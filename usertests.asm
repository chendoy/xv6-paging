
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
      15:	68 66 4e 00 00       	push   $0x4e66
      1a:	6a 01                	push   $0x1
      1c:	e8 df 3a 00 00       	call   3b00 <printf>

  if(open("usertests.ran", 0) >= 0){
      21:	59                   	pop    %ecx
      22:	58                   	pop    %eax
      23:	6a 00                	push   $0x0
      25:	68 7a 4e 00 00       	push   $0x4e7a
      2a:	e8 a4 39 00 00       	call   39d3 <open>
      2f:	83 c4 10             	add    $0x10,%esp
      32:	85 c0                	test   %eax,%eax
      34:	78 13                	js     49 <main+0x49>
    printf(1, "already ran user tests -- rebuild fs.img\n");
      36:	52                   	push   %edx
      37:	52                   	push   %edx
      38:	68 e4 55 00 00       	push   $0x55e4
      3d:	6a 01                	push   $0x1
      3f:	e8 bc 3a 00 00       	call   3b00 <printf>
    exit();
      44:	e8 4a 39 00 00       	call   3993 <exit>
  }
  close(open("usertests.ran", O_CREATE));
      49:	50                   	push   %eax
      4a:	50                   	push   %eax
      4b:	68 00 02 00 00       	push   $0x200
      50:	68 7a 4e 00 00       	push   $0x4e7a
      55:	e8 79 39 00 00       	call   39d3 <open>
      5a:	89 04 24             	mov    %eax,(%esp)
      5d:	e8 59 39 00 00       	call   39bb <close>

  argptest();
      62:	e8 39 36 00 00       	call   36a0 <argptest>
  createdelete();
      67:	e8 14 12 00 00       	call   1280 <createdelete>
  linkunlink();
      6c:	e8 ef 1a 00 00       	call   1b60 <linkunlink>
  concreate();
      71:	e8 ea 17 00 00       	call   1860 <concreate>
  // fourfiles();
  sharedfd();
      76:	e8 25 0e 00 00       	call   ea0 <sharedfd>

  bigargtest();
      7b:	e8 c0 32 00 00       	call   3340 <bigargtest>
  bigwrite();
      80:	e8 1b 24 00 00       	call   24a0 <bigwrite>
  bigargtest();
      85:	e8 b6 32 00 00       	call   3340 <bigargtest>
  bsstest();
      8a:	e8 41 32 00 00       	call   32d0 <bsstest>
  // sbrktest();
  validatetest();
      8f:	e8 7c 31 00 00       	call   3210 <validatetest>

  opentest();
      94:	e8 67 03 00 00       	call   400 <opentest>
  writetest();
      99:	e8 02 04 00 00       	call   4a0 <writetest>
  writetest1();
      9e:	e8 dd 05 00 00       	call   680 <writetest1>
  createtest();
      a3:	e8 a8 07 00 00       	call   850 <createtest>

  openiputtest();
      a8:	e8 53 02 00 00       	call   300 <openiputtest>
  exitiputtest();
      ad:	e8 4e 01 00 00       	call   200 <exitiputtest>
  iputtest();
      b2:	e8 59 00 00 00       	call   110 <iputtest>

  // mem();
  pipe1();
      b7:	e8 94 09 00 00       	call   a50 <pipe1>
  preempt();
      bc:	e8 2f 0b 00 00       	call   bf0 <preempt>
  exitwait();
      c1:	e8 8a 0c 00 00       	call   d50 <exitwait>

  rmdot();
      c6:	e8 c5 27 00 00       	call   2890 <rmdot>
  fourteen();
      cb:	e8 80 26 00 00       	call   2750 <fourteen>
  bigfile();
      d0:	e8 ab 24 00 00       	call   2580 <bigfile>
  subdir();
      d5:	e8 d6 1c 00 00       	call   1db0 <subdir>
  linktest();
      da:	e8 61 15 00 00       	call   1640 <linktest>
  unlinkread();
      df:	e8 cc 13 00 00       	call   14b0 <unlinkread>
  dirfile();
      e4:	e8 27 29 00 00       	call   2a10 <dirfile>
  iref();
      e9:	e8 22 2b 00 00       	call   2c10 <iref>
  forktest();
      ee:	e8 3d 2c 00 00       	call   2d30 <forktest>
  bigdir();
      f3:	e8 78 1b 00 00       	call   1c70 <bigdir>

  uio();
      f8:	e8 23 35 00 00       	call   3620 <uio>

  exectest();
      fd:	e8 fe 08 00 00       	call   a00 <exectest>

  exit();
     102:	e8 8c 38 00 00       	call   3993 <exit>
     107:	66 90                	xchg   %ax,%ax
     109:	66 90                	xchg   %ax,%ax
     10b:	66 90                	xchg   %ax,%ax
     10d:	66 90                	xchg   %ax,%ax
     10f:	90                   	nop

