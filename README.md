# NexusXv6

### Extended xv6-RISC-V Kernel

NexusXv6 is an extended version of the MIT `xv6-riscv` teaching operating system. It expands the baseline kernel with **15 modular kernel extensions** spanning process inspection, priority scheduling with anti-starvation aging, CPU and system-call accounting, execution benchmarking, Copy-on-Write (COW) virtual memory, demand-paged file mappings, system-call tracing, system resource diagnostics, multi-core HART introspection, cooperative yielding, dynamic process naming, and MMIO-driven power management.

The implementation targets **64-bit RISC-V (`rv64gc`)** and runs on **QEMU (`virt` machine, SMP)** under **WSL2 / Ubuntu**.

---

## Features

NexusXv6 implements fifteen major kernel extensions:

1. **Process inspection with `ps`**
2. **Priority-based CPU scheduling**
3. **Per-process CPU-time accounting**
4. **Copy-on-Write (COW) memory management**
5. **Memory mapping with `mmap()` and `munmap()`**
6. **System call tracing with `trace()` and `strace`**
7. **System resource diagnostics with `sysinfo()` and `free`**
8. **Parent process inspection with `getppid()` and `pstree`**
9. **Priority aging for starvation prevention**
10. **Per-process system call accounting with `getsyscallcount()`**
11. **Process execution benchmarking with `waitx()` and `time`**
12. **Clean system power management with `halt()` and `reboot()`**
13. **Voluntary CPU yielding with `sched_yield()`**
14. **Multi-core HART identification with `getcpuid()`**
15. **Dynamic process naming with `setprocname()`**

All fifteen extensions preserve original xv6 interfaces and compatibility with the standard `usertests` suite.

---

## Project Structure

```text
NexusXv6/
├── kernel/
│   ├── proc.h          # Process, VMA, scheduling, accounting, and tracing fields
│   ├── proc.c          # Scheduler, aging, fork/exit, waitx, ps, pstree, syscount
│   ├── syscall.h       # System call numbers (1..37)
│   ├── syscall.c       # Syscall dispatch, counting, and live trace logging
│   ├── sysproc.c       # Process, memory, benchmark, CPU, and power syscalls
│   ├── sysinfo.h       # struct sysinfo definition shared with user space
│   ├── trap.c          # Timer tick accounting, COW faults, mmap faults
│   ├── vm.c            # Page tables, COW fork/faults, mmap demand paging, MMIO map
│   ├── kalloc.c        # Physical page allocator, COW refcounts, free RAM metrics
│   ├── memlayout.h     # Physical/virtual memory layout including VIRT_TEST MMIO
│   ├── riscv.h         # RISC-V CSRs and PTE flags (including PTE_COW)
│   ├── param.h         # Kernel parameters, AGING_THRESHOLD, mmap flags
│   └── defs.h          # Internal kernel function prototypes
│
├── user/
│   ├── ps.c            # Process table viewer
│   ├── setpriority.c   # Priority configuration utility
│   ├── cpuburn.c       # CPU-bound workload generator
│   ├── cowtest.c       # Copy-on-Write verification test
│   ├── mmaptest.c      # Shared/private mmap verification test
│   ├── strace.c        # Live system-call tracer command
│   ├── free.c          # Physical memory & process diagnostics utility
│   ├── pstree.c        # Parent PID & hierarchical process tree viewer
│   ├── agetest.c       # Anti-starvation priority aging verification test
│   ├── syscount.c      # Per-process system-call counter utility
│   ├── time.c          # Command execution benchmark utility (waitx)
│   ├── shutdown.c      # Clean system power-off command
│   ├── reboot.c        # Clean system restart command
│   ├── yieldtest.c     # Cooperative CPU yielding verification test
│   ├── cpuinfo.c       # Multi-core RISC-V HART inspection utility
│   ├── renametest.c    # Dynamic process renaming verification test
│   ├── user.h          # User-space system call & library declarations
│   └── usys.pl         # System call assembly stub generator
│
├── Makefile
├── README.md
└── USER_MANUAL.md
```

---

## System Architecture

