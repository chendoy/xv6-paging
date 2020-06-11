
_ass3Tests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
   
}

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
    // simple_fork_test();
    // pagefault_test();
    // free_pages_test();
    free_pages_with_swap_test(); // not relevant to selection=None
  11:	e8 ea 05 00 00       	call   600 <free_pages_with_swap_test>
    // num_pages_test();
    // pagefault_cow_test(); 
    // cow_refs_test();
    // allocate_more_than_MaxPages_test(); // should pass only with selection=None
    exit();
  16:	e8 f7 08 00 00       	call   912 <exit>
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <simple_fork_test>:
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_fork_test --------\n");
  26:	68 c8 0d 00 00       	push   $0xdc8
  2b:	6a 01                	push   $0x1
  2d:	e8 3e 0a 00 00       	call   a70 <printf>
    pid = fork();
  32:	e8 d3 08 00 00       	call   90a <fork>
    if(pid == 0) // child
  37:	83 c4 10             	add    $0x10,%esp
  3a:	85 c0                	test   %eax,%eax
  3c:	74 21                	je     5f <simple_fork_test+0x3f>
        sleep(20);
  3e:	83 ec 0c             	sub    $0xc,%esp
  41:	6a 14                	push   $0x14
  43:	e8 5a 09 00 00       	call   9a2 <sleep>
        printf(1, "I'm parent!\n");
  48:	58                   	pop    %eax
  49:	5a                   	pop    %edx
  4a:	68 28 11 00 00       	push   $0x1128
  4f:	6a 01                	push   $0x1
  51:	e8 1a 0a 00 00       	call   a70 <printf>
        wait();
  56:	83 c4 10             	add    $0x10,%esp
}
  59:	c9                   	leave  
        wait();
  5a:	e9 bb 08 00 00       	jmp    91a <wait>
        printf(1, "I'm child!\n");
  5f:	51                   	push   %ecx
  60:	51                   	push   %ecx
  61:	68 1c 11 00 00       	push   $0x111c
  66:	6a 01                	push   $0x1
  68:	e8 03 0a 00 00       	call   a70 <printf>
        exit();
  6d:	e8 a0 08 00 00       	call   912 <exit>
  72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000080 <free_pages_with_swap_test1>:
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	53                   	push   %ebx
  84:	83 ec 04             	sub    $0x4,%esp
    int init_free = getNumberOfFreePages();
  87:	e8 26 09 00 00       	call   9b2 <getNumberOfFreePages>
    printf(1, "init free pages: %d\n", init_free);
  8c:	83 ec 04             	sub    $0x4,%esp
    int init_free = getNumberOfFreePages();
  8f:	89 c3                	mov    %eax,%ebx
    printf(1, "init free pages: %d\n", init_free);
  91:	50                   	push   %eax
  92:	68 35 11 00 00       	push   $0x1135
  97:	6a 01                	push   $0x1
  99:	e8 d2 09 00 00       	call   a70 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
  9e:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
  a5:	e8 f0 08 00 00       	call   99a <sbrk>
  aa:	83 c4 0c             	add    $0xc,%esp
  ad:	50                   	push   %eax
  ae:	68 4a 11 00 00       	push   $0x114a
  b3:	6a 01                	push   $0x1
  b5:	e8 b6 09 00 00       	call   a70 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
  ba:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
  c1:	e8 d4 08 00 00       	call   99a <sbrk>
  c6:	83 c4 0c             	add    $0xc,%esp
  c9:	50                   	push   %eax
  ca:	68 4a 11 00 00       	push   $0x114a
  cf:	6a 01                	push   $0x1
  d1:	e8 9a 09 00 00       	call   a70 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(3 * PGSIZE)));
  d6:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
  dd:	e8 b8 08 00 00       	call   99a <sbrk>
  e2:	83 c4 0c             	add    $0xc,%esp
  e5:	50                   	push   %eax
  e6:	68 4a 11 00 00       	push   $0x114a
  eb:	6a 01                	push   $0x1
  ed:	e8 7e 09 00 00       	call   a70 <printf>
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
  f2:	e8 bb 08 00 00       	call   9b2 <getNumberOfFreePages>
  f7:	50                   	push   %eax
  f8:	8d 43 f7             	lea    -0x9(%ebx),%eax
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
  fb:	83 eb 0c             	sub    $0xc,%ebx
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
  fe:	50                   	push   %eax
  ff:	68 f0 0d 00 00       	push   $0xdf0
 104:	6a 01                	push   $0x1
 106:	e8 65 09 00 00       	call   a70 <printf>
    printf(1, "a %d\n", (sbrk(3 * PGSIZE)));
 10b:	83 c4 14             	add    $0x14,%esp
 10e:	68 00 30 00 00       	push   $0x3000
 113:	e8 82 08 00 00       	call   99a <sbrk>
 118:	83 c4 0c             	add    $0xc,%esp
 11b:	50                   	push   %eax
 11c:	68 58 11 00 00       	push   $0x1158
 121:	6a 01                	push   $0x1
 123:	e8 48 09 00 00       	call   a70 <printf>
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
 128:	e8 85 08 00 00       	call   9b2 <getNumberOfFreePages>
 12d:	50                   	push   %eax
 12e:	53                   	push   %ebx
 12f:	68 24 0e 00 00       	push   $0xe24
 134:	6a 01                	push   $0x1
 136:	e8 35 09 00 00       	call   a70 <printf>
    printf(1, "sbrk res: %d\n", (sbrk(1 * PGSIZE)));
 13b:	83 c4 14             	add    $0x14,%esp
 13e:	68 00 10 00 00       	push   $0x1000
 143:	e8 52 08 00 00       	call   99a <sbrk>
 148:	83 c4 0c             	add    $0xc,%esp
 14b:	50                   	push   %eax
 14c:	68 4a 11 00 00       	push   $0x114a
 151:	6a 01                	push   $0x1
 153:	e8 18 09 00 00       	call   a70 <printf>
    printf(1, "allocated 1 more file, will swap page to disk.  <should be: %d> <actually: %d> \n", init_free-12, getNumberOfFreePages());   
 158:	e8 55 08 00 00       	call   9b2 <getNumberOfFreePages>
 15d:	50                   	push   %eax
 15e:	53                   	push   %ebx
 15f:	68 5c 0e 00 00       	push   $0xe5c
 164:	6a 01                	push   $0x1
 166:	e8 05 09 00 00       	call   a70 <printf>
}
 16b:	83 c4 20             	add    $0x20,%esp
 16e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 171:	c9                   	leave  
 172:	c3                   	ret    
 173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <pagefault_test>:
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	53                   	push   %ebx
 184:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 187:	68 00 f0 00 00       	push   $0xf000
 18c:	e8 3f 0b 00 00       	call   cd0 <malloc>
    memset((void*)arr, '0', len);
 191:	83 c4 0c             	add    $0xc,%esp
    char *arr = (char*)malloc(len);
 194:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len);
 196:	68 00 f0 00 00       	push   $0xf000
 19b:	6a 30                	push   $0x30
 19d:	50                   	push   %eax
 19e:	e8 cd 05 00 00       	call   770 <memset>
    printf(1,"arr[0]: %c\n", arr[0]); 
 1a3:	0f be 03             	movsbl (%ebx),%eax
 1a6:	83 c4 0c             	add    $0xc,%esp
 1a9:	50                   	push   %eax
 1aa:	68 5e 11 00 00       	push   $0x115e
 1af:	6a 01                	push   $0x1
 1b1:	e8 ba 08 00 00       	call   a70 <printf>
    printf(1,"arr[0]: %c\n", arr[len/2]); 
 1b6:	0f be 83 00 78 00 00 	movsbl 0x7800(%ebx),%eax
 1bd:	83 c4 0c             	add    $0xc,%esp
 1c0:	50                   	push   %eax
 1c1:	68 5e 11 00 00       	push   $0x115e
 1c6:	6a 01                	push   $0x1
 1c8:	e8 a3 08 00 00       	call   a70 <printf>
    printf(1,"arr[0]: %c\n", arr[len-1]); 
 1cd:	0f be 83 ff ef 00 00 	movsbl 0xefff(%ebx),%eax
 1d4:	83 c4 0c             	add    $0xc,%esp
 1d7:	50                   	push   %eax
 1d8:	68 5e 11 00 00       	push   $0x115e
 1dd:	6a 01                	push   $0x1
 1df:	e8 8c 08 00 00       	call   a70 <printf>
    return;
 1e4:	83 c4 10             	add    $0x10,%esp
}
 1e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    
 1ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000001f0 <pagefault_cow_test>:
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 1f7:	68 00 d0 00 00       	push   $0xd000
 1fc:	e8 cf 0a 00 00       	call   cd0 <malloc>
    memset((void*)arr, '0', len); // will cause some pagefaults
 201:	83 c4 0c             	add    $0xc,%esp
    char *arr = (char*)malloc(len);
 204:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len); // will cause some pagefaults
 206:	68 00 d0 00 00       	push   $0xd000
 20b:	6a 30                	push   $0x30
 20d:	50                   	push   %eax
 20e:	e8 5d 05 00 00       	call   770 <memset>
    if((pid = fork()) == 0) // child
 213:	e8 f2 06 00 00       	call   90a <fork>
 218:	83 c4 10             	add    $0x10,%esp
 21b:	85 c0                	test   %eax,%eax
 21d:	74 37                	je     256 <pagefault_cow_test+0x66>
        wait();
 21f:	e8 f6 06 00 00       	call   91a <wait>
        printf(1, "parent: arr[0]: %c (should be \'0\')\n" ,arr[0]);
 224:	0f be 03             	movsbl (%ebx),%eax
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	50                   	push   %eax
 22b:	68 b0 0e 00 00       	push   $0xeb0
 230:	6a 01                	push   $0x1
 232:	e8 39 08 00 00       	call   a70 <printf>
        printf(1, "parent: arr[1000]: %c (should be \'0\')\n",arr[1000]);
 237:	0f be 83 e8 03 00 00 	movsbl 0x3e8(%ebx),%eax
 23e:	83 c4 0c             	add    $0xc,%esp
 241:	50                   	push   %eax
 242:	68 d4 0e 00 00       	push   $0xed4
 247:	6a 01                	push   $0x1
 249:	e8 22 08 00 00       	call   a70 <printf>
        return;
 24e:	83 c4 10             	add    $0x10,%esp
}
 251:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 254:	c9                   	leave  
 255:	c3                   	ret    
        printf(1, "child: writing \'1\'s arr\n");
 256:	50                   	push   %eax
 257:	50                   	push   %eax
 258:	68 6a 11 00 00       	push   $0x116a
 25d:	6a 01                	push   $0x1
 25f:	e8 0c 08 00 00       	call   a70 <printf>
        memset((void*)arr, '1', len);
 264:	83 c4 0c             	add    $0xc,%esp
 267:	68 00 d0 00 00       	push   $0xd000
 26c:	6a 31                	push   $0x31
 26e:	53                   	push   %ebx
 26f:	e8 fc 04 00 00       	call   770 <memset>
        exit();
 274:	e8 99 06 00 00       	call   912 <exit>
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000280 <cow_refs_test>:
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	53                   	push   %ebx
 284:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 287:	68 00 80 00 00       	push   $0x8000
 28c:	e8 3f 0a 00 00       	call   cd0 <malloc>
    memset((void*)arr, '0', len); // will cause some pagefaults
 291:	83 c4 0c             	add    $0xc,%esp
    char *arr = (char*)malloc(len);
 294:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len); // will cause some pagefaults
 296:	68 00 80 00 00       	push   $0x8000
 29b:	6a 30                	push   $0x30
 29d:	50                   	push   %eax
 29e:	e8 cd 04 00 00       	call   770 <memset>
    if((pid = fork()) == 0) // child
 2a3:	e8 62 06 00 00       	call   90a <fork>
 2a8:	83 c4 10             	add    $0x10,%esp
 2ab:	85 c0                	test   %eax,%eax
 2ad:	74 09                	je     2b8 <cow_refs_test+0x38>
}
 2af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2b2:	c9                   	leave  
        wait();
 2b3:	e9 62 06 00 00       	jmp    91a <wait>
        printf(1, "before child write on arr num ref of rampage[%d] is : %d\n",6 , getNumRefs(6));
 2b8:	83 ec 0c             	sub    $0xc,%esp
 2bb:	6a 06                	push   $0x6
 2bd:	e8 f8 06 00 00       	call   9ba <getNumRefs>
 2c2:	50                   	push   %eax
 2c3:	6a 06                	push   $0x6
 2c5:	68 fc 0e 00 00       	push   $0xefc
 2ca:	6a 01                	push   $0x1
 2cc:	e8 9f 07 00 00       	call   a70 <printf>
        memset((void*)arr, '1', len);
 2d1:	83 c4 1c             	add    $0x1c,%esp
 2d4:	68 00 80 00 00       	push   $0x8000
 2d9:	6a 31                	push   $0x31
 2db:	53                   	push   %ebx
 2dc:	e8 8f 04 00 00       	call   770 <memset>
        printf(1, "after child write on arr num ref of rampage[%d] is : %d\n",6, getNumRefs(6));
 2e1:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
 2e8:	e8 cd 06 00 00       	call   9ba <getNumRefs>
 2ed:	50                   	push   %eax
 2ee:	6a 06                	push   $0x6
 2f0:	68 38 0f 00 00       	push   $0xf38
 2f5:	6a 01                	push   $0x1
 2f7:	e8 74 07 00 00       	call   a70 <printf>
        exit();
 2fc:	83 c4 20             	add    $0x20,%esp
 2ff:	e8 0e 06 00 00       	call   912 <exit>
 304:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 30a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000310 <num_pages_test>:
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
 316:	83 ec 28             	sub    $0x28,%esp
  char* oldbrk = sbrk(0);
 319:	6a 00                	push   $0x0
 31b:	e8 7a 06 00 00       	call   99a <sbrk>
 320:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  printf(1, "sbrk test\n");
 323:	58                   	pop    %eax
 324:	5a                   	pop    %edx
 325:	68 83 11 00 00       	push   $0x1183
 32a:	6a 01                	push   $0x1
 32c:	e8 3f 07 00 00       	call   a70 <printf>
  printf(1, "allocating 10 pages, should not write to swap\n");
 331:	59                   	pop    %ecx
 332:	5b                   	pop    %ebx
 333:	68 74 0f 00 00       	push   $0xf74
 338:	6a 01                	push   $0x1
 33a:	e8 31 07 00 00       	call   a70 <printf>
  a = sbrk(0);
 33f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 346:	e8 4f 06 00 00       	call   99a <sbrk>
 34b:	8d b0 00 c0 00 00    	lea    0xc000(%eax),%esi
 351:	89 c3                	mov    %eax,%ebx
 353:	83 c4 10             	add    $0x10,%esp
 356:	8d 76 00             	lea    0x0(%esi),%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    b = sbrk(PGSIZE);
 360:	83 ec 0c             	sub    $0xc,%esp
 363:	68 00 10 00 00       	push   $0x1000
 368:	e8 2d 06 00 00       	call   99a <sbrk>
    printf(1, "%x -> ", b);
 36d:	83 c4 0c             	add    $0xc,%esp
    b = sbrk(PGSIZE);
 370:	89 c7                	mov    %eax,%edi
    printf(1, "%x -> ", b);
 372:	50                   	push   %eax
 373:	68 8e 11 00 00       	push   $0x118e
 378:	6a 01                	push   $0x1
 37a:	e8 f1 06 00 00       	call   a70 <printf>
    if(b != a){
 37f:	83 c4 10             	add    $0x10,%esp
 382:	39 df                	cmp    %ebx,%edi
 384:	75 2e                	jne    3b4 <num_pages_test+0xa4>
    *b = 1;
 386:	c6 03 01             	movb   $0x1,(%ebx)
    a = b + PGSIZE;
 389:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(i = 0; i < 12; i++){
 38f:	39 de                	cmp    %ebx,%esi
 391:	75 cd                	jne    360 <num_pages_test+0x50>
  printf(1, "\ncreating child process\n");
 393:	83 ec 08             	sub    $0x8,%esp
 396:	68 95 11 00 00       	push   $0x1195
 39b:	6a 01                	push   $0x1
 39d:	e8 ce 06 00 00       	call   a70 <printf>
  pid = fork();
 3a2:	e8 63 05 00 00       	call   90a <fork>
  if(pid < 0){
 3a7:	83 c4 10             	add    $0x10,%esp
 3aa:	85 c0                	test   %eax,%eax
 3ac:	0f 88 b5 01 00 00    	js     567 <num_pages_test+0x257>
  if(pid > 0) // parent will writeToSwapFile
 3b2:	75 0c                	jne    3c0 <num_pages_test+0xb0>
      exit();
 3b4:	e8 59 05 00 00       	call   912 <exit>
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    int ramPagesBefore = getNumberOfFreePages();
 3c0:	e8 ed 05 00 00       	call   9b2 <getNumberOfFreePages>
    c = sbrk(PGSIZE);
 3c5:	83 ec 0c             	sub    $0xc,%esp
    int ramPagesBefore = getNumberOfFreePages();
 3c8:	89 c3                	mov    %eax,%ebx
    c = sbrk(PGSIZE);
 3ca:	68 00 10 00 00       	push   $0x1000
 3cf:	e8 c6 05 00 00       	call   99a <sbrk>
    if(c != a){
 3d4:	83 c4 10             	add    $0x10,%esp
 3d7:	39 f0                	cmp    %esi,%eax
 3d9:	0f 85 9b 01 00 00    	jne    57a <num_pages_test+0x26a>
    int ramPagesAfter = getNumberOfFreePages();
 3df:	e8 ce 05 00 00       	call   9b2 <getNumberOfFreePages>
    printf(1, "parent: %d should be equal to %d\n", ramPagesBefore, ramPagesAfter);
 3e4:	50                   	push   %eax
 3e5:	53                   	push   %ebx
 3e6:	68 a4 0f 00 00       	push   $0xfa4
 3eb:	6a 01                	push   $0x1
 3ed:	e8 7e 06 00 00       	call   a70 <printf>
  wait();
 3f2:	e8 23 05 00 00       	call   91a <wait>
  printf(1, "*********************************\n");
 3f7:	5f                   	pop    %edi
 3f8:	58                   	pop    %eax
 3f9:	68 c8 0f 00 00       	push   $0xfc8
 3fe:	6a 01                	push   $0x1
 400:	e8 6b 06 00 00       	call   a70 <printf>
  a = sbrk(0);
 405:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 40c:	e8 89 05 00 00       	call   99a <sbrk>
  c = sbrk(-4096);
 411:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
 418:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
 41a:	e8 7b 05 00 00       	call   99a <sbrk>
  if(c == (char*)0xffffffff){
 41f:	83 c4 10             	add    $0x10,%esp
 422:	83 f8 ff             	cmp    $0xffffffff,%eax
 425:	0f 84 62 01 00 00    	je     58d <num_pages_test+0x27d>
  printf(1, "*********************************\n");
 42b:	83 ec 08             	sub    $0x8,%esp
 42e:	68 c8 0f 00 00       	push   $0xfc8
 433:	6a 01                	push   $0x1
 435:	e8 36 06 00 00       	call   a70 <printf>
  c = sbrk(0);
 43a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 441:	e8 54 05 00 00       	call   99a <sbrk>
  if(c != a - 4096){
 446:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
 44c:	83 c4 10             	add    $0x10,%esp
 44f:	39 d0                	cmp    %edx,%eax
 451:	0f 85 49 01 00 00    	jne    5a0 <num_pages_test+0x290>
  a = sbrk(0);
 457:	83 ec 0c             	sub    $0xc,%esp
 45a:	6a 00                	push   $0x0
 45c:	e8 39 05 00 00       	call   99a <sbrk>
 461:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
 463:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 46a:	e8 2b 05 00 00       	call   99a <sbrk>
  if(c != a || sbrk(0) != a + 4096){
 46f:	83 c4 10             	add    $0x10,%esp
 472:	39 c3                	cmp    %eax,%ebx
  c = sbrk(4096);
 474:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
 476:	0f 85 d8 00 00 00    	jne    554 <num_pages_test+0x244>
 47c:	83 ec 0c             	sub    $0xc,%esp
 47f:	6a 00                	push   $0x0
 481:	e8 14 05 00 00       	call   99a <sbrk>
 486:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
 48c:	83 c4 10             	add    $0x10,%esp
 48f:	39 d0                	cmp    %edx,%eax
 491:	0f 85 bd 00 00 00    	jne    554 <num_pages_test+0x244>
  char *curbrk = sbrk(0);
 497:	83 ec 0c             	sub    $0xc,%esp
 49a:	6a 00                	push   $0x0
 49c:	e8 f9 04 00 00       	call   99a <sbrk>
  int size = curbrk - oldbrk;
 4a1:	8b 75 e4             	mov    -0x1c(%ebp),%esi
 4a4:	29 f0                	sub    %esi,%eax
 4a6:	89 c3                	mov    %eax,%ebx
  printf(1, "proc size in bytes: %d, in pages: %d\n", size, size / PGSIZE);
 4a8:	8d 80 ff 0f 00 00    	lea    0xfff(%eax),%eax
 4ae:	85 db                	test   %ebx,%ebx
 4b0:	0f 49 c3             	cmovns %ebx,%eax
 4b3:	c1 f8 0c             	sar    $0xc,%eax
 4b6:	50                   	push   %eax
 4b7:	53                   	push   %ebx
 4b8:	68 4c 10 00 00       	push   $0x104c
 4bd:	6a 01                	push   $0x1
 4bf:	e8 ac 05 00 00       	call   a70 <printf>
  printf(1, "filling mem with junk (should not cause pagefaults)\n");
 4c4:	83 c4 18             	add    $0x18,%esp
 4c7:	68 74 10 00 00       	push   $0x1074
 4cc:	6a 01                	push   $0x1
 4ce:	e8 9d 05 00 00       	call   a70 <printf>
  memset((void*)oldbrk, '1', size);
 4d3:	83 c4 0c             	add    $0xc,%esp
 4d6:	53                   	push   %ebx
 4d7:	6a 31                	push   $0x31
 4d9:	56                   	push   %esi
 4da:	e8 91 02 00 00       	call   770 <memset>
  memset((void*)oldbrk, '$', size);
 4df:	83 c4 0c             	add    $0xc,%esp
 4e2:	53                   	push   %ebx
 4e3:	6a 24                	push   $0x24
 4e5:	56                   	push   %esi
 4e6:	e8 85 02 00 00       	call   770 <memset>
  memset((void*)oldbrk, 3, size);
 4eb:	83 c4 0c             	add    $0xc,%esp
 4ee:	53                   	push   %ebx
 4ef:	6a 03                	push   $0x3
 4f1:	56                   	push   %esi
 4f2:	e8 79 02 00 00       	call   770 <memset>
  printf(1, "*********************************\n");
 4f7:	58                   	pop    %eax
 4f8:	5a                   	pop    %edx
 4f9:	68 c8 0f 00 00       	push   $0xfc8
 4fe:	6a 01                	push   $0x1
 500:	e8 6b 05 00 00       	call   a70 <printf>
  printf(1, "alocating 3 more pages up to limit (16) - should cause 3 swaps\n");
 505:	59                   	pop    %ecx
 506:	5b                   	pop    %ebx
 507:	68 ac 10 00 00       	push   $0x10ac
 50c:	6a 01                	push   $0x1
 50e:	e8 5d 05 00 00       	call   a70 <printf>
  sbrk(3 * PGSIZE);
 513:	c7 04 24 00 30 00 00 	movl   $0x3000,(%esp)
 51a:	e8 7b 04 00 00       	call   99a <sbrk>
  curbrk = sbrk(0);
 51f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 526:	e8 6f 04 00 00       	call   99a <sbrk>
  size = curbrk - oldbrk;
 52b:	29 f0                	sub    %esi,%eax
  printf(1, "proc size in bytes: %d, in pages: %d\n", size, size / PGSIZE);
 52d:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
 533:	85 c0                	test   %eax,%eax
 535:	0f 49 d0             	cmovns %eax,%edx
 538:	c1 fa 0c             	sar    $0xc,%edx
 53b:	52                   	push   %edx
 53c:	50                   	push   %eax
 53d:	68 4c 10 00 00       	push   $0x104c
 542:	6a 01                	push   $0x1
 544:	e8 27 05 00 00       	call   a70 <printf>
  return;
 549:	83 c4 20             	add    $0x20,%esp
}
 54c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 54f:	5b                   	pop    %ebx
 550:	5e                   	pop    %esi
 551:	5f                   	pop    %edi
 552:	5d                   	pop    %ebp
 553:	c3                   	ret    
    printf(1, "sbrk re-allocation failed, a %x c %x\n", a, c);
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	68 24 10 00 00       	push   $0x1024
 55b:	6a 01                	push   $0x1
 55d:	e8 0e 05 00 00       	call   a70 <printf>
    exit();
 562:	e8 ab 03 00 00       	call   912 <exit>
    printf(1, "sbrk test fork failed\n");
 567:	50                   	push   %eax
 568:	50                   	push   %eax
 569:	68 ae 11 00 00       	push   $0x11ae
 56e:	6a 01                	push   $0x1
 570:	e8 fb 04 00 00       	call   a70 <printf>
    exit();
 575:	e8 98 03 00 00       	call   912 <exit>
      printf(1, "sbrk test failed post-fork\n");
 57a:	50                   	push   %eax
 57b:	50                   	push   %eax
 57c:	68 c5 11 00 00       	push   $0x11c5
 581:	6a 01                	push   $0x1
 583:	e8 e8 04 00 00       	call   a70 <printf>
      exit();
 588:	e8 85 03 00 00       	call   912 <exit>
    printf(1, "sbrk could not deallocate\n");
 58d:	56                   	push   %esi
 58e:	56                   	push   %esi
 58f:	68 e1 11 00 00       	push   $0x11e1
 594:	6a 01                	push   $0x1
 596:	e8 d5 04 00 00       	call   a70 <printf>
    exit();
 59b:	e8 72 03 00 00       	call   912 <exit>
    printf(1, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
 5a0:	50                   	push   %eax
 5a1:	53                   	push   %ebx
 5a2:	68 ec 0f 00 00       	push   $0xfec
 5a7:	6a 01                	push   $0x1
 5a9:	e8 c2 04 00 00       	call   a70 <printf>
    exit();
 5ae:	e8 5f 03 00 00       	call   912 <exit>
 5b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 5b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005c0 <free_pages_test>:
{ 
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	53                   	push   %ebx
 5c4:	83 ec 04             	sub    $0x4,%esp
    int init =  getNumberOfFreePages();
 5c7:	e8 e6 03 00 00       	call   9b2 <getNumberOfFreePages>
    char *arr = sbrk(len);
 5cc:	83 ec 0c             	sub    $0xc,%esp
    int init =  getNumberOfFreePages();
 5cf:	89 c3                	mov    %eax,%ebx
    char *arr = sbrk(len);
 5d1:	68 00 a0 00 00       	push   $0xa000
    printf(1, "allocated %d files <expected: %d> <actual: %d>\n",len/PGSIZE, init - (len/PGSIZE), getNumberOfFreePages());
 5d6:	83 eb 0a             	sub    $0xa,%ebx
    char *arr = sbrk(len);
 5d9:	e8 bc 03 00 00       	call   99a <sbrk>
    printf(1, "allocated %d files <expected: %d> <actual: %d>\n",len/PGSIZE, init - (len/PGSIZE), getNumberOfFreePages());
 5de:	e8 cf 03 00 00       	call   9b2 <getNumberOfFreePages>
 5e3:	89 04 24             	mov    %eax,(%esp)
 5e6:	53                   	push   %ebx
 5e7:	6a 0a                	push   $0xa
 5e9:	68 ec 10 00 00       	push   $0x10ec
 5ee:	6a 01                	push   $0x1
 5f0:	e8 7b 04 00 00       	call   a70 <printf>
}
 5f5:	83 c4 20             	add    $0x20,%esp
 5f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fb:	c9                   	leave  
 5fc:	c3                   	ret    
 5fd:	8d 76 00             	lea    0x0(%esi),%esi

00000600 <free_pages_with_swap_test>:
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	53                   	push   %ebx
 604:	83 ec 04             	sub    $0x4,%esp
    int init_free = getNumberOfFreePages();
 607:	e8 a6 03 00 00       	call   9b2 <getNumberOfFreePages>
    printf(1, "init free pages: %d\n", init_free);
 60c:	83 ec 04             	sub    $0x4,%esp
    int init_free = getNumberOfFreePages();
 60f:	89 c3                	mov    %eax,%ebx
    printf(1, "init free pages: %d\n", init_free);
 611:	50                   	push   %eax
 612:	68 35 11 00 00       	push   $0x1135
 617:	6a 01                	push   $0x1
 619:	e8 52 04 00 00       	call   a70 <printf>
    sbrk(9 * PGSIZE);
 61e:	c7 04 24 00 90 00 00 	movl   $0x9000,(%esp)
 625:	e8 70 03 00 00       	call   99a <sbrk>
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
 62a:	e8 83 03 00 00       	call   9b2 <getNumberOfFreePages>
 62f:	50                   	push   %eax
 630:	8d 43 f7             	lea    -0x9(%ebx),%eax
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
 633:	83 eb 0c             	sub    $0xc,%ebx
    printf(1, "allocated 9 pages. <should be: %d>  <actually: %d>\n",init_free-9, getNumberOfFreePages());
 636:	50                   	push   %eax
 637:	68 f0 0d 00 00       	push   $0xdf0
 63c:	6a 01                	push   $0x1
 63e:	e8 2d 04 00 00       	call   a70 <printf>
    sbrk(3 * PGSIZE);
 643:	83 c4 14             	add    $0x14,%esp
 646:	68 00 30 00 00       	push   $0x3000
 64b:	e8 4a 03 00 00       	call   99a <sbrk>
    printf(1, "allocated 3 more pages. <should be: %d> <actually: %d>\n",init_free-12, getNumberOfFreePages());
 650:	e8 5d 03 00 00       	call   9b2 <getNumberOfFreePages>
 655:	50                   	push   %eax
 656:	53                   	push   %ebx
 657:	68 24 0e 00 00       	push   $0xe24
 65c:	6a 01                	push   $0x1
 65e:	e8 0d 04 00 00       	call   a70 <printf>
    sbrk(1 * PGSIZE);
 663:	83 c4 14             	add    $0x14,%esp
 666:	68 00 10 00 00       	push   $0x1000
 66b:	e8 2a 03 00 00       	call   99a <sbrk>
    printf(1, "allocated 1 more file, will swap page to disk.  <should be: %d> <actually: %d> \n", init_free-12, getNumberOfFreePages());   
 670:	e8 3d 03 00 00       	call   9b2 <getNumberOfFreePages>
 675:	50                   	push   %eax
 676:	53                   	push   %ebx
 677:	68 5c 0e 00 00       	push   $0xe5c
 67c:	6a 01                	push   $0x1
 67e:	e8 ed 03 00 00       	call   a70 <printf>
}
 683:	83 c4 20             	add    $0x20,%esp
 686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 689:	c9                   	leave  
 68a:	c3                   	ret    
 68b:	90                   	nop
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <allocate_more_than_MaxPages_test>:
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 14             	sub    $0x14,%esp
   printf(1, "sbrk res: %d\n", (sbrk(29 * PGSIZE)));
 696:	68 00 d0 01 00       	push   $0x1d000
 69b:	e8 fa 02 00 00       	call   99a <sbrk>
 6a0:	83 c4 0c             	add    $0xc,%esp
 6a3:	50                   	push   %eax
 6a4:	68 4a 11 00 00       	push   $0x114a
 6a9:	6a 01                	push   $0x1
 6ab:	e8 c0 03 00 00       	call   a70 <printf>
}
 6b0:	83 c4 10             	add    $0x10,%esp
 6b3:	c9                   	leave  
 6b4:	c3                   	ret    
 6b5:	66 90                	xchg   %ax,%ax
 6b7:	66 90                	xchg   %ax,%ax
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
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	53                   	push   %ebx
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6ca:	89 c2                	mov    %eax,%edx
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6d0:	83 c1 01             	add    $0x1,%ecx
 6d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 6d7:	83 c2 01             	add    $0x1,%edx
 6da:	84 db                	test   %bl,%bl
 6dc:	88 5a ff             	mov    %bl,-0x1(%edx)
 6df:	75 ef                	jne    6d0 <strcpy+0x10>
    ;
  return os;
}
 6e1:	5b                   	pop    %ebx
 6e2:	5d                   	pop    %ebp
 6e3:	c3                   	ret    
 6e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	53                   	push   %ebx
 6f4:	8b 55 08             	mov    0x8(%ebp),%edx
 6f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 6fa:	0f b6 02             	movzbl (%edx),%eax
 6fd:	0f b6 19             	movzbl (%ecx),%ebx
 700:	84 c0                	test   %al,%al
 702:	75 1c                	jne    720 <strcmp+0x30>
 704:	eb 2a                	jmp    730 <strcmp+0x40>
 706:	8d 76 00             	lea    0x0(%esi),%esi
 709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 710:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 713:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 716:	83 c1 01             	add    $0x1,%ecx
 719:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 71c:	84 c0                	test   %al,%al
 71e:	74 10                	je     730 <strcmp+0x40>
 720:	38 d8                	cmp    %bl,%al
 722:	74 ec                	je     710 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 724:	29 d8                	sub    %ebx,%eax
}
 726:	5b                   	pop    %ebx
 727:	5d                   	pop    %ebp
 728:	c3                   	ret    
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 730:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 732:	29 d8                	sub    %ebx,%eax
}
 734:	5b                   	pop    %ebx
 735:	5d                   	pop    %ebp
 736:	c3                   	ret    
 737:	89 f6                	mov    %esi,%esi
 739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000740 <strlen>:

uint
strlen(const char *s)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 746:	80 39 00             	cmpb   $0x0,(%ecx)
 749:	74 15                	je     760 <strlen+0x20>
 74b:	31 d2                	xor    %edx,%edx
 74d:	8d 76 00             	lea    0x0(%esi),%esi
 750:	83 c2 01             	add    $0x1,%edx
 753:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 757:	89 d0                	mov    %edx,%eax
 759:	75 f5                	jne    750 <strlen+0x10>
    ;
  return n;
}
 75b:	5d                   	pop    %ebp
 75c:	c3                   	ret    
 75d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 760:	31 c0                	xor    %eax,%eax
}
 762:	5d                   	pop    %ebp
 763:	c3                   	ret    
 764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 76a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000770 <memset>:

