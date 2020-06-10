#include "types.h"
#include "stat.h"
#include "user.h"

#define PGSIZE 4096

// ----------- aNg -----------
void read_mem(const char *mem) {
    printf(1, "read: mem[0]=%d , mem[1000]=%d\n", (int)mem[0], (int)mem[1000]);
}
// ----------- aNg -----------

void simple_buffer_test()
{
    printf(1, "\n-------- simple_buffer_test --------\n");
    char buf[1024];
    buf[0] = 'a';
    buf[512] = 'b';
    buf[1023] = 'c';
    printf(1, "buf[0] = %c, buf[512] = %c, buf[1023] = %c\n", buf[0], buf[512], buf[1023]);
}

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


void cow_test_aNg(void) {
    printf(1, "-- cow test --\n");

    printf(1, "malloc and set to zero...\n");
    char *mem = (char*)malloc(PGSIZE);
    for(int i = 0; i < PGSIZE; i++)
        mem[i] = 0;

    int pid = fork();
    if(pid == 0) { // child
        printf(1, "child (%d): writing to allocated memory...\n", getpid());
        mem[0] = 0x1;
        mem[1000] = 0x1;
        sleep(200);
        printf(1, "child (%d): ", getpid());
        read_mem(mem);
        exit();
    }
    else {
        sleep(100);
        printf(1, "parent (%d): ", getpid());
        read_mem(mem);
        printf(1, "parent (%d): writing to allocated memory...\n", getpid());
        mem[0] = 0x2;
        mem[1000] = 0x2;
        wait();
    }
}

void page_test_aNg(void) {
    printf(1, "\n-- page test --\n");
    
    printf(1, "getfp: %d\n", getNumberOfFreePages());
    char *mem = (char*)malloc(PGSIZE * 5);
    *mem=1;
    printf(1, "getfp: %d\n"), getNumberOfFreePages();
    free(mem);
    printf(1, "getfp: %d\n", getNumberOfFreePages());
}


int
main(void)
{
    // simple_buffer_test();
    // simple_fork_test();
    // pagefault_test();
    // pagefault_cow();
    // cow_test_aNg();
    page_test_aNg();

    exit();
}