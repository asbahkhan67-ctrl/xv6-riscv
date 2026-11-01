# NexusXv6 User Manual

## Extended xv6-RISC-V Kernel (15 Extensions)

This manual explains how to build, run, and verify all **15 kernel extensions** implemented in **NexusXv6**. It is designed as a step-by-step guide for evaluators and users.

---

# 1. Requirements

NexusXv6 runs on **Windows + WSL2 (Ubuntu)** with QEMU and the 64-bit RISC-V GCC toolchain:

```bash
sudo apt update
sudo apt install -y build-essential gcc-riscv64-unknown-elf qemu-system-misc qemu-system-riscv bc gdb-multiarch perl
```

Required tools:

* `make` & `gcc`
* `perl`
* `riscv64-unknown-elf-gcc`
* `qemu-system-riscv64` (version >= 7.2)

---

# 2. Open the Project

Open your **WSL2 Ubuntu** terminal and navigate to the repository:

```bash
cd /mnt/c/Kernel/xv6-riscv
```

Verify the directory contents:

```bash
ls
```

Expected items include `kernel`, `user`, `mkfs`, `Makefile`, `README.md`, and `USER_MANUAL.md`.

---

# 3. Build the Kernel & File System Image

Clean previous build artifacts and compile everything:

```bash
make clean
make
```

> Note: A linker warning `kernel/kernel has a LOAD segment with RWX permissions` is normal for xv6 builds and safe to ignore.

---

# 4. Boot NexusXv6 in QEMU

Start the multi-core RISC-V virtual machine:

```bash
make qemu
```

Expected boot sequence:

```text
xv6 kernel is booting

hart 2 starting
hart 1 starting
init: starting sh
$
```

The `$` prompt indicates the NexusXv6 shell is ready.

---

# 5. Test Module 1 — Process Inspection (`ps`)

```text
$ ps
```

Expected output columns:

```text
PID   PRIORITY   CPU-TICKS   STATE     NAME
1     10         ...         sleep     init
2     10         ...         sleep     sh
3     10         ...         run       ps
```

---

# 6. Test Module 2 — Priority-Based Scheduler (`setpriority`)

Check your shell's PID (typically `2`) and update its priority (`1` = highest, `10` = default, `20` = lowest):

```text
$ setpriority 2 5
Process 2 priority set to 5
$ ps
```

Verify PID `2` now displays priority `5`. Out-of-range priorities (e.g., `0` or `25`) fail safely:

```text
$ setpriority 2 25
setpriority: failed
```

---

# 7. Test Module 3 — Per-Process CPU-Time Accounting (`cpuburn`)

Start a background CPU-bound worker and observe its `CPU-TICKS` increase:

```text
$ cpuburn &
$ ps
$ ps
```

Stop the background process using `kill <pid>` once verified.

---

# 8. Test Module 4 — Copy-on-Write Fork (`cowtest`)

```text
$ cowtest
```

Expected output:

```text
Original: A
After child 1: A
After child 2: A
```

Confirms child processes write to private COW copies without mutating the parent's shared page.

---

# 9. Test Module 5 — Memory Mapping (`mmaptest`)

```text
$ mmaptest
```

Expected output:

```text
mmaptest: starting
mmaptest: mapped address 0x0000003FFFFFD000
mmaptest: ALL TESTS PASSED
```

Verifies demand-paged `MAP_SHARED` read/modify/write-back on `munmap()` and isolated `MAP_PRIVATE` modifications.

---

# 10. Test Module 6 — System Call Tracing (`strace`)

Trace all system calls made by a command with `-a`:

```text
$ strace -a echo hello
```

Or pass a specific bitmask (for example, `32` = `1 << SYS_read` to trace `read()` calls only):

```text
$ strace 32 grep xv6 README
```

Expected output prints `<pid>: syscall <name> -> <return_value>` for each matching system call.

---

# 11. Test Module 7 — System Resource Diagnostics (`free`)

```text
$ free
```

Expected output:

```text
Total memory:  ... KB (... pages)
Used memory:   ... KB (... pages)
Free memory:   ... KB (... pages)
Active procs:  3 / 64
System uptime: ... ticks
```

---

# 12. Test Module 8 — Parent PID & Process Hierarchy (`pstree`)

```text
$ pstree
```

Expected output:

```text
Current PID: 8 | Parent PID: 2
Process Hierarchy:
[1] init (prio=10, state=sleep )
  |-- [2] sh (prio=5, state=sleep )
    |-- [8] pstree (prio=10, state=run   )
```

---

# 13. Test Module 9 — Priority Aging / Starvation Prevention (`agetest`)

```text
$ agetest
```

Expected output:

```text
agetest: starting 4 high-priority hogs (prio 3) and 1 low-priority worker (prio 20)
agetest: low-priority worker (PID ..., prio 20) completed without starvation
agetest: ALL TESTS PASSED
```

Verifies that dynamic priority aging boosts long-waiting `RUNNABLE` processes even when all CPU cores are saturated by high-priority tasks.

---

# 14. Test Module 10 — Per-Process Syscall Accounting (`syscount`)

Run the self-check (no arguments) or inspect a specific process ID (such as PID `2` for `sh`):

```text
$ syscount
PID 15 syscall count before 5x getpid(): 1
PID 15 syscall count after  5x getpid(): 7

$ syscount 2
Process 2 total syscalls: ...
```

---

# 15. Test Module 11 — Process Execution Benchmarking (`time`)

Benchmark any user command using `time <command> [args...]`:

```text
$ time cowtest
$ time mmaptest
```

Expected benchmark summary at completion:

```text
--- Benchmark: cowtest (PID ...) ---
Elapsed ticks: ...
CPU ticks:     ...
Wait ticks:    ...
Exit status:   0
```

---

# 16. Test Module 13 — Voluntary CPU Yielding (`yieldtest`)

```text
$ yieldtest
```

Expected output:

```text
yieldtest: starting cooperative CPU yield test
Worker A (PID ...): step 1 -> sched_yield()
Worker B (PID ...): step 1 -> sched_yield()
...
yieldtest: ALL TESTS PASSED
```

---

# 17. Test Module 14 — Multi-Core HART Identification (`cpuinfo`)

```text
$ cpuinfo
```

Expected output showing execution across QEMU's SMP RISC-V harts (`0`, `1`, `2`):

```text
Parent (PID ...) running on RISC-V hart ...
Worker 0 (PID ...) executing on RISC-V hart ...
Worker 1 (PID ...) executing on RISC-V hart ...
Worker 2 (PID ...) executing on RISC-V hart ...
```

---

# 18. Test Module 15 — Dynamic Process Naming (`renametest`)

```text
$ renametest
```

Or specify a custom name:

```text
$ renametest custom_daemon
```

Expected output shows `ps` before and after `setprocname()`, ending with:

```text
renametest: ALL TESTS PASSED
```

---

# 19. Run the Complete xv6 Compatibility Suite (`usertests`)

```text
$ usertests
```

Expected final line:

```text
ALL TESTS PASSED
```

> Note: Negative memory-protection tests intentionally print `usertrap(): unexpected scause ...` before reporting `OK`. This is expected xv6 test behavior.

---

# 20. Test Module 12 — Clean Power Management (`reboot` & `shutdown`)

To cleanly restart NexusXv6 inside QEMU:

```text
$ reboot
```

NexusXv6 flushes disk buffers (`sync()`) and resets the QEMU `virt` machine back to boot.

To cleanly power off NexusXv6 and return to your WSL terminal (without needing `Ctrl+A` then `X`):

```text
$ shutdown
```

Expected output:

```text
Shutting down NexusXv6...
System halting...
```

*(Manual QEMU exit via `Ctrl+A`, then `X` also remains available at any time.)*

---

# 21. Feature-to-Test Summary Table

| #  | Extension                          | System Call(s)          | User Command / Test   |
| -: | ---------------------------------- | ----------------------- | --------------------- |
|  1 | Process inspection                 | `ps()`                  | `ps`                  |
|  2 | Priority-based CPU scheduler       | `setpriority()`         | `setpriority` + `ps`  |
|  3 | Per-process CPU-time accounting    | *(timer trap)*          | `cpuburn` + `ps`      |
|  4 | Copy-on-Write (COW) fork           | *(page fault)*          | `cowtest`             |
|  5 | Memory-mapped files                | `mmap()`, `munmap()`    | `mmaptest`            |
|  6 | System call tracing                | `trace()`               | `strace`              |
|  7 | System resource diagnostics        | `sysinfo()`             | `free`                |
|  8 | Parent PID & process tree          | `getppid()`, `ptree()`  | `pstree`              |
|  9 | Priority aging (anti-starvation)   | *(scheduler aging)*     | `agetest`             |
| 10 | Per-process syscall accounting     | `getsyscallcount()`     | `syscount`            |
| 11 | Process execution benchmarking     | `waitx()`               | `time <cmd>`          |
| 12 | Clean system power management      | `halt()`, `reboot()`    | `shutdown`, `reboot`  |
| 13 | Voluntary CPU yielding             | `sched_yield()`         | `yieldtest`           |
| 14 | Multi-core HART identification     | `getcpuid()`            | `cpuinfo`             |
| 15 | Dynamic process naming             | `setprocname()`         | `renametest`          |
|  * | Full xv6 regression suite          | *(all baseline calls)*  | `usertests`           |
