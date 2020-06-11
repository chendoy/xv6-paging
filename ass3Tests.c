#include "types.h"
#include "stat.h"
#include "user.h"
#include "memlayout.h"

#define PGSIZE 4096

void simple_fork_test()
{
    printf(1, "\n-------- simple_fork_test --------\n");
    int pid;
    
    pid = fork();
    if(pid == 0) // child
    {
        printf(1, "I'm child!\n");
        exit();
    } 
    else // parent
    {
        sleep(20);
        printf(1, "I'm parent!\n");
        wait();
        return;
    }
}

void free_pages_test()
{
    printf(1, "num of free pages is: %d\n", getNumberOfFreePages());
    int len =  10 * PGSIZE;
    char *arr = sbrk(len);
    arr++;
    printf(1, "cur num of free pages shold be old-10: %d\n", getNumberOfFreePages());
}

void free_pages_with_swap_test()
{
    int init_free = getNumberOfFreePages();
    printf(1, "init free pages: %d\n", init_free);
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
    printf(1, "a %d\n", (sbrk(3 * PGSIZE)));
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
    printf(1, "sbrk res: %d\n", (sbrk(1 * PGSIZE)));
    printf(1, "allocated 1 more file, will swap page to disk.  <should be: %d> <actually: %d> \n", init_free-12, getNumberOfFreePages());   
}


void pagefault_test()
{
    // printf(1, "\n-------- pagefault_test --------\n");
    int len = 15 * PGSIZE;
    char *arr = (char*)malloc(len);
    memset((void*)arr, '0', len);
    // memset((void*)arr, '1', len);
    // memset((void*)arr, '2', len);
    // arr[len / 2 - 1] = '2';
    printf(1,"arr[0]: %c\n", arr[0]); 
    printf(1,"arr[0]: %c\n", arr[len/2]); 
    printf(1,"arr[0]: %c\n", arr[len-1]); 
    return;
}

void pagefault_cow(void)
{
    int pid;
    int len = 15 * PGSIZE;
    char *arr = (char*)malloc(len);
    memset((void*)arr, '0', len); // will cause some pagefaults
    printf(1,"before fork num swap file: \n");
    if((pid = fork()) == 0) // child
    {
        printf(1, "child: writing \'1\'s arr\n");
        memset((void*)arr, '1', len);
        exit();
    }
    else // parent
    {
        printf(1, "parent: arr[0]: %c (should be \'0\')\n" ,arr[0]);
        printf(1, "parent: arr[1000]: %c (should be \'0\')\n",arr[1000]);
        wait();
        return;
    }

}

void sbrk_test()
{
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(1, "sbrk test\n");
  oldbrk = sbrk(0);

  // can one sbrk() less than a page?
  a = sbrk(0);
  printf(1, "%x -> ", a);
  int i;
  for(i = 0; i < 16; i++){
    b = sbrk(1);
    printf(1, "%x -> ", b);
    if(b != a){
      exit();
    }
    *b = 1;
    a = b + 1;
  }
  printf(1, "before fork\n");
  pid = fork();
  if(pid < 0){
    printf(1, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
  c = sbrk(1);
  if(c != a + 1){
    printf(1, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    exit();
  wait();

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
  amt = (BIG) - (uint)a;
  p = sbrk(amt);
  if (p != a) {
    printf(1, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;

  // can one de-allocate?
  a = sbrk(0);
  c = sbrk(-4096);
  if(c == (char*)0xffffffff){
    printf(1, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
  if(c != a - 4096){
    printf(1, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
  c = sbrk(4096);
  if(c != a || sbrk(0) != a + 4096){
    printf(1, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    // should be zero
    printf(1, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
  c = sbrk(-(sbrk(0) - oldbrk));
  if(c != a){
    printf(1, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    ppid = getpid();
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
      exit();
    }
    if(pid == 0){
      printf(1, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
      write(fds[1], "x", 1);
      // sit around until killed
      for(;;) sleep(1000);
    }
    if(pids[i] != -1)
      read(fds[0], &scratch, 1);
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    if(pids[i] == -1)
      continue;
    kill(pids[i]);
    wait();
  }
  if(c == (char*)0xffffffff){
    printf(1, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    sbrk(-(sbrk(0) - oldbrk));

  printf(1, "sbrk test OK\n");
  return;
}


int
main(void)
{
    // simple_fork_test();
    // pagefault_test();
    // pagefault_cow();
    // sbrk_test();
    // free_pages_test();
    free_pages_with_swap_test();
    exit();
}