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



void free_pages_with_swap_test1()
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

void pagefault_cow_test(void)
{
    int pid;
    int len = 13 * PGSIZE;
    char *arr = (char*)malloc(len);
    memset((void*)arr, '0', len); // will cause some pagefaults
    if((pid = fork()) == 0) // child
    {
        printf(1, "child: writing \'1\'s arr\n");
        memset((void*)arr, '1', len);
        exit();
    }
    else // parent
    {
        wait();
        printf(1, "parent: arr[0]: %c (should be \'0\')\n" ,arr[0]);
        printf(1, "parent: arr[1000]: %c (should be \'0\')\n",arr[1000]);
        return;
    }
}



void cow_refs_test(void)
{
    int pid;
    int len = 8 * PGSIZE;
    char *arr = (char*)malloc(len);
    memset((void*)arr, '0', len); // will cause some pagefaults
    if((pid = fork()) == 0) // child
    {
        printf(1, "before child write on arr num ref of rampage[%d] is : %d\n",6 , getNumRefs(6));
        memset((void*)arr, '1', len);
        printf(1, "after child write on arr num ref of rampage[%d] is : %d\n",6, getNumRefs(6));
        exit();
    }
    else // parent
    {
        wait();
        return;
    }
}


void num_pages_test()
{
  char* oldbrk = sbrk(0);
  int pid;
  char *a, *b, *c;
  // int fds[2], pids[10], ppid;
  // char *lastaddr, *oldbrk, scratch;

  printf(1, "sbrk test\n");

  printf(1, "allocating 10 pages, should not write to swap\n");
  a = sbrk(0);
  int i;
  for(i = 0; i < 12; i++){
    b = sbrk(PGSIZE);
    printf(1, "%x -> ", b);
    if(b != a){
      exit();
    }
    *b = 1;
    a = b + PGSIZE;
  }
  printf(1, "\ncreating child process\n");
  pid = fork();
  if(pid < 0){
    printf(1, "sbrk test fork failed\n");
    exit();
  }
  if(pid > 0) // parent will writeToSwapFile
  {
    int ramPagesBefore = getNumberOfFreePages();
    c = sbrk(PGSIZE);
    if(c != a){
      printf(1, "sbrk test failed post-fork\n");
      exit();
    }
    int ramPagesAfter = getNumberOfFreePages();
    printf(1, "parent: %d should be equal to %d\n", ramPagesBefore, ramPagesAfter);
  }
  if(pid == 0)
    exit();
  wait();

  printf(1, "*********************************\n");

  // can one de-allocate?
  a = sbrk(0);
  c = sbrk(-4096);
  if(c == (char*)0xffffffff){
    printf(1, "sbrk could not deallocate\n");
    exit();
  }
  printf(1, "*********************************\n");
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

  char *curbrk = sbrk(0);
  int size = curbrk - oldbrk;
  printf(1, "proc size in bytes: %d, in pages: %d\n", size, size / PGSIZE);
  printf(1, "filling mem with junk (should not cause pagefaults)\n");
  memset((void*)oldbrk, '1', size);
  memset((void*)oldbrk, '$', size);
  memset((void*)oldbrk, 3, size);

  printf(1, "*********************************\n");

  printf(1, "alocating 3 more pages up to limit (16) - should cause 3 swaps\n");
  sbrk(3 * PGSIZE);
  curbrk = sbrk(0);
  size = curbrk - oldbrk;

  printf(1, "proc size in bytes: %d, in pages: %d\n", size, size / PGSIZE);

  return;
}

void free_pages_test()
{
    printf(1, "num of free pages is: %d\n", getNumberOfFreePages());
    int len =  10 * PGSIZE;
    char *arr = sbrk(len);
    arr++;
    printf(1, "cur num of free pages shold be old-10: %d\n", getNumberOfFreePages());
}

void free_pages_with_swap_test2()
{
    int init_free = getNumberOfFreePages();
    printf(1, "init free pages: %d\n", init_free);
    sbrk(9 * PGSIZE);
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
    sbrk(3 * PGSIZE);
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
    sbrk(1 * PGSIZE);
    printf(1, "allocated 1 more file, will swap page to disk.  <should be: %d> <actually: %d> \n", init_free-12, getNumberOfFreePages());   
}

void allocate_more_than_MaxPages_test()
{
   printf(1, "sbrk res: %d\n", (sbrk(29 * PGSIZE)));
   
}

int
main(void)
{
    // simple_fork_test();
    // pagefault_test();
    // free_pages_test();
    // num_pages_test();

    // pagefault_cow_test();
    cow_refs_test();
    // free_pages_with_swap_test1();
    // free_pages_with_swap_test2();
    // allocate_more_than_MaxPages_test();
    exit();
}