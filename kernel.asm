
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
8010002d:	b8 e0 34 10 80       	mov    $0x801034e0,%eax
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
8010004c:	68 20 7f 10 80       	push   $0x80107f20
80100051:	68 00 e6 11 80       	push   $0x8011e600
80100056:	e8 15 4a 00 00       	call   80104a70 <initlock>
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
80100092:	68 27 7f 10 80       	push   $0x80107f27
80100097:	50                   	push   %eax
80100098:	e8 a3 48 00 00       	call   80104940 <initsleeplock>
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
801000e4:	e8 c7 4a 00 00       	call   80104bb0 <acquire>
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
80100162:	e8 09 4b 00 00       	call   80104c70 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 48 00 00       	call   80104980 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 23 00 00       	call   801024f0 <iderw>
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
80100193:	68 2e 7f 10 80       	push   $0x80107f2e
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
801001ae:	e8 6d 48 00 00       	call   80104a20 <holdingsleep>
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
801001c4:	e9 27 23 00 00       	jmp    801024f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 7f 10 80       	push   $0x80107f3f
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
801001ef:	e8 2c 48 00 00       	call   80104a20 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 47 00 00       	call   801049e0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 e6 11 80 	movl   $0x8011e600,(%esp)
8010020b:	e8 a0 49 00 00       	call   80104bb0 <acquire>
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
8010025c:	e9 0f 4a 00 00       	jmp    80104c70 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 7f 10 80       	push   $0x80107f46
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
8010028c:	e8 1f 49 00 00       	call   80104bb0 <acquire>
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
801002c5:	e8 b6 42 00 00       	call   80104580 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 2f 12 80    	mov    0x80122fe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 2f 12 80    	cmp    0x80122fe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 3b 00 00       	call   80103ec0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 7c 49 00 00       	call   80104c70 <release>
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
8010034d:	e8 1e 49 00 00       	call   80104c70 <release>
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
801003a9:	e8 c2 29 00 00       	call   80102d70 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 7f 10 80       	push   $0x80107f4d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 66 8a 10 80 	movl   $0x80108a66,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 b3 46 00 00       	call   80104a90 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 7f 10 80       	push   $0x80107f61
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
8010043a:	e8 51 5f 00 00       	call   80106390 <uartputc>
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
801004ec:	e8 9f 5e 00 00       	call   80106390 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 93 5e 00 00       	call   80106390 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 87 5e 00 00       	call   80106390 <uartputc>
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
80100524:	e8 47 48 00 00       	call   80104d70 <memmove>
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
80100541:	e8 7a 47 00 00       	call   80104cc0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 7f 10 80       	push   $0x80107f65
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
801005b1:	0f b6 92 90 7f 10 80 	movzbl -0x7fef8070(%edx),%edx
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
8010061b:	e8 90 45 00 00       	call   80104bb0 <acquire>
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
80100647:	e8 24 46 00 00       	call   80104c70 <release>
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
8010071f:	e8 4c 45 00 00       	call   80104c70 <release>
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
801007d0:	ba 78 7f 10 80       	mov    $0x80107f78,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 bb 43 00 00       	call   80104bb0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 7f 10 80       	push   $0x80107f7f
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
80100823:	e8 88 43 00 00       	call   80104bb0 <acquire>
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
80100888:	e8 e3 43 00 00       	call   80104c70 <release>
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
80100916:	e8 55 3e 00 00       	call   80104770 <wakeup>
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
80100997:	e9 b4 3e 00 00       	jmp    80104850 <procdump>
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
801009c6:	68 88 7f 10 80       	push   $0x80107f88
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 9b 40 00 00       	call   80104a70 <initlock>

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
801009f9:	e8 a2 1c 00 00       	call   801026a0 <ioapicenable>
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
80100a1c:	e8 9f 34 00 00       	call   80103ec0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 b4 27 00 00       	call   801031e0 <begin_op>

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
80100a6f:	e8 dc 27 00 00       	call   80103250 <end_op>
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
80100a94:	e8 e7 6c 00 00       	call   80107780 <setupkvm>
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
80100af6:	e8 45 69 00 00       	call   80107440 <allocuvm>
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
80100b28:	e8 73 66 00 00       	call   801071a0 <loaduvm>
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
80100b72:	e8 89 6b 00 00       	call   80107700 <freevm>
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
80100b9a:	e8 b1 26 00 00       	call   80103250 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 68 00 00       	call   80107440 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 3a 6b 00 00       	call   80107700 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 78 26 00 00       	call   80103250 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 a1 7f 10 80       	push   $0x80107fa1
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
80100c06:	e8 15 6c 00 00       	call   80107820 <clearpteu>
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
80100c39:	e8 a2 42 00 00       	call   80104ee0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	58                   	pop    %eax
80100c43:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 8f 42 00 00       	call   80104ee0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 ce 71 00 00       	call   80107e30 <copyout>
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
80100cc7:	e8 64 71 00 00       	call   80107e30 <copyout>
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
80100d08:	e8 93 41 00 00       	call   80104ea0 <safestrcpy>
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
80100d72:	e8 99 62 00 00       	call   80107010 <switchuvm>
  freevm(oldpgdir);
80100d77:	89 3c 24             	mov    %edi,(%esp)
80100d7a:	e8 81 69 00 00       	call   80107700 <freevm>
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
80100da6:	68 ad 7f 10 80       	push   $0x80107fad
80100dab:	68 00 30 12 80       	push   $0x80123000
80100db0:	e8 bb 3c 00 00       	call   80104a70 <initlock>
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
80100dd1:	e8 da 3d 00 00       	call   80104bb0 <acquire>
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
80100e01:	e8 6a 3e 00 00       	call   80104c70 <release>
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
80100e1a:	e8 51 3e 00 00       	call   80104c70 <release>
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
80100e3f:	e8 6c 3d 00 00       	call   80104bb0 <acquire>
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
80100e5c:	e8 0f 3e 00 00       	call   80104c70 <release>
  return f;
}
80100e61:	89 d8                	mov    %ebx,%eax
80100e63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e66:	c9                   	leave  
80100e67:	c3                   	ret    
    panic("filedup");
80100e68:	83 ec 0c             	sub    $0xc,%esp
80100e6b:	68 b4 7f 10 80       	push   $0x80107fb4
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
80100e91:	e8 1a 3d 00 00       	call   80104bb0 <acquire>
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
80100ebc:	e9 af 3d 00 00       	jmp    80104c70 <release>
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
80100ee8:	e8 83 3d 00 00       	call   80104c70 <release>
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
80100f11:	e8 7a 2a 00 00       	call   80103990 <pipeclose>
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	eb df                	jmp    80100efa <fileclose+0x7a>
80100f1b:	90                   	nop
80100f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f20:	e8 bb 22 00 00       	call   801031e0 <begin_op>
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
80100f3a:	e9 11 23 00 00       	jmp    80103250 <end_op>
    panic("fileclose");
80100f3f:	83 ec 0c             	sub    $0xc,%esp
80100f42:	68 bc 7f 10 80       	push   $0x80107fbc
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
8010100d:	e9 2e 2b 00 00       	jmp    80103b40 <piperead>
80101012:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101018:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010101d:	eb d7                	jmp    80100ff6 <fileread+0x56>
  panic("fileread");
8010101f:	83 ec 0c             	sub    $0xc,%esp
80101022:	68 c6 7f 10 80       	push   $0x80107fc6
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
80101089:	e8 c2 21 00 00       	call   80103250 <end_op>
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
801010b6:	e8 25 21 00 00       	call   801031e0 <begin_op>
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
801010ed:	e8 5e 21 00 00       	call   80103250 <end_op>
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
8010112d:	e9 fe 28 00 00       	jmp    80103a30 <pipewrite>
        panic("short filewrite");
80101132:	83 ec 0c             	sub    $0xc,%esp
80101135:	68 cf 7f 10 80       	push   $0x80107fcf
8010113a:	e8 51 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 d5 7f 10 80       	push   $0x80107fd5
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
80101199:	e8 12 22 00 00       	call   801033b0 <log_write>
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
801011b3:	68 df 7f 10 80       	push   $0x80107fdf
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
80101264:	68 f2 7f 10 80       	push   $0x80107ff2
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
8010127d:	e8 2e 21 00 00       	call   801033b0 <log_write>
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
801012a5:	e8 16 3a 00 00       	call   80104cc0 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 fe 20 00 00       	call   801033b0 <log_write>
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
801012ea:	e8 c1 38 00 00       	call   80104bb0 <acquire>
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
8010134f:	e8 1c 39 00 00       	call   80104c70 <release>

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
8010137d:	e8 ee 38 00 00       	call   80104c70 <release>
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
80101392:	68 08 80 10 80       	push   $0x80108008
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
8010140e:	e8 9d 1f 00 00       	call   801033b0 <log_write>
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
80101467:	68 18 80 10 80       	push   $0x80108018
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
801014a1:	e8 ca 38 00 00       	call   80104d70 <memmove>
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
801014cc:	68 2b 80 10 80       	push   $0x8010802b
801014d1:	68 20 3a 12 80       	push   $0x80123a20
801014d6:	e8 95 35 00 00       	call   80104a70 <initlock>
801014db:	83 c4 10             	add    $0x10,%esp
801014de:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	68 32 80 10 80       	push   $0x80108032
801014e8:	53                   	push   %ebx
801014e9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014ef:	e8 4c 34 00 00       	call   80104940 <initsleeplock>
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
80101539:	68 dc 80 10 80       	push   $0x801080dc
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
801015ce:	e8 ed 36 00 00       	call   80104cc0 <memset>
      dip->type = type;
801015d3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015d7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015da:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015dd:	89 3c 24             	mov    %edi,(%esp)
801015e0:	e8 cb 1d 00 00       	call   801033b0 <log_write>
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
80101603:	68 38 80 10 80       	push   $0x80108038
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
80101671:	e8 fa 36 00 00       	call   80104d70 <memmove>
  log_write(bp);
80101676:	89 34 24             	mov    %esi,(%esp)
80101679:	e8 32 1d 00 00       	call   801033b0 <log_write>
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
8010169f:	e8 0c 35 00 00       	call   80104bb0 <acquire>
  ip->ref++;
801016a4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016a8:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
801016af:	e8 bc 35 00 00       	call   80104c70 <release>
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
801016e2:	e8 99 32 00 00       	call   80104980 <acquiresleep>
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
80101758:	e8 13 36 00 00       	call   80104d70 <memmove>
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
8010177d:	68 50 80 10 80       	push   $0x80108050
80101782:	e8 09 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101787:	83 ec 0c             	sub    $0xc,%esp
8010178a:	68 4a 80 10 80       	push   $0x8010804a
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
801017b3:	e8 68 32 00 00       	call   80104a20 <holdingsleep>
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
801017cf:	e9 0c 32 00 00       	jmp    801049e0 <releasesleep>
    panic("iunlock");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 5f 80 10 80       	push   $0x8010805f
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
80101800:	e8 7b 31 00 00       	call   80104980 <acquiresleep>
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
8010181a:	e8 c1 31 00 00       	call   801049e0 <releasesleep>
  acquire(&icache.lock);
8010181f:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
80101826:	e8 85 33 00 00       	call   80104bb0 <acquire>
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
80101840:	e9 2b 34 00 00       	jmp    80104c70 <release>
80101845:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101848:	83 ec 0c             	sub    $0xc,%esp
8010184b:	68 20 3a 12 80       	push   $0x80123a20
80101850:	e8 5b 33 00 00       	call   80104bb0 <acquire>
    int r = ip->ref;
80101855:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101858:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
8010185f:	e8 0c 34 00 00       	call   80104c70 <release>
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
80101a47:	e8 24 33 00 00       	call   80104d70 <memmove>
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
80101b43:	e8 28 32 00 00       	call   80104d70 <memmove>
    log_write(bp);
80101b48:	89 3c 24             	mov    %edi,(%esp)
80101b4b:	e8 60 18 00 00       	call   801033b0 <log_write>
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
80101bde:	e8 fd 31 00 00       	call   80104de0 <strncmp>
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
80101c3d:	e8 9e 31 00 00       	call   80104de0 <strncmp>
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
80101c82:	68 79 80 10 80       	push   $0x80108079
80101c87:	e8 04 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c8c:	83 ec 0c             	sub    $0xc,%esp
80101c8f:	68 67 80 10 80       	push   $0x80108067
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
80101cb9:	e8 02 22 00 00       	call   80103ec0 <myproc>
  acquire(&icache.lock);
80101cbe:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101cc1:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cc4:	68 20 3a 12 80       	push   $0x80123a20
80101cc9:	e8 e2 2e 00 00       	call   80104bb0 <acquire>
  ip->ref++;
80101cce:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cd2:	c7 04 24 20 3a 12 80 	movl   $0x80123a20,(%esp)
80101cd9:	e8 92 2f 00 00       	call   80104c70 <release>
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
80101d35:	e8 36 30 00 00       	call   80104d70 <memmove>
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
80101dc8:	e8 a3 2f 00 00       	call   80104d70 <memmove>
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
80101ebd:	e8 7e 2f 00 00       	call   80104e40 <strncpy>
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
80101efb:	68 88 80 10 80       	push   $0x80108088
80101f00:	e8 8b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	68 35 87 10 80       	push   $0x80108735
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
80102001:	68 95 80 10 80       	push   $0x80108095
80102006:	56                   	push   %esi
80102007:	e8 64 2d 00 00       	call   80104d70 <memmove>
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
80102022:	0f 84 88 01 00 00    	je     801021b0 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102028:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010202b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010202e:	50                   	push   %eax
8010202f:	e8 4c ee ff ff       	call   80100e80 <fileclose>

  begin_op();
80102034:	e8 a7 11 00 00       	call   801031e0 <begin_op>
  return namex(path, 1, name);
80102039:	89 f0                	mov    %esi,%eax
8010203b:	89 d9                	mov    %ebx,%ecx
8010203d:	ba 01 00 00 00       	mov    $0x1,%edx
80102042:	e8 59 fc ff ff       	call   80101ca0 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010204c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010204e:	0f 84 66 01 00 00    	je     801021ba <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	50                   	push   %eax
80102058:	e8 63 f6 ff ff       	call   801016c0 <ilock>
  return strncmp(s, t, DIRSIZ);
8010205d:	83 c4 0c             	add    $0xc,%esp
80102060:	6a 0e                	push   $0xe
80102062:	68 9d 80 10 80       	push   $0x8010809d
80102067:	53                   	push   %ebx
80102068:	e8 73 2d 00 00       	call   80104de0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010206d:	83 c4 10             	add    $0x10,%esp
80102070:	85 c0                	test   %eax,%eax
80102072:	0f 84 f8 00 00 00    	je     80102170 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102078:	83 ec 04             	sub    $0x4,%esp
8010207b:	6a 0e                	push   $0xe
8010207d:	68 9c 80 10 80       	push   $0x8010809c
80102082:	53                   	push   %ebx
80102083:	e8 58 2d 00 00       	call   80104de0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102088:	83 c4 10             	add    $0x10,%esp
8010208b:	85 c0                	test   %eax,%eax
8010208d:	0f 84 dd 00 00 00    	je     80102170 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102093:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102096:	83 ec 04             	sub    $0x4,%esp
80102099:	50                   	push   %eax
8010209a:	53                   	push   %ebx
8010209b:	56                   	push   %esi
8010209c:	e8 4f fb ff ff       	call   80101bf0 <dirlookup>
801020a1:	83 c4 10             	add    $0x10,%esp
801020a4:	85 c0                	test   %eax,%eax
801020a6:	89 c3                	mov    %eax,%ebx
801020a8:	0f 84 c2 00 00 00    	je     80102170 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
801020ae:	83 ec 0c             	sub    $0xc,%esp
801020b1:	50                   	push   %eax
801020b2:	e8 09 f6 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801020bf:	0f 8e 11 01 00 00    	jle    801021d6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801020c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020ca:	74 74                	je     80102140 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801020cc:	8d 7d d8             	lea    -0x28(%ebp),%edi
801020cf:	83 ec 04             	sub    $0x4,%esp
801020d2:	6a 10                	push   $0x10
801020d4:	6a 00                	push   $0x0
801020d6:	57                   	push   %edi
801020d7:	e8 e4 2b 00 00       	call   80104cc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020dc:	6a 10                	push   $0x10
801020de:	ff 75 b8             	pushl  -0x48(%ebp)
801020e1:	57                   	push   %edi
801020e2:	56                   	push   %esi
801020e3:	e8 b8 f9 ff ff       	call   80101aa0 <writei>
801020e8:	83 c4 20             	add    $0x20,%esp
801020eb:	83 f8 10             	cmp    $0x10,%eax
801020ee:	0f 85 d5 00 00 00    	jne    801021c9 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020f4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020f9:	0f 84 91 00 00 00    	je     80102190 <removeSwapFile+0x1a0>
  iunlock(ip);
801020ff:	83 ec 0c             	sub    $0xc,%esp
80102102:	56                   	push   %esi
80102103:	e8 98 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102108:	89 34 24             	mov    %esi,(%esp)
8010210b:	e8 e0 f6 ff ff       	call   801017f0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102110:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102115:	89 1c 24             	mov    %ebx,(%esp)
80102118:	e8 f3 f4 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
8010211d:	89 1c 24             	mov    %ebx,(%esp)
80102120:	e8 7b f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102125:	89 1c 24             	mov    %ebx,(%esp)
80102128:	e8 c3 f6 ff ff       	call   801017f0 <iput>
  iunlockput(ip);

  end_op();
8010212d:	e8 1e 11 00 00       	call   80103250 <end_op>

  return 0;
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102137:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010213a:	5b                   	pop    %ebx
8010213b:	5e                   	pop    %esi
8010213c:	5f                   	pop    %edi
8010213d:	5d                   	pop    %ebp
8010213e:	c3                   	ret    
8010213f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	53                   	push   %ebx
80102144:	e8 57 33 00 00       	call   801054a0 <isdirempty>
80102149:	83 c4 10             	add    $0x10,%esp
8010214c:	85 c0                	test   %eax,%eax
8010214e:	0f 85 78 ff ff ff    	jne    801020cc <removeSwapFile+0xdc>
  iunlock(ip);
80102154:	83 ec 0c             	sub    $0xc,%esp
80102157:	53                   	push   %ebx
80102158:	e8 43 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
8010215d:	89 1c 24             	mov    %ebx,(%esp)
80102160:	e8 8b f6 ff ff       	call   801017f0 <iput>
80102165:	83 c4 10             	add    $0x10,%esp
80102168:	90                   	nop
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	56                   	push   %esi
80102174:	e8 27 f6 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80102179:	89 34 24             	mov    %esi,(%esp)
8010217c:	e8 6f f6 ff ff       	call   801017f0 <iput>
    end_op();
80102181:	e8 ca 10 00 00       	call   80103250 <end_op>
    return -1;
80102186:	83 c4 10             	add    $0x10,%esp
80102189:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010218e:	eb a7                	jmp    80102137 <removeSwapFile+0x147>
    dp->nlink--;
80102190:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	56                   	push   %esi
80102199:	e8 72 f4 ff ff       	call   80101610 <iupdate>
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	e9 59 ff ff ff       	jmp    801020ff <removeSwapFile+0x10f>
801021a6:	8d 76 00             	lea    0x0(%esi),%esi
801021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801021b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b5:	e9 7d ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    end_op();
801021ba:	e8 91 10 00 00       	call   80103250 <end_op>
    return -1;
801021bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021c4:	e9 6e ff ff ff       	jmp    80102137 <removeSwapFile+0x147>
    panic("unlink: writei");
801021c9:	83 ec 0c             	sub    $0xc,%esp
801021cc:	68 b1 80 10 80       	push   $0x801080b1
801021d1:	e8 ba e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021d6:	83 ec 0c             	sub    $0xc,%esp
801021d9:	68 9f 80 10 80       	push   $0x8010809f
801021de:	e8 ad e1 ff ff       	call   80100390 <panic>
801021e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	56                   	push   %esi
801021f4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021f5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801021f8:	83 ec 14             	sub    $0x14,%esp
801021fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021fe:	6a 06                	push   $0x6
80102200:	68 95 80 10 80       	push   $0x80108095
80102205:	56                   	push   %esi
80102206:	e8 65 2b 00 00       	call   80104d70 <memmove>
  itoa(p->pid, path+ 6);
8010220b:	58                   	pop    %eax
8010220c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010220f:	5a                   	pop    %edx
80102210:	50                   	push   %eax
80102211:	ff 73 10             	pushl  0x10(%ebx)
80102214:	e8 47 fd ff ff       	call   80101f60 <itoa>

    begin_op();
80102219:	e8 c2 0f 00 00       	call   801031e0 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010221e:	6a 00                	push   $0x0
80102220:	6a 00                	push   $0x0
80102222:	6a 02                	push   $0x2
80102224:	56                   	push   %esi
80102225:	e8 86 34 00 00       	call   801056b0 <create>
  iunlock(in);
8010222a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010222d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010222f:	50                   	push   %eax
80102230:	e8 6b f5 ff ff       	call   801017a0 <iunlock>

  p->swapFile = filealloc();
80102235:	e8 86 eb ff ff       	call   80100dc0 <filealloc>
  if (p->swapFile == 0)
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010223f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102242:	74 32                	je     80102276 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102244:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102247:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010224a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102250:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102253:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010225a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010225d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102261:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102264:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102268:	e8 e3 0f 00 00       	call   80103250 <end_op>

    return 0;
}
8010226d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102270:	31 c0                	xor    %eax,%eax
80102272:	5b                   	pop    %ebx
80102273:	5e                   	pop    %esi
80102274:	5d                   	pop    %ebp
80102275:	c3                   	ret    
    panic("no slot for files on /store");
80102276:	83 ec 0c             	sub    $0xc,%esp
80102279:	68 c0 80 10 80       	push   $0x801080c0
8010227e:	e8 0d e1 ff ff       	call   80100390 <panic>
80102283:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)

}
801022ab:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
801022ac:	e9 7f ed ff ff       	jmp    80101030 <filewrite>
801022b1:	eb 0d                	jmp    801022c0 <readFromSwapFile>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801022c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801022c9:	8b 50 7c             	mov    0x7c(%eax),%edx
801022cc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
801022cf:	8b 55 14             	mov    0x14(%ebp),%edx
801022d2:	89 55 10             	mov    %edx,0x10(%ebp)
801022d5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022d8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022db:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022dc:	e9 bf ec ff ff       	jmp    80100fa0 <fileread>
801022e1:	66 90                	xchg   %ax,%ax
801022e3:	66 90                	xchg   %ax,%ax
801022e5:	66 90                	xchg   %ax,%ax
801022e7:	66 90                	xchg   %ax,%ax
801022e9:	66 90                	xchg   %ax,%ax
801022eb:	66 90                	xchg   %ax,%ax
801022ed:	66 90                	xchg   %ax,%ax
801022ef:	90                   	nop

801022f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022f9:	85 c0                	test   %eax,%eax
801022fb:	0f 84 b4 00 00 00    	je     801023b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102301:	8b 58 08             	mov    0x8(%eax),%ebx
80102304:	89 c6                	mov    %eax,%esi
80102306:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010230c:	0f 87 96 00 00 00    	ja     801023a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102312:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102317:	89 f6                	mov    %esi,%esi
80102319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102320:	89 ca                	mov    %ecx,%edx
80102322:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102323:	83 e0 c0             	and    $0xffffffc0,%eax
80102326:	3c 40                	cmp    $0x40,%al
80102328:	75 f6                	jne    80102320 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010232a:	31 ff                	xor    %edi,%edi
8010232c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102331:	89 f8                	mov    %edi,%eax
80102333:	ee                   	out    %al,(%dx)
80102334:	b8 01 00 00 00       	mov    $0x1,%eax
80102339:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010233e:	ee                   	out    %al,(%dx)
8010233f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102344:	89 d8                	mov    %ebx,%eax
80102346:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102347:	89 d8                	mov    %ebx,%eax
80102349:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010234e:	c1 f8 08             	sar    $0x8,%eax
80102351:	ee                   	out    %al,(%dx)
80102352:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102357:	89 f8                	mov    %edi,%eax
80102359:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010235a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010235e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102363:	c1 e0 04             	shl    $0x4,%eax
80102366:	83 e0 10             	and    $0x10,%eax
80102369:	83 c8 e0             	or     $0xffffffe0,%eax
8010236c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010236d:	f6 06 04             	testb  $0x4,(%esi)
80102370:	75 16                	jne    80102388 <idestart+0x98>
80102372:	b8 20 00 00 00       	mov    $0x20,%eax
80102377:	89 ca                	mov    %ecx,%edx
80102379:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010237a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010237d:	5b                   	pop    %ebx
8010237e:	5e                   	pop    %esi
8010237f:	5f                   	pop    %edi
80102380:	5d                   	pop    %ebp
80102381:	c3                   	ret    
80102382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102388:	b8 30 00 00 00       	mov    $0x30,%eax
8010238d:	89 ca                	mov    %ecx,%edx
8010238f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102390:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102395:	83 c6 5c             	add    $0x5c,%esi
80102398:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010239d:	fc                   	cld    
8010239e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023a3:	5b                   	pop    %ebx
801023a4:	5e                   	pop    %esi
801023a5:	5f                   	pop    %edi
801023a6:	5d                   	pop    %ebp
801023a7:	c3                   	ret    
    panic("incorrect blockno");
801023a8:	83 ec 0c             	sub    $0xc,%esp
801023ab:	68 38 81 10 80       	push   $0x80108138
801023b0:	e8 db df ff ff       	call   80100390 <panic>
    panic("idestart");
801023b5:	83 ec 0c             	sub    $0xc,%esp
801023b8:	68 2f 81 10 80       	push   $0x8010812f
801023bd:	e8 ce df ff ff       	call   80100390 <panic>
801023c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023d0 <ideinit>:
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023d6:	68 4a 81 10 80       	push   $0x8010814a
801023db:	68 80 b5 10 80       	push   $0x8010b580
801023e0:	e8 8b 26 00 00       	call   80104a70 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023e5:	58                   	pop    %eax
801023e6:	a1 40 5d 19 80       	mov    0x80195d40,%eax
801023eb:	5a                   	pop    %edx
801023ec:	83 e8 01             	sub    $0x1,%eax
801023ef:	50                   	push   %eax
801023f0:	6a 0e                	push   $0xe
801023f2:	e8 a9 02 00 00       	call   801026a0 <ioapicenable>
801023f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ff:	90                   	nop
80102400:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102401:	83 e0 c0             	and    $0xffffffc0,%eax
80102404:	3c 40                	cmp    $0x40,%al
80102406:	75 f8                	jne    80102400 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102408:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010240d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102412:	ee                   	out    %al,(%dx)
80102413:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102418:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010241d:	eb 06                	jmp    80102425 <ideinit+0x55>
8010241f:	90                   	nop
  for(i=0; i<1000; i++){
80102420:	83 e9 01             	sub    $0x1,%ecx
80102423:	74 0f                	je     80102434 <ideinit+0x64>
80102425:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102426:	84 c0                	test   %al,%al
80102428:	74 f6                	je     80102420 <ideinit+0x50>
      havedisk1 = 1;
8010242a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102431:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102434:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102439:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010243e:	ee                   	out    %al,(%dx)
}
8010243f:	c9                   	leave  
80102440:	c3                   	ret    
80102441:	eb 0d                	jmp    80102450 <ideintr>
80102443:	90                   	nop
80102444:	90                   	nop
80102445:	90                   	nop
80102446:	90                   	nop
80102447:	90                   	nop
80102448:	90                   	nop
80102449:	90                   	nop
8010244a:	90                   	nop
8010244b:	90                   	nop
8010244c:	90                   	nop
8010244d:	90                   	nop
8010244e:	90                   	nop
8010244f:	90                   	nop

80102450 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	57                   	push   %edi
80102454:	56                   	push   %esi
80102455:	53                   	push   %ebx
80102456:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102459:	68 80 b5 10 80       	push   $0x8010b580
8010245e:	e8 4d 27 00 00       	call   80104bb0 <acquire>

  if((b = idequeue) == 0){
80102463:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102469:	83 c4 10             	add    $0x10,%esp
8010246c:	85 db                	test   %ebx,%ebx
8010246e:	74 67                	je     801024d7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102470:	8b 43 58             	mov    0x58(%ebx),%eax
80102473:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102478:	8b 3b                	mov    (%ebx),%edi
8010247a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102480:	75 31                	jne    801024b3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102482:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102487:	89 f6                	mov    %esi,%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102490:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102491:	89 c6                	mov    %eax,%esi
80102493:	83 e6 c0             	and    $0xffffffc0,%esi
80102496:	89 f1                	mov    %esi,%ecx
80102498:	80 f9 40             	cmp    $0x40,%cl
8010249b:	75 f3                	jne    80102490 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010249d:	a8 21                	test   $0x21,%al
8010249f:	75 12                	jne    801024b3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801024a1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024a4:	b9 80 00 00 00       	mov    $0x80,%ecx
801024a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024ae:	fc                   	cld    
801024af:	f3 6d                	rep insl (%dx),%es:(%edi)
801024b1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024b3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801024b6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024b9:	89 f9                	mov    %edi,%ecx
801024bb:	83 c9 02             	or     $0x2,%ecx
801024be:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801024c0:	53                   	push   %ebx
801024c1:	e8 aa 22 00 00       	call   80104770 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024c6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801024cb:	83 c4 10             	add    $0x10,%esp
801024ce:	85 c0                	test   %eax,%eax
801024d0:	74 05                	je     801024d7 <ideintr+0x87>
    idestart(idequeue);
801024d2:	e8 19 fe ff ff       	call   801022f0 <idestart>
    release(&idelock);
801024d7:	83 ec 0c             	sub    $0xc,%esp
801024da:	68 80 b5 10 80       	push   $0x8010b580
801024df:	e8 8c 27 00 00       	call   80104c70 <release>

  release(&idelock);
}
801024e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024e7:	5b                   	pop    %ebx
801024e8:	5e                   	pop    %esi
801024e9:	5f                   	pop    %edi
801024ea:	5d                   	pop    %ebp
801024eb:	c3                   	ret    
801024ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	53                   	push   %ebx
801024f4:	83 ec 10             	sub    $0x10,%esp
801024f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801024fd:	50                   	push   %eax
801024fe:	e8 1d 25 00 00       	call   80104a20 <holdingsleep>
80102503:	83 c4 10             	add    $0x10,%esp
80102506:	85 c0                	test   %eax,%eax
80102508:	0f 84 c6 00 00 00    	je     801025d4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010250e:	8b 03                	mov    (%ebx),%eax
80102510:	83 e0 06             	and    $0x6,%eax
80102513:	83 f8 02             	cmp    $0x2,%eax
80102516:	0f 84 ab 00 00 00    	je     801025c7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010251c:	8b 53 04             	mov    0x4(%ebx),%edx
8010251f:	85 d2                	test   %edx,%edx
80102521:	74 0d                	je     80102530 <iderw+0x40>
80102523:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102528:	85 c0                	test   %eax,%eax
8010252a:	0f 84 b1 00 00 00    	je     801025e1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 80 b5 10 80       	push   $0x8010b580
80102538:	e8 73 26 00 00       	call   80104bb0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010253d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102543:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102546:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010254d:	85 d2                	test   %edx,%edx
8010254f:	75 09                	jne    8010255a <iderw+0x6a>
80102551:	eb 6d                	jmp    801025c0 <iderw+0xd0>
80102553:	90                   	nop
80102554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102558:	89 c2                	mov    %eax,%edx
8010255a:	8b 42 58             	mov    0x58(%edx),%eax
8010255d:	85 c0                	test   %eax,%eax
8010255f:	75 f7                	jne    80102558 <iderw+0x68>
80102561:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102564:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102566:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010256c:	74 42                	je     801025b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010256e:	8b 03                	mov    (%ebx),%eax
80102570:	83 e0 06             	and    $0x6,%eax
80102573:	83 f8 02             	cmp    $0x2,%eax
80102576:	74 23                	je     8010259b <iderw+0xab>
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102580:	83 ec 08             	sub    $0x8,%esp
80102583:	68 80 b5 10 80       	push   $0x8010b580
80102588:	53                   	push   %ebx
80102589:	e8 f2 1f 00 00       	call   80104580 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010258e:	8b 03                	mov    (%ebx),%eax
80102590:	83 c4 10             	add    $0x10,%esp
80102593:	83 e0 06             	and    $0x6,%eax
80102596:	83 f8 02             	cmp    $0x2,%eax
80102599:	75 e5                	jne    80102580 <iderw+0x90>
  }


  release(&idelock);
8010259b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801025a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a5:	c9                   	leave  
  release(&idelock);
801025a6:	e9 c5 26 00 00       	jmp    80104c70 <release>
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801025b0:	89 d8                	mov    %ebx,%eax
801025b2:	e8 39 fd ff ff       	call   801022f0 <idestart>
801025b7:	eb b5                	jmp    8010256e <iderw+0x7e>
801025b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025c0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801025c5:	eb 9d                	jmp    80102564 <iderw+0x74>
    panic("iderw: nothing to do");
801025c7:	83 ec 0c             	sub    $0xc,%esp
801025ca:	68 64 81 10 80       	push   $0x80108164
801025cf:	e8 bc dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025d4:	83 ec 0c             	sub    $0xc,%esp
801025d7:	68 4e 81 10 80       	push   $0x8010814e
801025dc:	e8 af dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025e1:	83 ec 0c             	sub    $0xc,%esp
801025e4:	68 79 81 10 80       	push   $0x80108179
801025e9:	e8 a2 dd ff ff       	call   80100390 <panic>
801025ee:	66 90                	xchg   %ax,%ax

801025f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025f1:	c7 05 74 56 12 80 00 	movl   $0xfec00000,0x80125674
801025f8:	00 c0 fe 
{
801025fb:	89 e5                	mov    %esp,%ebp
801025fd:	56                   	push   %esi
801025fe:	53                   	push   %ebx
  ioapic->reg = reg;
801025ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102606:	00 00 00 
  return ioapic->data;
80102609:	a1 74 56 12 80       	mov    0x80125674,%eax
8010260e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102611:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102617:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010261d:	0f b6 15 a0 57 19 80 	movzbl 0x801957a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102624:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102627:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010262a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010262d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102630:	39 c2                	cmp    %eax,%edx
80102632:	74 16                	je     8010264a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102634:	83 ec 0c             	sub    $0xc,%esp
80102637:	68 98 81 10 80       	push   $0x80108198
8010263c:	e8 1f e0 ff ff       	call   80100660 <cprintf>
80102641:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
80102647:	83 c4 10             	add    $0x10,%esp
8010264a:	83 c3 21             	add    $0x21,%ebx
{
8010264d:	ba 10 00 00 00       	mov    $0x10,%edx
80102652:	b8 20 00 00 00       	mov    $0x20,%eax
80102657:	89 f6                	mov    %esi,%esi
80102659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102660:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102662:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102668:	89 c6                	mov    %eax,%esi
8010266a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102670:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102673:	89 71 10             	mov    %esi,0x10(%ecx)
80102676:	8d 72 01             	lea    0x1(%edx),%esi
80102679:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010267c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010267e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102680:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
80102686:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010268d:	75 d1                	jne    80102660 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010268f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102692:	5b                   	pop    %ebx
80102693:	5e                   	pop    %esi
80102694:	5d                   	pop    %ebp
80102695:	c3                   	ret    
80102696:	8d 76 00             	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026a0:	55                   	push   %ebp
  ioapic->reg = reg;
801026a1:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
{
801026a7:	89 e5                	mov    %esp,%ebp
801026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026ac:	8d 50 20             	lea    0x20(%eax),%edx
801026af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026b5:	8b 0d 74 56 12 80    	mov    0x80125674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026c6:	a1 74 56 12 80       	mov    0x80125674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    
801026d3:	66 90                	xchg   %ax,%ax
801026d5:	66 90                	xchg   %ax,%ax
801026d7:	66 90                	xchg   %ax,%ax
801026d9:	66 90                	xchg   %ax,%ax
801026db:	66 90                	xchg   %ax,%ax
801026dd:	66 90                	xchg   %ax,%ax
801026df:	90                   	nop

801026e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
801026e7:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801026ea:	a9 ff 0f 00 00       	test   $0xfff,%eax
801026ef:	0f 85 ad 00 00 00    	jne    801027a2 <kfree+0xc2>
801026f5:	3d e8 09 1a 80       	cmp    $0x801a09e8,%eax
801026fa:	0f 82 a2 00 00 00    	jb     801027a2 <kfree+0xc2>
#define V2P(a) (((uint) (a)) - KERNBASE)
#define P2V(a) ((void *)(((char *) (a)) + KERNBASE))

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102700:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102706:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010270c:	0f 87 90 00 00 00    	ja     801027a2 <kfree+0xc2>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102712:	83 ec 04             	sub    $0x4,%esp
80102715:	68 00 10 00 00       	push   $0x1000
8010271a:	6a 01                	push   $0x1
8010271c:	50                   	push   %eax
8010271d:	e8 9e 25 00 00       	call   80104cc0 <memset>

  if(kmem.use_lock) 
80102722:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
80102728:	83 c4 10             	add    $0x10,%esp
8010272b:	85 d2                	test   %edx,%edx
8010272d:	75 61                	jne    80102790 <kfree+0xb0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010272f:	c1 eb 0c             	shr    $0xc,%ebx
80102732:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 1)
80102735:	83 3c c5 90 56 12 80 	cmpl   $0x1,-0x7feda970(,%eax,8)
8010273c:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010273d:	8d 14 c5 8c 56 12 80 	lea    -0x7feda974(,%eax,8),%edx
  if(r->refcount != 1)
80102744:	75 69                	jne    801027af <kfree+0xcf>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
80102746:	8b 0d b8 56 12 80    	mov    0x801256b8,%ecx
  r->refcount = 0;
8010274c:	c7 04 c5 90 56 12 80 	movl   $0x0,-0x7feda970(,%eax,8)
80102753:	00 00 00 00 
  kmem.freelist = r;
80102757:	89 15 b8 56 12 80    	mov    %edx,0x801256b8
  r->next = kmem.freelist;
8010275d:	89 0c c5 8c 56 12 80 	mov    %ecx,-0x7feda974(,%eax,8)
  if(kmem.use_lock)
80102764:	a1 b4 56 12 80       	mov    0x801256b4,%eax
80102769:	85 c0                	test   %eax,%eax
8010276b:	75 0b                	jne    80102778 <kfree+0x98>
    release(&kmem.lock);
}
8010276d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102770:	c9                   	leave  
80102771:	c3                   	ret    
80102772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102778:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
8010277f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102782:	c9                   	leave  
    release(&kmem.lock);
80102783:	e9 e8 24 00 00       	jmp    80104c70 <release>
80102788:	90                   	nop
80102789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 80 56 12 80       	push   $0x80125680
80102798:	e8 13 24 00 00       	call   80104bb0 <acquire>
8010279d:	83 c4 10             	add    $0x10,%esp
801027a0:	eb 8d                	jmp    8010272f <kfree+0x4f>
    panic("kfree");
801027a2:	83 ec 0c             	sub    $0xc,%esp
801027a5:	68 ca 81 10 80       	push   $0x801081ca
801027aa:	e8 e1 db ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
801027af:	83 ec 0c             	sub    $0xc,%esp
801027b2:	68 d0 81 10 80       	push   $0x801081d0
801027b7:	e8 d4 db ff ff       	call   80100390 <panic>
801027bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027c0 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	53                   	push   %ebx
801027c4:	83 ec 04             	sub    $0x4,%esp
801027c7:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
801027ca:	a9 ff 0f 00 00       	test   $0xfff,%eax
801027cf:	0f 85 bd 00 00 00    	jne    80102892 <kfree_nocheck+0xd2>
801027d5:	3d e8 09 1a 80       	cmp    $0x801a09e8,%eax
801027da:	0f 82 b2 00 00 00    	jb     80102892 <kfree_nocheck+0xd2>
801027e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801027e6:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
801027ec:	0f 87 a0 00 00 00    	ja     80102892 <kfree_nocheck+0xd2>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801027f2:	83 ec 04             	sub    $0x4,%esp
801027f5:	68 00 10 00 00       	push   $0x1000
801027fa:	6a 01                	push   $0x1
801027fc:	50                   	push   %eax
801027fd:	e8 be 24 00 00       	call   80104cc0 <memset>

  if(kmem.use_lock) 
80102802:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
80102808:	83 c4 10             	add    $0x10,%esp
8010280b:	85 d2                	test   %edx,%edx
8010280d:	75 31                	jne    80102840 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
8010280f:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102814:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102817:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
8010281a:	c7 04 dd 90 56 12 80 	movl   $0x0,-0x7feda970(,%ebx,8)
80102821:	00 00 00 00 
  r->next = kmem.freelist;
80102825:	89 04 dd 8c 56 12 80 	mov    %eax,-0x7feda974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010282c:	8d 04 dd 8c 56 12 80 	lea    -0x7feda974(,%ebx,8),%eax
80102833:	a3 b8 56 12 80       	mov    %eax,0x801256b8
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010283b:	c9                   	leave  
8010283c:	c3                   	ret    
8010283d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102840:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102843:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102846:	68 80 56 12 80       	push   $0x80125680
  r->next = kmem.freelist;
8010284b:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
8010284e:	e8 5d 23 00 00       	call   80104bb0 <acquire>
  r->next = kmem.freelist;
80102853:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  if(kmem.use_lock)
80102858:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
8010285b:	c7 04 dd 90 56 12 80 	movl   $0x0,-0x7feda970(,%ebx,8)
80102862:	00 00 00 00 
  r->next = kmem.freelist;
80102866:	89 04 dd 8c 56 12 80 	mov    %eax,-0x7feda974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010286d:	8d 04 dd 8c 56 12 80 	lea    -0x7feda974(,%ebx,8),%eax
80102874:	a3 b8 56 12 80       	mov    %eax,0x801256b8
  if(kmem.use_lock)
80102879:	a1 b4 56 12 80       	mov    0x801256b4,%eax
8010287e:	85 c0                	test   %eax,%eax
80102880:	74 b6                	je     80102838 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102882:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
80102889:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288c:	c9                   	leave  
    release(&kmem.lock);
8010288d:	e9 de 23 00 00       	jmp    80104c70 <release>
    panic("kfree_nocheck");
80102892:	83 ec 0c             	sub    $0xc,%esp
80102895:	68 ed 81 10 80       	push   $0x801081ed
8010289a:	e8 f1 da ff ff       	call   80100390 <panic>
8010289f:	90                   	nop

801028a0 <freerange>:
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	56                   	push   %esi
801028a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028bd:	39 de                	cmp    %ebx,%esi
801028bf:	72 23                	jb     801028e4 <freerange+0x44>
801028c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
801028c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
801028d7:	50                   	push   %eax
801028d8:	e8 e3 fe ff ff       	call   801027c0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028dd:	83 c4 10             	add    $0x10,%esp
801028e0:	39 f3                	cmp    %esi,%ebx
801028e2:	76 e4                	jbe    801028c8 <freerange+0x28>
}
801028e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028e7:	5b                   	pop    %ebx
801028e8:	5e                   	pop    %esi
801028e9:	5d                   	pop    %ebp
801028ea:	c3                   	ret    
801028eb:	90                   	nop
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <kinit1>:
{
801028f0:	55                   	push   %ebp
801028f1:	89 e5                	mov    %esp,%ebp
801028f3:	56                   	push   %esi
801028f4:	53                   	push   %ebx
801028f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801028f8:	83 ec 08             	sub    $0x8,%esp
801028fb:	68 fb 81 10 80       	push   $0x801081fb
80102900:	68 80 56 12 80       	push   $0x80125680
80102905:	e8 66 21 00 00       	call   80104a70 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010290a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010290d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102910:	c7 05 b4 56 12 80 00 	movl   $0x0,0x801256b4
80102917:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010291a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102920:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102926:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010292c:	39 de                	cmp    %ebx,%esi
8010292e:	72 1c                	jb     8010294c <kinit1+0x5c>
    kfree_nocheck(p);
80102930:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102936:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102939:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
8010293f:	50                   	push   %eax
80102940:	e8 7b fe ff ff       	call   801027c0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102945:	83 c4 10             	add    $0x10,%esp
80102948:	39 de                	cmp    %ebx,%esi
8010294a:	73 e4                	jae    80102930 <kinit1+0x40>
}
8010294c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010294f:	5b                   	pop    %ebx
80102950:	5e                   	pop    %esi
80102951:	5d                   	pop    %ebp
80102952:	c3                   	ret    
80102953:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102960 <kinit2>:
{
80102960:	55                   	push   %ebp
80102961:	89 e5                	mov    %esp,%ebp
80102963:	56                   	push   %esi
80102964:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102965:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102968:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010296b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102971:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102977:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010297d:	39 de                	cmp    %ebx,%esi
8010297f:	72 23                	jb     801029a4 <kinit2+0x44>
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102988:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010298e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102991:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102997:	50                   	push   %eax
80102998:	e8 23 fe ff ff       	call   801027c0 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010299d:	83 c4 10             	add    $0x10,%esp
801029a0:	39 de                	cmp    %ebx,%esi
801029a2:	73 e4                	jae    80102988 <kinit2+0x28>
  kmem.use_lock = 1;
801029a4:	c7 05 b4 56 12 80 01 	movl   $0x1,0x801256b4
801029ab:	00 00 00 
}
801029ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801029b1:	5b                   	pop    %ebx
801029b2:	5e                   	pop    %esi
801029b3:	5d                   	pop    %ebp
801029b4:	c3                   	ret    
801029b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801029b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029c0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801029c0:	55                   	push   %ebp
801029c1:	89 e5                	mov    %esp,%ebp
801029c3:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
801029c6:	a1 b4 56 12 80       	mov    0x801256b4,%eax
801029cb:	85 c0                	test   %eax,%eax
801029cd:	75 59                	jne    80102a28 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
801029cf:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  if(r)
801029d4:	85 c0                	test   %eax,%eax
801029d6:	74 73                	je     80102a4b <kalloc+0x8b>
  {
    kmem.freelist = r->next;
801029d8:	8b 10                	mov    (%eax),%edx
801029da:	89 15 b8 56 12 80    	mov    %edx,0x801256b8
    r->refcount = 1;
801029e0:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
801029e7:	8b 0d b4 56 12 80    	mov    0x801256b4,%ecx
801029ed:	85 c9                	test   %ecx,%ecx
801029ef:	75 0f                	jne    80102a00 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
801029f1:	2d bc 56 12 80       	sub    $0x801256bc,%eax
801029f6:	c1 e0 09             	shl    $0x9,%eax
801029f9:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
801029fe:	c9                   	leave  
801029ff:	c3                   	ret    
    release(&kmem.lock);
80102a00:	83 ec 0c             	sub    $0xc,%esp
80102a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a06:	68 80 56 12 80       	push   $0x80125680
80102a0b:	e8 60 22 00 00       	call   80104c70 <release>
80102a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a13:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102a16:	2d bc 56 12 80       	sub    $0x801256bc,%eax
80102a1b:	c1 e0 09             	shl    $0x9,%eax
80102a1e:	05 00 00 00 80       	add    $0x80000000,%eax
80102a23:	eb d9                	jmp    801029fe <kalloc+0x3e>
80102a25:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102a28:	83 ec 0c             	sub    $0xc,%esp
80102a2b:	68 80 56 12 80       	push   $0x80125680
80102a30:	e8 7b 21 00 00       	call   80104bb0 <acquire>
  r = kmem.freelist;
80102a35:	a1 b8 56 12 80       	mov    0x801256b8,%eax
  if(r)
80102a3a:	83 c4 10             	add    $0x10,%esp
80102a3d:	85 c0                	test   %eax,%eax
80102a3f:	75 97                	jne    801029d8 <kalloc+0x18>
  if(kmem.use_lock)
80102a41:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
80102a47:	85 d2                	test   %edx,%edx
80102a49:	75 05                	jne    80102a50 <kalloc+0x90>
{
80102a4b:	31 c0                	xor    %eax,%eax
}
80102a4d:	c9                   	leave  
80102a4e:	c3                   	ret    
80102a4f:	90                   	nop
    release(&kmem.lock);
80102a50:	83 ec 0c             	sub    $0xc,%esp
80102a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a56:	68 80 56 12 80       	push   $0x80125680
80102a5b:	e8 10 22 00 00       	call   80104c70 <release>
80102a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a63:	83 c4 10             	add    $0x10,%esp
}
80102a66:	c9                   	leave  
80102a67:	c3                   	ret    
80102a68:	90                   	nop
80102a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a70 <refDec>:

void
refDec(char *v)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	53                   	push   %ebx
80102a74:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102a77:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
{
80102a7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102a80:	85 d2                	test   %edx,%edx
80102a82:	75 1c                	jne    80102aa0 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102a84:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102a8a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102a8d:	83 2c c5 c0 56 12 80 	subl   $0x1,-0x7feda940(,%eax,8)
80102a94:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102a95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a98:	c9                   	leave  
80102a99:	c3                   	ret    
80102a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102aa0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102aa3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102aa9:	68 80 56 12 80       	push   $0x80125680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102aae:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ab1:	e8 fa 20 00 00       	call   80104bb0 <acquire>
  if(kmem.use_lock)
80102ab6:	a1 b4 56 12 80       	mov    0x801256b4,%eax
  r->refcount -= 1;
80102abb:	83 2c dd c0 56 12 80 	subl   $0x1,-0x7feda940(,%ebx,8)
80102ac2:	01 
  if(kmem.use_lock)
80102ac3:	83 c4 10             	add    $0x10,%esp
80102ac6:	85 c0                	test   %eax,%eax
80102ac8:	74 cb                	je     80102a95 <refDec+0x25>
    release(&kmem.lock);
80102aca:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
80102ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ad4:	c9                   	leave  
    release(&kmem.lock);
80102ad5:	e9 96 21 00 00       	jmp    80104c70 <release>
80102ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ae0 <refInc>:

void
refInc(char *v)
{
80102ae0:	55                   	push   %ebp
80102ae1:	89 e5                	mov    %esp,%ebp
80102ae3:	53                   	push   %ebx
80102ae4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102ae7:	8b 15 b4 56 12 80    	mov    0x801256b4,%edx
{
80102aed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102af0:	85 d2                	test   %edx,%edx
80102af2:	75 1c                	jne    80102b10 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102af4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102afa:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102afd:	83 04 c5 c0 56 12 80 	addl   $0x1,-0x7feda940(,%eax,8)
80102b04:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b08:	c9                   	leave  
80102b09:	c3                   	ret    
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102b10:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b13:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102b19:	68 80 56 12 80       	push   $0x80125680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b1e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102b21:	e8 8a 20 00 00       	call   80104bb0 <acquire>
  if(kmem.use_lock)
80102b26:	a1 b4 56 12 80       	mov    0x801256b4,%eax
  r->refcount += 1;
80102b2b:	83 04 dd c0 56 12 80 	addl   $0x1,-0x7feda940(,%ebx,8)
80102b32:	01 
  if(kmem.use_lock)
80102b33:	83 c4 10             	add    $0x10,%esp
80102b36:	85 c0                	test   %eax,%eax
80102b38:	74 cb                	je     80102b05 <refInc+0x25>
    release(&kmem.lock);
80102b3a:	c7 45 08 80 56 12 80 	movl   $0x80125680,0x8(%ebp)
}
80102b41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b44:	c9                   	leave  
    release(&kmem.lock);
80102b45:	e9 26 21 00 00       	jmp    80104c70 <release>
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b50 <getRefs>:

int
getRefs(char *v)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b53:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102b56:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102b57:	05 00 00 00 80       	add    $0x80000000,%eax
80102b5c:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102b5f:	8b 04 c5 c0 56 12 80 	mov    -0x7feda940(,%eax,8),%eax
80102b66:	c3                   	ret    
80102b67:	66 90                	xchg   %ax,%ax
80102b69:	66 90                	xchg   %ax,%ax
80102b6b:	66 90                	xchg   %ax,%ax
80102b6d:	66 90                	xchg   %ax,%ax
80102b6f:	90                   	nop

80102b70 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b70:	ba 64 00 00 00       	mov    $0x64,%edx
80102b75:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102b76:	a8 01                	test   $0x1,%al
80102b78:	0f 84 c2 00 00 00    	je     80102c40 <kbdgetc+0xd0>
80102b7e:	ba 60 00 00 00       	mov    $0x60,%edx
80102b83:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102b84:	0f b6 d0             	movzbl %al,%edx
80102b87:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102b8d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102b93:	0f 84 7f 00 00 00    	je     80102c18 <kbdgetc+0xa8>
{
80102b99:	55                   	push   %ebp
80102b9a:	89 e5                	mov    %esp,%ebp
80102b9c:	53                   	push   %ebx
80102b9d:	89 cb                	mov    %ecx,%ebx
80102b9f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102ba2:	84 c0                	test   %al,%al
80102ba4:	78 4a                	js     80102bf0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102ba6:	85 db                	test   %ebx,%ebx
80102ba8:	74 09                	je     80102bb3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102baa:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102bad:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102bb0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102bb3:	0f b6 82 20 83 10 80 	movzbl -0x7fef7ce0(%edx),%eax
80102bba:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102bbc:	0f b6 82 20 82 10 80 	movzbl -0x7fef7de0(%edx),%eax
80102bc3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bc5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102bc7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102bcd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102bd0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102bd3:	8b 04 85 00 82 10 80 	mov    -0x7fef7e00(,%eax,4),%eax
80102bda:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102bde:	74 31                	je     80102c11 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102be0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102be3:	83 fa 19             	cmp    $0x19,%edx
80102be6:	77 40                	ja     80102c28 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102be8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102beb:	5b                   	pop    %ebx
80102bec:	5d                   	pop    %ebp
80102bed:	c3                   	ret    
80102bee:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102bf0:	83 e0 7f             	and    $0x7f,%eax
80102bf3:	85 db                	test   %ebx,%ebx
80102bf5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102bf8:	0f b6 82 20 83 10 80 	movzbl -0x7fef7ce0(%edx),%eax
80102bff:	83 c8 40             	or     $0x40,%eax
80102c02:	0f b6 c0             	movzbl %al,%eax
80102c05:	f7 d0                	not    %eax
80102c07:	21 c1                	and    %eax,%ecx
    return 0;
80102c09:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102c0b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102c11:	5b                   	pop    %ebx
80102c12:	5d                   	pop    %ebp
80102c13:	c3                   	ret    
80102c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102c18:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102c1b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102c1d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102c28:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102c2b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102c2e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102c2f:	83 f9 1a             	cmp    $0x1a,%ecx
80102c32:	0f 42 c2             	cmovb  %edx,%eax
}
80102c35:	5d                   	pop    %ebp
80102c36:	c3                   	ret    
80102c37:	89 f6                	mov    %esi,%esi
80102c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <kbdintr>:

void
kbdintr(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102c56:	68 70 2b 10 80       	push   $0x80102b70
80102c5b:	e8 b0 db ff ff       	call   80100810 <consoleintr>
}
80102c60:	83 c4 10             	add    $0x10,%esp
80102c63:	c9                   	leave  
80102c64:	c3                   	ret    
80102c65:	66 90                	xchg   %ax,%ax
80102c67:	66 90                	xchg   %ax,%ax
80102c69:	66 90                	xchg   %ax,%ax
80102c6b:	66 90                	xchg   %ax,%ax
80102c6d:	66 90                	xchg   %ax,%ax
80102c6f:	90                   	nop

80102c70 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102c70:	a1 bc 56 19 80       	mov    0x801956bc,%eax
{
80102c75:	55                   	push   %ebp
80102c76:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102c78:	85 c0                	test   %eax,%eax
80102c7a:	0f 84 c8 00 00 00    	je     80102d48 <lapicinit+0xd8>
  lapic[index] = value;
80102c80:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102c87:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c8a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c8d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102c94:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c97:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c9a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ca1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ca4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ca7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102cae:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102cb1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cb4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102cbb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102cbe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cc1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102cc8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ccb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102cce:	8b 50 30             	mov    0x30(%eax),%edx
80102cd1:	c1 ea 10             	shr    $0x10,%edx
80102cd4:	80 fa 03             	cmp    $0x3,%dl
80102cd7:	77 77                	ja     80102d50 <lapicinit+0xe0>
  lapic[index] = value;
80102cd9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ce0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ce3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ce6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102ced:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cf0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102cf3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102cfa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102cfd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d00:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102d07:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d0a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d0d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102d14:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d17:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102d1a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102d21:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102d24:	8b 50 20             	mov    0x20(%eax),%edx
80102d27:	89 f6                	mov    %esi,%esi
80102d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102d30:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102d36:	80 e6 10             	and    $0x10,%dh
80102d39:	75 f5                	jne    80102d30 <lapicinit+0xc0>
  lapic[index] = value;
80102d3b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102d42:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102d45:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102d48:	5d                   	pop    %ebp
80102d49:	c3                   	ret    
80102d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102d50:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102d57:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102d5a:	8b 50 20             	mov    0x20(%eax),%edx
80102d5d:	e9 77 ff ff ff       	jmp    80102cd9 <lapicinit+0x69>
80102d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d70 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102d70:	8b 15 bc 56 19 80    	mov    0x801956bc,%edx
{
80102d76:	55                   	push   %ebp
80102d77:	31 c0                	xor    %eax,%eax
80102d79:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102d7b:	85 d2                	test   %edx,%edx
80102d7d:	74 06                	je     80102d85 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102d7f:	8b 42 20             	mov    0x20(%edx),%eax
80102d82:	c1 e8 18             	shr    $0x18,%eax
}
80102d85:	5d                   	pop    %ebp
80102d86:	c3                   	ret    
80102d87:	89 f6                	mov    %esi,%esi
80102d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d90 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102d90:	a1 bc 56 19 80       	mov    0x801956bc,%eax
{
80102d95:	55                   	push   %ebp
80102d96:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102d98:	85 c0                	test   %eax,%eax
80102d9a:	74 0d                	je     80102da9 <lapiceoi+0x19>
  lapic[index] = value;
80102d9c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102da3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102da6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102da9:	5d                   	pop    %ebp
80102daa:	c3                   	ret    
80102dab:	90                   	nop
80102dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102db0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
}
80102db3:	5d                   	pop    %ebp
80102db4:	c3                   	ret    
80102db5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dc0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102dc0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102dc6:	ba 70 00 00 00       	mov    $0x70,%edx
80102dcb:	89 e5                	mov    %esp,%ebp
80102dcd:	53                   	push   %ebx
80102dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102dd1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dd4:	ee                   	out    %al,(%dx)
80102dd5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102dda:	ba 71 00 00 00       	mov    $0x71,%edx
80102ddf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102de0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102de2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102de5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102deb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ded:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102df0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102df3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102df5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102df8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102dfe:	a1 bc 56 19 80       	mov    0x801956bc,%eax
80102e03:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e09:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e0c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102e13:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e16:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e19:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102e20:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e23:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e26:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e2c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e2f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e35:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102e38:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e3e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e41:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102e47:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102e4a:	5b                   	pop    %ebx
80102e4b:	5d                   	pop    %ebp
80102e4c:	c3                   	ret    
80102e4d:	8d 76 00             	lea    0x0(%esi),%esi

80102e50 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102e50:	55                   	push   %ebp
80102e51:	b8 0b 00 00 00       	mov    $0xb,%eax
80102e56:	ba 70 00 00 00       	mov    $0x70,%edx
80102e5b:	89 e5                	mov    %esp,%ebp
80102e5d:	57                   	push   %edi
80102e5e:	56                   	push   %esi
80102e5f:	53                   	push   %ebx
80102e60:	83 ec 4c             	sub    $0x4c,%esp
80102e63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e64:	ba 71 00 00 00       	mov    $0x71,%edx
80102e69:	ec                   	in     (%dx),%al
80102e6a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e6d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102e72:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102e75:	8d 76 00             	lea    0x0(%esi),%esi
80102e78:	31 c0                	xor    %eax,%eax
80102e7a:	89 da                	mov    %ebx,%edx
80102e7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102e82:	89 ca                	mov    %ecx,%edx
80102e84:	ec                   	in     (%dx),%al
80102e85:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e88:	89 da                	mov    %ebx,%edx
80102e8a:	b8 02 00 00 00       	mov    $0x2,%eax
80102e8f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e90:	89 ca                	mov    %ecx,%edx
80102e92:	ec                   	in     (%dx),%al
80102e93:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e96:	89 da                	mov    %ebx,%edx
80102e98:	b8 04 00 00 00       	mov    $0x4,%eax
80102e9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e9e:	89 ca                	mov    %ecx,%edx
80102ea0:	ec                   	in     (%dx),%al
80102ea1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ea4:	89 da                	mov    %ebx,%edx
80102ea6:	b8 07 00 00 00       	mov    $0x7,%eax
80102eab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eac:	89 ca                	mov    %ecx,%edx
80102eae:	ec                   	in     (%dx),%al
80102eaf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eb2:	89 da                	mov    %ebx,%edx
80102eb4:	b8 08 00 00 00       	mov    $0x8,%eax
80102eb9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102eba:	89 ca                	mov    %ecx,%edx
80102ebc:	ec                   	in     (%dx),%al
80102ebd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ebf:	89 da                	mov    %ebx,%edx
80102ec1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ec6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ec7:	89 ca                	mov    %ecx,%edx
80102ec9:	ec                   	in     (%dx),%al
80102eca:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ecc:	89 da                	mov    %ebx,%edx
80102ece:	b8 0a 00 00 00       	mov    $0xa,%eax
80102ed3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed4:	89 ca                	mov    %ecx,%edx
80102ed6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102ed7:	84 c0                	test   %al,%al
80102ed9:	78 9d                	js     80102e78 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102edb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102edf:	89 fa                	mov    %edi,%edx
80102ee1:	0f b6 fa             	movzbl %dl,%edi
80102ee4:	89 f2                	mov    %esi,%edx
80102ee6:	0f b6 f2             	movzbl %dl,%esi
80102ee9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102eec:	89 da                	mov    %ebx,%edx
80102eee:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102ef1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102ef4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ef8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102efb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102eff:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102f02:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102f06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102f09:	31 c0                	xor    %eax,%eax
80102f0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f0c:	89 ca                	mov    %ecx,%edx
80102f0e:	ec                   	in     (%dx),%al
80102f0f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f12:	89 da                	mov    %ebx,%edx
80102f14:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102f17:	b8 02 00 00 00       	mov    $0x2,%eax
80102f1c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f1d:	89 ca                	mov    %ecx,%edx
80102f1f:	ec                   	in     (%dx),%al
80102f20:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f23:	89 da                	mov    %ebx,%edx
80102f25:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102f28:	b8 04 00 00 00       	mov    $0x4,%eax
80102f2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f2e:	89 ca                	mov    %ecx,%edx
80102f30:	ec                   	in     (%dx),%al
80102f31:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f34:	89 da                	mov    %ebx,%edx
80102f36:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102f39:	b8 07 00 00 00       	mov    $0x7,%eax
80102f3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f3f:	89 ca                	mov    %ecx,%edx
80102f41:	ec                   	in     (%dx),%al
80102f42:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f45:	89 da                	mov    %ebx,%edx
80102f47:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102f4a:	b8 08 00 00 00       	mov    $0x8,%eax
80102f4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f50:	89 ca                	mov    %ecx,%edx
80102f52:	ec                   	in     (%dx),%al
80102f53:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f56:	89 da                	mov    %ebx,%edx
80102f58:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102f5b:	b8 09 00 00 00       	mov    $0x9,%eax
80102f60:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f61:	89 ca                	mov    %ecx,%edx
80102f63:	ec                   	in     (%dx),%al
80102f64:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f67:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102f6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102f6d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102f70:	6a 18                	push   $0x18
80102f72:	50                   	push   %eax
80102f73:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102f76:	50                   	push   %eax
80102f77:	e8 94 1d 00 00       	call   80104d10 <memcmp>
80102f7c:	83 c4 10             	add    $0x10,%esp
80102f7f:	85 c0                	test   %eax,%eax
80102f81:	0f 85 f1 fe ff ff    	jne    80102e78 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102f87:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102f8b:	75 78                	jne    80103005 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102f8d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102f90:	89 c2                	mov    %eax,%edx
80102f92:	83 e0 0f             	and    $0xf,%eax
80102f95:	c1 ea 04             	shr    $0x4,%edx
80102f98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102f9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102f9e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102fa1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102fa4:	89 c2                	mov    %eax,%edx
80102fa6:	83 e0 0f             	and    $0xf,%eax
80102fa9:	c1 ea 04             	shr    $0x4,%edx
80102fac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102faf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fb2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102fb5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102fb8:	89 c2                	mov    %eax,%edx
80102fba:	83 e0 0f             	and    $0xf,%eax
80102fbd:	c1 ea 04             	shr    $0x4,%edx
80102fc0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fc3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fc6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102fc9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102fcc:	89 c2                	mov    %eax,%edx
80102fce:	83 e0 0f             	and    $0xf,%eax
80102fd1:	c1 ea 04             	shr    $0x4,%edx
80102fd4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fd7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fda:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102fdd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102fe0:	89 c2                	mov    %eax,%edx
80102fe2:	83 e0 0f             	and    $0xf,%eax
80102fe5:	c1 ea 04             	shr    $0x4,%edx
80102fe8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102feb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102fee:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ff1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ff4:	89 c2                	mov    %eax,%edx
80102ff6:	83 e0 0f             	and    $0xf,%eax
80102ff9:	c1 ea 04             	shr    $0x4,%edx
80102ffc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102fff:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103002:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103005:	8b 75 08             	mov    0x8(%ebp),%esi
80103008:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010300b:	89 06                	mov    %eax,(%esi)
8010300d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103010:	89 46 04             	mov    %eax,0x4(%esi)
80103013:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103016:	89 46 08             	mov    %eax,0x8(%esi)
80103019:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010301c:	89 46 0c             	mov    %eax,0xc(%esi)
8010301f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103022:	89 46 10             	mov    %eax,0x10(%esi)
80103025:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103028:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010302b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103032:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103035:	5b                   	pop    %ebx
80103036:	5e                   	pop    %esi
80103037:	5f                   	pop    %edi
80103038:	5d                   	pop    %ebp
80103039:	c3                   	ret    
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103040:	8b 0d 08 57 19 80    	mov    0x80195708,%ecx
80103046:	85 c9                	test   %ecx,%ecx
80103048:	0f 8e 8a 00 00 00    	jle    801030d8 <install_trans+0x98>
{
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	57                   	push   %edi
80103052:	56                   	push   %esi
80103053:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103054:	31 db                	xor    %ebx,%ebx
{
80103056:	83 ec 0c             	sub    $0xc,%esp
80103059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103060:	a1 f4 56 19 80       	mov    0x801956f4,%eax
80103065:	83 ec 08             	sub    $0x8,%esp
80103068:	01 d8                	add    %ebx,%eax
8010306a:	83 c0 01             	add    $0x1,%eax
8010306d:	50                   	push   %eax
8010306e:	ff 35 04 57 19 80    	pushl  0x80195704
80103074:	e8 57 d0 ff ff       	call   801000d0 <bread>
80103079:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010307b:	58                   	pop    %eax
8010307c:	5a                   	pop    %edx
8010307d:	ff 34 9d 0c 57 19 80 	pushl  -0x7fe6a8f4(,%ebx,4)
80103084:	ff 35 04 57 19 80    	pushl  0x80195704
  for (tail = 0; tail < log.lh.n; tail++) {
8010308a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010308d:	e8 3e d0 ff ff       	call   801000d0 <bread>
80103092:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103094:	8d 47 5c             	lea    0x5c(%edi),%eax
80103097:	83 c4 0c             	add    $0xc,%esp
8010309a:	68 00 02 00 00       	push   $0x200
8010309f:	50                   	push   %eax
801030a0:	8d 46 5c             	lea    0x5c(%esi),%eax
801030a3:	50                   	push   %eax
801030a4:	e8 c7 1c 00 00       	call   80104d70 <memmove>
    bwrite(dbuf);  // write dst to disk
801030a9:	89 34 24             	mov    %esi,(%esp)
801030ac:	e8 ef d0 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801030b1:	89 3c 24             	mov    %edi,(%esp)
801030b4:	e8 27 d1 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801030b9:	89 34 24             	mov    %esi,(%esp)
801030bc:	e8 1f d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030c1:	83 c4 10             	add    $0x10,%esp
801030c4:	39 1d 08 57 19 80    	cmp    %ebx,0x80195708
801030ca:	7f 94                	jg     80103060 <install_trans+0x20>
  }
}
801030cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cf:	5b                   	pop    %ebx
801030d0:	5e                   	pop    %esi
801030d1:	5f                   	pop    %edi
801030d2:	5d                   	pop    %ebp
801030d3:	c3                   	ret    
801030d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030d8:	f3 c3                	repz ret 
801030da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801030e0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801030e0:	55                   	push   %ebp
801030e1:	89 e5                	mov    %esp,%ebp
801030e3:	56                   	push   %esi
801030e4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801030e5:	83 ec 08             	sub    $0x8,%esp
801030e8:	ff 35 f4 56 19 80    	pushl  0x801956f4
801030ee:	ff 35 04 57 19 80    	pushl  0x80195704
801030f4:	e8 d7 cf ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801030f9:	8b 1d 08 57 19 80    	mov    0x80195708,%ebx
  for (i = 0; i < log.lh.n; i++) {
801030ff:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103102:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103104:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103106:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103109:	7e 16                	jle    80103121 <write_head+0x41>
8010310b:	c1 e3 02             	shl    $0x2,%ebx
8010310e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103110:	8b 8a 0c 57 19 80    	mov    -0x7fe6a8f4(%edx),%ecx
80103116:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010311a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010311d:	39 da                	cmp    %ebx,%edx
8010311f:	75 ef                	jne    80103110 <write_head+0x30>
  }
  bwrite(buf);
80103121:	83 ec 0c             	sub    $0xc,%esp
80103124:	56                   	push   %esi
80103125:	e8 76 d0 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010312a:	89 34 24             	mov    %esi,(%esp)
8010312d:	e8 ae d0 ff ff       	call   801001e0 <brelse>
}
80103132:	83 c4 10             	add    $0x10,%esp
80103135:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103138:	5b                   	pop    %ebx
80103139:	5e                   	pop    %esi
8010313a:	5d                   	pop    %ebp
8010313b:	c3                   	ret    
8010313c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103140 <initlog>:
{
80103140:	55                   	push   %ebp
80103141:	89 e5                	mov    %esp,%ebp
80103143:	53                   	push   %ebx
80103144:	83 ec 2c             	sub    $0x2c,%esp
80103147:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010314a:	68 20 84 10 80       	push   $0x80108420
8010314f:	68 c0 56 19 80       	push   $0x801956c0
80103154:	e8 17 19 00 00       	call   80104a70 <initlock>
  readsb(dev, &sb);
80103159:	58                   	pop    %eax
8010315a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010315d:	5a                   	pop    %edx
8010315e:	50                   	push   %eax
8010315f:	53                   	push   %ebx
80103160:	e8 1b e3 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
80103165:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103168:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010316b:	59                   	pop    %ecx
  log.dev = dev;
8010316c:	89 1d 04 57 19 80    	mov    %ebx,0x80195704
  log.size = sb.nlog;
80103172:	89 15 f8 56 19 80    	mov    %edx,0x801956f8
  log.start = sb.logstart;
80103178:	a3 f4 56 19 80       	mov    %eax,0x801956f4
  struct buf *buf = bread(log.dev, log.start);
8010317d:	5a                   	pop    %edx
8010317e:	50                   	push   %eax
8010317f:	53                   	push   %ebx
80103180:	e8 4b cf ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103185:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103188:	83 c4 10             	add    $0x10,%esp
8010318b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010318d:	89 1d 08 57 19 80    	mov    %ebx,0x80195708
  for (i = 0; i < log.lh.n; i++) {
80103193:	7e 1c                	jle    801031b1 <initlog+0x71>
80103195:	c1 e3 02             	shl    $0x2,%ebx
80103198:	31 d2                	xor    %edx,%edx
8010319a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801031a0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801031a4:	83 c2 04             	add    $0x4,%edx
801031a7:	89 8a 08 57 19 80    	mov    %ecx,-0x7fe6a8f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
801031ad:	39 d3                	cmp    %edx,%ebx
801031af:	75 ef                	jne    801031a0 <initlog+0x60>
  brelse(buf);
801031b1:	83 ec 0c             	sub    $0xc,%esp
801031b4:	50                   	push   %eax
801031b5:	e8 26 d0 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801031ba:	e8 81 fe ff ff       	call   80103040 <install_trans>
  log.lh.n = 0;
801031bf:	c7 05 08 57 19 80 00 	movl   $0x0,0x80195708
801031c6:	00 00 00 
  write_head(); // clear the log
801031c9:	e8 12 ff ff ff       	call   801030e0 <write_head>
}
801031ce:	83 c4 10             	add    $0x10,%esp
801031d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031d4:	c9                   	leave  
801031d5:	c3                   	ret    
801031d6:	8d 76 00             	lea    0x0(%esi),%esi
801031d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031e0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801031e6:	68 c0 56 19 80       	push   $0x801956c0
801031eb:	e8 c0 19 00 00       	call   80104bb0 <acquire>
801031f0:	83 c4 10             	add    $0x10,%esp
801031f3:	eb 18                	jmp    8010320d <begin_op+0x2d>
801031f5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801031f8:	83 ec 08             	sub    $0x8,%esp
801031fb:	68 c0 56 19 80       	push   $0x801956c0
80103200:	68 c0 56 19 80       	push   $0x801956c0
80103205:	e8 76 13 00 00       	call   80104580 <sleep>
8010320a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010320d:	a1 00 57 19 80       	mov    0x80195700,%eax
80103212:	85 c0                	test   %eax,%eax
80103214:	75 e2                	jne    801031f8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103216:	a1 fc 56 19 80       	mov    0x801956fc,%eax
8010321b:	8b 15 08 57 19 80    	mov    0x80195708,%edx
80103221:	83 c0 01             	add    $0x1,%eax
80103224:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103227:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010322a:	83 fa 1e             	cmp    $0x1e,%edx
8010322d:	7f c9                	jg     801031f8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010322f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103232:	a3 fc 56 19 80       	mov    %eax,0x801956fc
      release(&log.lock);
80103237:	68 c0 56 19 80       	push   $0x801956c0
8010323c:	e8 2f 1a 00 00       	call   80104c70 <release>
      break;
    }
  }
}
80103241:	83 c4 10             	add    $0x10,%esp
80103244:	c9                   	leave  
80103245:	c3                   	ret    
80103246:	8d 76 00             	lea    0x0(%esi),%esi
80103249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103250 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103259:	68 c0 56 19 80       	push   $0x801956c0
8010325e:	e8 4d 19 00 00       	call   80104bb0 <acquire>
  log.outstanding -= 1;
80103263:	a1 fc 56 19 80       	mov    0x801956fc,%eax
  if(log.committing)
80103268:	8b 35 00 57 19 80    	mov    0x80195700,%esi
8010326e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103271:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103274:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103276:	89 1d fc 56 19 80    	mov    %ebx,0x801956fc
  if(log.committing)
8010327c:	0f 85 1a 01 00 00    	jne    8010339c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103282:	85 db                	test   %ebx,%ebx
80103284:	0f 85 ee 00 00 00    	jne    80103378 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010328a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010328d:	c7 05 00 57 19 80 01 	movl   $0x1,0x80195700
80103294:	00 00 00 
  release(&log.lock);
80103297:	68 c0 56 19 80       	push   $0x801956c0
8010329c:	e8 cf 19 00 00       	call   80104c70 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801032a1:	8b 0d 08 57 19 80    	mov    0x80195708,%ecx
801032a7:	83 c4 10             	add    $0x10,%esp
801032aa:	85 c9                	test   %ecx,%ecx
801032ac:	0f 8e 85 00 00 00    	jle    80103337 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801032b2:	a1 f4 56 19 80       	mov    0x801956f4,%eax
801032b7:	83 ec 08             	sub    $0x8,%esp
801032ba:	01 d8                	add    %ebx,%eax
801032bc:	83 c0 01             	add    $0x1,%eax
801032bf:	50                   	push   %eax
801032c0:	ff 35 04 57 19 80    	pushl  0x80195704
801032c6:	e8 05 ce ff ff       	call   801000d0 <bread>
801032cb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032cd:	58                   	pop    %eax
801032ce:	5a                   	pop    %edx
801032cf:	ff 34 9d 0c 57 19 80 	pushl  -0x7fe6a8f4(,%ebx,4)
801032d6:	ff 35 04 57 19 80    	pushl  0x80195704
  for (tail = 0; tail < log.lh.n; tail++) {
801032dc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801032df:	e8 ec cd ff ff       	call   801000d0 <bread>
801032e4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801032e6:	8d 40 5c             	lea    0x5c(%eax),%eax
801032e9:	83 c4 0c             	add    $0xc,%esp
801032ec:	68 00 02 00 00       	push   $0x200
801032f1:	50                   	push   %eax
801032f2:	8d 46 5c             	lea    0x5c(%esi),%eax
801032f5:	50                   	push   %eax
801032f6:	e8 75 1a 00 00       	call   80104d70 <memmove>
    bwrite(to);  // write the log
801032fb:	89 34 24             	mov    %esi,(%esp)
801032fe:	e8 9d ce ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103303:	89 3c 24             	mov    %edi,(%esp)
80103306:	e8 d5 ce ff ff       	call   801001e0 <brelse>
    brelse(to);
8010330b:	89 34 24             	mov    %esi,(%esp)
8010330e:	e8 cd ce ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103313:	83 c4 10             	add    $0x10,%esp
80103316:	3b 1d 08 57 19 80    	cmp    0x80195708,%ebx
8010331c:	7c 94                	jl     801032b2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010331e:	e8 bd fd ff ff       	call   801030e0 <write_head>
    install_trans(); // Now install writes to home locations
80103323:	e8 18 fd ff ff       	call   80103040 <install_trans>
    log.lh.n = 0;
80103328:	c7 05 08 57 19 80 00 	movl   $0x0,0x80195708
8010332f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103332:	e8 a9 fd ff ff       	call   801030e0 <write_head>
    acquire(&log.lock);
80103337:	83 ec 0c             	sub    $0xc,%esp
8010333a:	68 c0 56 19 80       	push   $0x801956c0
8010333f:	e8 6c 18 00 00       	call   80104bb0 <acquire>
    wakeup(&log);
80103344:	c7 04 24 c0 56 19 80 	movl   $0x801956c0,(%esp)
    log.committing = 0;
8010334b:	c7 05 00 57 19 80 00 	movl   $0x0,0x80195700
80103352:	00 00 00 
    wakeup(&log);
80103355:	e8 16 14 00 00       	call   80104770 <wakeup>
    release(&log.lock);
8010335a:	c7 04 24 c0 56 19 80 	movl   $0x801956c0,(%esp)
80103361:	e8 0a 19 00 00       	call   80104c70 <release>
80103366:	83 c4 10             	add    $0x10,%esp
}
80103369:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010336c:	5b                   	pop    %ebx
8010336d:	5e                   	pop    %esi
8010336e:	5f                   	pop    %edi
8010336f:	5d                   	pop    %ebp
80103370:	c3                   	ret    
80103371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103378:	83 ec 0c             	sub    $0xc,%esp
8010337b:	68 c0 56 19 80       	push   $0x801956c0
80103380:	e8 eb 13 00 00       	call   80104770 <wakeup>
  release(&log.lock);
80103385:	c7 04 24 c0 56 19 80 	movl   $0x801956c0,(%esp)
8010338c:	e8 df 18 00 00       	call   80104c70 <release>
80103391:	83 c4 10             	add    $0x10,%esp
}
80103394:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103397:	5b                   	pop    %ebx
80103398:	5e                   	pop    %esi
80103399:	5f                   	pop    %edi
8010339a:	5d                   	pop    %ebp
8010339b:	c3                   	ret    
    panic("log.committing");
8010339c:	83 ec 0c             	sub    $0xc,%esp
8010339f:	68 24 84 10 80       	push   $0x80108424
801033a4:	e8 e7 cf ff ff       	call   80100390 <panic>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801033b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801033b0:	55                   	push   %ebp
801033b1:	89 e5                	mov    %esp,%ebp
801033b3:	53                   	push   %ebx
801033b4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033b7:	8b 15 08 57 19 80    	mov    0x80195708,%edx
{
801033bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801033c0:	83 fa 1d             	cmp    $0x1d,%edx
801033c3:	0f 8f 9d 00 00 00    	jg     80103466 <log_write+0xb6>
801033c9:	a1 f8 56 19 80       	mov    0x801956f8,%eax
801033ce:	83 e8 01             	sub    $0x1,%eax
801033d1:	39 c2                	cmp    %eax,%edx
801033d3:	0f 8d 8d 00 00 00    	jge    80103466 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801033d9:	a1 fc 56 19 80       	mov    0x801956fc,%eax
801033de:	85 c0                	test   %eax,%eax
801033e0:	0f 8e 8d 00 00 00    	jle    80103473 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801033e6:	83 ec 0c             	sub    $0xc,%esp
801033e9:	68 c0 56 19 80       	push   $0x801956c0
801033ee:	e8 bd 17 00 00       	call   80104bb0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801033f3:	8b 0d 08 57 19 80    	mov    0x80195708,%ecx
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	83 f9 00             	cmp    $0x0,%ecx
801033ff:	7e 57                	jle    80103458 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103401:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103404:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103406:	3b 15 0c 57 19 80    	cmp    0x8019570c,%edx
8010340c:	75 0b                	jne    80103419 <log_write+0x69>
8010340e:	eb 38                	jmp    80103448 <log_write+0x98>
80103410:	39 14 85 0c 57 19 80 	cmp    %edx,-0x7fe6a8f4(,%eax,4)
80103417:	74 2f                	je     80103448 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103419:	83 c0 01             	add    $0x1,%eax
8010341c:	39 c1                	cmp    %eax,%ecx
8010341e:	75 f0                	jne    80103410 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103420:	89 14 85 0c 57 19 80 	mov    %edx,-0x7fe6a8f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103427:	83 c0 01             	add    $0x1,%eax
8010342a:	a3 08 57 19 80       	mov    %eax,0x80195708
  b->flags |= B_DIRTY; // prevent eviction
8010342f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103432:	c7 45 08 c0 56 19 80 	movl   $0x801956c0,0x8(%ebp)
}
80103439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010343c:	c9                   	leave  
  release(&log.lock);
8010343d:	e9 2e 18 00 00       	jmp    80104c70 <release>
80103442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103448:	89 14 85 0c 57 19 80 	mov    %edx,-0x7fe6a8f4(,%eax,4)
8010344f:	eb de                	jmp    8010342f <log_write+0x7f>
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103458:	8b 43 08             	mov    0x8(%ebx),%eax
8010345b:	a3 0c 57 19 80       	mov    %eax,0x8019570c
  if (i == log.lh.n)
80103460:	75 cd                	jne    8010342f <log_write+0x7f>
80103462:	31 c0                	xor    %eax,%eax
80103464:	eb c1                	jmp    80103427 <log_write+0x77>
    panic("too big a transaction");
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	68 33 84 10 80       	push   $0x80108433
8010346e:	e8 1d cf ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103473:	83 ec 0c             	sub    $0xc,%esp
80103476:	68 49 84 10 80       	push   $0x80108449
8010347b:	e8 10 cf ff ff       	call   80100390 <panic>

80103480 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	53                   	push   %ebx
80103484:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103487:	e8 14 0a 00 00       	call   80103ea0 <cpuid>
8010348c:	89 c3                	mov    %eax,%ebx
8010348e:	e8 0d 0a 00 00       	call   80103ea0 <cpuid>
80103493:	83 ec 04             	sub    $0x4,%esp
80103496:	53                   	push   %ebx
80103497:	50                   	push   %eax
80103498:	68 64 84 10 80       	push   $0x80108464
8010349d:	e8 be d1 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801034a2:	e8 09 2b 00 00       	call   80105fb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801034a7:	e8 74 09 00 00       	call   80103e20 <mycpu>
801034ac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801034ae:	b8 01 00 00 00       	mov    $0x1,%eax
801034b3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801034ba:	e8 c1 0d 00 00       	call   80104280 <scheduler>
801034bf:	90                   	nop

801034c0 <mpenter>:
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801034c6:	e8 25 3b 00 00       	call   80106ff0 <switchkvm>
  seginit();
801034cb:	e8 90 3a 00 00       	call   80106f60 <seginit>
  lapicinit();
801034d0:	e8 9b f7 ff ff       	call   80102c70 <lapicinit>
  mpmain();
801034d5:	e8 a6 ff ff ff       	call   80103480 <mpmain>
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <main>:
{
801034e0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801034e4:	83 e4 f0             	and    $0xfffffff0,%esp
801034e7:	ff 71 fc             	pushl  -0x4(%ecx)
801034ea:	55                   	push   %ebp
801034eb:	89 e5                	mov    %esp,%ebp
801034ed:	53                   	push   %ebx
801034ee:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801034ef:	83 ec 08             	sub    $0x8,%esp
801034f2:	68 00 00 40 80       	push   $0x80400000
801034f7:	68 e8 09 1a 80       	push   $0x801a09e8
801034fc:	e8 ef f3 ff ff       	call   801028f0 <kinit1>
  kvmalloc();      // kernel page table
80103501:	e8 fa 42 00 00       	call   80107800 <kvmalloc>
  mpinit();        // detect other processors
80103506:	e8 75 01 00 00       	call   80103680 <mpinit>
  lapicinit();     // interrupt controller
8010350b:	e8 60 f7 ff ff       	call   80102c70 <lapicinit>
  seginit();       // segment descriptors
80103510:	e8 4b 3a 00 00       	call   80106f60 <seginit>
  picinit();       // disable pic
80103515:	e8 46 03 00 00       	call   80103860 <picinit>
  ioapicinit();    // another interrupt controller
8010351a:	e8 d1 f0 ff ff       	call   801025f0 <ioapicinit>
  consoleinit();   // console hardware
8010351f:	e8 9c d4 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103524:	e8 a7 2d 00 00       	call   801062d0 <uartinit>
  pinit();         // process table
80103529:	e8 d2 08 00 00       	call   80103e00 <pinit>
  tvinit();        // trap vectors
8010352e:	e8 fd 29 00 00       	call   80105f30 <tvinit>
  binit();         // buffer cache
80103533:	e8 08 cb ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103538:	e8 63 d8 ff ff       	call   80100da0 <fileinit>
  ideinit();       // disk 
8010353d:	e8 8e ee ff ff       	call   801023d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103542:	83 c4 0c             	add    $0xc,%esp
80103545:	68 8a 00 00 00       	push   $0x8a
8010354a:	68 8c b4 10 80       	push   $0x8010b48c
8010354f:	68 00 70 00 80       	push   $0x80007000
80103554:	e8 17 18 00 00       	call   80104d70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103559:	69 05 40 5d 19 80 b0 	imul   $0xb0,0x80195d40,%eax
80103560:	00 00 00 
80103563:	83 c4 10             	add    $0x10,%esp
80103566:	05 c0 57 19 80       	add    $0x801957c0,%eax
8010356b:	3d c0 57 19 80       	cmp    $0x801957c0,%eax
80103570:	76 71                	jbe    801035e3 <main+0x103>
80103572:	bb c0 57 19 80       	mov    $0x801957c0,%ebx
80103577:	89 f6                	mov    %esi,%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103580:	e8 9b 08 00 00       	call   80103e20 <mycpu>
80103585:	39 d8                	cmp    %ebx,%eax
80103587:	74 41                	je     801035ca <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103589:	e8 32 f4 ff ff       	call   801029c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010358e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103593:	c7 05 f8 6f 00 80 c0 	movl   $0x801034c0,0x80006ff8
8010359a:	34 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010359d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801035a4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801035a7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801035ac:	0f b6 03             	movzbl (%ebx),%eax
801035af:	83 ec 08             	sub    $0x8,%esp
801035b2:	68 00 70 00 00       	push   $0x7000
801035b7:	50                   	push   %eax
801035b8:	e8 03 f8 ff ff       	call   80102dc0 <lapicstartap>
801035bd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035c0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801035c6:	85 c0                	test   %eax,%eax
801035c8:	74 f6                	je     801035c0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801035ca:	69 05 40 5d 19 80 b0 	imul   $0xb0,0x80195d40,%eax
801035d1:	00 00 00 
801035d4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801035da:	05 c0 57 19 80       	add    $0x801957c0,%eax
801035df:	39 c3                	cmp    %eax,%ebx
801035e1:	72 9d                	jb     80103580 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801035e3:	83 ec 08             	sub    $0x8,%esp
801035e6:	68 00 00 00 8e       	push   $0x8e000000
801035eb:	68 00 00 40 80       	push   $0x80400000
801035f0:	e8 6b f3 ff ff       	call   80102960 <kinit2>
  userinit();      // first user process
801035f5:	e8 f6 08 00 00       	call   80103ef0 <userinit>
  mpmain();        // finish this processor's setup
801035fa:	e8 81 fe ff ff       	call   80103480 <mpmain>
801035ff:	90                   	nop

80103600 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103605:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010360b:	53                   	push   %ebx
  e = addr+len;
8010360c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010360f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103612:	39 de                	cmp    %ebx,%esi
80103614:	72 10                	jb     80103626 <mpsearch1+0x26>
80103616:	eb 50                	jmp    80103668 <mpsearch1+0x68>
80103618:	90                   	nop
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103620:	39 fb                	cmp    %edi,%ebx
80103622:	89 fe                	mov    %edi,%esi
80103624:	76 42                	jbe    80103668 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103626:	83 ec 04             	sub    $0x4,%esp
80103629:	8d 7e 10             	lea    0x10(%esi),%edi
8010362c:	6a 04                	push   $0x4
8010362e:	68 78 84 10 80       	push   $0x80108478
80103633:	56                   	push   %esi
80103634:	e8 d7 16 00 00       	call   80104d10 <memcmp>
80103639:	83 c4 10             	add    $0x10,%esp
8010363c:	85 c0                	test   %eax,%eax
8010363e:	75 e0                	jne    80103620 <mpsearch1+0x20>
80103640:	89 f1                	mov    %esi,%ecx
80103642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103648:	0f b6 11             	movzbl (%ecx),%edx
8010364b:	83 c1 01             	add    $0x1,%ecx
8010364e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103650:	39 f9                	cmp    %edi,%ecx
80103652:	75 f4                	jne    80103648 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103654:	84 c0                	test   %al,%al
80103656:	75 c8                	jne    80103620 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103658:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365b:	89 f0                	mov    %esi,%eax
8010365d:	5b                   	pop    %ebx
8010365e:	5e                   	pop    %esi
8010365f:	5f                   	pop    %edi
80103660:	5d                   	pop    %ebp
80103661:	c3                   	ret    
80103662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103668:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010366b:	31 f6                	xor    %esi,%esi
}
8010366d:	89 f0                	mov    %esi,%eax
8010366f:	5b                   	pop    %ebx
80103670:	5e                   	pop    %esi
80103671:	5f                   	pop    %edi
80103672:	5d                   	pop    %ebp
80103673:	c3                   	ret    
80103674:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010367a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103680 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103689:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103690:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103697:	c1 e0 08             	shl    $0x8,%eax
8010369a:	09 d0                	or     %edx,%eax
8010369c:	c1 e0 04             	shl    $0x4,%eax
8010369f:	85 c0                	test   %eax,%eax
801036a1:	75 1b                	jne    801036be <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801036a3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801036aa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801036b1:	c1 e0 08             	shl    $0x8,%eax
801036b4:	09 d0                	or     %edx,%eax
801036b6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801036b9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801036be:	ba 00 04 00 00       	mov    $0x400,%edx
801036c3:	e8 38 ff ff ff       	call   80103600 <mpsearch1>
801036c8:	85 c0                	test   %eax,%eax
801036ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036cd:	0f 84 3d 01 00 00    	je     80103810 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801036d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036d6:	8b 58 04             	mov    0x4(%eax),%ebx
801036d9:	85 db                	test   %ebx,%ebx
801036db:	0f 84 4f 01 00 00    	je     80103830 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801036e1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801036e7:	83 ec 04             	sub    $0x4,%esp
801036ea:	6a 04                	push   $0x4
801036ec:	68 95 84 10 80       	push   $0x80108495
801036f1:	56                   	push   %esi
801036f2:	e8 19 16 00 00       	call   80104d10 <memcmp>
801036f7:	83 c4 10             	add    $0x10,%esp
801036fa:	85 c0                	test   %eax,%eax
801036fc:	0f 85 2e 01 00 00    	jne    80103830 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103702:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103709:	3c 01                	cmp    $0x1,%al
8010370b:	0f 95 c2             	setne  %dl
8010370e:	3c 04                	cmp    $0x4,%al
80103710:	0f 95 c0             	setne  %al
80103713:	20 c2                	and    %al,%dl
80103715:	0f 85 15 01 00 00    	jne    80103830 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010371b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103722:	66 85 ff             	test   %di,%di
80103725:	74 1a                	je     80103741 <mpinit+0xc1>
80103727:	89 f0                	mov    %esi,%eax
80103729:	01 f7                	add    %esi,%edi
  sum = 0;
8010372b:	31 d2                	xor    %edx,%edx
8010372d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103730:	0f b6 08             	movzbl (%eax),%ecx
80103733:	83 c0 01             	add    $0x1,%eax
80103736:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103738:	39 c7                	cmp    %eax,%edi
8010373a:	75 f4                	jne    80103730 <mpinit+0xb0>
8010373c:	84 d2                	test   %dl,%dl
8010373e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103741:	85 f6                	test   %esi,%esi
80103743:	0f 84 e7 00 00 00    	je     80103830 <mpinit+0x1b0>
80103749:	84 d2                	test   %dl,%dl
8010374b:	0f 85 df 00 00 00    	jne    80103830 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103751:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103757:	a3 bc 56 19 80       	mov    %eax,0x801956bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010375c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103763:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103769:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010376e:	01 d6                	add    %edx,%esi
80103770:	39 c6                	cmp    %eax,%esi
80103772:	76 23                	jbe    80103797 <mpinit+0x117>
    switch(*p){
80103774:	0f b6 10             	movzbl (%eax),%edx
80103777:	80 fa 04             	cmp    $0x4,%dl
8010377a:	0f 87 ca 00 00 00    	ja     8010384a <mpinit+0x1ca>
80103780:	ff 24 95 bc 84 10 80 	jmp    *-0x7fef7b44(,%edx,4)
80103787:	89 f6                	mov    %esi,%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103790:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103793:	39 c6                	cmp    %eax,%esi
80103795:	77 dd                	ja     80103774 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103797:	85 db                	test   %ebx,%ebx
80103799:	0f 84 9e 00 00 00    	je     8010383d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010379f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801037a2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801037a6:	74 15                	je     801037bd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037a8:	b8 70 00 00 00       	mov    $0x70,%eax
801037ad:	ba 22 00 00 00       	mov    $0x22,%edx
801037b2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801037b3:	ba 23 00 00 00       	mov    $0x23,%edx
801037b8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801037b9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801037bc:	ee                   	out    %al,(%dx)
  }
}
801037bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c0:	5b                   	pop    %ebx
801037c1:	5e                   	pop    %esi
801037c2:	5f                   	pop    %edi
801037c3:	5d                   	pop    %ebp
801037c4:	c3                   	ret    
801037c5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801037c8:	8b 0d 40 5d 19 80    	mov    0x80195d40,%ecx
801037ce:	83 f9 07             	cmp    $0x7,%ecx
801037d1:	7f 19                	jg     801037ec <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037d3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801037d7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801037dd:	83 c1 01             	add    $0x1,%ecx
801037e0:	89 0d 40 5d 19 80    	mov    %ecx,0x80195d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801037e6:	88 97 c0 57 19 80    	mov    %dl,-0x7fe6a840(%edi)
      p += sizeof(struct mpproc);
801037ec:	83 c0 14             	add    $0x14,%eax
      continue;
801037ef:	e9 7c ff ff ff       	jmp    80103770 <mpinit+0xf0>
801037f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801037f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801037fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801037ff:	88 15 a0 57 19 80    	mov    %dl,0x801957a0
      continue;
80103805:	e9 66 ff ff ff       	jmp    80103770 <mpinit+0xf0>
8010380a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103810:	ba 00 00 01 00       	mov    $0x10000,%edx
80103815:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010381a:	e8 e1 fd ff ff       	call   80103600 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010381f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103824:	0f 85 a9 fe ff ff    	jne    801036d3 <mpinit+0x53>
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	68 7d 84 10 80       	push   $0x8010847d
80103838:	e8 53 cb ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010383d:	83 ec 0c             	sub    $0xc,%esp
80103840:	68 9c 84 10 80       	push   $0x8010849c
80103845:	e8 46 cb ff ff       	call   80100390 <panic>
      ismp = 0;
8010384a:	31 db                	xor    %ebx,%ebx
8010384c:	e9 26 ff ff ff       	jmp    80103777 <mpinit+0xf7>
80103851:	66 90                	xchg   %ax,%ax
80103853:	66 90                	xchg   %ax,%ax
80103855:	66 90                	xchg   %ax,%ax
80103857:	66 90                	xchg   %ax,%ax
80103859:	66 90                	xchg   %ax,%ax
8010385b:	66 90                	xchg   %ax,%ax
8010385d:	66 90                	xchg   %ax,%ax
8010385f:	90                   	nop

80103860 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103860:	55                   	push   %ebp
80103861:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103866:	ba 21 00 00 00       	mov    $0x21,%edx
8010386b:	89 e5                	mov    %esp,%ebp
8010386d:	ee                   	out    %al,(%dx)
8010386e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103873:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103874:	5d                   	pop    %ebp
80103875:	c3                   	ret    
80103876:	66 90                	xchg   %ax,%ax
80103878:	66 90                	xchg   %ax,%ax
8010387a:	66 90                	xchg   %ax,%ax
8010387c:	66 90                	xchg   %ax,%ax
8010387e:	66 90                	xchg   %ax,%ax

80103880 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	57                   	push   %edi
80103884:	56                   	push   %esi
80103885:	53                   	push   %ebx
80103886:	83 ec 0c             	sub    $0xc,%esp
80103889:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010388c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010388f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103895:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010389b:	e8 20 d5 ff ff       	call   80100dc0 <filealloc>
801038a0:	85 c0                	test   %eax,%eax
801038a2:	89 03                	mov    %eax,(%ebx)
801038a4:	74 22                	je     801038c8 <pipealloc+0x48>
801038a6:	e8 15 d5 ff ff       	call   80100dc0 <filealloc>
801038ab:	85 c0                	test   %eax,%eax
801038ad:	89 06                	mov    %eax,(%esi)
801038af:	74 3f                	je     801038f0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801038b1:	e8 0a f1 ff ff       	call   801029c0 <kalloc>
801038b6:	85 c0                	test   %eax,%eax
801038b8:	89 c7                	mov    %eax,%edi
801038ba:	75 54                	jne    80103910 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801038bc:	8b 03                	mov    (%ebx),%eax
801038be:	85 c0                	test   %eax,%eax
801038c0:	75 34                	jne    801038f6 <pipealloc+0x76>
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801038c8:	8b 06                	mov    (%esi),%eax
801038ca:	85 c0                	test   %eax,%eax
801038cc:	74 0c                	je     801038da <pipealloc+0x5a>
    fileclose(*f1);
801038ce:	83 ec 0c             	sub    $0xc,%esp
801038d1:	50                   	push   %eax
801038d2:	e8 a9 d5 ff ff       	call   80100e80 <fileclose>
801038d7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801038da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801038dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801038e2:	5b                   	pop    %ebx
801038e3:	5e                   	pop    %esi
801038e4:	5f                   	pop    %edi
801038e5:	5d                   	pop    %ebp
801038e6:	c3                   	ret    
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801038f0:	8b 03                	mov    (%ebx),%eax
801038f2:	85 c0                	test   %eax,%eax
801038f4:	74 e4                	je     801038da <pipealloc+0x5a>
    fileclose(*f0);
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	50                   	push   %eax
801038fa:	e8 81 d5 ff ff       	call   80100e80 <fileclose>
  if(*f1)
801038ff:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103901:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103904:	85 c0                	test   %eax,%eax
80103906:	75 c6                	jne    801038ce <pipealloc+0x4e>
80103908:	eb d0                	jmp    801038da <pipealloc+0x5a>
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103910:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103913:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010391a:	00 00 00 
  p->writeopen = 1;
8010391d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103924:	00 00 00 
  p->nwrite = 0;
80103927:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010392e:	00 00 00 
  p->nread = 0;
80103931:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103938:	00 00 00 
  initlock(&p->lock, "pipe");
8010393b:	68 d0 84 10 80       	push   $0x801084d0
80103940:	50                   	push   %eax
80103941:	e8 2a 11 00 00       	call   80104a70 <initlock>
  (*f0)->type = FD_PIPE;
80103946:	8b 03                	mov    (%ebx),%eax
  return 0;
80103948:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010394b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103951:	8b 03                	mov    (%ebx),%eax
80103953:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103957:	8b 03                	mov    (%ebx),%eax
80103959:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010395d:	8b 03                	mov    (%ebx),%eax
8010395f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103962:	8b 06                	mov    (%esi),%eax
80103964:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010396a:	8b 06                	mov    (%esi),%eax
8010396c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103970:	8b 06                	mov    (%esi),%eax
80103972:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103976:	8b 06                	mov    (%esi),%eax
80103978:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010397b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010397e:	31 c0                	xor    %eax,%eax
}
80103980:	5b                   	pop    %ebx
80103981:	5e                   	pop    %esi
80103982:	5f                   	pop    %edi
80103983:	5d                   	pop    %ebp
80103984:	c3                   	ret    
80103985:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	56                   	push   %esi
80103994:	53                   	push   %ebx
80103995:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103998:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010399b:	83 ec 0c             	sub    $0xc,%esp
8010399e:	53                   	push   %ebx
8010399f:	e8 0c 12 00 00       	call   80104bb0 <acquire>
  if(writable){
801039a4:	83 c4 10             	add    $0x10,%esp
801039a7:	85 f6                	test   %esi,%esi
801039a9:	74 45                	je     801039f0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801039ab:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801039b1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801039b4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801039bb:	00 00 00 
    wakeup(&p->nread);
801039be:	50                   	push   %eax
801039bf:	e8 ac 0d 00 00       	call   80104770 <wakeup>
801039c4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801039c7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801039cd:	85 d2                	test   %edx,%edx
801039cf:	75 0a                	jne    801039db <pipeclose+0x4b>
801039d1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801039d7:	85 c0                	test   %eax,%eax
801039d9:	74 35                	je     80103a10 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801039db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801039de:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039e1:	5b                   	pop    %ebx
801039e2:	5e                   	pop    %esi
801039e3:	5d                   	pop    %ebp
    release(&p->lock);
801039e4:	e9 87 12 00 00       	jmp    80104c70 <release>
801039e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801039f0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801039f6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801039f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103a00:	00 00 00 
    wakeup(&p->nwrite);
80103a03:	50                   	push   %eax
80103a04:	e8 67 0d 00 00       	call   80104770 <wakeup>
80103a09:	83 c4 10             	add    $0x10,%esp
80103a0c:	eb b9                	jmp    801039c7 <pipeclose+0x37>
80103a0e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103a10:	83 ec 0c             	sub    $0xc,%esp
80103a13:	53                   	push   %ebx
80103a14:	e8 57 12 00 00       	call   80104c70 <release>
    kfree((char*)p);
80103a19:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103a1c:	83 c4 10             	add    $0x10,%esp
}
80103a1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a22:	5b                   	pop    %ebx
80103a23:	5e                   	pop    %esi
80103a24:	5d                   	pop    %ebp
    kfree((char*)p);
80103a25:	e9 b6 ec ff ff       	jmp    801026e0 <kfree>
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 28             	sub    $0x28,%esp
80103a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103a3c:	53                   	push   %ebx
80103a3d:	e8 6e 11 00 00       	call   80104bb0 <acquire>
  for(i = 0; i < n; i++){
80103a42:	8b 45 10             	mov    0x10(%ebp),%eax
80103a45:	83 c4 10             	add    $0x10,%esp
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	0f 8e c9 00 00 00    	jle    80103b19 <pipewrite+0xe9>
80103a50:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103a53:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103a59:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103a5f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103a62:	03 4d 10             	add    0x10(%ebp),%ecx
80103a65:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103a68:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103a6e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103a74:	39 d0                	cmp    %edx,%eax
80103a76:	75 71                	jne    80103ae9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103a78:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103a7e:	85 c0                	test   %eax,%eax
80103a80:	74 4e                	je     80103ad0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a82:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103a88:	eb 3a                	jmp    80103ac4 <pipewrite+0x94>
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	57                   	push   %edi
80103a94:	e8 d7 0c 00 00       	call   80104770 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103a99:	5a                   	pop    %edx
80103a9a:	59                   	pop    %ecx
80103a9b:	53                   	push   %ebx
80103a9c:	56                   	push   %esi
80103a9d:	e8 de 0a 00 00       	call   80104580 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103aa2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103aa8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103aae:	83 c4 10             	add    $0x10,%esp
80103ab1:	05 00 02 00 00       	add    $0x200,%eax
80103ab6:	39 c2                	cmp    %eax,%edx
80103ab8:	75 36                	jne    80103af0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103aba:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103ac0:	85 c0                	test   %eax,%eax
80103ac2:	74 0c                	je     80103ad0 <pipewrite+0xa0>
80103ac4:	e8 f7 03 00 00       	call   80103ec0 <myproc>
80103ac9:	8b 40 24             	mov    0x24(%eax),%eax
80103acc:	85 c0                	test   %eax,%eax
80103ace:	74 c0                	je     80103a90 <pipewrite+0x60>
        release(&p->lock);
80103ad0:	83 ec 0c             	sub    $0xc,%esp
80103ad3:	53                   	push   %ebx
80103ad4:	e8 97 11 00 00       	call   80104c70 <release>
        return -1;
80103ad9:	83 c4 10             	add    $0x10,%esp
80103adc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ae4:	5b                   	pop    %ebx
80103ae5:	5e                   	pop    %esi
80103ae6:	5f                   	pop    %edi
80103ae7:	5d                   	pop    %ebp
80103ae8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ae9:	89 c2                	mov    %eax,%edx
80103aeb:	90                   	nop
80103aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103af0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103af3:	8d 42 01             	lea    0x1(%edx),%eax
80103af6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103afc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103b02:	83 c6 01             	add    $0x1,%esi
80103b05:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103b09:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103b0c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103b0f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103b13:	0f 85 4f ff ff ff    	jne    80103a68 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103b19:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103b1f:	83 ec 0c             	sub    $0xc,%esp
80103b22:	50                   	push   %eax
80103b23:	e8 48 0c 00 00       	call   80104770 <wakeup>
  release(&p->lock);
80103b28:	89 1c 24             	mov    %ebx,(%esp)
80103b2b:	e8 40 11 00 00       	call   80104c70 <release>
  return n;
80103b30:	83 c4 10             	add    $0x10,%esp
80103b33:	8b 45 10             	mov    0x10(%ebp),%eax
80103b36:	eb a9                	jmp    80103ae1 <pipewrite+0xb1>
80103b38:	90                   	nop
80103b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b40 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	57                   	push   %edi
80103b44:	56                   	push   %esi
80103b45:	53                   	push   %ebx
80103b46:	83 ec 18             	sub    $0x18,%esp
80103b49:	8b 75 08             	mov    0x8(%ebp),%esi
80103b4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103b4f:	56                   	push   %esi
80103b50:	e8 5b 10 00 00       	call   80104bb0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b55:	83 c4 10             	add    $0x10,%esp
80103b58:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b5e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b64:	75 6a                	jne    80103bd0 <piperead+0x90>
80103b66:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103b6c:	85 db                	test   %ebx,%ebx
80103b6e:	0f 84 c4 00 00 00    	je     80103c38 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103b74:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103b7a:	eb 2d                	jmp    80103ba9 <piperead+0x69>
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b80:	83 ec 08             	sub    $0x8,%esp
80103b83:	56                   	push   %esi
80103b84:	53                   	push   %ebx
80103b85:	e8 f6 09 00 00       	call   80104580 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103b8a:	83 c4 10             	add    $0x10,%esp
80103b8d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103b93:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103b99:	75 35                	jne    80103bd0 <piperead+0x90>
80103b9b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103ba1:	85 d2                	test   %edx,%edx
80103ba3:	0f 84 8f 00 00 00    	je     80103c38 <piperead+0xf8>
    if(myproc()->killed){
80103ba9:	e8 12 03 00 00       	call   80103ec0 <myproc>
80103bae:	8b 48 24             	mov    0x24(%eax),%ecx
80103bb1:	85 c9                	test   %ecx,%ecx
80103bb3:	74 cb                	je     80103b80 <piperead+0x40>
      release(&p->lock);
80103bb5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103bb8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103bbd:	56                   	push   %esi
80103bbe:	e8 ad 10 00 00       	call   80104c70 <release>
      return -1;
80103bc3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103bc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bc9:	89 d8                	mov    %ebx,%eax
80103bcb:	5b                   	pop    %ebx
80103bcc:	5e                   	pop    %esi
80103bcd:	5f                   	pop    %edi
80103bce:	5d                   	pop    %ebp
80103bcf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103bd0:	8b 45 10             	mov    0x10(%ebp),%eax
80103bd3:	85 c0                	test   %eax,%eax
80103bd5:	7e 61                	jle    80103c38 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103bd7:	31 db                	xor    %ebx,%ebx
80103bd9:	eb 13                	jmp    80103bee <piperead+0xae>
80103bdb:	90                   	nop
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103be0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103be6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103bec:	74 1f                	je     80103c0d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103bee:	8d 41 01             	lea    0x1(%ecx),%eax
80103bf1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103bf7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103bfd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103c02:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103c05:	83 c3 01             	add    $0x1,%ebx
80103c08:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103c0b:	75 d3                	jne    80103be0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103c0d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103c13:	83 ec 0c             	sub    $0xc,%esp
80103c16:	50                   	push   %eax
80103c17:	e8 54 0b 00 00       	call   80104770 <wakeup>
  release(&p->lock);
80103c1c:	89 34 24             	mov    %esi,(%esp)
80103c1f:	e8 4c 10 00 00       	call   80104c70 <release>
  return i;
80103c24:	83 c4 10             	add    $0x10,%esp
}
80103c27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c2a:	89 d8                	mov    %ebx,%eax
80103c2c:	5b                   	pop    %ebx
80103c2d:	5e                   	pop    %esi
80103c2e:	5f                   	pop    %edi
80103c2f:	5d                   	pop    %ebp
80103c30:	c3                   	ret    
80103c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c38:	31 db                	xor    %ebx,%ebx
80103c3a:	eb d1                	jmp    80103c0d <piperead+0xcd>
80103c3c:	66 90                	xchg   %ax,%ax
80103c3e:	66 90                	xchg   %ax,%ax

80103c40 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c44:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
{
80103c49:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103c4c:	68 60 5d 19 80       	push   $0x80195d60
80103c51:	e8 5a 0f 00 00       	call   80104bb0 <acquire>
80103c56:	83 c4 10             	add    $0x10,%esp
80103c59:	eb 17                	jmp    80103c72 <allocproc+0x32>
80103c5b:	90                   	nop
80103c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c60:	81 c3 90 02 00 00    	add    $0x290,%ebx
80103c66:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80103c6c:	0f 83 06 01 00 00    	jae    80103d78 <allocproc+0x138>
    if(p->state == UNUSED)
80103c72:	8b 43 0c             	mov    0xc(%ebx),%eax
80103c75:	85 c0                	test   %eax,%eax
80103c77:	75 e7                	jne    80103c60 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103c79:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103c7e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103c81:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103c88:	8d 50 01             	lea    0x1(%eax),%edx
80103c8b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103c8e:	68 60 5d 19 80       	push   $0x80195d60
  p->pid = nextpid++;
80103c93:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103c99:	e8 d2 0f 00 00       	call   80104c70 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103c9e:	e8 1d ed ff ff       	call   801029c0 <kalloc>
80103ca3:	83 c4 10             	add    $0x10,%esp
80103ca6:	85 c0                	test   %eax,%eax
80103ca8:	89 43 08             	mov    %eax,0x8(%ebx)
80103cab:	0f 84 e0 00 00 00    	je     80103d91 <allocproc+0x151>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103cb1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103cb7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103cba:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103cbf:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103cc2:	c7 40 14 21 5f 10 80 	movl   $0x80105f21,0x14(%eax)
  p->context = (struct context*)sp;
80103cc9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ccc:	6a 14                	push   $0x14
80103cce:	6a 00                	push   $0x0
80103cd0:	50                   	push   %eax
80103cd1:	e8 ea 0f 00 00       	call   80104cc0 <memset>
  p->context->eip = (uint)forkret;
80103cd6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80103cd9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103cdc:	c7 40 10 b0 3d 10 80 	movl   $0x80103db0,0x10(%eax)
  if(p->pid > 2) {
80103ce3:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103ce7:	7f 07                	jg     80103cf0 <allocproc+0xb0>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
  }


  return p;
}
80103ce9:	89 d8                	mov    %ebx,%eax
80103ceb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cee:	c9                   	leave  
80103cef:	c3                   	ret    
    if(createSwapFile(p) != 0)
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	53                   	push   %ebx
80103cf4:	e8 f7 e4 ff ff       	call   801021f0 <createSwapFile>
80103cf9:	83 c4 10             	add    $0x10,%esp
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	0f 85 9b 00 00 00    	jne    80103d9f <allocproc+0x15f>
    memset(buf, 0, 16 * 4096);
80103d04:	83 ec 04             	sub    $0x4,%esp
80103d07:	68 00 00 01 00       	push   $0x10000
80103d0c:	6a 00                	push   $0x0
80103d0e:	68 c0 b5 10 80       	push   $0x8010b5c0
80103d13:	e8 a8 0f 00 00       	call   80104cc0 <memset>
    writeToSwapFile(p, (char*)buf, 0, PGSIZE * 16);
80103d18:	68 00 00 01 00       	push   $0x10000
80103d1d:	6a 00                	push   $0x0
80103d1f:	68 c0 b5 10 80       	push   $0x8010b5c0
80103d24:	53                   	push   %ebx
80103d25:	e8 66 e5 ff ff       	call   80102290 <writeToSwapFile>
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d2a:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80103d30:	83 c4 1c             	add    $0x1c,%esp
    p->num_ram = 0;
80103d33:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80103d3a:	00 00 00 
    p->num_swap = 0;
80103d3d:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80103d44:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d47:	68 00 01 00 00       	push   $0x100
80103d4c:	6a 00                	push   $0x0
80103d4e:	50                   	push   %eax
80103d4f:	e8 6c 0f 00 00       	call   80104cc0 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d54:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103d5a:	83 c4 0c             	add    $0xc,%esp
80103d5d:	68 00 01 00 00       	push   $0x100
80103d62:	6a 00                	push   $0x0
80103d64:	50                   	push   %eax
80103d65:	e8 56 0f 00 00       	call   80104cc0 <memset>
}
80103d6a:	89 d8                	mov    %ebx,%eax
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103d6c:	83 c4 10             	add    $0x10,%esp
}
80103d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d72:	c9                   	leave  
80103d73:	c3                   	ret    
80103d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103d78:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103d7b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103d7d:	68 60 5d 19 80       	push   $0x80195d60
80103d82:	e8 e9 0e 00 00       	call   80104c70 <release>
}
80103d87:	89 d8                	mov    %ebx,%eax
  return 0;
80103d89:	83 c4 10             	add    $0x10,%esp
}
80103d8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d8f:	c9                   	leave  
80103d90:	c3                   	ret    
    p->state = UNUSED;
80103d91:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103d98:	31 db                	xor    %ebx,%ebx
80103d9a:	e9 4a ff ff ff       	jmp    80103ce9 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
80103d9f:	83 ec 0c             	sub    $0xc,%esp
80103da2:	68 d5 84 10 80       	push   $0x801084d5
80103da7:	e8 e4 c5 ff ff       	call   80100390 <panic>
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103db0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103db6:	68 60 5d 19 80       	push   $0x80195d60
80103dbb:	e8 b0 0e 00 00       	call   80104c70 <release>

  if (first) {
80103dc0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103dc5:	83 c4 10             	add    $0x10,%esp
80103dc8:	85 c0                	test   %eax,%eax
80103dca:	75 04                	jne    80103dd0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103dcc:	c9                   	leave  
80103dcd:	c3                   	ret    
80103dce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103dd0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103dd3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103dda:	00 00 00 
    iinit(ROOTDEV);
80103ddd:	6a 01                	push   $0x1
80103ddf:	e8 dc d6 ff ff       	call   801014c0 <iinit>
    initlog(ROOTDEV);
80103de4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103deb:	e8 50 f3 ff ff       	call   80103140 <initlog>
80103df0:	83 c4 10             	add    $0x10,%esp
}
80103df3:	c9                   	leave  
80103df4:	c3                   	ret    
80103df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <pinit>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103e06:	68 ef 84 10 80       	push   $0x801084ef
80103e0b:	68 60 5d 19 80       	push   $0x80195d60
80103e10:	e8 5b 0c 00 00       	call   80104a70 <initlock>
}
80103e15:	83 c4 10             	add    $0x10,%esp
80103e18:	c9                   	leave  
80103e19:	c3                   	ret    
80103e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103e20 <mycpu>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	56                   	push   %esi
80103e24:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e25:	9c                   	pushf  
80103e26:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e27:	f6 c4 02             	test   $0x2,%ah
80103e2a:	75 5e                	jne    80103e8a <mycpu+0x6a>
  apicid = lapicid();
80103e2c:	e8 3f ef ff ff       	call   80102d70 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103e31:	8b 35 40 5d 19 80    	mov    0x80195d40,%esi
80103e37:	85 f6                	test   %esi,%esi
80103e39:	7e 42                	jle    80103e7d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103e3b:	0f b6 15 c0 57 19 80 	movzbl 0x801957c0,%edx
80103e42:	39 d0                	cmp    %edx,%eax
80103e44:	74 30                	je     80103e76 <mycpu+0x56>
80103e46:	b9 70 58 19 80       	mov    $0x80195870,%ecx
  for (i = 0; i < ncpu; ++i) {
80103e4b:	31 d2                	xor    %edx,%edx
80103e4d:	8d 76 00             	lea    0x0(%esi),%esi
80103e50:	83 c2 01             	add    $0x1,%edx
80103e53:	39 f2                	cmp    %esi,%edx
80103e55:	74 26                	je     80103e7d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103e57:	0f b6 19             	movzbl (%ecx),%ebx
80103e5a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103e60:	39 c3                	cmp    %eax,%ebx
80103e62:	75 ec                	jne    80103e50 <mycpu+0x30>
80103e64:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103e6a:	05 c0 57 19 80       	add    $0x801957c0,%eax
}
80103e6f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e72:	5b                   	pop    %ebx
80103e73:	5e                   	pop    %esi
80103e74:	5d                   	pop    %ebp
80103e75:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103e76:	b8 c0 57 19 80       	mov    $0x801957c0,%eax
      return &cpus[i];
80103e7b:	eb f2                	jmp    80103e6f <mycpu+0x4f>
  panic("unknown apicid\n");
80103e7d:	83 ec 0c             	sub    $0xc,%esp
80103e80:	68 f6 84 10 80       	push   $0x801084f6
80103e85:	e8 06 c5 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103e8a:	83 ec 0c             	sub    $0xc,%esp
80103e8d:	68 00 86 10 80       	push   $0x80108600
80103e92:	e8 f9 c4 ff ff       	call   80100390 <panic>
80103e97:	89 f6                	mov    %esi,%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <cpuid>:
cpuid() {
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103ea6:	e8 75 ff ff ff       	call   80103e20 <mycpu>
80103eab:	2d c0 57 19 80       	sub    $0x801957c0,%eax
}
80103eb0:	c9                   	leave  
  return mycpu()-cpus;
80103eb1:	c1 f8 04             	sar    $0x4,%eax
80103eb4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103eba:	c3                   	ret    
80103ebb:	90                   	nop
80103ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <myproc>:
myproc(void) {
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	53                   	push   %ebx
80103ec4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ec7:	e8 14 0c 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103ecc:	e8 4f ff ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80103ed1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ed7:	e8 44 0c 00 00       	call   80104b20 <popcli>
}
80103edc:	83 c4 04             	add    $0x4,%esp
80103edf:	89 d8                	mov    %ebx,%eax
80103ee1:	5b                   	pop    %ebx
80103ee2:	5d                   	pop    %ebp
80103ee3:	c3                   	ret    
80103ee4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103eea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ef0 <userinit>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	53                   	push   %ebx
80103ef4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ef7:	e8 44 fd ff ff       	call   80103c40 <allocproc>
80103efc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103efe:	a3 c0 b5 11 80       	mov    %eax,0x8011b5c0
  if((p->pgdir = setupkvm()) == 0)
80103f03:	e8 78 38 00 00       	call   80107780 <setupkvm>
80103f08:	85 c0                	test   %eax,%eax
80103f0a:	89 43 04             	mov    %eax,0x4(%ebx)
80103f0d:	0f 84 bd 00 00 00    	je     80103fd0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103f13:	83 ec 04             	sub    $0x4,%esp
80103f16:	68 2c 00 00 00       	push   $0x2c
80103f1b:	68 60 b4 10 80       	push   $0x8010b460
80103f20:	50                   	push   %eax
80103f21:	e8 fa 31 00 00       	call   80107120 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103f26:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103f29:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103f2f:	6a 4c                	push   $0x4c
80103f31:	6a 00                	push   $0x0
80103f33:	ff 73 18             	pushl  0x18(%ebx)
80103f36:	e8 85 0d 00 00       	call   80104cc0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f3b:	8b 43 18             	mov    0x18(%ebx),%eax
80103f3e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f43:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f48:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103f4b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103f4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103f52:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103f56:	8b 43 18             	mov    0x18(%ebx),%eax
80103f59:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f5d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103f61:	8b 43 18             	mov    0x18(%ebx),%eax
80103f64:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103f68:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103f6c:	8b 43 18             	mov    0x18(%ebx),%eax
80103f6f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103f76:	8b 43 18             	mov    0x18(%ebx),%eax
80103f79:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103f80:	8b 43 18             	mov    0x18(%ebx),%eax
80103f83:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103f8a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103f8d:	6a 10                	push   $0x10
80103f8f:	68 1f 85 10 80       	push   $0x8010851f
80103f94:	50                   	push   %eax
80103f95:	e8 06 0f 00 00       	call   80104ea0 <safestrcpy>
  p->cwd = namei("/");
80103f9a:	c7 04 24 28 85 10 80 	movl   $0x80108528,(%esp)
80103fa1:	e8 7a df ff ff       	call   80101f20 <namei>
80103fa6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103fa9:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80103fb0:	e8 fb 0b 00 00       	call   80104bb0 <acquire>
  p->state = RUNNABLE;
80103fb5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fbc:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80103fc3:	e8 a8 0c 00 00       	call   80104c70 <release>
}
80103fc8:	83 c4 10             	add    $0x10,%esp
80103fcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fce:	c9                   	leave  
80103fcf:	c3                   	ret    
    panic("userinit: out of memory?");
80103fd0:	83 ec 0c             	sub    $0xc,%esp
80103fd3:	68 06 85 10 80       	push   $0x80108506
80103fd8:	e8 b3 c3 ff ff       	call   80100390 <panic>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi

80103fe0 <growproc>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
80103fe5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103fe8:	e8 f3 0a 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80103fed:	e8 2e fe ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80103ff2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ff8:	e8 23 0b 00 00       	call   80104b20 <popcli>
  if(n > 0){
80103ffd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104000:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104002:	7f 1c                	jg     80104020 <growproc+0x40>
  } else if(n < 0){
80104004:	75 3a                	jne    80104040 <growproc+0x60>
  switchuvm(curproc);
80104006:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80104009:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010400b:	53                   	push   %ebx
8010400c:	e8 ff 2f 00 00       	call   80107010 <switchuvm>
  return 0;
80104011:	83 c4 10             	add    $0x10,%esp
80104014:	31 c0                	xor    %eax,%eax
}
80104016:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104019:	5b                   	pop    %ebx
8010401a:	5e                   	pop    %esi
8010401b:	5d                   	pop    %ebp
8010401c:	c3                   	ret    
8010401d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104020:	83 ec 04             	sub    $0x4,%esp
80104023:	01 c6                	add    %eax,%esi
80104025:	56                   	push   %esi
80104026:	50                   	push   %eax
80104027:	ff 73 04             	pushl  0x4(%ebx)
8010402a:	e8 11 34 00 00       	call   80107440 <allocuvm>
8010402f:	83 c4 10             	add    $0x10,%esp
80104032:	85 c0                	test   %eax,%eax
80104034:	75 d0                	jne    80104006 <growproc+0x26>
      return -1;
80104036:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010403b:	eb d9                	jmp    80104016 <growproc+0x36>
8010403d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104040:	83 ec 04             	sub    $0x4,%esp
80104043:	01 c6                	add    %eax,%esi
80104045:	56                   	push   %esi
80104046:	50                   	push   %eax
80104047:	ff 73 04             	pushl  0x4(%ebx)
8010404a:	e8 21 32 00 00       	call   80107270 <deallocuvm>
8010404f:	83 c4 10             	add    $0x10,%esp
80104052:	85 c0                	test   %eax,%eax
80104054:	75 b0                	jne    80104006 <growproc+0x26>
80104056:	eb de                	jmp    80104036 <growproc+0x56>
80104058:	90                   	nop
80104059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104060 <fork>:
{ 
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104069:	e8 72 0a 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010406e:	e8 ad fd ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80104073:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104079:	e8 a2 0a 00 00       	call   80104b20 <popcli>
  if((np = allocproc()) == 0){
8010407e:	e8 bd fb ff ff       	call   80103c40 <allocproc>
80104083:	85 c0                	test   %eax,%eax
80104085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104088:	0f 84 a8 01 00 00    	je     80104236 <fork+0x1d6>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010408e:	83 ec 08             	sub    $0x8,%esp
80104091:	ff 33                	pushl  (%ebx)
80104093:	ff 73 04             	pushl  0x4(%ebx)
80104096:	e8 05 3c 00 00       	call   80107ca0 <copyuvm>
8010409b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(np->pgdir == 0){
8010409e:	83 c4 10             	add    $0x10,%esp
801040a1:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801040a3:	89 42 04             	mov    %eax,0x4(%edx)
  if(np->pgdir == 0){
801040a6:	0f 84 94 01 00 00    	je     80104240 <fork+0x1e0>
  np->sz = curproc->sz;
801040ac:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801040ae:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
801040b3:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801040b6:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
801040b9:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801040bb:	8b 73 18             	mov    0x18(%ebx),%esi
801040be:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801040c0:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801040c4:	0f 8f 9e 00 00 00    	jg     80104168 <fork+0x108>
  np->tf->eax = 0;
801040ca:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
801040cd:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801040cf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801040d6:	8d 76 00             	lea    0x0(%esi),%esi
801040d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
801040e0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801040e4:	85 c0                	test   %eax,%eax
801040e6:	74 16                	je     801040fe <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
801040e8:	83 ec 0c             	sub    $0xc,%esp
801040eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801040ee:	50                   	push   %eax
801040ef:	e8 3c cd ff ff       	call   80100e30 <filedup>
801040f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801040f7:	83 c4 10             	add    $0x10,%esp
801040fa:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801040fe:	83 c6 01             	add    $0x1,%esi
80104101:	83 fe 10             	cmp    $0x10,%esi
80104104:	75 da                	jne    801040e0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	ff 73 68             	pushl  0x68(%ebx)
8010410c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010410f:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104112:	e8 79 d5 ff ff       	call   80101690 <idup>
80104117:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010411a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010411d:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104120:	8d 42 6c             	lea    0x6c(%edx),%eax
80104123:	6a 10                	push   $0x10
80104125:	53                   	push   %ebx
80104126:	50                   	push   %eax
80104127:	e8 74 0d 00 00       	call   80104ea0 <safestrcpy>
  pid = np->pid;
8010412c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010412f:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80104132:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104139:	e8 72 0a 00 00       	call   80104bb0 <acquire>
  np->state = RUNNABLE;
8010413e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104141:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80104148:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
8010414f:	e8 1c 0b 00 00       	call   80104c70 <release>
  return pid;
80104154:	83 c4 10             	add    $0x10,%esp
}
80104157:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415a:	89 d8                	mov    %ebx,%eax
8010415c:	5b                   	pop    %ebx
8010415d:	5e                   	pop    %esi
8010415e:	5f                   	pop    %edi
8010415f:	5d                   	pop    %ebp
80104160:	c3                   	ret    
80104161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->ramPages[i].isused)
80104168:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
8010416e:	85 c0                	test   %eax,%eax
80104170:	74 1f                	je     80104191 <fork+0x131>
        np->ramPages[i].isused = 1;
80104172:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80104179:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010417c:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
80104182:	89 82 90 01 00 00    	mov    %eax,0x190(%edx)
        np->ramPages[i].pgdir = np->pgdir;
80104188:	8b 42 04             	mov    0x4(%edx),%eax
8010418b:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
{ 
80104191:	31 f6                	xor    %esi,%esi
80104193:	eb 12                	jmp    801041a7 <fork+0x147>
80104195:	8d 76 00             	lea    0x0(%esi),%esi
80104198:	83 c6 10             	add    $0x10,%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++)
8010419b:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801041a1:	0f 84 23 ff ff ff    	je     801040ca <fork+0x6a>
      if(curproc->swappedPages[i].isused)
801041a7:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
801041ae:	85 c9                	test   %ecx,%ecx
801041b0:	74 e6                	je     80104198 <fork+0x138>
      np->swappedPages[i].isused = 1;
801041b2:	c7 84 32 8c 00 00 00 	movl   $0x1,0x8c(%edx,%esi,1)
801041b9:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801041bd:	8b 84 33 90 00 00 00 	mov    0x90(%ebx,%esi,1),%eax
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
801041c4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
801041c7:	89 84 32 90 00 00 00 	mov    %eax,0x90(%edx,%esi,1)
      np->swappedPages[i].pgdir = np->pgdir;
801041ce:	8b 42 04             	mov    0x4(%edx),%eax
801041d1:	89 84 32 88 00 00 00 	mov    %eax,0x88(%edx,%esi,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
801041d8:	8b 84 33 94 00 00 00 	mov    0x94(%ebx,%esi,1),%eax
801041df:	89 84 32 94 00 00 00 	mov    %eax,0x94(%edx,%esi,1)
      if(readFromSwapFile((void*)curproc, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
801041e6:	68 00 10 00 00       	push   $0x1000
801041eb:	50                   	push   %eax
801041ec:	68 e0 b5 11 80       	push   $0x8011b5e0
801041f1:	53                   	push   %ebx
801041f2:	e8 c9 e0 ff ff       	call   801022c0 <readFromSwapFile>
801041f7:	83 c4 10             	add    $0x10,%esp
801041fa:	85 c0                	test   %eax,%eax
801041fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801041ff:	78 68                	js     80104269 <fork+0x209>
      if(writeToSwapFile((void*)np, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
80104201:	68 00 10 00 00       	push   $0x1000
80104206:	ff b4 32 94 00 00 00 	pushl  0x94(%edx,%esi,1)
8010420d:	68 e0 b5 11 80       	push   $0x8011b5e0
80104212:	52                   	push   %edx
80104213:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80104216:	e8 75 e0 ff ff       	call   80102290 <writeToSwapFile>
8010421b:	83 c4 10             	add    $0x10,%esp
8010421e:	85 c0                	test   %eax,%eax
80104220:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104223:	0f 89 6f ff ff ff    	jns    80104198 <fork+0x138>
        panic("fork: writeToSwapFile");
80104229:	83 ec 0c             	sub    $0xc,%esp
8010422c:	68 41 85 10 80       	push   $0x80108541
80104231:	e8 5a c1 ff ff       	call   80100390 <panic>
    return -1;
80104236:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010423b:	e9 17 ff ff ff       	jmp    80104157 <fork+0xf7>
    kfree(np->kstack);
80104240:	83 ec 0c             	sub    $0xc,%esp
80104243:	ff 72 08             	pushl  0x8(%edx)
    return -1;
80104246:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
8010424b:	e8 90 e4 ff ff       	call   801026e0 <kfree>
    np->kstack = 0;
80104250:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104253:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104256:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010425d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104264:	e9 ee fe ff ff       	jmp    80104157 <fork+0xf7>
        panic("fork: readFromSwapFile");
80104269:	83 ec 0c             	sub    $0xc,%esp
8010426c:	68 2a 85 10 80       	push   $0x8010852a
80104271:	e8 1a c1 ff ff       	call   80100390 <panic>
80104276:	8d 76 00             	lea    0x0(%esi),%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104280 <scheduler>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	57                   	push   %edi
80104284:	56                   	push   %esi
80104285:	53                   	push   %ebx
80104286:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104289:	e8 92 fb ff ff       	call   80103e20 <mycpu>
8010428e:	8d 78 04             	lea    0x4(%eax),%edi
80104291:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104293:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010429a:	00 00 00 
8010429d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801042a0:	fb                   	sti    
    acquire(&ptable.lock);
801042a1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042a4:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
    acquire(&ptable.lock);
801042a9:	68 60 5d 19 80       	push   $0x80195d60
801042ae:	e8 fd 08 00 00       	call   80104bb0 <acquire>
801042b3:	83 c4 10             	add    $0x10,%esp
801042b6:	8d 76 00             	lea    0x0(%esi),%esi
801042b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801042c0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801042c4:	75 33                	jne    801042f9 <scheduler+0x79>
      switchuvm(p);
801042c6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801042c9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801042cf:	53                   	push   %ebx
801042d0:	e8 3b 2d 00 00       	call   80107010 <switchuvm>
      swtch(&(c->scheduler), p->context);
801042d5:	58                   	pop    %eax
801042d6:	5a                   	pop    %edx
801042d7:	ff 73 1c             	pushl  0x1c(%ebx)
801042da:	57                   	push   %edi
      p->state = RUNNING;
801042db:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801042e2:	e8 14 0c 00 00       	call   80104efb <swtch>
      switchkvm();
801042e7:	e8 04 2d 00 00       	call   80106ff0 <switchkvm>
      c->proc = 0;
801042ec:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801042f3:	00 00 00 
801042f6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f9:	81 c3 90 02 00 00    	add    $0x290,%ebx
801042ff:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80104305:	72 b9                	jb     801042c0 <scheduler+0x40>
    release(&ptable.lock);
80104307:	83 ec 0c             	sub    $0xc,%esp
8010430a:	68 60 5d 19 80       	push   $0x80195d60
8010430f:	e8 5c 09 00 00       	call   80104c70 <release>
    sti();
80104314:	83 c4 10             	add    $0x10,%esp
80104317:	eb 87                	jmp    801042a0 <scheduler+0x20>
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104320 <sched>:
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
  pushcli();
80104325:	e8 b6 07 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010432a:	e8 f1 fa ff ff       	call   80103e20 <mycpu>
  p = c->proc;
8010432f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104335:	e8 e6 07 00 00       	call   80104b20 <popcli>
  if(!holding(&ptable.lock))
8010433a:	83 ec 0c             	sub    $0xc,%esp
8010433d:	68 60 5d 19 80       	push   $0x80195d60
80104342:	e8 39 08 00 00       	call   80104b80 <holding>
80104347:	83 c4 10             	add    $0x10,%esp
8010434a:	85 c0                	test   %eax,%eax
8010434c:	74 4f                	je     8010439d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010434e:	e8 cd fa ff ff       	call   80103e20 <mycpu>
80104353:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010435a:	75 68                	jne    801043c4 <sched+0xa4>
  if(p->state == RUNNING)
8010435c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104360:	74 55                	je     801043b7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104362:	9c                   	pushf  
80104363:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104364:	f6 c4 02             	test   $0x2,%ah
80104367:	75 41                	jne    801043aa <sched+0x8a>
  intena = mycpu()->intena;
80104369:	e8 b2 fa ff ff       	call   80103e20 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010436e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104371:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104377:	e8 a4 fa ff ff       	call   80103e20 <mycpu>
8010437c:	83 ec 08             	sub    $0x8,%esp
8010437f:	ff 70 04             	pushl  0x4(%eax)
80104382:	53                   	push   %ebx
80104383:	e8 73 0b 00 00       	call   80104efb <swtch>
  mycpu()->intena = intena;
80104388:	e8 93 fa ff ff       	call   80103e20 <mycpu>
}
8010438d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104390:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104396:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104399:	5b                   	pop    %ebx
8010439a:	5e                   	pop    %esi
8010439b:	5d                   	pop    %ebp
8010439c:	c3                   	ret    
    panic("sched ptable.lock");
8010439d:	83 ec 0c             	sub    $0xc,%esp
801043a0:	68 57 85 10 80       	push   $0x80108557
801043a5:	e8 e6 bf ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801043aa:	83 ec 0c             	sub    $0xc,%esp
801043ad:	68 83 85 10 80       	push   $0x80108583
801043b2:	e8 d9 bf ff ff       	call   80100390 <panic>
    panic("sched running");
801043b7:	83 ec 0c             	sub    $0xc,%esp
801043ba:	68 75 85 10 80       	push   $0x80108575
801043bf:	e8 cc bf ff ff       	call   80100390 <panic>
    panic("sched locks");
801043c4:	83 ec 0c             	sub    $0xc,%esp
801043c7:	68 69 85 10 80       	push   $0x80108569
801043cc:	e8 bf bf ff ff       	call   80100390 <panic>
801043d1:	eb 0d                	jmp    801043e0 <exit>
801043d3:	90                   	nop
801043d4:	90                   	nop
801043d5:	90                   	nop
801043d6:	90                   	nop
801043d7:	90                   	nop
801043d8:	90                   	nop
801043d9:	90                   	nop
801043da:	90                   	nop
801043db:	90                   	nop
801043dc:	90                   	nop
801043dd:	90                   	nop
801043de:	90                   	nop
801043df:	90                   	nop

801043e0 <exit>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	56                   	push   %esi
801043e5:	53                   	push   %ebx
801043e6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801043e9:	e8 f2 06 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
801043ee:	e8 2d fa ff ff       	call   80103e20 <mycpu>
  p = c->proc;
801043f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043f9:	e8 22 07 00 00       	call   80104b20 <popcli>
  if(curproc-> pid > 2)
801043fe:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104402:	0f 8f 09 01 00 00    	jg     80104511 <exit+0x131>
  if(curproc == initproc)
80104408:	39 1d c0 b5 11 80    	cmp    %ebx,0x8011b5c0
8010440e:	8d 73 28             	lea    0x28(%ebx),%esi
80104411:	8d 7b 68             	lea    0x68(%ebx),%edi
80104414:	0f 84 08 01 00 00    	je     80104522 <exit+0x142>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104420:	8b 06                	mov    (%esi),%eax
80104422:	85 c0                	test   %eax,%eax
80104424:	74 12                	je     80104438 <exit+0x58>
      fileclose(curproc->ofile[fd]);
80104426:	83 ec 0c             	sub    $0xc,%esp
80104429:	50                   	push   %eax
8010442a:	e8 51 ca ff ff       	call   80100e80 <fileclose>
      curproc->ofile[fd] = 0;
8010442f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104435:	83 c4 10             	add    $0x10,%esp
80104438:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010443b:	39 fe                	cmp    %edi,%esi
8010443d:	75 e1                	jne    80104420 <exit+0x40>
  begin_op();
8010443f:	e8 9c ed ff ff       	call   801031e0 <begin_op>
  iput(curproc->cwd);
80104444:	83 ec 0c             	sub    $0xc,%esp
80104447:	ff 73 68             	pushl  0x68(%ebx)
8010444a:	e8 a1 d3 ff ff       	call   801017f0 <iput>
  end_op();
8010444f:	e8 fc ed ff ff       	call   80103250 <end_op>
  curproc->cwd = 0;
80104454:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010445b:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104462:	e8 49 07 00 00       	call   80104bb0 <acquire>
  wakeup1(curproc->parent);
80104467:	8b 53 14             	mov    0x14(%ebx),%edx
8010446a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010446d:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
80104472:	eb 10                	jmp    80104484 <exit+0xa4>
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104478:	05 90 02 00 00       	add    $0x290,%eax
8010447d:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
80104482:	73 1e                	jae    801044a2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104484:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104488:	75 ee                	jne    80104478 <exit+0x98>
8010448a:	3b 50 20             	cmp    0x20(%eax),%edx
8010448d:	75 e9                	jne    80104478 <exit+0x98>
      p->state = RUNNABLE;
8010448f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104496:	05 90 02 00 00       	add    $0x290,%eax
8010449b:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801044a0:	72 e2                	jb     80104484 <exit+0xa4>
      p->parent = initproc;
801044a2:	8b 0d c0 b5 11 80    	mov    0x8011b5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a8:	ba 94 5d 19 80       	mov    $0x80195d94,%edx
801044ad:	eb 0f                	jmp    801044be <exit+0xde>
801044af:	90                   	nop
801044b0:	81 c2 90 02 00 00    	add    $0x290,%edx
801044b6:	81 fa 94 01 1a 80    	cmp    $0x801a0194,%edx
801044bc:	73 3a                	jae    801044f8 <exit+0x118>
    if(p->parent == curproc){
801044be:	39 5a 14             	cmp    %ebx,0x14(%edx)
801044c1:	75 ed                	jne    801044b0 <exit+0xd0>
      if(p->state == ZOMBIE)
801044c3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801044c7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801044ca:	75 e4                	jne    801044b0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044cc:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
801044d1:	eb 11                	jmp    801044e4 <exit+0x104>
801044d3:	90                   	nop
801044d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044d8:	05 90 02 00 00       	add    $0x290,%eax
801044dd:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801044e2:	73 cc                	jae    801044b0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801044e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801044e8:	75 ee                	jne    801044d8 <exit+0xf8>
801044ea:	3b 48 20             	cmp    0x20(%eax),%ecx
801044ed:	75 e9                	jne    801044d8 <exit+0xf8>
      p->state = RUNNABLE;
801044ef:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801044f6:	eb e0                	jmp    801044d8 <exit+0xf8>
  curproc->state = ZOMBIE;
801044f8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801044ff:	e8 1c fe ff ff       	call   80104320 <sched>
  panic("zombie exit");
80104504:	83 ec 0c             	sub    $0xc,%esp
80104507:	68 a4 85 10 80       	push   $0x801085a4
8010450c:	e8 7f be ff ff       	call   80100390 <panic>
    removeSwapFile(curproc);
80104511:	83 ec 0c             	sub    $0xc,%esp
80104514:	53                   	push   %ebx
80104515:	e8 d6 da ff ff       	call   80101ff0 <removeSwapFile>
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	e9 e6 fe ff ff       	jmp    80104408 <exit+0x28>
    panic("init exiting");
80104522:	83 ec 0c             	sub    $0xc,%esp
80104525:	68 97 85 10 80       	push   $0x80108597
8010452a:	e8 61 be ff ff       	call   80100390 <panic>
8010452f:	90                   	nop

80104530 <yield>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104537:	68 60 5d 19 80       	push   $0x80195d60
8010453c:	e8 6f 06 00 00       	call   80104bb0 <acquire>
  pushcli();
80104541:	e8 9a 05 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104546:	e8 d5 f8 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
8010454b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104551:	e8 ca 05 00 00       	call   80104b20 <popcli>
  myproc()->state = RUNNABLE;
80104556:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010455d:	e8 be fd ff ff       	call   80104320 <sched>
  release(&ptable.lock);
80104562:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104569:	e8 02 07 00 00       	call   80104c70 <release>
}
8010456e:	83 c4 10             	add    $0x10,%esp
80104571:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104574:	c9                   	leave  
80104575:	c3                   	ret    
80104576:	8d 76 00             	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <sleep>:
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	56                   	push   %esi
80104585:	53                   	push   %ebx
80104586:	83 ec 0c             	sub    $0xc,%esp
80104589:	8b 7d 08             	mov    0x8(%ebp),%edi
8010458c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010458f:	e8 4c 05 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
80104594:	e8 87 f8 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
80104599:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010459f:	e8 7c 05 00 00       	call   80104b20 <popcli>
  if(p == 0)
801045a4:	85 db                	test   %ebx,%ebx
801045a6:	0f 84 87 00 00 00    	je     80104633 <sleep+0xb3>
  if(lk == 0)
801045ac:	85 f6                	test   %esi,%esi
801045ae:	74 76                	je     80104626 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801045b0:	81 fe 60 5d 19 80    	cmp    $0x80195d60,%esi
801045b6:	74 50                	je     80104608 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801045b8:	83 ec 0c             	sub    $0xc,%esp
801045bb:	68 60 5d 19 80       	push   $0x80195d60
801045c0:	e8 eb 05 00 00       	call   80104bb0 <acquire>
    release(lk);
801045c5:	89 34 24             	mov    %esi,(%esp)
801045c8:	e8 a3 06 00 00       	call   80104c70 <release>
  p->chan = chan;
801045cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801045d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801045d7:	e8 44 fd ff ff       	call   80104320 <sched>
  p->chan = 0;
801045dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801045e3:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
801045ea:	e8 81 06 00 00       	call   80104c70 <release>
    acquire(lk);
801045ef:	89 75 08             	mov    %esi,0x8(%ebp)
801045f2:	83 c4 10             	add    $0x10,%esp
}
801045f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045f8:	5b                   	pop    %ebx
801045f9:	5e                   	pop    %esi
801045fa:	5f                   	pop    %edi
801045fb:	5d                   	pop    %ebp
    acquire(lk);
801045fc:	e9 af 05 00 00       	jmp    80104bb0 <acquire>
80104601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104608:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010460b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104612:	e8 09 fd ff ff       	call   80104320 <sched>
  p->chan = 0;
80104617:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010461e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104621:	5b                   	pop    %ebx
80104622:	5e                   	pop    %esi
80104623:	5f                   	pop    %edi
80104624:	5d                   	pop    %ebp
80104625:	c3                   	ret    
    panic("sleep without lk");
80104626:	83 ec 0c             	sub    $0xc,%esp
80104629:	68 b6 85 10 80       	push   $0x801085b6
8010462e:	e8 5d bd ff ff       	call   80100390 <panic>
    panic("sleep");
80104633:	83 ec 0c             	sub    $0xc,%esp
80104636:	68 b0 85 10 80       	push   $0x801085b0
8010463b:	e8 50 bd ff ff       	call   80100390 <panic>

80104640 <wait>:
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
  pushcli();
80104645:	e8 96 04 00 00       	call   80104ae0 <pushcli>
  c = mycpu();
8010464a:	e8 d1 f7 ff ff       	call   80103e20 <mycpu>
  p = c->proc;
8010464f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104655:	e8 c6 04 00 00       	call   80104b20 <popcli>
  acquire(&ptable.lock);
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	68 60 5d 19 80       	push   $0x80195d60
80104662:	e8 49 05 00 00       	call   80104bb0 <acquire>
80104667:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010466a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010466c:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
80104671:	eb 13                	jmp    80104686 <wait+0x46>
80104673:	90                   	nop
80104674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104678:	81 c3 90 02 00 00    	add    $0x290,%ebx
8010467e:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80104684:	73 1e                	jae    801046a4 <wait+0x64>
      if(p->parent != curproc)
80104686:	39 73 14             	cmp    %esi,0x14(%ebx)
80104689:	75 ed                	jne    80104678 <wait+0x38>
      if(p->state == ZOMBIE){
8010468b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010468f:	74 3f                	je     801046d0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104691:	81 c3 90 02 00 00    	add    $0x290,%ebx
      havekids = 1;
80104697:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010469c:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
801046a2:	72 e2                	jb     80104686 <wait+0x46>
    if(!havekids || curproc->killed){
801046a4:	85 c0                	test   %eax,%eax
801046a6:	0f 84 a6 00 00 00    	je     80104752 <wait+0x112>
801046ac:	8b 46 24             	mov    0x24(%esi),%eax
801046af:	85 c0                	test   %eax,%eax
801046b1:	0f 85 9b 00 00 00    	jne    80104752 <wait+0x112>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801046b7:	83 ec 08             	sub    $0x8,%esp
801046ba:	68 60 5d 19 80       	push   $0x80195d60
801046bf:	56                   	push   %esi
801046c0:	e8 bb fe ff ff       	call   80104580 <sleep>
    havekids = 0;
801046c5:	83 c4 10             	add    $0x10,%esp
801046c8:	eb a0                	jmp    8010466a <wait+0x2a>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801046d0:	83 ec 0c             	sub    $0xc,%esp
801046d3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801046d6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801046d9:	e8 02 e0 ff ff       	call   801026e0 <kfree>
        freevm(p->pgdir);
801046de:	5a                   	pop    %edx
801046df:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801046e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801046e9:	e8 12 30 00 00       	call   80107700 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
801046ee:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
801046f4:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
801046f7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
801046fe:	68 00 01 00 00       	push   $0x100
80104703:	6a 00                	push   $0x0
80104705:	50                   	push   %eax
        p->parent = 0;
80104706:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010470d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104711:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104718:	e8 a3 05 00 00       	call   80104cc0 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
8010471d:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104723:	83 c4 0c             	add    $0xc,%esp
80104726:	68 00 01 00 00       	push   $0x100
8010472b:	6a 00                	push   $0x0
8010472d:	50                   	push   %eax
8010472e:	e8 8d 05 00 00       	call   80104cc0 <memset>
        release(&ptable.lock);
80104733:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
        p->state = UNUSED;
8010473a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104741:	e8 2a 05 00 00       	call   80104c70 <release>
        return pid;
80104746:	83 c4 10             	add    $0x10,%esp
}
80104749:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010474c:	89 f0                	mov    %esi,%eax
8010474e:	5b                   	pop    %ebx
8010474f:	5e                   	pop    %esi
80104750:	5d                   	pop    %ebp
80104751:	c3                   	ret    
      release(&ptable.lock);
80104752:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104755:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010475a:	68 60 5d 19 80       	push   $0x80195d60
8010475f:	e8 0c 05 00 00       	call   80104c70 <release>
      return -1;
80104764:	83 c4 10             	add    $0x10,%esp
80104767:	eb e0                	jmp    80104749 <wait+0x109>
80104769:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104770 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 10             	sub    $0x10,%esp
80104777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010477a:	68 60 5d 19 80       	push   $0x80195d60
8010477f:	e8 2c 04 00 00       	call   80104bb0 <acquire>
80104784:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104787:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
8010478c:	eb 0e                	jmp    8010479c <wakeup+0x2c>
8010478e:	66 90                	xchg   %ax,%ax
80104790:	05 90 02 00 00       	add    $0x290,%eax
80104795:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
8010479a:	73 1e                	jae    801047ba <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010479c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047a0:	75 ee                	jne    80104790 <wakeup+0x20>
801047a2:	3b 58 20             	cmp    0x20(%eax),%ebx
801047a5:	75 e9                	jne    80104790 <wakeup+0x20>
      p->state = RUNNABLE;
801047a7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047ae:	05 90 02 00 00       	add    $0x290,%eax
801047b3:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801047b8:	72 e2                	jb     8010479c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801047ba:	c7 45 08 60 5d 19 80 	movl   $0x80195d60,0x8(%ebp)
}
801047c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047c4:	c9                   	leave  
  release(&ptable.lock);
801047c5:	e9 a6 04 00 00       	jmp    80104c70 <release>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	53                   	push   %ebx
801047d4:	83 ec 10             	sub    $0x10,%esp
801047d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801047da:	68 60 5d 19 80       	push   $0x80195d60
801047df:	e8 cc 03 00 00       	call   80104bb0 <acquire>
801047e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e7:	b8 94 5d 19 80       	mov    $0x80195d94,%eax
801047ec:	eb 0e                	jmp    801047fc <kill+0x2c>
801047ee:	66 90                	xchg   %ax,%ax
801047f0:	05 90 02 00 00       	add    $0x290,%eax
801047f5:	3d 94 01 1a 80       	cmp    $0x801a0194,%eax
801047fa:	73 34                	jae    80104830 <kill+0x60>
    if(p->pid == pid){
801047fc:	39 58 10             	cmp    %ebx,0x10(%eax)
801047ff:	75 ef                	jne    801047f0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104801:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104805:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010480c:	75 07                	jne    80104815 <kill+0x45>
        p->state = RUNNABLE;
8010480e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104815:	83 ec 0c             	sub    $0xc,%esp
80104818:	68 60 5d 19 80       	push   $0x80195d60
8010481d:	e8 4e 04 00 00       	call   80104c70 <release>
      return 0;
80104822:	83 c4 10             	add    $0x10,%esp
80104825:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104827:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010482a:	c9                   	leave  
8010482b:	c3                   	ret    
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104830:	83 ec 0c             	sub    $0xc,%esp
80104833:	68 60 5d 19 80       	push   $0x80195d60
80104838:	e8 33 04 00 00       	call   80104c70 <release>
  return -1;
8010483d:	83 c4 10             	add    $0x10,%esp
80104840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104845:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104848:	c9                   	leave  
80104849:	c3                   	ret    
8010484a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104850 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	56                   	push   %esi
80104855:	53                   	push   %ebx
80104856:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104859:	bb 94 5d 19 80       	mov    $0x80195d94,%ebx
{
8010485e:	83 ec 3c             	sub    $0x3c,%esp
80104861:	eb 27                	jmp    8010488a <procdump+0x3a>
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104868:	83 ec 0c             	sub    $0xc,%esp
8010486b:	68 66 8a 10 80       	push   $0x80108a66
80104870:	e8 eb bd ff ff       	call   80100660 <cprintf>
80104875:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104878:	81 c3 90 02 00 00    	add    $0x290,%ebx
8010487e:	81 fb 94 01 1a 80    	cmp    $0x801a0194,%ebx
80104884:	0f 83 86 00 00 00    	jae    80104910 <procdump+0xc0>
    if(p->state == UNUSED)
8010488a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010488d:	85 c0                	test   %eax,%eax
8010488f:	74 e7                	je     80104878 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104891:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104894:	ba c7 85 10 80       	mov    $0x801085c7,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104899:	77 11                	ja     801048ac <procdump+0x5c>
8010489b:	8b 14 85 28 86 10 80 	mov    -0x7fef79d8(,%eax,4),%edx
      state = "???";
801048a2:	b8 c7 85 10 80       	mov    $0x801085c7,%eax
801048a7:	85 d2                	test   %edx,%edx
801048a9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801048ac:	8d 43 6c             	lea    0x6c(%ebx),%eax
801048af:	50                   	push   %eax
801048b0:	52                   	push   %edx
801048b1:	ff 73 10             	pushl  0x10(%ebx)
801048b4:	68 cb 85 10 80       	push   $0x801085cb
801048b9:	e8 a2 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801048be:	83 c4 10             	add    $0x10,%esp
801048c1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801048c5:	75 a1                	jne    80104868 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801048c7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801048ca:	83 ec 08             	sub    $0x8,%esp
801048cd:	8d 7d c0             	lea    -0x40(%ebp),%edi
801048d0:	50                   	push   %eax
801048d1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801048d4:	8b 40 0c             	mov    0xc(%eax),%eax
801048d7:	83 c0 08             	add    $0x8,%eax
801048da:	50                   	push   %eax
801048db:	e8 b0 01 00 00       	call   80104a90 <getcallerpcs>
801048e0:	83 c4 10             	add    $0x10,%esp
801048e3:	90                   	nop
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801048e8:	8b 17                	mov    (%edi),%edx
801048ea:	85 d2                	test   %edx,%edx
801048ec:	0f 84 76 ff ff ff    	je     80104868 <procdump+0x18>
        cprintf(" %p", pc[i]);
801048f2:	83 ec 08             	sub    $0x8,%esp
801048f5:	83 c7 04             	add    $0x4,%edi
801048f8:	52                   	push   %edx
801048f9:	68 61 7f 10 80       	push   $0x80107f61
801048fe:	e8 5d bd ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104903:	83 c4 10             	add    $0x10,%esp
80104906:	39 fe                	cmp    %edi,%esi
80104908:	75 de                	jne    801048e8 <procdump+0x98>
8010490a:	e9 59 ff ff ff       	jmp    80104868 <procdump+0x18>
8010490f:	90                   	nop
  }
}
80104910:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104913:	5b                   	pop    %ebx
80104914:	5e                   	pop    %esi
80104915:	5f                   	pop    %edi
80104916:	5d                   	pop    %ebp
80104917:	c3                   	ret    
80104918:	90                   	nop
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104920 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
80104926:	68 60 5d 19 80       	push   $0x80195d60
8010492b:	e8 80 02 00 00       	call   80104bb0 <acquire>
    if(p->state == UNUSED)
      continue;
    // sum += MAX_PSYC_PAGES - p->nummemorypages;
    pcount++;
  }
  release(&ptable.lock);
80104930:	c7 04 24 60 5d 19 80 	movl   $0x80195d60,(%esp)
80104937:	e8 34 03 00 00       	call   80104c70 <release>
  return sum;
8010493c:	31 c0                	xor    %eax,%eax
8010493e:	c9                   	leave  
8010493f:	c3                   	ret    

80104940 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	53                   	push   %ebx
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010494a:	68 40 86 10 80       	push   $0x80108640
8010494f:	8d 43 04             	lea    0x4(%ebx),%eax
80104952:	50                   	push   %eax
80104953:	e8 18 01 00 00       	call   80104a70 <initlock>
  lk->name = name;
80104958:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010495b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104961:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104964:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010496b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010496e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104971:	c9                   	leave  
80104972:	c3                   	ret    
80104973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104988:	83 ec 0c             	sub    $0xc,%esp
8010498b:	8d 73 04             	lea    0x4(%ebx),%esi
8010498e:	56                   	push   %esi
8010498f:	e8 1c 02 00 00       	call   80104bb0 <acquire>
  while (lk->locked) {
80104994:	8b 13                	mov    (%ebx),%edx
80104996:	83 c4 10             	add    $0x10,%esp
80104999:	85 d2                	test   %edx,%edx
8010499b:	74 16                	je     801049b3 <acquiresleep+0x33>
8010499d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049a0:	83 ec 08             	sub    $0x8,%esp
801049a3:	56                   	push   %esi
801049a4:	53                   	push   %ebx
801049a5:	e8 d6 fb ff ff       	call   80104580 <sleep>
  while (lk->locked) {
801049aa:	8b 03                	mov    (%ebx),%eax
801049ac:	83 c4 10             	add    $0x10,%esp
801049af:	85 c0                	test   %eax,%eax
801049b1:	75 ed                	jne    801049a0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801049b3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801049b9:	e8 02 f5 ff ff       	call   80103ec0 <myproc>
801049be:	8b 40 10             	mov    0x10(%eax),%eax
801049c1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801049c4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801049c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5d                   	pop    %ebp
  release(&lk->lk);
801049cd:	e9 9e 02 00 00       	jmp    80104c70 <release>
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
801049e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049e8:	83 ec 0c             	sub    $0xc,%esp
801049eb:	8d 73 04             	lea    0x4(%ebx),%esi
801049ee:	56                   	push   %esi
801049ef:	e8 bc 01 00 00       	call   80104bb0 <acquire>
  lk->locked = 0;
801049f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801049fa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a01:	89 1c 24             	mov    %ebx,(%esp)
80104a04:	e8 67 fd ff ff       	call   80104770 <wakeup>
  release(&lk->lk);
80104a09:	89 75 08             	mov    %esi,0x8(%ebp)
80104a0c:	83 c4 10             	add    $0x10,%esp
}
80104a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a12:	5b                   	pop    %ebx
80104a13:	5e                   	pop    %esi
80104a14:	5d                   	pop    %ebp
  release(&lk->lk);
80104a15:	e9 56 02 00 00       	jmp    80104c70 <release>
80104a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	57                   	push   %edi
80104a24:	56                   	push   %esi
80104a25:	53                   	push   %ebx
80104a26:	31 ff                	xor    %edi,%edi
80104a28:	83 ec 18             	sub    $0x18,%esp
80104a2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a2e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a31:	56                   	push   %esi
80104a32:	e8 79 01 00 00       	call   80104bb0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a37:	8b 03                	mov    (%ebx),%eax
80104a39:	83 c4 10             	add    $0x10,%esp
80104a3c:	85 c0                	test   %eax,%eax
80104a3e:	74 13                	je     80104a53 <holdingsleep+0x33>
80104a40:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a43:	e8 78 f4 ff ff       	call   80103ec0 <myproc>
80104a48:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a4b:	0f 94 c0             	sete   %al
80104a4e:	0f b6 c0             	movzbl %al,%eax
80104a51:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104a53:	83 ec 0c             	sub    $0xc,%esp
80104a56:	56                   	push   %esi
80104a57:	e8 14 02 00 00       	call   80104c70 <release>
  return r;
}
80104a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a5f:	89 f8                	mov    %edi,%eax
80104a61:	5b                   	pop    %ebx
80104a62:	5e                   	pop    %esi
80104a63:	5f                   	pop    %edi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104a76:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104a79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104a7f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104a82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret    
80104a8b:	90                   	nop
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104a90:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104a91:	31 d2                	xor    %edx,%edx
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104a96:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104a99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104a9c:	83 e8 08             	sub    $0x8,%eax
80104a9f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104aa0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104aa6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104aac:	77 1a                	ja     80104ac8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104aae:	8b 58 04             	mov    0x4(%eax),%ebx
80104ab1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ab4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ab7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ab9:	83 fa 0a             	cmp    $0xa,%edx
80104abc:	75 e2                	jne    80104aa0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104abe:	5b                   	pop    %ebx
80104abf:	5d                   	pop    %ebp
80104ac0:	c3                   	ret    
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104acb:	83 c1 28             	add    $0x28,%ecx
80104ace:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ad0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104ad6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104ad9:	39 c1                	cmp    %eax,%ecx
80104adb:	75 f3                	jne    80104ad0 <getcallerpcs+0x40>
}
80104add:	5b                   	pop    %ebx
80104ade:	5d                   	pop    %ebp
80104adf:	c3                   	ret    

80104ae0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	9c                   	pushf  
80104ae8:	5b                   	pop    %ebx
  asm volatile("cli");
80104ae9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104aea:	e8 31 f3 ff ff       	call   80103e20 <mycpu>
80104aef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104af5:	85 c0                	test   %eax,%eax
80104af7:	75 11                	jne    80104b0a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104af9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104aff:	e8 1c f3 ff ff       	call   80103e20 <mycpu>
80104b04:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b0a:	e8 11 f3 ff ff       	call   80103e20 <mycpu>
80104b0f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b16:	83 c4 04             	add    $0x4,%esp
80104b19:	5b                   	pop    %ebx
80104b1a:	5d                   	pop    %ebp
80104b1b:	c3                   	ret    
80104b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b20 <popcli>:

void
popcli(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b26:	9c                   	pushf  
80104b27:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b28:	f6 c4 02             	test   $0x2,%ah
80104b2b:	75 35                	jne    80104b62 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b2d:	e8 ee f2 ff ff       	call   80103e20 <mycpu>
80104b32:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b39:	78 34                	js     80104b6f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b3b:	e8 e0 f2 ff ff       	call   80103e20 <mycpu>
80104b40:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b46:	85 d2                	test   %edx,%edx
80104b48:	74 06                	je     80104b50 <popcli+0x30>
    sti();
}
80104b4a:	c9                   	leave  
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b50:	e8 cb f2 ff ff       	call   80103e20 <mycpu>
80104b55:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104b5b:	85 c0                	test   %eax,%eax
80104b5d:	74 eb                	je     80104b4a <popcli+0x2a>
  asm volatile("sti");
80104b5f:	fb                   	sti    
}
80104b60:	c9                   	leave  
80104b61:	c3                   	ret    
    panic("popcli - interruptible");
80104b62:	83 ec 0c             	sub    $0xc,%esp
80104b65:	68 4b 86 10 80       	push   $0x8010864b
80104b6a:	e8 21 b8 ff ff       	call   80100390 <panic>
    panic("popcli");
80104b6f:	83 ec 0c             	sub    $0xc,%esp
80104b72:	68 62 86 10 80       	push   $0x80108662
80104b77:	e8 14 b8 ff ff       	call   80100390 <panic>
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b80 <holding>:
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	53                   	push   %ebx
80104b85:	8b 75 08             	mov    0x8(%ebp),%esi
80104b88:	31 db                	xor    %ebx,%ebx
  pushcli();
80104b8a:	e8 51 ff ff ff       	call   80104ae0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104b8f:	8b 06                	mov    (%esi),%eax
80104b91:	85 c0                	test   %eax,%eax
80104b93:	74 10                	je     80104ba5 <holding+0x25>
80104b95:	8b 5e 08             	mov    0x8(%esi),%ebx
80104b98:	e8 83 f2 ff ff       	call   80103e20 <mycpu>
80104b9d:	39 c3                	cmp    %eax,%ebx
80104b9f:	0f 94 c3             	sete   %bl
80104ba2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104ba5:	e8 76 ff ff ff       	call   80104b20 <popcli>
}
80104baa:	89 d8                	mov    %ebx,%eax
80104bac:	5b                   	pop    %ebx
80104bad:	5e                   	pop    %esi
80104bae:	5d                   	pop    %ebp
80104baf:	c3                   	ret    

80104bb0 <acquire>:
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
80104bb3:	56                   	push   %esi
80104bb4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104bb5:	e8 26 ff ff ff       	call   80104ae0 <pushcli>
  if(holding(lk))
80104bba:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bbd:	83 ec 0c             	sub    $0xc,%esp
80104bc0:	53                   	push   %ebx
80104bc1:	e8 ba ff ff ff       	call   80104b80 <holding>
80104bc6:	83 c4 10             	add    $0x10,%esp
80104bc9:	85 c0                	test   %eax,%eax
80104bcb:	0f 85 83 00 00 00    	jne    80104c54 <acquire+0xa4>
80104bd1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104bd3:	ba 01 00 00 00       	mov    $0x1,%edx
80104bd8:	eb 09                	jmp    80104be3 <acquire+0x33>
80104bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104be0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104be3:	89 d0                	mov    %edx,%eax
80104be5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104be8:	85 c0                	test   %eax,%eax
80104bea:	75 f4                	jne    80104be0 <acquire+0x30>
  __sync_synchronize();
80104bec:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104bf4:	e8 27 f2 ff ff       	call   80103e20 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104bf9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104bfc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104bff:	89 e8                	mov    %ebp,%eax
80104c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c08:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c0e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c14:	77 1a                	ja     80104c30 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c16:	8b 48 04             	mov    0x4(%eax),%ecx
80104c19:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c1c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c1f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c21:	83 fe 0a             	cmp    $0xa,%esi
80104c24:	75 e2                	jne    80104c08 <acquire+0x58>
}
80104c26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c29:	5b                   	pop    %ebx
80104c2a:	5e                   	pop    %esi
80104c2b:	5d                   	pop    %ebp
80104c2c:	c3                   	ret    
80104c2d:	8d 76 00             	lea    0x0(%esi),%esi
80104c30:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c33:	83 c2 28             	add    $0x28,%edx
80104c36:	8d 76 00             	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c46:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c49:	39 d0                	cmp    %edx,%eax
80104c4b:	75 f3                	jne    80104c40 <acquire+0x90>
}
80104c4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c50:	5b                   	pop    %ebx
80104c51:	5e                   	pop    %esi
80104c52:	5d                   	pop    %ebp
80104c53:	c3                   	ret    
    panic("acquire");
80104c54:	83 ec 0c             	sub    $0xc,%esp
80104c57:	68 69 86 10 80       	push   $0x80108669
80104c5c:	e8 2f b7 ff ff       	call   80100390 <panic>
80104c61:	eb 0d                	jmp    80104c70 <release>
80104c63:	90                   	nop
80104c64:	90                   	nop
80104c65:	90                   	nop
80104c66:	90                   	nop
80104c67:	90                   	nop
80104c68:	90                   	nop
80104c69:	90                   	nop
80104c6a:	90                   	nop
80104c6b:	90                   	nop
80104c6c:	90                   	nop
80104c6d:	90                   	nop
80104c6e:	90                   	nop
80104c6f:	90                   	nop

80104c70 <release>:
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 10             	sub    $0x10,%esp
80104c77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104c7a:	53                   	push   %ebx
80104c7b:	e8 00 ff ff ff       	call   80104b80 <holding>
80104c80:	83 c4 10             	add    $0x10,%esp
80104c83:	85 c0                	test   %eax,%eax
80104c85:	74 22                	je     80104ca9 <release+0x39>
  lk->pcs[0] = 0;
80104c87:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104c8e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104c95:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104c9a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca3:	c9                   	leave  
  popcli();
80104ca4:	e9 77 fe ff ff       	jmp    80104b20 <popcli>
    panic("release");
80104ca9:	83 ec 0c             	sub    $0xc,%esp
80104cac:	68 71 86 10 80       	push   $0x80108671
80104cb1:	e8 da b6 ff ff       	call   80100390 <panic>
80104cb6:	66 90                	xchg   %ax,%ax
80104cb8:	66 90                	xchg   %ax,%ax
80104cba:	66 90                	xchg   %ax,%ax
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	53                   	push   %ebx
80104cc5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cc8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104ccb:	f6 c2 03             	test   $0x3,%dl
80104cce:	75 05                	jne    80104cd5 <memset+0x15>
80104cd0:	f6 c1 03             	test   $0x3,%cl
80104cd3:	74 13                	je     80104ce8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104cd5:	89 d7                	mov    %edx,%edi
80104cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cda:	fc                   	cld    
80104cdb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104cdd:	5b                   	pop    %ebx
80104cde:	89 d0                	mov    %edx,%eax
80104ce0:	5f                   	pop    %edi
80104ce1:	5d                   	pop    %ebp
80104ce2:	c3                   	ret    
80104ce3:	90                   	nop
80104ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ce8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104cec:	c1 e9 02             	shr    $0x2,%ecx
80104cef:	89 f8                	mov    %edi,%eax
80104cf1:	89 fb                	mov    %edi,%ebx
80104cf3:	c1 e0 18             	shl    $0x18,%eax
80104cf6:	c1 e3 10             	shl    $0x10,%ebx
80104cf9:	09 d8                	or     %ebx,%eax
80104cfb:	09 f8                	or     %edi,%eax
80104cfd:	c1 e7 08             	shl    $0x8,%edi
80104d00:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d02:	89 d7                	mov    %edx,%edi
80104d04:	fc                   	cld    
80104d05:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d07:	5b                   	pop    %ebx
80104d08:	89 d0                	mov    %edx,%eax
80104d0a:	5f                   	pop    %edi
80104d0b:	5d                   	pop    %ebp
80104d0c:	c3                   	ret    
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi

80104d10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	57                   	push   %edi
80104d14:	56                   	push   %esi
80104d15:	53                   	push   %ebx
80104d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d19:	8b 75 08             	mov    0x8(%ebp),%esi
80104d1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d1f:	85 db                	test   %ebx,%ebx
80104d21:	74 29                	je     80104d4c <memcmp+0x3c>
    if(*s1 != *s2)
80104d23:	0f b6 16             	movzbl (%esi),%edx
80104d26:	0f b6 0f             	movzbl (%edi),%ecx
80104d29:	38 d1                	cmp    %dl,%cl
80104d2b:	75 2b                	jne    80104d58 <memcmp+0x48>
80104d2d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d32:	eb 14                	jmp    80104d48 <memcmp+0x38>
80104d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d38:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d3c:	83 c0 01             	add    $0x1,%eax
80104d3f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104d44:	38 ca                	cmp    %cl,%dl
80104d46:	75 10                	jne    80104d58 <memcmp+0x48>
  while(n-- > 0){
80104d48:	39 d8                	cmp    %ebx,%eax
80104d4a:	75 ec                	jne    80104d38 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104d4c:	5b                   	pop    %ebx
  return 0;
80104d4d:	31 c0                	xor    %eax,%eax
}
80104d4f:	5e                   	pop    %esi
80104d50:	5f                   	pop    %edi
80104d51:	5d                   	pop    %ebp
80104d52:	c3                   	ret    
80104d53:	90                   	nop
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104d58:	0f b6 c2             	movzbl %dl,%eax
}
80104d5b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104d5c:	29 c8                	sub    %ecx,%eax
}
80104d5e:	5e                   	pop    %esi
80104d5f:	5f                   	pop    %edi
80104d60:	5d                   	pop    %ebp
80104d61:	c3                   	ret    
80104d62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
80104d75:	8b 45 08             	mov    0x8(%ebp),%eax
80104d78:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104d7b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104d7e:	39 c3                	cmp    %eax,%ebx
80104d80:	73 26                	jae    80104da8 <memmove+0x38>
80104d82:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104d85:	39 c8                	cmp    %ecx,%eax
80104d87:	73 1f                	jae    80104da8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104d89:	85 f6                	test   %esi,%esi
80104d8b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104d8e:	74 0f                	je     80104d9f <memmove+0x2f>
      *--d = *--s;
80104d90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104d94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104d97:	83 ea 01             	sub    $0x1,%edx
80104d9a:	83 fa ff             	cmp    $0xffffffff,%edx
80104d9d:	75 f1                	jne    80104d90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104d9f:	5b                   	pop    %ebx
80104da0:	5e                   	pop    %esi
80104da1:	5d                   	pop    %ebp
80104da2:	c3                   	ret    
80104da3:	90                   	nop
80104da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104da8:	31 d2                	xor    %edx,%edx
80104daa:	85 f6                	test   %esi,%esi
80104dac:	74 f1                	je     80104d9f <memmove+0x2f>
80104dae:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104db0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104db4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104db7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104dba:	39 d6                	cmp    %edx,%esi
80104dbc:	75 f2                	jne    80104db0 <memmove+0x40>
}
80104dbe:	5b                   	pop    %ebx
80104dbf:	5e                   	pop    %esi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104dd3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104dd4:	eb 9a                	jmp    80104d70 <memmove>
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	57                   	push   %edi
80104de4:	56                   	push   %esi
80104de5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104de8:	53                   	push   %ebx
80104de9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dec:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104def:	85 ff                	test   %edi,%edi
80104df1:	74 2f                	je     80104e22 <strncmp+0x42>
80104df3:	0f b6 01             	movzbl (%ecx),%eax
80104df6:	0f b6 1e             	movzbl (%esi),%ebx
80104df9:	84 c0                	test   %al,%al
80104dfb:	74 37                	je     80104e34 <strncmp+0x54>
80104dfd:	38 c3                	cmp    %al,%bl
80104dff:	75 33                	jne    80104e34 <strncmp+0x54>
80104e01:	01 f7                	add    %esi,%edi
80104e03:	eb 13                	jmp    80104e18 <strncmp+0x38>
80104e05:	8d 76 00             	lea    0x0(%esi),%esi
80104e08:	0f b6 01             	movzbl (%ecx),%eax
80104e0b:	84 c0                	test   %al,%al
80104e0d:	74 21                	je     80104e30 <strncmp+0x50>
80104e0f:	0f b6 1a             	movzbl (%edx),%ebx
80104e12:	89 d6                	mov    %edx,%esi
80104e14:	38 d8                	cmp    %bl,%al
80104e16:	75 1c                	jne    80104e34 <strncmp+0x54>
    n--, p++, q++;
80104e18:	8d 56 01             	lea    0x1(%esi),%edx
80104e1b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e1e:	39 fa                	cmp    %edi,%edx
80104e20:	75 e6                	jne    80104e08 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e22:	5b                   	pop    %ebx
    return 0;
80104e23:	31 c0                	xor    %eax,%eax
}
80104e25:	5e                   	pop    %esi
80104e26:	5f                   	pop    %edi
80104e27:	5d                   	pop    %ebp
80104e28:	c3                   	ret    
80104e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e30:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e34:	29 d8                	sub    %ebx,%eax
}
80104e36:	5b                   	pop    %ebx
80104e37:	5e                   	pop    %esi
80104e38:	5f                   	pop    %edi
80104e39:	5d                   	pop    %ebp
80104e3a:	c3                   	ret    
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 45 08             	mov    0x8(%ebp),%eax
80104e48:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104e4e:	89 c2                	mov    %eax,%edx
80104e50:	eb 19                	jmp    80104e6b <strncpy+0x2b>
80104e52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e58:	83 c3 01             	add    $0x1,%ebx
80104e5b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104e5f:	83 c2 01             	add    $0x1,%edx
80104e62:	84 c9                	test   %cl,%cl
80104e64:	88 4a ff             	mov    %cl,-0x1(%edx)
80104e67:	74 09                	je     80104e72 <strncpy+0x32>
80104e69:	89 f1                	mov    %esi,%ecx
80104e6b:	85 c9                	test   %ecx,%ecx
80104e6d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104e70:	7f e6                	jg     80104e58 <strncpy+0x18>
    ;
  while(n-- > 0)
80104e72:	31 c9                	xor    %ecx,%ecx
80104e74:	85 f6                	test   %esi,%esi
80104e76:	7e 17                	jle    80104e8f <strncpy+0x4f>
80104e78:	90                   	nop
80104e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104e80:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104e84:	89 f3                	mov    %esi,%ebx
80104e86:	83 c1 01             	add    $0x1,%ecx
80104e89:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104e8b:	85 db                	test   %ebx,%ebx
80104e8d:	7f f1                	jg     80104e80 <strncpy+0x40>
  return os;
}
80104e8f:	5b                   	pop    %ebx
80104e90:	5e                   	pop    %esi
80104e91:	5d                   	pop    %ebp
80104e92:	c3                   	ret    
80104e93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ea0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ea8:	8b 45 08             	mov    0x8(%ebp),%eax
80104eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104eae:	85 c9                	test   %ecx,%ecx
80104eb0:	7e 26                	jle    80104ed8 <safestrcpy+0x38>
80104eb2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104eb6:	89 c1                	mov    %eax,%ecx
80104eb8:	eb 17                	jmp    80104ed1 <safestrcpy+0x31>
80104eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ec0:	83 c2 01             	add    $0x1,%edx
80104ec3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ec7:	83 c1 01             	add    $0x1,%ecx
80104eca:	84 db                	test   %bl,%bl
80104ecc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104ecf:	74 04                	je     80104ed5 <safestrcpy+0x35>
80104ed1:	39 f2                	cmp    %esi,%edx
80104ed3:	75 eb                	jne    80104ec0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ed5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ed8:	5b                   	pop    %ebx
80104ed9:	5e                   	pop    %esi
80104eda:	5d                   	pop    %ebp
80104edb:	c3                   	ret    
80104edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <strlen>:

int
strlen(const char *s)
{
80104ee0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104ee1:	31 c0                	xor    %eax,%eax
{
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104ee8:	80 3a 00             	cmpb   $0x0,(%edx)
80104eeb:	74 0c                	je     80104ef9 <strlen+0x19>
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
80104ef0:	83 c0 01             	add    $0x1,%eax
80104ef3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ef7:	75 f7                	jne    80104ef0 <strlen+0x10>
    ;
  return n;
}
80104ef9:	5d                   	pop    %ebp
80104efa:	c3                   	ret    

80104efb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104efb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104eff:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f03:	55                   	push   %ebp
  pushl %ebx
80104f04:	53                   	push   %ebx
  pushl %esi
80104f05:	56                   	push   %esi
  pushl %edi
80104f06:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f07:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f09:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f0b:	5f                   	pop    %edi
  popl %esi
80104f0c:	5e                   	pop    %esi
  popl %ebx
80104f0d:	5b                   	pop    %ebx
  popl %ebp
80104f0e:	5d                   	pop    %ebp
  ret
80104f0f:	c3                   	ret    

80104f10 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	53                   	push   %ebx
80104f14:	83 ec 04             	sub    $0x4,%esp
80104f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f1a:	e8 a1 ef ff ff       	call   80103ec0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f1f:	8b 00                	mov    (%eax),%eax
80104f21:	39 d8                	cmp    %ebx,%eax
80104f23:	76 1b                	jbe    80104f40 <fetchint+0x30>
80104f25:	8d 53 04             	lea    0x4(%ebx),%edx
80104f28:	39 d0                	cmp    %edx,%eax
80104f2a:	72 14                	jb     80104f40 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f2f:	8b 13                	mov    (%ebx),%edx
80104f31:	89 10                	mov    %edx,(%eax)
  return 0;
80104f33:	31 c0                	xor    %eax,%eax
}
80104f35:	83 c4 04             	add    $0x4,%esp
80104f38:	5b                   	pop    %ebx
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	90                   	nop
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f45:	eb ee                	jmp    80104f35 <fetchint+0x25>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	53                   	push   %ebx
80104f54:	83 ec 04             	sub    $0x4,%esp
80104f57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104f5a:	e8 61 ef ff ff       	call   80103ec0 <myproc>

  if(addr >= curproc->sz)
80104f5f:	39 18                	cmp    %ebx,(%eax)
80104f61:	76 29                	jbe    80104f8c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104f66:	89 da                	mov    %ebx,%edx
80104f68:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104f6a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104f6c:	39 c3                	cmp    %eax,%ebx
80104f6e:	73 1c                	jae    80104f8c <fetchstr+0x3c>
    if(*s == 0)
80104f70:	80 3b 00             	cmpb   $0x0,(%ebx)
80104f73:	75 10                	jne    80104f85 <fetchstr+0x35>
80104f75:	eb 39                	jmp    80104fb0 <fetchstr+0x60>
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104f80:	80 3a 00             	cmpb   $0x0,(%edx)
80104f83:	74 1b                	je     80104fa0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104f85:	83 c2 01             	add    $0x1,%edx
80104f88:	39 d0                	cmp    %edx,%eax
80104f8a:	77 f4                	ja     80104f80 <fetchstr+0x30>
    return -1;
80104f8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104f91:	83 c4 04             	add    $0x4,%esp
80104f94:	5b                   	pop    %ebx
80104f95:	5d                   	pop    %ebp
80104f96:	c3                   	ret    
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fa0:	83 c4 04             	add    $0x4,%esp
80104fa3:	89 d0                	mov    %edx,%eax
80104fa5:	29 d8                	sub    %ebx,%eax
80104fa7:	5b                   	pop    %ebx
80104fa8:	5d                   	pop    %ebp
80104fa9:	c3                   	ret    
80104faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104fb0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104fb2:	eb dd                	jmp    80104f91 <fetchstr+0x41>
80104fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104fc0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fc5:	e8 f6 ee ff ff       	call   80103ec0 <myproc>
80104fca:	8b 40 18             	mov    0x18(%eax),%eax
80104fcd:	8b 55 08             	mov    0x8(%ebp),%edx
80104fd0:	8b 40 44             	mov    0x44(%eax),%eax
80104fd3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104fd6:	e8 e5 ee ff ff       	call   80103ec0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fdb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104fdd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104fe0:	39 c6                	cmp    %eax,%esi
80104fe2:	73 1c                	jae    80105000 <argint+0x40>
80104fe4:	8d 53 08             	lea    0x8(%ebx),%edx
80104fe7:	39 d0                	cmp    %edx,%eax
80104fe9:	72 15                	jb     80105000 <argint+0x40>
  *ip = *(int*)(addr);
80104feb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fee:	8b 53 04             	mov    0x4(%ebx),%edx
80104ff1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ff3:	31 c0                	xor    %eax,%eax
}
80104ff5:	5b                   	pop    %ebx
80104ff6:	5e                   	pop    %esi
80104ff7:	5d                   	pop    %ebp
80104ff8:	c3                   	ret    
80104ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105005:	eb ee                	jmp    80104ff5 <argint+0x35>
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105010 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	83 ec 10             	sub    $0x10,%esp
80105018:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010501b:	e8 a0 ee ff ff       	call   80103ec0 <myproc>
80105020:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105022:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105025:	83 ec 08             	sub    $0x8,%esp
80105028:	50                   	push   %eax
80105029:	ff 75 08             	pushl  0x8(%ebp)
8010502c:	e8 8f ff ff ff       	call   80104fc0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105031:	83 c4 10             	add    $0x10,%esp
80105034:	85 c0                	test   %eax,%eax
80105036:	78 28                	js     80105060 <argptr+0x50>
80105038:	85 db                	test   %ebx,%ebx
8010503a:	78 24                	js     80105060 <argptr+0x50>
8010503c:	8b 16                	mov    (%esi),%edx
8010503e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105041:	39 c2                	cmp    %eax,%edx
80105043:	76 1b                	jbe    80105060 <argptr+0x50>
80105045:	01 c3                	add    %eax,%ebx
80105047:	39 da                	cmp    %ebx,%edx
80105049:	72 15                	jb     80105060 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010504b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010504e:	89 02                	mov    %eax,(%edx)
  return 0;
80105050:	31 c0                	xor    %eax,%eax
}
80105052:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5d                   	pop    %ebp
80105058:	c3                   	ret    
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105065:	eb eb                	jmp    80105052 <argptr+0x42>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105076:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105079:	50                   	push   %eax
8010507a:	ff 75 08             	pushl  0x8(%ebp)
8010507d:	e8 3e ff ff ff       	call   80104fc0 <argint>
80105082:	83 c4 10             	add    $0x10,%esp
80105085:	85 c0                	test   %eax,%eax
80105087:	78 17                	js     801050a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105089:	83 ec 08             	sub    $0x8,%esp
8010508c:	ff 75 0c             	pushl  0xc(%ebp)
8010508f:	ff 75 f4             	pushl  -0xc(%ebp)
80105092:	e8 b9 fe ff ff       	call   80104f50 <fetchstr>
80105097:	83 c4 10             	add    $0x10,%esp
}
8010509a:	c9                   	leave  
8010509b:	c3                   	ret    
8010509c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050a5:	c9                   	leave  
801050a6:	c3                   	ret    
801050a7:	89 f6                	mov    %esi,%esi
801050a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050b0 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	53                   	push   %ebx
801050b4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801050b7:	e8 04 ee ff ff       	call   80103ec0 <myproc>
801050bc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801050be:	8b 40 18             	mov    0x18(%eax),%eax
801050c1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801050c4:	8d 50 ff             	lea    -0x1(%eax),%edx
801050c7:	83 fa 16             	cmp    $0x16,%edx
801050ca:	77 1c                	ja     801050e8 <syscall+0x38>
801050cc:	8b 14 85 a0 86 10 80 	mov    -0x7fef7960(,%eax,4),%edx
801050d3:	85 d2                	test   %edx,%edx
801050d5:	74 11                	je     801050e8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801050d7:	ff d2                	call   *%edx
801050d9:	8b 53 18             	mov    0x18(%ebx),%edx
801050dc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801050df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050e2:	c9                   	leave  
801050e3:	c3                   	ret    
801050e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801050e8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801050e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801050ec:	50                   	push   %eax
801050ed:	ff 73 10             	pushl  0x10(%ebx)
801050f0:	68 79 86 10 80       	push   $0x80108679
801050f5:	e8 66 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801050fa:	8b 43 18             	mov    0x18(%ebx),%eax
801050fd:	83 c4 10             	add    $0x10,%esp
80105100:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105107:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010510a:	c9                   	leave  
8010510b:	c3                   	ret    
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
80105115:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105117:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010511a:	89 d6                	mov    %edx,%esi
8010511c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010511f:	50                   	push   %eax
80105120:	6a 00                	push   $0x0
80105122:	e8 99 fe ff ff       	call   80104fc0 <argint>
80105127:	83 c4 10             	add    $0x10,%esp
8010512a:	85 c0                	test   %eax,%eax
8010512c:	78 2a                	js     80105158 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010512e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105132:	77 24                	ja     80105158 <argfd.constprop.0+0x48>
80105134:	e8 87 ed ff ff       	call   80103ec0 <myproc>
80105139:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010513c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105140:	85 c0                	test   %eax,%eax
80105142:	74 14                	je     80105158 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105144:	85 db                	test   %ebx,%ebx
80105146:	74 02                	je     8010514a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105148:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010514a:	89 06                	mov    %eax,(%esi)
  return 0;
8010514c:	31 c0                	xor    %eax,%eax
}
8010514e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105151:	5b                   	pop    %ebx
80105152:	5e                   	pop    %esi
80105153:	5d                   	pop    %ebp
80105154:	c3                   	ret    
80105155:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010515d:	eb ef                	jmp    8010514e <argfd.constprop.0+0x3e>
8010515f:	90                   	nop

80105160 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105160:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105161:	31 c0                	xor    %eax,%eax
{
80105163:	89 e5                	mov    %esp,%ebp
80105165:	56                   	push   %esi
80105166:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105167:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010516a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010516d:	e8 9e ff ff ff       	call   80105110 <argfd.constprop.0>
80105172:	85 c0                	test   %eax,%eax
80105174:	78 42                	js     801051b8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105176:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105179:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010517b:	e8 40 ed ff ff       	call   80103ec0 <myproc>
80105180:	eb 0e                	jmp    80105190 <sys_dup+0x30>
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105188:	83 c3 01             	add    $0x1,%ebx
8010518b:	83 fb 10             	cmp    $0x10,%ebx
8010518e:	74 28                	je     801051b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105190:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105194:	85 d2                	test   %edx,%edx
80105196:	75 f0                	jne    80105188 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105198:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010519c:	83 ec 0c             	sub    $0xc,%esp
8010519f:	ff 75 f4             	pushl  -0xc(%ebp)
801051a2:	e8 89 bc ff ff       	call   80100e30 <filedup>
  return fd;
801051a7:	83 c4 10             	add    $0x10,%esp
}
801051aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051ad:	89 d8                	mov    %ebx,%eax
801051af:	5b                   	pop    %ebx
801051b0:	5e                   	pop    %esi
801051b1:	5d                   	pop    %ebp
801051b2:	c3                   	ret    
801051b3:	90                   	nop
801051b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801051bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801051c0:	89 d8                	mov    %ebx,%eax
801051c2:	5b                   	pop    %ebx
801051c3:	5e                   	pop    %esi
801051c4:	5d                   	pop    %ebp
801051c5:	c3                   	ret    
801051c6:	8d 76 00             	lea    0x0(%esi),%esi
801051c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801051d0 <sys_read>:

int
sys_read(void)
{
801051d0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d1:	31 c0                	xor    %eax,%eax
{
801051d3:	89 e5                	mov    %esp,%ebp
801051d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801051d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801051db:	e8 30 ff ff ff       	call   80105110 <argfd.constprop.0>
801051e0:	85 c0                	test   %eax,%eax
801051e2:	78 4c                	js     80105230 <sys_read+0x60>
801051e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e7:	83 ec 08             	sub    $0x8,%esp
801051ea:	50                   	push   %eax
801051eb:	6a 02                	push   $0x2
801051ed:	e8 ce fd ff ff       	call   80104fc0 <argint>
801051f2:	83 c4 10             	add    $0x10,%esp
801051f5:	85 c0                	test   %eax,%eax
801051f7:	78 37                	js     80105230 <sys_read+0x60>
801051f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fc:	83 ec 04             	sub    $0x4,%esp
801051ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105202:	50                   	push   %eax
80105203:	6a 01                	push   $0x1
80105205:	e8 06 fe ff ff       	call   80105010 <argptr>
8010520a:	83 c4 10             	add    $0x10,%esp
8010520d:	85 c0                	test   %eax,%eax
8010520f:	78 1f                	js     80105230 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105211:	83 ec 04             	sub    $0x4,%esp
80105214:	ff 75 f0             	pushl  -0x10(%ebp)
80105217:	ff 75 f4             	pushl  -0xc(%ebp)
8010521a:	ff 75 ec             	pushl  -0x14(%ebp)
8010521d:	e8 7e bd ff ff       	call   80100fa0 <fileread>
80105222:	83 c4 10             	add    $0x10,%esp
}
80105225:	c9                   	leave  
80105226:	c3                   	ret    
80105227:	89 f6                	mov    %esi,%esi
80105229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105240 <sys_write>:

int
sys_write(void)
{
80105240:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105241:	31 c0                	xor    %eax,%eax
{
80105243:	89 e5                	mov    %esp,%ebp
80105245:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105248:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010524b:	e8 c0 fe ff ff       	call   80105110 <argfd.constprop.0>
80105250:	85 c0                	test   %eax,%eax
80105252:	78 4c                	js     801052a0 <sys_write+0x60>
80105254:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105257:	83 ec 08             	sub    $0x8,%esp
8010525a:	50                   	push   %eax
8010525b:	6a 02                	push   $0x2
8010525d:	e8 5e fd ff ff       	call   80104fc0 <argint>
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	85 c0                	test   %eax,%eax
80105267:	78 37                	js     801052a0 <sys_write+0x60>
80105269:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010526c:	83 ec 04             	sub    $0x4,%esp
8010526f:	ff 75 f0             	pushl  -0x10(%ebp)
80105272:	50                   	push   %eax
80105273:	6a 01                	push   $0x1
80105275:	e8 96 fd ff ff       	call   80105010 <argptr>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	78 1f                	js     801052a0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105281:	83 ec 04             	sub    $0x4,%esp
80105284:	ff 75 f0             	pushl  -0x10(%ebp)
80105287:	ff 75 f4             	pushl  -0xc(%ebp)
8010528a:	ff 75 ec             	pushl  -0x14(%ebp)
8010528d:	e8 9e bd ff ff       	call   80101030 <filewrite>
80105292:	83 c4 10             	add    $0x10,%esp
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a5:	c9                   	leave  
801052a6:	c3                   	ret    
801052a7:	89 f6                	mov    %esi,%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052b0 <sys_close>:

int
sys_close(void)
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801052b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801052b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052bc:	e8 4f fe ff ff       	call   80105110 <argfd.constprop.0>
801052c1:	85 c0                	test   %eax,%eax
801052c3:	78 2b                	js     801052f0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801052c5:	e8 f6 eb ff ff       	call   80103ec0 <myproc>
801052ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801052cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801052d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801052d7:	00 
  fileclose(f);
801052d8:	ff 75 f4             	pushl  -0xc(%ebp)
801052db:	e8 a0 bb ff ff       	call   80100e80 <fileclose>
  return 0;
801052e0:	83 c4 10             	add    $0x10,%esp
801052e3:	31 c0                	xor    %eax,%eax
}
801052e5:	c9                   	leave  
801052e6:	c3                   	ret    
801052e7:	89 f6                	mov    %esi,%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801052f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052f5:	c9                   	leave  
801052f6:	c3                   	ret    
801052f7:	89 f6                	mov    %esi,%esi
801052f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105300 <sys_fstat>:

int
sys_fstat(void)
{
80105300:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105301:	31 c0                	xor    %eax,%eax
{
80105303:	89 e5                	mov    %esp,%ebp
80105305:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105308:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010530b:	e8 00 fe ff ff       	call   80105110 <argfd.constprop.0>
80105310:	85 c0                	test   %eax,%eax
80105312:	78 2c                	js     80105340 <sys_fstat+0x40>
80105314:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105317:	83 ec 04             	sub    $0x4,%esp
8010531a:	6a 14                	push   $0x14
8010531c:	50                   	push   %eax
8010531d:	6a 01                	push   $0x1
8010531f:	e8 ec fc ff ff       	call   80105010 <argptr>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	78 15                	js     80105340 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010532b:	83 ec 08             	sub    $0x8,%esp
8010532e:	ff 75 f4             	pushl  -0xc(%ebp)
80105331:	ff 75 f0             	pushl  -0x10(%ebp)
80105334:	e8 17 bc ff ff       	call   80100f50 <filestat>
80105339:	83 c4 10             	add    $0x10,%esp
}
8010533c:	c9                   	leave  
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax
    return -1;
80105340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105345:	c9                   	leave  
80105346:	c3                   	ret    
80105347:	89 f6                	mov    %esi,%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105356:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105359:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010535c:	50                   	push   %eax
8010535d:	6a 00                	push   $0x0
8010535f:	e8 0c fd ff ff       	call   80105070 <argstr>
80105364:	83 c4 10             	add    $0x10,%esp
80105367:	85 c0                	test   %eax,%eax
80105369:	0f 88 fb 00 00 00    	js     8010546a <sys_link+0x11a>
8010536f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105372:	83 ec 08             	sub    $0x8,%esp
80105375:	50                   	push   %eax
80105376:	6a 01                	push   $0x1
80105378:	e8 f3 fc ff ff       	call   80105070 <argstr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	0f 88 e2 00 00 00    	js     8010546a <sys_link+0x11a>
    return -1;

  begin_op();
80105388:	e8 53 de ff ff       	call   801031e0 <begin_op>
  if((ip = namei(old)) == 0){
8010538d:	83 ec 0c             	sub    $0xc,%esp
80105390:	ff 75 d4             	pushl  -0x2c(%ebp)
80105393:	e8 88 cb ff ff       	call   80101f20 <namei>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	89 c3                	mov    %eax,%ebx
8010539f:	0f 84 ea 00 00 00    	je     8010548f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801053a5:	83 ec 0c             	sub    $0xc,%esp
801053a8:	50                   	push   %eax
801053a9:	e8 12 c3 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053b6:	0f 84 bb 00 00 00    	je     80105477 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801053bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801053c1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801053c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801053c7:	53                   	push   %ebx
801053c8:	e8 43 c2 ff ff       	call   80101610 <iupdate>
  iunlock(ip);
801053cd:	89 1c 24             	mov    %ebx,(%esp)
801053d0:	e8 cb c3 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801053d5:	58                   	pop    %eax
801053d6:	5a                   	pop    %edx
801053d7:	57                   	push   %edi
801053d8:	ff 75 d0             	pushl  -0x30(%ebp)
801053db:	e8 60 cb ff ff       	call   80101f40 <nameiparent>
801053e0:	83 c4 10             	add    $0x10,%esp
801053e3:	85 c0                	test   %eax,%eax
801053e5:	89 c6                	mov    %eax,%esi
801053e7:	74 5b                	je     80105444 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801053e9:	83 ec 0c             	sub    $0xc,%esp
801053ec:	50                   	push   %eax
801053ed:	e8 ce c2 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	8b 03                	mov    (%ebx),%eax
801053f7:	39 06                	cmp    %eax,(%esi)
801053f9:	75 3d                	jne    80105438 <sys_link+0xe8>
801053fb:	83 ec 04             	sub    $0x4,%esp
801053fe:	ff 73 04             	pushl  0x4(%ebx)
80105401:	57                   	push   %edi
80105402:	56                   	push   %esi
80105403:	e8 58 ca ff ff       	call   80101e60 <dirlink>
80105408:	83 c4 10             	add    $0x10,%esp
8010540b:	85 c0                	test   %eax,%eax
8010540d:	78 29                	js     80105438 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	56                   	push   %esi
80105413:	e8 38 c5 ff ff       	call   80101950 <iunlockput>
  iput(ip);
80105418:	89 1c 24             	mov    %ebx,(%esp)
8010541b:	e8 d0 c3 ff ff       	call   801017f0 <iput>

  end_op();
80105420:	e8 2b de ff ff       	call   80103250 <end_op>

  return 0;
80105425:	83 c4 10             	add    $0x10,%esp
80105428:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010542a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010542d:	5b                   	pop    %ebx
8010542e:	5e                   	pop    %esi
8010542f:	5f                   	pop    %edi
80105430:	5d                   	pop    %ebp
80105431:	c3                   	ret    
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	56                   	push   %esi
8010543c:	e8 0f c5 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105441:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105444:	83 ec 0c             	sub    $0xc,%esp
80105447:	53                   	push   %ebx
80105448:	e8 73 c2 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
8010544d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105452:	89 1c 24             	mov    %ebx,(%esp)
80105455:	e8 b6 c1 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
8010545a:	89 1c 24             	mov    %ebx,(%esp)
8010545d:	e8 ee c4 ff ff       	call   80101950 <iunlockput>
  end_op();
80105462:	e8 e9 dd ff ff       	call   80103250 <end_op>
  return -1;
80105467:	83 c4 10             	add    $0x10,%esp
}
8010546a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010546d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105472:	5b                   	pop    %ebx
80105473:	5e                   	pop    %esi
80105474:	5f                   	pop    %edi
80105475:	5d                   	pop    %ebp
80105476:	c3                   	ret    
    iunlockput(ip);
80105477:	83 ec 0c             	sub    $0xc,%esp
8010547a:	53                   	push   %ebx
8010547b:	e8 d0 c4 ff ff       	call   80101950 <iunlockput>
    end_op();
80105480:	e8 cb dd ff ff       	call   80103250 <end_op>
    return -1;
80105485:	83 c4 10             	add    $0x10,%esp
80105488:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010548d:	eb 9b                	jmp    8010542a <sys_link+0xda>
    end_op();
8010548f:	e8 bc dd ff ff       	call   80103250 <end_op>
    return -1;
80105494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105499:	eb 8f                	jmp    8010542a <sys_link+0xda>
8010549b:	90                   	nop
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054a0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801054a0:	55                   	push   %ebp
801054a1:	89 e5                	mov    %esp,%ebp
801054a3:	57                   	push   %edi
801054a4:	56                   	push   %esi
801054a5:	53                   	push   %ebx
801054a6:	83 ec 1c             	sub    $0x1c,%esp
801054a9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054ac:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801054b0:	76 3e                	jbe    801054f0 <isdirempty+0x50>
801054b2:	bb 20 00 00 00       	mov    $0x20,%ebx
801054b7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801054ba:	eb 0c                	jmp    801054c8 <isdirempty+0x28>
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054c0:	83 c3 10             	add    $0x10,%ebx
801054c3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801054c6:	73 28                	jae    801054f0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054c8:	6a 10                	push   $0x10
801054ca:	53                   	push   %ebx
801054cb:	57                   	push   %edi
801054cc:	56                   	push   %esi
801054cd:	e8 ce c4 ff ff       	call   801019a0 <readi>
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	83 f8 10             	cmp    $0x10,%eax
801054d8:	75 23                	jne    801054fd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801054da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054df:	74 df                	je     801054c0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801054e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801054e4:	31 c0                	xor    %eax,%eax
}
801054e6:	5b                   	pop    %ebx
801054e7:	5e                   	pop    %esi
801054e8:	5f                   	pop    %edi
801054e9:	5d                   	pop    %ebp
801054ea:	c3                   	ret    
801054eb:	90                   	nop
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801054f3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801054f8:	5b                   	pop    %ebx
801054f9:	5e                   	pop    %esi
801054fa:	5f                   	pop    %edi
801054fb:	5d                   	pop    %ebp
801054fc:	c3                   	ret    
      panic("isdirempty: readi");
801054fd:	83 ec 0c             	sub    $0xc,%esp
80105500:	68 00 87 10 80       	push   $0x80108700
80105505:	e8 86 ae ff ff       	call   80100390 <panic>
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105510 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	57                   	push   %edi
80105514:	56                   	push   %esi
80105515:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105516:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105519:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010551c:	50                   	push   %eax
8010551d:	6a 00                	push   $0x0
8010551f:	e8 4c fb ff ff       	call   80105070 <argstr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	0f 88 51 01 00 00    	js     80105680 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010552f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105532:	e8 a9 dc ff ff       	call   801031e0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105537:	83 ec 08             	sub    $0x8,%esp
8010553a:	53                   	push   %ebx
8010553b:	ff 75 c0             	pushl  -0x40(%ebp)
8010553e:	e8 fd c9 ff ff       	call   80101f40 <nameiparent>
80105543:	83 c4 10             	add    $0x10,%esp
80105546:	85 c0                	test   %eax,%eax
80105548:	89 c6                	mov    %eax,%esi
8010554a:	0f 84 37 01 00 00    	je     80105687 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	50                   	push   %eax
80105554:	e8 67 c1 ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105559:	58                   	pop    %eax
8010555a:	5a                   	pop    %edx
8010555b:	68 9d 80 10 80       	push   $0x8010809d
80105560:	53                   	push   %ebx
80105561:	e8 6a c6 ff ff       	call   80101bd0 <namecmp>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	0f 84 d7 00 00 00    	je     80105648 <sys_unlink+0x138>
80105571:	83 ec 08             	sub    $0x8,%esp
80105574:	68 9c 80 10 80       	push   $0x8010809c
80105579:	53                   	push   %ebx
8010557a:	e8 51 c6 ff ff       	call   80101bd0 <namecmp>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	85 c0                	test   %eax,%eax
80105584:	0f 84 be 00 00 00    	je     80105648 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010558a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010558d:	83 ec 04             	sub    $0x4,%esp
80105590:	50                   	push   %eax
80105591:	53                   	push   %ebx
80105592:	56                   	push   %esi
80105593:	e8 58 c6 ff ff       	call   80101bf0 <dirlookup>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	89 c3                	mov    %eax,%ebx
8010559f:	0f 84 a3 00 00 00    	je     80105648 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801055a5:	83 ec 0c             	sub    $0xc,%esp
801055a8:	50                   	push   %eax
801055a9:	e8 12 c1 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801055b6:	0f 8e e4 00 00 00    	jle    801056a0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801055bc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055c1:	74 65                	je     80105628 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801055c3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801055c6:	83 ec 04             	sub    $0x4,%esp
801055c9:	6a 10                	push   $0x10
801055cb:	6a 00                	push   $0x0
801055cd:	57                   	push   %edi
801055ce:	e8 ed f6 ff ff       	call   80104cc0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801055d3:	6a 10                	push   $0x10
801055d5:	ff 75 c4             	pushl  -0x3c(%ebp)
801055d8:	57                   	push   %edi
801055d9:	56                   	push   %esi
801055da:	e8 c1 c4 ff ff       	call   80101aa0 <writei>
801055df:	83 c4 20             	add    $0x20,%esp
801055e2:	83 f8 10             	cmp    $0x10,%eax
801055e5:	0f 85 a8 00 00 00    	jne    80105693 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801055eb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055f0:	74 6e                	je     80105660 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801055f2:	83 ec 0c             	sub    $0xc,%esp
801055f5:	56                   	push   %esi
801055f6:	e8 55 c3 ff ff       	call   80101950 <iunlockput>

  ip->nlink--;
801055fb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105600:	89 1c 24             	mov    %ebx,(%esp)
80105603:	e8 08 c0 ff ff       	call   80101610 <iupdate>
  iunlockput(ip);
80105608:	89 1c 24             	mov    %ebx,(%esp)
8010560b:	e8 40 c3 ff ff       	call   80101950 <iunlockput>

  end_op();
80105610:	e8 3b dc ff ff       	call   80103250 <end_op>

  return 0;
80105615:	83 c4 10             	add    $0x10,%esp
80105618:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010561a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010561d:	5b                   	pop    %ebx
8010561e:	5e                   	pop    %esi
8010561f:	5f                   	pop    %edi
80105620:	5d                   	pop    %ebp
80105621:	c3                   	ret    
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105628:	83 ec 0c             	sub    $0xc,%esp
8010562b:	53                   	push   %ebx
8010562c:	e8 6f fe ff ff       	call   801054a0 <isdirempty>
80105631:	83 c4 10             	add    $0x10,%esp
80105634:	85 c0                	test   %eax,%eax
80105636:	75 8b                	jne    801055c3 <sys_unlink+0xb3>
    iunlockput(ip);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	53                   	push   %ebx
8010563c:	e8 0f c3 ff ff       	call   80101950 <iunlockput>
    goto bad;
80105641:	83 c4 10             	add    $0x10,%esp
80105644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105648:	83 ec 0c             	sub    $0xc,%esp
8010564b:	56                   	push   %esi
8010564c:	e8 ff c2 ff ff       	call   80101950 <iunlockput>
  end_op();
80105651:	e8 fa db ff ff       	call   80103250 <end_op>
  return -1;
80105656:	83 c4 10             	add    $0x10,%esp
80105659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565e:	eb ba                	jmp    8010561a <sys_unlink+0x10a>
    dp->nlink--;
80105660:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	56                   	push   %esi
80105669:	e8 a2 bf ff ff       	call   80101610 <iupdate>
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	e9 7c ff ff ff       	jmp    801055f2 <sys_unlink+0xe2>
80105676:	8d 76 00             	lea    0x0(%esi),%esi
80105679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105685:	eb 93                	jmp    8010561a <sys_unlink+0x10a>
    end_op();
80105687:	e8 c4 db ff ff       	call   80103250 <end_op>
    return -1;
8010568c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105691:	eb 87                	jmp    8010561a <sys_unlink+0x10a>
    panic("unlink: writei");
80105693:	83 ec 0c             	sub    $0xc,%esp
80105696:	68 b1 80 10 80       	push   $0x801080b1
8010569b:	e8 f0 ac ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	68 9f 80 10 80       	push   $0x8010809f
801056a8:	e8 e3 ac ff ff       	call   80100390 <panic>
801056ad:	8d 76 00             	lea    0x0(%esi),%esi

801056b0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
801056b5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801056b6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801056b9:	83 ec 34             	sub    $0x34,%esp
801056bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801056bf:	8b 55 10             	mov    0x10(%ebp),%edx
801056c2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801056c5:	56                   	push   %esi
801056c6:	ff 75 08             	pushl  0x8(%ebp)
{
801056c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801056cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
801056cf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801056d2:	e8 69 c8 ff ff       	call   80101f40 <nameiparent>
801056d7:	83 c4 10             	add    $0x10,%esp
801056da:	85 c0                	test   %eax,%eax
801056dc:	0f 84 4e 01 00 00    	je     80105830 <create+0x180>
    return 0;
  ilock(dp);
801056e2:	83 ec 0c             	sub    $0xc,%esp
801056e5:	89 c3                	mov    %eax,%ebx
801056e7:	50                   	push   %eax
801056e8:	e8 d3 bf ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801056ed:	83 c4 0c             	add    $0xc,%esp
801056f0:	6a 00                	push   $0x0
801056f2:	56                   	push   %esi
801056f3:	53                   	push   %ebx
801056f4:	e8 f7 c4 ff ff       	call   80101bf0 <dirlookup>
801056f9:	83 c4 10             	add    $0x10,%esp
801056fc:	85 c0                	test   %eax,%eax
801056fe:	89 c7                	mov    %eax,%edi
80105700:	74 3e                	je     80105740 <create+0x90>
    iunlockput(dp);
80105702:	83 ec 0c             	sub    $0xc,%esp
80105705:	53                   	push   %ebx
80105706:	e8 45 c2 ff ff       	call   80101950 <iunlockput>
    ilock(ip);
8010570b:	89 3c 24             	mov    %edi,(%esp)
8010570e:	e8 ad bf ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105713:	83 c4 10             	add    $0x10,%esp
80105716:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010571b:	0f 85 9f 00 00 00    	jne    801057c0 <create+0x110>
80105721:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105726:	0f 85 94 00 00 00    	jne    801057c0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010572c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010572f:	89 f8                	mov    %edi,%eax
80105731:	5b                   	pop    %ebx
80105732:	5e                   	pop    %esi
80105733:	5f                   	pop    %edi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
80105736:	8d 76 00             	lea    0x0(%esi),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105740:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105744:	83 ec 08             	sub    $0x8,%esp
80105747:	50                   	push   %eax
80105748:	ff 33                	pushl  (%ebx)
8010574a:	e8 01 be ff ff       	call   80101550 <ialloc>
8010574f:	83 c4 10             	add    $0x10,%esp
80105752:	85 c0                	test   %eax,%eax
80105754:	89 c7                	mov    %eax,%edi
80105756:	0f 84 e8 00 00 00    	je     80105844 <create+0x194>
  ilock(ip);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	50                   	push   %eax
80105760:	e8 5b bf ff ff       	call   801016c0 <ilock>
  ip->major = major;
80105765:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105769:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010576d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105771:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105775:	b8 01 00 00 00       	mov    $0x1,%eax
8010577a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010577e:	89 3c 24             	mov    %edi,(%esp)
80105781:	e8 8a be ff ff       	call   80101610 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105786:	83 c4 10             	add    $0x10,%esp
80105789:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010578e:	74 50                	je     801057e0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105790:	83 ec 04             	sub    $0x4,%esp
80105793:	ff 77 04             	pushl  0x4(%edi)
80105796:	56                   	push   %esi
80105797:	53                   	push   %ebx
80105798:	e8 c3 c6 ff ff       	call   80101e60 <dirlink>
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	85 c0                	test   %eax,%eax
801057a2:	0f 88 8f 00 00 00    	js     80105837 <create+0x187>
  iunlockput(dp);
801057a8:	83 ec 0c             	sub    $0xc,%esp
801057ab:	53                   	push   %ebx
801057ac:	e8 9f c1 ff ff       	call   80101950 <iunlockput>
  return ip;
801057b1:	83 c4 10             	add    $0x10,%esp
}
801057b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b7:	89 f8                	mov    %edi,%eax
801057b9:	5b                   	pop    %ebx
801057ba:	5e                   	pop    %esi
801057bb:	5f                   	pop    %edi
801057bc:	5d                   	pop    %ebp
801057bd:	c3                   	ret    
801057be:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801057c0:	83 ec 0c             	sub    $0xc,%esp
801057c3:	57                   	push   %edi
    return 0;
801057c4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801057c6:	e8 85 c1 ff ff       	call   80101950 <iunlockput>
    return 0;
801057cb:	83 c4 10             	add    $0x10,%esp
}
801057ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057d1:	89 f8                	mov    %edi,%eax
801057d3:	5b                   	pop    %ebx
801057d4:	5e                   	pop    %esi
801057d5:	5f                   	pop    %edi
801057d6:	5d                   	pop    %ebp
801057d7:	c3                   	ret    
801057d8:	90                   	nop
801057d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801057e0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801057e5:	83 ec 0c             	sub    $0xc,%esp
801057e8:	53                   	push   %ebx
801057e9:	e8 22 be ff ff       	call   80101610 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801057ee:	83 c4 0c             	add    $0xc,%esp
801057f1:	ff 77 04             	pushl  0x4(%edi)
801057f4:	68 9d 80 10 80       	push   $0x8010809d
801057f9:	57                   	push   %edi
801057fa:	e8 61 c6 ff ff       	call   80101e60 <dirlink>
801057ff:	83 c4 10             	add    $0x10,%esp
80105802:	85 c0                	test   %eax,%eax
80105804:	78 1c                	js     80105822 <create+0x172>
80105806:	83 ec 04             	sub    $0x4,%esp
80105809:	ff 73 04             	pushl  0x4(%ebx)
8010580c:	68 9c 80 10 80       	push   $0x8010809c
80105811:	57                   	push   %edi
80105812:	e8 49 c6 ff ff       	call   80101e60 <dirlink>
80105817:	83 c4 10             	add    $0x10,%esp
8010581a:	85 c0                	test   %eax,%eax
8010581c:	0f 89 6e ff ff ff    	jns    80105790 <create+0xe0>
      panic("create dots");
80105822:	83 ec 0c             	sub    $0xc,%esp
80105825:	68 21 87 10 80       	push   $0x80108721
8010582a:	e8 61 ab ff ff       	call   80100390 <panic>
8010582f:	90                   	nop
    return 0;
80105830:	31 ff                	xor    %edi,%edi
80105832:	e9 f5 fe ff ff       	jmp    8010572c <create+0x7c>
    panic("create: dirlink");
80105837:	83 ec 0c             	sub    $0xc,%esp
8010583a:	68 2d 87 10 80       	push   $0x8010872d
8010583f:	e8 4c ab ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	68 12 87 10 80       	push   $0x80108712
8010584c:	e8 3f ab ff ff       	call   80100390 <panic>
80105851:	eb 0d                	jmp    80105860 <sys_open>
80105853:	90                   	nop
80105854:	90                   	nop
80105855:	90                   	nop
80105856:	90                   	nop
80105857:	90                   	nop
80105858:	90                   	nop
80105859:	90                   	nop
8010585a:	90                   	nop
8010585b:	90                   	nop
8010585c:	90                   	nop
8010585d:	90                   	nop
8010585e:	90                   	nop
8010585f:	90                   	nop

80105860 <sys_open>:

int
sys_open(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105866:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105869:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010586c:	50                   	push   %eax
8010586d:	6a 00                	push   $0x0
8010586f:	e8 fc f7 ff ff       	call   80105070 <argstr>
80105874:	83 c4 10             	add    $0x10,%esp
80105877:	85 c0                	test   %eax,%eax
80105879:	0f 88 1d 01 00 00    	js     8010599c <sys_open+0x13c>
8010587f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105882:	83 ec 08             	sub    $0x8,%esp
80105885:	50                   	push   %eax
80105886:	6a 01                	push   $0x1
80105888:	e8 33 f7 ff ff       	call   80104fc0 <argint>
8010588d:	83 c4 10             	add    $0x10,%esp
80105890:	85 c0                	test   %eax,%eax
80105892:	0f 88 04 01 00 00    	js     8010599c <sys_open+0x13c>
    return -1;

  begin_op();
80105898:	e8 43 d9 ff ff       	call   801031e0 <begin_op>

  if(omode & O_CREATE){
8010589d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058a1:	0f 85 a9 00 00 00    	jne    80105950 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058a7:	83 ec 0c             	sub    $0xc,%esp
801058aa:	ff 75 e0             	pushl  -0x20(%ebp)
801058ad:	e8 6e c6 ff ff       	call   80101f20 <namei>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	89 c6                	mov    %eax,%esi
801058b9:	0f 84 ac 00 00 00    	je     8010596b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801058bf:	83 ec 0c             	sub    $0xc,%esp
801058c2:	50                   	push   %eax
801058c3:	e8 f8 bd ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058c8:	83 c4 10             	add    $0x10,%esp
801058cb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058d0:	0f 84 aa 00 00 00    	je     80105980 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058d6:	e8 e5 b4 ff ff       	call   80100dc0 <filealloc>
801058db:	85 c0                	test   %eax,%eax
801058dd:	89 c7                	mov    %eax,%edi
801058df:	0f 84 a6 00 00 00    	je     8010598b <sys_open+0x12b>
  struct proc *curproc = myproc();
801058e5:	e8 d6 e5 ff ff       	call   80103ec0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058ea:	31 db                	xor    %ebx,%ebx
801058ec:	eb 0e                	jmp    801058fc <sys_open+0x9c>
801058ee:	66 90                	xchg   %ax,%ax
801058f0:	83 c3 01             	add    $0x1,%ebx
801058f3:	83 fb 10             	cmp    $0x10,%ebx
801058f6:	0f 84 ac 00 00 00    	je     801059a8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801058fc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105900:	85 d2                	test   %edx,%edx
80105902:	75 ec                	jne    801058f0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105904:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105907:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010590b:	56                   	push   %esi
8010590c:	e8 8f be ff ff       	call   801017a0 <iunlock>
  end_op();
80105911:	e8 3a d9 ff ff       	call   80103250 <end_op>

  f->type = FD_INODE;
80105916:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010591c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010591f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105922:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105925:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010592c:	89 d0                	mov    %edx,%eax
8010592e:	f7 d0                	not    %eax
80105930:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105933:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105936:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105939:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010593d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105940:	89 d8                	mov    %ebx,%eax
80105942:	5b                   	pop    %ebx
80105943:	5e                   	pop    %esi
80105944:	5f                   	pop    %edi
80105945:	5d                   	pop    %ebp
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105950:	6a 00                	push   $0x0
80105952:	6a 00                	push   $0x0
80105954:	6a 02                	push   $0x2
80105956:	ff 75 e0             	pushl  -0x20(%ebp)
80105959:	e8 52 fd ff ff       	call   801056b0 <create>
    if(ip == 0){
8010595e:	83 c4 10             	add    $0x10,%esp
80105961:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105963:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105965:	0f 85 6b ff ff ff    	jne    801058d6 <sys_open+0x76>
      end_op();
8010596b:	e8 e0 d8 ff ff       	call   80103250 <end_op>
      return -1;
80105970:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105975:	eb c6                	jmp    8010593d <sys_open+0xdd>
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105980:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105983:	85 c9                	test   %ecx,%ecx
80105985:	0f 84 4b ff ff ff    	je     801058d6 <sys_open+0x76>
    iunlockput(ip);
8010598b:	83 ec 0c             	sub    $0xc,%esp
8010598e:	56                   	push   %esi
8010598f:	e8 bc bf ff ff       	call   80101950 <iunlockput>
    end_op();
80105994:	e8 b7 d8 ff ff       	call   80103250 <end_op>
    return -1;
80105999:	83 c4 10             	add    $0x10,%esp
8010599c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059a1:	eb 9a                	jmp    8010593d <sys_open+0xdd>
801059a3:	90                   	nop
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	57                   	push   %edi
801059ac:	e8 cf b4 ff ff       	call   80100e80 <fileclose>
801059b1:	83 c4 10             	add    $0x10,%esp
801059b4:	eb d5                	jmp    8010598b <sys_open+0x12b>
801059b6:	8d 76 00             	lea    0x0(%esi),%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059c6:	e8 15 d8 ff ff       	call   801031e0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ce:	83 ec 08             	sub    $0x8,%esp
801059d1:	50                   	push   %eax
801059d2:	6a 00                	push   $0x0
801059d4:	e8 97 f6 ff ff       	call   80105070 <argstr>
801059d9:	83 c4 10             	add    $0x10,%esp
801059dc:	85 c0                	test   %eax,%eax
801059de:	78 30                	js     80105a10 <sys_mkdir+0x50>
801059e0:	6a 00                	push   $0x0
801059e2:	6a 00                	push   $0x0
801059e4:	6a 01                	push   $0x1
801059e6:	ff 75 f4             	pushl  -0xc(%ebp)
801059e9:	e8 c2 fc ff ff       	call   801056b0 <create>
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	85 c0                	test   %eax,%eax
801059f3:	74 1b                	je     80105a10 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	50                   	push   %eax
801059f9:	e8 52 bf ff ff       	call   80101950 <iunlockput>
  end_op();
801059fe:	e8 4d d8 ff ff       	call   80103250 <end_op>
  return 0;
80105a03:	83 c4 10             	add    $0x10,%esp
80105a06:	31 c0                	xor    %eax,%eax
}
80105a08:	c9                   	leave  
80105a09:	c3                   	ret    
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105a10:	e8 3b d8 ff ff       	call   80103250 <end_op>
    return -1;
80105a15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_mknod>:

int
sys_mknod(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a26:	e8 b5 d7 ff ff       	call   801031e0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a2e:	83 ec 08             	sub    $0x8,%esp
80105a31:	50                   	push   %eax
80105a32:	6a 00                	push   $0x0
80105a34:	e8 37 f6 ff ff       	call   80105070 <argstr>
80105a39:	83 c4 10             	add    $0x10,%esp
80105a3c:	85 c0                	test   %eax,%eax
80105a3e:	78 60                	js     80105aa0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a40:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	50                   	push   %eax
80105a47:	6a 01                	push   $0x1
80105a49:	e8 72 f5 ff ff       	call   80104fc0 <argint>
  if((argstr(0, &path)) < 0 ||
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	85 c0                	test   %eax,%eax
80105a53:	78 4b                	js     80105aa0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a55:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a58:	83 ec 08             	sub    $0x8,%esp
80105a5b:	50                   	push   %eax
80105a5c:	6a 02                	push   $0x2
80105a5e:	e8 5d f5 ff ff       	call   80104fc0 <argint>
     argint(1, &major) < 0 ||
80105a63:	83 c4 10             	add    $0x10,%esp
80105a66:	85 c0                	test   %eax,%eax
80105a68:	78 36                	js     80105aa0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a6e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a6f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a73:	50                   	push   %eax
80105a74:	6a 03                	push   $0x3
80105a76:	ff 75 ec             	pushl  -0x14(%ebp)
80105a79:	e8 32 fc ff ff       	call   801056b0 <create>
80105a7e:	83 c4 10             	add    $0x10,%esp
80105a81:	85 c0                	test   %eax,%eax
80105a83:	74 1b                	je     80105aa0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a85:	83 ec 0c             	sub    $0xc,%esp
80105a88:	50                   	push   %eax
80105a89:	e8 c2 be ff ff       	call   80101950 <iunlockput>
  end_op();
80105a8e:	e8 bd d7 ff ff       	call   80103250 <end_op>
  return 0;
80105a93:	83 c4 10             	add    $0x10,%esp
80105a96:	31 c0                	xor    %eax,%eax
}
80105a98:	c9                   	leave  
80105a99:	c3                   	ret    
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105aa0:	e8 ab d7 ff ff       	call   80103250 <end_op>
    return -1;
80105aa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aaa:	c9                   	leave  
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_chdir>:

int
sys_chdir(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	56                   	push   %esi
80105ab4:	53                   	push   %ebx
80105ab5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ab8:	e8 03 e4 ff ff       	call   80103ec0 <myproc>
80105abd:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105abf:	e8 1c d7 ff ff       	call   801031e0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ac7:	83 ec 08             	sub    $0x8,%esp
80105aca:	50                   	push   %eax
80105acb:	6a 00                	push   $0x0
80105acd:	e8 9e f5 ff ff       	call   80105070 <argstr>
80105ad2:	83 c4 10             	add    $0x10,%esp
80105ad5:	85 c0                	test   %eax,%eax
80105ad7:	78 77                	js     80105b50 <sys_chdir+0xa0>
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	ff 75 f4             	pushl  -0xc(%ebp)
80105adf:	e8 3c c4 ff ff       	call   80101f20 <namei>
80105ae4:	83 c4 10             	add    $0x10,%esp
80105ae7:	85 c0                	test   %eax,%eax
80105ae9:	89 c3                	mov    %eax,%ebx
80105aeb:	74 63                	je     80105b50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105aed:	83 ec 0c             	sub    $0xc,%esp
80105af0:	50                   	push   %eax
80105af1:	e8 ca bb ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105af6:	83 c4 10             	add    $0x10,%esp
80105af9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105afe:	75 30                	jne    80105b30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	53                   	push   %ebx
80105b04:	e8 97 bc ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105b09:	58                   	pop    %eax
80105b0a:	ff 76 68             	pushl  0x68(%esi)
80105b0d:	e8 de bc ff ff       	call   801017f0 <iput>
  end_op();
80105b12:	e8 39 d7 ff ff       	call   80103250 <end_op>
  curproc->cwd = ip;
80105b17:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b1a:	83 c4 10             	add    $0x10,%esp
80105b1d:	31 c0                	xor    %eax,%eax
}
80105b1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b22:	5b                   	pop    %ebx
80105b23:	5e                   	pop    %esi
80105b24:	5d                   	pop    %ebp
80105b25:	c3                   	ret    
80105b26:	8d 76 00             	lea    0x0(%esi),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	53                   	push   %ebx
80105b34:	e8 17 be ff ff       	call   80101950 <iunlockput>
    end_op();
80105b39:	e8 12 d7 ff ff       	call   80103250 <end_op>
    return -1;
80105b3e:	83 c4 10             	add    $0x10,%esp
80105b41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b46:	eb d7                	jmp    80105b1f <sys_chdir+0x6f>
80105b48:	90                   	nop
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b50:	e8 fb d6 ff ff       	call   80103250 <end_op>
    return -1;
80105b55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b5a:	eb c3                	jmp    80105b1f <sys_chdir+0x6f>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exec>:

int
sys_exec(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b66:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b6c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b72:	50                   	push   %eax
80105b73:	6a 00                	push   $0x0
80105b75:	e8 f6 f4 ff ff       	call   80105070 <argstr>
80105b7a:	83 c4 10             	add    $0x10,%esp
80105b7d:	85 c0                	test   %eax,%eax
80105b7f:	0f 88 87 00 00 00    	js     80105c0c <sys_exec+0xac>
80105b85:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105b8b:	83 ec 08             	sub    $0x8,%esp
80105b8e:	50                   	push   %eax
80105b8f:	6a 01                	push   $0x1
80105b91:	e8 2a f4 ff ff       	call   80104fc0 <argint>
80105b96:	83 c4 10             	add    $0x10,%esp
80105b99:	85 c0                	test   %eax,%eax
80105b9b:	78 6f                	js     80105c0c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105b9d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ba3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105ba6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105ba8:	68 80 00 00 00       	push   $0x80
80105bad:	6a 00                	push   $0x0
80105baf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bb5:	50                   	push   %eax
80105bb6:	e8 05 f1 ff ff       	call   80104cc0 <memset>
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	eb 2c                	jmp    80105bec <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105bc0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	74 56                	je     80105c20 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bca:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bd6:	52                   	push   %edx
80105bd7:	50                   	push   %eax
80105bd8:	e8 73 f3 ff ff       	call   80104f50 <fetchstr>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	85 c0                	test   %eax,%eax
80105be2:	78 28                	js     80105c0c <sys_exec+0xac>
  for(i=0;; i++){
80105be4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105be7:	83 fb 20             	cmp    $0x20,%ebx
80105bea:	74 20                	je     80105c0c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105bec:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105bf2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105bf9:	83 ec 08             	sub    $0x8,%esp
80105bfc:	57                   	push   %edi
80105bfd:	01 f0                	add    %esi,%eax
80105bff:	50                   	push   %eax
80105c00:	e8 0b f3 ff ff       	call   80104f10 <fetchint>
80105c05:	83 c4 10             	add    $0x10,%esp
80105c08:	85 c0                	test   %eax,%eax
80105c0a:	79 b4                	jns    80105bc0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c14:	5b                   	pop    %ebx
80105c15:	5e                   	pop    %esi
80105c16:	5f                   	pop    %edi
80105c17:	5d                   	pop    %ebp
80105c18:	c3                   	ret    
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c20:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c26:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c29:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c30:	00 00 00 00 
  return exec(path, argv);
80105c34:	50                   	push   %eax
80105c35:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c3b:	e8 d0 ad ff ff       	call   80100a10 <exec>
80105c40:	83 c4 10             	add    $0x10,%esp
}
80105c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c46:	5b                   	pop    %ebx
80105c47:	5e                   	pop    %esi
80105c48:	5f                   	pop    %edi
80105c49:	5d                   	pop    %ebp
80105c4a:	c3                   	ret    
80105c4b:	90                   	nop
80105c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c50 <sys_pipe>:

int
sys_pipe(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	57                   	push   %edi
80105c54:	56                   	push   %esi
80105c55:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c56:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c59:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c5c:	6a 08                	push   $0x8
80105c5e:	50                   	push   %eax
80105c5f:	6a 00                	push   $0x0
80105c61:	e8 aa f3 ff ff       	call   80105010 <argptr>
80105c66:	83 c4 10             	add    $0x10,%esp
80105c69:	85 c0                	test   %eax,%eax
80105c6b:	0f 88 ae 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c71:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c74:	83 ec 08             	sub    $0x8,%esp
80105c77:	50                   	push   %eax
80105c78:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c7b:	50                   	push   %eax
80105c7c:	e8 ff db ff ff       	call   80103880 <pipealloc>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	0f 88 93 00 00 00    	js     80105d1f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105c8c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105c8f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105c91:	e8 2a e2 ff ff       	call   80103ec0 <myproc>
80105c96:	eb 10                	jmp    80105ca8 <sys_pipe+0x58>
80105c98:	90                   	nop
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105ca0:	83 c3 01             	add    $0x1,%ebx
80105ca3:	83 fb 10             	cmp    $0x10,%ebx
80105ca6:	74 60                	je     80105d08 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105ca8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105cac:	85 f6                	test   %esi,%esi
80105cae:	75 f0                	jne    80105ca0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cb0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cb3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cb7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cba:	e8 01 e2 ff ff       	call   80103ec0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cbf:	31 d2                	xor    %edx,%edx
80105cc1:	eb 0d                	jmp    80105cd0 <sys_pipe+0x80>
80105cc3:	90                   	nop
80105cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cc8:	83 c2 01             	add    $0x1,%edx
80105ccb:	83 fa 10             	cmp    $0x10,%edx
80105cce:	74 28                	je     80105cf8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105cd0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cd4:	85 c9                	test   %ecx,%ecx
80105cd6:	75 f0                	jne    80105cc8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105cd8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cdf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ce1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ce4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ce7:	31 c0                	xor    %eax,%eax
}
80105ce9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cec:	5b                   	pop    %ebx
80105ced:	5e                   	pop    %esi
80105cee:	5f                   	pop    %edi
80105cef:	5d                   	pop    %ebp
80105cf0:	c3                   	ret    
80105cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105cf8:	e8 c3 e1 ff ff       	call   80103ec0 <myproc>
80105cfd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d04:	00 
80105d05:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d08:	83 ec 0c             	sub    $0xc,%esp
80105d0b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d0e:	e8 6d b1 ff ff       	call   80100e80 <fileclose>
    fileclose(wf);
80105d13:	58                   	pop    %eax
80105d14:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d17:	e8 64 b1 ff ff       	call   80100e80 <fileclose>
    return -1;
80105d1c:	83 c4 10             	add    $0x10,%esp
80105d1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d24:	eb c3                	jmp    80105ce9 <sys_pipe+0x99>
80105d26:	66 90                	xchg   %ax,%ax
80105d28:	66 90                	xchg   %ax,%ax
80105d2a:	66 90                	xchg   %ax,%ax
80105d2c:	66 90                	xchg   %ax,%ax
80105d2e:	66 90                	xchg   %ax,%ax

80105d30 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105d33:	5d                   	pop    %ebp
  return fork();
80105d34:	e9 27 e3 ff ff       	jmp    80104060 <fork>
80105d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d40 <sys_exit>:

int
sys_exit(void)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 08             	sub    $0x8,%esp
  exit();
80105d46:	e8 95 e6 ff ff       	call   801043e0 <exit>
  return 0;  // not reached
}
80105d4b:	31 c0                	xor    %eax,%eax
80105d4d:	c9                   	leave  
80105d4e:	c3                   	ret    
80105d4f:	90                   	nop

80105d50 <sys_wait>:

int
sys_wait(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105d53:	5d                   	pop    %ebp
  return wait();
80105d54:	e9 e7 e8 ff ff       	jmp    80104640 <wait>
80105d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d60 <sys_kill>:

int
sys_kill(void)
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105d66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d69:	50                   	push   %eax
80105d6a:	6a 00                	push   $0x0
80105d6c:	e8 4f f2 ff ff       	call   80104fc0 <argint>
80105d71:	83 c4 10             	add    $0x10,%esp
80105d74:	85 c0                	test   %eax,%eax
80105d76:	78 18                	js     80105d90 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105d78:	83 ec 0c             	sub    $0xc,%esp
80105d7b:	ff 75 f4             	pushl  -0xc(%ebp)
80105d7e:	e8 4d ea ff ff       	call   801047d0 <kill>
80105d83:	83 c4 10             	add    $0x10,%esp
}
80105d86:	c9                   	leave  
80105d87:	c3                   	ret    
80105d88:	90                   	nop
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <sys_getpid>:

int
sys_getpid(void)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105da6:	e8 15 e1 ff ff       	call   80103ec0 <myproc>
80105dab:	8b 40 10             	mov    0x10(%eax),%eax
}
80105dae:	c9                   	leave  
80105daf:	c3                   	ret    

80105db0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105db4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105db7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105dba:	50                   	push   %eax
80105dbb:	6a 00                	push   $0x0
80105dbd:	e8 fe f1 ff ff       	call   80104fc0 <argint>
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	85 c0                	test   %eax,%eax
80105dc7:	78 27                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105dc9:	e8 f2 e0 ff ff       	call   80103ec0 <myproc>
  if(growproc(n) < 0)
80105dce:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105dd1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105dd3:	ff 75 f4             	pushl  -0xc(%ebp)
80105dd6:	e8 05 e2 ff ff       	call   80103fe0 <growproc>
80105ddb:	83 c4 10             	add    $0x10,%esp
80105dde:	85 c0                	test   %eax,%eax
80105de0:	78 0e                	js     80105df0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105de2:	89 d8                	mov    %ebx,%eax
80105de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105de7:	c9                   	leave  
80105de8:	c3                   	ret    
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105df0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105df5:	eb eb                	jmp    80105de2 <sys_sbrk+0x32>
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <sys_sleep>:

int
sys_sleep(void)
{
80105e00:	55                   	push   %ebp
80105e01:	89 e5                	mov    %esp,%ebp
80105e03:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105e04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105e07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105e0a:	50                   	push   %eax
80105e0b:	6a 00                	push   $0x0
80105e0d:	e8 ae f1 ff ff       	call   80104fc0 <argint>
80105e12:	83 c4 10             	add    $0x10,%esp
80105e15:	85 c0                	test   %eax,%eax
80105e17:	0f 88 8a 00 00 00    	js     80105ea7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105e1d:	83 ec 0c             	sub    $0xc,%esp
80105e20:	68 a0 01 1a 80       	push   $0x801a01a0
80105e25:	e8 86 ed ff ff       	call   80104bb0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105e2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e2d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105e30:	8b 1d e0 09 1a 80    	mov    0x801a09e0,%ebx
  while(ticks - ticks0 < n){
80105e36:	85 d2                	test   %edx,%edx
80105e38:	75 27                	jne    80105e61 <sys_sleep+0x61>
80105e3a:	eb 54                	jmp    80105e90 <sys_sleep+0x90>
80105e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105e40:	83 ec 08             	sub    $0x8,%esp
80105e43:	68 a0 01 1a 80       	push   $0x801a01a0
80105e48:	68 e0 09 1a 80       	push   $0x801a09e0
80105e4d:	e8 2e e7 ff ff       	call   80104580 <sleep>
  while(ticks - ticks0 < n){
80105e52:	a1 e0 09 1a 80       	mov    0x801a09e0,%eax
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	29 d8                	sub    %ebx,%eax
80105e5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105e5f:	73 2f                	jae    80105e90 <sys_sleep+0x90>
    if(myproc()->killed){
80105e61:	e8 5a e0 ff ff       	call   80103ec0 <myproc>
80105e66:	8b 40 24             	mov    0x24(%eax),%eax
80105e69:	85 c0                	test   %eax,%eax
80105e6b:	74 d3                	je     80105e40 <sys_sleep+0x40>
      release(&tickslock);
80105e6d:	83 ec 0c             	sub    $0xc,%esp
80105e70:	68 a0 01 1a 80       	push   $0x801a01a0
80105e75:	e8 f6 ed ff ff       	call   80104c70 <release>
      return -1;
80105e7a:	83 c4 10             	add    $0x10,%esp
80105e7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105e82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	89 f6                	mov    %esi,%esi
80105e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105e90:	83 ec 0c             	sub    $0xc,%esp
80105e93:	68 a0 01 1a 80       	push   $0x801a01a0
80105e98:	e8 d3 ed ff ff       	call   80104c70 <release>
  return 0;
80105e9d:	83 c4 10             	add    $0x10,%esp
80105ea0:	31 c0                	xor    %eax,%eax
}
80105ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ea5:	c9                   	leave  
80105ea6:	c3                   	ret    
    return -1;
80105ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105eac:	eb f4                	jmp    80105ea2 <sys_sleep+0xa2>
80105eae:	66 90                	xchg   %ax,%ax

80105eb0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	53                   	push   %ebx
80105eb4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105eb7:	68 a0 01 1a 80       	push   $0x801a01a0
80105ebc:	e8 ef ec ff ff       	call   80104bb0 <acquire>
  xticks = ticks;
80105ec1:	8b 1d e0 09 1a 80    	mov    0x801a09e0,%ebx
  release(&tickslock);
80105ec7:	c7 04 24 a0 01 1a 80 	movl   $0x801a01a0,(%esp)
80105ece:	e8 9d ed ff ff       	call   80104c70 <release>
  return xticks;
}
80105ed3:	89 d8                	mov    %ebx,%eax
80105ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ed8:	c9                   	leave  
80105ed9:	c3                   	ret    
80105eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ee0 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80105ee6:	e8 d5 df ff ff       	call   80103ec0 <myproc>
80105eeb:	ba 10 00 00 00       	mov    $0x10,%edx
80105ef0:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80105ef6:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80105ef7:	89 d0                	mov    %edx,%eax
}
80105ef9:	c3                   	ret    
80105efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f00 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80105f03:	5d                   	pop    %ebp
  return getTotalFreePages();
80105f04:	e9 17 ea ff ff       	jmp    80104920 <getTotalFreePages>

80105f09 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f09:	1e                   	push   %ds
  pushl %es
80105f0a:	06                   	push   %es
  pushl %fs
80105f0b:	0f a0                	push   %fs
  pushl %gs
80105f0d:	0f a8                	push   %gs
  pushal
80105f0f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f10:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f14:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f16:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f18:	54                   	push   %esp
  call trap
80105f19:	e8 c2 00 00 00       	call   80105fe0 <trap>
  addl $4, %esp
80105f1e:	83 c4 04             	add    $0x4,%esp

80105f21 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f21:	61                   	popa   
  popl %gs
80105f22:	0f a9                	pop    %gs
  popl %fs
80105f24:	0f a1                	pop    %fs
  popl %es
80105f26:	07                   	pop    %es
  popl %ds
80105f27:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105f28:	83 c4 08             	add    $0x8,%esp
  iret
80105f2b:	cf                   	iret   
80105f2c:	66 90                	xchg   %ax,%ax
80105f2e:	66 90                	xchg   %ax,%ax

80105f30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105f30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105f31:	31 c0                	xor    %eax,%eax
{
80105f33:	89 e5                	mov    %esp,%ebp
80105f35:	83 ec 08             	sub    $0x8,%esp
80105f38:	90                   	nop
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105f40:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105f47:	c7 04 c5 e2 01 1a 80 	movl   $0x8e000008,-0x7fe5fe1e(,%eax,8)
80105f4e:	08 00 00 8e 
80105f52:	66 89 14 c5 e0 01 1a 	mov    %dx,-0x7fe5fe20(,%eax,8)
80105f59:	80 
80105f5a:	c1 ea 10             	shr    $0x10,%edx
80105f5d:	66 89 14 c5 e6 01 1a 	mov    %dx,-0x7fe5fe1a(,%eax,8)
80105f64:	80 
  for(i = 0; i < 256; i++)
80105f65:	83 c0 01             	add    $0x1,%eax
80105f68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105f6d:	75 d1                	jne    80105f40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f6f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105f74:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f77:	c7 05 e2 03 1a 80 08 	movl   $0xef000008,0x801a03e2
80105f7e:	00 00 ef 
  initlock(&tickslock, "time");
80105f81:	68 3d 87 10 80       	push   $0x8010873d
80105f86:	68 a0 01 1a 80       	push   $0x801a01a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105f8b:	66 a3 e0 03 1a 80    	mov    %ax,0x801a03e0
80105f91:	c1 e8 10             	shr    $0x10,%eax
80105f94:	66 a3 e6 03 1a 80    	mov    %ax,0x801a03e6
  initlock(&tickslock, "time");
80105f9a:	e8 d1 ea ff ff       	call   80104a70 <initlock>
}
80105f9f:	83 c4 10             	add    $0x10,%esp
80105fa2:	c9                   	leave  
80105fa3:	c3                   	ret    
80105fa4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105faa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105fb0 <idtinit>:

void
idtinit(void)
{
80105fb0:	55                   	push   %ebp
  pd[0] = size-1;
80105fb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105fb6:	89 e5                	mov    %esp,%ebp
80105fb8:	83 ec 10             	sub    $0x10,%esp
80105fbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105fbf:	b8 e0 01 1a 80       	mov    $0x801a01e0,%eax
80105fc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105fc8:	c1 e8 10             	shr    $0x10,%eax
80105fcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105fcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105fd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	89 f6                	mov    %esi,%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	57                   	push   %edi
80105fe4:	56                   	push   %esi
80105fe5:	53                   	push   %ebx
80105fe6:	83 ec 1c             	sub    $0x1c,%esp
80105fe9:	8b 7d 08             	mov    0x8(%ebp),%edi

  struct proc* curproc = myproc();
80105fec:	e8 cf de ff ff       	call   80103ec0 <myproc>
  if(tf->trapno == T_SYSCALL){
80105ff1:	8b 57 30             	mov    0x30(%edi),%edx
80105ff4:	83 fa 40             	cmp    $0x40,%edx
80105ff7:	0f 84 eb 00 00 00    	je     801060e8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ffd:	83 ea 0e             	sub    $0xe,%edx
80106000:	83 fa 31             	cmp    $0x31,%edx
80106003:	77 0b                	ja     80106010 <trap+0x30>
80106005:	ff 24 95 e4 87 10 80 	jmp    *-0x7fef781c(,%edx,4)
8010600c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106010:	e8 ab de ff ff       	call   80103ec0 <myproc>
80106015:	85 c0                	test   %eax,%eax
80106017:	0f 84 07 02 00 00    	je     80106224 <trap+0x244>
8010601d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106021:	0f 84 fd 01 00 00    	je     80106224 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106027:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010602a:	8b 57 38             	mov    0x38(%edi),%edx
8010602d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106030:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106033:	e8 68 de ff ff       	call   80103ea0 <cpuid>
80106038:	8b 77 34             	mov    0x34(%edi),%esi
8010603b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010603e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106041:	e8 7a de ff ff       	call   80103ec0 <myproc>
80106046:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106049:	e8 72 de ff ff       	call   80103ec0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010604e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106051:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106054:	51                   	push   %ecx
80106055:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106056:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106059:	ff 75 e4             	pushl  -0x1c(%ebp)
8010605c:	56                   	push   %esi
8010605d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010605e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106061:	52                   	push   %edx
80106062:	ff 70 10             	pushl  0x10(%eax)
80106065:	68 a0 87 10 80       	push   $0x801087a0
8010606a:	e8 f1 a5 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010606f:	83 c4 20             	add    $0x20,%esp
80106072:	e8 49 de ff ff       	call   80103ec0 <myproc>
80106077:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010607e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106080:	e8 3b de ff ff       	call   80103ec0 <myproc>
80106085:	85 c0                	test   %eax,%eax
80106087:	74 1d                	je     801060a6 <trap+0xc6>
80106089:	e8 32 de ff ff       	call   80103ec0 <myproc>
8010608e:	8b 50 24             	mov    0x24(%eax),%edx
80106091:	85 d2                	test   %edx,%edx
80106093:	74 11                	je     801060a6 <trap+0xc6>
80106095:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106099:	83 e0 03             	and    $0x3,%eax
8010609c:	66 83 f8 03          	cmp    $0x3,%ax
801060a0:	0f 84 3a 01 00 00    	je     801061e0 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060a6:	e8 15 de ff ff       	call   80103ec0 <myproc>
801060ab:	85 c0                	test   %eax,%eax
801060ad:	74 0b                	je     801060ba <trap+0xda>
801060af:	e8 0c de ff ff       	call   80103ec0 <myproc>
801060b4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801060b8:	74 5e                	je     80106118 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060ba:	e8 01 de ff ff       	call   80103ec0 <myproc>
801060bf:	85 c0                	test   %eax,%eax
801060c1:	74 19                	je     801060dc <trap+0xfc>
801060c3:	e8 f8 dd ff ff       	call   80103ec0 <myproc>
801060c8:	8b 40 24             	mov    0x24(%eax),%eax
801060cb:	85 c0                	test   %eax,%eax
801060cd:	74 0d                	je     801060dc <trap+0xfc>
801060cf:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801060d3:	83 e0 03             	and    $0x3,%eax
801060d6:	66 83 f8 03          	cmp    $0x3,%ax
801060da:	74 2b                	je     80106107 <trap+0x127>
    exit();
}
801060dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060df:	5b                   	pop    %ebx
801060e0:	5e                   	pop    %esi
801060e1:	5f                   	pop    %edi
801060e2:	5d                   	pop    %ebp
801060e3:	c3                   	ret    
801060e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
801060e8:	8b 58 24             	mov    0x24(%eax),%ebx
801060eb:	85 db                	test   %ebx,%ebx
801060ed:	0f 85 dd 00 00 00    	jne    801061d0 <trap+0x1f0>
    curproc->tf = tf;
801060f3:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801060f6:	e8 b5 ef ff ff       	call   801050b0 <syscall>
    if(myproc()->killed)
801060fb:	e8 c0 dd ff ff       	call   80103ec0 <myproc>
80106100:	8b 48 24             	mov    0x24(%eax),%ecx
80106103:	85 c9                	test   %ecx,%ecx
80106105:	74 d5                	je     801060dc <trap+0xfc>
}
80106107:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010610a:	5b                   	pop    %ebx
8010610b:	5e                   	pop    %esi
8010610c:	5f                   	pop    %edi
8010610d:	5d                   	pop    %ebp
      exit();
8010610e:	e9 cd e2 ff ff       	jmp    801043e0 <exit>
80106113:	90                   	nop
80106114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106118:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010611c:	75 9c                	jne    801060ba <trap+0xda>
    yield();
8010611e:	e8 0d e4 ff ff       	call   80104530 <yield>
80106123:	eb 95                	jmp    801060ba <trap+0xda>
80106125:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
80106128:	e8 93 dd ff ff       	call   80103ec0 <myproc>
8010612d:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106131:	0f 8e 49 ff ff ff    	jle    80106080 <trap+0xa0>
    pagefault();
80106137:	e8 34 18 00 00       	call   80107970 <pagefault>
8010613c:	e9 3f ff ff ff       	jmp    80106080 <trap+0xa0>
80106141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106148:	e8 53 dd ff ff       	call   80103ea0 <cpuid>
8010614d:	85 c0                	test   %eax,%eax
8010614f:	0f 84 9b 00 00 00    	je     801061f0 <trap+0x210>
    lapiceoi();
80106155:	e8 36 cc ff ff       	call   80102d90 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010615a:	e8 61 dd ff ff       	call   80103ec0 <myproc>
8010615f:	85 c0                	test   %eax,%eax
80106161:	0f 85 22 ff ff ff    	jne    80106089 <trap+0xa9>
80106167:	e9 3a ff ff ff       	jmp    801060a6 <trap+0xc6>
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106170:	e8 db ca ff ff       	call   80102c50 <kbdintr>
    lapiceoi();
80106175:	e8 16 cc ff ff       	call   80102d90 <lapiceoi>
    break;
8010617a:	e9 01 ff ff ff       	jmp    80106080 <trap+0xa0>
8010617f:	90                   	nop
    uartintr();
80106180:	e8 3b 02 00 00       	call   801063c0 <uartintr>
    lapiceoi();
80106185:	e8 06 cc ff ff       	call   80102d90 <lapiceoi>
    break;
8010618a:	e9 f1 fe ff ff       	jmp    80106080 <trap+0xa0>
8010618f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106190:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106194:	8b 77 38             	mov    0x38(%edi),%esi
80106197:	e8 04 dd ff ff       	call   80103ea0 <cpuid>
8010619c:	56                   	push   %esi
8010619d:	53                   	push   %ebx
8010619e:	50                   	push   %eax
8010619f:	68 48 87 10 80       	push   $0x80108748
801061a4:	e8 b7 a4 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801061a9:	e8 e2 cb ff ff       	call   80102d90 <lapiceoi>
    break;
801061ae:	83 c4 10             	add    $0x10,%esp
801061b1:	e9 ca fe ff ff       	jmp    80106080 <trap+0xa0>
801061b6:	8d 76 00             	lea    0x0(%esi),%esi
801061b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
801061c0:	e8 8b c2 ff ff       	call   80102450 <ideintr>
801061c5:	eb 8e                	jmp    80106155 <trap+0x175>
801061c7:	89 f6                	mov    %esi,%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801061d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      exit();
801061d3:	e8 08 e2 ff ff       	call   801043e0 <exit>
801061d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801061db:	e9 13 ff ff ff       	jmp    801060f3 <trap+0x113>
    exit();
801061e0:	e8 fb e1 ff ff       	call   801043e0 <exit>
801061e5:	e9 bc fe ff ff       	jmp    801060a6 <trap+0xc6>
801061ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	68 a0 01 1a 80       	push   $0x801a01a0
801061f8:	e8 b3 e9 ff ff       	call   80104bb0 <acquire>
      wakeup(&ticks);
801061fd:	c7 04 24 e0 09 1a 80 	movl   $0x801a09e0,(%esp)
      ticks++;
80106204:	83 05 e0 09 1a 80 01 	addl   $0x1,0x801a09e0
      wakeup(&ticks);
8010620b:	e8 60 e5 ff ff       	call   80104770 <wakeup>
      release(&tickslock);
80106210:	c7 04 24 a0 01 1a 80 	movl   $0x801a01a0,(%esp)
80106217:	e8 54 ea ff ff       	call   80104c70 <release>
8010621c:	83 c4 10             	add    $0x10,%esp
8010621f:	e9 31 ff ff ff       	jmp    80106155 <trap+0x175>
80106224:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106227:	8b 5f 38             	mov    0x38(%edi),%ebx
8010622a:	e8 71 dc ff ff       	call   80103ea0 <cpuid>
8010622f:	83 ec 0c             	sub    $0xc,%esp
80106232:	56                   	push   %esi
80106233:	53                   	push   %ebx
80106234:	50                   	push   %eax
80106235:	ff 77 30             	pushl  0x30(%edi)
80106238:	68 6c 87 10 80       	push   $0x8010876c
8010623d:	e8 1e a4 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106242:	83 c4 14             	add    $0x14,%esp
80106245:	68 42 87 10 80       	push   $0x80108742
8010624a:	e8 41 a1 ff ff       	call   80100390 <panic>
8010624f:	90                   	nop

80106250 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106250:	a1 e0 c5 11 80       	mov    0x8011c5e0,%eax
{
80106255:	55                   	push   %ebp
80106256:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106258:	85 c0                	test   %eax,%eax
8010625a:	74 1c                	je     80106278 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010625c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106261:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106262:	a8 01                	test   $0x1,%al
80106264:	74 12                	je     80106278 <uartgetc+0x28>
80106266:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010626b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010626c:	0f b6 c0             	movzbl %al,%eax
}
8010626f:	5d                   	pop    %ebp
80106270:	c3                   	ret    
80106271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106278:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010627d:	5d                   	pop    %ebp
8010627e:	c3                   	ret    
8010627f:	90                   	nop

80106280 <uartputc.part.0>:
uartputc(int c)
80106280:	55                   	push   %ebp
80106281:	89 e5                	mov    %esp,%ebp
80106283:	57                   	push   %edi
80106284:	56                   	push   %esi
80106285:	53                   	push   %ebx
80106286:	89 c7                	mov    %eax,%edi
80106288:	bb 80 00 00 00       	mov    $0x80,%ebx
8010628d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106292:	83 ec 0c             	sub    $0xc,%esp
80106295:	eb 1b                	jmp    801062b2 <uartputc.part.0+0x32>
80106297:	89 f6                	mov    %esi,%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801062a0:	83 ec 0c             	sub    $0xc,%esp
801062a3:	6a 0a                	push   $0xa
801062a5:	e8 06 cb ff ff       	call   80102db0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	83 eb 01             	sub    $0x1,%ebx
801062b0:	74 07                	je     801062b9 <uartputc.part.0+0x39>
801062b2:	89 f2                	mov    %esi,%edx
801062b4:	ec                   	in     (%dx),%al
801062b5:	a8 20                	test   $0x20,%al
801062b7:	74 e7                	je     801062a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801062b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062be:	89 f8                	mov    %edi,%eax
801062c0:	ee                   	out    %al,(%dx)
}
801062c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c4:	5b                   	pop    %ebx
801062c5:	5e                   	pop    %esi
801062c6:	5f                   	pop    %edi
801062c7:	5d                   	pop    %ebp
801062c8:	c3                   	ret    
801062c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801062d0 <uartinit>:
{
801062d0:	55                   	push   %ebp
801062d1:	31 c9                	xor    %ecx,%ecx
801062d3:	89 c8                	mov    %ecx,%eax
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	57                   	push   %edi
801062d8:	56                   	push   %esi
801062d9:	53                   	push   %ebx
801062da:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801062df:	89 da                	mov    %ebx,%edx
801062e1:	83 ec 0c             	sub    $0xc,%esp
801062e4:	ee                   	out    %al,(%dx)
801062e5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801062ea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801062ef:	89 fa                	mov    %edi,%edx
801062f1:	ee                   	out    %al,(%dx)
801062f2:	b8 0c 00 00 00       	mov    $0xc,%eax
801062f7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801062fc:	ee                   	out    %al,(%dx)
801062fd:	be f9 03 00 00       	mov    $0x3f9,%esi
80106302:	89 c8                	mov    %ecx,%eax
80106304:	89 f2                	mov    %esi,%edx
80106306:	ee                   	out    %al,(%dx)
80106307:	b8 03 00 00 00       	mov    $0x3,%eax
8010630c:	89 fa                	mov    %edi,%edx
8010630e:	ee                   	out    %al,(%dx)
8010630f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106314:	89 c8                	mov    %ecx,%eax
80106316:	ee                   	out    %al,(%dx)
80106317:	b8 01 00 00 00       	mov    $0x1,%eax
8010631c:	89 f2                	mov    %esi,%edx
8010631e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010631f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106324:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106325:	3c ff                	cmp    $0xff,%al
80106327:	74 5a                	je     80106383 <uartinit+0xb3>
  uart = 1;
80106329:	c7 05 e0 c5 11 80 01 	movl   $0x1,0x8011c5e0
80106330:	00 00 00 
80106333:	89 da                	mov    %ebx,%edx
80106335:	ec                   	in     (%dx),%al
80106336:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010633b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010633c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010633f:	bb ac 88 10 80       	mov    $0x801088ac,%ebx
  ioapicenable(IRQ_COM1, 0);
80106344:	6a 00                	push   $0x0
80106346:	6a 04                	push   $0x4
80106348:	e8 53 c3 ff ff       	call   801026a0 <ioapicenable>
8010634d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106350:	b8 78 00 00 00       	mov    $0x78,%eax
80106355:	eb 13                	jmp    8010636a <uartinit+0x9a>
80106357:	89 f6                	mov    %esi,%esi
80106359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106360:	83 c3 01             	add    $0x1,%ebx
80106363:	0f be 03             	movsbl (%ebx),%eax
80106366:	84 c0                	test   %al,%al
80106368:	74 19                	je     80106383 <uartinit+0xb3>
  if(!uart)
8010636a:	8b 15 e0 c5 11 80    	mov    0x8011c5e0,%edx
80106370:	85 d2                	test   %edx,%edx
80106372:	74 ec                	je     80106360 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106374:	83 c3 01             	add    $0x1,%ebx
80106377:	e8 04 ff ff ff       	call   80106280 <uartputc.part.0>
8010637c:	0f be 03             	movsbl (%ebx),%eax
8010637f:	84 c0                	test   %al,%al
80106381:	75 e7                	jne    8010636a <uartinit+0x9a>
}
80106383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106386:	5b                   	pop    %ebx
80106387:	5e                   	pop    %esi
80106388:	5f                   	pop    %edi
80106389:	5d                   	pop    %ebp
8010638a:	c3                   	ret    
8010638b:	90                   	nop
8010638c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106390 <uartputc>:
  if(!uart)
80106390:	8b 15 e0 c5 11 80    	mov    0x8011c5e0,%edx
{
80106396:	55                   	push   %ebp
80106397:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106399:	85 d2                	test   %edx,%edx
{
8010639b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010639e:	74 10                	je     801063b0 <uartputc+0x20>
}
801063a0:	5d                   	pop    %ebp
801063a1:	e9 da fe ff ff       	jmp    80106280 <uartputc.part.0>
801063a6:	8d 76 00             	lea    0x0(%esi),%esi
801063a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801063b0:	5d                   	pop    %ebp
801063b1:	c3                   	ret    
801063b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <uartintr>:

void
uartintr(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801063c6:	68 50 62 10 80       	push   $0x80106250
801063cb:	e8 40 a4 ff ff       	call   80100810 <consoleintr>
}
801063d0:	83 c4 10             	add    $0x10,%esp
801063d3:	c9                   	leave  
801063d4:	c3                   	ret    

801063d5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801063d5:	6a 00                	push   $0x0
  pushl $0
801063d7:	6a 00                	push   $0x0
  jmp alltraps
801063d9:	e9 2b fb ff ff       	jmp    80105f09 <alltraps>

801063de <vector1>:
.globl vector1
vector1:
  pushl $0
801063de:	6a 00                	push   $0x0
  pushl $1
801063e0:	6a 01                	push   $0x1
  jmp alltraps
801063e2:	e9 22 fb ff ff       	jmp    80105f09 <alltraps>

801063e7 <vector2>:
.globl vector2
vector2:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $2
801063e9:	6a 02                	push   $0x2
  jmp alltraps
801063eb:	e9 19 fb ff ff       	jmp    80105f09 <alltraps>

801063f0 <vector3>:
.globl vector3
vector3:
  pushl $0
801063f0:	6a 00                	push   $0x0
  pushl $3
801063f2:	6a 03                	push   $0x3
  jmp alltraps
801063f4:	e9 10 fb ff ff       	jmp    80105f09 <alltraps>

801063f9 <vector4>:
.globl vector4
vector4:
  pushl $0
801063f9:	6a 00                	push   $0x0
  pushl $4
801063fb:	6a 04                	push   $0x4
  jmp alltraps
801063fd:	e9 07 fb ff ff       	jmp    80105f09 <alltraps>

80106402 <vector5>:
.globl vector5
vector5:
  pushl $0
80106402:	6a 00                	push   $0x0
  pushl $5
80106404:	6a 05                	push   $0x5
  jmp alltraps
80106406:	e9 fe fa ff ff       	jmp    80105f09 <alltraps>

8010640b <vector6>:
.globl vector6
vector6:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $6
8010640d:	6a 06                	push   $0x6
  jmp alltraps
8010640f:	e9 f5 fa ff ff       	jmp    80105f09 <alltraps>

80106414 <vector7>:
.globl vector7
vector7:
  pushl $0
80106414:	6a 00                	push   $0x0
  pushl $7
80106416:	6a 07                	push   $0x7
  jmp alltraps
80106418:	e9 ec fa ff ff       	jmp    80105f09 <alltraps>

8010641d <vector8>:
.globl vector8
vector8:
  pushl $8
8010641d:	6a 08                	push   $0x8
  jmp alltraps
8010641f:	e9 e5 fa ff ff       	jmp    80105f09 <alltraps>

80106424 <vector9>:
.globl vector9
vector9:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $9
80106426:	6a 09                	push   $0x9
  jmp alltraps
80106428:	e9 dc fa ff ff       	jmp    80105f09 <alltraps>

8010642d <vector10>:
.globl vector10
vector10:
  pushl $10
8010642d:	6a 0a                	push   $0xa
  jmp alltraps
8010642f:	e9 d5 fa ff ff       	jmp    80105f09 <alltraps>

80106434 <vector11>:
.globl vector11
vector11:
  pushl $11
80106434:	6a 0b                	push   $0xb
  jmp alltraps
80106436:	e9 ce fa ff ff       	jmp    80105f09 <alltraps>

8010643b <vector12>:
.globl vector12
vector12:
  pushl $12
8010643b:	6a 0c                	push   $0xc
  jmp alltraps
8010643d:	e9 c7 fa ff ff       	jmp    80105f09 <alltraps>

80106442 <vector13>:
.globl vector13
vector13:
  pushl $13
80106442:	6a 0d                	push   $0xd
  jmp alltraps
80106444:	e9 c0 fa ff ff       	jmp    80105f09 <alltraps>

80106449 <vector14>:
.globl vector14
vector14:
  pushl $14
80106449:	6a 0e                	push   $0xe
  jmp alltraps
8010644b:	e9 b9 fa ff ff       	jmp    80105f09 <alltraps>

80106450 <vector15>:
.globl vector15
vector15:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $15
80106452:	6a 0f                	push   $0xf
  jmp alltraps
80106454:	e9 b0 fa ff ff       	jmp    80105f09 <alltraps>

80106459 <vector16>:
.globl vector16
vector16:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $16
8010645b:	6a 10                	push   $0x10
  jmp alltraps
8010645d:	e9 a7 fa ff ff       	jmp    80105f09 <alltraps>

80106462 <vector17>:
.globl vector17
vector17:
  pushl $17
80106462:	6a 11                	push   $0x11
  jmp alltraps
80106464:	e9 a0 fa ff ff       	jmp    80105f09 <alltraps>

80106469 <vector18>:
.globl vector18
vector18:
  pushl $0
80106469:	6a 00                	push   $0x0
  pushl $18
8010646b:	6a 12                	push   $0x12
  jmp alltraps
8010646d:	e9 97 fa ff ff       	jmp    80105f09 <alltraps>

80106472 <vector19>:
.globl vector19
vector19:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $19
80106474:	6a 13                	push   $0x13
  jmp alltraps
80106476:	e9 8e fa ff ff       	jmp    80105f09 <alltraps>

8010647b <vector20>:
.globl vector20
vector20:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $20
8010647d:	6a 14                	push   $0x14
  jmp alltraps
8010647f:	e9 85 fa ff ff       	jmp    80105f09 <alltraps>

80106484 <vector21>:
.globl vector21
vector21:
  pushl $0
80106484:	6a 00                	push   $0x0
  pushl $21
80106486:	6a 15                	push   $0x15
  jmp alltraps
80106488:	e9 7c fa ff ff       	jmp    80105f09 <alltraps>

8010648d <vector22>:
.globl vector22
vector22:
  pushl $0
8010648d:	6a 00                	push   $0x0
  pushl $22
8010648f:	6a 16                	push   $0x16
  jmp alltraps
80106491:	e9 73 fa ff ff       	jmp    80105f09 <alltraps>

80106496 <vector23>:
.globl vector23
vector23:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $23
80106498:	6a 17                	push   $0x17
  jmp alltraps
8010649a:	e9 6a fa ff ff       	jmp    80105f09 <alltraps>

8010649f <vector24>:
.globl vector24
vector24:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $24
801064a1:	6a 18                	push   $0x18
  jmp alltraps
801064a3:	e9 61 fa ff ff       	jmp    80105f09 <alltraps>

801064a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801064a8:	6a 00                	push   $0x0
  pushl $25
801064aa:	6a 19                	push   $0x19
  jmp alltraps
801064ac:	e9 58 fa ff ff       	jmp    80105f09 <alltraps>

801064b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801064b1:	6a 00                	push   $0x0
  pushl $26
801064b3:	6a 1a                	push   $0x1a
  jmp alltraps
801064b5:	e9 4f fa ff ff       	jmp    80105f09 <alltraps>

801064ba <vector27>:
.globl vector27
vector27:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $27
801064bc:	6a 1b                	push   $0x1b
  jmp alltraps
801064be:	e9 46 fa ff ff       	jmp    80105f09 <alltraps>

801064c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $28
801064c5:	6a 1c                	push   $0x1c
  jmp alltraps
801064c7:	e9 3d fa ff ff       	jmp    80105f09 <alltraps>

801064cc <vector29>:
.globl vector29
vector29:
  pushl $0
801064cc:	6a 00                	push   $0x0
  pushl $29
801064ce:	6a 1d                	push   $0x1d
  jmp alltraps
801064d0:	e9 34 fa ff ff       	jmp    80105f09 <alltraps>

801064d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801064d5:	6a 00                	push   $0x0
  pushl $30
801064d7:	6a 1e                	push   $0x1e
  jmp alltraps
801064d9:	e9 2b fa ff ff       	jmp    80105f09 <alltraps>

801064de <vector31>:
.globl vector31
vector31:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $31
801064e0:	6a 1f                	push   $0x1f
  jmp alltraps
801064e2:	e9 22 fa ff ff       	jmp    80105f09 <alltraps>

801064e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $32
801064e9:	6a 20                	push   $0x20
  jmp alltraps
801064eb:	e9 19 fa ff ff       	jmp    80105f09 <alltraps>

801064f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801064f0:	6a 00                	push   $0x0
  pushl $33
801064f2:	6a 21                	push   $0x21
  jmp alltraps
801064f4:	e9 10 fa ff ff       	jmp    80105f09 <alltraps>

801064f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801064f9:	6a 00                	push   $0x0
  pushl $34
801064fb:	6a 22                	push   $0x22
  jmp alltraps
801064fd:	e9 07 fa ff ff       	jmp    80105f09 <alltraps>

80106502 <vector35>:
.globl vector35
vector35:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $35
80106504:	6a 23                	push   $0x23
  jmp alltraps
80106506:	e9 fe f9 ff ff       	jmp    80105f09 <alltraps>

8010650b <vector36>:
.globl vector36
vector36:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $36
8010650d:	6a 24                	push   $0x24
  jmp alltraps
8010650f:	e9 f5 f9 ff ff       	jmp    80105f09 <alltraps>

80106514 <vector37>:
.globl vector37
vector37:
  pushl $0
80106514:	6a 00                	push   $0x0
  pushl $37
80106516:	6a 25                	push   $0x25
  jmp alltraps
80106518:	e9 ec f9 ff ff       	jmp    80105f09 <alltraps>

8010651d <vector38>:
.globl vector38
vector38:
  pushl $0
8010651d:	6a 00                	push   $0x0
  pushl $38
8010651f:	6a 26                	push   $0x26
  jmp alltraps
80106521:	e9 e3 f9 ff ff       	jmp    80105f09 <alltraps>

80106526 <vector39>:
.globl vector39
vector39:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $39
80106528:	6a 27                	push   $0x27
  jmp alltraps
8010652a:	e9 da f9 ff ff       	jmp    80105f09 <alltraps>

8010652f <vector40>:
.globl vector40
vector40:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $40
80106531:	6a 28                	push   $0x28
  jmp alltraps
80106533:	e9 d1 f9 ff ff       	jmp    80105f09 <alltraps>

80106538 <vector41>:
.globl vector41
vector41:
  pushl $0
80106538:	6a 00                	push   $0x0
  pushl $41
8010653a:	6a 29                	push   $0x29
  jmp alltraps
8010653c:	e9 c8 f9 ff ff       	jmp    80105f09 <alltraps>

80106541 <vector42>:
.globl vector42
vector42:
  pushl $0
80106541:	6a 00                	push   $0x0
  pushl $42
80106543:	6a 2a                	push   $0x2a
  jmp alltraps
80106545:	e9 bf f9 ff ff       	jmp    80105f09 <alltraps>

8010654a <vector43>:
.globl vector43
vector43:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $43
8010654c:	6a 2b                	push   $0x2b
  jmp alltraps
8010654e:	e9 b6 f9 ff ff       	jmp    80105f09 <alltraps>

80106553 <vector44>:
.globl vector44
vector44:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $44
80106555:	6a 2c                	push   $0x2c
  jmp alltraps
80106557:	e9 ad f9 ff ff       	jmp    80105f09 <alltraps>

8010655c <vector45>:
.globl vector45
vector45:
  pushl $0
8010655c:	6a 00                	push   $0x0
  pushl $45
8010655e:	6a 2d                	push   $0x2d
  jmp alltraps
80106560:	e9 a4 f9 ff ff       	jmp    80105f09 <alltraps>

80106565 <vector46>:
.globl vector46
vector46:
  pushl $0
80106565:	6a 00                	push   $0x0
  pushl $46
80106567:	6a 2e                	push   $0x2e
  jmp alltraps
80106569:	e9 9b f9 ff ff       	jmp    80105f09 <alltraps>

8010656e <vector47>:
.globl vector47
vector47:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $47
80106570:	6a 2f                	push   $0x2f
  jmp alltraps
80106572:	e9 92 f9 ff ff       	jmp    80105f09 <alltraps>

80106577 <vector48>:
.globl vector48
vector48:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $48
80106579:	6a 30                	push   $0x30
  jmp alltraps
8010657b:	e9 89 f9 ff ff       	jmp    80105f09 <alltraps>

80106580 <vector49>:
.globl vector49
vector49:
  pushl $0
80106580:	6a 00                	push   $0x0
  pushl $49
80106582:	6a 31                	push   $0x31
  jmp alltraps
80106584:	e9 80 f9 ff ff       	jmp    80105f09 <alltraps>

80106589 <vector50>:
.globl vector50
vector50:
  pushl $0
80106589:	6a 00                	push   $0x0
  pushl $50
8010658b:	6a 32                	push   $0x32
  jmp alltraps
8010658d:	e9 77 f9 ff ff       	jmp    80105f09 <alltraps>

80106592 <vector51>:
.globl vector51
vector51:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $51
80106594:	6a 33                	push   $0x33
  jmp alltraps
80106596:	e9 6e f9 ff ff       	jmp    80105f09 <alltraps>

8010659b <vector52>:
.globl vector52
vector52:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $52
8010659d:	6a 34                	push   $0x34
  jmp alltraps
8010659f:	e9 65 f9 ff ff       	jmp    80105f09 <alltraps>

801065a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801065a4:	6a 00                	push   $0x0
  pushl $53
801065a6:	6a 35                	push   $0x35
  jmp alltraps
801065a8:	e9 5c f9 ff ff       	jmp    80105f09 <alltraps>

801065ad <vector54>:
.globl vector54
vector54:
  pushl $0
801065ad:	6a 00                	push   $0x0
  pushl $54
801065af:	6a 36                	push   $0x36
  jmp alltraps
801065b1:	e9 53 f9 ff ff       	jmp    80105f09 <alltraps>

801065b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $55
801065b8:	6a 37                	push   $0x37
  jmp alltraps
801065ba:	e9 4a f9 ff ff       	jmp    80105f09 <alltraps>

801065bf <vector56>:
.globl vector56
vector56:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $56
801065c1:	6a 38                	push   $0x38
  jmp alltraps
801065c3:	e9 41 f9 ff ff       	jmp    80105f09 <alltraps>

801065c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801065c8:	6a 00                	push   $0x0
  pushl $57
801065ca:	6a 39                	push   $0x39
  jmp alltraps
801065cc:	e9 38 f9 ff ff       	jmp    80105f09 <alltraps>

801065d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801065d1:	6a 00                	push   $0x0
  pushl $58
801065d3:	6a 3a                	push   $0x3a
  jmp alltraps
801065d5:	e9 2f f9 ff ff       	jmp    80105f09 <alltraps>

801065da <vector59>:
.globl vector59
vector59:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $59
801065dc:	6a 3b                	push   $0x3b
  jmp alltraps
801065de:	e9 26 f9 ff ff       	jmp    80105f09 <alltraps>

801065e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $60
801065e5:	6a 3c                	push   $0x3c
  jmp alltraps
801065e7:	e9 1d f9 ff ff       	jmp    80105f09 <alltraps>

801065ec <vector61>:
.globl vector61
vector61:
  pushl $0
801065ec:	6a 00                	push   $0x0
  pushl $61
801065ee:	6a 3d                	push   $0x3d
  jmp alltraps
801065f0:	e9 14 f9 ff ff       	jmp    80105f09 <alltraps>

801065f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801065f5:	6a 00                	push   $0x0
  pushl $62
801065f7:	6a 3e                	push   $0x3e
  jmp alltraps
801065f9:	e9 0b f9 ff ff       	jmp    80105f09 <alltraps>

801065fe <vector63>:
.globl vector63
vector63:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $63
80106600:	6a 3f                	push   $0x3f
  jmp alltraps
80106602:	e9 02 f9 ff ff       	jmp    80105f09 <alltraps>

80106607 <vector64>:
.globl vector64
vector64:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $64
80106609:	6a 40                	push   $0x40
  jmp alltraps
8010660b:	e9 f9 f8 ff ff       	jmp    80105f09 <alltraps>

80106610 <vector65>:
.globl vector65
vector65:
  pushl $0
80106610:	6a 00                	push   $0x0
  pushl $65
80106612:	6a 41                	push   $0x41
  jmp alltraps
80106614:	e9 f0 f8 ff ff       	jmp    80105f09 <alltraps>

80106619 <vector66>:
.globl vector66
vector66:
  pushl $0
80106619:	6a 00                	push   $0x0
  pushl $66
8010661b:	6a 42                	push   $0x42
  jmp alltraps
8010661d:	e9 e7 f8 ff ff       	jmp    80105f09 <alltraps>

80106622 <vector67>:
.globl vector67
vector67:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $67
80106624:	6a 43                	push   $0x43
  jmp alltraps
80106626:	e9 de f8 ff ff       	jmp    80105f09 <alltraps>

8010662b <vector68>:
.globl vector68
vector68:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $68
8010662d:	6a 44                	push   $0x44
  jmp alltraps
8010662f:	e9 d5 f8 ff ff       	jmp    80105f09 <alltraps>

80106634 <vector69>:
.globl vector69
vector69:
  pushl $0
80106634:	6a 00                	push   $0x0
  pushl $69
80106636:	6a 45                	push   $0x45
  jmp alltraps
80106638:	e9 cc f8 ff ff       	jmp    80105f09 <alltraps>

8010663d <vector70>:
.globl vector70
vector70:
  pushl $0
8010663d:	6a 00                	push   $0x0
  pushl $70
8010663f:	6a 46                	push   $0x46
  jmp alltraps
80106641:	e9 c3 f8 ff ff       	jmp    80105f09 <alltraps>

80106646 <vector71>:
.globl vector71
vector71:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $71
80106648:	6a 47                	push   $0x47
  jmp alltraps
8010664a:	e9 ba f8 ff ff       	jmp    80105f09 <alltraps>

8010664f <vector72>:
.globl vector72
vector72:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $72
80106651:	6a 48                	push   $0x48
  jmp alltraps
80106653:	e9 b1 f8 ff ff       	jmp    80105f09 <alltraps>

80106658 <vector73>:
.globl vector73
vector73:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $73
8010665a:	6a 49                	push   $0x49
  jmp alltraps
8010665c:	e9 a8 f8 ff ff       	jmp    80105f09 <alltraps>

80106661 <vector74>:
.globl vector74
vector74:
  pushl $0
80106661:	6a 00                	push   $0x0
  pushl $74
80106663:	6a 4a                	push   $0x4a
  jmp alltraps
80106665:	e9 9f f8 ff ff       	jmp    80105f09 <alltraps>

8010666a <vector75>:
.globl vector75
vector75:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $75
8010666c:	6a 4b                	push   $0x4b
  jmp alltraps
8010666e:	e9 96 f8 ff ff       	jmp    80105f09 <alltraps>

80106673 <vector76>:
.globl vector76
vector76:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $76
80106675:	6a 4c                	push   $0x4c
  jmp alltraps
80106677:	e9 8d f8 ff ff       	jmp    80105f09 <alltraps>

8010667c <vector77>:
.globl vector77
vector77:
  pushl $0
8010667c:	6a 00                	push   $0x0
  pushl $77
8010667e:	6a 4d                	push   $0x4d
  jmp alltraps
80106680:	e9 84 f8 ff ff       	jmp    80105f09 <alltraps>

80106685 <vector78>:
.globl vector78
vector78:
  pushl $0
80106685:	6a 00                	push   $0x0
  pushl $78
80106687:	6a 4e                	push   $0x4e
  jmp alltraps
80106689:	e9 7b f8 ff ff       	jmp    80105f09 <alltraps>

8010668e <vector79>:
.globl vector79
vector79:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $79
80106690:	6a 4f                	push   $0x4f
  jmp alltraps
80106692:	e9 72 f8 ff ff       	jmp    80105f09 <alltraps>

80106697 <vector80>:
.globl vector80
vector80:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $80
80106699:	6a 50                	push   $0x50
  jmp alltraps
8010669b:	e9 69 f8 ff ff       	jmp    80105f09 <alltraps>

801066a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801066a0:	6a 00                	push   $0x0
  pushl $81
801066a2:	6a 51                	push   $0x51
  jmp alltraps
801066a4:	e9 60 f8 ff ff       	jmp    80105f09 <alltraps>

801066a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801066a9:	6a 00                	push   $0x0
  pushl $82
801066ab:	6a 52                	push   $0x52
  jmp alltraps
801066ad:	e9 57 f8 ff ff       	jmp    80105f09 <alltraps>

801066b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $83
801066b4:	6a 53                	push   $0x53
  jmp alltraps
801066b6:	e9 4e f8 ff ff       	jmp    80105f09 <alltraps>

801066bb <vector84>:
.globl vector84
vector84:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $84
801066bd:	6a 54                	push   $0x54
  jmp alltraps
801066bf:	e9 45 f8 ff ff       	jmp    80105f09 <alltraps>

801066c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $85
801066c6:	6a 55                	push   $0x55
  jmp alltraps
801066c8:	e9 3c f8 ff ff       	jmp    80105f09 <alltraps>

801066cd <vector86>:
.globl vector86
vector86:
  pushl $0
801066cd:	6a 00                	push   $0x0
  pushl $86
801066cf:	6a 56                	push   $0x56
  jmp alltraps
801066d1:	e9 33 f8 ff ff       	jmp    80105f09 <alltraps>

801066d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $87
801066d8:	6a 57                	push   $0x57
  jmp alltraps
801066da:	e9 2a f8 ff ff       	jmp    80105f09 <alltraps>

801066df <vector88>:
.globl vector88
vector88:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $88
801066e1:	6a 58                	push   $0x58
  jmp alltraps
801066e3:	e9 21 f8 ff ff       	jmp    80105f09 <alltraps>

801066e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801066e8:	6a 00                	push   $0x0
  pushl $89
801066ea:	6a 59                	push   $0x59
  jmp alltraps
801066ec:	e9 18 f8 ff ff       	jmp    80105f09 <alltraps>

801066f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801066f1:	6a 00                	push   $0x0
  pushl $90
801066f3:	6a 5a                	push   $0x5a
  jmp alltraps
801066f5:	e9 0f f8 ff ff       	jmp    80105f09 <alltraps>

801066fa <vector91>:
.globl vector91
vector91:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $91
801066fc:	6a 5b                	push   $0x5b
  jmp alltraps
801066fe:	e9 06 f8 ff ff       	jmp    80105f09 <alltraps>

80106703 <vector92>:
.globl vector92
vector92:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $92
80106705:	6a 5c                	push   $0x5c
  jmp alltraps
80106707:	e9 fd f7 ff ff       	jmp    80105f09 <alltraps>

8010670c <vector93>:
.globl vector93
vector93:
  pushl $0
8010670c:	6a 00                	push   $0x0
  pushl $93
8010670e:	6a 5d                	push   $0x5d
  jmp alltraps
80106710:	e9 f4 f7 ff ff       	jmp    80105f09 <alltraps>

80106715 <vector94>:
.globl vector94
vector94:
  pushl $0
80106715:	6a 00                	push   $0x0
  pushl $94
80106717:	6a 5e                	push   $0x5e
  jmp alltraps
80106719:	e9 eb f7 ff ff       	jmp    80105f09 <alltraps>

8010671e <vector95>:
.globl vector95
vector95:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $95
80106720:	6a 5f                	push   $0x5f
  jmp alltraps
80106722:	e9 e2 f7 ff ff       	jmp    80105f09 <alltraps>

80106727 <vector96>:
.globl vector96
vector96:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $96
80106729:	6a 60                	push   $0x60
  jmp alltraps
8010672b:	e9 d9 f7 ff ff       	jmp    80105f09 <alltraps>

80106730 <vector97>:
.globl vector97
vector97:
  pushl $0
80106730:	6a 00                	push   $0x0
  pushl $97
80106732:	6a 61                	push   $0x61
  jmp alltraps
80106734:	e9 d0 f7 ff ff       	jmp    80105f09 <alltraps>

80106739 <vector98>:
.globl vector98
vector98:
  pushl $0
80106739:	6a 00                	push   $0x0
  pushl $98
8010673b:	6a 62                	push   $0x62
  jmp alltraps
8010673d:	e9 c7 f7 ff ff       	jmp    80105f09 <alltraps>

80106742 <vector99>:
.globl vector99
vector99:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $99
80106744:	6a 63                	push   $0x63
  jmp alltraps
80106746:	e9 be f7 ff ff       	jmp    80105f09 <alltraps>

8010674b <vector100>:
.globl vector100
vector100:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $100
8010674d:	6a 64                	push   $0x64
  jmp alltraps
8010674f:	e9 b5 f7 ff ff       	jmp    80105f09 <alltraps>

80106754 <vector101>:
.globl vector101
vector101:
  pushl $0
80106754:	6a 00                	push   $0x0
  pushl $101
80106756:	6a 65                	push   $0x65
  jmp alltraps
80106758:	e9 ac f7 ff ff       	jmp    80105f09 <alltraps>

8010675d <vector102>:
.globl vector102
vector102:
  pushl $0
8010675d:	6a 00                	push   $0x0
  pushl $102
8010675f:	6a 66                	push   $0x66
  jmp alltraps
80106761:	e9 a3 f7 ff ff       	jmp    80105f09 <alltraps>

80106766 <vector103>:
.globl vector103
vector103:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $103
80106768:	6a 67                	push   $0x67
  jmp alltraps
8010676a:	e9 9a f7 ff ff       	jmp    80105f09 <alltraps>

8010676f <vector104>:
.globl vector104
vector104:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $104
80106771:	6a 68                	push   $0x68
  jmp alltraps
80106773:	e9 91 f7 ff ff       	jmp    80105f09 <alltraps>

80106778 <vector105>:
.globl vector105
vector105:
  pushl $0
80106778:	6a 00                	push   $0x0
  pushl $105
8010677a:	6a 69                	push   $0x69
  jmp alltraps
8010677c:	e9 88 f7 ff ff       	jmp    80105f09 <alltraps>

80106781 <vector106>:
.globl vector106
vector106:
  pushl $0
80106781:	6a 00                	push   $0x0
  pushl $106
80106783:	6a 6a                	push   $0x6a
  jmp alltraps
80106785:	e9 7f f7 ff ff       	jmp    80105f09 <alltraps>

8010678a <vector107>:
.globl vector107
vector107:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $107
8010678c:	6a 6b                	push   $0x6b
  jmp alltraps
8010678e:	e9 76 f7 ff ff       	jmp    80105f09 <alltraps>

80106793 <vector108>:
.globl vector108
vector108:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $108
80106795:	6a 6c                	push   $0x6c
  jmp alltraps
80106797:	e9 6d f7 ff ff       	jmp    80105f09 <alltraps>

8010679c <vector109>:
.globl vector109
vector109:
  pushl $0
8010679c:	6a 00                	push   $0x0
  pushl $109
8010679e:	6a 6d                	push   $0x6d
  jmp alltraps
801067a0:	e9 64 f7 ff ff       	jmp    80105f09 <alltraps>

801067a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801067a5:	6a 00                	push   $0x0
  pushl $110
801067a7:	6a 6e                	push   $0x6e
  jmp alltraps
801067a9:	e9 5b f7 ff ff       	jmp    80105f09 <alltraps>

801067ae <vector111>:
.globl vector111
vector111:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $111
801067b0:	6a 6f                	push   $0x6f
  jmp alltraps
801067b2:	e9 52 f7 ff ff       	jmp    80105f09 <alltraps>

801067b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $112
801067b9:	6a 70                	push   $0x70
  jmp alltraps
801067bb:	e9 49 f7 ff ff       	jmp    80105f09 <alltraps>

801067c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801067c0:	6a 00                	push   $0x0
  pushl $113
801067c2:	6a 71                	push   $0x71
  jmp alltraps
801067c4:	e9 40 f7 ff ff       	jmp    80105f09 <alltraps>

801067c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $114
801067cb:	6a 72                	push   $0x72
  jmp alltraps
801067cd:	e9 37 f7 ff ff       	jmp    80105f09 <alltraps>

801067d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $115
801067d4:	6a 73                	push   $0x73
  jmp alltraps
801067d6:	e9 2e f7 ff ff       	jmp    80105f09 <alltraps>

801067db <vector116>:
.globl vector116
vector116:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $116
801067dd:	6a 74                	push   $0x74
  jmp alltraps
801067df:	e9 25 f7 ff ff       	jmp    80105f09 <alltraps>

801067e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $117
801067e6:	6a 75                	push   $0x75
  jmp alltraps
801067e8:	e9 1c f7 ff ff       	jmp    80105f09 <alltraps>

801067ed <vector118>:
.globl vector118
vector118:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $118
801067ef:	6a 76                	push   $0x76
  jmp alltraps
801067f1:	e9 13 f7 ff ff       	jmp    80105f09 <alltraps>

801067f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $119
801067f8:	6a 77                	push   $0x77
  jmp alltraps
801067fa:	e9 0a f7 ff ff       	jmp    80105f09 <alltraps>

801067ff <vector120>:
.globl vector120
vector120:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $120
80106801:	6a 78                	push   $0x78
  jmp alltraps
80106803:	e9 01 f7 ff ff       	jmp    80105f09 <alltraps>

80106808 <vector121>:
.globl vector121
vector121:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $121
8010680a:	6a 79                	push   $0x79
  jmp alltraps
8010680c:	e9 f8 f6 ff ff       	jmp    80105f09 <alltraps>

80106811 <vector122>:
.globl vector122
vector122:
  pushl $0
80106811:	6a 00                	push   $0x0
  pushl $122
80106813:	6a 7a                	push   $0x7a
  jmp alltraps
80106815:	e9 ef f6 ff ff       	jmp    80105f09 <alltraps>

8010681a <vector123>:
.globl vector123
vector123:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $123
8010681c:	6a 7b                	push   $0x7b
  jmp alltraps
8010681e:	e9 e6 f6 ff ff       	jmp    80105f09 <alltraps>

80106823 <vector124>:
.globl vector124
vector124:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $124
80106825:	6a 7c                	push   $0x7c
  jmp alltraps
80106827:	e9 dd f6 ff ff       	jmp    80105f09 <alltraps>

8010682c <vector125>:
.globl vector125
vector125:
  pushl $0
8010682c:	6a 00                	push   $0x0
  pushl $125
8010682e:	6a 7d                	push   $0x7d
  jmp alltraps
80106830:	e9 d4 f6 ff ff       	jmp    80105f09 <alltraps>

80106835 <vector126>:
.globl vector126
vector126:
  pushl $0
80106835:	6a 00                	push   $0x0
  pushl $126
80106837:	6a 7e                	push   $0x7e
  jmp alltraps
80106839:	e9 cb f6 ff ff       	jmp    80105f09 <alltraps>

8010683e <vector127>:
.globl vector127
vector127:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $127
80106840:	6a 7f                	push   $0x7f
  jmp alltraps
80106842:	e9 c2 f6 ff ff       	jmp    80105f09 <alltraps>

80106847 <vector128>:
.globl vector128
vector128:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $128
80106849:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010684e:	e9 b6 f6 ff ff       	jmp    80105f09 <alltraps>

80106853 <vector129>:
.globl vector129
vector129:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $129
80106855:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010685a:	e9 aa f6 ff ff       	jmp    80105f09 <alltraps>

8010685f <vector130>:
.globl vector130
vector130:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $130
80106861:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106866:	e9 9e f6 ff ff       	jmp    80105f09 <alltraps>

8010686b <vector131>:
.globl vector131
vector131:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $131
8010686d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106872:	e9 92 f6 ff ff       	jmp    80105f09 <alltraps>

80106877 <vector132>:
.globl vector132
vector132:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $132
80106879:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010687e:	e9 86 f6 ff ff       	jmp    80105f09 <alltraps>

80106883 <vector133>:
.globl vector133
vector133:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $133
80106885:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010688a:	e9 7a f6 ff ff       	jmp    80105f09 <alltraps>

8010688f <vector134>:
.globl vector134
vector134:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $134
80106891:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106896:	e9 6e f6 ff ff       	jmp    80105f09 <alltraps>

8010689b <vector135>:
.globl vector135
vector135:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $135
8010689d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801068a2:	e9 62 f6 ff ff       	jmp    80105f09 <alltraps>

801068a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $136
801068a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801068ae:	e9 56 f6 ff ff       	jmp    80105f09 <alltraps>

801068b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $137
801068b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801068ba:	e9 4a f6 ff ff       	jmp    80105f09 <alltraps>

801068bf <vector138>:
.globl vector138
vector138:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $138
801068c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801068c6:	e9 3e f6 ff ff       	jmp    80105f09 <alltraps>

801068cb <vector139>:
.globl vector139
vector139:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $139
801068cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801068d2:	e9 32 f6 ff ff       	jmp    80105f09 <alltraps>

801068d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $140
801068d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801068de:	e9 26 f6 ff ff       	jmp    80105f09 <alltraps>

801068e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $141
801068e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801068ea:	e9 1a f6 ff ff       	jmp    80105f09 <alltraps>

801068ef <vector142>:
.globl vector142
vector142:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $142
801068f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801068f6:	e9 0e f6 ff ff       	jmp    80105f09 <alltraps>

801068fb <vector143>:
.globl vector143
vector143:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $143
801068fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106902:	e9 02 f6 ff ff       	jmp    80105f09 <alltraps>

80106907 <vector144>:
.globl vector144
vector144:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $144
80106909:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010690e:	e9 f6 f5 ff ff       	jmp    80105f09 <alltraps>

80106913 <vector145>:
.globl vector145
vector145:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $145
80106915:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010691a:	e9 ea f5 ff ff       	jmp    80105f09 <alltraps>

8010691f <vector146>:
.globl vector146
vector146:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $146
80106921:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106926:	e9 de f5 ff ff       	jmp    80105f09 <alltraps>

8010692b <vector147>:
.globl vector147
vector147:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $147
8010692d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106932:	e9 d2 f5 ff ff       	jmp    80105f09 <alltraps>

80106937 <vector148>:
.globl vector148
vector148:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $148
80106939:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010693e:	e9 c6 f5 ff ff       	jmp    80105f09 <alltraps>

80106943 <vector149>:
.globl vector149
vector149:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $149
80106945:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010694a:	e9 ba f5 ff ff       	jmp    80105f09 <alltraps>

8010694f <vector150>:
.globl vector150
vector150:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $150
80106951:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106956:	e9 ae f5 ff ff       	jmp    80105f09 <alltraps>

8010695b <vector151>:
.globl vector151
vector151:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $151
8010695d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106962:	e9 a2 f5 ff ff       	jmp    80105f09 <alltraps>

80106967 <vector152>:
.globl vector152
vector152:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $152
80106969:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010696e:	e9 96 f5 ff ff       	jmp    80105f09 <alltraps>

80106973 <vector153>:
.globl vector153
vector153:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $153
80106975:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010697a:	e9 8a f5 ff ff       	jmp    80105f09 <alltraps>

8010697f <vector154>:
.globl vector154
vector154:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $154
80106981:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106986:	e9 7e f5 ff ff       	jmp    80105f09 <alltraps>

8010698b <vector155>:
.globl vector155
vector155:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $155
8010698d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106992:	e9 72 f5 ff ff       	jmp    80105f09 <alltraps>

80106997 <vector156>:
.globl vector156
vector156:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $156
80106999:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010699e:	e9 66 f5 ff ff       	jmp    80105f09 <alltraps>

801069a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $157
801069a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801069aa:	e9 5a f5 ff ff       	jmp    80105f09 <alltraps>

801069af <vector158>:
.globl vector158
vector158:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $158
801069b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801069b6:	e9 4e f5 ff ff       	jmp    80105f09 <alltraps>

801069bb <vector159>:
.globl vector159
vector159:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $159
801069bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801069c2:	e9 42 f5 ff ff       	jmp    80105f09 <alltraps>

801069c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $160
801069c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801069ce:	e9 36 f5 ff ff       	jmp    80105f09 <alltraps>

801069d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $161
801069d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801069da:	e9 2a f5 ff ff       	jmp    80105f09 <alltraps>

801069df <vector162>:
.globl vector162
vector162:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $162
801069e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801069e6:	e9 1e f5 ff ff       	jmp    80105f09 <alltraps>

801069eb <vector163>:
.globl vector163
vector163:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $163
801069ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801069f2:	e9 12 f5 ff ff       	jmp    80105f09 <alltraps>

801069f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $164
801069f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801069fe:	e9 06 f5 ff ff       	jmp    80105f09 <alltraps>

80106a03 <vector165>:
.globl vector165
vector165:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $165
80106a05:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106a0a:	e9 fa f4 ff ff       	jmp    80105f09 <alltraps>

80106a0f <vector166>:
.globl vector166
vector166:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $166
80106a11:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106a16:	e9 ee f4 ff ff       	jmp    80105f09 <alltraps>

80106a1b <vector167>:
.globl vector167
vector167:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $167
80106a1d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106a22:	e9 e2 f4 ff ff       	jmp    80105f09 <alltraps>

80106a27 <vector168>:
.globl vector168
vector168:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $168
80106a29:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106a2e:	e9 d6 f4 ff ff       	jmp    80105f09 <alltraps>

80106a33 <vector169>:
.globl vector169
vector169:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $169
80106a35:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106a3a:	e9 ca f4 ff ff       	jmp    80105f09 <alltraps>

80106a3f <vector170>:
.globl vector170
vector170:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $170
80106a41:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106a46:	e9 be f4 ff ff       	jmp    80105f09 <alltraps>

80106a4b <vector171>:
.globl vector171
vector171:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $171
80106a4d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106a52:	e9 b2 f4 ff ff       	jmp    80105f09 <alltraps>

80106a57 <vector172>:
.globl vector172
vector172:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $172
80106a59:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106a5e:	e9 a6 f4 ff ff       	jmp    80105f09 <alltraps>

80106a63 <vector173>:
.globl vector173
vector173:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $173
80106a65:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106a6a:	e9 9a f4 ff ff       	jmp    80105f09 <alltraps>

80106a6f <vector174>:
.globl vector174
vector174:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $174
80106a71:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106a76:	e9 8e f4 ff ff       	jmp    80105f09 <alltraps>

80106a7b <vector175>:
.globl vector175
vector175:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $175
80106a7d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106a82:	e9 82 f4 ff ff       	jmp    80105f09 <alltraps>

80106a87 <vector176>:
.globl vector176
vector176:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $176
80106a89:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106a8e:	e9 76 f4 ff ff       	jmp    80105f09 <alltraps>

80106a93 <vector177>:
.globl vector177
vector177:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $177
80106a95:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106a9a:	e9 6a f4 ff ff       	jmp    80105f09 <alltraps>

80106a9f <vector178>:
.globl vector178
vector178:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $178
80106aa1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106aa6:	e9 5e f4 ff ff       	jmp    80105f09 <alltraps>

80106aab <vector179>:
.globl vector179
vector179:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $179
80106aad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ab2:	e9 52 f4 ff ff       	jmp    80105f09 <alltraps>

80106ab7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $180
80106ab9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106abe:	e9 46 f4 ff ff       	jmp    80105f09 <alltraps>

80106ac3 <vector181>:
.globl vector181
vector181:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $181
80106ac5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106aca:	e9 3a f4 ff ff       	jmp    80105f09 <alltraps>

80106acf <vector182>:
.globl vector182
vector182:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $182
80106ad1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106ad6:	e9 2e f4 ff ff       	jmp    80105f09 <alltraps>

80106adb <vector183>:
.globl vector183
vector183:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $183
80106add:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ae2:	e9 22 f4 ff ff       	jmp    80105f09 <alltraps>

80106ae7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $184
80106ae9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106aee:	e9 16 f4 ff ff       	jmp    80105f09 <alltraps>

80106af3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $185
80106af5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106afa:	e9 0a f4 ff ff       	jmp    80105f09 <alltraps>

80106aff <vector186>:
.globl vector186
vector186:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $186
80106b01:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106b06:	e9 fe f3 ff ff       	jmp    80105f09 <alltraps>

80106b0b <vector187>:
.globl vector187
vector187:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $187
80106b0d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106b12:	e9 f2 f3 ff ff       	jmp    80105f09 <alltraps>

80106b17 <vector188>:
.globl vector188
vector188:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $188
80106b19:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106b1e:	e9 e6 f3 ff ff       	jmp    80105f09 <alltraps>

80106b23 <vector189>:
.globl vector189
vector189:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $189
80106b25:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106b2a:	e9 da f3 ff ff       	jmp    80105f09 <alltraps>

80106b2f <vector190>:
.globl vector190
vector190:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $190
80106b31:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106b36:	e9 ce f3 ff ff       	jmp    80105f09 <alltraps>

80106b3b <vector191>:
.globl vector191
vector191:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $191
80106b3d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106b42:	e9 c2 f3 ff ff       	jmp    80105f09 <alltraps>

80106b47 <vector192>:
.globl vector192
vector192:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $192
80106b49:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106b4e:	e9 b6 f3 ff ff       	jmp    80105f09 <alltraps>

80106b53 <vector193>:
.globl vector193
vector193:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $193
80106b55:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106b5a:	e9 aa f3 ff ff       	jmp    80105f09 <alltraps>

80106b5f <vector194>:
.globl vector194
vector194:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $194
80106b61:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106b66:	e9 9e f3 ff ff       	jmp    80105f09 <alltraps>

80106b6b <vector195>:
.globl vector195
vector195:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $195
80106b6d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106b72:	e9 92 f3 ff ff       	jmp    80105f09 <alltraps>

80106b77 <vector196>:
.globl vector196
vector196:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $196
80106b79:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106b7e:	e9 86 f3 ff ff       	jmp    80105f09 <alltraps>

80106b83 <vector197>:
.globl vector197
vector197:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $197
80106b85:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106b8a:	e9 7a f3 ff ff       	jmp    80105f09 <alltraps>

80106b8f <vector198>:
.globl vector198
vector198:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $198
80106b91:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106b96:	e9 6e f3 ff ff       	jmp    80105f09 <alltraps>

80106b9b <vector199>:
.globl vector199
vector199:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $199
80106b9d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ba2:	e9 62 f3 ff ff       	jmp    80105f09 <alltraps>

80106ba7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $200
80106ba9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106bae:	e9 56 f3 ff ff       	jmp    80105f09 <alltraps>

80106bb3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $201
80106bb5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106bba:	e9 4a f3 ff ff       	jmp    80105f09 <alltraps>

80106bbf <vector202>:
.globl vector202
vector202:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $202
80106bc1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106bc6:	e9 3e f3 ff ff       	jmp    80105f09 <alltraps>

80106bcb <vector203>:
.globl vector203
vector203:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $203
80106bcd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106bd2:	e9 32 f3 ff ff       	jmp    80105f09 <alltraps>

80106bd7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $204
80106bd9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106bde:	e9 26 f3 ff ff       	jmp    80105f09 <alltraps>

80106be3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $205
80106be5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106bea:	e9 1a f3 ff ff       	jmp    80105f09 <alltraps>

80106bef <vector206>:
.globl vector206
vector206:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $206
80106bf1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106bf6:	e9 0e f3 ff ff       	jmp    80105f09 <alltraps>

80106bfb <vector207>:
.globl vector207
vector207:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $207
80106bfd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106c02:	e9 02 f3 ff ff       	jmp    80105f09 <alltraps>

80106c07 <vector208>:
.globl vector208
vector208:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $208
80106c09:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106c0e:	e9 f6 f2 ff ff       	jmp    80105f09 <alltraps>

80106c13 <vector209>:
.globl vector209
vector209:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $209
80106c15:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106c1a:	e9 ea f2 ff ff       	jmp    80105f09 <alltraps>

80106c1f <vector210>:
.globl vector210
vector210:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $210
80106c21:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106c26:	e9 de f2 ff ff       	jmp    80105f09 <alltraps>

80106c2b <vector211>:
.globl vector211
vector211:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $211
80106c2d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106c32:	e9 d2 f2 ff ff       	jmp    80105f09 <alltraps>

80106c37 <vector212>:
.globl vector212
vector212:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $212
80106c39:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106c3e:	e9 c6 f2 ff ff       	jmp    80105f09 <alltraps>

80106c43 <vector213>:
.globl vector213
vector213:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $213
80106c45:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106c4a:	e9 ba f2 ff ff       	jmp    80105f09 <alltraps>

80106c4f <vector214>:
.globl vector214
vector214:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $214
80106c51:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106c56:	e9 ae f2 ff ff       	jmp    80105f09 <alltraps>

80106c5b <vector215>:
.globl vector215
vector215:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $215
80106c5d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106c62:	e9 a2 f2 ff ff       	jmp    80105f09 <alltraps>

80106c67 <vector216>:
.globl vector216
vector216:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $216
80106c69:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106c6e:	e9 96 f2 ff ff       	jmp    80105f09 <alltraps>

80106c73 <vector217>:
.globl vector217
vector217:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $217
80106c75:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106c7a:	e9 8a f2 ff ff       	jmp    80105f09 <alltraps>

80106c7f <vector218>:
.globl vector218
vector218:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $218
80106c81:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106c86:	e9 7e f2 ff ff       	jmp    80105f09 <alltraps>

80106c8b <vector219>:
.globl vector219
vector219:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $219
80106c8d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106c92:	e9 72 f2 ff ff       	jmp    80105f09 <alltraps>

80106c97 <vector220>:
.globl vector220
vector220:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $220
80106c99:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106c9e:	e9 66 f2 ff ff       	jmp    80105f09 <alltraps>

80106ca3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $221
80106ca5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106caa:	e9 5a f2 ff ff       	jmp    80105f09 <alltraps>

80106caf <vector222>:
.globl vector222
vector222:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $222
80106cb1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106cb6:	e9 4e f2 ff ff       	jmp    80105f09 <alltraps>

80106cbb <vector223>:
.globl vector223
vector223:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $223
80106cbd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106cc2:	e9 42 f2 ff ff       	jmp    80105f09 <alltraps>

80106cc7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $224
80106cc9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106cce:	e9 36 f2 ff ff       	jmp    80105f09 <alltraps>

80106cd3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $225
80106cd5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106cda:	e9 2a f2 ff ff       	jmp    80105f09 <alltraps>

80106cdf <vector226>:
.globl vector226
vector226:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $226
80106ce1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ce6:	e9 1e f2 ff ff       	jmp    80105f09 <alltraps>

80106ceb <vector227>:
.globl vector227
vector227:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $227
80106ced:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106cf2:	e9 12 f2 ff ff       	jmp    80105f09 <alltraps>

80106cf7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $228
80106cf9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106cfe:	e9 06 f2 ff ff       	jmp    80105f09 <alltraps>

80106d03 <vector229>:
.globl vector229
vector229:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $229
80106d05:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106d0a:	e9 fa f1 ff ff       	jmp    80105f09 <alltraps>

80106d0f <vector230>:
.globl vector230
vector230:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $230
80106d11:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106d16:	e9 ee f1 ff ff       	jmp    80105f09 <alltraps>

80106d1b <vector231>:
.globl vector231
vector231:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $231
80106d1d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106d22:	e9 e2 f1 ff ff       	jmp    80105f09 <alltraps>

80106d27 <vector232>:
.globl vector232
vector232:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $232
80106d29:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106d2e:	e9 d6 f1 ff ff       	jmp    80105f09 <alltraps>

80106d33 <vector233>:
.globl vector233
vector233:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $233
80106d35:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106d3a:	e9 ca f1 ff ff       	jmp    80105f09 <alltraps>

80106d3f <vector234>:
.globl vector234
vector234:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $234
80106d41:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106d46:	e9 be f1 ff ff       	jmp    80105f09 <alltraps>

80106d4b <vector235>:
.globl vector235
vector235:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $235
80106d4d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106d52:	e9 b2 f1 ff ff       	jmp    80105f09 <alltraps>

80106d57 <vector236>:
.globl vector236
vector236:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $236
80106d59:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106d5e:	e9 a6 f1 ff ff       	jmp    80105f09 <alltraps>

80106d63 <vector237>:
.globl vector237
vector237:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $237
80106d65:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106d6a:	e9 9a f1 ff ff       	jmp    80105f09 <alltraps>

80106d6f <vector238>:
.globl vector238
vector238:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $238
80106d71:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106d76:	e9 8e f1 ff ff       	jmp    80105f09 <alltraps>

80106d7b <vector239>:
.globl vector239
vector239:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $239
80106d7d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106d82:	e9 82 f1 ff ff       	jmp    80105f09 <alltraps>

80106d87 <vector240>:
.globl vector240
vector240:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $240
80106d89:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106d8e:	e9 76 f1 ff ff       	jmp    80105f09 <alltraps>

80106d93 <vector241>:
.globl vector241
vector241:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $241
80106d95:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106d9a:	e9 6a f1 ff ff       	jmp    80105f09 <alltraps>

80106d9f <vector242>:
.globl vector242
vector242:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $242
80106da1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106da6:	e9 5e f1 ff ff       	jmp    80105f09 <alltraps>

80106dab <vector243>:
.globl vector243
vector243:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $243
80106dad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106db2:	e9 52 f1 ff ff       	jmp    80105f09 <alltraps>

80106db7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $244
80106db9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106dbe:	e9 46 f1 ff ff       	jmp    80105f09 <alltraps>

80106dc3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $245
80106dc5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106dca:	e9 3a f1 ff ff       	jmp    80105f09 <alltraps>

80106dcf <vector246>:
.globl vector246
vector246:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $246
80106dd1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106dd6:	e9 2e f1 ff ff       	jmp    80105f09 <alltraps>

80106ddb <vector247>:
.globl vector247
vector247:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $247
80106ddd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106de2:	e9 22 f1 ff ff       	jmp    80105f09 <alltraps>

80106de7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $248
80106de9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106dee:	e9 16 f1 ff ff       	jmp    80105f09 <alltraps>

80106df3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $249
80106df5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106dfa:	e9 0a f1 ff ff       	jmp    80105f09 <alltraps>

80106dff <vector250>:
.globl vector250
vector250:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $250
80106e01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106e06:	e9 fe f0 ff ff       	jmp    80105f09 <alltraps>

80106e0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $251
80106e0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106e12:	e9 f2 f0 ff ff       	jmp    80105f09 <alltraps>

80106e17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $252
80106e19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106e1e:	e9 e6 f0 ff ff       	jmp    80105f09 <alltraps>

80106e23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $253
80106e25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106e2a:	e9 da f0 ff ff       	jmp    80105f09 <alltraps>

80106e2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $254
80106e31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106e36:	e9 ce f0 ff ff       	jmp    80105f09 <alltraps>

80106e3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $255
80106e3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106e42:	e9 c2 f0 ff ff       	jmp    80105f09 <alltraps>
80106e47:	66 90                	xchg   %ax,%ax
80106e49:	66 90                	xchg   %ax,%ax
80106e4b:	66 90                	xchg   %ax,%ax
80106e4d:	66 90                	xchg   %ax,%ax
80106e4f:	90                   	nop

80106e50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80106e56:	89 d3                	mov    %edx,%ebx
{
80106e58:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106e5a:	c1 eb 16             	shr    $0x16,%ebx
80106e5d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106e60:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106e63:	8b 06                	mov    (%esi),%eax
80106e65:	a8 01                	test   $0x1,%al
80106e67:	74 27                	je     80106e90 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e6e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106e74:	c1 ef 0a             	shr    $0xa,%edi
}
80106e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106e7a:	89 fa                	mov    %edi,%edx
80106e7c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e82:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106e85:	5b                   	pop    %ebx
80106e86:	5e                   	pop    %esi
80106e87:	5f                   	pop    %edi
80106e88:	5d                   	pop    %ebp
80106e89:	c3                   	ret    
80106e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e90:	85 c9                	test   %ecx,%ecx
80106e92:	74 2c                	je     80106ec0 <walkpgdir+0x70>
80106e94:	e8 27 bb ff ff       	call   801029c0 <kalloc>
80106e99:	85 c0                	test   %eax,%eax
80106e9b:	89 c3                	mov    %eax,%ebx
80106e9d:	74 21                	je     80106ec0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106e9f:	83 ec 04             	sub    $0x4,%esp
80106ea2:	68 00 10 00 00       	push   $0x1000
80106ea7:	6a 00                	push   $0x0
80106ea9:	50                   	push   %eax
80106eaa:	e8 11 de ff ff       	call   80104cc0 <memset>
80106eaf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80106eb5:	83 c4 10             	add    $0x10,%esp
80106eb8:	83 c8 07             	or     $0x7,%eax
80106ebb:	89 06                	mov    %eax,(%esi)
80106ebd:	eb b5                	jmp    80106e74 <walkpgdir+0x24>
80106ebf:	90                   	nop
}
80106ec0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ec3:	31 c0                	xor    %eax,%eax
}
80106ec5:	5b                   	pop    %ebx
80106ec6:	5e                   	pop    %esi
80106ec7:	5f                   	pop    %edi
80106ec8:	5d                   	pop    %ebp
80106ec9:	c3                   	ret    
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ed0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ed6:	89 d3                	mov    %edx,%ebx
80106ed8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ede:	83 ec 1c             	sub    $0x1c,%esp
80106ee1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ee4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ee8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106eeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ef0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ef6:	29 df                	sub    %ebx,%edi
80106ef8:	83 c8 01             	or     $0x1,%eax
80106efb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106efe:	eb 15                	jmp    80106f15 <mappages+0x45>
    if(*pte & PTE_P)
80106f00:	f6 00 01             	testb  $0x1,(%eax)
80106f03:	75 45                	jne    80106f4a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106f05:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106f08:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106f0b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106f0d:	74 31                	je     80106f40 <mappages+0x70>
      break;
    a += PGSIZE;
80106f0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106f15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f18:	b9 01 00 00 00       	mov    $0x1,%ecx
80106f1d:	89 da                	mov    %ebx,%edx
80106f1f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106f22:	e8 29 ff ff ff       	call   80106e50 <walkpgdir>
80106f27:	85 c0                	test   %eax,%eax
80106f29:	75 d5                	jne    80106f00 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f33:	5b                   	pop    %ebx
80106f34:	5e                   	pop    %esi
80106f35:	5f                   	pop    %edi
80106f36:	5d                   	pop    %ebp
80106f37:	c3                   	ret    
80106f38:	90                   	nop
80106f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f43:	31 c0                	xor    %eax,%eax
}
80106f45:	5b                   	pop    %ebx
80106f46:	5e                   	pop    %esi
80106f47:	5f                   	pop    %edi
80106f48:	5d                   	pop    %ebp
80106f49:	c3                   	ret    
      panic("remap");
80106f4a:	83 ec 0c             	sub    $0xc,%esp
80106f4d:	68 b4 88 10 80       	push   $0x801088b4
80106f52:	e8 39 94 ff ff       	call   80100390 <panic>
80106f57:	89 f6                	mov    %esi,%esi
80106f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f60 <seginit>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106f66:	e8 35 cf ff ff       	call   80103ea0 <cpuid>
80106f6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106f71:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106f76:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106f7a:	c7 80 38 58 19 80 ff 	movl   $0xffff,-0x7fe6a7c8(%eax)
80106f81:	ff 00 00 
80106f84:	c7 80 3c 58 19 80 00 	movl   $0xcf9a00,-0x7fe6a7c4(%eax)
80106f8b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106f8e:	c7 80 40 58 19 80 ff 	movl   $0xffff,-0x7fe6a7c0(%eax)
80106f95:	ff 00 00 
80106f98:	c7 80 44 58 19 80 00 	movl   $0xcf9200,-0x7fe6a7bc(%eax)
80106f9f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fa2:	c7 80 48 58 19 80 ff 	movl   $0xffff,-0x7fe6a7b8(%eax)
80106fa9:	ff 00 00 
80106fac:	c7 80 4c 58 19 80 00 	movl   $0xcffa00,-0x7fe6a7b4(%eax)
80106fb3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fb6:	c7 80 50 58 19 80 ff 	movl   $0xffff,-0x7fe6a7b0(%eax)
80106fbd:	ff 00 00 
80106fc0:	c7 80 54 58 19 80 00 	movl   $0xcff200,-0x7fe6a7ac(%eax)
80106fc7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106fca:	05 30 58 19 80       	add    $0x80195830,%eax
  pd[1] = (uint)p;
80106fcf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106fd3:	c1 e8 10             	shr    $0x10,%eax
80106fd6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106fda:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106fdd:	0f 01 10             	lgdtl  (%eax)
}
80106fe0:	c9                   	leave  
80106fe1:	c3                   	ret    
80106fe2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ff0 <switchkvm>:
80106ff0:	a1 e4 09 1a 80       	mov    0x801a09e4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106ff5:	55                   	push   %ebp
80106ff6:	89 e5                	mov    %esp,%ebp
80106ff8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ffd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(v2p(kpgdir));   // switch to the kernel page table
}
80107000:	5d                   	pop    %ebp
80107001:	c3                   	ret    
80107002:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107010 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107010:	55                   	push   %ebp
80107011:	89 e5                	mov    %esp,%ebp
80107013:	57                   	push   %edi
80107014:	56                   	push   %esi
80107015:	53                   	push   %ebx
80107016:	83 ec 1c             	sub    $0x1c,%esp
80107019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010701c:	85 db                	test   %ebx,%ebx
8010701e:	0f 84 cb 00 00 00    	je     801070ef <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107024:	8b 43 08             	mov    0x8(%ebx),%eax
80107027:	85 c0                	test   %eax,%eax
80107029:	0f 84 da 00 00 00    	je     80107109 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010702f:	8b 43 04             	mov    0x4(%ebx),%eax
80107032:	85 c0                	test   %eax,%eax
80107034:	0f 84 c2 00 00 00    	je     801070fc <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010703a:	e8 a1 da ff ff       	call   80104ae0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010703f:	e8 dc cd ff ff       	call   80103e20 <mycpu>
80107044:	89 c6                	mov    %eax,%esi
80107046:	e8 d5 cd ff ff       	call   80103e20 <mycpu>
8010704b:	89 c7                	mov    %eax,%edi
8010704d:	e8 ce cd ff ff       	call   80103e20 <mycpu>
80107052:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107055:	83 c7 08             	add    $0x8,%edi
80107058:	e8 c3 cd ff ff       	call   80103e20 <mycpu>
8010705d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107060:	83 c0 08             	add    $0x8,%eax
80107063:	ba 67 00 00 00       	mov    $0x67,%edx
80107068:	c1 e8 18             	shr    $0x18,%eax
8010706b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107072:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107079:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010707f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107084:	83 c1 08             	add    $0x8,%ecx
80107087:	c1 e9 10             	shr    $0x10,%ecx
8010708a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107090:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107095:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010709c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801070a1:	e8 7a cd ff ff       	call   80103e20 <mycpu>
801070a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801070ad:	e8 6e cd ff ff       	call   80103e20 <mycpu>
801070b2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801070b6:	8b 73 08             	mov    0x8(%ebx),%esi
801070b9:	e8 62 cd ff ff       	call   80103e20 <mycpu>
801070be:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070c4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801070c7:	e8 54 cd ff ff       	call   80103e20 <mycpu>
801070cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801070d0:	b8 28 00 00 00       	mov    $0x28,%eax
801070d5:	0f 00 d8             	ltr    %ax
801070d8:	8b 43 04             	mov    0x4(%ebx),%eax
801070db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801070e0:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(v2p(p->pgdir));  // switch to process's address space
  popcli();
}
801070e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070e6:	5b                   	pop    %ebx
801070e7:	5e                   	pop    %esi
801070e8:	5f                   	pop    %edi
801070e9:	5d                   	pop    %ebp
  popcli();
801070ea:	e9 31 da ff ff       	jmp    80104b20 <popcli>
    panic("switchuvm: no process");
801070ef:	83 ec 0c             	sub    $0xc,%esp
801070f2:	68 ba 88 10 80       	push   $0x801088ba
801070f7:	e8 94 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801070fc:	83 ec 0c             	sub    $0xc,%esp
801070ff:	68 e5 88 10 80       	push   $0x801088e5
80107104:	e8 87 92 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107109:	83 ec 0c             	sub    $0xc,%esp
8010710c:	68 d0 88 10 80       	push   $0x801088d0
80107111:	e8 7a 92 ff ff       	call   80100390 <panic>
80107116:	8d 76 00             	lea    0x0(%esi),%esi
80107119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107120 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	57                   	push   %edi
80107124:	56                   	push   %esi
80107125:	53                   	push   %ebx
80107126:	83 ec 1c             	sub    $0x1c,%esp
80107129:	8b 75 10             	mov    0x10(%ebp),%esi
8010712c:	8b 45 08             	mov    0x8(%ebp),%eax
8010712f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107132:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010713b:	77 49                	ja     80107186 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010713d:	e8 7e b8 ff ff       	call   801029c0 <kalloc>
  memset(mem, 0, PGSIZE);
80107142:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107145:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107147:	68 00 10 00 00       	push   $0x1000
8010714c:	6a 00                	push   $0x0
8010714e:	50                   	push   %eax
8010714f:	e8 6c db ff ff       	call   80104cc0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107154:	58                   	pop    %eax
80107155:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010715b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107160:	5a                   	pop    %edx
80107161:	6a 06                	push   $0x6
80107163:	50                   	push   %eax
80107164:	31 d2                	xor    %edx,%edx
80107166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107169:	e8 62 fd ff ff       	call   80106ed0 <mappages>
  memmove(mem, init, sz);
8010716e:	89 75 10             	mov    %esi,0x10(%ebp)
80107171:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107174:	83 c4 10             	add    $0x10,%esp
80107177:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010717a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010717d:	5b                   	pop    %ebx
8010717e:	5e                   	pop    %esi
8010717f:	5f                   	pop    %edi
80107180:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107181:	e9 ea db ff ff       	jmp    80104d70 <memmove>
    panic("inituvm: more than a page");
80107186:	83 ec 0c             	sub    $0xc,%esp
80107189:	68 f9 88 10 80       	push   $0x801088f9
8010718e:	e8 fd 91 ff ff       	call   80100390 <panic>
80107193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071a0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
801071a6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801071a9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801071b0:	0f 85 91 00 00 00    	jne    80107247 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801071b6:	8b 75 18             	mov    0x18(%ebp),%esi
801071b9:	31 db                	xor    %ebx,%ebx
801071bb:	85 f6                	test   %esi,%esi
801071bd:	75 1a                	jne    801071d9 <loaduvm+0x39>
801071bf:	eb 6f                	jmp    80107230 <loaduvm+0x90>
801071c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071c8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071ce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801071d4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801071d7:	76 57                	jbe    80107230 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801071d9:	8b 55 0c             	mov    0xc(%ebp),%edx
801071dc:	8b 45 08             	mov    0x8(%ebp),%eax
801071df:	31 c9                	xor    %ecx,%ecx
801071e1:	01 da                	add    %ebx,%edx
801071e3:	e8 68 fc ff ff       	call   80106e50 <walkpgdir>
801071e8:	85 c0                	test   %eax,%eax
801071ea:	74 4e                	je     8010723a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801071ec:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
801071ee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801071f1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801071f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801071fb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107201:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, p2v(pa), offset+i, n) != n)
80107204:	01 d9                	add    %ebx,%ecx
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107206:	05 00 00 00 80       	add    $0x80000000,%eax
8010720b:	57                   	push   %edi
8010720c:	51                   	push   %ecx
8010720d:	50                   	push   %eax
8010720e:	ff 75 10             	pushl  0x10(%ebp)
80107211:	e8 8a a7 ff ff       	call   801019a0 <readi>
80107216:	83 c4 10             	add    $0x10,%esp
80107219:	39 f8                	cmp    %edi,%eax
8010721b:	74 ab                	je     801071c8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010721d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107225:	5b                   	pop    %ebx
80107226:	5e                   	pop    %esi
80107227:	5f                   	pop    %edi
80107228:	5d                   	pop    %ebp
80107229:	c3                   	ret    
8010722a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107233:	31 c0                	xor    %eax,%eax
}
80107235:	5b                   	pop    %ebx
80107236:	5e                   	pop    %esi
80107237:	5f                   	pop    %edi
80107238:	5d                   	pop    %ebp
80107239:	c3                   	ret    
      panic("loaduvm: address should exist");
8010723a:	83 ec 0c             	sub    $0xc,%esp
8010723d:	68 13 89 10 80       	push   $0x80108913
80107242:	e8 49 91 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107247:	83 ec 0c             	sub    $0xc,%esp
8010724a:	68 68 8a 10 80       	push   $0x80108a68
8010724f:	e8 3c 91 ff ff       	call   80100390 <panic>
80107254:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010725a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107260 <indexToSwap>:
  }
  return newsz;
}

uint indexToSwap()
{
80107260:	55                   	push   %ebp
  return 1;
}
80107261:	b8 01 00 00 00       	mov    $0x1,%eax
{
80107266:	89 e5                	mov    %esp,%ebp
}
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    
8010726a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107270 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	57                   	push   %edi
80107274:	56                   	push   %esi
80107275:	53                   	push   %ebx
80107276:	83 ec 3c             	sub    $0x3c,%esp
80107279:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
8010727c:	e8 3f cc ff ff       	call   80103ec0 <myproc>
80107281:	89 45 c0             	mov    %eax,-0x40(%ebp)

  if(newsz >= oldsz)
80107284:	8b 45 0c             	mov    0xc(%ebp),%eax
80107287:	39 45 10             	cmp    %eax,0x10(%ebp)
8010728a:	0f 83 a3 00 00 00    	jae    80107333 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107290:	8b 45 10             	mov    0x10(%ebp),%eax
80107293:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107299:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
8010729f:	39 75 0c             	cmp    %esi,0xc(%ebp)
801072a2:	77 6a                	ja     8010730e <deallocuvm+0x9e>
801072a4:	e9 87 00 00 00       	jmp    80107330 <deallocuvm+0xc0>
801072a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
801072b0:	8b 00                	mov    (%eax),%eax
801072b2:	a8 01                	test   $0x1,%al
801072b4:	74 4d                	je     80107303 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801072b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801072bb:	0f 84 63 01 00 00    	je     80107424 <deallocuvm+0x1b4>
801072c1:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      {
        panic("kfree");
      }
      char *v = p2v(pa);
      
      if(getRefs(v) == 1)
801072c7:	83 ec 0c             	sub    $0xc,%esp
801072ca:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801072cd:	53                   	push   %ebx
801072ce:	e8 7d b8 ff ff       	call   80102b50 <getRefs>
801072d3:	83 c4 10             	add    $0x10,%esp
801072d6:	83 f8 01             	cmp    $0x1,%eax
801072d9:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801072dc:	0f 84 2e 01 00 00    	je     80107410 <deallocuvm+0x1a0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
801072e2:	83 ec 0c             	sub    $0xc,%esp
801072e5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801072e8:	53                   	push   %ebx
801072e9:	e8 82 b7 ff ff       	call   80102a70 <refDec>
801072ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
801072f1:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
801072f4:	8b 45 c0             	mov    -0x40(%ebp),%eax
801072f7:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801072fb:	7f 43                	jg     80107340 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
801072fd:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107303:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107309:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010730c:	76 22                	jbe    80107330 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010730e:	31 c9                	xor    %ecx,%ecx
80107310:	89 f2                	mov    %esi,%edx
80107312:	89 f8                	mov    %edi,%eax
80107314:	e8 37 fb ff ff       	call   80106e50 <walkpgdir>
    if(!pte)
80107319:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
8010731b:	89 c2                	mov    %eax,%edx
    if(!pte)
8010731d:	75 91                	jne    801072b0 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
8010731f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107325:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010732b:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010732e:	77 de                	ja     8010730e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107330:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107333:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107336:	5b                   	pop    %ebx
80107337:	5e                   	pop    %esi
80107338:	5f                   	pop    %edi
80107339:	5d                   	pop    %ebp
8010733a:	c3                   	ret    
8010733b:	90                   	nop
8010733c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107340:	8d 88 88 01 00 00    	lea    0x188(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107346:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80107349:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
8010734f:	89 fa                	mov    %edi,%edx
80107351:	89 cf                	mov    %ecx,%edi
80107353:	eb 13                	jmp    80107368 <deallocuvm+0xf8>
80107355:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107358:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010735b:	74 73                	je     801073d0 <deallocuvm+0x160>
8010735d:	83 c3 10             	add    $0x10,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107360:	39 fb                	cmp    %edi,%ebx
80107362:	0f 84 98 00 00 00    	je     80107400 <deallocuvm+0x190>
          struct page p_ram = curproc->ramPages[i];
80107368:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
8010736e:	89 45 c8             	mov    %eax,-0x38(%ebp)
80107371:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
80107377:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010737a:	8b 83 08 01 00 00    	mov    0x108(%ebx),%eax
80107380:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107383:	8b 83 0c 01 00 00    	mov    0x10c(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107389:	39 75 d0             	cmp    %esi,-0x30(%ebp)
          struct page p_ram = curproc->ramPages[i];
8010738c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
          struct page p_swap = curproc->swappedPages[i];
8010738f:	8b 03                	mov    (%ebx),%eax
80107391:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107394:	8b 43 04             	mov    0x4(%ebx),%eax
80107397:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010739a:	8b 43 08             	mov    0x8(%ebx),%eax
8010739d:	89 45 e0             	mov    %eax,-0x20(%ebp)
801073a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801073a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
801073a6:	75 b0                	jne    80107358 <deallocuvm+0xe8>
801073a8:	39 55 c8             	cmp    %edx,-0x38(%ebp)
801073ab:	75 ab                	jne    80107358 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801073ad:	8d 45 c8             	lea    -0x38(%ebp),%eax
801073b0:	83 ec 04             	sub    $0x4,%esp
801073b3:	89 55 bc             	mov    %edx,-0x44(%ebp)
801073b6:	6a 10                	push   $0x10
801073b8:	6a 00                	push   $0x0
801073ba:	50                   	push   %eax
801073bb:	e8 00 d9 ff ff       	call   80104cc0 <memset>
801073c0:	83 c4 10             	add    $0x10,%esp
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
801073c3:	39 75 e0             	cmp    %esi,-0x20(%ebp)
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801073c6:	8b 55 bc             	mov    -0x44(%ebp),%edx
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
801073c9:	75 92                	jne    8010735d <deallocuvm+0xed>
801073cb:	90                   	nop
801073cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801073d0:	39 55 d8             	cmp    %edx,-0x28(%ebp)
801073d3:	75 88                	jne    8010735d <deallocuvm+0xed>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
801073d5:	8d 45 d8             	lea    -0x28(%ebp),%eax
801073d8:	83 ec 04             	sub    $0x4,%esp
801073db:	83 c3 10             	add    $0x10,%ebx
801073de:	6a 10                	push   $0x10
801073e0:	6a 00                	push   $0x0
801073e2:	50                   	push   %eax
801073e3:	89 55 bc             	mov    %edx,-0x44(%ebp)
801073e6:	e8 d5 d8 ff ff       	call   80104cc0 <memset>
801073eb:	83 c4 10             	add    $0x10,%esp
        for(i = 0; i < MAX_PSYC_PAGES; i++)
801073ee:	39 fb                	cmp    %edi,%ebx
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
801073f0:	8b 55 bc             	mov    -0x44(%ebp),%edx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
801073f3:	0f 85 6f ff ff ff    	jne    80107368 <deallocuvm+0xf8>
801073f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107400:	89 d7                	mov    %edx,%edi
80107402:	8b 55 c4             	mov    -0x3c(%ebp),%edx
80107405:	e9 f3 fe ff ff       	jmp    801072fd <deallocuvm+0x8d>
8010740a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107410:	83 ec 0c             	sub    $0xc,%esp
80107413:	53                   	push   %ebx
80107414:	e8 c7 b2 ff ff       	call   801026e0 <kfree>
80107419:	83 c4 10             	add    $0x10,%esp
8010741c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
8010741f:	e9 d0 fe ff ff       	jmp    801072f4 <deallocuvm+0x84>
        panic("kfree");
80107424:	83 ec 0c             	sub    $0xc,%esp
80107427:	68 ca 81 10 80       	push   $0x801081ca
8010742c:	e8 5f 8f ff ff       	call   80100390 <panic>
80107431:	eb 0d                	jmp    80107440 <allocuvm>
80107433:	90                   	nop
80107434:	90                   	nop
80107435:	90                   	nop
80107436:	90                   	nop
80107437:	90                   	nop
80107438:	90                   	nop
80107439:	90                   	nop
8010743a:	90                   	nop
8010743b:	90                   	nop
8010743c:	90                   	nop
8010743d:	90                   	nop
8010743e:	90                   	nop
8010743f:	90                   	nop

80107440 <allocuvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107449:	e8 72 ca ff ff       	call   80103ec0 <myproc>
8010744e:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
80107450:	8b 45 10             	mov    0x10(%ebp),%eax
80107453:	85 c0                	test   %eax,%eax
80107455:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107458:	0f 88 e2 01 00 00    	js     80107640 <allocuvm+0x200>
  if(newsz < oldsz)
8010745e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107461:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107464:	0f 82 c6 01 00 00    	jb     80107630 <allocuvm+0x1f0>
  a = PGROUNDUP(oldsz);
8010746a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107470:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107476:	39 75 10             	cmp    %esi,0x10(%ebp)
80107479:	0f 87 ec 00 00 00    	ja     8010756b <allocuvm+0x12b>
8010747f:	e9 af 01 00 00       	jmp    80107633 <allocuvm+0x1f3>
80107484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        int write_res = writeToSwapFile(curproc, evicted_page->virt_addr, evicted_ind * PGSIZE, PGSIZE);
80107488:	68 00 10 00 00       	push   $0x1000
8010748d:	68 00 10 00 00       	push   $0x1000
80107492:	ff b3 a0 01 00 00    	pushl  0x1a0(%ebx)
80107498:	53                   	push   %ebx
80107499:	e8 f2 ad ff ff       	call   80102290 <writeToSwapFile>
        if(write_res < 0)
8010749e:	83 c4 10             	add    $0x10,%esp
801074a1:	85 c0                	test   %eax,%eax
801074a3:	0f 88 3f 02 00 00    	js     801076e8 <allocuvm+0x2a8>
        curproc->swappedPages[0].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
801074a9:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
        cprintf("num swap: %d\n", curproc->num_swap);
801074af:	83 ec 08             	sub    $0x8,%esp
        curproc->swappedPages[0].isused = 1;
801074b2:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
801074b9:	00 00 00 
        curproc->swappedPages[0].swap_offset = evicted_ind * PGSIZE;
801074bc:	c7 83 94 00 00 00 00 	movl   $0x1000,0x94(%ebx)
801074c3:	10 00 00 
        curproc->swappedPages[0].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
801074c6:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)
        curproc->swappedPages[0].pgdir = curproc->pgdir;
801074cc:	8b 43 04             	mov    0x4(%ebx),%eax
801074cf:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        cprintf("num swap: %d\n", curproc->num_swap);
801074d5:	ff b3 8c 02 00 00    	pushl  0x28c(%ebx)
801074db:	68 8d 89 10 80       	push   $0x8010898d
801074e0:	e8 7b 91 ff ff       	call   80100660 <cprintf>
        curproc->num_swap ++;
801074e5:	83 83 8c 02 00 00 01 	addl   $0x1,0x28c(%ebx)
        pte_t *evicted_pte = walkpgdir(curproc->pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
801074ec:	8b 93 a0 01 00 00    	mov    0x1a0(%ebx),%edx
801074f2:	31 c9                	xor    %ecx,%ecx
801074f4:	8b 43 04             	mov    0x4(%ebx),%eax
801074f7:	e8 54 f9 ff ff       	call   80106e50 <walkpgdir>
        if(!(*evicted_pte & PTE_P))
801074fc:	8b 10                	mov    (%eax),%edx
801074fe:	83 c4 10             	add    $0x10,%esp
        pte_t *evicted_pte = walkpgdir(curproc->pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107501:	89 c7                	mov    %eax,%edi
        if(!(*evicted_pte & PTE_P))
80107503:	f6 c2 01             	test   $0x1,%dl
80107506:	0f 84 cf 01 00 00    	je     801076db <allocuvm+0x29b>
        char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
8010750c:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
        kfree(P2V(evicted_pa));
80107512:	83 ec 0c             	sub    $0xc,%esp
80107515:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010751b:	52                   	push   %edx
8010751c:	e8 bf b1 ff ff       	call   801026e0 <kfree>
        *evicted_pte &= ~PTE_P;
80107521:	8b 07                	mov    (%edi),%eax
80107523:	83 e0 fe             	and    $0xfffffffe,%eax
80107526:	80 cc 02             	or     $0x2,%ah
80107529:	89 07                	mov    %eax,(%edi)
        newpage->pgdir = pgdir; // ??? 
8010752b:	8b 45 08             	mov    0x8(%ebp),%eax
        newpage->isused = 1;
8010752e:	c7 83 9c 01 00 00 01 	movl   $0x1,0x19c(%ebx)
80107535:	00 00 00 
        newpage->swap_offset = evicted_ind * PGSIZE;
80107538:	c7 83 a4 01 00 00 00 	movl   $0x1000,0x1a4(%ebx)
8010753f:	10 00 00 
        newpage->virt_addr = (char*)a;
80107542:	89 b3 a0 01 00 00    	mov    %esi,0x1a0(%ebx)
        newpage->pgdir = pgdir; // ??? 
80107548:	89 83 98 01 00 00    	mov    %eax,0x198(%ebx)
        lcr3(V2P(curproc->pgdir)); // flush TLB
8010754e:	8b 43 04             	mov    0x4(%ebx),%eax
80107551:	05 00 00 00 80       	add    $0x80000000,%eax
80107556:	0f 22 d8             	mov    %eax,%cr3
80107559:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
8010755c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107562:	39 75 10             	cmp    %esi,0x10(%ebp)
80107565:	0f 86 c8 00 00 00    	jbe    80107633 <allocuvm+0x1f3>
    mem = kalloc();
8010756b:	e8 50 b4 ff ff       	call   801029c0 <kalloc>
    if(mem == 0){
80107570:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107572:	89 c7                	mov    %eax,%edi
    if(mem == 0){
80107574:	0f 84 ee 00 00 00    	je     80107668 <allocuvm+0x228>
    memset(mem, 0, PGSIZE);
8010757a:	83 ec 04             	sub    $0x4,%esp
8010757d:	68 00 10 00 00       	push   $0x1000
80107582:	6a 00                	push   $0x0
80107584:	50                   	push   %eax
80107585:	e8 36 d7 ff ff       	call   80104cc0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010758a:	58                   	pop    %eax
8010758b:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107591:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107596:	5a                   	pop    %edx
80107597:	6a 06                	push   $0x6
80107599:	50                   	push   %eax
8010759a:	89 f2                	mov    %esi,%edx
8010759c:	8b 45 08             	mov    0x8(%ebp),%eax
8010759f:	e8 2c f9 ff ff       	call   80106ed0 <mappages>
801075a4:	83 c4 10             	add    $0x10,%esp
801075a7:	85 c0                	test   %eax,%eax
801075a9:	0f 88 f1 00 00 00    	js     801076a0 <allocuvm+0x260>
    if(curproc->pid > 2) {
801075af:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801075b3:	7e a7                	jle    8010755c <allocuvm+0x11c>
      if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801075b5:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
801075bc:	0f 8f c6 fe ff ff    	jg     80107488 <allocuvm+0x48>

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
801075c2:	e8 f9 c8 ff ff       	call   80103ec0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801075c7:	31 d2                	xor    %edx,%edx
801075c9:	05 8c 01 00 00       	add    $0x18c,%eax
801075ce:	eb 0b                	jmp    801075db <allocuvm+0x19b>
801075d0:	83 c2 01             	add    $0x1,%edx
801075d3:	83 c0 10             	add    $0x10,%eax
801075d6:	83 fa 10             	cmp    $0x10,%edx
801075d9:	74 7d                	je     80107658 <allocuvm+0x218>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
801075db:	8b 08                	mov    (%eax),%ecx
801075dd:	85 c9                	test   %ecx,%ecx
801075df:	75 ef                	jne    801075d0 <allocuvm+0x190>
801075e1:	89 d0                	mov    %edx,%eax
801075e3:	c1 e0 0c             	shl    $0xc,%eax
          page->pgdir = pgdir;
801075e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801075e9:	c1 e2 04             	shl    $0x4,%edx
          cprintf("num ram : %d\n", curproc->num_ram);
801075ec:	83 ec 08             	sub    $0x8,%esp
801075ef:	01 da                	add    %ebx,%edx
          page->isused = 1;
801075f1:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
801075f8:	00 00 00 
          page->swap_offset = new_index * PGSIZE;
801075fb:	89 82 94 01 00 00    	mov    %eax,0x194(%edx)
          page->pgdir = pgdir;
80107601:	89 8a 88 01 00 00    	mov    %ecx,0x188(%edx)
          page->virt_addr = (char*)a;
80107607:	89 b2 90 01 00 00    	mov    %esi,0x190(%edx)
          cprintf("num ram : %d\n", curproc->num_ram);
8010760d:	ff b3 88 02 00 00    	pushl  0x288(%ebx)
80107613:	68 65 89 10 80       	push   $0x80108965
80107618:	e8 43 90 ff ff       	call   80100660 <cprintf>
          curproc->num_ram++;
8010761d:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
80107624:	83 c4 10             	add    $0x10,%esp
80107627:	e9 30 ff ff ff       	jmp    8010755c <allocuvm+0x11c>
8010762c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107639:	5b                   	pop    %ebx
8010763a:	5e                   	pop    %esi
8010763b:	5f                   	pop    %edi
8010763c:	5d                   	pop    %ebp
8010763d:	c3                   	ret    
8010763e:	66 90                	xchg   %ax,%ax
    return 0;
80107640:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107647:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010764a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010764d:	5b                   	pop    %ebx
8010764e:	5e                   	pop    %esi
8010764f:	5f                   	pop    %edi
80107650:	5d                   	pop    %ebp
80107651:	c3                   	ret    
80107652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107658:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
      return i;
  }
  return -1;
8010765d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107662:	eb 82                	jmp    801075e6 <allocuvm+0x1a6>
80107664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory\n");
80107668:	83 ec 0c             	sub    $0xc,%esp
8010766b:	68 31 89 10 80       	push   $0x80108931
80107670:	e8 eb 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107675:	83 c4 0c             	add    $0xc,%esp
80107678:	ff 75 0c             	pushl  0xc(%ebp)
8010767b:	ff 75 10             	pushl  0x10(%ebp)
8010767e:	ff 75 08             	pushl  0x8(%ebp)
80107681:	e8 ea fb ff ff       	call   80107270 <deallocuvm>
      return 0;
80107686:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010768d:	83 c4 10             	add    $0x10,%esp
}
80107690:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107693:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107696:	5b                   	pop    %ebx
80107697:	5e                   	pop    %esi
80107698:	5f                   	pop    %edi
80107699:	5d                   	pop    %ebp
8010769a:	c3                   	ret    
8010769b:	90                   	nop
8010769c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801076a0:	83 ec 0c             	sub    $0xc,%esp
801076a3:	68 49 89 10 80       	push   $0x80108949
801076a8:	e8 b3 8f ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801076ad:	83 c4 0c             	add    $0xc,%esp
801076b0:	ff 75 0c             	pushl  0xc(%ebp)
801076b3:	ff 75 10             	pushl  0x10(%ebp)
801076b6:	ff 75 08             	pushl  0x8(%ebp)
801076b9:	e8 b2 fb ff ff       	call   80107270 <deallocuvm>
      kfree(mem);
801076be:	89 3c 24             	mov    %edi,(%esp)
801076c1:	e8 1a b0 ff ff       	call   801026e0 <kfree>
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
          panic("allocuvm: swap: ram page not present");
801076db:	83 ec 0c             	sub    $0xc,%esp
801076de:	68 8c 8a 10 80       	push   $0x80108a8c
801076e3:	e8 a8 8c ff ff       	call   80100390 <panic>
          panic("allocuvm: writeToSwapFile");
801076e8:	83 ec 0c             	sub    $0xc,%esp
801076eb:	68 73 89 10 80       	push   $0x80108973
801076f0:	e8 9b 8c ff ff       	call   80100390 <panic>
801076f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107700 <freevm>:
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	57                   	push   %edi
80107704:	56                   	push   %esi
80107705:	53                   	push   %ebx
80107706:	83 ec 0c             	sub    $0xc,%esp
80107709:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
8010770c:	85 f6                	test   %esi,%esi
8010770e:	74 59                	je     80107769 <freevm+0x69>
  deallocuvm(pgdir, KERNBASE, 0);
80107710:	83 ec 04             	sub    $0x4,%esp
80107713:	89 f3                	mov    %esi,%ebx
80107715:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010771b:	6a 00                	push   $0x0
8010771d:	68 00 00 00 80       	push   $0x80000000
80107722:	56                   	push   %esi
80107723:	e8 48 fb ff ff       	call   80107270 <deallocuvm>
80107728:	83 c4 10             	add    $0x10,%esp
8010772b:	eb 0a                	jmp    80107737 <freevm+0x37>
8010772d:	8d 76 00             	lea    0x0(%esi),%esi
80107730:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107733:	39 fb                	cmp    %edi,%ebx
80107735:	74 23                	je     8010775a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107737:	8b 03                	mov    (%ebx),%eax
80107739:	a8 01                	test   $0x1,%al
8010773b:	74 f3                	je     80107730 <freevm+0x30>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010773d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107742:	83 ec 0c             	sub    $0xc,%esp
80107745:	83 c3 04             	add    $0x4,%ebx
80107748:	05 00 00 00 80       	add    $0x80000000,%eax
8010774d:	50                   	push   %eax
8010774e:	e8 8d af ff ff       	call   801026e0 <kfree>
80107753:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107756:	39 fb                	cmp    %edi,%ebx
80107758:	75 dd                	jne    80107737 <freevm+0x37>
  kfree((char*)pgdir);
8010775a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010775d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107760:	5b                   	pop    %ebx
80107761:	5e                   	pop    %esi
80107762:	5f                   	pop    %edi
80107763:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107764:	e9 77 af ff ff       	jmp    801026e0 <kfree>
    panic("freevm: no pgdir");
80107769:	83 ec 0c             	sub    $0xc,%esp
8010776c:	68 9b 89 10 80       	push   $0x8010899b
80107771:	e8 1a 8c ff ff       	call   80100390 <panic>
80107776:	8d 76 00             	lea    0x0(%esi),%esi
80107779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107780 <setupkvm>:
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	56                   	push   %esi
80107784:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107785:	e8 36 b2 ff ff       	call   801029c0 <kalloc>
8010778a:	85 c0                	test   %eax,%eax
8010778c:	89 c6                	mov    %eax,%esi
8010778e:	74 42                	je     801077d2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107790:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107793:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107798:	68 00 10 00 00       	push   $0x1000
8010779d:	6a 00                	push   $0x0
8010779f:	50                   	push   %eax
801077a0:	e8 1b d5 ff ff       	call   80104cc0 <memset>
801077a5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077a8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077ab:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077ae:	83 ec 08             	sub    $0x8,%esp
801077b1:	8b 13                	mov    (%ebx),%edx
801077b3:	ff 73 0c             	pushl  0xc(%ebx)
801077b6:	50                   	push   %eax
801077b7:	29 c1                	sub    %eax,%ecx
801077b9:	89 f0                	mov    %esi,%eax
801077bb:	e8 10 f7 ff ff       	call   80106ed0 <mappages>
801077c0:	83 c4 10             	add    $0x10,%esp
801077c3:	85 c0                	test   %eax,%eax
801077c5:	78 19                	js     801077e0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077c7:	83 c3 10             	add    $0x10,%ebx
801077ca:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077d0:	75 d6                	jne    801077a8 <setupkvm+0x28>
}
801077d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077d5:	89 f0                	mov    %esi,%eax
801077d7:	5b                   	pop    %ebx
801077d8:	5e                   	pop    %esi
801077d9:	5d                   	pop    %ebp
801077da:	c3                   	ret    
801077db:	90                   	nop
801077dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801077e0:	83 ec 0c             	sub    $0xc,%esp
801077e3:	56                   	push   %esi
      return 0;
801077e4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077e6:	e8 15 ff ff ff       	call   80107700 <freevm>
      return 0;
801077eb:	83 c4 10             	add    $0x10,%esp
}
801077ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077f1:	89 f0                	mov    %esi,%eax
801077f3:	5b                   	pop    %ebx
801077f4:	5e                   	pop    %esi
801077f5:	5d                   	pop    %ebp
801077f6:	c3                   	ret    
801077f7:	89 f6                	mov    %esi,%esi
801077f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107800 <kvmalloc>:
{
80107800:	55                   	push   %ebp
80107801:	89 e5                	mov    %esp,%ebp
80107803:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107806:	e8 75 ff ff ff       	call   80107780 <setupkvm>
8010780b:	a3 e4 09 1a 80       	mov    %eax,0x801a09e4
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107810:	05 00 00 00 80       	add    $0x80000000,%eax
80107815:	0f 22 d8             	mov    %eax,%cr3
}
80107818:	c9                   	leave  
80107819:	c3                   	ret    
8010781a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107820 <clearpteu>:
{
80107820:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107821:	31 c9                	xor    %ecx,%ecx
{
80107823:	89 e5                	mov    %esp,%ebp
80107825:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107828:	8b 55 0c             	mov    0xc(%ebp),%edx
8010782b:	8b 45 08             	mov    0x8(%ebp),%eax
8010782e:	e8 1d f6 ff ff       	call   80106e50 <walkpgdir>
  if(pte == 0)
80107833:	85 c0                	test   %eax,%eax
80107835:	74 05                	je     8010783c <clearpteu+0x1c>
  *pte &= ~PTE_U;
80107837:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010783a:	c9                   	leave  
8010783b:	c3                   	ret    
    panic("clearpteu");
8010783c:	83 ec 0c             	sub    $0xc,%esp
8010783f:	68 ac 89 10 80       	push   $0x801089ac
80107844:	e8 47 8b ff ff       	call   80100390 <panic>
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107850 <cowuvm>:
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 0c             	sub    $0xc,%esp
  if((d = setupkvm()) == 0)
80107859:	e8 22 ff ff ff       	call   80107780 <setupkvm>
8010785e:	85 c0                	test   %eax,%eax
80107860:	89 c7                	mov    %eax,%edi
80107862:	0f 84 92 00 00 00    	je     801078fa <cowuvm+0xaa>
  for(i = 0; i < sz; i += PGSIZE)
80107868:	8b 45 0c             	mov    0xc(%ebp),%eax
8010786b:	85 c0                	test   %eax,%eax
8010786d:	0f 84 87 00 00 00    	je     801078fa <cowuvm+0xaa>
80107873:	31 db                	xor    %ebx,%ebx
80107875:	eb 29                	jmp    801078a0 <cowuvm+0x50>
80107877:	89 f6                	mov    %esi,%esi
80107879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    refInc(virt_addr);
80107880:	83 ec 0c             	sub    $0xc,%esp
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107883:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80107889:	56                   	push   %esi
8010788a:	e8 51 b2 ff ff       	call   80102ae0 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
8010788f:	0f 01 3b             	invlpg (%ebx)
  for(i = 0; i < sz; i += PGSIZE)
80107892:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107898:	83 c4 10             	add    $0x10,%esp
8010789b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010789e:	76 5a                	jbe    801078fa <cowuvm+0xaa>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078a0:	8b 45 08             	mov    0x8(%ebp),%eax
801078a3:	31 c9                	xor    %ecx,%ecx
801078a5:	89 da                	mov    %ebx,%edx
801078a7:	e8 a4 f5 ff ff       	call   80106e50 <walkpgdir>
801078ac:	85 c0                	test   %eax,%eax
801078ae:	74 61                	je     80107911 <cowuvm+0xc1>
    if(!(*pte & PTE_P))
801078b0:	8b 10                	mov    (%eax),%edx
801078b2:	f6 c2 01             	test   $0x1,%dl
801078b5:	74 4d                	je     80107904 <cowuvm+0xb4>
    *pte &= ~PTE_W;
801078b7:	89 d1                	mov    %edx,%ecx
801078b9:	89 d6                	mov    %edx,%esi
    flags = PTE_FLAGS(*pte);
801078bb:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
801078c1:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
801078c4:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
801078c7:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
801078ca:	80 cd 04             	or     $0x4,%ch
801078cd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801078d3:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
801078d5:	52                   	push   %edx
801078d6:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078db:	56                   	push   %esi
801078dc:	89 da                	mov    %ebx,%edx
801078de:	89 f8                	mov    %edi,%eax
801078e0:	e8 eb f5 ff ff       	call   80106ed0 <mappages>
801078e5:	83 c4 10             	add    $0x10,%esp
801078e8:	85 c0                	test   %eax,%eax
801078ea:	79 94                	jns    80107880 <cowuvm+0x30>
  freevm(d);
801078ec:	83 ec 0c             	sub    $0xc,%esp
801078ef:	57                   	push   %edi
  return 0;
801078f0:	31 ff                	xor    %edi,%edi
  freevm(d);
801078f2:	e8 09 fe ff ff       	call   80107700 <freevm>
  return 0;
801078f7:	83 c4 10             	add    $0x10,%esp
}
801078fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078fd:	89 f8                	mov    %edi,%eax
801078ff:	5b                   	pop    %ebx
80107900:	5e                   	pop    %esi
80107901:	5f                   	pop    %edi
80107902:	5d                   	pop    %ebp
80107903:	c3                   	ret    
      panic("cowuvm: page not present");
80107904:	83 ec 0c             	sub    $0xc,%esp
80107907:	68 c5 89 10 80       	push   $0x801089c5
8010790c:	e8 7f 8a ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107911:	83 ec 0c             	sub    $0xc,%esp
80107914:	68 b6 89 10 80       	push   $0x801089b6
80107919:	e8 72 8a ff ff       	call   80100390 <panic>
8010791e:	66 90                	xchg   %ax,%ax

80107920 <getSwappedPageIndex>:
{
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	53                   	push   %ebx
80107924:	83 ec 04             	sub    $0x4,%esp
80107927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
8010792a:	e8 91 c5 ff ff       	call   80103ec0 <myproc>
8010792f:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107935:	31 c0                	xor    %eax,%eax
80107937:	eb 12                	jmp    8010794b <getSwappedPageIndex+0x2b>
80107939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107940:	83 c0 01             	add    $0x1,%eax
80107943:	83 c2 10             	add    $0x10,%edx
80107946:	83 f8 10             	cmp    $0x10,%eax
80107949:	74 0d                	je     80107958 <getSwappedPageIndex+0x38>
    if(curproc->swappedPages[i].virt_addr == va)
8010794b:	39 1a                	cmp    %ebx,(%edx)
8010794d:	75 f1                	jne    80107940 <getSwappedPageIndex+0x20>
}
8010794f:	83 c4 04             	add    $0x4,%esp
80107952:	5b                   	pop    %ebx
80107953:	5d                   	pop    %ebp
80107954:	c3                   	ret    
80107955:	8d 76 00             	lea    0x0(%esi),%esi
80107958:	83 c4 04             	add    $0x4,%esp
  return -1;
8010795b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107960:	5b                   	pop    %ebx
80107961:	5d                   	pop    %ebp
80107962:	c3                   	ret    
80107963:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107970 <pagefault>:
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	57                   	push   %edi
80107974:	56                   	push   %esi
80107975:	53                   	push   %ebx
80107976:	83 ec 28             	sub    $0x28,%esp
  cprintf("PAGEFAULT\n");
80107979:	68 de 89 10 80       	push   $0x801089de
8010797e:	e8 dd 8c ff ff       	call   80100660 <cprintf>
  struct proc* curproc = myproc();
80107983:	e8 38 c5 ff ff       	call   80103ec0 <myproc>
80107988:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010798a:	0f 20 d7             	mov    %cr2,%edi
  uint err = curproc->tf->err;
8010798d:	8b 40 18             	mov    0x18(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107990:	89 fe                	mov    %edi,%esi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107992:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107994:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
8010799a:	89 f2                	mov    %esi,%edx
  uint err = curproc->tf->err;
8010799c:	8b 40 34             	mov    0x34(%eax),%eax
8010799f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801079a2:	8b 43 04             	mov    0x4(%ebx),%eax
801079a5:	e8 a6 f4 ff ff       	call   80106e50 <walkpgdir>
  if(*pte & PTE_PG) // page was paged out
801079aa:	83 c4 10             	add    $0x10,%esp
801079ad:	f7 00 00 02 00 00    	testl  $0x200,(%eax)
801079b3:	0f 84 1f 01 00 00    	je     80107ad8 <pagefault+0x168>
    cprintf("page was paged out\n");
801079b9:	83 ec 0c             	sub    $0xc,%esp
801079bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801079bf:	68 e9 89 10 80       	push   $0x801089e9
801079c4:	e8 97 8c ff ff       	call   80100660 <cprintf>
    new_page = kalloc();
801079c9:	e8 f2 af ff ff       	call   801029c0 <kalloc>
    *pte &= ~PTE_PG;                 //  points to a newly allocated page
801079ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    *pte |= V2P(new_page);           //  returned from kalloc()
801079d1:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= ~PTE_PG;                 //  points to a newly allocated page
801079d6:	8b 0a                	mov    (%edx),%ecx
801079d8:	80 e5 fd             	and    $0xfd,%ch
801079db:	83 c9 07             	or     $0x7,%ecx
    *pte |= V2P(new_page);           //  returned from kalloc()
801079de:	09 c8                	or     %ecx,%eax
801079e0:	89 02                	mov    %eax,(%edx)
  struct proc* curproc = myproc();
801079e2:	e8 d9 c4 ff ff       	call   80103ec0 <myproc>
801079e7:	83 c4 10             	add    $0x10,%esp
801079ea:	05 90 00 00 00       	add    $0x90,%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801079ef:	31 d2                	xor    %edx,%edx
801079f1:	eb 14                	jmp    80107a07 <pagefault+0x97>
801079f3:	90                   	nop
801079f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079f8:	83 c2 01             	add    $0x1,%edx
801079fb:	83 c0 10             	add    $0x10,%eax
801079fe:	83 fa 10             	cmp    $0x10,%edx
80107a01:	0f 84 e1 01 00 00    	je     80107be8 <pagefault+0x278>
    if(curproc->swappedPages[i].virt_addr == va)
80107a07:	3b 30                	cmp    (%eax),%esi
80107a09:	75 ed                	jne    801079f8 <pagefault+0x88>
80107a0b:	89 d0                	mov    %edx,%eax
80107a0d:	c1 e0 04             	shl    $0x4,%eax
80107a10:	8d b8 88 00 00 00    	lea    0x88(%eax),%edi
80107a16:	89 d1                	mov    %edx,%ecx
    struct page *swap_page = &curproc->swappedPages[index];
80107a18:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
    readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE);
80107a1b:	68 00 10 00 00       	push   $0x1000
80107a20:	c1 e1 04             	shl    $0x4,%ecx
80107a23:	89 55 e0             	mov    %edx,-0x20(%ebp)
80107a26:	8d 3c 0b             	lea    (%ebx,%ecx,1),%edi
    struct page *swap_page = &curproc->swappedPages[index];
80107a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE);
80107a2c:	ff b7 94 00 00 00    	pushl  0x94(%edi)
80107a32:	68 00 c6 11 80       	push   $0x8011c600
80107a37:	53                   	push   %ebx
80107a38:	e8 83 a8 ff ff       	call   801022c0 <readFromSwapFile>
    memmove((void*)start_page, buffer, PGSIZE);
80107a3d:	83 c4 0c             	add    $0xc,%esp
80107a40:	68 00 10 00 00       	push   $0x1000
80107a45:	68 00 c6 11 80       	push   $0x8011c600
80107a4a:	56                   	push   %esi
80107a4b:	e8 20 d3 ff ff       	call   80104d70 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80107a50:	83 c4 0c             	add    $0xc,%esp
80107a53:	6a 10                	push   $0x10
80107a55:	6a 00                	push   $0x0
80107a57:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a5a:	e8 61 d2 ff ff       	call   80104cc0 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80107a5f:	83 c4 10             	add    $0x10,%esp
80107a62:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
80107a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107a6c:	0f 8f de 00 00 00    	jg     80107b50 <pagefault+0x1e0>
  struct proc * currproc = myproc();
80107a72:	e8 49 c4 ff ff       	call   80103ec0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107a77:	31 d2                	xor    %edx,%edx
80107a79:	05 8c 01 00 00       	add    $0x18c,%eax
80107a7e:	eb 0f                	jmp    80107a8f <pagefault+0x11f>
80107a80:	83 c2 01             	add    $0x1,%edx
80107a83:	83 c0 10             	add    $0x10,%eax
80107a86:	83 fa 10             	cmp    $0x10,%edx
80107a89:	0f 84 a1 01 00 00    	je     80107c30 <pagefault+0x2c0>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107a8f:	8b 08                	mov    (%eax),%ecx
80107a91:	85 c9                	test   %ecx,%ecx
80107a93:	75 eb                	jne    80107a80 <pagefault+0x110>
80107a95:	89 d0                	mov    %edx,%eax
80107a97:	c1 e0 0c             	shl    $0xc,%eax
80107a9a:	c1 e2 04             	shl    $0x4,%edx
80107a9d:	01 da                	add    %ebx,%edx
      curproc->ramPages[new_indx].virt_addr = start_page;
80107a9f:	89 b2 90 01 00 00    	mov    %esi,0x190(%edx)
      curproc->ramPages[new_indx].isused = 1;
80107aa5:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80107aac:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80107aaf:	8b 4b 04             	mov    0x4(%ebx),%ecx
      curproc->ramPages[new_indx].swap_offset = new_indx * PGSIZE; //change the swap offset by the new index
80107ab2:	89 82 94 01 00 00    	mov    %eax,0x194(%edx)
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80107ab8:	89 8a 88 01 00 00    	mov    %ecx,0x188(%edx)
      curproc->num_ram++;      
80107abe:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
      curproc->num_swap--;
80107ac5:	83 ab 8c 02 00 00 01 	subl   $0x1,0x28c(%ebx)
}
80107acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107acf:	5b                   	pop    %ebx
80107ad0:	5e                   	pop    %esi
80107ad1:	5f                   	pop    %edi
80107ad2:	5d                   	pop    %ebp
80107ad3:	c3                   	ret    
80107ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("page was not paged out\n");
80107ad8:	83 ec 0c             	sub    $0xc,%esp
80107adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ade:	68 fd 89 10 80       	push   $0x801089fd
80107ae3:	e8 78 8b ff ff       	call   80100660 <cprintf>
    if(va >= KERNBASE || pte == 0)
80107ae8:	83 c4 10             	add    $0x10,%esp
80107aeb:	85 ff                	test   %edi,%edi
80107aed:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107af0:	0f 88 0a 01 00 00    	js     80107c00 <pagefault+0x290>
  if(err & FEC_WR)
80107af6:	f6 45 e4 02          	testb  $0x2,-0x1c(%ebp)
80107afa:	74 44                	je     80107b40 <pagefault+0x1d0>
    if(!(*pte & PTE_COW)) 
80107afc:	8b 32                	mov    (%edx),%esi
80107afe:	f7 c6 00 04 00 00    	test   $0x400,%esi
80107b04:	74 3a                	je     80107b40 <pagefault+0x1d0>
      pa = PTE_ADDR(*pte);
80107b06:	89 f3                	mov    %esi,%ebx
      ref_count = getRefs(virt_addr);
80107b08:	83 ec 0c             	sub    $0xc,%esp
80107b0b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80107b0e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107b14:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      ref_count = getRefs(virt_addr);
80107b1a:	53                   	push   %ebx
80107b1b:	e8 30 b0 ff ff       	call   80102b50 <getRefs>
      if (ref_count > 1) // more than one reference
80107b20:	83 c4 10             	add    $0x10,%esp
80107b23:	83 f8 01             	cmp    $0x1,%eax
80107b26:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b29:	0f 8f 10 01 00 00    	jg     80107c3f <pagefault+0x2cf>
        *pte &= ~PTE_COW; // turn COW off
80107b2f:	8b 02                	mov    (%edx),%eax
80107b31:	80 e4 fb             	and    $0xfb,%ah
80107b34:	83 c8 02             	or     $0x2,%eax
80107b37:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107b39:	0f 01 3f             	invlpg (%edi)
80107b3c:	eb 09                	jmp    80107b47 <pagefault+0x1d7>
80107b3e:	66 90                	xchg   %ax,%ax
    curproc->killed = 1;
80107b40:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
}
80107b47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b4a:	5b                   	pop    %ebx
80107b4b:	5e                   	pop    %esi
80107b4c:	5f                   	pop    %edi
80107b4d:	5d                   	pop    %ebp
80107b4e:	c3                   	ret    
80107b4f:	90                   	nop
      swap_page->virt_addr = ram_page->virt_addr;
80107b50:	8b 83 a0 01 00 00    	mov    0x1a0(%ebx),%eax
      swap_page->swap_offset = index * PGSIZE;
80107b56:	c1 e2 0c             	shl    $0xc,%edx
      swap_page->virt_addr = ram_page->virt_addr;
80107b59:	89 87 90 00 00 00    	mov    %eax,0x90(%edi)
      swap_page->pgdir = ram_page->pgdir;
80107b5f:	8b 8b 98 01 00 00    	mov    0x198(%ebx),%ecx
      swap_page->swap_offset = index * PGSIZE;
80107b65:	89 97 94 00 00 00    	mov    %edx,0x94(%edi)
      swap_page->isused = 1;
80107b6b:	c7 87 8c 00 00 00 01 	movl   $0x1,0x8c(%edi)
80107b72:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80107b75:	89 8f 88 00 00 00    	mov    %ecx,0x88(%edi)
      writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_page->swap_offset, PGSIZE);   // buffer now has bytes from swapped page (faulty one)
80107b7b:	68 00 10 00 00       	push   $0x1000
80107b80:	52                   	push   %edx
80107b81:	50                   	push   %eax
80107b82:	53                   	push   %ebx
80107b83:	e8 08 a7 ff ff       	call   80102290 <writeToSwapFile>
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107b88:	8b 93 a0 01 00 00    	mov    0x1a0(%ebx),%edx
80107b8e:	8b 43 04             	mov    0x4(%ebx),%eax
80107b91:	31 c9                	xor    %ecx,%ecx
80107b93:	e8 b8 f2 ff ff       	call   80106e50 <walkpgdir>
      if(!(*pte & PTE_P))
80107b98:	8b 10                	mov    (%eax),%edx
80107b9a:	83 c4 10             	add    $0x10,%esp
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107b9d:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80107b9f:	f6 c2 01             	test   $0x1,%dl
80107ba2:	0f 84 de 00 00 00    	je     80107c86 <pagefault+0x316>
      ramPa = (void*)PTE_ADDR(*pte);
80107ba8:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80107bae:	83 ec 0c             	sub    $0xc,%esp
80107bb1:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107bb7:	52                   	push   %edx
80107bb8:	e8 23 ab ff ff       	call   801026e0 <kfree>
      *pte &= ~PTE_P;                              // turn "present" flag off
80107bbd:	8b 07                	mov    (%edi),%eax
80107bbf:	83 e0 fe             	and    $0xfffffffe,%eax
80107bc2:	80 cc 02             	or     $0x2,%ah
80107bc5:	89 07                	mov    %eax,(%edi)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80107bc7:	8b 43 04             	mov    0x4(%ebx),%eax
80107bca:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107bcf:	0f 22 d8             	mov    %eax,%cr3
      ram_page->virt_addr = start_page;
80107bd2:	89 b3 a0 01 00 00    	mov    %esi,0x1a0(%ebx)
80107bd8:	83 c4 10             	add    $0x10,%esp
}
80107bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bde:	5b                   	pop    %ebx
80107bdf:	5e                   	pop    %esi
80107be0:	5f                   	pop    %edi
80107be1:	5d                   	pop    %ebp
80107be2:	c3                   	ret    
80107be3:	90                   	nop
80107be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107be8:	bf 78 00 00 00       	mov    $0x78,%edi
  return -1;
80107bed:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107bf2:	e9 1f fe ff ff       	jmp    80107a16 <pagefault+0xa6>
80107bf7:	89 f6                	mov    %esi,%esi
80107bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80107c00:	8d 43 6c             	lea    0x6c(%ebx),%eax
80107c03:	83 ec 04             	sub    $0x4,%esp
80107c06:	50                   	push   %eax
80107c07:	ff 73 10             	pushl  0x10(%ebx)
80107c0a:	68 d8 8a 10 80       	push   $0x80108ad8
80107c0f:	e8 4c 8a ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80107c14:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
80107c1b:	83 c4 10             	add    $0x10,%esp
}
80107c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107c21:	5b                   	pop    %ebx
80107c22:	5e                   	pop    %esi
80107c23:	5f                   	pop    %edi
80107c24:	5d                   	pop    %ebp
80107c25:	c3                   	ret    
80107c26:	8d 76 00             	lea    0x0(%esi),%esi
80107c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107c30:	b8 00 f0 ff ff       	mov    $0xfffff000,%eax
  return -1;
80107c35:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80107c3a:	e9 5b fe ff ff       	jmp    80107a9a <pagefault+0x12a>
80107c3f:	89 55 e0             	mov    %edx,-0x20(%ebp)
        new_page = kalloc();
80107c42:	e8 79 ad ff ff       	call   801029c0 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80107c47:	83 ec 04             	sub    $0x4,%esp
80107c4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c4d:	68 00 10 00 00       	push   $0x1000
80107c52:	53                   	push   %ebx
80107c53:	50                   	push   %eax
80107c54:	e8 17 d1 ff ff       	call   80104d70 <memmove>
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107c59:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
80107c5c:	89 f0                	mov    %esi,%eax
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80107c5e:	8b 55 e0             	mov    -0x20(%ebp),%edx
      flags = PTE_FLAGS(*pte);
80107c61:	25 ff 0f 00 00       	and    $0xfff,%eax
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80107c66:	83 c8 03             	or     $0x3,%eax
80107c69:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
80107c6f:	09 c8                	or     %ecx,%eax
80107c71:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107c73:	0f 01 3f             	invlpg (%edi)
        refDec(virt_addr); // decrement old page's ref count
80107c76:	89 1c 24             	mov    %ebx,(%esp)
80107c79:	e8 f2 ad ff ff       	call   80102a70 <refDec>
80107c7e:	83 c4 10             	add    $0x10,%esp
80107c81:	e9 c1 fe ff ff       	jmp    80107b47 <pagefault+0x1d7>
        panic("pagefault: ram page is not present");
80107c86:	83 ec 0c             	sub    $0xc,%esp
80107c89:	68 b4 8a 10 80       	push   $0x80108ab4
80107c8e:	e8 fd 86 ff ff       	call   80100390 <panic>
80107c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ca0 <copyuvm>:
{
80107ca0:	55                   	push   %ebp
80107ca1:	89 e5                	mov    %esp,%ebp
80107ca3:	57                   	push   %edi
80107ca4:	56                   	push   %esi
80107ca5:	53                   	push   %ebx
80107ca6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
80107ca9:	e8 d2 fa ff ff       	call   80107780 <setupkvm>
80107cae:	85 c0                	test   %eax,%eax
80107cb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107cb3:	0f 84 fd 00 00 00    	je     80107db6 <copyuvm+0x116>
  for(i = 0; i < sz; i += PGSIZE){
80107cb9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107cbc:	85 db                	test   %ebx,%ebx
80107cbe:	0f 84 f2 00 00 00    	je     80107db6 <copyuvm+0x116>
80107cc4:	31 db                	xor    %ebx,%ebx
80107cc6:	eb 37                	jmp    80107cff <copyuvm+0x5f>
80107cc8:	90                   	nop
80107cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
80107cd0:	83 ec 08             	sub    $0x8,%esp
80107cd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cd6:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107cdb:	56                   	push   %esi
80107cdc:	6a 00                	push   $0x0
80107cde:	89 da                	mov    %ebx,%edx
80107ce0:	e8 eb f1 ff ff       	call   80106ed0 <mappages>
80107ce5:	83 c4 10             	add    $0x10,%esp
80107ce8:	85 c0                	test   %eax,%eax
80107cea:	0f 88 eb 00 00 00    	js     80107ddb <copyuvm+0x13b>
  for(i = 0; i < sz; i += PGSIZE){
80107cf0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107cf6:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107cf9:	0f 86 b7 00 00 00    	jbe    80107db6 <copyuvm+0x116>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107cff:	8b 45 08             	mov    0x8(%ebp),%eax
80107d02:	31 c9                	xor    %ecx,%ecx
80107d04:	89 da                	mov    %ebx,%edx
80107d06:	e8 45 f1 ff ff       	call   80106e50 <walkpgdir>
80107d0b:	85 c0                	test   %eax,%eax
80107d0d:	0f 84 bb 00 00 00    	je     80107dce <copyuvm+0x12e>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107d13:	8b 10                	mov    (%eax),%edx
80107d15:	f7 c2 01 02 00 00    	test   $0x201,%edx
80107d1b:	0f 84 a0 00 00 00    	je     80107dc1 <copyuvm+0x121>
    flags = PTE_FLAGS(*pte);
80107d21:	89 d6                	mov    %edx,%esi
80107d23:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
    if(*pte & PTE_PG)
80107d29:	f6 c6 02             	test   $0x2,%dh
80107d2c:	75 a2                	jne    80107cd0 <copyuvm+0x30>
80107d2e:	89 55 e0             	mov    %edx,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80107d31:	e8 8a ac ff ff       	call   801029c0 <kalloc>
80107d36:	85 c0                	test   %eax,%eax
80107d38:	89 c7                	mov    %eax,%edi
80107d3a:	74 5a                	je     80107d96 <copyuvm+0xf6>
    pa = PTE_ADDR(*pte);
80107d3c:	8b 55 e0             	mov    -0x20(%ebp),%edx
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d3f:	83 ec 04             	sub    $0x4,%esp
80107d42:	68 00 10 00 00       	push   $0x1000
    pa = PTE_ADDR(*pte);
80107d47:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107d4d:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107d53:	52                   	push   %edx
80107d54:	50                   	push   %eax
80107d55:	e8 16 d0 ff ff       	call   80104d70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107d5a:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
80107d60:	5a                   	pop    %edx
80107d61:	59                   	pop    %ecx
80107d62:	56                   	push   %esi
80107d63:	50                   	push   %eax
80107d64:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107d69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d6c:	89 da                	mov    %ebx,%edx
80107d6e:	e8 5d f1 ff ff       	call   80106ed0 <mappages>
80107d73:	83 c4 10             	add    $0x10,%esp
80107d76:	85 c0                	test   %eax,%eax
80107d78:	0f 89 72 ff ff ff    	jns    80107cf0 <copyuvm+0x50>
      cprintf("copyuvm: mappages failed\n");
80107d7e:	83 ec 0c             	sub    $0xc,%esp
80107d81:	68 48 8a 10 80       	push   $0x80108a48
80107d86:	e8 d5 88 ff ff       	call   80100660 <cprintf>
      kfree(mem);
80107d8b:	89 3c 24             	mov    %edi,(%esp)
80107d8e:	e8 4d a9 ff ff       	call   801026e0 <kfree>
      goto bad;
80107d93:	83 c4 10             	add    $0x10,%esp
  cprintf("bad!\n");
80107d96:	83 ec 0c             	sub    $0xc,%esp
80107d99:	68 62 8a 10 80       	push   $0x80108a62
80107d9e:	e8 bd 88 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107da3:	58                   	pop    %eax
80107da4:	ff 75 e4             	pushl  -0x1c(%ebp)
80107da7:	e8 54 f9 ff ff       	call   80107700 <freevm>
  return 0;
80107dac:	83 c4 10             	add    $0x10,%esp
80107daf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107db9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107dbc:	5b                   	pop    %ebx
80107dbd:	5e                   	pop    %esi
80107dbe:	5f                   	pop    %edi
80107dbf:	5d                   	pop    %ebp
80107dc0:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
80107dc1:	83 ec 0c             	sub    $0xc,%esp
80107dc4:	68 0c 8b 10 80       	push   $0x80108b0c
80107dc9:	e8 c2 85 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107dce:	83 ec 0c             	sub    $0xc,%esp
80107dd1:	68 15 8a 10 80       	push   $0x80108a15
80107dd6:	e8 b5 85 ff ff       	call   80100390 <panic>
        panic("copyuvm: mappages failed");
80107ddb:	83 ec 0c             	sub    $0xc,%esp
80107dde:	68 2f 8a 10 80       	push   $0x80108a2f
80107de3:	e8 a8 85 ff ff       	call   80100390 <panic>
80107de8:	90                   	nop
80107de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107df0 <uva2ka>:
{
80107df0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107df1:	31 c9                	xor    %ecx,%ecx
{
80107df3:	89 e5                	mov    %esp,%ebp
80107df5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107df8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dfe:	e8 4d f0 ff ff       	call   80106e50 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107e03:	8b 00                	mov    (%eax),%eax
}
80107e05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107e06:	89 c2                	mov    %eax,%edx
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107e08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107e0d:	83 e2 05             	and    $0x5,%edx
80107e10:	05 00 00 00 80       	add    $0x80000000,%eax
80107e15:	83 fa 05             	cmp    $0x5,%edx
80107e18:	ba 00 00 00 00       	mov    $0x0,%edx
80107e1d:	0f 45 c2             	cmovne %edx,%eax
}
80107e20:	c3                   	ret    
80107e21:	eb 0d                	jmp    80107e30 <copyout>
80107e23:	90                   	nop
80107e24:	90                   	nop
80107e25:	90                   	nop
80107e26:	90                   	nop
80107e27:	90                   	nop
80107e28:	90                   	nop
80107e29:	90                   	nop
80107e2a:	90                   	nop
80107e2b:	90                   	nop
80107e2c:	90                   	nop
80107e2d:	90                   	nop
80107e2e:	90                   	nop
80107e2f:	90                   	nop

80107e30 <copyout>:
{
80107e30:	55                   	push   %ebp
80107e31:	89 e5                	mov    %esp,%ebp
80107e33:	57                   	push   %edi
80107e34:	56                   	push   %esi
80107e35:	53                   	push   %ebx
80107e36:	83 ec 1c             	sub    $0x1c,%esp
80107e39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107e3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80107e42:	85 db                	test   %ebx,%ebx
80107e44:	75 40                	jne    80107e86 <copyout+0x56>
80107e46:	eb 70                	jmp    80107eb8 <copyout+0x88>
80107e48:	90                   	nop
80107e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80107e50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107e53:	89 f1                	mov    %esi,%ecx
80107e55:	29 d1                	sub    %edx,%ecx
80107e57:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107e5d:	39 d9                	cmp    %ebx,%ecx
80107e5f:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
80107e62:	29 f2                	sub    %esi,%edx
80107e64:	83 ec 04             	sub    $0x4,%esp
80107e67:	01 d0                	add    %edx,%eax
80107e69:	51                   	push   %ecx
80107e6a:	57                   	push   %edi
80107e6b:	50                   	push   %eax
80107e6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107e6f:	e8 fc ce ff ff       	call   80104d70 <memmove>
    buf += n;
80107e74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107e77:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107e7a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107e80:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107e82:	29 cb                	sub    %ecx,%ebx
80107e84:	74 32                	je     80107eb8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107e86:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e88:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107e8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107e8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107e94:	56                   	push   %esi
80107e95:	ff 75 08             	pushl  0x8(%ebp)
80107e98:	e8 53 ff ff ff       	call   80107df0 <uva2ka>
    if(pa0 == 0)
80107e9d:	83 c4 10             	add    $0x10,%esp
80107ea0:	85 c0                	test   %eax,%eax
80107ea2:	75 ac                	jne    80107e50 <copyout+0x20>
}
80107ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107eac:	5b                   	pop    %ebx
80107ead:	5e                   	pop    %esi
80107eae:	5f                   	pop    %edi
80107eaf:	5d                   	pop    %ebp
80107eb0:	c3                   	ret    
80107eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ebb:	31 c0                	xor    %eax,%eax
}
80107ebd:	5b                   	pop    %ebx
80107ebe:	5e                   	pop    %esi
80107ebf:	5f                   	pop    %edi
80107ec0:	5d                   	pop    %ebp
80107ec1:	c3                   	ret    
80107ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ed0 <getNextFreeRamIndex>:
{ 
80107ed0:	55                   	push   %ebp
80107ed1:	89 e5                	mov    %esp,%ebp
80107ed3:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80107ed6:	e8 e5 bf ff ff       	call   80103ec0 <myproc>
80107edb:	8d 90 8c 01 00 00    	lea    0x18c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107ee1:	31 c0                	xor    %eax,%eax
80107ee3:	eb 0e                	jmp    80107ef3 <getNextFreeRamIndex+0x23>
80107ee5:	8d 76 00             	lea    0x0(%esi),%esi
80107ee8:	83 c0 01             	add    $0x1,%eax
80107eeb:	83 c2 10             	add    $0x10,%edx
80107eee:	83 f8 10             	cmp    $0x10,%eax
80107ef1:	74 0d                	je     80107f00 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107ef3:	8b 0a                	mov    (%edx),%ecx
80107ef5:	85 c9                	test   %ecx,%ecx
80107ef7:	75 ef                	jne    80107ee8 <getNextFreeRamIndex+0x18>
}
80107ef9:	c9                   	leave  
80107efa:	c3                   	ret    
80107efb:	90                   	nop
80107efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f05:	c9                   	leave  
80107f06:	c3                   	ret    
