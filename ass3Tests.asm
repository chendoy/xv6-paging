
_ass3Tests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   
}

int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
    // pagefault_test();
    // free_pages_test();
    // num_pages_test();

    // pagefault_cow_test();
    cow_refs_test();
   a:	e8 71 02 00 00       	call   280 <cow_refs_test>
    // free_pages_with_swap_test1();
    // free_pages_with_swap_test2();
    // allocate_more_than_MaxPages_test();
    exit();
   f:	e8 0f 09 00 00       	call   923 <exit>
  14:	66 90                	xchg   %ax,%ax
  16:	66 90                	xchg   %ax,%ax
  18:	66 90                	xchg   %ax,%ax
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <simple_fork_test>:
{
  20:	f3 0f 1e fb          	endbr32 
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_fork_test --------\n");
  2a:	68 f8 0d 00 00       	push   $0xdf8
  2f:	6a 01                	push   $0x1
  31:	e8 5a 0a 00 00       	call   a90 <printf>
    pid = fork();
  36:	e8 e0 08 00 00       	call   91b <fork>
    if(pid == 0) // child
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	85 c0                	test   %eax,%eax
  40:	74 21                	je     63 <simple_fork_test+0x43>
        sleep(20);
  42:	83 ec 0c             	sub    $0xc,%esp
  45:	6a 14                	push   $0x14
  47:	e8 67 09 00 00       	call   9b3 <sleep>
        printf(1, "I'm parent!\n");
  4c:	58                   	pop    %eax
  4d:	5a                   	pop    %edx
  4e:	68 53 11 00 00       	push   $0x1153
  53:	6a 01                	push   $0x1
  55:	e8 36 0a 00 00       	call   a90 <printf>
        wait();
  5a:	83 c4 10             	add    $0x10,%esp
}
  5d:	c9                   	leave  
        wait();
  5e:	e9 c8 08 00 00       	jmp    92b <wait>
        printf(1, "I'm child!\n");
  63:	51                   	push   %ecx
  64:	51                   	push   %ecx
  65:	68 47 11 00 00       	push   $0x1147
  6a:	6a 01                	push   $0x1
  6c:	e8 1f 0a 00 00       	call   a90 <printf>
        exit();
  71:	e8 ad 08 00 00       	call   923 <exit>
  76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  7d:	8d 76 00             	lea    0x0(%esi),%esi

00000080 <free_pages_with_swap_test1>:
{
  80:	f3 0f 1e fb          	endbr32 
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	53                   	push   %ebx
  88:	83 ec 04             	sub    $0x4,%esp
    int init_free = getNumberOfFreePages();
  8b:	e8 33 09 00 00       	call   9c3 <getNumberOfFreePages>
    printf(1, "init free pages: %d\n", init_free);
  90:	83 ec 04             	sub    $0x4,%esp
  93:	50                   	push   %eax
    int init_free = getNumberOfFreePages();
  94:	89 c3                	mov    %eax,%ebx
    printf(1, "init free pages: %d\n", init_free);
  96:	68 60 11 00 00       	push   $0x1160
  9b:	6a 01                	push   $0x1
  9d:	e8 ee 09 00 00       	call   a90 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
  a2:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
  a9:	e8 fd 08 00 00       	call   9ab <sbrk>
  ae:	83 c4 0c             	add    $0xc,%esp
  b1:	50                   	push   %eax
  b2:	68 75 11 00 00       	push   $0x1175
  b7:	6a 01                	push   $0x1
  b9:	e8 d2 09 00 00       	call   a90 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
  be:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
  c5:	e8 e1 08 00 00       	call   9ab <sbrk>
  ca:	83 c4 0c             	add    $0xc,%esp
  cd:	50                   	push   %eax
  ce:	68 75 11 00 00       	push   $0x1175
  d3:	6a 01                	push   $0x1
  d5:	e8 b6 09 00 00       	call   a90 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
  da:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
  e1:	e8 c5 08 00 00       	call   9ab <sbrk>
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	50                   	push   %eax
  ea:	68 75 11 00 00       	push   $0x1175
  ef:	6a 01                	push   $0x1
  f1:	e8 9a 09 00 00       	call   a90 <printf>
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
  f6:	e8 c8 08 00 00       	call   9c3 <getNumberOfFreePages>
  fb:	50                   	push   %eax
  fc:	8d 43 f7             	lea    -0x9(%ebx),%eax
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
  ff:	83 eb 0c             	sub    $0xc,%ebx
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
 102:	50                   	push   %eax
 103:	68 20 0e 00 00       	push   $0xe20
 108:	6a 01                	push   $0x1
 10a:	e8 81 09 00 00       	call   a90 <printf>
    printf(1, "a %d\n", (sbrk(3 * PGSIZE)));
 10f:	83 c4 14             	add    $0x14,%esp
 112:	68 00 30 00 00       	push   $0x3000
 117:	e8 8f 08 00 00       	call   9ab <sbrk>
 11c:	83 c4 0c             	add    $0xc,%esp
 11f:	50                   	push   %eax
 120:	68 83 11 00 00       	push   $0x1183
 125:	6a 01                	push   $0x1
 127:	e8 64 09 00 00       	call   a90 <printf>
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
 12c:	e8 92 08 00 00       	call   9c3 <getNumberOfFreePages>
 131:	50                   	push   %eax
 132:	53                   	push   %ebx
 133:	68 54 0e 00 00       	push   $0xe54
 138:	6a 01                	push   $0x1
 13a:	e8 51 09 00 00       	call   a90 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(1 * PGSIZE)));
 13f:	83 c4 14             	add    $0x14,%esp
 142:	68 00 10 00 00       	push   $0x1000
 147:	e8 5f 08 00 00       	call   9ab <sbrk>
 14c:	83 c4 0c             	add    $0xc,%esp
 14f:	50                   	push   %eax
 150:	68 75 11 00 00       	push   $0x1175
 155:	6a 01                	push   $0x1
 157:	e8 34 09 00 00       	call   a90 <printf>
    printf(1, "allocated 1 more file, will swap page to disk.  <should be: %d> <actually: %d> \n", init_free-12, getNumberOfFreePages());   
 15c:	e8 62 08 00 00       	call   9c3 <getNumberOfFreePages>
 161:	50                   	push   %eax
 162:	53                   	push   %ebx
 163:	68 8c 0e 00 00       	push   $0xe8c
 168:	6a 01                	push   $0x1
 16a:	e8 21 09 00 00       	call   a90 <printf>
}
 16f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 172:	83 c4 20             	add    $0x20,%esp
 175:	c9                   	leave  
 176:	c3                   	ret    
 177:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17e:	66 90                	xchg   %ax,%ax

00000180 <pagefault_test>:
{
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	53                   	push   %ebx
 188:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 18b:	68 00 f0 00 00       	push   $0xf000
 190:	e8 5b 0b 00 00       	call   cf0 <malloc>
    memset((void*)arr, '0', len);
 195:	83 c4 0c             	add    $0xc,%esp
 198:	68 00 f0 00 00       	push   $0xf000
    char *arr = (char*)malloc(len);
 19d:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len);
 19f:	6a 30                	push   $0x30
 1a1:	50                   	push   %eax
 1a2:	e8 d9 05 00 00       	call   780 <memset>
    printf(1,"arr[0]: %c\n", arr[0]); 
 1a7:	0f be 03             	movsbl (%ebx),%eax
 1aa:	83 c4 0c             	add    $0xc,%esp
 1ad:	50                   	push   %eax
 1ae:	68 89 11 00 00       	push   $0x1189
 1b3:	6a 01                	push   $0x1
 1b5:	e8 d6 08 00 00       	call   a90 <printf>
    printf(1,"arr[0]: %c\n", arr[len/2]); 
 1ba:	0f be 83 00 78 00 00 	movsbl 0x7800(%ebx),%eax
 1c1:	83 c4 0c             	add    $0xc,%esp
 1c4:	50                   	push   %eax
 1c5:	68 89 11 00 00       	push   $0x1189
 1ca:	6a 01                	push   $0x1
 1cc:	e8 bf 08 00 00       	call   a90 <printf>
    printf(1,"arr[0]: %c\n", arr[len-1]); 
 1d1:	0f be 83 ff ef 00 00 	movsbl 0xefff(%ebx),%eax
 1d8:	83 c4 0c             	add    $0xc,%esp
 1db:	50                   	push   %eax
 1dc:	68 89 11 00 00       	push   $0x1189
 1e1:	6a 01                	push   $0x1
 1e3:	e8 a8 08 00 00       	call   a90 <printf>
}
 1e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return;
 1eb:	83 c4 10             	add    $0x10,%esp
}
 1ee:	c9                   	leave  
 1ef:	c3                   	ret    

