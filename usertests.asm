
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return randstate;
}

int
main(int argc, char *argv[])
{
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	51                   	push   %ecx
      12:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
      15:	68 76 4e 00 00       	push   $0x4e76
      1a:	6a 01                	push   $0x1
      1c:	e8 ef 3a 00 00       	call   3b10 <printf>

  if(open("usertests.ran", 0) >= 0){
      21:	59                   	pop    %ecx
      22:	58                   	pop    %eax
      23:	6a 00                	push   $0x0
      25:	68 8a 4e 00 00       	push   $0x4e8a
      2a:	e8 b4 39 00 00       	call   39e3 <open>
      2f:	83 c4 10             	add    $0x10,%esp
      32:	85 c0                	test   %eax,%eax
      34:	78 13                	js     49 <main+0x49>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      36:	52                   	push   %edx
      37:	52                   	push   %edx
      38:	68 f4 55 00 00       	push   $0x55f4
      3d:	6a 01                	push   $0x1
      3f:	e8 cc 3a 00 00       	call   3b10 <printf>
    exit();
      44:	e8 5a 39 00 00       	call   39a3 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      49:	50                   	push   %eax
      4a:	50                   	push   %eax
      4b:	68 00 02 00 00       	push   $0x200
      50:	68 8a 4e 00 00       	push   $0x4e8a
      55:	e8 89 39 00 00       	call   39e3 <open>
      5a:	89 04 24             	mov    %eax,(%esp)
      5d:	e8 69 39 00 00       	call   39cb <close>

  argptest();
      62:	e8 49 36 00 00       	call   36b0 <argptest>
  createdelete();
      67:	e8 24 12 00 00       	call   1290 <createdelete>
  linkunlink();
      6c:	e8 ff 1a 00 00       	call   1b70 <linkunlink>
  concreate();
      71:	e8 fa 17 00 00       	call   1870 <concreate>
  fourfiles();
      76:	e8 f5 0f 00 00       	call   1070 <fourfiles>
  sharedfd();
      7b:	e8 30 0e 00 00       	call   eb0 <sharedfd>

  bigargtest();
      80:	e8 cb 32 00 00       	call   3350 <bigargtest>
  bigwrite();
      85:	e8 26 24 00 00       	call   24b0 <bigwrite>
  bigargtest();
      8a:	e8 c1 32 00 00       	call   3350 <bigargtest>
  bsstest();
      8f:	e8 4c 32 00 00       	call   32e0 <bsstest>
  sbrktest();
      94:	e8 57 2d 00 00       	call   2df0 <sbrktest>
  validatetest();
      99:	e8 82 31 00 00       	call   3220 <validatetest>

  opentest();
      9e:	e8 6d 03 00 00       	call   410 <opentest>
  writetest();
      a3:	e8 08 04 00 00       	call   4b0 <writetest>
  writetest1();
      a8:	e8 e3 05 00 00       	call   690 <writetest1>
  createtest();
      ad:	e8 ae 07 00 00       	call   860 <createtest>

  openiputtest();
      b2:	e8 59 02 00 00       	call   310 <openiputtest>
  exitiputtest();
      b7:	e8 54 01 00 00       	call   210 <exitiputtest>
  iputtest();
      bc:	e8 5f 00 00 00       	call   120 <iputtest>

  mem();
      c1:	e8 1a 0d 00 00       	call   de0 <mem>
  pipe1();
      c6:	e8 95 09 00 00       	call   a60 <pipe1>
  preempt();
      cb:	e8 30 0b 00 00       	call   c00 <preempt>
  exitwait();
      d0:	e8 8b 0c 00 00       	call   d60 <exitwait>

  rmdot();
      d5:	e8 c6 27 00 00       	call   28a0 <rmdot>
  fourteen();
      da:	e8 81 26 00 00       	call   2760 <fourteen>
  bigfile();
      df:	e8 ac 24 00 00       	call   2590 <bigfile>
  subdir();
      e4:	e8 d7 1c 00 00       	call   1dc0 <subdir>
  linktest();
      e9:	e8 62 15 00 00       	call   1650 <linktest>
  unlinkread();
      ee:	e8 cd 13 00 00       	call   14c0 <unlinkread>
  dirfile();
      f3:	e8 28 29 00 00       	call   2a20 <dirfile>
  iref();
      f8:	e8 23 2b 00 00       	call   2c20 <iref>
  forktest();  
      fd:	e8 3e 2c 00 00       	call   2d40 <forktest>
  bigdir();
     102:	e8 79 1b 00 00       	call   1c80 <bigdir>

  uio();
     107:	e8 24 35 00 00       	call   3630 <uio>

  exectest();
     10c:	e8 ff 08 00 00       	call   a10 <exectest>

  exit();
     111:	e8 8d 38 00 00       	call   39a3 <exit>
     116:	66 90                	xchg   %ax,%ax
     118:	66 90                	xchg   %ax,%ax
     11a:	66 90                	xchg   %ax,%ax
     11c:	66 90                	xchg   %ax,%ax
     11e:	66 90                	xchg   %ax,%ax

00000120 <iputtest>:
{
     120:	f3 0f 1e fb          	endbr32 
     124:	55                   	push   %ebp
     125:	89 e5                	mov    %esp,%ebp
     127:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
     12a:	68 0c 3f 00 00       	push   $0x3f0c
     12f:	ff 35 20 5f 00 00    	pushl  0x5f20
     135:	e8 d6 39 00 00       	call   3b10 <printf>
  if(mkdir("iputdir") < 0){
     13a:	c7 04 24 9f 3e 00 00 	movl   $0x3e9f,(%esp)
     141:	e8 c5 38 00 00       	call   3a0b <mkdir>
     146:	83 c4 10             	add    $0x10,%esp
     149:	85 c0                	test   %eax,%eax
     14b:	78 58                	js     1a5 <iputtest+0x85>
  if(chdir("iputdir") < 0){
     14d:	83 ec 0c             	sub    $0xc,%esp
     150:	68 9f 3e 00 00       	push   $0x3e9f
     155:	e8 b9 38 00 00       	call   3a13 <chdir>
     15a:	83 c4 10             	add    $0x10,%esp
     15d:	85 c0                	test   %eax,%eax
     15f:	0f 88 85 00 00 00    	js     1ea <iputtest+0xca>
  if(unlink("../iputdir") < 0){
     165:	83 ec 0c             	sub    $0xc,%esp
     168:	68 9c 3e 00 00       	push   $0x3e9c
     16d:	e8 81 38 00 00       	call   39f3 <unlink>
     172:	83 c4 10             	add    $0x10,%esp
     175:	85 c0                	test   %eax,%eax
     177:	78 5a                	js     1d3 <iputtest+0xb3>
  if(chdir("/") < 0){
     179:	83 ec 0c             	sub    $0xc,%esp
     17c:	68 c1 3e 00 00       	push   $0x3ec1
     181:	e8 8d 38 00 00       	call   3a13 <chdir>
     186:	83 c4 10             	add    $0x10,%esp
     189:	85 c0                	test   %eax,%eax
     18b:	78 2f                	js     1bc <iputtest+0x9c>
  printf(stdout, "iput test ok\n");
     18d:	83 ec 08             	sub    $0x8,%esp
     190:	68 44 3f 00 00       	push   $0x3f44
     195:	ff 35 20 5f 00 00    	pushl  0x5f20
     19b:	e8 70 39 00 00       	call   3b10 <printf>
}
     1a0:	83 c4 10             	add    $0x10,%esp
     1a3:	c9                   	leave  
     1a4:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     1a5:	50                   	push   %eax
     1a6:	50                   	push   %eax
     1a7:	68 78 3e 00 00       	push   $0x3e78
     1ac:	ff 35 20 5f 00 00    	pushl  0x5f20
     1b2:	e8 59 39 00 00       	call   3b10 <printf>
    exit();
     1b7:	e8 e7 37 00 00       	call   39a3 <exit>
    printf(stdout, "chdir / failed\n");
     1bc:	50                   	push   %eax
     1bd:	50                   	push   %eax
     1be:	68 c3 3e 00 00       	push   $0x3ec3
     1c3:	ff 35 20 5f 00 00    	pushl  0x5f20
     1c9:	e8 42 39 00 00       	call   3b10 <printf>
    exit();
     1ce:	e8 d0 37 00 00       	call   39a3 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1d3:	52                   	push   %edx
     1d4:	52                   	push   %edx
     1d5:	68 a7 3e 00 00       	push   $0x3ea7
     1da:	ff 35 20 5f 00 00    	pushl  0x5f20
     1e0:	e8 2b 39 00 00       	call   3b10 <printf>
    exit();
     1e5:	e8 b9 37 00 00       	call   39a3 <exit>
    printf(stdout, "chdir iputdir failed\n");
     1ea:	51                   	push   %ecx
     1eb:	51                   	push   %ecx
     1ec:	68 86 3e 00 00       	push   $0x3e86
     1f1:	ff 35 20 5f 00 00    	pushl  0x5f20
     1f7:	e8 14 39 00 00       	call   3b10 <printf>
    exit();
     1fc:	e8 a2 37 00 00       	call   39a3 <exit>
     201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     208:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     20f:	90                   	nop

00000210 <exitiputtest>:
{
     210:	f3 0f 1e fb          	endbr32 
     214:	55                   	push   %ebp
     215:	89 e5                	mov    %esp,%ebp
     217:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     21a:	68 d3 3e 00 00       	push   $0x3ed3
     21f:	ff 35 20 5f 00 00    	pushl  0x5f20
     225:	e8 e6 38 00 00       	call   3b10 <printf>
  pid = fork();
     22a:	e8 6c 37 00 00       	call   399b <fork>
  if(pid < 0){
     22f:	83 c4 10             	add    $0x10,%esp
     232:	85 c0                	test   %eax,%eax
     234:	0f 88 86 00 00 00    	js     2c0 <exitiputtest+0xb0>
  if(pid == 0){
     23a:	75 4c                	jne    288 <exitiputtest+0x78>
    if(mkdir("iputdir") < 0){
     23c:	83 ec 0c             	sub    $0xc,%esp
     23f:	68 9f 3e 00 00       	push   $0x3e9f
     244:	e8 c2 37 00 00       	call   3a0b <mkdir>
     249:	83 c4 10             	add    $0x10,%esp
     24c:	85 c0                	test   %eax,%eax
     24e:	0f 88 83 00 00 00    	js     2d7 <exitiputtest+0xc7>
    if(chdir("iputdir") < 0){
     254:	83 ec 0c             	sub    $0xc,%esp
     257:	68 9f 3e 00 00       	push   $0x3e9f
     25c:	e8 b2 37 00 00       	call   3a13 <chdir>
     261:	83 c4 10             	add    $0x10,%esp
     264:	85 c0                	test   %eax,%eax
     266:	0f 88 82 00 00 00    	js     2ee <exitiputtest+0xde>
    if(unlink("../iputdir") < 0){
     26c:	83 ec 0c             	sub    $0xc,%esp
     26f:	68 9c 3e 00 00       	push   $0x3e9c
     274:	e8 7a 37 00 00       	call   39f3 <unlink>
     279:	83 c4 10             	add    $0x10,%esp
     27c:	85 c0                	test   %eax,%eax
     27e:	78 28                	js     2a8 <exitiputtest+0x98>
    exit();
     280:	e8 1e 37 00 00       	call   39a3 <exit>
     285:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     288:	e8 1e 37 00 00       	call   39ab <wait>
  printf(stdout, "exitiput test ok\n");
     28d:	83 ec 08             	sub    $0x8,%esp
     290:	68 f6 3e 00 00       	push   $0x3ef6
     295:	ff 35 20 5f 00 00    	pushl  0x5f20
     29b:	e8 70 38 00 00       	call   3b10 <printf>
}
     2a0:	83 c4 10             	add    $0x10,%esp
     2a3:	c9                   	leave  
     2a4:	c3                   	ret    
     2a5:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     2a8:	83 ec 08             	sub    $0x8,%esp
     2ab:	68 a7 3e 00 00       	push   $0x3ea7
     2b0:	ff 35 20 5f 00 00    	pushl  0x5f20
     2b6:	e8 55 38 00 00       	call   3b10 <printf>
      exit();
     2bb:	e8 e3 36 00 00       	call   39a3 <exit>
    printf(stdout, "fork failed\n");
     2c0:	51                   	push   %ecx
     2c1:	51                   	push   %ecx
     2c2:	68 c9 4d 00 00       	push   $0x4dc9
     2c7:	ff 35 20 5f 00 00    	pushl  0x5f20
     2cd:	e8 3e 38 00 00       	call   3b10 <printf>
    exit();
     2d2:	e8 cc 36 00 00       	call   39a3 <exit>
      printf(stdout, "mkdir failed\n");
     2d7:	52                   	push   %edx
     2d8:	52                   	push   %edx
     2d9:	68 78 3e 00 00       	push   $0x3e78
     2de:	ff 35 20 5f 00 00    	pushl  0x5f20
     2e4:	e8 27 38 00 00       	call   3b10 <printf>
      exit();
     2e9:	e8 b5 36 00 00       	call   39a3 <exit>
      printf(stdout, "child chdir failed\n");
     2ee:	50                   	push   %eax
     2ef:	50                   	push   %eax
     2f0:	68 e2 3e 00 00       	push   $0x3ee2
     2f5:	ff 35 20 5f 00 00    	pushl  0x5f20
     2fb:	e8 10 38 00 00       	call   3b10 <printf>
      exit();
     300:	e8 9e 36 00 00       	call   39a3 <exit>
     305:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000310 <openiputtest>:
{
     310:	f3 0f 1e fb          	endbr32 
     314:	55                   	push   %ebp
     315:	89 e5                	mov    %esp,%ebp
     317:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     31a:	68 08 3f 00 00       	push   $0x3f08
     31f:	ff 35 20 5f 00 00    	pushl  0x5f20
     325:	e8 e6 37 00 00       	call   3b10 <printf>
  if(mkdir("oidir") < 0){
     32a:	c7 04 24 17 3f 00 00 	movl   $0x3f17,(%esp)
     331:	e8 d5 36 00 00       	call   3a0b <mkdir>
     336:	83 c4 10             	add    $0x10,%esp
     339:	85 c0                	test   %eax,%eax
     33b:	0f 88 9b 00 00 00    	js     3dc <openiputtest+0xcc>
  pid = fork();
     341:	e8 55 36 00 00       	call   399b <fork>
  if(pid < 0){
     346:	85 c0                	test   %eax,%eax
     348:	78 7b                	js     3c5 <openiputtest+0xb5>
  if(pid == 0){
     34a:	75 34                	jne    380 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     34c:	83 ec 08             	sub    $0x8,%esp
     34f:	6a 02                	push   $0x2
     351:	68 17 3f 00 00       	push   $0x3f17
     356:	e8 88 36 00 00       	call   39e3 <open>
    if(fd >= 0){
     35b:	83 c4 10             	add    $0x10,%esp
     35e:	85 c0                	test   %eax,%eax
     360:	78 5e                	js     3c0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     362:	83 ec 08             	sub    $0x8,%esp
     365:	68 ac 4e 00 00       	push   $0x4eac
     36a:	ff 35 20 5f 00 00    	pushl  0x5f20
     370:	e8 9b 37 00 00       	call   3b10 <printf>
      exit();
     375:	e8 29 36 00 00       	call   39a3 <exit>
     37a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
     380:	83 ec 0c             	sub    $0xc,%esp
     383:	6a 01                	push   $0x1
     385:	e8 a9 36 00 00       	call   3a33 <sleep>
  if(unlink("oidir") != 0){
     38a:	c7 04 24 17 3f 00 00 	movl   $0x3f17,(%esp)
     391:	e8 5d 36 00 00       	call   39f3 <unlink>
     396:	83 c4 10             	add    $0x10,%esp
     399:	85 c0                	test   %eax,%eax
     39b:	75 56                	jne    3f3 <openiputtest+0xe3>
  wait();
     39d:	e8 09 36 00 00       	call   39ab <wait>
  printf(stdout, "openiput test ok\n");
     3a2:	83 ec 08             	sub    $0x8,%esp
     3a5:	68 40 3f 00 00       	push   $0x3f40
     3aa:	ff 35 20 5f 00 00    	pushl  0x5f20
     3b0:	e8 5b 37 00 00       	call   3b10 <printf>
     3b5:	83 c4 10             	add    $0x10,%esp
}
     3b8:	c9                   	leave  
     3b9:	c3                   	ret    
     3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     3c0:	e8 de 35 00 00       	call   39a3 <exit>
    printf(stdout, "fork failed\n");
     3c5:	52                   	push   %edx
     3c6:	52                   	push   %edx
     3c7:	68 c9 4d 00 00       	push   $0x4dc9
     3cc:	ff 35 20 5f 00 00    	pushl  0x5f20
     3d2:	e8 39 37 00 00       	call   3b10 <printf>
    exit();
     3d7:	e8 c7 35 00 00       	call   39a3 <exit>
    printf(stdout, "mkdir oidir failed\n");
     3dc:	51                   	push   %ecx
     3dd:	51                   	push   %ecx
     3de:	68 1d 3f 00 00       	push   $0x3f1d
     3e3:	ff 35 20 5f 00 00    	pushl  0x5f20
     3e9:	e8 22 37 00 00       	call   3b10 <printf>
    exit();
     3ee:	e8 b0 35 00 00       	call   39a3 <exit>
    printf(stdout, "unlink failed\n");
     3f3:	50                   	push   %eax
     3f4:	50                   	push   %eax
     3f5:	68 31 3f 00 00       	push   $0x3f31
     3fa:	ff 35 20 5f 00 00    	pushl  0x5f20
     400:	e8 0b 37 00 00       	call   3b10 <printf>
    exit();
     405:	e8 99 35 00 00       	call   39a3 <exit>
     40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000410 <opentest>:
{
     410:	f3 0f 1e fb          	endbr32 
     414:	55                   	push   %ebp
     415:	89 e5                	mov    %esp,%ebp
     417:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     41a:	68 52 3f 00 00       	push   $0x3f52
     41f:	ff 35 20 5f 00 00    	pushl  0x5f20
     425:	e8 e6 36 00 00       	call   3b10 <printf>
  fd = open("echo", 0);
     42a:	58                   	pop    %eax
     42b:	5a                   	pop    %edx
     42c:	6a 00                	push   $0x0
     42e:	68 5d 3f 00 00       	push   $0x3f5d
     433:	e8 ab 35 00 00       	call   39e3 <open>
  if(fd < 0){
     438:	83 c4 10             	add    $0x10,%esp
     43b:	85 c0                	test   %eax,%eax
     43d:	78 36                	js     475 <opentest+0x65>
  close(fd);
     43f:	83 ec 0c             	sub    $0xc,%esp
     442:	50                   	push   %eax
     443:	e8 83 35 00 00       	call   39cb <close>
  fd = open("doesnotexist", 0);
     448:	5a                   	pop    %edx
     449:	59                   	pop    %ecx
     44a:	6a 00                	push   $0x0
     44c:	68 75 3f 00 00       	push   $0x3f75
     451:	e8 8d 35 00 00       	call   39e3 <open>
  if(fd >= 0){
     456:	83 c4 10             	add    $0x10,%esp
     459:	85 c0                	test   %eax,%eax
     45b:	79 2f                	jns    48c <opentest+0x7c>
  printf(stdout, "open test ok\n");
     45d:	83 ec 08             	sub    $0x8,%esp
     460:	68 a0 3f 00 00       	push   $0x3fa0
     465:	ff 35 20 5f 00 00    	pushl  0x5f20
     46b:	e8 a0 36 00 00       	call   3b10 <printf>
}
     470:	83 c4 10             	add    $0x10,%esp
     473:	c9                   	leave  
     474:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     475:	50                   	push   %eax
     476:	50                   	push   %eax
     477:	68 62 3f 00 00       	push   $0x3f62
     47c:	ff 35 20 5f 00 00    	pushl  0x5f20
     482:	e8 89 36 00 00       	call   3b10 <printf>
    exit();
     487:	e8 17 35 00 00       	call   39a3 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     48c:	50                   	push   %eax
     48d:	50                   	push   %eax
     48e:	68 82 3f 00 00       	push   $0x3f82
     493:	ff 35 20 5f 00 00    	pushl  0x5f20
     499:	e8 72 36 00 00       	call   3b10 <printf>
    exit();
     49e:	e8 00 35 00 00       	call   39a3 <exit>
     4a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     4aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004b0 <writetest>:
{
     4b0:	f3 0f 1e fb          	endbr32 
     4b4:	55                   	push   %ebp
     4b5:	89 e5                	mov    %esp,%ebp
     4b7:	56                   	push   %esi
     4b8:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     4b9:	83 ec 08             	sub    $0x8,%esp
     4bc:	68 ae 3f 00 00       	push   $0x3fae
     4c1:	ff 35 20 5f 00 00    	pushl  0x5f20
     4c7:	e8 44 36 00 00       	call   3b10 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     4cc:	58                   	pop    %eax
     4cd:	5a                   	pop    %edx
     4ce:	68 02 02 00 00       	push   $0x202
     4d3:	68 bf 3f 00 00       	push   $0x3fbf
     4d8:	e8 06 35 00 00       	call   39e3 <open>
  if(fd >= 0){
     4dd:	83 c4 10             	add    $0x10,%esp
     4e0:	85 c0                	test   %eax,%eax
     4e2:	0f 88 8c 01 00 00    	js     674 <writetest+0x1c4>
    printf(stdout, "creat small succeeded; ok\n");
     4e8:	83 ec 08             	sub    $0x8,%esp
     4eb:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     4ed:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     4ef:	68 c5 3f 00 00       	push   $0x3fc5
     4f4:	ff 35 20 5f 00 00    	pushl  0x5f20
     4fa:	e8 11 36 00 00       	call   3b10 <printf>
     4ff:	83 c4 10             	add    $0x10,%esp
     502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     508:	83 ec 04             	sub    $0x4,%esp
     50b:	6a 0a                	push   $0xa
     50d:	68 fc 3f 00 00       	push   $0x3ffc
     512:	56                   	push   %esi
     513:	e8 ab 34 00 00       	call   39c3 <write>
     518:	83 c4 10             	add    $0x10,%esp
     51b:	83 f8 0a             	cmp    $0xa,%eax
     51e:	0f 85 d9 00 00 00    	jne    5fd <writetest+0x14d>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     524:	83 ec 04             	sub    $0x4,%esp
     527:	6a 0a                	push   $0xa
     529:	68 07 40 00 00       	push   $0x4007
     52e:	56                   	push   %esi
     52f:	e8 8f 34 00 00       	call   39c3 <write>
     534:	83 c4 10             	add    $0x10,%esp
     537:	83 f8 0a             	cmp    $0xa,%eax
     53a:	0f 85 d6 00 00 00    	jne    616 <writetest+0x166>
  for(i = 0; i < 100; i++){
     540:	83 c3 01             	add    $0x1,%ebx
     543:	83 fb 64             	cmp    $0x64,%ebx
     546:	75 c0                	jne    508 <writetest+0x58>
  printf(stdout, "writes ok\n");
     548:	83 ec 08             	sub    $0x8,%esp
     54b:	68 12 40 00 00       	push   $0x4012
     550:	ff 35 20 5f 00 00    	pushl  0x5f20
     556:	e8 b5 35 00 00       	call   3b10 <printf>
  close(fd);
     55b:	89 34 24             	mov    %esi,(%esp)
     55e:	e8 68 34 00 00       	call   39cb <close>
  fd = open("small", O_RDONLY);
     563:	5b                   	pop    %ebx
     564:	5e                   	pop    %esi
     565:	6a 00                	push   $0x0
     567:	68 bf 3f 00 00       	push   $0x3fbf
     56c:	e8 72 34 00 00       	call   39e3 <open>
  if(fd >= 0){
     571:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     574:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     576:	85 c0                	test   %eax,%eax
     578:	0f 88 b1 00 00 00    	js     62f <writetest+0x17f>
    printf(stdout, "open small succeeded ok\n");
     57e:	83 ec 08             	sub    $0x8,%esp
     581:	68 1d 40 00 00       	push   $0x401d
     586:	ff 35 20 5f 00 00    	pushl  0x5f20
     58c:	e8 7f 35 00 00       	call   3b10 <printf>
  i = read(fd, buf, 2000);
     591:	83 c4 0c             	add    $0xc,%esp
     594:	68 d0 07 00 00       	push   $0x7d0
     599:	68 00 87 00 00       	push   $0x8700
     59e:	53                   	push   %ebx
     59f:	e8 17 34 00 00       	call   39bb <read>
  if(i == 2000){
     5a4:	83 c4 10             	add    $0x10,%esp
     5a7:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     5ac:	0f 85 94 00 00 00    	jne    646 <writetest+0x196>
    printf(stdout, "read succeeded ok\n");
     5b2:	83 ec 08             	sub    $0x8,%esp
     5b5:	68 51 40 00 00       	push   $0x4051
     5ba:	ff 35 20 5f 00 00    	pushl  0x5f20
     5c0:	e8 4b 35 00 00       	call   3b10 <printf>
  close(fd);
     5c5:	89 1c 24             	mov    %ebx,(%esp)
     5c8:	e8 fe 33 00 00       	call   39cb <close>
  if(unlink("small") < 0){
     5cd:	c7 04 24 bf 3f 00 00 	movl   $0x3fbf,(%esp)
     5d4:	e8 1a 34 00 00       	call   39f3 <unlink>
     5d9:	83 c4 10             	add    $0x10,%esp
     5dc:	85 c0                	test   %eax,%eax
     5de:	78 7d                	js     65d <writetest+0x1ad>
  printf(stdout, "small file test ok\n");
     5e0:	83 ec 08             	sub    $0x8,%esp
     5e3:	68 79 40 00 00       	push   $0x4079
     5e8:	ff 35 20 5f 00 00    	pushl  0x5f20
     5ee:	e8 1d 35 00 00       	call   3b10 <printf>
}
     5f3:	83 c4 10             	add    $0x10,%esp
     5f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5f9:	5b                   	pop    %ebx
     5fa:	5e                   	pop    %esi
     5fb:	5d                   	pop    %ebp
     5fc:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     5fd:	83 ec 04             	sub    $0x4,%esp
     600:	53                   	push   %ebx
     601:	68 d0 4e 00 00       	push   $0x4ed0
     606:	ff 35 20 5f 00 00    	pushl  0x5f20
     60c:	e8 ff 34 00 00       	call   3b10 <printf>
      exit();
     611:	e8 8d 33 00 00       	call   39a3 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     616:	83 ec 04             	sub    $0x4,%esp
     619:	53                   	push   %ebx
     61a:	68 f4 4e 00 00       	push   $0x4ef4
     61f:	ff 35 20 5f 00 00    	pushl  0x5f20
     625:	e8 e6 34 00 00       	call   3b10 <printf>
      exit();
     62a:	e8 74 33 00 00       	call   39a3 <exit>
    printf(stdout, "error: open small failed!\n");
     62f:	51                   	push   %ecx
     630:	51                   	push   %ecx
     631:	68 36 40 00 00       	push   $0x4036
     636:	ff 35 20 5f 00 00    	pushl  0x5f20
     63c:	e8 cf 34 00 00       	call   3b10 <printf>
    exit();
     641:	e8 5d 33 00 00       	call   39a3 <exit>
    printf(stdout, "read failed\n");
     646:	52                   	push   %edx
     647:	52                   	push   %edx
     648:	68 8d 43 00 00       	push   $0x438d
     64d:	ff 35 20 5f 00 00    	pushl  0x5f20
     653:	e8 b8 34 00 00       	call   3b10 <printf>
    exit();
     658:	e8 46 33 00 00       	call   39a3 <exit>
    printf(stdout, "unlink small failed\n");
     65d:	50                   	push   %eax
     65e:	50                   	push   %eax
     65f:	68 64 40 00 00       	push   $0x4064
     664:	ff 35 20 5f 00 00    	pushl  0x5f20
     66a:	e8 a1 34 00 00       	call   3b10 <printf>
    exit();
     66f:	e8 2f 33 00 00       	call   39a3 <exit>
    printf(stdout, "error: creat small failed!\n");
     674:	50                   	push   %eax
     675:	50                   	push   %eax
     676:	68 e0 3f 00 00       	push   $0x3fe0
     67b:	ff 35 20 5f 00 00    	pushl  0x5f20
     681:	e8 8a 34 00 00       	call   3b10 <printf>
    exit();
     686:	e8 18 33 00 00       	call   39a3 <exit>
     68b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     68f:	90                   	nop

00000690 <writetest1>:
{
     690:	f3 0f 1e fb          	endbr32 
     694:	55                   	push   %ebp
     695:	89 e5                	mov    %esp,%ebp
     697:	56                   	push   %esi
     698:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     699:	83 ec 08             	sub    $0x8,%esp
     69c:	68 8d 40 00 00       	push   $0x408d
     6a1:	ff 35 20 5f 00 00    	pushl  0x5f20
     6a7:	e8 64 34 00 00       	call   3b10 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     6ac:	58                   	pop    %eax
     6ad:	5a                   	pop    %edx
     6ae:	68 02 02 00 00       	push   $0x202
     6b3:	68 07 41 00 00       	push   $0x4107
     6b8:	e8 26 33 00 00       	call   39e3 <open>
  if(fd < 0){
     6bd:	83 c4 10             	add    $0x10,%esp
     6c0:	85 c0                	test   %eax,%eax
     6c2:	0f 88 5d 01 00 00    	js     825 <writetest1+0x195>
     6c8:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     6ca:	31 db                	xor    %ebx,%ebx
     6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     6d0:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     6d3:	89 1d 00 87 00 00    	mov    %ebx,0x8700
    if(write(fd, buf, 512) != 512){
     6d9:	68 00 02 00 00       	push   $0x200
     6de:	68 00 87 00 00       	push   $0x8700
     6e3:	56                   	push   %esi
     6e4:	e8 da 32 00 00       	call   39c3 <write>
     6e9:	83 c4 10             	add    $0x10,%esp
     6ec:	3d 00 02 00 00       	cmp    $0x200,%eax
     6f1:	0f 85 b3 00 00 00    	jne    7aa <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     6f7:	83 c3 01             	add    $0x1,%ebx
     6fa:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     700:	75 ce                	jne    6d0 <writetest1+0x40>
  close(fd);
     702:	83 ec 0c             	sub    $0xc,%esp
     705:	56                   	push   %esi
     706:	e8 c0 32 00 00       	call   39cb <close>
  fd = open("big", O_RDONLY);
     70b:	5b                   	pop    %ebx
     70c:	5e                   	pop    %esi
     70d:	6a 00                	push   $0x0
     70f:	68 07 41 00 00       	push   $0x4107
     714:	e8 ca 32 00 00       	call   39e3 <open>
  if(fd < 0){
     719:	83 c4 10             	add    $0x10,%esp
  fd = open("big", O_RDONLY);
     71c:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     71e:	85 c0                	test   %eax,%eax
     720:	0f 88 e8 00 00 00    	js     80e <writetest1+0x17e>
  n = 0;
     726:	31 f6                	xor    %esi,%esi
     728:	eb 1d                	jmp    747 <writetest1+0xb7>
     72a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     730:	3d 00 02 00 00       	cmp    $0x200,%eax
     735:	0f 85 9f 00 00 00    	jne    7da <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     73b:	a1 00 87 00 00       	mov    0x8700,%eax
     740:	39 f0                	cmp    %esi,%eax
     742:	75 7f                	jne    7c3 <writetest1+0x133>
    n++;
     744:	83 c6 01             	add    $0x1,%esi
    i = read(fd, buf, 512);
     747:	83 ec 04             	sub    $0x4,%esp
     74a:	68 00 02 00 00       	push   $0x200
     74f:	68 00 87 00 00       	push   $0x8700
     754:	53                   	push   %ebx
     755:	e8 61 32 00 00       	call   39bb <read>
    if(i == 0){
     75a:	83 c4 10             	add    $0x10,%esp
     75d:	85 c0                	test   %eax,%eax
     75f:	75 cf                	jne    730 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     761:	81 fe 8b 00 00 00    	cmp    $0x8b,%esi
     767:	0f 84 86 00 00 00    	je     7f3 <writetest1+0x163>
  close(fd);
     76d:	83 ec 0c             	sub    $0xc,%esp
     770:	53                   	push   %ebx
     771:	e8 55 32 00 00       	call   39cb <close>
  if(unlink("big") < 0){
     776:	c7 04 24 07 41 00 00 	movl   $0x4107,(%esp)
     77d:	e8 71 32 00 00       	call   39f3 <unlink>
     782:	83 c4 10             	add    $0x10,%esp
     785:	85 c0                	test   %eax,%eax
     787:	0f 88 af 00 00 00    	js     83c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     78d:	83 ec 08             	sub    $0x8,%esp
     790:	68 2e 41 00 00       	push   $0x412e
     795:	ff 35 20 5f 00 00    	pushl  0x5f20
     79b:	e8 70 33 00 00       	call   3b10 <printf>
}
     7a0:	83 c4 10             	add    $0x10,%esp
     7a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     7a6:	5b                   	pop    %ebx
     7a7:	5e                   	pop    %esi
     7a8:	5d                   	pop    %ebp
     7a9:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     7aa:	83 ec 04             	sub    $0x4,%esp
     7ad:	53                   	push   %ebx
     7ae:	68 b7 40 00 00       	push   $0x40b7
     7b3:	ff 35 20 5f 00 00    	pushl  0x5f20
     7b9:	e8 52 33 00 00       	call   3b10 <printf>
      exit();
     7be:	e8 e0 31 00 00       	call   39a3 <exit>
      printf(stdout, "read content of block %d is %d\n",
     7c3:	50                   	push   %eax
     7c4:	56                   	push   %esi
     7c5:	68 18 4f 00 00       	push   $0x4f18
     7ca:	ff 35 20 5f 00 00    	pushl  0x5f20
     7d0:	e8 3b 33 00 00       	call   3b10 <printf>
      exit();
     7d5:	e8 c9 31 00 00       	call   39a3 <exit>
      printf(stdout, "read failed %d\n", i);
     7da:	83 ec 04             	sub    $0x4,%esp
     7dd:	50                   	push   %eax
     7de:	68 0b 41 00 00       	push   $0x410b
     7e3:	ff 35 20 5f 00 00    	pushl  0x5f20
     7e9:	e8 22 33 00 00       	call   3b10 <printf>
      exit();
     7ee:	e8 b0 31 00 00       	call   39a3 <exit>
        printf(stdout, "read only %d blocks from big", n);
     7f3:	52                   	push   %edx
     7f4:	68 8b 00 00 00       	push   $0x8b
     7f9:	68 ee 40 00 00       	push   $0x40ee
     7fe:	ff 35 20 5f 00 00    	pushl  0x5f20
     804:	e8 07 33 00 00       	call   3b10 <printf>
        exit();
     809:	e8 95 31 00 00       	call   39a3 <exit>
    printf(stdout, "error: open big failed!\n");
     80e:	51                   	push   %ecx
     80f:	51                   	push   %ecx
     810:	68 d5 40 00 00       	push   $0x40d5
     815:	ff 35 20 5f 00 00    	pushl  0x5f20
     81b:	e8 f0 32 00 00       	call   3b10 <printf>
    exit();
     820:	e8 7e 31 00 00       	call   39a3 <exit>
    printf(stdout, "error: creat big failed!\n");
     825:	50                   	push   %eax
     826:	50                   	push   %eax
     827:	68 9d 40 00 00       	push   $0x409d
     82c:	ff 35 20 5f 00 00    	pushl  0x5f20
     832:	e8 d9 32 00 00       	call   3b10 <printf>
    exit();
     837:	e8 67 31 00 00       	call   39a3 <exit>
    printf(stdout, "unlink big failed\n");
     83c:	50                   	push   %eax
     83d:	50                   	push   %eax
     83e:	68 1b 41 00 00       	push   $0x411b
     843:	ff 35 20 5f 00 00    	pushl  0x5f20
     849:	e8 c2 32 00 00       	call   3b10 <printf>
    exit();
     84e:	e8 50 31 00 00       	call   39a3 <exit>
     853:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000860 <createtest>:
{
     860:	f3 0f 1e fb          	endbr32 
     864:	55                   	push   %ebp
     865:	89 e5                	mov    %esp,%ebp
     867:	53                   	push   %ebx
  name[2] = '\0';
     868:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     86d:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     870:	68 38 4f 00 00       	push   $0x4f38
     875:	ff 35 20 5f 00 00    	pushl  0x5f20
     87b:	e8 90 32 00 00       	call   3b10 <printf>
  name[0] = 'a';
     880:	c6 05 00 a7 00 00 61 	movb   $0x61,0xa700
  name[2] = '\0';
     887:	83 c4 10             	add    $0x10,%esp
     88a:	c6 05 02 a7 00 00 00 	movb   $0x0,0xa702
  for(i = 0; i < 52; i++){
     891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open(name, O_CREATE|O_RDWR);
     898:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     89b:	88 1d 01 a7 00 00    	mov    %bl,0xa701
    fd = open(name, O_CREATE|O_RDWR);
     8a1:	83 c3 01             	add    $0x1,%ebx
     8a4:	68 02 02 00 00       	push   $0x202
     8a9:	68 00 a7 00 00       	push   $0xa700
     8ae:	e8 30 31 00 00       	call   39e3 <open>
    close(fd);
     8b3:	89 04 24             	mov    %eax,(%esp)
     8b6:	e8 10 31 00 00       	call   39cb <close>
  for(i = 0; i < 52; i++){
     8bb:	83 c4 10             	add    $0x10,%esp
     8be:	80 fb 64             	cmp    $0x64,%bl
     8c1:	75 d5                	jne    898 <createtest+0x38>
  name[0] = 'a';
     8c3:	c6 05 00 a7 00 00 61 	movb   $0x61,0xa700
  name[2] = '\0';
     8ca:	bb 30 00 00 00       	mov    $0x30,%ebx
     8cf:	c6 05 02 a7 00 00 00 	movb   $0x0,0xa702
  for(i = 0; i < 52; i++){
     8d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     8dd:	8d 76 00             	lea    0x0(%esi),%esi
    unlink(name);
     8e0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     8e3:	88 1d 01 a7 00 00    	mov    %bl,0xa701
    unlink(name);
     8e9:	83 c3 01             	add    $0x1,%ebx
     8ec:	68 00 a7 00 00       	push   $0xa700
     8f1:	e8 fd 30 00 00       	call   39f3 <unlink>
  for(i = 0; i < 52; i++){
     8f6:	83 c4 10             	add    $0x10,%esp
     8f9:	80 fb 64             	cmp    $0x64,%bl
     8fc:	75 e2                	jne    8e0 <createtest+0x80>
  printf(stdout, "many creates, followed by unlink; ok\n");
     8fe:	83 ec 08             	sub    $0x8,%esp
     901:	68 60 4f 00 00       	push   $0x4f60
     906:	ff 35 20 5f 00 00    	pushl  0x5f20
     90c:	e8 ff 31 00 00       	call   3b10 <printf>
}
     911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     914:	83 c4 10             	add    $0x10,%esp
     917:	c9                   	leave  
     918:	c3                   	ret    
     919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000920 <dirtest>:
{
     920:	f3 0f 1e fb          	endbr32 
     924:	55                   	push   %ebp
     925:	89 e5                	mov    %esp,%ebp
     927:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     92a:	68 3c 41 00 00       	push   $0x413c
     92f:	ff 35 20 5f 00 00    	pushl  0x5f20
     935:	e8 d6 31 00 00       	call   3b10 <printf>
  if(mkdir("dir0") < 0){
     93a:	c7 04 24 48 41 00 00 	movl   $0x4148,(%esp)
     941:	e8 c5 30 00 00       	call   3a0b <mkdir>
     946:	83 c4 10             	add    $0x10,%esp
     949:	85 c0                	test   %eax,%eax
     94b:	78 58                	js     9a5 <dirtest+0x85>
  if(chdir("dir0") < 0){
     94d:	83 ec 0c             	sub    $0xc,%esp
     950:	68 48 41 00 00       	push   $0x4148
     955:	e8 b9 30 00 00       	call   3a13 <chdir>
     95a:	83 c4 10             	add    $0x10,%esp
     95d:	85 c0                	test   %eax,%eax
     95f:	0f 88 85 00 00 00    	js     9ea <dirtest+0xca>
  if(chdir("..") < 0){
     965:	83 ec 0c             	sub    $0xc,%esp
     968:	68 fd 46 00 00       	push   $0x46fd
     96d:	e8 a1 30 00 00       	call   3a13 <chdir>
     972:	83 c4 10             	add    $0x10,%esp
     975:	85 c0                	test   %eax,%eax
     977:	78 5a                	js     9d3 <dirtest+0xb3>
  if(unlink("dir0") < 0){
     979:	83 ec 0c             	sub    $0xc,%esp
     97c:	68 48 41 00 00       	push   $0x4148
     981:	e8 6d 30 00 00       	call   39f3 <unlink>
     986:	83 c4 10             	add    $0x10,%esp
     989:	85 c0                	test   %eax,%eax
     98b:	78 2f                	js     9bc <dirtest+0x9c>
  printf(stdout, "mkdir test ok\n");
     98d:	83 ec 08             	sub    $0x8,%esp
     990:	68 85 41 00 00       	push   $0x4185
     995:	ff 35 20 5f 00 00    	pushl  0x5f20
     99b:	e8 70 31 00 00       	call   3b10 <printf>
}
     9a0:	83 c4 10             	add    $0x10,%esp
     9a3:	c9                   	leave  
     9a4:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     9a5:	50                   	push   %eax
     9a6:	50                   	push   %eax
     9a7:	68 78 3e 00 00       	push   $0x3e78
     9ac:	ff 35 20 5f 00 00    	pushl  0x5f20
     9b2:	e8 59 31 00 00       	call   3b10 <printf>
    exit();
     9b7:	e8 e7 2f 00 00       	call   39a3 <exit>
    printf(stdout, "unlink dir0 failed\n");
     9bc:	50                   	push   %eax
     9bd:	50                   	push   %eax
     9be:	68 71 41 00 00       	push   $0x4171
     9c3:	ff 35 20 5f 00 00    	pushl  0x5f20
     9c9:	e8 42 31 00 00       	call   3b10 <printf>
    exit();
     9ce:	e8 d0 2f 00 00       	call   39a3 <exit>
    printf(stdout, "chdir .. failed\n");
     9d3:	52                   	push   %edx
     9d4:	52                   	push   %edx
     9d5:	68 60 41 00 00       	push   $0x4160
     9da:	ff 35 20 5f 00 00    	pushl  0x5f20
     9e0:	e8 2b 31 00 00       	call   3b10 <printf>
    exit();
     9e5:	e8 b9 2f 00 00       	call   39a3 <exit>
    printf(stdout, "chdir dir0 failed\n");
     9ea:	51                   	push   %ecx
     9eb:	51                   	push   %ecx
     9ec:	68 4d 41 00 00       	push   $0x414d
     9f1:	ff 35 20 5f 00 00    	pushl  0x5f20
     9f7:	e8 14 31 00 00       	call   3b10 <printf>
    exit();
     9fc:	e8 a2 2f 00 00       	call   39a3 <exit>
     a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     a0f:	90                   	nop

00000a10 <exectest>:
{
     a10:	f3 0f 1e fb          	endbr32 
     a14:	55                   	push   %ebp
     a15:	89 e5                	mov    %esp,%ebp
     a17:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     a1a:	68 94 41 00 00       	push   $0x4194
     a1f:	ff 35 20 5f 00 00    	pushl  0x5f20
     a25:	e8 e6 30 00 00       	call   3b10 <printf>
  if(exec("echo", echoargv) < 0){
     a2a:	5a                   	pop    %edx
     a2b:	59                   	pop    %ecx
     a2c:	68 24 5f 00 00       	push   $0x5f24
     a31:	68 5d 3f 00 00       	push   $0x3f5d
     a36:	e8 a0 2f 00 00       	call   39db <exec>
     a3b:	83 c4 10             	add    $0x10,%esp
     a3e:	85 c0                	test   %eax,%eax
     a40:	78 02                	js     a44 <exectest+0x34>
}
     a42:	c9                   	leave  
     a43:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     a44:	50                   	push   %eax
     a45:	50                   	push   %eax
     a46:	68 9f 41 00 00       	push   $0x419f
     a4b:	ff 35 20 5f 00 00    	pushl  0x5f20
     a51:	e8 ba 30 00 00       	call   3b10 <printf>
    exit();
     a56:	e8 48 2f 00 00       	call   39a3 <exit>
     a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a5f:	90                   	nop

00000a60 <pipe1>:
{
     a60:	f3 0f 1e fb          	endbr32 
     a64:	55                   	push   %ebp
     a65:	89 e5                	mov    %esp,%ebp
     a67:	57                   	push   %edi
     a68:	56                   	push   %esi
  if(pipe(fds) != 0){
     a69:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     a6c:	53                   	push   %ebx
     a6d:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     a70:	50                   	push   %eax
     a71:	e8 3d 2f 00 00       	call   39b3 <pipe>
     a76:	83 c4 10             	add    $0x10,%esp
     a79:	85 c0                	test   %eax,%eax
     a7b:	0f 85 38 01 00 00    	jne    bb9 <pipe1+0x159>
  pid = fork();
     a81:	e8 15 2f 00 00       	call   399b <fork>
  if(pid == 0){
     a86:	85 c0                	test   %eax,%eax
     a88:	0f 84 8d 00 00 00    	je     b1b <pipe1+0xbb>
  } else if(pid > 0){
     a8e:	0f 8e 38 01 00 00    	jle    bcc <pipe1+0x16c>
    close(fds[1]);
     a94:	83 ec 0c             	sub    $0xc,%esp
     a97:	ff 75 e4             	pushl  -0x1c(%ebp)
  seq = 0;
     a9a:	31 db                	xor    %ebx,%ebx
    cc = 1;
     a9c:	be 01 00 00 00       	mov    $0x1,%esi
    close(fds[1]);
     aa1:	e8 25 2f 00 00       	call   39cb <close>
    total = 0;
     aa6:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     aad:	83 c4 10             	add    $0x10,%esp
     ab0:	83 ec 04             	sub    $0x4,%esp
     ab3:	56                   	push   %esi
     ab4:	68 00 87 00 00       	push   $0x8700
     ab9:	ff 75 e0             	pushl  -0x20(%ebp)
     abc:	e8 fa 2e 00 00       	call   39bb <read>
     ac1:	83 c4 10             	add    $0x10,%esp
     ac4:	89 c7                	mov    %eax,%edi
     ac6:	85 c0                	test   %eax,%eax
     ac8:	0f 8e a7 00 00 00    	jle    b75 <pipe1+0x115>
     ace:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
      for(i = 0; i < n; i++){
     ad1:	31 c0                	xor    %eax,%eax
     ad3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ad7:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ad8:	89 da                	mov    %ebx,%edx
     ada:	83 c3 01             	add    $0x1,%ebx
     add:	38 90 00 87 00 00    	cmp    %dl,0x8700(%eax)
     ae3:	75 1c                	jne    b01 <pipe1+0xa1>
      for(i = 0; i < n; i++){
     ae5:	83 c0 01             	add    $0x1,%eax
     ae8:	39 d9                	cmp    %ebx,%ecx
     aea:	75 ec                	jne    ad8 <pipe1+0x78>
      cc = cc * 2;
     aec:	01 f6                	add    %esi,%esi
      total += n;
     aee:	01 7d d4             	add    %edi,-0x2c(%ebp)
     af1:	b8 00 20 00 00       	mov    $0x2000,%eax
     af6:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
     afc:	0f 4f f0             	cmovg  %eax,%esi
     aff:	eb af                	jmp    ab0 <pipe1+0x50>
          printf(1, "pipe1 oops 2\n");
     b01:	83 ec 08             	sub    $0x8,%esp
     b04:	68 ce 41 00 00       	push   $0x41ce
     b09:	6a 01                	push   $0x1
     b0b:	e8 00 30 00 00       	call   3b10 <printf>
          return;
     b10:	83 c4 10             	add    $0x10,%esp
}
     b13:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b16:	5b                   	pop    %ebx
     b17:	5e                   	pop    %esi
     b18:	5f                   	pop    %edi
     b19:	5d                   	pop    %ebp
     b1a:	c3                   	ret    
    close(fds[0]);
     b1b:	83 ec 0c             	sub    $0xc,%esp
     b1e:	ff 75 e0             	pushl  -0x20(%ebp)
  seq = 0;
     b21:	31 db                	xor    %ebx,%ebx
    close(fds[0]);
     b23:	e8 a3 2e 00 00       	call   39cb <close>
     b28:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 1033; i++)
     b2b:	31 c0                	xor    %eax,%eax
     b2d:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = seq++;
     b30:	8d 14 18             	lea    (%eax,%ebx,1),%edx
      for(i = 0; i < 1033; i++)
     b33:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     b36:	88 90 ff 86 00 00    	mov    %dl,0x86ff(%eax)
      for(i = 0; i < 1033; i++)
     b3c:	3d 09 04 00 00       	cmp    $0x409,%eax
     b41:	75 ed                	jne    b30 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     b43:	83 ec 04             	sub    $0x4,%esp
     b46:	81 c3 09 04 00 00    	add    $0x409,%ebx
     b4c:	68 09 04 00 00       	push   $0x409
     b51:	68 00 87 00 00       	push   $0x8700
     b56:	ff 75 e4             	pushl  -0x1c(%ebp)
     b59:	e8 65 2e 00 00       	call   39c3 <write>
     b5e:	83 c4 10             	add    $0x10,%esp
     b61:	3d 09 04 00 00       	cmp    $0x409,%eax
     b66:	75 77                	jne    bdf <pipe1+0x17f>
    for(n = 0; n < 5; n++){
     b68:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     b6e:	75 bb                	jne    b2b <pipe1+0xcb>
    exit();
     b70:	e8 2e 2e 00 00       	call   39a3 <exit>
    if(total != 5 * 1033){
     b75:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     b7c:	75 26                	jne    ba4 <pipe1+0x144>
    close(fds[0]);
     b7e:	83 ec 0c             	sub    $0xc,%esp
     b81:	ff 75 e0             	pushl  -0x20(%ebp)
     b84:	e8 42 2e 00 00       	call   39cb <close>
    wait();
     b89:	e8 1d 2e 00 00       	call   39ab <wait>
  printf(1, "pipe1 ok\n");
     b8e:	5a                   	pop    %edx
     b8f:	59                   	pop    %ecx
     b90:	68 f3 41 00 00       	push   $0x41f3
     b95:	6a 01                	push   $0x1
     b97:	e8 74 2f 00 00       	call   3b10 <printf>
     b9c:	83 c4 10             	add    $0x10,%esp
     b9f:	e9 6f ff ff ff       	jmp    b13 <pipe1+0xb3>
      printf(1, "pipe1 oops 3 total %d\n", total);
     ba4:	53                   	push   %ebx
     ba5:	ff 75 d4             	pushl  -0x2c(%ebp)
     ba8:	68 dc 41 00 00       	push   $0x41dc
     bad:	6a 01                	push   $0x1
     baf:	e8 5c 2f 00 00       	call   3b10 <printf>
      exit();
     bb4:	e8 ea 2d 00 00       	call   39a3 <exit>
    printf(1, "pipe() failed\n");
     bb9:	57                   	push   %edi
     bba:	57                   	push   %edi
     bbb:	68 b1 41 00 00       	push   $0x41b1
     bc0:	6a 01                	push   $0x1
     bc2:	e8 49 2f 00 00       	call   3b10 <printf>
    exit();
     bc7:	e8 d7 2d 00 00       	call   39a3 <exit>
    printf(1, "fork() failed\n");
     bcc:	50                   	push   %eax
     bcd:	50                   	push   %eax
     bce:	68 fd 41 00 00       	push   $0x41fd
     bd3:	6a 01                	push   $0x1
     bd5:	e8 36 2f 00 00       	call   3b10 <printf>
    exit();
     bda:	e8 c4 2d 00 00       	call   39a3 <exit>
        printf(1, "pipe1 oops 1\n");
     bdf:	56                   	push   %esi
     be0:	56                   	push   %esi
     be1:	68 c0 41 00 00       	push   $0x41c0
     be6:	6a 01                	push   $0x1
     be8:	e8 23 2f 00 00       	call   3b10 <printf>
        exit();
     bed:	e8 b1 2d 00 00       	call   39a3 <exit>
     bf2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000c00 <preempt>:
{
     c00:	f3 0f 1e fb          	endbr32 
     c04:	55                   	push   %ebp
     c05:	89 e5                	mov    %esp,%ebp
     c07:	57                   	push   %edi
     c08:	56                   	push   %esi
     c09:	53                   	push   %ebx
     c0a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     c0d:	68 0c 42 00 00       	push   $0x420c
     c12:	6a 01                	push   $0x1
     c14:	e8 f7 2e 00 00       	call   3b10 <printf>
  pid1 = fork();
     c19:	e8 7d 2d 00 00       	call   399b <fork>
  if(pid1 == 0)
     c1e:	83 c4 10             	add    $0x10,%esp
     c21:	85 c0                	test   %eax,%eax
     c23:	75 0b                	jne    c30 <preempt+0x30>
    for(;;)
     c25:	eb fe                	jmp    c25 <preempt+0x25>
     c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c2e:	66 90                	xchg   %ax,%ax
     c30:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     c32:	e8 64 2d 00 00       	call   399b <fork>
     c37:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     c39:	85 c0                	test   %eax,%eax
     c3b:	75 03                	jne    c40 <preempt+0x40>
    for(;;)
     c3d:	eb fe                	jmp    c3d <preempt+0x3d>
     c3f:	90                   	nop
  pipe(pfds);
     c40:	83 ec 0c             	sub    $0xc,%esp
     c43:	8d 45 e0             	lea    -0x20(%ebp),%eax
     c46:	50                   	push   %eax
     c47:	e8 67 2d 00 00       	call   39b3 <pipe>
  pid3 = fork();
     c4c:	e8 4a 2d 00 00       	call   399b <fork>
  if(pid3 == 0){
     c51:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     c54:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     c56:	85 c0                	test   %eax,%eax
     c58:	75 3e                	jne    c98 <preempt+0x98>
    close(pfds[0]);
     c5a:	83 ec 0c             	sub    $0xc,%esp
     c5d:	ff 75 e0             	pushl  -0x20(%ebp)
     c60:	e8 66 2d 00 00       	call   39cb <close>
    if(write(pfds[1], "x", 1) != 1)
     c65:	83 c4 0c             	add    $0xc,%esp
     c68:	6a 01                	push   $0x1
     c6a:	68 e1 47 00 00       	push   $0x47e1
     c6f:	ff 75 e4             	pushl  -0x1c(%ebp)
     c72:	e8 4c 2d 00 00       	call   39c3 <write>
     c77:	83 c4 10             	add    $0x10,%esp
     c7a:	83 f8 01             	cmp    $0x1,%eax
     c7d:	0f 85 a4 00 00 00    	jne    d27 <preempt+0x127>
    close(pfds[1]);
     c83:	83 ec 0c             	sub    $0xc,%esp
     c86:	ff 75 e4             	pushl  -0x1c(%ebp)
     c89:	e8 3d 2d 00 00       	call   39cb <close>
     c8e:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c91:	eb fe                	jmp    c91 <preempt+0x91>
     c93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c97:	90                   	nop
  close(pfds[1]);
     c98:	83 ec 0c             	sub    $0xc,%esp
     c9b:	ff 75 e4             	pushl  -0x1c(%ebp)
     c9e:	e8 28 2d 00 00       	call   39cb <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     ca3:	83 c4 0c             	add    $0xc,%esp
     ca6:	68 00 20 00 00       	push   $0x2000
     cab:	68 00 87 00 00       	push   $0x8700
     cb0:	ff 75 e0             	pushl  -0x20(%ebp)
     cb3:	e8 03 2d 00 00       	call   39bb <read>
     cb8:	83 c4 10             	add    $0x10,%esp
     cbb:	83 f8 01             	cmp    $0x1,%eax
     cbe:	75 7e                	jne    d3e <preempt+0x13e>
  close(pfds[0]);
     cc0:	83 ec 0c             	sub    $0xc,%esp
     cc3:	ff 75 e0             	pushl  -0x20(%ebp)
     cc6:	e8 00 2d 00 00       	call   39cb <close>
  printf(1, "kill... ");
     ccb:	58                   	pop    %eax
     ccc:	5a                   	pop    %edx
     ccd:	68 3d 42 00 00       	push   $0x423d
     cd2:	6a 01                	push   $0x1
     cd4:	e8 37 2e 00 00       	call   3b10 <printf>
  kill(pid1);
     cd9:	89 3c 24             	mov    %edi,(%esp)
     cdc:	e8 f2 2c 00 00       	call   39d3 <kill>
  kill(pid2);
     ce1:	89 34 24             	mov    %esi,(%esp)
     ce4:	e8 ea 2c 00 00       	call   39d3 <kill>
  kill(pid3);
     ce9:	89 1c 24             	mov    %ebx,(%esp)
     cec:	e8 e2 2c 00 00       	call   39d3 <kill>
  printf(1, "wait... ");
     cf1:	59                   	pop    %ecx
     cf2:	5b                   	pop    %ebx
     cf3:	68 46 42 00 00       	push   $0x4246
     cf8:	6a 01                	push   $0x1
     cfa:	e8 11 2e 00 00       	call   3b10 <printf>
  wait();
     cff:	e8 a7 2c 00 00       	call   39ab <wait>
  wait();
     d04:	e8 a2 2c 00 00       	call   39ab <wait>
  wait();
     d09:	e8 9d 2c 00 00       	call   39ab <wait>
  printf(1, "preempt ok\n");
     d0e:	5e                   	pop    %esi
     d0f:	5f                   	pop    %edi
     d10:	68 4f 42 00 00       	push   $0x424f
     d15:	6a 01                	push   $0x1
     d17:	e8 f4 2d 00 00       	call   3b10 <printf>
     d1c:	83 c4 10             	add    $0x10,%esp
}
     d1f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d22:	5b                   	pop    %ebx
     d23:	5e                   	pop    %esi
     d24:	5f                   	pop    %edi
     d25:	5d                   	pop    %ebp
     d26:	c3                   	ret    
      printf(1, "preempt write error");
     d27:	83 ec 08             	sub    $0x8,%esp
     d2a:	68 16 42 00 00       	push   $0x4216
     d2f:	6a 01                	push   $0x1
     d31:	e8 da 2d 00 00       	call   3b10 <printf>
     d36:	83 c4 10             	add    $0x10,%esp
     d39:	e9 45 ff ff ff       	jmp    c83 <preempt+0x83>
    printf(1, "preempt read error");
     d3e:	83 ec 08             	sub    $0x8,%esp
     d41:	68 2a 42 00 00       	push   $0x422a
     d46:	6a 01                	push   $0x1
     d48:	e8 c3 2d 00 00       	call   3b10 <printf>
    return;
     d4d:	83 c4 10             	add    $0x10,%esp
     d50:	eb cd                	jmp    d1f <preempt+0x11f>
     d52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d60 <exitwait>:
{
     d60:	f3 0f 1e fb          	endbr32 
     d64:	55                   	push   %ebp
     d65:	89 e5                	mov    %esp,%ebp
     d67:	56                   	push   %esi
     d68:	be 64 00 00 00       	mov    $0x64,%esi
     d6d:	53                   	push   %ebx
     d6e:	eb 10                	jmp    d80 <exitwait+0x20>
    if(pid){
     d70:	74 68                	je     dda <exitwait+0x7a>
      if(wait() != pid){
     d72:	e8 34 2c 00 00       	call   39ab <wait>
     d77:	39 d8                	cmp    %ebx,%eax
     d79:	75 2d                	jne    da8 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     d7b:	83 ee 01             	sub    $0x1,%esi
     d7e:	74 41                	je     dc1 <exitwait+0x61>
    pid = fork();
     d80:	e8 16 2c 00 00       	call   399b <fork>
     d85:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     d87:	85 c0                	test   %eax,%eax
     d89:	79 e5                	jns    d70 <exitwait+0x10>
      printf(1, "fork failed\n");
     d8b:	83 ec 08             	sub    $0x8,%esp
     d8e:	68 c9 4d 00 00       	push   $0x4dc9
     d93:	6a 01                	push   $0x1
     d95:	e8 76 2d 00 00       	call   3b10 <printf>
      return;
     d9a:	83 c4 10             	add    $0x10,%esp
}
     d9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     da0:	5b                   	pop    %ebx
     da1:	5e                   	pop    %esi
     da2:	5d                   	pop    %ebp
     da3:	c3                   	ret    
     da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     da8:	83 ec 08             	sub    $0x8,%esp
     dab:	68 5b 42 00 00       	push   $0x425b
     db0:	6a 01                	push   $0x1
     db2:	e8 59 2d 00 00       	call   3b10 <printf>
        return;
     db7:	83 c4 10             	add    $0x10,%esp
}
     dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dbd:	5b                   	pop    %ebx
     dbe:	5e                   	pop    %esi
     dbf:	5d                   	pop    %ebp
     dc0:	c3                   	ret    
  printf(1, "exitwait ok\n");
     dc1:	83 ec 08             	sub    $0x8,%esp
     dc4:	68 6b 42 00 00       	push   $0x426b
     dc9:	6a 01                	push   $0x1
     dcb:	e8 40 2d 00 00       	call   3b10 <printf>
     dd0:	83 c4 10             	add    $0x10,%esp
}
     dd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dd6:	5b                   	pop    %ebx
     dd7:	5e                   	pop    %esi
     dd8:	5d                   	pop    %ebp
     dd9:	c3                   	ret    
      exit();
     dda:	e8 c4 2b 00 00       	call   39a3 <exit>
     ddf:	90                   	nop

00000de0 <mem>:
{
     de0:	f3 0f 1e fb          	endbr32 
     de4:	55                   	push   %ebp
     de5:	89 e5                	mov    %esp,%ebp
     de7:	56                   	push   %esi
     de8:	31 f6                	xor    %esi,%esi
     dea:	53                   	push   %ebx
  printf(1, "mem test\n");
     deb:	83 ec 08             	sub    $0x8,%esp
     dee:	68 78 42 00 00       	push   $0x4278
     df3:	6a 01                	push   $0x1
     df5:	e8 16 2d 00 00       	call   3b10 <printf>
  ppid = getpid();
     dfa:	e8 24 2c 00 00       	call   3a23 <getpid>
     dff:	89 c3                	mov    %eax,%ebx
  if((pid = fork()) == 0){
     e01:	e8 95 2b 00 00       	call   399b <fork>
     e06:	83 c4 10             	add    $0x10,%esp
     e09:	85 c0                	test   %eax,%eax
     e0b:	74 0f                	je     e1c <mem+0x3c>
     e0d:	e9 8e 00 00 00       	jmp    ea0 <mem+0xc0>
     e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *(char**)m2 = m1;
     e18:	89 30                	mov    %esi,(%eax)
     e1a:	89 c6                	mov    %eax,%esi
    while((m2 = malloc(10001)) != 0){
     e1c:	83 ec 0c             	sub    $0xc,%esp
     e1f:	68 11 27 00 00       	push   $0x2711
     e24:	e8 47 2f 00 00       	call   3d70 <malloc>
     e29:	83 c4 10             	add    $0x10,%esp
     e2c:	85 c0                	test   %eax,%eax
     e2e:	75 e8                	jne    e18 <mem+0x38>
    while(m1){
     e30:	85 f6                	test   %esi,%esi
     e32:	74 18                	je     e4c <mem+0x6c>
     e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     e38:	89 f0                	mov    %esi,%eax
      free(m1);
     e3a:	83 ec 0c             	sub    $0xc,%esp
      m2 = *(char**)m1;
     e3d:	8b 36                	mov    (%esi),%esi
      free(m1);
     e3f:	50                   	push   %eax
     e40:	e8 9b 2e 00 00       	call   3ce0 <free>
    while(m1){
     e45:	83 c4 10             	add    $0x10,%esp
     e48:	85 f6                	test   %esi,%esi
     e4a:	75 ec                	jne    e38 <mem+0x58>
    m1 = malloc(1024*20);
     e4c:	83 ec 0c             	sub    $0xc,%esp
     e4f:	68 00 50 00 00       	push   $0x5000
     e54:	e8 17 2f 00 00       	call   3d70 <malloc>
    if(m1 == 0){
     e59:	83 c4 10             	add    $0x10,%esp
     e5c:	85 c0                	test   %eax,%eax
     e5e:	74 20                	je     e80 <mem+0xa0>
    free(m1);
     e60:	83 ec 0c             	sub    $0xc,%esp
     e63:	50                   	push   %eax
     e64:	e8 77 2e 00 00       	call   3ce0 <free>
    printf(1, "mem ok\n");
     e69:	58                   	pop    %eax
     e6a:	5a                   	pop    %edx
     e6b:	68 9c 42 00 00       	push   $0x429c
     e70:	6a 01                	push   $0x1
     e72:	e8 99 2c 00 00       	call   3b10 <printf>
    exit();
     e77:	e8 27 2b 00 00       	call   39a3 <exit>
     e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     e80:	83 ec 08             	sub    $0x8,%esp
     e83:	68 82 42 00 00       	push   $0x4282
     e88:	6a 01                	push   $0x1
     e8a:	e8 81 2c 00 00       	call   3b10 <printf>
      kill(ppid);
     e8f:	89 1c 24             	mov    %ebx,(%esp)
     e92:	e8 3c 2b 00 00       	call   39d3 <kill>
      exit();
     e97:	e8 07 2b 00 00       	call   39a3 <exit>
     e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
     ea0:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ea3:	5b                   	pop    %ebx
     ea4:	5e                   	pop    %esi
     ea5:	5d                   	pop    %ebp
    wait();
     ea6:	e9 00 2b 00 00       	jmp    39ab <wait>
     eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     eaf:	90                   	nop

00000eb0 <sharedfd>:
{
     eb0:	f3 0f 1e fb          	endbr32 
     eb4:	55                   	push   %ebp
     eb5:	89 e5                	mov    %esp,%ebp
     eb7:	57                   	push   %edi
     eb8:	56                   	push   %esi
     eb9:	53                   	push   %ebx
     eba:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     ebd:	68 a4 42 00 00       	push   $0x42a4
     ec2:	6a 01                	push   $0x1
     ec4:	e8 47 2c 00 00       	call   3b10 <printf>
  unlink("sharedfd");
     ec9:	c7 04 24 b3 42 00 00 	movl   $0x42b3,(%esp)
     ed0:	e8 1e 2b 00 00       	call   39f3 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ed5:	5b                   	pop    %ebx
     ed6:	5e                   	pop    %esi
     ed7:	68 02 02 00 00       	push   $0x202
     edc:	68 b3 42 00 00       	push   $0x42b3
     ee1:	e8 fd 2a 00 00       	call   39e3 <open>
  if(fd < 0){
     ee6:	83 c4 10             	add    $0x10,%esp
     ee9:	85 c0                	test   %eax,%eax
     eeb:	0f 88 26 01 00 00    	js     1017 <sharedfd+0x167>
     ef1:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ef3:	8d 75 de             	lea    -0x22(%ebp),%esi
     ef6:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     efb:	e8 9b 2a 00 00       	call   399b <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     f00:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     f03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     f06:	19 c0                	sbb    %eax,%eax
     f08:	83 ec 04             	sub    $0x4,%esp
     f0b:	83 e0 f3             	and    $0xfffffff3,%eax
     f0e:	6a 0a                	push   $0xa
     f10:	83 c0 70             	add    $0x70,%eax
     f13:	50                   	push   %eax
     f14:	56                   	push   %esi
     f15:	e8 e6 28 00 00       	call   3800 <memset>
     f1a:	83 c4 10             	add    $0x10,%esp
     f1d:	eb 06                	jmp    f25 <sharedfd+0x75>
     f1f:	90                   	nop
  for(i = 0; i < 1000; i++){
     f20:	83 eb 01             	sub    $0x1,%ebx
     f23:	74 26                	je     f4b <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f25:	83 ec 04             	sub    $0x4,%esp
     f28:	6a 0a                	push   $0xa
     f2a:	56                   	push   %esi
     f2b:	57                   	push   %edi
     f2c:	e8 92 2a 00 00       	call   39c3 <write>
     f31:	83 c4 10             	add    $0x10,%esp
     f34:	83 f8 0a             	cmp    $0xa,%eax
     f37:	74 e7                	je     f20 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     f39:	83 ec 08             	sub    $0x8,%esp
     f3c:	68 b4 4f 00 00       	push   $0x4fb4
     f41:	6a 01                	push   $0x1
     f43:	e8 c8 2b 00 00       	call   3b10 <printf>
      break;
     f48:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     f4b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     f4e:	85 c9                	test   %ecx,%ecx
     f50:	0f 84 f5 00 00 00    	je     104b <sharedfd+0x19b>
    wait();
     f56:	e8 50 2a 00 00       	call   39ab <wait>
  close(fd);
     f5b:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     f5e:	31 db                	xor    %ebx,%ebx
  close(fd);
     f60:	57                   	push   %edi
     f61:	8d 7d e8             	lea    -0x18(%ebp),%edi
     f64:	e8 62 2a 00 00       	call   39cb <close>
  fd = open("sharedfd", 0);
     f69:	58                   	pop    %eax
     f6a:	5a                   	pop    %edx
     f6b:	6a 00                	push   $0x0
     f6d:	68 b3 42 00 00       	push   $0x42b3
     f72:	e8 6c 2a 00 00       	call   39e3 <open>
  if(fd < 0){
     f77:	83 c4 10             	add    $0x10,%esp
  nc = np = 0;
     f7a:	31 d2                	xor    %edx,%edx
  fd = open("sharedfd", 0);
     f7c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
     f7f:	85 c0                	test   %eax,%eax
     f81:	0f 88 aa 00 00 00    	js     1031 <sharedfd+0x181>
     f87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f8e:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f90:	83 ec 04             	sub    $0x4,%esp
     f93:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f96:	6a 0a                	push   $0xa
     f98:	56                   	push   %esi
     f99:	ff 75 d0             	pushl  -0x30(%ebp)
     f9c:	e8 1a 2a 00 00       	call   39bb <read>
     fa1:	83 c4 10             	add    $0x10,%esp
     fa4:	85 c0                	test   %eax,%eax
     fa6:	7e 28                	jle    fd0 <sharedfd+0x120>
    for(i = 0; i < sizeof(buf); i++){
     fa8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     fab:	89 f0                	mov    %esi,%eax
     fad:	eb 13                	jmp    fc2 <sharedfd+0x112>
     faf:	90                   	nop
        np++;
     fb0:	80 f9 70             	cmp    $0x70,%cl
     fb3:	0f 94 c1             	sete   %cl
     fb6:	0f b6 c9             	movzbl %cl,%ecx
     fb9:	01 cb                	add    %ecx,%ebx
    for(i = 0; i < sizeof(buf); i++){
     fbb:	83 c0 01             	add    $0x1,%eax
     fbe:	39 c7                	cmp    %eax,%edi
     fc0:	74 ce                	je     f90 <sharedfd+0xe0>
      if(buf[i] == 'c')
     fc2:	0f b6 08             	movzbl (%eax),%ecx
     fc5:	80 f9 63             	cmp    $0x63,%cl
     fc8:	75 e6                	jne    fb0 <sharedfd+0x100>
        nc++;
     fca:	83 c2 01             	add    $0x1,%edx
      if(buf[i] == 'p')
     fcd:	eb ec                	jmp    fbb <sharedfd+0x10b>
     fcf:	90                   	nop
  close(fd);
     fd0:	83 ec 0c             	sub    $0xc,%esp
     fd3:	ff 75 d0             	pushl  -0x30(%ebp)
     fd6:	e8 f0 29 00 00       	call   39cb <close>
  unlink("sharedfd");
     fdb:	c7 04 24 b3 42 00 00 	movl   $0x42b3,(%esp)
     fe2:	e8 0c 2a 00 00       	call   39f3 <unlink>
  if(nc == 10000 && np == 10000){
     fe7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     fea:	83 c4 10             	add    $0x10,%esp
     fed:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
     ff3:	75 5b                	jne    1050 <sharedfd+0x1a0>
     ff5:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     ffb:	75 53                	jne    1050 <sharedfd+0x1a0>
    printf(1, "sharedfd ok\n");
     ffd:	83 ec 08             	sub    $0x8,%esp
    1000:	68 bc 42 00 00       	push   $0x42bc
    1005:	6a 01                	push   $0x1
    1007:	e8 04 2b 00 00       	call   3b10 <printf>
    100c:	83 c4 10             	add    $0x10,%esp
}
    100f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1012:	5b                   	pop    %ebx
    1013:	5e                   	pop    %esi
    1014:	5f                   	pop    %edi
    1015:	5d                   	pop    %ebp
    1016:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
    1017:	83 ec 08             	sub    $0x8,%esp
    101a:	68 88 4f 00 00       	push   $0x4f88
    101f:	6a 01                	push   $0x1
    1021:	e8 ea 2a 00 00       	call   3b10 <printf>
    return;
    1026:	83 c4 10             	add    $0x10,%esp
}
    1029:	8d 65 f4             	lea    -0xc(%ebp),%esp
    102c:	5b                   	pop    %ebx
    102d:	5e                   	pop    %esi
    102e:	5f                   	pop    %edi
    102f:	5d                   	pop    %ebp
    1030:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1031:	83 ec 08             	sub    $0x8,%esp
    1034:	68 d4 4f 00 00       	push   $0x4fd4
    1039:	6a 01                	push   $0x1
    103b:	e8 d0 2a 00 00       	call   3b10 <printf>
    return;
    1040:	83 c4 10             	add    $0x10,%esp
}
    1043:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1046:	5b                   	pop    %ebx
    1047:	5e                   	pop    %esi
    1048:	5f                   	pop    %edi
    1049:	5d                   	pop    %ebp
    104a:	c3                   	ret    
    exit();
    104b:	e8 53 29 00 00       	call   39a3 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1050:	53                   	push   %ebx
    1051:	52                   	push   %edx
    1052:	68 c9 42 00 00       	push   $0x42c9
    1057:	6a 01                	push   $0x1
    1059:	e8 b2 2a 00 00       	call   3b10 <printf>
    exit();
    105e:	e8 40 29 00 00       	call   39a3 <exit>
    1063:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001070 <fourfiles>:
{
    1070:	f3 0f 1e fb          	endbr32 
    1074:	55                   	push   %ebp
    1075:	89 e5                	mov    %esp,%ebp
    1077:	57                   	push   %edi
    1078:	56                   	push   %esi
  printf(1, "fourfiles test\n");
    1079:	be de 42 00 00       	mov    $0x42de,%esi
{
    107e:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    107f:	31 db                	xor    %ebx,%ebx
{
    1081:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    1084:	c7 45 d8 de 42 00 00 	movl   $0x42de,-0x28(%ebp)
  printf(1, "fourfiles test\n");
    108b:	68 e4 42 00 00       	push   $0x42e4
    1090:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    1092:	c7 45 dc 37 44 00 00 	movl   $0x4437,-0x24(%ebp)
    1099:	c7 45 e0 3b 44 00 00 	movl   $0x443b,-0x20(%ebp)
    10a0:	c7 45 e4 e1 42 00 00 	movl   $0x42e1,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    10a7:	e8 64 2a 00 00       	call   3b10 <printf>
    10ac:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    10af:	83 ec 0c             	sub    $0xc,%esp
    10b2:	56                   	push   %esi
    10b3:	e8 3b 29 00 00       	call   39f3 <unlink>
    pid = fork();
    10b8:	e8 de 28 00 00       	call   399b <fork>
    if(pid < 0){
    10bd:	83 c4 10             	add    $0x10,%esp
    10c0:	85 c0                	test   %eax,%eax
    10c2:	0f 88 80 01 00 00    	js     1248 <fourfiles+0x1d8>
    if(pid == 0){
    10c8:	0f 84 05 01 00 00    	je     11d3 <fourfiles+0x163>
  for(pi = 0; pi < 4; pi++){
    10ce:	83 c3 01             	add    $0x1,%ebx
    10d1:	83 fb 04             	cmp    $0x4,%ebx
    10d4:	74 06                	je     10dc <fourfiles+0x6c>
    10d6:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    10da:	eb d3                	jmp    10af <fourfiles+0x3f>
    wait();
    10dc:	e8 ca 28 00 00       	call   39ab <wait>
  for(i = 0; i < 2; i++){
    10e1:	31 f6                	xor    %esi,%esi
    wait();
    10e3:	e8 c3 28 00 00       	call   39ab <wait>
    10e8:	e8 be 28 00 00       	call   39ab <wait>
    10ed:	e8 b9 28 00 00       	call   39ab <wait>
    fname = names[i];
    10f2:	8b 44 b5 d8          	mov    -0x28(%ebp,%esi,4),%eax
    fd = open(fname, 0);
    10f6:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    10f9:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    10fb:	6a 00                	push   $0x0
    10fd:	50                   	push   %eax
    fname = names[i];
    10fe:	89 45 cc             	mov    %eax,-0x34(%ebp)
    fd = open(fname, 0);
    1101:	e8 dd 28 00 00       	call   39e3 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1106:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    1109:	89 45 d0             	mov    %eax,-0x30(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1110:	83 ec 04             	sub    $0x4,%esp
    1113:	68 00 20 00 00       	push   $0x2000
    1118:	68 00 87 00 00       	push   $0x8700
    111d:	ff 75 d0             	pushl  -0x30(%ebp)
    1120:	e8 96 28 00 00       	call   39bb <read>
    1125:	83 c4 10             	add    $0x10,%esp
    1128:	85 c0                	test   %eax,%eax
    112a:	7e 42                	jle    116e <fourfiles+0xfe>
      printf(1, "bytes read: %d\n", n);
    112c:	83 ec 04             	sub    $0x4,%esp
    112f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1132:	50                   	push   %eax
    1133:	68 05 43 00 00       	push   $0x4305
    1138:	6a 01                	push   $0x1
    113a:	e8 d1 29 00 00       	call   3b10 <printf>
      for(j = 0; j < n; j++){
    113f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      printf(1, "bytes read: %d\n", n);
    1142:	83 c4 10             	add    $0x10,%esp
      for(j = 0; j < n; j++){
    1145:	31 d2                	xor    %edx,%edx
    1147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    114e:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    1150:	83 fe 01             	cmp    $0x1,%esi
    1153:	0f be ba 00 87 00 00 	movsbl 0x8700(%edx),%edi
    115a:	19 c9                	sbb    %ecx,%ecx
    115c:	83 c1 31             	add    $0x31,%ecx
    115f:	39 cf                	cmp    %ecx,%edi
    1161:	75 5c                	jne    11bf <fourfiles+0x14f>
      for(j = 0; j < n; j++){
    1163:	83 c2 01             	add    $0x1,%edx
    1166:	39 d0                	cmp    %edx,%eax
    1168:	75 e6                	jne    1150 <fourfiles+0xe0>
      total += n;
    116a:	01 c3                	add    %eax,%ebx
    116c:	eb a2                	jmp    1110 <fourfiles+0xa0>
    close(fd);
    116e:	83 ec 0c             	sub    $0xc,%esp
    1171:	ff 75 d0             	pushl  -0x30(%ebp)
    1174:	e8 52 28 00 00       	call   39cb <close>
    if(total != 12*500){
    1179:	83 c4 10             	add    $0x10,%esp
    117c:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1182:	0f 85 d4 00 00 00    	jne    125c <fourfiles+0x1ec>
    unlink(fname);
    1188:	83 ec 0c             	sub    $0xc,%esp
    118b:	ff 75 cc             	pushl  -0x34(%ebp)
    118e:	e8 60 28 00 00       	call   39f3 <unlink>
  for(i = 0; i < 2; i++){
    1193:	83 c4 10             	add    $0x10,%esp
    1196:	83 fe 01             	cmp    $0x1,%esi
    1199:	75 1a                	jne    11b5 <fourfiles+0x145>
  printf(1, "fourfiles ok\n");
    119b:	83 ec 08             	sub    $0x8,%esp
    119e:	68 32 43 00 00       	push   $0x4332
    11a3:	6a 01                	push   $0x1
    11a5:	e8 66 29 00 00       	call   3b10 <printf>
}
    11aa:	83 c4 10             	add    $0x10,%esp
    11ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11b0:	5b                   	pop    %ebx
    11b1:	5e                   	pop    %esi
    11b2:	5f                   	pop    %edi
    11b3:	5d                   	pop    %ebp
    11b4:	c3                   	ret    
    11b5:	be 01 00 00 00       	mov    $0x1,%esi
    11ba:	e9 33 ff ff ff       	jmp    10f2 <fourfiles+0x82>
          printf(1, "wrong char\n");
    11bf:	83 ec 08             	sub    $0x8,%esp
    11c2:	68 15 43 00 00       	push   $0x4315
    11c7:	6a 01                	push   $0x1
    11c9:	e8 42 29 00 00       	call   3b10 <printf>
          exit();
    11ce:	e8 d0 27 00 00       	call   39a3 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    11d3:	83 ec 08             	sub    $0x8,%esp
    11d6:	68 02 02 00 00       	push   $0x202
    11db:	56                   	push   %esi
    11dc:	e8 02 28 00 00       	call   39e3 <open>
      if(fd < 0){
    11e1:	83 c4 10             	add    $0x10,%esp
      fd = open(fname, O_CREATE | O_RDWR);
    11e4:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    11e6:	85 c0                	test   %eax,%eax
    11e8:	78 45                	js     122f <fourfiles+0x1bf>
      memset(buf, '0'+pi, 512);
    11ea:	83 ec 04             	sub    $0x4,%esp
    11ed:	83 c3 30             	add    $0x30,%ebx
    11f0:	68 00 02 00 00       	push   $0x200
    11f5:	53                   	push   %ebx
    11f6:	bb 0c 00 00 00       	mov    $0xc,%ebx
    11fb:	68 00 87 00 00       	push   $0x8700
    1200:	e8 fb 25 00 00       	call   3800 <memset>
    1205:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    1208:	83 ec 04             	sub    $0x4,%esp
    120b:	68 f4 01 00 00       	push   $0x1f4
    1210:	68 00 87 00 00       	push   $0x8700
    1215:	56                   	push   %esi
    1216:	e8 a8 27 00 00       	call   39c3 <write>
    121b:	83 c4 10             	add    $0x10,%esp
    121e:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1223:	75 4a                	jne    126f <fourfiles+0x1ff>
      for(i = 0; i < 12; i++){
    1225:	83 eb 01             	sub    $0x1,%ebx
    1228:	75 de                	jne    1208 <fourfiles+0x198>
      exit();
    122a:	e8 74 27 00 00       	call   39a3 <exit>
        printf(1, "create failed\n");
    122f:	51                   	push   %ecx
    1230:	51                   	push   %ecx
    1231:	68 8f 45 00 00       	push   $0x458f
    1236:	6a 01                	push   $0x1
    1238:	e8 d3 28 00 00       	call   3b10 <printf>
        exit();
    123d:	e8 61 27 00 00       	call   39a3 <exit>
    1242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
    1248:	83 ec 08             	sub    $0x8,%esp
    124b:	68 c9 4d 00 00       	push   $0x4dc9
    1250:	6a 01                	push   $0x1
    1252:	e8 b9 28 00 00       	call   3b10 <printf>
      exit();
    1257:	e8 47 27 00 00       	call   39a3 <exit>
      printf(1, "wrong length %d\n", total);
    125c:	50                   	push   %eax
    125d:	53                   	push   %ebx
    125e:	68 21 43 00 00       	push   $0x4321
    1263:	6a 01                	push   $0x1
    1265:	e8 a6 28 00 00       	call   3b10 <printf>
      exit();
    126a:	e8 34 27 00 00       	call   39a3 <exit>
          printf(1, "write failed %d\n", n);
    126f:	52                   	push   %edx
    1270:	50                   	push   %eax
    1271:	68 f4 42 00 00       	push   $0x42f4
    1276:	6a 01                	push   $0x1
    1278:	e8 93 28 00 00       	call   3b10 <printf>
          exit();
    127d:	e8 21 27 00 00       	call   39a3 <exit>
    1282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001290 <createdelete>:
{
    1290:	f3 0f 1e fb          	endbr32 
    1294:	55                   	push   %ebp
    1295:	89 e5                	mov    %esp,%ebp
    1297:	57                   	push   %edi
    1298:	56                   	push   %esi
    1299:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    129a:	31 db                	xor    %ebx,%ebx
{
    129c:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    129f:	68 40 43 00 00       	push   $0x4340
    12a4:	6a 01                	push   $0x1
    12a6:	e8 65 28 00 00       	call   3b10 <printf>
    12ab:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    12ae:	e8 e8 26 00 00       	call   399b <fork>
    if(pid < 0){
    12b3:	85 c0                	test   %eax,%eax
    12b5:	0f 88 ce 01 00 00    	js     1489 <createdelete+0x1f9>
    if(pid == 0){
    12bb:	0f 84 17 01 00 00    	je     13d8 <createdelete+0x148>
  for(pi = 0; pi < 4; pi++){
    12c1:	83 c3 01             	add    $0x1,%ebx
    12c4:	83 fb 04             	cmp    $0x4,%ebx
    12c7:	75 e5                	jne    12ae <createdelete+0x1e>
    wait();
    12c9:	e8 dd 26 00 00       	call   39ab <wait>
    12ce:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    12d1:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    12d6:	e8 d0 26 00 00       	call   39ab <wait>
    12db:	e8 cb 26 00 00       	call   39ab <wait>
    12e0:	e8 c6 26 00 00       	call   39ab <wait>
  name[0] = name[1] = name[2] = 0;
    12e5:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    12e9:	89 7d c0             	mov    %edi,-0x40(%ebp)
    12ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(pi = 0; pi < 4; pi++){
    12f0:	8d 46 31             	lea    0x31(%esi),%eax
    12f3:	89 f7                	mov    %esi,%edi
    12f5:	83 c6 01             	add    $0x1,%esi
    12f8:	83 fe 09             	cmp    $0x9,%esi
    12fb:	88 45 c7             	mov    %al,-0x39(%ebp)
    12fe:	0f 9f c3             	setg   %bl
    1301:	85 f6                	test   %esi,%esi
    1303:	0f 94 c0             	sete   %al
    1306:	09 c3                	or     %eax,%ebx
    1308:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    130b:	bb 70 00 00 00       	mov    $0x70,%ebx
      fd = open(name, 0);
    1310:	83 ec 08             	sub    $0x8,%esp
      name[1] = '0' + i;
    1313:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      name[0] = 'p' + pi;
    1317:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    131a:	6a 00                	push   $0x0
    131c:	ff 75 c0             	pushl  -0x40(%ebp)
      name[1] = '0' + i;
    131f:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1322:	e8 bc 26 00 00       	call   39e3 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1327:	83 c4 10             	add    $0x10,%esp
    132a:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    132e:	0f 84 8c 00 00 00    	je     13c0 <createdelete+0x130>
    1334:	85 c0                	test   %eax,%eax
    1336:	0f 88 21 01 00 00    	js     145d <createdelete+0x1cd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    133c:	83 ff 08             	cmp    $0x8,%edi
    133f:	0f 86 60 01 00 00    	jbe    14a5 <createdelete+0x215>
        close(fd);
    1345:	83 ec 0c             	sub    $0xc,%esp
    1348:	50                   	push   %eax
    1349:	e8 7d 26 00 00       	call   39cb <close>
    134e:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1351:	83 c3 01             	add    $0x1,%ebx
    1354:	80 fb 74             	cmp    $0x74,%bl
    1357:	75 b7                	jne    1310 <createdelete+0x80>
  for(i = 0; i < N; i++){
    1359:	83 fe 13             	cmp    $0x13,%esi
    135c:	75 92                	jne    12f0 <createdelete+0x60>
    135e:	8b 7d c0             	mov    -0x40(%ebp),%edi
    1361:	be 70 00 00 00       	mov    $0x70,%esi
    1366:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    136d:	8d 76 00             	lea    0x0(%esi),%esi
    for(pi = 0; pi < 4; pi++){
    1370:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    1373:	bb 04 00 00 00       	mov    $0x4,%ebx
    1378:	88 45 c7             	mov    %al,-0x39(%ebp)
      unlink(name);
    137b:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    137e:	89 f0                	mov    %esi,%eax
      unlink(name);
    1380:	57                   	push   %edi
      name[0] = 'p' + i;
    1381:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1384:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    1388:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    138b:	e8 63 26 00 00       	call   39f3 <unlink>
    for(pi = 0; pi < 4; pi++){
    1390:	83 c4 10             	add    $0x10,%esp
    1393:	83 eb 01             	sub    $0x1,%ebx
    1396:	75 e3                	jne    137b <createdelete+0xeb>
  for(i = 0; i < N; i++){
    1398:	83 c6 01             	add    $0x1,%esi
    139b:	89 f0                	mov    %esi,%eax
    139d:	3c 84                	cmp    $0x84,%al
    139f:	75 cf                	jne    1370 <createdelete+0xe0>
  printf(1, "createdelete ok\n");
    13a1:	83 ec 08             	sub    $0x8,%esp
    13a4:	68 53 43 00 00       	push   $0x4353
    13a9:	6a 01                	push   $0x1
    13ab:	e8 60 27 00 00       	call   3b10 <printf>
}
    13b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13b3:	5b                   	pop    %ebx
    13b4:	5e                   	pop    %esi
    13b5:	5f                   	pop    %edi
    13b6:	5d                   	pop    %ebp
    13b7:	c3                   	ret    
    13b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13bf:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    13c0:	83 ff 08             	cmp    $0x8,%edi
    13c3:	0f 86 d4 00 00 00    	jbe    149d <createdelete+0x20d>
      if(fd >= 0)
    13c9:	85 c0                	test   %eax,%eax
    13cb:	78 84                	js     1351 <createdelete+0xc1>
    13cd:	e9 73 ff ff ff       	jmp    1345 <createdelete+0xb5>
    13d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    13d8:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    13db:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13df:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    13e2:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    13e5:	31 db                	xor    %ebx,%ebx
    13e7:	eb 0f                	jmp    13f8 <createdelete+0x168>
    13e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    13f0:	83 fb 13             	cmp    $0x13,%ebx
    13f3:	74 63                	je     1458 <createdelete+0x1c8>
    13f5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    13f8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    13fb:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    13fe:	68 02 02 00 00       	push   $0x202
    1403:	57                   	push   %edi
        name[1] = '0' + i;
    1404:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    1407:	e8 d7 25 00 00       	call   39e3 <open>
        if(fd < 0){
    140c:	83 c4 10             	add    $0x10,%esp
    140f:	85 c0                	test   %eax,%eax
    1411:	78 62                	js     1475 <createdelete+0x1e5>
        close(fd);
    1413:	83 ec 0c             	sub    $0xc,%esp
    1416:	50                   	push   %eax
    1417:	e8 af 25 00 00       	call   39cb <close>
        if(i > 0 && (i % 2 ) == 0){
    141c:	83 c4 10             	add    $0x10,%esp
    141f:	85 db                	test   %ebx,%ebx
    1421:	74 d2                	je     13f5 <createdelete+0x165>
    1423:	f6 c3 01             	test   $0x1,%bl
    1426:	75 c8                	jne    13f0 <createdelete+0x160>
          if(unlink(name) < 0){
    1428:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    142b:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
    142d:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    142e:	d1 f8                	sar    %eax
    1430:	83 c0 30             	add    $0x30,%eax
    1433:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1436:	e8 b8 25 00 00       	call   39f3 <unlink>
    143b:	83 c4 10             	add    $0x10,%esp
    143e:	85 c0                	test   %eax,%eax
    1440:	79 ae                	jns    13f0 <createdelete+0x160>
            printf(1, "unlink failed\n");
    1442:	52                   	push   %edx
    1443:	52                   	push   %edx
    1444:	68 31 3f 00 00       	push   $0x3f31
    1449:	6a 01                	push   $0x1
    144b:	e8 c0 26 00 00       	call   3b10 <printf>
            exit();
    1450:	e8 4e 25 00 00       	call   39a3 <exit>
    1455:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    1458:	e8 46 25 00 00       	call   39a3 <exit>
    145d:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s didn't exist\n", name);
    1460:	83 ec 04             	sub    $0x4,%esp
    1463:	57                   	push   %edi
    1464:	68 00 50 00 00       	push   $0x5000
    1469:	6a 01                	push   $0x1
    146b:	e8 a0 26 00 00       	call   3b10 <printf>
        exit();
    1470:	e8 2e 25 00 00       	call   39a3 <exit>
          printf(1, "create failed\n");
    1475:	83 ec 08             	sub    $0x8,%esp
    1478:	68 8f 45 00 00       	push   $0x458f
    147d:	6a 01                	push   $0x1
    147f:	e8 8c 26 00 00       	call   3b10 <printf>
          exit();
    1484:	e8 1a 25 00 00       	call   39a3 <exit>
      printf(1, "fork failed\n");
    1489:	83 ec 08             	sub    $0x8,%esp
    148c:	68 c9 4d 00 00       	push   $0x4dc9
    1491:	6a 01                	push   $0x1
    1493:	e8 78 26 00 00       	call   3b10 <printf>
      exit();
    1498:	e8 06 25 00 00       	call   39a3 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    149d:	85 c0                	test   %eax,%eax
    149f:	0f 88 ac fe ff ff    	js     1351 <createdelete+0xc1>
    14a5:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s did exist\n", name);
    14a8:	50                   	push   %eax
    14a9:	57                   	push   %edi
    14aa:	68 24 50 00 00       	push   $0x5024
    14af:	6a 01                	push   $0x1
    14b1:	e8 5a 26 00 00       	call   3b10 <printf>
        exit();
    14b6:	e8 e8 24 00 00       	call   39a3 <exit>
    14bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    14bf:	90                   	nop

000014c0 <unlinkread>:
{
    14c0:	f3 0f 1e fb          	endbr32 
    14c4:	55                   	push   %ebp
    14c5:	89 e5                	mov    %esp,%ebp
    14c7:	56                   	push   %esi
    14c8:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    14c9:	83 ec 08             	sub    $0x8,%esp
    14cc:	68 64 43 00 00       	push   $0x4364
    14d1:	6a 01                	push   $0x1
    14d3:	e8 38 26 00 00       	call   3b10 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    14d8:	5b                   	pop    %ebx
    14d9:	5e                   	pop    %esi
    14da:	68 02 02 00 00       	push   $0x202
    14df:	68 75 43 00 00       	push   $0x4375
    14e4:	e8 fa 24 00 00       	call   39e3 <open>
  if(fd < 0){
    14e9:	83 c4 10             	add    $0x10,%esp
    14ec:	85 c0                	test   %eax,%eax
    14ee:	0f 88 e6 00 00 00    	js     15da <unlinkread+0x11a>
  write(fd, "hello", 5);
    14f4:	83 ec 04             	sub    $0x4,%esp
    14f7:	89 c3                	mov    %eax,%ebx
    14f9:	6a 05                	push   $0x5
    14fb:	68 9a 43 00 00       	push   $0x439a
    1500:	50                   	push   %eax
    1501:	e8 bd 24 00 00       	call   39c3 <write>
  close(fd);
    1506:	89 1c 24             	mov    %ebx,(%esp)
    1509:	e8 bd 24 00 00       	call   39cb <close>
  fd = open("unlinkread", O_RDWR);
    150e:	58                   	pop    %eax
    150f:	5a                   	pop    %edx
    1510:	6a 02                	push   $0x2
    1512:	68 75 43 00 00       	push   $0x4375
    1517:	e8 c7 24 00 00       	call   39e3 <open>
  if(fd < 0){
    151c:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_RDWR);
    151f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1521:	85 c0                	test   %eax,%eax
    1523:	0f 88 10 01 00 00    	js     1639 <unlinkread+0x179>
  if(unlink("unlinkread") != 0){
    1529:	83 ec 0c             	sub    $0xc,%esp
    152c:	68 75 43 00 00       	push   $0x4375
    1531:	e8 bd 24 00 00       	call   39f3 <unlink>
    1536:	83 c4 10             	add    $0x10,%esp
    1539:	85 c0                	test   %eax,%eax
    153b:	0f 85 e5 00 00 00    	jne    1626 <unlinkread+0x166>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1541:	83 ec 08             	sub    $0x8,%esp
    1544:	68 02 02 00 00       	push   $0x202
    1549:	68 75 43 00 00       	push   $0x4375
    154e:	e8 90 24 00 00       	call   39e3 <open>
  write(fd1, "yyy", 3);
    1553:	83 c4 0c             	add    $0xc,%esp
    1556:	6a 03                	push   $0x3
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1558:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    155a:	68 d2 43 00 00       	push   $0x43d2
    155f:	50                   	push   %eax
    1560:	e8 5e 24 00 00       	call   39c3 <write>
  close(fd1);
    1565:	89 34 24             	mov    %esi,(%esp)
    1568:	e8 5e 24 00 00       	call   39cb <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    156d:	83 c4 0c             	add    $0xc,%esp
    1570:	68 00 20 00 00       	push   $0x2000
    1575:	68 00 87 00 00       	push   $0x8700
    157a:	53                   	push   %ebx
    157b:	e8 3b 24 00 00       	call   39bb <read>
    1580:	83 c4 10             	add    $0x10,%esp
    1583:	83 f8 05             	cmp    $0x5,%eax
    1586:	0f 85 87 00 00 00    	jne    1613 <unlinkread+0x153>
  if(buf[0] != 'h'){
    158c:	80 3d 00 87 00 00 68 	cmpb   $0x68,0x8700
    1593:	75 6b                	jne    1600 <unlinkread+0x140>
  if(write(fd, buf, 10) != 10){
    1595:	83 ec 04             	sub    $0x4,%esp
    1598:	6a 0a                	push   $0xa
    159a:	68 00 87 00 00       	push   $0x8700
    159f:	53                   	push   %ebx
    15a0:	e8 1e 24 00 00       	call   39c3 <write>
    15a5:	83 c4 10             	add    $0x10,%esp
    15a8:	83 f8 0a             	cmp    $0xa,%eax
    15ab:	75 40                	jne    15ed <unlinkread+0x12d>
  close(fd);
    15ad:	83 ec 0c             	sub    $0xc,%esp
    15b0:	53                   	push   %ebx
    15b1:	e8 15 24 00 00       	call   39cb <close>
  unlink("unlinkread");
    15b6:	c7 04 24 75 43 00 00 	movl   $0x4375,(%esp)
    15bd:	e8 31 24 00 00       	call   39f3 <unlink>
  printf(1, "unlinkread ok\n");
    15c2:	58                   	pop    %eax
    15c3:	5a                   	pop    %edx
    15c4:	68 1d 44 00 00       	push   $0x441d
    15c9:	6a 01                	push   $0x1
    15cb:	e8 40 25 00 00       	call   3b10 <printf>
}
    15d0:	83 c4 10             	add    $0x10,%esp
    15d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    15d6:	5b                   	pop    %ebx
    15d7:	5e                   	pop    %esi
    15d8:	5d                   	pop    %ebp
    15d9:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    15da:	51                   	push   %ecx
    15db:	51                   	push   %ecx
    15dc:	68 80 43 00 00       	push   $0x4380
    15e1:	6a 01                	push   $0x1
    15e3:	e8 28 25 00 00       	call   3b10 <printf>
    exit();
    15e8:	e8 b6 23 00 00       	call   39a3 <exit>
    printf(1, "unlinkread write failed\n");
    15ed:	51                   	push   %ecx
    15ee:	51                   	push   %ecx
    15ef:	68 04 44 00 00       	push   $0x4404
    15f4:	6a 01                	push   $0x1
    15f6:	e8 15 25 00 00       	call   3b10 <printf>
    exit();
    15fb:	e8 a3 23 00 00       	call   39a3 <exit>
    printf(1, "unlinkread wrong data\n");
    1600:	53                   	push   %ebx
    1601:	53                   	push   %ebx
    1602:	68 ed 43 00 00       	push   $0x43ed
    1607:	6a 01                	push   $0x1
    1609:	e8 02 25 00 00       	call   3b10 <printf>
    exit();
    160e:	e8 90 23 00 00       	call   39a3 <exit>
    printf(1, "unlinkread read failed");
    1613:	56                   	push   %esi
    1614:	56                   	push   %esi
    1615:	68 d6 43 00 00       	push   $0x43d6
    161a:	6a 01                	push   $0x1
    161c:	e8 ef 24 00 00       	call   3b10 <printf>
    exit();
    1621:	e8 7d 23 00 00       	call   39a3 <exit>
    printf(1, "unlink unlinkread failed\n");
    1626:	50                   	push   %eax
    1627:	50                   	push   %eax
    1628:	68 b8 43 00 00       	push   $0x43b8
    162d:	6a 01                	push   $0x1
    162f:	e8 dc 24 00 00       	call   3b10 <printf>
    exit();
    1634:	e8 6a 23 00 00       	call   39a3 <exit>
    printf(1, "open unlinkread failed\n");
    1639:	50                   	push   %eax
    163a:	50                   	push   %eax
    163b:	68 a0 43 00 00       	push   $0x43a0
    1640:	6a 01                	push   $0x1
    1642:	e8 c9 24 00 00       	call   3b10 <printf>
    exit();
    1647:	e8 57 23 00 00       	call   39a3 <exit>
    164c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001650 <linktest>:
{
    1650:	f3 0f 1e fb          	endbr32 
    1654:	55                   	push   %ebp
    1655:	89 e5                	mov    %esp,%ebp
    1657:	53                   	push   %ebx
    1658:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    165b:	68 2c 44 00 00       	push   $0x442c
    1660:	6a 01                	push   $0x1
    1662:	e8 a9 24 00 00       	call   3b10 <printf>
  unlink("lf1");
    1667:	c7 04 24 36 44 00 00 	movl   $0x4436,(%esp)
    166e:	e8 80 23 00 00       	call   39f3 <unlink>
  unlink("lf2");
    1673:	c7 04 24 3a 44 00 00 	movl   $0x443a,(%esp)
    167a:	e8 74 23 00 00       	call   39f3 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    167f:	58                   	pop    %eax
    1680:	5a                   	pop    %edx
    1681:	68 02 02 00 00       	push   $0x202
    1686:	68 36 44 00 00       	push   $0x4436
    168b:	e8 53 23 00 00       	call   39e3 <open>
  if(fd < 0){
    1690:	83 c4 10             	add    $0x10,%esp
    1693:	85 c0                	test   %eax,%eax
    1695:	0f 88 1e 01 00 00    	js     17b9 <linktest+0x169>
  if(write(fd, "hello", 5) != 5){
    169b:	83 ec 04             	sub    $0x4,%esp
    169e:	89 c3                	mov    %eax,%ebx
    16a0:	6a 05                	push   $0x5
    16a2:	68 9a 43 00 00       	push   $0x439a
    16a7:	50                   	push   %eax
    16a8:	e8 16 23 00 00       	call   39c3 <write>
    16ad:	83 c4 10             	add    $0x10,%esp
    16b0:	83 f8 05             	cmp    $0x5,%eax
    16b3:	0f 85 98 01 00 00    	jne    1851 <linktest+0x201>
  close(fd);
    16b9:	83 ec 0c             	sub    $0xc,%esp
    16bc:	53                   	push   %ebx
    16bd:	e8 09 23 00 00       	call   39cb <close>
  if(link("lf1", "lf2") < 0){
    16c2:	5b                   	pop    %ebx
    16c3:	58                   	pop    %eax
    16c4:	68 3a 44 00 00       	push   $0x443a
    16c9:	68 36 44 00 00       	push   $0x4436
    16ce:	e8 30 23 00 00       	call   3a03 <link>
    16d3:	83 c4 10             	add    $0x10,%esp
    16d6:	85 c0                	test   %eax,%eax
    16d8:	0f 88 60 01 00 00    	js     183e <linktest+0x1ee>
  unlink("lf1");
    16de:	83 ec 0c             	sub    $0xc,%esp
    16e1:	68 36 44 00 00       	push   $0x4436
    16e6:	e8 08 23 00 00       	call   39f3 <unlink>
  if(open("lf1", 0) >= 0){
    16eb:	58                   	pop    %eax
    16ec:	5a                   	pop    %edx
    16ed:	6a 00                	push   $0x0
    16ef:	68 36 44 00 00       	push   $0x4436
    16f4:	e8 ea 22 00 00       	call   39e3 <open>
    16f9:	83 c4 10             	add    $0x10,%esp
    16fc:	85 c0                	test   %eax,%eax
    16fe:	0f 89 27 01 00 00    	jns    182b <linktest+0x1db>
  fd = open("lf2", 0);
    1704:	83 ec 08             	sub    $0x8,%esp
    1707:	6a 00                	push   $0x0
    1709:	68 3a 44 00 00       	push   $0x443a
    170e:	e8 d0 22 00 00       	call   39e3 <open>
  if(fd < 0){
    1713:	83 c4 10             	add    $0x10,%esp
  fd = open("lf2", 0);
    1716:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1718:	85 c0                	test   %eax,%eax
    171a:	0f 88 f8 00 00 00    	js     1818 <linktest+0x1c8>
  if(read(fd, buf, sizeof(buf)) != 5){
    1720:	83 ec 04             	sub    $0x4,%esp
    1723:	68 00 20 00 00       	push   $0x2000
    1728:	68 00 87 00 00       	push   $0x8700
    172d:	50                   	push   %eax
    172e:	e8 88 22 00 00       	call   39bb <read>
    1733:	83 c4 10             	add    $0x10,%esp
    1736:	83 f8 05             	cmp    $0x5,%eax
    1739:	0f 85 c6 00 00 00    	jne    1805 <linktest+0x1b5>
  close(fd);
    173f:	83 ec 0c             	sub    $0xc,%esp
    1742:	53                   	push   %ebx
    1743:	e8 83 22 00 00       	call   39cb <close>
  if(link("lf2", "lf2") >= 0){
    1748:	58                   	pop    %eax
    1749:	5a                   	pop    %edx
    174a:	68 3a 44 00 00       	push   $0x443a
    174f:	68 3a 44 00 00       	push   $0x443a
    1754:	e8 aa 22 00 00       	call   3a03 <link>
    1759:	83 c4 10             	add    $0x10,%esp
    175c:	85 c0                	test   %eax,%eax
    175e:	0f 89 8e 00 00 00    	jns    17f2 <linktest+0x1a2>
  unlink("lf2");
    1764:	83 ec 0c             	sub    $0xc,%esp
    1767:	68 3a 44 00 00       	push   $0x443a
    176c:	e8 82 22 00 00       	call   39f3 <unlink>
  if(link("lf2", "lf1") >= 0){
    1771:	59                   	pop    %ecx
    1772:	5b                   	pop    %ebx
    1773:	68 36 44 00 00       	push   $0x4436
    1778:	68 3a 44 00 00       	push   $0x443a
    177d:	e8 81 22 00 00       	call   3a03 <link>
    1782:	83 c4 10             	add    $0x10,%esp
    1785:	85 c0                	test   %eax,%eax
    1787:	79 56                	jns    17df <linktest+0x18f>
  if(link(".", "lf1") >= 0){
    1789:	83 ec 08             	sub    $0x8,%esp
    178c:	68 36 44 00 00       	push   $0x4436
    1791:	68 fe 46 00 00       	push   $0x46fe
    1796:	e8 68 22 00 00       	call   3a03 <link>
    179b:	83 c4 10             	add    $0x10,%esp
    179e:	85 c0                	test   %eax,%eax
    17a0:	79 2a                	jns    17cc <linktest+0x17c>
  printf(1, "linktest ok\n");
    17a2:	83 ec 08             	sub    $0x8,%esp
    17a5:	68 d4 44 00 00       	push   $0x44d4
    17aa:	6a 01                	push   $0x1
    17ac:	e8 5f 23 00 00       	call   3b10 <printf>
}
    17b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    17b4:	83 c4 10             	add    $0x10,%esp
    17b7:	c9                   	leave  
    17b8:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    17b9:	50                   	push   %eax
    17ba:	50                   	push   %eax
    17bb:	68 3e 44 00 00       	push   $0x443e
    17c0:	6a 01                	push   $0x1
    17c2:	e8 49 23 00 00       	call   3b10 <printf>
    exit();
    17c7:	e8 d7 21 00 00       	call   39a3 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    17cc:	50                   	push   %eax
    17cd:	50                   	push   %eax
    17ce:	68 b8 44 00 00       	push   $0x44b8
    17d3:	6a 01                	push   $0x1
    17d5:	e8 36 23 00 00       	call   3b10 <printf>
    exit();
    17da:	e8 c4 21 00 00       	call   39a3 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    17df:	52                   	push   %edx
    17e0:	52                   	push   %edx
    17e1:	68 6c 50 00 00       	push   $0x506c
    17e6:	6a 01                	push   $0x1
    17e8:	e8 23 23 00 00       	call   3b10 <printf>
    exit();
    17ed:	e8 b1 21 00 00       	call   39a3 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    17f2:	50                   	push   %eax
    17f3:	50                   	push   %eax
    17f4:	68 9a 44 00 00       	push   $0x449a
    17f9:	6a 01                	push   $0x1
    17fb:	e8 10 23 00 00       	call   3b10 <printf>
    exit();
    1800:	e8 9e 21 00 00       	call   39a3 <exit>
    printf(1, "read lf2 failed\n");
    1805:	51                   	push   %ecx
    1806:	51                   	push   %ecx
    1807:	68 89 44 00 00       	push   $0x4489
    180c:	6a 01                	push   $0x1
    180e:	e8 fd 22 00 00       	call   3b10 <printf>
    exit();
    1813:	e8 8b 21 00 00       	call   39a3 <exit>
    printf(1, "open lf2 failed\n");
    1818:	53                   	push   %ebx
    1819:	53                   	push   %ebx
    181a:	68 78 44 00 00       	push   $0x4478
    181f:	6a 01                	push   $0x1
    1821:	e8 ea 22 00 00       	call   3b10 <printf>
    exit();
    1826:	e8 78 21 00 00       	call   39a3 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    182b:	50                   	push   %eax
    182c:	50                   	push   %eax
    182d:	68 44 50 00 00       	push   $0x5044
    1832:	6a 01                	push   $0x1
    1834:	e8 d7 22 00 00       	call   3b10 <printf>
    exit();
    1839:	e8 65 21 00 00       	call   39a3 <exit>
    printf(1, "link lf1 lf2 failed\n");
    183e:	51                   	push   %ecx
    183f:	51                   	push   %ecx
    1840:	68 63 44 00 00       	push   $0x4463
    1845:	6a 01                	push   $0x1
    1847:	e8 c4 22 00 00       	call   3b10 <printf>
    exit();
    184c:	e8 52 21 00 00       	call   39a3 <exit>
    printf(1, "write lf1 failed\n");
    1851:	50                   	push   %eax
    1852:	50                   	push   %eax
    1853:	68 51 44 00 00       	push   $0x4451
    1858:	6a 01                	push   $0x1
    185a:	e8 b1 22 00 00       	call   3b10 <printf>
    exit();
    185f:	e8 3f 21 00 00       	call   39a3 <exit>
    1864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    186b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    186f:	90                   	nop

00001870 <concreate>:
{
    1870:	f3 0f 1e fb          	endbr32 
    1874:	55                   	push   %ebp
    1875:	89 e5                	mov    %esp,%ebp
    1877:	57                   	push   %edi
    1878:	56                   	push   %esi
  for(i = 0; i < 40; i++){
    1879:	31 f6                	xor    %esi,%esi
{
    187b:	53                   	push   %ebx
    187c:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    187f:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1882:	68 e1 44 00 00       	push   $0x44e1
    1887:	6a 01                	push   $0x1
    1889:	e8 82 22 00 00       	call   3b10 <printf>
  file[0] = 'C';
    188e:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1892:	83 c4 10             	add    $0x10,%esp
    1895:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    1899:	eb 48                	jmp    18e3 <concreate+0x73>
    189b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    189f:	90                   	nop
    18a0:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
    if(pid && (i % 3) == 1){
    18a6:	3d ab aa aa aa       	cmp    $0xaaaaaaab,%eax
    18ab:	0f 83 af 00 00 00    	jae    1960 <concreate+0xf0>
      fd = open(file, O_CREATE | O_RDWR);
    18b1:	83 ec 08             	sub    $0x8,%esp
    18b4:	68 02 02 00 00       	push   $0x202
    18b9:	53                   	push   %ebx
    18ba:	e8 24 21 00 00       	call   39e3 <open>
      if(fd < 0){
    18bf:	83 c4 10             	add    $0x10,%esp
    18c2:	85 c0                	test   %eax,%eax
    18c4:	78 5f                	js     1925 <concreate+0xb5>
      close(fd);
    18c6:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    18c9:	83 c6 01             	add    $0x1,%esi
      close(fd);
    18cc:	50                   	push   %eax
    18cd:	e8 f9 20 00 00       	call   39cb <close>
    18d2:	83 c4 10             	add    $0x10,%esp
      wait();
    18d5:	e8 d1 20 00 00       	call   39ab <wait>
  for(i = 0; i < 40; i++){
    18da:	83 fe 28             	cmp    $0x28,%esi
    18dd:	0f 84 9f 00 00 00    	je     1982 <concreate+0x112>
    unlink(file);
    18e3:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    18e6:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    18e9:	53                   	push   %ebx
    file[1] = '0' + i;
    18ea:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    18ed:	e8 01 21 00 00       	call   39f3 <unlink>
    pid = fork();
    18f2:	e8 a4 20 00 00       	call   399b <fork>
    if(pid && (i % 3) == 1){
    18f7:	83 c4 10             	add    $0x10,%esp
    18fa:	85 c0                	test   %eax,%eax
    18fc:	75 a2                	jne    18a0 <concreate+0x30>
      link("C0", file);
    18fe:	69 f6 cd cc cc cc    	imul   $0xcccccccd,%esi,%esi
    } else if(pid == 0 && (i % 5) == 1){
    1904:	81 fe cd cc cc cc    	cmp    $0xcccccccd,%esi
    190a:	73 34                	jae    1940 <concreate+0xd0>
      fd = open(file, O_CREATE | O_RDWR);
    190c:	83 ec 08             	sub    $0x8,%esp
    190f:	68 02 02 00 00       	push   $0x202
    1914:	53                   	push   %ebx
    1915:	e8 c9 20 00 00       	call   39e3 <open>
      if(fd < 0){
    191a:	83 c4 10             	add    $0x10,%esp
    191d:	85 c0                	test   %eax,%eax
    191f:	0f 89 39 02 00 00    	jns    1b5e <concreate+0x2ee>
        printf(1, "concreate create %s failed\n", file);
    1925:	83 ec 04             	sub    $0x4,%esp
    1928:	53                   	push   %ebx
    1929:	68 f4 44 00 00       	push   $0x44f4
    192e:	6a 01                	push   $0x1
    1930:	e8 db 21 00 00       	call   3b10 <printf>
        exit();
    1935:	e8 69 20 00 00       	call   39a3 <exit>
    193a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("C0", file);
    1940:	83 ec 08             	sub    $0x8,%esp
    1943:	53                   	push   %ebx
    1944:	68 f1 44 00 00       	push   $0x44f1
    1949:	e8 b5 20 00 00       	call   3a03 <link>
    194e:	83 c4 10             	add    $0x10,%esp
      exit();
    1951:	e8 4d 20 00 00       	call   39a3 <exit>
    1956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    195d:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    1960:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    1963:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    1966:	53                   	push   %ebx
    1967:	68 f1 44 00 00       	push   $0x44f1
    196c:	e8 92 20 00 00       	call   3a03 <link>
    1971:	83 c4 10             	add    $0x10,%esp
      wait();
    1974:	e8 32 20 00 00       	call   39ab <wait>
  for(i = 0; i < 40; i++){
    1979:	83 fe 28             	cmp    $0x28,%esi
    197c:	0f 85 61 ff ff ff    	jne    18e3 <concreate+0x73>
  memset(fa, 0, sizeof(fa));
    1982:	83 ec 04             	sub    $0x4,%esp
    1985:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1988:	6a 28                	push   $0x28
    198a:	6a 00                	push   $0x0
    198c:	50                   	push   %eax
    198d:	e8 6e 1e 00 00       	call   3800 <memset>
  fd = open(".", 0);
    1992:	5e                   	pop    %esi
    1993:	5f                   	pop    %edi
    1994:	6a 00                	push   $0x0
    1996:	68 fe 46 00 00       	push   $0x46fe
    199b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    199e:	e8 40 20 00 00       	call   39e3 <open>
  n = 0;
    19a3:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    19aa:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    19ad:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    19af:	90                   	nop
    19b0:	83 ec 04             	sub    $0x4,%esp
    19b3:	6a 10                	push   $0x10
    19b5:	57                   	push   %edi
    19b6:	56                   	push   %esi
    19b7:	e8 ff 1f 00 00       	call   39bb <read>
    19bc:	83 c4 10             	add    $0x10,%esp
    19bf:	85 c0                	test   %eax,%eax
    19c1:	7e 3d                	jle    1a00 <concreate+0x190>
    if(de.inum == 0)
    19c3:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    19c8:	74 e6                	je     19b0 <concreate+0x140>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    19ca:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    19ce:	75 e0                	jne    19b0 <concreate+0x140>
    19d0:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    19d4:	75 da                	jne    19b0 <concreate+0x140>
      i = de.name[1] - '0';
    19d6:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    19da:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    19dd:	83 f8 27             	cmp    $0x27,%eax
    19e0:	0f 87 60 01 00 00    	ja     1b46 <concreate+0x2d6>
      if(fa[i]){
    19e6:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    19eb:	0f 85 3d 01 00 00    	jne    1b2e <concreate+0x2be>
      n++;
    19f1:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
      fa[i] = 1;
    19f5:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    19fa:	eb b4                	jmp    19b0 <concreate+0x140>
    19fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    1a00:	83 ec 0c             	sub    $0xc,%esp
    1a03:	56                   	push   %esi
    1a04:	e8 c2 1f 00 00       	call   39cb <close>
  if(n != 40){
    1a09:	83 c4 10             	add    $0x10,%esp
    1a0c:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1a10:	0f 85 05 01 00 00    	jne    1b1b <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    1a16:	31 f6                	xor    %esi,%esi
    1a18:	eb 4c                	jmp    1a66 <concreate+0x1f6>
    1a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    1a20:	85 ff                	test   %edi,%edi
    1a22:	74 05                	je     1a29 <concreate+0x1b9>
    1a24:	83 f8 01             	cmp    $0x1,%eax
    1a27:	74 6c                	je     1a95 <concreate+0x225>
      unlink(file);
    1a29:	83 ec 0c             	sub    $0xc,%esp
    1a2c:	53                   	push   %ebx
    1a2d:	e8 c1 1f 00 00       	call   39f3 <unlink>
      unlink(file);
    1a32:	89 1c 24             	mov    %ebx,(%esp)
    1a35:	e8 b9 1f 00 00       	call   39f3 <unlink>
      unlink(file);
    1a3a:	89 1c 24             	mov    %ebx,(%esp)
    1a3d:	e8 b1 1f 00 00       	call   39f3 <unlink>
      unlink(file);
    1a42:	89 1c 24             	mov    %ebx,(%esp)
    1a45:	e8 a9 1f 00 00       	call   39f3 <unlink>
    1a4a:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    1a4d:	85 ff                	test   %edi,%edi
    1a4f:	0f 84 fc fe ff ff    	je     1951 <concreate+0xe1>
      wait();
    1a55:	e8 51 1f 00 00       	call   39ab <wait>
  for(i = 0; i < 40; i++){
    1a5a:	83 c6 01             	add    $0x1,%esi
    1a5d:	83 fe 28             	cmp    $0x28,%esi
    1a60:	0f 84 8a 00 00 00    	je     1af0 <concreate+0x280>
    file[1] = '0' + i;
    1a66:	8d 46 30             	lea    0x30(%esi),%eax
    1a69:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1a6c:	e8 2a 1f 00 00       	call   399b <fork>
    1a71:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1a73:	85 c0                	test   %eax,%eax
    1a75:	0f 88 8c 00 00 00    	js     1b07 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    1a7b:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    1a80:	f7 e6                	mul    %esi
    1a82:	89 d0                	mov    %edx,%eax
    1a84:	83 e2 fe             	and    $0xfffffffe,%edx
    1a87:	d1 e8                	shr    %eax
    1a89:	01 c2                	add    %eax,%edx
    1a8b:	89 f0                	mov    %esi,%eax
    1a8d:	29 d0                	sub    %edx,%eax
    1a8f:	89 c1                	mov    %eax,%ecx
    1a91:	09 f9                	or     %edi,%ecx
    1a93:	75 8b                	jne    1a20 <concreate+0x1b0>
      close(open(file, 0));
    1a95:	83 ec 08             	sub    $0x8,%esp
    1a98:	6a 00                	push   $0x0
    1a9a:	53                   	push   %ebx
    1a9b:	e8 43 1f 00 00       	call   39e3 <open>
    1aa0:	89 04 24             	mov    %eax,(%esp)
    1aa3:	e8 23 1f 00 00       	call   39cb <close>
      close(open(file, 0));
    1aa8:	58                   	pop    %eax
    1aa9:	5a                   	pop    %edx
    1aaa:	6a 00                	push   $0x0
    1aac:	53                   	push   %ebx
    1aad:	e8 31 1f 00 00       	call   39e3 <open>
    1ab2:	89 04 24             	mov    %eax,(%esp)
    1ab5:	e8 11 1f 00 00       	call   39cb <close>
      close(open(file, 0));
    1aba:	59                   	pop    %ecx
    1abb:	58                   	pop    %eax
    1abc:	6a 00                	push   $0x0
    1abe:	53                   	push   %ebx
    1abf:	e8 1f 1f 00 00       	call   39e3 <open>
    1ac4:	89 04 24             	mov    %eax,(%esp)
    1ac7:	e8 ff 1e 00 00       	call   39cb <close>
      close(open(file, 0));
    1acc:	58                   	pop    %eax
    1acd:	5a                   	pop    %edx
    1ace:	6a 00                	push   $0x0
    1ad0:	53                   	push   %ebx
    1ad1:	e8 0d 1f 00 00       	call   39e3 <open>
    1ad6:	89 04 24             	mov    %eax,(%esp)
    1ad9:	e8 ed 1e 00 00       	call   39cb <close>
    1ade:	83 c4 10             	add    $0x10,%esp
    1ae1:	e9 67 ff ff ff       	jmp    1a4d <concreate+0x1dd>
    1ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1aed:	8d 76 00             	lea    0x0(%esi),%esi
  printf(1, "concreate ok\n");
    1af0:	83 ec 08             	sub    $0x8,%esp
    1af3:	68 46 45 00 00       	push   $0x4546
    1af8:	6a 01                	push   $0x1
    1afa:	e8 11 20 00 00       	call   3b10 <printf>
}
    1aff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1b02:	5b                   	pop    %ebx
    1b03:	5e                   	pop    %esi
    1b04:	5f                   	pop    %edi
    1b05:	5d                   	pop    %ebp
    1b06:	c3                   	ret    
      printf(1, "fork failed\n");
    1b07:	83 ec 08             	sub    $0x8,%esp
    1b0a:	68 c9 4d 00 00       	push   $0x4dc9
    1b0f:	6a 01                	push   $0x1
    1b11:	e8 fa 1f 00 00       	call   3b10 <printf>
      exit();
    1b16:	e8 88 1e 00 00       	call   39a3 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    1b1b:	51                   	push   %ecx
    1b1c:	51                   	push   %ecx
    1b1d:	68 90 50 00 00       	push   $0x5090
    1b22:	6a 01                	push   $0x1
    1b24:	e8 e7 1f 00 00       	call   3b10 <printf>
    exit();
    1b29:	e8 75 1e 00 00       	call   39a3 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b2e:	83 ec 04             	sub    $0x4,%esp
    1b31:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1b34:	50                   	push   %eax
    1b35:	68 29 45 00 00       	push   $0x4529
    1b3a:	6a 01                	push   $0x1
    1b3c:	e8 cf 1f 00 00       	call   3b10 <printf>
        exit();
    1b41:	e8 5d 1e 00 00       	call   39a3 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1b46:	83 ec 04             	sub    $0x4,%esp
    1b49:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1b4c:	50                   	push   %eax
    1b4d:	68 10 45 00 00       	push   $0x4510
    1b52:	6a 01                	push   $0x1
    1b54:	e8 b7 1f 00 00       	call   3b10 <printf>
        exit();
    1b59:	e8 45 1e 00 00       	call   39a3 <exit>
      close(fd);
    1b5e:	83 ec 0c             	sub    $0xc,%esp
    1b61:	50                   	push   %eax
    1b62:	e8 64 1e 00 00       	call   39cb <close>
    1b67:	83 c4 10             	add    $0x10,%esp
    1b6a:	e9 e2 fd ff ff       	jmp    1951 <concreate+0xe1>
    1b6f:	90                   	nop

00001b70 <linkunlink>:
{
    1b70:	f3 0f 1e fb          	endbr32 
    1b74:	55                   	push   %ebp
    1b75:	89 e5                	mov    %esp,%ebp
    1b77:	57                   	push   %edi
    1b78:	56                   	push   %esi
    1b79:	53                   	push   %ebx
    1b7a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1b7d:	68 54 45 00 00       	push   $0x4554
    1b82:	6a 01                	push   $0x1
    1b84:	e8 87 1f 00 00       	call   3b10 <printf>
  unlink("x");
    1b89:	c7 04 24 e1 47 00 00 	movl   $0x47e1,(%esp)
    1b90:	e8 5e 1e 00 00       	call   39f3 <unlink>
  pid = fork();
    1b95:	e8 01 1e 00 00       	call   399b <fork>
  if(pid < 0){
    1b9a:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1b9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1ba0:	85 c0                	test   %eax,%eax
    1ba2:	0f 88 b2 00 00 00    	js     1c5a <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1ba8:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1bac:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1bb1:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1bb6:	19 ff                	sbb    %edi,%edi
    1bb8:	83 e7 60             	and    $0x60,%edi
    1bbb:	83 c7 01             	add    $0x1,%edi
    1bbe:	eb 1a                	jmp    1bda <linkunlink+0x6a>
    } else if((x % 3) == 1){
    1bc0:	83 f8 01             	cmp    $0x1,%eax
    1bc3:	74 7b                	je     1c40 <linkunlink+0xd0>
      unlink("x");
    1bc5:	83 ec 0c             	sub    $0xc,%esp
    1bc8:	68 e1 47 00 00       	push   $0x47e1
    1bcd:	e8 21 1e 00 00       	call   39f3 <unlink>
    1bd2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1bd5:	83 eb 01             	sub    $0x1,%ebx
    1bd8:	74 41                	je     1c1b <linkunlink+0xab>
    x = x * 1103515245 + 12345;
    1bda:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1be0:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1be6:	89 f8                	mov    %edi,%eax
    1be8:	f7 e6                	mul    %esi
    1bea:	89 d0                	mov    %edx,%eax
    1bec:	83 e2 fe             	and    $0xfffffffe,%edx
    1bef:	d1 e8                	shr    %eax
    1bf1:	01 c2                	add    %eax,%edx
    1bf3:	89 f8                	mov    %edi,%eax
    1bf5:	29 d0                	sub    %edx,%eax
    1bf7:	75 c7                	jne    1bc0 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1bf9:	83 ec 08             	sub    $0x8,%esp
    1bfc:	68 02 02 00 00       	push   $0x202
    1c01:	68 e1 47 00 00       	push   $0x47e1
    1c06:	e8 d8 1d 00 00       	call   39e3 <open>
    1c0b:	89 04 24             	mov    %eax,(%esp)
    1c0e:	e8 b8 1d 00 00       	call   39cb <close>
    1c13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1c16:	83 eb 01             	sub    $0x1,%ebx
    1c19:	75 bf                	jne    1bda <linkunlink+0x6a>
  if(pid)
    1c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1c1e:	85 c0                	test   %eax,%eax
    1c20:	74 4b                	je     1c6d <linkunlink+0xfd>
    wait();
    1c22:	e8 84 1d 00 00       	call   39ab <wait>
  printf(1, "linkunlink ok\n");
    1c27:	83 ec 08             	sub    $0x8,%esp
    1c2a:	68 69 45 00 00       	push   $0x4569
    1c2f:	6a 01                	push   $0x1
    1c31:	e8 da 1e 00 00       	call   3b10 <printf>
}
    1c36:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1c39:	5b                   	pop    %ebx
    1c3a:	5e                   	pop    %esi
    1c3b:	5f                   	pop    %edi
    1c3c:	5d                   	pop    %ebp
    1c3d:	c3                   	ret    
    1c3e:	66 90                	xchg   %ax,%ax
      link("cat", "x");
    1c40:	83 ec 08             	sub    $0x8,%esp
    1c43:	68 e1 47 00 00       	push   $0x47e1
    1c48:	68 65 45 00 00       	push   $0x4565
    1c4d:	e8 b1 1d 00 00       	call   3a03 <link>
    1c52:	83 c4 10             	add    $0x10,%esp
    1c55:	e9 7b ff ff ff       	jmp    1bd5 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1c5a:	52                   	push   %edx
    1c5b:	52                   	push   %edx
    1c5c:	68 c9 4d 00 00       	push   $0x4dc9
    1c61:	6a 01                	push   $0x1
    1c63:	e8 a8 1e 00 00       	call   3b10 <printf>
    exit();
    1c68:	e8 36 1d 00 00       	call   39a3 <exit>
    exit();
    1c6d:	e8 31 1d 00 00       	call   39a3 <exit>
    1c72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001c80 <bigdir>:
{
    1c80:	f3 0f 1e fb          	endbr32 
    1c84:	55                   	push   %ebp
    1c85:	89 e5                	mov    %esp,%ebp
    1c87:	57                   	push   %edi
    1c88:	56                   	push   %esi
    1c89:	53                   	push   %ebx
    1c8a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1c8d:	68 78 45 00 00       	push   $0x4578
    1c92:	6a 01                	push   $0x1
    1c94:	e8 77 1e 00 00       	call   3b10 <printf>
  unlink("bd");
    1c99:	c7 04 24 85 45 00 00 	movl   $0x4585,(%esp)
    1ca0:	e8 4e 1d 00 00       	call   39f3 <unlink>
  fd = open("bd", O_CREATE);
    1ca5:	5a                   	pop    %edx
    1ca6:	59                   	pop    %ecx
    1ca7:	68 00 02 00 00       	push   $0x200
    1cac:	68 85 45 00 00       	push   $0x4585
    1cb1:	e8 2d 1d 00 00       	call   39e3 <open>
  if(fd < 0){
    1cb6:	83 c4 10             	add    $0x10,%esp
    1cb9:	85 c0                	test   %eax,%eax
    1cbb:	0f 88 ea 00 00 00    	js     1dab <bigdir+0x12b>
  close(fd);
    1cc1:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 500; i++){
    1cc4:	31 f6                	xor    %esi,%esi
    1cc6:	8d 7d de             	lea    -0x22(%ebp),%edi
  close(fd);
    1cc9:	50                   	push   %eax
    1cca:	e8 fc 1c 00 00       	call   39cb <close>
    1ccf:	83 c4 10             	add    $0x10,%esp
    1cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + (i / 64);
    1cd8:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1cda:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1cdd:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1ce1:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1ce4:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1ce5:	83 c0 30             	add    $0x30,%eax
    if(link("bd", name) != 0){
    1ce8:	68 85 45 00 00       	push   $0x4585
    name[1] = '0' + (i / 64);
    1ced:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1cf0:	89 f0                	mov    %esi,%eax
    1cf2:	83 e0 3f             	and    $0x3f,%eax
    name[3] = '\0';
    1cf5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[2] = '0' + (i % 64);
    1cf9:	83 c0 30             	add    $0x30,%eax
    1cfc:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1cff:	e8 ff 1c 00 00       	call   3a03 <link>
    1d04:	83 c4 10             	add    $0x10,%esp
    1d07:	89 c3                	mov    %eax,%ebx
    1d09:	85 c0                	test   %eax,%eax
    1d0b:	75 76                	jne    1d83 <bigdir+0x103>
  for(i = 0; i < 500; i++){
    1d0d:	83 c6 01             	add    $0x1,%esi
    1d10:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1d16:	75 c0                	jne    1cd8 <bigdir+0x58>
  unlink("bd");
    1d18:	83 ec 0c             	sub    $0xc,%esp
    1d1b:	68 85 45 00 00       	push   $0x4585
    1d20:	e8 ce 1c 00 00       	call   39f3 <unlink>
    1d25:	83 c4 10             	add    $0x10,%esp
    1d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1d2f:	90                   	nop
    name[1] = '0' + (i / 64);
    1d30:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1d32:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1d35:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1d39:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1d3c:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1d3d:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1d40:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1d44:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1d47:	89 d8                	mov    %ebx,%eax
    1d49:	83 e0 3f             	and    $0x3f,%eax
    1d4c:	83 c0 30             	add    $0x30,%eax
    1d4f:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1d52:	e8 9c 1c 00 00       	call   39f3 <unlink>
    1d57:	83 c4 10             	add    $0x10,%esp
    1d5a:	85 c0                	test   %eax,%eax
    1d5c:	75 39                	jne    1d97 <bigdir+0x117>
  for(i = 0; i < 500; i++){
    1d5e:	83 c3 01             	add    $0x1,%ebx
    1d61:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1d67:	75 c7                	jne    1d30 <bigdir+0xb0>
  printf(1, "bigdir ok\n");
    1d69:	83 ec 08             	sub    $0x8,%esp
    1d6c:	68 c7 45 00 00       	push   $0x45c7
    1d71:	6a 01                	push   $0x1
    1d73:	e8 98 1d 00 00       	call   3b10 <printf>
    1d78:	83 c4 10             	add    $0x10,%esp
}
    1d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1d7e:	5b                   	pop    %ebx
    1d7f:	5e                   	pop    %esi
    1d80:	5f                   	pop    %edi
    1d81:	5d                   	pop    %ebp
    1d82:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1d83:	83 ec 08             	sub    $0x8,%esp
    1d86:	68 9e 45 00 00       	push   $0x459e
    1d8b:	6a 01                	push   $0x1
    1d8d:	e8 7e 1d 00 00       	call   3b10 <printf>
      exit();
    1d92:	e8 0c 1c 00 00       	call   39a3 <exit>
      printf(1, "bigdir unlink failed");
    1d97:	83 ec 08             	sub    $0x8,%esp
    1d9a:	68 b2 45 00 00       	push   $0x45b2
    1d9f:	6a 01                	push   $0x1
    1da1:	e8 6a 1d 00 00       	call   3b10 <printf>
      exit();
    1da6:	e8 f8 1b 00 00       	call   39a3 <exit>
    printf(1, "bigdir create failed\n");
    1dab:	50                   	push   %eax
    1dac:	50                   	push   %eax
    1dad:	68 88 45 00 00       	push   $0x4588
    1db2:	6a 01                	push   $0x1
    1db4:	e8 57 1d 00 00       	call   3b10 <printf>
    exit();
    1db9:	e8 e5 1b 00 00       	call   39a3 <exit>
    1dbe:	66 90                	xchg   %ax,%ax

00001dc0 <subdir>:
{
    1dc0:	f3 0f 1e fb          	endbr32 
    1dc4:	55                   	push   %ebp
    1dc5:	89 e5                	mov    %esp,%ebp
    1dc7:	53                   	push   %ebx
    1dc8:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1dcb:	68 d2 45 00 00       	push   $0x45d2
    1dd0:	6a 01                	push   $0x1
    1dd2:	e8 39 1d 00 00       	call   3b10 <printf>
  unlink("ff");
    1dd7:	c7 04 24 5b 46 00 00 	movl   $0x465b,(%esp)
    1dde:	e8 10 1c 00 00       	call   39f3 <unlink>
  if(mkdir("dd") != 0){
    1de3:	c7 04 24 f8 46 00 00 	movl   $0x46f8,(%esp)
    1dea:	e8 1c 1c 00 00       	call   3a0b <mkdir>
    1def:	83 c4 10             	add    $0x10,%esp
    1df2:	85 c0                	test   %eax,%eax
    1df4:	0f 85 b3 05 00 00    	jne    23ad <subdir+0x5ed>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1dfa:	83 ec 08             	sub    $0x8,%esp
    1dfd:	68 02 02 00 00       	push   $0x202
    1e02:	68 31 46 00 00       	push   $0x4631
    1e07:	e8 d7 1b 00 00       	call   39e3 <open>
  if(fd < 0){
    1e0c:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1e0f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e11:	85 c0                	test   %eax,%eax
    1e13:	0f 88 81 05 00 00    	js     239a <subdir+0x5da>
  write(fd, "ff", 2);
    1e19:	83 ec 04             	sub    $0x4,%esp
    1e1c:	6a 02                	push   $0x2
    1e1e:	68 5b 46 00 00       	push   $0x465b
    1e23:	50                   	push   %eax
    1e24:	e8 9a 1b 00 00       	call   39c3 <write>
  close(fd);
    1e29:	89 1c 24             	mov    %ebx,(%esp)
    1e2c:	e8 9a 1b 00 00       	call   39cb <close>
  if(unlink("dd") >= 0){
    1e31:	c7 04 24 f8 46 00 00 	movl   $0x46f8,(%esp)
    1e38:	e8 b6 1b 00 00       	call   39f3 <unlink>
    1e3d:	83 c4 10             	add    $0x10,%esp
    1e40:	85 c0                	test   %eax,%eax
    1e42:	0f 89 3f 05 00 00    	jns    2387 <subdir+0x5c7>
  if(mkdir("/dd/dd") != 0){
    1e48:	83 ec 0c             	sub    $0xc,%esp
    1e4b:	68 0c 46 00 00       	push   $0x460c
    1e50:	e8 b6 1b 00 00       	call   3a0b <mkdir>
    1e55:	83 c4 10             	add    $0x10,%esp
    1e58:	85 c0                	test   %eax,%eax
    1e5a:	0f 85 14 05 00 00    	jne    2374 <subdir+0x5b4>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e60:	83 ec 08             	sub    $0x8,%esp
    1e63:	68 02 02 00 00       	push   $0x202
    1e68:	68 2e 46 00 00       	push   $0x462e
    1e6d:	e8 71 1b 00 00       	call   39e3 <open>
  if(fd < 0){
    1e72:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e75:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e77:	85 c0                	test   %eax,%eax
    1e79:	0f 88 24 04 00 00    	js     22a3 <subdir+0x4e3>
  write(fd, "FF", 2);
    1e7f:	83 ec 04             	sub    $0x4,%esp
    1e82:	6a 02                	push   $0x2
    1e84:	68 4f 46 00 00       	push   $0x464f
    1e89:	50                   	push   %eax
    1e8a:	e8 34 1b 00 00       	call   39c3 <write>
  close(fd);
    1e8f:	89 1c 24             	mov    %ebx,(%esp)
    1e92:	e8 34 1b 00 00       	call   39cb <close>
  fd = open("dd/dd/../ff", 0);
    1e97:	58                   	pop    %eax
    1e98:	5a                   	pop    %edx
    1e99:	6a 00                	push   $0x0
    1e9b:	68 52 46 00 00       	push   $0x4652
    1ea0:	e8 3e 1b 00 00       	call   39e3 <open>
  if(fd < 0){
    1ea5:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/../ff", 0);
    1ea8:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1eaa:	85 c0                	test   %eax,%eax
    1eac:	0f 88 de 03 00 00    	js     2290 <subdir+0x4d0>
  cc = read(fd, buf, sizeof(buf));
    1eb2:	83 ec 04             	sub    $0x4,%esp
    1eb5:	68 00 20 00 00       	push   $0x2000
    1eba:	68 00 87 00 00       	push   $0x8700
    1ebf:	50                   	push   %eax
    1ec0:	e8 f6 1a 00 00       	call   39bb <read>
  if(cc != 2 || buf[0] != 'f'){
    1ec5:	83 c4 10             	add    $0x10,%esp
    1ec8:	83 f8 02             	cmp    $0x2,%eax
    1ecb:	0f 85 3a 03 00 00    	jne    220b <subdir+0x44b>
    1ed1:	80 3d 00 87 00 00 66 	cmpb   $0x66,0x8700
    1ed8:	0f 85 2d 03 00 00    	jne    220b <subdir+0x44b>
  close(fd);
    1ede:	83 ec 0c             	sub    $0xc,%esp
    1ee1:	53                   	push   %ebx
    1ee2:	e8 e4 1a 00 00       	call   39cb <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1ee7:	59                   	pop    %ecx
    1ee8:	5b                   	pop    %ebx
    1ee9:	68 92 46 00 00       	push   $0x4692
    1eee:	68 2e 46 00 00       	push   $0x462e
    1ef3:	e8 0b 1b 00 00       	call   3a03 <link>
    1ef8:	83 c4 10             	add    $0x10,%esp
    1efb:	85 c0                	test   %eax,%eax
    1efd:	0f 85 c6 03 00 00    	jne    22c9 <subdir+0x509>
  if(unlink("dd/dd/ff") != 0){
    1f03:	83 ec 0c             	sub    $0xc,%esp
    1f06:	68 2e 46 00 00       	push   $0x462e
    1f0b:	e8 e3 1a 00 00       	call   39f3 <unlink>
    1f10:	83 c4 10             	add    $0x10,%esp
    1f13:	85 c0                	test   %eax,%eax
    1f15:	0f 85 16 03 00 00    	jne    2231 <subdir+0x471>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f1b:	83 ec 08             	sub    $0x8,%esp
    1f1e:	6a 00                	push   $0x0
    1f20:	68 2e 46 00 00       	push   $0x462e
    1f25:	e8 b9 1a 00 00       	call   39e3 <open>
    1f2a:	83 c4 10             	add    $0x10,%esp
    1f2d:	85 c0                	test   %eax,%eax
    1f2f:	0f 89 2c 04 00 00    	jns    2361 <subdir+0x5a1>
  if(chdir("dd") != 0){
    1f35:	83 ec 0c             	sub    $0xc,%esp
    1f38:	68 f8 46 00 00       	push   $0x46f8
    1f3d:	e8 d1 1a 00 00       	call   3a13 <chdir>
    1f42:	83 c4 10             	add    $0x10,%esp
    1f45:	85 c0                	test   %eax,%eax
    1f47:	0f 85 01 04 00 00    	jne    234e <subdir+0x58e>
  if(chdir("dd/../../dd") != 0){
    1f4d:	83 ec 0c             	sub    $0xc,%esp
    1f50:	68 c6 46 00 00       	push   $0x46c6
    1f55:	e8 b9 1a 00 00       	call   3a13 <chdir>
    1f5a:	83 c4 10             	add    $0x10,%esp
    1f5d:	85 c0                	test   %eax,%eax
    1f5f:	0f 85 b9 02 00 00    	jne    221e <subdir+0x45e>
  if(chdir("dd/../../../dd") != 0){
    1f65:	83 ec 0c             	sub    $0xc,%esp
    1f68:	68 ec 46 00 00       	push   $0x46ec
    1f6d:	e8 a1 1a 00 00       	call   3a13 <chdir>
    1f72:	83 c4 10             	add    $0x10,%esp
    1f75:	85 c0                	test   %eax,%eax
    1f77:	0f 85 a1 02 00 00    	jne    221e <subdir+0x45e>
  if(chdir("./..") != 0){
    1f7d:	83 ec 0c             	sub    $0xc,%esp
    1f80:	68 fb 46 00 00       	push   $0x46fb
    1f85:	e8 89 1a 00 00       	call   3a13 <chdir>
    1f8a:	83 c4 10             	add    $0x10,%esp
    1f8d:	85 c0                	test   %eax,%eax
    1f8f:	0f 85 21 03 00 00    	jne    22b6 <subdir+0x4f6>
  fd = open("dd/dd/ffff", 0);
    1f95:	83 ec 08             	sub    $0x8,%esp
    1f98:	6a 00                	push   $0x0
    1f9a:	68 92 46 00 00       	push   $0x4692
    1f9f:	e8 3f 1a 00 00       	call   39e3 <open>
  if(fd < 0){
    1fa4:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ffff", 0);
    1fa7:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1fa9:	85 c0                	test   %eax,%eax
    1fab:	0f 88 e0 04 00 00    	js     2491 <subdir+0x6d1>
  if(read(fd, buf, sizeof(buf)) != 2){
    1fb1:	83 ec 04             	sub    $0x4,%esp
    1fb4:	68 00 20 00 00       	push   $0x2000
    1fb9:	68 00 87 00 00       	push   $0x8700
    1fbe:	50                   	push   %eax
    1fbf:	e8 f7 19 00 00       	call   39bb <read>
    1fc4:	83 c4 10             	add    $0x10,%esp
    1fc7:	83 f8 02             	cmp    $0x2,%eax
    1fca:	0f 85 ae 04 00 00    	jne    247e <subdir+0x6be>
  close(fd);
    1fd0:	83 ec 0c             	sub    $0xc,%esp
    1fd3:	53                   	push   %ebx
    1fd4:	e8 f2 19 00 00       	call   39cb <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1fd9:	58                   	pop    %eax
    1fda:	5a                   	pop    %edx
    1fdb:	6a 00                	push   $0x0
    1fdd:	68 2e 46 00 00       	push   $0x462e
    1fe2:	e8 fc 19 00 00       	call   39e3 <open>
    1fe7:	83 c4 10             	add    $0x10,%esp
    1fea:	85 c0                	test   %eax,%eax
    1fec:	0f 89 65 02 00 00    	jns    2257 <subdir+0x497>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1ff2:	83 ec 08             	sub    $0x8,%esp
    1ff5:	68 02 02 00 00       	push   $0x202
    1ffa:	68 46 47 00 00       	push   $0x4746
    1fff:	e8 df 19 00 00       	call   39e3 <open>
    2004:	83 c4 10             	add    $0x10,%esp
    2007:	85 c0                	test   %eax,%eax
    2009:	0f 89 35 02 00 00    	jns    2244 <subdir+0x484>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    200f:	83 ec 08             	sub    $0x8,%esp
    2012:	68 02 02 00 00       	push   $0x202
    2017:	68 6b 47 00 00       	push   $0x476b
    201c:	e8 c2 19 00 00       	call   39e3 <open>
    2021:	83 c4 10             	add    $0x10,%esp
    2024:	85 c0                	test   %eax,%eax
    2026:	0f 89 0f 03 00 00    	jns    233b <subdir+0x57b>
  if(open("dd", O_CREATE) >= 0){
    202c:	83 ec 08             	sub    $0x8,%esp
    202f:	68 00 02 00 00       	push   $0x200
    2034:	68 f8 46 00 00       	push   $0x46f8
    2039:	e8 a5 19 00 00       	call   39e3 <open>
    203e:	83 c4 10             	add    $0x10,%esp
    2041:	85 c0                	test   %eax,%eax
    2043:	0f 89 df 02 00 00    	jns    2328 <subdir+0x568>
  if(open("dd", O_RDWR) >= 0){
    2049:	83 ec 08             	sub    $0x8,%esp
    204c:	6a 02                	push   $0x2
    204e:	68 f8 46 00 00       	push   $0x46f8
    2053:	e8 8b 19 00 00       	call   39e3 <open>
    2058:	83 c4 10             	add    $0x10,%esp
    205b:	85 c0                	test   %eax,%eax
    205d:	0f 89 b2 02 00 00    	jns    2315 <subdir+0x555>
  if(open("dd", O_WRONLY) >= 0){
    2063:	83 ec 08             	sub    $0x8,%esp
    2066:	6a 01                	push   $0x1
    2068:	68 f8 46 00 00       	push   $0x46f8
    206d:	e8 71 19 00 00       	call   39e3 <open>
    2072:	83 c4 10             	add    $0x10,%esp
    2075:	85 c0                	test   %eax,%eax
    2077:	0f 89 85 02 00 00    	jns    2302 <subdir+0x542>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    207d:	83 ec 08             	sub    $0x8,%esp
    2080:	68 da 47 00 00       	push   $0x47da
    2085:	68 46 47 00 00       	push   $0x4746
    208a:	e8 74 19 00 00       	call   3a03 <link>
    208f:	83 c4 10             	add    $0x10,%esp
    2092:	85 c0                	test   %eax,%eax
    2094:	0f 84 55 02 00 00    	je     22ef <subdir+0x52f>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    209a:	83 ec 08             	sub    $0x8,%esp
    209d:	68 da 47 00 00       	push   $0x47da
    20a2:	68 6b 47 00 00       	push   $0x476b
    20a7:	e8 57 19 00 00       	call   3a03 <link>
    20ac:	83 c4 10             	add    $0x10,%esp
    20af:	85 c0                	test   %eax,%eax
    20b1:	0f 84 25 02 00 00    	je     22dc <subdir+0x51c>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    20b7:	83 ec 08             	sub    $0x8,%esp
    20ba:	68 92 46 00 00       	push   $0x4692
    20bf:	68 31 46 00 00       	push   $0x4631
    20c4:	e8 3a 19 00 00       	call   3a03 <link>
    20c9:	83 c4 10             	add    $0x10,%esp
    20cc:	85 c0                	test   %eax,%eax
    20ce:	0f 84 a9 01 00 00    	je     227d <subdir+0x4bd>
  if(mkdir("dd/ff/ff") == 0){
    20d4:	83 ec 0c             	sub    $0xc,%esp
    20d7:	68 46 47 00 00       	push   $0x4746
    20dc:	e8 2a 19 00 00       	call   3a0b <mkdir>
    20e1:	83 c4 10             	add    $0x10,%esp
    20e4:	85 c0                	test   %eax,%eax
    20e6:	0f 84 7e 01 00 00    	je     226a <subdir+0x4aa>
  if(mkdir("dd/xx/ff") == 0){
    20ec:	83 ec 0c             	sub    $0xc,%esp
    20ef:	68 6b 47 00 00       	push   $0x476b
    20f4:	e8 12 19 00 00       	call   3a0b <mkdir>
    20f9:	83 c4 10             	add    $0x10,%esp
    20fc:	85 c0                	test   %eax,%eax
    20fe:	0f 84 67 03 00 00    	je     246b <subdir+0x6ab>
  if(mkdir("dd/dd/ffff") == 0){
    2104:	83 ec 0c             	sub    $0xc,%esp
    2107:	68 92 46 00 00       	push   $0x4692
    210c:	e8 fa 18 00 00       	call   3a0b <mkdir>
    2111:	83 c4 10             	add    $0x10,%esp
    2114:	85 c0                	test   %eax,%eax
    2116:	0f 84 3c 03 00 00    	je     2458 <subdir+0x698>
  if(unlink("dd/xx/ff") == 0){
    211c:	83 ec 0c             	sub    $0xc,%esp
    211f:	68 6b 47 00 00       	push   $0x476b
    2124:	e8 ca 18 00 00       	call   39f3 <unlink>
    2129:	83 c4 10             	add    $0x10,%esp
    212c:	85 c0                	test   %eax,%eax
    212e:	0f 84 11 03 00 00    	je     2445 <subdir+0x685>
  if(unlink("dd/ff/ff") == 0){
    2134:	83 ec 0c             	sub    $0xc,%esp
    2137:	68 46 47 00 00       	push   $0x4746
    213c:	e8 b2 18 00 00       	call   39f3 <unlink>
    2141:	83 c4 10             	add    $0x10,%esp
    2144:	85 c0                	test   %eax,%eax
    2146:	0f 84 e6 02 00 00    	je     2432 <subdir+0x672>
  if(chdir("dd/ff") == 0){
    214c:	83 ec 0c             	sub    $0xc,%esp
    214f:	68 31 46 00 00       	push   $0x4631
    2154:	e8 ba 18 00 00       	call   3a13 <chdir>
    2159:	83 c4 10             	add    $0x10,%esp
    215c:	85 c0                	test   %eax,%eax
    215e:	0f 84 bb 02 00 00    	je     241f <subdir+0x65f>
  if(chdir("dd/xx") == 0){
    2164:	83 ec 0c             	sub    $0xc,%esp
    2167:	68 dd 47 00 00       	push   $0x47dd
    216c:	e8 a2 18 00 00       	call   3a13 <chdir>
    2171:	83 c4 10             	add    $0x10,%esp
    2174:	85 c0                	test   %eax,%eax
    2176:	0f 84 90 02 00 00    	je     240c <subdir+0x64c>
  if(unlink("dd/dd/ffff") != 0){
    217c:	83 ec 0c             	sub    $0xc,%esp
    217f:	68 92 46 00 00       	push   $0x4692
    2184:	e8 6a 18 00 00       	call   39f3 <unlink>
    2189:	83 c4 10             	add    $0x10,%esp
    218c:	85 c0                	test   %eax,%eax
    218e:	0f 85 9d 00 00 00    	jne    2231 <subdir+0x471>
  if(unlink("dd/ff") != 0){
    2194:	83 ec 0c             	sub    $0xc,%esp
    2197:	68 31 46 00 00       	push   $0x4631
    219c:	e8 52 18 00 00       	call   39f3 <unlink>
    21a1:	83 c4 10             	add    $0x10,%esp
    21a4:	85 c0                	test   %eax,%eax
    21a6:	0f 85 4d 02 00 00    	jne    23f9 <subdir+0x639>
  if(unlink("dd") == 0){
    21ac:	83 ec 0c             	sub    $0xc,%esp
    21af:	68 f8 46 00 00       	push   $0x46f8
    21b4:	e8 3a 18 00 00       	call   39f3 <unlink>
    21b9:	83 c4 10             	add    $0x10,%esp
    21bc:	85 c0                	test   %eax,%eax
    21be:	0f 84 22 02 00 00    	je     23e6 <subdir+0x626>
  if(unlink("dd/dd") < 0){
    21c4:	83 ec 0c             	sub    $0xc,%esp
    21c7:	68 0d 46 00 00       	push   $0x460d
    21cc:	e8 22 18 00 00       	call   39f3 <unlink>
    21d1:	83 c4 10             	add    $0x10,%esp
    21d4:	85 c0                	test   %eax,%eax
    21d6:	0f 88 f7 01 00 00    	js     23d3 <subdir+0x613>
  if(unlink("dd") < 0){
    21dc:	83 ec 0c             	sub    $0xc,%esp
    21df:	68 f8 46 00 00       	push   $0x46f8
    21e4:	e8 0a 18 00 00       	call   39f3 <unlink>
    21e9:	83 c4 10             	add    $0x10,%esp
    21ec:	85 c0                	test   %eax,%eax
    21ee:	0f 88 cc 01 00 00    	js     23c0 <subdir+0x600>
  printf(1, "subdir ok\n");
    21f4:	83 ec 08             	sub    $0x8,%esp
    21f7:	68 da 48 00 00       	push   $0x48da
    21fc:	6a 01                	push   $0x1
    21fe:	e8 0d 19 00 00       	call   3b10 <printf>
}
    2203:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2206:	83 c4 10             	add    $0x10,%esp
    2209:	c9                   	leave  
    220a:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    220b:	50                   	push   %eax
    220c:	50                   	push   %eax
    220d:	68 77 46 00 00       	push   $0x4677
    2212:	6a 01                	push   $0x1
    2214:	e8 f7 18 00 00       	call   3b10 <printf>
    exit();
    2219:	e8 85 17 00 00       	call   39a3 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    221e:	50                   	push   %eax
    221f:	50                   	push   %eax
    2220:	68 d2 46 00 00       	push   $0x46d2
    2225:	6a 01                	push   $0x1
    2227:	e8 e4 18 00 00       	call   3b10 <printf>
    exit();
    222c:	e8 72 17 00 00       	call   39a3 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2231:	50                   	push   %eax
    2232:	50                   	push   %eax
    2233:	68 9d 46 00 00       	push   $0x469d
    2238:	6a 01                	push   $0x1
    223a:	e8 d1 18 00 00       	call   3b10 <printf>
    exit();
    223f:	e8 5f 17 00 00       	call   39a3 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2244:	51                   	push   %ecx
    2245:	51                   	push   %ecx
    2246:	68 4f 47 00 00       	push   $0x474f
    224b:	6a 01                	push   $0x1
    224d:	e8 be 18 00 00       	call   3b10 <printf>
    exit();
    2252:	e8 4c 17 00 00       	call   39a3 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2257:	53                   	push   %ebx
    2258:	53                   	push   %ebx
    2259:	68 34 51 00 00       	push   $0x5134
    225e:	6a 01                	push   $0x1
    2260:	e8 ab 18 00 00       	call   3b10 <printf>
    exit();
    2265:	e8 39 17 00 00       	call   39a3 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    226a:	51                   	push   %ecx
    226b:	51                   	push   %ecx
    226c:	68 e3 47 00 00       	push   $0x47e3
    2271:	6a 01                	push   $0x1
    2273:	e8 98 18 00 00       	call   3b10 <printf>
    exit();
    2278:	e8 26 17 00 00       	call   39a3 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    227d:	53                   	push   %ebx
    227e:	53                   	push   %ebx
    227f:	68 a4 51 00 00       	push   $0x51a4
    2284:	6a 01                	push   $0x1
    2286:	e8 85 18 00 00       	call   3b10 <printf>
    exit();
    228b:	e8 13 17 00 00       	call   39a3 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    2290:	50                   	push   %eax
    2291:	50                   	push   %eax
    2292:	68 5e 46 00 00       	push   $0x465e
    2297:	6a 01                	push   $0x1
    2299:	e8 72 18 00 00       	call   3b10 <printf>
    exit();
    229e:	e8 00 17 00 00       	call   39a3 <exit>
    printf(1, "create dd/dd/ff failed\n");
    22a3:	51                   	push   %ecx
    22a4:	51                   	push   %ecx
    22a5:	68 37 46 00 00       	push   $0x4637
    22aa:	6a 01                	push   $0x1
    22ac:	e8 5f 18 00 00       	call   3b10 <printf>
    exit();
    22b1:	e8 ed 16 00 00       	call   39a3 <exit>
    printf(1, "chdir ./.. failed\n");
    22b6:	50                   	push   %eax
    22b7:	50                   	push   %eax
    22b8:	68 00 47 00 00       	push   $0x4700
    22bd:	6a 01                	push   $0x1
    22bf:	e8 4c 18 00 00       	call   3b10 <printf>
    exit();
    22c4:	e8 da 16 00 00       	call   39a3 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    22c9:	52                   	push   %edx
    22ca:	52                   	push   %edx
    22cb:	68 ec 50 00 00       	push   $0x50ec
    22d0:	6a 01                	push   $0x1
    22d2:	e8 39 18 00 00       	call   3b10 <printf>
    exit();
    22d7:	e8 c7 16 00 00       	call   39a3 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    22dc:	50                   	push   %eax
    22dd:	50                   	push   %eax
    22de:	68 80 51 00 00       	push   $0x5180
    22e3:	6a 01                	push   $0x1
    22e5:	e8 26 18 00 00       	call   3b10 <printf>
    exit();
    22ea:	e8 b4 16 00 00       	call   39a3 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    22ef:	50                   	push   %eax
    22f0:	50                   	push   %eax
    22f1:	68 5c 51 00 00       	push   $0x515c
    22f6:	6a 01                	push   $0x1
    22f8:	e8 13 18 00 00       	call   3b10 <printf>
    exit();
    22fd:	e8 a1 16 00 00       	call   39a3 <exit>
    printf(1, "open dd wronly succeeded!\n");
    2302:	50                   	push   %eax
    2303:	50                   	push   %eax
    2304:	68 bf 47 00 00       	push   $0x47bf
    2309:	6a 01                	push   $0x1
    230b:	e8 00 18 00 00       	call   3b10 <printf>
    exit();
    2310:	e8 8e 16 00 00       	call   39a3 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2315:	50                   	push   %eax
    2316:	50                   	push   %eax
    2317:	68 a6 47 00 00       	push   $0x47a6
    231c:	6a 01                	push   $0x1
    231e:	e8 ed 17 00 00       	call   3b10 <printf>
    exit();
    2323:	e8 7b 16 00 00       	call   39a3 <exit>
    printf(1, "create dd succeeded!\n");
    2328:	50                   	push   %eax
    2329:	50                   	push   %eax
    232a:	68 90 47 00 00       	push   $0x4790
    232f:	6a 01                	push   $0x1
    2331:	e8 da 17 00 00       	call   3b10 <printf>
    exit();
    2336:	e8 68 16 00 00       	call   39a3 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    233b:	52                   	push   %edx
    233c:	52                   	push   %edx
    233d:	68 74 47 00 00       	push   $0x4774
    2342:	6a 01                	push   $0x1
    2344:	e8 c7 17 00 00       	call   3b10 <printf>
    exit();
    2349:	e8 55 16 00 00       	call   39a3 <exit>
    printf(1, "chdir dd failed\n");
    234e:	50                   	push   %eax
    234f:	50                   	push   %eax
    2350:	68 b5 46 00 00       	push   $0x46b5
    2355:	6a 01                	push   $0x1
    2357:	e8 b4 17 00 00       	call   3b10 <printf>
    exit();
    235c:	e8 42 16 00 00       	call   39a3 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2361:	50                   	push   %eax
    2362:	50                   	push   %eax
    2363:	68 10 51 00 00       	push   $0x5110
    2368:	6a 01                	push   $0x1
    236a:	e8 a1 17 00 00       	call   3b10 <printf>
    exit();
    236f:	e8 2f 16 00 00       	call   39a3 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2374:	53                   	push   %ebx
    2375:	53                   	push   %ebx
    2376:	68 13 46 00 00       	push   $0x4613
    237b:	6a 01                	push   $0x1
    237d:	e8 8e 17 00 00       	call   3b10 <printf>
    exit();
    2382:	e8 1c 16 00 00       	call   39a3 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2387:	50                   	push   %eax
    2388:	50                   	push   %eax
    2389:	68 c4 50 00 00       	push   $0x50c4
    238e:	6a 01                	push   $0x1
    2390:	e8 7b 17 00 00       	call   3b10 <printf>
    exit();
    2395:	e8 09 16 00 00       	call   39a3 <exit>
    printf(1, "create dd/ff failed\n");
    239a:	50                   	push   %eax
    239b:	50                   	push   %eax
    239c:	68 f7 45 00 00       	push   $0x45f7
    23a1:	6a 01                	push   $0x1
    23a3:	e8 68 17 00 00       	call   3b10 <printf>
    exit();
    23a8:	e8 f6 15 00 00       	call   39a3 <exit>
    printf(1, "subdir mkdir dd failed\n");
    23ad:	50                   	push   %eax
    23ae:	50                   	push   %eax
    23af:	68 df 45 00 00       	push   $0x45df
    23b4:	6a 01                	push   $0x1
    23b6:	e8 55 17 00 00       	call   3b10 <printf>
    exit();
    23bb:	e8 e3 15 00 00       	call   39a3 <exit>
    printf(1, "unlink dd failed\n");
    23c0:	50                   	push   %eax
    23c1:	50                   	push   %eax
    23c2:	68 c8 48 00 00       	push   $0x48c8
    23c7:	6a 01                	push   $0x1
    23c9:	e8 42 17 00 00       	call   3b10 <printf>
    exit();
    23ce:	e8 d0 15 00 00       	call   39a3 <exit>
    printf(1, "unlink dd/dd failed\n");
    23d3:	52                   	push   %edx
    23d4:	52                   	push   %edx
    23d5:	68 b3 48 00 00       	push   $0x48b3
    23da:	6a 01                	push   $0x1
    23dc:	e8 2f 17 00 00       	call   3b10 <printf>
    exit();
    23e1:	e8 bd 15 00 00       	call   39a3 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    23e6:	51                   	push   %ecx
    23e7:	51                   	push   %ecx
    23e8:	68 c8 51 00 00       	push   $0x51c8
    23ed:	6a 01                	push   $0x1
    23ef:	e8 1c 17 00 00       	call   3b10 <printf>
    exit();
    23f4:	e8 aa 15 00 00       	call   39a3 <exit>
    printf(1, "unlink dd/ff failed\n");
    23f9:	53                   	push   %ebx
    23fa:	53                   	push   %ebx
    23fb:	68 9e 48 00 00       	push   $0x489e
    2400:	6a 01                	push   $0x1
    2402:	e8 09 17 00 00       	call   3b10 <printf>
    exit();
    2407:	e8 97 15 00 00       	call   39a3 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    240c:	50                   	push   %eax
    240d:	50                   	push   %eax
    240e:	68 86 48 00 00       	push   $0x4886
    2413:	6a 01                	push   $0x1
    2415:	e8 f6 16 00 00       	call   3b10 <printf>
    exit();
    241a:	e8 84 15 00 00       	call   39a3 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    241f:	50                   	push   %eax
    2420:	50                   	push   %eax
    2421:	68 6e 48 00 00       	push   $0x486e
    2426:	6a 01                	push   $0x1
    2428:	e8 e3 16 00 00       	call   3b10 <printf>
    exit();
    242d:	e8 71 15 00 00       	call   39a3 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2432:	50                   	push   %eax
    2433:	50                   	push   %eax
    2434:	68 52 48 00 00       	push   $0x4852
    2439:	6a 01                	push   $0x1
    243b:	e8 d0 16 00 00       	call   3b10 <printf>
    exit();
    2440:	e8 5e 15 00 00       	call   39a3 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2445:	50                   	push   %eax
    2446:	50                   	push   %eax
    2447:	68 36 48 00 00       	push   $0x4836
    244c:	6a 01                	push   $0x1
    244e:	e8 bd 16 00 00       	call   3b10 <printf>
    exit();
    2453:	e8 4b 15 00 00       	call   39a3 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2458:	50                   	push   %eax
    2459:	50                   	push   %eax
    245a:	68 19 48 00 00       	push   $0x4819
    245f:	6a 01                	push   $0x1
    2461:	e8 aa 16 00 00       	call   3b10 <printf>
    exit();
    2466:	e8 38 15 00 00       	call   39a3 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    246b:	52                   	push   %edx
    246c:	52                   	push   %edx
    246d:	68 fe 47 00 00       	push   $0x47fe
    2472:	6a 01                	push   $0x1
    2474:	e8 97 16 00 00       	call   3b10 <printf>
    exit();
    2479:	e8 25 15 00 00       	call   39a3 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    247e:	51                   	push   %ecx
    247f:	51                   	push   %ecx
    2480:	68 2b 47 00 00       	push   $0x472b
    2485:	6a 01                	push   $0x1
    2487:	e8 84 16 00 00       	call   3b10 <printf>
    exit();
    248c:	e8 12 15 00 00       	call   39a3 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    2491:	53                   	push   %ebx
    2492:	53                   	push   %ebx
    2493:	68 13 47 00 00       	push   $0x4713
    2498:	6a 01                	push   $0x1
    249a:	e8 71 16 00 00       	call   3b10 <printf>
    exit();
    249f:	e8 ff 14 00 00       	call   39a3 <exit>
    24a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    24ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    24af:	90                   	nop

000024b0 <bigwrite>:
{
    24b0:	f3 0f 1e fb          	endbr32 
    24b4:	55                   	push   %ebp
    24b5:	89 e5                	mov    %esp,%ebp
    24b7:	56                   	push   %esi
    24b8:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    24b9:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    24be:	83 ec 08             	sub    $0x8,%esp
    24c1:	68 e5 48 00 00       	push   $0x48e5
    24c6:	6a 01                	push   $0x1
    24c8:	e8 43 16 00 00       	call   3b10 <printf>
  unlink("bigwrite");
    24cd:	c7 04 24 f4 48 00 00 	movl   $0x48f4,(%esp)
    24d4:	e8 1a 15 00 00       	call   39f3 <unlink>
    24d9:	83 c4 10             	add    $0x10,%esp
    24dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    24e0:	83 ec 08             	sub    $0x8,%esp
    24e3:	68 02 02 00 00       	push   $0x202
    24e8:	68 f4 48 00 00       	push   $0x48f4
    24ed:	e8 f1 14 00 00       	call   39e3 <open>
    if(fd < 0){
    24f2:	83 c4 10             	add    $0x10,%esp
    fd = open("bigwrite", O_CREATE | O_RDWR);
    24f5:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    24f7:	85 c0                	test   %eax,%eax
    24f9:	78 7e                	js     2579 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    24fb:	83 ec 04             	sub    $0x4,%esp
    24fe:	53                   	push   %ebx
    24ff:	68 00 87 00 00       	push   $0x8700
    2504:	50                   	push   %eax
    2505:	e8 b9 14 00 00       	call   39c3 <write>
      if(cc != sz){
    250a:	83 c4 10             	add    $0x10,%esp
    250d:	39 d8                	cmp    %ebx,%eax
    250f:	75 55                	jne    2566 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    2511:	83 ec 04             	sub    $0x4,%esp
    2514:	53                   	push   %ebx
    2515:	68 00 87 00 00       	push   $0x8700
    251a:	56                   	push   %esi
    251b:	e8 a3 14 00 00       	call   39c3 <write>
      if(cc != sz){
    2520:	83 c4 10             	add    $0x10,%esp
    2523:	39 d8                	cmp    %ebx,%eax
    2525:	75 3f                	jne    2566 <bigwrite+0xb6>
    close(fd);
    2527:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    252a:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    2530:	56                   	push   %esi
    2531:	e8 95 14 00 00       	call   39cb <close>
    unlink("bigwrite");
    2536:	c7 04 24 f4 48 00 00 	movl   $0x48f4,(%esp)
    253d:	e8 b1 14 00 00       	call   39f3 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2542:	83 c4 10             	add    $0x10,%esp
    2545:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    254b:	75 93                	jne    24e0 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    254d:	83 ec 08             	sub    $0x8,%esp
    2550:	68 27 49 00 00       	push   $0x4927
    2555:	6a 01                	push   $0x1
    2557:	e8 b4 15 00 00       	call   3b10 <printf>
}
    255c:	83 c4 10             	add    $0x10,%esp
    255f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2562:	5b                   	pop    %ebx
    2563:	5e                   	pop    %esi
    2564:	5d                   	pop    %ebp
    2565:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    2566:	50                   	push   %eax
    2567:	53                   	push   %ebx
    2568:	68 15 49 00 00       	push   $0x4915
    256d:	6a 01                	push   $0x1
    256f:	e8 9c 15 00 00       	call   3b10 <printf>
        exit();
    2574:	e8 2a 14 00 00       	call   39a3 <exit>
      printf(1, "cannot create bigwrite\n");
    2579:	83 ec 08             	sub    $0x8,%esp
    257c:	68 fd 48 00 00       	push   $0x48fd
    2581:	6a 01                	push   $0x1
    2583:	e8 88 15 00 00       	call   3b10 <printf>
      exit();
    2588:	e8 16 14 00 00       	call   39a3 <exit>
    258d:	8d 76 00             	lea    0x0(%esi),%esi

00002590 <bigfile>:
{
    2590:	f3 0f 1e fb          	endbr32 
    2594:	55                   	push   %ebp
    2595:	89 e5                	mov    %esp,%ebp
    2597:	57                   	push   %edi
    2598:	56                   	push   %esi
    2599:	53                   	push   %ebx
    259a:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    259d:	68 34 49 00 00       	push   $0x4934
    25a2:	6a 01                	push   $0x1
    25a4:	e8 67 15 00 00       	call   3b10 <printf>
  unlink("bigfile");
    25a9:	c7 04 24 50 49 00 00 	movl   $0x4950,(%esp)
    25b0:	e8 3e 14 00 00       	call   39f3 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    25b5:	58                   	pop    %eax
    25b6:	5a                   	pop    %edx
    25b7:	68 02 02 00 00       	push   $0x202
    25bc:	68 50 49 00 00       	push   $0x4950
    25c1:	e8 1d 14 00 00       	call   39e3 <open>
  if(fd < 0){
    25c6:	83 c4 10             	add    $0x10,%esp
    25c9:	85 c0                	test   %eax,%eax
    25cb:	0f 88 5a 01 00 00    	js     272b <bigfile+0x19b>
    25d1:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    25d3:	31 db                	xor    %ebx,%ebx
    25d5:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    25d8:	83 ec 04             	sub    $0x4,%esp
    25db:	68 58 02 00 00       	push   $0x258
    25e0:	53                   	push   %ebx
    25e1:	68 00 87 00 00       	push   $0x8700
    25e6:	e8 15 12 00 00       	call   3800 <memset>
    if(write(fd, buf, 600) != 600){
    25eb:	83 c4 0c             	add    $0xc,%esp
    25ee:	68 58 02 00 00       	push   $0x258
    25f3:	68 00 87 00 00       	push   $0x8700
    25f8:	56                   	push   %esi
    25f9:	e8 c5 13 00 00       	call   39c3 <write>
    25fe:	83 c4 10             	add    $0x10,%esp
    2601:	3d 58 02 00 00       	cmp    $0x258,%eax
    2606:	0f 85 f8 00 00 00    	jne    2704 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    260c:	83 c3 01             	add    $0x1,%ebx
    260f:	83 fb 14             	cmp    $0x14,%ebx
    2612:	75 c4                	jne    25d8 <bigfile+0x48>
  close(fd);
    2614:	83 ec 0c             	sub    $0xc,%esp
    2617:	56                   	push   %esi
    2618:	e8 ae 13 00 00       	call   39cb <close>
  fd = open("bigfile", 0);
    261d:	5e                   	pop    %esi
    261e:	5f                   	pop    %edi
    261f:	6a 00                	push   $0x0
    2621:	68 50 49 00 00       	push   $0x4950
    2626:	e8 b8 13 00 00       	call   39e3 <open>
  if(fd < 0){
    262b:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", 0);
    262e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2630:	85 c0                	test   %eax,%eax
    2632:	0f 88 e0 00 00 00    	js     2718 <bigfile+0x188>
  total = 0;
    2638:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    263a:	31 ff                	xor    %edi,%edi
    263c:	eb 30                	jmp    266e <bigfile+0xde>
    263e:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    2640:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2645:	0f 85 91 00 00 00    	jne    26dc <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    264b:	89 fa                	mov    %edi,%edx
    264d:	0f be 05 00 87 00 00 	movsbl 0x8700,%eax
    2654:	d1 fa                	sar    %edx
    2656:	39 d0                	cmp    %edx,%eax
    2658:	75 6e                	jne    26c8 <bigfile+0x138>
    265a:	0f be 15 2b 88 00 00 	movsbl 0x882b,%edx
    2661:	39 d0                	cmp    %edx,%eax
    2663:	75 63                	jne    26c8 <bigfile+0x138>
    total += cc;
    2665:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    266b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    266e:	83 ec 04             	sub    $0x4,%esp
    2671:	68 2c 01 00 00       	push   $0x12c
    2676:	68 00 87 00 00       	push   $0x8700
    267b:	56                   	push   %esi
    267c:	e8 3a 13 00 00       	call   39bb <read>
    if(cc < 0){
    2681:	83 c4 10             	add    $0x10,%esp
    2684:	85 c0                	test   %eax,%eax
    2686:	78 68                	js     26f0 <bigfile+0x160>
    if(cc == 0)
    2688:	75 b6                	jne    2640 <bigfile+0xb0>
  close(fd);
    268a:	83 ec 0c             	sub    $0xc,%esp
    268d:	56                   	push   %esi
    268e:	e8 38 13 00 00       	call   39cb <close>
  if(total != 20*600){
    2693:	83 c4 10             	add    $0x10,%esp
    2696:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    269c:	0f 85 9c 00 00 00    	jne    273e <bigfile+0x1ae>
  unlink("bigfile");
    26a2:	83 ec 0c             	sub    $0xc,%esp
    26a5:	68 50 49 00 00       	push   $0x4950
    26aa:	e8 44 13 00 00       	call   39f3 <unlink>
  printf(1, "bigfile test ok\n");
    26af:	58                   	pop    %eax
    26b0:	5a                   	pop    %edx
    26b1:	68 df 49 00 00       	push   $0x49df
    26b6:	6a 01                	push   $0x1
    26b8:	e8 53 14 00 00       	call   3b10 <printf>
}
    26bd:	83 c4 10             	add    $0x10,%esp
    26c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    26c3:	5b                   	pop    %ebx
    26c4:	5e                   	pop    %esi
    26c5:	5f                   	pop    %edi
    26c6:	5d                   	pop    %ebp
    26c7:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    26c8:	83 ec 08             	sub    $0x8,%esp
    26cb:	68 ac 49 00 00       	push   $0x49ac
    26d0:	6a 01                	push   $0x1
    26d2:	e8 39 14 00 00       	call   3b10 <printf>
      exit();
    26d7:	e8 c7 12 00 00       	call   39a3 <exit>
      printf(1, "short read bigfile\n");
    26dc:	83 ec 08             	sub    $0x8,%esp
    26df:	68 98 49 00 00       	push   $0x4998
    26e4:	6a 01                	push   $0x1
    26e6:	e8 25 14 00 00       	call   3b10 <printf>
      exit();
    26eb:	e8 b3 12 00 00       	call   39a3 <exit>
      printf(1, "read bigfile failed\n");
    26f0:	83 ec 08             	sub    $0x8,%esp
    26f3:	68 83 49 00 00       	push   $0x4983
    26f8:	6a 01                	push   $0x1
    26fa:	e8 11 14 00 00       	call   3b10 <printf>
      exit();
    26ff:	e8 9f 12 00 00       	call   39a3 <exit>
      printf(1, "write bigfile failed\n");
    2704:	83 ec 08             	sub    $0x8,%esp
    2707:	68 58 49 00 00       	push   $0x4958
    270c:	6a 01                	push   $0x1
    270e:	e8 fd 13 00 00       	call   3b10 <printf>
      exit();
    2713:	e8 8b 12 00 00       	call   39a3 <exit>
    printf(1, "cannot open bigfile\n");
    2718:	53                   	push   %ebx
    2719:	53                   	push   %ebx
    271a:	68 6e 49 00 00       	push   $0x496e
    271f:	6a 01                	push   $0x1
    2721:	e8 ea 13 00 00       	call   3b10 <printf>
    exit();
    2726:	e8 78 12 00 00       	call   39a3 <exit>
    printf(1, "cannot create bigfile");
    272b:	50                   	push   %eax
    272c:	50                   	push   %eax
    272d:	68 42 49 00 00       	push   $0x4942
    2732:	6a 01                	push   $0x1
    2734:	e8 d7 13 00 00       	call   3b10 <printf>
    exit();
    2739:	e8 65 12 00 00       	call   39a3 <exit>
    printf(1, "read bigfile wrong total\n");
    273e:	51                   	push   %ecx
    273f:	51                   	push   %ecx
    2740:	68 c5 49 00 00       	push   $0x49c5
    2745:	6a 01                	push   $0x1
    2747:	e8 c4 13 00 00       	call   3b10 <printf>
    exit();
    274c:	e8 52 12 00 00       	call   39a3 <exit>
    2751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    275f:	90                   	nop

00002760 <fourteen>:
{
    2760:	f3 0f 1e fb          	endbr32 
    2764:	55                   	push   %ebp
    2765:	89 e5                	mov    %esp,%ebp
    2767:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    276a:	68 f0 49 00 00       	push   $0x49f0
    276f:	6a 01                	push   $0x1
    2771:	e8 9a 13 00 00       	call   3b10 <printf>
  if(mkdir("12345678901234") != 0){
    2776:	c7 04 24 2b 4a 00 00 	movl   $0x4a2b,(%esp)
    277d:	e8 89 12 00 00       	call   3a0b <mkdir>
    2782:	83 c4 10             	add    $0x10,%esp
    2785:	85 c0                	test   %eax,%eax
    2787:	0f 85 97 00 00 00    	jne    2824 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    278d:	83 ec 0c             	sub    $0xc,%esp
    2790:	68 e8 51 00 00       	push   $0x51e8
    2795:	e8 71 12 00 00       	call   3a0b <mkdir>
    279a:	83 c4 10             	add    $0x10,%esp
    279d:	85 c0                	test   %eax,%eax
    279f:	0f 85 de 00 00 00    	jne    2883 <fourteen+0x123>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27a5:	83 ec 08             	sub    $0x8,%esp
    27a8:	68 00 02 00 00       	push   $0x200
    27ad:	68 38 52 00 00       	push   $0x5238
    27b2:	e8 2c 12 00 00       	call   39e3 <open>
  if(fd < 0){
    27b7:	83 c4 10             	add    $0x10,%esp
    27ba:	85 c0                	test   %eax,%eax
    27bc:	0f 88 ae 00 00 00    	js     2870 <fourteen+0x110>
  close(fd);
    27c2:	83 ec 0c             	sub    $0xc,%esp
    27c5:	50                   	push   %eax
    27c6:	e8 00 12 00 00       	call   39cb <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27cb:	58                   	pop    %eax
    27cc:	5a                   	pop    %edx
    27cd:	6a 00                	push   $0x0
    27cf:	68 a8 52 00 00       	push   $0x52a8
    27d4:	e8 0a 12 00 00       	call   39e3 <open>
  if(fd < 0){
    27d9:	83 c4 10             	add    $0x10,%esp
    27dc:	85 c0                	test   %eax,%eax
    27de:	78 7d                	js     285d <fourteen+0xfd>
  close(fd);
    27e0:	83 ec 0c             	sub    $0xc,%esp
    27e3:	50                   	push   %eax
    27e4:	e8 e2 11 00 00       	call   39cb <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27e9:	c7 04 24 1c 4a 00 00 	movl   $0x4a1c,(%esp)
    27f0:	e8 16 12 00 00       	call   3a0b <mkdir>
    27f5:	83 c4 10             	add    $0x10,%esp
    27f8:	85 c0                	test   %eax,%eax
    27fa:	74 4e                	je     284a <fourteen+0xea>
  if(mkdir("123456789012345/12345678901234") == 0){
    27fc:	83 ec 0c             	sub    $0xc,%esp
    27ff:	68 44 53 00 00       	push   $0x5344
    2804:	e8 02 12 00 00       	call   3a0b <mkdir>
    2809:	83 c4 10             	add    $0x10,%esp
    280c:	85 c0                	test   %eax,%eax
    280e:	74 27                	je     2837 <fourteen+0xd7>
  printf(1, "fourteen ok\n");
    2810:	83 ec 08             	sub    $0x8,%esp
    2813:	68 3a 4a 00 00       	push   $0x4a3a
    2818:	6a 01                	push   $0x1
    281a:	e8 f1 12 00 00       	call   3b10 <printf>
}
    281f:	83 c4 10             	add    $0x10,%esp
    2822:	c9                   	leave  
    2823:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2824:	50                   	push   %eax
    2825:	50                   	push   %eax
    2826:	68 ff 49 00 00       	push   $0x49ff
    282b:	6a 01                	push   $0x1
    282d:	e8 de 12 00 00       	call   3b10 <printf>
    exit();
    2832:	e8 6c 11 00 00       	call   39a3 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2837:	50                   	push   %eax
    2838:	50                   	push   %eax
    2839:	68 64 53 00 00       	push   $0x5364
    283e:	6a 01                	push   $0x1
    2840:	e8 cb 12 00 00       	call   3b10 <printf>
    exit();
    2845:	e8 59 11 00 00       	call   39a3 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    284a:	52                   	push   %edx
    284b:	52                   	push   %edx
    284c:	68 14 53 00 00       	push   $0x5314
    2851:	6a 01                	push   $0x1
    2853:	e8 b8 12 00 00       	call   3b10 <printf>
    exit();
    2858:	e8 46 11 00 00       	call   39a3 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    285d:	51                   	push   %ecx
    285e:	51                   	push   %ecx
    285f:	68 d8 52 00 00       	push   $0x52d8
    2864:	6a 01                	push   $0x1
    2866:	e8 a5 12 00 00       	call   3b10 <printf>
    exit();
    286b:	e8 33 11 00 00       	call   39a3 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2870:	51                   	push   %ecx
    2871:	51                   	push   %ecx
    2872:	68 68 52 00 00       	push   $0x5268
    2877:	6a 01                	push   $0x1
    2879:	e8 92 12 00 00       	call   3b10 <printf>
    exit();
    287e:	e8 20 11 00 00       	call   39a3 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2883:	50                   	push   %eax
    2884:	50                   	push   %eax
    2885:	68 08 52 00 00       	push   $0x5208
    288a:	6a 01                	push   $0x1
    288c:	e8 7f 12 00 00       	call   3b10 <printf>
    exit();
    2891:	e8 0d 11 00 00       	call   39a3 <exit>
    2896:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    289d:	8d 76 00             	lea    0x0(%esi),%esi

000028a0 <rmdot>:
{
    28a0:	f3 0f 1e fb          	endbr32 
    28a4:	55                   	push   %ebp
    28a5:	89 e5                	mov    %esp,%ebp
    28a7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    28aa:	68 47 4a 00 00       	push   $0x4a47
    28af:	6a 01                	push   $0x1
    28b1:	e8 5a 12 00 00       	call   3b10 <printf>
  if(mkdir("dots") != 0){
    28b6:	c7 04 24 53 4a 00 00 	movl   $0x4a53,(%esp)
    28bd:	e8 49 11 00 00       	call   3a0b <mkdir>
    28c2:	83 c4 10             	add    $0x10,%esp
    28c5:	85 c0                	test   %eax,%eax
    28c7:	0f 85 b0 00 00 00    	jne    297d <rmdot+0xdd>
  if(chdir("dots") != 0){
    28cd:	83 ec 0c             	sub    $0xc,%esp
    28d0:	68 53 4a 00 00       	push   $0x4a53
    28d5:	e8 39 11 00 00       	call   3a13 <chdir>
    28da:	83 c4 10             	add    $0x10,%esp
    28dd:	85 c0                	test   %eax,%eax
    28df:	0f 85 1d 01 00 00    	jne    2a02 <rmdot+0x162>
  if(unlink(".") == 0){
    28e5:	83 ec 0c             	sub    $0xc,%esp
    28e8:	68 fe 46 00 00       	push   $0x46fe
    28ed:	e8 01 11 00 00       	call   39f3 <unlink>
    28f2:	83 c4 10             	add    $0x10,%esp
    28f5:	85 c0                	test   %eax,%eax
    28f7:	0f 84 f2 00 00 00    	je     29ef <rmdot+0x14f>
  if(unlink("..") == 0){
    28fd:	83 ec 0c             	sub    $0xc,%esp
    2900:	68 fd 46 00 00       	push   $0x46fd
    2905:	e8 e9 10 00 00       	call   39f3 <unlink>
    290a:	83 c4 10             	add    $0x10,%esp
    290d:	85 c0                	test   %eax,%eax
    290f:	0f 84 c7 00 00 00    	je     29dc <rmdot+0x13c>
  if(chdir("/") != 0){
    2915:	83 ec 0c             	sub    $0xc,%esp
    2918:	68 c1 3e 00 00       	push   $0x3ec1
    291d:	e8 f1 10 00 00       	call   3a13 <chdir>
    2922:	83 c4 10             	add    $0x10,%esp
    2925:	85 c0                	test   %eax,%eax
    2927:	0f 85 9c 00 00 00    	jne    29c9 <rmdot+0x129>
  if(unlink("dots/.") == 0){
    292d:	83 ec 0c             	sub    $0xc,%esp
    2930:	68 9b 4a 00 00       	push   $0x4a9b
    2935:	e8 b9 10 00 00       	call   39f3 <unlink>
    293a:	83 c4 10             	add    $0x10,%esp
    293d:	85 c0                	test   %eax,%eax
    293f:	74 75                	je     29b6 <rmdot+0x116>
  if(unlink("dots/..") == 0){
    2941:	83 ec 0c             	sub    $0xc,%esp
    2944:	68 b9 4a 00 00       	push   $0x4ab9
    2949:	e8 a5 10 00 00       	call   39f3 <unlink>
    294e:	83 c4 10             	add    $0x10,%esp
    2951:	85 c0                	test   %eax,%eax
    2953:	74 4e                	je     29a3 <rmdot+0x103>
  if(unlink("dots") != 0){
    2955:	83 ec 0c             	sub    $0xc,%esp
    2958:	68 53 4a 00 00       	push   $0x4a53
    295d:	e8 91 10 00 00       	call   39f3 <unlink>
    2962:	83 c4 10             	add    $0x10,%esp
    2965:	85 c0                	test   %eax,%eax
    2967:	75 27                	jne    2990 <rmdot+0xf0>
  printf(1, "rmdot ok\n");
    2969:	83 ec 08             	sub    $0x8,%esp
    296c:	68 ee 4a 00 00       	push   $0x4aee
    2971:	6a 01                	push   $0x1
    2973:	e8 98 11 00 00       	call   3b10 <printf>
}
    2978:	83 c4 10             	add    $0x10,%esp
    297b:	c9                   	leave  
    297c:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    297d:	50                   	push   %eax
    297e:	50                   	push   %eax
    297f:	68 58 4a 00 00       	push   $0x4a58
    2984:	6a 01                	push   $0x1
    2986:	e8 85 11 00 00       	call   3b10 <printf>
    exit();
    298b:	e8 13 10 00 00       	call   39a3 <exit>
    printf(1, "unlink dots failed!\n");
    2990:	50                   	push   %eax
    2991:	50                   	push   %eax
    2992:	68 d9 4a 00 00       	push   $0x4ad9
    2997:	6a 01                	push   $0x1
    2999:	e8 72 11 00 00       	call   3b10 <printf>
    exit();
    299e:	e8 00 10 00 00       	call   39a3 <exit>
    printf(1, "unlink dots/.. worked!\n");
    29a3:	52                   	push   %edx
    29a4:	52                   	push   %edx
    29a5:	68 c1 4a 00 00       	push   $0x4ac1
    29aa:	6a 01                	push   $0x1
    29ac:	e8 5f 11 00 00       	call   3b10 <printf>
    exit();
    29b1:	e8 ed 0f 00 00       	call   39a3 <exit>
    printf(1, "unlink dots/. worked!\n");
    29b6:	51                   	push   %ecx
    29b7:	51                   	push   %ecx
    29b8:	68 a2 4a 00 00       	push   $0x4aa2
    29bd:	6a 01                	push   $0x1
    29bf:	e8 4c 11 00 00       	call   3b10 <printf>
    exit();
    29c4:	e8 da 0f 00 00       	call   39a3 <exit>
    printf(1, "chdir / failed\n");
    29c9:	50                   	push   %eax
    29ca:	50                   	push   %eax
    29cb:	68 c3 3e 00 00       	push   $0x3ec3
    29d0:	6a 01                	push   $0x1
    29d2:	e8 39 11 00 00       	call   3b10 <printf>
    exit();
    29d7:	e8 c7 0f 00 00       	call   39a3 <exit>
    printf(1, "rm .. worked!\n");
    29dc:	50                   	push   %eax
    29dd:	50                   	push   %eax
    29de:	68 8c 4a 00 00       	push   $0x4a8c
    29e3:	6a 01                	push   $0x1
    29e5:	e8 26 11 00 00       	call   3b10 <printf>
    exit();
    29ea:	e8 b4 0f 00 00       	call   39a3 <exit>
    printf(1, "rm . worked!\n");
    29ef:	50                   	push   %eax
    29f0:	50                   	push   %eax
    29f1:	68 7e 4a 00 00       	push   $0x4a7e
    29f6:	6a 01                	push   $0x1
    29f8:	e8 13 11 00 00       	call   3b10 <printf>
    exit();
    29fd:	e8 a1 0f 00 00       	call   39a3 <exit>
    printf(1, "chdir dots failed\n");
    2a02:	50                   	push   %eax
    2a03:	50                   	push   %eax
    2a04:	68 6b 4a 00 00       	push   $0x4a6b
    2a09:	6a 01                	push   $0x1
    2a0b:	e8 00 11 00 00       	call   3b10 <printf>
    exit();
    2a10:	e8 8e 0f 00 00       	call   39a3 <exit>
    2a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002a20 <dirfile>:
{
    2a20:	f3 0f 1e fb          	endbr32 
    2a24:	55                   	push   %ebp
    2a25:	89 e5                	mov    %esp,%ebp
    2a27:	53                   	push   %ebx
    2a28:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    2a2b:	68 f8 4a 00 00       	push   $0x4af8
    2a30:	6a 01                	push   $0x1
    2a32:	e8 d9 10 00 00       	call   3b10 <printf>
  fd = open("dirfile", O_CREATE);
    2a37:	5b                   	pop    %ebx
    2a38:	58                   	pop    %eax
    2a39:	68 00 02 00 00       	push   $0x200
    2a3e:	68 05 4b 00 00       	push   $0x4b05
    2a43:	e8 9b 0f 00 00       	call   39e3 <open>
  if(fd < 0){
    2a48:	83 c4 10             	add    $0x10,%esp
    2a4b:	85 c0                	test   %eax,%eax
    2a4d:	0f 88 43 01 00 00    	js     2b96 <dirfile+0x176>
  close(fd);
    2a53:	83 ec 0c             	sub    $0xc,%esp
    2a56:	50                   	push   %eax
    2a57:	e8 6f 0f 00 00       	call   39cb <close>
  if(chdir("dirfile") == 0){
    2a5c:	c7 04 24 05 4b 00 00 	movl   $0x4b05,(%esp)
    2a63:	e8 ab 0f 00 00       	call   3a13 <chdir>
    2a68:	83 c4 10             	add    $0x10,%esp
    2a6b:	85 c0                	test   %eax,%eax
    2a6d:	0f 84 10 01 00 00    	je     2b83 <dirfile+0x163>
  fd = open("dirfile/xx", 0);
    2a73:	83 ec 08             	sub    $0x8,%esp
    2a76:	6a 00                	push   $0x0
    2a78:	68 3e 4b 00 00       	push   $0x4b3e
    2a7d:	e8 61 0f 00 00       	call   39e3 <open>
  if(fd >= 0){
    2a82:	83 c4 10             	add    $0x10,%esp
    2a85:	85 c0                	test   %eax,%eax
    2a87:	0f 89 e3 00 00 00    	jns    2b70 <dirfile+0x150>
  fd = open("dirfile/xx", O_CREATE);
    2a8d:	83 ec 08             	sub    $0x8,%esp
    2a90:	68 00 02 00 00       	push   $0x200
    2a95:	68 3e 4b 00 00       	push   $0x4b3e
    2a9a:	e8 44 0f 00 00       	call   39e3 <open>
  if(fd >= 0){
    2a9f:	83 c4 10             	add    $0x10,%esp
    2aa2:	85 c0                	test   %eax,%eax
    2aa4:	0f 89 c6 00 00 00    	jns    2b70 <dirfile+0x150>
  if(mkdir("dirfile/xx") == 0){
    2aaa:	83 ec 0c             	sub    $0xc,%esp
    2aad:	68 3e 4b 00 00       	push   $0x4b3e
    2ab2:	e8 54 0f 00 00       	call   3a0b <mkdir>
    2ab7:	83 c4 10             	add    $0x10,%esp
    2aba:	85 c0                	test   %eax,%eax
    2abc:	0f 84 46 01 00 00    	je     2c08 <dirfile+0x1e8>
  if(unlink("dirfile/xx") == 0){
    2ac2:	83 ec 0c             	sub    $0xc,%esp
    2ac5:	68 3e 4b 00 00       	push   $0x4b3e
    2aca:	e8 24 0f 00 00       	call   39f3 <unlink>
    2acf:	83 c4 10             	add    $0x10,%esp
    2ad2:	85 c0                	test   %eax,%eax
    2ad4:	0f 84 1b 01 00 00    	je     2bf5 <dirfile+0x1d5>
  if(link("README", "dirfile/xx") == 0){
    2ada:	83 ec 08             	sub    $0x8,%esp
    2add:	68 3e 4b 00 00       	push   $0x4b3e
    2ae2:	68 a2 4b 00 00       	push   $0x4ba2
    2ae7:	e8 17 0f 00 00       	call   3a03 <link>
    2aec:	83 c4 10             	add    $0x10,%esp
    2aef:	85 c0                	test   %eax,%eax
    2af1:	0f 84 eb 00 00 00    	je     2be2 <dirfile+0x1c2>
  if(unlink("dirfile") != 0){
    2af7:	83 ec 0c             	sub    $0xc,%esp
    2afa:	68 05 4b 00 00       	push   $0x4b05
    2aff:	e8 ef 0e 00 00       	call   39f3 <unlink>
    2b04:	83 c4 10             	add    $0x10,%esp
    2b07:	85 c0                	test   %eax,%eax
    2b09:	0f 85 c0 00 00 00    	jne    2bcf <dirfile+0x1af>
  fd = open(".", O_RDWR);
    2b0f:	83 ec 08             	sub    $0x8,%esp
    2b12:	6a 02                	push   $0x2
    2b14:	68 fe 46 00 00       	push   $0x46fe
    2b19:	e8 c5 0e 00 00       	call   39e3 <open>
  if(fd >= 0){
    2b1e:	83 c4 10             	add    $0x10,%esp
    2b21:	85 c0                	test   %eax,%eax
    2b23:	0f 89 93 00 00 00    	jns    2bbc <dirfile+0x19c>
  fd = open(".", 0);
    2b29:	83 ec 08             	sub    $0x8,%esp
    2b2c:	6a 00                	push   $0x0
    2b2e:	68 fe 46 00 00       	push   $0x46fe
    2b33:	e8 ab 0e 00 00       	call   39e3 <open>
  if(write(fd, "x", 1) > 0){
    2b38:	83 c4 0c             	add    $0xc,%esp
    2b3b:	6a 01                	push   $0x1
  fd = open(".", 0);
    2b3d:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2b3f:	68 e1 47 00 00       	push   $0x47e1
    2b44:	50                   	push   %eax
    2b45:	e8 79 0e 00 00       	call   39c3 <write>
    2b4a:	83 c4 10             	add    $0x10,%esp
    2b4d:	85 c0                	test   %eax,%eax
    2b4f:	7f 58                	jg     2ba9 <dirfile+0x189>
  close(fd);
    2b51:	83 ec 0c             	sub    $0xc,%esp
    2b54:	53                   	push   %ebx
    2b55:	e8 71 0e 00 00       	call   39cb <close>
  printf(1, "dir vs file OK\n");
    2b5a:	58                   	pop    %eax
    2b5b:	5a                   	pop    %edx
    2b5c:	68 d5 4b 00 00       	push   $0x4bd5
    2b61:	6a 01                	push   $0x1
    2b63:	e8 a8 0f 00 00       	call   3b10 <printf>
}
    2b68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b6b:	83 c4 10             	add    $0x10,%esp
    2b6e:	c9                   	leave  
    2b6f:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2b70:	50                   	push   %eax
    2b71:	50                   	push   %eax
    2b72:	68 49 4b 00 00       	push   $0x4b49
    2b77:	6a 01                	push   $0x1
    2b79:	e8 92 0f 00 00       	call   3b10 <printf>
    exit();
    2b7e:	e8 20 0e 00 00       	call   39a3 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2b83:	52                   	push   %edx
    2b84:	52                   	push   %edx
    2b85:	68 24 4b 00 00       	push   $0x4b24
    2b8a:	6a 01                	push   $0x1
    2b8c:	e8 7f 0f 00 00       	call   3b10 <printf>
    exit();
    2b91:	e8 0d 0e 00 00       	call   39a3 <exit>
    printf(1, "create dirfile failed\n");
    2b96:	51                   	push   %ecx
    2b97:	51                   	push   %ecx
    2b98:	68 0d 4b 00 00       	push   $0x4b0d
    2b9d:	6a 01                	push   $0x1
    2b9f:	e8 6c 0f 00 00       	call   3b10 <printf>
    exit();
    2ba4:	e8 fa 0d 00 00       	call   39a3 <exit>
    printf(1, "write . succeeded!\n");
    2ba9:	51                   	push   %ecx
    2baa:	51                   	push   %ecx
    2bab:	68 c1 4b 00 00       	push   $0x4bc1
    2bb0:	6a 01                	push   $0x1
    2bb2:	e8 59 0f 00 00       	call   3b10 <printf>
    exit();
    2bb7:	e8 e7 0d 00 00       	call   39a3 <exit>
    printf(1, "open . for writing succeeded!\n");
    2bbc:	53                   	push   %ebx
    2bbd:	53                   	push   %ebx
    2bbe:	68 b8 53 00 00       	push   $0x53b8
    2bc3:	6a 01                	push   $0x1
    2bc5:	e8 46 0f 00 00       	call   3b10 <printf>
    exit();
    2bca:	e8 d4 0d 00 00       	call   39a3 <exit>
    printf(1, "unlink dirfile failed!\n");
    2bcf:	50                   	push   %eax
    2bd0:	50                   	push   %eax
    2bd1:	68 a9 4b 00 00       	push   $0x4ba9
    2bd6:	6a 01                	push   $0x1
    2bd8:	e8 33 0f 00 00       	call   3b10 <printf>
    exit();
    2bdd:	e8 c1 0d 00 00       	call   39a3 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2be2:	50                   	push   %eax
    2be3:	50                   	push   %eax
    2be4:	68 98 53 00 00       	push   $0x5398
    2be9:	6a 01                	push   $0x1
    2beb:	e8 20 0f 00 00       	call   3b10 <printf>
    exit();
    2bf0:	e8 ae 0d 00 00       	call   39a3 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2bf5:	50                   	push   %eax
    2bf6:	50                   	push   %eax
    2bf7:	68 84 4b 00 00       	push   $0x4b84
    2bfc:	6a 01                	push   $0x1
    2bfe:	e8 0d 0f 00 00       	call   3b10 <printf>
    exit();
    2c03:	e8 9b 0d 00 00       	call   39a3 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2c08:	50                   	push   %eax
    2c09:	50                   	push   %eax
    2c0a:	68 67 4b 00 00       	push   $0x4b67
    2c0f:	6a 01                	push   $0x1
    2c11:	e8 fa 0e 00 00       	call   3b10 <printf>
    exit();
    2c16:	e8 88 0d 00 00       	call   39a3 <exit>
    2c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2c1f:	90                   	nop

00002c20 <iref>:
{
    2c20:	f3 0f 1e fb          	endbr32 
    2c24:	55                   	push   %ebp
    2c25:	89 e5                	mov    %esp,%ebp
    2c27:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2c28:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2c2d:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2c30:	68 e5 4b 00 00       	push   $0x4be5
    2c35:	6a 01                	push   $0x1
    2c37:	e8 d4 0e 00 00       	call   3b10 <printf>
    2c3c:	83 c4 10             	add    $0x10,%esp
    2c3f:	90                   	nop
    if(mkdir("irefd") != 0){
    2c40:	83 ec 0c             	sub    $0xc,%esp
    2c43:	68 f6 4b 00 00       	push   $0x4bf6
    2c48:	e8 be 0d 00 00       	call   3a0b <mkdir>
    2c4d:	83 c4 10             	add    $0x10,%esp
    2c50:	85 c0                	test   %eax,%eax
    2c52:	0f 85 bb 00 00 00    	jne    2d13 <iref+0xf3>
    if(chdir("irefd") != 0){
    2c58:	83 ec 0c             	sub    $0xc,%esp
    2c5b:	68 f6 4b 00 00       	push   $0x4bf6
    2c60:	e8 ae 0d 00 00       	call   3a13 <chdir>
    2c65:	83 c4 10             	add    $0x10,%esp
    2c68:	85 c0                	test   %eax,%eax
    2c6a:	0f 85 b7 00 00 00    	jne    2d27 <iref+0x107>
    mkdir("");
    2c70:	83 ec 0c             	sub    $0xc,%esp
    2c73:	68 9b 42 00 00       	push   $0x429b
    2c78:	e8 8e 0d 00 00       	call   3a0b <mkdir>
    link("README", "");
    2c7d:	59                   	pop    %ecx
    2c7e:	58                   	pop    %eax
    2c7f:	68 9b 42 00 00       	push   $0x429b
    2c84:	68 a2 4b 00 00       	push   $0x4ba2
    2c89:	e8 75 0d 00 00       	call   3a03 <link>
    fd = open("", O_CREATE);
    2c8e:	58                   	pop    %eax
    2c8f:	5a                   	pop    %edx
    2c90:	68 00 02 00 00       	push   $0x200
    2c95:	68 9b 42 00 00       	push   $0x429b
    2c9a:	e8 44 0d 00 00       	call   39e3 <open>
    if(fd >= 0)
    2c9f:	83 c4 10             	add    $0x10,%esp
    2ca2:	85 c0                	test   %eax,%eax
    2ca4:	78 0c                	js     2cb2 <iref+0x92>
      close(fd);
    2ca6:	83 ec 0c             	sub    $0xc,%esp
    2ca9:	50                   	push   %eax
    2caa:	e8 1c 0d 00 00       	call   39cb <close>
    2caf:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2cb2:	83 ec 08             	sub    $0x8,%esp
    2cb5:	68 00 02 00 00       	push   $0x200
    2cba:	68 e0 47 00 00       	push   $0x47e0
    2cbf:	e8 1f 0d 00 00       	call   39e3 <open>
    if(fd >= 0)
    2cc4:	83 c4 10             	add    $0x10,%esp
    2cc7:	85 c0                	test   %eax,%eax
    2cc9:	78 0c                	js     2cd7 <iref+0xb7>
      close(fd);
    2ccb:	83 ec 0c             	sub    $0xc,%esp
    2cce:	50                   	push   %eax
    2ccf:	e8 f7 0c 00 00       	call   39cb <close>
    2cd4:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2cd7:	83 ec 0c             	sub    $0xc,%esp
    2cda:	68 e0 47 00 00       	push   $0x47e0
    2cdf:	e8 0f 0d 00 00       	call   39f3 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2ce4:	83 c4 10             	add    $0x10,%esp
    2ce7:	83 eb 01             	sub    $0x1,%ebx
    2cea:	0f 85 50 ff ff ff    	jne    2c40 <iref+0x20>
  chdir("/");
    2cf0:	83 ec 0c             	sub    $0xc,%esp
    2cf3:	68 c1 3e 00 00       	push   $0x3ec1
    2cf8:	e8 16 0d 00 00       	call   3a13 <chdir>
  printf(1, "empty file name OK\n");
    2cfd:	58                   	pop    %eax
    2cfe:	5a                   	pop    %edx
    2cff:	68 24 4c 00 00       	push   $0x4c24
    2d04:	6a 01                	push   $0x1
    2d06:	e8 05 0e 00 00       	call   3b10 <printf>
}
    2d0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2d0e:	83 c4 10             	add    $0x10,%esp
    2d11:	c9                   	leave  
    2d12:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2d13:	83 ec 08             	sub    $0x8,%esp
    2d16:	68 fc 4b 00 00       	push   $0x4bfc
    2d1b:	6a 01                	push   $0x1
    2d1d:	e8 ee 0d 00 00       	call   3b10 <printf>
      exit();
    2d22:	e8 7c 0c 00 00       	call   39a3 <exit>
      printf(1, "chdir irefd failed\n");
    2d27:	83 ec 08             	sub    $0x8,%esp
    2d2a:	68 10 4c 00 00       	push   $0x4c10
    2d2f:	6a 01                	push   $0x1
    2d31:	e8 da 0d 00 00       	call   3b10 <printf>
      exit();
    2d36:	e8 68 0c 00 00       	call   39a3 <exit>
    2d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2d3f:	90                   	nop

00002d40 <forktest>:
{
    2d40:	f3 0f 1e fb          	endbr32 
    2d44:	55                   	push   %ebp
    2d45:	89 e5                	mov    %esp,%ebp
    2d47:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2d48:	31 db                	xor    %ebx,%ebx
{
    2d4a:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2d4d:	68 38 4c 00 00       	push   $0x4c38
    2d52:	6a 01                	push   $0x1
    2d54:	e8 b7 0d 00 00       	call   3b10 <printf>
    2d59:	83 c4 10             	add    $0x10,%esp
    2d5c:	eb 0f                	jmp    2d6d <forktest+0x2d>
    2d5e:	66 90                	xchg   %ax,%ax
    if(pid == 0)
    2d60:	74 4a                	je     2dac <forktest+0x6c>
  for(n=0; n<1000; n++){
    2d62:	83 c3 01             	add    $0x1,%ebx
    2d65:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2d6b:	74 6b                	je     2dd8 <forktest+0x98>
    pid = fork();
    2d6d:	e8 29 0c 00 00       	call   399b <fork>
    if(pid < 0)
    2d72:	85 c0                	test   %eax,%eax
    2d74:	79 ea                	jns    2d60 <forktest+0x20>
  for(; n > 0; n--){
    2d76:	85 db                	test   %ebx,%ebx
    2d78:	74 14                	je     2d8e <forktest+0x4e>
    2d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2d80:	e8 26 0c 00 00       	call   39ab <wait>
    2d85:	85 c0                	test   %eax,%eax
    2d87:	78 28                	js     2db1 <forktest+0x71>
  for(; n > 0; n--){
    2d89:	83 eb 01             	sub    $0x1,%ebx
    2d8c:	75 f2                	jne    2d80 <forktest+0x40>
  if(wait() != -1){
    2d8e:	e8 18 0c 00 00       	call   39ab <wait>
    2d93:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d96:	75 2d                	jne    2dc5 <forktest+0x85>
  printf(1, "fork test OK\n");
    2d98:	83 ec 08             	sub    $0x8,%esp
    2d9b:	68 6a 4c 00 00       	push   $0x4c6a
    2da0:	6a 01                	push   $0x1
    2da2:	e8 69 0d 00 00       	call   3b10 <printf>
}
    2da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2daa:	c9                   	leave  
    2dab:	c3                   	ret    
      exit();
    2dac:	e8 f2 0b 00 00       	call   39a3 <exit>
      printf(1, "wait stopped early\n");
    2db1:	83 ec 08             	sub    $0x8,%esp
    2db4:	68 43 4c 00 00       	push   $0x4c43
    2db9:	6a 01                	push   $0x1
    2dbb:	e8 50 0d 00 00       	call   3b10 <printf>
      exit();
    2dc0:	e8 de 0b 00 00       	call   39a3 <exit>
    printf(1, "wait got too many\n");
    2dc5:	52                   	push   %edx
    2dc6:	52                   	push   %edx
    2dc7:	68 57 4c 00 00       	push   $0x4c57
    2dcc:	6a 01                	push   $0x1
    2dce:	e8 3d 0d 00 00       	call   3b10 <printf>
    exit();
    2dd3:	e8 cb 0b 00 00       	call   39a3 <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    2dd8:	50                   	push   %eax
    2dd9:	50                   	push   %eax
    2dda:	68 d8 53 00 00       	push   $0x53d8
    2ddf:	6a 01                	push   $0x1
    2de1:	e8 2a 0d 00 00       	call   3b10 <printf>
    exit();
    2de6:	e8 b8 0b 00 00       	call   39a3 <exit>
    2deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2def:	90                   	nop

00002df0 <sbrktest>:
{
    2df0:	f3 0f 1e fb          	endbr32 
    2df4:	55                   	push   %ebp
    2df5:	89 e5                	mov    %esp,%ebp
    2df7:	57                   	push   %edi
  for(i = 0; i < 5000; i++){
    2df8:	31 ff                	xor    %edi,%edi
{
    2dfa:	56                   	push   %esi
    2dfb:	53                   	push   %ebx
    2dfc:	83 ec 54             	sub    $0x54,%esp
  printf(stdout, "sbrk test\n");
    2dff:	68 78 4c 00 00       	push   $0x4c78
    2e04:	ff 35 20 5f 00 00    	pushl  0x5f20
    2e0a:	e8 01 0d 00 00       	call   3b10 <printf>
  oldbrk = sbrk(0);
    2e0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e16:	e8 10 0c 00 00       	call   3a2b <sbrk>
  a = sbrk(0);
    2e1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2e22:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2e24:	e8 02 0c 00 00       	call   3a2b <sbrk>
    2e29:	83 c4 10             	add    $0x10,%esp
    2e2c:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5000; i++){
    2e2e:	eb 02                	jmp    2e32 <sbrktest+0x42>
    a = b + 1;
    2e30:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2e32:	83 ec 0c             	sub    $0xc,%esp
    2e35:	6a 01                	push   $0x1
    2e37:	e8 ef 0b 00 00       	call   3a2b <sbrk>
    if(b != a){
    2e3c:	83 c4 10             	add    $0x10,%esp
    2e3f:	39 f0                	cmp    %esi,%eax
    2e41:	0f 85 84 02 00 00    	jne    30cb <sbrktest+0x2db>
  for(i = 0; i < 5000; i++){
    2e47:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2e4a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2e4d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2e50:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2e56:	75 d8                	jne    2e30 <sbrktest+0x40>
  pid = fork();
    2e58:	e8 3e 0b 00 00       	call   399b <fork>
    2e5d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2e5f:	85 c0                	test   %eax,%eax
    2e61:	0f 88 91 03 00 00    	js     31f8 <sbrktest+0x408>
  c = sbrk(1);
    2e67:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2e6a:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2e6d:	6a 01                	push   $0x1
    2e6f:	e8 b7 0b 00 00       	call   3a2b <sbrk>
  c = sbrk(1);
    2e74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e7b:	e8 ab 0b 00 00       	call   3a2b <sbrk>
  if(c != a + 1){
    2e80:	83 c4 10             	add    $0x10,%esp
    2e83:	39 c6                	cmp    %eax,%esi
    2e85:	0f 85 56 03 00 00    	jne    31e1 <sbrktest+0x3f1>
  if(pid == 0)
    2e8b:	85 ff                	test   %edi,%edi
    2e8d:	0f 84 49 03 00 00    	je     31dc <sbrktest+0x3ec>
  wait();
    2e93:	e8 13 0b 00 00       	call   39ab <wait>
  a = sbrk(0);
    2e98:	83 ec 0c             	sub    $0xc,%esp
    2e9b:	6a 00                	push   $0x0
    2e9d:	e8 89 0b 00 00       	call   3a2b <sbrk>
    2ea2:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2ea4:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2ea9:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2eab:	89 04 24             	mov    %eax,(%esp)
    2eae:	e8 78 0b 00 00       	call   3a2b <sbrk>
  if (p != a) {
    2eb3:	83 c4 10             	add    $0x10,%esp
    2eb6:	39 c6                	cmp    %eax,%esi
    2eb8:	0f 85 07 03 00 00    	jne    31c5 <sbrktest+0x3d5>
  a = sbrk(0);
    2ebe:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2ec1:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2ec8:	6a 00                	push   $0x0
    2eca:	e8 5c 0b 00 00       	call   3a2b <sbrk>
  c = sbrk(-4096);
    2ecf:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2ed6:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2ed8:	e8 4e 0b 00 00       	call   3a2b <sbrk>
  if(c == (char*)0xffffffff){
    2edd:	83 c4 10             	add    $0x10,%esp
    2ee0:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ee3:	0f 84 c5 02 00 00    	je     31ae <sbrktest+0x3be>
  c = sbrk(0);
    2ee9:	83 ec 0c             	sub    $0xc,%esp
    2eec:	6a 00                	push   $0x0
    2eee:	e8 38 0b 00 00       	call   3a2b <sbrk>
  if(c != a - 4096){
    2ef3:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2ef9:	83 c4 10             	add    $0x10,%esp
    2efc:	39 d0                	cmp    %edx,%eax
    2efe:	0f 85 93 02 00 00    	jne    3197 <sbrktest+0x3a7>
  a = sbrk(0);
    2f04:	83 ec 0c             	sub    $0xc,%esp
    2f07:	6a 00                	push   $0x0
    2f09:	e8 1d 0b 00 00       	call   3a2b <sbrk>
  c = sbrk(4096);
    2f0e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
    2f15:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2f17:	e8 0f 0b 00 00       	call   3a2b <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2f1c:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
    2f1f:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2f21:	39 c6                	cmp    %eax,%esi
    2f23:	0f 85 57 02 00 00    	jne    3180 <sbrktest+0x390>
    2f29:	83 ec 0c             	sub    $0xc,%esp
    2f2c:	6a 00                	push   $0x0
    2f2e:	e8 f8 0a 00 00       	call   3a2b <sbrk>
    2f33:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2f39:	83 c4 10             	add    $0x10,%esp
    2f3c:	39 c2                	cmp    %eax,%edx
    2f3e:	0f 85 3c 02 00 00    	jne    3180 <sbrktest+0x390>
  if(*lastaddr == 99){
    2f44:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2f4b:	0f 84 18 02 00 00    	je     3169 <sbrktest+0x379>
  a = sbrk(0);
    2f51:	83 ec 0c             	sub    $0xc,%esp
    2f54:	6a 00                	push   $0x0
    2f56:	e8 d0 0a 00 00       	call   3a2b <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2f5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2f62:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2f64:	e8 c2 0a 00 00       	call   3a2b <sbrk>
    2f69:	89 d9                	mov    %ebx,%ecx
    2f6b:	29 c1                	sub    %eax,%ecx
    2f6d:	89 0c 24             	mov    %ecx,(%esp)
    2f70:	e8 b6 0a 00 00       	call   3a2b <sbrk>
  if(c != a){
    2f75:	83 c4 10             	add    $0x10,%esp
    2f78:	39 c6                	cmp    %eax,%esi
    2f7a:	0f 85 d2 01 00 00    	jne    3152 <sbrktest+0x362>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2f80:	be 00 00 00 80       	mov    $0x80000000,%esi
    2f85:	8d 76 00             	lea    0x0(%esi),%esi
    ppid = getpid();
    2f88:	e8 96 0a 00 00       	call   3a23 <getpid>
    2f8d:	89 c7                	mov    %eax,%edi
    pid = fork();
    2f8f:	e8 07 0a 00 00       	call   399b <fork>
    if(pid < 0){
    2f94:	85 c0                	test   %eax,%eax
    2f96:	0f 88 9e 01 00 00    	js     313a <sbrktest+0x34a>
    if(pid == 0){
    2f9c:	0f 84 76 01 00 00    	je     3118 <sbrktest+0x328>
    wait();
    2fa2:	e8 04 0a 00 00       	call   39ab <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2fa7:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    2fad:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2fb3:	75 d3                	jne    2f88 <sbrktest+0x198>
  if(pipe(fds) != 0){
    2fb5:	83 ec 0c             	sub    $0xc,%esp
    2fb8:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2fbb:	50                   	push   %eax
    2fbc:	e8 f2 09 00 00       	call   39b3 <pipe>
    2fc1:	83 c4 10             	add    $0x10,%esp
    2fc4:	85 c0                	test   %eax,%eax
    2fc6:	0f 85 34 01 00 00    	jne    3100 <sbrktest+0x310>
    2fcc:	8d 75 c0             	lea    -0x40(%ebp),%esi
    2fcf:	89 f7                	mov    %esi,%edi
    if((pids[i] = fork()) == 0){
    2fd1:	e8 c5 09 00 00       	call   399b <fork>
    2fd6:	89 07                	mov    %eax,(%edi)
    2fd8:	85 c0                	test   %eax,%eax
    2fda:	0f 84 8f 00 00 00    	je     306f <sbrktest+0x27f>
    if(pids[i] != -1)
    2fe0:	83 f8 ff             	cmp    $0xffffffff,%eax
    2fe3:	74 14                	je     2ff9 <sbrktest+0x209>
      read(fds[0], &scratch, 1);
    2fe5:	83 ec 04             	sub    $0x4,%esp
    2fe8:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2feb:	6a 01                	push   $0x1
    2fed:	50                   	push   %eax
    2fee:	ff 75 b8             	pushl  -0x48(%ebp)
    2ff1:	e8 c5 09 00 00       	call   39bb <read>
    2ff6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2ff9:	83 c7 04             	add    $0x4,%edi
    2ffc:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2fff:	39 c7                	cmp    %eax,%edi
    3001:	75 ce                	jne    2fd1 <sbrktest+0x1e1>
  c = sbrk(4096);
    3003:	83 ec 0c             	sub    $0xc,%esp
    3006:	68 00 10 00 00       	push   $0x1000
    300b:	e8 1b 0a 00 00       	call   3a2b <sbrk>
    3010:	83 c4 10             	add    $0x10,%esp
    3013:	89 c7                	mov    %eax,%edi
    if(pids[i] == -1)
    3015:	8b 06                	mov    (%esi),%eax
    3017:	83 f8 ff             	cmp    $0xffffffff,%eax
    301a:	74 11                	je     302d <sbrktest+0x23d>
    kill(pids[i]);
    301c:	83 ec 0c             	sub    $0xc,%esp
    301f:	50                   	push   %eax
    3020:	e8 ae 09 00 00       	call   39d3 <kill>
    wait();
    3025:	e8 81 09 00 00       	call   39ab <wait>
    302a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    302d:	83 c6 04             	add    $0x4,%esi
    3030:	8d 45 e8             	lea    -0x18(%ebp),%eax
    3033:	39 f0                	cmp    %esi,%eax
    3035:	75 de                	jne    3015 <sbrktest+0x225>
  if(c == (char*)0xffffffff){
    3037:	83 ff ff             	cmp    $0xffffffff,%edi
    303a:	0f 84 a9 00 00 00    	je     30e9 <sbrktest+0x2f9>
  if(sbrk(0) > oldbrk)
    3040:	83 ec 0c             	sub    $0xc,%esp
    3043:	6a 00                	push   $0x0
    3045:	e8 e1 09 00 00       	call   3a2b <sbrk>
    304a:	83 c4 10             	add    $0x10,%esp
    304d:	39 c3                	cmp    %eax,%ebx
    304f:	72 61                	jb     30b2 <sbrktest+0x2c2>
  printf(stdout, "sbrk test OK\n");
    3051:	83 ec 08             	sub    $0x8,%esp
    3054:	68 20 4d 00 00       	push   $0x4d20
    3059:	ff 35 20 5f 00 00    	pushl  0x5f20
    305f:	e8 ac 0a 00 00       	call   3b10 <printf>
}
    3064:	83 c4 10             	add    $0x10,%esp
    3067:	8d 65 f4             	lea    -0xc(%ebp),%esp
    306a:	5b                   	pop    %ebx
    306b:	5e                   	pop    %esi
    306c:	5f                   	pop    %edi
    306d:	5d                   	pop    %ebp
    306e:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    306f:	83 ec 0c             	sub    $0xc,%esp
    3072:	6a 00                	push   $0x0
    3074:	e8 b2 09 00 00       	call   3a2b <sbrk>
    3079:	89 c2                	mov    %eax,%edx
    307b:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3080:	29 d0                	sub    %edx,%eax
    3082:	89 04 24             	mov    %eax,(%esp)
    3085:	e8 a1 09 00 00       	call   3a2b <sbrk>
      write(fds[1], "x", 1);
    308a:	83 c4 0c             	add    $0xc,%esp
    308d:	6a 01                	push   $0x1
    308f:	68 e1 47 00 00       	push   $0x47e1
    3094:	ff 75 bc             	pushl  -0x44(%ebp)
    3097:	e8 27 09 00 00       	call   39c3 <write>
    309c:	83 c4 10             	add    $0x10,%esp
    309f:	90                   	nop
      for(;;) sleep(1000);
    30a0:	83 ec 0c             	sub    $0xc,%esp
    30a3:	68 e8 03 00 00       	push   $0x3e8
    30a8:	e8 86 09 00 00       	call   3a33 <sleep>
    30ad:	83 c4 10             	add    $0x10,%esp
    30b0:	eb ee                	jmp    30a0 <sbrktest+0x2b0>
    sbrk(-(sbrk(0) - oldbrk));
    30b2:	83 ec 0c             	sub    $0xc,%esp
    30b5:	6a 00                	push   $0x0
    30b7:	e8 6f 09 00 00       	call   3a2b <sbrk>
    30bc:	29 c3                	sub    %eax,%ebx
    30be:	89 1c 24             	mov    %ebx,(%esp)
    30c1:	e8 65 09 00 00       	call   3a2b <sbrk>
    30c6:	83 c4 10             	add    $0x10,%esp
    30c9:	eb 86                	jmp    3051 <sbrktest+0x261>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    30cb:	83 ec 0c             	sub    $0xc,%esp
    30ce:	50                   	push   %eax
    30cf:	56                   	push   %esi
    30d0:	57                   	push   %edi
    30d1:	68 83 4c 00 00       	push   $0x4c83
    30d6:	ff 35 20 5f 00 00    	pushl  0x5f20
    30dc:	e8 2f 0a 00 00       	call   3b10 <printf>
      exit();
    30e1:	83 c4 20             	add    $0x20,%esp
    30e4:	e8 ba 08 00 00       	call   39a3 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    30e9:	50                   	push   %eax
    30ea:	50                   	push   %eax
    30eb:	68 05 4d 00 00       	push   $0x4d05
    30f0:	ff 35 20 5f 00 00    	pushl  0x5f20
    30f6:	e8 15 0a 00 00       	call   3b10 <printf>
    exit();
    30fb:	e8 a3 08 00 00       	call   39a3 <exit>
    printf(1, "pipe() failed\n");
    3100:	52                   	push   %edx
    3101:	52                   	push   %edx
    3102:	68 b1 41 00 00       	push   $0x41b1
    3107:	6a 01                	push   $0x1
    3109:	e8 02 0a 00 00       	call   3b10 <printf>
    exit();
    310e:	e8 90 08 00 00       	call   39a3 <exit>
    3113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3117:	90                   	nop
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3118:	0f be 06             	movsbl (%esi),%eax
    311b:	50                   	push   %eax
    311c:	56                   	push   %esi
    311d:	68 ec 4c 00 00       	push   $0x4cec
    3122:	ff 35 20 5f 00 00    	pushl  0x5f20
    3128:	e8 e3 09 00 00       	call   3b10 <printf>
      kill(ppid);
    312d:	89 3c 24             	mov    %edi,(%esp)
    3130:	e8 9e 08 00 00       	call   39d3 <kill>
      exit();
    3135:	e8 69 08 00 00       	call   39a3 <exit>
      printf(stdout, "fork failed\n");
    313a:	83 ec 08             	sub    $0x8,%esp
    313d:	68 c9 4d 00 00       	push   $0x4dc9
    3142:	ff 35 20 5f 00 00    	pushl  0x5f20
    3148:	e8 c3 09 00 00       	call   3b10 <printf>
      exit();
    314d:	e8 51 08 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3152:	50                   	push   %eax
    3153:	56                   	push   %esi
    3154:	68 cc 54 00 00       	push   $0x54cc
    3159:	ff 35 20 5f 00 00    	pushl  0x5f20
    315f:	e8 ac 09 00 00       	call   3b10 <printf>
    exit();
    3164:	e8 3a 08 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3169:	51                   	push   %ecx
    316a:	51                   	push   %ecx
    316b:	68 9c 54 00 00       	push   $0x549c
    3170:	ff 35 20 5f 00 00    	pushl  0x5f20
    3176:	e8 95 09 00 00       	call   3b10 <printf>
    exit();
    317b:	e8 23 08 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3180:	57                   	push   %edi
    3181:	56                   	push   %esi
    3182:	68 74 54 00 00       	push   $0x5474
    3187:	ff 35 20 5f 00 00    	pushl  0x5f20
    318d:	e8 7e 09 00 00       	call   3b10 <printf>
    exit();
    3192:	e8 0c 08 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3197:	50                   	push   %eax
    3198:	56                   	push   %esi
    3199:	68 3c 54 00 00       	push   $0x543c
    319e:	ff 35 20 5f 00 00    	pushl  0x5f20
    31a4:	e8 67 09 00 00       	call   3b10 <printf>
    exit();
    31a9:	e8 f5 07 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    31ae:	53                   	push   %ebx
    31af:	53                   	push   %ebx
    31b0:	68 d1 4c 00 00       	push   $0x4cd1
    31b5:	ff 35 20 5f 00 00    	pushl  0x5f20
    31bb:	e8 50 09 00 00       	call   3b10 <printf>
    exit();
    31c0:	e8 de 07 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    31c5:	56                   	push   %esi
    31c6:	56                   	push   %esi
    31c7:	68 fc 53 00 00       	push   $0x53fc
    31cc:	ff 35 20 5f 00 00    	pushl  0x5f20
    31d2:	e8 39 09 00 00       	call   3b10 <printf>
    exit();
    31d7:	e8 c7 07 00 00       	call   39a3 <exit>
    exit();
    31dc:	e8 c2 07 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    31e1:	57                   	push   %edi
    31e2:	57                   	push   %edi
    31e3:	68 b5 4c 00 00       	push   $0x4cb5
    31e8:	ff 35 20 5f 00 00    	pushl  0x5f20
    31ee:	e8 1d 09 00 00       	call   3b10 <printf>
    exit();
    31f3:	e8 ab 07 00 00       	call   39a3 <exit>
    printf(stdout, "sbrk test fork failed\n");
    31f8:	50                   	push   %eax
    31f9:	50                   	push   %eax
    31fa:	68 9e 4c 00 00       	push   $0x4c9e
    31ff:	ff 35 20 5f 00 00    	pushl  0x5f20
    3205:	e8 06 09 00 00       	call   3b10 <printf>
    exit();
    320a:	e8 94 07 00 00       	call   39a3 <exit>
    320f:	90                   	nop

00003210 <validateint>:
{
    3210:	f3 0f 1e fb          	endbr32 
}
    3214:	c3                   	ret    
    3215:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    321c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003220 <validatetest>:
{
    3220:	f3 0f 1e fb          	endbr32 
    3224:	55                   	push   %ebp
    3225:	89 e5                	mov    %esp,%ebp
    3227:	56                   	push   %esi
  for(p = 0; p <= (uint)hi; p += 4096){
    3228:	31 f6                	xor    %esi,%esi
{
    322a:	53                   	push   %ebx
  printf(stdout, "validate test\n");
    322b:	83 ec 08             	sub    $0x8,%esp
    322e:	68 2e 4d 00 00       	push   $0x4d2e
    3233:	ff 35 20 5f 00 00    	pushl  0x5f20
    3239:	e8 d2 08 00 00       	call   3b10 <printf>
    323e:	83 c4 10             	add    $0x10,%esp
    3241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pid = fork()) == 0){
    3248:	e8 4e 07 00 00       	call   399b <fork>
    324d:	89 c3                	mov    %eax,%ebx
    324f:	85 c0                	test   %eax,%eax
    3251:	74 63                	je     32b6 <validatetest+0x96>
    sleep(0);
    3253:	83 ec 0c             	sub    $0xc,%esp
    3256:	6a 00                	push   $0x0
    3258:	e8 d6 07 00 00       	call   3a33 <sleep>
    sleep(0);
    325d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3264:	e8 ca 07 00 00       	call   3a33 <sleep>
    kill(pid);
    3269:	89 1c 24             	mov    %ebx,(%esp)
    326c:	e8 62 07 00 00       	call   39d3 <kill>
    wait();
    3271:	e8 35 07 00 00       	call   39ab <wait>
    if(link("nosuchfile", (char*)p) != -1){
    3276:	58                   	pop    %eax
    3277:	5a                   	pop    %edx
    3278:	56                   	push   %esi
    3279:	68 3d 4d 00 00       	push   $0x4d3d
    327e:	e8 80 07 00 00       	call   3a03 <link>
    3283:	83 c4 10             	add    $0x10,%esp
    3286:	83 f8 ff             	cmp    $0xffffffff,%eax
    3289:	75 30                	jne    32bb <validatetest+0x9b>
  for(p = 0; p <= (uint)hi; p += 4096){
    328b:	81 c6 00 10 00 00    	add    $0x1000,%esi
    3291:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    3297:	75 af                	jne    3248 <validatetest+0x28>
  printf(stdout, "validate ok\n");
    3299:	83 ec 08             	sub    $0x8,%esp
    329c:	68 61 4d 00 00       	push   $0x4d61
    32a1:	ff 35 20 5f 00 00    	pushl  0x5f20
    32a7:	e8 64 08 00 00       	call   3b10 <printf>
}
    32ac:	83 c4 10             	add    $0x10,%esp
    32af:	8d 65 f8             	lea    -0x8(%ebp),%esp
    32b2:	5b                   	pop    %ebx
    32b3:	5e                   	pop    %esi
    32b4:	5d                   	pop    %ebp
    32b5:	c3                   	ret    
      exit();
    32b6:	e8 e8 06 00 00       	call   39a3 <exit>
      printf(stdout, "link should not succeed\n");
    32bb:	83 ec 08             	sub    $0x8,%esp
    32be:	68 48 4d 00 00       	push   $0x4d48
    32c3:	ff 35 20 5f 00 00    	pushl  0x5f20
    32c9:	e8 42 08 00 00       	call   3b10 <printf>
      exit();
    32ce:	e8 d0 06 00 00       	call   39a3 <exit>
    32d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    32da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000032e0 <bsstest>:
{
    32e0:	f3 0f 1e fb          	endbr32 
    32e4:	55                   	push   %ebp
    32e5:	89 e5                	mov    %esp,%ebp
    32e7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    32ea:	68 6e 4d 00 00       	push   $0x4d6e
    32ef:	ff 35 20 5f 00 00    	pushl  0x5f20
    32f5:	e8 16 08 00 00       	call   3b10 <printf>
    32fa:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    32fd:	31 c0                	xor    %eax,%eax
    32ff:	90                   	nop
    if(uninit[i] != '\0'){
    3300:	80 b8 e0 5f 00 00 00 	cmpb   $0x0,0x5fe0(%eax)
    3307:	75 22                	jne    332b <bsstest+0x4b>
  for(i = 0; i < sizeof(uninit); i++){
    3309:	83 c0 01             	add    $0x1,%eax
    330c:	3d 10 27 00 00       	cmp    $0x2710,%eax
    3311:	75 ed                	jne    3300 <bsstest+0x20>
  printf(stdout, "bss test ok\n");
    3313:	83 ec 08             	sub    $0x8,%esp
    3316:	68 89 4d 00 00       	push   $0x4d89
    331b:	ff 35 20 5f 00 00    	pushl  0x5f20
    3321:	e8 ea 07 00 00       	call   3b10 <printf>
}
    3326:	83 c4 10             	add    $0x10,%esp
    3329:	c9                   	leave  
    332a:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    332b:	83 ec 08             	sub    $0x8,%esp
    332e:	68 78 4d 00 00       	push   $0x4d78
    3333:	ff 35 20 5f 00 00    	pushl  0x5f20
    3339:	e8 d2 07 00 00       	call   3b10 <printf>
      exit();
    333e:	e8 60 06 00 00       	call   39a3 <exit>
    3343:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003350 <bigargtest>:
{
    3350:	f3 0f 1e fb          	endbr32 
    3354:	55                   	push   %ebp
    3355:	89 e5                	mov    %esp,%ebp
    3357:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    335a:	68 96 4d 00 00       	push   $0x4d96
    335f:	e8 8f 06 00 00       	call   39f3 <unlink>
  pid = fork();
    3364:	e8 32 06 00 00       	call   399b <fork>
  if(pid == 0){
    3369:	83 c4 10             	add    $0x10,%esp
    336c:	85 c0                	test   %eax,%eax
    336e:	74 40                	je     33b0 <bigargtest+0x60>
  } else if(pid < 0){
    3370:	0f 88 c1 00 00 00    	js     3437 <bigargtest+0xe7>
  wait();
    3376:	e8 30 06 00 00       	call   39ab <wait>
  fd = open("bigarg-ok", 0);
    337b:	83 ec 08             	sub    $0x8,%esp
    337e:	6a 00                	push   $0x0
    3380:	68 96 4d 00 00       	push   $0x4d96
    3385:	e8 59 06 00 00       	call   39e3 <open>
  if(fd < 0){
    338a:	83 c4 10             	add    $0x10,%esp
    338d:	85 c0                	test   %eax,%eax
    338f:	0f 88 8b 00 00 00    	js     3420 <bigargtest+0xd0>
  close(fd);
    3395:	83 ec 0c             	sub    $0xc,%esp
    3398:	50                   	push   %eax
    3399:	e8 2d 06 00 00       	call   39cb <close>
  unlink("bigarg-ok");
    339e:	c7 04 24 96 4d 00 00 	movl   $0x4d96,(%esp)
    33a5:	e8 49 06 00 00       	call   39f3 <unlink>
}
    33aa:	83 c4 10             	add    $0x10,%esp
    33ad:	c9                   	leave  
    33ae:	c3                   	ret    
    33af:	90                   	nop
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    33b0:	c7 04 85 40 5f 00 00 	movl   $0x54f0,0x5f40(,%eax,4)
    33b7:	f0 54 00 00 
    for(i = 0; i < MAXARG-1; i++)
    33bb:	83 c0 01             	add    $0x1,%eax
    33be:	83 f8 1f             	cmp    $0x1f,%eax
    33c1:	75 ed                	jne    33b0 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    33c3:	51                   	push   %ecx
    33c4:	51                   	push   %ecx
    33c5:	68 a0 4d 00 00       	push   $0x4da0
    33ca:	ff 35 20 5f 00 00    	pushl  0x5f20
    args[MAXARG-1] = 0;
    33d0:	c7 05 bc 5f 00 00 00 	movl   $0x0,0x5fbc
    33d7:	00 00 00 
    printf(stdout, "bigarg test\n");
    33da:	e8 31 07 00 00       	call   3b10 <printf>
    exec("echo", args);
    33df:	58                   	pop    %eax
    33e0:	5a                   	pop    %edx
    33e1:	68 40 5f 00 00       	push   $0x5f40
    33e6:	68 5d 3f 00 00       	push   $0x3f5d
    33eb:	e8 eb 05 00 00       	call   39db <exec>
    printf(stdout, "bigarg test ok\n");
    33f0:	59                   	pop    %ecx
    33f1:	58                   	pop    %eax
    33f2:	68 ad 4d 00 00       	push   $0x4dad
    33f7:	ff 35 20 5f 00 00    	pushl  0x5f20
    33fd:	e8 0e 07 00 00       	call   3b10 <printf>
    fd = open("bigarg-ok", O_CREATE);
    3402:	58                   	pop    %eax
    3403:	5a                   	pop    %edx
    3404:	68 00 02 00 00       	push   $0x200
    3409:	68 96 4d 00 00       	push   $0x4d96
    340e:	e8 d0 05 00 00       	call   39e3 <open>
    close(fd);
    3413:	89 04 24             	mov    %eax,(%esp)
    3416:	e8 b0 05 00 00       	call   39cb <close>
    exit();
    341b:	e8 83 05 00 00       	call   39a3 <exit>
    printf(stdout, "bigarg test failed!\n");
    3420:	50                   	push   %eax
    3421:	50                   	push   %eax
    3422:	68 d6 4d 00 00       	push   $0x4dd6
    3427:	ff 35 20 5f 00 00    	pushl  0x5f20
    342d:	e8 de 06 00 00       	call   3b10 <printf>
    exit();
    3432:	e8 6c 05 00 00       	call   39a3 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    3437:	52                   	push   %edx
    3438:	52                   	push   %edx
    3439:	68 bd 4d 00 00       	push   $0x4dbd
    343e:	ff 35 20 5f 00 00    	pushl  0x5f20
    3444:	e8 c7 06 00 00       	call   3b10 <printf>
    exit();
    3449:	e8 55 05 00 00       	call   39a3 <exit>
    344e:	66 90                	xchg   %ax,%ax

00003450 <fsfull>:
{
    3450:	f3 0f 1e fb          	endbr32 
    3454:	55                   	push   %ebp
    3455:	89 e5                	mov    %esp,%ebp
    3457:	57                   	push   %edi
    3458:	56                   	push   %esi
  for(nfiles = 0; ; nfiles++){
    3459:	31 f6                	xor    %esi,%esi
{
    345b:	53                   	push   %ebx
    345c:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    345f:	68 eb 4d 00 00       	push   $0x4deb
    3464:	6a 01                	push   $0x1
    3466:	e8 a5 06 00 00       	call   3b10 <printf>
    346b:	83 c4 10             	add    $0x10,%esp
    346e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + nfiles / 1000;
    3470:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3475:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    347a:	83 ec 04             	sub    $0x4,%esp
    name[0] = 'f';
    347d:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3481:	f7 e6                	mul    %esi
    name[5] = '\0';
    3483:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3487:	c1 ea 06             	shr    $0x6,%edx
    348a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    348d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3493:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3496:	89 f0                	mov    %esi,%eax
    3498:	29 d0                	sub    %edx,%eax
    349a:	89 c2                	mov    %eax,%edx
    349c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    34a1:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    34a3:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    34a8:	c1 ea 05             	shr    $0x5,%edx
    34ab:	83 c2 30             	add    $0x30,%edx
    34ae:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    34b1:	f7 e6                	mul    %esi
    34b3:	89 f0                	mov    %esi,%eax
    34b5:	c1 ea 05             	shr    $0x5,%edx
    34b8:	6b d2 64             	imul   $0x64,%edx,%edx
    34bb:	29 d0                	sub    %edx,%eax
    34bd:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    34bf:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    34c1:	c1 ea 03             	shr    $0x3,%edx
    34c4:	83 c2 30             	add    $0x30,%edx
    34c7:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    34ca:	f7 e1                	mul    %ecx
    34cc:	89 f1                	mov    %esi,%ecx
    34ce:	c1 ea 03             	shr    $0x3,%edx
    34d1:	8d 04 92             	lea    (%edx,%edx,4),%eax
    34d4:	01 c0                	add    %eax,%eax
    34d6:	29 c1                	sub    %eax,%ecx
    34d8:	89 c8                	mov    %ecx,%eax
    34da:	83 c0 30             	add    $0x30,%eax
    34dd:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    34e0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34e3:	50                   	push   %eax
    34e4:	68 f8 4d 00 00       	push   $0x4df8
    34e9:	6a 01                	push   $0x1
    34eb:	e8 20 06 00 00       	call   3b10 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    34f0:	58                   	pop    %eax
    34f1:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34f4:	5a                   	pop    %edx
    34f5:	68 02 02 00 00       	push   $0x202
    34fa:	50                   	push   %eax
    34fb:	e8 e3 04 00 00       	call   39e3 <open>
    if(fd < 0){
    3500:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    3503:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    3505:	85 c0                	test   %eax,%eax
    3507:	78 4d                	js     3556 <fsfull+0x106>
    int total = 0;
    3509:	31 db                	xor    %ebx,%ebx
    350b:	eb 05                	jmp    3512 <fsfull+0xc2>
    350d:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    3510:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    3512:	83 ec 04             	sub    $0x4,%esp
    3515:	68 00 02 00 00       	push   $0x200
    351a:	68 00 87 00 00       	push   $0x8700
    351f:	57                   	push   %edi
    3520:	e8 9e 04 00 00       	call   39c3 <write>
      if(cc < 512)
    3525:	83 c4 10             	add    $0x10,%esp
    3528:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    352d:	7f e1                	jg     3510 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    352f:	83 ec 04             	sub    $0x4,%esp
    3532:	53                   	push   %ebx
    3533:	68 14 4e 00 00       	push   $0x4e14
    3538:	6a 01                	push   $0x1
    353a:	e8 d1 05 00 00       	call   3b10 <printf>
    close(fd);
    353f:	89 3c 24             	mov    %edi,(%esp)
    3542:	e8 84 04 00 00       	call   39cb <close>
    if(total == 0)
    3547:	83 c4 10             	add    $0x10,%esp
    354a:	85 db                	test   %ebx,%ebx
    354c:	74 1e                	je     356c <fsfull+0x11c>
  for(nfiles = 0; ; nfiles++){
    354e:	83 c6 01             	add    $0x1,%esi
    3551:	e9 1a ff ff ff       	jmp    3470 <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    3556:	83 ec 04             	sub    $0x4,%esp
    3559:	8d 45 a8             	lea    -0x58(%ebp),%eax
    355c:	50                   	push   %eax
    355d:	68 04 4e 00 00       	push   $0x4e04
    3562:	6a 01                	push   $0x1
    3564:	e8 a7 05 00 00       	call   3b10 <printf>
      break;
    3569:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    356c:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    3571:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
    3576:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    357d:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    3580:	89 f0                	mov    %esi,%eax
    3582:	89 f1                	mov    %esi,%ecx
    unlink(name);
    3584:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'f';
    3587:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    358b:	f7 ef                	imul   %edi
    358d:	c1 f9 1f             	sar    $0x1f,%ecx
    name[5] = '\0';
    3590:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3594:	c1 fa 06             	sar    $0x6,%edx
    3597:	29 ca                	sub    %ecx,%edx
    3599:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    359c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    35a2:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    35a5:	89 f0                	mov    %esi,%eax
    35a7:	29 d0                	sub    %edx,%eax
    35a9:	f7 e3                	mul    %ebx
    name[3] = '0' + (nfiles % 100) / 10;
    35ab:	89 f0                	mov    %esi,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    35ad:	c1 ea 05             	shr    $0x5,%edx
    35b0:	83 c2 30             	add    $0x30,%edx
    35b3:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    35b6:	f7 eb                	imul   %ebx
    35b8:	89 f0                	mov    %esi,%eax
    35ba:	c1 fa 05             	sar    $0x5,%edx
    35bd:	29 ca                	sub    %ecx,%edx
    35bf:	6b d2 64             	imul   $0x64,%edx,%edx
    35c2:	29 d0                	sub    %edx,%eax
    35c4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    35c9:	f7 e2                	mul    %edx
    name[4] = '0' + (nfiles % 10);
    35cb:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    35cd:	c1 ea 03             	shr    $0x3,%edx
    35d0:	83 c2 30             	add    $0x30,%edx
    35d3:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    35d6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    35db:	f7 ea                	imul   %edx
    35dd:	c1 fa 02             	sar    $0x2,%edx
    35e0:	29 ca                	sub    %ecx,%edx
    35e2:	89 f1                	mov    %esi,%ecx
    nfiles--;
    35e4:	83 ee 01             	sub    $0x1,%esi
    name[4] = '0' + (nfiles % 10);
    35e7:	8d 04 92             	lea    (%edx,%edx,4),%eax
    35ea:	01 c0                	add    %eax,%eax
    35ec:	29 c1                	sub    %eax,%ecx
    35ee:	89 c8                	mov    %ecx,%eax
    35f0:	83 c0 30             	add    $0x30,%eax
    35f3:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    35f6:	8d 45 a8             	lea    -0x58(%ebp),%eax
    35f9:	50                   	push   %eax
    35fa:	e8 f4 03 00 00       	call   39f3 <unlink>
  while(nfiles >= 0){
    35ff:	83 c4 10             	add    $0x10,%esp
    3602:	83 fe ff             	cmp    $0xffffffff,%esi
    3605:	0f 85 75 ff ff ff    	jne    3580 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    360b:	83 ec 08             	sub    $0x8,%esp
    360e:	68 24 4e 00 00       	push   $0x4e24
    3613:	6a 01                	push   $0x1
    3615:	e8 f6 04 00 00       	call   3b10 <printf>
}
    361a:	83 c4 10             	add    $0x10,%esp
    361d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3620:	5b                   	pop    %ebx
    3621:	5e                   	pop    %esi
    3622:	5f                   	pop    %edi
    3623:	5d                   	pop    %ebp
    3624:	c3                   	ret    
    3625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003630 <uio>:
{
    3630:	f3 0f 1e fb          	endbr32 
    3634:	55                   	push   %ebp
    3635:	89 e5                	mov    %esp,%ebp
    3637:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    363a:	68 3a 4e 00 00       	push   $0x4e3a
    363f:	6a 01                	push   $0x1
    3641:	e8 ca 04 00 00       	call   3b10 <printf>
  pid = fork();
    3646:	e8 50 03 00 00       	call   399b <fork>
  if(pid == 0){
    364b:	83 c4 10             	add    $0x10,%esp
    364e:	85 c0                	test   %eax,%eax
    3650:	74 1b                	je     366d <uio+0x3d>
  } else if(pid < 0){
    3652:	78 3d                	js     3691 <uio+0x61>
  wait();
    3654:	e8 52 03 00 00       	call   39ab <wait>
  printf(1, "uio test done\n");
    3659:	83 ec 08             	sub    $0x8,%esp
    365c:	68 44 4e 00 00       	push   $0x4e44
    3661:	6a 01                	push   $0x1
    3663:	e8 a8 04 00 00       	call   3b10 <printf>
}
    3668:	83 c4 10             	add    $0x10,%esp
    366b:	c9                   	leave  
    366c:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    366d:	b8 09 00 00 00       	mov    $0x9,%eax
    3672:	ba 70 00 00 00       	mov    $0x70,%edx
    3677:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3678:	ba 71 00 00 00       	mov    $0x71,%edx
    367d:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    367e:	52                   	push   %edx
    367f:	52                   	push   %edx
    3680:	68 d0 55 00 00       	push   $0x55d0
    3685:	6a 01                	push   $0x1
    3687:	e8 84 04 00 00       	call   3b10 <printf>
    exit();
    368c:	e8 12 03 00 00       	call   39a3 <exit>
    printf (1, "fork failed\n");
    3691:	50                   	push   %eax
    3692:	50                   	push   %eax
    3693:	68 c9 4d 00 00       	push   $0x4dc9
    3698:	6a 01                	push   $0x1
    369a:	e8 71 04 00 00       	call   3b10 <printf>
    exit();
    369f:	e8 ff 02 00 00       	call   39a3 <exit>
    36a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    36ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    36af:	90                   	nop

000036b0 <argptest>:
{
    36b0:	f3 0f 1e fb          	endbr32 
    36b4:	55                   	push   %ebp
    36b5:	89 e5                	mov    %esp,%ebp
    36b7:	53                   	push   %ebx
    36b8:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    36bb:	6a 00                	push   $0x0
    36bd:	68 53 4e 00 00       	push   $0x4e53
    36c2:	e8 1c 03 00 00       	call   39e3 <open>
  if (fd < 0) {
    36c7:	83 c4 10             	add    $0x10,%esp
    36ca:	85 c0                	test   %eax,%eax
    36cc:	78 39                	js     3707 <argptest+0x57>
  read(fd, sbrk(0) - 1, -1);
    36ce:	83 ec 0c             	sub    $0xc,%esp
    36d1:	89 c3                	mov    %eax,%ebx
    36d3:	6a 00                	push   $0x0
    36d5:	e8 51 03 00 00       	call   3a2b <sbrk>
    36da:	83 c4 0c             	add    $0xc,%esp
    36dd:	83 e8 01             	sub    $0x1,%eax
    36e0:	6a ff                	push   $0xffffffff
    36e2:	50                   	push   %eax
    36e3:	53                   	push   %ebx
    36e4:	e8 d2 02 00 00       	call   39bb <read>
  close(fd);
    36e9:	89 1c 24             	mov    %ebx,(%esp)
    36ec:	e8 da 02 00 00       	call   39cb <close>
  printf(1, "arg test passed\n");
    36f1:	58                   	pop    %eax
    36f2:	5a                   	pop    %edx
    36f3:	68 65 4e 00 00       	push   $0x4e65
    36f8:	6a 01                	push   $0x1
    36fa:	e8 11 04 00 00       	call   3b10 <printf>
}
    36ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3702:	83 c4 10             	add    $0x10,%esp
    3705:	c9                   	leave  
    3706:	c3                   	ret    
    printf(2, "open failed\n");
    3707:	51                   	push   %ecx
    3708:	51                   	push   %ecx
    3709:	68 58 4e 00 00       	push   $0x4e58
    370e:	6a 02                	push   $0x2
    3710:	e8 fb 03 00 00       	call   3b10 <printf>
    exit();
    3715:	e8 89 02 00 00       	call   39a3 <exit>
    371a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003720 <rand>:
{
    3720:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    3724:	69 05 1c 5f 00 00 0d 	imul   $0x19660d,0x5f1c,%eax
    372b:	66 19 00 
    372e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3733:	a3 1c 5f 00 00       	mov    %eax,0x5f1c
}
    3738:	c3                   	ret    
    3739:	66 90                	xchg   %ax,%ax
    373b:	66 90                	xchg   %ax,%ax
    373d:	66 90                	xchg   %ax,%ax
    373f:	90                   	nop

00003740 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3740:	f3 0f 1e fb          	endbr32 
    3744:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3745:	31 c0                	xor    %eax,%eax
{
    3747:	89 e5                	mov    %esp,%ebp
    3749:	53                   	push   %ebx
    374a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    374d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    3750:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    3754:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    3757:	83 c0 01             	add    $0x1,%eax
    375a:	84 d2                	test   %dl,%dl
    375c:	75 f2                	jne    3750 <strcpy+0x10>
    ;
  return os;
}
    375e:	89 c8                	mov    %ecx,%eax
    3760:	5b                   	pop    %ebx
    3761:	5d                   	pop    %ebp
    3762:	c3                   	ret    
    3763:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    376a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003770 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3770:	f3 0f 1e fb          	endbr32 
    3774:	55                   	push   %ebp
    3775:	89 e5                	mov    %esp,%ebp
    3777:	53                   	push   %ebx
    3778:	8b 4d 08             	mov    0x8(%ebp),%ecx
    377b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    377e:	0f b6 01             	movzbl (%ecx),%eax
    3781:	0f b6 1a             	movzbl (%edx),%ebx
    3784:	84 c0                	test   %al,%al
    3786:	75 19                	jne    37a1 <strcmp+0x31>
    3788:	eb 26                	jmp    37b0 <strcmp+0x40>
    378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3790:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    3794:	83 c1 01             	add    $0x1,%ecx
    3797:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    379a:	0f b6 1a             	movzbl (%edx),%ebx
    379d:	84 c0                	test   %al,%al
    379f:	74 0f                	je     37b0 <strcmp+0x40>
    37a1:	38 d8                	cmp    %bl,%al
    37a3:	74 eb                	je     3790 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    37a5:	29 d8                	sub    %ebx,%eax
}
    37a7:	5b                   	pop    %ebx
    37a8:	5d                   	pop    %ebp
    37a9:	c3                   	ret    
    37aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    37b0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    37b2:	29 d8                	sub    %ebx,%eax
}
    37b4:	5b                   	pop    %ebx
    37b5:	5d                   	pop    %ebp
    37b6:	c3                   	ret    
    37b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37be:	66 90                	xchg   %ax,%ax

000037c0 <strlen>:

uint
strlen(const char *s)
{
    37c0:	f3 0f 1e fb          	endbr32 
    37c4:	55                   	push   %ebp
    37c5:	89 e5                	mov    %esp,%ebp
    37c7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    37ca:	80 3a 00             	cmpb   $0x0,(%edx)
    37cd:	74 21                	je     37f0 <strlen+0x30>
    37cf:	31 c0                	xor    %eax,%eax
    37d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37d8:	83 c0 01             	add    $0x1,%eax
    37db:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    37df:	89 c1                	mov    %eax,%ecx
    37e1:	75 f5                	jne    37d8 <strlen+0x18>
    ;
  return n;
}
    37e3:	89 c8                	mov    %ecx,%eax
    37e5:	5d                   	pop    %ebp
    37e6:	c3                   	ret    
    37e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37ee:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    37f0:	31 c9                	xor    %ecx,%ecx
}
    37f2:	5d                   	pop    %ebp
    37f3:	89 c8                	mov    %ecx,%eax
    37f5:	c3                   	ret    
    37f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37fd:	8d 76 00             	lea    0x0(%esi),%esi

00003800 <memset>:

void*
memset(void *dst, int c, uint n)
{
    3800:	f3 0f 1e fb          	endbr32 
    3804:	55                   	push   %ebp
    3805:	89 e5                	mov    %esp,%ebp
    3807:	57                   	push   %edi
    3808:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    380b:	8b 4d 10             	mov    0x10(%ebp),%ecx
    380e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3811:	89 d7                	mov    %edx,%edi
    3813:	fc                   	cld    
    3814:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3816:	89 d0                	mov    %edx,%eax
    3818:	5f                   	pop    %edi
    3819:	5d                   	pop    %ebp
    381a:	c3                   	ret    
    381b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    381f:	90                   	nop

00003820 <strchr>:

char*
strchr(const char *s, char c)
{
    3820:	f3 0f 1e fb          	endbr32 
    3824:	55                   	push   %ebp
    3825:	89 e5                	mov    %esp,%ebp
    3827:	8b 45 08             	mov    0x8(%ebp),%eax
    382a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    382e:	0f b6 10             	movzbl (%eax),%edx
    3831:	84 d2                	test   %dl,%dl
    3833:	75 16                	jne    384b <strchr+0x2b>
    3835:	eb 21                	jmp    3858 <strchr+0x38>
    3837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    383e:	66 90                	xchg   %ax,%ax
    3840:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    3844:	83 c0 01             	add    $0x1,%eax
    3847:	84 d2                	test   %dl,%dl
    3849:	74 0d                	je     3858 <strchr+0x38>
    if(*s == c)
    384b:	38 d1                	cmp    %dl,%cl
    384d:	75 f1                	jne    3840 <strchr+0x20>
      return (char*)s;
  return 0;
}
    384f:	5d                   	pop    %ebp
    3850:	c3                   	ret    
    3851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    3858:	31 c0                	xor    %eax,%eax
}
    385a:	5d                   	pop    %ebp
    385b:	c3                   	ret    
    385c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003860 <gets>:

char*
gets(char *buf, int max)
{
    3860:	f3 0f 1e fb          	endbr32 
    3864:	55                   	push   %ebp
    3865:	89 e5                	mov    %esp,%ebp
    3867:	57                   	push   %edi
    3868:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3869:	31 f6                	xor    %esi,%esi
{
    386b:	53                   	push   %ebx
    386c:	89 f3                	mov    %esi,%ebx
    386e:	83 ec 1c             	sub    $0x1c,%esp
    3871:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    3874:	eb 33                	jmp    38a9 <gets+0x49>
    3876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    387d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    3880:	83 ec 04             	sub    $0x4,%esp
    3883:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3886:	6a 01                	push   $0x1
    3888:	50                   	push   %eax
    3889:	6a 00                	push   $0x0
    388b:	e8 2b 01 00 00       	call   39bb <read>
    if(cc < 1)
    3890:	83 c4 10             	add    $0x10,%esp
    3893:	85 c0                	test   %eax,%eax
    3895:	7e 1c                	jle    38b3 <gets+0x53>
      break;
    buf[i++] = c;
    3897:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    389b:	83 c7 01             	add    $0x1,%edi
    389e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    38a1:	3c 0a                	cmp    $0xa,%al
    38a3:	74 23                	je     38c8 <gets+0x68>
    38a5:	3c 0d                	cmp    $0xd,%al
    38a7:	74 1f                	je     38c8 <gets+0x68>
  for(i=0; i+1 < max; ){
    38a9:	83 c3 01             	add    $0x1,%ebx
    38ac:	89 fe                	mov    %edi,%esi
    38ae:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    38b1:	7c cd                	jl     3880 <gets+0x20>
    38b3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    38b5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    38b8:	c6 03 00             	movb   $0x0,(%ebx)
}
    38bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
    38be:	5b                   	pop    %ebx
    38bf:	5e                   	pop    %esi
    38c0:	5f                   	pop    %edi
    38c1:	5d                   	pop    %ebp
    38c2:	c3                   	ret    
    38c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    38c7:	90                   	nop
    38c8:	8b 75 08             	mov    0x8(%ebp),%esi
    38cb:	8b 45 08             	mov    0x8(%ebp),%eax
    38ce:	01 de                	add    %ebx,%esi
    38d0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    38d2:	c6 03 00             	movb   $0x0,(%ebx)
}
    38d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    38d8:	5b                   	pop    %ebx
    38d9:	5e                   	pop    %esi
    38da:	5f                   	pop    %edi
    38db:	5d                   	pop    %ebp
    38dc:	c3                   	ret    
    38dd:	8d 76 00             	lea    0x0(%esi),%esi

000038e0 <stat>:

int
stat(const char *n, struct stat *st)
{
    38e0:	f3 0f 1e fb          	endbr32 
    38e4:	55                   	push   %ebp
    38e5:	89 e5                	mov    %esp,%ebp
    38e7:	56                   	push   %esi
    38e8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    38e9:	83 ec 08             	sub    $0x8,%esp
    38ec:	6a 00                	push   $0x0
    38ee:	ff 75 08             	pushl  0x8(%ebp)
    38f1:	e8 ed 00 00 00       	call   39e3 <open>
  if(fd < 0)
    38f6:	83 c4 10             	add    $0x10,%esp
    38f9:	85 c0                	test   %eax,%eax
    38fb:	78 2b                	js     3928 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    38fd:	83 ec 08             	sub    $0x8,%esp
    3900:	ff 75 0c             	pushl  0xc(%ebp)
    3903:	89 c3                	mov    %eax,%ebx
    3905:	50                   	push   %eax
    3906:	e8 f0 00 00 00       	call   39fb <fstat>
  close(fd);
    390b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    390e:	89 c6                	mov    %eax,%esi
  close(fd);
    3910:	e8 b6 00 00 00       	call   39cb <close>
  return r;
    3915:	83 c4 10             	add    $0x10,%esp
}
    3918:	8d 65 f8             	lea    -0x8(%ebp),%esp
    391b:	89 f0                	mov    %esi,%eax
    391d:	5b                   	pop    %ebx
    391e:	5e                   	pop    %esi
    391f:	5d                   	pop    %ebp
    3920:	c3                   	ret    
    3921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    3928:	be ff ff ff ff       	mov    $0xffffffff,%esi
    392d:	eb e9                	jmp    3918 <stat+0x38>
    392f:	90                   	nop

00003930 <atoi>:

int
atoi(const char *s)
{
    3930:	f3 0f 1e fb          	endbr32 
    3934:	55                   	push   %ebp
    3935:	89 e5                	mov    %esp,%ebp
    3937:	53                   	push   %ebx
    3938:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    393b:	0f be 02             	movsbl (%edx),%eax
    393e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    3941:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    3944:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    3949:	77 1a                	ja     3965 <atoi+0x35>
    394b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    394f:	90                   	nop
    n = n*10 + *s++ - '0';
    3950:	83 c2 01             	add    $0x1,%edx
    3953:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    3956:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    395a:	0f be 02             	movsbl (%edx),%eax
    395d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3960:	80 fb 09             	cmp    $0x9,%bl
    3963:	76 eb                	jbe    3950 <atoi+0x20>
  return n;
}
    3965:	89 c8                	mov    %ecx,%eax
    3967:	5b                   	pop    %ebx
    3968:	5d                   	pop    %ebp
    3969:	c3                   	ret    
    396a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003970 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3970:	f3 0f 1e fb          	endbr32 
    3974:	55                   	push   %ebp
    3975:	89 e5                	mov    %esp,%ebp
    3977:	57                   	push   %edi
    3978:	8b 45 10             	mov    0x10(%ebp),%eax
    397b:	8b 55 08             	mov    0x8(%ebp),%edx
    397e:	56                   	push   %esi
    397f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3982:	85 c0                	test   %eax,%eax
    3984:	7e 0f                	jle    3995 <memmove+0x25>
    3986:	01 d0                	add    %edx,%eax
  dst = vdst;
    3988:	89 d7                	mov    %edx,%edi
    398a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    3990:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    3991:	39 f8                	cmp    %edi,%eax
    3993:	75 fb                	jne    3990 <memmove+0x20>
  return vdst;
}
    3995:	5e                   	pop    %esi
    3996:	89 d0                	mov    %edx,%eax
    3998:	5f                   	pop    %edi
    3999:	5d                   	pop    %ebp
    399a:	c3                   	ret    

0000399b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    399b:	b8 01 00 00 00       	mov    $0x1,%eax
    39a0:	cd 40                	int    $0x40
    39a2:	c3                   	ret    

000039a3 <exit>:
SYSCALL(exit)
    39a3:	b8 02 00 00 00       	mov    $0x2,%eax
    39a8:	cd 40                	int    $0x40
    39aa:	c3                   	ret    

000039ab <wait>:
SYSCALL(wait)
    39ab:	b8 03 00 00 00       	mov    $0x3,%eax
    39b0:	cd 40                	int    $0x40
    39b2:	c3                   	ret    

000039b3 <pipe>:
SYSCALL(pipe)
    39b3:	b8 04 00 00 00       	mov    $0x4,%eax
    39b8:	cd 40                	int    $0x40
    39ba:	c3                   	ret    

000039bb <read>:
SYSCALL(read)
    39bb:	b8 05 00 00 00       	mov    $0x5,%eax
    39c0:	cd 40                	int    $0x40
    39c2:	c3                   	ret    

000039c3 <write>:
SYSCALL(write)
    39c3:	b8 10 00 00 00       	mov    $0x10,%eax
    39c8:	cd 40                	int    $0x40
    39ca:	c3                   	ret    

000039cb <close>:
SYSCALL(close)
    39cb:	b8 15 00 00 00       	mov    $0x15,%eax
    39d0:	cd 40                	int    $0x40
    39d2:	c3                   	ret    

000039d3 <kill>:
SYSCALL(kill)
    39d3:	b8 06 00 00 00       	mov    $0x6,%eax
    39d8:	cd 40                	int    $0x40
    39da:	c3                   	ret    

000039db <exec>:
SYSCALL(exec)
    39db:	b8 07 00 00 00       	mov    $0x7,%eax
    39e0:	cd 40                	int    $0x40
    39e2:	c3                   	ret    

000039e3 <open>:
SYSCALL(open)
    39e3:	b8 0f 00 00 00       	mov    $0xf,%eax
    39e8:	cd 40                	int    $0x40
    39ea:	c3                   	ret    

000039eb <mknod>:
SYSCALL(mknod)
    39eb:	b8 11 00 00 00       	mov    $0x11,%eax
    39f0:	cd 40                	int    $0x40
    39f2:	c3                   	ret    

000039f3 <unlink>:
SYSCALL(unlink)
    39f3:	b8 12 00 00 00       	mov    $0x12,%eax
    39f8:	cd 40                	int    $0x40
    39fa:	c3                   	ret    

000039fb <fstat>:
SYSCALL(fstat)
    39fb:	b8 08 00 00 00       	mov    $0x8,%eax
    3a00:	cd 40                	int    $0x40
    3a02:	c3                   	ret    

00003a03 <link>:
SYSCALL(link)
    3a03:	b8 13 00 00 00       	mov    $0x13,%eax
    3a08:	cd 40                	int    $0x40
    3a0a:	c3                   	ret    

00003a0b <mkdir>:
SYSCALL(mkdir)
    3a0b:	b8 14 00 00 00       	mov    $0x14,%eax
    3a10:	cd 40                	int    $0x40
    3a12:	c3                   	ret    

00003a13 <chdir>:
SYSCALL(chdir)
    3a13:	b8 09 00 00 00       	mov    $0x9,%eax
    3a18:	cd 40                	int    $0x40
    3a1a:	c3                   	ret    

00003a1b <dup>:
SYSCALL(dup)
    3a1b:	b8 0a 00 00 00       	mov    $0xa,%eax
    3a20:	cd 40                	int    $0x40
    3a22:	c3                   	ret    

00003a23 <getpid>:
SYSCALL(getpid)
    3a23:	b8 0b 00 00 00       	mov    $0xb,%eax
    3a28:	cd 40                	int    $0x40
    3a2a:	c3                   	ret    

00003a2b <sbrk>:
SYSCALL(sbrk)
    3a2b:	b8 0c 00 00 00       	mov    $0xc,%eax
    3a30:	cd 40                	int    $0x40
    3a32:	c3                   	ret    

00003a33 <sleep>:
SYSCALL(sleep)
    3a33:	b8 0d 00 00 00       	mov    $0xd,%eax
    3a38:	cd 40                	int    $0x40
    3a3a:	c3                   	ret    

00003a3b <uptime>:
SYSCALL(uptime)
    3a3b:	b8 0e 00 00 00       	mov    $0xe,%eax
    3a40:	cd 40                	int    $0x40
    3a42:	c3                   	ret    

00003a43 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
    3a43:	b8 16 00 00 00       	mov    $0x16,%eax
    3a48:	cd 40                	int    $0x40
    3a4a:	c3                   	ret    

00003a4b <getTotalFreePages>:
SYSCALL(getTotalFreePages)
    3a4b:	b8 17 00 00 00       	mov    $0x17,%eax
    3a50:	cd 40                	int    $0x40
    3a52:	c3                   	ret    
    3a53:	66 90                	xchg   %ax,%ax
    3a55:	66 90                	xchg   %ax,%ax
    3a57:	66 90                	xchg   %ax,%ax
    3a59:	66 90                	xchg   %ax,%ax
    3a5b:	66 90                	xchg   %ax,%ax
    3a5d:	66 90                	xchg   %ax,%ax
    3a5f:	90                   	nop

00003a60 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3a60:	55                   	push   %ebp
    3a61:	89 e5                	mov    %esp,%ebp
    3a63:	57                   	push   %edi
    3a64:	56                   	push   %esi
    3a65:	53                   	push   %ebx
    3a66:	83 ec 3c             	sub    $0x3c,%esp
    3a69:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3a6c:	89 d1                	mov    %edx,%ecx
{
    3a6e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    3a71:	85 d2                	test   %edx,%edx
    3a73:	0f 89 7f 00 00 00    	jns    3af8 <printint+0x98>
    3a79:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    3a7d:	74 79                	je     3af8 <printint+0x98>
    neg = 1;
    3a7f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    3a86:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    3a88:	31 db                	xor    %ebx,%ebx
    3a8a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    3a8d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    3a90:	89 c8                	mov    %ecx,%eax
    3a92:	31 d2                	xor    %edx,%edx
    3a94:	89 cf                	mov    %ecx,%edi
    3a96:	f7 75 c4             	divl   -0x3c(%ebp)
    3a99:	0f b6 92 28 56 00 00 	movzbl 0x5628(%edx),%edx
    3aa0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    3aa3:	89 d8                	mov    %ebx,%eax
    3aa5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    3aa8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    3aab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    3aae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    3ab1:	76 dd                	jbe    3a90 <printint+0x30>
  if(neg)
    3ab3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    3ab6:	85 c9                	test   %ecx,%ecx
    3ab8:	74 0c                	je     3ac6 <printint+0x66>
    buf[i++] = '-';
    3aba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    3abf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    3ac1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    3ac6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    3ac9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    3acd:	eb 07                	jmp    3ad6 <printint+0x76>
    3acf:	90                   	nop
    3ad0:	0f b6 13             	movzbl (%ebx),%edx
    3ad3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    3ad6:	83 ec 04             	sub    $0x4,%esp
    3ad9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    3adc:	6a 01                	push   $0x1
    3ade:	56                   	push   %esi
    3adf:	57                   	push   %edi
    3ae0:	e8 de fe ff ff       	call   39c3 <write>
  while(--i >= 0)
    3ae5:	83 c4 10             	add    $0x10,%esp
    3ae8:	39 de                	cmp    %ebx,%esi
    3aea:	75 e4                	jne    3ad0 <printint+0x70>
    putc(fd, buf[i]);
}
    3aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3aef:	5b                   	pop    %ebx
    3af0:	5e                   	pop    %esi
    3af1:	5f                   	pop    %edi
    3af2:	5d                   	pop    %ebp
    3af3:	c3                   	ret    
    3af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    3af8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    3aff:	eb 87                	jmp    3a88 <printint+0x28>
    3b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3b08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3b0f:	90                   	nop

00003b10 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3b10:	f3 0f 1e fb          	endbr32 
    3b14:	55                   	push   %ebp
    3b15:	89 e5                	mov    %esp,%ebp
    3b17:	57                   	push   %edi
    3b18:	56                   	push   %esi
    3b19:	53                   	push   %ebx
    3b1a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3b1d:	8b 75 0c             	mov    0xc(%ebp),%esi
    3b20:	0f b6 1e             	movzbl (%esi),%ebx
    3b23:	84 db                	test   %bl,%bl
    3b25:	0f 84 b4 00 00 00    	je     3bdf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    3b2b:	8d 45 10             	lea    0x10(%ebp),%eax
    3b2e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    3b31:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    3b34:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    3b36:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3b39:	eb 33                	jmp    3b6e <printf+0x5e>
    3b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3b3f:	90                   	nop
    3b40:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    3b43:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    3b48:	83 f8 25             	cmp    $0x25,%eax
    3b4b:	74 17                	je     3b64 <printf+0x54>
  write(fd, &c, 1);
    3b4d:	83 ec 04             	sub    $0x4,%esp
    3b50:	88 5d e7             	mov    %bl,-0x19(%ebp)
    3b53:	6a 01                	push   $0x1
    3b55:	57                   	push   %edi
    3b56:	ff 75 08             	pushl  0x8(%ebp)
    3b59:	e8 65 fe ff ff       	call   39c3 <write>
    3b5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    3b61:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    3b64:	0f b6 1e             	movzbl (%esi),%ebx
    3b67:	83 c6 01             	add    $0x1,%esi
    3b6a:	84 db                	test   %bl,%bl
    3b6c:	74 71                	je     3bdf <printf+0xcf>
    c = fmt[i] & 0xff;
    3b6e:	0f be cb             	movsbl %bl,%ecx
    3b71:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3b74:	85 d2                	test   %edx,%edx
    3b76:	74 c8                	je     3b40 <printf+0x30>
      }
    } else if(state == '%'){
    3b78:	83 fa 25             	cmp    $0x25,%edx
    3b7b:	75 e7                	jne    3b64 <printf+0x54>
      if(c == 'd'){
    3b7d:	83 f8 64             	cmp    $0x64,%eax
    3b80:	0f 84 9a 00 00 00    	je     3c20 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3b86:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    3b8c:	83 f9 70             	cmp    $0x70,%ecx
    3b8f:	74 5f                	je     3bf0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3b91:	83 f8 73             	cmp    $0x73,%eax
    3b94:	0f 84 d6 00 00 00    	je     3c70 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3b9a:	83 f8 63             	cmp    $0x63,%eax
    3b9d:	0f 84 8d 00 00 00    	je     3c30 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3ba3:	83 f8 25             	cmp    $0x25,%eax
    3ba6:	0f 84 b4 00 00 00    	je     3c60 <printf+0x150>
  write(fd, &c, 1);
    3bac:	83 ec 04             	sub    $0x4,%esp
    3baf:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3bb3:	6a 01                	push   $0x1
    3bb5:	57                   	push   %edi
    3bb6:	ff 75 08             	pushl  0x8(%ebp)
    3bb9:	e8 05 fe ff ff       	call   39c3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3bbe:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3bc1:	83 c4 0c             	add    $0xc,%esp
    3bc4:	6a 01                	push   $0x1
    3bc6:	83 c6 01             	add    $0x1,%esi
    3bc9:	57                   	push   %edi
    3bca:	ff 75 08             	pushl  0x8(%ebp)
    3bcd:	e8 f1 fd ff ff       	call   39c3 <write>
  for(i = 0; fmt[i]; i++){
    3bd2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    3bd6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3bd9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    3bdb:	84 db                	test   %bl,%bl
    3bdd:	75 8f                	jne    3b6e <printf+0x5e>
    }
  }
}
    3bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3be2:	5b                   	pop    %ebx
    3be3:	5e                   	pop    %esi
    3be4:	5f                   	pop    %edi
    3be5:	5d                   	pop    %ebp
    3be6:	c3                   	ret    
    3be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3bee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    3bf0:	83 ec 0c             	sub    $0xc,%esp
    3bf3:	b9 10 00 00 00       	mov    $0x10,%ecx
    3bf8:	6a 00                	push   $0x0
    3bfa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    3bfd:	8b 45 08             	mov    0x8(%ebp),%eax
    3c00:	8b 13                	mov    (%ebx),%edx
    3c02:	e8 59 fe ff ff       	call   3a60 <printint>
        ap++;
    3c07:	89 d8                	mov    %ebx,%eax
    3c09:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3c0c:	31 d2                	xor    %edx,%edx
        ap++;
    3c0e:	83 c0 04             	add    $0x4,%eax
    3c11:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3c14:	e9 4b ff ff ff       	jmp    3b64 <printf+0x54>
    3c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    3c20:	83 ec 0c             	sub    $0xc,%esp
    3c23:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3c28:	6a 01                	push   $0x1
    3c2a:	eb ce                	jmp    3bfa <printf+0xea>
    3c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    3c30:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    3c33:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3c36:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    3c38:	6a 01                	push   $0x1
        ap++;
    3c3a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    3c3d:	57                   	push   %edi
    3c3e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    3c41:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3c44:	e8 7a fd ff ff       	call   39c3 <write>
        ap++;
    3c49:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3c4c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3c4f:	31 d2                	xor    %edx,%edx
    3c51:	e9 0e ff ff ff       	jmp    3b64 <printf+0x54>
    3c56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c5d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    3c60:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3c63:	83 ec 04             	sub    $0x4,%esp
    3c66:	e9 59 ff ff ff       	jmp    3bc4 <printf+0xb4>
    3c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3c6f:	90                   	nop
        s = (char*)*ap;
    3c70:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3c73:	8b 18                	mov    (%eax),%ebx
        ap++;
    3c75:	83 c0 04             	add    $0x4,%eax
    3c78:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    3c7b:	85 db                	test   %ebx,%ebx
    3c7d:	74 17                	je     3c96 <printf+0x186>
        while(*s != 0){
    3c7f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    3c82:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    3c84:	84 c0                	test   %al,%al
    3c86:	0f 84 d8 fe ff ff    	je     3b64 <printf+0x54>
    3c8c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3c8f:	89 de                	mov    %ebx,%esi
    3c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3c94:	eb 1a                	jmp    3cb0 <printf+0x1a0>
          s = "(null)";
    3c96:	bb 1e 56 00 00       	mov    $0x561e,%ebx
        while(*s != 0){
    3c9b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3c9e:	b8 28 00 00 00       	mov    $0x28,%eax
    3ca3:	89 de                	mov    %ebx,%esi
    3ca5:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3caf:	90                   	nop
  write(fd, &c, 1);
    3cb0:	83 ec 04             	sub    $0x4,%esp
          s++;
    3cb3:	83 c6 01             	add    $0x1,%esi
    3cb6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3cb9:	6a 01                	push   $0x1
    3cbb:	57                   	push   %edi
    3cbc:	53                   	push   %ebx
    3cbd:	e8 01 fd ff ff       	call   39c3 <write>
        while(*s != 0){
    3cc2:	0f b6 06             	movzbl (%esi),%eax
    3cc5:	83 c4 10             	add    $0x10,%esp
    3cc8:	84 c0                	test   %al,%al
    3cca:	75 e4                	jne    3cb0 <printf+0x1a0>
    3ccc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    3ccf:	31 d2                	xor    %edx,%edx
    3cd1:	e9 8e fe ff ff       	jmp    3b64 <printf+0x54>
    3cd6:	66 90                	xchg   %ax,%ax
    3cd8:	66 90                	xchg   %ax,%ax
    3cda:	66 90                	xchg   %ax,%ax
    3cdc:	66 90                	xchg   %ax,%ax
    3cde:	66 90                	xchg   %ax,%ax

00003ce0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3ce0:	f3 0f 1e fb          	endbr32 
    3ce4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ce5:	a1 c0 5f 00 00       	mov    0x5fc0,%eax
{
    3cea:	89 e5                	mov    %esp,%ebp
    3cec:	57                   	push   %edi
    3ced:	56                   	push   %esi
    3cee:	53                   	push   %ebx
    3cef:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3cf2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    3cf4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3cf7:	39 c8                	cmp    %ecx,%eax
    3cf9:	73 15                	jae    3d10 <free+0x30>
    3cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3cff:	90                   	nop
    3d00:	39 d1                	cmp    %edx,%ecx
    3d02:	72 14                	jb     3d18 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3d04:	39 d0                	cmp    %edx,%eax
    3d06:	73 10                	jae    3d18 <free+0x38>
{
    3d08:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3d0a:	8b 10                	mov    (%eax),%edx
    3d0c:	39 c8                	cmp    %ecx,%eax
    3d0e:	72 f0                	jb     3d00 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3d10:	39 d0                	cmp    %edx,%eax
    3d12:	72 f4                	jb     3d08 <free+0x28>
    3d14:	39 d1                	cmp    %edx,%ecx
    3d16:	73 f0                	jae    3d08 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3d18:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3d1b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3d1e:	39 fa                	cmp    %edi,%edx
    3d20:	74 1e                	je     3d40 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3d22:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3d25:	8b 50 04             	mov    0x4(%eax),%edx
    3d28:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3d2b:	39 f1                	cmp    %esi,%ecx
    3d2d:	74 28                	je     3d57 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3d2f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    3d31:	5b                   	pop    %ebx
  freep = p;
    3d32:	a3 c0 5f 00 00       	mov    %eax,0x5fc0
}
    3d37:	5e                   	pop    %esi
    3d38:	5f                   	pop    %edi
    3d39:	5d                   	pop    %ebp
    3d3a:	c3                   	ret    
    3d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3d3f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    3d40:	03 72 04             	add    0x4(%edx),%esi
    3d43:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3d46:	8b 10                	mov    (%eax),%edx
    3d48:	8b 12                	mov    (%edx),%edx
    3d4a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3d4d:	8b 50 04             	mov    0x4(%eax),%edx
    3d50:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3d53:	39 f1                	cmp    %esi,%ecx
    3d55:	75 d8                	jne    3d2f <free+0x4f>
    p->s.size += bp->s.size;
    3d57:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3d5a:	a3 c0 5f 00 00       	mov    %eax,0x5fc0
    p->s.size += bp->s.size;
    3d5f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3d62:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3d65:	89 10                	mov    %edx,(%eax)
}
    3d67:	5b                   	pop    %ebx
    3d68:	5e                   	pop    %esi
    3d69:	5f                   	pop    %edi
    3d6a:	5d                   	pop    %ebp
    3d6b:	c3                   	ret    
    3d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003d70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3d70:	f3 0f 1e fb          	endbr32 
    3d74:	55                   	push   %ebp
    3d75:	89 e5                	mov    %esp,%ebp
    3d77:	57                   	push   %edi
    3d78:	56                   	push   %esi
    3d79:	53                   	push   %ebx
    3d7a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3d80:	8b 3d c0 5f 00 00    	mov    0x5fc0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3d86:	8d 70 07             	lea    0x7(%eax),%esi
    3d89:	c1 ee 03             	shr    $0x3,%esi
    3d8c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    3d8f:	85 ff                	test   %edi,%edi
    3d91:	0f 84 a9 00 00 00    	je     3e40 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3d97:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    3d99:	8b 48 04             	mov    0x4(%eax),%ecx
    3d9c:	39 f1                	cmp    %esi,%ecx
    3d9e:	73 6d                	jae    3e0d <malloc+0x9d>
    3da0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    3da6:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3dab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    3dae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    3db5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    3db8:	eb 17                	jmp    3dd1 <malloc+0x61>
    3dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3dc0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    3dc2:	8b 4a 04             	mov    0x4(%edx),%ecx
    3dc5:	39 f1                	cmp    %esi,%ecx
    3dc7:	73 4f                	jae    3e18 <malloc+0xa8>
    3dc9:	8b 3d c0 5f 00 00    	mov    0x5fc0,%edi
    3dcf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3dd1:	39 c7                	cmp    %eax,%edi
    3dd3:	75 eb                	jne    3dc0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    3dd5:	83 ec 0c             	sub    $0xc,%esp
    3dd8:	ff 75 e4             	pushl  -0x1c(%ebp)
    3ddb:	e8 4b fc ff ff       	call   3a2b <sbrk>
  if(p == (char*)-1)
    3de0:	83 c4 10             	add    $0x10,%esp
    3de3:	83 f8 ff             	cmp    $0xffffffff,%eax
    3de6:	74 1b                	je     3e03 <malloc+0x93>
  hp->s.size = nu;
    3de8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3deb:	83 ec 0c             	sub    $0xc,%esp
    3dee:	83 c0 08             	add    $0x8,%eax
    3df1:	50                   	push   %eax
    3df2:	e8 e9 fe ff ff       	call   3ce0 <free>
  return freep;
    3df7:	a1 c0 5f 00 00       	mov    0x5fc0,%eax
      if((p = morecore(nunits)) == 0)
    3dfc:	83 c4 10             	add    $0x10,%esp
    3dff:	85 c0                	test   %eax,%eax
    3e01:	75 bd                	jne    3dc0 <malloc+0x50>
        return 0;
  }
}
    3e03:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3e06:	31 c0                	xor    %eax,%eax
}
    3e08:	5b                   	pop    %ebx
    3e09:	5e                   	pop    %esi
    3e0a:	5f                   	pop    %edi
    3e0b:	5d                   	pop    %ebp
    3e0c:	c3                   	ret    
    if(p->s.size >= nunits){
    3e0d:	89 c2                	mov    %eax,%edx
    3e0f:	89 f8                	mov    %edi,%eax
    3e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    3e18:	39 ce                	cmp    %ecx,%esi
    3e1a:	74 54                	je     3e70 <malloc+0x100>
        p->s.size -= nunits;
    3e1c:	29 f1                	sub    %esi,%ecx
    3e1e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    3e21:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    3e24:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    3e27:	a3 c0 5f 00 00       	mov    %eax,0x5fc0
}
    3e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3e2f:	8d 42 08             	lea    0x8(%edx),%eax
}
    3e32:	5b                   	pop    %ebx
    3e33:	5e                   	pop    %esi
    3e34:	5f                   	pop    %edi
    3e35:	5d                   	pop    %ebp
    3e36:	c3                   	ret    
    3e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3e3e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    3e40:	c7 05 c0 5f 00 00 c4 	movl   $0x5fc4,0x5fc0
    3e47:	5f 00 00 
    base.s.size = 0;
    3e4a:	bf c4 5f 00 00       	mov    $0x5fc4,%edi
    base.s.ptr = freep = prevp = &base;
    3e4f:	c7 05 c4 5f 00 00 c4 	movl   $0x5fc4,0x5fc4
    3e56:	5f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3e59:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    3e5b:	c7 05 c8 5f 00 00 00 	movl   $0x0,0x5fc8
    3e62:	00 00 00 
    if(p->s.size >= nunits){
    3e65:	e9 36 ff ff ff       	jmp    3da0 <malloc+0x30>
    3e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    3e70:	8b 0a                	mov    (%edx),%ecx
    3e72:	89 08                	mov    %ecx,(%eax)
    3e74:	eb b1                	jmp    3e27 <malloc+0xb7>
