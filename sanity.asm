
_sanity:     file format elf32-i386


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
    // simple_printf_test();
    // simple_buffer_test();
    // simple_fork_test();
    // pagefault_test();
    pagefault_cow();
  11:	e8 fa 00 00 00       	call   110 <pagefault_cow>
    exit();
  16:	e8 d7 03 00 00       	call   3f2 <exit>
  1b:	66 90                	xchg   %ax,%ax
  1d:	66 90                	xchg   %ax,%ax
  1f:	90                   	nop

00000020 <simple_printf_test>:
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_printf_test --------\n");
  26:	68 a8 08 00 00       	push   $0x8a8
  2b:	6a 01                	push   $0x1
  2d:	e8 1e 05 00 00       	call   550 <printf>
   printf(1, "sanity test!\n");
  32:	58                   	pop    %eax
  33:	5a                   	pop    %edx
  34:	68 70 09 00 00       	push   $0x970
  39:	6a 01                	push   $0x1
  3b:	e8 10 05 00 00       	call   550 <printf>
}
  40:	83 c4 10             	add    $0x10,%esp
  43:	c9                   	leave  
  44:	c3                   	ret    
  45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000050 <simple_buffer_test>:
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_buffer_test --------\n");
  56:	68 d0 08 00 00       	push   $0x8d0
  5b:	6a 01                	push   $0x1
  5d:	e8 ee 04 00 00       	call   550 <printf>
    printf(1, "buf[0] = %c, buf[512] = %c, buf[1023] = %c\n", buf[0], buf[512], buf[1023]);
  62:	c7 04 24 63 00 00 00 	movl   $0x63,(%esp)
  69:	6a 62                	push   $0x62
  6b:	6a 61                	push   $0x61
  6d:	68 f8 08 00 00       	push   $0x8f8
  72:	6a 01                	push   $0x1
  74:	e8 d7 04 00 00       	call   550 <printf>
}
  79:	83 c4 20             	add    $0x20,%esp
  7c:	c9                   	leave  
  7d:	c3                   	ret    
  7e:	66 90                	xchg   %ax,%ax