void*
memset(void *dst, int c, uint n)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 777:	8b 4d 10             	mov    0x10(%ebp),%ecx
 77a:	8b 45 0c             	mov    0xc(%ebp),%eax
 77d:	89 d7                	mov    %edx,%edi
 77f:	fc                   	cld    
 780:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 782:	89 d0                	mov    %edx,%eax
 784:	5f                   	pop    %edi
 785:	5d                   	pop    %ebp
 786:	c3                   	ret    
 787:	89 f6                	mov    %esi,%esi
 789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000790 <strchr>:

char*
strchr(const char *s, char c)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	53                   	push   %ebx
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 79a:	0f b6 10             	movzbl (%eax),%edx
 79d:	84 d2                	test   %dl,%dl
 79f:	74 1d                	je     7be <strchr+0x2e>
    if(*s == c)
 7a1:	38 d3                	cmp    %dl,%bl
 7a3:	89 d9                	mov    %ebx,%ecx
 7a5:	75 0d                	jne    7b4 <strchr+0x24>
 7a7:	eb 17                	jmp    7c0 <strchr+0x30>
 7a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7b0:	38 ca                	cmp    %cl,%dl
 7b2:	74 0c                	je     7c0 <strchr+0x30>
  for(; *s; s++)
 7b4:	83 c0 01             	add    $0x1,%eax
 7b7:	0f b6 10             	movzbl (%eax),%edx
 7ba:	84 d2                	test   %dl,%dl
 7bc:	75 f2                	jne    7b0 <strchr+0x20>
      return (char*)s;
  return 0;
 7be:	31 c0                	xor    %eax,%eax
}
 7c0:	5b                   	pop    %ebx
 7c1:	5d                   	pop    %ebp
 7c2:	c3                   	ret    
 7c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 7c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000007d0 <gets>:

char*
gets(char *buf, int max)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	57                   	push   %edi
 7d4:	56                   	push   %esi
 7d5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7d6:	31 f6                	xor    %esi,%esi
 7d8:	89 f3                	mov    %esi,%ebx
{
 7da:	83 ec 1c             	sub    $0x1c,%esp
 7dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 7e0:	eb 2f                	jmp    811 <gets+0x41>
 7e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 7e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7eb:	83 ec 04             	sub    $0x4,%esp
 7ee:	6a 01                	push   $0x1
 7f0:	50                   	push   %eax
 7f1:	6a 00                	push   $0x0
 7f3:	e8 32 01 00 00       	call   92a <read>
    if(cc < 1)
 7f8:	83 c4 10             	add    $0x10,%esp
 7fb:	85 c0                	test   %eax,%eax
 7fd:	7e 1c                	jle    81b <gets+0x4b>
      break;
    buf[i++] = c;
 7ff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 803:	83 c7 01             	add    $0x1,%edi
 806:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 809:	3c 0a                	cmp    $0xa,%al
 80b:	74 23                	je     830 <gets+0x60>
 80d:	3c 0d                	cmp    $0xd,%al
 80f:	74 1f                	je     830 <gets+0x60>
  for(i=0; i+1 < max; ){
 811:	83 c3 01             	add    $0x1,%ebx
 814:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 817:	89 fe                	mov    %edi,%esi
 819:	7c cd                	jl     7e8 <gets+0x18>
 81b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 820:	c6 03 00             	movb   $0x0,(%ebx)
}
 823:	8d 65 f4             	lea    -0xc(%ebp),%esp
 826:	5b                   	pop    %ebx
 827:	5e                   	pop    %esi
 828:	5f                   	pop    %edi
 829:	5d                   	pop    %ebp
 82a:	c3                   	ret    
 82b:	90                   	nop
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 830:	8b 75 08             	mov    0x8(%ebp),%esi
 833:	8b 45 08             	mov    0x8(%ebp),%eax
 836:	01 de                	add    %ebx,%esi
 838:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 83a:	c6 03 00             	movb   $0x0,(%ebx)
}
 83d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 840:	5b                   	pop    %ebx
 841:	5e                   	pop    %esi
 842:	5f                   	pop    %edi
 843:	5d                   	pop    %ebp
 844:	c3                   	ret    
 845:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000850 <stat>:

int
stat(const char *n, struct stat *st)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	56                   	push   %esi
 854:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 855:	83 ec 08             	sub    $0x8,%esp
 858:	6a 00                	push   $0x0
 85a:	ff 75 08             	pushl  0x8(%ebp)
 85d:	e8 f0 00 00 00       	call   952 <open>
  if(fd < 0)
 862:	83 c4 10             	add    $0x10,%esp
 865:	85 c0                	test   %eax,%eax
 867:	78 27                	js     890 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 869:	83 ec 08             	sub    $0x8,%esp
 86c:	ff 75 0c             	pushl  0xc(%ebp)
 86f:	89 c3                	mov    %eax,%ebx
 871:	50                   	push   %eax
 872:	e8 f3 00 00 00       	call   96a <fstat>
  close(fd);
 877:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 87a:	89 c6                	mov    %eax,%esi
  close(fd);
 87c:	e8 b9 00 00 00       	call   93a <close>
  return r;
 881:	83 c4 10             	add    $0x10,%esp
}
 884:	8d 65 f8             	lea    -0x8(%ebp),%esp
 887:	89 f0                	mov    %esi,%eax
 889:	5b                   	pop    %ebx
 88a:	5e                   	pop    %esi
 88b:	5d                   	pop    %ebp
 88c:	c3                   	ret    
 88d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 890:	be ff ff ff ff       	mov    $0xffffffff,%esi
 895:	eb ed                	jmp    884 <stat+0x34>
 897:	89 f6                	mov    %esi,%esi
 899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000008a0 <atoi>:

int
atoi(const char *s)
{
 8a0:	55                   	push   %ebp
 8a1:	89 e5                	mov    %esp,%ebp
 8a3:	53                   	push   %ebx
 8a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8a7:	0f be 11             	movsbl (%ecx),%edx
 8aa:	8d 42 d0             	lea    -0x30(%edx),%eax
 8ad:	3c 09                	cmp    $0x9,%al
  n = 0;
 8af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 8b4:	77 1f                	ja     8d5 <atoi+0x35>
 8b6:	8d 76 00             	lea    0x0(%esi),%esi
 8b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 8c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 8c3:	83 c1 01             	add    $0x1,%ecx
 8c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 8ca:	0f be 11             	movsbl (%ecx),%edx
 8cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
 8d0:	80 fb 09             	cmp    $0x9,%bl
 8d3:	76 eb                	jbe    8c0 <atoi+0x20>
  return n;
}
 8d5:	5b                   	pop    %ebx
 8d6:	5d                   	pop    %ebp
 8d7:	c3                   	ret    
 8d8:	90                   	nop
 8d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8e0:	55                   	push   %ebp
 8e1:	89 e5                	mov    %esp,%ebp
 8e3:	56                   	push   %esi
 8e4:	53                   	push   %ebx
 8e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8e8:	8b 45 08             	mov    0x8(%ebp),%eax
 8eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8ee:	85 db                	test   %ebx,%ebx
 8f0:	7e 14                	jle    906 <memmove+0x26>
 8f2:	31 d2                	xor    %edx,%edx
 8f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 8f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 8fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 8ff:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 902:	39 d3                	cmp    %edx,%ebx
 904:	75 f2                	jne    8f8 <memmove+0x18>
  return vdst;
}
 906:	5b                   	pop    %ebx
 907:	5e                   	pop    %esi
 908:	5d                   	pop    %ebp
 909:	c3                   	ret    

