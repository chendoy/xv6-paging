
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 00 e6 11 80       	mov    $0x8011e600,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 34 10 80       	mov    $0x801034f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 34 e6 11 80       	mov    $0x8011e634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 7f 10 80       	push   $0x80107f60
80100051:	68 00 e6 11 80       	push   $0x8011e600
80100056:	e8 25 4a 00 00       	call   80104a80 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 4c 2d 12 80 fc 	movl   $0x80122cfc,0x80122d4c
80100062:	2c 12 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 50 2d 12 80 fc 	movl   $0x80122cfc,0x80122d50
8010006c:	2c 12 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba fc 2c 12 80       	mov    $0x80122cfc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc 2c 12 80 	movl   $0x80122cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7f 10 80       	push   $0x80107f67
80100097:	50                   	push   %eax
80100098:	e8 b3 48 00 00       	call   80104950 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 2d 12 80       	mov    0x80122d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 50 2d 12 80    	mov    %ebx,0x80122d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d fc 2c 12 80       	cmp    $0x80122cfc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 00 e6 11 80       	push   $0x8011e600
801000e4:	e8 d7 4a 00 00       	call   80104bc0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 2d 12 80    	mov    0x80122d50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc 2c 12 80    	cmp    $0x80122cfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 2c 12 80    	cmp    $0x80122cfc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c 2d 12 80    	mov    0x80122d4c,%ebx
80100126:	81 fb fc 2c 12 80    	cmp    $0x80122cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 2c 12 80    	cmp    $0x80122cfc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 e6 11 80       	push   $0x8011e600
80100162:	e8 19 4b 00 00       	call   80104c80 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 48 00 00       	call   80104990 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 7d 23 00 00       	call   80102500 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 7f 10 80       	push   $0x80107f6e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 7d 48 00 00       	call   80104a30 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 37 23 00 00       	jmp    80102500 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 7f 10 80       	push   $0x80107f7f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 3c 48 00 00       	call   80104a30 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 47 00 00       	call   801049f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 e6 11 80 	movl   $0x8011e600,(%esp)
8010020b:	e8 b0 49 00 00       	call   80104bc0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 50 2d 12 80       	mov    0x80122d50,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 fc 2c 12 80 	movl   $0x80122cfc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 50 2d 12 80       	mov    0x80122d50,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 50 2d 12 80    	mov    %ebx,0x80122d50
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 00 e6 11 80 	movl   $0x8011e600,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 1f 4a 00 00       	jmp    80104c80 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 7f 10 80       	push   $0x80107f86
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 1b 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 2f 49 00 00       	call   80104bc0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 2f 12 80    	mov    0x80122fe0,%edx
801002a7:	39 15 e4 2f 12 80    	cmp    %edx,0x80122fe4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 e0 2f 12 80       	push   $0x80122fe0
801002c5:	e8 c6 42 00 00       	call   80104590 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 2f 12 80    	mov    0x80122fe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 2f 12 80    	cmp    0x80122fe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 f0 3b 00 00       	call   80103ed0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 8c 49 00 00       	call   80104c80 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 c4 13 00 00       	call   801016c0 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 e0 2f 12 80       	mov    %eax,0x80122fe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 2f 12 80 	movsbl -0x7fedd0a0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 2e 49 00 00       	call   80104c80 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 66 13 00 00       	call   801016c0 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 e0 2f 12 80    	mov    %edx,0x80122fe0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 d2 29 00 00       	call   80102d80 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 7f 10 80       	push   $0x80107f8d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 ba 8a 10 80 	movl   $0x80108aba,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 c3 46 00 00       	call   80104aa0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 7f 10 80       	push   $0x80107fa1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 81 5f 00 00       	call   801063c0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 cf 5e 00 00       	call   801063c0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 c3 5e 00 00       	call   801063c0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 b7 5e 00 00       	call   801063c0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 57 48 00 00       	call   80104d80 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 8a 47 00 00       	call   80104cd0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 7f 10 80       	push   $0x80107fa5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 d0 7f 10 80 	movzbl -0x7fef8030(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 8c 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 a0 45 00 00       	call   80104bc0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 34 46 00 00       	call   80104c80 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 6b 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 5c 45 00 00       	call   80104c80 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba b8 7f 10 80       	mov    $0x80107fb8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 cb 43 00 00       	call   80104bc0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 7f 10 80       	push   $0x80107fbf
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 98 43 00 00       	call   80104bc0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 e8 2f 12 80       	mov    0x80122fe8,%eax
80100856:	3b 05 e4 2f 12 80    	cmp    0x80122fe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 2f 12 80       	mov    %eax,0x80122fe8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 f3 43 00 00       	call   80104c80 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 e8 2f 12 80       	mov    0x80122fe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 2f 12 80    	sub    0x80122fe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 2f 12 80    	mov    %edx,0x80122fe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 2f 12 80    	mov    %cl,-0x7fedd0a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 2f 12 80       	mov    0x80122fe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 2f 12 80    	cmp    %eax,0x80122fe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 2f 12 80       	mov    %eax,0x80122fe4
          wakeup(&input.r);
80100911:	68 e0 2f 12 80       	push   $0x80122fe0
80100916:	e8 65 3e 00 00       	call   80104780 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 2f 12 80       	mov    0x80122fe8,%eax
8010093d:	39 05 e4 2f 12 80    	cmp    %eax,0x80122fe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 2f 12 80       	mov    %eax,0x80122fe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 2f 12 80       	mov    0x80122fe8,%eax
80100964:	3b 05 e4 2f 12 80    	cmp    0x80122fe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 2f 12 80 0a 	cmpb   $0xa,-0x7fedd0a0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 c4 3e 00 00       	jmp    80104860 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 2f 12 80 0a 	movb   $0xa,-0x7fedd0a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 2f 12 80       	mov    0x80122fe8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 c8 7f 10 80       	push   $0x80107fc8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 ab 40 00 00       	call   80104a80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac 39 12 80 00 	movl   $0x80100600,0x801239ac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 39 12 80 70 	movl   $0x80100270,0x801239a8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 b2 1c 00 00       	call   801026b0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 af 34 00 00       	call   80103ed0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 c4 27 00 00       	call   801031f0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 e9 14 00 00       	call   80101f20 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 73 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 42 0f 00 00       	call   801019a0 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 e1 0e 00 00       	call   80101950 <iunlockput>
    end_op();
80100a6f:	e8 ec 27 00 00       	call   80103260 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 27 6d 00 00       	call   801077c0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 ca 02 00 00    	je     80100d89 <exec+0x379>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 75 69 00 00       	call   80107470 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 a3 66 00 00       	call   801071d0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 43 0e 00 00       	call   801019a0 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 c9 6b 00 00       	call   80107740 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 b6 0d 00 00       	call   80101950 <iunlockput>
  end_op();
80100b9a:	e8 c1 26 00 00       	call   80103260 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 c1 68 00 00       	call   80107470 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 6b 00 00       	call   80107740 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 88 26 00 00       	call   80103260 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 e1 7f 10 80       	push   $0x80107fe1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 55 6c 00 00       	call   80107860 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 b2 42 00 00       	call   80104ef0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	58                   	pop    %eax
80100c43:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 9f 42 00 00       	call   80104ef0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 0e 72 00 00       	call   80107e70 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 a4 71 00 00       	call   80107e70 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d07:	50                   	push   %eax
80100d08:	e8 a3 41 00 00       	call   80104eb0 <safestrcpy>
80100d0d:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100d13:	89 fa                	mov    %edi,%edx
80100d15:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
80100d1b:	81 c2 88 01 00 00    	add    $0x188,%edx
80100d21:	83 c4 10             	add    $0x10,%esp
80100d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ramPages[ind].isused)
80100d28:	8b b8 04 01 00 00    	mov    0x104(%eax),%edi
80100d2e:	85 ff                	test   %edi,%edi
80100d30:	74 06                	je     80100d38 <exec+0x328>
      curproc->ramPages[ind].pgdir = pgdir;
80100d32:	89 88 00 01 00 00    	mov    %ecx,0x100(%eax)
    if(curproc->swappedPages[ind].isused)
80100d38:	8b 78 04             	mov    0x4(%eax),%edi
80100d3b:	85 ff                	test   %edi,%edi
80100d3d:	74 02                	je     80100d41 <exec+0x331>
      curproc->swappedPages[ind].pgdir = pgdir;
80100d3f:	89 08                	mov    %ecx,(%eax)
80100d41:	83 c0 10             	add    $0x10,%eax
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
80100d44:	39 c2                	cmp    %eax,%edx
80100d46:	75 e0                	jne    80100d28 <exec+0x318>
  oldpgdir = curproc->pgdir;
80100d48:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  curproc->pgdir = pgdir;
80100d4e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  switchuvm(curproc);
80100d54:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
80100d57:	8b 79 04             	mov    0x4(%ecx),%edi
  curproc->sz = sz;
80100d5a:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d5c:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d5f:	8b 41 18             	mov    0x18(%ecx),%eax
80100d62:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d68:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d6b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d6e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d71:	51                   	push   %ecx
80100d72:	e8 c9 62 00 00       	call   80107040 <switchuvm>
  freevm(oldpgdir);
80100d77:	89 3c 24             	mov    %edi,(%esp)
80100d7a:	e8 c1 69 00 00       	call   80107740 <freevm>
  return 0;
80100d7f:	83 c4 10             	add    $0x10,%esp
80100d82:	31 c0                	xor    %eax,%eax
80100d84:	e9 f3 fc ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d89:	be 00 20 00 00       	mov    $0x2000,%esi
80100d8e:	e9 fe fd ff ff       	jmp    80100b91 <exec+0x181>
80100d93:	66 90                	xchg   %ax,%ax
80100d95:	66 90                	xchg   %ax,%ax
80100d97:	66 90                	xchg   %ax,%ax
80100d99:	66 90                	xchg   %ax,%ax
80100d9b:	66 90                	xchg   %ax,%ax
80100d9d:	66 90                	xchg   %ax,%ax
80100d9f:	90                   	nop

80100da0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100da6:	68 ed 7f 10 80       	push   $0x80107fed
80100dab:	68 00 30 12 80       	push   $0x80123000
80100db0:	e8 cb 3c 00 00       	call   80104a80 <initlock>
}
80100db5:	83 c4 10             	add    $0x10,%esp
80100db8:	c9                   	leave  
80100db9:	c3                   	ret    
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100dc0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100dc0:	55                   	push   %ebp
80100dc1:	89 e5                	mov    %esp,%ebp
80100dc3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc4:	bb 34 30 12 80       	mov    $0x80123034,%ebx
{
80100dc9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100dcc:	68 00 30 12 80       	push   $0x80123000
80100dd1:	e8 ea 3d 00 00       	call   80104bc0 <acquire>
80100dd6:	83 c4 10             	add    $0x10,%esp
80100dd9:	eb 10                	jmp    80100deb <filealloc+0x2b>
80100ddb:	90                   	nop
80100ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100de0:	83 c3 18             	add    $0x18,%ebx
80100de3:	81 fb 94 39 12 80    	cmp    $0x80123994,%ebx
80100de9:	73 25                	jae    80100e10 <filealloc+0x50>
    if(f->ref == 0){
80100deb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dee:	85 c0                	test   %eax,%eax
80100df0:	75 ee                	jne    80100de0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100df2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100df5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dfc:	68 00 30 12 80       	push   $0x80123000
80100e01:	e8 7a 3e 00 00       	call   80104c80 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e06:	89 d8                	mov    %ebx,%eax
      return f;
80100e08:	83 c4 10             	add    $0x10,%esp
}
80100e0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e0e:	c9                   	leave  
80100e0f:	c3                   	ret    
  release(&ftable.lock);
80100e10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e15:	68 00 30 12 80       	push   $0x80123000
80100e1a:	e8 61 3e 00 00       	call   80104c80 <release>
}
80100e1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e21:	83 c4 10             	add    $0x10,%esp
}
80100e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e27:	c9                   	leave  
80100e28:	c3                   	ret    
80100e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
80100e34:	83 ec 10             	sub    $0x10,%esp
80100e37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e3a:	68 00 30 12 80       	push   $0x80123000
80100e3f:	e8 7c 3d 00 00       	call   80104bc0 <acquire>
  if(f->ref < 1)
80100e44:	8b 43 04             	mov    0x4(%ebx),%eax
80100e47:	83 c4 10             	add    $0x10,%esp
80100e4a:	85 c0                	test   %eax,%eax
80100e4c:	7e 1a                	jle    80100e68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e57:	68 00 30 12 80       	push   $0x80123000
80100e5c:	e8 1f 3e 00 00       	call   80104c80 <release>
  return f;
}
80100e61:	89 d8                	mov    %ebx,%eax
80100e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e66:	c9                   	leave  
80100e67:	c3                   	ret    
    panic("filedup");
80100e68:	83 ec 0c             	sub    $0xc,%esp
80100e6b:	68 f4 7f 10 80       	push   $0x80107ff4
80100e70:	e8 1b f5 ff ff       	call   80100390 <panic>
80100e75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e80:	55                   	push   %ebp
80100e81:	89 e5                	mov    %esp,%ebp
80100e83:	57                   	push   %edi
80100e84:	56                   	push   %esi
80100e85:	53                   	push   %ebx
80100e86:	83 ec 28             	sub    $0x28,%esp
80100e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e8c:	68 00 30 12 80       	push   $0x80123000
80100e91:	e8 2a 3d 00 00       	call   80104bc0 <acquire>
  if(f->ref < 1)
80100e96:	8b 43 04             	mov    0x4(%ebx),%eax
80100e99:	83 c4 10             	add    $0x10,%esp
80100e9c:	85 c0                	test   %eax,%eax
80100e9e:	0f 8e 9b 00 00 00    	jle    80100f3f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100ea4:	83 e8 01             	sub    $0x1,%eax
80100ea7:	85 c0                	test   %eax,%eax
80100ea9:	89 43 04             	mov    %eax,0x4(%ebx)
80100eac:	74 1a                	je     80100ec8 <fileclose+0x48>
    release(&ftable.lock);
80100eae:	c7 45 08 00 30 12 80 	movl   $0x80123000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb8:	5b                   	pop    %ebx
80100eb9:	5e                   	pop    %esi
80100eba:	5f                   	pop    %edi
80100ebb:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ebc:	e9 bf 3d 00 00       	jmp    80104c80 <release>
80100ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100ec8:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100ecc:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100ece:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ed1:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100ed4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eda:	88 45 e7             	mov    %al,-0x19(%ebp)
80100edd:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ee0:	68 00 30 12 80       	push   $0x80123000
  ff = *f;
80100ee5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ee8:	e8 93 3d 00 00       	call   80104c80 <release>
  if(ff.type == FD_PIPE)
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	83 ff 01             	cmp    $0x1,%edi
80100ef3:	74 13                	je     80100f08 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100ef5:	83 ff 02             	cmp    $0x2,%edi
80100ef8:	74 26                	je     80100f20 <fileclose+0xa0>
}
80100efa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100efd:	5b                   	pop    %ebx
80100efe:	5e                   	pop    %esi
80100eff:	5f                   	pop    %edi
80100f00:	5d                   	pop    %ebp
80100f01:	c3                   	ret    
80100f02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f08:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f0c:	83 ec 08             	sub    $0x8,%esp
80100f0f:	53                   	push   %ebx
80100f10:	56                   	push   %esi
80100f11:	e8 8a 2a 00 00       	call   801039a0 <pipeclose>
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	eb df                	jmp    80100efa <fileclose+0x7a>
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f20:	e8 cb 22 00 00       	call   801031f0 <begin_op>
    iput(ff.ip);
80100f25:	83 ec 0c             	sub    $0xc,%esp
80100f28:	ff 75 e0             	pushl  -0x20(%ebp)
80100f2b:	e8 c0 08 00 00       	call   801017f0 <iput>
    end_op();
80100f30:	83 c4 10             	add    $0x10,%esp
}
80100f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f36:	5b                   	pop    %ebx
80100f37:	5e                   	pop    %esi
80100f38:	5f                   	pop    %edi
80100f39:	5d                   	pop    %ebp
    end_op();
80100f3a:	e9 21 23 00 00       	jmp    80103260 <end_op>
    panic("fileclose");
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	68 fc 7f 10 80       	push   $0x80107ffc
80100f47:	e8 44 f4 ff ff       	call   80100390 <panic>
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
80100f54:	83 ec 04             	sub    $0x4,%esp
80100f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f5a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f5d:	75 31                	jne    80100f90 <filestat+0x40>
    ilock(f->ip);
80100f5f:	83 ec 0c             	sub    $0xc,%esp
80100f62:	ff 73 10             	pushl  0x10(%ebx)
80100f65:	e8 56 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f6a:	58                   	pop    %eax
80100f6b:	5a                   	pop    %edx
80100f6c:	ff 75 0c             	pushl  0xc(%ebp)
80100f6f:	ff 73 10             	pushl  0x10(%ebx)
80100f72:	e8 f9 09 00 00       	call   80101970 <stati>
    iunlock(f->ip);
80100f77:	59                   	pop    %ecx
80100f78:	ff 73 10             	pushl  0x10(%ebx)
80100f7b:	e8 20 08 00 00       	call   801017a0 <iunlock>
    return 0;
80100f80:	83 c4 10             	add    $0x10,%esp
80100f83:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f88:	c9                   	leave  
80100f89:	c3                   	ret    
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f95:	eb ee                	jmp    80100f85 <filestat+0x35>
80100f97:	89 f6                	mov    %esi,%esi
80100f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fa0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 0c             	sub    $0xc,%esp
80100fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100fac:	8b 75 0c             	mov    0xc(%ebp),%esi
80100faf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100fb2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100fb6:	74 60                	je     80101018 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100fb8:	8b 03                	mov    (%ebx),%eax
80100fba:	83 f8 01             	cmp    $0x1,%eax
80100fbd:	74 41                	je     80101000 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fbf:	83 f8 02             	cmp    $0x2,%eax
80100fc2:	75 5b                	jne    8010101f <fileread+0x7f>
    ilock(f->ip);
80100fc4:	83 ec 0c             	sub    $0xc,%esp
80100fc7:	ff 73 10             	pushl  0x10(%ebx)
80100fca:	e8 f1 06 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcf:	57                   	push   %edi
80100fd0:	ff 73 14             	pushl  0x14(%ebx)
80100fd3:	56                   	push   %esi
80100fd4:	ff 73 10             	pushl  0x10(%ebx)
80100fd7:	e8 c4 09 00 00       	call   801019a0 <readi>
80100fdc:	83 c4 20             	add    $0x20,%esp
80100fdf:	85 c0                	test   %eax,%eax
80100fe1:	89 c6                	mov    %eax,%esi
80100fe3:	7e 03                	jle    80100fe8 <fileread+0x48>
      f->off += r;
80100fe5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fe8:	83 ec 0c             	sub    $0xc,%esp
80100feb:	ff 73 10             	pushl  0x10(%ebx)
80100fee:	e8 ad 07 00 00       	call   801017a0 <iunlock>
    return r;
80100ff3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100ff6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff9:	89 f0                	mov    %esi,%eax
80100ffb:	5b                   	pop    %ebx
80100ffc:	5e                   	pop    %esi
80100ffd:	5f                   	pop    %edi
80100ffe:	5d                   	pop    %ebp
80100fff:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101000:	8b 43 0c             	mov    0xc(%ebx),%eax
80101003:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101006:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101009:	5b                   	pop    %ebx
8010100a:	5e                   	pop    %esi
8010100b:	5f                   	pop    %edi
8010100c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010100d:	e9 3e 2b 00 00       	jmp    80103b50 <piperead>
80101012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101018:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010101d:	eb d7                	jmp    80100ff6 <fileread+0x56>
  panic("fileread");
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	68 06 80 10 80       	push   $0x80108006
80101027:	e8 64 f3 ff ff       	call   80100390 <panic>
8010102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101030 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 1c             	sub    $0x1c,%esp
80101039:	8b 75 08             	mov    0x8(%ebp),%esi
8010103c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010103f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101043:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101046:	8b 45 10             	mov    0x10(%ebp),%eax
80101049:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010104c:	0f 84 aa 00 00 00    	je     801010fc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101052:	8b 06                	mov    (%esi),%eax
80101054:	83 f8 01             	cmp    $0x1,%eax
80101057:	0f 84 c3 00 00 00    	je     80101120 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010105d:	83 f8 02             	cmp    $0x2,%eax
80101060:	0f 85 d9 00 00 00    	jne    8010113f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101069:	31 ff                	xor    %edi,%edi
    while(i < n){
8010106b:	85 c0                	test   %eax,%eax
8010106d:	7f 34                	jg     801010a3 <filewrite+0x73>
8010106f:	e9 9c 00 00 00       	jmp    80101110 <filewrite+0xe0>
80101074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101078:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101081:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101084:	e8 17 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101089:	e8 d2 21 00 00       	call   80103260 <end_op>
8010108e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101091:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101094:	39 c3                	cmp    %eax,%ebx
80101096:	0f 85 96 00 00 00    	jne    80101132 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010109c:	01 df                	add    %ebx,%edi
    while(i < n){
8010109e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010a1:	7e 6d                	jle    80101110 <filewrite+0xe0>
      int n1 = n - i;
801010a3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801010a6:	b8 00 06 00 00       	mov    $0x600,%eax
801010ab:	29 fb                	sub    %edi,%ebx
801010ad:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
801010b3:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
801010b6:	e8 35 21 00 00       	call   801031f0 <begin_op>
      ilock(f->ip);
801010bb:	83 ec 0c             	sub    $0xc,%esp
801010be:	ff 76 10             	pushl  0x10(%esi)
801010c1:	e8 fa 05 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c9:	53                   	push   %ebx
801010ca:	ff 76 14             	pushl  0x14(%esi)
801010cd:	01 f8                	add    %edi,%eax
801010cf:	50                   	push   %eax
801010d0:	ff 76 10             	pushl  0x10(%esi)
801010d3:	e8 c8 09 00 00       	call   80101aa0 <writei>
801010d8:	83 c4 20             	add    $0x20,%esp
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 99                	jg     80101078 <filewrite+0x48>
      iunlock(f->ip);
801010df:	83 ec 0c             	sub    $0xc,%esp
801010e2:	ff 76 10             	pushl  0x10(%esi)
801010e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010e8:	e8 b3 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010ed:	e8 6e 21 00 00       	call   80103260 <end_op>
      if(r < 0)
801010f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f5:	83 c4 10             	add    $0x10,%esp
801010f8:	85 c0                	test   %eax,%eax
801010fa:	74 98                	je     80101094 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101104:	89 f8                	mov    %edi,%eax
80101106:	5b                   	pop    %ebx
80101107:	5e                   	pop    %esi
80101108:	5f                   	pop    %edi
80101109:	5d                   	pop    %ebp
8010110a:	c3                   	ret    
8010110b:	90                   	nop
8010110c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101110:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101113:	75 e7                	jne    801010fc <filewrite+0xcc>
}
80101115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101118:	89 f8                	mov    %edi,%eax
8010111a:	5b                   	pop    %ebx
8010111b:	5e                   	pop    %esi
8010111c:	5f                   	pop    %edi
8010111d:	5d                   	pop    %ebp
8010111e:	c3                   	ret    
8010111f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101120:	8b 46 0c             	mov    0xc(%esi),%eax
80101123:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101129:	5b                   	pop    %ebx
8010112a:	5e                   	pop    %esi
8010112b:	5f                   	pop    %edi
8010112c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010112d:	e9 0e 29 00 00       	jmp    80103a40 <pipewrite>
        panic("short filewrite");
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	68 0f 80 10 80       	push   $0x8010800f
8010113a:	e8 51 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 15 80 10 80       	push   $0x80108015
80101147:	e8 44 f2 ff ff       	call   80100390 <panic>
8010114c:	66 90                	xchg   %ax,%ax
8010114e:	66 90                	xchg   %ax,%ax

80101150 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	56                   	push   %esi
80101154:	53                   	push   %ebx
80101155:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101157:	c1 ea 0c             	shr    $0xc,%edx
8010115a:	03 15 18 3a 12 80    	add    0x80123a18,%edx
80101160:	83 ec 08             	sub    $0x8,%esp
80101163:	52                   	push   %edx
80101164:	50                   	push   %eax
80101165:	e8 66 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010116a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010116c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010116f:	ba 01 00 00 00       	mov    $0x1,%edx
80101174:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101177:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010117d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101180:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101182:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101187:	85 d1                	test   %edx,%ecx
80101189:	74 25                	je     801011b0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010118b:	f7 d2                	not    %edx
8010118d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010118f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101192:	21 ca                	and    %ecx,%edx
80101194:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101198:	56                   	push   %esi
80101199:	e8 22 22 00 00       	call   801033c0 <log_write>
  brelse(bp);
8010119e:	89 34 24             	mov    %esi,(%esp)
801011a1:	e8 3a f0 ff ff       	call   801001e0 <brelse>
}
801011a6:	83 c4 10             	add    $0x10,%esp
801011a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011ac:	5b                   	pop    %ebx
801011ad:	5e                   	pop    %esi
801011ae:	5d                   	pop    %ebp
801011af:	c3                   	ret    
    panic("freeing free block");
801011b0:	83 ec 0c             	sub    $0xc,%esp
801011b3:	68 1f 80 10 80       	push   $0x8010801f
801011b8:	e8 d3 f1 ff ff       	call   80100390 <panic>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi

801011c0 <balloc>:
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801011c9:	8b 0d 00 3a 12 80    	mov    0x80123a00,%ecx
{
801011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011d2:	85 c9                	test   %ecx,%ecx
801011d4:	0f 84 87 00 00 00    	je     80101261 <balloc+0xa1>
801011da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	89 f0                	mov    %esi,%eax
801011e9:	c1 f8 0c             	sar    $0xc,%eax
801011ec:	03 05 18 3a 12 80    	add    0x80123a18,%eax
801011f2:	50                   	push   %eax
801011f3:	ff 75 d8             	pushl  -0x28(%ebp)
801011f6:	e8 d5 ee ff ff       	call   801000d0 <bread>
801011fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011fe:	a1 00 3a 12 80       	mov    0x80123a00,%eax
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101209:	31 c0                	xor    %eax,%eax
8010120b:	eb 2f                	jmp    8010123c <balloc+0x7c>
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101210:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101215:	bb 01 00 00 00       	mov    $0x1,%ebx
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121f:	89 c1                	mov    %eax,%ecx
80101221:	c1 f9 03             	sar    $0x3,%ecx
80101224:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101229:	85 df                	test   %ebx,%edi
8010122b:	89 fa                	mov    %edi,%edx
8010122d:	74 41                	je     80101270 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122f:	83 c0 01             	add    $0x1,%eax
80101232:	83 c6 01             	add    $0x1,%esi
80101235:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123a:	74 05                	je     80101241 <balloc+0x81>
8010123c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010123f:	77 cf                	ja     80101210 <balloc+0x50>
    brelse(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	ff 75 e4             	pushl  -0x1c(%ebp)
80101247:	e8 94 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010124c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	39 05 00 3a 12 80    	cmp    %eax,0x80123a00
8010125f:	77 80                	ja     801011e1 <balloc+0x21>
  panic("balloc: out of blocks");
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	68 32 80 10 80       	push   $0x80108032
80101269:	e8 22 f1 ff ff       	call   80100390 <panic>
8010126e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101276:	09 da                	or     %ebx,%edx
80101278:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010127c:	57                   	push   %edi
8010127d:	e8 3e 21 00 00       	call   801033c0 <log_write>
        brelse(bp);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	56                   	push   %esi
8010128d:	ff 75 d8             	pushl  -0x28(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
80101295:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101297:	8d 40 5c             	lea    0x5c(%eax),%eax
8010129a:	83 c4 0c             	add    $0xc,%esp
8010129d:	68 00 02 00 00       	push   $0x200
801012a2:	6a 00                	push   $0x0
801012a4:	50                   	push   %eax
801012a5:	e8 26 3a 00 00       	call   80104cd0 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 0e 21 00 00       	call   801033c0 <log_write>
  brelse(bp);
801012b2:	89 1c 24             	mov    %ebx,(%esp)
801012b5:	e8 26 ef ff ff       	call   801001e0 <brelse>
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 54 3a 12 80       	mov    $0x80123a54,%ebx
{
801012df:	83 ec 28             	sub    $0x28,%esp
801012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012e5:	68 20 3a 12 80       	push   $0x80123a20
801012ea:	e8 d1 38 00 00       	call   80104bc0 <acquire>
801012ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f5:	eb 17                	jmp    8010130e <iget+0x3e>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101300:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101306:	81 fb 74 56 12 80    	cmp    $0x80125674,%ebx
8010130c:	73 22                	jae    80101330 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101311:	85 c9                	test   %ecx,%ecx
80101313:	7e 04                	jle    80101319 <iget+0x49>
80101315:	39 3b                	cmp    %edi,(%ebx)
80101317:	74 4f                	je     80101368 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101319:	85 f6                	test   %esi,%esi
8010131b:	75 e3                	jne    80101300 <iget+0x30>
8010131d:	85 c9                	test   %ecx,%ecx
8010131f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101322:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101328:	81 fb 74 56 12 80    	cmp    $0x80125674,%ebx
8010132e:	72 de                	jb     8010130e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 5b                	je     8010138f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101334:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101337:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101339:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010133c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101343:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010134a:	68 20 3a 12 80       	push   $0x80123a20
8010134f:	e8 2c 39 00 00       	call   80104c80 <release>

  return ip;
80101354:	83 c4 10             	add    $0x10,%esp
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
80101361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101368:	39 53 04             	cmp    %edx,0x4(%ebx)
8010136b:	75 ac                	jne    80101319 <iget+0x49>
      release(&icache.lock);
8010136d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101370:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101373:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101375:	68 20 3a 12 80       	push   $0x80123a20
      ip->ref++;
8010137a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010137d:	e8 fe 38 00 00       	call   80104c80 <release>
      return ip;
80101382:	83 c4 10             	add    $0x10,%esp
}
80101385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
    panic("iget: no inodes");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 48 80 10 80       	push   $0x80108048
80101397:	e8 f4 ef ff ff       	call   80100390 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	89 c6                	mov    %eax,%esi
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	77 18                	ja     801013c8 <bmap+0x28>
801013b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013b6:	85 db                	test   %ebx,%ebx
801013b8:	74 76                	je     80101430 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 d8                	mov    %ebx,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013cb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ce:	0f 87 90 00 00 00    	ja     80101464 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013da:	8b 00                	mov    (%eax),%eax
801013dc:	85 d2                	test   %edx,%edx
801013de:	74 70                	je     80101450 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	52                   	push   %edx
801013e4:	50                   	push   %eax
801013e5:	e8 e6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013f3:	8b 1a                	mov    (%edx),%ebx
801013f5:	85 db                	test   %ebx,%ebx
801013f7:	75 1d                	jne    80101416 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013f9:	8b 06                	mov    (%esi),%eax
801013fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013fe:	e8 bd fd ff ff       	call   801011c0 <balloc>
80101403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101409:	89 c3                	mov    %eax,%ebx
8010140b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010140d:	57                   	push   %edi
8010140e:	e8 ad 1f 00 00       	call   801033c0 <log_write>
80101413:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101416:	83 ec 0c             	sub    $0xc,%esp
80101419:	57                   	push   %edi
8010141a:	e8 c1 ed ff ff       	call   801001e0 <brelse>
8010141f:	83 c4 10             	add    $0x10,%esp
}
80101422:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101425:	89 d8                	mov    %ebx,%eax
80101427:	5b                   	pop    %ebx
80101428:	5e                   	pop    %esi
80101429:	5f                   	pop    %edi
8010142a:	5d                   	pop    %ebp
8010142b:	c3                   	ret    
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101430:	8b 00                	mov    (%eax),%eax
80101432:	e8 89 fd ff ff       	call   801011c0 <balloc>
80101437:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010143d:	89 c3                	mov    %eax,%ebx
}
8010143f:	89 d8                	mov    %ebx,%eax
80101441:	5b                   	pop    %ebx
80101442:	5e                   	pop    %esi
80101443:	5f                   	pop    %edi
80101444:	5d                   	pop    %ebp
80101445:	c3                   	ret    
80101446:	8d 76 00             	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101450:	e8 6b fd ff ff       	call   801011c0 <balloc>
80101455:	89 c2                	mov    %eax,%edx
80101457:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010145d:	8b 06                	mov    (%esi),%eax
8010145f:	e9 7c ff ff ff       	jmp    801013e0 <bmap+0x40>
  panic("bmap: out of range");
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	68 58 80 10 80       	push   $0x80108058
8010146c:	e8 1f ef ff ff       	call   80100390 <panic>
80101471:	eb 0d                	jmp    80101480 <readsb>
80101473:	90                   	nop
80101474:	90                   	nop
80101475:	90                   	nop
80101476:	90                   	nop
80101477:	90                   	nop
80101478:	90                   	nop
80101479:	90                   	nop
8010147a:	90                   	nop
8010147b:	90                   	nop
8010147c:	90                   	nop
8010147d:	90                   	nop
8010147e:	90                   	nop
8010147f:	90                   	nop

80101480 <readsb>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 da 38 00 00       	call   80104d80 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
  brelse(bp);
801014b2:	e9 29 ed ff ff       	jmp    801001e0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <iinit>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	53                   	push   %ebx
801014c4:	bb 60 3a 12 80       	mov    $0x80123a60,%ebx
801014c9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801014cc:	68 6b 80 10 80       	push   $0x8010806b
801014d1:	68 20 3a 12 80       	push   $0x80123a20
801014d6:	e8 a5 35 00 00       	call   80104a80 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 72 80 10 80       	push   $0x80108072
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 5c 34 00 00       	call   80104950 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014f4:	83 c4 10             	add    $0x10,%esp
801014f7:	81 fb 80 56 12 80    	cmp    $0x80125680,%ebx
801014fd:	75 e1                	jne    801014e0 <iinit+0x20>
  readsb(dev, &sb);
801014ff:	83 ec 08             	sub    $0x8,%esp
80101502:	68 00 3a 12 80       	push   $0x80123a00
80101507:	ff 75 08             	pushl  0x8(%ebp)
8010150a:	e8 71 ff ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010150f:	ff 35 18 3a 12 80    	pushl  0x80123a18
80101515:	ff 35 14 3a 12 80    	pushl  0x80123a14
8010151b:	ff 35 10 3a 12 80    	pushl  0x80123a10
80101521:	ff 35 0c 3a 12 80    	pushl  0x80123a0c
80101527:	ff 35 08 3a 12 80    	pushl  0x80123a08
8010152d:	ff 35 04 3a 12 80    	pushl  0x80123a04
80101533:	ff 35 00 3a 12 80    	pushl  0x80123a00
80101539:	68 1c 81 10 80       	push   $0x8010811c
8010153e:	e8 1d f1 ff ff       	call   80100660 <cprintf>
}
80101543:	83 c4 30             	add    $0x30,%esp
80101546:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101549:	c9                   	leave  
8010154a:	c3                   	ret    
8010154b:	90                   	nop
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101559:	83 3d 08 3a 12 80 01 	cmpl   $0x1,0x80123a08
{
80101560:	8b 45 0c             	mov    0xc(%ebp),%eax
80101563:	8b 75 08             	mov    0x8(%ebp),%esi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 91 00 00 00    	jbe    80101600 <ialloc+0xb0>
8010156f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101574:	eb 21                	jmp    80101597 <ialloc+0x47>
80101576:	8d 76 00             	lea    0x0(%esi),%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	57                   	push   %edi
80101587:	e8 54 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	39 1d 08 3a 12 80    	cmp    %ebx,0x80123a08
80101595:	76 69                	jbe    80101600 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101597:	89 d8                	mov    %ebx,%eax
80101599:	83 ec 08             	sub    $0x8,%esp
8010159c:	c1 e8 03             	shr    $0x3,%eax
8010159f:	03 05 14 3a 12 80    	add    0x80123a14,%eax
801015a5:	50                   	push   %eax
801015a6:	56                   	push   %esi
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801015b0:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
801015b3:	83 e0 07             	and    $0x7,%eax
801015b6:	c1 e0 06             	shl    $0x6,%eax
801015b9:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015bd:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015c1:	75 bd                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c3:	83 ec 04             	sub    $0x4,%esp
801015c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015c9:	6a 40                	push   $0x40
801015cb:	6a 00                	push   $0x0
801015cd:	51                   	push   %ecx
801015ce:	e8 fd 36 00 00       	call   80104cd0 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 db 1d 00 00       	call   801033c0 <log_write>
      brelse(bp);
801015e5:	89 3c 24             	mov    %edi,(%esp)
801015e8:	e8 f3 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015ed:	83 c4 10             	add    $0x10,%esp
}
801015f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015f3:	89 da                	mov    %ebx,%edx
801015f5:	89 f0                	mov    %esi,%eax
}
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5f                   	pop    %edi
801015fa:	5d                   	pop    %ebp
      return iget(dev, inum);
801015fb:	e9 d0 fc ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
80101600:	83 ec 0c             	sub    $0xc,%esp
80101603:	68 78 80 10 80       	push   $0x80108078
80101608:	e8 83 ed ff ff       	call   80100390 <panic>
8010160d:	8d 76 00             	lea    0x0(%esi),%esi

80101610 <iupdate>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	56                   	push   %esi
80101614:	53                   	push   %ebx
80101615:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101621:	c1 e8 03             	shr    $0x3,%eax
80101624:	03 05 14 3a 12 80    	add    0x80123a14,%eax
8010162a:	50                   	push   %eax
8010162b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010162e:	e8 9d ea ff ff       	call   801000d0 <bread>
80101633:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101635:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101638:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010163f:	83 e0 07             	and    $0x7,%eax
80101642:	c1 e0 06             	shl    $0x6,%eax
80101645:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101649:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010164c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101650:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101653:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101657:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010165b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010165f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101663:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101667:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010166a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166d:	6a 34                	push   $0x34
8010166f:	53                   	push   %ebx
80101670:	50                   	push   %eax
80101671:	e8 0a 37 00 00       	call   80104d80 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 42 1d 00 00       	call   801033c0 <log_write>
  brelse(bp);
8010167e:	89 75 08             	mov    %esi,0x8(%ebp)
80101681:	83 c4 10             	add    $0x10,%esp
}
80101684:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5d                   	pop    %ebp
  brelse(bp);
8010168a:	e9 51 eb ff ff       	jmp    801001e0 <brelse>
8010168f:	90                   	nop

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 10             	sub    $0x10,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	68 20 3a 12 80       	push   $0x80123a20
8010169f:	e8 1c 35 00 00       	call   80104bc0 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
801016af:	e8 cc 35 00 00       	call   80104c80 <release>
}
801016b4:	89 d8                	mov    %ebx,%eax
801016b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016b9:	c9                   	leave  
801016ba:	c3                   	ret    
801016bb:	90                   	nop
801016bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016c8:	85 db                	test   %ebx,%ebx
801016ca:	0f 84 b7 00 00 00    	je     80101787 <ilock+0xc7>
801016d0:	8b 53 08             	mov    0x8(%ebx),%edx
801016d3:	85 d2                	test   %edx,%edx
801016d5:	0f 8e ac 00 00 00    	jle    80101787 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016db:	8d 43 0c             	lea    0xc(%ebx),%eax
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	50                   	push   %eax
801016e2:	e8 a9 32 00 00       	call   80104990 <acquiresleep>
  if(ip->valid == 0){
801016e7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ea:	83 c4 10             	add    $0x10,%esp
801016ed:	85 c0                	test   %eax,%eax
801016ef:	74 0f                	je     80101700 <ilock+0x40>
}
801016f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016f4:	5b                   	pop    %ebx
801016f5:	5e                   	pop    %esi
801016f6:	5d                   	pop    %ebp
801016f7:	c3                   	ret    
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101700:	8b 43 04             	mov    0x4(%ebx),%eax
80101703:	83 ec 08             	sub    $0x8,%esp
80101706:	c1 e8 03             	shr    $0x3,%eax
80101709:	03 05 14 3a 12 80    	add    0x80123a14,%eax
8010170f:	50                   	push   %eax
80101710:	ff 33                	pushl  (%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
80101717:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101719:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010171c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010171f:	83 e0 07             	and    $0x7,%eax
80101722:	c1 e0 06             	shl    $0x6,%eax
80101725:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101729:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010172c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010172f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101733:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101737:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010173b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010173f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101743:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101747:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010174b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010174e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	50                   	push   %eax
80101754:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101757:	50                   	push   %eax
80101758:	e8 23 36 00 00       	call   80104d80 <memmove>
    brelse(bp);
8010175d:	89 34 24             	mov    %esi,(%esp)
80101760:	e8 7b ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101765:	83 c4 10             	add    $0x10,%esp
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 77 ff ff ff    	jne    801016f1 <ilock+0x31>
      panic("ilock: no type");
8010177a:	83 ec 0c             	sub    $0xc,%esp
8010177d:	68 90 80 10 80       	push   $0x80108090
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 8a 80 10 80       	push   $0x8010808a
8010178f:	e8 fc eb ff ff       	call   80100390 <panic>
80101794:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010179a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017a8:	85 db                	test   %ebx,%ebx
801017aa:	74 28                	je     801017d4 <iunlock+0x34>
801017ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801017af:	83 ec 0c             	sub    $0xc,%esp
801017b2:	56                   	push   %esi
801017b3:	e8 78 32 00 00       	call   80104a30 <holdingsleep>
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 c0                	test   %eax,%eax
801017bd:	74 15                	je     801017d4 <iunlock+0x34>
801017bf:	8b 43 08             	mov    0x8(%ebx),%eax
801017c2:	85 c0                	test   %eax,%eax
801017c4:	7e 0e                	jle    801017d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801017c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017cc:	5b                   	pop    %ebx
801017cd:	5e                   	pop    %esi
801017ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017cf:	e9 1c 32 00 00       	jmp    801049f0 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 9f 80 10 80       	push   $0x8010809f
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <iput>
801017e3:	90                   	nop
801017e4:	90                   	nop
801017e5:	90                   	nop
801017e6:	90                   	nop
801017e7:	90                   	nop
801017e8:	90                   	nop
801017e9:	90                   	nop
801017ea:	90                   	nop
801017eb:	90                   	nop
801017ec:	90                   	nop
801017ed:	90                   	nop
801017ee:	90                   	nop
801017ef:	90                   	nop

801017f0 <iput>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	57                   	push   %edi
801017f4:	56                   	push   %esi
801017f5:	53                   	push   %ebx
801017f6:	83 ec 28             	sub    $0x28,%esp
801017f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017fc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017ff:	57                   	push   %edi
80101800:	e8 8b 31 00 00       	call   80104990 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101805:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 d2                	test   %edx,%edx
8010180d:	74 07                	je     80101816 <iput+0x26>
8010180f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101814:	74 32                	je     80101848 <iput+0x58>
  releasesleep(&ip->lock);
80101816:	83 ec 0c             	sub    $0xc,%esp
80101819:	57                   	push   %edi
8010181a:	e8 d1 31 00 00       	call   801049f0 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
80101826:	e8 95 33 00 00       	call   80104bc0 <acquire>
  ip->ref--;
8010182b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010182f:	83 c4 10             	add    $0x10,%esp
80101832:	c7 45 08 20 3a 12 80 	movl   $0x80123a20,0x8(%ebp)
}
80101839:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010183c:	5b                   	pop    %ebx
8010183d:	5e                   	pop    %esi
8010183e:	5f                   	pop    %edi
8010183f:	5d                   	pop    %ebp
  release(&icache.lock);
80101840:	e9 3b 34 00 00       	jmp    80104c80 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 20 3a 12 80       	push   $0x80123a20
80101850:	e8 6b 33 00 00       	call   80104bc0 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
8010185f:	e8 1c 34 00 00       	call   80104c80 <release>
    if(r == 1){
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	83 fe 01             	cmp    $0x1,%esi
8010186a:	75 aa                	jne    80101816 <iput+0x26>
8010186c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101872:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101875:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x97>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fe                	cmp    %edi,%esi
80101885:	74 19                	je     801018a0 <iput+0xb0>
    if(ip->addrs[i]){
80101887:	8b 16                	mov    (%esi),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010188d:	8b 03                	mov    (%ebx),%eax
8010188f:	e8 bc f8 ff ff       	call   80101150 <bfree>
      ip->addrs[i] = 0;
80101894:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010189a:	eb e4                	jmp    80101880 <iput+0x90>
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 33                	jne    801018e0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018ad:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801018b0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801018b7:	53                   	push   %ebx
801018b8:	e8 53 fd ff ff       	call   80101610 <iupdate>
      ip->type = 0;
801018bd:	31 c0                	xor    %eax,%eax
801018bf:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801018c3:	89 1c 24             	mov    %ebx,(%esp)
801018c6:	e8 45 fd ff ff       	call   80101610 <iupdate>
      ip->valid = 0;
801018cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018d2:	83 c4 10             	add    $0x10,%esp
801018d5:	e9 3c ff ff ff       	jmp    80101816 <iput+0x26>
801018da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	83 ec 08             	sub    $0x8,%esp
801018e3:	50                   	push   %eax
801018e4:	ff 33                	pushl  (%ebx)
801018e6:	e8 e5 e7 ff ff       	call   801000d0 <bread>
801018eb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018f1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018f7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018fa:	83 c4 10             	add    $0x10,%esp
801018fd:	89 cf                	mov    %ecx,%edi
801018ff:	eb 0e                	jmp    8010190f <iput+0x11f>
80101901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101908:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010190b:	39 fe                	cmp    %edi,%esi
8010190d:	74 0f                	je     8010191e <iput+0x12e>
      if(a[j])
8010190f:	8b 16                	mov    (%esi),%edx
80101911:	85 d2                	test   %edx,%edx
80101913:	74 f3                	je     80101908 <iput+0x118>
        bfree(ip->dev, a[j]);
80101915:	8b 03                	mov    (%ebx),%eax
80101917:	e8 34 f8 ff ff       	call   80101150 <bfree>
8010191c:	eb ea                	jmp    80101908 <iput+0x118>
    brelse(bp);
8010191e:	83 ec 0c             	sub    $0xc,%esp
80101921:	ff 75 e4             	pushl  -0x1c(%ebp)
80101924:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101927:	e8 b4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010192c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101932:	8b 03                	mov    (%ebx),%eax
80101934:	e8 17 f8 ff ff       	call   80101150 <bfree>
    ip->addrs[NDIRECT] = 0;
80101939:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101940:	00 00 00 
80101943:	83 c4 10             	add    $0x10,%esp
80101946:	e9 62 ff ff ff       	jmp    801018ad <iput+0xbd>
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <iunlockput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	53                   	push   %ebx
80101954:	83 ec 10             	sub    $0x10,%esp
80101957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010195a:	53                   	push   %ebx
8010195b:	e8 40 fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101960:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101963:	83 c4 10             	add    $0x10,%esp
}
80101966:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101969:	c9                   	leave  
  iput(ip);
8010196a:	e9 81 fe ff ff       	jmp    801017f0 <iput>
8010196f:	90                   	nop

80101970 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	8b 55 08             	mov    0x8(%ebp),%edx
80101976:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101979:	8b 0a                	mov    (%edx),%ecx
8010197b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010197e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101981:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101984:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101988:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010198b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010198f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101993:	8b 52 58             	mov    0x58(%edx),%edx
80101996:	89 50 10             	mov    %edx,0x10(%eax)
}
80101999:	5d                   	pop    %ebp
8010199a:	c3                   	ret    
8010199b:	90                   	nop
8010199c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019a0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	57                   	push   %edi
801019a4:	56                   	push   %esi
801019a5:	53                   	push   %ebx
801019a6:	83 ec 1c             	sub    $0x1c,%esp
801019a9:	8b 45 08             	mov    0x8(%ebp),%eax
801019ac:	8b 75 0c             	mov    0xc(%ebp),%esi
801019af:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019b2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
801019b7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801019ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
801019bd:	8b 75 10             	mov    0x10(%ebp),%esi
801019c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019c3:	0f 84 a7 00 00 00    	je     80101a70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801019cc:	8b 40 58             	mov    0x58(%eax),%eax
801019cf:	39 c6                	cmp    %eax,%esi
801019d1:	0f 87 ba 00 00 00    	ja     80101a91 <readi+0xf1>
801019d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019da:	89 f9                	mov    %edi,%ecx
801019dc:	01 f1                	add    %esi,%ecx
801019de:	0f 82 ad 00 00 00    	jb     80101a91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019e4:	89 c2                	mov    %eax,%edx
801019e6:	29 f2                	sub    %esi,%edx
801019e8:	39 c8                	cmp    %ecx,%eax
801019ea:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019ed:	31 ff                	xor    %edi,%edi
801019ef:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019f1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f4:	74 6c                	je     80101a62 <readi+0xc2>
801019f6:	8d 76 00             	lea    0x0(%esi),%esi
801019f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a03:	89 f2                	mov    %esi,%edx
80101a05:	c1 ea 09             	shr    $0x9,%edx
80101a08:	89 d8                	mov    %ebx,%eax
80101a0a:	e8 91 f9 ff ff       	call   801013a0 <bmap>
80101a0f:	83 ec 08             	sub    $0x8,%esp
80101a12:	50                   	push   %eax
80101a13:	ff 33                	pushl  (%ebx)
80101a15:	e8 b6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a1d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1f:	89 f0                	mov    %esi,%eax
80101a21:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a26:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a2b:	83 c4 0c             	add    $0xc,%esp
80101a2e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a30:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a34:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a37:	29 fb                	sub    %edi,%ebx
80101a39:	39 d9                	cmp    %ebx,%ecx
80101a3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a3e:	53                   	push   %ebx
80101a3f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a40:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a42:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a45:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a47:	e8 34 33 00 00       	call   80104d80 <memmove>
    brelse(bp);
80101a4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a4f:	89 14 24             	mov    %edx,(%esp)
80101a52:	e8 89 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a60:	77 9e                	ja     80101a00 <readi+0x60>
  }
  return n;
80101a62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a68:	5b                   	pop    %ebx
80101a69:	5e                   	pop    %esi
80101a6a:	5f                   	pop    %edi
80101a6b:	5d                   	pop    %ebp
80101a6c:	c3                   	ret    
80101a6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a74:	66 83 f8 09          	cmp    $0x9,%ax
80101a78:	77 17                	ja     80101a91 <readi+0xf1>
80101a7a:	8b 04 c5 a0 39 12 80 	mov    -0x7fedc660(,%eax,8),%eax
80101a81:	85 c0                	test   %eax,%eax
80101a83:	74 0c                	je     80101a91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a8b:	5b                   	pop    %ebx
80101a8c:	5e                   	pop    %esi
80101a8d:	5f                   	pop    %edi
80101a8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a8f:	ff e0                	jmp    *%eax
      return -1;
80101a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a96:	eb cd                	jmp    80101a65 <readi+0xc5>
80101a98:	90                   	nop
80101a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aaf:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ab7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101abd:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac0:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ac3:	0f 84 b7 00 00 00    	je     80101b80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ac9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101acc:	39 70 58             	cmp    %esi,0x58(%eax)
80101acf:	0f 82 eb 00 00 00    	jb     80101bc0 <writei+0x120>
80101ad5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ad8:	31 d2                	xor    %edx,%edx
80101ada:	89 f8                	mov    %edi,%eax
80101adc:	01 f0                	add    %esi,%eax
80101ade:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ae1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ae6:	0f 87 d4 00 00 00    	ja     80101bc0 <writei+0x120>
80101aec:	85 d2                	test   %edx,%edx
80101aee:	0f 85 cc 00 00 00    	jne    80101bc0 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af4:	85 ff                	test   %edi,%edi
80101af6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101afd:	74 72                	je     80101b71 <writei+0xd1>
80101aff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b03:	89 f2                	mov    %esi,%edx
80101b05:	c1 ea 09             	shr    $0x9,%edx
80101b08:	89 f8                	mov    %edi,%eax
80101b0a:	e8 91 f8 ff ff       	call   801013a0 <bmap>
80101b0f:	83 ec 08             	sub    $0x8,%esp
80101b12:	50                   	push   %eax
80101b13:	ff 37                	pushl  (%edi)
80101b15:	e8 b6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b1a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b1d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b22:	89 f0                	mov    %esi,%eax
80101b24:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b29:	83 c4 0c             	add    $0xc,%esp
80101b2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	39 d9                	cmp    %ebx,%ecx
80101b39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b3c:	53                   	push   %ebx
80101b3d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b40:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b42:	50                   	push   %eax
80101b43:	e8 38 32 00 00       	call   80104d80 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 70 18 00 00       	call   801033c0 <log_write>
    brelse(bp);
80101b50:	89 3c 24             	mov    %edi,(%esp)
80101b53:	e8 88 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b5b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b5e:	83 c4 10             	add    $0x10,%esp
80101b61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b67:	77 97                	ja     80101b00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b6f:	77 37                	ja     80101ba8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b77:	5b                   	pop    %ebx
80101b78:	5e                   	pop    %esi
80101b79:	5f                   	pop    %edi
80101b7a:	5d                   	pop    %ebp
80101b7b:	c3                   	ret    
80101b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 36                	ja     80101bc0 <writei+0x120>
80101b8a:	8b 04 c5 a4 39 12 80 	mov    -0x7fedc65c(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 2b                	je     80101bc0 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b9f:	ff e0                	jmp    *%eax
80101ba1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101ba8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101bb1:	50                   	push   %eax
80101bb2:	e8 59 fa ff ff       	call   80101610 <iupdate>
80101bb7:	83 c4 10             	add    $0x10,%esp
80101bba:	eb b5                	jmp    80101b71 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bc5:	eb ad                	jmp    80101b74 <writei+0xd4>
80101bc7:	89 f6                	mov    %esi,%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101bd6:	6a 0e                	push   $0xe
80101bd8:	ff 75 0c             	pushl  0xc(%ebp)
80101bdb:	ff 75 08             	pushl  0x8(%ebp)
80101bde:	e8 0d 32 00 00       	call   80104df0 <strncmp>
}
80101be3:	c9                   	leave  
80101be4:	c3                   	ret    
80101be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 1c             	sub    $0x1c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 85 00 00 00    	jne    80101c8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	74 3e                	je     80101c51 <dirlookup+0x61>
80101c13:	90                   	nop
80101c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c18:	6a 10                	push   $0x10
80101c1a:	57                   	push   %edi
80101c1b:	56                   	push   %esi
80101c1c:	53                   	push   %ebx
80101c1d:	e8 7e fd ff ff       	call   801019a0 <readi>
80101c22:	83 c4 10             	add    $0x10,%esp
80101c25:	83 f8 10             	cmp    $0x10,%eax
80101c28:	75 55                	jne    80101c7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c2f:	74 18                	je     80101c49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c34:	83 ec 04             	sub    $0x4,%esp
80101c37:	6a 0e                	push   $0xe
80101c39:	50                   	push   %eax
80101c3a:	ff 75 0c             	pushl  0xc(%ebp)
80101c3d:	e8 ae 31 00 00       	call   80104df0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 17                	je     80101c60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c49:	83 c7 10             	add    $0x10,%edi
80101c4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c4f:	72 c7                	jb     80101c18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c54:	31 c0                	xor    %eax,%eax
}
80101c56:	5b                   	pop    %ebx
80101c57:	5e                   	pop    %esi
80101c58:	5f                   	pop    %edi
80101c59:	5d                   	pop    %ebp
80101c5a:	c3                   	ret    
80101c5b:	90                   	nop
80101c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c60:	8b 45 10             	mov    0x10(%ebp),%eax
80101c63:	85 c0                	test   %eax,%eax
80101c65:	74 05                	je     80101c6c <dirlookup+0x7c>
        *poff = off;
80101c67:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c70:	8b 03                	mov    (%ebx),%eax
80101c72:	e8 59 f6 ff ff       	call   801012d0 <iget>
}
80101c77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c7a:	5b                   	pop    %ebx
80101c7b:	5e                   	pop    %esi
80101c7c:	5f                   	pop    %edi
80101c7d:	5d                   	pop    %ebp
80101c7e:	c3                   	ret    
      panic("dirlookup read");
80101c7f:	83 ec 0c             	sub    $0xc,%esp
80101c82:	68 b9 80 10 80       	push   $0x801080b9
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 a7 80 10 80       	push   $0x801080a7
80101c94:	e8 f7 e6 ff ff       	call   80100390 <panic>
80101c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ca0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	89 cf                	mov    %ecx,%edi
80101ca8:	89 c3                	mov    %eax,%ebx
80101caa:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cad:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cb0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cb3:	0f 84 67 01 00 00    	je     80101e20 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cb9:	e8 12 22 00 00       	call   80103ed0 <myproc>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 20 3a 12 80       	push   $0x80123a20
80101cc9:	e8 f2 2e 00 00       	call   80104bc0 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
80101cd9:	e8 a2 2f 00 00       	call   80104c80 <release>
80101cde:	83 c4 10             	add    $0x10,%esp
80101ce1:	eb 08                	jmp    80101ceb <namex+0x4b>
80101ce3:	90                   	nop
80101ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ce8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ceb:	0f b6 03             	movzbl (%ebx),%eax
80101cee:	3c 2f                	cmp    $0x2f,%al
80101cf0:	74 f6                	je     80101ce8 <namex+0x48>
  if(*path == 0)
80101cf2:	84 c0                	test   %al,%al
80101cf4:	0f 84 ee 00 00 00    	je     80101de8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cfa:	0f b6 03             	movzbl (%ebx),%eax
80101cfd:	3c 2f                	cmp    $0x2f,%al
80101cff:	0f 84 b3 00 00 00    	je     80101db8 <namex+0x118>
80101d05:	84 c0                	test   %al,%al
80101d07:	89 da                	mov    %ebx,%edx
80101d09:	75 09                	jne    80101d14 <namex+0x74>
80101d0b:	e9 a8 00 00 00       	jmp    80101db8 <namex+0x118>
80101d10:	84 c0                	test   %al,%al
80101d12:	74 0a                	je     80101d1e <namex+0x7e>
    path++;
80101d14:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d17:	0f b6 02             	movzbl (%edx),%eax
80101d1a:	3c 2f                	cmp    $0x2f,%al
80101d1c:	75 f2                	jne    80101d10 <namex+0x70>
80101d1e:	89 d1                	mov    %edx,%ecx
80101d20:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d22:	83 f9 0d             	cmp    $0xd,%ecx
80101d25:	0f 8e 91 00 00 00    	jle    80101dbc <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d2b:	83 ec 04             	sub    $0x4,%esp
80101d2e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d31:	6a 0e                	push   $0xe
80101d33:	53                   	push   %ebx
80101d34:	57                   	push   %edi
80101d35:	e8 46 30 00 00       	call   80104d80 <memmove>
    path++;
80101d3a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d3d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d40:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d42:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d45:	75 11                	jne    80101d58 <namex+0xb8>
80101d47:	89 f6                	mov    %esi,%esi
80101d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d50:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d53:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d56:	74 f8                	je     80101d50 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d58:	83 ec 0c             	sub    $0xc,%esp
80101d5b:	56                   	push   %esi
80101d5c:	e8 5f f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d61:	83 c4 10             	add    $0x10,%esp
80101d64:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d69:	0f 85 91 00 00 00    	jne    80101e00 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d72:	85 d2                	test   %edx,%edx
80101d74:	74 09                	je     80101d7f <namex+0xdf>
80101d76:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d79:	0f 84 b7 00 00 00    	je     80101e36 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d7f:	83 ec 04             	sub    $0x4,%esp
80101d82:	6a 00                	push   $0x0
80101d84:	57                   	push   %edi
80101d85:	56                   	push   %esi
80101d86:	e8 65 fe ff ff       	call   80101bf0 <dirlookup>
80101d8b:	83 c4 10             	add    $0x10,%esp
80101d8e:	85 c0                	test   %eax,%eax
80101d90:	74 6e                	je     80101e00 <namex+0x160>
  iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d98:	56                   	push   %esi
80101d99:	e8 02 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d9e:	89 34 24             	mov    %esi,(%esp)
80101da1:	e8 4a fa ff ff       	call   801017f0 <iput>
80101da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101da9:	83 c4 10             	add    $0x10,%esp
80101dac:	89 c6                	mov    %eax,%esi
80101dae:	e9 38 ff ff ff       	jmp    80101ceb <namex+0x4b>
80101db3:	90                   	nop
80101db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101db8:	89 da                	mov    %ebx,%edx
80101dba:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101dbc:	83 ec 04             	sub    $0x4,%esp
80101dbf:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dc2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dc5:	51                   	push   %ecx
80101dc6:	53                   	push   %ebx
80101dc7:	57                   	push   %edi
80101dc8:	e8 b3 2f 00 00       	call   80104d80 <memmove>
    name[len] = 0;
80101dcd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dd0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dd3:	83 c4 10             	add    $0x10,%esp
80101dd6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dda:	89 d3                	mov    %edx,%ebx
80101ddc:	e9 61 ff ff ff       	jmp    80101d42 <namex+0xa2>
80101de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101de8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101deb:	85 c0                	test   %eax,%eax
80101ded:	75 5d                	jne    80101e4c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101def:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101df2:	89 f0                	mov    %esi,%eax
80101df4:	5b                   	pop    %ebx
80101df5:	5e                   	pop    %esi
80101df6:	5f                   	pop    %edi
80101df7:	5d                   	pop    %ebp
80101df8:	c3                   	ret    
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e00:	83 ec 0c             	sub    $0xc,%esp
80101e03:	56                   	push   %esi
80101e04:	e8 97 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101e09:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e0c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e0e:	e8 dd f9 ff ff       	call   801017f0 <iput>
      return 0;
80101e13:	83 c4 10             	add    $0x10,%esp
}
80101e16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e19:	89 f0                	mov    %esi,%eax
80101e1b:	5b                   	pop    %ebx
80101e1c:	5e                   	pop    %esi
80101e1d:	5f                   	pop    %edi
80101e1e:	5d                   	pop    %ebp
80101e1f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e20:	ba 01 00 00 00       	mov    $0x1,%edx
80101e25:	b8 01 00 00 00       	mov    $0x1,%eax
80101e2a:	e8 a1 f4 ff ff       	call   801012d0 <iget>
80101e2f:	89 c6                	mov    %eax,%esi
80101e31:	e9 b5 fe ff ff       	jmp    80101ceb <namex+0x4b>
      iunlock(ip);
80101e36:	83 ec 0c             	sub    $0xc,%esp
80101e39:	56                   	push   %esi
80101e3a:	e8 61 f9 ff ff       	call   801017a0 <iunlock>
      return ip;
80101e3f:	83 c4 10             	add    $0x10,%esp
}
80101e42:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e45:	89 f0                	mov    %esi,%eax
80101e47:	5b                   	pop    %ebx
80101e48:	5e                   	pop    %esi
80101e49:	5f                   	pop    %edi
80101e4a:	5d                   	pop    %ebp
80101e4b:	c3                   	ret    
    iput(ip);
80101e4c:	83 ec 0c             	sub    $0xc,%esp
80101e4f:	56                   	push   %esi
    return 0;
80101e50:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e52:	e8 99 f9 ff ff       	call   801017f0 <iput>
    return 0;
80101e57:	83 c4 10             	add    $0x10,%esp
80101e5a:	eb 93                	jmp    80101def <namex+0x14f>
80101e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e60 <dirlink>:
{
80101e60:	55                   	push   %ebp
80101e61:	89 e5                	mov    %esp,%ebp
80101e63:	57                   	push   %edi
80101e64:	56                   	push   %esi
80101e65:	53                   	push   %ebx
80101e66:	83 ec 20             	sub    $0x20,%esp
80101e69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e6c:	6a 00                	push   $0x0
80101e6e:	ff 75 0c             	pushl  0xc(%ebp)
80101e71:	53                   	push   %ebx
80101e72:	e8 79 fd ff ff       	call   80101bf0 <dirlookup>
80101e77:	83 c4 10             	add    $0x10,%esp
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	75 67                	jne    80101ee5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e81:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e84:	85 ff                	test   %edi,%edi
80101e86:	74 29                	je     80101eb1 <dirlink+0x51>
80101e88:	31 ff                	xor    %edi,%edi
80101e8a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e8d:	eb 09                	jmp    80101e98 <dirlink+0x38>
80101e8f:	90                   	nop
80101e90:	83 c7 10             	add    $0x10,%edi
80101e93:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e96:	73 19                	jae    80101eb1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e98:	6a 10                	push   $0x10
80101e9a:	57                   	push   %edi
80101e9b:	56                   	push   %esi
80101e9c:	53                   	push   %ebx
80101e9d:	e8 fe fa ff ff       	call   801019a0 <readi>
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	83 f8 10             	cmp    $0x10,%eax
80101ea8:	75 4e                	jne    80101ef8 <dirlink+0x98>
    if(de.inum == 0)
80101eaa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101eaf:	75 df                	jne    80101e90 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101eb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb4:	83 ec 04             	sub    $0x4,%esp
80101eb7:	6a 0e                	push   $0xe
80101eb9:	ff 75 0c             	pushl  0xc(%ebp)
80101ebc:	50                   	push   %eax
80101ebd:	e8 8e 2f 00 00       	call   80104e50 <strncpy>
  de.inum = inum;
80101ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec5:	6a 10                	push   $0x10
80101ec7:	57                   	push   %edi
80101ec8:	56                   	push   %esi
80101ec9:	53                   	push   %ebx
  de.inum = inum;
80101eca:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ece:	e8 cd fb ff ff       	call   80101aa0 <writei>
80101ed3:	83 c4 20             	add    $0x20,%esp
80101ed6:	83 f8 10             	cmp    $0x10,%eax
80101ed9:	75 2a                	jne    80101f05 <dirlink+0xa5>
  return 0;
80101edb:	31 c0                	xor    %eax,%eax
}
80101edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
    iput(ip);
80101ee5:	83 ec 0c             	sub    $0xc,%esp
80101ee8:	50                   	push   %eax
80101ee9:	e8 02 f9 ff ff       	call   801017f0 <iput>
    return -1;
80101eee:	83 c4 10             	add    $0x10,%esp
80101ef1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef6:	eb e5                	jmp    80101edd <dirlink+0x7d>
      panic("dirlink read");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 c8 80 10 80       	push   $0x801080c8
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 75 87 10 80       	push   $0x80108775
80101f0d:	e8 7e e4 ff ff       	call   80100390 <panic>
80101f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f20 <namei>:

struct inode*
namei(char *path)
{
80101f20:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f21:	31 d2                	xor    %edx,%edx
{
80101f23:	89 e5                	mov    %esp,%ebp
80101f25:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f2e:	e8 6d fd ff ff       	call   80101ca0 <namex>
}
80101f33:	c9                   	leave  
80101f34:	c3                   	ret    
80101f35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f40:	55                   	push   %ebp
  return namex(path, 1, name);
80101f41:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f46:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f4f:	e9 4c fd ff ff       	jmp    80101ca0 <namex>
80101f54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f60 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f60:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f61:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f66:	89 e5                	mov    %esp,%ebp
80101f68:	57                   	push   %edi
80101f69:	56                   	push   %esi
80101f6a:	53                   	push   %ebx
80101f6b:	83 ec 10             	sub    $0x10,%esp
80101f6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f71:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f78:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f7f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f83:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f87:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f8a:	85 c9                	test   %ecx,%ecx
80101f8c:	79 0a                	jns    80101f98 <itoa+0x38>
80101f8e:	89 f0                	mov    %esi,%eax
80101f90:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f93:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f95:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f98:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f9a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f9f:	90                   	nop
80101fa0:	89 d8                	mov    %ebx,%eax
80101fa2:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101fa5:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101fa8:	f7 ef                	imul   %edi
80101faa:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101fad:	29 da                	sub    %ebx,%edx
80101faf:	89 d3                	mov    %edx,%ebx
80101fb1:	75 ed                	jne    80101fa0 <itoa+0x40>
    *p = '\0';
80101fb3:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101fb6:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101fbb:	90                   	nop
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fc0:	89 c8                	mov    %ecx,%eax
80101fc2:	83 ee 01             	sub    $0x1,%esi
80101fc5:	f7 eb                	imul   %ebx
80101fc7:	89 c8                	mov    %ecx,%eax
80101fc9:	c1 f8 1f             	sar    $0x1f,%eax
80101fcc:	c1 fa 02             	sar    $0x2,%edx
80101fcf:	29 c2                	sub    %eax,%edx
80101fd1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fd4:	01 c0                	add    %eax,%eax
80101fd6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fd8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101fda:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101fdf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fe1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fe3:	75 db                	jne    80101fc0 <itoa+0x60>
    return b;
}
80101fe5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5f                   	pop    %edi
80101fee:	5d                   	pop    %ebp
80101fef:	c3                   	ret    

80101ff0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101ff6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101ff9:	83 ec 40             	sub    $0x40,%esp
80101ffc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fff:	6a 06                	push   $0x6
80102001:	68 d5 80 10 80       	push   $0x801080d5
80102006:	56                   	push   %esi
80102007:	e8 74 2d 00 00       	call   80104d80 <memmove>
  itoa(p->pid, path+ 6);
8010200c:	58                   	pop    %eax
8010200d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102010:	5a                   	pop    %edx
80102011:	50                   	push   %eax
80102012:	ff 73 10             	pushl  0x10(%ebx)
80102015:	e8 46 ff ff ff       	call   80101f60 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010201a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010201d:	83 c4 10             	add    $0x10,%esp
80102020:	85 c0                	test   %eax,%eax
80102022:	0f 84 98 01 00 00    	je     801021c0 <removeSwapFile+0x1d0>
  {
    return -1;
  }
  p->swapFile->off = 0;
  fileclose(p->swapFile);
80102028:	83 ec 0c             	sub    $0xc,%esp
  p->swapFile->off = 0;
8010202b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  fileclose(p->swapFile);
80102032:	ff 73 7c             	pushl  0x7c(%ebx)
  return namex(path, 1, name);
80102035:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80102038:	e8 43 ee ff ff       	call   80100e80 <fileclose>

  begin_op();
8010203d:	e8 ae 11 00 00       	call   801031f0 <begin_op>
  return namex(path, 1, name);
80102042:	89 f0                	mov    %esi,%eax
80102044:	89 d9                	mov    %ebx,%ecx
80102046:	ba 01 00 00 00       	mov    $0x1,%edx
8010204b:	e8 50 fc ff ff       	call   80101ca0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102050:	83 c4 10             	add    $0x10,%esp
80102053:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
80102055:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
80102057:	0f 84 6d 01 00 00    	je     801021ca <removeSwapFile+0x1da>
  {
    end_op();
    return -1;
  }

  ilock(dp);
8010205d:	83 ec 0c             	sub    $0xc,%esp
80102060:	50                   	push   %eax
80102061:	e8 5a f6 ff ff       	call   801016c0 <ilock>
  return strncmp(s, t, DIRSIZ);
80102066:	83 c4 0c             	add    $0xc,%esp
80102069:	6a 0e                	push   $0xe
8010206b:	68 dd 80 10 80       	push   $0x801080dd
80102070:	53                   	push   %ebx
80102071:	e8 7a 2d 00 00       	call   80104df0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102076:	83 c4 10             	add    $0x10,%esp
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 ff 00 00 00    	je     80102180 <removeSwapFile+0x190>
  return strncmp(s, t, DIRSIZ);
80102081:	83 ec 04             	sub    $0x4,%esp
80102084:	6a 0e                	push   $0xe
80102086:	68 dc 80 10 80       	push   $0x801080dc
8010208b:	53                   	push   %ebx
8010208c:	e8 5f 2d 00 00       	call   80104df0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102091:	83 c4 10             	add    $0x10,%esp
80102094:	85 c0                	test   %eax,%eax
80102096:	0f 84 e4 00 00 00    	je     80102180 <removeSwapFile+0x190>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010209c:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010209f:	83 ec 04             	sub    $0x4,%esp
801020a2:	50                   	push   %eax
801020a3:	53                   	push   %ebx
801020a4:	56                   	push   %esi
801020a5:	e8 46 fb ff ff       	call   80101bf0 <dirlookup>
801020aa:	83 c4 10             	add    $0x10,%esp
801020ad:	85 c0                	test   %eax,%eax
801020af:	89 c3                	mov    %eax,%ebx
801020b1:	0f 84 c9 00 00 00    	je     80102180 <removeSwapFile+0x190>
    goto bad;
  ilock(ip);
801020b7:	83 ec 0c             	sub    $0xc,%esp
801020ba:	50                   	push   %eax
801020bb:	e8 00 f6 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801020c0:	83 c4 10             	add    $0x10,%esp
801020c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801020c8:	0f 8e 18 01 00 00    	jle    801021e6 <removeSwapFile+0x1f6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020d3:	74 7b                	je     80102150 <removeSwapFile+0x160>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801020d5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801020d8:	83 ec 04             	sub    $0x4,%esp
801020db:	6a 10                	push   $0x10
801020dd:	6a 00                	push   $0x0
801020df:	57                   	push   %edi
801020e0:	e8 eb 2b 00 00       	call   80104cd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020e5:	6a 10                	push   $0x10
801020e7:	ff 75 b8             	pushl  -0x48(%ebp)
801020ea:	57                   	push   %edi
801020eb:	56                   	push   %esi
801020ec:	e8 af f9 ff ff       	call   80101aa0 <writei>
801020f1:	83 c4 20             	add    $0x20,%esp
801020f4:	83 f8 10             	cmp    $0x10,%eax
801020f7:	0f 85 dc 00 00 00    	jne    801021d9 <removeSwapFile+0x1e9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020fd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102102:	0f 84 98 00 00 00    	je     801021a0 <removeSwapFile+0x1b0>
  iunlock(ip);
80102108:	83 ec 0c             	sub    $0xc,%esp
8010210b:	56                   	push   %esi
8010210c:	e8 8f f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102111:	89 34 24             	mov    %esi,(%esp)
80102114:	e8 d7 f6 ff ff       	call   801017f0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102119:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010211e:	89 1c 24             	mov    %ebx,(%esp)
80102121:	e8 ea f4 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
80102126:	89 1c 24             	mov    %ebx,(%esp)
80102129:	e8 72 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
8010212e:	89 1c 24             	mov    %ebx,(%esp)
80102131:	e8 ba f6 ff ff       	call   801017f0 <iput>
  iunlockput(ip);

  end_op();
80102136:	e8 25 11 00 00       	call   80103260 <end_op>

  return 0;
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102140:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102143:	5b                   	pop    %ebx
80102144:	5e                   	pop    %esi
80102145:	5f                   	pop    %edi
80102146:	5d                   	pop    %ebp
80102147:	c3                   	ret    
80102148:	90                   	nop
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80102150:	83 ec 0c             	sub    $0xc,%esp
80102153:	53                   	push   %ebx
80102154:	e8 57 33 00 00       	call   801054b0 <isdirempty>
80102159:	83 c4 10             	add    $0x10,%esp
8010215c:	85 c0                	test   %eax,%eax
8010215e:	0f 85 71 ff ff ff    	jne    801020d5 <removeSwapFile+0xe5>
  iunlock(ip);
80102164:	83 ec 0c             	sub    $0xc,%esp
80102167:	53                   	push   %ebx
80102168:	e8 33 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
8010216d:	89 1c 24             	mov    %ebx,(%esp)
80102170:	e8 7b f6 ff ff       	call   801017f0 <iput>
80102175:	83 c4 10             	add    $0x10,%esp
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	56                   	push   %esi
80102184:	e8 17 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102189:	89 34 24             	mov    %esi,(%esp)
8010218c:	e8 5f f6 ff ff       	call   801017f0 <iput>
    end_op();
80102191:	e8 ca 10 00 00       	call   80103260 <end_op>
    return -1;
80102196:	83 c4 10             	add    $0x10,%esp
80102199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010219e:	eb a0                	jmp    80102140 <removeSwapFile+0x150>
    dp->nlink--;
801021a0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	56                   	push   %esi
801021a9:	e8 62 f4 ff ff       	call   80101610 <iupdate>
801021ae:	83 c4 10             	add    $0x10,%esp
801021b1:	e9 52 ff ff ff       	jmp    80102108 <removeSwapFile+0x118>
801021b6:	8d 76 00             	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801021c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c5:	e9 76 ff ff ff       	jmp    80102140 <removeSwapFile+0x150>
    end_op();
801021ca:	e8 91 10 00 00       	call   80103260 <end_op>
    return -1;
801021cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021d4:	e9 67 ff ff ff       	jmp    80102140 <removeSwapFile+0x150>
    panic("unlink: writei");
801021d9:	83 ec 0c             	sub    $0xc,%esp
801021dc:	68 f1 80 10 80       	push   $0x801080f1
801021e1:	e8 aa e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021e6:	83 ec 0c             	sub    $0xc,%esp
801021e9:	68 df 80 10 80       	push   $0x801080df
801021ee:	e8 9d e1 ff ff       	call   80100390 <panic>
801021f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102200 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102200:	55                   	push   %ebp
80102201:	89 e5                	mov    %esp,%ebp
80102203:	56                   	push   %esi
80102204:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102205:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102208:	83 ec 14             	sub    $0x14,%esp
8010220b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010220e:	6a 06                	push   $0x6
80102210:	68 d5 80 10 80       	push   $0x801080d5
80102215:	56                   	push   %esi
80102216:	e8 65 2b 00 00       	call   80104d80 <memmove>
  itoa(p->pid, path+ 6);
8010221b:	58                   	pop    %eax
8010221c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010221f:	5a                   	pop    %edx
80102220:	50                   	push   %eax
80102221:	ff 73 10             	pushl  0x10(%ebx)
80102224:	e8 37 fd ff ff       	call   80101f60 <itoa>

    begin_op();
80102229:	e8 c2 0f 00 00       	call   801031f0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010222e:	6a 00                	push   $0x0
80102230:	6a 00                	push   $0x0
80102232:	6a 02                	push   $0x2
80102234:	56                   	push   %esi
80102235:	e8 86 34 00 00       	call   801056c0 <create>
  iunlock(in);
8010223a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010223d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010223f:	50                   	push   %eax
80102240:	e8 5b f5 ff ff       	call   801017a0 <iunlock>

  p->swapFile = filealloc();
80102245:	e8 76 eb ff ff       	call   80100dc0 <filealloc>
  if (p->swapFile == 0)
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010224f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102252:	74 32                	je     80102286 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102254:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102257:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010225a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102260:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102263:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010226a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010226d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102271:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102274:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102278:	e8 e3 0f 00 00       	call   80103260 <end_op>

    return 0;
}
8010227d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102280:	31 c0                	xor    %eax,%eax
80102282:	5b                   	pop    %ebx
80102283:	5e                   	pop    %esi
80102284:	5d                   	pop    %ebp
80102285:	c3                   	ret    
    panic("no slot for files on /store");
80102286:	83 ec 0c             	sub    $0xc,%esp
80102289:	68 00 81 10 80       	push   $0x80108100
8010228e:	e8 fd e0 ff ff       	call   80100390 <panic>
80102293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022a9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022ac:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801022af:	8b 55 14             	mov    0x14(%ebp),%edx
801022b2:	89 55 10             	mov    %edx,0x10(%ebp)
801022b5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022b8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022bb:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801022bc:	e9 6f ed ff ff       	jmp    80101030 <filewrite>
801022c1:	eb 0d                	jmp    801022d0 <readFromSwapFile>
801022c3:	90                   	nop
801022c4:	90                   	nop
801022c5:	90                   	nop
801022c6:	90                   	nop
801022c7:	90                   	nop
801022c8:	90                   	nop
801022c9:	90                   	nop
801022ca:	90                   	nop
801022cb:	90                   	nop
801022cc:	90                   	nop
801022cd:	90                   	nop
801022ce:	90                   	nop
801022cf:	90                   	nop

801022d0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022d9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022dc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801022df:	8b 55 14             	mov    0x14(%ebp),%edx
801022e2:	89 55 10             	mov    %edx,0x10(%ebp)
801022e5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022e8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022eb:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022ec:	e9 af ec ff ff       	jmp    80100fa0 <fileread>
801022f1:	66 90                	xchg   %ax,%ax
801022f3:	66 90                	xchg   %ax,%ax
801022f5:	66 90                	xchg   %ax,%ax
801022f7:	66 90                	xchg   %ax,%ax
801022f9:	66 90                	xchg   %ax,%ax
801022fb:	66 90                	xchg   %ax,%ax
801022fd:	66 90                	xchg   %ax,%ax
801022ff:	90                   	nop

80102300 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	57                   	push   %edi
80102304:	56                   	push   %esi
80102305:	53                   	push   %ebx
80102306:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102309:	85 c0                	test   %eax,%eax
8010230b:	0f 84 b4 00 00 00    	je     801023c5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102311:	8b 58 08             	mov    0x8(%eax),%ebx
80102314:	89 c6                	mov    %eax,%esi
80102316:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010231c:	0f 87 96 00 00 00    	ja     801023b8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102322:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102327:	89 f6                	mov    %esi,%esi
80102329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102330:	89 ca                	mov    %ecx,%edx
80102332:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102333:	83 e0 c0             	and    $0xffffffc0,%eax
80102336:	3c 40                	cmp    $0x40,%al
80102338:	75 f6                	jne    80102330 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010233a:	31 ff                	xor    %edi,%edi
8010233c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102341:	89 f8                	mov    %edi,%eax
80102343:	ee                   	out    %al,(%dx)
80102344:	b8 01 00 00 00       	mov    $0x1,%eax
80102349:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010234e:	ee                   	out    %al,(%dx)
8010234f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102354:	89 d8                	mov    %ebx,%eax
80102356:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102357:	89 d8                	mov    %ebx,%eax
80102359:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010235e:	c1 f8 08             	sar    $0x8,%eax
80102361:	ee                   	out    %al,(%dx)
80102362:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102367:	89 f8                	mov    %edi,%eax
80102369:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010236a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010236e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102373:	c1 e0 04             	shl    $0x4,%eax
80102376:	83 e0 10             	and    $0x10,%eax
80102379:	83 c8 e0             	or     $0xffffffe0,%eax
8010237c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010237d:	f6 06 04             	testb  $0x4,(%esi)
80102380:	75 16                	jne    80102398 <idestart+0x98>
80102382:	b8 20 00 00 00       	mov    $0x20,%eax
80102387:	89 ca                	mov    %ecx,%edx
80102389:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010238a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010238d:	5b                   	pop    %ebx
8010238e:	5e                   	pop    %esi
8010238f:	5f                   	pop    %edi
80102390:	5d                   	pop    %ebp
80102391:	c3                   	ret    
80102392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102398:	b8 30 00 00 00       	mov    $0x30,%eax
8010239d:	89 ca                	mov    %ecx,%edx
8010239f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801023a0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801023a5:	83 c6 5c             	add    $0x5c,%esi
801023a8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ad:	fc                   	cld    
801023ae:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023b3:	5b                   	pop    %ebx
801023b4:	5e                   	pop    %esi
801023b5:	5f                   	pop    %edi
801023b6:	5d                   	pop    %ebp
801023b7:	c3                   	ret    
    panic("incorrect blockno");
801023b8:	83 ec 0c             	sub    $0xc,%esp
801023bb:	68 78 81 10 80       	push   $0x80108178
801023c0:	e8 cb df ff ff       	call   80100390 <panic>
    panic("idestart");
801023c5:	83 ec 0c             	sub    $0xc,%esp
801023c8:	68 6f 81 10 80       	push   $0x8010816f
801023cd:	e8 be df ff ff       	call   80100390 <panic>
801023d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023e0 <ideinit>:
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023e6:	68 8a 81 10 80       	push   $0x8010818a
801023eb:	68 80 b5 10 80       	push   $0x8010b580
801023f0:	e8 8b 26 00 00       	call   80104a80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023f5:	58                   	pop    %eax
801023f6:	a1 40 5d 19 80       	mov    0x80195d40,%eax
801023fb:	5a                   	pop    %edx
801023fc:	83 e8 01             	sub    $0x1,%eax
801023ff:	50                   	push   %eax
80102400:	6a 0e                	push   $0xe
80102402:	e8 a9 02 00 00       	call   801026b0 <ioapicenable>
80102407:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010240a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010240f:	90                   	nop
80102410:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102411:	83 e0 c0             	and    $0xffffffc0,%eax
80102414:	3c 40                	cmp    $0x40,%al
80102416:	75 f8                	jne    80102410 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102418:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010241d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102422:	ee                   	out    %al,(%dx)
80102423:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102428:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010242d:	eb 06                	jmp    80102435 <ideinit+0x55>
8010242f:	90                   	nop
  for(i=0; i<1000; i++){
80102430:	83 e9 01             	sub    $0x1,%ecx
80102433:	74 0f                	je     80102444 <ideinit+0x64>
80102435:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102436:	84 c0                	test   %al,%al
80102438:	74 f6                	je     80102430 <ideinit+0x50>
      havedisk1 = 1;
8010243a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102441:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102444:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102449:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010244e:	ee                   	out    %al,(%dx)
}
8010244f:	c9                   	leave  
80102450:	c3                   	ret    
80102451:	eb 0d                	jmp    80102460 <ideintr>
80102453:	90                   	nop
80102454:	90                   	nop
80102455:	90                   	nop
80102456:	90                   	nop
80102457:	90                   	nop
80102458:	90                   	nop
80102459:	90                   	nop
8010245a:	90                   	nop
8010245b:	90                   	nop
8010245c:	90                   	nop
8010245d:	90                   	nop
8010245e:	90                   	nop
8010245f:	90                   	nop

80102460 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	57                   	push   %edi
80102464:	56                   	push   %esi
80102465:	53                   	push   %ebx
80102466:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102469:	68 80 b5 10 80       	push   $0x8010b580
8010246e:	e8 4d 27 00 00       	call   80104bc0 <acquire>

  if((b = idequeue) == 0){
80102473:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102479:	83 c4 10             	add    $0x10,%esp
8010247c:	85 db                	test   %ebx,%ebx
8010247e:	74 67                	je     801024e7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102480:	8b 43 58             	mov    0x58(%ebx),%eax
80102483:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102488:	8b 3b                	mov    (%ebx),%edi
8010248a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102490:	75 31                	jne    801024c3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102492:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102497:	89 f6                	mov    %esi,%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801024a0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024a1:	89 c6                	mov    %eax,%esi
801024a3:	83 e6 c0             	and    $0xffffffc0,%esi
801024a6:	89 f1                	mov    %esi,%ecx
801024a8:	80 f9 40             	cmp    $0x40,%cl
801024ab:	75 f3                	jne    801024a0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024ad:	a8 21                	test   $0x21,%al
801024af:	75 12                	jne    801024c3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801024b1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024b4:	b9 80 00 00 00       	mov    $0x80,%ecx
801024b9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024be:	fc                   	cld    
801024bf:	f3 6d                	rep insl (%dx),%es:(%edi)
801024c1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024c3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801024c6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024c9:	89 f9                	mov    %edi,%ecx
801024cb:	83 c9 02             	or     $0x2,%ecx
801024ce:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801024d0:	53                   	push   %ebx
801024d1:	e8 aa 22 00 00       	call   80104780 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024d6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024db:	83 c4 10             	add    $0x10,%esp
801024de:	85 c0                	test   %eax,%eax
801024e0:	74 05                	je     801024e7 <ideintr+0x87>
    idestart(idequeue);
801024e2:	e8 19 fe ff ff       	call   80102300 <idestart>
    release(&idelock);
801024e7:	83 ec 0c             	sub    $0xc,%esp
801024ea:	68 80 b5 10 80       	push   $0x8010b580
801024ef:	e8 8c 27 00 00       	call   80104c80 <release>

  release(&idelock);
}
801024f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024f7:	5b                   	pop    %ebx
801024f8:	5e                   	pop    %esi
801024f9:	5f                   	pop    %edi
801024fa:	5d                   	pop    %ebp
801024fb:	c3                   	ret    
801024fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102500 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	53                   	push   %ebx
80102504:	83 ec 10             	sub    $0x10,%esp
80102507:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010250a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010250d:	50                   	push   %eax
8010250e:	e8 1d 25 00 00       	call   80104a30 <holdingsleep>
80102513:	83 c4 10             	add    $0x10,%esp
80102516:	85 c0                	test   %eax,%eax
80102518:	0f 84 c6 00 00 00    	je     801025e4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010251e:	8b 03                	mov    (%ebx),%eax
80102520:	83 e0 06             	and    $0x6,%eax
80102523:	83 f8 02             	cmp    $0x2,%eax
80102526:	0f 84 ab 00 00 00    	je     801025d7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010252c:	8b 53 04             	mov    0x4(%ebx),%edx
8010252f:	85 d2                	test   %edx,%edx
80102531:	74 0d                	je     80102540 <iderw+0x40>
80102533:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102538:	85 c0                	test   %eax,%eax
8010253a:	0f 84 b1 00 00 00    	je     801025f1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	68 80 b5 10 80       	push   $0x8010b580
80102548:	e8 73 26 00 00       	call   80104bc0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010254d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102553:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102556:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010255d:	85 d2                	test   %edx,%edx
8010255f:	75 09                	jne    8010256a <iderw+0x6a>
80102561:	eb 6d                	jmp    801025d0 <iderw+0xd0>
80102563:	90                   	nop
80102564:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102568:	89 c2                	mov    %eax,%edx
8010256a:	8b 42 58             	mov    0x58(%edx),%eax
8010256d:	85 c0                	test   %eax,%eax
8010256f:	75 f7                	jne    80102568 <iderw+0x68>
80102571:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102574:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102576:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010257c:	74 42                	je     801025c0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010257e:	8b 03                	mov    (%ebx),%eax
80102580:	83 e0 06             	and    $0x6,%eax
80102583:	83 f8 02             	cmp    $0x2,%eax
80102586:	74 23                	je     801025ab <iderw+0xab>
80102588:	90                   	nop
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102590:	83 ec 08             	sub    $0x8,%esp
80102593:	68 80 b5 10 80       	push   $0x8010b580
80102598:	53                   	push   %ebx
80102599:	e8 f2 1f 00 00       	call   80104590 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010259e:	8b 03                	mov    (%ebx),%eax
801025a0:	83 c4 10             	add    $0x10,%esp
801025a3:	83 e0 06             	and    $0x6,%eax
801025a6:	83 f8 02             	cmp    $0x2,%eax
801025a9:	75 e5                	jne    80102590 <iderw+0x90>
  }


  release(&idelock);
801025ab:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025b5:	c9                   	leave  
  release(&idelock);
801025b6:	e9 c5 26 00 00       	jmp    80104c80 <release>
801025bb:	90                   	nop
801025bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801025c0:	89 d8                	mov    %ebx,%eax
801025c2:	e8 39 fd ff ff       	call   80102300 <idestart>
801025c7:	eb b5                	jmp    8010257e <iderw+0x7e>
801025c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025d0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025d5:	eb 9d                	jmp    80102574 <iderw+0x74>
    panic("iderw: nothing to do");
801025d7:	83 ec 0c             	sub    $0xc,%esp
801025da:	68 a4 81 10 80       	push   $0x801081a4
801025df:	e8 ac dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025e4:	83 ec 0c             	sub    $0xc,%esp
801025e7:	68 8e 81 10 80       	push   $0x8010818e
801025ec:	e8 9f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025f1:	83 ec 0c             	sub    $0xc,%esp
801025f4:	68 b9 81 10 80       	push   $0x801081b9
801025f9:	e8 92 dd ff ff       	call   80100390 <panic>
801025fe:	66 90                	xchg   %ax,%ax

80102600 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102600:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102601:	c7 05 74 56 12 80 00 	movl   $0xfec00000,0x80125674
80102608:	00 c0 fe 
{
8010260b:	89 e5                	mov    %esp,%ebp
8010260d:	56                   	push   %esi
8010260e:	53                   	push   %ebx
  ioapic->reg = reg;
8010260f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102616:	00 00 00 
  return ioapic->data;
80102619:	a1 74 56 12 80       	mov    0x80125674,%eax
8010261e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102621:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102627:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010262d:	0f b6 15 a0 57 19 80 	movzbl 0x801957a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102634:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102637:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010263a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010263d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102640:	39 c2                	cmp    %eax,%edx
80102642:	74 16                	je     8010265a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102644:	83 ec 0c             	sub    $0xc,%esp
80102647:	68 d8 81 10 80       	push   $0x801081d8
8010264c:	e8 0f e0 ff ff       	call   80100660 <cprintf>
80102651:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
80102657:	83 c4 10             	add    $0x10,%esp
8010265a:	83 c3 21             	add    $0x21,%ebx
{
8010265d:	ba 10 00 00 00       	mov    $0x10,%edx
80102662:	b8 20 00 00 00       	mov    $0x20,%eax
80102667:	89 f6                	mov    %esi,%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102670:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102672:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102678:	89 c6                	mov    %eax,%esi
8010267a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102680:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102683:	89 71 10             	mov    %esi,0x10(%ecx)
80102686:	8d 72 01             	lea    0x1(%edx),%esi
80102689:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010268c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010268e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102690:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
80102696:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010269d:	75 d1                	jne    80102670 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010269f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026a2:	5b                   	pop    %ebx
801026a3:	5e                   	pop    %esi
801026a4:	5d                   	pop    %ebp
801026a5:	c3                   	ret    
801026a6:	8d 76 00             	lea    0x0(%esi),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026b0:	55                   	push   %ebp
  ioapic->reg = reg;
801026b1:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
{
801026b7:	89 e5                	mov    %esp,%ebp
801026b9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026bc:	8d 50 20             	lea    0x20(%eax),%edx
801026bf:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026c3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026c5:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026cb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ce:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026d4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026d6:	a1 74 56 12 80       	mov    0x80125674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026db:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026de:	89 50 10             	mov    %edx,0x10(%eax)
}
801026e1:	5d                   	pop    %ebp
801026e2:	c3                   	ret    
801026e3:	66 90                	xchg   %ax,%ax
801026e5:	66 90                	xchg   %ax,%ax
801026e7:	66 90                	xchg   %ax,%ax
801026e9:	66 90                	xchg   %ax,%ax
801026eb:	66 90                	xchg   %ax,%ax
801026ed:	66 90                	xchg   %ax,%ax
801026ef:	90                   	nop

801026f0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
801026f3:	53                   	push   %ebx
801026f4:	83 ec 04             	sub    $0x4,%esp
801026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801026fa:	a9 ff 0f 00 00       	test   $0xfff,%eax
801026ff:	0f 85 ad 00 00 00    	jne    801027b2 <kfree+0xc2>
80102705:	3d e8 09 1a 80       	cmp    $0x801a09e8,%eax
8010270a:	0f 82 a2 00 00 00    	jb     801027b2 <kfree+0xc2>
#define V2P(a) (((uint) (a)) - KERNBASE)
#define P2V(a) ((void *)(((char *) (a)) + KERNBASE))

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102710:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102716:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010271c:	0f 87 90 00 00 00    	ja     801027b2 <kfree+0xc2>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102722:	83 ec 04             	sub    $0x4,%esp
80102725:	68 00 10 00 00       	push   $0x1000
8010272a:	6a 01                	push   $0x1
8010272c:	50                   	push   %eax
8010272d:	e8 9e 25 00 00       	call   80104cd0 <memset>

  if(kmem.use_lock) 
80102732:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
80102738:	83 c4 10             	add    $0x10,%esp
8010273b:	85 d2                	test   %edx,%edx
8010273d:	75 61                	jne    801027a0 <kfree+0xb0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010273f:	c1 eb 0c             	shr    $0xc,%ebx
80102742:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 1)
80102745:	83 3c c5 90 56 12 80 	cmpl   $0x1,-0x7feda970(,%eax,8)
8010274c:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010274d:	8d 14 c5 8c 56 12 80 	lea    -0x7feda974(,%eax,8),%edx
  if(r->refcount != 1)
80102754:	75 69                	jne    801027bf <kfree+0xcf>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
80102756:	8b 0d b8 56 12 80    	mov    0x801256b8,%ecx
  r->refcount = 0;
8010275c:	c7 04 c5 90 56 12 80 	movl   $0x0,-0x7feda970(,%eax,8)
80102763:	00 00 00 00 
  kmem.freelist = r;
80102767:	89 15 b8 56 12 80    	mov    %edx,0x801256b8
  r->next = kmem.freelist;
8010276d:	89 0c c5 8c 56 12 80 	mov    %ecx,-0x7feda974(,%eax,8)
  if(kmem.use_lock)
80102774:	a1 b4 56 12 80       	mov    0x801256b4,%eax
80102779:	85 c0                	test   %eax,%eax
8010277b:	75 0b                	jne    80102788 <kfree+0x98>
    release(&kmem.lock);
}
8010277d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102780:	c9                   	leave  
80102781:	c3                   	ret    
80102782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102788:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
8010278f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102792:	c9                   	leave  
    release(&kmem.lock);
80102793:	e9 e8 24 00 00       	jmp    80104c80 <release>
80102798:	90                   	nop
80102799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801027a0:	83 ec 0c             	sub    $0xc,%esp
801027a3:	68 80 56 12 80       	push   $0x80125680
801027a8:	e8 13 24 00 00       	call   80104bc0 <acquire>
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	eb 8d                	jmp    8010273f <kfree+0x4f>
    panic("kfree");
801027b2:	83 ec 0c             	sub    $0xc,%esp
801027b5:	68 0a 82 10 80       	push   $0x8010820a
801027ba:	e8 d1 db ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
801027bf:	83 ec 0c             	sub    $0xc,%esp
801027c2:	68 10 82 10 80       	push   $0x80108210
801027c7:	e8 c4 db ff ff       	call   80100390 <panic>
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	53                   	push   %ebx
801027d4:	83 ec 04             	sub    $0x4,%esp
801027d7:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801027da:	a9 ff 0f 00 00       	test   $0xfff,%eax
801027df:	0f 85 bd 00 00 00    	jne    801028a2 <kfree_nocheck+0xd2>
801027e5:	3d e8 09 1a 80       	cmp    $0x801a09e8,%eax
801027ea:	0f 82 b2 00 00 00    	jb     801028a2 <kfree_nocheck+0xd2>
801027f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801027f6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801027fc:	0f 87 a0 00 00 00    	ja     801028a2 <kfree_nocheck+0xd2>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102802:	83 ec 04             	sub    $0x4,%esp
80102805:	68 00 10 00 00       	push   $0x1000
8010280a:	6a 01                	push   $0x1
8010280c:	50                   	push   %eax
8010280d:	e8 be 24 00 00       	call   80104cd0 <memset>

  if(kmem.use_lock) 
80102812:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
80102818:	83 c4 10             	add    $0x10,%esp
8010281b:	85 d2                	test   %edx,%edx
8010281d:	75 31                	jne    80102850 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
8010281f:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102824:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102827:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
8010282a:	c7 04 dd 90 56 12 80 	movl   $0x0,-0x7feda970(,%ebx,8)
80102831:	00 00 00 00 
  r->next = kmem.freelist;
80102835:	89 04 dd 8c 56 12 80 	mov    %eax,-0x7feda974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010283c:	8d 04 dd 8c 56 12 80 	lea    -0x7feda974(,%ebx,8),%eax
80102843:	a3 b8 56 12 80       	mov    %eax,0x801256b8
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284b:	c9                   	leave  
8010284c:	c3                   	ret    
8010284d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102850:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102853:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102856:	68 80 56 12 80       	push   $0x80125680
  r->next = kmem.freelist;
8010285b:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
8010285e:	e8 5d 23 00 00       	call   80104bc0 <acquire>
  r->next = kmem.freelist;
80102863:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  if(kmem.use_lock)
80102868:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
8010286b:	c7 04 dd 90 56 12 80 	movl   $0x0,-0x7feda970(,%ebx,8)
80102872:	00 00 00 00 
  r->next = kmem.freelist;
80102876:	89 04 dd 8c 56 12 80 	mov    %eax,-0x7feda974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010287d:	8d 04 dd 8c 56 12 80 	lea    -0x7feda974(,%ebx,8),%eax
80102884:	a3 b8 56 12 80       	mov    %eax,0x801256b8
  if(kmem.use_lock)
80102889:	a1 b4 56 12 80       	mov    0x801256b4,%eax
8010288e:	85 c0                	test   %eax,%eax
80102890:	74 b6                	je     80102848 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102892:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
80102899:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010289c:	c9                   	leave  
    release(&kmem.lock);
8010289d:	e9 de 23 00 00       	jmp    80104c80 <release>
    panic("kfree_nocheck");
801028a2:	83 ec 0c             	sub    $0xc,%esp
801028a5:	68 2d 82 10 80       	push   $0x8010822d
801028aa:	e8 e1 da ff ff       	call   80100390 <panic>
801028af:	90                   	nop

801028b0 <freerange>:
{
801028b0:	55                   	push   %ebp
801028b1:	89 e5                	mov    %esp,%ebp
801028b3:	56                   	push   %esi
801028b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028cd:	39 de                	cmp    %ebx,%esi
801028cf:	72 23                	jb     801028f4 <freerange+0x44>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
801028d8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028de:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
801028e7:	50                   	push   %eax
801028e8:	e8 e3 fe ff ff       	call   801027d0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028ed:	83 c4 10             	add    $0x10,%esp
801028f0:	39 f3                	cmp    %esi,%ebx
801028f2:	76 e4                	jbe    801028d8 <freerange+0x28>
}
801028f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f7:	5b                   	pop    %ebx
801028f8:	5e                   	pop    %esi
801028f9:	5d                   	pop    %ebp
801028fa:	c3                   	ret    
801028fb:	90                   	nop
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <kinit1>:
{
80102900:	55                   	push   %ebp
80102901:	89 e5                	mov    %esp,%ebp
80102903:	56                   	push   %esi
80102904:	53                   	push   %ebx
80102905:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102908:	83 ec 08             	sub    $0x8,%esp
8010290b:	68 3b 82 10 80       	push   $0x8010823b
80102910:	68 80 56 12 80       	push   $0x80125680
80102915:	e8 66 21 00 00       	call   80104a80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010291a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010291d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102920:	c7 05 b4 56 12 80 00 	movl   $0x0,0x801256b4
80102927:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010292a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102930:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102936:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010293c:	39 de                	cmp    %ebx,%esi
8010293e:	72 1c                	jb     8010295c <kinit1+0x5c>
    kfree_nocheck(p);
80102940:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102946:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102949:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
8010294f:	50                   	push   %eax
80102950:	e8 7b fe ff ff       	call   801027d0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102955:	83 c4 10             	add    $0x10,%esp
80102958:	39 de                	cmp    %ebx,%esi
8010295a:	73 e4                	jae    80102940 <kinit1+0x40>
}
8010295c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010295f:	5b                   	pop    %ebx
80102960:	5e                   	pop    %esi
80102961:	5d                   	pop    %ebp
80102962:	c3                   	ret    
80102963:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102970 <kinit2>:
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	56                   	push   %esi
80102974:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102975:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102978:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010297b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102981:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102987:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010298d:	39 de                	cmp    %ebx,%esi
8010298f:	72 23                	jb     801029b4 <kinit2+0x44>
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102998:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010299e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
801029a7:	50                   	push   %eax
801029a8:	e8 23 fe ff ff       	call   801027d0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801029ad:	83 c4 10             	add    $0x10,%esp
801029b0:	39 de                	cmp    %ebx,%esi
801029b2:	73 e4                	jae    80102998 <kinit2+0x28>
  kmem.use_lock = 1;
801029b4:	c7 05 b4 56 12 80 01 	movl   $0x1,0x801256b4
801029bb:	00 00 00 
}
801029be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029c1:	5b                   	pop    %ebx
801029c2:	5e                   	pop    %esi
801029c3:	5d                   	pop    %ebp
801029c4:	c3                   	ret    
801029c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
801029d6:	a1 b4 56 12 80       	mov    0x801256b4,%eax
801029db:	85 c0                	test   %eax,%eax
801029dd:	75 59                	jne    80102a38 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029df:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  if(r)
801029e4:	85 c0                	test   %eax,%eax
801029e6:	74 73                	je     80102a5b <kalloc+0x8b>
  {
    kmem.freelist = r->next;
801029e8:	8b 10                	mov    (%eax),%edx
801029ea:	89 15 b8 56 12 80    	mov    %edx,0x801256b8
    r->refcount = 1;
801029f0:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
801029f7:	8b 0d b4 56 12 80    	mov    0x801256b4,%ecx
801029fd:	85 c9                	test   %ecx,%ecx
801029ff:	75 0f                	jne    80102a10 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102a01:	2d bc 56 12 80       	sub    $0x801256bc,%eax
80102a06:	c1 e0 09             	shl    $0x9,%eax
80102a09:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102a0e:	c9                   	leave  
80102a0f:	c3                   	ret    
    release(&kmem.lock);
80102a10:	83 ec 0c             	sub    $0xc,%esp
80102a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a16:	68 80 56 12 80       	push   $0x80125680
80102a1b:	e8 60 22 00 00       	call   80104c80 <release>
80102a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a23:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102a26:	2d bc 56 12 80       	sub    $0x801256bc,%eax
80102a2b:	c1 e0 09             	shl    $0x9,%eax
80102a2e:	05 00 00 00 80       	add    $0x80000000,%eax
80102a33:	eb d9                	jmp    80102a0e <kalloc+0x3e>
80102a35:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102a38:	83 ec 0c             	sub    $0xc,%esp
80102a3b:	68 80 56 12 80       	push   $0x80125680
80102a40:	e8 7b 21 00 00       	call   80104bc0 <acquire>
  r = kmem.freelist;
80102a45:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  if(r)
80102a4a:	83 c4 10             	add    $0x10,%esp
80102a4d:	85 c0                	test   %eax,%eax
80102a4f:	75 97                	jne    801029e8 <kalloc+0x18>
  if(kmem.use_lock)
80102a51:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
80102a57:	85 d2                	test   %edx,%edx
80102a59:	75 05                	jne    80102a60 <kalloc+0x90>
{
80102a5b:	31 c0                	xor    %eax,%eax
}
80102a5d:	c9                   	leave  
80102a5e:	c3                   	ret    
80102a5f:	90                   	nop
    release(&kmem.lock);
80102a60:	83 ec 0c             	sub    $0xc,%esp
80102a63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a66:	68 80 56 12 80       	push   $0x80125680
80102a6b:	e8 10 22 00 00       	call   80104c80 <release>
80102a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a73:	83 c4 10             	add    $0x10,%esp
}
80102a76:	c9                   	leave  
80102a77:	c3                   	ret    
80102a78:	90                   	nop
80102a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a80 <refDec>:

void
refDec(char *v)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	53                   	push   %ebx
80102a84:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102a87:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
{
80102a8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102a90:	85 d2                	test   %edx,%edx
80102a92:	75 1c                	jne    80102ab0 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102a94:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102a9a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102a9d:	83 2c c5 c0 56 12 80 	subl   $0x1,-0x7feda940(,%eax,8)
80102aa4:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102aa5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aa8:	c9                   	leave  
80102aa9:	c3                   	ret    
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102ab0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ab3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102ab9:	68 80 56 12 80       	push   $0x80125680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102abe:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ac1:	e8 fa 20 00 00       	call   80104bc0 <acquire>
  if(kmem.use_lock)
80102ac6:	a1 b4 56 12 80       	mov    0x801256b4,%eax
  r->refcount -= 1;
80102acb:	83 2c dd c0 56 12 80 	subl   $0x1,-0x7feda940(,%ebx,8)
80102ad2:	01 
  if(kmem.use_lock)
80102ad3:	83 c4 10             	add    $0x10,%esp
80102ad6:	85 c0                	test   %eax,%eax
80102ad8:	74 cb                	je     80102aa5 <refDec+0x25>
    release(&kmem.lock);
80102ada:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
80102ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ae4:	c9                   	leave  
    release(&kmem.lock);
80102ae5:	e9 96 21 00 00       	jmp    80104c80 <release>
80102aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102af0 <refInc>:

void
refInc(char *v)
{
80102af0:	55                   	push   %ebp
80102af1:	89 e5                	mov    %esp,%ebp
80102af3:	53                   	push   %ebx
80102af4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102af7:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
{
80102afd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102b00:	85 d2                	test   %edx,%edx
80102b02:	75 1c                	jne    80102b20 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b04:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102b0a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102b0d:	83 04 c5 c0 56 12 80 	addl   $0x1,-0x7feda940(,%eax,8)
80102b14:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b18:	c9                   	leave  
80102b19:	c3                   	ret    
80102b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102b20:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b23:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102b29:	68 80 56 12 80       	push   $0x80125680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b2e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102b31:	e8 8a 20 00 00       	call   80104bc0 <acquire>
  if(kmem.use_lock)
80102b36:	a1 b4 56 12 80       	mov    0x801256b4,%eax
  r->refcount += 1;
80102b3b:	83 04 dd c0 56 12 80 	addl   $0x1,-0x7feda940(,%ebx,8)
80102b42:	01 
  if(kmem.use_lock)
80102b43:	83 c4 10             	add    $0x10,%esp
80102b46:	85 c0                	test   %eax,%eax
80102b48:	74 cb                	je     80102b15 <refInc+0x25>
    release(&kmem.lock);
80102b4a:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
80102b51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b54:	c9                   	leave  
    release(&kmem.lock);
80102b55:	e9 26 21 00 00       	jmp    80104c80 <release>
80102b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b60 <getRefs>:

int
getRefs(char *v)
{
80102b60:	55                   	push   %ebp
80102b61:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b63:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102b66:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b67:	05 00 00 00 80       	add    $0x80000000,%eax
80102b6c:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102b6f:	8b 04 c5 c0 56 12 80 	mov    -0x7feda940(,%eax,8),%eax
80102b76:	c3                   	ret    
80102b77:	66 90                	xchg   %ax,%ax
80102b79:	66 90                	xchg   %ax,%ax
80102b7b:	66 90                	xchg   %ax,%ax
80102b7d:	66 90                	xchg   %ax,%ax
80102b7f:	90                   	nop

80102b80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b80:	ba 64 00 00 00       	mov    $0x64,%edx
80102b85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b86:	a8 01                	test   $0x1,%al
80102b88:	0f 84 c2 00 00 00    	je     80102c50 <kbdgetc+0xd0>
80102b8e:	ba 60 00 00 00       	mov    $0x60,%edx
80102b93:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102b94:	0f b6 d0             	movzbl %al,%edx
80102b97:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102b9d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102ba3:	0f 84 7f 00 00 00    	je     80102c28 <kbdgetc+0xa8>
{
80102ba9:	55                   	push   %ebp
80102baa:	89 e5                	mov    %esp,%ebp
80102bac:	53                   	push   %ebx
80102bad:	89 cb                	mov    %ecx,%ebx
80102baf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102bb2:	84 c0                	test   %al,%al
80102bb4:	78 4a                	js     80102c00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102bb6:	85 db                	test   %ebx,%ebx
80102bb8:	74 09                	je     80102bc3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102bba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bbd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102bc0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102bc3:	0f b6 82 60 83 10 80 	movzbl -0x7fef7ca0(%edx),%eax
80102bca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102bcc:	0f b6 82 60 82 10 80 	movzbl -0x7fef7da0(%edx),%eax
80102bd3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bd5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bd7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bdd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102be0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102be3:	8b 04 85 40 82 10 80 	mov    -0x7fef7dc0(,%eax,4),%eax
80102bea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bee:	74 31                	je     80102c21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102bf0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102bf3:	83 fa 19             	cmp    $0x19,%edx
80102bf6:	77 40                	ja     80102c38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102bf8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102bfb:	5b                   	pop    %ebx
80102bfc:	5d                   	pop    %ebp
80102bfd:	c3                   	ret    
80102bfe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102c00:	83 e0 7f             	and    $0x7f,%eax
80102c03:	85 db                	test   %ebx,%ebx
80102c05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102c08:	0f b6 82 60 83 10 80 	movzbl -0x7fef7ca0(%edx),%eax
80102c0f:	83 c8 40             	or     $0x40,%eax
80102c12:	0f b6 c0             	movzbl %al,%eax
80102c15:	f7 d0                	not    %eax
80102c17:	21 c1                	and    %eax,%ecx
    return 0;
80102c19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c1b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102c21:	5b                   	pop    %ebx
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102c28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102c2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c2d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102c3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102c42:	0f 42 c2             	cmovb  %edx,%eax
}
80102c45:	5d                   	pop    %ebp
80102c46:	c3                   	ret    
80102c47:	89 f6                	mov    %esi,%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c55:	c3                   	ret    
80102c56:	8d 76 00             	lea    0x0(%esi),%esi
80102c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c60 <kbdintr>:

void
kbdintr(void)
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c66:	68 80 2b 10 80       	push   $0x80102b80
80102c6b:	e8 a0 db ff ff       	call   80100810 <consoleintr>
}
80102c70:	83 c4 10             	add    $0x10,%esp
80102c73:	c9                   	leave  
80102c74:	c3                   	ret    
80102c75:	66 90                	xchg   %ax,%ax
80102c77:	66 90                	xchg   %ax,%ax
80102c79:	66 90                	xchg   %ax,%ax
80102c7b:	66 90                	xchg   %ax,%ax
80102c7d:	66 90                	xchg   %ax,%ax
80102c7f:	90                   	nop

80102c80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c80:	a1 bc 56 19 80       	mov    0x801956bc,%eax
{
80102c85:	55                   	push   %ebp
80102c86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102c88:	85 c0                	test   %eax,%eax
80102c8a:	0f 84 c8 00 00 00    	je     80102d58 <lapicinit+0xd8>
  lapic[index] = value;
80102c90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ca4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102caa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102cb1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102cbe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cc1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ccb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cd1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cd8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cdb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cde:	8b 50 30             	mov    0x30(%eax),%edx
80102ce1:	c1 ea 10             	shr    $0x10,%edx
80102ce4:	80 fa 03             	cmp    $0x3,%dl
80102ce7:	77 77                	ja     80102d60 <lapicinit+0xe0>
  lapic[index] = value;
80102ce9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102cf0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cfd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102d0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d34:	8b 50 20             	mov    0x20(%eax),%edx
80102d37:	89 f6                	mov    %esi,%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d46:	80 e6 10             	and    $0x10,%dh
80102d49:	75 f5                	jne    80102d40 <lapicinit+0xc0>
  lapic[index] = value;
80102d4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d58:	5d                   	pop    %ebp
80102d59:	c3                   	ret    
80102d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102d60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d6a:	8b 50 20             	mov    0x20(%eax),%edx
80102d6d:	e9 77 ff ff ff       	jmp    80102ce9 <lapicinit+0x69>
80102d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d80:	8b 15 bc 56 19 80    	mov    0x801956bc,%edx
{
80102d86:	55                   	push   %ebp
80102d87:	31 c0                	xor    %eax,%eax
80102d89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102d8b:	85 d2                	test   %edx,%edx
80102d8d:	74 06                	je     80102d95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102d8f:	8b 42 20             	mov    0x20(%edx),%eax
80102d92:	c1 e8 18             	shr    $0x18,%eax
}
80102d95:	5d                   	pop    %ebp
80102d96:	c3                   	ret    
80102d97:	89 f6                	mov    %esi,%esi
80102d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102da0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102da0:	a1 bc 56 19 80       	mov    0x801956bc,%eax
{
80102da5:	55                   	push   %ebp
80102da6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102da8:	85 c0                	test   %eax,%eax
80102daa:	74 0d                	je     80102db9 <lapiceoi+0x19>
  lapic[index] = value;
80102dac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102db3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102db6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102db9:	5d                   	pop    %ebp
80102dba:	c3                   	ret    
80102dbb:	90                   	nop
80102dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102dc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
}
80102dc3:	5d                   	pop    %ebp
80102dc4:	c3                   	ret    
80102dc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102dd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102dd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102ddb:	89 e5                	mov    %esp,%ebp
80102ddd:	53                   	push   %ebx
80102dde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102de1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102de4:	ee                   	out    %al,(%dx)
80102de5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dea:	ba 71 00 00 00       	mov    $0x71,%edx
80102def:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102df0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102df2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102df5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102dfb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102dfd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102e00:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102e03:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102e05:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102e08:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102e0e:	a1 bc 56 19 80       	mov    0x801956bc,%eax
80102e13:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e19:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e1c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e23:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e26:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e29:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e30:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e33:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e36:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e3c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e3f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e45:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e48:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e4e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e51:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e57:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e5a:	5b                   	pop    %ebx
80102e5b:	5d                   	pop    %ebp
80102e5c:	c3                   	ret    
80102e5d:	8d 76 00             	lea    0x0(%esi),%esi

80102e60 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e60:	55                   	push   %ebp
80102e61:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e66:	ba 70 00 00 00       	mov    $0x70,%edx
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	57                   	push   %edi
80102e6e:	56                   	push   %esi
80102e6f:	53                   	push   %ebx
80102e70:	83 ec 4c             	sub    $0x4c,%esp
80102e73:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e74:	ba 71 00 00 00       	mov    $0x71,%edx
80102e79:	ec                   	in     (%dx),%al
80102e7a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e7d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e82:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
80102e88:	31 c0                	xor    %eax,%eax
80102e8a:	89 da                	mov    %ebx,%edx
80102e8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e8d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e92:	89 ca                	mov    %ecx,%edx
80102e94:	ec                   	in     (%dx),%al
80102e95:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e98:	89 da                	mov    %ebx,%edx
80102e9a:	b8 02 00 00 00       	mov    $0x2,%eax
80102e9f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ea0:	89 ca                	mov    %ecx,%edx
80102ea2:	ec                   	in     (%dx),%al
80102ea3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea6:	89 da                	mov    %ebx,%edx
80102ea8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ead:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eae:	89 ca                	mov    %ecx,%edx
80102eb0:	ec                   	in     (%dx),%al
80102eb1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb4:	89 da                	mov    %ebx,%edx
80102eb6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ebb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ebc:	89 ca                	mov    %ecx,%edx
80102ebe:	ec                   	in     (%dx),%al
80102ebf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ec2:	89 da                	mov    %ebx,%edx
80102ec4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ec9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eca:	89 ca                	mov    %ecx,%edx
80102ecc:	ec                   	in     (%dx),%al
80102ecd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ecf:	89 da                	mov    %ebx,%edx
80102ed1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ed6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed7:	89 ca                	mov    %ecx,%edx
80102ed9:	ec                   	in     (%dx),%al
80102eda:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102edc:	89 da                	mov    %ebx,%edx
80102ede:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ee3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee4:	89 ca                	mov    %ecx,%edx
80102ee6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ee7:	84 c0                	test   %al,%al
80102ee9:	78 9d                	js     80102e88 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102eeb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102eef:	89 fa                	mov    %edi,%edx
80102ef1:	0f b6 fa             	movzbl %dl,%edi
80102ef4:	89 f2                	mov    %esi,%edx
80102ef6:	0f b6 f2             	movzbl %dl,%esi
80102ef9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102efc:	89 da                	mov    %ebx,%edx
80102efe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102f01:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102f04:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102f08:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102f0b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102f0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f12:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f19:	31 c0                	xor    %eax,%eax
80102f1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f1c:	89 ca                	mov    %ecx,%edx
80102f1e:	ec                   	in     (%dx),%al
80102f1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f22:	89 da                	mov    %ebx,%edx
80102f24:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f27:	b8 02 00 00 00       	mov    $0x2,%eax
80102f2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2d:	89 ca                	mov    %ecx,%edx
80102f2f:	ec                   	in     (%dx),%al
80102f30:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f33:	89 da                	mov    %ebx,%edx
80102f35:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f38:	b8 04 00 00 00       	mov    $0x4,%eax
80102f3d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f3e:	89 ca                	mov    %ecx,%edx
80102f40:	ec                   	in     (%dx),%al
80102f41:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f44:	89 da                	mov    %ebx,%edx
80102f46:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f49:	b8 07 00 00 00       	mov    $0x7,%eax
80102f4e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f4f:	89 ca                	mov    %ecx,%edx
80102f51:	ec                   	in     (%dx),%al
80102f52:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f55:	89 da                	mov    %ebx,%edx
80102f57:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f5a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f60:	89 ca                	mov    %ecx,%edx
80102f62:	ec                   	in     (%dx),%al
80102f63:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f66:	89 da                	mov    %ebx,%edx
80102f68:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f6b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f70:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f71:	89 ca                	mov    %ecx,%edx
80102f73:	ec                   	in     (%dx),%al
80102f74:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f77:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f7d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f80:	6a 18                	push   $0x18
80102f82:	50                   	push   %eax
80102f83:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f86:	50                   	push   %eax
80102f87:	e8 94 1d 00 00       	call   80104d20 <memcmp>
80102f8c:	83 c4 10             	add    $0x10,%esp
80102f8f:	85 c0                	test   %eax,%eax
80102f91:	0f 85 f1 fe ff ff    	jne    80102e88 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102f97:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f9b:	75 78                	jne    80103015 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f9d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102fa0:	89 c2                	mov    %eax,%edx
80102fa2:	83 e0 0f             	and    $0xf,%eax
80102fa5:	c1 ea 04             	shr    $0x4,%edx
80102fa8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fb1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fb4:	89 c2                	mov    %eax,%edx
80102fb6:	83 e0 0f             	and    $0xf,%eax
80102fb9:	c1 ea 04             	shr    $0x4,%edx
80102fbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fc2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fc5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fc8:	89 c2                	mov    %eax,%edx
80102fca:	83 e0 0f             	and    $0xf,%eax
80102fcd:	c1 ea 04             	shr    $0x4,%edx
80102fd0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fd3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fd6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fdc:	89 c2                	mov    %eax,%edx
80102fde:	83 e0 0f             	and    $0xf,%eax
80102fe1:	c1 ea 04             	shr    $0x4,%edx
80102fe4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fe7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fed:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ff0:	89 c2                	mov    %eax,%edx
80102ff2:	83 e0 0f             	and    $0xf,%eax
80102ff5:	c1 ea 04             	shr    $0x4,%edx
80102ff8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ffb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ffe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103001:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103004:	89 c2                	mov    %eax,%edx
80103006:	83 e0 0f             	and    $0xf,%eax
80103009:	c1 ea 04             	shr    $0x4,%edx
8010300c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010300f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103012:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103015:	8b 75 08             	mov    0x8(%ebp),%esi
80103018:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010301b:	89 06                	mov    %eax,(%esi)
8010301d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103020:	89 46 04             	mov    %eax,0x4(%esi)
80103023:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103026:	89 46 08             	mov    %eax,0x8(%esi)
80103029:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010302c:	89 46 0c             	mov    %eax,0xc(%esi)
8010302f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103032:	89 46 10             	mov    %eax,0x10(%esi)
80103035:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103038:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010303b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103042:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103045:	5b                   	pop    %ebx
80103046:	5e                   	pop    %esi
80103047:	5f                   	pop    %edi
80103048:	5d                   	pop    %ebp
80103049:	c3                   	ret    
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103050:	8b 0d 08 57 19 80    	mov    0x80195708,%ecx
80103056:	85 c9                	test   %ecx,%ecx
80103058:	0f 8e 8a 00 00 00    	jle    801030e8 <install_trans+0x98>
{
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	57                   	push   %edi
80103062:	56                   	push   %esi
80103063:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103064:	31 db                	xor    %ebx,%ebx
{
80103066:	83 ec 0c             	sub    $0xc,%esp
80103069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103070:	a1 f4 56 19 80       	mov    0x801956f4,%eax
80103075:	83 ec 08             	sub    $0x8,%esp
80103078:	01 d8                	add    %ebx,%eax
8010307a:	83 c0 01             	add    $0x1,%eax
8010307d:	50                   	push   %eax
8010307e:	ff 35 04 57 19 80    	pushl  0x80195704
80103084:	e8 47 d0 ff ff       	call   801000d0 <bread>
80103089:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010308b:	58                   	pop    %eax
8010308c:	5a                   	pop    %edx
8010308d:	ff 34 9d 0c 57 19 80 	pushl  -0x7fe6a8f4(,%ebx,4)
80103094:	ff 35 04 57 19 80    	pushl  0x80195704
  for (tail = 0; tail < log.lh.n; tail++) {
8010309a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010309d:	e8 2e d0 ff ff       	call   801000d0 <bread>
801030a2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030a4:	8d 47 5c             	lea    0x5c(%edi),%eax
801030a7:	83 c4 0c             	add    $0xc,%esp
801030aa:	68 00 02 00 00       	push   $0x200
801030af:	50                   	push   %eax
801030b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030b3:	50                   	push   %eax
801030b4:	e8 c7 1c 00 00       	call   80104d80 <memmove>
    bwrite(dbuf);  // write dst to disk
801030b9:	89 34 24             	mov    %esi,(%esp)
801030bc:	e8 df d0 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801030c1:	89 3c 24             	mov    %edi,(%esp)
801030c4:	e8 17 d1 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801030c9:	89 34 24             	mov    %esi,(%esp)
801030cc:	e8 0f d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030d1:	83 c4 10             	add    $0x10,%esp
801030d4:	39 1d 08 57 19 80    	cmp    %ebx,0x80195708
801030da:	7f 94                	jg     80103070 <install_trans+0x20>
  }
}
801030dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    
801030e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030e8:	f3 c3                	repz ret 
801030ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	56                   	push   %esi
801030f4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801030f5:	83 ec 08             	sub    $0x8,%esp
801030f8:	ff 35 f4 56 19 80    	pushl  0x801956f4
801030fe:	ff 35 04 57 19 80    	pushl  0x80195704
80103104:	e8 c7 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103109:	8b 1d 08 57 19 80    	mov    0x80195708,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010310f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103112:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103114:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103116:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103119:	7e 16                	jle    80103131 <write_head+0x41>
8010311b:	c1 e3 02             	shl    $0x2,%ebx
8010311e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103120:	8b 8a 0c 57 19 80    	mov    -0x7fe6a8f4(%edx),%ecx
80103126:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010312a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010312d:	39 da                	cmp    %ebx,%edx
8010312f:	75 ef                	jne    80103120 <write_head+0x30>
  }
  bwrite(buf);
80103131:	83 ec 0c             	sub    $0xc,%esp
80103134:	56                   	push   %esi
80103135:	e8 66 d0 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010313a:	89 34 24             	mov    %esi,(%esp)
8010313d:	e8 9e d0 ff ff       	call   801001e0 <brelse>
}
80103142:	83 c4 10             	add    $0x10,%esp
80103145:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103148:	5b                   	pop    %ebx
80103149:	5e                   	pop    %esi
8010314a:	5d                   	pop    %ebp
8010314b:	c3                   	ret    
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103150 <initlog>:
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	53                   	push   %ebx
80103154:	83 ec 2c             	sub    $0x2c,%esp
80103157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010315a:	68 60 84 10 80       	push   $0x80108460
8010315f:	68 c0 56 19 80       	push   $0x801956c0
80103164:	e8 17 19 00 00       	call   80104a80 <initlock>
  readsb(dev, &sb);
80103169:	58                   	pop    %eax
8010316a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010316d:	5a                   	pop    %edx
8010316e:	50                   	push   %eax
8010316f:	53                   	push   %ebx
80103170:	e8 0b e3 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
80103175:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010317b:	59                   	pop    %ecx
  log.dev = dev;
8010317c:	89 1d 04 57 19 80    	mov    %ebx,0x80195704
  log.size = sb.nlog;
80103182:	89 15 f8 56 19 80    	mov    %edx,0x801956f8
  log.start = sb.logstart;
80103188:	a3 f4 56 19 80       	mov    %eax,0x801956f4
  struct buf *buf = bread(log.dev, log.start);
8010318d:	5a                   	pop    %edx
8010318e:	50                   	push   %eax
8010318f:	53                   	push   %ebx
80103190:	e8 3b cf ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103195:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103198:	83 c4 10             	add    $0x10,%esp
8010319b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010319d:	89 1d 08 57 19 80    	mov    %ebx,0x80195708
  for (i = 0; i < log.lh.n; i++) {
801031a3:	7e 1c                	jle    801031c1 <initlog+0x71>
801031a5:	c1 e3 02             	shl    $0x2,%ebx
801031a8:	31 d2                	xor    %edx,%edx
801031aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801031b0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801031b4:	83 c2 04             	add    $0x4,%edx
801031b7:	89 8a 08 57 19 80    	mov    %ecx,-0x7fe6a8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
801031bd:	39 d3                	cmp    %edx,%ebx
801031bf:	75 ef                	jne    801031b0 <initlog+0x60>
  brelse(buf);
801031c1:	83 ec 0c             	sub    $0xc,%esp
801031c4:	50                   	push   %eax
801031c5:	e8 16 d0 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031ca:	e8 81 fe ff ff       	call   80103050 <install_trans>
  log.lh.n = 0;
801031cf:	c7 05 08 57 19 80 00 	movl   $0x0,0x80195708
801031d6:	00 00 00 
  write_head(); // clear the log
801031d9:	e8 12 ff ff ff       	call   801030f0 <write_head>
}
801031de:	83 c4 10             	add    $0x10,%esp
801031e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031e4:	c9                   	leave  
801031e5:	c3                   	ret    
801031e6:	8d 76 00             	lea    0x0(%esi),%esi
801031e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031f6:	68 c0 56 19 80       	push   $0x801956c0
801031fb:	e8 c0 19 00 00       	call   80104bc0 <acquire>
80103200:	83 c4 10             	add    $0x10,%esp
80103203:	eb 18                	jmp    8010321d <begin_op+0x2d>
80103205:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103208:	83 ec 08             	sub    $0x8,%esp
8010320b:	68 c0 56 19 80       	push   $0x801956c0
80103210:	68 c0 56 19 80       	push   $0x801956c0
80103215:	e8 76 13 00 00       	call   80104590 <sleep>
8010321a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010321d:	a1 00 57 19 80       	mov    0x80195700,%eax
80103222:	85 c0                	test   %eax,%eax
80103224:	75 e2                	jne    80103208 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103226:	a1 fc 56 19 80       	mov    0x801956fc,%eax
8010322b:	8b 15 08 57 19 80    	mov    0x80195708,%edx
80103231:	83 c0 01             	add    $0x1,%eax
80103234:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103237:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010323a:	83 fa 1e             	cmp    $0x1e,%edx
8010323d:	7f c9                	jg     80103208 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010323f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103242:	a3 fc 56 19 80       	mov    %eax,0x801956fc
      release(&log.lock);
80103247:	68 c0 56 19 80       	push   $0x801956c0
8010324c:	e8 2f 1a 00 00       	call   80104c80 <release>
      break;
    }
  }
}
80103251:	83 c4 10             	add    $0x10,%esp
80103254:	c9                   	leave  
80103255:	c3                   	ret    
80103256:	8d 76 00             	lea    0x0(%esi),%esi
80103259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103260 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103260:	55                   	push   %ebp
80103261:	89 e5                	mov    %esp,%ebp
80103263:	57                   	push   %edi
80103264:	56                   	push   %esi
80103265:	53                   	push   %ebx
80103266:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103269:	68 c0 56 19 80       	push   $0x801956c0
8010326e:	e8 4d 19 00 00       	call   80104bc0 <acquire>
  log.outstanding -= 1;
80103273:	a1 fc 56 19 80       	mov    0x801956fc,%eax
  if(log.committing)
80103278:	8b 35 00 57 19 80    	mov    0x80195700,%esi
8010327e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103281:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103284:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103286:	89 1d fc 56 19 80    	mov    %ebx,0x801956fc
  if(log.committing)
8010328c:	0f 85 1a 01 00 00    	jne    801033ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103292:	85 db                	test   %ebx,%ebx
80103294:	0f 85 ee 00 00 00    	jne    80103388 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010329a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010329d:	c7 05 00 57 19 80 01 	movl   $0x1,0x80195700
801032a4:	00 00 00 
  release(&log.lock);
801032a7:	68 c0 56 19 80       	push   $0x801956c0
801032ac:	e8 cf 19 00 00       	call   80104c80 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032b1:	8b 0d 08 57 19 80    	mov    0x80195708,%ecx
801032b7:	83 c4 10             	add    $0x10,%esp
801032ba:	85 c9                	test   %ecx,%ecx
801032bc:	0f 8e 85 00 00 00    	jle    80103347 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032c2:	a1 f4 56 19 80       	mov    0x801956f4,%eax
801032c7:	83 ec 08             	sub    $0x8,%esp
801032ca:	01 d8                	add    %ebx,%eax
801032cc:	83 c0 01             	add    $0x1,%eax
801032cf:	50                   	push   %eax
801032d0:	ff 35 04 57 19 80    	pushl  0x80195704
801032d6:	e8 f5 cd ff ff       	call   801000d0 <bread>
801032db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032dd:	58                   	pop    %eax
801032de:	5a                   	pop    %edx
801032df:	ff 34 9d 0c 57 19 80 	pushl  -0x7fe6a8f4(,%ebx,4)
801032e6:	ff 35 04 57 19 80    	pushl  0x80195704
  for (tail = 0; tail < log.lh.n; tail++) {
801032ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032ef:	e8 dc cd ff ff       	call   801000d0 <bread>
801032f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801032f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801032f9:	83 c4 0c             	add    $0xc,%esp
801032fc:	68 00 02 00 00       	push   $0x200
80103301:	50                   	push   %eax
80103302:	8d 46 5c             	lea    0x5c(%esi),%eax
80103305:	50                   	push   %eax
80103306:	e8 75 1a 00 00       	call   80104d80 <memmove>
    bwrite(to);  // write the log
8010330b:	89 34 24             	mov    %esi,(%esp)
8010330e:	e8 8d ce ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103313:	89 3c 24             	mov    %edi,(%esp)
80103316:	e8 c5 ce ff ff       	call   801001e0 <brelse>
    brelse(to);
8010331b:	89 34 24             	mov    %esi,(%esp)
8010331e:	e8 bd ce ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103323:	83 c4 10             	add    $0x10,%esp
80103326:	3b 1d 08 57 19 80    	cmp    0x80195708,%ebx
8010332c:	7c 94                	jl     801032c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010332e:	e8 bd fd ff ff       	call   801030f0 <write_head>
    install_trans(); // Now install writes to home locations
80103333:	e8 18 fd ff ff       	call   80103050 <install_trans>
    log.lh.n = 0;
80103338:	c7 05 08 57 19 80 00 	movl   $0x0,0x80195708
8010333f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103342:	e8 a9 fd ff ff       	call   801030f0 <write_head>
    acquire(&log.lock);
80103347:	83 ec 0c             	sub    $0xc,%esp
8010334a:	68 c0 56 19 80       	push   $0x801956c0
8010334f:	e8 6c 18 00 00       	call   80104bc0 <acquire>
    wakeup(&log);
80103354:	c7 04 24 c0 56 19 80 	movl   $0x801956c0,(%esp)
    log.committing = 0;
8010335b:	c7 05 00 57 19 80 00 	movl   $0x0,0x80195700
80103362:	00 00 00 
    wakeup(&log);
80103365:	e8 16 14 00 00       	call   80104780 <wakeup>
    release(&log.lock);
8010336a:	c7 04 24 c0 56 19 80 	movl   $0x801956c0,(%esp)
80103371:	e8 0a 19 00 00       	call   80104c80 <release>
80103376:	83 c4 10             	add    $0x10,%esp
}
80103379:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010337c:	5b                   	pop    %ebx
8010337d:	5e                   	pop    %esi
8010337e:	5f                   	pop    %edi
8010337f:	5d                   	pop    %ebp
80103380:	c3                   	ret    
80103381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103388:	83 ec 0c             	sub    $0xc,%esp
8010338b:	68 c0 56 19 80       	push   $0x801956c0
80103390:	e8 eb 13 00 00       	call   80104780 <wakeup>
  release(&log.lock);
80103395:	c7 04 24 c0 56 19 80 	movl   $0x801956c0,(%esp)
8010339c:	e8 df 18 00 00       	call   80104c80 <release>
801033a1:	83 c4 10             	add    $0x10,%esp
}
801033a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a7:	5b                   	pop    %ebx
801033a8:	5e                   	pop    %esi
801033a9:	5f                   	pop    %edi
801033aa:	5d                   	pop    %ebp
801033ab:	c3                   	ret    
    panic("log.committing");
801033ac:	83 ec 0c             	sub    $0xc,%esp
801033af:	68 64 84 10 80       	push   $0x80108464
801033b4:	e8 d7 cf ff ff       	call   80100390 <panic>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	53                   	push   %ebx
801033c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033c7:	8b 15 08 57 19 80    	mov    0x80195708,%edx
{
801033cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033d0:	83 fa 1d             	cmp    $0x1d,%edx
801033d3:	0f 8f 9d 00 00 00    	jg     80103476 <log_write+0xb6>
801033d9:	a1 f8 56 19 80       	mov    0x801956f8,%eax
801033de:	83 e8 01             	sub    $0x1,%eax
801033e1:	39 c2                	cmp    %eax,%edx
801033e3:	0f 8d 8d 00 00 00    	jge    80103476 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033e9:	a1 fc 56 19 80       	mov    0x801956fc,%eax
801033ee:	85 c0                	test   %eax,%eax
801033f0:	0f 8e 8d 00 00 00    	jle    80103483 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033f6:	83 ec 0c             	sub    $0xc,%esp
801033f9:	68 c0 56 19 80       	push   $0x801956c0
801033fe:	e8 bd 17 00 00       	call   80104bc0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103403:	8b 0d 08 57 19 80    	mov    0x80195708,%ecx
80103409:	83 c4 10             	add    $0x10,%esp
8010340c:	83 f9 00             	cmp    $0x0,%ecx
8010340f:	7e 57                	jle    80103468 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103411:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103414:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103416:	3b 15 0c 57 19 80    	cmp    0x8019570c,%edx
8010341c:	75 0b                	jne    80103429 <log_write+0x69>
8010341e:	eb 38                	jmp    80103458 <log_write+0x98>
80103420:	39 14 85 0c 57 19 80 	cmp    %edx,-0x7fe6a8f4(,%eax,4)
80103427:	74 2f                	je     80103458 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103429:	83 c0 01             	add    $0x1,%eax
8010342c:	39 c1                	cmp    %eax,%ecx
8010342e:	75 f0                	jne    80103420 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103430:	89 14 85 0c 57 19 80 	mov    %edx,-0x7fe6a8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103437:	83 c0 01             	add    $0x1,%eax
8010343a:	a3 08 57 19 80       	mov    %eax,0x80195708
  b->flags |= B_DIRTY; // prevent eviction
8010343f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103442:	c7 45 08 c0 56 19 80 	movl   $0x801956c0,0x8(%ebp)
}
80103449:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010344c:	c9                   	leave  
  release(&log.lock);
8010344d:	e9 2e 18 00 00       	jmp    80104c80 <release>
80103452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103458:	89 14 85 0c 57 19 80 	mov    %edx,-0x7fe6a8f4(,%eax,4)
8010345f:	eb de                	jmp    8010343f <log_write+0x7f>
80103461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103468:	8b 43 08             	mov    0x8(%ebx),%eax
8010346b:	a3 0c 57 19 80       	mov    %eax,0x8019570c
  if (i == log.lh.n)
80103470:	75 cd                	jne    8010343f <log_write+0x7f>
80103472:	31 c0                	xor    %eax,%eax
80103474:	eb c1                	jmp    80103437 <log_write+0x77>
    panic("too big a transaction");
80103476:	83 ec 0c             	sub    $0xc,%esp
80103479:	68 73 84 10 80       	push   $0x80108473
8010347e:	e8 0d cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103483:	83 ec 0c             	sub    $0xc,%esp
80103486:	68 89 84 10 80       	push   $0x80108489
8010348b:	e8 00 cf ff ff       	call   80100390 <panic>

80103490 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	53                   	push   %ebx
80103494:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103497:	e8 14 0a 00 00       	call   80103eb0 <cpuid>
8010349c:	89 c3                	mov    %eax,%ebx
8010349e:	e8 0d 0a 00 00       	call   80103eb0 <cpuid>
801034a3:	83 ec 04             	sub    $0x4,%esp
801034a6:	53                   	push   %ebx
801034a7:	50                   	push   %eax
801034a8:	68 a4 84 10 80       	push   $0x801084a4
801034ad:	e8 ae d1 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801034b2:	e8 09 2b 00 00       	call   80105fc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034b7:	e8 74 09 00 00       	call   80103e30 <mycpu>
801034bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034be:	b8 01 00 00 00       	mov    $0x1,%eax
801034c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034ca:	e8 c1 0d 00 00       	call   80104290 <scheduler>
801034cf:	90                   	nop

801034d0 <mpenter>:
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034d6:	e8 45 3b 00 00       	call   80107020 <switchkvm>
  seginit();
801034db:	e8 b0 3a 00 00       	call   80106f90 <seginit>
  lapicinit();
801034e0:	e8 9b f7 ff ff       	call   80102c80 <lapicinit>
  mpmain();
801034e5:	e8 a6 ff ff ff       	call   80103490 <mpmain>
801034ea:	66 90                	xchg   %ax,%ax
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <main>:
{
801034f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034f4:	83 e4 f0             	and    $0xfffffff0,%esp
801034f7:	ff 71 fc             	pushl  -0x4(%ecx)
801034fa:	55                   	push   %ebp
801034fb:	89 e5                	mov    %esp,%ebp
801034fd:	53                   	push   %ebx
801034fe:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034ff:	83 ec 08             	sub    $0x8,%esp
80103502:	68 00 00 40 80       	push   $0x80400000
80103507:	68 e8 09 1a 80       	push   $0x801a09e8
8010350c:	e8 ef f3 ff ff       	call   80102900 <kinit1>
  kvmalloc();      // kernel page table
80103511:	e8 2a 43 00 00       	call   80107840 <kvmalloc>
  mpinit();        // detect other processors
80103516:	e8 75 01 00 00       	call   80103690 <mpinit>
  lapicinit();     // interrupt controller
8010351b:	e8 60 f7 ff ff       	call   80102c80 <lapicinit>
  seginit();       // segment descriptors
80103520:	e8 6b 3a 00 00       	call   80106f90 <seginit>
  picinit();       // disable pic
80103525:	e8 46 03 00 00       	call   80103870 <picinit>
  ioapicinit();    // another interrupt controller
8010352a:	e8 d1 f0 ff ff       	call   80102600 <ioapicinit>
  consoleinit();   // console hardware
8010352f:	e8 8c d4 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103534:	e8 c7 2d 00 00       	call   80106300 <uartinit>
  pinit();         // process table
80103539:	e8 d2 08 00 00       	call   80103e10 <pinit>
  tvinit();        // trap vectors
8010353e:	e8 fd 29 00 00       	call   80105f40 <tvinit>
  binit();         // buffer cache
80103543:	e8 f8 ca ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103548:	e8 53 d8 ff ff       	call   80100da0 <fileinit>
  ideinit();       // disk 
8010354d:	e8 8e ee ff ff       	call   801023e0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103552:	83 c4 0c             	add    $0xc,%esp
80103555:	68 8a 00 00 00       	push   $0x8a
8010355a:	68 8c b4 10 80       	push   $0x8010b48c
8010355f:	68 00 70 00 80       	push   $0x80007000
80103564:	e8 17 18 00 00       	call   80104d80 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103569:	69 05 40 5d 19 80 b0 	imul   $0xb0,0x80195d40,%eax
80103570:	00 00 00 
80103573:	83 c4 10             	add    $0x10,%esp
80103576:	05 c0 57 19 80       	add    $0x801957c0,%eax
8010357b:	3d c0 57 19 80       	cmp    $0x801957c0,%eax
80103580:	76 71                	jbe    801035f3 <main+0x103>
80103582:	bb c0 57 19 80       	mov    $0x801957c0,%ebx
80103587:	89 f6                	mov    %esi,%esi
80103589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103590:	e8 9b 08 00 00       	call   80103e30 <mycpu>
80103595:	39 d8                	cmp    %ebx,%eax
80103597:	74 41                	je     801035da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103599:	e8 32 f4 ff ff       	call   801029d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010359e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801035a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801034d0,0x80006ff8
801035aa:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801035ad:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035b4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801035bc:	0f b6 03             	movzbl (%ebx),%eax
801035bf:	83 ec 08             	sub    $0x8,%esp
801035c2:	68 00 70 00 00       	push   $0x7000
801035c7:	50                   	push   %eax
801035c8:	e8 03 f8 ff ff       	call   80102dd0 <lapicstartap>
801035cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801035d6:	85 c0                	test   %eax,%eax
801035d8:	74 f6                	je     801035d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801035da:	69 05 40 5d 19 80 b0 	imul   $0xb0,0x80195d40,%eax
801035e1:	00 00 00 
801035e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035ea:	05 c0 57 19 80       	add    $0x801957c0,%eax
801035ef:	39 c3                	cmp    %eax,%ebx
801035f1:	72 9d                	jb     80103590 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035f3:	83 ec 08             	sub    $0x8,%esp
801035f6:	68 00 00 00 8e       	push   $0x8e000000
801035fb:	68 00 00 40 80       	push   $0x80400000
80103600:	e8 6b f3 ff ff       	call   80102970 <kinit2>
  userinit();      // first user process
80103605:	e8 f6 08 00 00       	call   80103f00 <userinit>
  mpmain();        // finish this processor's setup
8010360a:	e8 81 fe ff ff       	call   80103490 <mpmain>
8010360f:	90                   	nop

80103610 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103615:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010361b:	53                   	push   %ebx
  e = addr+len;
8010361c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010361f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103622:	39 de                	cmp    %ebx,%esi
80103624:	72 10                	jb     80103636 <mpsearch1+0x26>
80103626:	eb 50                	jmp    80103678 <mpsearch1+0x68>
80103628:	90                   	nop
80103629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103630:	39 fb                	cmp    %edi,%ebx
80103632:	89 fe                	mov    %edi,%esi
80103634:	76 42                	jbe    80103678 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103636:	83 ec 04             	sub    $0x4,%esp
80103639:	8d 7e 10             	lea    0x10(%esi),%edi
8010363c:	6a 04                	push   $0x4
8010363e:	68 b8 84 10 80       	push   $0x801084b8
80103643:	56                   	push   %esi
80103644:	e8 d7 16 00 00       	call   80104d20 <memcmp>
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	85 c0                	test   %eax,%eax
8010364e:	75 e0                	jne    80103630 <mpsearch1+0x20>
80103650:	89 f1                	mov    %esi,%ecx
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103658:	0f b6 11             	movzbl (%ecx),%edx
8010365b:	83 c1 01             	add    $0x1,%ecx
8010365e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103660:	39 f9                	cmp    %edi,%ecx
80103662:	75 f4                	jne    80103658 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103664:	84 c0                	test   %al,%al
80103666:	75 c8                	jne    80103630 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010366b:	89 f0                	mov    %esi,%eax
8010366d:	5b                   	pop    %ebx
8010366e:	5e                   	pop    %esi
8010366f:	5f                   	pop    %edi
80103670:	5d                   	pop    %ebp
80103671:	c3                   	ret    
80103672:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103678:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010367b:	31 f6                	xor    %esi,%esi
}
8010367d:	89 f0                	mov    %esi,%eax
8010367f:	5b                   	pop    %ebx
80103680:	5e                   	pop    %esi
80103681:	5f                   	pop    %edi
80103682:	5d                   	pop    %ebp
80103683:	c3                   	ret    
80103684:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010368a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103690 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	57                   	push   %edi
80103694:	56                   	push   %esi
80103695:	53                   	push   %ebx
80103696:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103699:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801036a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801036a7:	c1 e0 08             	shl    $0x8,%eax
801036aa:	09 d0                	or     %edx,%eax
801036ac:	c1 e0 04             	shl    $0x4,%eax
801036af:	85 c0                	test   %eax,%eax
801036b1:	75 1b                	jne    801036ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036c1:	c1 e0 08             	shl    $0x8,%eax
801036c4:	09 d0                	or     %edx,%eax
801036c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036ce:	ba 00 04 00 00       	mov    $0x400,%edx
801036d3:	e8 38 ff ff ff       	call   80103610 <mpsearch1>
801036d8:	85 c0                	test   %eax,%eax
801036da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036dd:	0f 84 3d 01 00 00    	je     80103820 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036e6:	8b 58 04             	mov    0x4(%eax),%ebx
801036e9:	85 db                	test   %ebx,%ebx
801036eb:	0f 84 4f 01 00 00    	je     80103840 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801036f7:	83 ec 04             	sub    $0x4,%esp
801036fa:	6a 04                	push   $0x4
801036fc:	68 d5 84 10 80       	push   $0x801084d5
80103701:	56                   	push   %esi
80103702:	e8 19 16 00 00       	call   80104d20 <memcmp>
80103707:	83 c4 10             	add    $0x10,%esp
8010370a:	85 c0                	test   %eax,%eax
8010370c:	0f 85 2e 01 00 00    	jne    80103840 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103712:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103719:	3c 01                	cmp    $0x1,%al
8010371b:	0f 95 c2             	setne  %dl
8010371e:	3c 04                	cmp    $0x4,%al
80103720:	0f 95 c0             	setne  %al
80103723:	20 c2                	and    %al,%dl
80103725:	0f 85 15 01 00 00    	jne    80103840 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010372b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103732:	66 85 ff             	test   %di,%di
80103735:	74 1a                	je     80103751 <mpinit+0xc1>
80103737:	89 f0                	mov    %esi,%eax
80103739:	01 f7                	add    %esi,%edi
  sum = 0;
8010373b:	31 d2                	xor    %edx,%edx
8010373d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103740:	0f b6 08             	movzbl (%eax),%ecx
80103743:	83 c0 01             	add    $0x1,%eax
80103746:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103748:	39 c7                	cmp    %eax,%edi
8010374a:	75 f4                	jne    80103740 <mpinit+0xb0>
8010374c:	84 d2                	test   %dl,%dl
8010374e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103751:	85 f6                	test   %esi,%esi
80103753:	0f 84 e7 00 00 00    	je     80103840 <mpinit+0x1b0>
80103759:	84 d2                	test   %dl,%dl
8010375b:	0f 85 df 00 00 00    	jne    80103840 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103761:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103767:	a3 bc 56 19 80       	mov    %eax,0x801956bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010376c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103773:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103779:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010377e:	01 d6                	add    %edx,%esi
80103780:	39 c6                	cmp    %eax,%esi
80103782:	76 23                	jbe    801037a7 <mpinit+0x117>
    switch(*p){
80103784:	0f b6 10             	movzbl (%eax),%edx
80103787:	80 fa 04             	cmp    $0x4,%dl
8010378a:	0f 87 ca 00 00 00    	ja     8010385a <mpinit+0x1ca>
80103790:	ff 24 95 fc 84 10 80 	jmp    *-0x7fef7b04(,%edx,4)
80103797:	89 f6                	mov    %esi,%esi
80103799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801037a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801037a3:	39 c6                	cmp    %eax,%esi
801037a5:	77 dd                	ja     80103784 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801037a7:	85 db                	test   %ebx,%ebx
801037a9:	0f 84 9e 00 00 00    	je     8010384d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801037af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801037b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801037b6:	74 15                	je     801037cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037b8:	b8 70 00 00 00       	mov    $0x70,%eax
801037bd:	ba 22 00 00 00       	mov    $0x22,%edx
801037c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037c3:	ba 23 00 00 00       	mov    $0x23,%edx
801037c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037cc:	ee                   	out    %al,(%dx)
  }
}
801037cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d0:	5b                   	pop    %ebx
801037d1:	5e                   	pop    %esi
801037d2:	5f                   	pop    %edi
801037d3:	5d                   	pop    %ebp
801037d4:	c3                   	ret    
801037d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801037d8:	8b 0d 40 5d 19 80    	mov    0x80195d40,%ecx
801037de:	83 f9 07             	cmp    $0x7,%ecx
801037e1:	7f 19                	jg     801037fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801037e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801037ed:	83 c1 01             	add    $0x1,%ecx
801037f0:	89 0d 40 5d 19 80    	mov    %ecx,0x80195d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037f6:	88 97 c0 57 19 80    	mov    %dl,-0x7fe6a840(%edi)
      p += sizeof(struct mpproc);
801037fc:	83 c0 14             	add    $0x14,%eax
      continue;
801037ff:	e9 7c ff ff ff       	jmp    80103780 <mpinit+0xf0>
80103804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103808:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010380c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010380f:	88 15 a0 57 19 80    	mov    %dl,0x801957a0
      continue;
80103815:	e9 66 ff ff ff       	jmp    80103780 <mpinit+0xf0>
8010381a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103820:	ba 00 00 01 00       	mov    $0x10000,%edx
80103825:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010382a:	e8 e1 fd ff ff       	call   80103610 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010382f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103831:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103834:	0f 85 a9 fe ff ff    	jne    801036e3 <mpinit+0x53>
8010383a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103840:	83 ec 0c             	sub    $0xc,%esp
80103843:	68 bd 84 10 80       	push   $0x801084bd
80103848:	e8 43 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 dc 84 10 80       	push   $0x801084dc
80103855:	e8 36 cb ff ff       	call   80100390 <panic>
      ismp = 0;
8010385a:	31 db                	xor    %ebx,%ebx
8010385c:	e9 26 ff ff ff       	jmp    80103787 <mpinit+0xf7>
80103861:	66 90                	xchg   %ax,%ax
80103863:	66 90                	xchg   %ax,%ax
80103865:	66 90                	xchg   %ax,%ax
80103867:	66 90                	xchg   %ax,%ax
80103869:	66 90                	xchg   %ax,%ax
8010386b:	66 90                	xchg   %ax,%ax
8010386d:	66 90                	xchg   %ax,%ax
8010386f:	90                   	nop

80103870 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103870:	55                   	push   %ebp
80103871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103876:	ba 21 00 00 00       	mov    $0x21,%edx
8010387b:	89 e5                	mov    %esp,%ebp
8010387d:	ee                   	out    %al,(%dx)
8010387e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103883:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103884:	5d                   	pop    %ebp
80103885:	c3                   	ret    
80103886:	66 90                	xchg   %ax,%ax
80103888:	66 90                	xchg   %ax,%ax
8010388a:	66 90                	xchg   %ax,%ax
8010388c:	66 90                	xchg   %ax,%ax
8010388e:	66 90                	xchg   %ax,%ax

80103890 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 0c             	sub    $0xc,%esp
80103899:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010389c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010389f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801038a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801038ab:	e8 10 d5 ff ff       	call   80100dc0 <filealloc>
801038b0:	85 c0                	test   %eax,%eax
801038b2:	89 03                	mov    %eax,(%ebx)
801038b4:	74 22                	je     801038d8 <pipealloc+0x48>
801038b6:	e8 05 d5 ff ff       	call   80100dc0 <filealloc>
801038bb:	85 c0                	test   %eax,%eax
801038bd:	89 06                	mov    %eax,(%esi)
801038bf:	74 3f                	je     80103900 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801038c1:	e8 0a f1 ff ff       	call   801029d0 <kalloc>
801038c6:	85 c0                	test   %eax,%eax
801038c8:	89 c7                	mov    %eax,%edi
801038ca:	75 54                	jne    80103920 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801038cc:	8b 03                	mov    (%ebx),%eax
801038ce:	85 c0                	test   %eax,%eax
801038d0:	75 34                	jne    80103906 <pipealloc+0x76>
801038d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801038d8:	8b 06                	mov    (%esi),%eax
801038da:	85 c0                	test   %eax,%eax
801038dc:	74 0c                	je     801038ea <pipealloc+0x5a>
    fileclose(*f1);
801038de:	83 ec 0c             	sub    $0xc,%esp
801038e1:	50                   	push   %eax
801038e2:	e8 99 d5 ff ff       	call   80100e80 <fileclose>
801038e7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801038ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801038ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038f2:	5b                   	pop    %ebx
801038f3:	5e                   	pop    %esi
801038f4:	5f                   	pop    %edi
801038f5:	5d                   	pop    %ebp
801038f6:	c3                   	ret    
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103900:	8b 03                	mov    (%ebx),%eax
80103902:	85 c0                	test   %eax,%eax
80103904:	74 e4                	je     801038ea <pipealloc+0x5a>
    fileclose(*f0);
80103906:	83 ec 0c             	sub    $0xc,%esp
80103909:	50                   	push   %eax
8010390a:	e8 71 d5 ff ff       	call   80100e80 <fileclose>
  if(*f1)
8010390f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103911:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103914:	85 c0                	test   %eax,%eax
80103916:	75 c6                	jne    801038de <pipealloc+0x4e>
80103918:	eb d0                	jmp    801038ea <pipealloc+0x5a>
8010391a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103920:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103923:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010392a:	00 00 00 
  p->writeopen = 1;
8010392d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103934:	00 00 00 
  p->nwrite = 0;
80103937:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010393e:	00 00 00 
  p->nread = 0;
80103941:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103948:	00 00 00 
  initlock(&p->lock, "pipe");
8010394b:	68 10 85 10 80       	push   $0x80108510
80103950:	50                   	push   %eax
80103951:	e8 2a 11 00 00       	call   80104a80 <initlock>
  (*f0)->type = FD_PIPE;
80103956:	8b 03                	mov    (%ebx),%eax
  return 0;
80103958:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010395b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103961:	8b 03                	mov    (%ebx),%eax
80103963:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103967:	8b 03                	mov    (%ebx),%eax
80103969:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010396d:	8b 03                	mov    (%ebx),%eax
8010396f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103972:	8b 06                	mov    (%esi),%eax
80103974:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010397a:	8b 06                	mov    (%esi),%eax
8010397c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103980:	8b 06                	mov    (%esi),%eax
80103982:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103986:	8b 06                	mov    (%esi),%eax
80103988:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010398b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010398e:	31 c0                	xor    %eax,%eax
}
80103990:	5b                   	pop    %ebx
80103991:	5e                   	pop    %esi
80103992:	5f                   	pop    %edi
80103993:	5d                   	pop    %ebp
80103994:	c3                   	ret    
80103995:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039a0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
801039a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801039a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801039ab:	83 ec 0c             	sub    $0xc,%esp
801039ae:	53                   	push   %ebx
801039af:	e8 0c 12 00 00       	call   80104bc0 <acquire>
  if(writable){
801039b4:	83 c4 10             	add    $0x10,%esp
801039b7:	85 f6                	test   %esi,%esi
801039b9:	74 45                	je     80103a00 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801039bb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039c1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801039c4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039cb:	00 00 00 
    wakeup(&p->nread);
801039ce:	50                   	push   %eax
801039cf:	e8 ac 0d 00 00       	call   80104780 <wakeup>
801039d4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801039d7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801039dd:	85 d2                	test   %edx,%edx
801039df:	75 0a                	jne    801039eb <pipeclose+0x4b>
801039e1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801039e7:	85 c0                	test   %eax,%eax
801039e9:	74 35                	je     80103a20 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801039eb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801039ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039f1:	5b                   	pop    %ebx
801039f2:	5e                   	pop    %esi
801039f3:	5d                   	pop    %ebp
    release(&p->lock);
801039f4:	e9 87 12 00 00       	jmp    80104c80 <release>
801039f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103a00:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103a06:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103a09:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a10:	00 00 00 
    wakeup(&p->nwrite);
80103a13:	50                   	push   %eax
80103a14:	e8 67 0d 00 00       	call   80104780 <wakeup>
80103a19:	83 c4 10             	add    $0x10,%esp
80103a1c:	eb b9                	jmp    801039d7 <pipeclose+0x37>
80103a1e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a20:	83 ec 0c             	sub    $0xc,%esp
80103a23:	53                   	push   %ebx
80103a24:	e8 57 12 00 00       	call   80104c80 <release>
    kfree((char*)p);
80103a29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a2c:	83 c4 10             	add    $0x10,%esp
}
80103a2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a32:	5b                   	pop    %ebx
80103a33:	5e                   	pop    %esi
80103a34:	5d                   	pop    %ebp
    kfree((char*)p);
80103a35:	e9 b6 ec ff ff       	jmp    801026f0 <kfree>
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a40 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	57                   	push   %edi
80103a44:	56                   	push   %esi
80103a45:	53                   	push   %ebx
80103a46:	83 ec 28             	sub    $0x28,%esp
80103a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a4c:	53                   	push   %ebx
80103a4d:	e8 6e 11 00 00       	call   80104bc0 <acquire>
  for(i = 0; i < n; i++){
80103a52:	8b 45 10             	mov    0x10(%ebp),%eax
80103a55:	83 c4 10             	add    $0x10,%esp
80103a58:	85 c0                	test   %eax,%eax
80103a5a:	0f 8e c9 00 00 00    	jle    80103b29 <pipewrite+0xe9>
80103a60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103a63:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a69:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a6f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103a72:	03 4d 10             	add    0x10(%ebp),%ecx
80103a75:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a78:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103a7e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103a84:	39 d0                	cmp    %edx,%eax
80103a86:	75 71                	jne    80103af9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103a88:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a8e:	85 c0                	test   %eax,%eax
80103a90:	74 4e                	je     80103ae0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a92:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103a98:	eb 3a                	jmp    80103ad4 <pipewrite+0x94>
80103a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	57                   	push   %edi
80103aa4:	e8 d7 0c 00 00       	call   80104780 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103aa9:	5a                   	pop    %edx
80103aaa:	59                   	pop    %ecx
80103aab:	53                   	push   %ebx
80103aac:	56                   	push   %esi
80103aad:	e8 de 0a 00 00       	call   80104590 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ab2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103ab8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103abe:	83 c4 10             	add    $0x10,%esp
80103ac1:	05 00 02 00 00       	add    $0x200,%eax
80103ac6:	39 c2                	cmp    %eax,%edx
80103ac8:	75 36                	jne    80103b00 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103aca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ad0:	85 c0                	test   %eax,%eax
80103ad2:	74 0c                	je     80103ae0 <pipewrite+0xa0>
80103ad4:	e8 f7 03 00 00       	call   80103ed0 <myproc>
80103ad9:	8b 40 24             	mov    0x24(%eax),%eax
80103adc:	85 c0                	test   %eax,%eax
80103ade:	74 c0                	je     80103aa0 <pipewrite+0x60>
        release(&p->lock);
80103ae0:	83 ec 0c             	sub    $0xc,%esp
80103ae3:	53                   	push   %ebx
80103ae4:	e8 97 11 00 00       	call   80104c80 <release>
        return -1;
80103ae9:	83 c4 10             	add    $0x10,%esp
80103aec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103af4:	5b                   	pop    %ebx
80103af5:	5e                   	pop    %esi
80103af6:	5f                   	pop    %edi
80103af7:	5d                   	pop    %ebp
80103af8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103af9:	89 c2                	mov    %eax,%edx
80103afb:	90                   	nop
80103afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103b03:	8d 42 01             	lea    0x1(%edx),%eax
80103b06:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103b0c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103b12:	83 c6 01             	add    $0x1,%esi
80103b15:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103b19:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b1c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b1f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b23:	0f 85 4f ff ff ff    	jne    80103a78 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b29:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b2f:	83 ec 0c             	sub    $0xc,%esp
80103b32:	50                   	push   %eax
80103b33:	e8 48 0c 00 00       	call   80104780 <wakeup>
  release(&p->lock);
80103b38:	89 1c 24             	mov    %ebx,(%esp)
80103b3b:	e8 40 11 00 00       	call   80104c80 <release>
  return n;
80103b40:	83 c4 10             	add    $0x10,%esp
80103b43:	8b 45 10             	mov    0x10(%ebp),%eax
80103b46:	eb a9                	jmp    80103af1 <pipewrite+0xb1>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 18             	sub    $0x18,%esp
80103b59:	8b 75 08             	mov    0x8(%ebp),%esi
80103b5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b5f:	56                   	push   %esi
80103b60:	e8 5b 10 00 00       	call   80104bc0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b65:	83 c4 10             	add    $0x10,%esp
80103b68:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b6e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b74:	75 6a                	jne    80103be0 <piperead+0x90>
80103b76:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103b7c:	85 db                	test   %ebx,%ebx
80103b7e:	0f 84 c4 00 00 00    	je     80103c48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103b84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b8a:	eb 2d                	jmp    80103bb9 <piperead+0x69>
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b90:	83 ec 08             	sub    $0x8,%esp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
80103b95:	e8 f6 09 00 00       	call   80104590 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b9a:	83 c4 10             	add    $0x10,%esp
80103b9d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ba3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ba9:	75 35                	jne    80103be0 <piperead+0x90>
80103bab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103bb1:	85 d2                	test   %edx,%edx
80103bb3:	0f 84 8f 00 00 00    	je     80103c48 <piperead+0xf8>
    if(myproc()->killed){
80103bb9:	e8 12 03 00 00       	call   80103ed0 <myproc>
80103bbe:	8b 48 24             	mov    0x24(%eax),%ecx
80103bc1:	85 c9                	test   %ecx,%ecx
80103bc3:	74 cb                	je     80103b90 <piperead+0x40>
      release(&p->lock);
80103bc5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103bc8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103bcd:	56                   	push   %esi
80103bce:	e8 ad 10 00 00       	call   80104c80 <release>
      return -1;
80103bd3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103bd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bd9:	89 d8                	mov    %ebx,%eax
80103bdb:	5b                   	pop    %ebx
80103bdc:	5e                   	pop    %esi
80103bdd:	5f                   	pop    %edi
80103bde:	5d                   	pop    %ebp
80103bdf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103be0:	8b 45 10             	mov    0x10(%ebp),%eax
80103be3:	85 c0                	test   %eax,%eax
80103be5:	7e 61                	jle    80103c48 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103be7:	31 db                	xor    %ebx,%ebx
80103be9:	eb 13                	jmp    80103bfe <piperead+0xae>
80103beb:	90                   	nop
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bf0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103bf6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103bfc:	74 1f                	je     80103c1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bfe:	8d 41 01             	lea    0x1(%ecx),%eax
80103c01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103c07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103c0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103c12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c15:	83 c3 01             	add    $0x1,%ebx
80103c18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c1b:	75 d3                	jne    80103bf0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c23:	83 ec 0c             	sub    $0xc,%esp
80103c26:	50                   	push   %eax
80103c27:	e8 54 0b 00 00       	call   80104780 <wakeup>
  release(&p->lock);
80103c2c:	89 34 24             	mov    %esi,(%esp)
80103c2f:	e8 4c 10 00 00       	call   80104c80 <release>
  return i;
80103c34:	83 c4 10             	add    $0x10,%esp
}
80103c37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c3a:	89 d8                	mov    %ebx,%eax
80103c3c:	5b                   	pop    %ebx
80103c3d:	5e                   	pop    %esi
80103c3e:	5f                   	pop    %edi
80103c3f:	5d                   	pop    %ebp
80103c40:	c3                   	ret    
80103c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c48:	31 db                	xor    %ebx,%ebx
80103c4a:	eb d1                	jmp    80103c1d <piperead+0xcd>
80103c4c:	66 90                	xchg   %ax,%ax
80103c4e:	66 90                	xchg   %ax,%ax

80103c50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c54:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
{
80103c59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c5c:	68 60 5d 19 80       	push   $0x80195d60
80103c61:	e8 5a 0f 00 00       	call   80104bc0 <acquire>
80103c66:	83 c4 10             	add    $0x10,%esp
80103c69:	eb 17                	jmp    80103c82 <allocproc+0x32>
80103c6b:	90                   	nop
80103c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c70:	81 c3 90 02 00 00    	add    $0x290,%ebx
80103c76:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80103c7c:	0f 83 06 01 00 00    	jae    80103d88 <allocproc+0x138>
    if(p->state == UNUSED)
80103c82:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c85:	85 c0                	test   %eax,%eax
80103c87:	75 e7                	jne    80103c70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c89:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103c8e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c91:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c98:	8d 50 01             	lea    0x1(%eax),%edx
80103c9b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103c9e:	68 60 5d 19 80       	push   $0x80195d60
  p->pid = nextpid++;
80103ca3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103ca9:	e8 d2 0f 00 00       	call   80104c80 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103cae:	e8 1d ed ff ff       	call   801029d0 <kalloc>
80103cb3:	83 c4 10             	add    $0x10,%esp
80103cb6:	85 c0                	test   %eax,%eax
80103cb8:	89 43 08             	mov    %eax,0x8(%ebx)
80103cbb:	0f 84 e0 00 00 00    	je     80103da1 <allocproc+0x151>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cc1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cc7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cca:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ccf:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cd2:	c7 40 14 31 5f 10 80 	movl   $0x80105f31,0x14(%eax)
  p->context = (struct context*)sp;
80103cd9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103cdc:	6a 14                	push   $0x14
80103cde:	6a 00                	push   $0x0
80103ce0:	50                   	push   %eax
80103ce1:	e8 ea 0f 00 00       	call   80104cd0 <memset>
  p->context->eip = (uint)forkret;
80103ce6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80103ce9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cec:	c7 40 10 c0 3d 10 80 	movl   $0x80103dc0,0x10(%eax)
  if(p->pid > 2) {
80103cf3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103cf7:	7f 07                	jg     80103d00 <allocproc+0xb0>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
  }


  return p;
}
80103cf9:	89 d8                	mov    %ebx,%eax
80103cfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cfe:	c9                   	leave  
80103cff:	c3                   	ret    
    if(createSwapFile(p) != 0)
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	53                   	push   %ebx
80103d04:	e8 f7 e4 ff ff       	call   80102200 <createSwapFile>
80103d09:	83 c4 10             	add    $0x10,%esp
80103d0c:	85 c0                	test   %eax,%eax
80103d0e:	0f 85 9b 00 00 00    	jne    80103daf <allocproc+0x15f>
    memset(buf, 0, 16 * 4096);
80103d14:	83 ec 04             	sub    $0x4,%esp
80103d17:	68 00 00 01 00       	push   $0x10000
80103d1c:	6a 00                	push   $0x0
80103d1e:	68 c0 b5 10 80       	push   $0x8010b5c0
80103d23:	e8 a8 0f 00 00       	call   80104cd0 <memset>
    writeToSwapFile(p, (char*)buf, 0, PGSIZE * 16);
80103d28:	68 00 00 01 00       	push   $0x10000
80103d2d:	6a 00                	push   $0x0
80103d2f:	68 c0 b5 10 80       	push   $0x8010b5c0
80103d34:	53                   	push   %ebx
80103d35:	e8 66 e5 ff ff       	call   801022a0 <writeToSwapFile>
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d3a:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80103d40:	83 c4 1c             	add    $0x1c,%esp
    p->num_ram = 0;
80103d43:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80103d4a:	00 00 00 
    p->num_swap = 0;
80103d4d:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80103d54:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d57:	68 00 01 00 00       	push   $0x100
80103d5c:	6a 00                	push   $0x0
80103d5e:	50                   	push   %eax
80103d5f:	e8 6c 0f 00 00       	call   80104cd0 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d64:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103d6a:	83 c4 0c             	add    $0xc,%esp
80103d6d:	68 00 01 00 00       	push   $0x100
80103d72:	6a 00                	push   $0x0
80103d74:	50                   	push   %eax
80103d75:	e8 56 0f 00 00       	call   80104cd0 <memset>
}
80103d7a:	89 d8                	mov    %ebx,%eax
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d7c:	83 c4 10             	add    $0x10,%esp
}
80103d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d82:	c9                   	leave  
80103d83:	c3                   	ret    
80103d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103d88:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d8b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d8d:	68 60 5d 19 80       	push   $0x80195d60
80103d92:	e8 e9 0e 00 00       	call   80104c80 <release>
}
80103d97:	89 d8                	mov    %ebx,%eax
  return 0;
80103d99:	83 c4 10             	add    $0x10,%esp
}
80103d9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d9f:	c9                   	leave  
80103da0:	c3                   	ret    
    p->state = UNUSED;
80103da1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103da8:	31 db                	xor    %ebx,%ebx
80103daa:	e9 4a ff ff ff       	jmp    80103cf9 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
80103daf:	83 ec 0c             	sub    $0xc,%esp
80103db2:	68 15 85 10 80       	push   $0x80108515
80103db7:	e8 d4 c5 ff ff       	call   80100390 <panic>
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103dc0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103dc6:	68 60 5d 19 80       	push   $0x80195d60
80103dcb:	e8 b0 0e 00 00       	call   80104c80 <release>

  if (first) {
80103dd0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103dd5:	83 c4 10             	add    $0x10,%esp
80103dd8:	85 c0                	test   %eax,%eax
80103dda:	75 04                	jne    80103de0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103ddc:	c9                   	leave  
80103ddd:	c3                   	ret    
80103dde:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103de0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103de3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103dea:	00 00 00 
    iinit(ROOTDEV);
80103ded:	6a 01                	push   $0x1
80103def:	e8 cc d6 ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
80103df4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103dfb:	e8 50 f3 ff ff       	call   80103150 <initlog>
80103e00:	83 c4 10             	add    $0x10,%esp
}
80103e03:	c9                   	leave  
80103e04:	c3                   	ret    
80103e05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e10 <pinit>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e16:	68 2f 85 10 80       	push   $0x8010852f
80103e1b:	68 60 5d 19 80       	push   $0x80195d60
80103e20:	e8 5b 0c 00 00       	call   80104a80 <initlock>
}
80103e25:	83 c4 10             	add    $0x10,%esp
80103e28:	c9                   	leave  
80103e29:	c3                   	ret    
80103e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e30 <mycpu>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e35:	9c                   	pushf  
80103e36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e37:	f6 c4 02             	test   $0x2,%ah
80103e3a:	75 5e                	jne    80103e9a <mycpu+0x6a>
  apicid = lapicid();
80103e3c:	e8 3f ef ff ff       	call   80102d80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e41:	8b 35 40 5d 19 80    	mov    0x80195d40,%esi
80103e47:	85 f6                	test   %esi,%esi
80103e49:	7e 42                	jle    80103e8d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103e4b:	0f b6 15 c0 57 19 80 	movzbl 0x801957c0,%edx
80103e52:	39 d0                	cmp    %edx,%eax
80103e54:	74 30                	je     80103e86 <mycpu+0x56>
80103e56:	b9 70 58 19 80       	mov    $0x80195870,%ecx
  for (i = 0; i < ncpu; ++i) {
80103e5b:	31 d2                	xor    %edx,%edx
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
80103e60:	83 c2 01             	add    $0x1,%edx
80103e63:	39 f2                	cmp    %esi,%edx
80103e65:	74 26                	je     80103e8d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103e67:	0f b6 19             	movzbl (%ecx),%ebx
80103e6a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103e70:	39 c3                	cmp    %eax,%ebx
80103e72:	75 ec                	jne    80103e60 <mycpu+0x30>
80103e74:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103e7a:	05 c0 57 19 80       	add    $0x801957c0,%eax
}
80103e7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e82:	5b                   	pop    %ebx
80103e83:	5e                   	pop    %esi
80103e84:	5d                   	pop    %ebp
80103e85:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103e86:	b8 c0 57 19 80       	mov    $0x801957c0,%eax
      return &cpus[i];
80103e8b:	eb f2                	jmp    80103e7f <mycpu+0x4f>
  panic("unknown apicid\n");
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 36 85 10 80       	push   $0x80108536
80103e95:	e8 f6 c4 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 40 86 10 80       	push   $0x80108640
80103ea2:	e8 e9 c4 ff ff       	call   80100390 <panic>
80103ea7:	89 f6                	mov    %esi,%esi
80103ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103eb0 <cpuid>:
cpuid() {
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103eb6:	e8 75 ff ff ff       	call   80103e30 <mycpu>
80103ebb:	2d c0 57 19 80       	sub    $0x801957c0,%eax
}
80103ec0:	c9                   	leave  
  return mycpu()-cpus;
80103ec1:	c1 f8 04             	sar    $0x4,%eax
80103ec4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eca:	c3                   	ret    
80103ecb:	90                   	nop
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <myproc>:
myproc(void) {
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	53                   	push   %ebx
80103ed4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ed7:	e8 14 0c 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103edc:	e8 4f ff ff ff       	call   80103e30 <mycpu>
  p = c->proc;
80103ee1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ee7:	e8 44 0c 00 00       	call   80104b30 <popcli>
}
80103eec:	83 c4 04             	add    $0x4,%esp
80103eef:	89 d8                	mov    %ebx,%eax
80103ef1:	5b                   	pop    %ebx
80103ef2:	5d                   	pop    %ebp
80103ef3:	c3                   	ret    
80103ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f00 <userinit>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103f07:	e8 44 fd ff ff       	call   80103c50 <allocproc>
80103f0c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103f0e:	a3 c0 b5 11 80       	mov    %eax,0x8011b5c0
  if((p->pgdir = setupkvm()) == 0)
80103f13:	e8 a8 38 00 00       	call   801077c0 <setupkvm>
80103f18:	85 c0                	test   %eax,%eax
80103f1a:	89 43 04             	mov    %eax,0x4(%ebx)
80103f1d:	0f 84 bd 00 00 00    	je     80103fe0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f23:	83 ec 04             	sub    $0x4,%esp
80103f26:	68 2c 00 00 00       	push   $0x2c
80103f2b:	68 60 b4 10 80       	push   $0x8010b460
80103f30:	50                   	push   %eax
80103f31:	e8 1a 32 00 00       	call   80107150 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f36:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f39:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f3f:	6a 4c                	push   $0x4c
80103f41:	6a 00                	push   $0x0
80103f43:	ff 73 18             	pushl  0x18(%ebx)
80103f46:	e8 85 0d 00 00       	call   80104cd0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f4b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f4e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f53:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f58:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f5b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f5f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f62:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f66:	8b 43 18             	mov    0x18(%ebx),%eax
80103f69:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f6d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f71:	8b 43 18             	mov    0x18(%ebx),%eax
80103f74:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f78:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f7c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f7f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f86:	8b 43 18             	mov    0x18(%ebx),%eax
80103f89:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f90:	8b 43 18             	mov    0x18(%ebx),%eax
80103f93:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f9a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f9d:	6a 10                	push   $0x10
80103f9f:	68 5f 85 10 80       	push   $0x8010855f
80103fa4:	50                   	push   %eax
80103fa5:	e8 06 0f 00 00       	call   80104eb0 <safestrcpy>
  p->cwd = namei("/");
80103faa:	c7 04 24 68 85 10 80 	movl   $0x80108568,(%esp)
80103fb1:	e8 6a df ff ff       	call   80101f20 <namei>
80103fb6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fb9:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80103fc0:	e8 fb 0b 00 00       	call   80104bc0 <acquire>
  p->state = RUNNABLE;
80103fc5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fcc:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80103fd3:	e8 a8 0c 00 00       	call   80104c80 <release>
}
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fde:	c9                   	leave  
80103fdf:	c3                   	ret    
    panic("userinit: out of memory?");
80103fe0:	83 ec 0c             	sub    $0xc,%esp
80103fe3:	68 46 85 10 80       	push   $0x80108546
80103fe8:	e8 a3 c3 ff ff       	call   80100390 <panic>
80103fed:	8d 76 00             	lea    0x0(%esi),%esi

80103ff0 <growproc>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
80103ff5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ff8:	e8 f3 0a 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80103ffd:	e8 2e fe ff ff       	call   80103e30 <mycpu>
  p = c->proc;
80104002:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104008:	e8 23 0b 00 00       	call   80104b30 <popcli>
  if(n > 0){
8010400d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104010:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104012:	7f 1c                	jg     80104030 <growproc+0x40>
  } else if(n < 0){
80104014:	75 3a                	jne    80104050 <growproc+0x60>
  switchuvm(curproc);
80104016:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104019:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010401b:	53                   	push   %ebx
8010401c:	e8 1f 30 00 00       	call   80107040 <switchuvm>
  return 0;
80104021:	83 c4 10             	add    $0x10,%esp
80104024:	31 c0                	xor    %eax,%eax
}
80104026:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104029:	5b                   	pop    %ebx
8010402a:	5e                   	pop    %esi
8010402b:	5d                   	pop    %ebp
8010402c:	c3                   	ret    
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104030:	83 ec 04             	sub    $0x4,%esp
80104033:	01 c6                	add    %eax,%esi
80104035:	56                   	push   %esi
80104036:	50                   	push   %eax
80104037:	ff 73 04             	pushl  0x4(%ebx)
8010403a:	e8 31 34 00 00       	call   80107470 <allocuvm>
8010403f:	83 c4 10             	add    $0x10,%esp
80104042:	85 c0                	test   %eax,%eax
80104044:	75 d0                	jne    80104016 <growproc+0x26>
      return -1;
80104046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404b:	eb d9                	jmp    80104026 <growproc+0x36>
8010404d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104050:	83 ec 04             	sub    $0x4,%esp
80104053:	01 c6                	add    %eax,%esi
80104055:	56                   	push   %esi
80104056:	50                   	push   %eax
80104057:	ff 73 04             	pushl  0x4(%ebx)
8010405a:	e8 41 32 00 00       	call   801072a0 <deallocuvm>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	85 c0                	test   %eax,%eax
80104064:	75 b0                	jne    80104016 <growproc+0x26>
80104066:	eb de                	jmp    80104046 <growproc+0x56>
80104068:	90                   	nop
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <fork>:
{ 
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
80104074:	56                   	push   %esi
80104075:	53                   	push   %ebx
80104076:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104079:	e8 72 0a 00 00       	call   80104af0 <pushcli>
  c = mycpu();
8010407e:	e8 ad fd ff ff       	call   80103e30 <mycpu>
  p = c->proc;
80104083:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104089:	e8 a2 0a 00 00       	call   80104b30 <popcli>
  if((np = allocproc()) == 0){
8010408e:	e8 bd fb ff ff       	call   80103c50 <allocproc>
80104093:	85 c0                	test   %eax,%eax
80104095:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104098:	0f 84 a8 01 00 00    	je     80104246 <fork+0x1d6>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010409e:	83 ec 08             	sub    $0x8,%esp
801040a1:	ff 33                	pushl  (%ebx)
801040a3:	ff 73 04             	pushl  0x4(%ebx)
801040a6:	e8 35 3c 00 00       	call   80107ce0 <copyuvm>
801040ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(np->pgdir == 0){
801040ae:	83 c4 10             	add    $0x10,%esp
801040b1:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801040b3:	89 42 04             	mov    %eax,0x4(%edx)
  if(np->pgdir == 0){
801040b6:	0f 84 94 01 00 00    	je     80104250 <fork+0x1e0>
  np->sz = curproc->sz;
801040bc:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801040be:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
801040c3:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801040c6:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
801040c9:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801040cb:	8b 73 18             	mov    0x18(%ebx),%esi
801040ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801040d0:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801040d4:	0f 8f 9e 00 00 00    	jg     80104178 <fork+0x108>
  np->tf->eax = 0;
801040da:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
801040dd:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040df:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801040e6:	8d 76 00             	lea    0x0(%esi),%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
801040f0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040f4:	85 c0                	test   %eax,%eax
801040f6:	74 16                	je     8010410e <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
801040f8:	83 ec 0c             	sub    $0xc,%esp
801040fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801040fe:	50                   	push   %eax
801040ff:	e8 2c cd ff ff       	call   80100e30 <filedup>
80104104:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104107:	83 c4 10             	add    $0x10,%esp
8010410a:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010410e:	83 c6 01             	add    $0x1,%esi
80104111:	83 fe 10             	cmp    $0x10,%esi
80104114:	75 da                	jne    801040f0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80104116:	83 ec 0c             	sub    $0xc,%esp
80104119:	ff 73 68             	pushl  0x68(%ebx)
8010411c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010411f:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104122:	e8 69 d5 ff ff       	call   80101690 <idup>
80104127:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010412a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010412d:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104130:	8d 42 6c             	lea    0x6c(%edx),%eax
80104133:	6a 10                	push   $0x10
80104135:	53                   	push   %ebx
80104136:	50                   	push   %eax
80104137:	e8 74 0d 00 00       	call   80104eb0 <safestrcpy>
  pid = np->pid;
8010413c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010413f:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80104142:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104149:	e8 72 0a 00 00       	call   80104bc0 <acquire>
  np->state = RUNNABLE;
8010414e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104151:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80104158:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
8010415f:	e8 1c 0b 00 00       	call   80104c80 <release>
  return pid;
80104164:	83 c4 10             	add    $0x10,%esp
}
80104167:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416a:	89 d8                	mov    %ebx,%eax
8010416c:	5b                   	pop    %ebx
8010416d:	5e                   	pop    %esi
8010416e:	5f                   	pop    %edi
8010416f:	5d                   	pop    %ebp
80104170:	c3                   	ret    
80104171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->ramPages[i].isused)
80104178:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
8010417e:	85 c0                	test   %eax,%eax
80104180:	74 1f                	je     801041a1 <fork+0x131>
        np->ramPages[i].isused = 1;
80104182:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80104189:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010418c:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
80104192:	89 82 90 01 00 00    	mov    %eax,0x190(%edx)
        np->ramPages[i].pgdir = np->pgdir;
80104198:	8b 42 04             	mov    0x4(%edx),%eax
8010419b:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
{ 
801041a1:	31 f6                	xor    %esi,%esi
801041a3:	eb 12                	jmp    801041b7 <fork+0x147>
801041a5:	8d 76 00             	lea    0x0(%esi),%esi
801041a8:	83 c6 10             	add    $0x10,%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801041ab:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801041b1:	0f 84 23 ff ff ff    	je     801040da <fork+0x6a>
      if(curproc->swappedPages[i].isused)
801041b7:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
801041be:	85 c9                	test   %ecx,%ecx
801041c0:	74 e6                	je     801041a8 <fork+0x138>
      np->swappedPages[i].isused = 1;
801041c2:	c7 84 32 8c 00 00 00 	movl   $0x1,0x8c(%edx,%esi,1)
801041c9:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801041cd:	8b 84 33 90 00 00 00 	mov    0x90(%ebx,%esi,1),%eax
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
801041d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801041d7:	89 84 32 90 00 00 00 	mov    %eax,0x90(%edx,%esi,1)
      np->swappedPages[i].pgdir = np->pgdir;
801041de:	8b 42 04             	mov    0x4(%edx),%eax
801041e1:	89 84 32 88 00 00 00 	mov    %eax,0x88(%edx,%esi,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
801041e8:	8b 84 33 94 00 00 00 	mov    0x94(%ebx,%esi,1),%eax
801041ef:	89 84 32 94 00 00 00 	mov    %eax,0x94(%edx,%esi,1)
      if(readFromSwapFile((void*)curproc, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
801041f6:	68 00 10 00 00       	push   $0x1000
801041fb:	50                   	push   %eax
801041fc:	68 e0 b5 11 80       	push   $0x8011b5e0
80104201:	53                   	push   %ebx
80104202:	e8 c9 e0 ff ff       	call   801022d0 <readFromSwapFile>
80104207:	83 c4 10             	add    $0x10,%esp
8010420a:	85 c0                	test   %eax,%eax
8010420c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010420f:	78 68                	js     80104279 <fork+0x209>
      if(writeToSwapFile((void*)np, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
80104211:	68 00 10 00 00       	push   $0x1000
80104216:	ff b4 32 94 00 00 00 	pushl  0x94(%edx,%esi,1)
8010421d:	68 e0 b5 11 80       	push   $0x8011b5e0
80104222:	52                   	push   %edx
80104223:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104226:	e8 75 e0 ff ff       	call   801022a0 <writeToSwapFile>
8010422b:	83 c4 10             	add    $0x10,%esp
8010422e:	85 c0                	test   %eax,%eax
80104230:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104233:	0f 89 6f ff ff ff    	jns    801041a8 <fork+0x138>
        panic("fork: writeToSwapFile");
80104239:	83 ec 0c             	sub    $0xc,%esp
8010423c:	68 81 85 10 80       	push   $0x80108581
80104241:	e8 4a c1 ff ff       	call   80100390 <panic>
    return -1;
80104246:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010424b:	e9 17 ff ff ff       	jmp    80104167 <fork+0xf7>
    kfree(np->kstack);
80104250:	83 ec 0c             	sub    $0xc,%esp
80104253:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80104256:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010425b:	e8 90 e4 ff ff       	call   801026f0 <kfree>
    np->kstack = 0;
80104260:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104263:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104266:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010426d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104274:	e9 ee fe ff ff       	jmp    80104167 <fork+0xf7>
        panic("fork: readFromSwapFile");
80104279:	83 ec 0c             	sub    $0xc,%esp
8010427c:	68 6a 85 10 80       	push   $0x8010856a
80104281:	e8 0a c1 ff ff       	call   80100390 <panic>
80104286:	8d 76 00             	lea    0x0(%esi),%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <scheduler>:
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	57                   	push   %edi
80104294:	56                   	push   %esi
80104295:	53                   	push   %ebx
80104296:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104299:	e8 92 fb ff ff       	call   80103e30 <mycpu>
8010429e:	8d 78 04             	lea    0x4(%eax),%edi
801042a1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801042a3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801042aa:	00 00 00 
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801042b0:	fb                   	sti    
    acquire(&ptable.lock);
801042b1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b4:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
    acquire(&ptable.lock);
801042b9:	68 60 5d 19 80       	push   $0x80195d60
801042be:	e8 fd 08 00 00       	call   80104bc0 <acquire>
801042c3:	83 c4 10             	add    $0x10,%esp
801042c6:	8d 76 00             	lea    0x0(%esi),%esi
801042c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801042d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042d4:	75 33                	jne    80104309 <scheduler+0x79>
      switchuvm(p);
801042d6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801042d9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801042df:	53                   	push   %ebx
801042e0:	e8 5b 2d 00 00       	call   80107040 <switchuvm>
      swtch(&(c->scheduler), p->context);
801042e5:	58                   	pop    %eax
801042e6:	5a                   	pop    %edx
801042e7:	ff 73 1c             	pushl  0x1c(%ebx)
801042ea:	57                   	push   %edi
      p->state = RUNNING;
801042eb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801042f2:	e8 14 0c 00 00       	call   80104f0b <swtch>
      switchkvm();
801042f7:	e8 24 2d 00 00       	call   80107020 <switchkvm>
      c->proc = 0;
801042fc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104303:	00 00 00 
80104306:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104309:	81 c3 90 02 00 00    	add    $0x290,%ebx
8010430f:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80104315:	72 b9                	jb     801042d0 <scheduler+0x40>
    release(&ptable.lock);
80104317:	83 ec 0c             	sub    $0xc,%esp
8010431a:	68 60 5d 19 80       	push   $0x80195d60
8010431f:	e8 5c 09 00 00       	call   80104c80 <release>
    sti();
80104324:	83 c4 10             	add    $0x10,%esp
80104327:	eb 87                	jmp    801042b0 <scheduler+0x20>
80104329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104330 <sched>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	56                   	push   %esi
80104334:	53                   	push   %ebx
  pushcli();
80104335:	e8 b6 07 00 00       	call   80104af0 <pushcli>
  c = mycpu();
8010433a:	e8 f1 fa ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010433f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104345:	e8 e6 07 00 00       	call   80104b30 <popcli>
  if(!holding(&ptable.lock))
8010434a:	83 ec 0c             	sub    $0xc,%esp
8010434d:	68 60 5d 19 80       	push   $0x80195d60
80104352:	e8 39 08 00 00       	call   80104b90 <holding>
80104357:	83 c4 10             	add    $0x10,%esp
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 4f                	je     801043ad <sched+0x7d>
  if(mycpu()->ncli != 1)
8010435e:	e8 cd fa ff ff       	call   80103e30 <mycpu>
80104363:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010436a:	75 68                	jne    801043d4 <sched+0xa4>
  if(p->state == RUNNING)
8010436c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104370:	74 55                	je     801043c7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104372:	9c                   	pushf  
80104373:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104374:	f6 c4 02             	test   $0x2,%ah
80104377:	75 41                	jne    801043ba <sched+0x8a>
  intena = mycpu()->intena;
80104379:	e8 b2 fa ff ff       	call   80103e30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010437e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104381:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104387:	e8 a4 fa ff ff       	call   80103e30 <mycpu>
8010438c:	83 ec 08             	sub    $0x8,%esp
8010438f:	ff 70 04             	pushl  0x4(%eax)
80104392:	53                   	push   %ebx
80104393:	e8 73 0b 00 00       	call   80104f0b <swtch>
  mycpu()->intena = intena;
80104398:	e8 93 fa ff ff       	call   80103e30 <mycpu>
}
8010439d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801043a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801043a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043a9:	5b                   	pop    %ebx
801043aa:	5e                   	pop    %esi
801043ab:	5d                   	pop    %ebp
801043ac:	c3                   	ret    
    panic("sched ptable.lock");
801043ad:	83 ec 0c             	sub    $0xc,%esp
801043b0:	68 97 85 10 80       	push   $0x80108597
801043b5:	e8 d6 bf ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801043ba:	83 ec 0c             	sub    $0xc,%esp
801043bd:	68 c3 85 10 80       	push   $0x801085c3
801043c2:	e8 c9 bf ff ff       	call   80100390 <panic>
    panic("sched running");
801043c7:	83 ec 0c             	sub    $0xc,%esp
801043ca:	68 b5 85 10 80       	push   $0x801085b5
801043cf:	e8 bc bf ff ff       	call   80100390 <panic>
    panic("sched locks");
801043d4:	83 ec 0c             	sub    $0xc,%esp
801043d7:	68 a9 85 10 80       	push   $0x801085a9
801043dc:	e8 af bf ff ff       	call   80100390 <panic>
801043e1:	eb 0d                	jmp    801043f0 <exit>
801043e3:	90                   	nop
801043e4:	90                   	nop
801043e5:	90                   	nop
801043e6:	90                   	nop
801043e7:	90                   	nop
801043e8:	90                   	nop
801043e9:	90                   	nop
801043ea:	90                   	nop
801043eb:	90                   	nop
801043ec:	90                   	nop
801043ed:	90                   	nop
801043ee:	90                   	nop
801043ef:	90                   	nop

801043f0 <exit>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	57                   	push   %edi
801043f4:	56                   	push   %esi
801043f5:	53                   	push   %ebx
801043f6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801043f9:	e8 f2 06 00 00       	call   80104af0 <pushcli>
  c = mycpu();
801043fe:	e8 2d fa ff ff       	call   80103e30 <mycpu>
  p = c->proc;
80104403:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104409:	e8 22 07 00 00       	call   80104b30 <popcli>
  if(curproc-> pid > 2)
8010440e:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104412:	0f 8f 09 01 00 00    	jg     80104521 <exit+0x131>
  if(curproc == initproc)
80104418:	39 1d c0 b5 11 80    	cmp    %ebx,0x8011b5c0
8010441e:	8d 73 28             	lea    0x28(%ebx),%esi
80104421:	8d 7b 68             	lea    0x68(%ebx),%edi
80104424:	0f 84 08 01 00 00    	je     80104532 <exit+0x142>
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104430:	8b 06                	mov    (%esi),%eax
80104432:	85 c0                	test   %eax,%eax
80104434:	74 12                	je     80104448 <exit+0x58>
      fileclose(curproc->ofile[fd]);
80104436:	83 ec 0c             	sub    $0xc,%esp
80104439:	50                   	push   %eax
8010443a:	e8 41 ca ff ff       	call   80100e80 <fileclose>
      curproc->ofile[fd] = 0;
8010443f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104445:	83 c4 10             	add    $0x10,%esp
80104448:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010444b:	39 fe                	cmp    %edi,%esi
8010444d:	75 e1                	jne    80104430 <exit+0x40>
  begin_op();
8010444f:	e8 9c ed ff ff       	call   801031f0 <begin_op>
  iput(curproc->cwd);
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	ff 73 68             	pushl  0x68(%ebx)
8010445a:	e8 91 d3 ff ff       	call   801017f0 <iput>
  end_op();
8010445f:	e8 fc ed ff ff       	call   80103260 <end_op>
  curproc->cwd = 0;
80104464:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010446b:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104472:	e8 49 07 00 00       	call   80104bc0 <acquire>
  wakeup1(curproc->parent);
80104477:	8b 53 14             	mov    0x14(%ebx),%edx
8010447a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010447d:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
80104482:	eb 10                	jmp    80104494 <exit+0xa4>
80104484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104488:	05 90 02 00 00       	add    $0x290,%eax
8010448d:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
80104492:	73 1e                	jae    801044b2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104494:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104498:	75 ee                	jne    80104488 <exit+0x98>
8010449a:	3b 50 20             	cmp    0x20(%eax),%edx
8010449d:	75 e9                	jne    80104488 <exit+0x98>
      p->state = RUNNABLE;
8010449f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044a6:	05 90 02 00 00       	add    $0x290,%eax
801044ab:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801044b0:	72 e2                	jb     80104494 <exit+0xa4>
      p->parent = initproc;
801044b2:	8b 0d c0 b5 11 80    	mov    0x8011b5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044b8:	ba 94 5d 19 80       	mov    $0x80195d94,%edx
801044bd:	eb 0f                	jmp    801044ce <exit+0xde>
801044bf:	90                   	nop
801044c0:	81 c2 90 02 00 00    	add    $0x290,%edx
801044c6:	81 fa 94 01 1a 80    	cmp    $0x801a0194,%edx
801044cc:	73 3a                	jae    80104508 <exit+0x118>
    if(p->parent == curproc){
801044ce:	39 5a 14             	cmp    %ebx,0x14(%edx)
801044d1:	75 ed                	jne    801044c0 <exit+0xd0>
      if(p->state == ZOMBIE)
801044d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801044d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801044da:	75 e4                	jne    801044c0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044dc:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
801044e1:	eb 11                	jmp    801044f4 <exit+0x104>
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	05 90 02 00 00       	add    $0x290,%eax
801044ed:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801044f2:	73 cc                	jae    801044c0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801044f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044f8:	75 ee                	jne    801044e8 <exit+0xf8>
801044fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801044fd:	75 e9                	jne    801044e8 <exit+0xf8>
      p->state = RUNNABLE;
801044ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104506:	eb e0                	jmp    801044e8 <exit+0xf8>
  curproc->state = ZOMBIE;
80104508:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010450f:	e8 1c fe ff ff       	call   80104330 <sched>
  panic("zombie exit");
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	68 e4 85 10 80       	push   $0x801085e4
8010451c:	e8 6f be ff ff       	call   80100390 <panic>
    removeSwapFile(curproc);
80104521:	83 ec 0c             	sub    $0xc,%esp
80104524:	53                   	push   %ebx
80104525:	e8 c6 da ff ff       	call   80101ff0 <removeSwapFile>
8010452a:	83 c4 10             	add    $0x10,%esp
8010452d:	e9 e6 fe ff ff       	jmp    80104418 <exit+0x28>
    panic("init exiting");
80104532:	83 ec 0c             	sub    $0xc,%esp
80104535:	68 d7 85 10 80       	push   $0x801085d7
8010453a:	e8 51 be ff ff       	call   80100390 <panic>
8010453f:	90                   	nop

80104540 <yield>:
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104547:	68 60 5d 19 80       	push   $0x80195d60
8010454c:	e8 6f 06 00 00       	call   80104bc0 <acquire>
  pushcli();
80104551:	e8 9a 05 00 00       	call   80104af0 <pushcli>
  c = mycpu();
80104556:	e8 d5 f8 ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010455b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104561:	e8 ca 05 00 00       	call   80104b30 <popcli>
  myproc()->state = RUNNABLE;
80104566:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010456d:	e8 be fd ff ff       	call   80104330 <sched>
  release(&ptable.lock);
80104572:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104579:	e8 02 07 00 00       	call   80104c80 <release>
}
8010457e:	83 c4 10             	add    $0x10,%esp
80104581:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104584:	c9                   	leave  
80104585:	c3                   	ret    
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <sleep>:
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	57                   	push   %edi
80104594:	56                   	push   %esi
80104595:	53                   	push   %ebx
80104596:	83 ec 0c             	sub    $0xc,%esp
80104599:	8b 7d 08             	mov    0x8(%ebp),%edi
8010459c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010459f:	e8 4c 05 00 00       	call   80104af0 <pushcli>
  c = mycpu();
801045a4:	e8 87 f8 ff ff       	call   80103e30 <mycpu>
  p = c->proc;
801045a9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045af:	e8 7c 05 00 00       	call   80104b30 <popcli>
  if(p == 0)
801045b4:	85 db                	test   %ebx,%ebx
801045b6:	0f 84 87 00 00 00    	je     80104643 <sleep+0xb3>
  if(lk == 0)
801045bc:	85 f6                	test   %esi,%esi
801045be:	74 76                	je     80104636 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045c0:	81 fe 60 5d 19 80    	cmp    $0x80195d60,%esi
801045c6:	74 50                	je     80104618 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	68 60 5d 19 80       	push   $0x80195d60
801045d0:	e8 eb 05 00 00       	call   80104bc0 <acquire>
    release(lk);
801045d5:	89 34 24             	mov    %esi,(%esp)
801045d8:	e8 a3 06 00 00       	call   80104c80 <release>
  p->chan = chan;
801045dd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801045e0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045e7:	e8 44 fd ff ff       	call   80104330 <sched>
  p->chan = 0;
801045ec:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801045f3:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
801045fa:	e8 81 06 00 00       	call   80104c80 <release>
    acquire(lk);
801045ff:	89 75 08             	mov    %esi,0x8(%ebp)
80104602:	83 c4 10             	add    $0x10,%esp
}
80104605:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104608:	5b                   	pop    %ebx
80104609:	5e                   	pop    %esi
8010460a:	5f                   	pop    %edi
8010460b:	5d                   	pop    %ebp
    acquire(lk);
8010460c:	e9 af 05 00 00       	jmp    80104bc0 <acquire>
80104611:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104618:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010461b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104622:	e8 09 fd ff ff       	call   80104330 <sched>
  p->chan = 0;
80104627:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010462e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104631:	5b                   	pop    %ebx
80104632:	5e                   	pop    %esi
80104633:	5f                   	pop    %edi
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
    panic("sleep without lk");
80104636:	83 ec 0c             	sub    $0xc,%esp
80104639:	68 f6 85 10 80       	push   $0x801085f6
8010463e:	e8 4d bd ff ff       	call   80100390 <panic>
    panic("sleep");
80104643:	83 ec 0c             	sub    $0xc,%esp
80104646:	68 f0 85 10 80       	push   $0x801085f0
8010464b:	e8 40 bd ff ff       	call   80100390 <panic>

80104650 <wait>:
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
  pushcli();
80104655:	e8 96 04 00 00       	call   80104af0 <pushcli>
  c = mycpu();
8010465a:	e8 d1 f7 ff ff       	call   80103e30 <mycpu>
  p = c->proc;
8010465f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104665:	e8 c6 04 00 00       	call   80104b30 <popcli>
  acquire(&ptable.lock);
8010466a:	83 ec 0c             	sub    $0xc,%esp
8010466d:	68 60 5d 19 80       	push   $0x80195d60
80104672:	e8 49 05 00 00       	call   80104bc0 <acquire>
80104677:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010467a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010467c:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
80104681:	eb 13                	jmp    80104696 <wait+0x46>
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104688:	81 c3 90 02 00 00    	add    $0x290,%ebx
8010468e:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80104694:	73 1e                	jae    801046b4 <wait+0x64>
      if(p->parent != curproc)
80104696:	39 73 14             	cmp    %esi,0x14(%ebx)
80104699:	75 ed                	jne    80104688 <wait+0x38>
      if(p->state == ZOMBIE){
8010469b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010469f:	74 3f                	je     801046e0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046a1:	81 c3 90 02 00 00    	add    $0x290,%ebx
      havekids = 1;
801046a7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ac:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
801046b2:	72 e2                	jb     80104696 <wait+0x46>
    if(!havekids || curproc->killed){
801046b4:	85 c0                	test   %eax,%eax
801046b6:	0f 84 a6 00 00 00    	je     80104762 <wait+0x112>
801046bc:	8b 46 24             	mov    0x24(%esi),%eax
801046bf:	85 c0                	test   %eax,%eax
801046c1:	0f 85 9b 00 00 00    	jne    80104762 <wait+0x112>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801046c7:	83 ec 08             	sub    $0x8,%esp
801046ca:	68 60 5d 19 80       	push   $0x80195d60
801046cf:	56                   	push   %esi
801046d0:	e8 bb fe ff ff       	call   80104590 <sleep>
    havekids = 0;
801046d5:	83 c4 10             	add    $0x10,%esp
801046d8:	eb a0                	jmp    8010467a <wait+0x2a>
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801046e0:	83 ec 0c             	sub    $0xc,%esp
801046e3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801046e6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801046e9:	e8 02 e0 ff ff       	call   801026f0 <kfree>
        freevm(p->pgdir);
801046ee:	5a                   	pop    %edx
801046ef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801046f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801046f9:	e8 42 30 00 00       	call   80107740 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
801046fe:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80104704:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104707:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
8010470e:	68 00 01 00 00       	push   $0x100
80104713:	6a 00                	push   $0x0
80104715:	50                   	push   %eax
        p->parent = 0;
80104716:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010471d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104721:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104728:	e8 a3 05 00 00       	call   80104cd0 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
8010472d:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104733:	83 c4 0c             	add    $0xc,%esp
80104736:	68 00 01 00 00       	push   $0x100
8010473b:	6a 00                	push   $0x0
8010473d:	50                   	push   %eax
8010473e:	e8 8d 05 00 00       	call   80104cd0 <memset>
        release(&ptable.lock);
80104743:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
        p->state = UNUSED;
8010474a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104751:	e8 2a 05 00 00       	call   80104c80 <release>
        return pid;
80104756:	83 c4 10             	add    $0x10,%esp
}
80104759:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010475c:	89 f0                	mov    %esi,%eax
8010475e:	5b                   	pop    %ebx
8010475f:	5e                   	pop    %esi
80104760:	5d                   	pop    %ebp
80104761:	c3                   	ret    
      release(&ptable.lock);
80104762:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104765:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010476a:	68 60 5d 19 80       	push   $0x80195d60
8010476f:	e8 0c 05 00 00       	call   80104c80 <release>
      return -1;
80104774:	83 c4 10             	add    $0x10,%esp
80104777:	eb e0                	jmp    80104759 <wait+0x109>
80104779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104780 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 10             	sub    $0x10,%esp
80104787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010478a:	68 60 5d 19 80       	push   $0x80195d60
8010478f:	e8 2c 04 00 00       	call   80104bc0 <acquire>
80104794:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104797:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
8010479c:	eb 0e                	jmp    801047ac <wakeup+0x2c>
8010479e:	66 90                	xchg   %ax,%ax
801047a0:	05 90 02 00 00       	add    $0x290,%eax
801047a5:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801047aa:	73 1e                	jae    801047ca <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801047ac:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047b0:	75 ee                	jne    801047a0 <wakeup+0x20>
801047b2:	3b 58 20             	cmp    0x20(%eax),%ebx
801047b5:	75 e9                	jne    801047a0 <wakeup+0x20>
      p->state = RUNNABLE;
801047b7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047be:	05 90 02 00 00       	add    $0x290,%eax
801047c3:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801047c8:	72 e2                	jb     801047ac <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801047ca:	c7 45 08 60 5d 19 80 	movl   $0x80195d60,0x8(%ebp)
}
801047d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d4:	c9                   	leave  
  release(&ptable.lock);
801047d5:	e9 a6 04 00 00       	jmp    80104c80 <release>
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047e0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	53                   	push   %ebx
801047e4:	83 ec 10             	sub    $0x10,%esp
801047e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047ea:	68 60 5d 19 80       	push   $0x80195d60
801047ef:	e8 cc 03 00 00       	call   80104bc0 <acquire>
801047f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f7:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
801047fc:	eb 0e                	jmp    8010480c <kill+0x2c>
801047fe:	66 90                	xchg   %ax,%ax
80104800:	05 90 02 00 00       	add    $0x290,%eax
80104805:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
8010480a:	73 34                	jae    80104840 <kill+0x60>
    if(p->pid == pid){
8010480c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010480f:	75 ef                	jne    80104800 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104811:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104815:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010481c:	75 07                	jne    80104825 <kill+0x45>
        p->state = RUNNABLE;
8010481e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104825:	83 ec 0c             	sub    $0xc,%esp
80104828:	68 60 5d 19 80       	push   $0x80195d60
8010482d:	e8 4e 04 00 00       	call   80104c80 <release>
      return 0;
80104832:	83 c4 10             	add    $0x10,%esp
80104835:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010483a:	c9                   	leave  
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104840:	83 ec 0c             	sub    $0xc,%esp
80104843:	68 60 5d 19 80       	push   $0x80195d60
80104848:	e8 33 04 00 00       	call   80104c80 <release>
  return -1;
8010484d:	83 c4 10             	add    $0x10,%esp
80104850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104858:	c9                   	leave  
80104859:	c3                   	ret    
8010485a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104860 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	57                   	push   %edi
80104864:	56                   	push   %esi
80104865:	53                   	push   %ebx
80104866:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104869:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
{
8010486e:	83 ec 3c             	sub    $0x3c,%esp
80104871:	eb 27                	jmp    8010489a <procdump+0x3a>
80104873:	90                   	nop
80104874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104878:	83 ec 0c             	sub    $0xc,%esp
8010487b:	68 ba 8a 10 80       	push   $0x80108aba
80104880:	e8 db bd ff ff       	call   80100660 <cprintf>
80104885:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104888:	81 c3 90 02 00 00    	add    $0x290,%ebx
8010488e:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80104894:	0f 83 86 00 00 00    	jae    80104920 <procdump+0xc0>
    if(p->state == UNUSED)
8010489a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010489d:	85 c0                	test   %eax,%eax
8010489f:	74 e7                	je     80104888 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048a1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801048a4:	ba 07 86 10 80       	mov    $0x80108607,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801048a9:	77 11                	ja     801048bc <procdump+0x5c>
801048ab:	8b 14 85 68 86 10 80 	mov    -0x7fef7998(,%eax,4),%edx
      state = "???";
801048b2:	b8 07 86 10 80       	mov    $0x80108607,%eax
801048b7:	85 d2                	test   %edx,%edx
801048b9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048bc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048bf:	50                   	push   %eax
801048c0:	52                   	push   %edx
801048c1:	ff 73 10             	pushl  0x10(%ebx)
801048c4:	68 0b 86 10 80       	push   $0x8010860b
801048c9:	e8 92 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801048ce:	83 c4 10             	add    $0x10,%esp
801048d1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801048d5:	75 a1                	jne    80104878 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048d7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048da:	83 ec 08             	sub    $0x8,%esp
801048dd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048e0:	50                   	push   %eax
801048e1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801048e4:	8b 40 0c             	mov    0xc(%eax),%eax
801048e7:	83 c0 08             	add    $0x8,%eax
801048ea:	50                   	push   %eax
801048eb:	e8 b0 01 00 00       	call   80104aa0 <getcallerpcs>
801048f0:	83 c4 10             	add    $0x10,%esp
801048f3:	90                   	nop
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801048f8:	8b 17                	mov    (%edi),%edx
801048fa:	85 d2                	test   %edx,%edx
801048fc:	0f 84 76 ff ff ff    	je     80104878 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104902:	83 ec 08             	sub    $0x8,%esp
80104905:	83 c7 04             	add    $0x4,%edi
80104908:	52                   	push   %edx
80104909:	68 a1 7f 10 80       	push   $0x80107fa1
8010490e:	e8 4d bd ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104913:	83 c4 10             	add    $0x10,%esp
80104916:	39 fe                	cmp    %edi,%esi
80104918:	75 de                	jne    801048f8 <procdump+0x98>
8010491a:	e9 59 ff ff ff       	jmp    80104878 <procdump+0x18>
8010491f:	90                   	nop
  }
}
80104920:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104923:	5b                   	pop    %ebx
80104924:	5e                   	pop    %esi
80104925:	5f                   	pop    %edi
80104926:	5d                   	pop    %ebp
80104927:	c3                   	ret    
80104928:	90                   	nop
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104930 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
80104936:	68 60 5d 19 80       	push   $0x80195d60
8010493b:	e8 80 02 00 00       	call   80104bc0 <acquire>
    if(p->state == UNUSED)
      continue;
    // sum += MAX_PSYC_PAGES - p->nummemorypages;
    pcount++;
  }
  release(&ptable.lock);
80104940:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104947:	e8 34 03 00 00       	call   80104c80 <release>
  return sum;
8010494c:	31 c0                	xor    %eax,%eax
8010494e:	c9                   	leave  
8010494f:	c3                   	ret    

80104950 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	53                   	push   %ebx
80104954:	83 ec 0c             	sub    $0xc,%esp
80104957:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010495a:	68 80 86 10 80       	push   $0x80108680
8010495f:	8d 43 04             	lea    0x4(%ebx),%eax
80104962:	50                   	push   %eax
80104963:	e8 18 01 00 00       	call   80104a80 <initlock>
  lk->name = name;
80104968:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010496b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104971:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104974:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010497b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010497e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104981:	c9                   	leave  
80104982:	c3                   	ret    
80104983:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	56                   	push   %esi
80104994:	53                   	push   %ebx
80104995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	8d 73 04             	lea    0x4(%ebx),%esi
8010499e:	56                   	push   %esi
8010499f:	e8 1c 02 00 00       	call   80104bc0 <acquire>
  while (lk->locked) {
801049a4:	8b 13                	mov    (%ebx),%edx
801049a6:	83 c4 10             	add    $0x10,%esp
801049a9:	85 d2                	test   %edx,%edx
801049ab:	74 16                	je     801049c3 <acquiresleep+0x33>
801049ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049b0:	83 ec 08             	sub    $0x8,%esp
801049b3:	56                   	push   %esi
801049b4:	53                   	push   %ebx
801049b5:	e8 d6 fb ff ff       	call   80104590 <sleep>
  while (lk->locked) {
801049ba:	8b 03                	mov    (%ebx),%eax
801049bc:	83 c4 10             	add    $0x10,%esp
801049bf:	85 c0                	test   %eax,%eax
801049c1:	75 ed                	jne    801049b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049c9:	e8 02 f5 ff ff       	call   80103ed0 <myproc>
801049ce:	8b 40 10             	mov    0x10(%eax),%eax
801049d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049da:	5b                   	pop    %ebx
801049db:	5e                   	pop    %esi
801049dc:	5d                   	pop    %ebp
  release(&lk->lk);
801049dd:	e9 9e 02 00 00       	jmp    80104c80 <release>
801049e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049f8:	83 ec 0c             	sub    $0xc,%esp
801049fb:	8d 73 04             	lea    0x4(%ebx),%esi
801049fe:	56                   	push   %esi
801049ff:	e8 bc 01 00 00       	call   80104bc0 <acquire>
  lk->locked = 0;
80104a04:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a0a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a11:	89 1c 24             	mov    %ebx,(%esp)
80104a14:	e8 67 fd ff ff       	call   80104780 <wakeup>
  release(&lk->lk);
80104a19:	89 75 08             	mov    %esi,0x8(%ebp)
80104a1c:	83 c4 10             	add    $0x10,%esp
}
80104a1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a22:	5b                   	pop    %ebx
80104a23:	5e                   	pop    %esi
80104a24:	5d                   	pop    %ebp
  release(&lk->lk);
80104a25:	e9 56 02 00 00       	jmp    80104c80 <release>
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	53                   	push   %ebx
80104a36:	31 ff                	xor    %edi,%edi
80104a38:	83 ec 18             	sub    $0x18,%esp
80104a3b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a3e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a41:	56                   	push   %esi
80104a42:	e8 79 01 00 00       	call   80104bc0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a47:	8b 03                	mov    (%ebx),%eax
80104a49:	83 c4 10             	add    $0x10,%esp
80104a4c:	85 c0                	test   %eax,%eax
80104a4e:	74 13                	je     80104a63 <holdingsleep+0x33>
80104a50:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a53:	e8 78 f4 ff ff       	call   80103ed0 <myproc>
80104a58:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a5b:	0f 94 c0             	sete   %al
80104a5e:	0f b6 c0             	movzbl %al,%eax
80104a61:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a63:	83 ec 0c             	sub    $0xc,%esp
80104a66:	56                   	push   %esi
80104a67:	e8 14 02 00 00       	call   80104c80 <release>
  return r;
}
80104a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a6f:	89 f8                	mov    %edi,%eax
80104a71:	5b                   	pop    %ebx
80104a72:	5e                   	pop    %esi
80104a73:	5f                   	pop    %edi
80104a74:	5d                   	pop    %ebp
80104a75:	c3                   	ret    
80104a76:	66 90                	xchg   %ax,%ax
80104a78:	66 90                	xchg   %ax,%ax
80104a7a:	66 90                	xchg   %ax,%ax
80104a7c:	66 90                	xchg   %ax,%ax
80104a7e:	66 90                	xchg   %ax,%ax

80104a80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a89:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a8f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a99:	5d                   	pop    %ebp
80104a9a:	c3                   	ret    
80104a9b:	90                   	nop
80104a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104aa0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104aa0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104aa1:	31 d2                	xor    %edx,%edx
{
80104aa3:	89 e5                	mov    %esp,%ebp
80104aa5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104aa6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104aa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104aac:	83 e8 08             	sub    $0x8,%eax
80104aaf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ab0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ab6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104abc:	77 1a                	ja     80104ad8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104abe:	8b 58 04             	mov    0x4(%eax),%ebx
80104ac1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ac4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ac7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ac9:	83 fa 0a             	cmp    $0xa,%edx
80104acc:	75 e2                	jne    80104ab0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ace:	5b                   	pop    %ebx
80104acf:	5d                   	pop    %ebp
80104ad0:	c3                   	ret    
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104adb:	83 c1 28             	add    $0x28,%ecx
80104ade:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ae0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ae6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ae9:	39 c1                	cmp    %eax,%ecx
80104aeb:	75 f3                	jne    80104ae0 <getcallerpcs+0x40>
}
80104aed:	5b                   	pop    %ebx
80104aee:	5d                   	pop    %ebp
80104aef:	c3                   	ret    

80104af0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	53                   	push   %ebx
80104af4:	83 ec 04             	sub    $0x4,%esp
80104af7:	9c                   	pushf  
80104af8:	5b                   	pop    %ebx
  asm volatile("cli");
80104af9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104afa:	e8 31 f3 ff ff       	call   80103e30 <mycpu>
80104aff:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b05:	85 c0                	test   %eax,%eax
80104b07:	75 11                	jne    80104b1a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b09:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b0f:	e8 1c f3 ff ff       	call   80103e30 <mycpu>
80104b14:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b1a:	e8 11 f3 ff ff       	call   80103e30 <mycpu>
80104b1f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b26:	83 c4 04             	add    $0x4,%esp
80104b29:	5b                   	pop    %ebx
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <popcli>:

void
popcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b36:	9c                   	pushf  
80104b37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b38:	f6 c4 02             	test   $0x2,%ah
80104b3b:	75 35                	jne    80104b72 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b3d:	e8 ee f2 ff ff       	call   80103e30 <mycpu>
80104b42:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b49:	78 34                	js     80104b7f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b4b:	e8 e0 f2 ff ff       	call   80103e30 <mycpu>
80104b50:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b56:	85 d2                	test   %edx,%edx
80104b58:	74 06                	je     80104b60 <popcli+0x30>
    sti();
}
80104b5a:	c9                   	leave  
80104b5b:	c3                   	ret    
80104b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b60:	e8 cb f2 ff ff       	call   80103e30 <mycpu>
80104b65:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b6b:	85 c0                	test   %eax,%eax
80104b6d:	74 eb                	je     80104b5a <popcli+0x2a>
  asm volatile("sti");
80104b6f:	fb                   	sti    
}
80104b70:	c9                   	leave  
80104b71:	c3                   	ret    
    panic("popcli - interruptible");
80104b72:	83 ec 0c             	sub    $0xc,%esp
80104b75:	68 8b 86 10 80       	push   $0x8010868b
80104b7a:	e8 11 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b7f:	83 ec 0c             	sub    $0xc,%esp
80104b82:	68 a2 86 10 80       	push   $0x801086a2
80104b87:	e8 04 b8 ff ff       	call   80100390 <panic>
80104b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b90 <holding>:
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
80104b95:	8b 75 08             	mov    0x8(%ebp),%esi
80104b98:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b9a:	e8 51 ff ff ff       	call   80104af0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b9f:	8b 06                	mov    (%esi),%eax
80104ba1:	85 c0                	test   %eax,%eax
80104ba3:	74 10                	je     80104bb5 <holding+0x25>
80104ba5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104ba8:	e8 83 f2 ff ff       	call   80103e30 <mycpu>
80104bad:	39 c3                	cmp    %eax,%ebx
80104baf:	0f 94 c3             	sete   %bl
80104bb2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104bb5:	e8 76 ff ff ff       	call   80104b30 <popcli>
}
80104bba:	89 d8                	mov    %ebx,%eax
80104bbc:	5b                   	pop    %ebx
80104bbd:	5e                   	pop    %esi
80104bbe:	5d                   	pop    %ebp
80104bbf:	c3                   	ret    

80104bc0 <acquire>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bc5:	e8 26 ff ff ff       	call   80104af0 <pushcli>
  if(holding(lk))
80104bca:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bcd:	83 ec 0c             	sub    $0xc,%esp
80104bd0:	53                   	push   %ebx
80104bd1:	e8 ba ff ff ff       	call   80104b90 <holding>
80104bd6:	83 c4 10             	add    $0x10,%esp
80104bd9:	85 c0                	test   %eax,%eax
80104bdb:	0f 85 83 00 00 00    	jne    80104c64 <acquire+0xa4>
80104be1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104be3:	ba 01 00 00 00       	mov    $0x1,%edx
80104be8:	eb 09                	jmp    80104bf3 <acquire+0x33>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bf0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bf3:	89 d0                	mov    %edx,%eax
80104bf5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104bf8:	85 c0                	test   %eax,%eax
80104bfa:	75 f4                	jne    80104bf0 <acquire+0x30>
  __sync_synchronize();
80104bfc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c04:	e8 27 f2 ff ff       	call   80103e30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c09:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104c0c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c0f:	89 e8                	mov    %ebp,%eax
80104c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c18:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c1e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c24:	77 1a                	ja     80104c40 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c26:	8b 48 04             	mov    0x4(%eax),%ecx
80104c29:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c2c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c2f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c31:	83 fe 0a             	cmp    $0xa,%esi
80104c34:	75 e2                	jne    80104c18 <acquire+0x58>
}
80104c36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c39:	5b                   	pop    %ebx
80104c3a:	5e                   	pop    %esi
80104c3b:	5d                   	pop    %ebp
80104c3c:	c3                   	ret    
80104c3d:	8d 76 00             	lea    0x0(%esi),%esi
80104c40:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c43:	83 c2 28             	add    $0x28,%edx
80104c46:	8d 76 00             	lea    0x0(%esi),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c56:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c59:	39 d0                	cmp    %edx,%eax
80104c5b:	75 f3                	jne    80104c50 <acquire+0x90>
}
80104c5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c60:	5b                   	pop    %ebx
80104c61:	5e                   	pop    %esi
80104c62:	5d                   	pop    %ebp
80104c63:	c3                   	ret    
    panic("acquire");
80104c64:	83 ec 0c             	sub    $0xc,%esp
80104c67:	68 a9 86 10 80       	push   $0x801086a9
80104c6c:	e8 1f b7 ff ff       	call   80100390 <panic>
80104c71:	eb 0d                	jmp    80104c80 <release>
80104c73:	90                   	nop
80104c74:	90                   	nop
80104c75:	90                   	nop
80104c76:	90                   	nop
80104c77:	90                   	nop
80104c78:	90                   	nop
80104c79:	90                   	nop
80104c7a:	90                   	nop
80104c7b:	90                   	nop
80104c7c:	90                   	nop
80104c7d:	90                   	nop
80104c7e:	90                   	nop
80104c7f:	90                   	nop

80104c80 <release>:
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	53                   	push   %ebx
80104c84:	83 ec 10             	sub    $0x10,%esp
80104c87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c8a:	53                   	push   %ebx
80104c8b:	e8 00 ff ff ff       	call   80104b90 <holding>
80104c90:	83 c4 10             	add    $0x10,%esp
80104c93:	85 c0                	test   %eax,%eax
80104c95:	74 22                	je     80104cb9 <release+0x39>
  lk->pcs[0] = 0;
80104c97:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c9e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ca5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104caa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cb3:	c9                   	leave  
  popcli();
80104cb4:	e9 77 fe ff ff       	jmp    80104b30 <popcli>
    panic("release");
80104cb9:	83 ec 0c             	sub    $0xc,%esp
80104cbc:	68 b1 86 10 80       	push   $0x801086b1
80104cc1:	e8 ca b6 ff ff       	call   80100390 <panic>
80104cc6:	66 90                	xchg   %ax,%ax
80104cc8:	66 90                	xchg   %ax,%ax
80104cca:	66 90                	xchg   %ax,%ax
80104ccc:	66 90                	xchg   %ax,%ax
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	53                   	push   %ebx
80104cd5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cd8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104cdb:	f6 c2 03             	test   $0x3,%dl
80104cde:	75 05                	jne    80104ce5 <memset+0x15>
80104ce0:	f6 c1 03             	test   $0x3,%cl
80104ce3:	74 13                	je     80104cf8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ce5:	89 d7                	mov    %edx,%edi
80104ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cea:	fc                   	cld    
80104ceb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104ced:	5b                   	pop    %ebx
80104cee:	89 d0                	mov    %edx,%eax
80104cf0:	5f                   	pop    %edi
80104cf1:	5d                   	pop    %ebp
80104cf2:	c3                   	ret    
80104cf3:	90                   	nop
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104cf8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cfc:	c1 e9 02             	shr    $0x2,%ecx
80104cff:	89 f8                	mov    %edi,%eax
80104d01:	89 fb                	mov    %edi,%ebx
80104d03:	c1 e0 18             	shl    $0x18,%eax
80104d06:	c1 e3 10             	shl    $0x10,%ebx
80104d09:	09 d8                	or     %ebx,%eax
80104d0b:	09 f8                	or     %edi,%eax
80104d0d:	c1 e7 08             	shl    $0x8,%edi
80104d10:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d12:	89 d7                	mov    %edx,%edi
80104d14:	fc                   	cld    
80104d15:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d17:	5b                   	pop    %ebx
80104d18:	89 d0                	mov    %edx,%eax
80104d1a:	5f                   	pop    %edi
80104d1b:	5d                   	pop    %ebp
80104d1c:	c3                   	ret    
80104d1d:	8d 76 00             	lea    0x0(%esi),%esi

80104d20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	53                   	push   %ebx
80104d26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d29:	8b 75 08             	mov    0x8(%ebp),%esi
80104d2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d2f:	85 db                	test   %ebx,%ebx
80104d31:	74 29                	je     80104d5c <memcmp+0x3c>
    if(*s1 != *s2)
80104d33:	0f b6 16             	movzbl (%esi),%edx
80104d36:	0f b6 0f             	movzbl (%edi),%ecx
80104d39:	38 d1                	cmp    %dl,%cl
80104d3b:	75 2b                	jne    80104d68 <memcmp+0x48>
80104d3d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d42:	eb 14                	jmp    80104d58 <memcmp+0x38>
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d48:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d4c:	83 c0 01             	add    $0x1,%eax
80104d4f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d54:	38 ca                	cmp    %cl,%dl
80104d56:	75 10                	jne    80104d68 <memcmp+0x48>
  while(n-- > 0){
80104d58:	39 d8                	cmp    %ebx,%eax
80104d5a:	75 ec                	jne    80104d48 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d5c:	5b                   	pop    %ebx
  return 0;
80104d5d:	31 c0                	xor    %eax,%eax
}
80104d5f:	5e                   	pop    %esi
80104d60:	5f                   	pop    %edi
80104d61:	5d                   	pop    %ebp
80104d62:	c3                   	ret    
80104d63:	90                   	nop
80104d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d68:	0f b6 c2             	movzbl %dl,%eax
}
80104d6b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d6c:	29 c8                	sub    %ecx,%eax
}
80104d6e:	5e                   	pop    %esi
80104d6f:	5f                   	pop    %edi
80104d70:	5d                   	pop    %ebp
80104d71:	c3                   	ret    
80104d72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d80 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	56                   	push   %esi
80104d84:	53                   	push   %ebx
80104d85:	8b 45 08             	mov    0x8(%ebp),%eax
80104d88:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d8b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d8e:	39 c3                	cmp    %eax,%ebx
80104d90:	73 26                	jae    80104db8 <memmove+0x38>
80104d92:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d95:	39 c8                	cmp    %ecx,%eax
80104d97:	73 1f                	jae    80104db8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d99:	85 f6                	test   %esi,%esi
80104d9b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d9e:	74 0f                	je     80104daf <memmove+0x2f>
      *--d = *--s;
80104da0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104da4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104da7:	83 ea 01             	sub    $0x1,%edx
80104daa:	83 fa ff             	cmp    $0xffffffff,%edx
80104dad:	75 f1                	jne    80104da0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104daf:	5b                   	pop    %ebx
80104db0:	5e                   	pop    %esi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	90                   	nop
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104db8:	31 d2                	xor    %edx,%edx
80104dba:	85 f6                	test   %esi,%esi
80104dbc:	74 f1                	je     80104daf <memmove+0x2f>
80104dbe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104dc0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104dc4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104dc7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dca:	39 d6                	cmp    %edx,%esi
80104dcc:	75 f2                	jne    80104dc0 <memmove+0x40>
}
80104dce:	5b                   	pop    %ebx
80104dcf:	5e                   	pop    %esi
80104dd0:	5d                   	pop    %ebp
80104dd1:	c3                   	ret    
80104dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104de3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104de4:	eb 9a                	jmp    80104d80 <memmove>
80104de6:	8d 76 00             	lea    0x0(%esi),%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
80104df5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104df8:	53                   	push   %ebx
80104df9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104dff:	85 ff                	test   %edi,%edi
80104e01:	74 2f                	je     80104e32 <strncmp+0x42>
80104e03:	0f b6 01             	movzbl (%ecx),%eax
80104e06:	0f b6 1e             	movzbl (%esi),%ebx
80104e09:	84 c0                	test   %al,%al
80104e0b:	74 37                	je     80104e44 <strncmp+0x54>
80104e0d:	38 c3                	cmp    %al,%bl
80104e0f:	75 33                	jne    80104e44 <strncmp+0x54>
80104e11:	01 f7                	add    %esi,%edi
80104e13:	eb 13                	jmp    80104e28 <strncmp+0x38>
80104e15:	8d 76 00             	lea    0x0(%esi),%esi
80104e18:	0f b6 01             	movzbl (%ecx),%eax
80104e1b:	84 c0                	test   %al,%al
80104e1d:	74 21                	je     80104e40 <strncmp+0x50>
80104e1f:	0f b6 1a             	movzbl (%edx),%ebx
80104e22:	89 d6                	mov    %edx,%esi
80104e24:	38 d8                	cmp    %bl,%al
80104e26:	75 1c                	jne    80104e44 <strncmp+0x54>
    n--, p++, q++;
80104e28:	8d 56 01             	lea    0x1(%esi),%edx
80104e2b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e2e:	39 fa                	cmp    %edi,%edx
80104e30:	75 e6                	jne    80104e18 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e32:	5b                   	pop    %ebx
    return 0;
80104e33:	31 c0                	xor    %eax,%eax
}
80104e35:	5e                   	pop    %esi
80104e36:	5f                   	pop    %edi
80104e37:	5d                   	pop    %ebp
80104e38:	c3                   	ret    
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e40:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e44:	29 d8                	sub    %ebx,%eax
}
80104e46:	5b                   	pop    %ebx
80104e47:	5e                   	pop    %esi
80104e48:	5f                   	pop    %edi
80104e49:	5d                   	pop    %ebp
80104e4a:	c3                   	ret    
80104e4b:	90                   	nop
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	56                   	push   %esi
80104e54:	53                   	push   %ebx
80104e55:	8b 45 08             	mov    0x8(%ebp),%eax
80104e58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e5e:	89 c2                	mov    %eax,%edx
80104e60:	eb 19                	jmp    80104e7b <strncpy+0x2b>
80104e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e68:	83 c3 01             	add    $0x1,%ebx
80104e6b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e6f:	83 c2 01             	add    $0x1,%edx
80104e72:	84 c9                	test   %cl,%cl
80104e74:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e77:	74 09                	je     80104e82 <strncpy+0x32>
80104e79:	89 f1                	mov    %esi,%ecx
80104e7b:	85 c9                	test   %ecx,%ecx
80104e7d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e80:	7f e6                	jg     80104e68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e82:	31 c9                	xor    %ecx,%ecx
80104e84:	85 f6                	test   %esi,%esi
80104e86:	7e 17                	jle    80104e9f <strncpy+0x4f>
80104e88:	90                   	nop
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e90:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e94:	89 f3                	mov    %esi,%ebx
80104e96:	83 c1 01             	add    $0x1,%ecx
80104e99:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104e9b:	85 db                	test   %ebx,%ebx
80104e9d:	7f f1                	jg     80104e90 <strncpy+0x40>
  return os;
}
80104e9f:	5b                   	pop    %ebx
80104ea0:	5e                   	pop    %esi
80104ea1:	5d                   	pop    %ebp
80104ea2:	c3                   	ret    
80104ea3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104eb0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	56                   	push   %esi
80104eb4:	53                   	push   %ebx
80104eb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eb8:	8b 45 08             	mov    0x8(%ebp),%eax
80104ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104ebe:	85 c9                	test   %ecx,%ecx
80104ec0:	7e 26                	jle    80104ee8 <safestrcpy+0x38>
80104ec2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ec6:	89 c1                	mov    %eax,%ecx
80104ec8:	eb 17                	jmp    80104ee1 <safestrcpy+0x31>
80104eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ed0:	83 c2 01             	add    $0x1,%edx
80104ed3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ed7:	83 c1 01             	add    $0x1,%ecx
80104eda:	84 db                	test   %bl,%bl
80104edc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104edf:	74 04                	je     80104ee5 <safestrcpy+0x35>
80104ee1:	39 f2                	cmp    %esi,%edx
80104ee3:	75 eb                	jne    80104ed0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ee5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ee8:	5b                   	pop    %ebx
80104ee9:	5e                   	pop    %esi
80104eea:	5d                   	pop    %ebp
80104eeb:	c3                   	ret    
80104eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ef0 <strlen>:

int
strlen(const char *s)
{
80104ef0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ef1:	31 c0                	xor    %eax,%eax
{
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ef8:	80 3a 00             	cmpb   $0x0,(%edx)
80104efb:	74 0c                	je     80104f09 <strlen+0x19>
80104efd:	8d 76 00             	lea    0x0(%esi),%esi
80104f00:	83 c0 01             	add    $0x1,%eax
80104f03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f07:	75 f7                	jne    80104f00 <strlen+0x10>
    ;
  return n;
}
80104f09:	5d                   	pop    %ebp
80104f0a:	c3                   	ret    

80104f0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f13:	55                   	push   %ebp
  pushl %ebx
80104f14:	53                   	push   %ebx
  pushl %esi
80104f15:	56                   	push   %esi
  pushl %edi
80104f16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f19:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f1b:	5f                   	pop    %edi
  popl %esi
80104f1c:	5e                   	pop    %esi
  popl %ebx
80104f1d:	5b                   	pop    %ebx
  popl %ebp
80104f1e:	5d                   	pop    %ebp
  ret
80104f1f:	c3                   	ret    

80104f20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 04             	sub    $0x4,%esp
80104f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f2a:	e8 a1 ef ff ff       	call   80103ed0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f2f:	8b 00                	mov    (%eax),%eax
80104f31:	39 d8                	cmp    %ebx,%eax
80104f33:	76 1b                	jbe    80104f50 <fetchint+0x30>
80104f35:	8d 53 04             	lea    0x4(%ebx),%edx
80104f38:	39 d0                	cmp    %edx,%eax
80104f3a:	72 14                	jb     80104f50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f3f:	8b 13                	mov    (%ebx),%edx
80104f41:	89 10                	mov    %edx,(%eax)
  return 0;
80104f43:	31 c0                	xor    %eax,%eax
}
80104f45:	83 c4 04             	add    $0x4,%esp
80104f48:	5b                   	pop    %ebx
80104f49:	5d                   	pop    %ebp
80104f4a:	c3                   	ret    
80104f4b:	90                   	nop
80104f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f55:	eb ee                	jmp    80104f45 <fetchint+0x25>
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 04             	sub    $0x4,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f6a:	e8 61 ef ff ff       	call   80103ed0 <myproc>

  if(addr >= curproc->sz)
80104f6f:	39 18                	cmp    %ebx,(%eax)
80104f71:	76 29                	jbe    80104f9c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f76:	89 da                	mov    %ebx,%edx
80104f78:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f7a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f7c:	39 c3                	cmp    %eax,%ebx
80104f7e:	73 1c                	jae    80104f9c <fetchstr+0x3c>
    if(*s == 0)
80104f80:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f83:	75 10                	jne    80104f95 <fetchstr+0x35>
80104f85:	eb 39                	jmp    80104fc0 <fetchstr+0x60>
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f90:	80 3a 00             	cmpb   $0x0,(%edx)
80104f93:	74 1b                	je     80104fb0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f95:	83 c2 01             	add    $0x1,%edx
80104f98:	39 d0                	cmp    %edx,%eax
80104f9a:	77 f4                	ja     80104f90 <fetchstr+0x30>
    return -1;
80104f9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104fa1:	83 c4 04             	add    $0x4,%esp
80104fa4:	5b                   	pop    %ebx
80104fa5:	5d                   	pop    %ebp
80104fa6:	c3                   	ret    
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fb0:	83 c4 04             	add    $0x4,%esp
80104fb3:	89 d0                	mov    %edx,%eax
80104fb5:	29 d8                	sub    %ebx,%eax
80104fb7:	5b                   	pop    %ebx
80104fb8:	5d                   	pop    %ebp
80104fb9:	c3                   	ret    
80104fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104fc0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104fc2:	eb dd                	jmp    80104fa1 <fetchstr+0x41>
80104fc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fd5:	e8 f6 ee ff ff       	call   80103ed0 <myproc>
80104fda:	8b 40 18             	mov    0x18(%eax),%eax
80104fdd:	8b 55 08             	mov    0x8(%ebp),%edx
80104fe0:	8b 40 44             	mov    0x44(%eax),%eax
80104fe3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fe6:	e8 e5 ee ff ff       	call   80103ed0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104feb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fed:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ff0:	39 c6                	cmp    %eax,%esi
80104ff2:	73 1c                	jae    80105010 <argint+0x40>
80104ff4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ff7:	39 d0                	cmp    %edx,%eax
80104ff9:	72 15                	jb     80105010 <argint+0x40>
  *ip = *(int*)(addr);
80104ffb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ffe:	8b 53 04             	mov    0x4(%ebx),%edx
80105001:	89 10                	mov    %edx,(%eax)
  return 0;
80105003:	31 c0                	xor    %eax,%eax
}
80105005:	5b                   	pop    %ebx
80105006:	5e                   	pop    %esi
80105007:	5d                   	pop    %ebp
80105008:	c3                   	ret    
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105015:	eb ee                	jmp    80105005 <argint+0x35>
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
80105025:	83 ec 10             	sub    $0x10,%esp
80105028:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010502b:	e8 a0 ee ff ff       	call   80103ed0 <myproc>
80105030:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105032:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105035:	83 ec 08             	sub    $0x8,%esp
80105038:	50                   	push   %eax
80105039:	ff 75 08             	pushl  0x8(%ebp)
8010503c:	e8 8f ff ff ff       	call   80104fd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105041:	83 c4 10             	add    $0x10,%esp
80105044:	85 c0                	test   %eax,%eax
80105046:	78 28                	js     80105070 <argptr+0x50>
80105048:	85 db                	test   %ebx,%ebx
8010504a:	78 24                	js     80105070 <argptr+0x50>
8010504c:	8b 16                	mov    (%esi),%edx
8010504e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105051:	39 c2                	cmp    %eax,%edx
80105053:	76 1b                	jbe    80105070 <argptr+0x50>
80105055:	01 c3                	add    %eax,%ebx
80105057:	39 da                	cmp    %ebx,%edx
80105059:	72 15                	jb     80105070 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010505b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010505e:	89 02                	mov    %eax,(%edx)
  return 0;
80105060:	31 c0                	xor    %eax,%eax
}
80105062:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105065:	5b                   	pop    %ebx
80105066:	5e                   	pop    %esi
80105067:	5d                   	pop    %ebp
80105068:	c3                   	ret    
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105070:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105075:	eb eb                	jmp    80105062 <argptr+0x42>
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105086:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105089:	50                   	push   %eax
8010508a:	ff 75 08             	pushl  0x8(%ebp)
8010508d:	e8 3e ff ff ff       	call   80104fd0 <argint>
80105092:	83 c4 10             	add    $0x10,%esp
80105095:	85 c0                	test   %eax,%eax
80105097:	78 17                	js     801050b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105099:	83 ec 08             	sub    $0x8,%esp
8010509c:	ff 75 0c             	pushl  0xc(%ebp)
8010509f:	ff 75 f4             	pushl  -0xc(%ebp)
801050a2:	e8 b9 fe ff ff       	call   80104f60 <fetchstr>
801050a7:	83 c4 10             	add    $0x10,%esp
}
801050aa:	c9                   	leave  
801050ab:	c3                   	ret    
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050b5:	c9                   	leave  
801050b6:	c3                   	ret    
801050b7:	89 f6                	mov    %esi,%esi
801050b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050c0 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050c7:	e8 04 ee ff ff       	call   80103ed0 <myproc>
801050cc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050ce:	8b 40 18             	mov    0x18(%eax),%eax
801050d1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050d7:	83 fa 16             	cmp    $0x16,%edx
801050da:	77 1c                	ja     801050f8 <syscall+0x38>
801050dc:	8b 14 85 e0 86 10 80 	mov    -0x7fef7920(,%eax,4),%edx
801050e3:	85 d2                	test   %edx,%edx
801050e5:	74 11                	je     801050f8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050e7:	ff d2                	call   *%edx
801050e9:	8b 53 18             	mov    0x18(%ebx),%edx
801050ec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f2:	c9                   	leave  
801050f3:	c3                   	ret    
801050f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050f8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050f9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050fc:	50                   	push   %eax
801050fd:	ff 73 10             	pushl  0x10(%ebx)
80105100:	68 b9 86 10 80       	push   $0x801086b9
80105105:	e8 56 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010510a:	8b 43 18             	mov    0x18(%ebx),%eax
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105117:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010511a:	c9                   	leave  
8010511b:	c3                   	ret    
8010511c:	66 90                	xchg   %ax,%ax
8010511e:	66 90                	xchg   %ax,%ax

80105120 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
80105125:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105127:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010512a:	89 d6                	mov    %edx,%esi
8010512c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010512f:	50                   	push   %eax
80105130:	6a 00                	push   $0x0
80105132:	e8 99 fe ff ff       	call   80104fd0 <argint>
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	85 c0                	test   %eax,%eax
8010513c:	78 2a                	js     80105168 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010513e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105142:	77 24                	ja     80105168 <argfd.constprop.0+0x48>
80105144:	e8 87 ed ff ff       	call   80103ed0 <myproc>
80105149:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010514c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105150:	85 c0                	test   %eax,%eax
80105152:	74 14                	je     80105168 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105154:	85 db                	test   %ebx,%ebx
80105156:	74 02                	je     8010515a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105158:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010515a:	89 06                	mov    %eax,(%esi)
  return 0;
8010515c:	31 c0                	xor    %eax,%eax
}
8010515e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105161:	5b                   	pop    %ebx
80105162:	5e                   	pop    %esi
80105163:	5d                   	pop    %ebp
80105164:	c3                   	ret    
80105165:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516d:	eb ef                	jmp    8010515e <argfd.constprop.0+0x3e>
8010516f:	90                   	nop

80105170 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105170:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105171:	31 c0                	xor    %eax,%eax
{
80105173:	89 e5                	mov    %esp,%ebp
80105175:	56                   	push   %esi
80105176:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105177:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010517a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010517d:	e8 9e ff ff ff       	call   80105120 <argfd.constprop.0>
80105182:	85 c0                	test   %eax,%eax
80105184:	78 42                	js     801051c8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105186:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105189:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010518b:	e8 40 ed ff ff       	call   80103ed0 <myproc>
80105190:	eb 0e                	jmp    801051a0 <sys_dup+0x30>
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105198:	83 c3 01             	add    $0x1,%ebx
8010519b:	83 fb 10             	cmp    $0x10,%ebx
8010519e:	74 28                	je     801051c8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801051a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801051a4:	85 d2                	test   %edx,%edx
801051a6:	75 f0                	jne    80105198 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801051a8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801051ac:	83 ec 0c             	sub    $0xc,%esp
801051af:	ff 75 f4             	pushl  -0xc(%ebp)
801051b2:	e8 79 bc ff ff       	call   80100e30 <filedup>
  return fd;
801051b7:	83 c4 10             	add    $0x10,%esp
}
801051ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051bd:	89 d8                	mov    %ebx,%eax
801051bf:	5b                   	pop    %ebx
801051c0:	5e                   	pop    %esi
801051c1:	5d                   	pop    %ebp
801051c2:	c3                   	ret    
801051c3:	90                   	nop
801051c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051d0:	89 d8                	mov    %ebx,%eax
801051d2:	5b                   	pop    %ebx
801051d3:	5e                   	pop    %esi
801051d4:	5d                   	pop    %ebp
801051d5:	c3                   	ret    
801051d6:	8d 76 00             	lea    0x0(%esi),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051e0 <sys_read>:

int
sys_read(void)
{
801051e0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e1:	31 c0                	xor    %eax,%eax
{
801051e3:	89 e5                	mov    %esp,%ebp
801051e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051eb:	e8 30 ff ff ff       	call   80105120 <argfd.constprop.0>
801051f0:	85 c0                	test   %eax,%eax
801051f2:	78 4c                	js     80105240 <sys_read+0x60>
801051f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f7:	83 ec 08             	sub    $0x8,%esp
801051fa:	50                   	push   %eax
801051fb:	6a 02                	push   $0x2
801051fd:	e8 ce fd ff ff       	call   80104fd0 <argint>
80105202:	83 c4 10             	add    $0x10,%esp
80105205:	85 c0                	test   %eax,%eax
80105207:	78 37                	js     80105240 <sys_read+0x60>
80105209:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520c:	83 ec 04             	sub    $0x4,%esp
8010520f:	ff 75 f0             	pushl  -0x10(%ebp)
80105212:	50                   	push   %eax
80105213:	6a 01                	push   $0x1
80105215:	e8 06 fe ff ff       	call   80105020 <argptr>
8010521a:	83 c4 10             	add    $0x10,%esp
8010521d:	85 c0                	test   %eax,%eax
8010521f:	78 1f                	js     80105240 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105221:	83 ec 04             	sub    $0x4,%esp
80105224:	ff 75 f0             	pushl  -0x10(%ebp)
80105227:	ff 75 f4             	pushl  -0xc(%ebp)
8010522a:	ff 75 ec             	pushl  -0x14(%ebp)
8010522d:	e8 6e bd ff ff       	call   80100fa0 <fileread>
80105232:	83 c4 10             	add    $0x10,%esp
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_write>:

int
sys_write(void)
{
80105250:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105251:	31 c0                	xor    %eax,%eax
{
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105258:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010525b:	e8 c0 fe ff ff       	call   80105120 <argfd.constprop.0>
80105260:	85 c0                	test   %eax,%eax
80105262:	78 4c                	js     801052b0 <sys_write+0x60>
80105264:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105267:	83 ec 08             	sub    $0x8,%esp
8010526a:	50                   	push   %eax
8010526b:	6a 02                	push   $0x2
8010526d:	e8 5e fd ff ff       	call   80104fd0 <argint>
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	85 c0                	test   %eax,%eax
80105277:	78 37                	js     801052b0 <sys_write+0x60>
80105279:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010527c:	83 ec 04             	sub    $0x4,%esp
8010527f:	ff 75 f0             	pushl  -0x10(%ebp)
80105282:	50                   	push   %eax
80105283:	6a 01                	push   $0x1
80105285:	e8 96 fd ff ff       	call   80105020 <argptr>
8010528a:	83 c4 10             	add    $0x10,%esp
8010528d:	85 c0                	test   %eax,%eax
8010528f:	78 1f                	js     801052b0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105291:	83 ec 04             	sub    $0x4,%esp
80105294:	ff 75 f0             	pushl  -0x10(%ebp)
80105297:	ff 75 f4             	pushl  -0xc(%ebp)
8010529a:	ff 75 ec             	pushl  -0x14(%ebp)
8010529d:	e8 8e bd ff ff       	call   80101030 <filewrite>
801052a2:	83 c4 10             	add    $0x10,%esp
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052b5:	c9                   	leave  
801052b6:	c3                   	ret    
801052b7:	89 f6                	mov    %esi,%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052c0 <sys_close>:

int
sys_close(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801052c6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052cc:	e8 4f fe ff ff       	call   80105120 <argfd.constprop.0>
801052d1:	85 c0                	test   %eax,%eax
801052d3:	78 2b                	js     80105300 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801052d5:	e8 f6 eb ff ff       	call   80103ed0 <myproc>
801052da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052dd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052e0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052e7:	00 
  fileclose(f);
801052e8:	ff 75 f4             	pushl  -0xc(%ebp)
801052eb:	e8 90 bb ff ff       	call   80100e80 <fileclose>
  return 0;
801052f0:	83 c4 10             	add    $0x10,%esp
801052f3:	31 c0                	xor    %eax,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105305:	c9                   	leave  
80105306:	c3                   	ret    
80105307:	89 f6                	mov    %esi,%esi
80105309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105310 <sys_fstat>:

int
sys_fstat(void)
{
80105310:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105311:	31 c0                	xor    %eax,%eax
{
80105313:	89 e5                	mov    %esp,%ebp
80105315:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105318:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010531b:	e8 00 fe ff ff       	call   80105120 <argfd.constprop.0>
80105320:	85 c0                	test   %eax,%eax
80105322:	78 2c                	js     80105350 <sys_fstat+0x40>
80105324:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105327:	83 ec 04             	sub    $0x4,%esp
8010532a:	6a 14                	push   $0x14
8010532c:	50                   	push   %eax
8010532d:	6a 01                	push   $0x1
8010532f:	e8 ec fc ff ff       	call   80105020 <argptr>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	78 15                	js     80105350 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010533b:	83 ec 08             	sub    $0x8,%esp
8010533e:	ff 75 f4             	pushl  -0xc(%ebp)
80105341:	ff 75 f0             	pushl  -0x10(%ebp)
80105344:	e8 07 bc ff ff       	call   80100f50 <filestat>
80105349:	83 c4 10             	add    $0x10,%esp
}
8010534c:	c9                   	leave  
8010534d:	c3                   	ret    
8010534e:	66 90                	xchg   %ax,%ax
    return -1;
80105350:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105355:	c9                   	leave  
80105356:	c3                   	ret    
80105357:	89 f6                	mov    %esi,%esi
80105359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105360 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105366:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105369:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010536c:	50                   	push   %eax
8010536d:	6a 00                	push   $0x0
8010536f:	e8 0c fd ff ff       	call   80105080 <argstr>
80105374:	83 c4 10             	add    $0x10,%esp
80105377:	85 c0                	test   %eax,%eax
80105379:	0f 88 fb 00 00 00    	js     8010547a <sys_link+0x11a>
8010537f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105382:	83 ec 08             	sub    $0x8,%esp
80105385:	50                   	push   %eax
80105386:	6a 01                	push   $0x1
80105388:	e8 f3 fc ff ff       	call   80105080 <argstr>
8010538d:	83 c4 10             	add    $0x10,%esp
80105390:	85 c0                	test   %eax,%eax
80105392:	0f 88 e2 00 00 00    	js     8010547a <sys_link+0x11a>
    return -1;

  begin_op();
80105398:	e8 53 de ff ff       	call   801031f0 <begin_op>
  if((ip = namei(old)) == 0){
8010539d:	83 ec 0c             	sub    $0xc,%esp
801053a0:	ff 75 d4             	pushl  -0x2c(%ebp)
801053a3:	e8 78 cb ff ff       	call   80101f20 <namei>
801053a8:	83 c4 10             	add    $0x10,%esp
801053ab:	85 c0                	test   %eax,%eax
801053ad:	89 c3                	mov    %eax,%ebx
801053af:	0f 84 ea 00 00 00    	je     8010549f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801053b5:	83 ec 0c             	sub    $0xc,%esp
801053b8:	50                   	push   %eax
801053b9:	e8 02 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
801053be:	83 c4 10             	add    $0x10,%esp
801053c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053c6:	0f 84 bb 00 00 00    	je     80105487 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801053cc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801053d1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801053d4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053d7:	53                   	push   %ebx
801053d8:	e8 33 c2 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
801053dd:	89 1c 24             	mov    %ebx,(%esp)
801053e0:	e8 bb c3 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053e5:	58                   	pop    %eax
801053e6:	5a                   	pop    %edx
801053e7:	57                   	push   %edi
801053e8:	ff 75 d0             	pushl  -0x30(%ebp)
801053eb:	e8 50 cb ff ff       	call   80101f40 <nameiparent>
801053f0:	83 c4 10             	add    $0x10,%esp
801053f3:	85 c0                	test   %eax,%eax
801053f5:	89 c6                	mov    %eax,%esi
801053f7:	74 5b                	je     80105454 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801053f9:	83 ec 0c             	sub    $0xc,%esp
801053fc:	50                   	push   %eax
801053fd:	e8 be c2 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	8b 03                	mov    (%ebx),%eax
80105407:	39 06                	cmp    %eax,(%esi)
80105409:	75 3d                	jne    80105448 <sys_link+0xe8>
8010540b:	83 ec 04             	sub    $0x4,%esp
8010540e:	ff 73 04             	pushl  0x4(%ebx)
80105411:	57                   	push   %edi
80105412:	56                   	push   %esi
80105413:	e8 48 ca ff ff       	call   80101e60 <dirlink>
80105418:	83 c4 10             	add    $0x10,%esp
8010541b:	85 c0                	test   %eax,%eax
8010541d:	78 29                	js     80105448 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010541f:	83 ec 0c             	sub    $0xc,%esp
80105422:	56                   	push   %esi
80105423:	e8 28 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
80105428:	89 1c 24             	mov    %ebx,(%esp)
8010542b:	e8 c0 c3 ff ff       	call   801017f0 <iput>

  end_op();
80105430:	e8 2b de ff ff       	call   80103260 <end_op>

  return 0;
80105435:	83 c4 10             	add    $0x10,%esp
80105438:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010543a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010543d:	5b                   	pop    %ebx
8010543e:	5e                   	pop    %esi
8010543f:	5f                   	pop    %edi
80105440:	5d                   	pop    %ebp
80105441:	c3                   	ret    
80105442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105448:	83 ec 0c             	sub    $0xc,%esp
8010544b:	56                   	push   %esi
8010544c:	e8 ff c4 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105451:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	53                   	push   %ebx
80105458:	e8 63 c2 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
8010545d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105462:	89 1c 24             	mov    %ebx,(%esp)
80105465:	e8 a6 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010546a:	89 1c 24             	mov    %ebx,(%esp)
8010546d:	e8 de c4 ff ff       	call   80101950 <iunlockput>
  end_op();
80105472:	e8 e9 dd ff ff       	call   80103260 <end_op>
  return -1;
80105477:	83 c4 10             	add    $0x10,%esp
}
8010547a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010547d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105482:	5b                   	pop    %ebx
80105483:	5e                   	pop    %esi
80105484:	5f                   	pop    %edi
80105485:	5d                   	pop    %ebp
80105486:	c3                   	ret    
    iunlockput(ip);
80105487:	83 ec 0c             	sub    $0xc,%esp
8010548a:	53                   	push   %ebx
8010548b:	e8 c0 c4 ff ff       	call   80101950 <iunlockput>
    end_op();
80105490:	e8 cb dd ff ff       	call   80103260 <end_op>
    return -1;
80105495:	83 c4 10             	add    $0x10,%esp
80105498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010549d:	eb 9b                	jmp    8010543a <sys_link+0xda>
    end_op();
8010549f:	e8 bc dd ff ff       	call   80103260 <end_op>
    return -1;
801054a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a9:	eb 8f                	jmp    8010543a <sys_link+0xda>
801054ab:	90                   	nop
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054b0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	57                   	push   %edi
801054b4:	56                   	push   %esi
801054b5:	53                   	push   %ebx
801054b6:	83 ec 1c             	sub    $0x1c,%esp
801054b9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054bc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801054c0:	76 3e                	jbe    80105500 <isdirempty+0x50>
801054c2:	bb 20 00 00 00       	mov    $0x20,%ebx
801054c7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054ca:	eb 0c                	jmp    801054d8 <isdirempty+0x28>
801054cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054d0:	83 c3 10             	add    $0x10,%ebx
801054d3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801054d6:	73 28                	jae    80105500 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054d8:	6a 10                	push   $0x10
801054da:	53                   	push   %ebx
801054db:	57                   	push   %edi
801054dc:	56                   	push   %esi
801054dd:	e8 be c4 ff ff       	call   801019a0 <readi>
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	83 f8 10             	cmp    $0x10,%eax
801054e8:	75 23                	jne    8010550d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054ef:	74 df                	je     801054d0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801054f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801054f4:	31 c0                	xor    %eax,%eax
}
801054f6:	5b                   	pop    %ebx
801054f7:	5e                   	pop    %esi
801054f8:	5f                   	pop    %edi
801054f9:	5d                   	pop    %ebp
801054fa:	c3                   	ret    
801054fb:	90                   	nop
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105500:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105503:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105508:	5b                   	pop    %ebx
80105509:	5e                   	pop    %esi
8010550a:	5f                   	pop    %edi
8010550b:	5d                   	pop    %ebp
8010550c:	c3                   	ret    
      panic("isdirempty: readi");
8010550d:	83 ec 0c             	sub    $0xc,%esp
80105510:	68 40 87 10 80       	push   $0x80108740
80105515:	e8 76 ae ff ff       	call   80100390 <panic>
8010551a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105520 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	57                   	push   %edi
80105524:	56                   	push   %esi
80105525:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105526:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105529:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010552c:	50                   	push   %eax
8010552d:	6a 00                	push   $0x0
8010552f:	e8 4c fb ff ff       	call   80105080 <argstr>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	0f 88 51 01 00 00    	js     80105690 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010553f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105542:	e8 a9 dc ff ff       	call   801031f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105547:	83 ec 08             	sub    $0x8,%esp
8010554a:	53                   	push   %ebx
8010554b:	ff 75 c0             	pushl  -0x40(%ebp)
8010554e:	e8 ed c9 ff ff       	call   80101f40 <nameiparent>
80105553:	83 c4 10             	add    $0x10,%esp
80105556:	85 c0                	test   %eax,%eax
80105558:	89 c6                	mov    %eax,%esi
8010555a:	0f 84 37 01 00 00    	je     80105697 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105560:	83 ec 0c             	sub    $0xc,%esp
80105563:	50                   	push   %eax
80105564:	e8 57 c1 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105569:	58                   	pop    %eax
8010556a:	5a                   	pop    %edx
8010556b:	68 dd 80 10 80       	push   $0x801080dd
80105570:	53                   	push   %ebx
80105571:	e8 5a c6 ff ff       	call   80101bd0 <namecmp>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	0f 84 d7 00 00 00    	je     80105658 <sys_unlink+0x138>
80105581:	83 ec 08             	sub    $0x8,%esp
80105584:	68 dc 80 10 80       	push   $0x801080dc
80105589:	53                   	push   %ebx
8010558a:	e8 41 c6 ff ff       	call   80101bd0 <namecmp>
8010558f:	83 c4 10             	add    $0x10,%esp
80105592:	85 c0                	test   %eax,%eax
80105594:	0f 84 be 00 00 00    	je     80105658 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010559a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010559d:	83 ec 04             	sub    $0x4,%esp
801055a0:	50                   	push   %eax
801055a1:	53                   	push   %ebx
801055a2:	56                   	push   %esi
801055a3:	e8 48 c6 ff ff       	call   80101bf0 <dirlookup>
801055a8:	83 c4 10             	add    $0x10,%esp
801055ab:	85 c0                	test   %eax,%eax
801055ad:	89 c3                	mov    %eax,%ebx
801055af:	0f 84 a3 00 00 00    	je     80105658 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801055b5:	83 ec 0c             	sub    $0xc,%esp
801055b8:	50                   	push   %eax
801055b9:	e8 02 c1 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055c6:	0f 8e e4 00 00 00    	jle    801056b0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055d1:	74 65                	je     80105638 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055d3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055d6:	83 ec 04             	sub    $0x4,%esp
801055d9:	6a 10                	push   $0x10
801055db:	6a 00                	push   $0x0
801055dd:	57                   	push   %edi
801055de:	e8 ed f6 ff ff       	call   80104cd0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055e3:	6a 10                	push   $0x10
801055e5:	ff 75 c4             	pushl  -0x3c(%ebp)
801055e8:	57                   	push   %edi
801055e9:	56                   	push   %esi
801055ea:	e8 b1 c4 ff ff       	call   80101aa0 <writei>
801055ef:	83 c4 20             	add    $0x20,%esp
801055f2:	83 f8 10             	cmp    $0x10,%eax
801055f5:	0f 85 a8 00 00 00    	jne    801056a3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055fb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105600:	74 6e                	je     80105670 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105602:	83 ec 0c             	sub    $0xc,%esp
80105605:	56                   	push   %esi
80105606:	e8 45 c3 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
8010560b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105610:	89 1c 24             	mov    %ebx,(%esp)
80105613:	e8 f8 bf ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80105618:	89 1c 24             	mov    %ebx,(%esp)
8010561b:	e8 30 c3 ff ff       	call   80101950 <iunlockput>

  end_op();
80105620:	e8 3b dc ff ff       	call   80103260 <end_op>

  return 0;
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010562a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010562d:	5b                   	pop    %ebx
8010562e:	5e                   	pop    %esi
8010562f:	5f                   	pop    %edi
80105630:	5d                   	pop    %ebp
80105631:	c3                   	ret    
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	53                   	push   %ebx
8010563c:	e8 6f fe ff ff       	call   801054b0 <isdirempty>
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	85 c0                	test   %eax,%eax
80105646:	75 8b                	jne    801055d3 <sys_unlink+0xb3>
    iunlockput(ip);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	53                   	push   %ebx
8010564c:	e8 ff c2 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105658:	83 ec 0c             	sub    $0xc,%esp
8010565b:	56                   	push   %esi
8010565c:	e8 ef c2 ff ff       	call   80101950 <iunlockput>
  end_op();
80105661:	e8 fa db ff ff       	call   80103260 <end_op>
  return -1;
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010566e:	eb ba                	jmp    8010562a <sys_unlink+0x10a>
    dp->nlink--;
80105670:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105675:	83 ec 0c             	sub    $0xc,%esp
80105678:	56                   	push   %esi
80105679:	e8 92 bf ff ff       	call   80101610 <iupdate>
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	e9 7c ff ff ff       	jmp    80105602 <sys_unlink+0xe2>
80105686:	8d 76 00             	lea    0x0(%esi),%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105695:	eb 93                	jmp    8010562a <sys_unlink+0x10a>
    end_op();
80105697:	e8 c4 db ff ff       	call   80103260 <end_op>
    return -1;
8010569c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a1:	eb 87                	jmp    8010562a <sys_unlink+0x10a>
    panic("unlink: writei");
801056a3:	83 ec 0c             	sub    $0xc,%esp
801056a6:	68 f1 80 10 80       	push   $0x801080f1
801056ab:	e8 e0 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801056b0:	83 ec 0c             	sub    $0xc,%esp
801056b3:	68 df 80 10 80       	push   $0x801080df
801056b8:	e8 d3 ac ff ff       	call   80100390 <panic>
801056bd:	8d 76 00             	lea    0x0(%esi),%esi

801056c0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056c6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056c9:	83 ec 34             	sub    $0x34,%esp
801056cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801056cf:	8b 55 10             	mov    0x10(%ebp),%edx
801056d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056d5:	56                   	push   %esi
801056d6:	ff 75 08             	pushl  0x8(%ebp)
{
801056d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801056dc:	89 55 d0             	mov    %edx,-0x30(%ebp)
801056df:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056e2:	e8 59 c8 ff ff       	call   80101f40 <nameiparent>
801056e7:	83 c4 10             	add    $0x10,%esp
801056ea:	85 c0                	test   %eax,%eax
801056ec:	0f 84 4e 01 00 00    	je     80105840 <create+0x180>
    return 0;
  ilock(dp);
801056f2:	83 ec 0c             	sub    $0xc,%esp
801056f5:	89 c3                	mov    %eax,%ebx
801056f7:	50                   	push   %eax
801056f8:	e8 c3 bf ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801056fd:	83 c4 0c             	add    $0xc,%esp
80105700:	6a 00                	push   $0x0
80105702:	56                   	push   %esi
80105703:	53                   	push   %ebx
80105704:	e8 e7 c4 ff ff       	call   80101bf0 <dirlookup>
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	85 c0                	test   %eax,%eax
8010570e:	89 c7                	mov    %eax,%edi
80105710:	74 3e                	je     80105750 <create+0x90>
    iunlockput(dp);
80105712:	83 ec 0c             	sub    $0xc,%esp
80105715:	53                   	push   %ebx
80105716:	e8 35 c2 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
8010571b:	89 3c 24             	mov    %edi,(%esp)
8010571e:	e8 9d bf ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105723:	83 c4 10             	add    $0x10,%esp
80105726:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010572b:	0f 85 9f 00 00 00    	jne    801057d0 <create+0x110>
80105731:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105736:	0f 85 94 00 00 00    	jne    801057d0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010573c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010573f:	89 f8                	mov    %edi,%eax
80105741:	5b                   	pop    %ebx
80105742:	5e                   	pop    %esi
80105743:	5f                   	pop    %edi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d 76 00             	lea    0x0(%esi),%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105750:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105754:	83 ec 08             	sub    $0x8,%esp
80105757:	50                   	push   %eax
80105758:	ff 33                	pushl  (%ebx)
8010575a:	e8 f1 bd ff ff       	call   80101550 <ialloc>
8010575f:	83 c4 10             	add    $0x10,%esp
80105762:	85 c0                	test   %eax,%eax
80105764:	89 c7                	mov    %eax,%edi
80105766:	0f 84 e8 00 00 00    	je     80105854 <create+0x194>
  ilock(ip);
8010576c:	83 ec 0c             	sub    $0xc,%esp
8010576f:	50                   	push   %eax
80105770:	e8 4b bf ff ff       	call   801016c0 <ilock>
  ip->major = major;
80105775:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105779:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010577d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105781:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105785:	b8 01 00 00 00       	mov    $0x1,%eax
8010578a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010578e:	89 3c 24             	mov    %edi,(%esp)
80105791:	e8 7a be ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105796:	83 c4 10             	add    $0x10,%esp
80105799:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010579e:	74 50                	je     801057f0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801057a0:	83 ec 04             	sub    $0x4,%esp
801057a3:	ff 77 04             	pushl  0x4(%edi)
801057a6:	56                   	push   %esi
801057a7:	53                   	push   %ebx
801057a8:	e8 b3 c6 ff ff       	call   80101e60 <dirlink>
801057ad:	83 c4 10             	add    $0x10,%esp
801057b0:	85 c0                	test   %eax,%eax
801057b2:	0f 88 8f 00 00 00    	js     80105847 <create+0x187>
  iunlockput(dp);
801057b8:	83 ec 0c             	sub    $0xc,%esp
801057bb:	53                   	push   %ebx
801057bc:	e8 8f c1 ff ff       	call   80101950 <iunlockput>
  return ip;
801057c1:	83 c4 10             	add    $0x10,%esp
}
801057c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057c7:	89 f8                	mov    %edi,%eax
801057c9:	5b                   	pop    %ebx
801057ca:	5e                   	pop    %esi
801057cb:	5f                   	pop    %edi
801057cc:	5d                   	pop    %ebp
801057cd:	c3                   	ret    
801057ce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	57                   	push   %edi
    return 0;
801057d4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057d6:	e8 75 c1 ff ff       	call   80101950 <iunlockput>
    return 0;
801057db:	83 c4 10             	add    $0x10,%esp
}
801057de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e1:	89 f8                	mov    %edi,%eax
801057e3:	5b                   	pop    %ebx
801057e4:	5e                   	pop    %esi
801057e5:	5f                   	pop    %edi
801057e6:	5d                   	pop    %ebp
801057e7:	c3                   	ret    
801057e8:	90                   	nop
801057e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057f0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057f5:	83 ec 0c             	sub    $0xc,%esp
801057f8:	53                   	push   %ebx
801057f9:	e8 12 be ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057fe:	83 c4 0c             	add    $0xc,%esp
80105801:	ff 77 04             	pushl  0x4(%edi)
80105804:	68 dd 80 10 80       	push   $0x801080dd
80105809:	57                   	push   %edi
8010580a:	e8 51 c6 ff ff       	call   80101e60 <dirlink>
8010580f:	83 c4 10             	add    $0x10,%esp
80105812:	85 c0                	test   %eax,%eax
80105814:	78 1c                	js     80105832 <create+0x172>
80105816:	83 ec 04             	sub    $0x4,%esp
80105819:	ff 73 04             	pushl  0x4(%ebx)
8010581c:	68 dc 80 10 80       	push   $0x801080dc
80105821:	57                   	push   %edi
80105822:	e8 39 c6 ff ff       	call   80101e60 <dirlink>
80105827:	83 c4 10             	add    $0x10,%esp
8010582a:	85 c0                	test   %eax,%eax
8010582c:	0f 89 6e ff ff ff    	jns    801057a0 <create+0xe0>
      panic("create dots");
80105832:	83 ec 0c             	sub    $0xc,%esp
80105835:	68 61 87 10 80       	push   $0x80108761
8010583a:	e8 51 ab ff ff       	call   80100390 <panic>
8010583f:	90                   	nop
    return 0;
80105840:	31 ff                	xor    %edi,%edi
80105842:	e9 f5 fe ff ff       	jmp    8010573c <create+0x7c>
    panic("create: dirlink");
80105847:	83 ec 0c             	sub    $0xc,%esp
8010584a:	68 6d 87 10 80       	push   $0x8010876d
8010584f:	e8 3c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105854:	83 ec 0c             	sub    $0xc,%esp
80105857:	68 52 87 10 80       	push   $0x80108752
8010585c:	e8 2f ab ff ff       	call   80100390 <panic>
80105861:	eb 0d                	jmp    80105870 <sys_open>
80105863:	90                   	nop
80105864:	90                   	nop
80105865:	90                   	nop
80105866:	90                   	nop
80105867:	90                   	nop
80105868:	90                   	nop
80105869:	90                   	nop
8010586a:	90                   	nop
8010586b:	90                   	nop
8010586c:	90                   	nop
8010586d:	90                   	nop
8010586e:	90                   	nop
8010586f:	90                   	nop

80105870 <sys_open>:

int
sys_open(void)
{
80105870:	55                   	push   %ebp
80105871:	89 e5                	mov    %esp,%ebp
80105873:	57                   	push   %edi
80105874:	56                   	push   %esi
80105875:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105876:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105879:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010587c:	50                   	push   %eax
8010587d:	6a 00                	push   $0x0
8010587f:	e8 fc f7 ff ff       	call   80105080 <argstr>
80105884:	83 c4 10             	add    $0x10,%esp
80105887:	85 c0                	test   %eax,%eax
80105889:	0f 88 1d 01 00 00    	js     801059ac <sys_open+0x13c>
8010588f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105892:	83 ec 08             	sub    $0x8,%esp
80105895:	50                   	push   %eax
80105896:	6a 01                	push   $0x1
80105898:	e8 33 f7 ff ff       	call   80104fd0 <argint>
8010589d:	83 c4 10             	add    $0x10,%esp
801058a0:	85 c0                	test   %eax,%eax
801058a2:	0f 88 04 01 00 00    	js     801059ac <sys_open+0x13c>
    return -1;

  begin_op();
801058a8:	e8 43 d9 ff ff       	call   801031f0 <begin_op>

  if(omode & O_CREATE){
801058ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058b1:	0f 85 a9 00 00 00    	jne    80105960 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058b7:	83 ec 0c             	sub    $0xc,%esp
801058ba:	ff 75 e0             	pushl  -0x20(%ebp)
801058bd:	e8 5e c6 ff ff       	call   80101f20 <namei>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	89 c6                	mov    %eax,%esi
801058c9:	0f 84 ac 00 00 00    	je     8010597b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801058cf:	83 ec 0c             	sub    $0xc,%esp
801058d2:	50                   	push   %eax
801058d3:	e8 e8 bd ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058d8:	83 c4 10             	add    $0x10,%esp
801058db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058e0:	0f 84 aa 00 00 00    	je     80105990 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058e6:	e8 d5 b4 ff ff       	call   80100dc0 <filealloc>
801058eb:	85 c0                	test   %eax,%eax
801058ed:	89 c7                	mov    %eax,%edi
801058ef:	0f 84 a6 00 00 00    	je     8010599b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058f5:	e8 d6 e5 ff ff       	call   80103ed0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058fa:	31 db                	xor    %ebx,%ebx
801058fc:	eb 0e                	jmp    8010590c <sys_open+0x9c>
801058fe:	66 90                	xchg   %ax,%ax
80105900:	83 c3 01             	add    $0x1,%ebx
80105903:	83 fb 10             	cmp    $0x10,%ebx
80105906:	0f 84 ac 00 00 00    	je     801059b8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010590c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105910:	85 d2                	test   %edx,%edx
80105912:	75 ec                	jne    80105900 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105914:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105917:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010591b:	56                   	push   %esi
8010591c:	e8 7f be ff ff       	call   801017a0 <iunlock>
  end_op();
80105921:	e8 3a d9 ff ff       	call   80103260 <end_op>

  f->type = FD_INODE;
80105926:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010592c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010592f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105932:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105935:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010593c:	89 d0                	mov    %edx,%eax
8010593e:	f7 d0                	not    %eax
80105940:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105943:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105946:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105949:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010594d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105950:	89 d8                	mov    %ebx,%eax
80105952:	5b                   	pop    %ebx
80105953:	5e                   	pop    %esi
80105954:	5f                   	pop    %edi
80105955:	5d                   	pop    %ebp
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105960:	6a 00                	push   $0x0
80105962:	6a 00                	push   $0x0
80105964:	6a 02                	push   $0x2
80105966:	ff 75 e0             	pushl  -0x20(%ebp)
80105969:	e8 52 fd ff ff       	call   801056c0 <create>
    if(ip == 0){
8010596e:	83 c4 10             	add    $0x10,%esp
80105971:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105973:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105975:	0f 85 6b ff ff ff    	jne    801058e6 <sys_open+0x76>
      end_op();
8010597b:	e8 e0 d8 ff ff       	call   80103260 <end_op>
      return -1;
80105980:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105985:	eb c6                	jmp    8010594d <sys_open+0xdd>
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105990:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105993:	85 c9                	test   %ecx,%ecx
80105995:	0f 84 4b ff ff ff    	je     801058e6 <sys_open+0x76>
    iunlockput(ip);
8010599b:	83 ec 0c             	sub    $0xc,%esp
8010599e:	56                   	push   %esi
8010599f:	e8 ac bf ff ff       	call   80101950 <iunlockput>
    end_op();
801059a4:	e8 b7 d8 ff ff       	call   80103260 <end_op>
    return -1;
801059a9:	83 c4 10             	add    $0x10,%esp
801059ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059b1:	eb 9a                	jmp    8010594d <sys_open+0xdd>
801059b3:	90                   	nop
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	57                   	push   %edi
801059bc:	e8 bf b4 ff ff       	call   80100e80 <fileclose>
801059c1:	83 c4 10             	add    $0x10,%esp
801059c4:	eb d5                	jmp    8010599b <sys_open+0x12b>
801059c6:	8d 76 00             	lea    0x0(%esi),%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059d6:	e8 15 d8 ff ff       	call   801031f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059de:	83 ec 08             	sub    $0x8,%esp
801059e1:	50                   	push   %eax
801059e2:	6a 00                	push   $0x0
801059e4:	e8 97 f6 ff ff       	call   80105080 <argstr>
801059e9:	83 c4 10             	add    $0x10,%esp
801059ec:	85 c0                	test   %eax,%eax
801059ee:	78 30                	js     80105a20 <sys_mkdir+0x50>
801059f0:	6a 00                	push   $0x0
801059f2:	6a 00                	push   $0x0
801059f4:	6a 01                	push   $0x1
801059f6:	ff 75 f4             	pushl  -0xc(%ebp)
801059f9:	e8 c2 fc ff ff       	call   801056c0 <create>
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	85 c0                	test   %eax,%eax
80105a03:	74 1b                	je     80105a20 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a05:	83 ec 0c             	sub    $0xc,%esp
80105a08:	50                   	push   %eax
80105a09:	e8 42 bf ff ff       	call   80101950 <iunlockput>
  end_op();
80105a0e:	e8 4d d8 ff ff       	call   80103260 <end_op>
  return 0;
80105a13:	83 c4 10             	add    $0x10,%esp
80105a16:	31 c0                	xor    %eax,%eax
}
80105a18:	c9                   	leave  
80105a19:	c3                   	ret    
80105a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a20:	e8 3b d8 ff ff       	call   80103260 <end_op>
    return -1;
80105a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a2a:	c9                   	leave  
80105a2b:	c3                   	ret    
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_mknod>:

int
sys_mknod(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a36:	e8 b5 d7 ff ff       	call   801031f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a3b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a3e:	83 ec 08             	sub    $0x8,%esp
80105a41:	50                   	push   %eax
80105a42:	6a 00                	push   $0x0
80105a44:	e8 37 f6 ff ff       	call   80105080 <argstr>
80105a49:	83 c4 10             	add    $0x10,%esp
80105a4c:	85 c0                	test   %eax,%eax
80105a4e:	78 60                	js     80105ab0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a50:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a53:	83 ec 08             	sub    $0x8,%esp
80105a56:	50                   	push   %eax
80105a57:	6a 01                	push   $0x1
80105a59:	e8 72 f5 ff ff       	call   80104fd0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	85 c0                	test   %eax,%eax
80105a63:	78 4b                	js     80105ab0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a65:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a68:	83 ec 08             	sub    $0x8,%esp
80105a6b:	50                   	push   %eax
80105a6c:	6a 02                	push   $0x2
80105a6e:	e8 5d f5 ff ff       	call   80104fd0 <argint>
     argint(1, &major) < 0 ||
80105a73:	83 c4 10             	add    $0x10,%esp
80105a76:	85 c0                	test   %eax,%eax
80105a78:	78 36                	js     80105ab0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a7a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a7e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a7f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a83:	50                   	push   %eax
80105a84:	6a 03                	push   $0x3
80105a86:	ff 75 ec             	pushl  -0x14(%ebp)
80105a89:	e8 32 fc ff ff       	call   801056c0 <create>
80105a8e:	83 c4 10             	add    $0x10,%esp
80105a91:	85 c0                	test   %eax,%eax
80105a93:	74 1b                	je     80105ab0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a95:	83 ec 0c             	sub    $0xc,%esp
80105a98:	50                   	push   %eax
80105a99:	e8 b2 be ff ff       	call   80101950 <iunlockput>
  end_op();
80105a9e:	e8 bd d7 ff ff       	call   80103260 <end_op>
  return 0;
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	31 c0                	xor    %eax,%eax
}
80105aa8:	c9                   	leave  
80105aa9:	c3                   	ret    
80105aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105ab0:	e8 ab d7 ff ff       	call   80103260 <end_op>
    return -1;
80105ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aba:	c9                   	leave  
80105abb:	c3                   	ret    
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <sys_chdir>:

int
sys_chdir(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	56                   	push   %esi
80105ac4:	53                   	push   %ebx
80105ac5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ac8:	e8 03 e4 ff ff       	call   80103ed0 <myproc>
80105acd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105acf:	e8 1c d7 ff ff       	call   801031f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ad4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ad7:	83 ec 08             	sub    $0x8,%esp
80105ada:	50                   	push   %eax
80105adb:	6a 00                	push   $0x0
80105add:	e8 9e f5 ff ff       	call   80105080 <argstr>
80105ae2:	83 c4 10             	add    $0x10,%esp
80105ae5:	85 c0                	test   %eax,%eax
80105ae7:	78 77                	js     80105b60 <sys_chdir+0xa0>
80105ae9:	83 ec 0c             	sub    $0xc,%esp
80105aec:	ff 75 f4             	pushl  -0xc(%ebp)
80105aef:	e8 2c c4 ff ff       	call   80101f20 <namei>
80105af4:	83 c4 10             	add    $0x10,%esp
80105af7:	85 c0                	test   %eax,%eax
80105af9:	89 c3                	mov    %eax,%ebx
80105afb:	74 63                	je     80105b60 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105afd:	83 ec 0c             	sub    $0xc,%esp
80105b00:	50                   	push   %eax
80105b01:	e8 ba bb ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105b06:	83 c4 10             	add    $0x10,%esp
80105b09:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b0e:	75 30                	jne    80105b40 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b10:	83 ec 0c             	sub    $0xc,%esp
80105b13:	53                   	push   %ebx
80105b14:	e8 87 bc ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105b19:	58                   	pop    %eax
80105b1a:	ff 76 68             	pushl  0x68(%esi)
80105b1d:	e8 ce bc ff ff       	call   801017f0 <iput>
  end_op();
80105b22:	e8 39 d7 ff ff       	call   80103260 <end_op>
  curproc->cwd = ip;
80105b27:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b2a:	83 c4 10             	add    $0x10,%esp
80105b2d:	31 c0                	xor    %eax,%eax
}
80105b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b32:	5b                   	pop    %ebx
80105b33:	5e                   	pop    %esi
80105b34:	5d                   	pop    %ebp
80105b35:	c3                   	ret    
80105b36:	8d 76 00             	lea    0x0(%esi),%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	53                   	push   %ebx
80105b44:	e8 07 be ff ff       	call   80101950 <iunlockput>
    end_op();
80105b49:	e8 12 d7 ff ff       	call   80103260 <end_op>
    return -1;
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b56:	eb d7                	jmp    80105b2f <sys_chdir+0x6f>
80105b58:	90                   	nop
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b60:	e8 fb d6 ff ff       	call   80103260 <end_op>
    return -1;
80105b65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b6a:	eb c3                	jmp    80105b2f <sys_chdir+0x6f>
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b70 <sys_exec>:

int
sys_exec(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
80105b73:	57                   	push   %edi
80105b74:	56                   	push   %esi
80105b75:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b76:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b7c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b82:	50                   	push   %eax
80105b83:	6a 00                	push   $0x0
80105b85:	e8 f6 f4 ff ff       	call   80105080 <argstr>
80105b8a:	83 c4 10             	add    $0x10,%esp
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	0f 88 87 00 00 00    	js     80105c1c <sys_exec+0xac>
80105b95:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b9b:	83 ec 08             	sub    $0x8,%esp
80105b9e:	50                   	push   %eax
80105b9f:	6a 01                	push   $0x1
80105ba1:	e8 2a f4 ff ff       	call   80104fd0 <argint>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	78 6f                	js     80105c1c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bb3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105bb6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bb8:	68 80 00 00 00       	push   $0x80
80105bbd:	6a 00                	push   $0x0
80105bbf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bc5:	50                   	push   %eax
80105bc6:	e8 05 f1 ff ff       	call   80104cd0 <memset>
80105bcb:	83 c4 10             	add    $0x10,%esp
80105bce:	eb 2c                	jmp    80105bfc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bd0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bd6:	85 c0                	test   %eax,%eax
80105bd8:	74 56                	je     80105c30 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bda:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105be0:	83 ec 08             	sub    $0x8,%esp
80105be3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105be6:	52                   	push   %edx
80105be7:	50                   	push   %eax
80105be8:	e8 73 f3 ff ff       	call   80104f60 <fetchstr>
80105bed:	83 c4 10             	add    $0x10,%esp
80105bf0:	85 c0                	test   %eax,%eax
80105bf2:	78 28                	js     80105c1c <sys_exec+0xac>
  for(i=0;; i++){
80105bf4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105bf7:	83 fb 20             	cmp    $0x20,%ebx
80105bfa:	74 20                	je     80105c1c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bfc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c02:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c09:	83 ec 08             	sub    $0x8,%esp
80105c0c:	57                   	push   %edi
80105c0d:	01 f0                	add    %esi,%eax
80105c0f:	50                   	push   %eax
80105c10:	e8 0b f3 ff ff       	call   80104f20 <fetchint>
80105c15:	83 c4 10             	add    $0x10,%esp
80105c18:	85 c0                	test   %eax,%eax
80105c1a:	79 b4                	jns    80105bd0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c24:	5b                   	pop    %ebx
80105c25:	5e                   	pop    %esi
80105c26:	5f                   	pop    %edi
80105c27:	5d                   	pop    %ebp
80105c28:	c3                   	ret    
80105c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c30:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c36:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c39:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c40:	00 00 00 00 
  return exec(path, argv);
80105c44:	50                   	push   %eax
80105c45:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c4b:	e8 c0 ad ff ff       	call   80100a10 <exec>
80105c50:	83 c4 10             	add    $0x10,%esp
}
80105c53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c56:	5b                   	pop    %ebx
80105c57:	5e                   	pop    %esi
80105c58:	5f                   	pop    %edi
80105c59:	5d                   	pop    %ebp
80105c5a:	c3                   	ret    
80105c5b:	90                   	nop
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c60 <sys_pipe>:

int
sys_pipe(void)
{
80105c60:	55                   	push   %ebp
80105c61:	89 e5                	mov    %esp,%ebp
80105c63:	57                   	push   %edi
80105c64:	56                   	push   %esi
80105c65:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c66:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c69:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c6c:	6a 08                	push   $0x8
80105c6e:	50                   	push   %eax
80105c6f:	6a 00                	push   $0x0
80105c71:	e8 aa f3 ff ff       	call   80105020 <argptr>
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	85 c0                	test   %eax,%eax
80105c7b:	0f 88 ae 00 00 00    	js     80105d2f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c81:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c84:	83 ec 08             	sub    $0x8,%esp
80105c87:	50                   	push   %eax
80105c88:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c8b:	50                   	push   %eax
80105c8c:	e8 ff db ff ff       	call   80103890 <pipealloc>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	0f 88 93 00 00 00    	js     80105d2f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c9c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c9f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105ca1:	e8 2a e2 ff ff       	call   80103ed0 <myproc>
80105ca6:	eb 10                	jmp    80105cb8 <sys_pipe+0x58>
80105ca8:	90                   	nop
80105ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105cb0:	83 c3 01             	add    $0x1,%ebx
80105cb3:	83 fb 10             	cmp    $0x10,%ebx
80105cb6:	74 60                	je     80105d18 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105cb8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cbc:	85 f6                	test   %esi,%esi
80105cbe:	75 f0                	jne    80105cb0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cc0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cc3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cc7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cca:	e8 01 e2 ff ff       	call   80103ed0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ccf:	31 d2                	xor    %edx,%edx
80105cd1:	eb 0d                	jmp    80105ce0 <sys_pipe+0x80>
80105cd3:	90                   	nop
80105cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cd8:	83 c2 01             	add    $0x1,%edx
80105cdb:	83 fa 10             	cmp    $0x10,%edx
80105cde:	74 28                	je     80105d08 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105ce0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ce4:	85 c9                	test   %ecx,%ecx
80105ce6:	75 f0                	jne    80105cd8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105ce8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cec:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105cf1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cf4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105cf7:	31 c0                	xor    %eax,%eax
}
80105cf9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cfc:	5b                   	pop    %ebx
80105cfd:	5e                   	pop    %esi
80105cfe:	5f                   	pop    %edi
80105cff:	5d                   	pop    %ebp
80105d00:	c3                   	ret    
80105d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105d08:	e8 c3 e1 ff ff       	call   80103ed0 <myproc>
80105d0d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d14:	00 
80105d15:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d18:	83 ec 0c             	sub    $0xc,%esp
80105d1b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d1e:	e8 5d b1 ff ff       	call   80100e80 <fileclose>
    fileclose(wf);
80105d23:	58                   	pop    %eax
80105d24:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d27:	e8 54 b1 ff ff       	call   80100e80 <fileclose>
    return -1;
80105d2c:	83 c4 10             	add    $0x10,%esp
80105d2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d34:	eb c3                	jmp    80105cf9 <sys_pipe+0x99>
80105d36:	66 90                	xchg   %ax,%ax
80105d38:	66 90                	xchg   %ax,%ax
80105d3a:	66 90                	xchg   %ax,%ax
80105d3c:	66 90                	xchg   %ax,%ax
80105d3e:	66 90                	xchg   %ax,%ax

80105d40 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d43:	5d                   	pop    %ebp
  return fork();
80105d44:	e9 27 e3 ff ff       	jmp    80104070 <fork>
80105d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d50 <sys_exit>:

int
sys_exit(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d56:	e8 95 e6 ff ff       	call   801043f0 <exit>
  return 0;  // not reached
}
80105d5b:	31 c0                	xor    %eax,%eax
80105d5d:	c9                   	leave  
80105d5e:	c3                   	ret    
80105d5f:	90                   	nop

80105d60 <sys_wait>:

int
sys_wait(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d63:	5d                   	pop    %ebp
  return wait();
80105d64:	e9 e7 e8 ff ff       	jmp    80104650 <wait>
80105d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_kill>:

int
sys_kill(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d79:	50                   	push   %eax
80105d7a:	6a 00                	push   $0x0
80105d7c:	e8 4f f2 ff ff       	call   80104fd0 <argint>
80105d81:	83 c4 10             	add    $0x10,%esp
80105d84:	85 c0                	test   %eax,%eax
80105d86:	78 18                	js     80105da0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d8e:	e8 4d ea ff ff       	call   801047e0 <kill>
80105d93:	83 c4 10             	add    $0x10,%esp
}
80105d96:	c9                   	leave  
80105d97:	c3                   	ret    
80105d98:	90                   	nop
80105d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <sys_getpid>:

int
sys_getpid(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105db6:	e8 15 e1 ff ff       	call   80103ed0 <myproc>
80105dbb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dbe:	c9                   	leave  
80105dbf:	c3                   	ret    

80105dc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105dc0:	55                   	push   %ebp
80105dc1:	89 e5                	mov    %esp,%ebp
80105dc3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105dc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105dc7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dca:	50                   	push   %eax
80105dcb:	6a 00                	push   $0x0
80105dcd:	e8 fe f1 ff ff       	call   80104fd0 <argint>
80105dd2:	83 c4 10             	add    $0x10,%esp
80105dd5:	85 c0                	test   %eax,%eax
80105dd7:	78 27                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dd9:	e8 f2 e0 ff ff       	call   80103ed0 <myproc>
  if(growproc(n) < 0)
80105dde:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105de1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105de3:	ff 75 f4             	pushl  -0xc(%ebp)
80105de6:	e8 05 e2 ff ff       	call   80103ff0 <growproc>
80105deb:	83 c4 10             	add    $0x10,%esp
80105dee:	85 c0                	test   %eax,%eax
80105df0:	78 0e                	js     80105e00 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105df2:	89 d8                	mov    %ebx,%eax
80105df4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105df7:	c9                   	leave  
80105df8:	c3                   	ret    
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e00:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e05:	eb eb                	jmp    80105df2 <sys_sbrk+0x32>
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e10 <sys_sleep>:

int
sys_sleep(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e14:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e17:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e1a:	50                   	push   %eax
80105e1b:	6a 00                	push   $0x0
80105e1d:	e8 ae f1 ff ff       	call   80104fd0 <argint>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	0f 88 8a 00 00 00    	js     80105eb7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e2d:	83 ec 0c             	sub    $0xc,%esp
80105e30:	68 a0 01 1a 80       	push   $0x801a01a0
80105e35:	e8 86 ed ff ff       	call   80104bc0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e40:	8b 1d e0 09 1a 80    	mov    0x801a09e0,%ebx
  while(ticks - ticks0 < n){
80105e46:	85 d2                	test   %edx,%edx
80105e48:	75 27                	jne    80105e71 <sys_sleep+0x61>
80105e4a:	eb 54                	jmp    80105ea0 <sys_sleep+0x90>
80105e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e50:	83 ec 08             	sub    $0x8,%esp
80105e53:	68 a0 01 1a 80       	push   $0x801a01a0
80105e58:	68 e0 09 1a 80       	push   $0x801a09e0
80105e5d:	e8 2e e7 ff ff       	call   80104590 <sleep>
  while(ticks - ticks0 < n){
80105e62:	a1 e0 09 1a 80       	mov    0x801a09e0,%eax
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	29 d8                	sub    %ebx,%eax
80105e6c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e6f:	73 2f                	jae    80105ea0 <sys_sleep+0x90>
    if(myproc()->killed){
80105e71:	e8 5a e0 ff ff       	call   80103ed0 <myproc>
80105e76:	8b 40 24             	mov    0x24(%eax),%eax
80105e79:	85 c0                	test   %eax,%eax
80105e7b:	74 d3                	je     80105e50 <sys_sleep+0x40>
      release(&tickslock);
80105e7d:	83 ec 0c             	sub    $0xc,%esp
80105e80:	68 a0 01 1a 80       	push   $0x801a01a0
80105e85:	e8 f6 ed ff ff       	call   80104c80 <release>
      return -1;
80105e8a:	83 c4 10             	add    $0x10,%esp
80105e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e95:	c9                   	leave  
80105e96:	c3                   	ret    
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	68 a0 01 1a 80       	push   $0x801a01a0
80105ea8:	e8 d3 ed ff ff       	call   80104c80 <release>
  return 0;
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	31 c0                	xor    %eax,%eax
}
80105eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105eb5:	c9                   	leave  
80105eb6:	c3                   	ret    
    return -1;
80105eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebc:	eb f4                	jmp    80105eb2 <sys_sleep+0xa2>
80105ebe:	66 90                	xchg   %ax,%ax

80105ec0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ec0:	55                   	push   %ebp
80105ec1:	89 e5                	mov    %esp,%ebp
80105ec3:	53                   	push   %ebx
80105ec4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ec7:	68 a0 01 1a 80       	push   $0x801a01a0
80105ecc:	e8 ef ec ff ff       	call   80104bc0 <acquire>
  xticks = ticks;
80105ed1:	8b 1d e0 09 1a 80    	mov    0x801a09e0,%ebx
  release(&tickslock);
80105ed7:	c7 04 24 a0 01 1a 80 	movl   $0x801a01a0,(%esp)
80105ede:	e8 9d ed ff ff       	call   80104c80 <release>
  return xticks;
}
80105ee3:	89 d8                	mov    %ebx,%eax
80105ee5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ee8:	c9                   	leave  
80105ee9:	c3                   	ret    
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ef0 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80105ef6:	e8 d5 df ff ff       	call   80103ed0 <myproc>
80105efb:	ba 10 00 00 00       	mov    $0x10,%edx
80105f00:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80105f06:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80105f07:	89 d0                	mov    %edx,%eax
}
80105f09:	c3                   	ret    
80105f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f10 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80105f13:	5d                   	pop    %ebp
  return getTotalFreePages();
80105f14:	e9 17 ea ff ff       	jmp    80104930 <getTotalFreePages>

80105f19 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f19:	1e                   	push   %ds
  pushl %es
80105f1a:	06                   	push   %es
  pushl %fs
80105f1b:	0f a0                	push   %fs
  pushl %gs
80105f1d:	0f a8                	push   %gs
  pushal
80105f1f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f20:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f24:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f26:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f28:	54                   	push   %esp
  call trap
80105f29:	e8 c2 00 00 00       	call   80105ff0 <trap>
  addl $4, %esp
80105f2e:	83 c4 04             	add    $0x4,%esp

80105f31 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f31:	61                   	popa   
  popl %gs
80105f32:	0f a9                	pop    %gs
  popl %fs
80105f34:	0f a1                	pop    %fs
  popl %es
80105f36:	07                   	pop    %es
  popl %ds
80105f37:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f38:	83 c4 08             	add    $0x8,%esp
  iret
80105f3b:	cf                   	iret   
80105f3c:	66 90                	xchg   %ax,%ax
80105f3e:	66 90                	xchg   %ax,%ax

80105f40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f41:	31 c0                	xor    %eax,%eax
{
80105f43:	89 e5                	mov    %esp,%ebp
80105f45:	83 ec 08             	sub    $0x8,%esp
80105f48:	90                   	nop
80105f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f57:	c7 04 c5 e2 01 1a 80 	movl   $0x8e000008,-0x7fe5fe1e(,%eax,8)
80105f5e:	08 00 00 8e 
80105f62:	66 89 14 c5 e0 01 1a 	mov    %dx,-0x7fe5fe20(,%eax,8)
80105f69:	80 
80105f6a:	c1 ea 10             	shr    $0x10,%edx
80105f6d:	66 89 14 c5 e6 01 1a 	mov    %dx,-0x7fe5fe1a(,%eax,8)
80105f74:	80 
  for(i = 0; i < 256; i++)
80105f75:	83 c0 01             	add    $0x1,%eax
80105f78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f7d:	75 d1                	jne    80105f50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f7f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f84:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f87:	c7 05 e2 03 1a 80 08 	movl   $0xef000008,0x801a03e2
80105f8e:	00 00 ef 
  initlock(&tickslock, "time");
80105f91:	68 7d 87 10 80       	push   $0x8010877d
80105f96:	68 a0 01 1a 80       	push   $0x801a01a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f9b:	66 a3 e0 03 1a 80    	mov    %ax,0x801a03e0
80105fa1:	c1 e8 10             	shr    $0x10,%eax
80105fa4:	66 a3 e6 03 1a 80    	mov    %ax,0x801a03e6
  initlock(&tickslock, "time");
80105faa:	e8 d1 ea ff ff       	call   80104a80 <initlock>
}
80105faf:	83 c4 10             	add    $0x10,%esp
80105fb2:	c9                   	leave  
80105fb3:	c3                   	ret    
80105fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105fc0 <idtinit>:

void
idtinit(void)
{
80105fc0:	55                   	push   %ebp
  pd[0] = size-1;
80105fc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fc6:	89 e5                	mov    %esp,%ebp
80105fc8:	83 ec 10             	sub    $0x10,%esp
80105fcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fcf:	b8 e0 01 1a 80       	mov    $0x801a01e0,%eax
80105fd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fd8:	c1 e8 10             	shr    $0x10,%eax
80105fdb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fdf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fe2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ff0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	57                   	push   %edi
80105ff4:	56                   	push   %esi
80105ff5:	53                   	push   %ebx
80105ff6:	83 ec 1c             	sub    $0x1c,%esp
80105ff9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
80105ffc:	e8 cf de ff ff       	call   80103ed0 <myproc>
80106001:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106003:	8b 47 30             	mov    0x30(%edi),%eax
80106006:	83 f8 40             	cmp    $0x40,%eax
80106009:	0f 84 e9 00 00 00    	je     801060f8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010600f:	83 e8 0e             	sub    $0xe,%eax
80106012:	83 f8 31             	cmp    $0x31,%eax
80106015:	77 09                	ja     80106020 <trap+0x30>
80106017:	ff 24 85 38 88 10 80 	jmp    *-0x7fef77c8(,%eax,4)
8010601e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106020:	e8 ab de ff ff       	call   80103ed0 <myproc>
80106025:	85 c0                	test   %eax,%eax
80106027:	0f 84 27 02 00 00    	je     80106254 <trap+0x264>
8010602d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106031:	0f 84 1d 02 00 00    	je     80106254 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106037:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010603a:	8b 57 38             	mov    0x38(%edi),%edx
8010603d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106040:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106043:	e8 68 de ff ff       	call   80103eb0 <cpuid>
80106048:	8b 77 34             	mov    0x34(%edi),%esi
8010604b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010604e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106051:	e8 7a de ff ff       	call   80103ed0 <myproc>
80106056:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106059:	e8 72 de ff ff       	call   80103ed0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010605e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106061:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106064:	51                   	push   %ecx
80106065:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106066:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106069:	ff 75 e4             	pushl  -0x1c(%ebp)
8010606c:	56                   	push   %esi
8010606d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010606e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106071:	52                   	push   %edx
80106072:	ff 70 10             	pushl  0x10(%eax)
80106075:	68 f4 87 10 80       	push   $0x801087f4
8010607a:	e8 e1 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010607f:	83 c4 20             	add    $0x20,%esp
80106082:	e8 49 de ff ff       	call   80103ed0 <myproc>
80106087:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010608e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106090:	e8 3b de ff ff       	call   80103ed0 <myproc>
80106095:	85 c0                	test   %eax,%eax
80106097:	74 1d                	je     801060b6 <trap+0xc6>
80106099:	e8 32 de ff ff       	call   80103ed0 <myproc>
8010609e:	8b 50 24             	mov    0x24(%eax),%edx
801060a1:	85 d2                	test   %edx,%edx
801060a3:	74 11                	je     801060b6 <trap+0xc6>
801060a5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060a9:	83 e0 03             	and    $0x3,%eax
801060ac:	66 83 f8 03          	cmp    $0x3,%ax
801060b0:	0f 84 5a 01 00 00    	je     80106210 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060b6:	e8 15 de ff ff       	call   80103ed0 <myproc>
801060bb:	85 c0                	test   %eax,%eax
801060bd:	74 0b                	je     801060ca <trap+0xda>
801060bf:	e8 0c de ff ff       	call   80103ed0 <myproc>
801060c4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801060c8:	74 5e                	je     80106128 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ca:	e8 01 de ff ff       	call   80103ed0 <myproc>
801060cf:	85 c0                	test   %eax,%eax
801060d1:	74 19                	je     801060ec <trap+0xfc>
801060d3:	e8 f8 dd ff ff       	call   80103ed0 <myproc>
801060d8:	8b 40 24             	mov    0x24(%eax),%eax
801060db:	85 c0                	test   %eax,%eax
801060dd:	74 0d                	je     801060ec <trap+0xfc>
801060df:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060e3:	83 e0 03             	and    $0x3,%eax
801060e6:	66 83 f8 03          	cmp    $0x3,%ax
801060ea:	74 2b                	je     80106117 <trap+0x127>
    exit();
}
801060ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060ef:	5b                   	pop    %ebx
801060f0:	5e                   	pop    %esi
801060f1:	5f                   	pop    %edi
801060f2:	5d                   	pop    %ebp
801060f3:	c3                   	ret    
801060f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
801060f8:	8b 73 24             	mov    0x24(%ebx),%esi
801060fb:	85 f6                	test   %esi,%esi
801060fd:	0f 85 fd 00 00 00    	jne    80106200 <trap+0x210>
    curproc->tf = tf;
80106103:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106106:	e8 b5 ef ff ff       	call   801050c0 <syscall>
    if(myproc()->killed)
8010610b:	e8 c0 dd ff ff       	call   80103ed0 <myproc>
80106110:	8b 58 24             	mov    0x24(%eax),%ebx
80106113:	85 db                	test   %ebx,%ebx
80106115:	74 d5                	je     801060ec <trap+0xfc>
}
80106117:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010611a:	5b                   	pop    %ebx
8010611b:	5e                   	pop    %esi
8010611c:	5f                   	pop    %edi
8010611d:	5d                   	pop    %ebp
      exit();
8010611e:	e9 cd e2 ff ff       	jmp    801043f0 <exit>
80106123:	90                   	nop
80106124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106128:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010612c:	75 9c                	jne    801060ca <trap+0xda>
    yield();
8010612e:	e8 0d e4 ff ff       	call   80104540 <yield>
80106133:	eb 95                	jmp    801060ca <trap+0xda>
80106135:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
80106138:	e8 93 dd ff ff       	call   80103ed0 <myproc>
8010613d:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106141:	0f 8e 49 ff ff ff    	jle    80106090 <trap+0xa0>
    pagefault();
80106147:	e8 64 18 00 00       	call   801079b0 <pagefault>
      if(curproc->killed) {
8010614c:	8b 4b 24             	mov    0x24(%ebx),%ecx
8010614f:	85 c9                	test   %ecx,%ecx
80106151:	0f 84 39 ff ff ff    	je     80106090 <trap+0xa0>
        cprintf("going to kill proc\n");
80106157:	83 ec 0c             	sub    $0xc,%esp
8010615a:	68 82 87 10 80       	push   $0x80108782
8010615f:	e8 fc a4 ff ff       	call   80100660 <cprintf>
        exit();
80106164:	e8 87 e2 ff ff       	call   801043f0 <exit>
80106169:	83 c4 10             	add    $0x10,%esp
8010616c:	e9 1f ff ff ff       	jmp    80106090 <trap+0xa0>
80106171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106178:	e8 33 dd ff ff       	call   80103eb0 <cpuid>
8010617d:	85 c0                	test   %eax,%eax
8010617f:	0f 84 9b 00 00 00    	je     80106220 <trap+0x230>
    lapiceoi();
80106185:	e8 16 cc ff ff       	call   80102da0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010618a:	e8 41 dd ff ff       	call   80103ed0 <myproc>
8010618f:	85 c0                	test   %eax,%eax
80106191:	0f 85 02 ff ff ff    	jne    80106099 <trap+0xa9>
80106197:	e9 1a ff ff ff       	jmp    801060b6 <trap+0xc6>
8010619c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801061a0:	e8 bb ca ff ff       	call   80102c60 <kbdintr>
    lapiceoi();
801061a5:	e8 f6 cb ff ff       	call   80102da0 <lapiceoi>
    break;
801061aa:	e9 e1 fe ff ff       	jmp    80106090 <trap+0xa0>
801061af:	90                   	nop
    uartintr();
801061b0:	e8 3b 02 00 00       	call   801063f0 <uartintr>
    lapiceoi();
801061b5:	e8 e6 cb ff ff       	call   80102da0 <lapiceoi>
    break;
801061ba:	e9 d1 fe ff ff       	jmp    80106090 <trap+0xa0>
801061bf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061c0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801061c4:	8b 77 38             	mov    0x38(%edi),%esi
801061c7:	e8 e4 dc ff ff       	call   80103eb0 <cpuid>
801061cc:	56                   	push   %esi
801061cd:	53                   	push   %ebx
801061ce:	50                   	push   %eax
801061cf:	68 9c 87 10 80       	push   $0x8010879c
801061d4:	e8 87 a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801061d9:	e8 c2 cb ff ff       	call   80102da0 <lapiceoi>
    break;
801061de:	83 c4 10             	add    $0x10,%esp
801061e1:	e9 aa fe ff ff       	jmp    80106090 <trap+0xa0>
801061e6:	8d 76 00             	lea    0x0(%esi),%esi
801061e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
801061f0:	e8 6b c2 ff ff       	call   80102460 <ideintr>
801061f5:	eb 8e                	jmp    80106185 <trap+0x195>
801061f7:	89 f6                	mov    %esi,%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106200:	e8 eb e1 ff ff       	call   801043f0 <exit>
80106205:	e9 f9 fe ff ff       	jmp    80106103 <trap+0x113>
8010620a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106210:	e8 db e1 ff ff       	call   801043f0 <exit>
80106215:	e9 9c fe ff ff       	jmp    801060b6 <trap+0xc6>
8010621a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106220:	83 ec 0c             	sub    $0xc,%esp
80106223:	68 a0 01 1a 80       	push   $0x801a01a0
80106228:	e8 93 e9 ff ff       	call   80104bc0 <acquire>
      wakeup(&ticks);
8010622d:	c7 04 24 e0 09 1a 80 	movl   $0x801a09e0,(%esp)
      ticks++;
80106234:	83 05 e0 09 1a 80 01 	addl   $0x1,0x801a09e0
      wakeup(&ticks);
8010623b:	e8 40 e5 ff ff       	call   80104780 <wakeup>
      release(&tickslock);
80106240:	c7 04 24 a0 01 1a 80 	movl   $0x801a01a0,(%esp)
80106247:	e8 34 ea ff ff       	call   80104c80 <release>
8010624c:	83 c4 10             	add    $0x10,%esp
8010624f:	e9 31 ff ff ff       	jmp    80106185 <trap+0x195>
80106254:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106257:	8b 5f 38             	mov    0x38(%edi),%ebx
8010625a:	e8 51 dc ff ff       	call   80103eb0 <cpuid>
8010625f:	83 ec 0c             	sub    $0xc,%esp
80106262:	56                   	push   %esi
80106263:	53                   	push   %ebx
80106264:	50                   	push   %eax
80106265:	ff 77 30             	pushl  0x30(%edi)
80106268:	68 c0 87 10 80       	push   $0x801087c0
8010626d:	e8 ee a3 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106272:	83 c4 14             	add    $0x14,%esp
80106275:	68 96 87 10 80       	push   $0x80108796
8010627a:	e8 11 a1 ff ff       	call   80100390 <panic>
8010627f:	90                   	nop

80106280 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106280:	a1 e0 c5 11 80       	mov    0x8011c5e0,%eax
{
80106285:	55                   	push   %ebp
80106286:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106288:	85 c0                	test   %eax,%eax
8010628a:	74 1c                	je     801062a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010628c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106291:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106292:	a8 01                	test   $0x1,%al
80106294:	74 12                	je     801062a8 <uartgetc+0x28>
80106296:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010629b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010629c:	0f b6 c0             	movzbl %al,%eax
}
8010629f:	5d                   	pop    %ebp
801062a0:	c3                   	ret    
801062a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801062a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062ad:	5d                   	pop    %ebp
801062ae:	c3                   	ret    
801062af:	90                   	nop

801062b0 <uartputc.part.0>:
uartputc(int c)
801062b0:	55                   	push   %ebp
801062b1:	89 e5                	mov    %esp,%ebp
801062b3:	57                   	push   %edi
801062b4:	56                   	push   %esi
801062b5:	53                   	push   %ebx
801062b6:	89 c7                	mov    %eax,%edi
801062b8:	bb 80 00 00 00       	mov    $0x80,%ebx
801062bd:	be fd 03 00 00       	mov    $0x3fd,%esi
801062c2:	83 ec 0c             	sub    $0xc,%esp
801062c5:	eb 1b                	jmp    801062e2 <uartputc.part.0+0x32>
801062c7:	89 f6                	mov    %esi,%esi
801062c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	6a 0a                	push   $0xa
801062d5:	e8 e6 ca ff ff       	call   80102dc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062da:	83 c4 10             	add    $0x10,%esp
801062dd:	83 eb 01             	sub    $0x1,%ebx
801062e0:	74 07                	je     801062e9 <uartputc.part.0+0x39>
801062e2:	89 f2                	mov    %esi,%edx
801062e4:	ec                   	in     (%dx),%al
801062e5:	a8 20                	test   $0x20,%al
801062e7:	74 e7                	je     801062d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062ee:	89 f8                	mov    %edi,%eax
801062f0:	ee                   	out    %al,(%dx)
}
801062f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062f4:	5b                   	pop    %ebx
801062f5:	5e                   	pop    %esi
801062f6:	5f                   	pop    %edi
801062f7:	5d                   	pop    %ebp
801062f8:	c3                   	ret    
801062f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106300 <uartinit>:
{
80106300:	55                   	push   %ebp
80106301:	31 c9                	xor    %ecx,%ecx
80106303:	89 c8                	mov    %ecx,%eax
80106305:	89 e5                	mov    %esp,%ebp
80106307:	57                   	push   %edi
80106308:	56                   	push   %esi
80106309:	53                   	push   %ebx
8010630a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010630f:	89 da                	mov    %ebx,%edx
80106311:	83 ec 0c             	sub    $0xc,%esp
80106314:	ee                   	out    %al,(%dx)
80106315:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010631a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010631f:	89 fa                	mov    %edi,%edx
80106321:	ee                   	out    %al,(%dx)
80106322:	b8 0c 00 00 00       	mov    $0xc,%eax
80106327:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010632c:	ee                   	out    %al,(%dx)
8010632d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106332:	89 c8                	mov    %ecx,%eax
80106334:	89 f2                	mov    %esi,%edx
80106336:	ee                   	out    %al,(%dx)
80106337:	b8 03 00 00 00       	mov    $0x3,%eax
8010633c:	89 fa                	mov    %edi,%edx
8010633e:	ee                   	out    %al,(%dx)
8010633f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106344:	89 c8                	mov    %ecx,%eax
80106346:	ee                   	out    %al,(%dx)
80106347:	b8 01 00 00 00       	mov    $0x1,%eax
8010634c:	89 f2                	mov    %esi,%edx
8010634e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010634f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106354:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106355:	3c ff                	cmp    $0xff,%al
80106357:	74 5a                	je     801063b3 <uartinit+0xb3>
  uart = 1;
80106359:	c7 05 e0 c5 11 80 01 	movl   $0x1,0x8011c5e0
80106360:	00 00 00 
80106363:	89 da                	mov    %ebx,%edx
80106365:	ec                   	in     (%dx),%al
80106366:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010636b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010636c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010636f:	bb 00 89 10 80       	mov    $0x80108900,%ebx
  ioapicenable(IRQ_COM1, 0);
80106374:	6a 00                	push   $0x0
80106376:	6a 04                	push   $0x4
80106378:	e8 33 c3 ff ff       	call   801026b0 <ioapicenable>
8010637d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106380:	b8 78 00 00 00       	mov    $0x78,%eax
80106385:	eb 13                	jmp    8010639a <uartinit+0x9a>
80106387:	89 f6                	mov    %esi,%esi
80106389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106390:	83 c3 01             	add    $0x1,%ebx
80106393:	0f be 03             	movsbl (%ebx),%eax
80106396:	84 c0                	test   %al,%al
80106398:	74 19                	je     801063b3 <uartinit+0xb3>
  if(!uart)
8010639a:	8b 15 e0 c5 11 80    	mov    0x8011c5e0,%edx
801063a0:	85 d2                	test   %edx,%edx
801063a2:	74 ec                	je     80106390 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801063a4:	83 c3 01             	add    $0x1,%ebx
801063a7:	e8 04 ff ff ff       	call   801062b0 <uartputc.part.0>
801063ac:	0f be 03             	movsbl (%ebx),%eax
801063af:	84 c0                	test   %al,%al
801063b1:	75 e7                	jne    8010639a <uartinit+0x9a>
}
801063b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063b6:	5b                   	pop    %ebx
801063b7:	5e                   	pop    %esi
801063b8:	5f                   	pop    %edi
801063b9:	5d                   	pop    %ebp
801063ba:	c3                   	ret    
801063bb:	90                   	nop
801063bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801063c0 <uartputc>:
  if(!uart)
801063c0:	8b 15 e0 c5 11 80    	mov    0x8011c5e0,%edx
{
801063c6:	55                   	push   %ebp
801063c7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801063c9:	85 d2                	test   %edx,%edx
{
801063cb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801063ce:	74 10                	je     801063e0 <uartputc+0x20>
}
801063d0:	5d                   	pop    %ebp
801063d1:	e9 da fe ff ff       	jmp    801062b0 <uartputc.part.0>
801063d6:	8d 76 00             	lea    0x0(%esi),%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063e0:	5d                   	pop    %ebp
801063e1:	c3                   	ret    
801063e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063f0 <uartintr>:

void
uartintr(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063f6:	68 80 62 10 80       	push   $0x80106280
801063fb:	e8 10 a4 ff ff       	call   80100810 <consoleintr>
}
80106400:	83 c4 10             	add    $0x10,%esp
80106403:	c9                   	leave  
80106404:	c3                   	ret    

80106405 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106405:	6a 00                	push   $0x0
  pushl $0
80106407:	6a 00                	push   $0x0
  jmp alltraps
80106409:	e9 0b fb ff ff       	jmp    80105f19 <alltraps>

8010640e <vector1>:
.globl vector1
vector1:
  pushl $0
8010640e:	6a 00                	push   $0x0
  pushl $1
80106410:	6a 01                	push   $0x1
  jmp alltraps
80106412:	e9 02 fb ff ff       	jmp    80105f19 <alltraps>

80106417 <vector2>:
.globl vector2
vector2:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $2
80106419:	6a 02                	push   $0x2
  jmp alltraps
8010641b:	e9 f9 fa ff ff       	jmp    80105f19 <alltraps>

80106420 <vector3>:
.globl vector3
vector3:
  pushl $0
80106420:	6a 00                	push   $0x0
  pushl $3
80106422:	6a 03                	push   $0x3
  jmp alltraps
80106424:	e9 f0 fa ff ff       	jmp    80105f19 <alltraps>

80106429 <vector4>:
.globl vector4
vector4:
  pushl $0
80106429:	6a 00                	push   $0x0
  pushl $4
8010642b:	6a 04                	push   $0x4
  jmp alltraps
8010642d:	e9 e7 fa ff ff       	jmp    80105f19 <alltraps>

80106432 <vector5>:
.globl vector5
vector5:
  pushl $0
80106432:	6a 00                	push   $0x0
  pushl $5
80106434:	6a 05                	push   $0x5
  jmp alltraps
80106436:	e9 de fa ff ff       	jmp    80105f19 <alltraps>

8010643b <vector6>:
.globl vector6
vector6:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $6
8010643d:	6a 06                	push   $0x6
  jmp alltraps
8010643f:	e9 d5 fa ff ff       	jmp    80105f19 <alltraps>

80106444 <vector7>:
.globl vector7
vector7:
  pushl $0
80106444:	6a 00                	push   $0x0
  pushl $7
80106446:	6a 07                	push   $0x7
  jmp alltraps
80106448:	e9 cc fa ff ff       	jmp    80105f19 <alltraps>

8010644d <vector8>:
.globl vector8
vector8:
  pushl $8
8010644d:	6a 08                	push   $0x8
  jmp alltraps
8010644f:	e9 c5 fa ff ff       	jmp    80105f19 <alltraps>

80106454 <vector9>:
.globl vector9
vector9:
  pushl $0
80106454:	6a 00                	push   $0x0
  pushl $9
80106456:	6a 09                	push   $0x9
  jmp alltraps
80106458:	e9 bc fa ff ff       	jmp    80105f19 <alltraps>

8010645d <vector10>:
.globl vector10
vector10:
  pushl $10
8010645d:	6a 0a                	push   $0xa
  jmp alltraps
8010645f:	e9 b5 fa ff ff       	jmp    80105f19 <alltraps>

80106464 <vector11>:
.globl vector11
vector11:
  pushl $11
80106464:	6a 0b                	push   $0xb
  jmp alltraps
80106466:	e9 ae fa ff ff       	jmp    80105f19 <alltraps>

8010646b <vector12>:
.globl vector12
vector12:
  pushl $12
8010646b:	6a 0c                	push   $0xc
  jmp alltraps
8010646d:	e9 a7 fa ff ff       	jmp    80105f19 <alltraps>

80106472 <vector13>:
.globl vector13
vector13:
  pushl $13
80106472:	6a 0d                	push   $0xd
  jmp alltraps
80106474:	e9 a0 fa ff ff       	jmp    80105f19 <alltraps>

80106479 <vector14>:
.globl vector14
vector14:
  pushl $14
80106479:	6a 0e                	push   $0xe
  jmp alltraps
8010647b:	e9 99 fa ff ff       	jmp    80105f19 <alltraps>

80106480 <vector15>:
.globl vector15
vector15:
  pushl $0
80106480:	6a 00                	push   $0x0
  pushl $15
80106482:	6a 0f                	push   $0xf
  jmp alltraps
80106484:	e9 90 fa ff ff       	jmp    80105f19 <alltraps>

80106489 <vector16>:
.globl vector16
vector16:
  pushl $0
80106489:	6a 00                	push   $0x0
  pushl $16
8010648b:	6a 10                	push   $0x10
  jmp alltraps
8010648d:	e9 87 fa ff ff       	jmp    80105f19 <alltraps>

80106492 <vector17>:
.globl vector17
vector17:
  pushl $17
80106492:	6a 11                	push   $0x11
  jmp alltraps
80106494:	e9 80 fa ff ff       	jmp    80105f19 <alltraps>

80106499 <vector18>:
.globl vector18
vector18:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $18
8010649b:	6a 12                	push   $0x12
  jmp alltraps
8010649d:	e9 77 fa ff ff       	jmp    80105f19 <alltraps>

801064a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $19
801064a4:	6a 13                	push   $0x13
  jmp alltraps
801064a6:	e9 6e fa ff ff       	jmp    80105f19 <alltraps>

801064ab <vector20>:
.globl vector20
vector20:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $20
801064ad:	6a 14                	push   $0x14
  jmp alltraps
801064af:	e9 65 fa ff ff       	jmp    80105f19 <alltraps>

801064b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $21
801064b6:	6a 15                	push   $0x15
  jmp alltraps
801064b8:	e9 5c fa ff ff       	jmp    80105f19 <alltraps>

801064bd <vector22>:
.globl vector22
vector22:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $22
801064bf:	6a 16                	push   $0x16
  jmp alltraps
801064c1:	e9 53 fa ff ff       	jmp    80105f19 <alltraps>

801064c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $23
801064c8:	6a 17                	push   $0x17
  jmp alltraps
801064ca:	e9 4a fa ff ff       	jmp    80105f19 <alltraps>

801064cf <vector24>:
.globl vector24
vector24:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $24
801064d1:	6a 18                	push   $0x18
  jmp alltraps
801064d3:	e9 41 fa ff ff       	jmp    80105f19 <alltraps>

801064d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $25
801064da:	6a 19                	push   $0x19
  jmp alltraps
801064dc:	e9 38 fa ff ff       	jmp    80105f19 <alltraps>

801064e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $26
801064e3:	6a 1a                	push   $0x1a
  jmp alltraps
801064e5:	e9 2f fa ff ff       	jmp    80105f19 <alltraps>

801064ea <vector27>:
.globl vector27
vector27:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $27
801064ec:	6a 1b                	push   $0x1b
  jmp alltraps
801064ee:	e9 26 fa ff ff       	jmp    80105f19 <alltraps>

801064f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $28
801064f5:	6a 1c                	push   $0x1c
  jmp alltraps
801064f7:	e9 1d fa ff ff       	jmp    80105f19 <alltraps>

801064fc <vector29>:
.globl vector29
vector29:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $29
801064fe:	6a 1d                	push   $0x1d
  jmp alltraps
80106500:	e9 14 fa ff ff       	jmp    80105f19 <alltraps>

80106505 <vector30>:
.globl vector30
vector30:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $30
80106507:	6a 1e                	push   $0x1e
  jmp alltraps
80106509:	e9 0b fa ff ff       	jmp    80105f19 <alltraps>

8010650e <vector31>:
.globl vector31
vector31:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $31
80106510:	6a 1f                	push   $0x1f
  jmp alltraps
80106512:	e9 02 fa ff ff       	jmp    80105f19 <alltraps>

80106517 <vector32>:
.globl vector32
vector32:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $32
80106519:	6a 20                	push   $0x20
  jmp alltraps
8010651b:	e9 f9 f9 ff ff       	jmp    80105f19 <alltraps>

80106520 <vector33>:
.globl vector33
vector33:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $33
80106522:	6a 21                	push   $0x21
  jmp alltraps
80106524:	e9 f0 f9 ff ff       	jmp    80105f19 <alltraps>

80106529 <vector34>:
.globl vector34
vector34:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $34
8010652b:	6a 22                	push   $0x22
  jmp alltraps
8010652d:	e9 e7 f9 ff ff       	jmp    80105f19 <alltraps>

80106532 <vector35>:
.globl vector35
vector35:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $35
80106534:	6a 23                	push   $0x23
  jmp alltraps
80106536:	e9 de f9 ff ff       	jmp    80105f19 <alltraps>

8010653b <vector36>:
.globl vector36
vector36:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $36
8010653d:	6a 24                	push   $0x24
  jmp alltraps
8010653f:	e9 d5 f9 ff ff       	jmp    80105f19 <alltraps>

80106544 <vector37>:
.globl vector37
vector37:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $37
80106546:	6a 25                	push   $0x25
  jmp alltraps
80106548:	e9 cc f9 ff ff       	jmp    80105f19 <alltraps>

8010654d <vector38>:
.globl vector38
vector38:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $38
8010654f:	6a 26                	push   $0x26
  jmp alltraps
80106551:	e9 c3 f9 ff ff       	jmp    80105f19 <alltraps>

80106556 <vector39>:
.globl vector39
vector39:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $39
80106558:	6a 27                	push   $0x27
  jmp alltraps
8010655a:	e9 ba f9 ff ff       	jmp    80105f19 <alltraps>

8010655f <vector40>:
.globl vector40
vector40:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $40
80106561:	6a 28                	push   $0x28
  jmp alltraps
80106563:	e9 b1 f9 ff ff       	jmp    80105f19 <alltraps>

80106568 <vector41>:
.globl vector41
vector41:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $41
8010656a:	6a 29                	push   $0x29
  jmp alltraps
8010656c:	e9 a8 f9 ff ff       	jmp    80105f19 <alltraps>

80106571 <vector42>:
.globl vector42
vector42:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $42
80106573:	6a 2a                	push   $0x2a
  jmp alltraps
80106575:	e9 9f f9 ff ff       	jmp    80105f19 <alltraps>

8010657a <vector43>:
.globl vector43
vector43:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $43
8010657c:	6a 2b                	push   $0x2b
  jmp alltraps
8010657e:	e9 96 f9 ff ff       	jmp    80105f19 <alltraps>

80106583 <vector44>:
.globl vector44
vector44:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $44
80106585:	6a 2c                	push   $0x2c
  jmp alltraps
80106587:	e9 8d f9 ff ff       	jmp    80105f19 <alltraps>

8010658c <vector45>:
.globl vector45
vector45:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $45
8010658e:	6a 2d                	push   $0x2d
  jmp alltraps
80106590:	e9 84 f9 ff ff       	jmp    80105f19 <alltraps>

80106595 <vector46>:
.globl vector46
vector46:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $46
80106597:	6a 2e                	push   $0x2e
  jmp alltraps
80106599:	e9 7b f9 ff ff       	jmp    80105f19 <alltraps>

8010659e <vector47>:
.globl vector47
vector47:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $47
801065a0:	6a 2f                	push   $0x2f
  jmp alltraps
801065a2:	e9 72 f9 ff ff       	jmp    80105f19 <alltraps>

801065a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $48
801065a9:	6a 30                	push   $0x30
  jmp alltraps
801065ab:	e9 69 f9 ff ff       	jmp    80105f19 <alltraps>

801065b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $49
801065b2:	6a 31                	push   $0x31
  jmp alltraps
801065b4:	e9 60 f9 ff ff       	jmp    80105f19 <alltraps>

801065b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $50
801065bb:	6a 32                	push   $0x32
  jmp alltraps
801065bd:	e9 57 f9 ff ff       	jmp    80105f19 <alltraps>

801065c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $51
801065c4:	6a 33                	push   $0x33
  jmp alltraps
801065c6:	e9 4e f9 ff ff       	jmp    80105f19 <alltraps>

801065cb <vector52>:
.globl vector52
vector52:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $52
801065cd:	6a 34                	push   $0x34
  jmp alltraps
801065cf:	e9 45 f9 ff ff       	jmp    80105f19 <alltraps>

801065d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $53
801065d6:	6a 35                	push   $0x35
  jmp alltraps
801065d8:	e9 3c f9 ff ff       	jmp    80105f19 <alltraps>

801065dd <vector54>:
.globl vector54
vector54:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $54
801065df:	6a 36                	push   $0x36
  jmp alltraps
801065e1:	e9 33 f9 ff ff       	jmp    80105f19 <alltraps>

801065e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $55
801065e8:	6a 37                	push   $0x37
  jmp alltraps
801065ea:	e9 2a f9 ff ff       	jmp    80105f19 <alltraps>

801065ef <vector56>:
.globl vector56
vector56:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $56
801065f1:	6a 38                	push   $0x38
  jmp alltraps
801065f3:	e9 21 f9 ff ff       	jmp    80105f19 <alltraps>

801065f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $57
801065fa:	6a 39                	push   $0x39
  jmp alltraps
801065fc:	e9 18 f9 ff ff       	jmp    80105f19 <alltraps>

80106601 <vector58>:
.globl vector58
vector58:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $58
80106603:	6a 3a                	push   $0x3a
  jmp alltraps
80106605:	e9 0f f9 ff ff       	jmp    80105f19 <alltraps>

8010660a <vector59>:
.globl vector59
vector59:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $59
8010660c:	6a 3b                	push   $0x3b
  jmp alltraps
8010660e:	e9 06 f9 ff ff       	jmp    80105f19 <alltraps>

80106613 <vector60>:
.globl vector60
vector60:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $60
80106615:	6a 3c                	push   $0x3c
  jmp alltraps
80106617:	e9 fd f8 ff ff       	jmp    80105f19 <alltraps>

8010661c <vector61>:
.globl vector61
vector61:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $61
8010661e:	6a 3d                	push   $0x3d
  jmp alltraps
80106620:	e9 f4 f8 ff ff       	jmp    80105f19 <alltraps>

80106625 <vector62>:
.globl vector62
vector62:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $62
80106627:	6a 3e                	push   $0x3e
  jmp alltraps
80106629:	e9 eb f8 ff ff       	jmp    80105f19 <alltraps>

8010662e <vector63>:
.globl vector63
vector63:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $63
80106630:	6a 3f                	push   $0x3f
  jmp alltraps
80106632:	e9 e2 f8 ff ff       	jmp    80105f19 <alltraps>

80106637 <vector64>:
.globl vector64
vector64:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $64
80106639:	6a 40                	push   $0x40
  jmp alltraps
8010663b:	e9 d9 f8 ff ff       	jmp    80105f19 <alltraps>

80106640 <vector65>:
.globl vector65
vector65:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $65
80106642:	6a 41                	push   $0x41
  jmp alltraps
80106644:	e9 d0 f8 ff ff       	jmp    80105f19 <alltraps>

80106649 <vector66>:
.globl vector66
vector66:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $66
8010664b:	6a 42                	push   $0x42
  jmp alltraps
8010664d:	e9 c7 f8 ff ff       	jmp    80105f19 <alltraps>

80106652 <vector67>:
.globl vector67
vector67:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $67
80106654:	6a 43                	push   $0x43
  jmp alltraps
80106656:	e9 be f8 ff ff       	jmp    80105f19 <alltraps>

8010665b <vector68>:
.globl vector68
vector68:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $68
8010665d:	6a 44                	push   $0x44
  jmp alltraps
8010665f:	e9 b5 f8 ff ff       	jmp    80105f19 <alltraps>

80106664 <vector69>:
.globl vector69
vector69:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $69
80106666:	6a 45                	push   $0x45
  jmp alltraps
80106668:	e9 ac f8 ff ff       	jmp    80105f19 <alltraps>

8010666d <vector70>:
.globl vector70
vector70:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $70
8010666f:	6a 46                	push   $0x46
  jmp alltraps
80106671:	e9 a3 f8 ff ff       	jmp    80105f19 <alltraps>

80106676 <vector71>:
.globl vector71
vector71:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $71
80106678:	6a 47                	push   $0x47
  jmp alltraps
8010667a:	e9 9a f8 ff ff       	jmp    80105f19 <alltraps>

8010667f <vector72>:
.globl vector72
vector72:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $72
80106681:	6a 48                	push   $0x48
  jmp alltraps
80106683:	e9 91 f8 ff ff       	jmp    80105f19 <alltraps>

80106688 <vector73>:
.globl vector73
vector73:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $73
8010668a:	6a 49                	push   $0x49
  jmp alltraps
8010668c:	e9 88 f8 ff ff       	jmp    80105f19 <alltraps>

80106691 <vector74>:
.globl vector74
vector74:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $74
80106693:	6a 4a                	push   $0x4a
  jmp alltraps
80106695:	e9 7f f8 ff ff       	jmp    80105f19 <alltraps>

8010669a <vector75>:
.globl vector75
vector75:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $75
8010669c:	6a 4b                	push   $0x4b
  jmp alltraps
8010669e:	e9 76 f8 ff ff       	jmp    80105f19 <alltraps>

801066a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $76
801066a5:	6a 4c                	push   $0x4c
  jmp alltraps
801066a7:	e9 6d f8 ff ff       	jmp    80105f19 <alltraps>

801066ac <vector77>:
.globl vector77
vector77:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $77
801066ae:	6a 4d                	push   $0x4d
  jmp alltraps
801066b0:	e9 64 f8 ff ff       	jmp    80105f19 <alltraps>

801066b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $78
801066b7:	6a 4e                	push   $0x4e
  jmp alltraps
801066b9:	e9 5b f8 ff ff       	jmp    80105f19 <alltraps>

801066be <vector79>:
.globl vector79
vector79:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $79
801066c0:	6a 4f                	push   $0x4f
  jmp alltraps
801066c2:	e9 52 f8 ff ff       	jmp    80105f19 <alltraps>

801066c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $80
801066c9:	6a 50                	push   $0x50
  jmp alltraps
801066cb:	e9 49 f8 ff ff       	jmp    80105f19 <alltraps>

801066d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $81
801066d2:	6a 51                	push   $0x51
  jmp alltraps
801066d4:	e9 40 f8 ff ff       	jmp    80105f19 <alltraps>

801066d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $82
801066db:	6a 52                	push   $0x52
  jmp alltraps
801066dd:	e9 37 f8 ff ff       	jmp    80105f19 <alltraps>

801066e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $83
801066e4:	6a 53                	push   $0x53
  jmp alltraps
801066e6:	e9 2e f8 ff ff       	jmp    80105f19 <alltraps>

801066eb <vector84>:
.globl vector84
vector84:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $84
801066ed:	6a 54                	push   $0x54
  jmp alltraps
801066ef:	e9 25 f8 ff ff       	jmp    80105f19 <alltraps>

801066f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $85
801066f6:	6a 55                	push   $0x55
  jmp alltraps
801066f8:	e9 1c f8 ff ff       	jmp    80105f19 <alltraps>

801066fd <vector86>:
.globl vector86
vector86:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $86
801066ff:	6a 56                	push   $0x56
  jmp alltraps
80106701:	e9 13 f8 ff ff       	jmp    80105f19 <alltraps>

80106706 <vector87>:
.globl vector87
vector87:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $87
80106708:	6a 57                	push   $0x57
  jmp alltraps
8010670a:	e9 0a f8 ff ff       	jmp    80105f19 <alltraps>

8010670f <vector88>:
.globl vector88
vector88:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $88
80106711:	6a 58                	push   $0x58
  jmp alltraps
80106713:	e9 01 f8 ff ff       	jmp    80105f19 <alltraps>

80106718 <vector89>:
.globl vector89
vector89:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $89
8010671a:	6a 59                	push   $0x59
  jmp alltraps
8010671c:	e9 f8 f7 ff ff       	jmp    80105f19 <alltraps>

80106721 <vector90>:
.globl vector90
vector90:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $90
80106723:	6a 5a                	push   $0x5a
  jmp alltraps
80106725:	e9 ef f7 ff ff       	jmp    80105f19 <alltraps>

8010672a <vector91>:
.globl vector91
vector91:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $91
8010672c:	6a 5b                	push   $0x5b
  jmp alltraps
8010672e:	e9 e6 f7 ff ff       	jmp    80105f19 <alltraps>

80106733 <vector92>:
.globl vector92
vector92:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $92
80106735:	6a 5c                	push   $0x5c
  jmp alltraps
80106737:	e9 dd f7 ff ff       	jmp    80105f19 <alltraps>

8010673c <vector93>:
.globl vector93
vector93:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $93
8010673e:	6a 5d                	push   $0x5d
  jmp alltraps
80106740:	e9 d4 f7 ff ff       	jmp    80105f19 <alltraps>

80106745 <vector94>:
.globl vector94
vector94:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $94
80106747:	6a 5e                	push   $0x5e
  jmp alltraps
80106749:	e9 cb f7 ff ff       	jmp    80105f19 <alltraps>

8010674e <vector95>:
.globl vector95
vector95:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $95
80106750:	6a 5f                	push   $0x5f
  jmp alltraps
80106752:	e9 c2 f7 ff ff       	jmp    80105f19 <alltraps>

80106757 <vector96>:
.globl vector96
vector96:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $96
80106759:	6a 60                	push   $0x60
  jmp alltraps
8010675b:	e9 b9 f7 ff ff       	jmp    80105f19 <alltraps>

80106760 <vector97>:
.globl vector97
vector97:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $97
80106762:	6a 61                	push   $0x61
  jmp alltraps
80106764:	e9 b0 f7 ff ff       	jmp    80105f19 <alltraps>

80106769 <vector98>:
.globl vector98
vector98:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $98
8010676b:	6a 62                	push   $0x62
  jmp alltraps
8010676d:	e9 a7 f7 ff ff       	jmp    80105f19 <alltraps>

80106772 <vector99>:
.globl vector99
vector99:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $99
80106774:	6a 63                	push   $0x63
  jmp alltraps
80106776:	e9 9e f7 ff ff       	jmp    80105f19 <alltraps>

8010677b <vector100>:
.globl vector100
vector100:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $100
8010677d:	6a 64                	push   $0x64
  jmp alltraps
8010677f:	e9 95 f7 ff ff       	jmp    80105f19 <alltraps>

80106784 <vector101>:
.globl vector101
vector101:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $101
80106786:	6a 65                	push   $0x65
  jmp alltraps
80106788:	e9 8c f7 ff ff       	jmp    80105f19 <alltraps>

8010678d <vector102>:
.globl vector102
vector102:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $102
8010678f:	6a 66                	push   $0x66
  jmp alltraps
80106791:	e9 83 f7 ff ff       	jmp    80105f19 <alltraps>

80106796 <vector103>:
.globl vector103
vector103:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $103
80106798:	6a 67                	push   $0x67
  jmp alltraps
8010679a:	e9 7a f7 ff ff       	jmp    80105f19 <alltraps>

8010679f <vector104>:
.globl vector104
vector104:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $104
801067a1:	6a 68                	push   $0x68
  jmp alltraps
801067a3:	e9 71 f7 ff ff       	jmp    80105f19 <alltraps>

801067a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $105
801067aa:	6a 69                	push   $0x69
  jmp alltraps
801067ac:	e9 68 f7 ff ff       	jmp    80105f19 <alltraps>

801067b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $106
801067b3:	6a 6a                	push   $0x6a
  jmp alltraps
801067b5:	e9 5f f7 ff ff       	jmp    80105f19 <alltraps>

801067ba <vector107>:
.globl vector107
vector107:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $107
801067bc:	6a 6b                	push   $0x6b
  jmp alltraps
801067be:	e9 56 f7 ff ff       	jmp    80105f19 <alltraps>

801067c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $108
801067c5:	6a 6c                	push   $0x6c
  jmp alltraps
801067c7:	e9 4d f7 ff ff       	jmp    80105f19 <alltraps>

801067cc <vector109>:
.globl vector109
vector109:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $109
801067ce:	6a 6d                	push   $0x6d
  jmp alltraps
801067d0:	e9 44 f7 ff ff       	jmp    80105f19 <alltraps>

801067d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $110
801067d7:	6a 6e                	push   $0x6e
  jmp alltraps
801067d9:	e9 3b f7 ff ff       	jmp    80105f19 <alltraps>

801067de <vector111>:
.globl vector111
vector111:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $111
801067e0:	6a 6f                	push   $0x6f
  jmp alltraps
801067e2:	e9 32 f7 ff ff       	jmp    80105f19 <alltraps>

801067e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $112
801067e9:	6a 70                	push   $0x70
  jmp alltraps
801067eb:	e9 29 f7 ff ff       	jmp    80105f19 <alltraps>

801067f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $113
801067f2:	6a 71                	push   $0x71
  jmp alltraps
801067f4:	e9 20 f7 ff ff       	jmp    80105f19 <alltraps>

801067f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $114
801067fb:	6a 72                	push   $0x72
  jmp alltraps
801067fd:	e9 17 f7 ff ff       	jmp    80105f19 <alltraps>

80106802 <vector115>:
.globl vector115
vector115:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $115
80106804:	6a 73                	push   $0x73
  jmp alltraps
80106806:	e9 0e f7 ff ff       	jmp    80105f19 <alltraps>

8010680b <vector116>:
.globl vector116
vector116:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $116
8010680d:	6a 74                	push   $0x74
  jmp alltraps
8010680f:	e9 05 f7 ff ff       	jmp    80105f19 <alltraps>

80106814 <vector117>:
.globl vector117
vector117:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $117
80106816:	6a 75                	push   $0x75
  jmp alltraps
80106818:	e9 fc f6 ff ff       	jmp    80105f19 <alltraps>

8010681d <vector118>:
.globl vector118
vector118:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $118
8010681f:	6a 76                	push   $0x76
  jmp alltraps
80106821:	e9 f3 f6 ff ff       	jmp    80105f19 <alltraps>

80106826 <vector119>:
.globl vector119
vector119:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $119
80106828:	6a 77                	push   $0x77
  jmp alltraps
8010682a:	e9 ea f6 ff ff       	jmp    80105f19 <alltraps>

8010682f <vector120>:
.globl vector120
vector120:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $120
80106831:	6a 78                	push   $0x78
  jmp alltraps
80106833:	e9 e1 f6 ff ff       	jmp    80105f19 <alltraps>

80106838 <vector121>:
.globl vector121
vector121:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $121
8010683a:	6a 79                	push   $0x79
  jmp alltraps
8010683c:	e9 d8 f6 ff ff       	jmp    80105f19 <alltraps>

80106841 <vector122>:
.globl vector122
vector122:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $122
80106843:	6a 7a                	push   $0x7a
  jmp alltraps
80106845:	e9 cf f6 ff ff       	jmp    80105f19 <alltraps>

8010684a <vector123>:
.globl vector123
vector123:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $123
8010684c:	6a 7b                	push   $0x7b
  jmp alltraps
8010684e:	e9 c6 f6 ff ff       	jmp    80105f19 <alltraps>

80106853 <vector124>:
.globl vector124
vector124:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $124
80106855:	6a 7c                	push   $0x7c
  jmp alltraps
80106857:	e9 bd f6 ff ff       	jmp    80105f19 <alltraps>

8010685c <vector125>:
.globl vector125
vector125:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $125
8010685e:	6a 7d                	push   $0x7d
  jmp alltraps
80106860:	e9 b4 f6 ff ff       	jmp    80105f19 <alltraps>

80106865 <vector126>:
.globl vector126
vector126:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $126
80106867:	6a 7e                	push   $0x7e
  jmp alltraps
80106869:	e9 ab f6 ff ff       	jmp    80105f19 <alltraps>

8010686e <vector127>:
.globl vector127
vector127:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $127
80106870:	6a 7f                	push   $0x7f
  jmp alltraps
80106872:	e9 a2 f6 ff ff       	jmp    80105f19 <alltraps>

80106877 <vector128>:
.globl vector128
vector128:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $128
80106879:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010687e:	e9 96 f6 ff ff       	jmp    80105f19 <alltraps>

80106883 <vector129>:
.globl vector129
vector129:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $129
80106885:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010688a:	e9 8a f6 ff ff       	jmp    80105f19 <alltraps>

8010688f <vector130>:
.globl vector130
vector130:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $130
80106891:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106896:	e9 7e f6 ff ff       	jmp    80105f19 <alltraps>

8010689b <vector131>:
.globl vector131
vector131:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $131
8010689d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801068a2:	e9 72 f6 ff ff       	jmp    80105f19 <alltraps>

801068a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $132
801068a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801068ae:	e9 66 f6 ff ff       	jmp    80105f19 <alltraps>

801068b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $133
801068b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801068ba:	e9 5a f6 ff ff       	jmp    80105f19 <alltraps>

801068bf <vector134>:
.globl vector134
vector134:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $134
801068c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801068c6:	e9 4e f6 ff ff       	jmp    80105f19 <alltraps>

801068cb <vector135>:
.globl vector135
vector135:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $135
801068cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068d2:	e9 42 f6 ff ff       	jmp    80105f19 <alltraps>

801068d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $136
801068d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068de:	e9 36 f6 ff ff       	jmp    80105f19 <alltraps>

801068e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $137
801068e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068ea:	e9 2a f6 ff ff       	jmp    80105f19 <alltraps>

801068ef <vector138>:
.globl vector138
vector138:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $138
801068f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068f6:	e9 1e f6 ff ff       	jmp    80105f19 <alltraps>

801068fb <vector139>:
.globl vector139
vector139:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $139
801068fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106902:	e9 12 f6 ff ff       	jmp    80105f19 <alltraps>

80106907 <vector140>:
.globl vector140
vector140:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $140
80106909:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010690e:	e9 06 f6 ff ff       	jmp    80105f19 <alltraps>

80106913 <vector141>:
.globl vector141
vector141:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $141
80106915:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010691a:	e9 fa f5 ff ff       	jmp    80105f19 <alltraps>

8010691f <vector142>:
.globl vector142
vector142:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $142
80106921:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106926:	e9 ee f5 ff ff       	jmp    80105f19 <alltraps>

8010692b <vector143>:
.globl vector143
vector143:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $143
8010692d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106932:	e9 e2 f5 ff ff       	jmp    80105f19 <alltraps>

80106937 <vector144>:
.globl vector144
vector144:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $144
80106939:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010693e:	e9 d6 f5 ff ff       	jmp    80105f19 <alltraps>

80106943 <vector145>:
.globl vector145
vector145:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $145
80106945:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010694a:	e9 ca f5 ff ff       	jmp    80105f19 <alltraps>

8010694f <vector146>:
.globl vector146
vector146:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $146
80106951:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106956:	e9 be f5 ff ff       	jmp    80105f19 <alltraps>

8010695b <vector147>:
.globl vector147
vector147:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $147
8010695d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106962:	e9 b2 f5 ff ff       	jmp    80105f19 <alltraps>

80106967 <vector148>:
.globl vector148
vector148:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $148
80106969:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010696e:	e9 a6 f5 ff ff       	jmp    80105f19 <alltraps>

80106973 <vector149>:
.globl vector149
vector149:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $149
80106975:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010697a:	e9 9a f5 ff ff       	jmp    80105f19 <alltraps>

8010697f <vector150>:
.globl vector150
vector150:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $150
80106981:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106986:	e9 8e f5 ff ff       	jmp    80105f19 <alltraps>

8010698b <vector151>:
.globl vector151
vector151:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $151
8010698d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106992:	e9 82 f5 ff ff       	jmp    80105f19 <alltraps>

80106997 <vector152>:
.globl vector152
vector152:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $152
80106999:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010699e:	e9 76 f5 ff ff       	jmp    80105f19 <alltraps>

801069a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $153
801069a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801069aa:	e9 6a f5 ff ff       	jmp    80105f19 <alltraps>

801069af <vector154>:
.globl vector154
vector154:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $154
801069b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801069b6:	e9 5e f5 ff ff       	jmp    80105f19 <alltraps>

801069bb <vector155>:
.globl vector155
vector155:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $155
801069bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801069c2:	e9 52 f5 ff ff       	jmp    80105f19 <alltraps>

801069c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $156
801069c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801069ce:	e9 46 f5 ff ff       	jmp    80105f19 <alltraps>

801069d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $157
801069d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069da:	e9 3a f5 ff ff       	jmp    80105f19 <alltraps>

801069df <vector158>:
.globl vector158
vector158:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $158
801069e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069e6:	e9 2e f5 ff ff       	jmp    80105f19 <alltraps>

801069eb <vector159>:
.globl vector159
vector159:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $159
801069ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069f2:	e9 22 f5 ff ff       	jmp    80105f19 <alltraps>

801069f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $160
801069f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069fe:	e9 16 f5 ff ff       	jmp    80105f19 <alltraps>

80106a03 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $161
80106a05:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a0a:	e9 0a f5 ff ff       	jmp    80105f19 <alltraps>

80106a0f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $162
80106a11:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106a16:	e9 fe f4 ff ff       	jmp    80105f19 <alltraps>

80106a1b <vector163>:
.globl vector163
vector163:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $163
80106a1d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106a22:	e9 f2 f4 ff ff       	jmp    80105f19 <alltraps>

80106a27 <vector164>:
.globl vector164
vector164:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $164
80106a29:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106a2e:	e9 e6 f4 ff ff       	jmp    80105f19 <alltraps>

80106a33 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $165
80106a35:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a3a:	e9 da f4 ff ff       	jmp    80105f19 <alltraps>

80106a3f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $166
80106a41:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a46:	e9 ce f4 ff ff       	jmp    80105f19 <alltraps>

80106a4b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $167
80106a4d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a52:	e9 c2 f4 ff ff       	jmp    80105f19 <alltraps>

80106a57 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $168
80106a59:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a5e:	e9 b6 f4 ff ff       	jmp    80105f19 <alltraps>

80106a63 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $169
80106a65:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a6a:	e9 aa f4 ff ff       	jmp    80105f19 <alltraps>

80106a6f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $170
80106a71:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a76:	e9 9e f4 ff ff       	jmp    80105f19 <alltraps>

80106a7b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $171
80106a7d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a82:	e9 92 f4 ff ff       	jmp    80105f19 <alltraps>

80106a87 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $172
80106a89:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a8e:	e9 86 f4 ff ff       	jmp    80105f19 <alltraps>

80106a93 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $173
80106a95:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a9a:	e9 7a f4 ff ff       	jmp    80105f19 <alltraps>

80106a9f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $174
80106aa1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106aa6:	e9 6e f4 ff ff       	jmp    80105f19 <alltraps>

80106aab <vector175>:
.globl vector175
vector175:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $175
80106aad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ab2:	e9 62 f4 ff ff       	jmp    80105f19 <alltraps>

80106ab7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $176
80106ab9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106abe:	e9 56 f4 ff ff       	jmp    80105f19 <alltraps>

80106ac3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $177
80106ac5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106aca:	e9 4a f4 ff ff       	jmp    80105f19 <alltraps>

80106acf <vector178>:
.globl vector178
vector178:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $178
80106ad1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106ad6:	e9 3e f4 ff ff       	jmp    80105f19 <alltraps>

80106adb <vector179>:
.globl vector179
vector179:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $179
80106add:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ae2:	e9 32 f4 ff ff       	jmp    80105f19 <alltraps>

80106ae7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $180
80106ae9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106aee:	e9 26 f4 ff ff       	jmp    80105f19 <alltraps>

80106af3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $181
80106af5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106afa:	e9 1a f4 ff ff       	jmp    80105f19 <alltraps>

80106aff <vector182>:
.globl vector182
vector182:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $182
80106b01:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b06:	e9 0e f4 ff ff       	jmp    80105f19 <alltraps>

80106b0b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $183
80106b0d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106b12:	e9 02 f4 ff ff       	jmp    80105f19 <alltraps>

80106b17 <vector184>:
.globl vector184
vector184:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $184
80106b19:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106b1e:	e9 f6 f3 ff ff       	jmp    80105f19 <alltraps>

80106b23 <vector185>:
.globl vector185
vector185:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $185
80106b25:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106b2a:	e9 ea f3 ff ff       	jmp    80105f19 <alltraps>

80106b2f <vector186>:
.globl vector186
vector186:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $186
80106b31:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b36:	e9 de f3 ff ff       	jmp    80105f19 <alltraps>

80106b3b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $187
80106b3d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b42:	e9 d2 f3 ff ff       	jmp    80105f19 <alltraps>

80106b47 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $188
80106b49:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b4e:	e9 c6 f3 ff ff       	jmp    80105f19 <alltraps>

80106b53 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $189
80106b55:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b5a:	e9 ba f3 ff ff       	jmp    80105f19 <alltraps>

80106b5f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $190
80106b61:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b66:	e9 ae f3 ff ff       	jmp    80105f19 <alltraps>

80106b6b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $191
80106b6d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b72:	e9 a2 f3 ff ff       	jmp    80105f19 <alltraps>

80106b77 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $192
80106b79:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b7e:	e9 96 f3 ff ff       	jmp    80105f19 <alltraps>

80106b83 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $193
80106b85:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b8a:	e9 8a f3 ff ff       	jmp    80105f19 <alltraps>

80106b8f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $194
80106b91:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b96:	e9 7e f3 ff ff       	jmp    80105f19 <alltraps>

80106b9b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $195
80106b9d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106ba2:	e9 72 f3 ff ff       	jmp    80105f19 <alltraps>

80106ba7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $196
80106ba9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106bae:	e9 66 f3 ff ff       	jmp    80105f19 <alltraps>

80106bb3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $197
80106bb5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106bba:	e9 5a f3 ff ff       	jmp    80105f19 <alltraps>

80106bbf <vector198>:
.globl vector198
vector198:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $198
80106bc1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106bc6:	e9 4e f3 ff ff       	jmp    80105f19 <alltraps>

80106bcb <vector199>:
.globl vector199
vector199:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $199
80106bcd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106bd2:	e9 42 f3 ff ff       	jmp    80105f19 <alltraps>

80106bd7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $200
80106bd9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bde:	e9 36 f3 ff ff       	jmp    80105f19 <alltraps>

80106be3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $201
80106be5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bea:	e9 2a f3 ff ff       	jmp    80105f19 <alltraps>

80106bef <vector202>:
.globl vector202
vector202:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $202
80106bf1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bf6:	e9 1e f3 ff ff       	jmp    80105f19 <alltraps>

80106bfb <vector203>:
.globl vector203
vector203:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $203
80106bfd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c02:	e9 12 f3 ff ff       	jmp    80105f19 <alltraps>

80106c07 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $204
80106c09:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c0e:	e9 06 f3 ff ff       	jmp    80105f19 <alltraps>

80106c13 <vector205>:
.globl vector205
vector205:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $205
80106c15:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106c1a:	e9 fa f2 ff ff       	jmp    80105f19 <alltraps>

80106c1f <vector206>:
.globl vector206
vector206:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $206
80106c21:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106c26:	e9 ee f2 ff ff       	jmp    80105f19 <alltraps>

80106c2b <vector207>:
.globl vector207
vector207:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $207
80106c2d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c32:	e9 e2 f2 ff ff       	jmp    80105f19 <alltraps>

80106c37 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $208
80106c39:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c3e:	e9 d6 f2 ff ff       	jmp    80105f19 <alltraps>

80106c43 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $209
80106c45:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c4a:	e9 ca f2 ff ff       	jmp    80105f19 <alltraps>

80106c4f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $210
80106c51:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c56:	e9 be f2 ff ff       	jmp    80105f19 <alltraps>

80106c5b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $211
80106c5d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c62:	e9 b2 f2 ff ff       	jmp    80105f19 <alltraps>

80106c67 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $212
80106c69:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c6e:	e9 a6 f2 ff ff       	jmp    80105f19 <alltraps>

80106c73 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $213
80106c75:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c7a:	e9 9a f2 ff ff       	jmp    80105f19 <alltraps>

80106c7f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $214
80106c81:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c86:	e9 8e f2 ff ff       	jmp    80105f19 <alltraps>

80106c8b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $215
80106c8d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c92:	e9 82 f2 ff ff       	jmp    80105f19 <alltraps>

80106c97 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $216
80106c99:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c9e:	e9 76 f2 ff ff       	jmp    80105f19 <alltraps>

80106ca3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $217
80106ca5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106caa:	e9 6a f2 ff ff       	jmp    80105f19 <alltraps>

80106caf <vector218>:
.globl vector218
vector218:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $218
80106cb1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106cb6:	e9 5e f2 ff ff       	jmp    80105f19 <alltraps>

80106cbb <vector219>:
.globl vector219
vector219:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $219
80106cbd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106cc2:	e9 52 f2 ff ff       	jmp    80105f19 <alltraps>

80106cc7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $220
80106cc9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106cce:	e9 46 f2 ff ff       	jmp    80105f19 <alltraps>

80106cd3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $221
80106cd5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106cda:	e9 3a f2 ff ff       	jmp    80105f19 <alltraps>

80106cdf <vector222>:
.globl vector222
vector222:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $222
80106ce1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106ce6:	e9 2e f2 ff ff       	jmp    80105f19 <alltraps>

80106ceb <vector223>:
.globl vector223
vector223:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $223
80106ced:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cf2:	e9 22 f2 ff ff       	jmp    80105f19 <alltraps>

80106cf7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $224
80106cf9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cfe:	e9 16 f2 ff ff       	jmp    80105f19 <alltraps>

80106d03 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $225
80106d05:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d0a:	e9 0a f2 ff ff       	jmp    80105f19 <alltraps>

80106d0f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $226
80106d11:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106d16:	e9 fe f1 ff ff       	jmp    80105f19 <alltraps>

80106d1b <vector227>:
.globl vector227
vector227:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $227
80106d1d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106d22:	e9 f2 f1 ff ff       	jmp    80105f19 <alltraps>

80106d27 <vector228>:
.globl vector228
vector228:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $228
80106d29:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106d2e:	e9 e6 f1 ff ff       	jmp    80105f19 <alltraps>

80106d33 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $229
80106d35:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d3a:	e9 da f1 ff ff       	jmp    80105f19 <alltraps>

80106d3f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $230
80106d41:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d46:	e9 ce f1 ff ff       	jmp    80105f19 <alltraps>

80106d4b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $231
80106d4d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d52:	e9 c2 f1 ff ff       	jmp    80105f19 <alltraps>

80106d57 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $232
80106d59:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d5e:	e9 b6 f1 ff ff       	jmp    80105f19 <alltraps>

80106d63 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $233
80106d65:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d6a:	e9 aa f1 ff ff       	jmp    80105f19 <alltraps>

80106d6f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $234
80106d71:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d76:	e9 9e f1 ff ff       	jmp    80105f19 <alltraps>

80106d7b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $235
80106d7d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d82:	e9 92 f1 ff ff       	jmp    80105f19 <alltraps>

80106d87 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $236
80106d89:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d8e:	e9 86 f1 ff ff       	jmp    80105f19 <alltraps>

80106d93 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $237
80106d95:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d9a:	e9 7a f1 ff ff       	jmp    80105f19 <alltraps>

80106d9f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $238
80106da1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106da6:	e9 6e f1 ff ff       	jmp    80105f19 <alltraps>

80106dab <vector239>:
.globl vector239
vector239:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $239
80106dad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106db2:	e9 62 f1 ff ff       	jmp    80105f19 <alltraps>

80106db7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $240
80106db9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106dbe:	e9 56 f1 ff ff       	jmp    80105f19 <alltraps>

80106dc3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $241
80106dc5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106dca:	e9 4a f1 ff ff       	jmp    80105f19 <alltraps>

80106dcf <vector242>:
.globl vector242
vector242:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $242
80106dd1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106dd6:	e9 3e f1 ff ff       	jmp    80105f19 <alltraps>

80106ddb <vector243>:
.globl vector243
vector243:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $243
80106ddd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106de2:	e9 32 f1 ff ff       	jmp    80105f19 <alltraps>

80106de7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $244
80106de9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dee:	e9 26 f1 ff ff       	jmp    80105f19 <alltraps>

80106df3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $245
80106df5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dfa:	e9 1a f1 ff ff       	jmp    80105f19 <alltraps>

80106dff <vector246>:
.globl vector246
vector246:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $246
80106e01:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e06:	e9 0e f1 ff ff       	jmp    80105f19 <alltraps>

80106e0b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $247
80106e0d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106e12:	e9 02 f1 ff ff       	jmp    80105f19 <alltraps>

80106e17 <vector248>:
.globl vector248
vector248:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $248
80106e19:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106e1e:	e9 f6 f0 ff ff       	jmp    80105f19 <alltraps>

80106e23 <vector249>:
.globl vector249
vector249:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $249
80106e25:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106e2a:	e9 ea f0 ff ff       	jmp    80105f19 <alltraps>

80106e2f <vector250>:
.globl vector250
vector250:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $250
80106e31:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e36:	e9 de f0 ff ff       	jmp    80105f19 <alltraps>

80106e3b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $251
80106e3d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e42:	e9 d2 f0 ff ff       	jmp    80105f19 <alltraps>

80106e47 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $252
80106e49:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e4e:	e9 c6 f0 ff ff       	jmp    80105f19 <alltraps>

80106e53 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $253
80106e55:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e5a:	e9 ba f0 ff ff       	jmp    80105f19 <alltraps>

80106e5f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $254
80106e61:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e66:	e9 ae f0 ff ff       	jmp    80105f19 <alltraps>

80106e6b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $255
80106e6d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e72:	e9 a2 f0 ff ff       	jmp    80105f19 <alltraps>
80106e77:	66 90                	xchg   %ax,%ax
80106e79:	66 90                	xchg   %ax,%ax
80106e7b:	66 90                	xchg   %ax,%ax
80106e7d:	66 90                	xchg   %ax,%ax
80106e7f:	90                   	nop

80106e80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80106e86:	89 d3                	mov    %edx,%ebx
{
80106e88:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e8a:	c1 eb 16             	shr    $0x16,%ebx
80106e8d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e90:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e93:	8b 06                	mov    (%esi),%eax
80106e95:	a8 01                	test   $0x1,%al
80106e97:	74 27                	je     80106ec0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e99:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e9e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106ea4:	c1 ef 0a             	shr    $0xa,%edi
}
80106ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106eaa:	89 fa                	mov    %edi,%edx
80106eac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106eb2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106eb5:	5b                   	pop    %ebx
80106eb6:	5e                   	pop    %esi
80106eb7:	5f                   	pop    %edi
80106eb8:	5d                   	pop    %ebp
80106eb9:	c3                   	ret    
80106eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ec0:	85 c9                	test   %ecx,%ecx
80106ec2:	74 2c                	je     80106ef0 <walkpgdir+0x70>
80106ec4:	e8 07 bb ff ff       	call   801029d0 <kalloc>
80106ec9:	85 c0                	test   %eax,%eax
80106ecb:	89 c3                	mov    %eax,%ebx
80106ecd:	74 21                	je     80106ef0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106ecf:	83 ec 04             	sub    $0x4,%esp
80106ed2:	68 00 10 00 00       	push   $0x1000
80106ed7:	6a 00                	push   $0x0
80106ed9:	50                   	push   %eax
80106eda:	e8 f1 dd ff ff       	call   80104cd0 <memset>
80106edf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80106ee5:	83 c4 10             	add    $0x10,%esp
80106ee8:	83 c8 07             	or     $0x7,%eax
80106eeb:	89 06                	mov    %eax,(%esi)
80106eed:	eb b5                	jmp    80106ea4 <walkpgdir+0x24>
80106eef:	90                   	nop
}
80106ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ef3:	31 c0                	xor    %eax,%eax
}
80106ef5:	5b                   	pop    %ebx
80106ef6:	5e                   	pop    %esi
80106ef7:	5f                   	pop    %edi
80106ef8:	5d                   	pop    %ebp
80106ef9:	c3                   	ret    
80106efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f00 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106f06:	89 d3                	mov    %edx,%ebx
80106f08:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106f0e:	83 ec 1c             	sub    $0x1c,%esp
80106f11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106f14:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106f18:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f1b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f20:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106f23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f26:	29 df                	sub    %ebx,%edi
80106f28:	83 c8 01             	or     $0x1,%eax
80106f2b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106f2e:	eb 15                	jmp    80106f45 <mappages+0x45>
    if(*pte & PTE_P)
80106f30:	f6 00 01             	testb  $0x1,(%eax)
80106f33:	75 45                	jne    80106f7a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f35:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f38:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f3b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f3d:	74 31                	je     80106f70 <mappages+0x70>
      break;
    a += PGSIZE;
80106f3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f48:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f4d:	89 da                	mov    %ebx,%edx
80106f4f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f52:	e8 29 ff ff ff       	call   80106e80 <walkpgdir>
80106f57:	85 c0                	test   %eax,%eax
80106f59:	75 d5                	jne    80106f30 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f63:	5b                   	pop    %ebx
80106f64:	5e                   	pop    %esi
80106f65:	5f                   	pop    %edi
80106f66:	5d                   	pop    %ebp
80106f67:	c3                   	ret    
80106f68:	90                   	nop
80106f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	5b                   	pop    %ebx
80106f76:	5e                   	pop    %esi
80106f77:	5f                   	pop    %edi
80106f78:	5d                   	pop    %ebp
80106f79:	c3                   	ret    
      panic("remap");
80106f7a:	83 ec 0c             	sub    $0xc,%esp
80106f7d:	68 08 89 10 80       	push   $0x80108908
80106f82:	e8 09 94 ff ff       	call   80100390 <panic>
80106f87:	89 f6                	mov    %esi,%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <seginit>:
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f96:	e8 15 cf ff ff       	call   80103eb0 <cpuid>
80106f9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106fa1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106fa6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106faa:	c7 80 38 58 19 80 ff 	movl   $0xffff,-0x7fe6a7c8(%eax)
80106fb1:	ff 00 00 
80106fb4:	c7 80 3c 58 19 80 00 	movl   $0xcf9a00,-0x7fe6a7c4(%eax)
80106fbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fbe:	c7 80 40 58 19 80 ff 	movl   $0xffff,-0x7fe6a7c0(%eax)
80106fc5:	ff 00 00 
80106fc8:	c7 80 44 58 19 80 00 	movl   $0xcf9200,-0x7fe6a7bc(%eax)
80106fcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fd2:	c7 80 48 58 19 80 ff 	movl   $0xffff,-0x7fe6a7b8(%eax)
80106fd9:	ff 00 00 
80106fdc:	c7 80 4c 58 19 80 00 	movl   $0xcffa00,-0x7fe6a7b4(%eax)
80106fe3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fe6:	c7 80 50 58 19 80 ff 	movl   $0xffff,-0x7fe6a7b0(%eax)
80106fed:	ff 00 00 
80106ff0:	c7 80 54 58 19 80 00 	movl   $0xcff200,-0x7fe6a7ac(%eax)
80106ff7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106ffa:	05 30 58 19 80       	add    $0x80195830,%eax
  pd[1] = (uint)p;
80106fff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107003:	c1 e8 10             	shr    $0x10,%eax
80107006:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010700a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010700d:	0f 01 10             	lgdtl  (%eax)
}
80107010:	c9                   	leave  
80107011:	c3                   	ret    
80107012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107020 <switchkvm>:
80107020:	a1 e4 09 1a 80       	mov    0x801a09e4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107025:	55                   	push   %ebp
80107026:	89 e5                	mov    %esp,%ebp
80107028:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010702d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(v2p(kpgdir));   // switch to the kernel page table
}
80107030:	5d                   	pop    %ebp
80107031:	c3                   	ret    
80107032:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107040 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	57                   	push   %edi
80107044:	56                   	push   %esi
80107045:	53                   	push   %ebx
80107046:	83 ec 1c             	sub    $0x1c,%esp
80107049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010704c:	85 db                	test   %ebx,%ebx
8010704e:	0f 84 cb 00 00 00    	je     8010711f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107054:	8b 43 08             	mov    0x8(%ebx),%eax
80107057:	85 c0                	test   %eax,%eax
80107059:	0f 84 da 00 00 00    	je     80107139 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010705f:	8b 43 04             	mov    0x4(%ebx),%eax
80107062:	85 c0                	test   %eax,%eax
80107064:	0f 84 c2 00 00 00    	je     8010712c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010706a:	e8 81 da ff ff       	call   80104af0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010706f:	e8 bc cd ff ff       	call   80103e30 <mycpu>
80107074:	89 c6                	mov    %eax,%esi
80107076:	e8 b5 cd ff ff       	call   80103e30 <mycpu>
8010707b:	89 c7                	mov    %eax,%edi
8010707d:	e8 ae cd ff ff       	call   80103e30 <mycpu>
80107082:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107085:	83 c7 08             	add    $0x8,%edi
80107088:	e8 a3 cd ff ff       	call   80103e30 <mycpu>
8010708d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107090:	83 c0 08             	add    $0x8,%eax
80107093:	ba 67 00 00 00       	mov    $0x67,%edx
80107098:	c1 e8 18             	shr    $0x18,%eax
8010709b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801070a2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801070a9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801070b4:	83 c1 08             	add    $0x8,%ecx
801070b7:	c1 e9 10             	shr    $0x10,%ecx
801070ba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801070c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801070c5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070cc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801070d1:	e8 5a cd ff ff       	call   80103e30 <mycpu>
801070d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070dd:	e8 4e cd ff ff       	call   80103e30 <mycpu>
801070e2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070e6:	8b 73 08             	mov    0x8(%ebx),%esi
801070e9:	e8 42 cd ff ff       	call   80103e30 <mycpu>
801070ee:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070f4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070f7:	e8 34 cd ff ff       	call   80103e30 <mycpu>
801070fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107100:	b8 28 00 00 00       	mov    $0x28,%eax
80107105:	0f 00 d8             	ltr    %ax
80107108:	8b 43 04             	mov    0x4(%ebx),%eax
8010710b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107110:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(v2p(p->pgdir));  // switch to process's address space
  popcli();
}
80107113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107116:	5b                   	pop    %ebx
80107117:	5e                   	pop    %esi
80107118:	5f                   	pop    %edi
80107119:	5d                   	pop    %ebp
  popcli();
8010711a:	e9 11 da ff ff       	jmp    80104b30 <popcli>
    panic("switchuvm: no process");
8010711f:	83 ec 0c             	sub    $0xc,%esp
80107122:	68 0e 89 10 80       	push   $0x8010890e
80107127:	e8 64 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010712c:	83 ec 0c             	sub    $0xc,%esp
8010712f:	68 39 89 10 80       	push   $0x80108939
80107134:	e8 57 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107139:	83 ec 0c             	sub    $0xc,%esp
8010713c:	68 24 89 10 80       	push   $0x80108924
80107141:	e8 4a 92 ff ff       	call   80100390 <panic>
80107146:	8d 76 00             	lea    0x0(%esi),%esi
80107149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107150 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 1c             	sub    $0x1c,%esp
80107159:	8b 75 10             	mov    0x10(%ebp),%esi
8010715c:	8b 45 08             	mov    0x8(%ebp),%eax
8010715f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107162:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010716b:	77 49                	ja     801071b6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010716d:	e8 5e b8 ff ff       	call   801029d0 <kalloc>
  memset(mem, 0, PGSIZE);
80107172:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107175:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107177:	68 00 10 00 00       	push   $0x1000
8010717c:	6a 00                	push   $0x0
8010717e:	50                   	push   %eax
8010717f:	e8 4c db ff ff       	call   80104cd0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107184:	58                   	pop    %eax
80107185:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010718b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107190:	5a                   	pop    %edx
80107191:	6a 06                	push   $0x6
80107193:	50                   	push   %eax
80107194:	31 d2                	xor    %edx,%edx
80107196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107199:	e8 62 fd ff ff       	call   80106f00 <mappages>
  memmove(mem, init, sz);
8010719e:	89 75 10             	mov    %esi,0x10(%ebp)
801071a1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801071a4:	83 c4 10             	add    $0x10,%esp
801071a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801071aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ad:	5b                   	pop    %ebx
801071ae:	5e                   	pop    %esi
801071af:	5f                   	pop    %edi
801071b0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801071b1:	e9 ca db ff ff       	jmp    80104d80 <memmove>
    panic("inituvm: more than a page");
801071b6:	83 ec 0c             	sub    $0xc,%esp
801071b9:	68 4d 89 10 80       	push   $0x8010894d
801071be:	e8 cd 91 ff ff       	call   80100390 <panic>
801071c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071d0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	57                   	push   %edi
801071d4:	56                   	push   %esi
801071d5:	53                   	push   %ebx
801071d6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801071d9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801071e0:	0f 85 91 00 00 00    	jne    80107277 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801071e6:	8b 75 18             	mov    0x18(%ebp),%esi
801071e9:	31 db                	xor    %ebx,%ebx
801071eb:	85 f6                	test   %esi,%esi
801071ed:	75 1a                	jne    80107209 <loaduvm+0x39>
801071ef:	eb 6f                	jmp    80107260 <loaduvm+0x90>
801071f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071fe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107204:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107207:	76 57                	jbe    80107260 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107209:	8b 55 0c             	mov    0xc(%ebp),%edx
8010720c:	8b 45 08             	mov    0x8(%ebp),%eax
8010720f:	31 c9                	xor    %ecx,%ecx
80107211:	01 da                	add    %ebx,%edx
80107213:	e8 68 fc ff ff       	call   80106e80 <walkpgdir>
80107218:	85 c0                	test   %eax,%eax
8010721a:	74 4e                	je     8010726a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010721c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
8010721e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107221:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107226:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010722b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107231:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107234:	01 d9                	add    %ebx,%ecx
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107236:	05 00 00 00 80       	add    $0x80000000,%eax
8010723b:	57                   	push   %edi
8010723c:	51                   	push   %ecx
8010723d:	50                   	push   %eax
8010723e:	ff 75 10             	pushl  0x10(%ebp)
80107241:	e8 5a a7 ff ff       	call   801019a0 <readi>
80107246:	83 c4 10             	add    $0x10,%esp
80107249:	39 f8                	cmp    %edi,%eax
8010724b:	74 ab                	je     801071f8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010724d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107255:	5b                   	pop    %ebx
80107256:	5e                   	pop    %esi
80107257:	5f                   	pop    %edi
80107258:	5d                   	pop    %ebp
80107259:	c3                   	ret    
8010725a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107263:	31 c0                	xor    %eax,%eax
}
80107265:	5b                   	pop    %ebx
80107266:	5e                   	pop    %esi
80107267:	5f                   	pop    %edi
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    
      panic("loaduvm: address should exist");
8010726a:	83 ec 0c             	sub    $0xc,%esp
8010726d:	68 67 89 10 80       	push   $0x80108967
80107272:	e8 19 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107277:	83 ec 0c             	sub    $0xc,%esp
8010727a:	68 bc 8a 10 80       	push   $0x80108abc
8010727f:	e8 0c 91 ff ff       	call   80100390 <panic>
80107284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010728a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107290 <indexToSwap>:
  }
  return newsz;
}

uint indexToSwap()
{
80107290:	55                   	push   %ebp
  return 15;
}
80107291:	b8 0f 00 00 00       	mov    $0xf,%eax
{
80107296:	89 e5                	mov    %esp,%ebp
}
80107298:	5d                   	pop    %ebp
80107299:	c3                   	ret    
8010729a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072a0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 3c             	sub    $0x3c,%esp
801072a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
801072ac:	e8 1f cc ff ff       	call   80103ed0 <myproc>
801072b1:	89 45 c0             	mov    %eax,-0x40(%ebp)

  if(newsz >= oldsz)
801072b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801072b7:	39 45 10             	cmp    %eax,0x10(%ebp)
801072ba:	0f 83 a3 00 00 00    	jae    80107363 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
801072c0:	8b 45 10             	mov    0x10(%ebp),%eax
801072c3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801072c9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
801072cf:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072d2:	77 6a                	ja     8010733e <deallocuvm+0x9e>
801072d4:	e9 87 00 00 00       	jmp    80107360 <deallocuvm+0xc0>
801072d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
801072e0:	8b 00                	mov    (%eax),%eax
801072e2:	a8 01                	test   $0x1,%al
801072e4:	74 4d                	je     80107333 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801072e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072eb:	0f 84 63 01 00 00    	je     80107454 <deallocuvm+0x1b4>
801072f1:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      {
        panic("kfree");
      }
      char *v = p2v(pa);
      
      if(getRefs(v) == 1)
801072f7:	83 ec 0c             	sub    $0xc,%esp
801072fa:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801072fd:	53                   	push   %ebx
801072fe:	e8 5d b8 ff ff       	call   80102b60 <getRefs>
80107303:	83 c4 10             	add    $0x10,%esp
80107306:	83 f8 01             	cmp    $0x1,%eax
80107309:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010730c:	0f 84 2e 01 00 00    	je     80107440 <deallocuvm+0x1a0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107312:	83 ec 0c             	sub    $0xc,%esp
80107315:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80107318:	53                   	push   %ebx
80107319:	e8 62 b7 ff ff       	call   80102a80 <refDec>
8010731e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80107321:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107324:	8b 45 c0             	mov    -0x40(%ebp),%eax
80107327:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010732b:	7f 43                	jg     80107370 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
8010732d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107333:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107339:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010733c:	76 22                	jbe    80107360 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010733e:	31 c9                	xor    %ecx,%ecx
80107340:	89 f2                	mov    %esi,%edx
80107342:	89 f8                	mov    %edi,%eax
80107344:	e8 37 fb ff ff       	call   80106e80 <walkpgdir>
    if(!pte)
80107349:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
8010734b:	89 c2                	mov    %eax,%edx
    if(!pte)
8010734d:	75 91                	jne    801072e0 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
8010734f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107355:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010735b:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010735e:	77 de                	ja     8010733e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107360:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107363:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107366:	5b                   	pop    %ebx
80107367:	5e                   	pop    %esi
80107368:	5f                   	pop    %edi
80107369:	5d                   	pop    %ebp
8010736a:	c3                   	ret    
8010736b:	90                   	nop
8010736c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107370:	8d 88 88 01 00 00    	lea    0x188(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107376:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80107379:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
8010737f:	89 fa                	mov    %edi,%edx
80107381:	89 cf                	mov    %ecx,%edi
80107383:	eb 13                	jmp    80107398 <deallocuvm+0xf8>
80107385:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107388:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010738b:	74 73                	je     80107400 <deallocuvm+0x160>
8010738d:	83 c3 10             	add    $0x10,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107390:	39 fb                	cmp    %edi,%ebx
80107392:	0f 84 98 00 00 00    	je     80107430 <deallocuvm+0x190>
          struct page p_ram = curproc->ramPages[i];
80107398:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
8010739e:	89 45 c8             	mov    %eax,-0x38(%ebp)
801073a1:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
801073a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801073aa:	8b 83 08 01 00 00    	mov    0x108(%ebx),%eax
801073b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801073b3:	8b 83 0c 01 00 00    	mov    0x10c(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
801073b9:	39 75 d0             	cmp    %esi,-0x30(%ebp)
          struct page p_ram = curproc->ramPages[i];
801073bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
          struct page p_swap = curproc->swappedPages[i];
801073bf:	8b 03                	mov    (%ebx),%eax
801073c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
801073c4:	8b 43 04             	mov    0x4(%ebx),%eax
801073c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801073ca:	8b 43 08             	mov    0x8(%ebx),%eax
801073cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801073d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
801073d6:	75 b0                	jne    80107388 <deallocuvm+0xe8>
801073d8:	39 55 c8             	cmp    %edx,-0x38(%ebp)
801073db:	75 ab                	jne    80107388 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801073dd:	8d 45 c8             	lea    -0x38(%ebp),%eax
801073e0:	83 ec 04             	sub    $0x4,%esp
801073e3:	89 55 bc             	mov    %edx,-0x44(%ebp)
801073e6:	6a 10                	push   $0x10
801073e8:	6a 00                	push   $0x0
801073ea:	50                   	push   %eax
801073eb:	e8 e0 d8 ff ff       	call   80104cd0 <memset>
801073f0:	83 c4 10             	add    $0x10,%esp
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
801073f3:	39 75 e0             	cmp    %esi,-0x20(%ebp)
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801073f6:	8b 55 bc             	mov    -0x44(%ebp),%edx
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
801073f9:	75 92                	jne    8010738d <deallocuvm+0xed>
801073fb:	90                   	nop
801073fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107400:	39 55 d8             	cmp    %edx,-0x28(%ebp)
80107403:	75 88                	jne    8010738d <deallocuvm+0xed>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107405:	8d 45 d8             	lea    -0x28(%ebp),%eax
80107408:	83 ec 04             	sub    $0x4,%esp
8010740b:	83 c3 10             	add    $0x10,%ebx
8010740e:	6a 10                	push   $0x10
80107410:	6a 00                	push   $0x0
80107412:	50                   	push   %eax
80107413:	89 55 bc             	mov    %edx,-0x44(%ebp)
80107416:	e8 b5 d8 ff ff       	call   80104cd0 <memset>
8010741b:	83 c4 10             	add    $0x10,%esp
        for(i = 0; i < MAX_PSYC_PAGES; i++)
8010741e:	39 fb                	cmp    %edi,%ebx
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107420:	8b 55 bc             	mov    -0x44(%ebp),%edx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107423:	0f 85 6f ff ff ff    	jne    80107398 <deallocuvm+0xf8>
80107429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107430:	89 d7                	mov    %edx,%edi
80107432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80107435:	e9 f3 fe ff ff       	jmp    8010732d <deallocuvm+0x8d>
8010743a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107440:	83 ec 0c             	sub    $0xc,%esp
80107443:	53                   	push   %ebx
80107444:	e8 a7 b2 ff ff       	call   801026f0 <kfree>
80107449:	83 c4 10             	add    $0x10,%esp
8010744c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010744f:	e9 d0 fe ff ff       	jmp    80107324 <deallocuvm+0x84>
        panic("kfree");
80107454:	83 ec 0c             	sub    $0xc,%esp
80107457:	68 0a 82 10 80       	push   $0x8010820a
8010745c:	e8 2f 8f ff ff       	call   80100390 <panic>
80107461:	eb 0d                	jmp    80107470 <allocuvm>
80107463:	90                   	nop
80107464:	90                   	nop
80107465:	90                   	nop
80107466:	90                   	nop
80107467:	90                   	nop
80107468:	90                   	nop
80107469:	90                   	nop
8010746a:	90                   	nop
8010746b:	90                   	nop
8010746c:	90                   	nop
8010746d:	90                   	nop
8010746e:	90                   	nop
8010746f:	90                   	nop

80107470 <allocuvm>:
{
80107470:	55                   	push   %ebp
80107471:	89 e5                	mov    %esp,%ebp
80107473:	57                   	push   %edi
80107474:	56                   	push   %esi
80107475:	53                   	push   %ebx
80107476:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107479:	e8 52 ca ff ff       	call   80103ed0 <myproc>
8010747e:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
80107480:	8b 45 10             	mov    0x10(%ebp),%eax
80107483:	85 c0                	test   %eax,%eax
80107485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107488:	0f 88 f2 01 00 00    	js     80107680 <allocuvm+0x210>
  if(newsz < oldsz)
8010748e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107491:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107494:	0f 82 d6 01 00 00    	jb     80107670 <allocuvm+0x200>
  a = PGROUNDUP(oldsz);
8010749a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801074a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801074a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801074a9:	0f 87 f7 00 00 00    	ja     801075a6 <allocuvm+0x136>
801074af:	e9 bf 01 00 00       	jmp    80107673 <allocuvm+0x203>
801074b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        int write_res = writeToSwapFile(curproc, evicted_page->virt_addr, evicted_ind * PGSIZE, PGSIZE);
801074b8:	68 00 10 00 00       	push   $0x1000
801074bd:	68 00 f0 00 00       	push   $0xf000
801074c2:	ff b3 80 02 00 00    	pushl  0x280(%ebx)
801074c8:	53                   	push   %ebx
801074c9:	e8 d2 ad ff ff       	call   801022a0 <writeToSwapFile>
        if(write_res < 0)
801074ce:	83 c4 10             	add    $0x10,%esp
801074d1:	85 c0                	test   %eax,%eax
801074d3:	0f 88 4f 02 00 00    	js     80107728 <allocuvm+0x2b8>
        curproc->swappedPages[curproc->num_swap].isused = 1;
801074d9:	8b 93 8c 02 00 00    	mov    0x28c(%ebx),%edx
        cprintf("num swap: %d\n", curproc->num_swap);
801074df:	83 ec 08             	sub    $0x8,%esp
801074e2:	89 d0                	mov    %edx,%eax
801074e4:	c1 e0 04             	shl    $0x4,%eax
801074e7:	01 d8                	add    %ebx,%eax
        curproc->swappedPages[curproc->num_swap].isused = 1;
801074e9:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
801074f0:	00 00 00 
        curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
801074f3:	8b 8b 80 02 00 00    	mov    0x280(%ebx),%ecx
801074f9:	89 88 90 00 00 00    	mov    %ecx,0x90(%eax)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->pgdir;
801074ff:	8b 4b 04             	mov    0x4(%ebx),%ecx
        curproc->swappedPages[curproc->num_swap].swap_offset = evicted_ind * PGSIZE;
80107502:	c7 80 94 00 00 00 00 	movl   $0xf000,0x94(%eax)
80107509:	f0 00 00 
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->pgdir;
8010750c:	89 88 88 00 00 00    	mov    %ecx,0x88(%eax)
        cprintf("num swap: %d\n", curproc->num_swap);
80107512:	52                   	push   %edx
80107513:	68 e1 89 10 80       	push   $0x801089e1
80107518:	e8 43 91 ff ff       	call   80100660 <cprintf>
        curproc->num_swap ++;
8010751d:	83 83 8c 02 00 00 01 	addl   $0x1,0x28c(%ebx)
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107524:	8b 93 80 02 00 00    	mov    0x280(%ebx),%edx
8010752a:	31 c9                	xor    %ecx,%ecx
8010752c:	8b 83 78 02 00 00    	mov    0x278(%ebx),%eax
80107532:	e8 49 f9 ff ff       	call   80106e80 <walkpgdir>
        if(!(*evicted_pte & PTE_P))
80107537:	8b 10                	mov    (%eax),%edx
80107539:	83 c4 10             	add    $0x10,%esp
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
8010753c:	89 c7                	mov    %eax,%edi
        if(!(*evicted_pte & PTE_P))
8010753e:	f6 c2 01             	test   $0x1,%dl
80107541:	0f 84 d4 01 00 00    	je     8010771b <allocuvm+0x2ab>
        char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107547:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
        kfree(P2V(evicted_pa));
8010754d:	83 ec 0c             	sub    $0xc,%esp
80107550:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107556:	52                   	push   %edx
80107557:	e8 94 b1 ff ff       	call   801026f0 <kfree>
        *evicted_pte &= ~PTE_P;
8010755c:	8b 07                	mov    (%edi),%eax
8010755e:	83 e0 fe             	and    $0xfffffffe,%eax
80107561:	80 cc 02             	or     $0x2,%ah
80107564:	89 07                	mov    %eax,(%edi)
        newpage->pgdir = pgdir; // ??? 
80107566:	8b 45 08             	mov    0x8(%ebp),%eax
        newpage->isused = 1;
80107569:	c7 83 7c 02 00 00 01 	movl   $0x1,0x27c(%ebx)
80107570:	00 00 00 
        newpage->swap_offset = evicted_ind * PGSIZE;
80107573:	c7 83 84 02 00 00 00 	movl   $0xf000,0x284(%ebx)
8010757a:	f0 00 00 
        newpage->virt_addr = (char*)a;
8010757d:	89 b3 80 02 00 00    	mov    %esi,0x280(%ebx)
        newpage->pgdir = pgdir; // ??? 
80107583:	89 83 78 02 00 00    	mov    %eax,0x278(%ebx)
        lcr3(V2P(curproc->pgdir)); // flush TLB
80107589:	8b 43 04             	mov    0x4(%ebx),%eax
8010758c:	05 00 00 00 80       	add    $0x80000000,%eax
80107591:	0f 22 d8             	mov    %eax,%cr3
80107594:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
80107597:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010759d:	39 75 10             	cmp    %esi,0x10(%ebp)
801075a0:	0f 86 cd 00 00 00    	jbe    80107673 <allocuvm+0x203>
    mem = kalloc();
801075a6:	e8 25 b4 ff ff       	call   801029d0 <kalloc>
    if(mem == 0){
801075ab:	85 c0                	test   %eax,%eax
    mem = kalloc();
801075ad:	89 c7                	mov    %eax,%edi
    if(mem == 0){
801075af:	0f 84 f3 00 00 00    	je     801076a8 <allocuvm+0x238>
    memset(mem, 0, PGSIZE);
801075b5:	83 ec 04             	sub    $0x4,%esp
801075b8:	68 00 10 00 00       	push   $0x1000
801075bd:	6a 00                	push   $0x0
801075bf:	50                   	push   %eax
801075c0:	e8 0b d7 ff ff       	call   80104cd0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075c5:	58                   	pop    %eax
801075c6:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801075cc:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075d1:	5a                   	pop    %edx
801075d2:	6a 06                	push   $0x6
801075d4:	50                   	push   %eax
801075d5:	89 f2                	mov    %esi,%edx
801075d7:	8b 45 08             	mov    0x8(%ebp),%eax
801075da:	e8 21 f9 ff ff       	call   80106f00 <mappages>
801075df:	83 c4 10             	add    $0x10,%esp
801075e2:	85 c0                	test   %eax,%eax
801075e4:	0f 88 f6 00 00 00    	js     801076e0 <allocuvm+0x270>
    if(curproc->pid > 2) {
801075ea:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801075ee:	7e a7                	jle    80107597 <allocuvm+0x127>
      if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801075f0:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
801075f7:	0f 8f bb fe ff ff    	jg     801074b8 <allocuvm+0x48>

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
801075fd:	e8 ce c8 ff ff       	call   80103ed0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107602:	31 d2                	xor    %edx,%edx
80107604:	05 8c 01 00 00       	add    $0x18c,%eax
80107609:	eb 10                	jmp    8010761b <allocuvm+0x1ab>
8010760b:	90                   	nop
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107610:	83 c2 01             	add    $0x1,%edx
80107613:	83 c0 10             	add    $0x10,%eax
80107616:	83 fa 10             	cmp    $0x10,%edx
80107619:	74 7d                	je     80107698 <allocuvm+0x228>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
8010761b:	8b 08                	mov    (%eax),%ecx
8010761d:	85 c9                	test   %ecx,%ecx
8010761f:	75 ef                	jne    80107610 <allocuvm+0x1a0>
80107621:	89 d0                	mov    %edx,%eax
80107623:	c1 e0 0c             	shl    $0xc,%eax
          page->pgdir = pgdir;
80107626:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107629:	c1 e2 04             	shl    $0x4,%edx
          cprintf("num ram : %d\n", curproc->num_ram);
8010762c:	83 ec 08             	sub    $0x8,%esp
8010762f:	01 da                	add    %ebx,%edx
          page->isused = 1;
80107631:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80107638:	00 00 00 
          page->swap_offset = new_index * PGSIZE;
8010763b:	89 82 94 01 00 00    	mov    %eax,0x194(%edx)
          page->pgdir = pgdir;
80107641:	89 8a 88 01 00 00    	mov    %ecx,0x188(%edx)
          page->virt_addr = (char*)a;
80107647:	89 b2 90 01 00 00    	mov    %esi,0x190(%edx)
          cprintf("num ram : %d\n", curproc->num_ram);
8010764d:	ff b3 88 02 00 00    	pushl  0x288(%ebx)
80107653:	68 b9 89 10 80       	push   $0x801089b9
80107658:	e8 03 90 ff ff       	call   80100660 <cprintf>
          curproc->num_ram++;
8010765d:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
80107664:	83 c4 10             	add    $0x10,%esp
80107667:	e9 2b ff ff ff       	jmp    80107597 <allocuvm+0x127>
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107679:	5b                   	pop    %ebx
8010767a:	5e                   	pop    %esi
8010767b:	5f                   	pop    %edi
8010767c:	5d                   	pop    %ebp
8010767d:	c3                   	ret    
8010767e:	66 90                	xchg   %ax,%ax
    return 0;
80107680:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768d:	5b                   	pop    %ebx
8010768e:	5e                   	pop    %esi
8010768f:	5f                   	pop    %edi
80107690:	5d                   	pop    %ebp
80107691:	c3                   	ret    
80107692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107698:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
      return i;
  }
  return -1;
8010769d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801076a2:	eb 82                	jmp    80107626 <allocuvm+0x1b6>
801076a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory\n");
801076a8:	83 ec 0c             	sub    $0xc,%esp
801076ab:	68 85 89 10 80       	push   $0x80108985
801076b0:	e8 ab 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801076b5:	83 c4 0c             	add    $0xc,%esp
801076b8:	ff 75 0c             	pushl  0xc(%ebp)
801076bb:	ff 75 10             	pushl  0x10(%ebp)
801076be:	ff 75 08             	pushl  0x8(%ebp)
801076c1:	e8 da fb ff ff       	call   801072a0 <deallocuvm>
      return 0;
801076c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076cd:	83 c4 10             	add    $0x10,%esp
}
801076d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d6:	5b                   	pop    %ebx
801076d7:	5e                   	pop    %esi
801076d8:	5f                   	pop    %edi
801076d9:	5d                   	pop    %ebp
801076da:	c3                   	ret    
801076db:	90                   	nop
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801076e0:	83 ec 0c             	sub    $0xc,%esp
801076e3:	68 9d 89 10 80       	push   $0x8010899d
801076e8:	e8 73 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801076ed:	83 c4 0c             	add    $0xc,%esp
801076f0:	ff 75 0c             	pushl  0xc(%ebp)
801076f3:	ff 75 10             	pushl  0x10(%ebp)
801076f6:	ff 75 08             	pushl  0x8(%ebp)
801076f9:	e8 a2 fb ff ff       	call   801072a0 <deallocuvm>
      kfree(mem);
801076fe:	89 3c 24             	mov    %edi,(%esp)
80107701:	e8 ea af ff ff       	call   801026f0 <kfree>
      return 0;
80107706:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010770d:	83 c4 10             	add    $0x10,%esp
}
80107710:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107713:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107716:	5b                   	pop    %ebx
80107717:	5e                   	pop    %esi
80107718:	5f                   	pop    %edi
80107719:	5d                   	pop    %ebp
8010771a:	c3                   	ret    
          panic("allocuvm: swap: ram page not present");
8010771b:	83 ec 0c             	sub    $0xc,%esp
8010771e:	68 e0 8a 10 80       	push   $0x80108ae0
80107723:	e8 68 8c ff ff       	call   80100390 <panic>
          panic("allocuvm: writeToSwapFile");
80107728:	83 ec 0c             	sub    $0xc,%esp
8010772b:	68 c7 89 10 80       	push   $0x801089c7
80107730:	e8 5b 8c ff ff       	call   80100390 <panic>
80107735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107740 <freevm>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	57                   	push   %edi
80107744:	56                   	push   %esi
80107745:	53                   	push   %ebx
80107746:	83 ec 0c             	sub    $0xc,%esp
80107749:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
8010774c:	85 f6                	test   %esi,%esi
8010774e:	74 59                	je     801077a9 <freevm+0x69>
  deallocuvm(pgdir, KERNBASE, 0);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	89 f3                	mov    %esi,%ebx
80107755:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010775b:	6a 00                	push   $0x0
8010775d:	68 00 00 00 80       	push   $0x80000000
80107762:	56                   	push   %esi
80107763:	e8 38 fb ff ff       	call   801072a0 <deallocuvm>
80107768:	83 c4 10             	add    $0x10,%esp
8010776b:	eb 0a                	jmp    80107777 <freevm+0x37>
8010776d:	8d 76 00             	lea    0x0(%esi),%esi
80107770:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107773:	39 fb                	cmp    %edi,%ebx
80107775:	74 23                	je     8010779a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107777:	8b 03                	mov    (%ebx),%eax
80107779:	a8 01                	test   $0x1,%al
8010777b:	74 f3                	je     80107770 <freevm+0x30>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010777d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107782:	83 ec 0c             	sub    $0xc,%esp
80107785:	83 c3 04             	add    $0x4,%ebx
80107788:	05 00 00 00 80       	add    $0x80000000,%eax
8010778d:	50                   	push   %eax
8010778e:	e8 5d af ff ff       	call   801026f0 <kfree>
80107793:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107796:	39 fb                	cmp    %edi,%ebx
80107798:	75 dd                	jne    80107777 <freevm+0x37>
  kfree((char*)pgdir);
8010779a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010779d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077a0:	5b                   	pop    %ebx
801077a1:	5e                   	pop    %esi
801077a2:	5f                   	pop    %edi
801077a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801077a4:	e9 47 af ff ff       	jmp    801026f0 <kfree>
    panic("freevm: no pgdir");
801077a9:	83 ec 0c             	sub    $0xc,%esp
801077ac:	68 ef 89 10 80       	push   $0x801089ef
801077b1:	e8 da 8b ff ff       	call   80100390 <panic>
801077b6:	8d 76 00             	lea    0x0(%esi),%esi
801077b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077c0 <setupkvm>:
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	56                   	push   %esi
801077c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801077c5:	e8 06 b2 ff ff       	call   801029d0 <kalloc>
801077ca:	85 c0                	test   %eax,%eax
801077cc:	89 c6                	mov    %eax,%esi
801077ce:	74 42                	je     80107812 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077d8:	68 00 10 00 00       	push   $0x1000
801077dd:	6a 00                	push   $0x0
801077df:	50                   	push   %eax
801077e0:	e8 eb d4 ff ff       	call   80104cd0 <memset>
801077e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077eb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077ee:	83 ec 08             	sub    $0x8,%esp
801077f1:	8b 13                	mov    (%ebx),%edx
801077f3:	ff 73 0c             	pushl  0xc(%ebx)
801077f6:	50                   	push   %eax
801077f7:	29 c1                	sub    %eax,%ecx
801077f9:	89 f0                	mov    %esi,%eax
801077fb:	e8 00 f7 ff ff       	call   80106f00 <mappages>
80107800:	83 c4 10             	add    $0x10,%esp
80107803:	85 c0                	test   %eax,%eax
80107805:	78 19                	js     80107820 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107807:	83 c3 10             	add    $0x10,%ebx
8010780a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107810:	75 d6                	jne    801077e8 <setupkvm+0x28>
}
80107812:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107815:	89 f0                	mov    %esi,%eax
80107817:	5b                   	pop    %ebx
80107818:	5e                   	pop    %esi
80107819:	5d                   	pop    %ebp
8010781a:	c3                   	ret    
8010781b:	90                   	nop
8010781c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107820:	83 ec 0c             	sub    $0xc,%esp
80107823:	56                   	push   %esi
      return 0;
80107824:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107826:	e8 15 ff ff ff       	call   80107740 <freevm>
      return 0;
8010782b:	83 c4 10             	add    $0x10,%esp
}
8010782e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107831:	89 f0                	mov    %esi,%eax
80107833:	5b                   	pop    %ebx
80107834:	5e                   	pop    %esi
80107835:	5d                   	pop    %ebp
80107836:	c3                   	ret    
80107837:	89 f6                	mov    %esi,%esi
80107839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107840 <kvmalloc>:
{
80107840:	55                   	push   %ebp
80107841:	89 e5                	mov    %esp,%ebp
80107843:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107846:	e8 75 ff ff ff       	call   801077c0 <setupkvm>
8010784b:	a3 e4 09 1a 80       	mov    %eax,0x801a09e4
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107850:	05 00 00 00 80       	add    $0x80000000,%eax
80107855:	0f 22 d8             	mov    %eax,%cr3
}
80107858:	c9                   	leave  
80107859:	c3                   	ret    
8010785a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107860 <clearpteu>:
{
80107860:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107861:	31 c9                	xor    %ecx,%ecx
{
80107863:	89 e5                	mov    %esp,%ebp
80107865:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107868:	8b 55 0c             	mov    0xc(%ebp),%edx
8010786b:	8b 45 08             	mov    0x8(%ebp),%eax
8010786e:	e8 0d f6 ff ff       	call   80106e80 <walkpgdir>
  if(pte == 0)
80107873:	85 c0                	test   %eax,%eax
80107875:	74 05                	je     8010787c <clearpteu+0x1c>
  *pte &= ~PTE_U;
80107877:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010787a:	c9                   	leave  
8010787b:	c3                   	ret    
    panic("clearpteu");
8010787c:	83 ec 0c             	sub    $0xc,%esp
8010787f:	68 00 8a 10 80       	push   $0x80108a00
80107884:	e8 07 8b ff ff       	call   80100390 <panic>
80107889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107890 <cowuvm>:
{
80107890:	55                   	push   %ebp
80107891:	89 e5                	mov    %esp,%ebp
80107893:	57                   	push   %edi
80107894:	56                   	push   %esi
80107895:	53                   	push   %ebx
80107896:	83 ec 0c             	sub    $0xc,%esp
  if((d = setupkvm()) == 0)
80107899:	e8 22 ff ff ff       	call   801077c0 <setupkvm>
8010789e:	85 c0                	test   %eax,%eax
801078a0:	89 c7                	mov    %eax,%edi
801078a2:	0f 84 92 00 00 00    	je     8010793a <cowuvm+0xaa>
  for(i = 0; i < sz; i += PGSIZE)
801078a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801078ab:	85 c0                	test   %eax,%eax
801078ad:	0f 84 87 00 00 00    	je     8010793a <cowuvm+0xaa>
801078b3:	31 db                	xor    %ebx,%ebx
801078b5:	eb 29                	jmp    801078e0 <cowuvm+0x50>
801078b7:	89 f6                	mov    %esi,%esi
801078b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    refInc(virt_addr);
801078c0:	83 ec 0c             	sub    $0xc,%esp
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801078c3:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801078c9:	56                   	push   %esi
801078ca:	e8 21 b2 ff ff       	call   80102af0 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801078cf:	0f 01 3b             	invlpg (%ebx)
  for(i = 0; i < sz; i += PGSIZE)
801078d2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801078d8:	83 c4 10             	add    $0x10,%esp
801078db:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801078de:	76 5a                	jbe    8010793a <cowuvm+0xaa>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078e0:	8b 45 08             	mov    0x8(%ebp),%eax
801078e3:	31 c9                	xor    %ecx,%ecx
801078e5:	89 da                	mov    %ebx,%edx
801078e7:	e8 94 f5 ff ff       	call   80106e80 <walkpgdir>
801078ec:	85 c0                	test   %eax,%eax
801078ee:	74 61                	je     80107951 <cowuvm+0xc1>
    if(!(*pte & PTE_P))
801078f0:	8b 10                	mov    (%eax),%edx
801078f2:	f6 c2 01             	test   $0x1,%dl
801078f5:	74 4d                	je     80107944 <cowuvm+0xb4>
    *pte &= ~PTE_W;
801078f7:	89 d1                	mov    %edx,%ecx
801078f9:	89 d6                	mov    %edx,%esi
    flags = PTE_FLAGS(*pte);
801078fb:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80107901:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107904:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107907:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
8010790a:	80 cd 04             	or     $0x4,%ch
8010790d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107913:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107915:	52                   	push   %edx
80107916:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010791b:	56                   	push   %esi
8010791c:	89 da                	mov    %ebx,%edx
8010791e:	89 f8                	mov    %edi,%eax
80107920:	e8 db f5 ff ff       	call   80106f00 <mappages>
80107925:	83 c4 10             	add    $0x10,%esp
80107928:	85 c0                	test   %eax,%eax
8010792a:	79 94                	jns    801078c0 <cowuvm+0x30>
  freevm(d);
8010792c:	83 ec 0c             	sub    $0xc,%esp
8010792f:	57                   	push   %edi
  return 0;
80107930:	31 ff                	xor    %edi,%edi
  freevm(d);
80107932:	e8 09 fe ff ff       	call   80107740 <freevm>
  return 0;
80107937:	83 c4 10             	add    $0x10,%esp
}
8010793a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010793d:	89 f8                	mov    %edi,%eax
8010793f:	5b                   	pop    %ebx
80107940:	5e                   	pop    %esi
80107941:	5f                   	pop    %edi
80107942:	5d                   	pop    %ebp
80107943:	c3                   	ret    
      panic("cowuvm: page not present");
80107944:	83 ec 0c             	sub    $0xc,%esp
80107947:	68 19 8a 10 80       	push   $0x80108a19
8010794c:	e8 3f 8a ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107951:	83 ec 0c             	sub    $0xc,%esp
80107954:	68 0a 8a 10 80       	push   $0x80108a0a
80107959:	e8 32 8a ff ff       	call   80100390 <panic>
8010795e:	66 90                	xchg   %ax,%ax

80107960 <getSwappedPageIndex>:
{
80107960:	55                   	push   %ebp
80107961:	89 e5                	mov    %esp,%ebp
80107963:	53                   	push   %ebx
80107964:	83 ec 04             	sub    $0x4,%esp
80107967:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
8010796a:	e8 61 c5 ff ff       	call   80103ed0 <myproc>
8010796f:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107975:	31 c0                	xor    %eax,%eax
80107977:	eb 12                	jmp    8010798b <getSwappedPageIndex+0x2b>
80107979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107980:	83 c0 01             	add    $0x1,%eax
80107983:	83 c2 10             	add    $0x10,%edx
80107986:	83 f8 10             	cmp    $0x10,%eax
80107989:	74 0d                	je     80107998 <getSwappedPageIndex+0x38>
    if(curproc->swappedPages[i].virt_addr == va)
8010798b:	39 1a                	cmp    %ebx,(%edx)
8010798d:	75 f1                	jne    80107980 <getSwappedPageIndex+0x20>
}
8010798f:	83 c4 04             	add    $0x4,%esp
80107992:	5b                   	pop    %ebx
80107993:	5d                   	pop    %ebp
80107994:	c3                   	ret    
80107995:	8d 76 00             	lea    0x0(%esi),%esi
80107998:	83 c4 04             	add    $0x4,%esp
  return -1;
8010799b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a0:	5b                   	pop    %ebx
801079a1:	5d                   	pop    %ebp
801079a2:	c3                   	ret    
801079a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079b0 <pagefault>:
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	57                   	push   %edi
801079b4:	56                   	push   %esi
801079b5:	53                   	push   %ebx
801079b6:	83 ec 28             	sub    $0x28,%esp
  cprintf("PAGEFAULT\n");
801079b9:	68 32 8a 10 80       	push   $0x80108a32
801079be:	e8 9d 8c ff ff       	call   80100660 <cprintf>
  struct proc* curproc = myproc();
801079c3:	e8 08 c5 ff ff       	call   80103ed0 <myproc>
801079c8:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
801079ca:	0f 20 d7             	mov    %cr2,%edi
  uint err = curproc->tf->err;
801079cd:	8b 40 18             	mov    0x18(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
801079d0:	89 fe                	mov    %edi,%esi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801079d2:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
801079d4:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801079da:	89 f2                	mov    %esi,%edx
  uint err = curproc->tf->err;
801079dc:	8b 40 34             	mov    0x34(%eax),%eax
801079df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801079e2:	8b 43 04             	mov    0x4(%ebx),%eax
801079e5:	e8 96 f4 ff ff       	call   80106e80 <walkpgdir>
  if(*pte & PTE_PG) // page was paged out
801079ea:	83 c4 10             	add    $0x10,%esp
801079ed:	f7 00 00 02 00 00    	testl  $0x200,(%eax)
801079f3:	0f 84 1f 01 00 00    	je     80107b18 <pagefault+0x168>
    cprintf("page was paged out\n");
801079f9:	83 ec 0c             	sub    $0xc,%esp
801079fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079ff:	68 3d 8a 10 80       	push   $0x80108a3d
80107a04:	e8 57 8c ff ff       	call   80100660 <cprintf>
    new_page = kalloc();
80107a09:	e8 c2 af ff ff       	call   801029d0 <kalloc>
    *pte &= ~PTE_PG;                 //  points to a newly allocated page
80107a0e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    *pte |= V2P(new_page);           //  returned from kalloc()
80107a11:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= ~PTE_PG;                 //  points to a newly allocated page
80107a16:	8b 0a                	mov    (%edx),%ecx
80107a18:	80 e5 fd             	and    $0xfd,%ch
80107a1b:	83 c9 07             	or     $0x7,%ecx
    *pte |= V2P(new_page);           //  returned from kalloc()
80107a1e:	09 c8                	or     %ecx,%eax
80107a20:	89 02                	mov    %eax,(%edx)
  struct proc* curproc = myproc();
80107a22:	e8 a9 c4 ff ff       	call   80103ed0 <myproc>
80107a27:	83 c4 10             	add    $0x10,%esp
80107a2a:	05 90 00 00 00       	add    $0x90,%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107a2f:	31 d2                	xor    %edx,%edx
80107a31:	eb 14                	jmp    80107a47 <pagefault+0x97>
80107a33:	90                   	nop
80107a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a38:	83 c2 01             	add    $0x1,%edx
80107a3b:	83 c0 10             	add    $0x10,%eax
80107a3e:	83 fa 10             	cmp    $0x10,%edx
80107a41:	0f 84 e1 01 00 00    	je     80107c28 <pagefault+0x278>
    if(curproc->swappedPages[i].virt_addr == va)
80107a47:	3b 30                	cmp    (%eax),%esi
80107a49:	75 ed                	jne    80107a38 <pagefault+0x88>
80107a4b:	89 d0                	mov    %edx,%eax
80107a4d:	c1 e0 04             	shl    $0x4,%eax
80107a50:	8d b8 88 00 00 00    	lea    0x88(%eax),%edi
80107a56:	89 d1                	mov    %edx,%ecx
    struct page *swap_page = &curproc->swappedPages[index];
80107a58:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
    readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE);
80107a5b:	68 00 10 00 00       	push   $0x1000
80107a60:	c1 e1 04             	shl    $0x4,%ecx
80107a63:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107a66:	8d 3c 0b             	lea    (%ebx,%ecx,1),%edi
    struct page *swap_page = &curproc->swappedPages[index];
80107a69:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE);
80107a6c:	ff b7 94 00 00 00    	pushl  0x94(%edi)
80107a72:	68 00 c6 11 80       	push   $0x8011c600
80107a77:	53                   	push   %ebx
80107a78:	e8 53 a8 ff ff       	call   801022d0 <readFromSwapFile>
    memmove((void*)start_page, buffer, PGSIZE);
80107a7d:	83 c4 0c             	add    $0xc,%esp
80107a80:	68 00 10 00 00       	push   $0x1000
80107a85:	68 00 c6 11 80       	push   $0x8011c600
80107a8a:	56                   	push   %esi
80107a8b:	e8 f0 d2 ff ff       	call   80104d80 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80107a90:	83 c4 0c             	add    $0xc,%esp
80107a93:	6a 10                	push   $0x10
80107a95:	6a 00                	push   $0x0
80107a97:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a9a:	e8 31 d2 ff ff       	call   80104cd0 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80107a9f:	83 c4 10             	add    $0x10,%esp
80107aa2:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
80107aa9:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107aac:	0f 8f de 00 00 00    	jg     80107b90 <pagefault+0x1e0>
  struct proc * currproc = myproc();
80107ab2:	e8 19 c4 ff ff       	call   80103ed0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107ab7:	31 d2                	xor    %edx,%edx
80107ab9:	05 8c 01 00 00       	add    $0x18c,%eax
80107abe:	eb 0f                	jmp    80107acf <pagefault+0x11f>
80107ac0:	83 c2 01             	add    $0x1,%edx
80107ac3:	83 c0 10             	add    $0x10,%eax
80107ac6:	83 fa 10             	cmp    $0x10,%edx
80107ac9:	0f 84 a1 01 00 00    	je     80107c70 <pagefault+0x2c0>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107acf:	8b 08                	mov    (%eax),%ecx
80107ad1:	85 c9                	test   %ecx,%ecx
80107ad3:	75 eb                	jne    80107ac0 <pagefault+0x110>
80107ad5:	89 d0                	mov    %edx,%eax
80107ad7:	c1 e0 0c             	shl    $0xc,%eax
80107ada:	c1 e2 04             	shl    $0x4,%edx
80107add:	01 da                	add    %ebx,%edx
      curproc->ramPages[new_indx].virt_addr = start_page;
80107adf:	89 b2 90 01 00 00    	mov    %esi,0x190(%edx)
      curproc->ramPages[new_indx].isused = 1;
80107ae5:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80107aec:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80107aef:	8b 4b 04             	mov    0x4(%ebx),%ecx
      curproc->ramPages[new_indx].swap_offset = new_indx * PGSIZE; //change the swap offset by the new index
80107af2:	89 82 94 01 00 00    	mov    %eax,0x194(%edx)
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80107af8:	89 8a 88 01 00 00    	mov    %ecx,0x188(%edx)
      curproc->num_ram++;      
80107afe:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
      curproc->num_swap--;
80107b05:	83 ab 8c 02 00 00 01 	subl   $0x1,0x28c(%ebx)
}
80107b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b0f:	5b                   	pop    %ebx
80107b10:	5e                   	pop    %esi
80107b11:	5f                   	pop    %edi
80107b12:	5d                   	pop    %ebp
80107b13:	c3                   	ret    
80107b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("page was not paged out\n");
80107b18:	83 ec 0c             	sub    $0xc,%esp
80107b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107b1e:	68 51 8a 10 80       	push   $0x80108a51
80107b23:	e8 38 8b ff ff       	call   80100660 <cprintf>
    if(va >= KERNBASE || pte == 0)
80107b28:	83 c4 10             	add    $0x10,%esp
80107b2b:	85 ff                	test   %edi,%edi
80107b2d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107b30:	0f 88 0a 01 00 00    	js     80107c40 <pagefault+0x290>
  if(err & FEC_WR)
80107b36:	f6 45 e4 02          	testb  $0x2,-0x1c(%ebp)
80107b3a:	74 44                	je     80107b80 <pagefault+0x1d0>
    if(!(*pte & PTE_COW)) 
80107b3c:	8b 32                	mov    (%edx),%esi
80107b3e:	f7 c6 00 04 00 00    	test   $0x400,%esi
80107b44:	74 3a                	je     80107b80 <pagefault+0x1d0>
      pa = PTE_ADDR(*pte);
80107b46:	89 f3                	mov    %esi,%ebx
      ref_count = getRefs(virt_addr);
80107b48:	83 ec 0c             	sub    $0xc,%esp
80107b4b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80107b4e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107b54:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      ref_count = getRefs(virt_addr);
80107b5a:	53                   	push   %ebx
80107b5b:	e8 00 b0 ff ff       	call   80102b60 <getRefs>
      if (ref_count > 1) // more than one reference
80107b60:	83 c4 10             	add    $0x10,%esp
80107b63:	83 f8 01             	cmp    $0x1,%eax
80107b66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b69:	0f 8f 10 01 00 00    	jg     80107c7f <pagefault+0x2cf>
        *pte &= ~PTE_COW; // turn COW off
80107b6f:	8b 02                	mov    (%edx),%eax
80107b71:	80 e4 fb             	and    $0xfb,%ah
80107b74:	83 c8 02             	or     $0x2,%eax
80107b77:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107b79:	0f 01 3f             	invlpg (%edi)
80107b7c:	eb 09                	jmp    80107b87 <pagefault+0x1d7>
80107b7e:	66 90                	xchg   %ax,%ax
    curproc->killed = 1;
80107b80:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
80107b87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b8a:	5b                   	pop    %ebx
80107b8b:	5e                   	pop    %esi
80107b8c:	5f                   	pop    %edi
80107b8d:	5d                   	pop    %ebp
80107b8e:	c3                   	ret    
80107b8f:	90                   	nop
      swap_page->virt_addr = ram_page->virt_addr;
80107b90:	8b 83 80 02 00 00    	mov    0x280(%ebx),%eax
      swap_page->swap_offset = index * PGSIZE;
80107b96:	c1 e2 0c             	shl    $0xc,%edx
      swap_page->virt_addr = ram_page->virt_addr;
80107b99:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
      swap_page->pgdir = ram_page->pgdir;
80107b9f:	8b 8b 78 02 00 00    	mov    0x278(%ebx),%ecx
      swap_page->swap_offset = index * PGSIZE;
80107ba5:	89 97 94 00 00 00    	mov    %edx,0x94(%edi)
      swap_page->isused = 1;
80107bab:	c7 87 8c 00 00 00 01 	movl   $0x1,0x8c(%edi)
80107bb2:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80107bb5:	89 8f 88 00 00 00    	mov    %ecx,0x88(%edi)
      writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_page->swap_offset, PGSIZE);   // buffer now has bytes from swapped page (faulty one)
80107bbb:	68 00 10 00 00       	push   $0x1000
80107bc0:	52                   	push   %edx
80107bc1:	50                   	push   %eax
80107bc2:	53                   	push   %ebx
80107bc3:	e8 d8 a6 ff ff       	call   801022a0 <writeToSwapFile>
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107bc8:	8b 93 80 02 00 00    	mov    0x280(%ebx),%edx
80107bce:	8b 43 04             	mov    0x4(%ebx),%eax
80107bd1:	31 c9                	xor    %ecx,%ecx
80107bd3:	e8 a8 f2 ff ff       	call   80106e80 <walkpgdir>
      if(!(*pte & PTE_P))
80107bd8:	8b 10                	mov    (%eax),%edx
80107bda:	83 c4 10             	add    $0x10,%esp
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107bdd:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80107bdf:	f6 c2 01             	test   $0x1,%dl
80107be2:	0f 84 de 00 00 00    	je     80107cc6 <pagefault+0x316>
      ramPa = (void*)PTE_ADDR(*pte);
80107be8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80107bee:	83 ec 0c             	sub    $0xc,%esp
80107bf1:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107bf7:	52                   	push   %edx
80107bf8:	e8 f3 aa ff ff       	call   801026f0 <kfree>
      *pte &= ~PTE_P;                              // turn "present" flag off
80107bfd:	8b 07                	mov    (%edi),%eax
80107bff:	83 e0 fe             	and    $0xfffffffe,%eax
80107c02:	80 cc 02             	or     $0x2,%ah
80107c05:	89 07                	mov    %eax,(%edi)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80107c07:	8b 43 04             	mov    0x4(%ebx),%eax
80107c0a:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107c0f:	0f 22 d8             	mov    %eax,%cr3
      ram_page->virt_addr = start_page;
80107c12:	89 b3 80 02 00 00    	mov    %esi,0x280(%ebx)
80107c18:	83 c4 10             	add    $0x10,%esp
}
80107c1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c1e:	5b                   	pop    %ebx
80107c1f:	5e                   	pop    %esi
80107c20:	5f                   	pop    %edi
80107c21:	5d                   	pop    %ebp
80107c22:	c3                   	ret    
80107c23:	90                   	nop
80107c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107c28:	bf 78 00 00 00       	mov    $0x78,%edi
  return -1;
80107c2d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107c32:	e9 1f fe ff ff       	jmp    80107a56 <pagefault+0xa6>
80107c37:	89 f6                	mov    %esi,%esi
80107c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80107c40:	8d 43 6c             	lea    0x6c(%ebx),%eax
80107c43:	83 ec 04             	sub    $0x4,%esp
80107c46:	50                   	push   %eax
80107c47:	ff 73 10             	pushl  0x10(%ebx)
80107c4a:	68 2c 8b 10 80       	push   $0x80108b2c
80107c4f:	e8 0c 8a ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80107c54:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
80107c5b:	83 c4 10             	add    $0x10,%esp
}
80107c5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c61:	5b                   	pop    %ebx
80107c62:	5e                   	pop    %esi
80107c63:	5f                   	pop    %edi
80107c64:	5d                   	pop    %ebp
80107c65:	c3                   	ret    
80107c66:	8d 76 00             	lea    0x0(%esi),%esi
80107c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107c70:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
  return -1;
80107c75:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107c7a:	e9 5b fe ff ff       	jmp    80107ada <pagefault+0x12a>
80107c7f:	89 55 e0             	mov    %edx,-0x20(%ebp)
        new_page = kalloc();
80107c82:	e8 49 ad ff ff       	call   801029d0 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80107c87:	83 ec 04             	sub    $0x4,%esp
80107c8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c8d:	68 00 10 00 00       	push   $0x1000
80107c92:	53                   	push   %ebx
80107c93:	50                   	push   %eax
80107c94:	e8 e7 d0 ff ff       	call   80104d80 <memmove>
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c99:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
80107c9c:	89 f0                	mov    %esi,%eax
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80107c9e:	8b 55 e0             	mov    -0x20(%ebp),%edx
      flags = PTE_FLAGS(*pte);
80107ca1:	25 ff 0f 00 00       	and    $0xfff,%eax
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80107ca6:	83 c8 03             	or     $0x3,%eax
80107ca9:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107caf:	09 c8                	or     %ecx,%eax
80107cb1:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107cb3:	0f 01 3f             	invlpg (%edi)
        refDec(virt_addr); // decrement old page's ref count
80107cb6:	89 1c 24             	mov    %ebx,(%esp)
80107cb9:	e8 c2 ad ff ff       	call   80102a80 <refDec>
80107cbe:	83 c4 10             	add    $0x10,%esp
80107cc1:	e9 c1 fe ff ff       	jmp    80107b87 <pagefault+0x1d7>
        panic("pagefault: ram page is not present");
80107cc6:	83 ec 0c             	sub    $0xc,%esp
80107cc9:	68 08 8b 10 80       	push   $0x80108b08
80107cce:	e8 bd 86 ff ff       	call   80100390 <panic>
80107cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ce0 <copyuvm>:
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	57                   	push   %edi
80107ce4:	56                   	push   %esi
80107ce5:	53                   	push   %ebx
80107ce6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
80107ce9:	e8 d2 fa ff ff       	call   801077c0 <setupkvm>
80107cee:	85 c0                	test   %eax,%eax
80107cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cf3:	0f 84 fd 00 00 00    	je     80107df6 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80107cf9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107cfc:	85 db                	test   %ebx,%ebx
80107cfe:	0f 84 f2 00 00 00    	je     80107df6 <copyuvm+0x116>
80107d04:	31 db                	xor    %ebx,%ebx
80107d06:	eb 37                	jmp    80107d3f <copyuvm+0x5f>
80107d08:	90                   	nop
80107d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
80107d10:	83 ec 08             	sub    $0x8,%esp
80107d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d16:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d1b:	56                   	push   %esi
80107d1c:	6a 00                	push   $0x0
80107d1e:	89 da                	mov    %ebx,%edx
80107d20:	e8 db f1 ff ff       	call   80106f00 <mappages>
80107d25:	83 c4 10             	add    $0x10,%esp
80107d28:	85 c0                	test   %eax,%eax
80107d2a:	0f 88 eb 00 00 00    	js     80107e1b <copyuvm+0x13b>
  for(i = 0; i < sz; i += PGSIZE){
80107d30:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107d36:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107d39:	0f 86 b7 00 00 00    	jbe    80107df6 <copyuvm+0x116>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d42:	31 c9                	xor    %ecx,%ecx
80107d44:	89 da                	mov    %ebx,%edx
80107d46:	e8 35 f1 ff ff       	call   80106e80 <walkpgdir>
80107d4b:	85 c0                	test   %eax,%eax
80107d4d:	0f 84 bb 00 00 00    	je     80107e0e <copyuvm+0x12e>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107d53:	8b 10                	mov    (%eax),%edx
80107d55:	f7 c2 01 02 00 00    	test   $0x201,%edx
80107d5b:	0f 84 a0 00 00 00    	je     80107e01 <copyuvm+0x121>
    flags = PTE_FLAGS(*pte);
80107d61:	89 d6                	mov    %edx,%esi
80107d63:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    if(*pte & PTE_PG)
80107d69:	f6 c6 02             	test   $0x2,%dh
80107d6c:	75 a2                	jne    80107d10 <copyuvm+0x30>
80107d6e:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107d71:	e8 5a ac ff ff       	call   801029d0 <kalloc>
80107d76:	85 c0                	test   %eax,%eax
80107d78:	89 c7                	mov    %eax,%edi
80107d7a:	74 5a                	je     80107dd6 <copyuvm+0xf6>
    pa = PTE_ADDR(*pte);
80107d7c:	8b 55 e0             	mov    -0x20(%ebp),%edx
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d7f:	83 ec 04             	sub    $0x4,%esp
80107d82:	68 00 10 00 00       	push   $0x1000
    pa = PTE_ADDR(*pte);
80107d87:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d8d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d93:	52                   	push   %edx
80107d94:	50                   	push   %eax
80107d95:	e8 e6 cf ff ff       	call   80104d80 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107d9a:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107da0:	5a                   	pop    %edx
80107da1:	59                   	pop    %ecx
80107da2:	56                   	push   %esi
80107da3:	50                   	push   %eax
80107da4:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107dac:	89 da                	mov    %ebx,%edx
80107dae:	e8 4d f1 ff ff       	call   80106f00 <mappages>
80107db3:	83 c4 10             	add    $0x10,%esp
80107db6:	85 c0                	test   %eax,%eax
80107db8:	0f 89 72 ff ff ff    	jns    80107d30 <copyuvm+0x50>
      cprintf("copyuvm: mappages failed\n");
80107dbe:	83 ec 0c             	sub    $0xc,%esp
80107dc1:	68 9c 8a 10 80       	push   $0x80108a9c
80107dc6:	e8 95 88 ff ff       	call   80100660 <cprintf>
      kfree(mem);
80107dcb:	89 3c 24             	mov    %edi,(%esp)
80107dce:	e8 1d a9 ff ff       	call   801026f0 <kfree>
      goto bad;
80107dd3:	83 c4 10             	add    $0x10,%esp
  cprintf("bad!\n");
80107dd6:	83 ec 0c             	sub    $0xc,%esp
80107dd9:	68 b6 8a 10 80       	push   $0x80108ab6
80107dde:	e8 7d 88 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107de3:	58                   	pop    %eax
80107de4:	ff 75 e4             	pushl  -0x1c(%ebp)
80107de7:	e8 54 f9 ff ff       	call   80107740 <freevm>
  return 0;
80107dec:	83 c4 10             	add    $0x10,%esp
80107def:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107df9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dfc:	5b                   	pop    %ebx
80107dfd:	5e                   	pop    %esi
80107dfe:	5f                   	pop    %edi
80107dff:	5d                   	pop    %ebp
80107e00:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
80107e01:	83 ec 0c             	sub    $0xc,%esp
80107e04:	68 60 8b 10 80       	push   $0x80108b60
80107e09:	e8 82 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107e0e:	83 ec 0c             	sub    $0xc,%esp
80107e11:	68 69 8a 10 80       	push   $0x80108a69
80107e16:	e8 75 85 ff ff       	call   80100390 <panic>
        panic("copyuvm: mappages failed");
80107e1b:	83 ec 0c             	sub    $0xc,%esp
80107e1e:	68 83 8a 10 80       	push   $0x80108a83
80107e23:	e8 68 85 ff ff       	call   80100390 <panic>
80107e28:	90                   	nop
80107e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e30 <uva2ka>:
{
80107e30:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107e31:	31 c9                	xor    %ecx,%ecx
{
80107e33:	89 e5                	mov    %esp,%ebp
80107e35:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e38:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e3b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e3e:	e8 3d f0 ff ff       	call   80106e80 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107e43:	8b 00                	mov    (%eax),%eax
}
80107e45:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107e46:	89 c2                	mov    %eax,%edx
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107e48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e4d:	83 e2 05             	and    $0x5,%edx
80107e50:	05 00 00 00 80       	add    $0x80000000,%eax
80107e55:	83 fa 05             	cmp    $0x5,%edx
80107e58:	ba 00 00 00 00       	mov    $0x0,%edx
80107e5d:	0f 45 c2             	cmovne %edx,%eax
}
80107e60:	c3                   	ret    
80107e61:	eb 0d                	jmp    80107e70 <copyout>
80107e63:	90                   	nop
80107e64:	90                   	nop
80107e65:	90                   	nop
80107e66:	90                   	nop
80107e67:	90                   	nop
80107e68:	90                   	nop
80107e69:	90                   	nop
80107e6a:	90                   	nop
80107e6b:	90                   	nop
80107e6c:	90                   	nop
80107e6d:	90                   	nop
80107e6e:	90                   	nop
80107e6f:	90                   	nop

80107e70 <copyout>:
{
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
80107e73:	57                   	push   %edi
80107e74:	56                   	push   %esi
80107e75:	53                   	push   %ebx
80107e76:	83 ec 1c             	sub    $0x1c,%esp
80107e79:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107e7c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80107e82:	85 db                	test   %ebx,%ebx
80107e84:	75 40                	jne    80107ec6 <copyout+0x56>
80107e86:	eb 70                	jmp    80107ef8 <copyout+0x88>
80107e88:	90                   	nop
80107e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80107e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107e93:	89 f1                	mov    %esi,%ecx
80107e95:	29 d1                	sub    %edx,%ecx
80107e97:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107e9d:	39 d9                	cmp    %ebx,%ecx
80107e9f:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
80107ea2:	29 f2                	sub    %esi,%edx
80107ea4:	83 ec 04             	sub    $0x4,%esp
80107ea7:	01 d0                	add    %edx,%eax
80107ea9:	51                   	push   %ecx
80107eaa:	57                   	push   %edi
80107eab:	50                   	push   %eax
80107eac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107eaf:	e8 cc ce ff ff       	call   80104d80 <memmove>
    buf += n;
80107eb4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107eb7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107eba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107ec0:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107ec2:	29 cb                	sub    %ecx,%ebx
80107ec4:	74 32                	je     80107ef8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107ec6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ec8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ecb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107ece:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ed4:	56                   	push   %esi
80107ed5:	ff 75 08             	pushl  0x8(%ebp)
80107ed8:	e8 53 ff ff ff       	call   80107e30 <uva2ka>
    if(pa0 == 0)
80107edd:	83 c4 10             	add    $0x10,%esp
80107ee0:	85 c0                	test   %eax,%eax
80107ee2:	75 ac                	jne    80107e90 <copyout+0x20>
}
80107ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ee7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107eec:	5b                   	pop    %ebx
80107eed:	5e                   	pop    %esi
80107eee:	5f                   	pop    %edi
80107eef:	5d                   	pop    %ebp
80107ef0:	c3                   	ret    
80107ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107efb:	31 c0                	xor    %eax,%eax
}
80107efd:	5b                   	pop    %ebx
80107efe:	5e                   	pop    %esi
80107eff:	5f                   	pop    %edi
80107f00:	5d                   	pop    %ebp
80107f01:	c3                   	ret    
80107f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f10 <getNextFreeRamIndex>:
{ 
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80107f16:	e8 b5 bf ff ff       	call   80103ed0 <myproc>
80107f1b:	8d 90 8c 01 00 00    	lea    0x18c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107f21:	31 c0                	xor    %eax,%eax
80107f23:	eb 0e                	jmp    80107f33 <getNextFreeRamIndex+0x23>
80107f25:	8d 76 00             	lea    0x0(%esi),%esi
80107f28:	83 c0 01             	add    $0x1,%eax
80107f2b:	83 c2 10             	add    $0x10,%edx
80107f2e:	83 f8 10             	cmp    $0x10,%eax
80107f31:	74 0d                	je     80107f40 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107f33:	8b 0a                	mov    (%edx),%ecx
80107f35:	85 c9                	test   %ecx,%ecx
80107f37:	75 ef                	jne    80107f28 <getNextFreeRamIndex+0x18>
}
80107f39:	c9                   	leave  
80107f3a:	c3                   	ret    
80107f3b:	90                   	nop
80107f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f45:	c9                   	leave  
80107f46:	c3                   	ret    