The diagram below illustrates how user-space utilities interact with all fifteen NexusXv6 kernel extensions across the trap/syscall boundary down to RISC-V hardware and QEMU devices.

```mermaid
flowchart TD
    subgraph UserSpace["User Space Utilities & Tests"]
        U1["Process & Sched: ps, pstree, setpriority, agetest, yieldtest, renametest"]
        U2["Profiling & Trace: strace, syscount, time, cpuburn, cpuinfo"]
        U3["Memory & System: cowtest, mmaptest, free, shutdown, reboot"]
    end

    subgraph TrapSyscall["System Call & Trap Layer (syscall.c / trap.c)"]
        SC["syscall(): Dispatch (1..37), syscall_count++, trace_mask logger"]
        TR["usertrap() / kerneltrap(): Timer ticks, Page faults (scause 13/15)"]
    end

    subgraph KernelCore["NexusXv6 Kernel Subsystems"]
        PM["Process & Scheduler (proc.c): Priority 1..20, Aging, waitx, ptree, setprocname"]
        VM["Virtual Memory (vm.c): PTE_COW, cowalloc(), VMA table, mmapfault(), mmap_unmap()"]
        KA["Physical Allocator (kalloc.c): Freelist, incref/decref/getref, kfreemem()"]
        FS["File System (fs.c / file.c): Backing inodes, readi(),logged writei()"]
    end

    subgraph Hardware["RISC-V 64 SMP / QEMU virt Hardware"]
        CPU["RISC-V Harts (tp / hartid, CLINT Timer)"]
        MMIO["QEMU VIRT_TEST MMIO (0x100000: Poweroff / Reset) & VirtIO Disk"]
    end

    U1 --> SC
    U2 --> SC
    U3 --> SC
    U2 --> TR
    U3 --> TR

    SC --> PM
    SC --> VM
    SC --> KA
    TR --> PM
    TR --> VM

    VM --> KA
    VM --> FS
    PM --> CPU
    SC --> MMIO
    FS --> MMIO
```

---

# 1. Process Inspection — `ps`

A `ps()` system call (`SYS_ps = 23`) displays active entries in the kernel process table (`proc[NPROC]`).

```mermaid
sequenceDiagram
    participant U as "User (ps)"
    participant S as "syscall() / sys_ps()"
    participant P as "procdump() (proc.c)"
    participant C as "Console (printk)"

    U->>S: ecall (SYS_ps)
    S->>P: invoke procdump()
    loop For each p in proc[NPROC]
        P->>P: Skip UNUSED, read PID, priority, cpu_time, state, name
        P->>C: Format and output process row
    end
    S-->>U: return 0
```

### Displayed Information

```text
PID   PRIORITY   CPU-TICKS   STATE     NAME
1     10         2           sleep     init
2     10         5           sleep     sh
3     10         0           run       ps
```

### Relevant Files

* `kernel/syscall.h`, `kernel/syscall.c`, `kernel/sysproc.c`, `kernel/proc.c`, `user/ps.c`

---

# 2. Priority-Based Scheduler

The baseline round-robin scheduler is extended with priority levels from `1` (highest priority) to `20` (lowest priority), with default priority `10` assigned in `allocproc()`.

```mermaid
flowchart LR
    A["scheduler() Loop"] --> B["Scan proc[NPROC]"]
    B --> C{"p->state == RUNNABLE?"}
    C -- "No" --> B
    C -- "Yes" --> D["Compare priority (1 = highest, 20 = lowest)"]
    D --> E["Keep lock on best candidate"]
    E --> F["swtch() to best->context"]
    F --> G["Process runs until yield / sleep / exit"]
```

### Changing Priority

```text
$ setpriority 2 5
Process 2 priority set to 5
```

Values outside `1..20` are rejected with `-1` in `sys_setpriority()`.

### Relevant Files

* `kernel/proc.h`, `kernel/proc.c`, `kernel/sysproc.c`, `user/setpriority.c`

---

# 3. Per-Process CPU-Time Accounting

Each process maintains `uint64 cpu_time` in `struct proc`, initialized to `0` at allocation and incremented whenever a hardware timer interrupt (`which_dev == 2`) preempts the running process in `usertrap()` or `kerneltrap()`.