00000080 <simple_fork_test>:
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_fork_test --------\n");
  86:	68 24 09 00 00       	push   $0x924
  8b:	6a 01                	push   $0x1
  8d:	e8 be 04 00 00       	call   550 <printf>
    if((pid = fork()) == 0) // child
  92:	e8 53 03 00 00       	call   3ea <fork>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	85 c0                	test   %eax,%eax
  9c:	74 21                	je     bf <simple_fork_test+0x3f>
        sleep(20);
  9e:	83 ec 0c             	sub    $0xc,%esp
  a1:	6a 14                	push   $0x14
  a3:	e8 da 03 00 00       	call   482 <sleep>
        printf(1, "I'm parent!\n");
  a8:	58                   	pop    %eax
  a9:	5a                   	pop    %edx
  aa:	68 8a 09 00 00       	push   $0x98a
  af:	6a 01                	push   $0x1
  b1:	e8 9a 04 00 00       	call   550 <printf>
        wait();
  b6:	83 c4 10             	add    $0x10,%esp
}
  b9:	c9                   	leave  
        wait();
  ba:	e9 3b 03 00 00       	jmp    3fa <wait>
        printf(1, "I'm child!\n");
  bf:	51                   	push   %ecx
  c0:	51                   	push   %ecx
  c1:	68 7e 09 00 00       	push   $0x97e
  c6:	6a 01                	push   $0x1
  c8:	e8 83 04 00 00       	call   550 <printf>
        exit();
  cd:	e8 20 03 00 00       	call   3f2 <exit>
  d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <pagefault_test>:
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	83 ec 14             	sub    $0x14,%esp
    char *arr = (char*)malloc(len);
  e6:	68 00 f0 00 00       	push   $0xf000
  eb:	e8 c0 06 00 00       	call   7b0 <malloc>
    memset((void*)arr, '0', len);
  f0:	83 c4 0c             	add    $0xc,%esp
  f3:	68 00 f0 00 00       	push   $0xf000
  f8:	6a 30                	push   $0x30
  fa:	50                   	push   %eax
  fb:	e8 50 01 00 00       	call   250 <memset>
    return;
 100:	83 c4 10             	add    $0x10,%esp
}
 103:	c9                   	leave  
 104:	c3                   	ret    
 105:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000110 <pagefault_cow>:
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 117:	68 00 f0 00 00       	push   $0xf000
 11c:	e8 8f 06 00 00       	call   7b0 <malloc>
    memset((void*)arr, '0', len);
 121:	83 c4 0c             	add    $0xc,%esp
    char *arr = (char*)malloc(len);
 124:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len);
 126:	68 00 f0 00 00       	push   $0xf000
 12b:	6a 30                	push   $0x30
 12d:	50                   	push   %eax
 12e:	e8 1d 01 00 00       	call   250 <memset>
    if((pid = fork()) == 0) // child
 133:	e8 b2 02 00 00       	call   3ea <fork>
 138:	83 c4 10             	add    $0x10,%esp
 13b:	85 c0                	test   %eax,%eax
 13d:	74 31                	je     170 <pagefault_cow+0x60>
        sleep(20);
 13f:	83 ec 0c             	sub    $0xc,%esp
 142:	6a 14                	push   $0x14
 144:	e8 39 03 00 00       	call   482 <sleep>
        printf(1, "parent: exprected: 0, actual: %c\n", arr[len / 2]);
 149:	0f be 83 00 78 00 00 	movsbl 0x7800(%ebx),%eax
 150:	83 c4 0c             	add    $0xc,%esp
 153:	50                   	push   %eax
 154:	68 4c 09 00 00       	push   $0x94c
 159:	6a 01                	push   $0x1
 15b:	e8 f0 03 00 00       	call   550 <printf>
        wait();
 160:	83 c4 10             	add    $0x10,%esp
}
 163:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 166:	c9                   	leave  
        wait();
 167:	e9 8e 02 00 00       	jmp    3fa <wait>
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        printf(1, "child: writing \'1\'s his mem\n");
 170:	83 ec 08             	sub    $0x8,%esp
 173:	68 97 09 00 00       	push   $0x997
 178:	6a 01                	push   $0x1
 17a:	e8 d1 03 00 00       	call   550 <printf>
        memset((void*)arr, '1', len);
 17f:	83 c4 0c             	add    $0xc,%esp
 182:	68 00 f0 00 00       	push   $0xf000
 187:	6a 31                	push   $0x31
 189:	53                   	push   %ebx
 18a:	e8 c1 00 00 00       	call   250 <memset>
 18f:	83 c4 10             	add    $0x10,%esp
}
 192:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 195:	c9                   	leave  
 196:	c3                   	ret    
 197:	66 90                	xchg   %ax,%ax
 199:	66 90                	xchg   %ax,%ax
 19b:	66 90                	xchg   %ax,%ax
 19d:	66 90                	xchg   %ax,%ax
 19f:	90                   	nop

000001a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	53                   	push   %ebx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1b0:	83 c1 01             	add    $0x1,%ecx
 1b3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 1b7:	83 c2 01             	add    $0x1,%edx
 1ba:	84 db                	test   %bl,%bl
 1bc:	88 5a ff             	mov    %bl,-0x1(%edx)
 1bf:	75 ef                	jne    1b0 <strcpy+0x10>
    ;
  return os;
}
 1c1:	5b                   	pop    %ebx
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    
 1c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000001d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d0:	55                   	push   %ebp
 1d1:	89 e5                	mov    %esp,%ebp
 1d3:	53                   	push   %ebx
 1d4:	8b 55 08             	mov    0x8(%ebp),%edx
 1d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1da:	0f b6 02             	movzbl (%edx),%eax
 1dd:	0f b6 19             	movzbl (%ecx),%ebx
 1e0:	84 c0                	test   %al,%al
 1e2:	75 1c                	jne    200 <strcmp+0x30>
 1e4:	eb 2a                	jmp    210 <strcmp+0x40>
 1e6:	8d 76 00             	lea    0x0(%esi),%esi
 1e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 1f0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1f3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1f6:	83 c1 01             	add    $0x1,%ecx
 1f9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 1fc:	84 c0                	test   %al,%al
 1fe:	74 10                	je     210 <strcmp+0x40>
 200:	38 d8                	cmp    %bl,%al
 202:	74 ec                	je     1f0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 204:	29 d8                	sub    %ebx,%eax
}
 206:	5b                   	pop    %ebx
 207:	5d                   	pop    %ebp
 208:	c3                   	ret    
 209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 210:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 212:	29 d8                	sub    %ebx,%eax
}
 214:	5b                   	pop    %ebx
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    
 217:	89 f6                	mov    %esi,%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <strlen>:

uint
strlen(const char *s)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 226:	80 39 00             	cmpb   $0x0,(%ecx)
 229:	74 15                	je     240 <strlen+0x20>
 22b:	31 d2                	xor    %edx,%edx
 22d:	8d 76 00             	lea    0x0(%esi),%esi
 230:	83 c2 01             	add    $0x1,%edx
 233:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 237:	89 d0                	mov    %edx,%eax
 239:	75 f5                	jne    230 <strlen+0x10>
    ;
  return n;
}
 23b:	5d                   	pop    %ebp
 23c:	c3                   	ret    
 23d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 240:	31 c0                	xor    %eax,%eax
}
 242:	5d                   	pop    %ebp
 243:	c3                   	ret    
 244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 24a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000250 <memset>:

void*
memset(void *dst, int c, uint n)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	57                   	push   %edi
 254:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 257:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25a:	8b 45 0c             	mov    0xc(%ebp),%eax
 25d:	89 d7                	mov    %edx,%edi
 25f:	fc                   	cld    
 260:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 262:	89 d0                	mov    %edx,%eax
 264:	5f                   	pop    %edi
 265:	5d                   	pop    %ebp
 266:	c3                   	ret    
 267:	89 f6                	mov    %esi,%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	53                   	push   %ebx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 27a:	0f b6 10             	movzbl (%eax),%edx
 27d:	84 d2                	test   %dl,%dl
 27f:	74 1d                	je     29e <strchr+0x2e>
    if(*s == c)
 281:	38 d3                	cmp    %dl,%bl
 283:	89 d9                	mov    %ebx,%ecx
 285:	75 0d                	jne    294 <strchr+0x24>
 287:	eb 17                	jmp    2a0 <strchr+0x30>
 289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 290:	38 ca                	cmp    %cl,%dl
 292:	74 0c                	je     2a0 <strchr+0x30>
  for(; *s; s++)
 294:	83 c0 01             	add    $0x1,%eax
 297:	0f b6 10             	movzbl (%eax),%edx
 29a:	84 d2                	test   %dl,%dl
 29c:	75 f2                	jne    290 <strchr+0x20>
      return (char*)s;
  return 0;
 29e:	31 c0                	xor    %eax,%eax
}
 2a0:	5b                   	pop    %ebx
 2a1:	5d                   	pop    %ebp
 2a2:	c3                   	ret    
 2a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002b0 <gets>:

char*
gets(char *buf, int max)
{
 2b0:	55                   	push   %ebp
 2b1:	89 e5                	mov    %esp,%ebp
 2b3:	57                   	push   %edi
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b6:	31 f6                	xor    %esi,%esi
 2b8:	89 f3                	mov    %esi,%ebx
{
 2ba:	83 ec 1c             	sub    $0x1c,%esp
 2bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 2c0:	eb 2f                	jmp    2f1 <gets+0x41>
 2c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 2c8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2cb:	83 ec 04             	sub    $0x4,%esp
 2ce:	6a 01                	push   $0x1
 2d0:	50                   	push   %eax
 2d1:	6a 00                	push   $0x0
 2d3:	e8 32 01 00 00       	call   40a <read>
    if(cc < 1)
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	85 c0                	test   %eax,%eax
 2dd:	7e 1c                	jle    2fb <gets+0x4b>
      break;
    buf[i++] = c;
 2df:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 2e3:	83 c7 01             	add    $0x1,%edi
 2e6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 2e9:	3c 0a                	cmp    $0xa,%al
 2eb:	74 23                	je     310 <gets+0x60>
 2ed:	3c 0d                	cmp    $0xd,%al
 2ef:	74 1f                	je     310 <gets+0x60>
  for(i=0; i+1 < max; ){
 2f1:	83 c3 01             	add    $0x1,%ebx
 2f4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2f7:	89 fe                	mov    %edi,%esi
 2f9:	7c cd                	jl     2c8 <gets+0x18>
 2fb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 300:	c6 03 00             	movb   $0x0,(%ebx)
}
 303:	8d 65 f4             	lea    -0xc(%ebp),%esp
 306:	5b                   	pop    %ebx
 307:	5e                   	pop    %esi
 308:	5f                   	pop    %edi
 309:	5d                   	pop    %ebp
 30a:	c3                   	ret    
 30b:	90                   	nop
 30c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 310:	8b 75 08             	mov    0x8(%ebp),%esi
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	01 de                	add    %ebx,%esi
 318:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 31a:	c6 03 00             	movb   $0x0,(%ebx)
}
 31d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 320:	5b                   	pop    %ebx
 321:	5e                   	pop    %esi
 322:	5f                   	pop    %edi
 323:	5d                   	pop    %ebp
 324:	c3                   	ret    
 325:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000330 <stat>:

int
stat(const char *n, struct stat *st)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	56                   	push   %esi
 334:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 335:	83 ec 08             	sub    $0x8,%esp
 338:	6a 00                	push   $0x0
 33a:	ff 75 08             	pushl  0x8(%ebp)
 33d:	e8 f0 00 00 00       	call   432 <open>
  if(fd < 0)
 342:	83 c4 10             	add    $0x10,%esp
 345:	85 c0                	test   %eax,%eax
 347:	78 27                	js     370 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 349:	83 ec 08             	sub    $0x8,%esp
 34c:	ff 75 0c             	pushl  0xc(%ebp)
 34f:	89 c3                	mov    %eax,%ebx
 351:	50                   	push   %eax
 352:	e8 f3 00 00 00       	call   44a <fstat>
  close(fd);
 357:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 35a:	89 c6                	mov    %eax,%esi
  close(fd);
 35c:	e8 b9 00 00 00       	call   41a <close>
  return r;
 361:	83 c4 10             	add    $0x10,%esp
}
 364:	8d 65 f8             	lea    -0x8(%ebp),%esp
 367:	89 f0                	mov    %esi,%eax
 369:	5b                   	pop    %ebx
 36a:	5e                   	pop    %esi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    
 36d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 370:	be ff ff ff ff       	mov    $0xffffffff,%esi
 375:	eb ed                	jmp    364 <stat+0x34>
 377:	89 f6                	mov    %esi,%esi
 379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000380 <atoi>:

int
atoi(const char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	53                   	push   %ebx
 384:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 387:	0f be 11             	movsbl (%ecx),%edx
 38a:	8d 42 d0             	lea    -0x30(%edx),%eax
 38d:	3c 09                	cmp    $0x9,%al
  n = 0;
 38f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 394:	77 1f                	ja     3b5 <atoi+0x35>
 396:	8d 76 00             	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 3a0:	8d 04 80             	lea    (%eax,%eax,4),%eax
 3a3:	83 c1 01             	add    $0x1,%ecx
 3a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 3aa:	0f be 11             	movsbl (%ecx),%edx
 3ad:	8d 5a d0             	lea    -0x30(%edx),%ebx
 3b0:	80 fb 09             	cmp    $0x9,%bl
 3b3:	76 eb                	jbe    3a0 <atoi+0x20>
  return n;
}
 3b5:	5b                   	pop    %ebx
 3b6:	5d                   	pop    %ebp
 3b7:	c3                   	ret    
 3b8:	90                   	nop
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	56                   	push   %esi
 3c4:	53                   	push   %ebx
 3c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3ce:	85 db                	test   %ebx,%ebx
 3d0:	7e 14                	jle    3e6 <memmove+0x26>
 3d2:	31 d2                	xor    %edx,%edx
 3d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 3d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3df:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3e2:	39 d3                	cmp    %edx,%ebx
 3e4:	75 f2                	jne    3d8 <memmove+0x18>
  return vdst;
}
 3e6:	5b                   	pop    %ebx
 3e7:	5e                   	pop    %esi
 3e8:	5d                   	pop    %ebp
 3e9:	c3                   	ret    

000003ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3ea:	b8 01 00 00 00       	mov    $0x1,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <exit>:
SYSCALL(exit)
 3f2:	b8 02 00 00 00       	mov    $0x2,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <wait>:
SYSCALL(wait)
 3fa:	b8 03 00 00 00       	mov    $0x3,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <pipe>:
SYSCALL(pipe)
 402:	b8 04 00 00 00       	mov    $0x4,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <read>:
SYSCALL(read)
 40a:	b8 05 00 00 00       	mov    $0x5,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <write>:
SYSCALL(write)
 412:	b8 10 00 00 00       	mov    $0x10,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <close>:
SYSCALL(close)
 41a:	b8 15 00 00 00       	mov    $0x15,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <kill>:
SYSCALL(kill)
 422:	b8 06 00 00 00       	mov    $0x6,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <exec>:
SYSCALL(exec)
 42a:	b8 07 00 00 00       	mov    $0x7,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <open>:
SYSCALL(open)
 432:	b8 0f 00 00 00       	mov    $0xf,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <mknod>:
SYSCALL(mknod)
 43a:	b8 11 00 00 00       	mov    $0x11,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <unlink>:
SYSCALL(unlink)
 442:	b8 12 00 00 00       	mov    $0x12,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <fstat>:
SYSCALL(fstat)
 44a:	b8 08 00 00 00       	mov    $0x8,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <link>:
SYSCALL(link)
 452:	b8 13 00 00 00       	mov    $0x13,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <mkdir>:
SYSCALL(mkdir)
 45a:	b8 14 00 00 00       	mov    $0x14,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <chdir>:
SYSCALL(chdir)
 462:	b8 09 00 00 00       	mov    $0x9,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <dup>:
SYSCALL(dup)
 46a:	b8 0a 00 00 00       	mov    $0xa,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <getpid>:
SYSCALL(getpid)
 472:	b8 0b 00 00 00       	mov    $0xb,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <sbrk>:
SYSCALL(sbrk)
 47a:	b8 0c 00 00 00       	mov    $0xc,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <sleep>:
SYSCALL(sleep)
 482:	b8 0d 00 00 00       	mov    $0xd,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <uptime>:
SYSCALL(uptime)
 48a:	b8 0e 00 00 00       	mov    $0xe,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
 492:	b8 16 00 00 00       	mov    $0x16,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <getTotalFreePages>:
SYSCALL(getTotalFreePages)
 49a:	b8 17 00 00 00       	mov    $0x17,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    
 4a2:	66 90                	xchg   %ax,%ax
 4a4:	66 90                	xchg   %ax,%ax
 4a6:	66 90                	xchg   %ax,%ax
 4a8:	66 90                	xchg   %ax,%ax
 4aa:	66 90                	xchg   %ax,%ax
 4ac:	66 90                	xchg   %ax,%ax
 4ae:	66 90                	xchg   %ax,%ax

000004b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4b9:	85 d2                	test   %edx,%edx
{
 4bb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 4be:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 4c0:	79 76                	jns    538 <printint+0x88>
 4c2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4c6:	74 70                	je     538 <printint+0x88>
    x = -xx;
 4c8:	f7 d8                	neg    %eax
    neg = 1;
 4ca:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 4d1:	31 f6                	xor    %esi,%esi
 4d3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 4d6:	eb 0a                	jmp    4e2 <printint+0x32>
 4d8:	90                   	nop
 4d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 4e0:	89 fe                	mov    %edi,%esi
 4e2:	31 d2                	xor    %edx,%edx
 4e4:	8d 7e 01             	lea    0x1(%esi),%edi
 4e7:	f7 f1                	div    %ecx
 4e9:	0f b6 92 bc 09 00 00 	movzbl 0x9bc(%edx),%edx
  }while((x /= base) != 0);
 4f0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4f2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 4f5:	75 e9                	jne    4e0 <printint+0x30>
  if(neg)
 4f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 4fa:	85 c0                	test   %eax,%eax
 4fc:	74 08                	je     506 <printint+0x56>
    buf[i++] = '-';
 4fe:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 503:	8d 7e 02             	lea    0x2(%esi),%edi
 506:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 50a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 50d:	8d 76 00             	lea    0x0(%esi),%esi
 510:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 513:	83 ec 04             	sub    $0x4,%esp
 516:	83 ee 01             	sub    $0x1,%esi
 519:	6a 01                	push   $0x1
 51b:	53                   	push   %ebx
 51c:	57                   	push   %edi
 51d:	88 45 d7             	mov    %al,-0x29(%ebp)
 520:	e8 ed fe ff ff       	call   412 <write>

  while(--i >= 0)
 525:	83 c4 10             	add    $0x10,%esp
 528:	39 de                	cmp    %ebx,%esi
 52a:	75 e4                	jne    510 <printint+0x60>
    putc(fd, buf[i]);
}
 52c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 52f:	5b                   	pop    %ebx
 530:	5e                   	pop    %esi
 531:	5f                   	pop    %edi
 532:	5d                   	pop    %ebp
 533:	c3                   	ret    
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 538:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 53f:	eb 90                	jmp    4d1 <printint+0x21>
 541:	eb 0d                	jmp    550 <printf>
 543:	90                   	nop
 544:	90                   	nop
 545:	90                   	nop
 546:	90                   	nop
 547:	90                   	nop
 548:	90                   	nop
 549:	90                   	nop
 54a:	90                   	nop
 54b:	90                   	nop
 54c:	90                   	nop
 54d:	90                   	nop
 54e:	90                   	nop
 54f:	90                   	nop

