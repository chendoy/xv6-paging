// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld

struct run {
  struct run *next;
  uint refcount;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
  
  struct run runs[MAXPAGES]; // pages allocated now (?)
} kmem;

// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree_nocheck(p);
}
//PAGEBREAK: 21
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)

void
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock) 
    acquire(&kmem.lock);
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  if(r->refcount != 1)
  {
    // cprintf("ref count is %d", r->refcount);
    panic("kfree: freeing a shared page");
  }


  r->next = kmem.freelist;
  r->refcount = 0;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

void
kfree_nocheck(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock) 
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
  r->refcount = 0;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
  char *rv;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
  {
    kmem.freelist = r->next;
    r->refcount = 1;
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
  return rv;
}

void
refDec(char *v)
{
  struct run *r;
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
  r->refcount -= 1;
  if(kmem.use_lock)
    release(&kmem.lock);
}

void
refInc(char *v)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
  r->refcount += 1;
  if(kmem.use_lock)
    release(&kmem.lock);
}

int
getRefs(char *v)
{
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
  return r->refcount;
}

int getNumOfFreePages(void) {
  int c = 0;
  struct run *r = kmem.freelist;
  while(r) {
    c++;
    r = r->next;
  }
  return c;
}