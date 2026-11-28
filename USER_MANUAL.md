# NexusXv6 User Manual

## Extended xv6-RISC-V Kernel (20 Modules + Mini-Extensions)

### Group Members

| Member Name | Registration / Roll No. |
| :--- | :--- |
| **Muhammad Asbah Khan** | `BCS-F24-E01` |
| **Musfirah Chaudhry** | `BCS-F24-E31` |
| **Sahiba Bibi** | `BCS-F24-E14` |
| **Muhammad Shahbaz** | `BCS-F24-E13` |

This manual explains how to build, run, and verify all **20 kernel modules** and their **20 mini-extensions** implemented in **NexusXv6**. It is organized so evaluators and users can boot QEMU once and step through every feature in order without shutting down until the end.

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
cd /mnt/d/xv6-riscv   # or your cloned xv6-riscv directory
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

hart 1 starting
hart 2 starting
init: starting sh
$
```

The `$` prompt indicates the NexusXv6 shell is ready.

---

# 5. Test Module 1 — Process Inspection (`ps`)

Display all active processes in fixed-width aligned columns, including each process's live effective priority (`EFF`), user/kernel CPU split (`CPU (U/K)`), and memory footprint (`MEM-KB`):

```text
$ ps
```

Expected output:

```text
PID   PRIO  EFF   CPU (U/K)       MEM-KB  STATE   NAME
----  ----  ----  --------------  ------  ------  ----------------
1     10    10    0 (0/0)         16      sleep   init
2     10    10    0 (0/0)         20      sleep   sh
3     10    10    0 (0/0)         16      run     ps
------------------------------------------------------------------
Active processes: 3 | Total process memory: 52 KB | Aging: 10 ticks
```

---

# 6. Test Module 2 — Priority Scheduler (`setpriority` & `getpriority`)

Priorities range from `1` (**highest**) to `20` (**lowest**), with `10` as the default. You can query priorities without changing them, pass `0` to target the calling process itself, and set a new priority:

```text
$ setpriority 2
Process 2 current priority: 10

$ setpriority 0
Process 6 (self) current priority: 10

$ setpriority 2 5
Process 2 priority changed: 10 -> 5

$ ps
```

Verify PID `2` (`sh`) now shows `PRIO` `5` (and reset it back to `10` with `setpriority 2 10` if desired). Out-of-range priorities (such as `0` or `25`) fail safely:

```text
$ setpriority 2 25
setpriority: failed (priority must be between 1 and 20)
```

---

# 7. Test Module 3 — Per-Process CPU-Time Accounting (`cpuburn`)

Run a quick finite CPU workload (`cpuburn <rounds>`):

```text
$ cpuburn 2
[cpuburn] PID 8 running 2 busy rounds...
[cpuburn] PID 8 finished 2 rounds
```

Or run `cpuburn` in the background to watch its `CPU (U/K)` counter climb in `ps`, then stop it with `kill <pid>`:

```text
$ cpuburn &
[cpuburn] PID 9 started (stop with 'kill 9')

$ ps
PID   PRIO  EFF   CPU (U/K)       MEM-KB  STATE   NAME
----  ----  ----  --------------  ------  ------  ----------------
1     10    10    0 (0/0)         16      sleep   init
2     5     5     0 (0/0)         20      sleep   sh
11    10    10    0 (0/0)         16      run     ps
9     10    10    3 (3/0)         16      run     cpuburn
------------------------------------------------------------------
Active processes: 4 | Total process memory: 68 KB | Aging: 10 ticks

$ kill 9
```

---

# 8. Test Module 4 — Copy-on-Write Fork (`cowtest`)

```text
$ cowtest
```

Expected output:

```text
cowtest: starting Copy-on-Write verification
[Test 1] Child read 'S' -> new COW faults: 0 (page stayed shared)
[Test 2] Original: A
         Child 1 wrote 'B' -> new COW faults: 1
         After child 1: A (parent unchanged)
         Child 2 wrote 'C' -> new COW faults: 1
         After child 2: A (parent unchanged)
[Test 3] Kernel copyout wrote 'K' into child -> new COW faults: 1
         Parent still sees 'P' (protected from kernel copyout)