```mermaid
flowchart LR
    T["CLINT Timer Interrupt"] --> D["devintr() returns 2"]
    D --> U["usertrap() / kerneltrap()"]
    U --> I["p->cpu_time++"]
    I --> Y["yield()"]
    I -. "Read by" .-> PS["ps / waitx()"]
```

### Example

```text
$ cpuburn &
$ ps
PID   PRIORITY   CPU-TICKS   STATE     NAME
4     10         84          runble    cpuburn
```

### Relevant Files

* `kernel/proc.h`, `kernel/proc.c`, `kernel/trap.c`, `user/cpuburn.c`

---

# 4. Copy-on-Write (COW) Memory Management

During `fork()`, `uvmcopy()` avoids duplicating writable physical pages. Instead, parent and child map the same physical frame read-only with `PTE_COW` (`1L << 8`) and increment its reference count in `kalloc.c`.

```mermaid
flowchart TD
    F["fork() -> uvmcopy()"] --> S["Clear PTE_W, set PTE_COW, incref(pa)"]
    S --> W["Parent or Child writes to page"]
    W --> PF["Store Page Fault (scause == 15)"]
    PF --> CA["cowalloc(pagetable, stval)"]
    CA --> RC{"getref(pa) == 1?"}
    RC -- "Yes" --> RW["Restore PTE_W, clear PTE_COW in-place"]
    RC -- "No" --> CP["kalloc() new page, memmove(), map PTE_W, decref(old_pa)"]
```

### Key Mechanisms

* **Reference Counting (`kernel/kalloc.c`):** `incref()`, `getref()`, and `decref()` ensure shared frames are freed only when their reference count reaches `0`.
* **Kernel Writes (`copyout()`):** Checks `PTE_COW` and triggers `cowalloc()` before copying kernel data to user pages.

### Relevant Files

* `kernel/riscv.h`, `kernel/kalloc.c`, `kernel/vm.c`, `kernel/trap.c`, `user/cowtest.c`

---

# 5. Memory Mapping — `mmap()` and `munmap()`

NexusXv6 supports lazy file-backed virtual memory mappings via per-process Virtual Memory Areas (`struct vma vmas[NVMA]`, `NVMA = 16`) with `PROT_READ`, `PROT_WRITE`, `MAP_SHARED`, and `MAP_PRIVATE`.

```mermaid
flowchart TD
    M["sys_mmap()"] --> V["Allocate VMA below TRAPFRAME (no physical pages yet)"]
    V --> A["User reads/writes mapped VA"]
    A --> F["Page Fault (scause 13 or 15)"]
    F --> MF["mmapfault(): kalloc() + readi() from backing inode + mappages()"]
    MF --> U["sys_munmap() / kexit() -> mmap_cleanup()"]
    U --> SH{"MAP_SHARED?"}
    SH -- "Yes" --> WB["Write modified pages back via writei(), kfree(), clear PTE"]
    SH -- "No (MAP_PRIVATE)" --> PR["Discard private changes, kfree(), clear PTE"]
```

### Relevant Files

* `kernel/param.h`, `kernel/proc.h`, `kernel/proc.c`, `kernel/sysproc.c`, `kernel/vm.c`, `kernel/trap.c`, `user/mmaptest.c`

---

# 6. System Call Tracing — `trace()` and `strace`

Processes can enable selective or full system-call tracing via `trace(uint64 mask)` (`SYS_trace = 27`). Each process stores `uint64 trace_mask` in `struct proc`, which is inherited across `fork()` so child processes are traced seamlessly.

```mermaid
sequenceDiagram
    participant ST as "strace Utility"
    participant K as "syscall() (syscall.c)"
    participant H as "sys_<name>() Handler"
    participant C as "Console (printk)"

    ST->>K: trace(mask) sets p->trace_mask
    ST->>K: exec(target_cmd, argv)
    loop Every Syscall (num = a7)
        K->>H: a0 = syscalls[num]()
        H-->>K: return result
        alt (p->trace_mask >> num) & 1
            K->>C: print "<pid>: syscall <name> -> <ret>"
        end
    end
```