00000550 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 559:	8b 75 0c             	mov    0xc(%ebp),%esi
 55c:	0f b6 1e             	movzbl (%esi),%ebx
 55f:	84 db                	test   %bl,%bl
 561:	0f 84 b3 00 00 00    	je     61a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 567:	8d 45 10             	lea    0x10(%ebp),%eax
 56a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 56d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 56f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 572:	eb 2f                	jmp    5a3 <printf+0x53>
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 578:	83 f8 25             	cmp    $0x25,%eax
 57b:	0f 84 a7 00 00 00    	je     628 <printf+0xd8>
  write(fd, &c, 1);
 581:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 584:	83 ec 04             	sub    $0x4,%esp
 587:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 58a:	6a 01                	push   $0x1
 58c:	50                   	push   %eax
 58d:	ff 75 08             	pushl  0x8(%ebp)
 590:	e8 7d fe ff ff       	call   412 <write>
 595:	83 c4 10             	add    $0x10,%esp
 598:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 59b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 59f:	84 db                	test   %bl,%bl
 5a1:	74 77                	je     61a <printf+0xca>
    if(state == 0){
 5a3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 5a5:	0f be cb             	movsbl %bl,%ecx
 5a8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5ab:	74 cb                	je     578 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ad:	83 ff 25             	cmp    $0x25,%edi
 5b0:	75 e6                	jne    598 <printf+0x48>
      if(c == 'd'){
 5b2:	83 f8 64             	cmp    $0x64,%eax
 5b5:	0f 84 05 01 00 00    	je     6c0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 5bb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 5c1:	83 f9 70             	cmp    $0x70,%ecx
 5c4:	74 72                	je     638 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 5c6:	83 f8 73             	cmp    $0x73,%eax
 5c9:	0f 84 99 00 00 00    	je     668 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5cf:	83 f8 63             	cmp    $0x63,%eax
 5d2:	0f 84 08 01 00 00    	je     6e0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 5d8:	83 f8 25             	cmp    $0x25,%eax
 5db:	0f 84 ef 00 00 00    	je     6d0 <printf+0x180>
  write(fd, &c, 1);
 5e1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5e4:	83 ec 04             	sub    $0x4,%esp
 5e7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5eb:	6a 01                	push   $0x1
 5ed:	50                   	push   %eax
 5ee:	ff 75 08             	pushl  0x8(%ebp)
 5f1:	e8 1c fe ff ff       	call   412 <write>
 5f6:	83 c4 0c             	add    $0xc,%esp
 5f9:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5fc:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5ff:	6a 01                	push   $0x1
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 608:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 60a:	e8 03 fe ff ff       	call   412 <write>
  for(i = 0; fmt[i]; i++){
 60f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 613:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 616:	84 db                	test   %bl,%bl
 618:	75 89                	jne    5a3 <printf+0x53>
    }
  }
}
 61a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 61d:	5b                   	pop    %ebx
 61e:	5e                   	pop    %esi
 61f:	5f                   	pop    %edi
 620:	5d                   	pop    %ebp
 621:	c3                   	ret    
 622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 628:	bf 25 00 00 00       	mov    $0x25,%edi
 62d:	e9 66 ff ff ff       	jmp    598 <printf+0x48>
 632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 638:	83 ec 0c             	sub    $0xc,%esp
 63b:	b9 10 00 00 00       	mov    $0x10,%ecx
 640:	6a 00                	push   $0x0
 642:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	8b 17                	mov    (%edi),%edx
 64a:	e8 61 fe ff ff       	call   4b0 <printint>
        ap++;
 64f:	89 f8                	mov    %edi,%eax
 651:	83 c4 10             	add    $0x10,%esp
      state = 0;
 654:	31 ff                	xor    %edi,%edi
        ap++;
 656:	83 c0 04             	add    $0x4,%eax
 659:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 65c:	e9 37 ff ff ff       	jmp    598 <printf+0x48>
 661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 668:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 66b:	8b 08                	mov    (%eax),%ecx
        ap++;
 66d:	83 c0 04             	add    $0x4,%eax
 670:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 673:	85 c9                	test   %ecx,%ecx
 675:	0f 84 8e 00 00 00    	je     709 <printf+0x1b9>
        while(*s != 0){
 67b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 67e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 680:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 682:	84 c0                	test   %al,%al
 684:	0f 84 0e ff ff ff    	je     598 <printf+0x48>
 68a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 68d:	89 de                	mov    %ebx,%esi
 68f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 692:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 695:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 698:	83 ec 04             	sub    $0x4,%esp
          s++;
 69b:	83 c6 01             	add    $0x1,%esi
 69e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 6a1:	6a 01                	push   $0x1
 6a3:	57                   	push   %edi
 6a4:	53                   	push   %ebx
 6a5:	e8 68 fd ff ff       	call   412 <write>
        while(*s != 0){
 6aa:	0f b6 06             	movzbl (%esi),%eax
 6ad:	83 c4 10             	add    $0x10,%esp
 6b0:	84 c0                	test   %al,%al
 6b2:	75 e4                	jne    698 <printf+0x148>
 6b4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 6b7:	31 ff                	xor    %edi,%edi
 6b9:	e9 da fe ff ff       	jmp    598 <printf+0x48>
 6be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c8:	6a 01                	push   $0x1
 6ca:	e9 73 ff ff ff       	jmp    642 <printf+0xf2>
 6cf:	90                   	nop
  write(fd, &c, 1);
 6d0:	83 ec 04             	sub    $0x4,%esp
 6d3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 6d6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6d9:	6a 01                	push   $0x1
 6db:	e9 21 ff ff ff       	jmp    601 <printf+0xb1>
        putc(fd, *ap);
 6e0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 6e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6e6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 6e8:	6a 01                	push   $0x1
        ap++;
 6ea:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 6ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6f3:	50                   	push   %eax
 6f4:	ff 75 08             	pushl  0x8(%ebp)
 6f7:	e8 16 fd ff ff       	call   412 <write>
        ap++;
 6fc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 6ff:	83 c4 10             	add    $0x10,%esp
      state = 0;
 702:	31 ff                	xor    %edi,%edi
 704:	e9 8f fe ff ff       	jmp    598 <printf+0x48>
          s = "(null)";
 709:	bb b4 09 00 00       	mov    $0x9b4,%ebx
        while(*s != 0){
 70e:	b8 28 00 00 00       	mov    $0x28,%eax
 713:	e9 72 ff ff ff       	jmp    68a <printf+0x13a>
 718:	66 90                	xchg   %ax,%ax
 71a:	66 90                	xchg   %ax,%ax
 71c:	66 90                	xchg   %ax,%ax
 71e:	66 90                	xchg   %ax,%ax

00000720 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 720:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 721:	a1 10 0d 00 00       	mov    0xd10,%eax
{
 726:	89 e5                	mov    %esp,%ebp
 728:	57                   	push   %edi
 729:	56                   	push   %esi
 72a:	53                   	push   %ebx
 72b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 72e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 738:	39 c8                	cmp    %ecx,%eax
 73a:	8b 10                	mov    (%eax),%edx
 73c:	73 32                	jae    770 <free+0x50>
 73e:	39 d1                	cmp    %edx,%ecx
 740:	72 04                	jb     746 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 742:	39 d0                	cmp    %edx,%eax
 744:	72 32                	jb     778 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 746:	8b 73 fc             	mov    -0x4(%ebx),%esi
 749:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 74c:	39 fa                	cmp    %edi,%edx
 74e:	74 30                	je     780 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 750:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 753:	8b 50 04             	mov    0x4(%eax),%edx
 756:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 759:	39 f1                	cmp    %esi,%ecx
 75b:	74 3a                	je     797 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 75d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 75f:	a3 10 0d 00 00       	mov    %eax,0xd10
}
 764:	5b                   	pop    %ebx
 765:	5e                   	pop    %esi
 766:	5f                   	pop    %edi
 767:	5d                   	pop    %ebp
 768:	c3                   	ret    
 769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	39 d0                	cmp    %edx,%eax
 772:	72 04                	jb     778 <free+0x58>
 774:	39 d1                	cmp    %edx,%ecx
 776:	72 ce                	jb     746 <free+0x26>
{
 778:	89 d0                	mov    %edx,%eax
 77a:	eb bc                	jmp    738 <free+0x18>
 77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 780:	03 72 04             	add    0x4(%edx),%esi
 783:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 12                	mov    (%edx),%edx
 78a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 78d:	8b 50 04             	mov    0x4(%eax),%edx
 790:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 793:	39 f1                	cmp    %esi,%ecx
 795:	75 c6                	jne    75d <free+0x3d>
    p->s.size += bp->s.size;
 797:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 79a:	a3 10 0d 00 00       	mov    %eax,0xd10
    p->s.size += bp->s.size;
 79f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7a5:	89 10                	mov    %edx,(%eax)
}
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret    
 7ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	57                   	push   %edi
 7b4:	56                   	push   %esi
 7b5:	53                   	push   %ebx
 7b6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 7bc:	8b 15 10 0d 00 00    	mov    0xd10,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7c2:	8d 78 07             	lea    0x7(%eax),%edi
 7c5:	c1 ef 03             	shr    $0x3,%edi
 7c8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 7cb:	85 d2                	test   %edx,%edx
 7cd:	0f 84 9d 00 00 00    	je     870 <malloc+0xc0>
 7d3:	8b 02                	mov    (%edx),%eax
 7d5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7d8:	39 cf                	cmp    %ecx,%edi
 7da:	76 6c                	jbe    848 <malloc+0x98>
 7dc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 7e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7e7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7ea:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7f1:	eb 0e                	jmp    801 <malloc+0x51>
 7f3:	90                   	nop
 7f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f8:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7fa:	8b 48 04             	mov    0x4(%eax),%ecx
 7fd:	39 f9                	cmp    %edi,%ecx
 7ff:	73 47                	jae    848 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 801:	39 05 10 0d 00 00    	cmp    %eax,0xd10
 807:	89 c2                	mov    %eax,%edx
 809:	75 ed                	jne    7f8 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 80b:	83 ec 0c             	sub    $0xc,%esp
 80e:	56                   	push   %esi
 80f:	e8 66 fc ff ff       	call   47a <sbrk>
  if(p == (char*)-1)
 814:	83 c4 10             	add    $0x10,%esp
 817:	83 f8 ff             	cmp    $0xffffffff,%eax
 81a:	74 1c                	je     838 <malloc+0x88>
  hp->s.size = nu;
 81c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 81f:	83 ec 0c             	sub    $0xc,%esp
 822:	83 c0 08             	add    $0x8,%eax
 825:	50                   	push   %eax
 826:	e8 f5 fe ff ff       	call   720 <free>
  return freep;
 82b:	8b 15 10 0d 00 00    	mov    0xd10,%edx
      if((p = morecore(nunits)) == 0)
 831:	83 c4 10             	add    $0x10,%esp
 834:	85 d2                	test   %edx,%edx
 836:	75 c0                	jne    7f8 <malloc+0x48>
        return 0;
  }
}
 838:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 83b:	31 c0                	xor    %eax,%eax
}
 83d:	5b                   	pop    %ebx
 83e:	5e                   	pop    %esi
 83f:	5f                   	pop    %edi
 840:	5d                   	pop    %ebp
 841:	c3                   	ret    
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 848:	39 cf                	cmp    %ecx,%edi
 84a:	74 54                	je     8a0 <malloc+0xf0>
        p->s.size -= nunits;
 84c:	29 f9                	sub    %edi,%ecx
 84e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 851:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 854:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 857:	89 15 10 0d 00 00    	mov    %edx,0xd10
}
 85d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 860:	83 c0 08             	add    $0x8,%eax
}
 863:	5b                   	pop    %ebx
 864:	5e                   	pop    %esi
 865:	5f                   	pop    %edi
 866:	5d                   	pop    %ebp
 867:	c3                   	ret    
 868:	90                   	nop
 869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 870:	c7 05 10 0d 00 00 14 	movl   $0xd14,0xd10
 877:	0d 00 00 
 87a:	c7 05 14 0d 00 00 14 	movl   $0xd14,0xd14
 881:	0d 00 00 
    base.s.size = 0;
 884:	b8 14 0d 00 00       	mov    $0xd14,%eax
 889:	c7 05 18 0d 00 00 00 	movl   $0x0,0xd18
 890:	00 00 00 
 893:	e9 44 ff ff ff       	jmp    7dc <malloc+0x2c>
 898:	90                   	nop
 899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 8a0:	8b 08                	mov    (%eax),%ecx
 8a2:	89 0a                	mov    %ecx,(%edx)
 8a4:	eb b1                	jmp    857 <malloc+0xa7>