cowtest: ALL TESTS PASSED
```

Confirms shared pages incur `0` copies on read, copy privately on user writes (`cow_faults`), and remain protected during kernel `copyout()` writes.

---

# 9. Test Module 5 — Memory Mapping (`mmaptest`)

```text
$ mmaptest
```

Expected output:

```text
mmaptest: starting memory-mapping verification
[Test 1] MAP_SHARED mapped at 0x0000003FFFFFD000
         Edited 'hello' -> 'Hello' (saved to disk on munmap)
[Test 2] MAP_PRIVATE mapped at 0x0000003FFFFFD000
         Changed memory to 'Xello', disk still has 'Hello' (isolated)
[Test 3] MAP_ANONYMOUS (2 pages) mapped at 0x0000003FFFFFC000
         Verified 8 KB zero-filled memory without a disk file
mmaptest: ALL TESTS PASSED
```

Verifies demand-paged `MAP_SHARED` write-back on `munmap()`, isolated `MAP_PRIVATE` edits, and zero-filled `MAP_ANONYMOUS` mappings (`fd = -1`).

---

# 10. Test Module 6 — System Call Tracing (`strace`)

`strace` supports four modes:

* `-a` — trace all system calls
* `-e` — trace only failing system calls (`return < 0`)
* `-c` — collect counts silently and print a summary table on exit
* `<mask>` — trace specific syscalls matching a decimal bitmask (for example, `32` = `1 << SYS_read`)

```text
$ strace -a echo hello
$ strace 32 grep xv6 README
$ strace -e cat no_such_file
4: syscall open -> -1
cat: cannot open no_such_file

$ strace -c echo hello
hello

--- strace summary (PID 5: echo) ---
SYSCALL           CALLS   ERRORS
----------------  ------  ------
write             2       0
exec              1       0
exit              1       0
--------------------------------
Total syscalls: 4 | Total errors: 0
```

---

# 11. Test Module 7 — System Resource Diagnostics (`free`)

View RAM, shared Copy-on-Write pages, open system file handles, active processes, and uptime in kilobytes (`free`) or megabytes (`free -m`):

```text
$ free
Total memory:  128668 KB (32167 pages)
Used memory:   804 KB (201 pages, <1%)
Free memory:   127864 KB (31966 pages)
Shared COW:    0 pages | Open files: 1 / 100
Active procs:  3 / 64  | Uptime: 2 ticks

$ free -m
Total memory:  126 MB (32167 pages)
Used memory:   1 MB (201 pages, <1%)
Free memory:   125 MB (31966 pages)
Shared COW:    0 pages | Open files: 1 / 100
Active procs:  3 / 64  | Uptime: 3 ticks
```

---

# 12. Test Module 8 — Process Family Tree (`pstree`)

Display the full hierarchy (including each process's `kids=N` child count) or focus on one subtree (`pstree <pid>`):

```text
$ pstree
Current PID: 8 | Parent PID: 2
Process Hierarchy:
[1] init (prio=10, state=sleep, kids=1)
  |-- [2] sh (prio=10, state=sleep, kids=1)
    |-- [8] pstree (prio=10, state=run, kids=0)

$ pstree 2
Current PID: 9 | Parent PID: 2
Subtree Root PID: 2 (kids=1)
[2] sh (prio=10, state=sleep, kids=1)
  |-- [9] pstree (prio=10, state=run, kids=0)
```

---

# 13. Test Module 9 — Priority Aging / Starvation Prevention (`agetest`)

Run the anti-starvation stress test, and inspect or tune the aging threshold (`ticks` per boost) at runtime:

```text
$ agetest
agetest: starting priority aging verification
[Test 1] Runtime setaging() verified (current threshold: 10 ticks)
[Test 2] Starting 4 high-priority hogs (prio 3) and 1 low-priority worker (prio 20)
         Low-priority worker (PID 16, prio 20) completed without starvation
agetest: ALL TESTS PASSED

$ agetest get
Current aging threshold: 10 ticks