### Example

```text
$ strace -a echo hello
4: syscall exec -> 2
hello
4: syscall write -> 5
4: syscall write -> 1
```

### Relevant Files

* `kernel/proc.h`, `kernel/proc.c`, `kernel/syscall.h`, `kernel/syscall.c`, `kernel/sysproc.c`, `user/strace.c`

---

# 7. System Resource Diagnostics — `sysinfo()` and `free`

The `sysinfo(struct sysinfo *)` system call (`SYS_sysinfo = 28`) aggregates live kernel memory, process-table, and uptime metrics into a single user-space structure defined in `kernel/sysinfo.h`.

```mermaid
flowchart LR
    U["free Command"] --> S["sys_sysinfo()"]
    S --> K1["kfreemem() & ktotalmem() (kalloc.c)"]
    S --> K2["nproc_active() (proc.c)"]
    S --> K3["ticks (trap.c)"]
    K1 --> CO["copyout(struct sysinfo)"]
    K2 --> CO
    K3 --> CO
    CO --> U
```

### Example

```text
$ free
Total memory:  130940 KB (32735 pages)
Used memory:   324 KB (81 pages)
Free memory:   130616 KB (32654 pages)
Active procs:  3 / 64
System uptime: 42 ticks
```

### Relevant Files

* `kernel/sysinfo.h`, `kernel/kalloc.c`, `kernel/proc.c`, `kernel/sysproc.c`, `user/free.c`

---

# 8. Parent Process Inspection — `getppid()` and `pstree`

NexusXv6 adds `getppid()` (`SYS_getppid = 29`) to retrieve the calling process's parent PID under `wait_lock`, along with `ptree()` (`SYS_ptree = 30`) to snapshot the process table and render the parent-child hierarchy.

```mermaid
flowchart TD
    R["[1] init (ppid = 0)"] --> S["[2] sh (ppid = 1)"]
    S --> BG["[4] cpuburn (ppid = 2)"]
    S --> PT["[5] pstree (ppid = 2)"]
```

### Example

```text
$ pstree
Current PID: 5 | Parent PID: 2
Process Hierarchy:
[1] init (prio=10, state=sleep )
  |-- [2] sh (prio=10, state=sleep )
    |-- [5] pstree (prio=10, state=run   )
```

### Relevant Files

* `kernel/proc.c`, `kernel/sysproc.c`, `kernel/syscall.h`, `user/pstree.c`

---

# 9. Priority Aging for Starvation Prevention

Static priority scheduling can starve low-priority (`priority = 20`) processes when higher-priority CPU-bound tasks stay runnable. NexusXv6 prevents starvation using dynamic **priority aging** in `scheduler()`.

```mermaid
flowchart LR
    W["Process enters RUNNABLE (last_run_tick = ticks)"] --> C["waited = ticks - last_run_tick"]
    C --> B["boost = waited / AGING_THRESHOLD (10 ticks)"]
    B --> E["eff_prio = max(1, priority - boost)"]
    E --> D["Scheduler picks lowest eff_prio (tie-break: longest waited)"]
    D --> R["After swtch(): reset last_run_tick = ticks"]
```

### Key Properties

* **Base priority preserved:** `p->priority` remains unchanged (`ps` still shows the user-configured priority), while `eff_prio` improves the longer a process waits in `RUNNABLE`.
* **Verified under full SMP load:** `agetest` saturates all CPU harts with `priority = 3` hogs and verifies that a `priority = 20` worker still completes.

### Relevant Files

* `kernel/param.h`, `kernel/proc.h`, `kernel/proc.c`, `user/agetest.c`

---

# 10. Per-Process System Call Accounting — `getsyscallcount()`

Every valid system call increments `p->syscall_count` in `syscall()`. User space can query its own count (`getsyscallcount(0)`) or inspect another process by PID (`getsyscallcount(pid)` via `SYS_getsyscallcount = 31`).

