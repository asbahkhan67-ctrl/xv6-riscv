# NexusXv6

### Extended xv6-RISC-V Kernel

NexusXv6 is an extended version of the MIT xv6-riscv teaching operating system. The project adds process scheduling, CPU-time accounting, copy-on-write memory management, and memory-mapped files while preserving the original xv6 architecture and interfaces wherever possible.

The implementation is designed for **RISC-V 64-bit** and can be built and executed using **QEMU** under **WSL2/Ubuntu**.

---

## Features

NexusXv6 implements five major kernel extensions:

1. **Process inspection with `ps`**
2. **Priority-based CPU scheduling**
3. **Per-process CPU-time accounting**
4. **Copy-on-Write (COW) memory management**
5. **Memory mapping with `mmap()` and `munmap()`**

All five extensions have been integrated into the xv6 kernel and tested using dedicated programs and the standard xv6 `usertests` suite.

---

## Project Structure

```text
NexusXv6/
├── kernel/
│   ├── proc.c
│   ├── proc.h
│   ├── syscall.c
│   ├── syscall.h
│   ├── sysproc.c
│   ├── trap.c
│   ├── vm.c
│   ├── kalloc.c
│   ├── riscv.h
│   ├── param.h
│   └── ...
│
├── user/
│   ├── ps.c
│   ├── setpriority.c
│   ├── cowtest.c
│   ├── mmaptest.c
│   └── ...
│
├── Makefile
├── README.md
└── USER_MANUAL.md
```

---

# 1. Process Inspection — `ps`

A new `ps` system call was added to display information about currently existing processes.

### Displayed information

```text
PID    PRIORITY    CPU-TICKS    STATE    NAME
```

The implementation exposes:

* Process ID
* Scheduling priority
* Accumulated CPU ticks
* Current process state
* Process name

### Kernel implementation

Relevant files:

```text
kernel/syscall.h
kernel/syscall.c
kernel/sysproc.c
kernel/proc.c
kernel/proc.h
```

User program:

```text
user/ps.c
```

The `ps` system call invokes the kernel's process-table display functionality.

### Example

```text
$ ps
PID     PRIORITY        CPU-TICKS       STATE       NAME
1       10              ...             SLEEPING    init
2       10              ...             RUNNING     sh
```

---

# 2. Priority-Based Scheduler

The default xv6 round-robin scheduling behavior was extended with a priority-based scheduler.

### Priority levels

```text
1   = highest priority
10  = default priority
20  = lowest priority
```

The scheduler searches for runnable processes and selects the runnable process with the numerically smallest priority value.

For example:

```text
Process A → priority 5
Process B → priority 10
Process C → priority 15
```

Process A is selected before B and C when all three are runnable.

### Default priority

Every newly allocated process receives:

```text
priority = 10
```

### Changing priority

A new system call was added:

```c
setpriority(pid, priority)
```

Valid priorities are:

```text
1 through 20
```

Example:

```text
$ setpriority 2 5
```

This changes process 2's priority to 5.

### Relevant files

```text
kernel/proc.h
kernel/proc.c
kernel/sysproc.c
kernel/syscall.c
kernel/syscall.h
user/setpriority.c
user/user.h
user/usys.pl
```

---

# 3. CPU-Time Accounting

NexusXv6 tracks the amount of timer-driven CPU time consumed by each process.

Each process contains:

```c
uint64 cpu_time;
```

The counter is initialized when the process is allocated and incremented during timer interrupts.

The value is displayed by `ps`.

### Example

```text
PID     PRIORITY    CPU-TICKS    STATE       NAME
2       10          37           RUNNING     sh
```

This makes it possible to observe how much CPU time different processes have consumed.

### Relevant files

```text
kernel/proc.h
kernel/proc.c
kernel/trap.c
kernel/sysproc.c
```

---

# 4. Copy-on-Write Fork

The memory subsystem was extended to support Copy-on-Write (COW) behavior during `fork()`.

Instead of immediately copying every writable physical page, parent and child initially share the same physical page.

Writable pages are converted to COW pages:

```text
Parent
  │
  └── shared physical page
          ▲
          │
       Child
```

The page is marked using the custom:

```c
#define PTE_COW (1L << 8)
```

and the normal writable bit is cleared.

### COW page fault

When either process attempts to write to a COW page:

1. A page fault occurs.
2. The kernel detects the `PTE_COW` flag.
3. The physical page reference count is checked.
4. If the page is still uniquely referenced, it can simply be made writable.
5. Otherwise, a new physical page is allocated.
6. The contents are copied to the new page.
7. The process receives a private writable copy.

### Reference counting

Physical pages now maintain reference counts.

The allocator provides:

```c
incref()
getref()
decref()
```

This prevents a shared physical page from being freed while another process still references it.

### `copyout()` support

Kernel-to-user memory copying was also updated so that a write into a COW page correctly triggers COW allocation instead of modifying the shared page.

### Relevant files

```text
kernel/kalloc.c
kernel/riscv.h
kernel/vm.c
kernel/trap.c
kernel/proc.c
kernel/defs.h
```

### Test program

```text
user/cowtest.c
```

Example behavior:

```text
Original: A
After child 1: A
After child 2: A
```

The children modify their own COW copies without changing the parent's original data.

---

# 5. Memory Mapping — `mmap()` / `munmap()`

NexusXv6 implements memory-mapped file support through:

```c
mmap()
munmap()
```