00000110 <iputtest>:
{
     110:	f3 0f 1e fb          	endbr32 
     114:	55                   	push   %ebp
     115:	89 e5                	mov    %esp,%ebp
     117:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
     11a:	68 fc 3e 00 00       	push   $0x3efc
     11f:	ff 35 10 5f 00 00    	pushl  0x5f10
     125:	e8 d6 39 00 00       	call   3b00 <printf>
  if(mkdir("iputdir") < 0){
     12a:	c7 04 24 8f 3e 00 00 	movl   $0x3e8f,(%esp)
     131:	e8 c5 38 00 00       	call   39fb <mkdir>
     136:	83 c4 10             	add    $0x10,%esp
     139:	85 c0                	test   %eax,%eax
     13b:	78 58                	js     195 <iputtest+0x85>
  if(chdir("iputdir") < 0){
     13d:	83 ec 0c             	sub    $0xc,%esp
     140:	68 8f 3e 00 00       	push   $0x3e8f
     145:	e8 b9 38 00 00       	call   3a03 <chdir>
     14a:	83 c4 10             	add    $0x10,%esp
     14d:	85 c0                	test   %eax,%eax
     14f:	0f 88 85 00 00 00    	js     1da <iputtest+0xca>
  if(unlink("../iputdir") < 0){
     155:	83 ec 0c             	sub    $0xc,%esp
     158:	68 8c 3e 00 00       	push   $0x3e8c
     15d:	e8 81 38 00 00       	call   39e3 <unlink>
     162:	83 c4 10             	add    $0x10,%esp
     165:	85 c0                	test   %eax,%eax
     167:	78 5a                	js     1c3 <iputtest+0xb3>
  if(chdir("/") < 0){
     169:	83 ec 0c             	sub    $0xc,%esp
     16c:	68 b1 3e 00 00       	push   $0x3eb1
     171:	e8 8d 38 00 00       	call   3a03 <chdir>
     176:	83 c4 10             	add    $0x10,%esp
     179:	85 c0                	test   %eax,%eax
     17b:	78 2f                	js     1ac <iputtest+0x9c>
  printf(stdout, "iput test ok\n");
     17d:	83 ec 08             	sub    $0x8,%esp
     180:	68 34 3f 00 00       	push   $0x3f34
     185:	ff 35 10 5f 00 00    	pushl  0x5f10
     18b:	e8 70 39 00 00       	call   3b00 <printf>
}
     190:	83 c4 10             	add    $0x10,%esp
     193:	c9                   	leave  
     194:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     195:	50                   	push   %eax
     196:	50                   	push   %eax
     197:	68 68 3e 00 00       	push   $0x3e68
     19c:	ff 35 10 5f 00 00    	pushl  0x5f10
     1a2:	e8 59 39 00 00       	call   3b00 <printf>
    exit();
     1a7:	e8 e7 37 00 00       	call   3993 <exit>
    printf(stdout, "chdir / failed\n");
     1ac:	50                   	push   %eax
     1ad:	50                   	push   %eax
     1ae:	68 b3 3e 00 00       	push   $0x3eb3
     1b3:	ff 35 10 5f 00 00    	pushl  0x5f10
     1b9:	e8 42 39 00 00       	call   3b00 <printf>
    exit();
     1be:	e8 d0 37 00 00       	call   3993 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
     1c3:	52                   	push   %edx
     1c4:	52                   	push   %edx
     1c5:	68 97 3e 00 00       	push   $0x3e97
     1ca:	ff 35 10 5f 00 00    	pushl  0x5f10
     1d0:	e8 2b 39 00 00       	call   3b00 <printf>
    exit();
     1d5:	e8 b9 37 00 00       	call   3993 <exit>
    printf(stdout, "chdir iputdir failed\n");
     1da:	51                   	push   %ecx
     1db:	51                   	push   %ecx
     1dc:	68 76 3e 00 00       	push   $0x3e76
     1e1:	ff 35 10 5f 00 00    	pushl  0x5f10
     1e7:	e8 14 39 00 00       	call   3b00 <printf>
    exit();
     1ec:	e8 a2 37 00 00       	call   3993 <exit>
     1f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1ff:	90                   	nop

00000200 <exitiputtest>:
{
     200:	f3 0f 1e fb          	endbr32 
     204:	55                   	push   %ebp
     205:	89 e5                	mov    %esp,%ebp
     207:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exitiput test\n");
     20a:	68 c3 3e 00 00       	push   $0x3ec3
     20f:	ff 35 10 5f 00 00    	pushl  0x5f10
     215:	e8 e6 38 00 00       	call   3b00 <printf>
  pid = fork();
     21a:	e8 6c 37 00 00       	call   398b <fork>
  if(pid < 0){
     21f:	83 c4 10             	add    $0x10,%esp
     222:	85 c0                	test   %eax,%eax
     224:	0f 88 86 00 00 00    	js     2b0 <exitiputtest+0xb0>
  if(pid == 0){
     22a:	75 4c                	jne    278 <exitiputtest+0x78>
    if(mkdir("iputdir") < 0){
     22c:	83 ec 0c             	sub    $0xc,%esp
     22f:	68 8f 3e 00 00       	push   $0x3e8f
     234:	e8 c2 37 00 00       	call   39fb <mkdir>
     239:	83 c4 10             	add    $0x10,%esp
     23c:	85 c0                	test   %eax,%eax
     23e:	0f 88 83 00 00 00    	js     2c7 <exitiputtest+0xc7>
    if(chdir("iputdir") < 0){
     244:	83 ec 0c             	sub    $0xc,%esp
     247:	68 8f 3e 00 00       	push   $0x3e8f
     24c:	e8 b2 37 00 00       	call   3a03 <chdir>
     251:	83 c4 10             	add    $0x10,%esp
     254:	85 c0                	test   %eax,%eax
     256:	0f 88 82 00 00 00    	js     2de <exitiputtest+0xde>
    if(unlink("../iputdir") < 0){
     25c:	83 ec 0c             	sub    $0xc,%esp
     25f:	68 8c 3e 00 00       	push   $0x3e8c
     264:	e8 7a 37 00 00       	call   39e3 <unlink>
     269:	83 c4 10             	add    $0x10,%esp
     26c:	85 c0                	test   %eax,%eax
     26e:	78 28                	js     298 <exitiputtest+0x98>
    exit();
     270:	e8 1e 37 00 00       	call   3993 <exit>
     275:	8d 76 00             	lea    0x0(%esi),%esi
  wait();
     278:	e8 1e 37 00 00       	call   399b <wait>
  printf(stdout, "exitiput test ok\n");
     27d:	83 ec 08             	sub    $0x8,%esp
     280:	68 e6 3e 00 00       	push   $0x3ee6
     285:	ff 35 10 5f 00 00    	pushl  0x5f10
     28b:	e8 70 38 00 00       	call   3b00 <printf>
}
     290:	83 c4 10             	add    $0x10,%esp
     293:	c9                   	leave  
     294:	c3                   	ret    
     295:	8d 76 00             	lea    0x0(%esi),%esi
      printf(stdout, "unlink ../iputdir failed\n");
     298:	83 ec 08             	sub    $0x8,%esp
     29b:	68 97 3e 00 00       	push   $0x3e97
     2a0:	ff 35 10 5f 00 00    	pushl  0x5f10
     2a6:	e8 55 38 00 00       	call   3b00 <printf>
      exit();
     2ab:	e8 e3 36 00 00       	call   3993 <exit>
    printf(stdout, "fork failed\n");
     2b0:	51                   	push   %ecx
     2b1:	51                   	push   %ecx
     2b2:	68 b9 4d 00 00       	push   $0x4db9
     2b7:	ff 35 10 5f 00 00    	pushl  0x5f10
     2bd:	e8 3e 38 00 00       	call   3b00 <printf>
    exit();
     2c2:	e8 cc 36 00 00       	call   3993 <exit>
      printf(stdout, "mkdir failed\n");
     2c7:	52                   	push   %edx
     2c8:	52                   	push   %edx
     2c9:	68 68 3e 00 00       	push   $0x3e68
     2ce:	ff 35 10 5f 00 00    	pushl  0x5f10
     2d4:	e8 27 38 00 00       	call   3b00 <printf>
      exit();
     2d9:	e8 b5 36 00 00       	call   3993 <exit>
      printf(stdout, "child chdir failed\n");
     2de:	50                   	push   %eax
     2df:	50                   	push   %eax
     2e0:	68 d2 3e 00 00       	push   $0x3ed2
     2e5:	ff 35 10 5f 00 00    	pushl  0x5f10
     2eb:	e8 10 38 00 00       	call   3b00 <printf>
      exit();
     2f0:	e8 9e 36 00 00       	call   3993 <exit>
     2f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <openiputtest>:
{
     300:	f3 0f 1e fb          	endbr32 
     304:	55                   	push   %ebp
     305:	89 e5                	mov    %esp,%ebp
     307:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "openiput test\n");
     30a:	68 f8 3e 00 00       	push   $0x3ef8
     30f:	ff 35 10 5f 00 00    	pushl  0x5f10
     315:	e8 e6 37 00 00       	call   3b00 <printf>
  if(mkdir("oidir") < 0){
     31a:	c7 04 24 07 3f 00 00 	movl   $0x3f07,(%esp)
     321:	e8 d5 36 00 00       	call   39fb <mkdir>
     326:	83 c4 10             	add    $0x10,%esp
     329:	85 c0                	test   %eax,%eax
     32b:	0f 88 9b 00 00 00    	js     3cc <openiputtest+0xcc>
  pid = fork();
     331:	e8 55 36 00 00       	call   398b <fork>
  if(pid < 0){
     336:	85 c0                	test   %eax,%eax
     338:	78 7b                	js     3b5 <openiputtest+0xb5>
  if(pid == 0){
     33a:	75 34                	jne    370 <openiputtest+0x70>
    int fd = open("oidir", O_RDWR);
     33c:	83 ec 08             	sub    $0x8,%esp
     33f:	6a 02                	push   $0x2
     341:	68 07 3f 00 00       	push   $0x3f07
     346:	e8 88 36 00 00       	call   39d3 <open>
    if(fd >= 0){
     34b:	83 c4 10             	add    $0x10,%esp
     34e:	85 c0                	test   %eax,%eax
     350:	78 5e                	js     3b0 <openiputtest+0xb0>
      printf(stdout, "open directory for write succeeded\n");
     352:	83 ec 08             	sub    $0x8,%esp
     355:	68 9c 4e 00 00       	push   $0x4e9c
     35a:	ff 35 10 5f 00 00    	pushl  0x5f10
     360:	e8 9b 37 00 00       	call   3b00 <printf>
      exit();
     365:	e8 29 36 00 00       	call   3993 <exit>
     36a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  sleep(1);
     370:	83 ec 0c             	sub    $0xc,%esp
     373:	6a 01                	push   $0x1
     375:	e8 a9 36 00 00       	call   3a23 <sleep>
  if(unlink("oidir") != 0){
     37a:	c7 04 24 07 3f 00 00 	movl   $0x3f07,(%esp)
     381:	e8 5d 36 00 00       	call   39e3 <unlink>
     386:	83 c4 10             	add    $0x10,%esp
     389:	85 c0                	test   %eax,%eax
     38b:	75 56                	jne    3e3 <openiputtest+0xe3>
  wait();
     38d:	e8 09 36 00 00       	call   399b <wait>
  printf(stdout, "openiput test ok\n");
     392:	83 ec 08             	sub    $0x8,%esp
     395:	68 30 3f 00 00       	push   $0x3f30
     39a:	ff 35 10 5f 00 00    	pushl  0x5f10
     3a0:	e8 5b 37 00 00       	call   3b00 <printf>
     3a5:	83 c4 10             	add    $0x10,%esp
}
     3a8:	c9                   	leave  
     3a9:	c3                   	ret    
     3aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
     3b0:	e8 de 35 00 00       	call   3993 <exit>
    printf(stdout, "fork failed\n");
     3b5:	52                   	push   %edx
     3b6:	52                   	push   %edx
     3b7:	68 b9 4d 00 00       	push   $0x4db9
     3bc:	ff 35 10 5f 00 00    	pushl  0x5f10
     3c2:	e8 39 37 00 00       	call   3b00 <printf>
    exit();
     3c7:	e8 c7 35 00 00       	call   3993 <exit>
    printf(stdout, "mkdir oidir failed\n");
     3cc:	51                   	push   %ecx
     3cd:	51                   	push   %ecx
     3ce:	68 0d 3f 00 00       	push   $0x3f0d
     3d3:	ff 35 10 5f 00 00    	pushl  0x5f10
     3d9:	e8 22 37 00 00       	call   3b00 <printf>
    exit();
     3de:	e8 b0 35 00 00       	call   3993 <exit>
    printf(stdout, "unlink failed\n");
     3e3:	50                   	push   %eax
     3e4:	50                   	push   %eax
     3e5:	68 21 3f 00 00       	push   $0x3f21
     3ea:	ff 35 10 5f 00 00    	pushl  0x5f10
     3f0:	e8 0b 37 00 00       	call   3b00 <printf>
    exit();
     3f5:	e8 99 35 00 00       	call   3993 <exit>
     3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <opentest>:
{
     400:	f3 0f 1e fb          	endbr32 
     404:	55                   	push   %ebp
     405:	89 e5                	mov    %esp,%ebp
     407:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "open test\n");
     40a:	68 42 3f 00 00       	push   $0x3f42
     40f:	ff 35 10 5f 00 00    	pushl  0x5f10
     415:	e8 e6 36 00 00       	call   3b00 <printf>
  fd = open("echo", 0);
     41a:	58                   	pop    %eax
     41b:	5a                   	pop    %edx
     41c:	6a 00                	push   $0x0
     41e:	68 4d 3f 00 00       	push   $0x3f4d
     423:	e8 ab 35 00 00       	call   39d3 <open>
  if(fd < 0){
     428:	83 c4 10             	add    $0x10,%esp
     42b:	85 c0                	test   %eax,%eax
     42d:	78 36                	js     465 <opentest+0x65>
  close(fd);
     42f:	83 ec 0c             	sub    $0xc,%esp
     432:	50                   	push   %eax
     433:	e8 83 35 00 00       	call   39bb <close>
  fd = open("doesnotexist", 0);
     438:	5a                   	pop    %edx
     439:	59                   	pop    %ecx
     43a:	6a 00                	push   $0x0
     43c:	68 65 3f 00 00       	push   $0x3f65
     441:	e8 8d 35 00 00       	call   39d3 <open>
  if(fd >= 0){
     446:	83 c4 10             	add    $0x10,%esp
     449:	85 c0                	test   %eax,%eax
     44b:	79 2f                	jns    47c <opentest+0x7c>
  printf(stdout, "open test ok\n");
     44d:	83 ec 08             	sub    $0x8,%esp
     450:	68 90 3f 00 00       	push   $0x3f90
     455:	ff 35 10 5f 00 00    	pushl  0x5f10
     45b:	e8 a0 36 00 00       	call   3b00 <printf>
}
     460:	83 c4 10             	add    $0x10,%esp
     463:	c9                   	leave  
     464:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     465:	50                   	push   %eax
     466:	50                   	push   %eax
     467:	68 52 3f 00 00       	push   $0x3f52
     46c:	ff 35 10 5f 00 00    	pushl  0x5f10
     472:	e8 89 36 00 00       	call   3b00 <printf>
    exit();
     477:	e8 17 35 00 00       	call   3993 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     47c:	50                   	push   %eax
     47d:	50                   	push   %eax
     47e:	68 72 3f 00 00       	push   $0x3f72
     483:	ff 35 10 5f 00 00    	pushl  0x5f10
     489:	e8 72 36 00 00       	call   3b00 <printf>
    exit();
     48e:	e8 00 35 00 00       	call   3993 <exit>
     493:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004a0 <writetest>:
{
     4a0:	f3 0f 1e fb          	endbr32 
     4a4:	55                   	push   %ebp
     4a5:	89 e5                	mov    %esp,%ebp
     4a7:	56                   	push   %esi
     4a8:	53                   	push   %ebx
  printf(stdout, "small file test\n");
     4a9:	83 ec 08             	sub    $0x8,%esp
     4ac:	68 9e 3f 00 00       	push   $0x3f9e
     4b1:	ff 35 10 5f 00 00    	pushl  0x5f10
     4b7:	e8 44 36 00 00       	call   3b00 <printf>
  fd = open("small", O_CREATE|O_RDWR);
     4bc:	58                   	pop    %eax
     4bd:	5a                   	pop    %edx
     4be:	68 02 02 00 00       	push   $0x202
     4c3:	68 af 3f 00 00       	push   $0x3faf
     4c8:	e8 06 35 00 00       	call   39d3 <open>
  if(fd >= 0){
     4cd:	83 c4 10             	add    $0x10,%esp
     4d0:	85 c0                	test   %eax,%eax
     4d2:	0f 88 8c 01 00 00    	js     664 <writetest+0x1c4>
    printf(stdout, "creat small succeeded; ok\n");
     4d8:	83 ec 08             	sub    $0x8,%esp
     4db:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 100; i++){
     4dd:	31 db                	xor    %ebx,%ebx
    printf(stdout, "creat small succeeded; ok\n");
     4df:	68 b5 3f 00 00       	push   $0x3fb5
     4e4:	ff 35 10 5f 00 00    	pushl  0x5f10
     4ea:	e8 11 36 00 00       	call   3b00 <printf>
     4ef:	83 c4 10             	add    $0x10,%esp
     4f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     4f8:	83 ec 04             	sub    $0x4,%esp
     4fb:	6a 0a                	push   $0xa
     4fd:	68 ec 3f 00 00       	push   $0x3fec
     502:	56                   	push   %esi
     503:	e8 ab 34 00 00       	call   39b3 <write>
     508:	83 c4 10             	add    $0x10,%esp
     50b:	83 f8 0a             	cmp    $0xa,%eax
     50e:	0f 85 d9 00 00 00    	jne    5ed <writetest+0x14d>
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     514:	83 ec 04             	sub    $0x4,%esp
     517:	6a 0a                	push   $0xa
     519:	68 f7 3f 00 00       	push   $0x3ff7
     51e:	56                   	push   %esi
     51f:	e8 8f 34 00 00       	call   39b3 <write>
     524:	83 c4 10             	add    $0x10,%esp
     527:	83 f8 0a             	cmp    $0xa,%eax
     52a:	0f 85 d6 00 00 00    	jne    606 <writetest+0x166>
  for(i = 0; i < 100; i++){
     530:	83 c3 01             	add    $0x1,%ebx
     533:	83 fb 64             	cmp    $0x64,%ebx
     536:	75 c0                	jne    4f8 <writetest+0x58>
  printf(stdout, "writes ok\n");
     538:	83 ec 08             	sub    $0x8,%esp
     53b:	68 02 40 00 00       	push   $0x4002
     540:	ff 35 10 5f 00 00    	pushl  0x5f10
     546:	e8 b5 35 00 00       	call   3b00 <printf>
  close(fd);
     54b:	89 34 24             	mov    %esi,(%esp)
     54e:	e8 68 34 00 00       	call   39bb <close>
  fd = open("small", O_RDONLY);
     553:	5b                   	pop    %ebx
     554:	5e                   	pop    %esi
     555:	6a 00                	push   $0x0
     557:	68 af 3f 00 00       	push   $0x3faf
     55c:	e8 72 34 00 00       	call   39d3 <open>
  if(fd >= 0){
     561:	83 c4 10             	add    $0x10,%esp
  fd = open("small", O_RDONLY);
     564:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     566:	85 c0                	test   %eax,%eax
     568:	0f 88 b1 00 00 00    	js     61f <writetest+0x17f>
    printf(stdout, "open small succeeded ok\n");
     56e:	83 ec 08             	sub    $0x8,%esp
     571:	68 0d 40 00 00       	push   $0x400d
     576:	ff 35 10 5f 00 00    	pushl  0x5f10
     57c:	e8 7f 35 00 00       	call   3b00 <printf>
  i = read(fd, buf, 2000);
     581:	83 c4 0c             	add    $0xc,%esp
     584:	68 d0 07 00 00       	push   $0x7d0
     589:	68 00 87 00 00       	push   $0x8700
     58e:	53                   	push   %ebx
     58f:	e8 17 34 00 00       	call   39ab <read>
  if(i == 2000){
     594:	83 c4 10             	add    $0x10,%esp
     597:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     59c:	0f 85 94 00 00 00    	jne    636 <writetest+0x196>
    printf(stdout, "read succeeded ok\n");
     5a2:	83 ec 08             	sub    $0x8,%esp
     5a5:	68 41 40 00 00       	push   $0x4041
     5aa:	ff 35 10 5f 00 00    	pushl  0x5f10
     5b0:	e8 4b 35 00 00       	call   3b00 <printf>
  close(fd);
     5b5:	89 1c 24             	mov    %ebx,(%esp)
     5b8:	e8 fe 33 00 00       	call   39bb <close>
  if(unlink("small") < 0){
     5bd:	c7 04 24 af 3f 00 00 	movl   $0x3faf,(%esp)
     5c4:	e8 1a 34 00 00       	call   39e3 <unlink>
     5c9:	83 c4 10             	add    $0x10,%esp
     5cc:	85 c0                	test   %eax,%eax
     5ce:	78 7d                	js     64d <writetest+0x1ad>
  printf(stdout, "small file test ok\n");
     5d0:	83 ec 08             	sub    $0x8,%esp
     5d3:	68 69 40 00 00       	push   $0x4069
     5d8:	ff 35 10 5f 00 00    	pushl  0x5f10
     5de:	e8 1d 35 00 00       	call   3b00 <printf>
}
     5e3:	83 c4 10             	add    $0x10,%esp
     5e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     5e9:	5b                   	pop    %ebx
     5ea:	5e                   	pop    %esi
     5eb:	5d                   	pop    %ebp
     5ec:	c3                   	ret    
      printf(stdout, "error: write aa %d new file failed\n", i);
     5ed:	83 ec 04             	sub    $0x4,%esp
     5f0:	53                   	push   %ebx
     5f1:	68 c0 4e 00 00       	push   $0x4ec0
     5f6:	ff 35 10 5f 00 00    	pushl  0x5f10
     5fc:	e8 ff 34 00 00       	call   3b00 <printf>
      exit();
     601:	e8 8d 33 00 00       	call   3993 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     606:	83 ec 04             	sub    $0x4,%esp
     609:	53                   	push   %ebx
     60a:	68 e4 4e 00 00       	push   $0x4ee4
     60f:	ff 35 10 5f 00 00    	pushl  0x5f10
     615:	e8 e6 34 00 00       	call   3b00 <printf>
      exit();
     61a:	e8 74 33 00 00       	call   3993 <exit>
    printf(stdout, "error: open small failed!\n");
     61f:	51                   	push   %ecx
     620:	51                   	push   %ecx
     621:	68 26 40 00 00       	push   $0x4026
     626:	ff 35 10 5f 00 00    	pushl  0x5f10
     62c:	e8 cf 34 00 00       	call   3b00 <printf>
    exit();
     631:	e8 5d 33 00 00       	call   3993 <exit>
    printf(stdout, "read failed\n");
     636:	52                   	push   %edx
     637:	52                   	push   %edx
     638:	68 7d 43 00 00       	push   $0x437d
     63d:	ff 35 10 5f 00 00    	pushl  0x5f10
     643:	e8 b8 34 00 00       	call   3b00 <printf>
    exit();
     648:	e8 46 33 00 00       	call   3993 <exit>
    printf(stdout, "unlink small failed\n");
     64d:	50                   	push   %eax
     64e:	50                   	push   %eax
     64f:	68 54 40 00 00       	push   $0x4054
     654:	ff 35 10 5f 00 00    	pushl  0x5f10
     65a:	e8 a1 34 00 00       	call   3b00 <printf>
    exit();
     65f:	e8 2f 33 00 00       	call   3993 <exit>
    printf(stdout, "error: creat small failed!\n");
     664:	50                   	push   %eax
     665:	50                   	push   %eax
     666:	68 d0 3f 00 00       	push   $0x3fd0
     66b:	ff 35 10 5f 00 00    	pushl  0x5f10
     671:	e8 8a 34 00 00       	call   3b00 <printf>
    exit();
     676:	e8 18 33 00 00       	call   3993 <exit>
     67b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     67f:	90                   	nop

00000680 <writetest1>:
{
     680:	f3 0f 1e fb          	endbr32 
     684:	55                   	push   %ebp
     685:	89 e5                	mov    %esp,%ebp
     687:	56                   	push   %esi
     688:	53                   	push   %ebx
  printf(stdout, "big files test\n");
     689:	83 ec 08             	sub    $0x8,%esp
     68c:	68 7d 40 00 00       	push   $0x407d
     691:	ff 35 10 5f 00 00    	pushl  0x5f10
     697:	e8 64 34 00 00       	call   3b00 <printf>
  fd = open("big", O_CREATE|O_RDWR);
     69c:	58                   	pop    %eax
     69d:	5a                   	pop    %edx
     69e:	68 02 02 00 00       	push   $0x202
     6a3:	68 f7 40 00 00       	push   $0x40f7
     6a8:	e8 26 33 00 00       	call   39d3 <open>
  if(fd < 0){
     6ad:	83 c4 10             	add    $0x10,%esp
     6b0:	85 c0                	test   %eax,%eax
     6b2:	0f 88 5d 01 00 00    	js     815 <writetest1+0x195>
     6b8:	89 c6                	mov    %eax,%esi
  for(i = 0; i < MAXFILE; i++){
     6ba:	31 db                	xor    %ebx,%ebx
     6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(write(fd, buf, 512) != 512){
     6c0:	83 ec 04             	sub    $0x4,%esp
    ((int*)buf)[0] = i;
     6c3:	89 1d 00 87 00 00    	mov    %ebx,0x8700
    if(write(fd, buf, 512) != 512){
     6c9:	68 00 02 00 00       	push   $0x200
     6ce:	68 00 87 00 00       	push   $0x8700
     6d3:	56                   	push   %esi
     6d4:	e8 da 32 00 00       	call   39b3 <write>
     6d9:	83 c4 10             	add    $0x10,%esp
     6dc:	3d 00 02 00 00       	cmp    $0x200,%eax
     6e1:	0f 85 b3 00 00 00    	jne    79a <writetest1+0x11a>
  for(i = 0; i < MAXFILE; i++){
     6e7:	83 c3 01             	add    $0x1,%ebx
     6ea:	81 fb 8c 00 00 00    	cmp    $0x8c,%ebx
     6f0:	75 ce                	jne    6c0 <writetest1+0x40>
  close(fd);
     6f2:	83 ec 0c             	sub    $0xc,%esp
     6f5:	56                   	push   %esi
     6f6:	e8 c0 32 00 00       	call   39bb <close>
  fd = open("big", O_RDONLY);
     6fb:	5b                   	pop    %ebx
     6fc:	5e                   	pop    %esi
     6fd:	6a 00                	push   $0x0
     6ff:	68 f7 40 00 00       	push   $0x40f7
     704:	e8 ca 32 00 00       	call   39d3 <open>
  if(fd < 0){
     709:	83 c4 10             	add    $0x10,%esp
  fd = open("big", O_RDONLY);
     70c:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
     70e:	85 c0                	test   %eax,%eax
     710:	0f 88 e8 00 00 00    	js     7fe <writetest1+0x17e>
  n = 0;
     716:	31 f6                	xor    %esi,%esi
     718:	eb 1d                	jmp    737 <writetest1+0xb7>
     71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(i != 512){
     720:	3d 00 02 00 00       	cmp    $0x200,%eax
     725:	0f 85 9f 00 00 00    	jne    7ca <writetest1+0x14a>
    if(((int*)buf)[0] != n){
     72b:	a1 00 87 00 00       	mov    0x8700,%eax
     730:	39 f0                	cmp    %esi,%eax
     732:	75 7f                	jne    7b3 <writetest1+0x133>
    n++;
     734:	83 c6 01             	add    $0x1,%esi
    i = read(fd, buf, 512);
     737:	83 ec 04             	sub    $0x4,%esp
     73a:	68 00 02 00 00       	push   $0x200
     73f:	68 00 87 00 00       	push   $0x8700
     744:	53                   	push   %ebx
     745:	e8 61 32 00 00       	call   39ab <read>
    if(i == 0){
     74a:	83 c4 10             	add    $0x10,%esp
     74d:	85 c0                	test   %eax,%eax
     74f:	75 cf                	jne    720 <writetest1+0xa0>
      if(n == MAXFILE - 1){
     751:	81 fe 8b 00 00 00    	cmp    $0x8b,%esi
     757:	0f 84 86 00 00 00    	je     7e3 <writetest1+0x163>
  close(fd);
     75d:	83 ec 0c             	sub    $0xc,%esp
     760:	53                   	push   %ebx
     761:	e8 55 32 00 00       	call   39bb <close>
  if(unlink("big") < 0){
     766:	c7 04 24 f7 40 00 00 	movl   $0x40f7,(%esp)
     76d:	e8 71 32 00 00       	call   39e3 <unlink>
     772:	83 c4 10             	add    $0x10,%esp
     775:	85 c0                	test   %eax,%eax
     777:	0f 88 af 00 00 00    	js     82c <writetest1+0x1ac>
  printf(stdout, "big files ok\n");
     77d:	83 ec 08             	sub    $0x8,%esp
     780:	68 1e 41 00 00       	push   $0x411e
     785:	ff 35 10 5f 00 00    	pushl  0x5f10
     78b:	e8 70 33 00 00       	call   3b00 <printf>
}
     790:	83 c4 10             	add    $0x10,%esp
     793:	8d 65 f8             	lea    -0x8(%ebp),%esp
     796:	5b                   	pop    %ebx
     797:	5e                   	pop    %esi
     798:	5d                   	pop    %ebp
     799:	c3                   	ret    
      printf(stdout, "error: write big file failed\n", i);
     79a:	83 ec 04             	sub    $0x4,%esp
     79d:	53                   	push   %ebx
     79e:	68 a7 40 00 00       	push   $0x40a7
     7a3:	ff 35 10 5f 00 00    	pushl  0x5f10
     7a9:	e8 52 33 00 00       	call   3b00 <printf>
      exit();
     7ae:	e8 e0 31 00 00       	call   3993 <exit>
      printf(stdout, "read content of block %d is %d\n",
     7b3:	50                   	push   %eax
     7b4:	56                   	push   %esi
     7b5:	68 08 4f 00 00       	push   $0x4f08
     7ba:	ff 35 10 5f 00 00    	pushl  0x5f10
     7c0:	e8 3b 33 00 00       	call   3b00 <printf>
      exit();
     7c5:	e8 c9 31 00 00       	call   3993 <exit>
      printf(stdout, "read failed %d\n", i);
     7ca:	83 ec 04             	sub    $0x4,%esp
     7cd:	50                   	push   %eax
     7ce:	68 fb 40 00 00       	push   $0x40fb
     7d3:	ff 35 10 5f 00 00    	pushl  0x5f10
     7d9:	e8 22 33 00 00       	call   3b00 <printf>
      exit();
     7de:	e8 b0 31 00 00       	call   3993 <exit>
        printf(stdout, "read only %d blocks from big", n);
     7e3:	52                   	push   %edx
     7e4:	68 8b 00 00 00       	push   $0x8b
     7e9:	68 de 40 00 00       	push   $0x40de
     7ee:	ff 35 10 5f 00 00    	pushl  0x5f10
     7f4:	e8 07 33 00 00       	call   3b00 <printf>
        exit();
     7f9:	e8 95 31 00 00       	call   3993 <exit>
    printf(stdout, "error: open big failed!\n");
     7fe:	51                   	push   %ecx
     7ff:	51                   	push   %ecx
     800:	68 c5 40 00 00       	push   $0x40c5
     805:	ff 35 10 5f 00 00    	pushl  0x5f10
     80b:	e8 f0 32 00 00       	call   3b00 <printf>
    exit();
     810:	e8 7e 31 00 00       	call   3993 <exit>
    printf(stdout, "error: creat big failed!\n");
     815:	50                   	push   %eax
     816:	50                   	push   %eax
     817:	68 8d 40 00 00       	push   $0x408d
     81c:	ff 35 10 5f 00 00    	pushl  0x5f10
     822:	e8 d9 32 00 00       	call   3b00 <printf>
    exit();
     827:	e8 67 31 00 00       	call   3993 <exit>
    printf(stdout, "unlink big failed\n");
     82c:	50                   	push   %eax
     82d:	50                   	push   %eax
     82e:	68 0b 41 00 00       	push   $0x410b
     833:	ff 35 10 5f 00 00    	pushl  0x5f10
     839:	e8 c2 32 00 00       	call   3b00 <printf>
    exit();
     83e:	e8 50 31 00 00       	call   3993 <exit>
     843:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000850 <createtest>:
{
     850:	f3 0f 1e fb          	endbr32 
     854:	55                   	push   %ebp
     855:	89 e5                	mov    %esp,%ebp
     857:	53                   	push   %ebx
  name[2] = '\0';
     858:	bb 30 00 00 00       	mov    $0x30,%ebx
{
     85d:	83 ec 0c             	sub    $0xc,%esp
  printf(stdout, "many creates, followed by unlink test\n");
     860:	68 28 4f 00 00       	push   $0x4f28
     865:	ff 35 10 5f 00 00    	pushl  0x5f10
     86b:	e8 90 32 00 00       	call   3b00 <printf>
  name[0] = 'a';
     870:	c6 05 00 a7 00 00 61 	movb   $0x61,0xa700
  name[2] = '\0';
     877:	83 c4 10             	add    $0x10,%esp
     87a:	c6 05 02 a7 00 00 00 	movb   $0x0,0xa702
  for(i = 0; i < 52; i++){
     881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    fd = open(name, O_CREATE|O_RDWR);
     888:	83 ec 08             	sub    $0x8,%esp
    name[1] = '0' + i;
     88b:	88 1d 01 a7 00 00    	mov    %bl,0xa701
    fd = open(name, O_CREATE|O_RDWR);
     891:	83 c3 01             	add    $0x1,%ebx
     894:	68 02 02 00 00       	push   $0x202
     899:	68 00 a7 00 00       	push   $0xa700
     89e:	e8 30 31 00 00       	call   39d3 <open>
    close(fd);
     8a3:	89 04 24             	mov    %eax,(%esp)
     8a6:	e8 10 31 00 00       	call   39bb <close>
  for(i = 0; i < 52; i++){
     8ab:	83 c4 10             	add    $0x10,%esp
     8ae:	80 fb 64             	cmp    $0x64,%bl
     8b1:	75 d5                	jne    888 <createtest+0x38>
  name[0] = 'a';
     8b3:	c6 05 00 a7 00 00 61 	movb   $0x61,0xa700
  name[2] = '\0';
     8ba:	bb 30 00 00 00       	mov    $0x30,%ebx
     8bf:	c6 05 02 a7 00 00 00 	movb   $0x0,0xa702
  for(i = 0; i < 52; i++){
     8c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     8cd:	8d 76 00             	lea    0x0(%esi),%esi
    unlink(name);
     8d0:	83 ec 0c             	sub    $0xc,%esp
    name[1] = '0' + i;
     8d3:	88 1d 01 a7 00 00    	mov    %bl,0xa701
    unlink(name);
     8d9:	83 c3 01             	add    $0x1,%ebx
     8dc:	68 00 a7 00 00       	push   $0xa700
     8e1:	e8 fd 30 00 00       	call   39e3 <unlink>
  for(i = 0; i < 52; i++){
     8e6:	83 c4 10             	add    $0x10,%esp
     8e9:	80 fb 64             	cmp    $0x64,%bl
     8ec:	75 e2                	jne    8d0 <createtest+0x80>
  printf(stdout, "many creates, followed by unlink; ok\n");
     8ee:	83 ec 08             	sub    $0x8,%esp
     8f1:	68 50 4f 00 00       	push   $0x4f50
     8f6:	ff 35 10 5f 00 00    	pushl  0x5f10
     8fc:	e8 ff 31 00 00       	call   3b00 <printf>
}
     901:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     904:	83 c4 10             	add    $0x10,%esp
     907:	c9                   	leave  
     908:	c3                   	ret    
     909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000910 <dirtest>:
{
     910:	f3 0f 1e fb          	endbr32 
     914:	55                   	push   %ebp
     915:	89 e5                	mov    %esp,%ebp
     917:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     91a:	68 2c 41 00 00       	push   $0x412c
     91f:	ff 35 10 5f 00 00    	pushl  0x5f10
     925:	e8 d6 31 00 00       	call   3b00 <printf>
  if(mkdir("dir0") < 0){
     92a:	c7 04 24 38 41 00 00 	movl   $0x4138,(%esp)
     931:	e8 c5 30 00 00       	call   39fb <mkdir>
     936:	83 c4 10             	add    $0x10,%esp
     939:	85 c0                	test   %eax,%eax
     93b:	78 58                	js     995 <dirtest+0x85>
  if(chdir("dir0") < 0){
     93d:	83 ec 0c             	sub    $0xc,%esp
     940:	68 38 41 00 00       	push   $0x4138
     945:	e8 b9 30 00 00       	call   3a03 <chdir>
     94a:	83 c4 10             	add    $0x10,%esp
     94d:	85 c0                	test   %eax,%eax
     94f:	0f 88 85 00 00 00    	js     9da <dirtest+0xca>
  if(chdir("..") < 0){
     955:	83 ec 0c             	sub    $0xc,%esp
     958:	68 ed 46 00 00       	push   $0x46ed
     95d:	e8 a1 30 00 00       	call   3a03 <chdir>
     962:	83 c4 10             	add    $0x10,%esp
     965:	85 c0                	test   %eax,%eax
     967:	78 5a                	js     9c3 <dirtest+0xb3>
  if(unlink("dir0") < 0){
     969:	83 ec 0c             	sub    $0xc,%esp
     96c:	68 38 41 00 00       	push   $0x4138
     971:	e8 6d 30 00 00       	call   39e3 <unlink>
     976:	83 c4 10             	add    $0x10,%esp
     979:	85 c0                	test   %eax,%eax
     97b:	78 2f                	js     9ac <dirtest+0x9c>
  printf(stdout, "mkdir test ok\n");
     97d:	83 ec 08             	sub    $0x8,%esp
     980:	68 75 41 00 00       	push   $0x4175
     985:	ff 35 10 5f 00 00    	pushl  0x5f10
     98b:	e8 70 31 00 00       	call   3b00 <printf>
}
     990:	83 c4 10             	add    $0x10,%esp
     993:	c9                   	leave  
     994:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     995:	50                   	push   %eax
     996:	50                   	push   %eax
     997:	68 68 3e 00 00       	push   $0x3e68
     99c:	ff 35 10 5f 00 00    	pushl  0x5f10
     9a2:	e8 59 31 00 00       	call   3b00 <printf>
    exit();
     9a7:	e8 e7 2f 00 00       	call   3993 <exit>
    printf(stdout, "unlink dir0 failed\n");
     9ac:	50                   	push   %eax
     9ad:	50                   	push   %eax
     9ae:	68 61 41 00 00       	push   $0x4161
     9b3:	ff 35 10 5f 00 00    	pushl  0x5f10
     9b9:	e8 42 31 00 00       	call   3b00 <printf>
    exit();
     9be:	e8 d0 2f 00 00       	call   3993 <exit>
    printf(stdout, "chdir .. failed\n");
     9c3:	52                   	push   %edx
     9c4:	52                   	push   %edx
     9c5:	68 50 41 00 00       	push   $0x4150
     9ca:	ff 35 10 5f 00 00    	pushl  0x5f10
     9d0:	e8 2b 31 00 00       	call   3b00 <printf>
    exit();
     9d5:	e8 b9 2f 00 00       	call   3993 <exit>
    printf(stdout, "chdir dir0 failed\n");
     9da:	51                   	push   %ecx
     9db:	51                   	push   %ecx
     9dc:	68 3d 41 00 00       	push   $0x413d
     9e1:	ff 35 10 5f 00 00    	pushl  0x5f10
     9e7:	e8 14 31 00 00       	call   3b00 <printf>
    exit();
     9ec:	e8 a2 2f 00 00       	call   3993 <exit>
     9f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9ff:	90                   	nop

00000a00 <exectest>:
{
     a00:	f3 0f 1e fb          	endbr32 
     a04:	55                   	push   %ebp
     a05:	89 e5                	mov    %esp,%ebp
     a07:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     a0a:	68 84 41 00 00       	push   $0x4184
     a0f:	ff 35 10 5f 00 00    	pushl  0x5f10
     a15:	e8 e6 30 00 00       	call   3b00 <printf>
  if(exec("echo", echoargv) < 0){
     a1a:	5a                   	pop    %edx
     a1b:	59                   	pop    %ecx
     a1c:	68 14 5f 00 00       	push   $0x5f14
     a21:	68 4d 3f 00 00       	push   $0x3f4d
     a26:	e8 a0 2f 00 00       	call   39cb <exec>
     a2b:	83 c4 10             	add    $0x10,%esp
     a2e:	85 c0                	test   %eax,%eax
     a30:	78 02                	js     a34 <exectest+0x34>
}
     a32:	c9                   	leave  
     a33:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     a34:	50                   	push   %eax
     a35:	50                   	push   %eax
     a36:	68 8f 41 00 00       	push   $0x418f
     a3b:	ff 35 10 5f 00 00    	pushl  0x5f10
     a41:	e8 ba 30 00 00       	call   3b00 <printf>
    exit();
     a46:	e8 48 2f 00 00       	call   3993 <exit>
     a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     a4f:	90                   	nop

00000a50 <pipe1>:
{
     a50:	f3 0f 1e fb          	endbr32 
     a54:	55                   	push   %ebp
     a55:	89 e5                	mov    %esp,%ebp
     a57:	57                   	push   %edi
     a58:	56                   	push   %esi
  if(pipe(fds) != 0){
     a59:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
     a5c:	53                   	push   %ebx
     a5d:	83 ec 38             	sub    $0x38,%esp
  if(pipe(fds) != 0){
     a60:	50                   	push   %eax
     a61:	e8 3d 2f 00 00       	call   39a3 <pipe>
     a66:	83 c4 10             	add    $0x10,%esp
     a69:	85 c0                	test   %eax,%eax
     a6b:	0f 85 38 01 00 00    	jne    ba9 <pipe1+0x159>
  pid = fork();
     a71:	e8 15 2f 00 00       	call   398b <fork>
  if(pid == 0){
     a76:	85 c0                	test   %eax,%eax
     a78:	0f 84 8d 00 00 00    	je     b0b <pipe1+0xbb>
  } else if(pid > 0){
     a7e:	0f 8e 38 01 00 00    	jle    bbc <pipe1+0x16c>
    close(fds[1]);
     a84:	83 ec 0c             	sub    $0xc,%esp
     a87:	ff 75 e4             	pushl  -0x1c(%ebp)
  seq = 0;
     a8a:	31 db                	xor    %ebx,%ebx
    cc = 1;
     a8c:	be 01 00 00 00       	mov    $0x1,%esi
    close(fds[1]);
     a91:	e8 25 2f 00 00       	call   39bb <close>
    total = 0;
     a96:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     a9d:	83 c4 10             	add    $0x10,%esp
     aa0:	83 ec 04             	sub    $0x4,%esp
     aa3:	56                   	push   %esi
     aa4:	68 00 87 00 00       	push   $0x8700
     aa9:	ff 75 e0             	pushl  -0x20(%ebp)
     aac:	e8 fa 2e 00 00       	call   39ab <read>
     ab1:	83 c4 10             	add    $0x10,%esp
     ab4:	89 c7                	mov    %eax,%edi
     ab6:	85 c0                	test   %eax,%eax
     ab8:	0f 8e a7 00 00 00    	jle    b65 <pipe1+0x115>
     abe:	8d 0c 3b             	lea    (%ebx,%edi,1),%ecx
      for(i = 0; i < n; i++){
     ac1:	31 c0                	xor    %eax,%eax
     ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ac7:	90                   	nop
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     ac8:	89 da                	mov    %ebx,%edx
     aca:	83 c3 01             	add    $0x1,%ebx
     acd:	38 90 00 87 00 00    	cmp    %dl,0x8700(%eax)
     ad3:	75 1c                	jne    af1 <pipe1+0xa1>
      for(i = 0; i < n; i++){
     ad5:	83 c0 01             	add    $0x1,%eax
     ad8:	39 d9                	cmp    %ebx,%ecx
     ada:	75 ec                	jne    ac8 <pipe1+0x78>
      cc = cc * 2;
     adc:	01 f6                	add    %esi,%esi
      total += n;
     ade:	01 7d d4             	add    %edi,-0x2c(%ebp)
     ae1:	b8 00 20 00 00       	mov    $0x2000,%eax
     ae6:	81 fe 00 20 00 00    	cmp    $0x2000,%esi
     aec:	0f 4f f0             	cmovg  %eax,%esi
     aef:	eb af                	jmp    aa0 <pipe1+0x50>
          printf(1, "pipe1 oops 2\n");
     af1:	83 ec 08             	sub    $0x8,%esp
     af4:	68 be 41 00 00       	push   $0x41be
     af9:	6a 01                	push   $0x1
     afb:	e8 00 30 00 00       	call   3b00 <printf>
          return;
     b00:	83 c4 10             	add    $0x10,%esp
}
     b03:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b06:	5b                   	pop    %ebx
     b07:	5e                   	pop    %esi
     b08:	5f                   	pop    %edi
     b09:	5d                   	pop    %ebp
     b0a:	c3                   	ret    
    close(fds[0]);
     b0b:	83 ec 0c             	sub    $0xc,%esp
     b0e:	ff 75 e0             	pushl  -0x20(%ebp)
  seq = 0;
     b11:	31 db                	xor    %ebx,%ebx
    close(fds[0]);
     b13:	e8 a3 2e 00 00       	call   39bb <close>
     b18:	83 c4 10             	add    $0x10,%esp
      for(i = 0; i < 1033; i++)
     b1b:	31 c0                	xor    %eax,%eax
     b1d:	8d 76 00             	lea    0x0(%esi),%esi
        buf[i] = seq++;
     b20:	8d 14 18             	lea    (%eax,%ebx,1),%edx
      for(i = 0; i < 1033; i++)
     b23:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     b26:	88 90 ff 86 00 00    	mov    %dl,0x86ff(%eax)
      for(i = 0; i < 1033; i++)
     b2c:	3d 09 04 00 00       	cmp    $0x409,%eax
     b31:	75 ed                	jne    b20 <pipe1+0xd0>
      if(write(fds[1], buf, 1033) != 1033){
     b33:	83 ec 04             	sub    $0x4,%esp
     b36:	81 c3 09 04 00 00    	add    $0x409,%ebx
     b3c:	68 09 04 00 00       	push   $0x409
     b41:	68 00 87 00 00       	push   $0x8700
     b46:	ff 75 e4             	pushl  -0x1c(%ebp)
     b49:	e8 65 2e 00 00       	call   39b3 <write>
     b4e:	83 c4 10             	add    $0x10,%esp
     b51:	3d 09 04 00 00       	cmp    $0x409,%eax
     b56:	75 77                	jne    bcf <pipe1+0x17f>
    for(n = 0; n < 5; n++){
     b58:	81 fb 2d 14 00 00    	cmp    $0x142d,%ebx
     b5e:	75 bb                	jne    b1b <pipe1+0xcb>
    exit();
     b60:	e8 2e 2e 00 00       	call   3993 <exit>
    if(total != 5 * 1033){
     b65:	81 7d d4 2d 14 00 00 	cmpl   $0x142d,-0x2c(%ebp)
     b6c:	75 26                	jne    b94 <pipe1+0x144>
    close(fds[0]);
     b6e:	83 ec 0c             	sub    $0xc,%esp
     b71:	ff 75 e0             	pushl  -0x20(%ebp)
     b74:	e8 42 2e 00 00       	call   39bb <close>
    wait();
     b79:	e8 1d 2e 00 00       	call   399b <wait>
  printf(1, "pipe1 ok\n");
     b7e:	5a                   	pop    %edx
     b7f:	59                   	pop    %ecx
     b80:	68 e3 41 00 00       	push   $0x41e3
     b85:	6a 01                	push   $0x1
     b87:	e8 74 2f 00 00       	call   3b00 <printf>
     b8c:	83 c4 10             	add    $0x10,%esp
     b8f:	e9 6f ff ff ff       	jmp    b03 <pipe1+0xb3>
      printf(1, "pipe1 oops 3 total %d\n", total);
     b94:	53                   	push   %ebx
     b95:	ff 75 d4             	pushl  -0x2c(%ebp)
     b98:	68 cc 41 00 00       	push   $0x41cc
     b9d:	6a 01                	push   $0x1
     b9f:	e8 5c 2f 00 00       	call   3b00 <printf>
      exit();
     ba4:	e8 ea 2d 00 00       	call   3993 <exit>
    printf(1, "pipe() failed\n");
     ba9:	57                   	push   %edi
     baa:	57                   	push   %edi
     bab:	68 a1 41 00 00       	push   $0x41a1
     bb0:	6a 01                	push   $0x1
     bb2:	e8 49 2f 00 00       	call   3b00 <printf>
    exit();
     bb7:	e8 d7 2d 00 00       	call   3993 <exit>
    printf(1, "fork() failed\n");
     bbc:	50                   	push   %eax
     bbd:	50                   	push   %eax
     bbe:	68 ed 41 00 00       	push   $0x41ed
     bc3:	6a 01                	push   $0x1
     bc5:	e8 36 2f 00 00       	call   3b00 <printf>
    exit();
     bca:	e8 c4 2d 00 00       	call   3993 <exit>
        printf(1, "pipe1 oops 1\n");
     bcf:	56                   	push   %esi
     bd0:	56                   	push   %esi
     bd1:	68 b0 41 00 00       	push   $0x41b0
     bd6:	6a 01                	push   $0x1
     bd8:	e8 23 2f 00 00       	call   3b00 <printf>
        exit();
     bdd:	e8 b1 2d 00 00       	call   3993 <exit>
     be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000bf0 <preempt>:
{
     bf0:	f3 0f 1e fb          	endbr32 
     bf4:	55                   	push   %ebp
     bf5:	89 e5                	mov    %esp,%ebp
     bf7:	57                   	push   %edi
     bf8:	56                   	push   %esi
     bf9:	53                   	push   %ebx
     bfa:	83 ec 24             	sub    $0x24,%esp
  printf(1, "preempt: ");
     bfd:	68 fc 41 00 00       	push   $0x41fc
     c02:	6a 01                	push   $0x1
     c04:	e8 f7 2e 00 00       	call   3b00 <printf>
  pid1 = fork();
     c09:	e8 7d 2d 00 00       	call   398b <fork>
  if(pid1 == 0)
     c0e:	83 c4 10             	add    $0x10,%esp
     c11:	85 c0                	test   %eax,%eax
     c13:	75 0b                	jne    c20 <preempt+0x30>
    for(;;)
     c15:	eb fe                	jmp    c15 <preempt+0x25>
     c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c1e:	66 90                	xchg   %ax,%ax
     c20:	89 c7                	mov    %eax,%edi
  pid2 = fork();
     c22:	e8 64 2d 00 00       	call   398b <fork>
     c27:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     c29:	85 c0                	test   %eax,%eax
     c2b:	75 03                	jne    c30 <preempt+0x40>
    for(;;)
     c2d:	eb fe                	jmp    c2d <preempt+0x3d>
     c2f:	90                   	nop
  pipe(pfds);
     c30:	83 ec 0c             	sub    $0xc,%esp
     c33:	8d 45 e0             	lea    -0x20(%ebp),%eax
     c36:	50                   	push   %eax
     c37:	e8 67 2d 00 00       	call   39a3 <pipe>
  pid3 = fork();
     c3c:	e8 4a 2d 00 00       	call   398b <fork>
  if(pid3 == 0){
     c41:	83 c4 10             	add    $0x10,%esp
  pid3 = fork();
     c44:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     c46:	85 c0                	test   %eax,%eax
     c48:	75 3e                	jne    c88 <preempt+0x98>
    close(pfds[0]);
     c4a:	83 ec 0c             	sub    $0xc,%esp
     c4d:	ff 75 e0             	pushl  -0x20(%ebp)
     c50:	e8 66 2d 00 00       	call   39bb <close>
    if(write(pfds[1], "x", 1) != 1)
     c55:	83 c4 0c             	add    $0xc,%esp
     c58:	6a 01                	push   $0x1
     c5a:	68 d1 47 00 00       	push   $0x47d1
     c5f:	ff 75 e4             	pushl  -0x1c(%ebp)
     c62:	e8 4c 2d 00 00       	call   39b3 <write>
     c67:	83 c4 10             	add    $0x10,%esp
     c6a:	83 f8 01             	cmp    $0x1,%eax
     c6d:	0f 85 a4 00 00 00    	jne    d17 <preempt+0x127>
    close(pfds[1]);
     c73:	83 ec 0c             	sub    $0xc,%esp
     c76:	ff 75 e4             	pushl  -0x1c(%ebp)
     c79:	e8 3d 2d 00 00       	call   39bb <close>
     c7e:	83 c4 10             	add    $0x10,%esp
    for(;;)
     c81:	eb fe                	jmp    c81 <preempt+0x91>
     c83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c87:	90                   	nop
  close(pfds[1]);
     c88:	83 ec 0c             	sub    $0xc,%esp
     c8b:	ff 75 e4             	pushl  -0x1c(%ebp)
     c8e:	e8 28 2d 00 00       	call   39bb <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     c93:	83 c4 0c             	add    $0xc,%esp
     c96:	68 00 20 00 00       	push   $0x2000
     c9b:	68 00 87 00 00       	push   $0x8700
     ca0:	ff 75 e0             	pushl  -0x20(%ebp)
     ca3:	e8 03 2d 00 00       	call   39ab <read>
     ca8:	83 c4 10             	add    $0x10,%esp
     cab:	83 f8 01             	cmp    $0x1,%eax
     cae:	75 7e                	jne    d2e <preempt+0x13e>
  close(pfds[0]);
     cb0:	83 ec 0c             	sub    $0xc,%esp
     cb3:	ff 75 e0             	pushl  -0x20(%ebp)
     cb6:	e8 00 2d 00 00       	call   39bb <close>
  printf(1, "kill... ");
     cbb:	58                   	pop    %eax
     cbc:	5a                   	pop    %edx
     cbd:	68 2d 42 00 00       	push   $0x422d
     cc2:	6a 01                	push   $0x1
     cc4:	e8 37 2e 00 00       	call   3b00 <printf>
  kill(pid1);
     cc9:	89 3c 24             	mov    %edi,(%esp)
     ccc:	e8 f2 2c 00 00       	call   39c3 <kill>
  kill(pid2);
     cd1:	89 34 24             	mov    %esi,(%esp)
     cd4:	e8 ea 2c 00 00       	call   39c3 <kill>
  kill(pid3);
     cd9:	89 1c 24             	mov    %ebx,(%esp)
     cdc:	e8 e2 2c 00 00       	call   39c3 <kill>
  printf(1, "wait... ");
     ce1:	59                   	pop    %ecx
     ce2:	5b                   	pop    %ebx
     ce3:	68 36 42 00 00       	push   $0x4236
     ce8:	6a 01                	push   $0x1
     cea:	e8 11 2e 00 00       	call   3b00 <printf>
  wait();
     cef:	e8 a7 2c 00 00       	call   399b <wait>
  wait();
     cf4:	e8 a2 2c 00 00       	call   399b <wait>
  wait();
     cf9:	e8 9d 2c 00 00       	call   399b <wait>
  printf(1, "preempt ok\n");
     cfe:	5e                   	pop    %esi
     cff:	5f                   	pop    %edi
     d00:	68 3f 42 00 00       	push   $0x423f
     d05:	6a 01                	push   $0x1
     d07:	e8 f4 2d 00 00       	call   3b00 <printf>
     d0c:	83 c4 10             	add    $0x10,%esp
}
     d0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d12:	5b                   	pop    %ebx
     d13:	5e                   	pop    %esi
     d14:	5f                   	pop    %edi
     d15:	5d                   	pop    %ebp
     d16:	c3                   	ret    
      printf(1, "preempt write error");
     d17:	83 ec 08             	sub    $0x8,%esp
     d1a:	68 06 42 00 00       	push   $0x4206
     d1f:	6a 01                	push   $0x1
     d21:	e8 da 2d 00 00       	call   3b00 <printf>
     d26:	83 c4 10             	add    $0x10,%esp
     d29:	e9 45 ff ff ff       	jmp    c73 <preempt+0x83>
    printf(1, "preempt read error");
     d2e:	83 ec 08             	sub    $0x8,%esp
     d31:	68 1a 42 00 00       	push   $0x421a
     d36:	6a 01                	push   $0x1
     d38:	e8 c3 2d 00 00       	call   3b00 <printf>
    return;
     d3d:	83 c4 10             	add    $0x10,%esp
     d40:	eb cd                	jmp    d0f <preempt+0x11f>
     d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000d50 <exitwait>:
{
     d50:	f3 0f 1e fb          	endbr32 
     d54:	55                   	push   %ebp
     d55:	89 e5                	mov    %esp,%ebp
     d57:	56                   	push   %esi
     d58:	be 64 00 00 00       	mov    $0x64,%esi
     d5d:	53                   	push   %ebx
     d5e:	eb 10                	jmp    d70 <exitwait+0x20>
    if(pid){
     d60:	74 68                	je     dca <exitwait+0x7a>
      if(wait() != pid){
     d62:	e8 34 2c 00 00       	call   399b <wait>
     d67:	39 d8                	cmp    %ebx,%eax
     d69:	75 2d                	jne    d98 <exitwait+0x48>
  for(i = 0; i < 100; i++){
     d6b:	83 ee 01             	sub    $0x1,%esi
     d6e:	74 41                	je     db1 <exitwait+0x61>
    pid = fork();
     d70:	e8 16 2c 00 00       	call   398b <fork>
     d75:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     d77:	85 c0                	test   %eax,%eax
     d79:	79 e5                	jns    d60 <exitwait+0x10>
      printf(1, "fork failed\n");
     d7b:	83 ec 08             	sub    $0x8,%esp
     d7e:	68 b9 4d 00 00       	push   $0x4db9
     d83:	6a 01                	push   $0x1
     d85:	e8 76 2d 00 00       	call   3b00 <printf>
      return;
     d8a:	83 c4 10             	add    $0x10,%esp
}
     d8d:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d90:	5b                   	pop    %ebx
     d91:	5e                   	pop    %esi
     d92:	5d                   	pop    %ebp
     d93:	c3                   	ret    
     d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "wait wrong pid\n");
     d98:	83 ec 08             	sub    $0x8,%esp
     d9b:	68 4b 42 00 00       	push   $0x424b
     da0:	6a 01                	push   $0x1
     da2:	e8 59 2d 00 00       	call   3b00 <printf>
        return;
     da7:	83 c4 10             	add    $0x10,%esp
}
     daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dad:	5b                   	pop    %ebx
     dae:	5e                   	pop    %esi
     daf:	5d                   	pop    %ebp
     db0:	c3                   	ret    
  printf(1, "exitwait ok\n");
     db1:	83 ec 08             	sub    $0x8,%esp
     db4:	68 5b 42 00 00       	push   $0x425b
     db9:	6a 01                	push   $0x1
     dbb:	e8 40 2d 00 00       	call   3b00 <printf>
     dc0:	83 c4 10             	add    $0x10,%esp
}
     dc3:	8d 65 f8             	lea    -0x8(%ebp),%esp
     dc6:	5b                   	pop    %ebx
     dc7:	5e                   	pop    %esi
     dc8:	5d                   	pop    %ebp
     dc9:	c3                   	ret    
      exit();
     dca:	e8 c4 2b 00 00       	call   3993 <exit>
     dcf:	90                   	nop

00000dd0 <mem>:
{
     dd0:	f3 0f 1e fb          	endbr32 
     dd4:	55                   	push   %ebp
     dd5:	89 e5                	mov    %esp,%ebp
     dd7:	56                   	push   %esi
     dd8:	31 f6                	xor    %esi,%esi
     dda:	53                   	push   %ebx
  printf(1, "mem test\n");
     ddb:	83 ec 08             	sub    $0x8,%esp
     dde:	68 68 42 00 00       	push   $0x4268
     de3:	6a 01                	push   $0x1
     de5:	e8 16 2d 00 00       	call   3b00 <printf>
  ppid = getpid();
     dea:	e8 24 2c 00 00       	call   3a13 <getpid>
     def:	89 c3                	mov    %eax,%ebx
  if((pid = fork()) == 0){
     df1:	e8 95 2b 00 00       	call   398b <fork>
     df6:	83 c4 10             	add    $0x10,%esp
     df9:	85 c0                	test   %eax,%eax
     dfb:	74 0f                	je     e0c <mem+0x3c>
     dfd:	e9 8e 00 00 00       	jmp    e90 <mem+0xc0>
     e02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *(char**)m2 = m1;
     e08:	89 30                	mov    %esi,(%eax)
     e0a:	89 c6                	mov    %eax,%esi
    while((m2 = malloc(10001)) != 0){
     e0c:	83 ec 0c             	sub    $0xc,%esp
     e0f:	68 11 27 00 00       	push   $0x2711
     e14:	e8 47 2f 00 00       	call   3d60 <malloc>
     e19:	83 c4 10             	add    $0x10,%esp
     e1c:	85 c0                	test   %eax,%eax
     e1e:	75 e8                	jne    e08 <mem+0x38>
    while(m1){
     e20:	85 f6                	test   %esi,%esi
     e22:	74 18                	je     e3c <mem+0x6c>
     e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m2 = *(char**)m1;
     e28:	89 f0                	mov    %esi,%eax
      free(m1);
     e2a:	83 ec 0c             	sub    $0xc,%esp
      m2 = *(char**)m1;
     e2d:	8b 36                	mov    (%esi),%esi
      free(m1);
     e2f:	50                   	push   %eax
     e30:	e8 9b 2e 00 00       	call   3cd0 <free>
    while(m1){
     e35:	83 c4 10             	add    $0x10,%esp
     e38:	85 f6                	test   %esi,%esi
     e3a:	75 ec                	jne    e28 <mem+0x58>
    m1 = malloc(1024*20);
     e3c:	83 ec 0c             	sub    $0xc,%esp
     e3f:	68 00 50 00 00       	push   $0x5000
     e44:	e8 17 2f 00 00       	call   3d60 <malloc>
    if(m1 == 0){
     e49:	83 c4 10             	add    $0x10,%esp
     e4c:	85 c0                	test   %eax,%eax
     e4e:	74 20                	je     e70 <mem+0xa0>
    free(m1);
     e50:	83 ec 0c             	sub    $0xc,%esp
     e53:	50                   	push   %eax
     e54:	e8 77 2e 00 00       	call   3cd0 <free>
    printf(1, "mem ok\n");
     e59:	58                   	pop    %eax
     e5a:	5a                   	pop    %edx
     e5b:	68 8c 42 00 00       	push   $0x428c
     e60:	6a 01                	push   $0x1
     e62:	e8 99 2c 00 00       	call   3b00 <printf>
    exit();
     e67:	e8 27 2b 00 00       	call   3993 <exit>
     e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printf(1, "couldn't allocate mem?!!\n");
     e70:	83 ec 08             	sub    $0x8,%esp
     e73:	68 72 42 00 00       	push   $0x4272
     e78:	6a 01                	push   $0x1
     e7a:	e8 81 2c 00 00       	call   3b00 <printf>
      kill(ppid);
     e7f:	89 1c 24             	mov    %ebx,(%esp)
     e82:	e8 3c 2b 00 00       	call   39c3 <kill>
      exit();
     e87:	e8 07 2b 00 00       	call   3993 <exit>
     e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
     e90:	8d 65 f8             	lea    -0x8(%ebp),%esp
     e93:	5b                   	pop    %ebx
     e94:	5e                   	pop    %esi
     e95:	5d                   	pop    %ebp
    wait();
     e96:	e9 00 2b 00 00       	jmp    399b <wait>
     e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e9f:	90                   	nop

00000ea0 <sharedfd>:
{
     ea0:	f3 0f 1e fb          	endbr32 
     ea4:	55                   	push   %ebp
     ea5:	89 e5                	mov    %esp,%ebp
     ea7:	57                   	push   %edi
     ea8:	56                   	push   %esi
     ea9:	53                   	push   %ebx
     eaa:	83 ec 34             	sub    $0x34,%esp
  printf(1, "sharedfd test\n");
     ead:	68 94 42 00 00       	push   $0x4294
     eb2:	6a 01                	push   $0x1
     eb4:	e8 47 2c 00 00       	call   3b00 <printf>
  unlink("sharedfd");
     eb9:	c7 04 24 a3 42 00 00 	movl   $0x42a3,(%esp)
     ec0:	e8 1e 2b 00 00       	call   39e3 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ec5:	5b                   	pop    %ebx
     ec6:	5e                   	pop    %esi
     ec7:	68 02 02 00 00       	push   $0x202
     ecc:	68 a3 42 00 00       	push   $0x42a3
     ed1:	e8 fd 2a 00 00       	call   39d3 <open>
  if(fd < 0){
     ed6:	83 c4 10             	add    $0x10,%esp
     ed9:	85 c0                	test   %eax,%eax
     edb:	0f 88 26 01 00 00    	js     1007 <sharedfd+0x167>
     ee1:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ee3:	8d 75 de             	lea    -0x22(%ebp),%esi
     ee6:	bb e8 03 00 00       	mov    $0x3e8,%ebx
  pid = fork();
     eeb:	e8 9b 2a 00 00       	call   398b <fork>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ef0:	83 f8 01             	cmp    $0x1,%eax
  pid = fork();
     ef3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  memset(buf, pid==0?'c':'p', sizeof(buf));
     ef6:	19 c0                	sbb    %eax,%eax
     ef8:	83 ec 04             	sub    $0x4,%esp
     efb:	83 e0 f3             	and    $0xfffffff3,%eax
     efe:	6a 0a                	push   $0xa
     f00:	83 c0 70             	add    $0x70,%eax
     f03:	50                   	push   %eax
     f04:	56                   	push   %esi
     f05:	e8 e6 28 00 00       	call   37f0 <memset>
     f0a:	83 c4 10             	add    $0x10,%esp
     f0d:	eb 06                	jmp    f15 <sharedfd+0x75>
     f0f:	90                   	nop
  for(i = 0; i < 1000; i++){
     f10:	83 eb 01             	sub    $0x1,%ebx
     f13:	74 26                	je     f3b <sharedfd+0x9b>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     f15:	83 ec 04             	sub    $0x4,%esp
     f18:	6a 0a                	push   $0xa
     f1a:	56                   	push   %esi
     f1b:	57                   	push   %edi
     f1c:	e8 92 2a 00 00       	call   39b3 <write>
     f21:	83 c4 10             	add    $0x10,%esp
     f24:	83 f8 0a             	cmp    $0xa,%eax
     f27:	74 e7                	je     f10 <sharedfd+0x70>
      printf(1, "fstests: write sharedfd failed\n");
     f29:	83 ec 08             	sub    $0x8,%esp
     f2c:	68 a4 4f 00 00       	push   $0x4fa4
     f31:	6a 01                	push   $0x1
     f33:	e8 c8 2b 00 00       	call   3b00 <printf>
      break;
     f38:	83 c4 10             	add    $0x10,%esp
  if(pid == 0)
     f3b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     f3e:	85 c9                	test   %ecx,%ecx
     f40:	0f 84 f5 00 00 00    	je     103b <sharedfd+0x19b>
    wait();
     f46:	e8 50 2a 00 00       	call   399b <wait>
  close(fd);
     f4b:	83 ec 0c             	sub    $0xc,%esp
  nc = np = 0;
     f4e:	31 db                	xor    %ebx,%ebx
  close(fd);
     f50:	57                   	push   %edi
     f51:	8d 7d e8             	lea    -0x18(%ebp),%edi
     f54:	e8 62 2a 00 00       	call   39bb <close>
  fd = open("sharedfd", 0);
     f59:	58                   	pop    %eax
     f5a:	5a                   	pop    %edx
     f5b:	6a 00                	push   $0x0
     f5d:	68 a3 42 00 00       	push   $0x42a3
     f62:	e8 6c 2a 00 00       	call   39d3 <open>
  if(fd < 0){
     f67:	83 c4 10             	add    $0x10,%esp
  nc = np = 0;
     f6a:	31 d2                	xor    %edx,%edx
  fd = open("sharedfd", 0);
     f6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  if(fd < 0){
     f6f:	85 c0                	test   %eax,%eax
     f71:	0f 88 aa 00 00 00    	js     1021 <sharedfd+0x181>
     f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f7e:	66 90                	xchg   %ax,%ax
  while((n = read(fd, buf, sizeof(buf))) > 0){
     f80:	83 ec 04             	sub    $0x4,%esp
     f83:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     f86:	6a 0a                	push   $0xa
     f88:	56                   	push   %esi
     f89:	ff 75 d0             	pushl  -0x30(%ebp)
     f8c:	e8 1a 2a 00 00       	call   39ab <read>
     f91:	83 c4 10             	add    $0x10,%esp
     f94:	85 c0                	test   %eax,%eax
     f96:	7e 28                	jle    fc0 <sharedfd+0x120>
    for(i = 0; i < sizeof(buf); i++){
     f98:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     f9b:	89 f0                	mov    %esi,%eax
     f9d:	eb 13                	jmp    fb2 <sharedfd+0x112>
     f9f:	90                   	nop
        np++;
     fa0:	80 f9 70             	cmp    $0x70,%cl
     fa3:	0f 94 c1             	sete   %cl
     fa6:	0f b6 c9             	movzbl %cl,%ecx
     fa9:	01 cb                	add    %ecx,%ebx
    for(i = 0; i < sizeof(buf); i++){
     fab:	83 c0 01             	add    $0x1,%eax
     fae:	39 c7                	cmp    %eax,%edi
     fb0:	74 ce                	je     f80 <sharedfd+0xe0>
      if(buf[i] == 'c')
     fb2:	0f b6 08             	movzbl (%eax),%ecx
     fb5:	80 f9 63             	cmp    $0x63,%cl
     fb8:	75 e6                	jne    fa0 <sharedfd+0x100>
        nc++;
     fba:	83 c2 01             	add    $0x1,%edx
      if(buf[i] == 'p')
     fbd:	eb ec                	jmp    fab <sharedfd+0x10b>
     fbf:	90                   	nop
  close(fd);
     fc0:	83 ec 0c             	sub    $0xc,%esp
     fc3:	ff 75 d0             	pushl  -0x30(%ebp)
     fc6:	e8 f0 29 00 00       	call   39bb <close>
  unlink("sharedfd");
     fcb:	c7 04 24 a3 42 00 00 	movl   $0x42a3,(%esp)
     fd2:	e8 0c 2a 00 00       	call   39e3 <unlink>
  if(nc == 10000 && np == 10000){
     fd7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     fda:	83 c4 10             	add    $0x10,%esp
     fdd:	81 fa 10 27 00 00    	cmp    $0x2710,%edx
     fe3:	75 5b                	jne    1040 <sharedfd+0x1a0>
     fe5:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     feb:	75 53                	jne    1040 <sharedfd+0x1a0>
    printf(1, "sharedfd ok\n");
     fed:	83 ec 08             	sub    $0x8,%esp
     ff0:	68 ac 42 00 00       	push   $0x42ac
     ff5:	6a 01                	push   $0x1
     ff7:	e8 04 2b 00 00       	call   3b00 <printf>
     ffc:	83 c4 10             	add    $0x10,%esp
}
     fff:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1002:	5b                   	pop    %ebx
    1003:	5e                   	pop    %esi
    1004:	5f                   	pop    %edi
    1005:	5d                   	pop    %ebp
    1006:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for writing");
    1007:	83 ec 08             	sub    $0x8,%esp
    100a:	68 78 4f 00 00       	push   $0x4f78
    100f:	6a 01                	push   $0x1
    1011:	e8 ea 2a 00 00       	call   3b00 <printf>
    return;
    1016:	83 c4 10             	add    $0x10,%esp
}
    1019:	8d 65 f4             	lea    -0xc(%ebp),%esp
    101c:	5b                   	pop    %ebx
    101d:	5e                   	pop    %esi
    101e:	5f                   	pop    %edi
    101f:	5d                   	pop    %ebp
    1020:	c3                   	ret    
    printf(1, "fstests: cannot open sharedfd for reading\n");
    1021:	83 ec 08             	sub    $0x8,%esp
    1024:	68 c4 4f 00 00       	push   $0x4fc4
    1029:	6a 01                	push   $0x1
    102b:	e8 d0 2a 00 00       	call   3b00 <printf>
    return;
    1030:	83 c4 10             	add    $0x10,%esp
}
    1033:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1036:	5b                   	pop    %ebx
    1037:	5e                   	pop    %esi
    1038:	5f                   	pop    %edi
    1039:	5d                   	pop    %ebp
    103a:	c3                   	ret    
    exit();
    103b:	e8 53 29 00 00       	call   3993 <exit>
    printf(1, "sharedfd oops %d %d\n", nc, np);
    1040:	53                   	push   %ebx
    1041:	52                   	push   %edx
    1042:	68 b9 42 00 00       	push   $0x42b9
    1047:	6a 01                	push   $0x1
    1049:	e8 b2 2a 00 00       	call   3b00 <printf>
    exit();
    104e:	e8 40 29 00 00       	call   3993 <exit>
    1053:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    105a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001060 <fourfiles>:
{
    1060:	f3 0f 1e fb          	endbr32 
    1064:	55                   	push   %ebp
    1065:	89 e5                	mov    %esp,%ebp
    1067:	57                   	push   %edi
    1068:	56                   	push   %esi
  printf(1, "fourfiles test\n");
    1069:	be ce 42 00 00       	mov    $0x42ce,%esi
{
    106e:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    106f:	31 db                	xor    %ebx,%ebx
{
    1071:	83 ec 34             	sub    $0x34,%esp
  char *names[] = { "f0", "f1", "f2", "f3" };
    1074:	c7 45 d8 ce 42 00 00 	movl   $0x42ce,-0x28(%ebp)
  printf(1, "fourfiles test\n");
    107b:	68 d4 42 00 00       	push   $0x42d4
    1080:	6a 01                	push   $0x1
  char *names[] = { "f0", "f1", "f2", "f3" };
    1082:	c7 45 dc 27 44 00 00 	movl   $0x4427,-0x24(%ebp)
    1089:	c7 45 e0 2b 44 00 00 	movl   $0x442b,-0x20(%ebp)
    1090:	c7 45 e4 d1 42 00 00 	movl   $0x42d1,-0x1c(%ebp)
  printf(1, "fourfiles test\n");
    1097:	e8 64 2a 00 00       	call   3b00 <printf>
    109c:	83 c4 10             	add    $0x10,%esp
    unlink(fname);
    109f:	83 ec 0c             	sub    $0xc,%esp
    10a2:	56                   	push   %esi
    10a3:	e8 3b 29 00 00       	call   39e3 <unlink>
    pid = fork();
    10a8:	e8 de 28 00 00       	call   398b <fork>
    if(pid < 0){
    10ad:	83 c4 10             	add    $0x10,%esp
    10b0:	85 c0                	test   %eax,%eax
    10b2:	0f 88 80 01 00 00    	js     1238 <fourfiles+0x1d8>
    if(pid == 0){
    10b8:	0f 84 05 01 00 00    	je     11c3 <fourfiles+0x163>
  for(pi = 0; pi < 4; pi++){
    10be:	83 c3 01             	add    $0x1,%ebx
    10c1:	83 fb 04             	cmp    $0x4,%ebx
    10c4:	74 06                	je     10cc <fourfiles+0x6c>
    10c6:	8b 74 9d d8          	mov    -0x28(%ebp,%ebx,4),%esi
    10ca:	eb d3                	jmp    109f <fourfiles+0x3f>
    wait();
    10cc:	e8 ca 28 00 00       	call   399b <wait>
  for(i = 0; i < 2; i++){
    10d1:	31 f6                	xor    %esi,%esi
    wait();
    10d3:	e8 c3 28 00 00       	call   399b <wait>
    10d8:	e8 be 28 00 00       	call   399b <wait>
    10dd:	e8 b9 28 00 00       	call   399b <wait>
    fname = names[i];
    10e2:	8b 44 b5 d8          	mov    -0x28(%ebp,%esi,4),%eax
    fd = open(fname, 0);
    10e6:	83 ec 08             	sub    $0x8,%esp
    total = 0;
    10e9:	31 db                	xor    %ebx,%ebx
    fd = open(fname, 0);
    10eb:	6a 00                	push   $0x0
    10ed:	50                   	push   %eax
    fname = names[i];
    10ee:	89 45 cc             	mov    %eax,-0x34(%ebp)
    fd = open(fname, 0);
    10f1:	e8 dd 28 00 00       	call   39d3 <open>
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10f6:	83 c4 10             	add    $0x10,%esp
    fd = open(fname, 0);
    10f9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    10fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1100:	83 ec 04             	sub    $0x4,%esp
    1103:	68 00 20 00 00       	push   $0x2000
    1108:	68 00 87 00 00       	push   $0x8700
    110d:	ff 75 d0             	pushl  -0x30(%ebp)
    1110:	e8 96 28 00 00       	call   39ab <read>
    1115:	83 c4 10             	add    $0x10,%esp
    1118:	85 c0                	test   %eax,%eax
    111a:	7e 42                	jle    115e <fourfiles+0xfe>
      printf(1, "bytes read: %d\n", n);
    111c:	83 ec 04             	sub    $0x4,%esp
    111f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    1122:	50                   	push   %eax
    1123:	68 f5 42 00 00       	push   $0x42f5
    1128:	6a 01                	push   $0x1
    112a:	e8 d1 29 00 00       	call   3b00 <printf>
      for(j = 0; j < n; j++){
    112f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      printf(1, "bytes read: %d\n", n);
    1132:	83 c4 10             	add    $0x10,%esp
      for(j = 0; j < n; j++){
    1135:	31 d2                	xor    %edx,%edx
    1137:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    113e:	66 90                	xchg   %ax,%ax
        if(buf[j] != '0'+i){
    1140:	83 fe 01             	cmp    $0x1,%esi
    1143:	0f be ba 00 87 00 00 	movsbl 0x8700(%edx),%edi
    114a:	19 c9                	sbb    %ecx,%ecx
    114c:	83 c1 31             	add    $0x31,%ecx
    114f:	39 cf                	cmp    %ecx,%edi
    1151:	75 5c                	jne    11af <fourfiles+0x14f>
      for(j = 0; j < n; j++){
    1153:	83 c2 01             	add    $0x1,%edx
    1156:	39 d0                	cmp    %edx,%eax
    1158:	75 e6                	jne    1140 <fourfiles+0xe0>
      total += n;
    115a:	01 c3                	add    %eax,%ebx
    115c:	eb a2                	jmp    1100 <fourfiles+0xa0>
    close(fd);
    115e:	83 ec 0c             	sub    $0xc,%esp
    1161:	ff 75 d0             	pushl  -0x30(%ebp)
    1164:	e8 52 28 00 00       	call   39bb <close>
    if(total != 12*500){
    1169:	83 c4 10             	add    $0x10,%esp
    116c:	81 fb 70 17 00 00    	cmp    $0x1770,%ebx
    1172:	0f 85 d4 00 00 00    	jne    124c <fourfiles+0x1ec>
    unlink(fname);
    1178:	83 ec 0c             	sub    $0xc,%esp
    117b:	ff 75 cc             	pushl  -0x34(%ebp)
    117e:	e8 60 28 00 00       	call   39e3 <unlink>
  for(i = 0; i < 2; i++){
    1183:	83 c4 10             	add    $0x10,%esp
    1186:	83 fe 01             	cmp    $0x1,%esi
    1189:	75 1a                	jne    11a5 <fourfiles+0x145>
  printf(1, "fourfiles ok\n");
    118b:	83 ec 08             	sub    $0x8,%esp
    118e:	68 22 43 00 00       	push   $0x4322
    1193:	6a 01                	push   $0x1
    1195:	e8 66 29 00 00       	call   3b00 <printf>
}
    119a:	83 c4 10             	add    $0x10,%esp
    119d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    11a0:	5b                   	pop    %ebx
    11a1:	5e                   	pop    %esi
    11a2:	5f                   	pop    %edi
    11a3:	5d                   	pop    %ebp
    11a4:	c3                   	ret    
    11a5:	be 01 00 00 00       	mov    $0x1,%esi
    11aa:	e9 33 ff ff ff       	jmp    10e2 <fourfiles+0x82>
          printf(1, "wrong char\n");
    11af:	83 ec 08             	sub    $0x8,%esp
    11b2:	68 05 43 00 00       	push   $0x4305
    11b7:	6a 01                	push   $0x1
    11b9:	e8 42 29 00 00       	call   3b00 <printf>
          exit();
    11be:	e8 d0 27 00 00       	call   3993 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    11c3:	83 ec 08             	sub    $0x8,%esp
    11c6:	68 02 02 00 00       	push   $0x202
    11cb:	56                   	push   %esi
    11cc:	e8 02 28 00 00       	call   39d3 <open>
      if(fd < 0){
    11d1:	83 c4 10             	add    $0x10,%esp
      fd = open(fname, O_CREATE | O_RDWR);
    11d4:	89 c6                	mov    %eax,%esi
      if(fd < 0){
    11d6:	85 c0                	test   %eax,%eax
    11d8:	78 45                	js     121f <fourfiles+0x1bf>
      memset(buf, '0'+pi, 512);
    11da:	83 ec 04             	sub    $0x4,%esp
    11dd:	83 c3 30             	add    $0x30,%ebx
    11e0:	68 00 02 00 00       	push   $0x200
    11e5:	53                   	push   %ebx
    11e6:	bb 0c 00 00 00       	mov    $0xc,%ebx
    11eb:	68 00 87 00 00       	push   $0x8700
    11f0:	e8 fb 25 00 00       	call   37f0 <memset>
    11f5:	83 c4 10             	add    $0x10,%esp
        if((n = write(fd, buf, 500)) != 500){
    11f8:	83 ec 04             	sub    $0x4,%esp
    11fb:	68 f4 01 00 00       	push   $0x1f4
    1200:	68 00 87 00 00       	push   $0x8700
    1205:	56                   	push   %esi
    1206:	e8 a8 27 00 00       	call   39b3 <write>
    120b:	83 c4 10             	add    $0x10,%esp
    120e:	3d f4 01 00 00       	cmp    $0x1f4,%eax
    1213:	75 4a                	jne    125f <fourfiles+0x1ff>
      for(i = 0; i < 12; i++){
    1215:	83 eb 01             	sub    $0x1,%ebx
    1218:	75 de                	jne    11f8 <fourfiles+0x198>
      exit();
    121a:	e8 74 27 00 00       	call   3993 <exit>
        printf(1, "create failed\n");
    121f:	51                   	push   %ecx
    1220:	51                   	push   %ecx
    1221:	68 7f 45 00 00       	push   $0x457f
    1226:	6a 01                	push   $0x1
    1228:	e8 d3 28 00 00       	call   3b00 <printf>
        exit();
    122d:	e8 61 27 00 00       	call   3993 <exit>
    1232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      printf(1, "fork failed\n");
    1238:	83 ec 08             	sub    $0x8,%esp
    123b:	68 b9 4d 00 00       	push   $0x4db9
    1240:	6a 01                	push   $0x1
    1242:	e8 b9 28 00 00       	call   3b00 <printf>
      exit();
    1247:	e8 47 27 00 00       	call   3993 <exit>
      printf(1, "wrong length %d\n", total);
    124c:	50                   	push   %eax
    124d:	53                   	push   %ebx
    124e:	68 11 43 00 00       	push   $0x4311
    1253:	6a 01                	push   $0x1
    1255:	e8 a6 28 00 00       	call   3b00 <printf>
      exit();
    125a:	e8 34 27 00 00       	call   3993 <exit>
          printf(1, "write failed %d\n", n);
    125f:	52                   	push   %edx
    1260:	50                   	push   %eax
    1261:	68 e4 42 00 00       	push   $0x42e4
    1266:	6a 01                	push   $0x1
    1268:	e8 93 28 00 00       	call   3b00 <printf>
          exit();
    126d:	e8 21 27 00 00       	call   3993 <exit>
    1272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001280 <createdelete>:
{
    1280:	f3 0f 1e fb          	endbr32 
    1284:	55                   	push   %ebp
    1285:	89 e5                	mov    %esp,%ebp
    1287:	57                   	push   %edi
    1288:	56                   	push   %esi
    1289:	53                   	push   %ebx
  for(pi = 0; pi < 4; pi++){
    128a:	31 db                	xor    %ebx,%ebx
{
    128c:	83 ec 44             	sub    $0x44,%esp
  printf(1, "createdelete test\n");
    128f:	68 30 43 00 00       	push   $0x4330
    1294:	6a 01                	push   $0x1
    1296:	e8 65 28 00 00       	call   3b00 <printf>
    129b:	83 c4 10             	add    $0x10,%esp
    pid = fork();
    129e:	e8 e8 26 00 00       	call   398b <fork>
    if(pid < 0){
    12a3:	85 c0                	test   %eax,%eax
    12a5:	0f 88 ce 01 00 00    	js     1479 <createdelete+0x1f9>
    if(pid == 0){
    12ab:	0f 84 17 01 00 00    	je     13c8 <createdelete+0x148>
  for(pi = 0; pi < 4; pi++){
    12b1:	83 c3 01             	add    $0x1,%ebx
    12b4:	83 fb 04             	cmp    $0x4,%ebx
    12b7:	75 e5                	jne    129e <createdelete+0x1e>
    wait();
    12b9:	e8 dd 26 00 00       	call   399b <wait>
    12be:	8d 7d c8             	lea    -0x38(%ebp),%edi
  name[0] = name[1] = name[2] = 0;
    12c1:	be ff ff ff ff       	mov    $0xffffffff,%esi
    wait();
    12c6:	e8 d0 26 00 00       	call   399b <wait>
    12cb:	e8 cb 26 00 00       	call   399b <wait>
    12d0:	e8 c6 26 00 00       	call   399b <wait>
  name[0] = name[1] = name[2] = 0;
    12d5:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
  for(i = 0; i < N; i++){
    12d9:	89 7d c0             	mov    %edi,-0x40(%ebp)
    12dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(pi = 0; pi < 4; pi++){
    12e0:	8d 46 31             	lea    0x31(%esi),%eax
    12e3:	89 f7                	mov    %esi,%edi
    12e5:	83 c6 01             	add    $0x1,%esi
    12e8:	83 fe 09             	cmp    $0x9,%esi
    12eb:	88 45 c7             	mov    %al,-0x39(%ebp)
    12ee:	0f 9f c3             	setg   %bl
    12f1:	85 f6                	test   %esi,%esi
    12f3:	0f 94 c0             	sete   %al
    12f6:	09 c3                	or     %eax,%ebx
    12f8:	88 5d c6             	mov    %bl,-0x3a(%ebp)
      name[2] = '\0';
    12fb:	bb 70 00 00 00       	mov    $0x70,%ebx
      fd = open(name, 0);
    1300:	83 ec 08             	sub    $0x8,%esp
      name[1] = '0' + i;
    1303:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
      name[0] = 'p' + pi;
    1307:	88 5d c8             	mov    %bl,-0x38(%ebp)
      fd = open(name, 0);
    130a:	6a 00                	push   $0x0
    130c:	ff 75 c0             	pushl  -0x40(%ebp)
      name[1] = '0' + i;
    130f:	88 45 c9             	mov    %al,-0x37(%ebp)
      fd = open(name, 0);
    1312:	e8 bc 26 00 00       	call   39d3 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1317:	83 c4 10             	add    $0x10,%esp
    131a:	80 7d c6 00          	cmpb   $0x0,-0x3a(%ebp)
    131e:	0f 84 8c 00 00 00    	je     13b0 <createdelete+0x130>
    1324:	85 c0                	test   %eax,%eax
    1326:	0f 88 21 01 00 00    	js     144d <createdelete+0x1cd>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    132c:	83 ff 08             	cmp    $0x8,%edi
    132f:	0f 86 60 01 00 00    	jbe    1495 <createdelete+0x215>
        close(fd);
    1335:	83 ec 0c             	sub    $0xc,%esp
    1338:	50                   	push   %eax
    1339:	e8 7d 26 00 00       	call   39bb <close>
    133e:	83 c4 10             	add    $0x10,%esp
    for(pi = 0; pi < 4; pi++){
    1341:	83 c3 01             	add    $0x1,%ebx
    1344:	80 fb 74             	cmp    $0x74,%bl
    1347:	75 b7                	jne    1300 <createdelete+0x80>
  for(i = 0; i < N; i++){
    1349:	83 fe 13             	cmp    $0x13,%esi
    134c:	75 92                	jne    12e0 <createdelete+0x60>
    134e:	8b 7d c0             	mov    -0x40(%ebp),%edi
    1351:	be 70 00 00 00       	mov    $0x70,%esi
    1356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    135d:	8d 76 00             	lea    0x0(%esi),%esi
    for(pi = 0; pi < 4; pi++){
    1360:	8d 46 c0             	lea    -0x40(%esi),%eax
  name[0] = name[1] = name[2] = 0;
    1363:	bb 04 00 00 00       	mov    $0x4,%ebx
    1368:	88 45 c7             	mov    %al,-0x39(%ebp)
      unlink(name);
    136b:	83 ec 0c             	sub    $0xc,%esp
      name[0] = 'p' + i;
    136e:	89 f0                	mov    %esi,%eax
      unlink(name);
    1370:	57                   	push   %edi
      name[0] = 'p' + i;
    1371:	88 45 c8             	mov    %al,-0x38(%ebp)
      name[1] = '0' + i;
    1374:	0f b6 45 c7          	movzbl -0x39(%ebp),%eax
    1378:	88 45 c9             	mov    %al,-0x37(%ebp)
      unlink(name);
    137b:	e8 63 26 00 00       	call   39e3 <unlink>
    for(pi = 0; pi < 4; pi++){
    1380:	83 c4 10             	add    $0x10,%esp
    1383:	83 eb 01             	sub    $0x1,%ebx
    1386:	75 e3                	jne    136b <createdelete+0xeb>
  for(i = 0; i < N; i++){
    1388:	83 c6 01             	add    $0x1,%esi
    138b:	89 f0                	mov    %esi,%eax
    138d:	3c 84                	cmp    $0x84,%al
    138f:	75 cf                	jne    1360 <createdelete+0xe0>
  printf(1, "createdelete ok\n");
    1391:	83 ec 08             	sub    $0x8,%esp
    1394:	68 43 43 00 00       	push   $0x4343
    1399:	6a 01                	push   $0x1
    139b:	e8 60 27 00 00       	call   3b00 <printf>
}
    13a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    13a3:	5b                   	pop    %ebx
    13a4:	5e                   	pop    %esi
    13a5:	5f                   	pop    %edi
    13a6:	5d                   	pop    %ebp
    13a7:	c3                   	ret    
    13a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    13af:	90                   	nop
      } else if((i >= 1 && i < N/2) && fd >= 0){
    13b0:	83 ff 08             	cmp    $0x8,%edi
    13b3:	0f 86 d4 00 00 00    	jbe    148d <createdelete+0x20d>
      if(fd >= 0)
    13b9:	85 c0                	test   %eax,%eax
    13bb:	78 84                	js     1341 <createdelete+0xc1>
    13bd:	e9 73 ff ff ff       	jmp    1335 <createdelete+0xb5>
    13c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      name[0] = 'p' + pi;
    13c8:	83 c3 70             	add    $0x70,%ebx
      name[2] = '\0';
    13cb:	c6 45 ca 00          	movb   $0x0,-0x36(%ebp)
    13cf:	8d 7d c8             	lea    -0x38(%ebp),%edi
      name[0] = 'p' + pi;
    13d2:	88 5d c8             	mov    %bl,-0x38(%ebp)
      name[2] = '\0';
    13d5:	31 db                	xor    %ebx,%ebx
    13d7:	eb 0f                	jmp    13e8 <createdelete+0x168>
    13d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i = 0; i < N; i++){
    13e0:	83 fb 13             	cmp    $0x13,%ebx
    13e3:	74 63                	je     1448 <createdelete+0x1c8>
    13e5:	83 c3 01             	add    $0x1,%ebx
        fd = open(name, O_CREATE | O_RDWR);
    13e8:	83 ec 08             	sub    $0x8,%esp
        name[1] = '0' + i;
    13eb:	8d 43 30             	lea    0x30(%ebx),%eax
        fd = open(name, O_CREATE | O_RDWR);
    13ee:	68 02 02 00 00       	push   $0x202
    13f3:	57                   	push   %edi
        name[1] = '0' + i;
    13f4:	88 45 c9             	mov    %al,-0x37(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    13f7:	e8 d7 25 00 00       	call   39d3 <open>
        if(fd < 0){
    13fc:	83 c4 10             	add    $0x10,%esp
    13ff:	85 c0                	test   %eax,%eax
    1401:	78 62                	js     1465 <createdelete+0x1e5>
        close(fd);
    1403:	83 ec 0c             	sub    $0xc,%esp
    1406:	50                   	push   %eax
    1407:	e8 af 25 00 00       	call   39bb <close>
        if(i > 0 && (i % 2 ) == 0){
    140c:	83 c4 10             	add    $0x10,%esp
    140f:	85 db                	test   %ebx,%ebx
    1411:	74 d2                	je     13e5 <createdelete+0x165>
    1413:	f6 c3 01             	test   $0x1,%bl
    1416:	75 c8                	jne    13e0 <createdelete+0x160>
          if(unlink(name) < 0){
    1418:	83 ec 0c             	sub    $0xc,%esp
          name[1] = '0' + (i / 2);
    141b:	89 d8                	mov    %ebx,%eax
          if(unlink(name) < 0){
    141d:	57                   	push   %edi
          name[1] = '0' + (i / 2);
    141e:	d1 f8                	sar    %eax
    1420:	83 c0 30             	add    $0x30,%eax
    1423:	88 45 c9             	mov    %al,-0x37(%ebp)
          if(unlink(name) < 0){
    1426:	e8 b8 25 00 00       	call   39e3 <unlink>
    142b:	83 c4 10             	add    $0x10,%esp
    142e:	85 c0                	test   %eax,%eax
    1430:	79 ae                	jns    13e0 <createdelete+0x160>
            printf(1, "unlink failed\n");
    1432:	52                   	push   %edx
    1433:	52                   	push   %edx
    1434:	68 21 3f 00 00       	push   $0x3f21
    1439:	6a 01                	push   $0x1
    143b:	e8 c0 26 00 00       	call   3b00 <printf>
            exit();
    1440:	e8 4e 25 00 00       	call   3993 <exit>
    1445:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
    1448:	e8 46 25 00 00       	call   3993 <exit>
    144d:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s didn't exist\n", name);
    1450:	83 ec 04             	sub    $0x4,%esp
    1453:	57                   	push   %edi
    1454:	68 f0 4f 00 00       	push   $0x4ff0
    1459:	6a 01                	push   $0x1
    145b:	e8 a0 26 00 00       	call   3b00 <printf>
        exit();
    1460:	e8 2e 25 00 00       	call   3993 <exit>
          printf(1, "create failed\n");
    1465:	83 ec 08             	sub    $0x8,%esp
    1468:	68 7f 45 00 00       	push   $0x457f
    146d:	6a 01                	push   $0x1
    146f:	e8 8c 26 00 00       	call   3b00 <printf>
          exit();
    1474:	e8 1a 25 00 00       	call   3993 <exit>
      printf(1, "fork failed\n");
    1479:	83 ec 08             	sub    $0x8,%esp
    147c:	68 b9 4d 00 00       	push   $0x4db9
    1481:	6a 01                	push   $0x1
    1483:	e8 78 26 00 00       	call   3b00 <printf>
      exit();
    1488:	e8 06 25 00 00       	call   3993 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    148d:	85 c0                	test   %eax,%eax
    148f:	0f 88 ac fe ff ff    	js     1341 <createdelete+0xc1>
    1495:	8b 7d c0             	mov    -0x40(%ebp),%edi
        printf(1, "oops createdelete %s did exist\n", name);
    1498:	50                   	push   %eax
    1499:	57                   	push   %edi
    149a:	68 14 50 00 00       	push   $0x5014
    149f:	6a 01                	push   $0x1
    14a1:	e8 5a 26 00 00       	call   3b00 <printf>
        exit();
    14a6:	e8 e8 24 00 00       	call   3993 <exit>
    14ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    14af:	90                   	nop

000014b0 <unlinkread>:
{
    14b0:	f3 0f 1e fb          	endbr32 
    14b4:	55                   	push   %ebp
    14b5:	89 e5                	mov    %esp,%ebp
    14b7:	56                   	push   %esi
    14b8:	53                   	push   %ebx
  printf(1, "unlinkread test\n");
    14b9:	83 ec 08             	sub    $0x8,%esp
    14bc:	68 54 43 00 00       	push   $0x4354
    14c1:	6a 01                	push   $0x1
    14c3:	e8 38 26 00 00       	call   3b00 <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    14c8:	5b                   	pop    %ebx
    14c9:	5e                   	pop    %esi
    14ca:	68 02 02 00 00       	push   $0x202
    14cf:	68 65 43 00 00       	push   $0x4365
    14d4:	e8 fa 24 00 00       	call   39d3 <open>
  if(fd < 0){
    14d9:	83 c4 10             	add    $0x10,%esp
    14dc:	85 c0                	test   %eax,%eax
    14de:	0f 88 e6 00 00 00    	js     15ca <unlinkread+0x11a>
  write(fd, "hello", 5);
    14e4:	83 ec 04             	sub    $0x4,%esp
    14e7:	89 c3                	mov    %eax,%ebx
    14e9:	6a 05                	push   $0x5
    14eb:	68 8a 43 00 00       	push   $0x438a
    14f0:	50                   	push   %eax
    14f1:	e8 bd 24 00 00       	call   39b3 <write>
  close(fd);
    14f6:	89 1c 24             	mov    %ebx,(%esp)
    14f9:	e8 bd 24 00 00       	call   39bb <close>
  fd = open("unlinkread", O_RDWR);
    14fe:	58                   	pop    %eax
    14ff:	5a                   	pop    %edx
    1500:	6a 02                	push   $0x2
    1502:	68 65 43 00 00       	push   $0x4365
    1507:	e8 c7 24 00 00       	call   39d3 <open>
  if(fd < 0){
    150c:	83 c4 10             	add    $0x10,%esp
  fd = open("unlinkread", O_RDWR);
    150f:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1511:	85 c0                	test   %eax,%eax
    1513:	0f 88 10 01 00 00    	js     1629 <unlinkread+0x179>
  if(unlink("unlinkread") != 0){
    1519:	83 ec 0c             	sub    $0xc,%esp
    151c:	68 65 43 00 00       	push   $0x4365
    1521:	e8 bd 24 00 00       	call   39e3 <unlink>
    1526:	83 c4 10             	add    $0x10,%esp
    1529:	85 c0                	test   %eax,%eax
    152b:	0f 85 e5 00 00 00    	jne    1616 <unlinkread+0x166>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1531:	83 ec 08             	sub    $0x8,%esp
    1534:	68 02 02 00 00       	push   $0x202
    1539:	68 65 43 00 00       	push   $0x4365
    153e:	e8 90 24 00 00       	call   39d3 <open>
  write(fd1, "yyy", 3);
    1543:	83 c4 0c             	add    $0xc,%esp
    1546:	6a 03                	push   $0x3
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1548:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    154a:	68 c2 43 00 00       	push   $0x43c2
    154f:	50                   	push   %eax
    1550:	e8 5e 24 00 00       	call   39b3 <write>
  close(fd1);
    1555:	89 34 24             	mov    %esi,(%esp)
    1558:	e8 5e 24 00 00       	call   39bb <close>
  if(read(fd, buf, sizeof(buf)) != 5){
    155d:	83 c4 0c             	add    $0xc,%esp
    1560:	68 00 20 00 00       	push   $0x2000
    1565:	68 00 87 00 00       	push   $0x8700
    156a:	53                   	push   %ebx
    156b:	e8 3b 24 00 00       	call   39ab <read>
    1570:	83 c4 10             	add    $0x10,%esp
    1573:	83 f8 05             	cmp    $0x5,%eax
    1576:	0f 85 87 00 00 00    	jne    1603 <unlinkread+0x153>
  if(buf[0] != 'h'){
    157c:	80 3d 00 87 00 00 68 	cmpb   $0x68,0x8700
    1583:	75 6b                	jne    15f0 <unlinkread+0x140>
  if(write(fd, buf, 10) != 10){
    1585:	83 ec 04             	sub    $0x4,%esp
    1588:	6a 0a                	push   $0xa
    158a:	68 00 87 00 00       	push   $0x8700
    158f:	53                   	push   %ebx
    1590:	e8 1e 24 00 00       	call   39b3 <write>
    1595:	83 c4 10             	add    $0x10,%esp
    1598:	83 f8 0a             	cmp    $0xa,%eax
    159b:	75 40                	jne    15dd <unlinkread+0x12d>
  close(fd);
    159d:	83 ec 0c             	sub    $0xc,%esp
    15a0:	53                   	push   %ebx
    15a1:	e8 15 24 00 00       	call   39bb <close>
  unlink("unlinkread");
    15a6:	c7 04 24 65 43 00 00 	movl   $0x4365,(%esp)
    15ad:	e8 31 24 00 00       	call   39e3 <unlink>
  printf(1, "unlinkread ok\n");
    15b2:	58                   	pop    %eax
    15b3:	5a                   	pop    %edx
    15b4:	68 0d 44 00 00       	push   $0x440d
    15b9:	6a 01                	push   $0x1
    15bb:	e8 40 25 00 00       	call   3b00 <printf>
}
    15c0:	83 c4 10             	add    $0x10,%esp
    15c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
    15c6:	5b                   	pop    %ebx
    15c7:	5e                   	pop    %esi
    15c8:	5d                   	pop    %ebp
    15c9:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    15ca:	51                   	push   %ecx
    15cb:	51                   	push   %ecx
    15cc:	68 70 43 00 00       	push   $0x4370
    15d1:	6a 01                	push   $0x1
    15d3:	e8 28 25 00 00       	call   3b00 <printf>
    exit();
    15d8:	e8 b6 23 00 00       	call   3993 <exit>
    printf(1, "unlinkread write failed\n");
    15dd:	51                   	push   %ecx
    15de:	51                   	push   %ecx
    15df:	68 f4 43 00 00       	push   $0x43f4
    15e4:	6a 01                	push   $0x1
    15e6:	e8 15 25 00 00       	call   3b00 <printf>
    exit();
    15eb:	e8 a3 23 00 00       	call   3993 <exit>
    printf(1, "unlinkread wrong data\n");
    15f0:	53                   	push   %ebx
    15f1:	53                   	push   %ebx
    15f2:	68 dd 43 00 00       	push   $0x43dd
    15f7:	6a 01                	push   $0x1
    15f9:	e8 02 25 00 00       	call   3b00 <printf>
    exit();
    15fe:	e8 90 23 00 00       	call   3993 <exit>
    printf(1, "unlinkread read failed");
    1603:	56                   	push   %esi
    1604:	56                   	push   %esi
    1605:	68 c6 43 00 00       	push   $0x43c6
    160a:	6a 01                	push   $0x1
    160c:	e8 ef 24 00 00       	call   3b00 <printf>
    exit();
    1611:	e8 7d 23 00 00       	call   3993 <exit>
    printf(1, "unlink unlinkread failed\n");
    1616:	50                   	push   %eax
    1617:	50                   	push   %eax
    1618:	68 a8 43 00 00       	push   $0x43a8
    161d:	6a 01                	push   $0x1
    161f:	e8 dc 24 00 00       	call   3b00 <printf>
    exit();
    1624:	e8 6a 23 00 00       	call   3993 <exit>
    printf(1, "open unlinkread failed\n");
    1629:	50                   	push   %eax
    162a:	50                   	push   %eax
    162b:	68 90 43 00 00       	push   $0x4390
    1630:	6a 01                	push   $0x1
    1632:	e8 c9 24 00 00       	call   3b00 <printf>
    exit();
    1637:	e8 57 23 00 00       	call   3993 <exit>
    163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001640 <linktest>:
{
    1640:	f3 0f 1e fb          	endbr32 
    1644:	55                   	push   %ebp
    1645:	89 e5                	mov    %esp,%ebp
    1647:	53                   	push   %ebx
    1648:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "linktest\n");
    164b:	68 1c 44 00 00       	push   $0x441c
    1650:	6a 01                	push   $0x1
    1652:	e8 a9 24 00 00       	call   3b00 <printf>
  unlink("lf1");
    1657:	c7 04 24 26 44 00 00 	movl   $0x4426,(%esp)
    165e:	e8 80 23 00 00       	call   39e3 <unlink>
  unlink("lf2");
    1663:	c7 04 24 2a 44 00 00 	movl   $0x442a,(%esp)
    166a:	e8 74 23 00 00       	call   39e3 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    166f:	58                   	pop    %eax
    1670:	5a                   	pop    %edx
    1671:	68 02 02 00 00       	push   $0x202
    1676:	68 26 44 00 00       	push   $0x4426
    167b:	e8 53 23 00 00       	call   39d3 <open>
  if(fd < 0){
    1680:	83 c4 10             	add    $0x10,%esp
    1683:	85 c0                	test   %eax,%eax
    1685:	0f 88 1e 01 00 00    	js     17a9 <linktest+0x169>
  if(write(fd, "hello", 5) != 5){
    168b:	83 ec 04             	sub    $0x4,%esp
    168e:	89 c3                	mov    %eax,%ebx
    1690:	6a 05                	push   $0x5
    1692:	68 8a 43 00 00       	push   $0x438a
    1697:	50                   	push   %eax
    1698:	e8 16 23 00 00       	call   39b3 <write>
    169d:	83 c4 10             	add    $0x10,%esp
    16a0:	83 f8 05             	cmp    $0x5,%eax
    16a3:	0f 85 98 01 00 00    	jne    1841 <linktest+0x201>
  close(fd);
    16a9:	83 ec 0c             	sub    $0xc,%esp
    16ac:	53                   	push   %ebx
    16ad:	e8 09 23 00 00       	call   39bb <close>
  if(link("lf1", "lf2") < 0){
    16b2:	5b                   	pop    %ebx
    16b3:	58                   	pop    %eax
    16b4:	68 2a 44 00 00       	push   $0x442a
    16b9:	68 26 44 00 00       	push   $0x4426
    16be:	e8 30 23 00 00       	call   39f3 <link>
    16c3:	83 c4 10             	add    $0x10,%esp
    16c6:	85 c0                	test   %eax,%eax
    16c8:	0f 88 60 01 00 00    	js     182e <linktest+0x1ee>
  unlink("lf1");
    16ce:	83 ec 0c             	sub    $0xc,%esp
    16d1:	68 26 44 00 00       	push   $0x4426
    16d6:	e8 08 23 00 00       	call   39e3 <unlink>
  if(open("lf1", 0) >= 0){
    16db:	58                   	pop    %eax
    16dc:	5a                   	pop    %edx
    16dd:	6a 00                	push   $0x0
    16df:	68 26 44 00 00       	push   $0x4426
    16e4:	e8 ea 22 00 00       	call   39d3 <open>
    16e9:	83 c4 10             	add    $0x10,%esp
    16ec:	85 c0                	test   %eax,%eax
    16ee:	0f 89 27 01 00 00    	jns    181b <linktest+0x1db>
  fd = open("lf2", 0);
    16f4:	83 ec 08             	sub    $0x8,%esp
    16f7:	6a 00                	push   $0x0
    16f9:	68 2a 44 00 00       	push   $0x442a
    16fe:	e8 d0 22 00 00       	call   39d3 <open>
  if(fd < 0){
    1703:	83 c4 10             	add    $0x10,%esp
  fd = open("lf2", 0);
    1706:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1708:	85 c0                	test   %eax,%eax
    170a:	0f 88 f8 00 00 00    	js     1808 <linktest+0x1c8>
  if(read(fd, buf, sizeof(buf)) != 5){
    1710:	83 ec 04             	sub    $0x4,%esp
    1713:	68 00 20 00 00       	push   $0x2000
    1718:	68 00 87 00 00       	push   $0x8700
    171d:	50                   	push   %eax
    171e:	e8 88 22 00 00       	call   39ab <read>
    1723:	83 c4 10             	add    $0x10,%esp
    1726:	83 f8 05             	cmp    $0x5,%eax
    1729:	0f 85 c6 00 00 00    	jne    17f5 <linktest+0x1b5>
  close(fd);
    172f:	83 ec 0c             	sub    $0xc,%esp
    1732:	53                   	push   %ebx
    1733:	e8 83 22 00 00       	call   39bb <close>
  if(link("lf2", "lf2") >= 0){
    1738:	58                   	pop    %eax
    1739:	5a                   	pop    %edx
    173a:	68 2a 44 00 00       	push   $0x442a
    173f:	68 2a 44 00 00       	push   $0x442a
    1744:	e8 aa 22 00 00       	call   39f3 <link>
    1749:	83 c4 10             	add    $0x10,%esp
    174c:	85 c0                	test   %eax,%eax
    174e:	0f 89 8e 00 00 00    	jns    17e2 <linktest+0x1a2>
  unlink("lf2");
    1754:	83 ec 0c             	sub    $0xc,%esp
    1757:	68 2a 44 00 00       	push   $0x442a
    175c:	e8 82 22 00 00       	call   39e3 <unlink>
  if(link("lf2", "lf1") >= 0){
    1761:	59                   	pop    %ecx
    1762:	5b                   	pop    %ebx
    1763:	68 26 44 00 00       	push   $0x4426
    1768:	68 2a 44 00 00       	push   $0x442a
    176d:	e8 81 22 00 00       	call   39f3 <link>
    1772:	83 c4 10             	add    $0x10,%esp
    1775:	85 c0                	test   %eax,%eax
    1777:	79 56                	jns    17cf <linktest+0x18f>
  if(link(".", "lf1") >= 0){
    1779:	83 ec 08             	sub    $0x8,%esp
    177c:	68 26 44 00 00       	push   $0x4426
    1781:	68 ee 46 00 00       	push   $0x46ee
    1786:	e8 68 22 00 00       	call   39f3 <link>
    178b:	83 c4 10             	add    $0x10,%esp
    178e:	85 c0                	test   %eax,%eax
    1790:	79 2a                	jns    17bc <linktest+0x17c>
  printf(1, "linktest ok\n");
    1792:	83 ec 08             	sub    $0x8,%esp
    1795:	68 c4 44 00 00       	push   $0x44c4
    179a:	6a 01                	push   $0x1
    179c:	e8 5f 23 00 00       	call   3b00 <printf>
}
    17a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    17a4:	83 c4 10             	add    $0x10,%esp
    17a7:	c9                   	leave  
    17a8:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    17a9:	50                   	push   %eax
    17aa:	50                   	push   %eax
    17ab:	68 2e 44 00 00       	push   $0x442e
    17b0:	6a 01                	push   $0x1
    17b2:	e8 49 23 00 00       	call   3b00 <printf>
    exit();
    17b7:	e8 d7 21 00 00       	call   3993 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    17bc:	50                   	push   %eax
    17bd:	50                   	push   %eax
    17be:	68 a8 44 00 00       	push   $0x44a8
    17c3:	6a 01                	push   $0x1
    17c5:	e8 36 23 00 00       	call   3b00 <printf>
    exit();
    17ca:	e8 c4 21 00 00       	call   3993 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    17cf:	52                   	push   %edx
    17d0:	52                   	push   %edx
    17d1:	68 5c 50 00 00       	push   $0x505c
    17d6:	6a 01                	push   $0x1
    17d8:	e8 23 23 00 00       	call   3b00 <printf>
    exit();
    17dd:	e8 b1 21 00 00       	call   3993 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    17e2:	50                   	push   %eax
    17e3:	50                   	push   %eax
    17e4:	68 8a 44 00 00       	push   $0x448a
    17e9:	6a 01                	push   $0x1
    17eb:	e8 10 23 00 00       	call   3b00 <printf>
    exit();
    17f0:	e8 9e 21 00 00       	call   3993 <exit>
    printf(1, "read lf2 failed\n");
    17f5:	51                   	push   %ecx
    17f6:	51                   	push   %ecx
    17f7:	68 79 44 00 00       	push   $0x4479
    17fc:	6a 01                	push   $0x1
    17fe:	e8 fd 22 00 00       	call   3b00 <printf>
    exit();
    1803:	e8 8b 21 00 00       	call   3993 <exit>
    printf(1, "open lf2 failed\n");
    1808:	53                   	push   %ebx
    1809:	53                   	push   %ebx
    180a:	68 68 44 00 00       	push   $0x4468
    180f:	6a 01                	push   $0x1
    1811:	e8 ea 22 00 00       	call   3b00 <printf>
    exit();
    1816:	e8 78 21 00 00       	call   3993 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    181b:	50                   	push   %eax
    181c:	50                   	push   %eax
    181d:	68 34 50 00 00       	push   $0x5034
    1822:	6a 01                	push   $0x1
    1824:	e8 d7 22 00 00       	call   3b00 <printf>
    exit();
    1829:	e8 65 21 00 00       	call   3993 <exit>
    printf(1, "link lf1 lf2 failed\n");
    182e:	51                   	push   %ecx
    182f:	51                   	push   %ecx
    1830:	68 53 44 00 00       	push   $0x4453
    1835:	6a 01                	push   $0x1
    1837:	e8 c4 22 00 00       	call   3b00 <printf>
    exit();
    183c:	e8 52 21 00 00       	call   3993 <exit>
    printf(1, "write lf1 failed\n");
    1841:	50                   	push   %eax
    1842:	50                   	push   %eax
    1843:	68 41 44 00 00       	push   $0x4441
    1848:	6a 01                	push   $0x1
    184a:	e8 b1 22 00 00       	call   3b00 <printf>
    exit();
    184f:	e8 3f 21 00 00       	call   3993 <exit>
    1854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    185b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    185f:	90                   	nop

00001860 <concreate>:
{
    1860:	f3 0f 1e fb          	endbr32 
    1864:	55                   	push   %ebp
    1865:	89 e5                	mov    %esp,%ebp
    1867:	57                   	push   %edi
    1868:	56                   	push   %esi
  for(i = 0; i < 40; i++){
    1869:	31 f6                	xor    %esi,%esi
{
    186b:	53                   	push   %ebx
    186c:	8d 5d ad             	lea    -0x53(%ebp),%ebx
    186f:	83 ec 64             	sub    $0x64,%esp
  printf(1, "concreate test\n");
    1872:	68 d1 44 00 00       	push   $0x44d1
    1877:	6a 01                	push   $0x1
    1879:	e8 82 22 00 00       	call   3b00 <printf>
  file[0] = 'C';
    187e:	c6 45 ad 43          	movb   $0x43,-0x53(%ebp)
  file[2] = '\0';
    1882:	83 c4 10             	add    $0x10,%esp
    1885:	c6 45 af 00          	movb   $0x0,-0x51(%ebp)
  for(i = 0; i < 40; i++){
    1889:	eb 48                	jmp    18d3 <concreate+0x73>
    188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    188f:	90                   	nop
    1890:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
    if(pid && (i % 3) == 1){
    1896:	3d ab aa aa aa       	cmp    $0xaaaaaaab,%eax
    189b:	0f 83 af 00 00 00    	jae    1950 <concreate+0xf0>
      fd = open(file, O_CREATE | O_RDWR);
    18a1:	83 ec 08             	sub    $0x8,%esp
    18a4:	68 02 02 00 00       	push   $0x202
    18a9:	53                   	push   %ebx
    18aa:	e8 24 21 00 00       	call   39d3 <open>
      if(fd < 0){
    18af:	83 c4 10             	add    $0x10,%esp
    18b2:	85 c0                	test   %eax,%eax
    18b4:	78 5f                	js     1915 <concreate+0xb5>
      close(fd);
    18b6:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 40; i++){
    18b9:	83 c6 01             	add    $0x1,%esi
      close(fd);
    18bc:	50                   	push   %eax
    18bd:	e8 f9 20 00 00       	call   39bb <close>
    18c2:	83 c4 10             	add    $0x10,%esp
      wait();
    18c5:	e8 d1 20 00 00       	call   399b <wait>
  for(i = 0; i < 40; i++){
    18ca:	83 fe 28             	cmp    $0x28,%esi
    18cd:	0f 84 9f 00 00 00    	je     1972 <concreate+0x112>
    unlink(file);
    18d3:	83 ec 0c             	sub    $0xc,%esp
    file[1] = '0' + i;
    18d6:	8d 46 30             	lea    0x30(%esi),%eax
    unlink(file);
    18d9:	53                   	push   %ebx
    file[1] = '0' + i;
    18da:	88 45 ae             	mov    %al,-0x52(%ebp)
    unlink(file);
    18dd:	e8 01 21 00 00       	call   39e3 <unlink>
    pid = fork();
    18e2:	e8 a4 20 00 00       	call   398b <fork>
    if(pid && (i % 3) == 1){
    18e7:	83 c4 10             	add    $0x10,%esp
    18ea:	85 c0                	test   %eax,%eax
    18ec:	75 a2                	jne    1890 <concreate+0x30>
      link("C0", file);
    18ee:	69 f6 cd cc cc cc    	imul   $0xcccccccd,%esi,%esi
    } else if(pid == 0 && (i % 5) == 1){
    18f4:	81 fe cd cc cc cc    	cmp    $0xcccccccd,%esi
    18fa:	73 34                	jae    1930 <concreate+0xd0>
      fd = open(file, O_CREATE | O_RDWR);
    18fc:	83 ec 08             	sub    $0x8,%esp
    18ff:	68 02 02 00 00       	push   $0x202
    1904:	53                   	push   %ebx
    1905:	e8 c9 20 00 00       	call   39d3 <open>
      if(fd < 0){
    190a:	83 c4 10             	add    $0x10,%esp
    190d:	85 c0                	test   %eax,%eax
    190f:	0f 89 39 02 00 00    	jns    1b4e <concreate+0x2ee>
        printf(1, "concreate create %s failed\n", file);
    1915:	83 ec 04             	sub    $0x4,%esp
    1918:	53                   	push   %ebx
    1919:	68 e4 44 00 00       	push   $0x44e4
    191e:	6a 01                	push   $0x1
    1920:	e8 db 21 00 00       	call   3b00 <printf>
        exit();
    1925:	e8 69 20 00 00       	call   3993 <exit>
    192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      link("C0", file);
    1930:	83 ec 08             	sub    $0x8,%esp
    1933:	53                   	push   %ebx
    1934:	68 e1 44 00 00       	push   $0x44e1
    1939:	e8 b5 20 00 00       	call   39f3 <link>
    193e:	83 c4 10             	add    $0x10,%esp
      exit();
    1941:	e8 4d 20 00 00       	call   3993 <exit>
    1946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    194d:	8d 76 00             	lea    0x0(%esi),%esi
      link("C0", file);
    1950:	83 ec 08             	sub    $0x8,%esp
  for(i = 0; i < 40; i++){
    1953:	83 c6 01             	add    $0x1,%esi
      link("C0", file);
    1956:	53                   	push   %ebx
    1957:	68 e1 44 00 00       	push   $0x44e1
    195c:	e8 92 20 00 00       	call   39f3 <link>
    1961:	83 c4 10             	add    $0x10,%esp
      wait();
    1964:	e8 32 20 00 00       	call   399b <wait>
  for(i = 0; i < 40; i++){
    1969:	83 fe 28             	cmp    $0x28,%esi
    196c:	0f 85 61 ff ff ff    	jne    18d3 <concreate+0x73>
  memset(fa, 0, sizeof(fa));
    1972:	83 ec 04             	sub    $0x4,%esp
    1975:	8d 45 c0             	lea    -0x40(%ebp),%eax
    1978:	6a 28                	push   $0x28
    197a:	6a 00                	push   $0x0
    197c:	50                   	push   %eax
    197d:	e8 6e 1e 00 00       	call   37f0 <memset>
  fd = open(".", 0);
    1982:	5e                   	pop    %esi
    1983:	5f                   	pop    %edi
    1984:	6a 00                	push   $0x0
    1986:	68 ee 46 00 00       	push   $0x46ee
    198b:	8d 7d b0             	lea    -0x50(%ebp),%edi
    198e:	e8 40 20 00 00       	call   39d3 <open>
  n = 0;
    1993:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
  while(read(fd, &de, sizeof(de)) > 0){
    199a:	83 c4 10             	add    $0x10,%esp
  fd = open(".", 0);
    199d:	89 c6                	mov    %eax,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    199f:	90                   	nop
    19a0:	83 ec 04             	sub    $0x4,%esp
    19a3:	6a 10                	push   $0x10
    19a5:	57                   	push   %edi
    19a6:	56                   	push   %esi
    19a7:	e8 ff 1f 00 00       	call   39ab <read>
    19ac:	83 c4 10             	add    $0x10,%esp
    19af:	85 c0                	test   %eax,%eax
    19b1:	7e 3d                	jle    19f0 <concreate+0x190>
    if(de.inum == 0)
    19b3:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
    19b8:	74 e6                	je     19a0 <concreate+0x140>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    19ba:	80 7d b2 43          	cmpb   $0x43,-0x4e(%ebp)
    19be:	75 e0                	jne    19a0 <concreate+0x140>
    19c0:	80 7d b4 00          	cmpb   $0x0,-0x4c(%ebp)
    19c4:	75 da                	jne    19a0 <concreate+0x140>
      i = de.name[1] - '0';
    19c6:	0f be 45 b3          	movsbl -0x4d(%ebp),%eax
    19ca:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    19cd:	83 f8 27             	cmp    $0x27,%eax
    19d0:	0f 87 60 01 00 00    	ja     1b36 <concreate+0x2d6>
      if(fa[i]){
    19d6:	80 7c 05 c0 00       	cmpb   $0x0,-0x40(%ebp,%eax,1)
    19db:	0f 85 3d 01 00 00    	jne    1b1e <concreate+0x2be>
      n++;
    19e1:	83 45 a4 01          	addl   $0x1,-0x5c(%ebp)
      fa[i] = 1;
    19e5:	c6 44 05 c0 01       	movb   $0x1,-0x40(%ebp,%eax,1)
      n++;
    19ea:	eb b4                	jmp    19a0 <concreate+0x140>
    19ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  close(fd);
    19f0:	83 ec 0c             	sub    $0xc,%esp
    19f3:	56                   	push   %esi
    19f4:	e8 c2 1f 00 00       	call   39bb <close>
  if(n != 40){
    19f9:	83 c4 10             	add    $0x10,%esp
    19fc:	83 7d a4 28          	cmpl   $0x28,-0x5c(%ebp)
    1a00:	0f 85 05 01 00 00    	jne    1b0b <concreate+0x2ab>
  for(i = 0; i < 40; i++){
    1a06:	31 f6                	xor    %esi,%esi
    1a08:	eb 4c                	jmp    1a56 <concreate+0x1f6>
    1a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
       ((i % 3) == 1 && pid != 0)){
    1a10:	85 ff                	test   %edi,%edi
    1a12:	74 05                	je     1a19 <concreate+0x1b9>
    1a14:	83 f8 01             	cmp    $0x1,%eax
    1a17:	74 6c                	je     1a85 <concreate+0x225>
      unlink(file);
    1a19:	83 ec 0c             	sub    $0xc,%esp
    1a1c:	53                   	push   %ebx
    1a1d:	e8 c1 1f 00 00       	call   39e3 <unlink>
      unlink(file);
    1a22:	89 1c 24             	mov    %ebx,(%esp)
    1a25:	e8 b9 1f 00 00       	call   39e3 <unlink>
      unlink(file);
    1a2a:	89 1c 24             	mov    %ebx,(%esp)
    1a2d:	e8 b1 1f 00 00       	call   39e3 <unlink>
      unlink(file);
    1a32:	89 1c 24             	mov    %ebx,(%esp)
    1a35:	e8 a9 1f 00 00       	call   39e3 <unlink>
    1a3a:	83 c4 10             	add    $0x10,%esp
    if(pid == 0)
    1a3d:	85 ff                	test   %edi,%edi
    1a3f:	0f 84 fc fe ff ff    	je     1941 <concreate+0xe1>
      wait();
    1a45:	e8 51 1f 00 00       	call   399b <wait>
  for(i = 0; i < 40; i++){
    1a4a:	83 c6 01             	add    $0x1,%esi
    1a4d:	83 fe 28             	cmp    $0x28,%esi
    1a50:	0f 84 8a 00 00 00    	je     1ae0 <concreate+0x280>
    file[1] = '0' + i;
    1a56:	8d 46 30             	lea    0x30(%esi),%eax
    1a59:	88 45 ae             	mov    %al,-0x52(%ebp)
    pid = fork();
    1a5c:	e8 2a 1f 00 00       	call   398b <fork>
    1a61:	89 c7                	mov    %eax,%edi
    if(pid < 0){
    1a63:	85 c0                	test   %eax,%eax
    1a65:	0f 88 8c 00 00 00    	js     1af7 <concreate+0x297>
    if(((i % 3) == 0 && pid == 0) ||
    1a6b:	b8 ab aa aa aa       	mov    $0xaaaaaaab,%eax
    1a70:	f7 e6                	mul    %esi
    1a72:	89 d0                	mov    %edx,%eax
    1a74:	83 e2 fe             	and    $0xfffffffe,%edx
    1a77:	d1 e8                	shr    %eax
    1a79:	01 c2                	add    %eax,%edx
    1a7b:	89 f0                	mov    %esi,%eax
    1a7d:	29 d0                	sub    %edx,%eax
    1a7f:	89 c1                	mov    %eax,%ecx
    1a81:	09 f9                	or     %edi,%ecx
    1a83:	75 8b                	jne    1a10 <concreate+0x1b0>
      close(open(file, 0));
    1a85:	83 ec 08             	sub    $0x8,%esp
    1a88:	6a 00                	push   $0x0
    1a8a:	53                   	push   %ebx
    1a8b:	e8 43 1f 00 00       	call   39d3 <open>
    1a90:	89 04 24             	mov    %eax,(%esp)
    1a93:	e8 23 1f 00 00       	call   39bb <close>
      close(open(file, 0));
    1a98:	58                   	pop    %eax
    1a99:	5a                   	pop    %edx
    1a9a:	6a 00                	push   $0x0
    1a9c:	53                   	push   %ebx
    1a9d:	e8 31 1f 00 00       	call   39d3 <open>
    1aa2:	89 04 24             	mov    %eax,(%esp)
    1aa5:	e8 11 1f 00 00       	call   39bb <close>
      close(open(file, 0));
    1aaa:	59                   	pop    %ecx
    1aab:	58                   	pop    %eax
    1aac:	6a 00                	push   $0x0
    1aae:	53                   	push   %ebx
    1aaf:	e8 1f 1f 00 00       	call   39d3 <open>
    1ab4:	89 04 24             	mov    %eax,(%esp)
    1ab7:	e8 ff 1e 00 00       	call   39bb <close>
      close(open(file, 0));
    1abc:	58                   	pop    %eax
    1abd:	5a                   	pop    %edx
    1abe:	6a 00                	push   $0x0
    1ac0:	53                   	push   %ebx
    1ac1:	e8 0d 1f 00 00       	call   39d3 <open>
    1ac6:	89 04 24             	mov    %eax,(%esp)
    1ac9:	e8 ed 1e 00 00       	call   39bb <close>
    1ace:	83 c4 10             	add    $0x10,%esp
    1ad1:	e9 67 ff ff ff       	jmp    1a3d <concreate+0x1dd>
    1ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1add:	8d 76 00             	lea    0x0(%esi),%esi
  printf(1, "concreate ok\n");
    1ae0:	83 ec 08             	sub    $0x8,%esp
    1ae3:	68 36 45 00 00       	push   $0x4536
    1ae8:	6a 01                	push   $0x1
    1aea:	e8 11 20 00 00       	call   3b00 <printf>
}
    1aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1af2:	5b                   	pop    %ebx
    1af3:	5e                   	pop    %esi
    1af4:	5f                   	pop    %edi
    1af5:	5d                   	pop    %ebp
    1af6:	c3                   	ret    
      printf(1, "fork failed\n");
    1af7:	83 ec 08             	sub    $0x8,%esp
    1afa:	68 b9 4d 00 00       	push   $0x4db9
    1aff:	6a 01                	push   $0x1
    1b01:	e8 fa 1f 00 00       	call   3b00 <printf>
      exit();
    1b06:	e8 88 1e 00 00       	call   3993 <exit>
    printf(1, "concreate not enough files in directory listing\n");
    1b0b:	51                   	push   %ecx
    1b0c:	51                   	push   %ecx
    1b0d:	68 80 50 00 00       	push   $0x5080
    1b12:	6a 01                	push   $0x1
    1b14:	e8 e7 1f 00 00       	call   3b00 <printf>
    exit();
    1b19:	e8 75 1e 00 00       	call   3993 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    1b1e:	83 ec 04             	sub    $0x4,%esp
    1b21:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1b24:	50                   	push   %eax
    1b25:	68 19 45 00 00       	push   $0x4519
    1b2a:	6a 01                	push   $0x1
    1b2c:	e8 cf 1f 00 00       	call   3b00 <printf>
        exit();
    1b31:	e8 5d 1e 00 00       	call   3993 <exit>
        printf(1, "concreate weird file %s\n", de.name);
    1b36:	83 ec 04             	sub    $0x4,%esp
    1b39:	8d 45 b2             	lea    -0x4e(%ebp),%eax
    1b3c:	50                   	push   %eax
    1b3d:	68 00 45 00 00       	push   $0x4500
    1b42:	6a 01                	push   $0x1
    1b44:	e8 b7 1f 00 00       	call   3b00 <printf>
        exit();
    1b49:	e8 45 1e 00 00       	call   3993 <exit>
      close(fd);
    1b4e:	83 ec 0c             	sub    $0xc,%esp
    1b51:	50                   	push   %eax
    1b52:	e8 64 1e 00 00       	call   39bb <close>
    1b57:	83 c4 10             	add    $0x10,%esp
    1b5a:	e9 e2 fd ff ff       	jmp    1941 <concreate+0xe1>
    1b5f:	90                   	nop

00001b60 <linkunlink>:
{
    1b60:	f3 0f 1e fb          	endbr32 
    1b64:	55                   	push   %ebp
    1b65:	89 e5                	mov    %esp,%ebp
    1b67:	57                   	push   %edi
    1b68:	56                   	push   %esi
    1b69:	53                   	push   %ebx
    1b6a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "linkunlink test\n");
    1b6d:	68 44 45 00 00       	push   $0x4544
    1b72:	6a 01                	push   $0x1
    1b74:	e8 87 1f 00 00       	call   3b00 <printf>
  unlink("x");
    1b79:	c7 04 24 d1 47 00 00 	movl   $0x47d1,(%esp)
    1b80:	e8 5e 1e 00 00       	call   39e3 <unlink>
  pid = fork();
    1b85:	e8 01 1e 00 00       	call   398b <fork>
  if(pid < 0){
    1b8a:	83 c4 10             	add    $0x10,%esp
  pid = fork();
    1b8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pid < 0){
    1b90:	85 c0                	test   %eax,%eax
    1b92:	0f 88 b2 00 00 00    	js     1c4a <linkunlink+0xea>
  unsigned int x = (pid ? 1 : 97);
    1b98:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
    1b9c:	bb 64 00 00 00       	mov    $0x64,%ebx
    if((x % 3) == 0){
    1ba1:	be ab aa aa aa       	mov    $0xaaaaaaab,%esi
  unsigned int x = (pid ? 1 : 97);
    1ba6:	19 ff                	sbb    %edi,%edi
    1ba8:	83 e7 60             	and    $0x60,%edi
    1bab:	83 c7 01             	add    $0x1,%edi
    1bae:	eb 1a                	jmp    1bca <linkunlink+0x6a>
    } else if((x % 3) == 1){
    1bb0:	83 f8 01             	cmp    $0x1,%eax
    1bb3:	74 7b                	je     1c30 <linkunlink+0xd0>
      unlink("x");
    1bb5:	83 ec 0c             	sub    $0xc,%esp
    1bb8:	68 d1 47 00 00       	push   $0x47d1
    1bbd:	e8 21 1e 00 00       	call   39e3 <unlink>
    1bc2:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1bc5:	83 eb 01             	sub    $0x1,%ebx
    1bc8:	74 41                	je     1c0b <linkunlink+0xab>
    x = x * 1103515245 + 12345;
    1bca:	69 cf 6d 4e c6 41    	imul   $0x41c64e6d,%edi,%ecx
    1bd0:	8d b9 39 30 00 00    	lea    0x3039(%ecx),%edi
    if((x % 3) == 0){
    1bd6:	89 f8                	mov    %edi,%eax
    1bd8:	f7 e6                	mul    %esi
    1bda:	89 d0                	mov    %edx,%eax
    1bdc:	83 e2 fe             	and    $0xfffffffe,%edx
    1bdf:	d1 e8                	shr    %eax
    1be1:	01 c2                	add    %eax,%edx
    1be3:	89 f8                	mov    %edi,%eax
    1be5:	29 d0                	sub    %edx,%eax
    1be7:	75 c7                	jne    1bb0 <linkunlink+0x50>
      close(open("x", O_RDWR | O_CREATE));
    1be9:	83 ec 08             	sub    $0x8,%esp
    1bec:	68 02 02 00 00       	push   $0x202
    1bf1:	68 d1 47 00 00       	push   $0x47d1
    1bf6:	e8 d8 1d 00 00       	call   39d3 <open>
    1bfb:	89 04 24             	mov    %eax,(%esp)
    1bfe:	e8 b8 1d 00 00       	call   39bb <close>
    1c03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1c06:	83 eb 01             	sub    $0x1,%ebx
    1c09:	75 bf                	jne    1bca <linkunlink+0x6a>
  if(pid)
    1c0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1c0e:	85 c0                	test   %eax,%eax
    1c10:	74 4b                	je     1c5d <linkunlink+0xfd>
    wait();
    1c12:	e8 84 1d 00 00       	call   399b <wait>
  printf(1, "linkunlink ok\n");
    1c17:	83 ec 08             	sub    $0x8,%esp
    1c1a:	68 59 45 00 00       	push   $0x4559
    1c1f:	6a 01                	push   $0x1
    1c21:	e8 da 1e 00 00       	call   3b00 <printf>
}
    1c26:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1c29:	5b                   	pop    %ebx
    1c2a:	5e                   	pop    %esi
    1c2b:	5f                   	pop    %edi
    1c2c:	5d                   	pop    %ebp
    1c2d:	c3                   	ret    
    1c2e:	66 90                	xchg   %ax,%ax
      link("cat", "x");
    1c30:	83 ec 08             	sub    $0x8,%esp
    1c33:	68 d1 47 00 00       	push   $0x47d1
    1c38:	68 55 45 00 00       	push   $0x4555
    1c3d:	e8 b1 1d 00 00       	call   39f3 <link>
    1c42:	83 c4 10             	add    $0x10,%esp
    1c45:	e9 7b ff ff ff       	jmp    1bc5 <linkunlink+0x65>
    printf(1, "fork failed\n");
    1c4a:	52                   	push   %edx
    1c4b:	52                   	push   %edx
    1c4c:	68 b9 4d 00 00       	push   $0x4db9
    1c51:	6a 01                	push   $0x1
    1c53:	e8 a8 1e 00 00       	call   3b00 <printf>
    exit();
    1c58:	e8 36 1d 00 00       	call   3993 <exit>
    exit();
    1c5d:	e8 31 1d 00 00       	call   3993 <exit>
    1c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001c70 <bigdir>:
{
    1c70:	f3 0f 1e fb          	endbr32 
    1c74:	55                   	push   %ebp
    1c75:	89 e5                	mov    %esp,%ebp
    1c77:	57                   	push   %edi
    1c78:	56                   	push   %esi
    1c79:	53                   	push   %ebx
    1c7a:	83 ec 24             	sub    $0x24,%esp
  printf(1, "bigdir test\n");
    1c7d:	68 68 45 00 00       	push   $0x4568
    1c82:	6a 01                	push   $0x1
    1c84:	e8 77 1e 00 00       	call   3b00 <printf>
  unlink("bd");
    1c89:	c7 04 24 75 45 00 00 	movl   $0x4575,(%esp)
    1c90:	e8 4e 1d 00 00       	call   39e3 <unlink>
  fd = open("bd", O_CREATE);
    1c95:	5a                   	pop    %edx
    1c96:	59                   	pop    %ecx
    1c97:	68 00 02 00 00       	push   $0x200
    1c9c:	68 75 45 00 00       	push   $0x4575
    1ca1:	e8 2d 1d 00 00       	call   39d3 <open>
  if(fd < 0){
    1ca6:	83 c4 10             	add    $0x10,%esp
    1ca9:	85 c0                	test   %eax,%eax
    1cab:	0f 88 ea 00 00 00    	js     1d9b <bigdir+0x12b>
  close(fd);
    1cb1:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < 500; i++){
    1cb4:	31 f6                	xor    %esi,%esi
    1cb6:	8d 7d de             	lea    -0x22(%ebp),%edi
  close(fd);
    1cb9:	50                   	push   %eax
    1cba:	e8 fc 1c 00 00       	call   39bb <close>
    1cbf:	83 c4 10             	add    $0x10,%esp
    1cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    name[1] = '0' + (i / 64);
    1cc8:	89 f0                	mov    %esi,%eax
    if(link("bd", name) != 0){
    1cca:	83 ec 08             	sub    $0x8,%esp
    name[0] = 'x';
    1ccd:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1cd1:	c1 f8 06             	sar    $0x6,%eax
    if(link("bd", name) != 0){
    1cd4:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1cd5:	83 c0 30             	add    $0x30,%eax
    if(link("bd", name) != 0){
    1cd8:	68 75 45 00 00       	push   $0x4575
    name[1] = '0' + (i / 64);
    1cdd:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1ce0:	89 f0                	mov    %esi,%eax
    1ce2:	83 e0 3f             	and    $0x3f,%eax
    name[3] = '\0';
    1ce5:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[2] = '0' + (i % 64);
    1ce9:	83 c0 30             	add    $0x30,%eax
    1cec:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(link("bd", name) != 0){
    1cef:	e8 ff 1c 00 00       	call   39f3 <link>
    1cf4:	83 c4 10             	add    $0x10,%esp
    1cf7:	89 c3                	mov    %eax,%ebx
    1cf9:	85 c0                	test   %eax,%eax
    1cfb:	75 76                	jne    1d73 <bigdir+0x103>
  for(i = 0; i < 500; i++){
    1cfd:	83 c6 01             	add    $0x1,%esi
    1d00:	81 fe f4 01 00 00    	cmp    $0x1f4,%esi
    1d06:	75 c0                	jne    1cc8 <bigdir+0x58>
  unlink("bd");
    1d08:	83 ec 0c             	sub    $0xc,%esp
    1d0b:	68 75 45 00 00       	push   $0x4575
    1d10:	e8 ce 1c 00 00       	call   39e3 <unlink>
    1d15:	83 c4 10             	add    $0x10,%esp
    1d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1d1f:	90                   	nop
    name[1] = '0' + (i / 64);
    1d20:	89 d8                	mov    %ebx,%eax
    if(unlink(name) != 0){
    1d22:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'x';
    1d25:	c6 45 de 78          	movb   $0x78,-0x22(%ebp)
    name[1] = '0' + (i / 64);
    1d29:	c1 f8 06             	sar    $0x6,%eax
    if(unlink(name) != 0){
    1d2c:	57                   	push   %edi
    name[1] = '0' + (i / 64);
    1d2d:	83 c0 30             	add    $0x30,%eax
    name[3] = '\0';
    1d30:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
    name[1] = '0' + (i / 64);
    1d34:	88 45 df             	mov    %al,-0x21(%ebp)
    name[2] = '0' + (i % 64);
    1d37:	89 d8                	mov    %ebx,%eax
    1d39:	83 e0 3f             	and    $0x3f,%eax
    1d3c:	83 c0 30             	add    $0x30,%eax
    1d3f:	88 45 e0             	mov    %al,-0x20(%ebp)
    if(unlink(name) != 0){
    1d42:	e8 9c 1c 00 00       	call   39e3 <unlink>
    1d47:	83 c4 10             	add    $0x10,%esp
    1d4a:	85 c0                	test   %eax,%eax
    1d4c:	75 39                	jne    1d87 <bigdir+0x117>
  for(i = 0; i < 500; i++){
    1d4e:	83 c3 01             	add    $0x1,%ebx
    1d51:	81 fb f4 01 00 00    	cmp    $0x1f4,%ebx
    1d57:	75 c7                	jne    1d20 <bigdir+0xb0>
  printf(1, "bigdir ok\n");
    1d59:	83 ec 08             	sub    $0x8,%esp
    1d5c:	68 b7 45 00 00       	push   $0x45b7
    1d61:	6a 01                	push   $0x1
    1d63:	e8 98 1d 00 00       	call   3b00 <printf>
    1d68:	83 c4 10             	add    $0x10,%esp
}
    1d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1d6e:	5b                   	pop    %ebx
    1d6f:	5e                   	pop    %esi
    1d70:	5f                   	pop    %edi
    1d71:	5d                   	pop    %ebp
    1d72:	c3                   	ret    
      printf(1, "bigdir link failed\n");
    1d73:	83 ec 08             	sub    $0x8,%esp
    1d76:	68 8e 45 00 00       	push   $0x458e
    1d7b:	6a 01                	push   $0x1
    1d7d:	e8 7e 1d 00 00       	call   3b00 <printf>
      exit();
    1d82:	e8 0c 1c 00 00       	call   3993 <exit>
      printf(1, "bigdir unlink failed");
    1d87:	83 ec 08             	sub    $0x8,%esp
    1d8a:	68 a2 45 00 00       	push   $0x45a2
    1d8f:	6a 01                	push   $0x1
    1d91:	e8 6a 1d 00 00       	call   3b00 <printf>
      exit();
    1d96:	e8 f8 1b 00 00       	call   3993 <exit>
    printf(1, "bigdir create failed\n");
    1d9b:	50                   	push   %eax
    1d9c:	50                   	push   %eax
    1d9d:	68 78 45 00 00       	push   $0x4578
    1da2:	6a 01                	push   $0x1
    1da4:	e8 57 1d 00 00       	call   3b00 <printf>
    exit();
    1da9:	e8 e5 1b 00 00       	call   3993 <exit>
    1dae:	66 90                	xchg   %ax,%ax

00001db0 <subdir>:
{
    1db0:	f3 0f 1e fb          	endbr32 
    1db4:	55                   	push   %ebp
    1db5:	89 e5                	mov    %esp,%ebp
    1db7:	53                   	push   %ebx
    1db8:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "subdir test\n");
    1dbb:	68 c2 45 00 00       	push   $0x45c2
    1dc0:	6a 01                	push   $0x1
    1dc2:	e8 39 1d 00 00       	call   3b00 <printf>
  unlink("ff");
    1dc7:	c7 04 24 4b 46 00 00 	movl   $0x464b,(%esp)
    1dce:	e8 10 1c 00 00       	call   39e3 <unlink>
  if(mkdir("dd") != 0){
    1dd3:	c7 04 24 e8 46 00 00 	movl   $0x46e8,(%esp)
    1dda:	e8 1c 1c 00 00       	call   39fb <mkdir>
    1ddf:	83 c4 10             	add    $0x10,%esp
    1de2:	85 c0                	test   %eax,%eax
    1de4:	0f 85 b3 05 00 00    	jne    239d <subdir+0x5ed>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1dea:	83 ec 08             	sub    $0x8,%esp
    1ded:	68 02 02 00 00       	push   $0x202
    1df2:	68 21 46 00 00       	push   $0x4621
    1df7:	e8 d7 1b 00 00       	call   39d3 <open>
  if(fd < 0){
    1dfc:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/ff", O_CREATE | O_RDWR);
    1dff:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e01:	85 c0                	test   %eax,%eax
    1e03:	0f 88 81 05 00 00    	js     238a <subdir+0x5da>
  write(fd, "ff", 2);
    1e09:	83 ec 04             	sub    $0x4,%esp
    1e0c:	6a 02                	push   $0x2
    1e0e:	68 4b 46 00 00       	push   $0x464b
    1e13:	50                   	push   %eax
    1e14:	e8 9a 1b 00 00       	call   39b3 <write>
  close(fd);
    1e19:	89 1c 24             	mov    %ebx,(%esp)
    1e1c:	e8 9a 1b 00 00       	call   39bb <close>
  if(unlink("dd") >= 0){
    1e21:	c7 04 24 e8 46 00 00 	movl   $0x46e8,(%esp)
    1e28:	e8 b6 1b 00 00       	call   39e3 <unlink>
    1e2d:	83 c4 10             	add    $0x10,%esp
    1e30:	85 c0                	test   %eax,%eax
    1e32:	0f 89 3f 05 00 00    	jns    2377 <subdir+0x5c7>
  if(mkdir("/dd/dd") != 0){
    1e38:	83 ec 0c             	sub    $0xc,%esp
    1e3b:	68 fc 45 00 00       	push   $0x45fc
    1e40:	e8 b6 1b 00 00       	call   39fb <mkdir>
    1e45:	83 c4 10             	add    $0x10,%esp
    1e48:	85 c0                	test   %eax,%eax
    1e4a:	0f 85 14 05 00 00    	jne    2364 <subdir+0x5b4>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e50:	83 ec 08             	sub    $0x8,%esp
    1e53:	68 02 02 00 00       	push   $0x202
    1e58:	68 1e 46 00 00       	push   $0x461e
    1e5d:	e8 71 1b 00 00       	call   39d3 <open>
  if(fd < 0){
    1e62:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1e65:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e67:	85 c0                	test   %eax,%eax
    1e69:	0f 88 24 04 00 00    	js     2293 <subdir+0x4e3>
  write(fd, "FF", 2);
    1e6f:	83 ec 04             	sub    $0x4,%esp
    1e72:	6a 02                	push   $0x2
    1e74:	68 3f 46 00 00       	push   $0x463f
    1e79:	50                   	push   %eax
    1e7a:	e8 34 1b 00 00       	call   39b3 <write>
  close(fd);
    1e7f:	89 1c 24             	mov    %ebx,(%esp)
    1e82:	e8 34 1b 00 00       	call   39bb <close>
  fd = open("dd/dd/../ff", 0);
    1e87:	58                   	pop    %eax
    1e88:	5a                   	pop    %edx
    1e89:	6a 00                	push   $0x0
    1e8b:	68 42 46 00 00       	push   $0x4642
    1e90:	e8 3e 1b 00 00       	call   39d3 <open>
  if(fd < 0){
    1e95:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/../ff", 0);
    1e98:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1e9a:	85 c0                	test   %eax,%eax
    1e9c:	0f 88 de 03 00 00    	js     2280 <subdir+0x4d0>
  cc = read(fd, buf, sizeof(buf));
    1ea2:	83 ec 04             	sub    $0x4,%esp
    1ea5:	68 00 20 00 00       	push   $0x2000
    1eaa:	68 00 87 00 00       	push   $0x8700
    1eaf:	50                   	push   %eax
    1eb0:	e8 f6 1a 00 00       	call   39ab <read>
  if(cc != 2 || buf[0] != 'f'){
    1eb5:	83 c4 10             	add    $0x10,%esp
    1eb8:	83 f8 02             	cmp    $0x2,%eax
    1ebb:	0f 85 3a 03 00 00    	jne    21fb <subdir+0x44b>
    1ec1:	80 3d 00 87 00 00 66 	cmpb   $0x66,0x8700
    1ec8:	0f 85 2d 03 00 00    	jne    21fb <subdir+0x44b>
  close(fd);
    1ece:	83 ec 0c             	sub    $0xc,%esp
    1ed1:	53                   	push   %ebx
    1ed2:	e8 e4 1a 00 00       	call   39bb <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1ed7:	59                   	pop    %ecx
    1ed8:	5b                   	pop    %ebx
    1ed9:	68 82 46 00 00       	push   $0x4682
    1ede:	68 1e 46 00 00       	push   $0x461e
    1ee3:	e8 0b 1b 00 00       	call   39f3 <link>
    1ee8:	83 c4 10             	add    $0x10,%esp
    1eeb:	85 c0                	test   %eax,%eax
    1eed:	0f 85 c6 03 00 00    	jne    22b9 <subdir+0x509>
  if(unlink("dd/dd/ff") != 0){
    1ef3:	83 ec 0c             	sub    $0xc,%esp
    1ef6:	68 1e 46 00 00       	push   $0x461e
    1efb:	e8 e3 1a 00 00       	call   39e3 <unlink>
    1f00:	83 c4 10             	add    $0x10,%esp
    1f03:	85 c0                	test   %eax,%eax
    1f05:	0f 85 16 03 00 00    	jne    2221 <subdir+0x471>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1f0b:	83 ec 08             	sub    $0x8,%esp
    1f0e:	6a 00                	push   $0x0
    1f10:	68 1e 46 00 00       	push   $0x461e
    1f15:	e8 b9 1a 00 00       	call   39d3 <open>
    1f1a:	83 c4 10             	add    $0x10,%esp
    1f1d:	85 c0                	test   %eax,%eax
    1f1f:	0f 89 2c 04 00 00    	jns    2351 <subdir+0x5a1>
  if(chdir("dd") != 0){
    1f25:	83 ec 0c             	sub    $0xc,%esp
    1f28:	68 e8 46 00 00       	push   $0x46e8
    1f2d:	e8 d1 1a 00 00       	call   3a03 <chdir>
    1f32:	83 c4 10             	add    $0x10,%esp
    1f35:	85 c0                	test   %eax,%eax
    1f37:	0f 85 01 04 00 00    	jne    233e <subdir+0x58e>
  if(chdir("dd/../../dd") != 0){
    1f3d:	83 ec 0c             	sub    $0xc,%esp
    1f40:	68 b6 46 00 00       	push   $0x46b6
    1f45:	e8 b9 1a 00 00       	call   3a03 <chdir>
    1f4a:	83 c4 10             	add    $0x10,%esp
    1f4d:	85 c0                	test   %eax,%eax
    1f4f:	0f 85 b9 02 00 00    	jne    220e <subdir+0x45e>
  if(chdir("dd/../../../dd") != 0){
    1f55:	83 ec 0c             	sub    $0xc,%esp
    1f58:	68 dc 46 00 00       	push   $0x46dc
    1f5d:	e8 a1 1a 00 00       	call   3a03 <chdir>
    1f62:	83 c4 10             	add    $0x10,%esp
    1f65:	85 c0                	test   %eax,%eax
    1f67:	0f 85 a1 02 00 00    	jne    220e <subdir+0x45e>
  if(chdir("./..") != 0){
    1f6d:	83 ec 0c             	sub    $0xc,%esp
    1f70:	68 eb 46 00 00       	push   $0x46eb
    1f75:	e8 89 1a 00 00       	call   3a03 <chdir>
    1f7a:	83 c4 10             	add    $0x10,%esp
    1f7d:	85 c0                	test   %eax,%eax
    1f7f:	0f 85 21 03 00 00    	jne    22a6 <subdir+0x4f6>
  fd = open("dd/dd/ffff", 0);
    1f85:	83 ec 08             	sub    $0x8,%esp
    1f88:	6a 00                	push   $0x0
    1f8a:	68 82 46 00 00       	push   $0x4682
    1f8f:	e8 3f 1a 00 00       	call   39d3 <open>
  if(fd < 0){
    1f94:	83 c4 10             	add    $0x10,%esp
  fd = open("dd/dd/ffff", 0);
    1f97:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1f99:	85 c0                	test   %eax,%eax
    1f9b:	0f 88 e0 04 00 00    	js     2481 <subdir+0x6d1>
  if(read(fd, buf, sizeof(buf)) != 2){
    1fa1:	83 ec 04             	sub    $0x4,%esp
    1fa4:	68 00 20 00 00       	push   $0x2000
    1fa9:	68 00 87 00 00       	push   $0x8700
    1fae:	50                   	push   %eax
    1faf:	e8 f7 19 00 00       	call   39ab <read>
    1fb4:	83 c4 10             	add    $0x10,%esp
    1fb7:	83 f8 02             	cmp    $0x2,%eax
    1fba:	0f 85 ae 04 00 00    	jne    246e <subdir+0x6be>
  close(fd);
    1fc0:	83 ec 0c             	sub    $0xc,%esp
    1fc3:	53                   	push   %ebx
    1fc4:	e8 f2 19 00 00       	call   39bb <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1fc9:	58                   	pop    %eax
    1fca:	5a                   	pop    %edx
    1fcb:	6a 00                	push   $0x0
    1fcd:	68 1e 46 00 00       	push   $0x461e
    1fd2:	e8 fc 19 00 00       	call   39d3 <open>
    1fd7:	83 c4 10             	add    $0x10,%esp
    1fda:	85 c0                	test   %eax,%eax
    1fdc:	0f 89 65 02 00 00    	jns    2247 <subdir+0x497>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1fe2:	83 ec 08             	sub    $0x8,%esp
    1fe5:	68 02 02 00 00       	push   $0x202
    1fea:	68 36 47 00 00       	push   $0x4736
    1fef:	e8 df 19 00 00       	call   39d3 <open>
    1ff4:	83 c4 10             	add    $0x10,%esp
    1ff7:	85 c0                	test   %eax,%eax
    1ff9:	0f 89 35 02 00 00    	jns    2234 <subdir+0x484>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1fff:	83 ec 08             	sub    $0x8,%esp
    2002:	68 02 02 00 00       	push   $0x202
    2007:	68 5b 47 00 00       	push   $0x475b
    200c:	e8 c2 19 00 00       	call   39d3 <open>
    2011:	83 c4 10             	add    $0x10,%esp
    2014:	85 c0                	test   %eax,%eax
    2016:	0f 89 0f 03 00 00    	jns    232b <subdir+0x57b>
  if(open("dd", O_CREATE) >= 0){
    201c:	83 ec 08             	sub    $0x8,%esp
    201f:	68 00 02 00 00       	push   $0x200
    2024:	68 e8 46 00 00       	push   $0x46e8
    2029:	e8 a5 19 00 00       	call   39d3 <open>
    202e:	83 c4 10             	add    $0x10,%esp
    2031:	85 c0                	test   %eax,%eax
    2033:	0f 89 df 02 00 00    	jns    2318 <subdir+0x568>
  if(open("dd", O_RDWR) >= 0){
    2039:	83 ec 08             	sub    $0x8,%esp
    203c:	6a 02                	push   $0x2
    203e:	68 e8 46 00 00       	push   $0x46e8
    2043:	e8 8b 19 00 00       	call   39d3 <open>
    2048:	83 c4 10             	add    $0x10,%esp
    204b:	85 c0                	test   %eax,%eax
    204d:	0f 89 b2 02 00 00    	jns    2305 <subdir+0x555>
  if(open("dd", O_WRONLY) >= 0){
    2053:	83 ec 08             	sub    $0x8,%esp
    2056:	6a 01                	push   $0x1
    2058:	68 e8 46 00 00       	push   $0x46e8
    205d:	e8 71 19 00 00       	call   39d3 <open>
    2062:	83 c4 10             	add    $0x10,%esp
    2065:	85 c0                	test   %eax,%eax
    2067:	0f 89 85 02 00 00    	jns    22f2 <subdir+0x542>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    206d:	83 ec 08             	sub    $0x8,%esp
    2070:	68 ca 47 00 00       	push   $0x47ca
    2075:	68 36 47 00 00       	push   $0x4736
    207a:	e8 74 19 00 00       	call   39f3 <link>
    207f:	83 c4 10             	add    $0x10,%esp
    2082:	85 c0                	test   %eax,%eax
    2084:	0f 84 55 02 00 00    	je     22df <subdir+0x52f>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    208a:	83 ec 08             	sub    $0x8,%esp
    208d:	68 ca 47 00 00       	push   $0x47ca
    2092:	68 5b 47 00 00       	push   $0x475b
    2097:	e8 57 19 00 00       	call   39f3 <link>
    209c:	83 c4 10             	add    $0x10,%esp
    209f:	85 c0                	test   %eax,%eax
    20a1:	0f 84 25 02 00 00    	je     22cc <subdir+0x51c>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    20a7:	83 ec 08             	sub    $0x8,%esp
    20aa:	68 82 46 00 00       	push   $0x4682
    20af:	68 21 46 00 00       	push   $0x4621
    20b4:	e8 3a 19 00 00       	call   39f3 <link>
    20b9:	83 c4 10             	add    $0x10,%esp
    20bc:	85 c0                	test   %eax,%eax
    20be:	0f 84 a9 01 00 00    	je     226d <subdir+0x4bd>
  if(mkdir("dd/ff/ff") == 0){
    20c4:	83 ec 0c             	sub    $0xc,%esp
    20c7:	68 36 47 00 00       	push   $0x4736
    20cc:	e8 2a 19 00 00       	call   39fb <mkdir>
    20d1:	83 c4 10             	add    $0x10,%esp
    20d4:	85 c0                	test   %eax,%eax
    20d6:	0f 84 7e 01 00 00    	je     225a <subdir+0x4aa>
  if(mkdir("dd/xx/ff") == 0){
    20dc:	83 ec 0c             	sub    $0xc,%esp
    20df:	68 5b 47 00 00       	push   $0x475b
    20e4:	e8 12 19 00 00       	call   39fb <mkdir>
    20e9:	83 c4 10             	add    $0x10,%esp
    20ec:	85 c0                	test   %eax,%eax
    20ee:	0f 84 67 03 00 00    	je     245b <subdir+0x6ab>
  if(mkdir("dd/dd/ffff") == 0){
    20f4:	83 ec 0c             	sub    $0xc,%esp
    20f7:	68 82 46 00 00       	push   $0x4682
    20fc:	e8 fa 18 00 00       	call   39fb <mkdir>
    2101:	83 c4 10             	add    $0x10,%esp
    2104:	85 c0                	test   %eax,%eax
    2106:	0f 84 3c 03 00 00    	je     2448 <subdir+0x698>
  if(unlink("dd/xx/ff") == 0){
    210c:	83 ec 0c             	sub    $0xc,%esp
    210f:	68 5b 47 00 00       	push   $0x475b
    2114:	e8 ca 18 00 00       	call   39e3 <unlink>
    2119:	83 c4 10             	add    $0x10,%esp
    211c:	85 c0                	test   %eax,%eax
    211e:	0f 84 11 03 00 00    	je     2435 <subdir+0x685>
  if(unlink("dd/ff/ff") == 0){
    2124:	83 ec 0c             	sub    $0xc,%esp
    2127:	68 36 47 00 00       	push   $0x4736
    212c:	e8 b2 18 00 00       	call   39e3 <unlink>
    2131:	83 c4 10             	add    $0x10,%esp
    2134:	85 c0                	test   %eax,%eax
    2136:	0f 84 e6 02 00 00    	je     2422 <subdir+0x672>
  if(chdir("dd/ff") == 0){
    213c:	83 ec 0c             	sub    $0xc,%esp
    213f:	68 21 46 00 00       	push   $0x4621
    2144:	e8 ba 18 00 00       	call   3a03 <chdir>
    2149:	83 c4 10             	add    $0x10,%esp
    214c:	85 c0                	test   %eax,%eax
    214e:	0f 84 bb 02 00 00    	je     240f <subdir+0x65f>
  if(chdir("dd/xx") == 0){
    2154:	83 ec 0c             	sub    $0xc,%esp
    2157:	68 cd 47 00 00       	push   $0x47cd
    215c:	e8 a2 18 00 00       	call   3a03 <chdir>
    2161:	83 c4 10             	add    $0x10,%esp
    2164:	85 c0                	test   %eax,%eax
    2166:	0f 84 90 02 00 00    	je     23fc <subdir+0x64c>
  if(unlink("dd/dd/ffff") != 0){
    216c:	83 ec 0c             	sub    $0xc,%esp
    216f:	68 82 46 00 00       	push   $0x4682
    2174:	e8 6a 18 00 00       	call   39e3 <unlink>
    2179:	83 c4 10             	add    $0x10,%esp
    217c:	85 c0                	test   %eax,%eax
    217e:	0f 85 9d 00 00 00    	jne    2221 <subdir+0x471>
  if(unlink("dd/ff") != 0){
    2184:	83 ec 0c             	sub    $0xc,%esp
    2187:	68 21 46 00 00       	push   $0x4621
    218c:	e8 52 18 00 00       	call   39e3 <unlink>
    2191:	83 c4 10             	add    $0x10,%esp
    2194:	85 c0                	test   %eax,%eax
    2196:	0f 85 4d 02 00 00    	jne    23e9 <subdir+0x639>
  if(unlink("dd") == 0){
    219c:	83 ec 0c             	sub    $0xc,%esp
    219f:	68 e8 46 00 00       	push   $0x46e8
    21a4:	e8 3a 18 00 00       	call   39e3 <unlink>
    21a9:	83 c4 10             	add    $0x10,%esp
    21ac:	85 c0                	test   %eax,%eax
    21ae:	0f 84 22 02 00 00    	je     23d6 <subdir+0x626>
  if(unlink("dd/dd") < 0){
    21b4:	83 ec 0c             	sub    $0xc,%esp
    21b7:	68 fd 45 00 00       	push   $0x45fd
    21bc:	e8 22 18 00 00       	call   39e3 <unlink>
    21c1:	83 c4 10             	add    $0x10,%esp
    21c4:	85 c0                	test   %eax,%eax
    21c6:	0f 88 f7 01 00 00    	js     23c3 <subdir+0x613>
  if(unlink("dd") < 0){
    21cc:	83 ec 0c             	sub    $0xc,%esp
    21cf:	68 e8 46 00 00       	push   $0x46e8
    21d4:	e8 0a 18 00 00       	call   39e3 <unlink>
    21d9:	83 c4 10             	add    $0x10,%esp
    21dc:	85 c0                	test   %eax,%eax
    21de:	0f 88 cc 01 00 00    	js     23b0 <subdir+0x600>
  printf(1, "subdir ok\n");
    21e4:	83 ec 08             	sub    $0x8,%esp
    21e7:	68 ca 48 00 00       	push   $0x48ca
    21ec:	6a 01                	push   $0x1
    21ee:	e8 0d 19 00 00       	call   3b00 <printf>
}
    21f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    21f6:	83 c4 10             	add    $0x10,%esp
    21f9:	c9                   	leave  
    21fa:	c3                   	ret    
    printf(1, "dd/dd/../ff wrong content\n");
    21fb:	50                   	push   %eax
    21fc:	50                   	push   %eax
    21fd:	68 67 46 00 00       	push   $0x4667
    2202:	6a 01                	push   $0x1
    2204:	e8 f7 18 00 00       	call   3b00 <printf>
    exit();
    2209:	e8 85 17 00 00       	call   3993 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    220e:	50                   	push   %eax
    220f:	50                   	push   %eax
    2210:	68 c2 46 00 00       	push   $0x46c2
    2215:	6a 01                	push   $0x1
    2217:	e8 e4 18 00 00       	call   3b00 <printf>
    exit();
    221c:	e8 72 17 00 00       	call   3993 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2221:	50                   	push   %eax
    2222:	50                   	push   %eax
    2223:	68 8d 46 00 00       	push   $0x468d
    2228:	6a 01                	push   $0x1
    222a:	e8 d1 18 00 00       	call   3b00 <printf>
    exit();
    222f:	e8 5f 17 00 00       	call   3993 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    2234:	51                   	push   %ecx
    2235:	51                   	push   %ecx
    2236:	68 3f 47 00 00       	push   $0x473f
    223b:	6a 01                	push   $0x1
    223d:	e8 be 18 00 00       	call   3b00 <printf>
    exit();
    2242:	e8 4c 17 00 00       	call   3993 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    2247:	53                   	push   %ebx
    2248:	53                   	push   %ebx
    2249:	68 24 51 00 00       	push   $0x5124
    224e:	6a 01                	push   $0x1
    2250:	e8 ab 18 00 00       	call   3b00 <printf>
    exit();
    2255:	e8 39 17 00 00       	call   3993 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    225a:	51                   	push   %ecx
    225b:	51                   	push   %ecx
    225c:	68 d3 47 00 00       	push   $0x47d3
    2261:	6a 01                	push   $0x1
    2263:	e8 98 18 00 00       	call   3b00 <printf>
    exit();
    2268:	e8 26 17 00 00       	call   3993 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    226d:	53                   	push   %ebx
    226e:	53                   	push   %ebx
    226f:	68 94 51 00 00       	push   $0x5194
    2274:	6a 01                	push   $0x1
    2276:	e8 85 18 00 00       	call   3b00 <printf>
    exit();
    227b:	e8 13 17 00 00       	call   3993 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    2280:	50                   	push   %eax
    2281:	50                   	push   %eax
    2282:	68 4e 46 00 00       	push   $0x464e
    2287:	6a 01                	push   $0x1
    2289:	e8 72 18 00 00       	call   3b00 <printf>
    exit();
    228e:	e8 00 17 00 00       	call   3993 <exit>
    printf(1, "create dd/dd/ff failed\n");
    2293:	51                   	push   %ecx
    2294:	51                   	push   %ecx
    2295:	68 27 46 00 00       	push   $0x4627
    229a:	6a 01                	push   $0x1
    229c:	e8 5f 18 00 00       	call   3b00 <printf>
    exit();
    22a1:	e8 ed 16 00 00       	call   3993 <exit>
    printf(1, "chdir ./.. failed\n");
    22a6:	50                   	push   %eax
    22a7:	50                   	push   %eax
    22a8:	68 f0 46 00 00       	push   $0x46f0
    22ad:	6a 01                	push   $0x1
    22af:	e8 4c 18 00 00       	call   3b00 <printf>
    exit();
    22b4:	e8 da 16 00 00       	call   3993 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    22b9:	52                   	push   %edx
    22ba:	52                   	push   %edx
    22bb:	68 dc 50 00 00       	push   $0x50dc
    22c0:	6a 01                	push   $0x1
    22c2:	e8 39 18 00 00       	call   3b00 <printf>
    exit();
    22c7:	e8 c7 16 00 00       	call   3993 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    22cc:	50                   	push   %eax
    22cd:	50                   	push   %eax
    22ce:	68 70 51 00 00       	push   $0x5170
    22d3:	6a 01                	push   $0x1
    22d5:	e8 26 18 00 00       	call   3b00 <printf>
    exit();
    22da:	e8 b4 16 00 00       	call   3993 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    22df:	50                   	push   %eax
    22e0:	50                   	push   %eax
    22e1:	68 4c 51 00 00       	push   $0x514c
    22e6:	6a 01                	push   $0x1
    22e8:	e8 13 18 00 00       	call   3b00 <printf>
    exit();
    22ed:	e8 a1 16 00 00       	call   3993 <exit>
    printf(1, "open dd wronly succeeded!\n");
    22f2:	50                   	push   %eax
    22f3:	50                   	push   %eax
    22f4:	68 af 47 00 00       	push   $0x47af
    22f9:	6a 01                	push   $0x1
    22fb:	e8 00 18 00 00       	call   3b00 <printf>
    exit();
    2300:	e8 8e 16 00 00       	call   3993 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2305:	50                   	push   %eax
    2306:	50                   	push   %eax
    2307:	68 96 47 00 00       	push   $0x4796
    230c:	6a 01                	push   $0x1
    230e:	e8 ed 17 00 00       	call   3b00 <printf>
    exit();
    2313:	e8 7b 16 00 00       	call   3993 <exit>
    printf(1, "create dd succeeded!\n");
    2318:	50                   	push   %eax
    2319:	50                   	push   %eax
    231a:	68 80 47 00 00       	push   $0x4780
    231f:	6a 01                	push   $0x1
    2321:	e8 da 17 00 00       	call   3b00 <printf>
    exit();
    2326:	e8 68 16 00 00       	call   3993 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    232b:	52                   	push   %edx
    232c:	52                   	push   %edx
    232d:	68 64 47 00 00       	push   $0x4764
    2332:	6a 01                	push   $0x1
    2334:	e8 c7 17 00 00       	call   3b00 <printf>
    exit();
    2339:	e8 55 16 00 00       	call   3993 <exit>
    printf(1, "chdir dd failed\n");
    233e:	50                   	push   %eax
    233f:	50                   	push   %eax
    2340:	68 a5 46 00 00       	push   $0x46a5
    2345:	6a 01                	push   $0x1
    2347:	e8 b4 17 00 00       	call   3b00 <printf>
    exit();
    234c:	e8 42 16 00 00       	call   3993 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    2351:	50                   	push   %eax
    2352:	50                   	push   %eax
    2353:	68 00 51 00 00       	push   $0x5100
    2358:	6a 01                	push   $0x1
    235a:	e8 a1 17 00 00       	call   3b00 <printf>
    exit();
    235f:	e8 2f 16 00 00       	call   3993 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    2364:	53                   	push   %ebx
    2365:	53                   	push   %ebx
    2366:	68 03 46 00 00       	push   $0x4603
    236b:	6a 01                	push   $0x1
    236d:	e8 8e 17 00 00       	call   3b00 <printf>
    exit();
    2372:	e8 1c 16 00 00       	call   3993 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    2377:	50                   	push   %eax
    2378:	50                   	push   %eax
    2379:	68 b4 50 00 00       	push   $0x50b4
    237e:	6a 01                	push   $0x1
    2380:	e8 7b 17 00 00       	call   3b00 <printf>
    exit();
    2385:	e8 09 16 00 00       	call   3993 <exit>
    printf(1, "create dd/ff failed\n");
    238a:	50                   	push   %eax
    238b:	50                   	push   %eax
    238c:	68 e7 45 00 00       	push   $0x45e7
    2391:	6a 01                	push   $0x1
    2393:	e8 68 17 00 00       	call   3b00 <printf>
    exit();
    2398:	e8 f6 15 00 00       	call   3993 <exit>
    printf(1, "subdir mkdir dd failed\n");
    239d:	50                   	push   %eax
    239e:	50                   	push   %eax
    239f:	68 cf 45 00 00       	push   $0x45cf
    23a4:	6a 01                	push   $0x1
    23a6:	e8 55 17 00 00       	call   3b00 <printf>
    exit();
    23ab:	e8 e3 15 00 00       	call   3993 <exit>
    printf(1, "unlink dd failed\n");
    23b0:	50                   	push   %eax
    23b1:	50                   	push   %eax
    23b2:	68 b8 48 00 00       	push   $0x48b8
    23b7:	6a 01                	push   $0x1
    23b9:	e8 42 17 00 00       	call   3b00 <printf>
    exit();
    23be:	e8 d0 15 00 00       	call   3993 <exit>
    printf(1, "unlink dd/dd failed\n");
    23c3:	52                   	push   %edx
    23c4:	52                   	push   %edx
    23c5:	68 a3 48 00 00       	push   $0x48a3
    23ca:	6a 01                	push   $0x1
    23cc:	e8 2f 17 00 00       	call   3b00 <printf>
    exit();
    23d1:	e8 bd 15 00 00       	call   3993 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    23d6:	51                   	push   %ecx
    23d7:	51                   	push   %ecx
    23d8:	68 b8 51 00 00       	push   $0x51b8
    23dd:	6a 01                	push   $0x1
    23df:	e8 1c 17 00 00       	call   3b00 <printf>
    exit();
    23e4:	e8 aa 15 00 00       	call   3993 <exit>
    printf(1, "unlink dd/ff failed\n");
    23e9:	53                   	push   %ebx
    23ea:	53                   	push   %ebx
    23eb:	68 8e 48 00 00       	push   $0x488e
    23f0:	6a 01                	push   $0x1
    23f2:	e8 09 17 00 00       	call   3b00 <printf>
    exit();
    23f7:	e8 97 15 00 00       	call   3993 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    23fc:	50                   	push   %eax
    23fd:	50                   	push   %eax
    23fe:	68 76 48 00 00       	push   $0x4876
    2403:	6a 01                	push   $0x1
    2405:	e8 f6 16 00 00       	call   3b00 <printf>
    exit();
    240a:	e8 84 15 00 00       	call   3993 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    240f:	50                   	push   %eax
    2410:	50                   	push   %eax
    2411:	68 5e 48 00 00       	push   $0x485e
    2416:	6a 01                	push   $0x1
    2418:	e8 e3 16 00 00       	call   3b00 <printf>
    exit();
    241d:	e8 71 15 00 00       	call   3993 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    2422:	50                   	push   %eax
    2423:	50                   	push   %eax
    2424:	68 42 48 00 00       	push   $0x4842
    2429:	6a 01                	push   $0x1
    242b:	e8 d0 16 00 00       	call   3b00 <printf>
    exit();
    2430:	e8 5e 15 00 00       	call   3993 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    2435:	50                   	push   %eax
    2436:	50                   	push   %eax
    2437:	68 26 48 00 00       	push   $0x4826
    243c:	6a 01                	push   $0x1
    243e:	e8 bd 16 00 00       	call   3b00 <printf>
    exit();
    2443:	e8 4b 15 00 00       	call   3993 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    2448:	50                   	push   %eax
    2449:	50                   	push   %eax
    244a:	68 09 48 00 00       	push   $0x4809
    244f:	6a 01                	push   $0x1
    2451:	e8 aa 16 00 00       	call   3b00 <printf>
    exit();
    2456:	e8 38 15 00 00       	call   3993 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    245b:	52                   	push   %edx
    245c:	52                   	push   %edx
    245d:	68 ee 47 00 00       	push   $0x47ee
    2462:	6a 01                	push   $0x1
    2464:	e8 97 16 00 00       	call   3b00 <printf>
    exit();
    2469:	e8 25 15 00 00       	call   3993 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    246e:	51                   	push   %ecx
    246f:	51                   	push   %ecx
    2470:	68 1b 47 00 00       	push   $0x471b
    2475:	6a 01                	push   $0x1
    2477:	e8 84 16 00 00       	call   3b00 <printf>
    exit();
    247c:	e8 12 15 00 00       	call   3993 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    2481:	53                   	push   %ebx
    2482:	53                   	push   %ebx
    2483:	68 03 47 00 00       	push   $0x4703
    2488:	6a 01                	push   $0x1
    248a:	e8 71 16 00 00       	call   3b00 <printf>
    exit();
    248f:	e8 ff 14 00 00       	call   3993 <exit>
    2494:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    249b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    249f:	90                   	nop

000024a0 <bigwrite>:
{
    24a0:	f3 0f 1e fb          	endbr32 
    24a4:	55                   	push   %ebp
    24a5:	89 e5                	mov    %esp,%ebp
    24a7:	56                   	push   %esi
    24a8:	53                   	push   %ebx
  for(sz = 499; sz < 12*512; sz += 471){
    24a9:	bb f3 01 00 00       	mov    $0x1f3,%ebx
  printf(1, "bigwrite test\n");
    24ae:	83 ec 08             	sub    $0x8,%esp
    24b1:	68 d5 48 00 00       	push   $0x48d5
    24b6:	6a 01                	push   $0x1
    24b8:	e8 43 16 00 00       	call   3b00 <printf>
  unlink("bigwrite");
    24bd:	c7 04 24 e4 48 00 00 	movl   $0x48e4,(%esp)
    24c4:	e8 1a 15 00 00       	call   39e3 <unlink>
    24c9:	83 c4 10             	add    $0x10,%esp
    24cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    fd = open("bigwrite", O_CREATE | O_RDWR);
    24d0:	83 ec 08             	sub    $0x8,%esp
    24d3:	68 02 02 00 00       	push   $0x202
    24d8:	68 e4 48 00 00       	push   $0x48e4
    24dd:	e8 f1 14 00 00       	call   39d3 <open>
    if(fd < 0){
    24e2:	83 c4 10             	add    $0x10,%esp
    fd = open("bigwrite", O_CREATE | O_RDWR);
    24e5:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    24e7:	85 c0                	test   %eax,%eax
    24e9:	78 7e                	js     2569 <bigwrite+0xc9>
      int cc = write(fd, buf, sz);
    24eb:	83 ec 04             	sub    $0x4,%esp
    24ee:	53                   	push   %ebx
    24ef:	68 00 87 00 00       	push   $0x8700
    24f4:	50                   	push   %eax
    24f5:	e8 b9 14 00 00       	call   39b3 <write>
      if(cc != sz){
    24fa:	83 c4 10             	add    $0x10,%esp
    24fd:	39 d8                	cmp    %ebx,%eax
    24ff:	75 55                	jne    2556 <bigwrite+0xb6>
      int cc = write(fd, buf, sz);
    2501:	83 ec 04             	sub    $0x4,%esp
    2504:	53                   	push   %ebx
    2505:	68 00 87 00 00       	push   $0x8700
    250a:	56                   	push   %esi
    250b:	e8 a3 14 00 00       	call   39b3 <write>
      if(cc != sz){
    2510:	83 c4 10             	add    $0x10,%esp
    2513:	39 d8                	cmp    %ebx,%eax
    2515:	75 3f                	jne    2556 <bigwrite+0xb6>
    close(fd);
    2517:	83 ec 0c             	sub    $0xc,%esp
  for(sz = 499; sz < 12*512; sz += 471){
    251a:	81 c3 d7 01 00 00    	add    $0x1d7,%ebx
    close(fd);
    2520:	56                   	push   %esi
    2521:	e8 95 14 00 00       	call   39bb <close>
    unlink("bigwrite");
    2526:	c7 04 24 e4 48 00 00 	movl   $0x48e4,(%esp)
    252d:	e8 b1 14 00 00       	call   39e3 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    2532:	83 c4 10             	add    $0x10,%esp
    2535:	81 fb 07 18 00 00    	cmp    $0x1807,%ebx
    253b:	75 93                	jne    24d0 <bigwrite+0x30>
  printf(1, "bigwrite ok\n");
    253d:	83 ec 08             	sub    $0x8,%esp
    2540:	68 17 49 00 00       	push   $0x4917
    2545:	6a 01                	push   $0x1
    2547:	e8 b4 15 00 00       	call   3b00 <printf>
}
    254c:	83 c4 10             	add    $0x10,%esp
    254f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    2552:	5b                   	pop    %ebx
    2553:	5e                   	pop    %esi
    2554:	5d                   	pop    %ebp
    2555:	c3                   	ret    
        printf(1, "write(%d) ret %d\n", sz, cc);
    2556:	50                   	push   %eax
    2557:	53                   	push   %ebx
    2558:	68 05 49 00 00       	push   $0x4905
    255d:	6a 01                	push   $0x1
    255f:	e8 9c 15 00 00       	call   3b00 <printf>
        exit();
    2564:	e8 2a 14 00 00       	call   3993 <exit>
      printf(1, "cannot create bigwrite\n");
    2569:	83 ec 08             	sub    $0x8,%esp
    256c:	68 ed 48 00 00       	push   $0x48ed
    2571:	6a 01                	push   $0x1
    2573:	e8 88 15 00 00       	call   3b00 <printf>
      exit();
    2578:	e8 16 14 00 00       	call   3993 <exit>
    257d:	8d 76 00             	lea    0x0(%esi),%esi

00002580 <bigfile>:
{
    2580:	f3 0f 1e fb          	endbr32 
    2584:	55                   	push   %ebp
    2585:	89 e5                	mov    %esp,%ebp
    2587:	57                   	push   %edi
    2588:	56                   	push   %esi
    2589:	53                   	push   %ebx
    258a:	83 ec 14             	sub    $0x14,%esp
  printf(1, "bigfile test\n");
    258d:	68 24 49 00 00       	push   $0x4924
    2592:	6a 01                	push   $0x1
    2594:	e8 67 15 00 00       	call   3b00 <printf>
  unlink("bigfile");
    2599:	c7 04 24 40 49 00 00 	movl   $0x4940,(%esp)
    25a0:	e8 3e 14 00 00       	call   39e3 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    25a5:	58                   	pop    %eax
    25a6:	5a                   	pop    %edx
    25a7:	68 02 02 00 00       	push   $0x202
    25ac:	68 40 49 00 00       	push   $0x4940
    25b1:	e8 1d 14 00 00       	call   39d3 <open>
  if(fd < 0){
    25b6:	83 c4 10             	add    $0x10,%esp
    25b9:	85 c0                	test   %eax,%eax
    25bb:	0f 88 5a 01 00 00    	js     271b <bigfile+0x19b>
    25c1:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++){
    25c3:	31 db                	xor    %ebx,%ebx
    25c5:	8d 76 00             	lea    0x0(%esi),%esi
    memset(buf, i, 600);
    25c8:	83 ec 04             	sub    $0x4,%esp
    25cb:	68 58 02 00 00       	push   $0x258
    25d0:	53                   	push   %ebx
    25d1:	68 00 87 00 00       	push   $0x8700
    25d6:	e8 15 12 00 00       	call   37f0 <memset>
    if(write(fd, buf, 600) != 600){
    25db:	83 c4 0c             	add    $0xc,%esp
    25de:	68 58 02 00 00       	push   $0x258
    25e3:	68 00 87 00 00       	push   $0x8700
    25e8:	56                   	push   %esi
    25e9:	e8 c5 13 00 00       	call   39b3 <write>
    25ee:	83 c4 10             	add    $0x10,%esp
    25f1:	3d 58 02 00 00       	cmp    $0x258,%eax
    25f6:	0f 85 f8 00 00 00    	jne    26f4 <bigfile+0x174>
  for(i = 0; i < 20; i++){
    25fc:	83 c3 01             	add    $0x1,%ebx
    25ff:	83 fb 14             	cmp    $0x14,%ebx
    2602:	75 c4                	jne    25c8 <bigfile+0x48>
  close(fd);
    2604:	83 ec 0c             	sub    $0xc,%esp
    2607:	56                   	push   %esi
    2608:	e8 ae 13 00 00       	call   39bb <close>
  fd = open("bigfile", 0);
    260d:	5e                   	pop    %esi
    260e:	5f                   	pop    %edi
    260f:	6a 00                	push   $0x0
    2611:	68 40 49 00 00       	push   $0x4940
    2616:	e8 b8 13 00 00       	call   39d3 <open>
  if(fd < 0){
    261b:	83 c4 10             	add    $0x10,%esp
  fd = open("bigfile", 0);
    261e:	89 c6                	mov    %eax,%esi
  if(fd < 0){
    2620:	85 c0                	test   %eax,%eax
    2622:	0f 88 e0 00 00 00    	js     2708 <bigfile+0x188>
  total = 0;
    2628:	31 db                	xor    %ebx,%ebx
  for(i = 0; ; i++){
    262a:	31 ff                	xor    %edi,%edi
    262c:	eb 30                	jmp    265e <bigfile+0xde>
    262e:	66 90                	xchg   %ax,%ax
    if(cc != 300){
    2630:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2635:	0f 85 91 00 00 00    	jne    26cc <bigfile+0x14c>
    if(buf[0] != i/2 || buf[299] != i/2){
    263b:	89 fa                	mov    %edi,%edx
    263d:	0f be 05 00 87 00 00 	movsbl 0x8700,%eax
    2644:	d1 fa                	sar    %edx
    2646:	39 d0                	cmp    %edx,%eax
    2648:	75 6e                	jne    26b8 <bigfile+0x138>
    264a:	0f be 15 2b 88 00 00 	movsbl 0x882b,%edx
    2651:	39 d0                	cmp    %edx,%eax
    2653:	75 63                	jne    26b8 <bigfile+0x138>
    total += cc;
    2655:	81 c3 2c 01 00 00    	add    $0x12c,%ebx
  for(i = 0; ; i++){
    265b:	83 c7 01             	add    $0x1,%edi
    cc = read(fd, buf, 300);
    265e:	83 ec 04             	sub    $0x4,%esp
    2661:	68 2c 01 00 00       	push   $0x12c
    2666:	68 00 87 00 00       	push   $0x8700
    266b:	56                   	push   %esi
    266c:	e8 3a 13 00 00       	call   39ab <read>
    if(cc < 0){
    2671:	83 c4 10             	add    $0x10,%esp
    2674:	85 c0                	test   %eax,%eax
    2676:	78 68                	js     26e0 <bigfile+0x160>
    if(cc == 0)
    2678:	75 b6                	jne    2630 <bigfile+0xb0>
  close(fd);
    267a:	83 ec 0c             	sub    $0xc,%esp
    267d:	56                   	push   %esi
    267e:	e8 38 13 00 00       	call   39bb <close>
  if(total != 20*600){
    2683:	83 c4 10             	add    $0x10,%esp
    2686:	81 fb e0 2e 00 00    	cmp    $0x2ee0,%ebx
    268c:	0f 85 9c 00 00 00    	jne    272e <bigfile+0x1ae>
  unlink("bigfile");
    2692:	83 ec 0c             	sub    $0xc,%esp
    2695:	68 40 49 00 00       	push   $0x4940
    269a:	e8 44 13 00 00       	call   39e3 <unlink>
  printf(1, "bigfile test ok\n");
    269f:	58                   	pop    %eax
    26a0:	5a                   	pop    %edx
    26a1:	68 cf 49 00 00       	push   $0x49cf
    26a6:	6a 01                	push   $0x1
    26a8:	e8 53 14 00 00       	call   3b00 <printf>
}
    26ad:	83 c4 10             	add    $0x10,%esp
    26b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    26b3:	5b                   	pop    %ebx
    26b4:	5e                   	pop    %esi
    26b5:	5f                   	pop    %edi
    26b6:	5d                   	pop    %ebp
    26b7:	c3                   	ret    
      printf(1, "read bigfile wrong data\n");
    26b8:	83 ec 08             	sub    $0x8,%esp
    26bb:	68 9c 49 00 00       	push   $0x499c
    26c0:	6a 01                	push   $0x1
    26c2:	e8 39 14 00 00       	call   3b00 <printf>
      exit();
    26c7:	e8 c7 12 00 00       	call   3993 <exit>
      printf(1, "short read bigfile\n");
    26cc:	83 ec 08             	sub    $0x8,%esp
    26cf:	68 88 49 00 00       	push   $0x4988
    26d4:	6a 01                	push   $0x1
    26d6:	e8 25 14 00 00       	call   3b00 <printf>
      exit();
    26db:	e8 b3 12 00 00       	call   3993 <exit>
      printf(1, "read bigfile failed\n");
    26e0:	83 ec 08             	sub    $0x8,%esp
    26e3:	68 73 49 00 00       	push   $0x4973
    26e8:	6a 01                	push   $0x1
    26ea:	e8 11 14 00 00       	call   3b00 <printf>
      exit();
    26ef:	e8 9f 12 00 00       	call   3993 <exit>
      printf(1, "write bigfile failed\n");
    26f4:	83 ec 08             	sub    $0x8,%esp
    26f7:	68 48 49 00 00       	push   $0x4948
    26fc:	6a 01                	push   $0x1
    26fe:	e8 fd 13 00 00       	call   3b00 <printf>
      exit();
    2703:	e8 8b 12 00 00       	call   3993 <exit>
    printf(1, "cannot open bigfile\n");
    2708:	53                   	push   %ebx
    2709:	53                   	push   %ebx
    270a:	68 5e 49 00 00       	push   $0x495e
    270f:	6a 01                	push   $0x1
    2711:	e8 ea 13 00 00       	call   3b00 <printf>
    exit();
    2716:	e8 78 12 00 00       	call   3993 <exit>
    printf(1, "cannot create bigfile");
    271b:	50                   	push   %eax
    271c:	50                   	push   %eax
    271d:	68 32 49 00 00       	push   $0x4932
    2722:	6a 01                	push   $0x1
    2724:	e8 d7 13 00 00       	call   3b00 <printf>
    exit();
    2729:	e8 65 12 00 00       	call   3993 <exit>
    printf(1, "read bigfile wrong total\n");
    272e:	51                   	push   %ecx
    272f:	51                   	push   %ecx
    2730:	68 b5 49 00 00       	push   $0x49b5
    2735:	6a 01                	push   $0x1
    2737:	e8 c4 13 00 00       	call   3b00 <printf>
    exit();
    273c:	e8 52 12 00 00       	call   3993 <exit>
    2741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    274f:	90                   	nop

00002750 <fourteen>:
{
    2750:	f3 0f 1e fb          	endbr32 
    2754:	55                   	push   %ebp
    2755:	89 e5                	mov    %esp,%ebp
    2757:	83 ec 10             	sub    $0x10,%esp
  printf(1, "fourteen test\n");
    275a:	68 e0 49 00 00       	push   $0x49e0
    275f:	6a 01                	push   $0x1
    2761:	e8 9a 13 00 00       	call   3b00 <printf>
  if(mkdir("12345678901234") != 0){
    2766:	c7 04 24 1b 4a 00 00 	movl   $0x4a1b,(%esp)
    276d:	e8 89 12 00 00       	call   39fb <mkdir>
    2772:	83 c4 10             	add    $0x10,%esp
    2775:	85 c0                	test   %eax,%eax
    2777:	0f 85 97 00 00 00    	jne    2814 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    277d:	83 ec 0c             	sub    $0xc,%esp
    2780:	68 d8 51 00 00       	push   $0x51d8
    2785:	e8 71 12 00 00       	call   39fb <mkdir>
    278a:	83 c4 10             	add    $0x10,%esp
    278d:	85 c0                	test   %eax,%eax
    278f:	0f 85 de 00 00 00    	jne    2873 <fourteen+0x123>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2795:	83 ec 08             	sub    $0x8,%esp
    2798:	68 00 02 00 00       	push   $0x200
    279d:	68 28 52 00 00       	push   $0x5228
    27a2:	e8 2c 12 00 00       	call   39d3 <open>
  if(fd < 0){
    27a7:	83 c4 10             	add    $0x10,%esp
    27aa:	85 c0                	test   %eax,%eax
    27ac:	0f 88 ae 00 00 00    	js     2860 <fourteen+0x110>
  close(fd);
    27b2:	83 ec 0c             	sub    $0xc,%esp
    27b5:	50                   	push   %eax
    27b6:	e8 00 12 00 00       	call   39bb <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27bb:	58                   	pop    %eax
    27bc:	5a                   	pop    %edx
    27bd:	6a 00                	push   $0x0
    27bf:	68 98 52 00 00       	push   $0x5298
    27c4:	e8 0a 12 00 00       	call   39d3 <open>
  if(fd < 0){
    27c9:	83 c4 10             	add    $0x10,%esp
    27cc:	85 c0                	test   %eax,%eax
    27ce:	78 7d                	js     284d <fourteen+0xfd>
  close(fd);
    27d0:	83 ec 0c             	sub    $0xc,%esp
    27d3:	50                   	push   %eax
    27d4:	e8 e2 11 00 00       	call   39bb <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27d9:	c7 04 24 0c 4a 00 00 	movl   $0x4a0c,(%esp)
    27e0:	e8 16 12 00 00       	call   39fb <mkdir>
    27e5:	83 c4 10             	add    $0x10,%esp
    27e8:	85 c0                	test   %eax,%eax
    27ea:	74 4e                	je     283a <fourteen+0xea>
  if(mkdir("123456789012345/12345678901234") == 0){
    27ec:	83 ec 0c             	sub    $0xc,%esp
    27ef:	68 34 53 00 00       	push   $0x5334
    27f4:	e8 02 12 00 00       	call   39fb <mkdir>
    27f9:	83 c4 10             	add    $0x10,%esp
    27fc:	85 c0                	test   %eax,%eax
    27fe:	74 27                	je     2827 <fourteen+0xd7>
  printf(1, "fourteen ok\n");
    2800:	83 ec 08             	sub    $0x8,%esp
    2803:	68 2a 4a 00 00       	push   $0x4a2a
    2808:	6a 01                	push   $0x1
    280a:	e8 f1 12 00 00       	call   3b00 <printf>
}
    280f:	83 c4 10             	add    $0x10,%esp
    2812:	c9                   	leave  
    2813:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    2814:	50                   	push   %eax
    2815:	50                   	push   %eax
    2816:	68 ef 49 00 00       	push   $0x49ef
    281b:	6a 01                	push   $0x1
    281d:	e8 de 12 00 00       	call   3b00 <printf>
    exit();
    2822:	e8 6c 11 00 00       	call   3993 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    2827:	50                   	push   %eax
    2828:	50                   	push   %eax
    2829:	68 54 53 00 00       	push   $0x5354
    282e:	6a 01                	push   $0x1
    2830:	e8 cb 12 00 00       	call   3b00 <printf>
    exit();
    2835:	e8 59 11 00 00       	call   3993 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    283a:	52                   	push   %edx
    283b:	52                   	push   %edx
    283c:	68 04 53 00 00       	push   $0x5304
    2841:	6a 01                	push   $0x1
    2843:	e8 b8 12 00 00       	call   3b00 <printf>
    exit();
    2848:	e8 46 11 00 00       	call   3993 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    284d:	51                   	push   %ecx
    284e:	51                   	push   %ecx
    284f:	68 c8 52 00 00       	push   $0x52c8
    2854:	6a 01                	push   $0x1
    2856:	e8 a5 12 00 00       	call   3b00 <printf>
    exit();
    285b:	e8 33 11 00 00       	call   3993 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    2860:	51                   	push   %ecx
    2861:	51                   	push   %ecx
    2862:	68 58 52 00 00       	push   $0x5258
    2867:	6a 01                	push   $0x1
    2869:	e8 92 12 00 00       	call   3b00 <printf>
    exit();
    286e:	e8 20 11 00 00       	call   3993 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    2873:	50                   	push   %eax
    2874:	50                   	push   %eax
    2875:	68 f8 51 00 00       	push   $0x51f8
    287a:	6a 01                	push   $0x1
    287c:	e8 7f 12 00 00       	call   3b00 <printf>
    exit();
    2881:	e8 0d 11 00 00       	call   3993 <exit>
    2886:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    288d:	8d 76 00             	lea    0x0(%esi),%esi

00002890 <rmdot>:
{
    2890:	f3 0f 1e fb          	endbr32 
    2894:	55                   	push   %ebp
    2895:	89 e5                	mov    %esp,%ebp
    2897:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    289a:	68 37 4a 00 00       	push   $0x4a37
    289f:	6a 01                	push   $0x1
    28a1:	e8 5a 12 00 00       	call   3b00 <printf>
  if(mkdir("dots") != 0){
    28a6:	c7 04 24 43 4a 00 00 	movl   $0x4a43,(%esp)
    28ad:	e8 49 11 00 00       	call   39fb <mkdir>
    28b2:	83 c4 10             	add    $0x10,%esp
    28b5:	85 c0                	test   %eax,%eax
    28b7:	0f 85 b0 00 00 00    	jne    296d <rmdot+0xdd>
  if(chdir("dots") != 0){
    28bd:	83 ec 0c             	sub    $0xc,%esp
    28c0:	68 43 4a 00 00       	push   $0x4a43
    28c5:	e8 39 11 00 00       	call   3a03 <chdir>
    28ca:	83 c4 10             	add    $0x10,%esp
    28cd:	85 c0                	test   %eax,%eax
    28cf:	0f 85 1d 01 00 00    	jne    29f2 <rmdot+0x162>
  if(unlink(".") == 0){
    28d5:	83 ec 0c             	sub    $0xc,%esp
    28d8:	68 ee 46 00 00       	push   $0x46ee
    28dd:	e8 01 11 00 00       	call   39e3 <unlink>
    28e2:	83 c4 10             	add    $0x10,%esp
    28e5:	85 c0                	test   %eax,%eax
    28e7:	0f 84 f2 00 00 00    	je     29df <rmdot+0x14f>
  if(unlink("..") == 0){
    28ed:	83 ec 0c             	sub    $0xc,%esp
    28f0:	68 ed 46 00 00       	push   $0x46ed
    28f5:	e8 e9 10 00 00       	call   39e3 <unlink>
    28fa:	83 c4 10             	add    $0x10,%esp
    28fd:	85 c0                	test   %eax,%eax
    28ff:	0f 84 c7 00 00 00    	je     29cc <rmdot+0x13c>
  if(chdir("/") != 0){
    2905:	83 ec 0c             	sub    $0xc,%esp
    2908:	68 b1 3e 00 00       	push   $0x3eb1
    290d:	e8 f1 10 00 00       	call   3a03 <chdir>
    2912:	83 c4 10             	add    $0x10,%esp
    2915:	85 c0                	test   %eax,%eax
    2917:	0f 85 9c 00 00 00    	jne    29b9 <rmdot+0x129>
  if(unlink("dots/.") == 0){
    291d:	83 ec 0c             	sub    $0xc,%esp
    2920:	68 8b 4a 00 00       	push   $0x4a8b
    2925:	e8 b9 10 00 00       	call   39e3 <unlink>
    292a:	83 c4 10             	add    $0x10,%esp
    292d:	85 c0                	test   %eax,%eax
    292f:	74 75                	je     29a6 <rmdot+0x116>
  if(unlink("dots/..") == 0){
    2931:	83 ec 0c             	sub    $0xc,%esp
    2934:	68 a9 4a 00 00       	push   $0x4aa9
    2939:	e8 a5 10 00 00       	call   39e3 <unlink>
    293e:	83 c4 10             	add    $0x10,%esp
    2941:	85 c0                	test   %eax,%eax
    2943:	74 4e                	je     2993 <rmdot+0x103>
  if(unlink("dots") != 0){
    2945:	83 ec 0c             	sub    $0xc,%esp
    2948:	68 43 4a 00 00       	push   $0x4a43
    294d:	e8 91 10 00 00       	call   39e3 <unlink>
    2952:	83 c4 10             	add    $0x10,%esp
    2955:	85 c0                	test   %eax,%eax
    2957:	75 27                	jne    2980 <rmdot+0xf0>
  printf(1, "rmdot ok\n");
    2959:	83 ec 08             	sub    $0x8,%esp
    295c:	68 de 4a 00 00       	push   $0x4ade
    2961:	6a 01                	push   $0x1
    2963:	e8 98 11 00 00       	call   3b00 <printf>
}
    2968:	83 c4 10             	add    $0x10,%esp
    296b:	c9                   	leave  
    296c:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    296d:	50                   	push   %eax
    296e:	50                   	push   %eax
    296f:	68 48 4a 00 00       	push   $0x4a48
    2974:	6a 01                	push   $0x1
    2976:	e8 85 11 00 00       	call   3b00 <printf>
    exit();
    297b:	e8 13 10 00 00       	call   3993 <exit>
    printf(1, "unlink dots failed!\n");
    2980:	50                   	push   %eax
    2981:	50                   	push   %eax
    2982:	68 c9 4a 00 00       	push   $0x4ac9
    2987:	6a 01                	push   $0x1
    2989:	e8 72 11 00 00       	call   3b00 <printf>
    exit();
    298e:	e8 00 10 00 00       	call   3993 <exit>
    printf(1, "unlink dots/.. worked!\n");
    2993:	52                   	push   %edx
    2994:	52                   	push   %edx
    2995:	68 b1 4a 00 00       	push   $0x4ab1
    299a:	6a 01                	push   $0x1
    299c:	e8 5f 11 00 00       	call   3b00 <printf>
    exit();
    29a1:	e8 ed 0f 00 00       	call   3993 <exit>
    printf(1, "unlink dots/. worked!\n");
    29a6:	51                   	push   %ecx
    29a7:	51                   	push   %ecx
    29a8:	68 92 4a 00 00       	push   $0x4a92
    29ad:	6a 01                	push   $0x1
    29af:	e8 4c 11 00 00       	call   3b00 <printf>
    exit();
    29b4:	e8 da 0f 00 00       	call   3993 <exit>
    printf(1, "chdir / failed\n");
    29b9:	50                   	push   %eax
    29ba:	50                   	push   %eax
    29bb:	68 b3 3e 00 00       	push   $0x3eb3
    29c0:	6a 01                	push   $0x1
    29c2:	e8 39 11 00 00       	call   3b00 <printf>
    exit();
    29c7:	e8 c7 0f 00 00       	call   3993 <exit>
    printf(1, "rm .. worked!\n");
    29cc:	50                   	push   %eax
    29cd:	50                   	push   %eax
    29ce:	68 7c 4a 00 00       	push   $0x4a7c
    29d3:	6a 01                	push   $0x1
    29d5:	e8 26 11 00 00       	call   3b00 <printf>
    exit();
    29da:	e8 b4 0f 00 00       	call   3993 <exit>
    printf(1, "rm . worked!\n");
    29df:	50                   	push   %eax
    29e0:	50                   	push   %eax
    29e1:	68 6e 4a 00 00       	push   $0x4a6e
    29e6:	6a 01                	push   $0x1
    29e8:	e8 13 11 00 00       	call   3b00 <printf>
    exit();
    29ed:	e8 a1 0f 00 00       	call   3993 <exit>
    printf(1, "chdir dots failed\n");
    29f2:	50                   	push   %eax
    29f3:	50                   	push   %eax
    29f4:	68 5b 4a 00 00       	push   $0x4a5b
    29f9:	6a 01                	push   $0x1
    29fb:	e8 00 11 00 00       	call   3b00 <printf>
    exit();
    2a00:	e8 8e 0f 00 00       	call   3993 <exit>
    2a05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    2a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00002a10 <dirfile>:
{
    2a10:	f3 0f 1e fb          	endbr32 
    2a14:	55                   	push   %ebp
    2a15:	89 e5                	mov    %esp,%ebp
    2a17:	53                   	push   %ebx
    2a18:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "dir vs file\n");
    2a1b:	68 e8 4a 00 00       	push   $0x4ae8
    2a20:	6a 01                	push   $0x1
    2a22:	e8 d9 10 00 00       	call   3b00 <printf>
  fd = open("dirfile", O_CREATE);
    2a27:	5b                   	pop    %ebx
    2a28:	58                   	pop    %eax
    2a29:	68 00 02 00 00       	push   $0x200
    2a2e:	68 f5 4a 00 00       	push   $0x4af5
    2a33:	e8 9b 0f 00 00       	call   39d3 <open>
  if(fd < 0){
    2a38:	83 c4 10             	add    $0x10,%esp
    2a3b:	85 c0                	test   %eax,%eax
    2a3d:	0f 88 43 01 00 00    	js     2b86 <dirfile+0x176>
  close(fd);
    2a43:	83 ec 0c             	sub    $0xc,%esp
    2a46:	50                   	push   %eax
    2a47:	e8 6f 0f 00 00       	call   39bb <close>
  if(chdir("dirfile") == 0){
    2a4c:	c7 04 24 f5 4a 00 00 	movl   $0x4af5,(%esp)
    2a53:	e8 ab 0f 00 00       	call   3a03 <chdir>
    2a58:	83 c4 10             	add    $0x10,%esp
    2a5b:	85 c0                	test   %eax,%eax
    2a5d:	0f 84 10 01 00 00    	je     2b73 <dirfile+0x163>
  fd = open("dirfile/xx", 0);
    2a63:	83 ec 08             	sub    $0x8,%esp
    2a66:	6a 00                	push   $0x0
    2a68:	68 2e 4b 00 00       	push   $0x4b2e
    2a6d:	e8 61 0f 00 00       	call   39d3 <open>
  if(fd >= 0){
    2a72:	83 c4 10             	add    $0x10,%esp
    2a75:	85 c0                	test   %eax,%eax
    2a77:	0f 89 e3 00 00 00    	jns    2b60 <dirfile+0x150>
  fd = open("dirfile/xx", O_CREATE);
    2a7d:	83 ec 08             	sub    $0x8,%esp
    2a80:	68 00 02 00 00       	push   $0x200
    2a85:	68 2e 4b 00 00       	push   $0x4b2e
    2a8a:	e8 44 0f 00 00       	call   39d3 <open>
  if(fd >= 0){
    2a8f:	83 c4 10             	add    $0x10,%esp
    2a92:	85 c0                	test   %eax,%eax
    2a94:	0f 89 c6 00 00 00    	jns    2b60 <dirfile+0x150>
  if(mkdir("dirfile/xx") == 0){
    2a9a:	83 ec 0c             	sub    $0xc,%esp
    2a9d:	68 2e 4b 00 00       	push   $0x4b2e
    2aa2:	e8 54 0f 00 00       	call   39fb <mkdir>
    2aa7:	83 c4 10             	add    $0x10,%esp
    2aaa:	85 c0                	test   %eax,%eax
    2aac:	0f 84 46 01 00 00    	je     2bf8 <dirfile+0x1e8>
  if(unlink("dirfile/xx") == 0){
    2ab2:	83 ec 0c             	sub    $0xc,%esp
    2ab5:	68 2e 4b 00 00       	push   $0x4b2e
    2aba:	e8 24 0f 00 00       	call   39e3 <unlink>
    2abf:	83 c4 10             	add    $0x10,%esp
    2ac2:	85 c0                	test   %eax,%eax
    2ac4:	0f 84 1b 01 00 00    	je     2be5 <dirfile+0x1d5>
  if(link("README", "dirfile/xx") == 0){
    2aca:	83 ec 08             	sub    $0x8,%esp
    2acd:	68 2e 4b 00 00       	push   $0x4b2e
    2ad2:	68 92 4b 00 00       	push   $0x4b92
    2ad7:	e8 17 0f 00 00       	call   39f3 <link>
    2adc:	83 c4 10             	add    $0x10,%esp
    2adf:	85 c0                	test   %eax,%eax
    2ae1:	0f 84 eb 00 00 00    	je     2bd2 <dirfile+0x1c2>
  if(unlink("dirfile") != 0){
    2ae7:	83 ec 0c             	sub    $0xc,%esp
    2aea:	68 f5 4a 00 00       	push   $0x4af5
    2aef:	e8 ef 0e 00 00       	call   39e3 <unlink>
    2af4:	83 c4 10             	add    $0x10,%esp
    2af7:	85 c0                	test   %eax,%eax
    2af9:	0f 85 c0 00 00 00    	jne    2bbf <dirfile+0x1af>
  fd = open(".", O_RDWR);
    2aff:	83 ec 08             	sub    $0x8,%esp
    2b02:	6a 02                	push   $0x2
    2b04:	68 ee 46 00 00       	push   $0x46ee
    2b09:	e8 c5 0e 00 00       	call   39d3 <open>
  if(fd >= 0){
    2b0e:	83 c4 10             	add    $0x10,%esp
    2b11:	85 c0                	test   %eax,%eax
    2b13:	0f 89 93 00 00 00    	jns    2bac <dirfile+0x19c>
  fd = open(".", 0);
    2b19:	83 ec 08             	sub    $0x8,%esp
    2b1c:	6a 00                	push   $0x0
    2b1e:	68 ee 46 00 00       	push   $0x46ee
    2b23:	e8 ab 0e 00 00       	call   39d3 <open>
  if(write(fd, "x", 1) > 0){
    2b28:	83 c4 0c             	add    $0xc,%esp
    2b2b:	6a 01                	push   $0x1
  fd = open(".", 0);
    2b2d:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    2b2f:	68 d1 47 00 00       	push   $0x47d1
    2b34:	50                   	push   %eax
    2b35:	e8 79 0e 00 00       	call   39b3 <write>
    2b3a:	83 c4 10             	add    $0x10,%esp
    2b3d:	85 c0                	test   %eax,%eax
    2b3f:	7f 58                	jg     2b99 <dirfile+0x189>
  close(fd);
    2b41:	83 ec 0c             	sub    $0xc,%esp
    2b44:	53                   	push   %ebx
    2b45:	e8 71 0e 00 00       	call   39bb <close>
  printf(1, "dir vs file OK\n");
    2b4a:	58                   	pop    %eax
    2b4b:	5a                   	pop    %edx
    2b4c:	68 c5 4b 00 00       	push   $0x4bc5
    2b51:	6a 01                	push   $0x1
    2b53:	e8 a8 0f 00 00       	call   3b00 <printf>
}
    2b58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b5b:	83 c4 10             	add    $0x10,%esp
    2b5e:	c9                   	leave  
    2b5f:	c3                   	ret    
    printf(1, "create dirfile/xx succeeded!\n");
    2b60:	50                   	push   %eax
    2b61:	50                   	push   %eax
    2b62:	68 39 4b 00 00       	push   $0x4b39
    2b67:	6a 01                	push   $0x1
    2b69:	e8 92 0f 00 00       	call   3b00 <printf>
    exit();
    2b6e:	e8 20 0e 00 00       	call   3993 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2b73:	52                   	push   %edx
    2b74:	52                   	push   %edx
    2b75:	68 14 4b 00 00       	push   $0x4b14
    2b7a:	6a 01                	push   $0x1
    2b7c:	e8 7f 0f 00 00       	call   3b00 <printf>
    exit();
    2b81:	e8 0d 0e 00 00       	call   3993 <exit>
    printf(1, "create dirfile failed\n");
    2b86:	51                   	push   %ecx
    2b87:	51                   	push   %ecx
    2b88:	68 fd 4a 00 00       	push   $0x4afd
    2b8d:	6a 01                	push   $0x1
    2b8f:	e8 6c 0f 00 00       	call   3b00 <printf>
    exit();
    2b94:	e8 fa 0d 00 00       	call   3993 <exit>
    printf(1, "write . succeeded!\n");
    2b99:	51                   	push   %ecx
    2b9a:	51                   	push   %ecx
    2b9b:	68 b1 4b 00 00       	push   $0x4bb1
    2ba0:	6a 01                	push   $0x1
    2ba2:	e8 59 0f 00 00       	call   3b00 <printf>
    exit();
    2ba7:	e8 e7 0d 00 00       	call   3993 <exit>
    printf(1, "open . for writing succeeded!\n");
    2bac:	53                   	push   %ebx
    2bad:	53                   	push   %ebx
    2bae:	68 a8 53 00 00       	push   $0x53a8
    2bb3:	6a 01                	push   $0x1
    2bb5:	e8 46 0f 00 00       	call   3b00 <printf>
    exit();
    2bba:	e8 d4 0d 00 00       	call   3993 <exit>
    printf(1, "unlink dirfile failed!\n");
    2bbf:	50                   	push   %eax
    2bc0:	50                   	push   %eax
    2bc1:	68 99 4b 00 00       	push   $0x4b99
    2bc6:	6a 01                	push   $0x1
    2bc8:	e8 33 0f 00 00       	call   3b00 <printf>
    exit();
    2bcd:	e8 c1 0d 00 00       	call   3993 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    2bd2:	50                   	push   %eax
    2bd3:	50                   	push   %eax
    2bd4:	68 88 53 00 00       	push   $0x5388
    2bd9:	6a 01                	push   $0x1
    2bdb:	e8 20 0f 00 00       	call   3b00 <printf>
    exit();
    2be0:	e8 ae 0d 00 00       	call   3993 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2be5:	50                   	push   %eax
    2be6:	50                   	push   %eax
    2be7:	68 74 4b 00 00       	push   $0x4b74
    2bec:	6a 01                	push   $0x1
    2bee:	e8 0d 0f 00 00       	call   3b00 <printf>
    exit();
    2bf3:	e8 9b 0d 00 00       	call   3993 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    2bf8:	50                   	push   %eax
    2bf9:	50                   	push   %eax
    2bfa:	68 57 4b 00 00       	push   $0x4b57
    2bff:	6a 01                	push   $0x1
    2c01:	e8 fa 0e 00 00       	call   3b00 <printf>
    exit();
    2c06:	e8 88 0d 00 00       	call   3993 <exit>
    2c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2c0f:	90                   	nop

00002c10 <iref>:
{
    2c10:	f3 0f 1e fb          	endbr32 
    2c14:	55                   	push   %ebp
    2c15:	89 e5                	mov    %esp,%ebp
    2c17:	53                   	push   %ebx
  printf(1, "empty file name\n");
    2c18:	bb 33 00 00 00       	mov    $0x33,%ebx
{
    2c1d:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "empty file name\n");
    2c20:	68 d5 4b 00 00       	push   $0x4bd5
    2c25:	6a 01                	push   $0x1
    2c27:	e8 d4 0e 00 00       	call   3b00 <printf>
    2c2c:	83 c4 10             	add    $0x10,%esp
    2c2f:	90                   	nop
    if(mkdir("irefd") != 0){
    2c30:	83 ec 0c             	sub    $0xc,%esp
    2c33:	68 e6 4b 00 00       	push   $0x4be6
    2c38:	e8 be 0d 00 00       	call   39fb <mkdir>
    2c3d:	83 c4 10             	add    $0x10,%esp
    2c40:	85 c0                	test   %eax,%eax
    2c42:	0f 85 bb 00 00 00    	jne    2d03 <iref+0xf3>
    if(chdir("irefd") != 0){
    2c48:	83 ec 0c             	sub    $0xc,%esp
    2c4b:	68 e6 4b 00 00       	push   $0x4be6
    2c50:	e8 ae 0d 00 00       	call   3a03 <chdir>
    2c55:	83 c4 10             	add    $0x10,%esp
    2c58:	85 c0                	test   %eax,%eax
    2c5a:	0f 85 b7 00 00 00    	jne    2d17 <iref+0x107>
    mkdir("");
    2c60:	83 ec 0c             	sub    $0xc,%esp
    2c63:	68 8b 42 00 00       	push   $0x428b
    2c68:	e8 8e 0d 00 00       	call   39fb <mkdir>
    link("README", "");
    2c6d:	59                   	pop    %ecx
    2c6e:	58                   	pop    %eax
    2c6f:	68 8b 42 00 00       	push   $0x428b
    2c74:	68 92 4b 00 00       	push   $0x4b92
    2c79:	e8 75 0d 00 00       	call   39f3 <link>
    fd = open("", O_CREATE);
    2c7e:	58                   	pop    %eax
    2c7f:	5a                   	pop    %edx
    2c80:	68 00 02 00 00       	push   $0x200
    2c85:	68 8b 42 00 00       	push   $0x428b
    2c8a:	e8 44 0d 00 00       	call   39d3 <open>
    if(fd >= 0)
    2c8f:	83 c4 10             	add    $0x10,%esp
    2c92:	85 c0                	test   %eax,%eax
    2c94:	78 0c                	js     2ca2 <iref+0x92>
      close(fd);
    2c96:	83 ec 0c             	sub    $0xc,%esp
    2c99:	50                   	push   %eax
    2c9a:	e8 1c 0d 00 00       	call   39bb <close>
    2c9f:	83 c4 10             	add    $0x10,%esp
    fd = open("xx", O_CREATE);
    2ca2:	83 ec 08             	sub    $0x8,%esp
    2ca5:	68 00 02 00 00       	push   $0x200
    2caa:	68 d0 47 00 00       	push   $0x47d0
    2caf:	e8 1f 0d 00 00       	call   39d3 <open>
    if(fd >= 0)
    2cb4:	83 c4 10             	add    $0x10,%esp
    2cb7:	85 c0                	test   %eax,%eax
    2cb9:	78 0c                	js     2cc7 <iref+0xb7>
      close(fd);
    2cbb:	83 ec 0c             	sub    $0xc,%esp
    2cbe:	50                   	push   %eax
    2cbf:	e8 f7 0c 00 00       	call   39bb <close>
    2cc4:	83 c4 10             	add    $0x10,%esp
    unlink("xx");
    2cc7:	83 ec 0c             	sub    $0xc,%esp
    2cca:	68 d0 47 00 00       	push   $0x47d0
    2ccf:	e8 0f 0d 00 00       	call   39e3 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2cd4:	83 c4 10             	add    $0x10,%esp
    2cd7:	83 eb 01             	sub    $0x1,%ebx
    2cda:	0f 85 50 ff ff ff    	jne    2c30 <iref+0x20>
  chdir("/");
    2ce0:	83 ec 0c             	sub    $0xc,%esp
    2ce3:	68 b1 3e 00 00       	push   $0x3eb1
    2ce8:	e8 16 0d 00 00       	call   3a03 <chdir>
  printf(1, "empty file name OK\n");
    2ced:	58                   	pop    %eax
    2cee:	5a                   	pop    %edx
    2cef:	68 14 4c 00 00       	push   $0x4c14
    2cf4:	6a 01                	push   $0x1
    2cf6:	e8 05 0e 00 00       	call   3b00 <printf>
}
    2cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2cfe:	83 c4 10             	add    $0x10,%esp
    2d01:	c9                   	leave  
    2d02:	c3                   	ret    
      printf(1, "mkdir irefd failed\n");
    2d03:	83 ec 08             	sub    $0x8,%esp
    2d06:	68 ec 4b 00 00       	push   $0x4bec
    2d0b:	6a 01                	push   $0x1
    2d0d:	e8 ee 0d 00 00       	call   3b00 <printf>
      exit();
    2d12:	e8 7c 0c 00 00       	call   3993 <exit>
      printf(1, "chdir irefd failed\n");
    2d17:	83 ec 08             	sub    $0x8,%esp
    2d1a:	68 00 4c 00 00       	push   $0x4c00
    2d1f:	6a 01                	push   $0x1
    2d21:	e8 da 0d 00 00       	call   3b00 <printf>
      exit();
    2d26:	e8 68 0c 00 00       	call   3993 <exit>
    2d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2d2f:	90                   	nop

00002d30 <forktest>:
{
    2d30:	f3 0f 1e fb          	endbr32 
    2d34:	55                   	push   %ebp
    2d35:	89 e5                	mov    %esp,%ebp
    2d37:	53                   	push   %ebx
  for(n=0; n<1000; n++){
    2d38:	31 db                	xor    %ebx,%ebx
{
    2d3a:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "fork test\n");
    2d3d:	68 28 4c 00 00       	push   $0x4c28
    2d42:	6a 01                	push   $0x1
    2d44:	e8 b7 0d 00 00       	call   3b00 <printf>
    2d49:	83 c4 10             	add    $0x10,%esp
    2d4c:	eb 0f                	jmp    2d5d <forktest+0x2d>
    2d4e:	66 90                	xchg   %ax,%ax
    if(pid == 0)
    2d50:	74 4a                	je     2d9c <forktest+0x6c>
  for(n=0; n<1000; n++){
    2d52:	83 c3 01             	add    $0x1,%ebx
    2d55:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2d5b:	74 6b                	je     2dc8 <forktest+0x98>
    pid = fork();
    2d5d:	e8 29 0c 00 00       	call   398b <fork>
    if(pid < 0)
    2d62:	85 c0                	test   %eax,%eax
    2d64:	79 ea                	jns    2d50 <forktest+0x20>
  for(; n > 0; n--){
    2d66:	85 db                	test   %ebx,%ebx
    2d68:	74 14                	je     2d7e <forktest+0x4e>
    2d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(wait() < 0){
    2d70:	e8 26 0c 00 00       	call   399b <wait>
    2d75:	85 c0                	test   %eax,%eax
    2d77:	78 28                	js     2da1 <forktest+0x71>
  for(; n > 0; n--){
    2d79:	83 eb 01             	sub    $0x1,%ebx
    2d7c:	75 f2                	jne    2d70 <forktest+0x40>
  if(wait() != -1){
    2d7e:	e8 18 0c 00 00       	call   399b <wait>
    2d83:	83 f8 ff             	cmp    $0xffffffff,%eax
    2d86:	75 2d                	jne    2db5 <forktest+0x85>
  printf(1, "fork test OK\n");
    2d88:	83 ec 08             	sub    $0x8,%esp
    2d8b:	68 5a 4c 00 00       	push   $0x4c5a
    2d90:	6a 01                	push   $0x1
    2d92:	e8 69 0d 00 00       	call   3b00 <printf>
}
    2d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2d9a:	c9                   	leave  
    2d9b:	c3                   	ret    
      exit();
    2d9c:	e8 f2 0b 00 00       	call   3993 <exit>
      printf(1, "wait stopped early\n");
    2da1:	83 ec 08             	sub    $0x8,%esp
    2da4:	68 33 4c 00 00       	push   $0x4c33
    2da9:	6a 01                	push   $0x1
    2dab:	e8 50 0d 00 00       	call   3b00 <printf>
      exit();
    2db0:	e8 de 0b 00 00       	call   3993 <exit>
    printf(1, "wait got too many\n");
    2db5:	52                   	push   %edx
    2db6:	52                   	push   %edx
    2db7:	68 47 4c 00 00       	push   $0x4c47
    2dbc:	6a 01                	push   $0x1
    2dbe:	e8 3d 0d 00 00       	call   3b00 <printf>
    exit();
    2dc3:	e8 cb 0b 00 00       	call   3993 <exit>
    printf(1, "fork claimed to work 1000 times!\n");
    2dc8:	50                   	push   %eax
    2dc9:	50                   	push   %eax
    2dca:	68 c8 53 00 00       	push   $0x53c8
    2dcf:	6a 01                	push   $0x1
    2dd1:	e8 2a 0d 00 00       	call   3b00 <printf>
    exit();
    2dd6:	e8 b8 0b 00 00       	call   3993 <exit>
    2ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    2ddf:	90                   	nop

00002de0 <sbrktest>:
{
    2de0:	f3 0f 1e fb          	endbr32 
    2de4:	55                   	push   %ebp
    2de5:	89 e5                	mov    %esp,%ebp
    2de7:	57                   	push   %edi
  for(i = 0; i < 5000; i++){
    2de8:	31 ff                	xor    %edi,%edi
{
    2dea:	56                   	push   %esi
    2deb:	53                   	push   %ebx
    2dec:	83 ec 54             	sub    $0x54,%esp
  printf(stdout, "sbrk test\n");
    2def:	68 68 4c 00 00       	push   $0x4c68
    2df4:	ff 35 10 5f 00 00    	pushl  0x5f10
    2dfa:	e8 01 0d 00 00       	call   3b00 <printf>
  oldbrk = sbrk(0);
    2dff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2e06:	e8 10 0c 00 00       	call   3a1b <sbrk>
  a = sbrk(0);
    2e0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  oldbrk = sbrk(0);
    2e12:	89 c3                	mov    %eax,%ebx
  a = sbrk(0);
    2e14:	e8 02 0c 00 00       	call   3a1b <sbrk>
    2e19:	83 c4 10             	add    $0x10,%esp
    2e1c:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 5000; i++){
    2e1e:	eb 02                	jmp    2e22 <sbrktest+0x42>
    a = b + 1;
    2e20:	89 c6                	mov    %eax,%esi
    b = sbrk(1);
    2e22:	83 ec 0c             	sub    $0xc,%esp
    2e25:	6a 01                	push   $0x1
    2e27:	e8 ef 0b 00 00       	call   3a1b <sbrk>
    if(b != a){
    2e2c:	83 c4 10             	add    $0x10,%esp
    2e2f:	39 f0                	cmp    %esi,%eax
    2e31:	0f 85 84 02 00 00    	jne    30bb <sbrktest+0x2db>
  for(i = 0; i < 5000; i++){
    2e37:	83 c7 01             	add    $0x1,%edi
    *b = 1;
    2e3a:	c6 06 01             	movb   $0x1,(%esi)
    a = b + 1;
    2e3d:	8d 46 01             	lea    0x1(%esi),%eax
  for(i = 0; i < 5000; i++){
    2e40:	81 ff 88 13 00 00    	cmp    $0x1388,%edi
    2e46:	75 d8                	jne    2e20 <sbrktest+0x40>
  pid = fork();
    2e48:	e8 3e 0b 00 00       	call   398b <fork>
    2e4d:	89 c7                	mov    %eax,%edi
  if(pid < 0){
    2e4f:	85 c0                	test   %eax,%eax
    2e51:	0f 88 91 03 00 00    	js     31e8 <sbrktest+0x408>
  c = sbrk(1);
    2e57:	83 ec 0c             	sub    $0xc,%esp
  if(c != a + 1){
    2e5a:	83 c6 02             	add    $0x2,%esi
  c = sbrk(1);
    2e5d:	6a 01                	push   $0x1
    2e5f:	e8 b7 0b 00 00       	call   3a1b <sbrk>
  c = sbrk(1);
    2e64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2e6b:	e8 ab 0b 00 00       	call   3a1b <sbrk>
  if(c != a + 1){
    2e70:	83 c4 10             	add    $0x10,%esp
    2e73:	39 c6                	cmp    %eax,%esi
    2e75:	0f 85 56 03 00 00    	jne    31d1 <sbrktest+0x3f1>
  if(pid == 0)
    2e7b:	85 ff                	test   %edi,%edi
    2e7d:	0f 84 49 03 00 00    	je     31cc <sbrktest+0x3ec>
  wait();
    2e83:	e8 13 0b 00 00       	call   399b <wait>
  a = sbrk(0);
    2e88:	83 ec 0c             	sub    $0xc,%esp
    2e8b:	6a 00                	push   $0x0
    2e8d:	e8 89 0b 00 00       	call   3a1b <sbrk>
    2e92:	89 c6                	mov    %eax,%esi
  amt = (BIG) - (uint)a;
    2e94:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2e99:	29 f0                	sub    %esi,%eax
  p = sbrk(amt);
    2e9b:	89 04 24             	mov    %eax,(%esp)
    2e9e:	e8 78 0b 00 00       	call   3a1b <sbrk>
  if (p != a) {
    2ea3:	83 c4 10             	add    $0x10,%esp
    2ea6:	39 c6                	cmp    %eax,%esi
    2ea8:	0f 85 07 03 00 00    	jne    31b5 <sbrktest+0x3d5>
  a = sbrk(0);
    2eae:	83 ec 0c             	sub    $0xc,%esp
  *lastaddr = 99;
    2eb1:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff
  a = sbrk(0);
    2eb8:	6a 00                	push   $0x0
    2eba:	e8 5c 0b 00 00       	call   3a1b <sbrk>
  c = sbrk(-4096);
    2ebf:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
  a = sbrk(0);
    2ec6:	89 c6                	mov    %eax,%esi
  c = sbrk(-4096);
    2ec8:	e8 4e 0b 00 00       	call   3a1b <sbrk>
  if(c == (char*)0xffffffff){
    2ecd:	83 c4 10             	add    $0x10,%esp
    2ed0:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ed3:	0f 84 c5 02 00 00    	je     319e <sbrktest+0x3be>
  c = sbrk(0);
    2ed9:	83 ec 0c             	sub    $0xc,%esp
    2edc:	6a 00                	push   $0x0
    2ede:	e8 38 0b 00 00       	call   3a1b <sbrk>
  if(c != a - 4096){
    2ee3:	8d 96 00 f0 ff ff    	lea    -0x1000(%esi),%edx
    2ee9:	83 c4 10             	add    $0x10,%esp
    2eec:	39 d0                	cmp    %edx,%eax
    2eee:	0f 85 93 02 00 00    	jne    3187 <sbrktest+0x3a7>
  a = sbrk(0);
    2ef4:	83 ec 0c             	sub    $0xc,%esp
    2ef7:	6a 00                	push   $0x0
    2ef9:	e8 1d 0b 00 00       	call   3a1b <sbrk>
  c = sbrk(4096);
    2efe:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  a = sbrk(0);
    2f05:	89 c6                	mov    %eax,%esi
  c = sbrk(4096);
    2f07:	e8 0f 0b 00 00       	call   3a1b <sbrk>
  if(c != a || sbrk(0) != a + 4096){
    2f0c:	83 c4 10             	add    $0x10,%esp
  c = sbrk(4096);
    2f0f:	89 c7                	mov    %eax,%edi
  if(c != a || sbrk(0) != a + 4096){
    2f11:	39 c6                	cmp    %eax,%esi
    2f13:	0f 85 57 02 00 00    	jne    3170 <sbrktest+0x390>
    2f19:	83 ec 0c             	sub    $0xc,%esp
    2f1c:	6a 00                	push   $0x0
    2f1e:	e8 f8 0a 00 00       	call   3a1b <sbrk>
    2f23:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    2f29:	83 c4 10             	add    $0x10,%esp
    2f2c:	39 c2                	cmp    %eax,%edx
    2f2e:	0f 85 3c 02 00 00    	jne    3170 <sbrktest+0x390>
  if(*lastaddr == 99){
    2f34:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2f3b:	0f 84 18 02 00 00    	je     3159 <sbrktest+0x379>
  a = sbrk(0);
    2f41:	83 ec 0c             	sub    $0xc,%esp
    2f44:	6a 00                	push   $0x0
    2f46:	e8 d0 0a 00 00       	call   3a1b <sbrk>
  c = sbrk(-(sbrk(0) - oldbrk));
    2f4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  a = sbrk(0);
    2f52:	89 c6                	mov    %eax,%esi
  c = sbrk(-(sbrk(0) - oldbrk));
    2f54:	e8 c2 0a 00 00       	call   3a1b <sbrk>
    2f59:	89 d9                	mov    %ebx,%ecx
    2f5b:	29 c1                	sub    %eax,%ecx
    2f5d:	89 0c 24             	mov    %ecx,(%esp)
    2f60:	e8 b6 0a 00 00       	call   3a1b <sbrk>
  if(c != a){
    2f65:	83 c4 10             	add    $0x10,%esp
    2f68:	39 c6                	cmp    %eax,%esi
    2f6a:	0f 85 d2 01 00 00    	jne    3142 <sbrktest+0x362>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2f70:	be 00 00 00 80       	mov    $0x80000000,%esi
    2f75:	8d 76 00             	lea    0x0(%esi),%esi
    ppid = getpid();
    2f78:	e8 96 0a 00 00       	call   3a13 <getpid>
    2f7d:	89 c7                	mov    %eax,%edi
    pid = fork();
    2f7f:	e8 07 0a 00 00       	call   398b <fork>
    if(pid < 0){
    2f84:	85 c0                	test   %eax,%eax
    2f86:	0f 88 9e 01 00 00    	js     312a <sbrktest+0x34a>
    if(pid == 0){
    2f8c:	0f 84 76 01 00 00    	je     3108 <sbrktest+0x328>
    wait();
    2f92:	e8 04 0a 00 00       	call   399b <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2f97:	81 c6 50 c3 00 00    	add    $0xc350,%esi
    2f9d:	81 fe 80 84 1e 80    	cmp    $0x801e8480,%esi
    2fa3:	75 d3                	jne    2f78 <sbrktest+0x198>
  if(pipe(fds) != 0){
    2fa5:	83 ec 0c             	sub    $0xc,%esp
    2fa8:	8d 45 b8             	lea    -0x48(%ebp),%eax
    2fab:	50                   	push   %eax
    2fac:	e8 f2 09 00 00       	call   39a3 <pipe>
    2fb1:	83 c4 10             	add    $0x10,%esp
    2fb4:	85 c0                	test   %eax,%eax
    2fb6:	0f 85 34 01 00 00    	jne    30f0 <sbrktest+0x310>
    2fbc:	8d 75 c0             	lea    -0x40(%ebp),%esi
    2fbf:	89 f7                	mov    %esi,%edi
    if((pids[i] = fork()) == 0){
    2fc1:	e8 c5 09 00 00       	call   398b <fork>
    2fc6:	89 07                	mov    %eax,(%edi)
    2fc8:	85 c0                	test   %eax,%eax
    2fca:	0f 84 8f 00 00 00    	je     305f <sbrktest+0x27f>
    if(pids[i] != -1)
    2fd0:	83 f8 ff             	cmp    $0xffffffff,%eax
    2fd3:	74 14                	je     2fe9 <sbrktest+0x209>
      read(fds[0], &scratch, 1);
    2fd5:	83 ec 04             	sub    $0x4,%esp
    2fd8:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2fdb:	6a 01                	push   $0x1
    2fdd:	50                   	push   %eax
    2fde:	ff 75 b8             	pushl  -0x48(%ebp)
    2fe1:	e8 c5 09 00 00       	call   39ab <read>
    2fe6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2fe9:	83 c7 04             	add    $0x4,%edi
    2fec:	8d 45 e8             	lea    -0x18(%ebp),%eax
    2fef:	39 c7                	cmp    %eax,%edi
    2ff1:	75 ce                	jne    2fc1 <sbrktest+0x1e1>
  c = sbrk(4096);
    2ff3:	83 ec 0c             	sub    $0xc,%esp
    2ff6:	68 00 10 00 00       	push   $0x1000
    2ffb:	e8 1b 0a 00 00       	call   3a1b <sbrk>
    3000:	83 c4 10             	add    $0x10,%esp
    3003:	89 c7                	mov    %eax,%edi
    if(pids[i] == -1)
    3005:	8b 06                	mov    (%esi),%eax
    3007:	83 f8 ff             	cmp    $0xffffffff,%eax
    300a:	74 11                	je     301d <sbrktest+0x23d>
    kill(pids[i]);
    300c:	83 ec 0c             	sub    $0xc,%esp
    300f:	50                   	push   %eax
    3010:	e8 ae 09 00 00       	call   39c3 <kill>
    wait();
    3015:	e8 81 09 00 00       	call   399b <wait>
    301a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    301d:	83 c6 04             	add    $0x4,%esi
    3020:	8d 45 e8             	lea    -0x18(%ebp),%eax
    3023:	39 f0                	cmp    %esi,%eax
    3025:	75 de                	jne    3005 <sbrktest+0x225>
  if(c == (char*)0xffffffff){
    3027:	83 ff ff             	cmp    $0xffffffff,%edi
    302a:	0f 84 a9 00 00 00    	je     30d9 <sbrktest+0x2f9>
  if(sbrk(0) > oldbrk)
    3030:	83 ec 0c             	sub    $0xc,%esp
    3033:	6a 00                	push   $0x0
    3035:	e8 e1 09 00 00       	call   3a1b <sbrk>
    303a:	83 c4 10             	add    $0x10,%esp
    303d:	39 c3                	cmp    %eax,%ebx
    303f:	72 61                	jb     30a2 <sbrktest+0x2c2>
  printf(stdout, "sbrk test OK\n");
    3041:	83 ec 08             	sub    $0x8,%esp
    3044:	68 10 4d 00 00       	push   $0x4d10
    3049:	ff 35 10 5f 00 00    	pushl  0x5f10
    304f:	e8 ac 0a 00 00       	call   3b00 <printf>
}
    3054:	83 c4 10             	add    $0x10,%esp
    3057:	8d 65 f4             	lea    -0xc(%ebp),%esp
    305a:	5b                   	pop    %ebx
    305b:	5e                   	pop    %esi
    305c:	5f                   	pop    %edi
    305d:	5d                   	pop    %ebp
    305e:	c3                   	ret    
      sbrk(BIG - (uint)sbrk(0));
    305f:	83 ec 0c             	sub    $0xc,%esp
    3062:	6a 00                	push   $0x0
    3064:	e8 b2 09 00 00       	call   3a1b <sbrk>
    3069:	89 c2                	mov    %eax,%edx
    306b:	b8 00 00 40 06       	mov    $0x6400000,%eax
    3070:	29 d0                	sub    %edx,%eax
    3072:	89 04 24             	mov    %eax,(%esp)
    3075:	e8 a1 09 00 00       	call   3a1b <sbrk>
      write(fds[1], "x", 1);
    307a:	83 c4 0c             	add    $0xc,%esp
    307d:	6a 01                	push   $0x1
    307f:	68 d1 47 00 00       	push   $0x47d1
    3084:	ff 75 bc             	pushl  -0x44(%ebp)
    3087:	e8 27 09 00 00       	call   39b3 <write>
    308c:	83 c4 10             	add    $0x10,%esp
    308f:	90                   	nop
      for(;;) sleep(1000);
    3090:	83 ec 0c             	sub    $0xc,%esp
    3093:	68 e8 03 00 00       	push   $0x3e8
    3098:	e8 86 09 00 00       	call   3a23 <sleep>
    309d:	83 c4 10             	add    $0x10,%esp
    30a0:	eb ee                	jmp    3090 <sbrktest+0x2b0>
    sbrk(-(sbrk(0) - oldbrk));
    30a2:	83 ec 0c             	sub    $0xc,%esp
    30a5:	6a 00                	push   $0x0
    30a7:	e8 6f 09 00 00       	call   3a1b <sbrk>
    30ac:	29 c3                	sub    %eax,%ebx
    30ae:	89 1c 24             	mov    %ebx,(%esp)
    30b1:	e8 65 09 00 00       	call   3a1b <sbrk>
    30b6:	83 c4 10             	add    $0x10,%esp
    30b9:	eb 86                	jmp    3041 <sbrktest+0x261>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    30bb:	83 ec 0c             	sub    $0xc,%esp
    30be:	50                   	push   %eax
    30bf:	56                   	push   %esi
    30c0:	57                   	push   %edi
    30c1:	68 73 4c 00 00       	push   $0x4c73
    30c6:	ff 35 10 5f 00 00    	pushl  0x5f10
    30cc:	e8 2f 0a 00 00       	call   3b00 <printf>
      exit();
    30d1:	83 c4 20             	add    $0x20,%esp
    30d4:	e8 ba 08 00 00       	call   3993 <exit>
    printf(stdout, "failed sbrk leaked memory\n");
    30d9:	50                   	push   %eax
    30da:	50                   	push   %eax
    30db:	68 f5 4c 00 00       	push   $0x4cf5
    30e0:	ff 35 10 5f 00 00    	pushl  0x5f10
    30e6:	e8 15 0a 00 00       	call   3b00 <printf>
    exit();
    30eb:	e8 a3 08 00 00       	call   3993 <exit>
    printf(1, "pipe() failed\n");
    30f0:	52                   	push   %edx
    30f1:	52                   	push   %edx
    30f2:	68 a1 41 00 00       	push   $0x41a1
    30f7:	6a 01                	push   $0x1
    30f9:	e8 02 0a 00 00       	call   3b00 <printf>
    exit();
    30fe:	e8 90 08 00 00       	call   3993 <exit>
    3103:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3107:	90                   	nop
      printf(stdout, "oops could read %x = %x\n", a, *a);
    3108:	0f be 06             	movsbl (%esi),%eax
    310b:	50                   	push   %eax
    310c:	56                   	push   %esi
    310d:	68 dc 4c 00 00       	push   $0x4cdc
    3112:	ff 35 10 5f 00 00    	pushl  0x5f10
    3118:	e8 e3 09 00 00       	call   3b00 <printf>
      kill(ppid);
    311d:	89 3c 24             	mov    %edi,(%esp)
    3120:	e8 9e 08 00 00       	call   39c3 <kill>
      exit();
    3125:	e8 69 08 00 00       	call   3993 <exit>
      printf(stdout, "fork failed\n");
    312a:	83 ec 08             	sub    $0x8,%esp
    312d:	68 b9 4d 00 00       	push   $0x4db9
    3132:	ff 35 10 5f 00 00    	pushl  0x5f10
    3138:	e8 c3 09 00 00       	call   3b00 <printf>
      exit();
    313d:	e8 51 08 00 00       	call   3993 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    3142:	50                   	push   %eax
    3143:	56                   	push   %esi
    3144:	68 bc 54 00 00       	push   $0x54bc
    3149:	ff 35 10 5f 00 00    	pushl  0x5f10
    314f:	e8 ac 09 00 00       	call   3b00 <printf>
    exit();
    3154:	e8 3a 08 00 00       	call   3993 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    3159:	51                   	push   %ecx
    315a:	51                   	push   %ecx
    315b:	68 8c 54 00 00       	push   $0x548c
    3160:	ff 35 10 5f 00 00    	pushl  0x5f10
    3166:	e8 95 09 00 00       	call   3b00 <printf>
    exit();
    316b:	e8 23 08 00 00       	call   3993 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    3170:	57                   	push   %edi
    3171:	56                   	push   %esi
    3172:	68 64 54 00 00       	push   $0x5464
    3177:	ff 35 10 5f 00 00    	pushl  0x5f10
    317d:	e8 7e 09 00 00       	call   3b00 <printf>
    exit();
    3182:	e8 0c 08 00 00       	call   3993 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    3187:	50                   	push   %eax
    3188:	56                   	push   %esi
    3189:	68 2c 54 00 00       	push   $0x542c
    318e:	ff 35 10 5f 00 00    	pushl  0x5f10
    3194:	e8 67 09 00 00       	call   3b00 <printf>
    exit();
    3199:	e8 f5 07 00 00       	call   3993 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    319e:	53                   	push   %ebx
    319f:	53                   	push   %ebx
    31a0:	68 c1 4c 00 00       	push   $0x4cc1
    31a5:	ff 35 10 5f 00 00    	pushl  0x5f10
    31ab:	e8 50 09 00 00       	call   3b00 <printf>
    exit();
    31b0:	e8 de 07 00 00       	call   3993 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    31b5:	56                   	push   %esi
    31b6:	56                   	push   %esi
    31b7:	68 ec 53 00 00       	push   $0x53ec
    31bc:	ff 35 10 5f 00 00    	pushl  0x5f10
    31c2:	e8 39 09 00 00       	call   3b00 <printf>
    exit();
    31c7:	e8 c7 07 00 00       	call   3993 <exit>
    exit();
    31cc:	e8 c2 07 00 00       	call   3993 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    31d1:	57                   	push   %edi
    31d2:	57                   	push   %edi
    31d3:	68 a5 4c 00 00       	push   $0x4ca5
    31d8:	ff 35 10 5f 00 00    	pushl  0x5f10
    31de:	e8 1d 09 00 00       	call   3b00 <printf>
    exit();
    31e3:	e8 ab 07 00 00       	call   3993 <exit>
    printf(stdout, "sbrk test fork failed\n");
    31e8:	50                   	push   %eax
    31e9:	50                   	push   %eax
    31ea:	68 8e 4c 00 00       	push   $0x4c8e
    31ef:	ff 35 10 5f 00 00    	pushl  0x5f10
    31f5:	e8 06 09 00 00       	call   3b00 <printf>
    exit();
    31fa:	e8 94 07 00 00       	call   3993 <exit>
    31ff:	90                   	nop

00003200 <validateint>:
{
    3200:	f3 0f 1e fb          	endbr32 
}
    3204:	c3                   	ret    
    3205:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    320c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003210 <validatetest>:
{
    3210:	f3 0f 1e fb          	endbr32 
    3214:	55                   	push   %ebp
    3215:	89 e5                	mov    %esp,%ebp
    3217:	56                   	push   %esi
  for(p = 0; p <= (uint)hi; p += 4096){
    3218:	31 f6                	xor    %esi,%esi
{
    321a:	53                   	push   %ebx
  printf(stdout, "validate test\n");
    321b:	83 ec 08             	sub    $0x8,%esp
    321e:	68 1e 4d 00 00       	push   $0x4d1e
    3223:	ff 35 10 5f 00 00    	pushl  0x5f10
    3229:	e8 d2 08 00 00       	call   3b00 <printf>
    322e:	83 c4 10             	add    $0x10,%esp
    3231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((pid = fork()) == 0){
    3238:	e8 4e 07 00 00       	call   398b <fork>
    323d:	89 c3                	mov    %eax,%ebx
    323f:	85 c0                	test   %eax,%eax
    3241:	74 63                	je     32a6 <validatetest+0x96>
    sleep(0);
    3243:	83 ec 0c             	sub    $0xc,%esp
    3246:	6a 00                	push   $0x0
    3248:	e8 d6 07 00 00       	call   3a23 <sleep>
    sleep(0);
    324d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3254:	e8 ca 07 00 00       	call   3a23 <sleep>
    kill(pid);
    3259:	89 1c 24             	mov    %ebx,(%esp)
    325c:	e8 62 07 00 00       	call   39c3 <kill>
    wait();
    3261:	e8 35 07 00 00       	call   399b <wait>
    if(link("nosuchfile", (char*)p) != -1){
    3266:	58                   	pop    %eax
    3267:	5a                   	pop    %edx
    3268:	56                   	push   %esi
    3269:	68 2d 4d 00 00       	push   $0x4d2d
    326e:	e8 80 07 00 00       	call   39f3 <link>
    3273:	83 c4 10             	add    $0x10,%esp
    3276:	83 f8 ff             	cmp    $0xffffffff,%eax
    3279:	75 30                	jne    32ab <validatetest+0x9b>
  for(p = 0; p <= (uint)hi; p += 4096){
    327b:	81 c6 00 10 00 00    	add    $0x1000,%esi
    3281:	81 fe 00 40 11 00    	cmp    $0x114000,%esi
    3287:	75 af                	jne    3238 <validatetest+0x28>
  printf(stdout, "validate ok\n");
    3289:	83 ec 08             	sub    $0x8,%esp
    328c:	68 51 4d 00 00       	push   $0x4d51
    3291:	ff 35 10 5f 00 00    	pushl  0x5f10
    3297:	e8 64 08 00 00       	call   3b00 <printf>
}
    329c:	83 c4 10             	add    $0x10,%esp
    329f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    32a2:	5b                   	pop    %ebx
    32a3:	5e                   	pop    %esi
    32a4:	5d                   	pop    %ebp
    32a5:	c3                   	ret    
      exit();
    32a6:	e8 e8 06 00 00       	call   3993 <exit>
      printf(stdout, "link should not succeed\n");
    32ab:	83 ec 08             	sub    $0x8,%esp
    32ae:	68 38 4d 00 00       	push   $0x4d38
    32b3:	ff 35 10 5f 00 00    	pushl  0x5f10
    32b9:	e8 42 08 00 00       	call   3b00 <printf>
      exit();
    32be:	e8 d0 06 00 00       	call   3993 <exit>
    32c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    32ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000032d0 <bsstest>:
{
    32d0:	f3 0f 1e fb          	endbr32 
    32d4:	55                   	push   %ebp
    32d5:	89 e5                	mov    %esp,%ebp
    32d7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "bss test\n");
    32da:	68 5e 4d 00 00       	push   $0x4d5e
    32df:	ff 35 10 5f 00 00    	pushl  0x5f10
    32e5:	e8 16 08 00 00       	call   3b00 <printf>
    32ea:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sizeof(uninit); i++){
    32ed:	31 c0                	xor    %eax,%eax
    32ef:	90                   	nop
    if(uninit[i] != '\0'){
    32f0:	80 b8 e0 5f 00 00 00 	cmpb   $0x0,0x5fe0(%eax)
    32f7:	75 22                	jne    331b <bsstest+0x4b>
  for(i = 0; i < sizeof(uninit); i++){
    32f9:	83 c0 01             	add    $0x1,%eax
    32fc:	3d 10 27 00 00       	cmp    $0x2710,%eax
    3301:	75 ed                	jne    32f0 <bsstest+0x20>
  printf(stdout, "bss test ok\n");
    3303:	83 ec 08             	sub    $0x8,%esp
    3306:	68 79 4d 00 00       	push   $0x4d79
    330b:	ff 35 10 5f 00 00    	pushl  0x5f10
    3311:	e8 ea 07 00 00       	call   3b00 <printf>
}
    3316:	83 c4 10             	add    $0x10,%esp
    3319:	c9                   	leave  
    331a:	c3                   	ret    
      printf(stdout, "bss test failed\n");
    331b:	83 ec 08             	sub    $0x8,%esp
    331e:	68 68 4d 00 00       	push   $0x4d68
    3323:	ff 35 10 5f 00 00    	pushl  0x5f10
    3329:	e8 d2 07 00 00       	call   3b00 <printf>
      exit();
    332e:	e8 60 06 00 00       	call   3993 <exit>
    3333:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003340 <bigargtest>:
{
    3340:	f3 0f 1e fb          	endbr32 
    3344:	55                   	push   %ebp
    3345:	89 e5                	mov    %esp,%ebp
    3347:	83 ec 14             	sub    $0x14,%esp
  unlink("bigarg-ok");
    334a:	68 86 4d 00 00       	push   $0x4d86
    334f:	e8 8f 06 00 00       	call   39e3 <unlink>
  pid = fork();
    3354:	e8 32 06 00 00       	call   398b <fork>
  if(pid == 0){
    3359:	83 c4 10             	add    $0x10,%esp
    335c:	85 c0                	test   %eax,%eax
    335e:	74 40                	je     33a0 <bigargtest+0x60>
  } else if(pid < 0){
    3360:	0f 88 c1 00 00 00    	js     3427 <bigargtest+0xe7>
  wait();
    3366:	e8 30 06 00 00       	call   399b <wait>
  fd = open("bigarg-ok", 0);
    336b:	83 ec 08             	sub    $0x8,%esp
    336e:	6a 00                	push   $0x0
    3370:	68 86 4d 00 00       	push   $0x4d86
    3375:	e8 59 06 00 00       	call   39d3 <open>
  if(fd < 0){
    337a:	83 c4 10             	add    $0x10,%esp
    337d:	85 c0                	test   %eax,%eax
    337f:	0f 88 8b 00 00 00    	js     3410 <bigargtest+0xd0>
  close(fd);
    3385:	83 ec 0c             	sub    $0xc,%esp
    3388:	50                   	push   %eax
    3389:	e8 2d 06 00 00       	call   39bb <close>
  unlink("bigarg-ok");
    338e:	c7 04 24 86 4d 00 00 	movl   $0x4d86,(%esp)
    3395:	e8 49 06 00 00       	call   39e3 <unlink>
}
    339a:	83 c4 10             	add    $0x10,%esp
    339d:	c9                   	leave  
    339e:	c3                   	ret    
    339f:	90                   	nop
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    33a0:	c7 04 85 40 5f 00 00 	movl   $0x54e0,0x5f40(,%eax,4)
    33a7:	e0 54 00 00 
    for(i = 0; i < MAXARG-1; i++)
    33ab:	83 c0 01             	add    $0x1,%eax
    33ae:	83 f8 1f             	cmp    $0x1f,%eax
    33b1:	75 ed                	jne    33a0 <bigargtest+0x60>
    printf(stdout, "bigarg test\n");
    33b3:	51                   	push   %ecx
    33b4:	51                   	push   %ecx
    33b5:	68 90 4d 00 00       	push   $0x4d90
    33ba:	ff 35 10 5f 00 00    	pushl  0x5f10
    args[MAXARG-1] = 0;
    33c0:	c7 05 bc 5f 00 00 00 	movl   $0x0,0x5fbc
    33c7:	00 00 00 
    printf(stdout, "bigarg test\n");
    33ca:	e8 31 07 00 00       	call   3b00 <printf>
    exec("echo", args);
    33cf:	58                   	pop    %eax
    33d0:	5a                   	pop    %edx
    33d1:	68 40 5f 00 00       	push   $0x5f40
    33d6:	68 4d 3f 00 00       	push   $0x3f4d
    33db:	e8 eb 05 00 00       	call   39cb <exec>
    printf(stdout, "bigarg test ok\n");
    33e0:	59                   	pop    %ecx
    33e1:	58                   	pop    %eax
    33e2:	68 9d 4d 00 00       	push   $0x4d9d
    33e7:	ff 35 10 5f 00 00    	pushl  0x5f10
    33ed:	e8 0e 07 00 00       	call   3b00 <printf>
    fd = open("bigarg-ok", O_CREATE);
    33f2:	58                   	pop    %eax
    33f3:	5a                   	pop    %edx
    33f4:	68 00 02 00 00       	push   $0x200
    33f9:	68 86 4d 00 00       	push   $0x4d86
    33fe:	e8 d0 05 00 00       	call   39d3 <open>
    close(fd);
    3403:	89 04 24             	mov    %eax,(%esp)
    3406:	e8 b0 05 00 00       	call   39bb <close>
    exit();
    340b:	e8 83 05 00 00       	call   3993 <exit>
    printf(stdout, "bigarg test failed!\n");
    3410:	50                   	push   %eax
    3411:	50                   	push   %eax
    3412:	68 c6 4d 00 00       	push   $0x4dc6
    3417:	ff 35 10 5f 00 00    	pushl  0x5f10
    341d:	e8 de 06 00 00       	call   3b00 <printf>
    exit();
    3422:	e8 6c 05 00 00       	call   3993 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    3427:	52                   	push   %edx
    3428:	52                   	push   %edx
    3429:	68 ad 4d 00 00       	push   $0x4dad
    342e:	ff 35 10 5f 00 00    	pushl  0x5f10
    3434:	e8 c7 06 00 00       	call   3b00 <printf>
    exit();
    3439:	e8 55 05 00 00       	call   3993 <exit>
    343e:	66 90                	xchg   %ax,%ax

00003440 <fsfull>:
{
    3440:	f3 0f 1e fb          	endbr32 
    3444:	55                   	push   %ebp
    3445:	89 e5                	mov    %esp,%ebp
    3447:	57                   	push   %edi
    3448:	56                   	push   %esi
  for(nfiles = 0; ; nfiles++){
    3449:	31 f6                	xor    %esi,%esi
{
    344b:	53                   	push   %ebx
    344c:	83 ec 54             	sub    $0x54,%esp
  printf(1, "fsfull test\n");
    344f:	68 db 4d 00 00       	push   $0x4ddb
    3454:	6a 01                	push   $0x1
    3456:	e8 a5 06 00 00       	call   3b00 <printf>
    345b:	83 c4 10             	add    $0x10,%esp
    345e:	66 90                	xchg   %ax,%ax
    name[1] = '0' + nfiles / 1000;
    3460:	b8 d3 4d 62 10       	mov    $0x10624dd3,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    3465:	b9 cd cc cc cc       	mov    $0xcccccccd,%ecx
    printf(1, "writing %s\n", name);
    346a:	83 ec 04             	sub    $0x4,%esp
    name[0] = 'f';
    346d:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3471:	f7 e6                	mul    %esi
    name[5] = '\0';
    3473:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3477:	c1 ea 06             	shr    $0x6,%edx
    347a:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    347d:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3483:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3486:	89 f0                	mov    %esi,%eax
    3488:	29 d0                	sub    %edx,%eax
    348a:	89 c2                	mov    %eax,%edx
    348c:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    3491:	f7 e2                	mul    %edx
    name[3] = '0' + (nfiles % 100) / 10;
    3493:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    3498:	c1 ea 05             	shr    $0x5,%edx
    349b:	83 c2 30             	add    $0x30,%edx
    349e:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    34a1:	f7 e6                	mul    %esi
    34a3:	89 f0                	mov    %esi,%eax
    34a5:	c1 ea 05             	shr    $0x5,%edx
    34a8:	6b d2 64             	imul   $0x64,%edx,%edx
    34ab:	29 d0                	sub    %edx,%eax
    34ad:	f7 e1                	mul    %ecx
    name[4] = '0' + (nfiles % 10);
    34af:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    34b1:	c1 ea 03             	shr    $0x3,%edx
    34b4:	83 c2 30             	add    $0x30,%edx
    34b7:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    34ba:	f7 e1                	mul    %ecx
    34bc:	89 f1                	mov    %esi,%ecx
    34be:	c1 ea 03             	shr    $0x3,%edx
    34c1:	8d 04 92             	lea    (%edx,%edx,4),%eax
    34c4:	01 c0                	add    %eax,%eax
    34c6:	29 c1                	sub    %eax,%ecx
    34c8:	89 c8                	mov    %ecx,%eax
    34ca:	83 c0 30             	add    $0x30,%eax
    34cd:	88 45 ac             	mov    %al,-0x54(%ebp)
    printf(1, "writing %s\n", name);
    34d0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34d3:	50                   	push   %eax
    34d4:	68 e8 4d 00 00       	push   $0x4de8
    34d9:	6a 01                	push   $0x1
    34db:	e8 20 06 00 00       	call   3b00 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    34e0:	58                   	pop    %eax
    34e1:	8d 45 a8             	lea    -0x58(%ebp),%eax
    34e4:	5a                   	pop    %edx
    34e5:	68 02 02 00 00       	push   $0x202
    34ea:	50                   	push   %eax
    34eb:	e8 e3 04 00 00       	call   39d3 <open>
    if(fd < 0){
    34f0:	83 c4 10             	add    $0x10,%esp
    int fd = open(name, O_CREATE|O_RDWR);
    34f3:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    34f5:	85 c0                	test   %eax,%eax
    34f7:	78 4d                	js     3546 <fsfull+0x106>
    int total = 0;
    34f9:	31 db                	xor    %ebx,%ebx
    34fb:	eb 05                	jmp    3502 <fsfull+0xc2>
    34fd:	8d 76 00             	lea    0x0(%esi),%esi
      total += cc;
    3500:	01 c3                	add    %eax,%ebx
      int cc = write(fd, buf, 512);
    3502:	83 ec 04             	sub    $0x4,%esp
    3505:	68 00 02 00 00       	push   $0x200
    350a:	68 00 87 00 00       	push   $0x8700
    350f:	57                   	push   %edi
    3510:	e8 9e 04 00 00       	call   39b3 <write>
      if(cc < 512)
    3515:	83 c4 10             	add    $0x10,%esp
    3518:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    351d:	7f e1                	jg     3500 <fsfull+0xc0>
    printf(1, "wrote %d bytes\n", total);
    351f:	83 ec 04             	sub    $0x4,%esp
    3522:	53                   	push   %ebx
    3523:	68 04 4e 00 00       	push   $0x4e04
    3528:	6a 01                	push   $0x1
    352a:	e8 d1 05 00 00       	call   3b00 <printf>
    close(fd);
    352f:	89 3c 24             	mov    %edi,(%esp)
    3532:	e8 84 04 00 00       	call   39bb <close>
    if(total == 0)
    3537:	83 c4 10             	add    $0x10,%esp
    353a:	85 db                	test   %ebx,%ebx
    353c:	74 1e                	je     355c <fsfull+0x11c>
  for(nfiles = 0; ; nfiles++){
    353e:	83 c6 01             	add    $0x1,%esi
    3541:	e9 1a ff ff ff       	jmp    3460 <fsfull+0x20>
      printf(1, "open %s failed\n", name);
    3546:	83 ec 04             	sub    $0x4,%esp
    3549:	8d 45 a8             	lea    -0x58(%ebp),%eax
    354c:	50                   	push   %eax
    354d:	68 f4 4d 00 00       	push   $0x4df4
    3552:	6a 01                	push   $0x1
    3554:	e8 a7 05 00 00       	call   3b00 <printf>
      break;
    3559:	83 c4 10             	add    $0x10,%esp
    name[1] = '0' + nfiles / 1000;
    355c:	bf d3 4d 62 10       	mov    $0x10624dd3,%edi
    name[2] = '0' + (nfiles % 1000) / 100;
    3561:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
    3566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    356d:	8d 76 00             	lea    0x0(%esi),%esi
    name[1] = '0' + nfiles / 1000;
    3570:	89 f0                	mov    %esi,%eax
    3572:	89 f1                	mov    %esi,%ecx
    unlink(name);
    3574:	83 ec 0c             	sub    $0xc,%esp
    name[0] = 'f';
    3577:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    357b:	f7 ef                	imul   %edi
    357d:	c1 f9 1f             	sar    $0x1f,%ecx
    name[5] = '\0';
    3580:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    name[1] = '0' + nfiles / 1000;
    3584:	c1 fa 06             	sar    $0x6,%edx
    3587:	29 ca                	sub    %ecx,%edx
    3589:	8d 42 30             	lea    0x30(%edx),%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    358c:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    name[1] = '0' + nfiles / 1000;
    3592:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3595:	89 f0                	mov    %esi,%eax
    3597:	29 d0                	sub    %edx,%eax
    3599:	f7 e3                	mul    %ebx
    name[3] = '0' + (nfiles % 100) / 10;
    359b:	89 f0                	mov    %esi,%eax
    name[2] = '0' + (nfiles % 1000) / 100;
    359d:	c1 ea 05             	shr    $0x5,%edx
    35a0:	83 c2 30             	add    $0x30,%edx
    35a3:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    35a6:	f7 eb                	imul   %ebx
    35a8:	89 f0                	mov    %esi,%eax
    35aa:	c1 fa 05             	sar    $0x5,%edx
    35ad:	29 ca                	sub    %ecx,%edx
    35af:	6b d2 64             	imul   $0x64,%edx,%edx
    35b2:	29 d0                	sub    %edx,%eax
    35b4:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
    35b9:	f7 e2                	mul    %edx
    name[4] = '0' + (nfiles % 10);
    35bb:	89 f0                	mov    %esi,%eax
    name[3] = '0' + (nfiles % 100) / 10;
    35bd:	c1 ea 03             	shr    $0x3,%edx
    35c0:	83 c2 30             	add    $0x30,%edx
    35c3:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    35c6:	ba 67 66 66 66       	mov    $0x66666667,%edx
    35cb:	f7 ea                	imul   %edx
    35cd:	c1 fa 02             	sar    $0x2,%edx
    35d0:	29 ca                	sub    %ecx,%edx
    35d2:	89 f1                	mov    %esi,%ecx
    nfiles--;
    35d4:	83 ee 01             	sub    $0x1,%esi
    name[4] = '0' + (nfiles % 10);
    35d7:	8d 04 92             	lea    (%edx,%edx,4),%eax
    35da:	01 c0                	add    %eax,%eax
    35dc:	29 c1                	sub    %eax,%ecx
    35de:	89 c8                	mov    %ecx,%eax
    35e0:	83 c0 30             	add    $0x30,%eax
    35e3:	88 45 ac             	mov    %al,-0x54(%ebp)
    unlink(name);
    35e6:	8d 45 a8             	lea    -0x58(%ebp),%eax
    35e9:	50                   	push   %eax
    35ea:	e8 f4 03 00 00       	call   39e3 <unlink>
  while(nfiles >= 0){
    35ef:	83 c4 10             	add    $0x10,%esp
    35f2:	83 fe ff             	cmp    $0xffffffff,%esi
    35f5:	0f 85 75 ff ff ff    	jne    3570 <fsfull+0x130>
  printf(1, "fsfull test finished\n");
    35fb:	83 ec 08             	sub    $0x8,%esp
    35fe:	68 14 4e 00 00       	push   $0x4e14
    3603:	6a 01                	push   $0x1
    3605:	e8 f6 04 00 00       	call   3b00 <printf>
}
    360a:	83 c4 10             	add    $0x10,%esp
    360d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3610:	5b                   	pop    %ebx
    3611:	5e                   	pop    %esi
    3612:	5f                   	pop    %edi
    3613:	5d                   	pop    %ebp
    3614:	c3                   	ret    
    3615:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    361c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003620 <uio>:
{
    3620:	f3 0f 1e fb          	endbr32 
    3624:	55                   	push   %ebp
    3625:	89 e5                	mov    %esp,%ebp
    3627:	83 ec 10             	sub    $0x10,%esp
  printf(1, "uio test\n");
    362a:	68 2a 4e 00 00       	push   $0x4e2a
    362f:	6a 01                	push   $0x1
    3631:	e8 ca 04 00 00       	call   3b00 <printf>
  pid = fork();
    3636:	e8 50 03 00 00       	call   398b <fork>
  if(pid == 0){
    363b:	83 c4 10             	add    $0x10,%esp
    363e:	85 c0                	test   %eax,%eax
    3640:	74 1b                	je     365d <uio+0x3d>
  } else if(pid < 0){
    3642:	78 3d                	js     3681 <uio+0x61>
  wait();
    3644:	e8 52 03 00 00       	call   399b <wait>
  printf(1, "uio test done\n");
    3649:	83 ec 08             	sub    $0x8,%esp
    364c:	68 34 4e 00 00       	push   $0x4e34
    3651:	6a 01                	push   $0x1
    3653:	e8 a8 04 00 00       	call   3b00 <printf>
}
    3658:	83 c4 10             	add    $0x10,%esp
    365b:	c9                   	leave  
    365c:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    365d:	b8 09 00 00 00       	mov    $0x9,%eax
    3662:	ba 70 00 00 00       	mov    $0x70,%edx
    3667:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3668:	ba 71 00 00 00       	mov    $0x71,%edx
    366d:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    366e:	52                   	push   %edx
    366f:	52                   	push   %edx
    3670:	68 c0 55 00 00       	push   $0x55c0
    3675:	6a 01                	push   $0x1
    3677:	e8 84 04 00 00       	call   3b00 <printf>
    exit();
    367c:	e8 12 03 00 00       	call   3993 <exit>
    printf (1, "fork failed\n");
    3681:	50                   	push   %eax
    3682:	50                   	push   %eax
    3683:	68 b9 4d 00 00       	push   $0x4db9
    3688:	6a 01                	push   $0x1
    368a:	e8 71 04 00 00       	call   3b00 <printf>
    exit();
    368f:	e8 ff 02 00 00       	call   3993 <exit>
    3694:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    369b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    369f:	90                   	nop

000036a0 <argptest>:
{
    36a0:	f3 0f 1e fb          	endbr32 
    36a4:	55                   	push   %ebp
    36a5:	89 e5                	mov    %esp,%ebp
    36a7:	53                   	push   %ebx
    36a8:	83 ec 0c             	sub    $0xc,%esp
  fd = open("init", O_RDONLY);
    36ab:	6a 00                	push   $0x0
    36ad:	68 43 4e 00 00       	push   $0x4e43
    36b2:	e8 1c 03 00 00       	call   39d3 <open>
  if (fd < 0) {
    36b7:	83 c4 10             	add    $0x10,%esp
    36ba:	85 c0                	test   %eax,%eax
    36bc:	78 39                	js     36f7 <argptest+0x57>
  read(fd, sbrk(0) - 1, -1);
    36be:	83 ec 0c             	sub    $0xc,%esp
    36c1:	89 c3                	mov    %eax,%ebx
    36c3:	6a 00                	push   $0x0
    36c5:	e8 51 03 00 00       	call   3a1b <sbrk>
    36ca:	83 c4 0c             	add    $0xc,%esp
    36cd:	83 e8 01             	sub    $0x1,%eax
    36d0:	6a ff                	push   $0xffffffff
    36d2:	50                   	push   %eax
    36d3:	53                   	push   %ebx
    36d4:	e8 d2 02 00 00       	call   39ab <read>
  close(fd);
    36d9:	89 1c 24             	mov    %ebx,(%esp)
    36dc:	e8 da 02 00 00       	call   39bb <close>
  printf(1, "arg test passed\n");
    36e1:	58                   	pop    %eax
    36e2:	5a                   	pop    %edx
    36e3:	68 55 4e 00 00       	push   $0x4e55
    36e8:	6a 01                	push   $0x1
    36ea:	e8 11 04 00 00       	call   3b00 <printf>
}
    36ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    36f2:	83 c4 10             	add    $0x10,%esp
    36f5:	c9                   	leave  
    36f6:	c3                   	ret    
    printf(2, "open failed\n");
    36f7:	51                   	push   %ecx
    36f8:	51                   	push   %ecx
    36f9:	68 48 4e 00 00       	push   $0x4e48
    36fe:	6a 02                	push   $0x2
    3700:	e8 fb 03 00 00       	call   3b00 <printf>
    exit();
    3705:	e8 89 02 00 00       	call   3993 <exit>
    370a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003710 <rand>:
{
    3710:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    3714:	69 05 0c 5f 00 00 0d 	imul   $0x19660d,0x5f0c,%eax
    371b:	66 19 00 
    371e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    3723:	a3 0c 5f 00 00       	mov    %eax,0x5f0c
}
    3728:	c3                   	ret    
    3729:	66 90                	xchg   %ax,%ax
    372b:	66 90                	xchg   %ax,%ax
    372d:	66 90                	xchg   %ax,%ax
    372f:	90                   	nop

00003730 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3730:	f3 0f 1e fb          	endbr32 
    3734:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3735:	31 c0                	xor    %eax,%eax
{
    3737:	89 e5                	mov    %esp,%ebp
    3739:	53                   	push   %ebx
    373a:	8b 4d 08             	mov    0x8(%ebp),%ecx
    373d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
    3740:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
    3744:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    3747:	83 c0 01             	add    $0x1,%eax
    374a:	84 d2                	test   %dl,%dl
    374c:	75 f2                	jne    3740 <strcpy+0x10>
    ;
  return os;
}
    374e:	89 c8                	mov    %ecx,%eax
    3750:	5b                   	pop    %ebx
    3751:	5d                   	pop    %ebp
    3752:	c3                   	ret    
    3753:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    375a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003760 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    3760:	f3 0f 1e fb          	endbr32 
    3764:	55                   	push   %ebp
    3765:	89 e5                	mov    %esp,%ebp
    3767:	53                   	push   %ebx
    3768:	8b 4d 08             	mov    0x8(%ebp),%ecx
    376b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    376e:	0f b6 01             	movzbl (%ecx),%eax
    3771:	0f b6 1a             	movzbl (%edx),%ebx
    3774:	84 c0                	test   %al,%al
    3776:	75 19                	jne    3791 <strcmp+0x31>
    3778:	eb 26                	jmp    37a0 <strcmp+0x40>
    377a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    3780:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
    3784:	83 c1 01             	add    $0x1,%ecx
    3787:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
    378a:	0f b6 1a             	movzbl (%edx),%ebx
    378d:	84 c0                	test   %al,%al
    378f:	74 0f                	je     37a0 <strcmp+0x40>
    3791:	38 d8                	cmp    %bl,%al
    3793:	74 eb                	je     3780 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
    3795:	29 d8                	sub    %ebx,%eax
}
    3797:	5b                   	pop    %ebx
    3798:	5d                   	pop    %ebp
    3799:	c3                   	ret    
    379a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    37a0:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    37a2:	29 d8                	sub    %ebx,%eax
}
    37a4:	5b                   	pop    %ebx
    37a5:	5d                   	pop    %ebp
    37a6:	c3                   	ret    
    37a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37ae:	66 90                	xchg   %ax,%ax

000037b0 <strlen>:

uint
strlen(const char *s)
{
    37b0:	f3 0f 1e fb          	endbr32 
    37b4:	55                   	push   %ebp
    37b5:	89 e5                	mov    %esp,%ebp
    37b7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    37ba:	80 3a 00             	cmpb   $0x0,(%edx)
    37bd:	74 21                	je     37e0 <strlen+0x30>
    37bf:	31 c0                	xor    %eax,%eax
    37c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37c8:	83 c0 01             	add    $0x1,%eax
    37cb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    37cf:	89 c1                	mov    %eax,%ecx
    37d1:	75 f5                	jne    37c8 <strlen+0x18>
    ;
  return n;
}
    37d3:	89 c8                	mov    %ecx,%eax
    37d5:	5d                   	pop    %ebp
    37d6:	c3                   	ret    
    37d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37de:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
    37e0:	31 c9                	xor    %ecx,%ecx
}
    37e2:	5d                   	pop    %ebp
    37e3:	89 c8                	mov    %ecx,%eax
    37e5:	c3                   	ret    
    37e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    37ed:	8d 76 00             	lea    0x0(%esi),%esi

000037f0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    37f0:	f3 0f 1e fb          	endbr32 
    37f4:	55                   	push   %ebp
    37f5:	89 e5                	mov    %esp,%ebp
    37f7:	57                   	push   %edi
    37f8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    37fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
    37fe:	8b 45 0c             	mov    0xc(%ebp),%eax
    3801:	89 d7                	mov    %edx,%edi
    3803:	fc                   	cld    
    3804:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    3806:	89 d0                	mov    %edx,%eax
    3808:	5f                   	pop    %edi
    3809:	5d                   	pop    %ebp
    380a:	c3                   	ret    
    380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    380f:	90                   	nop

00003810 <strchr>:

char*
strchr(const char *s, char c)
{
    3810:	f3 0f 1e fb          	endbr32 
    3814:	55                   	push   %ebp
    3815:	89 e5                	mov    %esp,%ebp
    3817:	8b 45 08             	mov    0x8(%ebp),%eax
    381a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    381e:	0f b6 10             	movzbl (%eax),%edx
    3821:	84 d2                	test   %dl,%dl
    3823:	75 16                	jne    383b <strchr+0x2b>
    3825:	eb 21                	jmp    3848 <strchr+0x38>
    3827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    382e:	66 90                	xchg   %ax,%ax
    3830:	0f b6 50 01          	movzbl 0x1(%eax),%edx
    3834:	83 c0 01             	add    $0x1,%eax
    3837:	84 d2                	test   %dl,%dl
    3839:	74 0d                	je     3848 <strchr+0x38>
    if(*s == c)
    383b:	38 d1                	cmp    %dl,%cl
    383d:	75 f1                	jne    3830 <strchr+0x20>
      return (char*)s;
  return 0;
}
    383f:	5d                   	pop    %ebp
    3840:	c3                   	ret    
    3841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
    3848:	31 c0                	xor    %eax,%eax
}
    384a:	5d                   	pop    %ebp
    384b:	c3                   	ret    
    384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003850 <gets>:

char*
gets(char *buf, int max)
{
    3850:	f3 0f 1e fb          	endbr32 
    3854:	55                   	push   %ebp
    3855:	89 e5                	mov    %esp,%ebp
    3857:	57                   	push   %edi
    3858:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    3859:	31 f6                	xor    %esi,%esi
{
    385b:	53                   	push   %ebx
    385c:	89 f3                	mov    %esi,%ebx
    385e:	83 ec 1c             	sub    $0x1c,%esp
    3861:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
    3864:	eb 33                	jmp    3899 <gets+0x49>
    3866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    386d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
    3870:	83 ec 04             	sub    $0x4,%esp
    3873:	8d 45 e7             	lea    -0x19(%ebp),%eax
    3876:	6a 01                	push   $0x1
    3878:	50                   	push   %eax
    3879:	6a 00                	push   $0x0
    387b:	e8 2b 01 00 00       	call   39ab <read>
    if(cc < 1)
    3880:	83 c4 10             	add    $0x10,%esp
    3883:	85 c0                	test   %eax,%eax
    3885:	7e 1c                	jle    38a3 <gets+0x53>
      break;
    buf[i++] = c;
    3887:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    388b:	83 c7 01             	add    $0x1,%edi
    388e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
    3891:	3c 0a                	cmp    $0xa,%al
    3893:	74 23                	je     38b8 <gets+0x68>
    3895:	3c 0d                	cmp    $0xd,%al
    3897:	74 1f                	je     38b8 <gets+0x68>
  for(i=0; i+1 < max; ){
    3899:	83 c3 01             	add    $0x1,%ebx
    389c:	89 fe                	mov    %edi,%esi
    389e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    38a1:	7c cd                	jl     3870 <gets+0x20>
    38a3:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
    38a5:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
    38a8:	c6 03 00             	movb   $0x0,(%ebx)
}
    38ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
    38ae:	5b                   	pop    %ebx
    38af:	5e                   	pop    %esi
    38b0:	5f                   	pop    %edi
    38b1:	5d                   	pop    %ebp
    38b2:	c3                   	ret    
    38b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    38b7:	90                   	nop
    38b8:	8b 75 08             	mov    0x8(%ebp),%esi
    38bb:	8b 45 08             	mov    0x8(%ebp),%eax
    38be:	01 de                	add    %ebx,%esi
    38c0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
    38c2:	c6 03 00             	movb   $0x0,(%ebx)
}
    38c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
    38c8:	5b                   	pop    %ebx
    38c9:	5e                   	pop    %esi
    38ca:	5f                   	pop    %edi
    38cb:	5d                   	pop    %ebp
    38cc:	c3                   	ret    
    38cd:	8d 76 00             	lea    0x0(%esi),%esi

000038d0 <stat>:

int
stat(const char *n, struct stat *st)
{
    38d0:	f3 0f 1e fb          	endbr32 
    38d4:	55                   	push   %ebp
    38d5:	89 e5                	mov    %esp,%ebp
    38d7:	56                   	push   %esi
    38d8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    38d9:	83 ec 08             	sub    $0x8,%esp
    38dc:	6a 00                	push   $0x0
    38de:	ff 75 08             	pushl  0x8(%ebp)
    38e1:	e8 ed 00 00 00       	call   39d3 <open>
  if(fd < 0)
    38e6:	83 c4 10             	add    $0x10,%esp
    38e9:	85 c0                	test   %eax,%eax
    38eb:	78 2b                	js     3918 <stat+0x48>
    return -1;
  r = fstat(fd, st);
    38ed:	83 ec 08             	sub    $0x8,%esp
    38f0:	ff 75 0c             	pushl  0xc(%ebp)
    38f3:	89 c3                	mov    %eax,%ebx
    38f5:	50                   	push   %eax
    38f6:	e8 f0 00 00 00       	call   39eb <fstat>
  close(fd);
    38fb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    38fe:	89 c6                	mov    %eax,%esi
  close(fd);
    3900:	e8 b6 00 00 00       	call   39bb <close>
  return r;
    3905:	83 c4 10             	add    $0x10,%esp
}
    3908:	8d 65 f8             	lea    -0x8(%ebp),%esp
    390b:	89 f0                	mov    %esi,%eax
    390d:	5b                   	pop    %ebx
    390e:	5e                   	pop    %esi
    390f:	5d                   	pop    %ebp
    3910:	c3                   	ret    
    3911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    3918:	be ff ff ff ff       	mov    $0xffffffff,%esi
    391d:	eb e9                	jmp    3908 <stat+0x38>
    391f:	90                   	nop

00003920 <atoi>:

int
atoi(const char *s)
{
    3920:	f3 0f 1e fb          	endbr32 
    3924:	55                   	push   %ebp
    3925:	89 e5                	mov    %esp,%ebp
    3927:	53                   	push   %ebx
    3928:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    392b:	0f be 02             	movsbl (%edx),%eax
    392e:	8d 48 d0             	lea    -0x30(%eax),%ecx
    3931:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
    3934:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
    3939:	77 1a                	ja     3955 <atoi+0x35>
    393b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    393f:	90                   	nop
    n = n*10 + *s++ - '0';
    3940:	83 c2 01             	add    $0x1,%edx
    3943:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
    3946:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
    394a:	0f be 02             	movsbl (%edx),%eax
    394d:	8d 58 d0             	lea    -0x30(%eax),%ebx
    3950:	80 fb 09             	cmp    $0x9,%bl
    3953:	76 eb                	jbe    3940 <atoi+0x20>
  return n;
}
    3955:	89 c8                	mov    %ecx,%eax
    3957:	5b                   	pop    %ebx
    3958:	5d                   	pop    %ebp
    3959:	c3                   	ret    
    395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00003960 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    3960:	f3 0f 1e fb          	endbr32 
    3964:	55                   	push   %ebp
    3965:	89 e5                	mov    %esp,%ebp
    3967:	57                   	push   %edi
    3968:	8b 45 10             	mov    0x10(%ebp),%eax
    396b:	8b 55 08             	mov    0x8(%ebp),%edx
    396e:	56                   	push   %esi
    396f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    3972:	85 c0                	test   %eax,%eax
    3974:	7e 0f                	jle    3985 <memmove+0x25>
    3976:	01 d0                	add    %edx,%eax
  dst = vdst;
    3978:	89 d7                	mov    %edx,%edi
    397a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
    3980:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    3981:	39 f8                	cmp    %edi,%eax
    3983:	75 fb                	jne    3980 <memmove+0x20>
  return vdst;
}
    3985:	5e                   	pop    %esi
    3986:	89 d0                	mov    %edx,%eax
    3988:	5f                   	pop    %edi
    3989:	5d                   	pop    %ebp
    398a:	c3                   	ret    

0000398b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    398b:	b8 01 00 00 00       	mov    $0x1,%eax
    3990:	cd 40                	int    $0x40
    3992:	c3                   	ret    

00003993 <exit>:
SYSCALL(exit)
    3993:	b8 02 00 00 00       	mov    $0x2,%eax
    3998:	cd 40                	int    $0x40
    399a:	c3                   	ret    

0000399b <wait>:
SYSCALL(wait)
    399b:	b8 03 00 00 00       	mov    $0x3,%eax
    39a0:	cd 40                	int    $0x40
    39a2:	c3                   	ret    

000039a3 <pipe>:
SYSCALL(pipe)
    39a3:	b8 04 00 00 00       	mov    $0x4,%eax
    39a8:	cd 40                	int    $0x40
    39aa:	c3                   	ret    

000039ab <read>:
SYSCALL(read)
    39ab:	b8 05 00 00 00       	mov    $0x5,%eax
    39b0:	cd 40                	int    $0x40
    39b2:	c3                   	ret    

000039b3 <write>:
SYSCALL(write)
    39b3:	b8 10 00 00 00       	mov    $0x10,%eax
    39b8:	cd 40                	int    $0x40
    39ba:	c3                   	ret    

000039bb <close>:
SYSCALL(close)
    39bb:	b8 15 00 00 00       	mov    $0x15,%eax
    39c0:	cd 40                	int    $0x40
    39c2:	c3                   	ret    

000039c3 <kill>:
SYSCALL(kill)
    39c3:	b8 06 00 00 00       	mov    $0x6,%eax
    39c8:	cd 40                	int    $0x40
    39ca:	c3                   	ret    

000039cb <exec>:
SYSCALL(exec)
    39cb:	b8 07 00 00 00       	mov    $0x7,%eax
    39d0:	cd 40                	int    $0x40
    39d2:	c3                   	ret    

000039d3 <open>:
SYSCALL(open)
    39d3:	b8 0f 00 00 00       	mov    $0xf,%eax
    39d8:	cd 40                	int    $0x40
    39da:	c3                   	ret    

000039db <mknod>:
SYSCALL(mknod)
    39db:	b8 11 00 00 00       	mov    $0x11,%eax
    39e0:	cd 40                	int    $0x40
    39e2:	c3                   	ret    

000039e3 <unlink>:
SYSCALL(unlink)
    39e3:	b8 12 00 00 00       	mov    $0x12,%eax
    39e8:	cd 40                	int    $0x40
    39ea:	c3                   	ret    

000039eb <fstat>:
SYSCALL(fstat)
    39eb:	b8 08 00 00 00       	mov    $0x8,%eax
    39f0:	cd 40                	int    $0x40
    39f2:	c3                   	ret    

000039f3 <link>:
SYSCALL(link)
    39f3:	b8 13 00 00 00       	mov    $0x13,%eax
    39f8:	cd 40                	int    $0x40
    39fa:	c3                   	ret    

000039fb <mkdir>:
SYSCALL(mkdir)
    39fb:	b8 14 00 00 00       	mov    $0x14,%eax
    3a00:	cd 40                	int    $0x40
    3a02:	c3                   	ret    

00003a03 <chdir>:
SYSCALL(chdir)
    3a03:	b8 09 00 00 00       	mov    $0x9,%eax
    3a08:	cd 40                	int    $0x40
    3a0a:	c3                   	ret    

00003a0b <dup>:
SYSCALL(dup)
    3a0b:	b8 0a 00 00 00       	mov    $0xa,%eax
    3a10:	cd 40                	int    $0x40
    3a12:	c3                   	ret    

00003a13 <getpid>:
SYSCALL(getpid)
    3a13:	b8 0b 00 00 00       	mov    $0xb,%eax
    3a18:	cd 40                	int    $0x40
    3a1a:	c3                   	ret    

00003a1b <sbrk>:
SYSCALL(sbrk)
    3a1b:	b8 0c 00 00 00       	mov    $0xc,%eax
    3a20:	cd 40                	int    $0x40
    3a22:	c3                   	ret    

00003a23 <sleep>:
SYSCALL(sleep)
    3a23:	b8 0d 00 00 00       	mov    $0xd,%eax
    3a28:	cd 40                	int    $0x40
    3a2a:	c3                   	ret    

00003a2b <uptime>:
SYSCALL(uptime)
    3a2b:	b8 0e 00 00 00       	mov    $0xe,%eax
    3a30:	cd 40                	int    $0x40
    3a32:	c3                   	ret    

00003a33 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
    3a33:	b8 17 00 00 00       	mov    $0x17,%eax
    3a38:	cd 40                	int    $0x40
    3a3a:	c3                   	ret    

00003a3b <getNumRefs>:
    3a3b:	b8 18 00 00 00       	mov    $0x18,%eax
    3a40:	cd 40                	int    $0x40
    3a42:	c3                   	ret    
    3a43:	66 90                	xchg   %ax,%ax
    3a45:	66 90                	xchg   %ax,%ax
    3a47:	66 90                	xchg   %ax,%ax
    3a49:	66 90                	xchg   %ax,%ax
    3a4b:	66 90                	xchg   %ax,%ax
    3a4d:	66 90                	xchg   %ax,%ax
    3a4f:	90                   	nop

00003a50 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    3a50:	55                   	push   %ebp
    3a51:	89 e5                	mov    %esp,%ebp
    3a53:	57                   	push   %edi
    3a54:	56                   	push   %esi
    3a55:	53                   	push   %ebx
    3a56:	83 ec 3c             	sub    $0x3c,%esp
    3a59:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    3a5c:	89 d1                	mov    %edx,%ecx
{
    3a5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    3a61:	85 d2                	test   %edx,%edx
    3a63:	0f 89 7f 00 00 00    	jns    3ae8 <printint+0x98>
    3a69:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    3a6d:	74 79                	je     3ae8 <printint+0x98>
    neg = 1;
    3a6f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    3a76:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    3a78:	31 db                	xor    %ebx,%ebx
    3a7a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    3a7d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    3a80:	89 c8                	mov    %ecx,%eax
    3a82:	31 d2                	xor    %edx,%edx
    3a84:	89 cf                	mov    %ecx,%edi
    3a86:	f7 75 c4             	divl   -0x3c(%ebp)
    3a89:	0f b6 92 18 56 00 00 	movzbl 0x5618(%edx),%edx
    3a90:	89 45 c0             	mov    %eax,-0x40(%ebp)
    3a93:	89 d8                	mov    %ebx,%eax
    3a95:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    3a98:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    3a9b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    3a9e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    3aa1:	76 dd                	jbe    3a80 <printint+0x30>
  if(neg)
    3aa3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    3aa6:	85 c9                	test   %ecx,%ecx
    3aa8:	74 0c                	je     3ab6 <printint+0x66>
    buf[i++] = '-';
    3aaa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    3aaf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    3ab1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    3ab6:	8b 7d b8             	mov    -0x48(%ebp),%edi
    3ab9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    3abd:	eb 07                	jmp    3ac6 <printint+0x76>
    3abf:	90                   	nop
    3ac0:	0f b6 13             	movzbl (%ebx),%edx
    3ac3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    3ac6:	83 ec 04             	sub    $0x4,%esp
    3ac9:	88 55 d7             	mov    %dl,-0x29(%ebp)
    3acc:	6a 01                	push   $0x1
    3ace:	56                   	push   %esi
    3acf:	57                   	push   %edi
    3ad0:	e8 de fe ff ff       	call   39b3 <write>
  while(--i >= 0)
    3ad5:	83 c4 10             	add    $0x10,%esp
    3ad8:	39 de                	cmp    %ebx,%esi
    3ada:	75 e4                	jne    3ac0 <printint+0x70>
    putc(fd, buf[i]);
}
    3adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3adf:	5b                   	pop    %ebx
    3ae0:	5e                   	pop    %esi
    3ae1:	5f                   	pop    %edi
    3ae2:	5d                   	pop    %ebp
    3ae3:	c3                   	ret    
    3ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    3ae8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    3aef:	eb 87                	jmp    3a78 <printint+0x28>
    3af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3aff:	90                   	nop

00003b00 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    3b00:	f3 0f 1e fb          	endbr32 
    3b04:	55                   	push   %ebp
    3b05:	89 e5                	mov    %esp,%ebp
    3b07:	57                   	push   %edi
    3b08:	56                   	push   %esi
    3b09:	53                   	push   %ebx
    3b0a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    3b0d:	8b 75 0c             	mov    0xc(%ebp),%esi
    3b10:	0f b6 1e             	movzbl (%esi),%ebx
    3b13:	84 db                	test   %bl,%bl
    3b15:	0f 84 b4 00 00 00    	je     3bcf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
    3b1b:	8d 45 10             	lea    0x10(%ebp),%eax
    3b1e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
    3b21:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    3b24:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
    3b26:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3b29:	eb 33                	jmp    3b5e <printf+0x5e>
    3b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3b2f:	90                   	nop
    3b30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    3b33:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    3b38:	83 f8 25             	cmp    $0x25,%eax
    3b3b:	74 17                	je     3b54 <printf+0x54>
  write(fd, &c, 1);
    3b3d:	83 ec 04             	sub    $0x4,%esp
    3b40:	88 5d e7             	mov    %bl,-0x19(%ebp)
    3b43:	6a 01                	push   $0x1
    3b45:	57                   	push   %edi
    3b46:	ff 75 08             	pushl  0x8(%ebp)
    3b49:	e8 65 fe ff ff       	call   39b3 <write>
    3b4e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
    3b51:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    3b54:	0f b6 1e             	movzbl (%esi),%ebx
    3b57:	83 c6 01             	add    $0x1,%esi
    3b5a:	84 db                	test   %bl,%bl
    3b5c:	74 71                	je     3bcf <printf+0xcf>
    c = fmt[i] & 0xff;
    3b5e:	0f be cb             	movsbl %bl,%ecx
    3b61:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    3b64:	85 d2                	test   %edx,%edx
    3b66:	74 c8                	je     3b30 <printf+0x30>
      }
    } else if(state == '%'){
    3b68:	83 fa 25             	cmp    $0x25,%edx
    3b6b:	75 e7                	jne    3b54 <printf+0x54>
      if(c == 'd'){
    3b6d:	83 f8 64             	cmp    $0x64,%eax
    3b70:	0f 84 9a 00 00 00    	je     3c10 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3b76:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    3b7c:	83 f9 70             	cmp    $0x70,%ecx
    3b7f:	74 5f                	je     3be0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3b81:	83 f8 73             	cmp    $0x73,%eax
    3b84:	0f 84 d6 00 00 00    	je     3c60 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    3b8a:	83 f8 63             	cmp    $0x63,%eax
    3b8d:	0f 84 8d 00 00 00    	je     3c20 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3b93:	83 f8 25             	cmp    $0x25,%eax
    3b96:	0f 84 b4 00 00 00    	je     3c50 <printf+0x150>
  write(fd, &c, 1);
    3b9c:	83 ec 04             	sub    $0x4,%esp
    3b9f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    3ba3:	6a 01                	push   $0x1
    3ba5:	57                   	push   %edi
    3ba6:	ff 75 08             	pushl  0x8(%ebp)
    3ba9:	e8 05 fe ff ff       	call   39b3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    3bae:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3bb1:	83 c4 0c             	add    $0xc,%esp
    3bb4:	6a 01                	push   $0x1
    3bb6:	83 c6 01             	add    $0x1,%esi
    3bb9:	57                   	push   %edi
    3bba:	ff 75 08             	pushl  0x8(%ebp)
    3bbd:	e8 f1 fd ff ff       	call   39b3 <write>
  for(i = 0; fmt[i]; i++){
    3bc2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    3bc6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    3bc9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    3bcb:	84 db                	test   %bl,%bl
    3bcd:	75 8f                	jne    3b5e <printf+0x5e>
    }
  }
}
    3bcf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3bd2:	5b                   	pop    %ebx
    3bd3:	5e                   	pop    %esi
    3bd4:	5f                   	pop    %edi
    3bd5:	5d                   	pop    %ebp
    3bd6:	c3                   	ret    
    3bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3bde:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    3be0:	83 ec 0c             	sub    $0xc,%esp
    3be3:	b9 10 00 00 00       	mov    $0x10,%ecx
    3be8:	6a 00                	push   $0x0
    3bea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    3bed:	8b 45 08             	mov    0x8(%ebp),%eax
    3bf0:	8b 13                	mov    (%ebx),%edx
    3bf2:	e8 59 fe ff ff       	call   3a50 <printint>
        ap++;
    3bf7:	89 d8                	mov    %ebx,%eax
    3bf9:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3bfc:	31 d2                	xor    %edx,%edx
        ap++;
    3bfe:	83 c0 04             	add    $0x4,%eax
    3c01:	89 45 d0             	mov    %eax,-0x30(%ebp)
    3c04:	e9 4b ff ff ff       	jmp    3b54 <printf+0x54>
    3c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    3c10:	83 ec 0c             	sub    $0xc,%esp
    3c13:	b9 0a 00 00 00       	mov    $0xa,%ecx
    3c18:	6a 01                	push   $0x1
    3c1a:	eb ce                	jmp    3bea <printf+0xea>
    3c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    3c20:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    3c23:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    3c26:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    3c28:	6a 01                	push   $0x1
        ap++;
    3c2a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    3c2d:	57                   	push   %edi
    3c2e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    3c31:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3c34:	e8 7a fd ff ff       	call   39b3 <write>
        ap++;
    3c39:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    3c3c:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3c3f:	31 d2                	xor    %edx,%edx
    3c41:	e9 0e ff ff ff       	jmp    3b54 <printf+0x54>
    3c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c4d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    3c50:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    3c53:	83 ec 04             	sub    $0x4,%esp
    3c56:	e9 59 ff ff ff       	jmp    3bb4 <printf+0xb4>
    3c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3c5f:	90                   	nop
        s = (char*)*ap;
    3c60:	8b 45 d0             	mov    -0x30(%ebp),%eax
    3c63:	8b 18                	mov    (%eax),%ebx
        ap++;
    3c65:	83 c0 04             	add    $0x4,%eax
    3c68:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    3c6b:	85 db                	test   %ebx,%ebx
    3c6d:	74 17                	je     3c86 <printf+0x186>
        while(*s != 0){
    3c6f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    3c72:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    3c74:	84 c0                	test   %al,%al
    3c76:	0f 84 d8 fe ff ff    	je     3b54 <printf+0x54>
    3c7c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3c7f:	89 de                	mov    %ebx,%esi
    3c81:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3c84:	eb 1a                	jmp    3ca0 <printf+0x1a0>
          s = "(null)";
    3c86:	bb 0e 56 00 00       	mov    $0x560e,%ebx
        while(*s != 0){
    3c8b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    3c8e:	b8 28 00 00 00       	mov    $0x28,%eax
    3c93:	89 de                	mov    %ebx,%esi
    3c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3c9f:	90                   	nop
  write(fd, &c, 1);
    3ca0:	83 ec 04             	sub    $0x4,%esp
          s++;
    3ca3:	83 c6 01             	add    $0x1,%esi
    3ca6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    3ca9:	6a 01                	push   $0x1
    3cab:	57                   	push   %edi
    3cac:	53                   	push   %ebx
    3cad:	e8 01 fd ff ff       	call   39b3 <write>
        while(*s != 0){
    3cb2:	0f b6 06             	movzbl (%esi),%eax
    3cb5:	83 c4 10             	add    $0x10,%esp
    3cb8:	84 c0                	test   %al,%al
    3cba:	75 e4                	jne    3ca0 <printf+0x1a0>
    3cbc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    3cbf:	31 d2                	xor    %edx,%edx
    3cc1:	e9 8e fe ff ff       	jmp    3b54 <printf+0x54>
    3cc6:	66 90                	xchg   %ax,%ax
    3cc8:	66 90                	xchg   %ax,%ax
    3cca:	66 90                	xchg   %ax,%ax
    3ccc:	66 90                	xchg   %ax,%ax
    3cce:	66 90                	xchg   %ax,%ax

00003cd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3cd0:	f3 0f 1e fb          	endbr32 
    3cd4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3cd5:	a1 c0 5f 00 00       	mov    0x5fc0,%eax
{
    3cda:	89 e5                	mov    %esp,%ebp
    3cdc:	57                   	push   %edi
    3cdd:	56                   	push   %esi
    3cde:	53                   	push   %ebx
    3cdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    3ce2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    3ce4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3ce7:	39 c8                	cmp    %ecx,%eax
    3ce9:	73 15                	jae    3d00 <free+0x30>
    3ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3cef:	90                   	nop
    3cf0:	39 d1                	cmp    %edx,%ecx
    3cf2:	72 14                	jb     3d08 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3cf4:	39 d0                	cmp    %edx,%eax
    3cf6:	73 10                	jae    3d08 <free+0x38>
{
    3cf8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3cfa:	8b 10                	mov    (%eax),%edx
    3cfc:	39 c8                	cmp    %ecx,%eax
    3cfe:	72 f0                	jb     3cf0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3d00:	39 d0                	cmp    %edx,%eax
    3d02:	72 f4                	jb     3cf8 <free+0x28>
    3d04:	39 d1                	cmp    %edx,%ecx
    3d06:	73 f0                	jae    3cf8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3d08:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3d0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3d0e:	39 fa                	cmp    %edi,%edx
    3d10:	74 1e                	je     3d30 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3d12:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3d15:	8b 50 04             	mov    0x4(%eax),%edx
    3d18:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3d1b:	39 f1                	cmp    %esi,%ecx
    3d1d:	74 28                	je     3d47 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3d1f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    3d21:	5b                   	pop    %ebx
  freep = p;
    3d22:	a3 c0 5f 00 00       	mov    %eax,0x5fc0
}
    3d27:	5e                   	pop    %esi
    3d28:	5f                   	pop    %edi
    3d29:	5d                   	pop    %ebp
    3d2a:	c3                   	ret    
    3d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    3d2f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    3d30:	03 72 04             	add    0x4(%edx),%esi
    3d33:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3d36:	8b 10                	mov    (%eax),%edx
    3d38:	8b 12                	mov    (%edx),%edx
    3d3a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3d3d:	8b 50 04             	mov    0x4(%eax),%edx
    3d40:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3d43:	39 f1                	cmp    %esi,%ecx
    3d45:	75 d8                	jne    3d1f <free+0x4f>
    p->s.size += bp->s.size;
    3d47:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    3d4a:	a3 c0 5f 00 00       	mov    %eax,0x5fc0
    p->s.size += bp->s.size;
    3d4f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3d52:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3d55:	89 10                	mov    %edx,(%eax)
}
    3d57:	5b                   	pop    %ebx
    3d58:	5e                   	pop    %esi
    3d59:	5f                   	pop    %edi
    3d5a:	5d                   	pop    %ebp
    3d5b:	c3                   	ret    
    3d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00003d60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    3d60:	f3 0f 1e fb          	endbr32 
    3d64:	55                   	push   %ebp
    3d65:	89 e5                	mov    %esp,%ebp
    3d67:	57                   	push   %edi
    3d68:	56                   	push   %esi
    3d69:	53                   	push   %ebx
    3d6a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    3d70:	8b 3d c0 5f 00 00    	mov    0x5fc0,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3d76:	8d 70 07             	lea    0x7(%eax),%esi
    3d79:	c1 ee 03             	shr    $0x3,%esi
    3d7c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    3d7f:	85 ff                	test   %edi,%edi
    3d81:	0f 84 a9 00 00 00    	je     3e30 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3d87:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    3d89:	8b 48 04             	mov    0x4(%eax),%ecx
    3d8c:	39 f1                	cmp    %esi,%ecx
    3d8e:	73 6d                	jae    3dfd <malloc+0x9d>
    3d90:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    3d96:	bb 00 10 00 00       	mov    $0x1000,%ebx
    3d9b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    3d9e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    3da5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    3da8:	eb 17                	jmp    3dc1 <malloc+0x61>
    3daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3db0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    3db2:	8b 4a 04             	mov    0x4(%edx),%ecx
    3db5:	39 f1                	cmp    %esi,%ecx
    3db7:	73 4f                	jae    3e08 <malloc+0xa8>
    3db9:	8b 3d c0 5f 00 00    	mov    0x5fc0,%edi
    3dbf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    3dc1:	39 c7                	cmp    %eax,%edi
    3dc3:	75 eb                	jne    3db0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    3dc5:	83 ec 0c             	sub    $0xc,%esp
    3dc8:	ff 75 e4             	pushl  -0x1c(%ebp)
    3dcb:	e8 4b fc ff ff       	call   3a1b <sbrk>
  if(p == (char*)-1)
    3dd0:	83 c4 10             	add    $0x10,%esp
    3dd3:	83 f8 ff             	cmp    $0xffffffff,%eax
    3dd6:	74 1b                	je     3df3 <malloc+0x93>
  hp->s.size = nu;
    3dd8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3ddb:	83 ec 0c             	sub    $0xc,%esp
    3dde:	83 c0 08             	add    $0x8,%eax
    3de1:	50                   	push   %eax
    3de2:	e8 e9 fe ff ff       	call   3cd0 <free>
  return freep;
    3de7:	a1 c0 5f 00 00       	mov    0x5fc0,%eax
      if((p = morecore(nunits)) == 0)
    3dec:	83 c4 10             	add    $0x10,%esp
    3def:	85 c0                	test   %eax,%eax
    3df1:	75 bd                	jne    3db0 <malloc+0x50>
        return 0;
  }
}
    3df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    3df6:	31 c0                	xor    %eax,%eax
}
    3df8:	5b                   	pop    %ebx
    3df9:	5e                   	pop    %esi
    3dfa:	5f                   	pop    %edi
    3dfb:	5d                   	pop    %ebp
    3dfc:	c3                   	ret    
    if(p->s.size >= nunits){
    3dfd:	89 c2                	mov    %eax,%edx
    3dff:	89 f8                	mov    %edi,%eax
    3e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    3e08:	39 ce                	cmp    %ecx,%esi
    3e0a:	74 54                	je     3e60 <malloc+0x100>
        p->s.size -= nunits;
    3e0c:	29 f1                	sub    %esi,%ecx
    3e0e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    3e11:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    3e14:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    3e17:	a3 c0 5f 00 00       	mov    %eax,0x5fc0
}
    3e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    3e1f:	8d 42 08             	lea    0x8(%edx),%eax
}
    3e22:	5b                   	pop    %ebx
    3e23:	5e                   	pop    %esi
    3e24:	5f                   	pop    %edi
    3e25:	5d                   	pop    %ebp
    3e26:	c3                   	ret    
    3e27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    3e2e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    3e30:	c7 05 c0 5f 00 00 c4 	movl   $0x5fc4,0x5fc0
    3e37:	5f 00 00 
    base.s.size = 0;
    3e3a:	bf c4 5f 00 00       	mov    $0x5fc4,%edi
    base.s.ptr = freep = prevp = &base;
    3e3f:	c7 05 c4 5f 00 00 c4 	movl   $0x5fc4,0x5fc4
    3e46:	5f 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3e49:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    3e4b:	c7 05 c8 5f 00 00 00 	movl   $0x0,0x5fc8
    3e52:	00 00 00 
    if(p->s.size >= nunits){
    3e55:	e9 36 ff ff ff       	jmp    3d90 <malloc+0x30>
    3e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    3e60:	8b 0a                	mov    (%edx),%ecx
    3e62:	89 08                	mov    %ecx,(%eax)
    3e64:	eb b1                	jmp    3e17 <malloc+0xb7>