000001f0 <pagefault_cow_test>:
{
 1f0:	f3 0f 1e fb          	endbr32 
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	53                   	push   %ebx
 1f8:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 1fb:	68 00 d0 00 00       	push   $0xd000
 200:	e8 eb 0a 00 00       	call   cf0 <malloc>
    memset((void*)arr, '0', len); // will cause some pagefaults
 205:	83 c4 0c             	add    $0xc,%esp
 208:	68 00 d0 00 00       	push   $0xd000
    char *arr = (char*)malloc(len);
 20d:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len); // will cause some pagefaults
 20f:	6a 30                	push   $0x30
 211:	50                   	push   %eax
 212:	e8 69 05 00 00       	call   780 <memset>
    if((pid = fork()) == 0) // child
 217:	e8 ff 06 00 00       	call   91b <fork>
 21c:	83 c4 10             	add    $0x10,%esp
 21f:	85 c0                	test   %eax,%eax
 221:	74 37                	je     25a <pagefault_cow_test+0x6a>
        wait();
 223:	e8 03 07 00 00       	call   92b <wait>
        printf(1, "parent: arr[0]: %c (should be \'0\')\n" ,arr[0]);
 228:	0f be 03             	movsbl (%ebx),%eax
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	50                   	push   %eax
 22f:	68 e0 0e 00 00       	push   $0xee0
 234:	6a 01                	push   $0x1
 236:	e8 55 08 00 00       	call   a90 <printf>
        printf(1, "parent: arr[1000]: %c (should be \'0\')\n",arr[1000]);
 23b:	0f be 83 e8 03 00 00 	movsbl 0x3e8(%ebx),%eax
 242:	83 c4 0c             	add    $0xc,%esp
 245:	50                   	push   %eax
 246:	68 04 0f 00 00       	push   $0xf04
 24b:	6a 01                	push   $0x1
 24d:	e8 3e 08 00 00       	call   a90 <printf>
}
 252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        return;
 255:	83 c4 10             	add    $0x10,%esp
}
 258:	c9                   	leave  
 259:	c3                   	ret    
        printf(1, "child: writing \'1\'s arr\n");
 25a:	50                   	push   %eax
 25b:	50                   	push   %eax
 25c:	68 95 11 00 00       	push   $0x1195
 261:	6a 01                	push   $0x1
 263:	e8 28 08 00 00       	call   a90 <printf>
        memset((void*)arr, '1', len);
 268:	83 c4 0c             	add    $0xc,%esp
 26b:	68 00 d0 00 00       	push   $0xd000
 270:	6a 31                	push   $0x31
 272:	53                   	push   %ebx
 273:	e8 08 05 00 00       	call   780 <memset>
        exit();
 278:	e8 a6 06 00 00       	call   923 <exit>
 27d:	8d 76 00             	lea    0x0(%esi),%esi

00000280 <cow_refs_test>:
{
 280:	f3 0f 1e fb          	endbr32 
 284:	55                   	push   %ebp
 285:	89 e5                	mov    %esp,%ebp
 287:	53                   	push   %ebx
 288:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 28b:	68 00 80 00 00       	push   $0x8000
 290:	e8 5b 0a 00 00       	call   cf0 <malloc>
    memset((void*)arr, '0', len); // will cause some pagefaults
 295:	83 c4 0c             	add    $0xc,%esp
 298:	68 00 80 00 00       	push   $0x8000
    char *arr = (char*)malloc(len);
 29d:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len); // will cause some pagefaults
 29f:	6a 30                	push   $0x30
 2a1:	50                   	push   %eax
 2a2:	e8 d9 04 00 00       	call   780 <memset>
    if((pid = fork()) == 0) // child
 2a7:	e8 6f 06 00 00       	call   91b <fork>
 2ac:	83 c4 10             	add    $0x10,%esp
 2af:	85 c0                	test   %eax,%eax
 2b1:	74 09                	je     2bc <cow_refs_test+0x3c>
}
 2b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b6:	c9                   	leave  
        wait();
 2b7:	e9 6f 06 00 00       	jmp    92b <wait>
        printf(1, "before child write on arr num ref of rampage[%d] is : %d\n",6 , getNumRefs(6));
 2bc:	83 ec 0c             	sub    $0xc,%esp
 2bf:	6a 06                	push   $0x6
 2c1:	e8 05 07 00 00       	call   9cb <getNumRefs>
 2c6:	50                   	push   %eax
 2c7:	6a 06                	push   $0x6
 2c9:	68 2c 0f 00 00       	push   $0xf2c
 2ce:	6a 01                	push   $0x1
 2d0:	e8 bb 07 00 00       	call   a90 <printf>
        memset((void*)arr, '1', len);
 2d5:	83 c4 1c             	add    $0x1c,%esp
 2d8:	68 00 80 00 00       	push   $0x8000
 2dd:	6a 31                	push   $0x31
 2df:	53                   	push   %ebx
 2e0:	e8 9b 04 00 00       	call   780 <memset>
        printf(1, "after child write on arr num ref of rampage[%d] is : %d\n",6, getNumRefs(6));
 2e5:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
 2ec:	e8 da 06 00 00       	call   9cb <getNumRefs>
 2f1:	50                   	push   %eax
 2f2:	6a 06                	push   $0x6
 2f4:	68 68 0f 00 00       	push   $0xf68
 2f9:	6a 01                	push   $0x1
 2fb:	e8 90 07 00 00       	call   a90 <printf>
        exit();
 300:	83 c4 20             	add    $0x20,%esp
 303:	e8 1b 06 00 00       	call   923 <exit>
 308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30f:	90                   	nop