The interface supports:

```text
PROT_READ
PROT_WRITE

MAP_SHARED
MAP_PRIVATE
```

### Virtual Memory Areas

Each process contains an array of VMAs:

```c
#define NVMA 16
```

Each VMA records:

* Starting virtual address
* Mapping length
* Original requested length
* Protection flags
* Mapping type
* Associated file
* File offset
* Whether the VMA is active

### Lazy page allocation

Mapped pages are loaded lazily.

The initial `mmap()` call creates a VMA but does not immediately allocate physical memory for every page.

When the process accesses an unmapped page:

```text
User access
     │
     ▼
Page fault
     │
     ▼
mmapfault()
     │
     ├── allocate physical page
     ├── read file contents
     └── map page into process
```

This avoids allocating pages that the process never accesses.

### MAP_SHARED

For shared mappings, modified pages are written back to the underlying file when the mapping is unmapped.

### MAP_PRIVATE

Private mappings can be modified by the process without writing those modifications back to the original file.

### Fork support

VMAs are inherited across `fork()`.

The child receives its own VMA records while the underlying file references are duplicated using the xv6 file-reference mechanism.

### Process exit

Mapped regions are cleaned up automatically when a process exits.

### Relevant files

```text
kernel/proc.h
kernel/proc.c
kernel/sysproc.c
kernel/vm.c
kernel/trap.c
kernel/param.h
kernel/syscall.c
kernel/syscall.h
kernel/defs.h
```

### Test program

```text
user/mmaptest.c
```

The test verifies:

* Shared mapping
* Reading file contents through a mapping
* Modifying a shared mapping
* Write-back during `munmap()`
* Reopening the file
* Private mapping
* Modification of a private mapping

---

# System Calls Added

| System Call     | Number | Purpose                            |
| --------------- | -----: | ---------------------------------- |
| `ps()`          |     23 | Display process information        |
| `setpriority()` |     24 | Change process priority            |
| `mmap()`        |     25 | Create a memory-mapped file region |
| `munmap()`      |     26 | Remove a memory mapping            |

The existing xv6 system-call numbering was preserved, with the new calls added after the existing calls.

---

# Testing

NexusXv6 was tested using both dedicated feature tests and the standard xv6 test suite.

## `ps`

```text
$ ps
```

Verified process information including priority and CPU ticks.

## Priority scheduling

```text
$ setpriority <pid> <priority>
$ ps
```

Verified that the requested process priority changes correctly.

## Copy-on-Write

```text
$ cowtest
```

Verified that child processes can modify COW pages without modifying the parent's private data.

## Memory mapping

```text
$ mmaptest
```

Expected:

```text
mmaptest: starting
mmaptest: mapped address 0x0000003FFFFFD000
mmaptest: ALL TESTS PASSED
```

The exact mapped address may vary depending on the memory layout.

## Standard xv6 tests

```text
$ usertests
```

The complete xv6 `usertests` suite was executed successfully and reached:

```text
ALL TESTS PASSED
```

Some negative memory-management tests intentionally generate kernel messages such as:

```text
usertrap(): unexpected scause
```

before reporting `OK`. These messages are part of the expected behavior of those xv6 tests and do not indicate a failed test when the corresponding test completes with `OK`.

---

# Building

NexusXv6 requires:

* WSL2
* Ubuntu
* RISC-V cross compiler
* QEMU
* GNU Make
* Git

From the project directory:

```bash
cd ~/xv6-riscv
make clean
make
```

Then start xv6:

```bash
make qemu
```

You should see:

```text
xv6 kernel is booting

hart 1 starting
hart 2 starting
init: starting sh
$
```

For complete setup and testing instructions, see:

**[USER_MANUAL.md](USER_MANUAL.md)**

---

# Design Notes

The implementation intentionally keeps the extensions close to the existing xv6 architecture.

### Scheduling

Priority selection occurs inside the kernel scheduler rather than introducing a separate scheduling subsystem.

### CPU accounting

CPU usage is maintained as part of each process structure and updated from timer-interrupt handling.

### COW

COW is implemented at the page-table and physical-page allocator level using:

* PTE flags
* Physical-page reference counting
* Page-fault handling

### mmap

Memory mappings are represented using per-process VMAs and are populated on demand through page faults.

This keeps the implementation modular while integrating with xv6's existing virtual-memory, file-system, process, and trap mechanisms.

---

# Educational Purpose

NexusXv6 is an educational operating-system project based on the MIT xv6-riscv teaching operating system.

The purpose of the project is to explore kernel-level concepts including:

* Process scheduling
* System calls
* Interrupts and timer accounting
* Virtual memory
* Page faults
* Physical memory allocation
* Reference counting
* Copy-on-Write
* File-backed memory mappings
* Process and file lifetime management

---

## System Architecture

The following diagram provides a high-level view of NexusXv6 and illustrates how the five kernel extensions interact with the existing xv6 architecture. It shows the flow from user-space programs through the system-call and trap layers into process management, virtual memory, physical memory management, and the file system, down to the underlying RISC-V/QEMU environment.

<img width="1791" height="3321" alt="mermaid-diagram" src="https://github.com/user-attachments/assets/3840f5b5-5bac-4c8b-a26a-b397710d2fa4" />



# Documentation

* **[README.md](README.md)** — Project overview and implementation details
* **[USER_MANUAL.md](USER_MANUAL.md)** — Setup, commands, testing, and evaluator instructions
