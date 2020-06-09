
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
      11:	68 66 4d 00 00       	push   $0x4d66
      16:	6a 01                	push   $0x1
      18:	e8 f3 39 00 00       	call   3a10 <printf>

  if(open("usertests.ran", 0) >= 0){
      1d:	59                   	pop    %ecx
      1e:	58                   	pop    %eax
      1f:	6a 00                	push   $0x0
      21:	68 7a 4d 00 00       	push   $0x4d7a
      26:	e8 c7 38 00 00       	call   38f2 <open>
      2b:	83 c4 10             	add    $0x10,%esp
      2e:	85 c0                	test   %eax,%eax
      30:	78 13                	js     45 <main+0x45>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      32:	52                   	push   %edx
      33:	52                   	push   %edx
      34:	68 e4 54 00 00       	push   $0x54e4
      39:	6a 01                	push   $0x1
      3b:	e8 d0 39 00 00       	call   3a10 <printf>
    exit();
      40:	e8 6d 38 00 00       	call   38b2 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      45:	50                   	push   %eax
      46:	50                   	push   %eax
      47:	68 00 02 00 00       	push   $0x200
      4c:	68 7a 4d 00 00       	push   $0x4d7a
      51:	e8 9c 38 00 00       	call   38f2 <open>
      56:	89 04 24             	mov    %eax,(%esp)
      59:	e8 7c 38 00 00       	call   38da <close>

  argptest();
      5e:	e8 6d 35 00 00       	call   35d0 <argptest>
  createdelete();
      63:	e8 b8 11 00 00       	call   1220 <createdelete>
  linkunlink();
      68:	e8 73 1a 00 00       	call   1ae0 <linkunlink>
  concreate();
      6d:	e8 6e 17 00 00       	call   17e0 <concreate>
  fourfiles();
      72:	e8 89 0f 00 00       	call   1000 <fourfiles>
  sharedfd();
      77:	e8 c4 0d 00 00       	call   e40 <sharedfd>

  bigargtest();
      7c:	e8 0f 32 00 00       	call   3290 <bigargtest>
  bigwrite();
      81:	e8 7a 23 00 00       	call   2400 <bigwrite>
  bigargtest();
      86:	e8 05 32 00 00       	call   3290 <bigargtest>
  bsstest();
      8b:	e8 80 31 00 00       	call   3210 <bsstest>
  // sbrktest();
  validatetest();
      90:	e8 cb 30 00 00       	call   3160 <validatetest>

  opentest();
      95:	e8 46 03 00 00       	call   3e0 <opentest>
  writetest();
      9a:	e8 d1 03 00 00       	call   470 <writetest>
  writetest1();
      9f:	e8 ac 05 00 00       	call   650 <writetest1>
  createtest();
      a4:	e8 77 07 00 00       	call   820 <createtest>

  openiputtest();
      a9:	e8 32 02 00 00       	call   2e0 <openiputtest>
  exitiputtest();
      ae:	e8 3d 01 00 00       	call   1f0 <exitiputtest>
  iputtest();
      b3:	e8 58 00 00 00       	call   110 <iputtest>

  // mem();
  pipe1();
      b8:	e8 43 09 00 00       	call   a00 <pipe1>
  // preempt();
  exitwait();
      bd:	e8 1e 0c 00 00       	call   ce0 <exitwait>

  rmdot();
      c2:	e8 29 27 00 00       	call   27f0 <rmdot>
  fourteen();
      c7:	e8 e4 25 00 00       	call   26b0 <fourteen>
  bigfile();
      cc:	e8 0f 24 00 00       	call   24e0 <bigfile>
  subdir();
      d1:	e8 4a 1c 00 00       	call   1d20 <subdir>
  linktest();
      d6:	e8 f5 14 00 00       	call   15d0 <linktest>
  unlinkread();
      db:	e8 60 13 00 00       	call   1440 <unlinkread>
  dirfile();
      e0:	e8 8b 28 00 00       	call   2970 <dirfile>
  iref();
      e5:	e8 86 2a 00 00       	call   2b70 <iref>
  forktest();  
      ea:	e8 a1 2b 00 00       	call   2c90 <forktest>
  bigdir();
      ef:	e8 fc 1a 00 00       	call   1bf0 <bigdir>

  uio();
      f4:	e8 67 34 00 00       	call   3560 <uio>

  exectest();
      f9:	e8 b2 08 00 00       	call   9b0 <exectest>

  exit();
      fe:	e8 af 37 00 00       	call   38b2 <exit>
     103:	66 90                	xchg   %ax,%ax
     105:	66 90                	xchg   %ax,%ax
     107:	66 90                	xchg   %ax,%ax
     109:	66 90                	xchg   %ax,%ax
     10b:	66 90                	xchg   %ax,%ax
     10d:	66 90                	xchg   %ax,%ax
     10f:	90                   	nop

00000110 <iputtest>:
{
     110:	55                   	push   %ebp
     111:	89 e5                	mov    %esp,%ebp
     113:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
     116:	68 fc 3d 00 00       	push   $0x3dfc
     11b:	ff 35 28 5e 00 00    	pushl  0x5e28
     121:	e8 ea 38 00 00       	call   3a10 <printf>
  if(mkdir("iputdir") < 0){
     126:	c7 04 24 8f 3d 00 00 	movl   $0x3d8f,(%esp)
     12d:	e8 e8 37 00 00       	call   391a <mkdir>
     132:	83 c4 10             	add    $0x10,%esp
     135:	85 c0                	test   %eax,%eax
     137:	78 58                	js     191 <iputtest+0x81>
  if(chdir("iputdir") < 0){
     139:	83 ec 0c             	sub    $0xc,%esp
     13c:	68 8f 3d 00 00       	push   $0x3d8f
     141:	e8 dc 37 00 00       	call   3922 <chdir>
     146:	83 c4 10             	add    $0x10,%esp
     149:	85 c0                	test   %eax,%eax
     14b:	0f 88 85 00 00 00    	js     1d6 <iputtest+0xc6>
  if(unlink("../iputdir") < 0){
     151:	83 ec 0c             	sub    $0xc,%esp
     154:	68 8c 3d 00 00       	push   $0x3d8c
     159:	e8 a4 37 00 00       	call   3902 <unlink>
     15e:	83 c4 10             	add    $0x10,%esp
     161:	85 c0                	test   %eax,%eax
     163:	78 5a                	js     1bf <iputtest+0xaf>
  if(chdir("/") < 0){
     165:	83 ec 0c             	sub    $0xc,%esp
     168:	68 b1 3d 00 00       	push   $0x3db1
     16d:	e8 b0 37 00 00       	call   3922 <chdir>
     172:	83 c4 10             	add    $0x10,%esp
     175:	85 c0                	test   %eax,%eax
     177:	78 2f                	js     1a8 <iputtest+0x98>
  printf(stdout, "iput test ok\n");
     179:	83 ec 08             	sub    $0x8,%esp
     17c:	68 34 3e 00 00       	push   $0x3e34
     181:	ff 35 28 5e 00 00    	pushl  0x5e28
     187:	e8 84 38 00 00       	call   3a10 <printf>
}
     18c:	83 c4 10             	add    $0x10,%esp
     18f:	c9                   	leave  
     190:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     191:	50                   	push   %eax
     192:	50                   	push   %eax
     193:	68 68 3d 00 00       	push   $0x3d68
     198:	ff 35 28 5e 00 00    	pushl  0x5e28
     19e:	e8 6d 38 00 00       	call   3a10 <printf>
    exit();
     1a3:	e8 0a 37 00 00       	call   38b2 <exit>
    printf(stdout, "chdir / failed\n");
     1a8:	50                   	push   %eax
     1a9:	50                   	push   %eax
     1aa:	68 b3 3d 00 00       	push   $0x3db3
     1af:	ff 35 28 5e 00 00    	pushl  0x5e28
     1b5:	e8 56 38 00 00       	call   3a10 <printf>
    exit();
     1ba:	e8 f3 36 00 00       	call   38b2 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1bf:	52                   	push   %edx
     1c0:	52                   	push   %edx
     1c1:	68 97 3d 00 00       	push   $0x3d97
     1c6:	ff 35 28 5e 00 00    	pushl  0x5e28
     1cc:	e8 3f 38 00 00       	call   3a10 <printf>
    exit();
     1d1:	e8 dc 36 00 00       	call   38b2 <exit>
    printf(stdout, "chdir iputdir failed\n");
     1d6:	51                   	push   %ecx
     1d7:	51                   	push   %ecx
     1d8:	68 76 3d 00 00       	push   $0x3d76
     1dd:	ff 35 28 5e 00 00    	pushl  0x5e28
     1e3:	e8 28 38 00 00       	call   3a10 <printf>
    exit();
     1e8:	e8 c5 36 00 00       	call   38b2 <exit>
     1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <exitiputtest>:
{
     1f0:	55                   	push   %ebp
     1f1:	89 e5                	mov    %esp,%ebp
     1f3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     1f6:	68 c3 3d 00 00       	push   $0x3dc3
     1fb:	ff 35 28 5e 00 00    	pushl  0x5e28
     201:	e8 0a 38 00 00       	call   3a10 <printf>
  pid = fork();
     206:	e8 9f 36 00 00       	call   38aa <fork>
  if(pid < 0){
     20b:	83 c4 10             	add    $0x10,%esp
     20e:	85 c0                	test   %eax,%eax
     210:	0f 88 82 00 00 00    	js     298 <exitiputtest+0xa8>
  if(pid == 0){
     216:	75 48                	jne    260 <exitiputtest+0x70>
    if(mkdir("iputdir") < 0){
     218:	83 ec 0c             	sub    $0xc,%esp
     21b:	68 8f 3d 00 00       	push   $0x3d8f
     220:	e8 f5 36 00 00       	call   391a <mkdir>
     225:	83 c4 10             	add    $0x10,%esp
     228:	85 c0                	test   %eax,%eax
     22a:	0f 88 96 00 00 00    	js     2c6 <exitiputtest+0xd6>
    if(chdir("iputdir") < 0){
     230:	83 ec 0c             	sub    $0xc,%esp
     233:	68 8f 3d 00 00       	push   $0x3d8f
     238:	e8 e5 36 00 00       	call   3922 <chdir>
     23d:	83 c4 10             	add    $0x10,%esp
     240:	85 c0                	test   %eax,%eax
     242:	78 6b                	js     2af <exitiputtest+0xbf>
    if(unlink("../iputdir") < 0){
     244:	83 ec 0c             	sub    $0xc,%esp
     247:	68 8c 3d 00 00       	push   $0x3d8c
     24c:	e8 b1 36 00 00       	call   3902 <unlink>
     251:	83 c4 10             	add    $0x10,%esp
     254:	85 c0                	test   %eax,%eax
     256:	78 28                	js     280 <exitiputtest+0x90>
    exit();
     258:	e8 55 36 00 00       	call   38b2 <exit>
     25d:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     260:	e8 55 36 00 00       	call   38ba <wait>
  printf(stdout, "exitiput test ok\n");
     265:	83 ec 08             	sub    $0x8,%esp
     268:	68 e6 3d 00 00       	push   $0x3de6
     26d:	ff 35 28 5e 00 00    	pushl  0x5e28
     273:	e8 98 37 00 00       	call   3a10 <printf>
}
     278:	83 c4 10             	add    $0x10,%esp
     27b:	c9                   	leave  
     27c:	c3                   	ret    
     27d:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     280:	83 ec 08             	sub    $0x8,%esp
     283:	68 97 3d 00 00       	push   $0x3d97
     288:	ff 35 28 5e 00 00    	pushl  0x5e28
     28e:	e8 7d 37 00 00       	call   3a10 <printf>
      exit();
     293:	e8 1a 36 00 00       	call   38b2 <exit>
    printf(stdout, "fork failed\n");
     298:	51                   	push   %ecx
     299:	51                   	push   %ecx
     29a:	68 b9 4c 00 00       	push   $0x4cb9
     29f:	ff 35 28 5e 00 00    	pushl  0x5e28
     2a5:	e8 66 37 00 00       	call   3a10 <printf>
    exit();
     2aa:	e8 03 36 00 00       	call   38b2 <exit>
      printf(stdout, "child chdir failed\n");
     2af:	50                   	push   %eax
     2b0:	50                   	push   %eax
     2b1:	68 d2 3d 00 00       	push   $0x3dd2
     2b6:	ff 35 28 5e 00 00    	pushl  0x5e28
     2bc:	e8 4f 37 00 00       	call   3a10 <printf>
      exit();
     2c1:	e8 ec 35 00 00       	call   38b2 <exit>
      printf(stdout, "mkdir failed\n");
     2c6:	52                   	push   %edx
     2c7:	52                   	push   %edx
     2c8:	68 68 3d 00 00       	push   $0x3d68
     2cd:	ff 35 28 5e 00 00    	pushl  0x5e28
     2d3:	e8 38 37 00 00       	call   3a10 <printf>
      exit();
     2d8:	e8 d5 35 00 00       	call   38b2 <exit>
     2dd:	8d 76 00             	lea    0x0(%esi),%esi

000002e0 <openiputtest>:
{
     2e0:	55                   	push   %ebp
     2e1:	89 e5                	mov    %esp,%ebp
     2e3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     2e6:	68 f8 3d 00 00       	push   $0x3df8
     2eb:	ff 35 28 5e 00 00    	pushl  0x5e28
     2f1:	e8 1a 37 00 00       	call   3a10 <printf>
  if(mkdir("oidir") < 0){
     2f6:	c7 04 24 07 3e 00 00 	movl   $0x3e07,(%esp)
     2fd:	e8 18 36 00 00       	call   391a <mkdir>
     302:	83 c4 10             	add    $0x10,%esp
     305:	85 c0                	test   %eax,%eax
     307:	0f 88 88 00 00 00    	js     395 <openiputtest+0xb5>
  pid = fork();
     30d:	e8 98 35 00 00       	call   38aa <fork>
  if(pid < 0){
     312:	85 c0                	test   %eax,%eax
     314:	0f 88 92 00 00 00    	js     3ac <openiputtest+0xcc>
  if(pid == 0){
     31a:	75 34                	jne    350 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     31c:	83 ec 08             	sub    $0x8,%esp
     31f:	6a 02                	push   $0x2
     321:	68 07 3e 00 00       	push   $0x3e07
     326:	e8 c7 35 00 00       	call   38f2 <open>
    if(fd >= 0){
     32b:	83 c4 10             	add    $0x10,%esp
     32e:	85 c0                	test   %eax,%eax
     330:	78 5e                	js     390 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     332:	83 ec 08             	sub    $0x8,%esp
     335:	68 9c 4d 00 00       	push   $0x4d9c
     33a:	ff 35 28 5e 00 00    	pushl  0x5e28
     340:	e8 cb 36 00 00       	call   3a10 <printf>
      exit();
     345:	e8 68 35 00 00       	call   38b2 <exit>
     34a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
     350:	83 ec 0c             	sub    $0xc,%esp
     353:	6a 01                	push   $0x1
     355:	e8 e8 35 00 00       	call   3942 <sleep>
  if(unlink("oidir") != 0){
     35a:	c7 04 24 07 3e 00 00 	movl   $0x3e07,(%esp)
     361:	e8 9c 35 00 00       	call   3902 <unlink>
     366:	83 c4 10             	add    $0x10,%esp
     369:	85 c0                	test   %eax,%eax
     36b:	75 56                	jne    3c3 <openiputtest+0xe3>
  wait();
     36d:	e8 48 35 00 00       	call   38ba <wait>
  printf(stdout, "openiput test ok\n");
     372:	83 ec 08             	sub    $0x8,%esp
     375:	68 30 3e 00 00       	push   $0x3e30
     37a:	ff 35 28 5e 00 00    	pushl  0x5e28
     380:	e8 8b 36 00 00       	call   3a10 <printf>
     385:	83 c4 10             	add    $0x10,%esp
}
     388:	c9                   	leave  
     389:	c3                   	ret    
     38a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     390:	e8 1d 35 00 00       	call   38b2 <exit>
    printf(stdout, "mkdir oidir failed\n");
     395:	51                   	push   %ecx
     396:	51                   	push   %ecx
     397:	68 0d 3e 00 00       	push   $0x3e0d
     39c:	ff 35 28 5e 00 00    	pushl  0x5e28
     3a2:	e8 69 36 00 00       	call   3a10 <printf>
    exit();
     3a7:	e8 06 35 00 00       	call   38b2 <exit>
    printf(stdout, "fork failed\n");
     3ac:	52                   	push   %edx
     3ad:	52                   	push   %edx
     3ae:	68 b9 4c 00 00       	push   $0x4cb9
     3b3:	ff 35 28 5e 00 00    	pushl  0x5e28
     3b9:	e8 52 36 00 00       	call   3a10 <printf>
    exit();
     3be:	e8 ef 34 00 00       	call   38b2 <exit>
    printf(stdout, "unlink failed\n");
     3c3:	50                   	push   %eax
     3c4:	50                   	push   %eax
     3c5:	68 21 3e 00 00       	push   $0x3e21
     3ca:	ff 35 28 5e 00 00    	pushl  0x5e28
     3d0:	e8 3b 36 00 00       	call   3a10 <printf>
    exit();
     3d5:	e8 d8 34 00 00       	call   38b2 <exit>
     3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <opentest>:
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     3e6:	68 42 3e 00 00       	push   $0x3e42
     3eb:	ff 35 28 5e 00 00    	pushl  0x5e28
     3f1:	e8 1a 36 00 00       	call   3a10 <printf>
  fd = open("echo", 0);
     3f6:	58                   	pop    %eax
     3f7:	5a                   	pop    %edx
     3f8:	6a 00                	push   $0x0
     3fa:	68 4d 3e 00 00       	push   $0x3e4d
     3ff:	e8 ee 34 00 00       	call   38f2 <open>
  if(fd < 0){
     404:	83 c4 10             	add    $0x10,%esp
     407:	85 c0                	test   %eax,%eax
     409:	78 36                	js     441 <opentest+0x61>
  close(fd);
     40b:	83 ec 0c             	sub    $0xc,%esp
     40e:	50                   	push   %eax
     40f:	e8 c6 34 00 00       	call   38da <close>
  fd = open("doesnotexist", 0);
     414:	5a                   	pop    %edx
     415:	59                   	pop    %ecx
     416:	6a 00                	push   $0x0
     418:	68 65 3e 00 00       	push   $0x3e65
     41d:	e8 d0 34 00 00       	call   38f2 <open>
  if(fd >= 0){
     422:	83 c4 10             	add    $0x10,%esp
     425:	85 c0                	test   %eax,%eax
     427:	79 2f                	jns    458 <opentest+0x78>
  printf(stdout, "open test ok\n");
     429:	83 ec 08             	sub    $0x8,%esp
     42c:	68 90 3e 00 00       	push   $0x3e90
     431:	ff 35 28 5e 00 00    	pushl  0x5e28
     437:	e8 d4 35 00 00       	call   3a10 <printf>
}
     43c:	83 c4 10             	add    $0x10,%esp
     43f:	c9                   	leave  
     440:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     441:	50                   	push   %eax
     442:	50                   	push   %eax
     443:	68 52 3e 00 00       	push   $0x3e52
     448:	ff 35 28 5e 00 00    	pushl  0x5e28
     44e:	e8 bd 35 00 00       	call   3a10 <printf>
    exit();
     453:	e8 5a 34 00 00       	call   38b2 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     458:	50                   	push   %eax
     459:	50                   	push   %eax
     45a:	68 72 3e 00 00       	push   $0x3e72
     45f:	ff 35 28 5e 00 00    	pushl  0x5e28
     465:	e8 a6 35 00 00       	call   3a10 <printf>
    exit();
     46a:	e8 43 34 00 00       	call   38b2 <exit>
     46f:	90                   	nop

00000470 <writetest>:
{
     470:	55                   	push   %ebp
     471:	89 e5                	mov    %esp,%ebp
     473:	56                   	push   %esi
     474:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     475:	83 ec 08             	sub    $0x8,%esp
     478:	68 9e 3e 00 00       	push   $0x3e9e
     47d:	ff 35 28 5e 00 00    	pushl  0x5e28
     483:	e8 88 35 00 00       	call   3a10 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     488:	58                   	pop    %eax
     489:	5a                   	pop    %edx
     48a:	68 02 02 00 00       	push   $0x202
     48f:	68 af 3e 00 00       	push   $0x3eaf
     494:	e8 59 34 00 00       	call   38f2 <open>
  if(fd >= 0){
     499:	83 c4 10             	add    $0x10,%esp
     49c:	85 c0                	test   %eax,%eax
     49e:	0f 88 88 01 00 00    	js     62c <writetest+0x1bc>
    printf(stdout, "creat small succeeded; ok\n");
     4a4:	83 ec 08             	sub    $0x8,%esp
     4a7:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     4a9:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     4ab:	68 b5 3e 00 00       	push   $0x3eb5
     4b0:	ff 35 28 5e 00 00    	pushl  0x5e28
     4b6:	e8 55 35 00 00       	call   3a10 <printf>
     4bb:	83 c4 10             	add    $0x10,%esp
     4be:	66 90                	xchg   %ax,%ax
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4c0:	83 ec 04             	sub    $0x4,%esp
     4c3:	6a 0a                	push   $0xa
     4c5:	68 ec 3e 00 00       	push   $0x3eec
     4ca:	56                   	push   %esi
     4cb:	e8 02 34 00 00       	call   38d2 <write>
     4d0:	83 c4 10             	add    $0x10,%esp
     4d3:	83 f8 0a             	cmp    $0xa,%eax
     4d6:	0f 85 d9 00 00 00    	jne    5b5 <writetest+0x145>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     4dc:	83 ec 04             	sub    $0x4,%esp
     4df:	6a 0a                	push   $0xa
     4e1:	68 f7 3e 00 00       	push   $0x3ef7
     4e6:	56                   	push   %esi
     4e7:	e8 e6 33 00 00       	call   38d2 <write>
     4ec:	83 c4 10             	add    $0x10,%esp
     4ef:	83 f8 0a             	cmp    $0xa,%eax
     4f2:	0f 85 d6 00 00 00    	jne    5ce <writetest+0x15e>
  for(i = 0; i < 100; i++){
     4f8:	83 c3 01             	add    $0x1,%ebx
     4fb:	83 fb 64             	cmp    $0x64,%ebx
     4fe:	75 c0                	jne    4c0 <writetest+0x50>
  printf(stdout, "writes ok\n");
     500:	83 ec 08             	sub    $0x8,%esp
     503:	68 02 3f 00 00       	push   $0x3f02
     508:	ff 35 28 5e 00 00    	pushl  0x5e28
     50e:	e8 fd 34 00 00       	call   3a10 <printf>
  close(fd);
     513:	89 34 24             	mov    %esi,(%esp)
     516:	e8 bf 33 00 00       	call   38da <close>
  fd = open("small", O_RDONLY);
     51b:	5b                   	pop    %ebx
     51c:	5e                   	pop    %esi
     51d:	6a 00                	push   $0x0
     51f:	68 af 3e 00 00       	push   $0x3eaf
     524:	e8 c9 33 00 00       	call   38f2 <open>
  if(fd >= 0){
     529:	83 c4 10             	add    $0x10,%esp
     52c:	85 c0                	test   %eax,%eax
  fd = open("small", O_RDONLY);
     52e:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     530:	0f 88 b1 00 00 00    	js     5e7 <writetest+0x177>
    printf(stdout, "open small succeeded ok\n");
     536:	83 ec 08             	sub    $0x8,%esp
     539:	68 0d 3f 00 00       	push   $0x3f0d
     53e:	ff 35 28 5e 00 00    	pushl  0x5e28
     544:	e8 c7 34 00 00       	call   3a10 <printf>
  i = read(fd, buf, 2000);
     549:	83 c4 0c             	add    $0xc,%esp
     54c:	68 d0 07 00 00       	push   $0x7d0
     551:	68 00 86 00 00       	push   $0x8600
     556:	53                   	push   %ebx
     557:	e8 6e 33 00 00       	call   38ca <read>
  if(i == 2000){
     55c:	83 c4 10             	add    $0x10,%esp
     55f:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     564:	0f 85 94 00 00 00    	jne    5fe <writetest+0x18e>
    printf(stdout, "read succeeded ok\n");
     56a:	83 ec 08             	sub    $0x8,%esp
     56d:	68 41 3f 00 00       	push   $0x3f41
     572:	ff 35 28 5e 00 00    	pushl  0x5e28
     578:	e8 93 34 00 00       	call   3a10 <printf>
  close(fd);
     57d:	89 1c 24             	mov    %ebx,(%esp)
     580:	e8 55 33 00 00       	call   38da <close>
  if(unlink("small") < 0){
     585:	c7 04 24 af 3e 00 00 	movl   $0x3eaf,(%esp)
     58c:	e8 71 33 00 00       	call   3902 <unlink>
     591:	83 c4 10             	add    $0x10,%esp
     594:	85 c0                	test   %eax,%eax
     596:	78 7d                	js     615 <writetest+0x1a5>
  printf(stdout, "small file test ok\n");
     598:	83 ec 08             	sub    $0x8,%esp
     59b:	68 69 3f 00 00       	push   $0x3f69
     5a0:	ff 35 28 5e 00 00    	pushl  0x5e28
     5a6:	e8 65 34 00 00       	call   3a10 <printf>
}
     5ab:	83 c4 10             	add    $0x10,%esp
     5ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5b1:	5b                   	pop    %ebx
     5b2:	5e                   	pop    %esi
     5b3:	5d                   	pop    %ebp
     5b4:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     5b5:	83 ec 04             	sub    $0x4,%esp
     5b8:	53                   	push   %ebx
     5b9:	68 c0 4d 00 00       	push   $0x4dc0
     5be:	ff 35 28 5e 00 00    	pushl  0x5e28
     5c4:	e8 47 34 00 00       	call   3a10 <printf>
      exit();
     5c9:	e8 e4 32 00 00       	call   38b2 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     5ce:	83 ec 04             	sub    $0x4,%esp
     5d1:	53                   	push   %ebx
     5d2:	68 e4 4d 00 00       	push   $0x4de4
     5d7:	ff 35 28 5e 00 00    	pushl  0x5e28
     5dd:	e8 2e 34 00 00       	call   3a10 <printf>
      exit();
     5e2:	e8 cb 32 00 00       	call   38b2 <exit>
    printf(stdout, "error: open small failed!\n");
     5e7:	51                   	push   %ecx
     5e8:	51                   	push   %ecx
     5e9:	68 26 3f 00 00       	push   $0x3f26
     5ee:	ff 35 28 5e 00 00    	pushl  0x5e28
     5f4:	e8 17 34 00 00       	call   3a10 <printf>
    exit();
     5f9:	e8 b4 32 00 00       	call   38b2 <exit>
    printf(stdout, "read failed\n");
     5fe:	52                   	push   %edx
     5ff:	52                   	push   %edx
     600:	68 7d 42 00 00       	push   $0x427d
     605:	ff 35 28 5e 00 00    	pushl  0x5e28
     60b:	e8 00 34 00 00       	call   3a10 <printf>
    exit();
     610:	e8 9d 32 00 00       	call   38b2 <exit>
    printf(stdout, "unlink small failed\n");
     615:	50                   	push   %eax
     616:	50                   	push   %eax
     617:	68 54 3f 00 00       	push   $0x3f54
     61c:	ff 35 28 5e 00 00    	pushl  0x5e28
     622:	e8 e9 33 00 00       	call   3a10 <printf>
    exit();
     627:	e8 86 32 00 00       	call   38b2 <exit>
    printf(stdout, "error: creat small failed!\n");
     62c:	50                   	push   %eax
     62d:	50                   	push   %eax
     62e:	68 d0 3e 00 00       	push   $0x3ed0
     633:	ff 35 28 5e 00 00    	pushl  0x5e28
     639:	e8 d2 33 00 00       	call   3a10 <printf>
    exit();
     63e:	e8 6f 32 00 00       	call   38b2 <exit>
     643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000650 <writetest1>:
{
     650:	55                   	push   %ebp
     651:	89 e5                	mov    %esp,%ebp
     653:	56                   	push   %esi
     654:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     655:	83 ec 08             	sub    $0x8,%esp
     658:	68 7d 3f 00 00       	push   $0x3f7d
     65d:	ff 35 28 5e 00 00    	pushl  0x5e28
     663:	e8 a8 33 00 00       	call   3a10 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     668:	58                   	pop    %eax
     669:	5a                   	pop    %edx
     66a:	68 02 02 00 00       	push   $0x202
     66f:	68 f7 3f 00 00       	push   $0x3ff7
     674:	e8 79 32 00 00       	call   38f2 <open>
  if(fd < 0){
     679:	83 c4 10             	add    $0x10,%esp
     67c:	85 c0                	test   %eax,%eax
     67e:	0f 88 61 01 00 00    	js     7e5 <writetest1+0x195>
     684:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     686:	31 db                	xor    %ebx,%ebx
     688:	90                   	nop
     689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     690:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     693:	89 1d 00 86 00 00    	mov    %ebx,0x8600
    if(write(fd, buf, 512) != 512){
     699:	68 00 02 00 00       	push   $0x200
     69e:	68 00 86 00 00       	push   $0x8600
     6a3:	56                   	push   %esi
     6a4:	e8 29 32 00 00       	call   38d2 <write>
     6a9:	83 c4 10             	add    $0x10,%esp
     6ac:	3d 00 02 00 00       	cmp    $0x200,%eax
     6b1:	0f 85 b3 00 00 00    	jne    76a <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     6b7:	83 c3 01             	add    $0x1,%ebx
     6ba:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     6c0:	75 ce                	jne    690 <writetest1+0x40>
  close(fd);
     6c2:	83 ec 0c             	sub    $0xc,%esp
     6c5:	56                   	push   %esi
     6c6:	e8 0f 32 00 00       	call   38da <close>
  fd = open("big", O_RDONLY);
     6cb:	5b                   	pop    %ebx
     6cc:	5e                   	pop    %esi
     6cd:	6a 00                	push   $0x0
     6cf:	68 f7 3f 00 00       	push   $0x3ff7
     6d4:	e8 19 32 00 00       	call   38f2 <open>
  if(fd < 0){
     6d9:	83 c4 10             	add    $0x10,%esp
     6dc:	85 c0                	test   %eax,%eax
  fd = open("big", O_RDONLY);
     6de:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     6e0:	0f 88 e8 00 00 00    	js     7ce <writetest1+0x17e>
  n = 0;
     6e6:	31 db                	xor    %ebx,%ebx
     6e8:	eb 1d                	jmp    707 <writetest1+0xb7>
     6ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     6f0:	3d 00 02 00 00       	cmp    $0x200,%eax
     6f5:	0f 85 9f 00 00 00    	jne    79a <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     6fb:	a1 00 86 00 00       	mov    0x8600,%eax
     700:	39 d8                	cmp    %ebx,%eax
     702:	75 7f                	jne    783 <writetest1+0x133>
    n++;
     704:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     707:	83 ec 04             	sub    $0x4,%esp
     70a:	68 00 02 00 00       	push   $0x200
     70f:	68 00 86 00 00       	push   $0x8600
     714:	56                   	push   %esi
     715:	e8 b0 31 00 00       	call   38ca <read>
    if(i == 0){
     71a:	83 c4 10             	add    $0x10,%esp
     71d:	85 c0                	test   %eax,%eax
     71f:	75 cf                	jne    6f0 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     721:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     727:	0f 84 86 00 00 00    	je     7b3 <writetest1+0x163>
  close(fd);
     72d:	83 ec 0c             	sub    $0xc,%esp
     730:	56                   	push   %esi
     731:	e8 a4 31 00 00       	call   38da <close>
  if(unlink("big") < 0){
     736:	c7 04 24 f7 3f 00 00 	movl   $0x3ff7,(%esp)
     73d:	e8 c0 31 00 00       	call   3902 <unlink>
     742:	83 c4 10             	add    $0x10,%esp
     745:	85 c0                	test   %eax,%eax
     747:	0f 88 af 00 00 00    	js     7fc <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     74d:	83 ec 08             	sub    $0x8,%esp
     750:	68 1e 40 00 00       	push   $0x401e
     755:	ff 35 28 5e 00 00    	pushl  0x5e28
     75b:	e8 b0 32 00 00       	call   3a10 <printf>
}
     760:	83 c4 10             	add    $0x10,%esp
     763:	8d 65 f8             	lea    -0x8(%ebp),%esp
     766:	5b                   	pop    %ebx
     767:	5e                   	pop    %esi
     768:	5d                   	pop    %ebp
     769:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     76a:	83 ec 04             	sub    $0x4,%esp
     76d:	53                   	push   %ebx
     76e:	68 a7 3f 00 00       	push   $0x3fa7
     773:	ff 35 28 5e 00 00    	pushl  0x5e28
     779:	e8 92 32 00 00       	call   3a10 <printf>
      exit();
     77e:	e8 2f 31 00 00       	call   38b2 <exit>
      printf(stdout, "read content of block %d is %d\n",
     783:	50                   	push   %eax
     784:	53                   	push   %ebx
     785:	68 08 4e 00 00       	push   $0x4e08
     78a:	ff 35 28 5e 00 00    	pushl  0x5e28
     790:	e8 7b 32 00 00       	call   3a10 <printf>
      exit();
     795:	e8 18 31 00 00       	call   38b2 <exit>
      printf(stdout, "read failed %d\n", i);
     79a:	83 ec 04             	sub    $0x4,%esp
     79d:	50                   	push   %eax
     79e:	68 fb 3f 00 00       	push   $0x3ffb
     7a3:	ff 35 28 5e 00 00    	pushl  0x5e28
     7a9:	e8 62 32 00 00       	call   3a10 <printf>
      exit();
     7ae:	e8 ff 30 00 00       	call   38b2 <exit>
        printf(stdout, "read only %d blocks from big", n);
     7b3:	52                   	push   %edx
     7b4:	68 8b 00 00 00       	push   $0x8b
     7b9:	68 de 3f 00 00       	push   $0x3fde
     7be:	ff 35 28 5e 00 00    	pushl  0x5e28
     7c4:	e8 47 32 00 00       	call   3a10 <printf>
        exit();
     7c9:	e8 e4 30 00 00       	call   38b2 <exit>
    printf(stdout, "error: open big failed!\n");
     7ce:	51                   	push   %ecx
     7cf:	51                   	push   %ecx
     7d0:	68 c5 3f 00 00       	push   $0x3fc5
     7d5:	ff 35 28 5e 00 00    	pushl  0x5e28
     7db:	e8 30 32 00 00       	call   3a10 <printf>
    exit();
     7e0:	e8 cd 30 00 00       	call   38b2 <exit>
    printf(stdout, "error: creat big failed!\n");
     7e5:	50                   	push   %eax
     7e6:	50                   	push   %eax
     7e7:	68 8d 3f 00 00       	push   $0x3f8d
     7ec:	ff 35 28 5e 00 00    	pushl  0x5e28
     7f2:	e8 19 32 00 00       	call   3a10 <printf>
    exit();
     7f7:	e8 b6 30 00 00       	call   38b2 <exit>
    printf(stdout, "unlink big failed\n");
     7fc:	50                   	push   %eax
     7fd:	50                   	push   %eax
     7fe:	68 0b 40 00 00       	push   $0x400b
     803:	ff 35 28 5e 00 00    	pushl  0x5e28
     809:	e8 02 32 00 00       	call   3a10 <printf>
    exit();
     80e:	e8 9f 30 00 00       	call   38b2 <exit>
     813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000820 <createtest>:
{
     820:	55                   	push   %ebp
     821:	89 e5                	mov    %esp,%ebp
     823:	53                   	push   %ebx
  name[2] = '\0';
     824:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     829:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     82c:	68 28 4e 00 00       	push   $0x4e28
     831:	ff 35 28 5e 00 00    	pushl  0x5e28
     837:	e8 d4 31 00 00       	call   3a10 <printf>
  name[0] = 'a';
     83c:	c6 05 00 a6 00 00 61 	movb   $0x61,0xa600
  name[2] = '\0';
     843:	c6 05 02 a6 00 00 00 	movb   $0x0,0xa602
     84a:	83 c4 10             	add    $0x10,%esp
     84d:	8d 76 00             	lea    0x0(%esi),%esi
    fd = open(name, O_CREATE|O_RDWR);
     850:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     853:	88 1d 01 a6 00 00    	mov    %bl,0xa601
     859:	83 c3 01             	add    $0x1,%ebx
    fd = open(name, O_CREATE|O_RDWR);
     85c:	68 02 02 00 00       	push   $0x202
     861:	68 00 a6 00 00       	push   $0xa600
     866:	e8 87 30 00 00       	call   38f2 <open>
    close(fd);
     86b:	89 04 24             	mov    %eax,(%esp)
     86e:	e8 67 30 00 00       	call   38da <close>
  for(i = 0; i < 52; i++){
     873:	83 c4 10             	add    $0x10,%esp
     876:	80 fb 64             	cmp    $0x64,%bl
     879:	75 d5                	jne    850 <createtest+0x30>
  name[0] = 'a';
     87b:	c6 05 00 a6 00 00 61 	movb   $0x61,0xa600
  name[2] = '\0';
     882:	c6 05 02 a6 00 00 00 	movb   $0x0,0xa602
     889:	bb 30 00 00 00       	mov    $0x30,%ebx
     88e:	66 90                	xchg   %ax,%ax
    unlink(name);
     890:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     893:	88 1d 01 a6 00 00    	mov    %bl,0xa601
     899:	83 c3 01             	add    $0x1,%ebx
    unlink(name);
     89c:	68 00 a6 00 00       	push   $0xa600
     8a1:	e8 5c 30 00 00       	call   3902 <unlink>
  for(i = 0; i < 52; i++){
     8a6:	83 c4 10             	add    $0x10,%esp
     8a9:	80 fb 64             	cmp    $0x64,%bl
     8ac:	75 e2                	jne    890 <createtest+0x70>
  printf(stdout, "many creates, followed by unlink; ok\n");
     8ae:	83 ec 08             	sub    $0x8,%esp
     8b1:	68 50 4e 00 00       	push   $0x4e50
     8b6:	ff 35 28 5e 00 00    	pushl  0x5e28
     8bc:	e8 4f 31 00 00       	call   3a10 <printf>
}
     8c1:	83 c4 10             	add    $0x10,%esp
     8c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     8c7:	c9                   	leave  
     8c8:	c3                   	ret    
     8c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000008d0 <dirtest>:
{
     8d0:	55                   	push   %ebp
     8d1:	89 e5                	mov    %esp,%ebp
     8d3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     8d6:	68 2c 40 00 00       	push   $0x402c
     8db:	ff 35 28 5e 00 00    	pushl  0x5e28
     8e1:	e8 2a 31 00 00       	call   3a10 <printf>
  if(mkdir("dir0") < 0){
     8e6:	c7 04 24 38 40 00 00 	movl   $0x4038,(%esp)
     8ed:	e8 28 30 00 00       	call   391a <mkdir>
     8f2:	83 c4 10             	add    $0x10,%esp
     8f5:	85 c0                	test   %eax,%eax
     8f7:	78 58                	js     951 <dirtest+0x81>
  if(chdir("dir0") < 0){
     8f9:	83 ec 0c             	sub    $0xc,%esp
     8fc:	68 38 40 00 00       	push   $0x4038
     901:	e8 1c 30 00 00       	call   3922 <chdir>
     906:	83 c4 10             	add    $0x10,%esp
     909:	85 c0                	test   %eax,%eax
     90b:	0f 88 85 00 00 00    	js     996 <dirtest+0xc6>
  if(chdir("..") < 0){
     911:	83 ec 0c             	sub    $0xc,%esp
     914:	68 ed 45 00 00       	push   $0x45ed
     919:	e8 04 30 00 00       	call   3922 <chdir>
     91e:	83 c4 10             	add    $0x10,%esp
     921:	85 c0                	test   %eax,%eax
     923:	78 5a                	js     97f <dirtest+0xaf>
  if(unlink("dir0") < 0){
     925:	83 ec 0c             	sub    $0xc,%esp
     928:	68 38 40 00 00       	push   $0x4038
     92d:	e8 d0 2f 00 00       	call   3902 <unlink>
     932:	83 c4 10             	add    $0x10,%esp
     935:	85 c0                	test   %eax,%eax
     937:	78 2f                	js     968 <dirtest+0x98>
  printf(stdout, "mkdir test ok\n");
     939:	83 ec 08             	sub    $0x8,%esp
     93c:	68 75 40 00 00       	push   $0x4075
     941:	ff 35 28 5e 00 00    	pushl  0x5e28
     947:	e8 c4 30 00 00       	call   3a10 <printf>
}
     94c:	83 c4 10             	add    $0x10,%esp
     94f:	c9                   	leave  
     950:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     951:	50                   	push   %eax
     952:	50                   	push   %eax
     953:	68 68 3d 00 00       	push   $0x3d68
     958:	ff 35 28 5e 00 00    	pushl  0x5e28
     95e:	e8 ad 30 00 00       	call   3a10 <printf>
    exit();
     963:	e8 4a 2f 00 00       	call   38b2 <exit>
    printf(stdout, "unlink dir0 failed\n");
     968:	50                   	push   %eax
     969:	50                   	push   %eax
     96a:	68 61 40 00 00       	push   $0x4061
     96f:	ff 35 28 5e 00 00    	pushl  0x5e28
     975:	e8 96 30 00 00       	call   3a10 <printf>
    exit();
     97a:	e8 33 2f 00 00       	call   38b2 <exit>
    printf(stdout, "chdir .. failed\n");
     97f:	52                   	push   %edx
     980:	52                   	push   %edx
     981:	68 50 40 00 00       	push   $0x4050
     986:	ff 35 28 5e 00 00    	pushl  0x5e28
     98c:	e8 7f 30 00 00       	call   3a10 <printf>
    exit();
     991:	e8 1c 2f 00 00       	call   38b2 <exit>
    printf(stdout, "chdir dir0 failed\n");
     996:	51                   	push   %ecx
     997:	51                   	push   %ecx
     998:	68 3d 40 00 00       	push   $0x403d
     99d:	ff 35 28 5e 00 00    	pushl  0x5e28
     9a3:	e8 68 30 00 00       	call   3a10 <printf>
    exit();
     9a8:	e8 05 2f 00 00       	call   38b2 <exit>
     9ad:	8d 76 00             	lea    0x0(%esi),%esi

000009b0 <exectest>:
{
     9b0:	55                   	push   %ebp
     9b1:	89 e5                	mov    %esp,%ebp
     9b3:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     9b6:	68 84 40 00 00       	push   $0x4084
     9bb:	ff 35 28 5e 00 00    	pushl  0x5e28
     9c1:	e8 4a 30 00 00       	call   3a10 <printf>
  if(exec("echo", echoargv) < 0){
     9c6:	5a                   	pop    %edx
     9c7:	59                   	pop    %ecx
     9c8:	68 2c 5e 00 00       	push   $0x5e2c
     9cd:	68 4d 3e 00 00       	push   $0x3e4d
     9d2:	e8 13 2f 00 00       	call   38ea <exec>
     9d7:	83 c4 10             	add    $0x10,%esp
     9da:	85 c0                	test   %eax,%eax
     9dc:	78 02                	js     9e0 <exectest+0x30>
}
     9de:	c9                   	leave  
     9df:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     9e0:	50                   	push   %eax
     9e1:	50                   	push   %eax
     9e2:	68 8f 40 00 00       	push   $0x408f
     9e7:	ff 35 28 5e 00 00    	pushl  0x5e28
     9ed:	e8 1e 30 00 00       	call   3a10 <printf>
    exit();
     9f2:	e8 bb 2e 00 00       	call   38b2 <exit>
     9f7:	89 f6                	mov    %esi,%esi
     9f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a00 <pipe1>:
{
     a00:	55                   	push   %ebp
     a01:	89 e5                	mov    %esp,%ebp
     a03:	57                   	push   %edi
     a04:	56                   	push   %esi
     a05:	53                   	push   %ebx
  if(pipe(fds) != 0){
     a06:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     a09:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     a0c:	50                   	push   %eax
     a0d:	e8 b0 2e 00 00       	call   38c2 <pipe>
     a12:	83 c4 10             	add    $0x10,%esp
     a15:	85 c0                	test   %eax,%eax
     a17:	0f 85 3e 01 00 00    	jne    b5b <pipe1+0x15b>
     a1d:	89 c3                	mov    %eax,%ebx
  pid = fork();
     a1f:	e8 86 2e 00 00       	call   38aa <fork>
  if(pid == 0){
     a24:	83 f8 00             	cmp    $0x0,%eax
     a27:	0f 84 84 00 00 00    	je     ab1 <pipe1+0xb1>
  } else if(pid > 0){
     a2d:	0f 8e 3b 01 00 00    	jle    b6e <pipe1+0x16e>
    close(fds[1]);
     a33:	83 ec 0c             	sub    $0xc,%esp
     a36:	ff 75 e4             	pushl  -0x1c(%ebp)
    cc = 1;
     a39:	bf 01 00 00 00       	mov    $0x1,%edi
    close(fds[1]);
     a3e:	e8 97 2e 00 00       	call   38da <close>
    while((n = read(fds[0], buf, cc)) > 0){
     a43:	83 c4 10             	add    $0x10,%esp
    total = 0;
     a46:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a4d:	83 ec 04             	sub    $0x4,%esp
     a50:	57                   	push   %edi
     a51:	68 00 86 00 00       	push   $0x8600
     a56:	ff 75 e0             	pushl  -0x20(%ebp)
     a59:	e8 6c 2e 00 00       	call   38ca <read>
     a5e:	83 c4 10             	add    $0x10,%esp
     a61:	85 c0                	test   %eax,%eax
     a63:	0f 8e ab 00 00 00    	jle    b14 <pipe1+0x114>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     a69:	89 d9                	mov    %ebx,%ecx
     a6b:	8d 34 18             	lea    (%eax,%ebx,1),%esi
     a6e:	f7 d9                	neg    %ecx
     a70:	38 9c 0b 00 86 00 00 	cmp    %bl,0x8600(%ebx,%ecx,1)
     a77:	8d 53 01             	lea    0x1(%ebx),%edx
     a7a:	75 1b                	jne    a97 <pipe1+0x97>
      for(i = 0; i < n; i++){
     a7c:	39 f2                	cmp    %esi,%edx
     a7e:	89 d3                	mov    %edx,%ebx
     a80:	75 ee                	jne    a70 <pipe1+0x70>
      cc = cc * 2;
     a82:	01 ff                	add    %edi,%edi
      total += n;
     a84:	01 45 d4             	add    %eax,-0x2c(%ebp)
     a87:	b8 00 20 00 00       	mov    $0x2000,%eax
     a8c:	81 ff 00 20 00 00    	cmp    $0x2000,%edi
     a92:	0f 4f f8             	cmovg  %eax,%edi
     a95:	eb b6                	jmp    a4d <pipe1+0x4d>
          printf(1, "pipe1 oops 2\n");
     a97:	83 ec 08             	sub    $0x8,%esp
     a9a:	68 be 40 00 00       	push   $0x40be
     a9f:	6a 01                	push   $0x1
     aa1:	e8 6a 2f 00 00       	call   3a10 <printf>
          return;
     aa6:	83 c4 10             	add    $0x10,%esp
}
     aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     aac:	5b                   	pop    %ebx
     aad:	5e                   	pop    %esi
     aae:	5f                   	pop    %edi
     aaf:	5d                   	pop    %ebp
     ab0:	c3                   	ret    
    close(fds[0]);
     ab1:	83 ec 0c             	sub    $0xc,%esp
     ab4:	ff 75 e0             	pushl  -0x20(%ebp)
     ab7:	31 db                	xor    %ebx,%ebx
     ab9:	be 09 04 00 00       	mov    $0x409,%esi
     abe:	e8 17 2e 00 00       	call   38da <close>
     ac3:	83 c4 10             	add    $0x10,%esp
     ac6:	89 d8                	mov    %ebx,%eax
     ac8:	89 f2                	mov    %esi,%edx
     aca:	f7 d8                	neg    %eax
     acc:	29 da                	sub    %ebx,%edx
     ace:	66 90                	xchg   %ax,%ax
        buf[i] = seq++;
     ad0:	88 84 03 00 86 00 00 	mov    %al,0x8600(%ebx,%eax,1)
     ad7:	83 c0 01             	add    $0x1,%eax
      for(i = 0; i < 1033; i++)
     ada:	39 d0                	cmp    %edx,%eax
     adc:	75 f2                	jne    ad0 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     ade:	83 ec 04             	sub    $0x4,%esp
     ae1:	68 09 04 00 00       	push   $0x409
     ae6:	68 00 86 00 00       	push   $0x8600
     aeb:	ff 75 e4             	pushl  -0x1c(%ebp)
     aee:	e8 df 2d 00 00       	call   38d2 <write>
     af3:	83 c4 10             	add    $0x10,%esp
     af6:	3d 09 04 00 00       	cmp    $0x409,%eax
     afb:	0f 85 80 00 00 00    	jne    b81 <pipe1+0x181>
     b01:	81 eb 09 04 00 00    	sub    $0x409,%ebx
    for(n = 0; n < 5; n++){
     b07:	81 fb d3 eb ff ff    	cmp    $0xffffebd3,%ebx
     b0d:	75 b7                	jne    ac6 <pipe1+0xc6>
    exit();
     b0f:	e8 9e 2d 00 00       	call   38b2 <exit>
    if(total != 5 * 1033){
     b14:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     b1b:	75 29                	jne    b46 <pipe1+0x146>
    close(fds[0]);
     b1d:	83 ec 0c             	sub    $0xc,%esp
     b20:	ff 75 e0             	pushl  -0x20(%ebp)
     b23:	e8 b2 2d 00 00       	call   38da <close>
    wait();
     b28:	e8 8d 2d 00 00       	call   38ba <wait>
  printf(1, "pipe1 ok\n");
     b2d:	5a                   	pop    %edx
     b2e:	59                   	pop    %ecx
     b2f:	68 e3 40 00 00       	push   $0x40e3
     b34:	6a 01                	push   $0x1
     b36:	e8 d5 2e 00 00       	call   3a10 <printf>
     b3b:	83 c4 10             	add    $0x10,%esp
}
     b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b41:	5b                   	pop    %ebx
     b42:	5e                   	pop    %esi
     b43:	5f                   	pop    %edi
     b44:	5d                   	pop    %ebp
     b45:	c3                   	ret    
      printf(1, "pipe1 oops 3 total %d\n", total);
     b46:	53                   	push   %ebx
     b47:	ff 75 d4             	pushl  -0x2c(%ebp)
     b4a:	68 cc 40 00 00       	push   $0x40cc
     b4f:	6a 01                	push   $0x1
     b51:	e8 ba 2e 00 00       	call   3a10 <printf>
      exit();
     b56:	e8 57 2d 00 00       	call   38b2 <exit>
    printf(1, "pipe() failed\n");
     b5b:	57                   	push   %edi
     b5c:	57                   	push   %edi
     b5d:	68 a1 40 00 00       	push   $0x40a1
     b62:	6a 01                	push   $0x1
     b64:	e8 a7 2e 00 00       	call   3a10 <printf>
    exit();
     b69:	e8 44 2d 00 00       	call   38b2 <exit>
    printf(1, "fork() failed\n");
     b6e:	50                   	push   %eax
     b6f:	50                   	push   %eax
     b70:	68 ed 40 00 00       	push   $0x40ed
     b75:	6a 01                	push   $0x1
     b77:	e8 94 2e 00 00       	call   3a10 <printf>
    exit();
     b7c:	e8 31 2d 00 00       	call   38b2 <exit>
        printf(1, "pipe1 oops 1\n");
     b81:	56                   	push   %esi
     b82:	56                   	push   %esi
     b83:	68 b0 40 00 00       	push   $0x40b0
     b88:	6a 01                	push   $0x1
     b8a:	e8 81 2e 00 00       	call   3a10 <printf>
        exit();
     b8f:	e8 1e 2d 00 00       	call   38b2 <exit>
     b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000ba0 <preempt>:
{
     ba0:	55                   	push   %ebp
     ba1:	89 e5                	mov    %esp,%ebp
     ba3:	57                   	push   %edi
     ba4:	56                   	push   %esi
     ba5:	53                   	push   %ebx
     ba6:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     ba9:	68 fc 40 00 00       	push   $0x40fc
     bae:	6a 01                	push   $0x1
     bb0:	e8 5b 2e 00 00       	call   3a10 <printf>
  pid1 = fork();
     bb5:	e8 f0 2c 00 00       	call   38aa <fork>
  if(pid1 == 0)
     bba:	83 c4 10             	add    $0x10,%esp
     bbd:	85 c0                	test   %eax,%eax
     bbf:	75 02                	jne    bc3 <preempt+0x23>
     bc1:	eb fe                	jmp    bc1 <preempt+0x21>
     bc3:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     bc5:	e8 e0 2c 00 00       	call   38aa <fork>
  if(pid2 == 0)
     bca:	85 c0                	test   %eax,%eax
  pid2 = fork();
     bcc:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     bce:	75 02                	jne    bd2 <preempt+0x32>
     bd0:	eb fe                	jmp    bd0 <preempt+0x30>
  pipe(pfds);
     bd2:	8d 45 e0             	lea    -0x20(%ebp),%eax
     bd5:	83 ec 0c             	sub    $0xc,%esp
     bd8:	50                   	push   %eax
     bd9:	e8 e4 2c 00 00       	call   38c2 <pipe>
  pid3 = fork();
     bde:	e8 c7 2c 00 00       	call   38aa <fork>
  if(pid3 == 0){
     be3:	83 c4 10             	add    $0x10,%esp
     be6:	85 c0                	test   %eax,%eax
  pid3 = fork();
     be8:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     bea:	75 46                	jne    c32 <preempt+0x92>
    close(pfds[0]);
     bec:	83 ec 0c             	sub    $0xc,%esp
     bef:	ff 75 e0             	pushl  -0x20(%ebp)
     bf2:	e8 e3 2c 00 00       	call   38da <close>
    if(write(pfds[1], "x", 1) != 1)
     bf7:	83 c4 0c             	add    $0xc,%esp
     bfa:	6a 01                	push   $0x1
     bfc:	68 d1 46 00 00       	push   $0x46d1
     c01:	ff 75 e4             	pushl  -0x1c(%ebp)
     c04:	e8 c9 2c 00 00       	call   38d2 <write>
     c09:	83 c4 10             	add    $0x10,%esp
     c0c:	83 e8 01             	sub    $0x1,%eax
     c0f:	74 11                	je     c22 <preempt+0x82>
      printf(1, "preempt write error");
     c11:	50                   	push   %eax
     c12:	50                   	push   %eax
     c13:	68 06 41 00 00       	push   $0x4106
     c18:	6a 01                	push   $0x1
     c1a:	e8 f1 2d 00 00       	call   3a10 <printf>
     c1f:	83 c4 10             	add    $0x10,%esp
    close(pfds[1]);
     c22:	83 ec 0c             	sub    $0xc,%esp
     c25:	ff 75 e4             	pushl  -0x1c(%ebp)
     c28:	e8 ad 2c 00 00       	call   38da <close>
     c2d:	83 c4 10             	add    $0x10,%esp
     c30:	eb fe                	jmp    c30 <preempt+0x90>
  close(pfds[1]);
     c32:	83 ec 0c             	sub    $0xc,%esp
     c35:	ff 75 e4             	pushl  -0x1c(%ebp)
     c38:	e8 9d 2c 00 00       	call   38da <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c3d:	83 c4 0c             	add    $0xc,%esp
     c40:	68 00 20 00 00       	push   $0x2000
     c45:	68 00 86 00 00       	push   $0x8600
     c4a:	ff 75 e0             	pushl  -0x20(%ebp)
     c4d:	e8 78 2c 00 00       	call   38ca <read>
     c52:	83 c4 10             	add    $0x10,%esp
     c55:	83 e8 01             	sub    $0x1,%eax
     c58:	74 19                	je     c73 <preempt+0xd3>
    printf(1, "preempt read error");
     c5a:	50                   	push   %eax
     c5b:	50                   	push   %eax
     c5c:	68 1a 41 00 00       	push   $0x411a
     c61:	6a 01                	push   $0x1
     c63:	e8 a8 2d 00 00       	call   3a10 <printf>
    return;
     c68:	83 c4 10             	add    $0x10,%esp
}
     c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c6e:	5b                   	pop    %ebx
     c6f:	5e                   	pop    %esi
     c70:	5f                   	pop    %edi
     c71:	5d                   	pop    %ebp
     c72:	c3                   	ret    
  close(pfds[0]);
     c73:	83 ec 0c             	sub    $0xc,%esp
     c76:	ff 75 e0             	pushl  -0x20(%ebp)
     c79:	e8 5c 2c 00 00       	call   38da <close>
  printf(1, "kill... ");
     c7e:	58                   	pop    %eax
     c7f:	5a                   	pop    %edx
     c80:	68 2d 41 00 00       	push   $0x412d
     c85:	6a 01                	push   $0x1
     c87:	e8 84 2d 00 00       	call   3a10 <printf>
  kill(pid1);
     c8c:	89 3c 24             	mov    %edi,(%esp)
     c8f:	e8 4e 2c 00 00       	call   38e2 <kill>
  kill(pid2);
     c94:	89 34 24             	mov    %esi,(%esp)
     c97:	e8 46 2c 00 00       	call   38e2 <kill>
  kill(pid3);
     c9c:	89 1c 24             	mov    %ebx,(%esp)
     c9f:	e8 3e 2c 00 00       	call   38e2 <kill>
  printf(1, "wait... ");
     ca4:	59                   	pop    %ecx
     ca5:	5b                   	pop    %ebx
     ca6:	68 36 41 00 00       	push   $0x4136
     cab:	6a 01                	push   $0x1
     cad:	e8 5e 2d 00 00       	call   3a10 <printf>
  wait();
     cb2:	e8 03 2c 00 00       	call   38ba <wait>
  wait();
     cb7:	e8 fe 2b 00 00       	call   38ba <wait>
  wait();
     cbc:	e8 f9 2b 00 00       	call   38ba <wait>
  printf(1, "preempt ok\n");
     cc1:	5e                   	pop    %esi
     cc2:	5f                   	pop    %edi
     cc3:	68 3f 41 00 00       	push   $0x413f
     cc8:	6a 01                	push   $0x1
     cca:	e8 41 2d 00 00       	call   3a10 <printf>
     ccf:	83 c4 10             	add    $0x10,%esp
     cd2:	eb 97                	jmp    c6b <preempt+0xcb>
     cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000ce0 <exitwait>:
{
     ce0:	55                   	push   %ebp
     ce1:	89 e5                	mov    %esp,%ebp
     ce3:	56                   	push   %esi
     ce4:	be 64 00 00 00       	mov    $0x64,%esi
     ce9:	53                   	push   %ebx
     cea:	eb 14                	jmp    d00 <exitwait+0x20>
     cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid){
     cf0:	74 6f                	je     d61 <exitwait+0x81>
      if(wait() != pid){
     cf2:	e8 c3 2b 00 00       	call   38ba <wait>
     cf7:	39 d8                	cmp    %ebx,%eax
     cf9:	75 2d                	jne    d28 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     cfb:	83 ee 01             	sub    $0x1,%esi
     cfe:	74 48                	je     d48 <exitwait+0x68>
    pid = fork();
     d00:	e8 a5 2b 00 00       	call   38aa <fork>
    if(pid < 0){
     d05:	85 c0                	test   %eax,%eax
    pid = fork();
     d07:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     d09:	79 e5                	jns    cf0 <exitwait+0x10>
      printf(1, "fork failed\n");
     d0b:	83 ec 08             	sub    $0x8,%esp
     d0e:	68 b9 4c 00 00       	push   $0x4cb9
     d13:	6a 01                	push   $0x1
     d15:	e8 f6 2c 00 00       	call   3a10 <printf>
      return;
     d1a:	83 c4 10             	add    $0x10,%esp
}
     d1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d20:	5b                   	pop    %ebx
     d21:	5e                   	pop    %esi
     d22:	5d                   	pop    %ebp
     d23:	c3                   	ret    
     d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     d28:	83 ec 08             	sub    $0x8,%esp
     d2b:	68 4b 41 00 00       	push   $0x414b
     d30:	6a 01                	push   $0x1
     d32:	e8 d9 2c 00 00       	call   3a10 <printf>
        return;
     d37:	83 c4 10             	add    $0x10,%esp
}
     d3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d3d:	5b                   	pop    %ebx
     d3e:	5e                   	pop    %esi
     d3f:	5d                   	pop    %ebp
     d40:	c3                   	ret    
     d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  printf(1, "exitwait ok\n");
     d48:	83 ec 08             	sub    $0x8,%esp
     d4b:	68 5b 41 00 00       	push   $0x415b
     d50:	6a 01                	push   $0x1
     d52:	e8 b9 2c 00 00       	call   3a10 <printf>
     d57:	83 c4 10             	add    $0x10,%esp
}
     d5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d5d:	5b                   	pop    %ebx
     d5e:	5e                   	pop    %esi
     d5f:	5d                   	pop    %ebp
     d60:	c3                   	ret    
      exit();
     d61:	e8 4c 2b 00 00       	call   38b2 <exit>
     d66:	8d 76 00             	lea    0x0(%esi),%esi
     d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000d70 <mem>:
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	57                   	push   %edi
     d74:	56                   	push   %esi
     d75:	53                   	push   %ebx
     d76:	31 db                	xor    %ebx,%ebx
     d78:	83 ec 14             	sub    $0x14,%esp
  printf(1, "mem test\n");
     d7b:	68 68 41 00 00       	push   $0x4168
     d80:	6a 01                	push   $0x1
     d82:	e8 89 2c 00 00       	call   3a10 <printf>
  ppid = getpid();
     d87:	e8 a6 2b 00 00       	call   3932 <getpid>
     d8c:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     d8e:	e8 17 2b 00 00       	call   38aa <fork>
     d93:	83 c4 10             	add    $0x10,%esp
     d96:	85 c0                	test   %eax,%eax
     d98:	74 0a                	je     da4 <mem+0x34>
     d9a:	e9 89 00 00 00       	jmp    e28 <mem+0xb8>
     d9f:	90                   	nop
      *(char**)m2 = m1;
     da0:	89 18                	mov    %ebx,(%eax)
     da2:	89 c3                	mov    %eax,%ebx
    while((m2 = malloc(10001)) != 0){
     da4:	83 ec 0c             	sub    $0xc,%esp
     da7:	68 11 27 00 00       	push   $0x2711
     dac:	e8 bf 2e 00 00       	call   3c70 <malloc>
     db1:	83 c4 10             	add    $0x10,%esp
     db4:	85 c0                	test   %eax,%eax
     db6:	75 e8                	jne    da0 <mem+0x30>
    while(m1){
     db8:	85 db                	test   %ebx,%ebx
     dba:	74 18                	je     dd4 <mem+0x64>
     dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     dc0:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     dc2:	83 ec 0c             	sub    $0xc,%esp
     dc5:	53                   	push   %ebx
     dc6:	89 fb                	mov    %edi,%ebx
     dc8:	e8 13 2e 00 00       	call   3be0 <free>
    while(m1){
     dcd:	83 c4 10             	add    $0x10,%esp
     dd0:	85 db                	test   %ebx,%ebx
     dd2:	75 ec                	jne    dc0 <mem+0x50>
    m1 = malloc(1024*20);
     dd4:	83 ec 0c             	sub    $0xc,%esp
     dd7:	68 00 50 00 00       	push   $0x5000
     ddc:	e8 8f 2e 00 00       	call   3c70 <malloc>
    if(m1 == 0){
     de1:	83 c4 10             	add    $0x10,%esp
     de4:	85 c0                	test   %eax,%eax
     de6:	74 20                	je     e08 <mem+0x98>
    free(m1);
     de8:	83 ec 0c             	sub    $0xc,%esp
     deb:	50                   	push   %eax
     dec:	e8 ef 2d 00 00       	call   3be0 <free>
    printf(1, "mem ok\n");
     df1:	58                   	pop    %eax
     df2:	5a                   	pop    %edx
     df3:	68 8c 41 00 00       	push   $0x418c
     df8:	6a 01                	push   $0x1
     dfa:	e8 11 2c 00 00       	call   3a10 <printf>
    exit();
     dff:	e8 ae 2a 00 00       	call   38b2 <exit>
     e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     e08:	83 ec 08             	sub    $0x8,%esp
     e0b:	68 72 41 00 00       	push   $0x4172
     e10:	6a 01                	push   $0x1
     e12:	e8 f9 2b 00 00       	call   3a10 <printf>
      kill(ppid);
     e17:	89 34 24             	mov    %esi,(%esp)
     e1a:	e8 c3 2a 00 00       	call   38e2 <kill>
      exit();
     e1f:	e8 8e 2a 00 00       	call   38b2 <exit>
     e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
     e28:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e2b:	5b                   	pop    %ebx
     e2c:	5e                   	pop    %esi
     e2d:	5f                   	pop    %edi
     e2e:	5d                   	pop    %ebp
    wait();
     e2f:	e9 86 2a 00 00       	jmp    38ba <wait>
     e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000e40 <sharedfd>:
{
     e40:	55                   	push   %ebp
     e41:	89 e5                	mov    %esp,%ebp
     e43:	57                   	push   %edi
     e44:	56                   	push   %esi
     e45:	53                   	push   %ebx
     e46:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     e49:	68 94 41 00 00       	push   $0x4194
     e4e:	6a 01                	push   $0x1
     e50:	e8 bb 2b 00 00       	call   3a10 <printf>
  unlink("sharedfd");
     e55:	c7 04 24 a3 41 00 00 	movl   $0x41a3,(%esp)
     e5c:	e8 a1 2a 00 00       	call   3902 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     e61:	59                   	pop    %ecx
     e62:	5b                   	pop    %ebx
     e63:	68 02 02 00 00       	push   $0x202
     e68:	68 a3 41 00 00       	push   $0x41a3
     e6d:	e8 80 2a 00 00       	call   38f2 <open>
  if(fd < 0){
     e72:	83 c4 10             	add    $0x10,%esp
     e75:	85 c0                	test   %eax,%eax
     e77:	0f 88 33 01 00 00    	js     fb0 <sharedfd+0x170>
     e7d:	89 c6                	mov    %eax,%esi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e7f:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     e84:	e8 21 2a 00 00       	call   38aa <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e89:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     e8c:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     e8e:	19 c0                	sbb    %eax,%eax
     e90:	83 ec 04             	sub    $0x4,%esp
     e93:	83 e0 f3             	and    $0xfffffff3,%eax
     e96:	6a 0a                	push   $0xa
     e98:	83 c0 70             	add    $0x70,%eax
     e9b:	50                   	push   %eax
     e9c:	8d 45 de             	lea    -0x22(%ebp),%eax
     e9f:	50                   	push   %eax
     ea0:	e8 6b 28 00 00       	call   3710 <memset>
     ea5:	83 c4 10             	add    $0x10,%esp
     ea8:	eb 0b                	jmp    eb5 <sharedfd+0x75>
     eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < 1000; i++){
     eb0:	83 eb 01             	sub    $0x1,%ebx
     eb3:	74 29                	je     ede <sharedfd+0x9e>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     eb5:	8d 45 de             	lea    -0x22(%ebp),%eax
     eb8:	83 ec 04             	sub    $0x4,%esp
     ebb:	6a 0a                	push   $0xa
     ebd:	50                   	push   %eax
     ebe:	56                   	push   %esi
     ebf:	e8 0e 2a 00 00       	call   38d2 <write>
     ec4:	83 c4 10             	add    $0x10,%esp
     ec7:	83 f8 0a             	cmp    $0xa,%eax
     eca:	74 e4                	je     eb0 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     ecc:	83 ec 08             	sub    $0x8,%esp
     ecf:	68 a4 4e 00 00       	push   $0x4ea4
     ed4:	6a 01                	push   $0x1
     ed6:	e8 35 2b 00 00       	call   3a10 <printf>
      break;
     edb:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     ede:	85 ff                	test   %edi,%edi
     ee0:	0f 84 fe 00 00 00    	je     fe4 <sharedfd+0x1a4>
    wait();
     ee6:	e8 cf 29 00 00       	call   38ba <wait>
  close(fd);
     eeb:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     eee:	31 db                	xor    %ebx,%ebx
     ef0:	31 ff                	xor    %edi,%edi
  close(fd);
     ef2:	56                   	push   %esi
     ef3:	8d 75 e8             	lea    -0x18(%ebp),%esi
     ef6:	e8 df 29 00 00       	call   38da <close>
  fd = open("sharedfd", 0);
     efb:	58                   	pop    %eax
     efc:	5a                   	pop    %edx
     efd:	6a 00                	push   $0x0
     eff:	68 a3 41 00 00       	push   $0x41a3
     f04:	e8 e9 29 00 00       	call   38f2 <open>
  if(fd < 0){
     f09:	83 c4 10             	add    $0x10,%esp
     f0c:	85 c0                	test   %eax,%eax
  fd = open("sharedfd", 0);
     f0e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  if(fd < 0){
     f11:	0f 88 b3 00 00 00    	js     fca <sharedfd+0x18a>
     f17:	89 f8                	mov    %edi,%eax
     f19:	89 df                	mov    %ebx,%edi
     f1b:	89 c3                	mov    %eax,%ebx
     f1d:	8d 76 00             	lea    0x0(%esi),%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f20:	8d 45 de             	lea    -0x22(%ebp),%eax
     f23:	83 ec 04             	sub    $0x4,%esp
     f26:	6a 0a                	push   $0xa
     f28:	50                   	push   %eax
     f29:	ff 75 d4             	pushl  -0x2c(%ebp)
     f2c:	e8 99 29 00 00       	call   38ca <read>
     f31:	83 c4 10             	add    $0x10,%esp
     f34:	85 c0                	test   %eax,%eax
     f36:	7e 28                	jle    f60 <sharedfd+0x120>
     f38:	8d 45 de             	lea    -0x22(%ebp),%eax
     f3b:	eb 15                	jmp    f52 <sharedfd+0x112>
     f3d:	8d 76 00             	lea    0x0(%esi),%esi
        np++;
     f40:	80 fa 70             	cmp    $0x70,%dl
     f43:	0f 94 c2             	sete   %dl
     f46:	0f b6 d2             	movzbl %dl,%edx
     f49:	01 d7                	add    %edx,%edi
     f4b:	83 c0 01             	add    $0x1,%eax
    for(i = 0; i < sizeof(buf); i++){
     f4e:	39 f0                	cmp    %esi,%eax
     f50:	74 ce                	je     f20 <sharedfd+0xe0>
      if(buf[i] == 'c')
     f52:	0f b6 10             	movzbl (%eax),%edx
     f55:	80 fa 63             	cmp    $0x63,%dl
     f58:	75 e6                	jne    f40 <sharedfd+0x100>
        nc++;
     f5a:	83 c3 01             	add    $0x1,%ebx
     f5d:	eb ec                	jmp    f4b <sharedfd+0x10b>
     f5f:	90                   	nop
  close(fd);
     f60:	83 ec 0c             	sub    $0xc,%esp
     f63:	89 d8                	mov    %ebx,%eax
     f65:	ff 75 d4             	pushl  -0x2c(%ebp)
     f68:	89 fb                	mov    %edi,%ebx
     f6a:	89 c7                	mov    %eax,%edi
     f6c:	e8 69 29 00 00       	call   38da <close>
  unlink("sharedfd");
     f71:	c7 04 24 a3 41 00 00 	movl   $0x41a3,(%esp)
     f78:	e8 85 29 00 00       	call   3902 <unlink>
  if(nc == 10000 && np == 10000){
     f7d:	83 c4 10             	add    $0x10,%esp
     f80:	81 ff 10 27 00 00    	cmp    $0x2710,%edi
     f86:	75 61                	jne    fe9 <sharedfd+0x1a9>
     f88:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     f8e:	75 59                	jne    fe9 <sharedfd+0x1a9>
    printf(1, "sharedfd ok\n");
     f90:	83 ec 08             	sub    $0x8,%esp
     f93:	68 ac 41 00 00       	push   $0x41ac
     f98:	6a 01                	push   $0x1
     f9a:	e8 71 2a 00 00       	call   3a10 <printf>
     f9f:	83 c4 10             	add    $0x10,%esp
}
     fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fa5:	5b                   	pop    %ebx
     fa6:	5e                   	pop    %esi
     fa7:	5f                   	pop    %edi
     fa8:	5d                   	pop    %ebp
     fa9:	c3                   	ret    
     faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    printf(1, "fstests: cannot open sharedfd for writing");
     fb0:	83 ec 08             	sub    $0x8,%esp
     fb3:	68 78 4e 00 00       	push   $0x4e78
     fb8:	6a 01                	push   $0x1
     fba:	e8 51 2a 00 00       	call   3a10 <printf>
    return;
     fbf:	83 c4 10             	add    $0x10,%esp
}
     fc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fc5:	5b                   	pop    %ebx
     fc6:	5e                   	pop    %esi
     fc7:	5f                   	pop    %edi
     fc8:	5d                   	pop    %ebp
     fc9:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
     fca:	83 ec 08             	sub    $0x8,%esp
     fcd:	68 c4 4e 00 00       	push   $0x4ec4
     fd2:	6a 01                	push   $0x1
     fd4:	e8 37 2a 00 00       	call   3a10 <printf>
    return;
     fd9:	83 c4 10             	add    $0x10,%esp
}
     fdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
     fdf:	5b                   	pop    %ebx
     fe0:	5e                   	pop    %esi
     fe1:	5f                   	pop    %edi
     fe2:	5d                   	pop    %ebp
     fe3:	c3                   	ret    
    exit();
     fe4:	e8 c9 28 00 00       	call   38b2 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
     fe9:	53                   	push   %ebx
     fea:	57                   	push   %edi
     feb:	68 b9 41 00 00       	push   $0x41b9
     ff0:	6a 01                	push   $0x1
     ff2:	e8 19 2a 00 00       	call   3a10 <printf>
    exit();
     ff7:	e8 b6 28 00 00       	call   38b2 <exit>
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001000 <fourfiles>:
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	56                   	push   %esi
    1005:	53                   	push   %ebx
  printf(1, "fourfiles test\n");
    1006:	be ce 41 00 00       	mov    $0x41ce,%esi
  for(pi = 0; pi < 4; pi++){
    100b:	31 db                	xor    %ebx,%ebx
{
    100d:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    1010:	c7 45 d8 ce 41 00 00 	movl   $0x41ce,-0x28(%ebp)
    1017:	c7 45 dc 27 43 00 00 	movl   $0x4327,-0x24(%ebp)
  printf(1, "fourfiles test\n");
    101e:	68 d4 41 00 00       	push   $0x41d4
    1023:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    1025:	c7 45 e0 2b 43 00 00 	movl   $0x432b,-0x20(%ebp)
    102c:	c7 45 e4 d1 41 00 00 	movl   $0x41d1,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    1033:	e8 d8 29 00 00       	call   3a10 <printf>
    1038:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    103b:	83 ec 0c             	sub    $0xc,%esp
    103e:	56                   	push   %esi
    103f:	e8 be 28 00 00       	call   3902 <unlink>
    pid = fork();
    1044:	e8 61 28 00 00       	call   38aa <fork>
    if(pid < 0){
    1049:	83 c4 10             	add    $0x10,%esp
    104c:	85 c0                	test   %eax,%eax
    104e:	0f 88 88 01 00 00    	js     11dc <fourfiles+0x1dc>
    if(pid == 0){
    1054:	0f 84 ff 00 00 00    	je     1159 <fourfiles+0x159>
  for(pi = 0; pi < 4; pi++){
    105a:	83 c3 01             	add    $0x1,%ebx
    105d:	83 fb 04             	cmp    $0x4,%ebx
    1060:	74 06                	je     1068 <fourfiles+0x68>
    1062:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    1066:	eb d3                	jmp    103b <fourfiles+0x3b>
    wait();
    1068:	e8 4d 28 00 00       	call   38ba <wait>
  for(i = 0; i < 2; i++){
    106d:	31 ff                	xor    %edi,%edi
    wait();
    106f:	e8 46 28 00 00       	call   38ba <wait>
    1074:	e8 41 28 00 00       	call   38ba <wait>
    1079:	e8 3c 28 00 00       	call   38ba <wait>
    107e:	c7 45 cc ce 41 00 00 	movl   $0x41ce,-0x34(%ebp)
    fd = open(fname, 0);
    1085:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    1088:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    108a:	6a 00                	push   $0x0
    108c:	ff 75 cc             	pushl  -0x34(%ebp)
    108f:	e8 5e 28 00 00       	call   38f2 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1094:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    1097:	89 45 d0             	mov    %eax,-0x30(%ebp)
    109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10a0:	83 ec 04             	sub    $0x4,%esp
    10a3:	68 00 20 00 00       	push   $0x2000
    10a8:	68 00 86 00 00       	push   $0x8600
    10ad:	ff 75 d0             	pushl  -0x30(%ebp)
    10b0:	e8 15 28 00 00       	call   38ca <read>
    10b5:	83 c4 10             	add    $0x10,%esp
    10b8:	85 c0                	test   %eax,%eax
    10ba:	7e 46                	jle    1102 <fourfiles+0x102>
      printf(1, "bytes read: %d\n", n);
    10bc:	83 ec 04             	sub    $0x4,%esp
    10bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    10c2:	50                   	push   %eax
    10c3:	68 f5 41 00 00       	push   $0x41f5
    10c8:	6a 01                	push   $0x1
    10ca:	e8 41 29 00 00       	call   3a10 <printf>
      for(j = 0; j < n; j++){
    10cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      printf(1, "bytes read: %d\n", n);
    10d2:	83 c4 10             	add    $0x10,%esp
      for(j = 0; j < n; j++){
    10d5:	31 d2                	xor    %edx,%edx
    10d7:	89 f6                	mov    %esi,%esi
    10d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if(buf[j] != '0'+i){
    10e0:	0f be b2 00 86 00 00 	movsbl 0x8600(%edx),%esi
    10e7:	83 ff 01             	cmp    $0x1,%edi
    10ea:	19 c9                	sbb    %ecx,%ecx
    10ec:	83 c1 31             	add    $0x31,%ecx
    10ef:	39 ce                	cmp    %ecx,%esi
    10f1:	0f 85 be 00 00 00    	jne    11b5 <fourfiles+0x1b5>
      for(j = 0; j < n; j++){
    10f7:	83 c2 01             	add    $0x1,%edx
    10fa:	39 d0                	cmp    %edx,%eax
    10fc:	75 e2                	jne    10e0 <fourfiles+0xe0>
      total += n;
    10fe:	01 c3                	add    %eax,%ebx
    1100:	eb 9e                	jmp    10a0 <fourfiles+0xa0>
    close(fd);
    1102:	83 ec 0c             	sub    $0xc,%esp
    1105:	ff 75 d0             	pushl  -0x30(%ebp)
    1108:	e8 cd 27 00 00       	call   38da <close>
    if(total != 12*500){
    110d:	83 c4 10             	add    $0x10,%esp
    1110:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1116:	0f 85 d3 00 00 00    	jne    11ef <fourfiles+0x1ef>
    unlink(fname);
    111c:	83 ec 0c             	sub    $0xc,%esp
    111f:	ff 75 cc             	pushl  -0x34(%ebp)
    1122:	e8 db 27 00 00       	call   3902 <unlink>
  for(i = 0; i < 2; i++){
    1127:	83 c4 10             	add    $0x10,%esp
    112a:	83 ff 01             	cmp    $0x1,%edi
    112d:	75 1a                	jne    1149 <fourfiles+0x149>
  printf(1, "fourfiles ok\n");
    112f:	83 ec 08             	sub    $0x8,%esp
    1132:	68 22 42 00 00       	push   $0x4222
    1137:	6a 01                	push   $0x1
    1139:	e8 d2 28 00 00       	call   3a10 <printf>
}
    113e:	83 c4 10             	add    $0x10,%esp
    1141:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1144:	5b                   	pop    %ebx
    1145:	5e                   	pop    %esi
    1146:	5f                   	pop    %edi
    1147:	5d                   	pop    %ebp
    1148:	c3                   	ret    
    1149:	8b 45 dc             	mov    -0x24(%ebp),%eax
    114c:	bf 01 00 00 00       	mov    $0x1,%edi
    1151:	89 45 cc             	mov    %eax,-0x34(%ebp)
    1154:	e9 2c ff ff ff       	jmp    1085 <fourfiles+0x85>
      fd = open(fname, O_CREATE | O_RDWR);
    1159:	83 ec 08             	sub    $0x8,%esp
    115c:	68 02 02 00 00       	push   $0x202
    1161:	56                   	push   %esi
    1162:	e8 8b 27 00 00       	call   38f2 <open>
      if(fd < 0){
    1167:	83 c4 10             	add    $0x10,%esp
    116a:	85 c0                	test   %eax,%eax
      fd = open(fname, O_CREATE | O_RDWR);
    116c:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    116e:	78 59                	js     11c9 <fourfiles+0x1c9>
      memset(buf, '0'+pi, 512);
    1170:	83 ec 04             	sub    $0x4,%esp
    1173:	83 c3 30             	add    $0x30,%ebx
    1176:	68 00 02 00 00       	push   $0x200
    117b:	53                   	push   %ebx
    117c:	bb 0c 00 00 00       	mov    $0xc,%ebx
    1181:	68 00 86 00 00       	push   $0x8600
    1186:	e8 85 25 00 00       	call   3710 <memset>
    118b:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    118e:	83 ec 04             	sub    $0x4,%esp
    1191:	68 f4 01 00 00       	push   $0x1f4
    1196:	68 00 86 00 00       	push   $0x8600
    119b:	56                   	push   %esi
    119c:	e8 31 27 00 00       	call   38d2 <write>
    11a1:	83 c4 10             	add    $0x10,%esp
    11a4:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    11a9:	75 57                	jne    1202 <fourfiles+0x202>
      for(i = 0; i < 12; i++){
    11ab:	83 eb 01             	sub    $0x1,%ebx
    11ae:	75 de                	jne    118e <fourfiles+0x18e>
      exit();
    11b0:	e8 fd 26 00 00       	call   38b2 <exit>
          printf(1, "wrong char\n");
    11b5:	83 ec 08             	sub    $0x8,%esp
    11b8:	68 05 42 00 00       	push   $0x4205
    11bd:	6a 01                	push   $0x1
    11bf:	e8 4c 28 00 00       	call   3a10 <printf>
          exit();
    11c4:	e8 e9 26 00 00       	call   38b2 <exit>
        printf(1, "create failed\n");
    11c9:	51                   	push   %ecx
    11ca:	51                   	push   %ecx
    11cb:	68 7f 44 00 00       	push   $0x447f
    11d0:	6a 01                	push   $0x1
    11d2:	e8 39 28 00 00       	call   3a10 <printf>
        exit();
    11d7:	e8 d6 26 00 00       	call   38b2 <exit>
      printf(1, "fork failed\n");
    11dc:	53                   	push   %ebx
    11dd:	53                   	push   %ebx
    11de:	68 b9 4c 00 00       	push   $0x4cb9
    11e3:	6a 01                	push   $0x1
    11e5:	e8 26 28 00 00       	call   3a10 <printf>
      exit();
    11ea:	e8 c3 26 00 00       	call   38b2 <exit>
      printf(1, "wrong length %d\n", total);
    11ef:	50                   	push   %eax
    11f0:	53                   	push   %ebx
    11f1:	68 11 42 00 00       	push   $0x4211
    11f6:	6a 01                	push   $0x1
    11f8:	e8 13 28 00 00       	call   3a10 <printf>
      exit();
    11fd:	e8 b0 26 00 00       	call   38b2 <exit>
          printf(1, "write failed %d\n", n);
    1202:	52                   	push   %edx
    1203:	50                   	push   %eax
    1204:	68 e4 41 00 00       	push   $0x41e4
    1209:	6a 01                	push   $0x1
    120b:	e8 00 28 00 00       	call   3a10 <printf>
          exit();
    1210:	e8 9d 26 00 00       	call   38b2 <exit>
    1215:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001220 <createdelete>:
{
    1220:	55                   	push   %ebp
    1221:	89 e5                	mov    %esp,%ebp
    1223:	57                   	push   %edi
    1224:	56                   	push   %esi
    1225:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    1226:	31 db                	xor    %ebx,%ebx
{
    1228:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    122b:	68 30 42 00 00       	push   $0x4230
    1230:	6a 01                	push   $0x1
    1232:	e8 d9 27 00 00       	call   3a10 <printf>
    1237:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    123a:	e8 6b 26 00 00       	call   38aa <fork>
    if(pid < 0){
    123f:	85 c0                	test   %eax,%eax
    1241:	0f 88 be 01 00 00    	js     1405 <createdelete+0x1e5>
    if(pid == 0){
    1247:	0f 84 0b 01 00 00    	je     1358 <createdelete+0x138>
  for(pi = 0; pi < 4; pi++){
    124d:	83 c3 01             	add    $0x1,%ebx
    1250:	83 fb 04             	cmp    $0x4,%ebx
    1253:	75 e5                	jne    123a <createdelete+0x1a>
    1255:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    1258:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    125d:	e8 58 26 00 00       	call   38ba <wait>
    1262:	e8 53 26 00 00       	call   38ba <wait>
    1267:	e8 4e 26 00 00       	call   38ba <wait>
    126c:	e8 49 26 00 00       	call   38ba <wait>
  name[0] = name[1] = name[2] = 0;
    1271:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    1275:	8d 76 00             	lea    0x0(%esi),%esi
    1278:	8d 46 31             	lea    0x31(%esi),%eax
    127b:	88 45 c7             	mov    %al,-0x39(%ebp)
    127e:	8d 46 01             	lea    0x1(%esi),%eax
    1281:	83 f8 09             	cmp    $0x9,%eax
    1284:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1287:	0f 9f c3             	setg   %bl
    128a:	85 c0                	test   %eax,%eax
    128c:	0f 94 c0             	sete   %al
    128f:	09 c3                	or     %eax,%ebx
    1291:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    1294:	bb 70 00 00 00       	mov    $0x70,%ebx
      name[1] = '0' + i;
    1299:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      fd = open(name, 0);
    129d:	83 ec 08             	sub    $0x8,%esp
      name[0] = 'p' + pi;
    12a0:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    12a3:	6a 00                	push   $0x0
    12a5:	57                   	push   %edi
      name[1] = '0' + i;
    12a6:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    12a9:	e8 44 26 00 00       	call   38f2 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    12ae:	83 c4 10             	add    $0x10,%esp
    12b1:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    12b5:	0f 84 85 00 00 00    	je     1340 <createdelete+0x120>
    12bb:	85 c0                	test   %eax,%eax
    12bd:	0f 88 1a 01 00 00    	js     13dd <createdelete+0x1bd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    12c3:	83 fe 08             	cmp    $0x8,%esi
    12c6:	0f 86 54 01 00 00    	jbe    1420 <createdelete+0x200>
        close(fd);
    12cc:	83 ec 0c             	sub    $0xc,%esp
    12cf:	50                   	push   %eax
    12d0:	e8 05 26 00 00       	call   38da <close>
    12d5:	83 c4 10             	add    $0x10,%esp
    12d8:	83 c3 01             	add    $0x1,%ebx
    for(pi = 0; pi < 4; pi++){
    12db:	80 fb 74             	cmp    $0x74,%bl
    12de:	75 b9                	jne    1299 <createdelete+0x79>
    12e0:	8b 75 c0             	mov    -0x40(%ebp),%esi
  for(i = 0; i < N; i++){
    12e3:	83 fe 13             	cmp    $0x13,%esi
    12e6:	75 90                	jne    1278 <createdelete+0x58>
    12e8:	be 70 00 00 00       	mov    $0x70,%esi
    12ed:	8d 76 00             	lea    0x0(%esi),%esi
    12f0:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    12f3:	bb 04 00 00 00       	mov    $0x4,%ebx
    12f8:	88 45 c7             	mov    %al,-0x39(%ebp)
      name[0] = 'p' + i;
    12fb:	89 f0                	mov    %esi,%eax
      unlink(name);
    12fd:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    1300:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1303:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      unlink(name);
    1307:	57                   	push   %edi
      name[1] = '0' + i;
    1308:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    130b:	e8 f2 25 00 00       	call   3902 <unlink>
    for(pi = 0; pi < 4; pi++){
    1310:	83 c4 10             	add    $0x10,%esp
    1313:	83 eb 01             	sub    $0x1,%ebx
    1316:	75 e3                	jne    12fb <createdelete+0xdb>
    1318:	83 c6 01             	add    $0x1,%esi
  for(i = 0; i < N; i++){
    131b:	89 f0                	mov    %esi,%eax
    131d:	3c 84                	cmp    $0x84,%al
    131f:	75 cf                	jne    12f0 <createdelete+0xd0>
  printf(1, "createdelete ok\n");
    1321:	83 ec 08             	sub    $0x8,%esp
    1324:	68 43 42 00 00       	push   $0x4243
    1329:	6a 01                	push   $0x1
    132b:	e8 e0 26 00 00       	call   3a10 <printf>
}
    1330:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1333:	5b                   	pop    %ebx
    1334:	5e                   	pop    %esi
    1335:	5f                   	pop    %edi
    1336:	5d                   	pop    %ebp
    1337:	c3                   	ret    
    1338:	90                   	nop
    1339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1340:	83 fe 08             	cmp    $0x8,%esi
    1343:	0f 86 cf 00 00 00    	jbe    1418 <createdelete+0x1f8>
      if(fd >= 0)
    1349:	85 c0                	test   %eax,%eax
    134b:	78 8b                	js     12d8 <createdelete+0xb8>
    134d:	e9 7a ff ff ff       	jmp    12cc <createdelete+0xac>
    1352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    1358:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    135b:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    135f:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    1362:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    1365:	31 db                	xor    %ebx,%ebx
    1367:	eb 0f                	jmp    1378 <createdelete+0x158>
    1369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    1370:	83 fb 13             	cmp    $0x13,%ebx
    1373:	74 63                	je     13d8 <createdelete+0x1b8>
    1375:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    1378:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    137b:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    137e:	68 02 02 00 00       	push   $0x202
    1383:	57                   	push   %edi
        name[1] = '0' + i;
    1384:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1387:	e8 66 25 00 00       	call   38f2 <open>
        if(fd < 0){
    138c:	83 c4 10             	add    $0x10,%esp
    138f:	85 c0                	test   %eax,%eax
    1391:	78 5f                	js     13f2 <createdelete+0x1d2>
        close(fd);
    1393:	83 ec 0c             	sub    $0xc,%esp
    1396:	50                   	push   %eax
    1397:	e8 3e 25 00 00       	call   38da <close>
        if(i > 0 && (i % 2 ) == 0){
    139c:	83 c4 10             	add    $0x10,%esp
    139f:	85 db                	test   %ebx,%ebx
    13a1:	74 d2                	je     1375 <createdelete+0x155>
    13a3:	f6 c3 01             	test   $0x1,%bl
    13a6:	75 c8                	jne    1370 <createdelete+0x150>
          if(unlink(name) < 0){
    13a8:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    13ab:	89 d8                	mov    %ebx,%eax
    13ad:	d1 f8                	sar    %eax
          if(unlink(name) < 0){
    13af:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    13b0:	83 c0 30             	add    $0x30,%eax
    13b3:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    13b6:	e8 47 25 00 00       	call   3902 <unlink>
    13bb:	83 c4 10             	add    $0x10,%esp
    13be:	85 c0                	test   %eax,%eax
    13c0:	79 ae                	jns    1370 <createdelete+0x150>
            printf(1, "unlink failed\n");
    13c2:	52                   	push   %edx
    13c3:	52                   	push   %edx
    13c4:	68 21 3e 00 00       	push   $0x3e21
    13c9:	6a 01                	push   $0x1
    13cb:	e8 40 26 00 00       	call   3a10 <printf>
            exit();
    13d0:	e8 dd 24 00 00       	call   38b2 <exit>
    13d5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    13d8:	e8 d5 24 00 00       	call   38b2 <exit>
        printf(1, "oops createdelete %s didn't exist\n", name);
    13dd:	83 ec 04             	sub    $0x4,%esp
    13e0:	57                   	push   %edi
    13e1:	68 f0 4e 00 00       	push   $0x4ef0
    13e6:	6a 01                	push   $0x1
    13e8:	e8 23 26 00 00       	call   3a10 <printf>
        exit();
    13ed:	e8 c0 24 00 00       	call   38b2 <exit>
          printf(1, "create failed\n");
    13f2:	51                   	push   %ecx
    13f3:	51                   	push   %ecx
    13f4:	68 7f 44 00 00       	push   $0x447f
    13f9:	6a 01                	push   $0x1
    13fb:	e8 10 26 00 00       	call   3a10 <printf>
          exit();
    1400:	e8 ad 24 00 00       	call   38b2 <exit>
      printf(1, "fork failed\n");
    1405:	53                   	push   %ebx
    1406:	53                   	push   %ebx
    1407:	68 b9 4c 00 00       	push   $0x4cb9
    140c:	6a 01                	push   $0x1
    140e:	e8 fd 25 00 00       	call   3a10 <printf>
      exit();
    1413:	e8 9a 24 00 00       	call   38b2 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1418:	85 c0                	test   %eax,%eax
    141a:	0f 88 b8 fe ff ff    	js     12d8 <createdelete+0xb8>
        printf(1, "oops createdelete %s did exist\n", name);
    1420:	50                   	push   %eax
    1421:	57                   	push   %edi
    1422:	68 14 4f 00 00       	push   $0x4f14
    1427:	6a 01                	push   $0x1
    1429:	e8 e2 25 00 00       	call   3a10 <printf>
        exit();
    142e:	e8 7f 24 00 00       	call   38b2 <exit>
    1433:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    1439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001440 <unlinkread>:
{
    1440:	55                   	push   %ebp
    1441:	89 e5                	mov    %esp,%ebp
    1443:	56                   	push   %esi
    1444:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    1445:	83 ec 08             	sub    $0x8,%esp
    1448:	68 54 42 00 00       	push   $0x4254
    144d:	6a 01                	push   $0x1
    144f:	e8 bc 25 00 00       	call   3a10 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1454:	5b                   	pop    %ebx
    1455:	5e                   	pop    %esi
    1456:	68 02 02 00 00       	push   $0x202
    145b:	68 65 42 00 00       	push   $0x4265
    1460:	e8 8d 24 00 00       	call   38f2 <open>
  if(fd < 0){
    1465:	83 c4 10             	add    $0x10,%esp
    1468:	85 c0                	test   %eax,%eax
    146a:	0f 88 e6 00 00 00    	js     1556 <unlinkread+0x116>
  write(fd, "hello", 5);
    1470:	83 ec 04             	sub    $0x4,%esp
    1473:	89 c3                	mov    %eax,%ebx
    1475:	6a 05                	push   $0x5
    1477:	68 8a 42 00 00       	push   $0x428a
    147c:	50                   	push   %eax
    147d:	e8 50 24 00 00       	call   38d2 <write>
  close(fd);
    1482:	89 1c 24             	mov    %ebx,(%esp)
    1485:	e8 50 24 00 00       	call   38da <close>
  fd = open("unlinkread", O_RDWR);
    148a:	58                   	pop    %eax
    148b:	5a                   	pop    %edx
    148c:	6a 02                	push   $0x2
    148e:	68 65 42 00 00       	push   $0x4265
    1493:	e8 5a 24 00 00       	call   38f2 <open>
  if(fd < 0){
    1498:	83 c4 10             	add    $0x10,%esp
    149b:	85 c0                	test   %eax,%eax
  fd = open("unlinkread", O_RDWR);
    149d:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    149f:	0f 88 10 01 00 00    	js     15b5 <unlinkread+0x175>
  if(unlink("unlinkread") != 0){
    14a5:	83 ec 0c             	sub    $0xc,%esp
    14a8:	68 65 42 00 00       	push   $0x4265
    14ad:	e8 50 24 00 00       	call   3902 <unlink>
    14b2:	83 c4 10             	add    $0x10,%esp
    14b5:	85 c0                	test   %eax,%eax
    14b7:	0f 85 e5 00 00 00    	jne    15a2 <unlinkread+0x162>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    14bd:	83 ec 08             	sub    $0x8,%esp
    14c0:	68 02 02 00 00       	push   $0x202
    14c5:	68 65 42 00 00       	push   $0x4265
    14ca:	e8 23 24 00 00       	call   38f2 <open>
  write(fd1, "yyy", 3);
    14cf:	83 c4 0c             	add    $0xc,%esp
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    14d2:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    14d4:	6a 03                	push   $0x3
    14d6:	68 c2 42 00 00       	push   $0x42c2
    14db:	50                   	push   %eax
    14dc:	e8 f1 23 00 00       	call   38d2 <write>
  close(fd1);
    14e1:	89 34 24             	mov    %esi,(%esp)
    14e4:	e8 f1 23 00 00       	call   38da <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    14e9:	83 c4 0c             	add    $0xc,%esp
    14ec:	68 00 20 00 00       	push   $0x2000
    14f1:	68 00 86 00 00       	push   $0x8600
    14f6:	53                   	push   %ebx
    14f7:	e8 ce 23 00 00       	call   38ca <read>
    14fc:	83 c4 10             	add    $0x10,%esp
    14ff:	83 f8 05             	cmp    $0x5,%eax
    1502:	0f 85 87 00 00 00    	jne    158f <unlinkread+0x14f>
  if(buf[0] != 'h'){
    1508:	80 3d 00 86 00 00 68 	cmpb   $0x68,0x8600
    150f:	75 6b                	jne    157c <unlinkread+0x13c>
  if(write(fd, buf, 10) != 10){
    1511:	83 ec 04             	sub    $0x4,%esp
    1514:	6a 0a                	push   $0xa
    1516:	68 00 86 00 00       	push   $0x8600
    151b:	53                   	push   %ebx
    151c:	e8 b1 23 00 00       	call   38d2 <write>
    1521:	83 c4 10             	add    $0x10,%esp
    1524:	83 f8 0a             	cmp    $0xa,%eax
    1527:	75 40                	jne    1569 <unlinkread+0x129>
  close(fd);
    1529:	83 ec 0c             	sub    $0xc,%esp
    152c:	53                   	push   %ebx
    152d:	e8 a8 23 00 00       	call   38da <close>
  unlink("unlinkread");
    1532:	c7 04 24 65 42 00 00 	movl   $0x4265,(%esp)
    1539:	e8 c4 23 00 00       	call   3902 <unlink>
  printf(1, "unlinkread ok\n");
    153e:	58                   	pop    %eax
    153f:	5a                   	pop    %edx
    1540:	68 0d 43 00 00       	push   $0x430d
    1545:	6a 01                	push   $0x1
    1547:	e8 c4 24 00 00       	call   3a10 <printf>
}
    154c:	83 c4 10             	add    $0x10,%esp
    154f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1552:	5b                   	pop    %ebx
    1553:	5e                   	pop    %esi
    1554:	5d                   	pop    %ebp
    1555:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1556:	51                   	push   %ecx
    1557:	51                   	push   %ecx
    1558:	68 70 42 00 00       	push   $0x4270
    155d:	6a 01                	push   $0x1
    155f:	e8 ac 24 00 00       	call   3a10 <printf>
    exit();
    1564:	e8 49 23 00 00       	call   38b2 <exit>
    printf(1, "unlinkread write failed\n");
    1569:	51                   	push   %ecx
    156a:	51                   	push   %ecx
    156b:	68 f4 42 00 00       	push   $0x42f4
    1570:	6a 01                	push   $0x1
    1572:	e8 99 24 00 00       	call   3a10 <printf>
    exit();
    1577:	e8 36 23 00 00       	call   38b2 <exit>
    printf(1, "unlinkread wrong data\n");
    157c:	53                   	push   %ebx
    157d:	53                   	push   %ebx
    157e:	68 dd 42 00 00       	push   $0x42dd
    1583:	6a 01                	push   $0x1
    1585:	e8 86 24 00 00       	call   3a10 <printf>
    exit();
    158a:	e8 23 23 00 00       	call   38b2 <exit>
    printf(1, "unlinkread read failed");
    158f:	56                   	push   %esi
    1590:	56                   	push   %esi
    1591:	68 c6 42 00 00       	push   $0x42c6
    1596:	6a 01                	push   $0x1
    1598:	e8 73 24 00 00       	call   3a10 <printf>
    exit();
    159d:	e8 10 23 00 00       	call   38b2 <exit>
    printf(1, "unlink unlinkread failed\n");
    15a2:	50                   	push   %eax
    15a3:	50                   	push   %eax
    15a4:	68 a8 42 00 00       	push   $0x42a8
    15a9:	6a 01                	push   $0x1
    15ab:	e8 60 24 00 00       	call   3a10 <printf>
    exit();
    15b0:	e8 fd 22 00 00       	call   38b2 <exit>
    printf(1, "open unlinkread failed\n");
    15b5:	50                   	push   %eax
    15b6:	50                   	push   %eax
    15b7:	68 90 42 00 00       	push   $0x4290
    15bc:	6a 01                	push   $0x1
    15be:	e8 4d 24 00 00       	call   3a10 <printf>
    exit();
    15c3:	e8 ea 22 00 00       	call   38b2 <exit>
    15c8:	90                   	nop
    15c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000015d0 <linktest>:
{
    15d0:	55                   	push   %ebp
    15d1:	89 e5                	mov    %esp,%ebp
    15d3:	53                   	push   %ebx
    15d4:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    15d7:	68 1c 43 00 00       	push   $0x431c
    15dc:	6a 01                	push   $0x1
    15de:	e8 2d 24 00 00       	call   3a10 <printf>
  unlink("lf1");
    15e3:	c7 04 24 26 43 00 00 	movl   $0x4326,(%esp)
    15ea:	e8 13 23 00 00       	call   3902 <unlink>
  unlink("lf2");
    15ef:	c7 04 24 2a 43 00 00 	movl   $0x432a,(%esp)
    15f6:	e8 07 23 00 00       	call   3902 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    15fb:	58                   	pop    %eax
    15fc:	5a                   	pop    %edx
    15fd:	68 02 02 00 00       	push   $0x202
    1602:	68 26 43 00 00       	push   $0x4326
    1607:	e8 e6 22 00 00       	call   38f2 <open>
  if(fd < 0){
    160c:	83 c4 10             	add    $0x10,%esp
    160f:	85 c0                	test   %eax,%eax
    1611:	0f 88 1e 01 00 00    	js     1735 <linktest+0x165>
  if(write(fd, "hello", 5) != 5){
    1617:	83 ec 04             	sub    $0x4,%esp
    161a:	89 c3                	mov    %eax,%ebx
    161c:	6a 05                	push   $0x5
    161e:	68 8a 42 00 00       	push   $0x428a
    1623:	50                   	push   %eax
    1624:	e8 a9 22 00 00       	call   38d2 <write>
    1629:	83 c4 10             	add    $0x10,%esp
    162c:	83 f8 05             	cmp    $0x5,%eax
    162f:	0f 85 98 01 00 00    	jne    17cd <linktest+0x1fd>
  close(fd);
    1635:	83 ec 0c             	sub    $0xc,%esp
    1638:	53                   	push   %ebx
    1639:	e8 9c 22 00 00       	call   38da <close>
  if(link("lf1", "lf2") < 0){
    163e:	5b                   	pop    %ebx
    163f:	58                   	pop    %eax
    1640:	68 2a 43 00 00       	push   $0x432a
    1645:	68 26 43 00 00       	push   $0x4326
    164a:	e8 c3 22 00 00       	call   3912 <link>
    164f:	83 c4 10             	add    $0x10,%esp
    1652:	85 c0                	test   %eax,%eax
    1654:	0f 88 60 01 00 00    	js     17ba <linktest+0x1ea>
  unlink("lf1");
    165a:	83 ec 0c             	sub    $0xc,%esp
    165d:	68 26 43 00 00       	push   $0x4326
    1662:	e8 9b 22 00 00       	call   3902 <unlink>
  if(open("lf1", 0) >= 0){
    1667:	58                   	pop    %eax
    1668:	5a                   	pop    %edx
    1669:	6a 00                	push   $0x0
    166b:	68 26 43 00 00       	push   $0x4326
    1670:	e8 7d 22 00 00       	call   38f2 <open>
    1675:	83 c4 10             	add    $0x10,%esp
    1678:	85 c0                	test   %eax,%eax
    167a:	0f 89 27 01 00 00    	jns    17a7 <linktest+0x1d7>
  fd = open("lf2", 0);
    1680:	83 ec 08             	sub    $0x8,%esp
    1683:	6a 00                	push   $0x0
    1685:	68 2a 43 00 00       	push   $0x432a
    168a:	e8 63 22 00 00       	call   38f2 <open>
  if(fd < 0){
    168f:	83 c4 10             	add    $0x10,%esp
    1692:	85 c0                	test   %eax,%eax
  fd = open("lf2", 0);
    1694:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1696:	0f 88 f8 00 00 00    	js     1794 <linktest+0x1c4>
  if(read(fd, buf, sizeof(buf)) != 5){
    169c:	83 ec 04             	sub    $0x4,%esp
    169f:	68 00 20 00 00       	push   $0x2000
    16a4:	68 00 86 00 00       	push   $0x8600
    16a9:	50                   	push   %eax
    16aa:	e8 1b 22 00 00       	call   38ca <read>
    16af:	83 c4 10             	add    $0x10,%esp
    16b2:	83 f8 05             	cmp    $0x5,%eax
    16b5:	0f 85 c6 00 00 00    	jne    1781 <linktest+0x1b1>
  close(fd);
    16bb:	83 ec 0c             	sub    $0xc,%esp
    16be:	53                   	push   %ebx
    16bf:	e8 16 22 00 00       	call   38da <close>
  if(link("lf2", "lf2") >= 0){
    16c4:	58                   	pop    %eax
    16c5:	5a                   	pop    %edx
    16c6:	68 2a 43 00 00       	push   $0x432a
    16cb:	68 2a 43 00 00       	push   $0x432a
    16d0:	e8 3d 22 00 00       	call   3912 <link>
    16d5:	83 c4 10             	add    $0x10,%esp
    16d8:	85 c0                	test   %eax,%eax
    16da:	0f 89 8e 00 00 00    	jns    176e <linktest+0x19e>
  unlink("lf2");
    16e0:	83 ec 0c             	sub    $0xc,%esp
    16e3:	68 2a 43 00 00       	push   $0x432a
    16e8:	e8 15 22 00 00       	call   3902 <unlink>
  if(link("lf2", "lf1") >= 0){
    16ed:	59                   	pop    %ecx
    16ee:	5b                   	pop    %ebx
    16ef:	68 26 43 00 00       	push   $0x4326
    16f4:	68 2a 43 00 00       	push   $0x432a
    16f9:	e8 14 22 00 00       	call   3912 <link>
    16fe:	83 c4 10             	add    $0x10,%esp
    1701:	85 c0                	test   %eax,%eax
    1703:	79 56                	jns    175b <linktest+0x18b>
  if(link(".", "lf1") >= 0){
    1705:	83 ec 08             	sub    $0x8,%esp
    1708:	68 26 43 00 00       	push   $0x4326
    170d:	68 ee 45 00 00       	push   $0x45ee
    1712:	e8 fb 21 00 00       	call   3912 <link>
    1717:	83 c4 10             	add    $0x10,%esp
    171a:	85 c0                	test   %eax,%eax
    171c:	79 2a                	jns    1748 <linktest+0x178>
  printf(1, "linktest ok\n");
    171e:	83 ec 08             	sub    $0x8,%esp
    1721:	68 c4 43 00 00       	push   $0x43c4
    1726:	6a 01                	push   $0x1
    1728:	e8 e3 22 00 00       	call   3a10 <printf>
}
    172d:	83 c4 10             	add    $0x10,%esp
    1730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1733:	c9                   	leave  
    1734:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1735:	50                   	push   %eax
    1736:	50                   	push   %eax
    1737:	68 2e 43 00 00       	push   $0x432e
    173c:	6a 01                	push   $0x1
    173e:	e8 cd 22 00 00       	call   3a10 <printf>
    exit();
    1743:	e8 6a 21 00 00       	call   38b2 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    1748:	50                   	push   %eax
    1749:	50                   	push   %eax
    174a:	68 a8 43 00 00       	push   $0x43a8
    174f:	6a 01                	push   $0x1
    1751:	e8 ba 22 00 00       	call   3a10 <printf>
    exit();
    1756:	e8 57 21 00 00       	call   38b2 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    175b:	52                   	push   %edx
    175c:	52                   	push   %edx
    175d:	68 5c 4f 00 00       	push   $0x4f5c
    1762:	6a 01                	push   $0x1
    1764:	e8 a7 22 00 00       	call   3a10 <printf>
    exit();
    1769:	e8 44 21 00 00       	call   38b2 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    176e:	50                   	push   %eax
    176f:	50                   	push   %eax
    1770:	68 8a 43 00 00       	push   $0x438a
    1775:	6a 01                	push   $0x1
    1777:	e8 94 22 00 00       	call   3a10 <printf>
    exit();
    177c:	e8 31 21 00 00       	call   38b2 <exit>
    printf(1, "read lf2 failed\n");
    1781:	51                   	push   %ecx
    1782:	51                   	push   %ecx
    1783:	68 79 43 00 00       	push   $0x4379
    1788:	6a 01                	push   $0x1
    178a:	e8 81 22 00 00       	call   3a10 <printf>
    exit();
    178f:	e8 1e 21 00 00       	call   38b2 <exit>
    printf(1, "open lf2 failed\n");
    1794:	53                   	push   %ebx
    1795:	53                   	push   %ebx
    1796:	68 68 43 00 00       	push   $0x4368
    179b:	6a 01                	push   $0x1
    179d:	e8 6e 22 00 00       	call   3a10 <printf>
    exit();
    17a2:	e8 0b 21 00 00       	call   38b2 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    17a7:	50                   	push   %eax
    17a8:	50                   	push   %eax
    17a9:	68 34 4f 00 00       	push   $0x4f34
    17ae:	6a 01                	push   $0x1
    17b0:	e8 5b 22 00 00       	call   3a10 <printf>
    exit();
    17b5:	e8 f8 20 00 00       	call   38b2 <exit>
    printf(1, "link lf1 lf2 failed\n");
    17ba:	51                   	push   %ecx
    17bb:	51                   	push   %ecx
    17bc:	68 53 43 00 00       	push   $0x4353
    17c1:	6a 01                	push   $0x1
    17c3:	e8 48 22 00 00       	call   3a10 <printf>
    exit();
    17c8:	e8 e5 20 00 00       	call   38b2 <exit>
    printf(1, "write lf1 failed\n");
    17cd:	50                   	push   %eax
    17ce:	50                   	push   %eax
    17cf:	68 41 43 00 00       	push   $0x4341
    17d4:	6a 01                	push   $0x1
    17d6:	e8 35 22 00 00       	call   3a10 <printf>
    exit();
    17db:	e8 d2 20 00 00       	call   38b2 <exit>

000017e0 <concreate>:
{
    17e0:	55                   	push   %ebp
    17e1:	89 e5                	mov    %esp,%ebp
    17e3:	57                   	push   %edi
    17e4:	56                   	push   %esi
    17e5:	53                   	push   %ebx
  for(i = 0; i < 40; i++){
    17e6:	31 f6                	xor    %esi,%esi
    17e8:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    if(pid && (i % 3) == 1){
    17eb:	bf ab aa aa aa       	mov    $0xaaaaaaab,%edi
{
    17f0:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    17f3:	68 d1 43 00 00       	push   $0x43d1
    17f8:	6a 01                	push   $0x1
    17fa:	e8 11 22 00 00       	call   3a10 <printf>
  file[0] = 'C';
    17ff:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1803:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
    1807:	83 c4 10             	add    $0x10,%esp
    180a:	eb 4c                	jmp    1858 <concreate+0x78>
    180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pid && (i % 3) == 1){
    1810:	89 f0                	mov    %esi,%eax
    1812:	89 f1                	mov    %esi,%ecx
    1814:	f7 e7                	mul    %edi
    1816:	d1 ea                	shr    %edx
    1818:	8d 04 52             	lea    (%edx,%edx,2),%eax
    181b:	29 c1                	sub    %eax,%ecx
    181d:	83 f9 01             	cmp    $0x1,%ecx
    1820:	0f 84 ba 00 00 00    	je     18e0 <concreate+0x100>
      fd = open(file, O_CREATE | O_RDWR);
    1826:	83 ec 08             	sub    $0x8,%esp
    1829:	68 02 02 00 00       	push   $0x202
    182e:	53                   	push   %ebx
    182f:	e8 be 20 00 00       	call   38f2 <open>
      if(fd < 0){
    1834:	83 c4 10             	add    $0x10,%esp
    1837:	85 c0                	test   %eax,%eax
    1839:	78 67                	js     18a2 <concreate+0xc2>
      close(fd);
    183b:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    183e:	83 c6 01             	add    $0x1,%esi
      close(fd);
    1841:	50                   	push   %eax
    1842:	e8 93 20 00 00       	call   38da <close>
    1847:	83 c4 10             	add    $0x10,%esp
      wait();
    184a:	e8 6b 20 00 00       	call   38ba <wait>
  for(i = 0; i < 40; i++){
    184f:	83 fe 28             	cmp    $0x28,%esi
    1852:	0f 84 aa 00 00 00    	je     1902 <concreate+0x122>
    unlink(file);
    1858:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    185b:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    185e:	53                   	push   %ebx
    file[1] = '0' + i;
    185f:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    1862:	e8 9b 20 00 00       	call   3902 <unlink>
    pid = fork();
    1867:	e8 3e 20 00 00       	call   38aa <fork>
    if(pid && (i % 3) == 1){
    186c:	83 c4 10             	add    $0x10,%esp
    186f:	85 c0                	test   %eax,%eax
    1871:	75 9d                	jne    1810 <concreate+0x30>
    } else if(pid == 0 && (i % 5) == 1){
    1873:	89 f0                	mov    %esi,%eax
    1875:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    187a:	f7 e2                	mul    %edx
    187c:	c1 ea 02             	shr    $0x2,%edx
    187f:	8d 04 92             	lea    (%edx,%edx,4),%eax
    1882:	29 c6                	sub    %eax,%esi
    1884:	83 fe 01             	cmp    $0x1,%esi
    1887:	74 37                	je     18c0 <concreate+0xe0>
      fd = open(file, O_CREATE | O_RDWR);
    1889:	83 ec 08             	sub    $0x8,%esp
    188c:	68 02 02 00 00       	push   $0x202
    1891:	53                   	push   %ebx
    1892:	e8 5b 20 00 00       	call   38f2 <open>
      if(fd < 0){
    1897:	83 c4 10             	add    $0x10,%esp
    189a:	85 c0                	test   %eax,%eax
    189c:	0f 89 28 02 00 00    	jns    1aca <concreate+0x2ea>
        printf(1, "concreate create %s failed\n", file);
    18a2:	83 ec 04             	sub    $0x4,%esp
    18a5:	53                   	push   %ebx
    18a6:	68 e4 43 00 00       	push   $0x43e4
    18ab:	6a 01                	push   $0x1
    18ad:	e8 5e 21 00 00       	call   3a10 <printf>
        exit();
    18b2:	e8 fb 1f 00 00       	call   38b2 <exit>
    18b7:	89 f6                	mov    %esi,%esi
    18b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      link("C0", file);
    18c0:	83 ec 08             	sub    $0x8,%esp
    18c3:	53                   	push   %ebx
    18c4:	68 e1 43 00 00       	push   $0x43e1
    18c9:	e8 44 20 00 00       	call   3912 <link>
    18ce:	83 c4 10             	add    $0x10,%esp
      exit();
    18d1:	e8 dc 1f 00 00       	call   38b2 <exit>
    18d6:	8d 76 00             	lea    0x0(%esi),%esi
    18d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      link("C0", file);
    18e0:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    18e3:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    18e6:	53                   	push   %ebx
    18e7:	68 e1 43 00 00       	push   $0x43e1
    18ec:	e8 21 20 00 00       	call   3912 <link>
    18f1:	83 c4 10             	add    $0x10,%esp
      wait();
    18f4:	e8 c1 1f 00 00       	call   38ba <wait>
  for(i = 0; i < 40; i++){
    18f9:	83 fe 28             	cmp    $0x28,%esi
    18fc:	0f 85 56 ff ff ff    	jne    1858 <concreate+0x78>
  memset(fa, 0, sizeof(fa));
    1902:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1905:	83 ec 04             	sub    $0x4,%esp
    1908:	6a 28                	push   $0x28
    190a:	6a 00                	push   $0x0
    190c:	50                   	push   %eax
    190d:	e8 fe 1d 00 00       	call   3710 <memset>
  fd = open(".", 0);
    1912:	5f                   	pop    %edi
    1913:	58                   	pop    %eax
    1914:	6a 00                	push   $0x0
    1916:	68 ee 45 00 00       	push   $0x45ee
    191b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    191e:	e8 cf 1f 00 00       	call   38f2 <open>
  while(read(fd, &de, sizeof(de)) > 0){
    1923:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    1926:	89 c6                	mov    %eax,%esi
  n = 0;
    1928:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
    192f:	90                   	nop
  while(read(fd, &de, sizeof(de)) > 0){
    1930:	83 ec 04             	sub    $0x4,%esp
    1933:	6a 10                	push   $0x10
    1935:	57                   	push   %edi
    1936:	56                   	push   %esi
    1937:	e8 8e 1f 00 00       	call   38ca <read>
    193c:	83 c4 10             	add    $0x10,%esp
    193f:	85 c0                	test   %eax,%eax
    1941:	7e 3d                	jle    1980 <concreate+0x1a0>
    if(de.inum == 0)
    1943:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    1948:	74 e6                	je     1930 <concreate+0x150>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    194a:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    194e:	75 e0                	jne    1930 <concreate+0x150>
    1950:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    1954:	75 da                	jne    1930 <concreate+0x150>
      i = de.name[1] - '0';
    1956:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    195a:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    195d:	83 f8 27             	cmp    $0x27,%eax
    1960:	0f 87 4e 01 00 00    	ja     1ab4 <concreate+0x2d4>
      if(fa[i]){
    1966:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    196b:	0f 85 2d 01 00 00    	jne    1a9e <concreate+0x2be>
      fa[i] = 1;
    1971:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    1976:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
    197a:	eb b4                	jmp    1930 <concreate+0x150>
    197c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    1980:	83 ec 0c             	sub    $0xc,%esp
    1983:	56                   	push   %esi
    1984:	e8 51 1f 00 00       	call   38da <close>
  if(n != 40){
    1989:	83 c4 10             	add    $0x10,%esp
    198c:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1990:	0f 85 f5 00 00 00    	jne    1a8b <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    1996:	31 f6                	xor    %esi,%esi
    1998:	eb 48                	jmp    19e2 <concreate+0x202>
    199a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    19a0:	85 ff                	test   %edi,%edi
    19a2:	74 05                	je     19a9 <concreate+0x1c9>
    19a4:	83 fa 01             	cmp    $0x1,%edx
    19a7:	74 64                	je     1a0d <concreate+0x22d>
      unlink(file);
    19a9:	83 ec 0c             	sub    $0xc,%esp
    19ac:	53                   	push   %ebx
    19ad:	e8 50 1f 00 00       	call   3902 <unlink>
      unlink(file);
    19b2:	89 1c 24             	mov    %ebx,(%esp)
    19b5:	e8 48 1f 00 00       	call   3902 <unlink>
      unlink(file);
    19ba:	89 1c 24             	mov    %ebx,(%esp)
    19bd:	e8 40 1f 00 00       	call   3902 <unlink>
      unlink(file);
    19c2:	89 1c 24             	mov    %ebx,(%esp)
    19c5:	e8 38 1f 00 00       	call   3902 <unlink>
    19ca:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    19cd:	85 ff                	test   %edi,%edi
    19cf:	0f 84 fc fe ff ff    	je     18d1 <concreate+0xf1>
  for(i = 0; i < 40; i++){
    19d5:	83 c6 01             	add    $0x1,%esi
      wait();
    19d8:	e8 dd 1e 00 00       	call   38ba <wait>
  for(i = 0; i < 40; i++){
    19dd:	83 fe 28             	cmp    $0x28,%esi
    19e0:	74 7e                	je     1a60 <concreate+0x280>
    file[1] = '0' + i;
    19e2:	8d 46 30             	lea    0x30(%esi),%eax
    19e5:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    19e8:	e8 bd 1e 00 00       	call   38aa <fork>
    if(pid < 0){
    19ed:	85 c0                	test   %eax,%eax
    pid = fork();
    19ef:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    19f1:	0f 88 80 00 00 00    	js     1a77 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    19f7:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    19fc:	f7 e6                	mul    %esi
    19fe:	d1 ea                	shr    %edx
    1a00:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1a03:	89 f2                	mov    %esi,%edx
    1a05:	29 c2                	sub    %eax,%edx
    1a07:	89 d0                	mov    %edx,%eax
    1a09:	09 f8                	or     %edi,%eax
    1a0b:	75 93                	jne    19a0 <concreate+0x1c0>
      close(open(file, 0));
    1a0d:	83 ec 08             	sub    $0x8,%esp
    1a10:	6a 00                	push   $0x0
    1a12:	53                   	push   %ebx
    1a13:	e8 da 1e 00 00       	call   38f2 <open>
    1a18:	89 04 24             	mov    %eax,(%esp)
    1a1b:	e8 ba 1e 00 00       	call   38da <close>
      close(open(file, 0));
    1a20:	58                   	pop    %eax
    1a21:	5a                   	pop    %edx
    1a22:	6a 00                	push   $0x0
    1a24:	53                   	push   %ebx
    1a25:	e8 c8 1e 00 00       	call   38f2 <open>
    1a2a:	89 04 24             	mov    %eax,(%esp)
    1a2d:	e8 a8 1e 00 00       	call   38da <close>
      close(open(file, 0));
    1a32:	59                   	pop    %ecx
    1a33:	58                   	pop    %eax
    1a34:	6a 00                	push   $0x0
    1a36:	53                   	push   %ebx
    1a37:	e8 b6 1e 00 00       	call   38f2 <open>
    1a3c:	89 04 24             	mov    %eax,(%esp)
    1a3f:	e8 96 1e 00 00       	call   38da <close>
      close(open(file, 0));
    1a44:	58                   	pop    %eax
    1a45:	5a                   	pop    %edx
    1a46:	6a 00                	push   $0x0
    1a48:	53                   	push   %ebx
    1a49:	e8 a4 1e 00 00       	call   38f2 <open>
    1a4e:	89 04 24             	mov    %eax,(%esp)
    1a51:	e8 84 1e 00 00       	call   38da <close>
    1a56:	83 c4 10             	add    $0x10,%esp
    1a59:	e9 6f ff ff ff       	jmp    19cd <concreate+0x1ed>
    1a5e:	66 90                	xchg   %ax,%ax
  printf(1, "concreate ok\n");
    1a60:	83 ec 08             	sub    $0x8,%esp
    1a63:	68 36 44 00 00       	push   $0x4436
    1a68:	6a 01                	push   $0x1
    1a6a:	e8 a1 1f 00 00       	call   3a10 <printf>
}
    1a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1a72:	5b                   	pop    %ebx
    1a73:	5e                   	pop    %esi
    1a74:	5f                   	pop    %edi
    1a75:	5d                   	pop    %ebp
    1a76:	c3                   	ret    
      printf(1, "fork failed\n");
    1a77:	83 ec 08             	sub    $0x8,%esp
    1a7a:	68 b9 4c 00 00       	push   $0x4cb9
    1a7f:	6a 01                	push   $0x1
    1a81:	e8 8a 1f 00 00       	call   3a10 <printf>
      exit();
    1a86:	e8 27 1e 00 00       	call   38b2 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    1a8b:	51                   	push   %ecx
    1a8c:	51                   	push   %ecx
    1a8d:	68 80 4f 00 00       	push   $0x4f80
    1a92:	6a 01                	push   $0x1
    1a94:	e8 77 1f 00 00       	call   3a10 <printf>
    exit();
    1a99:	e8 14 1e 00 00       	call   38b2 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1a9e:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1aa1:	53                   	push   %ebx
    1aa2:	50                   	push   %eax
    1aa3:	68 19 44 00 00       	push   $0x4419
    1aa8:	6a 01                	push   $0x1
    1aaa:	e8 61 1f 00 00       	call   3a10 <printf>
        exit();
    1aaf:	e8 fe 1d 00 00       	call   38b2 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1ab4:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1ab7:	56                   	push   %esi
    1ab8:	50                   	push   %eax
    1ab9:	68 00 44 00 00       	push   $0x4400
    1abe:	6a 01                	push   $0x1
    1ac0:	e8 4b 1f 00 00       	call   3a10 <printf>
        exit();
    1ac5:	e8 e8 1d 00 00       	call   38b2 <exit>
      close(fd);
    1aca:	83 ec 0c             	sub    $0xc,%esp
    1acd:	50                   	push   %eax
    1ace:	e8 07 1e 00 00       	call   38da <close>
    1ad3:	83 c4 10             	add    $0x10,%esp
    1ad6:	e9 f6 fd ff ff       	jmp    18d1 <concreate+0xf1>
    1adb:	90                   	nop
    1adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001ae0 <linkunlink>:
{
    1ae0:	55                   	push   %ebp
    1ae1:	89 e5                	mov    %esp,%ebp
    1ae3:	57                   	push   %edi
    1ae4:	56                   	push   %esi
    1ae5:	53                   	push   %ebx
    1ae6:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1ae9:	68 44 44 00 00       	push   $0x4444
    1aee:	6a 01                	push   $0x1
    1af0:	e8 1b 1f 00 00       	call   3a10 <printf>
  unlink("x");
    1af5:	c7 04 24 d1 46 00 00 	movl   $0x46d1,(%esp)
    1afc:	e8 01 1e 00 00       	call   3902 <unlink>
  pid = fork();
    1b01:	e8 a4 1d 00 00       	call   38aa <fork>
  if(pid < 0){
    1b06:	83 c4 10             	add    $0x10,%esp
    1b09:	85 c0                	test   %eax,%eax
  pid = fork();
    1b0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1b0e:	0f 88 b6 00 00 00    	js     1bca <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1b14:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1b18:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1b1d:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1b22:	19 ff                	sbb    %edi,%edi
    1b24:	83 e7 60             	and    $0x60,%edi
    1b27:	83 c7 01             	add    $0x1,%edi
    1b2a:	eb 1e                	jmp    1b4a <linkunlink+0x6a>
    1b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if((x % 3) == 1){
    1b30:	83 fa 01             	cmp    $0x1,%edx
    1b33:	74 7b                	je     1bb0 <linkunlink+0xd0>
      unlink("x");
    1b35:	83 ec 0c             	sub    $0xc,%esp
    1b38:	68 d1 46 00 00       	push   $0x46d1
    1b3d:	e8 c0 1d 00 00       	call   3902 <unlink>
    1b42:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b45:	83 eb 01             	sub    $0x1,%ebx
    1b48:	74 3d                	je     1b87 <linkunlink+0xa7>
    x = x * 1103515245 + 12345;
    1b4a:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1b50:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1b56:	89 f8                	mov    %edi,%eax
    1b58:	f7 e6                	mul    %esi
    1b5a:	d1 ea                	shr    %edx
    1b5c:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1b5f:	89 fa                	mov    %edi,%edx
    1b61:	29 c2                	sub    %eax,%edx
    1b63:	75 cb                	jne    1b30 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1b65:	83 ec 08             	sub    $0x8,%esp
    1b68:	68 02 02 00 00       	push   $0x202
    1b6d:	68 d1 46 00 00       	push   $0x46d1
    1b72:	e8 7b 1d 00 00       	call   38f2 <open>
    1b77:	89 04 24             	mov    %eax,(%esp)
    1b7a:	e8 5b 1d 00 00       	call   38da <close>
    1b7f:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1b82:	83 eb 01             	sub    $0x1,%ebx
    1b85:	75 c3                	jne    1b4a <linkunlink+0x6a>
  if(pid)
    1b87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1b8a:	85 c0                	test   %eax,%eax
    1b8c:	74 4f                	je     1bdd <linkunlink+0xfd>
    wait();
    1b8e:	e8 27 1d 00 00       	call   38ba <wait>
  printf(1, "linkunlink ok\n");
    1b93:	83 ec 08             	sub    $0x8,%esp
    1b96:	68 59 44 00 00       	push   $0x4459
    1b9b:	6a 01                	push   $0x1
    1b9d:	e8 6e 1e 00 00       	call   3a10 <printf>
}
    1ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1ba5:	5b                   	pop    %ebx
    1ba6:	5e                   	pop    %esi
    1ba7:	5f                   	pop    %edi
    1ba8:	5d                   	pop    %ebp
    1ba9:	c3                   	ret    
    1baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("cat", "x");
    1bb0:	83 ec 08             	sub    $0x8,%esp
    1bb3:	68 d1 46 00 00       	push   $0x46d1
    1bb8:	68 55 44 00 00       	push   $0x4455
    1bbd:	e8 50 1d 00 00       	call   3912 <link>
    1bc2:	83 c4 10             	add    $0x10,%esp
    1bc5:	e9 7b ff ff ff       	jmp    1b45 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1bca:	52                   	push   %edx
    1bcb:	52                   	push   %edx
    1bcc:	68 b9 4c 00 00       	push   $0x4cb9
    1bd1:	6a 01                	push   $0x1
    1bd3:	e8 38 1e 00 00       	call   3a10 <printf>
    exit();
    1bd8:	e8 d5 1c 00 00       	call   38b2 <exit>
    exit();
    1bdd:	e8 d0 1c 00 00       	call   38b2 <exit>
    1be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001bf0 <bigdir>:
{
    1bf0:	55                   	push   %ebp
    1bf1:	89 e5                	mov    %esp,%ebp
    1bf3:	57                   	push   %edi
    1bf4:	56                   	push   %esi
    1bf5:	53                   	push   %ebx
    1bf6:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1bf9:	68 68 44 00 00       	push   $0x4468
    1bfe:	6a 01                	push   $0x1
    1c00:	e8 0b 1e 00 00       	call   3a10 <printf>
  unlink("bd");
    1c05:	c7 04 24 75 44 00 00 	movl   $0x4475,(%esp)
    1c0c:	e8 f1 1c 00 00       	call   3902 <unlink>
  fd = open("bd", O_CREATE);
    1c11:	5a                   	pop    %edx
    1c12:	59                   	pop    %ecx
    1c13:	68 00 02 00 00       	push   $0x200
    1c18:	68 75 44 00 00       	push   $0x4475
    1c1d:	e8 d0 1c 00 00       	call   38f2 <open>
  if(fd < 0){
    1c22:	83 c4 10             	add    $0x10,%esp
    1c25:	85 c0                	test   %eax,%eax
    1c27:	0f 88 de 00 00 00    	js     1d0b <bigdir+0x11b>
  close(fd);
    1c2d:	83 ec 0c             	sub    $0xc,%esp
    1c30:	8d 7d de             	lea    -0x22(%ebp),%edi
  for(i = 0; i < 500; i++){
    1c33:	31 f6                	xor    %esi,%esi
  close(fd);
    1c35:	50                   	push   %eax
    1c36:	e8 9f 1c 00 00       	call   38da <close>
    1c3b:	83 c4 10             	add    $0x10,%esp
    1c3e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + (i / 64);
    1c40:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1c42:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1c45:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1c49:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1c4c:	57                   	push   %edi
    1c4d:	68 75 44 00 00       	push   $0x4475
    name[1] = '0' + (i / 64);
    1c52:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1c55:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1c59:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1c5c:	89 f0                	mov    %esi,%eax
    1c5e:	83 e0 3f             	and    $0x3f,%eax
    1c61:	83 c0 30             	add    $0x30,%eax
    1c64:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1c67:	e8 a6 1c 00 00       	call   3912 <link>
    1c6c:	83 c4 10             	add    $0x10,%esp
    1c6f:	85 c0                	test   %eax,%eax
    1c71:	89 c3                	mov    %eax,%ebx
    1c73:	75 6e                	jne    1ce3 <bigdir+0xf3>
  for(i = 0; i < 500; i++){
    1c75:	83 c6 01             	add    $0x1,%esi
    1c78:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1c7e:	75 c0                	jne    1c40 <bigdir+0x50>
  unlink("bd");
    1c80:	83 ec 0c             	sub    $0xc,%esp
    1c83:	68 75 44 00 00       	push   $0x4475
    1c88:	e8 75 1c 00 00       	call   3902 <unlink>
    1c8d:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + (i / 64);
    1c90:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1c92:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1c95:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1c99:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1c9c:	57                   	push   %edi
    name[3] = '\0';
    1c9d:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1ca1:	83 c0 30             	add    $0x30,%eax
    1ca4:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1ca7:	89 d8                	mov    %ebx,%eax
    1ca9:	83 e0 3f             	and    $0x3f,%eax
    1cac:	83 c0 30             	add    $0x30,%eax
    1caf:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1cb2:	e8 4b 1c 00 00       	call   3902 <unlink>
    1cb7:	83 c4 10             	add    $0x10,%esp
    1cba:	85 c0                	test   %eax,%eax
    1cbc:	75 39                	jne    1cf7 <bigdir+0x107>
  for(i = 0; i < 500; i++){
    1cbe:	83 c3 01             	add    $0x1,%ebx
    1cc1:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1cc7:	75 c7                	jne    1c90 <bigdir+0xa0>
  printf(1, "bigdir ok\n");
    1cc9:	83 ec 08             	sub    $0x8,%esp
    1ccc:	68 b7 44 00 00       	push   $0x44b7
    1cd1:	6a 01                	push   $0x1
    1cd3:	e8 38 1d 00 00       	call   3a10 <printf>
}
    1cd8:	83 c4 10             	add    $0x10,%esp
    1cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1cde:	5b                   	pop    %ebx
    1cdf:	5e                   	pop    %esi
    1ce0:	5f                   	pop    %edi
    1ce1:	5d                   	pop    %ebp
    1ce2:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1ce3:	83 ec 08             	sub    $0x8,%esp
    1ce6:	68 8e 44 00 00       	push   $0x448e
    1ceb:	6a 01                	push   $0x1
    1ced:	e8 1e 1d 00 00       	call   3a10 <printf>
      exit();
    1cf2:	e8 bb 1b 00 00       	call   38b2 <exit>
      printf(1, "bigdir unlink failed");
    1cf7:	83 ec 08             	sub    $0x8,%esp
    1cfa:	68 a2 44 00 00       	push   $0x44a2
    1cff:	6a 01                	push   $0x1
    1d01:	e8 0a 1d 00 00       	call   3a10 <printf>
      exit();
    1d06:	e8 a7 1b 00 00       	call   38b2 <exit>
    printf(1, "bigdir create failed\n");
    1d0b:	50                   	push   %eax
    1d0c:	50                   	push   %eax
    1d0d:	68 78 44 00 00       	push   $0x4478
    1d12:	6a 01                	push   $0x1
    1d14:	e8 f7 1c 00 00       	call   3a10 <printf>
    exit();
    1d19:	e8 94 1b 00 00       	call   38b2 <exit>
    1d1e:	66 90                	xchg   %ax,%ax

00001d20 <subdir>:
{
    1d20:	55                   	push   %ebp
    1d21:	89 e5                	mov    %esp,%ebp
    1d23:	53                   	push   %ebx
    1d24:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1d27:	68 c2 44 00 00       	push   $0x44c2
    1d2c:	6a 01                	push   $0x1
    1d2e:	e8 dd 1c 00 00       	call   3a10 <printf>
  unlink("ff");
    1d33:	c7 04 24 4b 45 00 00 	movl   $0x454b,(%esp)
    1d3a:	e8 c3 1b 00 00       	call   3902 <unlink>
  if(mkdir("dd") != 0){
    1d3f:	c7 04 24 e8 45 00 00 	movl   $0x45e8,(%esp)
    1d46:	e8 cf 1b 00 00       	call   391a <mkdir>
    1d4b:	83 c4 10             	add    $0x10,%esp
    1d4e:	85 c0                	test   %eax,%eax
    1d50:	0f 85 b3 05 00 00    	jne    2309 <subdir+0x5e9>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d56:	83 ec 08             	sub    $0x8,%esp
    1d59:	68 02 02 00 00       	push   $0x202
    1d5e:	68 21 45 00 00       	push   $0x4521
    1d63:	e8 8a 1b 00 00       	call   38f2 <open>
  if(fd < 0){
    1d68:	83 c4 10             	add    $0x10,%esp
    1d6b:	85 c0                	test   %eax,%eax
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1d6d:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d6f:	0f 88 81 05 00 00    	js     22f6 <subdir+0x5d6>
  write(fd, "ff", 2);
    1d75:	83 ec 04             	sub    $0x4,%esp
    1d78:	6a 02                	push   $0x2
    1d7a:	68 4b 45 00 00       	push   $0x454b
    1d7f:	50                   	push   %eax
    1d80:	e8 4d 1b 00 00       	call   38d2 <write>
  close(fd);
    1d85:	89 1c 24             	mov    %ebx,(%esp)
    1d88:	e8 4d 1b 00 00       	call   38da <close>
  if(unlink("dd") >= 0){
    1d8d:	c7 04 24 e8 45 00 00 	movl   $0x45e8,(%esp)
    1d94:	e8 69 1b 00 00       	call   3902 <unlink>
    1d99:	83 c4 10             	add    $0x10,%esp
    1d9c:	85 c0                	test   %eax,%eax
    1d9e:	0f 89 3f 05 00 00    	jns    22e3 <subdir+0x5c3>
  if(mkdir("/dd/dd") != 0){
    1da4:	83 ec 0c             	sub    $0xc,%esp
    1da7:	68 fc 44 00 00       	push   $0x44fc
    1dac:	e8 69 1b 00 00       	call   391a <mkdir>
    1db1:	83 c4 10             	add    $0x10,%esp
    1db4:	85 c0                	test   %eax,%eax
    1db6:	0f 85 14 05 00 00    	jne    22d0 <subdir+0x5b0>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1dbc:	83 ec 08             	sub    $0x8,%esp
    1dbf:	68 02 02 00 00       	push   $0x202
    1dc4:	68 1e 45 00 00       	push   $0x451e
    1dc9:	e8 24 1b 00 00       	call   38f2 <open>
  if(fd < 0){
    1dce:	83 c4 10             	add    $0x10,%esp
    1dd1:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1dd3:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1dd5:	0f 88 24 04 00 00    	js     21ff <subdir+0x4df>
  write(fd, "FF", 2);
    1ddb:	83 ec 04             	sub    $0x4,%esp
    1dde:	6a 02                	push   $0x2
    1de0:	68 3f 45 00 00       	push   $0x453f
    1de5:	50                   	push   %eax
    1de6:	e8 e7 1a 00 00       	call   38d2 <write>
  close(fd);
    1deb:	89 1c 24             	mov    %ebx,(%esp)
    1dee:	e8 e7 1a 00 00       	call   38da <close>
  fd = open("dd/dd/../ff", 0);
    1df3:	58                   	pop    %eax
    1df4:	5a                   	pop    %edx
    1df5:	6a 00                	push   $0x0
    1df7:	68 42 45 00 00       	push   $0x4542
    1dfc:	e8 f1 1a 00 00       	call   38f2 <open>
  if(fd < 0){
    1e01:	83 c4 10             	add    $0x10,%esp
    1e04:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/../ff", 0);
    1e06:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e08:	0f 88 de 03 00 00    	js     21ec <subdir+0x4cc>
  cc = read(fd, buf, sizeof(buf));
    1e0e:	83 ec 04             	sub    $0x4,%esp
    1e11:	68 00 20 00 00       	push   $0x2000
    1e16:	68 00 86 00 00       	push   $0x8600
    1e1b:	50                   	push   %eax
    1e1c:	e8 a9 1a 00 00       	call   38ca <read>
  if(cc != 2 || buf[0] != 'f'){
    1e21:	83 c4 10             	add    $0x10,%esp
    1e24:	83 f8 02             	cmp    $0x2,%eax
    1e27:	0f 85 3a 03 00 00    	jne    2167 <subdir+0x447>
    1e2d:	80 3d 00 86 00 00 66 	cmpb   $0x66,0x8600
    1e34:	0f 85 2d 03 00 00    	jne    2167 <subdir+0x447>
  close(fd);
    1e3a:	83 ec 0c             	sub    $0xc,%esp
    1e3d:	53                   	push   %ebx
    1e3e:	e8 97 1a 00 00       	call   38da <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1e43:	5b                   	pop    %ebx
    1e44:	58                   	pop    %eax
    1e45:	68 82 45 00 00       	push   $0x4582
    1e4a:	68 1e 45 00 00       	push   $0x451e
    1e4f:	e8 be 1a 00 00       	call   3912 <link>
    1e54:	83 c4 10             	add    $0x10,%esp
    1e57:	85 c0                	test   %eax,%eax
    1e59:	0f 85 c6 03 00 00    	jne    2225 <subdir+0x505>
  if(unlink("dd/dd/ff") != 0){
    1e5f:	83 ec 0c             	sub    $0xc,%esp
    1e62:	68 1e 45 00 00       	push   $0x451e
    1e67:	e8 96 1a 00 00       	call   3902 <unlink>
    1e6c:	83 c4 10             	add    $0x10,%esp
    1e6f:	85 c0                	test   %eax,%eax
    1e71:	0f 85 16 03 00 00    	jne    218d <subdir+0x46d>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1e77:	83 ec 08             	sub    $0x8,%esp
    1e7a:	6a 00                	push   $0x0
    1e7c:	68 1e 45 00 00       	push   $0x451e
    1e81:	e8 6c 1a 00 00       	call   38f2 <open>
    1e86:	83 c4 10             	add    $0x10,%esp
    1e89:	85 c0                	test   %eax,%eax
    1e8b:	0f 89 2c 04 00 00    	jns    22bd <subdir+0x59d>
  if(chdir("dd") != 0){
    1e91:	83 ec 0c             	sub    $0xc,%esp
    1e94:	68 e8 45 00 00       	push   $0x45e8
    1e99:	e8 84 1a 00 00       	call   3922 <chdir>
    1e9e:	83 c4 10             	add    $0x10,%esp
    1ea1:	85 c0                	test   %eax,%eax
    1ea3:	0f 85 01 04 00 00    	jne    22aa <subdir+0x58a>
  if(chdir("dd/../../dd") != 0){
    1ea9:	83 ec 0c             	sub    $0xc,%esp
    1eac:	68 b6 45 00 00       	push   $0x45b6
    1eb1:	e8 6c 1a 00 00       	call   3922 <chdir>
    1eb6:	83 c4 10             	add    $0x10,%esp
    1eb9:	85 c0                	test   %eax,%eax
    1ebb:	0f 85 b9 02 00 00    	jne    217a <subdir+0x45a>
  if(chdir("dd/../../../dd") != 0){
    1ec1:	83 ec 0c             	sub    $0xc,%esp
    1ec4:	68 dc 45 00 00       	push   $0x45dc
    1ec9:	e8 54 1a 00 00       	call   3922 <chdir>
    1ece:	83 c4 10             	add    $0x10,%esp
    1ed1:	85 c0                	test   %eax,%eax
    1ed3:	0f 85 a1 02 00 00    	jne    217a <subdir+0x45a>
  if(chdir("./..") != 0){
    1ed9:	83 ec 0c             	sub    $0xc,%esp
    1edc:	68 eb 45 00 00       	push   $0x45eb
    1ee1:	e8 3c 1a 00 00       	call   3922 <chdir>
    1ee6:	83 c4 10             	add    $0x10,%esp
    1ee9:	85 c0                	test   %eax,%eax
    1eeb:	0f 85 21 03 00 00    	jne    2212 <subdir+0x4f2>
  fd = open("dd/dd/ffff", 0);
    1ef1:	83 ec 08             	sub    $0x8,%esp
    1ef4:	6a 00                	push   $0x0
    1ef6:	68 82 45 00 00       	push   $0x4582
    1efb:	e8 f2 19 00 00       	call   38f2 <open>
  if(fd < 0){
    1f00:	83 c4 10             	add    $0x10,%esp
    1f03:	85 c0                	test   %eax,%eax
  fd = open("dd/dd/ffff", 0);
    1f05:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1f07:	0f 88 e0 04 00 00    	js     23ed <subdir+0x6cd>
  if(read(fd, buf, sizeof(buf)) != 2){
    1f0d:	83 ec 04             	sub    $0x4,%esp
    1f10:	68 00 20 00 00       	push   $0x2000
    1f15:	68 00 86 00 00       	push   $0x8600
    1f1a:	50                   	push   %eax
    1f1b:	e8 aa 19 00 00       	call   38ca <read>
    1f20:	83 c4 10             	add    $0x10,%esp
    1f23:	83 f8 02             	cmp    $0x2,%eax
    1f26:	0f 85 ae 04 00 00    	jne    23da <subdir+0x6ba>
  close(fd);
    1f2c:	83 ec 0c             	sub    $0xc,%esp
    1f2f:	53                   	push   %ebx
    1f30:	e8 a5 19 00 00       	call   38da <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f35:	59                   	pop    %ecx
    1f36:	5b                   	pop    %ebx
    1f37:	6a 00                	push   $0x0
    1f39:	68 1e 45 00 00       	push   $0x451e
    1f3e:	e8 af 19 00 00       	call   38f2 <open>
    1f43:	83 c4 10             	add    $0x10,%esp
    1f46:	85 c0                	test   %eax,%eax
    1f48:	0f 89 65 02 00 00    	jns    21b3 <subdir+0x493>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1f4e:	83 ec 08             	sub    $0x8,%esp
    1f51:	68 02 02 00 00       	push   $0x202
    1f56:	68 36 46 00 00       	push   $0x4636
    1f5b:	e8 92 19 00 00       	call   38f2 <open>
    1f60:	83 c4 10             	add    $0x10,%esp
    1f63:	85 c0                	test   %eax,%eax
    1f65:	0f 89 35 02 00 00    	jns    21a0 <subdir+0x480>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1f6b:	83 ec 08             	sub    $0x8,%esp
    1f6e:	68 02 02 00 00       	push   $0x202
    1f73:	68 5b 46 00 00       	push   $0x465b
    1f78:	e8 75 19 00 00       	call   38f2 <open>
    1f7d:	83 c4 10             	add    $0x10,%esp
    1f80:	85 c0                	test   %eax,%eax
    1f82:	0f 89 0f 03 00 00    	jns    2297 <subdir+0x577>
  if(open("dd", O_CREATE) >= 0){
    1f88:	83 ec 08             	sub    $0x8,%esp
    1f8b:	68 00 02 00 00       	push   $0x200
    1f90:	68 e8 45 00 00       	push   $0x45e8
    1f95:	e8 58 19 00 00       	call   38f2 <open>
    1f9a:	83 c4 10             	add    $0x10,%esp
    1f9d:	85 c0                	test   %eax,%eax
    1f9f:	0f 89 df 02 00 00    	jns    2284 <subdir+0x564>
  if(open("dd", O_RDWR) >= 0){
    1fa5:	83 ec 08             	sub    $0x8,%esp
    1fa8:	6a 02                	push   $0x2
    1faa:	68 e8 45 00 00       	push   $0x45e8
    1faf:	e8 3e 19 00 00       	call   38f2 <open>
    1fb4:	83 c4 10             	add    $0x10,%esp
    1fb7:	85 c0                	test   %eax,%eax
    1fb9:	0f 89 b2 02 00 00    	jns    2271 <subdir+0x551>
  if(open("dd", O_WRONLY) >= 0){
    1fbf:	83 ec 08             	sub    $0x8,%esp
    1fc2:	6a 01                	push   $0x1
    1fc4:	68 e8 45 00 00       	push   $0x45e8
    1fc9:	e8 24 19 00 00       	call   38f2 <open>
    1fce:	83 c4 10             	add    $0x10,%esp
    1fd1:	85 c0                	test   %eax,%eax
    1fd3:	0f 89 85 02 00 00    	jns    225e <subdir+0x53e>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1fd9:	83 ec 08             	sub    $0x8,%esp
    1fdc:	68 ca 46 00 00       	push   $0x46ca
    1fe1:	68 36 46 00 00       	push   $0x4636
    1fe6:	e8 27 19 00 00       	call   3912 <link>
    1feb:	83 c4 10             	add    $0x10,%esp
    1fee:	85 c0                	test   %eax,%eax
    1ff0:	0f 84 55 02 00 00    	je     224b <subdir+0x52b>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1ff6:	83 ec 08             	sub    $0x8,%esp
    1ff9:	68 ca 46 00 00       	push   $0x46ca
    1ffe:	68 5b 46 00 00       	push   $0x465b
    2003:	e8 0a 19 00 00       	call   3912 <link>
    2008:	83 c4 10             	add    $0x10,%esp
    200b:	85 c0                	test   %eax,%eax
    200d:	0f 84 25 02 00 00    	je     2238 <subdir+0x518>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2013:	83 ec 08             	sub    $0x8,%esp
    2016:	68 82 45 00 00       	push   $0x4582
    201b:	68 21 45 00 00       	push   $0x4521
    2020:	e8 ed 18 00 00       	call   3912 <link>
    2025:	83 c4 10             	add    $0x10,%esp
    2028:	85 c0                	test   %eax,%eax
    202a:	0f 84 a9 01 00 00    	je     21d9 <subdir+0x4b9>
  if(mkdir("dd/ff/ff") == 0){
    2030:	83 ec 0c             	sub    $0xc,%esp
    2033:	68 36 46 00 00       	push   $0x4636
    2038:	e8 dd 18 00 00       	call   391a <mkdir>
    203d:	83 c4 10             	add    $0x10,%esp
    2040:	85 c0                	test   %eax,%eax
    2042:	0f 84 7e 01 00 00    	je     21c6 <subdir+0x4a6>
  if(mkdir("dd/xx/ff") == 0){
    2048:	83 ec 0c             	sub    $0xc,%esp
    204b:	68 5b 46 00 00       	push   $0x465b
    2050:	e8 c5 18 00 00       	call   391a <mkdir>
    2055:	83 c4 10             	add    $0x10,%esp
    2058:	85 c0                	test   %eax,%eax
    205a:	0f 84 67 03 00 00    	je     23c7 <subdir+0x6a7>
  if(mkdir("dd/dd/ffff") == 0){
    2060:	83 ec 0c             	sub    $0xc,%esp
    2063:	68 82 45 00 00       	push   $0x4582
    2068:	e8 ad 18 00 00       	call   391a <mkdir>
    206d:	83 c4 10             	add    $0x10,%esp
    2070:	85 c0                	test   %eax,%eax
    2072:	0f 84 3c 03 00 00    	je     23b4 <subdir+0x694>
  if(unlink("dd/xx/ff") == 0){
    2078:	83 ec 0c             	sub    $0xc,%esp
    207b:	68 5b 46 00 00       	push   $0x465b
    2080:	e8 7d 18 00 00       	call   3902 <unlink>
    2085:	83 c4 10             	add    $0x10,%esp
    2088:	85 c0                	test   %eax,%eax
    208a:	0f 84 11 03 00 00    	je     23a1 <subdir+0x681>
  if(unlink("dd/ff/ff") == 0){
    2090:	83 ec 0c             	sub    $0xc,%esp
    2093:	68 36 46 00 00       	push   $0x4636
    2098:	e8 65 18 00 00       	call   3902 <unlink>
    209d:	83 c4 10             	add    $0x10,%esp
    20a0:	85 c0                	test   %eax,%eax
    20a2:	0f 84 e6 02 00 00    	je     238e <subdir+0x66e>
  if(chdir("dd/ff") == 0){
    20a8:	83 ec 0c             	sub    $0xc,%esp
    20ab:	68 21 45 00 00       	push   $0x4521
    20b0:	e8 6d 18 00 00       	call   3922 <chdir>
    20b5:	83 c4 10             	add    $0x10,%esp
    20b8:	85 c0                	test   %eax,%eax
    20ba:	0f 84 bb 02 00 00    	je     237b <subdir+0x65b>
  if(chdir("dd/xx") == 0){
    20c0:	83 ec 0c             	sub    $0xc,%esp
    20c3:	68 cd 46 00 00       	push   $0x46cd
    20c8:	e8 55 18 00 00       	call   3922 <chdir>
    20cd:	83 c4 10             	add    $0x10,%esp
    20d0:	85 c0                	test   %eax,%eax
    20d2:	0f 84 90 02 00 00    	je     2368 <subdir+0x648>
  if(unlink("dd/dd/ffff") != 0){
    20d8:	83 ec 0c             	sub    $0xc,%esp
    20db:	68 82 45 00 00       	push   $0x4582
    20e0:	e8 1d 18 00 00       	call   3902 <unlink>
    20e5:	83 c4 10             	add    $0x10,%esp
    20e8:	85 c0                	test   %eax,%eax
    20ea:	0f 85 9d 00 00 00    	jne    218d <subdir+0x46d>
  if(unlink("dd/ff") != 0){
    20f0:	83 ec 0c             	sub    $0xc,%esp
    20f3:	68 21 45 00 00       	push   $0x4521
    20f8:	e8 05 18 00 00       	call   3902 <unlink>
    20fd:	83 c4 10             	add    $0x10,%esp
    2100:	85 c0                	test   %eax,%eax
    2102:	0f 85 4d 02 00 00    	jne    2355 <subdir+0x635>
  if(unlink("dd") == 0){
    2108:	83 ec 0c             	sub    $0xc,%esp
    210b:	68 e8 45 00 00       	push   $0x45e8
    2110:	e8 ed 17 00 00       	call   3902 <unlink>
    2115:	83 c4 10             	add    $0x10,%esp
    2118:	85 c0                	test   %eax,%eax
    211a:	0f 84 22 02 00 00    	je     2342 <subdir+0x622>
  if(unlink("dd/dd") < 0){
    2120:	83 ec 0c             	sub    $0xc,%esp
    2123:	68 fd 44 00 00       	push   $0x44fd
    2128:	e8 d5 17 00 00       	call   3902 <unlink>
    212d:	83 c4 10             	add    $0x10,%esp
    2130:	85 c0                	test   %eax,%eax
    2132:	0f 88 f7 01 00 00    	js     232f <subdir+0x60f>
  if(unlink("dd") < 0){
    2138:	83 ec 0c             	sub    $0xc,%esp
    213b:	68 e8 45 00 00       	push   $0x45e8
    2140:	e8 bd 17 00 00       	call   3902 <unlink>
    2145:	83 c4 10             	add    $0x10,%esp
    2148:	85 c0                	test   %eax,%eax
    214a:	0f 88 cc 01 00 00    	js     231c <subdir+0x5fc>
  printf(1, "subdir ok\n");
    2150:	83 ec 08             	sub    $0x8,%esp
    2153:	68 ca 47 00 00       	push   $0x47ca
    2158:	6a 01                	push   $0x1
    215a:	e8 b1 18 00 00       	call   3a10 <printf>
}
    215f:	83 c4 10             	add    $0x10,%esp
    2162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2165:	c9                   	leave  
    2166:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    2167:	50                   	push   %eax
    2168:	50                   	push   %eax
    2169:	68 67 45 00 00       	push   $0x4567
    216e:	6a 01                	push   $0x1
    2170:	e8 9b 18 00 00       	call   3a10 <printf>
    exit();
    2175:	e8 38 17 00 00       	call   38b2 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    217a:	50                   	push   %eax
    217b:	50                   	push   %eax
    217c:	68 c2 45 00 00       	push   $0x45c2
    2181:	6a 01                	push   $0x1
    2183:	e8 88 18 00 00       	call   3a10 <printf>
    exit();
    2188:	e8 25 17 00 00       	call   38b2 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    218d:	52                   	push   %edx
    218e:	52                   	push   %edx
    218f:	68 8d 45 00 00       	push   $0x458d
    2194:	6a 01                	push   $0x1
    2196:	e8 75 18 00 00       	call   3a10 <printf>
    exit();
    219b:	e8 12 17 00 00       	call   38b2 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    21a0:	50                   	push   %eax
    21a1:	50                   	push   %eax
    21a2:	68 3f 46 00 00       	push   $0x463f
    21a7:	6a 01                	push   $0x1
    21a9:	e8 62 18 00 00       	call   3a10 <printf>
    exit();
    21ae:	e8 ff 16 00 00       	call   38b2 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    21b3:	52                   	push   %edx
    21b4:	52                   	push   %edx
    21b5:	68 24 50 00 00       	push   $0x5024
    21ba:	6a 01                	push   $0x1
    21bc:	e8 4f 18 00 00       	call   3a10 <printf>
    exit();
    21c1:	e8 ec 16 00 00       	call   38b2 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    21c6:	52                   	push   %edx
    21c7:	52                   	push   %edx
    21c8:	68 d3 46 00 00       	push   $0x46d3
    21cd:	6a 01                	push   $0x1
    21cf:	e8 3c 18 00 00       	call   3a10 <printf>
    exit();
    21d4:	e8 d9 16 00 00       	call   38b2 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    21d9:	51                   	push   %ecx
    21da:	51                   	push   %ecx
    21db:	68 94 50 00 00       	push   $0x5094
    21e0:	6a 01                	push   $0x1
    21e2:	e8 29 18 00 00       	call   3a10 <printf>
    exit();
    21e7:	e8 c6 16 00 00       	call   38b2 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    21ec:	50                   	push   %eax
    21ed:	50                   	push   %eax
    21ee:	68 4e 45 00 00       	push   $0x454e
    21f3:	6a 01                	push   $0x1
    21f5:	e8 16 18 00 00       	call   3a10 <printf>
    exit();
    21fa:	e8 b3 16 00 00       	call   38b2 <exit>
    printf(1, "create dd/dd/ff failed\n");
    21ff:	51                   	push   %ecx
    2200:	51                   	push   %ecx
    2201:	68 27 45 00 00       	push   $0x4527
    2206:	6a 01                	push   $0x1
    2208:	e8 03 18 00 00       	call   3a10 <printf>
    exit();
    220d:	e8 a0 16 00 00       	call   38b2 <exit>
    printf(1, "chdir ./.. failed\n");
    2212:	50                   	push   %eax
    2213:	50                   	push   %eax
    2214:	68 f0 45 00 00       	push   $0x45f0
    2219:	6a 01                	push   $0x1
    221b:	e8 f0 17 00 00       	call   3a10 <printf>
    exit();
    2220:	e8 8d 16 00 00       	call   38b2 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2225:	51                   	push   %ecx
    2226:	51                   	push   %ecx
    2227:	68 dc 4f 00 00       	push   $0x4fdc
    222c:	6a 01                	push   $0x1
    222e:	e8 dd 17 00 00       	call   3a10 <printf>
    exit();
    2233:	e8 7a 16 00 00       	call   38b2 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2238:	53                   	push   %ebx
    2239:	53                   	push   %ebx
    223a:	68 70 50 00 00       	push   $0x5070
    223f:	6a 01                	push   $0x1
    2241:	e8 ca 17 00 00       	call   3a10 <printf>
    exit();
    2246:	e8 67 16 00 00       	call   38b2 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    224b:	50                   	push   %eax
    224c:	50                   	push   %eax
    224d:	68 4c 50 00 00       	push   $0x504c
    2252:	6a 01                	push   $0x1
    2254:	e8 b7 17 00 00       	call   3a10 <printf>
    exit();
    2259:	e8 54 16 00 00       	call   38b2 <exit>
    printf(1, "open dd wronly succeeded!\n");
    225e:	50                   	push   %eax
    225f:	50                   	push   %eax
    2260:	68 af 46 00 00       	push   $0x46af
    2265:	6a 01                	push   $0x1
    2267:	e8 a4 17 00 00       	call   3a10 <printf>
    exit();
    226c:	e8 41 16 00 00       	call   38b2 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2271:	50                   	push   %eax
    2272:	50                   	push   %eax
    2273:	68 96 46 00 00       	push   $0x4696
    2278:	6a 01                	push   $0x1
    227a:	e8 91 17 00 00       	call   3a10 <printf>
    exit();
    227f:	e8 2e 16 00 00       	call   38b2 <exit>
    printf(1, "create dd succeeded!\n");
    2284:	50                   	push   %eax
    2285:	50                   	push   %eax
    2286:	68 80 46 00 00       	push   $0x4680
    228b:	6a 01                	push   $0x1
    228d:	e8 7e 17 00 00       	call   3a10 <printf>
    exit();
    2292:	e8 1b 16 00 00       	call   38b2 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2297:	50                   	push   %eax
    2298:	50                   	push   %eax
    2299:	68 64 46 00 00       	push   $0x4664
    229e:	6a 01                	push   $0x1
    22a0:	e8 6b 17 00 00       	call   3a10 <printf>
    exit();
    22a5:	e8 08 16 00 00       	call   38b2 <exit>
    printf(1, "chdir dd failed\n");
    22aa:	50                   	push   %eax
    22ab:	50                   	push   %eax
    22ac:	68 a5 45 00 00       	push   $0x45a5
    22b1:	6a 01                	push   $0x1
    22b3:	e8 58 17 00 00       	call   3a10 <printf>
    exit();
    22b8:	e8 f5 15 00 00       	call   38b2 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    22bd:	50                   	push   %eax
    22be:	50                   	push   %eax
    22bf:	68 00 50 00 00       	push   $0x5000
    22c4:	6a 01                	push   $0x1
    22c6:	e8 45 17 00 00       	call   3a10 <printf>
    exit();
    22cb:	e8 e2 15 00 00       	call   38b2 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    22d0:	53                   	push   %ebx
    22d1:	53                   	push   %ebx
    22d2:	68 03 45 00 00       	push   $0x4503
    22d7:	6a 01                	push   $0x1
    22d9:	e8 32 17 00 00       	call   3a10 <printf>
    exit();
    22de:	e8 cf 15 00 00       	call   38b2 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    22e3:	50                   	push   %eax
    22e4:	50                   	push   %eax
    22e5:	68 b4 4f 00 00       	push   $0x4fb4
    22ea:	6a 01                	push   $0x1
    22ec:	e8 1f 17 00 00       	call   3a10 <printf>
    exit();
    22f1:	e8 bc 15 00 00       	call   38b2 <exit>
    printf(1, "create dd/ff failed\n");
    22f6:	50                   	push   %eax
    22f7:	50                   	push   %eax
    22f8:	68 e7 44 00 00       	push   $0x44e7
    22fd:	6a 01                	push   $0x1
    22ff:	e8 0c 17 00 00       	call   3a10 <printf>
    exit();
    2304:	e8 a9 15 00 00       	call   38b2 <exit>
    printf(1, "subdir mkdir dd failed\n");
    2309:	50                   	push   %eax
    230a:	50                   	push   %eax
    230b:	68 cf 44 00 00       	push   $0x44cf
    2310:	6a 01                	push   $0x1
    2312:	e8 f9 16 00 00       	call   3a10 <printf>
    exit();
    2317:	e8 96 15 00 00       	call   38b2 <exit>
    printf(1, "unlink dd failed\n");
    231c:	50                   	push   %eax
    231d:	50                   	push   %eax
    231e:	68 b8 47 00 00       	push   $0x47b8
    2323:	6a 01                	push   $0x1
    2325:	e8 e6 16 00 00       	call   3a10 <printf>
    exit();
    232a:	e8 83 15 00 00       	call   38b2 <exit>
    printf(1, "unlink dd/dd failed\n");
    232f:	52                   	push   %edx
    2330:	52                   	push   %edx
    2331:	68 a3 47 00 00       	push   $0x47a3
    2336:	6a 01                	push   $0x1
    2338:	e8 d3 16 00 00       	call   3a10 <printf>
    exit();
    233d:	e8 70 15 00 00       	call   38b2 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2342:	51                   	push   %ecx
    2343:	51                   	push   %ecx
    2344:	68 b8 50 00 00       	push   $0x50b8
    2349:	6a 01                	push   $0x1
    234b:	e8 c0 16 00 00       	call   3a10 <printf>
    exit();
    2350:	e8 5d 15 00 00       	call   38b2 <exit>
    printf(1, "unlink dd/ff failed\n");
    2355:	53                   	push   %ebx
    2356:	53                   	push   %ebx
    2357:	68 8e 47 00 00       	push   $0x478e
    235c:	6a 01                	push   $0x1
    235e:	e8 ad 16 00 00       	call   3a10 <printf>
    exit();
    2363:	e8 4a 15 00 00       	call   38b2 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    2368:	50                   	push   %eax
    2369:	50                   	push   %eax
    236a:	68 76 47 00 00       	push   $0x4776
    236f:	6a 01                	push   $0x1
    2371:	e8 9a 16 00 00       	call   3a10 <printf>
    exit();
    2376:	e8 37 15 00 00       	call   38b2 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    237b:	50                   	push   %eax
    237c:	50                   	push   %eax
    237d:	68 5e 47 00 00       	push   $0x475e
    2382:	6a 01                	push   $0x1
    2384:	e8 87 16 00 00       	call   3a10 <printf>
    exit();
    2389:	e8 24 15 00 00       	call   38b2 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    238e:	50                   	push   %eax
    238f:	50                   	push   %eax
    2390:	68 42 47 00 00       	push   $0x4742
    2395:	6a 01                	push   $0x1
    2397:	e8 74 16 00 00       	call   3a10 <printf>
    exit();
    239c:	e8 11 15 00 00       	call   38b2 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    23a1:	50                   	push   %eax
    23a2:	50                   	push   %eax
    23a3:	68 26 47 00 00       	push   $0x4726
    23a8:	6a 01                	push   $0x1
    23aa:	e8 61 16 00 00       	call   3a10 <printf>
    exit();
    23af:	e8 fe 14 00 00       	call   38b2 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    23b4:	50                   	push   %eax
    23b5:	50                   	push   %eax
    23b6:	68 09 47 00 00       	push   $0x4709
    23bb:	6a 01                	push   $0x1
    23bd:	e8 4e 16 00 00       	call   3a10 <printf>
    exit();
    23c2:	e8 eb 14 00 00       	call   38b2 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    23c7:	50                   	push   %eax
    23c8:	50                   	push   %eax
    23c9:	68 ee 46 00 00       	push   $0x46ee
    23ce:	6a 01                	push   $0x1
    23d0:	e8 3b 16 00 00       	call   3a10 <printf>
    exit();
    23d5:	e8 d8 14 00 00       	call   38b2 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    23da:	50                   	push   %eax
    23db:	50                   	push   %eax
    23dc:	68 1b 46 00 00       	push   $0x461b
    23e1:	6a 01                	push   $0x1
    23e3:	e8 28 16 00 00       	call   3a10 <printf>
    exit();
    23e8:	e8 c5 14 00 00       	call   38b2 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    23ed:	50                   	push   %eax
    23ee:	50                   	push   %eax
    23ef:	68 03 46 00 00       	push   $0x4603
    23f4:	6a 01                	push   $0x1
    23f6:	e8 15 16 00 00       	call   3a10 <printf>
    exit();
    23fb:	e8 b2 14 00 00       	call   38b2 <exit>

00002400 <bigwrite>:
{
    2400:	55                   	push   %ebp
    2401:	89 e5                	mov    %esp,%ebp
    2403:	56                   	push   %esi
    2404:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    2405:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    240a:	83 ec 08             	sub    $0x8,%esp
    240d:	68 d5 47 00 00       	push   $0x47d5
    2412:	6a 01                	push   $0x1
    2414:	e8 f7 15 00 00       	call   3a10 <printf>
  unlink("bigwrite");
    2419:	c7 04 24 e4 47 00 00 	movl   $0x47e4,(%esp)
    2420:	e8 dd 14 00 00       	call   3902 <unlink>
    2425:	83 c4 10             	add    $0x10,%esp
    2428:	90                   	nop
    2429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2430:	83 ec 08             	sub    $0x8,%esp
    2433:	68 02 02 00 00       	push   $0x202
    2438:	68 e4 47 00 00       	push   $0x47e4
    243d:	e8 b0 14 00 00       	call   38f2 <open>
    if(fd < 0){
    2442:	83 c4 10             	add    $0x10,%esp
    2445:	85 c0                	test   %eax,%eax
    fd = open("bigwrite", O_CREATE | O_RDWR);
    2447:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    2449:	78 7e                	js     24c9 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    244b:	83 ec 04             	sub    $0x4,%esp
    244e:	53                   	push   %ebx
    244f:	68 00 86 00 00       	push   $0x8600
    2454:	50                   	push   %eax
    2455:	e8 78 14 00 00       	call   38d2 <write>
      if(cc != sz){
    245a:	83 c4 10             	add    $0x10,%esp
    245d:	39 d8                	cmp    %ebx,%eax
    245f:	75 55                	jne    24b6 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    2461:	83 ec 04             	sub    $0x4,%esp
    2464:	53                   	push   %ebx
    2465:	68 00 86 00 00       	push   $0x8600
    246a:	56                   	push   %esi
    246b:	e8 62 14 00 00       	call   38d2 <write>
      if(cc != sz){
    2470:	83 c4 10             	add    $0x10,%esp
    2473:	39 d8                	cmp    %ebx,%eax
    2475:	75 3f                	jne    24b6 <bigwrite+0xb6>
    close(fd);
    2477:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    247a:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    2480:	56                   	push   %esi
    2481:	e8 54 14 00 00       	call   38da <close>
    unlink("bigwrite");
    2486:	c7 04 24 e4 47 00 00 	movl   $0x47e4,(%esp)
    248d:	e8 70 14 00 00       	call   3902 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2492:	83 c4 10             	add    $0x10,%esp
    2495:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    249b:	75 93                	jne    2430 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    249d:	83 ec 08             	sub    $0x8,%esp
    24a0:	68 17 48 00 00       	push   $0x4817
    24a5:	6a 01                	push   $0x1
    24a7:	e8 64 15 00 00       	call   3a10 <printf>
}
    24ac:	83 c4 10             	add    $0x10,%esp
    24af:	8d 65 f8             	lea    -0x8(%ebp),%esp
    24b2:	5b                   	pop    %ebx
    24b3:	5e                   	pop    %esi
    24b4:	5d                   	pop    %ebp
    24b5:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    24b6:	50                   	push   %eax
    24b7:	53                   	push   %ebx
    24b8:	68 05 48 00 00       	push   $0x4805
    24bd:	6a 01                	push   $0x1
    24bf:	e8 4c 15 00 00       	call   3a10 <printf>
        exit();
    24c4:	e8 e9 13 00 00       	call   38b2 <exit>
      printf(1, "cannot create bigwrite\n");
    24c9:	83 ec 08             	sub    $0x8,%esp
    24cc:	68 ed 47 00 00       	push   $0x47ed
    24d1:	6a 01                	push   $0x1
    24d3:	e8 38 15 00 00       	call   3a10 <printf>
      exit();
    24d8:	e8 d5 13 00 00       	call   38b2 <exit>
    24dd:	8d 76 00             	lea    0x0(%esi),%esi

000024e0 <bigfile>:
{
    24e0:	55                   	push   %ebp
    24e1:	89 e5                	mov    %esp,%ebp
    24e3:	57                   	push   %edi
    24e4:	56                   	push   %esi
    24e5:	53                   	push   %ebx
    24e6:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    24e9:	68 24 48 00 00       	push   $0x4824
    24ee:	6a 01                	push   $0x1
    24f0:	e8 1b 15 00 00       	call   3a10 <printf>
  unlink("bigfile");
    24f5:	c7 04 24 40 48 00 00 	movl   $0x4840,(%esp)
    24fc:	e8 01 14 00 00       	call   3902 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2501:	58                   	pop    %eax
    2502:	5a                   	pop    %edx
    2503:	68 02 02 00 00       	push   $0x202
    2508:	68 40 48 00 00       	push   $0x4840
    250d:	e8 e0 13 00 00       	call   38f2 <open>
  if(fd < 0){
    2512:	83 c4 10             	add    $0x10,%esp
    2515:	85 c0                	test   %eax,%eax
    2517:	0f 88 5e 01 00 00    	js     267b <bigfile+0x19b>
    251d:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    251f:	31 db                	xor    %ebx,%ebx
    2521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memset(buf, i, 600);
    2528:	83 ec 04             	sub    $0x4,%esp
    252b:	68 58 02 00 00       	push   $0x258
    2530:	53                   	push   %ebx
    2531:	68 00 86 00 00       	push   $0x8600
    2536:	e8 d5 11 00 00       	call   3710 <memset>
    if(write(fd, buf, 600) != 600){
    253b:	83 c4 0c             	add    $0xc,%esp
    253e:	68 58 02 00 00       	push   $0x258
    2543:	68 00 86 00 00       	push   $0x8600
    2548:	56                   	push   %esi
    2549:	e8 84 13 00 00       	call   38d2 <write>
    254e:	83 c4 10             	add    $0x10,%esp
    2551:	3d 58 02 00 00       	cmp    $0x258,%eax
    2556:	0f 85 f8 00 00 00    	jne    2654 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    255c:	83 c3 01             	add    $0x1,%ebx
    255f:	83 fb 14             	cmp    $0x14,%ebx
    2562:	75 c4                	jne    2528 <bigfile+0x48>
  close(fd);
    2564:	83 ec 0c             	sub    $0xc,%esp
    2567:	56                   	push   %esi
    2568:	e8 6d 13 00 00       	call   38da <close>
  fd = open("bigfile", 0);
    256d:	5e                   	pop    %esi
    256e:	5f                   	pop    %edi
    256f:	6a 00                	push   $0x0
    2571:	68 40 48 00 00       	push   $0x4840
    2576:	e8 77 13 00 00       	call   38f2 <open>
  if(fd < 0){
    257b:	83 c4 10             	add    $0x10,%esp
    257e:	85 c0                	test   %eax,%eax
  fd = open("bigfile", 0);
    2580:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2582:	0f 88 e0 00 00 00    	js     2668 <bigfile+0x188>
  total = 0;
    2588:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    258a:	31 ff                	xor    %edi,%edi
    258c:	eb 30                	jmp    25be <bigfile+0xde>
    258e:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    2590:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2595:	0f 85 91 00 00 00    	jne    262c <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    259b:	0f be 05 00 86 00 00 	movsbl 0x8600,%eax
    25a2:	89 fa                	mov    %edi,%edx
    25a4:	d1 fa                	sar    %edx
    25a6:	39 d0                	cmp    %edx,%eax
    25a8:	75 6e                	jne    2618 <bigfile+0x138>
    25aa:	0f be 15 2b 87 00 00 	movsbl 0x872b,%edx
    25b1:	39 d0                	cmp    %edx,%eax
    25b3:	75 63                	jne    2618 <bigfile+0x138>
    total += cc;
    25b5:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    25bb:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    25be:	83 ec 04             	sub    $0x4,%esp
    25c1:	68 2c 01 00 00       	push   $0x12c
    25c6:	68 00 86 00 00       	push   $0x8600
    25cb:	56                   	push   %esi
    25cc:	e8 f9 12 00 00       	call   38ca <read>
    if(cc < 0){
    25d1:	83 c4 10             	add    $0x10,%esp
    25d4:	85 c0                	test   %eax,%eax
    25d6:	78 68                	js     2640 <bigfile+0x160>
    if(cc == 0)
    25d8:	75 b6                	jne    2590 <bigfile+0xb0>
  close(fd);
    25da:	83 ec 0c             	sub    $0xc,%esp
    25dd:	56                   	push   %esi
    25de:	e8 f7 12 00 00       	call   38da <close>
  if(total != 20*600){
    25e3:	83 c4 10             	add    $0x10,%esp
    25e6:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    25ec:	0f 85 9c 00 00 00    	jne    268e <bigfile+0x1ae>
  unlink("bigfile");
    25f2:	83 ec 0c             	sub    $0xc,%esp
    25f5:	68 40 48 00 00       	push   $0x4840
    25fa:	e8 03 13 00 00       	call   3902 <unlink>
  printf(1, "bigfile test ok\n");
    25ff:	58                   	pop    %eax
    2600:	5a                   	pop    %edx
    2601:	68 cf 48 00 00       	push   $0x48cf
    2606:	6a 01                	push   $0x1
    2608:	e8 03 14 00 00       	call   3a10 <printf>
}
    260d:	83 c4 10             	add    $0x10,%esp
    2610:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2613:	5b                   	pop    %ebx
    2614:	5e                   	pop    %esi
    2615:	5f                   	pop    %edi
    2616:	5d                   	pop    %ebp
    2617:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    2618:	83 ec 08             	sub    $0x8,%esp
    261b:	68 9c 48 00 00       	push   $0x489c
    2620:	6a 01                	push   $0x1
    2622:	e8 e9 13 00 00       	call   3a10 <printf>
      exit();
    2627:	e8 86 12 00 00       	call   38b2 <exit>
      printf(1, "short read bigfile\n");
    262c:	83 ec 08             	sub    $0x8,%esp
    262f:	68 88 48 00 00       	push   $0x4888
    2634:	6a 01                	push   $0x1
    2636:	e8 d5 13 00 00       	call   3a10 <printf>
      exit();
    263b:	e8 72 12 00 00       	call   38b2 <exit>
      printf(1, "read bigfile failed\n");
    2640:	83 ec 08             	sub    $0x8,%esp
    2643:	68 73 48 00 00       	push   $0x4873
    2648:	6a 01                	push   $0x1
    264a:	e8 c1 13 00 00       	call   3a10 <printf>
      exit();
    264f:	e8 5e 12 00 00       	call   38b2 <exit>
      printf(1, "write bigfile failed\n");
    2654:	83 ec 08             	sub    $0x8,%esp
    2657:	68 48 48 00 00       	push   $0x4848
    265c:	6a 01                	push   $0x1
    265e:	e8 ad 13 00 00       	call   3a10 <printf>
      exit();
    2663:	e8 4a 12 00 00       	call   38b2 <exit>
    printf(1, "cannot open bigfile\n");
    2668:	53                   	push   %ebx
    2669:	53                   	push   %ebx
    266a:	68 5e 48 00 00       	push   $0x485e
    266f:	6a 01                	push   $0x1
    2671:	e8 9a 13 00 00       	call   3a10 <printf>
    exit();
    2676:	e8 37 12 00 00       	call   38b2 <exit>
    printf(1, "cannot create bigfile");
    267b:	50                   	push   %eax
    267c:	50                   	push   %eax
    267d:	68 32 48 00 00       	push   $0x4832
    2682:	6a 01                	push   $0x1
    2684:	e8 87 13 00 00       	call   3a10 <printf>
    exit();
    2689:	e8 24 12 00 00       	call   38b2 <exit>
    printf(1, "read bigfile wrong total\n");
    268e:	51                   	push   %ecx
    268f:	51                   	push   %ecx
    2690:	68 b5 48 00 00       	push   $0x48b5
    2695:	6a 01                	push   $0x1
    2697:	e8 74 13 00 00       	call   3a10 <printf>
    exit();
    269c:	e8 11 12 00 00       	call   38b2 <exit>
    26a1:	eb 0d                	jmp    26b0 <fourteen>
    26a3:	90                   	nop
    26a4:	90                   	nop
    26a5:	90                   	nop
    26a6:	90                   	nop
    26a7:	90                   	nop
    26a8:	90                   	nop
    26a9:	90                   	nop
    26aa:	90                   	nop
    26ab:	90                   	nop
    26ac:	90                   	nop
    26ad:	90                   	nop
    26ae:	90                   	nop
    26af:	90                   	nop

000026b0 <fourteen>:
{
    26b0:	55                   	push   %ebp
    26b1:	89 e5                	mov    %esp,%ebp
    26b3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    26b6:	68 e0 48 00 00       	push   $0x48e0
    26bb:	6a 01                	push   $0x1
    26bd:	e8 4e 13 00 00       	call   3a10 <printf>
  if(mkdir("12345678901234") != 0){
    26c2:	c7 04 24 1b 49 00 00 	movl   $0x491b,(%esp)
    26c9:	e8 4c 12 00 00       	call   391a <mkdir>
    26ce:	83 c4 10             	add    $0x10,%esp
    26d1:	85 c0                	test   %eax,%eax
    26d3:	0f 85 97 00 00 00    	jne    2770 <fourteen+0xc0>
  if(mkdir("12345678901234/123456789012345") != 0){
    26d9:	83 ec 0c             	sub    $0xc,%esp
    26dc:	68 d8 50 00 00       	push   $0x50d8
    26e1:	e8 34 12 00 00       	call   391a <mkdir>
    26e6:	83 c4 10             	add    $0x10,%esp
    26e9:	85 c0                	test   %eax,%eax
    26eb:	0f 85 de 00 00 00    	jne    27cf <fourteen+0x11f>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26f1:	83 ec 08             	sub    $0x8,%esp
    26f4:	68 00 02 00 00       	push   $0x200
    26f9:	68 28 51 00 00       	push   $0x5128
    26fe:	e8 ef 11 00 00       	call   38f2 <open>
  if(fd < 0){
    2703:	83 c4 10             	add    $0x10,%esp
    2706:	85 c0                	test   %eax,%eax
    2708:	0f 88 ae 00 00 00    	js     27bc <fourteen+0x10c>
  close(fd);
    270e:	83 ec 0c             	sub    $0xc,%esp
    2711:	50                   	push   %eax
    2712:	e8 c3 11 00 00       	call   38da <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2717:	58                   	pop    %eax
    2718:	5a                   	pop    %edx
    2719:	6a 00                	push   $0x0
    271b:	68 98 51 00 00       	push   $0x5198
    2720:	e8 cd 11 00 00       	call   38f2 <open>
  if(fd < 0){
    2725:	83 c4 10             	add    $0x10,%esp
    2728:	85 c0                	test   %eax,%eax
    272a:	78 7d                	js     27a9 <fourteen+0xf9>
  close(fd);
    272c:	83 ec 0c             	sub    $0xc,%esp
    272f:	50                   	push   %eax
    2730:	e8 a5 11 00 00       	call   38da <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    2735:	c7 04 24 0c 49 00 00 	movl   $0x490c,(%esp)
    273c:	e8 d9 11 00 00       	call   391a <mkdir>
    2741:	83 c4 10             	add    $0x10,%esp
    2744:	85 c0                	test   %eax,%eax
    2746:	74 4e                	je     2796 <fourteen+0xe6>
  if(mkdir("123456789012345/12345678901234") == 0){
    2748:	83 ec 0c             	sub    $0xc,%esp
    274b:	68 34 52 00 00       	push   $0x5234
    2750:	e8 c5 11 00 00       	call   391a <mkdir>
    2755:	83 c4 10             	add    $0x10,%esp
    2758:	85 c0                	test   %eax,%eax
    275a:	74 27                	je     2783 <fourteen+0xd3>
  printf(1, "fourteen ok\n");
    275c:	83 ec 08             	sub    $0x8,%esp
    275f:	68 2a 49 00 00       	push   $0x492a
    2764:	6a 01                	push   $0x1
    2766:	e8 a5 12 00 00       	call   3a10 <printf>
}
    276b:	83 c4 10             	add    $0x10,%esp
    276e:	c9                   	leave  
    276f:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2770:	50                   	push   %eax
    2771:	50                   	push   %eax
    2772:	68 ef 48 00 00       	push   $0x48ef
    2777:	6a 01                	push   $0x1
    2779:	e8 92 12 00 00       	call   3a10 <printf>
    exit();
    277e:	e8 2f 11 00 00       	call   38b2 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2783:	50                   	push   %eax
    2784:	50                   	push   %eax
    2785:	68 54 52 00 00       	push   $0x5254
    278a:	6a 01                	push   $0x1
    278c:	e8 7f 12 00 00       	call   3a10 <printf>
    exit();
    2791:	e8 1c 11 00 00       	call   38b2 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2796:	52                   	push   %edx
    2797:	52                   	push   %edx
    2798:	68 04 52 00 00       	push   $0x5204
    279d:	6a 01                	push   $0x1
    279f:	e8 6c 12 00 00       	call   3a10 <printf>
    exit();
    27a4:	e8 09 11 00 00       	call   38b2 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    27a9:	51                   	push   %ecx
    27aa:	51                   	push   %ecx
    27ab:	68 c8 51 00 00       	push   $0x51c8
    27b0:	6a 01                	push   $0x1
    27b2:	e8 59 12 00 00       	call   3a10 <printf>
    exit();
    27b7:	e8 f6 10 00 00       	call   38b2 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    27bc:	51                   	push   %ecx
    27bd:	51                   	push   %ecx
    27be:	68 58 51 00 00       	push   $0x5158
    27c3:	6a 01                	push   $0x1
    27c5:	e8 46 12 00 00       	call   3a10 <printf>
    exit();
    27ca:	e8 e3 10 00 00       	call   38b2 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    27cf:	50                   	push   %eax
    27d0:	50                   	push   %eax
    27d1:	68 f8 50 00 00       	push   $0x50f8
    27d6:	6a 01                	push   $0x1
    27d8:	e8 33 12 00 00       	call   3a10 <printf>
    exit();
    27dd:	e8 d0 10 00 00       	call   38b2 <exit>
    27e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    27e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000027f0 <rmdot>:
{
    27f0:	55                   	push   %ebp
    27f1:	89 e5                	mov    %esp,%ebp
    27f3:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    27f6:	68 37 49 00 00       	push   $0x4937
    27fb:	6a 01                	push   $0x1
    27fd:	e8 0e 12 00 00       	call   3a10 <printf>
  if(mkdir("dots") != 0){
    2802:	c7 04 24 43 49 00 00 	movl   $0x4943,(%esp)
    2809:	e8 0c 11 00 00       	call   391a <mkdir>
    280e:	83 c4 10             	add    $0x10,%esp
    2811:	85 c0                	test   %eax,%eax
    2813:	0f 85 b0 00 00 00    	jne    28c9 <rmdot+0xd9>
  if(chdir("dots") != 0){
    2819:	83 ec 0c             	sub    $0xc,%esp
    281c:	68 43 49 00 00       	push   $0x4943
    2821:	e8 fc 10 00 00       	call   3922 <chdir>
    2826:	83 c4 10             	add    $0x10,%esp
    2829:	85 c0                	test   %eax,%eax
    282b:	0f 85 1d 01 00 00    	jne    294e <rmdot+0x15e>
  if(unlink(".") == 0){
    2831:	83 ec 0c             	sub    $0xc,%esp
    2834:	68 ee 45 00 00       	push   $0x45ee
    2839:	e8 c4 10 00 00       	call   3902 <unlink>
    283e:	83 c4 10             	add    $0x10,%esp
    2841:	85 c0                	test   %eax,%eax
    2843:	0f 84 f2 00 00 00    	je     293b <rmdot+0x14b>
  if(unlink("..") == 0){
    2849:	83 ec 0c             	sub    $0xc,%esp
    284c:	68 ed 45 00 00       	push   $0x45ed
    2851:	e8 ac 10 00 00       	call   3902 <unlink>
    2856:	83 c4 10             	add    $0x10,%esp
    2859:	85 c0                	test   %eax,%eax
    285b:	0f 84 c7 00 00 00    	je     2928 <rmdot+0x138>
  if(chdir("/") != 0){
    2861:	83 ec 0c             	sub    $0xc,%esp
    2864:	68 b1 3d 00 00       	push   $0x3db1
    2869:	e8 b4 10 00 00       	call   3922 <chdir>
    286e:	83 c4 10             	add    $0x10,%esp
    2871:	85 c0                	test   %eax,%eax
    2873:	0f 85 9c 00 00 00    	jne    2915 <rmdot+0x125>
  if(unlink("dots/.") == 0){
    2879:	83 ec 0c             	sub    $0xc,%esp
    287c:	68 8b 49 00 00       	push   $0x498b
    2881:	e8 7c 10 00 00       	call   3902 <unlink>
    2886:	83 c4 10             	add    $0x10,%esp
    2889:	85 c0                	test   %eax,%eax
    288b:	74 75                	je     2902 <rmdot+0x112>
  if(unlink("dots/..") == 0){
    288d:	83 ec 0c             	sub    $0xc,%esp
    2890:	68 a9 49 00 00       	push   $0x49a9
    2895:	e8 68 10 00 00       	call   3902 <unlink>
    289a:	83 c4 10             	add    $0x10,%esp
    289d:	85 c0                	test   %eax,%eax
    289f:	74 4e                	je     28ef <rmdot+0xff>
  if(unlink("dots") != 0){
    28a1:	83 ec 0c             	sub    $0xc,%esp
    28a4:	68 43 49 00 00       	push   $0x4943
    28a9:	e8 54 10 00 00       	call   3902 <unlink>
    28ae:	83 c4 10             	add    $0x10,%esp
    28b1:	85 c0                	test   %eax,%eax
    28b3:	75 27                	jne    28dc <rmdot+0xec>
  printf(1, "rmdot ok\n");
    28b5:	83 ec 08             	sub    $0x8,%esp
    28b8:	68 de 49 00 00       	push   $0x49de
    28bd:	6a 01                	push   $0x1
    28bf:	e8 4c 11 00 00       	call   3a10 <printf>
}
    28c4:	83 c4 10             	add    $0x10,%esp
    28c7:	c9                   	leave  
    28c8:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    28c9:	50                   	push   %eax
    28ca:	50                   	push   %eax
    28cb:	68 48 49 00 00       	push   $0x4948
    28d0:	6a 01                	push   $0x1
    28d2:	e8 39 11 00 00       	call   3a10 <printf>
    exit();
    28d7:	e8 d6 0f 00 00       	call   38b2 <exit>
    printf(1, "unlink dots failed!\n");
    28dc:	50                   	push   %eax
    28dd:	50                   	push   %eax
    28de:	68 c9 49 00 00       	push   $0x49c9
    28e3:	6a 01                	push   $0x1
    28e5:	e8 26 11 00 00       	call   3a10 <printf>
    exit();
    28ea:	e8 c3 0f 00 00       	call   38b2 <exit>
    printf(1, "unlink dots/.. worked!\n");
    28ef:	52                   	push   %edx
    28f0:	52                   	push   %edx
    28f1:	68 b1 49 00 00       	push   $0x49b1
    28f6:	6a 01                	push   $0x1
    28f8:	e8 13 11 00 00       	call   3a10 <printf>
    exit();
    28fd:	e8 b0 0f 00 00       	call   38b2 <exit>
    printf(1, "unlink dots/. worked!\n");
    2902:	51                   	push   %ecx
    2903:	51                   	push   %ecx
    2904:	68 92 49 00 00       	push   $0x4992
    2909:	6a 01                	push   $0x1
    290b:	e8 00 11 00 00       	call   3a10 <printf>
    exit();
    2910:	e8 9d 0f 00 00       	call   38b2 <exit>
    printf(1, "chdir / failed\n");
    2915:	50                   	push   %eax
    2916:	50                   	push   %eax
    2917:	68 b3 3d 00 00       	push   $0x3db3
    291c:	6a 01                	push   $0x1
    291e:	e8 ed 10 00 00       	call   3a10 <printf>
    exit();
    2923:	e8 8a 0f 00 00       	call   38b2 <exit>
    printf(1, "rm .. worked!\n");
    2928:	50                   	push   %eax
    2929:	50                   	push   %eax
    292a:	68 7c 49 00 00       	push   $0x497c
    292f:	6a 01                	push   $0x1
    2931:	e8 da 10 00 00       	call   3a10 <printf>
    exit();
    2936:	e8 77 0f 00 00       	call   38b2 <exit>
    printf(1, "rm . worked!\n");
    293b:	50                   	push   %eax
    293c:	50                   	push   %eax
    293d:	68 6e 49 00 00       	push   $0x496e
    2942:	6a 01                	push   $0x1
    2944:	e8 c7 10 00 00       	call   3a10 <printf>
    exit();
    2949:	e8 64 0f 00 00       	call   38b2 <exit>
    printf(1, "chdir dots failed\n");
    294e:	50                   	push   %eax
    294f:	50                   	push   %eax
    2950:	68 5b 49 00 00       	push   $0x495b
    2955:	6a 01                	push   $0x1
    2957:	e8 b4 10 00 00       	call   3a10 <printf>
    exit();
    295c:	e8 51 0f 00 00       	call   38b2 <exit>
    2961:	eb 0d                	jmp    2970 <dirfile>
    2963:	90                   	nop
    2964:	90                   	nop
    2965:	90                   	nop
    2966:	90                   	nop
    2967:	90                   	nop
    2968:	90                   	nop
    2969:	90                   	nop
    296a:	90                   	nop
    296b:	90                   	nop
    296c:	90                   	nop
    296d:	90                   	nop
    296e:	90                   	nop
    296f:	90                   	nop

00002970 <dirfile>:
{
    2970:	55                   	push   %ebp
    2971:	89 e5                	mov    %esp,%ebp
    2973:	53                   	push   %ebx
    2974:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    2977:	68 e8 49 00 00       	push   $0x49e8
    297c:	6a 01                	push   $0x1
    297e:	e8 8d 10 00 00       	call   3a10 <printf>
  fd = open("dirfile", O_CREATE);
    2983:	59                   	pop    %ecx
    2984:	5b                   	pop    %ebx
    2985:	68 00 02 00 00       	push   $0x200
    298a:	68 f5 49 00 00       	push   $0x49f5
    298f:	e8 5e 0f 00 00       	call   38f2 <open>
  if(fd < 0){
    2994:	83 c4 10             	add    $0x10,%esp
    2997:	85 c0                	test   %eax,%eax
    2999:	0f 88 43 01 00 00    	js     2ae2 <dirfile+0x172>
  close(fd);
    299f:	83 ec 0c             	sub    $0xc,%esp
    29a2:	50                   	push   %eax
    29a3:	e8 32 0f 00 00       	call   38da <close>
  if(chdir("dirfile") == 0){
    29a8:	c7 04 24 f5 49 00 00 	movl   $0x49f5,(%esp)
    29af:	e8 6e 0f 00 00       	call   3922 <chdir>
    29b4:	83 c4 10             	add    $0x10,%esp
    29b7:	85 c0                	test   %eax,%eax
    29b9:	0f 84 10 01 00 00    	je     2acf <dirfile+0x15f>
  fd = open("dirfile/xx", 0);
    29bf:	83 ec 08             	sub    $0x8,%esp
    29c2:	6a 00                	push   $0x0
    29c4:	68 2e 4a 00 00       	push   $0x4a2e
    29c9:	e8 24 0f 00 00       	call   38f2 <open>
  if(fd >= 0){
    29ce:	83 c4 10             	add    $0x10,%esp
    29d1:	85 c0                	test   %eax,%eax
    29d3:	0f 89 e3 00 00 00    	jns    2abc <dirfile+0x14c>
  fd = open("dirfile/xx", O_CREATE);
    29d9:	83 ec 08             	sub    $0x8,%esp
    29dc:	68 00 02 00 00       	push   $0x200
    29e1:	68 2e 4a 00 00       	push   $0x4a2e
    29e6:	e8 07 0f 00 00       	call   38f2 <open>
  if(fd >= 0){
    29eb:	83 c4 10             	add    $0x10,%esp
    29ee:	85 c0                	test   %eax,%eax
    29f0:	0f 89 c6 00 00 00    	jns    2abc <dirfile+0x14c>
  if(mkdir("dirfile/xx") == 0){
    29f6:	83 ec 0c             	sub    $0xc,%esp
    29f9:	68 2e 4a 00 00       	push   $0x4a2e
    29fe:	e8 17 0f 00 00       	call   391a <mkdir>
    2a03:	83 c4 10             	add    $0x10,%esp
    2a06:	85 c0                	test   %eax,%eax
    2a08:	0f 84 46 01 00 00    	je     2b54 <dirfile+0x1e4>
  if(unlink("dirfile/xx") == 0){
    2a0e:	83 ec 0c             	sub    $0xc,%esp
    2a11:	68 2e 4a 00 00       	push   $0x4a2e
    2a16:	e8 e7 0e 00 00       	call   3902 <unlink>
    2a1b:	83 c4 10             	add    $0x10,%esp
    2a1e:	85 c0                	test   %eax,%eax
    2a20:	0f 84 1b 01 00 00    	je     2b41 <dirfile+0x1d1>
  if(link("README", "dirfile/xx") == 0){
    2a26:	83 ec 08             	sub    $0x8,%esp
    2a29:	68 2e 4a 00 00       	push   $0x4a2e
    2a2e:	68 92 4a 00 00       	push   $0x4a92
    2a33:	e8 da 0e 00 00       	call   3912 <link>
    2a38:	83 c4 10             	add    $0x10,%esp
    2a3b:	85 c0                	test   %eax,%eax
    2a3d:	0f 84 eb 00 00 00    	je     2b2e <dirfile+0x1be>
  if(unlink("dirfile") != 0){
    2a43:	83 ec 0c             	sub    $0xc,%esp
    2a46:	68 f5 49 00 00       	push   $0x49f5
    2a4b:	e8 b2 0e 00 00       	call   3902 <unlink>
    2a50:	83 c4 10             	add    $0x10,%esp
    2a53:	85 c0                	test   %eax,%eax
    2a55:	0f 85 c0 00 00 00    	jne    2b1b <dirfile+0x1ab>
  fd = open(".", O_RDWR);
    2a5b:	83 ec 08             	sub    $0x8,%esp
    2a5e:	6a 02                	push   $0x2
    2a60:	68 ee 45 00 00       	push   $0x45ee
    2a65:	e8 88 0e 00 00       	call   38f2 <open>
  if(fd >= 0){
    2a6a:	83 c4 10             	add    $0x10,%esp
    2a6d:	85 c0                	test   %eax,%eax
    2a6f:	0f 89 93 00 00 00    	jns    2b08 <dirfile+0x198>
  fd = open(".", 0);
    2a75:	83 ec 08             	sub    $0x8,%esp
    2a78:	6a 00                	push   $0x0
    2a7a:	68 ee 45 00 00       	push   $0x45ee
    2a7f:	e8 6e 0e 00 00       	call   38f2 <open>
  if(write(fd, "x", 1) > 0){
    2a84:	83 c4 0c             	add    $0xc,%esp
  fd = open(".", 0);
    2a87:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2a89:	6a 01                	push   $0x1
    2a8b:	68 d1 46 00 00       	push   $0x46d1
    2a90:	50                   	push   %eax
    2a91:	e8 3c 0e 00 00       	call   38d2 <write>
    2a96:	83 c4 10             	add    $0x10,%esp
    2a99:	85 c0                	test   %eax,%eax
    2a9b:	7f 58                	jg     2af5 <dirfile+0x185>
  close(fd);
    2a9d:	83 ec 0c             	sub    $0xc,%esp
    2aa0:	53                   	push   %ebx
    2aa1:	e8 34 0e 00 00       	call   38da <close>
  printf(1, "dir vs file OK\n");
    2aa6:	58                   	pop    %eax
    2aa7:	5a                   	pop    %edx
    2aa8:	68 c5 4a 00 00       	push   $0x4ac5
    2aad:	6a 01                	push   $0x1
    2aaf:	e8 5c 0f 00 00       	call   3a10 <printf>
}
    2ab4:	83 c4 10             	add    $0x10,%esp
    2ab7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2aba:	c9                   	leave  
    2abb:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2abc:	50                   	push   %eax
    2abd:	50                   	push   %eax
    2abe:	68 39 4a 00 00       	push   $0x4a39
    2ac3:	6a 01                	push   $0x1
    2ac5:	e8 46 0f 00 00       	call   3a10 <printf>
    exit();
    2aca:	e8 e3 0d 00 00       	call   38b2 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2acf:	50                   	push   %eax
    2ad0:	50                   	push   %eax
    2ad1:	68 14 4a 00 00       	push   $0x4a14
    2ad6:	6a 01                	push   $0x1
    2ad8:	e8 33 0f 00 00       	call   3a10 <printf>
    exit();
    2add:	e8 d0 0d 00 00       	call   38b2 <exit>
    printf(1, "create dirfile failed\n");
    2ae2:	52                   	push   %edx
    2ae3:	52                   	push   %edx
    2ae4:	68 fd 49 00 00       	push   $0x49fd
    2ae9:	6a 01                	push   $0x1
    2aeb:	e8 20 0f 00 00       	call   3a10 <printf>
    exit();
    2af0:	e8 bd 0d 00 00       	call   38b2 <exit>
    printf(1, "write . succeeded!\n");
    2af5:	51                   	push   %ecx
    2af6:	51                   	push   %ecx
    2af7:	68 b1 4a 00 00       	push   $0x4ab1
    2afc:	6a 01                	push   $0x1
    2afe:	e8 0d 0f 00 00       	call   3a10 <printf>
    exit();
    2b03:	e8 aa 0d 00 00       	call   38b2 <exit>
    printf(1, "open . for writing succeeded!\n");
    2b08:	53                   	push   %ebx
    2b09:	53                   	push   %ebx
    2b0a:	68 a8 52 00 00       	push   $0x52a8
    2b0f:	6a 01                	push   $0x1
    2b11:	e8 fa 0e 00 00       	call   3a10 <printf>
    exit();
    2b16:	e8 97 0d 00 00       	call   38b2 <exit>
    printf(1, "unlink dirfile failed!\n");
    2b1b:	50                   	push   %eax
    2b1c:	50                   	push   %eax
    2b1d:	68 99 4a 00 00       	push   $0x4a99
    2b22:	6a 01                	push   $0x1
    2b24:	e8 e7 0e 00 00       	call   3a10 <printf>
    exit();
    2b29:	e8 84 0d 00 00       	call   38b2 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2b2e:	50                   	push   %eax
    2b2f:	50                   	push   %eax
    2b30:	68 88 52 00 00       	push   $0x5288
    2b35:	6a 01                	push   $0x1
    2b37:	e8 d4 0e 00 00       	call   3a10 <printf>
    exit();
    2b3c:	e8 71 0d 00 00       	call   38b2 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2b41:	50                   	push   %eax
    2b42:	50                   	push   %eax
    2b43:	68 74 4a 00 00       	push   $0x4a74
    2b48:	6a 01                	push   $0x1
    2b4a:	e8 c1 0e 00 00       	call   3a10 <printf>
    exit();
    2b4f:	e8 5e 0d 00 00       	call   38b2 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2b54:	50                   	push   %eax
    2b55:	50                   	push   %eax
    2b56:	68 57 4a 00 00       	push   $0x4a57
    2b5b:	6a 01                	push   $0x1
    2b5d:	e8 ae 0e 00 00       	call   3a10 <printf>
    exit();
    2b62:	e8 4b 0d 00 00       	call   38b2 <exit>
    2b67:	89 f6                	mov    %esi,%esi
    2b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00002b70 <iref>:
{
    2b70:	55                   	push   %ebp
    2b71:	89 e5                	mov    %esp,%ebp
    2b73:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2b74:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2b79:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2b7c:	68 d5 4a 00 00       	push   $0x4ad5
    2b81:	6a 01                	push   $0x1
    2b83:	e8 88 0e 00 00       	call   3a10 <printf>
    2b88:	83 c4 10             	add    $0x10,%esp
    2b8b:	90                   	nop
    2b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mkdir("irefd") != 0){
    2b90:	83 ec 0c             	sub    $0xc,%esp
    2b93:	68 e6 4a 00 00       	push   $0x4ae6
    2b98:	e8 7d 0d 00 00       	call   391a <mkdir>
    2b9d:	83 c4 10             	add    $0x10,%esp
    2ba0:	85 c0                	test   %eax,%eax
    2ba2:	0f 85 bb 00 00 00    	jne    2c63 <iref+0xf3>
    if(chdir("irefd") != 0){
    2ba8:	83 ec 0c             	sub    $0xc,%esp
    2bab:	68 e6 4a 00 00       	push   $0x4ae6
    2bb0:	e8 6d 0d 00 00       	call   3922 <chdir>
    2bb5:	83 c4 10             	add    $0x10,%esp
    2bb8:	85 c0                	test   %eax,%eax
    2bba:	0f 85 b7 00 00 00    	jne    2c77 <iref+0x107>
    mkdir("");
    2bc0:	83 ec 0c             	sub    $0xc,%esp
    2bc3:	68 8b 41 00 00       	push   $0x418b
    2bc8:	e8 4d 0d 00 00       	call   391a <mkdir>
    link("README", "");
    2bcd:	59                   	pop    %ecx
    2bce:	58                   	pop    %eax
    2bcf:	68 8b 41 00 00       	push   $0x418b
    2bd4:	68 92 4a 00 00       	push   $0x4a92
    2bd9:	e8 34 0d 00 00       	call   3912 <link>
    fd = open("", O_CREATE);
    2bde:	58                   	pop    %eax
    2bdf:	5a                   	pop    %edx
    2be0:	68 00 02 00 00       	push   $0x200
    2be5:	68 8b 41 00 00       	push   $0x418b
    2bea:	e8 03 0d 00 00       	call   38f2 <open>
    if(fd >= 0)
    2bef:	83 c4 10             	add    $0x10,%esp
    2bf2:	85 c0                	test   %eax,%eax
    2bf4:	78 0c                	js     2c02 <iref+0x92>
      close(fd);
    2bf6:	83 ec 0c             	sub    $0xc,%esp
    2bf9:	50                   	push   %eax
    2bfa:	e8 db 0c 00 00       	call   38da <close>
    2bff:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2c02:	83 ec 08             	sub    $0x8,%esp
    2c05:	68 00 02 00 00       	push   $0x200
    2c0a:	68 d0 46 00 00       	push   $0x46d0
    2c0f:	e8 de 0c 00 00       	call   38f2 <open>
    if(fd >= 0)
    2c14:	83 c4 10             	add    $0x10,%esp
    2c17:	85 c0                	test   %eax,%eax
    2c19:	78 0c                	js     2c27 <iref+0xb7>
      close(fd);
    2c1b:	83 ec 0c             	sub    $0xc,%esp
    2c1e:	50                   	push   %eax
    2c1f:	e8 b6 0c 00 00       	call   38da <close>
    2c24:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2c27:	83 ec 0c             	sub    $0xc,%esp
    2c2a:	68 d0 46 00 00       	push   $0x46d0
    2c2f:	e8 ce 0c 00 00       	call   3902 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2c34:	83 c4 10             	add    $0x10,%esp
    2c37:	83 eb 01             	sub    $0x1,%ebx
    2c3a:	0f 85 50 ff ff ff    	jne    2b90 <iref+0x20>
  chdir("/");
    2c40:	83 ec 0c             	sub    $0xc,%esp
    2c43:	68 b1 3d 00 00       	push   $0x3db1
    2c48:	e8 d5 0c 00 00       	call   3922 <chdir>
  printf(1, "empty file name OK\n");
    2c4d:	58                   	pop    %eax
    2c4e:	5a                   	pop    %edx
    2c4f:	68 14 4b 00 00       	push   $0x4b14
    2c54:	6a 01                	push   $0x1
    2c56:	e8 b5 0d 00 00       	call   3a10 <printf>
}
    2c5b:	83 c4 10             	add    $0x10,%esp
    2c5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2c61:	c9                   	leave  
    2c62:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2c63:	83 ec 08             	sub    $0x8,%esp
    2c66:	68 ec 4a 00 00       	push   $0x4aec
    2c6b:	6a 01                	push   $0x1
    2c6d:	e8 9e 0d 00 00       	call   3a10 <printf>
      exit();
    2c72:	e8 3b 0c 00 00       	call   38b2 <exit>
      printf(1, "chdir irefd failed\n");
    2c77:	83 ec 08             	sub    $0x8,%esp
    2c7a:	68 00 4b 00 00       	push   $0x4b00
    2c7f:	6a 01                	push   $0x1
    2c81:	e8 8a 0d 00 00       	call   3a10 <printf>
      exit();
    2c86:	e8 27 0c 00 00       	call   38b2 <exit>
    2c8b:	90                   	nop
    2c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002c90 <forktest>:
{
    2c90:	55                   	push   %ebp
    2c91:	89 e5                	mov    %esp,%ebp
    2c93:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2c94:	31 db                	xor    %ebx,%ebx
{
    2c96:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2c99:	68 28 4b 00 00       	push   $0x4b28
    2c9e:	6a 01                	push   $0x1
    2ca0:	e8 6b 0d 00 00       	call   3a10 <printf>
    2ca5:	83 c4 10             	add    $0x10,%esp
    2ca8:	eb 13                	jmp    2cbd <forktest+0x2d>
    2caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(pid == 0)
    2cb0:	74 62                	je     2d14 <forktest+0x84>
  for(n=0; n<1000; n++){
    2cb2:	83 c3 01             	add    $0x1,%ebx
    2cb5:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2cbb:	74 43                	je     2d00 <forktest+0x70>
    pid = fork();
    2cbd:	e8 e8 0b 00 00       	call   38aa <fork>
    if(pid < 0)
    2cc2:	85 c0                	test   %eax,%eax
    2cc4:	79 ea                	jns    2cb0 <forktest+0x20>
  for(; n > 0; n--){
    2cc6:	85 db                	test   %ebx,%ebx
    2cc8:	74 14                	je     2cde <forktest+0x4e>
    2cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2cd0:	e8 e5 0b 00 00       	call   38ba <wait>
    2cd5:	85 c0                	test   %eax,%eax
    2cd7:	78 40                	js     2d19 <forktest+0x89>
  for(; n > 0; n--){
    2cd9:	83 eb 01             	sub    $0x1,%ebx
    2cdc:	75 f2                	jne    2cd0 <forktest+0x40>
  if(wait() != -1){
    2cde:	e8 d7 0b 00 00       	call   38ba <wait>
    2ce3:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ce6:	75 45                	jne    2d2d <forktest+0x9d>
  printf(1, "fork test OK\n");
    2ce8:	83 ec 08             	sub    $0x8,%esp
    2ceb:	68 5a 4b 00 00       	push   $0x4b5a
    2cf0:	6a 01                	push   $0x1
    2cf2:	e8 19 0d 00 00       	call   3a10 <printf>
}
    2cf7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2cfa:	c9                   	leave  
    2cfb:	c3                   	ret    
    2cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    printf(1, "fork claimed to work 1000 times!\n");
    2d00:	83 ec 08             	sub    $0x8,%esp
    2d03:	68 c8 52 00 00       	push   $0x52c8
    2d08:	6a 01                	push   $0x1
    2d0a:	e8 01 0d 00 00       	call   3a10 <printf>
    exit();
    2d0f:	e8 9e 0b 00 00       	call   38b2 <exit>
      exit();
    2d14:	e8 99 0b 00 00       	call   38b2 <exit>
      printf(1, "wait stopped early\n");
    2d19:	83 ec 08             	sub    $0x8,%esp
    2d1c:	68 33 4b 00 00       	push   $0x4b33
    2d21:	6a 01                	push   $0x1
    2d23:	e8 e8 0c 00 00       	call   3a10 <printf>
      exit();
    2d28:	e8 85 0b 00 00       	call   38b2 <exit>
    printf(1, "wait got too many\n");
    2d2d:	50                   	push   %eax
    2d2e:	50                   	push   %eax
    2d2f:	68 47 4b 00 00       	push   $0x4b47
    2d34:	6a 01                	push   $0x1
    2d36:	e8 d5 0c 00 00       	call   3a10 <printf>
    exit();
    2d3b:	e8 72 0b 00 00       	call   38b2 <exit>

00002d40 <sbrktest>:
{
    2d40:	55                   	push   %ebp
    2d41:	89 e5                	mov    %esp,%ebp
    2d43:	57                   	push   %edi
    2d44:	56                   	push   %esi
    2d45:	53                   	push   %ebx
  for(i = 0; i < 5000; i++){
    2d46:	31 ff                	xor    %edi,%edi
{
    2d48:	83 ec 64             	sub    $0x64,%esp
  printf(stdout, "sbrk test\n");
    2d4b:	68 68 4b 00 00       	push   $0x4b68
    2d50:	ff 35 28 5e 00 00    	pushl  0x5e28
    2d56:	e8 b5 0c 00 00       	call   3a10 <printf>
  oldbrk = sbrk(0);
    2d5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d62:	e8 d3 0b 00 00       	call   393a <sbrk>
  a = sbrk(0);
    2d67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2d6e:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2d70:	e8 c5 0b 00 00       	call   393a <sbrk>
    2d75:	83 c4 10             	add    $0x10,%esp
    2d78:	89 c6                	mov    %eax,%esi
    2d7a:	eb 06                	jmp    2d82 <sbrktest+0x42>
    2d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    a = b + 1;
    2d80:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2d82:	83 ec 0c             	sub    $0xc,%esp
    2d85:	6a 01                	push   $0x1
    2d87:	e8 ae 0b 00 00       	call   393a <sbrk>
    if(b != a){
    2d8c:	83 c4 10             	add    $0x10,%esp
    2d8f:	39 f0                	cmp    %esi,%eax
    2d91:	0f 85 62 02 00 00    	jne    2ff9 <sbrktest+0x2b9>
  for(i = 0; i < 5000; i++){
    2d97:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2d9a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2d9d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2da0:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2da6:	75 d8                	jne    2d80 <sbrktest+0x40>
  pid = fork();
    2da8:	e8 fd 0a 00 00       	call   38aa <fork>
  if(pid < 0){
    2dad:	85 c0                	test   %eax,%eax
  pid = fork();
    2daf:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2db1:	0f 88 82 03 00 00    	js     3139 <sbrktest+0x3f9>
  c = sbrk(1);
    2db7:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2dba:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2dbd:	6a 01                	push   $0x1
    2dbf:	e8 76 0b 00 00       	call   393a <sbrk>
  c = sbrk(1);
    2dc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2dcb:	e8 6a 0b 00 00       	call   393a <sbrk>
  if(c != a + 1){
    2dd0:	83 c4 10             	add    $0x10,%esp
    2dd3:	39 f0                	cmp    %esi,%eax
    2dd5:	0f 85 47 03 00 00    	jne    3122 <sbrktest+0x3e2>
  if(pid == 0)
    2ddb:	85 ff                	test   %edi,%edi
    2ddd:	0f 84 3a 03 00 00    	je     311d <sbrktest+0x3dd>
  wait();
    2de3:	e8 d2 0a 00 00       	call   38ba <wait>
  a = sbrk(0);
    2de8:	83 ec 0c             	sub    $0xc,%esp
    2deb:	6a 00                	push   $0x0
    2ded:	e8 48 0b 00 00       	call   393a <sbrk>
    2df2:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2df4:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2df9:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2dfb:	89 04 24             	mov    %eax,(%esp)
    2dfe:	e8 37 0b 00 00       	call   393a <sbrk>
  if (p != a) {
    2e03:	83 c4 10             	add    $0x10,%esp
    2e06:	39 c6                	cmp    %eax,%esi
    2e08:	0f 85 f8 02 00 00    	jne    3106 <sbrktest+0x3c6>
  a = sbrk(0);
    2e0e:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2e11:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2e18:	6a 00                	push   $0x0
    2e1a:	e8 1b 0b 00 00       	call   393a <sbrk>
  c = sbrk(-4096);
    2e1f:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2e26:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2e28:	e8 0d 0b 00 00       	call   393a <sbrk>
  if(c == (char*)0xffffffff){
    2e2d:	83 c4 10             	add    $0x10,%esp
    2e30:	83 f8 ff             	cmp    $0xffffffff,%eax
    2e33:	0f 84 b6 02 00 00    	je     30ef <sbrktest+0x3af>
  c = sbrk(0);
    2e39:	83 ec 0c             	sub    $0xc,%esp
    2e3c:	6a 00                	push   $0x0
    2e3e:	e8 f7 0a 00 00       	call   393a <sbrk>
  if(c != a - 4096){
    2e43:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2e49:	83 c4 10             	add    $0x10,%esp
    2e4c:	39 d0                	cmp    %edx,%eax
    2e4e:	0f 85 84 02 00 00    	jne    30d8 <sbrktest+0x398>
  a = sbrk(0);
    2e54:	83 ec 0c             	sub    $0xc,%esp
    2e57:	6a 00                	push   $0x0
    2e59:	e8 dc 0a 00 00       	call   393a <sbrk>
    2e5e:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2e60:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2e67:	e8 ce 0a 00 00       	call   393a <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2e6c:	83 c4 10             	add    $0x10,%esp
    2e6f:	39 c6                	cmp    %eax,%esi
  c = sbrk(4096);
    2e71:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2e73:	0f 85 48 02 00 00    	jne    30c1 <sbrktest+0x381>
    2e79:	83 ec 0c             	sub    $0xc,%esp
    2e7c:	6a 00                	push   $0x0
    2e7e:	e8 b7 0a 00 00       	call   393a <sbrk>
    2e83:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2e89:	83 c4 10             	add    $0x10,%esp
    2e8c:	39 d0                	cmp    %edx,%eax
    2e8e:	0f 85 2d 02 00 00    	jne    30c1 <sbrktest+0x381>
  if(*lastaddr == 99){
    2e94:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2e9b:	0f 84 09 02 00 00    	je     30aa <sbrktest+0x36a>
  a = sbrk(0);
    2ea1:	83 ec 0c             	sub    $0xc,%esp
    2ea4:	6a 00                	push   $0x0
    2ea6:	e8 8f 0a 00 00       	call   393a <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2eab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2eb2:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2eb4:	e8 81 0a 00 00       	call   393a <sbrk>
    2eb9:	89 d9                	mov    %ebx,%ecx
    2ebb:	29 c1                	sub    %eax,%ecx
    2ebd:	89 0c 24             	mov    %ecx,(%esp)
    2ec0:	e8 75 0a 00 00       	call   393a <sbrk>
  if(c != a){
    2ec5:	83 c4 10             	add    $0x10,%esp
    2ec8:	39 c6                	cmp    %eax,%esi
    2eca:	0f 85 c3 01 00 00    	jne    3093 <sbrktest+0x353>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ed0:	be 00 00 00 80       	mov    $0x80000000,%esi
    ppid = getpid();
    2ed5:	e8 58 0a 00 00       	call   3932 <getpid>
    2eda:	89 c7                	mov    %eax,%edi
    pid = fork();
    2edc:	e8 c9 09 00 00       	call   38aa <fork>
    if(pid < 0){
    2ee1:	85 c0                	test   %eax,%eax
    2ee3:	0f 88 93 01 00 00    	js     307c <sbrktest+0x33c>
    if(pid == 0){
    2ee9:	0f 84 6b 01 00 00    	je     305a <sbrktest+0x31a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2eef:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    wait();
    2ef5:	e8 c0 09 00 00       	call   38ba <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2efa:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2f00:	75 d3                	jne    2ed5 <sbrktest+0x195>
  if(pipe(fds) != 0){
    2f02:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2f05:	83 ec 0c             	sub    $0xc,%esp
    2f08:	50                   	push   %eax
    2f09:	e8 b4 09 00 00       	call   38c2 <pipe>
    2f0e:	83 c4 10             	add    $0x10,%esp
    2f11:	85 c0                	test   %eax,%eax
    2f13:	0f 85 2e 01 00 00    	jne    3047 <sbrktest+0x307>
    2f19:	8d 7d c0             	lea    -0x40(%ebp),%edi
    2f1c:	89 fe                	mov    %edi,%esi
    2f1e:	eb 23                	jmp    2f43 <sbrktest+0x203>
    if(pids[i] != -1)
    2f20:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f23:	74 14                	je     2f39 <sbrktest+0x1f9>
      read(fds[0], &scratch, 1);
    2f25:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f28:	83 ec 04             	sub    $0x4,%esp
    2f2b:	6a 01                	push   $0x1
    2f2d:	50                   	push   %eax
    2f2e:	ff 75 b8             	pushl  -0x48(%ebp)
    2f31:	e8 94 09 00 00       	call   38ca <read>
    2f36:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f39:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2f3c:	83 c6 04             	add    $0x4,%esi
    2f3f:	39 c6                	cmp    %eax,%esi
    2f41:	74 4f                	je     2f92 <sbrktest+0x252>
    if((pids[i] = fork()) == 0){
    2f43:	e8 62 09 00 00       	call   38aa <fork>
    2f48:	85 c0                	test   %eax,%eax
    2f4a:	89 06                	mov    %eax,(%esi)
    2f4c:	75 d2                	jne    2f20 <sbrktest+0x1e0>
      sbrk(BIG - (uint)sbrk(0));
    2f4e:	83 ec 0c             	sub    $0xc,%esp
    2f51:	6a 00                	push   $0x0
    2f53:	e8 e2 09 00 00       	call   393a <sbrk>
    2f58:	ba 00 00 40 06       	mov    $0x6400000,%edx
    2f5d:	29 c2                	sub    %eax,%edx
    2f5f:	89 14 24             	mov    %edx,(%esp)
    2f62:	e8 d3 09 00 00       	call   393a <sbrk>
      write(fds[1], "x", 1);
    2f67:	83 c4 0c             	add    $0xc,%esp
    2f6a:	6a 01                	push   $0x1
    2f6c:	68 d1 46 00 00       	push   $0x46d1
    2f71:	ff 75 bc             	pushl  -0x44(%ebp)
    2f74:	e8 59 09 00 00       	call   38d2 <write>
    2f79:	83 c4 10             	add    $0x10,%esp
    2f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(;;) sleep(1000);
    2f80:	83 ec 0c             	sub    $0xc,%esp
    2f83:	68 e8 03 00 00       	push   $0x3e8
    2f88:	e8 b5 09 00 00       	call   3942 <sleep>
    2f8d:	83 c4 10             	add    $0x10,%esp
    2f90:	eb ee                	jmp    2f80 <sbrktest+0x240>
  c = sbrk(4096);
    2f92:	83 ec 0c             	sub    $0xc,%esp
    2f95:	68 00 10 00 00       	push   $0x1000
    2f9a:	e8 9b 09 00 00       	call   393a <sbrk>
    2f9f:	83 c4 10             	add    $0x10,%esp
    2fa2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    if(pids[i] == -1)
    2fa5:	8b 07                	mov    (%edi),%eax
    2fa7:	83 f8 ff             	cmp    $0xffffffff,%eax
    2faa:	74 11                	je     2fbd <sbrktest+0x27d>
    kill(pids[i]);
    2fac:	83 ec 0c             	sub    $0xc,%esp
    2faf:	50                   	push   %eax
    2fb0:	e8 2d 09 00 00       	call   38e2 <kill>
    wait();
    2fb5:	e8 00 09 00 00       	call   38ba <wait>
    2fba:	83 c4 10             	add    $0x10,%esp
    2fbd:	83 c7 04             	add    $0x4,%edi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2fc0:	39 fe                	cmp    %edi,%esi
    2fc2:	75 e1                	jne    2fa5 <sbrktest+0x265>
  if(c == (char*)0xffffffff){
    2fc4:	83 7d a4 ff          	cmpl   $0xffffffff,-0x5c(%ebp)
    2fc8:	74 66                	je     3030 <sbrktest+0x2f0>
  if(sbrk(0) > oldbrk)
    2fca:	83 ec 0c             	sub    $0xc,%esp
    2fcd:	6a 00                	push   $0x0
    2fcf:	e8 66 09 00 00       	call   393a <sbrk>
    2fd4:	83 c4 10             	add    $0x10,%esp
    2fd7:	39 d8                	cmp    %ebx,%eax
    2fd9:	77 3c                	ja     3017 <sbrktest+0x2d7>
  printf(stdout, "sbrk test OK\n");
    2fdb:	83 ec 08             	sub    $0x8,%esp
    2fde:	68 10 4c 00 00       	push   $0x4c10
    2fe3:	ff 35 28 5e 00 00    	pushl  0x5e28
    2fe9:	e8 22 0a 00 00       	call   3a10 <printf>
}
    2fee:	83 c4 10             	add    $0x10,%esp
    2ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2ff4:	5b                   	pop    %ebx
    2ff5:	5e                   	pop    %esi
    2ff6:	5f                   	pop    %edi
    2ff7:	5d                   	pop    %ebp
    2ff8:	c3                   	ret    
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2ff9:	83 ec 0c             	sub    $0xc,%esp
    2ffc:	50                   	push   %eax
    2ffd:	56                   	push   %esi
    2ffe:	57                   	push   %edi
    2fff:	68 73 4b 00 00       	push   $0x4b73
    3004:	ff 35 28 5e 00 00    	pushl  0x5e28
    300a:	e8 01 0a 00 00       	call   3a10 <printf>
      exit();
    300f:	83 c4 20             	add    $0x20,%esp
    3012:	e8 9b 08 00 00       	call   38b2 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    3017:	83 ec 0c             	sub    $0xc,%esp
    301a:	6a 00                	push   $0x0
    301c:	e8 19 09 00 00       	call   393a <sbrk>
    3021:	29 c3                	sub    %eax,%ebx
    3023:	89 1c 24             	mov    %ebx,(%esp)
    3026:	e8 0f 09 00 00       	call   393a <sbrk>
    302b:	83 c4 10             	add    $0x10,%esp
    302e:	eb ab                	jmp    2fdb <sbrktest+0x29b>
    printf(stdout, "failed sbrk leaked memory\n");
    3030:	50                   	push   %eax
    3031:	50                   	push   %eax
    3032:	68 f5 4b 00 00       	push   $0x4bf5
    3037:	ff 35 28 5e 00 00    	pushl  0x5e28
    303d:	e8 ce 09 00 00       	call   3a10 <printf>
    exit();
    3042:	e8 6b 08 00 00       	call   38b2 <exit>
    printf(1, "pipe() failed\n");
    3047:	52                   	push   %edx
    3048:	52                   	push   %edx
    3049:	68 a1 40 00 00       	push   $0x40a1
    304e:	6a 01                	push   $0x1
    3050:	e8 bb 09 00 00       	call   3a10 <printf>
    exit();
    3055:	e8 58 08 00 00       	call   38b2 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    305a:	0f be 06             	movsbl (%esi),%eax
    305d:	50                   	push   %eax
    305e:	56                   	push   %esi
    305f:	68 dc 4b 00 00       	push   $0x4bdc
    3064:	ff 35 28 5e 00 00    	pushl  0x5e28
    306a:	e8 a1 09 00 00       	call   3a10 <printf>
      kill(ppid);
    306f:	89 3c 24             	mov    %edi,(%esp)
    3072:	e8 6b 08 00 00       	call   38e2 <kill>
      exit();
    3077:	e8 36 08 00 00       	call   38b2 <exit>
      printf(stdout, "fork failed\n");
    307c:	51                   	push   %ecx
    307d:	51                   	push   %ecx
    307e:	68 b9 4c 00 00       	push   $0x4cb9
    3083:	ff 35 28 5e 00 00    	pushl  0x5e28
    3089:	e8 82 09 00 00       	call   3a10 <printf>
      exit();
    308e:	e8 1f 08 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3093:	50                   	push   %eax
    3094:	56                   	push   %esi
    3095:	68 bc 53 00 00       	push   $0x53bc
    309a:	ff 35 28 5e 00 00    	pushl  0x5e28
    30a0:	e8 6b 09 00 00       	call   3a10 <printf>
    exit();
    30a5:	e8 08 08 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    30aa:	53                   	push   %ebx
    30ab:	53                   	push   %ebx
    30ac:	68 8c 53 00 00       	push   $0x538c
    30b1:	ff 35 28 5e 00 00    	pushl  0x5e28
    30b7:	e8 54 09 00 00       	call   3a10 <printf>
    exit();
    30bc:	e8 f1 07 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    30c1:	57                   	push   %edi
    30c2:	56                   	push   %esi
    30c3:	68 64 53 00 00       	push   $0x5364
    30c8:	ff 35 28 5e 00 00    	pushl  0x5e28
    30ce:	e8 3d 09 00 00       	call   3a10 <printf>
    exit();
    30d3:	e8 da 07 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    30d8:	50                   	push   %eax
    30d9:	56                   	push   %esi
    30da:	68 2c 53 00 00       	push   $0x532c
    30df:	ff 35 28 5e 00 00    	pushl  0x5e28
    30e5:	e8 26 09 00 00       	call   3a10 <printf>
    exit();
    30ea:	e8 c3 07 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    30ef:	56                   	push   %esi
    30f0:	56                   	push   %esi
    30f1:	68 c1 4b 00 00       	push   $0x4bc1
    30f6:	ff 35 28 5e 00 00    	pushl  0x5e28
    30fc:	e8 0f 09 00 00       	call   3a10 <printf>
    exit();
    3101:	e8 ac 07 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    3106:	57                   	push   %edi
    3107:	57                   	push   %edi
    3108:	68 ec 52 00 00       	push   $0x52ec
    310d:	ff 35 28 5e 00 00    	pushl  0x5e28
    3113:	e8 f8 08 00 00       	call   3a10 <printf>
    exit();
    3118:	e8 95 07 00 00       	call   38b2 <exit>
    exit();
    311d:	e8 90 07 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    3122:	50                   	push   %eax
    3123:	50                   	push   %eax
    3124:	68 a5 4b 00 00       	push   $0x4ba5
    3129:	ff 35 28 5e 00 00    	pushl  0x5e28
    312f:	e8 dc 08 00 00       	call   3a10 <printf>
    exit();
    3134:	e8 79 07 00 00       	call   38b2 <exit>
    printf(stdout, "sbrk test fork failed\n");
    3139:	50                   	push   %eax
    313a:	50                   	push   %eax
    313b:	68 8e 4b 00 00       	push   $0x4b8e
    3140:	ff 35 28 5e 00 00    	pushl  0x5e28
    3146:	e8 c5 08 00 00       	call   3a10 <printf>
    exit();
    314b:	e8 62 07 00 00       	call   38b2 <exit>

00003150 <validateint>:
{
    3150:	55                   	push   %ebp
    3151:	89 e5                	mov    %esp,%ebp
}
    3153:	5d                   	pop    %ebp
    3154:	c3                   	ret    
    3155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003160 <validatetest>:
{
    3160:	55                   	push   %ebp
    3161:	89 e5                	mov    %esp,%ebp
    3163:	56                   	push   %esi
    3164:	53                   	push   %ebx
  for(p = 0; p <= (uint)hi; p += 4096){
    3165:	31 db                	xor    %ebx,%ebx
  printf(stdout, "validate test\n");
    3167:	83 ec 08             	sub    $0x8,%esp
    316a:	68 1e 4c 00 00       	push   $0x4c1e
    316f:	ff 35 28 5e 00 00    	pushl  0x5e28
    3175:	e8 96 08 00 00       	call   3a10 <printf>
    317a:	83 c4 10             	add    $0x10,%esp
    317d:	8d 76 00             	lea    0x0(%esi),%esi
    if((pid = fork()) == 0){
    3180:	e8 25 07 00 00       	call   38aa <fork>
    3185:	85 c0                	test   %eax,%eax
    3187:	89 c6                	mov    %eax,%esi
    3189:	74 63                	je     31ee <validatetest+0x8e>
    sleep(0);
    318b:	83 ec 0c             	sub    $0xc,%esp
    318e:	6a 00                	push   $0x0
    3190:	e8 ad 07 00 00       	call   3942 <sleep>
    sleep(0);
    3195:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    319c:	e8 a1 07 00 00       	call   3942 <sleep>
    kill(pid);
    31a1:	89 34 24             	mov    %esi,(%esp)
    31a4:	e8 39 07 00 00       	call   38e2 <kill>
    wait();
    31a9:	e8 0c 07 00 00       	call   38ba <wait>
    if(link("nosuchfile", (char*)p) != -1){
    31ae:	58                   	pop    %eax
    31af:	5a                   	pop    %edx
    31b0:	53                   	push   %ebx
    31b1:	68 2d 4c 00 00       	push   $0x4c2d
    31b6:	e8 57 07 00 00       	call   3912 <link>
    31bb:	83 c4 10             	add    $0x10,%esp
    31be:	83 f8 ff             	cmp    $0xffffffff,%eax
    31c1:	75 30                	jne    31f3 <validatetest+0x93>
  for(p = 0; p <= (uint)hi; p += 4096){
    31c3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    31c9:	81 fb 00 40 11 00    	cmp    $0x114000,%ebx
    31cf:	75 af                	jne    3180 <validatetest+0x20>
  printf(stdout, "validate ok\n");
    31d1:	83 ec 08             	sub    $0x8,%esp
    31d4:	68 51 4c 00 00       	push   $0x4c51
    31d9:	ff 35 28 5e 00 00    	pushl  0x5e28
    31df:	e8 2c 08 00 00       	call   3a10 <printf>
}
    31e4:	83 c4 10             	add    $0x10,%esp
    31e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
    31ea:	5b                   	pop    %ebx
    31eb:	5e                   	pop    %esi
    31ec:	5d                   	pop    %ebp
    31ed:	c3                   	ret    
      exit();
    31ee:	e8 bf 06 00 00       	call   38b2 <exit>
      printf(stdout, "link should not succeed\n");
    31f3:	83 ec 08             	sub    $0x8,%esp
    31f6:	68 38 4c 00 00       	push   $0x4c38
    31fb:	ff 35 28 5e 00 00    	pushl  0x5e28
    3201:	e8 0a 08 00 00       	call   3a10 <printf>
      exit();
    3206:	e8 a7 06 00 00       	call   38b2 <exit>
    320b:	90                   	nop
    320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003210 <bsstest>:
{
    3210:	55                   	push   %ebp
    3211:	89 e5                	mov    %esp,%ebp
    3213:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    3216:	68 5e 4c 00 00       	push   $0x4c5e
    321b:	ff 35 28 5e 00 00    	pushl  0x5e28
    3221:	e8 ea 07 00 00       	call   3a10 <printf>
    if(uninit[i] != '\0'){
    3226:	83 c4 10             	add    $0x10,%esp
    3229:	80 3d e0 5e 00 00 00 	cmpb   $0x0,0x5ee0
    3230:	75 39                	jne    326b <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3232:	b8 01 00 00 00       	mov    $0x1,%eax
    3237:	89 f6                	mov    %esi,%esi
    3239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(uninit[i] != '\0'){
    3240:	80 b8 e0 5e 00 00 00 	cmpb   $0x0,0x5ee0(%eax)
    3247:	75 22                	jne    326b <bsstest+0x5b>
  for(i = 0; i < sizeof(uninit); i++){
    3249:	83 c0 01             	add    $0x1,%eax
    324c:	3d 10 27 00 00       	cmp    $0x2710,%eax
    3251:	75 ed                	jne    3240 <bsstest+0x30>
  printf(stdout, "bss test ok\n");
    3253:	83 ec 08             	sub    $0x8,%esp
    3256:	68 79 4c 00 00       	push   $0x4c79
    325b:	ff 35 28 5e 00 00    	pushl  0x5e28
    3261:	e8 aa 07 00 00       	call   3a10 <printf>
}
    3266:	83 c4 10             	add    $0x10,%esp
    3269:	c9                   	leave  
    326a:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    326b:	83 ec 08             	sub    $0x8,%esp
    326e:	68 68 4c 00 00       	push   $0x4c68
    3273:	ff 35 28 5e 00 00    	pushl  0x5e28
    3279:	e8 92 07 00 00       	call   3a10 <printf>
      exit();
    327e:	e8 2f 06 00 00       	call   38b2 <exit>
    3283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003290 <bigargtest>:
{
    3290:	55                   	push   %ebp
    3291:	89 e5                	mov    %esp,%ebp
    3293:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    3296:	68 86 4c 00 00       	push   $0x4c86
    329b:	e8 62 06 00 00       	call   3902 <unlink>
  pid = fork();
    32a0:	e8 05 06 00 00       	call   38aa <fork>
  if(pid == 0){
    32a5:	83 c4 10             	add    $0x10,%esp
    32a8:	85 c0                	test   %eax,%eax
    32aa:	74 3f                	je     32eb <bigargtest+0x5b>
  } else if(pid < 0){
    32ac:	0f 88 c2 00 00 00    	js     3374 <bigargtest+0xe4>
  wait();
    32b2:	e8 03 06 00 00       	call   38ba <wait>
  fd = open("bigarg-ok", 0);
    32b7:	83 ec 08             	sub    $0x8,%esp
    32ba:	6a 00                	push   $0x0
    32bc:	68 86 4c 00 00       	push   $0x4c86
    32c1:	e8 2c 06 00 00       	call   38f2 <open>
  if(fd < 0){
    32c6:	83 c4 10             	add    $0x10,%esp
    32c9:	85 c0                	test   %eax,%eax
    32cb:	0f 88 8c 00 00 00    	js     335d <bigargtest+0xcd>
  close(fd);
    32d1:	83 ec 0c             	sub    $0xc,%esp
    32d4:	50                   	push   %eax
    32d5:	e8 00 06 00 00       	call   38da <close>
  unlink("bigarg-ok");
    32da:	c7 04 24 86 4c 00 00 	movl   $0x4c86,(%esp)
    32e1:	e8 1c 06 00 00       	call   3902 <unlink>
}
    32e6:	83 c4 10             	add    $0x10,%esp
    32e9:	c9                   	leave  
    32ea:	c3                   	ret    
    32eb:	b8 40 5e 00 00       	mov    $0x5e40,%eax
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    32f0:	c7 00 e0 53 00 00    	movl   $0x53e0,(%eax)
    32f6:	83 c0 04             	add    $0x4,%eax
    for(i = 0; i < MAXARG-1; i++)
    32f9:	3d bc 5e 00 00       	cmp    $0x5ebc,%eax
    32fe:	75 f0                	jne    32f0 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    3300:	51                   	push   %ecx
    3301:	51                   	push   %ecx
    3302:	68 90 4c 00 00       	push   $0x4c90
    3307:	ff 35 28 5e 00 00    	pushl  0x5e28
    args[MAXARG-1] = 0;
    330d:	c7 05 bc 5e 00 00 00 	movl   $0x0,0x5ebc
    3314:	00 00 00 
    printf(stdout, "bigarg test\n");
    3317:	e8 f4 06 00 00       	call   3a10 <printf>
    exec("echo", args);
    331c:	58                   	pop    %eax
    331d:	5a                   	pop    %edx
    331e:	68 40 5e 00 00       	push   $0x5e40
    3323:	68 4d 3e 00 00       	push   $0x3e4d
    3328:	e8 bd 05 00 00       	call   38ea <exec>
    printf(stdout, "bigarg test ok\n");
    332d:	59                   	pop    %ecx
    332e:	58                   	pop    %eax
    332f:	68 9d 4c 00 00       	push   $0x4c9d
    3334:	ff 35 28 5e 00 00    	pushl  0x5e28
    333a:	e8 d1 06 00 00       	call   3a10 <printf>
    fd = open("bigarg-ok", O_CREATE);
    333f:	58                   	pop    %eax
    3340:	5a                   	pop    %edx
    3341:	68 00 02 00 00       	push   $0x200
    3346:	68 86 4c 00 00       	push   $0x4c86
    334b:	e8 a2 05 00 00       	call   38f2 <open>
    close(fd);
    3350:	89 04 24             	mov    %eax,(%esp)
    3353:	e8 82 05 00 00       	call   38da <close>
    exit();
    3358:	e8 55 05 00 00       	call   38b2 <exit>
    printf(stdout, "bigarg test failed!\n");
    335d:	50                   	push   %eax
    335e:	50                   	push   %eax
    335f:	68 c6 4c 00 00       	push   $0x4cc6
    3364:	ff 35 28 5e 00 00    	pushl  0x5e28
    336a:	e8 a1 06 00 00       	call   3a10 <printf>
    exit();
    336f:	e8 3e 05 00 00       	call   38b2 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    3374:	52                   	push   %edx
    3375:	52                   	push   %edx
    3376:	68 ad 4c 00 00       	push   $0x4cad
    337b:	ff 35 28 5e 00 00    	pushl  0x5e28
    3381:	e8 8a 06 00 00       	call   3a10 <printf>
    exit();
    3386:	e8 27 05 00 00       	call   38b2 <exit>
    338b:	90                   	nop
    338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003390 <fsfull>:
{
    3390:	55                   	push   %ebp
    3391:	89 e5                	mov    %esp,%ebp
    3393:	57                   	push   %edi
    3394:	56                   	push   %esi
    3395:	53                   	push   %ebx
  for(nfiles = 0; ; nfiles++){
    3396:	31 db                	xor    %ebx,%ebx
{
    3398:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    339b:	68 db 4c 00 00       	push   $0x4cdb
    33a0:	6a 01                	push   $0x1
    33a2:	e8 69 06 00 00       	call   3a10 <printf>
    33a7:	83 c4 10             	add    $0x10,%esp
    33aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    33b0:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    33b5:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    33ba:	83 ec 04             	sub    $0x4,%esp
    name[1] = '0' + nfiles / 1000;
    33bd:	f7 e3                	mul    %ebx
    name[0] = 'f';
    33bf:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[5] = '\0';
    33c3:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    33c7:	c1 ea 06             	shr    $0x6,%edx
    33ca:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    33cd:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    33d3:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    33d6:	89 d8                	mov    %ebx,%eax
    33d8:	29 d0                	sub    %edx,%eax
    33da:	89 c2                	mov    %eax,%edx
    33dc:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    33e1:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    33e3:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    33e8:	c1 ea 05             	shr    $0x5,%edx
    33eb:	83 c2 30             	add    $0x30,%edx
    33ee:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    33f1:	f7 e3                	mul    %ebx
    33f3:	89 d8                	mov    %ebx,%eax
    33f5:	c1 ea 05             	shr    $0x5,%edx
    33f8:	6b d2 64             	imul   $0x64,%edx,%edx
    33fb:	29 d0                	sub    %edx,%eax
    33fd:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    33ff:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3401:	c1 ea 03             	shr    $0x3,%edx
    3404:	83 c2 30             	add    $0x30,%edx
    3407:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    340a:	f7 e1                	mul    %ecx
    340c:	89 d9                	mov    %ebx,%ecx
    340e:	c1 ea 03             	shr    $0x3,%edx
    3411:	8d 04 92             	lea    (%edx,%edx,4),%eax
    3414:	01 c0                	add    %eax,%eax
    3416:	29 c1                	sub    %eax,%ecx
    3418:	89 c8                	mov    %ecx,%eax
    341a:	83 c0 30             	add    $0x30,%eax
    341d:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    3420:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3423:	50                   	push   %eax
    3424:	68 e8 4c 00 00       	push   $0x4ce8
    3429:	6a 01                	push   $0x1
    342b:	e8 e0 05 00 00       	call   3a10 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3430:	58                   	pop    %eax
    3431:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3434:	5a                   	pop    %edx
    3435:	68 02 02 00 00       	push   $0x202
    343a:	50                   	push   %eax
    343b:	e8 b2 04 00 00       	call   38f2 <open>
    if(fd < 0){
    3440:	83 c4 10             	add    $0x10,%esp
    3443:	85 c0                	test   %eax,%eax
    int fd = open(name, O_CREATE|O_RDWR);
    3445:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    3447:	78 57                	js     34a0 <fsfull+0x110>
    int total = 0;
    3449:	31 f6                	xor    %esi,%esi
    344b:	eb 05                	jmp    3452 <fsfull+0xc2>
    344d:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    3450:	01 c6                	add    %eax,%esi
      int cc = write(fd, buf, 512);
    3452:	83 ec 04             	sub    $0x4,%esp
    3455:	68 00 02 00 00       	push   $0x200
    345a:	68 00 86 00 00       	push   $0x8600
    345f:	57                   	push   %edi
    3460:	e8 6d 04 00 00       	call   38d2 <write>
      if(cc < 512)
    3465:	83 c4 10             	add    $0x10,%esp
    3468:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    346d:	7f e1                	jg     3450 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    346f:	83 ec 04             	sub    $0x4,%esp
    3472:	56                   	push   %esi
    3473:	68 04 4d 00 00       	push   $0x4d04
    3478:	6a 01                	push   $0x1
    347a:	e8 91 05 00 00       	call   3a10 <printf>
    close(fd);
    347f:	89 3c 24             	mov    %edi,(%esp)
    3482:	e8 53 04 00 00       	call   38da <close>
    if(total == 0)
    3487:	83 c4 10             	add    $0x10,%esp
    348a:	85 f6                	test   %esi,%esi
    348c:	74 28                	je     34b6 <fsfull+0x126>
  for(nfiles = 0; ; nfiles++){
    348e:	83 c3 01             	add    $0x1,%ebx
    3491:	e9 1a ff ff ff       	jmp    33b0 <fsfull+0x20>
    3496:	8d 76 00             	lea    0x0(%esi),%esi
    3499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      printf(1, "open %s failed\n", name);
    34a0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34a3:	83 ec 04             	sub    $0x4,%esp
    34a6:	50                   	push   %eax
    34a7:	68 f4 4c 00 00       	push   $0x4cf4
    34ac:	6a 01                	push   $0x1
    34ae:	e8 5d 05 00 00       	call   3a10 <printf>
      break;
    34b3:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    34b6:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    34bb:	be 1f 85 eb 51       	mov    $0x51eb851f,%esi
    name[1] = '0' + nfiles / 1000;
    34c0:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    34c2:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    unlink(name);
    34c7:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + nfiles / 1000;
    34ca:	f7 e7                	mul    %edi
    name[0] = 'f';
    34cc:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[5] = '\0';
    34d0:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    34d4:	c1 ea 06             	shr    $0x6,%edx
    34d7:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    34da:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    34e0:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    34e3:	89 d8                	mov    %ebx,%eax
    34e5:	29 d0                	sub    %edx,%eax
    34e7:	f7 e6                	mul    %esi
    name[3] = '0' + (nfiles % 100) / 10;
    34e9:	89 d8                	mov    %ebx,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    34eb:	c1 ea 05             	shr    $0x5,%edx
    34ee:	83 c2 30             	add    $0x30,%edx
    34f1:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    34f4:	f7 e6                	mul    %esi
    34f6:	89 d8                	mov    %ebx,%eax
    34f8:	c1 ea 05             	shr    $0x5,%edx
    34fb:	6b d2 64             	imul   $0x64,%edx,%edx
    34fe:	29 d0                	sub    %edx,%eax
    3500:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    3502:	89 d8                	mov    %ebx,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3504:	c1 ea 03             	shr    $0x3,%edx
    3507:	83 c2 30             	add    $0x30,%edx
    350a:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    350d:	f7 e1                	mul    %ecx
    350f:	89 d9                	mov    %ebx,%ecx
    nfiles--;
    3511:	83 eb 01             	sub    $0x1,%ebx
    name[4] = '0' + (nfiles % 10);
    3514:	c1 ea 03             	shr    $0x3,%edx
    3517:	8d 04 92             	lea    (%edx,%edx,4),%eax
    351a:	01 c0                	add    %eax,%eax
    351c:	29 c1                	sub    %eax,%ecx
    351e:	89 c8                	mov    %ecx,%eax
    3520:	83 c0 30             	add    $0x30,%eax
    3523:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    3526:	8d 45 a8             	lea    -0x58(%ebp),%eax
    3529:	50                   	push   %eax
    352a:	e8 d3 03 00 00       	call   3902 <unlink>
  while(nfiles >= 0){
    352f:	83 c4 10             	add    $0x10,%esp
    3532:	83 fb ff             	cmp    $0xffffffff,%ebx
    3535:	75 89                	jne    34c0 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    3537:	83 ec 08             	sub    $0x8,%esp
    353a:	68 14 4d 00 00       	push   $0x4d14
    353f:	6a 01                	push   $0x1
    3541:	e8 ca 04 00 00       	call   3a10 <printf>
}
    3546:	83 c4 10             	add    $0x10,%esp
    3549:	8d 65 f4             	lea    -0xc(%ebp),%esp
    354c:	5b                   	pop    %ebx
    354d:	5e                   	pop    %esi
    354e:	5f                   	pop    %edi
    354f:	5d                   	pop    %ebp
    3550:	c3                   	ret    
    3551:	eb 0d                	jmp    3560 <uio>
    3553:	90                   	nop
    3554:	90                   	nop
    3555:	90                   	nop
    3556:	90                   	nop
    3557:	90                   	nop
    3558:	90                   	nop
    3559:	90                   	nop
    355a:	90                   	nop
    355b:	90                   	nop
    355c:	90                   	nop
    355d:	90                   	nop
    355e:	90                   	nop
    355f:	90                   	nop

00003560 <uio>:
{
    3560:	55                   	push   %ebp
    3561:	89 e5                	mov    %esp,%ebp
    3563:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    3566:	68 2a 4d 00 00       	push   $0x4d2a
    356b:	6a 01                	push   $0x1
    356d:	e8 9e 04 00 00       	call   3a10 <printf>
  pid = fork();
    3572:	e8 33 03 00 00       	call   38aa <fork>
  if(pid == 0){
    3577:	83 c4 10             	add    $0x10,%esp
    357a:	85 c0                	test   %eax,%eax
    357c:	74 1b                	je     3599 <uio+0x39>
  } else if(pid < 0){
    357e:	78 3d                	js     35bd <uio+0x5d>
  wait();
    3580:	e8 35 03 00 00       	call   38ba <wait>
  printf(1, "uio test done\n");
    3585:	83 ec 08             	sub    $0x8,%esp
    3588:	68 34 4d 00 00       	push   $0x4d34
    358d:	6a 01                	push   $0x1
    358f:	e8 7c 04 00 00       	call   3a10 <printf>
}
    3594:	83 c4 10             	add    $0x10,%esp
    3597:	c9                   	leave  
    3598:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    3599:	b8 09 00 00 00       	mov    $0x9,%eax
    359e:	ba 70 00 00 00       	mov    $0x70,%edx
    35a3:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    35a4:	ba 71 00 00 00       	mov    $0x71,%edx
    35a9:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    35aa:	52                   	push   %edx
    35ab:	52                   	push   %edx
    35ac:	68 c0 54 00 00       	push   $0x54c0
    35b1:	6a 01                	push   $0x1
    35b3:	e8 58 04 00 00       	call   3a10 <printf>
    exit();
    35b8:	e8 f5 02 00 00       	call   38b2 <exit>
    printf (1, "fork failed\n");
    35bd:	50                   	push   %eax
    35be:	50                   	push   %eax
    35bf:	68 b9 4c 00 00       	push   $0x4cb9
    35c4:	6a 01                	push   $0x1
    35c6:	e8 45 04 00 00       	call   3a10 <printf>
    exit();
    35cb:	e8 e2 02 00 00       	call   38b2 <exit>

000035d0 <argptest>:
{
    35d0:	55                   	push   %ebp
    35d1:	89 e5                	mov    %esp,%ebp
    35d3:	53                   	push   %ebx
    35d4:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    35d7:	6a 00                	push   $0x0
    35d9:	68 43 4d 00 00       	push   $0x4d43
    35de:	e8 0f 03 00 00       	call   38f2 <open>
  if (fd < 0) {
    35e3:	83 c4 10             	add    $0x10,%esp
    35e6:	85 c0                	test   %eax,%eax
    35e8:	78 39                	js     3623 <argptest+0x53>
  read(fd, sbrk(0) - 1, -1);
    35ea:	83 ec 0c             	sub    $0xc,%esp
    35ed:	89 c3                	mov    %eax,%ebx
    35ef:	6a 00                	push   $0x0
    35f1:	e8 44 03 00 00       	call   393a <sbrk>
    35f6:	83 c4 0c             	add    $0xc,%esp
    35f9:	83 e8 01             	sub    $0x1,%eax
    35fc:	6a ff                	push   $0xffffffff
    35fe:	50                   	push   %eax
    35ff:	53                   	push   %ebx
    3600:	e8 c5 02 00 00       	call   38ca <read>
  close(fd);
    3605:	89 1c 24             	mov    %ebx,(%esp)
    3608:	e8 cd 02 00 00       	call   38da <close>
  printf(1, "arg test passed\n");
    360d:	58                   	pop    %eax
    360e:	5a                   	pop    %edx
    360f:	68 55 4d 00 00       	push   $0x4d55
    3614:	6a 01                	push   $0x1
    3616:	e8 f5 03 00 00       	call   3a10 <printf>
}
    361b:	83 c4 10             	add    $0x10,%esp
    361e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3621:	c9                   	leave  
    3622:	c3                   	ret    
    printf(2, "open failed\n");
    3623:	51                   	push   %ecx
    3624:	51                   	push   %ecx
    3625:	68 48 4d 00 00       	push   $0x4d48
    362a:	6a 02                	push   $0x2
    362c:	e8 df 03 00 00       	call   3a10 <printf>
    exit();
    3631:	e8 7c 02 00 00       	call   38b2 <exit>
    3636:	8d 76 00             	lea    0x0(%esi),%esi
    3639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003640 <rand>:
  randstate = randstate * 1664525 + 1013904223;
    3640:	69 05 24 5e 00 00 0d 	imul   $0x19660d,0x5e24,%eax
    3647:	66 19 00 
{
    364a:	55                   	push   %ebp
    364b:	89 e5                	mov    %esp,%ebp
}
    364d:	5d                   	pop    %ebp
  randstate = randstate * 1664525 + 1013904223;
    364e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3653:	a3 24 5e 00 00       	mov    %eax,0x5e24
}
    3658:	c3                   	ret    
    3659:	66 90                	xchg   %ax,%ax
    365b:	66 90                	xchg   %ax,%ax
    365d:	66 90                	xchg   %ax,%ax
    365f:	90                   	nop

00003660 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3660:	55                   	push   %ebp
    3661:	89 e5                	mov    %esp,%ebp
    3663:	53                   	push   %ebx
    3664:	8b 45 08             	mov    0x8(%ebp),%eax
    3667:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    366a:	89 c2                	mov    %eax,%edx
    366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3670:	83 c1 01             	add    $0x1,%ecx
    3673:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
    3677:	83 c2 01             	add    $0x1,%edx
    367a:	84 db                	test   %bl,%bl
    367c:	88 5a ff             	mov    %bl,-0x1(%edx)
    367f:	75 ef                	jne    3670 <strcpy+0x10>
    ;
  return os;
}
    3681:	5b                   	pop    %ebx
    3682:	5d                   	pop    %ebp
    3683:	c3                   	ret    
    3684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    368a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00003690 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3690:	55                   	push   %ebp
    3691:	89 e5                	mov    %esp,%ebp
    3693:	53                   	push   %ebx
    3694:	8b 55 08             	mov    0x8(%ebp),%edx
    3697:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
    369a:	0f b6 02             	movzbl (%edx),%eax
    369d:	0f b6 19             	movzbl (%ecx),%ebx
    36a0:	84 c0                	test   %al,%al
    36a2:	75 1c                	jne    36c0 <strcmp+0x30>
    36a4:	eb 2a                	jmp    36d0 <strcmp+0x40>
    36a6:	8d 76 00             	lea    0x0(%esi),%esi
    36a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
    36b0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    36b3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
    36b6:	83 c1 01             	add    $0x1,%ecx
    36b9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
    36bc:	84 c0                	test   %al,%al
    36be:	74 10                	je     36d0 <strcmp+0x40>
    36c0:	38 d8                	cmp    %bl,%al
    36c2:	74 ec                	je     36b0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    36c4:	29 d8                	sub    %ebx,%eax
}
    36c6:	5b                   	pop    %ebx
    36c7:	5d                   	pop    %ebp
    36c8:	c3                   	ret    
    36c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    36d0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    36d2:	29 d8                	sub    %ebx,%eax
}
    36d4:	5b                   	pop    %ebx
    36d5:	5d                   	pop    %ebp
    36d6:	c3                   	ret    
    36d7:	89 f6                	mov    %esi,%esi
    36d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000036e0 <strlen>:

uint
strlen(const char *s)
{
    36e0:	55                   	push   %ebp
    36e1:	89 e5                	mov    %esp,%ebp
    36e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    36e6:	80 39 00             	cmpb   $0x0,(%ecx)
    36e9:	74 15                	je     3700 <strlen+0x20>
    36eb:	31 d2                	xor    %edx,%edx
    36ed:	8d 76 00             	lea    0x0(%esi),%esi
    36f0:	83 c2 01             	add    $0x1,%edx
    36f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    36f7:	89 d0                	mov    %edx,%eax
    36f9:	75 f5                	jne    36f0 <strlen+0x10>
    ;
  return n;
}
    36fb:	5d                   	pop    %ebp
    36fc:	c3                   	ret    
    36fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
    3700:	31 c0                	xor    %eax,%eax
}
    3702:	5d                   	pop    %ebp
    3703:	c3                   	ret    
    3704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00003710 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3710:	55                   	push   %ebp
    3711:	89 e5                	mov    %esp,%ebp
    3713:	57                   	push   %edi
    3714:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3717:	8b 4d 10             	mov    0x10(%ebp),%ecx
    371a:	8b 45 0c             	mov    0xc(%ebp),%eax
    371d:	89 d7                	mov    %edx,%edi
    371f:	fc                   	cld    
    3720:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3722:	89 d0                	mov    %edx,%eax
    3724:	5f                   	pop    %edi
    3725:	5d                   	pop    %ebp
    3726:	c3                   	ret    
    3727:	89 f6                	mov    %esi,%esi
    3729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003730 <strchr>:

char*
strchr(const char *s, char c)
{
    3730:	55                   	push   %ebp
    3731:	89 e5                	mov    %esp,%ebp
    3733:	53                   	push   %ebx
    3734:	8b 45 08             	mov    0x8(%ebp),%eax
    3737:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
    373a:	0f b6 10             	movzbl (%eax),%edx
    373d:	84 d2                	test   %dl,%dl
    373f:	74 1d                	je     375e <strchr+0x2e>
    if(*s == c)
    3741:	38 d3                	cmp    %dl,%bl
    3743:	89 d9                	mov    %ebx,%ecx
    3745:	75 0d                	jne    3754 <strchr+0x24>
    3747:	eb 17                	jmp    3760 <strchr+0x30>
    3749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3750:	38 ca                	cmp    %cl,%dl
    3752:	74 0c                	je     3760 <strchr+0x30>
  for(; *s; s++)
    3754:	83 c0 01             	add    $0x1,%eax
    3757:	0f b6 10             	movzbl (%eax),%edx
    375a:	84 d2                	test   %dl,%dl
    375c:	75 f2                	jne    3750 <strchr+0x20>
      return (char*)s;
  return 0;
    375e:	31 c0                	xor    %eax,%eax
}
    3760:	5b                   	pop    %ebx
    3761:	5d                   	pop    %ebp
    3762:	c3                   	ret    
    3763:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003770 <gets>:

char*
gets(char *buf, int max)
{
    3770:	55                   	push   %ebp
    3771:	89 e5                	mov    %esp,%ebp
    3773:	57                   	push   %edi
    3774:	56                   	push   %esi
    3775:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3776:	31 f6                	xor    %esi,%esi
    3778:	89 f3                	mov    %esi,%ebx
{
    377a:	83 ec 1c             	sub    $0x1c,%esp
    377d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    3780:	eb 2f                	jmp    37b1 <gets+0x41>
    3782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    3788:	8d 45 e7             	lea    -0x19(%ebp),%eax
    378b:	83 ec 04             	sub    $0x4,%esp
    378e:	6a 01                	push   $0x1
    3790:	50                   	push   %eax
    3791:	6a 00                	push   $0x0
    3793:	e8 32 01 00 00       	call   38ca <read>
    if(cc < 1)
    3798:	83 c4 10             	add    $0x10,%esp
    379b:	85 c0                	test   %eax,%eax
    379d:	7e 1c                	jle    37bb <gets+0x4b>
      break;
    buf[i++] = c;
    379f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    37a3:	83 c7 01             	add    $0x1,%edi
    37a6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    37a9:	3c 0a                	cmp    $0xa,%al
    37ab:	74 23                	je     37d0 <gets+0x60>
    37ad:	3c 0d                	cmp    $0xd,%al
    37af:	74 1f                	je     37d0 <gets+0x60>
  for(i=0; i+1 < max; ){
    37b1:	83 c3 01             	add    $0x1,%ebx
    37b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    37b7:	89 fe                	mov    %edi,%esi
    37b9:	7c cd                	jl     3788 <gets+0x18>
    37bb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    37bd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    37c0:	c6 03 00             	movb   $0x0,(%ebx)
}
    37c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    37c6:	5b                   	pop    %ebx
    37c7:	5e                   	pop    %esi
    37c8:	5f                   	pop    %edi
    37c9:	5d                   	pop    %ebp
    37ca:	c3                   	ret    
    37cb:	90                   	nop
    37cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    37d0:	8b 75 08             	mov    0x8(%ebp),%esi
    37d3:	8b 45 08             	mov    0x8(%ebp),%eax
    37d6:	01 de                	add    %ebx,%esi
    37d8:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    37da:	c6 03 00             	movb   $0x0,(%ebx)
}
    37dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    37e0:	5b                   	pop    %ebx
    37e1:	5e                   	pop    %esi
    37e2:	5f                   	pop    %edi
    37e3:	5d                   	pop    %ebp
    37e4:	c3                   	ret    
    37e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    37e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000037f0 <stat>:

int
stat(const char *n, struct stat *st)
{
    37f0:	55                   	push   %ebp
    37f1:	89 e5                	mov    %esp,%ebp
    37f3:	56                   	push   %esi
    37f4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    37f5:	83 ec 08             	sub    $0x8,%esp
    37f8:	6a 00                	push   $0x0
    37fa:	ff 75 08             	pushl  0x8(%ebp)
    37fd:	e8 f0 00 00 00       	call   38f2 <open>
  if(fd < 0)
    3802:	83 c4 10             	add    $0x10,%esp
    3805:	85 c0                	test   %eax,%eax
    3807:	78 27                	js     3830 <stat+0x40>
    return -1;
  r = fstat(fd, st);
    3809:	83 ec 08             	sub    $0x8,%esp
    380c:	ff 75 0c             	pushl  0xc(%ebp)
    380f:	89 c3                	mov    %eax,%ebx
    3811:	50                   	push   %eax
    3812:	e8 f3 00 00 00       	call   390a <fstat>
  close(fd);
    3817:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    381a:	89 c6                	mov    %eax,%esi
  close(fd);
    381c:	e8 b9 00 00 00       	call   38da <close>
  return r;
    3821:	83 c4 10             	add    $0x10,%esp
}
    3824:	8d 65 f8             	lea    -0x8(%ebp),%esp
    3827:	89 f0                	mov    %esi,%eax
    3829:	5b                   	pop    %ebx
    382a:	5e                   	pop    %esi
    382b:	5d                   	pop    %ebp
    382c:	c3                   	ret    
    382d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
    3830:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3835:	eb ed                	jmp    3824 <stat+0x34>
    3837:	89 f6                	mov    %esi,%esi
    3839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00003840 <atoi>:

int
atoi(const char *s)
{
    3840:	55                   	push   %ebp
    3841:	89 e5                	mov    %esp,%ebp
    3843:	53                   	push   %ebx
    3844:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    3847:	0f be 11             	movsbl (%ecx),%edx
    384a:	8d 42 d0             	lea    -0x30(%edx),%eax
    384d:	3c 09                	cmp    $0x9,%al
  n = 0;
    384f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    3854:	77 1f                	ja     3875 <atoi+0x35>
    3856:	8d 76 00             	lea    0x0(%esi),%esi
    3859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    3860:	8d 04 80             	lea    (%eax,%eax,4),%eax
    3863:	83 c1 01             	add    $0x1,%ecx
    3866:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    386a:	0f be 11             	movsbl (%ecx),%edx
    386d:	8d 5a d0             	lea    -0x30(%edx),%ebx
    3870:	80 fb 09             	cmp    $0x9,%bl
    3873:	76 eb                	jbe    3860 <atoi+0x20>
  return n;
}
    3875:	5b                   	pop    %ebx
    3876:	5d                   	pop    %ebp
    3877:	c3                   	ret    
    3878:	90                   	nop
    3879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00003880 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3880:	55                   	push   %ebp
    3881:	89 e5                	mov    %esp,%ebp
    3883:	56                   	push   %esi
    3884:	53                   	push   %ebx
    3885:	8b 5d 10             	mov    0x10(%ebp),%ebx
    3888:	8b 45 08             	mov    0x8(%ebp),%eax
    388b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    388e:	85 db                	test   %ebx,%ebx
    3890:	7e 14                	jle    38a6 <memmove+0x26>
    3892:	31 d2                	xor    %edx,%edx
    3894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
    3898:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    389c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    389f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
    38a2:	39 d3                	cmp    %edx,%ebx
    38a4:	75 f2                	jne    3898 <memmove+0x18>
  return vdst;
}
    38a6:	5b                   	pop    %ebx
    38a7:	5e                   	pop    %esi
    38a8:	5d                   	pop    %ebp
    38a9:	c3                   	ret    

000038aa <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    38aa:	b8 01 00 00 00       	mov    $0x1,%eax
    38af:	cd 40                	int    $0x40
    38b1:	c3                   	ret    

000038b2 <exit>:
SYSCALL(exit)
    38b2:	b8 02 00 00 00       	mov    $0x2,%eax
    38b7:	cd 40                	int    $0x40
    38b9:	c3                   	ret    

000038ba <wait>:
SYSCALL(wait)
    38ba:	b8 03 00 00 00       	mov    $0x3,%eax
    38bf:	cd 40                	int    $0x40
    38c1:	c3                   	ret    

000038c2 <pipe>:
SYSCALL(pipe)
    38c2:	b8 04 00 00 00       	mov    $0x4,%eax
    38c7:	cd 40                	int    $0x40
    38c9:	c3                   	ret    

000038ca <read>:
SYSCALL(read)
    38ca:	b8 05 00 00 00       	mov    $0x5,%eax
    38cf:	cd 40                	int    $0x40
    38d1:	c3                   	ret    

000038d2 <write>:
SYSCALL(write)
    38d2:	b8 10 00 00 00       	mov    $0x10,%eax
    38d7:	cd 40                	int    $0x40
    38d9:	c3                   	ret    

000038da <close>:
SYSCALL(close)
    38da:	b8 15 00 00 00       	mov    $0x15,%eax
    38df:	cd 40                	int    $0x40
    38e1:	c3                   	ret    

000038e2 <kill>:
SYSCALL(kill)
    38e2:	b8 06 00 00 00       	mov    $0x6,%eax
    38e7:	cd 40                	int    $0x40
    38e9:	c3                   	ret    

000038ea <exec>:
SYSCALL(exec)
    38ea:	b8 07 00 00 00       	mov    $0x7,%eax
    38ef:	cd 40                	int    $0x40
    38f1:	c3                   	ret    

000038f2 <open>:
SYSCALL(open)
    38f2:	b8 0f 00 00 00       	mov    $0xf,%eax
    38f7:	cd 40                	int    $0x40
    38f9:	c3                   	ret    

000038fa <mknod>:
SYSCALL(mknod)
    38fa:	b8 11 00 00 00       	mov    $0x11,%eax
    38ff:	cd 40                	int    $0x40
    3901:	c3                   	ret    

00003902 <unlink>:
SYSCALL(unlink)
    3902:	b8 12 00 00 00       	mov    $0x12,%eax
    3907:	cd 40                	int    $0x40
    3909:	c3                   	ret    

0000390a <fstat>:
SYSCALL(fstat)
    390a:	b8 08 00 00 00       	mov    $0x8,%eax
    390f:	cd 40                	int    $0x40
    3911:	c3                   	ret    

00003912 <link>:
SYSCALL(link)
    3912:	b8 13 00 00 00       	mov    $0x13,%eax
    3917:	cd 40                	int    $0x40
    3919:	c3                   	ret    

0000391a <mkdir>:
SYSCALL(mkdir)
    391a:	b8 14 00 00 00       	mov    $0x14,%eax
    391f:	cd 40                	int    $0x40
    3921:	c3                   	ret    

00003922 <chdir>:
SYSCALL(chdir)
    3922:	b8 09 00 00 00       	mov    $0x9,%eax
    3927:	cd 40                	int    $0x40
    3929:	c3                   	ret    

0000392a <dup>:
SYSCALL(dup)
    392a:	b8 0a 00 00 00       	mov    $0xa,%eax
    392f:	cd 40                	int    $0x40
    3931:	c3                   	ret    

00003932 <getpid>:
SYSCALL(getpid)
    3932:	b8 0b 00 00 00       	mov    $0xb,%eax
    3937:	cd 40                	int    $0x40
    3939:	c3                   	ret    

0000393a <sbrk>:
SYSCALL(sbrk)
    393a:	b8 0c 00 00 00       	mov    $0xc,%eax
    393f:	cd 40                	int    $0x40
    3941:	c3                   	ret    

00003942 <sleep>:
SYSCALL(sleep)
    3942:	b8 0d 00 00 00       	mov    $0xd,%eax
    3947:	cd 40                	int    $0x40
    3949:	c3                   	ret    

0000394a <uptime>:
SYSCALL(uptime)
    394a:	b8 0e 00 00 00       	mov    $0xe,%eax
    394f:	cd 40                	int    $0x40
    3951:	c3                   	ret    

00003952 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
    3952:	b8 16 00 00 00       	mov    $0x16,%eax
    3957:	cd 40                	int    $0x40
    3959:	c3                   	ret    

0000395a <getTotalFreePages>:
SYSCALL(getTotalFreePages)
    395a:	b8 17 00 00 00       	mov    $0x17,%eax
    395f:	cd 40                	int    $0x40
    3961:	c3                   	ret    
    3962:	66 90                	xchg   %ax,%ax
    3964:	66 90                	xchg   %ax,%ax
    3966:	66 90                	xchg   %ax,%ax
    3968:	66 90                	xchg   %ax,%ax
    396a:	66 90                	xchg   %ax,%ax
    396c:	66 90                	xchg   %ax,%ax
    396e:	66 90                	xchg   %ax,%ax

00003970 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3970:	55                   	push   %ebp
    3971:	89 e5                	mov    %esp,%ebp
    3973:	57                   	push   %edi
    3974:	56                   	push   %esi
    3975:	53                   	push   %ebx
    3976:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    3979:	85 d2                	test   %edx,%edx
{
    397b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
    397e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    3980:	79 76                	jns    39f8 <printint+0x88>
    3982:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    3986:	74 70                	je     39f8 <printint+0x88>
    x = -xx;
    3988:	f7 d8                	neg    %eax
    neg = 1;
    398a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    3991:	31 f6                	xor    %esi,%esi
    3993:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    3996:	eb 0a                	jmp    39a2 <printint+0x32>
    3998:	90                   	nop
    3999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
    39a0:	89 fe                	mov    %edi,%esi
    39a2:	31 d2                	xor    %edx,%edx
    39a4:	8d 7e 01             	lea    0x1(%esi),%edi
    39a7:	f7 f1                	div    %ecx
    39a9:	0f b6 92 18 55 00 00 	movzbl 0x5518(%edx),%edx
  }while((x /= base) != 0);
    39b0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    39b2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    39b5:	75 e9                	jne    39a0 <printint+0x30>
  if(neg)
    39b7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
    39ba:	85 c0                	test   %eax,%eax
    39bc:	74 08                	je     39c6 <printint+0x56>
    buf[i++] = '-';
    39be:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    39c3:	8d 7e 02             	lea    0x2(%esi),%edi
    39c6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    39ca:	8b 7d c0             	mov    -0x40(%ebp),%edi
    39cd:	8d 76 00             	lea    0x0(%esi),%esi
    39d0:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
    39d3:	83 ec 04             	sub    $0x4,%esp
    39d6:	83 ee 01             	sub    $0x1,%esi
    39d9:	6a 01                	push   $0x1
    39db:	53                   	push   %ebx
    39dc:	57                   	push   %edi
    39dd:	88 45 d7             	mov    %al,-0x29(%ebp)
    39e0:	e8 ed fe ff ff       	call   38d2 <write>

  while(--i >= 0)
    39e5:	83 c4 10             	add    $0x10,%esp
    39e8:	39 de                	cmp    %ebx,%esi
    39ea:	75 e4                	jne    39d0 <printint+0x60>
    putc(fd, buf[i]);
}
    39ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    39ef:	5b                   	pop    %ebx
    39f0:	5e                   	pop    %esi
    39f1:	5f                   	pop    %edi
    39f2:	5d                   	pop    %ebp
    39f3:	c3                   	ret    
    39f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    39f8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    39ff:	eb 90                	jmp    3991 <printint+0x21>
    3a01:	eb 0d                	jmp    3a10 <printf>
    3a03:	90                   	nop
    3a04:	90                   	nop
    3a05:	90                   	nop
    3a06:	90                   	nop
    3a07:	90                   	nop
    3a08:	90                   	nop
    3a09:	90                   	nop
    3a0a:	90                   	nop
    3a0b:	90                   	nop
    3a0c:	90                   	nop
    3a0d:	90                   	nop
    3a0e:	90                   	nop
    3a0f:	90                   	nop

00003a10 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3a10:	55                   	push   %ebp
    3a11:	89 e5                	mov    %esp,%ebp
    3a13:	57                   	push   %edi
    3a14:	56                   	push   %esi
    3a15:	53                   	push   %ebx
    3a16:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3a19:	8b 75 0c             	mov    0xc(%ebp),%esi
    3a1c:	0f b6 1e             	movzbl (%esi),%ebx
    3a1f:	84 db                	test   %bl,%bl
    3a21:	0f 84 b3 00 00 00    	je     3ada <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
    3a27:	8d 45 10             	lea    0x10(%ebp),%eax
    3a2a:	83 c6 01             	add    $0x1,%esi
  state = 0;
    3a2d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
    3a2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3a32:	eb 2f                	jmp    3a63 <printf+0x53>
    3a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    3a38:	83 f8 25             	cmp    $0x25,%eax
    3a3b:	0f 84 a7 00 00 00    	je     3ae8 <printf+0xd8>
  write(fd, &c, 1);
    3a41:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    3a44:	83 ec 04             	sub    $0x4,%esp
    3a47:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    3a4a:	6a 01                	push   $0x1
    3a4c:	50                   	push   %eax
    3a4d:	ff 75 08             	pushl  0x8(%ebp)
    3a50:	e8 7d fe ff ff       	call   38d2 <write>
    3a55:	83 c4 10             	add    $0x10,%esp
    3a58:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
    3a5b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    3a5f:	84 db                	test   %bl,%bl
    3a61:	74 77                	je     3ada <printf+0xca>
    if(state == 0){
    3a63:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
    3a65:	0f be cb             	movsbl %bl,%ecx
    3a68:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3a6b:	74 cb                	je     3a38 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    3a6d:	83 ff 25             	cmp    $0x25,%edi
    3a70:	75 e6                	jne    3a58 <printf+0x48>
      if(c == 'd'){
    3a72:	83 f8 64             	cmp    $0x64,%eax
    3a75:	0f 84 05 01 00 00    	je     3b80 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3a7b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    3a81:	83 f9 70             	cmp    $0x70,%ecx
    3a84:	74 72                	je     3af8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3a86:	83 f8 73             	cmp    $0x73,%eax
    3a89:	0f 84 99 00 00 00    	je     3b28 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3a8f:	83 f8 63             	cmp    $0x63,%eax
    3a92:	0f 84 08 01 00 00    	je     3ba0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3a98:	83 f8 25             	cmp    $0x25,%eax
    3a9b:	0f 84 ef 00 00 00    	je     3b90 <printf+0x180>
  write(fd, &c, 1);
    3aa1:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3aa4:	83 ec 04             	sub    $0x4,%esp
    3aa7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3aab:	6a 01                	push   $0x1
    3aad:	50                   	push   %eax
    3aae:	ff 75 08             	pushl  0x8(%ebp)
    3ab1:	e8 1c fe ff ff       	call   38d2 <write>
    3ab6:	83 c4 0c             	add    $0xc,%esp
    3ab9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    3abc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    3abf:	6a 01                	push   $0x1
    3ac1:	50                   	push   %eax
    3ac2:	ff 75 08             	pushl  0x8(%ebp)
    3ac5:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    3ac8:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
    3aca:	e8 03 fe ff ff       	call   38d2 <write>
  for(i = 0; fmt[i]; i++){
    3acf:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
    3ad3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    3ad6:	84 db                	test   %bl,%bl
    3ad8:	75 89                	jne    3a63 <printf+0x53>
    }
  }
}
    3ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3add:	5b                   	pop    %ebx
    3ade:	5e                   	pop    %esi
    3adf:	5f                   	pop    %edi
    3ae0:	5d                   	pop    %ebp
    3ae1:	c3                   	ret    
    3ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
    3ae8:	bf 25 00 00 00       	mov    $0x25,%edi
    3aed:	e9 66 ff ff ff       	jmp    3a58 <printf+0x48>
    3af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    3af8:	83 ec 0c             	sub    $0xc,%esp
    3afb:	b9 10 00 00 00       	mov    $0x10,%ecx
    3b00:	6a 00                	push   $0x0
    3b02:	8b 7d d4             	mov    -0x2c(%ebp),%edi
    3b05:	8b 45 08             	mov    0x8(%ebp),%eax
    3b08:	8b 17                	mov    (%edi),%edx
    3b0a:	e8 61 fe ff ff       	call   3970 <printint>
        ap++;
    3b0f:	89 f8                	mov    %edi,%eax
    3b11:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3b14:	31 ff                	xor    %edi,%edi
        ap++;
    3b16:	83 c0 04             	add    $0x4,%eax
    3b19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    3b1c:	e9 37 ff ff ff       	jmp    3a58 <printf+0x48>
    3b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    3b28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    3b2b:	8b 08                	mov    (%eax),%ecx
        ap++;
    3b2d:	83 c0 04             	add    $0x4,%eax
    3b30:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
    3b33:	85 c9                	test   %ecx,%ecx
    3b35:	0f 84 8e 00 00 00    	je     3bc9 <printf+0x1b9>
        while(*s != 0){
    3b3b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
    3b3e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
    3b40:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
    3b42:	84 c0                	test   %al,%al
    3b44:	0f 84 0e ff ff ff    	je     3a58 <printf+0x48>
    3b4a:	89 75 d0             	mov    %esi,-0x30(%ebp)
    3b4d:	89 de                	mov    %ebx,%esi
    3b4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3b52:	8d 7d e3             	lea    -0x1d(%ebp),%edi
    3b55:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    3b58:	83 ec 04             	sub    $0x4,%esp
          s++;
    3b5b:	83 c6 01             	add    $0x1,%esi
    3b5e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    3b61:	6a 01                	push   $0x1
    3b63:	57                   	push   %edi
    3b64:	53                   	push   %ebx
    3b65:	e8 68 fd ff ff       	call   38d2 <write>
        while(*s != 0){
    3b6a:	0f b6 06             	movzbl (%esi),%eax
    3b6d:	83 c4 10             	add    $0x10,%esp
    3b70:	84 c0                	test   %al,%al
    3b72:	75 e4                	jne    3b58 <printf+0x148>
    3b74:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
    3b77:	31 ff                	xor    %edi,%edi
    3b79:	e9 da fe ff ff       	jmp    3a58 <printf+0x48>
    3b7e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
    3b80:	83 ec 0c             	sub    $0xc,%esp
    3b83:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3b88:	6a 01                	push   $0x1
    3b8a:	e9 73 ff ff ff       	jmp    3b02 <printf+0xf2>
    3b8f:	90                   	nop
  write(fd, &c, 1);
    3b90:	83 ec 04             	sub    $0x4,%esp
    3b93:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    3b96:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    3b99:	6a 01                	push   $0x1
    3b9b:	e9 21 ff ff ff       	jmp    3ac1 <printf+0xb1>
        putc(fd, *ap);
    3ba0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
    3ba3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3ba6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
    3ba8:	6a 01                	push   $0x1
        ap++;
    3baa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
    3bad:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    3bb0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    3bb3:	50                   	push   %eax
    3bb4:	ff 75 08             	pushl  0x8(%ebp)
    3bb7:	e8 16 fd ff ff       	call   38d2 <write>
        ap++;
    3bbc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
    3bbf:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3bc2:	31 ff                	xor    %edi,%edi
    3bc4:	e9 8f fe ff ff       	jmp    3a58 <printf+0x48>
          s = "(null)";
    3bc9:	bb 10 55 00 00       	mov    $0x5510,%ebx
        while(*s != 0){
    3bce:	b8 28 00 00 00       	mov    $0x28,%eax
    3bd3:	e9 72 ff ff ff       	jmp    3b4a <printf+0x13a>
    3bd8:	66 90                	xchg   %ax,%ax
    3bda:	66 90                	xchg   %ax,%ax
    3bdc:	66 90                	xchg   %ax,%ax
    3bde:	66 90                	xchg   %ax,%ax

00003be0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3be0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3be1:	a1 c0 5e 00 00       	mov    0x5ec0,%eax
{
    3be6:	89 e5                	mov    %esp,%ebp
    3be8:	57                   	push   %edi
    3be9:	56                   	push   %esi
    3bea:	53                   	push   %ebx
    3beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    3bee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    3bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3bf8:	39 c8                	cmp    %ecx,%eax
    3bfa:	8b 10                	mov    (%eax),%edx
    3bfc:	73 32                	jae    3c30 <free+0x50>
    3bfe:	39 d1                	cmp    %edx,%ecx
    3c00:	72 04                	jb     3c06 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3c02:	39 d0                	cmp    %edx,%eax
    3c04:	72 32                	jb     3c38 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3c06:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3c09:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3c0c:	39 fa                	cmp    %edi,%edx
    3c0e:	74 30                	je     3c40 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3c10:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3c13:	8b 50 04             	mov    0x4(%eax),%edx
    3c16:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3c19:	39 f1                	cmp    %esi,%ecx
    3c1b:	74 3a                	je     3c57 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3c1d:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3c1f:	a3 c0 5e 00 00       	mov    %eax,0x5ec0
}
    3c24:	5b                   	pop    %ebx
    3c25:	5e                   	pop    %esi
    3c26:	5f                   	pop    %edi
    3c27:	5d                   	pop    %ebp
    3c28:	c3                   	ret    
    3c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3c30:	39 d0                	cmp    %edx,%eax
    3c32:	72 04                	jb     3c38 <free+0x58>
    3c34:	39 d1                	cmp    %edx,%ecx
    3c36:	72 ce                	jb     3c06 <free+0x26>
{
    3c38:	89 d0                	mov    %edx,%eax
    3c3a:	eb bc                	jmp    3bf8 <free+0x18>
    3c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    3c40:	03 72 04             	add    0x4(%edx),%esi
    3c43:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3c46:	8b 10                	mov    (%eax),%edx
    3c48:	8b 12                	mov    (%edx),%edx
    3c4a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3c4d:	8b 50 04             	mov    0x4(%eax),%edx
    3c50:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3c53:	39 f1                	cmp    %esi,%ecx
    3c55:	75 c6                	jne    3c1d <free+0x3d>
    p->s.size += bp->s.size;
    3c57:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3c5a:	a3 c0 5e 00 00       	mov    %eax,0x5ec0
    p->s.size += bp->s.size;
    3c5f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3c62:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3c65:	89 10                	mov    %edx,(%eax)
}
    3c67:	5b                   	pop    %ebx
    3c68:	5e                   	pop    %esi
    3c69:	5f                   	pop    %edi
    3c6a:	5d                   	pop    %ebp
    3c6b:	c3                   	ret    
    3c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003c70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3c70:	55                   	push   %ebp
    3c71:	89 e5                	mov    %esp,%ebp
    3c73:	57                   	push   %edi
    3c74:	56                   	push   %esi
    3c75:	53                   	push   %ebx
    3c76:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3c79:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3c7c:	8b 15 c0 5e 00 00    	mov    0x5ec0,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3c82:	8d 78 07             	lea    0x7(%eax),%edi
    3c85:	c1 ef 03             	shr    $0x3,%edi
    3c88:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
    3c8b:	85 d2                	test   %edx,%edx
    3c8d:	0f 84 9d 00 00 00    	je     3d30 <malloc+0xc0>
    3c93:	8b 02                	mov    (%edx),%eax
    3c95:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    3c98:	39 cf                	cmp    %ecx,%edi
    3c9a:	76 6c                	jbe    3d08 <malloc+0x98>
    3c9c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    3ca2:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3ca7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    3caa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    3cb1:	eb 0e                	jmp    3cc1 <malloc+0x51>
    3cb3:	90                   	nop
    3cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3cb8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    3cba:	8b 48 04             	mov    0x4(%eax),%ecx
    3cbd:	39 f9                	cmp    %edi,%ecx
    3cbf:	73 47                	jae    3d08 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3cc1:	39 05 c0 5e 00 00    	cmp    %eax,0x5ec0
    3cc7:	89 c2                	mov    %eax,%edx
    3cc9:	75 ed                	jne    3cb8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    3ccb:	83 ec 0c             	sub    $0xc,%esp
    3cce:	56                   	push   %esi
    3ccf:	e8 66 fc ff ff       	call   393a <sbrk>
  if(p == (char*)-1)
    3cd4:	83 c4 10             	add    $0x10,%esp
    3cd7:	83 f8 ff             	cmp    $0xffffffff,%eax
    3cda:	74 1c                	je     3cf8 <malloc+0x88>
  hp->s.size = nu;
    3cdc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3cdf:	83 ec 0c             	sub    $0xc,%esp
    3ce2:	83 c0 08             	add    $0x8,%eax
    3ce5:	50                   	push   %eax
    3ce6:	e8 f5 fe ff ff       	call   3be0 <free>
  return freep;
    3ceb:	8b 15 c0 5e 00 00    	mov    0x5ec0,%edx
      if((p = morecore(nunits)) == 0)
    3cf1:	83 c4 10             	add    $0x10,%esp
    3cf4:	85 d2                	test   %edx,%edx
    3cf6:	75 c0                	jne    3cb8 <malloc+0x48>
        return 0;
  }
}
    3cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3cfb:	31 c0                	xor    %eax,%eax
}
    3cfd:	5b                   	pop    %ebx
    3cfe:	5e                   	pop    %esi
    3cff:	5f                   	pop    %edi
    3d00:	5d                   	pop    %ebp
    3d01:	c3                   	ret    
    3d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    3d08:	39 cf                	cmp    %ecx,%edi
    3d0a:	74 54                	je     3d60 <malloc+0xf0>
        p->s.size -= nunits;
    3d0c:	29 f9                	sub    %edi,%ecx
    3d0e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    3d11:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    3d14:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    3d17:	89 15 c0 5e 00 00    	mov    %edx,0x5ec0
}
    3d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3d20:	83 c0 08             	add    $0x8,%eax
}
    3d23:	5b                   	pop    %ebx
    3d24:	5e                   	pop    %esi
    3d25:	5f                   	pop    %edi
    3d26:	5d                   	pop    %ebp
    3d27:	c3                   	ret    
    3d28:	90                   	nop
    3d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    3d30:	c7 05 c0 5e 00 00 c4 	movl   $0x5ec4,0x5ec0
    3d37:	5e 00 00 
    3d3a:	c7 05 c4 5e 00 00 c4 	movl   $0x5ec4,0x5ec4
    3d41:	5e 00 00 
    base.s.size = 0;
    3d44:	b8 c4 5e 00 00       	mov    $0x5ec4,%eax
    3d49:	c7 05 c8 5e 00 00 00 	movl   $0x0,0x5ec8
    3d50:	00 00 00 
    3d53:	e9 44 ff ff ff       	jmp    3c9c <malloc+0x2c>
    3d58:	90                   	nop
    3d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
    3d60:	8b 08                	mov    (%eax),%ecx
    3d62:	89 0a                	mov    %ecx,(%edx)
    3d64:	eb b1                	jmp    3d17 <malloc+0xa7>
