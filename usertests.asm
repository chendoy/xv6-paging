
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	pushl  -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
      11:	68 c6 4c 00 00       	push   $0x4cc6
      16:	6a 01                	push   $0x1
      18:	e8 53 39 00 00       	call   3970 <printf>

  if(open("usertests.ran", 0) >= 0){
      1d:	59                   	pop    %ecx
      1e:	58                   	pop    %eax
      1f:	6a 00                	push   $0x0
      21:	68 da 4c 00 00       	push   $0x4cda
      26:	e8 27 38 00 00       	call   3852 <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	85 c0                	test   %eax,%eax
      30:	78 13                	js     45 <main+0x45>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      32:	52                   	push   %edx
      33:	52                   	push   %edx
      34:	68 44 54 00 00       	push   $0x5444
      39:	6a 01                	push   $0x1
      3b:	e8 30 39 00 00       	call   3970 <printf>
    exit();
      40:	e8 cd 37 00 00       	call   3812 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      45:	50                   	push   %eax
      46:	50                   	push   %eax
      47:	68 00 02 00 00       	push   $0x200
      4c:	68 da 4c 00 00       	push   $0x4cda
      51:	e8 fc 37 00 00       	call   3852 <open>
      56:	89 04 24             	mov    %eax,(%esp)
      59:	e8 dc 37 00 00       	call   383a <close>

  // openiputtest();
  // exitiputtest();
  // iputtest();

  mem();
      5e:	e8 6d 0c 00 00       	call   cd0 <mem>

  // uio();

  // exectest();

  exit();
      63:	e8 aa 37 00 00       	call   3812 <exit>
      68:	66 90                	xchg   %ax,%ax
      6a:	66 90                	xchg   %ax,%ax
      6c:	66 90                	xchg   %ax,%ax
      6e:	66 90                	xchg   %ax,%ax

00000070 <iputtest>:
{
      70:	55                   	push   %ebp
      71:	89 e5                	mov    %esp,%ebp
      73:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
      76:	68 5c 3d 00 00       	push   $0x3d5c
      7b:	ff 35 88 5d 00 00    	pushl  0x5d88
      81:	e8 ea 38 00 00       	call   3970 <printf>
  if(mkdir("iputdir") < 0){
      86:	c7 04 24 ef 3c 00 00 	movl   $0x3cef,(%esp)
      8d:	e8 e8 37 00 00       	call   387a <mkdir>
      92:	83 c4 10             	add    $0x10,%esp
      95:	85 c0                	test   %eax,%eax
      97:	78 58                	js     f1 <iputtest+0x81>
  if(chdir("iputdir") < 0){
      99:	83 ec 0c             	sub    $0xc,%esp
      9c:	68 ef 3c 00 00       	push   $0x3cef
      a1:	e8 dc 37 00 00       	call   3882 <chdir>
      a6:	83 c4 10             	add    $0x10,%esp
      a9:	85 c0                	test   %eax,%eax
      ab:	0f 88 85 00 00 00    	js     136 <iputtest+0xc6>
  if(unlink("../iputdir") < 0){
      b1:	83 ec 0c             	sub    $0xc,%esp
      b4:	68 ec 3c 00 00       	push   $0x3cec
      b9:	e8 a4 37 00 00       	call   3862 <unlink>
      be:	83 c4 10             	add    $0x10,%esp
      c1:	85 c0                	test   %eax,%eax
      c3:	78 5a                	js     11f <iputtest+0xaf>
  if(chdir("/") < 0){
      c5:	83 ec 0c             	sub    $0xc,%esp
      c8:	68 11 3d 00 00       	push   $0x3d11
      cd:	e8 b0 37 00 00       	call   3882 <chdir>
      d2:	83 c4 10             	add    $0x10,%esp
      d5:	85 c0                	test   %eax,%eax
      d7:	78 2f                	js     108 <iputtest+0x98>
  printf(stdout, "iput test ok\n");
      d9:	83 ec 08             	sub    $0x8,%esp
      dc:	68 94 3d 00 00       	push   $0x3d94
      e1:	ff 35 88 5d 00 00    	pushl  0x5d88
      e7:	e8 84 38 00 00       	call   3970 <printf>
}
      ec:	83 c4 10             	add    $0x10,%esp
      ef:	c9                   	leave  
      f0:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      f1:	50                   	push   %eax
      f2:	50                   	push   %eax
      f3:	68 c8 3c 00 00       	push   $0x3cc8
      f8:	ff 35 88 5d 00 00    	pushl  0x5d88
      fe:	e8 6d 38 00 00       	call   3970 <printf>
    exit();
     103:	e8 0a 37 00 00       	call   3812 <exit>
    printf(stdout, "chdir / failed\n");
     108:	50                   	push   %eax
     109:	50                   	push   %eax
     10a:	68 13 3d 00 00       	push   $0x3d13
     10f:	ff 35 88 5d 00 00    	pushl  0x5d88
     115:	e8 56 38 00 00       	call   3970 <printf>
    exit();
     11a:	e8 f3 36 00 00       	call   3812 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     11f:	52                   	push   %edx
     120:	52                   	push   %edx
     121:	68 f7 3c 00 00       	push   $0x3cf7
     126:	ff 35 88 5d 00 00    	pushl  0x5d88
     12c:	e8 3f 38 00 00       	call   3970 <printf>
    exit();
     131:	e8 dc 36 00 00       	call   3812 <exit>
    printf(stdout, "chdir iputdir failed\n");
     136:	51                   	push   %ecx
     137:	51                   	push   %ecx
     138:	68 d6 3c 00 00       	push   $0x3cd6
     13d:	ff 35 88 5d 00 00    	pushl  0x5d88
     143:	e8 28 38 00 00       	call   3970 <printf>
    exit();
     148:	e8 c5 36 00 00       	call   3812 <exit>
     14d:	8d 76 00             	lea    0x0(%esi),%esi

00000150 <exitiputtest>:
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     156:	68 23 3d 00 00       	push   $0x3d23
     15b:	ff 35 88 5d 00 00    	pushl  0x5d88
     161:	e8 0a 38 00 00       	call   3970 <printf>
  pid = fork();
     166:	e8 9f 36 00 00       	call   380a <fork>
  if(pid < 0){
     16b:	83 c4 10             	add    $0x10,%esp
     16e:	85 c0                	test   %eax,%eax
     170:	0f 88 82 00 00 00    	js     1f8 <exitiputtest+0xa8>
  if(pid == 0){
     176:	75 48                	jne    1c0 <exitiputtest+0x70>
    if(mkdir("iputdir") < 0){
     178:	83 ec 0c             	sub    $0xc,%esp
     17b:	68 ef 3c 00 00       	push   $0x3cef
     180:	e8 f5 36 00 00       	call   387a <mkdir>
     185:	83 c4 10             	add    $0x10,%esp
     188:	85 c0                	test   %eax,%eax
     18a:	0f 88 96 00 00 00    	js     226 <exitiputtest+0xd6>
    if(chdir("iputdir") < 0){
     190:	83 ec 0c             	sub    $0xc,%esp
     193:	68 ef 3c 00 00       	push   $0x3cef
     198:	e8 e5 36 00 00       	call   3882 <chdir>
     19d:	83 c4 10             	add    $0x10,%esp
     1a0:	85 c0                	test   %eax,%eax
     1a2:	78 6b                	js     20f <exitiputtest+0xbf>
    if(unlink("../iputdir") < 0){
     1a4:	83 ec 0c             	sub    $0xc,%esp
     1a7:	68 ec 3c 00 00       	push   $0x3cec
     1ac:	e8 b1 36 00 00       	call   3862 <unlink>
     1b1:	83 c4 10             	add    $0x10,%esp
     1b4:	85 c0                	test   %eax,%eax
     1b6:	78 28                	js     1e0 <exitiputtest+0x90>
    exit();
     1b8:	e8 55 36 00 00       	call   3812 <exit>
     1bd:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     1c0:	e8 55 36 00 00       	call   381a <wait>
  printf(stdout, "exitiput test ok\n");
     1c5:	83 ec 08             	sub    $0x8,%esp
     1c8:	68 46 3d 00 00       	push   $0x3d46
     1cd:	ff 35 88 5d 00 00    	pushl  0x5d88
     1d3:	e8 98 37 00 00       	call   3970 <printf>
}
     1d8:	83 c4 10             	add    $0x10,%esp
     1db:	c9                   	leave  
     1dc:	c3                   	ret    
     1dd:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     1e0:	83 ec 08             	sub    $0x8,%esp
     1e3:	68 f7 3c 00 00       	push   $0x3cf7
     1e8:	ff 35 88 5d 00 00    	pushl  0x5d88
     1ee:	e8 7d 37 00 00       	call   3970 <printf>
      exit();
     1f3:	e8 1a 36 00 00       	call   3812 <exit>
    printf(stdout, "fork failed\n");
     1f8:	51                   	push   %ecx
     1f9:	51                   	push   %ecx
     1fa:	68 19 4c 00 00       	push   $0x4c19
     1ff:	ff 35 88 5d 00 00    	pushl  0x5d88
     205:	e8 66 37 00 00       	call   3970 <printf>
    exit();
     20a:	e8 03 36 00 00       	call   3812 <exit>
      printf(stdout, "child chdir failed\n");
     20f:	50                   	push   %eax
     210:	50                   	push   %eax
     211:	68 32 3d 00 00       	push   $0x3d32
     216:	ff 35 88 5d 00 00    	pushl  0x5d88
     21c:	e8 4f 37 00 00       	call   3970 <printf>
      exit();
     221:	e8 ec 35 00 00       	call   3812 <exit>
      printf(stdout, "mkdir failed\n");
     226:	52                   	push   %edx
     227:	52                   	push   %edx
     228:	68 c8 3c 00 00       	push   $0x3cc8
     22d:	ff 35 88 5d 00 00    	pushl  0x5d88
     233:	e8 38 37 00 00       	call   3970 <printf>
      exit();
     238:	e8 d5 35 00 00       	call   3812 <exit>
     23d:	8d 76 00             	lea    0x0(%esi),%esi

00000240 <openiputtest>:
{
     240:	55                   	push   %ebp
     241:	89 e5                	mov    %esp,%ebp
     243:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     246:	68 58 3d 00 00       	push   $0x3d58
     24b:	ff 35 88 5d 00 00    	pushl  0x5d88
     251:	e8 1a 37 00 00       	call   3970 <printf>
  if(mkdir("oidir") < 0){
     256:	c7 04 24 67 3d 00 00 	movl   $0x3d67,(%esp)
     25d:	e8 18 36 00 00       	call   387a <mkdir>
     262:	83 c4 10             	add    $0x10,%esp
     265:	85 c0                	test   %eax,%eax
     267:	0f 88 88 00 00 00    	js     2f5 <openiputtest+0xb5>
  pid = fork();
     26d:	e8 98 35 00 00       	call   380a <fork>
  if(pid < 0){
     272:	85 c0                	test   %eax,%eax
     274:	0f 88 92 00 00 00    	js     30c <openiputtest+0xcc>
  if(pid == 0){
     27a:	75 34                	jne    2b0 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     27c:	83 ec 08             	sub    $0x8,%esp
     27f:	6a 02                	push   $0x2
     281:	68 67 3d 00 00       	push   $0x3d67
     286:	e8 c7 35 00 00       	call   3852 <open>
    if(fd >= 0){
     28b:	83 c4 10             	add    $0x10,%esp
     28e:	85 c0                	test   %eax,%eax
     290:	78 5e                	js     2f0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     292:	83 ec 08             	sub    $0x8,%esp
     295:	68 fc 4c 00 00       	push   $0x4cfc
     29a:	ff 35 88 5d 00 00    	pushl  0x5d88
     2a0:	e8 cb 36 00 00       	call   3970 <printf>
      exit();
     2a5:	e8 68 35 00 00       	call   3812 <exit>
     2aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
     2b0:	83 ec 0c             	sub    $0xc,%esp
     2b3:	6a 01                	push   $0x1
     2b5:	e8 e8 35 00 00       	call   38a2 <sleep>
  if(unlink("oidir") != 0){
     2ba:	c7 04 24 67 3d 00 00 	movl   $0x3d67,(%esp)
     2c1:	e8 9c 35 00 00       	call   3862 <unlink>
     2c6:	83 c4 10             	add    $0x10,%esp
     2c9:	85 c0                	test   %eax,%eax
     2cb:	75 56                	jne    323 <openiputtest+0xe3>
  wait();
     2cd:	e8 48 35 00 00       	call   381a <wait>
  printf(stdout, "openiput test ok\n");
     2d2:	83 ec 08             	sub    $0x8,%esp
     2d5:	68 90 3d 00 00       	push   $0x3d90
     2da:	ff 35 88 5d 00 00    	pushl  0x5d88
     2e0:	e8 8b 36 00 00       	call   3970 <printf>
}
     2e5:	83 c4 10             	add    $0x10,%esp
     2e8:	c9                   	leave  
     2e9:	c3                   	ret    
     2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     2f0:	e8 1d 35 00 00       	call   3812 <exit>
    printf(stdout, "mkdir oidir failed\n");
     2f5:	51                   	push   %ecx
     2f6:	51                   	push   %ecx
     2f7:	68 6d 3d 00 00       	push   $0x3d6d
     2fc:	ff 35 88 5d 00 00    	pushl  0x5d88
     302:	e8 69 36 00 00       	call   3970 <printf>
    exit();
     307:	e8 06 35 00 00       	call   3812 <exit>
    printf(stdout, "fork failed\n");
     30c:	52                   	push   %edx
     30d:	52                   	push   %edx
     30e:	68 19 4c 00 00       	push   $0x4c19
     313:	ff 35 88 5d 00 00    	pushl  0x5d88
     319:	e8 52 36 00 00       	call   3970 <printf>
    exit();
     31e:	e8 ef 34 00 00       	call   3812 <exit>
    printf(stdout, "unlink failed\n");
     323:	50                   	push   %eax
     324:	50                   	push   %eax
     325:	68 81 3d 00 00       	push   $0x3d81
     32a:	ff 35 88 5d 00 00    	pushl  0x5d88
     330:	e8 3b 36 00 00       	call   3970 <printf>
    exit();
     335:	e8 d8 34 00 00       	call   3812 <exit>
     33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000340 <opentest>:
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     346:	68 a2 3d 00 00       	push   $0x3da2
     34b:	ff 35 88 5d 00 00    	pushl  0x5d88
     351:	e8 1a 36 00 00       	call   3970 <printf>
  fd = open("echo", 0);
     356:	58                   	pop    %eax
     357:	5a                   	pop    %edx
     358:	6a 00                	push   $0x0
     35a:	68 ad 3d 00 00       	push   $0x3dad
     35f:	e8 ee 34 00 00       	call   3852 <open>
  if(fd < 0){
     364:	83 c4 10             	add    $0x10,%esp
     367:	85 c0                	test   %eax,%eax
     369:	78 36                	js     3a1 <opentest+0x61>
  close(fd);
     36b:	83 ec 0c             	sub    $0xc,%esp
     36e:	50                   	push   %eax
     36f:	e8 c6 34 00 00       	call   383a <close>
  fd = open("doesnotexist", 0);
     374:	5a                   	pop    %edx
     375:	59                   	pop    %ecx
     376:	6a 00                	push   $0x0
     378:	68 c5 3d 00 00       	push   $0x3dc5
     37d:	e8 d0 34 00 00       	call   3852 <open>
  if(fd >= 0){
     382:	83 c4 10             	add    $0x10,%esp
     385:	85 c0                	test   %eax,%eax
     387:	79 2f                	jns    3b8 <opentest+0x78>
  printf(stdout, "open test ok\n");
     389:	83 ec 08             	sub    $0x8,%esp
     38c:	68 f0 3d 00 00       	push   $0x3df0
     391:	ff 35 88 5d 00 00    	pushl  0x5d88
     397:	e8 d4 35 00 00       	call   3970 <printf>
}
     39c:	83 c4 10             	add    $0x10,%esp
     39f:	c9                   	leave  
     3a0:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     3a1:	50                   	push   %eax
     3a2:	50                   	push   %eax
     3a3:	68 b2 3d 00 00       	push   $0x3db2
     3a8:	ff 35 88 5d 00 00    	pushl  0x5d88
     3ae:	e8 bd 35 00 00       	call   3970 <printf>
    exit();
     3b3:	e8 5a 34 00 00       	call   3812 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     3b8:	50                   	push   %eax
     3b9:	50                   	push   %eax
     3ba:	68 d2 3d 00 00       	push   $0x3dd2
     3bf:	ff 35 88 5d 00 00    	pushl  0x5d88
     3c5:	e8 a6 35 00 00       	call   3970 <printf>
    exit();
     3ca:	e8 43 34 00 00       	call   3812 <exit>
     3cf:	90                   	nop

000003d0 <writetest>:
{
     3d0:	55                   	push   %ebp
     3d1:	89 e5                	mov    %esp,%ebp
     3d3:	56                   	push   %esi
     3d4:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     3d5:	83 ec 08             	sub    $0x8,%esp
     3d8:	68 fe 3d 00 00       	push   $0x3dfe
     3dd:	ff 35 88 5d 00 00    	pushl  0x5d88
     3e3:	e8 88 35 00 00       	call   3970 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     3e8:	58                   	pop    %eax
     3e9:	5a                   	pop    %edx
     3ea:	68 02 02 00 00       	push   $0x202
     3ef:	68 0f 3e 00 00       	push   $0x3e0f
     3f4:	e8 59 34 00 00       	call   3852 <open>
  if(fd >= 0){
     3f9:	83 c4 10             	add    $0x10,%esp
     3fc:	85 c0                	test   %eax,%eax
     3fe:	0f 88 88 01 00 00    	js     58c <writetest+0x1bc>
    printf(stdout, "creat small succeeded; ok\n");
     404:	83 ec 08             	sub    $0x8,%esp
     407:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     409:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     40b:	68 15 3e 00 00       	push   $0x3e15
     410:	ff 35 88 5d 00 00    	pushl  0x5d88
     416:	e8 55 35 00 00       	call   3970 <printf>
     41b:	83 c4 10             	add    $0x10,%esp
     41e:	66 90                	xchg   %ax,%ax
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     420:	83 ec 04             	sub    $0x4,%esp
     423:	6a 0a                	push   $0xa
     425:	68 4c 3e 00 00       	push   $0x3e4c
     42a:	56                   	push   %esi
     42b:	e8 02 34 00 00       	call   3832 <write>
     430:	83 c4 10             	add    $0x10,%esp
     433:	83 f8 0a             	cmp    $0xa,%eax
     436:	0f 85 d9 00 00 00    	jne    515 <writetest+0x145>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     43c:	83 ec 04             	sub    $0x4,%esp
     43f:	6a 0a                	push   $0xa
     441:	68 57 3e 00 00       	push   $0x3e57
     446:	56                   	push   %esi
     447:	e8 e6 33 00 00       	call   3832 <write>
     44c:	83 c4 10             	add    $0x10,%esp
     44f:	83 f8 0a             	cmp    $0xa,%eax
     452:	0f 85 d6 00 00 00    	jne    52e <writetest+0x15e>
  for(i = 0; i < 100; i++){
     458:	83 c3 01             	add    $0x1,%ebx
     45b:	83 fb 64             	cmp    $0x64,%ebx
     45e:	75 c0                	jne    420 <writetest+0x50>
  printf(stdout, "writes ok\n");
     460:	83 ec 08             	sub    $0x8,%esp
     463:	68 62 3e 00 00       	push   $0x3e62
     468:	ff 35 88 5d 00 00    	pushl  0x5d88
     46e:	e8 fd 34 00 00       	call   3970 <printf>
  close(fd);
     473:	89 34 24             	mov    %esi,(%esp)
     476:	e8 bf 33 00 00       	call   383a <close>
  fd = open("small", O_RDONLY);
     47b:	5b                   	pop    %ebx
     47c:	5e                   	pop    %esi
     47d:	6a 00                	push   $0x0
     47f:	68 0f 3e 00 00       	push   $0x3e0f
     484:	e8 c9 33 00 00       	call   3852 <open>
  if(fd >= 0){
     489:	83 c4 10             	add    $0x10,%esp
     48c:	85 c0                	test   %eax,%eax
  fd = open("small", O_RDONLY);
     48e:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     490:	0f 88 b1 00 00 00    	js     547 <writetest+0x177>
    printf(stdout, "open small succeeded ok\n");
     496:	83 ec 08             	sub    $0x8,%esp
     499:	68 6d 3e 00 00       	push   $0x3e6d
     49e:	ff 35 88 5d 00 00    	pushl  0x5d88
     4a4:	e8 c7 34 00 00       	call   3970 <printf>
  i = read(fd, buf, 2000);
     4a9:	83 c4 0c             	add    $0xc,%esp
     4ac:	68 d0 07 00 00       	push   $0x7d0
     4b1:	68 60 85 00 00       	push   $0x8560
     4b6:	53                   	push   %ebx
     4b7:	e8 6e 33 00 00       	call   382a <read>
  if(i == 2000){
     4bc:	83 c4 10             	add    $0x10,%esp
     4bf:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     4c4:	0f 85 94 00 00 00    	jne    55e <writetest+0x18e>
    printf(stdout, "read succeeded ok\n");
     4ca:	83 ec 08             	sub    $0x8,%esp
     4cd:	68 a1 3e 00 00       	push   $0x3ea1
     4d2:	ff 35 88 5d 00 00    	pushl  0x5d88
     4d8:	e8 93 34 00 00       	call   3970 <printf>
  close(fd);
     4dd:	89 1c 24             	mov    %ebx,(%esp)
     4e0:	e8 55 33 00 00       	call   383a <close>
  if(unlink("small") < 0){
     4e5:	c7 04 24 0f 3e 00 00 	movl   $0x3e0f,(%esp)
     4ec:	e8 71 33 00 00       	call   3862 <unlink>
     4f1:	83 c4 10             	add    $0x10,%esp
     4f4:	85 c0                	test   %eax,%eax
     4f6:	78 7d                	js     575 <writetest+0x1a5>
  printf(stdout, "small file test ok\n");
     4f8:	83 ec 08             	sub    $0x8,%esp
     4fb:	68 c9 3e 00 00       	push   $0x3ec9
     500:	ff 35 88 5d 00 00    	pushl  0x5d88
     506:	e8 65 34 00 00       	call   3970 <printf>
}
     50b:	83 c4 10             	add    $0x10,%esp
     50e:	8d 65 f8             	lea    -0x8(%ebp),%esp
     511:	5b                   	pop    %ebx
     512:	5e                   	pop    %esi
     513:	5d                   	pop    %ebp
     514:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     515:	83 ec 04             	sub    $0x4,%esp
     518:	53                   	push   %ebx
     519:	68 20 4d 00 00       	push   $0x4d20
     51e:	ff 35 88 5d 00 00    	pushl  0x5d88
     524:	e8 47 34 00 00       	call   3970 <printf>
      exit();
     529:	e8 e4 32 00 00       	call   3812 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     52e:	83 ec 04             	sub    $0x4,%esp
     531:	53                   	push   %ebx
     532:	68 44 4d 00 00       	push   $0x4d44
     537:	ff 35 88 5d 00 00    	pushl  0x5d88
     53d:	e8 2e 34 00 00       	call   3970 <printf>
      exit();
     542:	e8 cb 32 00 00       	call   3812 <exit>
    printf(stdout, "error: open small failed!\n");
     547:	51                   	push   %ecx
     548:	51                   	push   %ecx
     549:	68 86 3e 00 00       	push   $0x3e86
     54e:	ff 35 88 5d 00 00    	pushl  0x5d88
     554:	e8 17 34 00 00       	call   3970 <printf>
    exit();
     559:	e8 b4 32 00 00       	call   3812 <exit>
    printf(stdout, "read failed\n");
     55e:	52                   	push   %edx
     55f:	52                   	push   %edx
     560:	68 dd 41 00 00       	push   $0x41dd
     565:	ff 35 88 5d 00 00    	pushl  0x5d88
     56b:	e8 00 34 00 00       	call   3970 <printf>
    exit();
     570:	e8 9d 32 00 00       	call   3812 <exit>
    printf(stdout, "unlink small failed\n");
     575:	50                   	push   %eax
     576:	50                   	push   %eax
     577:	68 b4 3e 00 00       	push   $0x3eb4
     57c:	ff 35 88 5d 00 00    	pushl  0x5d88
     582:	e8 e9 33 00 00       	call   3970 <printf>
    exit();
     587:	e8 86 32 00 00       	call   3812 <exit>
    printf(stdout, "error: creat small failed!\n");
     58c:	50                   	push   %eax
     58d:	50                   	push   %eax
     58e:	68 30 3e 00 00       	push   $0x3e30
     593:	ff 35 88 5d 00 00    	pushl  0x5d88
     599:	e8 d2 33 00 00       	call   3970 <printf>
    exit();
     59e:	e8 6f 32 00 00       	call   3812 <exit>
     5a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     5a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000005b0 <writetest1>:
{
     5b0:	55                   	push   %ebp
     5b1:	89 e5                	mov    %esp,%ebp
     5b3:	56                   	push   %esi
     5b4:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     5b5:	83 ec 08             	sub    $0x8,%esp
     5b8:	68 dd 3e 00 00       	push   $0x3edd
     5bd:	ff 35 88 5d 00 00    	pushl  0x5d88
     5c3:	e8 a8 33 00 00       	call   3970 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     5c8:	58                   	pop    %eax
     5c9:	5a                   	pop    %edx
     5ca:	68 02 02 00 00       	push   $0x202
     5cf:	68 57 3f 00 00       	push   $0x3f57
     5d4:	e8 79 32 00 00       	call   3852 <open>
  if(fd < 0){
     5d9:	83 c4 10             	add    $0x10,%esp
     5dc:	85 c0                	test   %eax,%eax
     5de:	0f 88 61 01 00 00    	js     745 <writetest1+0x195>
     5e4:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     5e6:	31 db                	xor    %ebx,%ebx
     5e8:	90                   	nop
     5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     5f0:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     5f3:	89 1d 60 85 00 00    	mov    %ebx,0x8560
    if(write(fd, buf, 512) != 512){
     5f9:	68 00 02 00 00       	push   $0x200
     5fe:	68 60 85 00 00       	push   $0x8560
     603:	56                   	push   %esi
     604:	e8 29 32 00 00       	call   3832 <write>
     609:	83 c4 10             	add    $0x10,%esp
     60c:	3d 00 02 00 00       	cmp    $0x200,%eax
     611:	0f 85 b3 00 00 00    	jne    6ca <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     617:	83 c3 01             	add    $0x1,%ebx
     61a:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     620:	75 ce                	jne    5f0 <writetest1+0x40>
  close(fd);
     622:	83 ec 0c             	sub    $0xc,%esp
     625:	56                   	push   %esi
     626:	e8 0f 32 00 00       	call   383a <close>
  fd = open("big", O_RDONLY);
     62b:	5b                   	pop    %ebx
     62c:	5e                   	pop    %esi
     62d:	6a 00                	push   $0x0
     62f:	68 57 3f 00 00       	push   $0x3f57
     634:	e8 19 32 00 00       	call   3852 <open>
  if(fd < 0){
     639:	83 c4 10             	add    $0x10,%esp
     63c:	85 c0                	test   %eax,%eax
  fd = open("big", O_RDONLY);
     63e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     640:	0f 88 e8 00 00 00    	js     72e <writetest1+0x17e>
  n = 0;
     646:	31 db                	xor    %ebx,%ebx
     648:	eb 1d                	jmp    667 <writetest1+0xb7>
     64a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     650:	3d 00 02 00 00       	cmp    $0x200,%eax
     655:	0f 85 9f 00 00 00    	jne    6fa <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     65b:	a1 60 85 00 00       	mov    0x8560,%eax
     660:	39 d8                	cmp    %ebx,%eax
     662:	75 7f                	jne    6e3 <writetest1+0x133>
    n++;
     664:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     667:	83 ec 04             	sub    $0x4,%esp
     66a:	68 00 02 00 00       	push   $0x200
     66f:	68 60 85 00 00       	push   $0x8560
     674:	56                   	push   %esi
     675:	e8 b0 31 00 00       	call   382a <read>
    if(i == 0){
     67a:	83 c4 10             	add    $0x10,%esp
     67d:	85 c0                	test   %eax,%eax
     67f:	75 cf                	jne    650 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     681:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     687:	0f 84 86 00 00 00    	je     713 <writetest1+0x163>
  close(fd);
     68d:	83 ec 0c             	sub    $0xc,%esp
     690:	56                   	push   %esi
     691:	e8 a4 31 00 00       	call   383a <close>
  if(unlink("big") < 0){
     696:	c7 04 24 57 3f 00 00 	movl   $0x3f57,(%esp)
     69d:	e8 c0 31 00 00       	call   3862 <unlink>
     6a2:	83 c4 10             	add    $0x10,%esp
     6a5:	85 c0                	test   %eax,%eax
     6a7:	0f 88 af 00 00 00    	js     75c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     6ad:	83 ec 08             	sub    $0x8,%esp
     6b0:	68 7e 3f 00 00       	push   $0x3f7e
     6b5:	ff 35 88 5d 00 00    	pushl  0x5d88
     6bb:	e8 b0 32 00 00       	call   3970 <printf>
}
     6c0:	83 c4 10             	add    $0x10,%esp
     6c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     6c6:	5b                   	pop    %ebx
     6c7:	5e                   	pop    %esi
     6c8:	5d                   	pop    %ebp
     6c9:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     6ca:	83 ec 04             	sub    $0x4,%esp
     6cd:	53                   	push   %ebx
     6ce:	68 07 3f 00 00       	push   $0x3f07
     6d3:	ff 35 88 5d 00 00    	pushl  0x5d88
     6d9:	e8 92 32 00 00       	call   3970 <printf>
      exit();
     6de:	e8 2f 31 00 00       	call   3812 <exit>
      printf(stdout, "read content of block %d is %d\n",
     6e3:	50                   	push   %eax
     6e4:	53                   	push   %ebx
     6e5:	68 68 4d 00 00       	push   $0x4d68
     6ea:	ff 35 88 5d 00 00    	pushl  0x5d88
     6f0:	e8 7b 32 00 00       	call   3970 <printf>
      exit();
     6f5:	e8 18 31 00 00       	call   3812 <exit>
      printf(stdout, "read failed %d\n", i);
     6fa:	83 ec 04             	sub    $0x4,%esp
     6fd:	50                   	push   %eax
     6fe:	68 5b 3f 00 00       	push   $0x3f5b
     703:	ff 35 88 5d 00 00    	pushl  0x5d88
     709:	e8 62 32 00 00       	call   3970 <printf>
      exit();
     70e:	e8 ff 30 00 00       	call   3812 <exit>
        printf(stdout, "read only %d blocks from big", n);
     713:	52                   	push   %edx
     714:	68 8b 00 00 00       	push   $0x8b
     719:	68 3e 3f 00 00       	push   $0x3f3e
     71e:	ff 35 88 5d 00 00    	pushl  0x5d88
     724:	e8 47 32 00 00       	call   3970 <printf>
        exit();
     729:	e8 e4 30 00 00       	call   3812 <exit>
    printf(stdout, "error: open big failed!\n");
     72e:	51                   	push   %ecx
     72f:	51                   	push   %ecx
     730:	68 25 3f 00 00       	push   $0x3f25
     735:	ff 35 88 5d 00 00    	pushl  0x5d88
     73b:	e8 30 32 00 00       	call   3970 <printf>
    exit();
     740:	e8 cd 30 00 00       	call   3812 <exit>
    printf(stdout, "error: creat big failed!\n");
     745:	50                   	push   %eax
     746:	50                   	push   %eax
     747:	68 ed 3e 00 00       	push   $0x3eed
     74c:	ff 35 88 5d 00 00    	pushl  0x5d88
     752:	e8 19 32 00 00       	call   3970 <printf>
    exit();
     757:	e8 b6 30 00 00       	call   3812 <exit>
    printf(stdout, "unlink big failed\n");
     75c:	50                   	push   %eax
     75d:	50                   	push   %eax
     75e:	68 6b 3f 00 00       	push   $0x3f6b
     763:	ff 35 88 5d 00 00    	pushl  0x5d88
     769:	e8 02 32 00 00       	call   3970 <printf>
    exit();
     76e:	e8 9f 30 00 00       	call   3812 <exit>
     773:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000780 <createtest>:
{
     780:	55                   	push   %ebp
     781:	89 e5                	mov    %esp,%ebp
     783:	53                   	push   %ebx
  name[2] = '\0';
     784:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     789:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     78c:	68 88 4d 00 00       	push   $0x4d88
     791:	ff 35 88 5d 00 00    	pushl  0x5d88
     797:	e8 d4 31 00 00       	call   3970 <printf>
  name[0] = 'a';
     79c:	c6 05 60 a5 00 00 61 	movb   $0x61,0xa560
  name[2] = '\0';
     7a3:	c6 05 62 a5 00 00 00 	movb   $0x0,0xa562
     7aa:	83 c4 10             	add    $0x10,%esp
     7ad:	8d 76 00             	lea    0x0(%esi),%esi
    fd = open(name, O_CREATE|O_RDWR);
     7b0:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     7b3:	88 1d 61 a5 00 00    	mov    %bl,0xa561
     7b9:	83 c3 01             	add    $0x1,%ebx
    fd = open(name, O_CREATE|O_RDWR);
     7bc:	68 02 02 00 00       	push   $0x202
     7c1:	68 60 a5 00 00       	push   $0xa560
     7c6:	e8 87 30 00 00       	call   3852 <open>
    close(fd);
     7cb:	89 04 24             	mov    %eax,(%esp)
     7ce:	e8 67 30 00 00       	call   383a <close>
  for(i = 0; i < 52; i++){
     7d3:	83 c4 10             	add    $0x10,%esp
     7d6:	80 fb 64             	cmp    $0x64,%bl
     7d9:	75 d5                	jne    7b0 <createtest+0x30>
  name[0] = 'a';
     7db:	c6 05 60 a5 00 00 61 	movb   $0x61,0xa560
  name[2] = '\0';
     7e2:	c6 05 62 a5 00 00 00 	movb   $0x0,0xa562
     7e9:	bb 30 00 00 00       	mov    $0x30,%ebx
     7ee:	66 90                	xchg   %ax,%ax
    unlink(name);
     7f0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     7f3:	88 1d 61 a5 00 00    	mov    %bl,0xa561
     7f9:	83 c3 01             	add    $0x1,%ebx
    unlink(name);
     7fc:	68 60 a5 00 00       	push   $0xa560
     801:	e8 5c 30 00 00       	call   3862 <unlink>
  for(i = 0; i < 52; i++){
     806:	83 c4 10             	add    $0x10,%esp
     809:	80 fb 64             	cmp    $0x64,%bl
     80c:	75 e2                	jne    7f0 <createtest+0x70>
  printf(stdout, "many creates, followed by unlink; ok\n");
     80e:	83 ec 08             	sub    $0x8,%esp
     811:	68 b0 4d 00 00       	push   $0x4db0
     816:	ff 35 88 5d 00 00    	pushl  0x5d88
     81c:	e8 4f 31 00 00       	call   3970 <printf>
}
     821:	83 c4 10             	add    $0x10,%esp
     824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     827:	c9                   	leave  
     828:	c3                   	ret    
     829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000830 <dirtest>:
{
     830:	55                   	push   %ebp
     831:	89 e5                	mov    %esp,%ebp
     833:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     836:	68 8c 3f 00 00       	push   $0x3f8c
     83b:	ff 35 88 5d 00 00    	pushl  0x5d88
     841:	e8 2a 31 00 00       	call   3970 <printf>
  if(mkdir("dir0") < 0){
     846:	c7 04 24 98 3f 00 00 	movl   $0x3f98,(%esp)
     84d:	e8 28 30 00 00       	call   387a <mkdir>
     852:	83 c4 10             	add    $0x10,%esp
     855:	85 c0                	test   %eax,%eax
     857:	78 58                	js     8b1 <dirtest+0x81>
  if(chdir("dir0") < 0){
     859:	83 ec 0c             	sub    $0xc,%esp
     85c:	68 98 3f 00 00       	push   $0x3f98
     861:	e8 1c 30 00 00       	call   3882 <chdir>
     866:	83 c4 10             	add    $0x10,%esp
     869:	85 c0                	test   %eax,%eax
     86b:	0f 88 85 00 00 00    	js     8f6 <dirtest+0xc6>
  if(chdir("..") < 0){
     871:	83 ec 0c             	sub    $0xc,%esp
     874:	68 4d 45 00 00       	push   $0x454d
     879:	e8 04 30 00 00       	call   3882 <chdir>
     87e:	83 c4 10             	add    $0x10,%esp
     881:	85 c0                	test   %eax,%eax
     883:	78 5a                	js     8df <dirtest+0xaf>
  if(unlink("dir0") < 0){
     885:	83 ec 0c             	sub    $0xc,%esp
     888:	68 98 3f 00 00       	push   $0x3f98
     88d:	e8 d0 2f 00 00       	call   3862 <unlink>
     892:	83 c4 10             	add    $0x10,%esp
     895:	85 c0                	test   %eax,%eax
     897:	78 2f                	js     8c8 <dirtest+0x98>
  printf(stdout, "mkdir test ok\n");
     899:	83 ec 08             	sub    $0x8,%esp
     89c:	68 d5 3f 00 00       	push   $0x3fd5
     8a1:	ff 35 88 5d 00 00    	pushl  0x5d88
     8a7:	e8 c4 30 00 00       	call   3970 <printf>
}
     8ac:	83 c4 10             	add    $0x10,%esp
     8af:	c9                   	leave  
     8b0:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     8b1:	50                   	push   %eax
     8b2:	50                   	push   %eax
     8b3:	68 c8 3c 00 00       	push   $0x3cc8
     8b8:	ff 35 88 5d 00 00    	pushl  0x5d88
     8be:	e8 ad 30 00 00       	call   3970 <printf>
    exit();
     8c3:	e8 4a 2f 00 00       	call   3812 <exit>
    printf(stdout, "unlink dir0 failed\n");
     8c8:	50                   	push   %eax
     8c9:	50                   	push   %eax
     8ca:	68 c1 3f 00 00       	push   $0x3fc1
     8cf:	ff 35 88 5d 00 00    	pushl  0x5d88
     8d5:	e8 96 30 00 00       	call   3970 <printf>
    exit();
     8da:	e8 33 2f 00 00       	call   3812 <exit>
    printf(stdout, "chdir .. failed\n");
     8df:	52                   	push   %edx
     8e0:	52                   	push   %edx
     8e1:	68 b0 3f 00 00       	push   $0x3fb0
     8e6:	ff 35 88 5d 00 00    	pushl  0x5d88
     8ec:	e8 7f 30 00 00       	call   3970 <printf>
    exit();
     8f1:	e8 1c 2f 00 00       	call   3812 <exit>
    printf(stdout, "chdir dir0 failed\n");
     8f6:	51                   	push   %ecx
     8f7:	51                   	push   %ecx
     8f8:	68 9d 3f 00 00       	push   $0x3f9d
     8fd:	ff 35 88 5d 00 00    	pushl  0x5d88
     903:	e8 68 30 00 00       	call   3970 <printf>
    exit();
     908:	e8 05 2f 00 00       	call   3812 <exit>
     90d:	8d 76 00             	lea    0x0(%esi),%esi

00000910 <exectest>:
{
     910:	55                   	push   %ebp
     911:	89 e5                	mov    %esp,%ebp
     913:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     916:	68 e4 3f 00 00       	push   $0x3fe4
     91b:	ff 35 88 5d 00 00    	pushl  0x5d88
     921:	e8 4a 30 00 00       	call   3970 <printf>
  if(exec("echo", echoargv) < 0){
     926:	5a                   	pop    %edx
     927:	59                   	pop    %ecx
     928:	68 8c 5d 00 00       	push   $0x5d8c
     92d:	68 ad 3d 00 00       	push   $0x3dad
     932:	e8 13 2f 00 00       	call   384a <exec>
     937:	83 c4 10             	add    $0x10,%esp
     93a:	85 c0                	test   %eax,%eax
     93c:	78 02                	js     940 <exectest+0x30>
}
     93e:	c9                   	leave  
     93f:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     940:	50                   	push   %eax
     941:	50                   	push   %eax
     942:	68 ef 3f 00 00       	push   $0x3fef
     947:	ff 35 88 5d 00 00    	pushl  0x5d88
     94d:	e8 1e 30 00 00       	call   3970 <printf>
    exit();
     952:	e8 bb 2e 00 00       	call   3812 <exit>
     957:	89 f6                	mov    %esi,%esi
     959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000960 <pipe1>:
{
     960:	55                   	push   %ebp
     961:	89 e5                	mov    %esp,%ebp
     963:	57                   	push   %edi
     964:	56                   	push   %esi
     965:	53                   	push   %ebx
  if(pipe(fds) != 0){
     966:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     969:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     96c:	50                   	push   %eax
     96d:	e8 b0 2e 00 00       	call   3822 <pipe>
     972:	83 c4 10             	add    $0x10,%esp
     975:	85 c0                	test   %eax,%eax
     977:	0f 85 3e 01 00 00    	jne    abb <pipe1+0x15b>
     97d:	89 c3                	mov    %eax,%ebx
  pid = fork();
     97f:	e8 86 2e 00 00       	call   380a <fork>
  if(pid == 0){
     984:	83 f8 00             	cmp    $0x0,%eax
     987:	0f 84 84 00 00 00    	je     a11 <pipe1+0xb1>
  } else if(pid > 0){
     98d:	0f 8e 3b 01 00 00    	jle    ace <pipe1+0x16e>
    close(fds[1]);
     993:	83 ec 0c             	sub    $0xc,%esp
     996:	ff 75 e4             	pushl  -0x1c(%ebp)
    cc = 1;
     999:	bf 01 00 00 00       	mov    $0x1,%edi
    close(fds[1]);
     99e:	e8 97 2e 00 00       	call   383a <close>
    while((n = read(fds[0], buf, cc)) > 0){
     9a3:	83 c4 10             	add    $0x10,%esp
    total = 0;
     9a6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     9ad:	83 ec 04             	sub    $0x4,%esp
     9b0:	57                   	push   %edi
     9b1:	68 60 85 00 00       	push   $0x8560
     9b6:	ff 75 e0             	pushl  -0x20(%ebp)
     9b9:	e8 6c 2e 00 00       	call   382a <read>
     9be:	83 c4 10             	add    $0x10,%esp
     9c1:	85 c0                	test   %eax,%eax
     9c3:	0f 8e ab 00 00 00    	jle    a74 <pipe1+0x114>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     9c9:	89 d9                	mov    %ebx,%ecx
     9cb:	8d 34 18             	lea    (%eax,%ebx,1),%esi
     9ce:	f7 d9                	neg    %ecx
     9d0:	38 9c 0b 60 85 00 00 	cmp    %bl,0x8560(%ebx,%ecx,1)
     9d7:	8d 53 01             	lea    0x1(%ebx),%edx
     9da:	75 1b                	jne    9f7 <pipe1+0x97>
      for(i = 0; i < n; i++){
     9dc:	39 f2                	cmp    %esi,%edx
     9de:	89 d3                	mov    %edx,%ebx
     9e0:	75 ee                	jne    9d0 <pipe1+0x70>
      cc = cc * 2;
     9e2:	01 ff                	add    %edi,%edi
      total += n;
     9e4:	01 45 d4             	add    %eax,-0x2c(%ebp)
     9e7:	b8 00 20 00 00       	mov    $0x2000,%eax
     9ec:	81 ff 00 20 00 00    	cmp    $0x2000,%edi
     9f2:	0f 4f f8             	cmovg  %eax,%edi
     9f5:	eb b6                	jmp    9ad <pipe1+0x4d>
          printf(1, "pipe1 oops 2\n");
     9f7:	83 ec 08             	sub    $0x8,%esp
     9fa:	68 1e 40 00 00       	push   $0x401e
     9ff:	6a 01                	push   $0x1
     a01:	e8 6a 2f 00 00       	call   3970 <printf>
          return;
     a06:	83 c4 10             	add    $0x10,%esp
}
     a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a0c:	5b                   	pop    %ebx
     a0d:	5e                   	pop    %esi
     a0e:	5f                   	pop    %edi
     a0f:	5d                   	pop    %ebp
     a10:	c3                   	ret    
    close(fds[0]);
     a11:	83 ec 0c             	sub    $0xc,%esp
     a14:	ff 75 e0             	pushl  -0x20(%ebp)
     a17:	31 db                	xor    %ebx,%ebx
     a19:	be 09 04 00 00       	mov    $0x409,%esi
     a1e:	e8 17 2e 00 00       	call   383a <close>
     a23:	83 c4 10             	add    $0x10,%esp
     a26:	89 d8                	mov    %ebx,%eax
     a28:	89 f2                	mov    %esi,%edx
     a2a:	f7 d8                	neg    %eax
     a2c:	29 da                	sub    %ebx,%edx
     a2e:	66 90                	xchg   %ax,%ax
        buf[i] = seq++;
     a30:	88 84 03 60 85 00 00 	mov    %al,0x8560(%ebx,%eax,1)
     a37:	83 c0 01             	add    $0x1,%eax
      for(i = 0; i < 1033; i++)
     a3a:	39 d0                	cmp    %edx,%eax
     a3c:	75 f2                	jne    a30 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     a3e:	83 ec 04             	sub    $0x4,%esp
     a41:	68 09 04 00 00       	push   $0x409
     a46:	68 60 85 00 00       	push   $0x8560
     a4b:	ff 75 e4             	pushl  -0x1c(%ebp)
     a4e:	e8 df 2d 00 00       	call   3832 <write>
     a53:	83 c4 10             	add    $0x10,%esp
     a56:	3d 09 04 00 00       	cmp    $0x409,%eax
     a5b:	0f 85 80 00 00 00    	jne    ae1 <pipe1+0x181>
     a61:	81 eb 09 04 00 00    	sub    $0x409,%ebx
    for(n = 0; n < 5; n++){
     a67:	81 fb d3 eb ff ff    	cmp    $0xffffebd3,%ebx
     a6d:	75 b7                	jne    a26 <pipe1+0xc6>
    exit();
     a6f:	e8 9e 2d 00 00       	call   3812 <exit>
    if(total != 5 * 1033){
     a74:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     a7b:	75 29                	jne    aa6 <pipe1+0x146>
    close(fds[0]);
     a7d:	83 ec 0c             	sub    $0xc,%esp
     a80:	ff 75 e0             	pushl  -0x20(%ebp)
     a83:	e8 b2 2d 00 00       	call   383a <close>
    wait();
     a88:	e8 8d 2d 00 00       	call   381a <wait>
  printf(1, "pipe1 ok\n");
     a8d:	5a                   	pop    %edx
     a8e:	59                   	pop    %ecx
     a8f:	68 43 40 00 00       	push   $0x4043
     a94:	6a 01                	push   $0x1
     a96:	e8 d5 2e 00 00       	call   3970 <printf>
     a9b:	83 c4 10             	add    $0x10,%esp
}
     a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     aa1:	5b                   	pop    %ebx
     aa2:	5e                   	pop    %esi
     aa3:	5f                   	pop    %edi
     aa4:	5d                   	pop    %ebp
     aa5:	c3                   	ret    
      printf(1, "pipe1 oops 3 total %d\n", total);
     aa6:	53                   	push   %ebx
     aa7:	ff 75 d4             	pushl  -0x2c(%ebp)
     aaa:	68 2c 40 00 00       	push   $0x402c
     aaf:	6a 01                	push   $0x1
     ab1:	e8 ba 2e 00 00       	call   3970 <printf>
      exit();
     ab6:	e8 57 2d 00 00       	call   3812 <exit>
    printf(1, "pipe() failed\n");
     abb:	57                   	push   %edi
     abc:	57                   	push   %edi
     abd:	68 01 40 00 00       	push   $0x4001
     ac2:	6a 01                	push   $0x1
     ac4:	e8 a7 2e 00 00       	call   3970 <printf>
    exit();
     ac9:	e8 44 2d 00 00       	call   3812 <exit>
    printf(1, "fork() failed\n");
     ace:	50                   	push   %eax
     acf:	50                   	push   %eax
     ad0:	68 4d 40 00 00       	push   $0x404d
     ad5:	6a 01                	push   $0x1
     ad7:	e8 94 2e 00 00       	call   3970 <printf>
    exit();
     adc:	e8 31 2d 00 00       	call   3812 <exit>
        printf(1, "pipe1 oops 1\n");
     ae1:	56                   	push   %esi
     ae2:	56                   	push   %esi
     ae3:	68 10 40 00 00       	push   $0x4010
     ae8:	6a 01                	push   $0x1
     aea:	e8 81 2e 00 00       	call   3970 <printf>
        exit();
     aef:	e8 1e 2d 00 00       	call   3812 <exit>
     af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000b00 <preempt>:
{
     b00:	55                   	push   %ebp
     b01:	89 e5                	mov    %esp,%ebp
     b03:	57                   	push   %edi
     b04:	56                   	push   %esi
     b05:	53                   	push   %ebx
     b06:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     b09:	68 5c 40 00 00       	push   $0x405c
     b0e:	6a 01                	push   $0x1
     b10:	e8 5b 2e 00 00       	call   3970 <printf>
  pid1 = fork();
     b15:	e8 f0 2c 00 00       	call   380a <fork>
  if(pid1 == 0)
     b1a:	83 c4 10             	add    $0x10,%esp
     b1d:	85 c0                	test   %eax,%eax
     b1f:	75 02                	jne    b23 <preempt+0x23>
     b21:	eb fe                	jmp    b21 <preempt+0x21>
     b23:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     b25:	e8 e0 2c 00 00       	call   380a <fork>
  if(pid2 == 0)
     b2a:	85 c0                	test   %eax,%eax
  pid2 = fork();
     b2c:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     b2e:	75 02                	jne    b32 <preempt+0x32>
     b30:	eb fe                	jmp    b30 <preempt+0x30>
  pipe(pfds);
     b32:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b35:	83 ec 0c             	sub    $0xc,%esp
     b38:	50                   	push   %eax
     b39:	e8 e4 2c 00 00       	call   3822 <pipe>
  pid3 = fork();
     b3e:	e8 c7 2c 00 00       	call   380a <fork>
  if(pid3 == 0){
     b43:	83 c4 10             	add    $0x10,%esp
     b46:	85 c0                	test   %eax,%eax
  pid3 = fork();
     b48:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     b4a:	75 46                	jne    b92 <preempt+0x92>
    close(pfds[0]);
     b4c:	83 ec 0c             	sub    $0xc,%esp
     b4f:	ff 75 e0             	pushl  -0x20(%ebp)
     b52:	e8 e3 2c 00 00       	call   383a <close>
    if(write(pfds[1], "x", 1) != 1)
     b57:	83 c4 0c             	add    $0xc,%esp
     b5a:	6a 01                	push   $0x1
     b5c:	68 31 46 00 00       	push   $0x4631
     b61:	ff 75 e4             	pushl  -0x1c(%ebp)
     b64:	e8 c9 2c 00 00       	call   3832 <write>
     b69:	83 c4 10             	add    $0x10,%esp
     b6c:	83 e8 01             	sub    $0x1,%eax
     b6f:	74 11                	je     b82 <preempt+0x82>
      printf(1, "preempt write error");
     b71:	50                   	push   %eax
     b72:	50                   	push   %eax
     b73:	68 66 40 00 00       	push   $0x4066
     b78:	6a 01                	push   $0x1
     b7a:	e8 f1 2d 00 00       	call   3970 <printf>
     b7f:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     b82:	83 ec 0c             	sub    $0xc,%esp
     b85:	ff 75 e4             	pushl  -0x1c(%ebp)
     b88:	e8 ad 2c 00 00       	call   383a <close>
     b8d:	83 c4 10             	add    $0x10,%esp
     b90:	eb fe                	jmp    b90 <preempt+0x90>
  close(pfds[1]);
     b92:	83 ec 0c             	sub    $0xc,%esp
     b95:	ff 75 e4             	pushl  -0x1c(%ebp)
     b98:	e8 9d 2c 00 00       	call   383a <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     b9d:	83 c4 0c             	add    $0xc,%esp
     ba0:	68 00 20 00 00       	push   $0x2000
     ba5:	68 60 85 00 00       	push   $0x8560
     baa:	ff 75 e0             	pushl  -0x20(%ebp)
     bad:	e8 78 2c 00 00       	call   382a <read>
     bb2:	83 c4 10             	add    $0x10,%esp
     bb5:	83 e8 01             	sub    $0x1,%eax
     bb8:	74 19                	je     bd3 <preempt+0xd3>
    printf(1, "preempt read error");
     bba:	50                   	push   %eax
     bbb:	50                   	push   %eax
     bbc:	68 7a 40 00 00       	push   $0x407a
     bc1:	6a 01                	push   $0x1
     bc3:	e8 a8 2d 00 00       	call   3970 <printf>
    return;
     bc8:	83 c4 10             	add    $0x10,%esp
}
     bcb:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bce:	5b                   	pop    %ebx
     bcf:	5e                   	pop    %esi
     bd0:	5f                   	pop    %edi
     bd1:	5d                   	pop    %ebp
     bd2:	c3                   	ret    
  close(pfds[0]);
     bd3:	83 ec 0c             	sub    $0xc,%esp
     bd6:	ff 75 e0             	pushl  -0x20(%ebp)
     bd9:	e8 5c 2c 00 00       	call   383a <close>
  printf(1, "kill... ");
     bde:	58                   	pop    %eax
     bdf:	5a                   	pop    %edx
     be0:	68 8d 40 00 00       	push   $0x408d
     be5:	6a 01                	push   $0x1
     be7:	e8 84 2d 00 00       	call   3970 <printf>
  kill(pid1);
     bec:	89 3c 24             	mov    %edi,(%esp)
     bef:	e8 4e 2c 00 00       	call   3842 <kill>
  kill(pid2);
     bf4:	89 34 24             	mov    %esi,(%esp)
     bf7:	e8 46 2c 00 00       	call   3842 <kill>
  kill(pid3);
     bfc:	89 1c 24             	mov    %ebx,(%esp)
     bff:	e8 3e 2c 00 00       	call   3842 <kill>
  printf(1, "wait... ");
     c04:	59                   	pop    %ecx
     c05:	5b                   	pop    %ebx
     c06:	68 96 40 00 00       	push   $0x4096
     c0b:	6a 01                	push   $0x1
     c0d:	e8 5e 2d 00 00       	call   3970 <printf>
  wait();
     c12:	e8 03 2c 00 00       	call   381a <wait>
  wait();
     c17:	e8 fe 2b 00 00       	call   381a <wait>
  wait();
     c1c:	e8 f9 2b 00 00       	call   381a <wait>
  printf(1, "preempt ok\n");
     c21:	5e                   	pop    %esi
     c22:	5f                   	pop    %edi
     c23:	68 9f 40 00 00       	push   $0x409f
     c28:	6a 01                	push   $0x1
     c2a:	e8 41 2d 00 00       	call   3970 <printf>
     c2f:	83 c4 10             	add    $0x10,%esp
     c32:	eb 97                	jmp    bcb <preempt+0xcb>
     c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000c40 <exitwait>:
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	56                   	push   %esi
     c44:	be 64 00 00 00       	mov    $0x64,%esi
     c49:	53                   	push   %ebx
     c4a:	eb 14                	jmp    c60 <exitwait+0x20>
     c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid){
     c50:	74 6f                	je     cc1 <exitwait+0x81>
      if(wait() != pid){
     c52:	e8 c3 2b 00 00       	call   381a <wait>
     c57:	39 d8                	cmp    %ebx,%eax
     c59:	75 2d                	jne    c88 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     c5b:	83 ee 01             	sub    $0x1,%esi
     c5e:	74 48                	je     ca8 <exitwait+0x68>
    pid = fork();
     c60:	e8 a5 2b 00 00       	call   380a <fork>
    if(pid < 0){
     c65:	85 c0                	test   %eax,%eax
    pid = fork();
     c67:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     c69:	79 e5                	jns    c50 <exitwait+0x10>
      printf(1, "fork failed\n");
     c6b:	83 ec 08             	sub    $0x8,%esp
     c6e:	68 19 4c 00 00       	push   $0x4c19
     c73:	6a 01                	push   $0x1
     c75:	e8 f6 2c 00 00       	call   3970 <printf>
      return;
     c7a:	83 c4 10             	add    $0x10,%esp
}
     c7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c80:	5b                   	pop    %ebx
     c81:	5e                   	pop    %esi
     c82:	5d                   	pop    %ebp
     c83:	c3                   	ret    
     c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     c88:	83 ec 08             	sub    $0x8,%esp
     c8b:	68 ab 40 00 00       	push   $0x40ab
     c90:	6a 01                	push   $0x1
     c92:	e8 d9 2c 00 00       	call   3970 <printf>
        return;
     c97:	83 c4 10             	add    $0x10,%esp
}
     c9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     c9d:	5b                   	pop    %ebx
     c9e:	5e                   	pop    %esi
     c9f:	5d                   	pop    %ebp
     ca0:	c3                   	ret    
     ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  printf(1, "exitwait ok\n");
     ca8:	83 ec 08             	sub    $0x8,%esp
     cab:	68 bb 40 00 00       	push   $0x40bb
     cb0:	6a 01                	push   $0x1
     cb2:	e8 b9 2c 00 00       	call   3970 <printf>
     cb7:	83 c4 10             	add    $0x10,%esp
}
     cba:	8d 65 f8             	lea    -0x8(%ebp),%esp
     cbd:	5b                   	pop    %ebx
     cbe:	5e                   	pop    %esi
     cbf:	5d                   	pop    %ebp
     cc0:	c3                   	ret    
      exit();
     cc1:	e8 4c 2b 00 00       	call   3812 <exit>
     cc6:	8d 76 00             	lea    0x0(%esi),%esi
     cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000cd0 <mem>:
{
     cd0:	55                   	push   %ebp
     cd1:	89 e5                	mov    %esp,%ebp
     cd3:	57                   	push   %edi
     cd4:	56                   	push   %esi
     cd5:	53                   	push   %ebx
     cd6:	31 db                	xor    %ebx,%ebx
     cd8:	83 ec 14             	sub    $0x14,%esp
  printf(1, "mem test\n");
     cdb:	68 c8 40 00 00       	push   $0x40c8
     ce0:	6a 01                	push   $0x1
     ce2:	e8 89 2c 00 00       	call   3970 <printf>
  ppid = getpid();
     ce7:	e8 a6 2b 00 00       	call   3892 <getpid>
     cec:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     cee:	e8 17 2b 00 00       	call   380a <fork>
     cf3:	83 c4 10             	add    $0x10,%esp
     cf6:	85 c0                	test   %eax,%eax
     cf8:	74 0a                	je     d04 <mem+0x34>
     cfa:	e9 89 00 00 00       	jmp    d88 <mem+0xb8>
     cff:	90                   	nop
      *(char**)m2 = m1;
     d00:	89 18                	mov    %ebx,(%eax)
     d02:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     d04:	83 ec 0c             	sub    $0xc,%esp
     d07:	68 11 27 00 00       	push   $0x2711
     d0c:	e8 bf 2e 00 00       	call   3bd0 <malloc>
     d11:	83 c4 10             	add    $0x10,%esp
     d14:	85 c0                	test   %eax,%eax
     d16:	75 e8                	jne    d00 <mem+0x30>
    while(m1){
     d18:	85 db                	test   %ebx,%ebx
     d1a:	74 18                	je     d34 <mem+0x64>
     d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     d20:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     d22:	83 ec 0c             	sub    $0xc,%esp
     d25:	53                   	push   %ebx
     d26:	89 fb                	mov    %edi,%ebx
     d28:	e8 13 2e 00 00       	call   3b40 <free>
    while(m1){
     d2d:	83 c4 10             	add    $0x10,%esp
     d30:	85 db                	test   %ebx,%ebx
     d32:	75 ec                	jne    d20 <mem+0x50>
    m1 = malloc(1024*20);
     d34:	83 ec 0c             	sub    $0xc,%esp
     d37:	68 00 50 00 00       	push   $0x5000
     d3c:	e8 8f 2e 00 00       	call   3bd0 <malloc>
    if(m1 == 0){
     d41:	83 c4 10             	add    $0x10,%esp
     d44:	85 c0                	test   %eax,%eax
     d46:	74 20                	je     d68 <mem+0x98>
    free(m1);
     d48:	83 ec 0c             	sub    $0xc,%esp
     d4b:	50                   	push   %eax
     d4c:	e8 ef 2d 00 00       	call   3b40 <free>
    printf(1, "mem ok\n");
     d51:	58                   	pop    %eax
     d52:	5a                   	pop    %edx
     d53:	68 ec 40 00 00       	push   $0x40ec
     d58:	6a 01                	push   $0x1
     d5a:	e8 11 2c 00 00       	call   3970 <printf>
    exit();
     d5f:	e8 ae 2a 00 00       	call   3812 <exit>
     d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     d68:	83 ec 08             	sub    $0x8,%esp
     d6b:	68 d2 40 00 00       	push   $0x40d2
     d70:	6a 01                	push   $0x1
     d72:	e8 f9 2b 00 00       	call   3970 <printf>
      kill(ppid);
     d77:	89 34 24             	mov    %esi,(%esp)
     d7a:	e8 c3 2a 00 00       	call   3842 <kill>
      exit();
     d7f:	e8 8e 2a 00 00       	call   3812 <exit>
     d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
     d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d8b:	5b                   	pop    %ebx
     d8c:	5e                   	pop    %esi
     d8d:	5f                   	pop    %edi
     d8e:	5d                   	pop    %ebp
    wait();
     d8f:	e9 86 2a 00 00       	jmp    381a <wait>
     d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000da0 <sharedfd>:
{
     da0:	55                   	push   %ebp
     da1:	89 e5                	mov    %esp,%ebp
     da3:	57                   	push   %edi
     da4:	56                   	push   %esi
     da5:	53                   	push   %ebx
     da6:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     da9:	68 f4 40 00 00       	push   $0x40f4
     dae:	6a 01                	push   $0x1
     db0:	e8 bb 2b 00 00       	call   3970 <printf>
  unlink("sharedfd");
     db5:	c7 04 24 03 41 00 00 	movl   $0x4103,(%esp)
     dbc:	e8 a1 2a 00 00       	call   3862 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     dc1:	59                   	pop    %ecx
     dc2:	5b                   	pop    %ebx
     dc3:	68 02 02 00 00       	push   $0x202
     dc8:	68 03 41 00 00       	push   $0x4103
     dcd:	e8 80 2a 00 00       	call   3852 <open>
  if(fd < 0){
     dd2:	83 c4 10             	add    $0x10,%esp
     dd5:	85 c0                	test   %eax,%eax
     dd7:	0f 88 33 01 00 00    	js     f10 <sharedfd+0x170>
     ddd:	89 c6                	mov    %eax,%esi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ddf:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     de4:	e8 21 2a 00 00       	call   380a <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     de9:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     dec:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     dee:	19 c0                	sbb    %eax,%eax
     df0:	83 ec 04             	sub    $0x4,%esp
     df3:	83 e0 f3             	and    $0xfffffff3,%eax
     df6:	6a 0a                	push   $0xa
     df8:	83 c0 70             	add    $0x70,%eax
     dfb:	50                   	push   %eax
     dfc:	8d 45 de             	lea    -0x22(%ebp),%eax
     dff:	50                   	push   %eax
     e00:	e8 6b 28 00 00       	call   3670 <memset>
     e05:	83 c4 10             	add    $0x10,%esp
     e08:	eb 0b                	jmp    e15 <sharedfd+0x75>
     e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < 1000; i++){
     e10:	83 eb 01             	sub    $0x1,%ebx
     e13:	74 29                	je     e3e <sharedfd+0x9e>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     e15:	8d 45 de             	lea    -0x22(%ebp),%eax
     e18:	83 ec 04             	sub    $0x4,%esp
     e1b:	6a 0a                	push   $0xa
     e1d:	50                   	push   %eax
     e1e:	56                   	push   %esi
     e1f:	e8 0e 2a 00 00       	call   3832 <write>
     e24:	83 c4 10             	add    $0x10,%esp
     e27:	83 f8 0a             	cmp    $0xa,%eax
     e2a:	74 e4                	je     e10 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     e2c:	83 ec 08             	sub    $0x8,%esp
     e2f:	68 04 4e 00 00       	push   $0x4e04
     e34:	6a 01                	push   $0x1
     e36:	e8 35 2b 00 00       	call   3970 <printf>
      break;
     e3b:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     e3e:	85 ff                	test   %edi,%edi
     e40:	0f 84 fe 00 00 00    	je     f44 <sharedfd+0x1a4>
    wait();
     e46:	e8 cf 29 00 00       	call   381a <wait>
  close(fd);
     e4b:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     e4e:	31 db                	xor    %ebx,%ebx
     e50:	31 ff                	xor    %edi,%edi
  close(fd);
     e52:	56                   	push   %esi
     e53:	8d 75 e8             	lea    -0x18(%ebp),%esi
     e56:	e8 df 29 00 00       	call   383a <close>
  fd = open("sharedfd", 0);
     e5b:	58                   	pop    %eax
     e5c:	5a                   	pop    %edx
     e5d:	6a 00                	push   $0x0
     e5f:	68 03 41 00 00       	push   $0x4103
     e64:	e8 e9 29 00 00       	call   3852 <open>
  if(fd < 0){
     e69:	83 c4 10             	add    $0x10,%esp
     e6c:	85 c0                	test   %eax,%eax
  fd = open("sharedfd", 0);
     e6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     e71:	0f 88 b3 00 00 00    	js     f2a <sharedfd+0x18a>
     e77:	89 f8                	mov    %edi,%eax
     e79:	89 df                	mov    %ebx,%edi
     e7b:	89 c3                	mov    %eax,%ebx
     e7d:	8d 76 00             	lea    0x0(%esi),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
     e80:	8d 45 de             	lea    -0x22(%ebp),%eax
     e83:	83 ec 04             	sub    $0x4,%esp
     e86:	6a 0a                	push   $0xa
     e88:	50                   	push   %eax
     e89:	ff 75 d4             	pushl  -0x2c(%ebp)
     e8c:	e8 99 29 00 00       	call   382a <read>
     e91:	83 c4 10             	add    $0x10,%esp
     e94:	85 c0                	test   %eax,%eax
     e96:	7e 28                	jle    ec0 <sharedfd+0x120>
     e98:	8d 45 de             	lea    -0x22(%ebp),%eax
     e9b:	eb 15                	jmp    eb2 <sharedfd+0x112>
     e9d:	8d 76 00             	lea    0x0(%esi),%esi
        np++;
     ea0:	80 fa 70             	cmp    $0x70,%dl
     ea3:	0f 94 c2             	sete   %dl
     ea6:	0f b6 d2             	movzbl %dl,%edx
     ea9:	01 d7                	add    %edx,%edi
     eab:	83 c0 01             	add    $0x1,%eax
    for(i = 0; i < sizeof(buf); i++){
     eae:	39 f0                	cmp    %esi,%eax
     eb0:	74 ce                	je     e80 <sharedfd+0xe0>
      if(buf[i] == 'c')
     eb2:	0f b6 10             	movzbl (%eax),%edx
     eb5:	80 fa 63             	cmp    $0x63,%dl
     eb8:	75 e6                	jne    ea0 <sharedfd+0x100>
        nc++;
     eba:	83 c3 01             	add    $0x1,%ebx
     ebd:	eb ec                	jmp    eab <sharedfd+0x10b>
     ebf:	90                   	nop
  close(fd);
     ec0:	83 ec 0c             	sub    $0xc,%esp
     ec3:	89 d8                	mov    %ebx,%eax
     ec5:	ff 75 d4             	pushl  -0x2c(%ebp)
     ec8:	89 fb                	mov    %edi,%ebx
     eca:	89 c7                	mov    %eax,%edi
     ecc:	e8 69 29 00 00       	call   383a <close>
  unlink("sharedfd");
     ed1:	c7 04 24 03 41 00 00 	movl   $0x4103,(%esp)
     ed8:	e8 85 29 00 00       	call   3862 <unlink>
  if(nc == 10000 && np == 10000){
     edd:	83 c4 10             	add    $0x10,%esp
     ee0:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     ee6:	75 61                	jne    f49 <sharedfd+0x1a9>
     ee8:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     eee:	75 59                	jne    f49 <sharedfd+0x1a9>
    printf(1, "sharedfd ok\n");
     ef0:	83 ec 08             	sub    $0x8,%esp
     ef3:	68 0c 41 00 00       	push   $0x410c
     ef8:	6a 01                	push   $0x1
     efa:	e8 71 2a 00 00       	call   3970 <printf>
     eff:	83 c4 10             	add    $0x10,%esp
}
     f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f05:	5b                   	pop    %ebx
     f06:	5e                   	pop    %esi
     f07:	5f                   	pop    %edi
     f08:	5d                   	pop    %ebp
     f09:	c3                   	ret    
     f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "fstests: cannot open sharedfd for writing");
     f10:	83 ec 08             	sub    $0x8,%esp
     f13:	68 d8 4d 00 00       	push   $0x4dd8
     f18:	6a 01                	push   $0x1
     f1a:	e8 51 2a 00 00       	call   3970 <printf>
    return;
     f1f:	83 c4 10             	add    $0x10,%esp
}
     f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f25:	5b                   	pop    %ebx
     f26:	5e                   	pop    %esi
     f27:	5f                   	pop    %edi
     f28:	5d                   	pop    %ebp
     f29:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
     f2a:	83 ec 08             	sub    $0x8,%esp
     f2d:	68 24 4e 00 00       	push   $0x4e24
     f32:	6a 01                	push   $0x1
     f34:	e8 37 2a 00 00       	call   3970 <printf>
    return;
     f39:	83 c4 10             	add    $0x10,%esp
}
     f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f3f:	5b                   	pop    %ebx
     f40:	5e                   	pop    %esi
     f41:	5f                   	pop    %edi
     f42:	5d                   	pop    %ebp
     f43:	c3                   	ret    
    exit();
     f44:	e8 c9 28 00 00       	call   3812 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
     f49:	53                   	push   %ebx
     f4a:	57                   	push   %edi
     f4b:	68 19 41 00 00       	push   $0x4119
     f50:	6a 01                	push   $0x1
     f52:	e8 19 2a 00 00       	call   3970 <printf>
    exit();
     f57:	e8 b6 28 00 00       	call   3812 <exit>
     f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000f60 <fourfiles>:
{
     f60:	55                   	push   %ebp
     f61:	89 e5                	mov    %esp,%ebp
     f63:	57                   	push   %edi
     f64:	56                   	push   %esi
     f65:	53                   	push   %ebx
  printf(1, "fourfiles test\n");
     f66:	be 2e 41 00 00       	mov    $0x412e,%esi
  for(pi = 0; pi < 4; pi++){
     f6b:	31 db                	xor    %ebx,%ebx
{
     f6d:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
     f70:	c7 45 d8 2e 41 00 00 	movl   $0x412e,-0x28(%ebp)
     f77:	c7 45 dc 87 42 00 00 	movl   $0x4287,-0x24(%ebp)
  printf(1, "fourfiles test\n");
     f7e:	68 34 41 00 00       	push   $0x4134
     f83:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
     f85:	c7 45 e0 8b 42 00 00 	movl   $0x428b,-0x20(%ebp)
     f8c:	c7 45 e4 31 41 00 00 	movl   $0x4131,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
     f93:	e8 d8 29 00 00       	call   3970 <printf>
     f98:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
     f9b:	83 ec 0c             	sub    $0xc,%esp
     f9e:	56                   	push   %esi
     f9f:	e8 be 28 00 00       	call   3862 <unlink>
    pid = fork();
     fa4:	e8 61 28 00 00       	call   380a <fork>
    if(pid < 0){
     fa9:	83 c4 10             	add    $0x10,%esp
     fac:	85 c0                	test   %eax,%eax
     fae:	0f 88 88 01 00 00    	js     113c <fourfiles+0x1dc>
    if(pid == 0){
     fb4:	0f 84 ff 00 00 00    	je     10b9 <fourfiles+0x159>
  for(pi = 0; pi < 4; pi++){
     fba:	83 c3 01             	add    $0x1,%ebx
     fbd:	83 fb 04             	cmp    $0x4,%ebx
     fc0:	74 06                	je     fc8 <fourfiles+0x68>
     fc2:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
     fc6:	eb d3                	jmp    f9b <fourfiles+0x3b>
    wait();
     fc8:	e8 4d 28 00 00       	call   381a <wait>
  for(i = 0; i < 2; i++){
     fcd:	31 ff                	xor    %edi,%edi
    wait();
     fcf:	e8 46 28 00 00       	call   381a <wait>
     fd4:	e8 41 28 00 00       	call   381a <wait>
     fd9:	e8 3c 28 00 00       	call   381a <wait>
     fde:	c7 45 cc 2e 41 00 00 	movl   $0x412e,-0x34(%ebp)
    fd = open(fname, 0);
     fe5:	83 ec 08             	sub    $0x8,%esp
    total = 0;
     fe8:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
     fea:	6a 00                	push   $0x0
     fec:	ff 75 cc             	pushl  -0x34(%ebp)
     fef:	e8 5e 28 00 00       	call   3852 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
     ff4:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
     ff7:	89 45 d0             	mov    %eax,-0x30(%ebp)
     ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1000:	83 ec 04             	sub    $0x4,%esp
    1003:	68 00 20 00 00       	push   $0x2000
    1008:	68 60 85 00 00       	push   $0x8560
    100d:	ff 75 d0             	pushl  -0x30(%ebp)
    1010:	e8 15 28 00 00       	call   382a <read>
    1015:	83 c4 10             	add    $0x10,%esp
    1018:	85 c0                	test   %eax,%eax
    101a:	7e 46                	jle    1062 <fourfiles+0x102>
      printf(1, "bytes read: %d\n", n);
    101c:	83 ec 04             	sub    $0x4,%esp
    101f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1022:	50                   	push   %eax
    1023:	68 55 41 00 00       	push   $0x4155
    1028:	6a 01                	push   $0x1
    102a:	e8 41 29 00 00       	call   3970 <printf>
      for(j = 0; j < n; j++){
    102f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      printf(1, "bytes read: %d\n", n);
    1032:	83 c4 10             	add    $0x10,%esp
      for(j = 0; j < n; j++){
    1035:	31 d2                	xor    %edx,%edx
    1037:	89 f6                	mov    %esi,%esi
    1039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if(buf[j] != '0'+i){
    1040:	0f be b2 60 85 00 00 	movsbl 0x8560(%edx),%esi
    1047:	83 ff 01             	cmp    $0x1,%edi
    104a:	19 c9                	sbb    %ecx,%ecx
    104c:	83 c1 31             	add    $0x31,%ecx
    104f:	39 ce                	cmp    %ecx,%esi
    1051:	0f 85 be 00 00 00    	jne    1115 <fourfiles+0x1b5>
      for(j = 0; j < n; j++){
    1057:	83 c2 01             	add    $0x1,%edx
    105a:	39 d0                	cmp    %edx,%eax
    105c:	75 e2                	jne    1040 <fourfiles+0xe0>
      total += n;
    105e:	01 c3                	add    %eax,%ebx
    1060:	eb 9e                	jmp    1000 <fourfiles+0xa0>
    close(fd);
    1062:	83 ec 0c             	sub    $0xc,%esp
    1065:	ff 75 d0             	pushl  -0x30(%ebp)
    1068:	e8 cd 27 00 00       	call   383a <close>
    if(total != 12*500){
    106d:	83 c4 10             	add    $0x10,%esp
    1070:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1076:	0f 85 d3 00 00 00    	jne    114f <fourfiles+0x1ef>
    unlink(fname);
    107c:	83 ec 0c             	sub    $0xc,%esp
    107f:	ff 75 cc             	pushl  -0x34(%ebp)
    1082:	e8 db 27 00 00       	call   3862 <unlink>
  for(i = 0; i < 2; i++){
    1087:	83 c4 10             	add    $0x10,%esp
    108a:	83 ff 01             	cmp    $0x1,%edi
    108d:	75 1a                	jne    10a9 <fourfiles+0x149>
  printf(1, "fourfiles ok\n");
    108f:	83 ec 08             	sub    $0x8,%esp
    1092:	68 82 41 00 00       	push   $0x4182
    1097:	6a 01                	push   $0x1
    1099:	e8 d2 28 00 00       	call   3970 <printf>
}
    109e:	83 c4 10             	add    $0x10,%esp
    10a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    10a4:	5b                   	pop    %ebx
    10a5:	5e                   	pop    %esi
    10a6:	5f                   	pop    %edi
    10a7:	5d                   	pop    %ebp
    10a8:	c3                   	ret    
    10a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
    10ac:	bf 01 00 00 00       	mov    $0x1,%edi
    10b1:	89 45 cc             	mov    %eax,-0x34(%ebp)
    10b4:	e9 2c ff ff ff       	jmp    fe5 <fourfiles+0x85>
      fd = open(fname, O_CREATE | O_RDWR);
    10b9:	83 ec 08             	sub    $0x8,%esp
    10bc:	68 02 02 00 00       	push   $0x202
    10c1:	56                   	push   %esi
    10c2:	e8 8b 27 00 00       	call   3852 <open>
      if(fd < 0){
    10c7:	83 c4 10             	add    $0x10,%esp
    10ca:	85 c0                	test   %eax,%eax
      fd = open(fname, O_CREATE | O_RDWR);
    10cc:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    10ce:	78 59                	js     1129 <fourfiles+0x1c9>
      memset(buf, '0'+pi, 512);
    10d0:	83 ec 04             	sub    $0x4,%esp
    10d3:	83 c3 30             	add    $0x30,%ebx
    10d6:	68 00 02 00 00       	push   $0x200
    10db:	53                   	push   %ebx
    10dc:	bb 0c 00 00 00       	mov    $0xc,%ebx
    10e1:	68 60 85 00 00       	push   $0x8560
    10e6:	e8 85 25 00 00       	call   3670 <memset>
    10eb:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    10ee:	83 ec 04             	sub    $0x4,%esp
    10f1:	68 f4 01 00 00       	push   $0x1f4
    10f6:	68 60 85 00 00       	push   $0x8560
    10fb:	56                   	push   %esi
    10fc:	e8 31 27 00 00       	call   3832 <write>
    1101:	83 c4 10             	add    $0x10,%esp
    1104:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1109:	75 57                	jne    1162 <fourfiles+0x202>
      for(i = 0; i < 12; i++){
    110b:	83 eb 01             	sub    $0x1,%ebx
    110e:	75 de                	jne    10ee <fourfiles+0x18e>
      exit();
    1110:	e8 fd 26 00 00       	call   3812 <exit>
          printf(1, "wrong char\n");
    1115:	83 ec 08             	sub    $0x8,%esp
    1118:	68 65 41 00 00       	push   $0x4165
    111d:	6a 01                	push   $0x1
    111f:	e8 4c 28 00 00       	call   3970 <printf>
          exit();
    1124:	e8 e9 26 00 00       	call   3812 <exit>
        printf(1, "create failed\n");
    1129:	51                   	push   %ecx
    112a:	51                   	push   %ecx
    112b:	68 df 43 00 00       	push   $0x43df
    1130:	6a 01                	push   $0x1
    1132:	e8 39 28 00 00       	call   3970 <printf>
        exit();
    1137:	e8 d6 26 00 00       	call   3812 <exit>
      printf(1, "fork failed\n");
    113c:	53                   	push   %ebx
    113d:	53                   	push   %ebx
    113e:	68 19 4c 00 00       	push   $0x4c19
    1143:	6a 01                	push   $0x1
    1145:	e8 26 28 00 00       	call   3970 <printf>
      exit();
    114a:	e8 c3 26 00 00       	call   3812 <exit>
      printf(1, "wrong length %d\n", total);
    114f:	50                   	push   %eax
    1150:	53                   	push   %ebx
    1151:	68 71 41 00 00       	push   $0x4171
    1156:	6a 01                	push   $0x1
    1158:	e8 13 28 00 00       	call   3970 <printf>
      exit();
    115d:	e8 b0 26 00 00       	call   3812 <exit>
          printf(1, "write failed %d\n", n);
    1162:	52                   	push   %edx
    1163:	50                   	push   %eax
    1164:	68 44 41 00 00       	push   $0x4144
    1169:	6a 01                	push   $0x1
    116b:	e8 00 28 00 00       	call   3970 <printf>
          exit();
    1170:	e8 9d 26 00 00       	call   3812 <exit>
    1175:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001180 <createdelete>:
{
    1180:	55                   	push   %ebp
    1181:	89 e5                	mov    %esp,%ebp
    1183:	57                   	push   %edi
    1184:	56                   	push   %esi
    1185:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    1186:	31 db                	xor    %ebx,%ebx
{
    1188:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    118b:	68 90 41 00 00       	push   $0x4190
    1190:	6a 01                	push   $0x1
    1192:	e8 d9 27 00 00       	call   3970 <printf>
    1197:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    119a:	e8 6b 26 00 00       	call   380a <fork>
    if(pid < 0){
    119f:	85 c0                	test   %eax,%eax
    11a1:	0f 88 be 01 00 00    	js     1365 <createdelete+0x1e5>
    if(pid == 0){
    11a7:	0f 84 0b 01 00 00    	je     12b8 <createdelete+0x138>
  for(pi = 0; pi < 4; pi++){
    11ad:	83 c3 01             	add    $0x1,%ebx
    11b0:	83 fb 04             	cmp    $0x4,%ebx
    11b3:	75 e5                	jne    119a <createdelete+0x1a>
    11b5:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    11b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    11bd:	e8 58 26 00 00       	call   381a <wait>
    11c2:	e8 53 26 00 00       	call   381a <wait>
    11c7:	e8 4e 26 00 00       	call   381a <wait>
    11cc:	e8 49 26 00 00       	call   381a <wait>
  name[0] = name[1] = name[2] = 0;
    11d1:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    11d5:	8d 76 00             	lea    0x0(%esi),%esi
    11d8:	8d 46 31             	lea    0x31(%esi),%eax
    11db:	88 45 c7             	mov    %al,-0x39(%ebp)
    11de:	8d 46 01             	lea    0x1(%esi),%eax
    11e1:	83 f8 09             	cmp    $0x9,%eax
    11e4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    11e7:	0f 9f c3             	setg   %bl
    11ea:	85 c0                	test   %eax,%eax
    11ec:	0f 94 c0             	sete   %al
    11ef:	09 c3                	or     %eax,%ebx
    11f1:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    11f4:	bb 70 00 00 00       	mov    $0x70,%ebx
      name[1] = '0' + i;
    11f9:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      fd = open(name, 0);
    11fd:	83 ec 08             	sub    $0x8,%esp
      name[0] = 'p' + pi;
    1200:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    1203:	6a 00                	push   $0x0
    1205:	57                   	push   %edi
      name[1] = '0' + i;
    1206:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1209:	e8 44 26 00 00       	call   3852 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    120e:	83 c4 10             	add    $0x10,%esp
    1211:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    1215:	0f 84 85 00 00 00    	je     12a0 <createdelete+0x120>
    121b:	85 c0                	test   %eax,%eax
    121d:	0f 88 1a 01 00 00    	js     133d <createdelete+0x1bd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1223:	83 fe 08             	cmp    $0x8,%esi
    1226:	0f 86 54 01 00 00    	jbe    1380 <createdelete+0x200>
        close(fd);
    122c:	83 ec 0c             	sub    $0xc,%esp
    122f:	50                   	push   %eax
    1230:	e8 05 26 00 00       	call   383a <close>
    1235:	83 c4 10             	add    $0x10,%esp
    1238:	83 c3 01             	add    $0x1,%ebx
    for(pi = 0; pi < 4; pi++){
    123b:	80 fb 74             	cmp    $0x74,%bl
    123e:	75 b9                	jne    11f9 <createdelete+0x79>
    1240:	8b 75 c0             	mov    -0x40(%ebp),%esi
  for(i = 0; i < N; i++){
    1243:	83 fe 13             	cmp    $0x13,%esi
    1246:	75 90                	jne    11d8 <createdelete+0x58>
    1248:	be 70 00 00 00       	mov    $0x70,%esi
    124d:	8d 76 00             	lea    0x0(%esi),%esi
    1250:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    1253:	bb 04 00 00 00       	mov    $0x4,%ebx
    1258:	88 45 c7             	mov    %al,-0x39(%ebp)
      name[0] = 'p' + i;
    125b:	89 f0                	mov    %esi,%eax
      unlink(name);
    125d:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    1260:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1263:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      unlink(name);
    1267:	57                   	push   %edi
      name[1] = '0' + i;
    1268:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    126b:	e8 f2 25 00 00       	call   3862 <unlink>
    for(pi = 0; pi < 4; pi++){
    1270:	83 c4 10             	add    $0x10,%esp
    1273:	83 eb 01             	sub    $0x1,%ebx
    1276:	75 e3                	jne    125b <createdelete+0xdb>
    1278:	83 c6 01             	add    $0x1,%esi
  for(i = 0; i < N; i++){
    127b:	89 f0                	mov    %esi,%eax
    127d:	3c 84                	cmp    $0x84,%al
    127f:	75 cf                	jne    1250 <createdelete+0xd0>
  printf(1, "createdelete ok\n");
    1281:	83 ec 08             	sub    $0x8,%esp
    1284:	68 a3 41 00 00       	push   $0x41a3
    1289:	6a 01                	push   $0x1
    128b:	e8 e0 26 00 00       	call   3970 <printf>
}
    1290:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1293:	5b                   	pop    %ebx
    1294:	5e                   	pop    %esi
    1295:	5f                   	pop    %edi
    1296:	5d                   	pop    %ebp
    1297:	c3                   	ret    
    1298:	90                   	nop
    1299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12a0:	83 fe 08             	cmp    $0x8,%esi
    12a3:	0f 86 cf 00 00 00    	jbe    1378 <createdelete+0x1f8>
      if(fd >= 0)
    12a9:	85 c0                	test   %eax,%eax
    12ab:	78 8b                	js     1238 <createdelete+0xb8>
    12ad:	e9 7a ff ff ff       	jmp    122c <createdelete+0xac>
    12b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    12b8:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    12bb:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    12bf:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    12c2:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    12c5:	31 db                	xor    %ebx,%ebx
    12c7:	eb 0f                	jmp    12d8 <createdelete+0x158>
    12c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    12d0:	83 fb 13             	cmp    $0x13,%ebx
    12d3:	74 63                	je     1338 <createdelete+0x1b8>
    12d5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    12d8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    12db:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    12de:	68 02 02 00 00       	push   $0x202
    12e3:	57                   	push   %edi
        name[1] = '0' + i;
    12e4:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    12e7:	e8 66 25 00 00       	call   3852 <open>
        if(fd < 0){
    12ec:	83 c4 10             	add    $0x10,%esp
    12ef:	85 c0                	test   %eax,%eax
    12f1:	78 5f                	js     1352 <createdelete+0x1d2>
        close(fd);
    12f3:	83 ec 0c             	sub    $0xc,%esp
    12f6:	50                   	push   %eax
    12f7:	e8 3e 25 00 00       	call   383a <close>
        if(i > 0 && (i % 2 ) == 0){
    12fc:	83 c4 10             	add    $0x10,%esp
    12ff:	85 db                	test   %ebx,%ebx
    1301:	74 d2                	je     12d5 <createdelete+0x155>
    1303:	f6 c3 01             	test   $0x1,%bl
    1306:	75 c8                	jne    12d0 <createdelete+0x150>
          if(unlink(name) < 0){
    1308:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    130b:	89 d8                	mov    %ebx,%eax
    130d:	d1 f8                	sar    %eax
          if(unlink(name) < 0){
    130f:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    1310:	83 c0 30             	add    $0x30,%eax
    1313:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1316:	e8 47 25 00 00       	call   3862 <unlink>
    131b:	83 c4 10             	add    $0x10,%esp
    131e:	85 c0                	test   %eax,%eax
    1320:	79 ae                	jns    12d0 <createdelete+0x150>
            printf(1, "unlink failed\n");
    1322:	52                   	push   %edx
    1323:	52                   	push   %edx
    1324:	68 81 3d 00 00       	push   $0x3d81
    1329:	6a 01                	push   $0x1
    132b:	e8 40 26 00 00       	call   3970 <printf>
            exit();
    1330:	e8 dd 24 00 00       	call   3812 <exit>
    1335:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    1338:	e8 d5 24 00 00       	call   3812 <exit>
        printf(1, "oops createdelete %s didn't exist\n", name);
    133d:	83 ec 04             	sub    $0x4,%esp
    1340:	57                   	push   %edi
    1341:	68 50 4e 00 00       	push   $0x4e50
    1346:	6a 01                	push   $0x1
    1348:	e8 23 26 00 00       	call   3970 <printf>
        exit();
    134d:	e8 c0 24 00 00       	call   3812 <exit>
          printf(1, "create failed\n");
    1352:	51                   	push   %ecx
    1353:	51                   	push   %ecx
    1354:	68 df 43 00 00       	push   $0x43df
    1359:	6a 01                	push   $0x1
    135b:	e8 10 26 00 00       	call   3970 <printf>
          exit();
    1360:	e8 ad 24 00 00       	call   3812 <exit>
      printf(1, "fork failed\n");
    1365:	53                   	push   %ebx
    1366:	53                   	push   %ebx
    1367:	68 19 4c 00 00       	push   $0x4c19
    136c:	6a 01                	push   $0x1
    136e:	e8 fd 25 00 00       	call   3970 <printf>
      exit();
    1373:	e8 9a 24 00 00       	call   3812 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1378:	85 c0                	test   %eax,%eax
    137a:	0f 88 b8 fe ff ff    	js     1238 <createdelete+0xb8>
        printf(1, "oops createdelete %s did exist\n", name);
    1380:	50                   	push   %eax
    1381:	57                   	push   %edi
    1382:	68 74 4e 00 00       	push   $0x4e74
    1387:	6a 01                	push   $0x1
    1389:	e8 e2 25 00 00       	call   3970 <printf>
        exit();
    138e:	e8 7f 24 00 00       	call   3812 <exit>
    1393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000013a0 <unlinkread>:
{
    13a0:	55                   	push   %ebp
    13a1:	89 e5                	mov    %esp,%ebp
    13a3:	56                   	push   %esi
    13a4:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    13a5:	83 ec 08             	sub    $0x8,%esp
    13a8:	68 b4 41 00 00       	push   $0x41b4
    13ad:	6a 01                	push   $0x1
    13af:	e8 bc 25 00 00       	call   3970 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    13b4:	5b                   	pop    %ebx
    13b5:	5e                   	pop    %esi
    13b6:	68 02 02 00 00       	push   $0x202
    13bb:	68 c5 41 00 00       	push   $0x41c5
    13c0:	e8 8d 24 00 00       	call   3852 <open>
  if(fd < 0){
    13c5:	83 c4 10             	add    $0x10,%esp
    13c8:	85 c0                	test   %eax,%eax
    13ca:	0f 88 e6 00 00 00    	js     14b6 <unlinkread+0x116>
  write(fd, "hello", 5);
    13d0:	83 ec 04             	sub    $0x4,%esp
    13d3:	89 c3                	mov    %eax,%ebx
    13d5:	6a 05                	push   $0x5
    13d7:	68 ea 41 00 00       	push   $0x41ea
    13dc:	50                   	push   %eax
    13dd:	e8 50 24 00 00       	call   3832 <write>
  close(fd);
    13e2:	89 1c 24             	mov    %ebx,(%esp)
    13e5:	e8 50 24 00 00       	call   383a <close>
  fd = open("unlinkread", O_RDWR);
    13ea:	58                   	pop    %eax
    13eb:	5a                   	pop    %edx
    13ec:	6a 02                	push   $0x2
    13ee:	68 c5 41 00 00       	push   $0x41c5
    13f3:	e8 5a 24 00 00       	call   3852 <open>
  if(fd < 0){
    13f8:	83 c4 10             	add    $0x10,%esp
    13fb:	85 c0                	test   %eax,%eax
  fd = open("unlinkread", O_RDWR);
    13fd:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    13ff:	0f 88 10 01 00 00    	js     1515 <unlinkread+0x175>
  if(unlink("unlinkread") != 0){
    1405:	83 ec 0c             	sub    $0xc,%esp
    1408:	68 c5 41 00 00       	push   $0x41c5
    140d:	e8 50 24 00 00       	call   3862 <unlink>
    1412:	83 c4 10             	add    $0x10,%esp
    1415:	85 c0                	test   %eax,%eax
    1417:	0f 85 e5 00 00 00    	jne    1502 <unlinkread+0x162>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    141d:	83 ec 08             	sub    $0x8,%esp
    1420:	68 02 02 00 00       	push   $0x202
    1425:	68 c5 41 00 00       	push   $0x41c5
    142a:	e8 23 24 00 00       	call   3852 <open>
  write(fd1, "yyy", 3);
    142f:	83 c4 0c             	add    $0xc,%esp
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1432:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    1434:	6a 03                	push   $0x3
    1436:	68 22 42 00 00       	push   $0x4222
    143b:	50                   	push   %eax
    143c:	e8 f1 23 00 00       	call   3832 <write>
  close(fd1);
    1441:	89 34 24             	mov    %esi,(%esp)
    1444:	e8 f1 23 00 00       	call   383a <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    1449:	83 c4 0c             	add    $0xc,%esp
    144c:	68 00 20 00 00       	push   $0x2000
    1451:	68 60 85 00 00       	push   $0x8560
    1456:	53                   	push   %ebx
    1457:	e8 ce 23 00 00       	call   382a <read>
    145c:	83 c4 10             	add    $0x10,%esp
    145f:	83 f8 05             	cmp    $0x5,%eax
    1462:	0f 85 87 00 00 00    	jne    14ef <unlinkread+0x14f>
  if(buf[0] != 'h'){
    1468:	80 3d 60 85 00 00 68 	cmpb   $0x68,0x8560
    146f:	75 6b                	jne    14dc <unlinkread+0x13c>
  if(write(fd, buf, 10) != 10){
    1471:	83 ec 04             	sub    $0x4,%esp
    1474:	6a 0a                	push   $0xa
    1476:	68 60 85 00 00       	push   $0x8560
    147b:	53                   	push   %ebx
    147c:	e8 b1 23 00 00       	call   3832 <write>
    1481:	83 c4 10             	add    $0x10,%esp
    1484:	83 f8 0a             	cmp    $0xa,%eax
    1487:	75 40                	jne    14c9 <unlinkread+0x129>
  close(fd);
    1489:	83 ec 0c             	sub    $0xc,%esp
    148c:	53                   	push   %ebx
    148d:	e8 a8 23 00 00       	call   383a <close>
  unlink("unlinkread");
    1492:	c7 04 24 c5 41 00 00 	movl   $0x41c5,(%esp)
    1499:	e8 c4 23 00 00       	call   3862 <unlink>
  printf(1, "unlinkread ok\n");
    149e:	58                   	pop    %eax
    149f:	5a                   	pop    %edx
    14a0:	68 6d 42 00 00       	push   $0x426d
    14a5:	6a 01                	push   $0x1
    14a7:	e8 c4 24 00 00       	call   3970 <printf>
}
    14ac:	83 c4 10             	add    $0x10,%esp
    14af:	8d 65 f8             	lea    -0x8(%ebp),%esp
    14b2:	5b                   	pop    %ebx
    14b3:	5e                   	pop    %esi
    14b4:	5d                   	pop    %ebp
    14b5:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    14b6:	51                   	push   %ecx
    14b7:	51                   	push   %ecx
    14b8:	68 d0 41 00 00       	push   $0x41d0
    14bd:	6a 01                	push   $0x1
    14bf:	e8 ac 24 00 00       	call   3970 <printf>
    exit();
    14c4:	e8 49 23 00 00       	call   3812 <exit>
    printf(1, "unlinkread write failed\n");
    14c9:	51                   	push   %ecx
    14ca:	51                   	push   %ecx
    14cb:	68 54 42 00 00       	push   $0x4254
    14d0:	6a 01                	push   $0x1
    14d2:	e8 99 24 00 00       	call   3970 <printf>
    exit();
    14d7:	e8 36 23 00 00       	call   3812 <exit>
    printf(1, "unlinkread wrong data\n");
    14dc:	53                   	push   %ebx
    14dd:	53                   	push   %ebx
    14de:	68 3d 42 00 00       	push   $0x423d
    14e3:	6a 01                	push   $0x1
    14e5:	e8 86 24 00 00       	call   3970 <printf>
    exit();
    14ea:	e8 23 23 00 00       	call   3812 <exit>
    printf(1, "unlinkread read failed");
    14ef:	56                   	push   %esi
    14f0:	56                   	push   %esi
    14f1:	68 26 42 00 00       	push   $0x4226
    14f6:	6a 01                	push   $0x1
    14f8:	e8 73 24 00 00       	call   3970 <printf>
    exit();
    14fd:	e8 10 23 00 00       	call   3812 <exit>
    printf(1, "unlink unlinkread failed\n");
    1502:	50                   	push   %eax
    1503:	50                   	push   %eax
    1504:	68 08 42 00 00       	push   $0x4208
    1509:	6a 01                	push   $0x1
    150b:	e8 60 24 00 00       	call   3970 <printf>
    exit();
    1510:	e8 fd 22 00 00       	call   3812 <exit>
    printf(1, "open unlinkread failed\n");
    1515:	50                   	push   %eax
    1516:	50                   	push   %eax
    1517:	68 f0 41 00 00       	push   $0x41f0
    151c:	6a 01                	push   $0x1
    151e:	e8 4d 24 00 00       	call   3970 <printf>
    exit();
    1523:	e8 ea 22 00 00       	call   3812 <exit>
    1528:	90                   	nop
    1529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001530 <linktest>:
{
    1530:	55                   	push   %ebp
    1531:	89 e5                	mov    %esp,%ebp
    1533:	53                   	push   %ebx
    1534:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    1537:	68 7c 42 00 00       	push   $0x427c
    153c:	6a 01                	push   $0x1
    153e:	e8 2d 24 00 00       	call   3970 <printf>
  unlink("lf1");
    1543:	c7 04 24 86 42 00 00 	movl   $0x4286,(%esp)
    154a:	e8 13 23 00 00       	call   3862 <unlink>
  unlink("lf2");
    154f:	c7 04 24 8a 42 00 00 	movl   $0x428a,(%esp)
    1556:	e8 07 23 00 00       	call   3862 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    155b:	58                   	pop    %eax
    155c:	5a                   	pop    %edx
    155d:	68 02 02 00 00       	push   $0x202
    1562:	68 86 42 00 00       	push   $0x4286
    1567:	e8 e6 22 00 00       	call   3852 <open>
  if(fd < 0){
    156c:	83 c4 10             	add    $0x10,%esp
    156f:	85 c0                	test   %eax,%eax
    1571:	0f 88 1e 01 00 00    	js     1695 <linktest+0x165>
  if(write(fd, "hello", 5) != 5){
    1577:	83 ec 04             	sub    $0x4,%esp
    157a:	89 c3                	mov    %eax,%ebx
    157c:	6a 05                	push   $0x5
    157e:	68 ea 41 00 00       	push   $0x41ea
    1583:	50                   	push   %eax
    1584:	e8 a9 22 00 00       	call   3832 <write>
    1589:	83 c4 10             	add    $0x10,%esp
    158c:	83 f8 05             	cmp    $0x5,%eax
    158f:	0f 85 98 01 00 00    	jne    172d <linktest+0x1fd>
  close(fd);
    1595:	83 ec 0c             	sub    $0xc,%esp
    1598:	53                   	push   %ebx
    1599:	e8 9c 22 00 00       	call   383a <close>
  if(link("lf1", "lf2") < 0){
    159e:	5b                   	pop    %ebx
    159f:	58                   	pop    %eax
    15a0:	68 8a 42 00 00       	push   $0x428a
    15a5:	68 86 42 00 00       	push   $0x4286
    15aa:	e8 c3 22 00 00       	call   3872 <link>
    15af:	83 c4 10             	add    $0x10,%esp
    15b2:	85 c0                	test   %eax,%eax
    15b4:	0f 88 60 01 00 00    	js     171a <linktest+0x1ea>
  unlink("lf1");
    15ba:	83 ec 0c             	sub    $0xc,%esp
    15bd:	68 86 42 00 00       	push   $0x4286
    15c2:	e8 9b 22 00 00       	call   3862 <unlink>
  if(open("lf1", 0) >= 0){
    15c7:	58                   	pop    %eax
    15c8:	5a                   	pop    %edx
    15c9:	6a 00                	push   $0x0
    15cb:	68 86 42 00 00       	push   $0x4286
    15d0:	e8 7d 22 00 00       	call   3852 <open>
    15d5:	83 c4 10             	add    $0x10,%esp
    15d8:	85 c0                	test   %eax,%eax
    15da:	0f 89 27 01 00 00    	jns    1707 <linktest+0x1d7>
  fd = open("lf2", 0);
    15e0:	83 ec 08             	sub    $0x8,%esp
    15e3:	6a 00                	push   $0x0
    15e5:	68 8a 42 00 00       	push   $0x428a
    15ea:	e8 63 22 00 00       	call   3852 <open>
  if(fd < 0){
    15ef:	83 c4 10             	add    $0x10,%esp
    15f2:	85 c0                	test   %eax,%eax
  fd = open("lf2", 0);
    15f4:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    15f6:	0f 88 f8 00 00 00    	js     16f4 <linktest+0x1c4>
  if(read(fd, buf, sizeof(buf)) != 5){
    15fc:	83 ec 04             	sub    $0x4,%esp
    15ff:	68 00 20 00 00       	push   $0x2000
    1604:	68 60 85 00 00       	push   $0x8560
    1609:	50                   	push   %eax
    160a:	e8 1b 22 00 00       	call   382a <read>
    160f:	83 c4 10             	add    $0x10,%esp
    1612:	83 f8 05             	cmp    $0x5,%eax
    1615:	0f 85 c6 00 00 00    	jne    16e1 <linktest+0x1b1>
  close(fd);
    161b:	83 ec 0c             	sub    $0xc,%esp
    161e:	53                   	push   %ebx
    161f:	e8 16 22 00 00       	call   383a <close>
  if(link("lf2", "lf2") >= 0){
    1624:	58                   	pop    %eax
    1625:	5a                   	pop    %edx
    1626:	68 8a 42 00 00       	push   $0x428a
    162b:	68 8a 42 00 00       	push   $0x428a
    1630:	e8 3d 22 00 00       	call   3872 <link>
    1635:	83 c4 10             	add    $0x10,%esp
    1638:	85 c0                	test   %eax,%eax
    163a:	0f 89 8e 00 00 00    	jns    16ce <linktest+0x19e>
  unlink("lf2");
    1640:	83 ec 0c             	sub    $0xc,%esp
    1643:	68 8a 42 00 00       	push   $0x428a
    1648:	e8 15 22 00 00       	call   3862 <unlink>
  if(link("lf2", "lf1") >= 0){
    164d:	59                   	pop    %ecx
    164e:	5b                   	pop    %ebx
    164f:	68 86 42 00 00       	push   $0x4286
    1654:	68 8a 42 00 00       	push   $0x428a
    1659:	e8 14 22 00 00       	call   3872 <link>
    165e:	83 c4 10             	add    $0x10,%esp
    1661:	85 c0                	test   %eax,%eax
    1663:	79 56                	jns    16bb <linktest+0x18b>
  if(link(".", "lf1") >= 0){
    1665:	83 ec 08             	sub    $0x8,%esp
    1668:	68 86 42 00 00       	push   $0x4286
    166d:	68 4e 45 00 00       	push   $0x454e
    1672:	e8 fb 21 00 00       	call   3872 <link>
    1677:	83 c4 10             	add    $0x10,%esp
    167a:	85 c0                	test   %eax,%eax
    167c:	79 2a                	jns    16a8 <linktest+0x178>
  printf(1, "linktest ok\n");
    167e:	83 ec 08             	sub    $0x8,%esp
    1681:	68 24 43 00 00       	push   $0x4324
    1686:	6a 01                	push   $0x1
    1688:	e8 e3 22 00 00       	call   3970 <printf>
}
    168d:	83 c4 10             	add    $0x10,%esp
    1690:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1693:	c9                   	leave  
    1694:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1695:	50                   	push   %eax
    1696:	50                   	push   %eax
    1697:	68 8e 42 00 00       	push   $0x428e
    169c:	6a 01                	push   $0x1
    169e:	e8 cd 22 00 00       	call   3970 <printf>
    exit();
    16a3:	e8 6a 21 00 00       	call   3812 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    16a8:	50                   	push   %eax
    16a9:	50                   	push   %eax
    16aa:	68 08 43 00 00       	push   $0x4308
    16af:	6a 01                	push   $0x1
    16b1:	e8 ba 22 00 00       	call   3970 <printf>
    exit();
    16b6:	e8 57 21 00 00       	call   3812 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    16bb:	52                   	push   %edx
    16bc:	52                   	push   %edx
    16bd:	68 bc 4e 00 00       	push   $0x4ebc
    16c2:	6a 01                	push   $0x1
    16c4:	e8 a7 22 00 00       	call   3970 <printf>
    exit();
    16c9:	e8 44 21 00 00       	call   3812 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    16ce:	50                   	push   %eax
    16cf:	50                   	push   %eax
    16d0:	68 ea 42 00 00       	push   $0x42ea
    16d5:	6a 01                	push   $0x1
    16d7:	e8 94 22 00 00       	call   3970 <printf>
    exit();
    16dc:	e8 31 21 00 00       	call   3812 <exit>
    printf(1, "read lf2 failed\n");
    16e1:	51                   	push   %ecx
    16e2:	51                   	push   %ecx
    16e3:	68 d9 42 00 00       	push   $0x42d9
    16e8:	6a 01                	push   $0x1
    16ea:	e8 81 22 00 00       	call   3970 <printf>
    exit();
    16ef:	e8 1e 21 00 00       	call   3812 <exit>
    printf(1, "open lf2 failed\n");
    16f4:	53                   	push   %ebx
    16f5:	53                   	push   %ebx
    16f6:	68 c8 42 00 00       	push   $0x42c8
    16fb:	6a 01                	push   $0x1
    16fd:	e8 6e 22 00 00       	call   3970 <printf>
    exit();
    1702:	e8 0b 21 00 00       	call   3812 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1707:	50                   	push   %eax
    1708:	50                   	push   %eax
    1709:	68 94 4e 00 00       	push   $0x4e94
    170e:	6a 01                	push   $0x1
    1710:	e8 5b 22 00 00       	call   3970 <printf>
    exit();
    1715:	e8 f8 20 00 00       	call   3812 <exit>
    printf(1, "link lf1 lf2 failed\n");
    171a:	51                   	push   %ecx
    171b:	51                   	push   %ecx
    171c:	68 b3 42 00 00       	push   $0x42b3
    1721:	6a 01                	push   $0x1
    1723:	e8 48 22 00 00       	call   3970 <printf>
    exit();
    1728:	e8 e5 20 00 00       	call   3812 <exit>
    printf(1, "write lf1 failed\n");
    172d:	50                   	push   %eax
    172e:	50                   	push   %eax
    172f:	68 a1 42 00 00       	push   $0x42a1
    1734:	6a 01                	push   $0x1
    1736:	e8 35 22 00 00       	call   3970 <printf>
    exit();
    173b:	e8 d2 20 00 00       	call   3812 <exit>

00001740 <concreate>:
{
    1740:	55                   	push   %ebp
    1741:	89 e5                	mov    %esp,%ebp
    1743:	57                   	push   %edi
    1744:	56                   	push   %esi
    1745:	53                   	push   %ebx
  for(i = 0; i < 40; i++){
    1746:	31 f6                	xor    %esi,%esi
    1748:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    if(pid && (i % 3) == 1){
    174b:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
{
    1750:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1753:	68 31 43 00 00       	push   $0x4331
    1758:	6a 01                	push   $0x1
    175a:	e8 11 22 00 00       	call   3970 <printf>
  file[0] = 'C';
    175f:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1763:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
    1767:	83 c4 10             	add    $0x10,%esp
    176a:	eb 4c                	jmp    17b8 <concreate+0x78>
    176c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid && (i % 3) == 1){
    1770:	89 f0                	mov    %esi,%eax
    1772:	89 f1                	mov    %esi,%ecx
    1774:	f7 e7                	mul    %edi
    1776:	d1 ea                	shr    %edx
    1778:	8d 04 52             	lea    (%edx,%edx,2),%eax
    177b:	29 c1                	sub    %eax,%ecx
    177d:	83 f9 01             	cmp    $0x1,%ecx
    1780:	0f 84 ba 00 00 00    	je     1840 <concreate+0x100>
      fd = open(file, O_CREATE | O_RDWR);
    1786:	83 ec 08             	sub    $0x8,%esp
    1789:	68 02 02 00 00       	push   $0x202
    178e:	53                   	push   %ebx
    178f:	e8 be 20 00 00       	call   3852 <open>
      if(fd < 0){
    1794:	83 c4 10             	add    $0x10,%esp
    1797:	85 c0                	test   %eax,%eax
    1799:	78 67                	js     1802 <concreate+0xc2>
      close(fd);
    179b:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    179e:	83 c6 01             	add    $0x1,%esi
      close(fd);
    17a1:	50                   	push   %eax
    17a2:	e8 93 20 00 00       	call   383a <close>
    17a7:	83 c4 10             	add    $0x10,%esp
      wait();
    17aa:	e8 6b 20 00 00       	call   381a <wait>
  for(i = 0; i < 40; i++){
    17af:	83 fe 28             	cmp    $0x28,%esi
    17b2:	0f 84 aa 00 00 00    	je     1862 <concreate+0x122>
    unlink(file);
    17b8:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    17bb:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    17be:	53                   	push   %ebx
    file[1] = '0' + i;
    17bf:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    17c2:	e8 9b 20 00 00       	call   3862 <unlink>
    pid = fork();
    17c7:	e8 3e 20 00 00       	call   380a <fork>
    if(pid && (i % 3) == 1){
    17cc:	83 c4 10             	add    $0x10,%esp
    17cf:	85 c0                	test   %eax,%eax
    17d1:	75 9d                	jne    1770 <concreate+0x30>
    } else if(pid == 0 && (i % 5) == 1){
    17d3:	89 f0                	mov    %esi,%eax
    17d5:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    17da:	f7 e2                	mul    %edx
    17dc:	c1 ea 02             	shr    $0x2,%edx
    17df:	8d 04 92             	lea    (%edx,%edx,4),%eax
    17e2:	29 c6                	sub    %eax,%esi
    17e4:	83 fe 01             	cmp    $0x1,%esi
    17e7:	74 37                	je     1820 <concreate+0xe0>
      fd = open(file, O_CREATE | O_RDWR);
    17e9:	83 ec 08             	sub    $0x8,%esp
    17ec:	68 02 02 00 00       	push   $0x202
    17f1:	53                   	push   %ebx
    17f2:	e8 5b 20 00 00       	call   3852 <open>
      if(fd < 0){
    17f7:	83 c4 10             	add    $0x10,%esp
    17fa:	85 c0                	test   %eax,%eax
    17fc:	0f 89 28 02 00 00    	jns    1a2a <concreate+0x2ea>
        printf(1, "concreate create %s failed\n", file);
    1802:	83 ec 04             	sub    $0x4,%esp
    1805:	53                   	push   %ebx
    1806:	68 44 43 00 00       	push   $0x4344
    180b:	6a 01                	push   $0x1
    180d:	e8 5e 21 00 00       	call   3970 <printf>
        exit();
    1812:	e8 fb 1f 00 00       	call   3812 <exit>
    1817:	89 f6                	mov    %esi,%esi
    1819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      link("C0", file);
    1820:	83 ec 08             	sub    $0x8,%esp
    1823:	53                   	push   %ebx
    1824:	68 41 43 00 00       	push   $0x4341
    1829:	e8 44 20 00 00       	call   3872 <link>
    182e:	83 c4 10             	add    $0x10,%esp
      exit();
    1831:	e8 dc 1f 00 00       	call   3812 <exit>
    1836:	8d 76 00             	lea    0x0(%esi),%esi
    1839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      link("C0", file);
    1840:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    1843:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    1846:	53                   	push   %ebx
    1847:	68 41 43 00 00       	push   $0x4341
    184c:	e8 21 20 00 00       	call   3872 <link>
    1851:	83 c4 10             	add    $0x10,%esp
      wait();
    1854:	e8 c1 1f 00 00       	call   381a <wait>
  for(i = 0; i < 40; i++){
    1859:	83 fe 28             	cmp    $0x28,%esi
    185c:	0f 85 56 ff ff ff    	jne    17b8 <concreate+0x78>
  memset(fa, 0, sizeof(fa));
    1862:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1865:	83 ec 04             	sub    $0x4,%esp
    1868:	6a 28                	push   $0x28
    186a:	6a 00                	push   $0x0
    186c:	50                   	push   %eax
    186d:	e8 fe 1d 00 00       	call   3670 <memset>
  fd = open(".", 0);
    1872:	5f                   	pop    %edi
    1873:	58                   	pop    %eax
    1874:	6a 00                	push   $0x0
    1876:	68 4e 45 00 00       	push   $0x454e
    187b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    187e:	e8 cf 1f 00 00       	call   3852 <open>
  while(read(fd, &de, sizeof(de)) > 0){
    1883:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1886:	89 c6                	mov    %eax,%esi
  n = 0;
    1888:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    188f:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    1890:	83 ec 04             	sub    $0x4,%esp
    1893:	6a 10                	push   $0x10
    1895:	57                   	push   %edi
    1896:	56                   	push   %esi
    1897:	e8 8e 1f 00 00       	call   382a <read>
    189c:	83 c4 10             	add    $0x10,%esp
    189f:	85 c0                	test   %eax,%eax
    18a1:	7e 3d                	jle    18e0 <concreate+0x1a0>
    if(de.inum == 0)
    18a3:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    18a8:	74 e6                	je     1890 <concreate+0x150>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    18aa:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    18ae:	75 e0                	jne    1890 <concreate+0x150>
    18b0:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    18b4:	75 da                	jne    1890 <concreate+0x150>
      i = de.name[1] - '0';
    18b6:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    18ba:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    18bd:	83 f8 27             	cmp    $0x27,%eax
    18c0:	0f 87 4e 01 00 00    	ja     1a14 <concreate+0x2d4>
      if(fa[i]){
    18c6:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    18cb:	0f 85 2d 01 00 00    	jne    19fe <concreate+0x2be>
      fa[i] = 1;
    18d1:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    18d6:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    18da:	eb b4                	jmp    1890 <concreate+0x150>
    18dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    18e0:	83 ec 0c             	sub    $0xc,%esp
    18e3:	56                   	push   %esi
    18e4:	e8 51 1f 00 00       	call   383a <close>
  if(n != 40){
    18e9:	83 c4 10             	add    $0x10,%esp
    18ec:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    18f0:	0f 85 f5 00 00 00    	jne    19eb <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    18f6:	31 f6                	xor    %esi,%esi
    18f8:	eb 48                	jmp    1942 <concreate+0x202>
    18fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    1900:	85 ff                	test   %edi,%edi
    1902:	74 05                	je     1909 <concreate+0x1c9>
    1904:	83 fa 01             	cmp    $0x1,%edx
    1907:	74 64                	je     196d <concreate+0x22d>
      unlink(file);
    1909:	83 ec 0c             	sub    $0xc,%esp
    190c:	53                   	push   %ebx
    190d:	e8 50 1f 00 00       	call   3862 <unlink>
      unlink(file);
    1912:	89 1c 24             	mov    %ebx,(%esp)
    1915:	e8 48 1f 00 00       	call   3862 <unlink>
      unlink(file);
    191a:	89 1c 24             	mov    %ebx,(%esp)
    191d:	e8 40 1f 00 00       	call   3862 <unlink>
      unlink(file);
    1922:	89 1c 24             	mov    %ebx,(%esp)
    1925:	e8 38 1f 00 00       	call   3862 <unlink>
    192a:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    192d:	85 ff                	test   %edi,%edi
    192f:	0f 84 fc fe ff ff    	je     1831 <concreate+0xf1>
  for(i = 0; i < 40; i++){
    1935:	83 c6 01             	add    $0x1,%esi
      wait();
    1938:	e8 dd 1e 00 00       	call   381a <wait>
  for(i = 0; i < 40; i++){
    193d:	83 fe 28             	cmp    $0x28,%esi
    1940:	74 7e                	je     19c0 <concreate+0x280>
    file[1] = '0' + i;
    1942:	8d 46 30             	lea    0x30(%esi),%eax
    1945:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1948:	e8 bd 1e 00 00       	call   380a <fork>
    if(pid < 0){
    194d:	85 c0                	test   %eax,%eax
    pid = fork();
    194f:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1951:	0f 88 80 00 00 00    	js     19d7 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    1957:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    195c:	f7 e6                	mul    %esi
    195e:	d1 ea                	shr    %edx
    1960:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1963:	89 f2                	mov    %esi,%edx
    1965:	29 c2                	sub    %eax,%edx
    1967:	89 d0                	mov    %edx,%eax
    1969:	09 f8                	or     %edi,%eax
    196b:	75 93                	jne    1900 <concreate+0x1c0>
      close(open(file, 0));
    196d:	83 ec 08             	sub    $0x8,%esp
    1970:	6a 00                	push   $0x0
    1972:	53                   	push   %ebx
    1973:	e8 da 1e 00 00       	call   3852 <open>
    1978:	89 04 24             	mov    %eax,(%esp)
    197b:	e8 ba 1e 00 00       	call   383a <close>
      close(open(file, 0));
    1980:	58                   	pop    %eax
    1981:	5a                   	pop    %edx
    1982:	6a 00                	push   $0x0
    1984:	53                   	push   %ebx
    1985:	e8 c8 1e 00 00       	call   3852 <open>
    198a:	89 04 24             	mov    %eax,(%esp)
    198d:	e8 a8 1e 00 00       	call   383a <close>
      close(open(file, 0));
    1992:	59                   	pop    %ecx
    1993:	58                   	pop    %eax
    1994:	6a 00                	push   $0x0
    1996:	53                   	push   %ebx
    1997:	e8 b6 1e 00 00       	call   3852 <open>
    199c:	89 04 24             	mov    %eax,(%esp)
    199f:	e8 96 1e 00 00       	call   383a <close>
      close(open(file, 0));
    19a4:	58                   	pop    %eax
    19a5:	5a                   	pop    %edx
    19a6:	6a 00                	push   $0x0
    19a8:	53                   	push   %ebx
    19a9:	e8 a4 1e 00 00       	call   3852 <open>
    19ae:	89 04 24             	mov    %eax,(%esp)
    19b1:	e8 84 1e 00 00       	call   383a <close>
    19b6:	83 c4 10             	add    $0x10,%esp
    19b9:	e9 6f ff ff ff       	jmp    192d <concreate+0x1ed>
    19be:	66 90                	xchg   %ax,%ax
  printf(1, "concreate ok\n");
    19c0:	83 ec 08             	sub    $0x8,%esp
    19c3:	68 96 43 00 00       	push   $0x4396
    19c8:	6a 01                	push   $0x1
    19ca:	e8 a1 1f 00 00       	call   3970 <printf>
}
    19cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19d2:	5b                   	pop    %ebx
    19d3:	5e                   	pop    %esi
    19d4:	5f                   	pop    %edi
    19d5:	5d                   	pop    %ebp
    19d6:	c3                   	ret    
      printf(1, "fork failed\n");
    19d7:	83 ec 08             	sub    $0x8,%esp
    19da:	68 19 4c 00 00       	push   $0x4c19
    19df:	6a 01                	push   $0x1
    19e1:	e8 8a 1f 00 00       	call   3970 <printf>
      exit();
    19e6:	e8 27 1e 00 00       	call   3812 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    19eb:	51                   	push   %ecx
    19ec:	51                   	push   %ecx
    19ed:	68 e0 4e 00 00       	push   $0x4ee0
    19f2:	6a 01                	push   $0x1
    19f4:	e8 77 1f 00 00       	call   3970 <printf>
    exit();
    19f9:	e8 14 1e 00 00       	call   3812 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    19fe:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1a01:	53                   	push   %ebx
    1a02:	50                   	push   %eax
    1a03:	68 79 43 00 00       	push   $0x4379
    1a08:	6a 01                	push   $0x1
    1a0a:	e8 61 1f 00 00       	call   3970 <printf>
        exit();
    1a0f:	e8 fe 1d 00 00       	call   3812 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1a14:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1a17:	56                   	push   %esi
    1a18:	50                   	push   %eax
    1a19:	68 60 43 00 00       	push   $0x4360
    1a1e:	6a 01                	push   $0x1
    1a20:	e8 4b 1f 00 00       	call   3970 <printf>
        exit();
    1a25:	e8 e8 1d 00 00       	call   3812 <exit>
      close(fd);
    1a2a:	83 ec 0c             	sub    $0xc,%esp
    1a2d:	50                   	push   %eax
    1a2e:	e8 07 1e 00 00       	call   383a <close>
    1a33:	83 c4 10             	add    $0x10,%esp
    1a36:	e9 f6 fd ff ff       	jmp    1831 <concreate+0xf1>
    1a3b:	90                   	nop
    1a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001a40 <linkunlink>:
{
    1a40:	55                   	push   %ebp
    1a41:	89 e5                	mov    %esp,%ebp
    1a43:	57                   	push   %edi
    1a44:	56                   	push   %esi
    1a45:	53                   	push   %ebx
    1a46:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1a49:	68 a4 43 00 00       	push   $0x43a4
    1a4e:	6a 01                	push   $0x1
    1a50:	e8 1b 1f 00 00       	call   3970 <printf>
  unlink("x");
    1a55:	c7 04 24 31 46 00 00 	movl   $0x4631,(%esp)
    1a5c:	e8 01 1e 00 00       	call   3862 <unlink>
  pid = fork();
    1a61:	e8 a4 1d 00 00       	call   380a <fork>
  if(pid < 0){
    1a66:	83 c4 10             	add    $0x10,%esp
    1a69:	85 c0                	test   %eax,%eax
  pid = fork();
    1a6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1a6e:	0f 88 b6 00 00 00    	js     1b2a <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1a74:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1a78:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1a7d:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1a82:	19 ff                	sbb    %edi,%edi
    1a84:	83 e7 60             	and    $0x60,%edi
    1a87:	83 c7 01             	add    $0x1,%edi
    1a8a:	eb 1e                	jmp    1aaa <linkunlink+0x6a>
    1a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if((x % 3) == 1){
    1a90:	83 fa 01             	cmp    $0x1,%edx
    1a93:	74 7b                	je     1b10 <linkunlink+0xd0>
      unlink("x");
    1a95:	83 ec 0c             	sub    $0xc,%esp
    1a98:	68 31 46 00 00       	push   $0x4631
    1a9d:	e8 c0 1d 00 00       	call   3862 <unlink>
    1aa2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1aa5:	83 eb 01             	sub    $0x1,%ebx
    1aa8:	74 3d                	je     1ae7 <linkunlink+0xa7>
    x = x * 1103515245 + 12345;
    1aaa:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1ab0:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1ab6:	89 f8                	mov    %edi,%eax
    1ab8:	f7 e6                	mul    %esi
    1aba:	d1 ea                	shr    %edx
    1abc:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1abf:	89 fa                	mov    %edi,%edx
    1ac1:	29 c2                	sub    %eax,%edx
    1ac3:	75 cb                	jne    1a90 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1ac5:	83 ec 08             	sub    $0x8,%esp
    1ac8:	68 02 02 00 00       	push   $0x202
    1acd:	68 31 46 00 00       	push   $0x4631
    1ad2:	e8 7b 1d 00 00       	call   3852 <open>
    1ad7:	89 04 24             	mov    %eax,(%esp)
    1ada:	e8 5b 1d 00 00       	call   383a <close>
    1adf:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1ae2:	83 eb 01             	sub    $0x1,%ebx
    1ae5:	75 c3                	jne    1aaa <linkunlink+0x6a>
  if(pid)
    1ae7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1aea:	85 c0                	test   %eax,%eax
    1aec:	74 4f                	je     1b3d <linkunlink+0xfd>
    wait();
    1aee:	e8 27 1d 00 00       	call   381a <wait>
  printf(1, "linkunlink ok\n");
    1af3:	83 ec 08             	sub    $0x8,%esp
    1af6:	68 b9 43 00 00       	push   $0x43b9
    1afb:	6a 01                	push   $0x1
    1afd:	e8 6e 1e 00 00       	call   3970 <printf>
}
    1b02:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b05:	5b                   	pop    %ebx
    1b06:	5e                   	pop    %esi
    1b07:	5f                   	pop    %edi
    1b08:	5d                   	pop    %ebp
    1b09:	c3                   	ret    
    1b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("cat", "x");
    1b10:	83 ec 08             	sub    $0x8,%esp
    1b13:	68 31 46 00 00       	push   $0x4631
    1b18:	68 b5 43 00 00       	push   $0x43b5
    1b1d:	e8 50 1d 00 00       	call   3872 <link>
    1b22:	83 c4 10             	add    $0x10,%esp
    1b25:	e9 7b ff ff ff       	jmp    1aa5 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1b2a:	52                   	push   %edx
    1b2b:	52                   	push   %edx
    1b2c:	68 19 4c 00 00       	push   $0x4c19
    1b31:	6a 01                	push   $0x1
    1b33:	e8 38 1e 00 00       	call   3970 <printf>
    exit();
    1b38:	e8 d5 1c 00 00       	call   3812 <exit>
    exit();
    1b3d:	e8 d0 1c 00 00       	call   3812 <exit>
    1b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001b50 <bigdir>:
{
    1b50:	55                   	push   %ebp
    1b51:	89 e5                	mov    %esp,%ebp
    1b53:	57                   	push   %edi
    1b54:	56                   	push   %esi
    1b55:	53                   	push   %ebx
    1b56:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1b59:	68 c8 43 00 00       	push   $0x43c8
    1b5e:	6a 01                	push   $0x1
    1b60:	e8 0b 1e 00 00       	call   3970 <printf>
  unlink("bd");
    1b65:	c7 04 24 d5 43 00 00 	movl   $0x43d5,(%esp)
    1b6c:	e8 f1 1c 00 00       	call   3862 <unlink>
  fd = open("bd", O_CREATE);
    1b71:	5a                   	pop    %edx
    1b72:	59                   	pop    %ecx
    1b73:	68 00 02 00 00       	push   $0x200
    1b78:	68 d5 43 00 00       	push   $0x43d5
    1b7d:	e8 d0 1c 00 00       	call   3852 <open>
  if(fd < 0){
    1b82:	83 c4 10             	add    $0x10,%esp
    1b85:	85 c0                	test   %eax,%eax
    1b87:	0f 88 de 00 00 00    	js     1c6b <bigdir+0x11b>
  close(fd);
    1b8d:	83 ec 0c             	sub    $0xc,%esp
    1b90:	8d 7d de             	lea    -0x22(%ebp),%edi
  for(i = 0; i < 500; i++){
    1b93:	31 f6                	xor    %esi,%esi
  close(fd);
    1b95:	50                   	push   %eax
    1b96:	e8 9f 1c 00 00       	call   383a <close>
    1b9b:	83 c4 10             	add    $0x10,%esp
    1b9e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + (i / 64);
    1ba0:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1ba2:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1ba5:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1ba9:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1bac:	57                   	push   %edi
    1bad:	68 d5 43 00 00       	push   $0x43d5
    name[1] = '0' + (i / 64);
    1bb2:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1bb5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1bb9:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1bbc:	89 f0                	mov    %esi,%eax
    1bbe:	83 e0 3f             	and    $0x3f,%eax
    1bc1:	83 c0 30             	add    $0x30,%eax
    1bc4:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1bc7:	e8 a6 1c 00 00       	call   3872 <link>
    1bcc:	83 c4 10             	add    $0x10,%esp
    1bcf:	85 c0                	test   %eax,%eax
    1bd1:	89 c3                	mov    %eax,%ebx
    1bd3:	75 6e                	jne    1c43 <bigdir+0xf3>
  for(i = 0; i < 500; i++){
    1bd5:	83 c6 01             	add    $0x1,%esi
    1bd8:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1bde:	75 c0                	jne    1ba0 <bigdir+0x50>
  unlink("bd");
    1be0:	83 ec 0c             	sub    $0xc,%esp
    1be3:	68 d5 43 00 00       	push   $0x43d5
    1be8:	e8 75 1c 00 00       	call   3862 <unlink>
    1bed:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + (i / 64);
    1bf0:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1bf2:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1bf5:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1bf9:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1bfc:	57                   	push   %edi
    name[3] = '\0';
    1bfd:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1c01:	83 c0 30             	add    $0x30,%eax
    1c04:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1c07:	89 d8                	mov    %ebx,%eax
    1c09:	83 e0 3f             	and    $0x3f,%eax
    1c0c:	83 c0 30             	add    $0x30,%eax
    1c0f:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1c12:	e8 4b 1c 00 00       	call   3862 <unlink>
    1c17:	83 c4 10             	add    $0x10,%esp
    1c1a:	85 c0                	test   %eax,%eax
    1c1c:	75 39                	jne    1c57 <bigdir+0x107>
  for(i = 0; i < 500; i++){
    1c1e:	83 c3 01             	add    $0x1,%ebx
    1c21:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1c27:	75 c7                	jne    1bf0 <bigdir+0xa0>
  printf(1, "bigdir ok\n");
    1c29:	83 ec 08             	sub    $0x8,%esp
    1c2c:	68 17 44 00 00       	push   $0x4417
    1c31:	6a 01                	push   $0x1
    1c33:	e8 38 1d 00 00       	call   3970 <printf>
}
    1c38:	83 c4 10             	add    $0x10,%esp
    1c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1c3e:	5b                   	pop    %ebx
    1c3f:	5e                   	pop    %esi
    1c40:	5f                   	pop    %edi
    1c41:	5d                   	pop    %ebp
    1c42:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1c43:	83 ec 08             	sub    $0x8,%esp
    1c46:	68 ee 43 00 00       	push   $0x43ee
    1c4b:	6a 01                	push   $0x1
    1c4d:	e8 1e 1d 00 00       	call   3970 <printf>
      exit();
    1c52:	e8 bb 1b 00 00       	call   3812 <exit>
      printf(1, "bigdir unlink failed");
    1c57:	83 ec 08             	sub    $0x8,%esp
    1c5a:	68 02 44 00 00       	push   $0x4402
    1c5f:	6a 01                	push   $0x1
    1c61:	e8 0a 1d 00 00       	call   3970 <printf>
      exit();
    1c66:	e8 a7 1b 00 00       	call   3812 <exit>
    printf(1, "bigdir create failed\n");
    1c6b:	50                   	push   %eax
    1c6c:	50                   	push   %eax
    1c6d:	68 d8 43 00 00       	push   $0x43d8
    1c72:	6a 01                	push   $0x1
    1c74:	e8 f7 1c 00 00       	call   3970 <printf>
    exit();
    1c79:	e8 94 1b 00 00       	call   3812 <exit>
    1c7e:	66 90                	xchg   %ax,%ax

00001c80 <subdir>:
{
    1c80:	55                   	push   %ebp
    1c81:	89 e5                	mov    %esp,%ebp
    1c83:	53                   	push   %ebx
    1c84:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1c87:	68 22 44 00 00       	push   $0x4422
    1c8c:	6a 01                	push   $0x1
    1c8e:	e8 dd 1c 00 00       	call   3970 <printf>
  unlink("ff");
    1c93:	c7 04 24 ab 44 00 00 	movl   $0x44ab,(%esp)
    1c9a:	e8 c3 1b 00 00       	call   3862 <unlink>
  if(mkdir("dd") != 0){
    1c9f:	c7 04 24 48 45 00 00 	movl   $0x4548,(%esp)
    1ca6:	e8 cf 1b 00 00       	call   387a <mkdir>
    1cab:	83 c4 10             	add    $0x10,%esp
    1cae:	85 c0                	test   %eax,%eax
    1cb0:	0f 85 b3 05 00 00    	jne    2269 <subdir+0x5e9>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1cb6:	83 ec 08             	sub    $0x8,%esp
    1cb9:	68 02 02 00 00       	push   $0x202
    1cbe:	68 81 44 00 00       	push   $0x4481
    1cc3:	e8 8a 1b 00 00       	call   3852 <open>
  if(fd < 0){
    1cc8:	83 c4 10             	add    $0x10,%esp
    1ccb:	85 c0                	test   %eax,%eax
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1ccd:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1ccf:	0f 88 81 05 00 00    	js     2256 <subdir+0x5d6>
  write(fd, "ff", 2);
    1cd5:	83 ec 04             	sub    $0x4,%esp
    1cd8:	6a 02                	push   $0x2
    1cda:	68 ab 44 00 00       	push   $0x44ab
    1cdf:	50                   	push   %eax
    1ce0:	e8 4d 1b 00 00       	call   3832 <write>
  close(fd);
    1ce5:	89 1c 24             	mov    %ebx,(%esp)
    1ce8:	e8 4d 1b 00 00       	call   383a <close>
  if(unlink("dd") >= 0){
    1ced:	c7 04 24 48 45 00 00 	movl   $0x4548,(%esp)
    1cf4:	e8 69 1b 00 00       	call   3862 <unlink>
    1cf9:	83 c4 10             	add    $0x10,%esp
    1cfc:	85 c0                	test   %eax,%eax
    1cfe:	0f 89 3f 05 00 00    	jns    2243 <subdir+0x5c3>
  if(mkdir("/dd/dd") != 0){
    1d04:	83 ec 0c             	sub    $0xc,%esp
    1d07:	68 5c 44 00 00       	push   $0x445c
    1d0c:	e8 69 1b 00 00       	call   387a <mkdir>
    1d11:	83 c4 10             	add    $0x10,%esp
    1d14:	85 c0                	test   %eax,%eax
    1d16:	0f 85 14 05 00 00    	jne    2230 <subdir+0x5b0>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1d1c:	83 ec 08             	sub    $0x8,%esp
    1d1f:	68 02 02 00 00       	push   $0x202
    1d24:	68 7e 44 00 00       	push   $0x447e
    1d29:	e8 24 1b 00 00       	call   3852 <open>
  if(fd < 0){
    1d2e:	83 c4 10             	add    $0x10,%esp
    1d31:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1d33:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d35:	0f 88 24 04 00 00    	js     215f <subdir+0x4df>
  write(fd, "FF", 2);
    1d3b:	83 ec 04             	sub    $0x4,%esp
    1d3e:	6a 02                	push   $0x2
    1d40:	68 9f 44 00 00       	push   $0x449f
    1d45:	50                   	push   %eax
    1d46:	e8 e7 1a 00 00       	call   3832 <write>
  close(fd);
    1d4b:	89 1c 24             	mov    %ebx,(%esp)
    1d4e:	e8 e7 1a 00 00       	call   383a <close>
  fd = open("dd/dd/../ff", 0);
    1d53:	58                   	pop    %eax
    1d54:	5a                   	pop    %edx
    1d55:	6a 00                	push   $0x0
    1d57:	68 a2 44 00 00       	push   $0x44a2
    1d5c:	e8 f1 1a 00 00       	call   3852 <open>
  if(fd < 0){
    1d61:	83 c4 10             	add    $0x10,%esp
    1d64:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/../ff", 0);
    1d66:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d68:	0f 88 de 03 00 00    	js     214c <subdir+0x4cc>
  cc = read(fd, buf, sizeof(buf));
    1d6e:	83 ec 04             	sub    $0x4,%esp
    1d71:	68 00 20 00 00       	push   $0x2000
    1d76:	68 60 85 00 00       	push   $0x8560
    1d7b:	50                   	push   %eax
    1d7c:	e8 a9 1a 00 00       	call   382a <read>
  if(cc != 2 || buf[0] != 'f'){
    1d81:	83 c4 10             	add    $0x10,%esp
    1d84:	83 f8 02             	cmp    $0x2,%eax
    1d87:	0f 85 3a 03 00 00    	jne    20c7 <subdir+0x447>
    1d8d:	80 3d 60 85 00 00 66 	cmpb   $0x66,0x8560
    1d94:	0f 85 2d 03 00 00    	jne    20c7 <subdir+0x447>
  close(fd);
    1d9a:	83 ec 0c             	sub    $0xc,%esp
    1d9d:	53                   	push   %ebx
    1d9e:	e8 97 1a 00 00       	call   383a <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1da3:	5b                   	pop    %ebx
    1da4:	58                   	pop    %eax
    1da5:	68 e2 44 00 00       	push   $0x44e2
    1daa:	68 7e 44 00 00       	push   $0x447e
    1daf:	e8 be 1a 00 00       	call   3872 <link>
    1db4:	83 c4 10             	add    $0x10,%esp
    1db7:	85 c0                	test   %eax,%eax
    1db9:	0f 85 c6 03 00 00    	jne    2185 <subdir+0x505>
  if(unlink("dd/dd/ff") != 0){
    1dbf:	83 ec 0c             	sub    $0xc,%esp
    1dc2:	68 7e 44 00 00       	push   $0x447e
    1dc7:	e8 96 1a 00 00       	call   3862 <unlink>
    1dcc:	83 c4 10             	add    $0x10,%esp
    1dcf:	85 c0                	test   %eax,%eax
    1dd1:	0f 85 16 03 00 00    	jne    20ed <subdir+0x46d>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1dd7:	83 ec 08             	sub    $0x8,%esp
    1dda:	6a 00                	push   $0x0
    1ddc:	68 7e 44 00 00       	push   $0x447e
    1de1:	e8 6c 1a 00 00       	call   3852 <open>
    1de6:	83 c4 10             	add    $0x10,%esp
    1de9:	85 c0                	test   %eax,%eax
    1deb:	0f 89 2c 04 00 00    	jns    221d <subdir+0x59d>
  if(chdir("dd") != 0){
    1df1:	83 ec 0c             	sub    $0xc,%esp
    1df4:	68 48 45 00 00       	push   $0x4548
    1df9:	e8 84 1a 00 00       	call   3882 <chdir>
    1dfe:	83 c4 10             	add    $0x10,%esp
    1e01:	85 c0                	test   %eax,%eax
    1e03:	0f 85 01 04 00 00    	jne    220a <subdir+0x58a>
  if(chdir("dd/../../dd") != 0){
    1e09:	83 ec 0c             	sub    $0xc,%esp
    1e0c:	68 16 45 00 00       	push   $0x4516
    1e11:	e8 6c 1a 00 00       	call   3882 <chdir>
    1e16:	83 c4 10             	add    $0x10,%esp
    1e19:	85 c0                	test   %eax,%eax
    1e1b:	0f 85 b9 02 00 00    	jne    20da <subdir+0x45a>
  if(chdir("dd/../../../dd") != 0){
    1e21:	83 ec 0c             	sub    $0xc,%esp
    1e24:	68 3c 45 00 00       	push   $0x453c
    1e29:	e8 54 1a 00 00       	call   3882 <chdir>
    1e2e:	83 c4 10             	add    $0x10,%esp
    1e31:	85 c0                	test   %eax,%eax
    1e33:	0f 85 a1 02 00 00    	jne    20da <subdir+0x45a>
  if(chdir("./..") != 0){
    1e39:	83 ec 0c             	sub    $0xc,%esp
    1e3c:	68 4b 45 00 00       	push   $0x454b
    1e41:	e8 3c 1a 00 00       	call   3882 <chdir>
    1e46:	83 c4 10             	add    $0x10,%esp
    1e49:	85 c0                	test   %eax,%eax
    1e4b:	0f 85 21 03 00 00    	jne    2172 <subdir+0x4f2>
  fd = open("dd/dd/ffff", 0);
    1e51:	83 ec 08             	sub    $0x8,%esp
    1e54:	6a 00                	push   $0x0
    1e56:	68 e2 44 00 00       	push   $0x44e2
    1e5b:	e8 f2 19 00 00       	call   3852 <open>
  if(fd < 0){
    1e60:	83 c4 10             	add    $0x10,%esp
    1e63:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/ffff", 0);
    1e65:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e67:	0f 88 e0 04 00 00    	js     234d <subdir+0x6cd>
  if(read(fd, buf, sizeof(buf)) != 2){
    1e6d:	83 ec 04             	sub    $0x4,%esp
    1e70:	68 00 20 00 00       	push   $0x2000
    1e75:	68 60 85 00 00       	push   $0x8560
    1e7a:	50                   	push   %eax
    1e7b:	e8 aa 19 00 00       	call   382a <read>
    1e80:	83 c4 10             	add    $0x10,%esp
    1e83:	83 f8 02             	cmp    $0x2,%eax
    1e86:	0f 85 ae 04 00 00    	jne    233a <subdir+0x6ba>
  close(fd);
    1e8c:	83 ec 0c             	sub    $0xc,%esp
    1e8f:	53                   	push   %ebx
    1e90:	e8 a5 19 00 00       	call   383a <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1e95:	59                   	pop    %ecx
    1e96:	5b                   	pop    %ebx
    1e97:	6a 00                	push   $0x0
    1e99:	68 7e 44 00 00       	push   $0x447e
    1e9e:	e8 af 19 00 00       	call   3852 <open>
    1ea3:	83 c4 10             	add    $0x10,%esp
    1ea6:	85 c0                	test   %eax,%eax
    1ea8:	0f 89 65 02 00 00    	jns    2113 <subdir+0x493>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1eae:	83 ec 08             	sub    $0x8,%esp
    1eb1:	68 02 02 00 00       	push   $0x202
    1eb6:	68 96 45 00 00       	push   $0x4596
    1ebb:	e8 92 19 00 00       	call   3852 <open>
    1ec0:	83 c4 10             	add    $0x10,%esp
    1ec3:	85 c0                	test   %eax,%eax
    1ec5:	0f 89 35 02 00 00    	jns    2100 <subdir+0x480>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1ecb:	83 ec 08             	sub    $0x8,%esp
    1ece:	68 02 02 00 00       	push   $0x202
    1ed3:	68 bb 45 00 00       	push   $0x45bb
    1ed8:	e8 75 19 00 00       	call   3852 <open>
    1edd:	83 c4 10             	add    $0x10,%esp
    1ee0:	85 c0                	test   %eax,%eax
    1ee2:	0f 89 0f 03 00 00    	jns    21f7 <subdir+0x577>
  if(open("dd", O_CREATE) >= 0){
    1ee8:	83 ec 08             	sub    $0x8,%esp
    1eeb:	68 00 02 00 00       	push   $0x200
    1ef0:	68 48 45 00 00       	push   $0x4548
    1ef5:	e8 58 19 00 00       	call   3852 <open>
    1efa:	83 c4 10             	add    $0x10,%esp
    1efd:	85 c0                	test   %eax,%eax
    1eff:	0f 89 df 02 00 00    	jns    21e4 <subdir+0x564>
  if(open("dd", O_RDWR) >= 0){
    1f05:	83 ec 08             	sub    $0x8,%esp
    1f08:	6a 02                	push   $0x2
    1f0a:	68 48 45 00 00       	push   $0x4548
    1f0f:	e8 3e 19 00 00       	call   3852 <open>
    1f14:	83 c4 10             	add    $0x10,%esp
    1f17:	85 c0                	test   %eax,%eax
    1f19:	0f 89 b2 02 00 00    	jns    21d1 <subdir+0x551>
  if(open("dd", O_WRONLY) >= 0){
    1f1f:	83 ec 08             	sub    $0x8,%esp
    1f22:	6a 01                	push   $0x1
    1f24:	68 48 45 00 00       	push   $0x4548
    1f29:	e8 24 19 00 00       	call   3852 <open>
    1f2e:	83 c4 10             	add    $0x10,%esp
    1f31:	85 c0                	test   %eax,%eax
    1f33:	0f 89 85 02 00 00    	jns    21be <subdir+0x53e>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1f39:	83 ec 08             	sub    $0x8,%esp
    1f3c:	68 2a 46 00 00       	push   $0x462a
    1f41:	68 96 45 00 00       	push   $0x4596
    1f46:	e8 27 19 00 00       	call   3872 <link>
    1f4b:	83 c4 10             	add    $0x10,%esp
    1f4e:	85 c0                	test   %eax,%eax
    1f50:	0f 84 55 02 00 00    	je     21ab <subdir+0x52b>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1f56:	83 ec 08             	sub    $0x8,%esp
    1f59:	68 2a 46 00 00       	push   $0x462a
    1f5e:	68 bb 45 00 00       	push   $0x45bb
    1f63:	e8 0a 19 00 00       	call   3872 <link>
    1f68:	83 c4 10             	add    $0x10,%esp
    1f6b:	85 c0                	test   %eax,%eax
    1f6d:	0f 84 25 02 00 00    	je     2198 <subdir+0x518>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1f73:	83 ec 08             	sub    $0x8,%esp
    1f76:	68 e2 44 00 00       	push   $0x44e2
    1f7b:	68 81 44 00 00       	push   $0x4481
    1f80:	e8 ed 18 00 00       	call   3872 <link>
    1f85:	83 c4 10             	add    $0x10,%esp
    1f88:	85 c0                	test   %eax,%eax
    1f8a:	0f 84 a9 01 00 00    	je     2139 <subdir+0x4b9>
  if(mkdir("dd/ff/ff") == 0){
    1f90:	83 ec 0c             	sub    $0xc,%esp
    1f93:	68 96 45 00 00       	push   $0x4596
    1f98:	e8 dd 18 00 00       	call   387a <mkdir>
    1f9d:	83 c4 10             	add    $0x10,%esp
    1fa0:	85 c0                	test   %eax,%eax
    1fa2:	0f 84 7e 01 00 00    	je     2126 <subdir+0x4a6>
  if(mkdir("dd/xx/ff") == 0){
    1fa8:	83 ec 0c             	sub    $0xc,%esp
    1fab:	68 bb 45 00 00       	push   $0x45bb
    1fb0:	e8 c5 18 00 00       	call   387a <mkdir>
    1fb5:	83 c4 10             	add    $0x10,%esp
    1fb8:	85 c0                	test   %eax,%eax
    1fba:	0f 84 67 03 00 00    	je     2327 <subdir+0x6a7>
  if(mkdir("dd/dd/ffff") == 0){
    1fc0:	83 ec 0c             	sub    $0xc,%esp
    1fc3:	68 e2 44 00 00       	push   $0x44e2
    1fc8:	e8 ad 18 00 00       	call   387a <mkdir>
    1fcd:	83 c4 10             	add    $0x10,%esp
    1fd0:	85 c0                	test   %eax,%eax
    1fd2:	0f 84 3c 03 00 00    	je     2314 <subdir+0x694>
  if(unlink("dd/xx/ff") == 0){
    1fd8:	83 ec 0c             	sub    $0xc,%esp
    1fdb:	68 bb 45 00 00       	push   $0x45bb
    1fe0:	e8 7d 18 00 00       	call   3862 <unlink>
    1fe5:	83 c4 10             	add    $0x10,%esp
    1fe8:	85 c0                	test   %eax,%eax
    1fea:	0f 84 11 03 00 00    	je     2301 <subdir+0x681>
  if(unlink("dd/ff/ff") == 0){
    1ff0:	83 ec 0c             	sub    $0xc,%esp
    1ff3:	68 96 45 00 00       	push   $0x4596
    1ff8:	e8 65 18 00 00       	call   3862 <unlink>
    1ffd:	83 c4 10             	add    $0x10,%esp
    2000:	85 c0                	test   %eax,%eax
    2002:	0f 84 e6 02 00 00    	je     22ee <subdir+0x66e>
  if(chdir("dd/ff") == 0){
    2008:	83 ec 0c             	sub    $0xc,%esp
    200b:	68 81 44 00 00       	push   $0x4481
    2010:	e8 6d 18 00 00       	call   3882 <chdir>
    2015:	83 c4 10             	add    $0x10,%esp
    2018:	85 c0                	test   %eax,%eax
    201a:	0f 84 bb 02 00 00    	je     22db <subdir+0x65b>
  if(chdir("dd/xx") == 0){
    2020:	83 ec 0c             	sub    $0xc,%esp
    2023:	68 2d 46 00 00       	push   $0x462d
    2028:	e8 55 18 00 00       	call   3882 <chdir>
    202d:	83 c4 10             	add    $0x10,%esp
    2030:	85 c0                	test   %eax,%eax
    2032:	0f 84 90 02 00 00    	je     22c8 <subdir+0x648>
  if(unlink("dd/dd/ffff") != 0){
    2038:	83 ec 0c             	sub    $0xc,%esp
    203b:	68 e2 44 00 00       	push   $0x44e2
    2040:	e8 1d 18 00 00       	call   3862 <unlink>
    2045:	83 c4 10             	add    $0x10,%esp
    2048:	85 c0                	test   %eax,%eax
    204a:	0f 85 9d 00 00 00    	jne    20ed <subdir+0x46d>
  if(unlink("dd/ff") != 0){
    2050:	83 ec 0c             	sub    $0xc,%esp
    2053:	68 81 44 00 00       	push   $0x4481
    2058:	e8 05 18 00 00       	call   3862 <unlink>
    205d:	83 c4 10             	add    $0x10,%esp
    2060:	85 c0                	test   %eax,%eax
    2062:	0f 85 4d 02 00 00    	jne    22b5 <subdir+0x635>
  if(unlink("dd") == 0){
    2068:	83 ec 0c             	sub    $0xc,%esp
    206b:	68 48 45 00 00       	push   $0x4548
    2070:	e8 ed 17 00 00       	call   3862 <unlink>
    2075:	83 c4 10             	add    $0x10,%esp
    2078:	85 c0                	test   %eax,%eax
    207a:	0f 84 22 02 00 00    	je     22a2 <subdir+0x622>
  if(unlink("dd/dd") < 0){
    2080:	83 ec 0c             	sub    $0xc,%esp
    2083:	68 5d 44 00 00       	push   $0x445d
    2088:	e8 d5 17 00 00       	call   3862 <unlink>
    208d:	83 c4 10             	add    $0x10,%esp
    2090:	85 c0                	test   %eax,%eax
    2092:	0f 88 f7 01 00 00    	js     228f <subdir+0x60f>
  if(unlink("dd") < 0){
    2098:	83 ec 0c             	sub    $0xc,%esp
    209b:	68 48 45 00 00       	push   $0x4548
    20a0:	e8 bd 17 00 00       	call   3862 <unlink>
    20a5:	83 c4 10             	add    $0x10,%esp
    20a8:	85 c0                	test   %eax,%eax
    20aa:	0f 88 cc 01 00 00    	js     227c <subdir+0x5fc>
  printf(1, "subdir ok\n");
    20b0:	83 ec 08             	sub    $0x8,%esp
    20b3:	68 2a 47 00 00       	push   $0x472a
    20b8:	6a 01                	push   $0x1
    20ba:	e8 b1 18 00 00       	call   3970 <printf>
}
    20bf:	83 c4 10             	add    $0x10,%esp
    20c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    20c5:	c9                   	leave  
    20c6:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    20c7:	50                   	push   %eax
    20c8:	50                   	push   %eax
    20c9:	68 c7 44 00 00       	push   $0x44c7
    20ce:	6a 01                	push   $0x1
    20d0:	e8 9b 18 00 00       	call   3970 <printf>
    exit();
    20d5:	e8 38 17 00 00       	call   3812 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    20da:	50                   	push   %eax
    20db:	50                   	push   %eax
    20dc:	68 22 45 00 00       	push   $0x4522
    20e1:	6a 01                	push   $0x1
    20e3:	e8 88 18 00 00       	call   3970 <printf>
    exit();
    20e8:	e8 25 17 00 00       	call   3812 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    20ed:	52                   	push   %edx
    20ee:	52                   	push   %edx
    20ef:	68 ed 44 00 00       	push   $0x44ed
    20f4:	6a 01                	push   $0x1
    20f6:	e8 75 18 00 00       	call   3970 <printf>
    exit();
    20fb:	e8 12 17 00 00       	call   3812 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2100:	50                   	push   %eax
    2101:	50                   	push   %eax
    2102:	68 9f 45 00 00       	push   $0x459f
    2107:	6a 01                	push   $0x1
    2109:	e8 62 18 00 00       	call   3970 <printf>
    exit();
    210e:	e8 ff 16 00 00       	call   3812 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2113:	52                   	push   %edx
    2114:	52                   	push   %edx
    2115:	68 84 4f 00 00       	push   $0x4f84
    211a:	6a 01                	push   $0x1
    211c:	e8 4f 18 00 00       	call   3970 <printf>
    exit();
    2121:	e8 ec 16 00 00       	call   3812 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    2126:	52                   	push   %edx
    2127:	52                   	push   %edx
    2128:	68 33 46 00 00       	push   $0x4633
    212d:	6a 01                	push   $0x1
    212f:	e8 3c 18 00 00       	call   3970 <printf>
    exit();
    2134:	e8 d9 16 00 00       	call   3812 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2139:	51                   	push   %ecx
    213a:	51                   	push   %ecx
    213b:	68 f4 4f 00 00       	push   $0x4ff4
    2140:	6a 01                	push   $0x1
    2142:	e8 29 18 00 00       	call   3970 <printf>
    exit();
    2147:	e8 c6 16 00 00       	call   3812 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    214c:	50                   	push   %eax
    214d:	50                   	push   %eax
    214e:	68 ae 44 00 00       	push   $0x44ae
    2153:	6a 01                	push   $0x1
    2155:	e8 16 18 00 00       	call   3970 <printf>
    exit();
    215a:	e8 b3 16 00 00       	call   3812 <exit>
    printf(1, "create dd/dd/ff failed\n");
    215f:	51                   	push   %ecx
    2160:	51                   	push   %ecx
    2161:	68 87 44 00 00       	push   $0x4487
    2166:	6a 01                	push   $0x1
    2168:	e8 03 18 00 00       	call   3970 <printf>
    exit();
    216d:	e8 a0 16 00 00       	call   3812 <exit>
    printf(1, "chdir ./.. failed\n");
    2172:	50                   	push   %eax
    2173:	50                   	push   %eax
    2174:	68 50 45 00 00       	push   $0x4550
    2179:	6a 01                	push   $0x1
    217b:	e8 f0 17 00 00       	call   3970 <printf>
    exit();
    2180:	e8 8d 16 00 00       	call   3812 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2185:	51                   	push   %ecx
    2186:	51                   	push   %ecx
    2187:	68 3c 4f 00 00       	push   $0x4f3c
    218c:	6a 01                	push   $0x1
    218e:	e8 dd 17 00 00       	call   3970 <printf>
    exit();
    2193:	e8 7a 16 00 00       	call   3812 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2198:	53                   	push   %ebx
    2199:	53                   	push   %ebx
    219a:	68 d0 4f 00 00       	push   $0x4fd0
    219f:	6a 01                	push   $0x1
    21a1:	e8 ca 17 00 00       	call   3970 <printf>
    exit();
    21a6:	e8 67 16 00 00       	call   3812 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    21ab:	50                   	push   %eax
    21ac:	50                   	push   %eax
    21ad:	68 ac 4f 00 00       	push   $0x4fac
    21b2:	6a 01                	push   $0x1
    21b4:	e8 b7 17 00 00       	call   3970 <printf>
    exit();
    21b9:	e8 54 16 00 00       	call   3812 <exit>
    printf(1, "open dd wronly succeeded!\n");
    21be:	50                   	push   %eax
    21bf:	50                   	push   %eax
    21c0:	68 0f 46 00 00       	push   $0x460f
    21c5:	6a 01                	push   $0x1
    21c7:	e8 a4 17 00 00       	call   3970 <printf>
    exit();
    21cc:	e8 41 16 00 00       	call   3812 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    21d1:	50                   	push   %eax
    21d2:	50                   	push   %eax
    21d3:	68 f6 45 00 00       	push   $0x45f6
    21d8:	6a 01                	push   $0x1
    21da:	e8 91 17 00 00       	call   3970 <printf>
    exit();
    21df:	e8 2e 16 00 00       	call   3812 <exit>
    printf(1, "create dd succeeded!\n");
    21e4:	50                   	push   %eax
    21e5:	50                   	push   %eax
    21e6:	68 e0 45 00 00       	push   $0x45e0
    21eb:	6a 01                	push   $0x1
    21ed:	e8 7e 17 00 00       	call   3970 <printf>
    exit();
    21f2:	e8 1b 16 00 00       	call   3812 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    21f7:	50                   	push   %eax
    21f8:	50                   	push   %eax
    21f9:	68 c4 45 00 00       	push   $0x45c4
    21fe:	6a 01                	push   $0x1
    2200:	e8 6b 17 00 00       	call   3970 <printf>
    exit();
    2205:	e8 08 16 00 00       	call   3812 <exit>
    printf(1, "chdir dd failed\n");
    220a:	50                   	push   %eax
    220b:	50                   	push   %eax
    220c:	68 05 45 00 00       	push   $0x4505
    2211:	6a 01                	push   $0x1
    2213:	e8 58 17 00 00       	call   3970 <printf>
    exit();
    2218:	e8 f5 15 00 00       	call   3812 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    221d:	50                   	push   %eax
    221e:	50                   	push   %eax
    221f:	68 60 4f 00 00       	push   $0x4f60
    2224:	6a 01                	push   $0x1
    2226:	e8 45 17 00 00       	call   3970 <printf>
    exit();
    222b:	e8 e2 15 00 00       	call   3812 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2230:	53                   	push   %ebx
    2231:	53                   	push   %ebx
    2232:	68 63 44 00 00       	push   $0x4463
    2237:	6a 01                	push   $0x1
    2239:	e8 32 17 00 00       	call   3970 <printf>
    exit();
    223e:	e8 cf 15 00 00       	call   3812 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2243:	50                   	push   %eax
    2244:	50                   	push   %eax
    2245:	68 14 4f 00 00       	push   $0x4f14
    224a:	6a 01                	push   $0x1
    224c:	e8 1f 17 00 00       	call   3970 <printf>
    exit();
    2251:	e8 bc 15 00 00       	call   3812 <exit>
    printf(1, "create dd/ff failed\n");
    2256:	50                   	push   %eax
    2257:	50                   	push   %eax
    2258:	68 47 44 00 00       	push   $0x4447
    225d:	6a 01                	push   $0x1
    225f:	e8 0c 17 00 00       	call   3970 <printf>
    exit();
    2264:	e8 a9 15 00 00       	call   3812 <exit>
    printf(1, "subdir mkdir dd failed\n");
    2269:	50                   	push   %eax
    226a:	50                   	push   %eax
    226b:	68 2f 44 00 00       	push   $0x442f
    2270:	6a 01                	push   $0x1
    2272:	e8 f9 16 00 00       	call   3970 <printf>
    exit();
    2277:	e8 96 15 00 00       	call   3812 <exit>
    printf(1, "unlink dd failed\n");
    227c:	50                   	push   %eax
    227d:	50                   	push   %eax
    227e:	68 18 47 00 00       	push   $0x4718
    2283:	6a 01                	push   $0x1
    2285:	e8 e6 16 00 00       	call   3970 <printf>
    exit();
    228a:	e8 83 15 00 00       	call   3812 <exit>
    printf(1, "unlink dd/dd failed\n");
    228f:	52                   	push   %edx
    2290:	52                   	push   %edx
    2291:	68 03 47 00 00       	push   $0x4703
    2296:	6a 01                	push   $0x1
    2298:	e8 d3 16 00 00       	call   3970 <printf>
    exit();
    229d:	e8 70 15 00 00       	call   3812 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    22a2:	51                   	push   %ecx
    22a3:	51                   	push   %ecx
    22a4:	68 18 50 00 00       	push   $0x5018
    22a9:	6a 01                	push   $0x1
    22ab:	e8 c0 16 00 00       	call   3970 <printf>
    exit();
    22b0:	e8 5d 15 00 00       	call   3812 <exit>
    printf(1, "unlink dd/ff failed\n");
    22b5:	53                   	push   %ebx
    22b6:	53                   	push   %ebx
    22b7:	68 ee 46 00 00       	push   $0x46ee
    22bc:	6a 01                	push   $0x1
    22be:	e8 ad 16 00 00       	call   3970 <printf>
    exit();
    22c3:	e8 4a 15 00 00       	call   3812 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    22c8:	50                   	push   %eax
    22c9:	50                   	push   %eax
    22ca:	68 d6 46 00 00       	push   $0x46d6
    22cf:	6a 01                	push   $0x1
    22d1:	e8 9a 16 00 00       	call   3970 <printf>
    exit();
    22d6:	e8 37 15 00 00       	call   3812 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    22db:	50                   	push   %eax
    22dc:	50                   	push   %eax
    22dd:	68 be 46 00 00       	push   $0x46be
    22e2:	6a 01                	push   $0x1
    22e4:	e8 87 16 00 00       	call   3970 <printf>
    exit();
    22e9:	e8 24 15 00 00       	call   3812 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    22ee:	50                   	push   %eax
    22ef:	50                   	push   %eax
    22f0:	68 a2 46 00 00       	push   $0x46a2
    22f5:	6a 01                	push   $0x1
    22f7:	e8 74 16 00 00       	call   3970 <printf>
    exit();
    22fc:	e8 11 15 00 00       	call   3812 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2301:	50                   	push   %eax
    2302:	50                   	push   %eax
    2303:	68 86 46 00 00       	push   $0x4686
    2308:	6a 01                	push   $0x1
    230a:	e8 61 16 00 00       	call   3970 <printf>
    exit();
    230f:	e8 fe 14 00 00       	call   3812 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2314:	50                   	push   %eax
    2315:	50                   	push   %eax
    2316:	68 69 46 00 00       	push   $0x4669
    231b:	6a 01                	push   $0x1
    231d:	e8 4e 16 00 00       	call   3970 <printf>
    exit();
    2322:	e8 eb 14 00 00       	call   3812 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    2327:	50                   	push   %eax
    2328:	50                   	push   %eax
    2329:	68 4e 46 00 00       	push   $0x464e
    232e:	6a 01                	push   $0x1
    2330:	e8 3b 16 00 00       	call   3970 <printf>
    exit();
    2335:	e8 d8 14 00 00       	call   3812 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    233a:	50                   	push   %eax
    233b:	50                   	push   %eax
    233c:	68 7b 45 00 00       	push   $0x457b
    2341:	6a 01                	push   $0x1
    2343:	e8 28 16 00 00       	call   3970 <printf>
    exit();
    2348:	e8 c5 14 00 00       	call   3812 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    234d:	50                   	push   %eax
    234e:	50                   	push   %eax
    234f:	68 63 45 00 00       	push   $0x4563
    2354:	6a 01                	push   $0x1
    2356:	e8 15 16 00 00       	call   3970 <printf>
    exit();
    235b:	e8 b2 14 00 00       	call   3812 <exit>

00002360 <bigwrite>:
{
    2360:	55                   	push   %ebp
    2361:	89 e5                	mov    %esp,%ebp
    2363:	56                   	push   %esi
    2364:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    2365:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    236a:	83 ec 08             	sub    $0x8,%esp
    236d:	68 35 47 00 00       	push   $0x4735
    2372:	6a 01                	push   $0x1
    2374:	e8 f7 15 00 00       	call   3970 <printf>
  unlink("bigwrite");
    2379:	c7 04 24 44 47 00 00 	movl   $0x4744,(%esp)
    2380:	e8 dd 14 00 00       	call   3862 <unlink>
    2385:	83 c4 10             	add    $0x10,%esp
    2388:	90                   	nop
    2389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2390:	83 ec 08             	sub    $0x8,%esp
    2393:	68 02 02 00 00       	push   $0x202
    2398:	68 44 47 00 00       	push   $0x4744
    239d:	e8 b0 14 00 00       	call   3852 <open>
    if(fd < 0){
    23a2:	83 c4 10             	add    $0x10,%esp
    23a5:	85 c0                	test   %eax,%eax
    fd = open("bigwrite", O_CREATE | O_RDWR);
    23a7:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    23a9:	78 7e                	js     2429 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    23ab:	83 ec 04             	sub    $0x4,%esp
    23ae:	53                   	push   %ebx
    23af:	68 60 85 00 00       	push   $0x8560
    23b4:	50                   	push   %eax
    23b5:	e8 78 14 00 00       	call   3832 <write>
      if(cc != sz){
    23ba:	83 c4 10             	add    $0x10,%esp
    23bd:	39 d8                	cmp    %ebx,%eax
    23bf:	75 55                	jne    2416 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    23c1:	83 ec 04             	sub    $0x4,%esp
    23c4:	53                   	push   %ebx
    23c5:	68 60 85 00 00       	push   $0x8560
    23ca:	56                   	push   %esi
    23cb:	e8 62 14 00 00       	call   3832 <write>
      if(cc != sz){
    23d0:	83 c4 10             	add    $0x10,%esp
    23d3:	39 d8                	cmp    %ebx,%eax
    23d5:	75 3f                	jne    2416 <bigwrite+0xb6>
    close(fd);
    23d7:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    23da:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    23e0:	56                   	push   %esi
    23e1:	e8 54 14 00 00       	call   383a <close>
    unlink("bigwrite");
    23e6:	c7 04 24 44 47 00 00 	movl   $0x4744,(%esp)
    23ed:	e8 70 14 00 00       	call   3862 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    23f2:	83 c4 10             	add    $0x10,%esp
    23f5:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    23fb:	75 93                	jne    2390 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    23fd:	83 ec 08             	sub    $0x8,%esp
    2400:	68 77 47 00 00       	push   $0x4777
    2405:	6a 01                	push   $0x1
    2407:	e8 64 15 00 00       	call   3970 <printf>
}
    240c:	83 c4 10             	add    $0x10,%esp
    240f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2412:	5b                   	pop    %ebx
    2413:	5e                   	pop    %esi
    2414:	5d                   	pop    %ebp
    2415:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    2416:	50                   	push   %eax
    2417:	53                   	push   %ebx
    2418:	68 65 47 00 00       	push   $0x4765
    241d:	6a 01                	push   $0x1
    241f:	e8 4c 15 00 00       	call   3970 <printf>
        exit();
    2424:	e8 e9 13 00 00       	call   3812 <exit>
      printf(1, "cannot create bigwrite\n");
    2429:	83 ec 08             	sub    $0x8,%esp
    242c:	68 4d 47 00 00       	push   $0x474d
    2431:	6a 01                	push   $0x1
    2433:	e8 38 15 00 00       	call   3970 <printf>
      exit();
    2438:	e8 d5 13 00 00       	call   3812 <exit>
    243d:	8d 76 00             	lea    0x0(%esi),%esi

00002440 <bigfile>:
{
    2440:	55                   	push   %ebp
    2441:	89 e5                	mov    %esp,%ebp
    2443:	57                   	push   %edi
    2444:	56                   	push   %esi
    2445:	53                   	push   %ebx
    2446:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    2449:	68 84 47 00 00       	push   $0x4784
    244e:	6a 01                	push   $0x1
    2450:	e8 1b 15 00 00       	call   3970 <printf>
  unlink("bigfile");
    2455:	c7 04 24 a0 47 00 00 	movl   $0x47a0,(%esp)
    245c:	e8 01 14 00 00       	call   3862 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2461:	58                   	pop    %eax
    2462:	5a                   	pop    %edx
    2463:	68 02 02 00 00       	push   $0x202
    2468:	68 a0 47 00 00       	push   $0x47a0
    246d:	e8 e0 13 00 00       	call   3852 <open>
  if(fd < 0){
    2472:	83 c4 10             	add    $0x10,%esp
    2475:	85 c0                	test   %eax,%eax
    2477:	0f 88 5e 01 00 00    	js     25db <bigfile+0x19b>
    247d:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    247f:	31 db                	xor    %ebx,%ebx
    2481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(buf, i, 600);
    2488:	83 ec 04             	sub    $0x4,%esp
    248b:	68 58 02 00 00       	push   $0x258
    2490:	53                   	push   %ebx
    2491:	68 60 85 00 00       	push   $0x8560
    2496:	e8 d5 11 00 00       	call   3670 <memset>
    if(write(fd, buf, 600) != 600){
    249b:	83 c4 0c             	add    $0xc,%esp
    249e:	68 58 02 00 00       	push   $0x258
    24a3:	68 60 85 00 00       	push   $0x8560
    24a8:	56                   	push   %esi
    24a9:	e8 84 13 00 00       	call   3832 <write>
    24ae:	83 c4 10             	add    $0x10,%esp
    24b1:	3d 58 02 00 00       	cmp    $0x258,%eax
    24b6:	0f 85 f8 00 00 00    	jne    25b4 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    24bc:	83 c3 01             	add    $0x1,%ebx
    24bf:	83 fb 14             	cmp    $0x14,%ebx
    24c2:	75 c4                	jne    2488 <bigfile+0x48>
  close(fd);
    24c4:	83 ec 0c             	sub    $0xc,%esp
    24c7:	56                   	push   %esi
    24c8:	e8 6d 13 00 00       	call   383a <close>
  fd = open("bigfile", 0);
    24cd:	5e                   	pop    %esi
    24ce:	5f                   	pop    %edi
    24cf:	6a 00                	push   $0x0
    24d1:	68 a0 47 00 00       	push   $0x47a0
    24d6:	e8 77 13 00 00       	call   3852 <open>
  if(fd < 0){
    24db:	83 c4 10             	add    $0x10,%esp
    24de:	85 c0                	test   %eax,%eax
  fd = open("bigfile", 0);
    24e0:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    24e2:	0f 88 e0 00 00 00    	js     25c8 <bigfile+0x188>
  total = 0;
    24e8:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    24ea:	31 ff                	xor    %edi,%edi
    24ec:	eb 30                	jmp    251e <bigfile+0xde>
    24ee:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    24f0:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    24f5:	0f 85 91 00 00 00    	jne    258c <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    24fb:	0f be 05 60 85 00 00 	movsbl 0x8560,%eax
    2502:	89 fa                	mov    %edi,%edx
    2504:	d1 fa                	sar    %edx
    2506:	39 d0                	cmp    %edx,%eax
    2508:	75 6e                	jne    2578 <bigfile+0x138>
    250a:	0f be 15 8b 86 00 00 	movsbl 0x868b,%edx
    2511:	39 d0                	cmp    %edx,%eax
    2513:	75 63                	jne    2578 <bigfile+0x138>
    total += cc;
    2515:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    251b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    251e:	83 ec 04             	sub    $0x4,%esp
    2521:	68 2c 01 00 00       	push   $0x12c
    2526:	68 60 85 00 00       	push   $0x8560
    252b:	56                   	push   %esi
    252c:	e8 f9 12 00 00       	call   382a <read>
    if(cc < 0){
    2531:	83 c4 10             	add    $0x10,%esp
    2534:	85 c0                	test   %eax,%eax
    2536:	78 68                	js     25a0 <bigfile+0x160>
    if(cc == 0)
    2538:	75 b6                	jne    24f0 <bigfile+0xb0>
  close(fd);
    253a:	83 ec 0c             	sub    $0xc,%esp
    253d:	56                   	push   %esi
    253e:	e8 f7 12 00 00       	call   383a <close>
  if(total != 20*600){
    2543:	83 c4 10             	add    $0x10,%esp
    2546:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    254c:	0f 85 9c 00 00 00    	jne    25ee <bigfile+0x1ae>
  unlink("bigfile");
    2552:	83 ec 0c             	sub    $0xc,%esp
    2555:	68 a0 47 00 00       	push   $0x47a0
    255a:	e8 03 13 00 00       	call   3862 <unlink>
  printf(1, "bigfile test ok\n");
    255f:	58                   	pop    %eax
    2560:	5a                   	pop    %edx
    2561:	68 2f 48 00 00       	push   $0x482f
    2566:	6a 01                	push   $0x1
    2568:	e8 03 14 00 00       	call   3970 <printf>
}
    256d:	83 c4 10             	add    $0x10,%esp
    2570:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2573:	5b                   	pop    %ebx
    2574:	5e                   	pop    %esi
    2575:	5f                   	pop    %edi
    2576:	5d                   	pop    %ebp
    2577:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    2578:	83 ec 08             	sub    $0x8,%esp
    257b:	68 fc 47 00 00       	push   $0x47fc
    2580:	6a 01                	push   $0x1
    2582:	e8 e9 13 00 00       	call   3970 <printf>
      exit();
    2587:	e8 86 12 00 00       	call   3812 <exit>
      printf(1, "short read bigfile\n");
    258c:	83 ec 08             	sub    $0x8,%esp
    258f:	68 e8 47 00 00       	push   $0x47e8
    2594:	6a 01                	push   $0x1
    2596:	e8 d5 13 00 00       	call   3970 <printf>
      exit();
    259b:	e8 72 12 00 00       	call   3812 <exit>
      printf(1, "read bigfile failed\n");
    25a0:	83 ec 08             	sub    $0x8,%esp
    25a3:	68 d3 47 00 00       	push   $0x47d3
    25a8:	6a 01                	push   $0x1
    25aa:	e8 c1 13 00 00       	call   3970 <printf>
      exit();
    25af:	e8 5e 12 00 00       	call   3812 <exit>
      printf(1, "write bigfile failed\n");
    25b4:	83 ec 08             	sub    $0x8,%esp
    25b7:	68 a8 47 00 00       	push   $0x47a8
    25bc:	6a 01                	push   $0x1
    25be:	e8 ad 13 00 00       	call   3970 <printf>
      exit();
    25c3:	e8 4a 12 00 00       	call   3812 <exit>
    printf(1, "cannot open bigfile\n");
    25c8:	53                   	push   %ebx
    25c9:	53                   	push   %ebx
    25ca:	68 be 47 00 00       	push   $0x47be
    25cf:	6a 01                	push   $0x1
    25d1:	e8 9a 13 00 00       	call   3970 <printf>
    exit();
    25d6:	e8 37 12 00 00       	call   3812 <exit>
    printf(1, "cannot create bigfile");
    25db:	50                   	push   %eax
    25dc:	50                   	push   %eax
    25dd:	68 92 47 00 00       	push   $0x4792
    25e2:	6a 01                	push   $0x1
    25e4:	e8 87 13 00 00       	call   3970 <printf>
    exit();
    25e9:	e8 24 12 00 00       	call   3812 <exit>
    printf(1, "read bigfile wrong total\n");
    25ee:	51                   	push   %ecx
    25ef:	51                   	push   %ecx
    25f0:	68 15 48 00 00       	push   $0x4815
    25f5:	6a 01                	push   $0x1
    25f7:	e8 74 13 00 00       	call   3970 <printf>
    exit();
    25fc:	e8 11 12 00 00       	call   3812 <exit>
    2601:	eb 0d                	jmp    2610 <fourteen>
    2603:	90                   	nop
    2604:	90                   	nop
    2605:	90                   	nop
    2606:	90                   	nop
    2607:	90                   	nop
    2608:	90                   	nop
    2609:	90                   	nop
    260a:	90                   	nop
    260b:	90                   	nop
    260c:	90                   	nop
    260d:	90                   	nop
    260e:	90                   	nop
    260f:	90                   	nop

00002610 <fourteen>:
{
    2610:	55                   	push   %ebp
    2611:	89 e5                	mov    %esp,%ebp
    2613:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    2616:	68 40 48 00 00       	push   $0x4840
    261b:	6a 01                	push   $0x1
    261d:	e8 4e 13 00 00       	call   3970 <printf>
  if(mkdir("12345678901234") != 0){
    2622:	c7 04 24 7b 48 00 00 	movl   $0x487b,(%esp)
    2629:	e8 4c 12 00 00       	call   387a <mkdir>
    262e:	83 c4 10             	add    $0x10,%esp
    2631:	85 c0                	test   %eax,%eax
    2633:	0f 85 97 00 00 00    	jne    26d0 <fourteen+0xc0>
  if(mkdir("12345678901234/123456789012345") != 0){
    2639:	83 ec 0c             	sub    $0xc,%esp
    263c:	68 38 50 00 00       	push   $0x5038
    2641:	e8 34 12 00 00       	call   387a <mkdir>
    2646:	83 c4 10             	add    $0x10,%esp
    2649:	85 c0                	test   %eax,%eax
    264b:	0f 85 de 00 00 00    	jne    272f <fourteen+0x11f>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2651:	83 ec 08             	sub    $0x8,%esp
    2654:	68 00 02 00 00       	push   $0x200
    2659:	68 88 50 00 00       	push   $0x5088
    265e:	e8 ef 11 00 00       	call   3852 <open>
  if(fd < 0){
    2663:	83 c4 10             	add    $0x10,%esp
    2666:	85 c0                	test   %eax,%eax
    2668:	0f 88 ae 00 00 00    	js     271c <fourteen+0x10c>
  close(fd);
    266e:	83 ec 0c             	sub    $0xc,%esp
    2671:	50                   	push   %eax
    2672:	e8 c3 11 00 00       	call   383a <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2677:	58                   	pop    %eax
    2678:	5a                   	pop    %edx
    2679:	6a 00                	push   $0x0
    267b:	68 f8 50 00 00       	push   $0x50f8
    2680:	e8 cd 11 00 00       	call   3852 <open>
  if(fd < 0){
    2685:	83 c4 10             	add    $0x10,%esp
    2688:	85 c0                	test   %eax,%eax
    268a:	78 7d                	js     2709 <fourteen+0xf9>
  close(fd);
    268c:	83 ec 0c             	sub    $0xc,%esp
    268f:	50                   	push   %eax
    2690:	e8 a5 11 00 00       	call   383a <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2695:	c7 04 24 6c 48 00 00 	movl   $0x486c,(%esp)
    269c:	e8 d9 11 00 00       	call   387a <mkdir>
    26a1:	83 c4 10             	add    $0x10,%esp
    26a4:	85 c0                	test   %eax,%eax
    26a6:	74 4e                	je     26f6 <fourteen+0xe6>
  if(mkdir("123456789012345/12345678901234") == 0){
    26a8:	83 ec 0c             	sub    $0xc,%esp
    26ab:	68 94 51 00 00       	push   $0x5194
    26b0:	e8 c5 11 00 00       	call   387a <mkdir>
    26b5:	83 c4 10             	add    $0x10,%esp
    26b8:	85 c0                	test   %eax,%eax
    26ba:	74 27                	je     26e3 <fourteen+0xd3>
  printf(1, "fourteen ok\n");
    26bc:	83 ec 08             	sub    $0x8,%esp
    26bf:	68 8a 48 00 00       	push   $0x488a
    26c4:	6a 01                	push   $0x1
    26c6:	e8 a5 12 00 00       	call   3970 <printf>
}
    26cb:	83 c4 10             	add    $0x10,%esp
    26ce:	c9                   	leave  
    26cf:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    26d0:	50                   	push   %eax
    26d1:	50                   	push   %eax
    26d2:	68 4f 48 00 00       	push   $0x484f
    26d7:	6a 01                	push   $0x1
    26d9:	e8 92 12 00 00       	call   3970 <printf>
    exit();
    26de:	e8 2f 11 00 00       	call   3812 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    26e3:	50                   	push   %eax
    26e4:	50                   	push   %eax
    26e5:	68 b4 51 00 00       	push   $0x51b4
    26ea:	6a 01                	push   $0x1
    26ec:	e8 7f 12 00 00       	call   3970 <printf>
    exit();
    26f1:	e8 1c 11 00 00       	call   3812 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    26f6:	52                   	push   %edx
    26f7:	52                   	push   %edx
    26f8:	68 64 51 00 00       	push   $0x5164
    26fd:	6a 01                	push   $0x1
    26ff:	e8 6c 12 00 00       	call   3970 <printf>
    exit();
    2704:	e8 09 11 00 00       	call   3812 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2709:	51                   	push   %ecx
    270a:	51                   	push   %ecx
    270b:	68 28 51 00 00       	push   $0x5128
    2710:	6a 01                	push   $0x1
    2712:	e8 59 12 00 00       	call   3970 <printf>
    exit();
    2717:	e8 f6 10 00 00       	call   3812 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    271c:	51                   	push   %ecx
    271d:	51                   	push   %ecx
    271e:	68 b8 50 00 00       	push   $0x50b8
    2723:	6a 01                	push   $0x1
    2725:	e8 46 12 00 00       	call   3970 <printf>
    exit();
    272a:	e8 e3 10 00 00       	call   3812 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    272f:	50                   	push   %eax
    2730:	50                   	push   %eax
    2731:	68 58 50 00 00       	push   $0x5058
    2736:	6a 01                	push   $0x1
    2738:	e8 33 12 00 00       	call   3970 <printf>
    exit();
    273d:	e8 d0 10 00 00       	call   3812 <exit>
    2742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002750 <rmdot>:
{
    2750:	55                   	push   %ebp
    2751:	89 e5                	mov    %esp,%ebp
    2753:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2756:	68 97 48 00 00       	push   $0x4897
    275b:	6a 01                	push   $0x1
    275d:	e8 0e 12 00 00       	call   3970 <printf>
  if(mkdir("dots") != 0){
    2762:	c7 04 24 a3 48 00 00 	movl   $0x48a3,(%esp)
    2769:	e8 0c 11 00 00       	call   387a <mkdir>
    276e:	83 c4 10             	add    $0x10,%esp
    2771:	85 c0                	test   %eax,%eax
    2773:	0f 85 b0 00 00 00    	jne    2829 <rmdot+0xd9>
  if(chdir("dots") != 0){
    2779:	83 ec 0c             	sub    $0xc,%esp
    277c:	68 a3 48 00 00       	push   $0x48a3
    2781:	e8 fc 10 00 00       	call   3882 <chdir>
    2786:	83 c4 10             	add    $0x10,%esp
    2789:	85 c0                	test   %eax,%eax
    278b:	0f 85 1d 01 00 00    	jne    28ae <rmdot+0x15e>
  if(unlink(".") == 0){
    2791:	83 ec 0c             	sub    $0xc,%esp
    2794:	68 4e 45 00 00       	push   $0x454e
    2799:	e8 c4 10 00 00       	call   3862 <unlink>
    279e:	83 c4 10             	add    $0x10,%esp
    27a1:	85 c0                	test   %eax,%eax
    27a3:	0f 84 f2 00 00 00    	je     289b <rmdot+0x14b>
  if(unlink("..") == 0){
    27a9:	83 ec 0c             	sub    $0xc,%esp
    27ac:	68 4d 45 00 00       	push   $0x454d
    27b1:	e8 ac 10 00 00       	call   3862 <unlink>
    27b6:	83 c4 10             	add    $0x10,%esp
    27b9:	85 c0                	test   %eax,%eax
    27bb:	0f 84 c7 00 00 00    	je     2888 <rmdot+0x138>
  if(chdir("/") != 0){
    27c1:	83 ec 0c             	sub    $0xc,%esp
    27c4:	68 11 3d 00 00       	push   $0x3d11
    27c9:	e8 b4 10 00 00       	call   3882 <chdir>
    27ce:	83 c4 10             	add    $0x10,%esp
    27d1:	85 c0                	test   %eax,%eax
    27d3:	0f 85 9c 00 00 00    	jne    2875 <rmdot+0x125>
  if(unlink("dots/.") == 0){
    27d9:	83 ec 0c             	sub    $0xc,%esp
    27dc:	68 eb 48 00 00       	push   $0x48eb
    27e1:	e8 7c 10 00 00       	call   3862 <unlink>
    27e6:	83 c4 10             	add    $0x10,%esp
    27e9:	85 c0                	test   %eax,%eax
    27eb:	74 75                	je     2862 <rmdot+0x112>
  if(unlink("dots/..") == 0){
    27ed:	83 ec 0c             	sub    $0xc,%esp
    27f0:	68 09 49 00 00       	push   $0x4909
    27f5:	e8 68 10 00 00       	call   3862 <unlink>
    27fa:	83 c4 10             	add    $0x10,%esp
    27fd:	85 c0                	test   %eax,%eax
    27ff:	74 4e                	je     284f <rmdot+0xff>
  if(unlink("dots") != 0){
    2801:	83 ec 0c             	sub    $0xc,%esp
    2804:	68 a3 48 00 00       	push   $0x48a3
    2809:	e8 54 10 00 00       	call   3862 <unlink>
    280e:	83 c4 10             	add    $0x10,%esp
    2811:	85 c0                	test   %eax,%eax
    2813:	75 27                	jne    283c <rmdot+0xec>
  printf(1, "rmdot ok\n");
    2815:	83 ec 08             	sub    $0x8,%esp
    2818:	68 3e 49 00 00       	push   $0x493e
    281d:	6a 01                	push   $0x1
    281f:	e8 4c 11 00 00       	call   3970 <printf>
}
    2824:	83 c4 10             	add    $0x10,%esp
    2827:	c9                   	leave  
    2828:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2829:	50                   	push   %eax
    282a:	50                   	push   %eax
    282b:	68 a8 48 00 00       	push   $0x48a8
    2830:	6a 01                	push   $0x1
    2832:	e8 39 11 00 00       	call   3970 <printf>
    exit();
    2837:	e8 d6 0f 00 00       	call   3812 <exit>
    printf(1, "unlink dots failed!\n");
    283c:	50                   	push   %eax
    283d:	50                   	push   %eax
    283e:	68 29 49 00 00       	push   $0x4929
    2843:	6a 01                	push   $0x1
    2845:	e8 26 11 00 00       	call   3970 <printf>
    exit();
    284a:	e8 c3 0f 00 00       	call   3812 <exit>
    printf(1, "unlink dots/.. worked!\n");
    284f:	52                   	push   %edx
    2850:	52                   	push   %edx
    2851:	68 11 49 00 00       	push   $0x4911
    2856:	6a 01                	push   $0x1
    2858:	e8 13 11 00 00       	call   3970 <printf>
    exit();
    285d:	e8 b0 0f 00 00       	call   3812 <exit>
    printf(1, "unlink dots/. worked!\n");
    2862:	51                   	push   %ecx
    2863:	51                   	push   %ecx
    2864:	68 f2 48 00 00       	push   $0x48f2
    2869:	6a 01                	push   $0x1
    286b:	e8 00 11 00 00       	call   3970 <printf>
    exit();
    2870:	e8 9d 0f 00 00       	call   3812 <exit>
    printf(1, "chdir / failed\n");
    2875:	50                   	push   %eax
    2876:	50                   	push   %eax
    2877:	68 13 3d 00 00       	push   $0x3d13
    287c:	6a 01                	push   $0x1
    287e:	e8 ed 10 00 00       	call   3970 <printf>
    exit();
    2883:	e8 8a 0f 00 00       	call   3812 <exit>
    printf(1, "rm .. worked!\n");
    2888:	50                   	push   %eax
    2889:	50                   	push   %eax
    288a:	68 dc 48 00 00       	push   $0x48dc
    288f:	6a 01                	push   $0x1
    2891:	e8 da 10 00 00       	call   3970 <printf>
    exit();
    2896:	e8 77 0f 00 00       	call   3812 <exit>
    printf(1, "rm . worked!\n");
    289b:	50                   	push   %eax
    289c:	50                   	push   %eax
    289d:	68 ce 48 00 00       	push   $0x48ce
    28a2:	6a 01                	push   $0x1
    28a4:	e8 c7 10 00 00       	call   3970 <printf>
    exit();
    28a9:	e8 64 0f 00 00       	call   3812 <exit>
    printf(1, "chdir dots failed\n");
    28ae:	50                   	push   %eax
    28af:	50                   	push   %eax
    28b0:	68 bb 48 00 00       	push   $0x48bb
    28b5:	6a 01                	push   $0x1
    28b7:	e8 b4 10 00 00       	call   3970 <printf>
    exit();
    28bc:	e8 51 0f 00 00       	call   3812 <exit>
    28c1:	eb 0d                	jmp    28d0 <dirfile>
    28c3:	90                   	nop
    28c4:	90                   	nop
    28c5:	90                   	nop
    28c6:	90                   	nop
    28c7:	90                   	nop
    28c8:	90                   	nop
    28c9:	90                   	nop
    28ca:	90                   	nop
    28cb:	90                   	nop
    28cc:	90                   	nop
    28cd:	90                   	nop
    28ce:	90                   	nop
    28cf:	90                   	nop

000028d0 <dirfile>:
{
    28d0:	55                   	push   %ebp
    28d1:	89 e5                	mov    %esp,%ebp
    28d3:	53                   	push   %ebx
    28d4:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    28d7:	68 48 49 00 00       	push   $0x4948
    28dc:	6a 01                	push   $0x1
    28de:	e8 8d 10 00 00       	call   3970 <printf>
  fd = open("dirfile", O_CREATE);
    28e3:	59                   	pop    %ecx
    28e4:	5b                   	pop    %ebx
    28e5:	68 00 02 00 00       	push   $0x200
    28ea:	68 55 49 00 00       	push   $0x4955
    28ef:	e8 5e 0f 00 00       	call   3852 <open>
  if(fd < 0){
    28f4:	83 c4 10             	add    $0x10,%esp
    28f7:	85 c0                	test   %eax,%eax
    28f9:	0f 88 43 01 00 00    	js     2a42 <dirfile+0x172>
  close(fd);
    28ff:	83 ec 0c             	sub    $0xc,%esp
    2902:	50                   	push   %eax
    2903:	e8 32 0f 00 00       	call   383a <close>
  if(chdir("dirfile") == 0){
    2908:	c7 04 24 55 49 00 00 	movl   $0x4955,(%esp)
    290f:	e8 6e 0f 00 00       	call   3882 <chdir>
    2914:	83 c4 10             	add    $0x10,%esp
    2917:	85 c0                	test   %eax,%eax
    2919:	0f 84 10 01 00 00    	je     2a2f <dirfile+0x15f>
  fd = open("dirfile/xx", 0);
    291f:	83 ec 08             	sub    $0x8,%esp
    2922:	6a 00                	push   $0x0
    2924:	68 8e 49 00 00       	push   $0x498e
    2929:	e8 24 0f 00 00       	call   3852 <open>
  if(fd >= 0){
    292e:	83 c4 10             	add    $0x10,%esp
    2931:	85 c0                	test   %eax,%eax
    2933:	0f 89 e3 00 00 00    	jns    2a1c <dirfile+0x14c>
  fd = open("dirfile/xx", O_CREATE);
    2939:	83 ec 08             	sub    $0x8,%esp
    293c:	68 00 02 00 00       	push   $0x200
    2941:	68 8e 49 00 00       	push   $0x498e
    2946:	e8 07 0f 00 00       	call   3852 <open>
  if(fd >= 0){
    294b:	83 c4 10             	add    $0x10,%esp
    294e:	85 c0                	test   %eax,%eax
    2950:	0f 89 c6 00 00 00    	jns    2a1c <dirfile+0x14c>
  if(mkdir("dirfile/xx") == 0){
    2956:	83 ec 0c             	sub    $0xc,%esp
    2959:	68 8e 49 00 00       	push   $0x498e
    295e:	e8 17 0f 00 00       	call   387a <mkdir>
    2963:	83 c4 10             	add    $0x10,%esp
    2966:	85 c0                	test   %eax,%eax
    2968:	0f 84 46 01 00 00    	je     2ab4 <dirfile+0x1e4>
  if(unlink("dirfile/xx") == 0){
    296e:	83 ec 0c             	sub    $0xc,%esp
    2971:	68 8e 49 00 00       	push   $0x498e
    2976:	e8 e7 0e 00 00       	call   3862 <unlink>
    297b:	83 c4 10             	add    $0x10,%esp
    297e:	85 c0                	test   %eax,%eax
    2980:	0f 84 1b 01 00 00    	je     2aa1 <dirfile+0x1d1>
  if(link("README", "dirfile/xx") == 0){
    2986:	83 ec 08             	sub    $0x8,%esp
    2989:	68 8e 49 00 00       	push   $0x498e
    298e:	68 f2 49 00 00       	push   $0x49f2
    2993:	e8 da 0e 00 00       	call   3872 <link>
    2998:	83 c4 10             	add    $0x10,%esp
    299b:	85 c0                	test   %eax,%eax
    299d:	0f 84 eb 00 00 00    	je     2a8e <dirfile+0x1be>
  if(unlink("dirfile") != 0){
    29a3:	83 ec 0c             	sub    $0xc,%esp
    29a6:	68 55 49 00 00       	push   $0x4955
    29ab:	e8 b2 0e 00 00       	call   3862 <unlink>
    29b0:	83 c4 10             	add    $0x10,%esp
    29b3:	85 c0                	test   %eax,%eax
    29b5:	0f 85 c0 00 00 00    	jne    2a7b <dirfile+0x1ab>
  fd = open(".", O_RDWR);
    29bb:	83 ec 08             	sub    $0x8,%esp
    29be:	6a 02                	push   $0x2
    29c0:	68 4e 45 00 00       	push   $0x454e
    29c5:	e8 88 0e 00 00       	call   3852 <open>
  if(fd >= 0){
    29ca:	83 c4 10             	add    $0x10,%esp
    29cd:	85 c0                	test   %eax,%eax
    29cf:	0f 89 93 00 00 00    	jns    2a68 <dirfile+0x198>
  fd = open(".", 0);
    29d5:	83 ec 08             	sub    $0x8,%esp
    29d8:	6a 00                	push   $0x0
    29da:	68 4e 45 00 00       	push   $0x454e
    29df:	e8 6e 0e 00 00       	call   3852 <open>
  if(write(fd, "x", 1) > 0){
    29e4:	83 c4 0c             	add    $0xc,%esp
  fd = open(".", 0);
    29e7:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    29e9:	6a 01                	push   $0x1
    29eb:	68 31 46 00 00       	push   $0x4631
    29f0:	50                   	push   %eax
    29f1:	e8 3c 0e 00 00       	call   3832 <write>
    29f6:	83 c4 10             	add    $0x10,%esp
    29f9:	85 c0                	test   %eax,%eax
    29fb:	7f 58                	jg     2a55 <dirfile+0x185>
  close(fd);
    29fd:	83 ec 0c             	sub    $0xc,%esp
    2a00:	53                   	push   %ebx
    2a01:	e8 34 0e 00 00       	call   383a <close>
  printf(1, "dir vs file OK\n");
    2a06:	58                   	pop    %eax
    2a07:	5a                   	pop    %edx
    2a08:	68 25 4a 00 00       	push   $0x4a25
    2a0d:	6a 01                	push   $0x1
    2a0f:	e8 5c 0f 00 00       	call   3970 <printf>
}
    2a14:	83 c4 10             	add    $0x10,%esp
    2a17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2a1a:	c9                   	leave  
    2a1b:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2a1c:	50                   	push   %eax
    2a1d:	50                   	push   %eax
    2a1e:	68 99 49 00 00       	push   $0x4999
    2a23:	6a 01                	push   $0x1
    2a25:	e8 46 0f 00 00       	call   3970 <printf>
    exit();
    2a2a:	e8 e3 0d 00 00       	call   3812 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2a2f:	50                   	push   %eax
    2a30:	50                   	push   %eax
    2a31:	68 74 49 00 00       	push   $0x4974
    2a36:	6a 01                	push   $0x1
    2a38:	e8 33 0f 00 00       	call   3970 <printf>
    exit();
    2a3d:	e8 d0 0d 00 00       	call   3812 <exit>
    printf(1, "create dirfile failed\n");
    2a42:	52                   	push   %edx
    2a43:	52                   	push   %edx
    2a44:	68 5d 49 00 00       	push   $0x495d
    2a49:	6a 01                	push   $0x1
    2a4b:	e8 20 0f 00 00       	call   3970 <printf>
    exit();
    2a50:	e8 bd 0d 00 00       	call   3812 <exit>
    printf(1, "write . succeeded!\n");
    2a55:	51                   	push   %ecx
    2a56:	51                   	push   %ecx
    2a57:	68 11 4a 00 00       	push   $0x4a11
    2a5c:	6a 01                	push   $0x1
    2a5e:	e8 0d 0f 00 00       	call   3970 <printf>
    exit();
    2a63:	e8 aa 0d 00 00       	call   3812 <exit>
    printf(1, "open . for writing succeeded!\n");
    2a68:	53                   	push   %ebx
    2a69:	53                   	push   %ebx
    2a6a:	68 08 52 00 00       	push   $0x5208
    2a6f:	6a 01                	push   $0x1
    2a71:	e8 fa 0e 00 00       	call   3970 <printf>
    exit();
    2a76:	e8 97 0d 00 00       	call   3812 <exit>
    printf(1, "unlink dirfile failed!\n");
    2a7b:	50                   	push   %eax
    2a7c:	50                   	push   %eax
    2a7d:	68 f9 49 00 00       	push   $0x49f9
    2a82:	6a 01                	push   $0x1
    2a84:	e8 e7 0e 00 00       	call   3970 <printf>
    exit();
    2a89:	e8 84 0d 00 00       	call   3812 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2a8e:	50                   	push   %eax
    2a8f:	50                   	push   %eax
    2a90:	68 e8 51 00 00       	push   $0x51e8
    2a95:	6a 01                	push   $0x1
    2a97:	e8 d4 0e 00 00       	call   3970 <printf>
    exit();
    2a9c:	e8 71 0d 00 00       	call   3812 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2aa1:	50                   	push   %eax
    2aa2:	50                   	push   %eax
    2aa3:	68 d4 49 00 00       	push   $0x49d4
    2aa8:	6a 01                	push   $0x1
    2aaa:	e8 c1 0e 00 00       	call   3970 <printf>
    exit();
    2aaf:	e8 5e 0d 00 00       	call   3812 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2ab4:	50                   	push   %eax
    2ab5:	50                   	push   %eax
    2ab6:	68 b7 49 00 00       	push   $0x49b7
    2abb:	6a 01                	push   $0x1
    2abd:	e8 ae 0e 00 00       	call   3970 <printf>
    exit();
    2ac2:	e8 4b 0d 00 00       	call   3812 <exit>
    2ac7:	89 f6                	mov    %esi,%esi
    2ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002ad0 <iref>:
{
    2ad0:	55                   	push   %ebp
    2ad1:	89 e5                	mov    %esp,%ebp
    2ad3:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2ad4:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2ad9:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2adc:	68 35 4a 00 00       	push   $0x4a35
    2ae1:	6a 01                	push   $0x1
    2ae3:	e8 88 0e 00 00       	call   3970 <printf>
    2ae8:	83 c4 10             	add    $0x10,%esp
    2aeb:	90                   	nop
    2aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mkdir("irefd") != 0){
    2af0:	83 ec 0c             	sub    $0xc,%esp
    2af3:	68 46 4a 00 00       	push   $0x4a46
    2af8:	e8 7d 0d 00 00       	call   387a <mkdir>
    2afd:	83 c4 10             	add    $0x10,%esp
    2b00:	85 c0                	test   %eax,%eax
    2b02:	0f 85 bb 00 00 00    	jne    2bc3 <iref+0xf3>
    if(chdir("irefd") != 0){
    2b08:	83 ec 0c             	sub    $0xc,%esp
    2b0b:	68 46 4a 00 00       	push   $0x4a46
    2b10:	e8 6d 0d 00 00       	call   3882 <chdir>
    2b15:	83 c4 10             	add    $0x10,%esp
    2b18:	85 c0                	test   %eax,%eax
    2b1a:	0f 85 b7 00 00 00    	jne    2bd7 <iref+0x107>
    mkdir("");
    2b20:	83 ec 0c             	sub    $0xc,%esp
    2b23:	68 eb 40 00 00       	push   $0x40eb
    2b28:	e8 4d 0d 00 00       	call   387a <mkdir>
    link("README", "");
    2b2d:	59                   	pop    %ecx
    2b2e:	58                   	pop    %eax
    2b2f:	68 eb 40 00 00       	push   $0x40eb
    2b34:	68 f2 49 00 00       	push   $0x49f2
    2b39:	e8 34 0d 00 00       	call   3872 <link>
    fd = open("", O_CREATE);
    2b3e:	58                   	pop    %eax
    2b3f:	5a                   	pop    %edx
    2b40:	68 00 02 00 00       	push   $0x200
    2b45:	68 eb 40 00 00       	push   $0x40eb
    2b4a:	e8 03 0d 00 00       	call   3852 <open>
    if(fd >= 0)
    2b4f:	83 c4 10             	add    $0x10,%esp
    2b52:	85 c0                	test   %eax,%eax
    2b54:	78 0c                	js     2b62 <iref+0x92>
      close(fd);
    2b56:	83 ec 0c             	sub    $0xc,%esp
    2b59:	50                   	push   %eax
    2b5a:	e8 db 0c 00 00       	call   383a <close>
    2b5f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2b62:	83 ec 08             	sub    $0x8,%esp
    2b65:	68 00 02 00 00       	push   $0x200
    2b6a:	68 30 46 00 00       	push   $0x4630
    2b6f:	e8 de 0c 00 00       	call   3852 <open>
    if(fd >= 0)
    2b74:	83 c4 10             	add    $0x10,%esp
    2b77:	85 c0                	test   %eax,%eax
    2b79:	78 0c                	js     2b87 <iref+0xb7>
      close(fd);
    2b7b:	83 ec 0c             	sub    $0xc,%esp
    2b7e:	50                   	push   %eax
    2b7f:	e8 b6 0c 00 00       	call   383a <close>
    2b84:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2b87:	83 ec 0c             	sub    $0xc,%esp
    2b8a:	68 30 46 00 00       	push   $0x4630
    2b8f:	e8 ce 0c 00 00       	call   3862 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2b94:	83 c4 10             	add    $0x10,%esp
    2b97:	83 eb 01             	sub    $0x1,%ebx
    2b9a:	0f 85 50 ff ff ff    	jne    2af0 <iref+0x20>
  chdir("/");
    2ba0:	83 ec 0c             	sub    $0xc,%esp
    2ba3:	68 11 3d 00 00       	push   $0x3d11
    2ba8:	e8 d5 0c 00 00       	call   3882 <chdir>
  printf(1, "empty file name OK\n");
    2bad:	58                   	pop    %eax
    2bae:	5a                   	pop    %edx
    2baf:	68 74 4a 00 00       	push   $0x4a74
    2bb4:	6a 01                	push   $0x1
    2bb6:	e8 b5 0d 00 00       	call   3970 <printf>
}
    2bbb:	83 c4 10             	add    $0x10,%esp
    2bbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2bc1:	c9                   	leave  
    2bc2:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2bc3:	83 ec 08             	sub    $0x8,%esp
    2bc6:	68 4c 4a 00 00       	push   $0x4a4c
    2bcb:	6a 01                	push   $0x1
    2bcd:	e8 9e 0d 00 00       	call   3970 <printf>
      exit();
    2bd2:	e8 3b 0c 00 00       	call   3812 <exit>
      printf(1, "chdir irefd failed\n");
    2bd7:	83 ec 08             	sub    $0x8,%esp
    2bda:	68 60 4a 00 00       	push   $0x4a60
    2bdf:	6a 01                	push   $0x1
    2be1:	e8 8a 0d 00 00       	call   3970 <printf>
      exit();
    2be6:	e8 27 0c 00 00       	call   3812 <exit>
    2beb:	90                   	nop
    2bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002bf0 <forktest>:
{
    2bf0:	55                   	push   %ebp
    2bf1:	89 e5                	mov    %esp,%ebp
    2bf3:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2bf4:	31 db                	xor    %ebx,%ebx
{
    2bf6:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2bf9:	68 88 4a 00 00       	push   $0x4a88
    2bfe:	6a 01                	push   $0x1
    2c00:	e8 6b 0d 00 00       	call   3970 <printf>
    2c05:	83 c4 10             	add    $0x10,%esp
    2c08:	eb 13                	jmp    2c1d <forktest+0x2d>
    2c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pid == 0)
    2c10:	74 62                	je     2c74 <forktest+0x84>
  for(n=0; n<1000; n++){
    2c12:	83 c3 01             	add    $0x1,%ebx
    2c15:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2c1b:	74 43                	je     2c60 <forktest+0x70>
    pid = fork();
    2c1d:	e8 e8 0b 00 00       	call   380a <fork>
    if(pid < 0)
    2c22:	85 c0                	test   %eax,%eax
    2c24:	79 ea                	jns    2c10 <forktest+0x20>
  for(; n > 0; n--){
    2c26:	85 db                	test   %ebx,%ebx
    2c28:	74 14                	je     2c3e <forktest+0x4e>
    2c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2c30:	e8 e5 0b 00 00       	call   381a <wait>
    2c35:	85 c0                	test   %eax,%eax
    2c37:	78 40                	js     2c79 <forktest+0x89>
  for(; n > 0; n--){
    2c39:	83 eb 01             	sub    $0x1,%ebx
    2c3c:	75 f2                	jne    2c30 <forktest+0x40>
  if(wait() != -1){
    2c3e:	e8 d7 0b 00 00       	call   381a <wait>
    2c43:	83 f8 ff             	cmp    $0xffffffff,%eax
    2c46:	75 45                	jne    2c8d <forktest+0x9d>
  printf(1, "fork test OK\n");
    2c48:	83 ec 08             	sub    $0x8,%esp
    2c4b:	68 ba 4a 00 00       	push   $0x4aba
    2c50:	6a 01                	push   $0x1
    2c52:	e8 19 0d 00 00       	call   3970 <printf>
}
    2c57:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2c5a:	c9                   	leave  
    2c5b:	c3                   	ret    
    2c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "fork claimed to work 1000 times!\n");
    2c60:	83 ec 08             	sub    $0x8,%esp
    2c63:	68 28 52 00 00       	push   $0x5228
    2c68:	6a 01                	push   $0x1
    2c6a:	e8 01 0d 00 00       	call   3970 <printf>
    exit();
    2c6f:	e8 9e 0b 00 00       	call   3812 <exit>
      exit();
    2c74:	e8 99 0b 00 00       	call   3812 <exit>
      printf(1, "wait stopped early\n");
    2c79:	83 ec 08             	sub    $0x8,%esp
    2c7c:	68 93 4a 00 00       	push   $0x4a93
    2c81:	6a 01                	push   $0x1
    2c83:	e8 e8 0c 00 00       	call   3970 <printf>
      exit();
    2c88:	e8 85 0b 00 00       	call   3812 <exit>
    printf(1, "wait got too many\n");
    2c8d:	50                   	push   %eax
    2c8e:	50                   	push   %eax
    2c8f:	68 a7 4a 00 00       	push   $0x4aa7
    2c94:	6a 01                	push   $0x1
    2c96:	e8 d5 0c 00 00       	call   3970 <printf>
    exit();
    2c9b:	e8 72 0b 00 00       	call   3812 <exit>

00002ca0 <sbrktest>:
{
    2ca0:	55                   	push   %ebp
    2ca1:	89 e5                	mov    %esp,%ebp
    2ca3:	57                   	push   %edi
    2ca4:	56                   	push   %esi
    2ca5:	53                   	push   %ebx
  for(i = 0; i < 5000; i++){
    2ca6:	31 ff                	xor    %edi,%edi
{
    2ca8:	83 ec 64             	sub    $0x64,%esp
  printf(stdout, "sbrk test\n");
    2cab:	68 c8 4a 00 00       	push   $0x4ac8
    2cb0:	ff 35 88 5d 00 00    	pushl  0x5d88
    2cb6:	e8 b5 0c 00 00       	call   3970 <printf>
  oldbrk = sbrk(0);
    2cbb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2cc2:	e8 d3 0b 00 00       	call   389a <sbrk>
  a = sbrk(0);
    2cc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2cce:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2cd0:	e8 c5 0b 00 00       	call   389a <sbrk>
    2cd5:	83 c4 10             	add    $0x10,%esp
    2cd8:	89 c6                	mov    %eax,%esi
    2cda:	eb 06                	jmp    2ce2 <sbrktest+0x42>
    2cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    a = b + 1;
    2ce0:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2ce2:	83 ec 0c             	sub    $0xc,%esp
    2ce5:	6a 01                	push   $0x1
    2ce7:	e8 ae 0b 00 00       	call   389a <sbrk>
    if(b != a){
    2cec:	83 c4 10             	add    $0x10,%esp
    2cef:	39 f0                	cmp    %esi,%eax
    2cf1:	0f 85 62 02 00 00    	jne    2f59 <sbrktest+0x2b9>
  for(i = 0; i < 5000; i++){
    2cf7:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2cfa:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2cfd:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2d00:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2d06:	75 d8                	jne    2ce0 <sbrktest+0x40>
  pid = fork();
    2d08:	e8 fd 0a 00 00       	call   380a <fork>
  if(pid < 0){
    2d0d:	85 c0                	test   %eax,%eax
  pid = fork();
    2d0f:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2d11:	0f 88 82 03 00 00    	js     3099 <sbrktest+0x3f9>
  c = sbrk(1);
    2d17:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2d1a:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2d1d:	6a 01                	push   $0x1
    2d1f:	e8 76 0b 00 00       	call   389a <sbrk>
  c = sbrk(1);
    2d24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2d2b:	e8 6a 0b 00 00       	call   389a <sbrk>
  if(c != a + 1){
    2d30:	83 c4 10             	add    $0x10,%esp
    2d33:	39 f0                	cmp    %esi,%eax
    2d35:	0f 85 47 03 00 00    	jne    3082 <sbrktest+0x3e2>
  if(pid == 0)
    2d3b:	85 ff                	test   %edi,%edi
    2d3d:	0f 84 3a 03 00 00    	je     307d <sbrktest+0x3dd>
  wait();
    2d43:	e8 d2 0a 00 00       	call   381a <wait>
  a = sbrk(0);
    2d48:	83 ec 0c             	sub    $0xc,%esp
    2d4b:	6a 00                	push   $0x0
    2d4d:	e8 48 0b 00 00       	call   389a <sbrk>
    2d52:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2d54:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2d59:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2d5b:	89 04 24             	mov    %eax,(%esp)
    2d5e:	e8 37 0b 00 00       	call   389a <sbrk>
  if (p != a) {
    2d63:	83 c4 10             	add    $0x10,%esp
    2d66:	39 c6                	cmp    %eax,%esi
    2d68:	0f 85 f8 02 00 00    	jne    3066 <sbrktest+0x3c6>
  a = sbrk(0);
    2d6e:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2d71:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2d78:	6a 00                	push   $0x0
    2d7a:	e8 1b 0b 00 00       	call   389a <sbrk>
  c = sbrk(-4096);
    2d7f:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2d86:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2d88:	e8 0d 0b 00 00       	call   389a <sbrk>
  if(c == (char*)0xffffffff){
    2d8d:	83 c4 10             	add    $0x10,%esp
    2d90:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d93:	0f 84 b6 02 00 00    	je     304f <sbrktest+0x3af>
  c = sbrk(0);
    2d99:	83 ec 0c             	sub    $0xc,%esp
    2d9c:	6a 00                	push   $0x0
    2d9e:	e8 f7 0a 00 00       	call   389a <sbrk>
  if(c != a - 4096){
    2da3:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2da9:	83 c4 10             	add    $0x10,%esp
    2dac:	39 d0                	cmp    %edx,%eax
    2dae:	0f 85 84 02 00 00    	jne    3038 <sbrktest+0x398>
  a = sbrk(0);
    2db4:	83 ec 0c             	sub    $0xc,%esp
    2db7:	6a 00                	push   $0x0
    2db9:	e8 dc 0a 00 00       	call   389a <sbrk>
    2dbe:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2dc0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2dc7:	e8 ce 0a 00 00       	call   389a <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2dcc:	83 c4 10             	add    $0x10,%esp
    2dcf:	39 c6                	cmp    %eax,%esi
  c = sbrk(4096);
    2dd1:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2dd3:	0f 85 48 02 00 00    	jne    3021 <sbrktest+0x381>
    2dd9:	83 ec 0c             	sub    $0xc,%esp
    2ddc:	6a 00                	push   $0x0
    2dde:	e8 b7 0a 00 00       	call   389a <sbrk>
    2de3:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2de9:	83 c4 10             	add    $0x10,%esp
    2dec:	39 d0                	cmp    %edx,%eax
    2dee:	0f 85 2d 02 00 00    	jne    3021 <sbrktest+0x381>
  if(*lastaddr == 99){
    2df4:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2dfb:	0f 84 09 02 00 00    	je     300a <sbrktest+0x36a>
  a = sbrk(0);
    2e01:	83 ec 0c             	sub    $0xc,%esp
    2e04:	6a 00                	push   $0x0
    2e06:	e8 8f 0a 00 00       	call   389a <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2e0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2e12:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2e14:	e8 81 0a 00 00       	call   389a <sbrk>
    2e19:	89 d9                	mov    %ebx,%ecx
    2e1b:	29 c1                	sub    %eax,%ecx
    2e1d:	89 0c 24             	mov    %ecx,(%esp)
    2e20:	e8 75 0a 00 00       	call   389a <sbrk>
  if(c != a){
    2e25:	83 c4 10             	add    $0x10,%esp
    2e28:	39 c6                	cmp    %eax,%esi
    2e2a:	0f 85 c3 01 00 00    	jne    2ff3 <sbrktest+0x353>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2e30:	be 00 00 00 80       	mov    $0x80000000,%esi
    ppid = getpid();
    2e35:	e8 58 0a 00 00       	call   3892 <getpid>
    2e3a:	89 c7                	mov    %eax,%edi
    pid = fork();
    2e3c:	e8 c9 09 00 00       	call   380a <fork>
    if(pid < 0){
    2e41:	85 c0                	test   %eax,%eax
    2e43:	0f 88 93 01 00 00    	js     2fdc <sbrktest+0x33c>
    if(pid == 0){
    2e49:	0f 84 6b 01 00 00    	je     2fba <sbrktest+0x31a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2e4f:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    wait();
    2e55:	e8 c0 09 00 00       	call   381a <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2e5a:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2e60:	75 d3                	jne    2e35 <sbrktest+0x195>
  if(pipe(fds) != 0){
    2e62:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2e65:	83 ec 0c             	sub    $0xc,%esp
    2e68:	50                   	push   %eax
    2e69:	e8 b4 09 00 00       	call   3822 <pipe>
    2e6e:	83 c4 10             	add    $0x10,%esp
    2e71:	85 c0                	test   %eax,%eax
    2e73:	0f 85 2e 01 00 00    	jne    2fa7 <sbrktest+0x307>
    2e79:	8d 7d c0             	lea    -0x40(%ebp),%edi
    2e7c:	89 fe                	mov    %edi,%esi
    2e7e:	eb 23                	jmp    2ea3 <sbrktest+0x203>
    if(pids[i] != -1)
    2e80:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e83:	74 14                	je     2e99 <sbrktest+0x1f9>
      read(fds[0], &scratch, 1);
    2e85:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2e88:	83 ec 04             	sub    $0x4,%esp
    2e8b:	6a 01                	push   $0x1
    2e8d:	50                   	push   %eax
    2e8e:	ff 75 b8             	pushl  -0x48(%ebp)
    2e91:	e8 94 09 00 00       	call   382a <read>
    2e96:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2e99:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2e9c:	83 c6 04             	add    $0x4,%esi
    2e9f:	39 c6                	cmp    %eax,%esi
    2ea1:	74 4f                	je     2ef2 <sbrktest+0x252>
    if((pids[i] = fork()) == 0){
    2ea3:	e8 62 09 00 00       	call   380a <fork>
    2ea8:	85 c0                	test   %eax,%eax
    2eaa:	89 06                	mov    %eax,(%esi)
    2eac:	75 d2                	jne    2e80 <sbrktest+0x1e0>
      sbrk(BIG - (uint)sbrk(0));
    2eae:	83 ec 0c             	sub    $0xc,%esp
    2eb1:	6a 00                	push   $0x0
    2eb3:	e8 e2 09 00 00       	call   389a <sbrk>
    2eb8:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2ebd:	29 c2                	sub    %eax,%edx
    2ebf:	89 14 24             	mov    %edx,(%esp)
    2ec2:	e8 d3 09 00 00       	call   389a <sbrk>
      write(fds[1], "x", 1);
    2ec7:	83 c4 0c             	add    $0xc,%esp
    2eca:	6a 01                	push   $0x1
    2ecc:	68 31 46 00 00       	push   $0x4631
    2ed1:	ff 75 bc             	pushl  -0x44(%ebp)
    2ed4:	e8 59 09 00 00       	call   3832 <write>
    2ed9:	83 c4 10             	add    $0x10,%esp
    2edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(;;) sleep(1000);
    2ee0:	83 ec 0c             	sub    $0xc,%esp
    2ee3:	68 e8 03 00 00       	push   $0x3e8
    2ee8:	e8 b5 09 00 00       	call   38a2 <sleep>
    2eed:	83 c4 10             	add    $0x10,%esp
    2ef0:	eb ee                	jmp    2ee0 <sbrktest+0x240>
  c = sbrk(4096);
    2ef2:	83 ec 0c             	sub    $0xc,%esp
    2ef5:	68 00 10 00 00       	push   $0x1000
    2efa:	e8 9b 09 00 00       	call   389a <sbrk>
    2eff:	83 c4 10             	add    $0x10,%esp
    2f02:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    if(pids[i] == -1)
    2f05:	8b 07                	mov    (%edi),%eax
    2f07:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f0a:	74 11                	je     2f1d <sbrktest+0x27d>
    kill(pids[i]);
    2f0c:	83 ec 0c             	sub    $0xc,%esp
    2f0f:	50                   	push   %eax
    2f10:	e8 2d 09 00 00       	call   3842 <kill>
    wait();
    2f15:	e8 00 09 00 00       	call   381a <wait>
    2f1a:	83 c4 10             	add    $0x10,%esp
    2f1d:	83 c7 04             	add    $0x4,%edi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f20:	39 fe                	cmp    %edi,%esi
    2f22:	75 e1                	jne    2f05 <sbrktest+0x265>
  if(c == (char*)0xffffffff){
    2f24:	83 7d a4 ff          	cmpl   $0xffffffff,-0x5c(%ebp)
    2f28:	74 66                	je     2f90 <sbrktest+0x2f0>
  if(sbrk(0) > oldbrk)
    2f2a:	83 ec 0c             	sub    $0xc,%esp
    2f2d:	6a 00                	push   $0x0
    2f2f:	e8 66 09 00 00       	call   389a <sbrk>
    2f34:	83 c4 10             	add    $0x10,%esp
    2f37:	39 d8                	cmp    %ebx,%eax
    2f39:	77 3c                	ja     2f77 <sbrktest+0x2d7>
  printf(stdout, "sbrk test OK\n");
    2f3b:	83 ec 08             	sub    $0x8,%esp
    2f3e:	68 70 4b 00 00       	push   $0x4b70
    2f43:	ff 35 88 5d 00 00    	pushl  0x5d88
    2f49:	e8 22 0a 00 00       	call   3970 <printf>
}
    2f4e:	83 c4 10             	add    $0x10,%esp
    2f51:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2f54:	5b                   	pop    %ebx
    2f55:	5e                   	pop    %esi
    2f56:	5f                   	pop    %edi
    2f57:	5d                   	pop    %ebp
    2f58:	c3                   	ret    
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2f59:	83 ec 0c             	sub    $0xc,%esp
    2f5c:	50                   	push   %eax
    2f5d:	56                   	push   %esi
    2f5e:	57                   	push   %edi
    2f5f:	68 d3 4a 00 00       	push   $0x4ad3
    2f64:	ff 35 88 5d 00 00    	pushl  0x5d88
    2f6a:	e8 01 0a 00 00       	call   3970 <printf>
      exit();
    2f6f:	83 c4 20             	add    $0x20,%esp
    2f72:	e8 9b 08 00 00       	call   3812 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    2f77:	83 ec 0c             	sub    $0xc,%esp
    2f7a:	6a 00                	push   $0x0
    2f7c:	e8 19 09 00 00       	call   389a <sbrk>
    2f81:	29 c3                	sub    %eax,%ebx
    2f83:	89 1c 24             	mov    %ebx,(%esp)
    2f86:	e8 0f 09 00 00       	call   389a <sbrk>
    2f8b:	83 c4 10             	add    $0x10,%esp
    2f8e:	eb ab                	jmp    2f3b <sbrktest+0x29b>
    printf(stdout, "failed sbrk leaked memory\n");
    2f90:	50                   	push   %eax
    2f91:	50                   	push   %eax
    2f92:	68 55 4b 00 00       	push   $0x4b55
    2f97:	ff 35 88 5d 00 00    	pushl  0x5d88
    2f9d:	e8 ce 09 00 00       	call   3970 <printf>
    exit();
    2fa2:	e8 6b 08 00 00       	call   3812 <exit>
    printf(1, "pipe() failed\n");
    2fa7:	52                   	push   %edx
    2fa8:	52                   	push   %edx
    2fa9:	68 01 40 00 00       	push   $0x4001
    2fae:	6a 01                	push   $0x1
    2fb0:	e8 bb 09 00 00       	call   3970 <printf>
    exit();
    2fb5:	e8 58 08 00 00       	call   3812 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2fba:	0f be 06             	movsbl (%esi),%eax
    2fbd:	50                   	push   %eax
    2fbe:	56                   	push   %esi
    2fbf:	68 3c 4b 00 00       	push   $0x4b3c
    2fc4:	ff 35 88 5d 00 00    	pushl  0x5d88
    2fca:	e8 a1 09 00 00       	call   3970 <printf>
      kill(ppid);
    2fcf:	89 3c 24             	mov    %edi,(%esp)
    2fd2:	e8 6b 08 00 00       	call   3842 <kill>
      exit();
    2fd7:	e8 36 08 00 00       	call   3812 <exit>
      printf(stdout, "fork failed\n");
    2fdc:	51                   	push   %ecx
    2fdd:	51                   	push   %ecx
    2fde:	68 19 4c 00 00       	push   $0x4c19
    2fe3:	ff 35 88 5d 00 00    	pushl  0x5d88
    2fe9:	e8 82 09 00 00       	call   3970 <printf>
      exit();
    2fee:	e8 1f 08 00 00       	call   3812 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2ff3:	50                   	push   %eax
    2ff4:	56                   	push   %esi
    2ff5:	68 1c 53 00 00       	push   $0x531c
    2ffa:	ff 35 88 5d 00 00    	pushl  0x5d88
    3000:	e8 6b 09 00 00       	call   3970 <printf>
    exit();
    3005:	e8 08 08 00 00       	call   3812 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    300a:	53                   	push   %ebx
    300b:	53                   	push   %ebx
    300c:	68 ec 52 00 00       	push   $0x52ec
    3011:	ff 35 88 5d 00 00    	pushl  0x5d88
    3017:	e8 54 09 00 00       	call   3970 <printf>
    exit();
    301c:	e8 f1 07 00 00       	call   3812 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3021:	57                   	push   %edi
    3022:	56                   	push   %esi
    3023:	68 c4 52 00 00       	push   $0x52c4
    3028:	ff 35 88 5d 00 00    	pushl  0x5d88
    302e:	e8 3d 09 00 00       	call   3970 <printf>
    exit();
    3033:	e8 da 07 00 00       	call   3812 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3038:	50                   	push   %eax
    3039:	56                   	push   %esi
    303a:	68 8c 52 00 00       	push   $0x528c
    303f:	ff 35 88 5d 00 00    	pushl  0x5d88
    3045:	e8 26 09 00 00       	call   3970 <printf>
    exit();
    304a:	e8 c3 07 00 00       	call   3812 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    304f:	56                   	push   %esi
    3050:	56                   	push   %esi
    3051:	68 21 4b 00 00       	push   $0x4b21
    3056:	ff 35 88 5d 00 00    	pushl  0x5d88
    305c:	e8 0f 09 00 00       	call   3970 <printf>
    exit();
    3061:	e8 ac 07 00 00       	call   3812 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3066:	57                   	push   %edi
    3067:	57                   	push   %edi
    3068:	68 4c 52 00 00       	push   $0x524c
    306d:	ff 35 88 5d 00 00    	pushl  0x5d88
    3073:	e8 f8 08 00 00       	call   3970 <printf>
    exit();
    3078:	e8 95 07 00 00       	call   3812 <exit>
    exit();
    307d:	e8 90 07 00 00       	call   3812 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    3082:	50                   	push   %eax
    3083:	50                   	push   %eax
    3084:	68 05 4b 00 00       	push   $0x4b05
    3089:	ff 35 88 5d 00 00    	pushl  0x5d88
    308f:	e8 dc 08 00 00       	call   3970 <printf>
    exit();
    3094:	e8 79 07 00 00       	call   3812 <exit>
    printf(stdout, "sbrk test fork failed\n");
    3099:	50                   	push   %eax
    309a:	50                   	push   %eax
    309b:	68 ee 4a 00 00       	push   $0x4aee
    30a0:	ff 35 88 5d 00 00    	pushl  0x5d88
    30a6:	e8 c5 08 00 00       	call   3970 <printf>
    exit();
    30ab:	e8 62 07 00 00       	call   3812 <exit>

000030b0 <validateint>:
{
    30b0:	55                   	push   %ebp
    30b1:	89 e5                	mov    %esp,%ebp
}
    30b3:	5d                   	pop    %ebp
    30b4:	c3                   	ret    
    30b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    30b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000030c0 <validatetest>:
{
    30c0:	55                   	push   %ebp
    30c1:	89 e5                	mov    %esp,%ebp
    30c3:	56                   	push   %esi
    30c4:	53                   	push   %ebx
  for(p = 0; p <= (uint)hi; p += 4096){
    30c5:	31 db                	xor    %ebx,%ebx
  printf(stdout, "validate test\n");
    30c7:	83 ec 08             	sub    $0x8,%esp
    30ca:	68 7e 4b 00 00       	push   $0x4b7e
    30cf:	ff 35 88 5d 00 00    	pushl  0x5d88
    30d5:	e8 96 08 00 00       	call   3970 <printf>
    30da:	83 c4 10             	add    $0x10,%esp
    30dd:	8d 76 00             	lea    0x0(%esi),%esi
    if((pid = fork()) == 0){
    30e0:	e8 25 07 00 00       	call   380a <fork>
    30e5:	85 c0                	test   %eax,%eax
    30e7:	89 c6                	mov    %eax,%esi
    30e9:	74 63                	je     314e <validatetest+0x8e>
    sleep(0);
    30eb:	83 ec 0c             	sub    $0xc,%esp
    30ee:	6a 00                	push   $0x0
    30f0:	e8 ad 07 00 00       	call   38a2 <sleep>
    sleep(0);
    30f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    30fc:	e8 a1 07 00 00       	call   38a2 <sleep>
    kill(pid);
    3101:	89 34 24             	mov    %esi,(%esp)
    3104:	e8 39 07 00 00       	call   3842 <kill>
    wait();
    3109:	e8 0c 07 00 00       	call   381a <wait>
    if(link("nosuchfile", (char*)p) != -1){
    310e:	58                   	pop    %eax
    310f:	5a                   	pop    %edx
    3110:	53                   	push   %ebx
    3111:	68 8d 4b 00 00       	push   $0x4b8d
    3116:	e8 57 07 00 00       	call   3872 <link>
    311b:	83 c4 10             	add    $0x10,%esp
    311e:	83 f8 ff             	cmp    $0xffffffff,%eax
    3121:	75 30                	jne    3153 <validatetest+0x93>
  for(p = 0; p <= (uint)hi; p += 4096){
    3123:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    3129:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    312f:	75 af                	jne    30e0 <validatetest+0x20>
  printf(stdout, "validate ok\n");
    3131:	83 ec 08             	sub    $0x8,%esp
    3134:	68 b1 4b 00 00       	push   $0x4bb1
    3139:	ff 35 88 5d 00 00    	pushl  0x5d88
    313f:	e8 2c 08 00 00       	call   3970 <printf>
}
    3144:	83 c4 10             	add    $0x10,%esp
    3147:	8d 65 f8             	lea    -0x8(%ebp),%esp
    314a:	5b                   	pop    %ebx
    314b:	5e                   	pop    %esi
    314c:	5d                   	pop    %ebp
    314d:	c3                   	ret    
      exit();
    314e:	e8 bf 06 00 00       	call   3812 <exit>
      printf(stdout, "link should not succeed\n");
    3153:	83 ec 08             	sub    $0x8,%esp
    3156:	68 98 4b 00 00       	push   $0x4b98
    315b:	ff 35 88 5d 00 00    	pushl  0x5d88
    3161:	e8 0a 08 00 00       	call   3970 <printf>
      exit();
    3166:	e8 a7 06 00 00       	call   3812 <exit>
    316b:	90                   	nop
    316c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003170 <bsstest>:
{
    3170:	55                   	push   %ebp
    3171:	89 e5                	mov    %esp,%ebp
    3173:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    3176:	68 be 4b 00 00       	push   $0x4bbe
    317b:	ff 35 88 5d 00 00    	pushl  0x5d88
    3181:	e8 ea 07 00 00       	call   3970 <printf>
    if(uninit[i] != '\0'){
    3186:	83 c4 10             	add    $0x10,%esp
    3189:	80 3d 40 5e 00 00 00 	cmpb   $0x0,0x5e40
    3190:	75 39                	jne    31cb <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3192:	b8 01 00 00 00       	mov    $0x1,%eax
    3197:	89 f6                	mov    %esi,%esi
    3199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(uninit[i] != '\0'){
    31a0:	80 b8 40 5e 00 00 00 	cmpb   $0x0,0x5e40(%eax)
    31a7:	75 22                	jne    31cb <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    31a9:	83 c0 01             	add    $0x1,%eax
    31ac:	3d 10 27 00 00       	cmp    $0x2710,%eax
    31b1:	75 ed                	jne    31a0 <bsstest+0x30>
  printf(stdout, "bss test ok\n");
    31b3:	83 ec 08             	sub    $0x8,%esp
    31b6:	68 d9 4b 00 00       	push   $0x4bd9
    31bb:	ff 35 88 5d 00 00    	pushl  0x5d88
    31c1:	e8 aa 07 00 00       	call   3970 <printf>
}
    31c6:	83 c4 10             	add    $0x10,%esp
    31c9:	c9                   	leave  
    31ca:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    31cb:	83 ec 08             	sub    $0x8,%esp
    31ce:	68 c8 4b 00 00       	push   $0x4bc8
    31d3:	ff 35 88 5d 00 00    	pushl  0x5d88
    31d9:	e8 92 07 00 00       	call   3970 <printf>
      exit();
    31de:	e8 2f 06 00 00       	call   3812 <exit>
    31e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    31e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000031f0 <bigargtest>:
{
    31f0:	55                   	push   %ebp
    31f1:	89 e5                	mov    %esp,%ebp
    31f3:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    31f6:	68 e6 4b 00 00       	push   $0x4be6
    31fb:	e8 62 06 00 00       	call   3862 <unlink>
  pid = fork();
    3200:	e8 05 06 00 00       	call   380a <fork>
  if(pid == 0){
    3205:	83 c4 10             	add    $0x10,%esp
    3208:	85 c0                	test   %eax,%eax
    320a:	74 3f                	je     324b <bigargtest+0x5b>
  } else if(pid < 0){
    320c:	0f 88 c2 00 00 00    	js     32d4 <bigargtest+0xe4>
  wait();
    3212:	e8 03 06 00 00       	call   381a <wait>
  fd = open("bigarg-ok", 0);
    3217:	83 ec 08             	sub    $0x8,%esp
    321a:	6a 00                	push   $0x0
    321c:	68 e6 4b 00 00       	push   $0x4be6
    3221:	e8 2c 06 00 00       	call   3852 <open>
  if(fd < 0){
    3226:	83 c4 10             	add    $0x10,%esp
    3229:	85 c0                	test   %eax,%eax
    322b:	0f 88 8c 00 00 00    	js     32bd <bigargtest+0xcd>
  close(fd);
    3231:	83 ec 0c             	sub    $0xc,%esp
    3234:	50                   	push   %eax
    3235:	e8 00 06 00 00       	call   383a <close>
  unlink("bigarg-ok");
    323a:	c7 04 24 e6 4b 00 00 	movl   $0x4be6,(%esp)
    3241:	e8 1c 06 00 00       	call   3862 <unlink>
}
    3246:	83 c4 10             	add    $0x10,%esp
    3249:	c9                   	leave  
    324a:	c3                   	ret    
    324b:	b8 a0 5d 00 00       	mov    $0x5da0,%eax
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    3250:	c7 00 40 53 00 00    	movl   $0x5340,(%eax)
    3256:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < MAXARG-1; i++)
    3259:	3d 1c 5e 00 00       	cmp    $0x5e1c,%eax
    325e:	75 f0                	jne    3250 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    3260:	51                   	push   %ecx
    3261:	51                   	push   %ecx
    3262:	68 f0 4b 00 00       	push   $0x4bf0
    3267:	ff 35 88 5d 00 00    	pushl  0x5d88
    args[MAXARG-1] = 0;
    326d:	c7 05 1c 5e 00 00 00 	movl   $0x0,0x5e1c
    3274:	00 00 00 
    printf(stdout, "bigarg test\n");
    3277:	e8 f4 06 00 00       	call   3970 <printf>
    exec("echo", args);
    327c:	58                   	pop    %eax
    327d:	5a                   	pop    %edx
    327e:	68 a0 5d 00 00       	push   $0x5da0
    3283:	68 ad 3d 00 00       	push   $0x3dad
    3288:	e8 bd 05 00 00       	call   384a <exec>
    printf(stdout, "bigarg test ok\n");
    328d:	59                   	pop    %ecx
    328e:	58                   	pop    %eax
    328f:	68 fd 4b 00 00       	push   $0x4bfd
    3294:	ff 35 88 5d 00 00    	pushl  0x5d88
    329a:	e8 d1 06 00 00       	call   3970 <printf>
    fd = open("bigarg-ok", O_CREATE);
    329f:	58                   	pop    %eax
    32a0:	5a                   	pop    %edx
    32a1:	68 00 02 00 00       	push   $0x200
    32a6:	68 e6 4b 00 00       	push   $0x4be6
    32ab:	e8 a2 05 00 00       	call   3852 <open>
    close(fd);
    32b0:	89 04 24             	mov    %eax,(%esp)
    32b3:	e8 82 05 00 00       	call   383a <close>
    exit();
    32b8:	e8 55 05 00 00       	call   3812 <exit>
    printf(stdout, "bigarg test failed!\n");
    32bd:	50                   	push   %eax
    32be:	50                   	push   %eax
    32bf:	68 26 4c 00 00       	push   $0x4c26
    32c4:	ff 35 88 5d 00 00    	pushl  0x5d88
    32ca:	e8 a1 06 00 00       	call   3970 <printf>
    exit();
    32cf:	e8 3e 05 00 00       	call   3812 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    32d4:	52                   	push   %edx
    32d5:	52                   	push   %edx
    32d6:	68 0d 4c 00 00       	push   $0x4c0d
    32db:	ff 35 88 5d 00 00    	pushl  0x5d88
    32e1:	e8 8a 06 00 00       	call   3970 <printf>
    exit();
    32e6:	e8 27 05 00 00       	call   3812 <exit>
    32eb:	90                   	nop
    32ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000032f0 <fsfull>:
{
    32f0:	55                   	push   %ebp
    32f1:	89 e5                	mov    %esp,%ebp
    32f3:	57                   	push   %edi
    32f4:	56                   	push   %esi
    32f5:	53                   	push   %ebx
  for(nfiles = 0; ; nfiles++){
    32f6:	31 db                	xor    %ebx,%ebx
{
    32f8:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    32fb:	68 3b 4c 00 00       	push   $0x4c3b
    3300:	6a 01                	push   $0x1
    3302:	e8 69 06 00 00       	call   3970 <printf>
    3307:	83 c4 10             	add    $0x10,%esp
    330a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    3310:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3315:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    331a:	83 ec 04             	sub    $0x4,%esp
    name[1] = '0' + nfiles / 1000;
    331d:	f7 e3                	mul    %ebx
    name[0] = 'f';
    331f:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[5] = '\0';
    3323:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3327:	c1 ea 06             	shr    $0x6,%edx
    332a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    332d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3333:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3336:	89 d8                	mov    %ebx,%eax
    3338:	29 d0                	sub    %edx,%eax
    333a:	89 c2                	mov    %eax,%edx
    333c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3341:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    3343:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3348:	c1 ea 05             	shr    $0x5,%edx
    334b:	83 c2 30             	add    $0x30,%edx
    334e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3351:	f7 e3                	mul    %ebx
    3353:	89 d8                	mov    %ebx,%eax
    3355:	c1 ea 05             	shr    $0x5,%edx
    3358:	6b d2 64             	imul   $0x64,%edx,%edx
    335b:	29 d0                	sub    %edx,%eax
    335d:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    335f:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3361:	c1 ea 03             	shr    $0x3,%edx
    3364:	83 c2 30             	add    $0x30,%edx
    3367:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    336a:	f7 e1                	mul    %ecx
    336c:	89 d9                	mov    %ebx,%ecx
    336e:	c1 ea 03             	shr    $0x3,%edx
    3371:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3374:	01 c0                	add    %eax,%eax
    3376:	29 c1                	sub    %eax,%ecx
    3378:	89 c8                	mov    %ecx,%eax
    337a:	83 c0 30             	add    $0x30,%eax
    337d:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    3380:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3383:	50                   	push   %eax
    3384:	68 48 4c 00 00       	push   $0x4c48
    3389:	6a 01                	push   $0x1
    338b:	e8 e0 05 00 00       	call   3970 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3390:	58                   	pop    %eax
    3391:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3394:	5a                   	pop    %edx
    3395:	68 02 02 00 00       	push   $0x202
    339a:	50                   	push   %eax
    339b:	e8 b2 04 00 00       	call   3852 <open>
    if(fd < 0){
    33a0:	83 c4 10             	add    $0x10,%esp
    33a3:	85 c0                	test   %eax,%eax
    int fd = open(name, O_CREATE|O_RDWR);
    33a5:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    33a7:	78 57                	js     3400 <fsfull+0x110>
    int total = 0;
    33a9:	31 f6                	xor    %esi,%esi
    33ab:	eb 05                	jmp    33b2 <fsfull+0xc2>
    33ad:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    33b0:	01 c6                	add    %eax,%esi
      int cc = write(fd, buf, 512);
    33b2:	83 ec 04             	sub    $0x4,%esp
    33b5:	68 00 02 00 00       	push   $0x200
    33ba:	68 60 85 00 00       	push   $0x8560
    33bf:	57                   	push   %edi
    33c0:	e8 6d 04 00 00       	call   3832 <write>
      if(cc < 512)
    33c5:	83 c4 10             	add    $0x10,%esp
    33c8:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    33cd:	7f e1                	jg     33b0 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    33cf:	83 ec 04             	sub    $0x4,%esp
    33d2:	56                   	push   %esi
    33d3:	68 64 4c 00 00       	push   $0x4c64
    33d8:	6a 01                	push   $0x1
    33da:	e8 91 05 00 00       	call   3970 <printf>
    close(fd);
    33df:	89 3c 24             	mov    %edi,(%esp)
    33e2:	e8 53 04 00 00       	call   383a <close>
    if(total == 0)
    33e7:	83 c4 10             	add    $0x10,%esp
    33ea:	85 f6                	test   %esi,%esi
    33ec:	74 28                	je     3416 <fsfull+0x126>
  for(nfiles = 0; ; nfiles++){
    33ee:	83 c3 01             	add    $0x1,%ebx
    33f1:	e9 1a ff ff ff       	jmp    3310 <fsfull+0x20>
    33f6:	8d 76 00             	lea    0x0(%esi),%esi
    33f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "open %s failed\n", name);
    3400:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3403:	83 ec 04             	sub    $0x4,%esp
    3406:	50                   	push   %eax
    3407:	68 54 4c 00 00       	push   $0x4c54
    340c:	6a 01                	push   $0x1
    340e:	e8 5d 05 00 00       	call   3970 <printf>
      break;
    3413:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    3416:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    341b:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
    name[1] = '0' + nfiles / 1000;
    3420:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3422:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    unlink(name);
    3427:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + nfiles / 1000;
    342a:	f7 e7                	mul    %edi
    name[0] = 'f';
    342c:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[5] = '\0';
    3430:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3434:	c1 ea 06             	shr    $0x6,%edx
    3437:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    343a:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3440:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3443:	89 d8                	mov    %ebx,%eax
    3445:	29 d0                	sub    %edx,%eax
    3447:	f7 e6                	mul    %esi
    name[3] = '0' + (nfiles % 100) / 10;
    3449:	89 d8                	mov    %ebx,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    344b:	c1 ea 05             	shr    $0x5,%edx
    344e:	83 c2 30             	add    $0x30,%edx
    3451:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3454:	f7 e6                	mul    %esi
    3456:	89 d8                	mov    %ebx,%eax
    3458:	c1 ea 05             	shr    $0x5,%edx
    345b:	6b d2 64             	imul   $0x64,%edx,%edx
    345e:	29 d0                	sub    %edx,%eax
    3460:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    3462:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3464:	c1 ea 03             	shr    $0x3,%edx
    3467:	83 c2 30             	add    $0x30,%edx
    346a:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    346d:	f7 e1                	mul    %ecx
    346f:	89 d9                	mov    %ebx,%ecx
    nfiles--;
    3471:	83 eb 01             	sub    $0x1,%ebx
    name[4] = '0' + (nfiles % 10);
    3474:	c1 ea 03             	shr    $0x3,%edx
    3477:	8d 04 92             	lea    (%edx,%edx,4),%eax
    347a:	01 c0                	add    %eax,%eax
    347c:	29 c1                	sub    %eax,%ecx
    347e:	89 c8                	mov    %ecx,%eax
    3480:	83 c0 30             	add    $0x30,%eax
    3483:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    3486:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3489:	50                   	push   %eax
    348a:	e8 d3 03 00 00       	call   3862 <unlink>
  while(nfiles >= 0){
    348f:	83 c4 10             	add    $0x10,%esp
    3492:	83 fb ff             	cmp    $0xffffffff,%ebx
    3495:	75 89                	jne    3420 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    3497:	83 ec 08             	sub    $0x8,%esp
    349a:	68 74 4c 00 00       	push   $0x4c74
    349f:	6a 01                	push   $0x1
    34a1:	e8 ca 04 00 00       	call   3970 <printf>
}
    34a6:	83 c4 10             	add    $0x10,%esp
    34a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    34ac:	5b                   	pop    %ebx
    34ad:	5e                   	pop    %esi
    34ae:	5f                   	pop    %edi
    34af:	5d                   	pop    %ebp
    34b0:	c3                   	ret    
    34b1:	eb 0d                	jmp    34c0 <uio>
    34b3:	90                   	nop
    34b4:	90                   	nop
    34b5:	90                   	nop
    34b6:	90                   	nop
    34b7:	90                   	nop
    34b8:	90                   	nop
    34b9:	90                   	nop
    34ba:	90                   	nop
    34bb:	90                   	nop
    34bc:	90                   	nop
    34bd:	90                   	nop
    34be:	90                   	nop
    34bf:	90                   	nop

000034c0 <uio>:
{
    34c0:	55                   	push   %ebp
    34c1:	89 e5                	mov    %esp,%ebp
    34c3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    34c6:	68 8a 4c 00 00       	push   $0x4c8a
    34cb:	6a 01                	push   $0x1
    34cd:	e8 9e 04 00 00       	call   3970 <printf>
  pid = fork();
    34d2:	e8 33 03 00 00       	call   380a <fork>
  if(pid == 0){
    34d7:	83 c4 10             	add    $0x10,%esp
    34da:	85 c0                	test   %eax,%eax
    34dc:	74 1b                	je     34f9 <uio+0x39>
  } else if(pid < 0){
    34de:	78 3d                	js     351d <uio+0x5d>
  wait();
    34e0:	e8 35 03 00 00       	call   381a <wait>
  printf(1, "uio test done\n");
    34e5:	83 ec 08             	sub    $0x8,%esp
    34e8:	68 94 4c 00 00       	push   $0x4c94
    34ed:	6a 01                	push   $0x1
    34ef:	e8 7c 04 00 00       	call   3970 <printf>
}
    34f4:	83 c4 10             	add    $0x10,%esp
    34f7:	c9                   	leave  
    34f8:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    34f9:	b8 09 00 00 00       	mov    $0x9,%eax
    34fe:	ba 70 00 00 00       	mov    $0x70,%edx
    3503:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3504:	ba 71 00 00 00       	mov    $0x71,%edx
    3509:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    350a:	52                   	push   %edx
    350b:	52                   	push   %edx
    350c:	68 20 54 00 00       	push   $0x5420
    3511:	6a 01                	push   $0x1
    3513:	e8 58 04 00 00       	call   3970 <printf>
    exit();
    3518:	e8 f5 02 00 00       	call   3812 <exit>
    printf (1, "fork failed\n");
    351d:	50                   	push   %eax
    351e:	50                   	push   %eax
    351f:	68 19 4c 00 00       	push   $0x4c19
    3524:	6a 01                	push   $0x1
    3526:	e8 45 04 00 00       	call   3970 <printf>
    exit();
    352b:	e8 e2 02 00 00       	call   3812 <exit>

00003530 <argptest>:
{
    3530:	55                   	push   %ebp
    3531:	89 e5                	mov    %esp,%ebp
    3533:	53                   	push   %ebx
    3534:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    3537:	6a 00                	push   $0x0
    3539:	68 a3 4c 00 00       	push   $0x4ca3
    353e:	e8 0f 03 00 00       	call   3852 <open>
  if (fd < 0) {
    3543:	83 c4 10             	add    $0x10,%esp
    3546:	85 c0                	test   %eax,%eax
    3548:	78 39                	js     3583 <argptest+0x53>
  read(fd, sbrk(0) - 1, -1);
    354a:	83 ec 0c             	sub    $0xc,%esp
    354d:	89 c3                	mov    %eax,%ebx
    354f:	6a 00                	push   $0x0
    3551:	e8 44 03 00 00       	call   389a <sbrk>
    3556:	83 c4 0c             	add    $0xc,%esp
    3559:	83 e8 01             	sub    $0x1,%eax
    355c:	6a ff                	push   $0xffffffff
    355e:	50                   	push   %eax
    355f:	53                   	push   %ebx
    3560:	e8 c5 02 00 00       	call   382a <read>
  close(fd);
    3565:	89 1c 24             	mov    %ebx,(%esp)
    3568:	e8 cd 02 00 00       	call   383a <close>
  printf(1, "arg test passed\n");
    356d:	58                   	pop    %eax
    356e:	5a                   	pop    %edx
    356f:	68 b5 4c 00 00       	push   $0x4cb5
    3574:	6a 01                	push   $0x1
    3576:	e8 f5 03 00 00       	call   3970 <printf>
}
    357b:	83 c4 10             	add    $0x10,%esp
    357e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3581:	c9                   	leave  
    3582:	c3                   	ret    
    printf(2, "open failed\n");
    3583:	51                   	push   %ecx
    3584:	51                   	push   %ecx
    3585:	68 a8 4c 00 00       	push   $0x4ca8
    358a:	6a 02                	push   $0x2
    358c:	e8 df 03 00 00       	call   3970 <printf>
    exit();
    3591:	e8 7c 02 00 00       	call   3812 <exit>
    3596:	8d 76 00             	lea    0x0(%esi),%esi
    3599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000035a0 <rand>:
  randstate = randstate * 1664525 + 1013904223;
    35a0:	69 05 84 5d 00 00 0d 	imul   $0x19660d,0x5d84,%eax
    35a7:	66 19 00 
{
    35aa:	55                   	push   %ebp
    35ab:	89 e5                	mov    %esp,%ebp
}
    35ad:	5d                   	pop    %ebp
  randstate = randstate * 1664525 + 1013904223;
    35ae:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    35b3:	a3 84 5d 00 00       	mov    %eax,0x5d84
}
    35b8:	c3                   	ret    
    35b9:	66 90                	xchg   %ax,%ax
    35bb:	66 90                	xchg   %ax,%ax
    35bd:	66 90                	xchg   %ax,%ax
    35bf:	90                   	nop

000035c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    35c0:	55                   	push   %ebp
    35c1:	89 e5                	mov    %esp,%ebp
    35c3:	53                   	push   %ebx
    35c4:	8b 45 08             	mov    0x8(%ebp),%eax
    35c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    35ca:	89 c2                	mov    %eax,%edx
    35cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    35d0:	83 c1 01             	add    $0x1,%ecx
    35d3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    35d7:	83 c2 01             	add    $0x1,%edx
    35da:	84 db                	test   %bl,%bl
    35dc:	88 5a ff             	mov    %bl,-0x1(%edx)
    35df:	75 ef                	jne    35d0 <strcpy+0x10>
    ;
  return os;
}
    35e1:	5b                   	pop    %ebx
    35e2:	5d                   	pop    %ebp
    35e3:	c3                   	ret    
    35e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    35ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000035f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    35f0:	55                   	push   %ebp
    35f1:	89 e5                	mov    %esp,%ebp
    35f3:	53                   	push   %ebx
    35f4:	8b 55 08             	mov    0x8(%ebp),%edx
    35f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    35fa:	0f b6 02             	movzbl (%edx),%eax
    35fd:	0f b6 19             	movzbl (%ecx),%ebx
    3600:	84 c0                	test   %al,%al
    3602:	75 1c                	jne    3620 <strcmp+0x30>
    3604:	eb 2a                	jmp    3630 <strcmp+0x40>
    3606:	8d 76 00             	lea    0x0(%esi),%esi
    3609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    3610:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    3613:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    3616:	83 c1 01             	add    $0x1,%ecx
    3619:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    361c:	84 c0                	test   %al,%al
    361e:	74 10                	je     3630 <strcmp+0x40>
    3620:	38 d8                	cmp    %bl,%al
    3622:	74 ec                	je     3610 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    3624:	29 d8                	sub    %ebx,%eax
}
    3626:	5b                   	pop    %ebx
    3627:	5d                   	pop    %ebp
    3628:	c3                   	ret    
    3629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3630:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    3632:	29 d8                	sub    %ebx,%eax
}
    3634:	5b                   	pop    %ebx
    3635:	5d                   	pop    %ebp
    3636:	c3                   	ret    
    3637:	89 f6                	mov    %esi,%esi
    3639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003640 <strlen>:

uint
strlen(const char *s)
{
    3640:	55                   	push   %ebp
    3641:	89 e5                	mov    %esp,%ebp
    3643:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    3646:	80 39 00             	cmpb   $0x0,(%ecx)
    3649:	74 15                	je     3660 <strlen+0x20>
    364b:	31 d2                	xor    %edx,%edx
    364d:	8d 76 00             	lea    0x0(%esi),%esi
    3650:	83 c2 01             	add    $0x1,%edx
    3653:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    3657:	89 d0                	mov    %edx,%eax
    3659:	75 f5                	jne    3650 <strlen+0x10>
    ;
  return n;
}
    365b:	5d                   	pop    %ebp
    365c:	c3                   	ret    
    365d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    3660:	31 c0                	xor    %eax,%eax
}
    3662:	5d                   	pop    %ebp
    3663:	c3                   	ret    
    3664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    366a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00003670 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3670:	55                   	push   %ebp
    3671:	89 e5                	mov    %esp,%ebp
    3673:	57                   	push   %edi
    3674:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3677:	8b 4d 10             	mov    0x10(%ebp),%ecx
    367a:	8b 45 0c             	mov    0xc(%ebp),%eax
    367d:	89 d7                	mov    %edx,%edi
    367f:	fc                   	cld    
    3680:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3682:	89 d0                	mov    %edx,%eax
    3684:	5f                   	pop    %edi
    3685:	5d                   	pop    %ebp
    3686:	c3                   	ret    
    3687:	89 f6                	mov    %esi,%esi
    3689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003690 <strchr>:

char*
strchr(const char *s, char c)
{
    3690:	55                   	push   %ebp
    3691:	89 e5                	mov    %esp,%ebp
    3693:	53                   	push   %ebx
    3694:	8b 45 08             	mov    0x8(%ebp),%eax
    3697:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    369a:	0f b6 10             	movzbl (%eax),%edx
    369d:	84 d2                	test   %dl,%dl
    369f:	74 1d                	je     36be <strchr+0x2e>
    if(*s == c)
    36a1:	38 d3                	cmp    %dl,%bl
    36a3:	89 d9                	mov    %ebx,%ecx
    36a5:	75 0d                	jne    36b4 <strchr+0x24>
    36a7:	eb 17                	jmp    36c0 <strchr+0x30>
    36a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    36b0:	38 ca                	cmp    %cl,%dl
    36b2:	74 0c                	je     36c0 <strchr+0x30>
  for(; *s; s++)
    36b4:	83 c0 01             	add    $0x1,%eax
    36b7:	0f b6 10             	movzbl (%eax),%edx
    36ba:	84 d2                	test   %dl,%dl
    36bc:	75 f2                	jne    36b0 <strchr+0x20>
      return (char*)s;
  return 0;
    36be:	31 c0                	xor    %eax,%eax
}
    36c0:	5b                   	pop    %ebx
    36c1:	5d                   	pop    %ebp
    36c2:	c3                   	ret    
    36c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    36c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000036d0 <gets>:

char*
gets(char *buf, int max)
{
    36d0:	55                   	push   %ebp
    36d1:	89 e5                	mov    %esp,%ebp
    36d3:	57                   	push   %edi
    36d4:	56                   	push   %esi
    36d5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    36d6:	31 f6                	xor    %esi,%esi
    36d8:	89 f3                	mov    %esi,%ebx
{
    36da:	83 ec 1c             	sub    $0x1c,%esp
    36dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    36e0:	eb 2f                	jmp    3711 <gets+0x41>
    36e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    36e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
    36eb:	83 ec 04             	sub    $0x4,%esp
    36ee:	6a 01                	push   $0x1
    36f0:	50                   	push   %eax
    36f1:	6a 00                	push   $0x0
    36f3:	e8 32 01 00 00       	call   382a <read>
    if(cc < 1)
    36f8:	83 c4 10             	add    $0x10,%esp
    36fb:	85 c0                	test   %eax,%eax
    36fd:	7e 1c                	jle    371b <gets+0x4b>
      break;
    buf[i++] = c;
    36ff:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    3703:	83 c7 01             	add    $0x1,%edi
    3706:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    3709:	3c 0a                	cmp    $0xa,%al
    370b:	74 23                	je     3730 <gets+0x60>
    370d:	3c 0d                	cmp    $0xd,%al
    370f:	74 1f                	je     3730 <gets+0x60>
  for(i=0; i+1 < max; ){
    3711:	83 c3 01             	add    $0x1,%ebx
    3714:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    3717:	89 fe                	mov    %edi,%esi
    3719:	7c cd                	jl     36e8 <gets+0x18>
    371b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    371d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    3720:	c6 03 00             	movb   $0x0,(%ebx)
}
    3723:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3726:	5b                   	pop    %ebx
    3727:	5e                   	pop    %esi
    3728:	5f                   	pop    %edi
    3729:	5d                   	pop    %ebp
    372a:	c3                   	ret    
    372b:	90                   	nop
    372c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3730:	8b 75 08             	mov    0x8(%ebp),%esi
    3733:	8b 45 08             	mov    0x8(%ebp),%eax
    3736:	01 de                	add    %ebx,%esi
    3738:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    373a:	c6 03 00             	movb   $0x0,(%ebx)
}
    373d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3740:	5b                   	pop    %ebx
    3741:	5e                   	pop    %esi
    3742:	5f                   	pop    %edi
    3743:	5d                   	pop    %ebp
    3744:	c3                   	ret    
    3745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003750 <stat>:

int
stat(const char *n, struct stat *st)
{
    3750:	55                   	push   %ebp
    3751:	89 e5                	mov    %esp,%ebp
    3753:	56                   	push   %esi
    3754:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3755:	83 ec 08             	sub    $0x8,%esp
    3758:	6a 00                	push   $0x0
    375a:	ff 75 08             	pushl  0x8(%ebp)
    375d:	e8 f0 00 00 00       	call   3852 <open>
  if(fd < 0)
    3762:	83 c4 10             	add    $0x10,%esp
    3765:	85 c0                	test   %eax,%eax
    3767:	78 27                	js     3790 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    3769:	83 ec 08             	sub    $0x8,%esp
    376c:	ff 75 0c             	pushl  0xc(%ebp)
    376f:	89 c3                	mov    %eax,%ebx
    3771:	50                   	push   %eax
    3772:	e8 f3 00 00 00       	call   386a <fstat>
  close(fd);
    3777:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    377a:	89 c6                	mov    %eax,%esi
  close(fd);
    377c:	e8 b9 00 00 00       	call   383a <close>
  return r;
    3781:	83 c4 10             	add    $0x10,%esp
}
    3784:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3787:	89 f0                	mov    %esi,%eax
    3789:	5b                   	pop    %ebx
    378a:	5e                   	pop    %esi
    378b:	5d                   	pop    %ebp
    378c:	c3                   	ret    
    378d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    3790:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3795:	eb ed                	jmp    3784 <stat+0x34>
    3797:	89 f6                	mov    %esi,%esi
    3799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000037a0 <atoi>:

int
atoi(const char *s)
{
    37a0:	55                   	push   %ebp
    37a1:	89 e5                	mov    %esp,%ebp
    37a3:	53                   	push   %ebx
    37a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    37a7:	0f be 11             	movsbl (%ecx),%edx
    37aa:	8d 42 d0             	lea    -0x30(%edx),%eax
    37ad:	3c 09                	cmp    $0x9,%al
  n = 0;
    37af:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    37b4:	77 1f                	ja     37d5 <atoi+0x35>
    37b6:	8d 76 00             	lea    0x0(%esi),%esi
    37b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    37c0:	8d 04 80             	lea    (%eax,%eax,4),%eax
    37c3:	83 c1 01             	add    $0x1,%ecx
    37c6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    37ca:	0f be 11             	movsbl (%ecx),%edx
    37cd:	8d 5a d0             	lea    -0x30(%edx),%ebx
    37d0:	80 fb 09             	cmp    $0x9,%bl
    37d3:	76 eb                	jbe    37c0 <atoi+0x20>
  return n;
}
    37d5:	5b                   	pop    %ebx
    37d6:	5d                   	pop    %ebp
    37d7:	c3                   	ret    
    37d8:	90                   	nop
    37d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000037e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    37e0:	55                   	push   %ebp
    37e1:	89 e5                	mov    %esp,%ebp
    37e3:	56                   	push   %esi
    37e4:	53                   	push   %ebx
    37e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
    37e8:	8b 45 08             	mov    0x8(%ebp),%eax
    37eb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    37ee:	85 db                	test   %ebx,%ebx
    37f0:	7e 14                	jle    3806 <memmove+0x26>
    37f2:	31 d2                	xor    %edx,%edx
    37f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    37f8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    37fc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    37ff:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    3802:	39 d3                	cmp    %edx,%ebx
    3804:	75 f2                	jne    37f8 <memmove+0x18>
  return vdst;
}
    3806:	5b                   	pop    %ebx
    3807:	5e                   	pop    %esi
    3808:	5d                   	pop    %ebp
    3809:	c3                   	ret    

0000380a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    380a:	b8 01 00 00 00       	mov    $0x1,%eax
    380f:	cd 40                	int    $0x40
    3811:	c3                   	ret    

00003812 <exit>:
SYSCALL(exit)
    3812:	b8 02 00 00 00       	mov    $0x2,%eax
    3817:	cd 40                	int    $0x40
    3819:	c3                   	ret    

0000381a <wait>:
SYSCALL(wait)
    381a:	b8 03 00 00 00       	mov    $0x3,%eax
    381f:	cd 40                	int    $0x40
    3821:	c3                   	ret    

00003822 <pipe>:
SYSCALL(pipe)
    3822:	b8 04 00 00 00       	mov    $0x4,%eax
    3827:	cd 40                	int    $0x40
    3829:	c3                   	ret    

0000382a <read>:
SYSCALL(read)
    382a:	b8 05 00 00 00       	mov    $0x5,%eax
    382f:	cd 40                	int    $0x40
    3831:	c3                   	ret    

00003832 <write>:
SYSCALL(write)
    3832:	b8 10 00 00 00       	mov    $0x10,%eax
    3837:	cd 40                	int    $0x40
    3839:	c3                   	ret    

0000383a <close>:
SYSCALL(close)
    383a:	b8 15 00 00 00       	mov    $0x15,%eax
    383f:	cd 40                	int    $0x40
    3841:	c3                   	ret    

00003842 <kill>:
SYSCALL(kill)
    3842:	b8 06 00 00 00       	mov    $0x6,%eax
    3847:	cd 40                	int    $0x40
    3849:	c3                   	ret    

0000384a <exec>:
SYSCALL(exec)
    384a:	b8 07 00 00 00       	mov    $0x7,%eax
    384f:	cd 40                	int    $0x40
    3851:	c3                   	ret    

00003852 <open>:
SYSCALL(open)
    3852:	b8 0f 00 00 00       	mov    $0xf,%eax
    3857:	cd 40                	int    $0x40
    3859:	c3                   	ret    

0000385a <mknod>:
SYSCALL(mknod)
    385a:	b8 11 00 00 00       	mov    $0x11,%eax
    385f:	cd 40                	int    $0x40
    3861:	c3                   	ret    

00003862 <unlink>:
SYSCALL(unlink)
    3862:	b8 12 00 00 00       	mov    $0x12,%eax
    3867:	cd 40                	int    $0x40
    3869:	c3                   	ret    

0000386a <fstat>:
SYSCALL(fstat)
    386a:	b8 08 00 00 00       	mov    $0x8,%eax
    386f:	cd 40                	int    $0x40
    3871:	c3                   	ret    

00003872 <link>:
SYSCALL(link)
    3872:	b8 13 00 00 00       	mov    $0x13,%eax
    3877:	cd 40                	int    $0x40
    3879:	c3                   	ret    

0000387a <mkdir>:
SYSCALL(mkdir)
    387a:	b8 14 00 00 00       	mov    $0x14,%eax
    387f:	cd 40                	int    $0x40
    3881:	c3                   	ret    

00003882 <chdir>:
SYSCALL(chdir)
    3882:	b8 09 00 00 00       	mov    $0x9,%eax
    3887:	cd 40                	int    $0x40
    3889:	c3                   	ret    

0000388a <dup>:
SYSCALL(dup)
    388a:	b8 0a 00 00 00       	mov    $0xa,%eax
    388f:	cd 40                	int    $0x40
    3891:	c3                   	ret    

00003892 <getpid>:
SYSCALL(getpid)
    3892:	b8 0b 00 00 00       	mov    $0xb,%eax
    3897:	cd 40                	int    $0x40
    3899:	c3                   	ret    

0000389a <sbrk>:
SYSCALL(sbrk)
    389a:	b8 0c 00 00 00       	mov    $0xc,%eax
    389f:	cd 40                	int    $0x40
    38a1:	c3                   	ret    

000038a2 <sleep>:
SYSCALL(sleep)
    38a2:	b8 0d 00 00 00       	mov    $0xd,%eax
    38a7:	cd 40                	int    $0x40
    38a9:	c3                   	ret    

000038aa <uptime>:
SYSCALL(uptime)
    38aa:	b8 0e 00 00 00       	mov    $0xe,%eax
    38af:	cd 40                	int    $0x40
    38b1:	c3                   	ret    

000038b2 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
    38b2:	b8 16 00 00 00       	mov    $0x16,%eax
    38b7:	cd 40                	int    $0x40
    38b9:	c3                   	ret    

000038ba <getTotalFreePages>:
SYSCALL(getTotalFreePages)
    38ba:	b8 17 00 00 00       	mov    $0x17,%eax
    38bf:	cd 40                	int    $0x40
    38c1:	c3                   	ret    
    38c2:	66 90                	xchg   %ax,%ax
    38c4:	66 90                	xchg   %ax,%ax
    38c6:	66 90                	xchg   %ax,%ax
    38c8:	66 90                	xchg   %ax,%ax
    38ca:	66 90                	xchg   %ax,%ax
    38cc:	66 90                	xchg   %ax,%ax
    38ce:	66 90                	xchg   %ax,%ax

000038d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    38d0:	55                   	push   %ebp
    38d1:	89 e5                	mov    %esp,%ebp
    38d3:	57                   	push   %edi
    38d4:	56                   	push   %esi
    38d5:	53                   	push   %ebx
    38d6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    38d9:	85 d2                	test   %edx,%edx
{
    38db:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    38de:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    38e0:	79 76                	jns    3958 <printint+0x88>
    38e2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    38e6:	74 70                	je     3958 <printint+0x88>
    x = -xx;
    38e8:	f7 d8                	neg    %eax
    neg = 1;
    38ea:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    38f1:	31 f6                	xor    %esi,%esi
    38f3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    38f6:	eb 0a                	jmp    3902 <printint+0x32>
    38f8:	90                   	nop
    38f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    3900:	89 fe                	mov    %edi,%esi
    3902:	31 d2                	xor    %edx,%edx
    3904:	8d 7e 01             	lea    0x1(%esi),%edi
    3907:	f7 f1                	div    %ecx
    3909:	0f b6 92 78 54 00 00 	movzbl 0x5478(%edx),%edx
  }while((x /= base) != 0);
    3910:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    3912:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    3915:	75 e9                	jne    3900 <printint+0x30>
  if(neg)
    3917:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    391a:	85 c0                	test   %eax,%eax
    391c:	74 08                	je     3926 <printint+0x56>
    buf[i++] = '-';
    391e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    3923:	8d 7e 02             	lea    0x2(%esi),%edi
    3926:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    392a:	8b 7d c0             	mov    -0x40(%ebp),%edi
    392d:	8d 76 00             	lea    0x0(%esi),%esi
    3930:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    3933:	83 ec 04             	sub    $0x4,%esp
    3936:	83 ee 01             	sub    $0x1,%esi
    3939:	6a 01                	push   $0x1
    393b:	53                   	push   %ebx
    393c:	57                   	push   %edi
    393d:	88 45 d7             	mov    %al,-0x29(%ebp)
    3940:	e8 ed fe ff ff       	call   3832 <write>

  while(--i >= 0)
    3945:	83 c4 10             	add    $0x10,%esp
    3948:	39 de                	cmp    %ebx,%esi
    394a:	75 e4                	jne    3930 <printint+0x60>
    putc(fd, buf[i]);
}
    394c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    394f:	5b                   	pop    %ebx
    3950:	5e                   	pop    %esi
    3951:	5f                   	pop    %edi
    3952:	5d                   	pop    %ebp
    3953:	c3                   	ret    
    3954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    3958:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    395f:	eb 90                	jmp    38f1 <printint+0x21>
    3961:	eb 0d                	jmp    3970 <printf>
    3963:	90                   	nop
    3964:	90                   	nop
    3965:	90                   	nop
    3966:	90                   	nop
    3967:	90                   	nop
    3968:	90                   	nop
    3969:	90                   	nop
    396a:	90                   	nop
    396b:	90                   	nop
    396c:	90                   	nop
    396d:	90                   	nop
    396e:	90                   	nop
    396f:	90                   	nop

00003970 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3970:	55                   	push   %ebp
    3971:	89 e5                	mov    %esp,%ebp
    3973:	57                   	push   %edi
    3974:	56                   	push   %esi
    3975:	53                   	push   %ebx
    3976:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3979:	8b 75 0c             	mov    0xc(%ebp),%esi
    397c:	0f b6 1e             	movzbl (%esi),%ebx
    397f:	84 db                	test   %bl,%bl
    3981:	0f 84 b3 00 00 00    	je     3a3a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    3987:	8d 45 10             	lea    0x10(%ebp),%eax
    398a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    398d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    398f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3992:	eb 2f                	jmp    39c3 <printf+0x53>
    3994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3998:	83 f8 25             	cmp    $0x25,%eax
    399b:	0f 84 a7 00 00 00    	je     3a48 <printf+0xd8>
  write(fd, &c, 1);
    39a1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    39a4:	83 ec 04             	sub    $0x4,%esp
    39a7:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    39aa:	6a 01                	push   $0x1
    39ac:	50                   	push   %eax
    39ad:	ff 75 08             	pushl  0x8(%ebp)
    39b0:	e8 7d fe ff ff       	call   3832 <write>
    39b5:	83 c4 10             	add    $0x10,%esp
    39b8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    39bb:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    39bf:	84 db                	test   %bl,%bl
    39c1:	74 77                	je     3a3a <printf+0xca>
    if(state == 0){
    39c3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    39c5:	0f be cb             	movsbl %bl,%ecx
    39c8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    39cb:	74 cb                	je     3998 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    39cd:	83 ff 25             	cmp    $0x25,%edi
    39d0:	75 e6                	jne    39b8 <printf+0x48>
      if(c == 'd'){
    39d2:	83 f8 64             	cmp    $0x64,%eax
    39d5:	0f 84 05 01 00 00    	je     3ae0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    39db:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    39e1:	83 f9 70             	cmp    $0x70,%ecx
    39e4:	74 72                	je     3a58 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    39e6:	83 f8 73             	cmp    $0x73,%eax
    39e9:	0f 84 99 00 00 00    	je     3a88 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    39ef:	83 f8 63             	cmp    $0x63,%eax
    39f2:	0f 84 08 01 00 00    	je     3b00 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    39f8:	83 f8 25             	cmp    $0x25,%eax
    39fb:	0f 84 ef 00 00 00    	je     3af0 <printf+0x180>
  write(fd, &c, 1);
    3a01:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3a04:	83 ec 04             	sub    $0x4,%esp
    3a07:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3a0b:	6a 01                	push   $0x1
    3a0d:	50                   	push   %eax
    3a0e:	ff 75 08             	pushl  0x8(%ebp)
    3a11:	e8 1c fe ff ff       	call   3832 <write>
    3a16:	83 c4 0c             	add    $0xc,%esp
    3a19:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    3a1c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    3a1f:	6a 01                	push   $0x1
    3a21:	50                   	push   %eax
    3a22:	ff 75 08             	pushl  0x8(%ebp)
    3a25:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3a28:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    3a2a:	e8 03 fe ff ff       	call   3832 <write>
  for(i = 0; fmt[i]; i++){
    3a2f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    3a33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    3a36:	84 db                	test   %bl,%bl
    3a38:	75 89                	jne    39c3 <printf+0x53>
    }
  }
}
    3a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3a3d:	5b                   	pop    %ebx
    3a3e:	5e                   	pop    %esi
    3a3f:	5f                   	pop    %edi
    3a40:	5d                   	pop    %ebp
    3a41:	c3                   	ret    
    3a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    3a48:	bf 25 00 00 00       	mov    $0x25,%edi
    3a4d:	e9 66 ff ff ff       	jmp    39b8 <printf+0x48>
    3a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    3a58:	83 ec 0c             	sub    $0xc,%esp
    3a5b:	b9 10 00 00 00       	mov    $0x10,%ecx
    3a60:	6a 00                	push   $0x0
    3a62:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3a65:	8b 45 08             	mov    0x8(%ebp),%eax
    3a68:	8b 17                	mov    (%edi),%edx
    3a6a:	e8 61 fe ff ff       	call   38d0 <printint>
        ap++;
    3a6f:	89 f8                	mov    %edi,%eax
    3a71:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a74:	31 ff                	xor    %edi,%edi
        ap++;
    3a76:	83 c0 04             	add    $0x4,%eax
    3a79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3a7c:	e9 37 ff ff ff       	jmp    39b8 <printf+0x48>
    3a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    3a88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3a8b:	8b 08                	mov    (%eax),%ecx
        ap++;
    3a8d:	83 c0 04             	add    $0x4,%eax
    3a90:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    3a93:	85 c9                	test   %ecx,%ecx
    3a95:	0f 84 8e 00 00 00    	je     3b29 <printf+0x1b9>
        while(*s != 0){
    3a9b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    3a9e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    3aa0:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    3aa2:	84 c0                	test   %al,%al
    3aa4:	0f 84 0e ff ff ff    	je     39b8 <printf+0x48>
    3aaa:	89 75 d0             	mov    %esi,-0x30(%ebp)
    3aad:	89 de                	mov    %ebx,%esi
    3aaf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3ab2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    3ab5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    3ab8:	83 ec 04             	sub    $0x4,%esp
          s++;
    3abb:	83 c6 01             	add    $0x1,%esi
    3abe:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    3ac1:	6a 01                	push   $0x1
    3ac3:	57                   	push   %edi
    3ac4:	53                   	push   %ebx
    3ac5:	e8 68 fd ff ff       	call   3832 <write>
        while(*s != 0){
    3aca:	0f b6 06             	movzbl (%esi),%eax
    3acd:	83 c4 10             	add    $0x10,%esp
    3ad0:	84 c0                	test   %al,%al
    3ad2:	75 e4                	jne    3ab8 <printf+0x148>
    3ad4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    3ad7:	31 ff                	xor    %edi,%edi
    3ad9:	e9 da fe ff ff       	jmp    39b8 <printf+0x48>
    3ade:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    3ae0:	83 ec 0c             	sub    $0xc,%esp
    3ae3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3ae8:	6a 01                	push   $0x1
    3aea:	e9 73 ff ff ff       	jmp    3a62 <printf+0xf2>
    3aef:	90                   	nop
  write(fd, &c, 1);
    3af0:	83 ec 04             	sub    $0x4,%esp
    3af3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    3af6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    3af9:	6a 01                	push   $0x1
    3afb:	e9 21 ff ff ff       	jmp    3a21 <printf+0xb1>
        putc(fd, *ap);
    3b00:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    3b03:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3b06:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    3b08:	6a 01                	push   $0x1
        ap++;
    3b0a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    3b0d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    3b10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3b13:	50                   	push   %eax
    3b14:	ff 75 08             	pushl  0x8(%ebp)
    3b17:	e8 16 fd ff ff       	call   3832 <write>
        ap++;
    3b1c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    3b1f:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3b22:	31 ff                	xor    %edi,%edi
    3b24:	e9 8f fe ff ff       	jmp    39b8 <printf+0x48>
          s = "(null)";
    3b29:	bb 70 54 00 00       	mov    $0x5470,%ebx
        while(*s != 0){
    3b2e:	b8 28 00 00 00       	mov    $0x28,%eax
    3b33:	e9 72 ff ff ff       	jmp    3aaa <printf+0x13a>
    3b38:	66 90                	xchg   %ax,%ax
    3b3a:	66 90                	xchg   %ax,%ax
    3b3c:	66 90                	xchg   %ax,%ax
    3b3e:	66 90                	xchg   %ax,%ax

00003b40 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3b40:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b41:	a1 20 5e 00 00       	mov    0x5e20,%eax
{
    3b46:	89 e5                	mov    %esp,%ebp
    3b48:	57                   	push   %edi
    3b49:	56                   	push   %esi
    3b4a:	53                   	push   %ebx
    3b4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    3b4e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    3b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3b58:	39 c8                	cmp    %ecx,%eax
    3b5a:	8b 10                	mov    (%eax),%edx
    3b5c:	73 32                	jae    3b90 <free+0x50>
    3b5e:	39 d1                	cmp    %edx,%ecx
    3b60:	72 04                	jb     3b66 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3b62:	39 d0                	cmp    %edx,%eax
    3b64:	72 32                	jb     3b98 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3b66:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3b69:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3b6c:	39 fa                	cmp    %edi,%edx
    3b6e:	74 30                	je     3ba0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3b70:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3b73:	8b 50 04             	mov    0x4(%eax),%edx
    3b76:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3b79:	39 f1                	cmp    %esi,%ecx
    3b7b:	74 3a                	je     3bb7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3b7d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3b7f:	a3 20 5e 00 00       	mov    %eax,0x5e20
}
    3b84:	5b                   	pop    %ebx
    3b85:	5e                   	pop    %esi
    3b86:	5f                   	pop    %edi
    3b87:	5d                   	pop    %ebp
    3b88:	c3                   	ret    
    3b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3b90:	39 d0                	cmp    %edx,%eax
    3b92:	72 04                	jb     3b98 <free+0x58>
    3b94:	39 d1                	cmp    %edx,%ecx
    3b96:	72 ce                	jb     3b66 <free+0x26>
{
    3b98:	89 d0                	mov    %edx,%eax
    3b9a:	eb bc                	jmp    3b58 <free+0x18>
    3b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    3ba0:	03 72 04             	add    0x4(%edx),%esi
    3ba3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3ba6:	8b 10                	mov    (%eax),%edx
    3ba8:	8b 12                	mov    (%edx),%edx
    3baa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3bad:	8b 50 04             	mov    0x4(%eax),%edx
    3bb0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3bb3:	39 f1                	cmp    %esi,%ecx
    3bb5:	75 c6                	jne    3b7d <free+0x3d>
    p->s.size += bp->s.size;
    3bb7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3bba:	a3 20 5e 00 00       	mov    %eax,0x5e20
    p->s.size += bp->s.size;
    3bbf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3bc2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3bc5:	89 10                	mov    %edx,(%eax)
}
    3bc7:	5b                   	pop    %ebx
    3bc8:	5e                   	pop    %esi
    3bc9:	5f                   	pop    %edi
    3bca:	5d                   	pop    %ebp
    3bcb:	c3                   	ret    
    3bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003bd0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3bd0:	55                   	push   %ebp
    3bd1:	89 e5                	mov    %esp,%ebp
    3bd3:	57                   	push   %edi
    3bd4:	56                   	push   %esi
    3bd5:	53                   	push   %ebx
    3bd6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3bdc:	8b 15 20 5e 00 00    	mov    0x5e20,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3be2:	8d 78 07             	lea    0x7(%eax),%edi
    3be5:	c1 ef 03             	shr    $0x3,%edi
    3be8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    3beb:	85 d2                	test   %edx,%edx
    3bed:	0f 84 9d 00 00 00    	je     3c90 <malloc+0xc0>
    3bf3:	8b 02                	mov    (%edx),%eax
    3bf5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    3bf8:	39 cf                	cmp    %ecx,%edi
    3bfa:	76 6c                	jbe    3c68 <malloc+0x98>
    3bfc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    3c02:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3c07:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    3c0a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    3c11:	eb 0e                	jmp    3c21 <malloc+0x51>
    3c13:	90                   	nop
    3c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3c18:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3c1a:	8b 48 04             	mov    0x4(%eax),%ecx
    3c1d:	39 f9                	cmp    %edi,%ecx
    3c1f:	73 47                	jae    3c68 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3c21:	39 05 20 5e 00 00    	cmp    %eax,0x5e20
    3c27:	89 c2                	mov    %eax,%edx
    3c29:	75 ed                	jne    3c18 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    3c2b:	83 ec 0c             	sub    $0xc,%esp
    3c2e:	56                   	push   %esi
    3c2f:	e8 66 fc ff ff       	call   389a <sbrk>
  if(p == (char*)-1)
    3c34:	83 c4 10             	add    $0x10,%esp
    3c37:	83 f8 ff             	cmp    $0xffffffff,%eax
    3c3a:	74 1c                	je     3c58 <malloc+0x88>
  hp->s.size = nu;
    3c3c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3c3f:	83 ec 0c             	sub    $0xc,%esp
    3c42:	83 c0 08             	add    $0x8,%eax
    3c45:	50                   	push   %eax
    3c46:	e8 f5 fe ff ff       	call   3b40 <free>
  return freep;
    3c4b:	8b 15 20 5e 00 00    	mov    0x5e20,%edx
      if((p = morecore(nunits)) == 0)
    3c51:	83 c4 10             	add    $0x10,%esp
    3c54:	85 d2                	test   %edx,%edx
    3c56:	75 c0                	jne    3c18 <malloc+0x48>
        return 0;
  }
}
    3c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3c5b:	31 c0                	xor    %eax,%eax
}
    3c5d:	5b                   	pop    %ebx
    3c5e:	5e                   	pop    %esi
    3c5f:	5f                   	pop    %edi
    3c60:	5d                   	pop    %ebp
    3c61:	c3                   	ret    
    3c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    3c68:	39 cf                	cmp    %ecx,%edi
    3c6a:	74 54                	je     3cc0 <malloc+0xf0>
        p->s.size -= nunits;
    3c6c:	29 f9                	sub    %edi,%ecx
    3c6e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3c71:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3c74:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    3c77:	89 15 20 5e 00 00    	mov    %edx,0x5e20
}
    3c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3c80:	83 c0 08             	add    $0x8,%eax
}
    3c83:	5b                   	pop    %ebx
    3c84:	5e                   	pop    %esi
    3c85:	5f                   	pop    %edi
    3c86:	5d                   	pop    %ebp
    3c87:	c3                   	ret    
    3c88:	90                   	nop
    3c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    3c90:	c7 05 20 5e 00 00 24 	movl   $0x5e24,0x5e20
    3c97:	5e 00 00 
    3c9a:	c7 05 24 5e 00 00 24 	movl   $0x5e24,0x5e24
    3ca1:	5e 00 00 
    base.s.size = 0;
    3ca4:	b8 24 5e 00 00       	mov    $0x5e24,%eax
    3ca9:	c7 05 28 5e 00 00 00 	movl   $0x0,0x5e28
    3cb0:	00 00 00 
    3cb3:	e9 44 ff ff ff       	jmp    3bfc <malloc+0x2c>
    3cb8:	90                   	nop
    3cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    3cc0:	8b 08                	mov    (%eax),%ecx
    3cc2:	89 0a                	mov    %ecx,(%edx)
    3cc4:	eb b1                	jmp    3c77 <malloc+0xa7>
