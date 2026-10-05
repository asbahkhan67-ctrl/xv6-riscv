// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

struct {
  struct spinlock lock;
  int refcnt[PHYSTOP / PGSIZE];
} ref;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  initlock(&ref.lock, "ref");

  for(int i = 0; i < PHYSTOP / PGSIZE; i++)
    ref.refcnt[i] = 1;

  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char *)PGROUNDUP((uint64)pa_start);
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  int index;
  int count;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end ||
     (uint64)pa >= PHYSTOP)
    panic("kfree");

  index = (uint64)pa / PGSIZE;

  acquire(&ref.lock);
  ref.refcnt[index]--;
  count = ref.refcnt[index];
  release(&ref.lock);

  if(count > 0)
    return;

  if(count < 0)
    panic("kfree refcnt");

  memset(pa, 1, PGSIZE);

  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE);

    acquire(&ref.lock);
    ref.refcnt[(uint64)r / PGSIZE] = 1;
    release(&ref.lock);
  }

  return (void*)r;
}

void
incref(void *pa)
{
  int index = (uint64)pa / PGSIZE;

  acquire(&ref.lock);
  ref.refcnt[index]++;
  release(&ref.lock);
}

int
getref(void *pa)
{
  int index = (uint64)pa / PGSIZE;
  int count;

  acquire(&ref.lock);
  count = ref.refcnt[index];
  release(&ref.lock);

  return count;
}

void
decref(void *pa)
{
  kfree(pa);
}