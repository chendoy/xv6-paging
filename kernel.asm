
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
80100028:	bc e0 e5 10 80       	mov    $0x8010e5e0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 38 10 80       	mov    $0x80103850,%eax
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
80100044:	bb 14 e6 10 80       	mov    $0x8010e614,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 8f 10 80       	push   $0x80108f00
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 65 50 00 00       	call   801050c0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 2c 2d 11 80 dc 	movl   $0x80112cdc,0x80112d2c
80100062:	2c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 30 2d 11 80 dc 	movl   $0x80112cdc,0x80112d30
8010006c:	2c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba dc 2c 11 80       	mov    $0x80112cdc,%edx
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
8010008b:	c7 43 50 dc 2c 11 80 	movl   $0x80112cdc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 8f 10 80       	push   $0x80108f07
80100097:	50                   	push   %eax
80100098:	e8 f3 4e 00 00       	call   80104f90 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 30 2d 11 80       	mov    0x80112d30,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 30 2d 11 80    	mov    %ebx,0x80112d30
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d dc 2c 11 80       	cmp    $0x80112cdc,%eax
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
801000df:	68 e0 e5 10 80       	push   $0x8010e5e0
801000e4:	e8 17 51 00 00       	call   80105200 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 30 2d 11 80    	mov    0x80112d30,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
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
80100120:	8b 1d 2c 2d 11 80    	mov    0x80112d2c,%ebx
80100126:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb dc 2c 11 80    	cmp    $0x80112cdc,%ebx
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
8010015d:	68 e0 e5 10 80       	push   $0x8010e5e0
80100162:	e8 59 51 00 00       	call   801052c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 4e 00 00       	call   80104fd0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 dd 26 00 00       	call   80102860 <iderw>
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
80100193:	68 0e 8f 10 80       	push   $0x80108f0e
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
801001ae:	e8 bd 4e 00 00       	call   80105070 <holdingsleep>
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
801001c4:	e9 97 26 00 00       	jmp    80102860 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 8f 10 80       	push   $0x80108f1f
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
801001ef:	e8 7c 4e 00 00       	call   80105070 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 4e 00 00       	call   80105030 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 f0 4f 00 00       	call   80105200 <acquire>
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
80100232:	a1 30 2d 11 80       	mov    0x80112d30,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 dc 2c 11 80 	movl   $0x80112cdc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 30 2d 11 80       	mov    0x80112d30,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 30 2d 11 80    	mov    %ebx,0x80112d30
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 e0 e5 10 80 	movl   $0x8010e5e0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 50 00 00       	jmp    801052c0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 8f 10 80       	push   $0x80108f26
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
80100280:	e8 8b 18 00 00       	call   80101b10 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 6f 4f 00 00       	call   80105200 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002a7:	39 15 c4 2f 11 80    	cmp    %edx,0x80112fc4
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
801002c0:	68 c0 2f 11 80       	push   $0x80112fc0
801002c5:	e8 e6 47 00 00       	call   80104ab0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 2f 11 80    	cmp    0x80112fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 e0 3f 00 00       	call   801042c0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 cc 4f 00 00       	call   801052c0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 34 17 00 00       	call   80101a30 <ilock>
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
80100313:	a3 c0 2f 11 80       	mov    %eax,0x80112fc0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 40 2f 11 80 	movsbl -0x7feed0c0(%eax),%eax
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
8010034d:	e8 6e 4f 00 00       	call   801052c0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 d6 16 00 00       	call   80101a30 <ilock>
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
80100372:	89 15 c0 2f 11 80    	mov    %edx,0x80112fc0
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
801003a9:	e8 32 2d 00 00       	call   801030e0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 2d 8f 10 80       	push   $0x80108f2d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 c0 9a 10 80 	movl   $0x80109ac0,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 4d 00 00       	call   801050e0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 41 8f 10 80       	push   $0x80108f41
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
8010043a:	e8 c1 65 00 00       	call   80106a00 <uartputc>
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
801004ec:	e8 0f 65 00 00       	call   80106a00 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 03 65 00 00       	call   80106a00 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 f7 64 00 00       	call   80106a00 <uartputc>
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
80100524:	e8 97 4e 00 00       	call   801053c0 <memmove>
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
80100541:	e8 ca 4d 00 00       	call   80105310 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 45 8f 10 80       	push   $0x80108f45
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
801005b1:	0f b6 92 70 8f 10 80 	movzbl -0x7fef7090(%edx),%edx
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
8010060f:	e8 fc 14 00 00       	call   80101b10 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 e0 4b 00 00       	call   80105200 <acquire>
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
80100647:	e8 74 4c 00 00       	call   801052c0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 db 13 00 00       	call   80101a30 <ilock>

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
8010071f:	e8 9c 4b 00 00       	call   801052c0 <release>
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
801007d0:	ba 58 8f 10 80       	mov    $0x80108f58,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 0b 4a 00 00       	call   80105200 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 5f 8f 10 80       	push   $0x80108f5f
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
80100823:	e8 d8 49 00 00       	call   80105200 <acquire>
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
80100851:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
80100856:	3b 05 c4 2f 11 80    	cmp    0x80112fc4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 c8 2f 11 80       	mov    %eax,0x80112fc8
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
80100888:	e8 33 4a 00 00       	call   801052c0 <release>
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
801008a9:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 c0 2f 11 80    	sub    0x80112fc0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 c8 2f 11 80    	mov    %edx,0x80112fc8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 40 2f 11 80    	mov    %cl,-0x7feed0c0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 c0 2f 11 80       	mov    0x80112fc0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 c8 2f 11 80    	cmp    %eax,0x80112fc8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 c4 2f 11 80       	mov    %eax,0x80112fc4
          wakeup(&input.r);
80100911:	68 c0 2f 11 80       	push   $0x80112fc0
80100916:	e8 d5 43 00 00       	call   80104cf0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
8010093d:	39 05 c4 2f 11 80    	cmp    %eax,0x80112fc4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 c8 2f 11 80       	mov    %eax,0x80112fc8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
80100964:	3b 05 c4 2f 11 80    	cmp    0x80112fc4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 40 2f 11 80 0a 	cmpb   $0xa,-0x7feed0c0(%edx)
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
80100997:	e9 e4 44 00 00       	jmp    80104e80 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 40 2f 11 80 0a 	movb   $0xa,-0x7feed0c0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 c8 2f 11 80       	mov    0x80112fc8,%eax
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
801009c6:	68 68 8f 10 80       	push   $0x80108f68
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 eb 46 00 00       	call   801050c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 4c 3d 11 80 00 	movl   $0x80100600,0x80113d4c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 48 3d 11 80 70 	movl   $0x80100270,0x80113d48
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 c5 10 80 01 	movl   $0x1,0x8010c554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 12 20 00 00       	call   80102a10 <ioapicenable>
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

80100a10 <backup>:
struct queue_node* queue_tail_backup;
struct file* swapfile_backup;

void 
backup(struct proc* curproc)
{  
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	53                   	push   %ebx
80100a14:	83 ec 08             	sub    $0x8,%esp
80100a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("exec now\n");
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100a1a:	68 c0 01 00 00       	push   $0x1c0
80100a1f:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100a25:	50                   	push   %eax
80100a26:	68 e0 2f 11 80       	push   $0x80112fe0
80100a2b:	e8 90 49 00 00       	call   801053c0 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a30:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a36:	83 c4 0c             	add    $0xc,%esp
80100a39:	68 c0 01 00 00       	push   $0x1c0
80100a3e:	50                   	push   %eax
80100a3f:	68 c0 31 11 80       	push   $0x801131c0
80100a44:	e8 77 49 00 00       	call   801053c0 <memmove>
  num_ram_backup = curproc->num_ram; 
80100a49:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
  free_tail_backup = curproc->free_tail;
  swapfile_backup = curproc->swapFile;
  queue_head_backup = curproc->queue_head;
  queue_tail_backup = curproc->queue_tail;
  clockhand_backup = curproc->clockHand;
}
80100a4f:	83 c4 10             	add    $0x10,%esp
  num_ram_backup = curproc->num_ram; 
80100a52:	a3 6c c5 10 80       	mov    %eax,0x8010c56c
  num_swap_backup = curproc->num_swap;
80100a57:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80100a5d:	a3 68 c5 10 80       	mov    %eax,0x8010c568
  free_head_backup = curproc->free_head;
80100a62:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80100a68:	a3 60 c5 10 80       	mov    %eax,0x8010c560
  free_tail_backup = curproc->free_tail;
80100a6d:	8b 83 18 04 00 00    	mov    0x418(%ebx),%eax
80100a73:	a3 5c c5 10 80       	mov    %eax,0x8010c55c
  swapfile_backup = curproc->swapFile;
80100a78:	8b 43 7c             	mov    0x7c(%ebx),%eax
80100a7b:	a3 a0 31 11 80       	mov    %eax,0x801131a0
  queue_head_backup = curproc->queue_head;
80100a80:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80100a86:	a3 80 33 11 80       	mov    %eax,0x80113380
  queue_tail_backup = curproc->queue_tail;
80100a8b:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
80100a91:	a3 84 33 11 80       	mov    %eax,0x80113384
  clockhand_backup = curproc->clockHand;
80100a96:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
}
80100a9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  clockhand_backup = curproc->clockHand;
80100a9f:	a3 64 c5 10 80       	mov    %eax,0x8010c564
}
80100aa4:	c9                   	leave  
80100aa5:	c3                   	ret    
80100aa6:	8d 76 00             	lea    0x0(%esi),%esi
80100aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ab0 <clean_arrays>:

void 
clean_arrays(struct proc* curproc)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	53                   	push   %ebx
80100ab4:	83 ec 08             	sub    $0x8,%esp
80100ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
80100aba:	68 c0 01 00 00       	push   $0x1c0
80100abf:	6a 00                	push   $0x0
80100ac1:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100ac7:	50                   	push   %eax
80100ac8:	e8 43 48 00 00       	call   80105310 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100acd:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ad3:	83 c4 0c             	add    $0xc,%esp
80100ad6:	68 c0 01 00 00       	push   $0x1c0
80100adb:	6a 00                	push   $0x0
80100add:	50                   	push   %eax
80100ade:	e8 2d 48 00 00       	call   80105310 <memset>
  curproc->num_ram = 0;
80100ae3:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80100aea:	00 00 00 
  curproc->num_swap = 0;
80100aed:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80100af4:	00 00 00 
}
80100af7:	83 c4 10             	add    $0x10,%esp
80100afa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100afd:	c9                   	leave  
80100afe:	c3                   	ret    
80100aff:	90                   	nop

80100b00 <alloc_fresh_fblocklst>:

void
alloc_fresh_fblocklst(struct proc* curproc)
{
80100b00:	55                   	push   %ebp
80100b01:	89 e5                	mov    %esp,%ebp
80100b03:	57                   	push   %edi
80100b04:	56                   	push   %esi
80100b05:	53                   	push   %ebx
 /*allocating fresh fblock list */
  curproc->free_head = (struct fblock*)kalloc();
  curproc->free_head->prev = 0;
  curproc->free_head->off = 0 * PGSIZE;
  struct fblock *prev = curproc->free_head;
80100b06:	bb 00 10 00 00       	mov    $0x1000,%ebx
{
80100b0b:	83 ec 0c             	sub    $0xc,%esp
80100b0e:	8b 75 08             	mov    0x8(%ebp),%esi
  curproc->free_head = (struct fblock*)kalloc();
80100b11:	e8 1a 22 00 00       	call   80102d30 <kalloc>
80100b16:	89 86 14 04 00 00    	mov    %eax,0x414(%esi)
  curproc->free_head->prev = 0;
80100b1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  curproc->free_head->off = 0 * PGSIZE;
80100b23:	8b 86 14 04 00 00    	mov    0x414(%esi),%eax
80100b29:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  struct fblock *prev = curproc->free_head;
80100b2f:	8b be 14 04 00 00    	mov    0x414(%esi),%edi
80100b35:	8d 76 00             	lea    0x0(%esi),%esi

  for(int i = 1; i < MAX_PSYC_PAGES; i++)
  {
    struct fblock *curr = (struct fblock*)kalloc();
80100b38:	e8 f3 21 00 00       	call   80102d30 <kalloc>
    curr->off = i * PGSIZE;
80100b3d:	89 18                	mov    %ebx,(%eax)
80100b3f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    curr->prev = prev;
80100b45:	89 78 08             	mov    %edi,0x8(%eax)
  for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100b48:	81 fb 00 00 01 00    	cmp    $0x10000,%ebx
    curr->prev->next = curr;
80100b4e:	89 47 04             	mov    %eax,0x4(%edi)
80100b51:	89 c7                	mov    %eax,%edi
  for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100b53:	75 e3                	jne    80100b38 <alloc_fresh_fblocklst+0x38>
    prev = curr;
  }
  curproc->free_tail = prev;
80100b55:	89 86 18 04 00 00    	mov    %eax,0x418(%esi)
  curproc->free_tail->next = 0;
80100b5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
80100b62:	83 c4 0c             	add    $0xc,%esp
80100b65:	5b                   	pop    %ebx
80100b66:	5e                   	pop    %esi
80100b67:	5f                   	pop    %edi
80100b68:	5d                   	pop    %ebp
80100b69:	c3                   	ret    
80100b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b70 <clean_by_selection>:

void
clean_by_selection(struct proc* curproc)
{
80100b70:	55                   	push   %ebp
80100b71:	89 e5                	mov    %esp,%ebp
80100b73:	53                   	push   %ebx
80100b74:	83 ec 04             	sub    $0x4,%esp
80100b77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(curproc->selection == AQ)
80100b7a:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100b80:	83 f8 04             	cmp    $0x4,%eax
80100b83:	74 1b                	je     80100ba0 <clean_by_selection+0x30>
    curproc->queue_head = 0;
    curproc->queue_tail = 0;
    cprintf("cleaning exec queue\n");
  }

  if(curproc->selection == SCFIFO)
80100b85:	83 f8 03             	cmp    $0x3,%eax
80100b88:	75 0a                	jne    80100b94 <clean_by_selection+0x24>
  {
    curproc->clockHand = 0;
80100b8a:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80100b91:	00 00 00 
  }
}
80100b94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b97:	c9                   	leave  
80100b98:	c3                   	ret    
80100b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cleaning exec queue\n");
80100ba0:	83 ec 0c             	sub    $0xc,%esp
    curproc->queue_head = 0;
80100ba3:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80100baa:	00 00 00 
    curproc->queue_tail = 0;
80100bad:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80100bb4:	00 00 00 
    cprintf("cleaning exec queue\n");
80100bb7:	68 81 8f 10 80       	push   $0x80108f81
80100bbc:	e8 9f fa ff ff       	call   80100660 <cprintf>
80100bc1:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100bc7:	83 c4 10             	add    $0x10,%esp
80100bca:	eb b9                	jmp    80100b85 <clean_by_selection+0x15>
80100bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100bd0 <allocate_fresh>:
void 
allocate_fresh(struct proc* curproc)
{
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	53                   	push   %ebx
80100bd4:	83 ec 10             	sub    $0x10,%esp
80100bd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(createSwapFile(curproc) != 0)
80100bda:	53                   	push   %ebx
80100bdb:	e8 80 19 00 00       	call   80102560 <createSwapFile>
80100be0:	83 c4 10             	add    $0x10,%esp
80100be3:	85 c0                	test   %eax,%eax
80100be5:	75 65                	jne    80100c4c <allocate_fresh+0x7c>
    panic("exec: create swapfile for exec proc failed");
  clean_arrays(curproc);
80100be7:	83 ec 0c             	sub    $0xc,%esp
80100bea:	53                   	push   %ebx
80100beb:	e8 c0 fe ff ff       	call   80100ab0 <clean_arrays>
  alloc_fresh_fblocklst(curproc);
80100bf0:	89 1c 24             	mov    %ebx,(%esp)
80100bf3:	e8 08 ff ff ff       	call   80100b00 <alloc_fresh_fblocklst>
  if(curproc->selection == AQ)
80100bf8:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100bfe:	83 c4 10             	add    $0x10,%esp
80100c01:	83 f8 04             	cmp    $0x4,%eax
80100c04:	74 1a                	je     80100c20 <allocate_fresh+0x50>
  if(curproc->selection == SCFIFO)
80100c06:	83 f8 03             	cmp    $0x3,%eax
80100c09:	75 0a                	jne    80100c15 <allocate_fresh+0x45>
    curproc->clockHand = 0;
80100c0b:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80100c12:	00 00 00 
  clean_by_selection(curproc);

}
80100c15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c18:	c9                   	leave  
80100c19:	c3                   	ret    
80100c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("cleaning exec queue\n");
80100c20:	83 ec 0c             	sub    $0xc,%esp
    curproc->queue_head = 0;
80100c23:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80100c2a:	00 00 00 
    curproc->queue_tail = 0;
80100c2d:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80100c34:	00 00 00 
    cprintf("cleaning exec queue\n");
80100c37:	68 81 8f 10 80       	push   $0x80108f81
80100c3c:	e8 1f fa ff ff       	call   80100660 <cprintf>
80100c41:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	eb ba                	jmp    80100c06 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	68 b0 8f 10 80       	push   $0x80108fb0
80100c54:	e8 37 f7 ff ff       	call   80100390 <panic>
80100c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100c60 <exec>:

int
exec(char *path, char **argv)
{
80100c60:	55                   	push   %ebp
80100c61:	89 e5                	mov    %esp,%ebp
80100c63:	57                   	push   %edi
80100c64:	56                   	push   %esi
80100c65:	53                   	push   %ebx
80100c66:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c6c:	e8 4f 36 00 00       	call   801042c0 <myproc>
  
  if(curproc->pid > 2)
80100c71:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *curproc = myproc();
80100c75:	89 c3                	mov    %eax,%ebx
  if(curproc->pid > 2)
80100c77:	0f 8f 93 00 00 00    	jg     80100d10 <exec+0xb0>
  {  
    backup(curproc);
    allocate_fresh(curproc);
  }

  begin_op();
80100c7d:	e8 ce 28 00 00       	call   80103550 <begin_op>

  if((ip = namei(path)) == 0){
80100c82:	83 ec 0c             	sub    $0xc,%esp
80100c85:	ff 75 08             	pushl  0x8(%ebp)
80100c88:	e8 03 16 00 00       	call   80102290 <namei>
80100c8d:	83 c4 10             	add    $0x10,%esp
80100c90:	85 c0                	test   %eax,%eax
80100c92:	89 c6                	mov    %eax,%esi
80100c94:	0f 84 2e 03 00 00    	je     80100fc8 <exec+0x368>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c9a:	83 ec 0c             	sub    $0xc,%esp
80100c9d:	50                   	push   %eax
80100c9e:	e8 8d 0d 00 00       	call   80101a30 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ca3:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ca9:	6a 34                	push   $0x34
80100cab:	6a 00                	push   $0x0
80100cad:	50                   	push   %eax
80100cae:	56                   	push   %esi
80100caf:	e8 5c 10 00 00       	call   80101d10 <readi>
80100cb4:	83 c4 20             	add    $0x20,%esp
80100cb7:	83 f8 34             	cmp    $0x34,%eax
80100cba:	75 10                	jne    80100ccc <exec+0x6c>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100cbc:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100cc3:	45 4c 46 
80100cc6:	0f 84 f4 00 00 00    	je     80100dc0 <exec+0x160>
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  cprintf("exec: bad\n");
80100ccc:	83 ec 0c             	sub    $0xc,%esp
80100ccf:	68 a2 8f 10 80       	push   $0x80108fa2
80100cd4:	e8 87 f9 ff ff       	call   80100660 <cprintf>
80100cd9:	83 c4 10             	add    $0x10,%esp
  if(pgdir)
    freevm(pgdir);
  /* restoring variables */
  if(curproc->pid > 2)
80100cdc:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100ce0:	7f 4e                	jg     80100d30 <exec+0xd0>
    curproc->queue_head = queue_head_backup;
    curproc->queue_tail = queue_tail_backup;
  }
  

  if(ip){
80100ce2:	85 f6                	test   %esi,%esi
    iunlockput(ip);
    end_op();
  }
  return -1;
80100ce4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(ip){
80100ce9:	74 11                	je     80100cfc <exec+0x9c>
    iunlockput(ip);
80100ceb:	83 ec 0c             	sub    $0xc,%esp
80100cee:	56                   	push   %esi
80100cef:	e8 cc 0f 00 00       	call   80101cc0 <iunlockput>
    end_op();
80100cf4:	e8 c7 28 00 00       	call   801035c0 <end_op>
80100cf9:	83 c4 10             	add    $0x10,%esp
}
80100cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100cff:	89 d8                	mov    %ebx,%eax
80100d01:	5b                   	pop    %ebx
80100d02:	5e                   	pop    %esi
80100d03:	5f                   	pop    %edi
80100d04:	5d                   	pop    %ebp
80100d05:	c3                   	ret    
80100d06:	8d 76 00             	lea    0x0(%esi),%esi
80100d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    backup(curproc);
80100d10:	83 ec 0c             	sub    $0xc,%esp
80100d13:	50                   	push   %eax
80100d14:	e8 f7 fc ff ff       	call   80100a10 <backup>
    allocate_fresh(curproc);
80100d19:	89 1c 24             	mov    %ebx,(%esp)
80100d1c:	e8 af fe ff ff       	call   80100bd0 <allocate_fresh>
80100d21:	83 c4 10             	add    $0x10,%esp
80100d24:	e9 54 ff ff ff       	jmp    80100c7d <exec+0x1d>
80100d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove((void*)curproc->ramPages, ramPagesBackup, 16 * sizeof(struct page));
80100d30:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100d36:	83 ec 04             	sub    $0x4,%esp
80100d39:	68 c0 01 00 00       	push   $0x1c0
80100d3e:	68 e0 2f 11 80       	push   $0x80112fe0
80100d43:	50                   	push   %eax
80100d44:	e8 77 46 00 00       	call   801053c0 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d49:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d4f:	83 c4 0c             	add    $0xc,%esp
80100d52:	68 c0 01 00 00       	push   $0x1c0
80100d57:	68 c0 31 11 80       	push   $0x801131c0
80100d5c:	50                   	push   %eax
80100d5d:	e8 5e 46 00 00       	call   801053c0 <memmove>
    curproc->free_head = free_head_backup;
80100d62:	a1 60 c5 10 80       	mov    0x8010c560,%eax
    curproc->queue_tail = queue_tail_backup;
80100d67:	83 c4 10             	add    $0x10,%esp
    curproc->free_head = free_head_backup;
80100d6a:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
    curproc->free_tail = free_tail_backup;
80100d70:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100d75:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    curproc->num_ram = num_ram_backup;
80100d7b:	a1 6c c5 10 80       	mov    0x8010c56c,%eax
80100d80:	89 83 08 04 00 00    	mov    %eax,0x408(%ebx)
    curproc->num_swap = num_swap_backup;
80100d86:	a1 68 c5 10 80       	mov    0x8010c568,%eax
80100d8b:	89 83 0c 04 00 00    	mov    %eax,0x40c(%ebx)
    curproc->swapFile = swapfile_backup;
80100d91:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80100d96:	89 43 7c             	mov    %eax,0x7c(%ebx)
    curproc->clockHand = clockhand_backup;
80100d99:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80100d9e:	89 83 10 04 00 00    	mov    %eax,0x410(%ebx)
    curproc->queue_head = queue_head_backup;
80100da4:	a1 80 33 11 80       	mov    0x80113380,%eax
80100da9:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
    curproc->queue_tail = queue_tail_backup;
80100daf:	a1 84 33 11 80       	mov    0x80113384,%eax
80100db4:	89 83 20 04 00 00    	mov    %eax,0x420(%ebx)
80100dba:	e9 23 ff ff ff       	jmp    80100ce2 <exec+0x82>
80100dbf:	90                   	nop
  if((pgdir = setupkvm()) == 0)
80100dc0:	e8 9b 72 00 00       	call   80108060 <setupkvm>
80100dc5:	85 c0                	test   %eax,%eax
80100dc7:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100dcd:	0f 84 f9 fe ff ff    	je     80100ccc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100dda:	00 
80100ddb:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100de1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100de7:	0f 84 00 03 00 00    	je     801010ed <exec+0x48d>
  sz = 0;
80100ded:	31 c0                	xor    %eax,%eax
80100def:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100df5:	31 ff                	xor    %edi,%edi
80100df7:	89 c3                	mov    %eax,%ebx
80100df9:	eb 7f                	jmp    80100e7a <exec+0x21a>
80100dfb:	90                   	nop
80100dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100e00:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100e07:	75 63                	jne    80100e6c <exec+0x20c>
    if(ph.memsz < ph.filesz)
80100e09:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100e0f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100e15:	0f 82 86 00 00 00    	jb     80100ea1 <exec+0x241>
80100e1b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e21:	72 7e                	jb     80100ea1 <exec+0x241>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e23:	83 ec 04             	sub    $0x4,%esp
80100e26:	50                   	push   %eax
80100e27:	53                   	push   %ebx
80100e28:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e2e:	e8 1d 70 00 00       	call   80107e50 <allocuvm>
80100e33:	83 c4 10             	add    $0x10,%esp
80100e36:	85 c0                	test   %eax,%eax
80100e38:	89 c3                	mov    %eax,%ebx
80100e3a:	74 65                	je     80100ea1 <exec+0x241>
    if(ph.vaddr % PGSIZE != 0)
80100e3c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e42:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e47:	75 58                	jne    80100ea1 <exec+0x241>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e49:	83 ec 0c             	sub    $0xc,%esp
80100e4c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e52:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e58:	56                   	push   %esi
80100e59:	50                   	push   %eax
80100e5a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e60:	e8 eb 6a 00 00       	call   80107950 <loaduvm>
80100e65:	83 c4 20             	add    $0x20,%esp
80100e68:	85 c0                	test   %eax,%eax
80100e6a:	78 35                	js     80100ea1 <exec+0x241>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e6c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e73:	83 c7 01             	add    $0x1,%edi
80100e76:	39 f8                	cmp    %edi,%eax
80100e78:	7e 56                	jle    80100ed0 <exec+0x270>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e7a:	89 f8                	mov    %edi,%eax
80100e7c:	6a 20                	push   $0x20
80100e7e:	c1 e0 05             	shl    $0x5,%eax
80100e81:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100e87:	50                   	push   %eax
80100e88:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e8e:	50                   	push   %eax
80100e8f:	56                   	push   %esi
80100e90:	e8 7b 0e 00 00       	call   80101d10 <readi>
80100e95:	83 c4 10             	add    $0x10,%esp
80100e98:	83 f8 20             	cmp    $0x20,%eax
80100e9b:	0f 84 5f ff ff ff    	je     80100e00 <exec+0x1a0>
80100ea1:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  cprintf("exec: bad\n");
80100ea7:	83 ec 0c             	sub    $0xc,%esp
80100eaa:	68 a2 8f 10 80       	push   $0x80108fa2
80100eaf:	e8 ac f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100eb4:	58                   	pop    %eax
80100eb5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ebb:	e8 20 71 00 00       	call   80107fe0 <freevm>
80100ec0:	83 c4 10             	add    $0x10,%esp
80100ec3:	e9 14 fe ff ff       	jmp    80100cdc <exec+0x7c>
80100ec8:	90                   	nop
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ed0:	89 d8                	mov    %ebx,%eax
80100ed2:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100ed8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100edd:	89 c7                	mov    %eax,%edi
80100edf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100ee5:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100eeb:	83 ec 0c             	sub    $0xc,%esp
80100eee:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ef4:	56                   	push   %esi
80100ef5:	e8 c6 0d 00 00       	call   80101cc0 <iunlockput>
  end_op();
80100efa:	e8 c1 26 00 00       	call   801035c0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100eff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f05:	83 c4 0c             	add    $0xc,%esp
80100f08:	50                   	push   %eax
80100f09:	57                   	push   %edi
80100f0a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f10:	e8 3b 6f 00 00       	call   80107e50 <allocuvm>
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	85 c0                	test   %eax,%eax
80100f1a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f20:	75 04                	jne    80100f26 <exec+0x2c6>
  ip = 0;
80100f22:	31 f6                	xor    %esi,%esi
80100f24:	eb 81                	jmp    80100ea7 <exec+0x247>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f26:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f2c:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100f2f:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f31:	8d 86 00 e0 ff ff    	lea    -0x2000(%esi),%eax
80100f37:	50                   	push   %eax
80100f38:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f3e:	e8 cd 71 00 00       	call   80108110 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f46:	83 c4 10             	add    $0x10,%esp
80100f49:	8b 00                	mov    (%eax),%eax
80100f4b:	85 c0                	test   %eax,%eax
80100f4d:	0f 84 a6 01 00 00    	je     801010f9 <exec+0x499>
80100f53:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
80100f59:	89 fb                	mov    %edi,%ebx
80100f5b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100f61:	eb 24                	jmp    80100f87 <exec+0x327>
80100f63:	90                   	nop
80100f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f68:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f6b:	89 b4 9d 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100f72:	83 c3 01             	add    $0x1,%ebx
    ustack[3+argc] = sp;
80100f75:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100f7b:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	74 65                	je     80100fe7 <exec+0x387>
    if(argc >= MAXARG)
80100f82:	83 fb 20             	cmp    $0x20,%ebx
80100f85:	74 34                	je     80100fbb <exec+0x35b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	50                   	push   %eax
80100f8b:	e8 a0 45 00 00       	call   80105530 <strlen>
80100f90:	f7 d0                	not    %eax
80100f92:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f94:	58                   	pop    %eax
80100f95:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f98:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f9b:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f9e:	e8 8d 45 00 00       	call   80105530 <strlen>
80100fa3:	83 c0 01             	add    $0x1,%eax
80100fa6:	50                   	push   %eax
80100fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faa:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fad:	56                   	push   %esi
80100fae:	57                   	push   %edi
80100faf:	e8 fc 78 00 00       	call   801088b0 <copyout>
80100fb4:	83 c4 20             	add    $0x20,%esp
80100fb7:	85 c0                	test   %eax,%eax
80100fb9:	79 ad                	jns    80100f68 <exec+0x308>
80100fbb:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ip = 0;
80100fc1:	31 f6                	xor    %esi,%esi
80100fc3:	e9 df fe ff ff       	jmp    80100ea7 <exec+0x247>
    end_op();
80100fc8:	e8 f3 25 00 00       	call   801035c0 <end_op>
    cprintf("exec: fail\n");
80100fcd:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80100fd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("exec: fail\n");
80100fd5:	68 96 8f 10 80       	push   $0x80108f96
80100fda:	e8 81 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100fdf:	83 c4 10             	add    $0x10,%esp
80100fe2:	e9 15 fd ff ff       	jmp    80100cfc <exec+0x9c>
80100fe7:	89 df                	mov    %ebx,%edi
80100fe9:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fef:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100ff6:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100ff8:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100fff:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80101003:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010100a:	ff ff ff 
  ustack[1] = argc;
8010100d:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101013:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80101015:	83 c0 0c             	add    $0xc,%eax
80101018:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010101a:	50                   	push   %eax
8010101b:	51                   	push   %ecx
8010101c:	56                   	push   %esi
8010101d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101023:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101029:	e8 82 78 00 00       	call   801088b0 <copyout>
8010102e:	83 c4 10             	add    $0x10,%esp
80101031:	85 c0                	test   %eax,%eax
80101033:	0f 88 e9 fe ff ff    	js     80100f22 <exec+0x2c2>
  for(last=s=path; *s; s++)
80101039:	8b 45 08             	mov    0x8(%ebp),%eax
8010103c:	8b 55 08             	mov    0x8(%ebp),%edx
8010103f:	0f b6 00             	movzbl (%eax),%eax
80101042:	84 c0                	test   %al,%al
80101044:	74 11                	je     80101057 <exec+0x3f7>
80101046:	89 d1                	mov    %edx,%ecx
80101048:	83 c1 01             	add    $0x1,%ecx
8010104b:	3c 2f                	cmp    $0x2f,%al
8010104d:	0f b6 01             	movzbl (%ecx),%eax
80101050:	0f 44 d1             	cmove  %ecx,%edx
80101053:	84 c0                	test   %al,%al
80101055:	75 f1                	jne    80101048 <exec+0x3e8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101057:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010105a:	83 ec 04             	sub    $0x4,%esp
8010105d:	6a 10                	push   $0x10
8010105f:	52                   	push   %edx
80101060:	50                   	push   %eax
80101061:	e8 8a 44 00 00       	call   801054f0 <safestrcpy>
80101066:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
8010106c:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80101072:	8d 93 48 02 00 00    	lea    0x248(%ebx),%edx
80101078:	83 c4 10             	add    $0x10,%esp
8010107b:	90                   	nop
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ramPages[ind].isused)
80101080:	8b b8 c4 01 00 00    	mov    0x1c4(%eax),%edi
80101086:	85 ff                	test   %edi,%edi
80101088:	74 06                	je     80101090 <exec+0x430>
      curproc->ramPages[ind].pgdir = pgdir;
8010108a:	89 88 c0 01 00 00    	mov    %ecx,0x1c0(%eax)
    if(curproc->swappedPages[ind].isused)
80101090:	8b 78 04             	mov    0x4(%eax),%edi
80101093:	85 ff                	test   %edi,%edi
80101095:	74 02                	je     80101099 <exec+0x439>
      curproc->swappedPages[ind].pgdir = pgdir;
80101097:	89 08                	mov    %ecx,(%eax)
80101099:	83 c0 1c             	add    $0x1c,%eax
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
8010109c:	39 d0                	cmp    %edx,%eax
8010109e:	75 e0                	jne    80101080 <exec+0x420>
  oldpgdir = curproc->pgdir;
801010a0:	8b 43 04             	mov    0x4(%ebx),%eax
  curproc->tf->eip = elf.entry;  // main
801010a3:	8b 53 18             	mov    0x18(%ebx),%edx
  switchuvm(curproc);
801010a6:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
801010a9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
801010af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801010b5:	89 43 04             	mov    %eax,0x4(%ebx)
  curproc->sz = sz;
801010b8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010be:	89 03                	mov    %eax,(%ebx)
  curproc->tf->eip = elf.entry;  // main
801010c0:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
801010c6:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
801010c9:	8b 53 18             	mov    0x18(%ebx),%edx
801010cc:	89 72 44             	mov    %esi,0x44(%edx)
  switchuvm(curproc);
801010cf:	53                   	push   %ebx
  return 0;
801010d0:	31 db                	xor    %ebx,%ebx
  switchuvm(curproc);
801010d2:	e8 e9 66 00 00       	call   801077c0 <switchuvm>
  freevm(oldpgdir);
801010d7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 fb 6e 00 00       	call   80107fe0 <freevm>
  return 0;
801010e5:	83 c4 10             	add    $0x10,%esp
801010e8:	e9 0f fc ff ff       	jmp    80100cfc <exec+0x9c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010ed:	31 ff                	xor    %edi,%edi
801010ef:	b8 00 20 00 00       	mov    $0x2000,%eax
801010f4:	e9 f2 fd ff ff       	jmp    80100eeb <exec+0x28b>
  for(argc = 0; argv[argc]; argc++) {
801010f9:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801010ff:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80101105:	e9 e5 fe ff ff       	jmp    80100fef <exec+0x38f>
8010110a:	66 90                	xchg   %ax,%ax
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101116:	68 db 8f 10 80       	push   $0x80108fdb
8010111b:	68 a0 33 11 80       	push   $0x801133a0
80101120:	e8 9b 3f 00 00       	call   801050c0 <initlock>
}
80101125:	83 c4 10             	add    $0x10,%esp
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101130 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101134:	bb d4 33 11 80       	mov    $0x801133d4,%ebx
{
80101139:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010113c:	68 a0 33 11 80       	push   $0x801133a0
80101141:	e8 ba 40 00 00       	call   80105200 <acquire>
80101146:	83 c4 10             	add    $0x10,%esp
80101149:	eb 10                	jmp    8010115b <filealloc+0x2b>
8010114b:	90                   	nop
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101150:	83 c3 18             	add    $0x18,%ebx
80101153:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
80101159:	73 25                	jae    80101180 <filealloc+0x50>
    if(f->ref == 0){
8010115b:	8b 43 04             	mov    0x4(%ebx),%eax
8010115e:	85 c0                	test   %eax,%eax
80101160:	75 ee                	jne    80101150 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101162:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101165:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010116c:	68 a0 33 11 80       	push   $0x801133a0
80101171:	e8 4a 41 00 00       	call   801052c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101176:	89 d8                	mov    %ebx,%eax
      return f;
80101178:	83 c4 10             	add    $0x10,%esp
}
8010117b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010117e:	c9                   	leave  
8010117f:	c3                   	ret    
  release(&ftable.lock);
80101180:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101183:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101185:	68 a0 33 11 80       	push   $0x801133a0
8010118a:	e8 31 41 00 00       	call   801052c0 <release>
}
8010118f:	89 d8                	mov    %ebx,%eax
  return 0;
80101191:	83 c4 10             	add    $0x10,%esp
}
80101194:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101197:	c9                   	leave  
80101198:	c3                   	ret    
80101199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011a0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011a0:	55                   	push   %ebp
801011a1:	89 e5                	mov    %esp,%ebp
801011a3:	53                   	push   %ebx
801011a4:	83 ec 10             	sub    $0x10,%esp
801011a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011aa:	68 a0 33 11 80       	push   $0x801133a0
801011af:	e8 4c 40 00 00       	call   80105200 <acquire>
  if(f->ref < 1)
801011b4:	8b 43 04             	mov    0x4(%ebx),%eax
801011b7:	83 c4 10             	add    $0x10,%esp
801011ba:	85 c0                	test   %eax,%eax
801011bc:	7e 1a                	jle    801011d8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011be:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011c1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801011c4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011c7:	68 a0 33 11 80       	push   $0x801133a0
801011cc:	e8 ef 40 00 00       	call   801052c0 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 e2 8f 10 80       	push   $0x80108fe2
801011e0:	e8 ab f1 ff ff       	call   80100390 <panic>
801011e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011f0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011f0:	55                   	push   %ebp
801011f1:	89 e5                	mov    %esp,%ebp
801011f3:	57                   	push   %edi
801011f4:	56                   	push   %esi
801011f5:	53                   	push   %ebx
801011f6:	83 ec 28             	sub    $0x28,%esp
801011f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801011fc:	68 a0 33 11 80       	push   $0x801133a0
80101201:	e8 fa 3f 00 00       	call   80105200 <acquire>
  if(f->ref < 1)
80101206:	8b 43 04             	mov    0x4(%ebx),%eax
80101209:	83 c4 10             	add    $0x10,%esp
8010120c:	85 c0                	test   %eax,%eax
8010120e:	0f 8e 9b 00 00 00    	jle    801012af <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101214:	83 e8 01             	sub    $0x1,%eax
80101217:	85 c0                	test   %eax,%eax
80101219:	89 43 04             	mov    %eax,0x4(%ebx)
8010121c:	74 1a                	je     80101238 <fileclose+0x48>
    release(&ftable.lock);
8010121e:	c7 45 08 a0 33 11 80 	movl   $0x801133a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101225:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101228:	5b                   	pop    %ebx
80101229:	5e                   	pop    %esi
8010122a:	5f                   	pop    %edi
8010122b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010122c:	e9 8f 40 00 00       	jmp    801052c0 <release>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101238:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010123c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010123e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101241:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101244:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010124a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010124d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101250:	68 a0 33 11 80       	push   $0x801133a0
  ff = *f;
80101255:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101258:	e8 63 40 00 00       	call   801052c0 <release>
  if(ff.type == FD_PIPE)
8010125d:	83 c4 10             	add    $0x10,%esp
80101260:	83 ff 01             	cmp    $0x1,%edi
80101263:	74 13                	je     80101278 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101265:	83 ff 02             	cmp    $0x2,%edi
80101268:	74 26                	je     80101290 <fileclose+0xa0>
}
8010126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010126d:	5b                   	pop    %ebx
8010126e:	5e                   	pop    %esi
8010126f:	5f                   	pop    %edi
80101270:	5d                   	pop    %ebp
80101271:	c3                   	ret    
80101272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101278:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010127c:	83 ec 08             	sub    $0x8,%esp
8010127f:	53                   	push   %ebx
80101280:	56                   	push   %esi
80101281:	e8 7a 2a 00 00       	call   80103d00 <pipeclose>
80101286:	83 c4 10             	add    $0x10,%esp
80101289:	eb df                	jmp    8010126a <fileclose+0x7a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101290:	e8 bb 22 00 00       	call   80103550 <begin_op>
    iput(ff.ip);
80101295:	83 ec 0c             	sub    $0xc,%esp
80101298:	ff 75 e0             	pushl  -0x20(%ebp)
8010129b:	e8 c0 08 00 00       	call   80101b60 <iput>
    end_op();
801012a0:	83 c4 10             	add    $0x10,%esp
}
801012a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012a6:	5b                   	pop    %ebx
801012a7:	5e                   	pop    %esi
801012a8:	5f                   	pop    %edi
801012a9:	5d                   	pop    %ebp
    end_op();
801012aa:	e9 11 23 00 00       	jmp    801035c0 <end_op>
    panic("fileclose");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 ea 8f 10 80       	push   $0x80108fea
801012b7:	e8 d4 f0 ff ff       	call   80100390 <panic>
801012bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012c0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012c0:	55                   	push   %ebp
801012c1:	89 e5                	mov    %esp,%ebp
801012c3:	53                   	push   %ebx
801012c4:	83 ec 04             	sub    $0x4,%esp
801012c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012ca:	83 3b 02             	cmpl   $0x2,(%ebx)
801012cd:	75 31                	jne    80101300 <filestat+0x40>
    ilock(f->ip);
801012cf:	83 ec 0c             	sub    $0xc,%esp
801012d2:	ff 73 10             	pushl  0x10(%ebx)
801012d5:	e8 56 07 00 00       	call   80101a30 <ilock>
    stati(f->ip, st);
801012da:	58                   	pop    %eax
801012db:	5a                   	pop    %edx
801012dc:	ff 75 0c             	pushl  0xc(%ebp)
801012df:	ff 73 10             	pushl  0x10(%ebx)
801012e2:	e8 f9 09 00 00       	call   80101ce0 <stati>
    iunlock(f->ip);
801012e7:	59                   	pop    %ecx
801012e8:	ff 73 10             	pushl  0x10(%ebx)
801012eb:	e8 20 08 00 00       	call   80101b10 <iunlock>
    return 0;
801012f0:	83 c4 10             	add    $0x10,%esp
801012f3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801012f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012f8:	c9                   	leave  
801012f9:	c3                   	ret    
801012fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101300:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101305:	eb ee                	jmp    801012f5 <filestat+0x35>
80101307:	89 f6                	mov    %esi,%esi
80101309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101310 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	56                   	push   %esi
80101315:	53                   	push   %ebx
80101316:	83 ec 0c             	sub    $0xc,%esp
80101319:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010131c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010131f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101322:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101326:	74 60                	je     80101388 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101328:	8b 03                	mov    (%ebx),%eax
8010132a:	83 f8 01             	cmp    $0x1,%eax
8010132d:	74 41                	je     80101370 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010132f:	83 f8 02             	cmp    $0x2,%eax
80101332:	75 5b                	jne    8010138f <fileread+0x7f>
    ilock(f->ip);
80101334:	83 ec 0c             	sub    $0xc,%esp
80101337:	ff 73 10             	pushl  0x10(%ebx)
8010133a:	e8 f1 06 00 00       	call   80101a30 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010133f:	57                   	push   %edi
80101340:	ff 73 14             	pushl  0x14(%ebx)
80101343:	56                   	push   %esi
80101344:	ff 73 10             	pushl  0x10(%ebx)
80101347:	e8 c4 09 00 00       	call   80101d10 <readi>
8010134c:	83 c4 20             	add    $0x20,%esp
8010134f:	85 c0                	test   %eax,%eax
80101351:	89 c6                	mov    %eax,%esi
80101353:	7e 03                	jle    80101358 <fileread+0x48>
      f->off += r;
80101355:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101358:	83 ec 0c             	sub    $0xc,%esp
8010135b:	ff 73 10             	pushl  0x10(%ebx)
8010135e:	e8 ad 07 00 00       	call   80101b10 <iunlock>
    return r;
80101363:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101366:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101369:	89 f0                	mov    %esi,%eax
8010136b:	5b                   	pop    %ebx
8010136c:	5e                   	pop    %esi
8010136d:	5f                   	pop    %edi
8010136e:	5d                   	pop    %ebp
8010136f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101370:	8b 43 0c             	mov    0xc(%ebx),%eax
80101373:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101379:	5b                   	pop    %ebx
8010137a:	5e                   	pop    %esi
8010137b:	5f                   	pop    %edi
8010137c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010137d:	e9 2e 2b 00 00       	jmp    80103eb0 <piperead>
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101388:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010138d:	eb d7                	jmp    80101366 <fileread+0x56>
  panic("fileread");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 f4 8f 10 80       	push   $0x80108ff4
80101397:	e8 f4 ef ff ff       	call   80100390 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	83 ec 1c             	sub    $0x1c,%esp
801013a9:	8b 75 08             	mov    0x8(%ebp),%esi
801013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801013af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801013b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013b6:	8b 45 10             	mov    0x10(%ebp),%eax
801013b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801013bc:	0f 84 aa 00 00 00    	je     8010146c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801013c2:	8b 06                	mov    (%esi),%eax
801013c4:	83 f8 01             	cmp    $0x1,%eax
801013c7:	0f 84 c3 00 00 00    	je     80101490 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013cd:	83 f8 02             	cmp    $0x2,%eax
801013d0:	0f 85 d9 00 00 00    	jne    801014af <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801013d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801013db:	85 c0                	test   %eax,%eax
801013dd:	7f 34                	jg     80101413 <filewrite+0x73>
801013df:	e9 9c 00 00 00       	jmp    80101480 <filewrite+0xe0>
801013e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801013eb:	83 ec 0c             	sub    $0xc,%esp
801013ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801013f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013f4:	e8 17 07 00 00       	call   80101b10 <iunlock>
      end_op();
801013f9:	e8 c2 21 00 00       	call   801035c0 <end_op>
801013fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101401:	83 c4 10             	add    $0x10,%esp
      if(r < 0)
        break;
      if(r != n1)
80101404:	39 c3                	cmp    %eax,%ebx
80101406:	0f 85 96 00 00 00    	jne    801014a2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010140c:	01 df                	add    %ebx,%edi
    while(i < n){
8010140e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101411:	7e 6d                	jle    80101480 <filewrite+0xe0>
      int n1 = n - i;
80101413:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101416:	b8 00 06 00 00       	mov    $0x600,%eax
8010141b:	29 fb                	sub    %edi,%ebx
8010141d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101423:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101426:	e8 25 21 00 00       	call   80103550 <begin_op>
      ilock(f->ip);
8010142b:	83 ec 0c             	sub    $0xc,%esp
8010142e:	ff 76 10             	pushl  0x10(%esi)
80101431:	e8 fa 05 00 00       	call   80101a30 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101436:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101439:	53                   	push   %ebx
8010143a:	ff 76 14             	pushl  0x14(%esi)
8010143d:	01 f8                	add    %edi,%eax
8010143f:	50                   	push   %eax
80101440:	ff 76 10             	pushl  0x10(%esi)
80101443:	e8 c8 09 00 00       	call   80101e10 <writei>
80101448:	83 c4 20             	add    $0x20,%esp
8010144b:	85 c0                	test   %eax,%eax
8010144d:	7f 99                	jg     801013e8 <filewrite+0x48>
      iunlock(f->ip);
8010144f:	83 ec 0c             	sub    $0xc,%esp
80101452:	ff 76 10             	pushl  0x10(%esi)
80101455:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101458:	e8 b3 06 00 00       	call   80101b10 <iunlock>
      end_op();
8010145d:	e8 5e 21 00 00       	call   801035c0 <end_op>
      if(r < 0)
80101462:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101465:	83 c4 10             	add    $0x10,%esp
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 98                	je     80101404 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010146f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101474:	89 f8                	mov    %edi,%eax
80101476:	5b                   	pop    %ebx
80101477:	5e                   	pop    %esi
80101478:	5f                   	pop    %edi
80101479:	5d                   	pop    %ebp
8010147a:	c3                   	ret    
8010147b:	90                   	nop
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101480:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101483:	75 e7                	jne    8010146c <filewrite+0xcc>
}
80101485:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101488:	89 f8                	mov    %edi,%eax
8010148a:	5b                   	pop    %ebx
8010148b:	5e                   	pop    %esi
8010148c:	5f                   	pop    %edi
8010148d:	5d                   	pop    %ebp
8010148e:	c3                   	ret    
8010148f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101490:	8b 46 0c             	mov    0xc(%esi),%eax
80101493:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101499:	5b                   	pop    %ebx
8010149a:	5e                   	pop    %esi
8010149b:	5f                   	pop    %edi
8010149c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010149d:	e9 fe 28 00 00       	jmp    80103da0 <pipewrite>
        panic("short filewrite");
801014a2:	83 ec 0c             	sub    $0xc,%esp
801014a5:	68 fd 8f 10 80       	push   $0x80108ffd
801014aa:	e8 e1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 03 90 10 80       	push   $0x80109003
801014b7:	e8 d4 ee ff ff       	call   80100390 <panic>
801014bc:	66 90                	xchg   %ax,%ax
801014be:	66 90                	xchg   %ax,%ax

801014c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014c7:	c1 ea 0c             	shr    $0xc,%edx
801014ca:	03 15 b8 3d 11 80    	add    0x80113db8,%edx
801014d0:	83 ec 08             	sub    $0x8,%esp
801014d3:	52                   	push   %edx
801014d4:	50                   	push   %eax
801014d5:	e8 f6 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014da:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014dc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014df:	ba 01 00 00 00       	mov    $0x1,%edx
801014e4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014e7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014ed:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014f0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014f2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014f7:	85 d1                	test   %edx,%ecx
801014f9:	74 25                	je     80101520 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014fb:	f7 d2                	not    %edx
801014fd:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014ff:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101502:	21 ca                	and    %ecx,%edx
80101504:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101508:	56                   	push   %esi
80101509:	e8 12 22 00 00       	call   80103720 <log_write>
  brelse(bp);
8010150e:	89 34 24             	mov    %esi,(%esp)
80101511:	e8 ca ec ff ff       	call   801001e0 <brelse>
}
80101516:	83 c4 10             	add    $0x10,%esp
80101519:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010151c:	5b                   	pop    %ebx
8010151d:	5e                   	pop    %esi
8010151e:	5d                   	pop    %ebp
8010151f:	c3                   	ret    
    panic("freeing free block");
80101520:	83 ec 0c             	sub    $0xc,%esp
80101523:	68 0d 90 10 80       	push   $0x8010900d
80101528:	e8 63 ee ff ff       	call   80100390 <panic>
8010152d:	8d 76 00             	lea    0x0(%esi),%esi

80101530 <balloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101539:	8b 0d a0 3d 11 80    	mov    0x80113da0,%ecx
{
8010153f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101542:	85 c9                	test   %ecx,%ecx
80101544:	0f 84 87 00 00 00    	je     801015d1 <balloc+0xa1>
8010154a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101551:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101554:	83 ec 08             	sub    $0x8,%esp
80101557:	89 f0                	mov    %esi,%eax
80101559:	c1 f8 0c             	sar    $0xc,%eax
8010155c:	03 05 b8 3d 11 80    	add    0x80113db8,%eax
80101562:	50                   	push   %eax
80101563:	ff 75 d8             	pushl  -0x28(%ebp)
80101566:	e8 65 eb ff ff       	call   801000d0 <bread>
8010156b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010156e:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80101573:	83 c4 10             	add    $0x10,%esp
80101576:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101579:	31 c0                	xor    %eax,%eax
8010157b:	eb 2f                	jmp    801015ac <balloc+0x7c>
8010157d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101580:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101582:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101585:	bb 01 00 00 00       	mov    $0x1,%ebx
8010158a:	83 e1 07             	and    $0x7,%ecx
8010158d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010158f:	89 c1                	mov    %eax,%ecx
80101591:	c1 f9 03             	sar    $0x3,%ecx
80101594:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101599:	85 df                	test   %ebx,%edi
8010159b:	89 fa                	mov    %edi,%edx
8010159d:	74 41                	je     801015e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010159f:	83 c0 01             	add    $0x1,%eax
801015a2:	83 c6 01             	add    $0x1,%esi
801015a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015aa:	74 05                	je     801015b1 <balloc+0x81>
801015ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801015af:	77 cf                	ja     80101580 <balloc+0x50>
    brelse(bp);
801015b1:	83 ec 0c             	sub    $0xc,%esp
801015b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801015b7:	e8 24 ec ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801015bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015c3:	83 c4 10             	add    $0x10,%esp
801015c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015c9:	39 05 a0 3d 11 80    	cmp    %eax,0x80113da0
801015cf:	77 80                	ja     80101551 <balloc+0x21>
  panic("balloc: out of blocks");
801015d1:	83 ec 0c             	sub    $0xc,%esp
801015d4:	68 20 90 10 80       	push   $0x80109020
801015d9:	e8 b2 ed ff ff       	call   80100390 <panic>
801015de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801015e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801015e6:	09 da                	or     %ebx,%edx
801015e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015ec:	57                   	push   %edi
801015ed:	e8 2e 21 00 00       	call   80103720 <log_write>
        brelse(bp);
801015f2:	89 3c 24             	mov    %edi,(%esp)
801015f5:	e8 e6 eb ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801015fa:	58                   	pop    %eax
801015fb:	5a                   	pop    %edx
801015fc:	56                   	push   %esi
801015fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101600:	e8 cb ea ff ff       	call   801000d0 <bread>
80101605:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101607:	8d 40 5c             	lea    0x5c(%eax),%eax
8010160a:	83 c4 0c             	add    $0xc,%esp
8010160d:	68 00 02 00 00       	push   $0x200
80101612:	6a 00                	push   $0x0
80101614:	50                   	push   %eax
80101615:	e8 f6 3c 00 00       	call   80105310 <memset>
  log_write(bp);
8010161a:	89 1c 24             	mov    %ebx,(%esp)
8010161d:	e8 fe 20 00 00       	call   80103720 <log_write>
  brelse(bp);
80101622:	89 1c 24             	mov    %ebx,(%esp)
80101625:	e8 b6 eb ff ff       	call   801001e0 <brelse>
}
8010162a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010162d:	89 f0                	mov    %esi,%eax
8010162f:	5b                   	pop    %ebx
80101630:	5e                   	pop    %esi
80101631:	5f                   	pop    %edi
80101632:	5d                   	pop    %ebp
80101633:	c3                   	ret    
80101634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010163a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101640 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	57                   	push   %edi
80101644:	56                   	push   %esi
80101645:	53                   	push   %ebx
80101646:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101648:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010164a:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
8010164f:	83 ec 28             	sub    $0x28,%esp
80101652:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101655:	68 c0 3d 11 80       	push   $0x80113dc0
8010165a:	e8 a1 3b 00 00       	call   80105200 <acquire>
8010165f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101662:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101665:	eb 17                	jmp    8010167e <iget+0x3e>
80101667:	89 f6                	mov    %esi,%esi
80101669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101670:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101676:	81 fb 14 5a 11 80    	cmp    $0x80115a14,%ebx
8010167c:	73 22                	jae    801016a0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010167e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101681:	85 c9                	test   %ecx,%ecx
80101683:	7e 04                	jle    80101689 <iget+0x49>
80101685:	39 3b                	cmp    %edi,(%ebx)
80101687:	74 4f                	je     801016d8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101689:	85 f6                	test   %esi,%esi
8010168b:	75 e3                	jne    80101670 <iget+0x30>
8010168d:	85 c9                	test   %ecx,%ecx
8010168f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101692:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101698:	81 fb 14 5a 11 80    	cmp    $0x80115a14,%ebx
8010169e:	72 de                	jb     8010167e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801016a0:	85 f6                	test   %esi,%esi
801016a2:	74 5b                	je     801016ff <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801016a4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801016a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801016a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801016ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016ba:	68 c0 3d 11 80       	push   $0x80113dc0
801016bf:	e8 fc 3b 00 00       	call   801052c0 <release>

  return ip;
801016c4:	83 c4 10             	add    $0x10,%esp
}
801016c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ca:	89 f0                	mov    %esi,%eax
801016cc:	5b                   	pop    %ebx
801016cd:	5e                   	pop    %esi
801016ce:	5f                   	pop    %edi
801016cf:	5d                   	pop    %ebp
801016d0:	c3                   	ret    
801016d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016d8:	39 53 04             	cmp    %edx,0x4(%ebx)
801016db:	75 ac                	jne    80101689 <iget+0x49>
      release(&icache.lock);
801016dd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801016e0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801016e3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801016e5:	68 c0 3d 11 80       	push   $0x80113dc0
      ip->ref++;
801016ea:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801016ed:	e8 ce 3b 00 00       	call   801052c0 <release>
      return ip;
801016f2:	83 c4 10             	add    $0x10,%esp
}
801016f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016f8:	89 f0                	mov    %esi,%eax
801016fa:	5b                   	pop    %ebx
801016fb:	5e                   	pop    %esi
801016fc:	5f                   	pop    %edi
801016fd:	5d                   	pop    %ebp
801016fe:	c3                   	ret    
    panic("iget: no inodes");
801016ff:	83 ec 0c             	sub    $0xc,%esp
80101702:	68 36 90 10 80       	push   $0x80109036
80101707:	e8 84 ec ff ff       	call   80100390 <panic>
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101710 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	57                   	push   %edi
80101714:	56                   	push   %esi
80101715:	53                   	push   %ebx
80101716:	89 c6                	mov    %eax,%esi
80101718:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010171b:	83 fa 0b             	cmp    $0xb,%edx
8010171e:	77 18                	ja     80101738 <bmap+0x28>
80101720:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101723:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101726:	85 db                	test   %ebx,%ebx
80101728:	74 76                	je     801017a0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010172a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010172d:	89 d8                	mov    %ebx,%eax
8010172f:	5b                   	pop    %ebx
80101730:	5e                   	pop    %esi
80101731:	5f                   	pop    %edi
80101732:	5d                   	pop    %ebp
80101733:	c3                   	ret    
80101734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101738:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010173b:	83 fb 7f             	cmp    $0x7f,%ebx
8010173e:	0f 87 90 00 00 00    	ja     801017d4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101744:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010174a:	8b 00                	mov    (%eax),%eax
8010174c:	85 d2                	test   %edx,%edx
8010174e:	74 70                	je     801017c0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101750:	83 ec 08             	sub    $0x8,%esp
80101753:	52                   	push   %edx
80101754:	50                   	push   %eax
80101755:	e8 76 e9 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010175a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010175e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101761:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101763:	8b 1a                	mov    (%edx),%ebx
80101765:	85 db                	test   %ebx,%ebx
80101767:	75 1d                	jne    80101786 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101769:	8b 06                	mov    (%esi),%eax
8010176b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010176e:	e8 bd fd ff ff       	call   80101530 <balloc>
80101773:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101776:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101779:	89 c3                	mov    %eax,%ebx
8010177b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010177d:	57                   	push   %edi
8010177e:	e8 9d 1f 00 00       	call   80103720 <log_write>
80101783:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101786:	83 ec 0c             	sub    $0xc,%esp
80101789:	57                   	push   %edi
8010178a:	e8 51 ea ff ff       	call   801001e0 <brelse>
8010178f:	83 c4 10             	add    $0x10,%esp
}
80101792:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101795:	89 d8                	mov    %ebx,%eax
80101797:	5b                   	pop    %ebx
80101798:	5e                   	pop    %esi
80101799:	5f                   	pop    %edi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801017a0:	8b 00                	mov    (%eax),%eax
801017a2:	e8 89 fd ff ff       	call   80101530 <balloc>
801017a7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801017aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801017ad:	89 c3                	mov    %eax,%ebx
}
801017af:	89 d8                	mov    %ebx,%eax
801017b1:	5b                   	pop    %ebx
801017b2:	5e                   	pop    %esi
801017b3:	5f                   	pop    %edi
801017b4:	5d                   	pop    %ebp
801017b5:	c3                   	ret    
801017b6:	8d 76 00             	lea    0x0(%esi),%esi
801017b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017c0:	e8 6b fd ff ff       	call   80101530 <balloc>
801017c5:	89 c2                	mov    %eax,%edx
801017c7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017cd:	8b 06                	mov    (%esi),%eax
801017cf:	e9 7c ff ff ff       	jmp    80101750 <bmap+0x40>
  panic("bmap: out of range");
801017d4:	83 ec 0c             	sub    $0xc,%esp
801017d7:	68 46 90 10 80       	push   $0x80109046
801017dc:	e8 af eb ff ff       	call   80100390 <panic>
801017e1:	eb 0d                	jmp    801017f0 <readsb>
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

801017f0 <readsb>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801017f8:	83 ec 08             	sub    $0x8,%esp
801017fb:	6a 01                	push   $0x1
801017fd:	ff 75 08             	pushl  0x8(%ebp)
80101800:	e8 cb e8 ff ff       	call   801000d0 <bread>
80101805:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101807:	8d 40 5c             	lea    0x5c(%eax),%eax
8010180a:	83 c4 0c             	add    $0xc,%esp
8010180d:	6a 1c                	push   $0x1c
8010180f:	50                   	push   %eax
80101810:	56                   	push   %esi
80101811:	e8 aa 3b 00 00       	call   801053c0 <memmove>
  brelse(bp);
80101816:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101819:	83 c4 10             	add    $0x10,%esp
}
8010181c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181f:	5b                   	pop    %ebx
80101820:	5e                   	pop    %esi
80101821:	5d                   	pop    %ebp
  brelse(bp);
80101822:	e9 b9 e9 ff ff       	jmp    801001e0 <brelse>
80101827:	89 f6                	mov    %esi,%esi
80101829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101830 <iinit>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	53                   	push   %ebx
80101834:	bb 00 3e 11 80       	mov    $0x80113e00,%ebx
80101839:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010183c:	68 59 90 10 80       	push   $0x80109059
80101841:	68 c0 3d 11 80       	push   $0x80113dc0
80101846:	e8 75 38 00 00       	call   801050c0 <initlock>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	68 60 90 10 80       	push   $0x80109060
80101858:	53                   	push   %ebx
80101859:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010185f:	e8 2c 37 00 00       	call   80104f90 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101864:	83 c4 10             	add    $0x10,%esp
80101867:	81 fb 20 5a 11 80    	cmp    $0x80115a20,%ebx
8010186d:	75 e1                	jne    80101850 <iinit+0x20>
  readsb(dev, &sb);
8010186f:	83 ec 08             	sub    $0x8,%esp
80101872:	68 a0 3d 11 80       	push   $0x80113da0
80101877:	ff 75 08             	pushl  0x8(%ebp)
8010187a:	e8 71 ff ff ff       	call   801017f0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010187f:	ff 35 b8 3d 11 80    	pushl  0x80113db8
80101885:	ff 35 b4 3d 11 80    	pushl  0x80113db4
8010188b:	ff 35 b0 3d 11 80    	pushl  0x80113db0
80101891:	ff 35 ac 3d 11 80    	pushl  0x80113dac
80101897:	ff 35 a8 3d 11 80    	pushl  0x80113da8
8010189d:	ff 35 a4 3d 11 80    	pushl  0x80113da4
801018a3:	ff 35 a0 3d 11 80    	pushl  0x80113da0
801018a9:	68 0c 91 10 80       	push   $0x8010910c
801018ae:	e8 ad ed ff ff       	call   80100660 <cprintf>
}
801018b3:	83 c4 30             	add    $0x30,%esp
801018b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018b9:	c9                   	leave  
801018ba:	c3                   	ret    
801018bb:	90                   	nop
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <ialloc>:
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	57                   	push   %edi
801018c4:	56                   	push   %esi
801018c5:	53                   	push   %ebx
801018c6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018c9:	83 3d a8 3d 11 80 01 	cmpl   $0x1,0x80113da8
{
801018d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801018d3:	8b 75 08             	mov    0x8(%ebp),%esi
801018d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801018d9:	0f 86 91 00 00 00    	jbe    80101970 <ialloc+0xb0>
801018df:	bb 01 00 00 00       	mov    $0x1,%ebx
801018e4:	eb 21                	jmp    80101907 <ialloc+0x47>
801018e6:	8d 76 00             	lea    0x0(%esi),%esi
801018e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801018f0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018f3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801018f6:	57                   	push   %edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801018fc:	83 c4 10             	add    $0x10,%esp
801018ff:	39 1d a8 3d 11 80    	cmp    %ebx,0x80113da8
80101905:	76 69                	jbe    80101970 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101907:	89 d8                	mov    %ebx,%eax
80101909:	83 ec 08             	sub    $0x8,%esp
8010190c:	c1 e8 03             	shr    $0x3,%eax
8010190f:	03 05 b4 3d 11 80    	add    0x80113db4,%eax
80101915:	50                   	push   %eax
80101916:	56                   	push   %esi
80101917:	e8 b4 e7 ff ff       	call   801000d0 <bread>
8010191c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010191e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101920:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101923:	83 e0 07             	and    $0x7,%eax
80101926:	c1 e0 06             	shl    $0x6,%eax
80101929:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010192d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101931:	75 bd                	jne    801018f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101933:	83 ec 04             	sub    $0x4,%esp
80101936:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101939:	6a 40                	push   $0x40
8010193b:	6a 00                	push   $0x0
8010193d:	51                   	push   %ecx
8010193e:	e8 cd 39 00 00       	call   80105310 <memset>
      dip->type = type;
80101943:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101947:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010194a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010194d:	89 3c 24             	mov    %edi,(%esp)
80101950:	e8 cb 1d 00 00       	call   80103720 <log_write>
      brelse(bp);
80101955:	89 3c 24             	mov    %edi,(%esp)
80101958:	e8 83 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010195d:	83 c4 10             	add    $0x10,%esp
}
80101960:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101963:	89 da                	mov    %ebx,%edx
80101965:	89 f0                	mov    %esi,%eax
}
80101967:	5b                   	pop    %ebx
80101968:	5e                   	pop    %esi
80101969:	5f                   	pop    %edi
8010196a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010196b:	e9 d0 fc ff ff       	jmp    80101640 <iget>
  panic("ialloc: no inodes");
80101970:	83 ec 0c             	sub    $0xc,%esp
80101973:	68 66 90 10 80       	push   $0x80109066
80101978:	e8 13 ea ff ff       	call   80100390 <panic>
8010197d:	8d 76 00             	lea    0x0(%esi),%esi

80101980 <iupdate>:
{
80101980:	55                   	push   %ebp
80101981:	89 e5                	mov    %esp,%ebp
80101983:	56                   	push   %esi
80101984:	53                   	push   %ebx
80101985:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010198e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101991:	c1 e8 03             	shr    $0x3,%eax
80101994:	03 05 b4 3d 11 80    	add    0x80113db4,%eax
8010199a:	50                   	push   %eax
8010199b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019a5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801019a8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ac:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019af:	83 e0 07             	and    $0x7,%eax
801019b2:	c1 e0 06             	shl    $0x6,%eax
801019b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019c0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801019c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019dd:	6a 34                	push   $0x34
801019df:	53                   	push   %ebx
801019e0:	50                   	push   %eax
801019e1:	e8 da 39 00 00       	call   801053c0 <memmove>
  log_write(bp);
801019e6:	89 34 24             	mov    %esi,(%esp)
801019e9:	e8 32 1d 00 00       	call   80103720 <log_write>
  brelse(bp);
801019ee:	89 75 08             	mov    %esi,0x8(%ebp)
801019f1:	83 c4 10             	add    $0x10,%esp
}
801019f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019f7:	5b                   	pop    %ebx
801019f8:	5e                   	pop    %esi
801019f9:	5d                   	pop    %ebp
  brelse(bp);
801019fa:	e9 e1 e7 ff ff       	jmp    801001e0 <brelse>
801019ff:	90                   	nop

80101a00 <idup>:
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	53                   	push   %ebx
80101a04:	83 ec 10             	sub    $0x10,%esp
80101a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a0a:	68 c0 3d 11 80       	push   $0x80113dc0
80101a0f:	e8 ec 37 00 00       	call   80105200 <acquire>
  ip->ref++;
80101a14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a18:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a1f:	e8 9c 38 00 00       	call   801052c0 <release>
}
80101a24:	89 d8                	mov    %ebx,%eax
80101a26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a29:	c9                   	leave  
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <ilock>:
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	56                   	push   %esi
80101a34:	53                   	push   %ebx
80101a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101a38:	85 db                	test   %ebx,%ebx
80101a3a:	0f 84 b7 00 00 00    	je     80101af7 <ilock+0xc7>
80101a40:	8b 53 08             	mov    0x8(%ebx),%edx
80101a43:	85 d2                	test   %edx,%edx
80101a45:	0f 8e ac 00 00 00    	jle    80101af7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a4b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a4e:	83 ec 0c             	sub    $0xc,%esp
80101a51:	50                   	push   %eax
80101a52:	e8 79 35 00 00       	call   80104fd0 <acquiresleep>
  if(ip->valid == 0){
80101a57:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a5a:	83 c4 10             	add    $0x10,%esp
80101a5d:	85 c0                	test   %eax,%eax
80101a5f:	74 0f                	je     80101a70 <ilock+0x40>
}
80101a61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a64:	5b                   	pop    %ebx
80101a65:	5e                   	pop    %esi
80101a66:	5d                   	pop    %ebp
80101a67:	c3                   	ret    
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a70:	8b 43 04             	mov    0x4(%ebx),%eax
80101a73:	83 ec 08             	sub    $0x8,%esp
80101a76:	c1 e8 03             	shr    $0x3,%eax
80101a79:	03 05 b4 3d 11 80    	add    0x80113db4,%eax
80101a7f:	50                   	push   %eax
80101a80:	ff 33                	pushl  (%ebx)
80101a82:	e8 49 e6 ff ff       	call   801000d0 <bread>
80101a87:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a89:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a8c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a8f:	83 e0 07             	and    $0x7,%eax
80101a92:	c1 e0 06             	shl    $0x6,%eax
80101a95:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a99:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a9c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a9f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101aa3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101aa7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101aab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101aaf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ab3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ab7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101abb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101abe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ac1:	6a 34                	push   $0x34
80101ac3:	50                   	push   %eax
80101ac4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ac7:	50                   	push   %eax
80101ac8:	e8 f3 38 00 00       	call   801053c0 <memmove>
    brelse(bp);
80101acd:	89 34 24             	mov    %esi,(%esp)
80101ad0:	e8 0b e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101ad5:	83 c4 10             	add    $0x10,%esp
80101ad8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101add:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ae4:	0f 85 77 ff ff ff    	jne    80101a61 <ilock+0x31>
      panic("ilock: no type");
80101aea:	83 ec 0c             	sub    $0xc,%esp
80101aed:	68 7e 90 10 80       	push   $0x8010907e
80101af2:	e8 99 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 78 90 10 80       	push   $0x80109078
80101aff:	e8 8c e8 ff ff       	call   80100390 <panic>
80101b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b10 <iunlock>:
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	56                   	push   %esi
80101b14:	53                   	push   %ebx
80101b15:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b18:	85 db                	test   %ebx,%ebx
80101b1a:	74 28                	je     80101b44 <iunlock+0x34>
80101b1c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b1f:	83 ec 0c             	sub    $0xc,%esp
80101b22:	56                   	push   %esi
80101b23:	e8 48 35 00 00       	call   80105070 <holdingsleep>
80101b28:	83 c4 10             	add    $0x10,%esp
80101b2b:	85 c0                	test   %eax,%eax
80101b2d:	74 15                	je     80101b44 <iunlock+0x34>
80101b2f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b32:	85 c0                	test   %eax,%eax
80101b34:	7e 0e                	jle    80101b44 <iunlock+0x34>
  releasesleep(&ip->lock);
80101b36:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b3c:	5b                   	pop    %ebx
80101b3d:	5e                   	pop    %esi
80101b3e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101b3f:	e9 ec 34 00 00       	jmp    80105030 <releasesleep>
    panic("iunlock");
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 8d 90 10 80       	push   $0x8010908d
80101b4c:	e8 3f e8 ff ff       	call   80100390 <panic>
80101b51:	eb 0d                	jmp    80101b60 <iput>
80101b53:	90                   	nop
80101b54:	90                   	nop
80101b55:	90                   	nop
80101b56:	90                   	nop
80101b57:	90                   	nop
80101b58:	90                   	nop
80101b59:	90                   	nop
80101b5a:	90                   	nop
80101b5b:	90                   	nop
80101b5c:	90                   	nop
80101b5d:	90                   	nop
80101b5e:	90                   	nop
80101b5f:	90                   	nop

80101b60 <iput>:
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	57                   	push   %edi
80101b64:	56                   	push   %esi
80101b65:	53                   	push   %ebx
80101b66:	83 ec 28             	sub    $0x28,%esp
80101b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b6c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b6f:	57                   	push   %edi
80101b70:	e8 5b 34 00 00       	call   80104fd0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b75:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b78:	83 c4 10             	add    $0x10,%esp
80101b7b:	85 d2                	test   %edx,%edx
80101b7d:	74 07                	je     80101b86 <iput+0x26>
80101b7f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b84:	74 32                	je     80101bb8 <iput+0x58>
  releasesleep(&ip->lock);
80101b86:	83 ec 0c             	sub    $0xc,%esp
80101b89:	57                   	push   %edi
80101b8a:	e8 a1 34 00 00       	call   80105030 <releasesleep>
  acquire(&icache.lock);
80101b8f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101b96:	e8 65 36 00 00       	call   80105200 <acquire>
  ip->ref--;
80101b9b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b9f:	83 c4 10             	add    $0x10,%esp
80101ba2:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
80101ba9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bac:	5b                   	pop    %ebx
80101bad:	5e                   	pop    %esi
80101bae:	5f                   	pop    %edi
80101baf:	5d                   	pop    %ebp
  release(&icache.lock);
80101bb0:	e9 0b 37 00 00       	jmp    801052c0 <release>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bc0:	e8 3b 36 00 00       	call   80105200 <acquire>
    int r = ip->ref;
80101bc5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bc8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bcf:	e8 ec 36 00 00       	call   801052c0 <release>
    if(r == 1){
80101bd4:	83 c4 10             	add    $0x10,%esp
80101bd7:	83 fe 01             	cmp    $0x1,%esi
80101bda:	75 aa                	jne    80101b86 <iput+0x26>
80101bdc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101be2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101be5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101be8:	89 cf                	mov    %ecx,%edi
80101bea:	eb 0b                	jmp    80101bf7 <iput+0x97>
80101bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bf0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101bf3:	39 fe                	cmp    %edi,%esi
80101bf5:	74 19                	je     80101c10 <iput+0xb0>
    if(ip->addrs[i]){
80101bf7:	8b 16                	mov    (%esi),%edx
80101bf9:	85 d2                	test   %edx,%edx
80101bfb:	74 f3                	je     80101bf0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101bfd:	8b 03                	mov    (%ebx),%eax
80101bff:	e8 bc f8 ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101c04:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c0a:	eb e4                	jmp    80101bf0 <iput+0x90>
80101c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c10:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c19:	85 c0                	test   %eax,%eax
80101c1b:	75 33                	jne    80101c50 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c1d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101c20:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101c27:	53                   	push   %ebx
80101c28:	e8 53 fd ff ff       	call   80101980 <iupdate>
      ip->type = 0;
80101c2d:	31 c0                	xor    %eax,%eax
80101c2f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101c33:	89 1c 24             	mov    %ebx,(%esp)
80101c36:	e8 45 fd ff ff       	call   80101980 <iupdate>
      ip->valid = 0;
80101c3b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c42:	83 c4 10             	add    $0x10,%esp
80101c45:	e9 3c ff ff ff       	jmp    80101b86 <iput+0x26>
80101c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c50:	83 ec 08             	sub    $0x8,%esp
80101c53:	50                   	push   %eax
80101c54:	ff 33                	pushl  (%ebx)
80101c56:	e8 75 e4 ff ff       	call   801000d0 <bread>
80101c5b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c61:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c67:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c6a:	83 c4 10             	add    $0x10,%esp
80101c6d:	89 cf                	mov    %ecx,%edi
80101c6f:	eb 0e                	jmp    80101c7f <iput+0x11f>
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c78:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101c7b:	39 fe                	cmp    %edi,%esi
80101c7d:	74 0f                	je     80101c8e <iput+0x12e>
      if(a[j])
80101c7f:	8b 16                	mov    (%esi),%edx
80101c81:	85 d2                	test   %edx,%edx
80101c83:	74 f3                	je     80101c78 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c85:	8b 03                	mov    (%ebx),%eax
80101c87:	e8 34 f8 ff ff       	call   801014c0 <bfree>
80101c8c:	eb ea                	jmp    80101c78 <iput+0x118>
    brelse(bp);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
80101c91:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c94:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c97:	e8 44 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c9c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101ca2:	8b 03                	mov    (%ebx),%eax
80101ca4:	e8 17 f8 ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101ca9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101cb0:	00 00 00 
80101cb3:	83 c4 10             	add    $0x10,%esp
80101cb6:	e9 62 ff ff ff       	jmp    80101c1d <iput+0xbd>
80101cbb:	90                   	nop
80101cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <iunlockput>:
{
80101cc0:	55                   	push   %ebp
80101cc1:	89 e5                	mov    %esp,%ebp
80101cc3:	53                   	push   %ebx
80101cc4:	83 ec 10             	sub    $0x10,%esp
80101cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101cca:	53                   	push   %ebx
80101ccb:	e8 40 fe ff ff       	call   80101b10 <iunlock>
  iput(ip);
80101cd0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101cd3:	83 c4 10             	add    $0x10,%esp
}
80101cd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cd9:	c9                   	leave  
  iput(ip);
80101cda:	e9 81 fe ff ff       	jmp    80101b60 <iput>
80101cdf:	90                   	nop

80101ce0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ce0:	55                   	push   %ebp
80101ce1:	89 e5                	mov    %esp,%ebp
80101ce3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ce9:	8b 0a                	mov    (%edx),%ecx
80101ceb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cee:	8b 4a 04             	mov    0x4(%edx),%ecx
80101cf1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101cf4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101cf8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101cfb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d03:	8b 52 58             	mov    0x58(%edx),%edx
80101d06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d09:	5d                   	pop    %ebp
80101d0a:	c3                   	ret    
80101d0b:	90                   	nop
80101d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	83 ec 1c             	sub    $0x1c,%esp
80101d19:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d27:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101d2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101d33:	0f 84 a7 00 00 00    	je     80101de0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d3c:	8b 40 58             	mov    0x58(%eax),%eax
80101d3f:	39 c6                	cmp    %eax,%esi
80101d41:	0f 87 ba 00 00 00    	ja     80101e01 <readi+0xf1>
80101d47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d4a:	89 f9                	mov    %edi,%ecx
80101d4c:	01 f1                	add    %esi,%ecx
80101d4e:	0f 82 ad 00 00 00    	jb     80101e01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d54:	89 c2                	mov    %eax,%edx
80101d56:	29 f2                	sub    %esi,%edx
80101d58:	39 c8                	cmp    %ecx,%eax
80101d5a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d5d:	31 ff                	xor    %edi,%edi
80101d5f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101d61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d64:	74 6c                	je     80101dd2 <readi+0xc2>
80101d66:	8d 76 00             	lea    0x0(%esi),%esi
80101d69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d73:	89 f2                	mov    %esi,%edx
80101d75:	c1 ea 09             	shr    $0x9,%edx
80101d78:	89 d8                	mov    %ebx,%eax
80101d7a:	e8 91 f9 ff ff       	call   80101710 <bmap>
80101d7f:	83 ec 08             	sub    $0x8,%esp
80101d82:	50                   	push   %eax
80101d83:	ff 33                	pushl  (%ebx)
80101d85:	e8 46 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d8d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d8f:	89 f0                	mov    %esi,%eax
80101d91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d96:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d9b:	83 c4 0c             	add    $0xc,%esp
80101d9e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101da0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101da4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101da7:	29 fb                	sub    %edi,%ebx
80101da9:	39 d9                	cmp    %ebx,%ecx
80101dab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101dae:	53                   	push   %ebx
80101daf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101db0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101db2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101db5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101db7:	e8 04 36 00 00       	call   801053c0 <memmove>
    brelse(bp);
80101dbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dbf:	89 14 24             	mov    %edx,(%esp)
80101dc2:	e8 19 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dca:	83 c4 10             	add    $0x10,%esp
80101dcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101dd0:	77 9e                	ja     80101d70 <readi+0x60>
  }
  return n;
80101dd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dd8:	5b                   	pop    %ebx
80101dd9:	5e                   	pop    %esi
80101dda:	5f                   	pop    %edi
80101ddb:	5d                   	pop    %ebp
80101ddc:	c3                   	ret    
80101ddd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101de0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101de4:	66 83 f8 09          	cmp    $0x9,%ax
80101de8:	77 17                	ja     80101e01 <readi+0xf1>
80101dea:	8b 04 c5 40 3d 11 80 	mov    -0x7feec2c0(,%eax,8),%eax
80101df1:	85 c0                	test   %eax,%eax
80101df3:	74 0c                	je     80101e01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101df5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101df8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101dff:	ff e0                	jmp    *%eax
      return -1;
80101e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e06:	eb cd                	jmp    80101dd5 <readi+0xc5>
80101e08:	90                   	nop
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	83 ec 1c             	sub    $0x1c,%esp
80101e19:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101e33:	0f 84 b7 00 00 00    	je     80101ef0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e3f:	0f 82 eb 00 00 00    	jb     80101f30 <writei+0x120>
80101e45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e48:	31 d2                	xor    %edx,%edx
80101e4a:	89 f8                	mov    %edi,%eax
80101e4c:	01 f0                	add    %esi,%eax
80101e4e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e51:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e56:	0f 87 d4 00 00 00    	ja     80101f30 <writei+0x120>
80101e5c:	85 d2                	test   %edx,%edx
80101e5e:	0f 85 cc 00 00 00    	jne    80101f30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e64:	85 ff                	test   %edi,%edi
80101e66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e6d:	74 72                	je     80101ee1 <writei+0xd1>
80101e6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e73:	89 f2                	mov    %esi,%edx
80101e75:	c1 ea 09             	shr    $0x9,%edx
80101e78:	89 f8                	mov    %edi,%eax
80101e7a:	e8 91 f8 ff ff       	call   80101710 <bmap>
80101e7f:	83 ec 08             	sub    $0x8,%esp
80101e82:	50                   	push   %eax
80101e83:	ff 37                	pushl  (%edi)
80101e85:	e8 46 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e8a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e8d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e90:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e92:	89 f0                	mov    %esi,%eax
80101e94:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e99:	83 c4 0c             	add    $0xc,%esp
80101e9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ea1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ea3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea7:	39 d9                	cmp    %ebx,%ecx
80101ea9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101eac:	53                   	push   %ebx
80101ead:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101eb0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101eb2:	50                   	push   %eax
80101eb3:	e8 08 35 00 00       	call   801053c0 <memmove>
    log_write(bp);
80101eb8:	89 3c 24             	mov    %edi,(%esp)
80101ebb:	e8 60 18 00 00       	call   80103720 <log_write>
    brelse(bp);
80101ec0:	89 3c 24             	mov    %edi,(%esp)
80101ec3:	e8 18 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ec8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ecb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ece:	83 c4 10             	add    $0x10,%esp
80101ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ed4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ed7:	77 97                	ja     80101e70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ed9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101edc:	3b 70 58             	cmp    0x58(%eax),%esi
80101edf:	77 37                	ja     80101f18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ee1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ee7:	5b                   	pop    %ebx
80101ee8:	5e                   	pop    %esi
80101ee9:	5f                   	pop    %edi
80101eea:	5d                   	pop    %ebp
80101eeb:	c3                   	ret    
80101eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ef0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ef4:	66 83 f8 09          	cmp    $0x9,%ax
80101ef8:	77 36                	ja     80101f30 <writei+0x120>
80101efa:	8b 04 c5 44 3d 11 80 	mov    -0x7feec2bc(,%eax,8),%eax
80101f01:	85 c0                	test   %eax,%eax
80101f03:	74 2b                	je     80101f30 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101f05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f0b:	5b                   	pop    %ebx
80101f0c:	5e                   	pop    %esi
80101f0d:	5f                   	pop    %edi
80101f0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101f0f:	ff e0                	jmp    *%eax
80101f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101f18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101f1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f21:	50                   	push   %eax
80101f22:	e8 59 fa ff ff       	call   80101980 <iupdate>
80101f27:	83 c4 10             	add    $0x10,%esp
80101f2a:	eb b5                	jmp    80101ee1 <writei+0xd1>
80101f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101f30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f35:	eb ad                	jmp    80101ee4 <writei+0xd4>
80101f37:	89 f6                	mov    %esi,%esi
80101f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f40:	55                   	push   %ebp
80101f41:	89 e5                	mov    %esp,%ebp
80101f43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f46:	6a 0e                	push   $0xe
80101f48:	ff 75 0c             	pushl  0xc(%ebp)
80101f4b:	ff 75 08             	pushl  0x8(%ebp)
80101f4e:	e8 dd 34 00 00       	call   80105430 <strncmp>
}
80101f53:	c9                   	leave  
80101f54:	c3                   	ret    
80101f55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f60:	55                   	push   %ebp
80101f61:	89 e5                	mov    %esp,%ebp
80101f63:	57                   	push   %edi
80101f64:	56                   	push   %esi
80101f65:	53                   	push   %ebx
80101f66:	83 ec 1c             	sub    $0x1c,%esp
80101f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f71:	0f 85 85 00 00 00    	jne    80101ffc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f77:	8b 53 58             	mov    0x58(%ebx),%edx
80101f7a:	31 ff                	xor    %edi,%edi
80101f7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f7f:	85 d2                	test   %edx,%edx
80101f81:	74 3e                	je     80101fc1 <dirlookup+0x61>
80101f83:	90                   	nop
80101f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f88:	6a 10                	push   $0x10
80101f8a:	57                   	push   %edi
80101f8b:	56                   	push   %esi
80101f8c:	53                   	push   %ebx
80101f8d:	e8 7e fd ff ff       	call   80101d10 <readi>
80101f92:	83 c4 10             	add    $0x10,%esp
80101f95:	83 f8 10             	cmp    $0x10,%eax
80101f98:	75 55                	jne    80101fef <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f9f:	74 18                	je     80101fb9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101fa1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fa4:	83 ec 04             	sub    $0x4,%esp
80101fa7:	6a 0e                	push   $0xe
80101fa9:	50                   	push   %eax
80101faa:	ff 75 0c             	pushl  0xc(%ebp)
80101fad:	e8 7e 34 00 00       	call   80105430 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101fb2:	83 c4 10             	add    $0x10,%esp
80101fb5:	85 c0                	test   %eax,%eax
80101fb7:	74 17                	je     80101fd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fb9:	83 c7 10             	add    $0x10,%edi
80101fbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbf:	72 c7                	jb     80101f88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101fc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101fc4:	31 c0                	xor    %eax,%eax
}
80101fc6:	5b                   	pop    %ebx
80101fc7:	5e                   	pop    %esi
80101fc8:	5f                   	pop    %edi
80101fc9:	5d                   	pop    %ebp
80101fca:	c3                   	ret    
80101fcb:	90                   	nop
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101fd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd3:	85 c0                	test   %eax,%eax
80101fd5:	74 05                	je     80101fdc <dirlookup+0x7c>
        *poff = off;
80101fd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101fdc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101fe0:	8b 03                	mov    (%ebx),%eax
80101fe2:	e8 59 f6 ff ff       	call   80101640 <iget>
}
80101fe7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fea:	5b                   	pop    %ebx
80101feb:	5e                   	pop    %esi
80101fec:	5f                   	pop    %edi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
      panic("dirlookup read");
80101fef:	83 ec 0c             	sub    $0xc,%esp
80101ff2:	68 a7 90 10 80       	push   $0x801090a7
80101ff7:	e8 94 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	68 95 90 10 80       	push   $0x80109095
80102004:	e8 87 e3 ff ff       	call   80100390 <panic>
80102009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102010 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	89 cf                	mov    %ecx,%edi
80102018:	89 c3                	mov    %eax,%ebx
8010201a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010201d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80102020:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80102023:	0f 84 67 01 00 00    	je     80102190 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102029:	e8 92 22 00 00       	call   801042c0 <myproc>
  acquire(&icache.lock);
8010202e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102031:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102034:	68 c0 3d 11 80       	push   $0x80113dc0
80102039:	e8 c2 31 00 00       	call   80105200 <acquire>
  ip->ref++;
8010203e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102042:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102049:	e8 72 32 00 00       	call   801052c0 <release>
8010204e:	83 c4 10             	add    $0x10,%esp
80102051:	eb 08                	jmp    8010205b <namex+0x4b>
80102053:	90                   	nop
80102054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102058:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010205b:	0f b6 03             	movzbl (%ebx),%eax
8010205e:	3c 2f                	cmp    $0x2f,%al
80102060:	74 f6                	je     80102058 <namex+0x48>
  if(*path == 0)
80102062:	84 c0                	test   %al,%al
80102064:	0f 84 ee 00 00 00    	je     80102158 <namex+0x148>
  while(*path != '/' && *path != 0)
8010206a:	0f b6 03             	movzbl (%ebx),%eax
8010206d:	3c 2f                	cmp    $0x2f,%al
8010206f:	0f 84 b3 00 00 00    	je     80102128 <namex+0x118>
80102075:	84 c0                	test   %al,%al
80102077:	89 da                	mov    %ebx,%edx
80102079:	75 09                	jne    80102084 <namex+0x74>
8010207b:	e9 a8 00 00 00       	jmp    80102128 <namex+0x118>
80102080:	84 c0                	test   %al,%al
80102082:	74 0a                	je     8010208e <namex+0x7e>
    path++;
80102084:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102087:	0f b6 02             	movzbl (%edx),%eax
8010208a:	3c 2f                	cmp    $0x2f,%al
8010208c:	75 f2                	jne    80102080 <namex+0x70>
8010208e:	89 d1                	mov    %edx,%ecx
80102090:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102092:	83 f9 0d             	cmp    $0xd,%ecx
80102095:	0f 8e 91 00 00 00    	jle    8010212c <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010209b:	83 ec 04             	sub    $0x4,%esp
8010209e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801020a1:	6a 0e                	push   $0xe
801020a3:	53                   	push   %ebx
801020a4:	57                   	push   %edi
801020a5:	e8 16 33 00 00       	call   801053c0 <memmove>
    path++;
801020aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
801020ad:	83 c4 10             	add    $0x10,%esp
    path++;
801020b0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
801020b2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801020b5:	75 11                	jne    801020c8 <namex+0xb8>
801020b7:	89 f6                	mov    %esi,%esi
801020b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801020c0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020c3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020c6:	74 f8                	je     801020c0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	56                   	push   %esi
801020cc:	e8 5f f9 ff ff       	call   80101a30 <ilock>
    if(ip->type != T_DIR){
801020d1:	83 c4 10             	add    $0x10,%esp
801020d4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020d9:	0f 85 91 00 00 00    	jne    80102170 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020df:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020e2:	85 d2                	test   %edx,%edx
801020e4:	74 09                	je     801020ef <namex+0xdf>
801020e6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020e9:	0f 84 b7 00 00 00    	je     801021a6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020ef:	83 ec 04             	sub    $0x4,%esp
801020f2:	6a 00                	push   $0x0
801020f4:	57                   	push   %edi
801020f5:	56                   	push   %esi
801020f6:	e8 65 fe ff ff       	call   80101f60 <dirlookup>
801020fb:	83 c4 10             	add    $0x10,%esp
801020fe:	85 c0                	test   %eax,%eax
80102100:	74 6e                	je     80102170 <namex+0x160>
  iunlock(ip);
80102102:	83 ec 0c             	sub    $0xc,%esp
80102105:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102108:	56                   	push   %esi
80102109:	e8 02 fa ff ff       	call   80101b10 <iunlock>
  iput(ip);
8010210e:	89 34 24             	mov    %esi,(%esp)
80102111:	e8 4a fa ff ff       	call   80101b60 <iput>
80102116:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	89 c6                	mov    %eax,%esi
8010211e:	e9 38 ff ff ff       	jmp    8010205b <namex+0x4b>
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102128:	89 da                	mov    %ebx,%edx
8010212a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010212c:	83 ec 04             	sub    $0x4,%esp
8010212f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102132:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102135:	51                   	push   %ecx
80102136:	53                   	push   %ebx
80102137:	57                   	push   %edi
80102138:	e8 83 32 00 00       	call   801053c0 <memmove>
    name[len] = 0;
8010213d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102140:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102143:	83 c4 10             	add    $0x10,%esp
80102146:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010214a:	89 d3                	mov    %edx,%ebx
8010214c:	e9 61 ff ff ff       	jmp    801020b2 <namex+0xa2>
80102151:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102158:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010215b:	85 c0                	test   %eax,%eax
8010215d:	75 5d                	jne    801021bc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010215f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102162:	89 f0                	mov    %esi,%eax
80102164:	5b                   	pop    %ebx
80102165:	5e                   	pop    %esi
80102166:	5f                   	pop    %edi
80102167:	5d                   	pop    %ebp
80102168:	c3                   	ret    
80102169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102170:	83 ec 0c             	sub    $0xc,%esp
80102173:	56                   	push   %esi
80102174:	e8 97 f9 ff ff       	call   80101b10 <iunlock>
  iput(ip);
80102179:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010217c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010217e:	e8 dd f9 ff ff       	call   80101b60 <iput>
      return 0;
80102183:	83 c4 10             	add    $0x10,%esp
}
80102186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102189:	89 f0                	mov    %esi,%eax
8010218b:	5b                   	pop    %ebx
8010218c:	5e                   	pop    %esi
8010218d:	5f                   	pop    %edi
8010218e:	5d                   	pop    %ebp
8010218f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102190:	ba 01 00 00 00       	mov    $0x1,%edx
80102195:	b8 01 00 00 00       	mov    $0x1,%eax
8010219a:	e8 a1 f4 ff ff       	call   80101640 <iget>
8010219f:	89 c6                	mov    %eax,%esi
801021a1:	e9 b5 fe ff ff       	jmp    8010205b <namex+0x4b>
      iunlock(ip);
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	56                   	push   %esi
801021aa:	e8 61 f9 ff ff       	call   80101b10 <iunlock>
      return ip;
801021af:	83 c4 10             	add    $0x10,%esp
}
801021b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021b5:	89 f0                	mov    %esi,%eax
801021b7:	5b                   	pop    %ebx
801021b8:	5e                   	pop    %esi
801021b9:	5f                   	pop    %edi
801021ba:	5d                   	pop    %ebp
801021bb:	c3                   	ret    
    iput(ip);
801021bc:	83 ec 0c             	sub    $0xc,%esp
801021bf:	56                   	push   %esi
    return 0;
801021c0:	31 f6                	xor    %esi,%esi
    iput(ip);
801021c2:	e8 99 f9 ff ff       	call   80101b60 <iput>
    return 0;
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	eb 93                	jmp    8010215f <namex+0x14f>
801021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021d0 <dirlink>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	57                   	push   %edi
801021d4:	56                   	push   %esi
801021d5:	53                   	push   %ebx
801021d6:	83 ec 20             	sub    $0x20,%esp
801021d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021dc:	6a 00                	push   $0x0
801021de:	ff 75 0c             	pushl  0xc(%ebp)
801021e1:	53                   	push   %ebx
801021e2:	e8 79 fd ff ff       	call   80101f60 <dirlookup>
801021e7:	83 c4 10             	add    $0x10,%esp
801021ea:	85 c0                	test   %eax,%eax
801021ec:	75 67                	jne    80102255 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021ee:	8b 7b 58             	mov    0x58(%ebx),%edi
801021f1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021f4:	85 ff                	test   %edi,%edi
801021f6:	74 29                	je     80102221 <dirlink+0x51>
801021f8:	31 ff                	xor    %edi,%edi
801021fa:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021fd:	eb 09                	jmp    80102208 <dirlink+0x38>
801021ff:	90                   	nop
80102200:	83 c7 10             	add    $0x10,%edi
80102203:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102206:	73 19                	jae    80102221 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102208:	6a 10                	push   $0x10
8010220a:	57                   	push   %edi
8010220b:	56                   	push   %esi
8010220c:	53                   	push   %ebx
8010220d:	e8 fe fa ff ff       	call   80101d10 <readi>
80102212:	83 c4 10             	add    $0x10,%esp
80102215:	83 f8 10             	cmp    $0x10,%eax
80102218:	75 4e                	jne    80102268 <dirlink+0x98>
    if(de.inum == 0)
8010221a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010221f:	75 df                	jne    80102200 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102221:	8d 45 da             	lea    -0x26(%ebp),%eax
80102224:	83 ec 04             	sub    $0x4,%esp
80102227:	6a 0e                	push   $0xe
80102229:	ff 75 0c             	pushl  0xc(%ebp)
8010222c:	50                   	push   %eax
8010222d:	e8 5e 32 00 00       	call   80105490 <strncpy>
  de.inum = inum;
80102232:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102235:	6a 10                	push   $0x10
80102237:	57                   	push   %edi
80102238:	56                   	push   %esi
80102239:	53                   	push   %ebx
  de.inum = inum;
8010223a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010223e:	e8 cd fb ff ff       	call   80101e10 <writei>
80102243:	83 c4 20             	add    $0x20,%esp
80102246:	83 f8 10             	cmp    $0x10,%eax
80102249:	75 2a                	jne    80102275 <dirlink+0xa5>
  return 0;
8010224b:	31 c0                	xor    %eax,%eax
}
8010224d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102250:	5b                   	pop    %ebx
80102251:	5e                   	pop    %esi
80102252:	5f                   	pop    %edi
80102253:	5d                   	pop    %ebp
80102254:	c3                   	ret    
    iput(ip);
80102255:	83 ec 0c             	sub    $0xc,%esp
80102258:	50                   	push   %eax
80102259:	e8 02 f9 ff ff       	call   80101b60 <iput>
    return -1;
8010225e:	83 c4 10             	add    $0x10,%esp
80102261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102266:	eb e5                	jmp    8010224d <dirlink+0x7d>
      panic("dirlink read");
80102268:	83 ec 0c             	sub    $0xc,%esp
8010226b:	68 b6 90 10 80       	push   $0x801090b6
80102270:	e8 1b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 15 98 10 80       	push   $0x80109815
8010227d:	e8 0e e1 ff ff       	call   80100390 <panic>
80102282:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102290 <namei>:

struct inode*
namei(char *path)
{
80102290:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102291:	31 d2                	xor    %edx,%edx
{
80102293:	89 e5                	mov    %esp,%ebp
80102295:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102298:	8b 45 08             	mov    0x8(%ebp),%eax
8010229b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010229e:	e8 6d fd ff ff       	call   80102010 <namex>
}
801022a3:	c9                   	leave  
801022a4:	c3                   	ret    
801022a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022b0:	55                   	push   %ebp
  return namex(path, 1, name);
801022b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022bf:	e9 4c fd ff ff       	jmp    80102010 <namex>
801022c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801022d0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801022d0:	55                   	push   %ebp
    char const digit[] = "0123456789";
801022d1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801022d6:	89 e5                	mov    %esp,%ebp
801022d8:	57                   	push   %edi
801022d9:	56                   	push   %esi
801022da:	53                   	push   %ebx
801022db:	83 ec 10             	sub    $0x10,%esp
801022de:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801022e1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801022e8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801022ef:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
801022f3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
801022f7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
801022fa:	85 c9                	test   %ecx,%ecx
801022fc:	79 0a                	jns    80102308 <itoa+0x38>
801022fe:	89 f0                	mov    %esi,%eax
80102300:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102303:	f7 d9                	neg    %ecx
        *p++ = '-';
80102305:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102308:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010230a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010230f:	90                   	nop
80102310:	89 d8                	mov    %ebx,%eax
80102312:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102315:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102318:	f7 ef                	imul   %edi
8010231a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010231d:	29 da                	sub    %ebx,%edx
8010231f:	89 d3                	mov    %edx,%ebx
80102321:	75 ed                	jne    80102310 <itoa+0x40>
    *p = '\0';
80102323:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102326:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010232b:	90                   	nop
8010232c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102330:	89 c8                	mov    %ecx,%eax
80102332:	83 ee 01             	sub    $0x1,%esi
80102335:	f7 eb                	imul   %ebx
80102337:	89 c8                	mov    %ecx,%eax
80102339:	c1 f8 1f             	sar    $0x1f,%eax
8010233c:	c1 fa 02             	sar    $0x2,%edx
8010233f:	29 c2                	sub    %eax,%edx
80102341:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102344:	01 c0                	add    %eax,%eax
80102346:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102348:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010234a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010234f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102351:	88 06                	mov    %al,(%esi)
    }while(i);
80102353:	75 db                	jne    80102330 <itoa+0x60>
    return b;
}
80102355:	8b 45 0c             	mov    0xc(%ebp),%eax
80102358:	83 c4 10             	add    $0x10,%esp
8010235b:	5b                   	pop    %ebx
8010235c:	5e                   	pop    %esi
8010235d:	5f                   	pop    %edi
8010235e:	5d                   	pop    %ebp
8010235f:	c3                   	ret    

80102360 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102360:	55                   	push   %ebp
80102361:	89 e5                	mov    %esp,%ebp
80102363:	57                   	push   %edi
80102364:	56                   	push   %esi
80102365:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102366:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102369:	83 ec 40             	sub    $0x40,%esp
8010236c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010236f:	6a 06                	push   $0x6
80102371:	68 c3 90 10 80       	push   $0x801090c3
80102376:	56                   	push   %esi
80102377:	e8 44 30 00 00       	call   801053c0 <memmove>
  itoa(p->pid, path+ 6);
8010237c:	58                   	pop    %eax
8010237d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102380:	5a                   	pop    %edx
80102381:	50                   	push   %eax
80102382:	ff 73 10             	pushl  0x10(%ebx)
80102385:	e8 46 ff ff ff       	call   801022d0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010238a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	85 c0                	test   %eax,%eax
80102392:	0f 84 88 01 00 00    	je     80102520 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102398:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010239b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010239e:	50                   	push   %eax
8010239f:	e8 4c ee ff ff       	call   801011f0 <fileclose>

  begin_op();
801023a4:	e8 a7 11 00 00       	call   80103550 <begin_op>
  return namex(path, 1, name);
801023a9:	89 f0                	mov    %esi,%eax
801023ab:	89 d9                	mov    %ebx,%ecx
801023ad:	ba 01 00 00 00       	mov    $0x1,%edx
801023b2:	e8 59 fc ff ff       	call   80102010 <namex>
  if((dp = nameiparent(path, name)) == 0)
801023b7:	83 c4 10             	add    $0x10,%esp
801023ba:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801023bc:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801023be:	0f 84 66 01 00 00    	je     8010252a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	50                   	push   %eax
801023c8:	e8 63 f6 ff ff       	call   80101a30 <ilock>
  return strncmp(s, t, DIRSIZ);
801023cd:	83 c4 0c             	add    $0xc,%esp
801023d0:	6a 0e                	push   $0xe
801023d2:	68 cb 90 10 80       	push   $0x801090cb
801023d7:	53                   	push   %ebx
801023d8:	e8 53 30 00 00       	call   80105430 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	85 c0                	test   %eax,%eax
801023e2:	0f 84 f8 00 00 00    	je     801024e0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023e8:	83 ec 04             	sub    $0x4,%esp
801023eb:	6a 0e                	push   $0xe
801023ed:	68 ca 90 10 80       	push   $0x801090ca
801023f2:	53                   	push   %ebx
801023f3:	e8 38 30 00 00       	call   80105430 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023f8:	83 c4 10             	add    $0x10,%esp
801023fb:	85 c0                	test   %eax,%eax
801023fd:	0f 84 dd 00 00 00    	je     801024e0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102403:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102406:	83 ec 04             	sub    $0x4,%esp
80102409:	50                   	push   %eax
8010240a:	53                   	push   %ebx
8010240b:	56                   	push   %esi
8010240c:	e8 4f fb ff ff       	call   80101f60 <dirlookup>
80102411:	83 c4 10             	add    $0x10,%esp
80102414:	85 c0                	test   %eax,%eax
80102416:	89 c3                	mov    %eax,%ebx
80102418:	0f 84 c2 00 00 00    	je     801024e0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010241e:	83 ec 0c             	sub    $0xc,%esp
80102421:	50                   	push   %eax
80102422:	e8 09 f6 ff ff       	call   80101a30 <ilock>

  if(ip->nlink < 1)
80102427:	83 c4 10             	add    $0x10,%esp
8010242a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010242f:	0f 8e 11 01 00 00    	jle    80102546 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102435:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010243a:	74 74                	je     801024b0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010243c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010243f:	83 ec 04             	sub    $0x4,%esp
80102442:	6a 10                	push   $0x10
80102444:	6a 00                	push   $0x0
80102446:	57                   	push   %edi
80102447:	e8 c4 2e 00 00       	call   80105310 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010244c:	6a 10                	push   $0x10
8010244e:	ff 75 b8             	pushl  -0x48(%ebp)
80102451:	57                   	push   %edi
80102452:	56                   	push   %esi
80102453:	e8 b8 f9 ff ff       	call   80101e10 <writei>
80102458:	83 c4 20             	add    $0x20,%esp
8010245b:	83 f8 10             	cmp    $0x10,%eax
8010245e:	0f 85 d5 00 00 00    	jne    80102539 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102464:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102469:	0f 84 91 00 00 00    	je     80102500 <removeSwapFile+0x1a0>
  iunlock(ip);
8010246f:	83 ec 0c             	sub    $0xc,%esp
80102472:	56                   	push   %esi
80102473:	e8 98 f6 ff ff       	call   80101b10 <iunlock>
  iput(ip);
80102478:	89 34 24             	mov    %esi,(%esp)
8010247b:	e8 e0 f6 ff ff       	call   80101b60 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102480:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102485:	89 1c 24             	mov    %ebx,(%esp)
80102488:	e8 f3 f4 ff ff       	call   80101980 <iupdate>
  iunlock(ip);
8010248d:	89 1c 24             	mov    %ebx,(%esp)
80102490:	e8 7b f6 ff ff       	call   80101b10 <iunlock>
  iput(ip);
80102495:	89 1c 24             	mov    %ebx,(%esp)
80102498:	e8 c3 f6 ff ff       	call   80101b60 <iput>
  iunlockput(ip);

  end_op();
8010249d:	e8 1e 11 00 00       	call   801035c0 <end_op>

  return 0;
801024a2:	83 c4 10             	add    $0x10,%esp
801024a5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801024a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024aa:	5b                   	pop    %ebx
801024ab:	5e                   	pop    %esi
801024ac:	5f                   	pop    %edi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801024b0:	83 ec 0c             	sub    $0xc,%esp
801024b3:	53                   	push   %ebx
801024b4:	e8 37 36 00 00       	call   80105af0 <isdirempty>
801024b9:	83 c4 10             	add    $0x10,%esp
801024bc:	85 c0                	test   %eax,%eax
801024be:	0f 85 78 ff ff ff    	jne    8010243c <removeSwapFile+0xdc>
  iunlock(ip);
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	53                   	push   %ebx
801024c8:	e8 43 f6 ff ff       	call   80101b10 <iunlock>
  iput(ip);
801024cd:	89 1c 24             	mov    %ebx,(%esp)
801024d0:	e8 8b f6 ff ff       	call   80101b60 <iput>
801024d5:	83 c4 10             	add    $0x10,%esp
801024d8:	90                   	nop
801024d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801024e0:	83 ec 0c             	sub    $0xc,%esp
801024e3:	56                   	push   %esi
801024e4:	e8 27 f6 ff ff       	call   80101b10 <iunlock>
  iput(ip);
801024e9:	89 34 24             	mov    %esi,(%esp)
801024ec:	e8 6f f6 ff ff       	call   80101b60 <iput>
    end_op();
801024f1:	e8 ca 10 00 00       	call   801035c0 <end_op>
    return -1;
801024f6:	83 c4 10             	add    $0x10,%esp
801024f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024fe:	eb a7                	jmp    801024a7 <removeSwapFile+0x147>
    dp->nlink--;
80102500:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102505:	83 ec 0c             	sub    $0xc,%esp
80102508:	56                   	push   %esi
80102509:	e8 72 f4 ff ff       	call   80101980 <iupdate>
8010250e:	83 c4 10             	add    $0x10,%esp
80102511:	e9 59 ff ff ff       	jmp    8010246f <removeSwapFile+0x10f>
80102516:	8d 76 00             	lea    0x0(%esi),%esi
80102519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102525:	e9 7d ff ff ff       	jmp    801024a7 <removeSwapFile+0x147>
    end_op();
8010252a:	e8 91 10 00 00       	call   801035c0 <end_op>
    return -1;
8010252f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102534:	e9 6e ff ff ff       	jmp    801024a7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102539:	83 ec 0c             	sub    $0xc,%esp
8010253c:	68 df 90 10 80       	push   $0x801090df
80102541:	e8 4a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	68 cd 90 10 80       	push   $0x801090cd
8010254e:	e8 3d de ff ff       	call   80100390 <panic>
80102553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	56                   	push   %esi
80102564:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102565:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102568:	83 ec 14             	sub    $0x14,%esp
8010256b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010256e:	6a 06                	push   $0x6
80102570:	68 c3 90 10 80       	push   $0x801090c3
80102575:	56                   	push   %esi
80102576:	e8 45 2e 00 00       	call   801053c0 <memmove>
  itoa(p->pid, path+ 6);
8010257b:	58                   	pop    %eax
8010257c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010257f:	5a                   	pop    %edx
80102580:	50                   	push   %eax
80102581:	ff 73 10             	pushl  0x10(%ebx)
80102584:	e8 47 fd ff ff       	call   801022d0 <itoa>

    begin_op();
80102589:	e8 c2 0f 00 00       	call   80103550 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010258e:	6a 00                	push   $0x0
80102590:	6a 00                	push   $0x0
80102592:	6a 02                	push   $0x2
80102594:	56                   	push   %esi
80102595:	e8 66 37 00 00       	call   80105d00 <create>
  iunlock(in);
8010259a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010259d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010259f:	50                   	push   %eax
801025a0:	e8 6b f5 ff ff       	call   80101b10 <iunlock>

  p->swapFile = filealloc();
801025a5:	e8 86 eb ff ff       	call   80101130 <filealloc>
  if (p->swapFile == 0)
801025aa:	83 c4 10             	add    $0x10,%esp
801025ad:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801025af:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801025b2:	74 32                	je     801025e6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801025b4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801025b7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025ba:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801025c0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025c3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801025ca:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025cd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801025d1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025d4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801025d8:	e8 e3 0f 00 00       	call   801035c0 <end_op>

    return 0;
}
801025dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025e0:	31 c0                	xor    %eax,%eax
801025e2:	5b                   	pop    %ebx
801025e3:	5e                   	pop    %esi
801025e4:	5d                   	pop    %ebp
801025e5:	c3                   	ret    
    panic("no slot for files on /store");
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	68 ee 90 10 80       	push   $0x801090ee
801025ee:	e8 9d dd ff ff       	call   80100390 <panic>
801025f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102600 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102606:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102609:	8b 50 7c             	mov    0x7c(%eax),%edx
8010260c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010260f:	8b 55 14             	mov    0x14(%ebp),%edx
80102612:	89 55 10             	mov    %edx,0x10(%ebp)
80102615:	8b 40 7c             	mov    0x7c(%eax),%eax
80102618:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010261b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010261c:	e9 7f ed ff ff       	jmp    801013a0 <filewrite>
80102621:	eb 0d                	jmp    80102630 <readFromSwapFile>
80102623:	90                   	nop
80102624:	90                   	nop
80102625:	90                   	nop
80102626:	90                   	nop
80102627:	90                   	nop
80102628:	90                   	nop
80102629:	90                   	nop
8010262a:	90                   	nop
8010262b:	90                   	nop
8010262c:	90                   	nop
8010262d:	90                   	nop
8010262e:	90                   	nop
8010262f:	90                   	nop

80102630 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102630:	55                   	push   %ebp
80102631:	89 e5                	mov    %esp,%ebp
80102633:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102636:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102639:	8b 50 7c             	mov    0x7c(%eax),%edx
8010263c:	89 4a 14             	mov    %ecx,0x14(%edx)
  return fileread(p->swapFile, buffer,  size);
8010263f:	8b 55 14             	mov    0x14(%ebp),%edx
80102642:	89 55 10             	mov    %edx,0x10(%ebp)
80102645:	8b 40 7c             	mov    0x7c(%eax),%eax
80102648:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010264b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010264c:	e9 bf ec ff ff       	jmp    80101310 <fileread>
80102651:	66 90                	xchg   %ax,%ax
80102653:	66 90                	xchg   %ax,%ax
80102655:	66 90                	xchg   %ax,%ax
80102657:	66 90                	xchg   %ax,%ax
80102659:	66 90                	xchg   %ax,%ax
8010265b:	66 90                	xchg   %ax,%ax
8010265d:	66 90                	xchg   %ax,%ax
8010265f:	90                   	nop

80102660 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	57                   	push   %edi
80102664:	56                   	push   %esi
80102665:	53                   	push   %ebx
80102666:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102669:	85 c0                	test   %eax,%eax
8010266b:	0f 84 b4 00 00 00    	je     80102725 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102671:	8b 58 08             	mov    0x8(%eax),%ebx
80102674:	89 c6                	mov    %eax,%esi
80102676:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010267c:	0f 87 96 00 00 00    	ja     80102718 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102682:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102687:	89 f6                	mov    %esi,%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102690:	89 ca                	mov    %ecx,%edx
80102692:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102693:	83 e0 c0             	and    $0xffffffc0,%eax
80102696:	3c 40                	cmp    $0x40,%al
80102698:	75 f6                	jne    80102690 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010269a:	31 ff                	xor    %edi,%edi
8010269c:	ba f6 03 00 00       	mov    $0x3f6,%edx
801026a1:	89 f8                	mov    %edi,%eax
801026a3:	ee                   	out    %al,(%dx)
801026a4:	b8 01 00 00 00       	mov    $0x1,%eax
801026a9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801026ae:	ee                   	out    %al,(%dx)
801026af:	ba f3 01 00 00       	mov    $0x1f3,%edx
801026b4:	89 d8                	mov    %ebx,%eax
801026b6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801026b7:	89 d8                	mov    %ebx,%eax
801026b9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801026be:	c1 f8 08             	sar    $0x8,%eax
801026c1:	ee                   	out    %al,(%dx)
801026c2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801026c7:	89 f8                	mov    %edi,%eax
801026c9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026ca:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801026ce:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026d3:	c1 e0 04             	shl    $0x4,%eax
801026d6:	83 e0 10             	and    $0x10,%eax
801026d9:	83 c8 e0             	or     $0xffffffe0,%eax
801026dc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801026dd:	f6 06 04             	testb  $0x4,(%esi)
801026e0:	75 16                	jne    801026f8 <idestart+0x98>
801026e2:	b8 20 00 00 00       	mov    $0x20,%eax
801026e7:	89 ca                	mov    %ecx,%edx
801026e9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801026ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ed:	5b                   	pop    %ebx
801026ee:	5e                   	pop    %esi
801026ef:	5f                   	pop    %edi
801026f0:	5d                   	pop    %ebp
801026f1:	c3                   	ret    
801026f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801026f8:	b8 30 00 00 00       	mov    $0x30,%eax
801026fd:	89 ca                	mov    %ecx,%edx
801026ff:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102700:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102705:	83 c6 5c             	add    $0x5c,%esi
80102708:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010270d:	fc                   	cld    
8010270e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102710:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102713:	5b                   	pop    %ebx
80102714:	5e                   	pop    %esi
80102715:	5f                   	pop    %edi
80102716:	5d                   	pop    %ebp
80102717:	c3                   	ret    
    panic("incorrect blockno");
80102718:	83 ec 0c             	sub    $0xc,%esp
8010271b:	68 68 91 10 80       	push   $0x80109168
80102720:	e8 6b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102725:	83 ec 0c             	sub    $0xc,%esp
80102728:	68 5f 91 10 80       	push   $0x8010915f
8010272d:	e8 5e dc ff ff       	call   80100390 <panic>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <ideinit>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102746:	68 7a 91 10 80       	push   $0x8010917a
8010274b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102750:	e8 6b 29 00 00       	call   801050c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102755:	58                   	pop    %eax
80102756:	a1 e0 60 18 80       	mov    0x801860e0,%eax
8010275b:	5a                   	pop    %edx
8010275c:	83 e8 01             	sub    $0x1,%eax
8010275f:	50                   	push   %eax
80102760:	6a 0e                	push   $0xe
80102762:	e8 a9 02 00 00       	call   80102a10 <ioapicenable>
80102767:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010276a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010276f:	90                   	nop
80102770:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102771:	83 e0 c0             	and    $0xffffffc0,%eax
80102774:	3c 40                	cmp    $0x40,%al
80102776:	75 f8                	jne    80102770 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102778:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010277d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102782:	ee                   	out    %al,(%dx)
80102783:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102788:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010278d:	eb 06                	jmp    80102795 <ideinit+0x55>
8010278f:	90                   	nop
  for(i=0; i<1000; i++){
80102790:	83 e9 01             	sub    $0x1,%ecx
80102793:	74 0f                	je     801027a4 <ideinit+0x64>
80102795:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102796:	84 c0                	test   %al,%al
80102798:	74 f6                	je     80102790 <ideinit+0x50>
      havedisk1 = 1;
8010279a:	c7 05 80 c5 10 80 01 	movl   $0x1,0x8010c580
801027a1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801027a9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027ae:	ee                   	out    %al,(%dx)
}
801027af:	c9                   	leave  
801027b0:	c3                   	ret    
801027b1:	eb 0d                	jmp    801027c0 <ideintr>
801027b3:	90                   	nop
801027b4:	90                   	nop
801027b5:	90                   	nop
801027b6:	90                   	nop
801027b7:	90                   	nop
801027b8:	90                   	nop
801027b9:	90                   	nop
801027ba:	90                   	nop
801027bb:	90                   	nop
801027bc:	90                   	nop
801027bd:	90                   	nop
801027be:	90                   	nop
801027bf:	90                   	nop

801027c0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	57                   	push   %edi
801027c4:	56                   	push   %esi
801027c5:	53                   	push   %ebx
801027c6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027c9:	68 a0 c5 10 80       	push   $0x8010c5a0
801027ce:	e8 2d 2a 00 00       	call   80105200 <acquire>

  if((b = idequeue) == 0){
801027d3:	8b 1d 84 c5 10 80    	mov    0x8010c584,%ebx
801027d9:	83 c4 10             	add    $0x10,%esp
801027dc:	85 db                	test   %ebx,%ebx
801027de:	74 67                	je     80102847 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801027e0:	8b 43 58             	mov    0x58(%ebx),%eax
801027e3:	a3 84 c5 10 80       	mov    %eax,0x8010c584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027e8:	8b 3b                	mov    (%ebx),%edi
801027ea:	f7 c7 04 00 00 00    	test   $0x4,%edi
801027f0:	75 31                	jne    80102823 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027f2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801027f7:	89 f6                	mov    %esi,%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102800:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102801:	89 c6                	mov    %eax,%esi
80102803:	83 e6 c0             	and    $0xffffffc0,%esi
80102806:	89 f1                	mov    %esi,%ecx
80102808:	80 f9 40             	cmp    $0x40,%cl
8010280b:	75 f3                	jne    80102800 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010280d:	a8 21                	test   $0x21,%al
8010280f:	75 12                	jne    80102823 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102811:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102814:	b9 80 00 00 00       	mov    $0x80,%ecx
80102819:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010281e:	fc                   	cld    
8010281f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102821:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102823:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102826:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102829:	89 f9                	mov    %edi,%ecx
8010282b:	83 c9 02             	or     $0x2,%ecx
8010282e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102830:	53                   	push   %ebx
80102831:	e8 ba 24 00 00       	call   80104cf0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102836:	a1 84 c5 10 80       	mov    0x8010c584,%eax
8010283b:	83 c4 10             	add    $0x10,%esp
8010283e:	85 c0                	test   %eax,%eax
80102840:	74 05                	je     80102847 <ideintr+0x87>
    idestart(idequeue);
80102842:	e8 19 fe ff ff       	call   80102660 <idestart>
    release(&idelock);
80102847:	83 ec 0c             	sub    $0xc,%esp
8010284a:	68 a0 c5 10 80       	push   $0x8010c5a0
8010284f:	e8 6c 2a 00 00       	call   801052c0 <release>

  release(&idelock);
}
80102854:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102857:	5b                   	pop    %ebx
80102858:	5e                   	pop    %esi
80102859:	5f                   	pop    %edi
8010285a:	5d                   	pop    %ebp
8010285b:	c3                   	ret    
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	53                   	push   %ebx
80102864:	83 ec 10             	sub    $0x10,%esp
80102867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010286a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010286d:	50                   	push   %eax
8010286e:	e8 fd 27 00 00       	call   80105070 <holdingsleep>
80102873:	83 c4 10             	add    $0x10,%esp
80102876:	85 c0                	test   %eax,%eax
80102878:	0f 84 c6 00 00 00    	je     80102944 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010287e:	8b 03                	mov    (%ebx),%eax
80102880:	83 e0 06             	and    $0x6,%eax
80102883:	83 f8 02             	cmp    $0x2,%eax
80102886:	0f 84 ab 00 00 00    	je     80102937 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010288c:	8b 53 04             	mov    0x4(%ebx),%edx
8010288f:	85 d2                	test   %edx,%edx
80102891:	74 0d                	je     801028a0 <iderw+0x40>
80102893:	a1 80 c5 10 80       	mov    0x8010c580,%eax
80102898:	85 c0                	test   %eax,%eax
8010289a:	0f 84 b1 00 00 00    	je     80102951 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801028a0:	83 ec 0c             	sub    $0xc,%esp
801028a3:	68 a0 c5 10 80       	push   $0x8010c5a0
801028a8:	e8 53 29 00 00       	call   80105200 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028ad:	8b 15 84 c5 10 80    	mov    0x8010c584,%edx
801028b3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801028b6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028bd:	85 d2                	test   %edx,%edx
801028bf:	75 09                	jne    801028ca <iderw+0x6a>
801028c1:	eb 6d                	jmp    80102930 <iderw+0xd0>
801028c3:	90                   	nop
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028c8:	89 c2                	mov    %eax,%edx
801028ca:	8b 42 58             	mov    0x58(%edx),%eax
801028cd:	85 c0                	test   %eax,%eax
801028cf:	75 f7                	jne    801028c8 <iderw+0x68>
801028d1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801028d4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801028d6:	39 1d 84 c5 10 80    	cmp    %ebx,0x8010c584
801028dc:	74 42                	je     80102920 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028de:	8b 03                	mov    (%ebx),%eax
801028e0:	83 e0 06             	and    $0x6,%eax
801028e3:	83 f8 02             	cmp    $0x2,%eax
801028e6:	74 23                	je     8010290b <iderw+0xab>
801028e8:	90                   	nop
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801028f0:	83 ec 08             	sub    $0x8,%esp
801028f3:	68 a0 c5 10 80       	push   $0x8010c5a0
801028f8:	53                   	push   %ebx
801028f9:	e8 b2 21 00 00       	call   80104ab0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028fe:	8b 03                	mov    (%ebx),%eax
80102900:	83 c4 10             	add    $0x10,%esp
80102903:	83 e0 06             	and    $0x6,%eax
80102906:	83 f8 02             	cmp    $0x2,%eax
80102909:	75 e5                	jne    801028f0 <iderw+0x90>
  }


  release(&idelock);
8010290b:	c7 45 08 a0 c5 10 80 	movl   $0x8010c5a0,0x8(%ebp)
}
80102912:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102915:	c9                   	leave  
  release(&idelock);
80102916:	e9 a5 29 00 00       	jmp    801052c0 <release>
8010291b:	90                   	nop
8010291c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102920:	89 d8                	mov    %ebx,%eax
80102922:	e8 39 fd ff ff       	call   80102660 <idestart>
80102927:	eb b5                	jmp    801028de <iderw+0x7e>
80102929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102930:	ba 84 c5 10 80       	mov    $0x8010c584,%edx
80102935:	eb 9d                	jmp    801028d4 <iderw+0x74>
    panic("iderw: nothing to do");
80102937:	83 ec 0c             	sub    $0xc,%esp
8010293a:	68 94 91 10 80       	push   $0x80109194
8010293f:	e8 4c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 7e 91 10 80       	push   $0x8010917e
8010294c:	e8 3f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	68 a9 91 10 80       	push   $0x801091a9
80102959:	e8 32 da ff ff       	call   80100390 <panic>
8010295e:	66 90                	xchg   %ax,%ax

80102960 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102960:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102961:	c7 05 14 5a 11 80 00 	movl   $0xfec00000,0x80115a14
80102968:	00 c0 fe 
{
8010296b:	89 e5                	mov    %esp,%ebp
8010296d:	56                   	push   %esi
8010296e:	53                   	push   %ebx
  ioapic->reg = reg;
8010296f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102976:	00 00 00 
  return ioapic->data;
80102979:	a1 14 5a 11 80       	mov    0x80115a14,%eax
8010297e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102981:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102987:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010298d:	0f b6 15 40 5b 18 80 	movzbl 0x80185b40,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102994:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102997:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010299a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010299d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801029a0:	39 c2                	cmp    %eax,%edx
801029a2:	74 16                	je     801029ba <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029a4:	83 ec 0c             	sub    $0xc,%esp
801029a7:	68 c8 91 10 80       	push   $0x801091c8
801029ac:	e8 af dc ff ff       	call   80100660 <cprintf>
801029b1:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
801029b7:	83 c4 10             	add    $0x10,%esp
801029ba:	83 c3 21             	add    $0x21,%ebx
{
801029bd:	ba 10 00 00 00       	mov    $0x10,%edx
801029c2:	b8 20 00 00 00       	mov    $0x20,%eax
801029c7:	89 f6                	mov    %esi,%esi
801029c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801029d0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801029d2:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029d8:	89 c6                	mov    %eax,%esi
801029da:	81 ce 00 00 01 00    	or     $0x10000,%esi
801029e0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801029e3:	89 71 10             	mov    %esi,0x10(%ecx)
801029e6:	8d 72 01             	lea    0x1(%edx),%esi
801029e9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801029ec:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801029ee:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801029f0:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
801029f6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801029fd:	75 d1                	jne    801029d0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801029ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a02:	5b                   	pop    %ebx
80102a03:	5e                   	pop    %esi
80102a04:	5d                   	pop    %ebp
80102a05:	c3                   	ret    
80102a06:	8d 76 00             	lea    0x0(%esi),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a10:	55                   	push   %ebp
  ioapic->reg = reg;
80102a11:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
{
80102a17:	89 e5                	mov    %esp,%ebp
80102a19:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a1c:	8d 50 20             	lea    0x20(%eax),%edx
80102a1f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102a23:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a25:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a2b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a2e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a31:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a34:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a36:	a1 14 5a 11 80       	mov    0x80115a14,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a3b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102a3e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a41:	5d                   	pop    %ebp
80102a42:	c3                   	ret    
80102a43:	66 90                	xchg   %ax,%ax
80102a45:	66 90                	xchg   %ax,%ax
80102a47:	66 90                	xchg   %ax,%ax
80102a49:	66 90                	xchg   %ax,%ax
80102a4b:	66 90                	xchg   %ax,%ax
80102a4d:	66 90                	xchg   %ax,%ax
80102a4f:	90                   	nop

80102a50 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	53                   	push   %ebx
80102a54:	83 ec 04             	sub    $0x4,%esp
80102a57:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a5a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102a5f:	0f 85 ad 00 00 00    	jne    80102b12 <kfree+0xc2>
80102a65:	3d 88 75 19 80       	cmp    $0x80197588,%eax
80102a6a:	0f 82 a2 00 00 00    	jb     80102b12 <kfree+0xc2>
80102a70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102a76:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102a7c:	0f 87 90 00 00 00    	ja     80102b12 <kfree+0xc2>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a82:	83 ec 04             	sub    $0x4,%esp
80102a85:	68 00 10 00 00       	push   $0x1000
80102a8a:	6a 01                	push   $0x1
80102a8c:	50                   	push   %eax
80102a8d:	e8 7e 28 00 00       	call   80105310 <memset>

  if(kmem.use_lock) 
80102a92:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102a98:	83 c4 10             	add    $0x10,%esp
80102a9b:	85 d2                	test   %edx,%edx
80102a9d:	75 61                	jne    80102b00 <kfree+0xb0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102a9f:	c1 eb 0c             	shr    $0xc,%ebx
80102aa2:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 1)
80102aa5:	83 3c c5 30 5a 11 80 	cmpl   $0x1,-0x7feea5d0(,%eax,8)
80102aac:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102aad:	8d 14 c5 2c 5a 11 80 	lea    -0x7feea5d4(,%eax,8),%edx
  if(r->refcount != 1)
80102ab4:	75 69                	jne    80102b1f <kfree+0xcf>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
80102ab6:	8b 0d 58 5a 11 80    	mov    0x80115a58,%ecx
  r->refcount = 0;
80102abc:	c7 04 c5 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%eax,8)
80102ac3:	00 00 00 00 
  kmem.freelist = r;
80102ac7:	89 15 58 5a 11 80    	mov    %edx,0x80115a58
  r->next = kmem.freelist;
80102acd:	89 0c c5 2c 5a 11 80 	mov    %ecx,-0x7feea5d4(,%eax,8)
  if(kmem.use_lock)
80102ad4:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102ad9:	85 c0                	test   %eax,%eax
80102adb:	75 0b                	jne    80102ae8 <kfree+0x98>
    release(&kmem.lock);
}
80102add:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ae0:	c9                   	leave  
80102ae1:	c3                   	ret    
80102ae2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102ae8:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102af2:	c9                   	leave  
    release(&kmem.lock);
80102af3:	e9 c8 27 00 00       	jmp    801052c0 <release>
80102af8:	90                   	nop
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b00:	83 ec 0c             	sub    $0xc,%esp
80102b03:	68 20 5a 11 80       	push   $0x80115a20
80102b08:	e8 f3 26 00 00       	call   80105200 <acquire>
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	eb 8d                	jmp    80102a9f <kfree+0x4f>
    panic("kfree");
80102b12:	83 ec 0c             	sub    $0xc,%esp
80102b15:	68 fa 91 10 80       	push   $0x801091fa
80102b1a:	e8 71 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b1f:	83 ec 0c             	sub    $0xc,%esp
80102b22:	68 00 92 10 80       	push   $0x80109200
80102b27:	e8 64 d8 ff ff       	call   80100390 <panic>
80102b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b30 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	53                   	push   %ebx
80102b34:	83 ec 04             	sub    $0x4,%esp
80102b37:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b3a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102b3f:	0f 85 bd 00 00 00    	jne    80102c02 <kfree_nocheck+0xd2>
80102b45:	3d 88 75 19 80       	cmp    $0x80197588,%eax
80102b4a:	0f 82 b2 00 00 00    	jb     80102c02 <kfree_nocheck+0xd2>
80102b50:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102b56:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102b5c:	0f 87 a0 00 00 00    	ja     80102c02 <kfree_nocheck+0xd2>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b62:	83 ec 04             	sub    $0x4,%esp
80102b65:	68 00 10 00 00       	push   $0x1000
80102b6a:	6a 01                	push   $0x1
80102b6c:	50                   	push   %eax
80102b6d:	e8 9e 27 00 00       	call   80105310 <memset>

  if(kmem.use_lock) 
80102b72:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102b78:	83 c4 10             	add    $0x10,%esp
80102b7b:	85 d2                	test   %edx,%edx
80102b7d:	75 31                	jne    80102bb0 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102b7f:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102b84:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102b87:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
80102b8a:	c7 04 dd 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%ebx,8)
80102b91:	00 00 00 00 
  r->next = kmem.freelist;
80102b95:	89 04 dd 2c 5a 11 80 	mov    %eax,-0x7feea5d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102b9c:	8d 04 dd 2c 5a 11 80 	lea    -0x7feea5d4(,%ebx,8),%eax
80102ba3:	a3 58 5a 11 80       	mov    %eax,0x80115a58
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102ba8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bab:	c9                   	leave  
80102bac:	c3                   	ret    
80102bad:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102bb0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bb3:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102bb6:	68 20 5a 11 80       	push   $0x80115a20
  r->next = kmem.freelist;
80102bbb:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102bbe:	e8 3d 26 00 00       	call   80105200 <acquire>
  r->next = kmem.freelist;
80102bc3:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(kmem.use_lock)
80102bc8:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102bcb:	c7 04 dd 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%ebx,8)
80102bd2:	00 00 00 00 
  r->next = kmem.freelist;
80102bd6:	89 04 dd 2c 5a 11 80 	mov    %eax,-0x7feea5d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bdd:	8d 04 dd 2c 5a 11 80 	lea    -0x7feea5d4(,%ebx,8),%eax
80102be4:	a3 58 5a 11 80       	mov    %eax,0x80115a58
  if(kmem.use_lock)
80102be9:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102bee:	85 c0                	test   %eax,%eax
80102bf0:	74 b6                	je     80102ba8 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102bf2:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102bf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bfc:	c9                   	leave  
    release(&kmem.lock);
80102bfd:	e9 be 26 00 00       	jmp    801052c0 <release>
    panic("kfree_nocheck");
80102c02:	83 ec 0c             	sub    $0xc,%esp
80102c05:	68 1d 92 10 80       	push   $0x8010921d
80102c0a:	e8 81 d7 ff ff       	call   80100390 <panic>
80102c0f:	90                   	nop

80102c10 <freerange>:
{
80102c10:	55                   	push   %ebp
80102c11:	89 e5                	mov    %esp,%ebp
80102c13:	56                   	push   %esi
80102c14:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c15:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c18:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c1b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c21:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c27:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c2d:	39 de                	cmp    %ebx,%esi
80102c2f:	72 23                	jb     80102c54 <freerange+0x44>
80102c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102c38:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c3e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c41:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102c47:	50                   	push   %eax
80102c48:	e8 e3 fe ff ff       	call   80102b30 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c4d:	83 c4 10             	add    $0x10,%esp
80102c50:	39 f3                	cmp    %esi,%ebx
80102c52:	76 e4                	jbe    80102c38 <freerange+0x28>
}
80102c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c57:	5b                   	pop    %ebx
80102c58:	5e                   	pop    %esi
80102c59:	5d                   	pop    %ebp
80102c5a:	c3                   	ret    
80102c5b:	90                   	nop
80102c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c60 <kinit1>:
{
80102c60:	55                   	push   %ebp
80102c61:	89 e5                	mov    %esp,%ebp
80102c63:	56                   	push   %esi
80102c64:	53                   	push   %ebx
80102c65:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c68:	83 ec 08             	sub    $0x8,%esp
80102c6b:	68 2b 92 10 80       	push   $0x8010922b
80102c70:	68 20 5a 11 80       	push   $0x80115a20
80102c75:	e8 46 24 00 00       	call   801050c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c7d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c80:	c7 05 54 5a 11 80 00 	movl   $0x0,0x80115a54
80102c87:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c8a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c96:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c9c:	39 de                	cmp    %ebx,%esi
80102c9e:	72 1c                	jb     80102cbc <kinit1+0x5c>
    kfree_nocheck(p);
80102ca0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102ca6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ca9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102caf:	50                   	push   %eax
80102cb0:	e8 7b fe ff ff       	call   80102b30 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cb5:	83 c4 10             	add    $0x10,%esp
80102cb8:	39 de                	cmp    %ebx,%esi
80102cba:	73 e4                	jae    80102ca0 <kinit1+0x40>
}
80102cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102cbf:	5b                   	pop    %ebx
80102cc0:	5e                   	pop    %esi
80102cc1:	5d                   	pop    %ebp
80102cc2:	c3                   	ret    
80102cc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cd0 <kinit2>:
{
80102cd0:	55                   	push   %ebp
80102cd1:	89 e5                	mov    %esp,%ebp
80102cd3:	56                   	push   %esi
80102cd4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102cd5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102cd8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102cdb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ce1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ce7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102ced:	39 de                	cmp    %ebx,%esi
80102cef:	72 23                	jb     80102d14 <kinit2+0x44>
80102cf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102cf8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cfe:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d01:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102d07:	50                   	push   %eax
80102d08:	e8 23 fe ff ff       	call   80102b30 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d0d:	83 c4 10             	add    $0x10,%esp
80102d10:	39 de                	cmp    %ebx,%esi
80102d12:	73 e4                	jae    80102cf8 <kinit2+0x28>
  kmem.use_lock = 1;
80102d14:	c7 05 54 5a 11 80 01 	movl   $0x1,0x80115a54
80102d1b:	00 00 00 
}
80102d1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d21:	5b                   	pop    %ebx
80102d22:	5e                   	pop    %esi
80102d23:	5d                   	pop    %ebp
80102d24:	c3                   	ret    
80102d25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d30 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102d36:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	75 59                	jne    80102d98 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d3f:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(r)
80102d44:	85 c0                	test   %eax,%eax
80102d46:	74 73                	je     80102dbb <kalloc+0x8b>
  {
    kmem.freelist = r->next;
80102d48:	8b 10                	mov    (%eax),%edx
80102d4a:	89 15 58 5a 11 80    	mov    %edx,0x80115a58
    r->refcount = 1;
80102d50:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102d57:	8b 0d 54 5a 11 80    	mov    0x80115a54,%ecx
80102d5d:	85 c9                	test   %ecx,%ecx
80102d5f:	75 0f                	jne    80102d70 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d61:	2d 5c 5a 11 80       	sub    $0x80115a5c,%eax
80102d66:	c1 e0 09             	shl    $0x9,%eax
80102d69:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102d6e:	c9                   	leave  
80102d6f:	c3                   	ret    
    release(&kmem.lock);
80102d70:	83 ec 0c             	sub    $0xc,%esp
80102d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d76:	68 20 5a 11 80       	push   $0x80115a20
80102d7b:	e8 40 25 00 00       	call   801052c0 <release>
80102d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d83:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d86:	2d 5c 5a 11 80       	sub    $0x80115a5c,%eax
80102d8b:	c1 e0 09             	shl    $0x9,%eax
80102d8e:	05 00 00 00 80       	add    $0x80000000,%eax
80102d93:	eb d9                	jmp    80102d6e <kalloc+0x3e>
80102d95:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102d98:	83 ec 0c             	sub    $0xc,%esp
80102d9b:	68 20 5a 11 80       	push   $0x80115a20
80102da0:	e8 5b 24 00 00       	call   80105200 <acquire>
  r = kmem.freelist;
80102da5:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(r)
80102daa:	83 c4 10             	add    $0x10,%esp
80102dad:	85 c0                	test   %eax,%eax
80102daf:	75 97                	jne    80102d48 <kalloc+0x18>
  if(kmem.use_lock)
80102db1:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102db7:	85 d2                	test   %edx,%edx
80102db9:	75 05                	jne    80102dc0 <kalloc+0x90>
{
80102dbb:	31 c0                	xor    %eax,%eax
}
80102dbd:	c9                   	leave  
80102dbe:	c3                   	ret    
80102dbf:	90                   	nop
    release(&kmem.lock);
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102dc6:	68 20 5a 11 80       	push   $0x80115a20
80102dcb:	e8 f0 24 00 00       	call   801052c0 <release>
80102dd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd3:	83 c4 10             	add    $0x10,%esp
}
80102dd6:	c9                   	leave  
80102dd7:	c3                   	ret    
80102dd8:	90                   	nop
80102dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102de0 <refDec>:

void
refDec(char *v)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	53                   	push   %ebx
80102de4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102de7:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
{
80102ded:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102df0:	85 d2                	test   %edx,%edx
80102df2:	75 1c                	jne    80102e10 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102df4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102dfa:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102dfd:	83 2c c5 60 5a 11 80 	subl   $0x1,-0x7feea5a0(,%eax,8)
80102e04:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102e05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e08:	c9                   	leave  
80102e09:	c3                   	ret    
80102e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e10:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e13:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e19:	68 20 5a 11 80       	push   $0x80115a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e1e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e21:	e8 da 23 00 00       	call   80105200 <acquire>
  if(kmem.use_lock)
80102e26:	a1 54 5a 11 80       	mov    0x80115a54,%eax
  r->refcount -= 1;
80102e2b:	83 2c dd 60 5a 11 80 	subl   $0x1,-0x7feea5a0(,%ebx,8)
80102e32:	01 
  if(kmem.use_lock)
80102e33:	83 c4 10             	add    $0x10,%esp
80102e36:	85 c0                	test   %eax,%eax
80102e38:	74 cb                	je     80102e05 <refDec+0x25>
    release(&kmem.lock);
80102e3a:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e44:	c9                   	leave  
    release(&kmem.lock);
80102e45:	e9 76 24 00 00       	jmp    801052c0 <release>
80102e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e50 <refInc>:

void
refInc(char *v)
{
80102e50:	55                   	push   %ebp
80102e51:	89 e5                	mov    %esp,%ebp
80102e53:	53                   	push   %ebx
80102e54:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102e57:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
{
80102e5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102e60:	85 d2                	test   %edx,%edx
80102e62:	75 1c                	jne    80102e80 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e64:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e6a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102e6d:	83 04 c5 60 5a 11 80 	addl   $0x1,-0x7feea5a0(,%eax,8)
80102e74:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102e75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e78:	c9                   	leave  
80102e79:	c3                   	ret    
80102e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e80:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e83:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e89:	68 20 5a 11 80       	push   $0x80115a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e8e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e91:	e8 6a 23 00 00       	call   80105200 <acquire>
  if(kmem.use_lock)
80102e96:	a1 54 5a 11 80       	mov    0x80115a54,%eax
  r->refcount += 1;
80102e9b:	83 04 dd 60 5a 11 80 	addl   $0x1,-0x7feea5a0(,%ebx,8)
80102ea2:	01 
  if(kmem.use_lock)
80102ea3:	83 c4 10             	add    $0x10,%esp
80102ea6:	85 c0                	test   %eax,%eax
80102ea8:	74 cb                	je     80102e75 <refInc+0x25>
    release(&kmem.lock);
80102eaa:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102eb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eb4:	c9                   	leave  
    release(&kmem.lock);
80102eb5:	e9 06 24 00 00       	jmp    801052c0 <release>
80102eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ec0 <getRefs>:

int
getRefs(char *v)
{
80102ec0:	55                   	push   %ebp
80102ec1:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102ec6:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ec7:	05 00 00 00 80       	add    $0x80000000,%eax
80102ecc:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102ecf:	8b 04 c5 60 5a 11 80 	mov    -0x7feea5a0(,%eax,8),%eax
80102ed6:	c3                   	ret    
80102ed7:	66 90                	xchg   %ax,%ax
80102ed9:	66 90                	xchg   %ax,%ax
80102edb:	66 90                	xchg   %ax,%ax
80102edd:	66 90                	xchg   %ax,%ax
80102edf:	90                   	nop

80102ee0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ee0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ee5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ee6:	a8 01                	test   $0x1,%al
80102ee8:	0f 84 c2 00 00 00    	je     80102fb0 <kbdgetc+0xd0>
80102eee:	ba 60 00 00 00       	mov    $0x60,%edx
80102ef3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102ef4:	0f b6 d0             	movzbl %al,%edx
80102ef7:	8b 0d d4 c5 10 80    	mov    0x8010c5d4,%ecx

  if(data == 0xE0){
80102efd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102f03:	0f 84 7f 00 00 00    	je     80102f88 <kbdgetc+0xa8>
{
80102f09:	55                   	push   %ebp
80102f0a:	89 e5                	mov    %esp,%ebp
80102f0c:	53                   	push   %ebx
80102f0d:	89 cb                	mov    %ecx,%ebx
80102f0f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f12:	84 c0                	test   %al,%al
80102f14:	78 4a                	js     80102f60 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f16:	85 db                	test   %ebx,%ebx
80102f18:	74 09                	je     80102f23 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f1a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f1d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102f20:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f23:	0f b6 82 60 93 10 80 	movzbl -0x7fef6ca0(%edx),%eax
80102f2a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f2c:	0f b6 82 60 92 10 80 	movzbl -0x7fef6da0(%edx),%eax
80102f33:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f35:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f37:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f3d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f40:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f43:	8b 04 85 40 92 10 80 	mov    -0x7fef6dc0(,%eax,4),%eax
80102f4a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102f4e:	74 31                	je     80102f81 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102f50:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f53:	83 fa 19             	cmp    $0x19,%edx
80102f56:	77 40                	ja     80102f98 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f58:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f5b:	5b                   	pop    %ebx
80102f5c:	5d                   	pop    %ebp
80102f5d:	c3                   	ret    
80102f5e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f60:	83 e0 7f             	and    $0x7f,%eax
80102f63:	85 db                	test   %ebx,%ebx
80102f65:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102f68:	0f b6 82 60 93 10 80 	movzbl -0x7fef6ca0(%edx),%eax
80102f6f:	83 c8 40             	or     $0x40,%eax
80102f72:	0f b6 c0             	movzbl %al,%eax
80102f75:	f7 d0                	not    %eax
80102f77:	21 c1                	and    %eax,%ecx
    return 0;
80102f79:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102f7b:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
}
80102f81:	5b                   	pop    %ebx
80102f82:	5d                   	pop    %ebp
80102f83:	c3                   	ret    
80102f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102f88:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102f8b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102f8d:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
    return 0;
80102f93:	c3                   	ret    
80102f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102f98:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102f9b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102f9e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102f9f:	83 f9 1a             	cmp    $0x1a,%ecx
80102fa2:	0f 42 c2             	cmovb  %edx,%eax
}
80102fa5:	5d                   	pop    %ebp
80102fa6:	c3                   	ret    
80102fa7:	89 f6                	mov    %esi,%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102fb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102fb5:	c3                   	ret    
80102fb6:	8d 76 00             	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <kbdintr>:

void
kbdintr(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102fc6:	68 e0 2e 10 80       	push   $0x80102ee0
80102fcb:	e8 40 d8 ff ff       	call   80100810 <consoleintr>
}
80102fd0:	83 c4 10             	add    $0x10,%esp
80102fd3:	c9                   	leave  
80102fd4:	c3                   	ret    
80102fd5:	66 90                	xchg   %ax,%ax
80102fd7:	66 90                	xchg   %ax,%ax
80102fd9:	66 90                	xchg   %ax,%ax
80102fdb:	66 90                	xchg   %ax,%ax
80102fdd:	66 90                	xchg   %ax,%ax
80102fdf:	90                   	nop

80102fe0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102fe0:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
{
80102fe5:	55                   	push   %ebp
80102fe6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	0f 84 c8 00 00 00    	je     801030b8 <lapicinit+0xd8>
  lapic[index] = value;
80102ff0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102ff7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ffa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ffd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103004:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103007:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010300a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103011:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103014:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103017:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010301e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103021:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103024:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010302b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010302e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103031:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103038:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010303b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010303e:	8b 50 30             	mov    0x30(%eax),%edx
80103041:	c1 ea 10             	shr    $0x10,%edx
80103044:	80 fa 03             	cmp    $0x3,%dl
80103047:	77 77                	ja     801030c0 <lapicinit+0xe0>
  lapic[index] = value;
80103049:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103050:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103053:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103056:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010305d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103060:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103063:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010306a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010306d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103070:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103077:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010307a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010307d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103084:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103087:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010308a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103091:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103094:	8b 50 20             	mov    0x20(%eax),%edx
80103097:	89 f6                	mov    %esi,%esi
80103099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801030a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801030a6:	80 e6 10             	and    $0x10,%dh
801030a9:	75 f5                	jne    801030a0 <lapicinit+0xc0>
  lapic[index] = value;
801030ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801030b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030b5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801030b8:	5d                   	pop    %ebp
801030b9:	c3                   	ret    
801030ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801030c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801030c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030ca:	8b 50 20             	mov    0x20(%eax),%edx
801030cd:	e9 77 ff ff ff       	jmp    80103049 <lapicinit+0x69>
801030d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801030e0:	8b 15 5c 5a 18 80    	mov    0x80185a5c,%edx
{
801030e6:	55                   	push   %ebp
801030e7:	31 c0                	xor    %eax,%eax
801030e9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801030eb:	85 d2                	test   %edx,%edx
801030ed:	74 06                	je     801030f5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801030ef:	8b 42 20             	mov    0x20(%edx),%eax
801030f2:	c1 e8 18             	shr    $0x18,%eax
}
801030f5:	5d                   	pop    %ebp
801030f6:	c3                   	ret    
801030f7:	89 f6                	mov    %esi,%esi
801030f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103100 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103100:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
{
80103105:	55                   	push   %ebp
80103106:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103108:	85 c0                	test   %eax,%eax
8010310a:	74 0d                	je     80103119 <lapiceoi+0x19>
  lapic[index] = value;
8010310c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103113:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103116:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103119:	5d                   	pop    %ebp
8010311a:	c3                   	ret    
8010311b:	90                   	nop
8010311c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103120 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103120:	55                   	push   %ebp
80103121:	89 e5                	mov    %esp,%ebp
}
80103123:	5d                   	pop    %ebp
80103124:	c3                   	ret    
80103125:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103130 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103130:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103131:	b8 0f 00 00 00       	mov    $0xf,%eax
80103136:	ba 70 00 00 00       	mov    $0x70,%edx
8010313b:	89 e5                	mov    %esp,%ebp
8010313d:	53                   	push   %ebx
8010313e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103141:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103144:	ee                   	out    %al,(%dx)
80103145:	b8 0a 00 00 00       	mov    $0xa,%eax
8010314a:	ba 71 00 00 00       	mov    $0x71,%edx
8010314f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103150:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103152:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103155:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010315b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010315d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103160:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103163:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103165:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103168:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010316e:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
80103173:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103179:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010317c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103183:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103186:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103189:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103190:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103193:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103196:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010319c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010319f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031a5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031b7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801031ba:	5b                   	pop    %ebx
801031bb:	5d                   	pop    %ebp
801031bc:	c3                   	ret    
801031bd:	8d 76 00             	lea    0x0(%esi),%esi

801031c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801031c0:	55                   	push   %ebp
801031c1:	b8 0b 00 00 00       	mov    $0xb,%eax
801031c6:	ba 70 00 00 00       	mov    $0x70,%edx
801031cb:	89 e5                	mov    %esp,%ebp
801031cd:	57                   	push   %edi
801031ce:	56                   	push   %esi
801031cf:	53                   	push   %ebx
801031d0:	83 ec 4c             	sub    $0x4c,%esp
801031d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031d4:	ba 71 00 00 00       	mov    $0x71,%edx
801031d9:	ec                   	in     (%dx),%al
801031da:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031dd:	bb 70 00 00 00       	mov    $0x70,%ebx
801031e2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801031e5:	8d 76 00             	lea    0x0(%esi),%esi
801031e8:	31 c0                	xor    %eax,%eax
801031ea:	89 da                	mov    %ebx,%edx
801031ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031ed:	b9 71 00 00 00       	mov    $0x71,%ecx
801031f2:	89 ca                	mov    %ecx,%edx
801031f4:	ec                   	in     (%dx),%al
801031f5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f8:	89 da                	mov    %ebx,%edx
801031fa:	b8 02 00 00 00       	mov    $0x2,%eax
801031ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103200:	89 ca                	mov    %ecx,%edx
80103202:	ec                   	in     (%dx),%al
80103203:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103206:	89 da                	mov    %ebx,%edx
80103208:	b8 04 00 00 00       	mov    $0x4,%eax
8010320d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010320e:	89 ca                	mov    %ecx,%edx
80103210:	ec                   	in     (%dx),%al
80103211:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103214:	89 da                	mov    %ebx,%edx
80103216:	b8 07 00 00 00       	mov    $0x7,%eax
8010321b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010321c:	89 ca                	mov    %ecx,%edx
8010321e:	ec                   	in     (%dx),%al
8010321f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103222:	89 da                	mov    %ebx,%edx
80103224:	b8 08 00 00 00       	mov    $0x8,%eax
80103229:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010322a:	89 ca                	mov    %ecx,%edx
8010322c:	ec                   	in     (%dx),%al
8010322d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010322f:	89 da                	mov    %ebx,%edx
80103231:	b8 09 00 00 00       	mov    $0x9,%eax
80103236:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103237:	89 ca                	mov    %ecx,%edx
80103239:	ec                   	in     (%dx),%al
8010323a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010323c:	89 da                	mov    %ebx,%edx
8010323e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103243:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103244:	89 ca                	mov    %ecx,%edx
80103246:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103247:	84 c0                	test   %al,%al
80103249:	78 9d                	js     801031e8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010324b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010324f:	89 fa                	mov    %edi,%edx
80103251:	0f b6 fa             	movzbl %dl,%edi
80103254:	89 f2                	mov    %esi,%edx
80103256:	0f b6 f2             	movzbl %dl,%esi
80103259:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325c:	89 da                	mov    %ebx,%edx
8010325e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103261:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103264:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103268:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010326b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010326f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103272:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103276:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103279:	31 c0                	xor    %eax,%eax
8010327b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010327c:	89 ca                	mov    %ecx,%edx
8010327e:	ec                   	in     (%dx),%al
8010327f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103282:	89 da                	mov    %ebx,%edx
80103284:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103287:	b8 02 00 00 00       	mov    $0x2,%eax
8010328c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010328d:	89 ca                	mov    %ecx,%edx
8010328f:	ec                   	in     (%dx),%al
80103290:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103293:	89 da                	mov    %ebx,%edx
80103295:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103298:	b8 04 00 00 00       	mov    $0x4,%eax
8010329d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010329e:	89 ca                	mov    %ecx,%edx
801032a0:	ec                   	in     (%dx),%al
801032a1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a4:	89 da                	mov    %ebx,%edx
801032a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801032a9:	b8 07 00 00 00       	mov    $0x7,%eax
801032ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032af:	89 ca                	mov    %ecx,%edx
801032b1:	ec                   	in     (%dx),%al
801032b2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b5:	89 da                	mov    %ebx,%edx
801032b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801032ba:	b8 08 00 00 00       	mov    $0x8,%eax
801032bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c0:	89 ca                	mov    %ecx,%edx
801032c2:	ec                   	in     (%dx),%al
801032c3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c6:	89 da                	mov    %ebx,%edx
801032c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801032cb:	b8 09 00 00 00       	mov    $0x9,%eax
801032d0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d1:	89 ca                	mov    %ecx,%edx
801032d3:	ec                   	in     (%dx),%al
801032d4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032d7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801032da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032dd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801032e0:	6a 18                	push   $0x18
801032e2:	50                   	push   %eax
801032e3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801032e6:	50                   	push   %eax
801032e7:	e8 74 20 00 00       	call   80105360 <memcmp>
801032ec:	83 c4 10             	add    $0x10,%esp
801032ef:	85 c0                	test   %eax,%eax
801032f1:	0f 85 f1 fe ff ff    	jne    801031e8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801032f7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801032fb:	75 78                	jne    80103375 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103300:	89 c2                	mov    %eax,%edx
80103302:	83 e0 0f             	and    $0xf,%eax
80103305:	c1 ea 04             	shr    $0x4,%edx
80103308:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010330b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010330e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103311:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103314:	89 c2                	mov    %eax,%edx
80103316:	83 e0 0f             	and    $0xf,%eax
80103319:	c1 ea 04             	shr    $0x4,%edx
8010331c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010331f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103322:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103325:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103328:	89 c2                	mov    %eax,%edx
8010332a:	83 e0 0f             	and    $0xf,%eax
8010332d:	c1 ea 04             	shr    $0x4,%edx
80103330:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103333:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103336:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103339:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010333c:	89 c2                	mov    %eax,%edx
8010333e:	83 e0 0f             	and    $0xf,%eax
80103341:	c1 ea 04             	shr    $0x4,%edx
80103344:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103347:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010334a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010334d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103350:	89 c2                	mov    %eax,%edx
80103352:	83 e0 0f             	and    $0xf,%eax
80103355:	c1 ea 04             	shr    $0x4,%edx
80103358:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010335b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010335e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103361:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103364:	89 c2                	mov    %eax,%edx
80103366:	83 e0 0f             	and    $0xf,%eax
80103369:	c1 ea 04             	shr    $0x4,%edx
8010336c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010336f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103372:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103375:	8b 75 08             	mov    0x8(%ebp),%esi
80103378:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010337b:	89 06                	mov    %eax,(%esi)
8010337d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103380:	89 46 04             	mov    %eax,0x4(%esi)
80103383:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103386:	89 46 08             	mov    %eax,0x8(%esi)
80103389:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010338c:	89 46 0c             	mov    %eax,0xc(%esi)
8010338f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103392:	89 46 10             	mov    %eax,0x10(%esi)
80103395:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103398:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010339b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801033a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033a5:	5b                   	pop    %ebx
801033a6:	5e                   	pop    %esi
801033a7:	5f                   	pop    %edi
801033a8:	5d                   	pop    %ebp
801033a9:	c3                   	ret    
801033aa:	66 90                	xchg   %ax,%ax
801033ac:	66 90                	xchg   %ax,%ax
801033ae:	66 90                	xchg   %ax,%ax

801033b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033b0:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
801033b6:	85 c9                	test   %ecx,%ecx
801033b8:	0f 8e 8a 00 00 00    	jle    80103448 <install_trans+0x98>
{
801033be:	55                   	push   %ebp
801033bf:	89 e5                	mov    %esp,%ebp
801033c1:	57                   	push   %edi
801033c2:	56                   	push   %esi
801033c3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801033c4:	31 db                	xor    %ebx,%ebx
{
801033c6:	83 ec 0c             	sub    $0xc,%esp
801033c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033d0:	a1 94 5a 18 80       	mov    0x80185a94,%eax
801033d5:	83 ec 08             	sub    $0x8,%esp
801033d8:	01 d8                	add    %ebx,%eax
801033da:	83 c0 01             	add    $0x1,%eax
801033dd:	50                   	push   %eax
801033de:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
801033e4:	e8 e7 cc ff ff       	call   801000d0 <bread>
801033e9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033eb:	58                   	pop    %eax
801033ec:	5a                   	pop    %edx
801033ed:	ff 34 9d ac 5a 18 80 	pushl  -0x7fe7a554(,%ebx,4)
801033f4:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
  for (tail = 0; tail < log.lh.n; tail++) {
801033fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033fd:	e8 ce cc ff ff       	call   801000d0 <bread>
80103402:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103404:	8d 47 5c             	lea    0x5c(%edi),%eax
80103407:	83 c4 0c             	add    $0xc,%esp
8010340a:	68 00 02 00 00       	push   $0x200
8010340f:	50                   	push   %eax
80103410:	8d 46 5c             	lea    0x5c(%esi),%eax
80103413:	50                   	push   %eax
80103414:	e8 a7 1f 00 00       	call   801053c0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103419:	89 34 24             	mov    %esi,(%esp)
8010341c:	e8 7f cd ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103421:	89 3c 24             	mov    %edi,(%esp)
80103424:	e8 b7 cd ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103429:	89 34 24             	mov    %esi,(%esp)
8010342c:	e8 af cd ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103431:	83 c4 10             	add    $0x10,%esp
80103434:	39 1d a8 5a 18 80    	cmp    %ebx,0x80185aa8
8010343a:	7f 94                	jg     801033d0 <install_trans+0x20>
  }
}
8010343c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010343f:	5b                   	pop    %ebx
80103440:	5e                   	pop    %esi
80103441:	5f                   	pop    %edi
80103442:	5d                   	pop    %ebp
80103443:	c3                   	ret    
80103444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103448:	f3 c3                	repz ret 
8010344a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103450 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	56                   	push   %esi
80103454:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103455:	83 ec 08             	sub    $0x8,%esp
80103458:	ff 35 94 5a 18 80    	pushl  0x80185a94
8010345e:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
80103464:	e8 67 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103469:	8b 1d a8 5a 18 80    	mov    0x80185aa8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010346f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103472:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103474:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103476:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103479:	7e 16                	jle    80103491 <write_head+0x41>
8010347b:	c1 e3 02             	shl    $0x2,%ebx
8010347e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103480:	8b 8a ac 5a 18 80    	mov    -0x7fe7a554(%edx),%ecx
80103486:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010348a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010348d:	39 da                	cmp    %ebx,%edx
8010348f:	75 ef                	jne    80103480 <write_head+0x30>
  }
  bwrite(buf);
80103491:	83 ec 0c             	sub    $0xc,%esp
80103494:	56                   	push   %esi
80103495:	e8 06 cd ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010349a:	89 34 24             	mov    %esi,(%esp)
8010349d:	e8 3e cd ff ff       	call   801001e0 <brelse>
}
801034a2:	83 c4 10             	add    $0x10,%esp
801034a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a8:	5b                   	pop    %ebx
801034a9:	5e                   	pop    %esi
801034aa:	5d                   	pop    %ebp
801034ab:	c3                   	ret    
801034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034b0 <initlog>:
{
801034b0:	55                   	push   %ebp
801034b1:	89 e5                	mov    %esp,%ebp
801034b3:	53                   	push   %ebx
801034b4:	83 ec 2c             	sub    $0x2c,%esp
801034b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801034ba:	68 60 94 10 80       	push   $0x80109460
801034bf:	68 60 5a 18 80       	push   $0x80185a60
801034c4:	e8 f7 1b 00 00       	call   801050c0 <initlock>
  readsb(dev, &sb);
801034c9:	58                   	pop    %eax
801034ca:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034cd:	5a                   	pop    %edx
801034ce:	50                   	push   %eax
801034cf:	53                   	push   %ebx
801034d0:	e8 1b e3 ff ff       	call   801017f0 <readsb>
  log.size = sb.nlog;
801034d5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801034d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801034db:	59                   	pop    %ecx
  log.dev = dev;
801034dc:	89 1d a4 5a 18 80    	mov    %ebx,0x80185aa4
  log.size = sb.nlog;
801034e2:	89 15 98 5a 18 80    	mov    %edx,0x80185a98
  log.start = sb.logstart;
801034e8:	a3 94 5a 18 80       	mov    %eax,0x80185a94
  struct buf *buf = bread(log.dev, log.start);
801034ed:	5a                   	pop    %edx
801034ee:	50                   	push   %eax
801034ef:	53                   	push   %ebx
801034f0:	e8 db cb ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
801034f5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
801034f8:	83 c4 10             	add    $0x10,%esp
801034fb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
801034fd:	89 1d a8 5a 18 80    	mov    %ebx,0x80185aa8
  for (i = 0; i < log.lh.n; i++) {
80103503:	7e 1c                	jle    80103521 <initlog+0x71>
80103505:	c1 e3 02             	shl    $0x2,%ebx
80103508:	31 d2                	xor    %edx,%edx
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103510:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103514:	83 c2 04             	add    $0x4,%edx
80103517:	89 8a a8 5a 18 80    	mov    %ecx,-0x7fe7a558(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010351d:	39 d3                	cmp    %edx,%ebx
8010351f:	75 ef                	jne    80103510 <initlog+0x60>
  brelse(buf);
80103521:	83 ec 0c             	sub    $0xc,%esp
80103524:	50                   	push   %eax
80103525:	e8 b6 cc ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010352a:	e8 81 fe ff ff       	call   801033b0 <install_trans>
  log.lh.n = 0;
8010352f:	c7 05 a8 5a 18 80 00 	movl   $0x0,0x80185aa8
80103536:	00 00 00 
  write_head(); // clear the log
80103539:	e8 12 ff ff ff       	call   80103450 <write_head>
}
8010353e:	83 c4 10             	add    $0x10,%esp
80103541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103544:	c9                   	leave  
80103545:	c3                   	ret    
80103546:	8d 76 00             	lea    0x0(%esi),%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103550 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103550:	55                   	push   %ebp
80103551:	89 e5                	mov    %esp,%ebp
80103553:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103556:	68 60 5a 18 80       	push   $0x80185a60
8010355b:	e8 a0 1c 00 00       	call   80105200 <acquire>
80103560:	83 c4 10             	add    $0x10,%esp
80103563:	eb 18                	jmp    8010357d <begin_op+0x2d>
80103565:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103568:	83 ec 08             	sub    $0x8,%esp
8010356b:	68 60 5a 18 80       	push   $0x80185a60
80103570:	68 60 5a 18 80       	push   $0x80185a60
80103575:	e8 36 15 00 00       	call   80104ab0 <sleep>
8010357a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010357d:	a1 a0 5a 18 80       	mov    0x80185aa0,%eax
80103582:	85 c0                	test   %eax,%eax
80103584:	75 e2                	jne    80103568 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103586:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
8010358b:	8b 15 a8 5a 18 80    	mov    0x80185aa8,%edx
80103591:	83 c0 01             	add    $0x1,%eax
80103594:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103597:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010359a:	83 fa 1e             	cmp    $0x1e,%edx
8010359d:	7f c9                	jg     80103568 <begin_op+0x18>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010359f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801035a2:	a3 9c 5a 18 80       	mov    %eax,0x80185a9c
      release(&log.lock);
801035a7:	68 60 5a 18 80       	push   $0x80185a60
801035ac:	e8 0f 1d 00 00       	call   801052c0 <release>
      break;
    }
  }
}
801035b1:	83 c4 10             	add    $0x10,%esp
801035b4:	c9                   	leave  
801035b5:	c3                   	ret    
801035b6:	8d 76 00             	lea    0x0(%esi),%esi
801035b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035c0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	57                   	push   %edi
801035c4:	56                   	push   %esi
801035c5:	53                   	push   %ebx
801035c6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801035c9:	68 60 5a 18 80       	push   $0x80185a60
801035ce:	e8 2d 1c 00 00       	call   80105200 <acquire>
  log.outstanding -= 1;
801035d3:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
  if(log.committing)
801035d8:	8b 35 a0 5a 18 80    	mov    0x80185aa0,%esi
801035de:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035e1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801035e4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801035e6:	89 1d 9c 5a 18 80    	mov    %ebx,0x80185a9c
  if(log.committing)
801035ec:	0f 85 1a 01 00 00    	jne    8010370c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801035f2:	85 db                	test   %ebx,%ebx
801035f4:	0f 85 ee 00 00 00    	jne    801036e8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801035fa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801035fd:	c7 05 a0 5a 18 80 01 	movl   $0x1,0x80185aa0
80103604:	00 00 00 
  release(&log.lock);
80103607:	68 60 5a 18 80       	push   $0x80185a60
8010360c:	e8 af 1c 00 00       	call   801052c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103611:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
80103617:	83 c4 10             	add    $0x10,%esp
8010361a:	85 c9                	test   %ecx,%ecx
8010361c:	0f 8e 85 00 00 00    	jle    801036a7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103622:	a1 94 5a 18 80       	mov    0x80185a94,%eax
80103627:	83 ec 08             	sub    $0x8,%esp
8010362a:	01 d8                	add    %ebx,%eax
8010362c:	83 c0 01             	add    $0x1,%eax
8010362f:	50                   	push   %eax
80103630:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
80103636:	e8 95 ca ff ff       	call   801000d0 <bread>
8010363b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010363d:	58                   	pop    %eax
8010363e:	5a                   	pop    %edx
8010363f:	ff 34 9d ac 5a 18 80 	pushl  -0x7fe7a554(,%ebx,4)
80103646:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
  for (tail = 0; tail < log.lh.n; tail++) {
8010364c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010364f:	e8 7c ca ff ff       	call   801000d0 <bread>
80103654:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103656:	8d 40 5c             	lea    0x5c(%eax),%eax
80103659:	83 c4 0c             	add    $0xc,%esp
8010365c:	68 00 02 00 00       	push   $0x200
80103661:	50                   	push   %eax
80103662:	8d 46 5c             	lea    0x5c(%esi),%eax
80103665:	50                   	push   %eax
80103666:	e8 55 1d 00 00       	call   801053c0 <memmove>
    bwrite(to);  // write the log
8010366b:	89 34 24             	mov    %esi,(%esp)
8010366e:	e8 2d cb ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103673:	89 3c 24             	mov    %edi,(%esp)
80103676:	e8 65 cb ff ff       	call   801001e0 <brelse>
    brelse(to);
8010367b:	89 34 24             	mov    %esi,(%esp)
8010367e:	e8 5d cb ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103683:	83 c4 10             	add    $0x10,%esp
80103686:	3b 1d a8 5a 18 80    	cmp    0x80185aa8,%ebx
8010368c:	7c 94                	jl     80103622 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010368e:	e8 bd fd ff ff       	call   80103450 <write_head>
    install_trans(); // Now install writes to home locations
80103693:	e8 18 fd ff ff       	call   801033b0 <install_trans>
    log.lh.n = 0;
80103698:	c7 05 a8 5a 18 80 00 	movl   $0x0,0x80185aa8
8010369f:	00 00 00 
    write_head();    // Erase the transaction from the log
801036a2:	e8 a9 fd ff ff       	call   80103450 <write_head>
    acquire(&log.lock);
801036a7:	83 ec 0c             	sub    $0xc,%esp
801036aa:	68 60 5a 18 80       	push   $0x80185a60
801036af:	e8 4c 1b 00 00       	call   80105200 <acquire>
    wakeup(&log);
801036b4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036bb:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036c2:	00 00 00 
    wakeup(&log);
801036c5:	e8 26 16 00 00       	call   80104cf0 <wakeup>
    release(&log.lock);
801036ca:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036d1:	e8 ea 1b 00 00       	call   801052c0 <release>
801036d6:	83 c4 10             	add    $0x10,%esp
}
801036d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801036e8:	83 ec 0c             	sub    $0xc,%esp
801036eb:	68 60 5a 18 80       	push   $0x80185a60
801036f0:	e8 fb 15 00 00       	call   80104cf0 <wakeup>
  release(&log.lock);
801036f5:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036fc:	e8 bf 1b 00 00       	call   801052c0 <release>
80103701:	83 c4 10             	add    $0x10,%esp
}
80103704:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103707:	5b                   	pop    %ebx
80103708:	5e                   	pop    %esi
80103709:	5f                   	pop    %edi
8010370a:	5d                   	pop    %ebp
8010370b:	c3                   	ret    
    panic("log.committing");
8010370c:	83 ec 0c             	sub    $0xc,%esp
8010370f:	68 64 94 10 80       	push   $0x80109464
80103714:	e8 77 cc ff ff       	call   80100390 <panic>
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103720 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	53                   	push   %ebx
80103724:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103727:	8b 15 a8 5a 18 80    	mov    0x80185aa8,%edx
{
8010372d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103730:	83 fa 1d             	cmp    $0x1d,%edx
80103733:	0f 8f 9d 00 00 00    	jg     801037d6 <log_write+0xb6>
80103739:	a1 98 5a 18 80       	mov    0x80185a98,%eax
8010373e:	83 e8 01             	sub    $0x1,%eax
80103741:	39 c2                	cmp    %eax,%edx
80103743:	0f 8d 8d 00 00 00    	jge    801037d6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103749:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
8010374e:	85 c0                	test   %eax,%eax
80103750:	0f 8e 8d 00 00 00    	jle    801037e3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103756:	83 ec 0c             	sub    $0xc,%esp
80103759:	68 60 5a 18 80       	push   $0x80185a60
8010375e:	e8 9d 1a 00 00       	call   80105200 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103763:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
80103769:	83 c4 10             	add    $0x10,%esp
8010376c:	83 f9 00             	cmp    $0x0,%ecx
8010376f:	7e 57                	jle    801037c8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103771:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103774:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103776:	3b 15 ac 5a 18 80    	cmp    0x80185aac,%edx
8010377c:	75 0b                	jne    80103789 <log_write+0x69>
8010377e:	eb 38                	jmp    801037b8 <log_write+0x98>
80103780:	39 14 85 ac 5a 18 80 	cmp    %edx,-0x7fe7a554(,%eax,4)
80103787:	74 2f                	je     801037b8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103789:	83 c0 01             	add    $0x1,%eax
8010378c:	39 c1                	cmp    %eax,%ecx
8010378e:	75 f0                	jne    80103780 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103790:	89 14 85 ac 5a 18 80 	mov    %edx,-0x7fe7a554(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103797:	83 c0 01             	add    $0x1,%eax
8010379a:	a3 a8 5a 18 80       	mov    %eax,0x80185aa8
  b->flags |= B_DIRTY; // prevent eviction
8010379f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801037a2:	c7 45 08 60 5a 18 80 	movl   $0x80185a60,0x8(%ebp)
}
801037a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037ac:	c9                   	leave  
  release(&log.lock);
801037ad:	e9 0e 1b 00 00       	jmp    801052c0 <release>
801037b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801037b8:	89 14 85 ac 5a 18 80 	mov    %edx,-0x7fe7a554(,%eax,4)
801037bf:	eb de                	jmp    8010379f <log_write+0x7f>
801037c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037c8:	8b 43 08             	mov    0x8(%ebx),%eax
801037cb:	a3 ac 5a 18 80       	mov    %eax,0x80185aac
  if (i == log.lh.n)
801037d0:	75 cd                	jne    8010379f <log_write+0x7f>
801037d2:	31 c0                	xor    %eax,%eax
801037d4:	eb c1                	jmp    80103797 <log_write+0x77>
    panic("too big a transaction");
801037d6:	83 ec 0c             	sub    $0xc,%esp
801037d9:	68 73 94 10 80       	push   $0x80109473
801037de:	e8 ad cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037e3:	83 ec 0c             	sub    $0xc,%esp
801037e6:	68 89 94 10 80       	push   $0x80109489
801037eb:	e8 a0 cb ff ff       	call   80100390 <panic>

801037f0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
801037f4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801037f7:	e8 a4 0a 00 00       	call   801042a0 <cpuid>
801037fc:	89 c3                	mov    %eax,%ebx
801037fe:	e8 9d 0a 00 00       	call   801042a0 <cpuid>
80103803:	83 ec 04             	sub    $0x4,%esp
80103806:	53                   	push   %ebx
80103807:	50                   	push   %eax
80103808:	68 a4 94 10 80       	push   $0x801094a4
8010380d:	e8 4e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103812:	e8 e9 2d 00 00       	call   80106600 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103817:	e8 04 0a 00 00       	call   80104220 <mycpu>
8010381c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010381e:	b8 01 00 00 00       	mov    $0x1,%eax
80103823:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010382a:	e8 71 0f 00 00       	call   801047a0 <scheduler>
8010382f:	90                   	nop

80103830 <mpenter>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103836:	e8 65 3f 00 00       	call   801077a0 <switchkvm>
  seginit();
8010383b:	e8 d0 3e 00 00       	call   80107710 <seginit>
  lapicinit();
80103840:	e8 9b f7 ff ff       	call   80102fe0 <lapicinit>
  mpmain();
80103845:	e8 a6 ff ff ff       	call   801037f0 <mpmain>
8010384a:	66 90                	xchg   %ax,%ax
8010384c:	66 90                	xchg   %ax,%ax
8010384e:	66 90                	xchg   %ax,%ax

80103850 <main>:
{
80103850:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103854:	83 e4 f0             	and    $0xfffffff0,%esp
80103857:	ff 71 fc             	pushl  -0x4(%ecx)
8010385a:	55                   	push   %ebp
8010385b:	89 e5                	mov    %esp,%ebp
8010385d:	53                   	push   %ebx
8010385e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010385f:	83 ec 08             	sub    $0x8,%esp
80103862:	68 00 00 40 80       	push   $0x80400000
80103867:	68 88 75 19 80       	push   $0x80197588
8010386c:	e8 ef f3 ff ff       	call   80102c60 <kinit1>
  kvmalloc();      // kernel page table
80103871:	e8 7a 48 00 00       	call   801080f0 <kvmalloc>
  mpinit();        // detect other processors
80103876:	e8 75 01 00 00       	call   801039f0 <mpinit>
  lapicinit();     // interrupt controller
8010387b:	e8 60 f7 ff ff       	call   80102fe0 <lapicinit>
  seginit();       // segment descriptors
80103880:	e8 8b 3e 00 00       	call   80107710 <seginit>
  picinit();       // disable pic
80103885:	e8 46 03 00 00       	call   80103bd0 <picinit>
  ioapicinit();    // another interrupt controller
8010388a:	e8 d1 f0 ff ff       	call   80102960 <ioapicinit>
  consoleinit();   // console hardware
8010388f:	e8 2c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103894:	e8 a7 30 00 00       	call   80106940 <uartinit>
  pinit();         // process table
80103899:	e8 62 09 00 00       	call   80104200 <pinit>
  tvinit();        // trap vectors
8010389e:	e8 dd 2c 00 00       	call   80106580 <tvinit>
  binit();         // buffer cache
801038a3:	e8 98 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801038a8:	e8 63 d8 ff ff       	call   80101110 <fileinit>
  ideinit();       // disk 
801038ad:	e8 8e ee ff ff       	call   80102740 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038b2:	83 c4 0c             	add    $0xc,%esp
801038b5:	68 8a 00 00 00       	push   $0x8a
801038ba:	68 8c c4 10 80       	push   $0x8010c48c
801038bf:	68 00 70 00 80       	push   $0x80007000
801038c4:	e8 f7 1a 00 00       	call   801053c0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038c9:	69 05 e0 60 18 80 b0 	imul   $0xb0,0x801860e0,%eax
801038d0:	00 00 00 
801038d3:	83 c4 10             	add    $0x10,%esp
801038d6:	05 60 5b 18 80       	add    $0x80185b60,%eax
801038db:	3d 60 5b 18 80       	cmp    $0x80185b60,%eax
801038e0:	76 71                	jbe    80103953 <main+0x103>
801038e2:	bb 60 5b 18 80       	mov    $0x80185b60,%ebx
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801038f0:	e8 2b 09 00 00       	call   80104220 <mycpu>
801038f5:	39 d8                	cmp    %ebx,%eax
801038f7:	74 41                	je     8010393a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038f9:	e8 32 f4 ff ff       	call   80102d30 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801038fe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103903:	c7 05 f8 6f 00 80 30 	movl   $0x80103830,0x80006ff8
8010390a:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010390d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103914:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103917:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010391c:	0f b6 03             	movzbl (%ebx),%eax
8010391f:	83 ec 08             	sub    $0x8,%esp
80103922:	68 00 70 00 00       	push   $0x7000
80103927:	50                   	push   %eax
80103928:	e8 03 f8 ff ff       	call   80103130 <lapicstartap>
8010392d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103930:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103936:	85 c0                	test   %eax,%eax
80103938:	74 f6                	je     80103930 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010393a:	69 05 e0 60 18 80 b0 	imul   $0xb0,0x801860e0,%eax
80103941:	00 00 00 
80103944:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010394a:	05 60 5b 18 80       	add    $0x80185b60,%eax
8010394f:	39 c3                	cmp    %eax,%ebx
80103951:	72 9d                	jb     801038f0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103953:	83 ec 08             	sub    $0x8,%esp
80103956:	68 00 00 00 8e       	push   $0x8e000000
8010395b:	68 00 00 40 80       	push   $0x80400000
80103960:	e8 6b f3 ff ff       	call   80102cd0 <kinit2>
  userinit();      // first user process
80103965:	e8 86 09 00 00       	call   801042f0 <userinit>
  mpmain();        // finish this processor's setup
8010396a:	e8 81 fe ff ff       	call   801037f0 <mpmain>
8010396f:	90                   	nop

80103970 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	57                   	push   %edi
80103974:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103975:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010397b:	53                   	push   %ebx
  e = addr+len;
8010397c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010397f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103982:	39 de                	cmp    %ebx,%esi
80103984:	72 10                	jb     80103996 <mpsearch1+0x26>
80103986:	eb 50                	jmp    801039d8 <mpsearch1+0x68>
80103988:	90                   	nop
80103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103990:	39 fb                	cmp    %edi,%ebx
80103992:	89 fe                	mov    %edi,%esi
80103994:	76 42                	jbe    801039d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103996:	83 ec 04             	sub    $0x4,%esp
80103999:	8d 7e 10             	lea    0x10(%esi),%edi
8010399c:	6a 04                	push   $0x4
8010399e:	68 b8 94 10 80       	push   $0x801094b8
801039a3:	56                   	push   %esi
801039a4:	e8 b7 19 00 00       	call   80105360 <memcmp>
801039a9:	83 c4 10             	add    $0x10,%esp
801039ac:	85 c0                	test   %eax,%eax
801039ae:	75 e0                	jne    80103990 <mpsearch1+0x20>
801039b0:	89 f1                	mov    %esi,%ecx
801039b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801039b8:	0f b6 11             	movzbl (%ecx),%edx
801039bb:	83 c1 01             	add    $0x1,%ecx
801039be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801039c0:	39 f9                	cmp    %edi,%ecx
801039c2:	75 f4                	jne    801039b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039c4:	84 c0                	test   %al,%al
801039c6:	75 c8                	jne    80103990 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801039c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039cb:	89 f0                	mov    %esi,%eax
801039cd:	5b                   	pop    %ebx
801039ce:	5e                   	pop    %esi
801039cf:	5f                   	pop    %edi
801039d0:	5d                   	pop    %ebp
801039d1:	c3                   	ret    
801039d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039db:	31 f6                	xor    %esi,%esi
}
801039dd:	89 f0                	mov    %esi,%eax
801039df:	5b                   	pop    %ebx
801039e0:	5e                   	pop    %esi
801039e1:	5f                   	pop    %edi
801039e2:	5d                   	pop    %ebp
801039e3:	c3                   	ret    
801039e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801039f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103a00:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103a07:	c1 e0 08             	shl    $0x8,%eax
80103a0a:	09 d0                	or     %edx,%eax
80103a0c:	c1 e0 04             	shl    $0x4,%eax
80103a0f:	85 c0                	test   %eax,%eax
80103a11:	75 1b                	jne    80103a2e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a13:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a1a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a21:	c1 e0 08             	shl    $0x8,%eax
80103a24:	09 d0                	or     %edx,%eax
80103a26:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a29:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a2e:	ba 00 04 00 00       	mov    $0x400,%edx
80103a33:	e8 38 ff ff ff       	call   80103970 <mpsearch1>
80103a38:	85 c0                	test   %eax,%eax
80103a3a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a3d:	0f 84 3d 01 00 00    	je     80103b80 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a46:	8b 58 04             	mov    0x4(%eax),%ebx
80103a49:	85 db                	test   %ebx,%ebx
80103a4b:	0f 84 4f 01 00 00    	je     80103ba0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a51:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103a57:	83 ec 04             	sub    $0x4,%esp
80103a5a:	6a 04                	push   $0x4
80103a5c:	68 d5 94 10 80       	push   $0x801094d5
80103a61:	56                   	push   %esi
80103a62:	e8 f9 18 00 00       	call   80105360 <memcmp>
80103a67:	83 c4 10             	add    $0x10,%esp
80103a6a:	85 c0                	test   %eax,%eax
80103a6c:	0f 85 2e 01 00 00    	jne    80103ba0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103a72:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103a79:	3c 01                	cmp    $0x1,%al
80103a7b:	0f 95 c2             	setne  %dl
80103a7e:	3c 04                	cmp    $0x4,%al
80103a80:	0f 95 c0             	setne  %al
80103a83:	20 c2                	and    %al,%dl
80103a85:	0f 85 15 01 00 00    	jne    80103ba0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a8b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103a92:	66 85 ff             	test   %di,%di
80103a95:	74 1a                	je     80103ab1 <mpinit+0xc1>
80103a97:	89 f0                	mov    %esi,%eax
80103a99:	01 f7                	add    %esi,%edi
  sum = 0;
80103a9b:	31 d2                	xor    %edx,%edx
80103a9d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103aa0:	0f b6 08             	movzbl (%eax),%ecx
80103aa3:	83 c0 01             	add    $0x1,%eax
80103aa6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103aa8:	39 c7                	cmp    %eax,%edi
80103aaa:	75 f4                	jne    80103aa0 <mpinit+0xb0>
80103aac:	84 d2                	test   %dl,%dl
80103aae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103ab1:	85 f6                	test   %esi,%esi
80103ab3:	0f 84 e7 00 00 00    	je     80103ba0 <mpinit+0x1b0>
80103ab9:	84 d2                	test   %dl,%dl
80103abb:	0f 85 df 00 00 00    	jne    80103ba0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103ac1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103ac7:	a3 5c 5a 18 80       	mov    %eax,0x80185a5c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103acc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103ad3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103ad9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ade:	01 d6                	add    %edx,%esi
80103ae0:	39 c6                	cmp    %eax,%esi
80103ae2:	76 23                	jbe    80103b07 <mpinit+0x117>
    switch(*p){
80103ae4:	0f b6 10             	movzbl (%eax),%edx
80103ae7:	80 fa 04             	cmp    $0x4,%dl
80103aea:	0f 87 ca 00 00 00    	ja     80103bba <mpinit+0x1ca>
80103af0:	ff 24 95 fc 94 10 80 	jmp    *-0x7fef6b04(,%edx,4)
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b00:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b03:	39 c6                	cmp    %eax,%esi
80103b05:	77 dd                	ja     80103ae4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b07:	85 db                	test   %ebx,%ebx
80103b09:	0f 84 9e 00 00 00    	je     80103bad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103b0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b12:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103b16:	74 15                	je     80103b2d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b18:	b8 70 00 00 00       	mov    $0x70,%eax
80103b1d:	ba 22 00 00 00       	mov    $0x22,%edx
80103b22:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b23:	ba 23 00 00 00       	mov    $0x23,%edx
80103b28:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b29:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b2c:	ee                   	out    %al,(%dx)
  }
}
80103b2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b30:	5b                   	pop    %ebx
80103b31:	5e                   	pop    %esi
80103b32:	5f                   	pop    %edi
80103b33:	5d                   	pop    %ebp
80103b34:	c3                   	ret    
80103b35:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103b38:	8b 0d e0 60 18 80    	mov    0x801860e0,%ecx
80103b3e:	83 f9 07             	cmp    $0x7,%ecx
80103b41:	7f 19                	jg     80103b5c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b43:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103b47:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103b4d:	83 c1 01             	add    $0x1,%ecx
80103b50:	89 0d e0 60 18 80    	mov    %ecx,0x801860e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b56:	88 97 60 5b 18 80    	mov    %dl,-0x7fe7a4a0(%edi)
      p += sizeof(struct mpproc);
80103b5c:	83 c0 14             	add    $0x14,%eax
      continue;
80103b5f:	e9 7c ff ff ff       	jmp    80103ae0 <mpinit+0xf0>
80103b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b68:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103b6c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b6f:	88 15 40 5b 18 80    	mov    %dl,0x80185b40
      continue;
80103b75:	e9 66 ff ff ff       	jmp    80103ae0 <mpinit+0xf0>
80103b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103b80:	ba 00 00 01 00       	mov    $0x10000,%edx
80103b85:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103b8a:	e8 e1 fd ff ff       	call   80103970 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b8f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103b91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b94:	0f 85 a9 fe ff ff    	jne    80103a43 <mpinit+0x53>
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 bd 94 10 80       	push   $0x801094bd
80103ba8:	e8 e3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bad:	83 ec 0c             	sub    $0xc,%esp
80103bb0:	68 dc 94 10 80       	push   $0x801094dc
80103bb5:	e8 d6 c7 ff ff       	call   80100390 <panic>
      ismp = 0;
80103bba:	31 db                	xor    %ebx,%ebx
80103bbc:	e9 26 ff ff ff       	jmp    80103ae7 <mpinit+0xf7>
80103bc1:	66 90                	xchg   %ax,%ax
80103bc3:	66 90                	xchg   %ax,%ax
80103bc5:	66 90                	xchg   %ax,%ax
80103bc7:	66 90                	xchg   %ax,%ax
80103bc9:	66 90                	xchg   %ax,%ax
80103bcb:	66 90                	xchg   %ax,%ax
80103bcd:	66 90                	xchg   %ax,%ax
80103bcf:	90                   	nop

80103bd0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bd6:	ba 21 00 00 00       	mov    $0x21,%edx
80103bdb:	89 e5                	mov    %esp,%ebp
80103bdd:	ee                   	out    %al,(%dx)
80103bde:	ba a1 00 00 00       	mov    $0xa1,%edx
80103be3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103be4:	5d                   	pop    %ebp
80103be5:	c3                   	ret    
80103be6:	66 90                	xchg   %ax,%ax
80103be8:	66 90                	xchg   %ax,%ax
80103bea:	66 90                	xchg   %ax,%ax
80103bec:	66 90                	xchg   %ax,%ax
80103bee:	66 90                	xchg   %ax,%ax

80103bf0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	57                   	push   %edi
80103bf4:	56                   	push   %esi
80103bf5:	53                   	push   %ebx
80103bf6:	83 ec 0c             	sub    $0xc,%esp
80103bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bfc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103bff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103c05:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c0b:	e8 20 d5 ff ff       	call   80101130 <filealloc>
80103c10:	85 c0                	test   %eax,%eax
80103c12:	89 03                	mov    %eax,(%ebx)
80103c14:	74 22                	je     80103c38 <pipealloc+0x48>
80103c16:	e8 15 d5 ff ff       	call   80101130 <filealloc>
80103c1b:	85 c0                	test   %eax,%eax
80103c1d:	89 06                	mov    %eax,(%esi)
80103c1f:	74 3f                	je     80103c60 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c21:	e8 0a f1 ff ff       	call   80102d30 <kalloc>
80103c26:	85 c0                	test   %eax,%eax
80103c28:	89 c7                	mov    %eax,%edi
80103c2a:	75 54                	jne    80103c80 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103c2c:	8b 03                	mov    (%ebx),%eax
80103c2e:	85 c0                	test   %eax,%eax
80103c30:	75 34                	jne    80103c66 <pipealloc+0x76>
80103c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103c38:	8b 06                	mov    (%esi),%eax
80103c3a:	85 c0                	test   %eax,%eax
80103c3c:	74 0c                	je     80103c4a <pipealloc+0x5a>
    fileclose(*f1);
80103c3e:	83 ec 0c             	sub    $0xc,%esp
80103c41:	50                   	push   %eax
80103c42:	e8 a9 d5 ff ff       	call   801011f0 <fileclose>
80103c47:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103c4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c52:	5b                   	pop    %ebx
80103c53:	5e                   	pop    %esi
80103c54:	5f                   	pop    %edi
80103c55:	5d                   	pop    %ebp
80103c56:	c3                   	ret    
80103c57:	89 f6                	mov    %esi,%esi
80103c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103c60:	8b 03                	mov    (%ebx),%eax
80103c62:	85 c0                	test   %eax,%eax
80103c64:	74 e4                	je     80103c4a <pipealloc+0x5a>
    fileclose(*f0);
80103c66:	83 ec 0c             	sub    $0xc,%esp
80103c69:	50                   	push   %eax
80103c6a:	e8 81 d5 ff ff       	call   801011f0 <fileclose>
  if(*f1)
80103c6f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103c71:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103c74:	85 c0                	test   %eax,%eax
80103c76:	75 c6                	jne    80103c3e <pipealloc+0x4e>
80103c78:	eb d0                	jmp    80103c4a <pipealloc+0x5a>
80103c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103c80:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103c83:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c8a:	00 00 00 
  p->writeopen = 1;
80103c8d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c94:	00 00 00 
  p->nwrite = 0;
80103c97:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c9e:	00 00 00 
  p->nread = 0;
80103ca1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ca8:	00 00 00 
  initlock(&p->lock, "pipe");
80103cab:	68 10 95 10 80       	push   $0x80109510
80103cb0:	50                   	push   %eax
80103cb1:	e8 0a 14 00 00       	call   801050c0 <initlock>
  (*f0)->type = FD_PIPE;
80103cb6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103cb8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cbb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cc1:	8b 03                	mov    (%ebx),%eax
80103cc3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cc7:	8b 03                	mov    (%ebx),%eax
80103cc9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103ccd:	8b 03                	mov    (%ebx),%eax
80103ccf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cd2:	8b 06                	mov    (%esi),%eax
80103cd4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cda:	8b 06                	mov    (%esi),%eax
80103cdc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103ce0:	8b 06                	mov    (%esi),%eax
80103ce2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103ce6:	8b 06                	mov    (%esi),%eax
80103ce8:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103ceb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103cee:	31 c0                	xor    %eax,%eax
}
80103cf0:	5b                   	pop    %ebx
80103cf1:	5e                   	pop    %esi
80103cf2:	5f                   	pop    %edi
80103cf3:	5d                   	pop    %ebp
80103cf4:	c3                   	ret    
80103cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	56                   	push   %esi
80103d04:	53                   	push   %ebx
80103d05:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d08:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103d0b:	83 ec 0c             	sub    $0xc,%esp
80103d0e:	53                   	push   %ebx
80103d0f:	e8 ec 14 00 00       	call   80105200 <acquire>
  if(writable){
80103d14:	83 c4 10             	add    $0x10,%esp
80103d17:	85 f6                	test   %esi,%esi
80103d19:	74 45                	je     80103d60 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d1b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d21:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103d24:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d2b:	00 00 00 
    wakeup(&p->nread);
80103d2e:	50                   	push   %eax
80103d2f:	e8 bc 0f 00 00       	call   80104cf0 <wakeup>
80103d34:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d37:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d3d:	85 d2                	test   %edx,%edx
80103d3f:	75 0a                	jne    80103d4b <pipeclose+0x4b>
80103d41:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d47:	85 c0                	test   %eax,%eax
80103d49:	74 35                	je     80103d80 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103d4b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d4e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d51:	5b                   	pop    %ebx
80103d52:	5e                   	pop    %esi
80103d53:	5d                   	pop    %ebp
    release(&p->lock);
80103d54:	e9 67 15 00 00       	jmp    801052c0 <release>
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d60:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d66:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d70:	00 00 00 
    wakeup(&p->nwrite);
80103d73:	50                   	push   %eax
80103d74:	e8 77 0f 00 00       	call   80104cf0 <wakeup>
80103d79:	83 c4 10             	add    $0x10,%esp
80103d7c:	eb b9                	jmp    80103d37 <pipeclose+0x37>
80103d7e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	53                   	push   %ebx
80103d84:	e8 37 15 00 00       	call   801052c0 <release>
    kfree((char*)p);
80103d89:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d8c:	83 c4 10             	add    $0x10,%esp
}
80103d8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d92:	5b                   	pop    %ebx
80103d93:	5e                   	pop    %esi
80103d94:	5d                   	pop    %ebp
    kfree((char*)p);
80103d95:	e9 b6 ec ff ff       	jmp    80102a50 <kfree>
80103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103da0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 28             	sub    $0x28,%esp
80103da9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103dac:	53                   	push   %ebx
80103dad:	e8 4e 14 00 00       	call   80105200 <acquire>
  for(i = 0; i < n; i++){
80103db2:	8b 45 10             	mov    0x10(%ebp),%eax
80103db5:	83 c4 10             	add    $0x10,%esp
80103db8:	85 c0                	test   %eax,%eax
80103dba:	0f 8e c9 00 00 00    	jle    80103e89 <pipewrite+0xe9>
80103dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103dc3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103dc9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103dcf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103dd2:	03 4d 10             	add    0x10(%ebp),%ecx
80103dd5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dd8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103dde:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103de4:	39 d0                	cmp    %edx,%eax
80103de6:	75 71                	jne    80103e59 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103de8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103dee:	85 c0                	test   %eax,%eax
80103df0:	74 4e                	je     80103e40 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103df2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103df8:	eb 3a                	jmp    80103e34 <pipewrite+0x94>
80103dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103e00:	83 ec 0c             	sub    $0xc,%esp
80103e03:	57                   	push   %edi
80103e04:	e8 e7 0e 00 00       	call   80104cf0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e09:	5a                   	pop    %edx
80103e0a:	59                   	pop    %ecx
80103e0b:	53                   	push   %ebx
80103e0c:	56                   	push   %esi
80103e0d:	e8 9e 0c 00 00       	call   80104ab0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e12:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e18:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e1e:	83 c4 10             	add    $0x10,%esp
80103e21:	05 00 02 00 00       	add    $0x200,%eax
80103e26:	39 c2                	cmp    %eax,%edx
80103e28:	75 36                	jne    80103e60 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103e2a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e30:	85 c0                	test   %eax,%eax
80103e32:	74 0c                	je     80103e40 <pipewrite+0xa0>
80103e34:	e8 87 04 00 00       	call   801042c0 <myproc>
80103e39:	8b 40 24             	mov    0x24(%eax),%eax
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	74 c0                	je     80103e00 <pipewrite+0x60>
        release(&p->lock);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	53                   	push   %ebx
80103e44:	e8 77 14 00 00       	call   801052c0 <release>
        return -1;
80103e49:	83 c4 10             	add    $0x10,%esp
80103e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e54:	5b                   	pop    %ebx
80103e55:	5e                   	pop    %esi
80103e56:	5f                   	pop    %edi
80103e57:	5d                   	pop    %ebp
80103e58:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e59:	89 c2                	mov    %eax,%edx
80103e5b:	90                   	nop
80103e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e60:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103e63:	8d 42 01             	lea    0x1(%edx),%eax
80103e66:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103e6c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103e72:	83 c6 01             	add    $0x1,%esi
80103e75:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103e79:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e7c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e7f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e83:	0f 85 4f ff ff ff    	jne    80103dd8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e89:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	50                   	push   %eax
80103e93:	e8 58 0e 00 00       	call   80104cf0 <wakeup>
  release(&p->lock);
80103e98:	89 1c 24             	mov    %ebx,(%esp)
80103e9b:	e8 20 14 00 00       	call   801052c0 <release>
  return n;
80103ea0:	83 c4 10             	add    $0x10,%esp
80103ea3:	8b 45 10             	mov    0x10(%ebp),%eax
80103ea6:	eb a9                	jmp    80103e51 <pipewrite+0xb1>
80103ea8:	90                   	nop
80103ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103eb0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 18             	sub    $0x18,%esp
80103eb9:	8b 75 08             	mov    0x8(%ebp),%esi
80103ebc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103ebf:	56                   	push   %esi
80103ec0:	e8 3b 13 00 00       	call   80105200 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ec5:	83 c4 10             	add    $0x10,%esp
80103ec8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ece:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ed4:	75 6a                	jne    80103f40 <piperead+0x90>
80103ed6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103edc:	85 db                	test   %ebx,%ebx
80103ede:	0f 84 c4 00 00 00    	je     80103fa8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ee4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103eea:	eb 2d                	jmp    80103f19 <piperead+0x69>
80103eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef0:	83 ec 08             	sub    $0x8,%esp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
80103ef5:	e8 b6 0b 00 00       	call   80104ab0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103efa:	83 c4 10             	add    $0x10,%esp
80103efd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f03:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f09:	75 35                	jne    80103f40 <piperead+0x90>
80103f0b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103f11:	85 d2                	test   %edx,%edx
80103f13:	0f 84 8f 00 00 00    	je     80103fa8 <piperead+0xf8>
    if(myproc()->killed){
80103f19:	e8 a2 03 00 00       	call   801042c0 <myproc>
80103f1e:	8b 48 24             	mov    0x24(%eax),%ecx
80103f21:	85 c9                	test   %ecx,%ecx
80103f23:	74 cb                	je     80103ef0 <piperead+0x40>
      release(&p->lock);
80103f25:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f28:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f2d:	56                   	push   %esi
80103f2e:	e8 8d 13 00 00       	call   801052c0 <release>
      return -1;
80103f33:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f39:	89 d8                	mov    %ebx,%eax
80103f3b:	5b                   	pop    %ebx
80103f3c:	5e                   	pop    %esi
80103f3d:	5f                   	pop    %edi
80103f3e:	5d                   	pop    %ebp
80103f3f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f40:	8b 45 10             	mov    0x10(%ebp),%eax
80103f43:	85 c0                	test   %eax,%eax
80103f45:	7e 61                	jle    80103fa8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103f47:	31 db                	xor    %ebx,%ebx
80103f49:	eb 13                	jmp    80103f5e <piperead+0xae>
80103f4b:	90                   	nop
80103f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f50:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f56:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f5c:	74 1f                	je     80103f7d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f5e:	8d 41 01             	lea    0x1(%ecx),%eax
80103f61:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103f67:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103f6d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103f72:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f75:	83 c3 01             	add    $0x1,%ebx
80103f78:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f7b:	75 d3                	jne    80103f50 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f7d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103f83:	83 ec 0c             	sub    $0xc,%esp
80103f86:	50                   	push   %eax
80103f87:	e8 64 0d 00 00       	call   80104cf0 <wakeup>
  release(&p->lock);
80103f8c:	89 34 24             	mov    %esi,(%esp)
80103f8f:	e8 2c 13 00 00       	call   801052c0 <release>
  return i;
80103f94:	83 c4 10             	add    $0x10,%esp
}
80103f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f9a:	89 d8                	mov    %ebx,%eax
80103f9c:	5b                   	pop    %ebx
80103f9d:	5e                   	pop    %esi
80103f9e:	5f                   	pop    %edi
80103f9f:	5d                   	pop    %ebp
80103fa0:	c3                   	ret    
80103fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fa8:	31 db                	xor    %ebx,%ebx
80103faa:	eb d1                	jmp    80103f7d <piperead+0xcd>
80103fac:	66 90                	xchg   %ax,%ax
80103fae:	66 90                	xchg   %ax,%ax

80103fb0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	57                   	push   %edi
80103fb4:	56                   	push   %esi
80103fb5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb6:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80103fbb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103fbe:	68 00 61 18 80       	push   $0x80186100
80103fc3:	e8 38 12 00 00       	call   80105200 <acquire>
80103fc8:	83 c4 10             	add    $0x10,%esp
80103fcb:	eb 15                	jmp    80103fe2 <allocproc+0x32>
80103fcd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fd0:	81 c3 30 04 00 00    	add    $0x430,%ebx
80103fd6:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80103fdc:	0f 83 96 01 00 00    	jae    80104178 <allocproc+0x1c8>
    if(p->state == UNUSED)
80103fe2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103fe5:	85 c0                	test   %eax,%eax
80103fe7:	75 e7                	jne    80103fd0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103fe9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103fee:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103ff1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103ff8:	8d 50 01             	lea    0x1(%eax),%edx
80103ffb:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103ffe:	68 00 61 18 80       	push   $0x80186100
  p->pid = nextpid++;
80104003:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104009:	e8 b2 12 00 00       	call   801052c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010400e:	e8 1d ed ff ff       	call   80102d30 <kalloc>
80104013:	83 c4 10             	add    $0x10,%esp
80104016:	85 c0                	test   %eax,%eax
80104018:	89 43 08             	mov    %eax,0x8(%ebx)
8010401b:	0f 84 73 01 00 00    	je     80104194 <allocproc+0x1e4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104021:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104027:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010402a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010402f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104032:	c7 40 14 71 65 10 80 	movl   $0x80106571,0x14(%eax)
  p->context = (struct context*)sp;
80104039:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010403c:	6a 14                	push   $0x14
8010403e:	6a 00                	push   $0x0
80104040:	50                   	push   %eax
80104041:	e8 ca 12 00 00       	call   80105310 <memset>
  p->context->eip = (uint)forkret;
80104046:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80104049:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010404c:	c7 40 10 b0 41 10 80 	movl   $0x801041b0,0x10(%eax)
  if(p->pid > 2) {
80104053:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104057:	7f 0f                	jg     80104068 <allocproc+0xb8>
      // cprintf("\n");

    }
  }
  return p;
}
80104059:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405c:	89 d8                	mov    %ebx,%eax
8010405e:	5b                   	pop    %ebx
8010405f:	5e                   	pop    %esi
80104060:	5f                   	pop    %edi
80104061:	5d                   	pop    %ebp
80104062:	c3                   	ret    
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(createSwapFile(p) != 0)
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	53                   	push   %ebx
8010406c:	e8 ef e4 ff ff       	call   80102560 <createSwapFile>
80104071:	83 c4 10             	add    $0x10,%esp
80104074:	85 c0                	test   %eax,%eax
80104076:	0f 85 26 01 00 00    	jne    801041a2 <allocproc+0x1f2>
    if(p->selection == SCFIFO)
8010407c:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
    p->num_ram = 0;
80104082:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80104089:	00 00 00 
    p->num_swap = 0;
8010408c:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80104093:	00 00 00 
    p->totalPgfltCount = 0;
80104096:	c7 83 28 04 00 00 00 	movl   $0x0,0x428(%ebx)
8010409d:	00 00 00 
    p->totalPgoutCount = 0;
801040a0:	c7 83 2c 04 00 00 00 	movl   $0x0,0x42c(%ebx)
801040a7:	00 00 00 
    if(p->selection == SCFIFO)
801040aa:	83 f8 03             	cmp    $0x3,%eax
801040ad:	0f 84 b1 00 00 00    	je     80104164 <allocproc+0x1b4>
    if(p->selection == AQ)
801040b3:	83 f8 04             	cmp    $0x4,%eax
801040b6:	75 14                	jne    801040cc <allocproc+0x11c>
      p->queue_head = 0;
801040b8:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
801040bf:	00 00 00 
      p->queue_tail = 0;
801040c2:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
801040c9:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040cc:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
801040d2:	83 ec 04             	sub    $0x4,%esp
801040d5:	68 c0 01 00 00       	push   $0x1c0
801040da:	6a 00                	push   $0x0
801040dc:	50                   	push   %eax
801040dd:	e8 2e 12 00 00       	call   80105310 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040e2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040e8:	83 c4 0c             	add    $0xc,%esp
801040eb:	68 c0 01 00 00       	push   $0x1c0
801040f0:	6a 00                	push   $0x0
801040f2:	50                   	push   %eax
801040f3:	e8 18 12 00 00       	call   80105310 <memset>
    if(p->pid > 2)
801040f8:	83 c4 10             	add    $0x10,%esp
801040fb:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801040ff:	0f 8e 54 ff ff ff    	jle    80104059 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
80104105:	e8 26 ec ff ff       	call   80102d30 <kalloc>
8010410a:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      p->free_head->prev = 0;
80104110:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = p->free_head;
80104117:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head->off = 0 * PGSIZE;
8010411c:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80104122:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80104128:	8b bb 14 04 00 00    	mov    0x414(%ebx),%edi
8010412e:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80104130:	e8 fb eb ff ff       	call   80102d30 <kalloc>
        curr->off = i * PGSIZE;
80104135:	89 30                	mov    %esi,(%eax)
80104137:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
8010413d:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80104140:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80104146:	89 47 04             	mov    %eax,0x4(%edi)
80104149:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
8010414b:	75 e3                	jne    80104130 <allocproc+0x180>
      p->free_tail = prev;
8010414d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
      p->free_tail->next = 0;
80104153:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
8010415a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415d:	89 d8                	mov    %ebx,%eax
8010415f:	5b                   	pop    %ebx
80104160:	5e                   	pop    %esi
80104161:	5f                   	pop    %edi
80104162:	5d                   	pop    %ebp
80104163:	c3                   	ret    
      p->clockHand = 0;
80104164:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
8010416b:	00 00 00 
8010416e:	e9 59 ff ff ff       	jmp    801040cc <allocproc+0x11c>
80104173:	90                   	nop
80104174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104178:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010417b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010417d:	68 00 61 18 80       	push   $0x80186100
80104182:	e8 39 11 00 00       	call   801052c0 <release>
  return 0;
80104187:	83 c4 10             	add    $0x10,%esp
}
8010418a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010418d:	89 d8                	mov    %ebx,%eax
8010418f:	5b                   	pop    %ebx
80104190:	5e                   	pop    %esi
80104191:	5f                   	pop    %edi
80104192:	5d                   	pop    %ebp
80104193:	c3                   	ret    
    p->state = UNUSED;
80104194:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010419b:	31 db                	xor    %ebx,%ebx
8010419d:	e9 b7 fe ff ff       	jmp    80104059 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
801041a2:	83 ec 0c             	sub    $0xc,%esp
801041a5:	68 15 95 10 80       	push   $0x80109515
801041aa:	e8 e1 c1 ff ff       	call   80100390 <panic>
801041af:	90                   	nop

801041b0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801041b6:	68 00 61 18 80       	push   $0x80186100
801041bb:	e8 00 11 00 00       	call   801052c0 <release>

  if (first) {
801041c0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	85 c0                	test   %eax,%eax
801041ca:	75 04                	jne    801041d0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801041cc:	c9                   	leave  
801041cd:	c3                   	ret    
801041ce:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801041d0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801041d3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801041da:	00 00 00 
    iinit(ROOTDEV);
801041dd:	6a 01                	push   $0x1
801041df:	e8 4c d6 ff ff       	call   80101830 <iinit>
    initlog(ROOTDEV);
801041e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801041eb:	e8 c0 f2 ff ff       	call   801034b0 <initlog>
801041f0:	83 c4 10             	add    $0x10,%esp
}
801041f3:	c9                   	leave  
801041f4:	c3                   	ret    
801041f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104200 <pinit>:
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104206:	68 2f 95 10 80       	push   $0x8010952f
8010420b:	68 00 61 18 80       	push   $0x80186100
80104210:	e8 ab 0e 00 00       	call   801050c0 <initlock>
}
80104215:	83 c4 10             	add    $0x10,%esp
80104218:	c9                   	leave  
80104219:	c3                   	ret    
8010421a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104220 <mycpu>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104225:	9c                   	pushf  
80104226:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104227:	f6 c4 02             	test   $0x2,%ah
8010422a:	75 5e                	jne    8010428a <mycpu+0x6a>
  apicid = lapicid();
8010422c:	e8 af ee ff ff       	call   801030e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104231:	8b 35 e0 60 18 80    	mov    0x801860e0,%esi
80104237:	85 f6                	test   %esi,%esi
80104239:	7e 42                	jle    8010427d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010423b:	0f b6 15 60 5b 18 80 	movzbl 0x80185b60,%edx
80104242:	39 d0                	cmp    %edx,%eax
80104244:	74 30                	je     80104276 <mycpu+0x56>
80104246:	b9 10 5c 18 80       	mov    $0x80185c10,%ecx
  for (i = 0; i < ncpu; ++i) {
8010424b:	31 d2                	xor    %edx,%edx
8010424d:	8d 76 00             	lea    0x0(%esi),%esi
80104250:	83 c2 01             	add    $0x1,%edx
80104253:	39 f2                	cmp    %esi,%edx
80104255:	74 26                	je     8010427d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104257:	0f b6 19             	movzbl (%ecx),%ebx
8010425a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104260:	39 c3                	cmp    %eax,%ebx
80104262:	75 ec                	jne    80104250 <mycpu+0x30>
80104264:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010426a:	05 60 5b 18 80       	add    $0x80185b60,%eax
}
8010426f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104272:	5b                   	pop    %ebx
80104273:	5e                   	pop    %esi
80104274:	5d                   	pop    %ebp
80104275:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104276:	b8 60 5b 18 80       	mov    $0x80185b60,%eax
      return &cpus[i];
8010427b:	eb f2                	jmp    8010426f <mycpu+0x4f>
  panic("unknown apicid\n");
8010427d:	83 ec 0c             	sub    $0xc,%esp
80104280:	68 36 95 10 80       	push   $0x80109536
80104285:	e8 06 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 24 96 10 80       	push   $0x80109624
80104292:	e8 f9 c0 ff ff       	call   80100390 <panic>
80104297:	89 f6                	mov    %esi,%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <cpuid>:
cpuid() {
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801042a6:	e8 75 ff ff ff       	call   80104220 <mycpu>
801042ab:	2d 60 5b 18 80       	sub    $0x80185b60,%eax
}
801042b0:	c9                   	leave  
  return mycpu()-cpus;
801042b1:	c1 f8 04             	sar    $0x4,%eax
801042b4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042ba:	c3                   	ret    
801042bb:	90                   	nop
801042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042c0 <myproc>:
myproc(void) {
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042c7:	e8 64 0e 00 00       	call   80105130 <pushcli>
  c = mycpu();
801042cc:	e8 4f ff ff ff       	call   80104220 <mycpu>
  p = c->proc;
801042d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d7:	e8 94 0e 00 00       	call   80105170 <popcli>
}
801042dc:	83 c4 04             	add    $0x4,%esp
801042df:	89 d8                	mov    %ebx,%eax
801042e1:	5b                   	pop    %ebx
801042e2:	5d                   	pop    %ebp
801042e3:	c3                   	ret    
801042e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801042f0 <userinit>:
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801042f7:	e8 b4 fc ff ff       	call   80103fb0 <allocproc>
801042fc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801042fe:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  if((p->pgdir = setupkvm()) == 0)
80104303:	e8 58 3d 00 00       	call   80108060 <setupkvm>
80104308:	85 c0                	test   %eax,%eax
8010430a:	89 43 04             	mov    %eax,0x4(%ebx)
8010430d:	0f 84 bd 00 00 00    	je     801043d0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104313:	83 ec 04             	sub    $0x4,%esp
80104316:	68 2c 00 00 00       	push   $0x2c
8010431b:	68 60 c4 10 80       	push   $0x8010c460
80104320:	50                   	push   %eax
80104321:	e8 aa 35 00 00       	call   801078d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104326:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104329:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010432f:	6a 4c                	push   $0x4c
80104331:	6a 00                	push   $0x0
80104333:	ff 73 18             	pushl  0x18(%ebx)
80104336:	e8 d5 0f 00 00       	call   80105310 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010433b:	8b 43 18             	mov    0x18(%ebx),%eax
8010433e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104343:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104348:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010434b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010434f:	8b 43 18             	mov    0x18(%ebx),%eax
80104352:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104356:	8b 43 18             	mov    0x18(%ebx),%eax
80104359:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010435d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104361:	8b 43 18             	mov    0x18(%ebx),%eax
80104364:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104368:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010436c:	8b 43 18             	mov    0x18(%ebx),%eax
8010436f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104376:	8b 43 18             	mov    0x18(%ebx),%eax
80104379:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104380:	8b 43 18             	mov    0x18(%ebx),%eax
80104383:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010438a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010438d:	6a 10                	push   $0x10
8010438f:	68 5f 95 10 80       	push   $0x8010955f
80104394:	50                   	push   %eax
80104395:	e8 56 11 00 00       	call   801054f0 <safestrcpy>
  p->cwd = namei("/");
8010439a:	c7 04 24 68 95 10 80 	movl   $0x80109568,(%esp)
801043a1:	e8 ea de ff ff       	call   80102290 <namei>
801043a6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043a9:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043b0:	e8 4b 0e 00 00       	call   80105200 <acquire>
  p->state = RUNNABLE;
801043b5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043bc:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043c3:	e8 f8 0e 00 00       	call   801052c0 <release>
}
801043c8:	83 c4 10             	add    $0x10,%esp
801043cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ce:	c9                   	leave  
801043cf:	c3                   	ret    
    panic("userinit: out of memory?");
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 46 95 10 80       	push   $0x80109546
801043d8:	e8 b3 bf ff ff       	call   80100390 <panic>
801043dd:	8d 76 00             	lea    0x0(%esi),%esi

801043e0 <growproc>:
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	56                   	push   %esi
801043e4:	53                   	push   %ebx
801043e5:	83 ec 10             	sub    $0x10,%esp
801043e8:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801043eb:	e8 40 0d 00 00       	call   80105130 <pushcli>
  c = mycpu();
801043f0:	e8 2b fe ff ff       	call   80104220 <mycpu>
  p = c->proc;
801043f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043fb:	e8 70 0d 00 00       	call   80105170 <popcli>
  if(n > 0){
80104400:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104403:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104405:	7f 19                	jg     80104420 <growproc+0x40>
  } else if(n < 0){
80104407:	75 37                	jne    80104440 <growproc+0x60>
  switchuvm(curproc);
80104409:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010440c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010440e:	53                   	push   %ebx
8010440f:	e8 ac 33 00 00       	call   801077c0 <switchuvm>
  return 0;
80104414:	83 c4 10             	add    $0x10,%esp
80104417:	31 c0                	xor    %eax,%eax
}
80104419:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010441c:	5b                   	pop    %ebx
8010441d:	5e                   	pop    %esi
8010441e:	5d                   	pop    %ebp
8010441f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104420:	83 ec 04             	sub    $0x4,%esp
80104423:	01 c6                	add    %eax,%esi
80104425:	56                   	push   %esi
80104426:	50                   	push   %eax
80104427:	ff 73 04             	pushl  0x4(%ebx)
8010442a:	e8 21 3a 00 00       	call   80107e50 <allocuvm>
8010442f:	83 c4 10             	add    $0x10,%esp
80104432:	85 c0                	test   %eax,%eax
80104434:	75 d3                	jne    80104409 <growproc+0x29>
      return -1;
80104436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443b:	eb dc                	jmp    80104419 <growproc+0x39>
8010443d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("growproc: n < 0\n");
80104440:	83 ec 0c             	sub    $0xc,%esp
80104443:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104446:	68 6a 95 10 80       	push   $0x8010956a
8010444b:	e8 10 c2 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	83 c4 0c             	add    $0xc,%esp
80104456:	01 c6                	add    %eax,%esi
80104458:	56                   	push   %esi
80104459:	50                   	push   %eax
8010445a:	ff 73 04             	pushl  0x4(%ebx)
8010445d:	e8 ce 37 00 00       	call   80107c30 <deallocuvm>
80104462:	83 c4 10             	add    $0x10,%esp
80104465:	85 c0                	test   %eax,%eax
80104467:	75 a0                	jne    80104409 <growproc+0x29>
80104469:	eb cb                	jmp    80104436 <growproc+0x56>
8010446b:	90                   	nop
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <fork>:
{ 
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010447c:	e8 af 0c 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104481:	e8 9a fd ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104486:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448c:	e8 df 0c 00 00       	call   80105170 <popcli>
  if((np = allocproc()) == 0){
80104491:	e8 1a fb ff ff       	call   80103fb0 <allocproc>
80104496:	85 c0                	test   %eax,%eax
80104498:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
8010449e:	0f 84 1f 02 00 00    	je     801046c3 <fork+0x253>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801044a4:	83 ec 08             	sub    $0x8,%esp
801044a7:	ff 33                	pushl  (%ebx)
801044a9:	ff 73 04             	pushl  0x4(%ebx)
801044ac:	e8 7f 42 00 00       	call   80108730 <copyuvm>
801044b1:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
  if(np->pgdir == 0){
801044b7:	83 c4 10             	add    $0x10,%esp
801044ba:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
801044bc:	89 42 04             	mov    %eax,0x4(%edx)
  if(np->pgdir == 0){
801044bf:	0f 84 05 02 00 00    	je     801046ca <fork+0x25a>
  np->sz = curproc->sz;
801044c5:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801044c7:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
801044cc:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801044cf:	8b 7a 18             	mov    0x18(%edx),%edi
  np->sz = curproc->sz;
801044d2:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
801044d4:	8b 73 18             	mov    0x18(%ebx),%esi
801044d7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801044d9:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801044dd:	0f 8e 3e 01 00 00    	jle    80104621 <fork+0x1b1>
    np->totalPgfltCount = 0;
801044e3:	c7 82 28 04 00 00 00 	movl   $0x0,0x428(%edx)
801044ea:	00 00 00 
    np->totalPgoutCount = 0;
801044ed:	c7 82 2c 04 00 00 00 	movl   $0x0,0x42c(%edx)
801044f4:	00 00 00 
    np->num_ram = curproc->num_ram;
801044f7:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
801044fd:	89 82 08 04 00 00    	mov    %eax,0x408(%edx)
    np->num_swap = curproc->num_swap;
80104503:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80104509:	89 82 0c 04 00 00    	mov    %eax,0x40c(%edx)
8010450f:	31 c0                	xor    %eax,%eax
80104511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->ramPages[i].isused)
80104518:	8b b4 03 4c 02 00 00 	mov    0x24c(%ebx,%eax,1),%esi
8010451f:	85 f6                	test   %esi,%esi
80104521:	74 31                	je     80104554 <fork+0xe4>
        np->ramPages[i].isused = 1;
80104523:	c7 84 02 4c 02 00 00 	movl   $0x1,0x24c(%edx,%eax,1)
8010452a:	01 00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010452e:	8b 8c 03 50 02 00 00 	mov    0x250(%ebx,%eax,1),%ecx
80104535:	89 8c 02 50 02 00 00 	mov    %ecx,0x250(%edx,%eax,1)
        np->ramPages[i].pgdir = np->pgdir;
8010453c:	8b 4a 04             	mov    0x4(%edx),%ecx
8010453f:	89 8c 02 48 02 00 00 	mov    %ecx,0x248(%edx,%eax,1)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104546:	8b 8c 03 58 02 00 00 	mov    0x258(%ebx,%eax,1),%ecx
8010454d:	89 8c 02 58 02 00 00 	mov    %ecx,0x258(%edx,%eax,1)
      if(curproc->swappedPages[i].isused)
80104554:	8b 8c 03 8c 00 00 00 	mov    0x8c(%ebx,%eax,1),%ecx
8010455b:	85 c9                	test   %ecx,%ecx
8010455d:	74 3f                	je     8010459e <fork+0x12e>
      np->swappedPages[i].isused = 1;
8010455f:	c7 84 02 8c 00 00 00 	movl   $0x1,0x8c(%edx,%eax,1)
80104566:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
8010456a:	8b 8c 03 90 00 00 00 	mov    0x90(%ebx,%eax,1),%ecx
80104571:	89 8c 02 90 00 00 00 	mov    %ecx,0x90(%edx,%eax,1)
      np->swappedPages[i].pgdir = np->pgdir;
80104578:	8b 4a 04             	mov    0x4(%edx),%ecx
8010457b:	89 8c 02 88 00 00 00 	mov    %ecx,0x88(%edx,%eax,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104582:	8b 8c 03 94 00 00 00 	mov    0x94(%ebx,%eax,1),%ecx
80104589:	89 8c 02 94 00 00 00 	mov    %ecx,0x94(%edx,%eax,1)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
80104590:	8b 8c 03 98 00 00 00 	mov    0x98(%ebx,%eax,1),%ecx
80104597:	89 8c 02 98 00 00 00 	mov    %ecx,0x98(%edx,%eax,1)
8010459e:	83 c0 1c             	add    $0x1c,%eax
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801045a1:	3d c0 01 00 00       	cmp    $0x1c0,%eax
801045a6:	0f 85 6c ff ff ff    	jne    80104518 <fork+0xa8>
      char buffer[PGSIZE / 2] = "";
801045ac:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
801045b2:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
801045b7:	31 c0                	xor    %eax,%eax
801045b9:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
801045c0:	00 00 00 
      int offset = 0;
801045c3:	31 f6                	xor    %esi,%esi
      char buffer[PGSIZE / 2] = "";
801045c5:	f3 ab                	rep stos %eax,%es:(%edi)
801045c7:	8d bd e8 f7 ff ff    	lea    -0x818(%ebp),%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801045cd:	eb 30                	jmp    801045ff <fork+0x18f>
801045cf:	90                   	nop
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
801045d0:	51                   	push   %ecx
801045d1:	56                   	push   %esi
801045d2:	57                   	push   %edi
801045d3:	52                   	push   %edx
801045d4:	89 8d e0 f7 ff ff    	mov    %ecx,-0x820(%ebp)
801045da:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
801045e0:	e8 1b e0 ff ff       	call   80102600 <writeToSwapFile>
801045e5:	83 c4 10             	add    $0x10,%esp
801045e8:	83 f8 ff             	cmp    $0xffffffff,%eax
801045eb:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
801045f1:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
801045f7:	0f 84 f6 00 00 00    	je     801046f3 <fork+0x283>
        offset += nread;
801045fd:	01 ce                	add    %ecx,%esi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801045ff:	68 00 08 00 00       	push   $0x800
80104604:	56                   	push   %esi
80104605:	57                   	push   %edi
80104606:	53                   	push   %ebx
80104607:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
8010460d:	e8 1e e0 ff ff       	call   80102630 <readFromSwapFile>
80104612:	83 c4 10             	add    $0x10,%esp
80104615:	85 c0                	test   %eax,%eax
80104617:	89 c1                	mov    %eax,%ecx
80104619:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
8010461f:	75 af                	jne    801045d0 <fork+0x160>
  np->tf->eax = 0;
80104621:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80104624:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104626:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80104630:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104634:	85 c0                	test   %eax,%eax
80104636:	74 1c                	je     80104654 <fork+0x1e4>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
80104641:	50                   	push   %eax
80104642:	e8 59 cb ff ff       	call   801011a0 <filedup>
80104647:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
8010464d:	83 c4 10             	add    $0x10,%esp
80104650:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104654:	83 c6 01             	add    $0x1,%esi
80104657:	83 fe 10             	cmp    $0x10,%esi
8010465a:	75 d4                	jne    80104630 <fork+0x1c0>
  np->cwd = idup(curproc->cwd);
8010465c:	83 ec 0c             	sub    $0xc,%esp
8010465f:	ff 73 68             	pushl  0x68(%ebx)
80104662:	89 95 e4 f7 ff ff    	mov    %edx,-0x81c(%ebp)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104668:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
8010466b:	e8 90 d3 ff ff       	call   80101a00 <idup>
80104670:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104676:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104679:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010467c:	8d 42 6c             	lea    0x6c(%edx),%eax
8010467f:	6a 10                	push   $0x10
80104681:	53                   	push   %ebx
80104682:	50                   	push   %eax
80104683:	e8 68 0e 00 00       	call   801054f0 <safestrcpy>
  pid = np->pid;
80104688:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
8010468e:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80104691:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104698:	e8 63 0b 00 00       	call   80105200 <acquire>
  np->state = RUNNABLE;
8010469d:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
801046a3:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
801046aa:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801046b1:	e8 0a 0c 00 00       	call   801052c0 <release>
  return pid;
801046b6:	83 c4 10             	add    $0x10,%esp
}
801046b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046bc:	89 d8                	mov    %ebx,%eax
801046be:	5b                   	pop    %ebx
801046bf:	5e                   	pop    %esi
801046c0:	5f                   	pop    %edi
801046c1:	5d                   	pop    %ebp
801046c2:	c3                   	ret    
    return -1;
801046c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046c8:	eb ef                	jmp    801046b9 <fork+0x249>
    kfree(np->kstack);
801046ca:	83 ec 0c             	sub    $0xc,%esp
801046cd:	ff 72 08             	pushl  0x8(%edx)
    return -1;
801046d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
801046d5:	e8 76 e3 ff ff       	call   80102a50 <kfree>
    np->kstack = 0;
801046da:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
    return -1;
801046e0:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
801046e3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
801046ea:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
801046f1:	eb c6                	jmp    801046b9 <fork+0x249>
          panic("fork: error copying parent's swap file");
801046f3:	83 ec 0c             	sub    $0xc,%esp
801046f6:	68 4c 96 10 80       	push   $0x8010964c
801046fb:	e8 90 bc ff ff       	call   80100390 <panic>

80104700 <copyAQ>:
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	57                   	push   %edi
80104704:	56                   	push   %esi
80104705:	53                   	push   %ebx
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010470c:	e8 1f 0a 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104711:	e8 0a fb ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104716:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010471c:	e8 4f 0a 00 00       	call   80105170 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
80104721:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
80104727:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
8010472e:	00 00 00 
  np->queue_tail = 0;
80104731:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
80104738:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
8010473b:	85 db                	test   %ebx,%ebx
8010473d:	74 4f                	je     8010478e <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
8010473f:	e8 ec e5 ff ff       	call   80102d30 <kalloc>
80104744:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
80104746:	8b 43 08             	mov    0x8(%ebx),%eax
80104749:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
8010474c:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
80104752:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
80104759:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
8010475b:	85 db                	test   %ebx,%ebx
8010475d:	74 37                	je     80104796 <copyAQ+0x96>
8010475f:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
80104760:	e8 cb e5 ff ff       	call   80102d30 <kalloc>
    np_curr->page_index = old_curr->page_index;
80104765:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
80104768:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
8010476b:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
8010476e:	89 07                	mov    %eax,(%edi)
80104770:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
80104772:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
80104774:	85 db                	test   %ebx,%ebx
80104776:	75 e8                	jne    80104760 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
80104778:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
8010477e:	85 d2                	test   %edx,%edx
80104780:	74 0c                	je     8010478e <copyAQ+0x8e>
    np_curr->next = 0;
80104782:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104788:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
8010478e:	83 c4 0c             	add    $0xc,%esp
80104791:	5b                   	pop    %ebx
80104792:	5e                   	pop    %esi
80104793:	5f                   	pop    %edi
80104794:	5d                   	pop    %ebp
80104795:	c3                   	ret    
  while(old_curr != 0)
80104796:	89 f8                	mov    %edi,%eax
80104798:	eb de                	jmp    80104778 <copyAQ+0x78>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047a0 <scheduler>:
{
801047a0:	55                   	push   %ebp
801047a1:	89 e5                	mov    %esp,%ebp
801047a3:	57                   	push   %edi
801047a4:	56                   	push   %esi
801047a5:	53                   	push   %ebx
801047a6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047a9:	e8 72 fa ff ff       	call   80104220 <mycpu>
801047ae:	8d 78 04             	lea    0x4(%eax),%edi
801047b1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801047b3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047ba:	00 00 00 
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801047c0:	fb                   	sti    
    acquire(&ptable.lock);
801047c1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047c4:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
801047c9:	68 00 61 18 80       	push   $0x80186100
801047ce:	e8 2d 0a 00 00       	call   80105200 <acquire>
801047d3:	83 c4 10             	add    $0x10,%esp
801047d6:	8d 76 00             	lea    0x0(%esi),%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801047e0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801047e4:	75 33                	jne    80104819 <scheduler+0x79>
      switchuvm(p);
801047e6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801047e9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801047ef:	53                   	push   %ebx
801047f0:	e8 cb 2f 00 00       	call   801077c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801047f5:	58                   	pop    %eax
801047f6:	5a                   	pop    %edx
801047f7:	ff 73 1c             	pushl  0x1c(%ebx)
801047fa:	57                   	push   %edi
      p->state = RUNNING;
801047fb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104802:	e8 44 0d 00 00       	call   8010554b <swtch>
      switchkvm();
80104807:	e8 94 2f 00 00       	call   801077a0 <switchkvm>
      c->proc = 0;
8010480c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104813:	00 00 00 
80104816:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104819:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010481f:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104825:	72 b9                	jb     801047e0 <scheduler+0x40>
    release(&ptable.lock);
80104827:	83 ec 0c             	sub    $0xc,%esp
8010482a:	68 00 61 18 80       	push   $0x80186100
8010482f:	e8 8c 0a 00 00       	call   801052c0 <release>
    sti();
80104834:	83 c4 10             	add    $0x10,%esp
80104837:	eb 87                	jmp    801047c0 <scheduler+0x20>
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104840 <sched>:
{
80104840:	55                   	push   %ebp
80104841:	89 e5                	mov    %esp,%ebp
80104843:	56                   	push   %esi
80104844:	53                   	push   %ebx
  pushcli();
80104845:	e8 e6 08 00 00       	call   80105130 <pushcli>
  c = mycpu();
8010484a:	e8 d1 f9 ff ff       	call   80104220 <mycpu>
  p = c->proc;
8010484f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104855:	e8 16 09 00 00       	call   80105170 <popcli>
  if(!holding(&ptable.lock))
8010485a:	83 ec 0c             	sub    $0xc,%esp
8010485d:	68 00 61 18 80       	push   $0x80186100
80104862:	e8 69 09 00 00       	call   801051d0 <holding>
80104867:	83 c4 10             	add    $0x10,%esp
8010486a:	85 c0                	test   %eax,%eax
8010486c:	74 4f                	je     801048bd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010486e:	e8 ad f9 ff ff       	call   80104220 <mycpu>
80104873:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010487a:	75 68                	jne    801048e4 <sched+0xa4>
  if(p->state == RUNNING)
8010487c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104880:	74 55                	je     801048d7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104882:	9c                   	pushf  
80104883:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104884:	f6 c4 02             	test   $0x2,%ah
80104887:	75 41                	jne    801048ca <sched+0x8a>
  intena = mycpu()->intena;
80104889:	e8 92 f9 ff ff       	call   80104220 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010488e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104891:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104897:	e8 84 f9 ff ff       	call   80104220 <mycpu>
8010489c:	83 ec 08             	sub    $0x8,%esp
8010489f:	ff 70 04             	pushl  0x4(%eax)
801048a2:	53                   	push   %ebx
801048a3:	e8 a3 0c 00 00       	call   8010554b <swtch>
  mycpu()->intena = intena;
801048a8:	e8 73 f9 ff ff       	call   80104220 <mycpu>
}
801048ad:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048b0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b9:	5b                   	pop    %ebx
801048ba:	5e                   	pop    %esi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
    panic("sched ptable.lock");
801048bd:	83 ec 0c             	sub    $0xc,%esp
801048c0:	68 7b 95 10 80       	push   $0x8010957b
801048c5:	e8 c6 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801048ca:	83 ec 0c             	sub    $0xc,%esp
801048cd:	68 a7 95 10 80       	push   $0x801095a7
801048d2:	e8 b9 ba ff ff       	call   80100390 <panic>
    panic("sched running");
801048d7:	83 ec 0c             	sub    $0xc,%esp
801048da:	68 99 95 10 80       	push   $0x80109599
801048df:	e8 ac ba ff ff       	call   80100390 <panic>
    panic("sched locks");
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	68 8d 95 10 80       	push   $0x8010958d
801048ec:	e8 9f ba ff ff       	call   80100390 <panic>
801048f1:	eb 0d                	jmp    80104900 <exit>
801048f3:	90                   	nop
801048f4:	90                   	nop
801048f5:	90                   	nop
801048f6:	90                   	nop
801048f7:	90                   	nop
801048f8:	90                   	nop
801048f9:	90                   	nop
801048fa:	90                   	nop
801048fb:	90                   	nop
801048fc:	90                   	nop
801048fd:	90                   	nop
801048fe:	90                   	nop
801048ff:	90                   	nop

80104900 <exit>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	57                   	push   %edi
80104904:	56                   	push   %esi
80104905:	53                   	push   %ebx
80104906:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104909:	e8 22 08 00 00       	call   80105130 <pushcli>
  c = mycpu();
8010490e:	e8 0d f9 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104913:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104919:	e8 52 08 00 00       	call   80105170 <popcli>
  if(curproc == initproc)
8010491e:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
80104924:	8d 73 28             	lea    0x28(%ebx),%esi
80104927:	8d 7b 68             	lea    0x68(%ebx),%edi
8010492a:	0f 84 22 01 00 00    	je     80104a52 <exit+0x152>
    if(curproc->ofile[fd]){
80104930:	8b 06                	mov    (%esi),%eax
80104932:	85 c0                	test   %eax,%eax
80104934:	74 12                	je     80104948 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104936:	83 ec 0c             	sub    $0xc,%esp
80104939:	50                   	push   %eax
8010493a:	e8 b1 c8 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
8010493f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104945:	83 c4 10             	add    $0x10,%esp
80104948:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010494b:	39 fe                	cmp    %edi,%esi
8010494d:	75 e1                	jne    80104930 <exit+0x30>
  begin_op();
8010494f:	e8 fc eb ff ff       	call   80103550 <begin_op>
  iput(curproc->cwd);
80104954:	83 ec 0c             	sub    $0xc,%esp
80104957:	ff 73 68             	pushl  0x68(%ebx)
8010495a:	e8 01 d2 ff ff       	call   80101b60 <iput>
  end_op();
8010495f:	e8 5c ec ff ff       	call   801035c0 <end_op>
  if(curproc->pid > 2) {
80104964:	83 c4 10             	add    $0x10,%esp
80104967:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
8010496b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
80104972:	0f 8f b9 00 00 00    	jg     80104a31 <exit+0x131>
  acquire(&ptable.lock);
80104978:	83 ec 0c             	sub    $0xc,%esp
8010497b:	68 00 61 18 80       	push   $0x80186100
80104980:	e8 7b 08 00 00       	call   80105200 <acquire>
  wakeup1(curproc->parent);
80104985:	8b 53 14             	mov    0x14(%ebx),%edx
80104988:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010498b:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104990:	eb 12                	jmp    801049a4 <exit+0xa4>
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104998:	05 30 04 00 00       	add    $0x430,%eax
8010499d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049a2:	73 1e                	jae    801049c2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
801049a4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049a8:	75 ee                	jne    80104998 <exit+0x98>
801049aa:	3b 50 20             	cmp    0x20(%eax),%edx
801049ad:	75 e9                	jne    80104998 <exit+0x98>
      p->state = RUNNABLE;
801049af:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049b6:	05 30 04 00 00       	add    $0x430,%eax
801049bb:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049c0:	72 e2                	jb     801049a4 <exit+0xa4>
      p->parent = initproc;
801049c2:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049c8:	ba 34 61 18 80       	mov    $0x80186134,%edx
801049cd:	eb 0f                	jmp    801049de <exit+0xde>
801049cf:	90                   	nop
801049d0:	81 c2 30 04 00 00    	add    $0x430,%edx
801049d6:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
801049dc:	73 3a                	jae    80104a18 <exit+0x118>
    if(p->parent == curproc){
801049de:	39 5a 14             	cmp    %ebx,0x14(%edx)
801049e1:	75 ed                	jne    801049d0 <exit+0xd0>
      if(p->state == ZOMBIE)
801049e3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801049e7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801049ea:	75 e4                	jne    801049d0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ec:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049f1:	eb 11                	jmp    80104a04 <exit+0x104>
801049f3:	90                   	nop
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049f8:	05 30 04 00 00       	add    $0x430,%eax
801049fd:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a02:	73 cc                	jae    801049d0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104a04:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a08:	75 ee                	jne    801049f8 <exit+0xf8>
80104a0a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a0d:	75 e9                	jne    801049f8 <exit+0xf8>
      p->state = RUNNABLE;
80104a0f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a16:	eb e0                	jmp    801049f8 <exit+0xf8>
  curproc->state = ZOMBIE;
80104a18:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104a1f:	e8 1c fe ff ff       	call   80104840 <sched>
  panic("zombie exit");
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	68 c8 95 10 80       	push   $0x801095c8
80104a2c:	e8 5f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a31:	83 ec 0c             	sub    $0xc,%esp
80104a34:	53                   	push   %ebx
80104a35:	e8 26 d9 ff ff       	call   80102360 <removeSwapFile>
80104a3a:	83 c4 10             	add    $0x10,%esp
80104a3d:	85 c0                	test   %eax,%eax
80104a3f:	0f 84 33 ff ff ff    	je     80104978 <exit+0x78>
      panic("exit: error deleting swap file");
80104a45:	83 ec 0c             	sub    $0xc,%esp
80104a48:	68 74 96 10 80       	push   $0x80109674
80104a4d:	e8 3e b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a52:	83 ec 0c             	sub    $0xc,%esp
80104a55:	68 bb 95 10 80       	push   $0x801095bb
80104a5a:	e8 31 b9 ff ff       	call   80100390 <panic>
80104a5f:	90                   	nop

80104a60 <yield>:
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a67:	68 00 61 18 80       	push   $0x80186100
80104a6c:	e8 8f 07 00 00       	call   80105200 <acquire>
  pushcli();
80104a71:	e8 ba 06 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104a76:	e8 a5 f7 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104a7b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a81:	e8 ea 06 00 00       	call   80105170 <popcli>
  myproc()->state = RUNNABLE;
80104a86:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104a8d:	e8 ae fd ff ff       	call   80104840 <sched>
  release(&ptable.lock);
80104a92:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104a99:	e8 22 08 00 00       	call   801052c0 <release>
}
80104a9e:	83 c4 10             	add    $0x10,%esp
80104aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa4:	c9                   	leave  
80104aa5:	c3                   	ret    
80104aa6:	8d 76 00             	lea    0x0(%esi),%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <sleep>:
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	57                   	push   %edi
80104ab4:	56                   	push   %esi
80104ab5:	53                   	push   %ebx
80104ab6:	83 ec 0c             	sub    $0xc,%esp
80104ab9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104abc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104abf:	e8 6c 06 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104ac4:	e8 57 f7 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104ac9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104acf:	e8 9c 06 00 00       	call   80105170 <popcli>
  if(p == 0)
80104ad4:	85 db                	test   %ebx,%ebx
80104ad6:	0f 84 87 00 00 00    	je     80104b63 <sleep+0xb3>
  if(lk == 0)
80104adc:	85 f6                	test   %esi,%esi
80104ade:	74 76                	je     80104b56 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ae0:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104ae6:	74 50                	je     80104b38 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	68 00 61 18 80       	push   $0x80186100
80104af0:	e8 0b 07 00 00       	call   80105200 <acquire>
    release(lk);
80104af5:	89 34 24             	mov    %esi,(%esp)
80104af8:	e8 c3 07 00 00       	call   801052c0 <release>
  p->chan = chan;
80104afd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b00:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b07:	e8 34 fd ff ff       	call   80104840 <sched>
  p->chan = 0;
80104b0c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b13:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104b1a:	e8 a1 07 00 00       	call   801052c0 <release>
    acquire(lk);
80104b1f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b22:	83 c4 10             	add    $0x10,%esp
}
80104b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5f                   	pop    %edi
80104b2b:	5d                   	pop    %ebp
    acquire(lk);
80104b2c:	e9 cf 06 00 00       	jmp    80105200 <acquire>
80104b31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b38:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b3b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b42:	e8 f9 fc ff ff       	call   80104840 <sched>
  p->chan = 0;
80104b47:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b51:	5b                   	pop    %ebx
80104b52:	5e                   	pop    %esi
80104b53:	5f                   	pop    %edi
80104b54:	5d                   	pop    %ebp
80104b55:	c3                   	ret    
    panic("sleep without lk");
80104b56:	83 ec 0c             	sub    $0xc,%esp
80104b59:	68 da 95 10 80       	push   $0x801095da
80104b5e:	e8 2d b8 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b63:	83 ec 0c             	sub    $0xc,%esp
80104b66:	68 d4 95 10 80       	push   $0x801095d4
80104b6b:	e8 20 b8 ff ff       	call   80100390 <panic>

80104b70 <wait>:
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
  pushcli();
80104b75:	e8 b6 05 00 00       	call   80105130 <pushcli>
  c = mycpu();
80104b7a:	e8 a1 f6 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104b7f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b85:	e8 e6 05 00 00       	call   80105170 <popcli>
  acquire(&ptable.lock);
80104b8a:	83 ec 0c             	sub    $0xc,%esp
80104b8d:	68 00 61 18 80       	push   $0x80186100
80104b92:	e8 69 06 00 00       	call   80105200 <acquire>
80104b97:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b9a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b9c:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104ba1:	eb 13                	jmp    80104bb6 <wait+0x46>
80104ba3:	90                   	nop
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ba8:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104bae:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104bb4:	73 1e                	jae    80104bd4 <wait+0x64>
      if(p->parent != curproc)
80104bb6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104bb9:	75 ed                	jne    80104ba8 <wait+0x38>
      if(p->state == ZOMBIE){
80104bbb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104bbf:	74 3f                	je     80104c00 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc1:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104bc7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bcc:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104bd2:	72 e2                	jb     80104bb6 <wait+0x46>
    if(!havekids || curproc->killed){
80104bd4:	85 c0                	test   %eax,%eax
80104bd6:	0f 84 f3 00 00 00    	je     80104ccf <wait+0x15f>
80104bdc:	8b 46 24             	mov    0x24(%esi),%eax
80104bdf:	85 c0                	test   %eax,%eax
80104be1:	0f 85 e8 00 00 00    	jne    80104ccf <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104be7:	83 ec 08             	sub    $0x8,%esp
80104bea:	68 00 61 18 80       	push   $0x80186100
80104bef:	56                   	push   %esi
80104bf0:	e8 bb fe ff ff       	call   80104ab0 <sleep>
    havekids = 0;
80104bf5:	83 c4 10             	add    $0x10,%esp
80104bf8:	eb a0                	jmp    80104b9a <wait+0x2a>
80104bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104c00:	83 ec 0c             	sub    $0xc,%esp
80104c03:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104c06:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104c09:	e8 42 de ff ff       	call   80102a50 <kfree>
        freevm(p->pgdir); // panic: kfree
80104c0e:	5a                   	pop    %edx
80104c0f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c12:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104c19:	e8 c2 33 00 00       	call   80107fe0 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c1e:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104c24:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104c27:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c2e:	68 c0 01 00 00       	push   $0x1c0
80104c33:	6a 00                	push   $0x0
80104c35:	50                   	push   %eax
        p->parent = 0;
80104c36:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c3d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c41:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c48:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c4f:	00 00 00 
        p->swapFile = 0;
80104c52:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104c59:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104c60:	00 00 00 
        p->free_tail = 0;
80104c63:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104c6a:	00 00 00 
        p->queue_head = 0;
80104c6d:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104c74:	00 00 00 
        p->queue_tail = 0;
80104c77:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104c7e:	00 00 00 
        p->numswappages = 0;
80104c81:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104c88:	00 00 00 
        p-> nummemorypages = 0;
80104c8b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104c92:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c95:	e8 76 06 00 00       	call   80105310 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104c9a:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104ca0:	83 c4 0c             	add    $0xc,%esp
80104ca3:	68 c0 01 00 00       	push   $0x1c0
80104ca8:	6a 00                	push   $0x0
80104caa:	50                   	push   %eax
80104cab:	e8 60 06 00 00       	call   80105310 <memset>
        release(&ptable.lock);
80104cb0:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104cb7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104cbe:	e8 fd 05 00 00       	call   801052c0 <release>
        return pid;
80104cc3:	83 c4 10             	add    $0x10,%esp
}
80104cc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cc9:	89 f0                	mov    %esi,%eax
80104ccb:	5b                   	pop    %ebx
80104ccc:	5e                   	pop    %esi
80104ccd:	5d                   	pop    %ebp
80104cce:	c3                   	ret    
      release(&ptable.lock);
80104ccf:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104cd2:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104cd7:	68 00 61 18 80       	push   $0x80186100
80104cdc:	e8 df 05 00 00       	call   801052c0 <release>
      return -1;
80104ce1:	83 c4 10             	add    $0x10,%esp
80104ce4:	eb e0                	jmp    80104cc6 <wait+0x156>
80104ce6:	8d 76 00             	lea    0x0(%esi),%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 10             	sub    $0x10,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104cfa:	68 00 61 18 80       	push   $0x80186100
80104cff:	e8 fc 04 00 00       	call   80105200 <acquire>
80104d04:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d07:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d0c:	eb 0e                	jmp    80104d1c <wakeup+0x2c>
80104d0e:	66 90                	xchg   %ax,%ax
80104d10:	05 30 04 00 00       	add    $0x430,%eax
80104d15:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d1a:	73 1e                	jae    80104d3a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d1c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d20:	75 ee                	jne    80104d10 <wakeup+0x20>
80104d22:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d25:	75 e9                	jne    80104d10 <wakeup+0x20>
      p->state = RUNNABLE;
80104d27:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d2e:	05 30 04 00 00       	add    $0x430,%eax
80104d33:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d38:	72 e2                	jb     80104d1c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d3a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d44:	c9                   	leave  
  release(&ptable.lock);
80104d45:	e9 76 05 00 00       	jmp    801052c0 <release>
80104d4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d50 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	53                   	push   %ebx
80104d54:	83 ec 10             	sub    $0x10,%esp
80104d57:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d5a:	68 00 61 18 80       	push   $0x80186100
80104d5f:	e8 9c 04 00 00       	call   80105200 <acquire>
80104d64:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d67:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d6c:	eb 0e                	jmp    80104d7c <kill+0x2c>
80104d6e:	66 90                	xchg   %ax,%ax
80104d70:	05 30 04 00 00       	add    $0x430,%eax
80104d75:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d7a:	73 34                	jae    80104db0 <kill+0x60>
    if(p->pid == pid){
80104d7c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d7f:	75 ef                	jne    80104d70 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d81:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104d85:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104d8c:	75 07                	jne    80104d95 <kill+0x45>
        p->state = RUNNABLE;
80104d8e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d95:	83 ec 0c             	sub    $0xc,%esp
80104d98:	68 00 61 18 80       	push   $0x80186100
80104d9d:	e8 1e 05 00 00       	call   801052c0 <release>
      return 0;
80104da2:	83 c4 10             	add    $0x10,%esp
80104da5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104daa:	c9                   	leave  
80104dab:	c3                   	ret    
80104dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104db0:	83 ec 0c             	sub    $0xc,%esp
80104db3:	68 00 61 18 80       	push   $0x80186100
80104db8:	e8 03 05 00 00       	call   801052c0 <release>
  return -1;
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dc8:	c9                   	leave  
80104dc9:	c3                   	ret    
80104dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dd0 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104dd4:	31 db                	xor    %ebx,%ebx
{
80104dd6:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104dd9:	68 00 61 18 80       	push   $0x80186100
80104dde:	e8 1d 04 00 00       	call   80105200 <acquire>
80104de3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104de6:	ba 34 61 18 80       	mov    $0x80186134,%edx
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104deb:	b9 10 00 00 00       	mov    $0x10,%ecx
    if(p->state == UNUSED)
80104df0:	8b 42 0c             	mov    0xc(%edx),%eax
80104df3:	85 c0                	test   %eax,%eax
80104df5:	74 0a                	je     80104e01 <getCurrentFreePages+0x31>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104df7:	89 c8                	mov    %ecx,%eax
80104df9:	2b 82 08 04 00 00    	sub    0x408(%edx),%eax
80104dff:	01 c3                	add    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e01:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e07:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e0d:	72 e1                	jb     80104df0 <getCurrentFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104e0f:	83 ec 0c             	sub    $0xc,%esp
80104e12:	68 00 61 18 80       	push   $0x80186100
80104e17:	e8 a4 04 00 00       	call   801052c0 <release>
  return sum;
}
80104e1c:	89 d8                	mov    %ebx,%eax
80104e1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e21:	c9                   	leave  
80104e22:	c3                   	ret    
80104e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80104e34:	31 db                	xor    %ebx,%ebx
{
80104e36:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e39:	68 00 61 18 80       	push   $0x80186100
80104e3e:	e8 bd 03 00 00       	call   80105200 <acquire>
80104e43:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e46:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104e4b:	90                   	nop
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80104e50:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104e54:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e57:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e5d:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e63:	72 eb                	jb     80104e50 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80104e65:	83 ec 0c             	sub    $0xc,%esp
80104e68:	68 00 61 18 80       	push   $0x80186100
80104e6d:	e8 4e 04 00 00       	call   801052c0 <release>
  return pcount * MAX_PSYC_PAGES;
80104e72:	89 d8                	mov    %ebx,%eax
80104e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return pcount * MAX_PSYC_PAGES;
80104e77:	c1 e0 04             	shl    $0x4,%eax
80104e7a:	c9                   	leave  
80104e7b:	c3                   	ret    
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <procdump>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
80104e86:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e89:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104e8e:	83 ec 3c             	sub    $0x3c,%esp
80104e91:	eb 41                	jmp    80104ed4 <procdump+0x54>
80104e93:	90                   	nop
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80104e98:	e8 93 ff ff ff       	call   80104e30 <getTotalFreePages>
80104e9d:	89 c7                	mov    %eax,%edi
80104e9f:	e8 2c ff ff ff       	call   80104dd0 <getCurrentFreePages>
80104ea4:	83 ec 04             	sub    $0x4,%esp
80104ea7:	57                   	push   %edi
80104ea8:	50                   	push   %eax
80104ea9:	68 ef 95 10 80       	push   $0x801095ef
80104eae:	e8 ad b7 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104eb3:	c7 04 24 c0 9a 10 80 	movl   $0x80109ac0,(%esp)
80104eba:	e8 a1 b7 ff ff       	call   80100660 <cprintf>
80104ebf:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ec2:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104ec8:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104ece:	0f 83 ac 00 00 00    	jae    80104f80 <procdump+0x100>
    if(p->state == UNUSED)
80104ed4:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ed7:	85 c0                	test   %eax,%eax
80104ed9:	74 e7                	je     80104ec2 <procdump+0x42>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104edb:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104ede:	ba eb 95 10 80       	mov    $0x801095eb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ee3:	77 11                	ja     80104ef6 <procdump+0x76>
80104ee5:	8b 14 85 fc 96 10 80 	mov    -0x7fef6904(,%eax,4),%edx
      state = "???";
80104eec:	b8 eb 95 10 80       	mov    $0x801095eb,%eax
80104ef1:	85 d2                	test   %edx,%edx
80104ef3:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104ef6:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104ef9:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104eff:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104f05:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104f0b:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104f11:	50                   	push   %eax
80104f12:	52                   	push   %edx
80104f13:	ff 73 10             	pushl  0x10(%ebx)
80104f16:	68 94 96 10 80       	push   $0x80109694
80104f1b:	e8 40 b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104f20:	83 c4 20             	add    $0x20,%esp
80104f23:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104f27:	0f 85 6b ff ff ff    	jne    80104e98 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f2d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f30:	83 ec 08             	sub    $0x8,%esp
80104f33:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104f36:	50                   	push   %eax
80104f37:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f3a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f3d:	83 c0 08             	add    $0x8,%eax
80104f40:	50                   	push   %eax
80104f41:	e8 9a 01 00 00       	call   801050e0 <getcallerpcs>
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104f50:	8b 17                	mov    (%edi),%edx
80104f52:	85 d2                	test   %edx,%edx
80104f54:	0f 84 3e ff ff ff    	je     80104e98 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104f5a:	83 ec 08             	sub    $0x8,%esp
80104f5d:	83 c7 04             	add    $0x4,%edi
80104f60:	52                   	push   %edx
80104f61:	68 41 8f 10 80       	push   $0x80108f41
80104f66:	e8 f5 b6 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104f6b:	83 c4 10             	add    $0x10,%esp
80104f6e:	39 fe                	cmp    %edi,%esi
80104f70:	75 de                	jne    80104f50 <procdump+0xd0>
80104f72:	e9 21 ff ff ff       	jmp    80104e98 <procdump+0x18>
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104f80:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f83:	5b                   	pop    %ebx
80104f84:	5e                   	pop    %esi
80104f85:	5f                   	pop    %edi
80104f86:	5d                   	pop    %ebp
80104f87:	c3                   	ret    
80104f88:	66 90                	xchg   %ax,%ax
80104f8a:	66 90                	xchg   %ax,%ax
80104f8c:	66 90                	xchg   %ax,%ax
80104f8e:	66 90                	xchg   %ax,%ax

80104f90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	53                   	push   %ebx
80104f94:	83 ec 0c             	sub    $0xc,%esp
80104f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104f9a:	68 14 97 10 80       	push   $0x80109714
80104f9f:	8d 43 04             	lea    0x4(%ebx),%eax
80104fa2:	50                   	push   %eax
80104fa3:	e8 18 01 00 00       	call   801050c0 <initlock>
  lk->name = name;
80104fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104fab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104fb1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104fb4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104fbb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fc1:	c9                   	leave  
80104fc2:	c3                   	ret    
80104fc3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104fd0:	55                   	push   %ebp
80104fd1:	89 e5                	mov    %esp,%ebp
80104fd3:	56                   	push   %esi
80104fd4:	53                   	push   %ebx
80104fd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	8d 73 04             	lea    0x4(%ebx),%esi
80104fde:	56                   	push   %esi
80104fdf:	e8 1c 02 00 00       	call   80105200 <acquire>
  while (lk->locked) {
80104fe4:	8b 13                	mov    (%ebx),%edx
80104fe6:	83 c4 10             	add    $0x10,%esp
80104fe9:	85 d2                	test   %edx,%edx
80104feb:	74 16                	je     80105003 <acquiresleep+0x33>
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104ff0:	83 ec 08             	sub    $0x8,%esp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	e8 b6 fa ff ff       	call   80104ab0 <sleep>
  while (lk->locked) {
80104ffa:	8b 03                	mov    (%ebx),%eax
80104ffc:	83 c4 10             	add    $0x10,%esp
80104fff:	85 c0                	test   %eax,%eax
80105001:	75 ed                	jne    80104ff0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105003:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105009:	e8 b2 f2 ff ff       	call   801042c0 <myproc>
8010500e:	8b 40 10             	mov    0x10(%eax),%eax
80105011:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105014:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105017:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010501a:	5b                   	pop    %ebx
8010501b:	5e                   	pop    %esi
8010501c:	5d                   	pop    %ebp
  release(&lk->lk);
8010501d:	e9 9e 02 00 00       	jmp    801052c0 <release>
80105022:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105030 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105030:	55                   	push   %ebp
80105031:	89 e5                	mov    %esp,%ebp
80105033:	56                   	push   %esi
80105034:	53                   	push   %ebx
80105035:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105038:	83 ec 0c             	sub    $0xc,%esp
8010503b:	8d 73 04             	lea    0x4(%ebx),%esi
8010503e:	56                   	push   %esi
8010503f:	e8 bc 01 00 00       	call   80105200 <acquire>
  lk->locked = 0;
80105044:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010504a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105051:	89 1c 24             	mov    %ebx,(%esp)
80105054:	e8 97 fc ff ff       	call   80104cf0 <wakeup>
  release(&lk->lk);
80105059:	89 75 08             	mov    %esi,0x8(%ebp)
8010505c:	83 c4 10             	add    $0x10,%esp
}
8010505f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105062:	5b                   	pop    %ebx
80105063:	5e                   	pop    %esi
80105064:	5d                   	pop    %ebp
  release(&lk->lk);
80105065:	e9 56 02 00 00       	jmp    801052c0 <release>
8010506a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105070 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	57                   	push   %edi
80105074:	56                   	push   %esi
80105075:	53                   	push   %ebx
80105076:	31 ff                	xor    %edi,%edi
80105078:	83 ec 18             	sub    $0x18,%esp
8010507b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010507e:	8d 73 04             	lea    0x4(%ebx),%esi
80105081:	56                   	push   %esi
80105082:	e8 79 01 00 00       	call   80105200 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105087:	8b 03                	mov    (%ebx),%eax
80105089:	83 c4 10             	add    $0x10,%esp
8010508c:	85 c0                	test   %eax,%eax
8010508e:	74 13                	je     801050a3 <holdingsleep+0x33>
80105090:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105093:	e8 28 f2 ff ff       	call   801042c0 <myproc>
80105098:	39 58 10             	cmp    %ebx,0x10(%eax)
8010509b:	0f 94 c0             	sete   %al
8010509e:	0f b6 c0             	movzbl %al,%eax
801050a1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801050a3:	83 ec 0c             	sub    $0xc,%esp
801050a6:	56                   	push   %esi
801050a7:	e8 14 02 00 00       	call   801052c0 <release>
  return r;
}
801050ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050af:	89 f8                	mov    %edi,%eax
801050b1:	5b                   	pop    %ebx
801050b2:	5e                   	pop    %esi
801050b3:	5f                   	pop    %edi
801050b4:	5d                   	pop    %ebp
801050b5:	c3                   	ret    
801050b6:	66 90                	xchg   %ax,%ax
801050b8:	66 90                	xchg   %ax,%ax
801050ba:	66 90                	xchg   %ax,%ax
801050bc:	66 90                	xchg   %ax,%ax
801050be:	66 90                	xchg   %ax,%ax

801050c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801050c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801050c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801050cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801050d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050d9:	5d                   	pop    %ebp
801050da:	c3                   	ret    
801050db:	90                   	nop
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801050e0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050e1:	31 d2                	xor    %edx,%edx
{
801050e3:	89 e5                	mov    %esp,%ebp
801050e5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801050e6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801050e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801050ec:	83 e8 08             	sub    $0x8,%eax
801050ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050f0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801050f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050fc:	77 1a                	ja     80105118 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050fe:	8b 58 04             	mov    0x4(%eax),%ebx
80105101:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105104:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105107:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105109:	83 fa 0a             	cmp    $0xa,%edx
8010510c:	75 e2                	jne    801050f0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010510e:	5b                   	pop    %ebx
8010510f:	5d                   	pop    %ebp
80105110:	c3                   	ret    
80105111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105118:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010511b:	83 c1 28             	add    $0x28,%ecx
8010511e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105120:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105126:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105129:	39 c1                	cmp    %eax,%ecx
8010512b:	75 f3                	jne    80105120 <getcallerpcs+0x40>
}
8010512d:	5b                   	pop    %ebx
8010512e:	5d                   	pop    %ebp
8010512f:	c3                   	ret    

80105130 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	53                   	push   %ebx
80105134:	83 ec 04             	sub    $0x4,%esp
80105137:	9c                   	pushf  
80105138:	5b                   	pop    %ebx
  asm volatile("cli");
80105139:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010513a:	e8 e1 f0 ff ff       	call   80104220 <mycpu>
8010513f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105145:	85 c0                	test   %eax,%eax
80105147:	75 11                	jne    8010515a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105149:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010514f:	e8 cc f0 ff ff       	call   80104220 <mycpu>
80105154:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010515a:	e8 c1 f0 ff ff       	call   80104220 <mycpu>
8010515f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105166:	83 c4 04             	add    $0x4,%esp
80105169:	5b                   	pop    %ebx
8010516a:	5d                   	pop    %ebp
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <popcli>:

void
popcli(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105176:	9c                   	pushf  
80105177:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105178:	f6 c4 02             	test   $0x2,%ah
8010517b:	75 35                	jne    801051b2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010517d:	e8 9e f0 ff ff       	call   80104220 <mycpu>
80105182:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105189:	78 34                	js     801051bf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010518b:	e8 90 f0 ff ff       	call   80104220 <mycpu>
80105190:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105196:	85 d2                	test   %edx,%edx
80105198:	74 06                	je     801051a0 <popcli+0x30>
    sti();
}
8010519a:	c9                   	leave  
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051a0:	e8 7b f0 ff ff       	call   80104220 <mycpu>
801051a5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051ab:	85 c0                	test   %eax,%eax
801051ad:	74 eb                	je     8010519a <popcli+0x2a>
  asm volatile("sti");
801051af:	fb                   	sti    
}
801051b0:	c9                   	leave  
801051b1:	c3                   	ret    
    panic("popcli - interruptible");
801051b2:	83 ec 0c             	sub    $0xc,%esp
801051b5:	68 1f 97 10 80       	push   $0x8010971f
801051ba:	e8 d1 b1 ff ff       	call   80100390 <panic>
    panic("popcli");
801051bf:	83 ec 0c             	sub    $0xc,%esp
801051c2:	68 36 97 10 80       	push   $0x80109736
801051c7:	e8 c4 b1 ff ff       	call   80100390 <panic>
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051d0 <holding>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
801051d5:	8b 75 08             	mov    0x8(%ebp),%esi
801051d8:	31 db                	xor    %ebx,%ebx
  pushcli();
801051da:	e8 51 ff ff ff       	call   80105130 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051df:	8b 06                	mov    (%esi),%eax
801051e1:	85 c0                	test   %eax,%eax
801051e3:	74 10                	je     801051f5 <holding+0x25>
801051e5:	8b 5e 08             	mov    0x8(%esi),%ebx
801051e8:	e8 33 f0 ff ff       	call   80104220 <mycpu>
801051ed:	39 c3                	cmp    %eax,%ebx
801051ef:	0f 94 c3             	sete   %bl
801051f2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801051f5:	e8 76 ff ff ff       	call   80105170 <popcli>
}
801051fa:	89 d8                	mov    %ebx,%eax
801051fc:	5b                   	pop    %ebx
801051fd:	5e                   	pop    %esi
801051fe:	5d                   	pop    %ebp
801051ff:	c3                   	ret    

80105200 <acquire>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105205:	e8 26 ff ff ff       	call   80105130 <pushcli>
  if(holding(lk))
8010520a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010520d:	83 ec 0c             	sub    $0xc,%esp
80105210:	53                   	push   %ebx
80105211:	e8 ba ff ff ff       	call   801051d0 <holding>
80105216:	83 c4 10             	add    $0x10,%esp
80105219:	85 c0                	test   %eax,%eax
8010521b:	0f 85 83 00 00 00    	jne    801052a4 <acquire+0xa4>
80105221:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105223:	ba 01 00 00 00       	mov    $0x1,%edx
80105228:	eb 09                	jmp    80105233 <acquire+0x33>
8010522a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105230:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105233:	89 d0                	mov    %edx,%eax
80105235:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105238:	85 c0                	test   %eax,%eax
8010523a:	75 f4                	jne    80105230 <acquire+0x30>
  __sync_synchronize();
8010523c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105241:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105244:	e8 d7 ef ff ff       	call   80104220 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105249:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010524c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010524f:	89 e8                	mov    %ebp,%eax
80105251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105258:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010525e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105264:	77 1a                	ja     80105280 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105266:	8b 48 04             	mov    0x4(%eax),%ecx
80105269:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010526c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010526f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105271:	83 fe 0a             	cmp    $0xa,%esi
80105274:	75 e2                	jne    80105258 <acquire+0x58>
}
80105276:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5d                   	pop    %ebp
8010527c:	c3                   	ret    
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
80105280:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105283:	83 c2 28             	add    $0x28,%edx
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105290:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105296:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105299:	39 d0                	cmp    %edx,%eax
8010529b:	75 f3                	jne    80105290 <acquire+0x90>
}
8010529d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a0:	5b                   	pop    %ebx
801052a1:	5e                   	pop    %esi
801052a2:	5d                   	pop    %ebp
801052a3:	c3                   	ret    
    panic("acquire");
801052a4:	83 ec 0c             	sub    $0xc,%esp
801052a7:	68 3d 97 10 80       	push   $0x8010973d
801052ac:	e8 df b0 ff ff       	call   80100390 <panic>
801052b1:	eb 0d                	jmp    801052c0 <release>
801052b3:	90                   	nop
801052b4:	90                   	nop
801052b5:	90                   	nop
801052b6:	90                   	nop
801052b7:	90                   	nop
801052b8:	90                   	nop
801052b9:	90                   	nop
801052ba:	90                   	nop
801052bb:	90                   	nop
801052bc:	90                   	nop
801052bd:	90                   	nop
801052be:	90                   	nop
801052bf:	90                   	nop

801052c0 <release>:
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	53                   	push   %ebx
801052c4:	83 ec 10             	sub    $0x10,%esp
801052c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801052ca:	53                   	push   %ebx
801052cb:	e8 00 ff ff ff       	call   801051d0 <holding>
801052d0:	83 c4 10             	add    $0x10,%esp
801052d3:	85 c0                	test   %eax,%eax
801052d5:	74 22                	je     801052f9 <release+0x39>
  lk->pcs[0] = 0;
801052d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801052de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801052e5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801052ea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801052f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052f3:	c9                   	leave  
  popcli();
801052f4:	e9 77 fe ff ff       	jmp    80105170 <popcli>
    panic("release");
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	68 45 97 10 80       	push   $0x80109745
80105301:	e8 8a b0 ff ff       	call   80100390 <panic>
80105306:	66 90                	xchg   %ax,%ax
80105308:	66 90                	xchg   %ax,%ax
8010530a:	66 90                	xchg   %ax,%ax
8010530c:	66 90                	xchg   %ax,%ax
8010530e:	66 90                	xchg   %ax,%ax

80105310 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	53                   	push   %ebx
80105315:	8b 55 08             	mov    0x8(%ebp),%edx
80105318:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010531b:	f6 c2 03             	test   $0x3,%dl
8010531e:	75 05                	jne    80105325 <memset+0x15>
80105320:	f6 c1 03             	test   $0x3,%cl
80105323:	74 13                	je     80105338 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105325:	89 d7                	mov    %edx,%edi
80105327:	8b 45 0c             	mov    0xc(%ebp),%eax
8010532a:	fc                   	cld    
8010532b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010532d:	5b                   	pop    %ebx
8010532e:	89 d0                	mov    %edx,%eax
80105330:	5f                   	pop    %edi
80105331:	5d                   	pop    %ebp
80105332:	c3                   	ret    
80105333:	90                   	nop
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105338:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010533c:	c1 e9 02             	shr    $0x2,%ecx
8010533f:	89 f8                	mov    %edi,%eax
80105341:	89 fb                	mov    %edi,%ebx
80105343:	c1 e0 18             	shl    $0x18,%eax
80105346:	c1 e3 10             	shl    $0x10,%ebx
80105349:	09 d8                	or     %ebx,%eax
8010534b:	09 f8                	or     %edi,%eax
8010534d:	c1 e7 08             	shl    $0x8,%edi
80105350:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105352:	89 d7                	mov    %edx,%edi
80105354:	fc                   	cld    
80105355:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105357:	5b                   	pop    %ebx
80105358:	89 d0                	mov    %edx,%eax
8010535a:	5f                   	pop    %edi
8010535b:	5d                   	pop    %ebp
8010535c:	c3                   	ret    
8010535d:	8d 76 00             	lea    0x0(%esi),%esi

80105360 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	56                   	push   %esi
80105365:	53                   	push   %ebx
80105366:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105369:	8b 75 08             	mov    0x8(%ebp),%esi
8010536c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010536f:	85 db                	test   %ebx,%ebx
80105371:	74 29                	je     8010539c <memcmp+0x3c>
    if(*s1 != *s2)
80105373:	0f b6 16             	movzbl (%esi),%edx
80105376:	0f b6 0f             	movzbl (%edi),%ecx
80105379:	38 d1                	cmp    %dl,%cl
8010537b:	75 2b                	jne    801053a8 <memcmp+0x48>
8010537d:	b8 01 00 00 00       	mov    $0x1,%eax
80105382:	eb 14                	jmp    80105398 <memcmp+0x38>
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105388:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010538c:	83 c0 01             	add    $0x1,%eax
8010538f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105394:	38 ca                	cmp    %cl,%dl
80105396:	75 10                	jne    801053a8 <memcmp+0x48>
  while(n-- > 0){
80105398:	39 d8                	cmp    %ebx,%eax
8010539a:	75 ec                	jne    80105388 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010539c:	5b                   	pop    %ebx
  return 0;
8010539d:	31 c0                	xor    %eax,%eax
}
8010539f:	5e                   	pop    %esi
801053a0:	5f                   	pop    %edi
801053a1:	5d                   	pop    %ebp
801053a2:	c3                   	ret    
801053a3:	90                   	nop
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801053a8:	0f b6 c2             	movzbl %dl,%eax
}
801053ab:	5b                   	pop    %ebx
      return *s1 - *s2;
801053ac:	29 c8                	sub    %ecx,%eax
}
801053ae:	5e                   	pop    %esi
801053af:	5f                   	pop    %edi
801053b0:	5d                   	pop    %ebp
801053b1:	c3                   	ret    
801053b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	56                   	push   %esi
801053c4:	53                   	push   %ebx
801053c5:	8b 45 08             	mov    0x8(%ebp),%eax
801053c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053cb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801053ce:	39 c3                	cmp    %eax,%ebx
801053d0:	73 26                	jae    801053f8 <memmove+0x38>
801053d2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801053d5:	39 c8                	cmp    %ecx,%eax
801053d7:	73 1f                	jae    801053f8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801053d9:	85 f6                	test   %esi,%esi
801053db:	8d 56 ff             	lea    -0x1(%esi),%edx
801053de:	74 0f                	je     801053ef <memmove+0x2f>
      *--d = *--s;
801053e0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801053e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801053e7:	83 ea 01             	sub    $0x1,%edx
801053ea:	83 fa ff             	cmp    $0xffffffff,%edx
801053ed:	75 f1                	jne    801053e0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801053ef:	5b                   	pop    %ebx
801053f0:	5e                   	pop    %esi
801053f1:	5d                   	pop    %ebp
801053f2:	c3                   	ret    
801053f3:	90                   	nop
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801053f8:	31 d2                	xor    %edx,%edx
801053fa:	85 f6                	test   %esi,%esi
801053fc:	74 f1                	je     801053ef <memmove+0x2f>
801053fe:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105400:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105404:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105407:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010540a:	39 d6                	cmp    %edx,%esi
8010540c:	75 f2                	jne    80105400 <memmove+0x40>
}
8010540e:	5b                   	pop    %ebx
8010540f:	5e                   	pop    %esi
80105410:	5d                   	pop    %ebp
80105411:	c3                   	ret    
80105412:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105423:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105424:	eb 9a                	jmp    801053c0 <memmove>
80105426:	8d 76 00             	lea    0x0(%esi),%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	57                   	push   %edi
80105434:	56                   	push   %esi
80105435:	8b 7d 10             	mov    0x10(%ebp),%edi
80105438:	53                   	push   %ebx
80105439:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010543c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010543f:	85 ff                	test   %edi,%edi
80105441:	74 2f                	je     80105472 <strncmp+0x42>
80105443:	0f b6 01             	movzbl (%ecx),%eax
80105446:	0f b6 1e             	movzbl (%esi),%ebx
80105449:	84 c0                	test   %al,%al
8010544b:	74 37                	je     80105484 <strncmp+0x54>
8010544d:	38 c3                	cmp    %al,%bl
8010544f:	75 33                	jne    80105484 <strncmp+0x54>
80105451:	01 f7                	add    %esi,%edi
80105453:	eb 13                	jmp    80105468 <strncmp+0x38>
80105455:	8d 76 00             	lea    0x0(%esi),%esi
80105458:	0f b6 01             	movzbl (%ecx),%eax
8010545b:	84 c0                	test   %al,%al
8010545d:	74 21                	je     80105480 <strncmp+0x50>
8010545f:	0f b6 1a             	movzbl (%edx),%ebx
80105462:	89 d6                	mov    %edx,%esi
80105464:	38 d8                	cmp    %bl,%al
80105466:	75 1c                	jne    80105484 <strncmp+0x54>
    n--, p++, q++;
80105468:	8d 56 01             	lea    0x1(%esi),%edx
8010546b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010546e:	39 fa                	cmp    %edi,%edx
80105470:	75 e6                	jne    80105458 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105472:	5b                   	pop    %ebx
    return 0;
80105473:	31 c0                	xor    %eax,%eax
}
80105475:	5e                   	pop    %esi
80105476:	5f                   	pop    %edi
80105477:	5d                   	pop    %ebp
80105478:	c3                   	ret    
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105480:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105484:	29 d8                	sub    %ebx,%eax
}
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	56                   	push   %esi
80105494:	53                   	push   %ebx
80105495:	8b 45 08             	mov    0x8(%ebp),%eax
80105498:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010549b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010549e:	89 c2                	mov    %eax,%edx
801054a0:	eb 19                	jmp    801054bb <strncpy+0x2b>
801054a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054a8:	83 c3 01             	add    $0x1,%ebx
801054ab:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801054af:	83 c2 01             	add    $0x1,%edx
801054b2:	84 c9                	test   %cl,%cl
801054b4:	88 4a ff             	mov    %cl,-0x1(%edx)
801054b7:	74 09                	je     801054c2 <strncpy+0x32>
801054b9:	89 f1                	mov    %esi,%ecx
801054bb:	85 c9                	test   %ecx,%ecx
801054bd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801054c0:	7f e6                	jg     801054a8 <strncpy+0x18>
    ;
  while(n-- > 0)
801054c2:	31 c9                	xor    %ecx,%ecx
801054c4:	85 f6                	test   %esi,%esi
801054c6:	7e 17                	jle    801054df <strncpy+0x4f>
801054c8:	90                   	nop
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801054d0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801054d4:	89 f3                	mov    %esi,%ebx
801054d6:	83 c1 01             	add    $0x1,%ecx
801054d9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801054db:	85 db                	test   %ebx,%ebx
801054dd:	7f f1                	jg     801054d0 <strncpy+0x40>
  return os;
}
801054df:	5b                   	pop    %ebx
801054e0:	5e                   	pop    %esi
801054e1:	5d                   	pop    %ebp
801054e2:	c3                   	ret    
801054e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801054f8:	8b 45 08             	mov    0x8(%ebp),%eax
801054fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801054fe:	85 c9                	test   %ecx,%ecx
80105500:	7e 26                	jle    80105528 <safestrcpy+0x38>
80105502:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105506:	89 c1                	mov    %eax,%ecx
80105508:	eb 17                	jmp    80105521 <safestrcpy+0x31>
8010550a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105510:	83 c2 01             	add    $0x1,%edx
80105513:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105517:	83 c1 01             	add    $0x1,%ecx
8010551a:	84 db                	test   %bl,%bl
8010551c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010551f:	74 04                	je     80105525 <safestrcpy+0x35>
80105521:	39 f2                	cmp    %esi,%edx
80105523:	75 eb                	jne    80105510 <safestrcpy+0x20>
    ;
  *s = 0;
80105525:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105528:	5b                   	pop    %ebx
80105529:	5e                   	pop    %esi
8010552a:	5d                   	pop    %ebp
8010552b:	c3                   	ret    
8010552c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105530 <strlen>:

int
strlen(const char *s)
{
80105530:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105531:	31 c0                	xor    %eax,%eax
{
80105533:	89 e5                	mov    %esp,%ebp
80105535:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105538:	80 3a 00             	cmpb   $0x0,(%edx)
8010553b:	74 0c                	je     80105549 <strlen+0x19>
8010553d:	8d 76 00             	lea    0x0(%esi),%esi
80105540:	83 c0 01             	add    $0x1,%eax
80105543:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105547:	75 f7                	jne    80105540 <strlen+0x10>
    ;
  return n;
}
80105549:	5d                   	pop    %ebp
8010554a:	c3                   	ret    

8010554b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010554b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010554f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105553:	55                   	push   %ebp
  pushl %ebx
80105554:	53                   	push   %ebx
  pushl %esi
80105555:	56                   	push   %esi
  pushl %edi
80105556:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105557:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105559:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010555b:	5f                   	pop    %edi
  popl %esi
8010555c:	5e                   	pop    %esi
  popl %ebx
8010555d:	5b                   	pop    %ebx
  popl %ebp
8010555e:	5d                   	pop    %ebp
  ret
8010555f:	c3                   	ret    

80105560 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 04             	sub    $0x4,%esp
80105567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010556a:	e8 51 ed ff ff       	call   801042c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010556f:	8b 00                	mov    (%eax),%eax
80105571:	39 d8                	cmp    %ebx,%eax
80105573:	76 1b                	jbe    80105590 <fetchint+0x30>
80105575:	8d 53 04             	lea    0x4(%ebx),%edx
80105578:	39 d0                	cmp    %edx,%eax
8010557a:	72 14                	jb     80105590 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010557c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010557f:	8b 13                	mov    (%ebx),%edx
80105581:	89 10                	mov    %edx,(%eax)
  return 0;
80105583:	31 c0                	xor    %eax,%eax
}
80105585:	83 c4 04             	add    $0x4,%esp
80105588:	5b                   	pop    %ebx
80105589:	5d                   	pop    %ebp
8010558a:	c3                   	ret    
8010558b:	90                   	nop
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105595:	eb ee                	jmp    80105585 <fetchint+0x25>
80105597:	89 f6                	mov    %esi,%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	53                   	push   %ebx
801055a4:	83 ec 04             	sub    $0x4,%esp
801055a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801055aa:	e8 11 ed ff ff       	call   801042c0 <myproc>

  if(addr >= curproc->sz)
801055af:	39 18                	cmp    %ebx,(%eax)
801055b1:	76 29                	jbe    801055dc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801055b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055b6:	89 da                	mov    %ebx,%edx
801055b8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801055ba:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801055bc:	39 c3                	cmp    %eax,%ebx
801055be:	73 1c                	jae    801055dc <fetchstr+0x3c>
    if(*s == 0)
801055c0:	80 3b 00             	cmpb   $0x0,(%ebx)
801055c3:	75 10                	jne    801055d5 <fetchstr+0x35>
801055c5:	eb 39                	jmp    80105600 <fetchstr+0x60>
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055d0:	80 3a 00             	cmpb   $0x0,(%edx)
801055d3:	74 1b                	je     801055f0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801055d5:	83 c2 01             	add    $0x1,%edx
801055d8:	39 d0                	cmp    %edx,%eax
801055da:	77 f4                	ja     801055d0 <fetchstr+0x30>
    return -1;
801055dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801055e1:	83 c4 04             	add    $0x4,%esp
801055e4:	5b                   	pop    %ebx
801055e5:	5d                   	pop    %ebp
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055f0:	83 c4 04             	add    $0x4,%esp
801055f3:	89 d0                	mov    %edx,%eax
801055f5:	29 d8                	sub    %ebx,%eax
801055f7:	5b                   	pop    %ebx
801055f8:	5d                   	pop    %ebp
801055f9:	c3                   	ret    
801055fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105600:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105602:	eb dd                	jmp    801055e1 <fetchstr+0x41>
80105604:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010560a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105610 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	56                   	push   %esi
80105614:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105615:	e8 a6 ec ff ff       	call   801042c0 <myproc>
8010561a:	8b 40 18             	mov    0x18(%eax),%eax
8010561d:	8b 55 08             	mov    0x8(%ebp),%edx
80105620:	8b 40 44             	mov    0x44(%eax),%eax
80105623:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105626:	e8 95 ec ff ff       	call   801042c0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010562b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010562d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105630:	39 c6                	cmp    %eax,%esi
80105632:	73 1c                	jae    80105650 <argint+0x40>
80105634:	8d 53 08             	lea    0x8(%ebx),%edx
80105637:	39 d0                	cmp    %edx,%eax
80105639:	72 15                	jb     80105650 <argint+0x40>
  *ip = *(int*)(addr);
8010563b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010563e:	8b 53 04             	mov    0x4(%ebx),%edx
80105641:	89 10                	mov    %edx,(%eax)
  return 0;
80105643:	31 c0                	xor    %eax,%eax
}
80105645:	5b                   	pop    %ebx
80105646:	5e                   	pop    %esi
80105647:	5d                   	pop    %ebp
80105648:	c3                   	ret    
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105650:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105655:	eb ee                	jmp    80105645 <argint+0x35>
80105657:	89 f6                	mov    %esi,%esi
80105659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105660 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
80105665:	83 ec 10             	sub    $0x10,%esp
80105668:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010566b:	e8 50 ec ff ff       	call   801042c0 <myproc>
80105670:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105672:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105675:	83 ec 08             	sub    $0x8,%esp
80105678:	50                   	push   %eax
80105679:	ff 75 08             	pushl  0x8(%ebp)
8010567c:	e8 8f ff ff ff       	call   80105610 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105681:	83 c4 10             	add    $0x10,%esp
80105684:	85 c0                	test   %eax,%eax
80105686:	78 28                	js     801056b0 <argptr+0x50>
80105688:	85 db                	test   %ebx,%ebx
8010568a:	78 24                	js     801056b0 <argptr+0x50>
8010568c:	8b 16                	mov    (%esi),%edx
8010568e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105691:	39 c2                	cmp    %eax,%edx
80105693:	76 1b                	jbe    801056b0 <argptr+0x50>
80105695:	01 c3                	add    %eax,%ebx
80105697:	39 da                	cmp    %ebx,%edx
80105699:	72 15                	jb     801056b0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010569b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010569e:	89 02                	mov    %eax,(%edx)
  return 0;
801056a0:	31 c0                	xor    %eax,%eax
}
801056a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056a5:	5b                   	pop    %ebx
801056a6:	5e                   	pop    %esi
801056a7:	5d                   	pop    %ebp
801056a8:	c3                   	ret    
801056a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b5:	eb eb                	jmp    801056a2 <argptr+0x42>
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c9:	50                   	push   %eax
801056ca:	ff 75 08             	pushl  0x8(%ebp)
801056cd:	e8 3e ff ff ff       	call   80105610 <argint>
801056d2:	83 c4 10             	add    $0x10,%esp
801056d5:	85 c0                	test   %eax,%eax
801056d7:	78 17                	js     801056f0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801056d9:	83 ec 08             	sub    $0x8,%esp
801056dc:	ff 75 0c             	pushl  0xc(%ebp)
801056df:	ff 75 f4             	pushl  -0xc(%ebp)
801056e2:	e8 b9 fe ff ff       	call   801055a0 <fetchstr>
801056e7:	83 c4 10             	add    $0x10,%esp
}
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	53                   	push   %ebx
80105704:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105707:	e8 b4 eb ff ff       	call   801042c0 <myproc>
8010570c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010570e:	8b 40 18             	mov    0x18(%eax),%eax
80105711:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105714:	8d 50 ff             	lea    -0x1(%eax),%edx
80105717:	83 fa 16             	cmp    $0x16,%edx
8010571a:	77 1c                	ja     80105738 <syscall+0x38>
8010571c:	8b 14 85 80 97 10 80 	mov    -0x7fef6880(,%eax,4),%edx
80105723:	85 d2                	test   %edx,%edx
80105725:	74 11                	je     80105738 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105727:	ff d2                	call   *%edx
80105729:	8b 53 18             	mov    0x18(%ebx),%edx
8010572c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010572f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105732:	c9                   	leave  
80105733:	c3                   	ret    
80105734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105738:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105739:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010573c:	50                   	push   %eax
8010573d:	ff 73 10             	pushl  0x10(%ebx)
80105740:	68 4d 97 10 80       	push   $0x8010974d
80105745:	e8 16 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010574a:	8b 43 18             	mov    0x18(%ebx),%eax
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105757:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	66 90                	xchg   %ax,%ax
8010575e:	66 90                	xchg   %ax,%ax

80105760 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	56                   	push   %esi
80105764:	53                   	push   %ebx
80105765:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105767:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010576a:	89 d6                	mov    %edx,%esi
8010576c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010576f:	50                   	push   %eax
80105770:	6a 00                	push   $0x0
80105772:	e8 99 fe ff ff       	call   80105610 <argint>
80105777:	83 c4 10             	add    $0x10,%esp
8010577a:	85 c0                	test   %eax,%eax
8010577c:	78 2a                	js     801057a8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010577e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105782:	77 24                	ja     801057a8 <argfd.constprop.0+0x48>
80105784:	e8 37 eb ff ff       	call   801042c0 <myproc>
80105789:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010578c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105790:	85 c0                	test   %eax,%eax
80105792:	74 14                	je     801057a8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105794:	85 db                	test   %ebx,%ebx
80105796:	74 02                	je     8010579a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105798:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010579a:	89 06                	mov    %eax,(%esi)
  return 0;
8010579c:	31 c0                	xor    %eax,%eax
}
8010579e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a1:	5b                   	pop    %ebx
801057a2:	5e                   	pop    %esi
801057a3:	5d                   	pop    %ebp
801057a4:	c3                   	ret    
801057a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ad:	eb ef                	jmp    8010579e <argfd.constprop.0+0x3e>
801057af:	90                   	nop

801057b0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801057b0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057b1:	31 c0                	xor    %eax,%eax
{
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	56                   	push   %esi
801057b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801057b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801057ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801057bd:	e8 9e ff ff ff       	call   80105760 <argfd.constprop.0>
801057c2:	85 c0                	test   %eax,%eax
801057c4:	78 42                	js     80105808 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801057c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057cb:	e8 f0 ea ff ff       	call   801042c0 <myproc>
801057d0:	eb 0e                	jmp    801057e0 <sys_dup+0x30>
801057d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057d8:	83 c3 01             	add    $0x1,%ebx
801057db:	83 fb 10             	cmp    $0x10,%ebx
801057de:	74 28                	je     80105808 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801057e0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057e4:	85 d2                	test   %edx,%edx
801057e6:	75 f0                	jne    801057d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801057e8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801057ec:	83 ec 0c             	sub    $0xc,%esp
801057ef:	ff 75 f4             	pushl  -0xc(%ebp)
801057f2:	e8 a9 b9 ff ff       	call   801011a0 <filedup>
  return fd;
801057f7:	83 c4 10             	add    $0x10,%esp
}
801057fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057fd:	89 d8                	mov    %ebx,%eax
801057ff:	5b                   	pop    %ebx
80105800:	5e                   	pop    %esi
80105801:	5d                   	pop    %ebp
80105802:	c3                   	ret    
80105803:	90                   	nop
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105808:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010580b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105810:	89 d8                	mov    %ebx,%eax
80105812:	5b                   	pop    %ebx
80105813:	5e                   	pop    %esi
80105814:	5d                   	pop    %ebp
80105815:	c3                   	ret    
80105816:	8d 76 00             	lea    0x0(%esi),%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_read>:

int
sys_read(void)
{
80105820:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105821:	31 c0                	xor    %eax,%eax
{
80105823:	89 e5                	mov    %esp,%ebp
80105825:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105828:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010582b:	e8 30 ff ff ff       	call   80105760 <argfd.constprop.0>
80105830:	85 c0                	test   %eax,%eax
80105832:	78 4c                	js     80105880 <sys_read+0x60>
80105834:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 02                	push   $0x2
8010583d:	e8 ce fd ff ff       	call   80105610 <argint>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 37                	js     80105880 <sys_read+0x60>
80105849:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584c:	83 ec 04             	sub    $0x4,%esp
8010584f:	ff 75 f0             	pushl  -0x10(%ebp)
80105852:	50                   	push   %eax
80105853:	6a 01                	push   $0x1
80105855:	e8 06 fe ff ff       	call   80105660 <argptr>
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	85 c0                	test   %eax,%eax
8010585f:	78 1f                	js     80105880 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105861:	83 ec 04             	sub    $0x4,%esp
80105864:	ff 75 f0             	pushl  -0x10(%ebp)
80105867:	ff 75 f4             	pushl  -0xc(%ebp)
8010586a:	ff 75 ec             	pushl  -0x14(%ebp)
8010586d:	e8 9e ba ff ff       	call   80101310 <fileread>
80105872:	83 c4 10             	add    $0x10,%esp
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105885:	c9                   	leave  
80105886:	c3                   	ret    
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105890 <sys_write>:

int
sys_write(void)
{
80105890:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105891:	31 c0                	xor    %eax,%eax
{
80105893:	89 e5                	mov    %esp,%ebp
80105895:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105898:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010589b:	e8 c0 fe ff ff       	call   80105760 <argfd.constprop.0>
801058a0:	85 c0                	test   %eax,%eax
801058a2:	78 4c                	js     801058f0 <sys_write+0x60>
801058a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 02                	push   $0x2
801058ad:	e8 5e fd ff ff       	call   80105610 <argint>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 37                	js     801058f0 <sys_write+0x60>
801058b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058bc:	83 ec 04             	sub    $0x4,%esp
801058bf:	ff 75 f0             	pushl  -0x10(%ebp)
801058c2:	50                   	push   %eax
801058c3:	6a 01                	push   $0x1
801058c5:	e8 96 fd ff ff       	call   80105660 <argptr>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	78 1f                	js     801058f0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801058d1:	83 ec 04             	sub    $0x4,%esp
801058d4:	ff 75 f0             	pushl  -0x10(%ebp)
801058d7:	ff 75 f4             	pushl  -0xc(%ebp)
801058da:	ff 75 ec             	pushl  -0x14(%ebp)
801058dd:	e8 be ba ff ff       	call   801013a0 <filewrite>
801058e2:	83 c4 10             	add    $0x10,%esp
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_close>:

int
sys_close(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105906:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105909:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010590c:	e8 4f fe ff ff       	call   80105760 <argfd.constprop.0>
80105911:	85 c0                	test   %eax,%eax
80105913:	78 2b                	js     80105940 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105915:	e8 a6 e9 ff ff       	call   801042c0 <myproc>
8010591a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010591d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105920:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105927:	00 
  fileclose(f);
80105928:	ff 75 f4             	pushl  -0xc(%ebp)
8010592b:	e8 c0 b8 ff ff       	call   801011f0 <fileclose>
  return 0;
80105930:	83 c4 10             	add    $0x10,%esp
80105933:	31 c0                	xor    %eax,%eax
}
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105945:	c9                   	leave  
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105950 <sys_fstat>:

int
sys_fstat(void)
{
80105950:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105951:	31 c0                	xor    %eax,%eax
{
80105953:	89 e5                	mov    %esp,%ebp
80105955:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105958:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010595b:	e8 00 fe ff ff       	call   80105760 <argfd.constprop.0>
80105960:	85 c0                	test   %eax,%eax
80105962:	78 2c                	js     80105990 <sys_fstat+0x40>
80105964:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105967:	83 ec 04             	sub    $0x4,%esp
8010596a:	6a 14                	push   $0x14
8010596c:	50                   	push   %eax
8010596d:	6a 01                	push   $0x1
8010596f:	e8 ec fc ff ff       	call   80105660 <argptr>
80105974:	83 c4 10             	add    $0x10,%esp
80105977:	85 c0                	test   %eax,%eax
80105979:	78 15                	js     80105990 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010597b:	83 ec 08             	sub    $0x8,%esp
8010597e:	ff 75 f4             	pushl  -0xc(%ebp)
80105981:	ff 75 f0             	pushl  -0x10(%ebp)
80105984:	e8 37 b9 ff ff       	call   801012c0 <filestat>
80105989:	83 c4 10             	add    $0x10,%esp
}
8010598c:	c9                   	leave  
8010598d:	c3                   	ret    
8010598e:	66 90                	xchg   %ax,%ax
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801059a0:	55                   	push   %ebp
801059a1:	89 e5                	mov    %esp,%ebp
801059a3:	57                   	push   %edi
801059a4:	56                   	push   %esi
801059a5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059ac:	50                   	push   %eax
801059ad:	6a 00                	push   $0x0
801059af:	e8 0c fd ff ff       	call   801056c0 <argstr>
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	85 c0                	test   %eax,%eax
801059b9:	0f 88 fb 00 00 00    	js     80105aba <sys_link+0x11a>
801059bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059c2:	83 ec 08             	sub    $0x8,%esp
801059c5:	50                   	push   %eax
801059c6:	6a 01                	push   $0x1
801059c8:	e8 f3 fc ff ff       	call   801056c0 <argstr>
801059cd:	83 c4 10             	add    $0x10,%esp
801059d0:	85 c0                	test   %eax,%eax
801059d2:	0f 88 e2 00 00 00    	js     80105aba <sys_link+0x11a>
    return -1;

  begin_op();
801059d8:	e8 73 db ff ff       	call   80103550 <begin_op>
  if((ip = namei(old)) == 0){
801059dd:	83 ec 0c             	sub    $0xc,%esp
801059e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801059e3:	e8 a8 c8 ff ff       	call   80102290 <namei>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	89 c3                	mov    %eax,%ebx
801059ef:	0f 84 ea 00 00 00    	je     80105adf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801059f5:	83 ec 0c             	sub    $0xc,%esp
801059f8:	50                   	push   %eax
801059f9:	e8 32 c0 ff ff       	call   80101a30 <ilock>
  if(ip->type == T_DIR){
801059fe:	83 c4 10             	add    $0x10,%esp
80105a01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a06:	0f 84 bb 00 00 00    	je     80105ac7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105a0c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a11:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a14:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a17:	53                   	push   %ebx
80105a18:	e8 63 bf ff ff       	call   80101980 <iupdate>
  iunlock(ip);
80105a1d:	89 1c 24             	mov    %ebx,(%esp)
80105a20:	e8 eb c0 ff ff       	call   80101b10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a25:	58                   	pop    %eax
80105a26:	5a                   	pop    %edx
80105a27:	57                   	push   %edi
80105a28:	ff 75 d0             	pushl  -0x30(%ebp)
80105a2b:	e8 80 c8 ff ff       	call   801022b0 <nameiparent>
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	85 c0                	test   %eax,%eax
80105a35:	89 c6                	mov    %eax,%esi
80105a37:	74 5b                	je     80105a94 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a39:	83 ec 0c             	sub    $0xc,%esp
80105a3c:	50                   	push   %eax
80105a3d:	e8 ee bf ff ff       	call   80101a30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	8b 03                	mov    (%ebx),%eax
80105a47:	39 06                	cmp    %eax,(%esi)
80105a49:	75 3d                	jne    80105a88 <sys_link+0xe8>
80105a4b:	83 ec 04             	sub    $0x4,%esp
80105a4e:	ff 73 04             	pushl  0x4(%ebx)
80105a51:	57                   	push   %edi
80105a52:	56                   	push   %esi
80105a53:	e8 78 c7 ff ff       	call   801021d0 <dirlink>
80105a58:	83 c4 10             	add    $0x10,%esp
80105a5b:	85 c0                	test   %eax,%eax
80105a5d:	78 29                	js     80105a88 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105a5f:	83 ec 0c             	sub    $0xc,%esp
80105a62:	56                   	push   %esi
80105a63:	e8 58 c2 ff ff       	call   80101cc0 <iunlockput>
  iput(ip);
80105a68:	89 1c 24             	mov    %ebx,(%esp)
80105a6b:	e8 f0 c0 ff ff       	call   80101b60 <iput>

  end_op();
80105a70:	e8 4b db ff ff       	call   801035c0 <end_op>

  return 0;
80105a75:	83 c4 10             	add    $0x10,%esp
80105a78:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a7d:	5b                   	pop    %ebx
80105a7e:	5e                   	pop    %esi
80105a7f:	5f                   	pop    %edi
80105a80:	5d                   	pop    %ebp
80105a81:	c3                   	ret    
80105a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a88:	83 ec 0c             	sub    $0xc,%esp
80105a8b:	56                   	push   %esi
80105a8c:	e8 2f c2 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105a91:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a94:	83 ec 0c             	sub    $0xc,%esp
80105a97:	53                   	push   %ebx
80105a98:	e8 93 bf ff ff       	call   80101a30 <ilock>
  ip->nlink--;
80105a9d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105aa2:	89 1c 24             	mov    %ebx,(%esp)
80105aa5:	e8 d6 be ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105aaa:	89 1c 24             	mov    %ebx,(%esp)
80105aad:	e8 0e c2 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105ab2:	e8 09 db ff ff       	call   801035c0 <end_op>
  return -1;
80105ab7:	83 c4 10             	add    $0x10,%esp
}
80105aba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac2:	5b                   	pop    %ebx
80105ac3:	5e                   	pop    %esi
80105ac4:	5f                   	pop    %edi
80105ac5:	5d                   	pop    %ebp
80105ac6:	c3                   	ret    
    iunlockput(ip);
80105ac7:	83 ec 0c             	sub    $0xc,%esp
80105aca:	53                   	push   %ebx
80105acb:	e8 f0 c1 ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105ad0:	e8 eb da ff ff       	call   801035c0 <end_op>
    return -1;
80105ad5:	83 c4 10             	add    $0x10,%esp
80105ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105add:	eb 9b                	jmp    80105a7a <sys_link+0xda>
    end_op();
80105adf:	e8 dc da ff ff       	call   801035c0 <end_op>
    return -1;
80105ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ae9:	eb 8f                	jmp    80105a7a <sys_link+0xda>
80105aeb:	90                   	nop
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105af0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
80105af6:	83 ec 1c             	sub    $0x1c,%esp
80105af9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105afc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105b00:	76 3e                	jbe    80105b40 <isdirempty+0x50>
80105b02:	bb 20 00 00 00       	mov    $0x20,%ebx
80105b07:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b0a:	eb 0c                	jmp    80105b18 <isdirempty+0x28>
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b10:	83 c3 10             	add    $0x10,%ebx
80105b13:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105b16:	73 28                	jae    80105b40 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b18:	6a 10                	push   $0x10
80105b1a:	53                   	push   %ebx
80105b1b:	57                   	push   %edi
80105b1c:	56                   	push   %esi
80105b1d:	e8 ee c1 ff ff       	call   80101d10 <readi>
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	83 f8 10             	cmp    $0x10,%eax
80105b28:	75 23                	jne    80105b4d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105b2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b2f:	74 df                	je     80105b10 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105b34:	31 c0                	xor    %eax,%eax
}
80105b36:	5b                   	pop    %ebx
80105b37:	5e                   	pop    %esi
80105b38:	5f                   	pop    %edi
80105b39:	5d                   	pop    %ebp
80105b3a:	c3                   	ret    
80105b3b:	90                   	nop
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105b43:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b48:	5b                   	pop    %ebx
80105b49:	5e                   	pop    %esi
80105b4a:	5f                   	pop    %edi
80105b4b:	5d                   	pop    %ebp
80105b4c:	c3                   	ret    
      panic("isdirempty: readi");
80105b4d:	83 ec 0c             	sub    $0xc,%esp
80105b50:	68 e0 97 10 80       	push   $0x801097e0
80105b55:	e8 36 a8 ff ff       	call   80100390 <panic>
80105b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b60 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b66:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b69:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b6c:	50                   	push   %eax
80105b6d:	6a 00                	push   $0x0
80105b6f:	e8 4c fb ff ff       	call   801056c0 <argstr>
80105b74:	83 c4 10             	add    $0x10,%esp
80105b77:	85 c0                	test   %eax,%eax
80105b79:	0f 88 51 01 00 00    	js     80105cd0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b7f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105b82:	e8 c9 d9 ff ff       	call   80103550 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b87:	83 ec 08             	sub    $0x8,%esp
80105b8a:	53                   	push   %ebx
80105b8b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b8e:	e8 1d c7 ff ff       	call   801022b0 <nameiparent>
80105b93:	83 c4 10             	add    $0x10,%esp
80105b96:	85 c0                	test   %eax,%eax
80105b98:	89 c6                	mov    %eax,%esi
80105b9a:	0f 84 37 01 00 00    	je     80105cd7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	50                   	push   %eax
80105ba4:	e8 87 be ff ff       	call   80101a30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105ba9:	58                   	pop    %eax
80105baa:	5a                   	pop    %edx
80105bab:	68 cb 90 10 80       	push   $0x801090cb
80105bb0:	53                   	push   %ebx
80105bb1:	e8 8a c3 ff ff       	call   80101f40 <namecmp>
80105bb6:	83 c4 10             	add    $0x10,%esp
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	0f 84 d7 00 00 00    	je     80105c98 <sys_unlink+0x138>
80105bc1:	83 ec 08             	sub    $0x8,%esp
80105bc4:	68 ca 90 10 80       	push   $0x801090ca
80105bc9:	53                   	push   %ebx
80105bca:	e8 71 c3 ff ff       	call   80101f40 <namecmp>
80105bcf:	83 c4 10             	add    $0x10,%esp
80105bd2:	85 c0                	test   %eax,%eax
80105bd4:	0f 84 be 00 00 00    	je     80105c98 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bda:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bdd:	83 ec 04             	sub    $0x4,%esp
80105be0:	50                   	push   %eax
80105be1:	53                   	push   %ebx
80105be2:	56                   	push   %esi
80105be3:	e8 78 c3 ff ff       	call   80101f60 <dirlookup>
80105be8:	83 c4 10             	add    $0x10,%esp
80105beb:	85 c0                	test   %eax,%eax
80105bed:	89 c3                	mov    %eax,%ebx
80105bef:	0f 84 a3 00 00 00    	je     80105c98 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105bf5:	83 ec 0c             	sub    $0xc,%esp
80105bf8:	50                   	push   %eax
80105bf9:	e8 32 be ff ff       	call   80101a30 <ilock>

  if(ip->nlink < 1)
80105bfe:	83 c4 10             	add    $0x10,%esp
80105c01:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c06:	0f 8e e4 00 00 00    	jle    80105cf0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c0c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c11:	74 65                	je     80105c78 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c13:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c16:	83 ec 04             	sub    $0x4,%esp
80105c19:	6a 10                	push   $0x10
80105c1b:	6a 00                	push   $0x0
80105c1d:	57                   	push   %edi
80105c1e:	e8 ed f6 ff ff       	call   80105310 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c23:	6a 10                	push   $0x10
80105c25:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c28:	57                   	push   %edi
80105c29:	56                   	push   %esi
80105c2a:	e8 e1 c1 ff ff       	call   80101e10 <writei>
80105c2f:	83 c4 20             	add    $0x20,%esp
80105c32:	83 f8 10             	cmp    $0x10,%eax
80105c35:	0f 85 a8 00 00 00    	jne    80105ce3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c3b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c40:	74 6e                	je     80105cb0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c42:	83 ec 0c             	sub    $0xc,%esp
80105c45:	56                   	push   %esi
80105c46:	e8 75 c0 ff ff       	call   80101cc0 <iunlockput>

  ip->nlink--;
80105c4b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c50:	89 1c 24             	mov    %ebx,(%esp)
80105c53:	e8 28 bd ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105c58:	89 1c 24             	mov    %ebx,(%esp)
80105c5b:	e8 60 c0 ff ff       	call   80101cc0 <iunlockput>

  end_op();
80105c60:	e8 5b d9 ff ff       	call   801035c0 <end_op>

  return 0;
80105c65:	83 c4 10             	add    $0x10,%esp
80105c68:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c6d:	5b                   	pop    %ebx
80105c6e:	5e                   	pop    %esi
80105c6f:	5f                   	pop    %edi
80105c70:	5d                   	pop    %ebp
80105c71:	c3                   	ret    
80105c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c78:	83 ec 0c             	sub    $0xc,%esp
80105c7b:	53                   	push   %ebx
80105c7c:	e8 6f fe ff ff       	call   80105af0 <isdirempty>
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	85 c0                	test   %eax,%eax
80105c86:	75 8b                	jne    80105c13 <sys_unlink+0xb3>
    iunlockput(ip);
80105c88:	83 ec 0c             	sub    $0xc,%esp
80105c8b:	53                   	push   %ebx
80105c8c:	e8 2f c0 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	56                   	push   %esi
80105c9c:	e8 1f c0 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105ca1:	e8 1a d9 ff ff       	call   801035c0 <end_op>
  return -1;
80105ca6:	83 c4 10             	add    $0x10,%esp
80105ca9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cae:	eb ba                	jmp    80105c6a <sys_unlink+0x10a>
    dp->nlink--;
80105cb0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105cb5:	83 ec 0c             	sub    $0xc,%esp
80105cb8:	56                   	push   %esi
80105cb9:	e8 c2 bc ff ff       	call   80101980 <iupdate>
80105cbe:	83 c4 10             	add    $0x10,%esp
80105cc1:	e9 7c ff ff ff       	jmp    80105c42 <sys_unlink+0xe2>
80105cc6:	8d 76 00             	lea    0x0(%esi),%esi
80105cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd5:	eb 93                	jmp    80105c6a <sys_unlink+0x10a>
    end_op();
80105cd7:	e8 e4 d8 ff ff       	call   801035c0 <end_op>
    return -1;
80105cdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce1:	eb 87                	jmp    80105c6a <sys_unlink+0x10a>
    panic("unlink: writei");
80105ce3:	83 ec 0c             	sub    $0xc,%esp
80105ce6:	68 df 90 10 80       	push   $0x801090df
80105ceb:	e8 a0 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	68 cd 90 10 80       	push   $0x801090cd
80105cf8:	e8 93 a6 ff ff       	call   80100390 <panic>
80105cfd:	8d 76 00             	lea    0x0(%esi),%esi

80105d00 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105d00:	55                   	push   %ebp
80105d01:	89 e5                	mov    %esp,%ebp
80105d03:	57                   	push   %edi
80105d04:	56                   	push   %esi
80105d05:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d06:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105d09:	83 ec 34             	sub    $0x34,%esp
80105d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d0f:	8b 55 10             	mov    0x10(%ebp),%edx
80105d12:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d15:	56                   	push   %esi
80105d16:	ff 75 08             	pushl  0x8(%ebp)
{
80105d19:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105d1c:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105d1f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d22:	e8 89 c5 ff ff       	call   801022b0 <nameiparent>
80105d27:	83 c4 10             	add    $0x10,%esp
80105d2a:	85 c0                	test   %eax,%eax
80105d2c:	0f 84 4e 01 00 00    	je     80105e80 <create+0x180>
    return 0;
  ilock(dp);
80105d32:	83 ec 0c             	sub    $0xc,%esp
80105d35:	89 c3                	mov    %eax,%ebx
80105d37:	50                   	push   %eax
80105d38:	e8 f3 bc ff ff       	call   80101a30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d3d:	83 c4 0c             	add    $0xc,%esp
80105d40:	6a 00                	push   $0x0
80105d42:	56                   	push   %esi
80105d43:	53                   	push   %ebx
80105d44:	e8 17 c2 ff ff       	call   80101f60 <dirlookup>
80105d49:	83 c4 10             	add    $0x10,%esp
80105d4c:	85 c0                	test   %eax,%eax
80105d4e:	89 c7                	mov    %eax,%edi
80105d50:	74 3e                	je     80105d90 <create+0x90>
    iunlockput(dp);
80105d52:	83 ec 0c             	sub    $0xc,%esp
80105d55:	53                   	push   %ebx
80105d56:	e8 65 bf ff ff       	call   80101cc0 <iunlockput>
    ilock(ip);
80105d5b:	89 3c 24             	mov    %edi,(%esp)
80105d5e:	e8 cd bc ff ff       	call   80101a30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d63:	83 c4 10             	add    $0x10,%esp
80105d66:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d6b:	0f 85 9f 00 00 00    	jne    80105e10 <create+0x110>
80105d71:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105d76:	0f 85 94 00 00 00    	jne    80105e10 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d7f:	89 f8                	mov    %edi,%eax
80105d81:	5b                   	pop    %ebx
80105d82:	5e                   	pop    %esi
80105d83:	5f                   	pop    %edi
80105d84:	5d                   	pop    %ebp
80105d85:	c3                   	ret    
80105d86:	8d 76 00             	lea    0x0(%esi),%esi
80105d89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105d90:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105d94:	83 ec 08             	sub    $0x8,%esp
80105d97:	50                   	push   %eax
80105d98:	ff 33                	pushl  (%ebx)
80105d9a:	e8 21 bb ff ff       	call   801018c0 <ialloc>
80105d9f:	83 c4 10             	add    $0x10,%esp
80105da2:	85 c0                	test   %eax,%eax
80105da4:	89 c7                	mov    %eax,%edi
80105da6:	0f 84 e8 00 00 00    	je     80105e94 <create+0x194>
  ilock(ip);
80105dac:	83 ec 0c             	sub    $0xc,%esp
80105daf:	50                   	push   %eax
80105db0:	e8 7b bc ff ff       	call   80101a30 <ilock>
  ip->major = major;
80105db5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105db9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105dbd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105dc1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105dc5:	b8 01 00 00 00       	mov    $0x1,%eax
80105dca:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105dce:	89 3c 24             	mov    %edi,(%esp)
80105dd1:	e8 aa bb ff ff       	call   80101980 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105dde:	74 50                	je     80105e30 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105de0:	83 ec 04             	sub    $0x4,%esp
80105de3:	ff 77 04             	pushl  0x4(%edi)
80105de6:	56                   	push   %esi
80105de7:	53                   	push   %ebx
80105de8:	e8 e3 c3 ff ff       	call   801021d0 <dirlink>
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	85 c0                	test   %eax,%eax
80105df2:	0f 88 8f 00 00 00    	js     80105e87 <create+0x187>
  iunlockput(dp);
80105df8:	83 ec 0c             	sub    $0xc,%esp
80105dfb:	53                   	push   %ebx
80105dfc:	e8 bf be ff ff       	call   80101cc0 <iunlockput>
  return ip;
80105e01:	83 c4 10             	add    $0x10,%esp
}
80105e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e07:	89 f8                	mov    %edi,%eax
80105e09:	5b                   	pop    %ebx
80105e0a:	5e                   	pop    %esi
80105e0b:	5f                   	pop    %edi
80105e0c:	5d                   	pop    %ebp
80105e0d:	c3                   	ret    
80105e0e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105e10:	83 ec 0c             	sub    $0xc,%esp
80105e13:	57                   	push   %edi
    return 0;
80105e14:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105e16:	e8 a5 be ff ff       	call   80101cc0 <iunlockput>
    return 0;
80105e1b:	83 c4 10             	add    $0x10,%esp
}
80105e1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e21:	89 f8                	mov    %edi,%eax
80105e23:	5b                   	pop    %ebx
80105e24:	5e                   	pop    %esi
80105e25:	5f                   	pop    %edi
80105e26:	5d                   	pop    %ebp
80105e27:	c3                   	ret    
80105e28:	90                   	nop
80105e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105e30:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e35:	83 ec 0c             	sub    $0xc,%esp
80105e38:	53                   	push   %ebx
80105e39:	e8 42 bb ff ff       	call   80101980 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e3e:	83 c4 0c             	add    $0xc,%esp
80105e41:	ff 77 04             	pushl  0x4(%edi)
80105e44:	68 cb 90 10 80       	push   $0x801090cb
80105e49:	57                   	push   %edi
80105e4a:	e8 81 c3 ff ff       	call   801021d0 <dirlink>
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	85 c0                	test   %eax,%eax
80105e54:	78 1c                	js     80105e72 <create+0x172>
80105e56:	83 ec 04             	sub    $0x4,%esp
80105e59:	ff 73 04             	pushl  0x4(%ebx)
80105e5c:	68 ca 90 10 80       	push   $0x801090ca
80105e61:	57                   	push   %edi
80105e62:	e8 69 c3 ff ff       	call   801021d0 <dirlink>
80105e67:	83 c4 10             	add    $0x10,%esp
80105e6a:	85 c0                	test   %eax,%eax
80105e6c:	0f 89 6e ff ff ff    	jns    80105de0 <create+0xe0>
      panic("create dots");
80105e72:	83 ec 0c             	sub    $0xc,%esp
80105e75:	68 01 98 10 80       	push   $0x80109801
80105e7a:	e8 11 a5 ff ff       	call   80100390 <panic>
80105e7f:	90                   	nop
    return 0;
80105e80:	31 ff                	xor    %edi,%edi
80105e82:	e9 f5 fe ff ff       	jmp    80105d7c <create+0x7c>
    panic("create: dirlink");
80105e87:	83 ec 0c             	sub    $0xc,%esp
80105e8a:	68 0d 98 10 80       	push   $0x8010980d
80105e8f:	e8 fc a4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105e94:	83 ec 0c             	sub    $0xc,%esp
80105e97:	68 f2 97 10 80       	push   $0x801097f2
80105e9c:	e8 ef a4 ff ff       	call   80100390 <panic>
80105ea1:	eb 0d                	jmp    80105eb0 <sys_open>
80105ea3:	90                   	nop
80105ea4:	90                   	nop
80105ea5:	90                   	nop
80105ea6:	90                   	nop
80105ea7:	90                   	nop
80105ea8:	90                   	nop
80105ea9:	90                   	nop
80105eaa:	90                   	nop
80105eab:	90                   	nop
80105eac:	90                   	nop
80105ead:	90                   	nop
80105eae:	90                   	nop
80105eaf:	90                   	nop

80105eb0 <sys_open>:

int
sys_open(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	57                   	push   %edi
80105eb4:	56                   	push   %esi
80105eb5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105eb6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105eb9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ebc:	50                   	push   %eax
80105ebd:	6a 00                	push   $0x0
80105ebf:	e8 fc f7 ff ff       	call   801056c0 <argstr>
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	85 c0                	test   %eax,%eax
80105ec9:	0f 88 1d 01 00 00    	js     80105fec <sys_open+0x13c>
80105ecf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ed2:	83 ec 08             	sub    $0x8,%esp
80105ed5:	50                   	push   %eax
80105ed6:	6a 01                	push   $0x1
80105ed8:	e8 33 f7 ff ff       	call   80105610 <argint>
80105edd:	83 c4 10             	add    $0x10,%esp
80105ee0:	85 c0                	test   %eax,%eax
80105ee2:	0f 88 04 01 00 00    	js     80105fec <sys_open+0x13c>
    return -1;

  begin_op();
80105ee8:	e8 63 d6 ff ff       	call   80103550 <begin_op>

  if(omode & O_CREATE){
80105eed:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ef1:	0f 85 a9 00 00 00    	jne    80105fa0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ef7:	83 ec 0c             	sub    $0xc,%esp
80105efa:	ff 75 e0             	pushl  -0x20(%ebp)
80105efd:	e8 8e c3 ff ff       	call   80102290 <namei>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	89 c6                	mov    %eax,%esi
80105f09:	0f 84 ac 00 00 00    	je     80105fbb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105f0f:	83 ec 0c             	sub    $0xc,%esp
80105f12:	50                   	push   %eax
80105f13:	e8 18 bb ff ff       	call   80101a30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f18:	83 c4 10             	add    $0x10,%esp
80105f1b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f20:	0f 84 aa 00 00 00    	je     80105fd0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f26:	e8 05 b2 ff ff       	call   80101130 <filealloc>
80105f2b:	85 c0                	test   %eax,%eax
80105f2d:	89 c7                	mov    %eax,%edi
80105f2f:	0f 84 a6 00 00 00    	je     80105fdb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105f35:	e8 86 e3 ff ff       	call   801042c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f3a:	31 db                	xor    %ebx,%ebx
80105f3c:	eb 0e                	jmp    80105f4c <sys_open+0x9c>
80105f3e:	66 90                	xchg   %ax,%ax
80105f40:	83 c3 01             	add    $0x1,%ebx
80105f43:	83 fb 10             	cmp    $0x10,%ebx
80105f46:	0f 84 ac 00 00 00    	je     80105ff8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105f4c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f50:	85 d2                	test   %edx,%edx
80105f52:	75 ec                	jne    80105f40 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f54:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f57:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105f5b:	56                   	push   %esi
80105f5c:	e8 af bb ff ff       	call   80101b10 <iunlock>
  end_op();
80105f61:	e8 5a d6 ff ff       	call   801035c0 <end_op>

  f->type = FD_INODE;
80105f66:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f6c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f6f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f72:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105f75:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f7c:	89 d0                	mov    %edx,%eax
80105f7e:	f7 d0                	not    %eax
80105f80:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f83:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105f86:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f89:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105f8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f90:	89 d8                	mov    %ebx,%eax
80105f92:	5b                   	pop    %ebx
80105f93:	5e                   	pop    %esi
80105f94:	5f                   	pop    %edi
80105f95:	5d                   	pop    %ebp
80105f96:	c3                   	ret    
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105fa0:	6a 00                	push   $0x0
80105fa2:	6a 00                	push   $0x0
80105fa4:	6a 02                	push   $0x2
80105fa6:	ff 75 e0             	pushl  -0x20(%ebp)
80105fa9:	e8 52 fd ff ff       	call   80105d00 <create>
    if(ip == 0){
80105fae:	83 c4 10             	add    $0x10,%esp
80105fb1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105fb3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105fb5:	0f 85 6b ff ff ff    	jne    80105f26 <sys_open+0x76>
      end_op();
80105fbb:	e8 00 d6 ff ff       	call   801035c0 <end_op>
      return -1;
80105fc0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fc5:	eb c6                	jmp    80105f8d <sys_open+0xdd>
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fd0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105fd3:	85 c9                	test   %ecx,%ecx
80105fd5:	0f 84 4b ff ff ff    	je     80105f26 <sys_open+0x76>
    iunlockput(ip);
80105fdb:	83 ec 0c             	sub    $0xc,%esp
80105fde:	56                   	push   %esi
80105fdf:	e8 dc bc ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105fe4:	e8 d7 d5 ff ff       	call   801035c0 <end_op>
    return -1;
80105fe9:	83 c4 10             	add    $0x10,%esp
80105fec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ff1:	eb 9a                	jmp    80105f8d <sys_open+0xdd>
80105ff3:	90                   	nop
80105ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105ff8:	83 ec 0c             	sub    $0xc,%esp
80105ffb:	57                   	push   %edi
80105ffc:	e8 ef b1 ff ff       	call   801011f0 <fileclose>
80106001:	83 c4 10             	add    $0x10,%esp
80106004:	eb d5                	jmp    80105fdb <sys_open+0x12b>
80106006:	8d 76 00             	lea    0x0(%esi),%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106010 <sys_mkdir>:

int
sys_mkdir(void)
{
80106010:	55                   	push   %ebp
80106011:	89 e5                	mov    %esp,%ebp
80106013:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106016:	e8 35 d5 ff ff       	call   80103550 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010601b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010601e:	83 ec 08             	sub    $0x8,%esp
80106021:	50                   	push   %eax
80106022:	6a 00                	push   $0x0
80106024:	e8 97 f6 ff ff       	call   801056c0 <argstr>
80106029:	83 c4 10             	add    $0x10,%esp
8010602c:	85 c0                	test   %eax,%eax
8010602e:	78 30                	js     80106060 <sys_mkdir+0x50>
80106030:	6a 00                	push   $0x0
80106032:	6a 00                	push   $0x0
80106034:	6a 01                	push   $0x1
80106036:	ff 75 f4             	pushl  -0xc(%ebp)
80106039:	e8 c2 fc ff ff       	call   80105d00 <create>
8010603e:	83 c4 10             	add    $0x10,%esp
80106041:	85 c0                	test   %eax,%eax
80106043:	74 1b                	je     80106060 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106045:	83 ec 0c             	sub    $0xc,%esp
80106048:	50                   	push   %eax
80106049:	e8 72 bc ff ff       	call   80101cc0 <iunlockput>
  end_op();
8010604e:	e8 6d d5 ff ff       	call   801035c0 <end_op>
  return 0;
80106053:	83 c4 10             	add    $0x10,%esp
80106056:	31 c0                	xor    %eax,%eax
}
80106058:	c9                   	leave  
80106059:	c3                   	ret    
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106060:	e8 5b d5 ff ff       	call   801035c0 <end_op>
    return -1;
80106065:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010606a:	c9                   	leave  
8010606b:	c3                   	ret    
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_mknod>:

int
sys_mknod(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106076:	e8 d5 d4 ff ff       	call   80103550 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010607b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010607e:	83 ec 08             	sub    $0x8,%esp
80106081:	50                   	push   %eax
80106082:	6a 00                	push   $0x0
80106084:	e8 37 f6 ff ff       	call   801056c0 <argstr>
80106089:	83 c4 10             	add    $0x10,%esp
8010608c:	85 c0                	test   %eax,%eax
8010608e:	78 60                	js     801060f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106090:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106093:	83 ec 08             	sub    $0x8,%esp
80106096:	50                   	push   %eax
80106097:	6a 01                	push   $0x1
80106099:	e8 72 f5 ff ff       	call   80105610 <argint>
  if((argstr(0, &path)) < 0 ||
8010609e:	83 c4 10             	add    $0x10,%esp
801060a1:	85 c0                	test   %eax,%eax
801060a3:	78 4b                	js     801060f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801060a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060a8:	83 ec 08             	sub    $0x8,%esp
801060ab:	50                   	push   %eax
801060ac:	6a 02                	push   $0x2
801060ae:	e8 5d f5 ff ff       	call   80105610 <argint>
     argint(1, &major) < 0 ||
801060b3:	83 c4 10             	add    $0x10,%esp
801060b6:	85 c0                	test   %eax,%eax
801060b8:	78 36                	js     801060f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801060ba:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801060be:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801060bf:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801060c3:	50                   	push   %eax
801060c4:	6a 03                	push   $0x3
801060c6:	ff 75 ec             	pushl  -0x14(%ebp)
801060c9:	e8 32 fc ff ff       	call   80105d00 <create>
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	85 c0                	test   %eax,%eax
801060d3:	74 1b                	je     801060f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801060d5:	83 ec 0c             	sub    $0xc,%esp
801060d8:	50                   	push   %eax
801060d9:	e8 e2 bb ff ff       	call   80101cc0 <iunlockput>
  end_op();
801060de:	e8 dd d4 ff ff       	call   801035c0 <end_op>
  return 0;
801060e3:	83 c4 10             	add    $0x10,%esp
801060e6:	31 c0                	xor    %eax,%eax
}
801060e8:	c9                   	leave  
801060e9:	c3                   	ret    
801060ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801060f0:	e8 cb d4 ff ff       	call   801035c0 <end_op>
    return -1;
801060f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060fa:	c9                   	leave  
801060fb:	c3                   	ret    
801060fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106100 <sys_chdir>:

int
sys_chdir(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	56                   	push   %esi
80106104:	53                   	push   %ebx
80106105:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106108:	e8 b3 e1 ff ff       	call   801042c0 <myproc>
8010610d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010610f:	e8 3c d4 ff ff       	call   80103550 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106114:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106117:	83 ec 08             	sub    $0x8,%esp
8010611a:	50                   	push   %eax
8010611b:	6a 00                	push   $0x0
8010611d:	e8 9e f5 ff ff       	call   801056c0 <argstr>
80106122:	83 c4 10             	add    $0x10,%esp
80106125:	85 c0                	test   %eax,%eax
80106127:	78 77                	js     801061a0 <sys_chdir+0xa0>
80106129:	83 ec 0c             	sub    $0xc,%esp
8010612c:	ff 75 f4             	pushl  -0xc(%ebp)
8010612f:	e8 5c c1 ff ff       	call   80102290 <namei>
80106134:	83 c4 10             	add    $0x10,%esp
80106137:	85 c0                	test   %eax,%eax
80106139:	89 c3                	mov    %eax,%ebx
8010613b:	74 63                	je     801061a0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010613d:	83 ec 0c             	sub    $0xc,%esp
80106140:	50                   	push   %eax
80106141:	e8 ea b8 ff ff       	call   80101a30 <ilock>
  if(ip->type != T_DIR){
80106146:	83 c4 10             	add    $0x10,%esp
80106149:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010614e:	75 30                	jne    80106180 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	53                   	push   %ebx
80106154:	e8 b7 b9 ff ff       	call   80101b10 <iunlock>
  iput(curproc->cwd);
80106159:	58                   	pop    %eax
8010615a:	ff 76 68             	pushl  0x68(%esi)
8010615d:	e8 fe b9 ff ff       	call   80101b60 <iput>
  end_op();
80106162:	e8 59 d4 ff ff       	call   801035c0 <end_op>
  curproc->cwd = ip;
80106167:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010616a:	83 c4 10             	add    $0x10,%esp
8010616d:	31 c0                	xor    %eax,%eax
}
8010616f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106172:	5b                   	pop    %ebx
80106173:	5e                   	pop    %esi
80106174:	5d                   	pop    %ebp
80106175:	c3                   	ret    
80106176:	8d 76 00             	lea    0x0(%esi),%esi
80106179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106180:	83 ec 0c             	sub    $0xc,%esp
80106183:	53                   	push   %ebx
80106184:	e8 37 bb ff ff       	call   80101cc0 <iunlockput>
    end_op();
80106189:	e8 32 d4 ff ff       	call   801035c0 <end_op>
    return -1;
8010618e:	83 c4 10             	add    $0x10,%esp
80106191:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106196:	eb d7                	jmp    8010616f <sys_chdir+0x6f>
80106198:	90                   	nop
80106199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801061a0:	e8 1b d4 ff ff       	call   801035c0 <end_op>
    return -1;
801061a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061aa:	eb c3                	jmp    8010616f <sys_chdir+0x6f>
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061b0 <sys_exec>:

int
sys_exec(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	57                   	push   %edi
801061b4:	56                   	push   %esi
801061b5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061b6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801061bc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061c2:	50                   	push   %eax
801061c3:	6a 00                	push   $0x0
801061c5:	e8 f6 f4 ff ff       	call   801056c0 <argstr>
801061ca:	83 c4 10             	add    $0x10,%esp
801061cd:	85 c0                	test   %eax,%eax
801061cf:	0f 88 87 00 00 00    	js     8010625c <sys_exec+0xac>
801061d5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801061db:	83 ec 08             	sub    $0x8,%esp
801061de:	50                   	push   %eax
801061df:	6a 01                	push   $0x1
801061e1:	e8 2a f4 ff ff       	call   80105610 <argint>
801061e6:	83 c4 10             	add    $0x10,%esp
801061e9:	85 c0                	test   %eax,%eax
801061eb:	78 6f                	js     8010625c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801061ed:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061f3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801061f6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801061f8:	68 80 00 00 00       	push   $0x80
801061fd:	6a 00                	push   $0x0
801061ff:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106205:	50                   	push   %eax
80106206:	e8 05 f1 ff ff       	call   80105310 <memset>
8010620b:	83 c4 10             	add    $0x10,%esp
8010620e:	eb 2c                	jmp    8010623c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106210:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106216:	85 c0                	test   %eax,%eax
80106218:	74 56                	je     80106270 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010621a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106220:	83 ec 08             	sub    $0x8,%esp
80106223:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106226:	52                   	push   %edx
80106227:	50                   	push   %eax
80106228:	e8 73 f3 ff ff       	call   801055a0 <fetchstr>
8010622d:	83 c4 10             	add    $0x10,%esp
80106230:	85 c0                	test   %eax,%eax
80106232:	78 28                	js     8010625c <sys_exec+0xac>
  for(i=0;; i++){
80106234:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106237:	83 fb 20             	cmp    $0x20,%ebx
8010623a:	74 20                	je     8010625c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010623c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106242:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106249:	83 ec 08             	sub    $0x8,%esp
8010624c:	57                   	push   %edi
8010624d:	01 f0                	add    %esi,%eax
8010624f:	50                   	push   %eax
80106250:	e8 0b f3 ff ff       	call   80105560 <fetchint>
80106255:	83 c4 10             	add    $0x10,%esp
80106258:	85 c0                	test   %eax,%eax
8010625a:	79 b4                	jns    80106210 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010625c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010625f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106264:	5b                   	pop    %ebx
80106265:	5e                   	pop    %esi
80106266:	5f                   	pop    %edi
80106267:	5d                   	pop    %ebp
80106268:	c3                   	ret    
80106269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106270:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106276:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106279:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106280:	00 00 00 00 
  return exec(path, argv);
80106284:	50                   	push   %eax
80106285:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010628b:	e8 d0 a9 ff ff       	call   80100c60 <exec>
80106290:	83 c4 10             	add    $0x10,%esp
}
80106293:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106296:	5b                   	pop    %ebx
80106297:	5e                   	pop    %esi
80106298:	5f                   	pop    %edi
80106299:	5d                   	pop    %ebp
8010629a:	c3                   	ret    
8010629b:	90                   	nop
8010629c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062a0 <sys_pipe>:

int
sys_pipe(void)
{
801062a0:	55                   	push   %ebp
801062a1:	89 e5                	mov    %esp,%ebp
801062a3:	57                   	push   %edi
801062a4:	56                   	push   %esi
801062a5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062a6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801062a9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062ac:	6a 08                	push   $0x8
801062ae:	50                   	push   %eax
801062af:	6a 00                	push   $0x0
801062b1:	e8 aa f3 ff ff       	call   80105660 <argptr>
801062b6:	83 c4 10             	add    $0x10,%esp
801062b9:	85 c0                	test   %eax,%eax
801062bb:	0f 88 ae 00 00 00    	js     8010636f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801062c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062c4:	83 ec 08             	sub    $0x8,%esp
801062c7:	50                   	push   %eax
801062c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062cb:	50                   	push   %eax
801062cc:	e8 1f d9 ff ff       	call   80103bf0 <pipealloc>
801062d1:	83 c4 10             	add    $0x10,%esp
801062d4:	85 c0                	test   %eax,%eax
801062d6:	0f 88 93 00 00 00    	js     8010636f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062dc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801062df:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801062e1:	e8 da df ff ff       	call   801042c0 <myproc>
801062e6:	eb 10                	jmp    801062f8 <sys_pipe+0x58>
801062e8:	90                   	nop
801062e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801062f0:	83 c3 01             	add    $0x1,%ebx
801062f3:	83 fb 10             	cmp    $0x10,%ebx
801062f6:	74 60                	je     80106358 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801062f8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801062fc:	85 f6                	test   %esi,%esi
801062fe:	75 f0                	jne    801062f0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106300:	8d 73 08             	lea    0x8(%ebx),%esi
80106303:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106307:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010630a:	e8 b1 df ff ff       	call   801042c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010630f:	31 d2                	xor    %edx,%edx
80106311:	eb 0d                	jmp    80106320 <sys_pipe+0x80>
80106313:	90                   	nop
80106314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106318:	83 c2 01             	add    $0x1,%edx
8010631b:	83 fa 10             	cmp    $0x10,%edx
8010631e:	74 28                	je     80106348 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106320:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106324:	85 c9                	test   %ecx,%ecx
80106326:	75 f0                	jne    80106318 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106328:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010632c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010632f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106331:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106334:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106337:	31 c0                	xor    %eax,%eax
}
80106339:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010633c:	5b                   	pop    %ebx
8010633d:	5e                   	pop    %esi
8010633e:	5f                   	pop    %edi
8010633f:	5d                   	pop    %ebp
80106340:	c3                   	ret    
80106341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106348:	e8 73 df ff ff       	call   801042c0 <myproc>
8010634d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106354:	00 
80106355:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106358:	83 ec 0c             	sub    $0xc,%esp
8010635b:	ff 75 e0             	pushl  -0x20(%ebp)
8010635e:	e8 8d ae ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
80106363:	58                   	pop    %eax
80106364:	ff 75 e4             	pushl  -0x1c(%ebp)
80106367:	e8 84 ae ff ff       	call   801011f0 <fileclose>
    return -1;
8010636c:	83 c4 10             	add    $0x10,%esp
8010636f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106374:	eb c3                	jmp    80106339 <sys_pipe+0x99>
80106376:	66 90                	xchg   %ax,%ax
80106378:	66 90                	xchg   %ax,%ax
8010637a:	66 90                	xchg   %ax,%ax
8010637c:	66 90                	xchg   %ax,%ax
8010637e:	66 90                	xchg   %ax,%ax

80106380 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106383:	5d                   	pop    %ebp
  return fork();
80106384:	e9 e7 e0 ff ff       	jmp    80104470 <fork>
80106389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106390 <sys_exit>:

int
sys_exit(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	83 ec 08             	sub    $0x8,%esp
  exit();
80106396:	e8 65 e5 ff ff       	call   80104900 <exit>
  return 0;  // not reached
}
8010639b:	31 c0                	xor    %eax,%eax
8010639d:	c9                   	leave  
8010639e:	c3                   	ret    
8010639f:	90                   	nop

801063a0 <sys_wait>:

int
sys_wait(void)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801063a3:	5d                   	pop    %ebp
  return wait();
801063a4:	e9 c7 e7 ff ff       	jmp    80104b70 <wait>
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063b0 <sys_kill>:

int
sys_kill(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063b9:	50                   	push   %eax
801063ba:	6a 00                	push   $0x0
801063bc:	e8 4f f2 ff ff       	call   80105610 <argint>
801063c1:	83 c4 10             	add    $0x10,%esp
801063c4:	85 c0                	test   %eax,%eax
801063c6:	78 18                	js     801063e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801063c8:	83 ec 0c             	sub    $0xc,%esp
801063cb:	ff 75 f4             	pushl  -0xc(%ebp)
801063ce:	e8 7d e9 ff ff       	call   80104d50 <kill>
801063d3:	83 c4 10             	add    $0x10,%esp
}
801063d6:	c9                   	leave  
801063d7:	c3                   	ret    
801063d8:	90                   	nop
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063e5:	c9                   	leave  
801063e6:	c3                   	ret    
801063e7:	89 f6                	mov    %esi,%esi
801063e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063f0 <sys_getpid>:

int
sys_getpid(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801063f6:	e8 c5 de ff ff       	call   801042c0 <myproc>
801063fb:	8b 40 10             	mov    0x10(%eax),%eax
}
801063fe:	c9                   	leave  
801063ff:	c3                   	ret    

80106400 <sys_sbrk>:

int
sys_sbrk(void)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106404:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106407:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010640a:	50                   	push   %eax
8010640b:	6a 00                	push   $0x0
8010640d:	e8 fe f1 ff ff       	call   80105610 <argint>
80106412:	83 c4 10             	add    $0x10,%esp
80106415:	85 c0                	test   %eax,%eax
80106417:	78 27                	js     80106440 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106419:	e8 a2 de ff ff       	call   801042c0 <myproc>
  if(growproc(n) < 0)
8010641e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106421:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106423:	ff 75 f4             	pushl  -0xc(%ebp)
80106426:	e8 b5 df ff ff       	call   801043e0 <growproc>
8010642b:	83 c4 10             	add    $0x10,%esp
8010642e:	85 c0                	test   %eax,%eax
80106430:	78 0e                	js     80106440 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106432:	89 d8                	mov    %ebx,%eax
80106434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106437:	c9                   	leave  
80106438:	c3                   	ret    
80106439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106440:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106445:	eb eb                	jmp    80106432 <sys_sbrk+0x32>
80106447:	89 f6                	mov    %esi,%esi
80106449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106450 <sys_sleep>:

int
sys_sleep(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106454:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106457:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010645a:	50                   	push   %eax
8010645b:	6a 00                	push   $0x0
8010645d:	e8 ae f1 ff ff       	call   80105610 <argint>
80106462:	83 c4 10             	add    $0x10,%esp
80106465:	85 c0                	test   %eax,%eax
80106467:	0f 88 8a 00 00 00    	js     801064f7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010646d:	83 ec 0c             	sub    $0xc,%esp
80106470:	68 40 6d 19 80       	push   $0x80196d40
80106475:	e8 86 ed ff ff       	call   80105200 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010647a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010647d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106480:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  while(ticks - ticks0 < n){
80106486:	85 d2                	test   %edx,%edx
80106488:	75 27                	jne    801064b1 <sys_sleep+0x61>
8010648a:	eb 54                	jmp    801064e0 <sys_sleep+0x90>
8010648c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106490:	83 ec 08             	sub    $0x8,%esp
80106493:	68 40 6d 19 80       	push   $0x80196d40
80106498:	68 80 75 19 80       	push   $0x80197580
8010649d:	e8 0e e6 ff ff       	call   80104ab0 <sleep>
  while(ticks - ticks0 < n){
801064a2:	a1 80 75 19 80       	mov    0x80197580,%eax
801064a7:	83 c4 10             	add    $0x10,%esp
801064aa:	29 d8                	sub    %ebx,%eax
801064ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064af:	73 2f                	jae    801064e0 <sys_sleep+0x90>
    if(myproc()->killed){
801064b1:	e8 0a de ff ff       	call   801042c0 <myproc>
801064b6:	8b 40 24             	mov    0x24(%eax),%eax
801064b9:	85 c0                	test   %eax,%eax
801064bb:	74 d3                	je     80106490 <sys_sleep+0x40>
      release(&tickslock);
801064bd:	83 ec 0c             	sub    $0xc,%esp
801064c0:	68 40 6d 19 80       	push   $0x80196d40
801064c5:	e8 f6 ed ff ff       	call   801052c0 <release>
      return -1;
801064ca:	83 c4 10             	add    $0x10,%esp
801064cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801064d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064d5:	c9                   	leave  
801064d6:	c3                   	ret    
801064d7:	89 f6                	mov    %esi,%esi
801064d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801064e0:	83 ec 0c             	sub    $0xc,%esp
801064e3:	68 40 6d 19 80       	push   $0x80196d40
801064e8:	e8 d3 ed ff ff       	call   801052c0 <release>
  return 0;
801064ed:	83 c4 10             	add    $0x10,%esp
801064f0:	31 c0                	xor    %eax,%eax
}
801064f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064f5:	c9                   	leave  
801064f6:	c3                   	ret    
    return -1;
801064f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064fc:	eb f4                	jmp    801064f2 <sys_sleep+0xa2>
801064fe:	66 90                	xchg   %ax,%ax

80106500 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	53                   	push   %ebx
80106504:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106507:	68 40 6d 19 80       	push   $0x80196d40
8010650c:	e8 ef ec ff ff       	call   80105200 <acquire>
  xticks = ticks;
80106511:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
80106517:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
8010651e:	e8 9d ed ff ff       	call   801052c0 <release>
  return xticks;
}
80106523:	89 d8                	mov    %ebx,%eax
80106525:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106528:	c9                   	leave  
80106529:	c3                   	ret    
8010652a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106530 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106536:	e8 85 dd ff ff       	call   801042c0 <myproc>
8010653b:	ba 10 00 00 00       	mov    $0x10,%edx
80106540:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80106546:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106547:	89 d0                	mov    %edx,%eax
}
80106549:	c3                   	ret    
8010654a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106550 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80106553:	5d                   	pop    %ebp
  return getTotalFreePages();
80106554:	e9 d7 e8 ff ff       	jmp    80104e30 <getTotalFreePages>

80106559 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106559:	1e                   	push   %ds
  pushl %es
8010655a:	06                   	push   %es
  pushl %fs
8010655b:	0f a0                	push   %fs
  pushl %gs
8010655d:	0f a8                	push   %gs
  pushal
8010655f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106560:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106564:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106566:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106568:	54                   	push   %esp
  call trap
80106569:	e8 c2 00 00 00       	call   80106630 <trap>
  addl $4, %esp
8010656e:	83 c4 04             	add    $0x4,%esp

80106571 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106571:	61                   	popa   
  popl %gs
80106572:	0f a9                	pop    %gs
  popl %fs
80106574:	0f a1                	pop    %fs
  popl %es
80106576:	07                   	pop    %es
  popl %ds
80106577:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106578:	83 c4 08             	add    $0x8,%esp
  iret
8010657b:	cf                   	iret   
8010657c:	66 90                	xchg   %ax,%ax
8010657e:	66 90                	xchg   %ax,%ax

80106580 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106580:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106581:	31 c0                	xor    %eax,%eax
{
80106583:	89 e5                	mov    %esp,%ebp
80106585:	83 ec 08             	sub    $0x8,%esp
80106588:	90                   	nop
80106589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106590:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106597:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
8010659e:	08 00 00 8e 
801065a2:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
801065a9:	80 
801065aa:	c1 ea 10             	shr    $0x10,%edx
801065ad:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
801065b4:	80 
  for(i = 0; i < 256; i++)
801065b5:	83 c0 01             	add    $0x1,%eax
801065b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065bd:	75 d1                	jne    80106590 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065bf:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
801065c4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065c7:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
801065ce:	00 00 ef 
  initlock(&tickslock, "time");
801065d1:	68 1d 98 10 80       	push   $0x8010981d
801065d6:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065db:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
801065e1:	c1 e8 10             	shr    $0x10,%eax
801065e4:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
801065ea:	e8 d1 ea ff ff       	call   801050c0 <initlock>
}
801065ef:	83 c4 10             	add    $0x10,%esp
801065f2:	c9                   	leave  
801065f3:	c3                   	ret    
801065f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106600 <idtinit>:

void
idtinit(void)
{
80106600:	55                   	push   %ebp
  pd[0] = size-1;
80106601:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106606:	89 e5                	mov    %esp,%ebp
80106608:	83 ec 10             	sub    $0x10,%esp
8010660b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010660f:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
80106614:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106618:	c1 e8 10             	shr    $0x10,%eax
8010661b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010661f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106622:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106625:	c9                   	leave  
80106626:	c3                   	ret    
80106627:	89 f6                	mov    %esi,%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106630 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106630:	55                   	push   %ebp
80106631:	89 e5                	mov    %esp,%ebp
80106633:	57                   	push   %edi
80106634:	56                   	push   %esi
80106635:	53                   	push   %ebx
80106636:	83 ec 1c             	sub    $0x1c,%esp
80106639:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
8010663c:	e8 7f dc ff ff       	call   801042c0 <myproc>
80106641:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106643:	8b 47 30             	mov    0x30(%edi),%eax
80106646:	83 f8 40             	cmp    $0x40,%eax
80106649:	0f 84 e9 00 00 00    	je     80106738 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010664f:	83 e8 0e             	sub    $0xe,%eax
80106652:	83 f8 31             	cmp    $0x31,%eax
80106655:	77 09                	ja     80106660 <trap+0x30>
80106657:	ff 24 85 c4 98 10 80 	jmp    *-0x7fef673c(,%eax,4)
8010665e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106660:	e8 5b dc ff ff       	call   801042c0 <myproc>
80106665:	85 c0                	test   %eax,%eax
80106667:	0f 84 27 02 00 00    	je     80106894 <trap+0x264>
8010666d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106671:	0f 84 1d 02 00 00    	je     80106894 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106677:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010667a:	8b 57 38             	mov    0x38(%edi),%edx
8010667d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106680:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106683:	e8 18 dc ff ff       	call   801042a0 <cpuid>
80106688:	8b 77 34             	mov    0x34(%edi),%esi
8010668b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010668e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106691:	e8 2a dc ff ff       	call   801042c0 <myproc>
80106696:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106699:	e8 22 dc ff ff       	call   801042c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010669e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066a4:	51                   	push   %ecx
801066a5:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801066a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801066ac:	56                   	push   %esi
801066ad:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
801066ae:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066b1:	52                   	push   %edx
801066b2:	ff 70 10             	pushl  0x10(%eax)
801066b5:	68 80 98 10 80       	push   $0x80109880
801066ba:	e8 a1 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066bf:	83 c4 20             	add    $0x20,%esp
801066c2:	e8 f9 db ff ff       	call   801042c0 <myproc>
801066c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801066ce:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066d0:	e8 eb db ff ff       	call   801042c0 <myproc>
801066d5:	85 c0                	test   %eax,%eax
801066d7:	74 1d                	je     801066f6 <trap+0xc6>
801066d9:	e8 e2 db ff ff       	call   801042c0 <myproc>
801066de:	8b 50 24             	mov    0x24(%eax),%edx
801066e1:	85 d2                	test   %edx,%edx
801066e3:	74 11                	je     801066f6 <trap+0xc6>
801066e5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066e9:	83 e0 03             	and    $0x3,%eax
801066ec:	66 83 f8 03          	cmp    $0x3,%ax
801066f0:	0f 84 5a 01 00 00    	je     80106850 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801066f6:	e8 c5 db ff ff       	call   801042c0 <myproc>
801066fb:	85 c0                	test   %eax,%eax
801066fd:	74 0b                	je     8010670a <trap+0xda>
801066ff:	e8 bc db ff ff       	call   801042c0 <myproc>
80106704:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106708:	74 5e                	je     80106768 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010670a:	e8 b1 db ff ff       	call   801042c0 <myproc>
8010670f:	85 c0                	test   %eax,%eax
80106711:	74 19                	je     8010672c <trap+0xfc>
80106713:	e8 a8 db ff ff       	call   801042c0 <myproc>
80106718:	8b 40 24             	mov    0x24(%eax),%eax
8010671b:	85 c0                	test   %eax,%eax
8010671d:	74 0d                	je     8010672c <trap+0xfc>
8010671f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106723:	83 e0 03             	and    $0x3,%eax
80106726:	66 83 f8 03          	cmp    $0x3,%ax
8010672a:	74 2b                	je     80106757 <trap+0x127>
    exit();
8010672c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010672f:	5b                   	pop    %ebx
80106730:	5e                   	pop    %esi
80106731:	5f                   	pop    %edi
80106732:	5d                   	pop    %ebp
80106733:	c3                   	ret    
80106734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106738:	8b 73 24             	mov    0x24(%ebx),%esi
8010673b:	85 f6                	test   %esi,%esi
8010673d:	0f 85 fd 00 00 00    	jne    80106840 <trap+0x210>
    curproc->tf = tf;
80106743:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106746:	e8 b5 ef ff ff       	call   80105700 <syscall>
    if(myproc()->killed)
8010674b:	e8 70 db ff ff       	call   801042c0 <myproc>
80106750:	8b 58 24             	mov    0x24(%eax),%ebx
80106753:	85 db                	test   %ebx,%ebx
80106755:	74 d5                	je     8010672c <trap+0xfc>
80106757:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010675a:	5b                   	pop    %ebx
8010675b:	5e                   	pop    %esi
8010675c:	5f                   	pop    %edi
8010675d:	5d                   	pop    %ebp
      exit();
8010675e:	e9 9d e1 ff ff       	jmp    80104900 <exit>
80106763:	90                   	nop
80106764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106768:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010676c:	75 9c                	jne    8010670a <trap+0xda>
      if(myproc()->pid > 2) 
8010676e:	e8 4d db ff ff       	call   801042c0 <myproc>
      yield();
80106773:	e8 e8 e2 ff ff       	call   80104a60 <yield>
80106778:	eb 90                	jmp    8010670a <trap+0xda>
8010677a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
80106780:	e8 3b db ff ff       	call   801042c0 <myproc>
80106785:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106789:	0f 8e 41 ff ff ff    	jle    801066d0 <trap+0xa0>
    pagefault();
8010678f:	e8 bc 1e 00 00       	call   80108650 <pagefault>
      if(curproc->killed) {
80106794:	8b 4b 24             	mov    0x24(%ebx),%ecx
80106797:	85 c9                	test   %ecx,%ecx
80106799:	0f 84 31 ff ff ff    	je     801066d0 <trap+0xa0>
        exit();
8010679f:	e8 5c e1 ff ff       	call   80104900 <exit>
801067a4:	e9 27 ff ff ff       	jmp    801066d0 <trap+0xa0>
801067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801067b0:	e8 eb da ff ff       	call   801042a0 <cpuid>
801067b5:	85 c0                	test   %eax,%eax
801067b7:	0f 84 a3 00 00 00    	je     80106860 <trap+0x230>
    lapiceoi();
801067bd:	e8 3e c9 ff ff       	call   80103100 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067c2:	e8 f9 da ff ff       	call   801042c0 <myproc>
801067c7:	85 c0                	test   %eax,%eax
801067c9:	0f 85 0a ff ff ff    	jne    801066d9 <trap+0xa9>
801067cf:	e9 22 ff ff ff       	jmp    801066f6 <trap+0xc6>
801067d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801067d8:	e8 e3 c7 ff ff       	call   80102fc0 <kbdintr>
    lapiceoi();
801067dd:	e8 1e c9 ff ff       	call   80103100 <lapiceoi>
    break;
801067e2:	e9 e9 fe ff ff       	jmp    801066d0 <trap+0xa0>
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
801067f0:	e8 3b 02 00 00       	call   80106a30 <uartintr>
    lapiceoi();
801067f5:	e8 06 c9 ff ff       	call   80103100 <lapiceoi>
    break;
801067fa:	e9 d1 fe ff ff       	jmp    801066d0 <trap+0xa0>
801067ff:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106800:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106804:	8b 77 38             	mov    0x38(%edi),%esi
80106807:	e8 94 da ff ff       	call   801042a0 <cpuid>
8010680c:	56                   	push   %esi
8010680d:	53                   	push   %ebx
8010680e:	50                   	push   %eax
8010680f:	68 28 98 10 80       	push   $0x80109828
80106814:	e8 47 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106819:	e8 e2 c8 ff ff       	call   80103100 <lapiceoi>
    break;
8010681e:	83 c4 10             	add    $0x10,%esp
80106821:	e9 aa fe ff ff       	jmp    801066d0 <trap+0xa0>
80106826:	8d 76 00             	lea    0x0(%esi),%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106830:	e8 8b bf ff ff       	call   801027c0 <ideintr>
80106835:	eb 86                	jmp    801067bd <trap+0x18d>
80106837:	89 f6                	mov    %esi,%esi
80106839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106840:	e8 bb e0 ff ff       	call   80104900 <exit>
80106845:	e9 f9 fe ff ff       	jmp    80106743 <trap+0x113>
8010684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106850:	e8 ab e0 ff ff       	call   80104900 <exit>
80106855:	e9 9c fe ff ff       	jmp    801066f6 <trap+0xc6>
8010685a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106860:	83 ec 0c             	sub    $0xc,%esp
80106863:	68 40 6d 19 80       	push   $0x80196d40
80106868:	e8 93 e9 ff ff       	call   80105200 <acquire>
      wakeup(&ticks);
8010686d:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
80106874:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
8010687b:	e8 70 e4 ff ff       	call   80104cf0 <wakeup>
      release(&tickslock);
80106880:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
80106887:	e8 34 ea ff ff       	call   801052c0 <release>
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	e9 29 ff ff ff       	jmp    801067bd <trap+0x18d>
80106894:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106897:	8b 5f 38             	mov    0x38(%edi),%ebx
8010689a:	e8 01 da ff ff       	call   801042a0 <cpuid>
8010689f:	83 ec 0c             	sub    $0xc,%esp
801068a2:	56                   	push   %esi
801068a3:	53                   	push   %ebx
801068a4:	50                   	push   %eax
801068a5:	ff 77 30             	pushl  0x30(%edi)
801068a8:	68 4c 98 10 80       	push   $0x8010984c
801068ad:	e8 ae 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
801068b2:	83 c4 14             	add    $0x14,%esp
801068b5:	68 22 98 10 80       	push   $0x80109822
801068ba:	e8 d1 9a ff ff       	call   80100390 <panic>
801068bf:	90                   	nop

801068c0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801068c0:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
801068c5:	55                   	push   %ebp
801068c6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801068c8:	85 c0                	test   %eax,%eax
801068ca:	74 1c                	je     801068e8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068cc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801068d1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801068d2:	a8 01                	test   $0x1,%al
801068d4:	74 12                	je     801068e8 <uartgetc+0x28>
801068d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068db:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801068dc:	0f b6 c0             	movzbl %al,%eax
}
801068df:	5d                   	pop    %ebp
801068e0:	c3                   	ret    
801068e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801068e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068ed:	5d                   	pop    %ebp
801068ee:	c3                   	ret    
801068ef:	90                   	nop

801068f0 <uartputc.part.0>:
uartputc(int c)
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	57                   	push   %edi
801068f4:	56                   	push   %esi
801068f5:	53                   	push   %ebx
801068f6:	89 c7                	mov    %eax,%edi
801068f8:	bb 80 00 00 00       	mov    $0x80,%ebx
801068fd:	be fd 03 00 00       	mov    $0x3fd,%esi
80106902:	83 ec 0c             	sub    $0xc,%esp
80106905:	eb 1b                	jmp    80106922 <uartputc.part.0+0x32>
80106907:	89 f6                	mov    %esi,%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106910:	83 ec 0c             	sub    $0xc,%esp
80106913:	6a 0a                	push   $0xa
80106915:	e8 06 c8 ff ff       	call   80103120 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010691a:	83 c4 10             	add    $0x10,%esp
8010691d:	83 eb 01             	sub    $0x1,%ebx
80106920:	74 07                	je     80106929 <uartputc.part.0+0x39>
80106922:	89 f2                	mov    %esi,%edx
80106924:	ec                   	in     (%dx),%al
80106925:	a8 20                	test   $0x20,%al
80106927:	74 e7                	je     80106910 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106929:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010692e:	89 f8                	mov    %edi,%eax
80106930:	ee                   	out    %al,(%dx)
}
80106931:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106934:	5b                   	pop    %ebx
80106935:	5e                   	pop    %esi
80106936:	5f                   	pop    %edi
80106937:	5d                   	pop    %ebp
80106938:	c3                   	ret    
80106939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106940 <uartinit>:
{
80106940:	55                   	push   %ebp
80106941:	31 c9                	xor    %ecx,%ecx
80106943:	89 c8                	mov    %ecx,%eax
80106945:	89 e5                	mov    %esp,%ebp
80106947:	57                   	push   %edi
80106948:	56                   	push   %esi
80106949:	53                   	push   %ebx
8010694a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010694f:	89 da                	mov    %ebx,%edx
80106951:	83 ec 0c             	sub    $0xc,%esp
80106954:	ee                   	out    %al,(%dx)
80106955:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010695a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010695f:	89 fa                	mov    %edi,%edx
80106961:	ee                   	out    %al,(%dx)
80106962:	b8 0c 00 00 00       	mov    $0xc,%eax
80106967:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010696c:	ee                   	out    %al,(%dx)
8010696d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106972:	89 c8                	mov    %ecx,%eax
80106974:	89 f2                	mov    %esi,%edx
80106976:	ee                   	out    %al,(%dx)
80106977:	b8 03 00 00 00       	mov    $0x3,%eax
8010697c:	89 fa                	mov    %edi,%edx
8010697e:	ee                   	out    %al,(%dx)
8010697f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106984:	89 c8                	mov    %ecx,%eax
80106986:	ee                   	out    %al,(%dx)
80106987:	b8 01 00 00 00       	mov    $0x1,%eax
8010698c:	89 f2                	mov    %esi,%edx
8010698e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010698f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106994:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106995:	3c ff                	cmp    $0xff,%al
80106997:	74 5a                	je     801069f3 <uartinit+0xb3>
  uart = 1;
80106999:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
801069a0:	00 00 00 
801069a3:	89 da                	mov    %ebx,%edx
801069a5:	ec                   	in     (%dx),%al
801069a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069ab:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801069ac:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801069af:	bb 8c 99 10 80       	mov    $0x8010998c,%ebx
  ioapicenable(IRQ_COM1, 0);
801069b4:	6a 00                	push   $0x0
801069b6:	6a 04                	push   $0x4
801069b8:	e8 53 c0 ff ff       	call   80102a10 <ioapicenable>
801069bd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801069c0:	b8 78 00 00 00       	mov    $0x78,%eax
801069c5:	eb 13                	jmp    801069da <uartinit+0x9a>
801069c7:	89 f6                	mov    %esi,%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069d0:	83 c3 01             	add    $0x1,%ebx
801069d3:	0f be 03             	movsbl (%ebx),%eax
801069d6:	84 c0                	test   %al,%al
801069d8:	74 19                	je     801069f3 <uartinit+0xb3>
  if(!uart)
801069da:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
801069e0:	85 d2                	test   %edx,%edx
801069e2:	74 ec                	je     801069d0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801069e4:	83 c3 01             	add    $0x1,%ebx
801069e7:	e8 04 ff ff ff       	call   801068f0 <uartputc.part.0>
801069ec:	0f be 03             	movsbl (%ebx),%eax
801069ef:	84 c0                	test   %al,%al
801069f1:	75 e7                	jne    801069da <uartinit+0x9a>
}
801069f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069f6:	5b                   	pop    %ebx
801069f7:	5e                   	pop    %esi
801069f8:	5f                   	pop    %edi
801069f9:	5d                   	pop    %ebp
801069fa:	c3                   	ret    
801069fb:	90                   	nop
801069fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a00 <uartputc>:
  if(!uart)
80106a00:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
80106a06:	55                   	push   %ebp
80106a07:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106a09:	85 d2                	test   %edx,%edx
{
80106a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106a0e:	74 10                	je     80106a20 <uartputc+0x20>
}
80106a10:	5d                   	pop    %ebp
80106a11:	e9 da fe ff ff       	jmp    801068f0 <uartputc.part.0>
80106a16:	8d 76 00             	lea    0x0(%esi),%esi
80106a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a20:	5d                   	pop    %ebp
80106a21:	c3                   	ret    
80106a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a30 <uartintr>:

void
uartintr(void)
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106a36:	68 c0 68 10 80       	push   $0x801068c0
80106a3b:	e8 d0 9d ff ff       	call   80100810 <consoleintr>
}
80106a40:	83 c4 10             	add    $0x10,%esp
80106a43:	c9                   	leave  
80106a44:	c3                   	ret    

80106a45 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $0
80106a47:	6a 00                	push   $0x0
  jmp alltraps
80106a49:	e9 0b fb ff ff       	jmp    80106559 <alltraps>

80106a4e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $1
80106a50:	6a 01                	push   $0x1
  jmp alltraps
80106a52:	e9 02 fb ff ff       	jmp    80106559 <alltraps>

80106a57 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $2
80106a59:	6a 02                	push   $0x2
  jmp alltraps
80106a5b:	e9 f9 fa ff ff       	jmp    80106559 <alltraps>

80106a60 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $3
80106a62:	6a 03                	push   $0x3
  jmp alltraps
80106a64:	e9 f0 fa ff ff       	jmp    80106559 <alltraps>

80106a69 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $4
80106a6b:	6a 04                	push   $0x4
  jmp alltraps
80106a6d:	e9 e7 fa ff ff       	jmp    80106559 <alltraps>

80106a72 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $5
80106a74:	6a 05                	push   $0x5
  jmp alltraps
80106a76:	e9 de fa ff ff       	jmp    80106559 <alltraps>

80106a7b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $6
80106a7d:	6a 06                	push   $0x6
  jmp alltraps
80106a7f:	e9 d5 fa ff ff       	jmp    80106559 <alltraps>

80106a84 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $7
80106a86:	6a 07                	push   $0x7
  jmp alltraps
80106a88:	e9 cc fa ff ff       	jmp    80106559 <alltraps>

80106a8d <vector8>:
.globl vector8
vector8:
  pushl $8
80106a8d:	6a 08                	push   $0x8
  jmp alltraps
80106a8f:	e9 c5 fa ff ff       	jmp    80106559 <alltraps>

80106a94 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $9
80106a96:	6a 09                	push   $0x9
  jmp alltraps
80106a98:	e9 bc fa ff ff       	jmp    80106559 <alltraps>

80106a9d <vector10>:
.globl vector10
vector10:
  pushl $10
80106a9d:	6a 0a                	push   $0xa
  jmp alltraps
80106a9f:	e9 b5 fa ff ff       	jmp    80106559 <alltraps>

80106aa4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106aa4:	6a 0b                	push   $0xb
  jmp alltraps
80106aa6:	e9 ae fa ff ff       	jmp    80106559 <alltraps>

80106aab <vector12>:
.globl vector12
vector12:
  pushl $12
80106aab:	6a 0c                	push   $0xc
  jmp alltraps
80106aad:	e9 a7 fa ff ff       	jmp    80106559 <alltraps>

80106ab2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ab2:	6a 0d                	push   $0xd
  jmp alltraps
80106ab4:	e9 a0 fa ff ff       	jmp    80106559 <alltraps>

80106ab9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ab9:	6a 0e                	push   $0xe
  jmp alltraps
80106abb:	e9 99 fa ff ff       	jmp    80106559 <alltraps>

80106ac0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ac0:	6a 00                	push   $0x0
  pushl $15
80106ac2:	6a 0f                	push   $0xf
  jmp alltraps
80106ac4:	e9 90 fa ff ff       	jmp    80106559 <alltraps>

80106ac9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $16
80106acb:	6a 10                	push   $0x10
  jmp alltraps
80106acd:	e9 87 fa ff ff       	jmp    80106559 <alltraps>

80106ad2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ad2:	6a 11                	push   $0x11
  jmp alltraps
80106ad4:	e9 80 fa ff ff       	jmp    80106559 <alltraps>

80106ad9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $18
80106adb:	6a 12                	push   $0x12
  jmp alltraps
80106add:	e9 77 fa ff ff       	jmp    80106559 <alltraps>

80106ae2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $19
80106ae4:	6a 13                	push   $0x13
  jmp alltraps
80106ae6:	e9 6e fa ff ff       	jmp    80106559 <alltraps>

80106aeb <vector20>:
.globl vector20
vector20:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $20
80106aed:	6a 14                	push   $0x14
  jmp alltraps
80106aef:	e9 65 fa ff ff       	jmp    80106559 <alltraps>

80106af4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $21
80106af6:	6a 15                	push   $0x15
  jmp alltraps
80106af8:	e9 5c fa ff ff       	jmp    80106559 <alltraps>

80106afd <vector22>:
.globl vector22
vector22:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $22
80106aff:	6a 16                	push   $0x16
  jmp alltraps
80106b01:	e9 53 fa ff ff       	jmp    80106559 <alltraps>

80106b06 <vector23>:
.globl vector23
vector23:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $23
80106b08:	6a 17                	push   $0x17
  jmp alltraps
80106b0a:	e9 4a fa ff ff       	jmp    80106559 <alltraps>

80106b0f <vector24>:
.globl vector24
vector24:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $24
80106b11:	6a 18                	push   $0x18
  jmp alltraps
80106b13:	e9 41 fa ff ff       	jmp    80106559 <alltraps>

80106b18 <vector25>:
.globl vector25
vector25:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $25
80106b1a:	6a 19                	push   $0x19
  jmp alltraps
80106b1c:	e9 38 fa ff ff       	jmp    80106559 <alltraps>

80106b21 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $26
80106b23:	6a 1a                	push   $0x1a
  jmp alltraps
80106b25:	e9 2f fa ff ff       	jmp    80106559 <alltraps>

80106b2a <vector27>:
.globl vector27
vector27:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $27
80106b2c:	6a 1b                	push   $0x1b
  jmp alltraps
80106b2e:	e9 26 fa ff ff       	jmp    80106559 <alltraps>

80106b33 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $28
80106b35:	6a 1c                	push   $0x1c
  jmp alltraps
80106b37:	e9 1d fa ff ff       	jmp    80106559 <alltraps>

80106b3c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $29
80106b3e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b40:	e9 14 fa ff ff       	jmp    80106559 <alltraps>

80106b45 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $30
80106b47:	6a 1e                	push   $0x1e
  jmp alltraps
80106b49:	e9 0b fa ff ff       	jmp    80106559 <alltraps>

80106b4e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $31
80106b50:	6a 1f                	push   $0x1f
  jmp alltraps
80106b52:	e9 02 fa ff ff       	jmp    80106559 <alltraps>

80106b57 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $32
80106b59:	6a 20                	push   $0x20
  jmp alltraps
80106b5b:	e9 f9 f9 ff ff       	jmp    80106559 <alltraps>

80106b60 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $33
80106b62:	6a 21                	push   $0x21
  jmp alltraps
80106b64:	e9 f0 f9 ff ff       	jmp    80106559 <alltraps>

80106b69 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $34
80106b6b:	6a 22                	push   $0x22
  jmp alltraps
80106b6d:	e9 e7 f9 ff ff       	jmp    80106559 <alltraps>

80106b72 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $35
80106b74:	6a 23                	push   $0x23
  jmp alltraps
80106b76:	e9 de f9 ff ff       	jmp    80106559 <alltraps>

80106b7b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $36
80106b7d:	6a 24                	push   $0x24
  jmp alltraps
80106b7f:	e9 d5 f9 ff ff       	jmp    80106559 <alltraps>

80106b84 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $37
80106b86:	6a 25                	push   $0x25
  jmp alltraps
80106b88:	e9 cc f9 ff ff       	jmp    80106559 <alltraps>

80106b8d <vector38>:
.globl vector38
vector38:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $38
80106b8f:	6a 26                	push   $0x26
  jmp alltraps
80106b91:	e9 c3 f9 ff ff       	jmp    80106559 <alltraps>

80106b96 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $39
80106b98:	6a 27                	push   $0x27
  jmp alltraps
80106b9a:	e9 ba f9 ff ff       	jmp    80106559 <alltraps>

80106b9f <vector40>:
.globl vector40
vector40:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $40
80106ba1:	6a 28                	push   $0x28
  jmp alltraps
80106ba3:	e9 b1 f9 ff ff       	jmp    80106559 <alltraps>

80106ba8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $41
80106baa:	6a 29                	push   $0x29
  jmp alltraps
80106bac:	e9 a8 f9 ff ff       	jmp    80106559 <alltraps>

80106bb1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $42
80106bb3:	6a 2a                	push   $0x2a
  jmp alltraps
80106bb5:	e9 9f f9 ff ff       	jmp    80106559 <alltraps>

80106bba <vector43>:
.globl vector43
vector43:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $43
80106bbc:	6a 2b                	push   $0x2b
  jmp alltraps
80106bbe:	e9 96 f9 ff ff       	jmp    80106559 <alltraps>

80106bc3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $44
80106bc5:	6a 2c                	push   $0x2c
  jmp alltraps
80106bc7:	e9 8d f9 ff ff       	jmp    80106559 <alltraps>

80106bcc <vector45>:
.globl vector45
vector45:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $45
80106bce:	6a 2d                	push   $0x2d
  jmp alltraps
80106bd0:	e9 84 f9 ff ff       	jmp    80106559 <alltraps>

80106bd5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $46
80106bd7:	6a 2e                	push   $0x2e
  jmp alltraps
80106bd9:	e9 7b f9 ff ff       	jmp    80106559 <alltraps>

80106bde <vector47>:
.globl vector47
vector47:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $47
80106be0:	6a 2f                	push   $0x2f
  jmp alltraps
80106be2:	e9 72 f9 ff ff       	jmp    80106559 <alltraps>

80106be7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $48
80106be9:	6a 30                	push   $0x30
  jmp alltraps
80106beb:	e9 69 f9 ff ff       	jmp    80106559 <alltraps>

80106bf0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $49
80106bf2:	6a 31                	push   $0x31
  jmp alltraps
80106bf4:	e9 60 f9 ff ff       	jmp    80106559 <alltraps>

80106bf9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $50
80106bfb:	6a 32                	push   $0x32
  jmp alltraps
80106bfd:	e9 57 f9 ff ff       	jmp    80106559 <alltraps>

80106c02 <vector51>:
.globl vector51
vector51:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $51
80106c04:	6a 33                	push   $0x33
  jmp alltraps
80106c06:	e9 4e f9 ff ff       	jmp    80106559 <alltraps>

80106c0b <vector52>:
.globl vector52
vector52:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $52
80106c0d:	6a 34                	push   $0x34
  jmp alltraps
80106c0f:	e9 45 f9 ff ff       	jmp    80106559 <alltraps>

80106c14 <vector53>:
.globl vector53
vector53:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $53
80106c16:	6a 35                	push   $0x35
  jmp alltraps
80106c18:	e9 3c f9 ff ff       	jmp    80106559 <alltraps>

80106c1d <vector54>:
.globl vector54
vector54:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $54
80106c1f:	6a 36                	push   $0x36
  jmp alltraps
80106c21:	e9 33 f9 ff ff       	jmp    80106559 <alltraps>

80106c26 <vector55>:
.globl vector55
vector55:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $55
80106c28:	6a 37                	push   $0x37
  jmp alltraps
80106c2a:	e9 2a f9 ff ff       	jmp    80106559 <alltraps>

80106c2f <vector56>:
.globl vector56
vector56:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $56
80106c31:	6a 38                	push   $0x38
  jmp alltraps
80106c33:	e9 21 f9 ff ff       	jmp    80106559 <alltraps>

80106c38 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $57
80106c3a:	6a 39                	push   $0x39
  jmp alltraps
80106c3c:	e9 18 f9 ff ff       	jmp    80106559 <alltraps>

80106c41 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $58
80106c43:	6a 3a                	push   $0x3a
  jmp alltraps
80106c45:	e9 0f f9 ff ff       	jmp    80106559 <alltraps>

80106c4a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $59
80106c4c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c4e:	e9 06 f9 ff ff       	jmp    80106559 <alltraps>

80106c53 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $60
80106c55:	6a 3c                	push   $0x3c
  jmp alltraps
80106c57:	e9 fd f8 ff ff       	jmp    80106559 <alltraps>

80106c5c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $61
80106c5e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c60:	e9 f4 f8 ff ff       	jmp    80106559 <alltraps>

80106c65 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $62
80106c67:	6a 3e                	push   $0x3e
  jmp alltraps
80106c69:	e9 eb f8 ff ff       	jmp    80106559 <alltraps>

80106c6e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $63
80106c70:	6a 3f                	push   $0x3f
  jmp alltraps
80106c72:	e9 e2 f8 ff ff       	jmp    80106559 <alltraps>

80106c77 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $64
80106c79:	6a 40                	push   $0x40
  jmp alltraps
80106c7b:	e9 d9 f8 ff ff       	jmp    80106559 <alltraps>

80106c80 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $65
80106c82:	6a 41                	push   $0x41
  jmp alltraps
80106c84:	e9 d0 f8 ff ff       	jmp    80106559 <alltraps>

80106c89 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $66
80106c8b:	6a 42                	push   $0x42
  jmp alltraps
80106c8d:	e9 c7 f8 ff ff       	jmp    80106559 <alltraps>

80106c92 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $67
80106c94:	6a 43                	push   $0x43
  jmp alltraps
80106c96:	e9 be f8 ff ff       	jmp    80106559 <alltraps>

80106c9b <vector68>:
.globl vector68
vector68:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $68
80106c9d:	6a 44                	push   $0x44
  jmp alltraps
80106c9f:	e9 b5 f8 ff ff       	jmp    80106559 <alltraps>

80106ca4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106ca4:	6a 00                	push   $0x0
  pushl $69
80106ca6:	6a 45                	push   $0x45
  jmp alltraps
80106ca8:	e9 ac f8 ff ff       	jmp    80106559 <alltraps>

80106cad <vector70>:
.globl vector70
vector70:
  pushl $0
80106cad:	6a 00                	push   $0x0
  pushl $70
80106caf:	6a 46                	push   $0x46
  jmp alltraps
80106cb1:	e9 a3 f8 ff ff       	jmp    80106559 <alltraps>

80106cb6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106cb6:	6a 00                	push   $0x0
  pushl $71
80106cb8:	6a 47                	push   $0x47
  jmp alltraps
80106cba:	e9 9a f8 ff ff       	jmp    80106559 <alltraps>

80106cbf <vector72>:
.globl vector72
vector72:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $72
80106cc1:	6a 48                	push   $0x48
  jmp alltraps
80106cc3:	e9 91 f8 ff ff       	jmp    80106559 <alltraps>

80106cc8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106cc8:	6a 00                	push   $0x0
  pushl $73
80106cca:	6a 49                	push   $0x49
  jmp alltraps
80106ccc:	e9 88 f8 ff ff       	jmp    80106559 <alltraps>

80106cd1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106cd1:	6a 00                	push   $0x0
  pushl $74
80106cd3:	6a 4a                	push   $0x4a
  jmp alltraps
80106cd5:	e9 7f f8 ff ff       	jmp    80106559 <alltraps>

80106cda <vector75>:
.globl vector75
vector75:
  pushl $0
80106cda:	6a 00                	push   $0x0
  pushl $75
80106cdc:	6a 4b                	push   $0x4b
  jmp alltraps
80106cde:	e9 76 f8 ff ff       	jmp    80106559 <alltraps>

80106ce3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $76
80106ce5:	6a 4c                	push   $0x4c
  jmp alltraps
80106ce7:	e9 6d f8 ff ff       	jmp    80106559 <alltraps>

80106cec <vector77>:
.globl vector77
vector77:
  pushl $0
80106cec:	6a 00                	push   $0x0
  pushl $77
80106cee:	6a 4d                	push   $0x4d
  jmp alltraps
80106cf0:	e9 64 f8 ff ff       	jmp    80106559 <alltraps>

80106cf5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106cf5:	6a 00                	push   $0x0
  pushl $78
80106cf7:	6a 4e                	push   $0x4e
  jmp alltraps
80106cf9:	e9 5b f8 ff ff       	jmp    80106559 <alltraps>

80106cfe <vector79>:
.globl vector79
vector79:
  pushl $0
80106cfe:	6a 00                	push   $0x0
  pushl $79
80106d00:	6a 4f                	push   $0x4f
  jmp alltraps
80106d02:	e9 52 f8 ff ff       	jmp    80106559 <alltraps>

80106d07 <vector80>:
.globl vector80
vector80:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $80
80106d09:	6a 50                	push   $0x50
  jmp alltraps
80106d0b:	e9 49 f8 ff ff       	jmp    80106559 <alltraps>

80106d10 <vector81>:
.globl vector81
vector81:
  pushl $0
80106d10:	6a 00                	push   $0x0
  pushl $81
80106d12:	6a 51                	push   $0x51
  jmp alltraps
80106d14:	e9 40 f8 ff ff       	jmp    80106559 <alltraps>

80106d19 <vector82>:
.globl vector82
vector82:
  pushl $0
80106d19:	6a 00                	push   $0x0
  pushl $82
80106d1b:	6a 52                	push   $0x52
  jmp alltraps
80106d1d:	e9 37 f8 ff ff       	jmp    80106559 <alltraps>

80106d22 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d22:	6a 00                	push   $0x0
  pushl $83
80106d24:	6a 53                	push   $0x53
  jmp alltraps
80106d26:	e9 2e f8 ff ff       	jmp    80106559 <alltraps>

80106d2b <vector84>:
.globl vector84
vector84:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $84
80106d2d:	6a 54                	push   $0x54
  jmp alltraps
80106d2f:	e9 25 f8 ff ff       	jmp    80106559 <alltraps>

80106d34 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $85
80106d36:	6a 55                	push   $0x55
  jmp alltraps
80106d38:	e9 1c f8 ff ff       	jmp    80106559 <alltraps>

80106d3d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $86
80106d3f:	6a 56                	push   $0x56
  jmp alltraps
80106d41:	e9 13 f8 ff ff       	jmp    80106559 <alltraps>

80106d46 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $87
80106d48:	6a 57                	push   $0x57
  jmp alltraps
80106d4a:	e9 0a f8 ff ff       	jmp    80106559 <alltraps>

80106d4f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $88
80106d51:	6a 58                	push   $0x58
  jmp alltraps
80106d53:	e9 01 f8 ff ff       	jmp    80106559 <alltraps>

80106d58 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $89
80106d5a:	6a 59                	push   $0x59
  jmp alltraps
80106d5c:	e9 f8 f7 ff ff       	jmp    80106559 <alltraps>

80106d61 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $90
80106d63:	6a 5a                	push   $0x5a
  jmp alltraps
80106d65:	e9 ef f7 ff ff       	jmp    80106559 <alltraps>

80106d6a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $91
80106d6c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d6e:	e9 e6 f7 ff ff       	jmp    80106559 <alltraps>

80106d73 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $92
80106d75:	6a 5c                	push   $0x5c
  jmp alltraps
80106d77:	e9 dd f7 ff ff       	jmp    80106559 <alltraps>

80106d7c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $93
80106d7e:	6a 5d                	push   $0x5d
  jmp alltraps
80106d80:	e9 d4 f7 ff ff       	jmp    80106559 <alltraps>

80106d85 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $94
80106d87:	6a 5e                	push   $0x5e
  jmp alltraps
80106d89:	e9 cb f7 ff ff       	jmp    80106559 <alltraps>

80106d8e <vector95>:
.globl vector95
vector95:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $95
80106d90:	6a 5f                	push   $0x5f
  jmp alltraps
80106d92:	e9 c2 f7 ff ff       	jmp    80106559 <alltraps>

80106d97 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $96
80106d99:	6a 60                	push   $0x60
  jmp alltraps
80106d9b:	e9 b9 f7 ff ff       	jmp    80106559 <alltraps>

80106da0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $97
80106da2:	6a 61                	push   $0x61
  jmp alltraps
80106da4:	e9 b0 f7 ff ff       	jmp    80106559 <alltraps>

80106da9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $98
80106dab:	6a 62                	push   $0x62
  jmp alltraps
80106dad:	e9 a7 f7 ff ff       	jmp    80106559 <alltraps>

80106db2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $99
80106db4:	6a 63                	push   $0x63
  jmp alltraps
80106db6:	e9 9e f7 ff ff       	jmp    80106559 <alltraps>

80106dbb <vector100>:
.globl vector100
vector100:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $100
80106dbd:	6a 64                	push   $0x64
  jmp alltraps
80106dbf:	e9 95 f7 ff ff       	jmp    80106559 <alltraps>

80106dc4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $101
80106dc6:	6a 65                	push   $0x65
  jmp alltraps
80106dc8:	e9 8c f7 ff ff       	jmp    80106559 <alltraps>

80106dcd <vector102>:
.globl vector102
vector102:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $102
80106dcf:	6a 66                	push   $0x66
  jmp alltraps
80106dd1:	e9 83 f7 ff ff       	jmp    80106559 <alltraps>

80106dd6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $103
80106dd8:	6a 67                	push   $0x67
  jmp alltraps
80106dda:	e9 7a f7 ff ff       	jmp    80106559 <alltraps>

80106ddf <vector104>:
.globl vector104
vector104:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $104
80106de1:	6a 68                	push   $0x68
  jmp alltraps
80106de3:	e9 71 f7 ff ff       	jmp    80106559 <alltraps>

80106de8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $105
80106dea:	6a 69                	push   $0x69
  jmp alltraps
80106dec:	e9 68 f7 ff ff       	jmp    80106559 <alltraps>

80106df1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $106
80106df3:	6a 6a                	push   $0x6a
  jmp alltraps
80106df5:	e9 5f f7 ff ff       	jmp    80106559 <alltraps>

80106dfa <vector107>:
.globl vector107
vector107:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $107
80106dfc:	6a 6b                	push   $0x6b
  jmp alltraps
80106dfe:	e9 56 f7 ff ff       	jmp    80106559 <alltraps>

80106e03 <vector108>:
.globl vector108
vector108:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $108
80106e05:	6a 6c                	push   $0x6c
  jmp alltraps
80106e07:	e9 4d f7 ff ff       	jmp    80106559 <alltraps>

80106e0c <vector109>:
.globl vector109
vector109:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $109
80106e0e:	6a 6d                	push   $0x6d
  jmp alltraps
80106e10:	e9 44 f7 ff ff       	jmp    80106559 <alltraps>

80106e15 <vector110>:
.globl vector110
vector110:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $110
80106e17:	6a 6e                	push   $0x6e
  jmp alltraps
80106e19:	e9 3b f7 ff ff       	jmp    80106559 <alltraps>

80106e1e <vector111>:
.globl vector111
vector111:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $111
80106e20:	6a 6f                	push   $0x6f
  jmp alltraps
80106e22:	e9 32 f7 ff ff       	jmp    80106559 <alltraps>

80106e27 <vector112>:
.globl vector112
vector112:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $112
80106e29:	6a 70                	push   $0x70
  jmp alltraps
80106e2b:	e9 29 f7 ff ff       	jmp    80106559 <alltraps>

80106e30 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $113
80106e32:	6a 71                	push   $0x71
  jmp alltraps
80106e34:	e9 20 f7 ff ff       	jmp    80106559 <alltraps>

80106e39 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $114
80106e3b:	6a 72                	push   $0x72
  jmp alltraps
80106e3d:	e9 17 f7 ff ff       	jmp    80106559 <alltraps>

80106e42 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $115
80106e44:	6a 73                	push   $0x73
  jmp alltraps
80106e46:	e9 0e f7 ff ff       	jmp    80106559 <alltraps>

80106e4b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $116
80106e4d:	6a 74                	push   $0x74
  jmp alltraps
80106e4f:	e9 05 f7 ff ff       	jmp    80106559 <alltraps>

80106e54 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $117
80106e56:	6a 75                	push   $0x75
  jmp alltraps
80106e58:	e9 fc f6 ff ff       	jmp    80106559 <alltraps>

80106e5d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $118
80106e5f:	6a 76                	push   $0x76
  jmp alltraps
80106e61:	e9 f3 f6 ff ff       	jmp    80106559 <alltraps>

80106e66 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $119
80106e68:	6a 77                	push   $0x77
  jmp alltraps
80106e6a:	e9 ea f6 ff ff       	jmp    80106559 <alltraps>

80106e6f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $120
80106e71:	6a 78                	push   $0x78
  jmp alltraps
80106e73:	e9 e1 f6 ff ff       	jmp    80106559 <alltraps>

80106e78 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $121
80106e7a:	6a 79                	push   $0x79
  jmp alltraps
80106e7c:	e9 d8 f6 ff ff       	jmp    80106559 <alltraps>

80106e81 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $122
80106e83:	6a 7a                	push   $0x7a
  jmp alltraps
80106e85:	e9 cf f6 ff ff       	jmp    80106559 <alltraps>

80106e8a <vector123>:
.globl vector123
vector123:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $123
80106e8c:	6a 7b                	push   $0x7b
  jmp alltraps
80106e8e:	e9 c6 f6 ff ff       	jmp    80106559 <alltraps>

80106e93 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $124
80106e95:	6a 7c                	push   $0x7c
  jmp alltraps
80106e97:	e9 bd f6 ff ff       	jmp    80106559 <alltraps>

80106e9c <vector125>:
.globl vector125
vector125:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $125
80106e9e:	6a 7d                	push   $0x7d
  jmp alltraps
80106ea0:	e9 b4 f6 ff ff       	jmp    80106559 <alltraps>

80106ea5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $126
80106ea7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ea9:	e9 ab f6 ff ff       	jmp    80106559 <alltraps>

80106eae <vector127>:
.globl vector127
vector127:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $127
80106eb0:	6a 7f                	push   $0x7f
  jmp alltraps
80106eb2:	e9 a2 f6 ff ff       	jmp    80106559 <alltraps>

80106eb7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $128
80106eb9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106ebe:	e9 96 f6 ff ff       	jmp    80106559 <alltraps>

80106ec3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $129
80106ec5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106eca:	e9 8a f6 ff ff       	jmp    80106559 <alltraps>

80106ecf <vector130>:
.globl vector130
vector130:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $130
80106ed1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ed6:	e9 7e f6 ff ff       	jmp    80106559 <alltraps>

80106edb <vector131>:
.globl vector131
vector131:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $131
80106edd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ee2:	e9 72 f6 ff ff       	jmp    80106559 <alltraps>

80106ee7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $132
80106ee9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106eee:	e9 66 f6 ff ff       	jmp    80106559 <alltraps>

80106ef3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $133
80106ef5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106efa:	e9 5a f6 ff ff       	jmp    80106559 <alltraps>

80106eff <vector134>:
.globl vector134
vector134:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $134
80106f01:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106f06:	e9 4e f6 ff ff       	jmp    80106559 <alltraps>

80106f0b <vector135>:
.globl vector135
vector135:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $135
80106f0d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106f12:	e9 42 f6 ff ff       	jmp    80106559 <alltraps>

80106f17 <vector136>:
.globl vector136
vector136:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $136
80106f19:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f1e:	e9 36 f6 ff ff       	jmp    80106559 <alltraps>

80106f23 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $137
80106f25:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f2a:	e9 2a f6 ff ff       	jmp    80106559 <alltraps>

80106f2f <vector138>:
.globl vector138
vector138:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $138
80106f31:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f36:	e9 1e f6 ff ff       	jmp    80106559 <alltraps>

80106f3b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $139
80106f3d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f42:	e9 12 f6 ff ff       	jmp    80106559 <alltraps>

80106f47 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $140
80106f49:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f4e:	e9 06 f6 ff ff       	jmp    80106559 <alltraps>

80106f53 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $141
80106f55:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f5a:	e9 fa f5 ff ff       	jmp    80106559 <alltraps>

80106f5f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $142
80106f61:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f66:	e9 ee f5 ff ff       	jmp    80106559 <alltraps>

80106f6b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $143
80106f6d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f72:	e9 e2 f5 ff ff       	jmp    80106559 <alltraps>

80106f77 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $144
80106f79:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f7e:	e9 d6 f5 ff ff       	jmp    80106559 <alltraps>

80106f83 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $145
80106f85:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f8a:	e9 ca f5 ff ff       	jmp    80106559 <alltraps>

80106f8f <vector146>:
.globl vector146
vector146:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $146
80106f91:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f96:	e9 be f5 ff ff       	jmp    80106559 <alltraps>

80106f9b <vector147>:
.globl vector147
vector147:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $147
80106f9d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106fa2:	e9 b2 f5 ff ff       	jmp    80106559 <alltraps>

80106fa7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $148
80106fa9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106fae:	e9 a6 f5 ff ff       	jmp    80106559 <alltraps>

80106fb3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $149
80106fb5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106fba:	e9 9a f5 ff ff       	jmp    80106559 <alltraps>

80106fbf <vector150>:
.globl vector150
vector150:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $150
80106fc1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106fc6:	e9 8e f5 ff ff       	jmp    80106559 <alltraps>

80106fcb <vector151>:
.globl vector151
vector151:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $151
80106fcd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fd2:	e9 82 f5 ff ff       	jmp    80106559 <alltraps>

80106fd7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $152
80106fd9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fde:	e9 76 f5 ff ff       	jmp    80106559 <alltraps>

80106fe3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $153
80106fe5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fea:	e9 6a f5 ff ff       	jmp    80106559 <alltraps>

80106fef <vector154>:
.globl vector154
vector154:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $154
80106ff1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ff6:	e9 5e f5 ff ff       	jmp    80106559 <alltraps>

80106ffb <vector155>:
.globl vector155
vector155:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $155
80106ffd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107002:	e9 52 f5 ff ff       	jmp    80106559 <alltraps>

80107007 <vector156>:
.globl vector156
vector156:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $156
80107009:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010700e:	e9 46 f5 ff ff       	jmp    80106559 <alltraps>

80107013 <vector157>:
.globl vector157
vector157:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $157
80107015:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010701a:	e9 3a f5 ff ff       	jmp    80106559 <alltraps>

8010701f <vector158>:
.globl vector158
vector158:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $158
80107021:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107026:	e9 2e f5 ff ff       	jmp    80106559 <alltraps>

8010702b <vector159>:
.globl vector159
vector159:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $159
8010702d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107032:	e9 22 f5 ff ff       	jmp    80106559 <alltraps>

80107037 <vector160>:
.globl vector160
vector160:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $160
80107039:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010703e:	e9 16 f5 ff ff       	jmp    80106559 <alltraps>

80107043 <vector161>:
.globl vector161
vector161:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $161
80107045:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010704a:	e9 0a f5 ff ff       	jmp    80106559 <alltraps>

8010704f <vector162>:
.globl vector162
vector162:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $162
80107051:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107056:	e9 fe f4 ff ff       	jmp    80106559 <alltraps>

8010705b <vector163>:
.globl vector163
vector163:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $163
8010705d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107062:	e9 f2 f4 ff ff       	jmp    80106559 <alltraps>

80107067 <vector164>:
.globl vector164
vector164:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $164
80107069:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010706e:	e9 e6 f4 ff ff       	jmp    80106559 <alltraps>

80107073 <vector165>:
.globl vector165
vector165:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $165
80107075:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010707a:	e9 da f4 ff ff       	jmp    80106559 <alltraps>

8010707f <vector166>:
.globl vector166
vector166:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $166
80107081:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107086:	e9 ce f4 ff ff       	jmp    80106559 <alltraps>

8010708b <vector167>:
.globl vector167
vector167:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $167
8010708d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107092:	e9 c2 f4 ff ff       	jmp    80106559 <alltraps>

80107097 <vector168>:
.globl vector168
vector168:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $168
80107099:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010709e:	e9 b6 f4 ff ff       	jmp    80106559 <alltraps>

801070a3 <vector169>:
.globl vector169
vector169:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $169
801070a5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801070aa:	e9 aa f4 ff ff       	jmp    80106559 <alltraps>

801070af <vector170>:
.globl vector170
vector170:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $170
801070b1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801070b6:	e9 9e f4 ff ff       	jmp    80106559 <alltraps>

801070bb <vector171>:
.globl vector171
vector171:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $171
801070bd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801070c2:	e9 92 f4 ff ff       	jmp    80106559 <alltraps>

801070c7 <vector172>:
.globl vector172
vector172:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $172
801070c9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070ce:	e9 86 f4 ff ff       	jmp    80106559 <alltraps>

801070d3 <vector173>:
.globl vector173
vector173:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $173
801070d5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070da:	e9 7a f4 ff ff       	jmp    80106559 <alltraps>

801070df <vector174>:
.globl vector174
vector174:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $174
801070e1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070e6:	e9 6e f4 ff ff       	jmp    80106559 <alltraps>

801070eb <vector175>:
.globl vector175
vector175:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $175
801070ed:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070f2:	e9 62 f4 ff ff       	jmp    80106559 <alltraps>

801070f7 <vector176>:
.globl vector176
vector176:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $176
801070f9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070fe:	e9 56 f4 ff ff       	jmp    80106559 <alltraps>

80107103 <vector177>:
.globl vector177
vector177:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $177
80107105:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010710a:	e9 4a f4 ff ff       	jmp    80106559 <alltraps>

8010710f <vector178>:
.globl vector178
vector178:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $178
80107111:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107116:	e9 3e f4 ff ff       	jmp    80106559 <alltraps>

8010711b <vector179>:
.globl vector179
vector179:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $179
8010711d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107122:	e9 32 f4 ff ff       	jmp    80106559 <alltraps>

80107127 <vector180>:
.globl vector180
vector180:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $180
80107129:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010712e:	e9 26 f4 ff ff       	jmp    80106559 <alltraps>

80107133 <vector181>:
.globl vector181
vector181:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $181
80107135:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010713a:	e9 1a f4 ff ff       	jmp    80106559 <alltraps>

8010713f <vector182>:
.globl vector182
vector182:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $182
80107141:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107146:	e9 0e f4 ff ff       	jmp    80106559 <alltraps>

8010714b <vector183>:
.globl vector183
vector183:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $183
8010714d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107152:	e9 02 f4 ff ff       	jmp    80106559 <alltraps>

80107157 <vector184>:
.globl vector184
vector184:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $184
80107159:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010715e:	e9 f6 f3 ff ff       	jmp    80106559 <alltraps>

80107163 <vector185>:
.globl vector185
vector185:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $185
80107165:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010716a:	e9 ea f3 ff ff       	jmp    80106559 <alltraps>

8010716f <vector186>:
.globl vector186
vector186:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $186
80107171:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107176:	e9 de f3 ff ff       	jmp    80106559 <alltraps>

8010717b <vector187>:
.globl vector187
vector187:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $187
8010717d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107182:	e9 d2 f3 ff ff       	jmp    80106559 <alltraps>

80107187 <vector188>:
.globl vector188
vector188:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $188
80107189:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010718e:	e9 c6 f3 ff ff       	jmp    80106559 <alltraps>

80107193 <vector189>:
.globl vector189
vector189:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $189
80107195:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010719a:	e9 ba f3 ff ff       	jmp    80106559 <alltraps>

8010719f <vector190>:
.globl vector190
vector190:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $190
801071a1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801071a6:	e9 ae f3 ff ff       	jmp    80106559 <alltraps>

801071ab <vector191>:
.globl vector191
vector191:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $191
801071ad:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801071b2:	e9 a2 f3 ff ff       	jmp    80106559 <alltraps>

801071b7 <vector192>:
.globl vector192
vector192:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $192
801071b9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801071be:	e9 96 f3 ff ff       	jmp    80106559 <alltraps>

801071c3 <vector193>:
.globl vector193
vector193:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $193
801071c5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071ca:	e9 8a f3 ff ff       	jmp    80106559 <alltraps>

801071cf <vector194>:
.globl vector194
vector194:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $194
801071d1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071d6:	e9 7e f3 ff ff       	jmp    80106559 <alltraps>

801071db <vector195>:
.globl vector195
vector195:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $195
801071dd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071e2:	e9 72 f3 ff ff       	jmp    80106559 <alltraps>

801071e7 <vector196>:
.globl vector196
vector196:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $196
801071e9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071ee:	e9 66 f3 ff ff       	jmp    80106559 <alltraps>

801071f3 <vector197>:
.globl vector197
vector197:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $197
801071f5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071fa:	e9 5a f3 ff ff       	jmp    80106559 <alltraps>

801071ff <vector198>:
.globl vector198
vector198:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $198
80107201:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107206:	e9 4e f3 ff ff       	jmp    80106559 <alltraps>

8010720b <vector199>:
.globl vector199
vector199:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $199
8010720d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107212:	e9 42 f3 ff ff       	jmp    80106559 <alltraps>

80107217 <vector200>:
.globl vector200
vector200:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $200
80107219:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010721e:	e9 36 f3 ff ff       	jmp    80106559 <alltraps>

80107223 <vector201>:
.globl vector201
vector201:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $201
80107225:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010722a:	e9 2a f3 ff ff       	jmp    80106559 <alltraps>

8010722f <vector202>:
.globl vector202
vector202:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $202
80107231:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107236:	e9 1e f3 ff ff       	jmp    80106559 <alltraps>

8010723b <vector203>:
.globl vector203
vector203:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $203
8010723d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107242:	e9 12 f3 ff ff       	jmp    80106559 <alltraps>

80107247 <vector204>:
.globl vector204
vector204:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $204
80107249:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010724e:	e9 06 f3 ff ff       	jmp    80106559 <alltraps>

80107253 <vector205>:
.globl vector205
vector205:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $205
80107255:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010725a:	e9 fa f2 ff ff       	jmp    80106559 <alltraps>

8010725f <vector206>:
.globl vector206
vector206:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $206
80107261:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107266:	e9 ee f2 ff ff       	jmp    80106559 <alltraps>

8010726b <vector207>:
.globl vector207
vector207:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $207
8010726d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107272:	e9 e2 f2 ff ff       	jmp    80106559 <alltraps>

80107277 <vector208>:
.globl vector208
vector208:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $208
80107279:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010727e:	e9 d6 f2 ff ff       	jmp    80106559 <alltraps>

80107283 <vector209>:
.globl vector209
vector209:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $209
80107285:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010728a:	e9 ca f2 ff ff       	jmp    80106559 <alltraps>

8010728f <vector210>:
.globl vector210
vector210:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $210
80107291:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107296:	e9 be f2 ff ff       	jmp    80106559 <alltraps>

8010729b <vector211>:
.globl vector211
vector211:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $211
8010729d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801072a2:	e9 b2 f2 ff ff       	jmp    80106559 <alltraps>

801072a7 <vector212>:
.globl vector212
vector212:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $212
801072a9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801072ae:	e9 a6 f2 ff ff       	jmp    80106559 <alltraps>

801072b3 <vector213>:
.globl vector213
vector213:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $213
801072b5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801072ba:	e9 9a f2 ff ff       	jmp    80106559 <alltraps>

801072bf <vector214>:
.globl vector214
vector214:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $214
801072c1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801072c6:	e9 8e f2 ff ff       	jmp    80106559 <alltraps>

801072cb <vector215>:
.globl vector215
vector215:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $215
801072cd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072d2:	e9 82 f2 ff ff       	jmp    80106559 <alltraps>

801072d7 <vector216>:
.globl vector216
vector216:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $216
801072d9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072de:	e9 76 f2 ff ff       	jmp    80106559 <alltraps>

801072e3 <vector217>:
.globl vector217
vector217:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $217
801072e5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072ea:	e9 6a f2 ff ff       	jmp    80106559 <alltraps>

801072ef <vector218>:
.globl vector218
vector218:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $218
801072f1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072f6:	e9 5e f2 ff ff       	jmp    80106559 <alltraps>

801072fb <vector219>:
.globl vector219
vector219:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $219
801072fd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107302:	e9 52 f2 ff ff       	jmp    80106559 <alltraps>

80107307 <vector220>:
.globl vector220
vector220:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $220
80107309:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010730e:	e9 46 f2 ff ff       	jmp    80106559 <alltraps>

80107313 <vector221>:
.globl vector221
vector221:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $221
80107315:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010731a:	e9 3a f2 ff ff       	jmp    80106559 <alltraps>

8010731f <vector222>:
.globl vector222
vector222:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $222
80107321:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107326:	e9 2e f2 ff ff       	jmp    80106559 <alltraps>

8010732b <vector223>:
.globl vector223
vector223:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $223
8010732d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107332:	e9 22 f2 ff ff       	jmp    80106559 <alltraps>

80107337 <vector224>:
.globl vector224
vector224:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $224
80107339:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010733e:	e9 16 f2 ff ff       	jmp    80106559 <alltraps>

80107343 <vector225>:
.globl vector225
vector225:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $225
80107345:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010734a:	e9 0a f2 ff ff       	jmp    80106559 <alltraps>

8010734f <vector226>:
.globl vector226
vector226:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $226
80107351:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107356:	e9 fe f1 ff ff       	jmp    80106559 <alltraps>

8010735b <vector227>:
.globl vector227
vector227:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $227
8010735d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107362:	e9 f2 f1 ff ff       	jmp    80106559 <alltraps>

80107367 <vector228>:
.globl vector228
vector228:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $228
80107369:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010736e:	e9 e6 f1 ff ff       	jmp    80106559 <alltraps>

80107373 <vector229>:
.globl vector229
vector229:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $229
80107375:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010737a:	e9 da f1 ff ff       	jmp    80106559 <alltraps>

8010737f <vector230>:
.globl vector230
vector230:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $230
80107381:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107386:	e9 ce f1 ff ff       	jmp    80106559 <alltraps>

8010738b <vector231>:
.globl vector231
vector231:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $231
8010738d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107392:	e9 c2 f1 ff ff       	jmp    80106559 <alltraps>

80107397 <vector232>:
.globl vector232
vector232:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $232
80107399:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010739e:	e9 b6 f1 ff ff       	jmp    80106559 <alltraps>

801073a3 <vector233>:
.globl vector233
vector233:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $233
801073a5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801073aa:	e9 aa f1 ff ff       	jmp    80106559 <alltraps>

801073af <vector234>:
.globl vector234
vector234:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $234
801073b1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801073b6:	e9 9e f1 ff ff       	jmp    80106559 <alltraps>

801073bb <vector235>:
.globl vector235
vector235:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $235
801073bd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801073c2:	e9 92 f1 ff ff       	jmp    80106559 <alltraps>

801073c7 <vector236>:
.globl vector236
vector236:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $236
801073c9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073ce:	e9 86 f1 ff ff       	jmp    80106559 <alltraps>

801073d3 <vector237>:
.globl vector237
vector237:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $237
801073d5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073da:	e9 7a f1 ff ff       	jmp    80106559 <alltraps>

801073df <vector238>:
.globl vector238
vector238:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $238
801073e1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073e6:	e9 6e f1 ff ff       	jmp    80106559 <alltraps>

801073eb <vector239>:
.globl vector239
vector239:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $239
801073ed:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073f2:	e9 62 f1 ff ff       	jmp    80106559 <alltraps>

801073f7 <vector240>:
.globl vector240
vector240:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $240
801073f9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073fe:	e9 56 f1 ff ff       	jmp    80106559 <alltraps>

80107403 <vector241>:
.globl vector241
vector241:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $241
80107405:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010740a:	e9 4a f1 ff ff       	jmp    80106559 <alltraps>

8010740f <vector242>:
.globl vector242
vector242:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $242
80107411:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107416:	e9 3e f1 ff ff       	jmp    80106559 <alltraps>

8010741b <vector243>:
.globl vector243
vector243:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $243
8010741d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107422:	e9 32 f1 ff ff       	jmp    80106559 <alltraps>

80107427 <vector244>:
.globl vector244
vector244:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $244
80107429:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010742e:	e9 26 f1 ff ff       	jmp    80106559 <alltraps>

80107433 <vector245>:
.globl vector245
vector245:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $245
80107435:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010743a:	e9 1a f1 ff ff       	jmp    80106559 <alltraps>

8010743f <vector246>:
.globl vector246
vector246:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $246
80107441:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107446:	e9 0e f1 ff ff       	jmp    80106559 <alltraps>

8010744b <vector247>:
.globl vector247
vector247:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $247
8010744d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107452:	e9 02 f1 ff ff       	jmp    80106559 <alltraps>

80107457 <vector248>:
.globl vector248
vector248:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $248
80107459:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010745e:	e9 f6 f0 ff ff       	jmp    80106559 <alltraps>

80107463 <vector249>:
.globl vector249
vector249:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $249
80107465:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010746a:	e9 ea f0 ff ff       	jmp    80106559 <alltraps>

8010746f <vector250>:
.globl vector250
vector250:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $250
80107471:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107476:	e9 de f0 ff ff       	jmp    80106559 <alltraps>

8010747b <vector251>:
.globl vector251
vector251:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $251
8010747d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107482:	e9 d2 f0 ff ff       	jmp    80106559 <alltraps>

80107487 <vector252>:
.globl vector252
vector252:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $252
80107489:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010748e:	e9 c6 f0 ff ff       	jmp    80106559 <alltraps>

80107493 <vector253>:
.globl vector253
vector253:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $253
80107495:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010749a:	e9 ba f0 ff ff       	jmp    80106559 <alltraps>

8010749f <vector254>:
.globl vector254
vector254:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $254
801074a1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801074a6:	e9 ae f0 ff ff       	jmp    80106559 <alltraps>

801074ab <vector255>:
.globl vector255
vector255:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $255
801074ad:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801074b2:	e9 a2 f0 ff ff       	jmp    80106559 <alltraps>
801074b7:	66 90                	xchg   %ax,%ax
801074b9:	66 90                	xchg   %ax,%ax
801074bb:	66 90                	xchg   %ax,%ax
801074bd:	66 90                	xchg   %ax,%ax
801074bf:	90                   	nop

801074c0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801074c6:	89 d3                	mov    %edx,%ebx
{
801074c8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801074ca:	c1 eb 16             	shr    $0x16,%ebx
801074cd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801074d0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801074d3:	8b 06                	mov    (%esi),%eax
801074d5:	a8 01                	test   $0x1,%al
801074d7:	74 27                	je     80107500 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074de:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801074e4:	c1 ef 0a             	shr    $0xa,%edi
}
801074e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801074ea:	89 fa                	mov    %edi,%edx
801074ec:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074f2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107500:	85 c9                	test   %ecx,%ecx
80107502:	74 2c                	je     80107530 <walkpgdir+0x70>
80107504:	e8 27 b8 ff ff       	call   80102d30 <kalloc>
80107509:	85 c0                	test   %eax,%eax
8010750b:	89 c3                	mov    %eax,%ebx
8010750d:	74 21                	je     80107530 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010750f:	83 ec 04             	sub    $0x4,%esp
80107512:	68 00 10 00 00       	push   $0x1000
80107517:	6a 00                	push   $0x0
80107519:	50                   	push   %eax
8010751a:	e8 f1 dd ff ff       	call   80105310 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010751f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107525:	83 c4 10             	add    $0x10,%esp
80107528:	83 c8 07             	or     $0x7,%eax
8010752b:	89 06                	mov    %eax,(%esi)
8010752d:	eb b5                	jmp    801074e4 <walkpgdir+0x24>
8010752f:	90                   	nop
}
80107530:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107533:	31 c0                	xor    %eax,%eax
}
80107535:	5b                   	pop    %ebx
80107536:	5e                   	pop    %esi
80107537:	5f                   	pop    %edi
80107538:	5d                   	pop    %ebp
80107539:	c3                   	ret    
8010753a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107540 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107540:	55                   	push   %ebp
80107541:	89 e5                	mov    %esp,%ebp
80107543:	57                   	push   %edi
80107544:	56                   	push   %esi
80107545:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107546:	89 d3                	mov    %edx,%ebx
80107548:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010754e:	83 ec 1c             	sub    $0x1c,%esp
80107551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107554:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107558:	8b 7d 08             	mov    0x8(%ebp),%edi
8010755b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107560:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107563:	8b 45 0c             	mov    0xc(%ebp),%eax
80107566:	29 df                	sub    %ebx,%edi
80107568:	83 c8 01             	or     $0x1,%eax
8010756b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010756e:	eb 15                	jmp    80107585 <mappages+0x45>
    if(*pte & PTE_P)
80107570:	f6 00 01             	testb  $0x1,(%eax)
80107573:	75 45                	jne    801075ba <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107575:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107578:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010757b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010757d:	74 31                	je     801075b0 <mappages+0x70>
      break;
    a += PGSIZE;
8010757f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107585:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107588:	b9 01 00 00 00       	mov    $0x1,%ecx
8010758d:	89 da                	mov    %ebx,%edx
8010758f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107592:	e8 29 ff ff ff       	call   801074c0 <walkpgdir>
80107597:	85 c0                	test   %eax,%eax
80107599:	75 d5                	jne    80107570 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010759b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010759e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075a3:	5b                   	pop    %ebx
801075a4:	5e                   	pop    %esi
801075a5:	5f                   	pop    %edi
801075a6:	5d                   	pop    %ebp
801075a7:	c3                   	ret    
801075a8:	90                   	nop
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075b3:	31 c0                	xor    %eax,%eax
}
801075b5:	5b                   	pop    %ebx
801075b6:	5e                   	pop    %esi
801075b7:	5f                   	pop    %edi
801075b8:	5d                   	pop    %ebp
801075b9:	c3                   	ret    
      panic("remap");
801075ba:	83 ec 0c             	sub    $0xc,%esp
801075bd:	68 94 99 10 80       	push   $0x80109994
801075c2:	e8 c9 8d ff ff       	call   80100390 <panic>
801075c7:	89 f6                	mov    %esi,%esi
801075c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075d0 <printlist>:
{
801075d0:	55                   	push   %ebp
801075d1:	89 e5                	mov    %esp,%ebp
801075d3:	56                   	push   %esi
801075d4:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
801075d5:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
801075da:	83 ec 0c             	sub    $0xc,%esp
801075dd:	68 9a 99 10 80       	push   $0x8010999a
801075e2:	e8 79 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
801075e7:	e8 d4 cc ff ff       	call   801042c0 <myproc>
801075ec:	83 c4 10             	add    $0x10,%esp
801075ef:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
801075f5:	eb 0e                	jmp    80107605 <printlist+0x35>
801075f7:	89 f6                	mov    %esi,%esi
801075f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107600:	83 ee 01             	sub    $0x1,%esi
80107603:	74 19                	je     8010761e <printlist+0x4e>
    cprintf("%d -> ", curr->off);
80107605:	83 ec 08             	sub    $0x8,%esp
80107608:	ff 33                	pushl  (%ebx)
8010760a:	68 aa 99 10 80       	push   $0x801099aa
8010760f:	e8 4c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107614:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107617:	83 c4 10             	add    $0x10,%esp
8010761a:	85 db                	test   %ebx,%ebx
8010761c:	75 e2                	jne    80107600 <printlist+0x30>
  cprintf("\n");
8010761e:	83 ec 0c             	sub    $0xc,%esp
80107621:	68 c0 9a 10 80       	push   $0x80109ac0
80107626:	e8 35 90 ff ff       	call   80100660 <cprintf>
}
8010762b:	83 c4 10             	add    $0x10,%esp
8010762e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107631:	5b                   	pop    %ebx
80107632:	5e                   	pop    %esi
80107633:	5d                   	pop    %ebp
80107634:	c3                   	ret    
80107635:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107640 <printaq>:
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	53                   	push   %ebx
80107644:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
80107647:	68 b1 99 10 80       	push   $0x801099b1
8010764c:	e8 0f 90 ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107651:	e8 6a cc ff ff       	call   801042c0 <myproc>
80107656:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010765c:	8b 58 08             	mov    0x8(%eax),%ebx
8010765f:	e8 5c cc ff ff       	call   801042c0 <myproc>
80107664:	83 c4 0c             	add    $0xc,%esp
80107667:	53                   	push   %ebx
80107668:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010766e:	ff 70 08             	pushl  0x8(%eax)
80107671:	68 c3 99 10 80       	push   $0x801099c3
80107676:	e8 e5 8f ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010767b:	e8 40 cc ff ff       	call   801042c0 <myproc>
80107680:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107686:	83 c4 10             	add    $0x10,%esp
80107689:	8b 50 04             	mov    0x4(%eax),%edx
8010768c:	85 d2                	test   %edx,%edx
8010768e:	74 68                	je     801076f8 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
80107690:	e8 2b cc ff ff       	call   801042c0 <myproc>
80107695:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010769b:	85 db                	test   %ebx,%ebx
8010769d:	74 1a                	je     801076b9 <printaq+0x79>
8010769f:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
801076a0:	83 ec 08             	sub    $0x8,%esp
801076a3:	ff 73 08             	pushl  0x8(%ebx)
801076a6:	68 e1 99 10 80       	push   $0x801099e1
801076ab:	e8 b0 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801076b0:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
801076b2:	83 c4 10             	add    $0x10,%esp
801076b5:	85 db                	test   %ebx,%ebx
801076b7:	75 e7                	jne    801076a0 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
801076b9:	e8 02 cc ff ff       	call   801042c0 <myproc>
801076be:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
801076c4:	8b 00                	mov    (%eax),%eax
801076c6:	85 c0                	test   %eax,%eax
801076c8:	74 16                	je     801076e0 <printaq+0xa0>
  cprintf("\n");
801076ca:	83 ec 0c             	sub    $0xc,%esp
801076cd:	68 c0 9a 10 80       	push   $0x80109ac0
801076d2:	e8 89 8f ff ff       	call   80100660 <cprintf>
}
801076d7:	83 c4 10             	add    $0x10,%esp
801076da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076dd:	c9                   	leave  
801076de:	c3                   	ret    
801076df:	90                   	nop
    cprintf("null <-> ");
801076e0:	83 ec 0c             	sub    $0xc,%esp
801076e3:	68 d7 99 10 80       	push   $0x801099d7
801076e8:	e8 73 8f ff ff       	call   80100660 <cprintf>
801076ed:	83 c4 10             	add    $0x10,%esp
801076f0:	eb d8                	jmp    801076ca <printaq+0x8a>
801076f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
801076f8:	83 ec 0c             	sub    $0xc,%esp
801076fb:	68 d7 99 10 80       	push   $0x801099d7
80107700:	e8 5b 8f ff ff       	call   80100660 <cprintf>
80107705:	83 c4 10             	add    $0x10,%esp
80107708:	eb 86                	jmp    80107690 <printaq+0x50>
8010770a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107710 <seginit>:
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107716:	e8 85 cb ff ff       	call   801042a0 <cpuid>
8010771b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107721:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107726:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010772a:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
80107731:	ff 00 00 
80107734:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
8010773b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010773e:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
80107745:	ff 00 00 
80107748:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
8010774f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107752:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
80107759:	ff 00 00 
8010775c:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
80107763:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107766:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
8010776d:	ff 00 00 
80107770:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
80107777:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010777a:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
  pd[1] = (uint)p;
8010777f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107783:	c1 e8 10             	shr    $0x10,%eax
80107786:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010778a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010778d:	0f 01 10             	lgdtl  (%eax)
}
80107790:	c9                   	leave  
80107791:	c3                   	ret    
80107792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077a0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077a0:	a1 84 75 19 80       	mov    0x80197584,%eax
{
801077a5:	55                   	push   %ebp
801077a6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077a8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077ad:	0f 22 d8             	mov    %eax,%cr3
}
801077b0:	5d                   	pop    %ebp
801077b1:	c3                   	ret    
801077b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801077c0:	55                   	push   %ebp
801077c1:	89 e5                	mov    %esp,%ebp
801077c3:	57                   	push   %edi
801077c4:	56                   	push   %esi
801077c5:	53                   	push   %ebx
801077c6:	83 ec 1c             	sub    $0x1c,%esp
801077c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801077cc:	85 db                	test   %ebx,%ebx
801077ce:	0f 84 cb 00 00 00    	je     8010789f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801077d4:	8b 43 08             	mov    0x8(%ebx),%eax
801077d7:	85 c0                	test   %eax,%eax
801077d9:	0f 84 da 00 00 00    	je     801078b9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801077df:	8b 43 04             	mov    0x4(%ebx),%eax
801077e2:	85 c0                	test   %eax,%eax
801077e4:	0f 84 c2 00 00 00    	je     801078ac <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801077ea:	e8 41 d9 ff ff       	call   80105130 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077ef:	e8 2c ca ff ff       	call   80104220 <mycpu>
801077f4:	89 c6                	mov    %eax,%esi
801077f6:	e8 25 ca ff ff       	call   80104220 <mycpu>
801077fb:	89 c7                	mov    %eax,%edi
801077fd:	e8 1e ca ff ff       	call   80104220 <mycpu>
80107802:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107805:	83 c7 08             	add    $0x8,%edi
80107808:	e8 13 ca ff ff       	call   80104220 <mycpu>
8010780d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107810:	83 c0 08             	add    $0x8,%eax
80107813:	ba 67 00 00 00       	mov    $0x67,%edx
80107818:	c1 e8 18             	shr    $0x18,%eax
8010781b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107822:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107829:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010782f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107834:	83 c1 08             	add    $0x8,%ecx
80107837:	c1 e9 10             	shr    $0x10,%ecx
8010783a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107840:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107845:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010784c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107851:	e8 ca c9 ff ff       	call   80104220 <mycpu>
80107856:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010785d:	e8 be c9 ff ff       	call   80104220 <mycpu>
80107862:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107866:	8b 73 08             	mov    0x8(%ebx),%esi
80107869:	e8 b2 c9 ff ff       	call   80104220 <mycpu>
8010786e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107874:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107877:	e8 a4 c9 ff ff       	call   80104220 <mycpu>
8010787c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107880:	b8 28 00 00 00       	mov    $0x28,%eax
80107885:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107888:	8b 43 04             	mov    0x4(%ebx),%eax
8010788b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107890:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107893:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107896:	5b                   	pop    %ebx
80107897:	5e                   	pop    %esi
80107898:	5f                   	pop    %edi
80107899:	5d                   	pop    %ebp
  popcli();
8010789a:	e9 d1 d8 ff ff       	jmp    80105170 <popcli>
    panic("switchuvm: no process");
8010789f:	83 ec 0c             	sub    $0xc,%esp
801078a2:	68 e9 99 10 80       	push   $0x801099e9
801078a7:	e8 e4 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801078ac:	83 ec 0c             	sub    $0xc,%esp
801078af:	68 14 9a 10 80       	push   $0x80109a14
801078b4:	e8 d7 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078b9:	83 ec 0c             	sub    $0xc,%esp
801078bc:	68 ff 99 10 80       	push   $0x801099ff
801078c1:	e8 ca 8a ff ff       	call   80100390 <panic>
801078c6:	8d 76 00             	lea    0x0(%esi),%esi
801078c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	57                   	push   %edi
801078d4:	56                   	push   %esi
801078d5:	53                   	push   %ebx
801078d6:	83 ec 1c             	sub    $0x1c,%esp
801078d9:	8b 75 10             	mov    0x10(%ebp),%esi
801078dc:	8b 45 08             	mov    0x8(%ebp),%eax
801078df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801078e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801078e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801078eb:	77 49                	ja     80107936 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801078ed:	e8 3e b4 ff ff       	call   80102d30 <kalloc>
  memset(mem, 0, PGSIZE);
801078f2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801078f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801078f7:	68 00 10 00 00       	push   $0x1000
801078fc:	6a 00                	push   $0x0
801078fe:	50                   	push   %eax
801078ff:	e8 0c da ff ff       	call   80105310 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107904:	58                   	pop    %eax
80107905:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010790b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107910:	5a                   	pop    %edx
80107911:	6a 06                	push   $0x6
80107913:	50                   	push   %eax
80107914:	31 d2                	xor    %edx,%edx
80107916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107919:	e8 22 fc ff ff       	call   80107540 <mappages>
  memmove(mem, init, sz);
8010791e:	89 75 10             	mov    %esi,0x10(%ebp)
80107921:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107924:	83 c4 10             	add    $0x10,%esp
80107927:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010792a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010792d:	5b                   	pop    %ebx
8010792e:	5e                   	pop    %esi
8010792f:	5f                   	pop    %edi
80107930:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107931:	e9 8a da ff ff       	jmp    801053c0 <memmove>
    panic("inituvm: more than a page");
80107936:	83 ec 0c             	sub    $0xc,%esp
80107939:	68 28 9a 10 80       	push   $0x80109a28
8010793e:	e8 4d 8a ff ff       	call   80100390 <panic>
80107943:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107950 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	57                   	push   %edi
80107954:	56                   	push   %esi
80107955:	53                   	push   %ebx
80107956:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107959:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107960:	0f 85 91 00 00 00    	jne    801079f7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107966:	8b 75 18             	mov    0x18(%ebp),%esi
80107969:	31 db                	xor    %ebx,%ebx
8010796b:	85 f6                	test   %esi,%esi
8010796d:	75 1a                	jne    80107989 <loaduvm+0x39>
8010796f:	eb 6f                	jmp    801079e0 <loaduvm+0x90>
80107971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107978:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010797e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107984:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107987:	76 57                	jbe    801079e0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107989:	8b 55 0c             	mov    0xc(%ebp),%edx
8010798c:	8b 45 08             	mov    0x8(%ebp),%eax
8010798f:	31 c9                	xor    %ecx,%ecx
80107991:	01 da                	add    %ebx,%edx
80107993:	e8 28 fb ff ff       	call   801074c0 <walkpgdir>
80107998:	85 c0                	test   %eax,%eax
8010799a:	74 4e                	je     801079ea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010799c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010799e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801079a1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801079a6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801079ab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079b1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079b4:	01 d9                	add    %ebx,%ecx
801079b6:	05 00 00 00 80       	add    $0x80000000,%eax
801079bb:	57                   	push   %edi
801079bc:	51                   	push   %ecx
801079bd:	50                   	push   %eax
801079be:	ff 75 10             	pushl  0x10(%ebp)
801079c1:	e8 4a a3 ff ff       	call   80101d10 <readi>
801079c6:	83 c4 10             	add    $0x10,%esp
801079c9:	39 f8                	cmp    %edi,%eax
801079cb:	74 ab                	je     80107978 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801079cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079d5:	5b                   	pop    %ebx
801079d6:	5e                   	pop    %esi
801079d7:	5f                   	pop    %edi
801079d8:	5d                   	pop    %ebp
801079d9:	c3                   	ret    
801079da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079e3:	31 c0                	xor    %eax,%eax
}
801079e5:	5b                   	pop    %ebx
801079e6:	5e                   	pop    %esi
801079e7:	5f                   	pop    %edi
801079e8:	5d                   	pop    %ebp
801079e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801079ea:	83 ec 0c             	sub    $0xc,%esp
801079ed:	68 42 9a 10 80       	push   $0x80109a42
801079f2:	e8 99 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801079f7:	83 ec 0c             	sub    $0xc,%esp
801079fa:	68 d8 9b 10 80       	push   $0x80109bd8
801079ff:	e8 8c 89 ff ff       	call   80100390 <panic>
80107a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a10 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a10:	55                   	push   %ebp
80107a11:	89 e5                	mov    %esp,%ebp
80107a13:	53                   	push   %ebx
80107a14:	8b 4d 08             	mov    0x8(%ebp),%ecx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
80107a17:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107a1a:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
80107a20:	6b c2 1c             	imul   $0x1c,%edx,%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  // cprintf("filling ram slot: %d\n", curproc->num_ram);
  // cprintf("allocating addr : %p\n\n", rounded_virtaddr);

  curproc->num_ram++;
80107a23:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107a26:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
80107a28:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107a2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107a31:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a38:	00 00 00 
  page->swap_offset = -1;
80107a3b:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107a42:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107a45:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107a4b:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
  
}
80107a51:	5b                   	pop    %ebx
80107a52:	5d                   	pop    %ebp
80107a53:	c3                   	ret    
80107a54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a60 <allocuvm_withswap>:



void
allocuvm_withswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a60:	55                   	push   %ebp
80107a61:	89 e5                	mov    %esp,%ebp
80107a63:	57                   	push   %edi
80107a64:	56                   	push   %esi
80107a65:	53                   	push   %ebx
80107a66:	83 ec 0c             	sub    $0xc,%esp
80107a69:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107a6c:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
80107a73:	0f 8f 1c 01 00 00    	jg     80107b95 <allocuvm_withswap+0x135>

      // get info of the page to be evicted
      uint evicted_ind = indexToEvict();
      // cprintf("[allocuvm] index to evict: %d\n",evicted_ind);
      struct page *evicted_page = &curproc->ramPages[evicted_ind];
      int swap_offset = curproc->free_head->off;
80107a79:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx

      if(curproc->free_head->next == 0)
80107a7f:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80107a82:	8b 32                	mov    (%edx),%esi
      if(curproc->free_head->next == 0)
80107a84:	85 c0                	test   %eax,%eax
80107a86:	0f 84 e4 00 00 00    	je     80107b70 <allocuvm_withswap+0x110>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80107a8c:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107a8f:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80107a95:	ff 70 08             	pushl  0x8(%eax)
80107a98:	e8 b3 af ff ff       	call   80102a50 <kfree>
80107a9d:	83 c4 10             	add    $0x10,%esp
      }

      // cprintf("before write to swap\n");
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80107aa0:	68 00 10 00 00       	push   $0x1000
80107aa5:	56                   	push   %esi
80107aa6:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
80107aac:	53                   	push   %ebx
80107aad:	e8 4e ab ff ff       	call   80102600 <writeToSwapFile>
80107ab2:	83 c4 10             	add    $0x10,%esp
80107ab5:	85 c0                	test   %eax,%eax
80107ab7:	0f 88 f2 00 00 00    	js     80107baf <allocuvm_withswap+0x14f>
        panic("allocuvm: writeToSwapFile");


      curproc->swappedPages[curproc->num_swap].isused = 1;
80107abd:	8b bb 0c 04 00 00    	mov    0x40c(%ebx),%edi
80107ac3:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80107ac6:	01 d9                	add    %ebx,%ecx
80107ac8:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80107acf:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107ad2:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80107ad8:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107ade:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107ae4:	89 b1 94 00 00 00    	mov    %esi,0x94(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107aea:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      // cprintf("num swap: %d\n", curproc->num_swap);
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107af0:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107af6:	0f 22 d9             	mov    %ecx,%cr3
      curproc->num_swap ++;
80107af9:	83 c7 01             	add    $0x1,%edi


      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107afc:	31 c9                	xor    %ecx,%ecx
      curproc->num_swap ++;
80107afe:	89 bb 0c 04 00 00    	mov    %edi,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b04:	e8 b7 f9 ff ff       	call   801074c0 <walkpgdir>



      if(!(*evicted_pte & PTE_P))
80107b09:	8b 10                	mov    (%eax),%edx
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b0b:	89 c6                	mov    %eax,%esi
      if(!(*evicted_pte & PTE_P))
80107b0d:	f6 c2 01             	test   $0x1,%dl
80107b10:	0f 84 8c 00 00 00    	je     80107ba2 <allocuvm_withswap+0x142>
        panic("allocuvm: swap: ram page not present");
      
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107b16:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      

      kfree(P2V(evicted_pa));
80107b1c:	83 ec 0c             	sub    $0xc,%esp
80107b1f:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107b25:	52                   	push   %edx
80107b26:	e8 25 af ff ff       	call   80102a50 <kfree>

      *evicted_pte &= 0xFFF; // ???

      *evicted_pte |= PTE_PG;
      *evicted_pte &= ~PTE_P;
80107b2b:	8b 16                	mov    (%esi),%edx
    

      struct page *newpage = &curproc->ramPages[evicted_ind];
      newpage->isused = 1;
      newpage->pgdir = pgdir; // ??? 
80107b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
      newpage->swap_offset = -1;
      newpage->virt_addr = rounded_virtaddr;
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
     
}
80107b30:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
80107b33:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
80107b39:	80 ce 02             	or     $0x2,%dh
80107b3c:	89 16                	mov    %edx,(%esi)
      newpage->pgdir = pgdir; // ??? 
80107b3e:	89 83 9c 02 00 00    	mov    %eax,0x29c(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80107b44:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->isused = 1;
80107b47:	c7 83 a0 02 00 00 01 	movl   $0x1,0x2a0(%ebx)
80107b4e:	00 00 00 
      newpage->swap_offset = -1;
80107b51:	c7 83 a8 02 00 00 ff 	movl   $0xffffffff,0x2a8(%ebx)
80107b58:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
80107b5b:	89 83 a4 02 00 00    	mov    %eax,0x2a4(%ebx)
}
80107b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b64:	5b                   	pop    %ebx
80107b65:	5e                   	pop    %esi
80107b66:	5f                   	pop    %edi
80107b67:	5d                   	pop    %ebp
80107b68:	c3                   	ret    
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
80107b70:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80107b73:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80107b7a:	00 00 00 
        kfree((char*)curproc->free_head);
80107b7d:	52                   	push   %edx
80107b7e:	e8 cd ae ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80107b83:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80107b8a:	00 00 00 
80107b8d:	83 c4 10             	add    $0x10,%esp
80107b90:	e9 0b ff ff ff       	jmp    80107aa0 <allocuvm_withswap+0x40>
        panic("page limit exceeded");
80107b95:	83 ec 0c             	sub    $0xc,%esp
80107b98:	68 60 9a 10 80       	push   $0x80109a60
80107b9d:	e8 ee 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80107ba2:	83 ec 0c             	sub    $0xc,%esp
80107ba5:	68 fc 9b 10 80       	push   $0x80109bfc
80107baa:	e8 e1 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80107baf:	83 ec 0c             	sub    $0xc,%esp
80107bb2:	68 74 9a 10 80       	push   $0x80109a74
80107bb7:	e8 d4 87 ff ff       	call   80100390 <panic>
80107bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107bc0 <allocuvm_paging>:
{
80107bc0:	55                   	push   %ebp
80107bc1:	89 e5                	mov    %esp,%ebp
80107bc3:	56                   	push   %esi
80107bc4:	53                   	push   %ebx
80107bc5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
80107bcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107bce:	8b 81 08 04 00 00    	mov    0x408(%ecx),%eax
80107bd4:	83 f8 0f             	cmp    $0xf,%eax
80107bd7:	7f 37                	jg     80107c10 <allocuvm_paging+0x50>
  page->isused = 1;
80107bd9:	6b d0 1c             	imul   $0x1c,%eax,%edx
  curproc->num_ram++;
80107bdc:	83 c0 01             	add    $0x1,%eax
  page->isused = 1;
80107bdf:	01 ca                	add    %ecx,%edx
80107be1:	c7 82 4c 02 00 00 01 	movl   $0x1,0x24c(%edx)
80107be8:	00 00 00 
  page->pgdir = pgdir;
80107beb:	89 b2 48 02 00 00    	mov    %esi,0x248(%edx)
  page->swap_offset = -1;
80107bf1:	c7 82 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edx)
80107bf8:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107bfb:	89 9a 50 02 00 00    	mov    %ebx,0x250(%edx)
  curproc->num_ram++;
80107c01:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
}
80107c07:	5b                   	pop    %ebx
80107c08:	5e                   	pop    %esi
80107c09:	5d                   	pop    %ebp
80107c0a:	c3                   	ret    
80107c0b:	90                   	nop
80107c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c10:	5b                   	pop    %ebx
80107c11:	5e                   	pop    %esi
80107c12:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107c13:	e9 48 fe ff ff       	jmp    80107a60 <allocuvm_withswap>
80107c18:	90                   	nop
80107c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c20 <update_selectionfiled_allocuvm>:

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107c20:	55                   	push   %ebp
80107c21:	89 e5                	mov    %esp,%ebp
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107c23:	5d                   	pop    %ebp
80107c24:	c3                   	ret    
80107c25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c30 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
80107c33:	57                   	push   %edi
80107c34:	56                   	push   %esi
80107c35:	53                   	push   %ebx
80107c36:	83 ec 5c             	sub    $0x5c,%esp
80107c39:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107c3c:	e8 7f c6 ff ff       	call   801042c0 <myproc>
80107c41:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107c44:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c47:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c4a:	0f 83 a3 00 00 00    	jae    80107cf3 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107c50:	8b 45 10             	mov    0x10(%ebp),%eax
80107c53:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c59:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107c5f:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c62:	77 6a                	ja     80107cce <deallocuvm+0x9e>
80107c64:	e9 87 00 00 00       	jmp    80107cf0 <deallocuvm+0xc0>
80107c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107c70:	8b 00                	mov    (%eax),%eax
80107c72:	a8 01                	test   $0x1,%al
80107c74:	74 4d                	je     80107cc3 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c7b:	0f 84 b3 01 00 00    	je     80107e34 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107c81:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107c87:	83 ec 0c             	sub    $0xc,%esp
80107c8a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107c8d:	53                   	push   %ebx
80107c8e:	e8 2d b2 ff ff       	call   80102ec0 <getRefs>
80107c93:	83 c4 10             	add    $0x10,%esp
80107c96:	83 f8 01             	cmp    $0x1,%eax
80107c99:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107c9c:	0f 84 7e 01 00 00    	je     80107e20 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107ca2:	83 ec 0c             	sub    $0xc,%esp
80107ca5:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107ca8:	53                   	push   %ebx
80107ca9:	e8 32 b1 ff ff       	call   80102de0 <refDec>
80107cae:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107cb1:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107cb4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107cb7:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107cbb:	7f 43                	jg     80107d00 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107cbd:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107cc3:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107cc9:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107ccc:	76 22                	jbe    80107cf0 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107cce:	31 c9                	xor    %ecx,%ecx
80107cd0:	89 f2                	mov    %esi,%edx
80107cd2:	89 f8                	mov    %edi,%eax
80107cd4:	e8 e7 f7 ff ff       	call   801074c0 <walkpgdir>
    if(!pte)
80107cd9:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107cdb:	89 c2                	mov    %eax,%edx
    if(!pte)
80107cdd:	75 91                	jne    80107c70 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107cdf:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107ce5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107ceb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cee:	77 de                	ja     80107cce <deallocuvm+0x9e>
    }
  }
  return newsz;
80107cf0:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107cf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cf6:	5b                   	pop    %ebx
80107cf7:	5e                   	pop    %esi
80107cf8:	5f                   	pop    %edi
80107cf9:	5d                   	pop    %ebp
80107cfa:	c3                   	ret    
80107cfb:	90                   	nop
80107cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d00:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107d06:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107d09:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107d0f:	89 fa                	mov    %edi,%edx
80107d11:	89 cf                	mov    %ecx,%edi
80107d13:	eb 17                	jmp    80107d2c <deallocuvm+0xfc>
80107d15:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107d18:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107d1b:	0f 84 b7 00 00 00    	je     80107dd8 <deallocuvm+0x1a8>
80107d21:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d24:	39 fb                	cmp    %edi,%ebx
80107d26:	0f 84 e4 00 00 00    	je     80107e10 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107d2c:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107d32:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107d35:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107d3b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107d3e:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107d44:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107d47:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107d4d:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107d50:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107d53:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107d59:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107d5c:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107d62:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107d65:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107d6b:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107d6e:	8b 03                	mov    (%ebx),%eax
80107d70:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107d73:	8b 43 04             	mov    0x4(%ebx),%eax
80107d76:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107d79:	8b 43 08             	mov    0x8(%ebx),%eax
80107d7c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107d7f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107d82:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107d85:	8b 43 10             	mov    0x10(%ebx),%eax
80107d88:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107d8b:	8b 43 14             	mov    0x14(%ebx),%eax
80107d8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d91:	8b 43 18             	mov    0x18(%ebx),%eax
80107d94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107d97:	0f 85 7b ff ff ff    	jne    80107d18 <deallocuvm+0xe8>
80107d9d:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107da0:	0f 85 72 ff ff ff    	jne    80107d18 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107da6:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107da9:	83 ec 04             	sub    $0x4,%esp
80107dac:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107daf:	6a 1c                	push   $0x1c
80107db1:	6a 00                	push   $0x0
80107db3:	50                   	push   %eax
80107db4:	e8 57 d5 ff ff       	call   80105310 <memset>
            curproc->num_ram -- ;
80107db9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107dbc:	83 c4 10             	add    $0x10,%esp
80107dbf:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107dc2:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107dc9:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107dcc:	0f 85 4f ff ff ff    	jne    80107d21 <deallocuvm+0xf1>
80107dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107dd8:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107ddb:	0f 85 40 ff ff ff    	jne    80107d21 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107de1:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107de4:	83 ec 04             	sub    $0x4,%esp
80107de7:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107dea:	6a 1c                	push   $0x1c
80107dec:	6a 00                	push   $0x0
80107dee:	83 c3 1c             	add    $0x1c,%ebx
80107df1:	50                   	push   %eax
80107df2:	e8 19 d5 ff ff       	call   80105310 <memset>
            curproc->num_swap --;
80107df7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107dfa:	83 c4 10             	add    $0x10,%esp
80107dfd:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107e00:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107e07:	39 fb                	cmp    %edi,%ebx
80107e09:	0f 85 1d ff ff ff    	jne    80107d2c <deallocuvm+0xfc>
80107e0f:	90                   	nop
80107e10:	89 d7                	mov    %edx,%edi
80107e12:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107e15:	e9 a3 fe ff ff       	jmp    80107cbd <deallocuvm+0x8d>
80107e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107e20:	83 ec 0c             	sub    $0xc,%esp
80107e23:	53                   	push   %ebx
80107e24:	e8 27 ac ff ff       	call   80102a50 <kfree>
80107e29:	83 c4 10             	add    $0x10,%esp
80107e2c:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107e2f:	e9 80 fe ff ff       	jmp    80107cb4 <deallocuvm+0x84>
        panic("kfree");
80107e34:	83 ec 0c             	sub    $0xc,%esp
80107e37:	68 fa 91 10 80       	push   $0x801091fa
80107e3c:	e8 4f 85 ff ff       	call   80100390 <panic>
80107e41:	eb 0d                	jmp    80107e50 <allocuvm>
80107e43:	90                   	nop
80107e44:	90                   	nop
80107e45:	90                   	nop
80107e46:	90                   	nop
80107e47:	90                   	nop
80107e48:	90                   	nop
80107e49:	90                   	nop
80107e4a:	90                   	nop
80107e4b:	90                   	nop
80107e4c:	90                   	nop
80107e4d:	90                   	nop
80107e4e:	90                   	nop
80107e4f:	90                   	nop

80107e50 <allocuvm>:
{
80107e50:	55                   	push   %ebp
80107e51:	89 e5                	mov    %esp,%ebp
80107e53:	57                   	push   %edi
80107e54:	56                   	push   %esi
80107e55:	53                   	push   %ebx
80107e56:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107e59:	e8 62 c4 ff ff       	call   801042c0 <myproc>
80107e5e:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107e60:	8b 45 10             	mov    0x10(%ebp),%eax
80107e63:	85 c0                	test   %eax,%eax
80107e65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e68:	0f 88 e2 00 00 00    	js     80107f50 <allocuvm+0x100>
  if(newsz < oldsz)
80107e6e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107e71:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107e74:	0f 82 c6 00 00 00    	jb     80107f40 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
80107e7a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107e80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107e86:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107e89:	77 41                	ja     80107ecc <allocuvm+0x7c>
80107e8b:	e9 b3 00 00 00       	jmp    80107f43 <allocuvm+0xf3>
  page->isused = 1;
80107e90:	6b c2 1c             	imul   $0x1c,%edx,%eax
  page->pgdir = pgdir;
80107e93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  curproc->num_ram++;
80107e96:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107e99:	01 f8                	add    %edi,%eax
80107e9b:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107ea2:	00 00 00 
  page->pgdir = pgdir;
80107ea5:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->swap_offset = -1;
80107eab:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107eb2:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107eb5:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107ebb:	89 97 08 04 00 00    	mov    %edx,0x408(%edi)
  for(; a < newsz; a += PGSIZE){
80107ec1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ec7:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107eca:	76 77                	jbe    80107f43 <allocuvm+0xf3>
    mem = kalloc();
80107ecc:	e8 5f ae ff ff       	call   80102d30 <kalloc>
    if(mem == 0){
80107ed1:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107ed3:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107ed5:	0f 84 8d 00 00 00    	je     80107f68 <allocuvm+0x118>
    memset(mem, 0, PGSIZE);
80107edb:	83 ec 04             	sub    $0x4,%esp
80107ede:	68 00 10 00 00       	push   $0x1000
80107ee3:	6a 00                	push   $0x0
80107ee5:	50                   	push   %eax
80107ee6:	e8 25 d4 ff ff       	call   80105310 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107eeb:	58                   	pop    %eax
80107eec:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ef2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ef7:	5a                   	pop    %edx
80107ef8:	6a 06                	push   $0x6
80107efa:	50                   	push   %eax
80107efb:	89 da                	mov    %ebx,%edx
80107efd:	8b 45 08             	mov    0x8(%ebp),%eax
80107f00:	e8 3b f6 ff ff       	call   80107540 <mappages>
80107f05:	83 c4 10             	add    $0x10,%esp
80107f08:	85 c0                	test   %eax,%eax
80107f0a:	0f 88 90 00 00 00    	js     80107fa0 <allocuvm+0x150>
    if(curproc->pid > 2) 
80107f10:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107f14:	7e ab                	jle    80107ec1 <allocuvm+0x71>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107f16:	8b 97 08 04 00 00    	mov    0x408(%edi),%edx
80107f1c:	83 fa 0f             	cmp    $0xf,%edx
80107f1f:	0f 8e 6b ff ff ff    	jle    80107e90 <allocuvm+0x40>
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107f25:	83 ec 04             	sub    $0x4,%esp
80107f28:	53                   	push   %ebx
80107f29:	ff 75 08             	pushl  0x8(%ebp)
80107f2c:	57                   	push   %edi
80107f2d:	e8 2e fb ff ff       	call   80107a60 <allocuvm_withswap>
80107f32:	83 c4 10             	add    $0x10,%esp
80107f35:	eb 8a                	jmp    80107ec1 <allocuvm+0x71>
80107f37:	89 f6                	mov    %esi,%esi
80107f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
80107f40:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f49:	5b                   	pop    %ebx
80107f4a:	5e                   	pop    %esi
80107f4b:	5f                   	pop    %edi
80107f4c:	5d                   	pop    %ebp
80107f4d:	c3                   	ret    
80107f4e:	66 90                	xchg   %ax,%ax
    return 0;
80107f50:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f5d:	5b                   	pop    %ebx
80107f5e:	5e                   	pop    %esi
80107f5f:	5f                   	pop    %edi
80107f60:	5d                   	pop    %ebp
80107f61:	c3                   	ret    
80107f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107f68:	83 ec 0c             	sub    $0xc,%esp
80107f6b:	68 8e 9a 10 80       	push   $0x80109a8e
80107f70:	e8 eb 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107f75:	83 c4 0c             	add    $0xc,%esp
80107f78:	ff 75 0c             	pushl  0xc(%ebp)
80107f7b:	ff 75 10             	pushl  0x10(%ebp)
80107f7e:	ff 75 08             	pushl  0x8(%ebp)
80107f81:	e8 aa fc ff ff       	call   80107c30 <deallocuvm>
      return 0;
80107f86:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107f8d:	83 c4 10             	add    $0x10,%esp
}
80107f90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f96:	5b                   	pop    %ebx
80107f97:	5e                   	pop    %esi
80107f98:	5f                   	pop    %edi
80107f99:	5d                   	pop    %ebp
80107f9a:	c3                   	ret    
80107f9b:	90                   	nop
80107f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107fa0:	83 ec 0c             	sub    $0xc,%esp
80107fa3:	68 a6 9a 10 80       	push   $0x80109aa6
80107fa8:	e8 b3 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107fad:	83 c4 0c             	add    $0xc,%esp
80107fb0:	ff 75 0c             	pushl  0xc(%ebp)
80107fb3:	ff 75 10             	pushl  0x10(%ebp)
80107fb6:	ff 75 08             	pushl  0x8(%ebp)
80107fb9:	e8 72 fc ff ff       	call   80107c30 <deallocuvm>
      kfree(mem);
80107fbe:	89 34 24             	mov    %esi,(%esp)
80107fc1:	e8 8a aa ff ff       	call   80102a50 <kfree>
      return 0;
80107fc6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107fcd:	83 c4 10             	add    $0x10,%esp
}
80107fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fd6:	5b                   	pop    %ebx
80107fd7:	5e                   	pop    %esi
80107fd8:	5f                   	pop    %edi
80107fd9:	5d                   	pop    %ebp
80107fda:	c3                   	ret    
80107fdb:	90                   	nop
80107fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107fe0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fe0:	55                   	push   %ebp
80107fe1:	89 e5                	mov    %esp,%ebp
80107fe3:	57                   	push   %edi
80107fe4:	56                   	push   %esi
80107fe5:	53                   	push   %ebx
80107fe6:	83 ec 0c             	sub    $0xc,%esp
80107fe9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107fec:	85 f6                	test   %esi,%esi
80107fee:	74 59                	je     80108049 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107ff0:	83 ec 04             	sub    $0x4,%esp
80107ff3:	89 f3                	mov    %esi,%ebx
80107ff5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107ffb:	6a 00                	push   $0x0
80107ffd:	68 00 00 00 80       	push   $0x80000000
80108002:	56                   	push   %esi
80108003:	e8 28 fc ff ff       	call   80107c30 <deallocuvm>
80108008:	83 c4 10             	add    $0x10,%esp
8010800b:	eb 0a                	jmp    80108017 <freevm+0x37>
8010800d:	8d 76 00             	lea    0x0(%esi),%esi
80108010:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80108013:	39 fb                	cmp    %edi,%ebx
80108015:	74 23                	je     8010803a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80108017:	8b 03                	mov    (%ebx),%eax
80108019:	a8 01                	test   $0x1,%al
8010801b:	74 f3                	je     80108010 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010801d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80108022:	83 ec 0c             	sub    $0xc,%esp
80108025:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108028:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010802d:	50                   	push   %eax
8010802e:	e8 1d aa ff ff       	call   80102a50 <kfree>
80108033:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108036:	39 fb                	cmp    %edi,%ebx
80108038:	75 dd                	jne    80108017 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010803a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010803d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108040:	5b                   	pop    %ebx
80108041:	5e                   	pop    %esi
80108042:	5f                   	pop    %edi
80108043:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108044:	e9 07 aa ff ff       	jmp    80102a50 <kfree>
    panic("freevm: no pgdir");
80108049:	83 ec 0c             	sub    $0xc,%esp
8010804c:	68 c2 9a 10 80       	push   $0x80109ac2
80108051:	e8 3a 83 ff ff       	call   80100390 <panic>
80108056:	8d 76 00             	lea    0x0(%esi),%esi
80108059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108060 <setupkvm>:
{
80108060:	55                   	push   %ebp
80108061:	89 e5                	mov    %esp,%ebp
80108063:	56                   	push   %esi
80108064:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108065:	e8 c6 ac ff ff       	call   80102d30 <kalloc>
8010806a:	85 c0                	test   %eax,%eax
8010806c:	89 c6                	mov    %eax,%esi
8010806e:	74 42                	je     801080b2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108070:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108073:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108078:	68 00 10 00 00       	push   $0x1000
8010807d:	6a 00                	push   $0x0
8010807f:	50                   	push   %eax
80108080:	e8 8b d2 ff ff       	call   80105310 <memset>
80108085:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108088:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010808b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010808e:	83 ec 08             	sub    $0x8,%esp
80108091:	8b 13                	mov    (%ebx),%edx
80108093:	ff 73 0c             	pushl  0xc(%ebx)
80108096:	50                   	push   %eax
80108097:	29 c1                	sub    %eax,%ecx
80108099:	89 f0                	mov    %esi,%eax
8010809b:	e8 a0 f4 ff ff       	call   80107540 <mappages>
801080a0:	83 c4 10             	add    $0x10,%esp
801080a3:	85 c0                	test   %eax,%eax
801080a5:	78 19                	js     801080c0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080a7:	83 c3 10             	add    $0x10,%ebx
801080aa:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801080b0:	75 d6                	jne    80108088 <setupkvm+0x28>
}
801080b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080b5:	89 f0                	mov    %esi,%eax
801080b7:	5b                   	pop    %ebx
801080b8:	5e                   	pop    %esi
801080b9:	5d                   	pop    %ebp
801080ba:	c3                   	ret    
801080bb:	90                   	nop
801080bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
801080c0:	83 ec 0c             	sub    $0xc,%esp
801080c3:	68 d3 9a 10 80       	push   $0x80109ad3
801080c8:	e8 93 85 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
801080cd:	89 34 24             	mov    %esi,(%esp)
      return 0;
801080d0:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801080d2:	e8 09 ff ff ff       	call   80107fe0 <freevm>
      return 0;
801080d7:	83 c4 10             	add    $0x10,%esp
}
801080da:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080dd:	89 f0                	mov    %esi,%eax
801080df:	5b                   	pop    %ebx
801080e0:	5e                   	pop    %esi
801080e1:	5d                   	pop    %ebp
801080e2:	c3                   	ret    
801080e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080f0 <kvmalloc>:
{
801080f0:	55                   	push   %ebp
801080f1:	89 e5                	mov    %esp,%ebp
801080f3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080f6:	e8 65 ff ff ff       	call   80108060 <setupkvm>
801080fb:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108100:	05 00 00 00 80       	add    $0x80000000,%eax
80108105:	0f 22 d8             	mov    %eax,%cr3
}
80108108:	c9                   	leave  
80108109:	c3                   	ret    
8010810a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108110 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108110:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108111:	31 c9                	xor    %ecx,%ecx
{
80108113:	89 e5                	mov    %esp,%ebp
80108115:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108118:	8b 55 0c             	mov    0xc(%ebp),%edx
8010811b:	8b 45 08             	mov    0x8(%ebp),%eax
8010811e:	e8 9d f3 ff ff       	call   801074c0 <walkpgdir>
  if(pte == 0)
80108123:	85 c0                	test   %eax,%eax
80108125:	74 05                	je     8010812c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108127:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010812a:	c9                   	leave  
8010812b:	c3                   	ret    
    panic("clearpteu");
8010812c:	83 ec 0c             	sub    $0xc,%esp
8010812f:	68 ef 9a 10 80       	push   $0x80109aef
80108134:	e8 57 82 ff ff       	call   80100390 <panic>
80108139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108140 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80108140:	55                   	push   %ebp
80108141:	89 e5                	mov    %esp,%ebp
80108143:	57                   	push   %edi
80108144:	56                   	push   %esi
80108145:	53                   	push   %ebx
80108146:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80108149:	e8 12 ff ff ff       	call   80108060 <setupkvm>
8010814e:	85 c0                	test   %eax,%eax
80108150:	89 c7                	mov    %eax,%edi
80108152:	0f 84 ce 00 00 00    	je     80108226 <cowuvm+0xe6>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80108158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010815b:	85 c0                	test   %eax,%eax
8010815d:	0f 84 c3 00 00 00    	je     80108226 <cowuvm+0xe6>
80108163:	8b 45 08             	mov    0x8(%ebp),%eax
80108166:	31 db                	xor    %ebx,%ebx
80108168:	05 00 00 00 80       	add    $0x80000000,%eax
8010816d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108170:	eb 62                	jmp    801081d4 <cowuvm+0x94>
80108172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }
    
    *pte |= PTE_COW;
    *pte &= ~PTE_W;
80108178:	89 d1                	mov    %edx,%ecx
8010817a:	89 d6                	mov    %edx,%esi

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
8010817c:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80108182:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80108185:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80108188:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
8010818b:	80 cd 04             	or     $0x4,%ch
8010818e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80108194:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80108196:	52                   	push   %edx
80108197:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010819c:	56                   	push   %esi
8010819d:	89 da                	mov    %ebx,%edx
8010819f:	89 f8                	mov    %edi,%eax
801081a1:	e8 9a f3 ff ff       	call   80107540 <mappages>
801081a6:	83 c4 10             	add    $0x10,%esp
801081a9:	85 c0                	test   %eax,%eax
801081ab:	0f 88 7f 00 00 00    	js     80108230 <cowuvm+0xf0>
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
801081b1:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
801081b4:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
801081ba:	56                   	push   %esi
801081bb:	e8 90 ac ff ff       	call   80102e50 <refInc>
801081c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801081c3:	0f 22 d8             	mov    %eax,%cr3
801081c6:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
801081c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801081cf:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801081d2:	76 52                	jbe    80108226 <cowuvm+0xe6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801081d4:	8b 45 08             	mov    0x8(%ebp),%eax
801081d7:	31 c9                	xor    %ecx,%ecx
801081d9:	89 da                	mov    %ebx,%edx
801081db:	e8 e0 f2 ff ff       	call   801074c0 <walkpgdir>
801081e0:	85 c0                	test   %eax,%eax
801081e2:	0f 84 7f 00 00 00    	je     80108267 <cowuvm+0x127>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801081e8:	8b 10                	mov    (%eax),%edx
801081ea:	f7 c2 01 02 00 00    	test   $0x201,%edx
801081f0:	74 68                	je     8010825a <cowuvm+0x11a>
    if(*pte & PTE_PG)  //there is pgfault, then not mark this entry as cow
801081f2:	f6 c6 02             	test   $0x2,%dh
801081f5:	74 81                	je     80108178 <cowuvm+0x38>
      cprintf("cowuvm,  not marked as cow because pgfault \n");
801081f7:	83 ec 0c             	sub    $0xc,%esp
801081fa:	68 54 9c 10 80       	push   $0x80109c54
801081ff:	e8 5c 84 ff ff       	call   80100660 <cprintf>
       pte = walkpgdir(d, (void*) i, 1);
80108204:	89 da                	mov    %ebx,%edx
80108206:	b9 01 00 00 00       	mov    $0x1,%ecx
8010820b:	89 f8                	mov    %edi,%eax
8010820d:	e8 ae f2 ff ff       	call   801074c0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE)
80108212:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      continue;
80108218:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
8010821b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
8010821e:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE)
80108224:	77 ae                	ja     801081d4 <cowuvm+0x94>
bad:
  cprintf("bad: cowuvm\n");
  freevm(d);
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
}
80108226:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108229:	89 f8                	mov    %edi,%eax
8010822b:	5b                   	pop    %ebx
8010822c:	5e                   	pop    %esi
8010822d:	5f                   	pop    %edi
8010822e:	5d                   	pop    %ebp
8010822f:	c3                   	ret    
  cprintf("bad: cowuvm\n");
80108230:	83 ec 0c             	sub    $0xc,%esp
80108233:	68 08 9b 10 80       	push   $0x80109b08
80108238:	e8 23 84 ff ff       	call   80100660 <cprintf>
  freevm(d);
8010823d:	89 3c 24             	mov    %edi,(%esp)
80108240:	e8 9b fd ff ff       	call   80107fe0 <freevm>
80108245:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108248:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010824b:	83 c4 10             	add    $0x10,%esp
}
8010824e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108251:	31 ff                	xor    %edi,%edi
}
80108253:	89 f8                	mov    %edi,%eax
80108255:	5b                   	pop    %ebx
80108256:	5e                   	pop    %esi
80108257:	5f                   	pop    %edi
80108258:	5d                   	pop    %ebp
80108259:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
8010825a:	83 ec 0c             	sub    $0xc,%esp
8010825d:	68 24 9c 10 80       	push   $0x80109c24
80108262:	e8 29 81 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80108267:	83 ec 0c             	sub    $0xc,%esp
8010826a:	68 f9 9a 10 80       	push   $0x80109af9
8010826f:	e8 1c 81 ff ff       	call   80100390 <panic>
80108274:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010827a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108280 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80108280:	55                   	push   %ebp
80108281:	89 e5                	mov    %esp,%ebp
80108283:	53                   	push   %ebx
80108284:	83 ec 04             	sub    $0x4,%esp
80108287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
8010828a:	e8 31 c0 ff ff       	call   801042c0 <myproc>
8010828f:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108295:	31 c0                	xor    %eax,%eax
80108297:	eb 12                	jmp    801082ab <getSwappedPageIndex+0x2b>
80108299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082a0:	83 c0 01             	add    $0x1,%eax
801082a3:	83 c2 1c             	add    $0x1c,%edx
801082a6:	83 f8 10             	cmp    $0x10,%eax
801082a9:	74 0d                	je     801082b8 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
801082ab:	39 1a                	cmp    %ebx,(%edx)
801082ad:	75 f1                	jne    801082a0 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
801082af:	83 c4 04             	add    $0x4,%esp
801082b2:	5b                   	pop    %ebx
801082b3:	5d                   	pop    %ebp
801082b4:	c3                   	ret    
801082b5:	8d 76 00             	lea    0x0(%esi),%esi
801082b8:	83 c4 04             	add    $0x4,%esp
  return -1;
801082bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082c0:	5b                   	pop    %ebx
801082c1:	5d                   	pop    %ebp
801082c2:	c3                   	ret    
801082c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801082c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082d0 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
801082d0:	55                   	push   %ebp
801082d1:	89 e5                	mov    %esp,%ebp
801082d3:	57                   	push   %edi
801082d4:	56                   	push   %esi
801082d5:	53                   	push   %ebx
801082d6:	83 ec 1c             	sub    $0x1c,%esp
801082d9:	8b 45 08             	mov    0x8(%ebp),%eax
801082dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801082df:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
801082e2:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
801082e5:	f6 42 34 02          	testb  $0x2,0x34(%edx)
801082e9:	74 07                	je     801082f2 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
801082eb:	8b 13                	mov    (%ebx),%edx
801082ed:	f6 c6 04             	test   $0x4,%dh
801082f0:	75 16                	jne    80108308 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
801082f2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
801082f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082fc:	5b                   	pop    %ebx
801082fd:	5e                   	pop    %esi
801082fe:	5f                   	pop    %edi
801082ff:	5d                   	pop    %ebp
80108300:	c3                   	ret    
80108301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
80108308:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
8010830a:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
8010830d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108310:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80108316:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
8010831c:	57                   	push   %edi
8010831d:	e8 9e ab ff ff       	call   80102ec0 <getRefs>
      if (ref_count > 1) // more than one reference
80108322:	83 c4 10             	add    $0x10,%esp
80108325:	83 f8 01             	cmp    $0x1,%eax
80108328:	7f 16                	jg     80108340 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
8010832a:	8b 03                	mov    (%ebx),%eax
8010832c:	80 e4 fb             	and    $0xfb,%ah
8010832f:	83 c8 02             	or     $0x2,%eax
80108332:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80108334:	0f 01 3e             	invlpg (%esi)
80108337:	eb c0                	jmp    801082f9 <handle_cow_pagefault+0x29>
80108339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80108340:	e8 eb a9 ff ff       	call   80102d30 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108345:	83 ec 04             	sub    $0x4,%esp
80108348:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010834b:	68 00 10 00 00       	push   $0x1000
80108350:	57                   	push   %edi
80108351:	50                   	push   %eax
80108352:	e8 69 d0 ff ff       	call   801053c0 <memmove>
      flags = PTE_FLAGS(*pte);
80108357:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
8010835a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
8010835d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
80108363:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108369:	83 ca 03             	or     $0x3,%edx
8010836c:	09 ca                	or     %ecx,%edx
8010836e:	89 13                	mov    %edx,(%ebx)
80108370:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
80108373:	89 7d 08             	mov    %edi,0x8(%ebp)
80108376:	83 c4 10             	add    $0x10,%esp
}
80108379:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010837c:	5b                   	pop    %ebx
8010837d:	5e                   	pop    %esi
8010837e:	5f                   	pop    %edi
8010837f:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
80108380:	e9 5b aa ff ff       	jmp    80102de0 <refDec>
80108385:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108390 <handle_pagedout>:

void
handle_pagedout(struct proc* curproc, char* start_page, pte_t* pte)
{
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	57                   	push   %edi
80108394:	56                   	push   %esi
80108395:	53                   	push   %ebx
80108396:	83 ec 20             	sub    $0x20,%esp
80108399:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010839c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010839f:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* new_page;
    void* ramPa;
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
801083a2:	8d 43 6c             	lea    0x6c(%ebx),%eax
801083a5:	ff 73 10             	pushl  0x10(%ebx)
801083a8:	50                   	push   %eax
801083a9:	68 84 9c 10 80       	push   $0x80109c84
801083ae:	e8 ad 82 ff ff       	call   80100660 <cprintf>

    new_page = kalloc();
801083b3:	e8 78 a9 ff ff       	call   80102d30 <kalloc>
    *pte |= PTE_P | PTE_W | PTE_U;
    *pte &= ~PTE_PG;
    *pte &= 0xFFF;
801083b8:	8b 17                	mov    (%edi),%edx
    *pte |= V2P(new_page);
801083ba:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
801083bf:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
801083c5:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
801083c8:	09 d0                	or     %edx,%eax
801083ca:	89 07                	mov    %eax,(%edi)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801083cc:	31 ff                	xor    %edi,%edi
  struct proc* curproc = myproc();
801083ce:	e8 ed be ff ff       	call   801042c0 <myproc>
801083d3:	83 c4 10             	add    $0x10,%esp
801083d6:	05 90 00 00 00       	add    $0x90,%eax
801083db:	eb 12                	jmp    801083ef <handle_pagedout+0x5f>
801083dd:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801083e0:	83 c7 01             	add    $0x1,%edi
801083e3:	83 c0 1c             	add    $0x1c,%eax
801083e6:	83 ff 10             	cmp    $0x10,%edi
801083e9:	0f 84 99 01 00 00    	je     80108588 <handle_pagedout+0x1f8>
    if(curproc->swappedPages[i].virt_addr == va)
801083ef:	3b 30                	cmp    (%eax),%esi
801083f1:	75 ed                	jne    801083e0 <handle_pagedout+0x50>
801083f3:	6b c7 1c             	imul   $0x1c,%edi,%eax
801083f6:	05 88 00 00 00       	add    $0x88,%eax
    
    int index = getSwappedPageIndex(start_page); // get swap page index
    struct page *swap_page = &curproc->swappedPages[index];
801083fb:	01 d8                	add    %ebx,%eax

    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801083fd:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80108402:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108405:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108408:	01 d8                	add    %ebx,%eax
8010840a:	ff b0 94 00 00 00    	pushl  0x94(%eax)
80108410:	68 e0 c5 10 80       	push   $0x8010c5e0
80108415:	53                   	push   %ebx
80108416:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108419:	e8 12 a2 ff ff       	call   80102630 <readFromSwapFile>
8010841e:	83 c4 10             	add    $0x10,%esp
80108421:	85 c0                	test   %eax,%eax
80108423:	0f 88 fe 01 00 00    	js     80108627 <handle_pagedout+0x297>
      panic("allocuvm: readFromSwapFile");

    struct fblock *new_block = (struct fblock*)kalloc();
80108429:	e8 02 a9 ff ff       	call   80102d30 <kalloc>
    new_block->off = swap_page->swap_offset;
8010842e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108431:	8b 91 94 00 00 00    	mov    0x94(%ecx),%edx
    new_block->next = 0;
80108437:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
8010843e:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80108440:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108446:	89 50 08             	mov    %edx,0x8(%eax)

    if(curproc->free_tail != 0)
80108449:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
8010844f:	85 d2                	test   %edx,%edx
80108451:	0f 84 b9 01 00 00    	je     80108610 <handle_pagedout+0x280>
      curproc->free_tail->next = new_block;
80108457:	89 42 04             	mov    %eax,0x4(%edx)
    curproc->free_tail = new_block;

    // cprintf("free blocks list after readFromSwapFile:\n");
    // printlist();

    memmove((void*)start_page, buffer, PGSIZE);
8010845a:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
8010845d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108463:	68 00 10 00 00       	push   $0x1000
80108468:	68 e0 c5 10 80       	push   $0x8010c5e0
8010846d:	56                   	push   %esi
8010846e:	e8 4d cf ff ff       	call   801053c0 <memmove>

    // zero swap page entry
    memset((void*)swap_page, 0, sizeof(struct page));
80108473:	83 c4 0c             	add    $0xc,%esp
80108476:	6a 1c                	push   $0x1c
80108478:	6a 00                	push   $0x0
8010847a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010847d:	e8 8e ce ff ff       	call   80105310 <memset>

    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108482:	83 c4 10             	add    $0x10,%esp
80108485:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
8010848c:	0f 8e 0e 01 00 00    	jle    801085a0 <handle_pagedout+0x210>
    else // no sapce in proc RAM, will swap
    {
      int index_to_evicet = indexToEvict();
      // cprintf("[pagefault] index to evict: %d\n", index_to_evicet);
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
      int swap_offset = curproc->free_head->off;
80108492:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
80108498:	8b 02                	mov    (%edx),%eax
8010849a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

      if(curproc->free_head->next == 0)
8010849d:	8b 42 04             	mov    0x4(%edx),%eax
801084a0:	85 c0                	test   %eax,%eax
801084a2:	0f 84 b8 00 00 00    	je     80108560 <handle_pagedout+0x1d0>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
801084a8:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
801084ab:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
801084b1:	ff 70 08             	pushl  0x8(%eax)
801084b4:	e8 97 a5 ff ff       	call   80102a50 <kfree>
801084b9:	83 c4 10             	add    $0x10,%esp
      }

      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
801084bc:	68 00 10 00 00       	push   $0x1000
801084c1:	ff 75 e4             	pushl  -0x1c(%ebp)
801084c4:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
801084ca:	53                   	push   %ebx
801084cb:	e8 30 a1 ff ff       	call   80102600 <writeToSwapFile>
801084d0:	83 c4 10             	add    $0x10,%esp
801084d3:	85 c0                	test   %eax,%eax
801084d5:	0f 88 59 01 00 00    	js     80108634 <handle_pagedout+0x2a4>
        panic("allocuvm: writeToSwapFile");
      
      swap_page->virt_addr = ram_page->virt_addr;
801084db:	6b cf 1c             	imul   $0x1c,%edi,%ecx
801084de:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
801084e4:	01 d9                	add    %ebx,%ecx
801084e6:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
801084ec:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      swap_page->isused = 1;
801084f2:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
801084f9:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
801084fc:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108505:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)

      // get pte of RAM page
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
8010850b:	8b 43 04             	mov    0x4(%ebx),%eax
8010850e:	31 c9                	xor    %ecx,%ecx
80108510:	e8 ab ef ff ff       	call   801074c0 <walkpgdir>
      if(!(*pte & PTE_P))
80108515:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108517:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80108519:	f6 c2 01             	test   $0x1,%dl
8010851c:	0f 84 1f 01 00 00    	je     80108641 <handle_pagedout+0x2b1>
        panic("pagefault: ram page is not present");
      ramPa = (void*)PTE_ADDR(*pte);
80108522:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx

      kfree(P2V(ramPa));
80108528:	83 ec 0c             	sub    $0xc,%esp
8010852b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108531:	52                   	push   %edx
80108532:	e8 19 a5 ff ff       	call   80102a50 <kfree>
      *pte &= 0xFFF;   // ???
      
      // prepare to-be-swapped page in RAM to move to swap file
      *pte |= PTE_PG;     // turn "paged-out" flag on
      *pte &= ~PTE_P;     // turn "present" flag off
80108537:	8b 07                	mov    (%edi),%eax
80108539:	25 fe 0f 00 00       	and    $0xffe,%eax
8010853e:	80 cc 02             	or     $0x2,%ah
80108541:	89 07                	mov    %eax,(%edi)

      ram_page->virt_addr = start_page;
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
      
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108543:	8b 43 04             	mov    0x4(%ebx),%eax
      ram_page->virt_addr = start_page;
80108546:	89 b3 a4 02 00 00    	mov    %esi,0x2a4(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
8010854c:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108551:	0f 22 d8             	mov    %eax,%cr3
80108554:	83 c4 10             	add    $0x10,%esp
    }
    return;
}
80108557:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010855a:	5b                   	pop    %ebx
8010855b:	5e                   	pop    %esi
8010855c:	5f                   	pop    %edi
8010855d:	5d                   	pop    %ebp
8010855e:	c3                   	ret    
8010855f:	90                   	nop
        kfree((char*)curproc->free_head);
80108560:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80108563:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
8010856a:	00 00 00 
        kfree((char*)curproc->free_head);
8010856d:	52                   	push   %edx
8010856e:	e8 dd a4 ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80108573:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
8010857a:	00 00 00 
8010857d:	83 c4 10             	add    $0x10,%esp
80108580:	e9 37 ff ff ff       	jmp    801084bc <handle_pagedout+0x12c>
80108585:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108588:	b8 6c 00 00 00       	mov    $0x6c,%eax
  return -1;
8010858d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108592:	e9 64 fe ff ff       	jmp    801083fb <handle_pagedout+0x6b>
80108597:	89 f6                	mov    %esi,%esi
80108599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
801085a0:	e8 1b bd ff ff       	call   801042c0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801085a5:	31 ff                	xor    %edi,%edi
801085a7:	05 4c 02 00 00       	add    $0x24c,%eax
801085ac:	eb 0d                	jmp    801085bb <handle_pagedout+0x22b>
801085ae:	66 90                	xchg   %ax,%ax
801085b0:	83 c7 01             	add    $0x1,%edi
801085b3:	83 c0 1c             	add    $0x1c,%eax
801085b6:	83 ff 10             	cmp    $0x10,%edi
801085b9:	74 65                	je     80108620 <handle_pagedout+0x290>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
801085bb:	8b 10                	mov    (%eax),%edx
801085bd:	85 d2                	test   %edx,%edx
801085bf:	75 ef                	jne    801085b0 <handle_pagedout+0x220>
      cprintf("filling ram slot: %d\n", new_indx);
801085c1:	83 ec 08             	sub    $0x8,%esp
801085c4:	57                   	push   %edi
801085c5:	68 30 9b 10 80       	push   $0x80109b30
      curproc->ramPages[new_indx].virt_addr = start_page;
801085ca:	6b ff 1c             	imul   $0x1c,%edi,%edi
      cprintf("filling ram slot: %d\n", new_indx);
801085cd:	e8 8e 80 ff ff       	call   80100660 <cprintf>
801085d2:	83 c4 10             	add    $0x10,%esp
      curproc->ramPages[new_indx].virt_addr = start_page;
801085d5:	01 df                	add    %ebx,%edi
801085d7:	89 b7 50 02 00 00    	mov    %esi,0x250(%edi)
      curproc->ramPages[new_indx].isused = 1;
801085dd:	c7 87 4c 02 00 00 01 	movl   $0x1,0x24c(%edi)
801085e4:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801085e7:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
801085ea:	c7 87 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edi)
801085f1:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801085f4:	89 87 48 02 00 00    	mov    %eax,0x248(%edi)
      curproc->num_ram++;
801085fa:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
80108601:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
80108608:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010860b:	5b                   	pop    %ebx
8010860c:	5e                   	pop    %esi
8010860d:	5f                   	pop    %edi
8010860e:	5d                   	pop    %ebp
8010860f:	c3                   	ret    
      curproc->free_head = new_block;
80108610:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108616:	e9 3f fe ff ff       	jmp    8010845a <handle_pagedout+0xca>
8010861b:	90                   	nop
8010861c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return i;
  }
  return -1;
80108620:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108625:	eb 9a                	jmp    801085c1 <handle_pagedout+0x231>
      panic("allocuvm: readFromSwapFile");
80108627:	83 ec 0c             	sub    $0xc,%esp
8010862a:	68 15 9b 10 80       	push   $0x80109b15
8010862f:	e8 5c 7d ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108634:	83 ec 0c             	sub    $0xc,%esp
80108637:	68 74 9a 10 80       	push   $0x80109a74
8010863c:	e8 4f 7d ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108641:	83 ec 0c             	sub    $0xc,%esp
80108644:	68 b4 9c 10 80       	push   $0x80109cb4
80108649:	e8 42 7d ff ff       	call   80100390 <panic>
8010864e:	66 90                	xchg   %ax,%ax

80108650 <pagefault>:
{
80108650:	55                   	push   %ebp
80108651:	89 e5                	mov    %esp,%ebp
80108653:	57                   	push   %edi
80108654:	56                   	push   %esi
80108655:	53                   	push   %ebx
80108656:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108659:	e8 62 bc ff ff       	call   801042c0 <myproc>
8010865e:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108660:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108663:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010866a:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
8010866c:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010866f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108675:	31 c9                	xor    %ecx,%ecx
80108677:	89 fa                	mov    %edi,%edx
80108679:	e8 42 ee ff ff       	call   801074c0 <walkpgdir>
  if((*pte & PTE_PG) && !(*pte & PTE_COW)) // paged out, not COW todo
8010867e:	8b 10                	mov    (%eax),%edx
80108680:	81 e2 00 06 00 00    	and    $0x600,%edx
80108686:	81 fa 00 02 00 00    	cmp    $0x200,%edx
8010868c:	74 62                	je     801086f0 <pagefault+0xa0>
    if(va >= KERNBASE || pte == 0)
8010868e:	85 f6                	test   %esi,%esi
80108690:	78 2e                	js     801086c0 <pagefault+0x70>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108692:	8b 43 04             	mov    0x4(%ebx),%eax
80108695:	31 c9                	xor    %ecx,%ecx
80108697:	89 f2                	mov    %esi,%edx
80108699:	e8 22 ee ff ff       	call   801074c0 <walkpgdir>
8010869e:	85 c0                	test   %eax,%eax
801086a0:	74 64                	je     80108706 <pagefault+0xb6>
    handle_cow_pagefault(curproc, pte, va);
801086a2:	83 ec 04             	sub    $0x4,%esp
801086a5:	56                   	push   %esi
801086a6:	50                   	push   %eax
801086a7:	53                   	push   %ebx
801086a8:	e8 23 fc ff ff       	call   801082d0 <handle_cow_pagefault>
801086ad:	83 c4 10             	add    $0x10,%esp
}
801086b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086b3:	5b                   	pop    %ebx
801086b4:	5e                   	pop    %esi
801086b5:	5f                   	pop    %edi
801086b6:	5d                   	pop    %ebp
801086b7:	c3                   	ret    
801086b8:	90                   	nop
801086b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
801086c0:	8d 43 6c             	lea    0x6c(%ebx),%eax
801086c3:	83 ec 04             	sub    $0x4,%esp
801086c6:	50                   	push   %eax
801086c7:	ff 73 10             	pushl  0x10(%ebx)
801086ca:	68 d8 9c 10 80       	push   $0x80109cd8
801086cf:	e8 8c 7f ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
801086d4:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
801086db:	83 c4 10             	add    $0x10,%esp
}
801086de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086e1:	5b                   	pop    %ebx
801086e2:	5e                   	pop    %esi
801086e3:	5f                   	pop    %edi
801086e4:	5d                   	pop    %ebp
801086e5:	c3                   	ret    
801086e6:	8d 76 00             	lea    0x0(%esi),%esi
801086e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    handle_pagedout(curproc, start_page, pte);
801086f0:	83 ec 04             	sub    $0x4,%esp
801086f3:	50                   	push   %eax
801086f4:	57                   	push   %edi
801086f5:	53                   	push   %ebx
801086f6:	e8 95 fc ff ff       	call   80108390 <handle_pagedout>
801086fb:	83 c4 10             	add    $0x10,%esp
}
801086fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108701:	5b                   	pop    %ebx
80108702:	5e                   	pop    %esi
80108703:	5f                   	pop    %edi
80108704:	5d                   	pop    %ebp
80108705:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
80108706:	83 ec 0c             	sub    $0xc,%esp
80108709:	68 46 9b 10 80       	push   $0x80109b46
8010870e:	e8 7d 7c ff ff       	call   80100390 <panic>
80108713:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108720 <update_selectionfiled_pagefault>:
80108720:	55                   	push   %ebp
80108721:	89 e5                	mov    %esp,%ebp
80108723:	5d                   	pop    %ebp
80108724:	c3                   	ret    
80108725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108730 <copyuvm>:
{
80108730:	55                   	push   %ebp
80108731:	89 e5                	mov    %esp,%ebp
80108733:	57                   	push   %edi
80108734:	56                   	push   %esi
80108735:	53                   	push   %ebx
80108736:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
80108739:	e8 22 f9 ff ff       	call   80108060 <setupkvm>
8010873e:	85 c0                	test   %eax,%eax
80108740:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108743:	0f 84 bf 00 00 00    	je     80108808 <copyuvm+0xd8>
  for(i = 0; i < sz; i += PGSIZE){
80108749:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010874c:	85 db                	test   %ebx,%ebx
8010874e:	0f 84 b4 00 00 00    	je     80108808 <copyuvm+0xd8>
80108754:	31 f6                	xor    %esi,%esi
80108756:	eb 69                	jmp    801087c1 <copyuvm+0x91>
80108758:	90                   	nop
80108759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
80108760:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80108762:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80108768:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010876e:	e8 bd a5 ff ff       	call   80102d30 <kalloc>
80108773:	85 c0                	test   %eax,%eax
80108775:	0f 84 ad 00 00 00    	je     80108828 <copyuvm+0xf8>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010877b:	83 ec 04             	sub    $0x4,%esp
8010877e:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108784:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108787:	68 00 10 00 00       	push   $0x1000
8010878c:	57                   	push   %edi
8010878d:	50                   	push   %eax
8010878e:	e8 2d cc ff ff       	call   801053c0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108793:	5a                   	pop    %edx
80108794:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108797:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010879a:	59                   	pop    %ecx
8010879b:	53                   	push   %ebx
8010879c:	b9 00 10 00 00       	mov    $0x1000,%ecx
801087a1:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801087a7:	52                   	push   %edx
801087a8:	89 f2                	mov    %esi,%edx
801087aa:	e8 91 ed ff ff       	call   80107540 <mappages>
801087af:	83 c4 10             	add    $0x10,%esp
801087b2:	85 c0                	test   %eax,%eax
801087b4:	78 62                	js     80108818 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801087b6:	81 c6 00 10 00 00    	add    $0x1000,%esi
801087bc:	39 75 0c             	cmp    %esi,0xc(%ebp)
801087bf:	76 47                	jbe    80108808 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801087c1:	8b 45 08             	mov    0x8(%ebp),%eax
801087c4:	31 c9                	xor    %ecx,%ecx
801087c6:	89 f2                	mov    %esi,%edx
801087c8:	e8 f3 ec ff ff       	call   801074c0 <walkpgdir>
801087cd:	85 c0                	test   %eax,%eax
801087cf:	0f 84 8b 00 00 00    	je     80108860 <copyuvm+0x130>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801087d5:	8b 18                	mov    (%eax),%ebx
801087d7:	f7 c3 01 02 00 00    	test   $0x201,%ebx
801087dd:	74 74                	je     80108853 <copyuvm+0x123>
    if (*pte & PTE_PG) {
801087df:	f6 c7 02             	test   $0x2,%bh
801087e2:	0f 84 78 ff ff ff    	je     80108760 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
801087e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087eb:	89 f2                	mov    %esi,%edx
801087ed:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801087f2:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801087f8:	e8 c3 ec ff ff       	call   801074c0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
801087fd:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
80108800:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108806:	77 b9                	ja     801087c1 <copyuvm+0x91>
}
80108808:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010880b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010880e:	5b                   	pop    %ebx
8010880f:	5e                   	pop    %esi
80108810:	5f                   	pop    %edi
80108811:	5d                   	pop    %ebp
80108812:	c3                   	ret    
80108813:	90                   	nop
80108814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("copyuvm: mappages failed\n");
80108818:	83 ec 0c             	sub    $0xc,%esp
8010881b:	68 79 9b 10 80       	push   $0x80109b79
80108820:	e8 3b 7e ff ff       	call   80100660 <cprintf>
      goto bad;
80108825:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
80108828:	83 ec 0c             	sub    $0xc,%esp
8010882b:	68 93 9b 10 80       	push   $0x80109b93
80108830:	e8 2b 7e ff ff       	call   80100660 <cprintf>
  freevm(d);
80108835:	58                   	pop    %eax
80108836:	ff 75 e0             	pushl  -0x20(%ebp)
80108839:	e8 a2 f7 ff ff       	call   80107fe0 <freevm>
  return 0;
8010883e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108845:	83 c4 10             	add    $0x10,%esp
}
80108848:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010884b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010884e:	5b                   	pop    %ebx
8010884f:	5e                   	pop    %esi
80108850:	5f                   	pop    %edi
80108851:	5d                   	pop    %ebp
80108852:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
80108853:	83 ec 0c             	sub    $0xc,%esp
80108856:	68 0c 9d 10 80       	push   $0x80109d0c
8010885b:	e8 30 7b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108860:	83 ec 0c             	sub    $0xc,%esp
80108863:	68 5f 9b 10 80       	push   $0x80109b5f
80108868:	e8 23 7b ff ff       	call   80100390 <panic>
8010886d:	8d 76 00             	lea    0x0(%esi),%esi

80108870 <uva2ka>:
{
80108870:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80108871:	31 c9                	xor    %ecx,%ecx
{
80108873:	89 e5                	mov    %esp,%ebp
80108875:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108878:	8b 55 0c             	mov    0xc(%ebp),%edx
8010887b:	8b 45 08             	mov    0x8(%ebp),%eax
8010887e:	e8 3d ec ff ff       	call   801074c0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108883:	8b 00                	mov    (%eax),%eax
}
80108885:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108886:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108888:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010888d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108890:	05 00 00 00 80       	add    $0x80000000,%eax
80108895:	83 fa 05             	cmp    $0x5,%edx
80108898:	ba 00 00 00 00       	mov    $0x0,%edx
8010889d:	0f 45 c2             	cmovne %edx,%eax
}
801088a0:	c3                   	ret    
801088a1:	eb 0d                	jmp    801088b0 <copyout>
801088a3:	90                   	nop
801088a4:	90                   	nop
801088a5:	90                   	nop
801088a6:	90                   	nop
801088a7:	90                   	nop
801088a8:	90                   	nop
801088a9:	90                   	nop
801088aa:	90                   	nop
801088ab:	90                   	nop
801088ac:	90                   	nop
801088ad:	90                   	nop
801088ae:	90                   	nop
801088af:	90                   	nop

801088b0 <copyout>:
{
801088b0:	55                   	push   %ebp
801088b1:	89 e5                	mov    %esp,%ebp
801088b3:	57                   	push   %edi
801088b4:	56                   	push   %esi
801088b5:	53                   	push   %ebx
801088b6:	83 ec 1c             	sub    $0x1c,%esp
801088b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801088bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801088bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
801088c2:	85 db                	test   %ebx,%ebx
801088c4:	75 40                	jne    80108906 <copyout+0x56>
801088c6:	eb 70                	jmp    80108938 <copyout+0x88>
801088c8:	90                   	nop
801088c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
801088d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801088d3:	89 f1                	mov    %esi,%ecx
801088d5:	29 d1                	sub    %edx,%ecx
801088d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801088dd:	39 d9                	cmp    %ebx,%ecx
801088df:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
801088e2:	29 f2                	sub    %esi,%edx
801088e4:	83 ec 04             	sub    $0x4,%esp
801088e7:	01 d0                	add    %edx,%eax
801088e9:	51                   	push   %ecx
801088ea:	57                   	push   %edi
801088eb:	50                   	push   %eax
801088ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801088ef:	e8 cc ca ff ff       	call   801053c0 <memmove>
    buf += n;
801088f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801088f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801088fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108900:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108902:	29 cb                	sub    %ecx,%ebx
80108904:	74 32                	je     80108938 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108906:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108908:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010890b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010890e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108914:	56                   	push   %esi
80108915:	ff 75 08             	pushl  0x8(%ebp)
80108918:	e8 53 ff ff ff       	call   80108870 <uva2ka>
    if(pa0 == 0)
8010891d:	83 c4 10             	add    $0x10,%esp
80108920:	85 c0                	test   %eax,%eax
80108922:	75 ac                	jne    801088d0 <copyout+0x20>
}
80108924:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108927:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010892c:	5b                   	pop    %ebx
8010892d:	5e                   	pop    %esi
8010892e:	5f                   	pop    %edi
8010892f:	5d                   	pop    %ebp
80108930:	c3                   	ret    
80108931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108938:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010893b:	31 c0                	xor    %eax,%eax
}
8010893d:	5b                   	pop    %ebx
8010893e:	5e                   	pop    %esi
8010893f:	5f                   	pop    %edi
80108940:	5d                   	pop    %ebp
80108941:	c3                   	ret    
80108942:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108950 <getNextFreeRamIndex>:
{ 
80108950:	55                   	push   %ebp
80108951:	89 e5                	mov    %esp,%ebp
80108953:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80108956:	e8 65 b9 ff ff       	call   801042c0 <myproc>
8010895b:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108961:	31 c0                	xor    %eax,%eax
80108963:	eb 0e                	jmp    80108973 <getNextFreeRamIndex+0x23>
80108965:	8d 76 00             	lea    0x0(%esi),%esi
80108968:	83 c0 01             	add    $0x1,%eax
8010896b:	83 c2 1c             	add    $0x1c,%edx
8010896e:	83 f8 10             	cmp    $0x10,%eax
80108971:	74 0d                	je     80108980 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108973:	8b 0a                	mov    (%edx),%ecx
80108975:	85 c9                	test   %ecx,%ecx
80108977:	75 ef                	jne    80108968 <getNextFreeRamIndex+0x18>
}
80108979:	c9                   	leave  
8010897a:	c3                   	ret    
8010897b:	90                   	nop
8010897c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108985:	c9                   	leave  
80108986:	c3                   	ret    
80108987:	89 f6                	mov    %esi,%esi
80108989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108990 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108990:	55                   	push   %ebp
80108991:	89 e5                	mov    %esp,%ebp
80108993:	56                   	push   %esi
80108994:	53                   	push   %ebx
80108995:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108998:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010899e:	81 c6 08 04 00 00    	add    $0x408,%esi
801089a4:	eb 1d                	jmp    801089c3 <updateLapa+0x33>
801089a6:	8d 76 00             	lea    0x0(%esi),%esi
801089a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
801089b0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
801089b6:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
801089b9:	83 20 df             	andl   $0xffffffdf,(%eax)
801089bc:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801089bf:	39 f3                	cmp    %esi,%ebx
801089c1:	74 2b                	je     801089ee <updateLapa+0x5e>
    if(!cur_page->isused)
801089c3:	8b 43 04             	mov    0x4(%ebx),%eax
801089c6:	85 c0                	test   %eax,%eax
801089c8:	74 f2                	je     801089bc <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
801089ca:	8b 53 08             	mov    0x8(%ebx),%edx
801089cd:	8b 03                	mov    (%ebx),%eax
801089cf:	31 c9                	xor    %ecx,%ecx
801089d1:	e8 ea ea ff ff       	call   801074c0 <walkpgdir>
801089d6:	85 c0                	test   %eax,%eax
801089d8:	74 1b                	je     801089f5 <updateLapa+0x65>
801089da:	8b 53 18             	mov    0x18(%ebx),%edx
801089dd:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
801089df:	f6 00 20             	testb  $0x20,(%eax)
801089e2:	75 cc                	jne    801089b0 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
801089e4:	89 53 18             	mov    %edx,0x18(%ebx)
801089e7:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801089ea:	39 f3                	cmp    %esi,%ebx
801089ec:	75 d5                	jne    801089c3 <updateLapa+0x33>
    }
  }
}
801089ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801089f1:	5b                   	pop    %ebx
801089f2:	5e                   	pop    %esi
801089f3:	5d                   	pop    %ebp
801089f4:	c3                   	ret    
      panic("updateLapa: no pte");
801089f5:	83 ec 0c             	sub    $0xc,%esp
801089f8:	68 a1 9b 10 80       	push   $0x80109ba1
801089fd:	e8 8e 79 ff ff       	call   80100390 <panic>
80108a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108a10 <updateNfua>:

void updateNfua(struct proc* p)
{
80108a10:	55                   	push   %ebp
80108a11:	89 e5                	mov    %esp,%ebp
80108a13:	56                   	push   %esi
80108a14:	53                   	push   %ebx
80108a15:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108a18:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108a1e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108a24:	eb 1d                	jmp    80108a43 <updateNfua+0x33>
80108a26:	8d 76 00             	lea    0x0(%esi),%esi
80108a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108a30:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108a36:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108a39:	83 20 df             	andl   $0xffffffdf,(%eax)
80108a3c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a3f:	39 f3                	cmp    %esi,%ebx
80108a41:	74 2b                	je     80108a6e <updateNfua+0x5e>
    if(!cur_page->isused)
80108a43:	8b 43 04             	mov    0x4(%ebx),%eax
80108a46:	85 c0                	test   %eax,%eax
80108a48:	74 f2                	je     80108a3c <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108a4a:	8b 53 08             	mov    0x8(%ebx),%edx
80108a4d:	8b 03                	mov    (%ebx),%eax
80108a4f:	31 c9                	xor    %ecx,%ecx
80108a51:	e8 6a ea ff ff       	call   801074c0 <walkpgdir>
80108a56:	85 c0                	test   %eax,%eax
80108a58:	74 1b                	je     80108a75 <updateNfua+0x65>
80108a5a:	8b 53 14             	mov    0x14(%ebx),%edx
80108a5d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
80108a5f:	f6 00 20             	testb  $0x20,(%eax)
80108a62:	75 cc                	jne    80108a30 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108a64:	89 53 14             	mov    %edx,0x14(%ebx)
80108a67:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a6a:	39 f3                	cmp    %esi,%ebx
80108a6c:	75 d5                	jne    80108a43 <updateNfua+0x33>
    }
  }
}
80108a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a71:	5b                   	pop    %ebx
80108a72:	5e                   	pop    %esi
80108a73:	5d                   	pop    %ebp
80108a74:	c3                   	ret    
      panic("updateNfua: no pte");
80108a75:	83 ec 0c             	sub    $0xc,%esp
80108a78:	68 b4 9b 10 80       	push   $0x80109bb4
80108a7d:	e8 0e 79 ff ff       	call   80100390 <panic>
80108a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108a90 <indexToEvict>:
uint indexToEvict()
{  
80108a90:	55                   	push   %ebp
  #if SELECTION==AQ
    return aq();
  #else
  return 11; // default
  #endif
}
80108a91:	b8 03 00 00 00       	mov    $0x3,%eax
{  
80108a96:	89 e5                	mov    %esp,%ebp
}
80108a98:	5d                   	pop    %ebp
80108a99:	c3                   	ret    
80108a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108aa0 <aq>:

uint aq()
{
80108aa0:	55                   	push   %ebp
80108aa1:	89 e5                	mov    %esp,%ebp
80108aa3:	57                   	push   %edi
80108aa4:	56                   	push   %esi
80108aa5:	53                   	push   %ebx
80108aa6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108aa9:	e8 12 b8 ff ff       	call   801042c0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108aae:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
80108ab4:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108aba:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
80108abc:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108abf:	74 45                	je     80108b06 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108ac1:	39 d1                	cmp    %edx,%ecx
80108ac3:	89 c3                	mov    %eax,%ebx
80108ac5:	74 31                	je     80108af8 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108ac7:	8b 41 04             	mov    0x4(%ecx),%eax
80108aca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108ad0:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
80108ad6:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
80108ad9:	83 ec 0c             	sub    $0xc,%esp
80108adc:	52                   	push   %edx
80108add:	e8 6e 9f ff ff       	call   80102a50 <kfree>
  curproc->queue_tail = new_tail;
80108ae2:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
80108ae8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108aeb:	89 f0                	mov    %esi,%eax
80108aed:	5b                   	pop    %ebx
80108aee:	5e                   	pop    %esi
80108aef:	5f                   	pop    %edi
80108af0:	5d                   	pop    %ebp
80108af1:	c3                   	ret    
80108af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108af8:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
80108aff:	00 00 00 
    new_tail = 0;
80108b02:	31 ff                	xor    %edi,%edi
80108b04:	eb d3                	jmp    80108ad9 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108b06:	83 ec 0c             	sub    $0xc,%esp
80108b09:	68 48 9d 10 80       	push   $0x80109d48
80108b0e:	e8 7d 78 ff ff       	call   80100390 <panic>
80108b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108b20 <lapa>:
uint lapa()
{
80108b20:	55                   	push   %ebp
80108b21:	89 e5                	mov    %esp,%ebp
80108b23:	57                   	push   %edi
80108b24:	56                   	push   %esi
80108b25:	53                   	push   %ebx
80108b26:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108b29:	e8 92 b7 ff ff       	call   801042c0 <myproc>
  struct page *ramPages = curproc->ramPages;
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
80108b2e:	8b 90 60 02 00 00    	mov    0x260(%eax),%edx
  struct page *ramPages = curproc->ramPages;
80108b34:	8d b8 48 02 00 00    	lea    0x248(%eax),%edi
80108b3a:	89 7d dc             	mov    %edi,-0x24(%ebp)
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
80108b3d:	85 d2                	test   %edx,%edx
80108b3f:	0f 84 ff 00 00 00    	je     80108c44 <lapa+0x124>
    uint count = 0;
80108b45:	31 c9                	xor    %ecx,%ecx
80108b47:	89 f6                	mov    %esi,%esi
80108b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        count += n & 1;
80108b50:	89 d3                	mov    %edx,%ebx
80108b52:	83 e3 01             	and    $0x1,%ebx
80108b55:	01 d9                	add    %ebx,%ecx
    while (n) {
80108b57:	d1 ea                	shr    %edx
80108b59:	75 f5                	jne    80108b50 <lapa+0x30>
80108b5b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108b5e:	05 7c 02 00 00       	add    $0x27c,%eax
  uint instances = 0;
80108b63:	31 ff                	xor    %edi,%edi
  uint minloc = 0;
80108b65:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108b6c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint count = 0;
80108b6f:	89 c6                	mov    %eax,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108b71:	bb 01 00 00 00       	mov    $0x1,%ebx
80108b76:	8d 76 00             	lea    0x0(%esi),%esi
80108b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108b80:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108b82:	31 d2                	xor    %edx,%edx
    while (n) {
80108b84:	85 c0                	test   %eax,%eax
80108b86:	74 13                	je     80108b9b <lapa+0x7b>
80108b88:	90                   	nop
80108b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108b90:	89 c1                	mov    %eax,%ecx
80108b92:	83 e1 01             	and    $0x1,%ecx
80108b95:	01 ca                	add    %ecx,%edx
    while (n) {
80108b97:	d1 e8                	shr    %eax
80108b99:	75 f5                	jne    80108b90 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
80108b9b:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
80108b9e:	0f 82 84 00 00 00    	jb     80108c28 <lapa+0x108>
      instances++;
80108ba4:	0f 94 c0             	sete   %al
80108ba7:	0f b6 c0             	movzbl %al,%eax
80108baa:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108bac:	83 c3 01             	add    $0x1,%ebx
80108baf:	83 c6 1c             	add    $0x1c,%esi
80108bb2:	83 fb 10             	cmp    $0x10,%ebx
80108bb5:	75 c9                	jne    80108b80 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108bb7:	83 ff 01             	cmp    $0x1,%edi
80108bba:	76 5b                	jbe    80108c17 <lapa+0xf7>
      uint minvalue = ramPages[minloc].lapa_counter;
80108bbc:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
80108bc0:	8b 7d dc             	mov    -0x24(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108bc3:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108bc8:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108bcc:	89 7d dc             	mov    %edi,-0x24(%ebp)
80108bcf:	8b 7d d8             	mov    -0x28(%ebp),%edi
80108bd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108bd8:	8b 1f                	mov    (%edi),%ebx
    while (n) {
80108bda:	85 db                	test   %ebx,%ebx
80108bdc:	74 62                	je     80108c40 <lapa+0x120>
80108bde:	89 d8                	mov    %ebx,%eax
    uint count = 0;
80108be0:	31 d2                	xor    %edx,%edx
80108be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
80108be8:	89 c1                	mov    %eax,%ecx
80108bea:	83 e1 01             	and    $0x1,%ecx
80108bed:	01 ca                	add    %ecx,%edx
    while (n) {
80108bef:	d1 e8                	shr    %eax
80108bf1:	75 f5                	jne    80108be8 <lapa+0xc8>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
80108bf3:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108bf6:	75 14                	jne    80108c0c <lapa+0xec>
80108bf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108bfb:	39 c3                	cmp    %eax,%ebx
80108bfd:	0f 43 d8             	cmovae %eax,%ebx
80108c00:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c03:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80108c06:	0f 42 c6             	cmovb  %esi,%eax
80108c09:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c0c:	83 c6 01             	add    $0x1,%esi
80108c0f:	83 c7 1c             	add    $0x1c,%edi
80108c12:	83 fe 10             	cmp    $0x10,%esi
80108c15:	75 c1                	jne    80108bd8 <lapa+0xb8>
}
80108c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c1a:	83 c4 1c             	add    $0x1c,%esp
80108c1d:	5b                   	pop    %ebx
80108c1e:	5e                   	pop    %esi
80108c1f:	5f                   	pop    %edi
80108c20:	5d                   	pop    %ebp
80108c21:	c3                   	ret    
80108c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      minloc = i;
80108c28:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80108c2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      instances = 1;
80108c2e:	bf 01 00 00 00       	mov    $0x1,%edi
80108c33:	e9 74 ff ff ff       	jmp    80108bac <lapa+0x8c>
80108c38:	90                   	nop
80108c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint count = 0;
80108c40:	31 d2                	xor    %edx,%edx
80108c42:	eb af                	jmp    80108bf3 <lapa+0xd3>
80108c44:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108c4b:	e9 0e ff ff ff       	jmp    80108b5e <lapa+0x3e>

80108c50 <nfua>:
{
80108c50:	55                   	push   %ebp
80108c51:	89 e5                	mov    %esp,%ebp
80108c53:	56                   	push   %esi
80108c54:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108c55:	e8 66 b6 ff ff       	call   801042c0 <myproc>
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c5a:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
80108c5f:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108c65:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
80108c6b:	31 c0                	xor    %eax,%eax
80108c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ramPages[i].nfua_counter < minval)
80108c70:	8b 19                	mov    (%ecx),%ebx
80108c72:	39 f3                	cmp    %esi,%ebx
80108c74:	73 04                	jae    80108c7a <nfua+0x2a>
      minloc = i;
80108c76:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108c78:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c7a:	83 c2 01             	add    $0x1,%edx
80108c7d:	83 c1 1c             	add    $0x1c,%ecx
80108c80:	83 fa 10             	cmp    $0x10,%edx
80108c83:	75 eb                	jne    80108c70 <nfua+0x20>
}
80108c85:	5b                   	pop    %ebx
80108c86:	5e                   	pop    %esi
80108c87:	5d                   	pop    %ebp
80108c88:	c3                   	ret    
80108c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108c90 <scfifo>:
{
80108c90:	55                   	push   %ebp
80108c91:	89 e5                	mov    %esp,%ebp
80108c93:	57                   	push   %edi
80108c94:	56                   	push   %esi
80108c95:	53                   	push   %ebx
80108c96:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108c99:	e8 22 b6 ff ff       	call   801042c0 <myproc>
80108c9e:	89 c7                	mov    %eax,%edi
80108ca0:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108ca6:	83 f8 0f             	cmp    $0xf,%eax
80108ca9:	89 c3                	mov    %eax,%ebx
80108cab:	7f 5f                	jg     80108d0c <scfifo+0x7c>
80108cad:	6b c0 1c             	imul   $0x1c,%eax,%eax
80108cb0:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108cb7:	eb 17                	jmp    80108cd0 <scfifo+0x40>
80108cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108cc0:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108cc3:	83 e2 df             	and    $0xffffffdf,%edx
80108cc6:	83 c6 1c             	add    $0x1c,%esi
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108cc9:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
80108ccc:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108cce:	74 30                	je     80108d00 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108cd0:	8b 56 08             	mov    0x8(%esi),%edx
80108cd3:	8b 06                	mov    (%esi),%eax
80108cd5:	31 c9                	xor    %ecx,%ecx
80108cd7:	e8 e4 e7 ff ff       	call   801074c0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108cdc:	8b 10                	mov    (%eax),%edx
80108cde:	f6 c2 20             	test   $0x20,%dl
80108ce1:	75 dd                	jne    80108cc0 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108ce3:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108cea:	74 74                	je     80108d60 <scfifo+0xd0>
            curproc->clockHand = i + 1;
80108cec:	8d 43 01             	lea    0x1(%ebx),%eax
80108cef:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
80108cf5:	83 c4 0c             	add    $0xc,%esp
80108cf8:	89 d8                	mov    %ebx,%eax
80108cfa:	5b                   	pop    %ebx
80108cfb:	5e                   	pop    %esi
80108cfc:	5f                   	pop    %edi
80108cfd:	5d                   	pop    %ebp
80108cfe:	c3                   	ret    
80108cff:	90                   	nop
80108d00:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108d06:	31 db                	xor    %ebx,%ebx
    for(j=0; j< curproc->clockHand ;j++)
80108d08:	85 c0                	test   %eax,%eax
80108d0a:	74 a1                	je     80108cad <scfifo+0x1d>
80108d0c:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108d12:	31 c9                	xor    %ecx,%ecx
80108d14:	eb 20                	jmp    80108d36 <scfifo+0xa6>
80108d16:	8d 76 00             	lea    0x0(%esi),%esi
80108d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          *pte &= ~PTE_A;  
80108d20:	83 e2 df             	and    $0xffffffdf,%edx
80108d23:	83 c6 1c             	add    $0x1c,%esi
80108d26:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108d28:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108d2e:	39 c8                	cmp    %ecx,%eax
80108d30:	0f 86 70 ff ff ff    	jbe    80108ca6 <scfifo+0x16>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108d36:	8b 56 08             	mov    0x8(%esi),%edx
80108d39:	8b 06                	mov    (%esi),%eax
80108d3b:	89 cb                	mov    %ecx,%ebx
80108d3d:	31 c9                	xor    %ecx,%ecx
80108d3f:	e8 7c e7 ff ff       	call   801074c0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108d44:	8b 10                	mov    (%eax),%edx
80108d46:	8d 4b 01             	lea    0x1(%ebx),%ecx
80108d49:	f6 c2 20             	test   $0x20,%dl
80108d4c:	75 d2                	jne    80108d20 <scfifo+0x90>
          curproc->clockHand = j + 1;
80108d4e:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108d54:	83 c4 0c             	add    $0xc,%esp
80108d57:	89 d8                	mov    %ebx,%eax
80108d59:	5b                   	pop    %ebx
80108d5a:	5e                   	pop    %esi
80108d5b:	5f                   	pop    %edi
80108d5c:	5d                   	pop    %ebp
80108d5d:	c3                   	ret    
80108d5e:	66 90                	xchg   %ax,%ax
            curproc->clockHand = 0;
80108d60:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
80108d67:	00 00 00 
}
80108d6a:	83 c4 0c             	add    $0xc,%esp
80108d6d:	89 d8                	mov    %ebx,%eax
80108d6f:	5b                   	pop    %ebx
80108d70:	5e                   	pop    %esi
80108d71:	5f                   	pop    %edi
80108d72:	5d                   	pop    %ebp
80108d73:	c3                   	ret    
80108d74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108d7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108d80 <countSetBits>:
{
80108d80:	55                   	push   %ebp
    uint count = 0;
80108d81:	31 c0                	xor    %eax,%eax
{
80108d83:	89 e5                	mov    %esp,%ebp
80108d85:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108d88:	85 d2                	test   %edx,%edx
80108d8a:	74 0f                	je     80108d9b <countSetBits+0x1b>
80108d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108d90:	89 d1                	mov    %edx,%ecx
80108d92:	83 e1 01             	and    $0x1,%ecx
80108d95:	01 c8                	add    %ecx,%eax
    while (n) {
80108d97:	d1 ea                	shr    %edx
80108d99:	75 f5                	jne    80108d90 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108d9b:	5d                   	pop    %ebp
80108d9c:	c3                   	ret    
80108d9d:	8d 76 00             	lea    0x0(%esi),%esi

80108da0 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108da0:	55                   	push   %ebp
80108da1:	89 e5                	mov    %esp,%ebp
80108da3:	56                   	push   %esi
80108da4:	53                   	push   %ebx
80108da5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
80108da8:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108dab:	e8 10 b5 ff ff       	call   801042c0 <myproc>
80108db0:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108db6:	74 30                	je     80108de8 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108db8:	e8 03 b5 ff ff       	call   801042c0 <myproc>
80108dbd:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108dc3:	74 53                	je     80108e18 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108dc5:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108dc8:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108dca:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108dcc:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108dcf:	85 d2                	test   %edx,%edx
80108dd1:	74 05                	je     80108dd8 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108dd3:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108dd6:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108dd8:	85 c0                	test   %eax,%eax
80108dda:	74 05                	je     80108de1 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108ddc:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108dde:	89 70 04             	mov    %esi,0x4(%eax)
  }
80108de1:	5b                   	pop    %ebx
80108de2:	5e                   	pop    %esi
80108de3:	5d                   	pop    %ebp
80108de4:	c3                   	ret    
80108de5:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108de8:	e8 d3 b4 ff ff       	call   801042c0 <myproc>
80108ded:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108df3:	e8 c8 b4 ff ff       	call   801042c0 <myproc>
80108df8:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108dfe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108e04:	e8 b7 b4 ff ff       	call   801042c0 <myproc>
80108e09:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108e0f:	75 b4                	jne    80108dc5 <swapAQ+0x25>
80108e11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108e18:	e8 a3 b4 ff ff       	call   801042c0 <myproc>
80108e1d:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108e23:	e8 98 b4 ff ff       	call   801042c0 <myproc>
80108e28:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108e2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108e35:	eb 8e                	jmp    80108dc5 <swapAQ+0x25>
80108e37:	89 f6                	mov    %esi,%esi
80108e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108e40 <updateAQ>:
{
80108e40:	55                   	push   %ebp
80108e41:	89 e5                	mov    %esp,%ebp
80108e43:	57                   	push   %edi
80108e44:	56                   	push   %esi
80108e45:	53                   	push   %ebx
80108e46:	83 ec 1c             	sub    $0x1c,%esp
80108e49:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108e4c:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108e52:	85 d2                	test   %edx,%edx
80108e54:	0f 84 7e 00 00 00    	je     80108ed8 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108e5a:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108e60:	8b 56 04             	mov    0x4(%esi),%edx
80108e63:	85 d2                	test   %edx,%edx
80108e65:	74 71                	je     80108ed8 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80108e67:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
80108e6d:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108e71:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108e75:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108e78:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108e7a:	01 d8                	add    %ebx,%eax
80108e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80108e80:	8b 50 08             	mov    0x8(%eax),%edx
80108e83:	8b 00                	mov    (%eax),%eax
80108e85:	31 c9                	xor    %ecx,%ecx
80108e87:	e8 34 e6 ff ff       	call   801074c0 <walkpgdir>
80108e8c:	85 c0                	test   %eax,%eax
80108e8e:	89 c3                	mov    %eax,%ebx
80108e90:	74 5e                	je     80108ef0 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80108e92:	8b 00                	mov    (%eax),%eax
80108e94:	8b 56 04             	mov    0x4(%esi),%edx
80108e97:	a8 20                	test   $0x20,%al
80108e99:	74 23                	je     80108ebe <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
80108e9b:	85 d2                	test   %edx,%edx
80108e9d:	74 17                	je     80108eb6 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80108e9f:	8b 57 08             	mov    0x8(%edi),%edx
80108ea2:	8b 07                	mov    (%edi),%eax
80108ea4:	31 c9                	xor    %ecx,%ecx
80108ea6:	e8 15 e6 ff ff       	call   801074c0 <walkpgdir>
80108eab:	85 c0                	test   %eax,%eax
80108ead:	74 41                	je     80108ef0 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80108eaf:	f6 00 20             	testb  $0x20,(%eax)
80108eb2:	74 2c                	je     80108ee0 <updateAQ+0xa0>
80108eb4:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80108eb6:	83 e0 df             	and    $0xffffffdf,%eax
80108eb9:	89 03                	mov    %eax,(%ebx)
80108ebb:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80108ebe:	85 d2                	test   %edx,%edx
80108ec0:	74 16                	je     80108ed8 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80108ec2:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108ec6:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80108eca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80108ecd:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
80108ecf:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108ed1:	01 cf                	add    %ecx,%edi
80108ed3:	eb ab                	jmp    80108e80 <updateAQ+0x40>
80108ed5:	8d 76 00             	lea    0x0(%esi),%esi
}
80108ed8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108edb:	5b                   	pop    %ebx
80108edc:	5e                   	pop    %esi
80108edd:	5f                   	pop    %edi
80108ede:	5d                   	pop    %ebp
80108edf:	c3                   	ret    
          swapAQ(curr_node);
80108ee0:	83 ec 0c             	sub    $0xc,%esp
80108ee3:	56                   	push   %esi
80108ee4:	e8 b7 fe ff ff       	call   80108da0 <swapAQ>
80108ee9:	8b 03                	mov    (%ebx),%eax
80108eeb:	83 c4 10             	add    $0x10,%esp
80108eee:	eb c6                	jmp    80108eb6 <updateAQ+0x76>
      panic("updateAQ: no pte");
80108ef0:	83 ec 0c             	sub    $0xc,%esp
80108ef3:	68 c7 9b 10 80       	push   $0x80109bc7
80108ef8:	e8 93 74 ff ff       	call   80100390 <panic>