00000310 <num_pages_test>:
{
 310:	f3 0f 1e fb          	endbr32 
 314:	55                   	push   %ebp
 315:	89 e5                	mov    %esp,%ebp
 317:	57                   	push   %edi
 318:	56                   	push   %esi
  a = sbrk(0);
 319:	be 0c 00 00 00       	mov    $0xc,%esi
{
 31e:	53                   	push   %ebx
 31f:	83 ec 28             	sub    $0x28,%esp
  char* oldbrk = sbrk(0);
 322:	6a 00                	push   $0x0
 324:	e8 82 06 00 00       	call   9ab <sbrk>
 329:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  printf(1, "sbrk test\n");
 32c:	58                   	pop    %eax
 32d:	5a                   	pop    %edx
 32e:	68 ae 11 00 00       	push   $0x11ae
 333:	6a 01                	push   $0x1
 335:	e8 56 07 00 00       	call   a90 <printf>
  printf(1, "allocating 10 pages, should not write to swap\n");
 33a:	59                   	pop    %ecx
 33b:	5b                   	pop    %ebx
 33c:	68 a4 0f 00 00       	push   $0xfa4
 341:	6a 01                	push   $0x1
 343:	e8 48 07 00 00       	call   a90 <printf>
  a = sbrk(0);
 348:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 34f:	e8 57 06 00 00       	call   9ab <sbrk>
 354:	83 c4 10             	add    $0x10,%esp
 357:	89 c7                	mov    %eax,%edi
  for(i = 0; i < 12; i++){
 359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    b = sbrk(PGSIZE);
 360:	83 ec 0c             	sub    $0xc,%esp
 363:	68 00 10 00 00       	push   $0x1000
 368:	e8 3e 06 00 00       	call   9ab <sbrk>
    printf(1, "%x -> ", b);
 36d:	83 c4 0c             	add    $0xc,%esp
 370:	50                   	push   %eax
    b = sbrk(PGSIZE);
 371:	89 c3                	mov    %eax,%ebx
    printf(1, "%x -> ", b);
 373:	68 b9 11 00 00       	push   $0x11b9
 378:	6a 01                	push   $0x1
 37a:	e8 11 07 00 00       	call   a90 <printf>
    if(b != a){
 37f:	83 c4 10             	add    $0x10,%esp
 382:	39 fb                	cmp    %edi,%ebx
 384:	75 2f                	jne    3b5 <num_pages_test+0xa5>
    *b = 1;
 386:	c6 07 01             	movb   $0x1,(%edi)
    a = b + PGSIZE;
 389:	81 c7 00 10 00 00    	add    $0x1000,%edi
  for(i = 0; i < 12; i++){
 38f:	83 ee 01             	sub    $0x1,%esi
 392:	75 cc                	jne    360 <num_pages_test+0x50>
  printf(1, "\ncreating child process\n");
 394:	83 ec 08             	sub    $0x8,%esp
 397:	68 c0 11 00 00       	push   $0x11c0
 39c:	6a 01                	push   $0x1
 39e:	e8 ed 06 00 00       	call   a90 <printf>
  pid = fork();
 3a3:	e8 73 05 00 00       	call   91b <fork>
  if(pid < 0){
 3a8:	83 c4 10             	add    $0x10,%esp
 3ab:	85 c0                	test   %eax,%eax
 3ad:	0f 88 b0 01 00 00    	js     563 <num_pages_test+0x253>
  if(pid > 0) // parent will writeToSwapFile
 3b3:	75 0b                	jne    3c0 <num_pages_test+0xb0>
      exit();
 3b5:	e8 69 05 00 00       	call   923 <exit>
 3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    int ramPagesBefore = getNumberOfFreePages();
 3c0:	e8 fe 05 00 00       	call   9c3 <getNumberOfFreePages>
    c = sbrk(PGSIZE);
 3c5:	83 ec 0c             	sub    $0xc,%esp
 3c8:	68 00 10 00 00       	push   $0x1000
    int ramPagesBefore = getNumberOfFreePages();
 3cd:	89 c3                	mov    %eax,%ebx
    c = sbrk(PGSIZE);
 3cf:	e8 d7 05 00 00       	call   9ab <sbrk>
    if(c != a){
 3d4:	83 c4 10             	add    $0x10,%esp
 3d7:	39 c7                	cmp    %eax,%edi
 3d9:	0f 85 97 01 00 00    	jne    576 <num_pages_test+0x266>
    int ramPagesAfter = getNumberOfFreePages();
 3df:	e8 df 05 00 00       	call   9c3 <getNumberOfFreePages>
    printf(1, "parent: %d should be equal to %d\n", ramPagesBefore, ramPagesAfter);
 3e4:	50                   	push   %eax
 3e5:	53                   	push   %ebx
 3e6:	68 d4 0f 00 00       	push   $0xfd4
 3eb:	6a 01                	push   $0x1
 3ed:	e8 9e 06 00 00       	call   a90 <printf>
  wait();
 3f2:	e8 34 05 00 00       	call   92b <wait>
  printf(1, "*********************************\n");
 3f7:	5f                   	pop    %edi
 3f8:	58                   	pop    %eax
 3f9:	68 f8 0f 00 00       	push   $0xff8
 3fe:	6a 01                	push   $0x1
 400:	e8 8b 06 00 00       	call   a90 <printf>
  a = sbrk(0);
 405:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 40c:	e8 9a 05 00 00       	call   9ab <sbrk>
  c = sbrk(-4096);
 411:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
 418:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
 41a:	e8 8c 05 00 00       	call   9ab <sbrk>
  if(c == (char*)0xffffffff){
 41f:	83 c4 10             	add    $0x10,%esp
 422:	83 f8 ff             	cmp    $0xffffffff,%eax
 425:	0f 84 5e 01 00 00    	je     589 <num_pages_test+0x279>
  printf(1, "*********************************\n");
 42b:	83 ec 08             	sub    $0x8,%esp
 42e:	68 f8 0f 00 00       	push   $0xff8
 433:	6a 01                	push   $0x1
 435:	e8 56 06 00 00       	call   a90 <printf>
  c = sbrk(0);
 43a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 441:	e8 65 05 00 00       	call   9ab <sbrk>
  if(c != a - 4096){
 446:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
 44c:	83 c4 10             	add    $0x10,%esp
 44f:	39 d0                	cmp    %edx,%eax
 451:	0f 85 45 01 00 00    	jne    59c <num_pages_test+0x28c>
  a = sbrk(0);
 457:	83 ec 0c             	sub    $0xc,%esp
 45a:	6a 00                	push   $0x0
 45c:	e8 4a 05 00 00       	call   9ab <sbrk>
  c = sbrk(4096);
 461:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
 468:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
 46a:	e8 3c 05 00 00       	call   9ab <sbrk>
  if(c != a || sbrk(0) != a + 4096){
 46f:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
 472:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
 474:	39 c3                	cmp    %eax,%ebx
 476:	0f 85 d4 00 00 00    	jne    550 <num_pages_test+0x240>
 47c:	83 ec 0c             	sub    $0xc,%esp
 47f:	6a 00                	push   $0x0
 481:	e8 25 05 00 00       	call   9ab <sbrk>
 486:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	39 c2                	cmp    %eax,%edx
 491:	0f 85 b9 00 00 00    	jne    550 <num_pages_test+0x240>
  char *curbrk = sbrk(0);
 497:	83 ec 0c             	sub    $0xc,%esp
 49a:	6a 00                	push   $0x0
 49c:	e8 0a 05 00 00       	call   9ab <sbrk>
  int size = curbrk - oldbrk;
 4a1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
 4a4:	29 f0                	sub    %esi,%eax
 4a6:	89 c3                	mov    %eax,%ebx
  printf(1, "proc size in bytes: %d, in pages: %d\n", size, size / PGSIZE);
 4a8:	8d 80 ff 0f 00 00    	lea    0xfff(%eax),%eax
 4ae:	0f 49 c3             	cmovns %ebx,%eax
 4b1:	c1 f8 0c             	sar    $0xc,%eax
 4b4:	50                   	push   %eax
 4b5:	53                   	push   %ebx
 4b6:	68 7c 10 00 00       	push   $0x107c
 4bb:	6a 01                	push   $0x1
 4bd:	e8 ce 05 00 00       	call   a90 <printf>
  printf(1, "filling mem with junk (should not cause pagefaults)\n");
 4c2:	83 c4 18             	add    $0x18,%esp
 4c5:	68 a4 10 00 00       	push   $0x10a4
 4ca:	6a 01                	push   $0x1
 4cc:	e8 bf 05 00 00       	call   a90 <printf>
  memset((void*)oldbrk, '1', size);
 4d1:	83 c4 0c             	add    $0xc,%esp
 4d4:	53                   	push   %ebx
 4d5:	6a 31                	push   $0x31
 4d7:	56                   	push   %esi
 4d8:	e8 a3 02 00 00       	call   780 <memset>
  memset((void*)oldbrk, '$', size);
 4dd:	83 c4 0c             	add    $0xc,%esp
 4e0:	53                   	push   %ebx
 4e1:	6a 24                	push   $0x24
 4e3:	56                   	push   %esi
 4e4:	e8 97 02 00 00       	call   780 <memset>
  memset((void*)oldbrk, 3, size);
 4e9:	83 c4 0c             	add    $0xc,%esp
 4ec:	53                   	push   %ebx
 4ed:	6a 03                	push   $0x3
 4ef:	56                   	push   %esi
 4f0:	e8 8b 02 00 00       	call   780 <memset>
  printf(1, "*********************************\n");
 4f5:	58                   	pop    %eax
 4f6:	5a                   	pop    %edx
 4f7:	68 f8 0f 00 00       	push   $0xff8
 4fc:	6a 01                	push   $0x1
 4fe:	e8 8d 05 00 00       	call   a90 <printf>
  printf(1, "alocating 3 more pages up to limit (16) - should cause 3 swaps\n");
 503:	59                   	pop    %ecx
 504:	5b                   	pop    %ebx
 505:	68 dc 10 00 00       	push   $0x10dc
 50a:	6a 01                	push   $0x1
 50c:	e8 7f 05 00 00       	call   a90 <printf>
  sbrk(3 * PGSIZE);
 511:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
 518:	e8 8e 04 00 00       	call   9ab <sbrk>
  curbrk = sbrk(0);
 51d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 524:	e8 82 04 00 00       	call   9ab <sbrk>
  size = curbrk - oldbrk;
 529:	29 f0                	sub    %esi,%eax
  printf(1, "proc size in bytes: %d, in pages: %d\n", size, size / PGSIZE);
 52b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
 531:	0f 49 d0             	cmovns %eax,%edx
 534:	c1 fa 0c             	sar    $0xc,%edx
 537:	52                   	push   %edx
 538:	50                   	push   %eax
 539:	68 7c 10 00 00       	push   $0x107c
 53e:	6a 01                	push   $0x1
 540:	e8 4b 05 00 00       	call   a90 <printf>
  return;
 545:	83 c4 20             	add    $0x20,%esp
}
 548:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54b:	5b                   	pop    %ebx
 54c:	5e                   	pop    %esi
 54d:	5f                   	pop    %edi
 54e:	5d                   	pop    %ebp
 54f:	c3                   	ret    
    printf(1, "sbrk re-allocation failed, a %x c %x\n", a, c);
 550:	56                   	push   %esi
 551:	53                   	push   %ebx
 552:	68 54 10 00 00       	push   $0x1054
 557:	6a 01                	push   $0x1
 559:	e8 32 05 00 00       	call   a90 <printf>
    exit();
 55e:	e8 c0 03 00 00       	call   923 <exit>
    printf(1, "sbrk test fork failed\n");
 563:	50                   	push   %eax
 564:	50                   	push   %eax
 565:	68 d9 11 00 00       	push   $0x11d9
 56a:	6a 01                	push   $0x1
 56c:	e8 1f 05 00 00       	call   a90 <printf>
    exit();
 571:	e8 ad 03 00 00       	call   923 <exit>
      printf(1, "sbrk test failed post-fork\n");
 576:	50                   	push   %eax
 577:	50                   	push   %eax
 578:	68 f0 11 00 00       	push   $0x11f0
 57d:	6a 01                	push   $0x1
 57f:	e8 0c 05 00 00       	call   a90 <printf>
      exit();
 584:	e8 9a 03 00 00       	call   923 <exit>
    printf(1, "sbrk could not deallocate\n");
 589:	56                   	push   %esi
 58a:	56                   	push   %esi
 58b:	68 0c 12 00 00       	push   $0x120c
 590:	6a 01                	push   $0x1
 592:	e8 f9 04 00 00       	call   a90 <printf>
    exit();
 597:	e8 87 03 00 00       	call   923 <exit>
    printf(1, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
 59c:	50                   	push   %eax
 59d:	53                   	push   %ebx
 59e:	68 1c 10 00 00       	push   $0x101c
 5a3:	6a 01                	push   $0x1
 5a5:	e8 e6 04 00 00       	call   a90 <printf>
    exit();
 5aa:	e8 74 03 00 00       	call   923 <exit>
 5af:	90                   	nop

000005b0 <free_pages_test>:
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	83 ec 08             	sub    $0x8,%esp
    printf(1, "num of free pages is: %d\n", getNumberOfFreePages());
 5ba:	e8 04 04 00 00       	call   9c3 <getNumberOfFreePages>
 5bf:	83 ec 04             	sub    $0x4,%esp
 5c2:	50                   	push   %eax
 5c3:	68 27 12 00 00       	push   $0x1227
 5c8:	6a 01                	push   $0x1
 5ca:	e8 c1 04 00 00       	call   a90 <printf>
    char *arr = sbrk(len);
 5cf:	c7 04 24 00 a0 00 00 	movl   $0xa000,(%esp)
 5d6:	e8 d0 03 00 00       	call   9ab <sbrk>
    printf(1, "cur num of free pages shold be old-10: %d\n", getNumberOfFreePages());
 5db:	e8 e3 03 00 00       	call   9c3 <getNumberOfFreePages>
 5e0:	83 c4 0c             	add    $0xc,%esp
 5e3:	50                   	push   %eax
 5e4:	68 1c 11 00 00       	push   $0x111c
 5e9:	6a 01                	push   $0x1
 5eb:	e8 a0 04 00 00       	call   a90 <printf>
}
 5f0:	83 c4 10             	add    $0x10,%esp
 5f3:	c9                   	leave  
 5f4:	c3                   	ret    
 5f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000600 <free_pages_with_swap_test2>:
{
 600:	f3 0f 1e fb          	endbr32 
 604:	55                   	push   %ebp
 605:	89 e5                	mov    %esp,%ebp
 607:	53                   	push   %ebx
 608:	83 ec 04             	sub    $0x4,%esp
    int init_free = getNumberOfFreePages();
 60b:	e8 b3 03 00 00       	call   9c3 <getNumberOfFreePages>
    printf(1, "init free pages: %d\n", init_free);
 610:	83 ec 04             	sub    $0x4,%esp
 613:	50                   	push   %eax
    int init_free = getNumberOfFreePages();
 614:	89 c3                	mov    %eax,%ebx
    printf(1, "init free pages: %d\n", init_free);
 616:	68 60 11 00 00       	push   $0x1160
 61b:	6a 01                	push   $0x1
 61d:	e8 6e 04 00 00       	call   a90 <printf>
    sbrk(9 * PGSIZE);
 622:	c7 04 24 00 90 00 00 	movl   $0x9000,(%esp)
 629:	e8 7d 03 00 00       	call   9ab <sbrk>
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
 62e:	e8 90 03 00 00       	call   9c3 <getNumberOfFreePages>
 633:	50                   	push   %eax
 634:	8d 43 f7             	lea    -0x9(%ebx),%eax
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
 637:	83 eb 0c             	sub    $0xc,%ebx
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
 63a:	50                   	push   %eax
 63b:	68 20 0e 00 00       	push   $0xe20
 640:	6a 01                	push   $0x1
 642:	e8 49 04 00 00       	call   a90 <printf>
    sbrk(3 * PGSIZE);
 647:	83 c4 14             	add    $0x14,%esp
 64a:	68 00 30 00 00       	push   $0x3000
 64f:	e8 57 03 00 00       	call   9ab <sbrk>
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
 654:	e8 6a 03 00 00       	call   9c3 <getNumberOfFreePages>
 659:	50                   	push   %eax
 65a:	53                   	push   %ebx
 65b:	68 54 0e 00 00       	push   $0xe54
 660:	6a 01                	push   $0x1
 662:	e8 29 04 00 00       	call   a90 <printf>
    sbrk(1 * PGSIZE);
 667:	83 c4 14             	add    $0x14,%esp
 66a:	68 00 10 00 00       	push   $0x1000
 66f:	e8 37 03 00 00       	call   9ab <sbrk>
    printf(1, "allocated 1 more file, will swap page to disk.  <should be: %d> <actually: %d> \n", init_free-12, getNumberOfFreePages());   
 674:	e8 4a 03 00 00       	call   9c3 <getNumberOfFreePages>
 679:	50                   	push   %eax
 67a:	53                   	push   %ebx
 67b:	68 8c 0e 00 00       	push   $0xe8c
 680:	6a 01                	push   $0x1
 682:	e8 09 04 00 00       	call   a90 <printf>
}
 687:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 68a:	83 c4 20             	add    $0x20,%esp
 68d:	c9                   	leave  
 68e:	c3                   	ret    
 68f:	90                   	nop

00000690 <allocate_more_than_MaxPages_test>:
{
 690:	f3 0f 1e fb          	endbr32 
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	83 ec 14             	sub    $0x14,%esp
   printf(1, "sbrk res: %d\n", (sbrk(29 * PGSIZE)));
 69a:	68 00 d0 01 00       	push   $0x1d000
 69f:	e8 07 03 00 00       	call   9ab <sbrk>
 6a4:	83 c4 0c             	add    $0xc,%esp
 6a7:	50                   	push   %eax
 6a8:	68 75 11 00 00       	push   $0x1175
 6ad:	6a 01                	push   $0x1
 6af:	e8 dc 03 00 00       	call   a90 <printf>
}
 6b4:	83 c4 10             	add    $0x10,%esp
 6b7:	c9                   	leave  
 6b8:	c3                   	ret    
 6b9:	66 90                	xchg   %ax,%ax
 6bb:	66 90                	xchg   %ax,%ax
 6bd:	66 90                	xchg   %ax,%ax
 6bf:	90                   	nop

000006c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 6c0:	f3 0f 1e fb          	endbr32 
 6c4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6c5:	31 c0                	xor    %eax,%eax
{
 6c7:	89 e5                	mov    %esp,%ebp
 6c9:	53                   	push   %ebx
 6ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 6d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 6d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 6d7:	83 c0 01             	add    $0x1,%eax
 6da:	84 d2                	test   %dl,%dl
 6dc:	75 f2                	jne    6d0 <strcpy+0x10>
    ;
  return os;
}
 6de:	89 c8                	mov    %ecx,%eax
 6e0:	5b                   	pop    %ebx
 6e1:	5d                   	pop    %ebp
 6e2:	c3                   	ret    
 6e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000006f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6f0:	f3 0f 1e fb          	endbr32 
 6f4:	55                   	push   %ebp
 6f5:	89 e5                	mov    %esp,%ebp
 6f7:	53                   	push   %ebx
 6f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 6fe:	0f b6 01             	movzbl (%ecx),%eax
 701:	0f b6 1a             	movzbl (%edx),%ebx
 704:	84 c0                	test   %al,%al
 706:	75 19                	jne    721 <strcmp+0x31>
 708:	eb 26                	jmp    730 <strcmp+0x40>
 70a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 710:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 714:	83 c1 01             	add    $0x1,%ecx
 717:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 71a:	0f b6 1a             	movzbl (%edx),%ebx
 71d:	84 c0                	test   %al,%al
 71f:	74 0f                	je     730 <strcmp+0x40>
 721:	38 d8                	cmp    %bl,%al
 723:	74 eb                	je     710 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 725:	29 d8                	sub    %ebx,%eax
}
 727:	5b                   	pop    %ebx
 728:	5d                   	pop    %ebp
 729:	c3                   	ret    
 72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 730:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 732:	29 d8                	sub    %ebx,%eax
}
 734:	5b                   	pop    %ebx
 735:	5d                   	pop    %ebp
 736:	c3                   	ret    
 737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73e:	66 90                	xchg   %ax,%ax

00000740 <strlen>:

uint
strlen(const char *s)
{
 740:	f3 0f 1e fb          	endbr32 
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 74a:	80 3a 00             	cmpb   $0x0,(%edx)
 74d:	74 21                	je     770 <strlen+0x30>
 74f:	31 c0                	xor    %eax,%eax
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 758:	83 c0 01             	add    $0x1,%eax
 75b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 75f:	89 c1                	mov    %eax,%ecx
 761:	75 f5                	jne    758 <strlen+0x18>
    ;
  return n;
}
 763:	89 c8                	mov    %ecx,%eax
 765:	5d                   	pop    %ebp
 766:	c3                   	ret    
 767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 770:	31 c9                	xor    %ecx,%ecx
}
 772:	5d                   	pop    %ebp
 773:	89 c8                	mov    %ecx,%eax
 775:	c3                   	ret    
 776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77d:	8d 76 00             	lea    0x0(%esi),%esi

00000780 <memset>:

void*
memset(void *dst, int c, uint n)
{
 780:	f3 0f 1e fb          	endbr32 
 784:	55                   	push   %ebp
 785:	89 e5                	mov    %esp,%ebp
 787:	57                   	push   %edi
 788:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 78b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 78e:	8b 45 0c             	mov    0xc(%ebp),%eax
 791:	89 d7                	mov    %edx,%edi
 793:	fc                   	cld    
 794:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 796:	89 d0                	mov    %edx,%eax
 798:	5f                   	pop    %edi
 799:	5d                   	pop    %ebp
 79a:	c3                   	ret    
 79b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop

000007a0 <strchr>:

char*
strchr(const char *s, char c)
{
 7a0:	f3 0f 1e fb          	endbr32 
 7a4:	55                   	push   %ebp
 7a5:	89 e5                	mov    %esp,%ebp
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 7ae:	0f b6 10             	movzbl (%eax),%edx
 7b1:	84 d2                	test   %dl,%dl
 7b3:	75 16                	jne    7cb <strchr+0x2b>
 7b5:	eb 21                	jmp    7d8 <strchr+0x38>
 7b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7be:	66 90                	xchg   %ax,%ax
 7c0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 7c4:	83 c0 01             	add    $0x1,%eax
 7c7:	84 d2                	test   %dl,%dl
 7c9:	74 0d                	je     7d8 <strchr+0x38>
    if(*s == c)
 7cb:	38 d1                	cmp    %dl,%cl
 7cd:	75 f1                	jne    7c0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 7cf:	5d                   	pop    %ebp
 7d0:	c3                   	ret    
 7d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 7d8:	31 c0                	xor    %eax,%eax
}
 7da:	5d                   	pop    %ebp
 7db:	c3                   	ret    
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007e0 <gets>:

char*
gets(char *buf, int max)
{
 7e0:	f3 0f 1e fb          	endbr32 
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	57                   	push   %edi
 7e8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7e9:	31 f6                	xor    %esi,%esi
{
 7eb:	53                   	push   %ebx
 7ec:	89 f3                	mov    %esi,%ebx
 7ee:	83 ec 1c             	sub    $0x1c,%esp
 7f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 7f4:	eb 33                	jmp    829 <gets+0x49>
 7f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7fd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 800:	83 ec 04             	sub    $0x4,%esp
 803:	8d 45 e7             	lea    -0x19(%ebp),%eax
 806:	6a 01                	push   $0x1
 808:	50                   	push   %eax
 809:	6a 00                	push   $0x0
 80b:	e8 2b 01 00 00       	call   93b <read>
    if(cc < 1)
 810:	83 c4 10             	add    $0x10,%esp
 813:	85 c0                	test   %eax,%eax
 815:	7e 1c                	jle    833 <gets+0x53>
      break;
    buf[i++] = c;
 817:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 81b:	83 c7 01             	add    $0x1,%edi
 81e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 821:	3c 0a                	cmp    $0xa,%al
 823:	74 23                	je     848 <gets+0x68>
 825:	3c 0d                	cmp    $0xd,%al
 827:	74 1f                	je     848 <gets+0x68>
  for(i=0; i+1 < max; ){
 829:	83 c3 01             	add    $0x1,%ebx
 82c:	89 fe                	mov    %edi,%esi
 82e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 831:	7c cd                	jl     800 <gets+0x20>
 833:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 835:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 838:	c6 03 00             	movb   $0x0,(%ebx)
}
 83b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 83e:	5b                   	pop    %ebx
 83f:	5e                   	pop    %esi
 840:	5f                   	pop    %edi
 841:	5d                   	pop    %ebp
 842:	c3                   	ret    
 843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 847:	90                   	nop
 848:	8b 75 08             	mov    0x8(%ebp),%esi
 84b:	8b 45 08             	mov    0x8(%ebp),%eax
 84e:	01 de                	add    %ebx,%esi
 850:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 852:	c6 03 00             	movb   $0x0,(%ebx)
}
 855:	8d 65 f4             	lea    -0xc(%ebp),%esp
 858:	5b                   	pop    %ebx
 859:	5e                   	pop    %esi
 85a:	5f                   	pop    %edi
 85b:	5d                   	pop    %ebp
 85c:	c3                   	ret    
 85d:	8d 76 00             	lea    0x0(%esi),%esi

00000860 <stat>:

int
stat(const char *n, struct stat *st)
{
 860:	f3 0f 1e fb          	endbr32 
 864:	55                   	push   %ebp
 865:	89 e5                	mov    %esp,%ebp
 867:	56                   	push   %esi
 868:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 869:	83 ec 08             	sub    $0x8,%esp
 86c:	6a 00                	push   $0x0
 86e:	ff 75 08             	pushl  0x8(%ebp)
 871:	e8 ed 00 00 00       	call   963 <open>
  if(fd < 0)
 876:	83 c4 10             	add    $0x10,%esp
 879:	85 c0                	test   %eax,%eax
 87b:	78 2b                	js     8a8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 87d:	83 ec 08             	sub    $0x8,%esp
 880:	ff 75 0c             	pushl  0xc(%ebp)
 883:	89 c3                	mov    %eax,%ebx
 885:	50                   	push   %eax
 886:	e8 f0 00 00 00       	call   97b <fstat>
  close(fd);
 88b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 88e:	89 c6                	mov    %eax,%esi
  close(fd);
 890:	e8 b6 00 00 00       	call   94b <close>
  return r;
 895:	83 c4 10             	add    $0x10,%esp
}
 898:	8d 65 f8             	lea    -0x8(%ebp),%esp
 89b:	89 f0                	mov    %esi,%eax
 89d:	5b                   	pop    %ebx
 89e:	5e                   	pop    %esi
 89f:	5d                   	pop    %ebp
 8a0:	c3                   	ret    
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 8a8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 8ad:	eb e9                	jmp    898 <stat+0x38>
 8af:	90                   	nop

000008b0 <atoi>:

int
atoi(const char *s)
{
 8b0:	f3 0f 1e fb          	endbr32 
 8b4:	55                   	push   %ebp
 8b5:	89 e5                	mov    %esp,%ebp
 8b7:	53                   	push   %ebx
 8b8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8bb:	0f be 02             	movsbl (%edx),%eax
 8be:	8d 48 d0             	lea    -0x30(%eax),%ecx
 8c1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 8c4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 8c9:	77 1a                	ja     8e5 <atoi+0x35>
 8cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8cf:	90                   	nop
    n = n*10 + *s++ - '0';
 8d0:	83 c2 01             	add    $0x1,%edx
 8d3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 8d6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 8da:	0f be 02             	movsbl (%edx),%eax
 8dd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 8e0:	80 fb 09             	cmp    $0x9,%bl
 8e3:	76 eb                	jbe    8d0 <atoi+0x20>
  return n;
}
 8e5:	89 c8                	mov    %ecx,%eax
 8e7:	5b                   	pop    %ebx
 8e8:	5d                   	pop    %ebp
 8e9:	c3                   	ret    
 8ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000008f0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8f0:	f3 0f 1e fb          	endbr32 
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	57                   	push   %edi
 8f8:	8b 45 10             	mov    0x10(%ebp),%eax
 8fb:	8b 55 08             	mov    0x8(%ebp),%edx
 8fe:	56                   	push   %esi
 8ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 902:	85 c0                	test   %eax,%eax
 904:	7e 0f                	jle    915 <memmove+0x25>
 906:	01 d0                	add    %edx,%eax
  dst = vdst;
 908:	89 d7                	mov    %edx,%edi
 90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 910:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 911:	39 f8                	cmp    %edi,%eax
 913:	75 fb                	jne    910 <memmove+0x20>
  return vdst;
}
 915:	5e                   	pop    %esi
 916:	89 d0                	mov    %edx,%eax
 918:	5f                   	pop    %edi
 919:	5d                   	pop    %ebp
 91a:	c3                   	ret    

0000091b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 91b:	b8 01 00 00 00       	mov    $0x1,%eax
 920:	cd 40                	int    $0x40
 922:	c3                   	ret    

00000923 <exit>:
SYSCALL(exit)
 923:	b8 02 00 00 00       	mov    $0x2,%eax
 928:	cd 40                	int    $0x40
 92a:	c3                   	ret    

0000092b <wait>:
SYSCALL(wait)
 92b:	b8 03 00 00 00       	mov    $0x3,%eax
 930:	cd 40                	int    $0x40
 932:	c3                   	ret    

00000933 <pipe>:
SYSCALL(pipe)
 933:	b8 04 00 00 00       	mov    $0x4,%eax
 938:	cd 40                	int    $0x40
 93a:	c3                   	ret    

0000093b <read>:
SYSCALL(read)
 93b:	b8 05 00 00 00       	mov    $0x5,%eax
 940:	cd 40                	int    $0x40
 942:	c3                   	ret    

00000943 <write>:
SYSCALL(write)
 943:	b8 10 00 00 00       	mov    $0x10,%eax
 948:	cd 40                	int    $0x40
 94a:	c3                   	ret    

0000094b <close>:
SYSCALL(close)
 94b:	b8 15 00 00 00       	mov    $0x15,%eax
 950:	cd 40                	int    $0x40
 952:	c3                   	ret    

00000953 <kill>:
SYSCALL(kill)
 953:	b8 06 00 00 00       	mov    $0x6,%eax
 958:	cd 40                	int    $0x40
 95a:	c3                   	ret    

0000095b <exec>:
SYSCALL(exec)
 95b:	b8 07 00 00 00       	mov    $0x7,%eax
 960:	cd 40                	int    $0x40
 962:	c3                   	ret    

00000963 <open>:
SYSCALL(open)
 963:	b8 0f 00 00 00       	mov    $0xf,%eax
 968:	cd 40                	int    $0x40
 96a:	c3                   	ret    

0000096b <mknod>:
SYSCALL(mknod)
 96b:	b8 11 00 00 00       	mov    $0x11,%eax
 970:	cd 40                	int    $0x40
 972:	c3                   	ret    

00000973 <unlink>:
SYSCALL(unlink)
 973:	b8 12 00 00 00       	mov    $0x12,%eax
 978:	cd 40                	int    $0x40
 97a:	c3                   	ret    

0000097b <fstat>:
SYSCALL(fstat)
 97b:	b8 08 00 00 00       	mov    $0x8,%eax
 980:	cd 40                	int    $0x40
 982:	c3                   	ret    

00000983 <link>:
SYSCALL(link)
 983:	b8 13 00 00 00       	mov    $0x13,%eax
 988:	cd 40                	int    $0x40
 98a:	c3                   	ret    

0000098b <mkdir>:
SYSCALL(mkdir)
 98b:	b8 14 00 00 00       	mov    $0x14,%eax
 990:	cd 40                	int    $0x40
 992:	c3                   	ret    

00000993 <chdir>:
SYSCALL(chdir)
 993:	b8 09 00 00 00       	mov    $0x9,%eax
 998:	cd 40                	int    $0x40
 99a:	c3                   	ret    

0000099b <dup>:
SYSCALL(dup)
 99b:	b8 0a 00 00 00       	mov    $0xa,%eax
 9a0:	cd 40                	int    $0x40
 9a2:	c3                   	ret    

000009a3 <getpid>:
SYSCALL(getpid)
 9a3:	b8 0b 00 00 00       	mov    $0xb,%eax
 9a8:	cd 40                	int    $0x40
 9aa:	c3                   	ret    

000009ab <sbrk>:
SYSCALL(sbrk)
 9ab:	b8 0c 00 00 00       	mov    $0xc,%eax
 9b0:	cd 40                	int    $0x40
 9b2:	c3                   	ret    

000009b3 <sleep>:
SYSCALL(sleep)
 9b3:	b8 0d 00 00 00       	mov    $0xd,%eax
 9b8:	cd 40                	int    $0x40
 9ba:	c3                   	ret    

000009bb <uptime>:
SYSCALL(uptime)
 9bb:	b8 0e 00 00 00       	mov    $0xe,%eax
 9c0:	cd 40                	int    $0x40
 9c2:	c3                   	ret    

000009c3 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
 9c3:	b8 17 00 00 00       	mov    $0x17,%eax
 9c8:	cd 40                	int    $0x40
 9ca:	c3                   	ret    

000009cb <getNumRefs>:
 9cb:	b8 18 00 00 00       	mov    $0x18,%eax
 9d0:	cd 40                	int    $0x40
 9d2:	c3                   	ret    
 9d3:	66 90                	xchg   %ax,%ax
 9d5:	66 90                	xchg   %ax,%ax
 9d7:	66 90                	xchg   %ax,%ax
 9d9:	66 90                	xchg   %ax,%ax
 9db:	66 90                	xchg   %ax,%ax
 9dd:	66 90                	xchg   %ax,%ax
 9df:	90                   	nop

000009e0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 9e0:	55                   	push   %ebp
 9e1:	89 e5                	mov    %esp,%ebp
 9e3:	57                   	push   %edi
 9e4:	56                   	push   %esi
 9e5:	53                   	push   %ebx
 9e6:	83 ec 3c             	sub    $0x3c,%esp
 9e9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 9ec:	89 d1                	mov    %edx,%ecx
{
 9ee:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 9f1:	85 d2                	test   %edx,%edx
 9f3:	0f 89 7f 00 00 00    	jns    a78 <printint+0x98>
 9f9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 9fd:	74 79                	je     a78 <printint+0x98>
    neg = 1;
 9ff:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 a06:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 a08:	31 db                	xor    %ebx,%ebx
 a0a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 a0d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 a10:	89 c8                	mov    %ecx,%eax
 a12:	31 d2                	xor    %edx,%edx
 a14:	89 cf                	mov    %ecx,%edi
 a16:	f7 75 c4             	divl   -0x3c(%ebp)
 a19:	0f b6 92 48 12 00 00 	movzbl 0x1248(%edx),%edx
 a20:	89 45 c0             	mov    %eax,-0x40(%ebp)
 a23:	89 d8                	mov    %ebx,%eax
 a25:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 a28:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 a2b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 a2e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 a31:	76 dd                	jbe    a10 <printint+0x30>
  if(neg)
 a33:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 a36:	85 c9                	test   %ecx,%ecx
 a38:	74 0c                	je     a46 <printint+0x66>
    buf[i++] = '-';
 a3a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 a3f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 a41:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 a46:	8b 7d b8             	mov    -0x48(%ebp),%edi
 a49:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 a4d:	eb 07                	jmp    a56 <printint+0x76>
 a4f:	90                   	nop
 a50:	0f b6 13             	movzbl (%ebx),%edx
 a53:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 a56:	83 ec 04             	sub    $0x4,%esp
 a59:	88 55 d7             	mov    %dl,-0x29(%ebp)
 a5c:	6a 01                	push   $0x1
 a5e:	56                   	push   %esi
 a5f:	57                   	push   %edi
 a60:	e8 de fe ff ff       	call   943 <write>
  while(--i >= 0)
 a65:	83 c4 10             	add    $0x10,%esp
 a68:	39 de                	cmp    %ebx,%esi
 a6a:	75 e4                	jne    a50 <printint+0x70>
    putc(fd, buf[i]);
}
 a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a6f:	5b                   	pop    %ebx
 a70:	5e                   	pop    %esi
 a71:	5f                   	pop    %edi
 a72:	5d                   	pop    %ebp
 a73:	c3                   	ret    
 a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 a78:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 a7f:	eb 87                	jmp    a08 <printint+0x28>
 a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8f:	90                   	nop

00000a90 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a90:	f3 0f 1e fb          	endbr32 
 a94:	55                   	push   %ebp
 a95:	89 e5                	mov    %esp,%ebp
 a97:	57                   	push   %edi
 a98:	56                   	push   %esi
 a99:	53                   	push   %ebx
 a9a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a9d:	8b 75 0c             	mov    0xc(%ebp),%esi
 aa0:	0f b6 1e             	movzbl (%esi),%ebx
 aa3:	84 db                	test   %bl,%bl
 aa5:	0f 84 b4 00 00 00    	je     b5f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 aab:	8d 45 10             	lea    0x10(%ebp),%eax
 aae:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 ab1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 ab4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 ab6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 ab9:	eb 33                	jmp    aee <printf+0x5e>
 abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 abf:	90                   	nop
 ac0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 ac3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 ac8:	83 f8 25             	cmp    $0x25,%eax
 acb:	74 17                	je     ae4 <printf+0x54>
  write(fd, &c, 1);
 acd:	83 ec 04             	sub    $0x4,%esp
 ad0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 ad3:	6a 01                	push   $0x1
 ad5:	57                   	push   %edi
 ad6:	ff 75 08             	pushl  0x8(%ebp)
 ad9:	e8 65 fe ff ff       	call   943 <write>
 ade:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 ae1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 ae4:	0f b6 1e             	movzbl (%esi),%ebx
 ae7:	83 c6 01             	add    $0x1,%esi
 aea:	84 db                	test   %bl,%bl
 aec:	74 71                	je     b5f <printf+0xcf>
    c = fmt[i] & 0xff;
 aee:	0f be cb             	movsbl %bl,%ecx
 af1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 af4:	85 d2                	test   %edx,%edx
 af6:	74 c8                	je     ac0 <printf+0x30>
      }
    } else if(state == '%'){
 af8:	83 fa 25             	cmp    $0x25,%edx
 afb:	75 e7                	jne    ae4 <printf+0x54>
      if(c == 'd'){
 afd:	83 f8 64             	cmp    $0x64,%eax
 b00:	0f 84 9a 00 00 00    	je     ba0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b06:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b0c:	83 f9 70             	cmp    $0x70,%ecx
 b0f:	74 5f                	je     b70 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b11:	83 f8 73             	cmp    $0x73,%eax
 b14:	0f 84 d6 00 00 00    	je     bf0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b1a:	83 f8 63             	cmp    $0x63,%eax
 b1d:	0f 84 8d 00 00 00    	je     bb0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b23:	83 f8 25             	cmp    $0x25,%eax
 b26:	0f 84 b4 00 00 00    	je     be0 <printf+0x150>
  write(fd, &c, 1);
 b2c:	83 ec 04             	sub    $0x4,%esp
 b2f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b33:	6a 01                	push   $0x1
 b35:	57                   	push   %edi
 b36:	ff 75 08             	pushl  0x8(%ebp)
 b39:	e8 05 fe ff ff       	call   943 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 b3e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 b41:	83 c4 0c             	add    $0xc,%esp
 b44:	6a 01                	push   $0x1
 b46:	83 c6 01             	add    $0x1,%esi
 b49:	57                   	push   %edi
 b4a:	ff 75 08             	pushl  0x8(%ebp)
 b4d:	e8 f1 fd ff ff       	call   943 <write>
  for(i = 0; fmt[i]; i++){
 b52:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 b56:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 b59:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 b5b:	84 db                	test   %bl,%bl
 b5d:	75 8f                	jne    aee <printf+0x5e>
    }
  }
}
 b5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b62:	5b                   	pop    %ebx
 b63:	5e                   	pop    %esi
 b64:	5f                   	pop    %edi
 b65:	5d                   	pop    %ebp
 b66:	c3                   	ret    
 b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b6e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 b70:	83 ec 0c             	sub    $0xc,%esp
 b73:	b9 10 00 00 00       	mov    $0x10,%ecx
 b78:	6a 00                	push   $0x0
 b7a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 b7d:	8b 45 08             	mov    0x8(%ebp),%eax
 b80:	8b 13                	mov    (%ebx),%edx
 b82:	e8 59 fe ff ff       	call   9e0 <printint>
        ap++;
 b87:	89 d8                	mov    %ebx,%eax
 b89:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b8c:	31 d2                	xor    %edx,%edx
        ap++;
 b8e:	83 c0 04             	add    $0x4,%eax
 b91:	89 45 d0             	mov    %eax,-0x30(%ebp)
 b94:	e9 4b ff ff ff       	jmp    ae4 <printf+0x54>
 b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 ba0:	83 ec 0c             	sub    $0xc,%esp
 ba3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 ba8:	6a 01                	push   $0x1
 baa:	eb ce                	jmp    b7a <printf+0xea>
 bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 bb0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 bb3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 bb6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 bb8:	6a 01                	push   $0x1
        ap++;
 bba:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 bbd:	57                   	push   %edi
 bbe:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 bc1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 bc4:	e8 7a fd ff ff       	call   943 <write>
        ap++;
 bc9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 bcc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bcf:	31 d2                	xor    %edx,%edx
 bd1:	e9 0e ff ff ff       	jmp    ae4 <printf+0x54>
 bd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 bdd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 be0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 be3:	83 ec 04             	sub    $0x4,%esp
 be6:	e9 59 ff ff ff       	jmp    b44 <printf+0xb4>
 beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 bef:	90                   	nop
        s = (char*)*ap;
 bf0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 bf3:	8b 18                	mov    (%eax),%ebx
        ap++;
 bf5:	83 c0 04             	add    $0x4,%eax
 bf8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 bfb:	85 db                	test   %ebx,%ebx
 bfd:	74 17                	je     c16 <printf+0x186>
        while(*s != 0){
 bff:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 c02:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 c04:	84 c0                	test   %al,%al
 c06:	0f 84 d8 fe ff ff    	je     ae4 <printf+0x54>
 c0c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 c0f:	89 de                	mov    %ebx,%esi
 c11:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c14:	eb 1a                	jmp    c30 <printf+0x1a0>
          s = "(null)";
 c16:	bb 41 12 00 00       	mov    $0x1241,%ebx
        while(*s != 0){
 c1b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 c1e:	b8 28 00 00 00       	mov    $0x28,%eax
 c23:	89 de                	mov    %ebx,%esi
 c25:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c2f:	90                   	nop
  write(fd, &c, 1);
 c30:	83 ec 04             	sub    $0x4,%esp
          s++;
 c33:	83 c6 01             	add    $0x1,%esi
 c36:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 c39:	6a 01                	push   $0x1
 c3b:	57                   	push   %edi
 c3c:	53                   	push   %ebx
 c3d:	e8 01 fd ff ff       	call   943 <write>
        while(*s != 0){
 c42:	0f b6 06             	movzbl (%esi),%eax
 c45:	83 c4 10             	add    $0x10,%esp
 c48:	84 c0                	test   %al,%al
 c4a:	75 e4                	jne    c30 <printf+0x1a0>
 c4c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 c4f:	31 d2                	xor    %edx,%edx
 c51:	e9 8e fe ff ff       	jmp    ae4 <printf+0x54>
 c56:	66 90                	xchg   %ax,%ax
 c58:	66 90                	xchg   %ax,%ax
 c5a:	66 90                	xchg   %ax,%ax
 c5c:	66 90                	xchg   %ax,%ax
 c5e:	66 90                	xchg   %ax,%ax

00000c60 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c60:	f3 0f 1e fb          	endbr32 
 c64:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c65:	a1 3c 16 00 00       	mov    0x163c,%eax
{
 c6a:	89 e5                	mov    %esp,%ebp
 c6c:	57                   	push   %edi
 c6d:	56                   	push   %esi
 c6e:	53                   	push   %ebx
 c6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c72:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 c74:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c77:	39 c8                	cmp    %ecx,%eax
 c79:	73 15                	jae    c90 <free+0x30>
 c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 c7f:	90                   	nop
 c80:	39 d1                	cmp    %edx,%ecx
 c82:	72 14                	jb     c98 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c84:	39 d0                	cmp    %edx,%eax
 c86:	73 10                	jae    c98 <free+0x38>
{
 c88:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c8a:	8b 10                	mov    (%eax),%edx
 c8c:	39 c8                	cmp    %ecx,%eax
 c8e:	72 f0                	jb     c80 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c90:	39 d0                	cmp    %edx,%eax
 c92:	72 f4                	jb     c88 <free+0x28>
 c94:	39 d1                	cmp    %edx,%ecx
 c96:	73 f0                	jae    c88 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c98:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c9b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c9e:	39 fa                	cmp    %edi,%edx
 ca0:	74 1e                	je     cc0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 ca2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ca5:	8b 50 04             	mov    0x4(%eax),%edx
 ca8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cab:	39 f1                	cmp    %esi,%ecx
 cad:	74 28                	je     cd7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 caf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 cb1:	5b                   	pop    %ebx
  freep = p;
 cb2:	a3 3c 16 00 00       	mov    %eax,0x163c
}
 cb7:	5e                   	pop    %esi
 cb8:	5f                   	pop    %edi
 cb9:	5d                   	pop    %ebp
 cba:	c3                   	ret    
 cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 cbf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 cc0:	03 72 04             	add    0x4(%edx),%esi
 cc3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 cc6:	8b 10                	mov    (%eax),%edx
 cc8:	8b 12                	mov    (%edx),%edx
 cca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ccd:	8b 50 04             	mov    0x4(%eax),%edx
 cd0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cd3:	39 f1                	cmp    %esi,%ecx
 cd5:	75 d8                	jne    caf <free+0x4f>
    p->s.size += bp->s.size;
 cd7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 cda:	a3 3c 16 00 00       	mov    %eax,0x163c
    p->s.size += bp->s.size;
 cdf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ce2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 ce5:	89 10                	mov    %edx,(%eax)
}
 ce7:	5b                   	pop    %ebx
 ce8:	5e                   	pop    %esi
 ce9:	5f                   	pop    %edi
 cea:	5d                   	pop    %ebp
 ceb:	c3                   	ret    
 cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cf0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cf0:	f3 0f 1e fb          	endbr32 
 cf4:	55                   	push   %ebp
 cf5:	89 e5                	mov    %esp,%ebp
 cf7:	57                   	push   %edi
 cf8:	56                   	push   %esi
 cf9:	53                   	push   %ebx
 cfa:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d00:	8b 3d 3c 16 00 00    	mov    0x163c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d06:	8d 70 07             	lea    0x7(%eax),%esi
 d09:	c1 ee 03             	shr    $0x3,%esi
 d0c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 d0f:	85 ff                	test   %edi,%edi
 d11:	0f 84 a9 00 00 00    	je     dc0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d17:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 d19:	8b 48 04             	mov    0x4(%eax),%ecx
 d1c:	39 f1                	cmp    %esi,%ecx
 d1e:	73 6d                	jae    d8d <malloc+0x9d>
 d20:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 d26:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d2b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 d2e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 d35:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 d38:	eb 17                	jmp    d51 <malloc+0x61>
 d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d40:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 d42:	8b 4a 04             	mov    0x4(%edx),%ecx
 d45:	39 f1                	cmp    %esi,%ecx
 d47:	73 4f                	jae    d98 <malloc+0xa8>
 d49:	8b 3d 3c 16 00 00    	mov    0x163c,%edi
 d4f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d51:	39 c7                	cmp    %eax,%edi
 d53:	75 eb                	jne    d40 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 d55:	83 ec 0c             	sub    $0xc,%esp
 d58:	ff 75 e4             	pushl  -0x1c(%ebp)
 d5b:	e8 4b fc ff ff       	call   9ab <sbrk>
  if(p == (char*)-1)
 d60:	83 c4 10             	add    $0x10,%esp
 d63:	83 f8 ff             	cmp    $0xffffffff,%eax
 d66:	74 1b                	je     d83 <malloc+0x93>
  hp->s.size = nu;
 d68:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d6b:	83 ec 0c             	sub    $0xc,%esp
 d6e:	83 c0 08             	add    $0x8,%eax
 d71:	50                   	push   %eax
 d72:	e8 e9 fe ff ff       	call   c60 <free>
  return freep;
 d77:	a1 3c 16 00 00       	mov    0x163c,%eax
      if((p = morecore(nunits)) == 0)
 d7c:	83 c4 10             	add    $0x10,%esp
 d7f:	85 c0                	test   %eax,%eax
 d81:	75 bd                	jne    d40 <malloc+0x50>
        return 0;
  }
}
 d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 d86:	31 c0                	xor    %eax,%eax
}
 d88:	5b                   	pop    %ebx
 d89:	5e                   	pop    %esi
 d8a:	5f                   	pop    %edi
 d8b:	5d                   	pop    %ebp
 d8c:	c3                   	ret    
    if(p->s.size >= nunits){
 d8d:	89 c2                	mov    %eax,%edx
 d8f:	89 f8                	mov    %edi,%eax
 d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 d98:	39 ce                	cmp    %ecx,%esi
 d9a:	74 54                	je     df0 <malloc+0x100>
        p->s.size -= nunits;
 d9c:	29 f1                	sub    %esi,%ecx
 d9e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 da1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 da4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 da7:	a3 3c 16 00 00       	mov    %eax,0x163c
}
 dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 daf:	8d 42 08             	lea    0x8(%edx),%eax
}
 db2:	5b                   	pop    %ebx
 db3:	5e                   	pop    %esi
 db4:	5f                   	pop    %edi
 db5:	5d                   	pop    %ebp
 db6:	c3                   	ret    
 db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 dbe:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 dc0:	c7 05 3c 16 00 00 40 	movl   $0x1640,0x163c
 dc7:	16 00 00 
    base.s.size = 0;
 dca:	bf 40 16 00 00       	mov    $0x1640,%edi
    base.s.ptr = freep = prevp = &base;
 dcf:	c7 05 40 16 00 00 40 	movl   $0x1640,0x1640
 dd6:	16 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 ddb:	c7 05 44 16 00 00 00 	movl   $0x0,0x1644
 de2:	00 00 00 
    if(p->s.size >= nunits){
 de5:	e9 36 ff ff ff       	jmp    d20 <malloc+0x30>
 dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 df0:	8b 0a                	mov    (%edx),%ecx
 df2:	89 08                	mov    %ecx,(%eax)
 df4:	eb b1                	jmp    da7 <malloc+0xb7>