$ agetest set 5
Aging threshold changed: 10 -> 5 ticks
```

*(Reset to default anytime with `agetest set 10`.)*

---

# 14. Test Module 10 — Per-Process Syscall Accounting (`syscount`)

Run the self-test (no arguments), inspect a total count (`syscount <pid>`), or display the top syscalls and full ranked breakdown (`syscount -v [pid]`):

```text
$ syscount
PID 20 syscall count before 5x getpid(): 3
PID 20 syscall count after  5x getpid(): 9

$ syscount 2
Process 2 total syscalls: 231

$ syscount -v 2
Process 2 (sh) total syscalls: 231
Top syscalls: read (183), wait (15), fork (15), write (15), open (1)

SYSCALL           CALLS   ERRORS
----------------  ------  ------
read              183     0
wait              15      0
fork              15      0
write             15      0
open              1       0
exec              1       0
close             1       0
--------------------------------
```

---

# 15. Test Module 11 — Process Execution Benchmarking (`time`)

Benchmark any user command using `time <command> [args...]` to see elapsed ticks, CPU time & `CPU%`, wait time, context switches, and exit status:

```text
$ time cpuburn 2
[cpuburn] PID 4 running 2 busy rounds...
[cpuburn] PID 4 finished 2 rounds

--- Benchmark: cpuburn (PID 4) ---
Elapsed ticks:    3
CPU ticks:        3 (100% CPU)
Wait ticks:       0
Context switches: 8
Exit status:      0

$ time cowtest
```

---

# 16. Test Module 13 — Voluntary CPU Yielding (`yieldtest`)

```text
$ yieldtest
```

Expected output:

```text
yieldtest: starting cooperative CPU yield test
Worker A (PID 6): step 1 -> sched_yield() (voluntary yields = 1)
Worker B (PID 7): step 1 -> sched_yield() (voluntary yields = 1)
Worker A (PID 6): step 2 -> sched_yield() (voluntary yields = 2)
Worker B (PID 7): step 2 -> sched_yield() (voluntary yields = 2)
Worker A (PID 6): step 3 -> sched_yield() (voluntary yields = 3)
Worker B (PID 7): step 3 -> sched_yield() (voluntary yields = 3)
yieldtest: ALL TESTS PASSED (6 total voluntary yields verified)
```

---

# 17. Test Module 14 — Multi-Core HART Identification & Affinity (`cpuinfo`)

```text
$ cpuinfo
```

Expected output showing the online core bitmask (`0x7` for harts `0`, `1`, `2`), invalid-mask rejection, and per-hart `setaffinity()` pinning:

```text
Parent (PID 8) running on RISC-V hart 1 (online mask=0x7)
Worker 0 (PID 9, mask=0x1) executing on RISC-V hart 0
Worker 1 (PID 10, mask=0x2) executing on RISC-V hart 1
Worker 2 (PID 11, mask=0x4) executing on RISC-V hart 2
cpuinfo: ALL TESTS PASSED
```

---

# 18. Test Module 15 — Dynamic Process Naming & Lookup (`renametest` & `pidof`)

Verify `setprocname()`, `getprocname()`, and `findproc()` with `renametest` (optionally passing a custom name such as `renametest custom_daemon`), and search running PIDs from the shell with `pidof <name>`:

```text
$ renametest
renametest (PID 12): before setprocname()
PID   PRIO  EFF   CPU (U/K)       MEM-KB  STATE   NAME
----  ----  ----  --------------  ------  ------  ----------------
1     10    10    0 (0/0)         16      sleep   init
2     10    10    0 (0/0)         20      sleep   sh
12    10    10    0 (0/0)         16      run     renametest
------------------------------------------------------------------
Active processes: 3 | Total process memory: 52 KB | Aging: 10 ticks

renametest (PID 12): renamed to "nexus_worker" (verified via getprocname & findproc)
PID   PRIO  EFF   CPU (U/K)       MEM-KB  STATE   NAME
----  ----  ----  --------------  ------  ------  ----------------
1     10    10    0 (0/0)         16      sleep   init
2     10    10    0 (0/0)         20      sleep   sh
12    10    10    0 (0/0)         16      run     nexus_worker
------------------------------------------------------------------
Active processes: 3 | Total process memory: 52 KB | Aging: 10 ticks
renametest: ALL TESTS PASSED

