
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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 00 f6 10 80       	mov    $0x8010f600,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 37 10 80       	mov    $0x80103740,%eax
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
80100044:	bb 34 f6 10 80       	mov    $0x8010f634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 83 10 80       	push   $0x80108360
80100051:	68 00 f6 10 80       	push   $0x8010f600
80100056:	e8 d5 4c 00 00       	call   80104d30 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 4c 3d 11 80 fc 	movl   $0x80113cfc,0x80113d4c
80100062:	3c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 50 3d 11 80 fc 	movl   $0x80113cfc,0x80113d50
8010006c:	3c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba fc 3c 11 80       	mov    $0x80113cfc,%edx
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
8010008b:	c7 43 50 fc 3c 11 80 	movl   $0x80113cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 83 10 80       	push   $0x80108367
80100097:	50                   	push   %eax
80100098:	e8 63 4b 00 00       	call   80104c00 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 3d 11 80       	mov    0x80113d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 50 3d 11 80    	mov    %ebx,0x80113d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d fc 3c 11 80       	cmp    $0x80113cfc,%eax
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
801000df:	68 00 f6 10 80       	push   $0x8010f600
801000e4:	e8 87 4d 00 00       	call   80104e70 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 3d 11 80    	mov    0x80113d50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
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
80100120:	8b 1d 4c 3d 11 80    	mov    0x80113d4c,%ebx
80100126:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 3c 11 80    	cmp    $0x80113cfc,%ebx
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
8010015d:	68 00 f6 10 80       	push   $0x8010f600
80100162:	e8 c9 4d 00 00       	call   80104f30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 4a 00 00       	call   80104c40 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 cd 25 00 00       	call   80102750 <iderw>
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
80100193:	68 6e 83 10 80       	push   $0x8010836e
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
801001ae:	e8 2d 4b 00 00       	call   80104ce0 <holdingsleep>
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
801001c4:	e9 87 25 00 00       	jmp    80102750 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 83 10 80       	push   $0x8010837f
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
801001ef:	e8 ec 4a 00 00       	call   80104ce0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 9c 4a 00 00       	call   80104ca0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 f6 10 80 	movl   $0x8010f600,(%esp)
8010020b:	e8 60 4c 00 00       	call   80104e70 <acquire>
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
80100232:	a1 50 3d 11 80       	mov    0x80113d50,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 fc 3c 11 80 	movl   $0x80113cfc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 50 3d 11 80       	mov    0x80113d50,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 50 3d 11 80    	mov    %ebx,0x80113d50
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 00 f6 10 80 	movl   $0x8010f600,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 cf 4c 00 00       	jmp    80104f30 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 83 10 80       	push   $0x80108386
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
80100280:	e8 7b 17 00 00       	call   80101a00 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 df 4b 00 00       	call   80104e70 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 3f 11 80    	mov    0x80113fe0,%edx
801002a7:	39 15 e4 3f 11 80    	cmp    %edx,0x80113fe4
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
801002bb:	68 20 c5 10 80       	push   $0x8010c520
801002c0:	68 e0 3f 11 80       	push   $0x80113fe0
801002c5:	e8 76 45 00 00       	call   80104840 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 3f 11 80    	mov    0x80113fe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 3f 11 80    	cmp    0x80113fe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 80 3e 00 00       	call   80104160 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 3c 4c 00 00       	call   80104f30 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 24 16 00 00       	call   80101920 <ilock>
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
80100313:	a3 e0 3f 11 80       	mov    %eax,0x80113fe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 3f 11 80 	movsbl -0x7feec0a0(%eax),%eax
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
80100348:	68 20 c5 10 80       	push   $0x8010c520
8010034d:	e8 de 4b 00 00       	call   80104f30 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 c6 15 00 00       	call   80101920 <ilock>
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
80100372:	89 15 e0 3f 11 80    	mov    %edx,0x80113fe0
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
80100399:	c7 05 54 c5 10 80 00 	movl   $0x0,0x8010c554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 2c 00 00       	call   80102fd0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 83 10 80       	push   $0x8010838d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 1a 8e 10 80 	movl   $0x80108e1a,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 49 00 00       	call   80104d50 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 83 10 80       	push   $0x801083a1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 c5 10 80 01 	movl   $0x1,0x8010c558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 c5 10 80    	mov    0x8010c558,%ecx
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
8010043a:	e8 11 62 00 00       	call   80106650 <uartputc>
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
801004ec:	e8 5f 61 00 00       	call   80106650 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 61 00 00       	call   80106650 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 61 00 00       	call   80106650 <uartputc>
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
80100524:	e8 07 4b 00 00       	call   80105030 <memmove>
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
80100541:	e8 3a 4a 00 00       	call   80104f80 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 83 10 80       	push   $0x801083a5
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
801005b1:	0f b6 92 d0 83 10 80 	movzbl -0x7fef7c30(%edx),%edx
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
8010060f:	e8 ec 13 00 00       	call   80101a00 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 50 48 00 00       	call   80104e70 <acquire>
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
80100642:	68 20 c5 10 80       	push   $0x8010c520
80100647:	e8 e4 48 00 00       	call   80104f30 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 12 00 00       	call   80101920 <ilock>

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
80100669:	a1 54 c5 10 80       	mov    0x8010c554,%eax
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
8010071a:	68 20 c5 10 80       	push   $0x8010c520
8010071f:	e8 0c 48 00 00       	call   80104f30 <release>
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
801007d0:	ba b8 83 10 80       	mov    $0x801083b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 7b 46 00 00       	call   80104e70 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 83 10 80       	push   $0x801083bf
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
8010081e:	68 20 c5 10 80       	push   $0x8010c520
80100823:	e8 48 46 00 00       	call   80104e70 <acquire>
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
80100851:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
80100856:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 3f 11 80       	mov    %eax,0x80113fe8
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
80100883:	68 20 c5 10 80       	push   $0x8010c520
80100888:	e8 a3 46 00 00       	call   80104f30 <release>
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
801008a9:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 3f 11 80    	sub    0x80113fe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 3f 11 80    	mov    %edx,0x80113fe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 3f 11 80    	mov    %cl,-0x7feec0a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 3f 11 80       	mov    0x80113fe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 3f 11 80    	cmp    %eax,0x80113fe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 3f 11 80       	mov    %eax,0x80113fe4
          wakeup(&input.r);
80100911:	68 e0 3f 11 80       	push   $0x80113fe0
80100916:	e8 15 41 00 00       	call   80104a30 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
8010093d:	39 05 e4 3f 11 80    	cmp    %eax,0x80113fe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 3f 11 80       	mov    %eax,0x80113fe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
80100964:	3b 05 e4 3f 11 80    	cmp    0x80113fe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 3f 11 80 0a 	cmpb   $0xa,-0x7feec0a0(%edx)
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
80100997:	e9 74 41 00 00       	jmp    80104b10 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 3f 11 80 0a 	movb   $0xa,-0x7feec0a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 3f 11 80       	mov    0x80113fe8,%eax
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
801009c6:	68 c8 83 10 80       	push   $0x801083c8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 5b 43 00 00       	call   80104d30 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac 49 11 80 00 	movl   $0x80100600,0x801149ac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 49 11 80 70 	movl   $0x80100270,0x801149a8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 02 1f 00 00       	call   80102900 <ioapicenable>
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
80100a16:	81 ec 1c 03 00 00    	sub    $0x31c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 3f 37 00 00       	call   80104160 <myproc>
      struct page ramPagesBackup[MAX_PSYC_PAGES];
      struct page swappedPagesBackup[MAX_PSYC_PAGES];
      int num_ram_backup=0, num_swap_backup=0;
      struct fblock *free_head_backup=0, *free_tail_backup=0;

    if(curproc->pid > 2)
80100a21:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *curproc = myproc();
80100a25:	89 c3                	mov    %eax,%ebx
    if(curproc->pid > 2)
80100a27:	0f 8f b3 00 00 00    	jg     80100ae0 <exec+0xd0>
      struct fblock *free_head_backup=0, *free_tail_backup=0;
80100a2d:	c7 85 e4 fc ff ff 00 	movl   $0x0,-0x31c(%ebp)
80100a34:	00 00 00 
80100a37:	c7 85 e8 fc ff ff 00 	movl   $0x0,-0x318(%ebp)
80100a3e:	00 00 00 
      int num_ram_backup=0, num_swap_backup=0;
80100a41:	c7 85 ec fc ff ff 00 	movl   $0x0,-0x314(%ebp)
80100a48:	00 00 00 
80100a4b:	c7 85 f0 fc ff ff 00 	movl   $0x0,-0x310(%ebp)
80100a52:	00 00 00 


    


  begin_op();
80100a55:	e8 e6 29 00 00       	call   80103440 <begin_op>

  if((ip = namei(path)) == 0){
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	ff 75 08             	pushl  0x8(%ebp)
80100a60:	e8 1b 17 00 00       	call   80102180 <namei>
80100a65:	83 c4 10             	add    $0x10,%esp
80100a68:	85 c0                	test   %eax,%eax
80100a6a:	89 c6                	mov    %eax,%esi
80100a6c:	0f 84 ae 03 00 00    	je     80100e20 <exec+0x410>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a72:	83 ec 0c             	sub    $0xc,%esp
80100a75:	50                   	push   %eax
80100a76:	e8 a5 0e 00 00       	call   80101920 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a7b:	8d 85 24 fd ff ff    	lea    -0x2dc(%ebp),%eax
80100a81:	6a 34                	push   $0x34
80100a83:	6a 00                	push   $0x0
80100a85:	50                   	push   %eax
80100a86:	56                   	push   %esi
80100a87:	e8 74 11 00 00       	call   80101c00 <readi>
80100a8c:	83 c4 20             	add    $0x20,%esp
80100a8f:	83 f8 34             	cmp    $0x34,%eax
80100a92:	75 10                	jne    80100aa4 <exec+0x94>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a94:	81 bd 24 fd ff ff 7f 	cmpl   $0x464c457f,-0x2dc(%ebp)
80100a9b:	45 4c 46 
80100a9e:	0f 84 3c 02 00 00    	je     80100ce0 <exec+0x2d0>
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  cprintf("exec: bad\n");
80100aa4:	83 ec 0c             	sub    $0xc,%esp
80100aa7:	68 f7 83 10 80       	push   $0x801083f7
80100aac:	e8 af fb ff ff       	call   80100660 <cprintf>
  if(pgdir)
    freevm(pgdir);
  /* restoring variables */
  if(curproc->pid > 2)
80100ab1:	83 c4 10             	add    $0x10,%esp
80100ab4:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100ab8:	0f 8f aa 01 00 00    	jg     80100c68 <exec+0x258>

  }
  

  if(ip){
    iunlockput(ip);
80100abe:	83 ec 0c             	sub    $0xc,%esp
80100ac1:	56                   	push   %esi
80100ac2:	e8 e9 10 00 00       	call   80101bb0 <iunlockput>
    end_op();
80100ac7:	e8 e4 29 00 00       	call   801034b0 <end_op>
80100acc:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ad4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ad7:	5b                   	pop    %ebx
80100ad8:	5e                   	pop    %esi
80100ad9:	5f                   	pop    %edi
80100ada:	5d                   	pop    %ebp
80100adb:	c3                   	ret    
80100adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("exec now\n");
80100ae0:	83 ec 0c             	sub    $0xc,%esp
      memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100ae3:	8d b3 88 01 00 00    	lea    0x188(%ebx),%esi
      memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100ae9:	8d bb 88 00 00 00    	lea    0x88(%ebx),%edi
      cprintf("exec now\n");
80100aef:	68 e1 83 10 80       	push   $0x801083e1
80100af4:	e8 67 fb ff ff       	call   80100660 <cprintf>
      memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100af9:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80100aff:	83 c4 0c             	add    $0xc,%esp
80100b02:	68 00 01 00 00       	push   $0x100
80100b07:	56                   	push   %esi
80100b08:	50                   	push   %eax
80100b09:	e8 22 45 00 00       	call   80105030 <memmove>
      memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100b0e:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100b14:	83 c4 0c             	add    $0xc,%esp
80100b17:	68 00 01 00 00       	push   $0x100
80100b1c:	57                   	push   %edi
80100b1d:	50                   	push   %eax
80100b1e:	e8 0d 45 00 00       	call   80105030 <memmove>
      num_ram_backup = curproc->num_ram; num_swap_backup = curproc->num_swap;
80100b23:	8b 83 88 02 00 00    	mov    0x288(%ebx),%eax
      memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
80100b29:	83 c4 0c             	add    $0xc,%esp
      num_ram_backup = curproc->num_ram; num_swap_backup = curproc->num_swap;
80100b2c:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%ebp)
80100b32:	8b 83 8c 02 00 00    	mov    0x28c(%ebx),%eax
80100b38:	89 85 ec fc ff ff    	mov    %eax,-0x314(%ebp)
      free_head_backup = curproc->free_head;
80100b3e:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80100b44:	89 85 e8 fc ff ff    	mov    %eax,-0x318(%ebp)
      free_tail_backup = curproc->free_tail;
80100b4a:	8b 83 94 02 00 00    	mov    0x294(%ebx),%eax
      memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
80100b50:	68 00 01 00 00       	push   $0x100
80100b55:	6a 00                	push   $0x0
80100b57:	57                   	push   %edi
      free_tail_backup = curproc->free_tail;
80100b58:	89 85 e4 fc ff ff    	mov    %eax,-0x31c(%ebp)
      memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
80100b5e:	e8 1d 44 00 00       	call   80104f80 <memset>
      memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100b63:	83 c4 0c             	add    $0xc,%esp
80100b66:	68 00 01 00 00       	push   $0x100
80100b6b:	6a 00                	push   $0x0
80100b6d:	56                   	push   %esi
      struct fblock *prev = curproc->free_head;
80100b6e:	be 00 10 00 00       	mov    $0x1000,%esi
      memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100b73:	e8 08 44 00 00       	call   80104f80 <memset>
      curproc->num_ram = 0; curproc->num_swap = 0;
80100b78:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80100b7f:	00 00 00 
80100b82:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80100b89:	00 00 00 
      curproc->free_head = (struct fblock*)kalloc();
80100b8c:	e8 8f 20 00 00       	call   80102c20 <kalloc>
80100b91:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
      curproc->free_head->prev = 0;
80100b97:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = curproc->free_head;
80100b9e:	83 c4 10             	add    $0x10,%esp
      curproc->free_head->off = 0 * PGSIZE;
80100ba1:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80100ba7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = curproc->free_head;
80100bad:	8b bb 90 02 00 00    	mov    0x290(%ebx),%edi
80100bb3:	90                   	nop
80100bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        struct fblock *curr = (struct fblock*)kalloc();
80100bb8:	e8 63 20 00 00       	call   80102c20 <kalloc>
        curr->off = i * PGSIZE;
80100bbd:	89 30                	mov    %esi,(%eax)
80100bbf:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
80100bc5:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100bc8:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80100bce:	89 47 04             	mov    %eax,0x4(%edi)
80100bd1:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100bd3:	75 e3                	jne    80100bb8 <exec+0x1a8>
      curproc->free_tail = prev;
80100bd5:	89 83 94 02 00 00    	mov    %eax,0x294(%ebx)
      curproc->free_tail->next = 0;
80100bdb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80100be2:	e9 6e fe ff ff       	jmp    80100a55 <exec+0x45>
80100be7:	89 d8                	mov    %ebx,%eax
80100be9:	8b 9d dc fc ff ff    	mov    -0x324(%ebp),%ebx
80100bef:	05 ff 0f 00 00       	add    $0xfff,%eax
80100bf4:	89 c7                	mov    %eax,%edi
80100bf6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100bfc:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	89 85 e0 fc ff ff    	mov    %eax,-0x320(%ebp)
80100c0b:	56                   	push   %esi
80100c0c:	e8 9f 0f 00 00       	call   80101bb0 <iunlockput>
  end_op();
80100c11:	e8 9a 28 00 00       	call   801034b0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c16:	8b 85 e0 fc ff ff    	mov    -0x320(%ebp),%eax
80100c1c:	83 c4 0c             	add    $0xc,%esp
80100c1f:	50                   	push   %eax
80100c20:	57                   	push   %edi
80100c21:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
80100c27:	e8 54 6b 00 00       	call   80107780 <allocuvm>
80100c2c:	83 c4 10             	add    $0x10,%esp
80100c2f:	85 c0                	test   %eax,%eax
80100c31:	89 85 e0 fc ff ff    	mov    %eax,-0x320(%ebp)
80100c37:	0f 85 02 02 00 00    	jne    80100e3f <exec+0x42f>
  cprintf("exec: bad\n");
80100c3d:	83 ec 0c             	sub    $0xc,%esp
80100c40:	68 f7 83 10 80       	push   $0x801083f7
80100c45:	e8 16 fa ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100c4a:	5a                   	pop    %edx
80100c4b:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
80100c51:	e8 3a 6e 00 00       	call   80107a90 <freevm>
  if(curproc->pid > 2)
80100c56:	83 c4 10             	add    $0x10,%esp
80100c59:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100c5d:	0f 8e 6c fe ff ff    	jle    80100acf <exec+0xbf>
  ip = 0;
80100c63:	31 f6                	xor    %esi,%esi
80100c65:	8d 76 00             	lea    0x0(%esi),%esi
    memmove((void*)curproc->ramPages, ramPagesBackup, 16 * sizeof(struct page));
80100c68:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80100c6e:	83 ec 04             	sub    $0x4,%esp
80100c71:	68 00 01 00 00       	push   $0x100
80100c76:	50                   	push   %eax
80100c77:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80100c7d:	50                   	push   %eax
80100c7e:	e8 ad 43 00 00       	call   80105030 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100c83:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100c89:	83 c4 0c             	add    $0xc,%esp
80100c8c:	68 00 01 00 00       	push   $0x100
80100c91:	50                   	push   %eax
80100c92:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100c98:	50                   	push   %eax
80100c99:	e8 92 43 00 00       	call   80105030 <memmove>
    curproc->free_head = free_head_backup;
80100c9e:	8b 85 e8 fc ff ff    	mov    -0x318(%ebp),%eax
  if(ip){
80100ca4:	83 c4 10             	add    $0x10,%esp
80100ca7:	85 f6                	test   %esi,%esi
    curproc->free_head = free_head_backup;
80100ca9:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
    curproc->free_tail = free_tail_backup;
80100caf:	8b 85 e4 fc ff ff    	mov    -0x31c(%ebp),%eax
80100cb5:	89 83 94 02 00 00    	mov    %eax,0x294(%ebx)
    curproc->num_ram = num_ram_backup;
80100cbb:	8b 85 f0 fc ff ff    	mov    -0x310(%ebp),%eax
80100cc1:	89 83 88 02 00 00    	mov    %eax,0x288(%ebx)
    curproc->num_swap = num_swap_backup;
80100cc7:	8b 85 ec fc ff ff    	mov    -0x314(%ebp),%eax
80100ccd:	89 83 8c 02 00 00    	mov    %eax,0x28c(%ebx)
  if(ip){
80100cd3:	0f 84 f6 fd ff ff    	je     80100acf <exec+0xbf>
80100cd9:	e9 e0 fd ff ff       	jmp    80100abe <exec+0xae>
80100cde:	66 90                	xchg   %ax,%ax
  if((pgdir = setupkvm()) == 0)
80100ce0:	e8 2b 6e 00 00       	call   80107b10 <setupkvm>
80100ce5:	85 c0                	test   %eax,%eax
80100ce7:	89 85 f4 fc ff ff    	mov    %eax,-0x30c(%ebp)
80100ced:	0f 84 0d 01 00 00    	je     80100e00 <exec+0x3f0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cf3:	66 83 bd 50 fd ff ff 	cmpw   $0x0,-0x2b0(%ebp)
80100cfa:	00 
80100cfb:	8b 85 40 fd ff ff    	mov    -0x2c0(%ebp),%eax
80100d01:	89 85 e0 fc ff ff    	mov    %eax,-0x320(%ebp)
80100d07:	0f 84 c8 02 00 00    	je     80100fd5 <exec+0x5c5>
  sz = 0;
80100d0d:	31 c0                	xor    %eax,%eax
80100d0f:	89 9d dc fc ff ff    	mov    %ebx,-0x324(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d15:	31 ff                	xor    %edi,%edi
80100d17:	89 c3                	mov    %eax,%ebx
80100d19:	e9 84 00 00 00       	jmp    80100da2 <exec+0x392>
80100d1e:	66 90                	xchg   %ax,%ax
    if(ph.type != ELF_PROG_LOAD)
80100d20:	83 bd 04 fd ff ff 01 	cmpl   $0x1,-0x2fc(%ebp)
80100d27:	75 67                	jne    80100d90 <exec+0x380>
    if(ph.memsz < ph.filesz)
80100d29:	8b 85 18 fd ff ff    	mov    -0x2e8(%ebp),%eax
80100d2f:	3b 85 14 fd ff ff    	cmp    -0x2ec(%ebp),%eax
80100d35:	0f 82 8e 00 00 00    	jb     80100dc9 <exec+0x3b9>
80100d3b:	03 85 0c fd ff ff    	add    -0x2f4(%ebp),%eax
80100d41:	0f 82 82 00 00 00    	jb     80100dc9 <exec+0x3b9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d47:	83 ec 04             	sub    $0x4,%esp
80100d4a:	50                   	push   %eax
80100d4b:	53                   	push   %ebx
80100d4c:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
80100d52:	e8 29 6a 00 00       	call   80107780 <allocuvm>
80100d57:	83 c4 10             	add    $0x10,%esp
80100d5a:	85 c0                	test   %eax,%eax
80100d5c:	89 c3                	mov    %eax,%ebx
80100d5e:	74 69                	je     80100dc9 <exec+0x3b9>
    if(ph.vaddr % PGSIZE != 0)
80100d60:	8b 85 0c fd ff ff    	mov    -0x2f4(%ebp),%eax
80100d66:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d6b:	75 5c                	jne    80100dc9 <exec+0x3b9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d6d:	83 ec 0c             	sub    $0xc,%esp
80100d70:	ff b5 14 fd ff ff    	pushl  -0x2ec(%ebp)
80100d76:	ff b5 08 fd ff ff    	pushl  -0x2f8(%ebp)
80100d7c:	56                   	push   %esi
80100d7d:	50                   	push   %eax
80100d7e:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
80100d84:	e8 47 67 00 00       	call   801074d0 <loaduvm>
80100d89:	83 c4 20             	add    $0x20,%esp
80100d8c:	85 c0                	test   %eax,%eax
80100d8e:	78 39                	js     80100dc9 <exec+0x3b9>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d90:	0f b7 85 50 fd ff ff 	movzwl -0x2b0(%ebp),%eax
80100d97:	83 c7 01             	add    $0x1,%edi
80100d9a:	39 f8                	cmp    %edi,%eax
80100d9c:	0f 8e 45 fe ff ff    	jle    80100be7 <exec+0x1d7>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100da2:	89 f8                	mov    %edi,%eax
80100da4:	6a 20                	push   $0x20
80100da6:	c1 e0 05             	shl    $0x5,%eax
80100da9:	03 85 e0 fc ff ff    	add    -0x320(%ebp),%eax
80100daf:	50                   	push   %eax
80100db0:	8d 85 04 fd ff ff    	lea    -0x2fc(%ebp),%eax
80100db6:	50                   	push   %eax
80100db7:	56                   	push   %esi
80100db8:	e8 43 0e 00 00       	call   80101c00 <readi>
80100dbd:	83 c4 10             	add    $0x10,%esp
80100dc0:	83 f8 20             	cmp    $0x20,%eax
80100dc3:	0f 84 57 ff ff ff    	je     80100d20 <exec+0x310>
  cprintf("exec: bad\n");
80100dc9:	83 ec 0c             	sub    $0xc,%esp
80100dcc:	8b 9d dc fc ff ff    	mov    -0x324(%ebp),%ebx
80100dd2:	68 f7 83 10 80       	push   $0x801083f7
80100dd7:	e8 84 f8 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100ddc:	58                   	pop    %eax
80100ddd:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
80100de3:	e8 a8 6c 00 00       	call   80107a90 <freevm>
  if(curproc->pid > 2)
80100de8:	83 c4 10             	add    $0x10,%esp
80100deb:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100def:	0f 8e c9 fc ff ff    	jle    80100abe <exec+0xae>
80100df5:	e9 6e fe ff ff       	jmp    80100c68 <exec+0x258>
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cprintf("exec: bad\n");
80100e00:	83 ec 0c             	sub    $0xc,%esp
80100e03:	68 f7 83 10 80       	push   $0x801083f7
80100e08:	e8 53 f8 ff ff       	call   80100660 <cprintf>
  if(curproc->pid > 2)
80100e0d:	83 c4 10             	add    $0x10,%esp
80100e10:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100e14:	0f 8f 4e fe ff ff    	jg     80100c68 <exec+0x258>
80100e1a:	e9 9f fc ff ff       	jmp    80100abe <exec+0xae>
80100e1f:	90                   	nop
    end_op();
80100e20:	e8 8b 26 00 00       	call   801034b0 <end_op>
    cprintf("exec: fail\n");
80100e25:	83 ec 0c             	sub    $0xc,%esp
80100e28:	68 eb 83 10 80       	push   $0x801083eb
80100e2d:	e8 2e f8 ff ff       	call   80100660 <cprintf>
    return -1;
80100e32:	83 c4 10             	add    $0x10,%esp
80100e35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e3a:	e9 95 fc ff ff       	jmp    80100ad4 <exec+0xc4>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e3f:	89 c6                	mov    %eax,%esi
80100e41:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100e47:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100e4a:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e4c:	50                   	push   %eax
80100e4d:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
80100e53:	e8 68 6d 00 00       	call   80107bc0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100e58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e5b:	83 c4 10             	add    $0x10,%esp
80100e5e:	8b 00                	mov    (%eax),%eax
80100e60:	85 c0                	test   %eax,%eax
80100e62:	0f 84 79 01 00 00    	je     80100fe1 <exec+0x5d1>
80100e68:	89 9d dc fc ff ff    	mov    %ebx,-0x324(%ebp)
80100e6e:	8b 9d f4 fc ff ff    	mov    -0x30c(%ebp),%ebx
80100e74:	eb 1f                	jmp    80100e95 <exec+0x485>
80100e76:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100e79:	89 b4 bd 64 fd ff ff 	mov    %esi,-0x29c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100e80:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100e83:	8d 8d 58 fd ff ff    	lea    -0x2a8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100e89:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100e8c:	85 c0                	test   %eax,%eax
80100e8e:	74 44                	je     80100ed4 <exec+0x4c4>
    if(argc >= MAXARG)
80100e90:	83 ff 20             	cmp    $0x20,%edi
80100e93:	74 34                	je     80100ec9 <exec+0x4b9>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e95:	83 ec 0c             	sub    $0xc,%esp
80100e98:	50                   	push   %eax
80100e99:	e8 02 43 00 00       	call   801051a0 <strlen>
80100e9e:	f7 d0                	not    %eax
80100ea0:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ea2:	58                   	pop    %eax
80100ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ea6:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ea9:	ff 34 b8             	pushl  (%eax,%edi,4)
80100eac:	e8 ef 42 00 00       	call   801051a0 <strlen>
80100eb1:	83 c0 01             	add    $0x1,%eax
80100eb4:	50                   	push   %eax
80100eb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100eb8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ebb:	56                   	push   %esi
80100ebc:	53                   	push   %ebx
80100ebd:	e8 ae 73 00 00       	call   80108270 <copyout>
80100ec2:	83 c4 20             	add    $0x20,%esp
80100ec5:	85 c0                	test   %eax,%eax
80100ec7:	79 ad                	jns    80100e76 <exec+0x466>
80100ec9:	8b 9d dc fc ff ff    	mov    -0x324(%ebp),%ebx
80100ecf:	e9 69 fd ff ff       	jmp    80100c3d <exec+0x22d>
80100ed4:	8b 9d dc fc ff ff    	mov    -0x324(%ebp),%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100eda:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100ee1:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100ee3:	c7 84 bd 64 fd ff ff 	movl   $0x0,-0x29c(%ebp,%edi,4)
80100eea:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100eee:	c7 85 58 fd ff ff ff 	movl   $0xffffffff,-0x2a8(%ebp)
80100ef5:	ff ff ff 
  ustack[1] = argc;
80100ef8:	89 bd 5c fd ff ff    	mov    %edi,-0x2a4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100efe:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100f00:	83 c0 0c             	add    $0xc,%eax
80100f03:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f05:	50                   	push   %eax
80100f06:	51                   	push   %ecx
80100f07:	56                   	push   %esi
80100f08:	ff b5 f4 fc ff ff    	pushl  -0x30c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f0e:	89 95 60 fd ff ff    	mov    %edx,-0x2a0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f14:	e8 57 73 00 00       	call   80108270 <copyout>
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 c0                	test   %eax,%eax
80100f1e:	0f 88 19 fd ff ff    	js     80100c3d <exec+0x22d>
  for(last=s=path; *s; s++)
80100f24:	8b 45 08             	mov    0x8(%ebp),%eax
80100f27:	0f b6 10             	movzbl (%eax),%edx
80100f2a:	84 d2                	test   %dl,%dl
80100f2c:	0f 84 c0 00 00 00    	je     80100ff2 <exec+0x5e2>
80100f32:	89 c1                	mov    %eax,%ecx
80100f34:	83 c1 01             	add    $0x1,%ecx
80100f37:	80 fa 2f             	cmp    $0x2f,%dl
80100f3a:	0f b6 11             	movzbl (%ecx),%edx
80100f3d:	0f 44 c1             	cmove  %ecx,%eax
80100f40:	84 d2                	test   %dl,%dl
80100f42:	75 f0                	jne    80100f34 <exec+0x524>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100f44:	83 ec 04             	sub    $0x4,%esp
80100f47:	6a 10                	push   $0x10
80100f49:	50                   	push   %eax
80100f4a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80100f4d:	50                   	push   %eax
80100f4e:	e8 0d 42 00 00       	call   80105160 <safestrcpy>
80100f53:	8b 8d f4 fc ff ff    	mov    -0x30c(%ebp),%ecx
80100f59:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100f5f:	8d 93 88 01 00 00    	lea    0x188(%ebx),%edx
80100f65:	83 c4 10             	add    $0x10,%esp
    if(curproc->ramPages[ind].isused)
80100f68:	8b b8 04 01 00 00    	mov    0x104(%eax),%edi
80100f6e:	85 ff                	test   %edi,%edi
80100f70:	74 06                	je     80100f78 <exec+0x568>
      curproc->ramPages[ind].pgdir = pgdir;
80100f72:	89 88 00 01 00 00    	mov    %ecx,0x100(%eax)
    if(curproc->swappedPages[ind].isused)
80100f78:	8b 78 04             	mov    0x4(%eax),%edi
80100f7b:	85 ff                	test   %edi,%edi
80100f7d:	74 02                	je     80100f81 <exec+0x571>
      curproc->swappedPages[ind].pgdir = pgdir;
80100f7f:	89 08                	mov    %ecx,(%eax)
80100f81:	83 c0 10             	add    $0x10,%eax
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
80100f84:	39 d0                	cmp    %edx,%eax
80100f86:	75 e0                	jne    80100f68 <exec+0x558>
  oldpgdir = curproc->pgdir;
80100f88:	8b 43 04             	mov    0x4(%ebx),%eax
  curproc->tf->eip = elf.entry;  // main
80100f8b:	8b 53 18             	mov    0x18(%ebx),%edx
  switchuvm(curproc);
80100f8e:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
80100f91:	89 85 f0 fc ff ff    	mov    %eax,-0x310(%ebp)
  curproc->pgdir = pgdir;
80100f97:	8b 85 f4 fc ff ff    	mov    -0x30c(%ebp),%eax
80100f9d:	89 43 04             	mov    %eax,0x4(%ebx)
  curproc->sz = sz;
80100fa0:	8b 85 e0 fc ff ff    	mov    -0x320(%ebp),%eax
80100fa6:	89 03                	mov    %eax,(%ebx)
  curproc->tf->eip = elf.entry;  // main
80100fa8:	8b 8d 3c fd ff ff    	mov    -0x2c4(%ebp),%ecx
80100fae:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
80100fb1:	8b 53 18             	mov    0x18(%ebx),%edx
80100fb4:	89 72 44             	mov    %esi,0x44(%edx)
  switchuvm(curproc);
80100fb7:	53                   	push   %ebx
80100fb8:	e8 83 63 00 00       	call   80107340 <switchuvm>
  freevm(oldpgdir);
80100fbd:	8b 85 f0 fc ff ff    	mov    -0x310(%ebp),%eax
80100fc3:	89 04 24             	mov    %eax,(%esp)
80100fc6:	e8 c5 6a 00 00       	call   80107a90 <freevm>
  return 0;
80100fcb:	83 c4 10             	add    $0x10,%esp
80100fce:	31 c0                	xor    %eax,%eax
80100fd0:	e9 ff fa ff ff       	jmp    80100ad4 <exec+0xc4>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100fd5:	31 ff                	xor    %edi,%edi
80100fd7:	b8 00 20 00 00       	mov    $0x2000,%eax
80100fdc:	e9 21 fc ff ff       	jmp    80100c02 <exec+0x1f2>
  for(argc = 0; argv[argc]; argc++) {
80100fe1:	8b b5 e0 fc ff ff    	mov    -0x320(%ebp),%esi
80100fe7:	8d 8d 58 fd ff ff    	lea    -0x2a8(%ebp),%ecx
80100fed:	e9 e8 fe ff ff       	jmp    80100eda <exec+0x4ca>
  for(last=s=path; *s; s++)
80100ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff5:	e9 4a ff ff ff       	jmp    80100f44 <exec+0x534>
80100ffa:	66 90                	xchg   %ax,%ax
80100ffc:	66 90                	xchg   %ax,%ax
80100ffe:	66 90                	xchg   %ax,%ax

80101000 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101006:	68 02 84 10 80       	push   $0x80108402
8010100b:	68 00 40 11 80       	push   $0x80114000
80101010:	e8 1b 3d 00 00       	call   80104d30 <initlock>
}
80101015:	83 c4 10             	add    $0x10,%esp
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101024:	bb 34 40 11 80       	mov    $0x80114034,%ebx
{
80101029:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010102c:	68 00 40 11 80       	push   $0x80114000
80101031:	e8 3a 3e 00 00       	call   80104e70 <acquire>
80101036:	83 c4 10             	add    $0x10,%esp
80101039:	eb 10                	jmp    8010104b <filealloc+0x2b>
8010103b:	90                   	nop
8010103c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101040:	83 c3 18             	add    $0x18,%ebx
80101043:	81 fb 94 49 11 80    	cmp    $0x80114994,%ebx
80101049:	73 25                	jae    80101070 <filealloc+0x50>
    if(f->ref == 0){
8010104b:	8b 43 04             	mov    0x4(%ebx),%eax
8010104e:	85 c0                	test   %eax,%eax
80101050:	75 ee                	jne    80101040 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101052:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101055:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010105c:	68 00 40 11 80       	push   $0x80114000
80101061:	e8 ca 3e 00 00       	call   80104f30 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101066:	89 d8                	mov    %ebx,%eax
      return f;
80101068:	83 c4 10             	add    $0x10,%esp
}
8010106b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010106e:	c9                   	leave  
8010106f:	c3                   	ret    
  release(&ftable.lock);
80101070:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101073:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101075:	68 00 40 11 80       	push   $0x80114000
8010107a:	e8 b1 3e 00 00       	call   80104f30 <release>
}
8010107f:	89 d8                	mov    %ebx,%eax
  return 0;
80101081:	83 c4 10             	add    $0x10,%esp
}
80101084:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101087:	c9                   	leave  
80101088:	c3                   	ret    
80101089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101090 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101090:	55                   	push   %ebp
80101091:	89 e5                	mov    %esp,%ebp
80101093:	53                   	push   %ebx
80101094:	83 ec 10             	sub    $0x10,%esp
80101097:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010109a:	68 00 40 11 80       	push   $0x80114000
8010109f:	e8 cc 3d 00 00       	call   80104e70 <acquire>
  if(f->ref < 1)
801010a4:	8b 43 04             	mov    0x4(%ebx),%eax
801010a7:	83 c4 10             	add    $0x10,%esp
801010aa:	85 c0                	test   %eax,%eax
801010ac:	7e 1a                	jle    801010c8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801010ae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801010b1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801010b4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801010b7:	68 00 40 11 80       	push   $0x80114000
801010bc:	e8 6f 3e 00 00       	call   80104f30 <release>
  return f;
}
801010c1:	89 d8                	mov    %ebx,%eax
801010c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801010c6:	c9                   	leave  
801010c7:	c3                   	ret    
    panic("filedup");
801010c8:	83 ec 0c             	sub    $0xc,%esp
801010cb:	68 09 84 10 80       	push   $0x80108409
801010d0:	e8 bb f2 ff ff       	call   80100390 <panic>
801010d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801010e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801010e0:	55                   	push   %ebp
801010e1:	89 e5                	mov    %esp,%ebp
801010e3:	57                   	push   %edi
801010e4:	56                   	push   %esi
801010e5:	53                   	push   %ebx
801010e6:	83 ec 28             	sub    $0x28,%esp
801010e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801010ec:	68 00 40 11 80       	push   $0x80114000
801010f1:	e8 7a 3d 00 00       	call   80104e70 <acquire>
  if(f->ref < 1)
801010f6:	8b 43 04             	mov    0x4(%ebx),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	85 c0                	test   %eax,%eax
801010fe:	0f 8e 9b 00 00 00    	jle    8010119f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101104:	83 e8 01             	sub    $0x1,%eax
80101107:	85 c0                	test   %eax,%eax
80101109:	89 43 04             	mov    %eax,0x4(%ebx)
8010110c:	74 1a                	je     80101128 <fileclose+0x48>
    release(&ftable.lock);
8010110e:	c7 45 08 00 40 11 80 	movl   $0x80114000,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101115:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101118:	5b                   	pop    %ebx
80101119:	5e                   	pop    %esi
8010111a:	5f                   	pop    %edi
8010111b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010111c:	e9 0f 3e 00 00       	jmp    80104f30 <release>
80101121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101128:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010112c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010112e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101131:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101134:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010113a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010113d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101140:	68 00 40 11 80       	push   $0x80114000
  ff = *f;
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101148:	e8 e3 3d 00 00       	call   80104f30 <release>
  if(ff.type == FD_PIPE)
8010114d:	83 c4 10             	add    $0x10,%esp
80101150:	83 ff 01             	cmp    $0x1,%edi
80101153:	74 13                	je     80101168 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101155:	83 ff 02             	cmp    $0x2,%edi
80101158:	74 26                	je     80101180 <fileclose+0xa0>
}
8010115a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010115d:	5b                   	pop    %ebx
8010115e:	5e                   	pop    %esi
8010115f:	5f                   	pop    %edi
80101160:	5d                   	pop    %ebp
80101161:	c3                   	ret    
80101162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101168:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010116c:	83 ec 08             	sub    $0x8,%esp
8010116f:	53                   	push   %ebx
80101170:	56                   	push   %esi
80101171:	e8 7a 2a 00 00       	call   80103bf0 <pipeclose>
80101176:	83 c4 10             	add    $0x10,%esp
80101179:	eb df                	jmp    8010115a <fileclose+0x7a>
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101180:	e8 bb 22 00 00       	call   80103440 <begin_op>
    iput(ff.ip);
80101185:	83 ec 0c             	sub    $0xc,%esp
80101188:	ff 75 e0             	pushl  -0x20(%ebp)
8010118b:	e8 c0 08 00 00       	call   80101a50 <iput>
    end_op();
80101190:	83 c4 10             	add    $0x10,%esp
}
80101193:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101196:	5b                   	pop    %ebx
80101197:	5e                   	pop    %esi
80101198:	5f                   	pop    %edi
80101199:	5d                   	pop    %ebp
    end_op();
8010119a:	e9 11 23 00 00       	jmp    801034b0 <end_op>
    panic("fileclose");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 11 84 10 80       	push   $0x80108411
801011a7:	e8 e4 f1 ff ff       	call   80100390 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011b0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	53                   	push   %ebx
801011b4:	83 ec 04             	sub    $0x4,%esp
801011b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801011ba:	83 3b 02             	cmpl   $0x2,(%ebx)
801011bd:	75 31                	jne    801011f0 <filestat+0x40>
    ilock(f->ip);
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	ff 73 10             	pushl  0x10(%ebx)
801011c5:	e8 56 07 00 00       	call   80101920 <ilock>
    stati(f->ip, st);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	ff 75 0c             	pushl  0xc(%ebp)
801011cf:	ff 73 10             	pushl  0x10(%ebx)
801011d2:	e8 f9 09 00 00       	call   80101bd0 <stati>
    iunlock(f->ip);
801011d7:	59                   	pop    %ecx
801011d8:	ff 73 10             	pushl  0x10(%ebx)
801011db:	e8 20 08 00 00       	call   80101a00 <iunlock>
    return 0;
801011e0:	83 c4 10             	add    $0x10,%esp
801011e3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801011e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011e8:	c9                   	leave  
801011e9:	c3                   	ret    
801011ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801011f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011f5:	eb ee                	jmp    801011e5 <filestat+0x35>
801011f7:	89 f6                	mov    %esi,%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101200 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	83 ec 0c             	sub    $0xc,%esp
80101209:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010120c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010120f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101212:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101216:	74 60                	je     80101278 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101218:	8b 03                	mov    (%ebx),%eax
8010121a:	83 f8 01             	cmp    $0x1,%eax
8010121d:	74 41                	je     80101260 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010121f:	83 f8 02             	cmp    $0x2,%eax
80101222:	75 5b                	jne    8010127f <fileread+0x7f>
    ilock(f->ip);
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	ff 73 10             	pushl  0x10(%ebx)
8010122a:	e8 f1 06 00 00       	call   80101920 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010122f:	57                   	push   %edi
80101230:	ff 73 14             	pushl  0x14(%ebx)
80101233:	56                   	push   %esi
80101234:	ff 73 10             	pushl  0x10(%ebx)
80101237:	e8 c4 09 00 00       	call   80101c00 <readi>
8010123c:	83 c4 20             	add    $0x20,%esp
8010123f:	85 c0                	test   %eax,%eax
80101241:	89 c6                	mov    %eax,%esi
80101243:	7e 03                	jle    80101248 <fileread+0x48>
      f->off += r;
80101245:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101248:	83 ec 0c             	sub    $0xc,%esp
8010124b:	ff 73 10             	pushl  0x10(%ebx)
8010124e:	e8 ad 07 00 00       	call   80101a00 <iunlock>
    return r;
80101253:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101256:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101259:	89 f0                	mov    %esi,%eax
8010125b:	5b                   	pop    %ebx
8010125c:	5e                   	pop    %esi
8010125d:	5f                   	pop    %edi
8010125e:	5d                   	pop    %ebp
8010125f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101260:	8b 43 0c             	mov    0xc(%ebx),%eax
80101263:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101266:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101269:	5b                   	pop    %ebx
8010126a:	5e                   	pop    %esi
8010126b:	5f                   	pop    %edi
8010126c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010126d:	e9 2e 2b 00 00       	jmp    80103da0 <piperead>
80101272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101278:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010127d:	eb d7                	jmp    80101256 <fileread+0x56>
  panic("fileread");
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	68 1b 84 10 80       	push   $0x8010841b
80101287:	e8 04 f1 ff ff       	call   80100390 <panic>
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101290 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 1c             	sub    $0x1c,%esp
80101299:	8b 75 08             	mov    0x8(%ebp),%esi
8010129c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010129f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801012a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801012a6:	8b 45 10             	mov    0x10(%ebp),%eax
801012a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801012ac:	0f 84 aa 00 00 00    	je     8010135c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801012b2:	8b 06                	mov    (%esi),%eax
801012b4:	83 f8 01             	cmp    $0x1,%eax
801012b7:	0f 84 c3 00 00 00    	je     80101380 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801012bd:	83 f8 02             	cmp    $0x2,%eax
801012c0:	0f 85 d9 00 00 00    	jne    8010139f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801012c9:	31 ff                	xor    %edi,%edi
    while(i < n){
801012cb:	85 c0                	test   %eax,%eax
801012cd:	7f 34                	jg     80101303 <filewrite+0x73>
801012cf:	e9 9c 00 00 00       	jmp    80101370 <filewrite+0xe0>
801012d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801012d8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801012db:	83 ec 0c             	sub    $0xc,%esp
801012de:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801012e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801012e4:	e8 17 07 00 00       	call   80101a00 <iunlock>
      end_op();
801012e9:	e8 c2 21 00 00       	call   801034b0 <end_op>
801012ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012f1:	83 c4 10             	add    $0x10,%esp
      if(r < 0)
        break;
      if(r != n1)
801012f4:	39 c3                	cmp    %eax,%ebx
801012f6:	0f 85 96 00 00 00    	jne    80101392 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801012fc:	01 df                	add    %ebx,%edi
    while(i < n){
801012fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101301:	7e 6d                	jle    80101370 <filewrite+0xe0>
      int n1 = n - i;
80101303:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101306:	b8 00 06 00 00       	mov    $0x600,%eax
8010130b:	29 fb                	sub    %edi,%ebx
8010130d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101313:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101316:	e8 25 21 00 00       	call   80103440 <begin_op>
      ilock(f->ip);
8010131b:	83 ec 0c             	sub    $0xc,%esp
8010131e:	ff 76 10             	pushl  0x10(%esi)
80101321:	e8 fa 05 00 00       	call   80101920 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101326:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101329:	53                   	push   %ebx
8010132a:	ff 76 14             	pushl  0x14(%esi)
8010132d:	01 f8                	add    %edi,%eax
8010132f:	50                   	push   %eax
80101330:	ff 76 10             	pushl  0x10(%esi)
80101333:	e8 c8 09 00 00       	call   80101d00 <writei>
80101338:	83 c4 20             	add    $0x20,%esp
8010133b:	85 c0                	test   %eax,%eax
8010133d:	7f 99                	jg     801012d8 <filewrite+0x48>
      iunlock(f->ip);
8010133f:	83 ec 0c             	sub    $0xc,%esp
80101342:	ff 76 10             	pushl  0x10(%esi)
80101345:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101348:	e8 b3 06 00 00       	call   80101a00 <iunlock>
      end_op();
8010134d:	e8 5e 21 00 00       	call   801034b0 <end_op>
      if(r < 0)
80101352:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101355:	83 c4 10             	add    $0x10,%esp
80101358:	85 c0                	test   %eax,%eax
8010135a:	74 98                	je     801012f4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010135c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010135f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101364:	89 f8                	mov    %edi,%eax
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101370:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101373:	75 e7                	jne    8010135c <filewrite+0xcc>
}
80101375:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101378:	89 f8                	mov    %edi,%eax
8010137a:	5b                   	pop    %ebx
8010137b:	5e                   	pop    %esi
8010137c:	5f                   	pop    %edi
8010137d:	5d                   	pop    %ebp
8010137e:	c3                   	ret    
8010137f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101380:	8b 46 0c             	mov    0xc(%esi),%eax
80101383:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101386:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101389:	5b                   	pop    %ebx
8010138a:	5e                   	pop    %esi
8010138b:	5f                   	pop    %edi
8010138c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010138d:	e9 fe 28 00 00       	jmp    80103c90 <pipewrite>
        panic("short filewrite");
80101392:	83 ec 0c             	sub    $0xc,%esp
80101395:	68 24 84 10 80       	push   $0x80108424
8010139a:	e8 f1 ef ff ff       	call   80100390 <panic>
  panic("filewrite");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 2a 84 10 80       	push   $0x8010842a
801013a7:	e8 e4 ef ff ff       	call   80100390 <panic>
801013ac:	66 90                	xchg   %ax,%ax
801013ae:	66 90                	xchg   %ax,%ax

801013b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801013b7:	c1 ea 0c             	shr    $0xc,%edx
801013ba:	03 15 18 4a 11 80    	add    0x80114a18,%edx
801013c0:	83 ec 08             	sub    $0x8,%esp
801013c3:	52                   	push   %edx
801013c4:	50                   	push   %eax
801013c5:	e8 06 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013ca:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013cc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801013cf:	ba 01 00 00 00       	mov    $0x1,%edx
801013d4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013d7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801013dd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801013e0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801013e2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801013e7:	85 d1                	test   %edx,%ecx
801013e9:	74 25                	je     80101410 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013eb:	f7 d2                	not    %edx
801013ed:	89 c6                	mov    %eax,%esi
  log_write(bp);
801013ef:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801013f2:	21 ca                	and    %ecx,%edx
801013f4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801013f8:	56                   	push   %esi
801013f9:	e8 12 22 00 00       	call   80103610 <log_write>
  brelse(bp);
801013fe:	89 34 24             	mov    %esi,(%esp)
80101401:	e8 da ed ff ff       	call   801001e0 <brelse>
}
80101406:	83 c4 10             	add    $0x10,%esp
80101409:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010140c:	5b                   	pop    %ebx
8010140d:	5e                   	pop    %esi
8010140e:	5d                   	pop    %ebp
8010140f:	c3                   	ret    
    panic("freeing free block");
80101410:	83 ec 0c             	sub    $0xc,%esp
80101413:	68 34 84 10 80       	push   $0x80108434
80101418:	e8 73 ef ff ff       	call   80100390 <panic>
8010141d:	8d 76 00             	lea    0x0(%esi),%esi

80101420 <balloc>:
{
80101420:	55                   	push   %ebp
80101421:	89 e5                	mov    %esp,%ebp
80101423:	57                   	push   %edi
80101424:	56                   	push   %esi
80101425:	53                   	push   %ebx
80101426:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101429:	8b 0d 00 4a 11 80    	mov    0x80114a00,%ecx
{
8010142f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101432:	85 c9                	test   %ecx,%ecx
80101434:	0f 84 87 00 00 00    	je     801014c1 <balloc+0xa1>
8010143a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101441:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101444:	83 ec 08             	sub    $0x8,%esp
80101447:	89 f0                	mov    %esi,%eax
80101449:	c1 f8 0c             	sar    $0xc,%eax
8010144c:	03 05 18 4a 11 80    	add    0x80114a18,%eax
80101452:	50                   	push   %eax
80101453:	ff 75 d8             	pushl  -0x28(%ebp)
80101456:	e8 75 ec ff ff       	call   801000d0 <bread>
8010145b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010145e:	a1 00 4a 11 80       	mov    0x80114a00,%eax
80101463:	83 c4 10             	add    $0x10,%esp
80101466:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101469:	31 c0                	xor    %eax,%eax
8010146b:	eb 2f                	jmp    8010149c <balloc+0x7c>
8010146d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101470:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101472:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101475:	bb 01 00 00 00       	mov    $0x1,%ebx
8010147a:	83 e1 07             	and    $0x7,%ecx
8010147d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010147f:	89 c1                	mov    %eax,%ecx
80101481:	c1 f9 03             	sar    $0x3,%ecx
80101484:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101489:	85 df                	test   %ebx,%edi
8010148b:	89 fa                	mov    %edi,%edx
8010148d:	74 41                	je     801014d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010148f:	83 c0 01             	add    $0x1,%eax
80101492:	83 c6 01             	add    $0x1,%esi
80101495:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010149a:	74 05                	je     801014a1 <balloc+0x81>
8010149c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010149f:	77 cf                	ja     80101470 <balloc+0x50>
    brelse(bp);
801014a1:	83 ec 0c             	sub    $0xc,%esp
801014a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801014a7:	e8 34 ed ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801014ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801014b3:	83 c4 10             	add    $0x10,%esp
801014b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801014b9:	39 05 00 4a 11 80    	cmp    %eax,0x80114a00
801014bf:	77 80                	ja     80101441 <balloc+0x21>
  panic("balloc: out of blocks");
801014c1:	83 ec 0c             	sub    $0xc,%esp
801014c4:	68 47 84 10 80       	push   $0x80108447
801014c9:	e8 c2 ee ff ff       	call   80100390 <panic>
801014ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801014d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801014d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801014d6:	09 da                	or     %ebx,%edx
801014d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801014dc:	57                   	push   %edi
801014dd:	e8 2e 21 00 00       	call   80103610 <log_write>
        brelse(bp);
801014e2:	89 3c 24             	mov    %edi,(%esp)
801014e5:	e8 f6 ec ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801014ea:	58                   	pop    %eax
801014eb:	5a                   	pop    %edx
801014ec:	56                   	push   %esi
801014ed:	ff 75 d8             	pushl  -0x28(%ebp)
801014f0:	e8 db eb ff ff       	call   801000d0 <bread>
801014f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801014f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801014fa:	83 c4 0c             	add    $0xc,%esp
801014fd:	68 00 02 00 00       	push   $0x200
80101502:	6a 00                	push   $0x0
80101504:	50                   	push   %eax
80101505:	e8 76 3a 00 00       	call   80104f80 <memset>
  log_write(bp);
8010150a:	89 1c 24             	mov    %ebx,(%esp)
8010150d:	e8 fe 20 00 00       	call   80103610 <log_write>
  brelse(bp);
80101512:	89 1c 24             	mov    %ebx,(%esp)
80101515:	e8 c6 ec ff ff       	call   801001e0 <brelse>
}
8010151a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010151d:	89 f0                	mov    %esi,%eax
8010151f:	5b                   	pop    %ebx
80101520:	5e                   	pop    %esi
80101521:	5f                   	pop    %edi
80101522:	5d                   	pop    %ebp
80101523:	c3                   	ret    
80101524:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010152a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101530 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101538:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010153a:	bb 54 4a 11 80       	mov    $0x80114a54,%ebx
{
8010153f:	83 ec 28             	sub    $0x28,%esp
80101542:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101545:	68 20 4a 11 80       	push   $0x80114a20
8010154a:	e8 21 39 00 00       	call   80104e70 <acquire>
8010154f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101552:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101555:	eb 17                	jmp    8010156e <iget+0x3e>
80101557:	89 f6                	mov    %esi,%esi
80101559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101560:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101566:	81 fb 74 66 11 80    	cmp    $0x80116674,%ebx
8010156c:	73 22                	jae    80101590 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010156e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101571:	85 c9                	test   %ecx,%ecx
80101573:	7e 04                	jle    80101579 <iget+0x49>
80101575:	39 3b                	cmp    %edi,(%ebx)
80101577:	74 4f                	je     801015c8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101579:	85 f6                	test   %esi,%esi
8010157b:	75 e3                	jne    80101560 <iget+0x30>
8010157d:	85 c9                	test   %ecx,%ecx
8010157f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101582:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101588:	81 fb 74 66 11 80    	cmp    $0x80116674,%ebx
8010158e:	72 de                	jb     8010156e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101590:	85 f6                	test   %esi,%esi
80101592:	74 5b                	je     801015ef <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101594:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101597:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101599:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010159c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801015a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801015aa:	68 20 4a 11 80       	push   $0x80114a20
801015af:	e8 7c 39 00 00       	call   80104f30 <release>

  return ip;
801015b4:	83 c4 10             	add    $0x10,%esp
}
801015b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ba:	89 f0                	mov    %esi,%eax
801015bc:	5b                   	pop    %ebx
801015bd:	5e                   	pop    %esi
801015be:	5f                   	pop    %edi
801015bf:	5d                   	pop    %ebp
801015c0:	c3                   	ret    
801015c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801015c8:	39 53 04             	cmp    %edx,0x4(%ebx)
801015cb:	75 ac                	jne    80101579 <iget+0x49>
      release(&icache.lock);
801015cd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801015d0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801015d3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801015d5:	68 20 4a 11 80       	push   $0x80114a20
      ip->ref++;
801015da:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801015dd:	e8 4e 39 00 00       	call   80104f30 <release>
      return ip;
801015e2:	83 c4 10             	add    $0x10,%esp
}
801015e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015e8:	89 f0                	mov    %esi,%eax
801015ea:	5b                   	pop    %ebx
801015eb:	5e                   	pop    %esi
801015ec:	5f                   	pop    %edi
801015ed:	5d                   	pop    %ebp
801015ee:	c3                   	ret    
    panic("iget: no inodes");
801015ef:	83 ec 0c             	sub    $0xc,%esp
801015f2:	68 5d 84 10 80       	push   $0x8010845d
801015f7:	e8 94 ed ff ff       	call   80100390 <panic>
801015fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101600 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	57                   	push   %edi
80101604:	56                   	push   %esi
80101605:	53                   	push   %ebx
80101606:	89 c6                	mov    %eax,%esi
80101608:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010160b:	83 fa 0b             	cmp    $0xb,%edx
8010160e:	77 18                	ja     80101628 <bmap+0x28>
80101610:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101613:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101616:	85 db                	test   %ebx,%ebx
80101618:	74 76                	je     80101690 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010161a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161d:	89 d8                	mov    %ebx,%eax
8010161f:	5b                   	pop    %ebx
80101620:	5e                   	pop    %esi
80101621:	5f                   	pop    %edi
80101622:	5d                   	pop    %ebp
80101623:	c3                   	ret    
80101624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101628:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010162b:	83 fb 7f             	cmp    $0x7f,%ebx
8010162e:	0f 87 90 00 00 00    	ja     801016c4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101634:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010163a:	8b 00                	mov    (%eax),%eax
8010163c:	85 d2                	test   %edx,%edx
8010163e:	74 70                	je     801016b0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101640:	83 ec 08             	sub    $0x8,%esp
80101643:	52                   	push   %edx
80101644:	50                   	push   %eax
80101645:	e8 86 ea ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010164a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010164e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101651:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101653:	8b 1a                	mov    (%edx),%ebx
80101655:	85 db                	test   %ebx,%ebx
80101657:	75 1d                	jne    80101676 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101659:	8b 06                	mov    (%esi),%eax
8010165b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010165e:	e8 bd fd ff ff       	call   80101420 <balloc>
80101663:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101666:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101669:	89 c3                	mov    %eax,%ebx
8010166b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010166d:	57                   	push   %edi
8010166e:	e8 9d 1f 00 00       	call   80103610 <log_write>
80101673:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101676:	83 ec 0c             	sub    $0xc,%esp
80101679:	57                   	push   %edi
8010167a:	e8 61 eb ff ff       	call   801001e0 <brelse>
8010167f:	83 c4 10             	add    $0x10,%esp
}
80101682:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101685:	89 d8                	mov    %ebx,%eax
80101687:	5b                   	pop    %ebx
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
8010168b:	c3                   	ret    
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101690:	8b 00                	mov    (%eax),%eax
80101692:	e8 89 fd ff ff       	call   80101420 <balloc>
80101697:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010169a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010169d:	89 c3                	mov    %eax,%ebx
}
8010169f:	89 d8                	mov    %ebx,%eax
801016a1:	5b                   	pop    %ebx
801016a2:	5e                   	pop    %esi
801016a3:	5f                   	pop    %edi
801016a4:	5d                   	pop    %ebp
801016a5:	c3                   	ret    
801016a6:	8d 76 00             	lea    0x0(%esi),%esi
801016a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801016b0:	e8 6b fd ff ff       	call   80101420 <balloc>
801016b5:	89 c2                	mov    %eax,%edx
801016b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801016bd:	8b 06                	mov    (%esi),%eax
801016bf:	e9 7c ff ff ff       	jmp    80101640 <bmap+0x40>
  panic("bmap: out of range");
801016c4:	83 ec 0c             	sub    $0xc,%esp
801016c7:	68 6d 84 10 80       	push   $0x8010846d
801016cc:	e8 bf ec ff ff       	call   80100390 <panic>
801016d1:	eb 0d                	jmp    801016e0 <readsb>
801016d3:	90                   	nop
801016d4:	90                   	nop
801016d5:	90                   	nop
801016d6:	90                   	nop
801016d7:	90                   	nop
801016d8:	90                   	nop
801016d9:	90                   	nop
801016da:	90                   	nop
801016db:	90                   	nop
801016dc:	90                   	nop
801016dd:	90                   	nop
801016de:	90                   	nop
801016df:	90                   	nop

801016e0 <readsb>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801016e8:	83 ec 08             	sub    $0x8,%esp
801016eb:	6a 01                	push   $0x1
801016ed:	ff 75 08             	pushl  0x8(%ebp)
801016f0:	e8 db e9 ff ff       	call   801000d0 <bread>
801016f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801016fa:	83 c4 0c             	add    $0xc,%esp
801016fd:	6a 1c                	push   $0x1c
801016ff:	50                   	push   %eax
80101700:	56                   	push   %esi
80101701:	e8 2a 39 00 00       	call   80105030 <memmove>
  brelse(bp);
80101706:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101709:	83 c4 10             	add    $0x10,%esp
}
8010170c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010170f:	5b                   	pop    %ebx
80101710:	5e                   	pop    %esi
80101711:	5d                   	pop    %ebp
  brelse(bp);
80101712:	e9 c9 ea ff ff       	jmp    801001e0 <brelse>
80101717:	89 f6                	mov    %esi,%esi
80101719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101720 <iinit>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	53                   	push   %ebx
80101724:	bb 60 4a 11 80       	mov    $0x80114a60,%ebx
80101729:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010172c:	68 80 84 10 80       	push   $0x80108480
80101731:	68 20 4a 11 80       	push   $0x80114a20
80101736:	e8 f5 35 00 00       	call   80104d30 <initlock>
8010173b:	83 c4 10             	add    $0x10,%esp
8010173e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101740:	83 ec 08             	sub    $0x8,%esp
80101743:	68 87 84 10 80       	push   $0x80108487
80101748:	53                   	push   %ebx
80101749:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010174f:	e8 ac 34 00 00       	call   80104c00 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101754:	83 c4 10             	add    $0x10,%esp
80101757:	81 fb 80 66 11 80    	cmp    $0x80116680,%ebx
8010175d:	75 e1                	jne    80101740 <iinit+0x20>
  readsb(dev, &sb);
8010175f:	83 ec 08             	sub    $0x8,%esp
80101762:	68 00 4a 11 80       	push   $0x80114a00
80101767:	ff 75 08             	pushl  0x8(%ebp)
8010176a:	e8 71 ff ff ff       	call   801016e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010176f:	ff 35 18 4a 11 80    	pushl  0x80114a18
80101775:	ff 35 14 4a 11 80    	pushl  0x80114a14
8010177b:	ff 35 10 4a 11 80    	pushl  0x80114a10
80101781:	ff 35 0c 4a 11 80    	pushl  0x80114a0c
80101787:	ff 35 08 4a 11 80    	pushl  0x80114a08
8010178d:	ff 35 04 4a 11 80    	pushl  0x80114a04
80101793:	ff 35 00 4a 11 80    	pushl  0x80114a00
80101799:	68 34 85 10 80       	push   $0x80108534
8010179e:	e8 bd ee ff ff       	call   80100660 <cprintf>
}
801017a3:	83 c4 30             	add    $0x30,%esp
801017a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017a9:	c9                   	leave  
801017aa:	c3                   	ret    
801017ab:	90                   	nop
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017b0 <ialloc>:
{
801017b0:	55                   	push   %ebp
801017b1:	89 e5                	mov    %esp,%ebp
801017b3:	57                   	push   %edi
801017b4:	56                   	push   %esi
801017b5:	53                   	push   %ebx
801017b6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017b9:	83 3d 08 4a 11 80 01 	cmpl   $0x1,0x80114a08
{
801017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801017c3:	8b 75 08             	mov    0x8(%ebp),%esi
801017c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801017c9:	0f 86 91 00 00 00    	jbe    80101860 <ialloc+0xb0>
801017cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801017d4:	eb 21                	jmp    801017f7 <ialloc+0x47>
801017d6:	8d 76 00             	lea    0x0(%esi),%esi
801017d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801017e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801017e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801017e6:	57                   	push   %edi
801017e7:	e8 f4 e9 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801017ec:	83 c4 10             	add    $0x10,%esp
801017ef:	39 1d 08 4a 11 80    	cmp    %ebx,0x80114a08
801017f5:	76 69                	jbe    80101860 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801017f7:	89 d8                	mov    %ebx,%eax
801017f9:	83 ec 08             	sub    $0x8,%esp
801017fc:	c1 e8 03             	shr    $0x3,%eax
801017ff:	03 05 14 4a 11 80    	add    0x80114a14,%eax
80101805:	50                   	push   %eax
80101806:	56                   	push   %esi
80101807:	e8 c4 e8 ff ff       	call   801000d0 <bread>
8010180c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010180e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101810:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101813:	83 e0 07             	and    $0x7,%eax
80101816:	c1 e0 06             	shl    $0x6,%eax
80101819:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010181d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101821:	75 bd                	jne    801017e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101823:	83 ec 04             	sub    $0x4,%esp
80101826:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101829:	6a 40                	push   $0x40
8010182b:	6a 00                	push   $0x0
8010182d:	51                   	push   %ecx
8010182e:	e8 4d 37 00 00       	call   80104f80 <memset>
      dip->type = type;
80101833:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101837:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010183a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010183d:	89 3c 24             	mov    %edi,(%esp)
80101840:	e8 cb 1d 00 00       	call   80103610 <log_write>
      brelse(bp);
80101845:	89 3c 24             	mov    %edi,(%esp)
80101848:	e8 93 e9 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010184d:	83 c4 10             	add    $0x10,%esp
}
80101850:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101853:	89 da                	mov    %ebx,%edx
80101855:	89 f0                	mov    %esi,%eax
}
80101857:	5b                   	pop    %ebx
80101858:	5e                   	pop    %esi
80101859:	5f                   	pop    %edi
8010185a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010185b:	e9 d0 fc ff ff       	jmp    80101530 <iget>
  panic("ialloc: no inodes");
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	68 8d 84 10 80       	push   $0x8010848d
80101868:	e8 23 eb ff ff       	call   80100390 <panic>
8010186d:	8d 76 00             	lea    0x0(%esi),%esi

80101870 <iupdate>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	56                   	push   %esi
80101874:	53                   	push   %ebx
80101875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101878:	83 ec 08             	sub    $0x8,%esp
8010187b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010187e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101881:	c1 e8 03             	shr    $0x3,%eax
80101884:	03 05 14 4a 11 80    	add    0x80114a14,%eax
8010188a:	50                   	push   %eax
8010188b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010188e:	e8 3d e8 ff ff       	call   801000d0 <bread>
80101893:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101895:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101898:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010189c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010189f:	83 e0 07             	and    $0x7,%eax
801018a2:	c1 e0 06             	shl    $0x6,%eax
801018a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801018a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801018ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801018b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801018b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801018bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801018bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801018c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801018c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801018ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018cd:	6a 34                	push   $0x34
801018cf:	53                   	push   %ebx
801018d0:	50                   	push   %eax
801018d1:	e8 5a 37 00 00       	call   80105030 <memmove>
  log_write(bp);
801018d6:	89 34 24             	mov    %esi,(%esp)
801018d9:	e8 32 1d 00 00       	call   80103610 <log_write>
  brelse(bp);
801018de:	89 75 08             	mov    %esi,0x8(%ebp)
801018e1:	83 c4 10             	add    $0x10,%esp
}
801018e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e7:	5b                   	pop    %ebx
801018e8:	5e                   	pop    %esi
801018e9:	5d                   	pop    %ebp
  brelse(bp);
801018ea:	e9 f1 e8 ff ff       	jmp    801001e0 <brelse>
801018ef:	90                   	nop

801018f0 <idup>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	53                   	push   %ebx
801018f4:	83 ec 10             	sub    $0x10,%esp
801018f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801018fa:	68 20 4a 11 80       	push   $0x80114a20
801018ff:	e8 6c 35 00 00       	call   80104e70 <acquire>
  ip->ref++;
80101904:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101908:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
8010190f:	e8 1c 36 00 00       	call   80104f30 <release>
}
80101914:	89 d8                	mov    %ebx,%eax
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <ilock>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	56                   	push   %esi
80101924:	53                   	push   %ebx
80101925:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101928:	85 db                	test   %ebx,%ebx
8010192a:	0f 84 b7 00 00 00    	je     801019e7 <ilock+0xc7>
80101930:	8b 53 08             	mov    0x8(%ebx),%edx
80101933:	85 d2                	test   %edx,%edx
80101935:	0f 8e ac 00 00 00    	jle    801019e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010193b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010193e:	83 ec 0c             	sub    $0xc,%esp
80101941:	50                   	push   %eax
80101942:	e8 f9 32 00 00       	call   80104c40 <acquiresleep>
  if(ip->valid == 0){
80101947:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010194a:	83 c4 10             	add    $0x10,%esp
8010194d:	85 c0                	test   %eax,%eax
8010194f:	74 0f                	je     80101960 <ilock+0x40>
}
80101951:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101954:	5b                   	pop    %ebx
80101955:	5e                   	pop    %esi
80101956:	5d                   	pop    %ebp
80101957:	c3                   	ret    
80101958:	90                   	nop
80101959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101960:	8b 43 04             	mov    0x4(%ebx),%eax
80101963:	83 ec 08             	sub    $0x8,%esp
80101966:	c1 e8 03             	shr    $0x3,%eax
80101969:	03 05 14 4a 11 80    	add    0x80114a14,%eax
8010196f:	50                   	push   %eax
80101970:	ff 33                	pushl  (%ebx)
80101972:	e8 59 e7 ff ff       	call   801000d0 <bread>
80101977:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101979:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010197c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010197f:	83 e0 07             	and    $0x7,%eax
80101982:	c1 e0 06             	shl    $0x6,%eax
80101985:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101989:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010198c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010198f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101993:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101997:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010199b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010199f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801019a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801019a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801019ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801019ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801019b1:	6a 34                	push   $0x34
801019b3:	50                   	push   %eax
801019b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801019b7:	50                   	push   %eax
801019b8:	e8 73 36 00 00       	call   80105030 <memmove>
    brelse(bp);
801019bd:	89 34 24             	mov    %esi,(%esp)
801019c0:	e8 1b e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801019c5:	83 c4 10             	add    $0x10,%esp
801019c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801019cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801019d4:	0f 85 77 ff ff ff    	jne    80101951 <ilock+0x31>
      panic("ilock: no type");
801019da:	83 ec 0c             	sub    $0xc,%esp
801019dd:	68 a5 84 10 80       	push   $0x801084a5
801019e2:	e8 a9 e9 ff ff       	call   80100390 <panic>
    panic("ilock");
801019e7:	83 ec 0c             	sub    $0xc,%esp
801019ea:	68 9f 84 10 80       	push   $0x8010849f
801019ef:	e8 9c e9 ff ff       	call   80100390 <panic>
801019f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101a00 <iunlock>:
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	56                   	push   %esi
80101a04:	53                   	push   %ebx
80101a05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a08:	85 db                	test   %ebx,%ebx
80101a0a:	74 28                	je     80101a34 <iunlock+0x34>
80101a0c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101a0f:	83 ec 0c             	sub    $0xc,%esp
80101a12:	56                   	push   %esi
80101a13:	e8 c8 32 00 00       	call   80104ce0 <holdingsleep>
80101a18:	83 c4 10             	add    $0x10,%esp
80101a1b:	85 c0                	test   %eax,%eax
80101a1d:	74 15                	je     80101a34 <iunlock+0x34>
80101a1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101a22:	85 c0                	test   %eax,%eax
80101a24:	7e 0e                	jle    80101a34 <iunlock+0x34>
  releasesleep(&ip->lock);
80101a26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101a29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a2c:	5b                   	pop    %ebx
80101a2d:	5e                   	pop    %esi
80101a2e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101a2f:	e9 6c 32 00 00       	jmp    80104ca0 <releasesleep>
    panic("iunlock");
80101a34:	83 ec 0c             	sub    $0xc,%esp
80101a37:	68 b4 84 10 80       	push   $0x801084b4
80101a3c:	e8 4f e9 ff ff       	call   80100390 <panic>
80101a41:	eb 0d                	jmp    80101a50 <iput>
80101a43:	90                   	nop
80101a44:	90                   	nop
80101a45:	90                   	nop
80101a46:	90                   	nop
80101a47:	90                   	nop
80101a48:	90                   	nop
80101a49:	90                   	nop
80101a4a:	90                   	nop
80101a4b:	90                   	nop
80101a4c:	90                   	nop
80101a4d:	90                   	nop
80101a4e:	90                   	nop
80101a4f:	90                   	nop

80101a50 <iput>:
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 28             	sub    $0x28,%esp
80101a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101a5c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101a5f:	57                   	push   %edi
80101a60:	e8 db 31 00 00       	call   80104c40 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a65:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101a68:	83 c4 10             	add    $0x10,%esp
80101a6b:	85 d2                	test   %edx,%edx
80101a6d:	74 07                	je     80101a76 <iput+0x26>
80101a6f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101a74:	74 32                	je     80101aa8 <iput+0x58>
  releasesleep(&ip->lock);
80101a76:	83 ec 0c             	sub    $0xc,%esp
80101a79:	57                   	push   %edi
80101a7a:	e8 21 32 00 00       	call   80104ca0 <releasesleep>
  acquire(&icache.lock);
80101a7f:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
80101a86:	e8 e5 33 00 00       	call   80104e70 <acquire>
  ip->ref--;
80101a8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a8f:	83 c4 10             	add    $0x10,%esp
80101a92:	c7 45 08 20 4a 11 80 	movl   $0x80114a20,0x8(%ebp)
}
80101a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a9c:	5b                   	pop    %ebx
80101a9d:	5e                   	pop    %esi
80101a9e:	5f                   	pop    %edi
80101a9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101aa0:	e9 8b 34 00 00       	jmp    80104f30 <release>
80101aa5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101aa8:	83 ec 0c             	sub    $0xc,%esp
80101aab:	68 20 4a 11 80       	push   $0x80114a20
80101ab0:	e8 bb 33 00 00       	call   80104e70 <acquire>
    int r = ip->ref;
80101ab5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101ab8:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
80101abf:	e8 6c 34 00 00       	call   80104f30 <release>
    if(r == 1){
80101ac4:	83 c4 10             	add    $0x10,%esp
80101ac7:	83 fe 01             	cmp    $0x1,%esi
80101aca:	75 aa                	jne    80101a76 <iput+0x26>
80101acc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101ad2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101ad5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101ad8:	89 cf                	mov    %ecx,%edi
80101ada:	eb 0b                	jmp    80101ae7 <iput+0x97>
80101adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ae0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101ae3:	39 fe                	cmp    %edi,%esi
80101ae5:	74 19                	je     80101b00 <iput+0xb0>
    if(ip->addrs[i]){
80101ae7:	8b 16                	mov    (%esi),%edx
80101ae9:	85 d2                	test   %edx,%edx
80101aeb:	74 f3                	je     80101ae0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101aed:	8b 03                	mov    (%ebx),%eax
80101aef:	e8 bc f8 ff ff       	call   801013b0 <bfree>
      ip->addrs[i] = 0;
80101af4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101afa:	eb e4                	jmp    80101ae0 <iput+0x90>
80101afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101b00:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101b06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b09:	85 c0                	test   %eax,%eax
80101b0b:	75 33                	jne    80101b40 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101b0d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101b10:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101b17:	53                   	push   %ebx
80101b18:	e8 53 fd ff ff       	call   80101870 <iupdate>
      ip->type = 0;
80101b1d:	31 c0                	xor    %eax,%eax
80101b1f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101b23:	89 1c 24             	mov    %ebx,(%esp)
80101b26:	e8 45 fd ff ff       	call   80101870 <iupdate>
      ip->valid = 0;
80101b2b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101b32:	83 c4 10             	add    $0x10,%esp
80101b35:	e9 3c ff ff ff       	jmp    80101a76 <iput+0x26>
80101b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101b40:	83 ec 08             	sub    $0x8,%esp
80101b43:	50                   	push   %eax
80101b44:	ff 33                	pushl  (%ebx)
80101b46:	e8 85 e5 ff ff       	call   801000d0 <bread>
80101b4b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101b51:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101b57:	8d 70 5c             	lea    0x5c(%eax),%esi
80101b5a:	83 c4 10             	add    $0x10,%esp
80101b5d:	89 cf                	mov    %ecx,%edi
80101b5f:	eb 0e                	jmp    80101b6f <iput+0x11f>
80101b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b68:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101b6b:	39 fe                	cmp    %edi,%esi
80101b6d:	74 0f                	je     80101b7e <iput+0x12e>
      if(a[j])
80101b6f:	8b 16                	mov    (%esi),%edx
80101b71:	85 d2                	test   %edx,%edx
80101b73:	74 f3                	je     80101b68 <iput+0x118>
        bfree(ip->dev, a[j]);
80101b75:	8b 03                	mov    (%ebx),%eax
80101b77:	e8 34 f8 ff ff       	call   801013b0 <bfree>
80101b7c:	eb ea                	jmp    80101b68 <iput+0x118>
    brelse(bp);
80101b7e:	83 ec 0c             	sub    $0xc,%esp
80101b81:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b84:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b87:	e8 54 e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101b8c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101b92:	8b 03                	mov    (%ebx),%eax
80101b94:	e8 17 f8 ff ff       	call   801013b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b99:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ba0:	00 00 00 
80101ba3:	83 c4 10             	add    $0x10,%esp
80101ba6:	e9 62 ff ff ff       	jmp    80101b0d <iput+0xbd>
80101bab:	90                   	nop
80101bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101bb0 <iunlockput>:
{
80101bb0:	55                   	push   %ebp
80101bb1:	89 e5                	mov    %esp,%ebp
80101bb3:	53                   	push   %ebx
80101bb4:	83 ec 10             	sub    $0x10,%esp
80101bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101bba:	53                   	push   %ebx
80101bbb:	e8 40 fe ff ff       	call   80101a00 <iunlock>
  iput(ip);
80101bc0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101bc3:	83 c4 10             	add    $0x10,%esp
}
80101bc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101bc9:	c9                   	leave  
  iput(ip);
80101bca:	e9 81 fe ff ff       	jmp    80101a50 <iput>
80101bcf:	90                   	nop

80101bd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	8b 55 08             	mov    0x8(%ebp),%edx
80101bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101bd9:	8b 0a                	mov    (%edx),%ecx
80101bdb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101bde:	8b 4a 04             	mov    0x4(%edx),%ecx
80101be1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101be4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101be8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101beb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101bef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101bf3:	8b 52 58             	mov    0x58(%edx),%edx
80101bf6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101bf9:	5d                   	pop    %ebp
80101bfa:	c3                   	ret    
80101bfb:	90                   	nop
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	57                   	push   %edi
80101c04:	56                   	push   %esi
80101c05:	53                   	push   %ebx
80101c06:	83 ec 1c             	sub    $0x1c,%esp
80101c09:	8b 45 08             	mov    0x8(%ebp),%eax
80101c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c17:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c23:	0f 84 a7 00 00 00    	je     80101cd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	8b 40 58             	mov    0x58(%eax),%eax
80101c2f:	39 c6                	cmp    %eax,%esi
80101c31:	0f 87 ba 00 00 00    	ja     80101cf1 <readi+0xf1>
80101c37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c3a:	89 f9                	mov    %edi,%ecx
80101c3c:	01 f1                	add    %esi,%ecx
80101c3e:	0f 82 ad 00 00 00    	jb     80101cf1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c44:	89 c2                	mov    %eax,%edx
80101c46:	29 f2                	sub    %esi,%edx
80101c48:	39 c8                	cmp    %ecx,%eax
80101c4a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c4d:	31 ff                	xor    %edi,%edi
80101c4f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101c51:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c54:	74 6c                	je     80101cc2 <readi+0xc2>
80101c56:	8d 76 00             	lea    0x0(%esi),%esi
80101c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c63:	89 f2                	mov    %esi,%edx
80101c65:	c1 ea 09             	shr    $0x9,%edx
80101c68:	89 d8                	mov    %ebx,%eax
80101c6a:	e8 91 f9 ff ff       	call   80101600 <bmap>
80101c6f:	83 ec 08             	sub    $0x8,%esp
80101c72:	50                   	push   %eax
80101c73:	ff 33                	pushl  (%ebx)
80101c75:	e8 56 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c7d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c7f:	89 f0                	mov    %esi,%eax
80101c81:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c86:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c8b:	83 c4 0c             	add    $0xc,%esp
80101c8e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c90:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101c94:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c97:	29 fb                	sub    %edi,%ebx
80101c99:	39 d9                	cmp    %ebx,%ecx
80101c9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c9e:	53                   	push   %ebx
80101c9f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ca0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ca2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ca5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ca7:	e8 84 33 00 00       	call   80105030 <memmove>
    brelse(bp);
80101cac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101caf:	89 14 24             	mov    %edx,(%esp)
80101cb2:	e8 29 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cb7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101cba:	83 c4 10             	add    $0x10,%esp
80101cbd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101cc0:	77 9e                	ja     80101c60 <readi+0x60>
  }
  return n;
80101cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101cc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cc8:	5b                   	pop    %ebx
80101cc9:	5e                   	pop    %esi
80101cca:	5f                   	pop    %edi
80101ccb:	5d                   	pop    %ebp
80101ccc:	c3                   	ret    
80101ccd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101cd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cd4:	66 83 f8 09          	cmp    $0x9,%ax
80101cd8:	77 17                	ja     80101cf1 <readi+0xf1>
80101cda:	8b 04 c5 a0 49 11 80 	mov    -0x7feeb660(,%eax,8),%eax
80101ce1:	85 c0                	test   %eax,%eax
80101ce3:	74 0c                	je     80101cf1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ce5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101cef:	ff e0                	jmp    *%eax
      return -1;
80101cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cf6:	eb cd                	jmp    80101cc5 <readi+0xc5>
80101cf8:	90                   	nop
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	57                   	push   %edi
80101d04:	56                   	push   %esi
80101d05:	53                   	push   %ebx
80101d06:	83 ec 1c             	sub    $0x1c,%esp
80101d09:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d23:	0f 84 b7 00 00 00    	je     80101de0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101d29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d2f:	0f 82 eb 00 00 00    	jb     80101e20 <writei+0x120>
80101d35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d38:	31 d2                	xor    %edx,%edx
80101d3a:	89 f8                	mov    %edi,%eax
80101d3c:	01 f0                	add    %esi,%eax
80101d3e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101d41:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101d46:	0f 87 d4 00 00 00    	ja     80101e20 <writei+0x120>
80101d4c:	85 d2                	test   %edx,%edx
80101d4e:	0f 85 cc 00 00 00    	jne    80101e20 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d54:	85 ff                	test   %edi,%edi
80101d56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101d5d:	74 72                	je     80101dd1 <writei+0xd1>
80101d5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d63:	89 f2                	mov    %esi,%edx
80101d65:	c1 ea 09             	shr    $0x9,%edx
80101d68:	89 f8                	mov    %edi,%eax
80101d6a:	e8 91 f8 ff ff       	call   80101600 <bmap>
80101d6f:	83 ec 08             	sub    $0x8,%esp
80101d72:	50                   	push   %eax
80101d73:	ff 37                	pushl  (%edi)
80101d75:	e8 56 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d7a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d7d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d80:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d82:	89 f0                	mov    %esi,%eax
80101d84:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d89:	83 c4 0c             	add    $0xc,%esp
80101d8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d97:	39 d9                	cmp    %ebx,%ecx
80101d99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d9c:	53                   	push   %ebx
80101d9d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101da0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101da2:	50                   	push   %eax
80101da3:	e8 88 32 00 00       	call   80105030 <memmove>
    log_write(bp);
80101da8:	89 3c 24             	mov    %edi,(%esp)
80101dab:	e8 60 18 00 00       	call   80103610 <log_write>
    brelse(bp);
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	e8 28 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101db8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101dbb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101dbe:	83 c4 10             	add    $0x10,%esp
80101dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101dc4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101dc7:	77 97                	ja     80101d60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101dc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101dcc:	3b 70 58             	cmp    0x58(%eax),%esi
80101dcf:	77 37                	ja     80101e08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd7:	5b                   	pop    %ebx
80101dd8:	5e                   	pop    %esi
80101dd9:	5f                   	pop    %edi
80101dda:	5d                   	pop    %ebp
80101ddb:	c3                   	ret    
80101ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101de0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101de4:	66 83 f8 09          	cmp    $0x9,%ax
80101de8:	77 36                	ja     80101e20 <writei+0x120>
80101dea:	8b 04 c5 a4 49 11 80 	mov    -0x7feeb65c(,%eax,8),%eax
80101df1:	85 c0                	test   %eax,%eax
80101df3:	74 2b                	je     80101e20 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101df5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101df8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101dff:	ff e0                	jmp    *%eax
80101e01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e11:	50                   	push   %eax
80101e12:	e8 59 fa ff ff       	call   80101870 <iupdate>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	eb b5                	jmp    80101dd1 <writei+0xd1>
80101e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e25:	eb ad                	jmp    80101dd4 <writei+0xd4>
80101e27:	89 f6                	mov    %esi,%esi
80101e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e36:	6a 0e                	push   $0xe
80101e38:	ff 75 0c             	pushl  0xc(%ebp)
80101e3b:	ff 75 08             	pushl  0x8(%ebp)
80101e3e:	e8 5d 32 00 00       	call   801050a0 <strncmp>
}
80101e43:	c9                   	leave  
80101e44:	c3                   	ret    
80101e45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 1c             	sub    $0x1c,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101e5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e61:	0f 85 85 00 00 00    	jne    80101eec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e67:	8b 53 58             	mov    0x58(%ebx),%edx
80101e6a:	31 ff                	xor    %edi,%edi
80101e6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e6f:	85 d2                	test   %edx,%edx
80101e71:	74 3e                	je     80101eb1 <dirlookup+0x61>
80101e73:	90                   	nop
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e78:	6a 10                	push   $0x10
80101e7a:	57                   	push   %edi
80101e7b:	56                   	push   %esi
80101e7c:	53                   	push   %ebx
80101e7d:	e8 7e fd ff ff       	call   80101c00 <readi>
80101e82:	83 c4 10             	add    $0x10,%esp
80101e85:	83 f8 10             	cmp    $0x10,%eax
80101e88:	75 55                	jne    80101edf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e8f:	74 18                	je     80101ea9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e94:	83 ec 04             	sub    $0x4,%esp
80101e97:	6a 0e                	push   $0xe
80101e99:	50                   	push   %eax
80101e9a:	ff 75 0c             	pushl  0xc(%ebp)
80101e9d:	e8 fe 31 00 00       	call   801050a0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ea2:	83 c4 10             	add    $0x10,%esp
80101ea5:	85 c0                	test   %eax,%eax
80101ea7:	74 17                	je     80101ec0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ea9:	83 c7 10             	add    $0x10,%edi
80101eac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101eaf:	72 c7                	jb     80101e78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101eb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101eb4:	31 c0                	xor    %eax,%eax
}
80101eb6:	5b                   	pop    %ebx
80101eb7:	5e                   	pop    %esi
80101eb8:	5f                   	pop    %edi
80101eb9:	5d                   	pop    %ebp
80101eba:	c3                   	ret    
80101ebb:	90                   	nop
80101ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ec0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	74 05                	je     80101ecc <dirlookup+0x7c>
        *poff = off;
80101ec7:	8b 45 10             	mov    0x10(%ebp),%eax
80101eca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ecc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ed0:	8b 03                	mov    (%ebx),%eax
80101ed2:	e8 59 f6 ff ff       	call   80101530 <iget>
}
80101ed7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eda:	5b                   	pop    %ebx
80101edb:	5e                   	pop    %esi
80101edc:	5f                   	pop    %edi
80101edd:	5d                   	pop    %ebp
80101ede:	c3                   	ret    
      panic("dirlookup read");
80101edf:	83 ec 0c             	sub    $0xc,%esp
80101ee2:	68 ce 84 10 80       	push   $0x801084ce
80101ee7:	e8 a4 e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101eec:	83 ec 0c             	sub    $0xc,%esp
80101eef:	68 bc 84 10 80       	push   $0x801084bc
80101ef4:	e8 97 e4 ff ff       	call   80100390 <panic>
80101ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f00 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f00:	55                   	push   %ebp
80101f01:	89 e5                	mov    %esp,%ebp
80101f03:	57                   	push   %edi
80101f04:	56                   	push   %esi
80101f05:	53                   	push   %ebx
80101f06:	89 cf                	mov    %ecx,%edi
80101f08:	89 c3                	mov    %eax,%ebx
80101f0a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f0d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f10:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f13:	0f 84 67 01 00 00    	je     80102080 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f19:	e8 42 22 00 00       	call   80104160 <myproc>
  acquire(&icache.lock);
80101f1e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f21:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f24:	68 20 4a 11 80       	push   $0x80114a20
80101f29:	e8 42 2f 00 00       	call   80104e70 <acquire>
  ip->ref++;
80101f2e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f32:	c7 04 24 20 4a 11 80 	movl   $0x80114a20,(%esp)
80101f39:	e8 f2 2f 00 00       	call   80104f30 <release>
80101f3e:	83 c4 10             	add    $0x10,%esp
80101f41:	eb 08                	jmp    80101f4b <namex+0x4b>
80101f43:	90                   	nop
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	0f b6 03             	movzbl (%ebx),%eax
80101f4e:	3c 2f                	cmp    $0x2f,%al
80101f50:	74 f6                	je     80101f48 <namex+0x48>
  if(*path == 0)
80101f52:	84 c0                	test   %al,%al
80101f54:	0f 84 ee 00 00 00    	je     80102048 <namex+0x148>
  while(*path != '/' && *path != 0)
80101f5a:	0f b6 03             	movzbl (%ebx),%eax
80101f5d:	3c 2f                	cmp    $0x2f,%al
80101f5f:	0f 84 b3 00 00 00    	je     80102018 <namex+0x118>
80101f65:	84 c0                	test   %al,%al
80101f67:	89 da                	mov    %ebx,%edx
80101f69:	75 09                	jne    80101f74 <namex+0x74>
80101f6b:	e9 a8 00 00 00       	jmp    80102018 <namex+0x118>
80101f70:	84 c0                	test   %al,%al
80101f72:	74 0a                	je     80101f7e <namex+0x7e>
    path++;
80101f74:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101f77:	0f b6 02             	movzbl (%edx),%eax
80101f7a:	3c 2f                	cmp    $0x2f,%al
80101f7c:	75 f2                	jne    80101f70 <namex+0x70>
80101f7e:	89 d1                	mov    %edx,%ecx
80101f80:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101f82:	83 f9 0d             	cmp    $0xd,%ecx
80101f85:	0f 8e 91 00 00 00    	jle    8010201c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101f8b:	83 ec 04             	sub    $0x4,%esp
80101f8e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101f91:	6a 0e                	push   $0xe
80101f93:	53                   	push   %ebx
80101f94:	57                   	push   %edi
80101f95:	e8 96 30 00 00       	call   80105030 <memmove>
    path++;
80101f9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101f9d:	83 c4 10             	add    $0x10,%esp
    path++;
80101fa0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101fa2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101fa5:	75 11                	jne    80101fb8 <namex+0xb8>
80101fa7:	89 f6                	mov    %esi,%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101fb0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101fb3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101fb6:	74 f8                	je     80101fb0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101fb8:	83 ec 0c             	sub    $0xc,%esp
80101fbb:	56                   	push   %esi
80101fbc:	e8 5f f9 ff ff       	call   80101920 <ilock>
    if(ip->type != T_DIR){
80101fc1:	83 c4 10             	add    $0x10,%esp
80101fc4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101fc9:	0f 85 91 00 00 00    	jne    80102060 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101fcf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fd2:	85 d2                	test   %edx,%edx
80101fd4:	74 09                	je     80101fdf <namex+0xdf>
80101fd6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101fd9:	0f 84 b7 00 00 00    	je     80102096 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101fdf:	83 ec 04             	sub    $0x4,%esp
80101fe2:	6a 00                	push   $0x0
80101fe4:	57                   	push   %edi
80101fe5:	56                   	push   %esi
80101fe6:	e8 65 fe ff ff       	call   80101e50 <dirlookup>
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	85 c0                	test   %eax,%eax
80101ff0:	74 6e                	je     80102060 <namex+0x160>
  iunlock(ip);
80101ff2:	83 ec 0c             	sub    $0xc,%esp
80101ff5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101ff8:	56                   	push   %esi
80101ff9:	e8 02 fa ff ff       	call   80101a00 <iunlock>
  iput(ip);
80101ffe:	89 34 24             	mov    %esi,(%esp)
80102001:	e8 4a fa ff ff       	call   80101a50 <iput>
80102006:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102009:	83 c4 10             	add    $0x10,%esp
8010200c:	89 c6                	mov    %eax,%esi
8010200e:	e9 38 ff ff ff       	jmp    80101f4b <namex+0x4b>
80102013:	90                   	nop
80102014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102018:	89 da                	mov    %ebx,%edx
8010201a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010201c:	83 ec 04             	sub    $0x4,%esp
8010201f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102022:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102025:	51                   	push   %ecx
80102026:	53                   	push   %ebx
80102027:	57                   	push   %edi
80102028:	e8 03 30 00 00       	call   80105030 <memmove>
    name[len] = 0;
8010202d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102030:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102033:	83 c4 10             	add    $0x10,%esp
80102036:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010203a:	89 d3                	mov    %edx,%ebx
8010203c:	e9 61 ff ff ff       	jmp    80101fa2 <namex+0xa2>
80102041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102048:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010204b:	85 c0                	test   %eax,%eax
8010204d:	75 5d                	jne    801020ac <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010204f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102052:	89 f0                	mov    %esi,%eax
80102054:	5b                   	pop    %ebx
80102055:	5e                   	pop    %esi
80102056:	5f                   	pop    %edi
80102057:	5d                   	pop    %ebp
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102060:	83 ec 0c             	sub    $0xc,%esp
80102063:	56                   	push   %esi
80102064:	e8 97 f9 ff ff       	call   80101a00 <iunlock>
  iput(ip);
80102069:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010206c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010206e:	e8 dd f9 ff ff       	call   80101a50 <iput>
      return 0;
80102073:	83 c4 10             	add    $0x10,%esp
}
80102076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102079:	89 f0                	mov    %esi,%eax
8010207b:	5b                   	pop    %ebx
8010207c:	5e                   	pop    %esi
8010207d:	5f                   	pop    %edi
8010207e:	5d                   	pop    %ebp
8010207f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102080:	ba 01 00 00 00       	mov    $0x1,%edx
80102085:	b8 01 00 00 00       	mov    $0x1,%eax
8010208a:	e8 a1 f4 ff ff       	call   80101530 <iget>
8010208f:	89 c6                	mov    %eax,%esi
80102091:	e9 b5 fe ff ff       	jmp    80101f4b <namex+0x4b>
      iunlock(ip);
80102096:	83 ec 0c             	sub    $0xc,%esp
80102099:	56                   	push   %esi
8010209a:	e8 61 f9 ff ff       	call   80101a00 <iunlock>
      return ip;
8010209f:	83 c4 10             	add    $0x10,%esp
}
801020a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a5:	89 f0                	mov    %esi,%eax
801020a7:	5b                   	pop    %ebx
801020a8:	5e                   	pop    %esi
801020a9:	5f                   	pop    %edi
801020aa:	5d                   	pop    %ebp
801020ab:	c3                   	ret    
    iput(ip);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	56                   	push   %esi
    return 0;
801020b0:	31 f6                	xor    %esi,%esi
    iput(ip);
801020b2:	e8 99 f9 ff ff       	call   80101a50 <iput>
    return 0;
801020b7:	83 c4 10             	add    $0x10,%esp
801020ba:	eb 93                	jmp    8010204f <namex+0x14f>
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <dirlink>:
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 20             	sub    $0x20,%esp
801020c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020cc:	6a 00                	push   $0x0
801020ce:	ff 75 0c             	pushl  0xc(%ebp)
801020d1:	53                   	push   %ebx
801020d2:	e8 79 fd ff ff       	call   80101e50 <dirlookup>
801020d7:	83 c4 10             	add    $0x10,%esp
801020da:	85 c0                	test   %eax,%eax
801020dc:	75 67                	jne    80102145 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020de:	8b 7b 58             	mov    0x58(%ebx),%edi
801020e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020e4:	85 ff                	test   %edi,%edi
801020e6:	74 29                	je     80102111 <dirlink+0x51>
801020e8:	31 ff                	xor    %edi,%edi
801020ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020ed:	eb 09                	jmp    801020f8 <dirlink+0x38>
801020ef:	90                   	nop
801020f0:	83 c7 10             	add    $0x10,%edi
801020f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020f6:	73 19                	jae    80102111 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f8:	6a 10                	push   $0x10
801020fa:	57                   	push   %edi
801020fb:	56                   	push   %esi
801020fc:	53                   	push   %ebx
801020fd:	e8 fe fa ff ff       	call   80101c00 <readi>
80102102:	83 c4 10             	add    $0x10,%esp
80102105:	83 f8 10             	cmp    $0x10,%eax
80102108:	75 4e                	jne    80102158 <dirlink+0x98>
    if(de.inum == 0)
8010210a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010210f:	75 df                	jne    801020f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102111:	8d 45 da             	lea    -0x26(%ebp),%eax
80102114:	83 ec 04             	sub    $0x4,%esp
80102117:	6a 0e                	push   $0xe
80102119:	ff 75 0c             	pushl  0xc(%ebp)
8010211c:	50                   	push   %eax
8010211d:	e8 de 2f 00 00       	call   80105100 <strncpy>
  de.inum = inum;
80102122:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102125:	6a 10                	push   $0x10
80102127:	57                   	push   %edi
80102128:	56                   	push   %esi
80102129:	53                   	push   %ebx
  de.inum = inum;
8010212a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010212e:	e8 cd fb ff ff       	call   80101d00 <writei>
80102133:	83 c4 20             	add    $0x20,%esp
80102136:	83 f8 10             	cmp    $0x10,%eax
80102139:	75 2a                	jne    80102165 <dirlink+0xa5>
  return 0;
8010213b:	31 c0                	xor    %eax,%eax
}
8010213d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102140:	5b                   	pop    %ebx
80102141:	5e                   	pop    %esi
80102142:	5f                   	pop    %edi
80102143:	5d                   	pop    %ebp
80102144:	c3                   	ret    
    iput(ip);
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	50                   	push   %eax
80102149:	e8 02 f9 ff ff       	call   80101a50 <iput>
    return -1;
8010214e:	83 c4 10             	add    $0x10,%esp
80102151:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102156:	eb e5                	jmp    8010213d <dirlink+0x7d>
      panic("dirlink read");
80102158:	83 ec 0c             	sub    $0xc,%esp
8010215b:	68 dd 84 10 80       	push   $0x801084dd
80102160:	e8 2b e2 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	68 d5 8b 10 80       	push   $0x80108bd5
8010216d:	e8 1e e2 ff ff       	call   80100390 <panic>
80102172:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102180 <namei>:

struct inode*
namei(char *path)
{
80102180:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102181:	31 d2                	xor    %edx,%edx
{
80102183:	89 e5                	mov    %esp,%ebp
80102185:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102188:	8b 45 08             	mov    0x8(%ebp),%eax
8010218b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010218e:	e8 6d fd ff ff       	call   80101f00 <namex>
}
80102193:	c9                   	leave  
80102194:	c3                   	ret    
80102195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021a0:	55                   	push   %ebp
  return namex(path, 1, name);
801021a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021af:	e9 4c fd ff ff       	jmp    80101f00 <namex>
801021b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801021c0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801021c0:	55                   	push   %ebp
    char const digit[] = "0123456789";
801021c1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801021c6:	89 e5                	mov    %esp,%ebp
801021c8:	57                   	push   %edi
801021c9:	56                   	push   %esi
801021ca:	53                   	push   %ebx
801021cb:	83 ec 10             	sub    $0x10,%esp
801021ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801021d1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801021d8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801021df:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
801021e3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
801021e7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
801021ea:	85 c9                	test   %ecx,%ecx
801021ec:	79 0a                	jns    801021f8 <itoa+0x38>
801021ee:	89 f0                	mov    %esi,%eax
801021f0:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
801021f3:	f7 d9                	neg    %ecx
        *p++ = '-';
801021f5:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
801021f8:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801021fa:	bf 67 66 66 66       	mov    $0x66666667,%edi
801021ff:	90                   	nop
80102200:	89 d8                	mov    %ebx,%eax
80102202:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102205:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102208:	f7 ef                	imul   %edi
8010220a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010220d:	29 da                	sub    %ebx,%edx
8010220f:	89 d3                	mov    %edx,%ebx
80102211:	75 ed                	jne    80102200 <itoa+0x40>
    *p = '\0';
80102213:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102216:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010221b:	90                   	nop
8010221c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102220:	89 c8                	mov    %ecx,%eax
80102222:	83 ee 01             	sub    $0x1,%esi
80102225:	f7 eb                	imul   %ebx
80102227:	89 c8                	mov    %ecx,%eax
80102229:	c1 f8 1f             	sar    $0x1f,%eax
8010222c:	c1 fa 02             	sar    $0x2,%edx
8010222f:	29 c2                	sub    %eax,%edx
80102231:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102234:	01 c0                	add    %eax,%eax
80102236:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102238:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010223a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010223f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102241:	88 06                	mov    %al,(%esi)
    }while(i);
80102243:	75 db                	jne    80102220 <itoa+0x60>
    return b;
}
80102245:	8b 45 0c             	mov    0xc(%ebp),%eax
80102248:	83 c4 10             	add    $0x10,%esp
8010224b:	5b                   	pop    %ebx
8010224c:	5e                   	pop    %esi
8010224d:	5f                   	pop    %edi
8010224e:	5d                   	pop    %ebp
8010224f:	c3                   	ret    

80102250 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102256:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102259:	83 ec 40             	sub    $0x40,%esp
8010225c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010225f:	6a 06                	push   $0x6
80102261:	68 ea 84 10 80       	push   $0x801084ea
80102266:	56                   	push   %esi
80102267:	e8 c4 2d 00 00       	call   80105030 <memmove>
  itoa(p->pid, path+ 6);
8010226c:	58                   	pop    %eax
8010226d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102270:	5a                   	pop    %edx
80102271:	50                   	push   %eax
80102272:	ff 73 10             	pushl  0x10(%ebx)
80102275:	e8 46 ff ff ff       	call   801021c0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010227a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010227d:	83 c4 10             	add    $0x10,%esp
80102280:	85 c0                	test   %eax,%eax
80102282:	0f 84 88 01 00 00    	je     80102410 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102288:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010228b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010228e:	50                   	push   %eax
8010228f:	e8 4c ee ff ff       	call   801010e0 <fileclose>

  begin_op();
80102294:	e8 a7 11 00 00       	call   80103440 <begin_op>
  return namex(path, 1, name);
80102299:	89 f0                	mov    %esi,%eax
8010229b:	89 d9                	mov    %ebx,%ecx
8010229d:	ba 01 00 00 00       	mov    $0x1,%edx
801022a2:	e8 59 fc ff ff       	call   80101f00 <namex>
  if((dp = nameiparent(path, name)) == 0)
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801022ac:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801022ae:	0f 84 66 01 00 00    	je     8010241a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801022b4:	83 ec 0c             	sub    $0xc,%esp
801022b7:	50                   	push   %eax
801022b8:	e8 63 f6 ff ff       	call   80101920 <ilock>
  return strncmp(s, t, DIRSIZ);
801022bd:	83 c4 0c             	add    $0xc,%esp
801022c0:	6a 0e                	push   $0xe
801022c2:	68 f2 84 10 80       	push   $0x801084f2
801022c7:	53                   	push   %ebx
801022c8:	e8 d3 2d 00 00       	call   801050a0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801022cd:	83 c4 10             	add    $0x10,%esp
801022d0:	85 c0                	test   %eax,%eax
801022d2:	0f 84 f8 00 00 00    	je     801023d0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801022d8:	83 ec 04             	sub    $0x4,%esp
801022db:	6a 0e                	push   $0xe
801022dd:	68 f1 84 10 80       	push   $0x801084f1
801022e2:	53                   	push   %ebx
801022e3:	e8 b8 2d 00 00       	call   801050a0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801022e8:	83 c4 10             	add    $0x10,%esp
801022eb:	85 c0                	test   %eax,%eax
801022ed:	0f 84 dd 00 00 00    	je     801023d0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801022f3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801022f6:	83 ec 04             	sub    $0x4,%esp
801022f9:	50                   	push   %eax
801022fa:	53                   	push   %ebx
801022fb:	56                   	push   %esi
801022fc:	e8 4f fb ff ff       	call   80101e50 <dirlookup>
80102301:	83 c4 10             	add    $0x10,%esp
80102304:	85 c0                	test   %eax,%eax
80102306:	89 c3                	mov    %eax,%ebx
80102308:	0f 84 c2 00 00 00    	je     801023d0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010230e:	83 ec 0c             	sub    $0xc,%esp
80102311:	50                   	push   %eax
80102312:	e8 09 f6 ff ff       	call   80101920 <ilock>

  if(ip->nlink < 1)
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010231f:	0f 8e 11 01 00 00    	jle    80102436 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102325:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010232a:	74 74                	je     801023a0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010232c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010232f:	83 ec 04             	sub    $0x4,%esp
80102332:	6a 10                	push   $0x10
80102334:	6a 00                	push   $0x0
80102336:	57                   	push   %edi
80102337:	e8 44 2c 00 00       	call   80104f80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010233c:	6a 10                	push   $0x10
8010233e:	ff 75 b8             	pushl  -0x48(%ebp)
80102341:	57                   	push   %edi
80102342:	56                   	push   %esi
80102343:	e8 b8 f9 ff ff       	call   80101d00 <writei>
80102348:	83 c4 20             	add    $0x20,%esp
8010234b:	83 f8 10             	cmp    $0x10,%eax
8010234e:	0f 85 d5 00 00 00    	jne    80102429 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102354:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102359:	0f 84 91 00 00 00    	je     801023f0 <removeSwapFile+0x1a0>
  iunlock(ip);
8010235f:	83 ec 0c             	sub    $0xc,%esp
80102362:	56                   	push   %esi
80102363:	e8 98 f6 ff ff       	call   80101a00 <iunlock>
  iput(ip);
80102368:	89 34 24             	mov    %esi,(%esp)
8010236b:	e8 e0 f6 ff ff       	call   80101a50 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102370:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102375:	89 1c 24             	mov    %ebx,(%esp)
80102378:	e8 f3 f4 ff ff       	call   80101870 <iupdate>
  iunlock(ip);
8010237d:	89 1c 24             	mov    %ebx,(%esp)
80102380:	e8 7b f6 ff ff       	call   80101a00 <iunlock>
  iput(ip);
80102385:	89 1c 24             	mov    %ebx,(%esp)
80102388:	e8 c3 f6 ff ff       	call   80101a50 <iput>
  iunlockput(ip);

  end_op();
8010238d:	e8 1e 11 00 00       	call   801034b0 <end_op>

  return 0;
80102392:	83 c4 10             	add    $0x10,%esp
80102395:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010239a:	5b                   	pop    %ebx
8010239b:	5e                   	pop    %esi
8010239c:	5f                   	pop    %edi
8010239d:	5d                   	pop    %ebp
8010239e:	c3                   	ret    
8010239f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801023a0:	83 ec 0c             	sub    $0xc,%esp
801023a3:	53                   	push   %ebx
801023a4:	e8 b7 33 00 00       	call   80105760 <isdirempty>
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 c0                	test   %eax,%eax
801023ae:	0f 85 78 ff ff ff    	jne    8010232c <removeSwapFile+0xdc>
  iunlock(ip);
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	53                   	push   %ebx
801023b8:	e8 43 f6 ff ff       	call   80101a00 <iunlock>
  iput(ip);
801023bd:	89 1c 24             	mov    %ebx,(%esp)
801023c0:	e8 8b f6 ff ff       	call   80101a50 <iput>
801023c5:	83 c4 10             	add    $0x10,%esp
801023c8:	90                   	nop
801023c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801023d0:	83 ec 0c             	sub    $0xc,%esp
801023d3:	56                   	push   %esi
801023d4:	e8 27 f6 ff ff       	call   80101a00 <iunlock>
  iput(ip);
801023d9:	89 34 24             	mov    %esi,(%esp)
801023dc:	e8 6f f6 ff ff       	call   80101a50 <iput>
    end_op();
801023e1:	e8 ca 10 00 00       	call   801034b0 <end_op>
    return -1;
801023e6:	83 c4 10             	add    $0x10,%esp
801023e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801023ee:	eb a7                	jmp    80102397 <removeSwapFile+0x147>
    dp->nlink--;
801023f0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801023f5:	83 ec 0c             	sub    $0xc,%esp
801023f8:	56                   	push   %esi
801023f9:	e8 72 f4 ff ff       	call   80101870 <iupdate>
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	e9 59 ff ff ff       	jmp    8010235f <removeSwapFile+0x10f>
80102406:	8d 76 00             	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102415:	e9 7d ff ff ff       	jmp    80102397 <removeSwapFile+0x147>
    end_op();
8010241a:	e8 91 10 00 00       	call   801034b0 <end_op>
    return -1;
8010241f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102424:	e9 6e ff ff ff       	jmp    80102397 <removeSwapFile+0x147>
    panic("unlink: writei");
80102429:	83 ec 0c             	sub    $0xc,%esp
8010242c:	68 06 85 10 80       	push   $0x80108506
80102431:	e8 5a df ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102436:	83 ec 0c             	sub    $0xc,%esp
80102439:	68 f4 84 10 80       	push   $0x801084f4
8010243e:	e8 4d df ff ff       	call   80100390 <panic>
80102443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102455:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102458:	83 ec 14             	sub    $0x14,%esp
8010245b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010245e:	6a 06                	push   $0x6
80102460:	68 ea 84 10 80       	push   $0x801084ea
80102465:	56                   	push   %esi
80102466:	e8 c5 2b 00 00       	call   80105030 <memmove>
  itoa(p->pid, path+ 6);
8010246b:	58                   	pop    %eax
8010246c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010246f:	5a                   	pop    %edx
80102470:	50                   	push   %eax
80102471:	ff 73 10             	pushl  0x10(%ebx)
80102474:	e8 47 fd ff ff       	call   801021c0 <itoa>

    begin_op();
80102479:	e8 c2 0f 00 00       	call   80103440 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010247e:	6a 00                	push   $0x0
80102480:	6a 00                	push   $0x0
80102482:	6a 02                	push   $0x2
80102484:	56                   	push   %esi
80102485:	e8 e6 34 00 00       	call   80105970 <create>
  iunlock(in);
8010248a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010248d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010248f:	50                   	push   %eax
80102490:	e8 6b f5 ff ff       	call   80101a00 <iunlock>

  p->swapFile = filealloc();
80102495:	e8 86 eb ff ff       	call   80101020 <filealloc>
  if (p->swapFile == 0)
8010249a:	83 c4 10             	add    $0x10,%esp
8010249d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010249f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801024a2:	74 32                	je     801024d6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801024a4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801024a7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024aa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801024b0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024b3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801024ba:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024bd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801024c1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801024c4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801024c8:	e8 e3 0f 00 00       	call   801034b0 <end_op>

    return 0;
}
801024cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024d0:	31 c0                	xor    %eax,%eax
801024d2:	5b                   	pop    %ebx
801024d3:	5e                   	pop    %esi
801024d4:	5d                   	pop    %ebp
801024d5:	c3                   	ret    
    panic("no slot for files on /store");
801024d6:	83 ec 0c             	sub    $0xc,%esp
801024d9:	68 15 85 10 80       	push   $0x80108515
801024de:	e8 ad de ff ff       	call   80100390 <panic>
801024e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024f0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801024f0:	55                   	push   %ebp
801024f1:	89 e5                	mov    %esp,%ebp
801024f3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
801024f6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801024f9:	8b 50 7c             	mov    0x7c(%eax),%edx
801024fc:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
801024ff:	8b 55 14             	mov    0x14(%ebp),%edx
80102502:	89 55 10             	mov    %edx,0x10(%ebp)
80102505:	8b 40 7c             	mov    0x7c(%eax),%eax
80102508:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010250b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010250c:	e9 7f ed ff ff       	jmp    80101290 <filewrite>
80102511:	eb 0d                	jmp    80102520 <readFromSwapFile>
80102513:	90                   	nop
80102514:	90                   	nop
80102515:	90                   	nop
80102516:	90                   	nop
80102517:	90                   	nop
80102518:	90                   	nop
80102519:	90                   	nop
8010251a:	90                   	nop
8010251b:	90                   	nop
8010251c:	90                   	nop
8010251d:	90                   	nop
8010251e:	90                   	nop
8010251f:	90                   	nop

80102520 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102526:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102529:	8b 50 7c             	mov    0x7c(%eax),%edx
8010252c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010252f:	8b 55 14             	mov    0x14(%ebp),%edx
80102532:	89 55 10             	mov    %edx,0x10(%ebp)
80102535:	8b 40 7c             	mov    0x7c(%eax),%eax
80102538:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010253b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010253c:	e9 bf ec ff ff       	jmp    80101200 <fileread>
80102541:	66 90                	xchg   %ax,%ax
80102543:	66 90                	xchg   %ax,%ax
80102545:	66 90                	xchg   %ax,%ax
80102547:	66 90                	xchg   %ax,%ax
80102549:	66 90                	xchg   %ax,%ax
8010254b:	66 90                	xchg   %ax,%ax
8010254d:	66 90                	xchg   %ax,%ax
8010254f:	90                   	nop

80102550 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	57                   	push   %edi
80102554:	56                   	push   %esi
80102555:	53                   	push   %ebx
80102556:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102559:	85 c0                	test   %eax,%eax
8010255b:	0f 84 b4 00 00 00    	je     80102615 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102561:	8b 58 08             	mov    0x8(%eax),%ebx
80102564:	89 c6                	mov    %eax,%esi
80102566:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010256c:	0f 87 96 00 00 00    	ja     80102608 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102572:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102577:	89 f6                	mov    %esi,%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102580:	89 ca                	mov    %ecx,%edx
80102582:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102583:	83 e0 c0             	and    $0xffffffc0,%eax
80102586:	3c 40                	cmp    $0x40,%al
80102588:	75 f6                	jne    80102580 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010258a:	31 ff                	xor    %edi,%edi
8010258c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102591:	89 f8                	mov    %edi,%eax
80102593:	ee                   	out    %al,(%dx)
80102594:	b8 01 00 00 00       	mov    $0x1,%eax
80102599:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010259e:	ee                   	out    %al,(%dx)
8010259f:	ba f3 01 00 00       	mov    $0x1f3,%edx
801025a4:	89 d8                	mov    %ebx,%eax
801025a6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801025a7:	89 d8                	mov    %ebx,%eax
801025a9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801025ae:	c1 f8 08             	sar    $0x8,%eax
801025b1:	ee                   	out    %al,(%dx)
801025b2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801025b7:	89 f8                	mov    %edi,%eax
801025b9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801025ba:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801025be:	ba f6 01 00 00       	mov    $0x1f6,%edx
801025c3:	c1 e0 04             	shl    $0x4,%eax
801025c6:	83 e0 10             	and    $0x10,%eax
801025c9:	83 c8 e0             	or     $0xffffffe0,%eax
801025cc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801025cd:	f6 06 04             	testb  $0x4,(%esi)
801025d0:	75 16                	jne    801025e8 <idestart+0x98>
801025d2:	b8 20 00 00 00       	mov    $0x20,%eax
801025d7:	89 ca                	mov    %ecx,%edx
801025d9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801025da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025dd:	5b                   	pop    %ebx
801025de:	5e                   	pop    %esi
801025df:	5f                   	pop    %edi
801025e0:	5d                   	pop    %ebp
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e8:	b8 30 00 00 00       	mov    $0x30,%eax
801025ed:	89 ca                	mov    %ecx,%edx
801025ef:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801025f0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801025f5:	83 c6 5c             	add    $0x5c,%esi
801025f8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801025fd:	fc                   	cld    
801025fe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102603:	5b                   	pop    %ebx
80102604:	5e                   	pop    %esi
80102605:	5f                   	pop    %edi
80102606:	5d                   	pop    %ebp
80102607:	c3                   	ret    
    panic("incorrect blockno");
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	68 90 85 10 80       	push   $0x80108590
80102610:	e8 7b dd ff ff       	call   80100390 <panic>
    panic("idestart");
80102615:	83 ec 0c             	sub    $0xc,%esp
80102618:	68 87 85 10 80       	push   $0x80108587
8010261d:	e8 6e dd ff ff       	call   80100390 <panic>
80102622:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102630 <ideinit>:
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102636:	68 a2 85 10 80       	push   $0x801085a2
8010263b:	68 80 c5 10 80       	push   $0x8010c580
80102640:	e8 eb 26 00 00       	call   80104d30 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102645:	58                   	pop    %eax
80102646:	a1 40 6d 18 80       	mov    0x80186d40,%eax
8010264b:	5a                   	pop    %edx
8010264c:	83 e8 01             	sub    $0x1,%eax
8010264f:	50                   	push   %eax
80102650:	6a 0e                	push   $0xe
80102652:	e8 a9 02 00 00       	call   80102900 <ioapicenable>
80102657:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010265a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010265f:	90                   	nop
80102660:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102661:	83 e0 c0             	and    $0xffffffc0,%eax
80102664:	3c 40                	cmp    $0x40,%al
80102666:	75 f8                	jne    80102660 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102668:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010266d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102672:	ee                   	out    %al,(%dx)
80102673:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102678:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010267d:	eb 06                	jmp    80102685 <ideinit+0x55>
8010267f:	90                   	nop
  for(i=0; i<1000; i++){
80102680:	83 e9 01             	sub    $0x1,%ecx
80102683:	74 0f                	je     80102694 <ideinit+0x64>
80102685:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102686:	84 c0                	test   %al,%al
80102688:	74 f6                	je     80102680 <ideinit+0x50>
      havedisk1 = 1;
8010268a:	c7 05 60 c5 10 80 01 	movl   $0x1,0x8010c560
80102691:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102694:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102699:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010269e:	ee                   	out    %al,(%dx)
}
8010269f:	c9                   	leave  
801026a0:	c3                   	ret    
801026a1:	eb 0d                	jmp    801026b0 <ideintr>
801026a3:	90                   	nop
801026a4:	90                   	nop
801026a5:	90                   	nop
801026a6:	90                   	nop
801026a7:	90                   	nop
801026a8:	90                   	nop
801026a9:	90                   	nop
801026aa:	90                   	nop
801026ab:	90                   	nop
801026ac:	90                   	nop
801026ad:	90                   	nop
801026ae:	90                   	nop
801026af:	90                   	nop

801026b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	57                   	push   %edi
801026b4:	56                   	push   %esi
801026b5:	53                   	push   %ebx
801026b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026b9:	68 80 c5 10 80       	push   $0x8010c580
801026be:	e8 ad 27 00 00       	call   80104e70 <acquire>

  if((b = idequeue) == 0){
801026c3:	8b 1d 64 c5 10 80    	mov    0x8010c564,%ebx
801026c9:	83 c4 10             	add    $0x10,%esp
801026cc:	85 db                	test   %ebx,%ebx
801026ce:	74 67                	je     80102737 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801026d0:	8b 43 58             	mov    0x58(%ebx),%eax
801026d3:	a3 64 c5 10 80       	mov    %eax,0x8010c564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801026d8:	8b 3b                	mov    (%ebx),%edi
801026da:	f7 c7 04 00 00 00    	test   $0x4,%edi
801026e0:	75 31                	jne    80102713 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026f1:	89 c6                	mov    %eax,%esi
801026f3:	83 e6 c0             	and    $0xffffffc0,%esi
801026f6:	89 f1                	mov    %esi,%ecx
801026f8:	80 f9 40             	cmp    $0x40,%cl
801026fb:	75 f3                	jne    801026f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026fd:	a8 21                	test   $0x21,%al
801026ff:	75 12                	jne    80102713 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102701:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102704:	b9 80 00 00 00       	mov    $0x80,%ecx
80102709:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010270e:	fc                   	cld    
8010270f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102711:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102713:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102716:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102719:	89 f9                	mov    %edi,%ecx
8010271b:	83 c9 02             	or     $0x2,%ecx
8010271e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102720:	53                   	push   %ebx
80102721:	e8 0a 23 00 00       	call   80104a30 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102726:	a1 64 c5 10 80       	mov    0x8010c564,%eax
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	85 c0                	test   %eax,%eax
80102730:	74 05                	je     80102737 <ideintr+0x87>
    idestart(idequeue);
80102732:	e8 19 fe ff ff       	call   80102550 <idestart>
    release(&idelock);
80102737:	83 ec 0c             	sub    $0xc,%esp
8010273a:	68 80 c5 10 80       	push   $0x8010c580
8010273f:	e8 ec 27 00 00       	call   80104f30 <release>

  release(&idelock);
}
80102744:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102747:	5b                   	pop    %ebx
80102748:	5e                   	pop    %esi
80102749:	5f                   	pop    %edi
8010274a:	5d                   	pop    %ebp
8010274b:	c3                   	ret    
8010274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102750 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	53                   	push   %ebx
80102754:	83 ec 10             	sub    $0x10,%esp
80102757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010275a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010275d:	50                   	push   %eax
8010275e:	e8 7d 25 00 00       	call   80104ce0 <holdingsleep>
80102763:	83 c4 10             	add    $0x10,%esp
80102766:	85 c0                	test   %eax,%eax
80102768:	0f 84 c6 00 00 00    	je     80102834 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010276e:	8b 03                	mov    (%ebx),%eax
80102770:	83 e0 06             	and    $0x6,%eax
80102773:	83 f8 02             	cmp    $0x2,%eax
80102776:	0f 84 ab 00 00 00    	je     80102827 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010277c:	8b 53 04             	mov    0x4(%ebx),%edx
8010277f:	85 d2                	test   %edx,%edx
80102781:	74 0d                	je     80102790 <iderw+0x40>
80102783:	a1 60 c5 10 80       	mov    0x8010c560,%eax
80102788:	85 c0                	test   %eax,%eax
8010278a:	0f 84 b1 00 00 00    	je     80102841 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102790:	83 ec 0c             	sub    $0xc,%esp
80102793:	68 80 c5 10 80       	push   $0x8010c580
80102798:	e8 d3 26 00 00       	call   80104e70 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010279d:	8b 15 64 c5 10 80    	mov    0x8010c564,%edx
801027a3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801027a6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801027ad:	85 d2                	test   %edx,%edx
801027af:	75 09                	jne    801027ba <iderw+0x6a>
801027b1:	eb 6d                	jmp    80102820 <iderw+0xd0>
801027b3:	90                   	nop
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b8:	89 c2                	mov    %eax,%edx
801027ba:	8b 42 58             	mov    0x58(%edx),%eax
801027bd:	85 c0                	test   %eax,%eax
801027bf:	75 f7                	jne    801027b8 <iderw+0x68>
801027c1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801027c4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801027c6:	39 1d 64 c5 10 80    	cmp    %ebx,0x8010c564
801027cc:	74 42                	je     80102810 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ce:	8b 03                	mov    (%ebx),%eax
801027d0:	83 e0 06             	and    $0x6,%eax
801027d3:	83 f8 02             	cmp    $0x2,%eax
801027d6:	74 23                	je     801027fb <iderw+0xab>
801027d8:	90                   	nop
801027d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801027e0:	83 ec 08             	sub    $0x8,%esp
801027e3:	68 80 c5 10 80       	push   $0x8010c580
801027e8:	53                   	push   %ebx
801027e9:	e8 52 20 00 00       	call   80104840 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801027ee:	8b 03                	mov    (%ebx),%eax
801027f0:	83 c4 10             	add    $0x10,%esp
801027f3:	83 e0 06             	and    $0x6,%eax
801027f6:	83 f8 02             	cmp    $0x2,%eax
801027f9:	75 e5                	jne    801027e0 <iderw+0x90>
  }


  release(&idelock);
801027fb:	c7 45 08 80 c5 10 80 	movl   $0x8010c580,0x8(%ebp)
}
80102802:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102805:	c9                   	leave  
  release(&idelock);
80102806:	e9 25 27 00 00       	jmp    80104f30 <release>
8010280b:	90                   	nop
8010280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102810:	89 d8                	mov    %ebx,%eax
80102812:	e8 39 fd ff ff       	call   80102550 <idestart>
80102817:	eb b5                	jmp    801027ce <iderw+0x7e>
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102820:	ba 64 c5 10 80       	mov    $0x8010c564,%edx
80102825:	eb 9d                	jmp    801027c4 <iderw+0x74>
    panic("iderw: nothing to do");
80102827:	83 ec 0c             	sub    $0xc,%esp
8010282a:	68 bc 85 10 80       	push   $0x801085bc
8010282f:	e8 5c db ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102834:	83 ec 0c             	sub    $0xc,%esp
80102837:	68 a6 85 10 80       	push   $0x801085a6
8010283c:	e8 4f db ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102841:	83 ec 0c             	sub    $0xc,%esp
80102844:	68 d1 85 10 80       	push   $0x801085d1
80102849:	e8 42 db ff ff       	call   80100390 <panic>
8010284e:	66 90                	xchg   %ax,%ax

80102850 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102850:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102851:	c7 05 74 66 11 80 00 	movl   $0xfec00000,0x80116674
80102858:	00 c0 fe 
{
8010285b:	89 e5                	mov    %esp,%ebp
8010285d:	56                   	push   %esi
8010285e:	53                   	push   %ebx
  ioapic->reg = reg;
8010285f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102866:	00 00 00 
  return ioapic->data;
80102869:	a1 74 66 11 80       	mov    0x80116674,%eax
8010286e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102877:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010287d:	0f b6 15 a0 67 18 80 	movzbl 0x801867a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102884:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102887:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010288a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010288d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102890:	39 c2                	cmp    %eax,%edx
80102892:	74 16                	je     801028aa <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102894:	83 ec 0c             	sub    $0xc,%esp
80102897:	68 f0 85 10 80       	push   $0x801085f0
8010289c:	e8 bf dd ff ff       	call   80100660 <cprintf>
801028a1:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
801028a7:	83 c4 10             	add    $0x10,%esp
801028aa:	83 c3 21             	add    $0x21,%ebx
{
801028ad:	ba 10 00 00 00       	mov    $0x10,%edx
801028b2:	b8 20 00 00 00       	mov    $0x20,%eax
801028b7:	89 f6                	mov    %esi,%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801028c0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801028c2:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801028c8:	89 c6                	mov    %eax,%esi
801028ca:	81 ce 00 00 01 00    	or     $0x10000,%esi
801028d0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801028d3:	89 71 10             	mov    %esi,0x10(%ecx)
801028d6:	8d 72 01             	lea    0x1(%edx),%esi
801028d9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801028dc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801028de:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801028e0:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
801028e6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801028ed:	75 d1                	jne    801028c0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801028ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028f2:	5b                   	pop    %ebx
801028f3:	5e                   	pop    %esi
801028f4:	5d                   	pop    %ebp
801028f5:	c3                   	ret    
801028f6:	8d 76 00             	lea    0x0(%esi),%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102900:	55                   	push   %ebp
  ioapic->reg = reg;
80102901:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
{
80102907:	89 e5                	mov    %esp,%ebp
80102909:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010290c:	8d 50 20             	lea    0x20(%eax),%edx
8010290f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102913:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102915:	8b 0d 74 66 11 80    	mov    0x80116674,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010291b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010291e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102921:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102924:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102926:	a1 74 66 11 80       	mov    0x80116674,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010292b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010292e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102931:	5d                   	pop    %ebp
80102932:	c3                   	ret    
80102933:	66 90                	xchg   %ax,%ax
80102935:	66 90                	xchg   %ax,%ax
80102937:	66 90                	xchg   %ax,%ax
80102939:	66 90                	xchg   %ax,%ax
8010293b:	66 90                	xchg   %ax,%ax
8010293d:	66 90                	xchg   %ax,%ax
8010293f:	90                   	nop

80102940 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102940:	55                   	push   %ebp
80102941:	89 e5                	mov    %esp,%ebp
80102943:	53                   	push   %ebx
80102944:	83 ec 04             	sub    $0x4,%esp
80102947:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010294a:	a9 ff 0f 00 00       	test   $0xfff,%eax
8010294f:	0f 85 ad 00 00 00    	jne    80102a02 <kfree+0xc2>
80102955:	3d e8 1b 19 80       	cmp    $0x80191be8,%eax
8010295a:	0f 82 a2 00 00 00    	jb     80102a02 <kfree+0xc2>
80102960:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102966:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
8010296c:	0f 87 90 00 00 00    	ja     80102a02 <kfree+0xc2>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102972:	83 ec 04             	sub    $0x4,%esp
80102975:	68 00 10 00 00       	push   $0x1000
8010297a:	6a 01                	push   $0x1
8010297c:	50                   	push   %eax
8010297d:	e8 fe 25 00 00       	call   80104f80 <memset>

  if(kmem.use_lock) 
80102982:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
80102988:	83 c4 10             	add    $0x10,%esp
8010298b:	85 d2                	test   %edx,%edx
8010298d:	75 61                	jne    801029f0 <kfree+0xb0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010298f:	c1 eb 0c             	shr    $0xc,%ebx
80102992:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 1)
80102995:	83 3c c5 90 66 11 80 	cmpl   $0x1,-0x7fee9970(,%eax,8)
8010299c:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
8010299d:	8d 14 c5 8c 66 11 80 	lea    -0x7fee9974(,%eax,8),%edx
  if(r->refcount != 1)
801029a4:	75 69                	jne    80102a0f <kfree+0xcf>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
801029a6:	8b 0d b8 66 11 80    	mov    0x801166b8,%ecx
  r->refcount = 0;
801029ac:	c7 04 c5 90 66 11 80 	movl   $0x0,-0x7fee9970(,%eax,8)
801029b3:	00 00 00 00 
  kmem.freelist = r;
801029b7:	89 15 b8 66 11 80    	mov    %edx,0x801166b8
  r->next = kmem.freelist;
801029bd:	89 0c c5 8c 66 11 80 	mov    %ecx,-0x7fee9974(,%eax,8)
  if(kmem.use_lock)
801029c4:	a1 b4 66 11 80       	mov    0x801166b4,%eax
801029c9:	85 c0                	test   %eax,%eax
801029cb:	75 0b                	jne    801029d8 <kfree+0x98>
    release(&kmem.lock);
}
801029cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029d0:	c9                   	leave  
801029d1:	c3                   	ret    
801029d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801029d8:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
801029df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029e2:	c9                   	leave  
    release(&kmem.lock);
801029e3:	e9 48 25 00 00       	jmp    80104f30 <release>
801029e8:	90                   	nop
801029e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801029f0:	83 ec 0c             	sub    $0xc,%esp
801029f3:	68 80 66 11 80       	push   $0x80116680
801029f8:	e8 73 24 00 00       	call   80104e70 <acquire>
801029fd:	83 c4 10             	add    $0x10,%esp
80102a00:	eb 8d                	jmp    8010298f <kfree+0x4f>
    panic("kfree");
80102a02:	83 ec 0c             	sub    $0xc,%esp
80102a05:	68 22 86 10 80       	push   $0x80108622
80102a0a:	e8 81 d9 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102a0f:	83 ec 0c             	sub    $0xc,%esp
80102a12:	68 28 86 10 80       	push   $0x80108628
80102a17:	e8 74 d9 ff ff       	call   80100390 <panic>
80102a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102a20 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	53                   	push   %ebx
80102a24:	83 ec 04             	sub    $0x4,%esp
80102a27:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a2a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102a2f:	0f 85 bd 00 00 00    	jne    80102af2 <kfree_nocheck+0xd2>
80102a35:	3d e8 1b 19 80       	cmp    $0x80191be8,%eax
80102a3a:	0f 82 b2 00 00 00    	jb     80102af2 <kfree_nocheck+0xd2>
80102a40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102a46:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102a4c:	0f 87 a0 00 00 00    	ja     80102af2 <kfree_nocheck+0xd2>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a52:	83 ec 04             	sub    $0x4,%esp
80102a55:	68 00 10 00 00       	push   $0x1000
80102a5a:	6a 01                	push   $0x1
80102a5c:	50                   	push   %eax
80102a5d:	e8 1e 25 00 00       	call   80104f80 <memset>

  if(kmem.use_lock) 
80102a62:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
80102a68:	83 c4 10             	add    $0x10,%esp
80102a6b:	85 d2                	test   %edx,%edx
80102a6d:	75 31                	jne    80102aa0 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102a6f:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102a74:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102a77:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
80102a7a:	c7 04 dd 90 66 11 80 	movl   $0x0,-0x7fee9970(,%ebx,8)
80102a81:	00 00 00 00 
  r->next = kmem.freelist;
80102a85:	89 04 dd 8c 66 11 80 	mov    %eax,-0x7fee9974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102a8c:	8d 04 dd 8c 66 11 80 	lea    -0x7fee9974(,%ebx,8),%eax
80102a93:	a3 b8 66 11 80       	mov    %eax,0x801166b8
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a9b:	c9                   	leave  
80102a9c:	c3                   	ret    
80102a9d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102aa0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102aa3:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102aa6:	68 80 66 11 80       	push   $0x80116680
  r->next = kmem.freelist;
80102aab:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102aae:	e8 bd 23 00 00       	call   80104e70 <acquire>
  r->next = kmem.freelist;
80102ab3:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  if(kmem.use_lock)
80102ab8:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102abb:	c7 04 dd 90 66 11 80 	movl   $0x0,-0x7fee9970(,%ebx,8)
80102ac2:	00 00 00 00 
  r->next = kmem.freelist;
80102ac6:	89 04 dd 8c 66 11 80 	mov    %eax,-0x7fee9974(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102acd:	8d 04 dd 8c 66 11 80 	lea    -0x7fee9974(,%ebx,8),%eax
80102ad4:	a3 b8 66 11 80       	mov    %eax,0x801166b8
  if(kmem.use_lock)
80102ad9:	a1 b4 66 11 80       	mov    0x801166b4,%eax
80102ade:	85 c0                	test   %eax,%eax
80102ae0:	74 b6                	je     80102a98 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102ae2:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
80102ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aec:	c9                   	leave  
    release(&kmem.lock);
80102aed:	e9 3e 24 00 00       	jmp    80104f30 <release>
    panic("kfree_nocheck");
80102af2:	83 ec 0c             	sub    $0xc,%esp
80102af5:	68 45 86 10 80       	push   $0x80108645
80102afa:	e8 91 d8 ff ff       	call   80100390 <panic>
80102aff:	90                   	nop

80102b00 <freerange>:
{
80102b00:	55                   	push   %ebp
80102b01:	89 e5                	mov    %esp,%ebp
80102b03:	56                   	push   %esi
80102b04:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102b05:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102b08:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102b0b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b11:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b1d:	39 de                	cmp    %ebx,%esi
80102b1f:	72 23                	jb     80102b44 <freerange+0x44>
80102b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102b28:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102b2e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102b37:	50                   	push   %eax
80102b38:	e8 e3 fe ff ff       	call   80102a20 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b3d:	83 c4 10             	add    $0x10,%esp
80102b40:	39 f3                	cmp    %esi,%ebx
80102b42:	76 e4                	jbe    80102b28 <freerange+0x28>
}
80102b44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102b47:	5b                   	pop    %ebx
80102b48:	5e                   	pop    %esi
80102b49:	5d                   	pop    %ebp
80102b4a:	c3                   	ret    
80102b4b:	90                   	nop
80102b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b50 <kinit1>:
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
80102b55:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102b58:	83 ec 08             	sub    $0x8,%esp
80102b5b:	68 53 86 10 80       	push   $0x80108653
80102b60:	68 80 66 11 80       	push   $0x80116680
80102b65:	e8 c6 21 00 00       	call   80104d30 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b6d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b70:	c7 05 b4 66 11 80 00 	movl   $0x0,0x801166b4
80102b77:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102b7a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102b80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b86:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102b8c:	39 de                	cmp    %ebx,%esi
80102b8e:	72 1c                	jb     80102bac <kinit1+0x5c>
    kfree_nocheck(p);
80102b90:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102b96:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102b99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102b9f:	50                   	push   %eax
80102ba0:	e8 7b fe ff ff       	call   80102a20 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ba5:	83 c4 10             	add    $0x10,%esp
80102ba8:	39 de                	cmp    %ebx,%esi
80102baa:	73 e4                	jae    80102b90 <kinit1+0x40>
}
80102bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102baf:	5b                   	pop    %ebx
80102bb0:	5e                   	pop    %esi
80102bb1:	5d                   	pop    %ebp
80102bb2:	c3                   	ret    
80102bb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <kinit2>:
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	56                   	push   %esi
80102bc4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102bc5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102bcb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102bd1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bd7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102bdd:	39 de                	cmp    %ebx,%esi
80102bdf:	72 23                	jb     80102c04 <kinit2+0x44>
80102be1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102be8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102bee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102bf7:	50                   	push   %eax
80102bf8:	e8 23 fe ff ff       	call   80102a20 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bfd:	83 c4 10             	add    $0x10,%esp
80102c00:	39 de                	cmp    %ebx,%esi
80102c02:	73 e4                	jae    80102be8 <kinit2+0x28>
  kmem.use_lock = 1;
80102c04:	c7 05 b4 66 11 80 01 	movl   $0x1,0x801166b4
80102c0b:	00 00 00 
}
80102c0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c11:	5b                   	pop    %ebx
80102c12:	5e                   	pop    %esi
80102c13:	5d                   	pop    %ebp
80102c14:	c3                   	ret    
80102c15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102c26:	a1 b4 66 11 80       	mov    0x801166b4,%eax
80102c2b:	85 c0                	test   %eax,%eax
80102c2d:	75 59                	jne    80102c88 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102c2f:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  if(r)
80102c34:	85 c0                	test   %eax,%eax
80102c36:	74 73                	je     80102cab <kalloc+0x8b>
  {
    kmem.freelist = r->next;
80102c38:	8b 10                	mov    (%eax),%edx
80102c3a:	89 15 b8 66 11 80    	mov    %edx,0x801166b8
    r->refcount = 1;
80102c40:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102c47:	8b 0d b4 66 11 80    	mov    0x801166b4,%ecx
80102c4d:	85 c9                	test   %ecx,%ecx
80102c4f:	75 0f                	jne    80102c60 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102c51:	2d bc 66 11 80       	sub    $0x801166bc,%eax
80102c56:	c1 e0 09             	shl    $0x9,%eax
80102c59:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102c5e:	c9                   	leave  
80102c5f:	c3                   	ret    
    release(&kmem.lock);
80102c60:	83 ec 0c             	sub    $0xc,%esp
80102c63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102c66:	68 80 66 11 80       	push   $0x80116680
80102c6b:	e8 c0 22 00 00       	call   80104f30 <release>
80102c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c73:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102c76:	2d bc 66 11 80       	sub    $0x801166bc,%eax
80102c7b:	c1 e0 09             	shl    $0x9,%eax
80102c7e:	05 00 00 00 80       	add    $0x80000000,%eax
80102c83:	eb d9                	jmp    80102c5e <kalloc+0x3e>
80102c85:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102c88:	83 ec 0c             	sub    $0xc,%esp
80102c8b:	68 80 66 11 80       	push   $0x80116680
80102c90:	e8 db 21 00 00       	call   80104e70 <acquire>
  r = kmem.freelist;
80102c95:	a1 b8 66 11 80       	mov    0x801166b8,%eax
  if(r)
80102c9a:	83 c4 10             	add    $0x10,%esp
80102c9d:	85 c0                	test   %eax,%eax
80102c9f:	75 97                	jne    80102c38 <kalloc+0x18>
  if(kmem.use_lock)
80102ca1:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
80102ca7:	85 d2                	test   %edx,%edx
80102ca9:	75 05                	jne    80102cb0 <kalloc+0x90>
{
80102cab:	31 c0                	xor    %eax,%eax
}
80102cad:	c9                   	leave  
80102cae:	c3                   	ret    
80102caf:	90                   	nop
    release(&kmem.lock);
80102cb0:	83 ec 0c             	sub    $0xc,%esp
80102cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cb6:	68 80 66 11 80       	push   $0x80116680
80102cbb:	e8 70 22 00 00       	call   80104f30 <release>
80102cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc3:	83 c4 10             	add    $0x10,%esp
}
80102cc6:	c9                   	leave  
80102cc7:	c3                   	ret    
80102cc8:	90                   	nop
80102cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cd0 <refDec>:

void
refDec(char *v)
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	53                   	push   %ebx
80102cd4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102cd7:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
{
80102cdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102ce0:	85 d2                	test   %edx,%edx
80102ce2:	75 1c                	jne    80102d00 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ce4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102cea:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102ced:	83 2c c5 c0 66 11 80 	subl   $0x1,-0x7fee9940(,%eax,8)
80102cf4:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102cf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cf8:	c9                   	leave  
80102cf9:	c3                   	ret    
80102cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102d00:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102d03:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102d09:	68 80 66 11 80       	push   $0x80116680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102d0e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102d11:	e8 5a 21 00 00       	call   80104e70 <acquire>
  if(kmem.use_lock)
80102d16:	a1 b4 66 11 80       	mov    0x801166b4,%eax
  r->refcount -= 1;
80102d1b:	83 2c dd c0 66 11 80 	subl   $0x1,-0x7fee9940(,%ebx,8)
80102d22:	01 
  if(kmem.use_lock)
80102d23:	83 c4 10             	add    $0x10,%esp
80102d26:	85 c0                	test   %eax,%eax
80102d28:	74 cb                	je     80102cf5 <refDec+0x25>
    release(&kmem.lock);
80102d2a:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
80102d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d34:	c9                   	leave  
    release(&kmem.lock);
80102d35:	e9 f6 21 00 00       	jmp    80104f30 <release>
80102d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102d40 <refInc>:

void
refInc(char *v)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	53                   	push   %ebx
80102d44:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102d47:	8b 15 b4 66 11 80    	mov    0x801166b4,%edx
{
80102d4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102d50:	85 d2                	test   %edx,%edx
80102d52:	75 1c                	jne    80102d70 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102d54:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102d5a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102d5d:	83 04 c5 c0 66 11 80 	addl   $0x1,-0x7fee9940(,%eax,8)
80102d64:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d68:	c9                   	leave  
80102d69:	c3                   	ret    
80102d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102d70:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102d73:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102d79:	68 80 66 11 80       	push   $0x80116680
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102d7e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102d81:	e8 ea 20 00 00       	call   80104e70 <acquire>
  if(kmem.use_lock)
80102d86:	a1 b4 66 11 80       	mov    0x801166b4,%eax
  r->refcount += 1;
80102d8b:	83 04 dd c0 66 11 80 	addl   $0x1,-0x7fee9940(,%ebx,8)
80102d92:	01 
  if(kmem.use_lock)
80102d93:	83 c4 10             	add    $0x10,%esp
80102d96:	85 c0                	test   %eax,%eax
80102d98:	74 cb                	je     80102d65 <refInc+0x25>
    release(&kmem.lock);
80102d9a:	c7 45 08 80 66 11 80 	movl   $0x80116680,0x8(%ebp)
}
80102da1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da4:	c9                   	leave  
    release(&kmem.lock);
80102da5:	e9 86 21 00 00       	jmp    80104f30 <release>
80102daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102db0 <getRefs>:

int
getRefs(char *v)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102db3:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102db6:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102db7:	05 00 00 00 80       	add    $0x80000000,%eax
80102dbc:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102dbf:	8b 04 c5 c0 66 11 80 	mov    -0x7fee9940(,%eax,8),%eax
80102dc6:	c3                   	ret    
80102dc7:	66 90                	xchg   %ax,%ax
80102dc9:	66 90                	xchg   %ax,%ax
80102dcb:	66 90                	xchg   %ax,%ax
80102dcd:	66 90                	xchg   %ax,%ax
80102dcf:	90                   	nop

80102dd0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dd0:	ba 64 00 00 00       	mov    $0x64,%edx
80102dd5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102dd6:	a8 01                	test   $0x1,%al
80102dd8:	0f 84 c2 00 00 00    	je     80102ea0 <kbdgetc+0xd0>
80102dde:	ba 60 00 00 00       	mov    $0x60,%edx
80102de3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102de4:	0f b6 d0             	movzbl %al,%edx
80102de7:	8b 0d b4 c5 10 80    	mov    0x8010c5b4,%ecx

  if(data == 0xE0){
80102ded:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102df3:	0f 84 7f 00 00 00    	je     80102e78 <kbdgetc+0xa8>
{
80102df9:	55                   	push   %ebp
80102dfa:	89 e5                	mov    %esp,%ebp
80102dfc:	53                   	push   %ebx
80102dfd:	89 cb                	mov    %ecx,%ebx
80102dff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102e02:	84 c0                	test   %al,%al
80102e04:	78 4a                	js     80102e50 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102e06:	85 db                	test   %ebx,%ebx
80102e08:	74 09                	je     80102e13 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e0a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102e0d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102e10:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102e13:	0f b6 82 80 87 10 80 	movzbl -0x7fef7880(%edx),%eax
80102e1a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102e1c:	0f b6 82 80 86 10 80 	movzbl -0x7fef7980(%edx),%eax
80102e23:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e25:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102e27:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102e2d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102e30:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102e33:	8b 04 85 60 86 10 80 	mov    -0x7fef79a0(,%eax,4),%eax
80102e3a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102e3e:	74 31                	je     80102e71 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102e40:	8d 50 9f             	lea    -0x61(%eax),%edx
80102e43:	83 fa 19             	cmp    $0x19,%edx
80102e46:	77 40                	ja     80102e88 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102e48:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102e4b:	5b                   	pop    %ebx
80102e4c:	5d                   	pop    %ebp
80102e4d:	c3                   	ret    
80102e4e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e50:	83 e0 7f             	and    $0x7f,%eax
80102e53:	85 db                	test   %ebx,%ebx
80102e55:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102e58:	0f b6 82 80 87 10 80 	movzbl -0x7fef7880(%edx),%eax
80102e5f:	83 c8 40             	or     $0x40,%eax
80102e62:	0f b6 c0             	movzbl %al,%eax
80102e65:	f7 d0                	not    %eax
80102e67:	21 c1                	and    %eax,%ecx
    return 0;
80102e69:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e6b:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
}
80102e71:	5b                   	pop    %ebx
80102e72:	5d                   	pop    %ebp
80102e73:	c3                   	ret    
80102e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102e78:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102e7b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e7d:	89 0d b4 c5 10 80    	mov    %ecx,0x8010c5b4
    return 0;
80102e83:	c3                   	ret    
80102e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e88:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e8b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e8e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102e8f:	83 f9 1a             	cmp    $0x1a,%ecx
80102e92:	0f 42 c2             	cmovb  %edx,%eax
}
80102e95:	5d                   	pop    %ebp
80102e96:	c3                   	ret    
80102e97:	89 f6                	mov    %esi,%esi
80102e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102ea0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ea5:	c3                   	ret    
80102ea6:	8d 76 00             	lea    0x0(%esi),%esi
80102ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102eb0 <kbdintr>:

void
kbdintr(void)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
80102eb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102eb6:	68 d0 2d 10 80       	push   $0x80102dd0
80102ebb:	e8 50 d9 ff ff       	call   80100810 <consoleintr>
}
80102ec0:	83 c4 10             	add    $0x10,%esp
80102ec3:	c9                   	leave  
80102ec4:	c3                   	ret    
80102ec5:	66 90                	xchg   %ax,%ax
80102ec7:	66 90                	xchg   %ax,%ax
80102ec9:	66 90                	xchg   %ax,%ax
80102ecb:	66 90                	xchg   %ax,%ax
80102ecd:	66 90                	xchg   %ax,%ax
80102ecf:	90                   	nop

80102ed0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ed0:	a1 bc 66 18 80       	mov    0x801866bc,%eax
{
80102ed5:	55                   	push   %ebp
80102ed6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ed8:	85 c0                	test   %eax,%eax
80102eda:	0f 84 c8 00 00 00    	je     80102fa8 <lapicinit+0xd8>
  lapic[index] = value;
80102ee0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ee7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102eea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ef4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102efa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102f01:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102f04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f07:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102f0e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102f11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f14:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102f1b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f21:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102f28:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f2e:	8b 50 30             	mov    0x30(%eax),%edx
80102f31:	c1 ea 10             	shr    $0x10,%edx
80102f34:	80 fa 03             	cmp    $0x3,%dl
80102f37:	77 77                	ja     80102fb0 <lapicinit+0xe0>
  lapic[index] = value;
80102f39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102f40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f84:	8b 50 20             	mov    0x20(%eax),%edx
80102f87:	89 f6                	mov    %esi,%esi
80102f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f96:	80 e6 10             	and    $0x10,%dh
80102f99:	75 f5                	jne    80102f90 <lapicinit+0xc0>
  lapic[index] = value;
80102f9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102fa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102fa8:	5d                   	pop    %ebp
80102fa9:	c3                   	ret    
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102fb0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102fb7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102fba:	8b 50 20             	mov    0x20(%eax),%edx
80102fbd:	e9 77 ff ff ff       	jmp    80102f39 <lapicinit+0x69>
80102fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fd0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102fd0:	8b 15 bc 66 18 80    	mov    0x801866bc,%edx
{
80102fd6:	55                   	push   %ebp
80102fd7:	31 c0                	xor    %eax,%eax
80102fd9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102fdb:	85 d2                	test   %edx,%edx
80102fdd:	74 06                	je     80102fe5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102fdf:	8b 42 20             	mov    0x20(%edx),%eax
80102fe2:	c1 e8 18             	shr    $0x18,%eax
}
80102fe5:	5d                   	pop    %ebp
80102fe6:	c3                   	ret    
80102fe7:	89 f6                	mov    %esi,%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102ff0:	a1 bc 66 18 80       	mov    0x801866bc,%eax
{
80102ff5:	55                   	push   %ebp
80102ff6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102ff8:	85 c0                	test   %eax,%eax
80102ffa:	74 0d                	je     80103009 <lapiceoi+0x19>
  lapic[index] = value;
80102ffc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103003:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103006:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103009:	5d                   	pop    %ebp
8010300a:	c3                   	ret    
8010300b:	90                   	nop
8010300c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103010 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
}
80103013:	5d                   	pop    %ebp
80103014:	c3                   	ret    
80103015:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103020 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103020:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103021:	b8 0f 00 00 00       	mov    $0xf,%eax
80103026:	ba 70 00 00 00       	mov    $0x70,%edx
8010302b:	89 e5                	mov    %esp,%ebp
8010302d:	53                   	push   %ebx
8010302e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103031:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103034:	ee                   	out    %al,(%dx)
80103035:	b8 0a 00 00 00       	mov    $0xa,%eax
8010303a:	ba 71 00 00 00       	mov    $0x71,%edx
8010303f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103040:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103042:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103045:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010304b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010304d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103050:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103053:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103055:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103058:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010305e:	a1 bc 66 18 80       	mov    0x801866bc,%eax
80103063:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103069:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010306c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103073:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103076:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103079:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103080:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103083:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103086:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010308c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010308f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103095:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103098:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010309e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801030a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801030aa:	5b                   	pop    %ebx
801030ab:	5d                   	pop    %ebp
801030ac:	c3                   	ret    
801030ad:	8d 76 00             	lea    0x0(%esi),%esi

801030b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801030b0:	55                   	push   %ebp
801030b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801030b6:	ba 70 00 00 00       	mov    $0x70,%edx
801030bb:	89 e5                	mov    %esp,%ebp
801030bd:	57                   	push   %edi
801030be:	56                   	push   %esi
801030bf:	53                   	push   %ebx
801030c0:	83 ec 4c             	sub    $0x4c,%esp
801030c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c4:	ba 71 00 00 00       	mov    $0x71,%edx
801030c9:	ec                   	in     (%dx),%al
801030ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801030d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801030d5:	8d 76 00             	lea    0x0(%esi),%esi
801030d8:	31 c0                	xor    %eax,%eax
801030da:	89 da                	mov    %ebx,%edx
801030dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801030e2:	89 ca                	mov    %ecx,%edx
801030e4:	ec                   	in     (%dx),%al
801030e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e8:	89 da                	mov    %ebx,%edx
801030ea:	b8 02 00 00 00       	mov    $0x2,%eax
801030ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f0:	89 ca                	mov    %ecx,%edx
801030f2:	ec                   	in     (%dx),%al
801030f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f6:	89 da                	mov    %ebx,%edx
801030f8:	b8 04 00 00 00       	mov    $0x4,%eax
801030fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030fe:	89 ca                	mov    %ecx,%edx
80103100:	ec                   	in     (%dx),%al
80103101:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103104:	89 da                	mov    %ebx,%edx
80103106:	b8 07 00 00 00       	mov    $0x7,%eax
8010310b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010310c:	89 ca                	mov    %ecx,%edx
8010310e:	ec                   	in     (%dx),%al
8010310f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103112:	89 da                	mov    %ebx,%edx
80103114:	b8 08 00 00 00       	mov    $0x8,%eax
80103119:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010311a:	89 ca                	mov    %ecx,%edx
8010311c:	ec                   	in     (%dx),%al
8010311d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010311f:	89 da                	mov    %ebx,%edx
80103121:	b8 09 00 00 00       	mov    $0x9,%eax
80103126:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103127:	89 ca                	mov    %ecx,%edx
80103129:	ec                   	in     (%dx),%al
8010312a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010312c:	89 da                	mov    %ebx,%edx
8010312e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103133:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103134:	89 ca                	mov    %ecx,%edx
80103136:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103137:	84 c0                	test   %al,%al
80103139:	78 9d                	js     801030d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010313b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010313f:	89 fa                	mov    %edi,%edx
80103141:	0f b6 fa             	movzbl %dl,%edi
80103144:	89 f2                	mov    %esi,%edx
80103146:	0f b6 f2             	movzbl %dl,%esi
80103149:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010314c:	89 da                	mov    %ebx,%edx
8010314e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103151:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103154:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103158:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010315b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010315f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103162:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103166:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103169:	31 c0                	xor    %eax,%eax
8010316b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010316c:	89 ca                	mov    %ecx,%edx
8010316e:	ec                   	in     (%dx),%al
8010316f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103172:	89 da                	mov    %ebx,%edx
80103174:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103177:	b8 02 00 00 00       	mov    $0x2,%eax
8010317c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010317d:	89 ca                	mov    %ecx,%edx
8010317f:	ec                   	in     (%dx),%al
80103180:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103183:	89 da                	mov    %ebx,%edx
80103185:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103188:	b8 04 00 00 00       	mov    $0x4,%eax
8010318d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010318e:	89 ca                	mov    %ecx,%edx
80103190:	ec                   	in     (%dx),%al
80103191:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103194:	89 da                	mov    %ebx,%edx
80103196:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103199:	b8 07 00 00 00       	mov    $0x7,%eax
8010319e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010319f:	89 ca                	mov    %ecx,%edx
801031a1:	ec                   	in     (%dx),%al
801031a2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a5:	89 da                	mov    %ebx,%edx
801031a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801031aa:	b8 08 00 00 00       	mov    $0x8,%eax
801031af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031b0:	89 ca                	mov    %ecx,%edx
801031b2:	ec                   	in     (%dx),%al
801031b3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b6:	89 da                	mov    %ebx,%edx
801031b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801031bb:	b8 09 00 00 00       	mov    $0x9,%eax
801031c0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c1:	89 ca                	mov    %ecx,%edx
801031c3:	ec                   	in     (%dx),%al
801031c4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031c7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801031ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801031cd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801031d0:	6a 18                	push   $0x18
801031d2:	50                   	push   %eax
801031d3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801031d6:	50                   	push   %eax
801031d7:	e8 f4 1d 00 00       	call   80104fd0 <memcmp>
801031dc:	83 c4 10             	add    $0x10,%esp
801031df:	85 c0                	test   %eax,%eax
801031e1:	0f 85 f1 fe ff ff    	jne    801030d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801031e7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801031eb:	75 78                	jne    80103265 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031f0:	89 c2                	mov    %eax,%edx
801031f2:	83 e0 0f             	and    $0xf,%eax
801031f5:	c1 ea 04             	shr    $0x4,%edx
801031f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103201:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103204:	89 c2                	mov    %eax,%edx
80103206:	83 e0 0f             	and    $0xf,%eax
80103209:	c1 ea 04             	shr    $0x4,%edx
8010320c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010320f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103212:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103215:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103218:	89 c2                	mov    %eax,%edx
8010321a:	83 e0 0f             	and    $0xf,%eax
8010321d:	c1 ea 04             	shr    $0x4,%edx
80103220:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103223:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103226:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103229:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010322c:	89 c2                	mov    %eax,%edx
8010322e:	83 e0 0f             	and    $0xf,%eax
80103231:	c1 ea 04             	shr    $0x4,%edx
80103234:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103237:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010323a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010323d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103240:	89 c2                	mov    %eax,%edx
80103242:	83 e0 0f             	and    $0xf,%eax
80103245:	c1 ea 04             	shr    $0x4,%edx
80103248:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010324b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010324e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103251:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103254:	89 c2                	mov    %eax,%edx
80103256:	83 e0 0f             	and    $0xf,%eax
80103259:	c1 ea 04             	shr    $0x4,%edx
8010325c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010325f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103262:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103265:	8b 75 08             	mov    0x8(%ebp),%esi
80103268:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010326b:	89 06                	mov    %eax,(%esi)
8010326d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103270:	89 46 04             	mov    %eax,0x4(%esi)
80103273:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103276:	89 46 08             	mov    %eax,0x8(%esi)
80103279:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010327c:	89 46 0c             	mov    %eax,0xc(%esi)
8010327f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103282:	89 46 10             	mov    %eax,0x10(%esi)
80103285:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103288:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010328b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103292:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103295:	5b                   	pop    %ebx
80103296:	5e                   	pop    %esi
80103297:	5f                   	pop    %edi
80103298:	5d                   	pop    %ebp
80103299:	c3                   	ret    
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032a0:	8b 0d 08 67 18 80    	mov    0x80186708,%ecx
801032a6:	85 c9                	test   %ecx,%ecx
801032a8:	0f 8e 8a 00 00 00    	jle    80103338 <install_trans+0x98>
{
801032ae:	55                   	push   %ebp
801032af:	89 e5                	mov    %esp,%ebp
801032b1:	57                   	push   %edi
801032b2:	56                   	push   %esi
801032b3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801032b4:	31 db                	xor    %ebx,%ebx
{
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032c0:	a1 f4 66 18 80       	mov    0x801866f4,%eax
801032c5:	83 ec 08             	sub    $0x8,%esp
801032c8:	01 d8                	add    %ebx,%eax
801032ca:	83 c0 01             	add    $0x1,%eax
801032cd:	50                   	push   %eax
801032ce:	ff 35 04 67 18 80    	pushl  0x80186704
801032d4:	e8 f7 cd ff ff       	call   801000d0 <bread>
801032d9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032db:	58                   	pop    %eax
801032dc:	5a                   	pop    %edx
801032dd:	ff 34 9d 0c 67 18 80 	pushl  -0x7fe798f4(,%ebx,4)
801032e4:	ff 35 04 67 18 80    	pushl  0x80186704
  for (tail = 0; tail < log.lh.n; tail++) {
801032ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801032ed:	e8 de cd ff ff       	call   801000d0 <bread>
801032f2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032f4:	8d 47 5c             	lea    0x5c(%edi),%eax
801032f7:	83 c4 0c             	add    $0xc,%esp
801032fa:	68 00 02 00 00       	push   $0x200
801032ff:	50                   	push   %eax
80103300:	8d 46 5c             	lea    0x5c(%esi),%eax
80103303:	50                   	push   %eax
80103304:	e8 27 1d 00 00       	call   80105030 <memmove>
    bwrite(dbuf);  // write dst to disk
80103309:	89 34 24             	mov    %esi,(%esp)
8010330c:	e8 8f ce ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103311:	89 3c 24             	mov    %edi,(%esp)
80103314:	e8 c7 ce ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103319:	89 34 24             	mov    %esi,(%esp)
8010331c:	e8 bf ce ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103321:	83 c4 10             	add    $0x10,%esp
80103324:	39 1d 08 67 18 80    	cmp    %ebx,0x80186708
8010332a:	7f 94                	jg     801032c0 <install_trans+0x20>
  }
}
8010332c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010332f:	5b                   	pop    %ebx
80103330:	5e                   	pop    %esi
80103331:	5f                   	pop    %edi
80103332:	5d                   	pop    %ebp
80103333:	c3                   	ret    
80103334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103338:	f3 c3                	repz ret 
8010333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103340 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	56                   	push   %esi
80103344:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103345:	83 ec 08             	sub    $0x8,%esp
80103348:	ff 35 f4 66 18 80    	pushl  0x801866f4
8010334e:	ff 35 04 67 18 80    	pushl  0x80186704
80103354:	e8 77 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103359:	8b 1d 08 67 18 80    	mov    0x80186708,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010335f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103362:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103364:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103366:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103369:	7e 16                	jle    80103381 <write_head+0x41>
8010336b:	c1 e3 02             	shl    $0x2,%ebx
8010336e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103370:	8b 8a 0c 67 18 80    	mov    -0x7fe798f4(%edx),%ecx
80103376:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010337a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010337d:	39 da                	cmp    %ebx,%edx
8010337f:	75 ef                	jne    80103370 <write_head+0x30>
  }
  bwrite(buf);
80103381:	83 ec 0c             	sub    $0xc,%esp
80103384:	56                   	push   %esi
80103385:	e8 16 ce ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010338a:	89 34 24             	mov    %esi,(%esp)
8010338d:	e8 4e ce ff ff       	call   801001e0 <brelse>
}
80103392:	83 c4 10             	add    $0x10,%esp
80103395:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103398:	5b                   	pop    %ebx
80103399:	5e                   	pop    %esi
8010339a:	5d                   	pop    %ebp
8010339b:	c3                   	ret    
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033a0 <initlog>:
{
801033a0:	55                   	push   %ebp
801033a1:	89 e5                	mov    %esp,%ebp
801033a3:	53                   	push   %ebx
801033a4:	83 ec 2c             	sub    $0x2c,%esp
801033a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801033aa:	68 80 88 10 80       	push   $0x80108880
801033af:	68 c0 66 18 80       	push   $0x801866c0
801033b4:	e8 77 19 00 00       	call   80104d30 <initlock>
  readsb(dev, &sb);
801033b9:	58                   	pop    %eax
801033ba:	8d 45 dc             	lea    -0x24(%ebp),%eax
801033bd:	5a                   	pop    %edx
801033be:	50                   	push   %eax
801033bf:	53                   	push   %ebx
801033c0:	e8 1b e3 ff ff       	call   801016e0 <readsb>
  log.size = sb.nlog;
801033c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801033c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801033cb:	59                   	pop    %ecx
  log.dev = dev;
801033cc:	89 1d 04 67 18 80    	mov    %ebx,0x80186704
  log.size = sb.nlog;
801033d2:	89 15 f8 66 18 80    	mov    %edx,0x801866f8
  log.start = sb.logstart;
801033d8:	a3 f4 66 18 80       	mov    %eax,0x801866f4
  struct buf *buf = bread(log.dev, log.start);
801033dd:	5a                   	pop    %edx
801033de:	50                   	push   %eax
801033df:	53                   	push   %ebx
801033e0:	e8 eb cc ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
801033e5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
801033e8:	83 c4 10             	add    $0x10,%esp
801033eb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
801033ed:	89 1d 08 67 18 80    	mov    %ebx,0x80186708
  for (i = 0; i < log.lh.n; i++) {
801033f3:	7e 1c                	jle    80103411 <initlog+0x71>
801033f5:	c1 e3 02             	shl    $0x2,%ebx
801033f8:	31 d2                	xor    %edx,%edx
801033fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103400:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103404:	83 c2 04             	add    $0x4,%edx
80103407:	89 8a 08 67 18 80    	mov    %ecx,-0x7fe798f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010340d:	39 d3                	cmp    %edx,%ebx
8010340f:	75 ef                	jne    80103400 <initlog+0x60>
  brelse(buf);
80103411:	83 ec 0c             	sub    $0xc,%esp
80103414:	50                   	push   %eax
80103415:	e8 c6 cd ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010341a:	e8 81 fe ff ff       	call   801032a0 <install_trans>
  log.lh.n = 0;
8010341f:	c7 05 08 67 18 80 00 	movl   $0x0,0x80186708
80103426:	00 00 00 
  write_head(); // clear the log
80103429:	e8 12 ff ff ff       	call   80103340 <write_head>
}
8010342e:	83 c4 10             	add    $0x10,%esp
80103431:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103434:	c9                   	leave  
80103435:	c3                   	ret    
80103436:	8d 76 00             	lea    0x0(%esi),%esi
80103439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103440 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103446:	68 c0 66 18 80       	push   $0x801866c0
8010344b:	e8 20 1a 00 00       	call   80104e70 <acquire>
80103450:	83 c4 10             	add    $0x10,%esp
80103453:	eb 18                	jmp    8010346d <begin_op+0x2d>
80103455:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103458:	83 ec 08             	sub    $0x8,%esp
8010345b:	68 c0 66 18 80       	push   $0x801866c0
80103460:	68 c0 66 18 80       	push   $0x801866c0
80103465:	e8 d6 13 00 00       	call   80104840 <sleep>
8010346a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010346d:	a1 00 67 18 80       	mov    0x80186700,%eax
80103472:	85 c0                	test   %eax,%eax
80103474:	75 e2                	jne    80103458 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103476:	a1 fc 66 18 80       	mov    0x801866fc,%eax
8010347b:	8b 15 08 67 18 80    	mov    0x80186708,%edx
80103481:	83 c0 01             	add    $0x1,%eax
80103484:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103487:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010348a:	83 fa 1e             	cmp    $0x1e,%edx
8010348d:	7f c9                	jg     80103458 <begin_op+0x18>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010348f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103492:	a3 fc 66 18 80       	mov    %eax,0x801866fc
      release(&log.lock);
80103497:	68 c0 66 18 80       	push   $0x801866c0
8010349c:	e8 8f 1a 00 00       	call   80104f30 <release>
      break;
    }
  }
}
801034a1:	83 c4 10             	add    $0x10,%esp
801034a4:	c9                   	leave  
801034a5:	c3                   	ret    
801034a6:	8d 76 00             	lea    0x0(%esi),%esi
801034a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801034b0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	57                   	push   %edi
801034b4:	56                   	push   %esi
801034b5:	53                   	push   %ebx
801034b6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801034b9:	68 c0 66 18 80       	push   $0x801866c0
801034be:	e8 ad 19 00 00       	call   80104e70 <acquire>
  log.outstanding -= 1;
801034c3:	a1 fc 66 18 80       	mov    0x801866fc,%eax
  if(log.committing)
801034c8:	8b 35 00 67 18 80    	mov    0x80186700,%esi
801034ce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801034d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801034d4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801034d6:	89 1d fc 66 18 80    	mov    %ebx,0x801866fc
  if(log.committing)
801034dc:	0f 85 1a 01 00 00    	jne    801035fc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801034e2:	85 db                	test   %ebx,%ebx
801034e4:	0f 85 ee 00 00 00    	jne    801035d8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801034ea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801034ed:	c7 05 00 67 18 80 01 	movl   $0x1,0x80186700
801034f4:	00 00 00 
  release(&log.lock);
801034f7:	68 c0 66 18 80       	push   $0x801866c0
801034fc:	e8 2f 1a 00 00       	call   80104f30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103501:	8b 0d 08 67 18 80    	mov    0x80186708,%ecx
80103507:	83 c4 10             	add    $0x10,%esp
8010350a:	85 c9                	test   %ecx,%ecx
8010350c:	0f 8e 85 00 00 00    	jle    80103597 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103512:	a1 f4 66 18 80       	mov    0x801866f4,%eax
80103517:	83 ec 08             	sub    $0x8,%esp
8010351a:	01 d8                	add    %ebx,%eax
8010351c:	83 c0 01             	add    $0x1,%eax
8010351f:	50                   	push   %eax
80103520:	ff 35 04 67 18 80    	pushl  0x80186704
80103526:	e8 a5 cb ff ff       	call   801000d0 <bread>
8010352b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010352d:	58                   	pop    %eax
8010352e:	5a                   	pop    %edx
8010352f:	ff 34 9d 0c 67 18 80 	pushl  -0x7fe798f4(,%ebx,4)
80103536:	ff 35 04 67 18 80    	pushl  0x80186704
  for (tail = 0; tail < log.lh.n; tail++) {
8010353c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010353f:	e8 8c cb ff ff       	call   801000d0 <bread>
80103544:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103546:	8d 40 5c             	lea    0x5c(%eax),%eax
80103549:	83 c4 0c             	add    $0xc,%esp
8010354c:	68 00 02 00 00       	push   $0x200
80103551:	50                   	push   %eax
80103552:	8d 46 5c             	lea    0x5c(%esi),%eax
80103555:	50                   	push   %eax
80103556:	e8 d5 1a 00 00       	call   80105030 <memmove>
    bwrite(to);  // write the log
8010355b:	89 34 24             	mov    %esi,(%esp)
8010355e:	e8 3d cc ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103563:	89 3c 24             	mov    %edi,(%esp)
80103566:	e8 75 cc ff ff       	call   801001e0 <brelse>
    brelse(to);
8010356b:	89 34 24             	mov    %esi,(%esp)
8010356e:	e8 6d cc ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103573:	83 c4 10             	add    $0x10,%esp
80103576:	3b 1d 08 67 18 80    	cmp    0x80186708,%ebx
8010357c:	7c 94                	jl     80103512 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010357e:	e8 bd fd ff ff       	call   80103340 <write_head>
    install_trans(); // Now install writes to home locations
80103583:	e8 18 fd ff ff       	call   801032a0 <install_trans>
    log.lh.n = 0;
80103588:	c7 05 08 67 18 80 00 	movl   $0x0,0x80186708
8010358f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103592:	e8 a9 fd ff ff       	call   80103340 <write_head>
    acquire(&log.lock);
80103597:	83 ec 0c             	sub    $0xc,%esp
8010359a:	68 c0 66 18 80       	push   $0x801866c0
8010359f:	e8 cc 18 00 00       	call   80104e70 <acquire>
    wakeup(&log);
801035a4:	c7 04 24 c0 66 18 80 	movl   $0x801866c0,(%esp)
    log.committing = 0;
801035ab:	c7 05 00 67 18 80 00 	movl   $0x0,0x80186700
801035b2:	00 00 00 
    wakeup(&log);
801035b5:	e8 76 14 00 00       	call   80104a30 <wakeup>
    release(&log.lock);
801035ba:	c7 04 24 c0 66 18 80 	movl   $0x801866c0,(%esp)
801035c1:	e8 6a 19 00 00       	call   80104f30 <release>
801035c6:	83 c4 10             	add    $0x10,%esp
}
801035c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035cc:	5b                   	pop    %ebx
801035cd:	5e                   	pop    %esi
801035ce:	5f                   	pop    %edi
801035cf:	5d                   	pop    %ebp
801035d0:	c3                   	ret    
801035d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801035d8:	83 ec 0c             	sub    $0xc,%esp
801035db:	68 c0 66 18 80       	push   $0x801866c0
801035e0:	e8 4b 14 00 00       	call   80104a30 <wakeup>
  release(&log.lock);
801035e5:	c7 04 24 c0 66 18 80 	movl   $0x801866c0,(%esp)
801035ec:	e8 3f 19 00 00       	call   80104f30 <release>
801035f1:	83 c4 10             	add    $0x10,%esp
}
801035f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035f7:	5b                   	pop    %ebx
801035f8:	5e                   	pop    %esi
801035f9:	5f                   	pop    %edi
801035fa:	5d                   	pop    %ebp
801035fb:	c3                   	ret    
    panic("log.committing");
801035fc:	83 ec 0c             	sub    $0xc,%esp
801035ff:	68 84 88 10 80       	push   $0x80108884
80103604:	e8 87 cd ff ff       	call   80100390 <panic>
80103609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103610 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	53                   	push   %ebx
80103614:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103617:	8b 15 08 67 18 80    	mov    0x80186708,%edx
{
8010361d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103620:	83 fa 1d             	cmp    $0x1d,%edx
80103623:	0f 8f 9d 00 00 00    	jg     801036c6 <log_write+0xb6>
80103629:	a1 f8 66 18 80       	mov    0x801866f8,%eax
8010362e:	83 e8 01             	sub    $0x1,%eax
80103631:	39 c2                	cmp    %eax,%edx
80103633:	0f 8d 8d 00 00 00    	jge    801036c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103639:	a1 fc 66 18 80       	mov    0x801866fc,%eax
8010363e:	85 c0                	test   %eax,%eax
80103640:	0f 8e 8d 00 00 00    	jle    801036d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	68 c0 66 18 80       	push   $0x801866c0
8010364e:	e8 1d 18 00 00       	call   80104e70 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103653:	8b 0d 08 67 18 80    	mov    0x80186708,%ecx
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	83 f9 00             	cmp    $0x0,%ecx
8010365f:	7e 57                	jle    801036b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103661:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103664:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103666:	3b 15 0c 67 18 80    	cmp    0x8018670c,%edx
8010366c:	75 0b                	jne    80103679 <log_write+0x69>
8010366e:	eb 38                	jmp    801036a8 <log_write+0x98>
80103670:	39 14 85 0c 67 18 80 	cmp    %edx,-0x7fe798f4(,%eax,4)
80103677:	74 2f                	je     801036a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103679:	83 c0 01             	add    $0x1,%eax
8010367c:	39 c1                	cmp    %eax,%ecx
8010367e:	75 f0                	jne    80103670 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103680:	89 14 85 0c 67 18 80 	mov    %edx,-0x7fe798f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103687:	83 c0 01             	add    $0x1,%eax
8010368a:	a3 08 67 18 80       	mov    %eax,0x80186708
  b->flags |= B_DIRTY; // prevent eviction
8010368f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103692:	c7 45 08 c0 66 18 80 	movl   $0x801866c0,0x8(%ebp)
}
80103699:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010369c:	c9                   	leave  
  release(&log.lock);
8010369d:	e9 8e 18 00 00       	jmp    80104f30 <release>
801036a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801036a8:	89 14 85 0c 67 18 80 	mov    %edx,-0x7fe798f4(,%eax,4)
801036af:	eb de                	jmp    8010368f <log_write+0x7f>
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b8:	8b 43 08             	mov    0x8(%ebx),%eax
801036bb:	a3 0c 67 18 80       	mov    %eax,0x8018670c
  if (i == log.lh.n)
801036c0:	75 cd                	jne    8010368f <log_write+0x7f>
801036c2:	31 c0                	xor    %eax,%eax
801036c4:	eb c1                	jmp    80103687 <log_write+0x77>
    panic("too big a transaction");
801036c6:	83 ec 0c             	sub    $0xc,%esp
801036c9:	68 93 88 10 80       	push   $0x80108893
801036ce:	e8 bd cc ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801036d3:	83 ec 0c             	sub    $0xc,%esp
801036d6:	68 a9 88 10 80       	push   $0x801088a9
801036db:	e8 b0 cc ff ff       	call   80100390 <panic>

801036e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801036e7:	e8 54 0a 00 00       	call   80104140 <cpuid>
801036ec:	89 c3                	mov    %eax,%ebx
801036ee:	e8 4d 0a 00 00       	call   80104140 <cpuid>
801036f3:	83 ec 04             	sub    $0x4,%esp
801036f6:	53                   	push   %ebx
801036f7:	50                   	push   %eax
801036f8:	68 c4 88 10 80       	push   $0x801088c4
801036fd:	e8 5e cf ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103702:	e8 69 2b 00 00       	call   80106270 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103707:	e8 b4 09 00 00       	call   801040c0 <mycpu>
8010370c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010370e:	b8 01 00 00 00       	mov    $0x1,%eax
80103713:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010371a:	e8 11 0e 00 00       	call   80104530 <scheduler>
8010371f:	90                   	nop

80103720 <mpenter>:
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103726:	e8 f5 3b 00 00       	call   80107320 <switchkvm>
  seginit();
8010372b:	e8 60 3b 00 00       	call   80107290 <seginit>
  lapicinit();
80103730:	e8 9b f7 ff ff       	call   80102ed0 <lapicinit>
  mpmain();
80103735:	e8 a6 ff ff ff       	call   801036e0 <mpmain>
8010373a:	66 90                	xchg   %ax,%ax
8010373c:	66 90                	xchg   %ax,%ax
8010373e:	66 90                	xchg   %ax,%ax

80103740 <main>:
{
80103740:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103744:	83 e4 f0             	and    $0xfffffff0,%esp
80103747:	ff 71 fc             	pushl  -0x4(%ecx)
8010374a:	55                   	push   %ebp
8010374b:	89 e5                	mov    %esp,%ebp
8010374d:	53                   	push   %ebx
8010374e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010374f:	83 ec 08             	sub    $0x8,%esp
80103752:	68 00 00 40 80       	push   $0x80400000
80103757:	68 e8 1b 19 80       	push   $0x80191be8
8010375c:	e8 ef f3 ff ff       	call   80102b50 <kinit1>
  kvmalloc();      // kernel page table
80103761:	e8 3a 44 00 00       	call   80107ba0 <kvmalloc>
  mpinit();        // detect other processors
80103766:	e8 75 01 00 00       	call   801038e0 <mpinit>
  lapicinit();     // interrupt controller
8010376b:	e8 60 f7 ff ff       	call   80102ed0 <lapicinit>
  seginit();       // segment descriptors
80103770:	e8 1b 3b 00 00       	call   80107290 <seginit>
  picinit();       // disable pic
80103775:	e8 46 03 00 00       	call   80103ac0 <picinit>
  ioapicinit();    // another interrupt controller
8010377a:	e8 d1 f0 ff ff       	call   80102850 <ioapicinit>
  consoleinit();   // console hardware
8010377f:	e8 3c d2 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103784:	e8 07 2e 00 00       	call   80106590 <uartinit>
  pinit();         // process table
80103789:	e8 12 09 00 00       	call   801040a0 <pinit>
  tvinit();        // trap vectors
8010378e:	e8 5d 2a 00 00       	call   801061f0 <tvinit>
  binit();         // buffer cache
80103793:	e8 a8 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103798:	e8 63 d8 ff ff       	call   80101000 <fileinit>
  ideinit();       // disk 
8010379d:	e8 8e ee ff ff       	call   80102630 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801037a2:	83 c4 0c             	add    $0xc,%esp
801037a5:	68 8a 00 00 00       	push   $0x8a
801037aa:	68 8c c4 10 80       	push   $0x8010c48c
801037af:	68 00 70 00 80       	push   $0x80007000
801037b4:	e8 77 18 00 00       	call   80105030 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801037b9:	69 05 40 6d 18 80 b0 	imul   $0xb0,0x80186d40,%eax
801037c0:	00 00 00 
801037c3:	83 c4 10             	add    $0x10,%esp
801037c6:	05 c0 67 18 80       	add    $0x801867c0,%eax
801037cb:	3d c0 67 18 80       	cmp    $0x801867c0,%eax
801037d0:	76 71                	jbe    80103843 <main+0x103>
801037d2:	bb c0 67 18 80       	mov    $0x801867c0,%ebx
801037d7:	89 f6                	mov    %esi,%esi
801037d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801037e0:	e8 db 08 00 00       	call   801040c0 <mycpu>
801037e5:	39 d8                	cmp    %ebx,%eax
801037e7:	74 41                	je     8010382a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801037e9:	e8 32 f4 ff ff       	call   80102c20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801037ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801037f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103720,0x80006ff8
801037fa:	37 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037fd:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103804:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103807:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010380c:	0f b6 03             	movzbl (%ebx),%eax
8010380f:	83 ec 08             	sub    $0x8,%esp
80103812:	68 00 70 00 00       	push   $0x7000
80103817:	50                   	push   %eax
80103818:	e8 03 f8 ff ff       	call   80103020 <lapicstartap>
8010381d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103820:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103826:	85 c0                	test   %eax,%eax
80103828:	74 f6                	je     80103820 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010382a:	69 05 40 6d 18 80 b0 	imul   $0xb0,0x80186d40,%eax
80103831:	00 00 00 
80103834:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010383a:	05 c0 67 18 80       	add    $0x801867c0,%eax
8010383f:	39 c3                	cmp    %eax,%ebx
80103841:	72 9d                	jb     801037e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103843:	83 ec 08             	sub    $0x8,%esp
80103846:	68 00 00 00 8e       	push   $0x8e000000
8010384b:	68 00 00 40 80       	push   $0x80400000
80103850:	e8 6b f3 ff ff       	call   80102bc0 <kinit2>
  userinit();      // first user process
80103855:	e8 36 09 00 00       	call   80104190 <userinit>
  mpmain();        // finish this processor's setup
8010385a:	e8 81 fe ff ff       	call   801036e0 <mpmain>
8010385f:	90                   	nop

80103860 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	57                   	push   %edi
80103864:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103865:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010386b:	53                   	push   %ebx
  e = addr+len;
8010386c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010386f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103872:	39 de                	cmp    %ebx,%esi
80103874:	72 10                	jb     80103886 <mpsearch1+0x26>
80103876:	eb 50                	jmp    801038c8 <mpsearch1+0x68>
80103878:	90                   	nop
80103879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103880:	39 fb                	cmp    %edi,%ebx
80103882:	89 fe                	mov    %edi,%esi
80103884:	76 42                	jbe    801038c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103886:	83 ec 04             	sub    $0x4,%esp
80103889:	8d 7e 10             	lea    0x10(%esi),%edi
8010388c:	6a 04                	push   $0x4
8010388e:	68 d8 88 10 80       	push   $0x801088d8
80103893:	56                   	push   %esi
80103894:	e8 37 17 00 00       	call   80104fd0 <memcmp>
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 e0                	jne    80103880 <mpsearch1+0x20>
801038a0:	89 f1                	mov    %esi,%ecx
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801038a8:	0f b6 11             	movzbl (%ecx),%edx
801038ab:	83 c1 01             	add    $0x1,%ecx
801038ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801038b0:	39 f9                	cmp    %edi,%ecx
801038b2:	75 f4                	jne    801038a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801038b4:	84 c0                	test   %al,%al
801038b6:	75 c8                	jne    80103880 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801038b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038bb:	89 f0                	mov    %esi,%eax
801038bd:	5b                   	pop    %ebx
801038be:	5e                   	pop    %esi
801038bf:	5f                   	pop    %edi
801038c0:	5d                   	pop    %ebp
801038c1:	c3                   	ret    
801038c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801038cb:	31 f6                	xor    %esi,%esi
}
801038cd:	89 f0                	mov    %esi,%eax
801038cf:	5b                   	pop    %ebx
801038d0:	5e                   	pop    %esi
801038d1:	5f                   	pop    %edi
801038d2:	5d                   	pop    %ebp
801038d3:	c3                   	ret    
801038d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	57                   	push   %edi
801038e4:	56                   	push   %esi
801038e5:	53                   	push   %ebx
801038e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801038e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038f7:	c1 e0 08             	shl    $0x8,%eax
801038fa:	09 d0                	or     %edx,%eax
801038fc:	c1 e0 04             	shl    $0x4,%eax
801038ff:	85 c0                	test   %eax,%eax
80103901:	75 1b                	jne    8010391e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103903:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010390a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103911:	c1 e0 08             	shl    $0x8,%eax
80103914:	09 d0                	or     %edx,%eax
80103916:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103919:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010391e:	ba 00 04 00 00       	mov    $0x400,%edx
80103923:	e8 38 ff ff ff       	call   80103860 <mpsearch1>
80103928:	85 c0                	test   %eax,%eax
8010392a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010392d:	0f 84 3d 01 00 00    	je     80103a70 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103933:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103936:	8b 58 04             	mov    0x4(%eax),%ebx
80103939:	85 db                	test   %ebx,%ebx
8010393b:	0f 84 4f 01 00 00    	je     80103a90 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103941:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103947:	83 ec 04             	sub    $0x4,%esp
8010394a:	6a 04                	push   $0x4
8010394c:	68 f5 88 10 80       	push   $0x801088f5
80103951:	56                   	push   %esi
80103952:	e8 79 16 00 00       	call   80104fd0 <memcmp>
80103957:	83 c4 10             	add    $0x10,%esp
8010395a:	85 c0                	test   %eax,%eax
8010395c:	0f 85 2e 01 00 00    	jne    80103a90 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103962:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103969:	3c 01                	cmp    $0x1,%al
8010396b:	0f 95 c2             	setne  %dl
8010396e:	3c 04                	cmp    $0x4,%al
80103970:	0f 95 c0             	setne  %al
80103973:	20 c2                	and    %al,%dl
80103975:	0f 85 15 01 00 00    	jne    80103a90 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010397b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103982:	66 85 ff             	test   %di,%di
80103985:	74 1a                	je     801039a1 <mpinit+0xc1>
80103987:	89 f0                	mov    %esi,%eax
80103989:	01 f7                	add    %esi,%edi
  sum = 0;
8010398b:	31 d2                	xor    %edx,%edx
8010398d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103990:	0f b6 08             	movzbl (%eax),%ecx
80103993:	83 c0 01             	add    $0x1,%eax
80103996:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103998:	39 c7                	cmp    %eax,%edi
8010399a:	75 f4                	jne    80103990 <mpinit+0xb0>
8010399c:	84 d2                	test   %dl,%dl
8010399e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801039a1:	85 f6                	test   %esi,%esi
801039a3:	0f 84 e7 00 00 00    	je     80103a90 <mpinit+0x1b0>
801039a9:	84 d2                	test   %dl,%dl
801039ab:	0f 85 df 00 00 00    	jne    80103a90 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801039b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801039b7:	a3 bc 66 18 80       	mov    %eax,0x801866bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801039c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801039c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039ce:	01 d6                	add    %edx,%esi
801039d0:	39 c6                	cmp    %eax,%esi
801039d2:	76 23                	jbe    801039f7 <mpinit+0x117>
    switch(*p){
801039d4:	0f b6 10             	movzbl (%eax),%edx
801039d7:	80 fa 04             	cmp    $0x4,%dl
801039da:	0f 87 ca 00 00 00    	ja     80103aaa <mpinit+0x1ca>
801039e0:	ff 24 95 1c 89 10 80 	jmp    *-0x7fef76e4(,%edx,4)
801039e7:	89 f6                	mov    %esi,%esi
801039e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039f3:	39 c6                	cmp    %eax,%esi
801039f5:	77 dd                	ja     801039d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039f7:	85 db                	test   %ebx,%ebx
801039f9:	0f 84 9e 00 00 00    	je     80103a9d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a02:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103a06:	74 15                	je     80103a1d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a08:	b8 70 00 00 00       	mov    $0x70,%eax
80103a0d:	ba 22 00 00 00       	mov    $0x22,%edx
80103a12:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103a13:	ba 23 00 00 00       	mov    $0x23,%edx
80103a18:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a19:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a1c:	ee                   	out    %al,(%dx)
  }
}
80103a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a20:	5b                   	pop    %ebx
80103a21:	5e                   	pop    %esi
80103a22:	5f                   	pop    %edi
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    
80103a25:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103a28:	8b 0d 40 6d 18 80    	mov    0x80186d40,%ecx
80103a2e:	83 f9 07             	cmp    $0x7,%ecx
80103a31:	7f 19                	jg     80103a4c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a33:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103a37:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103a3d:	83 c1 01             	add    $0x1,%ecx
80103a40:	89 0d 40 6d 18 80    	mov    %ecx,0x80186d40
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103a46:	88 97 c0 67 18 80    	mov    %dl,-0x7fe79840(%edi)
      p += sizeof(struct mpproc);
80103a4c:	83 c0 14             	add    $0x14,%eax
      continue;
80103a4f:	e9 7c ff ff ff       	jmp    801039d0 <mpinit+0xf0>
80103a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a58:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103a5c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a5f:	88 15 a0 67 18 80    	mov    %dl,0x801867a0
      continue;
80103a65:	e9 66 ff ff ff       	jmp    801039d0 <mpinit+0xf0>
80103a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a70:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a75:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a7a:	e8 e1 fd ff ff       	call   80103860 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a7f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103a81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a84:	0f 85 a9 fe ff ff    	jne    80103933 <mpinit+0x53>
80103a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 dd 88 10 80       	push   $0x801088dd
80103a98:	e8 f3 c8 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a9d:	83 ec 0c             	sub    $0xc,%esp
80103aa0:	68 fc 88 10 80       	push   $0x801088fc
80103aa5:	e8 e6 c8 ff ff       	call   80100390 <panic>
      ismp = 0;
80103aaa:	31 db                	xor    %ebx,%ebx
80103aac:	e9 26 ff ff ff       	jmp    801039d7 <mpinit+0xf7>
80103ab1:	66 90                	xchg   %ax,%ax
80103ab3:	66 90                	xchg   %ax,%ax
80103ab5:	66 90                	xchg   %ax,%ax
80103ab7:	66 90                	xchg   %ax,%ax
80103ab9:	66 90                	xchg   %ax,%ax
80103abb:	66 90                	xchg   %ax,%ax
80103abd:	66 90                	xchg   %ax,%ax
80103abf:	90                   	nop

80103ac0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ac6:	ba 21 00 00 00       	mov    $0x21,%edx
80103acb:	89 e5                	mov    %esp,%ebp
80103acd:	ee                   	out    %al,(%dx)
80103ace:	ba a1 00 00 00       	mov    $0xa1,%edx
80103ad3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103ad4:	5d                   	pop    %ebp
80103ad5:	c3                   	ret    
80103ad6:	66 90                	xchg   %ax,%ax
80103ad8:	66 90                	xchg   %ax,%ax
80103ada:	66 90                	xchg   %ax,%ax
80103adc:	66 90                	xchg   %ax,%ax
80103ade:	66 90                	xchg   %ax,%ax

80103ae0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 0c             	sub    $0xc,%esp
80103ae9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103aef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103af5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103afb:	e8 20 d5 ff ff       	call   80101020 <filealloc>
80103b00:	85 c0                	test   %eax,%eax
80103b02:	89 03                	mov    %eax,(%ebx)
80103b04:	74 22                	je     80103b28 <pipealloc+0x48>
80103b06:	e8 15 d5 ff ff       	call   80101020 <filealloc>
80103b0b:	85 c0                	test   %eax,%eax
80103b0d:	89 06                	mov    %eax,(%esi)
80103b0f:	74 3f                	je     80103b50 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103b11:	e8 0a f1 ff ff       	call   80102c20 <kalloc>
80103b16:	85 c0                	test   %eax,%eax
80103b18:	89 c7                	mov    %eax,%edi
80103b1a:	75 54                	jne    80103b70 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103b1c:	8b 03                	mov    (%ebx),%eax
80103b1e:	85 c0                	test   %eax,%eax
80103b20:	75 34                	jne    80103b56 <pipealloc+0x76>
80103b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103b28:	8b 06                	mov    (%esi),%eax
80103b2a:	85 c0                	test   %eax,%eax
80103b2c:	74 0c                	je     80103b3a <pipealloc+0x5a>
    fileclose(*f1);
80103b2e:	83 ec 0c             	sub    $0xc,%esp
80103b31:	50                   	push   %eax
80103b32:	e8 a9 d5 ff ff       	call   801010e0 <fileclose>
80103b37:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103b3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103b3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103b42:	5b                   	pop    %ebx
80103b43:	5e                   	pop    %esi
80103b44:	5f                   	pop    %edi
80103b45:	5d                   	pop    %ebp
80103b46:	c3                   	ret    
80103b47:	89 f6                	mov    %esi,%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103b50:	8b 03                	mov    (%ebx),%eax
80103b52:	85 c0                	test   %eax,%eax
80103b54:	74 e4                	je     80103b3a <pipealloc+0x5a>
    fileclose(*f0);
80103b56:	83 ec 0c             	sub    $0xc,%esp
80103b59:	50                   	push   %eax
80103b5a:	e8 81 d5 ff ff       	call   801010e0 <fileclose>
  if(*f1)
80103b5f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103b61:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b64:	85 c0                	test   %eax,%eax
80103b66:	75 c6                	jne    80103b2e <pipealloc+0x4e>
80103b68:	eb d0                	jmp    80103b3a <pipealloc+0x5a>
80103b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103b70:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103b73:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b7a:	00 00 00 
  p->writeopen = 1;
80103b7d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b84:	00 00 00 
  p->nwrite = 0;
80103b87:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b8e:	00 00 00 
  p->nread = 0;
80103b91:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b98:	00 00 00 
  initlock(&p->lock, "pipe");
80103b9b:	68 30 89 10 80       	push   $0x80108930
80103ba0:	50                   	push   %eax
80103ba1:	e8 8a 11 00 00       	call   80104d30 <initlock>
  (*f0)->type = FD_PIPE;
80103ba6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103ba8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103bab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103bb1:	8b 03                	mov    (%ebx),%eax
80103bb3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103bb7:	8b 03                	mov    (%ebx),%eax
80103bb9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103bbd:	8b 03                	mov    (%ebx),%eax
80103bbf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103bc2:	8b 06                	mov    (%esi),%eax
80103bc4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103bca:	8b 06                	mov    (%esi),%eax
80103bcc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103bd0:	8b 06                	mov    (%esi),%eax
80103bd2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103bd6:	8b 06                	mov    (%esi),%eax
80103bd8:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103bdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103bde:	31 c0                	xor    %eax,%eax
}
80103be0:	5b                   	pop    %ebx
80103be1:	5e                   	pop    %esi
80103be2:	5f                   	pop    %edi
80103be3:	5d                   	pop    %ebp
80103be4:	c3                   	ret    
80103be5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bf0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
80103bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bf8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103bfb:	83 ec 0c             	sub    $0xc,%esp
80103bfe:	53                   	push   %ebx
80103bff:	e8 6c 12 00 00       	call   80104e70 <acquire>
  if(writable){
80103c04:	83 c4 10             	add    $0x10,%esp
80103c07:	85 f6                	test   %esi,%esi
80103c09:	74 45                	je     80103c50 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103c0b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103c11:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103c14:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103c1b:	00 00 00 
    wakeup(&p->nread);
80103c1e:	50                   	push   %eax
80103c1f:	e8 0c 0e 00 00       	call   80104a30 <wakeup>
80103c24:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103c27:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103c2d:	85 d2                	test   %edx,%edx
80103c2f:	75 0a                	jne    80103c3b <pipeclose+0x4b>
80103c31:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103c37:	85 c0                	test   %eax,%eax
80103c39:	74 35                	je     80103c70 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103c3b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103c3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c41:	5b                   	pop    %ebx
80103c42:	5e                   	pop    %esi
80103c43:	5d                   	pop    %ebp
    release(&p->lock);
80103c44:	e9 e7 12 00 00       	jmp    80104f30 <release>
80103c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103c50:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103c56:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103c59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c60:	00 00 00 
    wakeup(&p->nwrite);
80103c63:	50                   	push   %eax
80103c64:	e8 c7 0d 00 00       	call   80104a30 <wakeup>
80103c69:	83 c4 10             	add    $0x10,%esp
80103c6c:	eb b9                	jmp    80103c27 <pipeclose+0x37>
80103c6e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c70:	83 ec 0c             	sub    $0xc,%esp
80103c73:	53                   	push   %ebx
80103c74:	e8 b7 12 00 00       	call   80104f30 <release>
    kfree((char*)p);
80103c79:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c7c:	83 c4 10             	add    $0x10,%esp
}
80103c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c82:	5b                   	pop    %ebx
80103c83:	5e                   	pop    %esi
80103c84:	5d                   	pop    %ebp
    kfree((char*)p);
80103c85:	e9 b6 ec ff ff       	jmp    80102940 <kfree>
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c90 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	57                   	push   %edi
80103c94:	56                   	push   %esi
80103c95:	53                   	push   %ebx
80103c96:	83 ec 28             	sub    $0x28,%esp
80103c99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c9c:	53                   	push   %ebx
80103c9d:	e8 ce 11 00 00       	call   80104e70 <acquire>
  for(i = 0; i < n; i++){
80103ca2:	8b 45 10             	mov    0x10(%ebp),%eax
80103ca5:	83 c4 10             	add    $0x10,%esp
80103ca8:	85 c0                	test   %eax,%eax
80103caa:	0f 8e c9 00 00 00    	jle    80103d79 <pipewrite+0xe9>
80103cb0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103cb3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103cb9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103cbf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103cc2:	03 4d 10             	add    0x10(%ebp),%ecx
80103cc5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cc8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103cce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103cd4:	39 d0                	cmp    %edx,%eax
80103cd6:	75 71                	jne    80103d49 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103cd8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103cde:	85 c0                	test   %eax,%eax
80103ce0:	74 4e                	je     80103d30 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ce2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103ce8:	eb 3a                	jmp    80103d24 <pipewrite+0x94>
80103cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103cf0:	83 ec 0c             	sub    $0xc,%esp
80103cf3:	57                   	push   %edi
80103cf4:	e8 37 0d 00 00       	call   80104a30 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103cf9:	5a                   	pop    %edx
80103cfa:	59                   	pop    %ecx
80103cfb:	53                   	push   %ebx
80103cfc:	56                   	push   %esi
80103cfd:	e8 3e 0b 00 00       	call   80104840 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d02:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103d08:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103d0e:	83 c4 10             	add    $0x10,%esp
80103d11:	05 00 02 00 00       	add    $0x200,%eax
80103d16:	39 c2                	cmp    %eax,%edx
80103d18:	75 36                	jne    80103d50 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103d1a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103d20:	85 c0                	test   %eax,%eax
80103d22:	74 0c                	je     80103d30 <pipewrite+0xa0>
80103d24:	e8 37 04 00 00       	call   80104160 <myproc>
80103d29:	8b 40 24             	mov    0x24(%eax),%eax
80103d2c:	85 c0                	test   %eax,%eax
80103d2e:	74 c0                	je     80103cf0 <pipewrite+0x60>
        release(&p->lock);
80103d30:	83 ec 0c             	sub    $0xc,%esp
80103d33:	53                   	push   %ebx
80103d34:	e8 f7 11 00 00       	call   80104f30 <release>
        return -1;
80103d39:	83 c4 10             	add    $0x10,%esp
80103d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d44:	5b                   	pop    %ebx
80103d45:	5e                   	pop    %esi
80103d46:	5f                   	pop    %edi
80103d47:	5d                   	pop    %ebp
80103d48:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103d49:	89 c2                	mov    %eax,%edx
80103d4b:	90                   	nop
80103d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d50:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d53:	8d 42 01             	lea    0x1(%edx),%eax
80103d56:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d5c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103d62:	83 c6 01             	add    $0x1,%esi
80103d65:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103d69:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d6c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d6f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d73:	0f 85 4f ff ff ff    	jne    80103cc8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d79:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d7f:	83 ec 0c             	sub    $0xc,%esp
80103d82:	50                   	push   %eax
80103d83:	e8 a8 0c 00 00       	call   80104a30 <wakeup>
  release(&p->lock);
80103d88:	89 1c 24             	mov    %ebx,(%esp)
80103d8b:	e8 a0 11 00 00       	call   80104f30 <release>
  return n;
80103d90:	83 c4 10             	add    $0x10,%esp
80103d93:	8b 45 10             	mov    0x10(%ebp),%eax
80103d96:	eb a9                	jmp    80103d41 <pipewrite+0xb1>
80103d98:	90                   	nop
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 18             	sub    $0x18,%esp
80103da9:	8b 75 08             	mov    0x8(%ebp),%esi
80103dac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103daf:	56                   	push   %esi
80103db0:	e8 bb 10 00 00       	call   80104e70 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103db5:	83 c4 10             	add    $0x10,%esp
80103db8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103dbe:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103dc4:	75 6a                	jne    80103e30 <piperead+0x90>
80103dc6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103dcc:	85 db                	test   %ebx,%ebx
80103dce:	0f 84 c4 00 00 00    	je     80103e98 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103dd4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103dda:	eb 2d                	jmp    80103e09 <piperead+0x69>
80103ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de0:	83 ec 08             	sub    $0x8,%esp
80103de3:	56                   	push   %esi
80103de4:	53                   	push   %ebx
80103de5:	e8 56 0a 00 00       	call   80104840 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103dea:	83 c4 10             	add    $0x10,%esp
80103ded:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103df3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103df9:	75 35                	jne    80103e30 <piperead+0x90>
80103dfb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103e01:	85 d2                	test   %edx,%edx
80103e03:	0f 84 8f 00 00 00    	je     80103e98 <piperead+0xf8>
    if(myproc()->killed){
80103e09:	e8 52 03 00 00       	call   80104160 <myproc>
80103e0e:	8b 48 24             	mov    0x24(%eax),%ecx
80103e11:	85 c9                	test   %ecx,%ecx
80103e13:	74 cb                	je     80103de0 <piperead+0x40>
      release(&p->lock);
80103e15:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103e18:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103e1d:	56                   	push   %esi
80103e1e:	e8 0d 11 00 00       	call   80104f30 <release>
      return -1;
80103e23:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e29:	89 d8                	mov    %ebx,%eax
80103e2b:	5b                   	pop    %ebx
80103e2c:	5e                   	pop    %esi
80103e2d:	5f                   	pop    %edi
80103e2e:	5d                   	pop    %ebp
80103e2f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e30:	8b 45 10             	mov    0x10(%ebp),%eax
80103e33:	85 c0                	test   %eax,%eax
80103e35:	7e 61                	jle    80103e98 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103e37:	31 db                	xor    %ebx,%ebx
80103e39:	eb 13                	jmp    80103e4e <piperead+0xae>
80103e3b:	90                   	nop
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103e46:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103e4c:	74 1f                	je     80103e6d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103e4e:	8d 41 01             	lea    0x1(%ecx),%eax
80103e51:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103e57:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103e5d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103e62:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e65:	83 c3 01             	add    $0x1,%ebx
80103e68:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e6b:	75 d3                	jne    80103e40 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e6d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e73:	83 ec 0c             	sub    $0xc,%esp
80103e76:	50                   	push   %eax
80103e77:	e8 b4 0b 00 00       	call   80104a30 <wakeup>
  release(&p->lock);
80103e7c:	89 34 24             	mov    %esi,(%esp)
80103e7f:	e8 ac 10 00 00       	call   80104f30 <release>
  return i;
80103e84:	83 c4 10             	add    $0x10,%esp
}
80103e87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e8a:	89 d8                	mov    %ebx,%eax
80103e8c:	5b                   	pop    %ebx
80103e8d:	5e                   	pop    %esi
80103e8e:	5f                   	pop    %edi
80103e8f:	5d                   	pop    %ebp
80103e90:	c3                   	ret    
80103e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e98:	31 db                	xor    %ebx,%ebx
80103e9a:	eb d1                	jmp    80103e6d <piperead+0xcd>
80103e9c:	66 90                	xchg   %ax,%ax
80103e9e:	66 90                	xchg   %ax,%ax

80103ea0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	57                   	push   %edi
80103ea4:	56                   	push   %esi
80103ea5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ea6:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
{
80103eab:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103eae:	68 60 6d 18 80       	push   $0x80186d60
80103eb3:	e8 b8 0f 00 00       	call   80104e70 <acquire>
80103eb8:	83 c4 10             	add    $0x10,%esp
80103ebb:	eb 15                	jmp    80103ed2 <allocproc+0x32>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec0:	81 c3 98 02 00 00    	add    $0x298,%ebx
80103ec6:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80103ecc:	0f 83 46 01 00 00    	jae    80104018 <allocproc+0x178>
    if(p->state == UNUSED)
80103ed2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ed5:	85 c0                	test   %eax,%eax
80103ed7:	75 e7                	jne    80103ec0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ed9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103ede:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103ee1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ee8:	8d 50 01             	lea    0x1(%eax),%edx
80103eeb:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103eee:	68 60 6d 18 80       	push   $0x80186d60
  p->pid = nextpid++;
80103ef3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103ef9:	e8 32 10 00 00       	call   80104f30 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103efe:	e8 1d ed ff ff       	call   80102c20 <kalloc>
80103f03:	83 c4 10             	add    $0x10,%esp
80103f06:	85 c0                	test   %eax,%eax
80103f08:	89 43 08             	mov    %eax,0x8(%ebx)
80103f0b:	0f 84 23 01 00 00    	je     80104034 <allocproc+0x194>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103f11:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103f17:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103f1a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103f1f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103f22:	c7 40 14 e1 61 10 80 	movl   $0x801061e1,0x14(%eax)
  p->context = (struct context*)sp;
80103f29:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103f2c:	6a 14                	push   $0x14
80103f2e:	6a 00                	push   $0x0
80103f30:	50                   	push   %eax
80103f31:	e8 4a 10 00 00       	call   80104f80 <memset>
  p->context->eip = (uint)forkret;
80103f36:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80103f39:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103f3c:	c7 40 10 50 40 10 80 	movl   $0x80104050,0x10(%eax)
  if(p->pid > 2) {
80103f43:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103f47:	7f 0f                	jg     80103f58 <allocproc+0xb8>
    }
  }


  return p;
}
80103f49:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f4c:	89 d8                	mov    %ebx,%eax
80103f4e:	5b                   	pop    %ebx
80103f4f:	5e                   	pop    %esi
80103f50:	5f                   	pop    %edi
80103f51:	5d                   	pop    %ebp
80103f52:	c3                   	ret    
80103f53:	90                   	nop
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(createSwapFile(p) != 0)
80103f58:	83 ec 0c             	sub    $0xc,%esp
80103f5b:	53                   	push   %ebx
80103f5c:	e8 ef e4 ff ff       	call   80102450 <createSwapFile>
80103f61:	83 c4 10             	add    $0x10,%esp
80103f64:	85 c0                	test   %eax,%eax
80103f66:	0f 85 d6 00 00 00    	jne    80104042 <allocproc+0x1a2>
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103f6c:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
80103f72:	83 ec 04             	sub    $0x4,%esp
    p->num_ram = 0;
80103f75:	c7 83 88 02 00 00 00 	movl   $0x0,0x288(%ebx)
80103f7c:	00 00 00 
    p->num_swap = 0;
80103f7f:	c7 83 8c 02 00 00 00 	movl   $0x0,0x28c(%ebx)
80103f86:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103f89:	68 00 01 00 00       	push   $0x100
80103f8e:	6a 00                	push   $0x0
80103f90:	50                   	push   %eax
80103f91:	e8 ea 0f 00 00       	call   80104f80 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
80103f96:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80103f9c:	83 c4 0c             	add    $0xc,%esp
80103f9f:	68 00 01 00 00       	push   $0x100
80103fa4:	6a 00                	push   $0x0
80103fa6:	50                   	push   %eax
80103fa7:	e8 d4 0f 00 00       	call   80104f80 <memset>
    if(p->pid > 2)
80103fac:	83 c4 10             	add    $0x10,%esp
80103faf:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80103fb3:	7e 94                	jle    80103f49 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
80103fb5:	e8 66 ec ff ff       	call   80102c20 <kalloc>
80103fba:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
      p->free_head->prev = 0;
80103fc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = p->free_head;
80103fc7:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head->off = 0 * PGSIZE;
80103fcc:	8b 83 90 02 00 00    	mov    0x290(%ebx),%eax
80103fd2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80103fd8:	8b bb 90 02 00 00    	mov    0x290(%ebx),%edi
80103fde:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80103fe0:	e8 3b ec ff ff       	call   80102c20 <kalloc>
        curr->off = i * PGSIZE;
80103fe5:	89 30                	mov    %esi,(%eax)
80103fe7:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
80103fed:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80103ff0:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80103ff6:	89 47 04             	mov    %eax,0x4(%edi)
80103ff9:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80103ffb:	75 e3                	jne    80103fe0 <allocproc+0x140>
      p->free_tail = prev;
80103ffd:	89 83 94 02 00 00    	mov    %eax,0x294(%ebx)
      p->free_tail->next = 0;
80104003:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
8010400a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010400d:	89 d8                	mov    %ebx,%eax
8010400f:	5b                   	pop    %ebx
80104010:	5e                   	pop    %esi
80104011:	5f                   	pop    %edi
80104012:	5d                   	pop    %ebp
80104013:	c3                   	ret    
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104018:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010401b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010401d:	68 60 6d 18 80       	push   $0x80186d60
80104022:	e8 09 0f 00 00       	call   80104f30 <release>
  return 0;
80104027:	83 c4 10             	add    $0x10,%esp
}
8010402a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010402d:	89 d8                	mov    %ebx,%eax
8010402f:	5b                   	pop    %ebx
80104030:	5e                   	pop    %esi
80104031:	5f                   	pop    %edi
80104032:	5d                   	pop    %ebp
80104033:	c3                   	ret    
    p->state = UNUSED;
80104034:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010403b:	31 db                	xor    %ebx,%ebx
8010403d:	e9 07 ff ff ff       	jmp    80103f49 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
80104042:	83 ec 0c             	sub    $0xc,%esp
80104045:	68 35 89 10 80       	push   $0x80108935
8010404a:	e8 41 c3 ff ff       	call   80100390 <panic>
8010404f:	90                   	nop

80104050 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104056:	68 60 6d 18 80       	push   $0x80186d60
8010405b:	e8 d0 0e 00 00       	call   80104f30 <release>

  if (first) {
80104060:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	85 c0                	test   %eax,%eax
8010406a:	75 04                	jne    80104070 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010406c:	c9                   	leave  
8010406d:	c3                   	ret    
8010406e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80104070:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80104073:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
8010407a:	00 00 00 
    iinit(ROOTDEV);
8010407d:	6a 01                	push   $0x1
8010407f:	e8 9c d6 ff ff       	call   80101720 <iinit>
    initlog(ROOTDEV);
80104084:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010408b:	e8 10 f3 ff ff       	call   801033a0 <initlog>
80104090:	83 c4 10             	add    $0x10,%esp
}
80104093:	c9                   	leave  
80104094:	c3                   	ret    
80104095:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <pinit>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801040a6:	68 4f 89 10 80       	push   $0x8010894f
801040ab:	68 60 6d 18 80       	push   $0x80186d60
801040b0:	e8 7b 0c 00 00       	call   80104d30 <initlock>
}
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	c9                   	leave  
801040b9:	c3                   	ret    
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040c0 <mycpu>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801040c5:	9c                   	pushf  
801040c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801040c7:	f6 c4 02             	test   $0x2,%ah
801040ca:	75 5e                	jne    8010412a <mycpu+0x6a>
  apicid = lapicid();
801040cc:	e8 ff ee ff ff       	call   80102fd0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801040d1:	8b 35 40 6d 18 80    	mov    0x80186d40,%esi
801040d7:	85 f6                	test   %esi,%esi
801040d9:	7e 42                	jle    8010411d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801040db:	0f b6 15 c0 67 18 80 	movzbl 0x801867c0,%edx
801040e2:	39 d0                	cmp    %edx,%eax
801040e4:	74 30                	je     80104116 <mycpu+0x56>
801040e6:	b9 70 68 18 80       	mov    $0x80186870,%ecx
  for (i = 0; i < ncpu; ++i) {
801040eb:	31 d2                	xor    %edx,%edx
801040ed:	8d 76 00             	lea    0x0(%esi),%esi
801040f0:	83 c2 01             	add    $0x1,%edx
801040f3:	39 f2                	cmp    %esi,%edx
801040f5:	74 26                	je     8010411d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
801040f7:	0f b6 19             	movzbl (%ecx),%ebx
801040fa:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104100:	39 c3                	cmp    %eax,%ebx
80104102:	75 ec                	jne    801040f0 <mycpu+0x30>
80104104:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010410a:	05 c0 67 18 80       	add    $0x801867c0,%eax
}
8010410f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104112:	5b                   	pop    %ebx
80104113:	5e                   	pop    %esi
80104114:	5d                   	pop    %ebp
80104115:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104116:	b8 c0 67 18 80       	mov    $0x801867c0,%eax
      return &cpus[i];
8010411b:	eb f2                	jmp    8010410f <mycpu+0x4f>
  panic("unknown apicid\n");
8010411d:	83 ec 0c             	sub    $0xc,%esp
80104120:	68 56 89 10 80       	push   $0x80108956
80104125:	e8 66 c2 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 70 8a 10 80       	push   $0x80108a70
80104132:	e8 59 c2 ff ff       	call   80100390 <panic>
80104137:	89 f6                	mov    %esi,%esi
80104139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104140 <cpuid>:
cpuid() {
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104146:	e8 75 ff ff ff       	call   801040c0 <mycpu>
8010414b:	2d c0 67 18 80       	sub    $0x801867c0,%eax
}
80104150:	c9                   	leave  
  return mycpu()-cpus;
80104151:	c1 f8 04             	sar    $0x4,%eax
80104154:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010415a:	c3                   	ret    
8010415b:	90                   	nop
8010415c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104160 <myproc>:
myproc(void) {
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104167:	e8 34 0c 00 00       	call   80104da0 <pushcli>
  c = mycpu();
8010416c:	e8 4f ff ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104171:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104177:	e8 64 0c 00 00       	call   80104de0 <popcli>
}
8010417c:	83 c4 04             	add    $0x4,%esp
8010417f:	89 d8                	mov    %ebx,%eax
80104181:	5b                   	pop    %ebx
80104182:	5d                   	pop    %ebp
80104183:	c3                   	ret    
80104184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010418a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104190 <userinit>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104197:	e8 04 fd ff ff       	call   80103ea0 <allocproc>
8010419c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010419e:	a3 c0 c5 10 80       	mov    %eax,0x8010c5c0
  if((p->pgdir = setupkvm()) == 0)
801041a3:	e8 68 39 00 00       	call   80107b10 <setupkvm>
801041a8:	85 c0                	test   %eax,%eax
801041aa:	89 43 04             	mov    %eax,0x4(%ebx)
801041ad:	0f 84 bd 00 00 00    	je     80104270 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801041b3:	83 ec 04             	sub    $0x4,%esp
801041b6:	68 2c 00 00 00       	push   $0x2c
801041bb:	68 60 c4 10 80       	push   $0x8010c460
801041c0:	50                   	push   %eax
801041c1:	e8 8a 32 00 00       	call   80107450 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801041c6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801041c9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801041cf:	6a 4c                	push   $0x4c
801041d1:	6a 00                	push   $0x0
801041d3:	ff 73 18             	pushl  0x18(%ebx)
801041d6:	e8 a5 0d 00 00       	call   80104f80 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041db:	8b 43 18             	mov    0x18(%ebx),%eax
801041de:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041e3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801041e8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041eb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041ef:	8b 43 18             	mov    0x18(%ebx),%eax
801041f2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041f6:	8b 43 18             	mov    0x18(%ebx),%eax
801041f9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801041fd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104201:	8b 43 18             	mov    0x18(%ebx),%eax
80104204:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104208:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010420c:	8b 43 18             	mov    0x18(%ebx),%eax
8010420f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104216:	8b 43 18             	mov    0x18(%ebx),%eax
80104219:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104220:	8b 43 18             	mov    0x18(%ebx),%eax
80104223:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010422a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010422d:	6a 10                	push   $0x10
8010422f:	68 7f 89 10 80       	push   $0x8010897f
80104234:	50                   	push   %eax
80104235:	e8 26 0f 00 00       	call   80105160 <safestrcpy>
  p->cwd = namei("/");
8010423a:	c7 04 24 88 89 10 80 	movl   $0x80108988,(%esp)
80104241:	e8 3a df ff ff       	call   80102180 <namei>
80104246:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104249:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
80104250:	e8 1b 0c 00 00       	call   80104e70 <acquire>
  p->state = RUNNABLE;
80104255:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010425c:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
80104263:	e8 c8 0c 00 00       	call   80104f30 <release>
}
80104268:	83 c4 10             	add    $0x10,%esp
8010426b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010426e:	c9                   	leave  
8010426f:	c3                   	ret    
    panic("userinit: out of memory?");
80104270:	83 ec 0c             	sub    $0xc,%esp
80104273:	68 66 89 10 80       	push   $0x80108966
80104278:	e8 13 c1 ff ff       	call   80100390 <panic>
8010427d:	8d 76 00             	lea    0x0(%esi),%esi

80104280 <growproc>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
80104285:	83 ec 10             	sub    $0x10,%esp
80104288:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010428b:	e8 10 0b 00 00       	call   80104da0 <pushcli>
  c = mycpu();
80104290:	e8 2b fe ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104295:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010429b:	e8 40 0b 00 00       	call   80104de0 <popcli>
  if(n > 0){
801042a0:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801042a3:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801042a5:	7f 19                	jg     801042c0 <growproc+0x40>
  } else if(n < 0){
801042a7:	75 37                	jne    801042e0 <growproc+0x60>
  switchuvm(curproc);
801042a9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801042ac:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801042ae:	53                   	push   %ebx
801042af:	e8 8c 30 00 00       	call   80107340 <switchuvm>
  return 0;
801042b4:	83 c4 10             	add    $0x10,%esp
801042b7:	31 c0                	xor    %eax,%eax
}
801042b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042bc:	5b                   	pop    %ebx
801042bd:	5e                   	pop    %esi
801042be:	5d                   	pop    %ebp
801042bf:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801042c0:	83 ec 04             	sub    $0x4,%esp
801042c3:	01 c6                	add    %eax,%esi
801042c5:	56                   	push   %esi
801042c6:	50                   	push   %eax
801042c7:	ff 73 04             	pushl  0x4(%ebx)
801042ca:	e8 b1 34 00 00       	call   80107780 <allocuvm>
801042cf:	83 c4 10             	add    $0x10,%esp
801042d2:	85 c0                	test   %eax,%eax
801042d4:	75 d3                	jne    801042a9 <growproc+0x29>
      return -1;
801042d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042db:	eb dc                	jmp    801042b9 <growproc+0x39>
801042dd:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("growproc: n < 0\n");
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042e6:	68 8a 89 10 80       	push   $0x8010898a
801042eb:	e8 70 c3 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801042f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042f3:	83 c4 0c             	add    $0xc,%esp
801042f6:	01 c6                	add    %eax,%esi
801042f8:	56                   	push   %esi
801042f9:	50                   	push   %eax
801042fa:	ff 73 04             	pushl  0x4(%ebx)
801042fd:	e8 9e 32 00 00       	call   801075a0 <deallocuvm>
80104302:	83 c4 10             	add    $0x10,%esp
80104305:	85 c0                	test   %eax,%eax
80104307:	75 a0                	jne    801042a9 <growproc+0x29>
80104309:	eb cb                	jmp    801042d6 <growproc+0x56>
8010430b:	90                   	nop
8010430c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104310 <fork>:
{ 
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	57                   	push   %edi
80104314:	56                   	push   %esi
80104315:	53                   	push   %ebx
80104316:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104319:	e8 82 0a 00 00       	call   80104da0 <pushcli>
  c = mycpu();
8010431e:	e8 9d fd ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104323:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104329:	e8 b2 0a 00 00       	call   80104de0 <popcli>
  if((np = allocproc()) == 0){
8010432e:	e8 6d fb ff ff       	call   80103ea0 <allocproc>
80104333:	85 c0                	test   %eax,%eax
80104335:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104338:	0f 84 a8 01 00 00    	je     801044e6 <fork+0x1d6>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010433e:	83 ec 08             	sub    $0x8,%esp
80104341:	ff 33                	pushl  (%ebx)
80104343:	ff 73 04             	pushl  0x4(%ebx)
80104346:	e8 95 3d 00 00       	call   801080e0 <copyuvm>
8010434b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  if(np->pgdir == 0){
8010434e:	83 c4 10             	add    $0x10,%esp
80104351:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104353:	89 42 04             	mov    %eax,0x4(%edx)
  if(np->pgdir == 0){
80104356:	0f 84 94 01 00 00    	je     801044f0 <fork+0x1e0>
  np->sz = curproc->sz;
8010435c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
8010435e:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80104363:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80104366:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
80104369:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
8010436b:	8b 73 18             	mov    0x18(%ebx),%esi
8010436e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
80104370:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104374:	0f 8f 9e 00 00 00    	jg     80104418 <fork+0x108>
  np->tf->eax = 0;
8010437a:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
8010437d:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010437f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80104386:	8d 76 00             	lea    0x0(%esi),%esi
80104389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
80104390:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104394:	85 c0                	test   %eax,%eax
80104396:	74 16                	je     801043ae <fork+0x9e>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104398:	83 ec 0c             	sub    $0xc,%esp
8010439b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010439e:	50                   	push   %eax
8010439f:	e8 ec cc ff ff       	call   80101090 <filedup>
801043a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043a7:	83 c4 10             	add    $0x10,%esp
801043aa:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801043ae:	83 c6 01             	add    $0x1,%esi
801043b1:	83 fe 10             	cmp    $0x10,%esi
801043b4:	75 da                	jne    80104390 <fork+0x80>
  np->cwd = idup(curproc->cwd);
801043b6:	83 ec 0c             	sub    $0xc,%esp
801043b9:	ff 73 68             	pushl  0x68(%ebx)
801043bc:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043bf:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801043c2:	e8 29 d5 ff ff       	call   801018f0 <idup>
801043c7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043ca:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801043cd:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801043d0:	8d 42 6c             	lea    0x6c(%edx),%eax
801043d3:	6a 10                	push   $0x10
801043d5:	53                   	push   %ebx
801043d6:	50                   	push   %eax
801043d7:	e8 84 0d 00 00       	call   80105160 <safestrcpy>
  pid = np->pid;
801043dc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043df:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
801043e2:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
801043e9:	e8 82 0a 00 00       	call   80104e70 <acquire>
  np->state = RUNNABLE;
801043ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043f1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801043f8:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
801043ff:	e8 2c 0b 00 00       	call   80104f30 <release>
  return pid;
80104404:	83 c4 10             	add    $0x10,%esp
}
80104407:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010440a:	89 d8                	mov    %ebx,%eax
8010440c:	5b                   	pop    %ebx
8010440d:	5e                   	pop    %esi
8010440e:	5f                   	pop    %edi
8010440f:	5d                   	pop    %ebp
80104410:	c3                   	ret    
80104411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->ramPages[i].isused)
80104418:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
8010441e:	85 c0                	test   %eax,%eax
80104420:	74 1f                	je     80104441 <fork+0x131>
        np->ramPages[i].isused = 1;
80104422:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80104429:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010442c:	8b 83 90 01 00 00    	mov    0x190(%ebx),%eax
80104432:	89 82 90 01 00 00    	mov    %eax,0x190(%edx)
        np->ramPages[i].pgdir = np->pgdir;
80104438:	8b 42 04             	mov    0x4(%edx),%eax
8010443b:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
{ 
80104441:	31 f6                	xor    %esi,%esi
80104443:	eb 12                	jmp    80104457 <fork+0x147>
80104445:	8d 76 00             	lea    0x0(%esi),%esi
80104448:	83 c6 10             	add    $0x10,%esi
    for(i = 0; i < MAX_PSYC_PAGES; i++)
8010444b:	81 fe 00 01 00 00    	cmp    $0x100,%esi
80104451:	0f 84 23 ff ff ff    	je     8010437a <fork+0x6a>
      if(curproc->swappedPages[i].isused)
80104457:	8b 8c 33 8c 00 00 00 	mov    0x8c(%ebx,%esi,1),%ecx
8010445e:	85 c9                	test   %ecx,%ecx
80104460:	74 e6                	je     80104448 <fork+0x138>
      np->swappedPages[i].isused = 1;
80104462:	c7 84 32 8c 00 00 00 	movl   $0x1,0x8c(%edx,%esi,1)
80104469:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
8010446d:	8b 84 33 90 00 00 00 	mov    0x90(%ebx,%esi,1),%eax
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104474:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104477:	89 84 32 90 00 00 00 	mov    %eax,0x90(%edx,%esi,1)
      np->swappedPages[i].pgdir = np->pgdir;
8010447e:	8b 42 04             	mov    0x4(%edx),%eax
80104481:	89 84 32 88 00 00 00 	mov    %eax,0x88(%edx,%esi,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104488:	8b 84 33 94 00 00 00 	mov    0x94(%ebx,%esi,1),%eax
8010448f:	89 84 32 94 00 00 00 	mov    %eax,0x94(%edx,%esi,1)
      if(readFromSwapFile((void*)curproc, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
80104496:	68 00 10 00 00       	push   $0x1000
8010449b:	50                   	push   %eax
8010449c:	68 e0 c5 10 80       	push   $0x8010c5e0
801044a1:	53                   	push   %ebx
801044a2:	e8 79 e0 ff ff       	call   80102520 <readFromSwapFile>
801044a7:	83 c4 10             	add    $0x10,%esp
801044aa:	85 c0                	test   %eax,%eax
801044ac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044af:	78 68                	js     80104519 <fork+0x209>
      if(writeToSwapFile((void*)np, buffer, np->swappedPages[i].swap_offset, PGSIZE) < 0)
801044b1:	68 00 10 00 00       	push   $0x1000
801044b6:	ff b4 32 94 00 00 00 	pushl  0x94(%edx,%esi,1)
801044bd:	68 e0 c5 10 80       	push   $0x8010c5e0
801044c2:	52                   	push   %edx
801044c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801044c6:	e8 25 e0 ff ff       	call   801024f0 <writeToSwapFile>
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	85 c0                	test   %eax,%eax
801044d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801044d3:	0f 89 6f ff ff ff    	jns    80104448 <fork+0x138>
        panic("fork: writeToSwapFile");
801044d9:	83 ec 0c             	sub    $0xc,%esp
801044dc:	68 b2 89 10 80       	push   $0x801089b2
801044e1:	e8 aa be ff ff       	call   80100390 <panic>
    return -1;
801044e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801044eb:	e9 17 ff ff ff       	jmp    80104407 <fork+0xf7>
    kfree(np->kstack);
801044f0:	83 ec 0c             	sub    $0xc,%esp
801044f3:	ff 72 08             	pushl  0x8(%edx)
    return -1;
801044f6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
801044fb:	e8 40 e4 ff ff       	call   80102940 <kfree>
    np->kstack = 0;
80104500:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80104503:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104506:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
8010450d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80104514:	e9 ee fe ff ff       	jmp    80104407 <fork+0xf7>
        panic("fork: readFromSwapFile");
80104519:	83 ec 0c             	sub    $0xc,%esp
8010451c:	68 9b 89 10 80       	push   $0x8010899b
80104521:	e8 6a be ff ff       	call   80100390 <panic>
80104526:	8d 76 00             	lea    0x0(%esi),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <scheduler>:
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	53                   	push   %ebx
80104536:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104539:	e8 82 fb ff ff       	call   801040c0 <mycpu>
8010453e:	8d 78 04             	lea    0x4(%eax),%edi
80104541:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104543:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010454a:	00 00 00 
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104550:	fb                   	sti    
    acquire(&ptable.lock);
80104551:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104554:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
    acquire(&ptable.lock);
80104559:	68 60 6d 18 80       	push   $0x80186d60
8010455e:	e8 0d 09 00 00       	call   80104e70 <acquire>
80104563:	83 c4 10             	add    $0x10,%esp
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104570:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104574:	75 33                	jne    801045a9 <scheduler+0x79>
      switchuvm(p);
80104576:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104579:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010457f:	53                   	push   %ebx
80104580:	e8 bb 2d 00 00       	call   80107340 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104585:	58                   	pop    %eax
80104586:	5a                   	pop    %edx
80104587:	ff 73 1c             	pushl  0x1c(%ebx)
8010458a:	57                   	push   %edi
      p->state = RUNNING;
8010458b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104592:	e8 24 0c 00 00       	call   801051bb <swtch>
      switchkvm();
80104597:	e8 84 2d 00 00       	call   80107320 <switchkvm>
      c->proc = 0;
8010459c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801045a3:	00 00 00 
801045a6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045a9:	81 c3 98 02 00 00    	add    $0x298,%ebx
801045af:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
801045b5:	72 b9                	jb     80104570 <scheduler+0x40>
    release(&ptable.lock);
801045b7:	83 ec 0c             	sub    $0xc,%esp
801045ba:	68 60 6d 18 80       	push   $0x80186d60
801045bf:	e8 6c 09 00 00       	call   80104f30 <release>
    sti();
801045c4:	83 c4 10             	add    $0x10,%esp
801045c7:	eb 87                	jmp    80104550 <scheduler+0x20>
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801045d0 <sched>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
  pushcli();
801045d5:	e8 c6 07 00 00       	call   80104da0 <pushcli>
  c = mycpu();
801045da:	e8 e1 fa ff ff       	call   801040c0 <mycpu>
  p = c->proc;
801045df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e5:	e8 f6 07 00 00       	call   80104de0 <popcli>
  if(!holding(&ptable.lock))
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	68 60 6d 18 80       	push   $0x80186d60
801045f2:	e8 49 08 00 00       	call   80104e40 <holding>
801045f7:	83 c4 10             	add    $0x10,%esp
801045fa:	85 c0                	test   %eax,%eax
801045fc:	74 4f                	je     8010464d <sched+0x7d>
  if(mycpu()->ncli != 1)
801045fe:	e8 bd fa ff ff       	call   801040c0 <mycpu>
80104603:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010460a:	75 68                	jne    80104674 <sched+0xa4>
  if(p->state == RUNNING)
8010460c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104610:	74 55                	je     80104667 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104612:	9c                   	pushf  
80104613:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104614:	f6 c4 02             	test   $0x2,%ah
80104617:	75 41                	jne    8010465a <sched+0x8a>
  intena = mycpu()->intena;
80104619:	e8 a2 fa ff ff       	call   801040c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010461e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104621:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104627:	e8 94 fa ff ff       	call   801040c0 <mycpu>
8010462c:	83 ec 08             	sub    $0x8,%esp
8010462f:	ff 70 04             	pushl  0x4(%eax)
80104632:	53                   	push   %ebx
80104633:	e8 83 0b 00 00       	call   801051bb <swtch>
  mycpu()->intena = intena;
80104638:	e8 83 fa ff ff       	call   801040c0 <mycpu>
}
8010463d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104640:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104646:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104649:	5b                   	pop    %ebx
8010464a:	5e                   	pop    %esi
8010464b:	5d                   	pop    %ebp
8010464c:	c3                   	ret    
    panic("sched ptable.lock");
8010464d:	83 ec 0c             	sub    $0xc,%esp
80104650:	68 c8 89 10 80       	push   $0x801089c8
80104655:	e8 36 bd ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010465a:	83 ec 0c             	sub    $0xc,%esp
8010465d:	68 f4 89 10 80       	push   $0x801089f4
80104662:	e8 29 bd ff ff       	call   80100390 <panic>
    panic("sched running");
80104667:	83 ec 0c             	sub    $0xc,%esp
8010466a:	68 e6 89 10 80       	push   $0x801089e6
8010466f:	e8 1c bd ff ff       	call   80100390 <panic>
    panic("sched locks");
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	68 da 89 10 80       	push   $0x801089da
8010467c:	e8 0f bd ff ff       	call   80100390 <panic>
80104681:	eb 0d                	jmp    80104690 <exit>
80104683:	90                   	nop
80104684:	90                   	nop
80104685:	90                   	nop
80104686:	90                   	nop
80104687:	90                   	nop
80104688:	90                   	nop
80104689:	90                   	nop
8010468a:	90                   	nop
8010468b:	90                   	nop
8010468c:	90                   	nop
8010468d:	90                   	nop
8010468e:	90                   	nop
8010468f:	90                   	nop

80104690 <exit>:
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	57                   	push   %edi
80104694:	56                   	push   %esi
80104695:	53                   	push   %ebx
80104696:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104699:	e8 02 07 00 00       	call   80104da0 <pushcli>
  c = mycpu();
8010469e:	e8 1d fa ff ff       	call   801040c0 <mycpu>
  p = c->proc;
801046a3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046a9:	e8 32 07 00 00       	call   80104de0 <popcli>
  if(curproc == initproc)
801046ae:	39 1d c0 c5 10 80    	cmp    %ebx,0x8010c5c0
801046b4:	8d 73 28             	lea    0x28(%ebx),%esi
801046b7:	8d 7b 68             	lea    0x68(%ebx),%edi
801046ba:	0f 84 22 01 00 00    	je     801047e2 <exit+0x152>
    if(curproc->ofile[fd]){
801046c0:	8b 06                	mov    (%esi),%eax
801046c2:	85 c0                	test   %eax,%eax
801046c4:	74 12                	je     801046d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801046c6:	83 ec 0c             	sub    $0xc,%esp
801046c9:	50                   	push   %eax
801046ca:	e8 11 ca ff ff       	call   801010e0 <fileclose>
      curproc->ofile[fd] = 0;
801046cf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801046d5:	83 c4 10             	add    $0x10,%esp
801046d8:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
801046db:	39 fe                	cmp    %edi,%esi
801046dd:	75 e1                	jne    801046c0 <exit+0x30>
  begin_op();
801046df:	e8 5c ed ff ff       	call   80103440 <begin_op>
  iput(curproc->cwd);
801046e4:	83 ec 0c             	sub    $0xc,%esp
801046e7:	ff 73 68             	pushl  0x68(%ebx)
801046ea:	e8 61 d3 ff ff       	call   80101a50 <iput>
  end_op();
801046ef:	e8 bc ed ff ff       	call   801034b0 <end_op>
  if(curproc->pid > 2) {
801046f4:	83 c4 10             	add    $0x10,%esp
801046f7:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
801046fb:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
80104702:	0f 8f b9 00 00 00    	jg     801047c1 <exit+0x131>
  acquire(&ptable.lock);
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	68 60 6d 18 80       	push   $0x80186d60
80104710:	e8 5b 07 00 00       	call   80104e70 <acquire>
  wakeup1(curproc->parent);
80104715:	8b 53 14             	mov    0x14(%ebx),%edx
80104718:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010471b:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104720:	eb 12                	jmp    80104734 <exit+0xa4>
80104722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104728:	05 98 02 00 00       	add    $0x298,%eax
8010472d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104732:	73 1e                	jae    80104752 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104734:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104738:	75 ee                	jne    80104728 <exit+0x98>
8010473a:	3b 50 20             	cmp    0x20(%eax),%edx
8010473d:	75 e9                	jne    80104728 <exit+0x98>
      p->state = RUNNABLE;
8010473f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104746:	05 98 02 00 00       	add    $0x298,%eax
8010474b:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104750:	72 e2                	jb     80104734 <exit+0xa4>
      p->parent = initproc;
80104752:	8b 0d c0 c5 10 80    	mov    0x8010c5c0,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104758:	ba 94 6d 18 80       	mov    $0x80186d94,%edx
8010475d:	eb 0f                	jmp    8010476e <exit+0xde>
8010475f:	90                   	nop
80104760:	81 c2 98 02 00 00    	add    $0x298,%edx
80104766:	81 fa 94 13 19 80    	cmp    $0x80191394,%edx
8010476c:	73 3a                	jae    801047a8 <exit+0x118>
    if(p->parent == curproc){
8010476e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104771:	75 ed                	jne    80104760 <exit+0xd0>
      if(p->state == ZOMBIE)
80104773:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104777:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010477a:	75 e4                	jne    80104760 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010477c:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104781:	eb 11                	jmp    80104794 <exit+0x104>
80104783:	90                   	nop
80104784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104788:	05 98 02 00 00       	add    $0x298,%eax
8010478d:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104792:	73 cc                	jae    80104760 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104794:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104798:	75 ee                	jne    80104788 <exit+0xf8>
8010479a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010479d:	75 e9                	jne    80104788 <exit+0xf8>
      p->state = RUNNABLE;
8010479f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047a6:	eb e0                	jmp    80104788 <exit+0xf8>
  curproc->state = ZOMBIE;
801047a8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801047af:	e8 1c fe ff ff       	call   801045d0 <sched>
  panic("zombie exit");
801047b4:	83 ec 0c             	sub    $0xc,%esp
801047b7:	68 15 8a 10 80       	push   $0x80108a15
801047bc:	e8 cf bb ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	53                   	push   %ebx
801047c5:	e8 86 da ff ff       	call   80102250 <removeSwapFile>
801047ca:	83 c4 10             	add    $0x10,%esp
801047cd:	85 c0                	test   %eax,%eax
801047cf:	0f 84 33 ff ff ff    	je     80104708 <exit+0x78>
      panic("exit: error deleting swap file");
801047d5:	83 ec 0c             	sub    $0xc,%esp
801047d8:	68 98 8a 10 80       	push   $0x80108a98
801047dd:	e8 ae bb ff ff       	call   80100390 <panic>
    panic("init exiting");
801047e2:	83 ec 0c             	sub    $0xc,%esp
801047e5:	68 08 8a 10 80       	push   $0x80108a08
801047ea:	e8 a1 bb ff ff       	call   80100390 <panic>
801047ef:	90                   	nop

801047f0 <yield>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801047f7:	68 60 6d 18 80       	push   $0x80186d60
801047fc:	e8 6f 06 00 00       	call   80104e70 <acquire>
  pushcli();
80104801:	e8 9a 05 00 00       	call   80104da0 <pushcli>
  c = mycpu();
80104806:	e8 b5 f8 ff ff       	call   801040c0 <mycpu>
  p = c->proc;
8010480b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104811:	e8 ca 05 00 00       	call   80104de0 <popcli>
  myproc()->state = RUNNABLE;
80104816:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010481d:	e8 ae fd ff ff       	call   801045d0 <sched>
  release(&ptable.lock);
80104822:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
80104829:	e8 02 07 00 00       	call   80104f30 <release>
}
8010482e:	83 c4 10             	add    $0x10,%esp
80104831:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104834:	c9                   	leave  
80104835:	c3                   	ret    
80104836:	8d 76 00             	lea    0x0(%esi),%esi
80104839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104840 <sleep>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	57                   	push   %edi
80104844:	56                   	push   %esi
80104845:	53                   	push   %ebx
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	8b 7d 08             	mov    0x8(%ebp),%edi
8010484c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010484f:	e8 4c 05 00 00       	call   80104da0 <pushcli>
  c = mycpu();
80104854:	e8 67 f8 ff ff       	call   801040c0 <mycpu>
  p = c->proc;
80104859:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010485f:	e8 7c 05 00 00       	call   80104de0 <popcli>
  if(p == 0)
80104864:	85 db                	test   %ebx,%ebx
80104866:	0f 84 87 00 00 00    	je     801048f3 <sleep+0xb3>
  if(lk == 0)
8010486c:	85 f6                	test   %esi,%esi
8010486e:	74 76                	je     801048e6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104870:	81 fe 60 6d 18 80    	cmp    $0x80186d60,%esi
80104876:	74 50                	je     801048c8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104878:	83 ec 0c             	sub    $0xc,%esp
8010487b:	68 60 6d 18 80       	push   $0x80186d60
80104880:	e8 eb 05 00 00       	call   80104e70 <acquire>
    release(lk);
80104885:	89 34 24             	mov    %esi,(%esp)
80104888:	e8 a3 06 00 00       	call   80104f30 <release>
  p->chan = chan;
8010488d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104890:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104897:	e8 34 fd ff ff       	call   801045d0 <sched>
  p->chan = 0;
8010489c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801048a3:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
801048aa:	e8 81 06 00 00       	call   80104f30 <release>
    acquire(lk);
801048af:	89 75 08             	mov    %esi,0x8(%ebp)
801048b2:	83 c4 10             	add    $0x10,%esp
}
801048b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048b8:	5b                   	pop    %ebx
801048b9:	5e                   	pop    %esi
801048ba:	5f                   	pop    %edi
801048bb:	5d                   	pop    %ebp
    acquire(lk);
801048bc:	e9 af 05 00 00       	jmp    80104e70 <acquire>
801048c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801048c8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801048cb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801048d2:	e8 f9 fc ff ff       	call   801045d0 <sched>
  p->chan = 0;
801048d7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801048de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048e1:	5b                   	pop    %ebx
801048e2:	5e                   	pop    %esi
801048e3:	5f                   	pop    %edi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
    panic("sleep without lk");
801048e6:	83 ec 0c             	sub    $0xc,%esp
801048e9:	68 27 8a 10 80       	push   $0x80108a27
801048ee:	e8 9d ba ff ff       	call   80100390 <panic>
    panic("sleep");
801048f3:	83 ec 0c             	sub    $0xc,%esp
801048f6:	68 21 8a 10 80       	push   $0x80108a21
801048fb:	e8 90 ba ff ff       	call   80100390 <panic>

80104900 <wait>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	56                   	push   %esi
80104904:	53                   	push   %ebx
  pushcli();
80104905:	e8 96 04 00 00       	call   80104da0 <pushcli>
  c = mycpu();
8010490a:	e8 b1 f7 ff ff       	call   801040c0 <mycpu>
  p = c->proc;
8010490f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104915:	e8 c6 04 00 00       	call   80104de0 <popcli>
  acquire(&ptable.lock);
8010491a:	83 ec 0c             	sub    $0xc,%esp
8010491d:	68 60 6d 18 80       	push   $0x80186d60
80104922:	e8 49 05 00 00       	call   80104e70 <acquire>
80104927:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010492a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010492c:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
80104931:	eb 13                	jmp    80104946 <wait+0x46>
80104933:	90                   	nop
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104938:	81 c3 98 02 00 00    	add    $0x298,%ebx
8010493e:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104944:	73 1e                	jae    80104964 <wait+0x64>
      if(p->parent != curproc)
80104946:	39 73 14             	cmp    %esi,0x14(%ebx)
80104949:	75 ed                	jne    80104938 <wait+0x38>
      if(p->state == ZOMBIE){
8010494b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010494f:	74 3f                	je     80104990 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104951:	81 c3 98 02 00 00    	add    $0x298,%ebx
      havekids = 1;
80104957:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010495c:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104962:	72 e2                	jb     80104946 <wait+0x46>
    if(!havekids || curproc->killed){
80104964:	85 c0                	test   %eax,%eax
80104966:	0f 84 a6 00 00 00    	je     80104a12 <wait+0x112>
8010496c:	8b 46 24             	mov    0x24(%esi),%eax
8010496f:	85 c0                	test   %eax,%eax
80104971:	0f 85 9b 00 00 00    	jne    80104a12 <wait+0x112>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104977:	83 ec 08             	sub    $0x8,%esp
8010497a:	68 60 6d 18 80       	push   $0x80186d60
8010497f:	56                   	push   %esi
80104980:	e8 bb fe ff ff       	call   80104840 <sleep>
    havekids = 0;
80104985:	83 c4 10             	add    $0x10,%esp
80104988:	eb a0                	jmp    8010492a <wait+0x2a>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104990:	83 ec 0c             	sub    $0xc,%esp
80104993:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104996:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104999:	e8 a2 df ff ff       	call   80102940 <kfree>
        freevm(p->pgdir); // panic: kfree
8010499e:	5a                   	pop    %edx
8010499f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801049a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
801049a9:	e8 e2 30 00 00       	call   80107a90 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
801049ae:	8d 83 88 01 00 00    	lea    0x188(%ebx),%eax
801049b4:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
801049b7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
801049be:	68 00 01 00 00       	push   $0x100
801049c3:	6a 00                	push   $0x0
801049c5:	50                   	push   %eax
        p->parent = 0;
801049c6:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801049cd:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801049d1:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
801049d8:	e8 a3 05 00 00       	call   80104f80 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
801049dd:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801049e3:	83 c4 0c             	add    $0xc,%esp
801049e6:	68 00 01 00 00       	push   $0x100
801049eb:	6a 00                	push   $0x0
801049ed:	50                   	push   %eax
801049ee:	e8 8d 05 00 00       	call   80104f80 <memset>
        release(&ptable.lock);
801049f3:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
        p->state = UNUSED;
801049fa:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104a01:	e8 2a 05 00 00       	call   80104f30 <release>
        return pid;
80104a06:	83 c4 10             	add    $0x10,%esp
}
80104a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a0c:	89 f0                	mov    %esi,%eax
80104a0e:	5b                   	pop    %ebx
80104a0f:	5e                   	pop    %esi
80104a10:	5d                   	pop    %ebp
80104a11:	c3                   	ret    
      release(&ptable.lock);
80104a12:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104a15:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104a1a:	68 60 6d 18 80       	push   $0x80186d60
80104a1f:	e8 0c 05 00 00       	call   80104f30 <release>
      return -1;
80104a24:	83 c4 10             	add    $0x10,%esp
80104a27:	eb e0                	jmp    80104a09 <wait+0x109>
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104a30 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 10             	sub    $0x10,%esp
80104a37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104a3a:	68 60 6d 18 80       	push   $0x80186d60
80104a3f:	e8 2c 04 00 00       	call   80104e70 <acquire>
80104a44:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a47:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104a4c:	eb 0e                	jmp    80104a5c <wakeup+0x2c>
80104a4e:	66 90                	xchg   %ax,%ax
80104a50:	05 98 02 00 00       	add    $0x298,%eax
80104a55:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104a5a:	73 1e                	jae    80104a7a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104a5c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a60:	75 ee                	jne    80104a50 <wakeup+0x20>
80104a62:	3b 58 20             	cmp    0x20(%eax),%ebx
80104a65:	75 e9                	jne    80104a50 <wakeup+0x20>
      p->state = RUNNABLE;
80104a67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6e:	05 98 02 00 00       	add    $0x298,%eax
80104a73:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104a78:	72 e2                	jb     80104a5c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104a7a:	c7 45 08 60 6d 18 80 	movl   $0x80186d60,0x8(%ebp)
}
80104a81:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a84:	c9                   	leave  
  release(&ptable.lock);
80104a85:	e9 a6 04 00 00       	jmp    80104f30 <release>
80104a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a90 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 10             	sub    $0x10,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104a9a:	68 60 6d 18 80       	push   $0x80186d60
80104a9f:	e8 cc 03 00 00       	call   80104e70 <acquire>
80104aa4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104aa7:	b8 94 6d 18 80       	mov    $0x80186d94,%eax
80104aac:	eb 0e                	jmp    80104abc <kill+0x2c>
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	05 98 02 00 00       	add    $0x298,%eax
80104ab5:	3d 94 13 19 80       	cmp    $0x80191394,%eax
80104aba:	73 34                	jae    80104af0 <kill+0x60>
    if(p->pid == pid){
80104abc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104abf:	75 ef                	jne    80104ab0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104ac1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104ac5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104acc:	75 07                	jne    80104ad5 <kill+0x45>
        p->state = RUNNABLE;
80104ace:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104ad5:	83 ec 0c             	sub    $0xc,%esp
80104ad8:	68 60 6d 18 80       	push   $0x80186d60
80104add:	e8 4e 04 00 00       	call   80104f30 <release>
      return 0;
80104ae2:	83 c4 10             	add    $0x10,%esp
80104ae5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aea:	c9                   	leave  
80104aeb:	c3                   	ret    
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104af0:	83 ec 0c             	sub    $0xc,%esp
80104af3:	68 60 6d 18 80       	push   $0x80186d60
80104af8:	e8 33 04 00 00       	call   80104f30 <release>
  return -1;
80104afd:	83 c4 10             	add    $0x10,%esp
80104b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b08:	c9                   	leave  
80104b09:	c3                   	ret    
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
80104b15:	53                   	push   %ebx
80104b16:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b19:	bb 94 6d 18 80       	mov    $0x80186d94,%ebx
{
80104b1e:	83 ec 3c             	sub    $0x3c,%esp
80104b21:	eb 27                	jmp    80104b4a <procdump+0x3a>
80104b23:	90                   	nop
80104b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b28:	83 ec 0c             	sub    $0xc,%esp
80104b2b:	68 1a 8e 10 80       	push   $0x80108e1a
80104b30:	e8 2b bb ff ff       	call   80100660 <cprintf>
80104b35:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b38:	81 c3 98 02 00 00    	add    $0x298,%ebx
80104b3e:	81 fb 94 13 19 80    	cmp    $0x80191394,%ebx
80104b44:	0f 83 86 00 00 00    	jae    80104bd0 <procdump+0xc0>
    if(p->state == UNUSED)
80104b4a:	8b 43 0c             	mov    0xc(%ebx),%eax
80104b4d:	85 c0                	test   %eax,%eax
80104b4f:	74 e7                	je     80104b38 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b51:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104b54:	ba 38 8a 10 80       	mov    $0x80108a38,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104b59:	77 11                	ja     80104b6c <procdump+0x5c>
80104b5b:	8b 14 85 b8 8a 10 80 	mov    -0x7fef7548(,%eax,4),%edx
      state = "???";
80104b62:	b8 38 8a 10 80       	mov    $0x80108a38,%eax
80104b67:	85 d2                	test   %edx,%edx
80104b69:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104b6c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104b6f:	50                   	push   %eax
80104b70:	52                   	push   %edx
80104b71:	ff 73 10             	pushl  0x10(%ebx)
80104b74:	68 3c 8a 10 80       	push   $0x80108a3c
80104b79:	e8 e2 ba ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104b7e:	83 c4 10             	add    $0x10,%esp
80104b81:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104b85:	75 a1                	jne    80104b28 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b87:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104b8a:	83 ec 08             	sub    $0x8,%esp
80104b8d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104b90:	50                   	push   %eax
80104b91:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104b94:	8b 40 0c             	mov    0xc(%eax),%eax
80104b97:	83 c0 08             	add    $0x8,%eax
80104b9a:	50                   	push   %eax
80104b9b:	e8 b0 01 00 00       	call   80104d50 <getcallerpcs>
80104ba0:	83 c4 10             	add    $0x10,%esp
80104ba3:	90                   	nop
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104ba8:	8b 17                	mov    (%edi),%edx
80104baa:	85 d2                	test   %edx,%edx
80104bac:	0f 84 76 ff ff ff    	je     80104b28 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104bb2:	83 ec 08             	sub    $0x8,%esp
80104bb5:	83 c7 04             	add    $0x4,%edi
80104bb8:	52                   	push   %edx
80104bb9:	68 a1 83 10 80       	push   $0x801083a1
80104bbe:	e8 9d ba ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104bc3:	83 c4 10             	add    $0x10,%esp
80104bc6:	39 fe                	cmp    %edi,%esi
80104bc8:	75 de                	jne    80104ba8 <procdump+0x98>
80104bca:	e9 59 ff ff ff       	jmp    80104b28 <procdump+0x18>
80104bcf:	90                   	nop
  }
}
80104bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104bd3:	5b                   	pop    %ebx
80104bd4:	5e                   	pop    %esi
80104bd5:	5f                   	pop    %edi
80104bd6:	5d                   	pop    %ebp
80104bd7:	c3                   	ret    
80104bd8:	90                   	nop
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104be0 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  int sum = 0;
  int pcount = 0;
  acquire(&ptable.lock);
80104be6:	68 60 6d 18 80       	push   $0x80186d60
80104beb:	e8 80 02 00 00       	call   80104e70 <acquire>
    if(p->state == UNUSED)
      continue;
    // sum += MAX_PSYC_PAGES - p->nummemorypages;
    pcount++;
  }
  release(&ptable.lock);
80104bf0:	c7 04 24 60 6d 18 80 	movl   $0x80186d60,(%esp)
80104bf7:	e8 34 03 00 00       	call   80104f30 <release>
  return sum;
80104bfc:	31 c0                	xor    %eax,%eax
80104bfe:	c9                   	leave  
80104bff:	c3                   	ret    

80104c00 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 0c             	sub    $0xc,%esp
80104c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104c0a:	68 d0 8a 10 80       	push   $0x80108ad0
80104c0f:	8d 43 04             	lea    0x4(%ebx),%eax
80104c12:	50                   	push   %eax
80104c13:	e8 18 01 00 00       	call   80104d30 <initlock>
  lk->name = name;
80104c18:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104c1b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104c21:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104c24:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104c2b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104c2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c31:	c9                   	leave  
80104c32:	c3                   	ret    
80104c33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c40 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	56                   	push   %esi
80104c44:	53                   	push   %ebx
80104c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c48:	83 ec 0c             	sub    $0xc,%esp
80104c4b:	8d 73 04             	lea    0x4(%ebx),%esi
80104c4e:	56                   	push   %esi
80104c4f:	e8 1c 02 00 00       	call   80104e70 <acquire>
  while (lk->locked) {
80104c54:	8b 13                	mov    (%ebx),%edx
80104c56:	83 c4 10             	add    $0x10,%esp
80104c59:	85 d2                	test   %edx,%edx
80104c5b:	74 16                	je     80104c73 <acquiresleep+0x33>
80104c5d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104c60:	83 ec 08             	sub    $0x8,%esp
80104c63:	56                   	push   %esi
80104c64:	53                   	push   %ebx
80104c65:	e8 d6 fb ff ff       	call   80104840 <sleep>
  while (lk->locked) {
80104c6a:	8b 03                	mov    (%ebx),%eax
80104c6c:	83 c4 10             	add    $0x10,%esp
80104c6f:	85 c0                	test   %eax,%eax
80104c71:	75 ed                	jne    80104c60 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104c73:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c79:	e8 e2 f4 ff ff       	call   80104160 <myproc>
80104c7e:	8b 40 10             	mov    0x10(%eax),%eax
80104c81:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c84:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c8a:	5b                   	pop    %ebx
80104c8b:	5e                   	pop    %esi
80104c8c:	5d                   	pop    %ebp
  release(&lk->lk);
80104c8d:	e9 9e 02 00 00       	jmp    80104f30 <release>
80104c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	56                   	push   %esi
80104ca4:	53                   	push   %ebx
80104ca5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ca8:	83 ec 0c             	sub    $0xc,%esp
80104cab:	8d 73 04             	lea    0x4(%ebx),%esi
80104cae:	56                   	push   %esi
80104caf:	e8 bc 01 00 00       	call   80104e70 <acquire>
  lk->locked = 0;
80104cb4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104cba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104cc1:	89 1c 24             	mov    %ebx,(%esp)
80104cc4:	e8 67 fd ff ff       	call   80104a30 <wakeup>
  release(&lk->lk);
80104cc9:	89 75 08             	mov    %esi,0x8(%ebp)
80104ccc:	83 c4 10             	add    $0x10,%esp
}
80104ccf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cd2:	5b                   	pop    %ebx
80104cd3:	5e                   	pop    %esi
80104cd4:	5d                   	pop    %ebp
  release(&lk->lk);
80104cd5:	e9 56 02 00 00       	jmp    80104f30 <release>
80104cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ce0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	53                   	push   %ebx
80104ce6:	31 ff                	xor    %edi,%edi
80104ce8:	83 ec 18             	sub    $0x18,%esp
80104ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104cee:	8d 73 04             	lea    0x4(%ebx),%esi
80104cf1:	56                   	push   %esi
80104cf2:	e8 79 01 00 00       	call   80104e70 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104cf7:	8b 03                	mov    (%ebx),%eax
80104cf9:	83 c4 10             	add    $0x10,%esp
80104cfc:	85 c0                	test   %eax,%eax
80104cfe:	74 13                	je     80104d13 <holdingsleep+0x33>
80104d00:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104d03:	e8 58 f4 ff ff       	call   80104160 <myproc>
80104d08:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d0b:	0f 94 c0             	sete   %al
80104d0e:	0f b6 c0             	movzbl %al,%eax
80104d11:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104d13:	83 ec 0c             	sub    $0xc,%esp
80104d16:	56                   	push   %esi
80104d17:	e8 14 02 00 00       	call   80104f30 <release>
  return r;
}
80104d1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d1f:	89 f8                	mov    %edi,%eax
80104d21:	5b                   	pop    %ebx
80104d22:	5e                   	pop    %esi
80104d23:	5f                   	pop    %edi
80104d24:	5d                   	pop    %ebp
80104d25:	c3                   	ret    
80104d26:	66 90                	xchg   %ax,%ax
80104d28:	66 90                	xchg   %ax,%ax
80104d2a:	66 90                	xchg   %ax,%ax
80104d2c:	66 90                	xchg   %ax,%ax
80104d2e:	66 90                	xchg   %ax,%ax

80104d30 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104d36:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104d39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104d3f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104d49:	5d                   	pop    %ebp
80104d4a:	c3                   	ret    
80104d4b:	90                   	nop
80104d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104d50 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104d50:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104d51:	31 d2                	xor    %edx,%edx
{
80104d53:	89 e5                	mov    %esp,%ebp
80104d55:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104d56:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d5c:	83 e8 08             	sub    $0x8,%eax
80104d5f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d60:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d66:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d6c:	77 1a                	ja     80104d88 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d6e:	8b 58 04             	mov    0x4(%eax),%ebx
80104d71:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d74:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d77:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d79:	83 fa 0a             	cmp    $0xa,%edx
80104d7c:	75 e2                	jne    80104d60 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d7e:	5b                   	pop    %ebx
80104d7f:	5d                   	pop    %ebp
80104d80:	c3                   	ret    
80104d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d88:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d8b:	83 c1 28             	add    $0x28,%ecx
80104d8e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104d90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d96:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104d99:	39 c1                	cmp    %eax,%ecx
80104d9b:	75 f3                	jne    80104d90 <getcallerpcs+0x40>
}
80104d9d:	5b                   	pop    %ebx
80104d9e:	5d                   	pop    %ebp
80104d9f:	c3                   	ret    

80104da0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 04             	sub    $0x4,%esp
80104da7:	9c                   	pushf  
80104da8:	5b                   	pop    %ebx
  asm volatile("cli");
80104da9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104daa:	e8 11 f3 ff ff       	call   801040c0 <mycpu>
80104daf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104db5:	85 c0                	test   %eax,%eax
80104db7:	75 11                	jne    80104dca <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104db9:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104dbf:	e8 fc f2 ff ff       	call   801040c0 <mycpu>
80104dc4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104dca:	e8 f1 f2 ff ff       	call   801040c0 <mycpu>
80104dcf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104dd6:	83 c4 04             	add    $0x4,%esp
80104dd9:	5b                   	pop    %ebx
80104dda:	5d                   	pop    %ebp
80104ddb:	c3                   	ret    
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104de0 <popcli>:

void
popcli(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104de6:	9c                   	pushf  
80104de7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104de8:	f6 c4 02             	test   $0x2,%ah
80104deb:	75 35                	jne    80104e22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104ded:	e8 ce f2 ff ff       	call   801040c0 <mycpu>
80104df2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104df9:	78 34                	js     80104e2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dfb:	e8 c0 f2 ff ff       	call   801040c0 <mycpu>
80104e00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104e06:	85 d2                	test   %edx,%edx
80104e08:	74 06                	je     80104e10 <popcli+0x30>
    sti();
}
80104e0a:	c9                   	leave  
80104e0b:	c3                   	ret    
80104e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104e10:	e8 ab f2 ff ff       	call   801040c0 <mycpu>
80104e15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104e1b:	85 c0                	test   %eax,%eax
80104e1d:	74 eb                	je     80104e0a <popcli+0x2a>
  asm volatile("sti");
80104e1f:	fb                   	sti    
}
80104e20:	c9                   	leave  
80104e21:	c3                   	ret    
    panic("popcli - interruptible");
80104e22:	83 ec 0c             	sub    $0xc,%esp
80104e25:	68 db 8a 10 80       	push   $0x80108adb
80104e2a:	e8 61 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104e2f:	83 ec 0c             	sub    $0xc,%esp
80104e32:	68 f2 8a 10 80       	push   $0x80108af2
80104e37:	e8 54 b5 ff ff       	call   80100390 <panic>
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e40 <holding>:
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	56                   	push   %esi
80104e44:	53                   	push   %ebx
80104e45:	8b 75 08             	mov    0x8(%ebp),%esi
80104e48:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e4a:	e8 51 ff ff ff       	call   80104da0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e4f:	8b 06                	mov    (%esi),%eax
80104e51:	85 c0                	test   %eax,%eax
80104e53:	74 10                	je     80104e65 <holding+0x25>
80104e55:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e58:	e8 63 f2 ff ff       	call   801040c0 <mycpu>
80104e5d:	39 c3                	cmp    %eax,%ebx
80104e5f:	0f 94 c3             	sete   %bl
80104e62:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104e65:	e8 76 ff ff ff       	call   80104de0 <popcli>
}
80104e6a:	89 d8                	mov    %ebx,%eax
80104e6c:	5b                   	pop    %ebx
80104e6d:	5e                   	pop    %esi
80104e6e:	5d                   	pop    %ebp
80104e6f:	c3                   	ret    

80104e70 <acquire>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	56                   	push   %esi
80104e74:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e75:	e8 26 ff ff ff       	call   80104da0 <pushcli>
  if(holding(lk))
80104e7a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e7d:	83 ec 0c             	sub    $0xc,%esp
80104e80:	53                   	push   %ebx
80104e81:	e8 ba ff ff ff       	call   80104e40 <holding>
80104e86:	83 c4 10             	add    $0x10,%esp
80104e89:	85 c0                	test   %eax,%eax
80104e8b:	0f 85 83 00 00 00    	jne    80104f14 <acquire+0xa4>
80104e91:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e93:	ba 01 00 00 00       	mov    $0x1,%edx
80104e98:	eb 09                	jmp    80104ea3 <acquire+0x33>
80104e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ea0:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ea3:	89 d0                	mov    %edx,%eax
80104ea5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104ea8:	85 c0                	test   %eax,%eax
80104eaa:	75 f4                	jne    80104ea0 <acquire+0x30>
  __sync_synchronize();
80104eac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104eb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104eb4:	e8 07 f2 ff ff       	call   801040c0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104eb9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104ebc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104ebf:	89 e8                	mov    %ebp,%eax
80104ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ec8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104ece:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104ed4:	77 1a                	ja     80104ef0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104ed6:	8b 48 04             	mov    0x4(%eax),%ecx
80104ed9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104edc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104edf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ee1:	83 fe 0a             	cmp    $0xa,%esi
80104ee4:	75 e2                	jne    80104ec8 <acquire+0x58>
}
80104ee6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee9:	5b                   	pop    %ebx
80104eea:	5e                   	pop    %esi
80104eeb:	5d                   	pop    %ebp
80104eec:	c3                   	ret    
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
80104ef0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104ef3:	83 c2 28             	add    $0x28,%edx
80104ef6:	8d 76 00             	lea    0x0(%esi),%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104f00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104f06:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104f09:	39 d0                	cmp    %edx,%eax
80104f0b:	75 f3                	jne    80104f00 <acquire+0x90>
}
80104f0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f10:	5b                   	pop    %ebx
80104f11:	5e                   	pop    %esi
80104f12:	5d                   	pop    %ebp
80104f13:	c3                   	ret    
    panic("acquire");
80104f14:	83 ec 0c             	sub    $0xc,%esp
80104f17:	68 f9 8a 10 80       	push   $0x80108af9
80104f1c:	e8 6f b4 ff ff       	call   80100390 <panic>
80104f21:	eb 0d                	jmp    80104f30 <release>
80104f23:	90                   	nop
80104f24:	90                   	nop
80104f25:	90                   	nop
80104f26:	90                   	nop
80104f27:	90                   	nop
80104f28:	90                   	nop
80104f29:	90                   	nop
80104f2a:	90                   	nop
80104f2b:	90                   	nop
80104f2c:	90                   	nop
80104f2d:	90                   	nop
80104f2e:	90                   	nop
80104f2f:	90                   	nop

80104f30 <release>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	53                   	push   %ebx
80104f34:	83 ec 10             	sub    $0x10,%esp
80104f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f3a:	53                   	push   %ebx
80104f3b:	e8 00 ff ff ff       	call   80104e40 <holding>
80104f40:	83 c4 10             	add    $0x10,%esp
80104f43:	85 c0                	test   %eax,%eax
80104f45:	74 22                	je     80104f69 <release+0x39>
  lk->pcs[0] = 0;
80104f47:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f4e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f55:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f5a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f63:	c9                   	leave  
  popcli();
80104f64:	e9 77 fe ff ff       	jmp    80104de0 <popcli>
    panic("release");
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	68 01 8b 10 80       	push   $0x80108b01
80104f71:	e8 1a b4 ff ff       	call   80100390 <panic>
80104f76:	66 90                	xchg   %ax,%ax
80104f78:	66 90                	xchg   %ax,%ax
80104f7a:	66 90                	xchg   %ax,%ax
80104f7c:	66 90                	xchg   %ax,%ax
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	57                   	push   %edi
80104f84:	53                   	push   %ebx
80104f85:	8b 55 08             	mov    0x8(%ebp),%edx
80104f88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104f8b:	f6 c2 03             	test   $0x3,%dl
80104f8e:	75 05                	jne    80104f95 <memset+0x15>
80104f90:	f6 c1 03             	test   $0x3,%cl
80104f93:	74 13                	je     80104fa8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104f95:	89 d7                	mov    %edx,%edi
80104f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f9a:	fc                   	cld    
80104f9b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104f9d:	5b                   	pop    %ebx
80104f9e:	89 d0                	mov    %edx,%eax
80104fa0:	5f                   	pop    %edi
80104fa1:	5d                   	pop    %ebp
80104fa2:	c3                   	ret    
80104fa3:	90                   	nop
80104fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104fa8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104fac:	c1 e9 02             	shr    $0x2,%ecx
80104faf:	89 f8                	mov    %edi,%eax
80104fb1:	89 fb                	mov    %edi,%ebx
80104fb3:	c1 e0 18             	shl    $0x18,%eax
80104fb6:	c1 e3 10             	shl    $0x10,%ebx
80104fb9:	09 d8                	or     %ebx,%eax
80104fbb:	09 f8                	or     %edi,%eax
80104fbd:	c1 e7 08             	shl    $0x8,%edi
80104fc0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104fc2:	89 d7                	mov    %edx,%edi
80104fc4:	fc                   	cld    
80104fc5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104fc7:	5b                   	pop    %ebx
80104fc8:	89 d0                	mov    %edx,%eax
80104fca:	5f                   	pop    %edi
80104fcb:	5d                   	pop    %ebp
80104fcc:	c3                   	ret    
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi

80104fd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	57                   	push   %edi
80104fd4:	56                   	push   %esi
80104fd5:	53                   	push   %ebx
80104fd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104fd9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fdc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fdf:	85 db                	test   %ebx,%ebx
80104fe1:	74 29                	je     8010500c <memcmp+0x3c>
    if(*s1 != *s2)
80104fe3:	0f b6 16             	movzbl (%esi),%edx
80104fe6:	0f b6 0f             	movzbl (%edi),%ecx
80104fe9:	38 d1                	cmp    %dl,%cl
80104feb:	75 2b                	jne    80105018 <memcmp+0x48>
80104fed:	b8 01 00 00 00       	mov    $0x1,%eax
80104ff2:	eb 14                	jmp    80105008 <memcmp+0x38>
80104ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ff8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104ffc:	83 c0 01             	add    $0x1,%eax
80104fff:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105004:	38 ca                	cmp    %cl,%dl
80105006:	75 10                	jne    80105018 <memcmp+0x48>
  while(n-- > 0){
80105008:	39 d8                	cmp    %ebx,%eax
8010500a:	75 ec                	jne    80104ff8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010500c:	5b                   	pop    %ebx
  return 0;
8010500d:	31 c0                	xor    %eax,%eax
}
8010500f:	5e                   	pop    %esi
80105010:	5f                   	pop    %edi
80105011:	5d                   	pop    %ebp
80105012:	c3                   	ret    
80105013:	90                   	nop
80105014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105018:	0f b6 c2             	movzbl %dl,%eax
}
8010501b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010501c:	29 c8                	sub    %ecx,%eax
}
8010501e:	5e                   	pop    %esi
8010501f:	5f                   	pop    %edi
80105020:	5d                   	pop    %ebp
80105021:	c3                   	ret    
80105022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
80105035:	8b 45 08             	mov    0x8(%ebp),%eax
80105038:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010503b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010503e:	39 c3                	cmp    %eax,%ebx
80105040:	73 26                	jae    80105068 <memmove+0x38>
80105042:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105045:	39 c8                	cmp    %ecx,%eax
80105047:	73 1f                	jae    80105068 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105049:	85 f6                	test   %esi,%esi
8010504b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010504e:	74 0f                	je     8010505f <memmove+0x2f>
      *--d = *--s;
80105050:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105054:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105057:	83 ea 01             	sub    $0x1,%edx
8010505a:	83 fa ff             	cmp    $0xffffffff,%edx
8010505d:	75 f1                	jne    80105050 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    
80105063:	90                   	nop
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105068:	31 d2                	xor    %edx,%edx
8010506a:	85 f6                	test   %esi,%esi
8010506c:	74 f1                	je     8010505f <memmove+0x2f>
8010506e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105070:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105074:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105077:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010507a:	39 d6                	cmp    %edx,%esi
8010507c:	75 f2                	jne    80105070 <memmove+0x40>
}
8010507e:	5b                   	pop    %ebx
8010507f:	5e                   	pop    %esi
80105080:	5d                   	pop    %ebp
80105081:	c3                   	ret    
80105082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105093:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105094:	eb 9a                	jmp    80105030 <memmove>
80105096:	8d 76 00             	lea    0x0(%esi),%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	8b 7d 10             	mov    0x10(%ebp),%edi
801050a8:	53                   	push   %ebx
801050a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801050ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801050af:	85 ff                	test   %edi,%edi
801050b1:	74 2f                	je     801050e2 <strncmp+0x42>
801050b3:	0f b6 01             	movzbl (%ecx),%eax
801050b6:	0f b6 1e             	movzbl (%esi),%ebx
801050b9:	84 c0                	test   %al,%al
801050bb:	74 37                	je     801050f4 <strncmp+0x54>
801050bd:	38 c3                	cmp    %al,%bl
801050bf:	75 33                	jne    801050f4 <strncmp+0x54>
801050c1:	01 f7                	add    %esi,%edi
801050c3:	eb 13                	jmp    801050d8 <strncmp+0x38>
801050c5:	8d 76 00             	lea    0x0(%esi),%esi
801050c8:	0f b6 01             	movzbl (%ecx),%eax
801050cb:	84 c0                	test   %al,%al
801050cd:	74 21                	je     801050f0 <strncmp+0x50>
801050cf:	0f b6 1a             	movzbl (%edx),%ebx
801050d2:	89 d6                	mov    %edx,%esi
801050d4:	38 d8                	cmp    %bl,%al
801050d6:	75 1c                	jne    801050f4 <strncmp+0x54>
    n--, p++, q++;
801050d8:	8d 56 01             	lea    0x1(%esi),%edx
801050db:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801050de:	39 fa                	cmp    %edi,%edx
801050e0:	75 e6                	jne    801050c8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801050e2:	5b                   	pop    %ebx
    return 0;
801050e3:	31 c0                	xor    %eax,%eax
}
801050e5:	5e                   	pop    %esi
801050e6:	5f                   	pop    %edi
801050e7:	5d                   	pop    %ebp
801050e8:	c3                   	ret    
801050e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050f0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801050f4:	29 d8                	sub    %ebx,%eax
}
801050f6:	5b                   	pop    %ebx
801050f7:	5e                   	pop    %esi
801050f8:	5f                   	pop    %edi
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret    
801050fb:	90                   	nop
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
80105105:	8b 45 08             	mov    0x8(%ebp),%eax
80105108:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010510b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010510e:	89 c2                	mov    %eax,%edx
80105110:	eb 19                	jmp    8010512b <strncpy+0x2b>
80105112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105118:	83 c3 01             	add    $0x1,%ebx
8010511b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010511f:	83 c2 01             	add    $0x1,%edx
80105122:	84 c9                	test   %cl,%cl
80105124:	88 4a ff             	mov    %cl,-0x1(%edx)
80105127:	74 09                	je     80105132 <strncpy+0x32>
80105129:	89 f1                	mov    %esi,%ecx
8010512b:	85 c9                	test   %ecx,%ecx
8010512d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105130:	7f e6                	jg     80105118 <strncpy+0x18>
    ;
  while(n-- > 0)
80105132:	31 c9                	xor    %ecx,%ecx
80105134:	85 f6                	test   %esi,%esi
80105136:	7e 17                	jle    8010514f <strncpy+0x4f>
80105138:	90                   	nop
80105139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105140:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105144:	89 f3                	mov    %esi,%ebx
80105146:	83 c1 01             	add    $0x1,%ecx
80105149:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010514b:	85 db                	test   %ebx,%ebx
8010514d:	7f f1                	jg     80105140 <strncpy+0x40>
  return os;
}
8010514f:	5b                   	pop    %ebx
80105150:	5e                   	pop    %esi
80105151:	5d                   	pop    %ebp
80105152:	c3                   	ret    
80105153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105160 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
80105165:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105168:	8b 45 08             	mov    0x8(%ebp),%eax
8010516b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010516e:	85 c9                	test   %ecx,%ecx
80105170:	7e 26                	jle    80105198 <safestrcpy+0x38>
80105172:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105176:	89 c1                	mov    %eax,%ecx
80105178:	eb 17                	jmp    80105191 <safestrcpy+0x31>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105180:	83 c2 01             	add    $0x1,%edx
80105183:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105187:	83 c1 01             	add    $0x1,%ecx
8010518a:	84 db                	test   %bl,%bl
8010518c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010518f:	74 04                	je     80105195 <safestrcpy+0x35>
80105191:	39 f2                	cmp    %esi,%edx
80105193:	75 eb                	jne    80105180 <safestrcpy+0x20>
    ;
  *s = 0;
80105195:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105198:	5b                   	pop    %ebx
80105199:	5e                   	pop    %esi
8010519a:	5d                   	pop    %ebp
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051a0 <strlen>:

int
strlen(const char *s)
{
801051a0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801051a1:	31 c0                	xor    %eax,%eax
{
801051a3:	89 e5                	mov    %esp,%ebp
801051a5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801051a8:	80 3a 00             	cmpb   $0x0,(%edx)
801051ab:	74 0c                	je     801051b9 <strlen+0x19>
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
801051b0:	83 c0 01             	add    $0x1,%eax
801051b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801051b7:	75 f7                	jne    801051b0 <strlen+0x10>
    ;
  return n;
}
801051b9:	5d                   	pop    %ebp
801051ba:	c3                   	ret    

801051bb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801051bb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801051bf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801051c3:	55                   	push   %ebp
  pushl %ebx
801051c4:	53                   	push   %ebx
  pushl %esi
801051c5:	56                   	push   %esi
  pushl %edi
801051c6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801051c7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801051c9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801051cb:	5f                   	pop    %edi
  popl %esi
801051cc:	5e                   	pop    %esi
  popl %ebx
801051cd:	5b                   	pop    %ebx
  popl %ebp
801051ce:	5d                   	pop    %ebp
  ret
801051cf:	c3                   	ret    

801051d0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	53                   	push   %ebx
801051d4:	83 ec 04             	sub    $0x4,%esp
801051d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801051da:	e8 81 ef ff ff       	call   80104160 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051df:	8b 00                	mov    (%eax),%eax
801051e1:	39 d8                	cmp    %ebx,%eax
801051e3:	76 1b                	jbe    80105200 <fetchint+0x30>
801051e5:	8d 53 04             	lea    0x4(%ebx),%edx
801051e8:	39 d0                	cmp    %edx,%eax
801051ea:	72 14                	jb     80105200 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801051ef:	8b 13                	mov    (%ebx),%edx
801051f1:	89 10                	mov    %edx,(%eax)
  return 0;
801051f3:	31 c0                	xor    %eax,%eax
}
801051f5:	83 c4 04             	add    $0x4,%esp
801051f8:	5b                   	pop    %ebx
801051f9:	5d                   	pop    %ebp
801051fa:	c3                   	ret    
801051fb:	90                   	nop
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105200:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105205:	eb ee                	jmp    801051f5 <fetchint+0x25>
80105207:	89 f6                	mov    %esi,%esi
80105209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105210 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	53                   	push   %ebx
80105214:	83 ec 04             	sub    $0x4,%esp
80105217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010521a:	e8 41 ef ff ff       	call   80104160 <myproc>

  if(addr >= curproc->sz)
8010521f:	39 18                	cmp    %ebx,(%eax)
80105221:	76 29                	jbe    8010524c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105223:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105226:	89 da                	mov    %ebx,%edx
80105228:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010522a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010522c:	39 c3                	cmp    %eax,%ebx
8010522e:	73 1c                	jae    8010524c <fetchstr+0x3c>
    if(*s == 0)
80105230:	80 3b 00             	cmpb   $0x0,(%ebx)
80105233:	75 10                	jne    80105245 <fetchstr+0x35>
80105235:	eb 39                	jmp    80105270 <fetchstr+0x60>
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105240:	80 3a 00             	cmpb   $0x0,(%edx)
80105243:	74 1b                	je     80105260 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105245:	83 c2 01             	add    $0x1,%edx
80105248:	39 d0                	cmp    %edx,%eax
8010524a:	77 f4                	ja     80105240 <fetchstr+0x30>
    return -1;
8010524c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105251:	83 c4 04             	add    $0x4,%esp
80105254:	5b                   	pop    %ebx
80105255:	5d                   	pop    %ebp
80105256:	c3                   	ret    
80105257:	89 f6                	mov    %esi,%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105260:	83 c4 04             	add    $0x4,%esp
80105263:	89 d0                	mov    %edx,%eax
80105265:	29 d8                	sub    %ebx,%eax
80105267:	5b                   	pop    %ebx
80105268:	5d                   	pop    %ebp
80105269:	c3                   	ret    
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105270:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105272:	eb dd                	jmp    80105251 <fetchstr+0x41>
80105274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010527a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105280 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	56                   	push   %esi
80105284:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105285:	e8 d6 ee ff ff       	call   80104160 <myproc>
8010528a:	8b 40 18             	mov    0x18(%eax),%eax
8010528d:	8b 55 08             	mov    0x8(%ebp),%edx
80105290:	8b 40 44             	mov    0x44(%eax),%eax
80105293:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105296:	e8 c5 ee ff ff       	call   80104160 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010529b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010529d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801052a0:	39 c6                	cmp    %eax,%esi
801052a2:	73 1c                	jae    801052c0 <argint+0x40>
801052a4:	8d 53 08             	lea    0x8(%ebx),%edx
801052a7:	39 d0                	cmp    %edx,%eax
801052a9:	72 15                	jb     801052c0 <argint+0x40>
  *ip = *(int*)(addr);
801052ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ae:	8b 53 04             	mov    0x4(%ebx),%edx
801052b1:	89 10                	mov    %edx,(%eax)
  return 0;
801052b3:	31 c0                	xor    %eax,%eax
}
801052b5:	5b                   	pop    %ebx
801052b6:	5e                   	pop    %esi
801052b7:	5d                   	pop    %ebp
801052b8:	c3                   	ret    
801052b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801052c5:	eb ee                	jmp    801052b5 <argint+0x35>
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	56                   	push   %esi
801052d4:	53                   	push   %ebx
801052d5:	83 ec 10             	sub    $0x10,%esp
801052d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801052db:	e8 80 ee ff ff       	call   80104160 <myproc>
801052e0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801052e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052e5:	83 ec 08             	sub    $0x8,%esp
801052e8:	50                   	push   %eax
801052e9:	ff 75 08             	pushl  0x8(%ebp)
801052ec:	e8 8f ff ff ff       	call   80105280 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052f1:	83 c4 10             	add    $0x10,%esp
801052f4:	85 c0                	test   %eax,%eax
801052f6:	78 28                	js     80105320 <argptr+0x50>
801052f8:	85 db                	test   %ebx,%ebx
801052fa:	78 24                	js     80105320 <argptr+0x50>
801052fc:	8b 16                	mov    (%esi),%edx
801052fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105301:	39 c2                	cmp    %eax,%edx
80105303:	76 1b                	jbe    80105320 <argptr+0x50>
80105305:	01 c3                	add    %eax,%ebx
80105307:	39 da                	cmp    %ebx,%edx
80105309:	72 15                	jb     80105320 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010530b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010530e:	89 02                	mov    %eax,(%edx)
  return 0;
80105310:	31 c0                	xor    %eax,%eax
}
80105312:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105315:	5b                   	pop    %ebx
80105316:	5e                   	pop    %esi
80105317:	5d                   	pop    %ebp
80105318:	c3                   	ret    
80105319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	eb eb                	jmp    80105312 <argptr+0x42>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105336:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105339:	50                   	push   %eax
8010533a:	ff 75 08             	pushl  0x8(%ebp)
8010533d:	e8 3e ff ff ff       	call   80105280 <argint>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	85 c0                	test   %eax,%eax
80105347:	78 17                	js     80105360 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105349:	83 ec 08             	sub    $0x8,%esp
8010534c:	ff 75 0c             	pushl  0xc(%ebp)
8010534f:	ff 75 f4             	pushl  -0xc(%ebp)
80105352:	e8 b9 fe ff ff       	call   80105210 <fetchstr>
80105357:	83 c4 10             	add    $0x10,%esp
}
8010535a:	c9                   	leave  
8010535b:	c3                   	ret    
8010535c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105365:	c9                   	leave  
80105366:	c3                   	ret    
80105367:	89 f6                	mov    %esi,%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105370 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105370:	55                   	push   %ebp
80105371:	89 e5                	mov    %esp,%ebp
80105373:	53                   	push   %ebx
80105374:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105377:	e8 e4 ed ff ff       	call   80104160 <myproc>
8010537c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010537e:	8b 40 18             	mov    0x18(%eax),%eax
80105381:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105384:	8d 50 ff             	lea    -0x1(%eax),%edx
80105387:	83 fa 16             	cmp    $0x16,%edx
8010538a:	77 1c                	ja     801053a8 <syscall+0x38>
8010538c:	8b 14 85 40 8b 10 80 	mov    -0x7fef74c0(,%eax,4),%edx
80105393:	85 d2                	test   %edx,%edx
80105395:	74 11                	je     801053a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105397:	ff d2                	call   *%edx
80105399:	8b 53 18             	mov    0x18(%ebx),%edx
8010539c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010539f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053a2:	c9                   	leave  
801053a3:	c3                   	ret    
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801053a8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801053a9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801053ac:	50                   	push   %eax
801053ad:	ff 73 10             	pushl  0x10(%ebx)
801053b0:	68 09 8b 10 80       	push   $0x80108b09
801053b5:	e8 a6 b2 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801053ba:	8b 43 18             	mov    0x18(%ebx),%eax
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801053c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801053ca:	c9                   	leave  
801053cb:	c3                   	ret    
801053cc:	66 90                	xchg   %ax,%ax
801053ce:	66 90                	xchg   %ax,%ax

801053d0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	56                   	push   %esi
801053d4:	53                   	push   %ebx
801053d5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801053d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801053da:	89 d6                	mov    %edx,%esi
801053dc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801053df:	50                   	push   %eax
801053e0:	6a 00                	push   $0x0
801053e2:	e8 99 fe ff ff       	call   80105280 <argint>
801053e7:	83 c4 10             	add    $0x10,%esp
801053ea:	85 c0                	test   %eax,%eax
801053ec:	78 2a                	js     80105418 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801053ee:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801053f2:	77 24                	ja     80105418 <argfd.constprop.0+0x48>
801053f4:	e8 67 ed ff ff       	call   80104160 <myproc>
801053f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053fc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105400:	85 c0                	test   %eax,%eax
80105402:	74 14                	je     80105418 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105404:	85 db                	test   %ebx,%ebx
80105406:	74 02                	je     8010540a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105408:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010540a:	89 06                	mov    %eax,(%esi)
  return 0;
8010540c:	31 c0                	xor    %eax,%eax
}
8010540e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105411:	5b                   	pop    %ebx
80105412:	5e                   	pop    %esi
80105413:	5d                   	pop    %ebp
80105414:	c3                   	ret    
80105415:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010541d:	eb ef                	jmp    8010540e <argfd.constprop.0+0x3e>
8010541f:	90                   	nop

80105420 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105420:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105421:	31 c0                	xor    %eax,%eax
{
80105423:	89 e5                	mov    %esp,%ebp
80105425:	56                   	push   %esi
80105426:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105427:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010542a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010542d:	e8 9e ff ff ff       	call   801053d0 <argfd.constprop.0>
80105432:	85 c0                	test   %eax,%eax
80105434:	78 42                	js     80105478 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105436:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105439:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010543b:	e8 20 ed ff ff       	call   80104160 <myproc>
80105440:	eb 0e                	jmp    80105450 <sys_dup+0x30>
80105442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105448:	83 c3 01             	add    $0x1,%ebx
8010544b:	83 fb 10             	cmp    $0x10,%ebx
8010544e:	74 28                	je     80105478 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105450:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105454:	85 d2                	test   %edx,%edx
80105456:	75 f0                	jne    80105448 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105458:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	ff 75 f4             	pushl  -0xc(%ebp)
80105462:	e8 29 bc ff ff       	call   80101090 <filedup>
  return fd;
80105467:	83 c4 10             	add    $0x10,%esp
}
8010546a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010546d:	89 d8                	mov    %ebx,%eax
8010546f:	5b                   	pop    %ebx
80105470:	5e                   	pop    %esi
80105471:	5d                   	pop    %ebp
80105472:	c3                   	ret    
80105473:	90                   	nop
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105478:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010547b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105480:	89 d8                	mov    %ebx,%eax
80105482:	5b                   	pop    %ebx
80105483:	5e                   	pop    %esi
80105484:	5d                   	pop    %ebp
80105485:	c3                   	ret    
80105486:	8d 76 00             	lea    0x0(%esi),%esi
80105489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105490 <sys_read>:

int
sys_read(void)
{
80105490:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105491:	31 c0                	xor    %eax,%eax
{
80105493:	89 e5                	mov    %esp,%ebp
80105495:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105498:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010549b:	e8 30 ff ff ff       	call   801053d0 <argfd.constprop.0>
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 4c                	js     801054f0 <sys_read+0x60>
801054a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054a7:	83 ec 08             	sub    $0x8,%esp
801054aa:	50                   	push   %eax
801054ab:	6a 02                	push   $0x2
801054ad:	e8 ce fd ff ff       	call   80105280 <argint>
801054b2:	83 c4 10             	add    $0x10,%esp
801054b5:	85 c0                	test   %eax,%eax
801054b7:	78 37                	js     801054f0 <sys_read+0x60>
801054b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054bc:	83 ec 04             	sub    $0x4,%esp
801054bf:	ff 75 f0             	pushl  -0x10(%ebp)
801054c2:	50                   	push   %eax
801054c3:	6a 01                	push   $0x1
801054c5:	e8 06 fe ff ff       	call   801052d0 <argptr>
801054ca:	83 c4 10             	add    $0x10,%esp
801054cd:	85 c0                	test   %eax,%eax
801054cf:	78 1f                	js     801054f0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801054d1:	83 ec 04             	sub    $0x4,%esp
801054d4:	ff 75 f0             	pushl  -0x10(%ebp)
801054d7:	ff 75 f4             	pushl  -0xc(%ebp)
801054da:	ff 75 ec             	pushl  -0x14(%ebp)
801054dd:	e8 1e bd ff ff       	call   80101200 <fileread>
801054e2:	83 c4 10             	add    $0x10,%esp
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_write>:

int
sys_write(void)
{
80105500:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105501:	31 c0                	xor    %eax,%eax
{
80105503:	89 e5                	mov    %esp,%ebp
80105505:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105508:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010550b:	e8 c0 fe ff ff       	call   801053d0 <argfd.constprop.0>
80105510:	85 c0                	test   %eax,%eax
80105512:	78 4c                	js     80105560 <sys_write+0x60>
80105514:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105517:	83 ec 08             	sub    $0x8,%esp
8010551a:	50                   	push   %eax
8010551b:	6a 02                	push   $0x2
8010551d:	e8 5e fd ff ff       	call   80105280 <argint>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	85 c0                	test   %eax,%eax
80105527:	78 37                	js     80105560 <sys_write+0x60>
80105529:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010552c:	83 ec 04             	sub    $0x4,%esp
8010552f:	ff 75 f0             	pushl  -0x10(%ebp)
80105532:	50                   	push   %eax
80105533:	6a 01                	push   $0x1
80105535:	e8 96 fd ff ff       	call   801052d0 <argptr>
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	85 c0                	test   %eax,%eax
8010553f:	78 1f                	js     80105560 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105541:	83 ec 04             	sub    $0x4,%esp
80105544:	ff 75 f0             	pushl  -0x10(%ebp)
80105547:	ff 75 f4             	pushl  -0xc(%ebp)
8010554a:	ff 75 ec             	pushl  -0x14(%ebp)
8010554d:	e8 3e bd ff ff       	call   80101290 <filewrite>
80105552:	83 c4 10             	add    $0x10,%esp
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105565:	c9                   	leave  
80105566:	c3                   	ret    
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <sys_close>:

int
sys_close(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105576:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105579:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010557c:	e8 4f fe ff ff       	call   801053d0 <argfd.constprop.0>
80105581:	85 c0                	test   %eax,%eax
80105583:	78 2b                	js     801055b0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105585:	e8 d6 eb ff ff       	call   80104160 <myproc>
8010558a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010558d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105590:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105597:	00 
  fileclose(f);
80105598:	ff 75 f4             	pushl  -0xc(%ebp)
8010559b:	e8 40 bb ff ff       	call   801010e0 <fileclose>
  return 0;
801055a0:	83 c4 10             	add    $0x10,%esp
801055a3:	31 c0                	xor    %eax,%eax
}
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <sys_fstat>:

int
sys_fstat(void)
{
801055c0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055c1:	31 c0                	xor    %eax,%eax
{
801055c3:	89 e5                	mov    %esp,%ebp
801055c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801055c8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801055cb:	e8 00 fe ff ff       	call   801053d0 <argfd.constprop.0>
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 2c                	js     80105600 <sys_fstat+0x40>
801055d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055d7:	83 ec 04             	sub    $0x4,%esp
801055da:	6a 14                	push   $0x14
801055dc:	50                   	push   %eax
801055dd:	6a 01                	push   $0x1
801055df:	e8 ec fc ff ff       	call   801052d0 <argptr>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	78 15                	js     80105600 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801055eb:	83 ec 08             	sub    $0x8,%esp
801055ee:	ff 75 f4             	pushl  -0xc(%ebp)
801055f1:	ff 75 f0             	pushl  -0x10(%ebp)
801055f4:	e8 b7 bb ff ff       	call   801011b0 <filestat>
801055f9:	83 c4 10             	add    $0x10,%esp
}
801055fc:	c9                   	leave  
801055fd:	c3                   	ret    
801055fe:	66 90                	xchg   %ax,%ax
    return -1;
80105600:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105605:	c9                   	leave  
80105606:	c3                   	ret    
80105607:	89 f6                	mov    %esi,%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	57                   	push   %edi
80105614:	56                   	push   %esi
80105615:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105616:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105619:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010561c:	50                   	push   %eax
8010561d:	6a 00                	push   $0x0
8010561f:	e8 0c fd ff ff       	call   80105330 <argstr>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	85 c0                	test   %eax,%eax
80105629:	0f 88 fb 00 00 00    	js     8010572a <sys_link+0x11a>
8010562f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105632:	83 ec 08             	sub    $0x8,%esp
80105635:	50                   	push   %eax
80105636:	6a 01                	push   $0x1
80105638:	e8 f3 fc ff ff       	call   80105330 <argstr>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	0f 88 e2 00 00 00    	js     8010572a <sys_link+0x11a>
    return -1;

  begin_op();
80105648:	e8 f3 dd ff ff       	call   80103440 <begin_op>
  if((ip = namei(old)) == 0){
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	ff 75 d4             	pushl  -0x2c(%ebp)
80105653:	e8 28 cb ff ff       	call   80102180 <namei>
80105658:	83 c4 10             	add    $0x10,%esp
8010565b:	85 c0                	test   %eax,%eax
8010565d:	89 c3                	mov    %eax,%ebx
8010565f:	0f 84 ea 00 00 00    	je     8010574f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105665:	83 ec 0c             	sub    $0xc,%esp
80105668:	50                   	push   %eax
80105669:	e8 b2 c2 ff ff       	call   80101920 <ilock>
  if(ip->type == T_DIR){
8010566e:	83 c4 10             	add    $0x10,%esp
80105671:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105676:	0f 84 bb 00 00 00    	je     80105737 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010567c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105681:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105684:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105687:	53                   	push   %ebx
80105688:	e8 e3 c1 ff ff       	call   80101870 <iupdate>
  iunlock(ip);
8010568d:	89 1c 24             	mov    %ebx,(%esp)
80105690:	e8 6b c3 ff ff       	call   80101a00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105695:	58                   	pop    %eax
80105696:	5a                   	pop    %edx
80105697:	57                   	push   %edi
80105698:	ff 75 d0             	pushl  -0x30(%ebp)
8010569b:	e8 00 cb ff ff       	call   801021a0 <nameiparent>
801056a0:	83 c4 10             	add    $0x10,%esp
801056a3:	85 c0                	test   %eax,%eax
801056a5:	89 c6                	mov    %eax,%esi
801056a7:	74 5b                	je     80105704 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801056a9:	83 ec 0c             	sub    $0xc,%esp
801056ac:	50                   	push   %eax
801056ad:	e8 6e c2 ff ff       	call   80101920 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801056b2:	83 c4 10             	add    $0x10,%esp
801056b5:	8b 03                	mov    (%ebx),%eax
801056b7:	39 06                	cmp    %eax,(%esi)
801056b9:	75 3d                	jne    801056f8 <sys_link+0xe8>
801056bb:	83 ec 04             	sub    $0x4,%esp
801056be:	ff 73 04             	pushl  0x4(%ebx)
801056c1:	57                   	push   %edi
801056c2:	56                   	push   %esi
801056c3:	e8 f8 c9 ff ff       	call   801020c0 <dirlink>
801056c8:	83 c4 10             	add    $0x10,%esp
801056cb:	85 c0                	test   %eax,%eax
801056cd:	78 29                	js     801056f8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801056cf:	83 ec 0c             	sub    $0xc,%esp
801056d2:	56                   	push   %esi
801056d3:	e8 d8 c4 ff ff       	call   80101bb0 <iunlockput>
  iput(ip);
801056d8:	89 1c 24             	mov    %ebx,(%esp)
801056db:	e8 70 c3 ff ff       	call   80101a50 <iput>

  end_op();
801056e0:	e8 cb dd ff ff       	call   801034b0 <end_op>

  return 0;
801056e5:	83 c4 10             	add    $0x10,%esp
801056e8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
801056ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056ed:	5b                   	pop    %ebx
801056ee:	5e                   	pop    %esi
801056ef:	5f                   	pop    %edi
801056f0:	5d                   	pop    %ebp
801056f1:	c3                   	ret    
801056f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	56                   	push   %esi
801056fc:	e8 af c4 ff ff       	call   80101bb0 <iunlockput>
    goto bad;
80105701:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105704:	83 ec 0c             	sub    $0xc,%esp
80105707:	53                   	push   %ebx
80105708:	e8 13 c2 ff ff       	call   80101920 <ilock>
  ip->nlink--;
8010570d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105712:	89 1c 24             	mov    %ebx,(%esp)
80105715:	e8 56 c1 ff ff       	call   80101870 <iupdate>
  iunlockput(ip);
8010571a:	89 1c 24             	mov    %ebx,(%esp)
8010571d:	e8 8e c4 ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105722:	e8 89 dd ff ff       	call   801034b0 <end_op>
  return -1;
80105727:	83 c4 10             	add    $0x10,%esp
}
8010572a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010572d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105732:	5b                   	pop    %ebx
80105733:	5e                   	pop    %esi
80105734:	5f                   	pop    %edi
80105735:	5d                   	pop    %ebp
80105736:	c3                   	ret    
    iunlockput(ip);
80105737:	83 ec 0c             	sub    $0xc,%esp
8010573a:	53                   	push   %ebx
8010573b:	e8 70 c4 ff ff       	call   80101bb0 <iunlockput>
    end_op();
80105740:	e8 6b dd ff ff       	call   801034b0 <end_op>
    return -1;
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010574d:	eb 9b                	jmp    801056ea <sys_link+0xda>
    end_op();
8010574f:	e8 5c dd ff ff       	call   801034b0 <end_op>
    return -1;
80105754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105759:	eb 8f                	jmp    801056ea <sys_link+0xda>
8010575b:	90                   	nop
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	57                   	push   %edi
80105764:	56                   	push   %esi
80105765:	53                   	push   %ebx
80105766:	83 ec 1c             	sub    $0x1c,%esp
80105769:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010576c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105770:	76 3e                	jbe    801057b0 <isdirempty+0x50>
80105772:	bb 20 00 00 00       	mov    $0x20,%ebx
80105777:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010577a:	eb 0c                	jmp    80105788 <isdirempty+0x28>
8010577c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105780:	83 c3 10             	add    $0x10,%ebx
80105783:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105786:	73 28                	jae    801057b0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105788:	6a 10                	push   $0x10
8010578a:	53                   	push   %ebx
8010578b:	57                   	push   %edi
8010578c:	56                   	push   %esi
8010578d:	e8 6e c4 ff ff       	call   80101c00 <readi>
80105792:	83 c4 10             	add    $0x10,%esp
80105795:	83 f8 10             	cmp    $0x10,%eax
80105798:	75 23                	jne    801057bd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
8010579a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010579f:	74 df                	je     80105780 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801057a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801057a4:	31 c0                	xor    %eax,%eax
}
801057a6:	5b                   	pop    %ebx
801057a7:	5e                   	pop    %esi
801057a8:	5f                   	pop    %edi
801057a9:	5d                   	pop    %ebp
801057aa:	c3                   	ret    
801057ab:	90                   	nop
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801057b3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801057b8:	5b                   	pop    %ebx
801057b9:	5e                   	pop    %esi
801057ba:	5f                   	pop    %edi
801057bb:	5d                   	pop    %ebp
801057bc:	c3                   	ret    
      panic("isdirempty: readi");
801057bd:	83 ec 0c             	sub    $0xc,%esp
801057c0:	68 a0 8b 10 80       	push   $0x80108ba0
801057c5:	e8 c6 ab ff ff       	call   80100390 <panic>
801057ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057d0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	57                   	push   %edi
801057d4:	56                   	push   %esi
801057d5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801057d6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057d9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801057dc:	50                   	push   %eax
801057dd:	6a 00                	push   $0x0
801057df:	e8 4c fb ff ff       	call   80105330 <argstr>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	85 c0                	test   %eax,%eax
801057e9:	0f 88 51 01 00 00    	js     80105940 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
801057ef:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801057f2:	e8 49 dc ff ff       	call   80103440 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057f7:	83 ec 08             	sub    $0x8,%esp
801057fa:	53                   	push   %ebx
801057fb:	ff 75 c0             	pushl  -0x40(%ebp)
801057fe:	e8 9d c9 ff ff       	call   801021a0 <nameiparent>
80105803:	83 c4 10             	add    $0x10,%esp
80105806:	85 c0                	test   %eax,%eax
80105808:	89 c6                	mov    %eax,%esi
8010580a:	0f 84 37 01 00 00    	je     80105947 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	50                   	push   %eax
80105814:	e8 07 c1 ff ff       	call   80101920 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105819:	58                   	pop    %eax
8010581a:	5a                   	pop    %edx
8010581b:	68 f2 84 10 80       	push   $0x801084f2
80105820:	53                   	push   %ebx
80105821:	e8 0a c6 ff ff       	call   80101e30 <namecmp>
80105826:	83 c4 10             	add    $0x10,%esp
80105829:	85 c0                	test   %eax,%eax
8010582b:	0f 84 d7 00 00 00    	je     80105908 <sys_unlink+0x138>
80105831:	83 ec 08             	sub    $0x8,%esp
80105834:	68 f1 84 10 80       	push   $0x801084f1
80105839:	53                   	push   %ebx
8010583a:	e8 f1 c5 ff ff       	call   80101e30 <namecmp>
8010583f:	83 c4 10             	add    $0x10,%esp
80105842:	85 c0                	test   %eax,%eax
80105844:	0f 84 be 00 00 00    	je     80105908 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010584a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010584d:	83 ec 04             	sub    $0x4,%esp
80105850:	50                   	push   %eax
80105851:	53                   	push   %ebx
80105852:	56                   	push   %esi
80105853:	e8 f8 c5 ff ff       	call   80101e50 <dirlookup>
80105858:	83 c4 10             	add    $0x10,%esp
8010585b:	85 c0                	test   %eax,%eax
8010585d:	89 c3                	mov    %eax,%ebx
8010585f:	0f 84 a3 00 00 00    	je     80105908 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105865:	83 ec 0c             	sub    $0xc,%esp
80105868:	50                   	push   %eax
80105869:	e8 b2 c0 ff ff       	call   80101920 <ilock>

  if(ip->nlink < 1)
8010586e:	83 c4 10             	add    $0x10,%esp
80105871:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105876:	0f 8e e4 00 00 00    	jle    80105960 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010587c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105881:	74 65                	je     801058e8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105883:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105886:	83 ec 04             	sub    $0x4,%esp
80105889:	6a 10                	push   $0x10
8010588b:	6a 00                	push   $0x0
8010588d:	57                   	push   %edi
8010588e:	e8 ed f6 ff ff       	call   80104f80 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105893:	6a 10                	push   $0x10
80105895:	ff 75 c4             	pushl  -0x3c(%ebp)
80105898:	57                   	push   %edi
80105899:	56                   	push   %esi
8010589a:	e8 61 c4 ff ff       	call   80101d00 <writei>
8010589f:	83 c4 20             	add    $0x20,%esp
801058a2:	83 f8 10             	cmp    $0x10,%eax
801058a5:	0f 85 a8 00 00 00    	jne    80105953 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801058ab:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058b0:	74 6e                	je     80105920 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801058b2:	83 ec 0c             	sub    $0xc,%esp
801058b5:	56                   	push   %esi
801058b6:	e8 f5 c2 ff ff       	call   80101bb0 <iunlockput>

  ip->nlink--;
801058bb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058c0:	89 1c 24             	mov    %ebx,(%esp)
801058c3:	e8 a8 bf ff ff       	call   80101870 <iupdate>
  iunlockput(ip);
801058c8:	89 1c 24             	mov    %ebx,(%esp)
801058cb:	e8 e0 c2 ff ff       	call   80101bb0 <iunlockput>

  end_op();
801058d0:	e8 db db ff ff       	call   801034b0 <end_op>

  return 0;
801058d5:	83 c4 10             	add    $0x10,%esp
801058d8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801058da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058dd:	5b                   	pop    %ebx
801058de:	5e                   	pop    %esi
801058df:	5f                   	pop    %edi
801058e0:	5d                   	pop    %ebp
801058e1:	c3                   	ret    
801058e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
801058e8:	83 ec 0c             	sub    $0xc,%esp
801058eb:	53                   	push   %ebx
801058ec:	e8 6f fe ff ff       	call   80105760 <isdirempty>
801058f1:	83 c4 10             	add    $0x10,%esp
801058f4:	85 c0                	test   %eax,%eax
801058f6:	75 8b                	jne    80105883 <sys_unlink+0xb3>
    iunlockput(ip);
801058f8:	83 ec 0c             	sub    $0xc,%esp
801058fb:	53                   	push   %ebx
801058fc:	e8 af c2 ff ff       	call   80101bb0 <iunlockput>
    goto bad;
80105901:	83 c4 10             	add    $0x10,%esp
80105904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105908:	83 ec 0c             	sub    $0xc,%esp
8010590b:	56                   	push   %esi
8010590c:	e8 9f c2 ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105911:	e8 9a db ff ff       	call   801034b0 <end_op>
  return -1;
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010591e:	eb ba                	jmp    801058da <sys_unlink+0x10a>
    dp->nlink--;
80105920:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105925:	83 ec 0c             	sub    $0xc,%esp
80105928:	56                   	push   %esi
80105929:	e8 42 bf ff ff       	call   80101870 <iupdate>
8010592e:	83 c4 10             	add    $0x10,%esp
80105931:	e9 7c ff ff ff       	jmp    801058b2 <sys_unlink+0xe2>
80105936:	8d 76 00             	lea    0x0(%esi),%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105945:	eb 93                	jmp    801058da <sys_unlink+0x10a>
    end_op();
80105947:	e8 64 db ff ff       	call   801034b0 <end_op>
    return -1;
8010594c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105951:	eb 87                	jmp    801058da <sys_unlink+0x10a>
    panic("unlink: writei");
80105953:	83 ec 0c             	sub    $0xc,%esp
80105956:	68 06 85 10 80       	push   $0x80108506
8010595b:	e8 30 aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	68 f4 84 10 80       	push   $0x801084f4
80105968:	e8 23 aa ff ff       	call   80100390 <panic>
8010596d:	8d 76 00             	lea    0x0(%esi),%esi

80105970 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
80105975:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105976:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105979:	83 ec 34             	sub    $0x34,%esp
8010597c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010597f:	8b 55 10             	mov    0x10(%ebp),%edx
80105982:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105985:	56                   	push   %esi
80105986:	ff 75 08             	pushl  0x8(%ebp)
{
80105989:	89 45 d4             	mov    %eax,-0x2c(%ebp)
8010598c:	89 55 d0             	mov    %edx,-0x30(%ebp)
8010598f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105992:	e8 09 c8 ff ff       	call   801021a0 <nameiparent>
80105997:	83 c4 10             	add    $0x10,%esp
8010599a:	85 c0                	test   %eax,%eax
8010599c:	0f 84 4e 01 00 00    	je     80105af0 <create+0x180>
    return 0;
  ilock(dp);
801059a2:	83 ec 0c             	sub    $0xc,%esp
801059a5:	89 c3                	mov    %eax,%ebx
801059a7:	50                   	push   %eax
801059a8:	e8 73 bf ff ff       	call   80101920 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801059ad:	83 c4 0c             	add    $0xc,%esp
801059b0:	6a 00                	push   $0x0
801059b2:	56                   	push   %esi
801059b3:	53                   	push   %ebx
801059b4:	e8 97 c4 ff ff       	call   80101e50 <dirlookup>
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	85 c0                	test   %eax,%eax
801059be:	89 c7                	mov    %eax,%edi
801059c0:	74 3e                	je     80105a00 <create+0x90>
    iunlockput(dp);
801059c2:	83 ec 0c             	sub    $0xc,%esp
801059c5:	53                   	push   %ebx
801059c6:	e8 e5 c1 ff ff       	call   80101bb0 <iunlockput>
    ilock(ip);
801059cb:	89 3c 24             	mov    %edi,(%esp)
801059ce:	e8 4d bf ff ff       	call   80101920 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801059d3:	83 c4 10             	add    $0x10,%esp
801059d6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801059db:	0f 85 9f 00 00 00    	jne    80105a80 <create+0x110>
801059e1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801059e6:	0f 85 94 00 00 00    	jne    80105a80 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801059ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059ef:	89 f8                	mov    %edi,%eax
801059f1:	5b                   	pop    %ebx
801059f2:	5e                   	pop    %esi
801059f3:	5f                   	pop    %edi
801059f4:	5d                   	pop    %ebp
801059f5:	c3                   	ret    
801059f6:	8d 76 00             	lea    0x0(%esi),%esi
801059f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105a00:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105a04:	83 ec 08             	sub    $0x8,%esp
80105a07:	50                   	push   %eax
80105a08:	ff 33                	pushl  (%ebx)
80105a0a:	e8 a1 bd ff ff       	call   801017b0 <ialloc>
80105a0f:	83 c4 10             	add    $0x10,%esp
80105a12:	85 c0                	test   %eax,%eax
80105a14:	89 c7                	mov    %eax,%edi
80105a16:	0f 84 e8 00 00 00    	je     80105b04 <create+0x194>
  ilock(ip);
80105a1c:	83 ec 0c             	sub    $0xc,%esp
80105a1f:	50                   	push   %eax
80105a20:	e8 fb be ff ff       	call   80101920 <ilock>
  ip->major = major;
80105a25:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105a29:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105a2d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105a31:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105a35:	b8 01 00 00 00       	mov    $0x1,%eax
80105a3a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105a3e:	89 3c 24             	mov    %edi,(%esp)
80105a41:	e8 2a be ff ff       	call   80101870 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105a4e:	74 50                	je     80105aa0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105a50:	83 ec 04             	sub    $0x4,%esp
80105a53:	ff 77 04             	pushl  0x4(%edi)
80105a56:	56                   	push   %esi
80105a57:	53                   	push   %ebx
80105a58:	e8 63 c6 ff ff       	call   801020c0 <dirlink>
80105a5d:	83 c4 10             	add    $0x10,%esp
80105a60:	85 c0                	test   %eax,%eax
80105a62:	0f 88 8f 00 00 00    	js     80105af7 <create+0x187>
  iunlockput(dp);
80105a68:	83 ec 0c             	sub    $0xc,%esp
80105a6b:	53                   	push   %ebx
80105a6c:	e8 3f c1 ff ff       	call   80101bb0 <iunlockput>
  return ip;
80105a71:	83 c4 10             	add    $0x10,%esp
}
80105a74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a77:	89 f8                	mov    %edi,%eax
80105a79:	5b                   	pop    %ebx
80105a7a:	5e                   	pop    %esi
80105a7b:	5f                   	pop    %edi
80105a7c:	5d                   	pop    %ebp
80105a7d:	c3                   	ret    
80105a7e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	57                   	push   %edi
    return 0;
80105a84:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105a86:	e8 25 c1 ff ff       	call   80101bb0 <iunlockput>
    return 0;
80105a8b:	83 c4 10             	add    $0x10,%esp
}
80105a8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a91:	89 f8                	mov    %edi,%eax
80105a93:	5b                   	pop    %ebx
80105a94:	5e                   	pop    %esi
80105a95:	5f                   	pop    %edi
80105a96:	5d                   	pop    %ebp
80105a97:	c3                   	ret    
80105a98:	90                   	nop
80105a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105aa0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105aa5:	83 ec 0c             	sub    $0xc,%esp
80105aa8:	53                   	push   %ebx
80105aa9:	e8 c2 bd ff ff       	call   80101870 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105aae:	83 c4 0c             	add    $0xc,%esp
80105ab1:	ff 77 04             	pushl  0x4(%edi)
80105ab4:	68 f2 84 10 80       	push   $0x801084f2
80105ab9:	57                   	push   %edi
80105aba:	e8 01 c6 ff ff       	call   801020c0 <dirlink>
80105abf:	83 c4 10             	add    $0x10,%esp
80105ac2:	85 c0                	test   %eax,%eax
80105ac4:	78 1c                	js     80105ae2 <create+0x172>
80105ac6:	83 ec 04             	sub    $0x4,%esp
80105ac9:	ff 73 04             	pushl  0x4(%ebx)
80105acc:	68 f1 84 10 80       	push   $0x801084f1
80105ad1:	57                   	push   %edi
80105ad2:	e8 e9 c5 ff ff       	call   801020c0 <dirlink>
80105ad7:	83 c4 10             	add    $0x10,%esp
80105ada:	85 c0                	test   %eax,%eax
80105adc:	0f 89 6e ff ff ff    	jns    80105a50 <create+0xe0>
      panic("create dots");
80105ae2:	83 ec 0c             	sub    $0xc,%esp
80105ae5:	68 c1 8b 10 80       	push   $0x80108bc1
80105aea:	e8 a1 a8 ff ff       	call   80100390 <panic>
80105aef:	90                   	nop
    return 0;
80105af0:	31 ff                	xor    %edi,%edi
80105af2:	e9 f5 fe ff ff       	jmp    801059ec <create+0x7c>
    panic("create: dirlink");
80105af7:	83 ec 0c             	sub    $0xc,%esp
80105afa:	68 cd 8b 10 80       	push   $0x80108bcd
80105aff:	e8 8c a8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105b04:	83 ec 0c             	sub    $0xc,%esp
80105b07:	68 b2 8b 10 80       	push   $0x80108bb2
80105b0c:	e8 7f a8 ff ff       	call   80100390 <panic>
80105b11:	eb 0d                	jmp    80105b20 <sys_open>
80105b13:	90                   	nop
80105b14:	90                   	nop
80105b15:	90                   	nop
80105b16:	90                   	nop
80105b17:	90                   	nop
80105b18:	90                   	nop
80105b19:	90                   	nop
80105b1a:	90                   	nop
80105b1b:	90                   	nop
80105b1c:	90                   	nop
80105b1d:	90                   	nop
80105b1e:	90                   	nop
80105b1f:	90                   	nop

80105b20 <sys_open>:

int
sys_open(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	57                   	push   %edi
80105b24:	56                   	push   %esi
80105b25:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b26:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105b29:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105b2c:	50                   	push   %eax
80105b2d:	6a 00                	push   $0x0
80105b2f:	e8 fc f7 ff ff       	call   80105330 <argstr>
80105b34:	83 c4 10             	add    $0x10,%esp
80105b37:	85 c0                	test   %eax,%eax
80105b39:	0f 88 1d 01 00 00    	js     80105c5c <sys_open+0x13c>
80105b3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b42:	83 ec 08             	sub    $0x8,%esp
80105b45:	50                   	push   %eax
80105b46:	6a 01                	push   $0x1
80105b48:	e8 33 f7 ff ff       	call   80105280 <argint>
80105b4d:	83 c4 10             	add    $0x10,%esp
80105b50:	85 c0                	test   %eax,%eax
80105b52:	0f 88 04 01 00 00    	js     80105c5c <sys_open+0x13c>
    return -1;

  begin_op();
80105b58:	e8 e3 d8 ff ff       	call   80103440 <begin_op>

  if(omode & O_CREATE){
80105b5d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105b61:	0f 85 a9 00 00 00    	jne    80105c10 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105b67:	83 ec 0c             	sub    $0xc,%esp
80105b6a:	ff 75 e0             	pushl  -0x20(%ebp)
80105b6d:	e8 0e c6 ff ff       	call   80102180 <namei>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	89 c6                	mov    %eax,%esi
80105b79:	0f 84 ac 00 00 00    	je     80105c2b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105b7f:	83 ec 0c             	sub    $0xc,%esp
80105b82:	50                   	push   %eax
80105b83:	e8 98 bd ff ff       	call   80101920 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b88:	83 c4 10             	add    $0x10,%esp
80105b8b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b90:	0f 84 aa 00 00 00    	je     80105c40 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b96:	e8 85 b4 ff ff       	call   80101020 <filealloc>
80105b9b:	85 c0                	test   %eax,%eax
80105b9d:	89 c7                	mov    %eax,%edi
80105b9f:	0f 84 a6 00 00 00    	je     80105c4b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105ba5:	e8 b6 e5 ff ff       	call   80104160 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105baa:	31 db                	xor    %ebx,%ebx
80105bac:	eb 0e                	jmp    80105bbc <sys_open+0x9c>
80105bae:	66 90                	xchg   %ax,%ax
80105bb0:	83 c3 01             	add    $0x1,%ebx
80105bb3:	83 fb 10             	cmp    $0x10,%ebx
80105bb6:	0f 84 ac 00 00 00    	je     80105c68 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105bbc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105bc0:	85 d2                	test   %edx,%edx
80105bc2:	75 ec                	jne    80105bb0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105bc4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105bc7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105bcb:	56                   	push   %esi
80105bcc:	e8 2f be ff ff       	call   80101a00 <iunlock>
  end_op();
80105bd1:	e8 da d8 ff ff       	call   801034b0 <end_op>

  f->type = FD_INODE;
80105bd6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bdc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bdf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105be2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105be5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bec:	89 d0                	mov    %edx,%eax
80105bee:	f7 d0                	not    %eax
80105bf0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bf3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bf6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bf9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c00:	89 d8                	mov    %ebx,%eax
80105c02:	5b                   	pop    %ebx
80105c03:	5e                   	pop    %esi
80105c04:	5f                   	pop    %edi
80105c05:	5d                   	pop    %ebp
80105c06:	c3                   	ret    
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105c10:	6a 00                	push   $0x0
80105c12:	6a 00                	push   $0x0
80105c14:	6a 02                	push   $0x2
80105c16:	ff 75 e0             	pushl  -0x20(%ebp)
80105c19:	e8 52 fd ff ff       	call   80105970 <create>
    if(ip == 0){
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105c23:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105c25:	0f 85 6b ff ff ff    	jne    80105b96 <sys_open+0x76>
      end_op();
80105c2b:	e8 80 d8 ff ff       	call   801034b0 <end_op>
      return -1;
80105c30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c35:	eb c6                	jmp    80105bfd <sys_open+0xdd>
80105c37:	89 f6                	mov    %esi,%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105c40:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105c43:	85 c9                	test   %ecx,%ecx
80105c45:	0f 84 4b ff ff ff    	je     80105b96 <sys_open+0x76>
    iunlockput(ip);
80105c4b:	83 ec 0c             	sub    $0xc,%esp
80105c4e:	56                   	push   %esi
80105c4f:	e8 5c bf ff ff       	call   80101bb0 <iunlockput>
    end_op();
80105c54:	e8 57 d8 ff ff       	call   801034b0 <end_op>
    return -1;
80105c59:	83 c4 10             	add    $0x10,%esp
80105c5c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c61:	eb 9a                	jmp    80105bfd <sys_open+0xdd>
80105c63:	90                   	nop
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105c68:	83 ec 0c             	sub    $0xc,%esp
80105c6b:	57                   	push   %edi
80105c6c:	e8 6f b4 ff ff       	call   801010e0 <fileclose>
80105c71:	83 c4 10             	add    $0x10,%esp
80105c74:	eb d5                	jmp    80105c4b <sys_open+0x12b>
80105c76:	8d 76 00             	lea    0x0(%esi),%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c80 <sys_mkdir>:

int
sys_mkdir(void)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105c86:	e8 b5 d7 ff ff       	call   80103440 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105c8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c8e:	83 ec 08             	sub    $0x8,%esp
80105c91:	50                   	push   %eax
80105c92:	6a 00                	push   $0x0
80105c94:	e8 97 f6 ff ff       	call   80105330 <argstr>
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	85 c0                	test   %eax,%eax
80105c9e:	78 30                	js     80105cd0 <sys_mkdir+0x50>
80105ca0:	6a 00                	push   $0x0
80105ca2:	6a 00                	push   $0x0
80105ca4:	6a 01                	push   $0x1
80105ca6:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca9:	e8 c2 fc ff ff       	call   80105970 <create>
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	85 c0                	test   %eax,%eax
80105cb3:	74 1b                	je     80105cd0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cb5:	83 ec 0c             	sub    $0xc,%esp
80105cb8:	50                   	push   %eax
80105cb9:	e8 f2 be ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105cbe:	e8 ed d7 ff ff       	call   801034b0 <end_op>
  return 0;
80105cc3:	83 c4 10             	add    $0x10,%esp
80105cc6:	31 c0                	xor    %eax,%eax
}
80105cc8:	c9                   	leave  
80105cc9:	c3                   	ret    
80105cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105cd0:	e8 db d7 ff ff       	call   801034b0 <end_op>
    return -1;
80105cd5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cda:	c9                   	leave  
80105cdb:	c3                   	ret    
80105cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ce0 <sys_mknod>:

int
sys_mknod(void)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105ce6:	e8 55 d7 ff ff       	call   80103440 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105ceb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105cee:	83 ec 08             	sub    $0x8,%esp
80105cf1:	50                   	push   %eax
80105cf2:	6a 00                	push   $0x0
80105cf4:	e8 37 f6 ff ff       	call   80105330 <argstr>
80105cf9:	83 c4 10             	add    $0x10,%esp
80105cfc:	85 c0                	test   %eax,%eax
80105cfe:	78 60                	js     80105d60 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105d00:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d03:	83 ec 08             	sub    $0x8,%esp
80105d06:	50                   	push   %eax
80105d07:	6a 01                	push   $0x1
80105d09:	e8 72 f5 ff ff       	call   80105280 <argint>
  if((argstr(0, &path)) < 0 ||
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	85 c0                	test   %eax,%eax
80105d13:	78 4b                	js     80105d60 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105d15:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d18:	83 ec 08             	sub    $0x8,%esp
80105d1b:	50                   	push   %eax
80105d1c:	6a 02                	push   $0x2
80105d1e:	e8 5d f5 ff ff       	call   80105280 <argint>
     argint(1, &major) < 0 ||
80105d23:	83 c4 10             	add    $0x10,%esp
80105d26:	85 c0                	test   %eax,%eax
80105d28:	78 36                	js     80105d60 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d2a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d2e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
80105d2f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105d33:	50                   	push   %eax
80105d34:	6a 03                	push   $0x3
80105d36:	ff 75 ec             	pushl  -0x14(%ebp)
80105d39:	e8 32 fc ff ff       	call   80105970 <create>
80105d3e:	83 c4 10             	add    $0x10,%esp
80105d41:	85 c0                	test   %eax,%eax
80105d43:	74 1b                	je     80105d60 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105d45:	83 ec 0c             	sub    $0xc,%esp
80105d48:	50                   	push   %eax
80105d49:	e8 62 be ff ff       	call   80101bb0 <iunlockput>
  end_op();
80105d4e:	e8 5d d7 ff ff       	call   801034b0 <end_op>
  return 0;
80105d53:	83 c4 10             	add    $0x10,%esp
80105d56:	31 c0                	xor    %eax,%eax
}
80105d58:	c9                   	leave  
80105d59:	c3                   	ret    
80105d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105d60:	e8 4b d7 ff ff       	call   801034b0 <end_op>
    return -1;
80105d65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d6a:	c9                   	leave  
80105d6b:	c3                   	ret    
80105d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105d70 <sys_chdir>:

int
sys_chdir(void)
{
80105d70:	55                   	push   %ebp
80105d71:	89 e5                	mov    %esp,%ebp
80105d73:	56                   	push   %esi
80105d74:	53                   	push   %ebx
80105d75:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d78:	e8 e3 e3 ff ff       	call   80104160 <myproc>
80105d7d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d7f:	e8 bc d6 ff ff       	call   80103440 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d87:	83 ec 08             	sub    $0x8,%esp
80105d8a:	50                   	push   %eax
80105d8b:	6a 00                	push   $0x0
80105d8d:	e8 9e f5 ff ff       	call   80105330 <argstr>
80105d92:	83 c4 10             	add    $0x10,%esp
80105d95:	85 c0                	test   %eax,%eax
80105d97:	78 77                	js     80105e10 <sys_chdir+0xa0>
80105d99:	83 ec 0c             	sub    $0xc,%esp
80105d9c:	ff 75 f4             	pushl  -0xc(%ebp)
80105d9f:	e8 dc c3 ff ff       	call   80102180 <namei>
80105da4:	83 c4 10             	add    $0x10,%esp
80105da7:	85 c0                	test   %eax,%eax
80105da9:	89 c3                	mov    %eax,%ebx
80105dab:	74 63                	je     80105e10 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105dad:	83 ec 0c             	sub    $0xc,%esp
80105db0:	50                   	push   %eax
80105db1:	e8 6a bb ff ff       	call   80101920 <ilock>
  if(ip->type != T_DIR){
80105db6:	83 c4 10             	add    $0x10,%esp
80105db9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105dbe:	75 30                	jne    80105df0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105dc0:	83 ec 0c             	sub    $0xc,%esp
80105dc3:	53                   	push   %ebx
80105dc4:	e8 37 bc ff ff       	call   80101a00 <iunlock>
  iput(curproc->cwd);
80105dc9:	58                   	pop    %eax
80105dca:	ff 76 68             	pushl  0x68(%esi)
80105dcd:	e8 7e bc ff ff       	call   80101a50 <iput>
  end_op();
80105dd2:	e8 d9 d6 ff ff       	call   801034b0 <end_op>
  curproc->cwd = ip;
80105dd7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105dda:	83 c4 10             	add    $0x10,%esp
80105ddd:	31 c0                	xor    %eax,%eax
}
80105ddf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105de2:	5b                   	pop    %ebx
80105de3:	5e                   	pop    %esi
80105de4:	5d                   	pop    %ebp
80105de5:	c3                   	ret    
80105de6:	8d 76 00             	lea    0x0(%esi),%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	53                   	push   %ebx
80105df4:	e8 b7 bd ff ff       	call   80101bb0 <iunlockput>
    end_op();
80105df9:	e8 b2 d6 ff ff       	call   801034b0 <end_op>
    return -1;
80105dfe:	83 c4 10             	add    $0x10,%esp
80105e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e06:	eb d7                	jmp    80105ddf <sys_chdir+0x6f>
80105e08:	90                   	nop
80105e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105e10:	e8 9b d6 ff ff       	call   801034b0 <end_op>
    return -1;
80105e15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1a:	eb c3                	jmp    80105ddf <sys_chdir+0x6f>
80105e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e20 <sys_exec>:

int
sys_exec(void)
{
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	57                   	push   %edi
80105e24:	56                   	push   %esi
80105e25:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e26:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105e2c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105e32:	50                   	push   %eax
80105e33:	6a 00                	push   $0x0
80105e35:	e8 f6 f4 ff ff       	call   80105330 <argstr>
80105e3a:	83 c4 10             	add    $0x10,%esp
80105e3d:	85 c0                	test   %eax,%eax
80105e3f:	0f 88 87 00 00 00    	js     80105ecc <sys_exec+0xac>
80105e45:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105e4b:	83 ec 08             	sub    $0x8,%esp
80105e4e:	50                   	push   %eax
80105e4f:	6a 01                	push   $0x1
80105e51:	e8 2a f4 ff ff       	call   80105280 <argint>
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	78 6f                	js     80105ecc <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105e5d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105e63:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105e66:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105e68:	68 80 00 00 00       	push   $0x80
80105e6d:	6a 00                	push   $0x0
80105e6f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e75:	50                   	push   %eax
80105e76:	e8 05 f1 ff ff       	call   80104f80 <memset>
80105e7b:	83 c4 10             	add    $0x10,%esp
80105e7e:	eb 2c                	jmp    80105eac <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105e80:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e86:	85 c0                	test   %eax,%eax
80105e88:	74 56                	je     80105ee0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e8a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e90:	83 ec 08             	sub    $0x8,%esp
80105e93:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e96:	52                   	push   %edx
80105e97:	50                   	push   %eax
80105e98:	e8 73 f3 ff ff       	call   80105210 <fetchstr>
80105e9d:	83 c4 10             	add    $0x10,%esp
80105ea0:	85 c0                	test   %eax,%eax
80105ea2:	78 28                	js     80105ecc <sys_exec+0xac>
  for(i=0;; i++){
80105ea4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105ea7:	83 fb 20             	cmp    $0x20,%ebx
80105eaa:	74 20                	je     80105ecc <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105eac:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105eb2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105eb9:	83 ec 08             	sub    $0x8,%esp
80105ebc:	57                   	push   %edi
80105ebd:	01 f0                	add    %esi,%eax
80105ebf:	50                   	push   %eax
80105ec0:	e8 0b f3 ff ff       	call   801051d0 <fetchint>
80105ec5:	83 c4 10             	add    $0x10,%esp
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	79 b4                	jns    80105e80 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105ecf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed4:	5b                   	pop    %ebx
80105ed5:	5e                   	pop    %esi
80105ed6:	5f                   	pop    %edi
80105ed7:	5d                   	pop    %ebp
80105ed8:	c3                   	ret    
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105ee0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105ee6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105ee9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105ef0:	00 00 00 00 
  return exec(path, argv);
80105ef4:	50                   	push   %eax
80105ef5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105efb:	e8 10 ab ff ff       	call   80100a10 <exec>
80105f00:	83 c4 10             	add    $0x10,%esp
}
80105f03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f06:	5b                   	pop    %ebx
80105f07:	5e                   	pop    %esi
80105f08:	5f                   	pop    %edi
80105f09:	5d                   	pop    %ebp
80105f0a:	c3                   	ret    
80105f0b:	90                   	nop
80105f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f10 <sys_pipe>:

int
sys_pipe(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	57                   	push   %edi
80105f14:	56                   	push   %esi
80105f15:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f16:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105f19:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105f1c:	6a 08                	push   $0x8
80105f1e:	50                   	push   %eax
80105f1f:	6a 00                	push   $0x0
80105f21:	e8 aa f3 ff ff       	call   801052d0 <argptr>
80105f26:	83 c4 10             	add    $0x10,%esp
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	0f 88 ae 00 00 00    	js     80105fdf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105f31:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f34:	83 ec 08             	sub    $0x8,%esp
80105f37:	50                   	push   %eax
80105f38:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105f3b:	50                   	push   %eax
80105f3c:	e8 9f db ff ff       	call   80103ae0 <pipealloc>
80105f41:	83 c4 10             	add    $0x10,%esp
80105f44:	85 c0                	test   %eax,%eax
80105f46:	0f 88 93 00 00 00    	js     80105fdf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f4c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105f4f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105f51:	e8 0a e2 ff ff       	call   80104160 <myproc>
80105f56:	eb 10                	jmp    80105f68 <sys_pipe+0x58>
80105f58:	90                   	nop
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105f60:	83 c3 01             	add    $0x1,%ebx
80105f63:	83 fb 10             	cmp    $0x10,%ebx
80105f66:	74 60                	je     80105fc8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105f68:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105f6c:	85 f6                	test   %esi,%esi
80105f6e:	75 f0                	jne    80105f60 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105f70:	8d 73 08             	lea    0x8(%ebx),%esi
80105f73:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f7a:	e8 e1 e1 ff ff       	call   80104160 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f7f:	31 d2                	xor    %edx,%edx
80105f81:	eb 0d                	jmp    80105f90 <sys_pipe+0x80>
80105f83:	90                   	nop
80105f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f88:	83 c2 01             	add    $0x1,%edx
80105f8b:	83 fa 10             	cmp    $0x10,%edx
80105f8e:	74 28                	je     80105fb8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105f90:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f94:	85 c9                	test   %ecx,%ecx
80105f96:	75 f0                	jne    80105f88 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105f98:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f9f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105fa1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105fa4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105fa7:	31 c0                	xor    %eax,%eax
}
80105fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fac:	5b                   	pop    %ebx
80105fad:	5e                   	pop    %esi
80105fae:	5f                   	pop    %edi
80105faf:	5d                   	pop    %ebp
80105fb0:	c3                   	ret    
80105fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105fb8:	e8 a3 e1 ff ff       	call   80104160 <myproc>
80105fbd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105fc4:	00 
80105fc5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	ff 75 e0             	pushl  -0x20(%ebp)
80105fce:	e8 0d b1 ff ff       	call   801010e0 <fileclose>
    fileclose(wf);
80105fd3:	58                   	pop    %eax
80105fd4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105fd7:	e8 04 b1 ff ff       	call   801010e0 <fileclose>
    return -1;
80105fdc:	83 c4 10             	add    $0x10,%esp
80105fdf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe4:	eb c3                	jmp    80105fa9 <sys_pipe+0x99>
80105fe6:	66 90                	xchg   %ax,%ax
80105fe8:	66 90                	xchg   %ax,%ax
80105fea:	66 90                	xchg   %ax,%ax
80105fec:	66 90                	xchg   %ax,%ax
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105ff3:	5d                   	pop    %ebp
  return fork();
80105ff4:	e9 17 e3 ff ff       	jmp    80104310 <fork>
80105ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_exit>:

int
sys_exit(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 08             	sub    $0x8,%esp
  exit();
80106006:	e8 85 e6 ff ff       	call   80104690 <exit>
  return 0;  // not reached
}
8010600b:	31 c0                	xor    %eax,%eax
8010600d:	c9                   	leave  
8010600e:	c3                   	ret    
8010600f:	90                   	nop

80106010 <sys_wait>:

int
sys_wait(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106013:	5d                   	pop    %ebp
  return wait();
80106014:	e9 e7 e8 ff ff       	jmp    80104900 <wait>
80106019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106020 <sys_kill>:

int
sys_kill(void)
{
80106020:	55                   	push   %ebp
80106021:	89 e5                	mov    %esp,%ebp
80106023:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106026:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106029:	50                   	push   %eax
8010602a:	6a 00                	push   $0x0
8010602c:	e8 4f f2 ff ff       	call   80105280 <argint>
80106031:	83 c4 10             	add    $0x10,%esp
80106034:	85 c0                	test   %eax,%eax
80106036:	78 18                	js     80106050 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106038:	83 ec 0c             	sub    $0xc,%esp
8010603b:	ff 75 f4             	pushl  -0xc(%ebp)
8010603e:	e8 4d ea ff ff       	call   80104a90 <kill>
80106043:	83 c4 10             	add    $0x10,%esp
}
80106046:	c9                   	leave  
80106047:	c3                   	ret    
80106048:	90                   	nop
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106055:	c9                   	leave  
80106056:	c3                   	ret    
80106057:	89 f6                	mov    %esi,%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106060 <sys_getpid>:

int
sys_getpid(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106066:	e8 f5 e0 ff ff       	call   80104160 <myproc>
8010606b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010606e:	c9                   	leave  
8010606f:	c3                   	ret    

80106070 <sys_sbrk>:

int
sys_sbrk(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106074:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106077:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010607a:	50                   	push   %eax
8010607b:	6a 00                	push   $0x0
8010607d:	e8 fe f1 ff ff       	call   80105280 <argint>
80106082:	83 c4 10             	add    $0x10,%esp
80106085:	85 c0                	test   %eax,%eax
80106087:	78 27                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106089:	e8 d2 e0 ff ff       	call   80104160 <myproc>
  if(growproc(n) < 0)
8010608e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106091:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106093:	ff 75 f4             	pushl  -0xc(%ebp)
80106096:	e8 e5 e1 ff ff       	call   80104280 <growproc>
8010609b:	83 c4 10             	add    $0x10,%esp
8010609e:	85 c0                	test   %eax,%eax
801060a0:	78 0e                	js     801060b0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801060a2:	89 d8                	mov    %ebx,%eax
801060a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060a7:	c9                   	leave  
801060a8:	c3                   	ret    
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060b0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801060b5:	eb eb                	jmp    801060a2 <sys_sbrk+0x32>
801060b7:	89 f6                	mov    %esi,%esi
801060b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801060c0 <sys_sleep>:

int
sys_sleep(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801060c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801060c7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801060ca:	50                   	push   %eax
801060cb:	6a 00                	push   $0x0
801060cd:	e8 ae f1 ff ff       	call   80105280 <argint>
801060d2:	83 c4 10             	add    $0x10,%esp
801060d5:	85 c0                	test   %eax,%eax
801060d7:	0f 88 8a 00 00 00    	js     80106167 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060dd:	83 ec 0c             	sub    $0xc,%esp
801060e0:	68 a0 13 19 80       	push   $0x801913a0
801060e5:	e8 86 ed ff ff       	call   80104e70 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060ed:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801060f0:	8b 1d e0 1b 19 80    	mov    0x80191be0,%ebx
  while(ticks - ticks0 < n){
801060f6:	85 d2                	test   %edx,%edx
801060f8:	75 27                	jne    80106121 <sys_sleep+0x61>
801060fa:	eb 54                	jmp    80106150 <sys_sleep+0x90>
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106100:	83 ec 08             	sub    $0x8,%esp
80106103:	68 a0 13 19 80       	push   $0x801913a0
80106108:	68 e0 1b 19 80       	push   $0x80191be0
8010610d:	e8 2e e7 ff ff       	call   80104840 <sleep>
  while(ticks - ticks0 < n){
80106112:	a1 e0 1b 19 80       	mov    0x80191be0,%eax
80106117:	83 c4 10             	add    $0x10,%esp
8010611a:	29 d8                	sub    %ebx,%eax
8010611c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010611f:	73 2f                	jae    80106150 <sys_sleep+0x90>
    if(myproc()->killed){
80106121:	e8 3a e0 ff ff       	call   80104160 <myproc>
80106126:	8b 40 24             	mov    0x24(%eax),%eax
80106129:	85 c0                	test   %eax,%eax
8010612b:	74 d3                	je     80106100 <sys_sleep+0x40>
      release(&tickslock);
8010612d:	83 ec 0c             	sub    $0xc,%esp
80106130:	68 a0 13 19 80       	push   $0x801913a0
80106135:	e8 f6 ed ff ff       	call   80104f30 <release>
      return -1;
8010613a:	83 c4 10             	add    $0x10,%esp
8010613d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106145:	c9                   	leave  
80106146:	c3                   	ret    
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	68 a0 13 19 80       	push   $0x801913a0
80106158:	e8 d3 ed ff ff       	call   80104f30 <release>
  return 0;
8010615d:	83 c4 10             	add    $0x10,%esp
80106160:	31 c0                	xor    %eax,%eax
}
80106162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106165:	c9                   	leave  
80106166:	c3                   	ret    
    return -1;
80106167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010616c:	eb f4                	jmp    80106162 <sys_sleep+0xa2>
8010616e:	66 90                	xchg   %ax,%ax

80106170 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	53                   	push   %ebx
80106174:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106177:	68 a0 13 19 80       	push   $0x801913a0
8010617c:	e8 ef ec ff ff       	call   80104e70 <acquire>
  xticks = ticks;
80106181:	8b 1d e0 1b 19 80    	mov    0x80191be0,%ebx
  release(&tickslock);
80106187:	c7 04 24 a0 13 19 80 	movl   $0x801913a0,(%esp)
8010618e:	e8 9d ed ff ff       	call   80104f30 <release>
  return xticks;
}
80106193:	89 d8                	mov    %ebx,%eax
80106195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106198:	c9                   	leave  
80106199:	c3                   	ret    
8010619a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061a0 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
801061a6:	e8 b5 df ff ff       	call   80104160 <myproc>
801061ab:	ba 10 00 00 00       	mov    $0x10,%edx
801061b0:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
801061b6:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
801061b7:	89 d0                	mov    %edx,%eax
}
801061b9:	c3                   	ret    
801061ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801061c0 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
801061c0:	55                   	push   %ebp
801061c1:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
801061c3:	5d                   	pop    %ebp
  return getTotalFreePages();
801061c4:	e9 17 ea ff ff       	jmp    80104be0 <getTotalFreePages>

801061c9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801061c9:	1e                   	push   %ds
  pushl %es
801061ca:	06                   	push   %es
  pushl %fs
801061cb:	0f a0                	push   %fs
  pushl %gs
801061cd:	0f a8                	push   %gs
  pushal
801061cf:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801061d0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801061d4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801061d6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801061d8:	54                   	push   %esp
  call trap
801061d9:	e8 c2 00 00 00       	call   801062a0 <trap>
  addl $4, %esp
801061de:	83 c4 04             	add    $0x4,%esp

801061e1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801061e1:	61                   	popa   
  popl %gs
801061e2:	0f a9                	pop    %gs
  popl %fs
801061e4:	0f a1                	pop    %fs
  popl %es
801061e6:	07                   	pop    %es
  popl %ds
801061e7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801061e8:	83 c4 08             	add    $0x8,%esp
  iret
801061eb:	cf                   	iret   
801061ec:	66 90                	xchg   %ax,%ax
801061ee:	66 90                	xchg   %ax,%ax

801061f0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801061f0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801061f1:	31 c0                	xor    %eax,%eax
{
801061f3:	89 e5                	mov    %esp,%ebp
801061f5:	83 ec 08             	sub    $0x8,%esp
801061f8:	90                   	nop
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106200:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106207:	c7 04 c5 e2 13 19 80 	movl   $0x8e000008,-0x7fe6ec1e(,%eax,8)
8010620e:	08 00 00 8e 
80106212:	66 89 14 c5 e0 13 19 	mov    %dx,-0x7fe6ec20(,%eax,8)
80106219:	80 
8010621a:	c1 ea 10             	shr    $0x10,%edx
8010621d:	66 89 14 c5 e6 13 19 	mov    %dx,-0x7fe6ec1a(,%eax,8)
80106224:	80 
  for(i = 0; i < 256; i++)
80106225:	83 c0 01             	add    $0x1,%eax
80106228:	3d 00 01 00 00       	cmp    $0x100,%eax
8010622d:	75 d1                	jne    80106200 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010622f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106234:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106237:	c7 05 e2 15 19 80 08 	movl   $0xef000008,0x801915e2
8010623e:	00 00 ef 
  initlock(&tickslock, "time");
80106241:	68 dd 8b 10 80       	push   $0x80108bdd
80106246:	68 a0 13 19 80       	push   $0x801913a0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010624b:	66 a3 e0 15 19 80    	mov    %ax,0x801915e0
80106251:	c1 e8 10             	shr    $0x10,%eax
80106254:	66 a3 e6 15 19 80    	mov    %ax,0x801915e6
  initlock(&tickslock, "time");
8010625a:	e8 d1 ea ff ff       	call   80104d30 <initlock>
}
8010625f:	83 c4 10             	add    $0x10,%esp
80106262:	c9                   	leave  
80106263:	c3                   	ret    
80106264:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010626a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106270 <idtinit>:

void
idtinit(void)
{
80106270:	55                   	push   %ebp
  pd[0] = size-1;
80106271:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106276:	89 e5                	mov    %esp,%ebp
80106278:	83 ec 10             	sub    $0x10,%esp
8010627b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010627f:	b8 e0 13 19 80       	mov    $0x801913e0,%eax
80106284:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106288:	c1 e8 10             	shr    $0x10,%eax
8010628b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010628f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106292:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106295:	c9                   	leave  
80106296:	c3                   	ret    
80106297:	89 f6                	mov    %esi,%esi
80106299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801062a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	57                   	push   %edi
801062a4:	56                   	push   %esi
801062a5:	53                   	push   %ebx
801062a6:	83 ec 1c             	sub    $0x1c,%esp
801062a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
801062ac:	e8 af de ff ff       	call   80104160 <myproc>
  if(tf->trapno == T_SYSCALL){
801062b1:	8b 57 30             	mov    0x30(%edi),%edx
801062b4:	83 fa 40             	cmp    $0x40,%edx
801062b7:	0f 84 eb 00 00 00    	je     801063a8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801062bd:	83 ea 0e             	sub    $0xe,%edx
801062c0:	83 fa 31             	cmp    $0x31,%edx
801062c3:	77 0b                	ja     801062d0 <trap+0x30>
801062c5:	ff 24 95 84 8c 10 80 	jmp    *-0x7fef737c(,%edx,4)
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801062d0:	e8 8b de ff ff       	call   80104160 <myproc>
801062d5:	85 c0                	test   %eax,%eax
801062d7:	0f 84 07 02 00 00    	je     801064e4 <trap+0x244>
801062dd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801062e1:	0f 84 fd 01 00 00    	je     801064e4 <trap+0x244>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801062e7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801062ea:	8b 57 38             	mov    0x38(%edi),%edx
801062ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801062f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801062f3:	e8 48 de ff ff       	call   80104140 <cpuid>
801062f8:	8b 77 34             	mov    0x34(%edi),%esi
801062fb:	8b 5f 30             	mov    0x30(%edi),%ebx
801062fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106301:	e8 5a de ff ff       	call   80104160 <myproc>
80106306:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106309:	e8 52 de ff ff       	call   80104160 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010630e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106311:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106314:	51                   	push   %ecx
80106315:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106316:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106319:	ff 75 e4             	pushl  -0x1c(%ebp)
8010631c:	56                   	push   %esi
8010631d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010631e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106321:	52                   	push   %edx
80106322:	ff 70 10             	pushl  0x10(%eax)
80106325:	68 40 8c 10 80       	push   $0x80108c40
8010632a:	e8 31 a3 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010632f:	83 c4 20             	add    $0x20,%esp
80106332:	e8 29 de ff ff       	call   80104160 <myproc>
80106337:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010633e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106340:	e8 1b de ff ff       	call   80104160 <myproc>
80106345:	85 c0                	test   %eax,%eax
80106347:	74 1d                	je     80106366 <trap+0xc6>
80106349:	e8 12 de ff ff       	call   80104160 <myproc>
8010634e:	8b 50 24             	mov    0x24(%eax),%edx
80106351:	85 d2                	test   %edx,%edx
80106353:	74 11                	je     80106366 <trap+0xc6>
80106355:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106359:	83 e0 03             	and    $0x3,%eax
8010635c:	66 83 f8 03          	cmp    $0x3,%ax
80106360:	0f 84 3a 01 00 00    	je     801064a0 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106366:	e8 f5 dd ff ff       	call   80104160 <myproc>
8010636b:	85 c0                	test   %eax,%eax
8010636d:	74 0b                	je     8010637a <trap+0xda>
8010636f:	e8 ec dd ff ff       	call   80104160 <myproc>
80106374:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106378:	74 5e                	je     801063d8 <trap+0x138>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010637a:	e8 e1 dd ff ff       	call   80104160 <myproc>
8010637f:	85 c0                	test   %eax,%eax
80106381:	74 19                	je     8010639c <trap+0xfc>
80106383:	e8 d8 dd ff ff       	call   80104160 <myproc>
80106388:	8b 40 24             	mov    0x24(%eax),%eax
8010638b:	85 c0                	test   %eax,%eax
8010638d:	74 0d                	je     8010639c <trap+0xfc>
8010638f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106393:	83 e0 03             	and    $0x3,%eax
80106396:	66 83 f8 03          	cmp    $0x3,%ax
8010639a:	74 2b                	je     801063c7 <trap+0x127>
    exit();
}
8010639c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010639f:	5b                   	pop    %ebx
801063a0:	5e                   	pop    %esi
801063a1:	5f                   	pop    %edi
801063a2:	5d                   	pop    %ebp
801063a3:	c3                   	ret    
801063a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
801063a8:	8b 58 24             	mov    0x24(%eax),%ebx
801063ab:	85 db                	test   %ebx,%ebx
801063ad:	0f 85 dd 00 00 00    	jne    80106490 <trap+0x1f0>
    curproc->tf = tf;
801063b3:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801063b6:	e8 b5 ef ff ff       	call   80105370 <syscall>
    if(myproc()->killed)
801063bb:	e8 a0 dd ff ff       	call   80104160 <myproc>
801063c0:	8b 48 24             	mov    0x24(%eax),%ecx
801063c3:	85 c9                	test   %ecx,%ecx
801063c5:	74 d5                	je     8010639c <trap+0xfc>
}
801063c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063ca:	5b                   	pop    %ebx
801063cb:	5e                   	pop    %esi
801063cc:	5f                   	pop    %edi
801063cd:	5d                   	pop    %ebp
      exit();
801063ce:	e9 bd e2 ff ff       	jmp    80104690 <exit>
801063d3:	90                   	nop
801063d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801063d8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801063dc:	75 9c                	jne    8010637a <trap+0xda>
    yield();
801063de:	e8 0d e4 ff ff       	call   801047f0 <yield>
801063e3:	eb 95                	jmp    8010637a <trap+0xda>
801063e5:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
801063e8:	e8 73 dd ff ff       	call   80104160 <myproc>
801063ed:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801063f1:	0f 8e 49 ff ff ff    	jle    80106340 <trap+0xa0>
    pagefault();
801063f7:	e8 24 19 00 00       	call   80107d20 <pagefault>
801063fc:	e9 3f ff ff ff       	jmp    80106340 <trap+0xa0>
80106401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106408:	e8 33 dd ff ff       	call   80104140 <cpuid>
8010640d:	85 c0                	test   %eax,%eax
8010640f:	0f 84 9b 00 00 00    	je     801064b0 <trap+0x210>
    lapiceoi();
80106415:	e8 d6 cb ff ff       	call   80102ff0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010641a:	e8 41 dd ff ff       	call   80104160 <myproc>
8010641f:	85 c0                	test   %eax,%eax
80106421:	0f 85 22 ff ff ff    	jne    80106349 <trap+0xa9>
80106427:	e9 3a ff ff ff       	jmp    80106366 <trap+0xc6>
8010642c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106430:	e8 7b ca ff ff       	call   80102eb0 <kbdintr>
    lapiceoi();
80106435:	e8 b6 cb ff ff       	call   80102ff0 <lapiceoi>
    break;
8010643a:	e9 01 ff ff ff       	jmp    80106340 <trap+0xa0>
8010643f:	90                   	nop
    uartintr();
80106440:	e8 3b 02 00 00       	call   80106680 <uartintr>
    lapiceoi();
80106445:	e8 a6 cb ff ff       	call   80102ff0 <lapiceoi>
    break;
8010644a:	e9 f1 fe ff ff       	jmp    80106340 <trap+0xa0>
8010644f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106450:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106454:	8b 77 38             	mov    0x38(%edi),%esi
80106457:	e8 e4 dc ff ff       	call   80104140 <cpuid>
8010645c:	56                   	push   %esi
8010645d:	53                   	push   %ebx
8010645e:	50                   	push   %eax
8010645f:	68 e8 8b 10 80       	push   $0x80108be8
80106464:	e8 f7 a1 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106469:	e8 82 cb ff ff       	call   80102ff0 <lapiceoi>
    break;
8010646e:	83 c4 10             	add    $0x10,%esp
80106471:	e9 ca fe ff ff       	jmp    80106340 <trap+0xa0>
80106476:	8d 76 00             	lea    0x0(%esi),%esi
80106479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106480:	e8 2b c2 ff ff       	call   801026b0 <ideintr>
80106485:	eb 8e                	jmp    80106415 <trap+0x175>
80106487:	89 f6                	mov    %esi,%esi
80106489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      exit();
80106493:	e8 f8 e1 ff ff       	call   80104690 <exit>
80106498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010649b:	e9 13 ff ff ff       	jmp    801063b3 <trap+0x113>
    exit();
801064a0:	e8 eb e1 ff ff       	call   80104690 <exit>
801064a5:	e9 bc fe ff ff       	jmp    80106366 <trap+0xc6>
801064aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	68 a0 13 19 80       	push   $0x801913a0
801064b8:	e8 b3 e9 ff ff       	call   80104e70 <acquire>
      wakeup(&ticks);
801064bd:	c7 04 24 e0 1b 19 80 	movl   $0x80191be0,(%esp)
      ticks++;
801064c4:	83 05 e0 1b 19 80 01 	addl   $0x1,0x80191be0
      wakeup(&ticks);
801064cb:	e8 60 e5 ff ff       	call   80104a30 <wakeup>
      release(&tickslock);
801064d0:	c7 04 24 a0 13 19 80 	movl   $0x801913a0,(%esp)
801064d7:	e8 54 ea ff ff       	call   80104f30 <release>
801064dc:	83 c4 10             	add    $0x10,%esp
801064df:	e9 31 ff ff ff       	jmp    80106415 <trap+0x175>
801064e4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064e7:	8b 5f 38             	mov    0x38(%edi),%ebx
801064ea:	e8 51 dc ff ff       	call   80104140 <cpuid>
801064ef:	83 ec 0c             	sub    $0xc,%esp
801064f2:	56                   	push   %esi
801064f3:	53                   	push   %ebx
801064f4:	50                   	push   %eax
801064f5:	ff 77 30             	pushl  0x30(%edi)
801064f8:	68 0c 8c 10 80       	push   $0x80108c0c
801064fd:	e8 5e a1 ff ff       	call   80100660 <cprintf>
      panic("trap");
80106502:	83 c4 14             	add    $0x14,%esp
80106505:	68 e2 8b 10 80       	push   $0x80108be2
8010650a:	e8 81 9e ff ff       	call   80100390 <panic>
8010650f:	90                   	nop

80106510 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106510:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
{
80106515:	55                   	push   %ebp
80106516:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106518:	85 c0                	test   %eax,%eax
8010651a:	74 1c                	je     80106538 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010651c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106521:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106522:	a8 01                	test   $0x1,%al
80106524:	74 12                	je     80106538 <uartgetc+0x28>
80106526:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010652b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010652c:	0f b6 c0             	movzbl %al,%eax
}
8010652f:	5d                   	pop    %ebp
80106530:	c3                   	ret    
80106531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106538:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010653d:	5d                   	pop    %ebp
8010653e:	c3                   	ret    
8010653f:	90                   	nop

80106540 <uartputc.part.0>:
uartputc(int c)
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
80106543:	57                   	push   %edi
80106544:	56                   	push   %esi
80106545:	53                   	push   %ebx
80106546:	89 c7                	mov    %eax,%edi
80106548:	bb 80 00 00 00       	mov    $0x80,%ebx
8010654d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106552:	83 ec 0c             	sub    $0xc,%esp
80106555:	eb 1b                	jmp    80106572 <uartputc.part.0+0x32>
80106557:	89 f6                	mov    %esi,%esi
80106559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106560:	83 ec 0c             	sub    $0xc,%esp
80106563:	6a 0a                	push   $0xa
80106565:	e8 a6 ca ff ff       	call   80103010 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010656a:	83 c4 10             	add    $0x10,%esp
8010656d:	83 eb 01             	sub    $0x1,%ebx
80106570:	74 07                	je     80106579 <uartputc.part.0+0x39>
80106572:	89 f2                	mov    %esi,%edx
80106574:	ec                   	in     (%dx),%al
80106575:	a8 20                	test   $0x20,%al
80106577:	74 e7                	je     80106560 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106579:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010657e:	89 f8                	mov    %edi,%eax
80106580:	ee                   	out    %al,(%dx)
}
80106581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106584:	5b                   	pop    %ebx
80106585:	5e                   	pop    %esi
80106586:	5f                   	pop    %edi
80106587:	5d                   	pop    %ebp
80106588:	c3                   	ret    
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106590 <uartinit>:
{
80106590:	55                   	push   %ebp
80106591:	31 c9                	xor    %ecx,%ecx
80106593:	89 c8                	mov    %ecx,%eax
80106595:	89 e5                	mov    %esp,%ebp
80106597:	57                   	push   %edi
80106598:	56                   	push   %esi
80106599:	53                   	push   %ebx
8010659a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010659f:	89 da                	mov    %ebx,%edx
801065a1:	83 ec 0c             	sub    $0xc,%esp
801065a4:	ee                   	out    %al,(%dx)
801065a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801065aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801065af:	89 fa                	mov    %edi,%edx
801065b1:	ee                   	out    %al,(%dx)
801065b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801065b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065bc:	ee                   	out    %al,(%dx)
801065bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801065c2:	89 c8                	mov    %ecx,%eax
801065c4:	89 f2                	mov    %esi,%edx
801065c6:	ee                   	out    %al,(%dx)
801065c7:	b8 03 00 00 00       	mov    $0x3,%eax
801065cc:	89 fa                	mov    %edi,%edx
801065ce:	ee                   	out    %al,(%dx)
801065cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801065d4:	89 c8                	mov    %ecx,%eax
801065d6:	ee                   	out    %al,(%dx)
801065d7:	b8 01 00 00 00       	mov    $0x1,%eax
801065dc:	89 f2                	mov    %esi,%edx
801065de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801065df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801065e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801065e5:	3c ff                	cmp    $0xff,%al
801065e7:	74 5a                	je     80106643 <uartinit+0xb3>
  uart = 1;
801065e9:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
801065f0:	00 00 00 
801065f3:	89 da                	mov    %ebx,%edx
801065f5:	ec                   	in     (%dx),%al
801065f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801065fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801065ff:	bb 4c 8d 10 80       	mov    $0x80108d4c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106604:	6a 00                	push   $0x0
80106606:	6a 04                	push   $0x4
80106608:	e8 f3 c2 ff ff       	call   80102900 <ioapicenable>
8010660d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106610:	b8 78 00 00 00       	mov    $0x78,%eax
80106615:	eb 13                	jmp    8010662a <uartinit+0x9a>
80106617:	89 f6                	mov    %esi,%esi
80106619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106620:	83 c3 01             	add    $0x1,%ebx
80106623:	0f be 03             	movsbl (%ebx),%eax
80106626:	84 c0                	test   %al,%al
80106628:	74 19                	je     80106643 <uartinit+0xb3>
  if(!uart)
8010662a:	8b 15 e0 d5 10 80    	mov    0x8010d5e0,%edx
80106630:	85 d2                	test   %edx,%edx
80106632:	74 ec                	je     80106620 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106634:	83 c3 01             	add    $0x1,%ebx
80106637:	e8 04 ff ff ff       	call   80106540 <uartputc.part.0>
8010663c:	0f be 03             	movsbl (%ebx),%eax
8010663f:	84 c0                	test   %al,%al
80106641:	75 e7                	jne    8010662a <uartinit+0x9a>
}
80106643:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106646:	5b                   	pop    %ebx
80106647:	5e                   	pop    %esi
80106648:	5f                   	pop    %edi
80106649:	5d                   	pop    %ebp
8010664a:	c3                   	ret    
8010664b:	90                   	nop
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106650 <uartputc>:
  if(!uart)
80106650:	8b 15 e0 d5 10 80    	mov    0x8010d5e0,%edx
{
80106656:	55                   	push   %ebp
80106657:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106659:	85 d2                	test   %edx,%edx
{
8010665b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010665e:	74 10                	je     80106670 <uartputc+0x20>
}
80106660:	5d                   	pop    %ebp
80106661:	e9 da fe ff ff       	jmp    80106540 <uartputc.part.0>
80106666:	8d 76 00             	lea    0x0(%esi),%esi
80106669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106670:	5d                   	pop    %ebp
80106671:	c3                   	ret    
80106672:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106680 <uartintr>:

void
uartintr(void)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106686:	68 10 65 10 80       	push   $0x80106510
8010668b:	e8 80 a1 ff ff       	call   80100810 <consoleintr>
}
80106690:	83 c4 10             	add    $0x10,%esp
80106693:	c9                   	leave  
80106694:	c3                   	ret    

80106695 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106695:	6a 00                	push   $0x0
  pushl $0
80106697:	6a 00                	push   $0x0
  jmp alltraps
80106699:	e9 2b fb ff ff       	jmp    801061c9 <alltraps>

8010669e <vector1>:
.globl vector1
vector1:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $1
801066a0:	6a 01                	push   $0x1
  jmp alltraps
801066a2:	e9 22 fb ff ff       	jmp    801061c9 <alltraps>

801066a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $2
801066a9:	6a 02                	push   $0x2
  jmp alltraps
801066ab:	e9 19 fb ff ff       	jmp    801061c9 <alltraps>

801066b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801066b0:	6a 00                	push   $0x0
  pushl $3
801066b2:	6a 03                	push   $0x3
  jmp alltraps
801066b4:	e9 10 fb ff ff       	jmp    801061c9 <alltraps>

801066b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801066b9:	6a 00                	push   $0x0
  pushl $4
801066bb:	6a 04                	push   $0x4
  jmp alltraps
801066bd:	e9 07 fb ff ff       	jmp    801061c9 <alltraps>

801066c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $5
801066c4:	6a 05                	push   $0x5
  jmp alltraps
801066c6:	e9 fe fa ff ff       	jmp    801061c9 <alltraps>

801066cb <vector6>:
.globl vector6
vector6:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $6
801066cd:	6a 06                	push   $0x6
  jmp alltraps
801066cf:	e9 f5 fa ff ff       	jmp    801061c9 <alltraps>

801066d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066d4:	6a 00                	push   $0x0
  pushl $7
801066d6:	6a 07                	push   $0x7
  jmp alltraps
801066d8:	e9 ec fa ff ff       	jmp    801061c9 <alltraps>

801066dd <vector8>:
.globl vector8
vector8:
  pushl $8
801066dd:	6a 08                	push   $0x8
  jmp alltraps
801066df:	e9 e5 fa ff ff       	jmp    801061c9 <alltraps>

801066e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $9
801066e6:	6a 09                	push   $0x9
  jmp alltraps
801066e8:	e9 dc fa ff ff       	jmp    801061c9 <alltraps>

801066ed <vector10>:
.globl vector10
vector10:
  pushl $10
801066ed:	6a 0a                	push   $0xa
  jmp alltraps
801066ef:	e9 d5 fa ff ff       	jmp    801061c9 <alltraps>

801066f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066f4:	6a 0b                	push   $0xb
  jmp alltraps
801066f6:	e9 ce fa ff ff       	jmp    801061c9 <alltraps>

801066fb <vector12>:
.globl vector12
vector12:
  pushl $12
801066fb:	6a 0c                	push   $0xc
  jmp alltraps
801066fd:	e9 c7 fa ff ff       	jmp    801061c9 <alltraps>

80106702 <vector13>:
.globl vector13
vector13:
  pushl $13
80106702:	6a 0d                	push   $0xd
  jmp alltraps
80106704:	e9 c0 fa ff ff       	jmp    801061c9 <alltraps>

80106709 <vector14>:
.globl vector14
vector14:
  pushl $14
80106709:	6a 0e                	push   $0xe
  jmp alltraps
8010670b:	e9 b9 fa ff ff       	jmp    801061c9 <alltraps>

80106710 <vector15>:
.globl vector15
vector15:
  pushl $0
80106710:	6a 00                	push   $0x0
  pushl $15
80106712:	6a 0f                	push   $0xf
  jmp alltraps
80106714:	e9 b0 fa ff ff       	jmp    801061c9 <alltraps>

80106719 <vector16>:
.globl vector16
vector16:
  pushl $0
80106719:	6a 00                	push   $0x0
  pushl $16
8010671b:	6a 10                	push   $0x10
  jmp alltraps
8010671d:	e9 a7 fa ff ff       	jmp    801061c9 <alltraps>

80106722 <vector17>:
.globl vector17
vector17:
  pushl $17
80106722:	6a 11                	push   $0x11
  jmp alltraps
80106724:	e9 a0 fa ff ff       	jmp    801061c9 <alltraps>

80106729 <vector18>:
.globl vector18
vector18:
  pushl $0
80106729:	6a 00                	push   $0x0
  pushl $18
8010672b:	6a 12                	push   $0x12
  jmp alltraps
8010672d:	e9 97 fa ff ff       	jmp    801061c9 <alltraps>

80106732 <vector19>:
.globl vector19
vector19:
  pushl $0
80106732:	6a 00                	push   $0x0
  pushl $19
80106734:	6a 13                	push   $0x13
  jmp alltraps
80106736:	e9 8e fa ff ff       	jmp    801061c9 <alltraps>

8010673b <vector20>:
.globl vector20
vector20:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $20
8010673d:	6a 14                	push   $0x14
  jmp alltraps
8010673f:	e9 85 fa ff ff       	jmp    801061c9 <alltraps>

80106744 <vector21>:
.globl vector21
vector21:
  pushl $0
80106744:	6a 00                	push   $0x0
  pushl $21
80106746:	6a 15                	push   $0x15
  jmp alltraps
80106748:	e9 7c fa ff ff       	jmp    801061c9 <alltraps>

8010674d <vector22>:
.globl vector22
vector22:
  pushl $0
8010674d:	6a 00                	push   $0x0
  pushl $22
8010674f:	6a 16                	push   $0x16
  jmp alltraps
80106751:	e9 73 fa ff ff       	jmp    801061c9 <alltraps>

80106756 <vector23>:
.globl vector23
vector23:
  pushl $0
80106756:	6a 00                	push   $0x0
  pushl $23
80106758:	6a 17                	push   $0x17
  jmp alltraps
8010675a:	e9 6a fa ff ff       	jmp    801061c9 <alltraps>

8010675f <vector24>:
.globl vector24
vector24:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $24
80106761:	6a 18                	push   $0x18
  jmp alltraps
80106763:	e9 61 fa ff ff       	jmp    801061c9 <alltraps>

80106768 <vector25>:
.globl vector25
vector25:
  pushl $0
80106768:	6a 00                	push   $0x0
  pushl $25
8010676a:	6a 19                	push   $0x19
  jmp alltraps
8010676c:	e9 58 fa ff ff       	jmp    801061c9 <alltraps>

80106771 <vector26>:
.globl vector26
vector26:
  pushl $0
80106771:	6a 00                	push   $0x0
  pushl $26
80106773:	6a 1a                	push   $0x1a
  jmp alltraps
80106775:	e9 4f fa ff ff       	jmp    801061c9 <alltraps>

8010677a <vector27>:
.globl vector27
vector27:
  pushl $0
8010677a:	6a 00                	push   $0x0
  pushl $27
8010677c:	6a 1b                	push   $0x1b
  jmp alltraps
8010677e:	e9 46 fa ff ff       	jmp    801061c9 <alltraps>

80106783 <vector28>:
.globl vector28
vector28:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $28
80106785:	6a 1c                	push   $0x1c
  jmp alltraps
80106787:	e9 3d fa ff ff       	jmp    801061c9 <alltraps>

8010678c <vector29>:
.globl vector29
vector29:
  pushl $0
8010678c:	6a 00                	push   $0x0
  pushl $29
8010678e:	6a 1d                	push   $0x1d
  jmp alltraps
80106790:	e9 34 fa ff ff       	jmp    801061c9 <alltraps>

80106795 <vector30>:
.globl vector30
vector30:
  pushl $0
80106795:	6a 00                	push   $0x0
  pushl $30
80106797:	6a 1e                	push   $0x1e
  jmp alltraps
80106799:	e9 2b fa ff ff       	jmp    801061c9 <alltraps>

8010679e <vector31>:
.globl vector31
vector31:
  pushl $0
8010679e:	6a 00                	push   $0x0
  pushl $31
801067a0:	6a 1f                	push   $0x1f
  jmp alltraps
801067a2:	e9 22 fa ff ff       	jmp    801061c9 <alltraps>

801067a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $32
801067a9:	6a 20                	push   $0x20
  jmp alltraps
801067ab:	e9 19 fa ff ff       	jmp    801061c9 <alltraps>

801067b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801067b0:	6a 00                	push   $0x0
  pushl $33
801067b2:	6a 21                	push   $0x21
  jmp alltraps
801067b4:	e9 10 fa ff ff       	jmp    801061c9 <alltraps>

801067b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801067b9:	6a 00                	push   $0x0
  pushl $34
801067bb:	6a 22                	push   $0x22
  jmp alltraps
801067bd:	e9 07 fa ff ff       	jmp    801061c9 <alltraps>

801067c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067c2:	6a 00                	push   $0x0
  pushl $35
801067c4:	6a 23                	push   $0x23
  jmp alltraps
801067c6:	e9 fe f9 ff ff       	jmp    801061c9 <alltraps>

801067cb <vector36>:
.globl vector36
vector36:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $36
801067cd:	6a 24                	push   $0x24
  jmp alltraps
801067cf:	e9 f5 f9 ff ff       	jmp    801061c9 <alltraps>

801067d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067d4:	6a 00                	push   $0x0
  pushl $37
801067d6:	6a 25                	push   $0x25
  jmp alltraps
801067d8:	e9 ec f9 ff ff       	jmp    801061c9 <alltraps>

801067dd <vector38>:
.globl vector38
vector38:
  pushl $0
801067dd:	6a 00                	push   $0x0
  pushl $38
801067df:	6a 26                	push   $0x26
  jmp alltraps
801067e1:	e9 e3 f9 ff ff       	jmp    801061c9 <alltraps>

801067e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067e6:	6a 00                	push   $0x0
  pushl $39
801067e8:	6a 27                	push   $0x27
  jmp alltraps
801067ea:	e9 da f9 ff ff       	jmp    801061c9 <alltraps>

801067ef <vector40>:
.globl vector40
vector40:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $40
801067f1:	6a 28                	push   $0x28
  jmp alltraps
801067f3:	e9 d1 f9 ff ff       	jmp    801061c9 <alltraps>

801067f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067f8:	6a 00                	push   $0x0
  pushl $41
801067fa:	6a 29                	push   $0x29
  jmp alltraps
801067fc:	e9 c8 f9 ff ff       	jmp    801061c9 <alltraps>

80106801 <vector42>:
.globl vector42
vector42:
  pushl $0
80106801:	6a 00                	push   $0x0
  pushl $42
80106803:	6a 2a                	push   $0x2a
  jmp alltraps
80106805:	e9 bf f9 ff ff       	jmp    801061c9 <alltraps>

8010680a <vector43>:
.globl vector43
vector43:
  pushl $0
8010680a:	6a 00                	push   $0x0
  pushl $43
8010680c:	6a 2b                	push   $0x2b
  jmp alltraps
8010680e:	e9 b6 f9 ff ff       	jmp    801061c9 <alltraps>

80106813 <vector44>:
.globl vector44
vector44:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $44
80106815:	6a 2c                	push   $0x2c
  jmp alltraps
80106817:	e9 ad f9 ff ff       	jmp    801061c9 <alltraps>

8010681c <vector45>:
.globl vector45
vector45:
  pushl $0
8010681c:	6a 00                	push   $0x0
  pushl $45
8010681e:	6a 2d                	push   $0x2d
  jmp alltraps
80106820:	e9 a4 f9 ff ff       	jmp    801061c9 <alltraps>

80106825 <vector46>:
.globl vector46
vector46:
  pushl $0
80106825:	6a 00                	push   $0x0
  pushl $46
80106827:	6a 2e                	push   $0x2e
  jmp alltraps
80106829:	e9 9b f9 ff ff       	jmp    801061c9 <alltraps>

8010682e <vector47>:
.globl vector47
vector47:
  pushl $0
8010682e:	6a 00                	push   $0x0
  pushl $47
80106830:	6a 2f                	push   $0x2f
  jmp alltraps
80106832:	e9 92 f9 ff ff       	jmp    801061c9 <alltraps>

80106837 <vector48>:
.globl vector48
vector48:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $48
80106839:	6a 30                	push   $0x30
  jmp alltraps
8010683b:	e9 89 f9 ff ff       	jmp    801061c9 <alltraps>

80106840 <vector49>:
.globl vector49
vector49:
  pushl $0
80106840:	6a 00                	push   $0x0
  pushl $49
80106842:	6a 31                	push   $0x31
  jmp alltraps
80106844:	e9 80 f9 ff ff       	jmp    801061c9 <alltraps>

80106849 <vector50>:
.globl vector50
vector50:
  pushl $0
80106849:	6a 00                	push   $0x0
  pushl $50
8010684b:	6a 32                	push   $0x32
  jmp alltraps
8010684d:	e9 77 f9 ff ff       	jmp    801061c9 <alltraps>

80106852 <vector51>:
.globl vector51
vector51:
  pushl $0
80106852:	6a 00                	push   $0x0
  pushl $51
80106854:	6a 33                	push   $0x33
  jmp alltraps
80106856:	e9 6e f9 ff ff       	jmp    801061c9 <alltraps>

8010685b <vector52>:
.globl vector52
vector52:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $52
8010685d:	6a 34                	push   $0x34
  jmp alltraps
8010685f:	e9 65 f9 ff ff       	jmp    801061c9 <alltraps>

80106864 <vector53>:
.globl vector53
vector53:
  pushl $0
80106864:	6a 00                	push   $0x0
  pushl $53
80106866:	6a 35                	push   $0x35
  jmp alltraps
80106868:	e9 5c f9 ff ff       	jmp    801061c9 <alltraps>

8010686d <vector54>:
.globl vector54
vector54:
  pushl $0
8010686d:	6a 00                	push   $0x0
  pushl $54
8010686f:	6a 36                	push   $0x36
  jmp alltraps
80106871:	e9 53 f9 ff ff       	jmp    801061c9 <alltraps>

80106876 <vector55>:
.globl vector55
vector55:
  pushl $0
80106876:	6a 00                	push   $0x0
  pushl $55
80106878:	6a 37                	push   $0x37
  jmp alltraps
8010687a:	e9 4a f9 ff ff       	jmp    801061c9 <alltraps>

8010687f <vector56>:
.globl vector56
vector56:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $56
80106881:	6a 38                	push   $0x38
  jmp alltraps
80106883:	e9 41 f9 ff ff       	jmp    801061c9 <alltraps>

80106888 <vector57>:
.globl vector57
vector57:
  pushl $0
80106888:	6a 00                	push   $0x0
  pushl $57
8010688a:	6a 39                	push   $0x39
  jmp alltraps
8010688c:	e9 38 f9 ff ff       	jmp    801061c9 <alltraps>

80106891 <vector58>:
.globl vector58
vector58:
  pushl $0
80106891:	6a 00                	push   $0x0
  pushl $58
80106893:	6a 3a                	push   $0x3a
  jmp alltraps
80106895:	e9 2f f9 ff ff       	jmp    801061c9 <alltraps>

8010689a <vector59>:
.globl vector59
vector59:
  pushl $0
8010689a:	6a 00                	push   $0x0
  pushl $59
8010689c:	6a 3b                	push   $0x3b
  jmp alltraps
8010689e:	e9 26 f9 ff ff       	jmp    801061c9 <alltraps>

801068a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $60
801068a5:	6a 3c                	push   $0x3c
  jmp alltraps
801068a7:	e9 1d f9 ff ff       	jmp    801061c9 <alltraps>

801068ac <vector61>:
.globl vector61
vector61:
  pushl $0
801068ac:	6a 00                	push   $0x0
  pushl $61
801068ae:	6a 3d                	push   $0x3d
  jmp alltraps
801068b0:	e9 14 f9 ff ff       	jmp    801061c9 <alltraps>

801068b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801068b5:	6a 00                	push   $0x0
  pushl $62
801068b7:	6a 3e                	push   $0x3e
  jmp alltraps
801068b9:	e9 0b f9 ff ff       	jmp    801061c9 <alltraps>

801068be <vector63>:
.globl vector63
vector63:
  pushl $0
801068be:	6a 00                	push   $0x0
  pushl $63
801068c0:	6a 3f                	push   $0x3f
  jmp alltraps
801068c2:	e9 02 f9 ff ff       	jmp    801061c9 <alltraps>

801068c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $64
801068c9:	6a 40                	push   $0x40
  jmp alltraps
801068cb:	e9 f9 f8 ff ff       	jmp    801061c9 <alltraps>

801068d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068d0:	6a 00                	push   $0x0
  pushl $65
801068d2:	6a 41                	push   $0x41
  jmp alltraps
801068d4:	e9 f0 f8 ff ff       	jmp    801061c9 <alltraps>

801068d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068d9:	6a 00                	push   $0x0
  pushl $66
801068db:	6a 42                	push   $0x42
  jmp alltraps
801068dd:	e9 e7 f8 ff ff       	jmp    801061c9 <alltraps>

801068e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068e2:	6a 00                	push   $0x0
  pushl $67
801068e4:	6a 43                	push   $0x43
  jmp alltraps
801068e6:	e9 de f8 ff ff       	jmp    801061c9 <alltraps>

801068eb <vector68>:
.globl vector68
vector68:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $68
801068ed:	6a 44                	push   $0x44
  jmp alltraps
801068ef:	e9 d5 f8 ff ff       	jmp    801061c9 <alltraps>

801068f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068f4:	6a 00                	push   $0x0
  pushl $69
801068f6:	6a 45                	push   $0x45
  jmp alltraps
801068f8:	e9 cc f8 ff ff       	jmp    801061c9 <alltraps>

801068fd <vector70>:
.globl vector70
vector70:
  pushl $0
801068fd:	6a 00                	push   $0x0
  pushl $70
801068ff:	6a 46                	push   $0x46
  jmp alltraps
80106901:	e9 c3 f8 ff ff       	jmp    801061c9 <alltraps>

80106906 <vector71>:
.globl vector71
vector71:
  pushl $0
80106906:	6a 00                	push   $0x0
  pushl $71
80106908:	6a 47                	push   $0x47
  jmp alltraps
8010690a:	e9 ba f8 ff ff       	jmp    801061c9 <alltraps>

8010690f <vector72>:
.globl vector72
vector72:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $72
80106911:	6a 48                	push   $0x48
  jmp alltraps
80106913:	e9 b1 f8 ff ff       	jmp    801061c9 <alltraps>

80106918 <vector73>:
.globl vector73
vector73:
  pushl $0
80106918:	6a 00                	push   $0x0
  pushl $73
8010691a:	6a 49                	push   $0x49
  jmp alltraps
8010691c:	e9 a8 f8 ff ff       	jmp    801061c9 <alltraps>

80106921 <vector74>:
.globl vector74
vector74:
  pushl $0
80106921:	6a 00                	push   $0x0
  pushl $74
80106923:	6a 4a                	push   $0x4a
  jmp alltraps
80106925:	e9 9f f8 ff ff       	jmp    801061c9 <alltraps>

8010692a <vector75>:
.globl vector75
vector75:
  pushl $0
8010692a:	6a 00                	push   $0x0
  pushl $75
8010692c:	6a 4b                	push   $0x4b
  jmp alltraps
8010692e:	e9 96 f8 ff ff       	jmp    801061c9 <alltraps>

80106933 <vector76>:
.globl vector76
vector76:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $76
80106935:	6a 4c                	push   $0x4c
  jmp alltraps
80106937:	e9 8d f8 ff ff       	jmp    801061c9 <alltraps>

8010693c <vector77>:
.globl vector77
vector77:
  pushl $0
8010693c:	6a 00                	push   $0x0
  pushl $77
8010693e:	6a 4d                	push   $0x4d
  jmp alltraps
80106940:	e9 84 f8 ff ff       	jmp    801061c9 <alltraps>

80106945 <vector78>:
.globl vector78
vector78:
  pushl $0
80106945:	6a 00                	push   $0x0
  pushl $78
80106947:	6a 4e                	push   $0x4e
  jmp alltraps
80106949:	e9 7b f8 ff ff       	jmp    801061c9 <alltraps>

8010694e <vector79>:
.globl vector79
vector79:
  pushl $0
8010694e:	6a 00                	push   $0x0
  pushl $79
80106950:	6a 4f                	push   $0x4f
  jmp alltraps
80106952:	e9 72 f8 ff ff       	jmp    801061c9 <alltraps>

80106957 <vector80>:
.globl vector80
vector80:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $80
80106959:	6a 50                	push   $0x50
  jmp alltraps
8010695b:	e9 69 f8 ff ff       	jmp    801061c9 <alltraps>

80106960 <vector81>:
.globl vector81
vector81:
  pushl $0
80106960:	6a 00                	push   $0x0
  pushl $81
80106962:	6a 51                	push   $0x51
  jmp alltraps
80106964:	e9 60 f8 ff ff       	jmp    801061c9 <alltraps>

80106969 <vector82>:
.globl vector82
vector82:
  pushl $0
80106969:	6a 00                	push   $0x0
  pushl $82
8010696b:	6a 52                	push   $0x52
  jmp alltraps
8010696d:	e9 57 f8 ff ff       	jmp    801061c9 <alltraps>

80106972 <vector83>:
.globl vector83
vector83:
  pushl $0
80106972:	6a 00                	push   $0x0
  pushl $83
80106974:	6a 53                	push   $0x53
  jmp alltraps
80106976:	e9 4e f8 ff ff       	jmp    801061c9 <alltraps>

8010697b <vector84>:
.globl vector84
vector84:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $84
8010697d:	6a 54                	push   $0x54
  jmp alltraps
8010697f:	e9 45 f8 ff ff       	jmp    801061c9 <alltraps>

80106984 <vector85>:
.globl vector85
vector85:
  pushl $0
80106984:	6a 00                	push   $0x0
  pushl $85
80106986:	6a 55                	push   $0x55
  jmp alltraps
80106988:	e9 3c f8 ff ff       	jmp    801061c9 <alltraps>

8010698d <vector86>:
.globl vector86
vector86:
  pushl $0
8010698d:	6a 00                	push   $0x0
  pushl $86
8010698f:	6a 56                	push   $0x56
  jmp alltraps
80106991:	e9 33 f8 ff ff       	jmp    801061c9 <alltraps>

80106996 <vector87>:
.globl vector87
vector87:
  pushl $0
80106996:	6a 00                	push   $0x0
  pushl $87
80106998:	6a 57                	push   $0x57
  jmp alltraps
8010699a:	e9 2a f8 ff ff       	jmp    801061c9 <alltraps>

8010699f <vector88>:
.globl vector88
vector88:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $88
801069a1:	6a 58                	push   $0x58
  jmp alltraps
801069a3:	e9 21 f8 ff ff       	jmp    801061c9 <alltraps>

801069a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801069a8:	6a 00                	push   $0x0
  pushl $89
801069aa:	6a 59                	push   $0x59
  jmp alltraps
801069ac:	e9 18 f8 ff ff       	jmp    801061c9 <alltraps>

801069b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801069b1:	6a 00                	push   $0x0
  pushl $90
801069b3:	6a 5a                	push   $0x5a
  jmp alltraps
801069b5:	e9 0f f8 ff ff       	jmp    801061c9 <alltraps>

801069ba <vector91>:
.globl vector91
vector91:
  pushl $0
801069ba:	6a 00                	push   $0x0
  pushl $91
801069bc:	6a 5b                	push   $0x5b
  jmp alltraps
801069be:	e9 06 f8 ff ff       	jmp    801061c9 <alltraps>

801069c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $92
801069c5:	6a 5c                	push   $0x5c
  jmp alltraps
801069c7:	e9 fd f7 ff ff       	jmp    801061c9 <alltraps>

801069cc <vector93>:
.globl vector93
vector93:
  pushl $0
801069cc:	6a 00                	push   $0x0
  pushl $93
801069ce:	6a 5d                	push   $0x5d
  jmp alltraps
801069d0:	e9 f4 f7 ff ff       	jmp    801061c9 <alltraps>

801069d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069d5:	6a 00                	push   $0x0
  pushl $94
801069d7:	6a 5e                	push   $0x5e
  jmp alltraps
801069d9:	e9 eb f7 ff ff       	jmp    801061c9 <alltraps>

801069de <vector95>:
.globl vector95
vector95:
  pushl $0
801069de:	6a 00                	push   $0x0
  pushl $95
801069e0:	6a 5f                	push   $0x5f
  jmp alltraps
801069e2:	e9 e2 f7 ff ff       	jmp    801061c9 <alltraps>

801069e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $96
801069e9:	6a 60                	push   $0x60
  jmp alltraps
801069eb:	e9 d9 f7 ff ff       	jmp    801061c9 <alltraps>

801069f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069f0:	6a 00                	push   $0x0
  pushl $97
801069f2:	6a 61                	push   $0x61
  jmp alltraps
801069f4:	e9 d0 f7 ff ff       	jmp    801061c9 <alltraps>

801069f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069f9:	6a 00                	push   $0x0
  pushl $98
801069fb:	6a 62                	push   $0x62
  jmp alltraps
801069fd:	e9 c7 f7 ff ff       	jmp    801061c9 <alltraps>

80106a02 <vector99>:
.globl vector99
vector99:
  pushl $0
80106a02:	6a 00                	push   $0x0
  pushl $99
80106a04:	6a 63                	push   $0x63
  jmp alltraps
80106a06:	e9 be f7 ff ff       	jmp    801061c9 <alltraps>

80106a0b <vector100>:
.globl vector100
vector100:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $100
80106a0d:	6a 64                	push   $0x64
  jmp alltraps
80106a0f:	e9 b5 f7 ff ff       	jmp    801061c9 <alltraps>

80106a14 <vector101>:
.globl vector101
vector101:
  pushl $0
80106a14:	6a 00                	push   $0x0
  pushl $101
80106a16:	6a 65                	push   $0x65
  jmp alltraps
80106a18:	e9 ac f7 ff ff       	jmp    801061c9 <alltraps>

80106a1d <vector102>:
.globl vector102
vector102:
  pushl $0
80106a1d:	6a 00                	push   $0x0
  pushl $102
80106a1f:	6a 66                	push   $0x66
  jmp alltraps
80106a21:	e9 a3 f7 ff ff       	jmp    801061c9 <alltraps>

80106a26 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a26:	6a 00                	push   $0x0
  pushl $103
80106a28:	6a 67                	push   $0x67
  jmp alltraps
80106a2a:	e9 9a f7 ff ff       	jmp    801061c9 <alltraps>

80106a2f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $104
80106a31:	6a 68                	push   $0x68
  jmp alltraps
80106a33:	e9 91 f7 ff ff       	jmp    801061c9 <alltraps>

80106a38 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a38:	6a 00                	push   $0x0
  pushl $105
80106a3a:	6a 69                	push   $0x69
  jmp alltraps
80106a3c:	e9 88 f7 ff ff       	jmp    801061c9 <alltraps>

80106a41 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a41:	6a 00                	push   $0x0
  pushl $106
80106a43:	6a 6a                	push   $0x6a
  jmp alltraps
80106a45:	e9 7f f7 ff ff       	jmp    801061c9 <alltraps>

80106a4a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a4a:	6a 00                	push   $0x0
  pushl $107
80106a4c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a4e:	e9 76 f7 ff ff       	jmp    801061c9 <alltraps>

80106a53 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $108
80106a55:	6a 6c                	push   $0x6c
  jmp alltraps
80106a57:	e9 6d f7 ff ff       	jmp    801061c9 <alltraps>

80106a5c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a5c:	6a 00                	push   $0x0
  pushl $109
80106a5e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a60:	e9 64 f7 ff ff       	jmp    801061c9 <alltraps>

80106a65 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $110
80106a67:	6a 6e                	push   $0x6e
  jmp alltraps
80106a69:	e9 5b f7 ff ff       	jmp    801061c9 <alltraps>

80106a6e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $111
80106a70:	6a 6f                	push   $0x6f
  jmp alltraps
80106a72:	e9 52 f7 ff ff       	jmp    801061c9 <alltraps>

80106a77 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $112
80106a79:	6a 70                	push   $0x70
  jmp alltraps
80106a7b:	e9 49 f7 ff ff       	jmp    801061c9 <alltraps>

80106a80 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $113
80106a82:	6a 71                	push   $0x71
  jmp alltraps
80106a84:	e9 40 f7 ff ff       	jmp    801061c9 <alltraps>

80106a89 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $114
80106a8b:	6a 72                	push   $0x72
  jmp alltraps
80106a8d:	e9 37 f7 ff ff       	jmp    801061c9 <alltraps>

80106a92 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $115
80106a94:	6a 73                	push   $0x73
  jmp alltraps
80106a96:	e9 2e f7 ff ff       	jmp    801061c9 <alltraps>

80106a9b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $116
80106a9d:	6a 74                	push   $0x74
  jmp alltraps
80106a9f:	e9 25 f7 ff ff       	jmp    801061c9 <alltraps>

80106aa4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $117
80106aa6:	6a 75                	push   $0x75
  jmp alltraps
80106aa8:	e9 1c f7 ff ff       	jmp    801061c9 <alltraps>

80106aad <vector118>:
.globl vector118
vector118:
  pushl $0
80106aad:	6a 00                	push   $0x0
  pushl $118
80106aaf:	6a 76                	push   $0x76
  jmp alltraps
80106ab1:	e9 13 f7 ff ff       	jmp    801061c9 <alltraps>

80106ab6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106ab6:	6a 00                	push   $0x0
  pushl $119
80106ab8:	6a 77                	push   $0x77
  jmp alltraps
80106aba:	e9 0a f7 ff ff       	jmp    801061c9 <alltraps>

80106abf <vector120>:
.globl vector120
vector120:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $120
80106ac1:	6a 78                	push   $0x78
  jmp alltraps
80106ac3:	e9 01 f7 ff ff       	jmp    801061c9 <alltraps>

80106ac8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ac8:	6a 00                	push   $0x0
  pushl $121
80106aca:	6a 79                	push   $0x79
  jmp alltraps
80106acc:	e9 f8 f6 ff ff       	jmp    801061c9 <alltraps>

80106ad1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ad1:	6a 00                	push   $0x0
  pushl $122
80106ad3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ad5:	e9 ef f6 ff ff       	jmp    801061c9 <alltraps>

80106ada <vector123>:
.globl vector123
vector123:
  pushl $0
80106ada:	6a 00                	push   $0x0
  pushl $123
80106adc:	6a 7b                	push   $0x7b
  jmp alltraps
80106ade:	e9 e6 f6 ff ff       	jmp    801061c9 <alltraps>

80106ae3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $124
80106ae5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ae7:	e9 dd f6 ff ff       	jmp    801061c9 <alltraps>

80106aec <vector125>:
.globl vector125
vector125:
  pushl $0
80106aec:	6a 00                	push   $0x0
  pushl $125
80106aee:	6a 7d                	push   $0x7d
  jmp alltraps
80106af0:	e9 d4 f6 ff ff       	jmp    801061c9 <alltraps>

80106af5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106af5:	6a 00                	push   $0x0
  pushl $126
80106af7:	6a 7e                	push   $0x7e
  jmp alltraps
80106af9:	e9 cb f6 ff ff       	jmp    801061c9 <alltraps>

80106afe <vector127>:
.globl vector127
vector127:
  pushl $0
80106afe:	6a 00                	push   $0x0
  pushl $127
80106b00:	6a 7f                	push   $0x7f
  jmp alltraps
80106b02:	e9 c2 f6 ff ff       	jmp    801061c9 <alltraps>

80106b07 <vector128>:
.globl vector128
vector128:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $128
80106b09:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106b0e:	e9 b6 f6 ff ff       	jmp    801061c9 <alltraps>

80106b13 <vector129>:
.globl vector129
vector129:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $129
80106b15:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106b1a:	e9 aa f6 ff ff       	jmp    801061c9 <alltraps>

80106b1f <vector130>:
.globl vector130
vector130:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $130
80106b21:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b26:	e9 9e f6 ff ff       	jmp    801061c9 <alltraps>

80106b2b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $131
80106b2d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b32:	e9 92 f6 ff ff       	jmp    801061c9 <alltraps>

80106b37 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $132
80106b39:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b3e:	e9 86 f6 ff ff       	jmp    801061c9 <alltraps>

80106b43 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $133
80106b45:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b4a:	e9 7a f6 ff ff       	jmp    801061c9 <alltraps>

80106b4f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $134
80106b51:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b56:	e9 6e f6 ff ff       	jmp    801061c9 <alltraps>

80106b5b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $135
80106b5d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b62:	e9 62 f6 ff ff       	jmp    801061c9 <alltraps>

80106b67 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $136
80106b69:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b6e:	e9 56 f6 ff ff       	jmp    801061c9 <alltraps>

80106b73 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $137
80106b75:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b7a:	e9 4a f6 ff ff       	jmp    801061c9 <alltraps>

80106b7f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $138
80106b81:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b86:	e9 3e f6 ff ff       	jmp    801061c9 <alltraps>

80106b8b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $139
80106b8d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b92:	e9 32 f6 ff ff       	jmp    801061c9 <alltraps>

80106b97 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $140
80106b99:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b9e:	e9 26 f6 ff ff       	jmp    801061c9 <alltraps>

80106ba3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $141
80106ba5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106baa:	e9 1a f6 ff ff       	jmp    801061c9 <alltraps>

80106baf <vector142>:
.globl vector142
vector142:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $142
80106bb1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106bb6:	e9 0e f6 ff ff       	jmp    801061c9 <alltraps>

80106bbb <vector143>:
.globl vector143
vector143:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $143
80106bbd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106bc2:	e9 02 f6 ff ff       	jmp    801061c9 <alltraps>

80106bc7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $144
80106bc9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bce:	e9 f6 f5 ff ff       	jmp    801061c9 <alltraps>

80106bd3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $145
80106bd5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bda:	e9 ea f5 ff ff       	jmp    801061c9 <alltraps>

80106bdf <vector146>:
.globl vector146
vector146:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $146
80106be1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106be6:	e9 de f5 ff ff       	jmp    801061c9 <alltraps>

80106beb <vector147>:
.globl vector147
vector147:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $147
80106bed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106bf2:	e9 d2 f5 ff ff       	jmp    801061c9 <alltraps>

80106bf7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $148
80106bf9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bfe:	e9 c6 f5 ff ff       	jmp    801061c9 <alltraps>

80106c03 <vector149>:
.globl vector149
vector149:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $149
80106c05:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106c0a:	e9 ba f5 ff ff       	jmp    801061c9 <alltraps>

80106c0f <vector150>:
.globl vector150
vector150:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $150
80106c11:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106c16:	e9 ae f5 ff ff       	jmp    801061c9 <alltraps>

80106c1b <vector151>:
.globl vector151
vector151:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $151
80106c1d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c22:	e9 a2 f5 ff ff       	jmp    801061c9 <alltraps>

80106c27 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $152
80106c29:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c2e:	e9 96 f5 ff ff       	jmp    801061c9 <alltraps>

80106c33 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $153
80106c35:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c3a:	e9 8a f5 ff ff       	jmp    801061c9 <alltraps>

80106c3f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $154
80106c41:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c46:	e9 7e f5 ff ff       	jmp    801061c9 <alltraps>

80106c4b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $155
80106c4d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c52:	e9 72 f5 ff ff       	jmp    801061c9 <alltraps>

80106c57 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $156
80106c59:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c5e:	e9 66 f5 ff ff       	jmp    801061c9 <alltraps>

80106c63 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $157
80106c65:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c6a:	e9 5a f5 ff ff       	jmp    801061c9 <alltraps>

80106c6f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $158
80106c71:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c76:	e9 4e f5 ff ff       	jmp    801061c9 <alltraps>

80106c7b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $159
80106c7d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c82:	e9 42 f5 ff ff       	jmp    801061c9 <alltraps>

80106c87 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $160
80106c89:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c8e:	e9 36 f5 ff ff       	jmp    801061c9 <alltraps>

80106c93 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $161
80106c95:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c9a:	e9 2a f5 ff ff       	jmp    801061c9 <alltraps>

80106c9f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $162
80106ca1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106ca6:	e9 1e f5 ff ff       	jmp    801061c9 <alltraps>

80106cab <vector163>:
.globl vector163
vector163:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $163
80106cad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106cb2:	e9 12 f5 ff ff       	jmp    801061c9 <alltraps>

80106cb7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $164
80106cb9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106cbe:	e9 06 f5 ff ff       	jmp    801061c9 <alltraps>

80106cc3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $165
80106cc5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106cca:	e9 fa f4 ff ff       	jmp    801061c9 <alltraps>

80106ccf <vector166>:
.globl vector166
vector166:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $166
80106cd1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cd6:	e9 ee f4 ff ff       	jmp    801061c9 <alltraps>

80106cdb <vector167>:
.globl vector167
vector167:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $167
80106cdd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ce2:	e9 e2 f4 ff ff       	jmp    801061c9 <alltraps>

80106ce7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $168
80106ce9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cee:	e9 d6 f4 ff ff       	jmp    801061c9 <alltraps>

80106cf3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $169
80106cf5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cfa:	e9 ca f4 ff ff       	jmp    801061c9 <alltraps>

80106cff <vector170>:
.globl vector170
vector170:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $170
80106d01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106d06:	e9 be f4 ff ff       	jmp    801061c9 <alltraps>

80106d0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $171
80106d0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106d12:	e9 b2 f4 ff ff       	jmp    801061c9 <alltraps>

80106d17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $172
80106d19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106d1e:	e9 a6 f4 ff ff       	jmp    801061c9 <alltraps>

80106d23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $173
80106d25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d2a:	e9 9a f4 ff ff       	jmp    801061c9 <alltraps>

80106d2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $174
80106d31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d36:	e9 8e f4 ff ff       	jmp    801061c9 <alltraps>

80106d3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $175
80106d3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d42:	e9 82 f4 ff ff       	jmp    801061c9 <alltraps>

80106d47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $176
80106d49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d4e:	e9 76 f4 ff ff       	jmp    801061c9 <alltraps>

80106d53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $177
80106d55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d5a:	e9 6a f4 ff ff       	jmp    801061c9 <alltraps>

80106d5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $178
80106d61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d66:	e9 5e f4 ff ff       	jmp    801061c9 <alltraps>

80106d6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $179
80106d6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d72:	e9 52 f4 ff ff       	jmp    801061c9 <alltraps>

80106d77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $180
80106d79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d7e:	e9 46 f4 ff ff       	jmp    801061c9 <alltraps>

80106d83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $181
80106d85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d8a:	e9 3a f4 ff ff       	jmp    801061c9 <alltraps>

80106d8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $182
80106d91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d96:	e9 2e f4 ff ff       	jmp    801061c9 <alltraps>

80106d9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $183
80106d9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106da2:	e9 22 f4 ff ff       	jmp    801061c9 <alltraps>

80106da7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $184
80106da9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106dae:	e9 16 f4 ff ff       	jmp    801061c9 <alltraps>

80106db3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $185
80106db5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106dba:	e9 0a f4 ff ff       	jmp    801061c9 <alltraps>

80106dbf <vector186>:
.globl vector186
vector186:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $186
80106dc1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106dc6:	e9 fe f3 ff ff       	jmp    801061c9 <alltraps>

80106dcb <vector187>:
.globl vector187
vector187:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $187
80106dcd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106dd2:	e9 f2 f3 ff ff       	jmp    801061c9 <alltraps>

80106dd7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $188
80106dd9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dde:	e9 e6 f3 ff ff       	jmp    801061c9 <alltraps>

80106de3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $189
80106de5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dea:	e9 da f3 ff ff       	jmp    801061c9 <alltraps>

80106def <vector190>:
.globl vector190
vector190:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $190
80106df1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106df6:	e9 ce f3 ff ff       	jmp    801061c9 <alltraps>

80106dfb <vector191>:
.globl vector191
vector191:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $191
80106dfd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106e02:	e9 c2 f3 ff ff       	jmp    801061c9 <alltraps>

80106e07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $192
80106e09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106e0e:	e9 b6 f3 ff ff       	jmp    801061c9 <alltraps>

80106e13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $193
80106e15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106e1a:	e9 aa f3 ff ff       	jmp    801061c9 <alltraps>

80106e1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $194
80106e21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e26:	e9 9e f3 ff ff       	jmp    801061c9 <alltraps>

80106e2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $195
80106e2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e32:	e9 92 f3 ff ff       	jmp    801061c9 <alltraps>

80106e37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $196
80106e39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e3e:	e9 86 f3 ff ff       	jmp    801061c9 <alltraps>

80106e43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $197
80106e45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e4a:	e9 7a f3 ff ff       	jmp    801061c9 <alltraps>

80106e4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $198
80106e51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e56:	e9 6e f3 ff ff       	jmp    801061c9 <alltraps>

80106e5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $199
80106e5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e62:	e9 62 f3 ff ff       	jmp    801061c9 <alltraps>

80106e67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $200
80106e69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e6e:	e9 56 f3 ff ff       	jmp    801061c9 <alltraps>

80106e73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $201
80106e75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e7a:	e9 4a f3 ff ff       	jmp    801061c9 <alltraps>

80106e7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $202
80106e81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e86:	e9 3e f3 ff ff       	jmp    801061c9 <alltraps>

80106e8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $203
80106e8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e92:	e9 32 f3 ff ff       	jmp    801061c9 <alltraps>

80106e97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $204
80106e99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e9e:	e9 26 f3 ff ff       	jmp    801061c9 <alltraps>

80106ea3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $205
80106ea5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106eaa:	e9 1a f3 ff ff       	jmp    801061c9 <alltraps>

80106eaf <vector206>:
.globl vector206
vector206:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $206
80106eb1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106eb6:	e9 0e f3 ff ff       	jmp    801061c9 <alltraps>

80106ebb <vector207>:
.globl vector207
vector207:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $207
80106ebd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ec2:	e9 02 f3 ff ff       	jmp    801061c9 <alltraps>

80106ec7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $208
80106ec9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ece:	e9 f6 f2 ff ff       	jmp    801061c9 <alltraps>

80106ed3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $209
80106ed5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eda:	e9 ea f2 ff ff       	jmp    801061c9 <alltraps>

80106edf <vector210>:
.globl vector210
vector210:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $210
80106ee1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ee6:	e9 de f2 ff ff       	jmp    801061c9 <alltraps>

80106eeb <vector211>:
.globl vector211
vector211:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $211
80106eed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ef2:	e9 d2 f2 ff ff       	jmp    801061c9 <alltraps>

80106ef7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $212
80106ef9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106efe:	e9 c6 f2 ff ff       	jmp    801061c9 <alltraps>

80106f03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $213
80106f05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106f0a:	e9 ba f2 ff ff       	jmp    801061c9 <alltraps>

80106f0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $214
80106f11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106f16:	e9 ae f2 ff ff       	jmp    801061c9 <alltraps>

80106f1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $215
80106f1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f22:	e9 a2 f2 ff ff       	jmp    801061c9 <alltraps>

80106f27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $216
80106f29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f2e:	e9 96 f2 ff ff       	jmp    801061c9 <alltraps>

80106f33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $217
80106f35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f3a:	e9 8a f2 ff ff       	jmp    801061c9 <alltraps>

80106f3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $218
80106f41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f46:	e9 7e f2 ff ff       	jmp    801061c9 <alltraps>

80106f4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $219
80106f4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f52:	e9 72 f2 ff ff       	jmp    801061c9 <alltraps>

80106f57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $220
80106f59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f5e:	e9 66 f2 ff ff       	jmp    801061c9 <alltraps>

80106f63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $221
80106f65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f6a:	e9 5a f2 ff ff       	jmp    801061c9 <alltraps>

80106f6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $222
80106f71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f76:	e9 4e f2 ff ff       	jmp    801061c9 <alltraps>

80106f7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $223
80106f7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f82:	e9 42 f2 ff ff       	jmp    801061c9 <alltraps>

80106f87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f87:	6a 00                	push   $0x0
  pushl $224
80106f89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f8e:	e9 36 f2 ff ff       	jmp    801061c9 <alltraps>

80106f93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f93:	6a 00                	push   $0x0
  pushl $225
80106f95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f9a:	e9 2a f2 ff ff       	jmp    801061c9 <alltraps>

80106f9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $226
80106fa1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106fa6:	e9 1e f2 ff ff       	jmp    801061c9 <alltraps>

80106fab <vector227>:
.globl vector227
vector227:
  pushl $0
80106fab:	6a 00                	push   $0x0
  pushl $227
80106fad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106fb2:	e9 12 f2 ff ff       	jmp    801061c9 <alltraps>

80106fb7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106fb7:	6a 00                	push   $0x0
  pushl $228
80106fb9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106fbe:	e9 06 f2 ff ff       	jmp    801061c9 <alltraps>

80106fc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $229
80106fc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106fca:	e9 fa f1 ff ff       	jmp    801061c9 <alltraps>

80106fcf <vector230>:
.globl vector230
vector230:
  pushl $0
80106fcf:	6a 00                	push   $0x0
  pushl $230
80106fd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fd6:	e9 ee f1 ff ff       	jmp    801061c9 <alltraps>

80106fdb <vector231>:
.globl vector231
vector231:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $231
80106fdd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fe2:	e9 e2 f1 ff ff       	jmp    801061c9 <alltraps>

80106fe7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $232
80106fe9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fee:	e9 d6 f1 ff ff       	jmp    801061c9 <alltraps>

80106ff3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106ff3:	6a 00                	push   $0x0
  pushl $233
80106ff5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106ffa:	e9 ca f1 ff ff       	jmp    801061c9 <alltraps>

80106fff <vector234>:
.globl vector234
vector234:
  pushl $0
80106fff:	6a 00                	push   $0x0
  pushl $234
80107001:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107006:	e9 be f1 ff ff       	jmp    801061c9 <alltraps>

8010700b <vector235>:
.globl vector235
vector235:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $235
8010700d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107012:	e9 b2 f1 ff ff       	jmp    801061c9 <alltraps>

80107017 <vector236>:
.globl vector236
vector236:
  pushl $0
80107017:	6a 00                	push   $0x0
  pushl $236
80107019:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010701e:	e9 a6 f1 ff ff       	jmp    801061c9 <alltraps>

80107023 <vector237>:
.globl vector237
vector237:
  pushl $0
80107023:	6a 00                	push   $0x0
  pushl $237
80107025:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010702a:	e9 9a f1 ff ff       	jmp    801061c9 <alltraps>

8010702f <vector238>:
.globl vector238
vector238:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $238
80107031:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107036:	e9 8e f1 ff ff       	jmp    801061c9 <alltraps>

8010703b <vector239>:
.globl vector239
vector239:
  pushl $0
8010703b:	6a 00                	push   $0x0
  pushl $239
8010703d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107042:	e9 82 f1 ff ff       	jmp    801061c9 <alltraps>

80107047 <vector240>:
.globl vector240
vector240:
  pushl $0
80107047:	6a 00                	push   $0x0
  pushl $240
80107049:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010704e:	e9 76 f1 ff ff       	jmp    801061c9 <alltraps>

80107053 <vector241>:
.globl vector241
vector241:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $241
80107055:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010705a:	e9 6a f1 ff ff       	jmp    801061c9 <alltraps>

8010705f <vector242>:
.globl vector242
vector242:
  pushl $0
8010705f:	6a 00                	push   $0x0
  pushl $242
80107061:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107066:	e9 5e f1 ff ff       	jmp    801061c9 <alltraps>

8010706b <vector243>:
.globl vector243
vector243:
  pushl $0
8010706b:	6a 00                	push   $0x0
  pushl $243
8010706d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107072:	e9 52 f1 ff ff       	jmp    801061c9 <alltraps>

80107077 <vector244>:
.globl vector244
vector244:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $244
80107079:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010707e:	e9 46 f1 ff ff       	jmp    801061c9 <alltraps>

80107083 <vector245>:
.globl vector245
vector245:
  pushl $0
80107083:	6a 00                	push   $0x0
  pushl $245
80107085:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010708a:	e9 3a f1 ff ff       	jmp    801061c9 <alltraps>

8010708f <vector246>:
.globl vector246
vector246:
  pushl $0
8010708f:	6a 00                	push   $0x0
  pushl $246
80107091:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107096:	e9 2e f1 ff ff       	jmp    801061c9 <alltraps>

8010709b <vector247>:
.globl vector247
vector247:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $247
8010709d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801070a2:	e9 22 f1 ff ff       	jmp    801061c9 <alltraps>

801070a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801070a7:	6a 00                	push   $0x0
  pushl $248
801070a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801070ae:	e9 16 f1 ff ff       	jmp    801061c9 <alltraps>

801070b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801070b3:	6a 00                	push   $0x0
  pushl $249
801070b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801070ba:	e9 0a f1 ff ff       	jmp    801061c9 <alltraps>

801070bf <vector250>:
.globl vector250
vector250:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $250
801070c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070c6:	e9 fe f0 ff ff       	jmp    801061c9 <alltraps>

801070cb <vector251>:
.globl vector251
vector251:
  pushl $0
801070cb:	6a 00                	push   $0x0
  pushl $251
801070cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070d2:	e9 f2 f0 ff ff       	jmp    801061c9 <alltraps>

801070d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070d7:	6a 00                	push   $0x0
  pushl $252
801070d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070de:	e9 e6 f0 ff ff       	jmp    801061c9 <alltraps>

801070e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $253
801070e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070ea:	e9 da f0 ff ff       	jmp    801061c9 <alltraps>

801070ef <vector254>:
.globl vector254
vector254:
  pushl $0
801070ef:	6a 00                	push   $0x0
  pushl $254
801070f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070f6:	e9 ce f0 ff ff       	jmp    801061c9 <alltraps>

801070fb <vector255>:
.globl vector255
vector255:
  pushl $0
801070fb:	6a 00                	push   $0x0
  pushl $255
801070fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107102:	e9 c2 f0 ff ff       	jmp    801061c9 <alltraps>
80107107:	66 90                	xchg   %ax,%ax
80107109:	66 90                	xchg   %ax,%ax
8010710b:	66 90                	xchg   %ax,%ax
8010710d:	66 90                	xchg   %ax,%ax
8010710f:	90                   	nop

80107110 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107110:	55                   	push   %ebp
80107111:	89 e5                	mov    %esp,%ebp
80107113:	57                   	push   %edi
80107114:	56                   	push   %esi
80107115:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80107116:	89 d3                	mov    %edx,%ebx
{
80107118:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010711a:	c1 eb 16             	shr    $0x16,%ebx
8010711d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107120:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107123:	8b 06                	mov    (%esi),%eax
80107125:	a8 01                	test   $0x1,%al
80107127:	74 27                	je     80107150 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107129:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010712e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107134:	c1 ef 0a             	shr    $0xa,%edi
}
80107137:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010713a:	89 fa                	mov    %edi,%edx
8010713c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107142:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107145:	5b                   	pop    %ebx
80107146:	5e                   	pop    %esi
80107147:	5f                   	pop    %edi
80107148:	5d                   	pop    %ebp
80107149:	c3                   	ret    
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107150:	85 c9                	test   %ecx,%ecx
80107152:	74 2c                	je     80107180 <walkpgdir+0x70>
80107154:	e8 c7 ba ff ff       	call   80102c20 <kalloc>
80107159:	85 c0                	test   %eax,%eax
8010715b:	89 c3                	mov    %eax,%ebx
8010715d:	74 21                	je     80107180 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010715f:	83 ec 04             	sub    $0x4,%esp
80107162:	68 00 10 00 00       	push   $0x1000
80107167:	6a 00                	push   $0x0
80107169:	50                   	push   %eax
8010716a:	e8 11 de ff ff       	call   80104f80 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010716f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107175:	83 c4 10             	add    $0x10,%esp
80107178:	83 c8 07             	or     $0x7,%eax
8010717b:	89 06                	mov    %eax,(%esi)
8010717d:	eb b5                	jmp    80107134 <walkpgdir+0x24>
8010717f:	90                   	nop
}
80107180:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107183:	31 c0                	xor    %eax,%eax
}
80107185:	5b                   	pop    %ebx
80107186:	5e                   	pop    %esi
80107187:	5f                   	pop    %edi
80107188:	5d                   	pop    %ebp
80107189:	c3                   	ret    
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107190 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107196:	89 d3                	mov    %edx,%ebx
80107198:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010719e:	83 ec 1c             	sub    $0x1c,%esp
801071a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801071ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801071b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071b6:	29 df                	sub    %ebx,%edi
801071b8:	83 c8 01             	or     $0x1,%eax
801071bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071be:	eb 15                	jmp    801071d5 <mappages+0x45>
    if(*pte & PTE_P)
801071c0:	f6 00 01             	testb  $0x1,(%eax)
801071c3:	75 45                	jne    8010720a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801071c5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801071c8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801071cb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801071cd:	74 31                	je     80107200 <mappages+0x70>
      break;
    a += PGSIZE;
801071cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071d8:	b9 01 00 00 00       	mov    $0x1,%ecx
801071dd:	89 da                	mov    %ebx,%edx
801071df:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801071e2:	e8 29 ff ff ff       	call   80107110 <walkpgdir>
801071e7:	85 c0                	test   %eax,%eax
801071e9:	75 d5                	jne    801071c0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801071eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071f3:	5b                   	pop    %ebx
801071f4:	5e                   	pop    %esi
801071f5:	5f                   	pop    %edi
801071f6:	5d                   	pop    %ebp
801071f7:	c3                   	ret    
801071f8:	90                   	nop
801071f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107200:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107203:	31 c0                	xor    %eax,%eax
}
80107205:	5b                   	pop    %ebx
80107206:	5e                   	pop    %esi
80107207:	5f                   	pop    %edi
80107208:	5d                   	pop    %ebp
80107209:	c3                   	ret    
      panic("remap");
8010720a:	83 ec 0c             	sub    $0xc,%esp
8010720d:	68 54 8d 10 80       	push   $0x80108d54
80107212:	e8 79 91 ff ff       	call   80100390 <panic>
80107217:	89 f6                	mov    %esi,%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <printlist>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	56                   	push   %esi
80107224:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
80107225:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
8010722a:	83 ec 0c             	sub    $0xc,%esp
8010722d:	68 5a 8d 10 80       	push   $0x80108d5a
80107232:	e8 29 94 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
80107237:	e8 24 cf ff ff       	call   80104160 <myproc>
8010723c:	83 c4 10             	add    $0x10,%esp
8010723f:	8b 98 90 02 00 00    	mov    0x290(%eax),%ebx
80107245:	eb 0e                	jmp    80107255 <printlist+0x35>
80107247:	89 f6                	mov    %esi,%esi
80107249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107250:	83 ee 01             	sub    $0x1,%esi
80107253:	74 19                	je     8010726e <printlist+0x4e>
    cprintf("%d -> ", curr->off);
80107255:	83 ec 08             	sub    $0x8,%esp
80107258:	ff 33                	pushl  (%ebx)
8010725a:	68 6a 8d 10 80       	push   $0x80108d6a
8010725f:	e8 fc 93 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107264:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107267:	83 c4 10             	add    $0x10,%esp
8010726a:	85 db                	test   %ebx,%ebx
8010726c:	75 e2                	jne    80107250 <printlist+0x30>
  cprintf("\n");
8010726e:	83 ec 0c             	sub    $0xc,%esp
80107271:	68 1a 8e 10 80       	push   $0x80108e1a
80107276:	e8 e5 93 ff ff       	call   80100660 <cprintf>
}
8010727b:	83 c4 10             	add    $0x10,%esp
8010727e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107281:	5b                   	pop    %ebx
80107282:	5e                   	pop    %esi
80107283:	5d                   	pop    %ebp
80107284:	c3                   	ret    
80107285:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107290 <seginit>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107296:	e8 a5 ce ff ff       	call   80104140 <cpuid>
8010729b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801072a1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801072a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072aa:	c7 80 38 68 18 80 ff 	movl   $0xffff,-0x7fe797c8(%eax)
801072b1:	ff 00 00 
801072b4:	c7 80 3c 68 18 80 00 	movl   $0xcf9a00,-0x7fe797c4(%eax)
801072bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072be:	c7 80 40 68 18 80 ff 	movl   $0xffff,-0x7fe797c0(%eax)
801072c5:	ff 00 00 
801072c8:	c7 80 44 68 18 80 00 	movl   $0xcf9200,-0x7fe797bc(%eax)
801072cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072d2:	c7 80 48 68 18 80 ff 	movl   $0xffff,-0x7fe797b8(%eax)
801072d9:	ff 00 00 
801072dc:	c7 80 4c 68 18 80 00 	movl   $0xcffa00,-0x7fe797b4(%eax)
801072e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072e6:	c7 80 50 68 18 80 ff 	movl   $0xffff,-0x7fe797b0(%eax)
801072ed:	ff 00 00 
801072f0:	c7 80 54 68 18 80 00 	movl   $0xcff200,-0x7fe797ac(%eax)
801072f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072fa:	05 30 68 18 80       	add    $0x80186830,%eax
  pd[1] = (uint)p;
801072ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107303:	c1 e8 10             	shr    $0x10,%eax
80107306:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010730a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010730d:	0f 01 10             	lgdtl  (%eax)
}
80107310:	c9                   	leave  
80107311:	c3                   	ret    
80107312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107320:	a1 e4 1b 19 80       	mov    0x80191be4,%eax
{
80107325:	55                   	push   %ebp
80107326:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107328:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010732d:	0f 22 d8             	mov    %eax,%cr3
}
80107330:	5d                   	pop    %ebp
80107331:	c3                   	ret    
80107332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107340 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 1c             	sub    $0x1c,%esp
80107349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010734c:	85 db                	test   %ebx,%ebx
8010734e:	0f 84 cb 00 00 00    	je     8010741f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107354:	8b 43 08             	mov    0x8(%ebx),%eax
80107357:	85 c0                	test   %eax,%eax
80107359:	0f 84 da 00 00 00    	je     80107439 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010735f:	8b 43 04             	mov    0x4(%ebx),%eax
80107362:	85 c0                	test   %eax,%eax
80107364:	0f 84 c2 00 00 00    	je     8010742c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010736a:	e8 31 da ff ff       	call   80104da0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010736f:	e8 4c cd ff ff       	call   801040c0 <mycpu>
80107374:	89 c6                	mov    %eax,%esi
80107376:	e8 45 cd ff ff       	call   801040c0 <mycpu>
8010737b:	89 c7                	mov    %eax,%edi
8010737d:	e8 3e cd ff ff       	call   801040c0 <mycpu>
80107382:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107385:	83 c7 08             	add    $0x8,%edi
80107388:	e8 33 cd ff ff       	call   801040c0 <mycpu>
8010738d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107390:	83 c0 08             	add    $0x8,%eax
80107393:	ba 67 00 00 00       	mov    $0x67,%edx
80107398:	c1 e8 18             	shr    $0x18,%eax
8010739b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801073a2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801073a9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073af:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801073b4:	83 c1 08             	add    $0x8,%ecx
801073b7:	c1 e9 10             	shr    $0x10,%ecx
801073ba:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801073c0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073c5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073cc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801073d1:	e8 ea cc ff ff       	call   801040c0 <mycpu>
801073d6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073dd:	e8 de cc ff ff       	call   801040c0 <mycpu>
801073e2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073e6:	8b 73 08             	mov    0x8(%ebx),%esi
801073e9:	e8 d2 cc ff ff       	call   801040c0 <mycpu>
801073ee:	81 c6 00 10 00 00    	add    $0x1000,%esi
801073f4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073f7:	e8 c4 cc ff ff       	call   801040c0 <mycpu>
801073fc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107400:	b8 28 00 00 00       	mov    $0x28,%eax
80107405:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107408:	8b 43 04             	mov    0x4(%ebx),%eax
8010740b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107410:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107413:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107416:	5b                   	pop    %ebx
80107417:	5e                   	pop    %esi
80107418:	5f                   	pop    %edi
80107419:	5d                   	pop    %ebp
  popcli();
8010741a:	e9 c1 d9 ff ff       	jmp    80104de0 <popcli>
    panic("switchuvm: no process");
8010741f:	83 ec 0c             	sub    $0xc,%esp
80107422:	68 71 8d 10 80       	push   $0x80108d71
80107427:	e8 64 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010742c:	83 ec 0c             	sub    $0xc,%esp
8010742f:	68 9c 8d 10 80       	push   $0x80108d9c
80107434:	e8 57 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107439:	83 ec 0c             	sub    $0xc,%esp
8010743c:	68 87 8d 10 80       	push   $0x80108d87
80107441:	e8 4a 8f ff ff       	call   80100390 <panic>
80107446:	8d 76 00             	lea    0x0(%esi),%esi
80107449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107450 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107450:	55                   	push   %ebp
80107451:	89 e5                	mov    %esp,%ebp
80107453:	57                   	push   %edi
80107454:	56                   	push   %esi
80107455:	53                   	push   %ebx
80107456:	83 ec 1c             	sub    $0x1c,%esp
80107459:	8b 75 10             	mov    0x10(%ebp),%esi
8010745c:	8b 45 08             	mov    0x8(%ebp),%eax
8010745f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107462:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010746b:	77 49                	ja     801074b6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010746d:	e8 ae b7 ff ff       	call   80102c20 <kalloc>
  memset(mem, 0, PGSIZE);
80107472:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107475:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107477:	68 00 10 00 00       	push   $0x1000
8010747c:	6a 00                	push   $0x0
8010747e:	50                   	push   %eax
8010747f:	e8 fc da ff ff       	call   80104f80 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107484:	58                   	pop    %eax
80107485:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010748b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107490:	5a                   	pop    %edx
80107491:	6a 06                	push   $0x6
80107493:	50                   	push   %eax
80107494:	31 d2                	xor    %edx,%edx
80107496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107499:	e8 f2 fc ff ff       	call   80107190 <mappages>
  memmove(mem, init, sz);
8010749e:	89 75 10             	mov    %esi,0x10(%ebp)
801074a1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801074a4:	83 c4 10             	add    $0x10,%esp
801074a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074b1:	e9 7a db ff ff       	jmp    80105030 <memmove>
    panic("inituvm: more than a page");
801074b6:	83 ec 0c             	sub    $0xc,%esp
801074b9:	68 b0 8d 10 80       	push   $0x80108db0
801074be:	e8 cd 8e ff ff       	call   80100390 <panic>
801074c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801074c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801074d0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801074d0:	55                   	push   %ebp
801074d1:	89 e5                	mov    %esp,%ebp
801074d3:	57                   	push   %edi
801074d4:	56                   	push   %esi
801074d5:	53                   	push   %ebx
801074d6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801074d9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801074e0:	0f 85 91 00 00 00    	jne    80107577 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801074e6:	8b 75 18             	mov    0x18(%ebp),%esi
801074e9:	31 db                	xor    %ebx,%ebx
801074eb:	85 f6                	test   %esi,%esi
801074ed:	75 1a                	jne    80107509 <loaduvm+0x39>
801074ef:	eb 6f                	jmp    80107560 <loaduvm+0x90>
801074f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074f8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074fe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107504:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107507:	76 57                	jbe    80107560 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107509:	8b 55 0c             	mov    0xc(%ebp),%edx
8010750c:	8b 45 08             	mov    0x8(%ebp),%eax
8010750f:	31 c9                	xor    %ecx,%ecx
80107511:	01 da                	add    %ebx,%edx
80107513:	e8 f8 fb ff ff       	call   80107110 <walkpgdir>
80107518:	85 c0                	test   %eax,%eax
8010751a:	74 4e                	je     8010756a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010751c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010751e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107521:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107526:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010752b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107531:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107534:	01 d9                	add    %ebx,%ecx
80107536:	05 00 00 00 80       	add    $0x80000000,%eax
8010753b:	57                   	push   %edi
8010753c:	51                   	push   %ecx
8010753d:	50                   	push   %eax
8010753e:	ff 75 10             	pushl  0x10(%ebp)
80107541:	e8 ba a6 ff ff       	call   80101c00 <readi>
80107546:	83 c4 10             	add    $0x10,%esp
80107549:	39 f8                	cmp    %edi,%eax
8010754b:	74 ab                	je     801074f8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010754d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
8010755a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107560:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107563:	31 c0                	xor    %eax,%eax
}
80107565:	5b                   	pop    %ebx
80107566:	5e                   	pop    %esi
80107567:	5f                   	pop    %edi
80107568:	5d                   	pop    %ebp
80107569:	c3                   	ret    
      panic("loaduvm: address should exist");
8010756a:	83 ec 0c             	sub    $0xc,%esp
8010756d:	68 ca 8d 10 80       	push   $0x80108dca
80107572:	e8 19 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107577:	83 ec 0c             	sub    $0xc,%esp
8010757a:	68 34 8f 10 80       	push   $0x80108f34
8010757f:	e8 0c 8e ff ff       	call   80100390 <panic>
80107584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010758a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107590 <indexToSwap>:
  }
  return newsz;
}

uint indexToSwap()
{
80107590:	55                   	push   %ebp
  return 11;
}
80107591:	b8 0b 00 00 00       	mov    $0xb,%eax
{
80107596:	89 e5                	mov    %esp,%ebp
}
80107598:	5d                   	pop    %ebp
80107599:	c3                   	ret    
8010759a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075a0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	57                   	push   %edi
801075a4:	56                   	push   %esi
801075a5:	53                   	push   %ebx
801075a6:	83 ec 3c             	sub    $0x3c,%esp
801075a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
801075ac:	e8 af cb ff ff       	call   80104160 <myproc>
801075b1:	89 45 c4             	mov    %eax,-0x3c(%ebp)

  if(newsz >= oldsz)
801075b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801075b7:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ba:	0f 83 a3 00 00 00    	jae    80107663 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
801075c0:	8b 45 10             	mov    0x10(%ebp),%eax
801075c3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075c9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a  < oldsz; a += PGSIZE){
801075cf:	39 75 0c             	cmp    %esi,0xc(%ebp)
801075d2:	77 6a                	ja     8010763e <deallocuvm+0x9e>
801075d4:	e9 87 00 00 00       	jmp    80107660 <deallocuvm+0xc0>
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
801075e0:	8b 00                	mov    (%eax),%eax
801075e2:	a8 01                	test   $0x1,%al
801075e4:	74 4d                	je     80107633 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801075e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075eb:	0f 84 73 01 00 00    	je     80107764 <deallocuvm+0x1c4>
        panic("kfree");
      char *v = P2V(pa);
801075f1:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
801075f7:	83 ec 0c             	sub    $0xc,%esp
801075fa:	89 55 c0             	mov    %edx,-0x40(%ebp)
801075fd:	53                   	push   %ebx
801075fe:	e8 ad b7 ff ff       	call   80102db0 <getRefs>
80107603:	83 c4 10             	add    $0x10,%esp
80107606:	83 f8 01             	cmp    $0x1,%eax
80107609:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010760c:	0f 84 3e 01 00 00    	je     80107750 <deallocuvm+0x1b0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107612:	83 ec 0c             	sub    $0xc,%esp
80107615:	89 55 c0             	mov    %edx,-0x40(%ebp)
80107618:	53                   	push   %ebx
80107619:	e8 b2 b6 ff ff       	call   80102cd0 <refDec>
8010761e:	8b 55 c0             	mov    -0x40(%ebp),%edx
80107621:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107624:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80107627:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
8010762b:	7f 43                	jg     80107670 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
8010762d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107633:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107639:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010763c:	76 22                	jbe    80107660 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010763e:	31 c9                	xor    %ecx,%ecx
80107640:	89 f2                	mov    %esi,%edx
80107642:	89 f8                	mov    %edi,%eax
80107644:	e8 c7 fa ff ff       	call   80107110 <walkpgdir>
    if(!pte)
80107649:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
8010764b:	89 c2                	mov    %eax,%edx
    if(!pte)
8010764d:	75 91                	jne    801075e0 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
8010764f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107655:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010765b:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010765e:	77 de                	ja     8010763e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107660:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107663:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107666:	5b                   	pop    %ebx
80107667:	5e                   	pop    %esi
80107668:	5f                   	pop    %edi
80107669:	5d                   	pop    %ebp
8010766a:	c3                   	ret    
8010766b:	90                   	nop
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107670:	8d 88 88 01 00 00    	lea    0x188(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107676:	89 55 c0             	mov    %edx,-0x40(%ebp)
80107679:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
8010767f:	89 fa                	mov    %edi,%edx
80107681:	89 cf                	mov    %ecx,%edi
80107683:	eb 13                	jmp    80107698 <deallocuvm+0xf8>
80107685:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107688:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010768b:	74 7b                	je     80107708 <deallocuvm+0x168>
8010768d:	83 c3 10             	add    $0x10,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107690:	39 fb                	cmp    %edi,%ebx
80107692:	0f 84 a8 00 00 00    	je     80107740 <deallocuvm+0x1a0>
          struct page p_ram = curproc->ramPages[i];
80107698:	8b 83 00 01 00 00    	mov    0x100(%ebx),%eax
8010769e:	89 45 c8             	mov    %eax,-0x38(%ebp)
801076a1:	8b 83 04 01 00 00    	mov    0x104(%ebx),%eax
801076a7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801076aa:	8b 83 08 01 00 00    	mov    0x108(%ebx),%eax
801076b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801076b3:	8b 83 0c 01 00 00    	mov    0x10c(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
801076b9:	39 75 d0             	cmp    %esi,-0x30(%ebp)
          struct page p_ram = curproc->ramPages[i];
801076bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
          struct page p_swap = curproc->swappedPages[i];
801076bf:	8b 03                	mov    (%ebx),%eax
801076c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
801076c4:	8b 43 04             	mov    0x4(%ebx),%eax
801076c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801076ca:	8b 43 08             	mov    0x8(%ebx),%eax
801076cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076d0:	8b 43 0c             	mov    0xc(%ebx),%eax
801076d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
801076d6:	75 b0                	jne    80107688 <deallocuvm+0xe8>
801076d8:	39 55 c8             	cmp    %edx,-0x38(%ebp)
801076db:	75 ab                	jne    80107688 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
801076dd:	8d 45 c8             	lea    -0x38(%ebp),%eax
801076e0:	83 ec 04             	sub    $0x4,%esp
801076e3:	89 55 bc             	mov    %edx,-0x44(%ebp)
801076e6:	6a 10                	push   $0x10
801076e8:	6a 00                	push   $0x0
801076ea:	50                   	push   %eax
801076eb:	e8 90 d8 ff ff       	call   80104f80 <memset>
            curproc->num_ram -- ;
801076f0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801076f3:	83 c4 10             	add    $0x10,%esp
801076f6:	8b 55 bc             	mov    -0x44(%ebp),%edx
801076f9:	83 a8 88 02 00 00 01 	subl   $0x1,0x288(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107700:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80107703:	75 88                	jne    8010768d <deallocuvm+0xed>
80107705:	8d 76 00             	lea    0x0(%esi),%esi
80107708:	39 55 d8             	cmp    %edx,-0x28(%ebp)
8010770b:	75 80                	jne    8010768d <deallocuvm+0xed>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
8010770d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80107710:	83 ec 04             	sub    $0x4,%esp
80107713:	89 55 bc             	mov    %edx,-0x44(%ebp)
80107716:	6a 10                	push   $0x10
80107718:	6a 00                	push   $0x0
8010771a:	83 c3 10             	add    $0x10,%ebx
8010771d:	50                   	push   %eax
8010771e:	e8 5d d8 ff ff       	call   80104f80 <memset>
            curproc->num_swap --;
80107723:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80107726:	83 c4 10             	add    $0x10,%esp
80107729:	8b 55 bc             	mov    -0x44(%ebp),%edx
8010772c:	83 a8 8c 02 00 00 01 	subl   $0x1,0x28c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107733:	39 fb                	cmp    %edi,%ebx
80107735:	0f 85 5d ff ff ff    	jne    80107698 <deallocuvm+0xf8>
8010773b:	90                   	nop
8010773c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107740:	89 d7                	mov    %edx,%edi
80107742:	8b 55 c0             	mov    -0x40(%ebp),%edx
80107745:	e9 e3 fe ff ff       	jmp    8010762d <deallocuvm+0x8d>
8010774a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107750:	83 ec 0c             	sub    $0xc,%esp
80107753:	53                   	push   %ebx
80107754:	e8 e7 b1 ff ff       	call   80102940 <kfree>
80107759:	83 c4 10             	add    $0x10,%esp
8010775c:	8b 55 c0             	mov    -0x40(%ebp),%edx
8010775f:	e9 c0 fe ff ff       	jmp    80107624 <deallocuvm+0x84>
        panic("kfree");
80107764:	83 ec 0c             	sub    $0xc,%esp
80107767:	68 22 86 10 80       	push   $0x80108622
8010776c:	e8 1f 8c ff ff       	call   80100390 <panic>
80107771:	eb 0d                	jmp    80107780 <allocuvm>
80107773:	90                   	nop
80107774:	90                   	nop
80107775:	90                   	nop
80107776:	90                   	nop
80107777:	90                   	nop
80107778:	90                   	nop
80107779:	90                   	nop
8010777a:	90                   	nop
8010777b:	90                   	nop
8010777c:	90                   	nop
8010777d:	90                   	nop
8010777e:	90                   	nop
8010777f:	90                   	nop

80107780 <allocuvm>:
{
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	57                   	push   %edi
80107784:	56                   	push   %esi
80107785:	53                   	push   %ebx
80107786:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107789:	e8 d2 c9 ff ff       	call   80104160 <myproc>
8010778e:	89 c3                	mov    %eax,%ebx
  if(newsz >= KERNBASE)
80107790:	8b 45 10             	mov    0x10(%ebp),%eax
80107793:	85 c0                	test   %eax,%eax
80107795:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107798:	0f 88 32 02 00 00    	js     801079d0 <allocuvm+0x250>
  if(newsz < oldsz)
8010779e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801077a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801077a4:	0f 82 a6 01 00 00    	jb     80107950 <allocuvm+0x1d0>
  a = PGROUNDUP(oldsz);
801077aa:	05 ff 0f 00 00       	add    $0xfff,%eax
801077af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; a < newsz; a += PGSIZE){
801077b4:	39 45 10             	cmp    %eax,0x10(%ebp)
  a = PGROUNDUP(oldsz);
801077b7:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
801077b9:	0f 87 f1 00 00 00    	ja     801078b0 <allocuvm+0x130>
801077bf:	e9 8f 01 00 00       	jmp    80107953 <allocuvm+0x1d3>
801077c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          kfree((char*)curproc->free_head->prev);
801077c8:	83 ec 0c             	sub    $0xc,%esp
          curproc->free_head = curproc->free_head->next;
801077cb:	89 83 90 02 00 00    	mov    %eax,0x290(%ebx)
          kfree((char*)curproc->free_head->prev);
801077d1:	ff 70 08             	pushl  0x8(%eax)
801077d4:	e8 67 b1 ff ff       	call   80102940 <kfree>
801077d9:	83 c4 10             	add    $0x10,%esp
        if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
801077dc:	68 00 10 00 00       	push   $0x1000
801077e1:	56                   	push   %esi
801077e2:	ff b3 40 02 00 00    	pushl  0x240(%ebx)
801077e8:	53                   	push   %ebx
801077e9:	e8 02 ad ff ff       	call   801024f0 <writeToSwapFile>
801077ee:	83 c4 10             	add    $0x10,%esp
801077f1:	85 c0                	test   %eax,%eax
801077f3:	0f 88 77 02 00 00    	js     80107a70 <allocuvm+0x2f0>
        curproc->swappedPages[curproc->num_swap].isused = 1;
801077f9:	8b 83 8c 02 00 00    	mov    0x28c(%ebx),%eax
801077ff:	89 c1                	mov    %eax,%ecx
80107801:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107804:	c1 e1 04             	shl    $0x4,%ecx
80107807:	01 d9                	add    %ebx,%ecx
80107809:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80107810:	00 00 00 
        curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107813:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80107819:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
8010781f:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
        curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107825:	89 b1 94 00 00 00    	mov    %esi,0x94(%ecx)
        curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
8010782b:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
        lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107831:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107837:	0f 22 d9             	mov    %ecx,%cr3
        curproc->num_swap ++;
8010783a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010783d:	8d 71 01             	lea    0x1(%ecx),%esi
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107840:	31 c9                	xor    %ecx,%ecx
        curproc->num_swap ++;
80107842:	89 b3 8c 02 00 00    	mov    %esi,0x28c(%ebx)
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107848:	e8 c3 f8 ff ff       	call   80107110 <walkpgdir>
        if(!(*evicted_pte & PTE_P))
8010784d:	8b 10                	mov    (%eax),%edx
        pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
8010784f:	89 c6                	mov    %eax,%esi
        if(!(*evicted_pte & PTE_P))
80107851:	f6 c2 01             	test   $0x1,%dl
80107854:	0f 84 23 02 00 00    	je     80107a7d <allocuvm+0x2fd>
        char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
8010785a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
        kfree(P2V(evicted_pa));
80107860:	83 ec 0c             	sub    $0xc,%esp
80107863:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107869:	52                   	push   %edx
8010786a:	e8 d1 b0 ff ff       	call   80102940 <kfree>
        *evicted_pte &= ~PTE_P;
8010786f:	8b 06                	mov    (%esi),%eax
        newpage->virt_addr = (char*)a;
80107871:	83 c4 10             	add    $0x10,%esp
        *evicted_pte &= ~PTE_P;
80107874:	25 fe 0f 00 00       	and    $0xffe,%eax
80107879:	80 cc 02             	or     $0x2,%ah
8010787c:	89 06                	mov    %eax,(%esi)
        newpage->pgdir = pgdir; // ??? 
8010787e:	8b 45 08             	mov    0x8(%ebp),%eax
        newpage->isused = 1;
80107881:	c7 83 3c 02 00 00 01 	movl   $0x1,0x23c(%ebx)
80107888:	00 00 00 
        newpage->swap_offset = -1;
8010788b:	c7 83 44 02 00 00 ff 	movl   $0xffffffff,0x244(%ebx)
80107892:	ff ff ff 
        newpage->virt_addr = (char*)a;
80107895:	89 bb 40 02 00 00    	mov    %edi,0x240(%ebx)
        newpage->pgdir = pgdir; // ??? 
8010789b:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
  for(; a < newsz; a += PGSIZE){
801078a1:	81 c7 00 10 00 00    	add    $0x1000,%edi
801078a7:	39 7d 10             	cmp    %edi,0x10(%ebp)
801078aa:	0f 86 a3 00 00 00    	jbe    80107953 <allocuvm+0x1d3>
    mem = kalloc();
801078b0:	e8 6b b3 ff ff       	call   80102c20 <kalloc>
    if(mem == 0){
801078b5:	85 c0                	test   %eax,%eax
    mem = kalloc();
801078b7:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801078b9:	0f 84 31 01 00 00    	je     801079f0 <allocuvm+0x270>
    memset(mem, 0, PGSIZE);
801078bf:	83 ec 04             	sub    $0x4,%esp
801078c2:	68 00 10 00 00       	push   $0x1000
801078c7:	6a 00                	push   $0x0
801078c9:	50                   	push   %eax
801078ca:	e8 b1 d6 ff ff       	call   80104f80 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801078cf:	58                   	pop    %eax
801078d0:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801078d6:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078db:	5a                   	pop    %edx
801078dc:	6a 06                	push   $0x6
801078de:	50                   	push   %eax
801078df:	89 fa                	mov    %edi,%edx
801078e1:	8b 45 08             	mov    0x8(%ebp),%eax
801078e4:	e8 a7 f8 ff ff       	call   80107190 <mappages>
801078e9:	83 c4 10             	add    $0x10,%esp
801078ec:	85 c0                	test   %eax,%eax
801078ee:	0f 88 34 01 00 00    	js     80107a28 <allocuvm+0x2a8>
    if(curproc->pid > 2) {
801078f4:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801078f8:	7e a7                	jle    801078a1 <allocuvm+0x121>
      if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801078fa:	83 bb 88 02 00 00 0f 	cmpl   $0xf,0x288(%ebx)
80107901:	7e 5d                	jle    80107960 <allocuvm+0x1e0>
        if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107903:	83 bb 8c 02 00 00 0f 	cmpl   $0xf,0x28c(%ebx)
8010790a:	0f 8f 53 01 00 00    	jg     80107a63 <allocuvm+0x2e3>
        int swap_offset = curproc->free_head->off;
80107910:	8b 93 90 02 00 00    	mov    0x290(%ebx),%edx
        if(curproc->free_head->next == 0)
80107916:	8b 42 04             	mov    0x4(%edx),%eax
        int swap_offset = curproc->free_head->off;
80107919:	8b 32                	mov    (%edx),%esi
        if(curproc->free_head->next == 0)
8010791b:	85 c0                	test   %eax,%eax
8010791d:	0f 85 a5 fe ff ff    	jne    801077c8 <allocuvm+0x48>
          kfree((char*)curproc->free_head);
80107923:	83 ec 0c             	sub    $0xc,%esp
          curproc->free_tail = 0;
80107926:	c7 83 94 02 00 00 00 	movl   $0x0,0x294(%ebx)
8010792d:	00 00 00 
          kfree((char*)curproc->free_head);
80107930:	52                   	push   %edx
80107931:	e8 0a b0 ff ff       	call   80102940 <kfree>
          curproc->free_head = 0;
80107936:	c7 83 90 02 00 00 00 	movl   $0x0,0x290(%ebx)
8010793d:	00 00 00 
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	e9 94 fe ff ff       	jmp    801077dc <allocuvm+0x5c>
80107948:	90                   	nop
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107950:	89 45 e0             	mov    %eax,-0x20(%ebp)
}
80107953:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107956:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107959:	5b                   	pop    %ebx
8010795a:	5e                   	pop    %esi
8010795b:	5f                   	pop    %edi
8010795c:	5d                   	pop    %ebp
8010795d:	c3                   	ret    
8010795e:	66 90                	xchg   %ax,%ax

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80107960:	e8 fb c7 ff ff       	call   80104160 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107965:	31 d2                	xor    %edx,%edx
80107967:	05 8c 01 00 00       	add    $0x18c,%eax
8010796c:	eb 0d                	jmp    8010797b <allocuvm+0x1fb>
8010796e:	66 90                	xchg   %ax,%ax
80107970:	83 c2 01             	add    $0x1,%edx
80107973:	83 c0 10             	add    $0x10,%eax
80107976:	83 fa 10             	cmp    $0x10,%edx
80107979:	74 6d                	je     801079e8 <allocuvm+0x268>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
8010797b:	8b 08                	mov    (%eax),%ecx
8010797d:	85 c9                	test   %ecx,%ecx
8010797f:	75 ef                	jne    80107970 <allocuvm+0x1f0>
          page->pgdir = pgdir;
80107981:	8b 45 08             	mov    0x8(%ebp),%eax
80107984:	c1 e2 04             	shl    $0x4,%edx
          cprintf("num ram : %d\n", curproc->num_ram);
80107987:	83 ec 08             	sub    $0x8,%esp
8010798a:	01 da                	add    %ebx,%edx
          page->isused = 1;
8010798c:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80107993:	00 00 00 
          page->swap_offset = -1;
80107996:	c7 82 94 01 00 00 ff 	movl   $0xffffffff,0x194(%edx)
8010799d:	ff ff ff 
          page->pgdir = pgdir;
801079a0:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
          page->virt_addr = (char*)a;
801079a6:	89 ba 90 01 00 00    	mov    %edi,0x190(%edx)
          cprintf("num ram : %d\n", curproc->num_ram);
801079ac:	ff b3 88 02 00 00    	pushl  0x288(%ebx)
801079b2:	68 1c 8e 10 80       	push   $0x80108e1c
801079b7:	e8 a4 8c ff ff       	call   80100660 <cprintf>
          curproc->num_ram++;
801079bc:	83 83 88 02 00 00 01 	addl   $0x1,0x288(%ebx)
801079c3:	83 c4 10             	add    $0x10,%esp
801079c6:	e9 d6 fe ff ff       	jmp    801078a1 <allocuvm+0x121>
801079cb:	90                   	nop
801079cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801079d0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801079d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801079da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079dd:	5b                   	pop    %ebx
801079de:	5e                   	pop    %esi
801079df:	5f                   	pop    %edi
801079e0:	5d                   	pop    %ebp
801079e1:	c3                   	ret    
801079e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return i;
  }
  return -1;
801079e8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801079ed:	eb 92                	jmp    80107981 <allocuvm+0x201>
801079ef:	90                   	nop
      cprintf("allocuvm out of memory\n");
801079f0:	83 ec 0c             	sub    $0xc,%esp
801079f3:	68 e8 8d 10 80       	push   $0x80108de8
801079f8:	e8 63 8c ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801079fd:	83 c4 0c             	add    $0xc,%esp
80107a00:	ff 75 0c             	pushl  0xc(%ebp)
80107a03:	ff 75 10             	pushl  0x10(%ebp)
80107a06:	ff 75 08             	pushl  0x8(%ebp)
80107a09:	e8 92 fb ff ff       	call   801075a0 <deallocuvm>
      return 0;
80107a0e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a15:	83 c4 10             	add    $0x10,%esp
}
80107a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a1e:	5b                   	pop    %ebx
80107a1f:	5e                   	pop    %esi
80107a20:	5f                   	pop    %edi
80107a21:	5d                   	pop    %ebp
80107a22:	c3                   	ret    
80107a23:	90                   	nop
80107a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107a28:	83 ec 0c             	sub    $0xc,%esp
80107a2b:	68 00 8e 10 80       	push   $0x80108e00
80107a30:	e8 2b 8c ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107a35:	83 c4 0c             	add    $0xc,%esp
80107a38:	ff 75 0c             	pushl  0xc(%ebp)
80107a3b:	ff 75 10             	pushl  0x10(%ebp)
80107a3e:	ff 75 08             	pushl  0x8(%ebp)
80107a41:	e8 5a fb ff ff       	call   801075a0 <deallocuvm>
      kfree(mem);
80107a46:	89 34 24             	mov    %esi,(%esp)
80107a49:	e8 f2 ae ff ff       	call   80102940 <kfree>
      return 0;
80107a4e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a55:	83 c4 10             	add    $0x10,%esp
}
80107a58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a5e:	5b                   	pop    %ebx
80107a5f:	5e                   	pop    %esi
80107a60:	5f                   	pop    %edi
80107a61:	5d                   	pop    %ebp
80107a62:	c3                   	ret    
          panic("exceeded max swap pages");
80107a63:	83 ec 0c             	sub    $0xc,%esp
80107a66:	68 2a 8e 10 80       	push   $0x80108e2a
80107a6b:	e8 20 89 ff ff       	call   80100390 <panic>
          panic("allocuvm: writeToSwapFile");
80107a70:	83 ec 0c             	sub    $0xc,%esp
80107a73:	68 42 8e 10 80       	push   $0x80108e42
80107a78:	e8 13 89 ff ff       	call   80100390 <panic>
          panic("allocuvm: swap: ram page not present");
80107a7d:	83 ec 0c             	sub    $0xc,%esp
80107a80:	68 58 8f 10 80       	push   $0x80108f58
80107a85:	e8 06 89 ff ff       	call   80100390 <panic>
80107a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107a90 <freevm>:
{
80107a90:	55                   	push   %ebp
80107a91:	89 e5                	mov    %esp,%ebp
80107a93:	57                   	push   %edi
80107a94:	56                   	push   %esi
80107a95:	53                   	push   %ebx
80107a96:	83 ec 0c             	sub    $0xc,%esp
80107a99:	8b 75 08             	mov    0x8(%ebp),%esi
  if(pgdir == 0)
80107a9c:	85 f6                	test   %esi,%esi
80107a9e:	74 59                	je     80107af9 <freevm+0x69>
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107aa0:	83 ec 04             	sub    $0x4,%esp
80107aa3:	89 f3                	mov    %esi,%ebx
80107aa5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107aab:	6a 00                	push   $0x0
80107aad:	68 00 00 00 80       	push   $0x80000000
80107ab2:	56                   	push   %esi
80107ab3:	e8 e8 fa ff ff       	call   801075a0 <deallocuvm>
80107ab8:	83 c4 10             	add    $0x10,%esp
80107abb:	eb 0a                	jmp    80107ac7 <freevm+0x37>
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
80107ac0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107ac3:	39 fb                	cmp    %edi,%ebx
80107ac5:	74 23                	je     80107aea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107ac7:	8b 03                	mov    (%ebx),%eax
80107ac9:	a8 01                	test   $0x1,%al
80107acb:	74 f3                	je     80107ac0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107acd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ad2:	83 ec 0c             	sub    $0xc,%esp
80107ad5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ad8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107add:	50                   	push   %eax
80107ade:	e8 5d ae ff ff       	call   80102940 <kfree>
80107ae3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107ae6:	39 fb                	cmp    %edi,%ebx
80107ae8:	75 dd                	jne    80107ac7 <freevm+0x37>
  kfree((char*)pgdir);
80107aea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107aed:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107af0:	5b                   	pop    %ebx
80107af1:	5e                   	pop    %esi
80107af2:	5f                   	pop    %edi
80107af3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107af4:	e9 47 ae ff ff       	jmp    80102940 <kfree>
    panic("freevm: no pgdir");
80107af9:	83 ec 0c             	sub    $0xc,%esp
80107afc:	68 5c 8e 10 80       	push   $0x80108e5c
80107b01:	e8 8a 88 ff ff       	call   80100390 <panic>
80107b06:	8d 76 00             	lea    0x0(%esi),%esi
80107b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107b10 <setupkvm>:
{
80107b10:	55                   	push   %ebp
80107b11:	89 e5                	mov    %esp,%ebp
80107b13:	56                   	push   %esi
80107b14:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107b15:	e8 06 b1 ff ff       	call   80102c20 <kalloc>
80107b1a:	85 c0                	test   %eax,%eax
80107b1c:	89 c6                	mov    %eax,%esi
80107b1e:	74 42                	je     80107b62 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107b20:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b23:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107b28:	68 00 10 00 00       	push   $0x1000
80107b2d:	6a 00                	push   $0x0
80107b2f:	50                   	push   %eax
80107b30:	e8 4b d4 ff ff       	call   80104f80 <memset>
80107b35:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107b38:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107b3b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107b3e:	83 ec 08             	sub    $0x8,%esp
80107b41:	8b 13                	mov    (%ebx),%edx
80107b43:	ff 73 0c             	pushl  0xc(%ebx)
80107b46:	50                   	push   %eax
80107b47:	29 c1                	sub    %eax,%ecx
80107b49:	89 f0                	mov    %esi,%eax
80107b4b:	e8 40 f6 ff ff       	call   80107190 <mappages>
80107b50:	83 c4 10             	add    $0x10,%esp
80107b53:	85 c0                	test   %eax,%eax
80107b55:	78 19                	js     80107b70 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107b57:	83 c3 10             	add    $0x10,%ebx
80107b5a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107b60:	75 d6                	jne    80107b38 <setupkvm+0x28>
}
80107b62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b65:	89 f0                	mov    %esi,%eax
80107b67:	5b                   	pop    %ebx
80107b68:	5e                   	pop    %esi
80107b69:	5d                   	pop    %ebp
80107b6a:	c3                   	ret    
80107b6b:	90                   	nop
80107b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80107b70:	83 ec 0c             	sub    $0xc,%esp
80107b73:	68 6d 8e 10 80       	push   $0x80108e6d
80107b78:	e8 e3 8a ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
80107b7d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107b80:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107b82:	e8 09 ff ff ff       	call   80107a90 <freevm>
      return 0;
80107b87:	83 c4 10             	add    $0x10,%esp
}
80107b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107b8d:	89 f0                	mov    %esi,%eax
80107b8f:	5b                   	pop    %ebx
80107b90:	5e                   	pop    %esi
80107b91:	5d                   	pop    %ebp
80107b92:	c3                   	ret    
80107b93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ba0 <kvmalloc>:
{
80107ba0:	55                   	push   %ebp
80107ba1:	89 e5                	mov    %esp,%ebp
80107ba3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107ba6:	e8 65 ff ff ff       	call   80107b10 <setupkvm>
80107bab:	a3 e4 1b 19 80       	mov    %eax,0x80191be4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107bb0:	05 00 00 00 80       	add    $0x80000000,%eax
80107bb5:	0f 22 d8             	mov    %eax,%cr3
}
80107bb8:	c9                   	leave  
80107bb9:	c3                   	ret    
80107bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107bc0 <clearpteu>:
{
80107bc0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80107bc1:	31 c9                	xor    %ecx,%ecx
{
80107bc3:	89 e5                	mov    %esp,%ebp
80107bc5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107bc8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bcb:	8b 45 08             	mov    0x8(%ebp),%eax
80107bce:	e8 3d f5 ff ff       	call   80107110 <walkpgdir>
  if(pte == 0)
80107bd3:	85 c0                	test   %eax,%eax
80107bd5:	74 05                	je     80107bdc <clearpteu+0x1c>
  *pte &= ~PTE_U;
80107bd7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107bda:	c9                   	leave  
80107bdb:	c3                   	ret    
    panic("clearpteu");
80107bdc:	83 ec 0c             	sub    $0xc,%esp
80107bdf:	68 89 8e 10 80       	push   $0x80108e89
80107be4:	e8 a7 87 ff ff       	call   80100390 <panic>
80107be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bf0 <cowuvm>:
{
80107bf0:	55                   	push   %ebp
80107bf1:	89 e5                	mov    %esp,%ebp
80107bf3:	57                   	push   %edi
80107bf4:	56                   	push   %esi
80107bf5:	53                   	push   %ebx
80107bf6:	83 ec 0c             	sub    $0xc,%esp
  if((d = setupkvm()) == 0)
80107bf9:	e8 12 ff ff ff       	call   80107b10 <setupkvm>
80107bfe:	85 c0                	test   %eax,%eax
80107c00:	89 c7                	mov    %eax,%edi
80107c02:	0f 84 9e 00 00 00    	je     80107ca6 <cowuvm+0xb6>
  for(i = 0; i < sz; i += PGSIZE)
80107c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c0b:	85 c0                	test   %eax,%eax
80107c0d:	0f 84 93 00 00 00    	je     80107ca6 <cowuvm+0xb6>
80107c13:	31 db                	xor    %ebx,%ebx
80107c15:	eb 29                	jmp    80107c40 <cowuvm+0x50>
80107c17:	89 f6                	mov    %esi,%esi
80107c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    refInc(virt_addr);
80107c20:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107c23:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
80107c29:	56                   	push   %esi
80107c2a:	e8 11 b1 ff ff       	call   80102d40 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107c2f:	0f 01 3b             	invlpg (%ebx)
  for(i = 0; i < sz; i += PGSIZE)
80107c32:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107c38:	83 c4 10             	add    $0x10,%esp
80107c3b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107c3e:	76 66                	jbe    80107ca6 <cowuvm+0xb6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107c40:	8b 45 08             	mov    0x8(%ebp),%eax
80107c43:	31 c9                	xor    %ecx,%ecx
80107c45:	89 da                	mov    %ebx,%edx
80107c47:	e8 c4 f4 ff ff       	call   80107110 <walkpgdir>
80107c4c:	85 c0                	test   %eax,%eax
80107c4e:	74 6d                	je     80107cbd <cowuvm+0xcd>
    if(!(*pte & PTE_P))
80107c50:	8b 10                	mov    (%eax),%edx
80107c52:	f6 c2 01             	test   $0x1,%dl
80107c55:	74 59                	je     80107cb0 <cowuvm+0xc0>
    *pte &= ~PTE_W;
80107c57:	89 d1                	mov    %edx,%ecx
80107c59:	89 d6                	mov    %edx,%esi
    flags = PTE_FLAGS(*pte);
80107c5b:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80107c61:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c64:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107c67:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
80107c6a:	80 cd 04             	or     $0x4,%ch
80107c6d:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107c73:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107c75:	52                   	push   %edx
80107c76:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107c7b:	56                   	push   %esi
80107c7c:	89 da                	mov    %ebx,%edx
80107c7e:	89 f8                	mov    %edi,%eax
80107c80:	e8 0b f5 ff ff       	call   80107190 <mappages>
80107c85:	83 c4 10             	add    $0x10,%esp
80107c88:	85 c0                	test   %eax,%eax
80107c8a:	79 94                	jns    80107c20 <cowuvm+0x30>
  cprintf("bad: cowuvm\n");
80107c8c:	83 ec 0c             	sub    $0xc,%esp
80107c8f:	68 bb 8e 10 80       	push   $0x80108ebb
80107c94:	e8 c7 89 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107c99:	89 3c 24             	mov    %edi,(%esp)
  return 0;
80107c9c:	31 ff                	xor    %edi,%edi
  freevm(d);
80107c9e:	e8 ed fd ff ff       	call   80107a90 <freevm>
  return 0;
80107ca3:	83 c4 10             	add    $0x10,%esp
}
80107ca6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ca9:	89 f8                	mov    %edi,%eax
80107cab:	5b                   	pop    %ebx
80107cac:	5e                   	pop    %esi
80107cad:	5f                   	pop    %edi
80107cae:	5d                   	pop    %ebp
80107caf:	c3                   	ret    
      panic("cowuvm: page not present");
80107cb0:	83 ec 0c             	sub    $0xc,%esp
80107cb3:	68 a2 8e 10 80       	push   $0x80108ea2
80107cb8:	e8 d3 86 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107cbd:	83 ec 0c             	sub    $0xc,%esp
80107cc0:	68 93 8e 10 80       	push   $0x80108e93
80107cc5:	e8 c6 86 ff ff       	call   80100390 <panic>
80107cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107cd0 <getSwappedPageIndex>:
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	53                   	push   %ebx
80107cd4:	83 ec 04             	sub    $0x4,%esp
80107cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107cda:	e8 81 c4 ff ff       	call   80104160 <myproc>
80107cdf:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107ce5:	31 c0                	xor    %eax,%eax
80107ce7:	eb 12                	jmp    80107cfb <getSwappedPageIndex+0x2b>
80107ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107cf0:	83 c0 01             	add    $0x1,%eax
80107cf3:	83 c2 10             	add    $0x10,%edx
80107cf6:	83 f8 10             	cmp    $0x10,%eax
80107cf9:	74 0d                	je     80107d08 <getSwappedPageIndex+0x38>
    if(curproc->swappedPages[i].virt_addr == va)
80107cfb:	39 1a                	cmp    %ebx,(%edx)
80107cfd:	75 f1                	jne    80107cf0 <getSwappedPageIndex+0x20>
}
80107cff:	83 c4 04             	add    $0x4,%esp
80107d02:	5b                   	pop    %ebx
80107d03:	5d                   	pop    %ebp
80107d04:	c3                   	ret    
80107d05:	8d 76 00             	lea    0x0(%esi),%esi
80107d08:	83 c4 04             	add    $0x4,%esp
  return -1;
80107d0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107d10:	5b                   	pop    %ebx
80107d11:	5d                   	pop    %ebp
80107d12:	c3                   	ret    
80107d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d20 <pagefault>:
{
80107d20:	55                   	push   %ebp
80107d21:	89 e5                	mov    %esp,%ebp
80107d23:	57                   	push   %edi
80107d24:	56                   	push   %esi
80107d25:	53                   	push   %ebx
80107d26:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107d29:	e8 32 c4 ff ff       	call   80104160 <myproc>
80107d2e:	89 c6                	mov    %eax,%esi
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107d30:	0f 20 d3             	mov    %cr2,%ebx
  uint err = curproc->tf->err;
80107d33:	8b 40 18             	mov    0x18(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107d36:	89 df                	mov    %ebx,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d38:	31 c9                	xor    %ecx,%ecx
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80107d3a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d40:	89 fa                	mov    %edi,%edx
  uint err = curproc->tf->err;
80107d42:	8b 40 34             	mov    0x34(%eax),%eax
80107d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80107d48:	8b 46 04             	mov    0x4(%esi),%eax
80107d4b:	e8 c0 f3 ff ff       	call   80107110 <walkpgdir>
  if(*pte & PTE_PG) // page was paged out
80107d50:	8b 08                	mov    (%eax),%ecx
80107d52:	f6 c5 02             	test   $0x2,%ch
80107d55:	75 29                	jne    80107d80 <pagefault+0x60>
    if(va >= KERNBASE || pte == 0)
80107d57:	85 db                	test   %ebx,%ebx
80107d59:	0f 88 e1 01 00 00    	js     80107f40 <pagefault+0x220>
  if(err & FEC_WR)
80107d5f:	f6 45 e4 02          	testb  $0x2,-0x1c(%ebp)
80107d63:	74 09                	je     80107d6e <pagefault+0x4e>
    if(!(*pte & PTE_COW)) 
80107d65:	f6 c5 04             	test   $0x4,%ch
80107d68:	0f 85 02 02 00 00    	jne    80107f70 <pagefault+0x250>
    curproc->killed = 1;
80107d6e:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
}
80107d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d78:	5b                   	pop    %ebx
80107d79:	5e                   	pop    %esi
80107d7a:	5f                   	pop    %edi
80107d7b:	5d                   	pop    %ebp
80107d7c:	c3                   	ret    
80107d7d:	8d 76 00             	lea    0x0(%esi),%esi
80107d80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d83:	31 db                	xor    %ebx,%ebx
    new_page = kalloc();
80107d85:	e8 96 ae ff ff       	call   80102c20 <kalloc>
    *pte &= 0xFFF;
80107d8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    *pte |= V2P(new_page);
80107d8d:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
80107d92:	8b 0a                	mov    (%edx),%ecx
80107d94:	81 e1 ff 0d 00 00    	and    $0xdff,%ecx
80107d9a:	83 c9 07             	or     $0x7,%ecx
    *pte |= V2P(new_page);
80107d9d:	09 c8                	or     %ecx,%eax
80107d9f:	89 02                	mov    %eax,(%edx)
  struct proc* curproc = myproc();
80107da1:	e8 ba c3 ff ff       	call   80104160 <myproc>
80107da6:	05 90 00 00 00       	add    $0x90,%eax
80107dab:	eb 12                	jmp    80107dbf <pagefault+0x9f>
80107dad:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107db0:	83 c3 01             	add    $0x1,%ebx
80107db3:	83 c0 10             	add    $0x10,%eax
80107db6:	83 fb 10             	cmp    $0x10,%ebx
80107db9:	0f 84 f1 01 00 00    	je     80107fb0 <pagefault+0x290>
    if(curproc->swappedPages[i].virt_addr == va)
80107dbf:	3b 38                	cmp    (%eax),%edi
80107dc1:	75 ed                	jne    80107db0 <pagefault+0x90>
80107dc3:	89 d8                	mov    %ebx,%eax
80107dc5:	c1 e0 04             	shl    $0x4,%eax
80107dc8:	05 88 00 00 00       	add    $0x88,%eax
80107dcd:	c1 e3 04             	shl    $0x4,%ebx
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80107dd0:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80107dd5:	01 f0                	add    %esi,%eax
80107dd7:	01 f3                	add    %esi,%ebx
80107dd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80107ddc:	ff b3 94 00 00 00    	pushl  0x94(%ebx)
80107de2:	68 00 d6 10 80       	push   $0x8010d600
80107de7:	56                   	push   %esi
80107de8:	e8 33 a7 ff ff       	call   80102520 <readFromSwapFile>
80107ded:	83 c4 10             	add    $0x10,%esp
80107df0:	85 c0                	test   %eax,%eax
80107df2:	0f 88 ba 02 00 00    	js     801080b2 <pagefault+0x392>
    struct fblock *new_block = (struct fblock*)kalloc();
80107df8:	e8 23 ae ff ff       	call   80102c20 <kalloc>
    new_block->off = swap_page->swap_offset;
80107dfd:	8b 93 94 00 00 00    	mov    0x94(%ebx),%edx
    new_block->next = 0;
80107e03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
80107e0a:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80107e0c:	8b 96 94 02 00 00    	mov    0x294(%esi),%edx
80107e12:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
80107e15:	8b 96 94 02 00 00    	mov    0x294(%esi),%edx
80107e1b:	85 d2                	test   %edx,%edx
80107e1d:	0f 84 05 02 00 00    	je     80108028 <pagefault+0x308>
      curproc->free_tail->next = new_block;
80107e23:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80107e26:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80107e29:	89 86 94 02 00 00    	mov    %eax,0x294(%esi)
    memmove((void*)start_page, buffer, PGSIZE);
80107e2f:	68 00 10 00 00       	push   $0x1000
80107e34:	68 00 d6 10 80       	push   $0x8010d600
80107e39:	57                   	push   %edi
80107e3a:	e8 f1 d1 ff ff       	call   80105030 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80107e3f:	83 c4 0c             	add    $0xc,%esp
80107e42:	6a 10                	push   $0x10
80107e44:	6a 00                	push   $0x0
80107e46:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e49:	e8 32 d1 ff ff       	call   80104f80 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80107e4e:	83 c4 10             	add    $0x10,%esp
80107e51:	83 be 88 02 00 00 0f 	cmpl   $0xf,0x288(%esi)
80107e58:	0f 8e 62 01 00 00    	jle    80107fc0 <pagefault+0x2a0>
      int swap_offset = curproc->free_head->off;
80107e5e:	8b 96 90 02 00 00    	mov    0x290(%esi),%edx
80107e64:	8b 02                	mov    (%edx),%eax
80107e66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
80107e69:	8b 42 04             	mov    0x4(%edx),%eax
80107e6c:	85 c0                	test   %eax,%eax
80107e6e:	0f 84 c4 01 00 00    	je     80108038 <pagefault+0x318>
        kfree((char*)curproc->free_head->prev);
80107e74:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107e77:	89 86 90 02 00 00    	mov    %eax,0x290(%esi)
        kfree((char*)curproc->free_head->prev);
80107e7d:	ff 70 08             	pushl  0x8(%eax)
80107e80:	e8 bb aa ff ff       	call   80102940 <kfree>
80107e85:	83 c4 10             	add    $0x10,%esp
      cprintf("swap off : %d\n", swap_offset);
80107e88:	83 ec 08             	sub    $0x8,%esp
80107e8b:	ff 75 e4             	pushl  -0x1c(%ebp)
80107e8e:	68 e3 8e 10 80       	push   $0x80108ee3
80107e93:	e8 c8 87 ff ff       	call   80100660 <cprintf>
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80107e98:	68 00 10 00 00       	push   $0x1000
80107e9d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ea0:	ff b6 40 02 00 00    	pushl  0x240(%esi)
80107ea6:	56                   	push   %esi
80107ea7:	e8 44 a6 ff ff       	call   801024f0 <writeToSwapFile>
80107eac:	83 c4 20             	add    $0x20,%esp
80107eaf:	85 c0                	test   %eax,%eax
80107eb1:	0f 88 15 02 00 00    	js     801080cc <pagefault+0x3ac>
      swap_page->virt_addr = ram_page->virt_addr;
80107eb7:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107ebd:	31 c9                	xor    %ecx,%ecx
      swap_page->virt_addr = ram_page->virt_addr;
80107ebf:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
      swap_page->pgdir = ram_page->pgdir;
80107ec5:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
      swap_page->isused = 1;
80107ecb:	c7 83 8c 00 00 00 01 	movl   $0x1,0x8c(%ebx)
80107ed2:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80107ed5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
      swap_page->swap_offset = swap_offset;
80107edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ede:	89 83 94 00 00 00    	mov    %eax,0x94(%ebx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107ee4:	8b 46 04             	mov    0x4(%esi),%eax
80107ee7:	e8 24 f2 ff ff       	call   80107110 <walkpgdir>
      if(!(*pte & PTE_P))
80107eec:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80107eee:	89 c3                	mov    %eax,%ebx
      if(!(*pte & PTE_P))
80107ef0:	f6 c2 01             	test   $0x1,%dl
80107ef3:	0f 84 c6 01 00 00    	je     801080bf <pagefault+0x39f>
      ramPa = (void*)PTE_ADDR(*pte);
80107ef9:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80107eff:	83 ec 0c             	sub    $0xc,%esp
80107f02:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107f08:	52                   	push   %edx
80107f09:	e8 32 aa ff ff       	call   80102940 <kfree>
      *pte &= ~PTE_P;                              // turn "present" flag off
80107f0e:	8b 03                	mov    (%ebx),%eax
80107f10:	25 fe 0f 00 00       	and    $0xffe,%eax
80107f15:	80 cc 02             	or     $0x2,%ah
80107f18:	89 03                	mov    %eax,(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80107f1a:	8b 46 04             	mov    0x4(%esi),%eax
      ram_page->virt_addr = start_page;
80107f1d:	89 be 40 02 00 00    	mov    %edi,0x240(%esi)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80107f23:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f28:	0f 22 d8             	mov    %eax,%cr3
80107f2b:	83 c4 10             	add    $0x10,%esp
}
80107f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f31:	5b                   	pop    %ebx
80107f32:	5e                   	pop    %esi
80107f33:	5f                   	pop    %edi
80107f34:	5d                   	pop    %ebp
80107f35:	c3                   	ret    
80107f36:	8d 76 00             	lea    0x0(%esi),%esi
80107f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80107f40:	8d 46 6c             	lea    0x6c(%esi),%eax
80107f43:	83 ec 04             	sub    $0x4,%esp
80107f46:	50                   	push   %eax
80107f47:	ff 76 10             	pushl  0x10(%esi)
80107f4a:	68 a4 8f 10 80       	push   $0x80108fa4
80107f4f:	e8 0c 87 ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80107f54:	c7 46 24 01 00 00 00 	movl   $0x1,0x24(%esi)
      return;
80107f5b:	83 c4 10             	add    $0x10,%esp
}
80107f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f61:	5b                   	pop    %ebx
80107f62:	5e                   	pop    %esi
80107f63:	5f                   	pop    %edi
80107f64:	5d                   	pop    %ebp
80107f65:	c3                   	ret    
80107f66:	8d 76 00             	lea    0x0(%esi),%esi
80107f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      pa = PTE_ADDR(*pte);
80107f70:	89 ce                	mov    %ecx,%esi
      ref_count = getRefs(virt_addr);
80107f72:	83 ec 0c             	sub    $0xc,%esp
80107f75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      pa = PTE_ADDR(*pte);
80107f78:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107f7e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
      char *virt_addr = P2V(pa);
80107f81:	81 c6 00 00 00 80    	add    $0x80000000,%esi
      ref_count = getRefs(virt_addr);
80107f87:	56                   	push   %esi
80107f88:	e8 23 ae ff ff       	call   80102db0 <getRefs>
      if (ref_count > 1) // more than one reference
80107f8d:	83 c4 10             	add    $0x10,%esp
80107f90:	83 f8 01             	cmp    $0x1,%eax
80107f93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107f96:	0f 8f c4 00 00 00    	jg     80108060 <pagefault+0x340>
        *pte &= ~PTE_COW; // turn COW off
80107f9c:	8b 02                	mov    (%edx),%eax
80107f9e:	80 e4 fb             	and    $0xfb,%ah
80107fa1:	83 c8 02             	or     $0x2,%eax
80107fa4:	89 02                	mov    %eax,(%edx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107fa6:	0f 01 3b             	invlpg (%ebx)
80107fa9:	e9 c7 fd ff ff       	jmp    80107d75 <pagefault+0x55>
80107fae:	66 90                	xchg   %ax,%ax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107fb0:	b8 78 00 00 00       	mov    $0x78,%eax
  return -1;
80107fb5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107fba:	e9 0e fe ff ff       	jmp    80107dcd <pagefault+0xad>
80107fbf:	90                   	nop
  struct proc * currproc = myproc();
80107fc0:	e8 9b c1 ff ff       	call   80104160 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80107fc5:	31 d2                	xor    %edx,%edx
80107fc7:	05 8c 01 00 00       	add    $0x18c,%eax
80107fcc:	eb 11                	jmp    80107fdf <pagefault+0x2bf>
80107fce:	66 90                	xchg   %ax,%ax
80107fd0:	83 c2 01             	add    $0x1,%edx
80107fd3:	83 c0 10             	add    $0x10,%eax
80107fd6:	83 fa 10             	cmp    $0x10,%edx
80107fd9:	0f 84 c9 00 00 00    	je     801080a8 <pagefault+0x388>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80107fdf:	8b 08                	mov    (%eax),%ecx
80107fe1:	85 c9                	test   %ecx,%ecx
80107fe3:	75 eb                	jne    80107fd0 <pagefault+0x2b0>
80107fe5:	c1 e2 04             	shl    $0x4,%edx
80107fe8:	01 f2                	add    %esi,%edx
      curproc->ramPages[new_indx].virt_addr = start_page;
80107fea:	89 ba 90 01 00 00    	mov    %edi,0x190(%edx)
      curproc->ramPages[new_indx].isused = 1;
80107ff0:	c7 82 8c 01 00 00 01 	movl   $0x1,0x18c(%edx)
80107ff7:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80107ffa:	8b 46 04             	mov    0x4(%esi),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80107ffd:	c7 82 94 01 00 00 ff 	movl   $0xffffffff,0x194(%edx)
80108004:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108007:	89 82 88 01 00 00    	mov    %eax,0x188(%edx)
      curproc->num_ram++;      
8010800d:	83 86 88 02 00 00 01 	addl   $0x1,0x288(%esi)
      curproc->num_swap--;
80108014:	83 ae 8c 02 00 00 01 	subl   $0x1,0x28c(%esi)
}
8010801b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010801e:	5b                   	pop    %ebx
8010801f:	5e                   	pop    %esi
80108020:	5f                   	pop    %edi
80108021:	5d                   	pop    %ebp
80108022:	c3                   	ret    
80108023:	90                   	nop
80108024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->free_head = new_block;
80108028:	89 86 90 02 00 00    	mov    %eax,0x290(%esi)
8010802e:	e9 f3 fd ff ff       	jmp    80107e26 <pagefault+0x106>
80108033:	90                   	nop
80108034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
80108038:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
8010803b:	c7 86 94 02 00 00 00 	movl   $0x0,0x294(%esi)
80108042:	00 00 00 
        kfree((char*)curproc->free_head);
80108045:	52                   	push   %edx
80108046:	e8 f5 a8 ff ff       	call   80102940 <kfree>
        curproc->free_head = 0;
8010804b:	c7 86 90 02 00 00 00 	movl   $0x0,0x290(%esi)
80108052:	00 00 00 
80108055:	83 c4 10             	add    $0x10,%esp
80108058:	e9 2b fe ff ff       	jmp    80107e88 <pagefault+0x168>
8010805d:	8d 76 00             	lea    0x0(%esi),%esi
        new_page = kalloc();
80108060:	e8 bb ab ff ff       	call   80102c20 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108065:	83 ec 04             	sub    $0x4,%esp
        new_page = kalloc();
80108068:	89 c7                	mov    %eax,%edi
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
8010806a:	68 00 10 00 00       	push   $0x1000
8010806f:	56                   	push   %esi
        new_pa = V2P(new_page);
80108070:	81 c7 00 00 00 80    	add    $0x80000000,%edi
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108076:	50                   	push   %eax
80108077:	e8 b4 cf ff ff       	call   80105030 <memmove>
      flags = PTE_FLAGS(*pte);
8010807c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
8010807f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      flags = PTE_FLAGS(*pte);
80108082:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108088:	83 c9 03             	or     $0x3,%ecx
8010808b:	09 f9                	or     %edi,%ecx
8010808d:	89 0a                	mov    %ecx,(%edx)
8010808f:	0f 01 3b             	invlpg (%ebx)
        refDec(virt_addr); // decrement old page's ref count
80108092:	89 34 24             	mov    %esi,(%esp)
80108095:	e8 36 ac ff ff       	call   80102cd0 <refDec>
8010809a:	83 c4 10             	add    $0x10,%esp
8010809d:	e9 d3 fc ff ff       	jmp    80107d75 <pagefault+0x55>
801080a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801080a8:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801080ad:	e9 33 ff ff ff       	jmp    80107fe5 <pagefault+0x2c5>
      panic("allocuvm: readFromSwapFile");
801080b2:	83 ec 0c             	sub    $0xc,%esp
801080b5:	68 c8 8e 10 80       	push   $0x80108ec8
801080ba:	e8 d1 82 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
801080bf:	83 ec 0c             	sub    $0xc,%esp
801080c2:	68 80 8f 10 80       	push   $0x80108f80
801080c7:	e8 c4 82 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801080cc:	83 ec 0c             	sub    $0xc,%esp
801080cf:	68 42 8e 10 80       	push   $0x80108e42
801080d4:	e8 b7 82 ff ff       	call   80100390 <panic>
801080d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801080e0 <copyuvm>:
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	57                   	push   %edi
801080e4:	56                   	push   %esi
801080e5:	53                   	push   %ebx
801080e6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801080e9:	e8 22 fa ff ff       	call   80107b10 <setupkvm>
801080ee:	85 c0                	test   %eax,%eax
801080f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080f3:	0f 84 be 00 00 00    	je     801081b7 <copyuvm+0xd7>
  for(i = 0; i < sz; i += PGSIZE){
801080f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801080fc:	85 db                	test   %ebx,%ebx
801080fe:	0f 84 b3 00 00 00    	je     801081b7 <copyuvm+0xd7>
80108104:	31 f6                	xor    %esi,%esi
80108106:	eb 69                	jmp    80108171 <copyuvm+0x91>
80108108:	90                   	nop
80108109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
80108110:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108112:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80108117:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
8010811d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108120:	e8 fb aa ff ff       	call   80102c20 <kalloc>
80108125:	85 c0                	test   %eax,%eax
80108127:	89 c3                	mov    %eax,%ebx
80108129:	0f 84 b1 00 00 00    	je     801081e0 <copyuvm+0x100>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010812f:	83 ec 04             	sub    $0x4,%esp
80108132:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108138:	68 00 10 00 00       	push   $0x1000
8010813d:	57                   	push   %edi
8010813e:	50                   	push   %eax
8010813f:	e8 ec ce ff ff       	call   80105030 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108144:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010814a:	5a                   	pop    %edx
8010814b:	59                   	pop    %ecx
8010814c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010814f:	50                   	push   %eax
80108150:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108155:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108158:	89 f2                	mov    %esi,%edx
8010815a:	e8 31 f0 ff ff       	call   80107190 <mappages>
8010815f:	83 c4 10             	add    $0x10,%esp
80108162:	85 c0                	test   %eax,%eax
80108164:	78 62                	js     801081c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108166:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010816c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010816f:	76 46                	jbe    801081b7 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108171:	8b 45 08             	mov    0x8(%ebp),%eax
80108174:	31 c9                	xor    %ecx,%ecx
80108176:	89 f2                	mov    %esi,%edx
80108178:	e8 93 ef ff ff       	call   80107110 <walkpgdir>
8010817d:	85 c0                	test   %eax,%eax
8010817f:	0f 84 93 00 00 00    	je     80108218 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108185:	8b 00                	mov    (%eax),%eax
80108187:	a9 01 02 00 00       	test   $0x201,%eax
8010818c:	74 7d                	je     8010820b <copyuvm+0x12b>
    if (*pte & PTE_PG) {
8010818e:	f6 c4 02             	test   $0x2,%ah
80108191:	0f 84 79 ff ff ff    	je     80108110 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108197:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010819a:	89 f2                	mov    %esi,%edx
8010819c:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801081a1:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801081a7:	e8 64 ef ff ff       	call   80107110 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
801081ac:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
801081af:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
801081b5:	77 ba                	ja     80108171 <copyuvm+0x91>
}
801081b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081bd:	5b                   	pop    %ebx
801081be:	5e                   	pop    %esi
801081bf:	5f                   	pop    %edi
801081c0:	5d                   	pop    %ebp
801081c1:	c3                   	ret    
801081c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
801081c8:	83 ec 0c             	sub    $0xc,%esp
801081cb:	68 0c 8f 10 80       	push   $0x80108f0c
801081d0:	e8 8b 84 ff ff       	call   80100660 <cprintf>
      kfree(mem);
801081d5:	89 1c 24             	mov    %ebx,(%esp)
801081d8:	e8 63 a7 ff ff       	call   80102940 <kfree>
      goto bad;
801081dd:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801081e0:	83 ec 0c             	sub    $0xc,%esp
801081e3:	68 26 8f 10 80       	push   $0x80108f26
801081e8:	e8 73 84 ff ff       	call   80100660 <cprintf>
  freevm(d);
801081ed:	58                   	pop    %eax
801081ee:	ff 75 e0             	pushl  -0x20(%ebp)
801081f1:	e8 9a f8 ff ff       	call   80107a90 <freevm>
  return 0;
801081f6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801081fd:	83 c4 10             	add    $0x10,%esp
}
80108200:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108206:	5b                   	pop    %ebx
80108207:	5e                   	pop    %esi
80108208:	5f                   	pop    %edi
80108209:	5d                   	pop    %ebp
8010820a:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
8010820b:	83 ec 0c             	sub    $0xc,%esp
8010820e:	68 d8 8f 10 80       	push   $0x80108fd8
80108213:	e8 78 81 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108218:	83 ec 0c             	sub    $0xc,%esp
8010821b:	68 f2 8e 10 80       	push   $0x80108ef2
80108220:	e8 6b 81 ff ff       	call   80100390 <panic>
80108225:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108230 <uva2ka>:
{
80108230:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80108231:	31 c9                	xor    %ecx,%ecx
{
80108233:	89 e5                	mov    %esp,%ebp
80108235:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108238:	8b 55 0c             	mov    0xc(%ebp),%edx
8010823b:	8b 45 08             	mov    0x8(%ebp),%eax
8010823e:	e8 cd ee ff ff       	call   80107110 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108243:	8b 00                	mov    (%eax),%eax
}
80108245:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108246:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108248:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010824d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108250:	05 00 00 00 80       	add    $0x80000000,%eax
80108255:	83 fa 05             	cmp    $0x5,%edx
80108258:	ba 00 00 00 00       	mov    $0x0,%edx
8010825d:	0f 45 c2             	cmovne %edx,%eax
}
80108260:	c3                   	ret    
80108261:	eb 0d                	jmp    80108270 <copyout>
80108263:	90                   	nop
80108264:	90                   	nop
80108265:	90                   	nop
80108266:	90                   	nop
80108267:	90                   	nop
80108268:	90                   	nop
80108269:	90                   	nop
8010826a:	90                   	nop
8010826b:	90                   	nop
8010826c:	90                   	nop
8010826d:	90                   	nop
8010826e:	90                   	nop
8010826f:	90                   	nop

80108270 <copyout>:
{
80108270:	55                   	push   %ebp
80108271:	89 e5                	mov    %esp,%ebp
80108273:	57                   	push   %edi
80108274:	56                   	push   %esi
80108275:	53                   	push   %ebx
80108276:	83 ec 1c             	sub    $0x1c,%esp
80108279:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010827c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010827f:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80108282:	85 db                	test   %ebx,%ebx
80108284:	75 40                	jne    801082c6 <copyout+0x56>
80108286:	eb 70                	jmp    801082f8 <copyout+0x88>
80108288:	90                   	nop
80108289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80108290:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108293:	89 f1                	mov    %esi,%ecx
80108295:	29 d1                	sub    %edx,%ecx
80108297:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010829d:	39 d9                	cmp    %ebx,%ecx
8010829f:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
801082a2:	29 f2                	sub    %esi,%edx
801082a4:	83 ec 04             	sub    $0x4,%esp
801082a7:	01 d0                	add    %edx,%eax
801082a9:	51                   	push   %ecx
801082aa:	57                   	push   %edi
801082ab:	50                   	push   %eax
801082ac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801082af:	e8 7c cd ff ff       	call   80105030 <memmove>
    buf += n;
801082b4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801082b7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801082ba:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801082c0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801082c2:	29 cb                	sub    %ecx,%ebx
801082c4:	74 32                	je     801082f8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801082c6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801082c8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801082cb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801082ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801082d4:	56                   	push   %esi
801082d5:	ff 75 08             	pushl  0x8(%ebp)
801082d8:	e8 53 ff ff ff       	call   80108230 <uva2ka>
    if(pa0 == 0)
801082dd:	83 c4 10             	add    $0x10,%esp
801082e0:	85 c0                	test   %eax,%eax
801082e2:	75 ac                	jne    80108290 <copyout+0x20>
}
801082e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801082e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082ec:	5b                   	pop    %ebx
801082ed:	5e                   	pop    %esi
801082ee:	5f                   	pop    %edi
801082ef:	5d                   	pop    %ebp
801082f0:	c3                   	ret    
801082f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082fb:	31 c0                	xor    %eax,%eax
}
801082fd:	5b                   	pop    %ebx
801082fe:	5e                   	pop    %esi
801082ff:	5f                   	pop    %edi
80108300:	5d                   	pop    %ebp
80108301:	c3                   	ret    
80108302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108310 <getNextFreeRamIndex>:
{ 
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80108316:	e8 45 be ff ff       	call   80104160 <myproc>
8010831b:	8d 90 8c 01 00 00    	lea    0x18c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108321:	31 c0                	xor    %eax,%eax
80108323:	eb 0e                	jmp    80108333 <getNextFreeRamIndex+0x23>
80108325:	8d 76 00             	lea    0x0(%esi),%esi
80108328:	83 c0 01             	add    $0x1,%eax
8010832b:	83 c2 10             	add    $0x10,%edx
8010832e:	83 f8 10             	cmp    $0x10,%eax
80108331:	74 0d                	je     80108340 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108333:	8b 0a                	mov    (%edx),%ecx
80108335:	85 c9                	test   %ecx,%ecx
80108337:	75 ef                	jne    80108328 <getNextFreeRamIndex+0x18>
}
80108339:	c9                   	leave  
8010833a:	c3                   	ret    
8010833b:	90                   	nop
8010833c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108340:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108345:	c9                   	leave  
80108346:	c3                   	ret    
