// Per-CPU state
struct cpu {
  uchar apicid;                // Local APIC ID
  struct context *scheduler;   // swtch() here to enter scheduler
  struct taskstate ts;         // Used by x86 to find stack for interrupt
  struct segdesc gdt[NSEGS];   // x86 global descriptor table
  volatile uint started;       // Has the CPU started?
  int ncli;                    // Depth of pushcli nesting.
  int intena;                  // Were interrupts enabled before pushcli?
  struct proc *proc;           // The process running on this cpu or null
};

extern struct cpu cpus[NCPU];
extern int ncpu;

//PAGEBREAK: 17
// Saved registers for kernel context switches.
// Don't need to save all the segment registers (%cs, etc),
// because they are constant across kernel contexts.
// Don't need to save %eax, %ecx, %edx, because the
// x86 convention is that the caller has saved them.
// Contexts are stored at the bottom of the stack they
// describe; the stack pointer is the address of the context.
// The layout of the context matches the layout of the stack in swtch.S
// at the "Switch stacks" comment. Switch doesn't save eip explicitly,
// but it is on the stack and allocproc() manipulates it.
struct context {
  uint edi;
  uint esi;
  uint ebx;
  uint ebp;
  uint eip;
};

struct queue_node{
  struct queue_node* next;
  struct queue_node* prev;
  int page_index;
};

struct page {
  pde_t* pgdir;   
  int isused;
  char *virt_addr;
  int swap_offset;
  int ref_bit;        // SCFIFO referenced bit
  uint nfua_counter;  // NFUA counter
  uint lapa_counter;  // LAPA counter
};

struct fblock {
  uint off;
  struct fblock *next;
  struct fblock *prev;
};

// page that avilable to process but no used yet
// struct unusedpage {
//   char *virt_addr;
//   int age;
//   struct unusedpage *next; // the next avilable not used page
//   struct unusedpage *prev; // the prev avilabe not used page
// };


enum procstate { UNUSED, EMBRYO, SLEEPING, RUNNABLE, RUNNING, ZOMBIE };

// Per-process state
struct proc {
  uint sz;                     // Size of process memory (bytes)
  pde_t* pgdir;                // Page table
  char *kstack;                // Bottom of kernel stack for this process
  enum procstate state;        // Process state
  int pid;                     // Process ID
  struct proc *parent;         // Parent process
  struct trapframe *tf;        // Trap frame for current syscall
  struct context *context;     // swtch() here to run process
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
  //Swap file. must initiate with create swap file
  struct file *swapFile;       //page file
  uint nummemorypages;         // number of pages in process memory (without kernel pages)
  uint numswappages;           // num of pages reside in the swap file
  struct page swappedPages [MAX_PSYC_PAGES];  // Swapped pages of this process
  struct page ramPages [MAX_PSYC_PAGES];
  int num_ram;
  int num_swap;
  uint clockHand;                   // Second chance FIFO clock hand (0 <= clockHand <= 15)
  struct fblock *free_head;         // head of free blocks linked list of PGSIZE bytes in swapFile
  struct fblock *free_tail;         // tail of free blocks linked list of PGSIZE bytes in swapFile

  struct queue_node* queue_head;
  struct queue_node* queue_tail;
  int selection;
  uint totalPgfltCount;
  uint totalPgoutCount;

};

// Process memory is laid out contiguously, low addresses first:
//   text
//   original data and bss
//   fixed-size stack
//   expandable heap
