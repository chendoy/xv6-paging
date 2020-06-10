
_sanity:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:



int
main(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	83 e4 f0             	and    $0xfffffff0,%esp
    // simple_printf_test();
    // simple_buffer_test();
    // simple_fork_test();
    // pagefault_test();
    pagefault_cow();
   a:	e8 21 01 00 00       	call   130 <pagefault_cow>
    // countinuetest();
    exit();
   f:	e8 1f 04 00 00       	call   433 <exit>
  14:	66 90                	xchg   %ax,%ax
  16:	66 90                	xchg   %ax,%ax
  18:	66 90                	xchg   %ax,%ax
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <simple_printf_test>:
{
  20:	f3 0f 1e fb          	endbr32 
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_printf_test --------\n");
  2a:	68 08 09 00 00       	push   $0x908
  2f:	6a 01                	push   $0x1
  31:	e8 6a 05 00 00       	call   5a0 <printf>
   printf(1, "sanity test!\n");
  36:	58                   	pop    %eax
  37:	5a                   	pop    %edx
  38:	68 f7 09 00 00       	push   $0x9f7
  3d:	6a 01                	push   $0x1
  3f:	e8 5c 05 00 00       	call   5a0 <printf>
}
  44:	83 c4 10             	add    $0x10,%esp
  47:	c9                   	leave  
  48:	c3                   	ret    
  49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000050 <simple_buffer_test>:
{
  50:	f3 0f 1e fb          	endbr32 
  54:	55                   	push   %ebp
  55:	89 e5                	mov    %esp,%ebp
  57:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_buffer_test --------\n");
  5a:	68 30 09 00 00       	push   $0x930
  5f:	6a 01                	push   $0x1
  61:	e8 3a 05 00 00       	call   5a0 <printf>
    printf(1, "buf[0] = %c, buf[512] = %c, buf[1023] = %c\n", buf[0], buf[512], buf[1023]);
  66:	c7 04 24 63 00 00 00 	movl   $0x63,(%esp)
  6d:	6a 62                	push   $0x62
  6f:	6a 61                	push   $0x61
  71:	68 58 09 00 00       	push   $0x958
  76:	6a 01                	push   $0x1
  78:	e8 23 05 00 00       	call   5a0 <printf>
}
  7d:	83 c4 20             	add    $0x20,%esp
  80:	c9                   	leave  
  81:	c3                   	ret    
  82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000090 <simple_fork_test>:
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	83 ec 10             	sub    $0x10,%esp
    printf(1, "\n-------- simple_fork_test --------\n");
  9a:	68 84 09 00 00       	push   $0x984
  9f:	6a 01                	push   $0x1
  a1:	e8 fa 04 00 00       	call   5a0 <printf>
    if((pid = fork()) == 0) // child
  a6:	e8 80 03 00 00       	call   42b <fork>
  ab:	83 c4 10             	add    $0x10,%esp
  ae:	85 c0                	test   %eax,%eax
  b0:	74 21                	je     d3 <simple_fork_test+0x43>
        sleep(20);
  b2:	83 ec 0c             	sub    $0xc,%esp
  b5:	6a 14                	push   $0x14
  b7:	e8 07 04 00 00       	call   4c3 <sleep>
        printf(1, "I'm parent!\n");
  bc:	58                   	pop    %eax
  bd:	5a                   	pop    %edx
  be:	68 11 0a 00 00       	push   $0xa11
  c3:	6a 01                	push   $0x1
  c5:	e8 d6 04 00 00       	call   5a0 <printf>
        wait();
  ca:	83 c4 10             	add    $0x10,%esp
}
  cd:	c9                   	leave  
        wait();
  ce:	e9 68 03 00 00       	jmp    43b <wait>
        printf(1, "I'm child!\n");
  d3:	51                   	push   %ecx
  d4:	51                   	push   %ecx
  d5:	68 05 0a 00 00       	push   $0xa05
  da:	6a 01                	push   $0x1
  dc:	e8 bf 04 00 00       	call   5a0 <printf>
        exit();
  e1:	e8 4d 03 00 00       	call   433 <exit>
  e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ed:	8d 76 00             	lea    0x0(%esi),%esi