$ pidof sh
PID(s) for 'sh': 2
```

---

# 19. Test Module 16 — Random-Access & Sparse File Positioning (`lseektest`)

Verify `SEEK_SET`, `SEEK_CUR`, `SEEK_END`, and sparse zero-fill when seeking past end-of-file before writing:

```text
$ lseektest
lseektest: starting random-access file positioning test
[Test 1] SEEK_SET offset 4 -> patched "WXYZ"
[Test 2] SEEK_CUR +4 (offset 12) -> read "CDEF"
[Test 3] SEEK_END -12 (offset 4) -> verified "WXYZ"
[Test 4] Sparse seek past EOF -> 8 zero-filled gap bytes + "END!" (size=28)
lseektest: ALL TESTS PASSED
```

---

# 20. Test Module 17 — Symbolic Links & `readlink` (`symlinktest`, `ln -s`, `ls`)

Run the automated symbolic link verification suite, then test creating and listing a symlink interactively:

```text
$ symlinktest
symlinktest: starting symbolic link verification
[Test 1] Chained symlink sym_link2 -> sym_link1 -> sym_target read "nexus-link"
[Test 2] readlink("sym_link1") = "sym_target" (O_NOFOLLOW type=T_SYMLINK)
[Test 3] Dangling symlink rejected cleanly
[Test 4] Symlink cycle caught cleanly (MAXSYMLINK guard)
symlinktest: ALL TESTS PASSED

$ ln -s README doclink
$ ls doclink
doclink -> README  4 45 6
```

*(Clean up the demo link afterward with `rm doclink` if desired.)*

---

# 21. Test Module 18 — User-Space Timer Alarms (`alarmtest`)

Verify periodic alarms, remaining-tick reporting when re-arming `sigalarm()`, and automatic disarmament under `SIGALARM_ONESHOT`:

```text
$ alarmtest
alarmtest: starting user-space timer alarm verification
[Test 1] Periodic alarm delivered 4 signals (remaining=1 ticks)
[Test 2] Previous alarm remaining ticks returned: 20 / 20
[Test 3] SIGALARM_ONESHOT fired exactly once and auto-disarmed
alarmtest: ALL TESTS PASSED
```

---

# 22. Test Module 19 — Descriptor Redirection & `O_CLOEXEC` (`dup2test`)

Verify targeted descriptor placement (`dup2`) with shared file offsets and automatic close-on-exec (`dup3` with `O_CLOEXEC`):

```text
$ dup2test
dup2test: starting descriptor redirection verification
[Test 1] dup2(fd, 10) shared offset verified ("ABCD")
[Test 2] dup3(fd, 11, O_CLOEXEC) automatically closed fd 11 on exec()
dup2test: ALL TESTS PASSED
```

---

# 23. Test Module 20 — Disk & Buffer Cache Diagnostics (`df`)

Inspect block and inode utilization (`df`), include buffer-cache hits/misses (`df -c`), and run the live create/unlink accounting self-test (`df -t`):

```text
$ df -c
Filesystem (ROOTDEV 1, block size 1024 B):
Total disk:   4000 KB (4000 blocks: 3953 data, 31 log)
Used disk:    1946 KB (1946 blocks, 48%)
Free disk:    2054 KB (2054 blocks)
Inodes:       45 used / 199 total (154 free, 22%)
Buffer cache: 749 hits / 225 misses (76% hit rate)

$ df -t
...
df: ALL TESTS PASSED
```

---

# 24. Run the xv6 Compatibility Suite (`usertests`)

Run the quick subset (~1 minute) or the full upstream xv6 regression suite:

```text
$ usertests -q
```

Or for the complete suite:

```text
$ usertests
```

Expected final line:

```text
ALL TESTS PASSED
```

> Note: Negative memory-protection tests intentionally print `usertrap(): unexpected scause ...` before reporting `OK`. This is expected xv6 test behavior.

---

# 25. Test Module 12 — Clean Power Management (`reboot` & `shutdown`)

To flush disk buffers (`sync()`) and restart NexusXv6 immediately inside QEMU (or pass `[seconds]` for a timed console countdown broadcast):

```text
$ reboot 2
Broadcast: NexusXv6 rebooting in 2 second(s)...
  rebooting in 2...
  rebooting in 1...
