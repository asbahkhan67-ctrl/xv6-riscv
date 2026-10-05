#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
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

  if(priority < 1 || priority > 20)
    return -1;

  return setpriority(pid, priority);
}

uint64
mmap_find_addr(struct proc *p, uint64 length)
{
  uint64 addr;
  uint64 end;
  int i;

  end = TRAPFRAME;

  for(i = 0; i < NVMA; i++){
    if(p->vmas[i].used){
      if(p->vmas[i].addr < end)
        end = p->vmas[i].addr;
    }
  }

  length = PGROUNDUP(length);

  if(length > end)
    return 0;

  addr = PGROUNDDOWN(end - length);

  if(addr < p->sz)
    return 0;

  return addr;
}


uint64
sys_mmap(void)
{
  uint64 addr;
  uint64 length;
  uint64 offset;
  int prot;
  int flags;
  int fd;
  struct file *f;
  struct proc *p = myproc();
  struct vma *vma;
  int i;

  argaddr(0, &addr);
  argaddr(1, &length);
  argint(2, &prot);
  argint(3, &flags);
  argint(4, &fd);
  argaddr(5, &offset);

  if(length == 0)
    return -1;

  if(offset % PGSIZE != 0)
    return -1;

  if(prot & ~(PROT_READ | PROT_WRITE))
    return -1;

  if(flags != MAP_SHARED && flags != MAP_PRIVATE)
    return -1;

  if(fd < 0 || fd >= NOFILE)
    return -1;

  f = p->ofile[fd];

  if(f == 0)
    return -1;


  for(i = 0; i < NVMA; i++){
    if(p->vmas[i].used == 0)
      break;
  }

  if(i == NVMA)
    return -1;

  vma = &p->vmas[i];

  vma->addr = mmap_find_addr(p, length);

  if(vma->addr == 0)
    return -1;

  vma->used = 1;
  vma->length = length;
  vma->maplen = PGROUNDUP(length);
  vma->prot = prot;
  vma->flags = flags;
  vma->file = filedup(f);
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

  if(length == 0)
    return -1;

  if(addr % PGSIZE != 0)
    return -1;

  return mmap_unmap(myproc(), addr, length);
}