000000f0 <pagefault_test>:
{
  f0:	f3 0f 1e fb          	endbr32 
  f4:	55                   	push   %ebp
  f5:	89 e5                	mov    %esp,%ebp
  f7:	53                   	push   %ebx
  f8:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
  fb:	68 00 f0 00 00       	push   $0xf000
 100:	e8 fb 06 00 00       	call   800 <malloc>
    memset((void*)arr, '0', len);
 105:	83 c4 0c             	add    $0xc,%esp
 108:	68 00 f0 00 00       	push   $0xf000
    char *arr = (char*)malloc(len);
 10d:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len);
 10f:	6a 30                	push   $0x30
 111:	50                   	push   %eax
 112:	e8 79 01 00 00       	call   290 <memset>
    arr[0] = '3';
 117:	c6 03 33             	movb   $0x33,(%ebx)
    return;
 11a:	83 c4 10             	add    $0x10,%esp
}
 11d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 120:	c9                   	leave  
 121:	c3                   	ret    
 122:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000130 <pagefault_cow>:
{
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	53                   	push   %ebx
 138:	83 ec 10             	sub    $0x10,%esp
    char *arr = (char*)malloc(len);
 13b:	68 00 f0 00 00       	push   $0xf000
 140:	e8 bb 06 00 00       	call   800 <malloc>
    memset((void*)arr, '0', len); // will cause some pagefaults
 145:	83 c4 0c             	add    $0xc,%esp
 148:	68 00 f0 00 00       	push   $0xf000
    char *arr = (char*)malloc(len);
 14d:	89 c3                	mov    %eax,%ebx
    memset((void*)arr, '0', len); // will cause some pagefaults
 14f:	6a 30                	push   $0x30
 151:	50                   	push   %eax
 152:	e8 39 01 00 00       	call   290 <memset>
    printf(1,"before fork num swap file: \n");
 157:	5a                   	pop    %edx
 158:	59                   	pop    %ecx
 159:	68 1e 0a 00 00       	push   $0xa1e
 15e:	6a 01                	push   $0x1
 160:	e8 3b 04 00 00       	call   5a0 <printf>
    if((pid = fork()) == 0) // child
 165:	e8 c1 02 00 00       	call   42b <fork>
 16a:	83 c4 10             	add    $0x10,%esp
 16d:	85 c0                	test   %eax,%eax
 16f:	74 36                	je     1a7 <pagefault_cow+0x77>
        printf(1, "parent: arr[0]: %c (should be \'0\')\n" ,arr[0]);
 171:	0f be 03             	movsbl (%ebx),%eax
 174:	83 ec 04             	sub    $0x4,%esp
 177:	50                   	push   %eax
 178:	68 ac 09 00 00       	push   $0x9ac
 17d:	6a 01                	push   $0x1
 17f:	e8 1c 04 00 00       	call   5a0 <printf>
        printf(1, "parent: arr[1000]: %c (should be \'0\')\n",arr[1000]);
 184:	0f be 83 e8 03 00 00 	movsbl 0x3e8(%ebx),%eax
 18b:	83 c4 0c             	add    $0xc,%esp
 18e:	50                   	push   %eax
 18f:	68 d0 09 00 00       	push   $0x9d0
 194:	6a 01                	push   $0x1
 196:	e8 05 04 00 00       	call   5a0 <printf>
}
 19b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
        wait();
 19e:	83 c4 10             	add    $0x10,%esp
}
 1a1:	c9                   	leave  
        wait();
 1a2:	e9 94 02 00 00       	jmp    43b <wait>
        printf(1, "child: writing \'1\'s arr\n");
 1a7:	50                   	push   %eax
 1a8:	50                   	push   %eax
 1a9:	68 3b 0a 00 00       	push   $0xa3b
 1ae:	6a 01                	push   $0x1
 1b0:	e8 eb 03 00 00       	call   5a0 <printf>
        memset((void*)arr, '1', len);
 1b5:	83 c4 0c             	add    $0xc,%esp
 1b8:	68 00 f0 00 00       	push   $0xf000
 1bd:	6a 31                	push   $0x31
 1bf:	53                   	push   %ebx
 1c0:	e8 cb 00 00 00       	call   290 <memset>
        exit();
 1c5:	e8 69 02 00 00       	call   433 <exit>
 1ca:	66 90                	xchg   %ax,%ax
 1cc:	66 90                	xchg   %ax,%ax
 1ce:	66 90                	xchg   %ax,%ax