Flushing filesystems...
Rebooting NexusXv6...
```

*(Use `reboot` without arguments to restart immediately.)*

To cleanly flush disk buffers and power off QEMU back to your WSL terminal (without needing `Ctrl+A` then `X`):

```text
$ shutdown 1
Broadcast: NexusXv6 shutting down in 1 second(s)...
  shutting down in 1...
Flushing filesystems...
Shutting down NexusXv6...
System halting...
```

*(Use `shutdown` without arguments to power off immediately. Manual QEMU exit via `Ctrl+A`, then `X` also remains available at any time.)*

---

# 26. Complete Feature-to-Test Summary Table

| #  | Module                         | Core & Mini-Extension System Calls                                  | User Command / Flags / Test                  |
| -: | ------------------------------ | ------------------------------------------------------------------- | -------------------------------------------- |
|  1 | Process inspection             | `ps()` *(with `MEM-KB` & summary footer)*                           | `ps`                                         |
|  2 | Priority CPU scheduler         | `setpriority()`, `getpriority()` *(`pid = 0` self shortcut)*        | `setpriority`, `ps`                          |
|  3 | Per-process CPU accounting     | *(timer trap `user_ticks` / `kernel_ticks` split)*                  | `cpuburn [rounds]`, `ps`                     |
|  4 | Copy-on-Write (COW) fork       | `getcowfaults()` *(+ COW page faults & `copyout` protection)*       | `cowtest`                                    |
|  5 | Memory-mapped files            | `mmap()`, `munmap()` *(file-backed + `MAP_ANONYMOUS`)*              | `mmaptest`                                   |
|  6 | System call tracing            | `trace()`, `tracemode()` *(`-e` errors, `-c` summary table)*        | `strace [-a \| -e \| -c \| mask] <cmd>`      |
|  7 | System health & RAM diagnostics| `sysinfo()` *(shared COW pages & open file counts)*                 | `free`, `free -m`                            |
|  8 | Parent PID & process hierarchy | `getppid()`, `ptree()` *(subtree filter & `kids=N` badges)*         | `pstree [pid]`                               |
|  9 | Priority aging                 | `setaging()` *(runtime tuning + `EFF` column in `ps`)*              | `agetest`, `agetest get`, `agetest set <n>`  |
| 10 | Syscall counting & breakdown   | `getsyscallcount()`, `syscallstats()` *(ranked table & errors)*     | `syscount`, `syscount <pid>`, `syscount -v`  |
| 11 | Process benchmarking           | `waitx()` *(elapsed, `CPU%`, wait ticks, context switches)*         | `time <cmd> [args...]`                       |
| 12 | Clean power management         | `halt()`, `reboot()` *(after `sync()` + optional countdown)*        | `shutdown [sec]`, `reboot [sec]`             |
| 13 | Voluntary CPU yielding         | `sched_yield()` *(returns per-process `yield_count`)*               | `yieldtest`                                  |
| 14 | Multi-core HART & affinity     | `getcpuid()`, `setaffinity()` *(hart bitmask pinning)*              | `cpuinfo`                                    |
| 15 | Dynamic process naming         | `setprocname()`, `getprocname()`, `findproc()`                      | `renametest [name]`, `pidof <name>`          |
| 16 | Random-access file positioning | `lseek()` *(`SEEK_SET/CUR/END` + sparse EOF zero-fill)*             | `lseektest`                                  |
| 17 | Symbolic links (shortcuts)     | `symlink()`, `readlink()`, `open(..., O_NOFOLLOW)`                  | `symlinktest`, `ln -s`, `ls`                 |
| 18 | User-space timer alarms        | `sigalarm()`, `sigreturn()` *(`SIGALARM_ONESHOT` & remaining ticks)*| `alarmtest`                                  |
| 19 | Descriptor redirection         | `dup2()`, `dup3()` *(with `O_CLOEXEC` close-on-exec)*               | `dup2test`                                   |
| 20 | Disk & buffer cache metrics    | `statfs()` *(blocks, inodes, `bcache` hits/misses)*                 | `df`, `df -c`, `df -t`                       |
|  * | Full xv6 regression suite      | *(all baseline syscalls 1–22)*                                      | `usertests -q`, `usertests`                  |
