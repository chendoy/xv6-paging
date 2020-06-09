#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"



/* zero pages arrays and struct variables, will restore in bad */
struct page ramPagesBackup[MAX_PSYC_PAGES];
struct page swappedPagesBackup[MAX_PSYC_PAGES];
int num_ram_backup=0, num_swap_backup=0, clockhand_backup=0;
struct fblock* free_head_backup=0, *free_tail_backup=0;
struct queue_node* queue_head_backup;
struct queue_node* queue_tail_backup;
struct file* swapfile_backup;



void 
backup(struct proc* curproc)
{  
  cprintf("exec now\n");
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
  num_ram_backup = curproc->num_ram; 
  num_swap_backup = curproc->num_swap;
  free_head_backup = curproc->free_head;
  free_tail_backup = curproc->free_tail;
  swapfile_backup = curproc->swapFile;
  queue_head_backup = curproc->queue_head;
  queue_tail_backup = curproc->queue_tail;
  clockhand_backup = curproc->clockHand;
}

void 
clean_arrays(struct proc* curproc)
{
  memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
  curproc->num_ram = 0;
  curproc->num_swap = 0;
}

void
alloc_fresh_fblocklst(struct proc* curproc)
{
 /*allocating fresh fblock list */
  curproc->free_head = (struct fblock*)kalloc();
  curproc->free_head->prev = 0;
  curproc->free_head->off = 0 * PGSIZE;
  struct fblock *prev = curproc->free_head;

  for(int i = 1; i < MAX_PSYC_PAGES; i++)
  {
    struct fblock *curr = (struct fblock*)kalloc();
    curr->off = i * PGSIZE;
    curr->prev = prev;
    curr->prev->next = curr;
    prev = curr;
  }
  curproc->free_tail = prev;
  curproc->free_tail->next = 0;
}

void
clean_by_selection(struct proc* curproc)
{
  if(curproc->selection == AQ)
  {
    curproc->queue_head = 0;
    curproc->queue_tail = 0;
    cprintf("cleaning exec queue\n");
  }

  if(curproc->selection == SCFIFO)
  {
    curproc->clockHand = 0;
  }
}
void 
allocate_fresh(struct proc* curproc)
{
  if(createSwapFile(curproc) != 0)
    panic("exec: create swapfile for exec proc failed");
  clean_arrays(curproc);
  alloc_fresh_fblocklst(curproc);
  clean_by_selection(curproc);

}

int
exec(char *path, char **argv)
{
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
  
  if(curproc->pid > 2)
  {  
    backup(curproc);
    allocate_fresh(curproc);
  }

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  int ind;
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
  {
    // if(curproc->ramPages[ind].isused)
    curproc->ramPages[ind].pgdir = pgdir;

    // if(curproc->swappedPages[ind].isused)
    curproc->swappedPages[ind].pgdir = pgdir;
  }

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  cprintf("exec: bad\n");
  if(pgdir)
    freevm(pgdir);
  /* restoring variables */
  if(curproc->pid > 2)
  {
    memmove((void*)curproc->ramPages, ramPagesBackup, 16 * sizeof(struct page));
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
    
    curproc->free_head = free_head_backup;
    curproc->free_tail = free_tail_backup;
    curproc->num_ram = num_ram_backup;
    curproc->num_swap = num_swap_backup;
    curproc->swapFile = swapfile_backup;
    curproc->clockHand = clockhand_backup;
    curproc->queue_head = queue_head_backup;
    curproc->queue_tail = queue_tail_backup;
  }
  

  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
