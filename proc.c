#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  if(p->pid > 2) {

    if(createSwapFile(p) != 0)
      panic("allocproc: createSwapFile");
    
    // memset(buf, 0, 16 * 4096);
    // writeToSwapFile(p, (char*)buf, 0, PGSIZE * 16);

    p->num_ram = 0;
    p->num_swap = 0;
    p->totalPgfltCount = 0;
    p->totalPgoutCount = 0;
    if(p->selection == SCFIFO)
    {
      p->clockHand = 0;
    }
    if(p->selection == AQ)
    {
      p->queue_head = 0;
      p->queue_tail = 0;
    }

    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);

    if(p->pid > 2)
    {
  
      // init fblock list
      p->free_head = (struct fblock*)kalloc();
      p->free_head->prev = 0;
      p->free_head->off = 0 * PGSIZE;

      struct fblock *prev = p->free_head;

      for(int i = 1; i < MAX_PSYC_PAGES; i++)
      {
        struct fblock *curr = (struct fblock*)kalloc();
        curr->off = i * PGSIZE;
        curr->prev = prev;
        curr->prev->next = curr;
        prev = curr;
      }
      p->free_tail = prev;
      p->free_tail->next = 0;

      // struct fblock *curr = p->free_tail;
      // for(int i = 0; i < MAX_PSYC_PAGES; i++)
      // {
      //   cprintf("%d -> ", curr->off);
      //   curr = curr->prev;
      // }
      // cprintf("\n");

    }
  }
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    cprintf("growproc: n < 0\n");
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{ 
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  if(curproc->pid <= 2) // init, shell
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
  else // other processes
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
  

  if(np->pgdir == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  if(curproc->pid > 2) // not init or shell
  {
    np->totalPgfltCount = 0;
    np->totalPgoutCount = 0;
    np->num_ram = curproc->num_ram;
    np->num_swap = curproc->num_swap;
    
    int i;
    for(i = 0; i < MAX_PSYC_PAGES; i++)
    {
      if(curproc->ramPages[i].isused)
      {
        np->ramPages[i].isused = 1;
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
        np->ramPages[i].pgdir = np->pgdir;
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
      }

      if(curproc->swappedPages[i].isused)
      {
      np->swappedPages[i].isused = 1;
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
      np->swappedPages[i].pgdir = np->pgdir;
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
      }
    }
      
      char buffer[PGSIZE / 2] = "";
      int offset = 0;
      int nread = 0;
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
          panic("fork: error copying parent's swap file");
        offset += nread;
      }

    #if SELECTION==AQ
      copyAQ(np);
    #endif
  }

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
  pid = np->pid;


  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);
  
  return pid;
}

void copyAQ(struct proc* np)
{
  struct proc* curproc = myproc();
  struct queue_node *old_curr = curproc->queue_head;
  struct queue_node *np_curr = 0, *np_prev = 0;
  np->queue_head = 0;
  np->queue_tail = 0;

  if(old_curr != 0) // copying first node separately to set new queue_head
  {
    np_curr = (struct queue_node*)kalloc();
    np_curr->page_index = old_curr->page_index;
    np->queue_head =np_curr;
    np_curr->prev = 0;
    np_prev = np_curr;
    old_curr = old_curr->next;
  }

  while(old_curr != 0)
  {
    np_curr = (struct queue_node*)kalloc();
    np_curr->page_index = old_curr->page_index;
    np_curr->prev = np_prev;
    np_prev->next = np_curr;

    np_prev = np_curr;
    old_curr = old_curr->next;
  }
  if(np->queue_head != 0) // if the queue wasn't empty
  {
    np_curr->next = 0;
    np->queue_tail = np_curr;
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  // if(curproc-> pid > 2)
  // {
  //   removeSwapFile(curproc);
  // }

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  #if VERBOSE_PRINT == TRUE
      cprintf("<%d / %d>\n", getCurrentFreePages(), getTotalFreePages());
  #endif

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  

  if(curproc->pid > 2) {
    if (removeSwapFile(curproc) != 0)
      panic("exit: error deleting swap file");
  }

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  
  curproc->state = ZOMBIE;
  
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir); // panic: kfree
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->clockHand = 0;
        p->swapFile = 0;
        p->free_head = 0;
        p->free_tail = 0;
        p->queue_head = 0;
        p->queue_tail = 0;
        p->numswappages = 0;
        p-> nummemorypages = 0;
        memset(p->ramPages, 0, sizeof(p->ramPages));
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
     p->pid, state, p->name, p->num_ram, p->num_swap, p->totalPgfltCount, p->totalPgoutCount);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
    cprintf("\n");
  }
}

int
getCurrentFreePages(void)
{
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
    pcount++;
  }
  release(&ptable.lock);
  return sum;
}

int
getTotalFreePages(void)
{
  struct proc *p;
  int pcount = 0;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
  }
  release(&ptable.lock);
  return pcount * MAX_PSYC_PAGES;
}