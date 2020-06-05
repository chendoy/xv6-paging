#include "types.h"
#include "stat.h"
#include "user.h"

// parent allocates 10 bytes of memeory using malloc and writes 'p's all over it.
// then child writes 'c's all over it. we print both parent and child values.
// expected: parent mem: p
//           child mem: c
void test_1()
{
    char *mem;
    printf(0, "I'm parent process.\n");
    mem = malloc(10);
    memset(mem, 'p', sizeof(mem));

    if(fork() == 0) // child
    {
        printf(0, "child writing on shared memeory.\n");
        memset(mem, 'c', sizeof(mem));
        printf(0, "child mem: %c\n", mem[0]);
        exit();
    }
    else // parent
    {
        sleep(30);
        printf(0, "parent mem: %c\n", mem[0]);
        wait();
        return; 
    }
}

// free pages test. uses the getNumberOfFreePages system call as sugested in assignment 3.
// expected: getTotalFreePages() should return lower values upon writing to a shared page.
int test_2()
{
    char* mem = malloc(10);
    memset(mem, 'p', sizeof(mem));

    if(fork() == 0) // child
    {
        printf(0, "total free pages: %d\n", getTotalFreePages());
        mem[0] = 'c';
        printf(0, "total free pages: %d\n", getTotalFreePages());
        exit();
    }
    sleep(30);
    wait();
    return 0;
}

int main()
{
    // test_1();
    test_1();
    exit();
}