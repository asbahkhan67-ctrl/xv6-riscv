#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"
#include "defs.h"

// Fetch the uint64 at addr from the current process.
int
fetchaddr(uint64 addr, uint64 *ip)
{
  struct proc *p = myproc();
  if (addr >= p->sz ||
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    return -1;
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    return -1;
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Returns length of string, not including nul, or -1 for error.
int
fetchstr(uint64 addr, char *buf, int max)
{
  struct proc *p = myproc();
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    return -1;
  return strlen(buf);
}

static uint64
argraw(int n)
{
  struct proc *p = myproc();
  switch (n) {
  case 0:
    return p->trapframe->a0;
  case 1:
    return p->trapframe->a1;
  case 2:
    return p->trapframe->a2;
  case 3:
    return p->trapframe->a3;
  case 4:
    return p->trapframe->a4;
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
  *ip = argraw(n);
}

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
  *ip = argraw(n);
}

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 for error.
int
argstr(int n, char *buf, int max)
{
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
}

// Prototypes for the functions that handle system calls.
extern uint64 sys_fork(void);
extern uint64 sys_exit(void);
extern uint64 sys_wait(void);
extern uint64 sys_pipe(void);
extern uint64 sys_read(void);
extern uint64 sys_kill(void);
extern uint64 sys_exec(void);
extern uint64 sys_fstat(void);
extern uint64 sys_chdir(void);
extern uint64 sys_dup(void);
extern uint64 sys_getpid(void);
extern uint64 sys_sbrk(void);
extern uint64 sys_pause(void);
extern uint64 sys_uptime(void);
extern uint64 sys_open(void);
extern uint64 sys_write(void);
extern uint64 sys_mknod(void);
extern uint64 sys_unlink(void);
extern uint64 sys_link(void);
extern uint64 sys_mkdir(void);
extern uint64 sys_close(void);
extern uint64 sys_sync(void);
extern uint64 sys_ps(void);
extern uint64 sys_setpriority(void);
extern uint64 sys_mmap(void);
extern uint64 sys_munmap(void);
extern uint64 sys_trace(void);
extern uint64 sys_sysinfo(void);
extern uint64 sys_getppid(void);
extern uint64 sys_ptree(void);
extern uint64 sys_getsyscallcount(void);
extern uint64 sys_waitx(void);
extern uint64 sys_halt(void);
extern uint64 sys_reboot(void);
extern uint64 sys_sched_yield(void);
extern uint64 sys_getcpuid(void);
extern uint64 sys_setprocname(void);
extern uint64 sys_getpriority(void);
extern uint64 sys_getcowfaults(void);
<<<<<<< HEAD
=======
extern uint64 sys_tracemode(void);
extern uint64 sys_setaging(void);
extern uint64 sys_syscallstats(void);
>>>>>>> e18456e (Updated xv6-riscv)

// An array mapping syscall numbers from syscall.h
// to the function that handles the system call.
static uint64 (*syscalls[])(void) = {
  // clang-format off
  [SYS_fork]            = sys_fork,
  [SYS_exit]            = sys_exit,
  [SYS_wait]            = sys_wait,
  [SYS_pipe]            = sys_pipe,
  [SYS_read]            = sys_read,
  [SYS_kill]            = sys_kill,
  [SYS_exec]            = sys_exec,
  [SYS_fstat]           = sys_fstat,
  [SYS_chdir]           = sys_chdir,
  [SYS_dup]             = sys_dup,
  [SYS_getpid]          = sys_getpid,
  [SYS_sbrk]            = sys_sbrk,
  [SYS_pause]           = sys_pause,
  [SYS_uptime]          = sys_uptime,
  [SYS_open]            = sys_open,
  [SYS_write]           = sys_write,
  [SYS_mknod]           = sys_mknod,
  [SYS_unlink]          = sys_unlink,
  [SYS_link]            = sys_link,
  [SYS_mkdir]           = sys_mkdir,
  [SYS_close]           = sys_close,
  [SYS_sync]            = sys_sync,
  [SYS_ps]              = sys_ps,
  [SYS_setpriority]     = sys_setpriority,
  [SYS_mmap]            = sys_mmap,
  [SYS_munmap]          = sys_munmap,
  [SYS_trace]           = sys_trace,
  [SYS_sysinfo]         = sys_sysinfo,
  [SYS_getppid]         = sys_getppid,
  [SYS_ptree]           = sys_ptree,
  [SYS_getsyscallcount] = sys_getsyscallcount,
  [SYS_waitx]           = sys_waitx,
  [SYS_halt]            = sys_halt,
  [SYS_reboot]          = sys_reboot,
  [SYS_sched_yield]     = sys_sched_yield,
  [SYS_getcpuid]        = sys_getcpuid,
  [SYS_setprocname]     = sys_setprocname,
  [SYS_getpriority]     = sys_getpriority,
  [SYS_getcowfaults]    = sys_getcowfaults,
<<<<<<< HEAD
=======
  [SYS_tracemode]       = sys_tracemode,
  [SYS_setaging]        = sys_setaging,
  [SYS_syscallstats]    = sys_syscallstats,
>>>>>>> e18456e (Updated xv6-riscv)
  // clang-format on
};

static char *syscall_names[] = {
  // clang-format off
  [SYS_fork]            = "fork",
  [SYS_exit]            = "exit",
  [SYS_wait]            = "wait",
  [SYS_pipe]            = "pipe",
  [SYS_read]            = "read",
  [SYS_kill]            = "kill",
  [SYS_exec]            = "exec",
  [SYS_fstat]           = "fstat",
  [SYS_chdir]           = "chdir",
  [SYS_dup]             = "dup",
  [SYS_getpid]          = "getpid",
  [SYS_sbrk]            = "sbrk",
  [SYS_pause]           = "pause",
  [SYS_uptime]          = "uptime",
  [SYS_open]            = "open",
  [SYS_write]           = "write",
  [SYS_mknod]           = "mknod",
  [SYS_unlink]          = "unlink",
  [SYS_link]            = "link",
  [SYS_mkdir]           = "mkdir",
  [SYS_close]           = "close",
  [SYS_sync]            = "sync",
  [SYS_ps]              = "ps",
  [SYS_setpriority]     = "setpriority",
  [SYS_mmap]            = "mmap",
  [SYS_munmap]          = "munmap",
  [SYS_trace]           = "trace",
  [SYS_sysinfo]         = "sysinfo",
  [SYS_getppid]         = "getppid",
  [SYS_ptree]           = "ptree",
  [SYS_getsyscallcount] = "getsyscallcount",
  [SYS_waitx]           = "waitx",
  [SYS_halt]            = "halt",
  [SYS_reboot]          = "reboot",
  [SYS_sched_yield]     = "sched_yield",
  [SYS_getcpuid]        = "getcpuid",
  [SYS_setprocname]     = "setprocname",
  [SYS_getpriority]     = "getpriority",
  [SYS_getcowfaults]    = "getcowfaults",
<<<<<<< HEAD
=======
  [SYS_tracemode]       = "tracemode",
  [SYS_setaging]        = "setaging",
  [SYS_syscallstats]    = "syscallstats",
>>>>>>> e18456e (Updated xv6-riscv)
  // clang-format on
};

// Convert an unsigned 32-bit integer to decimal in buf and return its length.
static int
sc_uint_to_str(uint32 val, char *buf)
{
  char tmp[16];
  int len = 0;

  do {
    tmp[len++] = '0' + (val % 10);
    val /= 10;
  } while (val > 0);

  for (int i = 0; i < len; i++)
    buf[i] = tmp[len - 1 - i];
  buf[len] = '\0';
  return len;
}

// Print a left-aligned string column padded with spaces (xv6 printk lacks %-Ns).
static void
sc_print_col(const char *s, int width)
{
  int len = strlen(s);

  printk("%s", (char *)s);
  if (len < width) {
    for (int i = len; i < width; i++)
      printk(" ");
  } else {
    printk(" ");
  }
}

// Print a left-aligned uint32 column padded with spaces.
static void
sc_print_u32_col(uint32 val, int width)
{
  char buf[16];

  sc_uint_to_str(val, buf);
  sc_print_col(buf, width);
}

// Sort active syscall indices descending by call frequency.
static int
collect_sorted_syscalls(const uint32 *freq, uint64 mask, int *order)
{
  int n = 0;

  for (int i = 1; i < NELEM(syscalls) && i < MAX_SYSCALLS; i++) {
    if (freq[i] > 0 && ((mask >> i) & 1ULL) && syscall_names[i])
      order[n++] = i;
  }

  for (int i = 0; i < n; i++) {
    int best = i;
    for (int j = i + 1; j < n; j++) {
      if (freq[order[j]] > freq[order[best]])
        best = j;
    }
    if (best != i) {
      int tmp = order[i];
      order[i] = order[best];
      order[best] = tmp;
    }
  }

  return n;
}

// Print a ranked syscall table from collected frequency and error arrays.
static void
print_ranked_syscall_table(const uint32 *freq, const uint32 *errs,
                           const int *order, int n, uint64 *total_errs_out)
{
  uint64 total_errs = 0;

  printk("SYSCALL           CALLS   ERRORS\n");
  printk("----------------  ------  ------\n");
  for (int k = 0; k < n; k++) {
    int id = order[k];
    total_errs += errs[id];
    sc_print_col(syscall_names[id], 18);
    sc_print_u32_col(freq[id], 8);
    printk("%u\n", errs[id]);
  }
  printk("--------------------------------\n");

  if (total_errs_out)
    *total_errs_out = total_errs;
}

// Print a strace -c summary table when a traced process exits.
void
print_trace_summary(struct proc *p)
{
  int order[MAX_SYSCALLS];
  int n = collect_sorted_syscalls(p->syscall_freq, p->trace_mask, order);
  uint64 total_calls = 0;
  uint64 total_errs = 0;

  for (int k = 0; k < n; k++)
    total_calls += p->syscall_freq[order[k]];

  printk("\n--- strace summary (PID %d: %s) ---\n", p->pid, p->name);
  print_ranked_syscall_table(p->syscall_freq, p->syscall_errs, order, n,
                             &total_errs);
  printk("Total syscalls: %lu | Total errors: %lu\n", total_calls, total_errs);
}

// Print per-syscall breakdown and top invoked syscalls for syscount -v [pid].
int
print_syscall_stats(int pid)
{
  int target_pid = 0;
  char name[16];
  uint64 total = 0;
  uint32 freq[MAX_SYSCALLS];
  uint32 errs[MAX_SYSCALLS];
  int order[MAX_SYSCALLS];

  if (getsyscall_snapshot(pid, &target_pid, name, &total, freq, errs) < 0)
    return -1;

  int n = collect_sorted_syscalls(freq, ~(uint64)0, order);

  printk("Process %d (%s) total syscalls: %lu\n", target_pid, name, total);
  if (n > 0) {
    int top = (n < 5) ? n : 5;
    printk("Top syscalls: ");
    for (int k = 0; k < top; k++) {
      int id = order[k];
      printk("%s (%u)", syscall_names[id], freq[id]);
      if (k + 1 < top)
        printk(", ");
    }
    printk("\n\n");
    print_ranked_syscall_table(freq, errs, order, n, 0);
  }

  return (int)total;
}

void
syscall(void)
{
  int num;
  struct proc *p = myproc();

  num = p->trapframe->a7;
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    p->syscall_count++;
    if (num < MAX_SYSCALLS)
      p->syscall_freq[num]++;

    // Dispatch system call handler and store return value in a0.
    uint64 ret = syscalls[num]();
    p->trapframe->a0 = ret;

    if ((long)ret < 0 && num < MAX_SYSCALLS)
      p->syscall_errs[num]++;

    // Live strace output (unless summary-only mode -c is active).
    if (((p->trace_mask >> num) & 1ULL) && !(p->trace_flags & TRACE_SUMMARY)) {
      if (!(p->trace_flags & TRACE_ERRORS) || (long)ret < 0) {
        printk("%d: syscall %s -> %ld\n",
               p->pid, syscall_names[num], (long)ret);
      }
    }
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    p->trapframe->a0 = -1;
  }
}