000001d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d5:	31 c0                	xor    %eax,%eax
{
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	53                   	push   %ebx
 1da:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1e0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1e4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1e7:	83 c0 01             	add    $0x1,%eax
 1ea:	84 d2                	test   %dl,%dl
 1ec:	75 f2                	jne    1e0 <strcpy+0x10>
    ;
  return os;
}
 1ee:	89 c8                	mov    %ecx,%eax
 1f0:	5b                   	pop    %ebx
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    
 1f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000200 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	53                   	push   %ebx
 208:	8b 4d 08             	mov    0x8(%ebp),%ecx
 20b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 20e:	0f b6 01             	movzbl (%ecx),%eax
 211:	0f b6 1a             	movzbl (%edx),%ebx
 214:	84 c0                	test   %al,%al
 216:	75 19                	jne    231 <strcmp+0x31>
 218:	eb 26                	jmp    240 <strcmp+0x40>
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 220:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 224:	83 c1 01             	add    $0x1,%ecx
 227:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 22a:	0f b6 1a             	movzbl (%edx),%ebx
 22d:	84 c0                	test   %al,%al
 22f:	74 0f                	je     240 <strcmp+0x40>
 231:	38 d8                	cmp    %bl,%al
 233:	74 eb                	je     220 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 235:	29 d8                	sub    %ebx,%eax
}
 237:	5b                   	pop    %ebx
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    
 23a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 240:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 242:	29 d8                	sub    %ebx,%eax
}
 244:	5b                   	pop    %ebx
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    
 247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24e:	66 90                	xchg   %ax,%ax

00000250 <strlen>:

uint
strlen(const char *s)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 25a:	80 3a 00             	cmpb   $0x0,(%edx)
 25d:	74 21                	je     280 <strlen+0x30>
 25f:	31 c0                	xor    %eax,%eax
 261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 268:	83 c0 01             	add    $0x1,%eax
 26b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 26f:	89 c1                	mov    %eax,%ecx
 271:	75 f5                	jne    268 <strlen+0x18>
    ;
  return n;
}
 273:	89 c8                	mov    %ecx,%eax
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
 277:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 280:	31 c9                	xor    %ecx,%ecx
}
 282:	5d                   	pop    %ebp
 283:	89 c8                	mov    %ecx,%eax
 285:	c3                   	ret    
 286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28d:	8d 76 00             	lea    0x0(%esi),%esi

00000290 <memset>:

void*
memset(void *dst, int c, uint n)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	57                   	push   %edi
 298:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 29b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 29e:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a1:	89 d7                	mov    %edx,%edi
 2a3:	fc                   	cld    
 2a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2a6:	89 d0                	mov    %edx,%eax
 2a8:	5f                   	pop    %edi
 2a9:	5d                   	pop    %ebp
 2aa:	c3                   	ret    
 2ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2af:	90                   	nop

000002b0 <strchr>:

char*
strchr(const char *s, char c)
{
 2b0:	f3 0f 1e fb          	endbr32 
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2be:	0f b6 10             	movzbl (%eax),%edx
 2c1:	84 d2                	test   %dl,%dl
 2c3:	75 16                	jne    2db <strchr+0x2b>
 2c5:	eb 21                	jmp    2e8 <strchr+0x38>
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
 2d0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2d4:	83 c0 01             	add    $0x1,%eax
 2d7:	84 d2                	test   %dl,%dl
 2d9:	74 0d                	je     2e8 <strchr+0x38>
    if(*s == c)
 2db:	38 d1                	cmp    %dl,%cl
 2dd:	75 f1                	jne    2d0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2df:	5d                   	pop    %ebp
 2e0:	c3                   	ret    
 2e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2e8:	31 c0                	xor    %eax,%eax
}
 2ea:	5d                   	pop    %ebp
 2eb:	c3                   	ret    
 2ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002f0 <gets>:

char*
gets(char *buf, int max)
{
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	57                   	push   %edi
 2f8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f9:	31 f6                	xor    %esi,%esi
{
 2fb:	53                   	push   %ebx
 2fc:	89 f3                	mov    %esi,%ebx
 2fe:	83 ec 1c             	sub    $0x1c,%esp
 301:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 304:	eb 33                	jmp    339 <gets+0x49>
 306:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 30d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 310:	83 ec 04             	sub    $0x4,%esp
 313:	8d 45 e7             	lea    -0x19(%ebp),%eax
 316:	6a 01                	push   $0x1
 318:	50                   	push   %eax
 319:	6a 00                	push   $0x0
 31b:	e8 2b 01 00 00       	call   44b <read>
    if(cc < 1)
 320:	83 c4 10             	add    $0x10,%esp
 323:	85 c0                	test   %eax,%eax
 325:	7e 1c                	jle    343 <gets+0x53>
      break;
    buf[i++] = c;
 327:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 32b:	83 c7 01             	add    $0x1,%edi
 32e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 331:	3c 0a                	cmp    $0xa,%al
 333:	74 23                	je     358 <gets+0x68>
 335:	3c 0d                	cmp    $0xd,%al
 337:	74 1f                	je     358 <gets+0x68>
  for(i=0; i+1 < max; ){
 339:	83 c3 01             	add    $0x1,%ebx
 33c:	89 fe                	mov    %edi,%esi
 33e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 341:	7c cd                	jl     310 <gets+0x20>
 343:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 345:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 348:	c6 03 00             	movb   $0x0,(%ebx)
}
 34b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 34e:	5b                   	pop    %ebx
 34f:	5e                   	pop    %esi
 350:	5f                   	pop    %edi
 351:	5d                   	pop    %ebp
 352:	c3                   	ret    
 353:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 357:	90                   	nop
 358:	8b 75 08             	mov    0x8(%ebp),%esi
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	01 de                	add    %ebx,%esi
 360:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 362:	c6 03 00             	movb   $0x0,(%ebx)
}
 365:	8d 65 f4             	lea    -0xc(%ebp),%esp
 368:	5b                   	pop    %ebx
 369:	5e                   	pop    %esi
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    
 36d:	8d 76 00             	lea    0x0(%esi),%esi

00000370 <stat>:

int
stat(const char *n, struct stat *st)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	56                   	push   %esi
 378:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 379:	83 ec 08             	sub    $0x8,%esp
 37c:	6a 00                	push   $0x0
 37e:	ff 75 08             	pushl  0x8(%ebp)
 381:	e8 ed 00 00 00       	call   473 <open>
  if(fd < 0)
 386:	83 c4 10             	add    $0x10,%esp
 389:	85 c0                	test   %eax,%eax
 38b:	78 2b                	js     3b8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 38d:	83 ec 08             	sub    $0x8,%esp
 390:	ff 75 0c             	pushl  0xc(%ebp)
 393:	89 c3                	mov    %eax,%ebx
 395:	50                   	push   %eax
 396:	e8 f0 00 00 00       	call   48b <fstat>
  close(fd);
 39b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 39e:	89 c6                	mov    %eax,%esi
  close(fd);
 3a0:	e8 b6 00 00 00       	call   45b <close>
  return r;
 3a5:	83 c4 10             	add    $0x10,%esp
}
 3a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ab:	89 f0                	mov    %esi,%eax
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3bd:	eb e9                	jmp    3a8 <stat+0x38>
 3bf:	90                   	nop

000003c0 <atoi>:

int
atoi(const char *s)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	53                   	push   %ebx
 3c8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3cb:	0f be 02             	movsbl (%edx),%eax
 3ce:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3d1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3d4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3d9:	77 1a                	ja     3f5 <atoi+0x35>
 3db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3df:	90                   	nop
    n = n*10 + *s++ - '0';
 3e0:	83 c2 01             	add    $0x1,%edx
 3e3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3e6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ea:	0f be 02             	movsbl (%edx),%eax
 3ed:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3f0:	80 fb 09             	cmp    $0x9,%bl
 3f3:	76 eb                	jbe    3e0 <atoi+0x20>
  return n;
}
 3f5:	89 c8                	mov    %ecx,%eax
 3f7:	5b                   	pop    %ebx
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000400 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	8b 45 10             	mov    0x10(%ebp),%eax
 40b:	8b 55 08             	mov    0x8(%ebp),%edx
 40e:	56                   	push   %esi
 40f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 412:	85 c0                	test   %eax,%eax
 414:	7e 0f                	jle    425 <memmove+0x25>
 416:	01 d0                	add    %edx,%eax
  dst = vdst;
 418:	89 d7                	mov    %edx,%edi
 41a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 420:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 421:	39 f8                	cmp    %edi,%eax
 423:	75 fb                	jne    420 <memmove+0x20>
  return vdst;
}
 425:	5e                   	pop    %esi
 426:	89 d0                	mov    %edx,%eax
 428:	5f                   	pop    %edi
 429:	5d                   	pop    %ebp
 42a:	c3                   	ret    

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <getNumberOfFreePages>:
SYSCALL(getNumberOfFreePages)
 4d3:	b8 16 00 00 00       	mov    $0x16,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <getTotalFreePages>:
SYSCALL(getTotalFreePages)
 4db:	b8 17 00 00 00       	mov    $0x17,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    
 4e3:	66 90                	xchg   %ax,%ax
 4e5:	66 90                	xchg   %ax,%ax
 4e7:	66 90                	xchg   %ax,%ax
 4e9:	66 90                	xchg   %ax,%ax
 4eb:	66 90                	xchg   %ax,%ax
 4ed:	66 90                	xchg   %ax,%ax
 4ef:	90                   	nop

000004f0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	57                   	push   %edi
 4f4:	56                   	push   %esi
 4f5:	53                   	push   %ebx
 4f6:	83 ec 3c             	sub    $0x3c,%esp
 4f9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4fc:	89 d1                	mov    %edx,%ecx
{
 4fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 501:	85 d2                	test   %edx,%edx
 503:	0f 89 7f 00 00 00    	jns    588 <printint+0x98>
 509:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 50d:	74 79                	je     588 <printint+0x98>
    neg = 1;
 50f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 516:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 518:	31 db                	xor    %ebx,%ebx
 51a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 51d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 520:	89 c8                	mov    %ecx,%eax
 522:	31 d2                	xor    %edx,%edx
 524:	89 cf                	mov    %ecx,%edi
 526:	f7 75 c4             	divl   -0x3c(%ebp)
 529:	0f b6 92 5c 0a 00 00 	movzbl 0xa5c(%edx),%edx
 530:	89 45 c0             	mov    %eax,-0x40(%ebp)
 533:	89 d8                	mov    %ebx,%eax
 535:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 538:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 53b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 53e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 541:	76 dd                	jbe    520 <printint+0x30>
  if(neg)
 543:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 546:	85 c9                	test   %ecx,%ecx
 548:	74 0c                	je     556 <printint+0x66>
    buf[i++] = '-';
 54a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 54f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 551:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 556:	8b 7d b8             	mov    -0x48(%ebp),%edi
 559:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 55d:	eb 07                	jmp    566 <printint+0x76>
 55f:	90                   	nop
 560:	0f b6 13             	movzbl (%ebx),%edx
 563:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 566:	83 ec 04             	sub    $0x4,%esp
 569:	88 55 d7             	mov    %dl,-0x29(%ebp)
 56c:	6a 01                	push   $0x1
 56e:	56                   	push   %esi
 56f:	57                   	push   %edi
 570:	e8 de fe ff ff       	call   453 <write>
  while(--i >= 0)
 575:	83 c4 10             	add    $0x10,%esp
 578:	39 de                	cmp    %ebx,%esi
 57a:	75 e4                	jne    560 <printint+0x70>
    putc(fd, buf[i]);
}
 57c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57f:	5b                   	pop    %ebx
 580:	5e                   	pop    %esi
 581:	5f                   	pop    %edi
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    
 584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 588:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 58f:	eb 87                	jmp    518 <printint+0x28>
 591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 598:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59f:	90                   	nop