0000090a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 90a:	b8 01 00 00 00       	mov    $0x1,%eax
 90f:	cd 40                	int    $0x40
 911:	c3                   	ret    

00000912 <exit>:
SYSCALL(exit)
 912:	b8 02 00 00 00       	mov    $0x2,%eax
 917:	cd 40                	int    $0x40
 919:	c3                   	ret    

0000091a <wait>:
SYSCALL(wait)
 91a:	b8 03 00 00 00       	mov    $0x3,%eax
 91f:	cd 40                	int    $0x40
 921:	c3                   	ret    

00000922 <pipe>:
SYSCALL(pipe)
 922:	b8 04 00 00 00       	mov    $0x4,%eax
 927:	cd 40                	int    $0x40
 929:	c3                   	ret    

0000092a <read>:
SYSCALL(read)
 92a:	b8 05 00 00 00       	mov    $0x5,%eax
 92f:	cd 40                	int    $0x40
 931:	c3                   	ret    

00000932 <write>:
SYSCALL(write)
 932:	b8 10 00 00 00       	mov    $0x10,%eax
 937:	cd 40                	int    $0x40
 939:	c3                   	ret    

0000093a <close>:
SYSCALL(close)
 93a:	b8 15 00 00 00       	mov    $0x15,%eax
 93f:	cd 40                	int    $0x40
 941:	c3                   	ret    

00000942 <kill>:
SYSCALL(kill)
 942:	b8 06 00 00 00       	mov    $0x6,%eax
 947:	cd 40                	int    $0x40
 949:	c3                   	ret    

0000094a <exec>:
SYSCALL(exec)
 94a:	b8 07 00 00 00       	mov    $0x7,%eax
 94f:	cd 40                	int    $0x40
 951:	c3                   	ret    

00000952 <open>:
SYSCALL(open)
 952:	b8 0f 00 00 00       	mov    $0xf,%eax
 957:	cd 40                	int    $0x40
 959:	c3                   	ret    

0000095a <mknod>:
SYSCALL(mknod)
 95a:	b8 11 00 00 00       	mov    $0x11,%eax
 95f:	cd 40                	int    $0x40
 961:	c3                   	ret    

00000962 <unlink>:
SYSCALL(unlink)
 962:	b8 12 00 00 00       	mov    $0x12,%eax
 967:	cd 40                	int    $0x40
 969:	c3                   	ret    

0000096a <fstat>:
SYSCALL(fstat)
 96a:	b8 08 00 00 00       	mov    $0x8,%eax
 96f:	cd 40                	int    $0x40
 971:	c3                   	ret    

00000972 <link>:
SYSCALL(link)
 972:	b8 13 00 00 00       	mov    $0x13,%eax
 977:	cd 40                	int    $0x40
 979:	c3                   	ret    

0000097a <mkdir>:
SYSCALL(mkdir)
 97a:	b8 14 00 00 00       	mov    $0x14,%eax
 97f:	cd 40                	int    $0x40
 981:	c3                   	ret    

00000982 <chdir>:
SYSCALL(chdir)
 982:	b8 09 00 00 00       	mov    $0x9,%eax
 987:	cd 40                	int    $0x40
 989:	c3                   	ret    

0000098a <dup>:
SYSCALL(dup)
 98a:	b8 0a 00 00 00       	mov    $0xa,%eax
 98f:	cd 40                	int    $0x40
 991:	c3                   	ret    

00000992 <getpid>:
SYSCALL(getpid)
 992:	b8 0b 00 00 00       	mov    $0xb,%eax
 997:	cd 40                	int    $0x40
 999:	c3                   	ret    

0000099a <sbrk>:
SYSCALL(sbrk)
 99a:	b8 0c 00 00 00       	mov    $0xc,%eax
 99f:	cd 40                	int    $0x40
 9a1:	c3                   	ret    

000009a2 <sleep>:
SYSCALL(sleep)
 9a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 9a7:	cd 40                	int    $0x40
 9a9:	c3                   	ret    

000009aa <uptime>:
SYSCALL(uptime)
 9aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 9af:	cd 40                	int    $0x40
 9b1:	c3                   	ret    

000009b2 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
 9b2:	b8 17 00 00 00       	mov    $0x17,%eax
 9b7:	cd 40                	int    $0x40
 9b9:	c3                   	ret    

000009ba <getNumRefs>:
 9ba:	b8 18 00 00 00       	mov    $0x18,%eax
 9bf:	cd 40                	int    $0x40
 9c1:	c3                   	ret    
 9c2:	66 90                	xchg   %ax,%ax
 9c4:	66 90                	xchg   %ax,%ax
 9c6:	66 90                	xchg   %ax,%ax
 9c8:	66 90                	xchg   %ax,%ax
 9ca:	66 90                	xchg   %ax,%ax
 9cc:	66 90                	xchg   %ax,%ax
 9ce:	66 90                	xchg   %ax,%ax

