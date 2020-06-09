#include "types.h"
#include "stat.h"
#include "user.h"

#define PGSIZE 4096

void simple_printf_test()
{
    printf(1, "\n-------- simple_printf_test --------\n");
   printf(1, "sanity test!\n");
}

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

    if((pid = fork()) == 0) // child
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
    int len = 28 * PGSIZE;
    char *arr = (char*)malloc(len);
    arr++;
    memset((void*)arr, '0', len);
    // memset((void*)arr, '1', len);
    // memset((void*)arr, '2', len);
    // arr[len / 2 - 1] = '2';
    // arr[0] = '3';
    return;
}

int
main(void)
{
    // simple_printf_test();
    // simple_buffer_test();
    // simple_fork_test();
    pagefault_test();
    exit();
}