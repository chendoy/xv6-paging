
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
8010004c:	68 20 8f 10 80       	push   $0x80108f20
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 85 50 00 00       	call   801050e0 <initlock>
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
80100092:	68 27 8f 10 80       	push   $0x80108f27
80100097:	50                   	push   %eax
80100098:	e8 13 4f 00 00       	call   80104fb0 <initsleeplock>
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
801000e4:	e8 37 51 00 00       	call   80105220 <acquire>
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
80100162:	e8 79 51 00 00       	call   801052e0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 7e 4e 00 00       	call   80104ff0 <acquiresleep>
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
80100193:	68 2e 8f 10 80       	push   $0x80108f2e
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
801001ae:	e8 dd 4e 00 00       	call   80105090 <holdingsleep>
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
801001cc:	68 3f 8f 10 80       	push   $0x80108f3f
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
801001ef:	e8 9c 4e 00 00       	call   80105090 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 4c 4e 00 00       	call   80105050 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 10 50 00 00       	call   80105220 <acquire>
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
8010025c:	e9 7f 50 00 00       	jmp    801052e0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 8f 10 80       	push   $0x80108f46
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
8010028c:	e8 8f 4f 00 00       	call   80105220 <acquire>
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
801002c5:	e8 06 48 00 00       	call   80104ad0 <sleep>
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
801002ef:	e8 ec 4f 00 00       	call   801052e0 <release>
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
8010034d:	e8 8e 4f 00 00       	call   801052e0 <release>
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
801003b2:	68 4d 8f 10 80       	push   $0x80108f4d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 9b 9b 10 80 	movl   $0x80109b9b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 23 4d 00 00       	call   80105100 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 8f 10 80       	push   $0x80108f61
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
8010043a:	e8 e1 65 00 00       	call   80106a20 <uartputc>
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
801004ec:	e8 2f 65 00 00       	call   80106a20 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 23 65 00 00       	call   80106a20 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 17 65 00 00       	call   80106a20 <uartputc>
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
80100524:	e8 b7 4e 00 00       	call   801053e0 <memmove>
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
80100541:	e8 ea 4d 00 00       	call   80105330 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 8f 10 80       	push   $0x80108f65
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
801005b1:	0f b6 92 90 8f 10 80 	movzbl -0x7fef7070(%edx),%edx
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
8010061b:	e8 00 4c 00 00       	call   80105220 <acquire>
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
80100647:	e8 94 4c 00 00       	call   801052e0 <release>
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
8010071f:	e8 bc 4b 00 00       	call   801052e0 <release>
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
801007d0:	ba 78 8f 10 80       	mov    $0x80108f78,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 2b 4a 00 00       	call   80105220 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 8f 10 80       	push   $0x80108f7f
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
80100823:	e8 f8 49 00 00       	call   80105220 <acquire>
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
80100888:	e8 53 4a 00 00       	call   801052e0 <release>
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
80100916:	e8 f5 43 00 00       	call   80104d10 <wakeup>
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
80100997:	e9 04 45 00 00       	jmp    80104ea0 <procdump>
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
801009c6:	68 88 8f 10 80       	push   $0x80108f88
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 0b 47 00 00       	call   801050e0 <initlock>

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
80100a2b:	e8 b0 49 00 00       	call   801053e0 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a30:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a36:	83 c4 0c             	add    $0xc,%esp
80100a39:	68 c0 01 00 00       	push   $0x1c0
80100a3e:	50                   	push   %eax
80100a3f:	68 c0 31 11 80       	push   $0x801131c0
80100a44:	e8 97 49 00 00       	call   801053e0 <memmove>
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
80100ac8:	e8 63 48 00 00       	call   80105330 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100acd:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ad3:	83 c4 0c             	add    $0xc,%esp
80100ad6:	68 c0 01 00 00       	push   $0x1c0
80100adb:	6a 00                	push   $0x0
80100add:	50                   	push   %eax
80100ade:	e8 4d 48 00 00       	call   80105330 <memset>
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
80100bb7:	68 a1 8f 10 80       	push   $0x80108fa1
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
80100c37:	68 a1 8f 10 80       	push   $0x80108fa1
80100c3c:	e8 1f fa ff ff       	call   80100660 <cprintf>
80100c41:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	eb ba                	jmp    80100c06 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	68 d0 8f 10 80       	push   $0x80108fd0
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
80100ccf:	68 c2 8f 10 80       	push   $0x80108fc2
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
80100d44:	e8 97 46 00 00       	call   801053e0 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d49:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d4f:	83 c4 0c             	add    $0xc,%esp
80100d52:	68 c0 01 00 00       	push   $0x1c0
80100d57:	68 c0 31 11 80       	push   $0x801131c0
80100d5c:	50                   	push   %eax
80100d5d:	e8 7e 46 00 00       	call   801053e0 <memmove>
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
80100dc0:	e8 6b 6f 00 00       	call   80107d30 <setupkvm>
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
80100e2e:	e8 1d 7a 00 00       	call   80108850 <allocuvm>
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
80100e60:	e8 0b 6b 00 00       	call   80107970 <loaduvm>
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
80100eaa:	68 c2 8f 10 80       	push   $0x80108fc2
80100eaf:	e8 ac f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100eb4:	58                   	pop    %eax
80100eb5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ebb:	e8 f0 6d 00 00       	call   80107cb0 <freevm>
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
80100f10:	e8 3b 79 00 00       	call   80108850 <allocuvm>
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
80100f3e:	e8 9d 6e 00 00       	call   80107de0 <clearpteu>
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
80100f8b:	e8 c0 45 00 00       	call   80105550 <strlen>
80100f90:	f7 d0                	not    %eax
80100f92:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f94:	58                   	pop    %eax
80100f95:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f98:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f9b:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f9e:	e8 ad 45 00 00       	call   80105550 <strlen>
80100fa3:	83 c0 01             	add    $0x1,%eax
80100fa6:	50                   	push   %eax
80100fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faa:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fad:	56                   	push   %esi
80100fae:	57                   	push   %edi
80100faf:	e8 fc 71 00 00       	call   801081b0 <copyout>
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
80100fd5:	68 b6 8f 10 80       	push   $0x80108fb6
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
80101029:	e8 82 71 00 00       	call   801081b0 <copyout>
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
80101061:	e8 aa 44 00 00       	call   80105510 <safestrcpy>
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
801010d2:	e8 09 67 00 00       	call   801077e0 <switchuvm>
  freevm(oldpgdir);
801010d7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 cb 6b 00 00       	call   80107cb0 <freevm>
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
80101116:	68 fb 8f 10 80       	push   $0x80108ffb
8010111b:	68 a0 33 11 80       	push   $0x801133a0
80101120:	e8 bb 3f 00 00       	call   801050e0 <initlock>
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
80101141:	e8 da 40 00 00       	call   80105220 <acquire>
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
80101171:	e8 6a 41 00 00       	call   801052e0 <release>
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
8010118a:	e8 51 41 00 00       	call   801052e0 <release>
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
801011af:	e8 6c 40 00 00       	call   80105220 <acquire>
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
801011cc:	e8 0f 41 00 00       	call   801052e0 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 02 90 10 80       	push   $0x80109002
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
80101201:	e8 1a 40 00 00       	call   80105220 <acquire>
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
8010122c:	e9 af 40 00 00       	jmp    801052e0 <release>
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
80101258:	e8 83 40 00 00       	call   801052e0 <release>
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
801012b2:	68 0a 90 10 80       	push   $0x8010900a
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
80101392:	68 14 90 10 80       	push   $0x80109014
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
801014a5:	68 1d 90 10 80       	push   $0x8010901d
801014aa:	e8 e1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 23 90 10 80       	push   $0x80109023
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
80101523:	68 2d 90 10 80       	push   $0x8010902d
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
801015d4:	68 40 90 10 80       	push   $0x80109040
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
80101615:	e8 16 3d 00 00       	call   80105330 <memset>
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
8010165a:	e8 c1 3b 00 00       	call   80105220 <acquire>
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
801016bf:	e8 1c 3c 00 00       	call   801052e0 <release>

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
801016ed:	e8 ee 3b 00 00       	call   801052e0 <release>
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
80101702:	68 56 90 10 80       	push   $0x80109056
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
801017d7:	68 66 90 10 80       	push   $0x80109066
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
80101811:	e8 ca 3b 00 00       	call   801053e0 <memmove>
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
8010183c:	68 79 90 10 80       	push   $0x80109079
80101841:	68 c0 3d 11 80       	push   $0x80113dc0
80101846:	e8 95 38 00 00       	call   801050e0 <initlock>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	68 80 90 10 80       	push   $0x80109080
80101858:	53                   	push   %ebx
80101859:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010185f:	e8 4c 37 00 00       	call   80104fb0 <initsleeplock>
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
801018a9:	68 2c 91 10 80       	push   $0x8010912c
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
8010193e:	e8 ed 39 00 00       	call   80105330 <memset>
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
80101973:	68 86 90 10 80       	push   $0x80109086
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
801019e1:	e8 fa 39 00 00       	call   801053e0 <memmove>
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
80101a0f:	e8 0c 38 00 00       	call   80105220 <acquire>
  ip->ref++;
80101a14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a18:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a1f:	e8 bc 38 00 00       	call   801052e0 <release>
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
80101a52:	e8 99 35 00 00       	call   80104ff0 <acquiresleep>
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
80101ac8:	e8 13 39 00 00       	call   801053e0 <memmove>
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
80101aed:	68 9e 90 10 80       	push   $0x8010909e
80101af2:	e8 99 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 98 90 10 80       	push   $0x80109098
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
80101b23:	e8 68 35 00 00       	call   80105090 <holdingsleep>
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
80101b3f:	e9 0c 35 00 00       	jmp    80105050 <releasesleep>
    panic("iunlock");
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 ad 90 10 80       	push   $0x801090ad
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
80101b70:	e8 7b 34 00 00       	call   80104ff0 <acquiresleep>
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
80101b8a:	e8 c1 34 00 00       	call   80105050 <releasesleep>
  acquire(&icache.lock);
80101b8f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101b96:	e8 85 36 00 00       	call   80105220 <acquire>
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
80101bb0:	e9 2b 37 00 00       	jmp    801052e0 <release>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bc0:	e8 5b 36 00 00       	call   80105220 <acquire>
    int r = ip->ref;
80101bc5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bc8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bcf:	e8 0c 37 00 00       	call   801052e0 <release>
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
80101db7:	e8 24 36 00 00       	call   801053e0 <memmove>
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
80101eb3:	e8 28 35 00 00       	call   801053e0 <memmove>
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
80101f4e:	e8 fd 34 00 00       	call   80105450 <strncmp>
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
80101fad:	e8 9e 34 00 00       	call   80105450 <strncmp>
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
80101ff2:	68 c7 90 10 80       	push   $0x801090c7
80101ff7:	e8 94 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	68 b5 90 10 80       	push   $0x801090b5
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
80102039:	e8 e2 31 00 00       	call   80105220 <acquire>
  ip->ref++;
8010203e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102042:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102049:	e8 92 32 00 00       	call   801052e0 <release>
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
801020a5:	e8 36 33 00 00       	call   801053e0 <memmove>
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
80102138:	e8 a3 32 00 00       	call   801053e0 <memmove>
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
8010222d:	e8 7e 32 00 00       	call   801054b0 <strncpy>
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
8010226b:	68 d6 90 10 80       	push   $0x801090d6
80102270:	e8 1b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 35 98 10 80       	push   $0x80109835
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
80102371:	68 e3 90 10 80       	push   $0x801090e3
80102376:	56                   	push   %esi
80102377:	e8 64 30 00 00       	call   801053e0 <memmove>
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
801023d2:	68 eb 90 10 80       	push   $0x801090eb
801023d7:	53                   	push   %ebx
801023d8:	e8 73 30 00 00       	call   80105450 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	85 c0                	test   %eax,%eax
801023e2:	0f 84 f8 00 00 00    	je     801024e0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023e8:	83 ec 04             	sub    $0x4,%esp
801023eb:	6a 0e                	push   $0xe
801023ed:	68 ea 90 10 80       	push   $0x801090ea
801023f2:	53                   	push   %ebx
801023f3:	e8 58 30 00 00       	call   80105450 <strncmp>
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
80102447:	e8 e4 2e 00 00       	call   80105330 <memset>
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
801024b4:	e8 57 36 00 00       	call   80105b10 <isdirempty>
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
8010253c:	68 ff 90 10 80       	push   $0x801090ff
80102541:	e8 4a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	68 ed 90 10 80       	push   $0x801090ed
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
80102570:	68 e3 90 10 80       	push   $0x801090e3
80102575:	56                   	push   %esi
80102576:	e8 65 2e 00 00       	call   801053e0 <memmove>
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
80102595:	e8 86 37 00 00       	call   80105d20 <create>
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
801025e9:	68 0e 91 10 80       	push   $0x8010910e
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
8010271b:	68 88 91 10 80       	push   $0x80109188
80102720:	e8 6b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102725:	83 ec 0c             	sub    $0xc,%esp
80102728:	68 7f 91 10 80       	push   $0x8010917f
8010272d:	e8 5e dc ff ff       	call   80100390 <panic>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <ideinit>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102746:	68 9a 91 10 80       	push   $0x8010919a
8010274b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102750:	e8 8b 29 00 00       	call   801050e0 <initlock>
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
801027ce:	e8 4d 2a 00 00       	call   80105220 <acquire>

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
80102831:	e8 da 24 00 00       	call   80104d10 <wakeup>

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
8010284f:	e8 8c 2a 00 00       	call   801052e0 <release>

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
8010286e:	e8 1d 28 00 00       	call   80105090 <holdingsleep>
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
801028a8:	e8 73 29 00 00       	call   80105220 <acquire>

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
801028f9:	e8 d2 21 00 00       	call   80104ad0 <sleep>
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
80102916:	e9 c5 29 00 00       	jmp    801052e0 <release>
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
8010293a:	68 b4 91 10 80       	push   $0x801091b4
8010293f:	e8 4c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 9e 91 10 80       	push   $0x8010919e
8010294c:	e8 3f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	68 c9 91 10 80       	push   $0x801091c9
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
801029a7:	68 e8 91 10 80       	push   $0x801091e8
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
80102a8d:	e8 9e 28 00 00       	call   80105330 <memset>

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
80102af3:	e9 e8 27 00 00       	jmp    801052e0 <release>
80102af8:	90                   	nop
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b00:	83 ec 0c             	sub    $0xc,%esp
80102b03:	68 20 5a 11 80       	push   $0x80115a20
80102b08:	e8 13 27 00 00       	call   80105220 <acquire>
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	eb 8d                	jmp    80102a9f <kfree+0x4f>
    panic("kfree");
80102b12:	83 ec 0c             	sub    $0xc,%esp
80102b15:	68 1a 92 10 80       	push   $0x8010921a
80102b1a:	e8 71 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b1f:	83 ec 0c             	sub    $0xc,%esp
80102b22:	68 20 92 10 80       	push   $0x80109220
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
80102b6d:	e8 be 27 00 00       	call   80105330 <memset>

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
80102bbe:	e8 5d 26 00 00       	call   80105220 <acquire>
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
80102bfd:	e9 de 26 00 00       	jmp    801052e0 <release>
    panic("kfree_nocheck");
80102c02:	83 ec 0c             	sub    $0xc,%esp
80102c05:	68 3d 92 10 80       	push   $0x8010923d
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
80102c6b:	68 4b 92 10 80       	push   $0x8010924b
80102c70:	68 20 5a 11 80       	push   $0x80115a20
80102c75:	e8 66 24 00 00       	call   801050e0 <initlock>
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
80102d7b:	e8 60 25 00 00       	call   801052e0 <release>
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
80102da0:	e8 7b 24 00 00       	call   80105220 <acquire>
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
80102dcb:	e8 10 25 00 00       	call   801052e0 <release>
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
80102e21:	e8 fa 23 00 00       	call   80105220 <acquire>
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
80102e45:	e9 96 24 00 00       	jmp    801052e0 <release>
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
80102e91:	e8 8a 23 00 00       	call   80105220 <acquire>
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
80102eb5:	e9 26 24 00 00       	jmp    801052e0 <release>
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
80102f23:	0f b6 82 80 93 10 80 	movzbl -0x7fef6c80(%edx),%eax
80102f2a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f2c:	0f b6 82 80 92 10 80 	movzbl -0x7fef6d80(%edx),%eax
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
80102f43:	8b 04 85 60 92 10 80 	mov    -0x7fef6da0(,%eax,4),%eax
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
80102f68:	0f b6 82 80 93 10 80 	movzbl -0x7fef6c80(%edx),%eax
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
801032e7:	e8 94 20 00 00       	call   80105380 <memcmp>
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
80103414:	e8 c7 1f 00 00       	call   801053e0 <memmove>
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
801034ba:	68 80 94 10 80       	push   $0x80109480
801034bf:	68 60 5a 18 80       	push   $0x80185a60
801034c4:	e8 17 1c 00 00       	call   801050e0 <initlock>
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
8010355b:	e8 c0 1c 00 00       	call   80105220 <acquire>
80103560:	83 c4 10             	add    $0x10,%esp
80103563:	eb 18                	jmp    8010357d <begin_op+0x2d>
80103565:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103568:	83 ec 08             	sub    $0x8,%esp
8010356b:	68 60 5a 18 80       	push   $0x80185a60
80103570:	68 60 5a 18 80       	push   $0x80185a60
80103575:	e8 56 15 00 00       	call   80104ad0 <sleep>
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
801035ac:	e8 2f 1d 00 00       	call   801052e0 <release>
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
801035ce:	e8 4d 1c 00 00       	call   80105220 <acquire>
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
8010360c:	e8 cf 1c 00 00       	call   801052e0 <release>
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
80103666:	e8 75 1d 00 00       	call   801053e0 <memmove>
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
801036af:	e8 6c 1b 00 00       	call   80105220 <acquire>
    wakeup(&log);
801036b4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036bb:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036c2:	00 00 00 
    wakeup(&log);
801036c5:	e8 46 16 00 00       	call   80104d10 <wakeup>
    release(&log.lock);
801036ca:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036d1:	e8 0a 1c 00 00       	call   801052e0 <release>
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
801036f0:	e8 1b 16 00 00       	call   80104d10 <wakeup>
  release(&log.lock);
801036f5:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036fc:	e8 df 1b 00 00       	call   801052e0 <release>
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
8010370f:	68 84 94 10 80       	push   $0x80109484
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
8010375e:	e8 bd 1a 00 00       	call   80105220 <acquire>
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
801037ad:	e9 2e 1b 00 00       	jmp    801052e0 <release>
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
801037d9:	68 93 94 10 80       	push   $0x80109493
801037de:	e8 ad cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037e3:	83 ec 0c             	sub    $0xc,%esp
801037e6:	68 a9 94 10 80       	push   $0x801094a9
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
80103808:	68 c4 94 10 80       	push   $0x801094c4
8010380d:	e8 4e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103812:	e8 09 2e 00 00       	call   80106620 <idtinit>
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
8010382a:	e8 91 0f 00 00       	call   801047c0 <scheduler>
8010382f:	90                   	nop

80103830 <mpenter>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103836:	e8 85 3f 00 00       	call   801077c0 <switchkvm>
  seginit();
8010383b:	e8 f0 3e 00 00       	call   80107730 <seginit>
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
80103871:	e8 4a 45 00 00       	call   80107dc0 <kvmalloc>
  mpinit();        // detect other processors
80103876:	e8 75 01 00 00       	call   801039f0 <mpinit>
  lapicinit();     // interrupt controller
8010387b:	e8 60 f7 ff ff       	call   80102fe0 <lapicinit>
  seginit();       // segment descriptors
80103880:	e8 ab 3e 00 00       	call   80107730 <seginit>
  picinit();       // disable pic
80103885:	e8 46 03 00 00       	call   80103bd0 <picinit>
  ioapicinit();    // another interrupt controller
8010388a:	e8 d1 f0 ff ff       	call   80102960 <ioapicinit>
  consoleinit();   // console hardware
8010388f:	e8 2c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103894:	e8 c7 30 00 00       	call   80106960 <uartinit>
  pinit();         // process table
80103899:	e8 62 09 00 00       	call   80104200 <pinit>
  tvinit();        // trap vectors
8010389e:	e8 fd 2c 00 00       	call   801065a0 <tvinit>
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
801038c4:	e8 17 1b 00 00       	call   801053e0 <memmove>

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
8010399e:	68 d8 94 10 80       	push   $0x801094d8
801039a3:	56                   	push   %esi
801039a4:	e8 d7 19 00 00       	call   80105380 <memcmp>
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
80103a5c:	68 f5 94 10 80       	push   $0x801094f5
80103a61:	56                   	push   %esi
80103a62:	e8 19 19 00 00       	call   80105380 <memcmp>
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
80103af0:	ff 24 95 1c 95 10 80 	jmp    *-0x7fef6ae4(,%edx,4)
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
80103ba3:	68 dd 94 10 80       	push   $0x801094dd
80103ba8:	e8 e3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bad:	83 ec 0c             	sub    $0xc,%esp
80103bb0:	68 fc 94 10 80       	push   $0x801094fc
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
80103cab:	68 30 95 10 80       	push   $0x80109530
80103cb0:	50                   	push   %eax
80103cb1:	e8 2a 14 00 00       	call   801050e0 <initlock>
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
80103d0f:	e8 0c 15 00 00       	call   80105220 <acquire>
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
80103d2f:	e8 dc 0f 00 00       	call   80104d10 <wakeup>
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
80103d54:	e9 87 15 00 00       	jmp    801052e0 <release>
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d60:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d66:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d70:	00 00 00 
    wakeup(&p->nwrite);
80103d73:	50                   	push   %eax
80103d74:	e8 97 0f 00 00       	call   80104d10 <wakeup>
80103d79:	83 c4 10             	add    $0x10,%esp
80103d7c:	eb b9                	jmp    80103d37 <pipeclose+0x37>
80103d7e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	53                   	push   %ebx
80103d84:	e8 57 15 00 00       	call   801052e0 <release>
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
80103dad:	e8 6e 14 00 00       	call   80105220 <acquire>
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
80103e04:	e8 07 0f 00 00       	call   80104d10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e09:	5a                   	pop    %edx
80103e0a:	59                   	pop    %ecx
80103e0b:	53                   	push   %ebx
80103e0c:	56                   	push   %esi
80103e0d:	e8 be 0c 00 00       	call   80104ad0 <sleep>
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
80103e44:	e8 97 14 00 00       	call   801052e0 <release>
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
80103e93:	e8 78 0e 00 00       	call   80104d10 <wakeup>
  release(&p->lock);
80103e98:	89 1c 24             	mov    %ebx,(%esp)
80103e9b:	e8 40 14 00 00       	call   801052e0 <release>
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
80103ec0:	e8 5b 13 00 00       	call   80105220 <acquire>
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
80103ef5:	e8 d6 0b 00 00       	call   80104ad0 <sleep>
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
80103f2e:	e8 ad 13 00 00       	call   801052e0 <release>
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
80103f87:	e8 84 0d 00 00       	call   80104d10 <wakeup>
  release(&p->lock);
80103f8c:	89 34 24             	mov    %esi,(%esp)
80103f8f:	e8 4c 13 00 00       	call   801052e0 <release>
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
80103fc3:	e8 58 12 00 00       	call   80105220 <acquire>
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
80104009:	e8 d2 12 00 00       	call   801052e0 <release>

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
80104032:	c7 40 14 91 65 10 80 	movl   $0x80106591,0x14(%eax)
  p->context = (struct context*)sp;
80104039:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010403c:	6a 14                	push   $0x14
8010403e:	6a 00                	push   $0x0
80104040:	50                   	push   %eax
80104041:	e8 ea 12 00 00       	call   80105330 <memset>
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
801040dd:	e8 4e 12 00 00       	call   80105330 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040e2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040e8:	83 c4 0c             	add    $0xc,%esp
801040eb:	68 c0 01 00 00       	push   $0x1c0
801040f0:	6a 00                	push   $0x0
801040f2:	50                   	push   %eax
801040f3:	e8 38 12 00 00       	call   80105330 <memset>
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
80104182:	e8 59 11 00 00       	call   801052e0 <release>
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
801041a5:	68 35 95 10 80       	push   $0x80109535
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
801041bb:	e8 20 11 00 00       	call   801052e0 <release>

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
80104206:	68 4f 95 10 80       	push   $0x8010954f
8010420b:	68 00 61 18 80       	push   $0x80186100
80104210:	e8 cb 0e 00 00       	call   801050e0 <initlock>
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
80104280:	68 56 95 10 80       	push   $0x80109556
80104285:	e8 06 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 44 96 10 80       	push   $0x80109644
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
801042c7:	e8 84 0e 00 00       	call   80105150 <pushcli>
  c = mycpu();
801042cc:	e8 4f ff ff ff       	call   80104220 <mycpu>
  p = c->proc;
801042d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d7:	e8 b4 0e 00 00       	call   80105190 <popcli>
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
80104303:	e8 28 3a 00 00       	call   80107d30 <setupkvm>
80104308:	85 c0                	test   %eax,%eax
8010430a:	89 43 04             	mov    %eax,0x4(%ebx)
8010430d:	0f 84 bd 00 00 00    	je     801043d0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104313:	83 ec 04             	sub    $0x4,%esp
80104316:	68 2c 00 00 00       	push   $0x2c
8010431b:	68 60 c4 10 80       	push   $0x8010c460
80104320:	50                   	push   %eax
80104321:	e8 ca 35 00 00       	call   801078f0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104326:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104329:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010432f:	6a 4c                	push   $0x4c
80104331:	6a 00                	push   $0x0
80104333:	ff 73 18             	pushl  0x18(%ebx)
80104336:	e8 f5 0f 00 00       	call   80105330 <memset>
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
8010438f:	68 7f 95 10 80       	push   $0x8010957f
80104394:	50                   	push   %eax
80104395:	e8 76 11 00 00       	call   80105510 <safestrcpy>
  p->cwd = namei("/");
8010439a:	c7 04 24 88 95 10 80 	movl   $0x80109588,(%esp)
801043a1:	e8 ea de ff ff       	call   80102290 <namei>
801043a6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043a9:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043b0:	e8 6b 0e 00 00       	call   80105220 <acquire>
  p->state = RUNNABLE;
801043b5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043bc:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043c3:	e8 18 0f 00 00       	call   801052e0 <release>
}
801043c8:	83 c4 10             	add    $0x10,%esp
801043cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ce:	c9                   	leave  
801043cf:	c3                   	ret    
    panic("userinit: out of memory?");
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 66 95 10 80       	push   $0x80109566
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
801043eb:	e8 60 0d 00 00       	call   80105150 <pushcli>
  c = mycpu();
801043f0:	e8 2b fe ff ff       	call   80104220 <mycpu>
  p = c->proc;
801043f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043fb:	e8 90 0d 00 00       	call   80105190 <popcli>
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
8010440f:	e8 cc 33 00 00       	call   801077e0 <switchuvm>
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
8010442a:	e8 21 44 00 00       	call   80108850 <allocuvm>
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
80104446:	68 8a 95 10 80       	push   $0x8010958a
8010444b:	e8 10 c2 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	83 c4 0c             	add    $0xc,%esp
80104456:	01 c6                	add    %eax,%esi
80104458:	56                   	push   %esi
80104459:	50                   	push   %eax
8010445a:	ff 73 04             	pushl  0x4(%ebx)
8010445d:	e8 2e 36 00 00       	call   80107a90 <deallocuvm>
80104462:	83 c4 10             	add    $0x10,%esp
80104465:	85 c0                	test   %eax,%eax
80104467:	75 a0                	jne    80104409 <growproc+0x29>
80104469:	eb cb                	jmp    80104436 <growproc+0x56>
8010446b:	90                   	nop
8010446c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104470 <copyAQ>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	56                   	push   %esi
80104475:	53                   	push   %ebx
80104476:	83 ec 0c             	sub    $0xc,%esp
80104479:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010447c:	e8 cf 0c 00 00       	call   80105150 <pushcli>
  c = mycpu();
80104481:	e8 9a fd ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104486:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448c:	e8 ff 0c 00 00       	call   80105190 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
80104491:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
80104497:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
8010449e:	00 00 00 
  np->queue_tail = 0;
801044a1:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
801044a8:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
801044ab:	85 db                	test   %ebx,%ebx
801044ad:	74 4f                	je     801044fe <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
801044af:	e8 7c e8 ff ff       	call   80102d30 <kalloc>
801044b4:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
801044b6:	8b 43 08             	mov    0x8(%ebx),%eax
801044b9:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
801044bc:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
801044c2:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
801044c9:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801044cb:	85 db                	test   %ebx,%ebx
801044cd:	74 37                	je     80104506 <copyAQ+0x96>
801044cf:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
801044d0:	e8 5b e8 ff ff       	call   80102d30 <kalloc>
    np_curr->page_index = old_curr->page_index;
801044d5:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
801044d8:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
801044db:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
801044de:	89 07                	mov    %eax,(%edi)
801044e0:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
801044e2:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801044e4:	85 db                	test   %ebx,%ebx
801044e6:	75 e8                	jne    801044d0 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
801044e8:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
801044ee:	85 d2                	test   %edx,%edx
801044f0:	74 0c                	je     801044fe <copyAQ+0x8e>
    np_curr->next = 0;
801044f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
801044f8:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
801044fe:	83 c4 0c             	add    $0xc,%esp
80104501:	5b                   	pop    %ebx
80104502:	5e                   	pop    %esi
80104503:	5f                   	pop    %edi
80104504:	5d                   	pop    %ebp
80104505:	c3                   	ret    
  while(old_curr != 0)
80104506:	89 f8                	mov    %edi,%eax
80104508:	eb de                	jmp    801044e8 <copyAQ+0x78>
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <fork>:
{ 
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	53                   	push   %ebx
80104516:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010451c:	e8 2f 0c 00 00       	call   80105150 <pushcli>
  c = mycpu();
80104521:	e8 fa fc ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104526:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
8010452c:	89 b5 e4 f7 ff ff    	mov    %esi,-0x81c(%ebp)
  popcli();
80104532:	e8 59 0c 00 00       	call   80105190 <popcli>
  if((np = allocproc()) == 0){
80104537:	e8 74 fa ff ff       	call   80103fb0 <allocproc>
8010453c:	85 c0                	test   %eax,%eax
8010453e:	89 85 e0 f7 ff ff    	mov    %eax,-0x820(%ebp)
80104544:	0f 84 48 02 00 00    	je     80104792 <fork+0x282>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010454a:	83 ec 08             	sub    $0x8,%esp
8010454d:	ff 36                	pushl  (%esi)
8010454f:	ff 76 04             	pushl  0x4(%esi)
80104552:	89 c3                	mov    %eax,%ebx
80104554:	e8 c7 3a 00 00       	call   80108020 <copyuvm>
  if(np->pgdir == 0){
80104559:	83 c4 10             	add    $0x10,%esp
8010455c:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010455e:	89 43 04             	mov    %eax,0x4(%ebx)
  if(np->pgdir == 0){
80104561:	0f 84 32 02 00 00    	je     80104799 <fork+0x289>
  np->sz = curproc->sz;
80104567:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
8010456d:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
80104573:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80104575:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104578:	89 51 14             	mov    %edx,0x14(%ecx)
  np->sz = curproc->sz;
8010457b:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010457d:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
8010457f:	8b 72 18             	mov    0x18(%edx),%esi
80104582:	b9 13 00 00 00       	mov    $0x13,%ecx
80104587:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
80104589:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
8010458d:	0f 8e 1c 01 00 00    	jle    801046af <fork+0x19f>
    np->totalPgfltCount = 0;
80104593:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
8010459a:	00 00 00 
    np->totalPgoutCount = 0;
8010459d:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801045a4:	00 00 00 
    np->totalPgfltCount = 0;
801045a7:	89 c1                	mov    %eax,%ecx
    np->num_ram = curproc->num_ram;
801045a9:	8b 82 08 04 00 00    	mov    0x408(%edx),%eax
801045af:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
    np->num_swap = curproc->num_swap;
801045b5:	8b 82 0c 04 00 00    	mov    0x40c(%edx),%eax
801045bb:	89 81 0c 04 00 00    	mov    %eax,0x40c(%ecx)
      if(curproc->ramPages[i].isused)
801045c1:	8b 9a 4c 02 00 00    	mov    0x24c(%edx),%ebx
801045c7:	85 db                	test   %ebx,%ebx
801045c9:	0f 85 86 01 00 00    	jne    80104755 <fork+0x245>
801045cf:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
{ 
801045d5:	c7 85 dc f7 ff ff 00 	movl   $0x0,-0x824(%ebp)
801045dc:	00 00 00 
801045df:	90                   	nop
      if(curproc->swappedPages[i].isused)
801045e0:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801045e6:	8b 95 dc f7 ff ff    	mov    -0x824(%ebp),%edx
801045ec:	8b 84 11 8c 00 00 00 	mov    0x8c(%ecx,%edx,1),%eax
801045f3:	85 c0                	test   %eax,%eax
801045f5:	74 45                	je     8010463c <fork+0x12c>
      np->swappedPages[i].isused = 1;
801045f7:	8b bd e0 f7 ff ff    	mov    -0x820(%ebp),%edi
801045fd:	c7 84 17 8c 00 00 00 	movl   $0x1,0x8c(%edi,%edx,1)
80104604:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104608:	8b 84 11 90 00 00 00 	mov    0x90(%ecx,%edx,1),%eax
8010460f:	89 84 17 90 00 00 00 	mov    %eax,0x90(%edi,%edx,1)
      np->swappedPages[i].pgdir = np->pgdir;
80104616:	8b 47 04             	mov    0x4(%edi),%eax
80104619:	89 84 17 88 00 00 00 	mov    %eax,0x88(%edi,%edx,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104620:	8b 84 11 94 00 00 00 	mov    0x94(%ecx,%edx,1),%eax
80104627:	89 84 17 94 00 00 00 	mov    %eax,0x94(%edi,%edx,1)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
8010462e:	8b 84 11 98 00 00 00 	mov    0x98(%ecx,%edx,1),%eax
80104635:	89 84 17 98 00 00 00 	mov    %eax,0x98(%edi,%edx,1)
        char buffer[PGSIZE / 2] = "";
8010463c:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104642:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104647:	31 c0                	xor    %eax,%eax
80104649:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104650:	00 00 00 
80104653:	f3 ab                	rep stos %eax,%es:(%edi)
        int offset = 0;
80104655:	31 ff                	xor    %edi,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
80104657:	eb 23                	jmp    8010467c <fork+0x16c>
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
80104660:	53                   	push   %ebx
80104661:	57                   	push   %edi
80104662:	56                   	push   %esi
80104663:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
80104669:	e8 92 df ff ff       	call   80102600 <writeToSwapFile>
8010466e:	83 c4 10             	add    $0x10,%esp
80104671:	83 f8 ff             	cmp    $0xffffffff,%eax
80104674:	0f 84 0b 01 00 00    	je     80104785 <fork+0x275>
        offset += nread;
8010467a:	01 df                	add    %ebx,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
8010467c:	68 00 08 00 00       	push   $0x800
80104681:	57                   	push   %edi
80104682:	56                   	push   %esi
80104683:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
80104689:	e8 a2 df ff ff       	call   80102630 <readFromSwapFile>
8010468e:	83 c4 10             	add    $0x10,%esp
80104691:	85 c0                	test   %eax,%eax
80104693:	89 c3                	mov    %eax,%ebx
80104695:	75 c9                	jne    80104660 <fork+0x150>
80104697:	83 85 dc f7 ff ff 1c 	addl   $0x1c,-0x824(%ebp)
8010469e:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801046a4:	3d c0 01 00 00       	cmp    $0x1c0,%eax
801046a9:	0f 85 31 ff ff ff    	jne    801045e0 <fork+0xd0>
  np->tf->eax = 0;
801046af:	8b bd e0 f7 ff ff    	mov    -0x820(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
801046b5:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
801046bb:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801046bd:	8b 47 18             	mov    0x18(%edi),%eax
801046c0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801046c7:	89 f6                	mov    %esi,%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
801046d0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801046d4:	85 c0                	test   %eax,%eax
801046d6:	74 10                	je     801046e8 <fork+0x1d8>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046d8:	83 ec 0c             	sub    $0xc,%esp
801046db:	50                   	push   %eax
801046dc:	e8 bf ca ff ff       	call   801011a0 <filedup>
801046e1:	83 c4 10             	add    $0x10,%esp
801046e4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
801046e8:	83 c6 01             	add    $0x1,%esi
801046eb:	83 fe 10             	cmp    $0x10,%esi
801046ee:	75 e0                	jne    801046d0 <fork+0x1c0>
  np->cwd = idup(curproc->cwd);
801046f0:	8b b5 e4 f7 ff ff    	mov    -0x81c(%ebp),%esi
801046f6:	83 ec 0c             	sub    $0xc,%esp
801046f9:	ff 76 68             	pushl  0x68(%esi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801046fc:	8d 5e 6c             	lea    0x6c(%esi),%ebx
  np->cwd = idup(curproc->cwd);
801046ff:	e8 fc d2 ff ff       	call   80101a00 <idup>
80104704:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010470a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010470d:	89 41 68             	mov    %eax,0x68(%ecx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104710:	8d 41 6c             	lea    0x6c(%ecx),%eax
80104713:	6a 10                	push   $0x10
80104715:	53                   	push   %ebx
80104716:	89 ce                	mov    %ecx,%esi
80104718:	50                   	push   %eax
80104719:	e8 f2 0d 00 00       	call   80105510 <safestrcpy>
  pid = np->pid;
8010471e:	8b 5e 10             	mov    0x10(%esi),%ebx
  copyAQ(np);
80104721:	89 34 24             	mov    %esi,(%esp)
80104724:	e8 47 fd ff ff       	call   80104470 <copyAQ>
  acquire(&ptable.lock);
80104729:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104730:	e8 eb 0a 00 00       	call   80105220 <acquire>
  np->state = RUNNABLE;
80104735:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
8010473c:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104743:	e8 98 0b 00 00       	call   801052e0 <release>
  return pid;
80104748:	83 c4 10             	add    $0x10,%esp
}
8010474b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474e:	89 d8                	mov    %ebx,%eax
80104750:	5b                   	pop    %ebx
80104751:	5e                   	pop    %esi
80104752:	5f                   	pop    %edi
80104753:	5d                   	pop    %ebp
80104754:	c3                   	ret    
        np->ramPages[i].isused = 1;
80104755:	c7 81 4c 02 00 00 01 	movl   $0x1,0x24c(%ecx)
8010475c:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010475f:	8b 82 50 02 00 00    	mov    0x250(%edx),%eax
80104765:	89 81 50 02 00 00    	mov    %eax,0x250(%ecx)
        np->ramPages[i].pgdir = np->pgdir;
8010476b:	8b 41 04             	mov    0x4(%ecx),%eax
8010476e:	89 81 48 02 00 00    	mov    %eax,0x248(%ecx)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104774:	8b 82 58 02 00 00    	mov    0x258(%edx),%eax
8010477a:	89 81 58 02 00 00    	mov    %eax,0x258(%ecx)
80104780:	e9 4a fe ff ff       	jmp    801045cf <fork+0xbf>
          panic("fork: error copying parent's swap file");
80104785:	83 ec 0c             	sub    $0xc,%esp
80104788:	68 6c 96 10 80       	push   $0x8010966c
8010478d:	e8 fe bb ff ff       	call   80100390 <panic>
    return -1;
80104792:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104797:	eb b2                	jmp    8010474b <fork+0x23b>
    kfree(np->kstack);
80104799:	8b b5 e0 f7 ff ff    	mov    -0x820(%ebp),%esi
8010479f:	83 ec 0c             	sub    $0xc,%esp
    return -1;
801047a2:	83 cb ff             	or     $0xffffffff,%ebx
    kfree(np->kstack);
801047a5:	ff 76 08             	pushl  0x8(%esi)
801047a8:	e8 a3 e2 ff ff       	call   80102a50 <kfree>
    np->kstack = 0;
801047ad:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    np->state = UNUSED;
801047b4:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return -1;
801047bb:	83 c4 10             	add    $0x10,%esp
801047be:	eb 8b                	jmp    8010474b <fork+0x23b>

801047c0 <scheduler>:
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	57                   	push   %edi
801047c4:	56                   	push   %esi
801047c5:	53                   	push   %ebx
801047c6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047c9:	e8 52 fa ff ff       	call   80104220 <mycpu>
801047ce:	8d 78 04             	lea    0x4(%eax),%edi
801047d1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801047d3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047da:	00 00 00 
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801047e0:	fb                   	sti    
    acquire(&ptable.lock);
801047e1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e4:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
801047e9:	68 00 61 18 80       	push   $0x80186100
801047ee:	e8 2d 0a 00 00       	call   80105220 <acquire>
801047f3:	83 c4 10             	add    $0x10,%esp
801047f6:	8d 76 00             	lea    0x0(%esi),%esi
801047f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104800:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104804:	75 33                	jne    80104839 <scheduler+0x79>
      switchuvm(p);
80104806:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104809:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010480f:	53                   	push   %ebx
80104810:	e8 cb 2f 00 00       	call   801077e0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104815:	58                   	pop    %eax
80104816:	5a                   	pop    %edx
80104817:	ff 73 1c             	pushl  0x1c(%ebx)
8010481a:	57                   	push   %edi
      p->state = RUNNING;
8010481b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104822:	e8 44 0d 00 00       	call   8010556b <swtch>
      switchkvm();
80104827:	e8 94 2f 00 00       	call   801077c0 <switchkvm>
      c->proc = 0;
8010482c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104833:	00 00 00 
80104836:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104839:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010483f:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104845:	72 b9                	jb     80104800 <scheduler+0x40>
    release(&ptable.lock);
80104847:	83 ec 0c             	sub    $0xc,%esp
8010484a:	68 00 61 18 80       	push   $0x80186100
8010484f:	e8 8c 0a 00 00       	call   801052e0 <release>
    sti();
80104854:	83 c4 10             	add    $0x10,%esp
80104857:	eb 87                	jmp    801047e0 <scheduler+0x20>
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104860 <sched>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
  pushcli();
80104865:	e8 e6 08 00 00       	call   80105150 <pushcli>
  c = mycpu();
8010486a:	e8 b1 f9 ff ff       	call   80104220 <mycpu>
  p = c->proc;
8010486f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104875:	e8 16 09 00 00       	call   80105190 <popcli>
  if(!holding(&ptable.lock))
8010487a:	83 ec 0c             	sub    $0xc,%esp
8010487d:	68 00 61 18 80       	push   $0x80186100
80104882:	e8 69 09 00 00       	call   801051f0 <holding>
80104887:	83 c4 10             	add    $0x10,%esp
8010488a:	85 c0                	test   %eax,%eax
8010488c:	74 4f                	je     801048dd <sched+0x7d>
  if(mycpu()->ncli != 1)
8010488e:	e8 8d f9 ff ff       	call   80104220 <mycpu>
80104893:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010489a:	75 68                	jne    80104904 <sched+0xa4>
  if(p->state == RUNNING)
8010489c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801048a0:	74 55                	je     801048f7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048a2:	9c                   	pushf  
801048a3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048a4:	f6 c4 02             	test   $0x2,%ah
801048a7:	75 41                	jne    801048ea <sched+0x8a>
  intena = mycpu()->intena;
801048a9:	e8 72 f9 ff ff       	call   80104220 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801048ae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801048b1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801048b7:	e8 64 f9 ff ff       	call   80104220 <mycpu>
801048bc:	83 ec 08             	sub    $0x8,%esp
801048bf:	ff 70 04             	pushl  0x4(%eax)
801048c2:	53                   	push   %ebx
801048c3:	e8 a3 0c 00 00       	call   8010556b <swtch>
  mycpu()->intena = intena;
801048c8:	e8 53 f9 ff ff       	call   80104220 <mycpu>
}
801048cd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048d0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
    panic("sched ptable.lock");
801048dd:	83 ec 0c             	sub    $0xc,%esp
801048e0:	68 9b 95 10 80       	push   $0x8010959b
801048e5:	e8 a6 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801048ea:	83 ec 0c             	sub    $0xc,%esp
801048ed:	68 c7 95 10 80       	push   $0x801095c7
801048f2:	e8 99 ba ff ff       	call   80100390 <panic>
    panic("sched running");
801048f7:	83 ec 0c             	sub    $0xc,%esp
801048fa:	68 b9 95 10 80       	push   $0x801095b9
801048ff:	e8 8c ba ff ff       	call   80100390 <panic>
    panic("sched locks");
80104904:	83 ec 0c             	sub    $0xc,%esp
80104907:	68 ad 95 10 80       	push   $0x801095ad
8010490c:	e8 7f ba ff ff       	call   80100390 <panic>
80104911:	eb 0d                	jmp    80104920 <exit>
80104913:	90                   	nop
80104914:	90                   	nop
80104915:	90                   	nop
80104916:	90                   	nop
80104917:	90                   	nop
80104918:	90                   	nop
80104919:	90                   	nop
8010491a:	90                   	nop
8010491b:	90                   	nop
8010491c:	90                   	nop
8010491d:	90                   	nop
8010491e:	90                   	nop
8010491f:	90                   	nop

80104920 <exit>:
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	56                   	push   %esi
80104925:	53                   	push   %ebx
80104926:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104929:	e8 22 08 00 00       	call   80105150 <pushcli>
  c = mycpu();
8010492e:	e8 ed f8 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104933:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104939:	e8 52 08 00 00       	call   80105190 <popcli>
  if(curproc == initproc)
8010493e:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
80104944:	8d 73 28             	lea    0x28(%ebx),%esi
80104947:	8d 7b 68             	lea    0x68(%ebx),%edi
8010494a:	0f 84 22 01 00 00    	je     80104a72 <exit+0x152>
    if(curproc->ofile[fd]){
80104950:	8b 06                	mov    (%esi),%eax
80104952:	85 c0                	test   %eax,%eax
80104954:	74 12                	je     80104968 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104956:	83 ec 0c             	sub    $0xc,%esp
80104959:	50                   	push   %eax
8010495a:	e8 91 c8 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
8010495f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104965:	83 c4 10             	add    $0x10,%esp
80104968:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010496b:	39 fe                	cmp    %edi,%esi
8010496d:	75 e1                	jne    80104950 <exit+0x30>
  begin_op();
8010496f:	e8 dc eb ff ff       	call   80103550 <begin_op>
  iput(curproc->cwd);
80104974:	83 ec 0c             	sub    $0xc,%esp
80104977:	ff 73 68             	pushl  0x68(%ebx)
8010497a:	e8 e1 d1 ff ff       	call   80101b60 <iput>
  end_op();
8010497f:	e8 3c ec ff ff       	call   801035c0 <end_op>
  if(curproc->pid > 2) {
80104984:	83 c4 10             	add    $0x10,%esp
80104987:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
8010498b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
80104992:	0f 8f b9 00 00 00    	jg     80104a51 <exit+0x131>
  acquire(&ptable.lock);
80104998:	83 ec 0c             	sub    $0xc,%esp
8010499b:	68 00 61 18 80       	push   $0x80186100
801049a0:	e8 7b 08 00 00       	call   80105220 <acquire>
  wakeup1(curproc->parent);
801049a5:	8b 53 14             	mov    0x14(%ebx),%edx
801049a8:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049ab:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049b0:	eb 12                	jmp    801049c4 <exit+0xa4>
801049b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049b8:	05 30 04 00 00       	add    $0x430,%eax
801049bd:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049c2:	73 1e                	jae    801049e2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
801049c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049c8:	75 ee                	jne    801049b8 <exit+0x98>
801049ca:	3b 50 20             	cmp    0x20(%eax),%edx
801049cd:	75 e9                	jne    801049b8 <exit+0x98>
      p->state = RUNNABLE;
801049cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049d6:	05 30 04 00 00       	add    $0x430,%eax
801049db:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049e0:	72 e2                	jb     801049c4 <exit+0xa4>
      p->parent = initproc;
801049e2:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049e8:	ba 34 61 18 80       	mov    $0x80186134,%edx
801049ed:	eb 0f                	jmp    801049fe <exit+0xde>
801049ef:	90                   	nop
801049f0:	81 c2 30 04 00 00    	add    $0x430,%edx
801049f6:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
801049fc:	73 3a                	jae    80104a38 <exit+0x118>
    if(p->parent == curproc){
801049fe:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104a01:	75 ed                	jne    801049f0 <exit+0xd0>
      if(p->state == ZOMBIE)
80104a03:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104a07:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104a0a:	75 e4                	jne    801049f0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a0c:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104a11:	eb 11                	jmp    80104a24 <exit+0x104>
80104a13:	90                   	nop
80104a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a18:	05 30 04 00 00       	add    $0x430,%eax
80104a1d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a22:	73 cc                	jae    801049f0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104a24:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a28:	75 ee                	jne    80104a18 <exit+0xf8>
80104a2a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a2d:	75 e9                	jne    80104a18 <exit+0xf8>
      p->state = RUNNABLE;
80104a2f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a36:	eb e0                	jmp    80104a18 <exit+0xf8>
  curproc->state = ZOMBIE;
80104a38:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104a3f:	e8 1c fe ff ff       	call   80104860 <sched>
  panic("zombie exit");
80104a44:	83 ec 0c             	sub    $0xc,%esp
80104a47:	68 e8 95 10 80       	push   $0x801095e8
80104a4c:	e8 3f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a51:	83 ec 0c             	sub    $0xc,%esp
80104a54:	53                   	push   %ebx
80104a55:	e8 06 d9 ff ff       	call   80102360 <removeSwapFile>
80104a5a:	83 c4 10             	add    $0x10,%esp
80104a5d:	85 c0                	test   %eax,%eax
80104a5f:	0f 84 33 ff ff ff    	je     80104998 <exit+0x78>
      panic("exit: error deleting swap file");
80104a65:	83 ec 0c             	sub    $0xc,%esp
80104a68:	68 94 96 10 80       	push   $0x80109694
80104a6d:	e8 1e b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a72:	83 ec 0c             	sub    $0xc,%esp
80104a75:	68 db 95 10 80       	push   $0x801095db
80104a7a:	e8 11 b9 ff ff       	call   80100390 <panic>
80104a7f:	90                   	nop

80104a80 <yield>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	53                   	push   %ebx
80104a84:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a87:	68 00 61 18 80       	push   $0x80186100
80104a8c:	e8 8f 07 00 00       	call   80105220 <acquire>
  pushcli();
80104a91:	e8 ba 06 00 00       	call   80105150 <pushcli>
  c = mycpu();
80104a96:	e8 85 f7 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104a9b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aa1:	e8 ea 06 00 00       	call   80105190 <popcli>
  myproc()->state = RUNNABLE;
80104aa6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104aad:	e8 ae fd ff ff       	call   80104860 <sched>
  release(&ptable.lock);
80104ab2:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104ab9:	e8 22 08 00 00       	call   801052e0 <release>
}
80104abe:	83 c4 10             	add    $0x10,%esp
80104ac1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac4:	c9                   	leave  
80104ac5:	c3                   	ret    
80104ac6:	8d 76 00             	lea    0x0(%esi),%esi
80104ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ad0 <sleep>:
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	57                   	push   %edi
80104ad4:	56                   	push   %esi
80104ad5:	53                   	push   %ebx
80104ad6:	83 ec 0c             	sub    $0xc,%esp
80104ad9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104adc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104adf:	e8 6c 06 00 00       	call   80105150 <pushcli>
  c = mycpu();
80104ae4:	e8 37 f7 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104ae9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aef:	e8 9c 06 00 00       	call   80105190 <popcli>
  if(p == 0)
80104af4:	85 db                	test   %ebx,%ebx
80104af6:	0f 84 87 00 00 00    	je     80104b83 <sleep+0xb3>
  if(lk == 0)
80104afc:	85 f6                	test   %esi,%esi
80104afe:	74 76                	je     80104b76 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b00:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104b06:	74 50                	je     80104b58 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	68 00 61 18 80       	push   $0x80186100
80104b10:	e8 0b 07 00 00       	call   80105220 <acquire>
    release(lk);
80104b15:	89 34 24             	mov    %esi,(%esp)
80104b18:	e8 c3 07 00 00       	call   801052e0 <release>
  p->chan = chan;
80104b1d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b20:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b27:	e8 34 fd ff ff       	call   80104860 <sched>
  p->chan = 0;
80104b2c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b33:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104b3a:	e8 a1 07 00 00       	call   801052e0 <release>
    acquire(lk);
80104b3f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b42:	83 c4 10             	add    $0x10,%esp
}
80104b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b48:	5b                   	pop    %ebx
80104b49:	5e                   	pop    %esi
80104b4a:	5f                   	pop    %edi
80104b4b:	5d                   	pop    %ebp
    acquire(lk);
80104b4c:	e9 cf 06 00 00       	jmp    80105220 <acquire>
80104b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b58:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b5b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b62:	e8 f9 fc ff ff       	call   80104860 <sched>
  p->chan = 0;
80104b67:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b71:	5b                   	pop    %ebx
80104b72:	5e                   	pop    %esi
80104b73:	5f                   	pop    %edi
80104b74:	5d                   	pop    %ebp
80104b75:	c3                   	ret    
    panic("sleep without lk");
80104b76:	83 ec 0c             	sub    $0xc,%esp
80104b79:	68 fa 95 10 80       	push   $0x801095fa
80104b7e:	e8 0d b8 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b83:	83 ec 0c             	sub    $0xc,%esp
80104b86:	68 f4 95 10 80       	push   $0x801095f4
80104b8b:	e8 00 b8 ff ff       	call   80100390 <panic>

80104b90 <wait>:
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
  pushcli();
80104b95:	e8 b6 05 00 00       	call   80105150 <pushcli>
  c = mycpu();
80104b9a:	e8 81 f6 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104b9f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104ba5:	e8 e6 05 00 00       	call   80105190 <popcli>
  acquire(&ptable.lock);
80104baa:	83 ec 0c             	sub    $0xc,%esp
80104bad:	68 00 61 18 80       	push   $0x80186100
80104bb2:	e8 69 06 00 00       	call   80105220 <acquire>
80104bb7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104bba:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bbc:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104bc1:	eb 13                	jmp    80104bd6 <wait+0x46>
80104bc3:	90                   	nop
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bc8:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104bce:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104bd4:	73 1e                	jae    80104bf4 <wait+0x64>
      if(p->parent != curproc)
80104bd6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104bd9:	75 ed                	jne    80104bc8 <wait+0x38>
      if(p->state == ZOMBIE){
80104bdb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104bdf:	74 3f                	je     80104c20 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104be1:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104be7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bec:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104bf2:	72 e2                	jb     80104bd6 <wait+0x46>
    if(!havekids || curproc->killed){
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	0f 84 f3 00 00 00    	je     80104cef <wait+0x15f>
80104bfc:	8b 46 24             	mov    0x24(%esi),%eax
80104bff:	85 c0                	test   %eax,%eax
80104c01:	0f 85 e8 00 00 00    	jne    80104cef <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c07:	83 ec 08             	sub    $0x8,%esp
80104c0a:	68 00 61 18 80       	push   $0x80186100
80104c0f:	56                   	push   %esi
80104c10:	e8 bb fe ff ff       	call   80104ad0 <sleep>
    havekids = 0;
80104c15:	83 c4 10             	add    $0x10,%esp
80104c18:	eb a0                	jmp    80104bba <wait+0x2a>
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104c20:	83 ec 0c             	sub    $0xc,%esp
80104c23:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104c26:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104c29:	e8 22 de ff ff       	call   80102a50 <kfree>
        freevm(p->pgdir); // panic: kfree
80104c2e:	5a                   	pop    %edx
80104c2f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104c39:	e8 72 30 00 00       	call   80107cb0 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c3e:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104c44:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104c47:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c4e:	68 c0 01 00 00       	push   $0x1c0
80104c53:	6a 00                	push   $0x0
80104c55:	50                   	push   %eax
        p->parent = 0;
80104c56:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c5d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c61:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c68:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c6f:	00 00 00 
        p->swapFile = 0;
80104c72:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104c79:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104c80:	00 00 00 
        p->free_tail = 0;
80104c83:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104c8a:	00 00 00 
        p->queue_head = 0;
80104c8d:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104c94:	00 00 00 
        p->queue_tail = 0;
80104c97:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104c9e:	00 00 00 
        p->numswappages = 0;
80104ca1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104ca8:	00 00 00 
        p-> nummemorypages = 0;
80104cab:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104cb2:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104cb5:	e8 76 06 00 00       	call   80105330 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104cba:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104cc0:	83 c4 0c             	add    $0xc,%esp
80104cc3:	68 c0 01 00 00       	push   $0x1c0
80104cc8:	6a 00                	push   $0x0
80104cca:	50                   	push   %eax
80104ccb:	e8 60 06 00 00       	call   80105330 <memset>
        release(&ptable.lock);
80104cd0:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104cd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104cde:	e8 fd 05 00 00       	call   801052e0 <release>
        return pid;
80104ce3:	83 c4 10             	add    $0x10,%esp
}
80104ce6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ce9:	89 f0                	mov    %esi,%eax
80104ceb:	5b                   	pop    %ebx
80104cec:	5e                   	pop    %esi
80104ced:	5d                   	pop    %ebp
80104cee:	c3                   	ret    
      release(&ptable.lock);
80104cef:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104cf2:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104cf7:	68 00 61 18 80       	push   $0x80186100
80104cfc:	e8 df 05 00 00       	call   801052e0 <release>
      return -1;
80104d01:	83 c4 10             	add    $0x10,%esp
80104d04:	eb e0                	jmp    80104ce6 <wait+0x156>
80104d06:	8d 76 00             	lea    0x0(%esi),%esi
80104d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	53                   	push   %ebx
80104d14:	83 ec 10             	sub    $0x10,%esp
80104d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104d1a:	68 00 61 18 80       	push   $0x80186100
80104d1f:	e8 fc 04 00 00       	call   80105220 <acquire>
80104d24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d27:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d2c:	eb 0e                	jmp    80104d3c <wakeup+0x2c>
80104d2e:	66 90                	xchg   %ax,%ax
80104d30:	05 30 04 00 00       	add    $0x430,%eax
80104d35:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d3a:	73 1e                	jae    80104d5a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d3c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d40:	75 ee                	jne    80104d30 <wakeup+0x20>
80104d42:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d45:	75 e9                	jne    80104d30 <wakeup+0x20>
      p->state = RUNNABLE;
80104d47:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d4e:	05 30 04 00 00       	add    $0x430,%eax
80104d53:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d58:	72 e2                	jb     80104d3c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d5a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d64:	c9                   	leave  
  release(&ptable.lock);
80104d65:	e9 76 05 00 00       	jmp    801052e0 <release>
80104d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	53                   	push   %ebx
80104d74:	83 ec 10             	sub    $0x10,%esp
80104d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d7a:	68 00 61 18 80       	push   $0x80186100
80104d7f:	e8 9c 04 00 00       	call   80105220 <acquire>
80104d84:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d87:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d8c:	eb 0e                	jmp    80104d9c <kill+0x2c>
80104d8e:	66 90                	xchg   %ax,%ax
80104d90:	05 30 04 00 00       	add    $0x430,%eax
80104d95:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d9a:	73 34                	jae    80104dd0 <kill+0x60>
    if(p->pid == pid){
80104d9c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d9f:	75 ef                	jne    80104d90 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104da1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104da5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104dac:	75 07                	jne    80104db5 <kill+0x45>
        p->state = RUNNABLE;
80104dae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104db5:	83 ec 0c             	sub    $0xc,%esp
80104db8:	68 00 61 18 80       	push   $0x80186100
80104dbd:	e8 1e 05 00 00       	call   801052e0 <release>
      return 0;
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104dc7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dca:	c9                   	leave  
80104dcb:	c3                   	ret    
80104dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104dd0:	83 ec 0c             	sub    $0xc,%esp
80104dd3:	68 00 61 18 80       	push   $0x80186100
80104dd8:	e8 03 05 00 00       	call   801052e0 <release>
  return -1;
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de8:	c9                   	leave  
80104de9:	c3                   	ret    
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104df0 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104df4:	31 db                	xor    %ebx,%ebx
{
80104df6:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104df9:	68 00 61 18 80       	push   $0x80186100
80104dfe:	e8 1d 04 00 00       	call   80105220 <acquire>
80104e03:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e06:	ba 34 61 18 80       	mov    $0x80186134,%edx
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104e0b:	b9 10 00 00 00       	mov    $0x10,%ecx
    if(p->state == UNUSED)
80104e10:	8b 42 0c             	mov    0xc(%edx),%eax
80104e13:	85 c0                	test   %eax,%eax
80104e15:	74 0a                	je     80104e21 <getCurrentFreePages+0x31>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104e17:	89 c8                	mov    %ecx,%eax
80104e19:	2b 82 08 04 00 00    	sub    0x408(%edx),%eax
80104e1f:	01 c3                	add    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e21:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e27:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e2d:	72 e1                	jb     80104e10 <getCurrentFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104e2f:	83 ec 0c             	sub    $0xc,%esp
80104e32:	68 00 61 18 80       	push   $0x80186100
80104e37:	e8 a4 04 00 00       	call   801052e0 <release>
  return sum;
}
80104e3c:	89 d8                	mov    %ebx,%eax
80104e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e41:	c9                   	leave  
80104e42:	c3                   	ret    
80104e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80104e54:	31 db                	xor    %ebx,%ebx
{
80104e56:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e59:	68 00 61 18 80       	push   $0x80186100
80104e5e:	e8 bd 03 00 00       	call   80105220 <acquire>
80104e63:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e66:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104e6b:	90                   	nop
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80104e70:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104e74:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e77:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e7d:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e83:	72 eb                	jb     80104e70 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80104e85:	83 ec 0c             	sub    $0xc,%esp
80104e88:	68 00 61 18 80       	push   $0x80186100
80104e8d:	e8 4e 04 00 00       	call   801052e0 <release>
  return pcount * MAX_PSYC_PAGES;
80104e92:	89 d8                	mov    %ebx,%eax
80104e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return pcount * MAX_PSYC_PAGES;
80104e97:	c1 e0 04             	shl    $0x4,%eax
80104e9a:	c9                   	leave  
80104e9b:	c3                   	ret    
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <procdump>:
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
80104ea5:	53                   	push   %ebx
80104ea6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ea9:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104eae:	83 ec 3c             	sub    $0x3c,%esp
80104eb1:	eb 41                	jmp    80104ef4 <procdump+0x54>
80104eb3:	90                   	nop
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80104eb8:	e8 93 ff ff ff       	call   80104e50 <getTotalFreePages>
80104ebd:	89 c7                	mov    %eax,%edi
80104ebf:	e8 2c ff ff ff       	call   80104df0 <getCurrentFreePages>
80104ec4:	83 ec 04             	sub    $0x4,%esp
80104ec7:	57                   	push   %edi
80104ec8:	50                   	push   %eax
80104ec9:	68 0f 96 10 80       	push   $0x8010960f
80104ece:	e8 8d b7 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104ed3:	c7 04 24 9b 9b 10 80 	movl   $0x80109b9b,(%esp)
80104eda:	e8 81 b7 ff ff       	call   80100660 <cprintf>
80104edf:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ee2:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104ee8:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104eee:	0f 83 ac 00 00 00    	jae    80104fa0 <procdump+0x100>
    if(p->state == UNUSED)
80104ef4:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ef7:	85 c0                	test   %eax,%eax
80104ef9:	74 e7                	je     80104ee2 <procdump+0x42>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104efb:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104efe:	ba 0b 96 10 80       	mov    $0x8010960b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f03:	77 11                	ja     80104f16 <procdump+0x76>
80104f05:	8b 14 85 1c 97 10 80 	mov    -0x7fef68e4(,%eax,4),%edx
      state = "???";
80104f0c:	b8 0b 96 10 80       	mov    $0x8010960b,%eax
80104f11:	85 d2                	test   %edx,%edx
80104f13:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104f16:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104f19:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104f1f:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104f25:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104f2b:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104f31:	50                   	push   %eax
80104f32:	52                   	push   %edx
80104f33:	ff 73 10             	pushl  0x10(%ebx)
80104f36:	68 b4 96 10 80       	push   $0x801096b4
80104f3b:	e8 20 b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104f40:	83 c4 20             	add    $0x20,%esp
80104f43:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104f47:	0f 85 6b ff ff ff    	jne    80104eb8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f4d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f50:	83 ec 08             	sub    $0x8,%esp
80104f53:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104f56:	50                   	push   %eax
80104f57:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f5a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f5d:	83 c0 08             	add    $0x8,%eax
80104f60:	50                   	push   %eax
80104f61:	e8 9a 01 00 00       	call   80105100 <getcallerpcs>
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104f70:	8b 17                	mov    (%edi),%edx
80104f72:	85 d2                	test   %edx,%edx
80104f74:	0f 84 3e ff ff ff    	je     80104eb8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104f7a:	83 ec 08             	sub    $0x8,%esp
80104f7d:	83 c7 04             	add    $0x4,%edi
80104f80:	52                   	push   %edx
80104f81:	68 61 8f 10 80       	push   $0x80108f61
80104f86:	e8 d5 b6 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104f8b:	83 c4 10             	add    $0x10,%esp
80104f8e:	39 fe                	cmp    %edi,%esi
80104f90:	75 de                	jne    80104f70 <procdump+0xd0>
80104f92:	e9 21 ff ff ff       	jmp    80104eb8 <procdump+0x18>
80104f97:	89 f6                	mov    %esi,%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104fa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fa3:	5b                   	pop    %ebx
80104fa4:	5e                   	pop    %esi
80104fa5:	5f                   	pop    %edi
80104fa6:	5d                   	pop    %ebp
80104fa7:	c3                   	ret    
80104fa8:	66 90                	xchg   %ax,%ax
80104faa:	66 90                	xchg   %ax,%ax
80104fac:	66 90                	xchg   %ax,%ax
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104fba:	68 34 97 10 80       	push   $0x80109734
80104fbf:	8d 43 04             	lea    0x4(%ebx),%eax
80104fc2:	50                   	push   %eax
80104fc3:	e8 18 01 00 00       	call   801050e0 <initlock>
  lk->name = name;
80104fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104fcb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104fd1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104fd4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104fdb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fe1:	c9                   	leave  
80104fe2:	c3                   	ret    
80104fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ff0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ff0:	55                   	push   %ebp
80104ff1:	89 e5                	mov    %esp,%ebp
80104ff3:	56                   	push   %esi
80104ff4:	53                   	push   %ebx
80104ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ff8:	83 ec 0c             	sub    $0xc,%esp
80104ffb:	8d 73 04             	lea    0x4(%ebx),%esi
80104ffe:	56                   	push   %esi
80104fff:	e8 1c 02 00 00       	call   80105220 <acquire>
  while (lk->locked) {
80105004:	8b 13                	mov    (%ebx),%edx
80105006:	83 c4 10             	add    $0x10,%esp
80105009:	85 d2                	test   %edx,%edx
8010500b:	74 16                	je     80105023 <acquiresleep+0x33>
8010500d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105010:	83 ec 08             	sub    $0x8,%esp
80105013:	56                   	push   %esi
80105014:	53                   	push   %ebx
80105015:	e8 b6 fa ff ff       	call   80104ad0 <sleep>
  while (lk->locked) {
8010501a:	8b 03                	mov    (%ebx),%eax
8010501c:	83 c4 10             	add    $0x10,%esp
8010501f:	85 c0                	test   %eax,%eax
80105021:	75 ed                	jne    80105010 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105023:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105029:	e8 92 f2 ff ff       	call   801042c0 <myproc>
8010502e:	8b 40 10             	mov    0x10(%eax),%eax
80105031:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105034:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105037:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010503a:	5b                   	pop    %ebx
8010503b:	5e                   	pop    %esi
8010503c:	5d                   	pop    %ebp
  release(&lk->lk);
8010503d:	e9 9e 02 00 00       	jmp    801052e0 <release>
80105042:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	56                   	push   %esi
80105054:	53                   	push   %ebx
80105055:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105058:	83 ec 0c             	sub    $0xc,%esp
8010505b:	8d 73 04             	lea    0x4(%ebx),%esi
8010505e:	56                   	push   %esi
8010505f:	e8 bc 01 00 00       	call   80105220 <acquire>
  lk->locked = 0;
80105064:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010506a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105071:	89 1c 24             	mov    %ebx,(%esp)
80105074:	e8 97 fc ff ff       	call   80104d10 <wakeup>
  release(&lk->lk);
80105079:	89 75 08             	mov    %esi,0x8(%ebp)
8010507c:	83 c4 10             	add    $0x10,%esp
}
8010507f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5d                   	pop    %ebp
  release(&lk->lk);
80105085:	e9 56 02 00 00       	jmp    801052e0 <release>
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105090 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
80105096:	31 ff                	xor    %edi,%edi
80105098:	83 ec 18             	sub    $0x18,%esp
8010509b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010509e:	8d 73 04             	lea    0x4(%ebx),%esi
801050a1:	56                   	push   %esi
801050a2:	e8 79 01 00 00       	call   80105220 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801050a7:	8b 03                	mov    (%ebx),%eax
801050a9:	83 c4 10             	add    $0x10,%esp
801050ac:	85 c0                	test   %eax,%eax
801050ae:	74 13                	je     801050c3 <holdingsleep+0x33>
801050b0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801050b3:	e8 08 f2 ff ff       	call   801042c0 <myproc>
801050b8:	39 58 10             	cmp    %ebx,0x10(%eax)
801050bb:	0f 94 c0             	sete   %al
801050be:	0f b6 c0             	movzbl %al,%eax
801050c1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801050c3:	83 ec 0c             	sub    $0xc,%esp
801050c6:	56                   	push   %esi
801050c7:	e8 14 02 00 00       	call   801052e0 <release>
  return r;
}
801050cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050cf:	89 f8                	mov    %edi,%eax
801050d1:	5b                   	pop    %ebx
801050d2:	5e                   	pop    %esi
801050d3:	5f                   	pop    %edi
801050d4:	5d                   	pop    %ebp
801050d5:	c3                   	ret    
801050d6:	66 90                	xchg   %ax,%ax
801050d8:	66 90                	xchg   %ax,%ax
801050da:	66 90                	xchg   %ax,%ax
801050dc:	66 90                	xchg   %ax,%ax
801050de:	66 90                	xchg   %ax,%ax

801050e0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801050e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801050e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801050ef:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801050f2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret    
801050fb:	90                   	nop
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105100:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105101:	31 d2                	xor    %edx,%edx
{
80105103:	89 e5                	mov    %esp,%ebp
80105105:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105106:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105109:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010510c:	83 e8 08             	sub    $0x8,%eax
8010510f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105110:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105116:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010511c:	77 1a                	ja     80105138 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010511e:	8b 58 04             	mov    0x4(%eax),%ebx
80105121:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105124:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105127:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105129:	83 fa 0a             	cmp    $0xa,%edx
8010512c:	75 e2                	jne    80105110 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010512e:	5b                   	pop    %ebx
8010512f:	5d                   	pop    %ebp
80105130:	c3                   	ret    
80105131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105138:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010513b:	83 c1 28             	add    $0x28,%ecx
8010513e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105140:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105146:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105149:	39 c1                	cmp    %eax,%ecx
8010514b:	75 f3                	jne    80105140 <getcallerpcs+0x40>
}
8010514d:	5b                   	pop    %ebx
8010514e:	5d                   	pop    %ebp
8010514f:	c3                   	ret    

80105150 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105150:	55                   	push   %ebp
80105151:	89 e5                	mov    %esp,%ebp
80105153:	53                   	push   %ebx
80105154:	83 ec 04             	sub    $0x4,%esp
80105157:	9c                   	pushf  
80105158:	5b                   	pop    %ebx
  asm volatile("cli");
80105159:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010515a:	e8 c1 f0 ff ff       	call   80104220 <mycpu>
8010515f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105165:	85 c0                	test   %eax,%eax
80105167:	75 11                	jne    8010517a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105169:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010516f:	e8 ac f0 ff ff       	call   80104220 <mycpu>
80105174:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010517a:	e8 a1 f0 ff ff       	call   80104220 <mycpu>
8010517f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105186:	83 c4 04             	add    $0x4,%esp
80105189:	5b                   	pop    %ebx
8010518a:	5d                   	pop    %ebp
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105190 <popcli>:

void
popcli(void)
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105196:	9c                   	pushf  
80105197:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105198:	f6 c4 02             	test   $0x2,%ah
8010519b:	75 35                	jne    801051d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010519d:	e8 7e f0 ff ff       	call   80104220 <mycpu>
801051a2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801051a9:	78 34                	js     801051df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051ab:	e8 70 f0 ff ff       	call   80104220 <mycpu>
801051b0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051b6:	85 d2                	test   %edx,%edx
801051b8:	74 06                	je     801051c0 <popcli+0x30>
    sti();
}
801051ba:	c9                   	leave  
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051c0:	e8 5b f0 ff ff       	call   80104220 <mycpu>
801051c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051cb:	85 c0                	test   %eax,%eax
801051cd:	74 eb                	je     801051ba <popcli+0x2a>
  asm volatile("sti");
801051cf:	fb                   	sti    
}
801051d0:	c9                   	leave  
801051d1:	c3                   	ret    
    panic("popcli - interruptible");
801051d2:	83 ec 0c             	sub    $0xc,%esp
801051d5:	68 3f 97 10 80       	push   $0x8010973f
801051da:	e8 b1 b1 ff ff       	call   80100390 <panic>
    panic("popcli");
801051df:	83 ec 0c             	sub    $0xc,%esp
801051e2:	68 56 97 10 80       	push   $0x80109756
801051e7:	e8 a4 b1 ff ff       	call   80100390 <panic>
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051f0 <holding>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
801051f5:	8b 75 08             	mov    0x8(%ebp),%esi
801051f8:	31 db                	xor    %ebx,%ebx
  pushcli();
801051fa:	e8 51 ff ff ff       	call   80105150 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051ff:	8b 06                	mov    (%esi),%eax
80105201:	85 c0                	test   %eax,%eax
80105203:	74 10                	je     80105215 <holding+0x25>
80105205:	8b 5e 08             	mov    0x8(%esi),%ebx
80105208:	e8 13 f0 ff ff       	call   80104220 <mycpu>
8010520d:	39 c3                	cmp    %eax,%ebx
8010520f:	0f 94 c3             	sete   %bl
80105212:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105215:	e8 76 ff ff ff       	call   80105190 <popcli>
}
8010521a:	89 d8                	mov    %ebx,%eax
8010521c:	5b                   	pop    %ebx
8010521d:	5e                   	pop    %esi
8010521e:	5d                   	pop    %ebp
8010521f:	c3                   	ret    

80105220 <acquire>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105225:	e8 26 ff ff ff       	call   80105150 <pushcli>
  if(holding(lk))
8010522a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010522d:	83 ec 0c             	sub    $0xc,%esp
80105230:	53                   	push   %ebx
80105231:	e8 ba ff ff ff       	call   801051f0 <holding>
80105236:	83 c4 10             	add    $0x10,%esp
80105239:	85 c0                	test   %eax,%eax
8010523b:	0f 85 83 00 00 00    	jne    801052c4 <acquire+0xa4>
80105241:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105243:	ba 01 00 00 00       	mov    $0x1,%edx
80105248:	eb 09                	jmp    80105253 <acquire+0x33>
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105250:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105253:	89 d0                	mov    %edx,%eax
80105255:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105258:	85 c0                	test   %eax,%eax
8010525a:	75 f4                	jne    80105250 <acquire+0x30>
  __sync_synchronize();
8010525c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105261:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105264:	e8 b7 ef ff ff       	call   80104220 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105269:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010526c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010526f:	89 e8                	mov    %ebp,%eax
80105271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105278:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010527e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105284:	77 1a                	ja     801052a0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105286:	8b 48 04             	mov    0x4(%eax),%ecx
80105289:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010528c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010528f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105291:	83 fe 0a             	cmp    $0xa,%esi
80105294:	75 e2                	jne    80105278 <acquire+0x58>
}
80105296:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105299:	5b                   	pop    %ebx
8010529a:	5e                   	pop    %esi
8010529b:	5d                   	pop    %ebp
8010529c:	c3                   	ret    
8010529d:	8d 76 00             	lea    0x0(%esi),%esi
801052a0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801052a3:	83 c2 28             	add    $0x28,%edx
801052a6:	8d 76 00             	lea    0x0(%esi),%esi
801052a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801052b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801052b6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801052b9:	39 d0                	cmp    %edx,%eax
801052bb:	75 f3                	jne    801052b0 <acquire+0x90>
}
801052bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c0:	5b                   	pop    %ebx
801052c1:	5e                   	pop    %esi
801052c2:	5d                   	pop    %ebp
801052c3:	c3                   	ret    
    panic("acquire");
801052c4:	83 ec 0c             	sub    $0xc,%esp
801052c7:	68 5d 97 10 80       	push   $0x8010975d
801052cc:	e8 bf b0 ff ff       	call   80100390 <panic>
801052d1:	eb 0d                	jmp    801052e0 <release>
801052d3:	90                   	nop
801052d4:	90                   	nop
801052d5:	90                   	nop
801052d6:	90                   	nop
801052d7:	90                   	nop
801052d8:	90                   	nop
801052d9:	90                   	nop
801052da:	90                   	nop
801052db:	90                   	nop
801052dc:	90                   	nop
801052dd:	90                   	nop
801052de:	90                   	nop
801052df:	90                   	nop

801052e0 <release>:
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 10             	sub    $0x10,%esp
801052e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801052ea:	53                   	push   %ebx
801052eb:	e8 00 ff ff ff       	call   801051f0 <holding>
801052f0:	83 c4 10             	add    $0x10,%esp
801052f3:	85 c0                	test   %eax,%eax
801052f5:	74 22                	je     80105319 <release+0x39>
  lk->pcs[0] = 0;
801052f7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801052fe:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105305:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010530a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105310:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105313:	c9                   	leave  
  popcli();
80105314:	e9 77 fe ff ff       	jmp    80105190 <popcli>
    panic("release");
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	68 65 97 10 80       	push   $0x80109765
80105321:	e8 6a b0 ff ff       	call   80100390 <panic>
80105326:	66 90                	xchg   %ax,%ax
80105328:	66 90                	xchg   %ax,%ax
8010532a:	66 90                	xchg   %ax,%ax
8010532c:	66 90                	xchg   %ax,%ax
8010532e:	66 90                	xchg   %ax,%ax

80105330 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	53                   	push   %ebx
80105335:	8b 55 08             	mov    0x8(%ebp),%edx
80105338:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010533b:	f6 c2 03             	test   $0x3,%dl
8010533e:	75 05                	jne    80105345 <memset+0x15>
80105340:	f6 c1 03             	test   $0x3,%cl
80105343:	74 13                	je     80105358 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105345:	89 d7                	mov    %edx,%edi
80105347:	8b 45 0c             	mov    0xc(%ebp),%eax
8010534a:	fc                   	cld    
8010534b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010534d:	5b                   	pop    %ebx
8010534e:	89 d0                	mov    %edx,%eax
80105350:	5f                   	pop    %edi
80105351:	5d                   	pop    %ebp
80105352:	c3                   	ret    
80105353:	90                   	nop
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105358:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010535c:	c1 e9 02             	shr    $0x2,%ecx
8010535f:	89 f8                	mov    %edi,%eax
80105361:	89 fb                	mov    %edi,%ebx
80105363:	c1 e0 18             	shl    $0x18,%eax
80105366:	c1 e3 10             	shl    $0x10,%ebx
80105369:	09 d8                	or     %ebx,%eax
8010536b:	09 f8                	or     %edi,%eax
8010536d:	c1 e7 08             	shl    $0x8,%edi
80105370:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105372:	89 d7                	mov    %edx,%edi
80105374:	fc                   	cld    
80105375:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105377:	5b                   	pop    %ebx
80105378:	89 d0                	mov    %edx,%eax
8010537a:	5f                   	pop    %edi
8010537b:	5d                   	pop    %ebp
8010537c:	c3                   	ret    
8010537d:	8d 76 00             	lea    0x0(%esi),%esi

80105380 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105380:	55                   	push   %ebp
80105381:	89 e5                	mov    %esp,%ebp
80105383:	57                   	push   %edi
80105384:	56                   	push   %esi
80105385:	53                   	push   %ebx
80105386:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105389:	8b 75 08             	mov    0x8(%ebp),%esi
8010538c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010538f:	85 db                	test   %ebx,%ebx
80105391:	74 29                	je     801053bc <memcmp+0x3c>
    if(*s1 != *s2)
80105393:	0f b6 16             	movzbl (%esi),%edx
80105396:	0f b6 0f             	movzbl (%edi),%ecx
80105399:	38 d1                	cmp    %dl,%cl
8010539b:	75 2b                	jne    801053c8 <memcmp+0x48>
8010539d:	b8 01 00 00 00       	mov    $0x1,%eax
801053a2:	eb 14                	jmp    801053b8 <memcmp+0x38>
801053a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053a8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801053ac:	83 c0 01             	add    $0x1,%eax
801053af:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801053b4:	38 ca                	cmp    %cl,%dl
801053b6:	75 10                	jne    801053c8 <memcmp+0x48>
  while(n-- > 0){
801053b8:	39 d8                	cmp    %ebx,%eax
801053ba:	75 ec                	jne    801053a8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801053bc:	5b                   	pop    %ebx
  return 0;
801053bd:	31 c0                	xor    %eax,%eax
}
801053bf:	5e                   	pop    %esi
801053c0:	5f                   	pop    %edi
801053c1:	5d                   	pop    %ebp
801053c2:	c3                   	ret    
801053c3:	90                   	nop
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801053c8:	0f b6 c2             	movzbl %dl,%eax
}
801053cb:	5b                   	pop    %ebx
      return *s1 - *s2;
801053cc:	29 c8                	sub    %ecx,%eax
}
801053ce:	5e                   	pop    %esi
801053cf:	5f                   	pop    %edi
801053d0:	5d                   	pop    %ebp
801053d1:	c3                   	ret    
801053d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	56                   	push   %esi
801053e4:	53                   	push   %ebx
801053e5:	8b 45 08             	mov    0x8(%ebp),%eax
801053e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053eb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801053ee:	39 c3                	cmp    %eax,%ebx
801053f0:	73 26                	jae    80105418 <memmove+0x38>
801053f2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801053f5:	39 c8                	cmp    %ecx,%eax
801053f7:	73 1f                	jae    80105418 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801053f9:	85 f6                	test   %esi,%esi
801053fb:	8d 56 ff             	lea    -0x1(%esi),%edx
801053fe:	74 0f                	je     8010540f <memmove+0x2f>
      *--d = *--s;
80105400:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105404:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105407:	83 ea 01             	sub    $0x1,%edx
8010540a:	83 fa ff             	cmp    $0xffffffff,%edx
8010540d:	75 f1                	jne    80105400 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010540f:	5b                   	pop    %ebx
80105410:	5e                   	pop    %esi
80105411:	5d                   	pop    %ebp
80105412:	c3                   	ret    
80105413:	90                   	nop
80105414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105418:	31 d2                	xor    %edx,%edx
8010541a:	85 f6                	test   %esi,%esi
8010541c:	74 f1                	je     8010540f <memmove+0x2f>
8010541e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105420:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105424:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105427:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010542a:	39 d6                	cmp    %edx,%esi
8010542c:	75 f2                	jne    80105420 <memmove+0x40>
}
8010542e:	5b                   	pop    %ebx
8010542f:	5e                   	pop    %esi
80105430:	5d                   	pop    %ebp
80105431:	c3                   	ret    
80105432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105440:	55                   	push   %ebp
80105441:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105443:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105444:	eb 9a                	jmp    801053e0 <memmove>
80105446:	8d 76 00             	lea    0x0(%esi),%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	57                   	push   %edi
80105454:	56                   	push   %esi
80105455:	8b 7d 10             	mov    0x10(%ebp),%edi
80105458:	53                   	push   %ebx
80105459:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010545c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010545f:	85 ff                	test   %edi,%edi
80105461:	74 2f                	je     80105492 <strncmp+0x42>
80105463:	0f b6 01             	movzbl (%ecx),%eax
80105466:	0f b6 1e             	movzbl (%esi),%ebx
80105469:	84 c0                	test   %al,%al
8010546b:	74 37                	je     801054a4 <strncmp+0x54>
8010546d:	38 c3                	cmp    %al,%bl
8010546f:	75 33                	jne    801054a4 <strncmp+0x54>
80105471:	01 f7                	add    %esi,%edi
80105473:	eb 13                	jmp    80105488 <strncmp+0x38>
80105475:	8d 76 00             	lea    0x0(%esi),%esi
80105478:	0f b6 01             	movzbl (%ecx),%eax
8010547b:	84 c0                	test   %al,%al
8010547d:	74 21                	je     801054a0 <strncmp+0x50>
8010547f:	0f b6 1a             	movzbl (%edx),%ebx
80105482:	89 d6                	mov    %edx,%esi
80105484:	38 d8                	cmp    %bl,%al
80105486:	75 1c                	jne    801054a4 <strncmp+0x54>
    n--, p++, q++;
80105488:	8d 56 01             	lea    0x1(%esi),%edx
8010548b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010548e:	39 fa                	cmp    %edi,%edx
80105490:	75 e6                	jne    80105478 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105492:	5b                   	pop    %ebx
    return 0;
80105493:	31 c0                	xor    %eax,%eax
}
80105495:	5e                   	pop    %esi
80105496:	5f                   	pop    %edi
80105497:	5d                   	pop    %ebp
80105498:	c3                   	ret    
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054a0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801054a4:	29 d8                	sub    %ebx,%eax
}
801054a6:	5b                   	pop    %ebx
801054a7:	5e                   	pop    %esi
801054a8:	5f                   	pop    %edi
801054a9:	5d                   	pop    %ebp
801054aa:	c3                   	ret    
801054ab:	90                   	nop
801054ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	56                   	push   %esi
801054b4:	53                   	push   %ebx
801054b5:	8b 45 08             	mov    0x8(%ebp),%eax
801054b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801054bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801054be:	89 c2                	mov    %eax,%edx
801054c0:	eb 19                	jmp    801054db <strncpy+0x2b>
801054c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054c8:	83 c3 01             	add    $0x1,%ebx
801054cb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801054cf:	83 c2 01             	add    $0x1,%edx
801054d2:	84 c9                	test   %cl,%cl
801054d4:	88 4a ff             	mov    %cl,-0x1(%edx)
801054d7:	74 09                	je     801054e2 <strncpy+0x32>
801054d9:	89 f1                	mov    %esi,%ecx
801054db:	85 c9                	test   %ecx,%ecx
801054dd:	8d 71 ff             	lea    -0x1(%ecx),%esi
801054e0:	7f e6                	jg     801054c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801054e2:	31 c9                	xor    %ecx,%ecx
801054e4:	85 f6                	test   %esi,%esi
801054e6:	7e 17                	jle    801054ff <strncpy+0x4f>
801054e8:	90                   	nop
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801054f0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801054f4:	89 f3                	mov    %esi,%ebx
801054f6:	83 c1 01             	add    $0x1,%ecx
801054f9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801054fb:	85 db                	test   %ebx,%ebx
801054fd:	7f f1                	jg     801054f0 <strncpy+0x40>
  return os;
}
801054ff:	5b                   	pop    %ebx
80105500:	5e                   	pop    %esi
80105501:	5d                   	pop    %ebp
80105502:	c3                   	ret    
80105503:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105510 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105510:	55                   	push   %ebp
80105511:	89 e5                	mov    %esp,%ebp
80105513:	56                   	push   %esi
80105514:	53                   	push   %ebx
80105515:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105518:	8b 45 08             	mov    0x8(%ebp),%eax
8010551b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010551e:	85 c9                	test   %ecx,%ecx
80105520:	7e 26                	jle    80105548 <safestrcpy+0x38>
80105522:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105526:	89 c1                	mov    %eax,%ecx
80105528:	eb 17                	jmp    80105541 <safestrcpy+0x31>
8010552a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105530:	83 c2 01             	add    $0x1,%edx
80105533:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105537:	83 c1 01             	add    $0x1,%ecx
8010553a:	84 db                	test   %bl,%bl
8010553c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010553f:	74 04                	je     80105545 <safestrcpy+0x35>
80105541:	39 f2                	cmp    %esi,%edx
80105543:	75 eb                	jne    80105530 <safestrcpy+0x20>
    ;
  *s = 0;
80105545:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105548:	5b                   	pop    %ebx
80105549:	5e                   	pop    %esi
8010554a:	5d                   	pop    %ebp
8010554b:	c3                   	ret    
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <strlen>:

int
strlen(const char *s)
{
80105550:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105551:	31 c0                	xor    %eax,%eax
{
80105553:	89 e5                	mov    %esp,%ebp
80105555:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105558:	80 3a 00             	cmpb   $0x0,(%edx)
8010555b:	74 0c                	je     80105569 <strlen+0x19>
8010555d:	8d 76 00             	lea    0x0(%esi),%esi
80105560:	83 c0 01             	add    $0x1,%eax
80105563:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105567:	75 f7                	jne    80105560 <strlen+0x10>
    ;
  return n;
}
80105569:	5d                   	pop    %ebp
8010556a:	c3                   	ret    

8010556b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010556b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010556f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105573:	55                   	push   %ebp
  pushl %ebx
80105574:	53                   	push   %ebx
  pushl %esi
80105575:	56                   	push   %esi
  pushl %edi
80105576:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105577:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105579:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010557b:	5f                   	pop    %edi
  popl %esi
8010557c:	5e                   	pop    %esi
  popl %ebx
8010557d:	5b                   	pop    %ebx
  popl %ebp
8010557e:	5d                   	pop    %ebp
  ret
8010557f:	c3                   	ret    

80105580 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	53                   	push   %ebx
80105584:	83 ec 04             	sub    $0x4,%esp
80105587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010558a:	e8 31 ed ff ff       	call   801042c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010558f:	8b 00                	mov    (%eax),%eax
80105591:	39 d8                	cmp    %ebx,%eax
80105593:	76 1b                	jbe    801055b0 <fetchint+0x30>
80105595:	8d 53 04             	lea    0x4(%ebx),%edx
80105598:	39 d0                	cmp    %edx,%eax
8010559a:	72 14                	jb     801055b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010559c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559f:	8b 13                	mov    (%ebx),%edx
801055a1:	89 10                	mov    %edx,(%eax)
  return 0;
801055a3:	31 c0                	xor    %eax,%eax
}
801055a5:	83 c4 04             	add    $0x4,%esp
801055a8:	5b                   	pop    %ebx
801055a9:	5d                   	pop    %ebp
801055aa:	c3                   	ret    
801055ab:	90                   	nop
801055ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055b5:	eb ee                	jmp    801055a5 <fetchint+0x25>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	53                   	push   %ebx
801055c4:	83 ec 04             	sub    $0x4,%esp
801055c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801055ca:	e8 f1 ec ff ff       	call   801042c0 <myproc>

  if(addr >= curproc->sz)
801055cf:	39 18                	cmp    %ebx,(%eax)
801055d1:	76 29                	jbe    801055fc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801055d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055d6:	89 da                	mov    %ebx,%edx
801055d8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801055da:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801055dc:	39 c3                	cmp    %eax,%ebx
801055de:	73 1c                	jae    801055fc <fetchstr+0x3c>
    if(*s == 0)
801055e0:	80 3b 00             	cmpb   $0x0,(%ebx)
801055e3:	75 10                	jne    801055f5 <fetchstr+0x35>
801055e5:	eb 39                	jmp    80105620 <fetchstr+0x60>
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055f0:	80 3a 00             	cmpb   $0x0,(%edx)
801055f3:	74 1b                	je     80105610 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801055f5:	83 c2 01             	add    $0x1,%edx
801055f8:	39 d0                	cmp    %edx,%eax
801055fa:	77 f4                	ja     801055f0 <fetchstr+0x30>
    return -1;
801055fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105601:	83 c4 04             	add    $0x4,%esp
80105604:	5b                   	pop    %ebx
80105605:	5d                   	pop    %ebp
80105606:	c3                   	ret    
80105607:	89 f6                	mov    %esi,%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105610:	83 c4 04             	add    $0x4,%esp
80105613:	89 d0                	mov    %edx,%eax
80105615:	29 d8                	sub    %ebx,%eax
80105617:	5b                   	pop    %ebx
80105618:	5d                   	pop    %ebp
80105619:	c3                   	ret    
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105620:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105622:	eb dd                	jmp    80105601 <fetchstr+0x41>
80105624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010562a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105630 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105635:	e8 86 ec ff ff       	call   801042c0 <myproc>
8010563a:	8b 40 18             	mov    0x18(%eax),%eax
8010563d:	8b 55 08             	mov    0x8(%ebp),%edx
80105640:	8b 40 44             	mov    0x44(%eax),%eax
80105643:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105646:	e8 75 ec ff ff       	call   801042c0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010564b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010564d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105650:	39 c6                	cmp    %eax,%esi
80105652:	73 1c                	jae    80105670 <argint+0x40>
80105654:	8d 53 08             	lea    0x8(%ebx),%edx
80105657:	39 d0                	cmp    %edx,%eax
80105659:	72 15                	jb     80105670 <argint+0x40>
  *ip = *(int*)(addr);
8010565b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010565e:	8b 53 04             	mov    0x4(%ebx),%edx
80105661:	89 10                	mov    %edx,(%eax)
  return 0;
80105663:	31 c0                	xor    %eax,%eax
}
80105665:	5b                   	pop    %ebx
80105666:	5e                   	pop    %esi
80105667:	5d                   	pop    %ebp
80105668:	c3                   	ret    
80105669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105675:	eb ee                	jmp    80105665 <argint+0x35>
80105677:	89 f6                	mov    %esi,%esi
80105679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105680 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	56                   	push   %esi
80105684:	53                   	push   %ebx
80105685:	83 ec 10             	sub    $0x10,%esp
80105688:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010568b:	e8 30 ec ff ff       	call   801042c0 <myproc>
80105690:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105692:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105695:	83 ec 08             	sub    $0x8,%esp
80105698:	50                   	push   %eax
80105699:	ff 75 08             	pushl  0x8(%ebp)
8010569c:	e8 8f ff ff ff       	call   80105630 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801056a1:	83 c4 10             	add    $0x10,%esp
801056a4:	85 c0                	test   %eax,%eax
801056a6:	78 28                	js     801056d0 <argptr+0x50>
801056a8:	85 db                	test   %ebx,%ebx
801056aa:	78 24                	js     801056d0 <argptr+0x50>
801056ac:	8b 16                	mov    (%esi),%edx
801056ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b1:	39 c2                	cmp    %eax,%edx
801056b3:	76 1b                	jbe    801056d0 <argptr+0x50>
801056b5:	01 c3                	add    %eax,%ebx
801056b7:	39 da                	cmp    %ebx,%edx
801056b9:	72 15                	jb     801056d0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801056bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801056be:	89 02                	mov    %eax,(%edx)
  return 0;
801056c0:	31 c0                	xor    %eax,%eax
}
801056c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056c5:	5b                   	pop    %ebx
801056c6:	5e                   	pop    %esi
801056c7:	5d                   	pop    %ebp
801056c8:	c3                   	ret    
801056c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056d5:	eb eb                	jmp    801056c2 <argptr+0x42>
801056d7:	89 f6                	mov    %esi,%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056e0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	ff 75 08             	pushl  0x8(%ebp)
801056ed:	e8 3e ff ff ff       	call   80105630 <argint>
801056f2:	83 c4 10             	add    $0x10,%esp
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 17                	js     80105710 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801056f9:	83 ec 08             	sub    $0x8,%esp
801056fc:	ff 75 0c             	pushl  0xc(%ebp)
801056ff:	ff 75 f4             	pushl  -0xc(%ebp)
80105702:	e8 b9 fe ff ff       	call   801055c0 <fetchstr>
80105707:	83 c4 10             	add    $0x10,%esp
}
8010570a:	c9                   	leave  
8010570b:	c3                   	ret    
8010570c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105715:	c9                   	leave  
80105716:	c3                   	ret    
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105720 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	53                   	push   %ebx
80105724:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105727:	e8 94 eb ff ff       	call   801042c0 <myproc>
8010572c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010572e:	8b 40 18             	mov    0x18(%eax),%eax
80105731:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105734:	8d 50 ff             	lea    -0x1(%eax),%edx
80105737:	83 fa 16             	cmp    $0x16,%edx
8010573a:	77 1c                	ja     80105758 <syscall+0x38>
8010573c:	8b 14 85 a0 97 10 80 	mov    -0x7fef6860(,%eax,4),%edx
80105743:	85 d2                	test   %edx,%edx
80105745:	74 11                	je     80105758 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105747:	ff d2                	call   *%edx
80105749:	8b 53 18             	mov    0x18(%ebx),%edx
8010574c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010574f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105752:	c9                   	leave  
80105753:	c3                   	ret    
80105754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105758:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105759:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010575c:	50                   	push   %eax
8010575d:	ff 73 10             	pushl  0x10(%ebx)
80105760:	68 6d 97 10 80       	push   $0x8010976d
80105765:	e8 f6 ae ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010576a:	8b 43 18             	mov    0x18(%ebx),%eax
8010576d:	83 c4 10             	add    $0x10,%esp
80105770:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010577a:	c9                   	leave  
8010577b:	c3                   	ret    
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	56                   	push   %esi
80105784:	53                   	push   %ebx
80105785:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105787:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010578a:	89 d6                	mov    %edx,%esi
8010578c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010578f:	50                   	push   %eax
80105790:	6a 00                	push   $0x0
80105792:	e8 99 fe ff ff       	call   80105630 <argint>
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	85 c0                	test   %eax,%eax
8010579c:	78 2a                	js     801057c8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010579e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057a2:	77 24                	ja     801057c8 <argfd.constprop.0+0x48>
801057a4:	e8 17 eb ff ff       	call   801042c0 <myproc>
801057a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801057b0:	85 c0                	test   %eax,%eax
801057b2:	74 14                	je     801057c8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801057b4:	85 db                	test   %ebx,%ebx
801057b6:	74 02                	je     801057ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801057b8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801057ba:	89 06                	mov    %eax,(%esi)
  return 0;
801057bc:	31 c0                	xor    %eax,%eax
}
801057be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057c1:	5b                   	pop    %ebx
801057c2:	5e                   	pop    %esi
801057c3:	5d                   	pop    %ebp
801057c4:	c3                   	ret    
801057c5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057cd:	eb ef                	jmp    801057be <argfd.constprop.0+0x3e>
801057cf:	90                   	nop

801057d0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801057d0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057d1:	31 c0                	xor    %eax,%eax
{
801057d3:	89 e5                	mov    %esp,%ebp
801057d5:	56                   	push   %esi
801057d6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801057d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801057da:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801057dd:	e8 9e ff ff ff       	call   80105780 <argfd.constprop.0>
801057e2:	85 c0                	test   %eax,%eax
801057e4:	78 42                	js     80105828 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801057e6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057e9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057eb:	e8 d0 ea ff ff       	call   801042c0 <myproc>
801057f0:	eb 0e                	jmp    80105800 <sys_dup+0x30>
801057f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057f8:	83 c3 01             	add    $0x1,%ebx
801057fb:	83 fb 10             	cmp    $0x10,%ebx
801057fe:	74 28                	je     80105828 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105800:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105804:	85 d2                	test   %edx,%edx
80105806:	75 f0                	jne    801057f8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105808:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010580c:	83 ec 0c             	sub    $0xc,%esp
8010580f:	ff 75 f4             	pushl  -0xc(%ebp)
80105812:	e8 89 b9 ff ff       	call   801011a0 <filedup>
  return fd;
80105817:	83 c4 10             	add    $0x10,%esp
}
8010581a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010581d:	89 d8                	mov    %ebx,%eax
8010581f:	5b                   	pop    %ebx
80105820:	5e                   	pop    %esi
80105821:	5d                   	pop    %ebp
80105822:	c3                   	ret    
80105823:	90                   	nop
80105824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105828:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010582b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105830:	89 d8                	mov    %ebx,%eax
80105832:	5b                   	pop    %ebx
80105833:	5e                   	pop    %esi
80105834:	5d                   	pop    %ebp
80105835:	c3                   	ret    
80105836:	8d 76 00             	lea    0x0(%esi),%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105840 <sys_read>:

int
sys_read(void)
{
80105840:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105841:	31 c0                	xor    %eax,%eax
{
80105843:	89 e5                	mov    %esp,%ebp
80105845:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105848:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010584b:	e8 30 ff ff ff       	call   80105780 <argfd.constprop.0>
80105850:	85 c0                	test   %eax,%eax
80105852:	78 4c                	js     801058a0 <sys_read+0x60>
80105854:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105857:	83 ec 08             	sub    $0x8,%esp
8010585a:	50                   	push   %eax
8010585b:	6a 02                	push   $0x2
8010585d:	e8 ce fd ff ff       	call   80105630 <argint>
80105862:	83 c4 10             	add    $0x10,%esp
80105865:	85 c0                	test   %eax,%eax
80105867:	78 37                	js     801058a0 <sys_read+0x60>
80105869:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010586c:	83 ec 04             	sub    $0x4,%esp
8010586f:	ff 75 f0             	pushl  -0x10(%ebp)
80105872:	50                   	push   %eax
80105873:	6a 01                	push   $0x1
80105875:	e8 06 fe ff ff       	call   80105680 <argptr>
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	85 c0                	test   %eax,%eax
8010587f:	78 1f                	js     801058a0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105881:	83 ec 04             	sub    $0x4,%esp
80105884:	ff 75 f0             	pushl  -0x10(%ebp)
80105887:	ff 75 f4             	pushl  -0xc(%ebp)
8010588a:	ff 75 ec             	pushl  -0x14(%ebp)
8010588d:	e8 7e ba ff ff       	call   80101310 <fileread>
80105892:	83 c4 10             	add    $0x10,%esp
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058b0 <sys_write>:

int
sys_write(void)
{
801058b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058b1:	31 c0                	xor    %eax,%eax
{
801058b3:	89 e5                	mov    %esp,%ebp
801058b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801058bb:	e8 c0 fe ff ff       	call   80105780 <argfd.constprop.0>
801058c0:	85 c0                	test   %eax,%eax
801058c2:	78 4c                	js     80105910 <sys_write+0x60>
801058c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c7:	83 ec 08             	sub    $0x8,%esp
801058ca:	50                   	push   %eax
801058cb:	6a 02                	push   $0x2
801058cd:	e8 5e fd ff ff       	call   80105630 <argint>
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	85 c0                	test   %eax,%eax
801058d7:	78 37                	js     80105910 <sys_write+0x60>
801058d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058dc:	83 ec 04             	sub    $0x4,%esp
801058df:	ff 75 f0             	pushl  -0x10(%ebp)
801058e2:	50                   	push   %eax
801058e3:	6a 01                	push   $0x1
801058e5:	e8 96 fd ff ff       	call   80105680 <argptr>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	78 1f                	js     80105910 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801058f1:	83 ec 04             	sub    $0x4,%esp
801058f4:	ff 75 f0             	pushl  -0x10(%ebp)
801058f7:	ff 75 f4             	pushl  -0xc(%ebp)
801058fa:	ff 75 ec             	pushl  -0x14(%ebp)
801058fd:	e8 9e ba ff ff       	call   801013a0 <filewrite>
80105902:	83 c4 10             	add    $0x10,%esp
}
80105905:	c9                   	leave  
80105906:	c3                   	ret    
80105907:	89 f6                	mov    %esi,%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <sys_close>:

int
sys_close(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105926:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105929:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010592c:	e8 4f fe ff ff       	call   80105780 <argfd.constprop.0>
80105931:	85 c0                	test   %eax,%eax
80105933:	78 2b                	js     80105960 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105935:	e8 86 e9 ff ff       	call   801042c0 <myproc>
8010593a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010593d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105940:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105947:	00 
  fileclose(f);
80105948:	ff 75 f4             	pushl  -0xc(%ebp)
8010594b:	e8 a0 b8 ff ff       	call   801011f0 <fileclose>
  return 0;
80105950:	83 c4 10             	add    $0x10,%esp
80105953:	31 c0                	xor    %eax,%eax
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_fstat>:

int
sys_fstat(void)
{
80105970:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105971:	31 c0                	xor    %eax,%eax
{
80105973:	89 e5                	mov    %esp,%ebp
80105975:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105978:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010597b:	e8 00 fe ff ff       	call   80105780 <argfd.constprop.0>
80105980:	85 c0                	test   %eax,%eax
80105982:	78 2c                	js     801059b0 <sys_fstat+0x40>
80105984:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105987:	83 ec 04             	sub    $0x4,%esp
8010598a:	6a 14                	push   $0x14
8010598c:	50                   	push   %eax
8010598d:	6a 01                	push   $0x1
8010598f:	e8 ec fc ff ff       	call   80105680 <argptr>
80105994:	83 c4 10             	add    $0x10,%esp
80105997:	85 c0                	test   %eax,%eax
80105999:	78 15                	js     801059b0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010599b:	83 ec 08             	sub    $0x8,%esp
8010599e:	ff 75 f4             	pushl  -0xc(%ebp)
801059a1:	ff 75 f0             	pushl  -0x10(%ebp)
801059a4:	e8 17 b9 ff ff       	call   801012c0 <filestat>
801059a9:	83 c4 10             	add    $0x10,%esp
}
801059ac:	c9                   	leave  
801059ad:	c3                   	ret    
801059ae:	66 90                	xchg   %ax,%ax
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b5:	c9                   	leave  
801059b6:	c3                   	ret    
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059c6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059c9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059cc:	50                   	push   %eax
801059cd:	6a 00                	push   $0x0
801059cf:	e8 0c fd ff ff       	call   801056e0 <argstr>
801059d4:	83 c4 10             	add    $0x10,%esp
801059d7:	85 c0                	test   %eax,%eax
801059d9:	0f 88 fb 00 00 00    	js     80105ada <sys_link+0x11a>
801059df:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059e2:	83 ec 08             	sub    $0x8,%esp
801059e5:	50                   	push   %eax
801059e6:	6a 01                	push   $0x1
801059e8:	e8 f3 fc ff ff       	call   801056e0 <argstr>
801059ed:	83 c4 10             	add    $0x10,%esp
801059f0:	85 c0                	test   %eax,%eax
801059f2:	0f 88 e2 00 00 00    	js     80105ada <sys_link+0x11a>
    return -1;

  begin_op();
801059f8:	e8 53 db ff ff       	call   80103550 <begin_op>
  if((ip = namei(old)) == 0){
801059fd:	83 ec 0c             	sub    $0xc,%esp
80105a00:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a03:	e8 88 c8 ff ff       	call   80102290 <namei>
80105a08:	83 c4 10             	add    $0x10,%esp
80105a0b:	85 c0                	test   %eax,%eax
80105a0d:	89 c3                	mov    %eax,%ebx
80105a0f:	0f 84 ea 00 00 00    	je     80105aff <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105a15:	83 ec 0c             	sub    $0xc,%esp
80105a18:	50                   	push   %eax
80105a19:	e8 12 c0 ff ff       	call   80101a30 <ilock>
  if(ip->type == T_DIR){
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a26:	0f 84 bb 00 00 00    	je     80105ae7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105a2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a31:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a34:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a37:	53                   	push   %ebx
80105a38:	e8 43 bf ff ff       	call   80101980 <iupdate>
  iunlock(ip);
80105a3d:	89 1c 24             	mov    %ebx,(%esp)
80105a40:	e8 cb c0 ff ff       	call   80101b10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a45:	58                   	pop    %eax
80105a46:	5a                   	pop    %edx
80105a47:	57                   	push   %edi
80105a48:	ff 75 d0             	pushl  -0x30(%ebp)
80105a4b:	e8 60 c8 ff ff       	call   801022b0 <nameiparent>
80105a50:	83 c4 10             	add    $0x10,%esp
80105a53:	85 c0                	test   %eax,%eax
80105a55:	89 c6                	mov    %eax,%esi
80105a57:	74 5b                	je     80105ab4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	50                   	push   %eax
80105a5d:	e8 ce bf ff ff       	call   80101a30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a62:	83 c4 10             	add    $0x10,%esp
80105a65:	8b 03                	mov    (%ebx),%eax
80105a67:	39 06                	cmp    %eax,(%esi)
80105a69:	75 3d                	jne    80105aa8 <sys_link+0xe8>
80105a6b:	83 ec 04             	sub    $0x4,%esp
80105a6e:	ff 73 04             	pushl  0x4(%ebx)
80105a71:	57                   	push   %edi
80105a72:	56                   	push   %esi
80105a73:	e8 58 c7 ff ff       	call   801021d0 <dirlink>
80105a78:	83 c4 10             	add    $0x10,%esp
80105a7b:	85 c0                	test   %eax,%eax
80105a7d:	78 29                	js     80105aa8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105a7f:	83 ec 0c             	sub    $0xc,%esp
80105a82:	56                   	push   %esi
80105a83:	e8 38 c2 ff ff       	call   80101cc0 <iunlockput>
  iput(ip);
80105a88:	89 1c 24             	mov    %ebx,(%esp)
80105a8b:	e8 d0 c0 ff ff       	call   80101b60 <iput>

  end_op();
80105a90:	e8 2b db ff ff       	call   801035c0 <end_op>

  return 0;
80105a95:	83 c4 10             	add    $0x10,%esp
80105a98:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105a9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a9d:	5b                   	pop    %ebx
80105a9e:	5e                   	pop    %esi
80105a9f:	5f                   	pop    %edi
80105aa0:	5d                   	pop    %ebp
80105aa1:	c3                   	ret    
80105aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105aa8:	83 ec 0c             	sub    $0xc,%esp
80105aab:	56                   	push   %esi
80105aac:	e8 0f c2 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105ab1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ab4:	83 ec 0c             	sub    $0xc,%esp
80105ab7:	53                   	push   %ebx
80105ab8:	e8 73 bf ff ff       	call   80101a30 <ilock>
  ip->nlink--;
80105abd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ac2:	89 1c 24             	mov    %ebx,(%esp)
80105ac5:	e8 b6 be ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105aca:	89 1c 24             	mov    %ebx,(%esp)
80105acd:	e8 ee c1 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105ad2:	e8 e9 da ff ff       	call   801035c0 <end_op>
  return -1;
80105ad7:	83 c4 10             	add    $0x10,%esp
}
80105ada:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ae2:	5b                   	pop    %ebx
80105ae3:	5e                   	pop    %esi
80105ae4:	5f                   	pop    %edi
80105ae5:	5d                   	pop    %ebp
80105ae6:	c3                   	ret    
    iunlockput(ip);
80105ae7:	83 ec 0c             	sub    $0xc,%esp
80105aea:	53                   	push   %ebx
80105aeb:	e8 d0 c1 ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105af0:	e8 cb da ff ff       	call   801035c0 <end_op>
    return -1;
80105af5:	83 c4 10             	add    $0x10,%esp
80105af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105afd:	eb 9b                	jmp    80105a9a <sys_link+0xda>
    end_op();
80105aff:	e8 bc da ff ff       	call   801035c0 <end_op>
    return -1;
80105b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b09:	eb 8f                	jmp    80105a9a <sys_link+0xda>
80105b0b:	90                   	nop
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b10 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
80105b16:	83 ec 1c             	sub    $0x1c,%esp
80105b19:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b1c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105b20:	76 3e                	jbe    80105b60 <isdirempty+0x50>
80105b22:	bb 20 00 00 00       	mov    $0x20,%ebx
80105b27:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b2a:	eb 0c                	jmp    80105b38 <isdirempty+0x28>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b30:	83 c3 10             	add    $0x10,%ebx
80105b33:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105b36:	73 28                	jae    80105b60 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b38:	6a 10                	push   $0x10
80105b3a:	53                   	push   %ebx
80105b3b:	57                   	push   %edi
80105b3c:	56                   	push   %esi
80105b3d:	e8 ce c1 ff ff       	call   80101d10 <readi>
80105b42:	83 c4 10             	add    $0x10,%esp
80105b45:	83 f8 10             	cmp    $0x10,%eax
80105b48:	75 23                	jne    80105b6d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105b4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b4f:	74 df                	je     80105b30 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105b54:	31 c0                	xor    %eax,%eax
}
80105b56:	5b                   	pop    %ebx
80105b57:	5e                   	pop    %esi
80105b58:	5f                   	pop    %edi
80105b59:	5d                   	pop    %ebp
80105b5a:	c3                   	ret    
80105b5b:	90                   	nop
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b60:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105b63:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b68:	5b                   	pop    %ebx
80105b69:	5e                   	pop    %esi
80105b6a:	5f                   	pop    %edi
80105b6b:	5d                   	pop    %ebp
80105b6c:	c3                   	ret    
      panic("isdirempty: readi");
80105b6d:	83 ec 0c             	sub    $0xc,%esp
80105b70:	68 00 98 10 80       	push   $0x80109800
80105b75:	e8 16 a8 ff ff       	call   80100390 <panic>
80105b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b80 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b86:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b89:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b8c:	50                   	push   %eax
80105b8d:	6a 00                	push   $0x0
80105b8f:	e8 4c fb ff ff       	call   801056e0 <argstr>
80105b94:	83 c4 10             	add    $0x10,%esp
80105b97:	85 c0                	test   %eax,%eax
80105b99:	0f 88 51 01 00 00    	js     80105cf0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105ba2:	e8 a9 d9 ff ff       	call   80103550 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105ba7:	83 ec 08             	sub    $0x8,%esp
80105baa:	53                   	push   %ebx
80105bab:	ff 75 c0             	pushl  -0x40(%ebp)
80105bae:	e8 fd c6 ff ff       	call   801022b0 <nameiparent>
80105bb3:	83 c4 10             	add    $0x10,%esp
80105bb6:	85 c0                	test   %eax,%eax
80105bb8:	89 c6                	mov    %eax,%esi
80105bba:	0f 84 37 01 00 00    	je     80105cf7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105bc0:	83 ec 0c             	sub    $0xc,%esp
80105bc3:	50                   	push   %eax
80105bc4:	e8 67 be ff ff       	call   80101a30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bc9:	58                   	pop    %eax
80105bca:	5a                   	pop    %edx
80105bcb:	68 eb 90 10 80       	push   $0x801090eb
80105bd0:	53                   	push   %ebx
80105bd1:	e8 6a c3 ff ff       	call   80101f40 <namecmp>
80105bd6:	83 c4 10             	add    $0x10,%esp
80105bd9:	85 c0                	test   %eax,%eax
80105bdb:	0f 84 d7 00 00 00    	je     80105cb8 <sys_unlink+0x138>
80105be1:	83 ec 08             	sub    $0x8,%esp
80105be4:	68 ea 90 10 80       	push   $0x801090ea
80105be9:	53                   	push   %ebx
80105bea:	e8 51 c3 ff ff       	call   80101f40 <namecmp>
80105bef:	83 c4 10             	add    $0x10,%esp
80105bf2:	85 c0                	test   %eax,%eax
80105bf4:	0f 84 be 00 00 00    	je     80105cb8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bfa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bfd:	83 ec 04             	sub    $0x4,%esp
80105c00:	50                   	push   %eax
80105c01:	53                   	push   %ebx
80105c02:	56                   	push   %esi
80105c03:	e8 58 c3 ff ff       	call   80101f60 <dirlookup>
80105c08:	83 c4 10             	add    $0x10,%esp
80105c0b:	85 c0                	test   %eax,%eax
80105c0d:	89 c3                	mov    %eax,%ebx
80105c0f:	0f 84 a3 00 00 00    	je     80105cb8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105c15:	83 ec 0c             	sub    $0xc,%esp
80105c18:	50                   	push   %eax
80105c19:	e8 12 be ff ff       	call   80101a30 <ilock>

  if(ip->nlink < 1)
80105c1e:	83 c4 10             	add    $0x10,%esp
80105c21:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c26:	0f 8e e4 00 00 00    	jle    80105d10 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c31:	74 65                	je     80105c98 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c33:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c36:	83 ec 04             	sub    $0x4,%esp
80105c39:	6a 10                	push   $0x10
80105c3b:	6a 00                	push   $0x0
80105c3d:	57                   	push   %edi
80105c3e:	e8 ed f6 ff ff       	call   80105330 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c43:	6a 10                	push   $0x10
80105c45:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c48:	57                   	push   %edi
80105c49:	56                   	push   %esi
80105c4a:	e8 c1 c1 ff ff       	call   80101e10 <writei>
80105c4f:	83 c4 20             	add    $0x20,%esp
80105c52:	83 f8 10             	cmp    $0x10,%eax
80105c55:	0f 85 a8 00 00 00    	jne    80105d03 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c5b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c60:	74 6e                	je     80105cd0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c62:	83 ec 0c             	sub    $0xc,%esp
80105c65:	56                   	push   %esi
80105c66:	e8 55 c0 ff ff       	call   80101cc0 <iunlockput>

  ip->nlink--;
80105c6b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c70:	89 1c 24             	mov    %ebx,(%esp)
80105c73:	e8 08 bd ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105c78:	89 1c 24             	mov    %ebx,(%esp)
80105c7b:	e8 40 c0 ff ff       	call   80101cc0 <iunlockput>

  end_op();
80105c80:	e8 3b d9 ff ff       	call   801035c0 <end_op>

  return 0;
80105c85:	83 c4 10             	add    $0x10,%esp
80105c88:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c8d:	5b                   	pop    %ebx
80105c8e:	5e                   	pop    %esi
80105c8f:	5f                   	pop    %edi
80105c90:	5d                   	pop    %ebp
80105c91:	c3                   	ret    
80105c92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c98:	83 ec 0c             	sub    $0xc,%esp
80105c9b:	53                   	push   %ebx
80105c9c:	e8 6f fe ff ff       	call   80105b10 <isdirempty>
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	85 c0                	test   %eax,%eax
80105ca6:	75 8b                	jne    80105c33 <sys_unlink+0xb3>
    iunlockput(ip);
80105ca8:	83 ec 0c             	sub    $0xc,%esp
80105cab:	53                   	push   %ebx
80105cac:	e8 0f c0 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	56                   	push   %esi
80105cbc:	e8 ff bf ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105cc1:	e8 fa d8 ff ff       	call   801035c0 <end_op>
  return -1;
80105cc6:	83 c4 10             	add    $0x10,%esp
80105cc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cce:	eb ba                	jmp    80105c8a <sys_unlink+0x10a>
    dp->nlink--;
80105cd0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105cd5:	83 ec 0c             	sub    $0xc,%esp
80105cd8:	56                   	push   %esi
80105cd9:	e8 a2 bc ff ff       	call   80101980 <iupdate>
80105cde:	83 c4 10             	add    $0x10,%esp
80105ce1:	e9 7c ff ff ff       	jmp    80105c62 <sys_unlink+0xe2>
80105ce6:	8d 76 00             	lea    0x0(%esi),%esi
80105ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cf5:	eb 93                	jmp    80105c8a <sys_unlink+0x10a>
    end_op();
80105cf7:	e8 c4 d8 ff ff       	call   801035c0 <end_op>
    return -1;
80105cfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d01:	eb 87                	jmp    80105c8a <sys_unlink+0x10a>
    panic("unlink: writei");
80105d03:	83 ec 0c             	sub    $0xc,%esp
80105d06:	68 ff 90 10 80       	push   $0x801090ff
80105d0b:	e8 80 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d10:	83 ec 0c             	sub    $0xc,%esp
80105d13:	68 ed 90 10 80       	push   $0x801090ed
80105d18:	e8 73 a6 ff ff       	call   80100390 <panic>
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi

80105d20 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	57                   	push   %edi
80105d24:	56                   	push   %esi
80105d25:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d26:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105d29:	83 ec 34             	sub    $0x34,%esp
80105d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d2f:	8b 55 10             	mov    0x10(%ebp),%edx
80105d32:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d35:	56                   	push   %esi
80105d36:	ff 75 08             	pushl  0x8(%ebp)
{
80105d39:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105d3c:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105d3f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d42:	e8 69 c5 ff ff       	call   801022b0 <nameiparent>
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	85 c0                	test   %eax,%eax
80105d4c:	0f 84 4e 01 00 00    	je     80105ea0 <create+0x180>
    return 0;
  ilock(dp);
80105d52:	83 ec 0c             	sub    $0xc,%esp
80105d55:	89 c3                	mov    %eax,%ebx
80105d57:	50                   	push   %eax
80105d58:	e8 d3 bc ff ff       	call   80101a30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d5d:	83 c4 0c             	add    $0xc,%esp
80105d60:	6a 00                	push   $0x0
80105d62:	56                   	push   %esi
80105d63:	53                   	push   %ebx
80105d64:	e8 f7 c1 ff ff       	call   80101f60 <dirlookup>
80105d69:	83 c4 10             	add    $0x10,%esp
80105d6c:	85 c0                	test   %eax,%eax
80105d6e:	89 c7                	mov    %eax,%edi
80105d70:	74 3e                	je     80105db0 <create+0x90>
    iunlockput(dp);
80105d72:	83 ec 0c             	sub    $0xc,%esp
80105d75:	53                   	push   %ebx
80105d76:	e8 45 bf ff ff       	call   80101cc0 <iunlockput>
    ilock(ip);
80105d7b:	89 3c 24             	mov    %edi,(%esp)
80105d7e:	e8 ad bc ff ff       	call   80101a30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d83:	83 c4 10             	add    $0x10,%esp
80105d86:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d8b:	0f 85 9f 00 00 00    	jne    80105e30 <create+0x110>
80105d91:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105d96:	0f 85 94 00 00 00    	jne    80105e30 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d9f:	89 f8                	mov    %edi,%eax
80105da1:	5b                   	pop    %ebx
80105da2:	5e                   	pop    %esi
80105da3:	5f                   	pop    %edi
80105da4:	5d                   	pop    %ebp
80105da5:	c3                   	ret    
80105da6:	8d 76 00             	lea    0x0(%esi),%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105db0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105db4:	83 ec 08             	sub    $0x8,%esp
80105db7:	50                   	push   %eax
80105db8:	ff 33                	pushl  (%ebx)
80105dba:	e8 01 bb ff ff       	call   801018c0 <ialloc>
80105dbf:	83 c4 10             	add    $0x10,%esp
80105dc2:	85 c0                	test   %eax,%eax
80105dc4:	89 c7                	mov    %eax,%edi
80105dc6:	0f 84 e8 00 00 00    	je     80105eb4 <create+0x194>
  ilock(ip);
80105dcc:	83 ec 0c             	sub    $0xc,%esp
80105dcf:	50                   	push   %eax
80105dd0:	e8 5b bc ff ff       	call   80101a30 <ilock>
  ip->major = major;
80105dd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105dd9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105ddd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105de1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105de5:	b8 01 00 00 00       	mov    $0x1,%eax
80105dea:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105dee:	89 3c 24             	mov    %edi,(%esp)
80105df1:	e8 8a bb ff ff       	call   80101980 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105df6:	83 c4 10             	add    $0x10,%esp
80105df9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105dfe:	74 50                	je     80105e50 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105e00:	83 ec 04             	sub    $0x4,%esp
80105e03:	ff 77 04             	pushl  0x4(%edi)
80105e06:	56                   	push   %esi
80105e07:	53                   	push   %ebx
80105e08:	e8 c3 c3 ff ff       	call   801021d0 <dirlink>
80105e0d:	83 c4 10             	add    $0x10,%esp
80105e10:	85 c0                	test   %eax,%eax
80105e12:	0f 88 8f 00 00 00    	js     80105ea7 <create+0x187>
  iunlockput(dp);
80105e18:	83 ec 0c             	sub    $0xc,%esp
80105e1b:	53                   	push   %ebx
80105e1c:	e8 9f be ff ff       	call   80101cc0 <iunlockput>
  return ip;
80105e21:	83 c4 10             	add    $0x10,%esp
}
80105e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e27:	89 f8                	mov    %edi,%eax
80105e29:	5b                   	pop    %ebx
80105e2a:	5e                   	pop    %esi
80105e2b:	5f                   	pop    %edi
80105e2c:	5d                   	pop    %ebp
80105e2d:	c3                   	ret    
80105e2e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105e30:	83 ec 0c             	sub    $0xc,%esp
80105e33:	57                   	push   %edi
    return 0;
80105e34:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105e36:	e8 85 be ff ff       	call   80101cc0 <iunlockput>
    return 0;
80105e3b:	83 c4 10             	add    $0x10,%esp
}
80105e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e41:	89 f8                	mov    %edi,%eax
80105e43:	5b                   	pop    %ebx
80105e44:	5e                   	pop    %esi
80105e45:	5f                   	pop    %edi
80105e46:	5d                   	pop    %ebp
80105e47:	c3                   	ret    
80105e48:	90                   	nop
80105e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105e50:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e55:	83 ec 0c             	sub    $0xc,%esp
80105e58:	53                   	push   %ebx
80105e59:	e8 22 bb ff ff       	call   80101980 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e5e:	83 c4 0c             	add    $0xc,%esp
80105e61:	ff 77 04             	pushl  0x4(%edi)
80105e64:	68 eb 90 10 80       	push   $0x801090eb
80105e69:	57                   	push   %edi
80105e6a:	e8 61 c3 ff ff       	call   801021d0 <dirlink>
80105e6f:	83 c4 10             	add    $0x10,%esp
80105e72:	85 c0                	test   %eax,%eax
80105e74:	78 1c                	js     80105e92 <create+0x172>
80105e76:	83 ec 04             	sub    $0x4,%esp
80105e79:	ff 73 04             	pushl  0x4(%ebx)
80105e7c:	68 ea 90 10 80       	push   $0x801090ea
80105e81:	57                   	push   %edi
80105e82:	e8 49 c3 ff ff       	call   801021d0 <dirlink>
80105e87:	83 c4 10             	add    $0x10,%esp
80105e8a:	85 c0                	test   %eax,%eax
80105e8c:	0f 89 6e ff ff ff    	jns    80105e00 <create+0xe0>
      panic("create dots");
80105e92:	83 ec 0c             	sub    $0xc,%esp
80105e95:	68 21 98 10 80       	push   $0x80109821
80105e9a:	e8 f1 a4 ff ff       	call   80100390 <panic>
80105e9f:	90                   	nop
    return 0;
80105ea0:	31 ff                	xor    %edi,%edi
80105ea2:	e9 f5 fe ff ff       	jmp    80105d9c <create+0x7c>
    panic("create: dirlink");
80105ea7:	83 ec 0c             	sub    $0xc,%esp
80105eaa:	68 2d 98 10 80       	push   $0x8010982d
80105eaf:	e8 dc a4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105eb4:	83 ec 0c             	sub    $0xc,%esp
80105eb7:	68 12 98 10 80       	push   $0x80109812
80105ebc:	e8 cf a4 ff ff       	call   80100390 <panic>
80105ec1:	eb 0d                	jmp    80105ed0 <sys_open>
80105ec3:	90                   	nop
80105ec4:	90                   	nop
80105ec5:	90                   	nop
80105ec6:	90                   	nop
80105ec7:	90                   	nop
80105ec8:	90                   	nop
80105ec9:	90                   	nop
80105eca:	90                   	nop
80105ecb:	90                   	nop
80105ecc:	90                   	nop
80105ecd:	90                   	nop
80105ece:	90                   	nop
80105ecf:	90                   	nop

80105ed0 <sys_open>:

int
sys_open(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	57                   	push   %edi
80105ed4:	56                   	push   %esi
80105ed5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ed6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105ed9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105edc:	50                   	push   %eax
80105edd:	6a 00                	push   $0x0
80105edf:	e8 fc f7 ff ff       	call   801056e0 <argstr>
80105ee4:	83 c4 10             	add    $0x10,%esp
80105ee7:	85 c0                	test   %eax,%eax
80105ee9:	0f 88 1d 01 00 00    	js     8010600c <sys_open+0x13c>
80105eef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ef2:	83 ec 08             	sub    $0x8,%esp
80105ef5:	50                   	push   %eax
80105ef6:	6a 01                	push   $0x1
80105ef8:	e8 33 f7 ff ff       	call   80105630 <argint>
80105efd:	83 c4 10             	add    $0x10,%esp
80105f00:	85 c0                	test   %eax,%eax
80105f02:	0f 88 04 01 00 00    	js     8010600c <sys_open+0x13c>
    return -1;

  begin_op();
80105f08:	e8 43 d6 ff ff       	call   80103550 <begin_op>

  if(omode & O_CREATE){
80105f0d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105f11:	0f 85 a9 00 00 00    	jne    80105fc0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105f17:	83 ec 0c             	sub    $0xc,%esp
80105f1a:	ff 75 e0             	pushl  -0x20(%ebp)
80105f1d:	e8 6e c3 ff ff       	call   80102290 <namei>
80105f22:	83 c4 10             	add    $0x10,%esp
80105f25:	85 c0                	test   %eax,%eax
80105f27:	89 c6                	mov    %eax,%esi
80105f29:	0f 84 ac 00 00 00    	je     80105fdb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105f2f:	83 ec 0c             	sub    $0xc,%esp
80105f32:	50                   	push   %eax
80105f33:	e8 f8 ba ff ff       	call   80101a30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f38:	83 c4 10             	add    $0x10,%esp
80105f3b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f40:	0f 84 aa 00 00 00    	je     80105ff0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f46:	e8 e5 b1 ff ff       	call   80101130 <filealloc>
80105f4b:	85 c0                	test   %eax,%eax
80105f4d:	89 c7                	mov    %eax,%edi
80105f4f:	0f 84 a6 00 00 00    	je     80105ffb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105f55:	e8 66 e3 ff ff       	call   801042c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f5a:	31 db                	xor    %ebx,%ebx
80105f5c:	eb 0e                	jmp    80105f6c <sys_open+0x9c>
80105f5e:	66 90                	xchg   %ax,%ax
80105f60:	83 c3 01             	add    $0x1,%ebx
80105f63:	83 fb 10             	cmp    $0x10,%ebx
80105f66:	0f 84 ac 00 00 00    	je     80106018 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105f6c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f70:	85 d2                	test   %edx,%edx
80105f72:	75 ec                	jne    80105f60 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f74:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f77:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105f7b:	56                   	push   %esi
80105f7c:	e8 8f bb ff ff       	call   80101b10 <iunlock>
  end_op();
80105f81:	e8 3a d6 ff ff       	call   801035c0 <end_op>

  f->type = FD_INODE;
80105f86:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f8f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f92:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105f95:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f9c:	89 d0                	mov    %edx,%eax
80105f9e:	f7 d0                	not    %eax
80105fa0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fa3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105fa6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fa9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105fad:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fb0:	89 d8                	mov    %ebx,%eax
80105fb2:	5b                   	pop    %ebx
80105fb3:	5e                   	pop    %esi
80105fb4:	5f                   	pop    %edi
80105fb5:	5d                   	pop    %ebp
80105fb6:	c3                   	ret    
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105fc0:	6a 00                	push   $0x0
80105fc2:	6a 00                	push   $0x0
80105fc4:	6a 02                	push   $0x2
80105fc6:	ff 75 e0             	pushl  -0x20(%ebp)
80105fc9:	e8 52 fd ff ff       	call   80105d20 <create>
    if(ip == 0){
80105fce:	83 c4 10             	add    $0x10,%esp
80105fd1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105fd3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105fd5:	0f 85 6b ff ff ff    	jne    80105f46 <sys_open+0x76>
      end_op();
80105fdb:	e8 e0 d5 ff ff       	call   801035c0 <end_op>
      return -1;
80105fe0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fe5:	eb c6                	jmp    80105fad <sys_open+0xdd>
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ff0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ff3:	85 c9                	test   %ecx,%ecx
80105ff5:	0f 84 4b ff ff ff    	je     80105f46 <sys_open+0x76>
    iunlockput(ip);
80105ffb:	83 ec 0c             	sub    $0xc,%esp
80105ffe:	56                   	push   %esi
80105fff:	e8 bc bc ff ff       	call   80101cc0 <iunlockput>
    end_op();
80106004:	e8 b7 d5 ff ff       	call   801035c0 <end_op>
    return -1;
80106009:	83 c4 10             	add    $0x10,%esp
8010600c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106011:	eb 9a                	jmp    80105fad <sys_open+0xdd>
80106013:	90                   	nop
80106014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80106018:	83 ec 0c             	sub    $0xc,%esp
8010601b:	57                   	push   %edi
8010601c:	e8 cf b1 ff ff       	call   801011f0 <fileclose>
80106021:	83 c4 10             	add    $0x10,%esp
80106024:	eb d5                	jmp    80105ffb <sys_open+0x12b>
80106026:	8d 76 00             	lea    0x0(%esi),%esi
80106029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106030 <sys_mkdir>:

int
sys_mkdir(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106036:	e8 15 d5 ff ff       	call   80103550 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010603b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010603e:	83 ec 08             	sub    $0x8,%esp
80106041:	50                   	push   %eax
80106042:	6a 00                	push   $0x0
80106044:	e8 97 f6 ff ff       	call   801056e0 <argstr>
80106049:	83 c4 10             	add    $0x10,%esp
8010604c:	85 c0                	test   %eax,%eax
8010604e:	78 30                	js     80106080 <sys_mkdir+0x50>
80106050:	6a 00                	push   $0x0
80106052:	6a 00                	push   $0x0
80106054:	6a 01                	push   $0x1
80106056:	ff 75 f4             	pushl  -0xc(%ebp)
80106059:	e8 c2 fc ff ff       	call   80105d20 <create>
8010605e:	83 c4 10             	add    $0x10,%esp
80106061:	85 c0                	test   %eax,%eax
80106063:	74 1b                	je     80106080 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106065:	83 ec 0c             	sub    $0xc,%esp
80106068:	50                   	push   %eax
80106069:	e8 52 bc ff ff       	call   80101cc0 <iunlockput>
  end_op();
8010606e:	e8 4d d5 ff ff       	call   801035c0 <end_op>
  return 0;
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	31 c0                	xor    %eax,%eax
}
80106078:	c9                   	leave  
80106079:	c3                   	ret    
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106080:	e8 3b d5 ff ff       	call   801035c0 <end_op>
    return -1;
80106085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010608a:	c9                   	leave  
8010608b:	c3                   	ret    
8010608c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106090 <sys_mknod>:

int
sys_mknod(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106096:	e8 b5 d4 ff ff       	call   80103550 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010609b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010609e:	83 ec 08             	sub    $0x8,%esp
801060a1:	50                   	push   %eax
801060a2:	6a 00                	push   $0x0
801060a4:	e8 37 f6 ff ff       	call   801056e0 <argstr>
801060a9:	83 c4 10             	add    $0x10,%esp
801060ac:	85 c0                	test   %eax,%eax
801060ae:	78 60                	js     80106110 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801060b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060b3:	83 ec 08             	sub    $0x8,%esp
801060b6:	50                   	push   %eax
801060b7:	6a 01                	push   $0x1
801060b9:	e8 72 f5 ff ff       	call   80105630 <argint>
  if((argstr(0, &path)) < 0 ||
801060be:	83 c4 10             	add    $0x10,%esp
801060c1:	85 c0                	test   %eax,%eax
801060c3:	78 4b                	js     80106110 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801060c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060c8:	83 ec 08             	sub    $0x8,%esp
801060cb:	50                   	push   %eax
801060cc:	6a 02                	push   $0x2
801060ce:	e8 5d f5 ff ff       	call   80105630 <argint>
     argint(1, &major) < 0 ||
801060d3:	83 c4 10             	add    $0x10,%esp
801060d6:	85 c0                	test   %eax,%eax
801060d8:	78 36                	js     80106110 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801060da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801060de:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801060df:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801060e3:	50                   	push   %eax
801060e4:	6a 03                	push   $0x3
801060e6:	ff 75 ec             	pushl  -0x14(%ebp)
801060e9:	e8 32 fc ff ff       	call   80105d20 <create>
801060ee:	83 c4 10             	add    $0x10,%esp
801060f1:	85 c0                	test   %eax,%eax
801060f3:	74 1b                	je     80106110 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801060f5:	83 ec 0c             	sub    $0xc,%esp
801060f8:	50                   	push   %eax
801060f9:	e8 c2 bb ff ff       	call   80101cc0 <iunlockput>
  end_op();
801060fe:	e8 bd d4 ff ff       	call   801035c0 <end_op>
  return 0;
80106103:	83 c4 10             	add    $0x10,%esp
80106106:	31 c0                	xor    %eax,%eax
}
80106108:	c9                   	leave  
80106109:	c3                   	ret    
8010610a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106110:	e8 ab d4 ff ff       	call   801035c0 <end_op>
    return -1;
80106115:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010611a:	c9                   	leave  
8010611b:	c3                   	ret    
8010611c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106120 <sys_chdir>:

int
sys_chdir(void)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	56                   	push   %esi
80106124:	53                   	push   %ebx
80106125:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106128:	e8 93 e1 ff ff       	call   801042c0 <myproc>
8010612d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010612f:	e8 1c d4 ff ff       	call   80103550 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106134:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106137:	83 ec 08             	sub    $0x8,%esp
8010613a:	50                   	push   %eax
8010613b:	6a 00                	push   $0x0
8010613d:	e8 9e f5 ff ff       	call   801056e0 <argstr>
80106142:	83 c4 10             	add    $0x10,%esp
80106145:	85 c0                	test   %eax,%eax
80106147:	78 77                	js     801061c0 <sys_chdir+0xa0>
80106149:	83 ec 0c             	sub    $0xc,%esp
8010614c:	ff 75 f4             	pushl  -0xc(%ebp)
8010614f:	e8 3c c1 ff ff       	call   80102290 <namei>
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	85 c0                	test   %eax,%eax
80106159:	89 c3                	mov    %eax,%ebx
8010615b:	74 63                	je     801061c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010615d:	83 ec 0c             	sub    $0xc,%esp
80106160:	50                   	push   %eax
80106161:	e8 ca b8 ff ff       	call   80101a30 <ilock>
  if(ip->type != T_DIR){
80106166:	83 c4 10             	add    $0x10,%esp
80106169:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010616e:	75 30                	jne    801061a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	53                   	push   %ebx
80106174:	e8 97 b9 ff ff       	call   80101b10 <iunlock>
  iput(curproc->cwd);
80106179:	58                   	pop    %eax
8010617a:	ff 76 68             	pushl  0x68(%esi)
8010617d:	e8 de b9 ff ff       	call   80101b60 <iput>
  end_op();
80106182:	e8 39 d4 ff ff       	call   801035c0 <end_op>
  curproc->cwd = ip;
80106187:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010618a:	83 c4 10             	add    $0x10,%esp
8010618d:	31 c0                	xor    %eax,%eax
}
8010618f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106192:	5b                   	pop    %ebx
80106193:	5e                   	pop    %esi
80106194:	5d                   	pop    %ebp
80106195:	c3                   	ret    
80106196:	8d 76 00             	lea    0x0(%esi),%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801061a0:	83 ec 0c             	sub    $0xc,%esp
801061a3:	53                   	push   %ebx
801061a4:	e8 17 bb ff ff       	call   80101cc0 <iunlockput>
    end_op();
801061a9:	e8 12 d4 ff ff       	call   801035c0 <end_op>
    return -1;
801061ae:	83 c4 10             	add    $0x10,%esp
801061b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061b6:	eb d7                	jmp    8010618f <sys_chdir+0x6f>
801061b8:	90                   	nop
801061b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801061c0:	e8 fb d3 ff ff       	call   801035c0 <end_op>
    return -1;
801061c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061ca:	eb c3                	jmp    8010618f <sys_chdir+0x6f>
801061cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061d0 <sys_exec>:

int
sys_exec(void)
{
801061d0:	55                   	push   %ebp
801061d1:	89 e5                	mov    %esp,%ebp
801061d3:	57                   	push   %edi
801061d4:	56                   	push   %esi
801061d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801061dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061e2:	50                   	push   %eax
801061e3:	6a 00                	push   $0x0
801061e5:	e8 f6 f4 ff ff       	call   801056e0 <argstr>
801061ea:	83 c4 10             	add    $0x10,%esp
801061ed:	85 c0                	test   %eax,%eax
801061ef:	0f 88 87 00 00 00    	js     8010627c <sys_exec+0xac>
801061f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801061fb:	83 ec 08             	sub    $0x8,%esp
801061fe:	50                   	push   %eax
801061ff:	6a 01                	push   $0x1
80106201:	e8 2a f4 ff ff       	call   80105630 <argint>
80106206:	83 c4 10             	add    $0x10,%esp
80106209:	85 c0                	test   %eax,%eax
8010620b:	78 6f                	js     8010627c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010620d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106213:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106216:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106218:	68 80 00 00 00       	push   $0x80
8010621d:	6a 00                	push   $0x0
8010621f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106225:	50                   	push   %eax
80106226:	e8 05 f1 ff ff       	call   80105330 <memset>
8010622b:	83 c4 10             	add    $0x10,%esp
8010622e:	eb 2c                	jmp    8010625c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106230:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106236:	85 c0                	test   %eax,%eax
80106238:	74 56                	je     80106290 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010623a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106240:	83 ec 08             	sub    $0x8,%esp
80106243:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106246:	52                   	push   %edx
80106247:	50                   	push   %eax
80106248:	e8 73 f3 ff ff       	call   801055c0 <fetchstr>
8010624d:	83 c4 10             	add    $0x10,%esp
80106250:	85 c0                	test   %eax,%eax
80106252:	78 28                	js     8010627c <sys_exec+0xac>
  for(i=0;; i++){
80106254:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106257:	83 fb 20             	cmp    $0x20,%ebx
8010625a:	74 20                	je     8010627c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010625c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106262:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106269:	83 ec 08             	sub    $0x8,%esp
8010626c:	57                   	push   %edi
8010626d:	01 f0                	add    %esi,%eax
8010626f:	50                   	push   %eax
80106270:	e8 0b f3 ff ff       	call   80105580 <fetchint>
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	85 c0                	test   %eax,%eax
8010627a:	79 b4                	jns    80106230 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010627c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010627f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106284:	5b                   	pop    %ebx
80106285:	5e                   	pop    %esi
80106286:	5f                   	pop    %edi
80106287:	5d                   	pop    %ebp
80106288:	c3                   	ret    
80106289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106290:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106296:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106299:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801062a0:	00 00 00 00 
  return exec(path, argv);
801062a4:	50                   	push   %eax
801062a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801062ab:	e8 b0 a9 ff ff       	call   80100c60 <exec>
801062b0:	83 c4 10             	add    $0x10,%esp
}
801062b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062b6:	5b                   	pop    %ebx
801062b7:	5e                   	pop    %esi
801062b8:	5f                   	pop    %edi
801062b9:	5d                   	pop    %ebp
801062ba:	c3                   	ret    
801062bb:	90                   	nop
801062bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062c0 <sys_pipe>:

int
sys_pipe(void)
{
801062c0:	55                   	push   %ebp
801062c1:	89 e5                	mov    %esp,%ebp
801062c3:	57                   	push   %edi
801062c4:	56                   	push   %esi
801062c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801062c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062cc:	6a 08                	push   $0x8
801062ce:	50                   	push   %eax
801062cf:	6a 00                	push   $0x0
801062d1:	e8 aa f3 ff ff       	call   80105680 <argptr>
801062d6:	83 c4 10             	add    $0x10,%esp
801062d9:	85 c0                	test   %eax,%eax
801062db:	0f 88 ae 00 00 00    	js     8010638f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801062e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062e4:	83 ec 08             	sub    $0x8,%esp
801062e7:	50                   	push   %eax
801062e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062eb:	50                   	push   %eax
801062ec:	e8 ff d8 ff ff       	call   80103bf0 <pipealloc>
801062f1:	83 c4 10             	add    $0x10,%esp
801062f4:	85 c0                	test   %eax,%eax
801062f6:	0f 88 93 00 00 00    	js     8010638f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801062ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106301:	e8 ba df ff ff       	call   801042c0 <myproc>
80106306:	eb 10                	jmp    80106318 <sys_pipe+0x58>
80106308:	90                   	nop
80106309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106310:	83 c3 01             	add    $0x1,%ebx
80106313:	83 fb 10             	cmp    $0x10,%ebx
80106316:	74 60                	je     80106378 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106318:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010631c:	85 f6                	test   %esi,%esi
8010631e:	75 f0                	jne    80106310 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106320:	8d 73 08             	lea    0x8(%ebx),%esi
80106323:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106327:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010632a:	e8 91 df ff ff       	call   801042c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010632f:	31 d2                	xor    %edx,%edx
80106331:	eb 0d                	jmp    80106340 <sys_pipe+0x80>
80106333:	90                   	nop
80106334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106338:	83 c2 01             	add    $0x1,%edx
8010633b:	83 fa 10             	cmp    $0x10,%edx
8010633e:	74 28                	je     80106368 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106340:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106344:	85 c9                	test   %ecx,%ecx
80106346:	75 f0                	jne    80106338 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106348:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010634c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010634f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106351:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106354:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106357:	31 c0                	xor    %eax,%eax
}
80106359:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010635c:	5b                   	pop    %ebx
8010635d:	5e                   	pop    %esi
8010635e:	5f                   	pop    %edi
8010635f:	5d                   	pop    %ebp
80106360:	c3                   	ret    
80106361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106368:	e8 53 df ff ff       	call   801042c0 <myproc>
8010636d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106374:	00 
80106375:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106378:	83 ec 0c             	sub    $0xc,%esp
8010637b:	ff 75 e0             	pushl  -0x20(%ebp)
8010637e:	e8 6d ae ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
80106383:	58                   	pop    %eax
80106384:	ff 75 e4             	pushl  -0x1c(%ebp)
80106387:	e8 64 ae ff ff       	call   801011f0 <fileclose>
    return -1;
8010638c:	83 c4 10             	add    $0x10,%esp
8010638f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106394:	eb c3                	jmp    80106359 <sys_pipe+0x99>
80106396:	66 90                	xchg   %ax,%ax
80106398:	66 90                	xchg   %ax,%ax
8010639a:	66 90                	xchg   %ax,%ax
8010639c:	66 90                	xchg   %ax,%ax
8010639e:	66 90                	xchg   %ax,%ax

801063a0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801063a3:	5d                   	pop    %ebp
  return fork();
801063a4:	e9 67 e1 ff ff       	jmp    80104510 <fork>
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063b0 <sys_exit>:

int
sys_exit(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
801063b3:	83 ec 08             	sub    $0x8,%esp
  exit();
801063b6:	e8 65 e5 ff ff       	call   80104920 <exit>
  return 0;  // not reached
}
801063bb:	31 c0                	xor    %eax,%eax
801063bd:	c9                   	leave  
801063be:	c3                   	ret    
801063bf:	90                   	nop

801063c0 <sys_wait>:

int
sys_wait(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801063c3:	5d                   	pop    %ebp
  return wait();
801063c4:	e9 c7 e7 ff ff       	jmp    80104b90 <wait>
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063d0 <sys_kill>:

int
sys_kill(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063d9:	50                   	push   %eax
801063da:	6a 00                	push   $0x0
801063dc:	e8 4f f2 ff ff       	call   80105630 <argint>
801063e1:	83 c4 10             	add    $0x10,%esp
801063e4:	85 c0                	test   %eax,%eax
801063e6:	78 18                	js     80106400 <sys_kill+0x30>
    return -1;
  return kill(pid);
801063e8:	83 ec 0c             	sub    $0xc,%esp
801063eb:	ff 75 f4             	pushl  -0xc(%ebp)
801063ee:	e8 7d e9 ff ff       	call   80104d70 <kill>
801063f3:	83 c4 10             	add    $0x10,%esp
}
801063f6:	c9                   	leave  
801063f7:	c3                   	ret    
801063f8:	90                   	nop
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106400:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106405:	c9                   	leave  
80106406:	c3                   	ret    
80106407:	89 f6                	mov    %esi,%esi
80106409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106410 <sys_getpid>:

int
sys_getpid(void)
{
80106410:	55                   	push   %ebp
80106411:	89 e5                	mov    %esp,%ebp
80106413:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106416:	e8 a5 de ff ff       	call   801042c0 <myproc>
8010641b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010641e:	c9                   	leave  
8010641f:	c3                   	ret    

80106420 <sys_sbrk>:

int
sys_sbrk(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106424:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106427:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010642a:	50                   	push   %eax
8010642b:	6a 00                	push   $0x0
8010642d:	e8 fe f1 ff ff       	call   80105630 <argint>
80106432:	83 c4 10             	add    $0x10,%esp
80106435:	85 c0                	test   %eax,%eax
80106437:	78 27                	js     80106460 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106439:	e8 82 de ff ff       	call   801042c0 <myproc>
  if(growproc(n) < 0)
8010643e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106441:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106443:	ff 75 f4             	pushl  -0xc(%ebp)
80106446:	e8 95 df ff ff       	call   801043e0 <growproc>
8010644b:	83 c4 10             	add    $0x10,%esp
8010644e:	85 c0                	test   %eax,%eax
80106450:	78 0e                	js     80106460 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106452:	89 d8                	mov    %ebx,%eax
80106454:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106457:	c9                   	leave  
80106458:	c3                   	ret    
80106459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106460:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106465:	eb eb                	jmp    80106452 <sys_sbrk+0x32>
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106470 <sys_sleep>:

int
sys_sleep(void)
{
80106470:	55                   	push   %ebp
80106471:	89 e5                	mov    %esp,%ebp
80106473:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106474:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106477:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010647a:	50                   	push   %eax
8010647b:	6a 00                	push   $0x0
8010647d:	e8 ae f1 ff ff       	call   80105630 <argint>
80106482:	83 c4 10             	add    $0x10,%esp
80106485:	85 c0                	test   %eax,%eax
80106487:	0f 88 8a 00 00 00    	js     80106517 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	68 40 6d 19 80       	push   $0x80196d40
80106495:	e8 86 ed ff ff       	call   80105220 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010649a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010649d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064a0:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  while(ticks - ticks0 < n){
801064a6:	85 d2                	test   %edx,%edx
801064a8:	75 27                	jne    801064d1 <sys_sleep+0x61>
801064aa:	eb 54                	jmp    80106500 <sys_sleep+0x90>
801064ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801064b0:	83 ec 08             	sub    $0x8,%esp
801064b3:	68 40 6d 19 80       	push   $0x80196d40
801064b8:	68 80 75 19 80       	push   $0x80197580
801064bd:	e8 0e e6 ff ff       	call   80104ad0 <sleep>
  while(ticks - ticks0 < n){
801064c2:	a1 80 75 19 80       	mov    0x80197580,%eax
801064c7:	83 c4 10             	add    $0x10,%esp
801064ca:	29 d8                	sub    %ebx,%eax
801064cc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064cf:	73 2f                	jae    80106500 <sys_sleep+0x90>
    if(myproc()->killed){
801064d1:	e8 ea dd ff ff       	call   801042c0 <myproc>
801064d6:	8b 40 24             	mov    0x24(%eax),%eax
801064d9:	85 c0                	test   %eax,%eax
801064db:	74 d3                	je     801064b0 <sys_sleep+0x40>
      release(&tickslock);
801064dd:	83 ec 0c             	sub    $0xc,%esp
801064e0:	68 40 6d 19 80       	push   $0x80196d40
801064e5:	e8 f6 ed ff ff       	call   801052e0 <release>
      return -1;
801064ea:	83 c4 10             	add    $0x10,%esp
801064ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801064f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064f5:	c9                   	leave  
801064f6:	c3                   	ret    
801064f7:	89 f6                	mov    %esi,%esi
801064f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106500:	83 ec 0c             	sub    $0xc,%esp
80106503:	68 40 6d 19 80       	push   $0x80196d40
80106508:	e8 d3 ed ff ff       	call   801052e0 <release>
  return 0;
8010650d:	83 c4 10             	add    $0x10,%esp
80106510:	31 c0                	xor    %eax,%eax
}
80106512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106515:	c9                   	leave  
80106516:	c3                   	ret    
    return -1;
80106517:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010651c:	eb f4                	jmp    80106512 <sys_sleep+0xa2>
8010651e:	66 90                	xchg   %ax,%ax

80106520 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	53                   	push   %ebx
80106524:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106527:	68 40 6d 19 80       	push   $0x80196d40
8010652c:	e8 ef ec ff ff       	call   80105220 <acquire>
  xticks = ticks;
80106531:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
80106537:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
8010653e:	e8 9d ed ff ff       	call   801052e0 <release>
  return xticks;
}
80106543:	89 d8                	mov    %ebx,%eax
80106545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106548:	c9                   	leave  
80106549:	c3                   	ret    
8010654a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106550 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106556:	e8 65 dd ff ff       	call   801042c0 <myproc>
8010655b:	ba 10 00 00 00       	mov    $0x10,%edx
80106560:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80106566:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106567:	89 d0                	mov    %edx,%eax
}
80106569:	c3                   	ret    
8010656a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106570 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80106573:	5d                   	pop    %ebp
  return getTotalFreePages();
80106574:	e9 d7 e8 ff ff       	jmp    80104e50 <getTotalFreePages>

80106579 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106579:	1e                   	push   %ds
  pushl %es
8010657a:	06                   	push   %es
  pushl %fs
8010657b:	0f a0                	push   %fs
  pushl %gs
8010657d:	0f a8                	push   %gs
  pushal
8010657f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106580:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106584:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106586:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106588:	54                   	push   %esp
  call trap
80106589:	e8 c2 00 00 00       	call   80106650 <trap>
  addl $4, %esp
8010658e:	83 c4 04             	add    $0x4,%esp

80106591 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106591:	61                   	popa   
  popl %gs
80106592:	0f a9                	pop    %gs
  popl %fs
80106594:	0f a1                	pop    %fs
  popl %es
80106596:	07                   	pop    %es
  popl %ds
80106597:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106598:	83 c4 08             	add    $0x8,%esp
  iret
8010659b:	cf                   	iret   
8010659c:	66 90                	xchg   %ax,%ax
8010659e:	66 90                	xchg   %ax,%ax

801065a0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065a0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801065a1:	31 c0                	xor    %eax,%eax
{
801065a3:	89 e5                	mov    %esp,%ebp
801065a5:	83 ec 08             	sub    $0x8,%esp
801065a8:	90                   	nop
801065a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065b0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801065b7:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
801065be:	08 00 00 8e 
801065c2:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
801065c9:	80 
801065ca:	c1 ea 10             	shr    $0x10,%edx
801065cd:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
801065d4:	80 
  for(i = 0; i < 256; i++)
801065d5:	83 c0 01             	add    $0x1,%eax
801065d8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065dd:	75 d1                	jne    801065b0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065df:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
801065e4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065e7:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
801065ee:	00 00 ef 
  initlock(&tickslock, "time");
801065f1:	68 3d 98 10 80       	push   $0x8010983d
801065f6:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065fb:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
80106601:	c1 e8 10             	shr    $0x10,%eax
80106604:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
8010660a:	e8 d1 ea ff ff       	call   801050e0 <initlock>
}
8010660f:	83 c4 10             	add    $0x10,%esp
80106612:	c9                   	leave  
80106613:	c3                   	ret    
80106614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010661a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106620 <idtinit>:

void
idtinit(void)
{
80106620:	55                   	push   %ebp
  pd[0] = size-1;
80106621:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106626:	89 e5                	mov    %esp,%ebp
80106628:	83 ec 10             	sub    $0x10,%esp
8010662b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010662f:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
80106634:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106638:	c1 e8 10             	shr    $0x10,%eax
8010663b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010663f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106642:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106645:	c9                   	leave  
80106646:	c3                   	ret    
80106647:	89 f6                	mov    %esi,%esi
80106649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106650 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	57                   	push   %edi
80106654:	56                   	push   %esi
80106655:	53                   	push   %ebx
80106656:	83 ec 1c             	sub    $0x1c,%esp
80106659:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
8010665c:	e8 5f dc ff ff       	call   801042c0 <myproc>
80106661:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106663:	8b 47 30             	mov    0x30(%edi),%eax
80106666:	83 f8 40             	cmp    $0x40,%eax
80106669:	0f 84 e9 00 00 00    	je     80106758 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010666f:	83 e8 0e             	sub    $0xe,%eax
80106672:	83 f8 31             	cmp    $0x31,%eax
80106675:	77 09                	ja     80106680 <trap+0x30>
80106677:	ff 24 85 e4 98 10 80 	jmp    *-0x7fef671c(,%eax,4)
8010667e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106680:	e8 3b dc ff ff       	call   801042c0 <myproc>
80106685:	85 c0                	test   %eax,%eax
80106687:	0f 84 27 02 00 00    	je     801068b4 <trap+0x264>
8010668d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106691:	0f 84 1d 02 00 00    	je     801068b4 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106697:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010669a:	8b 57 38             	mov    0x38(%edi),%edx
8010669d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801066a0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801066a3:	e8 f8 db ff ff       	call   801042a0 <cpuid>
801066a8:	8b 77 34             	mov    0x34(%edi),%esi
801066ab:	8b 5f 30             	mov    0x30(%edi),%ebx
801066ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066b1:	e8 0a dc ff ff       	call   801042c0 <myproc>
801066b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066b9:	e8 02 dc ff ff       	call   801042c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066be:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066c4:	51                   	push   %ecx
801066c5:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801066c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066c9:	ff 75 e4             	pushl  -0x1c(%ebp)
801066cc:	56                   	push   %esi
801066cd:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
801066ce:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066d1:	52                   	push   %edx
801066d2:	ff 70 10             	pushl  0x10(%eax)
801066d5:	68 a0 98 10 80       	push   $0x801098a0
801066da:	e8 81 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066df:	83 c4 20             	add    $0x20,%esp
801066e2:	e8 d9 db ff ff       	call   801042c0 <myproc>
801066e7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801066ee:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066f0:	e8 cb db ff ff       	call   801042c0 <myproc>
801066f5:	85 c0                	test   %eax,%eax
801066f7:	74 1d                	je     80106716 <trap+0xc6>
801066f9:	e8 c2 db ff ff       	call   801042c0 <myproc>
801066fe:	8b 50 24             	mov    0x24(%eax),%edx
80106701:	85 d2                	test   %edx,%edx
80106703:	74 11                	je     80106716 <trap+0xc6>
80106705:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106709:	83 e0 03             	and    $0x3,%eax
8010670c:	66 83 f8 03          	cmp    $0x3,%ax
80106710:	0f 84 5a 01 00 00    	je     80106870 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106716:	e8 a5 db ff ff       	call   801042c0 <myproc>
8010671b:	85 c0                	test   %eax,%eax
8010671d:	74 0b                	je     8010672a <trap+0xda>
8010671f:	e8 9c db ff ff       	call   801042c0 <myproc>
80106724:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106728:	74 5e                	je     80106788 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010672a:	e8 91 db ff ff       	call   801042c0 <myproc>
8010672f:	85 c0                	test   %eax,%eax
80106731:	74 19                	je     8010674c <trap+0xfc>
80106733:	e8 88 db ff ff       	call   801042c0 <myproc>
80106738:	8b 40 24             	mov    0x24(%eax),%eax
8010673b:	85 c0                	test   %eax,%eax
8010673d:	74 0d                	je     8010674c <trap+0xfc>
8010673f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106743:	83 e0 03             	and    $0x3,%eax
80106746:	66 83 f8 03          	cmp    $0x3,%ax
8010674a:	74 2b                	je     80106777 <trap+0x127>
    exit();
8010674c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010674f:	5b                   	pop    %ebx
80106750:	5e                   	pop    %esi
80106751:	5f                   	pop    %edi
80106752:	5d                   	pop    %ebp
80106753:	c3                   	ret    
80106754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106758:	8b 73 24             	mov    0x24(%ebx),%esi
8010675b:	85 f6                	test   %esi,%esi
8010675d:	0f 85 fd 00 00 00    	jne    80106860 <trap+0x210>
    curproc->tf = tf;
80106763:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106766:	e8 b5 ef ff ff       	call   80105720 <syscall>
    if(myproc()->killed)
8010676b:	e8 50 db ff ff       	call   801042c0 <myproc>
80106770:	8b 58 24             	mov    0x24(%eax),%ebx
80106773:	85 db                	test   %ebx,%ebx
80106775:	74 d5                	je     8010674c <trap+0xfc>
80106777:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010677a:	5b                   	pop    %ebx
8010677b:	5e                   	pop    %esi
8010677c:	5f                   	pop    %edi
8010677d:	5d                   	pop    %ebp
      exit();
8010677e:	e9 9d e1 ff ff       	jmp    80104920 <exit>
80106783:	90                   	nop
80106784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106788:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010678c:	75 9c                	jne    8010672a <trap+0xda>
      if(myproc()->pid > 2) 
8010678e:	e8 2d db ff ff       	call   801042c0 <myproc>
      yield();
80106793:	e8 e8 e2 ff ff       	call   80104a80 <yield>
80106798:	eb 90                	jmp    8010672a <trap+0xda>
8010679a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
801067a0:	e8 1b db ff ff       	call   801042c0 <myproc>
801067a5:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801067a9:	0f 8e 41 ff ff ff    	jle    801066f0 <trap+0xa0>
    pagefault();
801067af:	e8 0c 25 00 00       	call   80108cc0 <pagefault>
      if(curproc->killed) {
801067b4:	8b 4b 24             	mov    0x24(%ebx),%ecx
801067b7:	85 c9                	test   %ecx,%ecx
801067b9:	0f 84 31 ff ff ff    	je     801066f0 <trap+0xa0>
        exit();
801067bf:	e8 5c e1 ff ff       	call   80104920 <exit>
801067c4:	e9 27 ff ff ff       	jmp    801066f0 <trap+0xa0>
801067c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801067d0:	e8 cb da ff ff       	call   801042a0 <cpuid>
801067d5:	85 c0                	test   %eax,%eax
801067d7:	0f 84 a3 00 00 00    	je     80106880 <trap+0x230>
    lapiceoi();
801067dd:	e8 1e c9 ff ff       	call   80103100 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067e2:	e8 d9 da ff ff       	call   801042c0 <myproc>
801067e7:	85 c0                	test   %eax,%eax
801067e9:	0f 85 0a ff ff ff    	jne    801066f9 <trap+0xa9>
801067ef:	e9 22 ff ff ff       	jmp    80106716 <trap+0xc6>
801067f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801067f8:	e8 c3 c7 ff ff       	call   80102fc0 <kbdintr>
    lapiceoi();
801067fd:	e8 fe c8 ff ff       	call   80103100 <lapiceoi>
    break;
80106802:	e9 e9 fe ff ff       	jmp    801066f0 <trap+0xa0>
80106807:	89 f6                	mov    %esi,%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80106810:	e8 3b 02 00 00       	call   80106a50 <uartintr>
    lapiceoi();
80106815:	e8 e6 c8 ff ff       	call   80103100 <lapiceoi>
    break;
8010681a:	e9 d1 fe ff ff       	jmp    801066f0 <trap+0xa0>
8010681f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106820:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106824:	8b 77 38             	mov    0x38(%edi),%esi
80106827:	e8 74 da ff ff       	call   801042a0 <cpuid>
8010682c:	56                   	push   %esi
8010682d:	53                   	push   %ebx
8010682e:	50                   	push   %eax
8010682f:	68 48 98 10 80       	push   $0x80109848
80106834:	e8 27 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106839:	e8 c2 c8 ff ff       	call   80103100 <lapiceoi>
    break;
8010683e:	83 c4 10             	add    $0x10,%esp
80106841:	e9 aa fe ff ff       	jmp    801066f0 <trap+0xa0>
80106846:	8d 76 00             	lea    0x0(%esi),%esi
80106849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106850:	e8 6b bf ff ff       	call   801027c0 <ideintr>
80106855:	eb 86                	jmp    801067dd <trap+0x18d>
80106857:	89 f6                	mov    %esi,%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106860:	e8 bb e0 ff ff       	call   80104920 <exit>
80106865:	e9 f9 fe ff ff       	jmp    80106763 <trap+0x113>
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106870:	e8 ab e0 ff ff       	call   80104920 <exit>
80106875:	e9 9c fe ff ff       	jmp    80106716 <trap+0xc6>
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106880:	83 ec 0c             	sub    $0xc,%esp
80106883:	68 40 6d 19 80       	push   $0x80196d40
80106888:	e8 93 e9 ff ff       	call   80105220 <acquire>
      wakeup(&ticks);
8010688d:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
80106894:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
8010689b:	e8 70 e4 ff ff       	call   80104d10 <wakeup>
      release(&tickslock);
801068a0:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
801068a7:	e8 34 ea ff ff       	call   801052e0 <release>
801068ac:	83 c4 10             	add    $0x10,%esp
801068af:	e9 29 ff ff ff       	jmp    801067dd <trap+0x18d>
801068b4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068b7:	8b 5f 38             	mov    0x38(%edi),%ebx
801068ba:	e8 e1 d9 ff ff       	call   801042a0 <cpuid>
801068bf:	83 ec 0c             	sub    $0xc,%esp
801068c2:	56                   	push   %esi
801068c3:	53                   	push   %ebx
801068c4:	50                   	push   %eax
801068c5:	ff 77 30             	pushl  0x30(%edi)
801068c8:	68 6c 98 10 80       	push   $0x8010986c
801068cd:	e8 8e 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
801068d2:	83 c4 14             	add    $0x14,%esp
801068d5:	68 42 98 10 80       	push   $0x80109842
801068da:	e8 b1 9a ff ff       	call   80100390 <panic>
801068df:	90                   	nop

801068e0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801068e0:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
801068e5:	55                   	push   %ebp
801068e6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801068e8:	85 c0                	test   %eax,%eax
801068ea:	74 1c                	je     80106908 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068ec:	ba fd 03 00 00       	mov    $0x3fd,%edx
801068f1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801068f2:	a8 01                	test   $0x1,%al
801068f4:	74 12                	je     80106908 <uartgetc+0x28>
801068f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068fb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801068fc:	0f b6 c0             	movzbl %al,%eax
}
801068ff:	5d                   	pop    %ebp
80106900:	c3                   	ret    
80106901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106908:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010690d:	5d                   	pop    %ebp
8010690e:	c3                   	ret    
8010690f:	90                   	nop

80106910 <uartputc.part.0>:
uartputc(int c)
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	89 c7                	mov    %eax,%edi
80106918:	bb 80 00 00 00       	mov    $0x80,%ebx
8010691d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106922:	83 ec 0c             	sub    $0xc,%esp
80106925:	eb 1b                	jmp    80106942 <uartputc.part.0+0x32>
80106927:	89 f6                	mov    %esi,%esi
80106929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106930:	83 ec 0c             	sub    $0xc,%esp
80106933:	6a 0a                	push   $0xa
80106935:	e8 e6 c7 ff ff       	call   80103120 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010693a:	83 c4 10             	add    $0x10,%esp
8010693d:	83 eb 01             	sub    $0x1,%ebx
80106940:	74 07                	je     80106949 <uartputc.part.0+0x39>
80106942:	89 f2                	mov    %esi,%edx
80106944:	ec                   	in     (%dx),%al
80106945:	a8 20                	test   $0x20,%al
80106947:	74 e7                	je     80106930 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106949:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010694e:	89 f8                	mov    %edi,%eax
80106950:	ee                   	out    %al,(%dx)
}
80106951:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106954:	5b                   	pop    %ebx
80106955:	5e                   	pop    %esi
80106956:	5f                   	pop    %edi
80106957:	5d                   	pop    %ebp
80106958:	c3                   	ret    
80106959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106960 <uartinit>:
{
80106960:	55                   	push   %ebp
80106961:	31 c9                	xor    %ecx,%ecx
80106963:	89 c8                	mov    %ecx,%eax
80106965:	89 e5                	mov    %esp,%ebp
80106967:	57                   	push   %edi
80106968:	56                   	push   %esi
80106969:	53                   	push   %ebx
8010696a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010696f:	89 da                	mov    %ebx,%edx
80106971:	83 ec 0c             	sub    $0xc,%esp
80106974:	ee                   	out    %al,(%dx)
80106975:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010697a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010697f:	89 fa                	mov    %edi,%edx
80106981:	ee                   	out    %al,(%dx)
80106982:	b8 0c 00 00 00       	mov    $0xc,%eax
80106987:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010698c:	ee                   	out    %al,(%dx)
8010698d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106992:	89 c8                	mov    %ecx,%eax
80106994:	89 f2                	mov    %esi,%edx
80106996:	ee                   	out    %al,(%dx)
80106997:	b8 03 00 00 00       	mov    $0x3,%eax
8010699c:	89 fa                	mov    %edi,%edx
8010699e:	ee                   	out    %al,(%dx)
8010699f:	ba fc 03 00 00       	mov    $0x3fc,%edx
801069a4:	89 c8                	mov    %ecx,%eax
801069a6:	ee                   	out    %al,(%dx)
801069a7:	b8 01 00 00 00       	mov    $0x1,%eax
801069ac:	89 f2                	mov    %esi,%edx
801069ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069af:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069b4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801069b5:	3c ff                	cmp    $0xff,%al
801069b7:	74 5a                	je     80106a13 <uartinit+0xb3>
  uart = 1;
801069b9:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
801069c0:	00 00 00 
801069c3:	89 da                	mov    %ebx,%edx
801069c5:	ec                   	in     (%dx),%al
801069c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069cb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801069cc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801069cf:	bb ac 99 10 80       	mov    $0x801099ac,%ebx
  ioapicenable(IRQ_COM1, 0);
801069d4:	6a 00                	push   $0x0
801069d6:	6a 04                	push   $0x4
801069d8:	e8 33 c0 ff ff       	call   80102a10 <ioapicenable>
801069dd:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801069e0:	b8 78 00 00 00       	mov    $0x78,%eax
801069e5:	eb 13                	jmp    801069fa <uartinit+0x9a>
801069e7:	89 f6                	mov    %esi,%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069f0:	83 c3 01             	add    $0x1,%ebx
801069f3:	0f be 03             	movsbl (%ebx),%eax
801069f6:	84 c0                	test   %al,%al
801069f8:	74 19                	je     80106a13 <uartinit+0xb3>
  if(!uart)
801069fa:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
80106a00:	85 d2                	test   %edx,%edx
80106a02:	74 ec                	je     801069f0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106a04:	83 c3 01             	add    $0x1,%ebx
80106a07:	e8 04 ff ff ff       	call   80106910 <uartputc.part.0>
80106a0c:	0f be 03             	movsbl (%ebx),%eax
80106a0f:	84 c0                	test   %al,%al
80106a11:	75 e7                	jne    801069fa <uartinit+0x9a>
}
80106a13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a16:	5b                   	pop    %ebx
80106a17:	5e                   	pop    %esi
80106a18:	5f                   	pop    %edi
80106a19:	5d                   	pop    %ebp
80106a1a:	c3                   	ret    
80106a1b:	90                   	nop
80106a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a20 <uartputc>:
  if(!uart)
80106a20:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
80106a26:	55                   	push   %ebp
80106a27:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106a29:	85 d2                	test   %edx,%edx
{
80106a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106a2e:	74 10                	je     80106a40 <uartputc+0x20>
}
80106a30:	5d                   	pop    %ebp
80106a31:	e9 da fe ff ff       	jmp    80106910 <uartputc.part.0>
80106a36:	8d 76 00             	lea    0x0(%esi),%esi
80106a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a40:	5d                   	pop    %ebp
80106a41:	c3                   	ret    
80106a42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a50 <uartintr>:

void
uartintr(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106a56:	68 e0 68 10 80       	push   $0x801068e0
80106a5b:	e8 b0 9d ff ff       	call   80100810 <consoleintr>
}
80106a60:	83 c4 10             	add    $0x10,%esp
80106a63:	c9                   	leave  
80106a64:	c3                   	ret    

80106a65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a65:	6a 00                	push   $0x0
  pushl $0
80106a67:	6a 00                	push   $0x0
  jmp alltraps
80106a69:	e9 0b fb ff ff       	jmp    80106579 <alltraps>

80106a6e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a6e:	6a 00                	push   $0x0
  pushl $1
80106a70:	6a 01                	push   $0x1
  jmp alltraps
80106a72:	e9 02 fb ff ff       	jmp    80106579 <alltraps>

80106a77 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $2
80106a79:	6a 02                	push   $0x2
  jmp alltraps
80106a7b:	e9 f9 fa ff ff       	jmp    80106579 <alltraps>

80106a80 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a80:	6a 00                	push   $0x0
  pushl $3
80106a82:	6a 03                	push   $0x3
  jmp alltraps
80106a84:	e9 f0 fa ff ff       	jmp    80106579 <alltraps>

80106a89 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a89:	6a 00                	push   $0x0
  pushl $4
80106a8b:	6a 04                	push   $0x4
  jmp alltraps
80106a8d:	e9 e7 fa ff ff       	jmp    80106579 <alltraps>

80106a92 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a92:	6a 00                	push   $0x0
  pushl $5
80106a94:	6a 05                	push   $0x5
  jmp alltraps
80106a96:	e9 de fa ff ff       	jmp    80106579 <alltraps>

80106a9b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $6
80106a9d:	6a 06                	push   $0x6
  jmp alltraps
80106a9f:	e9 d5 fa ff ff       	jmp    80106579 <alltraps>

80106aa4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106aa4:	6a 00                	push   $0x0
  pushl $7
80106aa6:	6a 07                	push   $0x7
  jmp alltraps
80106aa8:	e9 cc fa ff ff       	jmp    80106579 <alltraps>

80106aad <vector8>:
.globl vector8
vector8:
  pushl $8
80106aad:	6a 08                	push   $0x8
  jmp alltraps
80106aaf:	e9 c5 fa ff ff       	jmp    80106579 <alltraps>

80106ab4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $9
80106ab6:	6a 09                	push   $0x9
  jmp alltraps
80106ab8:	e9 bc fa ff ff       	jmp    80106579 <alltraps>

80106abd <vector10>:
.globl vector10
vector10:
  pushl $10
80106abd:	6a 0a                	push   $0xa
  jmp alltraps
80106abf:	e9 b5 fa ff ff       	jmp    80106579 <alltraps>

80106ac4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ac4:	6a 0b                	push   $0xb
  jmp alltraps
80106ac6:	e9 ae fa ff ff       	jmp    80106579 <alltraps>

80106acb <vector12>:
.globl vector12
vector12:
  pushl $12
80106acb:	6a 0c                	push   $0xc
  jmp alltraps
80106acd:	e9 a7 fa ff ff       	jmp    80106579 <alltraps>

80106ad2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ad2:	6a 0d                	push   $0xd
  jmp alltraps
80106ad4:	e9 a0 fa ff ff       	jmp    80106579 <alltraps>

80106ad9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ad9:	6a 0e                	push   $0xe
  jmp alltraps
80106adb:	e9 99 fa ff ff       	jmp    80106579 <alltraps>

80106ae0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ae0:	6a 00                	push   $0x0
  pushl $15
80106ae2:	6a 0f                	push   $0xf
  jmp alltraps
80106ae4:	e9 90 fa ff ff       	jmp    80106579 <alltraps>

80106ae9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ae9:	6a 00                	push   $0x0
  pushl $16
80106aeb:	6a 10                	push   $0x10
  jmp alltraps
80106aed:	e9 87 fa ff ff       	jmp    80106579 <alltraps>

80106af2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106af2:	6a 11                	push   $0x11
  jmp alltraps
80106af4:	e9 80 fa ff ff       	jmp    80106579 <alltraps>

80106af9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $18
80106afb:	6a 12                	push   $0x12
  jmp alltraps
80106afd:	e9 77 fa ff ff       	jmp    80106579 <alltraps>

80106b02 <vector19>:
.globl vector19
vector19:
  pushl $0
80106b02:	6a 00                	push   $0x0
  pushl $19
80106b04:	6a 13                	push   $0x13
  jmp alltraps
80106b06:	e9 6e fa ff ff       	jmp    80106579 <alltraps>

80106b0b <vector20>:
.globl vector20
vector20:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $20
80106b0d:	6a 14                	push   $0x14
  jmp alltraps
80106b0f:	e9 65 fa ff ff       	jmp    80106579 <alltraps>

80106b14 <vector21>:
.globl vector21
vector21:
  pushl $0
80106b14:	6a 00                	push   $0x0
  pushl $21
80106b16:	6a 15                	push   $0x15
  jmp alltraps
80106b18:	e9 5c fa ff ff       	jmp    80106579 <alltraps>

80106b1d <vector22>:
.globl vector22
vector22:
  pushl $0
80106b1d:	6a 00                	push   $0x0
  pushl $22
80106b1f:	6a 16                	push   $0x16
  jmp alltraps
80106b21:	e9 53 fa ff ff       	jmp    80106579 <alltraps>

80106b26 <vector23>:
.globl vector23
vector23:
  pushl $0
80106b26:	6a 00                	push   $0x0
  pushl $23
80106b28:	6a 17                	push   $0x17
  jmp alltraps
80106b2a:	e9 4a fa ff ff       	jmp    80106579 <alltraps>

80106b2f <vector24>:
.globl vector24
vector24:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $24
80106b31:	6a 18                	push   $0x18
  jmp alltraps
80106b33:	e9 41 fa ff ff       	jmp    80106579 <alltraps>

80106b38 <vector25>:
.globl vector25
vector25:
  pushl $0
80106b38:	6a 00                	push   $0x0
  pushl $25
80106b3a:	6a 19                	push   $0x19
  jmp alltraps
80106b3c:	e9 38 fa ff ff       	jmp    80106579 <alltraps>

80106b41 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b41:	6a 00                	push   $0x0
  pushl $26
80106b43:	6a 1a                	push   $0x1a
  jmp alltraps
80106b45:	e9 2f fa ff ff       	jmp    80106579 <alltraps>

80106b4a <vector27>:
.globl vector27
vector27:
  pushl $0
80106b4a:	6a 00                	push   $0x0
  pushl $27
80106b4c:	6a 1b                	push   $0x1b
  jmp alltraps
80106b4e:	e9 26 fa ff ff       	jmp    80106579 <alltraps>

80106b53 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $28
80106b55:	6a 1c                	push   $0x1c
  jmp alltraps
80106b57:	e9 1d fa ff ff       	jmp    80106579 <alltraps>

80106b5c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b5c:	6a 00                	push   $0x0
  pushl $29
80106b5e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b60:	e9 14 fa ff ff       	jmp    80106579 <alltraps>

80106b65 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b65:	6a 00                	push   $0x0
  pushl $30
80106b67:	6a 1e                	push   $0x1e
  jmp alltraps
80106b69:	e9 0b fa ff ff       	jmp    80106579 <alltraps>

80106b6e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b6e:	6a 00                	push   $0x0
  pushl $31
80106b70:	6a 1f                	push   $0x1f
  jmp alltraps
80106b72:	e9 02 fa ff ff       	jmp    80106579 <alltraps>

80106b77 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $32
80106b79:	6a 20                	push   $0x20
  jmp alltraps
80106b7b:	e9 f9 f9 ff ff       	jmp    80106579 <alltraps>

80106b80 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b80:	6a 00                	push   $0x0
  pushl $33
80106b82:	6a 21                	push   $0x21
  jmp alltraps
80106b84:	e9 f0 f9 ff ff       	jmp    80106579 <alltraps>

80106b89 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b89:	6a 00                	push   $0x0
  pushl $34
80106b8b:	6a 22                	push   $0x22
  jmp alltraps
80106b8d:	e9 e7 f9 ff ff       	jmp    80106579 <alltraps>

80106b92 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b92:	6a 00                	push   $0x0
  pushl $35
80106b94:	6a 23                	push   $0x23
  jmp alltraps
80106b96:	e9 de f9 ff ff       	jmp    80106579 <alltraps>

80106b9b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $36
80106b9d:	6a 24                	push   $0x24
  jmp alltraps
80106b9f:	e9 d5 f9 ff ff       	jmp    80106579 <alltraps>

80106ba4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106ba4:	6a 00                	push   $0x0
  pushl $37
80106ba6:	6a 25                	push   $0x25
  jmp alltraps
80106ba8:	e9 cc f9 ff ff       	jmp    80106579 <alltraps>

80106bad <vector38>:
.globl vector38
vector38:
  pushl $0
80106bad:	6a 00                	push   $0x0
  pushl $38
80106baf:	6a 26                	push   $0x26
  jmp alltraps
80106bb1:	e9 c3 f9 ff ff       	jmp    80106579 <alltraps>

80106bb6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106bb6:	6a 00                	push   $0x0
  pushl $39
80106bb8:	6a 27                	push   $0x27
  jmp alltraps
80106bba:	e9 ba f9 ff ff       	jmp    80106579 <alltraps>

80106bbf <vector40>:
.globl vector40
vector40:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $40
80106bc1:	6a 28                	push   $0x28
  jmp alltraps
80106bc3:	e9 b1 f9 ff ff       	jmp    80106579 <alltraps>

80106bc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106bc8:	6a 00                	push   $0x0
  pushl $41
80106bca:	6a 29                	push   $0x29
  jmp alltraps
80106bcc:	e9 a8 f9 ff ff       	jmp    80106579 <alltraps>

80106bd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106bd1:	6a 00                	push   $0x0
  pushl $42
80106bd3:	6a 2a                	push   $0x2a
  jmp alltraps
80106bd5:	e9 9f f9 ff ff       	jmp    80106579 <alltraps>

80106bda <vector43>:
.globl vector43
vector43:
  pushl $0
80106bda:	6a 00                	push   $0x0
  pushl $43
80106bdc:	6a 2b                	push   $0x2b
  jmp alltraps
80106bde:	e9 96 f9 ff ff       	jmp    80106579 <alltraps>

80106be3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $44
80106be5:	6a 2c                	push   $0x2c
  jmp alltraps
80106be7:	e9 8d f9 ff ff       	jmp    80106579 <alltraps>

80106bec <vector45>:
.globl vector45
vector45:
  pushl $0
80106bec:	6a 00                	push   $0x0
  pushl $45
80106bee:	6a 2d                	push   $0x2d
  jmp alltraps
80106bf0:	e9 84 f9 ff ff       	jmp    80106579 <alltraps>

80106bf5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106bf5:	6a 00                	push   $0x0
  pushl $46
80106bf7:	6a 2e                	push   $0x2e
  jmp alltraps
80106bf9:	e9 7b f9 ff ff       	jmp    80106579 <alltraps>

80106bfe <vector47>:
.globl vector47
vector47:
  pushl $0
80106bfe:	6a 00                	push   $0x0
  pushl $47
80106c00:	6a 2f                	push   $0x2f
  jmp alltraps
80106c02:	e9 72 f9 ff ff       	jmp    80106579 <alltraps>

80106c07 <vector48>:
.globl vector48
vector48:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $48
80106c09:	6a 30                	push   $0x30
  jmp alltraps
80106c0b:	e9 69 f9 ff ff       	jmp    80106579 <alltraps>

80106c10 <vector49>:
.globl vector49
vector49:
  pushl $0
80106c10:	6a 00                	push   $0x0
  pushl $49
80106c12:	6a 31                	push   $0x31
  jmp alltraps
80106c14:	e9 60 f9 ff ff       	jmp    80106579 <alltraps>

80106c19 <vector50>:
.globl vector50
vector50:
  pushl $0
80106c19:	6a 00                	push   $0x0
  pushl $50
80106c1b:	6a 32                	push   $0x32
  jmp alltraps
80106c1d:	e9 57 f9 ff ff       	jmp    80106579 <alltraps>

80106c22 <vector51>:
.globl vector51
vector51:
  pushl $0
80106c22:	6a 00                	push   $0x0
  pushl $51
80106c24:	6a 33                	push   $0x33
  jmp alltraps
80106c26:	e9 4e f9 ff ff       	jmp    80106579 <alltraps>

80106c2b <vector52>:
.globl vector52
vector52:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $52
80106c2d:	6a 34                	push   $0x34
  jmp alltraps
80106c2f:	e9 45 f9 ff ff       	jmp    80106579 <alltraps>

80106c34 <vector53>:
.globl vector53
vector53:
  pushl $0
80106c34:	6a 00                	push   $0x0
  pushl $53
80106c36:	6a 35                	push   $0x35
  jmp alltraps
80106c38:	e9 3c f9 ff ff       	jmp    80106579 <alltraps>

80106c3d <vector54>:
.globl vector54
vector54:
  pushl $0
80106c3d:	6a 00                	push   $0x0
  pushl $54
80106c3f:	6a 36                	push   $0x36
  jmp alltraps
80106c41:	e9 33 f9 ff ff       	jmp    80106579 <alltraps>

80106c46 <vector55>:
.globl vector55
vector55:
  pushl $0
80106c46:	6a 00                	push   $0x0
  pushl $55
80106c48:	6a 37                	push   $0x37
  jmp alltraps
80106c4a:	e9 2a f9 ff ff       	jmp    80106579 <alltraps>

80106c4f <vector56>:
.globl vector56
vector56:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $56
80106c51:	6a 38                	push   $0x38
  jmp alltraps
80106c53:	e9 21 f9 ff ff       	jmp    80106579 <alltraps>

80106c58 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c58:	6a 00                	push   $0x0
  pushl $57
80106c5a:	6a 39                	push   $0x39
  jmp alltraps
80106c5c:	e9 18 f9 ff ff       	jmp    80106579 <alltraps>

80106c61 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c61:	6a 00                	push   $0x0
  pushl $58
80106c63:	6a 3a                	push   $0x3a
  jmp alltraps
80106c65:	e9 0f f9 ff ff       	jmp    80106579 <alltraps>

80106c6a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c6a:	6a 00                	push   $0x0
  pushl $59
80106c6c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c6e:	e9 06 f9 ff ff       	jmp    80106579 <alltraps>

80106c73 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $60
80106c75:	6a 3c                	push   $0x3c
  jmp alltraps
80106c77:	e9 fd f8 ff ff       	jmp    80106579 <alltraps>

80106c7c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c7c:	6a 00                	push   $0x0
  pushl $61
80106c7e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c80:	e9 f4 f8 ff ff       	jmp    80106579 <alltraps>

80106c85 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c85:	6a 00                	push   $0x0
  pushl $62
80106c87:	6a 3e                	push   $0x3e
  jmp alltraps
80106c89:	e9 eb f8 ff ff       	jmp    80106579 <alltraps>

80106c8e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c8e:	6a 00                	push   $0x0
  pushl $63
80106c90:	6a 3f                	push   $0x3f
  jmp alltraps
80106c92:	e9 e2 f8 ff ff       	jmp    80106579 <alltraps>

80106c97 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $64
80106c99:	6a 40                	push   $0x40
  jmp alltraps
80106c9b:	e9 d9 f8 ff ff       	jmp    80106579 <alltraps>

80106ca0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $65
80106ca2:	6a 41                	push   $0x41
  jmp alltraps
80106ca4:	e9 d0 f8 ff ff       	jmp    80106579 <alltraps>

80106ca9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $66
80106cab:	6a 42                	push   $0x42
  jmp alltraps
80106cad:	e9 c7 f8 ff ff       	jmp    80106579 <alltraps>

80106cb2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $67
80106cb4:	6a 43                	push   $0x43
  jmp alltraps
80106cb6:	e9 be f8 ff ff       	jmp    80106579 <alltraps>

80106cbb <vector68>:
.globl vector68
vector68:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $68
80106cbd:	6a 44                	push   $0x44
  jmp alltraps
80106cbf:	e9 b5 f8 ff ff       	jmp    80106579 <alltraps>

80106cc4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $69
80106cc6:	6a 45                	push   $0x45
  jmp alltraps
80106cc8:	e9 ac f8 ff ff       	jmp    80106579 <alltraps>

80106ccd <vector70>:
.globl vector70
vector70:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $70
80106ccf:	6a 46                	push   $0x46
  jmp alltraps
80106cd1:	e9 a3 f8 ff ff       	jmp    80106579 <alltraps>

80106cd6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $71
80106cd8:	6a 47                	push   $0x47
  jmp alltraps
80106cda:	e9 9a f8 ff ff       	jmp    80106579 <alltraps>

80106cdf <vector72>:
.globl vector72
vector72:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $72
80106ce1:	6a 48                	push   $0x48
  jmp alltraps
80106ce3:	e9 91 f8 ff ff       	jmp    80106579 <alltraps>

80106ce8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106ce8:	6a 00                	push   $0x0
  pushl $73
80106cea:	6a 49                	push   $0x49
  jmp alltraps
80106cec:	e9 88 f8 ff ff       	jmp    80106579 <alltraps>

80106cf1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106cf1:	6a 00                	push   $0x0
  pushl $74
80106cf3:	6a 4a                	push   $0x4a
  jmp alltraps
80106cf5:	e9 7f f8 ff ff       	jmp    80106579 <alltraps>

80106cfa <vector75>:
.globl vector75
vector75:
  pushl $0
80106cfa:	6a 00                	push   $0x0
  pushl $75
80106cfc:	6a 4b                	push   $0x4b
  jmp alltraps
80106cfe:	e9 76 f8 ff ff       	jmp    80106579 <alltraps>

80106d03 <vector76>:
.globl vector76
vector76:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $76
80106d05:	6a 4c                	push   $0x4c
  jmp alltraps
80106d07:	e9 6d f8 ff ff       	jmp    80106579 <alltraps>

80106d0c <vector77>:
.globl vector77
vector77:
  pushl $0
80106d0c:	6a 00                	push   $0x0
  pushl $77
80106d0e:	6a 4d                	push   $0x4d
  jmp alltraps
80106d10:	e9 64 f8 ff ff       	jmp    80106579 <alltraps>

80106d15 <vector78>:
.globl vector78
vector78:
  pushl $0
80106d15:	6a 00                	push   $0x0
  pushl $78
80106d17:	6a 4e                	push   $0x4e
  jmp alltraps
80106d19:	e9 5b f8 ff ff       	jmp    80106579 <alltraps>

80106d1e <vector79>:
.globl vector79
vector79:
  pushl $0
80106d1e:	6a 00                	push   $0x0
  pushl $79
80106d20:	6a 4f                	push   $0x4f
  jmp alltraps
80106d22:	e9 52 f8 ff ff       	jmp    80106579 <alltraps>

80106d27 <vector80>:
.globl vector80
vector80:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $80
80106d29:	6a 50                	push   $0x50
  jmp alltraps
80106d2b:	e9 49 f8 ff ff       	jmp    80106579 <alltraps>

80106d30 <vector81>:
.globl vector81
vector81:
  pushl $0
80106d30:	6a 00                	push   $0x0
  pushl $81
80106d32:	6a 51                	push   $0x51
  jmp alltraps
80106d34:	e9 40 f8 ff ff       	jmp    80106579 <alltraps>

80106d39 <vector82>:
.globl vector82
vector82:
  pushl $0
80106d39:	6a 00                	push   $0x0
  pushl $82
80106d3b:	6a 52                	push   $0x52
  jmp alltraps
80106d3d:	e9 37 f8 ff ff       	jmp    80106579 <alltraps>

80106d42 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d42:	6a 00                	push   $0x0
  pushl $83
80106d44:	6a 53                	push   $0x53
  jmp alltraps
80106d46:	e9 2e f8 ff ff       	jmp    80106579 <alltraps>

80106d4b <vector84>:
.globl vector84
vector84:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $84
80106d4d:	6a 54                	push   $0x54
  jmp alltraps
80106d4f:	e9 25 f8 ff ff       	jmp    80106579 <alltraps>

80106d54 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d54:	6a 00                	push   $0x0
  pushl $85
80106d56:	6a 55                	push   $0x55
  jmp alltraps
80106d58:	e9 1c f8 ff ff       	jmp    80106579 <alltraps>

80106d5d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d5d:	6a 00                	push   $0x0
  pushl $86
80106d5f:	6a 56                	push   $0x56
  jmp alltraps
80106d61:	e9 13 f8 ff ff       	jmp    80106579 <alltraps>

80106d66 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d66:	6a 00                	push   $0x0
  pushl $87
80106d68:	6a 57                	push   $0x57
  jmp alltraps
80106d6a:	e9 0a f8 ff ff       	jmp    80106579 <alltraps>

80106d6f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $88
80106d71:	6a 58                	push   $0x58
  jmp alltraps
80106d73:	e9 01 f8 ff ff       	jmp    80106579 <alltraps>

80106d78 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d78:	6a 00                	push   $0x0
  pushl $89
80106d7a:	6a 59                	push   $0x59
  jmp alltraps
80106d7c:	e9 f8 f7 ff ff       	jmp    80106579 <alltraps>

80106d81 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d81:	6a 00                	push   $0x0
  pushl $90
80106d83:	6a 5a                	push   $0x5a
  jmp alltraps
80106d85:	e9 ef f7 ff ff       	jmp    80106579 <alltraps>

80106d8a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d8a:	6a 00                	push   $0x0
  pushl $91
80106d8c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d8e:	e9 e6 f7 ff ff       	jmp    80106579 <alltraps>

80106d93 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $92
80106d95:	6a 5c                	push   $0x5c
  jmp alltraps
80106d97:	e9 dd f7 ff ff       	jmp    80106579 <alltraps>

80106d9c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d9c:	6a 00                	push   $0x0
  pushl $93
80106d9e:	6a 5d                	push   $0x5d
  jmp alltraps
80106da0:	e9 d4 f7 ff ff       	jmp    80106579 <alltraps>

80106da5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106da5:	6a 00                	push   $0x0
  pushl $94
80106da7:	6a 5e                	push   $0x5e
  jmp alltraps
80106da9:	e9 cb f7 ff ff       	jmp    80106579 <alltraps>

80106dae <vector95>:
.globl vector95
vector95:
  pushl $0
80106dae:	6a 00                	push   $0x0
  pushl $95
80106db0:	6a 5f                	push   $0x5f
  jmp alltraps
80106db2:	e9 c2 f7 ff ff       	jmp    80106579 <alltraps>

80106db7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $96
80106db9:	6a 60                	push   $0x60
  jmp alltraps
80106dbb:	e9 b9 f7 ff ff       	jmp    80106579 <alltraps>

80106dc0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106dc0:	6a 00                	push   $0x0
  pushl $97
80106dc2:	6a 61                	push   $0x61
  jmp alltraps
80106dc4:	e9 b0 f7 ff ff       	jmp    80106579 <alltraps>

80106dc9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106dc9:	6a 00                	push   $0x0
  pushl $98
80106dcb:	6a 62                	push   $0x62
  jmp alltraps
80106dcd:	e9 a7 f7 ff ff       	jmp    80106579 <alltraps>

80106dd2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106dd2:	6a 00                	push   $0x0
  pushl $99
80106dd4:	6a 63                	push   $0x63
  jmp alltraps
80106dd6:	e9 9e f7 ff ff       	jmp    80106579 <alltraps>

80106ddb <vector100>:
.globl vector100
vector100:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $100
80106ddd:	6a 64                	push   $0x64
  jmp alltraps
80106ddf:	e9 95 f7 ff ff       	jmp    80106579 <alltraps>

80106de4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106de4:	6a 00                	push   $0x0
  pushl $101
80106de6:	6a 65                	push   $0x65
  jmp alltraps
80106de8:	e9 8c f7 ff ff       	jmp    80106579 <alltraps>

80106ded <vector102>:
.globl vector102
vector102:
  pushl $0
80106ded:	6a 00                	push   $0x0
  pushl $102
80106def:	6a 66                	push   $0x66
  jmp alltraps
80106df1:	e9 83 f7 ff ff       	jmp    80106579 <alltraps>

80106df6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106df6:	6a 00                	push   $0x0
  pushl $103
80106df8:	6a 67                	push   $0x67
  jmp alltraps
80106dfa:	e9 7a f7 ff ff       	jmp    80106579 <alltraps>

80106dff <vector104>:
.globl vector104
vector104:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $104
80106e01:	6a 68                	push   $0x68
  jmp alltraps
80106e03:	e9 71 f7 ff ff       	jmp    80106579 <alltraps>

80106e08 <vector105>:
.globl vector105
vector105:
  pushl $0
80106e08:	6a 00                	push   $0x0
  pushl $105
80106e0a:	6a 69                	push   $0x69
  jmp alltraps
80106e0c:	e9 68 f7 ff ff       	jmp    80106579 <alltraps>

80106e11 <vector106>:
.globl vector106
vector106:
  pushl $0
80106e11:	6a 00                	push   $0x0
  pushl $106
80106e13:	6a 6a                	push   $0x6a
  jmp alltraps
80106e15:	e9 5f f7 ff ff       	jmp    80106579 <alltraps>

80106e1a <vector107>:
.globl vector107
vector107:
  pushl $0
80106e1a:	6a 00                	push   $0x0
  pushl $107
80106e1c:	6a 6b                	push   $0x6b
  jmp alltraps
80106e1e:	e9 56 f7 ff ff       	jmp    80106579 <alltraps>

80106e23 <vector108>:
.globl vector108
vector108:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $108
80106e25:	6a 6c                	push   $0x6c
  jmp alltraps
80106e27:	e9 4d f7 ff ff       	jmp    80106579 <alltraps>

80106e2c <vector109>:
.globl vector109
vector109:
  pushl $0
80106e2c:	6a 00                	push   $0x0
  pushl $109
80106e2e:	6a 6d                	push   $0x6d
  jmp alltraps
80106e30:	e9 44 f7 ff ff       	jmp    80106579 <alltraps>

80106e35 <vector110>:
.globl vector110
vector110:
  pushl $0
80106e35:	6a 00                	push   $0x0
  pushl $110
80106e37:	6a 6e                	push   $0x6e
  jmp alltraps
80106e39:	e9 3b f7 ff ff       	jmp    80106579 <alltraps>

80106e3e <vector111>:
.globl vector111
vector111:
  pushl $0
80106e3e:	6a 00                	push   $0x0
  pushl $111
80106e40:	6a 6f                	push   $0x6f
  jmp alltraps
80106e42:	e9 32 f7 ff ff       	jmp    80106579 <alltraps>

80106e47 <vector112>:
.globl vector112
vector112:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $112
80106e49:	6a 70                	push   $0x70
  jmp alltraps
80106e4b:	e9 29 f7 ff ff       	jmp    80106579 <alltraps>

80106e50 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e50:	6a 00                	push   $0x0
  pushl $113
80106e52:	6a 71                	push   $0x71
  jmp alltraps
80106e54:	e9 20 f7 ff ff       	jmp    80106579 <alltraps>

80106e59 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e59:	6a 00                	push   $0x0
  pushl $114
80106e5b:	6a 72                	push   $0x72
  jmp alltraps
80106e5d:	e9 17 f7 ff ff       	jmp    80106579 <alltraps>

80106e62 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e62:	6a 00                	push   $0x0
  pushl $115
80106e64:	6a 73                	push   $0x73
  jmp alltraps
80106e66:	e9 0e f7 ff ff       	jmp    80106579 <alltraps>

80106e6b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $116
80106e6d:	6a 74                	push   $0x74
  jmp alltraps
80106e6f:	e9 05 f7 ff ff       	jmp    80106579 <alltraps>

80106e74 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e74:	6a 00                	push   $0x0
  pushl $117
80106e76:	6a 75                	push   $0x75
  jmp alltraps
80106e78:	e9 fc f6 ff ff       	jmp    80106579 <alltraps>

80106e7d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e7d:	6a 00                	push   $0x0
  pushl $118
80106e7f:	6a 76                	push   $0x76
  jmp alltraps
80106e81:	e9 f3 f6 ff ff       	jmp    80106579 <alltraps>

80106e86 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e86:	6a 00                	push   $0x0
  pushl $119
80106e88:	6a 77                	push   $0x77
  jmp alltraps
80106e8a:	e9 ea f6 ff ff       	jmp    80106579 <alltraps>

80106e8f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $120
80106e91:	6a 78                	push   $0x78
  jmp alltraps
80106e93:	e9 e1 f6 ff ff       	jmp    80106579 <alltraps>

80106e98 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e98:	6a 00                	push   $0x0
  pushl $121
80106e9a:	6a 79                	push   $0x79
  jmp alltraps
80106e9c:	e9 d8 f6 ff ff       	jmp    80106579 <alltraps>

80106ea1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ea1:	6a 00                	push   $0x0
  pushl $122
80106ea3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ea5:	e9 cf f6 ff ff       	jmp    80106579 <alltraps>

80106eaa <vector123>:
.globl vector123
vector123:
  pushl $0
80106eaa:	6a 00                	push   $0x0
  pushl $123
80106eac:	6a 7b                	push   $0x7b
  jmp alltraps
80106eae:	e9 c6 f6 ff ff       	jmp    80106579 <alltraps>

80106eb3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $124
80106eb5:	6a 7c                	push   $0x7c
  jmp alltraps
80106eb7:	e9 bd f6 ff ff       	jmp    80106579 <alltraps>

80106ebc <vector125>:
.globl vector125
vector125:
  pushl $0
80106ebc:	6a 00                	push   $0x0
  pushl $125
80106ebe:	6a 7d                	push   $0x7d
  jmp alltraps
80106ec0:	e9 b4 f6 ff ff       	jmp    80106579 <alltraps>

80106ec5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ec5:	6a 00                	push   $0x0
  pushl $126
80106ec7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ec9:	e9 ab f6 ff ff       	jmp    80106579 <alltraps>

80106ece <vector127>:
.globl vector127
vector127:
  pushl $0
80106ece:	6a 00                	push   $0x0
  pushl $127
80106ed0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ed2:	e9 a2 f6 ff ff       	jmp    80106579 <alltraps>

80106ed7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $128
80106ed9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106ede:	e9 96 f6 ff ff       	jmp    80106579 <alltraps>

80106ee3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $129
80106ee5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106eea:	e9 8a f6 ff ff       	jmp    80106579 <alltraps>

80106eef <vector130>:
.globl vector130
vector130:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $130
80106ef1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ef6:	e9 7e f6 ff ff       	jmp    80106579 <alltraps>

80106efb <vector131>:
.globl vector131
vector131:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $131
80106efd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106f02:	e9 72 f6 ff ff       	jmp    80106579 <alltraps>

80106f07 <vector132>:
.globl vector132
vector132:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $132
80106f09:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106f0e:	e9 66 f6 ff ff       	jmp    80106579 <alltraps>

80106f13 <vector133>:
.globl vector133
vector133:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $133
80106f15:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106f1a:	e9 5a f6 ff ff       	jmp    80106579 <alltraps>

80106f1f <vector134>:
.globl vector134
vector134:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $134
80106f21:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106f26:	e9 4e f6 ff ff       	jmp    80106579 <alltraps>

80106f2b <vector135>:
.globl vector135
vector135:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $135
80106f2d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106f32:	e9 42 f6 ff ff       	jmp    80106579 <alltraps>

80106f37 <vector136>:
.globl vector136
vector136:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $136
80106f39:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f3e:	e9 36 f6 ff ff       	jmp    80106579 <alltraps>

80106f43 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $137
80106f45:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f4a:	e9 2a f6 ff ff       	jmp    80106579 <alltraps>

80106f4f <vector138>:
.globl vector138
vector138:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $138
80106f51:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f56:	e9 1e f6 ff ff       	jmp    80106579 <alltraps>

80106f5b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $139
80106f5d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f62:	e9 12 f6 ff ff       	jmp    80106579 <alltraps>

80106f67 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $140
80106f69:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f6e:	e9 06 f6 ff ff       	jmp    80106579 <alltraps>

80106f73 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $141
80106f75:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f7a:	e9 fa f5 ff ff       	jmp    80106579 <alltraps>

80106f7f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $142
80106f81:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f86:	e9 ee f5 ff ff       	jmp    80106579 <alltraps>

80106f8b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $143
80106f8d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f92:	e9 e2 f5 ff ff       	jmp    80106579 <alltraps>

80106f97 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $144
80106f99:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f9e:	e9 d6 f5 ff ff       	jmp    80106579 <alltraps>

80106fa3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $145
80106fa5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106faa:	e9 ca f5 ff ff       	jmp    80106579 <alltraps>

80106faf <vector146>:
.globl vector146
vector146:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $146
80106fb1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106fb6:	e9 be f5 ff ff       	jmp    80106579 <alltraps>

80106fbb <vector147>:
.globl vector147
vector147:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $147
80106fbd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106fc2:	e9 b2 f5 ff ff       	jmp    80106579 <alltraps>

80106fc7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $148
80106fc9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106fce:	e9 a6 f5 ff ff       	jmp    80106579 <alltraps>

80106fd3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $149
80106fd5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106fda:	e9 9a f5 ff ff       	jmp    80106579 <alltraps>

80106fdf <vector150>:
.globl vector150
vector150:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $150
80106fe1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106fe6:	e9 8e f5 ff ff       	jmp    80106579 <alltraps>

80106feb <vector151>:
.globl vector151
vector151:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $151
80106fed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106ff2:	e9 82 f5 ff ff       	jmp    80106579 <alltraps>

80106ff7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $152
80106ff9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ffe:	e9 76 f5 ff ff       	jmp    80106579 <alltraps>

80107003 <vector153>:
.globl vector153
vector153:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $153
80107005:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010700a:	e9 6a f5 ff ff       	jmp    80106579 <alltraps>

8010700f <vector154>:
.globl vector154
vector154:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $154
80107011:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107016:	e9 5e f5 ff ff       	jmp    80106579 <alltraps>

8010701b <vector155>:
.globl vector155
vector155:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $155
8010701d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107022:	e9 52 f5 ff ff       	jmp    80106579 <alltraps>

80107027 <vector156>:
.globl vector156
vector156:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $156
80107029:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010702e:	e9 46 f5 ff ff       	jmp    80106579 <alltraps>

80107033 <vector157>:
.globl vector157
vector157:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $157
80107035:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010703a:	e9 3a f5 ff ff       	jmp    80106579 <alltraps>

8010703f <vector158>:
.globl vector158
vector158:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $158
80107041:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107046:	e9 2e f5 ff ff       	jmp    80106579 <alltraps>

8010704b <vector159>:
.globl vector159
vector159:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $159
8010704d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107052:	e9 22 f5 ff ff       	jmp    80106579 <alltraps>

80107057 <vector160>:
.globl vector160
vector160:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $160
80107059:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010705e:	e9 16 f5 ff ff       	jmp    80106579 <alltraps>

80107063 <vector161>:
.globl vector161
vector161:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $161
80107065:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010706a:	e9 0a f5 ff ff       	jmp    80106579 <alltraps>

8010706f <vector162>:
.globl vector162
vector162:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $162
80107071:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107076:	e9 fe f4 ff ff       	jmp    80106579 <alltraps>

8010707b <vector163>:
.globl vector163
vector163:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $163
8010707d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107082:	e9 f2 f4 ff ff       	jmp    80106579 <alltraps>

80107087 <vector164>:
.globl vector164
vector164:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $164
80107089:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010708e:	e9 e6 f4 ff ff       	jmp    80106579 <alltraps>

80107093 <vector165>:
.globl vector165
vector165:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $165
80107095:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010709a:	e9 da f4 ff ff       	jmp    80106579 <alltraps>

8010709f <vector166>:
.globl vector166
vector166:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $166
801070a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801070a6:	e9 ce f4 ff ff       	jmp    80106579 <alltraps>

801070ab <vector167>:
.globl vector167
vector167:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $167
801070ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801070b2:	e9 c2 f4 ff ff       	jmp    80106579 <alltraps>

801070b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $168
801070b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801070be:	e9 b6 f4 ff ff       	jmp    80106579 <alltraps>

801070c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $169
801070c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801070ca:	e9 aa f4 ff ff       	jmp    80106579 <alltraps>

801070cf <vector170>:
.globl vector170
vector170:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $170
801070d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801070d6:	e9 9e f4 ff ff       	jmp    80106579 <alltraps>

801070db <vector171>:
.globl vector171
vector171:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $171
801070dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801070e2:	e9 92 f4 ff ff       	jmp    80106579 <alltraps>

801070e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $172
801070e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070ee:	e9 86 f4 ff ff       	jmp    80106579 <alltraps>

801070f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $173
801070f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070fa:	e9 7a f4 ff ff       	jmp    80106579 <alltraps>

801070ff <vector174>:
.globl vector174
vector174:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $174
80107101:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107106:	e9 6e f4 ff ff       	jmp    80106579 <alltraps>

8010710b <vector175>:
.globl vector175
vector175:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $175
8010710d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107112:	e9 62 f4 ff ff       	jmp    80106579 <alltraps>

80107117 <vector176>:
.globl vector176
vector176:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $176
80107119:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010711e:	e9 56 f4 ff ff       	jmp    80106579 <alltraps>

80107123 <vector177>:
.globl vector177
vector177:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $177
80107125:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010712a:	e9 4a f4 ff ff       	jmp    80106579 <alltraps>

8010712f <vector178>:
.globl vector178
vector178:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $178
80107131:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107136:	e9 3e f4 ff ff       	jmp    80106579 <alltraps>

8010713b <vector179>:
.globl vector179
vector179:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $179
8010713d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107142:	e9 32 f4 ff ff       	jmp    80106579 <alltraps>

80107147 <vector180>:
.globl vector180
vector180:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $180
80107149:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010714e:	e9 26 f4 ff ff       	jmp    80106579 <alltraps>

80107153 <vector181>:
.globl vector181
vector181:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $181
80107155:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010715a:	e9 1a f4 ff ff       	jmp    80106579 <alltraps>

8010715f <vector182>:
.globl vector182
vector182:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $182
80107161:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107166:	e9 0e f4 ff ff       	jmp    80106579 <alltraps>

8010716b <vector183>:
.globl vector183
vector183:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $183
8010716d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107172:	e9 02 f4 ff ff       	jmp    80106579 <alltraps>

80107177 <vector184>:
.globl vector184
vector184:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $184
80107179:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010717e:	e9 f6 f3 ff ff       	jmp    80106579 <alltraps>

80107183 <vector185>:
.globl vector185
vector185:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $185
80107185:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010718a:	e9 ea f3 ff ff       	jmp    80106579 <alltraps>

8010718f <vector186>:
.globl vector186
vector186:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $186
80107191:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107196:	e9 de f3 ff ff       	jmp    80106579 <alltraps>

8010719b <vector187>:
.globl vector187
vector187:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $187
8010719d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801071a2:	e9 d2 f3 ff ff       	jmp    80106579 <alltraps>

801071a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $188
801071a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801071ae:	e9 c6 f3 ff ff       	jmp    80106579 <alltraps>

801071b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $189
801071b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801071ba:	e9 ba f3 ff ff       	jmp    80106579 <alltraps>

801071bf <vector190>:
.globl vector190
vector190:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $190
801071c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801071c6:	e9 ae f3 ff ff       	jmp    80106579 <alltraps>

801071cb <vector191>:
.globl vector191
vector191:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $191
801071cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801071d2:	e9 a2 f3 ff ff       	jmp    80106579 <alltraps>

801071d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $192
801071d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801071de:	e9 96 f3 ff ff       	jmp    80106579 <alltraps>

801071e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $193
801071e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071ea:	e9 8a f3 ff ff       	jmp    80106579 <alltraps>

801071ef <vector194>:
.globl vector194
vector194:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $194
801071f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071f6:	e9 7e f3 ff ff       	jmp    80106579 <alltraps>

801071fb <vector195>:
.globl vector195
vector195:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $195
801071fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107202:	e9 72 f3 ff ff       	jmp    80106579 <alltraps>

80107207 <vector196>:
.globl vector196
vector196:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $196
80107209:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010720e:	e9 66 f3 ff ff       	jmp    80106579 <alltraps>

80107213 <vector197>:
.globl vector197
vector197:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $197
80107215:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010721a:	e9 5a f3 ff ff       	jmp    80106579 <alltraps>

8010721f <vector198>:
.globl vector198
vector198:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $198
80107221:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107226:	e9 4e f3 ff ff       	jmp    80106579 <alltraps>

8010722b <vector199>:
.globl vector199
vector199:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $199
8010722d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107232:	e9 42 f3 ff ff       	jmp    80106579 <alltraps>

80107237 <vector200>:
.globl vector200
vector200:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $200
80107239:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010723e:	e9 36 f3 ff ff       	jmp    80106579 <alltraps>

80107243 <vector201>:
.globl vector201
vector201:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $201
80107245:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010724a:	e9 2a f3 ff ff       	jmp    80106579 <alltraps>

8010724f <vector202>:
.globl vector202
vector202:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $202
80107251:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107256:	e9 1e f3 ff ff       	jmp    80106579 <alltraps>

8010725b <vector203>:
.globl vector203
vector203:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $203
8010725d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107262:	e9 12 f3 ff ff       	jmp    80106579 <alltraps>

80107267 <vector204>:
.globl vector204
vector204:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $204
80107269:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010726e:	e9 06 f3 ff ff       	jmp    80106579 <alltraps>

80107273 <vector205>:
.globl vector205
vector205:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $205
80107275:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010727a:	e9 fa f2 ff ff       	jmp    80106579 <alltraps>

8010727f <vector206>:
.globl vector206
vector206:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $206
80107281:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107286:	e9 ee f2 ff ff       	jmp    80106579 <alltraps>

8010728b <vector207>:
.globl vector207
vector207:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $207
8010728d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107292:	e9 e2 f2 ff ff       	jmp    80106579 <alltraps>

80107297 <vector208>:
.globl vector208
vector208:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $208
80107299:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010729e:	e9 d6 f2 ff ff       	jmp    80106579 <alltraps>

801072a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $209
801072a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801072aa:	e9 ca f2 ff ff       	jmp    80106579 <alltraps>

801072af <vector210>:
.globl vector210
vector210:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $210
801072b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801072b6:	e9 be f2 ff ff       	jmp    80106579 <alltraps>

801072bb <vector211>:
.globl vector211
vector211:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $211
801072bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801072c2:	e9 b2 f2 ff ff       	jmp    80106579 <alltraps>

801072c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $212
801072c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801072ce:	e9 a6 f2 ff ff       	jmp    80106579 <alltraps>

801072d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $213
801072d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801072da:	e9 9a f2 ff ff       	jmp    80106579 <alltraps>

801072df <vector214>:
.globl vector214
vector214:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $214
801072e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801072e6:	e9 8e f2 ff ff       	jmp    80106579 <alltraps>

801072eb <vector215>:
.globl vector215
vector215:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $215
801072ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072f2:	e9 82 f2 ff ff       	jmp    80106579 <alltraps>

801072f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $216
801072f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072fe:	e9 76 f2 ff ff       	jmp    80106579 <alltraps>

80107303 <vector217>:
.globl vector217
vector217:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $217
80107305:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010730a:	e9 6a f2 ff ff       	jmp    80106579 <alltraps>

8010730f <vector218>:
.globl vector218
vector218:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $218
80107311:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107316:	e9 5e f2 ff ff       	jmp    80106579 <alltraps>

8010731b <vector219>:
.globl vector219
vector219:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $219
8010731d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107322:	e9 52 f2 ff ff       	jmp    80106579 <alltraps>

80107327 <vector220>:
.globl vector220
vector220:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $220
80107329:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010732e:	e9 46 f2 ff ff       	jmp    80106579 <alltraps>

80107333 <vector221>:
.globl vector221
vector221:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $221
80107335:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010733a:	e9 3a f2 ff ff       	jmp    80106579 <alltraps>

8010733f <vector222>:
.globl vector222
vector222:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $222
80107341:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107346:	e9 2e f2 ff ff       	jmp    80106579 <alltraps>

8010734b <vector223>:
.globl vector223
vector223:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $223
8010734d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107352:	e9 22 f2 ff ff       	jmp    80106579 <alltraps>

80107357 <vector224>:
.globl vector224
vector224:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $224
80107359:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010735e:	e9 16 f2 ff ff       	jmp    80106579 <alltraps>

80107363 <vector225>:
.globl vector225
vector225:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $225
80107365:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010736a:	e9 0a f2 ff ff       	jmp    80106579 <alltraps>

8010736f <vector226>:
.globl vector226
vector226:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $226
80107371:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107376:	e9 fe f1 ff ff       	jmp    80106579 <alltraps>

8010737b <vector227>:
.globl vector227
vector227:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $227
8010737d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107382:	e9 f2 f1 ff ff       	jmp    80106579 <alltraps>

80107387 <vector228>:
.globl vector228
vector228:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $228
80107389:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010738e:	e9 e6 f1 ff ff       	jmp    80106579 <alltraps>

80107393 <vector229>:
.globl vector229
vector229:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $229
80107395:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010739a:	e9 da f1 ff ff       	jmp    80106579 <alltraps>

8010739f <vector230>:
.globl vector230
vector230:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $230
801073a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801073a6:	e9 ce f1 ff ff       	jmp    80106579 <alltraps>

801073ab <vector231>:
.globl vector231
vector231:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $231
801073ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801073b2:	e9 c2 f1 ff ff       	jmp    80106579 <alltraps>

801073b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $232
801073b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801073be:	e9 b6 f1 ff ff       	jmp    80106579 <alltraps>

801073c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $233
801073c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801073ca:	e9 aa f1 ff ff       	jmp    80106579 <alltraps>

801073cf <vector234>:
.globl vector234
vector234:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $234
801073d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801073d6:	e9 9e f1 ff ff       	jmp    80106579 <alltraps>

801073db <vector235>:
.globl vector235
vector235:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $235
801073dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801073e2:	e9 92 f1 ff ff       	jmp    80106579 <alltraps>

801073e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $236
801073e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073ee:	e9 86 f1 ff ff       	jmp    80106579 <alltraps>

801073f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $237
801073f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073fa:	e9 7a f1 ff ff       	jmp    80106579 <alltraps>

801073ff <vector238>:
.globl vector238
vector238:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $238
80107401:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107406:	e9 6e f1 ff ff       	jmp    80106579 <alltraps>

8010740b <vector239>:
.globl vector239
vector239:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $239
8010740d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107412:	e9 62 f1 ff ff       	jmp    80106579 <alltraps>

80107417 <vector240>:
.globl vector240
vector240:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $240
80107419:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010741e:	e9 56 f1 ff ff       	jmp    80106579 <alltraps>

80107423 <vector241>:
.globl vector241
vector241:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $241
80107425:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010742a:	e9 4a f1 ff ff       	jmp    80106579 <alltraps>

8010742f <vector242>:
.globl vector242
vector242:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $242
80107431:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107436:	e9 3e f1 ff ff       	jmp    80106579 <alltraps>

8010743b <vector243>:
.globl vector243
vector243:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $243
8010743d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107442:	e9 32 f1 ff ff       	jmp    80106579 <alltraps>

80107447 <vector244>:
.globl vector244
vector244:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $244
80107449:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010744e:	e9 26 f1 ff ff       	jmp    80106579 <alltraps>

80107453 <vector245>:
.globl vector245
vector245:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $245
80107455:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010745a:	e9 1a f1 ff ff       	jmp    80106579 <alltraps>

8010745f <vector246>:
.globl vector246
vector246:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $246
80107461:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107466:	e9 0e f1 ff ff       	jmp    80106579 <alltraps>

8010746b <vector247>:
.globl vector247
vector247:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $247
8010746d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107472:	e9 02 f1 ff ff       	jmp    80106579 <alltraps>

80107477 <vector248>:
.globl vector248
vector248:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $248
80107479:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010747e:	e9 f6 f0 ff ff       	jmp    80106579 <alltraps>

80107483 <vector249>:
.globl vector249
vector249:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $249
80107485:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010748a:	e9 ea f0 ff ff       	jmp    80106579 <alltraps>

8010748f <vector250>:
.globl vector250
vector250:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $250
80107491:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107496:	e9 de f0 ff ff       	jmp    80106579 <alltraps>

8010749b <vector251>:
.globl vector251
vector251:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $251
8010749d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801074a2:	e9 d2 f0 ff ff       	jmp    80106579 <alltraps>

801074a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $252
801074a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801074ae:	e9 c6 f0 ff ff       	jmp    80106579 <alltraps>

801074b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $253
801074b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801074ba:	e9 ba f0 ff ff       	jmp    80106579 <alltraps>

801074bf <vector254>:
.globl vector254
vector254:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $254
801074c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801074c6:	e9 ae f0 ff ff       	jmp    80106579 <alltraps>

801074cb <vector255>:
.globl vector255
vector255:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $255
801074cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801074d2:	e9 a2 f0 ff ff       	jmp    80106579 <alltraps>
801074d7:	66 90                	xchg   %ax,%ax
801074d9:	66 90                	xchg   %ax,%ax
801074db:	66 90                	xchg   %ax,%ax
801074dd:	66 90                	xchg   %ax,%ax
801074df:	90                   	nop

801074e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801074e0:	55                   	push   %ebp
801074e1:	89 e5                	mov    %esp,%ebp
801074e3:	57                   	push   %edi
801074e4:	56                   	push   %esi
801074e5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801074e6:	89 d3                	mov    %edx,%ebx
{
801074e8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801074ea:	c1 eb 16             	shr    $0x16,%ebx
801074ed:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801074f0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801074f3:	8b 06                	mov    (%esi),%eax
801074f5:	a8 01                	test   $0x1,%al
801074f7:	74 27                	je     80107520 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074fe:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107504:	c1 ef 0a             	shr    $0xa,%edi
}
80107507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010750a:	89 fa                	mov    %edi,%edx
8010750c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107512:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107515:	5b                   	pop    %ebx
80107516:	5e                   	pop    %esi
80107517:	5f                   	pop    %edi
80107518:	5d                   	pop    %ebp
80107519:	c3                   	ret    
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107520:	85 c9                	test   %ecx,%ecx
80107522:	74 2c                	je     80107550 <walkpgdir+0x70>
80107524:	e8 07 b8 ff ff       	call   80102d30 <kalloc>
80107529:	85 c0                	test   %eax,%eax
8010752b:	89 c3                	mov    %eax,%ebx
8010752d:	74 21                	je     80107550 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010752f:	83 ec 04             	sub    $0x4,%esp
80107532:	68 00 10 00 00       	push   $0x1000
80107537:	6a 00                	push   $0x0
80107539:	50                   	push   %eax
8010753a:	e8 f1 dd ff ff       	call   80105330 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010753f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107545:	83 c4 10             	add    $0x10,%esp
80107548:	83 c8 07             	or     $0x7,%eax
8010754b:	89 06                	mov    %eax,(%esi)
8010754d:	eb b5                	jmp    80107504 <walkpgdir+0x24>
8010754f:	90                   	nop
}
80107550:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107553:	31 c0                	xor    %eax,%eax
}
80107555:	5b                   	pop    %ebx
80107556:	5e                   	pop    %esi
80107557:	5f                   	pop    %edi
80107558:	5d                   	pop    %ebp
80107559:	c3                   	ret    
8010755a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107560 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107560:	55                   	push   %ebp
80107561:	89 e5                	mov    %esp,%ebp
80107563:	57                   	push   %edi
80107564:	56                   	push   %esi
80107565:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107566:	89 d3                	mov    %edx,%ebx
80107568:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010756e:	83 ec 1c             	sub    $0x1c,%esp
80107571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107574:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107578:	8b 7d 08             	mov    0x8(%ebp),%edi
8010757b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107580:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107583:	8b 45 0c             	mov    0xc(%ebp),%eax
80107586:	29 df                	sub    %ebx,%edi
80107588:	83 c8 01             	or     $0x1,%eax
8010758b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010758e:	eb 15                	jmp    801075a5 <mappages+0x45>
    if(*pte & PTE_P)
80107590:	f6 00 01             	testb  $0x1,(%eax)
80107593:	75 45                	jne    801075da <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107595:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107598:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010759b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010759d:	74 31                	je     801075d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010759f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801075a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801075ad:	89 da                	mov    %ebx,%edx
801075af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801075b2:	e8 29 ff ff ff       	call   801074e0 <walkpgdir>
801075b7:	85 c0                	test   %eax,%eax
801075b9:	75 d5                	jne    80107590 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801075bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075c3:	5b                   	pop    %ebx
801075c4:	5e                   	pop    %esi
801075c5:	5f                   	pop    %edi
801075c6:	5d                   	pop    %ebp
801075c7:	c3                   	ret    
801075c8:	90                   	nop
801075c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075d3:	31 c0                	xor    %eax,%eax
}
801075d5:	5b                   	pop    %ebx
801075d6:	5e                   	pop    %esi
801075d7:	5f                   	pop    %edi
801075d8:	5d                   	pop    %ebp
801075d9:	c3                   	ret    
      panic("remap");
801075da:	83 ec 0c             	sub    $0xc,%esp
801075dd:	68 b4 99 10 80       	push   $0x801099b4
801075e2:	e8 a9 8d ff ff       	call   80100390 <panic>
801075e7:	89 f6                	mov    %esi,%esi
801075e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075f0 <printlist>:
{
801075f0:	55                   	push   %ebp
801075f1:	89 e5                	mov    %esp,%ebp
801075f3:	56                   	push   %esi
801075f4:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
801075f5:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
801075fa:	83 ec 0c             	sub    $0xc,%esp
801075fd:	68 ba 99 10 80       	push   $0x801099ba
80107602:	e8 59 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
80107607:	e8 b4 cc ff ff       	call   801042c0 <myproc>
8010760c:	83 c4 10             	add    $0x10,%esp
8010760f:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
80107615:	eb 0e                	jmp    80107625 <printlist+0x35>
80107617:	89 f6                	mov    %esi,%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107620:	83 ee 01             	sub    $0x1,%esi
80107623:	74 19                	je     8010763e <printlist+0x4e>
    cprintf("%d -> ", curr->off);
80107625:	83 ec 08             	sub    $0x8,%esp
80107628:	ff 33                	pushl  (%ebx)
8010762a:	68 ca 99 10 80       	push   $0x801099ca
8010762f:	e8 2c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107634:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107637:	83 c4 10             	add    $0x10,%esp
8010763a:	85 db                	test   %ebx,%ebx
8010763c:	75 e2                	jne    80107620 <printlist+0x30>
  cprintf("\n");
8010763e:	83 ec 0c             	sub    $0xc,%esp
80107641:	68 9b 9b 10 80       	push   $0x80109b9b
80107646:	e8 15 90 ff ff       	call   80100660 <cprintf>
}
8010764b:	83 c4 10             	add    $0x10,%esp
8010764e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107651:	5b                   	pop    %ebx
80107652:	5e                   	pop    %esi
80107653:	5d                   	pop    %ebp
80107654:	c3                   	ret    
80107655:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107660 <printaq>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	53                   	push   %ebx
80107664:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
80107667:	68 d1 99 10 80       	push   $0x801099d1
8010766c:	e8 ef 8f ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107671:	e8 4a cc ff ff       	call   801042c0 <myproc>
80107676:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010767c:	8b 58 08             	mov    0x8(%eax),%ebx
8010767f:	e8 3c cc ff ff       	call   801042c0 <myproc>
80107684:	83 c4 0c             	add    $0xc,%esp
80107687:	53                   	push   %ebx
80107688:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010768e:	ff 70 08             	pushl  0x8(%eax)
80107691:	68 e3 99 10 80       	push   $0x801099e3
80107696:	e8 c5 8f ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010769b:	e8 20 cc ff ff       	call   801042c0 <myproc>
801076a0:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
801076a6:	83 c4 10             	add    $0x10,%esp
801076a9:	8b 50 04             	mov    0x4(%eax),%edx
801076ac:	85 d2                	test   %edx,%edx
801076ae:	74 68                	je     80107718 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
801076b0:	e8 0b cc ff ff       	call   801042c0 <myproc>
801076b5:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
801076bb:	85 db                	test   %ebx,%ebx
801076bd:	74 1a                	je     801076d9 <printaq+0x79>
801076bf:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
801076c0:	83 ec 08             	sub    $0x8,%esp
801076c3:	ff 73 08             	pushl  0x8(%ebx)
801076c6:	68 01 9a 10 80       	push   $0x80109a01
801076cb:	e8 90 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801076d0:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
801076d2:	83 c4 10             	add    $0x10,%esp
801076d5:	85 db                	test   %ebx,%ebx
801076d7:	75 e7                	jne    801076c0 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
801076d9:	e8 e2 cb ff ff       	call   801042c0 <myproc>
801076de:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
801076e4:	8b 00                	mov    (%eax),%eax
801076e6:	85 c0                	test   %eax,%eax
801076e8:	74 16                	je     80107700 <printaq+0xa0>
  cprintf("\n");
801076ea:	83 ec 0c             	sub    $0xc,%esp
801076ed:	68 9b 9b 10 80       	push   $0x80109b9b
801076f2:	e8 69 8f ff ff       	call   80100660 <cprintf>
}
801076f7:	83 c4 10             	add    $0x10,%esp
801076fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076fd:	c9                   	leave  
801076fe:	c3                   	ret    
801076ff:	90                   	nop
    cprintf("null <-> ");
80107700:	83 ec 0c             	sub    $0xc,%esp
80107703:	68 f7 99 10 80       	push   $0x801099f7
80107708:	e8 53 8f ff ff       	call   80100660 <cprintf>
8010770d:	83 c4 10             	add    $0x10,%esp
80107710:	eb d8                	jmp    801076ea <printaq+0x8a>
80107712:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
80107718:	83 ec 0c             	sub    $0xc,%esp
8010771b:	68 f7 99 10 80       	push   $0x801099f7
80107720:	e8 3b 8f ff ff       	call   80100660 <cprintf>
80107725:	83 c4 10             	add    $0x10,%esp
80107728:	eb 86                	jmp    801076b0 <printaq+0x50>
8010772a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107730 <seginit>:
{
80107730:	55                   	push   %ebp
80107731:	89 e5                	mov    %esp,%ebp
80107733:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107736:	e8 65 cb ff ff       	call   801042a0 <cpuid>
8010773b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107741:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107746:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010774a:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
80107751:	ff 00 00 
80107754:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
8010775b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010775e:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
80107765:	ff 00 00 
80107768:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
8010776f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107772:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
80107779:	ff 00 00 
8010777c:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
80107783:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107786:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
8010778d:	ff 00 00 
80107790:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
80107797:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010779a:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
  pd[1] = (uint)p;
8010779f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801077a3:	c1 e8 10             	shr    $0x10,%eax
801077a6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077aa:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077ad:	0f 01 10             	lgdtl  (%eax)
}
801077b0:	c9                   	leave  
801077b1:	c3                   	ret    
801077b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077c0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c0:	a1 84 75 19 80       	mov    0x80197584,%eax
{
801077c5:	55                   	push   %ebp
801077c6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077cd:	0f 22 d8             	mov    %eax,%cr3
}
801077d0:	5d                   	pop    %ebp
801077d1:	c3                   	ret    
801077d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077e0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801077e0:	55                   	push   %ebp
801077e1:	89 e5                	mov    %esp,%ebp
801077e3:	57                   	push   %edi
801077e4:	56                   	push   %esi
801077e5:	53                   	push   %ebx
801077e6:	83 ec 1c             	sub    $0x1c,%esp
801077e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801077ec:	85 db                	test   %ebx,%ebx
801077ee:	0f 84 cb 00 00 00    	je     801078bf <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801077f4:	8b 43 08             	mov    0x8(%ebx),%eax
801077f7:	85 c0                	test   %eax,%eax
801077f9:	0f 84 da 00 00 00    	je     801078d9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801077ff:	8b 43 04             	mov    0x4(%ebx),%eax
80107802:	85 c0                	test   %eax,%eax
80107804:	0f 84 c2 00 00 00    	je     801078cc <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010780a:	e8 41 d9 ff ff       	call   80105150 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010780f:	e8 0c ca ff ff       	call   80104220 <mycpu>
80107814:	89 c6                	mov    %eax,%esi
80107816:	e8 05 ca ff ff       	call   80104220 <mycpu>
8010781b:	89 c7                	mov    %eax,%edi
8010781d:	e8 fe c9 ff ff       	call   80104220 <mycpu>
80107822:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107825:	83 c7 08             	add    $0x8,%edi
80107828:	e8 f3 c9 ff ff       	call   80104220 <mycpu>
8010782d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107830:	83 c0 08             	add    $0x8,%eax
80107833:	ba 67 00 00 00       	mov    $0x67,%edx
80107838:	c1 e8 18             	shr    $0x18,%eax
8010783b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107842:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107849:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010784f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107854:	83 c1 08             	add    $0x8,%ecx
80107857:	c1 e9 10             	shr    $0x10,%ecx
8010785a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107860:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107865:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010786c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107871:	e8 aa c9 ff ff       	call   80104220 <mycpu>
80107876:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010787d:	e8 9e c9 ff ff       	call   80104220 <mycpu>
80107882:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107886:	8b 73 08             	mov    0x8(%ebx),%esi
80107889:	e8 92 c9 ff ff       	call   80104220 <mycpu>
8010788e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107894:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107897:	e8 84 c9 ff ff       	call   80104220 <mycpu>
8010789c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801078a0:	b8 28 00 00 00       	mov    $0x28,%eax
801078a5:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801078a8:	8b 43 04             	mov    0x4(%ebx),%eax
801078ab:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078b0:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801078b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078b6:	5b                   	pop    %ebx
801078b7:	5e                   	pop    %esi
801078b8:	5f                   	pop    %edi
801078b9:	5d                   	pop    %ebp
  popcli();
801078ba:	e9 d1 d8 ff ff       	jmp    80105190 <popcli>
    panic("switchuvm: no process");
801078bf:	83 ec 0c             	sub    $0xc,%esp
801078c2:	68 09 9a 10 80       	push   $0x80109a09
801078c7:	e8 c4 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801078cc:	83 ec 0c             	sub    $0xc,%esp
801078cf:	68 34 9a 10 80       	push   $0x80109a34
801078d4:	e8 b7 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078d9:	83 ec 0c             	sub    $0xc,%esp
801078dc:	68 1f 9a 10 80       	push   $0x80109a1f
801078e1:	e8 aa 8a ff ff       	call   80100390 <panic>
801078e6:	8d 76 00             	lea    0x0(%esi),%esi
801078e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078f0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801078f0:	55                   	push   %ebp
801078f1:	89 e5                	mov    %esp,%ebp
801078f3:	57                   	push   %edi
801078f4:	56                   	push   %esi
801078f5:	53                   	push   %ebx
801078f6:	83 ec 1c             	sub    $0x1c,%esp
801078f9:	8b 75 10             	mov    0x10(%ebp),%esi
801078fc:	8b 45 08             	mov    0x8(%ebp),%eax
801078ff:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107902:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107908:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010790b:	77 49                	ja     80107956 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010790d:	e8 1e b4 ff ff       	call   80102d30 <kalloc>
  memset(mem, 0, PGSIZE);
80107912:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107915:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107917:	68 00 10 00 00       	push   $0x1000
8010791c:	6a 00                	push   $0x0
8010791e:	50                   	push   %eax
8010791f:	e8 0c da ff ff       	call   80105330 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107924:	58                   	pop    %eax
80107925:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010792b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107930:	5a                   	pop    %edx
80107931:	6a 06                	push   $0x6
80107933:	50                   	push   %eax
80107934:	31 d2                	xor    %edx,%edx
80107936:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107939:	e8 22 fc ff ff       	call   80107560 <mappages>
  memmove(mem, init, sz);
8010793e:	89 75 10             	mov    %esi,0x10(%ebp)
80107941:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107944:	83 c4 10             	add    $0x10,%esp
80107947:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010794a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010794d:	5b                   	pop    %ebx
8010794e:	5e                   	pop    %esi
8010794f:	5f                   	pop    %edi
80107950:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107951:	e9 8a da ff ff       	jmp    801053e0 <memmove>
    panic("inituvm: more than a page");
80107956:	83 ec 0c             	sub    $0xc,%esp
80107959:	68 48 9a 10 80       	push   $0x80109a48
8010795e:	e8 2d 8a ff ff       	call   80100390 <panic>
80107963:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107970 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107970:	55                   	push   %ebp
80107971:	89 e5                	mov    %esp,%ebp
80107973:	57                   	push   %edi
80107974:	56                   	push   %esi
80107975:	53                   	push   %ebx
80107976:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107979:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107980:	0f 85 91 00 00 00    	jne    80107a17 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107986:	8b 75 18             	mov    0x18(%ebp),%esi
80107989:	31 db                	xor    %ebx,%ebx
8010798b:	85 f6                	test   %esi,%esi
8010798d:	75 1a                	jne    801079a9 <loaduvm+0x39>
8010798f:	eb 6f                	jmp    80107a00 <loaduvm+0x90>
80107991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107998:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010799e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801079a4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801079a7:	76 57                	jbe    80107a00 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801079a9:	8b 55 0c             	mov    0xc(%ebp),%edx
801079ac:	8b 45 08             	mov    0x8(%ebp),%eax
801079af:	31 c9                	xor    %ecx,%ecx
801079b1:	01 da                	add    %ebx,%edx
801079b3:	e8 28 fb ff ff       	call   801074e0 <walkpgdir>
801079b8:	85 c0                	test   %eax,%eax
801079ba:	74 4e                	je     80107a0a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801079bc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079be:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801079c1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801079c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801079cb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079d1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079d4:	01 d9                	add    %ebx,%ecx
801079d6:	05 00 00 00 80       	add    $0x80000000,%eax
801079db:	57                   	push   %edi
801079dc:	51                   	push   %ecx
801079dd:	50                   	push   %eax
801079de:	ff 75 10             	pushl  0x10(%ebp)
801079e1:	e8 2a a3 ff ff       	call   80101d10 <readi>
801079e6:	83 c4 10             	add    $0x10,%esp
801079e9:	39 f8                	cmp    %edi,%eax
801079eb:	74 ab                	je     80107998 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801079ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079f5:	5b                   	pop    %ebx
801079f6:	5e                   	pop    %esi
801079f7:	5f                   	pop    %edi
801079f8:	5d                   	pop    %ebp
801079f9:	c3                   	ret    
801079fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a03:	31 c0                	xor    %eax,%eax
}
80107a05:	5b                   	pop    %ebx
80107a06:	5e                   	pop    %esi
80107a07:	5f                   	pop    %edi
80107a08:	5d                   	pop    %ebp
80107a09:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a0a:	83 ec 0c             	sub    $0xc,%esp
80107a0d:	68 62 9a 10 80       	push   $0x80109a62
80107a12:	e8 79 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107a17:	83 ec 0c             	sub    $0xc,%esp
80107a1a:	68 f8 9b 10 80       	push   $0x80109bf8
80107a1f:	e8 6c 89 ff ff       	call   80100390 <panic>
80107a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a30 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	53                   	push   %ebx
80107a34:	8b 4d 08             	mov    0x8(%ebp),%ecx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
80107a37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107a3a:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
80107a40:	6b c2 1c             	imul   $0x1c,%edx,%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  // cprintf("filling ram slot: %d\n", curproc->num_ram);
  // cprintf("allocating addr : %p\n\n", rounded_virtaddr);

  curproc->num_ram++;
80107a43:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107a46:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
80107a48:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107a4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107a51:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a58:	00 00 00 
  page->swap_offset = -1;
80107a5b:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107a62:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107a65:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107a6b:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
  
}
80107a71:	5b                   	pop    %ebx
80107a72:	5d                   	pop    %ebp
80107a73:	c3                   	ret    
80107a74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a80 <update_selectionfiled_allocuvm>:
     
}

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107a80:	55                   	push   %ebp
80107a81:	89 e5                	mov    %esp,%ebp
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107a83:	5d                   	pop    %ebp
80107a84:	c3                   	ret    
80107a85:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107a90 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107a90:	55                   	push   %ebp
80107a91:	89 e5                	mov    %esp,%ebp
80107a93:	57                   	push   %edi
80107a94:	56                   	push   %esi
80107a95:	53                   	push   %ebx
80107a96:	83 ec 5c             	sub    $0x5c,%esp
80107a99:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107a9c:	e8 1f c8 ff ff       	call   801042c0 <myproc>
80107aa1:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107aa7:	39 45 10             	cmp    %eax,0x10(%ebp)
80107aaa:	0f 83 a3 00 00 00    	jae    80107b53 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107ab0:	8b 45 10             	mov    0x10(%ebp),%eax
80107ab3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107ab9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107abf:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107ac2:	77 6a                	ja     80107b2e <deallocuvm+0x9e>
80107ac4:	e9 87 00 00 00       	jmp    80107b50 <deallocuvm+0xc0>
80107ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107ad0:	8b 00                	mov    (%eax),%eax
80107ad2:	a8 01                	test   $0x1,%al
80107ad4:	74 4d                	je     80107b23 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107ad6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107adb:	0f 84 b3 01 00 00    	je     80107c94 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107ae1:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107ae7:	83 ec 0c             	sub    $0xc,%esp
80107aea:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107aed:	53                   	push   %ebx
80107aee:	e8 cd b3 ff ff       	call   80102ec0 <getRefs>
80107af3:	83 c4 10             	add    $0x10,%esp
80107af6:	83 f8 01             	cmp    $0x1,%eax
80107af9:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107afc:	0f 84 7e 01 00 00    	je     80107c80 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107b02:	83 ec 0c             	sub    $0xc,%esp
80107b05:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b08:	53                   	push   %ebx
80107b09:	e8 d2 b2 ff ff       	call   80102de0 <refDec>
80107b0e:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107b11:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107b14:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107b17:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107b1b:	7f 43                	jg     80107b60 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107b1d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107b23:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b29:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b2c:	76 22                	jbe    80107b50 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b2e:	31 c9                	xor    %ecx,%ecx
80107b30:	89 f2                	mov    %esi,%edx
80107b32:	89 f8                	mov    %edi,%eax
80107b34:	e8 a7 f9 ff ff       	call   801074e0 <walkpgdir>
    if(!pte)
80107b39:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b3b:	89 c2                	mov    %eax,%edx
    if(!pte)
80107b3d:	75 91                	jne    80107ad0 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107b3f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107b45:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b4b:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b4e:	77 de                	ja     80107b2e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107b50:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b53:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b56:	5b                   	pop    %ebx
80107b57:	5e                   	pop    %esi
80107b58:	5f                   	pop    %edi
80107b59:	5d                   	pop    %ebp
80107b5a:	c3                   	ret    
80107b5b:	90                   	nop
80107b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b60:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107b66:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b69:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107b6f:	89 fa                	mov    %edi,%edx
80107b71:	89 cf                	mov    %ecx,%edi
80107b73:	eb 17                	jmp    80107b8c <deallocuvm+0xfc>
80107b75:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107b78:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107b7b:	0f 84 b7 00 00 00    	je     80107c38 <deallocuvm+0x1a8>
80107b81:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107b84:	39 fb                	cmp    %edi,%ebx
80107b86:	0f 84 e4 00 00 00    	je     80107c70 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107b8c:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107b92:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107b95:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107b9b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107b9e:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107ba4:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107ba7:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107bad:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107bb0:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107bb3:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107bb9:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107bbc:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107bc2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107bc5:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107bcb:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107bce:	8b 03                	mov    (%ebx),%eax
80107bd0:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107bd3:	8b 43 04             	mov    0x4(%ebx),%eax
80107bd6:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107bd9:	8b 43 08             	mov    0x8(%ebx),%eax
80107bdc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107bdf:	8b 43 0c             	mov    0xc(%ebx),%eax
80107be2:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107be5:	8b 43 10             	mov    0x10(%ebx),%eax
80107be8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107beb:	8b 43 14             	mov    0x14(%ebx),%eax
80107bee:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107bf1:	8b 43 18             	mov    0x18(%ebx),%eax
80107bf4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107bf7:	0f 85 7b ff ff ff    	jne    80107b78 <deallocuvm+0xe8>
80107bfd:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107c00:	0f 85 72 ff ff ff    	jne    80107b78 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107c06:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107c09:	83 ec 04             	sub    $0x4,%esp
80107c0c:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107c0f:	6a 1c                	push   $0x1c
80107c11:	6a 00                	push   $0x0
80107c13:	50                   	push   %eax
80107c14:	e8 17 d7 ff ff       	call   80105330 <memset>
            curproc->num_ram -- ;
80107c19:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c1c:	83 c4 10             	add    $0x10,%esp
80107c1f:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107c22:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107c29:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107c2c:	0f 85 4f ff ff ff    	jne    80107b81 <deallocuvm+0xf1>
80107c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c38:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107c3b:	0f 85 40 ff ff ff    	jne    80107b81 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107c41:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107c44:	83 ec 04             	sub    $0x4,%esp
80107c47:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107c4a:	6a 1c                	push   $0x1c
80107c4c:	6a 00                	push   $0x0
80107c4e:	83 c3 1c             	add    $0x1c,%ebx
80107c51:	50                   	push   %eax
80107c52:	e8 d9 d6 ff ff       	call   80105330 <memset>
            curproc->num_swap --;
80107c57:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c5a:	83 c4 10             	add    $0x10,%esp
80107c5d:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107c60:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107c67:	39 fb                	cmp    %edi,%ebx
80107c69:	0f 85 1d ff ff ff    	jne    80107b8c <deallocuvm+0xfc>
80107c6f:	90                   	nop
80107c70:	89 d7                	mov    %edx,%edi
80107c72:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107c75:	e9 a3 fe ff ff       	jmp    80107b1d <deallocuvm+0x8d>
80107c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107c80:	83 ec 0c             	sub    $0xc,%esp
80107c83:	53                   	push   %ebx
80107c84:	e8 c7 ad ff ff       	call   80102a50 <kfree>
80107c89:	83 c4 10             	add    $0x10,%esp
80107c8c:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107c8f:	e9 80 fe ff ff       	jmp    80107b14 <deallocuvm+0x84>
        panic("kfree");
80107c94:	83 ec 0c             	sub    $0xc,%esp
80107c97:	68 1a 92 10 80       	push   $0x8010921a
80107c9c:	e8 ef 86 ff ff       	call   80100390 <panic>
80107ca1:	eb 0d                	jmp    80107cb0 <freevm>
80107ca3:	90                   	nop
80107ca4:	90                   	nop
80107ca5:	90                   	nop
80107ca6:	90                   	nop
80107ca7:	90                   	nop
80107ca8:	90                   	nop
80107ca9:	90                   	nop
80107caa:	90                   	nop
80107cab:	90                   	nop
80107cac:	90                   	nop
80107cad:	90                   	nop
80107cae:	90                   	nop
80107caf:	90                   	nop

80107cb0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
80107cb3:	57                   	push   %edi
80107cb4:	56                   	push   %esi
80107cb5:	53                   	push   %ebx
80107cb6:	83 ec 0c             	sub    $0xc,%esp
80107cb9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107cbc:	85 f6                	test   %esi,%esi
80107cbe:	74 59                	je     80107d19 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107cc0:	83 ec 04             	sub    $0x4,%esp
80107cc3:	89 f3                	mov    %esi,%ebx
80107cc5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107ccb:	6a 00                	push   $0x0
80107ccd:	68 00 00 00 80       	push   $0x80000000
80107cd2:	56                   	push   %esi
80107cd3:	e8 b8 fd ff ff       	call   80107a90 <deallocuvm>
80107cd8:	83 c4 10             	add    $0x10,%esp
80107cdb:	eb 0a                	jmp    80107ce7 <freevm+0x37>
80107cdd:	8d 76 00             	lea    0x0(%esi),%esi
80107ce0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107ce3:	39 fb                	cmp    %edi,%ebx
80107ce5:	74 23                	je     80107d0a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107ce7:	8b 03                	mov    (%ebx),%eax
80107ce9:	a8 01                	test   $0x1,%al
80107ceb:	74 f3                	je     80107ce0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ced:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107cf2:	83 ec 0c             	sub    $0xc,%esp
80107cf5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107cf8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107cfd:	50                   	push   %eax
80107cfe:	e8 4d ad ff ff       	call   80102a50 <kfree>
80107d03:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d06:	39 fb                	cmp    %edi,%ebx
80107d08:	75 dd                	jne    80107ce7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d0a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d10:	5b                   	pop    %ebx
80107d11:	5e                   	pop    %esi
80107d12:	5f                   	pop    %edi
80107d13:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d14:	e9 37 ad ff ff       	jmp    80102a50 <kfree>
    panic("freevm: no pgdir");
80107d19:	83 ec 0c             	sub    $0xc,%esp
80107d1c:	68 80 9a 10 80       	push   $0x80109a80
80107d21:	e8 6a 86 ff ff       	call   80100390 <panic>
80107d26:	8d 76 00             	lea    0x0(%esi),%esi
80107d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d30 <setupkvm>:
{
80107d30:	55                   	push   %ebp
80107d31:	89 e5                	mov    %esp,%ebp
80107d33:	56                   	push   %esi
80107d34:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107d35:	e8 f6 af ff ff       	call   80102d30 <kalloc>
80107d3a:	85 c0                	test   %eax,%eax
80107d3c:	89 c6                	mov    %eax,%esi
80107d3e:	74 42                	je     80107d82 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107d40:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d43:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107d48:	68 00 10 00 00       	push   $0x1000
80107d4d:	6a 00                	push   $0x0
80107d4f:	50                   	push   %eax
80107d50:	e8 db d5 ff ff       	call   80105330 <memset>
80107d55:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d58:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d5b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d5e:	83 ec 08             	sub    $0x8,%esp
80107d61:	8b 13                	mov    (%ebx),%edx
80107d63:	ff 73 0c             	pushl  0xc(%ebx)
80107d66:	50                   	push   %eax
80107d67:	29 c1                	sub    %eax,%ecx
80107d69:	89 f0                	mov    %esi,%eax
80107d6b:	e8 f0 f7 ff ff       	call   80107560 <mappages>
80107d70:	83 c4 10             	add    $0x10,%esp
80107d73:	85 c0                	test   %eax,%eax
80107d75:	78 19                	js     80107d90 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d77:	83 c3 10             	add    $0x10,%ebx
80107d7a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107d80:	75 d6                	jne    80107d58 <setupkvm+0x28>
}
80107d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107d85:	89 f0                	mov    %esi,%eax
80107d87:	5b                   	pop    %ebx
80107d88:	5e                   	pop    %esi
80107d89:	5d                   	pop    %ebp
80107d8a:	c3                   	ret    
80107d8b:	90                   	nop
80107d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80107d90:	83 ec 0c             	sub    $0xc,%esp
80107d93:	68 91 9a 10 80       	push   $0x80109a91
80107d98:	e8 c3 88 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
80107d9d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107da0:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107da2:	e8 09 ff ff ff       	call   80107cb0 <freevm>
      return 0;
80107da7:	83 c4 10             	add    $0x10,%esp
}
80107daa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107dad:	89 f0                	mov    %esi,%eax
80107daf:	5b                   	pop    %ebx
80107db0:	5e                   	pop    %esi
80107db1:	5d                   	pop    %ebp
80107db2:	c3                   	ret    
80107db3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107dc0 <kvmalloc>:
{
80107dc0:	55                   	push   %ebp
80107dc1:	89 e5                	mov    %esp,%ebp
80107dc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107dc6:	e8 65 ff ff ff       	call   80107d30 <setupkvm>
80107dcb:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107dd0:	05 00 00 00 80       	add    $0x80000000,%eax
80107dd5:	0f 22 d8             	mov    %eax,%cr3
}
80107dd8:	c9                   	leave  
80107dd9:	c3                   	ret    
80107dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107de1:	31 c9                	xor    %ecx,%ecx
{
80107de3:	89 e5                	mov    %esp,%ebp
80107de5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107deb:	8b 45 08             	mov    0x8(%ebp),%eax
80107dee:	e8 ed f6 ff ff       	call   801074e0 <walkpgdir>
  if(pte == 0)
80107df3:	85 c0                	test   %eax,%eax
80107df5:	74 05                	je     80107dfc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107df7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107dfa:	c9                   	leave  
80107dfb:	c3                   	ret    
    panic("clearpteu");
80107dfc:	83 ec 0c             	sub    $0xc,%esp
80107dff:	68 ad 9a 10 80       	push   $0x80109aad
80107e04:	e8 87 85 ff ff       	call   80100390 <panic>
80107e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e10 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80107e10:	55                   	push   %ebp
80107e11:	89 e5                	mov    %esp,%ebp
80107e13:	57                   	push   %edi
80107e14:	56                   	push   %esi
80107e15:	53                   	push   %ebx
80107e16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107e19:	e8 12 ff ff ff       	call   80107d30 <setupkvm>
80107e1e:	85 c0                	test   %eax,%eax
80107e20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e23:	0f 84 b2 00 00 00    	je     80107edb <cowuvm+0xcb>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80107e29:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e2c:	85 d2                	test   %edx,%edx
80107e2e:	0f 84 a7 00 00 00    	je     80107edb <cowuvm+0xcb>
80107e34:	8b 45 08             	mov    0x8(%ebp),%eax
80107e37:	31 db                	xor    %ebx,%ebx
80107e39:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
80107e3f:	eb 27                	jmp    80107e68 <cowuvm+0x58>
80107e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80107e48:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107e4b:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
80107e51:	56                   	push   %esi
80107e52:	e8 f9 af ff ff       	call   80102e50 <refInc>
80107e57:	0f 22 df             	mov    %edi,%cr3
  for(i = 0; i < sz; i += PGSIZE)
80107e5a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e60:	83 c4 10             	add    $0x10,%esp
80107e63:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107e66:	76 73                	jbe    80107edb <cowuvm+0xcb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e68:	8b 45 08             	mov    0x8(%ebp),%eax
80107e6b:	31 c9                	xor    %ecx,%ecx
80107e6d:	89 da                	mov    %ebx,%edx
80107e6f:	e8 6c f6 ff ff       	call   801074e0 <walkpgdir>
80107e74:	85 c0                	test   %eax,%eax
80107e76:	74 7b                	je     80107ef3 <cowuvm+0xe3>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107e78:	8b 10                	mov    (%eax),%edx
80107e7a:	f7 c2 01 02 00 00    	test   $0x201,%edx
80107e80:	74 64                	je     80107ee6 <cowuvm+0xd6>
    *pte &= ~PTE_W;
80107e82:	89 d1                	mov    %edx,%ecx
80107e84:	89 d6                	mov    %edx,%esi
    flags = PTE_FLAGS(*pte);
80107e86:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80107e8c:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107e8f:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107e92:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
80107e95:	80 cd 04             	or     $0x4,%ch
80107e98:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107e9e:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ea3:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ea8:	52                   	push   %edx
80107ea9:	56                   	push   %esi
80107eaa:	89 da                	mov    %ebx,%edx
80107eac:	e8 af f6 ff ff       	call   80107560 <mappages>
80107eb1:	83 c4 10             	add    $0x10,%esp
80107eb4:	85 c0                	test   %eax,%eax
80107eb6:	79 90                	jns    80107e48 <cowuvm+0x38>
    // invlpg((void*)i); // flush TLB
  }
  return d;

bad:
  cprintf("bad: cowuvm\n");
80107eb8:	83 ec 0c             	sub    $0xc,%esp
80107ebb:	68 c6 9a 10 80       	push   $0x80109ac6
80107ec0:	e8 9b 87 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107ec5:	58                   	pop    %eax
80107ec6:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ec9:	e8 e2 fd ff ff       	call   80107cb0 <freevm>
80107ece:	0f 22 df             	mov    %edi,%cr3
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
80107ed1:	83 c4 10             	add    $0x10,%esp
80107ed4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107edb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ede:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ee1:	5b                   	pop    %ebx
80107ee2:	5e                   	pop    %esi
80107ee3:	5f                   	pop    %edi
80107ee4:	5d                   	pop    %ebp
80107ee5:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
80107ee6:	83 ec 0c             	sub    $0xc,%esp
80107ee9:	68 1c 9c 10 80       	push   $0x80109c1c
80107eee:	e8 9d 84 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107ef3:	83 ec 0c             	sub    $0xc,%esp
80107ef6:	68 b7 9a 10 80       	push   $0x80109ab7
80107efb:	e8 90 84 ff ff       	call   80100390 <panic>

80107f00 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80107f00:	55                   	push   %ebp
80107f01:	89 e5                	mov    %esp,%ebp
80107f03:	53                   	push   %ebx
80107f04:	83 ec 04             	sub    $0x4,%esp
80107f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107f0a:	e8 b1 c3 ff ff       	call   801042c0 <myproc>
80107f0f:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107f15:	31 c0                	xor    %eax,%eax
80107f17:	eb 12                	jmp    80107f2b <getSwappedPageIndex+0x2b>
80107f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f20:	83 c0 01             	add    $0x1,%eax
80107f23:	83 c2 1c             	add    $0x1c,%edx
80107f26:	83 f8 10             	cmp    $0x10,%eax
80107f29:	74 0d                	je     80107f38 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
80107f2b:	39 1a                	cmp    %ebx,(%edx)
80107f2d:	75 f1                	jne    80107f20 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
80107f2f:	83 c4 04             	add    $0x4,%esp
80107f32:	5b                   	pop    %ebx
80107f33:	5d                   	pop    %ebp
80107f34:	c3                   	ret    
80107f35:	8d 76 00             	lea    0x0(%esi),%esi
80107f38:	83 c4 04             	add    $0x4,%esp
  return -1;
80107f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f40:	5b                   	pop    %ebx
80107f41:	5d                   	pop    %ebp
80107f42:	c3                   	ret    
80107f43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f50 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
80107f50:	55                   	push   %ebp
80107f51:	89 e5                	mov    %esp,%ebp
80107f53:	57                   	push   %edi
80107f54:	56                   	push   %esi
80107f55:	53                   	push   %ebx
80107f56:	83 ec 1c             	sub    $0x1c,%esp
80107f59:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107f5f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
80107f62:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80107f65:	f6 42 34 02          	testb  $0x2,0x34(%edx)
80107f69:	74 07                	je     80107f72 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
80107f6b:	8b 13                	mov    (%ebx),%edx
80107f6d:	f6 c6 04             	test   $0x4,%dh
80107f70:	75 16                	jne    80107f88 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80107f72:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
80107f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f7c:	5b                   	pop    %ebx
80107f7d:	5e                   	pop    %esi
80107f7e:	5f                   	pop    %edi
80107f7f:	5d                   	pop    %ebp
80107f80:	c3                   	ret    
80107f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
80107f88:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
80107f8a:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
80107f8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107f90:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80107f96:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
80107f9c:	57                   	push   %edi
80107f9d:	e8 1e af ff ff       	call   80102ec0 <getRefs>
      if (ref_count > 1) // more than one reference
80107fa2:	83 c4 10             	add    $0x10,%esp
80107fa5:	83 f8 01             	cmp    $0x1,%eax
80107fa8:	7f 16                	jg     80107fc0 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
80107faa:	8b 03                	mov    (%ebx),%eax
80107fac:	80 e4 fb             	and    $0xfb,%ah
80107faf:	83 c8 02             	or     $0x2,%eax
80107fb2:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107fb4:	0f 01 3e             	invlpg (%esi)
80107fb7:	eb c0                	jmp    80107f79 <handle_cow_pagefault+0x29>
80107fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80107fc0:	e8 6b ad ff ff       	call   80102d30 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80107fc5:	83 ec 04             	sub    $0x4,%esp
80107fc8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107fcb:	68 00 10 00 00       	push   $0x1000
80107fd0:	57                   	push   %edi
80107fd1:	50                   	push   %eax
80107fd2:	e8 09 d4 ff ff       	call   801053e0 <memmove>
      flags = PTE_FLAGS(*pte);
80107fd7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
80107fda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
80107fdd:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
80107fe3:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80107fe9:	83 ca 03             	or     $0x3,%edx
80107fec:	09 ca                	or     %ecx,%edx
80107fee:	89 13                	mov    %edx,(%ebx)
80107ff0:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
80107ff3:	89 7d 08             	mov    %edi,0x8(%ebp)
80107ff6:	83 c4 10             	add    $0x10,%esp
}
80107ff9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ffc:	5b                   	pop    %ebx
80107ffd:	5e                   	pop    %esi
80107ffe:	5f                   	pop    %edi
80107fff:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
80108000:	e9 db ad ff ff       	jmp    80102de0 <refDec>
80108005:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108010 <update_selectionfiled_pagefault>:
80108010:	55                   	push   %ebp
80108011:	89 e5                	mov    %esp,%ebp
80108013:	5d                   	pop    %ebp
80108014:	c3                   	ret    
80108015:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108020 <copyuvm>:

}

pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108020:	55                   	push   %ebp
80108021:	89 e5                	mov    %esp,%ebp
80108023:	57                   	push   %edi
80108024:	56                   	push   %esi
80108025:	53                   	push   %ebx
80108026:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108029:	e8 02 fd ff ff       	call   80107d30 <setupkvm>
8010802e:	85 c0                	test   %eax,%eax
80108030:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108033:	0f 84 be 00 00 00    	je     801080f7 <copyuvm+0xd7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108039:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010803c:	85 db                	test   %ebx,%ebx
8010803e:	0f 84 b3 00 00 00    	je     801080f7 <copyuvm+0xd7>
80108044:	31 f6                	xor    %esi,%esi
80108046:	eb 69                	jmp    801080b1 <copyuvm+0x91>
80108048:	90                   	nop
80108049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }

    pa = PTE_ADDR(*pte);
80108050:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108052:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80108057:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
8010805d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    {
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
        panic("copyuvm: mappages failed");
      continue;
    }
    if((mem = kalloc()) == 0)
80108060:	e8 cb ac ff ff       	call   80102d30 <kalloc>
80108065:	85 c0                	test   %eax,%eax
80108067:	89 c3                	mov    %eax,%ebx
80108069:	0f 84 b1 00 00 00    	je     80108120 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010806f:	83 ec 04             	sub    $0x4,%esp
80108072:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108078:	68 00 10 00 00       	push   $0x1000
8010807d:	57                   	push   %edi
8010807e:	50                   	push   %eax
8010807f:	e8 5c d3 ff ff       	call   801053e0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108084:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010808a:	5a                   	pop    %edx
8010808b:	59                   	pop    %ecx
8010808c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010808f:	50                   	push   %eax
80108090:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108095:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108098:	89 f2                	mov    %esi,%edx
8010809a:	e8 c1 f4 ff ff       	call   80107560 <mappages>
8010809f:	83 c4 10             	add    $0x10,%esp
801080a2:	85 c0                	test   %eax,%eax
801080a4:	78 62                	js     80108108 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801080a6:	81 c6 00 10 00 00    	add    $0x1000,%esi
801080ac:	39 75 0c             	cmp    %esi,0xc(%ebp)
801080af:	76 46                	jbe    801080f7 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080b1:	8b 45 08             	mov    0x8(%ebp),%eax
801080b4:	31 c9                	xor    %ecx,%ecx
801080b6:	89 f2                	mov    %esi,%edx
801080b8:	e8 23 f4 ff ff       	call   801074e0 <walkpgdir>
801080bd:	85 c0                	test   %eax,%eax
801080bf:	0f 84 93 00 00 00    	je     80108158 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801080c5:	8b 00                	mov    (%eax),%eax
801080c7:	a9 01 02 00 00       	test   $0x201,%eax
801080cc:	74 7d                	je     8010814b <copyuvm+0x12b>
    if (*pte & PTE_PG) {
801080ce:	f6 c4 02             	test   $0x2,%ah
801080d1:	0f 84 79 ff ff ff    	je     80108050 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
801080d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080da:	89 f2                	mov    %esi,%edx
801080dc:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801080e1:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801080e7:	e8 f4 f3 ff ff       	call   801074e0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
801080ec:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
801080ef:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
801080f5:	77 ba                	ja     801080b1 <copyuvm+0x91>

bad:
  cprintf("bad: copyuvm\n");
  freevm(d);
  return 0;
}
801080f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080fd:	5b                   	pop    %ebx
801080fe:	5e                   	pop    %esi
801080ff:	5f                   	pop    %edi
80108100:	5d                   	pop    %ebp
80108101:	c3                   	ret    
80108102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
80108108:	83 ec 0c             	sub    $0xc,%esp
8010810b:	68 ed 9a 10 80       	push   $0x80109aed
80108110:	e8 4b 85 ff ff       	call   80100660 <cprintf>
      kfree(mem);
80108115:	89 1c 24             	mov    %ebx,(%esp)
80108118:	e8 33 a9 ff ff       	call   80102a50 <kfree>
      goto bad;
8010811d:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
80108120:	83 ec 0c             	sub    $0xc,%esp
80108123:	68 07 9b 10 80       	push   $0x80109b07
80108128:	e8 33 85 ff ff       	call   80100660 <cprintf>
  freevm(d);
8010812d:	58                   	pop    %eax
8010812e:	ff 75 e0             	pushl  -0x20(%ebp)
80108131:	e8 7a fb ff ff       	call   80107cb0 <freevm>
  return 0;
80108136:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010813d:	83 c4 10             	add    $0x10,%esp
}
80108140:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108143:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108146:	5b                   	pop    %ebx
80108147:	5e                   	pop    %esi
80108148:	5f                   	pop    %edi
80108149:	5d                   	pop    %ebp
8010814a:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
8010814b:	83 ec 0c             	sub    $0xc,%esp
8010814e:	68 4c 9c 10 80       	push   $0x80109c4c
80108153:	e8 38 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108158:	83 ec 0c             	sub    $0xc,%esp
8010815b:	68 d3 9a 10 80       	push   $0x80109ad3
80108160:	e8 2b 82 ff ff       	call   80100390 <panic>
80108165:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108170 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108170:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108171:	31 c9                	xor    %ecx,%ecx
{
80108173:	89 e5                	mov    %esp,%ebp
80108175:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108178:	8b 55 0c             	mov    0xc(%ebp),%edx
8010817b:	8b 45 08             	mov    0x8(%ebp),%eax
8010817e:	e8 5d f3 ff ff       	call   801074e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108183:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108185:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108186:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108188:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010818d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108190:	05 00 00 00 80       	add    $0x80000000,%eax
80108195:	83 fa 05             	cmp    $0x5,%edx
80108198:	ba 00 00 00 00       	mov    $0x0,%edx
8010819d:	0f 45 c2             	cmovne %edx,%eax
}
801081a0:	c3                   	ret    
801081a1:	eb 0d                	jmp    801081b0 <copyout>
801081a3:	90                   	nop
801081a4:	90                   	nop
801081a5:	90                   	nop
801081a6:	90                   	nop
801081a7:	90                   	nop
801081a8:	90                   	nop
801081a9:	90                   	nop
801081aa:	90                   	nop
801081ab:	90                   	nop
801081ac:	90                   	nop
801081ad:	90                   	nop
801081ae:	90                   	nop
801081af:	90                   	nop

801081b0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081b0:	55                   	push   %ebp
801081b1:	89 e5                	mov    %esp,%ebp
801081b3:	57                   	push   %edi
801081b4:	56                   	push   %esi
801081b5:	53                   	push   %ebx
801081b6:	83 ec 1c             	sub    $0x1c,%esp
801081b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801081bc:	8b 55 0c             	mov    0xc(%ebp),%edx
801081bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081c2:	85 db                	test   %ebx,%ebx
801081c4:	75 40                	jne    80108206 <copyout+0x56>
801081c6:	eb 70                	jmp    80108238 <copyout+0x88>
801081c8:	90                   	nop
801081c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801081d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801081d3:	89 f1                	mov    %esi,%ecx
801081d5:	29 d1                	sub    %edx,%ecx
801081d7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801081dd:	39 d9                	cmp    %ebx,%ecx
801081df:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801081e2:	29 f2                	sub    %esi,%edx
801081e4:	83 ec 04             	sub    $0x4,%esp
801081e7:	01 d0                	add    %edx,%eax
801081e9:	51                   	push   %ecx
801081ea:	57                   	push   %edi
801081eb:	50                   	push   %eax
801081ec:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801081ef:	e8 ec d1 ff ff       	call   801053e0 <memmove>
    len -= n;
    buf += n;
801081f4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801081f7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801081fa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108200:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108202:	29 cb                	sub    %ecx,%ebx
80108204:	74 32                	je     80108238 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108206:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108208:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010820b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010820e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108214:	56                   	push   %esi
80108215:	ff 75 08             	pushl  0x8(%ebp)
80108218:	e8 53 ff ff ff       	call   80108170 <uva2ka>
    if(pa0 == 0)
8010821d:	83 c4 10             	add    $0x10,%esp
80108220:	85 c0                	test   %eax,%eax
80108222:	75 ac                	jne    801081d0 <copyout+0x20>
  }
  return 0;
}
80108224:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010822c:	5b                   	pop    %ebx
8010822d:	5e                   	pop    %esi
8010822e:	5f                   	pop    %edi
8010822f:	5d                   	pop    %ebp
80108230:	c3                   	ret    
80108231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010823b:	31 c0                	xor    %eax,%eax
}
8010823d:	5b                   	pop    %ebx
8010823e:	5e                   	pop    %esi
8010823f:	5f                   	pop    %edi
80108240:	5d                   	pop    %ebp
80108241:	c3                   	ret    
80108242:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108250 <getNextFreeRamIndex>:

int
getNextFreeRamIndex()
{ 
80108250:	55                   	push   %ebp
80108251:	89 e5                	mov    %esp,%ebp
80108253:	83 ec 08             	sub    $0x8,%esp
  int i;
  struct proc * currproc = myproc();
80108256:	e8 65 c0 ff ff       	call   801042c0 <myproc>
8010825b:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108261:	31 c0                	xor    %eax,%eax
80108263:	eb 0e                	jmp    80108273 <getNextFreeRamIndex+0x23>
80108265:	8d 76 00             	lea    0x0(%esi),%esi
80108268:	83 c0 01             	add    $0x1,%eax
8010826b:	83 c2 1c             	add    $0x1c,%edx
8010826e:	83 f8 10             	cmp    $0x10,%eax
80108271:	74 0d                	je     80108280 <getNextFreeRamIndex+0x30>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108273:	8b 0a                	mov    (%edx),%ecx
80108275:	85 c9                	test   %ecx,%ecx
80108277:	75 ef                	jne    80108268 <getNextFreeRamIndex+0x18>
      return i;
  }
  return -1;
}
80108279:	c9                   	leave  
8010827a:	c3                   	ret    
8010827b:	90                   	nop
8010827c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108285:	c9                   	leave  
80108286:	c3                   	ret    
80108287:	89 f6                	mov    %esi,%esi
80108289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108290 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108290:	55                   	push   %ebp
80108291:	89 e5                	mov    %esp,%ebp
80108293:	56                   	push   %esi
80108294:	53                   	push   %ebx
80108295:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108298:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010829e:	81 c6 08 04 00 00    	add    $0x408,%esi
801082a4:	eb 1d                	jmp    801082c3 <updateLapa+0x33>
801082a6:	8d 76 00             	lea    0x0(%esi),%esi
801082a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
801082b0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
801082b6:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
801082b9:	83 20 df             	andl   $0xffffffdf,(%eax)
801082bc:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801082bf:	39 f3                	cmp    %esi,%ebx
801082c1:	74 2b                	je     801082ee <updateLapa+0x5e>
    if(!cur_page->isused)
801082c3:	8b 43 04             	mov    0x4(%ebx),%eax
801082c6:	85 c0                	test   %eax,%eax
801082c8:	74 f2                	je     801082bc <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
801082ca:	8b 53 08             	mov    0x8(%ebx),%edx
801082cd:	8b 03                	mov    (%ebx),%eax
801082cf:	31 c9                	xor    %ecx,%ecx
801082d1:	e8 0a f2 ff ff       	call   801074e0 <walkpgdir>
801082d6:	85 c0                	test   %eax,%eax
801082d8:	74 1b                	je     801082f5 <updateLapa+0x65>
801082da:	8b 53 18             	mov    0x18(%ebx),%edx
801082dd:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
801082df:	f6 00 20             	testb  $0x20,(%eax)
801082e2:	75 cc                	jne    801082b0 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
801082e4:	89 53 18             	mov    %edx,0x18(%ebx)
801082e7:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801082ea:	39 f3                	cmp    %esi,%ebx
801082ec:	75 d5                	jne    801082c3 <updateLapa+0x33>
    }
  }
}
801082ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801082f1:	5b                   	pop    %ebx
801082f2:	5e                   	pop    %esi
801082f3:	5d                   	pop    %ebp
801082f4:	c3                   	ret    
      panic("updateLapa: no pte");
801082f5:	83 ec 0c             	sub    $0xc,%esp
801082f8:	68 15 9b 10 80       	push   $0x80109b15
801082fd:	e8 8e 80 ff ff       	call   80100390 <panic>
80108302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108310 <updateNfua>:

void updateNfua(struct proc* p)
{
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	56                   	push   %esi
80108314:	53                   	push   %ebx
80108315:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108318:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010831e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108324:	eb 1d                	jmp    80108343 <updateNfua+0x33>
80108326:	8d 76 00             	lea    0x0(%esi),%esi
80108329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108330:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108336:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108339:	83 20 df             	andl   $0xffffffdf,(%eax)
8010833c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010833f:	39 f3                	cmp    %esi,%ebx
80108341:	74 2b                	je     8010836e <updateNfua+0x5e>
    if(!cur_page->isused)
80108343:	8b 43 04             	mov    0x4(%ebx),%eax
80108346:	85 c0                	test   %eax,%eax
80108348:	74 f2                	je     8010833c <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010834a:	8b 53 08             	mov    0x8(%ebx),%edx
8010834d:	8b 03                	mov    (%ebx),%eax
8010834f:	31 c9                	xor    %ecx,%ecx
80108351:	e8 8a f1 ff ff       	call   801074e0 <walkpgdir>
80108356:	85 c0                	test   %eax,%eax
80108358:	74 1b                	je     80108375 <updateNfua+0x65>
8010835a:	8b 53 14             	mov    0x14(%ebx),%edx
8010835d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
8010835f:	f6 00 20             	testb  $0x20,(%eax)
80108362:	75 cc                	jne    80108330 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108364:	89 53 14             	mov    %edx,0x14(%ebx)
80108367:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010836a:	39 f3                	cmp    %esi,%ebx
8010836c:	75 d5                	jne    80108343 <updateNfua+0x33>
    }
  }
}
8010836e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108371:	5b                   	pop    %ebx
80108372:	5e                   	pop    %esi
80108373:	5d                   	pop    %ebp
80108374:	c3                   	ret    
      panic("updateNfua: no pte");
80108375:	83 ec 0c             	sub    $0xc,%esp
80108378:	68 28 9b 10 80       	push   $0x80109b28
8010837d:	e8 0e 80 ff ff       	call   80100390 <panic>
80108382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108390 <aq>:
  return 11; // default
  #endif
}

uint aq()
{
80108390:	55                   	push   %ebp
80108391:	89 e5                	mov    %esp,%ebp
80108393:	57                   	push   %edi
80108394:	56                   	push   %esi
80108395:	53                   	push   %ebx
80108396:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108399:	e8 22 bf ff ff       	call   801042c0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
8010839e:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
801083a4:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
801083aa:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
801083ac:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
801083af:	74 45                	je     801083f6 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
801083b1:	39 d1                	cmp    %edx,%ecx
801083b3:	89 c3                	mov    %eax,%ebx
801083b5:	74 31                	je     801083e8 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
801083b7:	8b 41 04             	mov    0x4(%ecx),%eax
801083ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
801083c0:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
801083c6:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
801083c9:	83 ec 0c             	sub    $0xc,%esp
801083cc:	52                   	push   %edx
801083cd:	e8 7e a6 ff ff       	call   80102a50 <kfree>
  curproc->queue_tail = new_tail;
801083d2:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
801083d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083db:	89 f0                	mov    %esi,%eax
801083dd:	5b                   	pop    %ebx
801083de:	5e                   	pop    %esi
801083df:	5f                   	pop    %edi
801083e0:	5d                   	pop    %ebp
801083e1:	c3                   	ret    
801083e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
801083e8:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
801083ef:	00 00 00 
    new_tail = 0;
801083f2:	31 ff                	xor    %edi,%edi
801083f4:	eb d3                	jmp    801083c9 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
801083f6:	83 ec 0c             	sub    $0xc,%esp
801083f9:	68 88 9c 10 80       	push   $0x80109c88
801083fe:	e8 8d 7f ff ff       	call   80100390 <panic>
80108403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108410 <lapa>:
uint lapa()
{
80108410:	55                   	push   %ebp
80108411:	89 e5                	mov    %esp,%ebp
80108413:	57                   	push   %edi
80108414:	56                   	push   %esi
80108415:	53                   	push   %ebx
80108416:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108419:	e8 a2 be ff ff       	call   801042c0 <myproc>
  struct page *ramPages = curproc->ramPages;
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
8010841e:	8b 90 60 02 00 00    	mov    0x260(%eax),%edx
  struct page *ramPages = curproc->ramPages;
80108424:	8d b8 48 02 00 00    	lea    0x248(%eax),%edi
8010842a:	89 7d dc             	mov    %edi,-0x24(%ebp)
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
8010842d:	85 d2                	test   %edx,%edx
8010842f:	0f 84 ff 00 00 00    	je     80108534 <lapa+0x124>
    uint count = 0;
80108435:	31 c9                	xor    %ecx,%ecx
80108437:	89 f6                	mov    %esi,%esi
80108439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        count += n & 1;
80108440:	89 d3                	mov    %edx,%ebx
80108442:	83 e3 01             	and    $0x1,%ebx
80108445:	01 d9                	add    %ebx,%ecx
    while (n) {
80108447:	d1 ea                	shr    %edx
80108449:	75 f5                	jne    80108440 <lapa+0x30>
8010844b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010844e:	05 7c 02 00 00       	add    $0x27c,%eax
  uint instances = 0;
80108453:	31 ff                	xor    %edi,%edi
  uint minloc = 0;
80108455:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010845c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint count = 0;
8010845f:	89 c6                	mov    %eax,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108461:	bb 01 00 00 00       	mov    $0x1,%ebx
80108466:	8d 76 00             	lea    0x0(%esi),%esi
80108469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108470:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108472:	31 d2                	xor    %edx,%edx
    while (n) {
80108474:	85 c0                	test   %eax,%eax
80108476:	74 13                	je     8010848b <lapa+0x7b>
80108478:	90                   	nop
80108479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108480:	89 c1                	mov    %eax,%ecx
80108482:	83 e1 01             	and    $0x1,%ecx
80108485:	01 ca                	add    %ecx,%edx
    while (n) {
80108487:	d1 e8                	shr    %eax
80108489:	75 f5                	jne    80108480 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
8010848b:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
8010848e:	0f 82 84 00 00 00    	jb     80108518 <lapa+0x108>
      instances++;
80108494:	0f 94 c0             	sete   %al
80108497:	0f b6 c0             	movzbl %al,%eax
8010849a:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010849c:	83 c3 01             	add    $0x1,%ebx
8010849f:	83 c6 1c             	add    $0x1c,%esi
801084a2:	83 fb 10             	cmp    $0x10,%ebx
801084a5:	75 c9                	jne    80108470 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
801084a7:	83 ff 01             	cmp    $0x1,%edi
801084aa:	76 5b                	jbe    80108507 <lapa+0xf7>
      uint minvalue = ramPages[minloc].lapa_counter;
801084ac:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
801084b0:	8b 7d dc             	mov    -0x24(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
801084b3:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
801084b8:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
801084bc:	89 7d dc             	mov    %edi,-0x24(%ebp)
801084bf:	8b 7d d8             	mov    -0x28(%ebp),%edi
801084c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
801084c8:	8b 1f                	mov    (%edi),%ebx
    while (n) {
801084ca:	85 db                	test   %ebx,%ebx
801084cc:	74 62                	je     80108530 <lapa+0x120>
801084ce:	89 d8                	mov    %ebx,%eax
    uint count = 0;
801084d0:	31 d2                	xor    %edx,%edx
801084d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
801084d8:	89 c1                	mov    %eax,%ecx
801084da:	83 e1 01             	and    $0x1,%ecx
801084dd:	01 ca                	add    %ecx,%edx
    while (n) {
801084df:	d1 e8                	shr    %eax
801084e1:	75 f5                	jne    801084d8 <lapa+0xc8>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
801084e3:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801084e6:	75 14                	jne    801084fc <lapa+0xec>
801084e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
801084eb:	39 c3                	cmp    %eax,%ebx
801084ed:	0f 43 d8             	cmovae %eax,%ebx
801084f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084f3:	89 5d dc             	mov    %ebx,-0x24(%ebp)
801084f6:	0f 42 c6             	cmovb  %esi,%eax
801084f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
801084fc:	83 c6 01             	add    $0x1,%esi
801084ff:	83 c7 1c             	add    $0x1c,%edi
80108502:	83 fe 10             	cmp    $0x10,%esi
80108505:	75 c1                	jne    801084c8 <lapa+0xb8>
}
80108507:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010850a:	83 c4 1c             	add    $0x1c,%esp
8010850d:	5b                   	pop    %ebx
8010850e:	5e                   	pop    %esi
8010850f:	5f                   	pop    %edi
80108510:	5d                   	pop    %ebp
80108511:	c3                   	ret    
80108512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      minloc = i;
80108518:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010851b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      instances = 1;
8010851e:	bf 01 00 00 00       	mov    $0x1,%edi
80108523:	e9 74 ff ff ff       	jmp    8010849c <lapa+0x8c>
80108528:	90                   	nop
80108529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint count = 0;
80108530:	31 d2                	xor    %edx,%edx
80108532:	eb af                	jmp    801084e3 <lapa+0xd3>
80108534:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010853b:	e9 0e ff ff ff       	jmp    8010844e <lapa+0x3e>

80108540 <nfua>:
{
80108540:	55                   	push   %ebp
80108541:	89 e5                	mov    %esp,%ebp
80108543:	56                   	push   %esi
80108544:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108545:	e8 76 bd ff ff       	call   801042c0 <myproc>
  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010854a:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
8010854f:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108555:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
8010855b:	31 c0                	xor    %eax,%eax
8010855d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ramPages[i].nfua_counter < minval)
80108560:	8b 19                	mov    (%ecx),%ebx
80108562:	39 f3                	cmp    %esi,%ebx
80108564:	73 04                	jae    8010856a <nfua+0x2a>
      minloc = i;
80108566:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108568:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010856a:	83 c2 01             	add    $0x1,%edx
8010856d:	83 c1 1c             	add    $0x1c,%ecx
80108570:	83 fa 10             	cmp    $0x10,%edx
80108573:	75 eb                	jne    80108560 <nfua+0x20>
}
80108575:	5b                   	pop    %ebx
80108576:	5e                   	pop    %esi
80108577:	5d                   	pop    %ebp
80108578:	c3                   	ret    
80108579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108580 <scfifo>:
{
80108580:	55                   	push   %ebp
80108581:	89 e5                	mov    %esp,%ebp
80108583:	57                   	push   %edi
80108584:	56                   	push   %esi
80108585:	53                   	push   %ebx
80108586:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108589:	e8 32 bd ff ff       	call   801042c0 <myproc>
8010858e:	89 c7                	mov    %eax,%edi
80108590:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108596:	83 f8 0f             	cmp    $0xf,%eax
80108599:	89 c3                	mov    %eax,%ebx
8010859b:	7f 5f                	jg     801085fc <scfifo+0x7c>
8010859d:	6b c0 1c             	imul   $0x1c,%eax,%eax
801085a0:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
801085a7:	eb 17                	jmp    801085c0 <scfifo+0x40>
801085a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801085b0:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
801085b3:	83 e2 df             	and    $0xffffffdf,%edx
801085b6:	83 c6 1c             	add    $0x1c,%esi
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
801085b9:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
801085bc:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
801085be:	74 30                	je     801085f0 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
801085c0:	8b 56 08             	mov    0x8(%esi),%edx
801085c3:	8b 06                	mov    (%esi),%eax
801085c5:	31 c9                	xor    %ecx,%ecx
801085c7:	e8 14 ef ff ff       	call   801074e0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
801085cc:	8b 10                	mov    (%eax),%edx
801085ce:	f6 c2 20             	test   $0x20,%dl
801085d1:	75 dd                	jne    801085b0 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
801085d3:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
801085da:	74 74                	je     80108650 <scfifo+0xd0>
            curproc->clockHand = i + 1;
801085dc:	8d 43 01             	lea    0x1(%ebx),%eax
801085df:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
801085e5:	83 c4 0c             	add    $0xc,%esp
801085e8:	89 d8                	mov    %ebx,%eax
801085ea:	5b                   	pop    %ebx
801085eb:	5e                   	pop    %esi
801085ec:	5f                   	pop    %edi
801085ed:	5d                   	pop    %ebp
801085ee:	c3                   	ret    
801085ef:	90                   	nop
801085f0:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
801085f6:	31 db                	xor    %ebx,%ebx
    for(j=0; j< curproc->clockHand ;j++)
801085f8:	85 c0                	test   %eax,%eax
801085fa:	74 a1                	je     8010859d <scfifo+0x1d>
801085fc:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108602:	31 c9                	xor    %ecx,%ecx
80108604:	eb 20                	jmp    80108626 <scfifo+0xa6>
80108606:	8d 76 00             	lea    0x0(%esi),%esi
80108609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          *pte &= ~PTE_A;  
80108610:	83 e2 df             	and    $0xffffffdf,%edx
80108613:	83 c6 1c             	add    $0x1c,%esi
80108616:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108618:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
8010861e:	39 c8                	cmp    %ecx,%eax
80108620:	0f 86 70 ff ff ff    	jbe    80108596 <scfifo+0x16>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108626:	8b 56 08             	mov    0x8(%esi),%edx
80108629:	8b 06                	mov    (%esi),%eax
8010862b:	89 cb                	mov    %ecx,%ebx
8010862d:	31 c9                	xor    %ecx,%ecx
8010862f:	e8 ac ee ff ff       	call   801074e0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108634:	8b 10                	mov    (%eax),%edx
80108636:	8d 4b 01             	lea    0x1(%ebx),%ecx
80108639:	f6 c2 20             	test   $0x20,%dl
8010863c:	75 d2                	jne    80108610 <scfifo+0x90>
          curproc->clockHand = j + 1;
8010863e:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108644:	83 c4 0c             	add    $0xc,%esp
80108647:	89 d8                	mov    %ebx,%eax
80108649:	5b                   	pop    %ebx
8010864a:	5e                   	pop    %esi
8010864b:	5f                   	pop    %edi
8010864c:	5d                   	pop    %ebp
8010864d:	c3                   	ret    
8010864e:	66 90                	xchg   %ax,%ax
            curproc->clockHand = 0;
80108650:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
80108657:	00 00 00 
}
8010865a:	83 c4 0c             	add    $0xc,%esp
8010865d:	89 d8                	mov    %ebx,%eax
8010865f:	5b                   	pop    %ebx
80108660:	5e                   	pop    %esi
80108661:	5f                   	pop    %edi
80108662:	5d                   	pop    %ebp
80108663:	c3                   	ret    
80108664:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010866a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108670 <indexToEvict>:
{  
80108670:	55                   	push   %ebp
80108671:	89 e5                	mov    %esp,%ebp
}
80108673:	5d                   	pop    %ebp
    return scfifo();
80108674:	e9 07 ff ff ff       	jmp    80108580 <scfifo>
80108679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108680 <allocuvm_withswap>:
{
80108680:	55                   	push   %ebp
80108681:	89 e5                	mov    %esp,%ebp
80108683:	57                   	push   %edi
80108684:	56                   	push   %esi
80108685:	53                   	push   %ebx
80108686:	83 ec 1c             	sub    $0x1c,%esp
80108689:	8b 75 08             	mov    0x8(%ebp),%esi
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
8010868c:	83 be 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%esi)
80108693:	0f 8f 2c 01 00 00    	jg     801087c5 <allocuvm_withswap+0x145>
    return scfifo();
80108699:	e8 e2 fe ff ff       	call   80108580 <scfifo>
      int swap_offset = curproc->free_head->off;
8010869e:	8b 96 14 04 00 00    	mov    0x414(%esi),%edx
    return scfifo();
801086a4:	89 c3                	mov    %eax,%ebx
      if(curproc->free_head->next == 0)
801086a6:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
801086a9:	8b 3a                	mov    (%edx),%edi
      if(curproc->free_head->next == 0)
801086ab:	85 c0                	test   %eax,%eax
801086ad:	0f 84 ed 00 00 00    	je     801087a0 <allocuvm_withswap+0x120>
        kfree((char*)curproc->free_head->prev);
801086b3:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
801086b6:	89 86 14 04 00 00    	mov    %eax,0x414(%esi)
        kfree((char*)curproc->free_head->prev);
801086bc:	ff 70 08             	pushl  0x8(%eax)
801086bf:	e8 8c a3 ff ff       	call   80102a50 <kfree>
801086c4:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
801086c7:	6b db 1c             	imul   $0x1c,%ebx,%ebx
801086ca:	68 00 10 00 00       	push   $0x1000
801086cf:	57                   	push   %edi
801086d0:	01 f3                	add    %esi,%ebx
801086d2:	ff b3 50 02 00 00    	pushl  0x250(%ebx)
801086d8:	56                   	push   %esi
801086d9:	e8 22 9f ff ff       	call   80102600 <writeToSwapFile>
801086de:	83 c4 10             	add    $0x10,%esp
801086e1:	85 c0                	test   %eax,%eax
801086e3:	0f 88 f6 00 00 00    	js     801087df <allocuvm_withswap+0x15f>
      curproc->swappedPages[curproc->num_swap].isused = 1;
801086e9:	8b 86 0c 04 00 00    	mov    0x40c(%esi),%eax
801086ef:	6b c8 1c             	imul   $0x1c,%eax,%ecx
801086f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801086f5:	01 f1                	add    %esi,%ecx
801086f7:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
801086fe:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80108701:	8b 93 50 02 00 00    	mov    0x250(%ebx),%edx
80108707:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
8010870d:	8b 83 48 02 00 00    	mov    0x248(%ebx),%eax
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80108713:	89 b9 94 00 00 00    	mov    %edi,0x94(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80108719:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
8010871f:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108725:	0f 22 d9             	mov    %ecx,%cr3
      curproc->num_swap ++;
80108728:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010872b:	8d 4f 01             	lea    0x1(%edi),%ecx
8010872e:	89 8e 0c 04 00 00    	mov    %ecx,0x40c(%esi)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80108734:	31 c9                	xor    %ecx,%ecx
80108736:	e8 a5 ed ff ff       	call   801074e0 <walkpgdir>
      if(!(*evicted_pte & PTE_P))
8010873b:	8b 10                	mov    (%eax),%edx
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
8010873d:	89 c6                	mov    %eax,%esi
      if(!(*evicted_pte & PTE_P))
8010873f:	f6 c2 01             	test   $0x1,%dl
80108742:	0f 84 8a 00 00 00    	je     801087d2 <allocuvm_withswap+0x152>
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80108748:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(evicted_pa));
8010874e:	83 ec 0c             	sub    $0xc,%esp
80108751:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108757:	52                   	push   %edx
80108758:	e8 f3 a2 ff ff       	call   80102a50 <kfree>
      *evicted_pte &= ~PTE_P;
8010875d:	8b 16                	mov    (%esi),%edx
      newpage->pgdir = pgdir; // ??? 
8010875f:	8b 45 0c             	mov    0xc(%ebp),%eax
}
80108762:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
80108765:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
8010876b:	80 ce 02             	or     $0x2,%dh
8010876e:	89 16                	mov    %edx,(%esi)
      newpage->pgdir = pgdir; // ??? 
80108770:	89 83 48 02 00 00    	mov    %eax,0x248(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80108776:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->isused = 1;
80108779:	c7 83 4c 02 00 00 01 	movl   $0x1,0x24c(%ebx)
80108780:	00 00 00 
      newpage->swap_offset = -1;
80108783:	c7 83 54 02 00 00 ff 	movl   $0xffffffff,0x254(%ebx)
8010878a:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
8010878d:	89 83 50 02 00 00    	mov    %eax,0x250(%ebx)
}
80108793:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108796:	5b                   	pop    %ebx
80108797:	5e                   	pop    %esi
80108798:	5f                   	pop    %edi
80108799:	5d                   	pop    %ebp
8010879a:	c3                   	ret    
8010879b:	90                   	nop
8010879c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
801087a0:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
801087a3:	c7 86 18 04 00 00 00 	movl   $0x0,0x418(%esi)
801087aa:	00 00 00 
        kfree((char*)curproc->free_head);
801087ad:	52                   	push   %edx
801087ae:	e8 9d a2 ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
801087b3:	c7 86 14 04 00 00 00 	movl   $0x0,0x414(%esi)
801087ba:	00 00 00 
801087bd:	83 c4 10             	add    $0x10,%esp
801087c0:	e9 02 ff ff ff       	jmp    801086c7 <allocuvm_withswap+0x47>
        panic("page limit exceeded");
801087c5:	83 ec 0c             	sub    $0xc,%esp
801087c8:	68 3b 9b 10 80       	push   $0x80109b3b
801087cd:	e8 be 7b ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
801087d2:	83 ec 0c             	sub    $0xc,%esp
801087d5:	68 c8 9c 10 80       	push   $0x80109cc8
801087da:	e8 b1 7b ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801087df:	83 ec 0c             	sub    $0xc,%esp
801087e2:	68 4f 9b 10 80       	push   $0x80109b4f
801087e7:	e8 a4 7b ff ff       	call   80100390 <panic>
801087ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801087f0 <allocuvm_paging>:
{
801087f0:	55                   	push   %ebp
801087f1:	89 e5                	mov    %esp,%ebp
801087f3:	56                   	push   %esi
801087f4:	53                   	push   %ebx
801087f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
801087f8:	8b 75 0c             	mov    0xc(%ebp),%esi
801087fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801087fe:	8b 81 08 04 00 00    	mov    0x408(%ecx),%eax
80108804:	83 f8 0f             	cmp    $0xf,%eax
80108807:	7f 37                	jg     80108840 <allocuvm_paging+0x50>
  page->isused = 1;
80108809:	6b d0 1c             	imul   $0x1c,%eax,%edx
  curproc->num_ram++;
8010880c:	83 c0 01             	add    $0x1,%eax
  page->isused = 1;
8010880f:	01 ca                	add    %ecx,%edx
80108811:	c7 82 4c 02 00 00 01 	movl   $0x1,0x24c(%edx)
80108818:	00 00 00 
  page->pgdir = pgdir;
8010881b:	89 b2 48 02 00 00    	mov    %esi,0x248(%edx)
  page->swap_offset = -1;
80108821:	c7 82 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edx)
80108828:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
8010882b:	89 9a 50 02 00 00    	mov    %ebx,0x250(%edx)
  curproc->num_ram++;
80108831:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
}
80108837:	5b                   	pop    %ebx
80108838:	5e                   	pop    %esi
80108839:	5d                   	pop    %ebp
8010883a:	c3                   	ret    
8010883b:	90                   	nop
8010883c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108840:	5b                   	pop    %ebx
80108841:	5e                   	pop    %esi
80108842:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80108843:	e9 38 fe ff ff       	jmp    80108680 <allocuvm_withswap>
80108848:	90                   	nop
80108849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108850 <allocuvm>:
{
80108850:	55                   	push   %ebp
80108851:	89 e5                	mov    %esp,%ebp
80108853:	57                   	push   %edi
80108854:	56                   	push   %esi
80108855:	53                   	push   %ebx
80108856:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80108859:	e8 62 ba ff ff       	call   801042c0 <myproc>
8010885e:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80108860:	8b 45 10             	mov    0x10(%ebp),%eax
80108863:	85 c0                	test   %eax,%eax
80108865:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108868:	0f 88 e2 00 00 00    	js     80108950 <allocuvm+0x100>
  if(newsz < oldsz)
8010886e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80108871:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80108874:	0f 82 c6 00 00 00    	jb     80108940 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
8010887a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80108880:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80108886:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108889:	77 41                	ja     801088cc <allocuvm+0x7c>
8010888b:	e9 b3 00 00 00       	jmp    80108943 <allocuvm+0xf3>
  page->isused = 1;
80108890:	6b c2 1c             	imul   $0x1c,%edx,%eax
  page->pgdir = pgdir;
80108893:	8b 4d 08             	mov    0x8(%ebp),%ecx
  curproc->num_ram++;
80108896:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80108899:	01 f8                	add    %edi,%eax
8010889b:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
801088a2:	00 00 00 
  page->pgdir = pgdir;
801088a5:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->swap_offset = -1;
801088ab:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
801088b2:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
801088b5:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
801088bb:	89 97 08 04 00 00    	mov    %edx,0x408(%edi)
  for(; a < newsz; a += PGSIZE){
801088c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801088c7:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801088ca:	76 77                	jbe    80108943 <allocuvm+0xf3>
    mem = kalloc();
801088cc:	e8 5f a4 ff ff       	call   80102d30 <kalloc>
    if(mem == 0){
801088d1:	85 c0                	test   %eax,%eax
    mem = kalloc();
801088d3:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801088d5:	0f 84 8d 00 00 00    	je     80108968 <allocuvm+0x118>
    memset(mem, 0, PGSIZE);
801088db:	83 ec 04             	sub    $0x4,%esp
801088de:	68 00 10 00 00       	push   $0x1000
801088e3:	6a 00                	push   $0x0
801088e5:	50                   	push   %eax
801088e6:	e8 45 ca ff ff       	call   80105330 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801088eb:	58                   	pop    %eax
801088ec:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801088f2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801088f7:	5a                   	pop    %edx
801088f8:	6a 06                	push   $0x6
801088fa:	50                   	push   %eax
801088fb:	89 da                	mov    %ebx,%edx
801088fd:	8b 45 08             	mov    0x8(%ebp),%eax
80108900:	e8 5b ec ff ff       	call   80107560 <mappages>
80108905:	83 c4 10             	add    $0x10,%esp
80108908:	85 c0                	test   %eax,%eax
8010890a:	0f 88 90 00 00 00    	js     801089a0 <allocuvm+0x150>
    if(curproc->pid > 2) 
80108910:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80108914:	7e ab                	jle    801088c1 <allocuvm+0x71>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80108916:	8b 97 08 04 00 00    	mov    0x408(%edi),%edx
8010891c:	83 fa 0f             	cmp    $0xf,%edx
8010891f:	0f 8e 6b ff ff ff    	jle    80108890 <allocuvm+0x40>
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80108925:	83 ec 04             	sub    $0x4,%esp
80108928:	53                   	push   %ebx
80108929:	ff 75 08             	pushl  0x8(%ebp)
8010892c:	57                   	push   %edi
8010892d:	e8 4e fd ff ff       	call   80108680 <allocuvm_withswap>
80108932:	83 c4 10             	add    $0x10,%esp
80108935:	eb 8a                	jmp    801088c1 <allocuvm+0x71>
80108937:	89 f6                	mov    %esi,%esi
80108939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
80108940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80108943:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108946:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108949:	5b                   	pop    %ebx
8010894a:	5e                   	pop    %esi
8010894b:	5f                   	pop    %edi
8010894c:	5d                   	pop    %ebp
8010894d:	c3                   	ret    
8010894e:	66 90                	xchg   %ax,%ax
    return 0;
80108950:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80108957:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010895a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010895d:	5b                   	pop    %ebx
8010895e:	5e                   	pop    %esi
8010895f:	5f                   	pop    %edi
80108960:	5d                   	pop    %ebp
80108961:	c3                   	ret    
80108962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80108968:	83 ec 0c             	sub    $0xc,%esp
8010896b:	68 69 9b 10 80       	push   $0x80109b69
80108970:	e8 eb 7c ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108975:	83 c4 0c             	add    $0xc,%esp
80108978:	ff 75 0c             	pushl  0xc(%ebp)
8010897b:	ff 75 10             	pushl  0x10(%ebp)
8010897e:	ff 75 08             	pushl  0x8(%ebp)
80108981:	e8 0a f1 ff ff       	call   80107a90 <deallocuvm>
      return 0;
80108986:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010898d:	83 c4 10             	add    $0x10,%esp
}
80108990:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108993:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108996:	5b                   	pop    %ebx
80108997:	5e                   	pop    %esi
80108998:	5f                   	pop    %edi
80108999:	5d                   	pop    %ebp
8010899a:	c3                   	ret    
8010899b:	90                   	nop
8010899c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801089a0:	83 ec 0c             	sub    $0xc,%esp
801089a3:	68 81 9b 10 80       	push   $0x80109b81
801089a8:	e8 b3 7c ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801089ad:	83 c4 0c             	add    $0xc,%esp
801089b0:	ff 75 0c             	pushl  0xc(%ebp)
801089b3:	ff 75 10             	pushl  0x10(%ebp)
801089b6:	ff 75 08             	pushl  0x8(%ebp)
801089b9:	e8 d2 f0 ff ff       	call   80107a90 <deallocuvm>
      kfree(mem);
801089be:	89 34 24             	mov    %esi,(%esp)
801089c1:	e8 8a a0 ff ff       	call   80102a50 <kfree>
      return 0;
801089c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801089cd:	83 c4 10             	add    $0x10,%esp
}
801089d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801089d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089d6:	5b                   	pop    %ebx
801089d7:	5e                   	pop    %esi
801089d8:	5f                   	pop    %edi
801089d9:	5d                   	pop    %ebp
801089da:	c3                   	ret    
801089db:	90                   	nop
801089dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801089e0 <handle_pagedout>:
{
801089e0:	55                   	push   %ebp
801089e1:	89 e5                	mov    %esp,%ebp
801089e3:	57                   	push   %edi
801089e4:	56                   	push   %esi
801089e5:	53                   	push   %ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801089e6:	31 ff                	xor    %edi,%edi
{
801089e8:	83 ec 20             	sub    $0x20,%esp
801089eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
801089ee:	8b 75 10             	mov    0x10(%ebp),%esi
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
801089f1:	8d 43 6c             	lea    0x6c(%ebx),%eax
801089f4:	ff 73 10             	pushl  0x10(%ebx)
801089f7:	50                   	push   %eax
801089f8:	68 f0 9c 10 80       	push   $0x80109cf0
801089fd:	e8 5e 7c ff ff       	call   80100660 <cprintf>
    new_page = kalloc();
80108a02:	e8 29 a3 ff ff       	call   80102d30 <kalloc>
    *pte &= 0xFFF;
80108a07:	8b 16                	mov    (%esi),%edx
    *pte |= V2P(new_page);
80108a09:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
80108a0e:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
80108a14:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
80108a17:	09 d0                	or     %edx,%eax
80108a19:	89 06                	mov    %eax,(%esi)
  struct proc* curproc = myproc();
80108a1b:	e8 a0 b8 ff ff       	call   801042c0 <myproc>
80108a20:	83 c4 10             	add    $0x10,%esp
80108a23:	05 90 00 00 00       	add    $0x90,%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a28:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a2b:	eb 12                	jmp    80108a3f <handle_pagedout+0x5f>
80108a2d:	8d 76 00             	lea    0x0(%esi),%esi
80108a30:	83 c7 01             	add    $0x1,%edi
80108a33:	83 c0 1c             	add    $0x1c,%eax
80108a36:	83 ff 10             	cmp    $0x10,%edi
80108a39:	0f 84 01 02 00 00    	je     80108c40 <handle_pagedout+0x260>
    if(curproc->swappedPages[i].virt_addr == va)
80108a3f:	3b 10                	cmp    (%eax),%edx
80108a41:	75 ed                	jne    80108a30 <handle_pagedout+0x50>
80108a43:	6b f7 1c             	imul   $0x1c,%edi,%esi
80108a46:	81 c6 88 00 00 00    	add    $0x88,%esi
    struct page *swap_page = &curproc->swappedPages[index];
80108a4c:	8d 04 33             	lea    (%ebx,%esi,1),%eax
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108a4f:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80108a54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108a57:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108a5a:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80108a5d:	ff b6 94 00 00 00    	pushl  0x94(%esi)
80108a63:	68 e0 c5 10 80       	push   $0x8010c5e0
80108a68:	53                   	push   %ebx
80108a69:	e8 c2 9b ff ff       	call   80102630 <readFromSwapFile>
80108a6e:	83 c4 10             	add    $0x10,%esp
80108a71:	85 c0                	test   %eax,%eax
80108a73:	0f 88 1c 02 00 00    	js     80108c95 <handle_pagedout+0x2b5>
    struct fblock *new_block = (struct fblock*)kalloc();
80108a79:	e8 b2 a2 ff ff       	call   80102d30 <kalloc>
    new_block->off = swap_page->swap_offset;
80108a7e:	8b 96 94 00 00 00    	mov    0x94(%esi),%edx
    new_block->next = 0;
80108a84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
80108a8b:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80108a8d:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108a93:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
80108a96:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108a9c:	85 d2                	test   %edx,%edx
80108a9e:	0f 84 ac 01 00 00    	je     80108c50 <handle_pagedout+0x270>
      curproc->free_tail->next = new_block;
80108aa4:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80108aa7:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80108aaa:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108ab0:	68 00 10 00 00       	push   $0x1000
80108ab5:	68 e0 c5 10 80       	push   $0x8010c5e0
80108aba:	ff 75 0c             	pushl  0xc(%ebp)
80108abd:	e8 1e c9 ff ff       	call   801053e0 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80108ac2:	83 c4 0c             	add    $0xc,%esp
80108ac5:	6a 1c                	push   $0x1c
80108ac7:	6a 00                	push   $0x0
80108ac9:	ff 75 e4             	pushl  -0x1c(%ebp)
80108acc:	e8 5f c8 ff ff       	call   80105330 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108ad1:	83 c4 10             	add    $0x10,%esp
80108ad4:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
80108adb:	0f 8f 7f 00 00 00    	jg     80108b60 <handle_pagedout+0x180>
  struct proc * currproc = myproc();
80108ae1:	e8 da b7 ff ff       	call   801042c0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108ae6:	31 f6                	xor    %esi,%esi
80108ae8:	05 4c 02 00 00       	add    $0x24c,%eax
80108aed:	eb 10                	jmp    80108aff <handle_pagedout+0x11f>
80108aef:	90                   	nop
80108af0:	83 c6 01             	add    $0x1,%esi
80108af3:	83 c0 1c             	add    $0x1c,%eax
80108af6:	83 fe 10             	cmp    $0x10,%esi
80108af9:	0f 84 61 01 00 00    	je     80108c60 <handle_pagedout+0x280>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108aff:	8b 10                	mov    (%eax),%edx
80108b01:	85 d2                	test   %edx,%edx
80108b03:	75 eb                	jne    80108af0 <handle_pagedout+0x110>
      cprintf("filling ram slot: %d\n", new_indx);
80108b05:	83 ec 08             	sub    $0x8,%esp
80108b08:	56                   	push   %esi
80108b09:	68 b8 9b 10 80       	push   $0x80109bb8
      curproc->ramPages[new_indx].virt_addr = start_page;
80108b0e:	6b f6 1c             	imul   $0x1c,%esi,%esi
      cprintf("filling ram slot: %d\n", new_indx);
80108b11:	e8 4a 7b ff ff       	call   80100660 <cprintf>
      curproc->ramPages[new_indx].virt_addr = start_page;
80108b16:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b19:	83 c4 10             	add    $0x10,%esp
80108b1c:	01 de                	add    %ebx,%esi
      curproc->ramPages[new_indx].isused = 1;
80108b1e:	c7 86 4c 02 00 00 01 	movl   $0x1,0x24c(%esi)
80108b25:	00 00 00 
      curproc->ramPages[new_indx].virt_addr = start_page;
80108b28:	89 86 50 02 00 00    	mov    %eax,0x250(%esi)
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108b2e:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80108b31:	c7 86 54 02 00 00 ff 	movl   $0xffffffff,0x254(%esi)
80108b38:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108b3b:	89 86 48 02 00 00    	mov    %eax,0x248(%esi)
      curproc->num_ram++;
80108b41:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
80108b48:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
80108b4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b52:	5b                   	pop    %ebx
80108b53:	5e                   	pop    %esi
80108b54:	5f                   	pop    %edi
80108b55:	5d                   	pop    %ebp
80108b56:	c3                   	ret    
80108b57:	89 f6                	mov    %esi,%esi
80108b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return scfifo();
80108b60:	e8 1b fa ff ff       	call   80108580 <scfifo>
      int swap_offset = curproc->free_head->off;
80108b65:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
    return scfifo();
80108b6b:	89 c6                	mov    %eax,%esi
      int swap_offset = curproc->free_head->off;
80108b6d:	8b 02                	mov    (%edx),%eax
80108b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
80108b72:	8b 42 04             	mov    0x4(%edx),%eax
80108b75:	85 c0                	test   %eax,%eax
80108b77:	0f 84 f3 00 00 00    	je     80108c70 <handle_pagedout+0x290>
        kfree((char*)curproc->free_head->prev);
80108b7d:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80108b80:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108b86:	ff 70 08             	pushl  0x8(%eax)
80108b89:	e8 c2 9e ff ff       	call   80102a50 <kfree>
80108b8e:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108b91:	6b f6 1c             	imul   $0x1c,%esi,%esi
80108b94:	68 00 10 00 00       	push   $0x1000
80108b99:	ff 75 e4             	pushl  -0x1c(%ebp)
80108b9c:	01 de                	add    %ebx,%esi
80108b9e:	ff b6 50 02 00 00    	pushl  0x250(%esi)
80108ba4:	53                   	push   %ebx
80108ba5:	e8 56 9a ff ff       	call   80102600 <writeToSwapFile>
80108baa:	83 c4 10             	add    $0x10,%esp
80108bad:	85 c0                	test   %eax,%eax
80108baf:	0f 88 ed 00 00 00    	js     80108ca2 <handle_pagedout+0x2c2>
      swap_page->virt_addr = ram_page->virt_addr;
80108bb5:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80108bb8:	8b 96 50 02 00 00    	mov    0x250(%esi),%edx
80108bbe:	01 d9                	add    %ebx,%ecx
80108bc0:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
80108bc6:	8b 86 48 02 00 00    	mov    0x248(%esi),%eax
      swap_page->isused = 1;
80108bcc:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80108bd3:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80108bd6:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108bdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108bdf:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108be5:	8b 43 04             	mov    0x4(%ebx),%eax
80108be8:	31 c9                	xor    %ecx,%ecx
80108bea:	e8 f1 e8 ff ff       	call   801074e0 <walkpgdir>
      if(!(*pte & PTE_P))
80108bef:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108bf1:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80108bf3:	f6 c2 01             	test   $0x1,%dl
80108bf6:	0f 84 b3 00 00 00    	je     80108caf <handle_pagedout+0x2cf>
      ramPa = (void*)PTE_ADDR(*pte);
80108bfc:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80108c02:	83 ec 0c             	sub    $0xc,%esp
80108c05:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108c0b:	52                   	push   %edx
80108c0c:	e8 3f 9e ff ff       	call   80102a50 <kfree>
      *pte &= ~PTE_P;     // turn "present" flag off
80108c11:	8b 07                	mov    (%edi),%eax
80108c13:	25 fe 0f 00 00       	and    $0xffe,%eax
80108c18:	80 cc 02             	or     $0x2,%ah
80108c1b:	89 07                	mov    %eax,(%edi)
      ram_page->virt_addr = start_page;
80108c1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c20:	89 86 50 02 00 00    	mov    %eax,0x250(%esi)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108c26:	8b 43 04             	mov    0x4(%ebx),%eax
80108c29:	05 00 00 00 80       	add    $0x80000000,%eax
80108c2e:	0f 22 d8             	mov    %eax,%cr3
80108c31:	83 c4 10             	add    $0x10,%esp
}
80108c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c37:	5b                   	pop    %ebx
80108c38:	5e                   	pop    %esi
80108c39:	5f                   	pop    %edi
80108c3a:	5d                   	pop    %ebp
80108c3b:	c3                   	ret    
80108c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108c40:	be 6c 00 00 00       	mov    $0x6c,%esi
  return -1;
80108c45:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108c4a:	e9 fd fd ff ff       	jmp    80108a4c <handle_pagedout+0x6c>
80108c4f:	90                   	nop
      curproc->free_head = new_block;
80108c50:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108c56:	e9 4c fe ff ff       	jmp    80108aa7 <handle_pagedout+0xc7>
80108c5b:	90                   	nop
80108c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108c60:	be ff ff ff ff       	mov    $0xffffffff,%esi
80108c65:	e9 9b fe ff ff       	jmp    80108b05 <handle_pagedout+0x125>
80108c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree((char*)curproc->free_head);
80108c70:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80108c73:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80108c7a:	00 00 00 
        kfree((char*)curproc->free_head);
80108c7d:	52                   	push   %edx
80108c7e:	e8 cd 9d ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80108c83:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80108c8a:	00 00 00 
80108c8d:	83 c4 10             	add    $0x10,%esp
80108c90:	e9 fc fe ff ff       	jmp    80108b91 <handle_pagedout+0x1b1>
      panic("allocuvm: readFromSwapFile");
80108c95:	83 ec 0c             	sub    $0xc,%esp
80108c98:	68 9d 9b 10 80       	push   $0x80109b9d
80108c9d:	e8 ee 76 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108ca2:	83 ec 0c             	sub    $0xc,%esp
80108ca5:	68 4f 9b 10 80       	push   $0x80109b4f
80108caa:	e8 e1 76 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108caf:	83 ec 0c             	sub    $0xc,%esp
80108cb2:	68 20 9d 10 80       	push   $0x80109d20
80108cb7:	e8 d4 76 ff ff       	call   80100390 <panic>
80108cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108cc0 <pagefault>:
{
80108cc0:	55                   	push   %ebp
80108cc1:	89 e5                	mov    %esp,%ebp
80108cc3:	57                   	push   %edi
80108cc4:	56                   	push   %esi
80108cc5:	53                   	push   %ebx
80108cc6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108cc9:	e8 f2 b5 ff ff       	call   801042c0 <myproc>
80108cce:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108cd0:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108cd3:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108cda:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108cdc:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108cdf:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108ce5:	31 c9                	xor    %ecx,%ecx
80108ce7:	89 fa                	mov    %edi,%edx
80108ce9:	e8 f2 e7 ff ff       	call   801074e0 <walkpgdir>
  if((*pte & PTE_PG) && (*pte & ~PTE_COW)) // paged out, not COW todo
80108cee:	8b 10                	mov    (%eax),%edx
80108cf0:	f6 c6 02             	test   $0x2,%dh
80108cf3:	74 08                	je     80108cfd <pagefault+0x3d>
80108cf5:	81 e2 ff fb ff ff    	and    $0xfffffbff,%edx
80108cfb:	75 6b                	jne    80108d68 <pagefault+0xa8>
    cprintf("pagefault - %s (pid %d) - maybe COW\n", curproc->name, curproc->pid);
80108cfd:	8d 7b 6c             	lea    0x6c(%ebx),%edi
80108d00:	83 ec 04             	sub    $0x4,%esp
80108d03:	ff 73 10             	pushl  0x10(%ebx)
80108d06:	57                   	push   %edi
80108d07:	68 44 9d 10 80       	push   $0x80109d44
80108d0c:	e8 4f 79 ff ff       	call   80100660 <cprintf>
    if(va >= KERNBASE || pte == 0)
80108d11:	83 c4 10             	add    $0x10,%esp
80108d14:	85 f6                	test   %esi,%esi
80108d16:	78 28                	js     80108d40 <pagefault+0x80>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108d18:	8b 43 04             	mov    0x4(%ebx),%eax
80108d1b:	31 c9                	xor    %ecx,%ecx
80108d1d:	89 f2                	mov    %esi,%edx
80108d1f:	e8 bc e7 ff ff       	call   801074e0 <walkpgdir>
80108d24:	85 c0                	test   %eax,%eax
80108d26:	74 56                	je     80108d7e <pagefault+0xbe>
    handle_cow_pagefault(curproc, pte, va);
80108d28:	83 ec 04             	sub    $0x4,%esp
80108d2b:	56                   	push   %esi
80108d2c:	50                   	push   %eax
80108d2d:	53                   	push   %ebx
80108d2e:	e8 1d f2 ff ff       	call   80107f50 <handle_cow_pagefault>
80108d33:	83 c4 10             	add    $0x10,%esp
}
80108d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d39:	5b                   	pop    %ebx
80108d3a:	5e                   	pop    %esi
80108d3b:	5f                   	pop    %edi
80108d3c:	5d                   	pop    %ebp
80108d3d:	c3                   	ret    
80108d3e:	66 90                	xchg   %ax,%ax
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108d40:	83 ec 04             	sub    $0x4,%esp
80108d43:	57                   	push   %edi
80108d44:	ff 73 10             	pushl  0x10(%ebx)
80108d47:	68 6c 9d 10 80       	push   $0x80109d6c
80108d4c:	e8 0f 79 ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80108d51:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
80108d58:	83 c4 10             	add    $0x10,%esp
}
80108d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d5e:	5b                   	pop    %ebx
80108d5f:	5e                   	pop    %esi
80108d60:	5f                   	pop    %edi
80108d61:	5d                   	pop    %ebp
80108d62:	c3                   	ret    
80108d63:	90                   	nop
80108d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    handle_pagedout(curproc, start_page, pte);
80108d68:	83 ec 04             	sub    $0x4,%esp
80108d6b:	50                   	push   %eax
80108d6c:	57                   	push   %edi
80108d6d:	53                   	push   %ebx
80108d6e:	e8 6d fc ff ff       	call   801089e0 <handle_pagedout>
80108d73:	83 c4 10             	add    $0x10,%esp
}
80108d76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d79:	5b                   	pop    %ebx
80108d7a:	5e                   	pop    %esi
80108d7b:	5f                   	pop    %edi
80108d7c:	5d                   	pop    %ebp
80108d7d:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
80108d7e:	83 ec 0c             	sub    $0xc,%esp
80108d81:	68 ce 9b 10 80       	push   $0x80109bce
80108d86:	e8 05 76 ff ff       	call   80100390 <panic>
80108d8b:	90                   	nop
80108d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108d90 <countSetBits>:
{
80108d90:	55                   	push   %ebp
    uint count = 0;
80108d91:	31 c0                	xor    %eax,%eax
{
80108d93:	89 e5                	mov    %esp,%ebp
80108d95:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108d98:	85 d2                	test   %edx,%edx
80108d9a:	74 0f                	je     80108dab <countSetBits+0x1b>
80108d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108da0:	89 d1                	mov    %edx,%ecx
80108da2:	83 e1 01             	and    $0x1,%ecx
80108da5:	01 c8                	add    %ecx,%eax
    while (n) {
80108da7:	d1 ea                	shr    %edx
80108da9:	75 f5                	jne    80108da0 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108dab:	5d                   	pop    %ebp
80108dac:	c3                   	ret    
80108dad:	8d 76 00             	lea    0x0(%esi),%esi

80108db0 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108db0:	55                   	push   %ebp
80108db1:	89 e5                	mov    %esp,%ebp
80108db3:	56                   	push   %esi
80108db4:	53                   	push   %ebx
80108db5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
80108db8:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108dbb:	e8 00 b5 ff ff       	call   801042c0 <myproc>
80108dc0:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108dc6:	74 30                	je     80108df8 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108dc8:	e8 f3 b4 ff ff       	call   801042c0 <myproc>
80108dcd:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108dd3:	74 53                	je     80108e28 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108dd5:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108dd8:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108dda:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108ddc:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108ddf:	85 d2                	test   %edx,%edx
80108de1:	74 05                	je     80108de8 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108de3:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108de6:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108de8:	85 c0                	test   %eax,%eax
80108dea:	74 05                	je     80108df1 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108dec:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108dee:	89 70 04             	mov    %esi,0x4(%eax)
  }
80108df1:	5b                   	pop    %ebx
80108df2:	5e                   	pop    %esi
80108df3:	5d                   	pop    %ebp
80108df4:	c3                   	ret    
80108df5:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108df8:	e8 c3 b4 ff ff       	call   801042c0 <myproc>
80108dfd:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108e03:	e8 b8 b4 ff ff       	call   801042c0 <myproc>
80108e08:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108e0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108e14:	e8 a7 b4 ff ff       	call   801042c0 <myproc>
80108e19:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108e1f:	75 b4                	jne    80108dd5 <swapAQ+0x25>
80108e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108e28:	e8 93 b4 ff ff       	call   801042c0 <myproc>
80108e2d:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108e33:	e8 88 b4 ff ff       	call   801042c0 <myproc>
80108e38:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108e3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108e45:	eb 8e                	jmp    80108dd5 <swapAQ+0x25>
80108e47:	89 f6                	mov    %esi,%esi
80108e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108e50 <updateAQ>:
{
80108e50:	55                   	push   %ebp
80108e51:	89 e5                	mov    %esp,%ebp
80108e53:	57                   	push   %edi
80108e54:	56                   	push   %esi
80108e55:	53                   	push   %ebx
80108e56:	83 ec 1c             	sub    $0x1c,%esp
80108e59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108e5c:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108e62:	85 d2                	test   %edx,%edx
80108e64:	0f 84 7e 00 00 00    	je     80108ee8 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108e6a:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108e70:	8b 56 04             	mov    0x4(%esi),%edx
80108e73:	85 d2                	test   %edx,%edx
80108e75:	74 71                	je     80108ee8 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80108e77:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
80108e7d:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108e81:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108e85:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108e88:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108e8a:	01 d8                	add    %ebx,%eax
80108e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80108e90:	8b 50 08             	mov    0x8(%eax),%edx
80108e93:	8b 00                	mov    (%eax),%eax
80108e95:	31 c9                	xor    %ecx,%ecx
80108e97:	e8 44 e6 ff ff       	call   801074e0 <walkpgdir>
80108e9c:	85 c0                	test   %eax,%eax
80108e9e:	89 c3                	mov    %eax,%ebx
80108ea0:	74 5e                	je     80108f00 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80108ea2:	8b 00                	mov    (%eax),%eax
80108ea4:	8b 56 04             	mov    0x4(%esi),%edx
80108ea7:	a8 20                	test   $0x20,%al
80108ea9:	74 23                	je     80108ece <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
80108eab:	85 d2                	test   %edx,%edx
80108ead:	74 17                	je     80108ec6 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80108eaf:	8b 57 08             	mov    0x8(%edi),%edx
80108eb2:	8b 07                	mov    (%edi),%eax
80108eb4:	31 c9                	xor    %ecx,%ecx
80108eb6:	e8 25 e6 ff ff       	call   801074e0 <walkpgdir>
80108ebb:	85 c0                	test   %eax,%eax
80108ebd:	74 41                	je     80108f00 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80108ebf:	f6 00 20             	testb  $0x20,(%eax)
80108ec2:	74 2c                	je     80108ef0 <updateAQ+0xa0>
80108ec4:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80108ec6:	83 e0 df             	and    $0xffffffdf,%eax
80108ec9:	89 03                	mov    %eax,(%ebx)
80108ecb:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80108ece:	85 d2                	test   %edx,%edx
80108ed0:	74 16                	je     80108ee8 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80108ed2:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108ed6:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80108eda:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80108edd:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
80108edf:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108ee1:	01 cf                	add    %ecx,%edi
80108ee3:	eb ab                	jmp    80108e90 <updateAQ+0x40>
80108ee5:	8d 76 00             	lea    0x0(%esi),%esi
}
80108ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108eeb:	5b                   	pop    %ebx
80108eec:	5e                   	pop    %esi
80108eed:	5f                   	pop    %edi
80108eee:	5d                   	pop    %ebp
80108eef:	c3                   	ret    
          swapAQ(curr_node);
80108ef0:	83 ec 0c             	sub    $0xc,%esp
80108ef3:	56                   	push   %esi
80108ef4:	e8 b7 fe ff ff       	call   80108db0 <swapAQ>
80108ef9:	8b 03                	mov    (%ebx),%eax
80108efb:	83 c4 10             	add    $0x10,%esp
80108efe:	eb c6                	jmp    80108ec6 <updateAQ+0x76>
      panic("updateAQ: no pte");
80108f00:	83 ec 0c             	sub    $0xc,%esp
80108f03:	68 e7 9b 10 80       	push   $0x80109be7
80108f08:	e8 83 74 ff ff       	call   80100390 <panic>
