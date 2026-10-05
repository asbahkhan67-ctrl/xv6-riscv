# NexusXv6 User Manual

## Extended xv6-RISC-V Kernel

This manual explains how to build, run, and test **NexusXv6**.

It is intended for an evaluator who wants to verify the implemented kernel extensions without needing to inspect the source code first.

---

# 1. Requirements

NexusXv6 is designed to run in:

* Windows
* WSL2
* Ubuntu
* QEMU
* RISC-V 64-bit cross-compilation environment

The following tools should be installed:

```text
git
make
gcc
QEMU
riscv64-unknown-elf-gcc
```

---

# 2. Open the Project

Start Ubuntu through WSL2.

Go to the project directory:

```bash
cd ~/xv6-riscv
```

Check that the project is present:

```bash
ls
```

You should see files/directories similar to:

```text
kernel
user
Makefile
README.md
USER_MANUAL.md
```

---

# 3. Build the Kernel

Before building, clean any previous build:

```bash
make clean
```

Then compile:

```bash
make
```

A linker warning similar to the following may appear:

```text
riscv64-unknown-elf-ld: warning: kernel/kernel has a LOAD segment with RWX permissions
```

This warning is expected for the xv6 build and does not prevent the kernel from running.

---

# 4. Start NexusXv6

Run:

```bash
make qemu
```

A successful boot should end with something similar to:

```text
xv6 kernel is booting

hart 2 starting
hart 1 starting
init: starting sh
$
```

The `$` prompt means the xv6 shell is ready.

---

# 5. Test `ps`

At the xv6 shell:

```text
$ ps
```

The command displays process information.

Expected columns:

```text
PID     PRIORITY    CPU-TICKS    STATE     NAME
```

The exact values depend on the processes currently running.

The important things to verify are that:

* The command executes successfully.
* Processes are listed.
* A priority value is displayed.
* CPU tick information is displayed.
* Process state and name are displayed.

---

# 6. Test Priority Scheduling

First display the current processes:

```text
$ ps
```

Find the PID of the shell.

For example:

```text
PID     PRIORITY    CPU-TICKS    STATE     NAME
2       10          ...          RUNNING   sh
```

Change its priority:

```text
$ setpriority 2 5
```

Then run:

```text
$ ps
```

The shell should now show:

```text
PID     PRIORITY    CPU-TICKS    STATE     NAME
2       5           ...          RUNNING   sh
```

Priority values supported by NexusXv6 are:

```text
1 = highest
10 = default
20 = lowest
```

Invalid values outside the range `1–20` are rejected.

---

# 7. Observe CPU-Time Accounting

Run:

```text
$ ps
```

Record the CPU tick value of a process.

Run another command and then execute:

```text
$ ps
```

The CPU tick counters can change as processes receive timer-driven CPU time.

The CPU counter is maintained independently for each process.

---

# 8. Test Copy-on-Write

Run:

```text
$ cowtest
```

The test creates memory, forks children, and modifies the memory from the child processes.

Expected output:

```text
Original: A
After child 1: A
After child 2: A
```

The important result is that the parent's value remains `A` even though the children modify their own copies.

This verifies that:

* Parent and child initially share physical memory.
* Writable pages are converted to COW pages during `fork()`.
* A write causes a COW page fault.
* A private physical page is created when necessary.
* The parent's data remains unchanged.

---

# 9. Test Memory Mapping

Run:

```text
$ mmaptest
```

Expected output:

```text
mmaptest: starting
mmaptest: mapped address 0x0000003FFFFFD000
mmaptest: ALL TESTS PASSED
```

The exact virtual address may differ depending on the memory layout.

The test verifies:

1. Creating a file.
2. Writing initial contents to the file.
3. Creating a `MAP_SHARED` mapping.
4. Reading file contents through the mapping.
5. Modifying the mapped memory.
6. Calling `munmap()`.
7. Verifying that the modification was written back to the file.
8. Creating a `MAP_PRIVATE` mapping.
9. Modifying the private mapping.
10. Removing the mapping.

---

# 10. Run the Complete xv6 Test Suite

Run:

```text
$ usertests
```

The complete test suite should eventually report:

```text
ALL TESTS PASSED
```

Individual tests normally appear with:

```text
OK
```

For example:

```text
test ...
...
OK
```

Some xv6 memory-management tests intentionally trigger page faults and invalid accesses. Therefore, messages such as:

```text
usertrap(): unexpected scause
```

may appear during tests such as memory-protection or invalid-access tests.

This is not necessarily a failure.

The important result is that the corresponding test continues and reports:

```text
OK
```

and that the complete suite reaches:

```text
ALL TESTS PASSED
```

---

# 11. Quick Evaluation Checklist

An evaluator can verify the project with the following sequence:

```text
$ make clean
$ make
$ make qemu
```

Then inside xv6:

```text
$ ps
$ setpriority <pid> 5
$ ps
$ cowtest
$ mmaptest
$ usertests
```

Expected final result:

```text
ALL TESTS PASSED
```

---

# 12. Feature-to-Test Mapping

| Feature                      | Test                 |
| ---------------------------- | -------------------- |
| Process information          | `ps`                 |
| Priority scheduling          | `setpriority` + `ps` |
| CPU-time accounting          | `ps`                 |
| Copy-on-Write                | `cowtest`            |
| `mmap()`                     | `mmaptest`           |
| `munmap()`                   | `mmaptest`           |
| General kernel compatibility | `usertests`          |

---

# 13. Important Source Files

The main implementation files are:

```text
kernel/proc.h
kernel/proc.c
kernel/sysproc.c
kernel/syscall.h
kernel/syscall.c
kernel/trap.c
kernel/vm.c
kernel/kalloc.c
kernel/riscv.h
kernel/param.h
kernel/defs.h
```

User-space test and command programs include:

```text
user/ps.c
user/setpriority.c
user/cowtest.c
user/mmaptest.c
```

---

# 14. Stopping QEMU

To exit the QEMU session, use the QEMU escape sequence:

```text
Ctrl-A
```

then:

```text
X
```

That is:

```text
Ctrl+A, then X
```

You should return to the WSL terminal.

---

# 15. Troubleshooting

## `make: command not found`

Install the required build tools:

```bash
sudo apt update
sudo apt install build-essential
```

---

## `qemu-system-riscv64: command not found`

Install QEMU:

```bash
sudo apt install qemu-system-misc
```

---

## RISC-V compiler not found

Check:

```bash
riscv64-unknown-elf-gcc --version
```

If it is unavailable, install the appropriate RISC-V cross-compiler package for the Ubuntu environment.

---

## Build errors after changing source files

Run:

```bash
make clean
make
```

Then start QEMU again:

```bash
make qemu
```

---

# 16. Successful Verification

NexusXv6 has been verified using:

```text
ps
setpriority
cowtest
mmaptest
usertests
```

The dedicated `mmaptest` completed with:

```text
mmaptest: ALL TESTS PASSED
```

The complete xv6 `usertests` suite completed with:

```text
ALL TESTS PASSED
```

This provides a reproducible procedure for evaluating the five kernel extensions implemented in NexusXv6.
