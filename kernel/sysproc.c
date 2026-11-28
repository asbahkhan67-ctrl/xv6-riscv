#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "proc.h"
#include "fs.h"
#include "file.h"
#include "sysinfo.h"
#include "vm.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if (t == SBRK_EAGER || n < 0) {
    if (growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
      return -1;
    if (addr + n > TRAPFRAME)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if (n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    release(&tickslock);
    sleep();
    acquire(&tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_ps(void)
{
  procdump();
  return 0;
}

uint64
sys_setpriority(void)
{
  int pid;
  int priority;

  argint(0, &pid);
  argint(1, &priority);

  if (pid < 0 || priority < PRIO_MIN || priority > PRIO_MAX)
    return -1;

  return setpriority(pid, priority);
}

uint64
sys_getpriority(void)
{
  int pid;

  argint(0, &pid);

  if (pid < 0)
    return -1;

  return getpriority(pid);
}

uint64
sys_getcowfaults(void)
{
  int pid;

  argint(0, &pid);
  return getcowfaults_proc(pid);
}

// Find an unused virtual address range below TRAPFRAME for a new mmap VMA.
uint64
mmap_find_addr(struct proc *p, uint64 length)
{
  uint64 addr;
  uint64 end;
  int i;

  end = TRAPFRAME;

  for (i = 0; i < NVMA; i++) {
    if (p->vmas[i].used && p->vmas[i].addr < end)
      end = p->vmas[i].addr;
  }

  length = PGROUNDUP(length);
  if (length > end)
    return 0;

  addr = PGROUNDDOWN(end - length);
  if (addr < p->sz)
    return 0;

  return addr;
}

// Reserve a lazy virtual memory mapping (file-backed or MAP_ANONYMOUS).
// Physical pages are allocated on demand by mmapfault() on first access.
uint64
sys_mmap(void)
{
  uint64 addr;
  uint64 length;
  uint64 offset;
  int prot;
  int flags;
  int fd;
  int is_anon;
  int is_shared;
  int is_private;
  struct file *f = 0;
  struct proc *p = myproc();
  struct vma *vma;
  int i;

  argaddr(0, &addr);
  argaddr(1, &length);
  argint(2, &prot);
  argint(3, &flags);
  argint(4, &fd);
  argaddr(5, &offset);

  if (length == 0)
    return -1;

  if (offset % PGSIZE != 0)
    return -1;

  if (prot & ~(PROT_READ | PROT_WRITE))
    return -1;

  if (flags & ~(MAP_SHARED | MAP_PRIVATE | MAP_ANONYMOUS))
    return -1;

  is_anon = (flags & MAP_ANONYMOUS) != 0;
  is_shared = (flags & MAP_SHARED) != 0;
  is_private = (flags & MAP_PRIVATE) != 0;

  if (is_shared && is_private)
    return -1;

  if (!is_anon && !is_shared && !is_private)
    return -1;

  if (is_anon) {
    // Anonymous mappings have no backing file and must use fd == -1, offset 0.
    if (fd != -1 || offset != 0)
      return -1;
  } else {
    if (fd < 0 || fd >= NOFILE)
      return -1;

    f = p->ofile[fd];
    if (f == 0 || f->type != FD_INODE)
      return -1;

    if (!f->readable)
      return -1;

    if (is_shared && (prot & PROT_WRITE) && !f->writable)
      return -1;
  }

  for (i = 0; i < NVMA; i++) {
    if (p->vmas[i].used == 0)
      break;
  }

  if (i == NVMA)
    return -1;

  vma = &p->vmas[i];
  vma->addr = mmap_find_addr(p, length);
  if (vma->addr == 0)
    return -1;

  vma->used = 1;
  vma->length = length;
  vma->maplen = PGROUNDUP(length);
  vma->prot = prot;
  vma->flags = flags;
  vma->file = f ? filedup(f) : 0;
  vma->offset = offset;

  return vma->addr;
}

uint64
sys_munmap(void)
{
  uint64 addr;
  uint64 length;

  argaddr(0, &addr);
  argaddr(1, &length);

  if (length == 0)
    return -1;

  if (addr % PGSIZE != 0)
    return -1;

  return mmap_unmap(myproc(), addr, length);
}

uint64
sys_trace(void)
{
  uint64 mask;
  struct proc *p = myproc();

  argaddr(0, &mask);
  p->trace_mask = mask;
  if (p->trace_flags & TRACE_SUMMARY) {
    memset(p->syscall_freq, 0, sizeof(p->syscall_freq));
    memset(p->syscall_errs, 0, sizeof(p->syscall_errs));
  }
  return 0;
}

uint64
sys_tracemode(void)
{
  int flags;
  struct proc *p = myproc();

  argint(0, &flags);
  if (flags & ~(TRACE_ERRORS | TRACE_SUMMARY))
    return -1;

  p->trace_flags = flags;
  if (flags & TRACE_SUMMARY) {
    memset(p->syscall_freq, 0, sizeof(p->syscall_freq));
    memset(p->syscall_errs, 0, sizeof(p->syscall_errs));
  }
  return 0;
}

uint64
sys_sysinfo(void)
{
  uint64 addr;
  struct sysinfo info;
  struct proc *p = myproc();

  argaddr(0, &addr);

  info.freemem = kfreemem();
  info.totalmem = ktotalmem();
  info.nproc = nproc_active();
  info.nfiles = nopen_files();
  info.shared_pages = ksharedpages();
  acquire(&tickslock);
  info.uptime = ticks;
  release(&tickslock);

  if (copyout(p->pagetable, p->sz, addr, (char *)&info, sizeof(info)) < 0)
    return -1;

  return 0;
}

uint64
sys_getppid(void)
{
  return kgetppid();
}

uint64
sys_ptree(void)
{
  int root_pid;

  argint(0, &root_pid);
  if (root_pid < 0)
    return -1;

  return proctree(root_pid);
}

uint64
sys_getsyscallcount(void)
{
  int pid;

  argint(0, &pid);
  return getsyscallcount_proc(pid);
}

uint64
sys_setaging(void)
{
  int new_ticks;

  argint(0, &new_ticks);
  return setaging(new_ticks);
}

uint64
sys_syscallstats(void)
{
  int pid;

  argint(0, &pid);
  return print_syscall_stats(pid);
}

uint64
sys_waitx(void)
{
  uint64 addr, waddr, raddr, csw_addr;

  argaddr(0, &addr);
  argaddr(1, &waddr);
  argaddr(2, &raddr);
  argaddr(3, &csw_addr);

  return kwaitx(addr, waddr, raddr, csw_addr);
}

uint64
sys_halt(void)
{
  printk("System halting...\n");
  *(volatile uint32 *)VIRT_TEST = 0x5555;
  for (;;)
    ;
  return 0;
}

uint64
sys_reboot(void)
{
  printk("System rebooting...\n");
  *(volatile uint32 *)VIRT_TEST = 0x7777;
  for (;;)
    ;
  return 0;
}

uint64
sys_sched_yield(void)
{
  struct proc *p = myproc();

  p->yield_count++;
  uint64 count = p->yield_count;
  yield();
  return count;
}

uint64
sys_getcpuid(void)
{
  int id;

  push_off();
  id = cpuid();
  pop_off();
  return id;
}

uint64
sys_setprocname(void)
{
  char buf[16];
  struct proc *p = myproc();

  if (argstr(0, buf, sizeof(buf)) < 0)
    return -1;

  if (buf[0] == '\0')
    return -1;

  acquire(&p->lock);
  safestrcpy(p->name, buf, sizeof(p->name));
  release(&p->lock);

  return 0;
}

uint64
sys_setaffinity(void)
{
  int pid;
  uint64 mask;
  int old;

  argint(0, &pid);
  argaddr(1, &mask);

  old = setaffinity_proc(pid, mask);
  if (old < 0)
    return -1;

  // Trigger immediate rescheduling if caller pinned itself away from current hart.
  if (mask != 0 && (pid == 0 || pid == myproc()->pid))
    yield();

  return old;
}

uint64
sys_getprocname(void)
{
  int pid, bufsiz;
  uint64 ubuf;

  argint(0, &pid);
  argaddr(1, &ubuf);
  argint(2, &bufsiz);

  return getprocname_proc(pid, ubuf, bufsiz);
}

uint64
sys_findproc(void)
{
  char name[16];
  uint64 upids;
  int max;

  if (argstr(0, name, sizeof(name)) < 0)
    return -1;
  argaddr(1, &upids);
  argint(2, &max);

  return findproc_by_name(name, upids, max);
}
<<<<<<< HEAD
=======

// Arm or disarm a periodic (or SIGALARM_ONESHOT) user-space timer callback.
// Returns remaining ticks from any previously scheduled alarm (0 if none).
uint64
sys_sigalarm(void)
{
  int interval, flags;
  uint64 handler;
  struct proc *p = myproc();

  argint(0, &interval);
  argaddr(1, &handler);
  argint(2, &flags);

  if (interval < 0 || (flags & ~SIGALARM_ONESHOT))
    return -1;

  int prev_rem = 0;
  if (p->alarm_interval > 0 && p->alarm_interval > p->alarm_ticks)
    prev_rem = p->alarm_interval - p->alarm_ticks;

  p->alarm_interval = interval;
  p->alarm_handler = handler;
  p->alarm_ticks = 0;
  p->alarm_oneshot = (flags & SIGALARM_ONESHOT) ? 1 : 0;
  if (interval == 0)
    p->alarm_active = 0;

  return prev_rem;
}

// Restore the interrupted user registers saved when sigalarm fired.
uint64
sys_sigreturn(void)
{
  struct proc *p = myproc();

  if (!p->alarm_active)
    return -1;

  *(p->trapframe) = p->alarm_tf;
  p->alarm_active = 0;
  // Return saved a0 so syscall() preserves the interrupted instruction's a0.
  return p->trapframe->a0;
}
>>>>>>> 6400aec (Implemented modueles)