000009d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 9d0:	55                   	push   %ebp
 9d1:	89 e5                	mov    %esp,%ebp
 9d3:	57                   	push   %edi
 9d4:	56                   	push   %esi
 9d5:	53                   	push   %ebx
 9d6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 9d9:	85 d2                	test   %edx,%edx
{
 9db:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 9de:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 9e0:	79 76                	jns    a58 <printint+0x88>
 9e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 9e6:	74 70                	je     a58 <printint+0x88>
    x = -xx;
 9e8:	f7 d8                	neg    %eax
    neg = 1;
 9ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 9f1:	31 f6                	xor    %esi,%esi
 9f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 9f6:	eb 0a                	jmp    a02 <printint+0x32>
 9f8:	90                   	nop
 9f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 a00:	89 fe                	mov    %edi,%esi
 a02:	31 d2                	xor    %edx,%edx
 a04:	8d 7e 01             	lea    0x1(%esi),%edi
 a07:	f7 f1                	div    %ecx
 a09:	0f b6 92 04 12 00 00 	movzbl 0x1204(%edx),%edx
  }while((x /= base) != 0);
 a10:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 a12:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 a15:	75 e9                	jne    a00 <printint+0x30>
  if(neg)
 a17:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 a1a:	85 c0                	test   %eax,%eax
 a1c:	74 08                	je     a26 <printint+0x56>
    buf[i++] = '-';
 a1e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 a23:	8d 7e 02             	lea    0x2(%esi),%edi
 a26:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 a2a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 a2d:	8d 76 00             	lea    0x0(%esi),%esi
 a30:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 a33:	83 ec 04             	sub    $0x4,%esp
 a36:	83 ee 01             	sub    $0x1,%esi
 a39:	6a 01                	push   $0x1
 a3b:	53                   	push   %ebx
 a3c:	57                   	push   %edi
 a3d:	88 45 d7             	mov    %al,-0x29(%ebp)
 a40:	e8 ed fe ff ff       	call   932 <write>

  while(--i >= 0)
 a45:	83 c4 10             	add    $0x10,%esp
 a48:	39 de                	cmp    %ebx,%esi
 a4a:	75 e4                	jne    a30 <printint+0x60>
    putc(fd, buf[i]);
}
 a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a4f:	5b                   	pop    %ebx
 a50:	5e                   	pop    %esi
 a51:	5f                   	pop    %edi
 a52:	5d                   	pop    %ebp
 a53:	c3                   	ret    
 a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 a58:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 a5f:	eb 90                	jmp    9f1 <printint+0x21>
 a61:	eb 0d                	jmp    a70 <printf>
 a63:	90                   	nop
 a64:	90                   	nop
 a65:	90                   	nop
 a66:	90                   	nop
 a67:	90                   	nop
 a68:	90                   	nop
 a69:	90                   	nop
 a6a:	90                   	nop
 a6b:	90                   	nop
 a6c:	90                   	nop
 a6d:	90                   	nop
 a6e:	90                   	nop
 a6f:	90                   	nop

