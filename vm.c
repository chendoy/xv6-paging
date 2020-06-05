#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()
static char buffer[PGSIZE];

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
  {
    return 0;
  }
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(v2p(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(v2p(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;
  struct proc* curproc = myproc();
  // uint pa;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){

    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    if(curproc->pid <= 2) // init or shell
    {
        memset(mem, 0, PGSIZE);
        if(mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0){
          cprintf("allocuvm out of memory (2)\n");
          deallocuvm(pgdir, newsz, oldsz);
          kfree(mem);
          return 0;
        }
    }
    else // not init or shell
    {
      memset(mem, 0, PGSIZE);
      if(mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0){
        cprintf("allocuvm out of memory (2)\n");
        deallocuvm(pgdir, newsz, oldsz);
        kfree(mem);
        return 0;
      }

      if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
      {
          int new_index = getNextFreeRamIndex();
          struct page *newpage = &curproc->ramPages[new_index];

          newpage->isused = 1;
          newpage->pgdir = pgdir;
          newpage->swap_offset = new_index * PGSIZE;
          newpage->virt_addr = (char*)a;

          curproc->num_ram++;  
      }

      else // no space in RAM for this new page, will swap
      {
        // get info of the page to be evicted
        uint evicted_ind = indexToSwap();
        struct page evicted_page = curproc->ramPages[evicted_ind];
        char* evicted_va = evicted_page.virt_addr;
        pde_t *evicted_pgdir = curproc->ramPages[evicted_ind].pgdir;
        pde_t *evicted_ram_pte = walkpgdir(evicted_pgdir, evicted_va, 0);
        void* evicted_pa = (void*) PTE_ADDR(evicted_ram_pte);

        // saving the evicted file content to swap file               
        memmove((void*)buffer, evicted_pa, PGSIZE);//backup content to buffer    
        writeToSwapFile(curproc, buffer, evicted_page.swap_offset, PGSIZE);
        
        // moving the page struct from ram arr to next free swap arr idx
        void *src = (void*)&curproc->ramPages[evicted_ind];
        void *dest = (void*)&curproc->swappedPages[curproc->num_swap];
        memmove(dest, src, sizeof(struct page));   // ramPages[i] = swappedPages[i]
        curproc->num_swap ++;

        // free the pyschial memory of the evicted addr
        kfree(P2V(evicted_pa));

        *evicted_ram_pte |= PTE_PG; // evicted was indeed evicted to secondary storage
        *evicted_ram_pte &= ~PTE_P; // evicted is not present anymore

        lcr3(V2P(curproc->pgdir)); // flush TLB

        struct page *newpage = &curproc->ramPages[evicted_ind];
        newpage->isused = 1;
        newpage->pgdir = pgdir;
        newpage->swap_offset = evicted_ind * PGSIZE;
        newpage->virt_addr = (char*)a;
      }
    }
  }
  return newsz;
}

uint indexToSwap()
{
  // fow now we allways return index 0
  return 0;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = p2v(pa);
      
      if(getRefs(v) == 1)
        kfree(v);
      else
        refDec(v);

      if(curproc->pid >2)
      {
          // remove page a from current proc RAM pages and swap pages
        int i;
        for(i = 0; i < MAX_PSYC_PAGES; i++)
        {
          struct page p_ram = curproc->ramPages[i];
          struct page p_swap = curproc->swappedPages[i];
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
          {
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
          }

          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
          {
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
          }
        }

      }
     
      *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
  {
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("cowuvm: no pte");
    if(!(*pte & PTE_P))
      panic("cowuvm: page not present");
    *pte |= PTE_COW;
    *pte &= ~PTE_W;
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
      goto bad;

    char *virt_addr = p2v(pa);
    refInc(virt_addr);
    invlpg((void*)i); // flush TLB
  }
  return d;

bad:
  freevm(d);
  return 0;
}

int 
getSwappedPageIndex(char* va)
{
  struct proc* curproc = myproc();
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
  {
    if(curproc->swappedPages[i].virt_addr == va)
      return i;
  }
  return -1;
}

void
pagefault()
{
  cprintf("PAGEFAULT!\n");
  struct proc* curproc = myproc();
  pte_t *pte;
  uint pa, new_pa;
  uint va = rcr2(); //  the address retreived from the cr2 register, contains pagefault addr
  uint err = curproc->tf->err;
  uint flags;
  char* new_page;
  void* ramPa;

  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
  
  // we should now do COW mechanism for kernel addresses
  if(va >= KERNBASE || (pte = walkpgdir(curproc->pgdir, start_page, 0)) == 0)
  {
    cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
    curproc->killed = 1;
    return;
  }

  if(*pte & PTE_PG) // page was paged out
  {
    new_page = kalloc();
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
    {
      pte_t *pte = walkpgdir(curproc->pgdir, start_page, 0);
      *pte |= PTE_P | PTE_W | PTE_U;
      *pte &= ~PTE_PG;
      *pte |= (uint)new_page;
      int index = getSwappedPageIndex(start_page);
      readFromSwapFile(curproc, buffer, index * PGSIZE, PGSIZE);

      int new_indx = getNextFreeRamIndex();
      void *dst = (void*)&curproc->ramPages[new_indx];
      const void *src = (void*)&curproc->swappedPages[index];
      memmove(dst, src, sizeof(struct page)); // for arrays in proc struct
      curproc->ramPages[new_indx].swap_offset = new_indx * PGSIZE; //change the swap offset by the new index


      memmove((void*)new_page, buffer, PGSIZE); // copy content from swap file to new page
      
      curproc->num_swap--;
    }
    else // no sapce in proc RAM
    {
      int index_to_evicet = indexToSwap();
      pte_t *pte = walkpgdir(curproc->pgdir, start_page, 0);              // pte of faulty page
      *pte |= PTE_P | PTE_W | PTE_U;                                      // the fauly page pte now
      *pte &= ~PTE_PG;                                                    //  now points to a newly allocated page
      *pte |= (uint)new_page;                                             //  returned from kalloc()

      
      int index = getSwappedPageIndex(start_page);                        // get the index of the fauly page from swapped pages array
      readFromSwapFile(curproc, buffer, index * PGSIZE, PGSIZE);          // buffer now has bytes from swapped page (faulty one)
      
      // get the pyshcial addr of the old ram page file
      char *old_ram_va = curproc->ramPages[index_to_evicet].virt_addr;
      pde_t *old_ram_pgdir = curproc->ramPages[index_to_evicet].pgdir;
      pte_t *old_ram_pte = walkpgdir(old_ram_pgdir, old_ram_va, 0);
      ramPa = (void*)PTE_ADDR(old_ram_pte);
      
      // prepare to-be-swapped page in RAM to move to swap file
      *old_ram_pte |= PTE_PG;                                             // turn "paged-out" flag on
      *old_ram_pte &= ~PTE_P;                                             // turn "present" flag off


      const void* src;
      void *dst;

      struct page temp;
      src = (void*)&curproc->ramPages[index_to_evicet];
      memmove(&temp, src, sizeof(struct page));                           // temp = ramPages[i]

      dst = (void*)&curproc->ramPages[index_to_evicet];
      src = (void*)&curproc->swappedPages[index];
      memmove(dst, src, sizeof(struct page));                             // ramPages[i] = swappedPages[i]

      dst = (void*)&curproc->ramPages[index_to_evicet];
      memmove(dst, &temp, sizeof(struct page));                           // swappedPages[i] = temp

      curproc->ramPages[index_to_evicet].swap_offset = index_to_evicet * PGSIZE;

      memmove((void*)new_page, buffer, PGSIZE);                           // the memory actually move from swap file to the new page

      memmove((void*)buffer, ramPa, PGSIZE);
      writeToSwapFile(curproc, buffer, index_to_evicet * PGSIZE, PGSIZE); // finally, write evicted page bytes from RAM to swpa file

      kfree(P2V(ramPa));
      lcr3(V2P(curproc->pgdir));                                          // refresh TLB
    }
    return;
  } 

  // checking that page fault caused by write
  if(err & FEC_WR)
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW)) 
    {
      curproc->killed = 1;
      return;
    }
    else
    {
      int ref_count;
      pa = PTE_ADDR(*pte);
      char *virt_addr = p2v(pa);
      flags = PTE_FLAGS(*pte);

      // get how much processes share this page (i.e referece count)
      ref_count = getRefs(virt_addr);

      if (ref_count > 1) // more than one reference
      {
        new_page = kalloc();
        //curproc->nummemorypages++;
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
        new_pa = v2p(new_page);
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
        invlpg((void*)va); // refresh TLB
        refDec(virt_addr); // decrement old page's ref count
      }
      else // ref_count = 1
      {
        *pte |= PTE_W;    // make it writeable
        *pte &= ~PTE_COW; // turn COW off
        invlpg((void *)va); // refresh TLB
      }
    }
  }

  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}

pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if(*pte & PTE_PG)
    {
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
        panic("copyuvm: mappages failed");
      continue;
    }
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0) {
      kfree(mem);
      goto bad;
    }
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)p2v(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
  {
    if(((struct page)currproc->ramPages[i]).isused != 0)
      return i;
  }
  return -1;
}
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