000005a0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a0:	f3 0f 1e fb          	endbr32 
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	57                   	push   %edi
 5a8:	56                   	push   %esi
 5a9:	53                   	push   %ebx
 5aa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ad:	8b 75 0c             	mov    0xc(%ebp),%esi
 5b0:	0f b6 1e             	movzbl (%esi),%ebx
 5b3:	84 db                	test   %bl,%bl
 5b5:	0f 84 b4 00 00 00    	je     66f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5bb:	8d 45 10             	lea    0x10(%ebp),%eax
 5be:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5c1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5c4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5c6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5c9:	eb 33                	jmp    5fe <printf+0x5e>
 5cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop
 5d0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5d3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5d8:	83 f8 25             	cmp    $0x25,%eax
 5db:	74 17                	je     5f4 <printf+0x54>
  write(fd, &c, 1);
 5dd:	83 ec 04             	sub    $0x4,%esp
 5e0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5e3:	6a 01                	push   $0x1
 5e5:	57                   	push   %edi
 5e6:	ff 75 08             	pushl  0x8(%ebp)
 5e9:	e8 65 fe ff ff       	call   453 <write>
 5ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 5f1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 5f4:	0f b6 1e             	movzbl (%esi),%ebx
 5f7:	83 c6 01             	add    $0x1,%esi
 5fa:	84 db                	test   %bl,%bl
 5fc:	74 71                	je     66f <printf+0xcf>
    c = fmt[i] & 0xff;
 5fe:	0f be cb             	movsbl %bl,%ecx
 601:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 604:	85 d2                	test   %edx,%edx
 606:	74 c8                	je     5d0 <printf+0x30>
      }
    } else if(state == '%'){
 608:	83 fa 25             	cmp    $0x25,%edx
 60b:	75 e7                	jne    5f4 <printf+0x54>
      if(c == 'd'){
 60d:	83 f8 64             	cmp    $0x64,%eax
 610:	0f 84 9a 00 00 00    	je     6b0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 616:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 61c:	83 f9 70             	cmp    $0x70,%ecx
 61f:	74 5f                	je     680 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 621:	83 f8 73             	cmp    $0x73,%eax
 624:	0f 84 d6 00 00 00    	je     700 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 62a:	83 f8 63             	cmp    $0x63,%eax
 62d:	0f 84 8d 00 00 00    	je     6c0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 633:	83 f8 25             	cmp    $0x25,%eax
 636:	0f 84 b4 00 00 00    	je     6f0 <printf+0x150>
  write(fd, &c, 1);
 63c:	83 ec 04             	sub    $0x4,%esp
 63f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 643:	6a 01                	push   $0x1
 645:	57                   	push   %edi
 646:	ff 75 08             	pushl  0x8(%ebp)
 649:	e8 05 fe ff ff       	call   453 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 64e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 651:	83 c4 0c             	add    $0xc,%esp
 654:	6a 01                	push   $0x1
 656:	83 c6 01             	add    $0x1,%esi
 659:	57                   	push   %edi
 65a:	ff 75 08             	pushl  0x8(%ebp)
 65d:	e8 f1 fd ff ff       	call   453 <write>
  for(i = 0; fmt[i]; i++){
 662:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 666:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 669:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 66b:	84 db                	test   %bl,%bl
 66d:	75 8f                	jne    5fe <printf+0x5e>
    }
  }
}
 66f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 672:	5b                   	pop    %ebx
 673:	5e                   	pop    %esi
 674:	5f                   	pop    %edi
 675:	5d                   	pop    %ebp
 676:	c3                   	ret    
 677:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 680:	83 ec 0c             	sub    $0xc,%esp
 683:	b9 10 00 00 00       	mov    $0x10,%ecx
 688:	6a 00                	push   $0x0
 68a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	8b 13                	mov    (%ebx),%edx
 692:	e8 59 fe ff ff       	call   4f0 <printint>
        ap++;
 697:	89 d8                	mov    %ebx,%eax
 699:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69c:	31 d2                	xor    %edx,%edx
        ap++;
 69e:	83 c0 04             	add    $0x4,%eax
 6a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6a4:	e9 4b ff ff ff       	jmp    5f4 <printf+0x54>
 6a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6b0:	83 ec 0c             	sub    $0xc,%esp
 6b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6b8:	6a 01                	push   $0x1
 6ba:	eb ce                	jmp    68a <printf+0xea>
 6bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6c0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6c3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6c6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6c8:	6a 01                	push   $0x1
        ap++;
 6ca:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6cd:	57                   	push   %edi
 6ce:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6d1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6d4:	e8 7a fd ff ff       	call   453 <write>
        ap++;
 6d9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6dc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6df:	31 d2                	xor    %edx,%edx
 6e1:	e9 0e ff ff ff       	jmp    5f4 <printf+0x54>
 6e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 6f0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6f3:	83 ec 04             	sub    $0x4,%esp
 6f6:	e9 59 ff ff ff       	jmp    654 <printf+0xb4>
 6fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
        s = (char*)*ap;
 700:	8b 45 d0             	mov    -0x30(%ebp),%eax
 703:	8b 18                	mov    (%eax),%ebx
        ap++;
 705:	83 c0 04             	add    $0x4,%eax
 708:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 70b:	85 db                	test   %ebx,%ebx
 70d:	74 17                	je     726 <printf+0x186>
        while(*s != 0){
 70f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 712:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 714:	84 c0                	test   %al,%al
 716:	0f 84 d8 fe ff ff    	je     5f4 <printf+0x54>
 71c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 71f:	89 de                	mov    %ebx,%esi
 721:	8b 5d 08             	mov    0x8(%ebp),%ebx
 724:	eb 1a                	jmp    740 <printf+0x1a0>
          s = "(null)";
 726:	bb 54 0a 00 00       	mov    $0xa54,%ebx
        while(*s != 0){
 72b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 72e:	b8 28 00 00 00       	mov    $0x28,%eax
 733:	89 de                	mov    %ebx,%esi
 735:	8b 5d 08             	mov    0x8(%ebp),%ebx
 738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
  write(fd, &c, 1);
 740:	83 ec 04             	sub    $0x4,%esp
          s++;
 743:	83 c6 01             	add    $0x1,%esi
 746:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 749:	6a 01                	push   $0x1
 74b:	57                   	push   %edi
 74c:	53                   	push   %ebx
 74d:	e8 01 fd ff ff       	call   453 <write>
        while(*s != 0){
 752:	0f b6 06             	movzbl (%esi),%eax
 755:	83 c4 10             	add    $0x10,%esp
 758:	84 c0                	test   %al,%al
 75a:	75 e4                	jne    740 <printf+0x1a0>
 75c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 75f:	31 d2                	xor    %edx,%edx
 761:	e9 8e fe ff ff       	jmp    5f4 <printf+0x54>
 766:	66 90                	xchg   %ax,%ax
 768:	66 90                	xchg   %ax,%ax
 76a:	66 90                	xchg   %ax,%ax
 76c:	66 90                	xchg   %ax,%ax
 76e:	66 90                	xchg   %ax,%ax

00000770 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 770:	f3 0f 1e fb          	endbr32 
 774:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 775:	a1 ac 0d 00 00       	mov    0xdac,%eax
{
 77a:	89 e5                	mov    %esp,%ebp
 77c:	57                   	push   %edi
 77d:	56                   	push   %esi
 77e:	53                   	push   %ebx
 77f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 782:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 784:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 787:	39 c8                	cmp    %ecx,%eax
 789:	73 15                	jae    7a0 <free+0x30>
 78b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 78f:	90                   	nop
 790:	39 d1                	cmp    %edx,%ecx
 792:	72 14                	jb     7a8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 794:	39 d0                	cmp    %edx,%eax
 796:	73 10                	jae    7a8 <free+0x38>
{
 798:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 79a:	8b 10                	mov    (%eax),%edx
 79c:	39 c8                	cmp    %ecx,%eax
 79e:	72 f0                	jb     790 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a0:	39 d0                	cmp    %edx,%eax
 7a2:	72 f4                	jb     798 <free+0x28>
 7a4:	39 d1                	cmp    %edx,%ecx
 7a6:	73 f0                	jae    798 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ae:	39 fa                	cmp    %edi,%edx
 7b0:	74 1e                	je     7d0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7b5:	8b 50 04             	mov    0x4(%eax),%edx
 7b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7bb:	39 f1                	cmp    %esi,%ecx
 7bd:	74 28                	je     7e7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7c1:	5b                   	pop    %ebx
  freep = p;
 7c2:	a3 ac 0d 00 00       	mov    %eax,0xdac
}
 7c7:	5e                   	pop    %esi
 7c8:	5f                   	pop    %edi
 7c9:	5d                   	pop    %ebp
 7ca:	c3                   	ret    
 7cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7d0:	03 72 04             	add    0x4(%edx),%esi
 7d3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d6:	8b 10                	mov    (%eax),%edx
 7d8:	8b 12                	mov    (%edx),%edx
 7da:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7dd:	8b 50 04             	mov    0x4(%eax),%edx
 7e0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7e3:	39 f1                	cmp    %esi,%ecx
 7e5:	75 d8                	jne    7bf <free+0x4f>
    p->s.size += bp->s.size;
 7e7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7ea:	a3 ac 0d 00 00       	mov    %eax,0xdac
    p->s.size += bp->s.size;
 7ef:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 7f5:	89 10                	mov    %edx,(%eax)
}
 7f7:	5b                   	pop    %ebx
 7f8:	5e                   	pop    %esi
 7f9:	5f                   	pop    %edi
 7fa:	5d                   	pop    %ebp
 7fb:	c3                   	ret    
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000800 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 800:	f3 0f 1e fb          	endbr32 
 804:	55                   	push   %ebp
 805:	89 e5                	mov    %esp,%ebp
 807:	57                   	push   %edi
 808:	56                   	push   %esi
 809:	53                   	push   %ebx
 80a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 810:	8b 3d ac 0d 00 00    	mov    0xdac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 816:	8d 70 07             	lea    0x7(%eax),%esi
 819:	c1 ee 03             	shr    $0x3,%esi
 81c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 81f:	85 ff                	test   %edi,%edi
 821:	0f 84 a9 00 00 00    	je     8d0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 827:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 829:	8b 48 04             	mov    0x4(%eax),%ecx
 82c:	39 f1                	cmp    %esi,%ecx
 82e:	73 6d                	jae    89d <malloc+0x9d>
 830:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 836:	bb 00 10 00 00       	mov    $0x1000,%ebx
 83b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 83e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 845:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 848:	eb 17                	jmp    861 <malloc+0x61>
 84a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 850:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 852:	8b 4a 04             	mov    0x4(%edx),%ecx
 855:	39 f1                	cmp    %esi,%ecx
 857:	73 4f                	jae    8a8 <malloc+0xa8>
 859:	8b 3d ac 0d 00 00    	mov    0xdac,%edi
 85f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 861:	39 c7                	cmp    %eax,%edi
 863:	75 eb                	jne    850 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 865:	83 ec 0c             	sub    $0xc,%esp
 868:	ff 75 e4             	pushl  -0x1c(%ebp)
 86b:	e8 4b fc ff ff       	call   4bb <sbrk>
  if(p == (char*)-1)
 870:	83 c4 10             	add    $0x10,%esp
 873:	83 f8 ff             	cmp    $0xffffffff,%eax
 876:	74 1b                	je     893 <malloc+0x93>
  hp->s.size = nu;
 878:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 87b:	83 ec 0c             	sub    $0xc,%esp
 87e:	83 c0 08             	add    $0x8,%eax
 881:	50                   	push   %eax
 882:	e8 e9 fe ff ff       	call   770 <free>
  return freep;
 887:	a1 ac 0d 00 00       	mov    0xdac,%eax
      if((p = morecore(nunits)) == 0)
 88c:	83 c4 10             	add    $0x10,%esp
 88f:	85 c0                	test   %eax,%eax
 891:	75 bd                	jne    850 <malloc+0x50>
        return 0;
  }
}
 893:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 896:	31 c0                	xor    %eax,%eax
}
 898:	5b                   	pop    %ebx
 899:	5e                   	pop    %esi
 89a:	5f                   	pop    %edi
 89b:	5d                   	pop    %ebp
 89c:	c3                   	ret    
    if(p->s.size >= nunits){
 89d:	89 c2                	mov    %eax,%edx
 89f:	89 f8                	mov    %edi,%eax
 8a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8a8:	39 ce                	cmp    %ecx,%esi
 8aa:	74 54                	je     900 <malloc+0x100>
        p->s.size -= nunits;
 8ac:	29 f1                	sub    %esi,%ecx
 8ae:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8b1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8b4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8b7:	a3 ac 0d 00 00       	mov    %eax,0xdac
}
 8bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8bf:	8d 42 08             	lea    0x8(%edx),%eax
}
 8c2:	5b                   	pop    %ebx
 8c3:	5e                   	pop    %esi
 8c4:	5f                   	pop    %edi
 8c5:	5d                   	pop    %ebp
 8c6:	c3                   	ret    
 8c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ce:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8d0:	c7 05 ac 0d 00 00 b0 	movl   $0xdb0,0xdac
 8d7:	0d 00 00 
    base.s.size = 0;
 8da:	bf b0 0d 00 00       	mov    $0xdb0,%edi
    base.s.ptr = freep = prevp = &base;
 8df:	c7 05 b0 0d 00 00 b0 	movl   $0xdb0,0xdb0
 8e6:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 8eb:	c7 05 b4 0d 00 00 00 	movl   $0x0,0xdb4
 8f2:	00 00 00 
    if(p->s.size >= nunits){
 8f5:	e9 36 ff ff ff       	jmp    830 <malloc+0x30>
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 900:	8b 0a                	mov    (%edx),%ecx
 902:	89 08                	mov    %ecx,(%eax)
 904:	eb b1                	jmp    8b7 <malloc+0xb7>
