#include "types.h"
#include "stat.h"
#include "user.h"

char buf[7 * 4096];

void simple_printf_test()
{
   printf(1, "sanity test!\n");
}

void simple_buffer_test()
{
    char buf[1024];
    buf[0] = 'a';
    buf[512] = 'b';
    buf[1023] = 'c';
    printf(1, "buf[0] = %c, buf[512] = %c, buf[1023] = %c\n", buf[0], buf[512], buf[1023]);
}

void simple_fork_test()
{
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
    memset(buf, 'a', 7 * 4096);
    printf(1, "buf[0] = %c, buf[mid] = %c, buf[end] = %c\n", buf[0], buf[4 * 4096 - 1], buf[7 * 4096 - 1]);
    return;
}

int
main()
{
    pagefault_test();
    exit();
}