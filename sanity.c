#include "types.h"
#include "stat.h"
#include "user.h"

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

void pagefult_test()
{
    // char buf[512];
    // memset(buf,0, 512);
    // printf(1,"buf[0] = %d\n", buf[0]);

    char buf[30 * 4096];
    memset(buf,0, 30 * 4096);
    printf(1,"buf[0] = %c, buf[mid] = %c, buf[end] = %c\n", buf[0], buf[4096*15], buf[4096*30 - 1]);
}

int
main()
{
    pagefult_test();
    exit();
}