```mermaid
flowchart LR
    A["User invokes any syscall"] --> B["syscall() in kernel/syscall.c"]
    B --> C["p->syscall_count++"]
    C --> D["Execute handler"]
    Q["syscount [pid]"] --> G["sys_getsyscallcount(pid)"]
    G -. "Reads" .-> C
```

### Example

```text
$ syscount 2
Process 2 total syscalls: 28
```

### Relevant Files

* `kernel/proc.h`, `kernel/proc.c`, `kernel/syscall.c`, `kernel/sysproc.c`, `user/syscount.c`

---

# 11. Process Execution Benchmarking — `waitx()` and `time`

Each process records its creation tick (`p->ctime = ticks`) in `allocproc()`. The `waitx(&status, &wtime, &rtime)` system call (`SYS_waitx = 32`) reaps an exited child while reporting both **active CPU ticks (`rtime`)** and **non-running wait/sleep ticks (`wtime`)**.

```mermaid
sequenceDiagram
    participant T as "time Utility"
    participant C as "Child Command"
    participant K as "Kernel (allocproc / trap / kwaitx)"

    T->>K: fork() -> sets child ctime = ticks
    C->>K: exec(cmd) & runs (accumulates cpu_time)
    C->>K: exit(status) -> ZOMBIE
    T->>K: waitx(&status, &wtime, &rtime)
    K->>K: rtime = cpu_time, wtime = (ticks - ctime) - rtime
    K-->>T: Return child PID + metrics
```

### Example

```text
$ time cowtest
Original: A
After child 1: A
After child 2: A
--- Benchmark: cowtest (PID 6) ---
Elapsed ticks: 3
CPU ticks:     1
Wait ticks:    2
Exit status:   0
```

### Relevant Files

* `kernel/proc.h`, `kernel/proc.c`, `kernel/sysproc.c`, `user/time.c`

---

# 12. Clean System Power Management — `halt()` and `reboot()`

NexusXv6 maps QEMU's SiFive test/power finisher MMIO register (`VIRT_TEST = 0x100000L`) into the kernel page table during `kvmmake()`. Two system calls—`halt()` (`SYS_halt = 33`) and `reboot()` (`SYS_reboot = 34`)—flush filesystem state via `sync()` in user space and signal QEMU cleanly.

```mermaid
flowchart LR
    SH["shutdown / reboot Command"] --> SY["sync() flushes FS log"]
    SY --> SC["sys_halt() / sys_reboot()"]
    SC --> MM["Write 0x5555 (halt) or 0x7777 (reset) to VIRT_TEST (0x100000)"]
    MM --> QM["QEMU virt Machine Powers Off or Restarts"]
```

### Example

```text
$ shutdown
Shutting down NexusXv6...
System halting...
```

### Relevant Files

* `kernel/memlayout.h`, `kernel/vm.c`, `kernel/sysproc.c`, `user/shutdown.c`, `user/reboot.c`

---

# 13. Voluntary CPU Yielding — `sched_yield()`

The `sched_yield()` system call (`SYS_sched_yield = 35`) exposes the kernel's `yield()` mechanism to user space, allowing cooperative processes to voluntarily transition from `RUNNING` to `RUNNABLE` without waiting for timer expiration.

```mermaid
stateDiagram-v2
    [*] --> RUNNING : Selected by scheduler()
    RUNNING --> RUNNABLE : User calls sched_yield()
    RUNNABLE --> RUNNING : Next scheduling turn
    RUNNING --> [*] : exit()
```

### Example

```text
$ yieldtest
yieldtest: starting cooperative CPU yield test
Worker A (PID 4): step 1 -> sched_yield()
Worker B (PID 5): step 1 -> sched_yield()
...
yieldtest: ALL TESTS PASSED
```

### Relevant Files

* `kernel/sysproc.c`, `kernel/proc.c`, `user/yieldtest.c`

---

# 14. Multi-Core HART Identification — `getcpuid()`

QEMU boots NexusXv6 as a symmetric multiprocessor (`CPUS = 3` by default: `hart 0`, `hart 1`, `hart 2`). `getcpuid()` (`SYS_getcpuid = 36`) disables interrupts via `push_off()`, reads the RISC-V `tp` register through `cpuid()`, re-enables interrupts via `pop_off()`, and returns the executing hardware thread ID.

