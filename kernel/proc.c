#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;
int aging_threshold = AGING_THRESHOLD; // Runtime-tunable aging interval (ticks)
<<<<<<< HEAD
<<<<<<< HEAD
=======
volatile uint64 online_cpus = 0;       // Bitmask of harts running scheduler()
>>>>>>> bc531db (Implemented modules 11-15)
=======
volatile uint64 online_cpus = 0;       // Bitmask of harts running scheduler()
>>>>>>> 6400aec (Implemented modueles)

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void
procinit(void)
{
  struct proc *p;

  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for (p = proc; p < &proc[NPROC]; p++) {
    initlock(&p->lock, "proc");
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int
allocpid()
{
  int pid;

  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc *
allocproc(void)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->priority = PRIO_DEFAULT;
  p->cpu_time = 0;
  p->user_ticks = 0;
  p->kernel_ticks = 0;
  p->cow_faults = 0;
  p->trace_mask = 0;
  p->trace_flags = 0;
  p->syscall_count = 0;
  memset(p->syscall_freq, 0, sizeof(p->syscall_freq));
  memset(p->syscall_errs, 0, sizeof(p->syscall_errs));
  p->ctime = ticks;
  p->last_run_tick = ticks;
<<<<<<< HEAD
<<<<<<< HEAD
=======
  p->ctx_switches = 0;
  p->yield_count = 0;
  p->cpu_affinity = ~0ULL;
>>>>>>> bc531db (Implemented modules 11-15)
=======
  p->ctx_switches = 0;
  p->yield_count = 0;
  p->cpu_affinity = ~0ULL;
  p->fd_cloexec = 0;
  p->alarm_interval = 0;
  p->alarm_ticks = 0;
  p->alarm_active = 0;
  p->alarm_oneshot = 0;
  p->alarm_handler = 0;
  memset(&p->alarm_tf, 0, sizeof(p->alarm_tf));
>>>>>>> 6400aec (Implemented modueles)
  for (int i = 0; i < NVMA; i++)
    memset(&p->vmas[i], 0, sizeof(p->vmas[i]));
  p->state = USED;

  // Allocate a trapframe page.
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if (p->pagetable == 0) {
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if (p->trapframe)
    kfree((void *)p->trapframe);
  p->trapframe = 0;
  if (p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->priority = 0;
  p->cpu_time = 0;
  p->user_ticks = 0;
  p->kernel_ticks = 0;
  p->cow_faults = 0;
  p->trace_mask = 0;
  p->trace_flags = 0;
  p->syscall_count = 0;
  memset(p->syscall_freq, 0, sizeof(p->syscall_freq));
  memset(p->syscall_errs, 0, sizeof(p->syscall_errs));
  p->ctime = 0;
  p->last_run_tick = 0;
  p->ctx_switches = 0;
  p->yield_count = 0;
  p->cpu_affinity = ~0ULL;
<<<<<<< HEAD
=======
  p->fd_cloexec = 0;
  p->alarm_interval = 0;
  p->alarm_ticks = 0;
  p->alarm_active = 0;
  p->alarm_oneshot = 0;
  p->alarm_handler = 0;
  memset(&p->alarm_tf, 0, sizeof(p->alarm_tf));
>>>>>>> 6400aec (Implemented modueles)
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if (pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
               PTE_R | PTE_X) < 0) {
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
               PTE_R | PTE_W) < 0) {
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;

  p->cwd = namei("/");

  p->last_run_tick = ticks;
  p->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if (n > 0) {
    if (sz + n > TRAPFRAME) {
      return -1;
    }
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
      return -1;
    }
  } else if (n < 0) {
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
kfork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if ((np = allocproc()) == 0) {
    return -1;
  }

  // Copy user memory from parent to child.
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;
  np->trace_mask = p->trace_mask;
  np->trace_flags = p->trace_flags;
<<<<<<< HEAD
<<<<<<< HEAD
=======
  np->cpu_affinity = p->cpu_affinity;
>>>>>>> bc531db (Implemented modules 11-15)
=======
  np->cpu_affinity = p->cpu_affinity;
>>>>>>> 6400aec (Implemented modueles)

  // Inherit active memory mappings (duplicate file handle only if file-backed).
  for (i = 0; i < NVMA; i++) {
    if (p->vmas[i].used) {
      np->vmas[i] = p->vmas[i];
      if (p->vmas[i].file)
        np->vmas[i].file = filedup(p->vmas[i].file);
    }
  }

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for (i = 0; i < NOFILE; i++)
    if (p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->fd_cloexec = p->fd_cloexec;
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->last_run_tick = ticks;
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for (pp = proc; pp < &proc[NPROC]; pp++) {
    if (pp->parent == p) {
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
kexit(int status)
{
  struct proc *p = myproc();

  if (p == initproc)
    panic("init exiting");

  if (p->trace_flags & TRACE_SUMMARY)
    print_trace_summary(p);

  mmap_cleanup(p);

  // Close all open files.
  for (int fd = 0; fd < NOFILE; fd++) {
    if (p->ofile[fd]) {
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);

  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
kwait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;) {
    // Scan through table looking for exited children.
    havekids = 0;
    for (pp = proc; pp < &proc[NPROC]; pp++) {
      if (pp->parent == p) {
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if (pp->state == ZOMBIE) {
          // Found one.
          pid = pp->pid;
          if (addr != 0 &&
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
                      sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          pp->parent = 0;
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if (!havekids || killed(p)) {
      release(&wait_lock);
      return -1;
    }

    // Wait for a child to exit.
    sleep_prepare(p); //DOC: wait-sleep
    release(&wait_lock);
    sleep();
    acquire(&wait_lock);
  }
}

// Extended wait returning child's wait ticks, CPU run ticks, and context switches.
int
kwaitx(uint64 addr, uint64 wtime_addr, uint64 rtime_addr, uint64 csw_addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for (;;) {
    havekids = 0;
    for (pp = proc; pp < &proc[NPROC]; pp++) {
      if (pp->parent == p) {
        acquire(&pp->lock);

        havekids = 1;
        if (pp->state == ZOMBIE) {
          uint64 rtime = pp->cpu_time;
          uint64 now = ticks;
          uint64 total = (now >= pp->ctime) ? (now - pp->ctime) : 0;
          uint64 wtime = (total > rtime) ? (total - rtime) : 0;
          uint64 csw = pp->ctx_switches;

          pid = pp->pid;
          if (addr != 0 &&
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
                      sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          if (wtime_addr != 0 && copyout(p->pagetable, p->sz, wtime_addr,
                                         (char *)&wtime, sizeof(wtime)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          if (rtime_addr != 0 && copyout(p->pagetable, p->sz, rtime_addr,
                                         (char *)&rtime, sizeof(rtime)) < 0) {
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 6400aec (Implemented modueles)
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          if (csw_addr != 0 && copyout(p->pagetable, p->sz, csw_addr,
                                       (char *)&csw, sizeof(csw)) < 0) {
<<<<<<< HEAD
>>>>>>> bc531db (Implemented modules 11-15)
=======
>>>>>>> 6400aec (Implemented modueles)
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          pp->parent = 0;
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    if (!havekids || killed(p)) {
      release(&wait_lock);
      return -1;
    }

    sleep_prepare(p);
    release(&wait_lock);
    sleep();
    acquire(&wait_lock);
  }
}

// Compute a process's effective priority using anti-starvation aging.
// Base priority (p->priority) is never mutated; RUNNABLE processes earn a
// boost of 1 level for every 'aging_threshold' ticks spent waiting.
static int
calc_eff_prio(struct proc *p, uint64 now, uint64 *waited_out)
{
  uint64 waited = 0;
  int eff_prio = p->priority;
  int thresh = aging_threshold;

  if (thresh < 1)
    thresh = 1;

  if (p->state == RUNNABLE) {
    waited = (now > p->last_run_tick) ? (now - p->last_run_tick) : 0;
    uint64 boost = waited / (uint64)thresh;
    eff_prio = p->priority - (int)boost;
    if (eff_prio < PRIO_MIN)
      eff_prio = PRIO_MIN;
  }

  if (waited_out)
    *waited_out = waited;

  return eff_prio;
}

// Query or tune the runtime priority aging threshold (ticks per boost).
// Passing 0 returns the current threshold; passing 1..1000 sets it and
// returns the previous threshold; invalid values return -1.
int
setaging(int new_ticks)
{
  if (new_ticks < 0 || new_ticks > 1000)
    return -1;

  int old = aging_threshold;
  if (new_ticks > 0)
    aging_threshold = new_ticks;
  return old;
}

// Per-CPU process scheduler with priority selection and priority aging.
// Lower priority numbers run first (PRIO_MIN=1 highest .. PRIO_MAX=20 lowest).
void
scheduler(void)
{
  struct proc *p;
  struct proc *best;
  int best_eff_prio;
  uint64 best_waited;
  struct cpu *c = mycpu();
  uint64 my_bit = 1ULL << cpuid();

  // Register this RISC-V hart as online so setaffinity() validates masks safely.
  acquire(&pid_lock);
  online_cpus |= my_bit;
  release(&pid_lock);

  c->proc = 0;

  for (;;) {
    // Allow interrupts while scanning so devices and timers stay responsive.
    intr_on();

    best = 0;
    best_eff_prio = PRIO_MAX + 1;
    best_waited = 0;
    uint64 now = ticks;

    // Scan the process table and keep p->lock held only on the current best pick.
    for (p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);

<<<<<<< HEAD
<<<<<<< HEAD
      if (p->state == RUNNABLE) {
<<<<<<< HEAD
<<<<<<< HEAD
        uint64 waited = (now > p->last_run_tick) ? (now - p->last_run_tick) : 0;
        uint64 boost = waited / AGING_THRESHOLD;
        int eff_prio = p->priority - (int)boost;
        if (eff_prio < PRIO_MIN)
          eff_prio = PRIO_MIN;
=======
        uint64 waited = 0;
        int eff_prio = calc_eff_prio(p, now, &waited);
>>>>>>> e18456e (Updated xv6-riscv)
=======
        uint64 waited = 0;
        int eff_prio = calc_eff_prio(p, now, &waited);
>>>>>>> b8719fe (updated project)
=======
      if (p->state == RUNNABLE && (p->cpu_affinity & my_bit)) {
        uint64 waited = 0;
        int eff_prio = calc_eff_prio(p, now, &waited);
>>>>>>> bc531db (Implemented modules 11-15)
=======
      if (p->state == RUNNABLE && (p->cpu_affinity & my_bit)) {
        uint64 waited = 0;
        int eff_prio = calc_eff_prio(p, now, &waited);
>>>>>>> 6400aec (Implemented modueles)

        if (best == 0 || eff_prio < best_eff_prio ||
            (eff_prio == best_eff_prio && waited > best_waited)) {
          if (best != 0)
            release(&best->lock);

          best = p;
          best_eff_prio = eff_prio;
          best_waited = waited;
        } else {
          release(&p->lock);
        }
      } else {
        release(&p->lock);
      }
    }

    // Switch CPU context to the winning process if one is runnable.
    if (best != 0) {
      best->state = RUNNING;
      best->ctx_switches++;
      c->proc = best;

      swtch(&c->context, &best->context);

      best->last_run_tick = ticks;
      c->proc = 0;
      release(&best->lock);
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if (!holding(&p->lock))
    panic("sched p->lock");
  if (mycpu()->noff != 1)
    panic("sched locks");
  if (p->state == RUNNING)
    panic("sched RUNNING");
  if (intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();

  // Still holding p->lock from scheduler.
  release(&p->lock);

  if (first) {
    first = 0;

    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    if (p->trapframe->a0 == -1) {
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
  uint64 satp = MAKE_SATP(p->pagetable);
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
  struct proc *p = myproc();

  acquire(&p->lock);
  if (chan == 0)
    panic("sleep_prepare: zero chan");
  p->chan = chan;
  release(&p->lock);
}

// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
  struct proc *p = myproc();

  acquire(&p->lock);
  if (p->chan != 0) {
    p->state = SLEEPING;
    sched();
  }
  release(&p->lock);
}

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->chan == chan) {
      // If the process is waiting for wakeups on this channel,
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNABLE.
      if (p->state == SLEEPING) {
        p->last_run_tick = ticks;
        p->state = RUNNABLE;
      }
    }
    release(&p->lock);
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
  struct proc *p;

  if (pid == 0)
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->pid == pid) {
      p->killed = 1;
      if (p->state == SLEEPING) {
        // Wake process from sleep().
        p->last_run_tick = ticks;
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void
setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int
killed(struct proc *p)
{
  int k;

  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if (user_dst) {
    return copyout(p->pagetable, p->sz, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if (user_src) {
    return copyin(p->pagetable, p->sz, dst, src, len);
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}

// Convert an unsigned 64-bit integer to decimal in buf and return its length.
static int
uint_to_str(uint64 val, char *buf)
{
  char tmp[24];
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

// Print a string left-aligned to a fixed column width (xv6 printk lacks %-Ns).
static void
print_col(const char *s, int width)
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

// Print an unsigned integer left-aligned to a fixed column width.
static void
print_uint_col(uint64 val, int width)
{
  char buf[24];

  uint_to_str(val, buf);
  print_col(buf, width);
}

// Print a formatted table of all active processes to the console.
// Used by both the 'ps' command and the Ctrl+P console shortcut.
// Intentionally lock-free so Ctrl+P still works if a lock is wedged.
void
procdump(void)
{
  static char *states[] = {
    // clang-format off
    [UNUSED]    = "unused",
    [USED]      = "used",
    [SLEEPING]  = "sleep",
    [RUNNABLE]  = "runble",
    [RUNNING]   = "run",
    [ZOMBIE]    = "zombie"
    // clang-format on
  };
  struct proc *p;
  char *state;
  int active_count = 0;
  uint64 total_mem_kb = 0;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD

  printk("PID   PRIO  CPU (U/K)       MEM-KB  STATE   NAME\n");
  printk("----  ----  --------------  ------  ------  ----------------\n");
=======
  uint64 now = ticks;

  printk("PID   PRIO  EFF   CPU (U/K)       MEM-KB  STATE   NAME\n");
  printk("----  ----  ----  --------------  ------  ------  ----------------\n");
>>>>>>> e18456e (Updated xv6-riscv)
=======
=======
>>>>>>> bc531db (Implemented modules 11-15)
=======
>>>>>>> 6400aec (Implemented modueles)
  uint64 now = ticks;

  printk("PID   PRIO  EFF   CPU (U/K)       MEM-KB  STATE   NAME\n");
  printk(
    "----  ----  ----  --------------  ------  ------  ----------------\n");
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> b8719fe (updated project)
=======
>>>>>>> bc531db (Implemented modules 11-15)
=======
>>>>>>> 6400aec (Implemented modueles)

  for (p = proc; p < &proc[NPROC]; p++) {
    if (p->state == UNUSED)
      continue;

    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";

    // Build "total (user/kernel)" CPU tick string.
    char cpubuf[72];
    int pos = 0;
    pos += uint_to_str(p->cpu_time, cpubuf + pos);
    cpubuf[pos++] = ' ';
    cpubuf[pos++] = '(';
    pos += uint_to_str(p->user_ticks, cpubuf + pos);
    cpubuf[pos++] = '/';
    pos += uint_to_str(p->kernel_ticks, cpubuf + pos);
    cpubuf[pos++] = ')';
    cpubuf[pos] = '\0';

    // Convert user memory size from bytes to KB (rounding up partial KB).
    uint64 mem_kb = (p->sz + 1023) / 1024;
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
    int eff_prio = calc_eff_prio(p, now, 0);
>>>>>>> e18456e (Updated xv6-riscv)
=======
    int eff_prio = calc_eff_prio(p, now, 0);
>>>>>>> b8719fe (updated project)
=======
    int eff_prio = calc_eff_prio(p, now, 0);
>>>>>>> bc531db (Implemented modules 11-15)
=======
    int eff_prio = calc_eff_prio(p, now, 0);
>>>>>>> 6400aec (Implemented modueles)
    total_mem_kb += mem_kb;
    active_count++;

    print_uint_col(p->pid, 6);
    print_uint_col(p->priority, 6);
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
=======
    print_uint_col(eff_prio, 6);
>>>>>>> e18456e (Updated xv6-riscv)
=======
    print_uint_col(eff_prio, 6);
>>>>>>> b8719fe (updated project)
=======
    print_uint_col(eff_prio, 6);
>>>>>>> bc531db (Implemented modules 11-15)
=======
    print_uint_col(eff_prio, 6);
>>>>>>> 6400aec (Implemented modueles)
    print_col(cpubuf, 16);
    print_uint_col(mem_kb, 8);
    print_col(state, 8);
    printk("%s\n", p->name);
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  printk("------------------------------------------------------------\n");
  printk("Active processes: %d | Total process memory: %lu KB\n",
         active_count, total_mem_kb);
=======
  printk("------------------------------------------------------------------\n");
  printk("Active processes: %d | Total process memory: %lu KB | Aging: %d ticks\n",
         active_count, total_mem_kb, aging_threshold);
>>>>>>> e18456e (Updated xv6-riscv)
=======
=======
>>>>>>> bc531db (Implemented modules 11-15)
=======
>>>>>>> 6400aec (Implemented modueles)
  printk(
    "------------------------------------------------------------------\n");
  printk(
    "Active processes: %d | Total process memory: %lu KB | Aging: %d ticks\n",
    active_count, total_mem_kb, aging_threshold);
<<<<<<< HEAD
<<<<<<< HEAD
>>>>>>> b8719fe (updated project)
=======
>>>>>>> bc531db (Implemented modules 11-15)
=======
>>>>>>> 6400aec (Implemented modueles)
}

// Update the scheduling priority of process 'pid' (pid == 0 targets caller).
// Returns 0 on success, -1 if no active process matches 'pid'.
int
setpriority(int pid, int priority)
{
  struct proc *p;

  if (pid == 0) {
    p = myproc();
    acquire(&p->lock);
    p->priority = priority;
    release(&p->lock);
    return 0;
  }

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && p->pid == pid) {
      p->priority = priority;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }

  return -1;
}

// Query the base scheduling priority of process 'pid' (pid == 0 targets caller).
// Returns priority (PRIO_MIN..PRIO_MAX) on success, or -1 if not found.
int
getpriority(int pid)
{
  struct proc *p;
  int prio;

  if (pid == 0) {
    p = myproc();
    acquire(&p->lock);
    prio = p->priority;
    release(&p->lock);
    return prio;
  }

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && p->pid == pid) {
      prio = p->priority;
      release(&p->lock);
      return prio;
    }
    release(&p->lock);
  }

  return -1;
}

// Query how many Copy-on-Write write faults process 'pid' has triggered.
// Passing pid <= 0 inspects the calling process.
int
getcowfaults_proc(int pid)
{
  struct proc *p;
  int count;

  if (pid <= 0)
    return (int)myproc()->cow_faults;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && p->pid == pid) {
      count = (int)p->cow_faults;
      release(&p->lock);
      return count;
    }
    release(&p->lock);
  }

  return -1;
}

uint64
nproc_active(void)
{
  struct proc *p;
  uint64 count = 0;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED)
      count++;
    release(&p->lock);
  }

  return count;
}

int
kgetppid(void)
{
  struct proc *p = myproc();
  int ppid = 0;

  acquire(&wait_lock);
  if (p->parent != 0) {
    acquire(&p->parent->lock);
    ppid = p->parent->pid;
    release(&p->parent->lock);
  }
  release(&wait_lock);

  return ppid;
}

struct pnode {
  int pid;
  int ppid;
  int priority;
  int kids;
  enum procstate state;
  char name[16];
};

static void
print_ptree_node(const struct pnode *node, int depth)
{
  static char *states[] = {
    // clang-format off
    [UNUSED]    = "unused",
    [USED]      = "used",
    [SLEEPING]  = "sleep",
    [RUNNABLE]  = "runble",
    [RUNNING]   = "run",
    [ZOMBIE]    = "zombie"
    // clang-format on
  };
  char *st;

  for (int d = 0; d < depth; d++)
    printk("  ");
  if (depth > 0)
    printk("|-- ");

  if (node->state >= 0 && node->state < NELEM(states) && states[node->state])
    st = states[node->state];
  else
    st = "???";

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  printk("[%d] %s (prio=%d, state=%s, kids=%d)\n",
         node->pid, node->name, node->priority, st, node->kids);
=======
  printk("[%d] %s (prio=%d, state=%s, kids=%d)\n", node->pid, node->name,
         node->priority, st, node->kids);
>>>>>>> b8719fe (updated project)
=======
  printk("[%d] %s (prio=%d, state=%s, kids=%d)\n", node->pid, node->name,
         node->priority, st, node->kids);
>>>>>>> bc531db (Implemented modules 11-15)
=======
  printk("[%d] %s (prio=%d, state=%s, kids=%d)\n", node->pid, node->name,
         node->priority, st, node->kids);
>>>>>>> 6400aec (Implemented modueles)
}

static void
print_ptree_nodes(struct pnode *nodes, int count, int ppid, int depth)
{
  if (depth > 16)
    return;

  for (int i = 0; i < count; i++) {
    if (nodes[i].ppid == ppid) {
      print_ptree_node(&nodes[i], depth);
      print_ptree_nodes(nodes, count, nodes[i].pid, depth + 1);
    }
  }
}

// Render the live process hierarchy (or only the subtree rooted at root_pid).
// Returns 0 on success, -1 on allocation failure or if root_pid is not active.
int
proctree(int root_pid)
{
  struct pnode *nodes;
  struct proc *p;
  int count = 0;

  nodes = (struct pnode *)kalloc();
  if (nodes == 0)
    return -1;

  acquire(&wait_lock);
  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED) {
      nodes[count].pid = p->pid;
      nodes[count].priority = p->priority;
      nodes[count].kids = 0;
      nodes[count].state = p->state;
      safestrcpy(nodes[count].name, p->name, sizeof(nodes[count].name));
      release(&p->lock);

      if (p->parent != 0) {
        acquire(&p->parent->lock);
        nodes[count].ppid = p->parent->pid;
        release(&p->parent->lock);
      } else {
        nodes[count].ppid = 0;
      }
      count++;
    } else {
      release(&p->lock);
    }
  }
  release(&wait_lock);

  // Compute direct active child counts for each node.
  for (int i = 0; i < count; i++) {
    for (int j = 0; j < count; j++) {
      if (nodes[j].ppid == nodes[i].pid)
        nodes[i].kids++;
    }
  }

  if (root_pid <= 0) {
    print_ptree_nodes(nodes, count, 0, 0);
    kfree((void *)nodes);
    return 0;
  }

  // Subtree filtering mode: locate root_pid and print its descendants.
  int root_idx = -1;
  for (int i = 0; i < count; i++) {
    if (nodes[i].pid == root_pid) {
      root_idx = i;
      break;
    }
  }

  if (root_idx < 0) {
    kfree((void *)nodes);
    return -1;
  }

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
  printk("Subtree Root PID: %d (kids=%d)\n",
         nodes[root_idx].pid, nodes[root_idx].kids);
=======
  printk("Subtree Root PID: %d (kids=%d)\n", nodes[root_idx].pid,
         nodes[root_idx].kids);
>>>>>>> b8719fe (updated project)
=======
  printk("Subtree Root PID: %d (kids=%d)\n", nodes[root_idx].pid,
         nodes[root_idx].kids);
>>>>>>> bc531db (Implemented modules 11-15)
=======
  printk("Subtree Root PID: %d (kids=%d)\n", nodes[root_idx].pid,
         nodes[root_idx].kids);
>>>>>>> 6400aec (Implemented modueles)
  print_ptree_node(&nodes[root_idx], 0);
  print_ptree_nodes(nodes, count, nodes[root_idx].pid, 1);
  kfree((void *)nodes);
  return 0;
}

int
getsyscallcount_proc(int pid)
{
  struct proc *p;
  int count;

  if (pid <= 0)
    return (int)myproc()->syscall_count;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && p->pid == pid) {
      count = (int)p->syscall_count;
      release(&p->lock);
      return count;
    }
    release(&p->lock);
  }

  return -1;
}

// Copy a process's syscall frequency and error counters safely for syscount -v.
int
getsyscall_snapshot(int pid, int *pid_out, char *name_out, uint64 *total_out,
                    uint32 *freq_out, uint32 *errs_out)
{
  struct proc *p;

  if (pid <= 0) {
    p = myproc();
    acquire(&p->lock);
    *pid_out = p->pid;
    safestrcpy(name_out, p->name, 16);
    *total_out = p->syscall_count;
    memmove(freq_out, p->syscall_freq, sizeof(p->syscall_freq));
    memmove(errs_out, p->syscall_errs, sizeof(p->syscall_errs));
    release(&p->lock);
    return 0;
  }

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && p->pid == pid) {
      *pid_out = p->pid;
      safestrcpy(name_out, p->name, 16);
      *total_out = p->syscall_count;
      memmove(freq_out, p->syscall_freq, sizeof(p->syscall_freq));
      memmove(errs_out, p->syscall_errs, sizeof(p->syscall_errs));
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }

  return -1;
}
<<<<<<< HEAD
<<<<<<< HEAD
=======
=======
>>>>>>> 6400aec (Implemented modueles)

// Query or set a process's CPU affinity mask (pid == 0 targets caller).
// Passing mask == 0 returns the current effective mask; otherwise sets mask
// (requires at least one online hart bit) and returns the previous mask.
int
setaffinity_proc(int pid, uint64 mask)
{
  struct proc *p;
  uint64 valid = online_cpus;

  if (valid == 0)
    valid = 1ULL;
  if (pid < 0)
    return -1;
  if (mask != 0 && (mask & valid) == 0)
    return -1;

  if (pid == 0) {
    p = myproc();
    acquire(&p->lock);
    int old = (int)(p->cpu_affinity & valid);
    if (mask != 0)
      p->cpu_affinity = mask & valid;
    release(&p->lock);
    return old;
  }

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && p->pid == pid) {
      int old = (int)(p->cpu_affinity & valid);
      if (mask != 0)
        p->cpu_affinity = mask & valid;
      release(&p->lock);
      return old;
    }
    release(&p->lock);
  }

  return -1;
}

// Copy process 'pid' runtime name into user buffer ubuf (pid == 0 = caller).
// Returns the string length on success, or -1 on error / not found.
int
getprocname_proc(int pid, uint64 ubuf, int bufsiz)
{
  struct proc *cur = myproc();
  struct proc *p;
  char name[16];
  int found = 0;

  if (pid < 0 || bufsiz <= 0)
    return -1;

  if (pid == 0) {
    acquire(&cur->lock);
    safestrcpy(name, cur->name, sizeof(name));
    release(&cur->lock);
    found = 1;
  } else {
    for (p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      if (p->state != UNUSED && p->pid == pid) {
        safestrcpy(name, p->name, sizeof(name));
        release(&p->lock);
        found = 1;
        break;
      }
      release(&p->lock);
    }
  }

  if (!found)
    return -1;

  int len = strlen(name);
  if (len >= bufsiz)
    len = bufsiz - 1;
  name[len] = '\0';

  if (copyout(cur->pagetable, cur->sz, ubuf, name, len + 1) < 0)
    return -1;

  return len;
}

// Find all active processes whose name matches 'name' and copy up to 'max'
// PIDs into user array upids. Returns total matching process count.
int
findproc_by_name(const char *name, uint64 upids, int max)
{
  struct proc *cur = myproc();
  struct proc *p;
  int found[NPROC];
  int count = 0;

  if (max <= 0 || name[0] == '\0')
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->state != UNUSED && strncmp(p->name, name, sizeof(p->name)) == 0) {
      if (count < NPROC)
        found[count++] = p->pid;
    }
    release(&p->lock);
  }

  int to_copy = (count < max) ? count : max;
  if (to_copy > 0 && upids != 0) {
    if (copyout(cur->pagetable, cur->sz, upids, (char *)found,
                to_copy * sizeof(int)) < 0)
      return -1;
  }

  return count;
}
<<<<<<< HEAD
>>>>>>> bc531db (Implemented modules 11-15)
=======
>>>>>>> 6400aec (Implemented modueles)