00000a70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	57                   	push   %edi
 a74:	56                   	push   %esi
 a75:	53                   	push   %ebx
 a76:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a79:	8b 75 0c             	mov    0xc(%ebp),%esi
 a7c:	0f b6 1e             	movzbl (%esi),%ebx
 a7f:	84 db                	test   %bl,%bl
 a81:	0f 84 b3 00 00 00    	je     b3a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 a87:	8d 45 10             	lea    0x10(%ebp),%eax
 a8a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 a8d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 a8f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 a92:	eb 2f                	jmp    ac3 <printf+0x53>
 a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 a98:	83 f8 25             	cmp    $0x25,%eax
 a9b:	0f 84 a7 00 00 00    	je     b48 <printf+0xd8>
  write(fd, &c, 1);
 aa1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 aa4:	83 ec 04             	sub    $0x4,%esp
 aa7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 aaa:	6a 01                	push   $0x1
 aac:	50                   	push   %eax
 aad:	ff 75 08             	pushl  0x8(%ebp)
 ab0:	e8 7d fe ff ff       	call   932 <write>
 ab5:	83 c4 10             	add    $0x10,%esp
 ab8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 abb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 abf:	84 db                	test   %bl,%bl
 ac1:	74 77                	je     b3a <printf+0xca>
    if(state == 0){
 ac3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 ac5:	0f be cb             	movsbl %bl,%ecx
 ac8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 acb:	74 cb                	je     a98 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 acd:	83 ff 25             	cmp    $0x25,%edi
 ad0:	75 e6                	jne    ab8 <printf+0x48>
      if(c == 'd'){
 ad2:	83 f8 64             	cmp    $0x64,%eax
 ad5:	0f 84 05 01 00 00    	je     be0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 adb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 ae1:	83 f9 70             	cmp    $0x70,%ecx
 ae4:	74 72                	je     b58 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 ae6:	83 f8 73             	cmp    $0x73,%eax
 ae9:	0f 84 99 00 00 00    	je     b88 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 aef:	83 f8 63             	cmp    $0x63,%eax
 af2:	0f 84 08 01 00 00    	je     c00 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 af8:	83 f8 25             	cmp    $0x25,%eax
 afb:	0f 84 ef 00 00 00    	je     bf0 <printf+0x180>
  write(fd, &c, 1);
 b01:	8d 45 e7             	lea    -0x19(%ebp),%eax
 b04:	83 ec 04             	sub    $0x4,%esp
 b07:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b0b:	6a 01                	push   $0x1
 b0d:	50                   	push   %eax
 b0e:	ff 75 08             	pushl  0x8(%ebp)
 b11:	e8 1c fe ff ff       	call   932 <write>
 b16:	83 c4 0c             	add    $0xc,%esp
 b19:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 b1c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 b1f:	6a 01                	push   $0x1
 b21:	50                   	push   %eax
 b22:	ff 75 08             	pushl  0x8(%ebp)
 b25:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b28:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 b2a:	e8 03 fe ff ff       	call   932 <write>
  for(i = 0; fmt[i]; i++){
 b2f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 b33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 b36:	84 db                	test   %bl,%bl
 b38:	75 89                	jne    ac3 <printf+0x53>
    }
  }
}
 b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b3d:	5b                   	pop    %ebx
 b3e:	5e                   	pop    %esi
 b3f:	5f                   	pop    %edi
 b40:	5d                   	pop    %ebp
 b41:	c3                   	ret    
 b42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 b48:	bf 25 00 00 00       	mov    $0x25,%edi
 b4d:	e9 66 ff ff ff       	jmp    ab8 <printf+0x48>
 b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 b58:	83 ec 0c             	sub    $0xc,%esp
 b5b:	b9 10 00 00 00       	mov    $0x10,%ecx
 b60:	6a 00                	push   $0x0
 b62:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 b65:	8b 45 08             	mov    0x8(%ebp),%eax
 b68:	8b 17                	mov    (%edi),%edx
 b6a:	e8 61 fe ff ff       	call   9d0 <printint>
        ap++;
 b6f:	89 f8                	mov    %edi,%eax
 b71:	83 c4 10             	add    $0x10,%esp
      state = 0;
 b74:	31 ff                	xor    %edi,%edi
        ap++;
 b76:	83 c0 04             	add    $0x4,%eax
 b79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 b7c:	e9 37 ff ff ff       	jmp    ab8 <printf+0x48>
 b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 b88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 b8b:	8b 08                	mov    (%eax),%ecx
        ap++;
 b8d:	83 c0 04             	add    $0x4,%eax
 b90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 b93:	85 c9                	test   %ecx,%ecx
 b95:	0f 84 8e 00 00 00    	je     c29 <printf+0x1b9>
        while(*s != 0){
 b9b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 b9e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 ba0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 ba2:	84 c0                	test   %al,%al
 ba4:	0f 84 0e ff ff ff    	je     ab8 <printf+0x48>
 baa:	89 75 d0             	mov    %esi,-0x30(%ebp)
 bad:	89 de                	mov    %ebx,%esi
 baf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 bb2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 bb5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 bb8:	83 ec 04             	sub    $0x4,%esp
          s++;
 bbb:	83 c6 01             	add    $0x1,%esi
 bbe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 bc1:	6a 01                	push   $0x1
 bc3:	57                   	push   %edi
 bc4:	53                   	push   %ebx
 bc5:	e8 68 fd ff ff       	call   932 <write>
        while(*s != 0){
 bca:	0f b6 06             	movzbl (%esi),%eax
 bcd:	83 c4 10             	add    $0x10,%esp
 bd0:	84 c0                	test   %al,%al
 bd2:	75 e4                	jne    bb8 <printf+0x148>
 bd4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 bd7:	31 ff                	xor    %edi,%edi
 bd9:	e9 da fe ff ff       	jmp    ab8 <printf+0x48>
 bde:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 be0:	83 ec 0c             	sub    $0xc,%esp
 be3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 be8:	6a 01                	push   $0x1
 bea:	e9 73 ff ff ff       	jmp    b62 <printf+0xf2>
 bef:	90                   	nop
  write(fd, &c, 1);
 bf0:	83 ec 04             	sub    $0x4,%esp
 bf3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 bf6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 bf9:	6a 01                	push   $0x1
 bfb:	e9 21 ff ff ff       	jmp    b21 <printf+0xb1>
        putc(fd, *ap);
 c00:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 c03:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 c06:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 c08:	6a 01                	push   $0x1
        ap++;
 c0a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 c0d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 c10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 c13:	50                   	push   %eax
 c14:	ff 75 08             	pushl  0x8(%ebp)
 c17:	e8 16 fd ff ff       	call   932 <write>
        ap++;
 c1c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 c1f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 c22:	31 ff                	xor    %edi,%edi
 c24:	e9 8f fe ff ff       	jmp    ab8 <printf+0x48>
          s = "(null)";
 c29:	bb fc 11 00 00       	mov    $0x11fc,%ebx
        while(*s != 0){
 c2e:	b8 28 00 00 00       	mov    $0x28,%eax
 c33:	e9 72 ff ff ff       	jmp    baa <printf+0x13a>
 c38:	66 90                	xchg   %ax,%ax
 c3a:	66 90                	xchg   %ax,%ax
 c3c:	66 90                	xchg   %ax,%ax
 c3e:	66 90                	xchg   %ax,%ax

00000c40 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c40:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c41:	a1 fc 15 00 00       	mov    0x15fc,%eax
{
 c46:	89 e5                	mov    %esp,%ebp
 c48:	57                   	push   %edi
 c49:	56                   	push   %esi
 c4a:	53                   	push   %ebx
 c4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 c4e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c58:	39 c8                	cmp    %ecx,%eax
 c5a:	8b 10                	mov    (%eax),%edx
 c5c:	73 32                	jae    c90 <free+0x50>
 c5e:	39 d1                	cmp    %edx,%ecx
 c60:	72 04                	jb     c66 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c62:	39 d0                	cmp    %edx,%eax
 c64:	72 32                	jb     c98 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 c66:	8b 73 fc             	mov    -0x4(%ebx),%esi
 c69:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 c6c:	39 fa                	cmp    %edi,%edx
 c6e:	74 30                	je     ca0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 c70:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 c73:	8b 50 04             	mov    0x4(%eax),%edx
 c76:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 c79:	39 f1                	cmp    %esi,%ecx
 c7b:	74 3a                	je     cb7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 c7d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 c7f:	a3 fc 15 00 00       	mov    %eax,0x15fc
}
 c84:	5b                   	pop    %ebx
 c85:	5e                   	pop    %esi
 c86:	5f                   	pop    %edi
 c87:	5d                   	pop    %ebp
 c88:	c3                   	ret    
 c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c90:	39 d0                	cmp    %edx,%eax
 c92:	72 04                	jb     c98 <free+0x58>
 c94:	39 d1                	cmp    %edx,%ecx
 c96:	72 ce                	jb     c66 <free+0x26>
{
 c98:	89 d0                	mov    %edx,%eax
 c9a:	eb bc                	jmp    c58 <free+0x18>
 c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 ca0:	03 72 04             	add    0x4(%edx),%esi
 ca3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ca6:	8b 10                	mov    (%eax),%edx
 ca8:	8b 12                	mov    (%edx),%edx
 caa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 cad:	8b 50 04             	mov    0x4(%eax),%edx
 cb0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cb3:	39 f1                	cmp    %esi,%ecx
 cb5:	75 c6                	jne    c7d <free+0x3d>
    p->s.size += bp->s.size;
 cb7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 cba:	a3 fc 15 00 00       	mov    %eax,0x15fc
    p->s.size += bp->s.size;
 cbf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cc2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 cc5:	89 10                	mov    %edx,(%eax)
}
 cc7:	5b                   	pop    %ebx
 cc8:	5e                   	pop    %esi
 cc9:	5f                   	pop    %edi
 cca:	5d                   	pop    %ebp
 ccb:	c3                   	ret    
 ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cd0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 cd0:	55                   	push   %ebp
 cd1:	89 e5                	mov    %esp,%ebp
 cd3:	57                   	push   %edi
 cd4:	56                   	push   %esi
 cd5:	53                   	push   %ebx
 cd6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 cdc:	8b 15 fc 15 00 00    	mov    0x15fc,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ce2:	8d 78 07             	lea    0x7(%eax),%edi
 ce5:	c1 ef 03             	shr    $0x3,%edi
 ce8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 ceb:	85 d2                	test   %edx,%edx
 ced:	0f 84 9d 00 00 00    	je     d90 <malloc+0xc0>
 cf3:	8b 02                	mov    (%edx),%eax
 cf5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 cf8:	39 cf                	cmp    %ecx,%edi
 cfa:	76 6c                	jbe    d68 <malloc+0x98>
 cfc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 d02:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d07:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 d0a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 d11:	eb 0e                	jmp    d21 <malloc+0x51>
 d13:	90                   	nop
 d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d18:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 d1a:	8b 48 04             	mov    0x4(%eax),%ecx
 d1d:	39 f9                	cmp    %edi,%ecx
 d1f:	73 47                	jae    d68 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d21:	39 05 fc 15 00 00    	cmp    %eax,0x15fc
 d27:	89 c2                	mov    %eax,%edx
 d29:	75 ed                	jne    d18 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 d2b:	83 ec 0c             	sub    $0xc,%esp
 d2e:	56                   	push   %esi
 d2f:	e8 66 fc ff ff       	call   99a <sbrk>
  if(p == (char*)-1)
 d34:	83 c4 10             	add    $0x10,%esp
 d37:	83 f8 ff             	cmp    $0xffffffff,%eax
 d3a:	74 1c                	je     d58 <malloc+0x88>
  hp->s.size = nu;
 d3c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d3f:	83 ec 0c             	sub    $0xc,%esp
 d42:	83 c0 08             	add    $0x8,%eax
 d45:	50                   	push   %eax
 d46:	e8 f5 fe ff ff       	call   c40 <free>
  return freep;
 d4b:	8b 15 fc 15 00 00    	mov    0x15fc,%edx
      if((p = morecore(nunits)) == 0)
 d51:	83 c4 10             	add    $0x10,%esp
 d54:	85 d2                	test   %edx,%edx
 d56:	75 c0                	jne    d18 <malloc+0x48>
        return 0;
  }
}
 d58:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 d5b:	31 c0                	xor    %eax,%eax
}
 d5d:	5b                   	pop    %ebx
 d5e:	5e                   	pop    %esi
 d5f:	5f                   	pop    %edi
 d60:	5d                   	pop    %ebp
 d61:	c3                   	ret    
 d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 d68:	39 cf                	cmp    %ecx,%edi
 d6a:	74 54                	je     dc0 <malloc+0xf0>
        p->s.size -= nunits;
 d6c:	29 f9                	sub    %edi,%ecx
 d6e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 d71:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 d74:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 d77:	89 15 fc 15 00 00    	mov    %edx,0x15fc
}
 d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 d80:	83 c0 08             	add    $0x8,%eax
}
 d83:	5b                   	pop    %ebx
 d84:	5e                   	pop    %esi
 d85:	5f                   	pop    %edi
 d86:	5d                   	pop    %ebp
 d87:	c3                   	ret    
 d88:	90                   	nop
 d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 d90:	c7 05 fc 15 00 00 00 	movl   $0x1600,0x15fc
 d97:	16 00 00 
 d9a:	c7 05 00 16 00 00 00 	movl   $0x1600,0x1600
 da1:	16 00 00 
    base.s.size = 0;
 da4:	b8 00 16 00 00       	mov    $0x1600,%eax
 da9:	c7 05 04 16 00 00 00 	movl   $0x0,0x1604
 db0:	00 00 00 
 db3:	e9 44 ff ff ff       	jmp    cfc <malloc+0x2c>
 db8:	90                   	nop
 db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 dc0:	8b 08                	mov    (%eax),%ecx
 dc2:	89 0a                	mov    %ecx,(%edx)
 dc4:	eb b1                	jmp    d77 <malloc+0xa7>