```mermaid
flowchart LR
    U["cpuinfo Worker"] --> S["sys_getcpuid()"]
    S --> P1["push_off() (disable interrupts)"]
    P1 --> TP["cpuid() reads RISC-V tp register"]
    TP --> P2["pop_off() (restore interrupts)"]
    P2 --> R["Return Hart ID (0, 1, or 2)"]
```

### Example

```text
$ cpuinfo
Parent (PID 4) running on RISC-V hart 0
Worker 0 (PID 5) executing on RISC-V hart 1
Worker 1 (PID 6) executing on RISC-V hart 2
Worker 2 (PID 7) executing on RISC-V hart 0
```

### Relevant Files

* `kernel/sysproc.c`, `kernel/proc.c`, `user/cpuinfo.c`

---

# 15. Dynamic Process Naming — `setprocname()`

The `setprocname(const char *name)` system call (`SYS_setprocname = 37`) safely copies a non-empty user string into `p->name` under `p->lock`, enabling worker processes and daemons to update their descriptive names dynamically at runtime.

```mermaid
flowchart LR
    U["renametest / Worker"] --> A["sys_setprocname(name)"]
    A --> V["argstr() copies & validates non-empty string"]
    V --> L["acquire(&p->lock) -> safestrcpy(p->name) -> release(&p->lock)"]
    L --> PS["Updated name visible in ps & pstree"]
```

### Example

```text
$ renametest
renametest (PID 5): before setprocname()
...
5   10   0   run   renametest

renametest (PID 5): after setprocname("nexus_worker")
...
5   10   0   run   nexus_worker
renametest: ALL TESTS PASSED
```

### Relevant Files

* `kernel/sysproc.c`, `kernel/proc.h`, `user/renametest.c`

---

# System Calls Added

| System Call         | Number | Purpose                                           |
| ------------------- | -----: | ------------------------------------------------- |
| `ps()`              |     23 | Display process table information                 |
| `setpriority()`     |     24 | Change process scheduling priority (`1..20`)      |
| `mmap()`            |     25 | Create a lazy file-backed memory mapping          |
| `munmap()`          |     26 | Unmap a memory-mapped region                      |
| `trace()`           |     27 | Configure per-process system-call trace bitmask   |
| `sysinfo()`         |     28 | Query free/total RAM, active processes, & uptime  |
| `getppid()`         |     29 | Return parent process ID                          |
| `ptree()`           |     30 | Display hierarchical parent-child process tree    |
| `getsyscallcount()` |     31 | Return per-process invoked system-call count      |
| `waitx()`           |     32 | Reap child and return wait ticks & CPU ticks      |
| `halt()`            |     33 | Cleanly power off the QEMU RISC-V machine         |
| `reboot()`          |     34 | Cleanly restart the QEMU RISC-V machine           |
| `sched_yield()`     |     35 | Voluntarily yield the current CPU time slice      |
| `getcpuid()`        |     36 | Return executing RISC-V hardware thread (hart) ID |
| `setprocname()`     |     37 | Dynamically rename the calling process            |

---

# Building & Running

NexusXv6 requires **WSL2 (Ubuntu)** with `build-essential`, `gcc-riscv64-unknown-elf`, `qemu-system-riscv`, and `bc`:

```bash
cd /mnt/c/Kernel/xv6-riscv
make clean
make
make qemu
```

Inside the xv6 shell (`$`):

```text
$ ps
$ pstree
$ free
$ setpriority 2 5
$ agetest
$ cowtest
$ mmaptest
$ strace -a echo hello
$ syscount
$ time cowtest
$ yieldtest
$ cpuinfo
$ renametest
$ usertests
$ shutdown
```

For step-by-step evaluator instructions and expected outputs for every module, see **[USER_MANUAL.md](USER_MANUAL.md)**.

---

# Documentation

* **[README.md](README.md)** — Architecture, diagrams, and implementation details for all 15 extensions
* **[USER_MANUAL.md](USER_MANUAL.md)** — Step-by-step build, command reference, and evaluation guide
