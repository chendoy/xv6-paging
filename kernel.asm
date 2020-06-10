
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
8010002d:	b8 60 38 10 80       	mov    $0x80103860,%eax
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
8010004c:	68 80 8f 10 80       	push   $0x80108f80
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 55 50 00 00       	call   801050b0 <initlock>
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
80100092:	68 87 8f 10 80       	push   $0x80108f87
80100097:	50                   	push   %eax
80100098:	e8 e3 4e 00 00       	call   80104f80 <initsleeplock>
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
801000e4:	e8 07 51 00 00       	call   801051f0 <acquire>
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
80100162:	e8 49 51 00 00       	call   801052b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 4e 00 00       	call   80104fc0 <acquiresleep>
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
80100193:	68 8e 8f 10 80       	push   $0x80108f8e
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
801001ae:	e8 ad 4e 00 00       	call   80105060 <holdingsleep>
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
801001cc:	68 9f 8f 10 80       	push   $0x80108f9f
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
801001ef:	e8 6c 4e 00 00       	call   80105060 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 4e 00 00       	call   80105020 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 e0 4f 00 00       	call   801051f0 <acquire>
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
8010025c:	e9 4f 50 00 00       	jmp    801052b0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 8f 10 80       	push   $0x80108fa6
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
8010028c:	e8 5f 4f 00 00       	call   801051f0 <acquire>
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
801002c5:	e8 d6 47 00 00       	call   80104aa0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 2f 11 80    	cmp    0x80112fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 f0 3f 00 00       	call   801042d0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 bc 4f 00 00       	call   801052b0 <release>
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
8010034d:	e8 5e 4f 00 00       	call   801052b0 <release>
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
801003a9:	e8 42 2d 00 00       	call   801030f0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 8f 10 80       	push   $0x80108fad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 40 9b 10 80 	movl   $0x80109b40,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 4c 00 00       	call   801050d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 8f 10 80       	push   $0x80108fc1
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
8010043a:	e8 b1 65 00 00       	call   801069f0 <uartputc>
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
801004ec:	e8 ff 64 00 00       	call   801069f0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 f3 64 00 00       	call   801069f0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 e7 64 00 00       	call   801069f0 <uartputc>
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
80100524:	e8 87 4e 00 00       	call   801053b0 <memmove>
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
80100541:	e8 ba 4d 00 00       	call   80105300 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 8f 10 80       	push   $0x80108fc5
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
801005b1:	0f b6 92 f0 8f 10 80 	movzbl -0x7fef7010(%edx),%edx
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
8010061b:	e8 d0 4b 00 00       	call   801051f0 <acquire>
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
80100647:	e8 64 4c 00 00       	call   801052b0 <release>
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
8010071f:	e8 8c 4b 00 00       	call   801052b0 <release>
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
801007d0:	ba d8 8f 10 80       	mov    $0x80108fd8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 fb 49 00 00       	call   801051f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 8f 10 80       	push   $0x80108fdf
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
80100823:	e8 c8 49 00 00       	call   801051f0 <acquire>
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
80100888:	e8 23 4a 00 00       	call   801052b0 <release>
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
80100916:	e8 c5 43 00 00       	call   80104ce0 <wakeup>
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
80100997:	e9 d4 44 00 00       	jmp    80104e70 <procdump>
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
801009c6:	68 e8 8f 10 80       	push   $0x80108fe8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 db 46 00 00       	call   801050b0 <initlock>

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
80100a2b:	e8 80 49 00 00       	call   801053b0 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a30:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a36:	83 c4 0c             	add    $0xc,%esp
80100a39:	68 c0 01 00 00       	push   $0x1c0
80100a3e:	50                   	push   %eax
80100a3f:	68 c0 31 11 80       	push   $0x801131c0
80100a44:	e8 67 49 00 00       	call   801053b0 <memmove>
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
80100ac8:	e8 33 48 00 00       	call   80105300 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100acd:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ad3:	83 c4 0c             	add    $0xc,%esp
80100ad6:	68 c0 01 00 00       	push   $0x1c0
80100adb:	6a 00                	push   $0x0
80100add:	50                   	push   %eax
80100ade:	e8 1d 48 00 00       	call   80105300 <memset>
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
80100b11:	e8 2a 22 00 00       	call   80102d40 <kalloc>
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
80100b38:	e8 03 22 00 00       	call   80102d40 <kalloc>
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
80100bb7:	68 01 90 10 80       	push   $0x80109001
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
80100c37:	68 01 90 10 80       	push   $0x80109001
80100c3c:	e8 1f fa ff ff       	call   80100660 <cprintf>
80100c41:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	eb ba                	jmp    80100c06 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	68 30 90 10 80       	push   $0x80109030
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
80100c6c:	e8 5f 36 00 00       	call   801042d0 <myproc>
  
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
80100c7d:	e8 de 28 00 00       	call   80103560 <begin_op>

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
80100ccf:	68 22 90 10 80       	push   $0x80109022
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
80100cf4:	e8 d7 28 00 00       	call   801035d0 <end_op>
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
80100d44:	e8 67 46 00 00       	call   801053b0 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d49:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d4f:	83 c4 0c             	add    $0xc,%esp
80100d52:	68 c0 01 00 00       	push   $0x1c0
80100d57:	68 c0 31 11 80       	push   $0x801131c0
80100d5c:	50                   	push   %eax
80100d5d:	e8 4e 46 00 00       	call   801053b0 <memmove>
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
80100dc0:	e8 db 72 00 00       	call   801080a0 <setupkvm>
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
80100e2e:	e8 2d 70 00 00       	call   80107e60 <allocuvm>
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
80100e60:	e8 db 6a 00 00       	call   80107940 <loaduvm>
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
80100eaa:	68 22 90 10 80       	push   $0x80109022
80100eaf:	e8 ac f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100eb4:	58                   	pop    %eax
80100eb5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ebb:	e8 30 71 00 00       	call   80107ff0 <freevm>
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
80100efa:	e8 d1 26 00 00       	call   801035d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100eff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f05:	83 c4 0c             	add    $0xc,%esp
80100f08:	50                   	push   %eax
80100f09:	57                   	push   %edi
80100f0a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f10:	e8 4b 6f 00 00       	call   80107e60 <allocuvm>
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
80100f3e:	e8 0d 72 00 00       	call   80108150 <clearpteu>
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
80100f8b:	e8 90 45 00 00       	call   80105520 <strlen>
80100f90:	f7 d0                	not    %eax
80100f92:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f94:	58                   	pop    %eax
80100f95:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f98:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f9b:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f9e:	e8 7d 45 00 00       	call   80105520 <strlen>
80100fa3:	83 c0 01             	add    $0x1,%eax
80100fa6:	50                   	push   %eax
80100fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faa:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fad:	56                   	push   %esi
80100fae:	57                   	push   %edi
80100faf:	e8 7c 79 00 00       	call   80108930 <copyout>
80100fb4:	83 c4 20             	add    $0x20,%esp
80100fb7:	85 c0                	test   %eax,%eax
80100fb9:	79 ad                	jns    80100f68 <exec+0x308>
80100fbb:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ip = 0;
80100fc1:	31 f6                	xor    %esi,%esi
80100fc3:	e9 df fe ff ff       	jmp    80100ea7 <exec+0x247>
    end_op();
80100fc8:	e8 03 26 00 00       	call   801035d0 <end_op>
    cprintf("exec: fail\n");
80100fcd:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80100fd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("exec: fail\n");
80100fd5:	68 16 90 10 80       	push   $0x80109016
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
80101029:	e8 02 79 00 00       	call   80108930 <copyout>
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
80101061:	e8 7a 44 00 00       	call   801054e0 <safestrcpy>
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
801010d2:	e8 d9 66 00 00       	call   801077b0 <switchuvm>
  freevm(oldpgdir);
801010d7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 0b 6f 00 00       	call   80107ff0 <freevm>
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
80101116:	68 5b 90 10 80       	push   $0x8010905b
8010111b:	68 a0 33 11 80       	push   $0x801133a0
80101120:	e8 8b 3f 00 00       	call   801050b0 <initlock>
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
80101141:	e8 aa 40 00 00       	call   801051f0 <acquire>
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
80101171:	e8 3a 41 00 00       	call   801052b0 <release>
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
8010118a:	e8 21 41 00 00       	call   801052b0 <release>
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
801011af:	e8 3c 40 00 00       	call   801051f0 <acquire>
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
801011cc:	e8 df 40 00 00       	call   801052b0 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 62 90 10 80       	push   $0x80109062
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
80101201:	e8 ea 3f 00 00       	call   801051f0 <acquire>
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
8010122c:	e9 7f 40 00 00       	jmp    801052b0 <release>
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
80101258:	e8 53 40 00 00       	call   801052b0 <release>
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
80101281:	e8 8a 2a 00 00       	call   80103d10 <pipeclose>
80101286:	83 c4 10             	add    $0x10,%esp
80101289:	eb df                	jmp    8010126a <fileclose+0x7a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101290:	e8 cb 22 00 00       	call   80103560 <begin_op>
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
801012aa:	e9 21 23 00 00       	jmp    801035d0 <end_op>
    panic("fileclose");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 6a 90 10 80       	push   $0x8010906a
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
8010137d:	e9 3e 2b 00 00       	jmp    80103ec0 <piperead>
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101388:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010138d:	eb d7                	jmp    80101366 <fileread+0x56>
  panic("fileread");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 74 90 10 80       	push   $0x80109074
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
801013f9:	e8 d2 21 00 00       	call   801035d0 <end_op>
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
80101426:	e8 35 21 00 00       	call   80103560 <begin_op>
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
8010145d:	e8 6e 21 00 00       	call   801035d0 <end_op>
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
8010149d:	e9 0e 29 00 00       	jmp    80103db0 <pipewrite>
        panic("short filewrite");
801014a2:	83 ec 0c             	sub    $0xc,%esp
801014a5:	68 7d 90 10 80       	push   $0x8010907d
801014aa:	e8 e1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 83 90 10 80       	push   $0x80109083
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
80101509:	e8 22 22 00 00       	call   80103730 <log_write>
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
80101523:	68 8d 90 10 80       	push   $0x8010908d
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
801015d4:	68 a0 90 10 80       	push   $0x801090a0
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
801015ed:	e8 3e 21 00 00       	call   80103730 <log_write>
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
80101615:	e8 e6 3c 00 00       	call   80105300 <memset>
  log_write(bp);
8010161a:	89 1c 24             	mov    %ebx,(%esp)
8010161d:	e8 0e 21 00 00       	call   80103730 <log_write>
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
8010165a:	e8 91 3b 00 00       	call   801051f0 <acquire>
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
801016bf:	e8 ec 3b 00 00       	call   801052b0 <release>

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
801016ed:	e8 be 3b 00 00       	call   801052b0 <release>
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
80101702:	68 b6 90 10 80       	push   $0x801090b6
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
8010177e:	e8 ad 1f 00 00       	call   80103730 <log_write>
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
801017d7:	68 c6 90 10 80       	push   $0x801090c6
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
80101811:	e8 9a 3b 00 00       	call   801053b0 <memmove>
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
8010183c:	68 d9 90 10 80       	push   $0x801090d9
80101841:	68 c0 3d 11 80       	push   $0x80113dc0
80101846:	e8 65 38 00 00       	call   801050b0 <initlock>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	68 e0 90 10 80       	push   $0x801090e0
80101858:	53                   	push   %ebx
80101859:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010185f:	e8 1c 37 00 00       	call   80104f80 <initsleeplock>
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
801018a9:	68 8c 91 10 80       	push   $0x8010918c
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
8010193e:	e8 bd 39 00 00       	call   80105300 <memset>
      dip->type = type;
80101943:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101947:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010194a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010194d:	89 3c 24             	mov    %edi,(%esp)
80101950:	e8 db 1d 00 00       	call   80103730 <log_write>
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
80101973:	68 e6 90 10 80       	push   $0x801090e6
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
801019e1:	e8 ca 39 00 00       	call   801053b0 <memmove>
  log_write(bp);
801019e6:	89 34 24             	mov    %esi,(%esp)
801019e9:	e8 42 1d 00 00       	call   80103730 <log_write>
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
80101a0f:	e8 dc 37 00 00       	call   801051f0 <acquire>
  ip->ref++;
80101a14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a18:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a1f:	e8 8c 38 00 00       	call   801052b0 <release>
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
80101a52:	e8 69 35 00 00       	call   80104fc0 <acquiresleep>
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
80101ac8:	e8 e3 38 00 00       	call   801053b0 <memmove>
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
80101aed:	68 fe 90 10 80       	push   $0x801090fe
80101af2:	e8 99 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 f8 90 10 80       	push   $0x801090f8
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
80101b23:	e8 38 35 00 00       	call   80105060 <holdingsleep>
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
80101b3f:	e9 dc 34 00 00       	jmp    80105020 <releasesleep>
    panic("iunlock");
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 0d 91 10 80       	push   $0x8010910d
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
80101b70:	e8 4b 34 00 00       	call   80104fc0 <acquiresleep>
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
80101b8a:	e8 91 34 00 00       	call   80105020 <releasesleep>
  acquire(&icache.lock);
80101b8f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101b96:	e8 55 36 00 00       	call   801051f0 <acquire>
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
80101bb0:	e9 fb 36 00 00       	jmp    801052b0 <release>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bc0:	e8 2b 36 00 00       	call   801051f0 <acquire>
    int r = ip->ref;
80101bc5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bc8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bcf:	e8 dc 36 00 00       	call   801052b0 <release>
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
80101db7:	e8 f4 35 00 00       	call   801053b0 <memmove>
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
80101eb3:	e8 f8 34 00 00       	call   801053b0 <memmove>
    log_write(bp);
80101eb8:	89 3c 24             	mov    %edi,(%esp)
80101ebb:	e8 70 18 00 00       	call   80103730 <log_write>
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
80101f4e:	e8 cd 34 00 00       	call   80105420 <strncmp>
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
80101fad:	e8 6e 34 00 00       	call   80105420 <strncmp>
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
80101ff2:	68 27 91 10 80       	push   $0x80109127
80101ff7:	e8 94 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	68 15 91 10 80       	push   $0x80109115
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
80102029:	e8 a2 22 00 00       	call   801042d0 <myproc>
  acquire(&icache.lock);
8010202e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102031:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102034:	68 c0 3d 11 80       	push   $0x80113dc0
80102039:	e8 b2 31 00 00       	call   801051f0 <acquire>
  ip->ref++;
8010203e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102042:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102049:	e8 62 32 00 00       	call   801052b0 <release>
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
801020a5:	e8 06 33 00 00       	call   801053b0 <memmove>
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
80102138:	e8 73 32 00 00       	call   801053b0 <memmove>
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
8010222d:	e8 4e 32 00 00       	call   80105480 <strncpy>
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
8010226b:	68 36 91 10 80       	push   $0x80109136
80102270:	e8 1b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 95 98 10 80       	push   $0x80109895
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
80102371:	68 43 91 10 80       	push   $0x80109143
80102376:	56                   	push   %esi
80102377:	e8 34 30 00 00       	call   801053b0 <memmove>
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
801023a4:	e8 b7 11 00 00       	call   80103560 <begin_op>
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
801023d2:	68 4b 91 10 80       	push   $0x8010914b
801023d7:	53                   	push   %ebx
801023d8:	e8 43 30 00 00       	call   80105420 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	85 c0                	test   %eax,%eax
801023e2:	0f 84 f8 00 00 00    	je     801024e0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023e8:	83 ec 04             	sub    $0x4,%esp
801023eb:	6a 0e                	push   $0xe
801023ed:	68 4a 91 10 80       	push   $0x8010914a
801023f2:	53                   	push   %ebx
801023f3:	e8 28 30 00 00       	call   80105420 <strncmp>
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
80102447:	e8 b4 2e 00 00       	call   80105300 <memset>
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
8010249d:	e8 2e 11 00 00       	call   801035d0 <end_op>

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
801024b4:	e8 27 36 00 00       	call   80105ae0 <isdirempty>
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
801024f1:	e8 da 10 00 00       	call   801035d0 <end_op>
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
8010252a:	e8 a1 10 00 00       	call   801035d0 <end_op>
    return -1;
8010252f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102534:	e9 6e ff ff ff       	jmp    801024a7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102539:	83 ec 0c             	sub    $0xc,%esp
8010253c:	68 5f 91 10 80       	push   $0x8010915f
80102541:	e8 4a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	68 4d 91 10 80       	push   $0x8010914d
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
80102570:	68 43 91 10 80       	push   $0x80109143
80102575:	56                   	push   %esi
80102576:	e8 35 2e 00 00       	call   801053b0 <memmove>
  itoa(p->pid, path+ 6);
8010257b:	58                   	pop    %eax
8010257c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010257f:	5a                   	pop    %edx
80102580:	50                   	push   %eax
80102581:	ff 73 10             	pushl  0x10(%ebx)
80102584:	e8 47 fd ff ff       	call   801022d0 <itoa>

    begin_op();
80102589:	e8 d2 0f 00 00       	call   80103560 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010258e:	6a 00                	push   $0x0
80102590:	6a 00                	push   $0x0
80102592:	6a 02                	push   $0x2
80102594:	56                   	push   %esi
80102595:	e8 56 37 00 00       	call   80105cf0 <create>
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
801025d8:	e8 f3 0f 00 00       	call   801035d0 <end_op>

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
801025e9:	68 6e 91 10 80       	push   $0x8010916e
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
8010271b:	68 e8 91 10 80       	push   $0x801091e8
80102720:	e8 6b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102725:	83 ec 0c             	sub    $0xc,%esp
80102728:	68 df 91 10 80       	push   $0x801091df
8010272d:	e8 5e dc ff ff       	call   80100390 <panic>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <ideinit>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102746:	68 fa 91 10 80       	push   $0x801091fa
8010274b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102750:	e8 5b 29 00 00       	call   801050b0 <initlock>
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
801027ce:	e8 1d 2a 00 00       	call   801051f0 <acquire>

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
80102831:	e8 aa 24 00 00       	call   80104ce0 <wakeup>

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
8010284f:	e8 5c 2a 00 00       	call   801052b0 <release>

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
8010286e:	e8 ed 27 00 00       	call   80105060 <holdingsleep>
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
801028a8:	e8 43 29 00 00       	call   801051f0 <acquire>

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
801028f9:	e8 a2 21 00 00       	call   80104aa0 <sleep>
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
80102916:	e9 95 29 00 00       	jmp    801052b0 <release>
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
8010293a:	68 14 92 10 80       	push   $0x80109214
8010293f:	e8 4c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 fe 91 10 80       	push   $0x801091fe
8010294c:	e8 3f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	68 29 92 10 80       	push   $0x80109229
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
801029a7:	68 48 92 10 80       	push   $0x80109248
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
80102a8d:	e8 6e 28 00 00       	call   80105300 <memset>

  if(kmem.use_lock) 
80102a92:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102a97:	83 c4 10             	add    $0x10,%esp
80102a9a:	85 c0                	test   %eax,%eax
80102a9c:	75 62                	jne    80102b00 <kfree+0xb0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102a9e:	c1 eb 0c             	shr    $0xc,%ebx
80102aa1:	8d 43 06             	lea    0x6(%ebx),%eax


  if(r->refcount != 1)
80102aa4:	8b 14 c5 30 5a 11 80 	mov    -0x7feea5d0(,%eax,8),%edx
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102aab:	8d 0c c5 2c 5a 11 80 	lea    -0x7feea5d4(,%eax,8),%ecx
  if(r->refcount != 1)
80102ab2:	83 fa 01             	cmp    $0x1,%edx
80102ab5:	75 68                	jne    80102b1f <kfree+0xcf>
    panic("kfree: freeing a shared page");

  }
  

  r->next = kmem.freelist;
80102ab7:	8b 15 58 5a 11 80    	mov    0x80115a58,%edx
  r->refcount = 0;
80102abd:	c7 04 c5 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%eax,8)
80102ac4:	00 00 00 00 
  kmem.freelist = r;
80102ac8:	89 0d 58 5a 11 80    	mov    %ecx,0x80115a58
  r->next = kmem.freelist;
80102ace:	89 14 c5 2c 5a 11 80 	mov    %edx,-0x7feea5d4(,%eax,8)
  if(kmem.use_lock)
80102ad5:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102ada:	85 c0                	test   %eax,%eax
80102adc:	75 0a                	jne    80102ae8 <kfree+0x98>
    release(&kmem.lock);
}
80102ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ae1:	c9                   	leave  
80102ae2:	c3                   	ret    
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    release(&kmem.lock);
80102ae8:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102aef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102af2:	c9                   	leave  
    release(&kmem.lock);
80102af3:	e9 b8 27 00 00       	jmp    801052b0 <release>
80102af8:	90                   	nop
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b00:	83 ec 0c             	sub    $0xc,%esp
80102b03:	68 20 5a 11 80       	push   $0x80115a20
80102b08:	e8 e3 26 00 00       	call   801051f0 <acquire>
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	eb 8c                	jmp    80102a9e <kfree+0x4e>
    panic("kfree");
80102b12:	83 ec 0c             	sub    $0xc,%esp
80102b15:	68 7a 92 10 80       	push   $0x8010927a
80102b1a:	e8 71 d8 ff ff       	call   80100390 <panic>
    cprintf("ref count is %d", r->refcount);
80102b1f:	51                   	push   %ecx
80102b20:	51                   	push   %ecx
80102b21:	52                   	push   %edx
80102b22:	68 80 92 10 80       	push   $0x80109280
80102b27:	e8 34 db ff ff       	call   80100660 <cprintf>
    panic("kfree: freeing a shared page");
80102b2c:	c7 04 24 90 92 10 80 	movl   $0x80109290,(%esp)
80102b33:	e8 58 d8 ff ff       	call   80100390 <panic>
80102b38:	90                   	nop
80102b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b40 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	53                   	push   %ebx
80102b44:	83 ec 04             	sub    $0x4,%esp
80102b47:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b4a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102b4f:	0f 85 bd 00 00 00    	jne    80102c12 <kfree_nocheck+0xd2>
80102b55:	3d 88 75 19 80       	cmp    $0x80197588,%eax
80102b5a:	0f 82 b2 00 00 00    	jb     80102c12 <kfree_nocheck+0xd2>
80102b60:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102b66:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102b6c:	0f 87 a0 00 00 00    	ja     80102c12 <kfree_nocheck+0xd2>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b72:	83 ec 04             	sub    $0x4,%esp
80102b75:	68 00 10 00 00       	push   $0x1000
80102b7a:	6a 01                	push   $0x1
80102b7c:	50                   	push   %eax
80102b7d:	e8 7e 27 00 00       	call   80105300 <memset>

  if(kmem.use_lock) 
80102b82:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 d2                	test   %edx,%edx
80102b8d:	75 31                	jne    80102bc0 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102b8f:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102b94:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102b97:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
80102b9a:	c7 04 dd 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%ebx,8)
80102ba1:	00 00 00 00 
  r->next = kmem.freelist;
80102ba5:	89 04 dd 2c 5a 11 80 	mov    %eax,-0x7feea5d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bac:	8d 04 dd 2c 5a 11 80 	lea    -0x7feea5d4(,%ebx,8),%eax
80102bb3:	a3 58 5a 11 80       	mov    %eax,0x80115a58
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bbb:	c9                   	leave  
80102bbc:	c3                   	ret    
80102bbd:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102bc0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bc3:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102bc6:	68 20 5a 11 80       	push   $0x80115a20
  r->next = kmem.freelist;
80102bcb:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102bce:	e8 1d 26 00 00       	call   801051f0 <acquire>
  r->next = kmem.freelist;
80102bd3:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(kmem.use_lock)
80102bd8:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102bdb:	c7 04 dd 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%ebx,8)
80102be2:	00 00 00 00 
  r->next = kmem.freelist;
80102be6:	89 04 dd 2c 5a 11 80 	mov    %eax,-0x7feea5d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bed:	8d 04 dd 2c 5a 11 80 	lea    -0x7feea5d4(,%ebx,8),%eax
80102bf4:	a3 58 5a 11 80       	mov    %eax,0x80115a58
  if(kmem.use_lock)
80102bf9:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102bfe:	85 c0                	test   %eax,%eax
80102c00:	74 b6                	je     80102bb8 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102c02:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c0c:	c9                   	leave  
    release(&kmem.lock);
80102c0d:	e9 9e 26 00 00       	jmp    801052b0 <release>
    panic("kfree_nocheck");
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	68 ad 92 10 80       	push   $0x801092ad
80102c1a:	e8 71 d7 ff ff       	call   80100390 <panic>
80102c1f:	90                   	nop

80102c20 <freerange>:
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	56                   	push   %esi
80102c24:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c25:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c28:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c2b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c31:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c3d:	39 de                	cmp    %ebx,%esi
80102c3f:	72 23                	jb     80102c64 <freerange+0x44>
80102c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102c48:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c4e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102c57:	50                   	push   %eax
80102c58:	e8 e3 fe ff ff       	call   80102b40 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c5d:	83 c4 10             	add    $0x10,%esp
80102c60:	39 f3                	cmp    %esi,%ebx
80102c62:	76 e4                	jbe    80102c48 <freerange+0x28>
}
80102c64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c67:	5b                   	pop    %ebx
80102c68:	5e                   	pop    %esi
80102c69:	5d                   	pop    %ebp
80102c6a:	c3                   	ret    
80102c6b:	90                   	nop
80102c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c70 <kinit1>:
{
80102c70:	55                   	push   %ebp
80102c71:	89 e5                	mov    %esp,%ebp
80102c73:	56                   	push   %esi
80102c74:	53                   	push   %ebx
80102c75:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c78:	83 ec 08             	sub    $0x8,%esp
80102c7b:	68 bb 92 10 80       	push   $0x801092bb
80102c80:	68 20 5a 11 80       	push   $0x80115a20
80102c85:	e8 26 24 00 00       	call   801050b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c90:	c7 05 54 5a 11 80 00 	movl   $0x0,0x80115a54
80102c97:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c9a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102ca0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ca6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cac:	39 de                	cmp    %ebx,%esi
80102cae:	72 1c                	jb     80102ccc <kinit1+0x5c>
    kfree_nocheck(p);
80102cb0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cb6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cb9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102cbf:	50                   	push   %eax
80102cc0:	e8 7b fe ff ff       	call   80102b40 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cc5:	83 c4 10             	add    $0x10,%esp
80102cc8:	39 de                	cmp    %ebx,%esi
80102cca:	73 e4                	jae    80102cb0 <kinit1+0x40>
}
80102ccc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ccf:	5b                   	pop    %ebx
80102cd0:	5e                   	pop    %esi
80102cd1:	5d                   	pop    %ebp
80102cd2:	c3                   	ret    
80102cd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ce0 <kinit2>:
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	56                   	push   %esi
80102ce4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102ce5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102ce8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ceb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cf1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cf7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cfd:	39 de                	cmp    %ebx,%esi
80102cff:	72 23                	jb     80102d24 <kinit2+0x44>
80102d01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102d08:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102d0e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d11:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102d17:	50                   	push   %eax
80102d18:	e8 23 fe ff ff       	call   80102b40 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102d1d:	83 c4 10             	add    $0x10,%esp
80102d20:	39 de                	cmp    %ebx,%esi
80102d22:	73 e4                	jae    80102d08 <kinit2+0x28>
  kmem.use_lock = 1;
80102d24:	c7 05 54 5a 11 80 01 	movl   $0x1,0x80115a54
80102d2b:	00 00 00 
}
80102d2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d31:	5b                   	pop    %ebx
80102d32:	5e                   	pop    %esi
80102d33:	5d                   	pop    %ebp
80102d34:	c3                   	ret    
80102d35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d40 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d40:	55                   	push   %ebp
80102d41:	89 e5                	mov    %esp,%ebp
80102d43:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102d46:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102d4b:	85 c0                	test   %eax,%eax
80102d4d:	75 59                	jne    80102da8 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d4f:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(r)
80102d54:	85 c0                	test   %eax,%eax
80102d56:	74 73                	je     80102dcb <kalloc+0x8b>
  {
    kmem.freelist = r->next;
80102d58:	8b 10                	mov    (%eax),%edx
80102d5a:	89 15 58 5a 11 80    	mov    %edx,0x80115a58
    r->refcount = 1;
80102d60:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102d67:	8b 0d 54 5a 11 80    	mov    0x80115a54,%ecx
80102d6d:	85 c9                	test   %ecx,%ecx
80102d6f:	75 0f                	jne    80102d80 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d71:	2d 5c 5a 11 80       	sub    $0x80115a5c,%eax
80102d76:	c1 e0 09             	shl    $0x9,%eax
80102d79:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102d7e:	c9                   	leave  
80102d7f:	c3                   	ret    
    release(&kmem.lock);
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d86:	68 20 5a 11 80       	push   $0x80115a20
80102d8b:	e8 20 25 00 00       	call   801052b0 <release>
80102d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d93:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d96:	2d 5c 5a 11 80       	sub    $0x80115a5c,%eax
80102d9b:	c1 e0 09             	shl    $0x9,%eax
80102d9e:	05 00 00 00 80       	add    $0x80000000,%eax
80102da3:	eb d9                	jmp    80102d7e <kalloc+0x3e>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	68 20 5a 11 80       	push   $0x80115a20
80102db0:	e8 3b 24 00 00       	call   801051f0 <acquire>
  r = kmem.freelist;
80102db5:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(r)
80102dba:	83 c4 10             	add    $0x10,%esp
80102dbd:	85 c0                	test   %eax,%eax
80102dbf:	75 97                	jne    80102d58 <kalloc+0x18>
  if(kmem.use_lock)
80102dc1:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102dc7:	85 d2                	test   %edx,%edx
80102dc9:	75 05                	jne    80102dd0 <kalloc+0x90>
{
80102dcb:	31 c0                	xor    %eax,%eax
}
80102dcd:	c9                   	leave  
80102dce:	c3                   	ret    
80102dcf:	90                   	nop
    release(&kmem.lock);
80102dd0:	83 ec 0c             	sub    $0xc,%esp
80102dd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102dd6:	68 20 5a 11 80       	push   $0x80115a20
80102ddb:	e8 d0 24 00 00       	call   801052b0 <release>
80102de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102de3:	83 c4 10             	add    $0x10,%esp
}
80102de6:	c9                   	leave  
80102de7:	c3                   	ret    
80102de8:	90                   	nop
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102df0 <refDec>:

void
refDec(char *v)
{
80102df0:	55                   	push   %ebp
80102df1:	89 e5                	mov    %esp,%ebp
80102df3:	53                   	push   %ebx
80102df4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102df7:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
{
80102dfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102e00:	85 d2                	test   %edx,%edx
80102e02:	75 1c                	jne    80102e20 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e04:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e0a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102e0d:	83 2c c5 60 5a 11 80 	subl   $0x1,-0x7feea5a0(,%eax,8)
80102e14:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e18:	c9                   	leave  
80102e19:	c3                   	ret    
80102e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e20:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e23:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e29:	68 20 5a 11 80       	push   $0x80115a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e2e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e31:	e8 ba 23 00 00       	call   801051f0 <acquire>
  if(kmem.use_lock)
80102e36:	a1 54 5a 11 80       	mov    0x80115a54,%eax
  r->refcount -= 1;
80102e3b:	83 2c dd 60 5a 11 80 	subl   $0x1,-0x7feea5a0(,%ebx,8)
80102e42:	01 
  if(kmem.use_lock)
80102e43:	83 c4 10             	add    $0x10,%esp
80102e46:	85 c0                	test   %eax,%eax
80102e48:	74 cb                	je     80102e15 <refDec+0x25>
    release(&kmem.lock);
80102e4a:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102e51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e54:	c9                   	leave  
    release(&kmem.lock);
80102e55:	e9 56 24 00 00       	jmp    801052b0 <release>
80102e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e60 <refInc>:

void
refInc(char *v)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	53                   	push   %ebx
80102e64:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102e67:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
{
80102e6d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102e70:	85 d2                	test   %edx,%edx
80102e72:	75 1c                	jne    80102e90 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e74:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e7a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102e7d:	83 04 c5 60 5a 11 80 	addl   $0x1,-0x7feea5a0(,%eax,8)
80102e84:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102e85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e88:	c9                   	leave  
80102e89:	c3                   	ret    
80102e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e90:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e93:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e99:	68 20 5a 11 80       	push   $0x80115a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e9e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ea1:	e8 4a 23 00 00       	call   801051f0 <acquire>
  if(kmem.use_lock)
80102ea6:	a1 54 5a 11 80       	mov    0x80115a54,%eax
  r->refcount += 1;
80102eab:	83 04 dd 60 5a 11 80 	addl   $0x1,-0x7feea5a0(,%ebx,8)
80102eb2:	01 
  if(kmem.use_lock)
80102eb3:	83 c4 10             	add    $0x10,%esp
80102eb6:	85 c0                	test   %eax,%eax
80102eb8:	74 cb                	je     80102e85 <refInc+0x25>
    release(&kmem.lock);
80102eba:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec4:	c9                   	leave  
    release(&kmem.lock);
80102ec5:	e9 e6 23 00 00       	jmp    801052b0 <release>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ed0 <getRefs>:

int
getRefs(char *v)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102ed6:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ed7:	05 00 00 00 80       	add    $0x80000000,%eax
80102edc:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102edf:	8b 04 c5 60 5a 11 80 	mov    -0x7feea5a0(,%eax,8),%eax
80102ee6:	c3                   	ret    
80102ee7:	66 90                	xchg   %ax,%ax
80102ee9:	66 90                	xchg   %ax,%ax
80102eeb:	66 90                	xchg   %ax,%ax
80102eed:	66 90                	xchg   %ax,%ax
80102eef:	90                   	nop

80102ef0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ef0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ef5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ef6:	a8 01                	test   $0x1,%al
80102ef8:	0f 84 c2 00 00 00    	je     80102fc0 <kbdgetc+0xd0>
80102efe:	ba 60 00 00 00       	mov    $0x60,%edx
80102f03:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102f04:	0f b6 d0             	movzbl %al,%edx
80102f07:	8b 0d d4 c5 10 80    	mov    0x8010c5d4,%ecx

  if(data == 0xE0){
80102f0d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102f13:	0f 84 7f 00 00 00    	je     80102f98 <kbdgetc+0xa8>
{
80102f19:	55                   	push   %ebp
80102f1a:	89 e5                	mov    %esp,%ebp
80102f1c:	53                   	push   %ebx
80102f1d:	89 cb                	mov    %ecx,%ebx
80102f1f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f22:	84 c0                	test   %al,%al
80102f24:	78 4a                	js     80102f70 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f26:	85 db                	test   %ebx,%ebx
80102f28:	74 09                	je     80102f33 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f2a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f2d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102f30:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f33:	0f b6 82 e0 93 10 80 	movzbl -0x7fef6c20(%edx),%eax
80102f3a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f3c:	0f b6 82 e0 92 10 80 	movzbl -0x7fef6d20(%edx),%eax
80102f43:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f45:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f47:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f4d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f50:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f53:	8b 04 85 c0 92 10 80 	mov    -0x7fef6d40(,%eax,4),%eax
80102f5a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102f5e:	74 31                	je     80102f91 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102f60:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f63:	83 fa 19             	cmp    $0x19,%edx
80102f66:	77 40                	ja     80102fa8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f68:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f6b:	5b                   	pop    %ebx
80102f6c:	5d                   	pop    %ebp
80102f6d:	c3                   	ret    
80102f6e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f70:	83 e0 7f             	and    $0x7f,%eax
80102f73:	85 db                	test   %ebx,%ebx
80102f75:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102f78:	0f b6 82 e0 93 10 80 	movzbl -0x7fef6c20(%edx),%eax
80102f7f:	83 c8 40             	or     $0x40,%eax
80102f82:	0f b6 c0             	movzbl %al,%eax
80102f85:	f7 d0                	not    %eax
80102f87:	21 c1                	and    %eax,%ecx
    return 0;
80102f89:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102f8b:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
}
80102f91:	5b                   	pop    %ebx
80102f92:	5d                   	pop    %ebp
80102f93:	c3                   	ret    
80102f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102f98:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102f9b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102f9d:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
    return 0;
80102fa3:	c3                   	ret    
80102fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102fa8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102fab:	8d 50 20             	lea    0x20(%eax),%edx
}
80102fae:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102faf:	83 f9 1a             	cmp    $0x1a,%ecx
80102fb2:	0f 42 c2             	cmovb  %edx,%eax
}
80102fb5:	5d                   	pop    %ebp
80102fb6:	c3                   	ret    
80102fb7:	89 f6                	mov    %esi,%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102fc5:	c3                   	ret    
80102fc6:	8d 76 00             	lea    0x0(%esi),%esi
80102fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fd0 <kbdintr>:

void
kbdintr(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102fd6:	68 f0 2e 10 80       	push   $0x80102ef0
80102fdb:	e8 30 d8 ff ff       	call   80100810 <consoleintr>
}
80102fe0:	83 c4 10             	add    $0x10,%esp
80102fe3:	c9                   	leave  
80102fe4:	c3                   	ret    
80102fe5:	66 90                	xchg   %ax,%ax
80102fe7:	66 90                	xchg   %ax,%ax
80102fe9:	66 90                	xchg   %ax,%ax
80102feb:	66 90                	xchg   %ax,%ax
80102fed:	66 90                	xchg   %ax,%ax
80102fef:	90                   	nop

80102ff0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102ff0:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
{
80102ff5:	55                   	push   %ebp
80102ff6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102ff8:	85 c0                	test   %eax,%eax
80102ffa:	0f 84 c8 00 00 00    	je     801030c8 <lapicinit+0xd8>
  lapic[index] = value;
80103000:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103007:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010300a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010300d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103014:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103017:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010301a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103021:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103024:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103027:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010302e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103031:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103034:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010303b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010303e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103041:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103048:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010304b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010304e:	8b 50 30             	mov    0x30(%eax),%edx
80103051:	c1 ea 10             	shr    $0x10,%edx
80103054:	80 fa 03             	cmp    $0x3,%dl
80103057:	77 77                	ja     801030d0 <lapicinit+0xe0>
  lapic[index] = value;
80103059:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103060:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103063:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103066:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010306d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103070:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103073:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010307a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010307d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103080:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103087:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010308a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010308d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103094:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103097:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010309a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801030a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801030a4:	8b 50 20             	mov    0x20(%eax),%edx
801030a7:	89 f6                	mov    %esi,%esi
801030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801030b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801030b6:	80 e6 10             	and    $0x10,%dh
801030b9:	75 f5                	jne    801030b0 <lapicinit+0xc0>
  lapic[index] = value;
801030bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801030c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801030c8:	5d                   	pop    %ebp
801030c9:	c3                   	ret    
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801030d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801030d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030da:	8b 50 20             	mov    0x20(%eax),%edx
801030dd:	e9 77 ff ff ff       	jmp    80103059 <lapicinit+0x69>
801030e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030f0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801030f0:	8b 15 5c 5a 18 80    	mov    0x80185a5c,%edx
{
801030f6:	55                   	push   %ebp
801030f7:	31 c0                	xor    %eax,%eax
801030f9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801030fb:	85 d2                	test   %edx,%edx
801030fd:	74 06                	je     80103105 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801030ff:	8b 42 20             	mov    0x20(%edx),%eax
80103102:	c1 e8 18             	shr    $0x18,%eax
}
80103105:	5d                   	pop    %ebp
80103106:	c3                   	ret    
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103110 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103110:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
{
80103115:	55                   	push   %ebp
80103116:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103118:	85 c0                	test   %eax,%eax
8010311a:	74 0d                	je     80103129 <lapiceoi+0x19>
  lapic[index] = value;
8010311c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103123:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103126:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103129:	5d                   	pop    %ebp
8010312a:	c3                   	ret    
8010312b:	90                   	nop
8010312c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103130 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
}
80103133:	5d                   	pop    %ebp
80103134:	c3                   	ret    
80103135:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103140 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103140:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103141:	b8 0f 00 00 00       	mov    $0xf,%eax
80103146:	ba 70 00 00 00       	mov    $0x70,%edx
8010314b:	89 e5                	mov    %esp,%ebp
8010314d:	53                   	push   %ebx
8010314e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103151:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103154:	ee                   	out    %al,(%dx)
80103155:	b8 0a 00 00 00       	mov    $0xa,%eax
8010315a:	ba 71 00 00 00       	mov    $0x71,%edx
8010315f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103160:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103162:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103165:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010316b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010316d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103170:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103173:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103175:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103178:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010317e:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
80103183:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103189:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010318c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103193:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103196:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103199:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801031a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031a3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031ac:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031b5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031be:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031c7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801031ca:	5b                   	pop    %ebx
801031cb:	5d                   	pop    %ebp
801031cc:	c3                   	ret    
801031cd:	8d 76 00             	lea    0x0(%esi),%esi

801031d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801031d0:	55                   	push   %ebp
801031d1:	b8 0b 00 00 00       	mov    $0xb,%eax
801031d6:	ba 70 00 00 00       	mov    $0x70,%edx
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	57                   	push   %edi
801031de:	56                   	push   %esi
801031df:	53                   	push   %ebx
801031e0:	83 ec 4c             	sub    $0x4c,%esp
801031e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031e4:	ba 71 00 00 00       	mov    $0x71,%edx
801031e9:	ec                   	in     (%dx),%al
801031ea:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031ed:	bb 70 00 00 00       	mov    $0x70,%ebx
801031f2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801031f5:	8d 76 00             	lea    0x0(%esi),%esi
801031f8:	31 c0                	xor    %eax,%eax
801031fa:	89 da                	mov    %ebx,%edx
801031fc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031fd:	b9 71 00 00 00       	mov    $0x71,%ecx
80103202:	89 ca                	mov    %ecx,%edx
80103204:	ec                   	in     (%dx),%al
80103205:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103208:	89 da                	mov    %ebx,%edx
8010320a:	b8 02 00 00 00       	mov    $0x2,%eax
8010320f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103210:	89 ca                	mov    %ecx,%edx
80103212:	ec                   	in     (%dx),%al
80103213:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103216:	89 da                	mov    %ebx,%edx
80103218:	b8 04 00 00 00       	mov    $0x4,%eax
8010321d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010321e:	89 ca                	mov    %ecx,%edx
80103220:	ec                   	in     (%dx),%al
80103221:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103224:	89 da                	mov    %ebx,%edx
80103226:	b8 07 00 00 00       	mov    $0x7,%eax
8010322b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010322c:	89 ca                	mov    %ecx,%edx
8010322e:	ec                   	in     (%dx),%al
8010322f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103232:	89 da                	mov    %ebx,%edx
80103234:	b8 08 00 00 00       	mov    $0x8,%eax
80103239:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010323a:	89 ca                	mov    %ecx,%edx
8010323c:	ec                   	in     (%dx),%al
8010323d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010323f:	89 da                	mov    %ebx,%edx
80103241:	b8 09 00 00 00       	mov    $0x9,%eax
80103246:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103247:	89 ca                	mov    %ecx,%edx
80103249:	ec                   	in     (%dx),%al
8010324a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010324c:	89 da                	mov    %ebx,%edx
8010324e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103253:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103254:	89 ca                	mov    %ecx,%edx
80103256:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103257:	84 c0                	test   %al,%al
80103259:	78 9d                	js     801031f8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010325b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010325f:	89 fa                	mov    %edi,%edx
80103261:	0f b6 fa             	movzbl %dl,%edi
80103264:	89 f2                	mov    %esi,%edx
80103266:	0f b6 f2             	movzbl %dl,%esi
80103269:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010326c:	89 da                	mov    %ebx,%edx
8010326e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103271:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103274:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103278:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010327b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010327f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103282:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103286:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103289:	31 c0                	xor    %eax,%eax
8010328b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010328c:	89 ca                	mov    %ecx,%edx
8010328e:	ec                   	in     (%dx),%al
8010328f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103292:	89 da                	mov    %ebx,%edx
80103294:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103297:	b8 02 00 00 00       	mov    $0x2,%eax
8010329c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010329d:	89 ca                	mov    %ecx,%edx
8010329f:	ec                   	in     (%dx),%al
801032a0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a3:	89 da                	mov    %ebx,%edx
801032a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801032a8:	b8 04 00 00 00       	mov    $0x4,%eax
801032ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ae:	89 ca                	mov    %ecx,%edx
801032b0:	ec                   	in     (%dx),%al
801032b1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b4:	89 da                	mov    %ebx,%edx
801032b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801032b9:	b8 07 00 00 00       	mov    $0x7,%eax
801032be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032bf:	89 ca                	mov    %ecx,%edx
801032c1:	ec                   	in     (%dx),%al
801032c2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c5:	89 da                	mov    %ebx,%edx
801032c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801032ca:	b8 08 00 00 00       	mov    $0x8,%eax
801032cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032d0:	89 ca                	mov    %ecx,%edx
801032d2:	ec                   	in     (%dx),%al
801032d3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d6:	89 da                	mov    %ebx,%edx
801032d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801032db:	b8 09 00 00 00       	mov    $0x9,%eax
801032e0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032e1:	89 ca                	mov    %ecx,%edx
801032e3:	ec                   	in     (%dx),%al
801032e4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032e7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801032ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032ed:	8d 45 d0             	lea    -0x30(%ebp),%eax
801032f0:	6a 18                	push   $0x18
801032f2:	50                   	push   %eax
801032f3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801032f6:	50                   	push   %eax
801032f7:	e8 54 20 00 00       	call   80105350 <memcmp>
801032fc:	83 c4 10             	add    $0x10,%esp
801032ff:	85 c0                	test   %eax,%eax
80103301:	0f 85 f1 fe ff ff    	jne    801031f8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103307:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010330b:	75 78                	jne    80103385 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010330d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103310:	89 c2                	mov    %eax,%edx
80103312:	83 e0 0f             	and    $0xf,%eax
80103315:	c1 ea 04             	shr    $0x4,%edx
80103318:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010331b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010331e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103321:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103324:	89 c2                	mov    %eax,%edx
80103326:	83 e0 0f             	and    $0xf,%eax
80103329:	c1 ea 04             	shr    $0x4,%edx
8010332c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010332f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103332:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103335:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103338:	89 c2                	mov    %eax,%edx
8010333a:	83 e0 0f             	and    $0xf,%eax
8010333d:	c1 ea 04             	shr    $0x4,%edx
80103340:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103343:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103346:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103349:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010334c:	89 c2                	mov    %eax,%edx
8010334e:	83 e0 0f             	and    $0xf,%eax
80103351:	c1 ea 04             	shr    $0x4,%edx
80103354:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103357:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010335a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010335d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103360:	89 c2                	mov    %eax,%edx
80103362:	83 e0 0f             	and    $0xf,%eax
80103365:	c1 ea 04             	shr    $0x4,%edx
80103368:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010336b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010336e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103371:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103374:	89 c2                	mov    %eax,%edx
80103376:	83 e0 0f             	and    $0xf,%eax
80103379:	c1 ea 04             	shr    $0x4,%edx
8010337c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010337f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103382:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103385:	8b 75 08             	mov    0x8(%ebp),%esi
80103388:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010338b:	89 06                	mov    %eax,(%esi)
8010338d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103390:	89 46 04             	mov    %eax,0x4(%esi)
80103393:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103396:	89 46 08             	mov    %eax,0x8(%esi)
80103399:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010339c:	89 46 0c             	mov    %eax,0xc(%esi)
8010339f:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033a2:	89 46 10             	mov    %eax,0x10(%esi)
801033a5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033a8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801033ab:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801033b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033b5:	5b                   	pop    %ebx
801033b6:	5e                   	pop    %esi
801033b7:	5f                   	pop    %edi
801033b8:	5d                   	pop    %ebp
801033b9:	c3                   	ret    
801033ba:	66 90                	xchg   %ax,%ax
801033bc:	66 90                	xchg   %ax,%ax
801033be:	66 90                	xchg   %ax,%ax

801033c0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033c0:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
801033c6:	85 c9                	test   %ecx,%ecx
801033c8:	0f 8e 8a 00 00 00    	jle    80103458 <install_trans+0x98>
{
801033ce:	55                   	push   %ebp
801033cf:	89 e5                	mov    %esp,%ebp
801033d1:	57                   	push   %edi
801033d2:	56                   	push   %esi
801033d3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801033d4:	31 db                	xor    %ebx,%ebx
{
801033d6:	83 ec 0c             	sub    $0xc,%esp
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033e0:	a1 94 5a 18 80       	mov    0x80185a94,%eax
801033e5:	83 ec 08             	sub    $0x8,%esp
801033e8:	01 d8                	add    %ebx,%eax
801033ea:	83 c0 01             	add    $0x1,%eax
801033ed:	50                   	push   %eax
801033ee:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
801033f4:	e8 d7 cc ff ff       	call   801000d0 <bread>
801033f9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033fb:	58                   	pop    %eax
801033fc:	5a                   	pop    %edx
801033fd:	ff 34 9d ac 5a 18 80 	pushl  -0x7fe7a554(,%ebx,4)
80103404:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
  for (tail = 0; tail < log.lh.n; tail++) {
8010340a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010340d:	e8 be cc ff ff       	call   801000d0 <bread>
80103412:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103414:	8d 47 5c             	lea    0x5c(%edi),%eax
80103417:	83 c4 0c             	add    $0xc,%esp
8010341a:	68 00 02 00 00       	push   $0x200
8010341f:	50                   	push   %eax
80103420:	8d 46 5c             	lea    0x5c(%esi),%eax
80103423:	50                   	push   %eax
80103424:	e8 87 1f 00 00       	call   801053b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103429:	89 34 24             	mov    %esi,(%esp)
8010342c:	e8 6f cd ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103431:	89 3c 24             	mov    %edi,(%esp)
80103434:	e8 a7 cd ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103439:	89 34 24             	mov    %esi,(%esp)
8010343c:	e8 9f cd ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103441:	83 c4 10             	add    $0x10,%esp
80103444:	39 1d a8 5a 18 80    	cmp    %ebx,0x80185aa8
8010344a:	7f 94                	jg     801033e0 <install_trans+0x20>
  }
}
8010344c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344f:	5b                   	pop    %ebx
80103450:	5e                   	pop    %esi
80103451:	5f                   	pop    %edi
80103452:	5d                   	pop    %ebp
80103453:	c3                   	ret    
80103454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103458:	f3 c3                	repz ret 
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103460 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	56                   	push   %esi
80103464:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103465:	83 ec 08             	sub    $0x8,%esp
80103468:	ff 35 94 5a 18 80    	pushl  0x80185a94
8010346e:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
80103474:	e8 57 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103479:	8b 1d a8 5a 18 80    	mov    0x80185aa8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010347f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103482:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103484:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103486:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103489:	7e 16                	jle    801034a1 <write_head+0x41>
8010348b:	c1 e3 02             	shl    $0x2,%ebx
8010348e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103490:	8b 8a ac 5a 18 80    	mov    -0x7fe7a554(%edx),%ecx
80103496:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010349a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010349d:	39 da                	cmp    %ebx,%edx
8010349f:	75 ef                	jne    80103490 <write_head+0x30>
  }
  bwrite(buf);
801034a1:	83 ec 0c             	sub    $0xc,%esp
801034a4:	56                   	push   %esi
801034a5:	e8 f6 cc ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801034aa:	89 34 24             	mov    %esi,(%esp)
801034ad:	e8 2e cd ff ff       	call   801001e0 <brelse>
}
801034b2:	83 c4 10             	add    $0x10,%esp
801034b5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b8:	5b                   	pop    %ebx
801034b9:	5e                   	pop    %esi
801034ba:	5d                   	pop    %ebp
801034bb:	c3                   	ret    
801034bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034c0 <initlog>:
{
801034c0:	55                   	push   %ebp
801034c1:	89 e5                	mov    %esp,%ebp
801034c3:	53                   	push   %ebx
801034c4:	83 ec 2c             	sub    $0x2c,%esp
801034c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801034ca:	68 e0 94 10 80       	push   $0x801094e0
801034cf:	68 60 5a 18 80       	push   $0x80185a60
801034d4:	e8 d7 1b 00 00       	call   801050b0 <initlock>
  readsb(dev, &sb);
801034d9:	58                   	pop    %eax
801034da:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034dd:	5a                   	pop    %edx
801034de:	50                   	push   %eax
801034df:	53                   	push   %ebx
801034e0:	e8 0b e3 ff ff       	call   801017f0 <readsb>
  log.size = sb.nlog;
801034e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801034e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801034eb:	59                   	pop    %ecx
  log.dev = dev;
801034ec:	89 1d a4 5a 18 80    	mov    %ebx,0x80185aa4
  log.size = sb.nlog;
801034f2:	89 15 98 5a 18 80    	mov    %edx,0x80185a98
  log.start = sb.logstart;
801034f8:	a3 94 5a 18 80       	mov    %eax,0x80185a94
  struct buf *buf = bread(log.dev, log.start);
801034fd:	5a                   	pop    %edx
801034fe:	50                   	push   %eax
801034ff:	53                   	push   %ebx
80103500:	e8 cb cb ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103505:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103508:	83 c4 10             	add    $0x10,%esp
8010350b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010350d:	89 1d a8 5a 18 80    	mov    %ebx,0x80185aa8
  for (i = 0; i < log.lh.n; i++) {
80103513:	7e 1c                	jle    80103531 <initlog+0x71>
80103515:	c1 e3 02             	shl    $0x2,%ebx
80103518:	31 d2                	xor    %edx,%edx
8010351a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103520:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103524:	83 c2 04             	add    $0x4,%edx
80103527:	89 8a a8 5a 18 80    	mov    %ecx,-0x7fe7a558(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010352d:	39 d3                	cmp    %edx,%ebx
8010352f:	75 ef                	jne    80103520 <initlog+0x60>
  brelse(buf);
80103531:	83 ec 0c             	sub    $0xc,%esp
80103534:	50                   	push   %eax
80103535:	e8 a6 cc ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010353a:	e8 81 fe ff ff       	call   801033c0 <install_trans>
  log.lh.n = 0;
8010353f:	c7 05 a8 5a 18 80 00 	movl   $0x0,0x80185aa8
80103546:	00 00 00 
  write_head(); // clear the log
80103549:	e8 12 ff ff ff       	call   80103460 <write_head>
}
8010354e:	83 c4 10             	add    $0x10,%esp
80103551:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103554:	c9                   	leave  
80103555:	c3                   	ret    
80103556:	8d 76 00             	lea    0x0(%esi),%esi
80103559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103560 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103566:	68 60 5a 18 80       	push   $0x80185a60
8010356b:	e8 80 1c 00 00       	call   801051f0 <acquire>
80103570:	83 c4 10             	add    $0x10,%esp
80103573:	eb 18                	jmp    8010358d <begin_op+0x2d>
80103575:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103578:	83 ec 08             	sub    $0x8,%esp
8010357b:	68 60 5a 18 80       	push   $0x80185a60
80103580:	68 60 5a 18 80       	push   $0x80185a60
80103585:	e8 16 15 00 00       	call   80104aa0 <sleep>
8010358a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010358d:	a1 a0 5a 18 80       	mov    0x80185aa0,%eax
80103592:	85 c0                	test   %eax,%eax
80103594:	75 e2                	jne    80103578 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103596:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
8010359b:	8b 15 a8 5a 18 80    	mov    0x80185aa8,%edx
801035a1:	83 c0 01             	add    $0x1,%eax
801035a4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801035a7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801035aa:	83 fa 1e             	cmp    $0x1e,%edx
801035ad:	7f c9                	jg     80103578 <begin_op+0x18>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
801035af:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801035b2:	a3 9c 5a 18 80       	mov    %eax,0x80185a9c
      release(&log.lock);
801035b7:	68 60 5a 18 80       	push   $0x80185a60
801035bc:	e8 ef 1c 00 00       	call   801052b0 <release>
      break;
    }
  }
}
801035c1:	83 c4 10             	add    $0x10,%esp
801035c4:	c9                   	leave  
801035c5:	c3                   	ret    
801035c6:	8d 76 00             	lea    0x0(%esi),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	57                   	push   %edi
801035d4:	56                   	push   %esi
801035d5:	53                   	push   %ebx
801035d6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801035d9:	68 60 5a 18 80       	push   $0x80185a60
801035de:	e8 0d 1c 00 00       	call   801051f0 <acquire>
  log.outstanding -= 1;
801035e3:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
  if(log.committing)
801035e8:	8b 35 a0 5a 18 80    	mov    0x80185aa0,%esi
801035ee:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801035f4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801035f6:	89 1d 9c 5a 18 80    	mov    %ebx,0x80185a9c
  if(log.committing)
801035fc:	0f 85 1a 01 00 00    	jne    8010371c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103602:	85 db                	test   %ebx,%ebx
80103604:	0f 85 ee 00 00 00    	jne    801036f8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010360a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010360d:	c7 05 a0 5a 18 80 01 	movl   $0x1,0x80185aa0
80103614:	00 00 00 
  release(&log.lock);
80103617:	68 60 5a 18 80       	push   $0x80185a60
8010361c:	e8 8f 1c 00 00       	call   801052b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103621:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
80103627:	83 c4 10             	add    $0x10,%esp
8010362a:	85 c9                	test   %ecx,%ecx
8010362c:	0f 8e 85 00 00 00    	jle    801036b7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103632:	a1 94 5a 18 80       	mov    0x80185a94,%eax
80103637:	83 ec 08             	sub    $0x8,%esp
8010363a:	01 d8                	add    %ebx,%eax
8010363c:	83 c0 01             	add    $0x1,%eax
8010363f:	50                   	push   %eax
80103640:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
80103646:	e8 85 ca ff ff       	call   801000d0 <bread>
8010364b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010364d:	58                   	pop    %eax
8010364e:	5a                   	pop    %edx
8010364f:	ff 34 9d ac 5a 18 80 	pushl  -0x7fe7a554(,%ebx,4)
80103656:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
  for (tail = 0; tail < log.lh.n; tail++) {
8010365c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010365f:	e8 6c ca ff ff       	call   801000d0 <bread>
80103664:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103666:	8d 40 5c             	lea    0x5c(%eax),%eax
80103669:	83 c4 0c             	add    $0xc,%esp
8010366c:	68 00 02 00 00       	push   $0x200
80103671:	50                   	push   %eax
80103672:	8d 46 5c             	lea    0x5c(%esi),%eax
80103675:	50                   	push   %eax
80103676:	e8 35 1d 00 00       	call   801053b0 <memmove>
    bwrite(to);  // write the log
8010367b:	89 34 24             	mov    %esi,(%esp)
8010367e:	e8 1d cb ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103683:	89 3c 24             	mov    %edi,(%esp)
80103686:	e8 55 cb ff ff       	call   801001e0 <brelse>
    brelse(to);
8010368b:	89 34 24             	mov    %esi,(%esp)
8010368e:	e8 4d cb ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103693:	83 c4 10             	add    $0x10,%esp
80103696:	3b 1d a8 5a 18 80    	cmp    0x80185aa8,%ebx
8010369c:	7c 94                	jl     80103632 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010369e:	e8 bd fd ff ff       	call   80103460 <write_head>
    install_trans(); // Now install writes to home locations
801036a3:	e8 18 fd ff ff       	call   801033c0 <install_trans>
    log.lh.n = 0;
801036a8:	c7 05 a8 5a 18 80 00 	movl   $0x0,0x80185aa8
801036af:	00 00 00 
    write_head();    // Erase the transaction from the log
801036b2:	e8 a9 fd ff ff       	call   80103460 <write_head>
    acquire(&log.lock);
801036b7:	83 ec 0c             	sub    $0xc,%esp
801036ba:	68 60 5a 18 80       	push   $0x80185a60
801036bf:	e8 2c 1b 00 00       	call   801051f0 <acquire>
    wakeup(&log);
801036c4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036cb:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036d2:	00 00 00 
    wakeup(&log);
801036d5:	e8 06 16 00 00       	call   80104ce0 <wakeup>
    release(&log.lock);
801036da:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036e1:	e8 ca 1b 00 00       	call   801052b0 <release>
801036e6:	83 c4 10             	add    $0x10,%esp
}
801036e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ec:	5b                   	pop    %ebx
801036ed:	5e                   	pop    %esi
801036ee:	5f                   	pop    %edi
801036ef:	5d                   	pop    %ebp
801036f0:	c3                   	ret    
801036f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801036f8:	83 ec 0c             	sub    $0xc,%esp
801036fb:	68 60 5a 18 80       	push   $0x80185a60
80103700:	e8 db 15 00 00       	call   80104ce0 <wakeup>
  release(&log.lock);
80103705:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
8010370c:	e8 9f 1b 00 00       	call   801052b0 <release>
80103711:	83 c4 10             	add    $0x10,%esp
}
80103714:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103717:	5b                   	pop    %ebx
80103718:	5e                   	pop    %esi
80103719:	5f                   	pop    %edi
8010371a:	5d                   	pop    %ebp
8010371b:	c3                   	ret    
    panic("log.committing");
8010371c:	83 ec 0c             	sub    $0xc,%esp
8010371f:	68 e4 94 10 80       	push   $0x801094e4
80103724:	e8 67 cc ff ff       	call   80100390 <panic>
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103730 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	53                   	push   %ebx
80103734:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103737:	8b 15 a8 5a 18 80    	mov    0x80185aa8,%edx
{
8010373d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103740:	83 fa 1d             	cmp    $0x1d,%edx
80103743:	0f 8f 9d 00 00 00    	jg     801037e6 <log_write+0xb6>
80103749:	a1 98 5a 18 80       	mov    0x80185a98,%eax
8010374e:	83 e8 01             	sub    $0x1,%eax
80103751:	39 c2                	cmp    %eax,%edx
80103753:	0f 8d 8d 00 00 00    	jge    801037e6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103759:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
8010375e:	85 c0                	test   %eax,%eax
80103760:	0f 8e 8d 00 00 00    	jle    801037f3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103766:	83 ec 0c             	sub    $0xc,%esp
80103769:	68 60 5a 18 80       	push   $0x80185a60
8010376e:	e8 7d 1a 00 00       	call   801051f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103773:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
80103779:	83 c4 10             	add    $0x10,%esp
8010377c:	83 f9 00             	cmp    $0x0,%ecx
8010377f:	7e 57                	jle    801037d8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103781:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103784:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103786:	3b 15 ac 5a 18 80    	cmp    0x80185aac,%edx
8010378c:	75 0b                	jne    80103799 <log_write+0x69>
8010378e:	eb 38                	jmp    801037c8 <log_write+0x98>
80103790:	39 14 85 ac 5a 18 80 	cmp    %edx,-0x7fe7a554(,%eax,4)
80103797:	74 2f                	je     801037c8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103799:	83 c0 01             	add    $0x1,%eax
8010379c:	39 c1                	cmp    %eax,%ecx
8010379e:	75 f0                	jne    80103790 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801037a0:	89 14 85 ac 5a 18 80 	mov    %edx,-0x7fe7a554(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801037a7:	83 c0 01             	add    $0x1,%eax
801037aa:	a3 a8 5a 18 80       	mov    %eax,0x80185aa8
  b->flags |= B_DIRTY; // prevent eviction
801037af:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801037b2:	c7 45 08 60 5a 18 80 	movl   $0x80185a60,0x8(%ebp)
}
801037b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037bc:	c9                   	leave  
  release(&log.lock);
801037bd:	e9 ee 1a 00 00       	jmp    801052b0 <release>
801037c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801037c8:	89 14 85 ac 5a 18 80 	mov    %edx,-0x7fe7a554(,%eax,4)
801037cf:	eb de                	jmp    801037af <log_write+0x7f>
801037d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d8:	8b 43 08             	mov    0x8(%ebx),%eax
801037db:	a3 ac 5a 18 80       	mov    %eax,0x80185aac
  if (i == log.lh.n)
801037e0:	75 cd                	jne    801037af <log_write+0x7f>
801037e2:	31 c0                	xor    %eax,%eax
801037e4:	eb c1                	jmp    801037a7 <log_write+0x77>
    panic("too big a transaction");
801037e6:	83 ec 0c             	sub    $0xc,%esp
801037e9:	68 f3 94 10 80       	push   $0x801094f3
801037ee:	e8 9d cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	68 09 95 10 80       	push   $0x80109509
801037fb:	e8 90 cb ff ff       	call   80100390 <panic>

80103800 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	53                   	push   %ebx
80103804:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103807:	e8 a4 0a 00 00       	call   801042b0 <cpuid>
8010380c:	89 c3                	mov    %eax,%ebx
8010380e:	e8 9d 0a 00 00       	call   801042b0 <cpuid>
80103813:	83 ec 04             	sub    $0x4,%esp
80103816:	53                   	push   %ebx
80103817:	50                   	push   %eax
80103818:	68 24 95 10 80       	push   $0x80109524
8010381d:	e8 3e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103822:	e8 c9 2d 00 00       	call   801065f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103827:	e8 04 0a 00 00       	call   80104230 <mycpu>
8010382c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010382e:	b8 01 00 00 00       	mov    $0x1,%eax
80103833:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010383a:	e8 51 0f 00 00       	call   80104790 <scheduler>
8010383f:	90                   	nop

80103840 <mpenter>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103846:	e8 45 3f 00 00       	call   80107790 <switchkvm>
  seginit();
8010384b:	e8 b0 3e 00 00       	call   80107700 <seginit>
  lapicinit();
80103850:	e8 9b f7 ff ff       	call   80102ff0 <lapicinit>
  mpmain();
80103855:	e8 a6 ff ff ff       	call   80103800 <mpmain>
8010385a:	66 90                	xchg   %ax,%ax
8010385c:	66 90                	xchg   %ax,%ax
8010385e:	66 90                	xchg   %ax,%ax

80103860 <main>:
{
80103860:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103864:	83 e4 f0             	and    $0xfffffff0,%esp
80103867:	ff 71 fc             	pushl  -0x4(%ecx)
8010386a:	55                   	push   %ebp
8010386b:	89 e5                	mov    %esp,%ebp
8010386d:	53                   	push   %ebx
8010386e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010386f:	83 ec 08             	sub    $0x8,%esp
80103872:	68 00 00 40 80       	push   $0x80400000
80103877:	68 88 75 19 80       	push   $0x80197588
8010387c:	e8 ef f3 ff ff       	call   80102c70 <kinit1>
  kvmalloc();      // kernel page table
80103881:	e8 aa 48 00 00       	call   80108130 <kvmalloc>
  mpinit();        // detect other processors
80103886:	e8 75 01 00 00       	call   80103a00 <mpinit>
  lapicinit();     // interrupt controller
8010388b:	e8 60 f7 ff ff       	call   80102ff0 <lapicinit>
  seginit();       // segment descriptors
80103890:	e8 6b 3e 00 00       	call   80107700 <seginit>
  picinit();       // disable pic
80103895:	e8 46 03 00 00       	call   80103be0 <picinit>
  ioapicinit();    // another interrupt controller
8010389a:	e8 c1 f0 ff ff       	call   80102960 <ioapicinit>
  consoleinit();   // console hardware
8010389f:	e8 1c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801038a4:	e8 87 30 00 00       	call   80106930 <uartinit>
  pinit();         // process table
801038a9:	e8 62 09 00 00       	call   80104210 <pinit>
  tvinit();        // trap vectors
801038ae:	e8 bd 2c 00 00       	call   80106570 <tvinit>
  binit();         // buffer cache
801038b3:	e8 88 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801038b8:	e8 53 d8 ff ff       	call   80101110 <fileinit>
  ideinit();       // disk 
801038bd:	e8 7e ee ff ff       	call   80102740 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038c2:	83 c4 0c             	add    $0xc,%esp
801038c5:	68 8a 00 00 00       	push   $0x8a
801038ca:	68 8c c4 10 80       	push   $0x8010c48c
801038cf:	68 00 70 00 80       	push   $0x80007000
801038d4:	e8 d7 1a 00 00       	call   801053b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038d9:	69 05 e0 60 18 80 b0 	imul   $0xb0,0x801860e0,%eax
801038e0:	00 00 00 
801038e3:	83 c4 10             	add    $0x10,%esp
801038e6:	05 60 5b 18 80       	add    $0x80185b60,%eax
801038eb:	3d 60 5b 18 80       	cmp    $0x80185b60,%eax
801038f0:	76 71                	jbe    80103963 <main+0x103>
801038f2:	bb 60 5b 18 80       	mov    $0x80185b60,%ebx
801038f7:	89 f6                	mov    %esi,%esi
801038f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103900:	e8 2b 09 00 00       	call   80104230 <mycpu>
80103905:	39 d8                	cmp    %ebx,%eax
80103907:	74 41                	je     8010394a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103909:	e8 32 f4 ff ff       	call   80102d40 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010390e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103913:	c7 05 f8 6f 00 80 40 	movl   $0x80103840,0x80006ff8
8010391a:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010391d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103924:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103927:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010392c:	0f b6 03             	movzbl (%ebx),%eax
8010392f:	83 ec 08             	sub    $0x8,%esp
80103932:	68 00 70 00 00       	push   $0x7000
80103937:	50                   	push   %eax
80103938:	e8 03 f8 ff ff       	call   80103140 <lapicstartap>
8010393d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103940:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103946:	85 c0                	test   %eax,%eax
80103948:	74 f6                	je     80103940 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010394a:	69 05 e0 60 18 80 b0 	imul   $0xb0,0x801860e0,%eax
80103951:	00 00 00 
80103954:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010395a:	05 60 5b 18 80       	add    $0x80185b60,%eax
8010395f:	39 c3                	cmp    %eax,%ebx
80103961:	72 9d                	jb     80103900 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103963:	83 ec 08             	sub    $0x8,%esp
80103966:	68 00 00 00 8e       	push   $0x8e000000
8010396b:	68 00 00 40 80       	push   $0x80400000
80103970:	e8 6b f3 ff ff       	call   80102ce0 <kinit2>
  userinit();      // first user process
80103975:	e8 86 09 00 00       	call   80104300 <userinit>
  mpmain();        // finish this processor's setup
8010397a:	e8 81 fe ff ff       	call   80103800 <mpmain>
8010397f:	90                   	nop

80103980 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103985:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010398b:	53                   	push   %ebx
  e = addr+len;
8010398c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010398f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103992:	39 de                	cmp    %ebx,%esi
80103994:	72 10                	jb     801039a6 <mpsearch1+0x26>
80103996:	eb 50                	jmp    801039e8 <mpsearch1+0x68>
80103998:	90                   	nop
80103999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039a0:	39 fb                	cmp    %edi,%ebx
801039a2:	89 fe                	mov    %edi,%esi
801039a4:	76 42                	jbe    801039e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039a6:	83 ec 04             	sub    $0x4,%esp
801039a9:	8d 7e 10             	lea    0x10(%esi),%edi
801039ac:	6a 04                	push   $0x4
801039ae:	68 38 95 10 80       	push   $0x80109538
801039b3:	56                   	push   %esi
801039b4:	e8 97 19 00 00       	call   80105350 <memcmp>
801039b9:	83 c4 10             	add    $0x10,%esp
801039bc:	85 c0                	test   %eax,%eax
801039be:	75 e0                	jne    801039a0 <mpsearch1+0x20>
801039c0:	89 f1                	mov    %esi,%ecx
801039c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801039c8:	0f b6 11             	movzbl (%ecx),%edx
801039cb:	83 c1 01             	add    $0x1,%ecx
801039ce:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801039d0:	39 f9                	cmp    %edi,%ecx
801039d2:	75 f4                	jne    801039c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039d4:	84 c0                	test   %al,%al
801039d6:	75 c8                	jne    801039a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801039d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039db:	89 f0                	mov    %esi,%eax
801039dd:	5b                   	pop    %ebx
801039de:	5e                   	pop    %esi
801039df:	5f                   	pop    %edi
801039e0:	5d                   	pop    %ebp
801039e1:	c3                   	ret    
801039e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039eb:	31 f6                	xor    %esi,%esi
}
801039ed:	89 f0                	mov    %esi,%eax
801039ef:	5b                   	pop    %ebx
801039f0:	5e                   	pop    %esi
801039f1:	5f                   	pop    %edi
801039f2:	5d                   	pop    %ebp
801039f3:	c3                   	ret    
801039f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a00 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a09:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103a10:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103a17:	c1 e0 08             	shl    $0x8,%eax
80103a1a:	09 d0                	or     %edx,%eax
80103a1c:	c1 e0 04             	shl    $0x4,%eax
80103a1f:	85 c0                	test   %eax,%eax
80103a21:	75 1b                	jne    80103a3e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a23:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a2a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a31:	c1 e0 08             	shl    $0x8,%eax
80103a34:	09 d0                	or     %edx,%eax
80103a36:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a39:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a3e:	ba 00 04 00 00       	mov    $0x400,%edx
80103a43:	e8 38 ff ff ff       	call   80103980 <mpsearch1>
80103a48:	85 c0                	test   %eax,%eax
80103a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a4d:	0f 84 3d 01 00 00    	je     80103b90 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a56:	8b 58 04             	mov    0x4(%eax),%ebx
80103a59:	85 db                	test   %ebx,%ebx
80103a5b:	0f 84 4f 01 00 00    	je     80103bb0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a61:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103a67:	83 ec 04             	sub    $0x4,%esp
80103a6a:	6a 04                	push   $0x4
80103a6c:	68 55 95 10 80       	push   $0x80109555
80103a71:	56                   	push   %esi
80103a72:	e8 d9 18 00 00       	call   80105350 <memcmp>
80103a77:	83 c4 10             	add    $0x10,%esp
80103a7a:	85 c0                	test   %eax,%eax
80103a7c:	0f 85 2e 01 00 00    	jne    80103bb0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103a82:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103a89:	3c 01                	cmp    $0x1,%al
80103a8b:	0f 95 c2             	setne  %dl
80103a8e:	3c 04                	cmp    $0x4,%al
80103a90:	0f 95 c0             	setne  %al
80103a93:	20 c2                	and    %al,%dl
80103a95:	0f 85 15 01 00 00    	jne    80103bb0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a9b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103aa2:	66 85 ff             	test   %di,%di
80103aa5:	74 1a                	je     80103ac1 <mpinit+0xc1>
80103aa7:	89 f0                	mov    %esi,%eax
80103aa9:	01 f7                	add    %esi,%edi
  sum = 0;
80103aab:	31 d2                	xor    %edx,%edx
80103aad:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103ab0:	0f b6 08             	movzbl (%eax),%ecx
80103ab3:	83 c0 01             	add    $0x1,%eax
80103ab6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103ab8:	39 c7                	cmp    %eax,%edi
80103aba:	75 f4                	jne    80103ab0 <mpinit+0xb0>
80103abc:	84 d2                	test   %dl,%dl
80103abe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103ac1:	85 f6                	test   %esi,%esi
80103ac3:	0f 84 e7 00 00 00    	je     80103bb0 <mpinit+0x1b0>
80103ac9:	84 d2                	test   %dl,%dl
80103acb:	0f 85 df 00 00 00    	jne    80103bb0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103ad1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103ad7:	a3 5c 5a 18 80       	mov    %eax,0x80185a5c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103adc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103ae3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103ae9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103aee:	01 d6                	add    %edx,%esi
80103af0:	39 c6                	cmp    %eax,%esi
80103af2:	76 23                	jbe    80103b17 <mpinit+0x117>
    switch(*p){
80103af4:	0f b6 10             	movzbl (%eax),%edx
80103af7:	80 fa 04             	cmp    $0x4,%dl
80103afa:	0f 87 ca 00 00 00    	ja     80103bca <mpinit+0x1ca>
80103b00:	ff 24 95 7c 95 10 80 	jmp    *-0x7fef6a84(,%edx,4)
80103b07:	89 f6                	mov    %esi,%esi
80103b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b10:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b13:	39 c6                	cmp    %eax,%esi
80103b15:	77 dd                	ja     80103af4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b17:	85 db                	test   %ebx,%ebx
80103b19:	0f 84 9e 00 00 00    	je     80103bbd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103b1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b22:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103b26:	74 15                	je     80103b3d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b28:	b8 70 00 00 00       	mov    $0x70,%eax
80103b2d:	ba 22 00 00 00       	mov    $0x22,%edx
80103b32:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b33:	ba 23 00 00 00       	mov    $0x23,%edx
80103b38:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b39:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b3c:	ee                   	out    %al,(%dx)
  }
}
80103b3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b40:	5b                   	pop    %ebx
80103b41:	5e                   	pop    %esi
80103b42:	5f                   	pop    %edi
80103b43:	5d                   	pop    %ebp
80103b44:	c3                   	ret    
80103b45:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103b48:	8b 0d e0 60 18 80    	mov    0x801860e0,%ecx
80103b4e:	83 f9 07             	cmp    $0x7,%ecx
80103b51:	7f 19                	jg     80103b6c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b53:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103b57:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103b5d:	83 c1 01             	add    $0x1,%ecx
80103b60:	89 0d e0 60 18 80    	mov    %ecx,0x801860e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b66:	88 97 60 5b 18 80    	mov    %dl,-0x7fe7a4a0(%edi)
      p += sizeof(struct mpproc);
80103b6c:	83 c0 14             	add    $0x14,%eax
      continue;
80103b6f:	e9 7c ff ff ff       	jmp    80103af0 <mpinit+0xf0>
80103b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b78:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103b7c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b7f:	88 15 40 5b 18 80    	mov    %dl,0x80185b40
      continue;
80103b85:	e9 66 ff ff ff       	jmp    80103af0 <mpinit+0xf0>
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103b90:	ba 00 00 01 00       	mov    $0x10000,%edx
80103b95:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103b9a:	e8 e1 fd ff ff       	call   80103980 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b9f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103ba1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ba4:	0f 85 a9 fe ff ff    	jne    80103a53 <mpinit+0x53>
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	68 3d 95 10 80       	push   $0x8010953d
80103bb8:	e8 d3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bbd:	83 ec 0c             	sub    $0xc,%esp
80103bc0:	68 5c 95 10 80       	push   $0x8010955c
80103bc5:	e8 c6 c7 ff ff       	call   80100390 <panic>
      ismp = 0;
80103bca:	31 db                	xor    %ebx,%ebx
80103bcc:	e9 26 ff ff ff       	jmp    80103af7 <mpinit+0xf7>
80103bd1:	66 90                	xchg   %ax,%ax
80103bd3:	66 90                	xchg   %ax,%ax
80103bd5:	66 90                	xchg   %ax,%ax
80103bd7:	66 90                	xchg   %ax,%ax
80103bd9:	66 90                	xchg   %ax,%ax
80103bdb:	66 90                	xchg   %ax,%ax
80103bdd:	66 90                	xchg   %ax,%ax
80103bdf:	90                   	nop

80103be0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103be0:	55                   	push   %ebp
80103be1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103be6:	ba 21 00 00 00       	mov    $0x21,%edx
80103beb:	89 e5                	mov    %esp,%ebp
80103bed:	ee                   	out    %al,(%dx)
80103bee:	ba a1 00 00 00       	mov    $0xa1,%edx
80103bf3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103bf4:	5d                   	pop    %ebp
80103bf5:	c3                   	ret    
80103bf6:	66 90                	xchg   %ax,%ax
80103bf8:	66 90                	xchg   %ax,%ax
80103bfa:	66 90                	xchg   %ax,%ax
80103bfc:	66 90                	xchg   %ax,%ax
80103bfe:	66 90                	xchg   %ax,%ax

80103c00 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	57                   	push   %edi
80103c04:	56                   	push   %esi
80103c05:	53                   	push   %ebx
80103c06:	83 ec 0c             	sub    $0xc,%esp
80103c09:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103c0f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103c15:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c1b:	e8 10 d5 ff ff       	call   80101130 <filealloc>
80103c20:	85 c0                	test   %eax,%eax
80103c22:	89 03                	mov    %eax,(%ebx)
80103c24:	74 22                	je     80103c48 <pipealloc+0x48>
80103c26:	e8 05 d5 ff ff       	call   80101130 <filealloc>
80103c2b:	85 c0                	test   %eax,%eax
80103c2d:	89 06                	mov    %eax,(%esi)
80103c2f:	74 3f                	je     80103c70 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c31:	e8 0a f1 ff ff       	call   80102d40 <kalloc>
80103c36:	85 c0                	test   %eax,%eax
80103c38:	89 c7                	mov    %eax,%edi
80103c3a:	75 54                	jne    80103c90 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103c3c:	8b 03                	mov    (%ebx),%eax
80103c3e:	85 c0                	test   %eax,%eax
80103c40:	75 34                	jne    80103c76 <pipealloc+0x76>
80103c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103c48:	8b 06                	mov    (%esi),%eax
80103c4a:	85 c0                	test   %eax,%eax
80103c4c:	74 0c                	je     80103c5a <pipealloc+0x5a>
    fileclose(*f1);
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	50                   	push   %eax
80103c52:	e8 99 d5 ff ff       	call   801011f0 <fileclose>
80103c57:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c62:	5b                   	pop    %ebx
80103c63:	5e                   	pop    %esi
80103c64:	5f                   	pop    %edi
80103c65:	5d                   	pop    %ebp
80103c66:	c3                   	ret    
80103c67:	89 f6                	mov    %esi,%esi
80103c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103c70:	8b 03                	mov    (%ebx),%eax
80103c72:	85 c0                	test   %eax,%eax
80103c74:	74 e4                	je     80103c5a <pipealloc+0x5a>
    fileclose(*f0);
80103c76:	83 ec 0c             	sub    $0xc,%esp
80103c79:	50                   	push   %eax
80103c7a:	e8 71 d5 ff ff       	call   801011f0 <fileclose>
  if(*f1)
80103c7f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103c81:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103c84:	85 c0                	test   %eax,%eax
80103c86:	75 c6                	jne    80103c4e <pipealloc+0x4e>
80103c88:	eb d0                	jmp    80103c5a <pipealloc+0x5a>
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103c90:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103c93:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c9a:	00 00 00 
  p->writeopen = 1;
80103c9d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ca4:	00 00 00 
  p->nwrite = 0;
80103ca7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cae:	00 00 00 
  p->nread = 0;
80103cb1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cb8:	00 00 00 
  initlock(&p->lock, "pipe");
80103cbb:	68 90 95 10 80       	push   $0x80109590
80103cc0:	50                   	push   %eax
80103cc1:	e8 ea 13 00 00       	call   801050b0 <initlock>
  (*f0)->type = FD_PIPE;
80103cc6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103cc8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103ccb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cd1:	8b 03                	mov    (%ebx),%eax
80103cd3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cd7:	8b 03                	mov    (%ebx),%eax
80103cd9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cdd:	8b 03                	mov    (%ebx),%eax
80103cdf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103ce2:	8b 06                	mov    (%esi),%eax
80103ce4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cea:	8b 06                	mov    (%esi),%eax
80103cec:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cf0:	8b 06                	mov    (%esi),%eax
80103cf2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cf6:	8b 06                	mov    (%esi),%eax
80103cf8:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103cfe:	31 c0                	xor    %eax,%eax
}
80103d00:	5b                   	pop    %ebx
80103d01:	5e                   	pop    %esi
80103d02:	5f                   	pop    %edi
80103d03:	5d                   	pop    %ebp
80103d04:	c3                   	ret    
80103d05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d10 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d10:	55                   	push   %ebp
80103d11:	89 e5                	mov    %esp,%ebp
80103d13:	56                   	push   %esi
80103d14:	53                   	push   %ebx
80103d15:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d18:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103d1b:	83 ec 0c             	sub    $0xc,%esp
80103d1e:	53                   	push   %ebx
80103d1f:	e8 cc 14 00 00       	call   801051f0 <acquire>
  if(writable){
80103d24:	83 c4 10             	add    $0x10,%esp
80103d27:	85 f6                	test   %esi,%esi
80103d29:	74 45                	je     80103d70 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d2b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d31:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103d34:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d3b:	00 00 00 
    wakeup(&p->nread);
80103d3e:	50                   	push   %eax
80103d3f:	e8 9c 0f 00 00       	call   80104ce0 <wakeup>
80103d44:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d47:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d4d:	85 d2                	test   %edx,%edx
80103d4f:	75 0a                	jne    80103d5b <pipeclose+0x4b>
80103d51:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d57:	85 c0                	test   %eax,%eax
80103d59:	74 35                	je     80103d90 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103d5b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d61:	5b                   	pop    %ebx
80103d62:	5e                   	pop    %esi
80103d63:	5d                   	pop    %ebp
    release(&p->lock);
80103d64:	e9 47 15 00 00       	jmp    801052b0 <release>
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d70:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d76:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d79:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d80:	00 00 00 
    wakeup(&p->nwrite);
80103d83:	50                   	push   %eax
80103d84:	e8 57 0f 00 00       	call   80104ce0 <wakeup>
80103d89:	83 c4 10             	add    $0x10,%esp
80103d8c:	eb b9                	jmp    80103d47 <pipeclose+0x37>
80103d8e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	53                   	push   %ebx
80103d94:	e8 17 15 00 00       	call   801052b0 <release>
    kfree((char*)p);
80103d99:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d9c:	83 c4 10             	add    $0x10,%esp
}
80103d9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da2:	5b                   	pop    %ebx
80103da3:	5e                   	pop    %esi
80103da4:	5d                   	pop    %ebp
    kfree((char*)p);
80103da5:	e9 a6 ec ff ff       	jmp    80102a50 <kfree>
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103db0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	57                   	push   %edi
80103db4:	56                   	push   %esi
80103db5:	53                   	push   %ebx
80103db6:	83 ec 28             	sub    $0x28,%esp
80103db9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103dbc:	53                   	push   %ebx
80103dbd:	e8 2e 14 00 00       	call   801051f0 <acquire>
  for(i = 0; i < n; i++){
80103dc2:	8b 45 10             	mov    0x10(%ebp),%eax
80103dc5:	83 c4 10             	add    $0x10,%esp
80103dc8:	85 c0                	test   %eax,%eax
80103dca:	0f 8e c9 00 00 00    	jle    80103e99 <pipewrite+0xe9>
80103dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103dd3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103dd9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103ddf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103de2:	03 4d 10             	add    0x10(%ebp),%ecx
80103de5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103de8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103dee:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103df4:	39 d0                	cmp    %edx,%eax
80103df6:	75 71                	jne    80103e69 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103df8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103dfe:	85 c0                	test   %eax,%eax
80103e00:	74 4e                	je     80103e50 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e02:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103e08:	eb 3a                	jmp    80103e44 <pipewrite+0x94>
80103e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103e10:	83 ec 0c             	sub    $0xc,%esp
80103e13:	57                   	push   %edi
80103e14:	e8 c7 0e 00 00       	call   80104ce0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e19:	5a                   	pop    %edx
80103e1a:	59                   	pop    %ecx
80103e1b:	53                   	push   %ebx
80103e1c:	56                   	push   %esi
80103e1d:	e8 7e 0c 00 00       	call   80104aa0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e22:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e28:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e2e:	83 c4 10             	add    $0x10,%esp
80103e31:	05 00 02 00 00       	add    $0x200,%eax
80103e36:	39 c2                	cmp    %eax,%edx
80103e38:	75 36                	jne    80103e70 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103e3a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e40:	85 c0                	test   %eax,%eax
80103e42:	74 0c                	je     80103e50 <pipewrite+0xa0>
80103e44:	e8 87 04 00 00       	call   801042d0 <myproc>
80103e49:	8b 40 24             	mov    0x24(%eax),%eax
80103e4c:	85 c0                	test   %eax,%eax
80103e4e:	74 c0                	je     80103e10 <pipewrite+0x60>
        release(&p->lock);
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	53                   	push   %ebx
80103e54:	e8 57 14 00 00       	call   801052b0 <release>
        return -1;
80103e59:	83 c4 10             	add    $0x10,%esp
80103e5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e64:	5b                   	pop    %ebx
80103e65:	5e                   	pop    %esi
80103e66:	5f                   	pop    %edi
80103e67:	5d                   	pop    %ebp
80103e68:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e69:	89 c2                	mov    %eax,%edx
80103e6b:	90                   	nop
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e70:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103e73:	8d 42 01             	lea    0x1(%edx),%eax
80103e76:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103e7c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103e82:	83 c6 01             	add    $0x1,%esi
80103e85:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103e89:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e8c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e8f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e93:	0f 85 4f ff ff ff    	jne    80103de8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e99:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e9f:	83 ec 0c             	sub    $0xc,%esp
80103ea2:	50                   	push   %eax
80103ea3:	e8 38 0e 00 00       	call   80104ce0 <wakeup>
  release(&p->lock);
80103ea8:	89 1c 24             	mov    %ebx,(%esp)
80103eab:	e8 00 14 00 00       	call   801052b0 <release>
  return n;
80103eb0:	83 c4 10             	add    $0x10,%esp
80103eb3:	8b 45 10             	mov    0x10(%ebp),%eax
80103eb6:	eb a9                	jmp    80103e61 <pipewrite+0xb1>
80103eb8:	90                   	nop
80103eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ec0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 18             	sub    $0x18,%esp
80103ec9:	8b 75 08             	mov    0x8(%ebp),%esi
80103ecc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103ecf:	56                   	push   %esi
80103ed0:	e8 1b 13 00 00       	call   801051f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ed5:	83 c4 10             	add    $0x10,%esp
80103ed8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ede:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ee4:	75 6a                	jne    80103f50 <piperead+0x90>
80103ee6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103eec:	85 db                	test   %ebx,%ebx
80103eee:	0f 84 c4 00 00 00    	je     80103fb8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ef4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103efa:	eb 2d                	jmp    80103f29 <piperead+0x69>
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f00:	83 ec 08             	sub    $0x8,%esp
80103f03:	56                   	push   %esi
80103f04:	53                   	push   %ebx
80103f05:	e8 96 0b 00 00       	call   80104aa0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f0a:	83 c4 10             	add    $0x10,%esp
80103f0d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f13:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f19:	75 35                	jne    80103f50 <piperead+0x90>
80103f1b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103f21:	85 d2                	test   %edx,%edx
80103f23:	0f 84 8f 00 00 00    	je     80103fb8 <piperead+0xf8>
    if(myproc()->killed){
80103f29:	e8 a2 03 00 00       	call   801042d0 <myproc>
80103f2e:	8b 48 24             	mov    0x24(%eax),%ecx
80103f31:	85 c9                	test   %ecx,%ecx
80103f33:	74 cb                	je     80103f00 <piperead+0x40>
      release(&p->lock);
80103f35:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f38:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f3d:	56                   	push   %esi
80103f3e:	e8 6d 13 00 00       	call   801052b0 <release>
      return -1;
80103f43:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f49:	89 d8                	mov    %ebx,%eax
80103f4b:	5b                   	pop    %ebx
80103f4c:	5e                   	pop    %esi
80103f4d:	5f                   	pop    %edi
80103f4e:	5d                   	pop    %ebp
80103f4f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f50:	8b 45 10             	mov    0x10(%ebp),%eax
80103f53:	85 c0                	test   %eax,%eax
80103f55:	7e 61                	jle    80103fb8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103f57:	31 db                	xor    %ebx,%ebx
80103f59:	eb 13                	jmp    80103f6e <piperead+0xae>
80103f5b:	90                   	nop
80103f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f60:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f66:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f6c:	74 1f                	je     80103f8d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f6e:	8d 41 01             	lea    0x1(%ecx),%eax
80103f71:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103f77:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103f7d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103f82:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f85:	83 c3 01             	add    $0x1,%ebx
80103f88:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f8b:	75 d3                	jne    80103f60 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f8d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103f93:	83 ec 0c             	sub    $0xc,%esp
80103f96:	50                   	push   %eax
80103f97:	e8 44 0d 00 00       	call   80104ce0 <wakeup>
  release(&p->lock);
80103f9c:	89 34 24             	mov    %esi,(%esp)
80103f9f:	e8 0c 13 00 00       	call   801052b0 <release>
  return i;
80103fa4:	83 c4 10             	add    $0x10,%esp
}
80103fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103faa:	89 d8                	mov    %ebx,%eax
80103fac:	5b                   	pop    %ebx
80103fad:	5e                   	pop    %esi
80103fae:	5f                   	pop    %edi
80103faf:	5d                   	pop    %ebp
80103fb0:	c3                   	ret    
80103fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fb8:	31 db                	xor    %ebx,%ebx
80103fba:	eb d1                	jmp    80103f8d <piperead+0xcd>
80103fbc:	66 90                	xchg   %ax,%ax
80103fbe:	66 90                	xchg   %ax,%ax

80103fc0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fc0:	55                   	push   %ebp
80103fc1:	89 e5                	mov    %esp,%ebp
80103fc3:	57                   	push   %edi
80103fc4:	56                   	push   %esi
80103fc5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc6:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80103fcb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103fce:	68 00 61 18 80       	push   $0x80186100
80103fd3:	e8 18 12 00 00       	call   801051f0 <acquire>
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	eb 15                	jmp    80103ff2 <allocproc+0x32>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fe0:	81 c3 30 04 00 00    	add    $0x430,%ebx
80103fe6:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80103fec:	0f 83 96 01 00 00    	jae    80104188 <allocproc+0x1c8>
    if(p->state == UNUSED)
80103ff2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103ff5:	85 c0                	test   %eax,%eax
80103ff7:	75 e7                	jne    80103fe0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103ff9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103ffe:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104001:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104008:	8d 50 01             	lea    0x1(%eax),%edx
8010400b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010400e:	68 00 61 18 80       	push   $0x80186100
  p->pid = nextpid++;
80104013:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104019:	e8 92 12 00 00       	call   801052b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010401e:	e8 1d ed ff ff       	call   80102d40 <kalloc>
80104023:	83 c4 10             	add    $0x10,%esp
80104026:	85 c0                	test   %eax,%eax
80104028:	89 43 08             	mov    %eax,0x8(%ebx)
8010402b:	0f 84 73 01 00 00    	je     801041a4 <allocproc+0x1e4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104031:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104037:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010403a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010403f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104042:	c7 40 14 61 65 10 80 	movl   $0x80106561,0x14(%eax)
  p->context = (struct context*)sp;
80104049:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010404c:	6a 14                	push   $0x14
8010404e:	6a 00                	push   $0x0
80104050:	50                   	push   %eax
80104051:	e8 aa 12 00 00       	call   80105300 <memset>
  p->context->eip = (uint)forkret;
80104056:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80104059:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010405c:	c7 40 10 c0 41 10 80 	movl   $0x801041c0,0x10(%eax)
  if(p->pid > 2) {
80104063:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104067:	7f 0f                	jg     80104078 <allocproc+0xb8>
      // cprintf("\n");

    }
  }
  return p;
}
80104069:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010406c:	89 d8                	mov    %ebx,%eax
8010406e:	5b                   	pop    %ebx
8010406f:	5e                   	pop    %esi
80104070:	5f                   	pop    %edi
80104071:	5d                   	pop    %ebp
80104072:	c3                   	ret    
80104073:	90                   	nop
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(createSwapFile(p) != 0)
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	53                   	push   %ebx
8010407c:	e8 df e4 ff ff       	call   80102560 <createSwapFile>
80104081:	83 c4 10             	add    $0x10,%esp
80104084:	85 c0                	test   %eax,%eax
80104086:	0f 85 26 01 00 00    	jne    801041b2 <allocproc+0x1f2>
    if(p->selection == SCFIFO)
8010408c:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
    p->num_ram = 0;
80104092:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80104099:	00 00 00 
    p->num_swap = 0;
8010409c:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
801040a3:	00 00 00 
    p->totalPgfltCount = 0;
801040a6:	c7 83 28 04 00 00 00 	movl   $0x0,0x428(%ebx)
801040ad:	00 00 00 
    p->totalPgoutCount = 0;
801040b0:	c7 83 2c 04 00 00 00 	movl   $0x0,0x42c(%ebx)
801040b7:	00 00 00 
    if(p->selection == SCFIFO)
801040ba:	83 f8 03             	cmp    $0x3,%eax
801040bd:	0f 84 b1 00 00 00    	je     80104174 <allocproc+0x1b4>
    if(p->selection == AQ)
801040c3:	83 f8 04             	cmp    $0x4,%eax
801040c6:	75 14                	jne    801040dc <allocproc+0x11c>
      p->queue_head = 0;
801040c8:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
801040cf:	00 00 00 
      p->queue_tail = 0;
801040d2:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
801040d9:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040dc:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
801040e2:	83 ec 04             	sub    $0x4,%esp
801040e5:	68 c0 01 00 00       	push   $0x1c0
801040ea:	6a 00                	push   $0x0
801040ec:	50                   	push   %eax
801040ed:	e8 0e 12 00 00       	call   80105300 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040f2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040f8:	83 c4 0c             	add    $0xc,%esp
801040fb:	68 c0 01 00 00       	push   $0x1c0
80104100:	6a 00                	push   $0x0
80104102:	50                   	push   %eax
80104103:	e8 f8 11 00 00       	call   80105300 <memset>
    if(p->pid > 2)
80104108:	83 c4 10             	add    $0x10,%esp
8010410b:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010410f:	0f 8e 54 ff ff ff    	jle    80104069 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
80104115:	e8 26 ec ff ff       	call   80102d40 <kalloc>
8010411a:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      p->free_head->prev = 0;
80104120:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = p->free_head;
80104127:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head->off = 0 * PGSIZE;
8010412c:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80104132:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80104138:	8b bb 14 04 00 00    	mov    0x414(%ebx),%edi
8010413e:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80104140:	e8 fb eb ff ff       	call   80102d40 <kalloc>
        curr->off = i * PGSIZE;
80104145:	89 30                	mov    %esi,(%eax)
80104147:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
8010414d:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80104150:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80104156:	89 47 04             	mov    %eax,0x4(%edi)
80104159:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
8010415b:	75 e3                	jne    80104140 <allocproc+0x180>
      p->free_tail = prev;
8010415d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
      p->free_tail->next = 0;
80104163:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
8010416a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010416d:	89 d8                	mov    %ebx,%eax
8010416f:	5b                   	pop    %ebx
80104170:	5e                   	pop    %esi
80104171:	5f                   	pop    %edi
80104172:	5d                   	pop    %ebp
80104173:	c3                   	ret    
      p->clockHand = 0;
80104174:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
8010417b:	00 00 00 
8010417e:	e9 59 ff ff ff       	jmp    801040dc <allocproc+0x11c>
80104183:	90                   	nop
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104188:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010418b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010418d:	68 00 61 18 80       	push   $0x80186100
80104192:	e8 19 11 00 00       	call   801052b0 <release>
  return 0;
80104197:	83 c4 10             	add    $0x10,%esp
}
8010419a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010419d:	89 d8                	mov    %ebx,%eax
8010419f:	5b                   	pop    %ebx
801041a0:	5e                   	pop    %esi
801041a1:	5f                   	pop    %edi
801041a2:	5d                   	pop    %ebp
801041a3:	c3                   	ret    
    p->state = UNUSED;
801041a4:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801041ab:	31 db                	xor    %ebx,%ebx
801041ad:	e9 b7 fe ff ff       	jmp    80104069 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
801041b2:	83 ec 0c             	sub    $0xc,%esp
801041b5:	68 95 95 10 80       	push   $0x80109595
801041ba:	e8 d1 c1 ff ff       	call   80100390 <panic>
801041bf:	90                   	nop

801041c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801041c6:	68 00 61 18 80       	push   $0x80186100
801041cb:	e8 e0 10 00 00       	call   801052b0 <release>

  if (first) {
801041d0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801041d5:	83 c4 10             	add    $0x10,%esp
801041d8:	85 c0                	test   %eax,%eax
801041da:	75 04                	jne    801041e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801041dc:	c9                   	leave  
801041dd:	c3                   	ret    
801041de:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801041e0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801041e3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801041ea:	00 00 00 
    iinit(ROOTDEV);
801041ed:	6a 01                	push   $0x1
801041ef:	e8 3c d6 ff ff       	call   80101830 <iinit>
    initlog(ROOTDEV);
801041f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801041fb:	e8 c0 f2 ff ff       	call   801034c0 <initlog>
80104200:	83 c4 10             	add    $0x10,%esp
}
80104203:	c9                   	leave  
80104204:	c3                   	ret    
80104205:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104210 <pinit>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104216:	68 af 95 10 80       	push   $0x801095af
8010421b:	68 00 61 18 80       	push   $0x80186100
80104220:	e8 8b 0e 00 00       	call   801050b0 <initlock>
}
80104225:	83 c4 10             	add    $0x10,%esp
80104228:	c9                   	leave  
80104229:	c3                   	ret    
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104230 <mycpu>:
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	56                   	push   %esi
80104234:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104235:	9c                   	pushf  
80104236:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104237:	f6 c4 02             	test   $0x2,%ah
8010423a:	75 5e                	jne    8010429a <mycpu+0x6a>
  apicid = lapicid();
8010423c:	e8 af ee ff ff       	call   801030f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104241:	8b 35 e0 60 18 80    	mov    0x801860e0,%esi
80104247:	85 f6                	test   %esi,%esi
80104249:	7e 42                	jle    8010428d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010424b:	0f b6 15 60 5b 18 80 	movzbl 0x80185b60,%edx
80104252:	39 d0                	cmp    %edx,%eax
80104254:	74 30                	je     80104286 <mycpu+0x56>
80104256:	b9 10 5c 18 80       	mov    $0x80185c10,%ecx
  for (i = 0; i < ncpu; ++i) {
8010425b:	31 d2                	xor    %edx,%edx
8010425d:	8d 76 00             	lea    0x0(%esi),%esi
80104260:	83 c2 01             	add    $0x1,%edx
80104263:	39 f2                	cmp    %esi,%edx
80104265:	74 26                	je     8010428d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104267:	0f b6 19             	movzbl (%ecx),%ebx
8010426a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104270:	39 c3                	cmp    %eax,%ebx
80104272:	75 ec                	jne    80104260 <mycpu+0x30>
80104274:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010427a:	05 60 5b 18 80       	add    $0x80185b60,%eax
}
8010427f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104286:	b8 60 5b 18 80       	mov    $0x80185b60,%eax
      return &cpus[i];
8010428b:	eb f2                	jmp    8010427f <mycpu+0x4f>
  panic("unknown apicid\n");
8010428d:	83 ec 0c             	sub    $0xc,%esp
80104290:	68 b6 95 10 80       	push   $0x801095b6
80104295:	e8 f6 c0 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010429a:	83 ec 0c             	sub    $0xc,%esp
8010429d:	68 a4 96 10 80       	push   $0x801096a4
801042a2:	e8 e9 c0 ff ff       	call   80100390 <panic>
801042a7:	89 f6                	mov    %esi,%esi
801042a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042b0 <cpuid>:
cpuid() {
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801042b6:	e8 75 ff ff ff       	call   80104230 <mycpu>
801042bb:	2d 60 5b 18 80       	sub    $0x80185b60,%eax
}
801042c0:	c9                   	leave  
  return mycpu()-cpus;
801042c1:	c1 f8 04             	sar    $0x4,%eax
801042c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042ca:	c3                   	ret    
801042cb:	90                   	nop
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042d0 <myproc>:
myproc(void) {
801042d0:	55                   	push   %ebp
801042d1:	89 e5                	mov    %esp,%ebp
801042d3:	53                   	push   %ebx
801042d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042d7:	e8 44 0e 00 00       	call   80105120 <pushcli>
  c = mycpu();
801042dc:	e8 4f ff ff ff       	call   80104230 <mycpu>
  p = c->proc;
801042e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e7:	e8 74 0e 00 00       	call   80105160 <popcli>
}
801042ec:	83 c4 04             	add    $0x4,%esp
801042ef:	89 d8                	mov    %ebx,%eax
801042f1:	5b                   	pop    %ebx
801042f2:	5d                   	pop    %ebp
801042f3:	c3                   	ret    
801042f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104300 <userinit>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104307:	e8 b4 fc ff ff       	call   80103fc0 <allocproc>
8010430c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010430e:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  if((p->pgdir = setupkvm()) == 0)
80104313:	e8 88 3d 00 00       	call   801080a0 <setupkvm>
80104318:	85 c0                	test   %eax,%eax
8010431a:	89 43 04             	mov    %eax,0x4(%ebx)
8010431d:	0f 84 bd 00 00 00    	je     801043e0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104323:	83 ec 04             	sub    $0x4,%esp
80104326:	68 2c 00 00 00       	push   $0x2c
8010432b:	68 60 c4 10 80       	push   $0x8010c460
80104330:	50                   	push   %eax
80104331:	e8 8a 35 00 00       	call   801078c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104336:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104339:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010433f:	6a 4c                	push   $0x4c
80104341:	6a 00                	push   $0x0
80104343:	ff 73 18             	pushl  0x18(%ebx)
80104346:	e8 b5 0f 00 00       	call   80105300 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010434b:	8b 43 18             	mov    0x18(%ebx),%eax
8010434e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104353:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104358:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010435b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010435f:	8b 43 18             	mov    0x18(%ebx),%eax
80104362:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104366:	8b 43 18             	mov    0x18(%ebx),%eax
80104369:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010436d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104371:	8b 43 18             	mov    0x18(%ebx),%eax
80104374:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104378:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010437c:	8b 43 18             	mov    0x18(%ebx),%eax
8010437f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104386:	8b 43 18             	mov    0x18(%ebx),%eax
80104389:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104390:	8b 43 18             	mov    0x18(%ebx),%eax
80104393:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010439a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010439d:	6a 10                	push   $0x10
8010439f:	68 df 95 10 80       	push   $0x801095df
801043a4:	50                   	push   %eax
801043a5:	e8 36 11 00 00       	call   801054e0 <safestrcpy>
  p->cwd = namei("/");
801043aa:	c7 04 24 e8 95 10 80 	movl   $0x801095e8,(%esp)
801043b1:	e8 da de ff ff       	call   80102290 <namei>
801043b6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043b9:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043c0:	e8 2b 0e 00 00       	call   801051f0 <acquire>
  p->state = RUNNABLE;
801043c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043cc:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043d3:	e8 d8 0e 00 00       	call   801052b0 <release>
}
801043d8:	83 c4 10             	add    $0x10,%esp
801043db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043de:	c9                   	leave  
801043df:	c3                   	ret    
    panic("userinit: out of memory?");
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	68 c6 95 10 80       	push   $0x801095c6
801043e8:	e8 a3 bf ff ff       	call   80100390 <panic>
801043ed:	8d 76 00             	lea    0x0(%esi),%esi

801043f0 <growproc>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
801043f5:	83 ec 10             	sub    $0x10,%esp
801043f8:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801043fb:	e8 20 0d 00 00       	call   80105120 <pushcli>
  c = mycpu();
80104400:	e8 2b fe ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104405:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010440b:	e8 50 0d 00 00       	call   80105160 <popcli>
  if(n > 0){
80104410:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104413:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104415:	7f 19                	jg     80104430 <growproc+0x40>
  } else if(n < 0){
80104417:	75 37                	jne    80104450 <growproc+0x60>
  switchuvm(curproc);
80104419:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010441c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010441e:	53                   	push   %ebx
8010441f:	e8 8c 33 00 00       	call   801077b0 <switchuvm>
  return 0;
80104424:	83 c4 10             	add    $0x10,%esp
80104427:	31 c0                	xor    %eax,%eax
}
80104429:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010442c:	5b                   	pop    %ebx
8010442d:	5e                   	pop    %esi
8010442e:	5d                   	pop    %ebp
8010442f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104430:	83 ec 04             	sub    $0x4,%esp
80104433:	01 c6                	add    %eax,%esi
80104435:	56                   	push   %esi
80104436:	50                   	push   %eax
80104437:	ff 73 04             	pushl  0x4(%ebx)
8010443a:	e8 21 3a 00 00       	call   80107e60 <allocuvm>
8010443f:	83 c4 10             	add    $0x10,%esp
80104442:	85 c0                	test   %eax,%eax
80104444:	75 d3                	jne    80104419 <growproc+0x29>
      return -1;
80104446:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010444b:	eb dc                	jmp    80104429 <growproc+0x39>
8010444d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("growproc: n < 0\n");
80104450:	83 ec 0c             	sub    $0xc,%esp
80104453:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104456:	68 ea 95 10 80       	push   $0x801095ea
8010445b:	e8 00 c2 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104463:	83 c4 0c             	add    $0xc,%esp
80104466:	01 c6                	add    %eax,%esi
80104468:	56                   	push   %esi
80104469:	50                   	push   %eax
8010446a:	ff 73 04             	pushl  0x4(%ebx)
8010446d:	e8 ce 37 00 00       	call   80107c40 <deallocuvm>
80104472:	83 c4 10             	add    $0x10,%esp
80104475:	85 c0                	test   %eax,%eax
80104477:	75 a0                	jne    80104419 <growproc+0x29>
80104479:	eb cb                	jmp    80104446 <growproc+0x56>
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <fork>:
{ 
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	53                   	push   %ebx
80104486:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010448c:	e8 8f 0c 00 00       	call   80105120 <pushcli>
  c = mycpu();
80104491:	e8 9a fd ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104496:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010449c:	e8 bf 0c 00 00       	call   80105160 <popcli>
  if((np = allocproc()) == 0){
801044a1:	e8 1a fb ff ff       	call   80103fc0 <allocproc>
801044a6:	85 c0                	test   %eax,%eax
801044a8:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
801044ae:	0f 84 f9 01 00 00    	je     801046ad <fork+0x22d>
  if(curproc->pid <= 2) // init, shell
801044b4:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801044b8:	89 c7                	mov    %eax,%edi
801044ba:	8b 13                	mov    (%ebx),%edx
801044bc:	8b 43 04             	mov    0x4(%ebx),%eax
801044bf:	0f 8e d3 01 00 00    	jle    80104698 <fork+0x218>
    np->pgdir = cowuvm(curproc->pgdir, curproc->sz);
801044c5:	83 ec 08             	sub    $0x8,%esp
801044c8:	52                   	push   %edx
801044c9:	50                   	push   %eax
801044ca:	e8 b1 3c 00 00       	call   80108180 <cowuvm>
801044cf:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801044d5:	83 c4 10             	add    $0x10,%esp
801044d8:	89 41 04             	mov    %eax,0x4(%ecx)
  if(np->pgdir == 0){
801044db:	85 c0                	test   %eax,%eax
801044dd:	0f 84 d1 01 00 00    	je     801046b4 <fork+0x234>
  np->sz = curproc->sz;
801044e3:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801044e9:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801044eb:	8b 79 18             	mov    0x18(%ecx),%edi
  np->sz = curproc->sz;
801044ee:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801044f0:	89 c8                	mov    %ecx,%eax
801044f2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801044f5:	b9 13 00 00 00       	mov    $0x13,%ecx
801044fa:	8b 73 18             	mov    0x18(%ebx),%esi
801044fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801044ff:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104503:	0f 8e 04 01 00 00    	jle    8010460d <fork+0x18d>
    np->totalPgfltCount = 0;
80104509:	89 c7                	mov    %eax,%edi
8010450b:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
80104512:	00 00 00 
    np->totalPgoutCount = 0;
80104515:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
8010451c:	00 00 00 
    np->num_ram = curproc->num_ram;
8010451f:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
80104525:	8d 93 90 00 00 00    	lea    0x90(%ebx),%edx
        np->ramPages[i].pgdir = np->pgdir;
8010452b:	8b 4f 04             	mov    0x4(%edi),%ecx
    np->num_ram = curproc->num_ram;
8010452e:	89 87 08 04 00 00    	mov    %eax,0x408(%edi)
    np->num_swap = curproc->num_swap;
80104534:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
8010453a:	89 87 0c 04 00 00    	mov    %eax,0x40c(%edi)
80104540:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
80104546:	81 c7 48 02 00 00    	add    $0x248,%edi
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        np->ramPages[i].isused = 1;
80104550:	c7 80 c4 01 00 00 01 	movl   $0x1,0x1c4(%eax)
80104557:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010455a:	8b b2 c0 01 00 00    	mov    0x1c0(%edx),%esi
80104560:	83 c0 1c             	add    $0x1c,%eax
        np->ramPages[i].pgdir = np->pgdir;
80104563:	89 88 a4 01 00 00    	mov    %ecx,0x1a4(%eax)
80104569:	83 c2 1c             	add    $0x1c,%edx
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010456c:	89 b0 ac 01 00 00    	mov    %esi,0x1ac(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104572:	8b b2 ac 01 00 00    	mov    0x1ac(%edx),%esi
      np->swappedPages[i].isused = 1;
80104578:	c7 40 e8 01 00 00 00 	movl   $0x1,-0x18(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
8010457f:	89 b0 b4 01 00 00    	mov    %esi,0x1b4(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104585:	8b 72 e4             	mov    -0x1c(%edx),%esi
      np->swappedPages[i].pgdir = np->pgdir;
80104588:	89 48 e4             	mov    %ecx,-0x1c(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
8010458b:	89 70 ec             	mov    %esi,-0x14(%eax)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
8010458e:	8b 72 e8             	mov    -0x18(%edx),%esi
80104591:	89 70 f0             	mov    %esi,-0x10(%eax)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
80104594:	8b 72 ec             	mov    -0x14(%edx),%esi
80104597:	89 70 f4             	mov    %esi,-0xc(%eax)
    for(i = 0; i < MAX_PSYC_PAGES; i++)
8010459a:	39 f8                	cmp    %edi,%eax
8010459c:	75 b2                	jne    80104550 <fork+0xd0>
      char buffer[PGSIZE / 2] = "";
8010459e:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
801045a4:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
801045a9:	31 c0                	xor    %eax,%eax
801045ab:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
801045b2:	00 00 00 
      int offset = 0;
801045b5:	31 f6                	xor    %esi,%esi
801045b7:	89 9d e0 f7 ff ff    	mov    %ebx,-0x820(%ebp)
      char buffer[PGSIZE / 2] = "";
801045bd:	f3 ab                	rep stos %eax,%es:(%edi)
801045bf:	8d bd e8 f7 ff ff    	lea    -0x818(%ebp),%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801045c5:	eb 25                	jmp    801045ec <fork+0x16c>
801045c7:	89 f6                	mov    %esi,%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
801045d0:	53                   	push   %ebx
801045d1:	56                   	push   %esi
801045d2:	57                   	push   %edi
801045d3:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
801045d9:	e8 22 e0 ff ff       	call   80102600 <writeToSwapFile>
801045de:	83 c4 10             	add    $0x10,%esp
801045e1:	83 f8 ff             	cmp    $0xffffffff,%eax
801045e4:	0f 84 f3 00 00 00    	je     801046dd <fork+0x25d>
        offset += nread;
801045ea:	01 de                	add    %ebx,%esi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801045ec:	68 00 08 00 00       	push   $0x800
801045f1:	56                   	push   %esi
801045f2:	57                   	push   %edi
801045f3:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
801045f9:	e8 32 e0 ff ff       	call   80102630 <readFromSwapFile>
801045fe:	83 c4 10             	add    $0x10,%esp
80104601:	85 c0                	test   %eax,%eax
80104603:	89 c3                	mov    %eax,%ebx
80104605:	75 c9                	jne    801045d0 <fork+0x150>
80104607:	8b 9d e0 f7 ff ff    	mov    -0x820(%ebp),%ebx
  np->tf->eax = 0;
8010460d:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
80104613:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104615:	8b 47 18             	mov    0x18(%edi),%eax
80104618:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
8010461f:	90                   	nop
    if(curproc->ofile[i])
80104620:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104624:	85 c0                	test   %eax,%eax
80104626:	74 10                	je     80104638 <fork+0x1b8>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	50                   	push   %eax
8010462c:	e8 6f cb ff ff       	call   801011a0 <filedup>
80104631:	83 c4 10             	add    $0x10,%esp
80104634:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104638:	83 c6 01             	add    $0x1,%esi
8010463b:	83 fe 10             	cmp    $0x10,%esi
8010463e:	75 e0                	jne    80104620 <fork+0x1a0>
  np->cwd = idup(curproc->cwd);
80104640:	83 ec 0c             	sub    $0xc,%esp
80104643:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104646:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104649:	e8 b2 d3 ff ff       	call   80101a00 <idup>
8010464e:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104654:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104657:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010465a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010465d:	6a 10                	push   $0x10
8010465f:	53                   	push   %ebx
80104660:	50                   	push   %eax
80104661:	e8 7a 0e 00 00       	call   801054e0 <safestrcpy>
  pid = np->pid;
80104666:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104669:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104670:	e8 7b 0b 00 00       	call   801051f0 <acquire>
  np->state = RUNNABLE;
80104675:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010467c:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104683:	e8 28 0c 00 00       	call   801052b0 <release>
  return pid;
80104688:	83 c4 10             	add    $0x10,%esp
}
8010468b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010468e:	89 d8                	mov    %ebx,%eax
80104690:	5b                   	pop    %ebx
80104691:	5e                   	pop    %esi
80104692:	5f                   	pop    %edi
80104693:	5d                   	pop    %ebp
80104694:	c3                   	ret    
80104695:	8d 76 00             	lea    0x0(%esi),%esi
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104698:	83 ec 08             	sub    $0x8,%esp
8010469b:	52                   	push   %edx
8010469c:	50                   	push   %eax
8010469d:	e8 0e 41 00 00       	call   801087b0 <copyuvm>
801046a2:	83 c4 10             	add    $0x10,%esp
801046a5:	89 47 04             	mov    %eax,0x4(%edi)
801046a8:	e9 2e fe ff ff       	jmp    801044db <fork+0x5b>
    return -1;
801046ad:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046b2:	eb d7                	jmp    8010468b <fork+0x20b>
    kfree(np->kstack);
801046b4:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
801046ba:	83 ec 0c             	sub    $0xc,%esp
801046bd:	ff 73 08             	pushl  0x8(%ebx)
801046c0:	e8 8b e3 ff ff       	call   80102a50 <kfree>
    np->kstack = 0;
801046c5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801046cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801046d3:	83 c4 10             	add    $0x10,%esp
801046d6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046db:	eb ae                	jmp    8010468b <fork+0x20b>
          panic("fork: error copying parent's swap file");
801046dd:	83 ec 0c             	sub    $0xc,%esp
801046e0:	68 cc 96 10 80       	push   $0x801096cc
801046e5:	e8 a6 bc ff ff       	call   80100390 <panic>
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046f0 <copyAQ>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	56                   	push   %esi
801046f5:	53                   	push   %ebx
801046f6:	83 ec 0c             	sub    $0xc,%esp
801046f9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801046fc:	e8 1f 0a 00 00       	call   80105120 <pushcli>
  c = mycpu();
80104701:	e8 2a fb ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104706:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010470c:	e8 4f 0a 00 00       	call   80105160 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
80104711:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
80104717:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
8010471e:	00 00 00 
  np->queue_tail = 0;
80104721:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
80104728:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
8010472b:	85 db                	test   %ebx,%ebx
8010472d:	74 4f                	je     8010477e <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
8010472f:	e8 0c e6 ff ff       	call   80102d40 <kalloc>
80104734:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
80104736:	8b 43 08             	mov    0x8(%ebx),%eax
80104739:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
8010473c:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
80104742:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
80104749:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
8010474b:	85 db                	test   %ebx,%ebx
8010474d:	74 37                	je     80104786 <copyAQ+0x96>
8010474f:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
80104750:	e8 eb e5 ff ff       	call   80102d40 <kalloc>
    np_curr->page_index = old_curr->page_index;
80104755:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
80104758:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
8010475b:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
8010475e:	89 07                	mov    %eax,(%edi)
80104760:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
80104762:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
80104764:	85 db                	test   %ebx,%ebx
80104766:	75 e8                	jne    80104750 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
80104768:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
8010476e:	85 d2                	test   %edx,%edx
80104770:	74 0c                	je     8010477e <copyAQ+0x8e>
    np_curr->next = 0;
80104772:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104778:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
8010477e:	83 c4 0c             	add    $0xc,%esp
80104781:	5b                   	pop    %ebx
80104782:	5e                   	pop    %esi
80104783:	5f                   	pop    %edi
80104784:	5d                   	pop    %ebp
80104785:	c3                   	ret    
  while(old_curr != 0)
80104786:	89 f8                	mov    %edi,%eax
80104788:	eb de                	jmp    80104768 <copyAQ+0x78>
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <scheduler>:
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	53                   	push   %ebx
80104796:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104799:	e8 92 fa ff ff       	call   80104230 <mycpu>
8010479e:	8d 78 04             	lea    0x4(%eax),%edi
801047a1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801047a3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047aa:	00 00 00 
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801047b0:	fb                   	sti    
    acquire(&ptable.lock);
801047b1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047b4:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
801047b9:	68 00 61 18 80       	push   $0x80186100
801047be:	e8 2d 0a 00 00       	call   801051f0 <acquire>
801047c3:	83 c4 10             	add    $0x10,%esp
801047c6:	8d 76 00             	lea    0x0(%esi),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801047d0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801047d4:	75 33                	jne    80104809 <scheduler+0x79>
      switchuvm(p);
801047d6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801047d9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801047df:	53                   	push   %ebx
801047e0:	e8 cb 2f 00 00       	call   801077b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
801047e5:	58                   	pop    %eax
801047e6:	5a                   	pop    %edx
801047e7:	ff 73 1c             	pushl  0x1c(%ebx)
801047ea:	57                   	push   %edi
      p->state = RUNNING;
801047eb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801047f2:	e8 44 0d 00 00       	call   8010553b <swtch>
      switchkvm();
801047f7:	e8 94 2f 00 00       	call   80107790 <switchkvm>
      c->proc = 0;
801047fc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104803:	00 00 00 
80104806:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104809:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010480f:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104815:	72 b9                	jb     801047d0 <scheduler+0x40>
    release(&ptable.lock);
80104817:	83 ec 0c             	sub    $0xc,%esp
8010481a:	68 00 61 18 80       	push   $0x80186100
8010481f:	e8 8c 0a 00 00       	call   801052b0 <release>
    sti();
80104824:	83 c4 10             	add    $0x10,%esp
80104827:	eb 87                	jmp    801047b0 <scheduler+0x20>
80104829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104830 <sched>:
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
  pushcli();
80104835:	e8 e6 08 00 00       	call   80105120 <pushcli>
  c = mycpu();
8010483a:	e8 f1 f9 ff ff       	call   80104230 <mycpu>
  p = c->proc;
8010483f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104845:	e8 16 09 00 00       	call   80105160 <popcli>
  if(!holding(&ptable.lock))
8010484a:	83 ec 0c             	sub    $0xc,%esp
8010484d:	68 00 61 18 80       	push   $0x80186100
80104852:	e8 69 09 00 00       	call   801051c0 <holding>
80104857:	83 c4 10             	add    $0x10,%esp
8010485a:	85 c0                	test   %eax,%eax
8010485c:	74 4f                	je     801048ad <sched+0x7d>
  if(mycpu()->ncli != 1)
8010485e:	e8 cd f9 ff ff       	call   80104230 <mycpu>
80104863:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010486a:	75 68                	jne    801048d4 <sched+0xa4>
  if(p->state == RUNNING)
8010486c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104870:	74 55                	je     801048c7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104872:	9c                   	pushf  
80104873:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104874:	f6 c4 02             	test   $0x2,%ah
80104877:	75 41                	jne    801048ba <sched+0x8a>
  intena = mycpu()->intena;
80104879:	e8 b2 f9 ff ff       	call   80104230 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010487e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104881:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104887:	e8 a4 f9 ff ff       	call   80104230 <mycpu>
8010488c:	83 ec 08             	sub    $0x8,%esp
8010488f:	ff 70 04             	pushl  0x4(%eax)
80104892:	53                   	push   %ebx
80104893:	e8 a3 0c 00 00       	call   8010553b <swtch>
  mycpu()->intena = intena;
80104898:	e8 93 f9 ff ff       	call   80104230 <mycpu>
}
8010489d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048a0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048a9:	5b                   	pop    %ebx
801048aa:	5e                   	pop    %esi
801048ab:	5d                   	pop    %ebp
801048ac:	c3                   	ret    
    panic("sched ptable.lock");
801048ad:	83 ec 0c             	sub    $0xc,%esp
801048b0:	68 fb 95 10 80       	push   $0x801095fb
801048b5:	e8 d6 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801048ba:	83 ec 0c             	sub    $0xc,%esp
801048bd:	68 27 96 10 80       	push   $0x80109627
801048c2:	e8 c9 ba ff ff       	call   80100390 <panic>
    panic("sched running");
801048c7:	83 ec 0c             	sub    $0xc,%esp
801048ca:	68 19 96 10 80       	push   $0x80109619
801048cf:	e8 bc ba ff ff       	call   80100390 <panic>
    panic("sched locks");
801048d4:	83 ec 0c             	sub    $0xc,%esp
801048d7:	68 0d 96 10 80       	push   $0x8010960d
801048dc:	e8 af ba ff ff       	call   80100390 <panic>
801048e1:	eb 0d                	jmp    801048f0 <exit>
801048e3:	90                   	nop
801048e4:	90                   	nop
801048e5:	90                   	nop
801048e6:	90                   	nop
801048e7:	90                   	nop
801048e8:	90                   	nop
801048e9:	90                   	nop
801048ea:	90                   	nop
801048eb:	90                   	nop
801048ec:	90                   	nop
801048ed:	90                   	nop
801048ee:	90                   	nop
801048ef:	90                   	nop

801048f0 <exit>:
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	57                   	push   %edi
801048f4:	56                   	push   %esi
801048f5:	53                   	push   %ebx
801048f6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801048f9:	e8 22 08 00 00       	call   80105120 <pushcli>
  c = mycpu();
801048fe:	e8 2d f9 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104903:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104909:	e8 52 08 00 00       	call   80105160 <popcli>
  if(curproc == initproc)
8010490e:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
80104914:	8d 73 28             	lea    0x28(%ebx),%esi
80104917:	8d 7b 68             	lea    0x68(%ebx),%edi
8010491a:	0f 84 22 01 00 00    	je     80104a42 <exit+0x152>
    if(curproc->ofile[fd]){
80104920:	8b 06                	mov    (%esi),%eax
80104922:	85 c0                	test   %eax,%eax
80104924:	74 12                	je     80104938 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104926:	83 ec 0c             	sub    $0xc,%esp
80104929:	50                   	push   %eax
8010492a:	e8 c1 c8 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
8010492f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104935:	83 c4 10             	add    $0x10,%esp
80104938:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010493b:	39 fe                	cmp    %edi,%esi
8010493d:	75 e1                	jne    80104920 <exit+0x30>
  begin_op();
8010493f:	e8 1c ec ff ff       	call   80103560 <begin_op>
  iput(curproc->cwd);
80104944:	83 ec 0c             	sub    $0xc,%esp
80104947:	ff 73 68             	pushl  0x68(%ebx)
8010494a:	e8 11 d2 ff ff       	call   80101b60 <iput>
  end_op();
8010494f:	e8 7c ec ff ff       	call   801035d0 <end_op>
  if(curproc->pid > 2) {
80104954:	83 c4 10             	add    $0x10,%esp
80104957:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
8010495b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
80104962:	0f 8f b9 00 00 00    	jg     80104a21 <exit+0x131>
  acquire(&ptable.lock);
80104968:	83 ec 0c             	sub    $0xc,%esp
8010496b:	68 00 61 18 80       	push   $0x80186100
80104970:	e8 7b 08 00 00       	call   801051f0 <acquire>
  wakeup1(curproc->parent);
80104975:	8b 53 14             	mov    0x14(%ebx),%edx
80104978:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010497b:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104980:	eb 12                	jmp    80104994 <exit+0xa4>
80104982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104988:	05 30 04 00 00       	add    $0x430,%eax
8010498d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104992:	73 1e                	jae    801049b2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104994:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104998:	75 ee                	jne    80104988 <exit+0x98>
8010499a:	3b 50 20             	cmp    0x20(%eax),%edx
8010499d:	75 e9                	jne    80104988 <exit+0x98>
      p->state = RUNNABLE;
8010499f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049a6:	05 30 04 00 00       	add    $0x430,%eax
801049ab:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049b0:	72 e2                	jb     80104994 <exit+0xa4>
      p->parent = initproc;
801049b2:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049b8:	ba 34 61 18 80       	mov    $0x80186134,%edx
801049bd:	eb 0f                	jmp    801049ce <exit+0xde>
801049bf:	90                   	nop
801049c0:	81 c2 30 04 00 00    	add    $0x430,%edx
801049c6:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
801049cc:	73 3a                	jae    80104a08 <exit+0x118>
    if(p->parent == curproc){
801049ce:	39 5a 14             	cmp    %ebx,0x14(%edx)
801049d1:	75 ed                	jne    801049c0 <exit+0xd0>
      if(p->state == ZOMBIE)
801049d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801049d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801049da:	75 e4                	jne    801049c0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049dc:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049e1:	eb 11                	jmp    801049f4 <exit+0x104>
801049e3:	90                   	nop
801049e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049e8:	05 30 04 00 00       	add    $0x430,%eax
801049ed:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049f2:	73 cc                	jae    801049c0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801049f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049f8:	75 ee                	jne    801049e8 <exit+0xf8>
801049fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801049fd:	75 e9                	jne    801049e8 <exit+0xf8>
      p->state = RUNNABLE;
801049ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a06:	eb e0                	jmp    801049e8 <exit+0xf8>
  curproc->state = ZOMBIE;
80104a08:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104a0f:	e8 1c fe ff ff       	call   80104830 <sched>
  panic("zombie exit");
80104a14:	83 ec 0c             	sub    $0xc,%esp
80104a17:	68 48 96 10 80       	push   $0x80109648
80104a1c:	e8 6f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a21:	83 ec 0c             	sub    $0xc,%esp
80104a24:	53                   	push   %ebx
80104a25:	e8 36 d9 ff ff       	call   80102360 <removeSwapFile>
80104a2a:	83 c4 10             	add    $0x10,%esp
80104a2d:	85 c0                	test   %eax,%eax
80104a2f:	0f 84 33 ff ff ff    	je     80104968 <exit+0x78>
      panic("exit: error deleting swap file");
80104a35:	83 ec 0c             	sub    $0xc,%esp
80104a38:	68 f4 96 10 80       	push   $0x801096f4
80104a3d:	e8 4e b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a42:	83 ec 0c             	sub    $0xc,%esp
80104a45:	68 3b 96 10 80       	push   $0x8010963b
80104a4a:	e8 41 b9 ff ff       	call   80100390 <panic>
80104a4f:	90                   	nop

80104a50 <yield>:
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	53                   	push   %ebx
80104a54:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a57:	68 00 61 18 80       	push   $0x80186100
80104a5c:	e8 8f 07 00 00       	call   801051f0 <acquire>
  pushcli();
80104a61:	e8 ba 06 00 00       	call   80105120 <pushcli>
  c = mycpu();
80104a66:	e8 c5 f7 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104a6b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a71:	e8 ea 06 00 00       	call   80105160 <popcli>
  myproc()->state = RUNNABLE;
80104a76:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104a7d:	e8 ae fd ff ff       	call   80104830 <sched>
  release(&ptable.lock);
80104a82:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104a89:	e8 22 08 00 00       	call   801052b0 <release>
}
80104a8e:	83 c4 10             	add    $0x10,%esp
80104a91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a94:	c9                   	leave  
80104a95:	c3                   	ret    
80104a96:	8d 76 00             	lea    0x0(%esi),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <sleep>:
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	56                   	push   %esi
80104aa5:	53                   	push   %ebx
80104aa6:	83 ec 0c             	sub    $0xc,%esp
80104aa9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104aac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104aaf:	e8 6c 06 00 00       	call   80105120 <pushcli>
  c = mycpu();
80104ab4:	e8 77 f7 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104ab9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104abf:	e8 9c 06 00 00       	call   80105160 <popcli>
  if(p == 0)
80104ac4:	85 db                	test   %ebx,%ebx
80104ac6:	0f 84 87 00 00 00    	je     80104b53 <sleep+0xb3>
  if(lk == 0)
80104acc:	85 f6                	test   %esi,%esi
80104ace:	74 76                	je     80104b46 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ad0:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104ad6:	74 50                	je     80104b28 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ad8:	83 ec 0c             	sub    $0xc,%esp
80104adb:	68 00 61 18 80       	push   $0x80186100
80104ae0:	e8 0b 07 00 00       	call   801051f0 <acquire>
    release(lk);
80104ae5:	89 34 24             	mov    %esi,(%esp)
80104ae8:	e8 c3 07 00 00       	call   801052b0 <release>
  p->chan = chan;
80104aed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104af0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104af7:	e8 34 fd ff ff       	call   80104830 <sched>
  p->chan = 0;
80104afc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b03:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104b0a:	e8 a1 07 00 00       	call   801052b0 <release>
    acquire(lk);
80104b0f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b12:	83 c4 10             	add    $0x10,%esp
}
80104b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b18:	5b                   	pop    %ebx
80104b19:	5e                   	pop    %esi
80104b1a:	5f                   	pop    %edi
80104b1b:	5d                   	pop    %ebp
    acquire(lk);
80104b1c:	e9 cf 06 00 00       	jmp    801051f0 <acquire>
80104b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b28:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b2b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b32:	e8 f9 fc ff ff       	call   80104830 <sched>
  p->chan = 0;
80104b37:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b41:	5b                   	pop    %ebx
80104b42:	5e                   	pop    %esi
80104b43:	5f                   	pop    %edi
80104b44:	5d                   	pop    %ebp
80104b45:	c3                   	ret    
    panic("sleep without lk");
80104b46:	83 ec 0c             	sub    $0xc,%esp
80104b49:	68 5a 96 10 80       	push   $0x8010965a
80104b4e:	e8 3d b8 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b53:	83 ec 0c             	sub    $0xc,%esp
80104b56:	68 54 96 10 80       	push   $0x80109654
80104b5b:	e8 30 b8 ff ff       	call   80100390 <panic>

80104b60 <wait>:
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	56                   	push   %esi
80104b64:	53                   	push   %ebx
  pushcli();
80104b65:	e8 b6 05 00 00       	call   80105120 <pushcli>
  c = mycpu();
80104b6a:	e8 c1 f6 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104b6f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b75:	e8 e6 05 00 00       	call   80105160 <popcli>
  acquire(&ptable.lock);
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	68 00 61 18 80       	push   $0x80186100
80104b82:	e8 69 06 00 00       	call   801051f0 <acquire>
80104b87:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b8a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b8c:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104b91:	eb 13                	jmp    80104ba6 <wait+0x46>
80104b93:	90                   	nop
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b98:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104b9e:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104ba4:	73 1e                	jae    80104bc4 <wait+0x64>
      if(p->parent != curproc)
80104ba6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104ba9:	75 ed                	jne    80104b98 <wait+0x38>
      if(p->state == ZOMBIE){
80104bab:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104baf:	74 3f                	je     80104bf0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb1:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104bb7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bbc:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104bc2:	72 e2                	jb     80104ba6 <wait+0x46>
    if(!havekids || curproc->killed){
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	0f 84 f3 00 00 00    	je     80104cbf <wait+0x15f>
80104bcc:	8b 46 24             	mov    0x24(%esi),%eax
80104bcf:	85 c0                	test   %eax,%eax
80104bd1:	0f 85 e8 00 00 00    	jne    80104cbf <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104bd7:	83 ec 08             	sub    $0x8,%esp
80104bda:	68 00 61 18 80       	push   $0x80186100
80104bdf:	56                   	push   %esi
80104be0:	e8 bb fe ff ff       	call   80104aa0 <sleep>
    havekids = 0;
80104be5:	83 c4 10             	add    $0x10,%esp
80104be8:	eb a0                	jmp    80104b8a <wait+0x2a>
80104bea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104bf0:	83 ec 0c             	sub    $0xc,%esp
80104bf3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104bf6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104bf9:	e8 52 de ff ff       	call   80102a50 <kfree>
        freevm(p->pgdir); // panic: kfree
80104bfe:	5a                   	pop    %edx
80104bff:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c02:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104c09:	e8 e2 33 00 00       	call   80107ff0 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c0e:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104c14:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104c17:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c1e:	68 c0 01 00 00       	push   $0x1c0
80104c23:	6a 00                	push   $0x0
80104c25:	50                   	push   %eax
        p->parent = 0;
80104c26:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c2d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c31:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c38:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c3f:	00 00 00 
        p->swapFile = 0;
80104c42:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104c49:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104c50:	00 00 00 
        p->free_tail = 0;
80104c53:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104c5a:	00 00 00 
        p->queue_head = 0;
80104c5d:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104c64:	00 00 00 
        p->queue_tail = 0;
80104c67:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104c6e:	00 00 00 
        p->numswappages = 0;
80104c71:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104c78:	00 00 00 
        p-> nummemorypages = 0;
80104c7b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104c82:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c85:	e8 76 06 00 00       	call   80105300 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104c8a:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104c90:	83 c4 0c             	add    $0xc,%esp
80104c93:	68 c0 01 00 00       	push   $0x1c0
80104c98:	6a 00                	push   $0x0
80104c9a:	50                   	push   %eax
80104c9b:	e8 60 06 00 00       	call   80105300 <memset>
        release(&ptable.lock);
80104ca0:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104ca7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104cae:	e8 fd 05 00 00       	call   801052b0 <release>
        return pid;
80104cb3:	83 c4 10             	add    $0x10,%esp
}
80104cb6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cb9:	89 f0                	mov    %esi,%eax
80104cbb:	5b                   	pop    %ebx
80104cbc:	5e                   	pop    %esi
80104cbd:	5d                   	pop    %ebp
80104cbe:	c3                   	ret    
      release(&ptable.lock);
80104cbf:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104cc2:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104cc7:	68 00 61 18 80       	push   $0x80186100
80104ccc:	e8 df 05 00 00       	call   801052b0 <release>
      return -1;
80104cd1:	83 c4 10             	add    $0x10,%esp
80104cd4:	eb e0                	jmp    80104cb6 <wait+0x156>
80104cd6:	8d 76 00             	lea    0x0(%esi),%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	53                   	push   %ebx
80104ce4:	83 ec 10             	sub    $0x10,%esp
80104ce7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104cea:	68 00 61 18 80       	push   $0x80186100
80104cef:	e8 fc 04 00 00       	call   801051f0 <acquire>
80104cf4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cf7:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104cfc:	eb 0e                	jmp    80104d0c <wakeup+0x2c>
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	05 30 04 00 00       	add    $0x430,%eax
80104d05:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d0a:	73 1e                	jae    80104d2a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d0c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d10:	75 ee                	jne    80104d00 <wakeup+0x20>
80104d12:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d15:	75 e9                	jne    80104d00 <wakeup+0x20>
      p->state = RUNNABLE;
80104d17:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d1e:	05 30 04 00 00       	add    $0x430,%eax
80104d23:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d28:	72 e2                	jb     80104d0c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d2a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d34:	c9                   	leave  
  release(&ptable.lock);
80104d35:	e9 76 05 00 00       	jmp    801052b0 <release>
80104d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 10             	sub    $0x10,%esp
80104d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d4a:	68 00 61 18 80       	push   $0x80186100
80104d4f:	e8 9c 04 00 00       	call   801051f0 <acquire>
80104d54:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d57:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d5c:	eb 0e                	jmp    80104d6c <kill+0x2c>
80104d5e:	66 90                	xchg   %ax,%ax
80104d60:	05 30 04 00 00       	add    $0x430,%eax
80104d65:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d6a:	73 34                	jae    80104da0 <kill+0x60>
    if(p->pid == pid){
80104d6c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d6f:	75 ef                	jne    80104d60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d71:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104d75:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104d7c:	75 07                	jne    80104d85 <kill+0x45>
        p->state = RUNNABLE;
80104d7e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d85:	83 ec 0c             	sub    $0xc,%esp
80104d88:	68 00 61 18 80       	push   $0x80186100
80104d8d:	e8 1e 05 00 00       	call   801052b0 <release>
      return 0;
80104d92:	83 c4 10             	add    $0x10,%esp
80104d95:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104d97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d9a:	c9                   	leave  
80104d9b:	c3                   	ret    
80104d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104da0:	83 ec 0c             	sub    $0xc,%esp
80104da3:	68 00 61 18 80       	push   $0x80186100
80104da8:	e8 03 05 00 00       	call   801052b0 <release>
  return -1;
80104dad:	83 c4 10             	add    $0x10,%esp
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104db5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104db8:	c9                   	leave  
80104db9:	c3                   	ret    
80104dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104dc0 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104dc4:	31 db                	xor    %ebx,%ebx
{
80104dc6:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104dc9:	68 00 61 18 80       	push   $0x80186100
80104dce:	e8 1d 04 00 00       	call   801051f0 <acquire>
80104dd3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104dd6:	ba 34 61 18 80       	mov    $0x80186134,%edx
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104ddb:	b9 10 00 00 00       	mov    $0x10,%ecx
    if(p->state == UNUSED)
80104de0:	8b 42 0c             	mov    0xc(%edx),%eax
80104de3:	85 c0                	test   %eax,%eax
80104de5:	74 0a                	je     80104df1 <getCurrentFreePages+0x31>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104de7:	89 c8                	mov    %ecx,%eax
80104de9:	2b 82 08 04 00 00    	sub    0x408(%edx),%eax
80104def:	01 c3                	add    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104df1:	81 c2 30 04 00 00    	add    $0x430,%edx
80104df7:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104dfd:	72 e1                	jb     80104de0 <getCurrentFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	68 00 61 18 80       	push   $0x80186100
80104e07:	e8 a4 04 00 00       	call   801052b0 <release>
  return sum;
}
80104e0c:	89 d8                	mov    %ebx,%eax
80104e0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e11:	c9                   	leave  
80104e12:	c3                   	ret    
80104e13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80104e24:	31 db                	xor    %ebx,%ebx
{
80104e26:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e29:	68 00 61 18 80       	push   $0x80186100
80104e2e:	e8 bd 03 00 00       	call   801051f0 <acquire>
80104e33:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e36:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104e3b:	90                   	nop
80104e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80104e40:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104e44:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e47:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e4d:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e53:	72 eb                	jb     80104e40 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80104e55:	83 ec 0c             	sub    $0xc,%esp
80104e58:	68 00 61 18 80       	push   $0x80186100
80104e5d:	e8 4e 04 00 00       	call   801052b0 <release>
  return pcount * MAX_PSYC_PAGES;
80104e62:	89 d8                	mov    %ebx,%eax
80104e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return pcount * MAX_PSYC_PAGES;
80104e67:	c1 e0 04             	shl    $0x4,%eax
80104e6a:	c9                   	leave  
80104e6b:	c3                   	ret    
80104e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e70 <procdump>:
{
80104e70:	55                   	push   %ebp
80104e71:	89 e5                	mov    %esp,%ebp
80104e73:	57                   	push   %edi
80104e74:	56                   	push   %esi
80104e75:	53                   	push   %ebx
80104e76:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e79:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104e7e:	83 ec 3c             	sub    $0x3c,%esp
80104e81:	eb 41                	jmp    80104ec4 <procdump+0x54>
80104e83:	90                   	nop
80104e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80104e88:	e8 93 ff ff ff       	call   80104e20 <getTotalFreePages>
80104e8d:	89 c7                	mov    %eax,%edi
80104e8f:	e8 2c ff ff ff       	call   80104dc0 <getCurrentFreePages>
80104e94:	83 ec 04             	sub    $0x4,%esp
80104e97:	57                   	push   %edi
80104e98:	50                   	push   %eax
80104e99:	68 6f 96 10 80       	push   $0x8010966f
80104e9e:	e8 bd b7 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104ea3:	c7 04 24 40 9b 10 80 	movl   $0x80109b40,(%esp)
80104eaa:	e8 b1 b7 ff ff       	call   80100660 <cprintf>
80104eaf:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eb2:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104eb8:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104ebe:	0f 83 ac 00 00 00    	jae    80104f70 <procdump+0x100>
    if(p->state == UNUSED)
80104ec4:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ec7:	85 c0                	test   %eax,%eax
80104ec9:	74 e7                	je     80104eb2 <procdump+0x42>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ecb:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104ece:	ba 6b 96 10 80       	mov    $0x8010966b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104ed3:	77 11                	ja     80104ee6 <procdump+0x76>
80104ed5:	8b 14 85 7c 97 10 80 	mov    -0x7fef6884(,%eax,4),%edx
      state = "???";
80104edc:	b8 6b 96 10 80       	mov    $0x8010966b,%eax
80104ee1:	85 d2                	test   %edx,%edx
80104ee3:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104ee6:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104ee9:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104eef:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104ef5:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104efb:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104f01:	50                   	push   %eax
80104f02:	52                   	push   %edx
80104f03:	ff 73 10             	pushl  0x10(%ebx)
80104f06:	68 14 97 10 80       	push   $0x80109714
80104f0b:	e8 50 b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104f10:	83 c4 20             	add    $0x20,%esp
80104f13:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104f17:	0f 85 6b ff ff ff    	jne    80104e88 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f1d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f20:	83 ec 08             	sub    $0x8,%esp
80104f23:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104f26:	50                   	push   %eax
80104f27:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f2a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f2d:	83 c0 08             	add    $0x8,%eax
80104f30:	50                   	push   %eax
80104f31:	e8 9a 01 00 00       	call   801050d0 <getcallerpcs>
80104f36:	83 c4 10             	add    $0x10,%esp
80104f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104f40:	8b 17                	mov    (%edi),%edx
80104f42:	85 d2                	test   %edx,%edx
80104f44:	0f 84 3e ff ff ff    	je     80104e88 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104f4a:	83 ec 08             	sub    $0x8,%esp
80104f4d:	83 c7 04             	add    $0x4,%edi
80104f50:	52                   	push   %edx
80104f51:	68 c1 8f 10 80       	push   $0x80108fc1
80104f56:	e8 05 b7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104f5b:	83 c4 10             	add    $0x10,%esp
80104f5e:	39 fe                	cmp    %edi,%esi
80104f60:	75 de                	jne    80104f40 <procdump+0xd0>
80104f62:	e9 21 ff ff ff       	jmp    80104e88 <procdump+0x18>
80104f67:	89 f6                	mov    %esi,%esi
80104f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f73:	5b                   	pop    %ebx
80104f74:	5e                   	pop    %esi
80104f75:	5f                   	pop    %edi
80104f76:	5d                   	pop    %ebp
80104f77:	c3                   	ret    
80104f78:	66 90                	xchg   %ax,%ax
80104f7a:	66 90                	xchg   %ax,%ax
80104f7c:	66 90                	xchg   %ax,%ax
80104f7e:	66 90                	xchg   %ax,%ax

80104f80 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	53                   	push   %ebx
80104f84:	83 ec 0c             	sub    $0xc,%esp
80104f87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104f8a:	68 94 97 10 80       	push   $0x80109794
80104f8f:	8d 43 04             	lea    0x4(%ebx),%eax
80104f92:	50                   	push   %eax
80104f93:	e8 18 01 00 00       	call   801050b0 <initlock>
  lk->name = name;
80104f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104f9b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104fa1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104fa4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104fab:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104fae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104fb1:	c9                   	leave  
80104fb2:	c3                   	ret    
80104fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
80104fc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104fc8:	83 ec 0c             	sub    $0xc,%esp
80104fcb:	8d 73 04             	lea    0x4(%ebx),%esi
80104fce:	56                   	push   %esi
80104fcf:	e8 1c 02 00 00       	call   801051f0 <acquire>
  while (lk->locked) {
80104fd4:	8b 13                	mov    (%ebx),%edx
80104fd6:	83 c4 10             	add    $0x10,%esp
80104fd9:	85 d2                	test   %edx,%edx
80104fdb:	74 16                	je     80104ff3 <acquiresleep+0x33>
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104fe0:	83 ec 08             	sub    $0x8,%esp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
80104fe5:	e8 b6 fa ff ff       	call   80104aa0 <sleep>
  while (lk->locked) {
80104fea:	8b 03                	mov    (%ebx),%eax
80104fec:	83 c4 10             	add    $0x10,%esp
80104fef:	85 c0                	test   %eax,%eax
80104ff1:	75 ed                	jne    80104fe0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104ff3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104ff9:	e8 d2 f2 ff ff       	call   801042d0 <myproc>
80104ffe:	8b 40 10             	mov    0x10(%eax),%eax
80105001:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105004:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105007:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010500a:	5b                   	pop    %ebx
8010500b:	5e                   	pop    %esi
8010500c:	5d                   	pop    %ebp
  release(&lk->lk);
8010500d:	e9 9e 02 00 00       	jmp    801052b0 <release>
80105012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
80105025:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105028:	83 ec 0c             	sub    $0xc,%esp
8010502b:	8d 73 04             	lea    0x4(%ebx),%esi
8010502e:	56                   	push   %esi
8010502f:	e8 bc 01 00 00       	call   801051f0 <acquire>
  lk->locked = 0;
80105034:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010503a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105041:	89 1c 24             	mov    %ebx,(%esp)
80105044:	e8 97 fc ff ff       	call   80104ce0 <wakeup>
  release(&lk->lk);
80105049:	89 75 08             	mov    %esi,0x8(%ebp)
8010504c:	83 c4 10             	add    $0x10,%esp
}
8010504f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105052:	5b                   	pop    %ebx
80105053:	5e                   	pop    %esi
80105054:	5d                   	pop    %ebp
  release(&lk->lk);
80105055:	e9 56 02 00 00       	jmp    801052b0 <release>
8010505a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105060 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
80105066:	31 ff                	xor    %edi,%edi
80105068:	83 ec 18             	sub    $0x18,%esp
8010506b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010506e:	8d 73 04             	lea    0x4(%ebx),%esi
80105071:	56                   	push   %esi
80105072:	e8 79 01 00 00       	call   801051f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105077:	8b 03                	mov    (%ebx),%eax
80105079:	83 c4 10             	add    $0x10,%esp
8010507c:	85 c0                	test   %eax,%eax
8010507e:	74 13                	je     80105093 <holdingsleep+0x33>
80105080:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105083:	e8 48 f2 ff ff       	call   801042d0 <myproc>
80105088:	39 58 10             	cmp    %ebx,0x10(%eax)
8010508b:	0f 94 c0             	sete   %al
8010508e:	0f b6 c0             	movzbl %al,%eax
80105091:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105093:	83 ec 0c             	sub    $0xc,%esp
80105096:	56                   	push   %esi
80105097:	e8 14 02 00 00       	call   801052b0 <release>
  return r;
}
8010509c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010509f:	89 f8                	mov    %edi,%eax
801050a1:	5b                   	pop    %ebx
801050a2:	5e                   	pop    %esi
801050a3:	5f                   	pop    %edi
801050a4:	5d                   	pop    %ebp
801050a5:	c3                   	ret    
801050a6:	66 90                	xchg   %ax,%ax
801050a8:	66 90                	xchg   %ax,%ax
801050aa:	66 90                	xchg   %ax,%ax
801050ac:	66 90                	xchg   %ax,%ax
801050ae:	66 90                	xchg   %ax,%ax

801050b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801050b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801050b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801050bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801050c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050c9:	5d                   	pop    %ebp
801050ca:	c3                   	ret    
801050cb:	90                   	nop
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801050d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050d1:	31 d2                	xor    %edx,%edx
{
801050d3:	89 e5                	mov    %esp,%ebp
801050d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801050d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801050d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801050dc:	83 e8 08             	sub    $0x8,%eax
801050df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801050e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050ec:	77 1a                	ja     80105108 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050ee:	8b 58 04             	mov    0x4(%eax),%ebx
801050f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801050f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801050f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050f9:	83 fa 0a             	cmp    $0xa,%edx
801050fc:	75 e2                	jne    801050e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801050fe:	5b                   	pop    %ebx
801050ff:	5d                   	pop    %ebp
80105100:	c3                   	ret    
80105101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105108:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010510b:	83 c1 28             	add    $0x28,%ecx
8010510e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105110:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105116:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105119:	39 c1                	cmp    %eax,%ecx
8010511b:	75 f3                	jne    80105110 <getcallerpcs+0x40>
}
8010511d:	5b                   	pop    %ebx
8010511e:	5d                   	pop    %ebp
8010511f:	c3                   	ret    

80105120 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	53                   	push   %ebx
80105124:	83 ec 04             	sub    $0x4,%esp
80105127:	9c                   	pushf  
80105128:	5b                   	pop    %ebx
  asm volatile("cli");
80105129:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010512a:	e8 01 f1 ff ff       	call   80104230 <mycpu>
8010512f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105135:	85 c0                	test   %eax,%eax
80105137:	75 11                	jne    8010514a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105139:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010513f:	e8 ec f0 ff ff       	call   80104230 <mycpu>
80105144:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010514a:	e8 e1 f0 ff ff       	call   80104230 <mycpu>
8010514f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105156:	83 c4 04             	add    $0x4,%esp
80105159:	5b                   	pop    %ebx
8010515a:	5d                   	pop    %ebp
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <popcli>:

void
popcli(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105166:	9c                   	pushf  
80105167:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105168:	f6 c4 02             	test   $0x2,%ah
8010516b:	75 35                	jne    801051a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010516d:	e8 be f0 ff ff       	call   80104230 <mycpu>
80105172:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105179:	78 34                	js     801051af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010517b:	e8 b0 f0 ff ff       	call   80104230 <mycpu>
80105180:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105186:	85 d2                	test   %edx,%edx
80105188:	74 06                	je     80105190 <popcli+0x30>
    sti();
}
8010518a:	c9                   	leave  
8010518b:	c3                   	ret    
8010518c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105190:	e8 9b f0 ff ff       	call   80104230 <mycpu>
80105195:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010519b:	85 c0                	test   %eax,%eax
8010519d:	74 eb                	je     8010518a <popcli+0x2a>
  asm volatile("sti");
8010519f:	fb                   	sti    
}
801051a0:	c9                   	leave  
801051a1:	c3                   	ret    
    panic("popcli - interruptible");
801051a2:	83 ec 0c             	sub    $0xc,%esp
801051a5:	68 9f 97 10 80       	push   $0x8010979f
801051aa:	e8 e1 b1 ff ff       	call   80100390 <panic>
    panic("popcli");
801051af:	83 ec 0c             	sub    $0xc,%esp
801051b2:	68 b6 97 10 80       	push   $0x801097b6
801051b7:	e8 d4 b1 ff ff       	call   80100390 <panic>
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <holding>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
801051c5:	8b 75 08             	mov    0x8(%ebp),%esi
801051c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801051ca:	e8 51 ff ff ff       	call   80105120 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051cf:	8b 06                	mov    (%esi),%eax
801051d1:	85 c0                	test   %eax,%eax
801051d3:	74 10                	je     801051e5 <holding+0x25>
801051d5:	8b 5e 08             	mov    0x8(%esi),%ebx
801051d8:	e8 53 f0 ff ff       	call   80104230 <mycpu>
801051dd:	39 c3                	cmp    %eax,%ebx
801051df:	0f 94 c3             	sete   %bl
801051e2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801051e5:	e8 76 ff ff ff       	call   80105160 <popcli>
}
801051ea:	89 d8                	mov    %ebx,%eax
801051ec:	5b                   	pop    %ebx
801051ed:	5e                   	pop    %esi
801051ee:	5d                   	pop    %ebp
801051ef:	c3                   	ret    

801051f0 <acquire>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	56                   	push   %esi
801051f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801051f5:	e8 26 ff ff ff       	call   80105120 <pushcli>
  if(holding(lk))
801051fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051fd:	83 ec 0c             	sub    $0xc,%esp
80105200:	53                   	push   %ebx
80105201:	e8 ba ff ff ff       	call   801051c0 <holding>
80105206:	83 c4 10             	add    $0x10,%esp
80105209:	85 c0                	test   %eax,%eax
8010520b:	0f 85 83 00 00 00    	jne    80105294 <acquire+0xa4>
80105211:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105213:	ba 01 00 00 00       	mov    $0x1,%edx
80105218:	eb 09                	jmp    80105223 <acquire+0x33>
8010521a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105220:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105223:	89 d0                	mov    %edx,%eax
80105225:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105228:	85 c0                	test   %eax,%eax
8010522a:	75 f4                	jne    80105220 <acquire+0x30>
  __sync_synchronize();
8010522c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105231:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105234:	e8 f7 ef ff ff       	call   80104230 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105239:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010523c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010523f:	89 e8                	mov    %ebp,%eax
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105248:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010524e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105254:	77 1a                	ja     80105270 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105256:	8b 48 04             	mov    0x4(%eax),%ecx
80105259:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010525c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010525f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105261:	83 fe 0a             	cmp    $0xa,%esi
80105264:	75 e2                	jne    80105248 <acquire+0x58>
}
80105266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5d                   	pop    %ebp
8010526c:	c3                   	ret    
8010526d:	8d 76 00             	lea    0x0(%esi),%esi
80105270:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105273:	83 c2 28             	add    $0x28,%edx
80105276:	8d 76 00             	lea    0x0(%esi),%esi
80105279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105286:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105289:	39 d0                	cmp    %edx,%eax
8010528b:	75 f3                	jne    80105280 <acquire+0x90>
}
8010528d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105290:	5b                   	pop    %ebx
80105291:	5e                   	pop    %esi
80105292:	5d                   	pop    %ebp
80105293:	c3                   	ret    
    panic("acquire");
80105294:	83 ec 0c             	sub    $0xc,%esp
80105297:	68 bd 97 10 80       	push   $0x801097bd
8010529c:	e8 ef b0 ff ff       	call   80100390 <panic>
801052a1:	eb 0d                	jmp    801052b0 <release>
801052a3:	90                   	nop
801052a4:	90                   	nop
801052a5:	90                   	nop
801052a6:	90                   	nop
801052a7:	90                   	nop
801052a8:	90                   	nop
801052a9:	90                   	nop
801052aa:	90                   	nop
801052ab:	90                   	nop
801052ac:	90                   	nop
801052ad:	90                   	nop
801052ae:	90                   	nop
801052af:	90                   	nop

801052b0 <release>:
{
801052b0:	55                   	push   %ebp
801052b1:	89 e5                	mov    %esp,%ebp
801052b3:	53                   	push   %ebx
801052b4:	83 ec 10             	sub    $0x10,%esp
801052b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801052ba:	53                   	push   %ebx
801052bb:	e8 00 ff ff ff       	call   801051c0 <holding>
801052c0:	83 c4 10             	add    $0x10,%esp
801052c3:	85 c0                	test   %eax,%eax
801052c5:	74 22                	je     801052e9 <release+0x39>
  lk->pcs[0] = 0;
801052c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801052ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801052d5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801052da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801052e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052e3:	c9                   	leave  
  popcli();
801052e4:	e9 77 fe ff ff       	jmp    80105160 <popcli>
    panic("release");
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	68 c5 97 10 80       	push   $0x801097c5
801052f1:	e8 9a b0 ff ff       	call   80100390 <panic>
801052f6:	66 90                	xchg   %ax,%ax
801052f8:	66 90                	xchg   %ax,%ax
801052fa:	66 90                	xchg   %ax,%ax
801052fc:	66 90                	xchg   %ax,%ax
801052fe:	66 90                	xchg   %ax,%ax

80105300 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	53                   	push   %ebx
80105305:	8b 55 08             	mov    0x8(%ebp),%edx
80105308:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010530b:	f6 c2 03             	test   $0x3,%dl
8010530e:	75 05                	jne    80105315 <memset+0x15>
80105310:	f6 c1 03             	test   $0x3,%cl
80105313:	74 13                	je     80105328 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105315:	89 d7                	mov    %edx,%edi
80105317:	8b 45 0c             	mov    0xc(%ebp),%eax
8010531a:	fc                   	cld    
8010531b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010531d:	5b                   	pop    %ebx
8010531e:	89 d0                	mov    %edx,%eax
80105320:	5f                   	pop    %edi
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    
80105323:	90                   	nop
80105324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105328:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010532c:	c1 e9 02             	shr    $0x2,%ecx
8010532f:	89 f8                	mov    %edi,%eax
80105331:	89 fb                	mov    %edi,%ebx
80105333:	c1 e0 18             	shl    $0x18,%eax
80105336:	c1 e3 10             	shl    $0x10,%ebx
80105339:	09 d8                	or     %ebx,%eax
8010533b:	09 f8                	or     %edi,%eax
8010533d:	c1 e7 08             	shl    $0x8,%edi
80105340:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105342:	89 d7                	mov    %edx,%edi
80105344:	fc                   	cld    
80105345:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105347:	5b                   	pop    %ebx
80105348:	89 d0                	mov    %edx,%eax
8010534a:	5f                   	pop    %edi
8010534b:	5d                   	pop    %ebp
8010534c:	c3                   	ret    
8010534d:	8d 76 00             	lea    0x0(%esi),%esi

80105350 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	57                   	push   %edi
80105354:	56                   	push   %esi
80105355:	53                   	push   %ebx
80105356:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105359:	8b 75 08             	mov    0x8(%ebp),%esi
8010535c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010535f:	85 db                	test   %ebx,%ebx
80105361:	74 29                	je     8010538c <memcmp+0x3c>
    if(*s1 != *s2)
80105363:	0f b6 16             	movzbl (%esi),%edx
80105366:	0f b6 0f             	movzbl (%edi),%ecx
80105369:	38 d1                	cmp    %dl,%cl
8010536b:	75 2b                	jne    80105398 <memcmp+0x48>
8010536d:	b8 01 00 00 00       	mov    $0x1,%eax
80105372:	eb 14                	jmp    80105388 <memcmp+0x38>
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105378:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010537c:	83 c0 01             	add    $0x1,%eax
8010537f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105384:	38 ca                	cmp    %cl,%dl
80105386:	75 10                	jne    80105398 <memcmp+0x48>
  while(n-- > 0){
80105388:	39 d8                	cmp    %ebx,%eax
8010538a:	75 ec                	jne    80105378 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010538c:	5b                   	pop    %ebx
  return 0;
8010538d:	31 c0                	xor    %eax,%eax
}
8010538f:	5e                   	pop    %esi
80105390:	5f                   	pop    %edi
80105391:	5d                   	pop    %ebp
80105392:	c3                   	ret    
80105393:	90                   	nop
80105394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105398:	0f b6 c2             	movzbl %dl,%eax
}
8010539b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010539c:	29 c8                	sub    %ecx,%eax
}
8010539e:	5e                   	pop    %esi
8010539f:	5f                   	pop    %edi
801053a0:	5d                   	pop    %ebp
801053a1:	c3                   	ret    
801053a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	56                   	push   %esi
801053b4:	53                   	push   %ebx
801053b5:	8b 45 08             	mov    0x8(%ebp),%eax
801053b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053bb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801053be:	39 c3                	cmp    %eax,%ebx
801053c0:	73 26                	jae    801053e8 <memmove+0x38>
801053c2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801053c5:	39 c8                	cmp    %ecx,%eax
801053c7:	73 1f                	jae    801053e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801053c9:	85 f6                	test   %esi,%esi
801053cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801053ce:	74 0f                	je     801053df <memmove+0x2f>
      *--d = *--s;
801053d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801053d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801053d7:	83 ea 01             	sub    $0x1,%edx
801053da:	83 fa ff             	cmp    $0xffffffff,%edx
801053dd:	75 f1                	jne    801053d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801053df:	5b                   	pop    %ebx
801053e0:	5e                   	pop    %esi
801053e1:	5d                   	pop    %ebp
801053e2:	c3                   	ret    
801053e3:	90                   	nop
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801053e8:	31 d2                	xor    %edx,%edx
801053ea:	85 f6                	test   %esi,%esi
801053ec:	74 f1                	je     801053df <memmove+0x2f>
801053ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801053f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801053f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801053f7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801053fa:	39 d6                	cmp    %edx,%esi
801053fc:	75 f2                	jne    801053f0 <memmove+0x40>
}
801053fe:	5b                   	pop    %ebx
801053ff:	5e                   	pop    %esi
80105400:	5d                   	pop    %ebp
80105401:	c3                   	ret    
80105402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105413:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105414:	eb 9a                	jmp    801053b0 <memmove>
80105416:	8d 76 00             	lea    0x0(%esi),%esi
80105419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105420 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	57                   	push   %edi
80105424:	56                   	push   %esi
80105425:	8b 7d 10             	mov    0x10(%ebp),%edi
80105428:	53                   	push   %ebx
80105429:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010542c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010542f:	85 ff                	test   %edi,%edi
80105431:	74 2f                	je     80105462 <strncmp+0x42>
80105433:	0f b6 01             	movzbl (%ecx),%eax
80105436:	0f b6 1e             	movzbl (%esi),%ebx
80105439:	84 c0                	test   %al,%al
8010543b:	74 37                	je     80105474 <strncmp+0x54>
8010543d:	38 c3                	cmp    %al,%bl
8010543f:	75 33                	jne    80105474 <strncmp+0x54>
80105441:	01 f7                	add    %esi,%edi
80105443:	eb 13                	jmp    80105458 <strncmp+0x38>
80105445:	8d 76 00             	lea    0x0(%esi),%esi
80105448:	0f b6 01             	movzbl (%ecx),%eax
8010544b:	84 c0                	test   %al,%al
8010544d:	74 21                	je     80105470 <strncmp+0x50>
8010544f:	0f b6 1a             	movzbl (%edx),%ebx
80105452:	89 d6                	mov    %edx,%esi
80105454:	38 d8                	cmp    %bl,%al
80105456:	75 1c                	jne    80105474 <strncmp+0x54>
    n--, p++, q++;
80105458:	8d 56 01             	lea    0x1(%esi),%edx
8010545b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010545e:	39 fa                	cmp    %edi,%edx
80105460:	75 e6                	jne    80105448 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105462:	5b                   	pop    %ebx
    return 0;
80105463:	31 c0                	xor    %eax,%eax
}
80105465:	5e                   	pop    %esi
80105466:	5f                   	pop    %edi
80105467:	5d                   	pop    %ebp
80105468:	c3                   	ret    
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105470:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105474:	29 d8                	sub    %ebx,%eax
}
80105476:	5b                   	pop    %ebx
80105477:	5e                   	pop    %esi
80105478:	5f                   	pop    %edi
80105479:	5d                   	pop    %ebp
8010547a:	c3                   	ret    
8010547b:	90                   	nop
8010547c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105480 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
80105485:	8b 45 08             	mov    0x8(%ebp),%eax
80105488:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010548b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010548e:	89 c2                	mov    %eax,%edx
80105490:	eb 19                	jmp    801054ab <strncpy+0x2b>
80105492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105498:	83 c3 01             	add    $0x1,%ebx
8010549b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010549f:	83 c2 01             	add    $0x1,%edx
801054a2:	84 c9                	test   %cl,%cl
801054a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801054a7:	74 09                	je     801054b2 <strncpy+0x32>
801054a9:	89 f1                	mov    %esi,%ecx
801054ab:	85 c9                	test   %ecx,%ecx
801054ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801054b0:	7f e6                	jg     80105498 <strncpy+0x18>
    ;
  while(n-- > 0)
801054b2:	31 c9                	xor    %ecx,%ecx
801054b4:	85 f6                	test   %esi,%esi
801054b6:	7e 17                	jle    801054cf <strncpy+0x4f>
801054b8:	90                   	nop
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801054c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801054c4:	89 f3                	mov    %esi,%ebx
801054c6:	83 c1 01             	add    $0x1,%ecx
801054c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801054cb:	85 db                	test   %ebx,%ebx
801054cd:	7f f1                	jg     801054c0 <strncpy+0x40>
  return os;
}
801054cf:	5b                   	pop    %ebx
801054d0:	5e                   	pop    %esi
801054d1:	5d                   	pop    %ebp
801054d2:	c3                   	ret    
801054d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
801054e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801054e8:	8b 45 08             	mov    0x8(%ebp),%eax
801054eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801054ee:	85 c9                	test   %ecx,%ecx
801054f0:	7e 26                	jle    80105518 <safestrcpy+0x38>
801054f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801054f6:	89 c1                	mov    %eax,%ecx
801054f8:	eb 17                	jmp    80105511 <safestrcpy+0x31>
801054fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105500:	83 c2 01             	add    $0x1,%edx
80105503:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105507:	83 c1 01             	add    $0x1,%ecx
8010550a:	84 db                	test   %bl,%bl
8010550c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010550f:	74 04                	je     80105515 <safestrcpy+0x35>
80105511:	39 f2                	cmp    %esi,%edx
80105513:	75 eb                	jne    80105500 <safestrcpy+0x20>
    ;
  *s = 0;
80105515:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105518:	5b                   	pop    %ebx
80105519:	5e                   	pop    %esi
8010551a:	5d                   	pop    %ebp
8010551b:	c3                   	ret    
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <strlen>:

int
strlen(const char *s)
{
80105520:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105521:	31 c0                	xor    %eax,%eax
{
80105523:	89 e5                	mov    %esp,%ebp
80105525:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105528:	80 3a 00             	cmpb   $0x0,(%edx)
8010552b:	74 0c                	je     80105539 <strlen+0x19>
8010552d:	8d 76 00             	lea    0x0(%esi),%esi
80105530:	83 c0 01             	add    $0x1,%eax
80105533:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105537:	75 f7                	jne    80105530 <strlen+0x10>
    ;
  return n;
}
80105539:	5d                   	pop    %ebp
8010553a:	c3                   	ret    

8010553b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010553b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010553f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105543:	55                   	push   %ebp
  pushl %ebx
80105544:	53                   	push   %ebx
  pushl %esi
80105545:	56                   	push   %esi
  pushl %edi
80105546:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105547:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105549:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010554b:	5f                   	pop    %edi
  popl %esi
8010554c:	5e                   	pop    %esi
  popl %ebx
8010554d:	5b                   	pop    %ebx
  popl %ebp
8010554e:	5d                   	pop    %ebp
  ret
8010554f:	c3                   	ret    

80105550 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	53                   	push   %ebx
80105554:	83 ec 04             	sub    $0x4,%esp
80105557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010555a:	e8 71 ed ff ff       	call   801042d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010555f:	8b 00                	mov    (%eax),%eax
80105561:	39 d8                	cmp    %ebx,%eax
80105563:	76 1b                	jbe    80105580 <fetchint+0x30>
80105565:	8d 53 04             	lea    0x4(%ebx),%edx
80105568:	39 d0                	cmp    %edx,%eax
8010556a:	72 14                	jb     80105580 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010556c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010556f:	8b 13                	mov    (%ebx),%edx
80105571:	89 10                	mov    %edx,(%eax)
  return 0;
80105573:	31 c0                	xor    %eax,%eax
}
80105575:	83 c4 04             	add    $0x4,%esp
80105578:	5b                   	pop    %ebx
80105579:	5d                   	pop    %ebp
8010557a:	c3                   	ret    
8010557b:	90                   	nop
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105585:	eb ee                	jmp    80105575 <fetchint+0x25>
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 04             	sub    $0x4,%esp
80105597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010559a:	e8 31 ed ff ff       	call   801042d0 <myproc>

  if(addr >= curproc->sz)
8010559f:	39 18                	cmp    %ebx,(%eax)
801055a1:	76 29                	jbe    801055cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801055a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055a6:	89 da                	mov    %ebx,%edx
801055a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801055aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801055ac:	39 c3                	cmp    %eax,%ebx
801055ae:	73 1c                	jae    801055cc <fetchstr+0x3c>
    if(*s == 0)
801055b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801055b3:	75 10                	jne    801055c5 <fetchstr+0x35>
801055b5:	eb 39                	jmp    801055f0 <fetchstr+0x60>
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055c0:	80 3a 00             	cmpb   $0x0,(%edx)
801055c3:	74 1b                	je     801055e0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801055c5:	83 c2 01             	add    $0x1,%edx
801055c8:	39 d0                	cmp    %edx,%eax
801055ca:	77 f4                	ja     801055c0 <fetchstr+0x30>
    return -1;
801055cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801055d1:	83 c4 04             	add    $0x4,%esp
801055d4:	5b                   	pop    %ebx
801055d5:	5d                   	pop    %ebp
801055d6:	c3                   	ret    
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055e0:	83 c4 04             	add    $0x4,%esp
801055e3:	89 d0                	mov    %edx,%eax
801055e5:	29 d8                	sub    %ebx,%eax
801055e7:	5b                   	pop    %ebx
801055e8:	5d                   	pop    %ebp
801055e9:	c3                   	ret    
801055ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801055f0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801055f2:	eb dd                	jmp    801055d1 <fetchstr+0x41>
801055f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105600 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	56                   	push   %esi
80105604:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105605:	e8 c6 ec ff ff       	call   801042d0 <myproc>
8010560a:	8b 40 18             	mov    0x18(%eax),%eax
8010560d:	8b 55 08             	mov    0x8(%ebp),%edx
80105610:	8b 40 44             	mov    0x44(%eax),%eax
80105613:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105616:	e8 b5 ec ff ff       	call   801042d0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010561b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010561d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105620:	39 c6                	cmp    %eax,%esi
80105622:	73 1c                	jae    80105640 <argint+0x40>
80105624:	8d 53 08             	lea    0x8(%ebx),%edx
80105627:	39 d0                	cmp    %edx,%eax
80105629:	72 15                	jb     80105640 <argint+0x40>
  *ip = *(int*)(addr);
8010562b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010562e:	8b 53 04             	mov    0x4(%ebx),%edx
80105631:	89 10                	mov    %edx,(%eax)
  return 0;
80105633:	31 c0                	xor    %eax,%eax
}
80105635:	5b                   	pop    %ebx
80105636:	5e                   	pop    %esi
80105637:	5d                   	pop    %ebp
80105638:	c3                   	ret    
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105645:	eb ee                	jmp    80105635 <argint+0x35>
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	56                   	push   %esi
80105654:	53                   	push   %ebx
80105655:	83 ec 10             	sub    $0x10,%esp
80105658:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010565b:	e8 70 ec ff ff       	call   801042d0 <myproc>
80105660:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105662:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105665:	83 ec 08             	sub    $0x8,%esp
80105668:	50                   	push   %eax
80105669:	ff 75 08             	pushl  0x8(%ebp)
8010566c:	e8 8f ff ff ff       	call   80105600 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	78 28                	js     801056a0 <argptr+0x50>
80105678:	85 db                	test   %ebx,%ebx
8010567a:	78 24                	js     801056a0 <argptr+0x50>
8010567c:	8b 16                	mov    (%esi),%edx
8010567e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105681:	39 c2                	cmp    %eax,%edx
80105683:	76 1b                	jbe    801056a0 <argptr+0x50>
80105685:	01 c3                	add    %eax,%ebx
80105687:	39 da                	cmp    %ebx,%edx
80105689:	72 15                	jb     801056a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010568b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010568e:	89 02                	mov    %eax,(%edx)
  return 0;
80105690:	31 c0                	xor    %eax,%eax
}
80105692:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105695:	5b                   	pop    %ebx
80105696:	5e                   	pop    %esi
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a5:	eb eb                	jmp    80105692 <argptr+0x42>
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056b9:	50                   	push   %eax
801056ba:	ff 75 08             	pushl  0x8(%ebp)
801056bd:	e8 3e ff ff ff       	call   80105600 <argint>
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	85 c0                	test   %eax,%eax
801056c7:	78 17                	js     801056e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801056c9:	83 ec 08             	sub    $0x8,%esp
801056cc:	ff 75 0c             	pushl  0xc(%ebp)
801056cf:	ff 75 f4             	pushl  -0xc(%ebp)
801056d2:	e8 b9 fe ff ff       	call   80105590 <fetchstr>
801056d7:	83 c4 10             	add    $0x10,%esp
}
801056da:	c9                   	leave  
801056db:	c3                   	ret    
801056dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056f0 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	53                   	push   %ebx
801056f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801056f7:	e8 d4 eb ff ff       	call   801042d0 <myproc>
801056fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801056fe:	8b 40 18             	mov    0x18(%eax),%eax
80105701:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105704:	8d 50 ff             	lea    -0x1(%eax),%edx
80105707:	83 fa 16             	cmp    $0x16,%edx
8010570a:	77 1c                	ja     80105728 <syscall+0x38>
8010570c:	8b 14 85 00 98 10 80 	mov    -0x7fef6800(,%eax,4),%edx
80105713:	85 d2                	test   %edx,%edx
80105715:	74 11                	je     80105728 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105717:	ff d2                	call   *%edx
80105719:	8b 53 18             	mov    0x18(%ebx),%edx
8010571c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010571f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105722:	c9                   	leave  
80105723:	c3                   	ret    
80105724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105728:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105729:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010572c:	50                   	push   %eax
8010572d:	ff 73 10             	pushl  0x10(%ebx)
80105730:	68 cd 97 10 80       	push   $0x801097cd
80105735:	e8 26 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010573a:	8b 43 18             	mov    0x18(%ebx),%eax
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105747:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010574a:	c9                   	leave  
8010574b:	c3                   	ret    
8010574c:	66 90                	xchg   %ax,%ax
8010574e:	66 90                	xchg   %ax,%ax

80105750 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	56                   	push   %esi
80105754:	53                   	push   %ebx
80105755:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105757:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010575a:	89 d6                	mov    %edx,%esi
8010575c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010575f:	50                   	push   %eax
80105760:	6a 00                	push   $0x0
80105762:	e8 99 fe ff ff       	call   80105600 <argint>
80105767:	83 c4 10             	add    $0x10,%esp
8010576a:	85 c0                	test   %eax,%eax
8010576c:	78 2a                	js     80105798 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010576e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105772:	77 24                	ja     80105798 <argfd.constprop.0+0x48>
80105774:	e8 57 eb ff ff       	call   801042d0 <myproc>
80105779:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010577c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105780:	85 c0                	test   %eax,%eax
80105782:	74 14                	je     80105798 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105784:	85 db                	test   %ebx,%ebx
80105786:	74 02                	je     8010578a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105788:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010578a:	89 06                	mov    %eax,(%esi)
  return 0;
8010578c:	31 c0                	xor    %eax,%eax
}
8010578e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105791:	5b                   	pop    %ebx
80105792:	5e                   	pop    %esi
80105793:	5d                   	pop    %ebp
80105794:	c3                   	ret    
80105795:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105798:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579d:	eb ef                	jmp    8010578e <argfd.constprop.0+0x3e>
8010579f:	90                   	nop

801057a0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801057a0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057a1:	31 c0                	xor    %eax,%eax
{
801057a3:	89 e5                	mov    %esp,%ebp
801057a5:	56                   	push   %esi
801057a6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801057a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801057aa:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801057ad:	e8 9e ff ff ff       	call   80105750 <argfd.constprop.0>
801057b2:	85 c0                	test   %eax,%eax
801057b4:	78 42                	js     801057f8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801057b6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057b9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057bb:	e8 10 eb ff ff       	call   801042d0 <myproc>
801057c0:	eb 0e                	jmp    801057d0 <sys_dup+0x30>
801057c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057c8:	83 c3 01             	add    $0x1,%ebx
801057cb:	83 fb 10             	cmp    $0x10,%ebx
801057ce:	74 28                	je     801057f8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801057d0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057d4:	85 d2                	test   %edx,%edx
801057d6:	75 f0                	jne    801057c8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801057d8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801057dc:	83 ec 0c             	sub    $0xc,%esp
801057df:	ff 75 f4             	pushl  -0xc(%ebp)
801057e2:	e8 b9 b9 ff ff       	call   801011a0 <filedup>
  return fd;
801057e7:	83 c4 10             	add    $0x10,%esp
}
801057ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057ed:	89 d8                	mov    %ebx,%eax
801057ef:	5b                   	pop    %ebx
801057f0:	5e                   	pop    %esi
801057f1:	5d                   	pop    %ebp
801057f2:	c3                   	ret    
801057f3:	90                   	nop
801057f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801057fb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105800:	89 d8                	mov    %ebx,%eax
80105802:	5b                   	pop    %ebx
80105803:	5e                   	pop    %esi
80105804:	5d                   	pop    %ebp
80105805:	c3                   	ret    
80105806:	8d 76 00             	lea    0x0(%esi),%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105810 <sys_read>:

int
sys_read(void)
{
80105810:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105811:	31 c0                	xor    %eax,%eax
{
80105813:	89 e5                	mov    %esp,%ebp
80105815:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105818:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010581b:	e8 30 ff ff ff       	call   80105750 <argfd.constprop.0>
80105820:	85 c0                	test   %eax,%eax
80105822:	78 4c                	js     80105870 <sys_read+0x60>
80105824:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105827:	83 ec 08             	sub    $0x8,%esp
8010582a:	50                   	push   %eax
8010582b:	6a 02                	push   $0x2
8010582d:	e8 ce fd ff ff       	call   80105600 <argint>
80105832:	83 c4 10             	add    $0x10,%esp
80105835:	85 c0                	test   %eax,%eax
80105837:	78 37                	js     80105870 <sys_read+0x60>
80105839:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010583c:	83 ec 04             	sub    $0x4,%esp
8010583f:	ff 75 f0             	pushl  -0x10(%ebp)
80105842:	50                   	push   %eax
80105843:	6a 01                	push   $0x1
80105845:	e8 06 fe ff ff       	call   80105650 <argptr>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	78 1f                	js     80105870 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105851:	83 ec 04             	sub    $0x4,%esp
80105854:	ff 75 f0             	pushl  -0x10(%ebp)
80105857:	ff 75 f4             	pushl  -0xc(%ebp)
8010585a:	ff 75 ec             	pushl  -0x14(%ebp)
8010585d:	e8 ae ba ff ff       	call   80101310 <fileread>
80105862:	83 c4 10             	add    $0x10,%esp
}
80105865:	c9                   	leave  
80105866:	c3                   	ret    
80105867:	89 f6                	mov    %esi,%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    
80105877:	89 f6                	mov    %esi,%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <sys_write>:

int
sys_write(void)
{
80105880:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105881:	31 c0                	xor    %eax,%eax
{
80105883:	89 e5                	mov    %esp,%ebp
80105885:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105888:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010588b:	e8 c0 fe ff ff       	call   80105750 <argfd.constprop.0>
80105890:	85 c0                	test   %eax,%eax
80105892:	78 4c                	js     801058e0 <sys_write+0x60>
80105894:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105897:	83 ec 08             	sub    $0x8,%esp
8010589a:	50                   	push   %eax
8010589b:	6a 02                	push   $0x2
8010589d:	e8 5e fd ff ff       	call   80105600 <argint>
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 37                	js     801058e0 <sys_write+0x60>
801058a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ac:	83 ec 04             	sub    $0x4,%esp
801058af:	ff 75 f0             	pushl  -0x10(%ebp)
801058b2:	50                   	push   %eax
801058b3:	6a 01                	push   $0x1
801058b5:	e8 96 fd ff ff       	call   80105650 <argptr>
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	85 c0                	test   %eax,%eax
801058bf:	78 1f                	js     801058e0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801058c1:	83 ec 04             	sub    $0x4,%esp
801058c4:	ff 75 f0             	pushl  -0x10(%ebp)
801058c7:	ff 75 f4             	pushl  -0xc(%ebp)
801058ca:	ff 75 ec             	pushl  -0x14(%ebp)
801058cd:	e8 ce ba ff ff       	call   801013a0 <filewrite>
801058d2:	83 c4 10             	add    $0x10,%esp
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <sys_close>:

int
sys_close(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801058f6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801058f9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058fc:	e8 4f fe ff ff       	call   80105750 <argfd.constprop.0>
80105901:	85 c0                	test   %eax,%eax
80105903:	78 2b                	js     80105930 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105905:	e8 c6 e9 ff ff       	call   801042d0 <myproc>
8010590a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010590d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105910:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105917:	00 
  fileclose(f);
80105918:	ff 75 f4             	pushl  -0xc(%ebp)
8010591b:	e8 d0 b8 ff ff       	call   801011f0 <fileclose>
  return 0;
80105920:	83 c4 10             	add    $0x10,%esp
80105923:	31 c0                	xor    %eax,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105935:	c9                   	leave  
80105936:	c3                   	ret    
80105937:	89 f6                	mov    %esi,%esi
80105939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105940 <sys_fstat>:

int
sys_fstat(void)
{
80105940:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105941:	31 c0                	xor    %eax,%eax
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105948:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010594b:	e8 00 fe ff ff       	call   80105750 <argfd.constprop.0>
80105950:	85 c0                	test   %eax,%eax
80105952:	78 2c                	js     80105980 <sys_fstat+0x40>
80105954:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105957:	83 ec 04             	sub    $0x4,%esp
8010595a:	6a 14                	push   $0x14
8010595c:	50                   	push   %eax
8010595d:	6a 01                	push   $0x1
8010595f:	e8 ec fc ff ff       	call   80105650 <argptr>
80105964:	83 c4 10             	add    $0x10,%esp
80105967:	85 c0                	test   %eax,%eax
80105969:	78 15                	js     80105980 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	ff 75 f4             	pushl  -0xc(%ebp)
80105971:	ff 75 f0             	pushl  -0x10(%ebp)
80105974:	e8 47 b9 ff ff       	call   801012c0 <filestat>
80105979:	83 c4 10             	add    $0x10,%esp
}
8010597c:	c9                   	leave  
8010597d:	c3                   	ret    
8010597e:	66 90                	xchg   %ax,%ax
    return -1;
80105980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105990 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	57                   	push   %edi
80105994:	56                   	push   %esi
80105995:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105996:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105999:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010599c:	50                   	push   %eax
8010599d:	6a 00                	push   $0x0
8010599f:	e8 0c fd ff ff       	call   801056b0 <argstr>
801059a4:	83 c4 10             	add    $0x10,%esp
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 88 fb 00 00 00    	js     80105aaa <sys_link+0x11a>
801059af:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059b2:	83 ec 08             	sub    $0x8,%esp
801059b5:	50                   	push   %eax
801059b6:	6a 01                	push   $0x1
801059b8:	e8 f3 fc ff ff       	call   801056b0 <argstr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	0f 88 e2 00 00 00    	js     80105aaa <sys_link+0x11a>
    return -1;

  begin_op();
801059c8:	e8 93 db ff ff       	call   80103560 <begin_op>
  if((ip = namei(old)) == 0){
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801059d3:	e8 b8 c8 ff ff       	call   80102290 <namei>
801059d8:	83 c4 10             	add    $0x10,%esp
801059db:	85 c0                	test   %eax,%eax
801059dd:	89 c3                	mov    %eax,%ebx
801059df:	0f 84 ea 00 00 00    	je     80105acf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801059e5:	83 ec 0c             	sub    $0xc,%esp
801059e8:	50                   	push   %eax
801059e9:	e8 42 c0 ff ff       	call   80101a30 <ilock>
  if(ip->type == T_DIR){
801059ee:	83 c4 10             	add    $0x10,%esp
801059f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059f6:	0f 84 bb 00 00 00    	je     80105ab7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801059fc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a01:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a04:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a07:	53                   	push   %ebx
80105a08:	e8 73 bf ff ff       	call   80101980 <iupdate>
  iunlock(ip);
80105a0d:	89 1c 24             	mov    %ebx,(%esp)
80105a10:	e8 fb c0 ff ff       	call   80101b10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a15:	58                   	pop    %eax
80105a16:	5a                   	pop    %edx
80105a17:	57                   	push   %edi
80105a18:	ff 75 d0             	pushl  -0x30(%ebp)
80105a1b:	e8 90 c8 ff ff       	call   801022b0 <nameiparent>
80105a20:	83 c4 10             	add    $0x10,%esp
80105a23:	85 c0                	test   %eax,%eax
80105a25:	89 c6                	mov    %eax,%esi
80105a27:	74 5b                	je     80105a84 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a29:	83 ec 0c             	sub    $0xc,%esp
80105a2c:	50                   	push   %eax
80105a2d:	e8 fe bf ff ff       	call   80101a30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	8b 03                	mov    (%ebx),%eax
80105a37:	39 06                	cmp    %eax,(%esi)
80105a39:	75 3d                	jne    80105a78 <sys_link+0xe8>
80105a3b:	83 ec 04             	sub    $0x4,%esp
80105a3e:	ff 73 04             	pushl  0x4(%ebx)
80105a41:	57                   	push   %edi
80105a42:	56                   	push   %esi
80105a43:	e8 88 c7 ff ff       	call   801021d0 <dirlink>
80105a48:	83 c4 10             	add    $0x10,%esp
80105a4b:	85 c0                	test   %eax,%eax
80105a4d:	78 29                	js     80105a78 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105a4f:	83 ec 0c             	sub    $0xc,%esp
80105a52:	56                   	push   %esi
80105a53:	e8 68 c2 ff ff       	call   80101cc0 <iunlockput>
  iput(ip);
80105a58:	89 1c 24             	mov    %ebx,(%esp)
80105a5b:	e8 00 c1 ff ff       	call   80101b60 <iput>

  end_op();
80105a60:	e8 6b db ff ff       	call   801035d0 <end_op>

  return 0;
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105a6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a6d:	5b                   	pop    %ebx
80105a6e:	5e                   	pop    %esi
80105a6f:	5f                   	pop    %edi
80105a70:	5d                   	pop    %ebp
80105a71:	c3                   	ret    
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	56                   	push   %esi
80105a7c:	e8 3f c2 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105a81:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	53                   	push   %ebx
80105a88:	e8 a3 bf ff ff       	call   80101a30 <ilock>
  ip->nlink--;
80105a8d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a92:	89 1c 24             	mov    %ebx,(%esp)
80105a95:	e8 e6 be ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105a9a:	89 1c 24             	mov    %ebx,(%esp)
80105a9d:	e8 1e c2 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105aa2:	e8 29 db ff ff       	call   801035d0 <end_op>
  return -1;
80105aa7:	83 c4 10             	add    $0x10,%esp
}
80105aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab2:	5b                   	pop    %ebx
80105ab3:	5e                   	pop    %esi
80105ab4:	5f                   	pop    %edi
80105ab5:	5d                   	pop    %ebp
80105ab6:	c3                   	ret    
    iunlockput(ip);
80105ab7:	83 ec 0c             	sub    $0xc,%esp
80105aba:	53                   	push   %ebx
80105abb:	e8 00 c2 ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105ac0:	e8 0b db ff ff       	call   801035d0 <end_op>
    return -1;
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acd:	eb 9b                	jmp    80105a6a <sys_link+0xda>
    end_op();
80105acf:	e8 fc da ff ff       	call   801035d0 <end_op>
    return -1;
80105ad4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad9:	eb 8f                	jmp    80105a6a <sys_link+0xda>
80105adb:	90                   	nop
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	56                   	push   %esi
80105ae5:	53                   	push   %ebx
80105ae6:	83 ec 1c             	sub    $0x1c,%esp
80105ae9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105aec:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105af0:	76 3e                	jbe    80105b30 <isdirempty+0x50>
80105af2:	bb 20 00 00 00       	mov    $0x20,%ebx
80105af7:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105afa:	eb 0c                	jmp    80105b08 <isdirempty+0x28>
80105afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b00:	83 c3 10             	add    $0x10,%ebx
80105b03:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105b06:	73 28                	jae    80105b30 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b08:	6a 10                	push   $0x10
80105b0a:	53                   	push   %ebx
80105b0b:	57                   	push   %edi
80105b0c:	56                   	push   %esi
80105b0d:	e8 fe c1 ff ff       	call   80101d10 <readi>
80105b12:	83 c4 10             	add    $0x10,%esp
80105b15:	83 f8 10             	cmp    $0x10,%eax
80105b18:	75 23                	jne    80105b3d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105b1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b1f:	74 df                	je     80105b00 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105b24:	31 c0                	xor    %eax,%eax
}
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105b33:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b38:	5b                   	pop    %ebx
80105b39:	5e                   	pop    %esi
80105b3a:	5f                   	pop    %edi
80105b3b:	5d                   	pop    %ebp
80105b3c:	c3                   	ret    
      panic("isdirempty: readi");
80105b3d:	83 ec 0c             	sub    $0xc,%esp
80105b40:	68 60 98 10 80       	push   $0x80109860
80105b45:	e8 46 a8 ff ff       	call   80100390 <panic>
80105b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b50 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	57                   	push   %edi
80105b54:	56                   	push   %esi
80105b55:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b56:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b59:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b5c:	50                   	push   %eax
80105b5d:	6a 00                	push   $0x0
80105b5f:	e8 4c fb ff ff       	call   801056b0 <argstr>
80105b64:	83 c4 10             	add    $0x10,%esp
80105b67:	85 c0                	test   %eax,%eax
80105b69:	0f 88 51 01 00 00    	js     80105cc0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b6f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105b72:	e8 e9 d9 ff ff       	call   80103560 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b77:	83 ec 08             	sub    $0x8,%esp
80105b7a:	53                   	push   %ebx
80105b7b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b7e:	e8 2d c7 ff ff       	call   801022b0 <nameiparent>
80105b83:	83 c4 10             	add    $0x10,%esp
80105b86:	85 c0                	test   %eax,%eax
80105b88:	89 c6                	mov    %eax,%esi
80105b8a:	0f 84 37 01 00 00    	je     80105cc7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105b90:	83 ec 0c             	sub    $0xc,%esp
80105b93:	50                   	push   %eax
80105b94:	e8 97 be ff ff       	call   80101a30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b99:	58                   	pop    %eax
80105b9a:	5a                   	pop    %edx
80105b9b:	68 4b 91 10 80       	push   $0x8010914b
80105ba0:	53                   	push   %ebx
80105ba1:	e8 9a c3 ff ff       	call   80101f40 <namecmp>
80105ba6:	83 c4 10             	add    $0x10,%esp
80105ba9:	85 c0                	test   %eax,%eax
80105bab:	0f 84 d7 00 00 00    	je     80105c88 <sys_unlink+0x138>
80105bb1:	83 ec 08             	sub    $0x8,%esp
80105bb4:	68 4a 91 10 80       	push   $0x8010914a
80105bb9:	53                   	push   %ebx
80105bba:	e8 81 c3 ff ff       	call   80101f40 <namecmp>
80105bbf:	83 c4 10             	add    $0x10,%esp
80105bc2:	85 c0                	test   %eax,%eax
80105bc4:	0f 84 be 00 00 00    	je     80105c88 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105bca:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bcd:	83 ec 04             	sub    $0x4,%esp
80105bd0:	50                   	push   %eax
80105bd1:	53                   	push   %ebx
80105bd2:	56                   	push   %esi
80105bd3:	e8 88 c3 ff ff       	call   80101f60 <dirlookup>
80105bd8:	83 c4 10             	add    $0x10,%esp
80105bdb:	85 c0                	test   %eax,%eax
80105bdd:	89 c3                	mov    %eax,%ebx
80105bdf:	0f 84 a3 00 00 00    	je     80105c88 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105be5:	83 ec 0c             	sub    $0xc,%esp
80105be8:	50                   	push   %eax
80105be9:	e8 42 be ff ff       	call   80101a30 <ilock>

  if(ip->nlink < 1)
80105bee:	83 c4 10             	add    $0x10,%esp
80105bf1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105bf6:	0f 8e e4 00 00 00    	jle    80105ce0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c01:	74 65                	je     80105c68 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c03:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c06:	83 ec 04             	sub    $0x4,%esp
80105c09:	6a 10                	push   $0x10
80105c0b:	6a 00                	push   $0x0
80105c0d:	57                   	push   %edi
80105c0e:	e8 ed f6 ff ff       	call   80105300 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c13:	6a 10                	push   $0x10
80105c15:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c18:	57                   	push   %edi
80105c19:	56                   	push   %esi
80105c1a:	e8 f1 c1 ff ff       	call   80101e10 <writei>
80105c1f:	83 c4 20             	add    $0x20,%esp
80105c22:	83 f8 10             	cmp    $0x10,%eax
80105c25:	0f 85 a8 00 00 00    	jne    80105cd3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c2b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c30:	74 6e                	je     80105ca0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c32:	83 ec 0c             	sub    $0xc,%esp
80105c35:	56                   	push   %esi
80105c36:	e8 85 c0 ff ff       	call   80101cc0 <iunlockput>

  ip->nlink--;
80105c3b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c40:	89 1c 24             	mov    %ebx,(%esp)
80105c43:	e8 38 bd ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105c48:	89 1c 24             	mov    %ebx,(%esp)
80105c4b:	e8 70 c0 ff ff       	call   80101cc0 <iunlockput>

  end_op();
80105c50:	e8 7b d9 ff ff       	call   801035d0 <end_op>

  return 0;
80105c55:	83 c4 10             	add    $0x10,%esp
80105c58:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c5d:	5b                   	pop    %ebx
80105c5e:	5e                   	pop    %esi
80105c5f:	5f                   	pop    %edi
80105c60:	5d                   	pop    %ebp
80105c61:	c3                   	ret    
80105c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c68:	83 ec 0c             	sub    $0xc,%esp
80105c6b:	53                   	push   %ebx
80105c6c:	e8 6f fe ff ff       	call   80105ae0 <isdirempty>
80105c71:	83 c4 10             	add    $0x10,%esp
80105c74:	85 c0                	test   %eax,%eax
80105c76:	75 8b                	jne    80105c03 <sys_unlink+0xb3>
    iunlockput(ip);
80105c78:	83 ec 0c             	sub    $0xc,%esp
80105c7b:	53                   	push   %ebx
80105c7c:	e8 3f c0 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105c81:	83 c4 10             	add    $0x10,%esp
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105c88:	83 ec 0c             	sub    $0xc,%esp
80105c8b:	56                   	push   %esi
80105c8c:	e8 2f c0 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105c91:	e8 3a d9 ff ff       	call   801035d0 <end_op>
  return -1;
80105c96:	83 c4 10             	add    $0x10,%esp
80105c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9e:	eb ba                	jmp    80105c5a <sys_unlink+0x10a>
    dp->nlink--;
80105ca0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ca5:	83 ec 0c             	sub    $0xc,%esp
80105ca8:	56                   	push   %esi
80105ca9:	e8 d2 bc ff ff       	call   80101980 <iupdate>
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	e9 7c ff ff ff       	jmp    80105c32 <sys_unlink+0xe2>
80105cb6:	8d 76 00             	lea    0x0(%esi),%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cc5:	eb 93                	jmp    80105c5a <sys_unlink+0x10a>
    end_op();
80105cc7:	e8 04 d9 ff ff       	call   801035d0 <end_op>
    return -1;
80105ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cd1:	eb 87                	jmp    80105c5a <sys_unlink+0x10a>
    panic("unlink: writei");
80105cd3:	83 ec 0c             	sub    $0xc,%esp
80105cd6:	68 5f 91 10 80       	push   $0x8010915f
80105cdb:	e8 b0 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105ce0:	83 ec 0c             	sub    $0xc,%esp
80105ce3:	68 4d 91 10 80       	push   $0x8010914d
80105ce8:	e8 a3 a6 ff ff       	call   80100390 <panic>
80105ced:	8d 76 00             	lea    0x0(%esi),%esi

80105cf0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105cf0:	55                   	push   %ebp
80105cf1:	89 e5                	mov    %esp,%ebp
80105cf3:	57                   	push   %edi
80105cf4:	56                   	push   %esi
80105cf5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105cf6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105cf9:	83 ec 34             	sub    $0x34,%esp
80105cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cff:	8b 55 10             	mov    0x10(%ebp),%edx
80105d02:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d05:	56                   	push   %esi
80105d06:	ff 75 08             	pushl  0x8(%ebp)
{
80105d09:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105d0c:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105d0f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d12:	e8 99 c5 ff ff       	call   801022b0 <nameiparent>
80105d17:	83 c4 10             	add    $0x10,%esp
80105d1a:	85 c0                	test   %eax,%eax
80105d1c:	0f 84 4e 01 00 00    	je     80105e70 <create+0x180>
    return 0;
  ilock(dp);
80105d22:	83 ec 0c             	sub    $0xc,%esp
80105d25:	89 c3                	mov    %eax,%ebx
80105d27:	50                   	push   %eax
80105d28:	e8 03 bd ff ff       	call   80101a30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d2d:	83 c4 0c             	add    $0xc,%esp
80105d30:	6a 00                	push   $0x0
80105d32:	56                   	push   %esi
80105d33:	53                   	push   %ebx
80105d34:	e8 27 c2 ff ff       	call   80101f60 <dirlookup>
80105d39:	83 c4 10             	add    $0x10,%esp
80105d3c:	85 c0                	test   %eax,%eax
80105d3e:	89 c7                	mov    %eax,%edi
80105d40:	74 3e                	je     80105d80 <create+0x90>
    iunlockput(dp);
80105d42:	83 ec 0c             	sub    $0xc,%esp
80105d45:	53                   	push   %ebx
80105d46:	e8 75 bf ff ff       	call   80101cc0 <iunlockput>
    ilock(ip);
80105d4b:	89 3c 24             	mov    %edi,(%esp)
80105d4e:	e8 dd bc ff ff       	call   80101a30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d53:	83 c4 10             	add    $0x10,%esp
80105d56:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d5b:	0f 85 9f 00 00 00    	jne    80105e00 <create+0x110>
80105d61:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105d66:	0f 85 94 00 00 00    	jne    80105e00 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d6f:	89 f8                	mov    %edi,%eax
80105d71:	5b                   	pop    %ebx
80105d72:	5e                   	pop    %esi
80105d73:	5f                   	pop    %edi
80105d74:	5d                   	pop    %ebp
80105d75:	c3                   	ret    
80105d76:	8d 76 00             	lea    0x0(%esi),%esi
80105d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105d80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105d84:	83 ec 08             	sub    $0x8,%esp
80105d87:	50                   	push   %eax
80105d88:	ff 33                	pushl  (%ebx)
80105d8a:	e8 31 bb ff ff       	call   801018c0 <ialloc>
80105d8f:	83 c4 10             	add    $0x10,%esp
80105d92:	85 c0                	test   %eax,%eax
80105d94:	89 c7                	mov    %eax,%edi
80105d96:	0f 84 e8 00 00 00    	je     80105e84 <create+0x194>
  ilock(ip);
80105d9c:	83 ec 0c             	sub    $0xc,%esp
80105d9f:	50                   	push   %eax
80105da0:	e8 8b bc ff ff       	call   80101a30 <ilock>
  ip->major = major;
80105da5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105da9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105dad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105db1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105db5:	b8 01 00 00 00       	mov    $0x1,%eax
80105dba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105dbe:	89 3c 24             	mov    %edi,(%esp)
80105dc1:	e8 ba bb ff ff       	call   80101980 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105dce:	74 50                	je     80105e20 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105dd0:	83 ec 04             	sub    $0x4,%esp
80105dd3:	ff 77 04             	pushl  0x4(%edi)
80105dd6:	56                   	push   %esi
80105dd7:	53                   	push   %ebx
80105dd8:	e8 f3 c3 ff ff       	call   801021d0 <dirlink>
80105ddd:	83 c4 10             	add    $0x10,%esp
80105de0:	85 c0                	test   %eax,%eax
80105de2:	0f 88 8f 00 00 00    	js     80105e77 <create+0x187>
  iunlockput(dp);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	53                   	push   %ebx
80105dec:	e8 cf be ff ff       	call   80101cc0 <iunlockput>
  return ip;
80105df1:	83 c4 10             	add    $0x10,%esp
}
80105df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df7:	89 f8                	mov    %edi,%eax
80105df9:	5b                   	pop    %ebx
80105dfa:	5e                   	pop    %esi
80105dfb:	5f                   	pop    %edi
80105dfc:	5d                   	pop    %ebp
80105dfd:	c3                   	ret    
80105dfe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	57                   	push   %edi
    return 0;
80105e04:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105e06:	e8 b5 be ff ff       	call   80101cc0 <iunlockput>
    return 0;
80105e0b:	83 c4 10             	add    $0x10,%esp
}
80105e0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e11:	89 f8                	mov    %edi,%eax
80105e13:	5b                   	pop    %ebx
80105e14:	5e                   	pop    %esi
80105e15:	5f                   	pop    %edi
80105e16:	5d                   	pop    %ebp
80105e17:	c3                   	ret    
80105e18:	90                   	nop
80105e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105e20:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e25:	83 ec 0c             	sub    $0xc,%esp
80105e28:	53                   	push   %ebx
80105e29:	e8 52 bb ff ff       	call   80101980 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e2e:	83 c4 0c             	add    $0xc,%esp
80105e31:	ff 77 04             	pushl  0x4(%edi)
80105e34:	68 4b 91 10 80       	push   $0x8010914b
80105e39:	57                   	push   %edi
80105e3a:	e8 91 c3 ff ff       	call   801021d0 <dirlink>
80105e3f:	83 c4 10             	add    $0x10,%esp
80105e42:	85 c0                	test   %eax,%eax
80105e44:	78 1c                	js     80105e62 <create+0x172>
80105e46:	83 ec 04             	sub    $0x4,%esp
80105e49:	ff 73 04             	pushl  0x4(%ebx)
80105e4c:	68 4a 91 10 80       	push   $0x8010914a
80105e51:	57                   	push   %edi
80105e52:	e8 79 c3 ff ff       	call   801021d0 <dirlink>
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	85 c0                	test   %eax,%eax
80105e5c:	0f 89 6e ff ff ff    	jns    80105dd0 <create+0xe0>
      panic("create dots");
80105e62:	83 ec 0c             	sub    $0xc,%esp
80105e65:	68 81 98 10 80       	push   $0x80109881
80105e6a:	e8 21 a5 ff ff       	call   80100390 <panic>
80105e6f:	90                   	nop
    return 0;
80105e70:	31 ff                	xor    %edi,%edi
80105e72:	e9 f5 fe ff ff       	jmp    80105d6c <create+0x7c>
    panic("create: dirlink");
80105e77:	83 ec 0c             	sub    $0xc,%esp
80105e7a:	68 8d 98 10 80       	push   $0x8010988d
80105e7f:	e8 0c a5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105e84:	83 ec 0c             	sub    $0xc,%esp
80105e87:	68 72 98 10 80       	push   $0x80109872
80105e8c:	e8 ff a4 ff ff       	call   80100390 <panic>
80105e91:	eb 0d                	jmp    80105ea0 <sys_open>
80105e93:	90                   	nop
80105e94:	90                   	nop
80105e95:	90                   	nop
80105e96:	90                   	nop
80105e97:	90                   	nop
80105e98:	90                   	nop
80105e99:	90                   	nop
80105e9a:	90                   	nop
80105e9b:	90                   	nop
80105e9c:	90                   	nop
80105e9d:	90                   	nop
80105e9e:	90                   	nop
80105e9f:	90                   	nop

80105ea0 <sys_open>:

int
sys_open(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	57                   	push   %edi
80105ea4:	56                   	push   %esi
80105ea5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ea6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105ea9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105eac:	50                   	push   %eax
80105ead:	6a 00                	push   $0x0
80105eaf:	e8 fc f7 ff ff       	call   801056b0 <argstr>
80105eb4:	83 c4 10             	add    $0x10,%esp
80105eb7:	85 c0                	test   %eax,%eax
80105eb9:	0f 88 1d 01 00 00    	js     80105fdc <sys_open+0x13c>
80105ebf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ec2:	83 ec 08             	sub    $0x8,%esp
80105ec5:	50                   	push   %eax
80105ec6:	6a 01                	push   $0x1
80105ec8:	e8 33 f7 ff ff       	call   80105600 <argint>
80105ecd:	83 c4 10             	add    $0x10,%esp
80105ed0:	85 c0                	test   %eax,%eax
80105ed2:	0f 88 04 01 00 00    	js     80105fdc <sys_open+0x13c>
    return -1;

  begin_op();
80105ed8:	e8 83 d6 ff ff       	call   80103560 <begin_op>

  if(omode & O_CREATE){
80105edd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ee1:	0f 85 a9 00 00 00    	jne    80105f90 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ee7:	83 ec 0c             	sub    $0xc,%esp
80105eea:	ff 75 e0             	pushl  -0x20(%ebp)
80105eed:	e8 9e c3 ff ff       	call   80102290 <namei>
80105ef2:	83 c4 10             	add    $0x10,%esp
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	89 c6                	mov    %eax,%esi
80105ef9:	0f 84 ac 00 00 00    	je     80105fab <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105eff:	83 ec 0c             	sub    $0xc,%esp
80105f02:	50                   	push   %eax
80105f03:	e8 28 bb ff ff       	call   80101a30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f08:	83 c4 10             	add    $0x10,%esp
80105f0b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f10:	0f 84 aa 00 00 00    	je     80105fc0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f16:	e8 15 b2 ff ff       	call   80101130 <filealloc>
80105f1b:	85 c0                	test   %eax,%eax
80105f1d:	89 c7                	mov    %eax,%edi
80105f1f:	0f 84 a6 00 00 00    	je     80105fcb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105f25:	e8 a6 e3 ff ff       	call   801042d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f2a:	31 db                	xor    %ebx,%ebx
80105f2c:	eb 0e                	jmp    80105f3c <sys_open+0x9c>
80105f2e:	66 90                	xchg   %ax,%ax
80105f30:	83 c3 01             	add    $0x1,%ebx
80105f33:	83 fb 10             	cmp    $0x10,%ebx
80105f36:	0f 84 ac 00 00 00    	je     80105fe8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105f3c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f40:	85 d2                	test   %edx,%edx
80105f42:	75 ec                	jne    80105f30 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f44:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f47:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105f4b:	56                   	push   %esi
80105f4c:	e8 bf bb ff ff       	call   80101b10 <iunlock>
  end_op();
80105f51:	e8 7a d6 ff ff       	call   801035d0 <end_op>

  f->type = FD_INODE;
80105f56:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f5c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f5f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f62:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105f65:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f6c:	89 d0                	mov    %edx,%eax
80105f6e:	f7 d0                	not    %eax
80105f70:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f73:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105f76:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f79:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105f7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f80:	89 d8                	mov    %ebx,%eax
80105f82:	5b                   	pop    %ebx
80105f83:	5e                   	pop    %esi
80105f84:	5f                   	pop    %edi
80105f85:	5d                   	pop    %ebp
80105f86:	c3                   	ret    
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105f90:	6a 00                	push   $0x0
80105f92:	6a 00                	push   $0x0
80105f94:	6a 02                	push   $0x2
80105f96:	ff 75 e0             	pushl  -0x20(%ebp)
80105f99:	e8 52 fd ff ff       	call   80105cf0 <create>
    if(ip == 0){
80105f9e:	83 c4 10             	add    $0x10,%esp
80105fa1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105fa3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105fa5:	0f 85 6b ff ff ff    	jne    80105f16 <sys_open+0x76>
      end_op();
80105fab:	e8 20 d6 ff ff       	call   801035d0 <end_op>
      return -1;
80105fb0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fb5:	eb c6                	jmp    80105f7d <sys_open+0xdd>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fc0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105fc3:	85 c9                	test   %ecx,%ecx
80105fc5:	0f 84 4b ff ff ff    	je     80105f16 <sys_open+0x76>
    iunlockput(ip);
80105fcb:	83 ec 0c             	sub    $0xc,%esp
80105fce:	56                   	push   %esi
80105fcf:	e8 ec bc ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105fd4:	e8 f7 d5 ff ff       	call   801035d0 <end_op>
    return -1;
80105fd9:	83 c4 10             	add    $0x10,%esp
80105fdc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fe1:	eb 9a                	jmp    80105f7d <sys_open+0xdd>
80105fe3:	90                   	nop
80105fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105fe8:	83 ec 0c             	sub    $0xc,%esp
80105feb:	57                   	push   %edi
80105fec:	e8 ff b1 ff ff       	call   801011f0 <fileclose>
80105ff1:	83 c4 10             	add    $0x10,%esp
80105ff4:	eb d5                	jmp    80105fcb <sys_open+0x12b>
80105ff6:	8d 76 00             	lea    0x0(%esi),%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106000 <sys_mkdir>:

int
sys_mkdir(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106006:	e8 55 d5 ff ff       	call   80103560 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010600b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010600e:	83 ec 08             	sub    $0x8,%esp
80106011:	50                   	push   %eax
80106012:	6a 00                	push   $0x0
80106014:	e8 97 f6 ff ff       	call   801056b0 <argstr>
80106019:	83 c4 10             	add    $0x10,%esp
8010601c:	85 c0                	test   %eax,%eax
8010601e:	78 30                	js     80106050 <sys_mkdir+0x50>
80106020:	6a 00                	push   $0x0
80106022:	6a 00                	push   $0x0
80106024:	6a 01                	push   $0x1
80106026:	ff 75 f4             	pushl  -0xc(%ebp)
80106029:	e8 c2 fc ff ff       	call   80105cf0 <create>
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	85 c0                	test   %eax,%eax
80106033:	74 1b                	je     80106050 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106035:	83 ec 0c             	sub    $0xc,%esp
80106038:	50                   	push   %eax
80106039:	e8 82 bc ff ff       	call   80101cc0 <iunlockput>
  end_op();
8010603e:	e8 8d d5 ff ff       	call   801035d0 <end_op>
  return 0;
80106043:	83 c4 10             	add    $0x10,%esp
80106046:	31 c0                	xor    %eax,%eax
}
80106048:	c9                   	leave  
80106049:	c3                   	ret    
8010604a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106050:	e8 7b d5 ff ff       	call   801035d0 <end_op>
    return -1;
80106055:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010605a:	c9                   	leave  
8010605b:	c3                   	ret    
8010605c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106060 <sys_mknod>:

int
sys_mknod(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106066:	e8 f5 d4 ff ff       	call   80103560 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010606b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010606e:	83 ec 08             	sub    $0x8,%esp
80106071:	50                   	push   %eax
80106072:	6a 00                	push   $0x0
80106074:	e8 37 f6 ff ff       	call   801056b0 <argstr>
80106079:	83 c4 10             	add    $0x10,%esp
8010607c:	85 c0                	test   %eax,%eax
8010607e:	78 60                	js     801060e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106080:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106083:	83 ec 08             	sub    $0x8,%esp
80106086:	50                   	push   %eax
80106087:	6a 01                	push   $0x1
80106089:	e8 72 f5 ff ff       	call   80105600 <argint>
  if((argstr(0, &path)) < 0 ||
8010608e:	83 c4 10             	add    $0x10,%esp
80106091:	85 c0                	test   %eax,%eax
80106093:	78 4b                	js     801060e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106095:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106098:	83 ec 08             	sub    $0x8,%esp
8010609b:	50                   	push   %eax
8010609c:	6a 02                	push   $0x2
8010609e:	e8 5d f5 ff ff       	call   80105600 <argint>
     argint(1, &major) < 0 ||
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	85 c0                	test   %eax,%eax
801060a8:	78 36                	js     801060e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801060aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801060ae:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801060af:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801060b3:	50                   	push   %eax
801060b4:	6a 03                	push   $0x3
801060b6:	ff 75 ec             	pushl  -0x14(%ebp)
801060b9:	e8 32 fc ff ff       	call   80105cf0 <create>
801060be:	83 c4 10             	add    $0x10,%esp
801060c1:	85 c0                	test   %eax,%eax
801060c3:	74 1b                	je     801060e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801060c5:	83 ec 0c             	sub    $0xc,%esp
801060c8:	50                   	push   %eax
801060c9:	e8 f2 bb ff ff       	call   80101cc0 <iunlockput>
  end_op();
801060ce:	e8 fd d4 ff ff       	call   801035d0 <end_op>
  return 0;
801060d3:	83 c4 10             	add    $0x10,%esp
801060d6:	31 c0                	xor    %eax,%eax
}
801060d8:	c9                   	leave  
801060d9:	c3                   	ret    
801060da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801060e0:	e8 eb d4 ff ff       	call   801035d0 <end_op>
    return -1;
801060e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ea:	c9                   	leave  
801060eb:	c3                   	ret    
801060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060f0 <sys_chdir>:

int
sys_chdir(void)
{
801060f0:	55                   	push   %ebp
801060f1:	89 e5                	mov    %esp,%ebp
801060f3:	56                   	push   %esi
801060f4:	53                   	push   %ebx
801060f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801060f8:	e8 d3 e1 ff ff       	call   801042d0 <myproc>
801060fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801060ff:	e8 5c d4 ff ff       	call   80103560 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106104:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106107:	83 ec 08             	sub    $0x8,%esp
8010610a:	50                   	push   %eax
8010610b:	6a 00                	push   $0x0
8010610d:	e8 9e f5 ff ff       	call   801056b0 <argstr>
80106112:	83 c4 10             	add    $0x10,%esp
80106115:	85 c0                	test   %eax,%eax
80106117:	78 77                	js     80106190 <sys_chdir+0xa0>
80106119:	83 ec 0c             	sub    $0xc,%esp
8010611c:	ff 75 f4             	pushl  -0xc(%ebp)
8010611f:	e8 6c c1 ff ff       	call   80102290 <namei>
80106124:	83 c4 10             	add    $0x10,%esp
80106127:	85 c0                	test   %eax,%eax
80106129:	89 c3                	mov    %eax,%ebx
8010612b:	74 63                	je     80106190 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010612d:	83 ec 0c             	sub    $0xc,%esp
80106130:	50                   	push   %eax
80106131:	e8 fa b8 ff ff       	call   80101a30 <ilock>
  if(ip->type != T_DIR){
80106136:	83 c4 10             	add    $0x10,%esp
80106139:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010613e:	75 30                	jne    80106170 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106140:	83 ec 0c             	sub    $0xc,%esp
80106143:	53                   	push   %ebx
80106144:	e8 c7 b9 ff ff       	call   80101b10 <iunlock>
  iput(curproc->cwd);
80106149:	58                   	pop    %eax
8010614a:	ff 76 68             	pushl  0x68(%esi)
8010614d:	e8 0e ba ff ff       	call   80101b60 <iput>
  end_op();
80106152:	e8 79 d4 ff ff       	call   801035d0 <end_op>
  curproc->cwd = ip;
80106157:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010615a:	83 c4 10             	add    $0x10,%esp
8010615d:	31 c0                	xor    %eax,%eax
}
8010615f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106162:	5b                   	pop    %ebx
80106163:	5e                   	pop    %esi
80106164:	5d                   	pop    %ebp
80106165:	c3                   	ret    
80106166:	8d 76 00             	lea    0x0(%esi),%esi
80106169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106170:	83 ec 0c             	sub    $0xc,%esp
80106173:	53                   	push   %ebx
80106174:	e8 47 bb ff ff       	call   80101cc0 <iunlockput>
    end_op();
80106179:	e8 52 d4 ff ff       	call   801035d0 <end_op>
    return -1;
8010617e:	83 c4 10             	add    $0x10,%esp
80106181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106186:	eb d7                	jmp    8010615f <sys_chdir+0x6f>
80106188:	90                   	nop
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106190:	e8 3b d4 ff ff       	call   801035d0 <end_op>
    return -1;
80106195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619a:	eb c3                	jmp    8010615f <sys_chdir+0x6f>
8010619c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061a0 <sys_exec>:

int
sys_exec(void)
{
801061a0:	55                   	push   %ebp
801061a1:	89 e5                	mov    %esp,%ebp
801061a3:	57                   	push   %edi
801061a4:	56                   	push   %esi
801061a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801061ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061b2:	50                   	push   %eax
801061b3:	6a 00                	push   $0x0
801061b5:	e8 f6 f4 ff ff       	call   801056b0 <argstr>
801061ba:	83 c4 10             	add    $0x10,%esp
801061bd:	85 c0                	test   %eax,%eax
801061bf:	0f 88 87 00 00 00    	js     8010624c <sys_exec+0xac>
801061c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801061cb:	83 ec 08             	sub    $0x8,%esp
801061ce:	50                   	push   %eax
801061cf:	6a 01                	push   $0x1
801061d1:	e8 2a f4 ff ff       	call   80105600 <argint>
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	85 c0                	test   %eax,%eax
801061db:	78 6f                	js     8010624c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801061dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801061e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801061e8:	68 80 00 00 00       	push   $0x80
801061ed:	6a 00                	push   $0x0
801061ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801061f5:	50                   	push   %eax
801061f6:	e8 05 f1 ff ff       	call   80105300 <memset>
801061fb:	83 c4 10             	add    $0x10,%esp
801061fe:	eb 2c                	jmp    8010622c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106200:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106206:	85 c0                	test   %eax,%eax
80106208:	74 56                	je     80106260 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010620a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106210:	83 ec 08             	sub    $0x8,%esp
80106213:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106216:	52                   	push   %edx
80106217:	50                   	push   %eax
80106218:	e8 73 f3 ff ff       	call   80105590 <fetchstr>
8010621d:	83 c4 10             	add    $0x10,%esp
80106220:	85 c0                	test   %eax,%eax
80106222:	78 28                	js     8010624c <sys_exec+0xac>
  for(i=0;; i++){
80106224:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106227:	83 fb 20             	cmp    $0x20,%ebx
8010622a:	74 20                	je     8010624c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010622c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106232:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106239:	83 ec 08             	sub    $0x8,%esp
8010623c:	57                   	push   %edi
8010623d:	01 f0                	add    %esi,%eax
8010623f:	50                   	push   %eax
80106240:	e8 0b f3 ff ff       	call   80105550 <fetchint>
80106245:	83 c4 10             	add    $0x10,%esp
80106248:	85 c0                	test   %eax,%eax
8010624a:	79 b4                	jns    80106200 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010624c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010624f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106254:	5b                   	pop    %ebx
80106255:	5e                   	pop    %esi
80106256:	5f                   	pop    %edi
80106257:	5d                   	pop    %ebp
80106258:	c3                   	ret    
80106259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106260:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106266:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106269:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106270:	00 00 00 00 
  return exec(path, argv);
80106274:	50                   	push   %eax
80106275:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010627b:	e8 e0 a9 ff ff       	call   80100c60 <exec>
80106280:	83 c4 10             	add    $0x10,%esp
}
80106283:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106286:	5b                   	pop    %ebx
80106287:	5e                   	pop    %esi
80106288:	5f                   	pop    %edi
80106289:	5d                   	pop    %ebp
8010628a:	c3                   	ret    
8010628b:	90                   	nop
8010628c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106290 <sys_pipe>:

int
sys_pipe(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	57                   	push   %edi
80106294:	56                   	push   %esi
80106295:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106296:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106299:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010629c:	6a 08                	push   $0x8
8010629e:	50                   	push   %eax
8010629f:	6a 00                	push   $0x0
801062a1:	e8 aa f3 ff ff       	call   80105650 <argptr>
801062a6:	83 c4 10             	add    $0x10,%esp
801062a9:	85 c0                	test   %eax,%eax
801062ab:	0f 88 ae 00 00 00    	js     8010635f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801062b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062b4:	83 ec 08             	sub    $0x8,%esp
801062b7:	50                   	push   %eax
801062b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062bb:	50                   	push   %eax
801062bc:	e8 3f d9 ff ff       	call   80103c00 <pipealloc>
801062c1:	83 c4 10             	add    $0x10,%esp
801062c4:	85 c0                	test   %eax,%eax
801062c6:	0f 88 93 00 00 00    	js     8010635f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801062cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801062d1:	e8 fa df ff ff       	call   801042d0 <myproc>
801062d6:	eb 10                	jmp    801062e8 <sys_pipe+0x58>
801062d8:	90                   	nop
801062d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801062e0:	83 c3 01             	add    $0x1,%ebx
801062e3:	83 fb 10             	cmp    $0x10,%ebx
801062e6:	74 60                	je     80106348 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801062e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801062ec:	85 f6                	test   %esi,%esi
801062ee:	75 f0                	jne    801062e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801062f0:	8d 73 08             	lea    0x8(%ebx),%esi
801062f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801062fa:	e8 d1 df ff ff       	call   801042d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801062ff:	31 d2                	xor    %edx,%edx
80106301:	eb 0d                	jmp    80106310 <sys_pipe+0x80>
80106303:	90                   	nop
80106304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106308:	83 c2 01             	add    $0x1,%edx
8010630b:	83 fa 10             	cmp    $0x10,%edx
8010630e:	74 28                	je     80106338 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106310:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106314:	85 c9                	test   %ecx,%ecx
80106316:	75 f0                	jne    80106308 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106318:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010631c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010631f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106321:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106324:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106327:	31 c0                	xor    %eax,%eax
}
80106329:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010632c:	5b                   	pop    %ebx
8010632d:	5e                   	pop    %esi
8010632e:	5f                   	pop    %edi
8010632f:	5d                   	pop    %ebp
80106330:	c3                   	ret    
80106331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106338:	e8 93 df ff ff       	call   801042d0 <myproc>
8010633d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106344:	00 
80106345:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106348:	83 ec 0c             	sub    $0xc,%esp
8010634b:	ff 75 e0             	pushl  -0x20(%ebp)
8010634e:	e8 9d ae ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
80106353:	58                   	pop    %eax
80106354:	ff 75 e4             	pushl  -0x1c(%ebp)
80106357:	e8 94 ae ff ff       	call   801011f0 <fileclose>
    return -1;
8010635c:	83 c4 10             	add    $0x10,%esp
8010635f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106364:	eb c3                	jmp    80106329 <sys_pipe+0x99>
80106366:	66 90                	xchg   %ax,%ax
80106368:	66 90                	xchg   %ax,%ax
8010636a:	66 90                	xchg   %ax,%ax
8010636c:	66 90                	xchg   %ax,%ax
8010636e:	66 90                	xchg   %ax,%ax

80106370 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106373:	5d                   	pop    %ebp
  return fork();
80106374:	e9 07 e1 ff ff       	jmp    80104480 <fork>
80106379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106380 <sys_exit>:

int
sys_exit(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 08             	sub    $0x8,%esp
  exit();
80106386:	e8 65 e5 ff ff       	call   801048f0 <exit>
  return 0;  // not reached
}
8010638b:	31 c0                	xor    %eax,%eax
8010638d:	c9                   	leave  
8010638e:	c3                   	ret    
8010638f:	90                   	nop

80106390 <sys_wait>:

int
sys_wait(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106393:	5d                   	pop    %ebp
  return wait();
80106394:	e9 c7 e7 ff ff       	jmp    80104b60 <wait>
80106399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063a0 <sys_kill>:

int
sys_kill(void)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
801063a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063a9:	50                   	push   %eax
801063aa:	6a 00                	push   $0x0
801063ac:	e8 4f f2 ff ff       	call   80105600 <argint>
801063b1:	83 c4 10             	add    $0x10,%esp
801063b4:	85 c0                	test   %eax,%eax
801063b6:	78 18                	js     801063d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801063b8:	83 ec 0c             	sub    $0xc,%esp
801063bb:	ff 75 f4             	pushl  -0xc(%ebp)
801063be:	e8 7d e9 ff ff       	call   80104d40 <kill>
801063c3:	83 c4 10             	add    $0x10,%esp
}
801063c6:	c9                   	leave  
801063c7:	c3                   	ret    
801063c8:	90                   	nop
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063d5:	c9                   	leave  
801063d6:	c3                   	ret    
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063e0 <sys_getpid>:

int
sys_getpid(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801063e6:	e8 e5 de ff ff       	call   801042d0 <myproc>
801063eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801063ee:	c9                   	leave  
801063ef:	c3                   	ret    

801063f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
801063f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801063f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801063fa:	50                   	push   %eax
801063fb:	6a 00                	push   $0x0
801063fd:	e8 fe f1 ff ff       	call   80105600 <argint>
80106402:	83 c4 10             	add    $0x10,%esp
80106405:	85 c0                	test   %eax,%eax
80106407:	78 27                	js     80106430 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106409:	e8 c2 de ff ff       	call   801042d0 <myproc>
  if(growproc(n) < 0)
8010640e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106411:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106413:	ff 75 f4             	pushl  -0xc(%ebp)
80106416:	e8 d5 df ff ff       	call   801043f0 <growproc>
8010641b:	83 c4 10             	add    $0x10,%esp
8010641e:	85 c0                	test   %eax,%eax
80106420:	78 0e                	js     80106430 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106422:	89 d8                	mov    %ebx,%eax
80106424:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106427:	c9                   	leave  
80106428:	c3                   	ret    
80106429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106430:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106435:	eb eb                	jmp    80106422 <sys_sbrk+0x32>
80106437:	89 f6                	mov    %esi,%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106440 <sys_sleep>:

int
sys_sleep(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106444:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106447:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010644a:	50                   	push   %eax
8010644b:	6a 00                	push   $0x0
8010644d:	e8 ae f1 ff ff       	call   80105600 <argint>
80106452:	83 c4 10             	add    $0x10,%esp
80106455:	85 c0                	test   %eax,%eax
80106457:	0f 88 8a 00 00 00    	js     801064e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010645d:	83 ec 0c             	sub    $0xc,%esp
80106460:	68 40 6d 19 80       	push   $0x80196d40
80106465:	e8 86 ed ff ff       	call   801051f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010646a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010646d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106470:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  while(ticks - ticks0 < n){
80106476:	85 d2                	test   %edx,%edx
80106478:	75 27                	jne    801064a1 <sys_sleep+0x61>
8010647a:	eb 54                	jmp    801064d0 <sys_sleep+0x90>
8010647c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106480:	83 ec 08             	sub    $0x8,%esp
80106483:	68 40 6d 19 80       	push   $0x80196d40
80106488:	68 80 75 19 80       	push   $0x80197580
8010648d:	e8 0e e6 ff ff       	call   80104aa0 <sleep>
  while(ticks - ticks0 < n){
80106492:	a1 80 75 19 80       	mov    0x80197580,%eax
80106497:	83 c4 10             	add    $0x10,%esp
8010649a:	29 d8                	sub    %ebx,%eax
8010649c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010649f:	73 2f                	jae    801064d0 <sys_sleep+0x90>
    if(myproc()->killed){
801064a1:	e8 2a de ff ff       	call   801042d0 <myproc>
801064a6:	8b 40 24             	mov    0x24(%eax),%eax
801064a9:	85 c0                	test   %eax,%eax
801064ab:	74 d3                	je     80106480 <sys_sleep+0x40>
      release(&tickslock);
801064ad:	83 ec 0c             	sub    $0xc,%esp
801064b0:	68 40 6d 19 80       	push   $0x80196d40
801064b5:	e8 f6 ed ff ff       	call   801052b0 <release>
      return -1;
801064ba:	83 c4 10             	add    $0x10,%esp
801064bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801064c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064c5:	c9                   	leave  
801064c6:	c3                   	ret    
801064c7:	89 f6                	mov    %esi,%esi
801064c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	68 40 6d 19 80       	push   $0x80196d40
801064d8:	e8 d3 ed ff ff       	call   801052b0 <release>
  return 0;
801064dd:	83 c4 10             	add    $0x10,%esp
801064e0:	31 c0                	xor    %eax,%eax
}
801064e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064e5:	c9                   	leave  
801064e6:	c3                   	ret    
    return -1;
801064e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ec:	eb f4                	jmp    801064e2 <sys_sleep+0xa2>
801064ee:	66 90                	xchg   %ax,%ax

801064f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064f0:	55                   	push   %ebp
801064f1:	89 e5                	mov    %esp,%ebp
801064f3:	53                   	push   %ebx
801064f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801064f7:	68 40 6d 19 80       	push   $0x80196d40
801064fc:	e8 ef ec ff ff       	call   801051f0 <acquire>
  xticks = ticks;
80106501:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
80106507:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
8010650e:	e8 9d ed ff ff       	call   801052b0 <release>
  return xticks;
}
80106513:	89 d8                	mov    %ebx,%eax
80106515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106518:	c9                   	leave  
80106519:	c3                   	ret    
8010651a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106520 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
80106523:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106526:	e8 a5 dd ff ff       	call   801042d0 <myproc>
8010652b:	ba 10 00 00 00       	mov    $0x10,%edx
80106530:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80106536:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106537:	89 d0                	mov    %edx,%eax
}
80106539:	c3                   	ret    
8010653a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106540 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106540:	55                   	push   %ebp
80106541:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80106543:	5d                   	pop    %ebp
  return getTotalFreePages();
80106544:	e9 d7 e8 ff ff       	jmp    80104e20 <getTotalFreePages>

80106549 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106549:	1e                   	push   %ds
  pushl %es
8010654a:	06                   	push   %es
  pushl %fs
8010654b:	0f a0                	push   %fs
  pushl %gs
8010654d:	0f a8                	push   %gs
  pushal
8010654f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106550:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106554:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106556:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106558:	54                   	push   %esp
  call trap
80106559:	e8 c2 00 00 00       	call   80106620 <trap>
  addl $4, %esp
8010655e:	83 c4 04             	add    $0x4,%esp

80106561 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106561:	61                   	popa   
  popl %gs
80106562:	0f a9                	pop    %gs
  popl %fs
80106564:	0f a1                	pop    %fs
  popl %es
80106566:	07                   	pop    %es
  popl %ds
80106567:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106568:	83 c4 08             	add    $0x8,%esp
  iret
8010656b:	cf                   	iret   
8010656c:	66 90                	xchg   %ax,%ax
8010656e:	66 90                	xchg   %ax,%ax

80106570 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106570:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106571:	31 c0                	xor    %eax,%eax
{
80106573:	89 e5                	mov    %esp,%ebp
80106575:	83 ec 08             	sub    $0x8,%esp
80106578:	90                   	nop
80106579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106580:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106587:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
8010658e:	08 00 00 8e 
80106592:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
80106599:	80 
8010659a:	c1 ea 10             	shr    $0x10,%edx
8010659d:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
801065a4:	80 
  for(i = 0; i < 256; i++)
801065a5:	83 c0 01             	add    $0x1,%eax
801065a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065ad:	75 d1                	jne    80106580 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065af:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
801065b4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065b7:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
801065be:	00 00 ef 
  initlock(&tickslock, "time");
801065c1:	68 9d 98 10 80       	push   $0x8010989d
801065c6:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065cb:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
801065d1:	c1 e8 10             	shr    $0x10,%eax
801065d4:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
801065da:	e8 d1 ea ff ff       	call   801050b0 <initlock>
}
801065df:	83 c4 10             	add    $0x10,%esp
801065e2:	c9                   	leave  
801065e3:	c3                   	ret    
801065e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801065f0 <idtinit>:

void
idtinit(void)
{
801065f0:	55                   	push   %ebp
  pd[0] = size-1;
801065f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065f6:	89 e5                	mov    %esp,%ebp
801065f8:	83 ec 10             	sub    $0x10,%esp
801065fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065ff:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
80106604:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106608:	c1 e8 10             	shr    $0x10,%eax
8010660b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010660f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106612:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106615:	c9                   	leave  
80106616:	c3                   	ret    
80106617:	89 f6                	mov    %esi,%esi
80106619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106620 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106620:	55                   	push   %ebp
80106621:	89 e5                	mov    %esp,%ebp
80106623:	57                   	push   %edi
80106624:	56                   	push   %esi
80106625:	53                   	push   %ebx
80106626:	83 ec 1c             	sub    $0x1c,%esp
80106629:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
8010662c:	e8 9f dc ff ff       	call   801042d0 <myproc>
80106631:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106633:	8b 47 30             	mov    0x30(%edi),%eax
80106636:	83 f8 40             	cmp    $0x40,%eax
80106639:	0f 84 e9 00 00 00    	je     80106728 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010663f:	83 e8 0e             	sub    $0xe,%eax
80106642:	83 f8 31             	cmp    $0x31,%eax
80106645:	77 09                	ja     80106650 <trap+0x30>
80106647:	ff 24 85 44 99 10 80 	jmp    *-0x7fef66bc(,%eax,4)
8010664e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106650:	e8 7b dc ff ff       	call   801042d0 <myproc>
80106655:	85 c0                	test   %eax,%eax
80106657:	0f 84 27 02 00 00    	je     80106884 <trap+0x264>
8010665d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106661:	0f 84 1d 02 00 00    	je     80106884 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106667:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010666a:	8b 57 38             	mov    0x38(%edi),%edx
8010666d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106670:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106673:	e8 38 dc ff ff       	call   801042b0 <cpuid>
80106678:	8b 77 34             	mov    0x34(%edi),%esi
8010667b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010667e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106681:	e8 4a dc ff ff       	call   801042d0 <myproc>
80106686:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106689:	e8 42 dc ff ff       	call   801042d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010668e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106691:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106694:	51                   	push   %ecx
80106695:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106696:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106699:	ff 75 e4             	pushl  -0x1c(%ebp)
8010669c:	56                   	push   %esi
8010669d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010669e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066a1:	52                   	push   %edx
801066a2:	ff 70 10             	pushl  0x10(%eax)
801066a5:	68 00 99 10 80       	push   $0x80109900
801066aa:	e8 b1 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066af:	83 c4 20             	add    $0x20,%esp
801066b2:	e8 19 dc ff ff       	call   801042d0 <myproc>
801066b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801066be:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066c0:	e8 0b dc ff ff       	call   801042d0 <myproc>
801066c5:	85 c0                	test   %eax,%eax
801066c7:	74 1d                	je     801066e6 <trap+0xc6>
801066c9:	e8 02 dc ff ff       	call   801042d0 <myproc>
801066ce:	8b 50 24             	mov    0x24(%eax),%edx
801066d1:	85 d2                	test   %edx,%edx
801066d3:	74 11                	je     801066e6 <trap+0xc6>
801066d5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066d9:	83 e0 03             	and    $0x3,%eax
801066dc:	66 83 f8 03          	cmp    $0x3,%ax
801066e0:	0f 84 5a 01 00 00    	je     80106840 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801066e6:	e8 e5 db ff ff       	call   801042d0 <myproc>
801066eb:	85 c0                	test   %eax,%eax
801066ed:	74 0b                	je     801066fa <trap+0xda>
801066ef:	e8 dc db ff ff       	call   801042d0 <myproc>
801066f4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801066f8:	74 5e                	je     80106758 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066fa:	e8 d1 db ff ff       	call   801042d0 <myproc>
801066ff:	85 c0                	test   %eax,%eax
80106701:	74 19                	je     8010671c <trap+0xfc>
80106703:	e8 c8 db ff ff       	call   801042d0 <myproc>
80106708:	8b 40 24             	mov    0x24(%eax),%eax
8010670b:	85 c0                	test   %eax,%eax
8010670d:	74 0d                	je     8010671c <trap+0xfc>
8010670f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106713:	83 e0 03             	and    $0x3,%eax
80106716:	66 83 f8 03          	cmp    $0x3,%ax
8010671a:	74 2b                	je     80106747 <trap+0x127>
    exit();
8010671c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010671f:	5b                   	pop    %ebx
80106720:	5e                   	pop    %esi
80106721:	5f                   	pop    %edi
80106722:	5d                   	pop    %ebp
80106723:	c3                   	ret    
80106724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106728:	8b 73 24             	mov    0x24(%ebx),%esi
8010672b:	85 f6                	test   %esi,%esi
8010672d:	0f 85 fd 00 00 00    	jne    80106830 <trap+0x210>
    curproc->tf = tf;
80106733:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106736:	e8 b5 ef ff ff       	call   801056f0 <syscall>
    if(myproc()->killed)
8010673b:	e8 90 db ff ff       	call   801042d0 <myproc>
80106740:	8b 58 24             	mov    0x24(%eax),%ebx
80106743:	85 db                	test   %ebx,%ebx
80106745:	74 d5                	je     8010671c <trap+0xfc>
80106747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010674a:	5b                   	pop    %ebx
8010674b:	5e                   	pop    %esi
8010674c:	5f                   	pop    %edi
8010674d:	5d                   	pop    %ebp
      exit();
8010674e:	e9 9d e1 ff ff       	jmp    801048f0 <exit>
80106753:	90                   	nop
80106754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106758:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010675c:	75 9c                	jne    801066fa <trap+0xda>
      if(myproc()->pid > 2) 
8010675e:	e8 6d db ff ff       	call   801042d0 <myproc>
      yield();
80106763:	e8 e8 e2 ff ff       	call   80104a50 <yield>
80106768:	eb 90                	jmp    801066fa <trap+0xda>
8010676a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
80106770:	e8 5b db ff ff       	call   801042d0 <myproc>
80106775:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106779:	0f 8e 41 ff ff ff    	jle    801066c0 <trap+0xa0>
    pagefault();
8010677f:	e8 4c 1f 00 00       	call   801086d0 <pagefault>
      if(curproc->killed) {
80106784:	8b 4b 24             	mov    0x24(%ebx),%ecx
80106787:	85 c9                	test   %ecx,%ecx
80106789:	0f 84 31 ff ff ff    	je     801066c0 <trap+0xa0>
        exit();
8010678f:	e8 5c e1 ff ff       	call   801048f0 <exit>
80106794:	e9 27 ff ff ff       	jmp    801066c0 <trap+0xa0>
80106799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801067a0:	e8 0b db ff ff       	call   801042b0 <cpuid>
801067a5:	85 c0                	test   %eax,%eax
801067a7:	0f 84 a3 00 00 00    	je     80106850 <trap+0x230>
    lapiceoi();
801067ad:	e8 5e c9 ff ff       	call   80103110 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067b2:	e8 19 db ff ff       	call   801042d0 <myproc>
801067b7:	85 c0                	test   %eax,%eax
801067b9:	0f 85 0a ff ff ff    	jne    801066c9 <trap+0xa9>
801067bf:	e9 22 ff ff ff       	jmp    801066e6 <trap+0xc6>
801067c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801067c8:	e8 03 c8 ff ff       	call   80102fd0 <kbdintr>
    lapiceoi();
801067cd:	e8 3e c9 ff ff       	call   80103110 <lapiceoi>
    break;
801067d2:	e9 e9 fe ff ff       	jmp    801066c0 <trap+0xa0>
801067d7:	89 f6                	mov    %esi,%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
801067e0:	e8 3b 02 00 00       	call   80106a20 <uartintr>
    lapiceoi();
801067e5:	e8 26 c9 ff ff       	call   80103110 <lapiceoi>
    break;
801067ea:	e9 d1 fe ff ff       	jmp    801066c0 <trap+0xa0>
801067ef:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067f0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801067f4:	8b 77 38             	mov    0x38(%edi),%esi
801067f7:	e8 b4 da ff ff       	call   801042b0 <cpuid>
801067fc:	56                   	push   %esi
801067fd:	53                   	push   %ebx
801067fe:	50                   	push   %eax
801067ff:	68 a8 98 10 80       	push   $0x801098a8
80106804:	e8 57 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106809:	e8 02 c9 ff ff       	call   80103110 <lapiceoi>
    break;
8010680e:	83 c4 10             	add    $0x10,%esp
80106811:	e9 aa fe ff ff       	jmp    801066c0 <trap+0xa0>
80106816:	8d 76 00             	lea    0x0(%esi),%esi
80106819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106820:	e8 9b bf ff ff       	call   801027c0 <ideintr>
80106825:	eb 86                	jmp    801067ad <trap+0x18d>
80106827:	89 f6                	mov    %esi,%esi
80106829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106830:	e8 bb e0 ff ff       	call   801048f0 <exit>
80106835:	e9 f9 fe ff ff       	jmp    80106733 <trap+0x113>
8010683a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106840:	e8 ab e0 ff ff       	call   801048f0 <exit>
80106845:	e9 9c fe ff ff       	jmp    801066e6 <trap+0xc6>
8010684a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106850:	83 ec 0c             	sub    $0xc,%esp
80106853:	68 40 6d 19 80       	push   $0x80196d40
80106858:	e8 93 e9 ff ff       	call   801051f0 <acquire>
      wakeup(&ticks);
8010685d:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
80106864:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
8010686b:	e8 70 e4 ff ff       	call   80104ce0 <wakeup>
      release(&tickslock);
80106870:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
80106877:	e8 34 ea ff ff       	call   801052b0 <release>
8010687c:	83 c4 10             	add    $0x10,%esp
8010687f:	e9 29 ff ff ff       	jmp    801067ad <trap+0x18d>
80106884:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106887:	8b 5f 38             	mov    0x38(%edi),%ebx
8010688a:	e8 21 da ff ff       	call   801042b0 <cpuid>
8010688f:	83 ec 0c             	sub    $0xc,%esp
80106892:	56                   	push   %esi
80106893:	53                   	push   %ebx
80106894:	50                   	push   %eax
80106895:	ff 77 30             	pushl  0x30(%edi)
80106898:	68 cc 98 10 80       	push   $0x801098cc
8010689d:	e8 be 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
801068a2:	83 c4 14             	add    $0x14,%esp
801068a5:	68 a2 98 10 80       	push   $0x801098a2
801068aa:	e8 e1 9a ff ff       	call   80100390 <panic>
801068af:	90                   	nop

801068b0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801068b0:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
801068b5:	55                   	push   %ebp
801068b6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801068b8:	85 c0                	test   %eax,%eax
801068ba:	74 1c                	je     801068d8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
801068c1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801068c2:	a8 01                	test   $0x1,%al
801068c4:	74 12                	je     801068d8 <uartgetc+0x28>
801068c6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068cb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801068cc:	0f b6 c0             	movzbl %al,%eax
}
801068cf:	5d                   	pop    %ebp
801068d0:	c3                   	ret    
801068d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801068d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068dd:	5d                   	pop    %ebp
801068de:	c3                   	ret    
801068df:	90                   	nop

801068e0 <uartputc.part.0>:
uartputc(int c)
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	57                   	push   %edi
801068e4:	56                   	push   %esi
801068e5:	53                   	push   %ebx
801068e6:	89 c7                	mov    %eax,%edi
801068e8:	bb 80 00 00 00       	mov    $0x80,%ebx
801068ed:	be fd 03 00 00       	mov    $0x3fd,%esi
801068f2:	83 ec 0c             	sub    $0xc,%esp
801068f5:	eb 1b                	jmp    80106912 <uartputc.part.0+0x32>
801068f7:	89 f6                	mov    %esi,%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106900:	83 ec 0c             	sub    $0xc,%esp
80106903:	6a 0a                	push   $0xa
80106905:	e8 26 c8 ff ff       	call   80103130 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010690a:	83 c4 10             	add    $0x10,%esp
8010690d:	83 eb 01             	sub    $0x1,%ebx
80106910:	74 07                	je     80106919 <uartputc.part.0+0x39>
80106912:	89 f2                	mov    %esi,%edx
80106914:	ec                   	in     (%dx),%al
80106915:	a8 20                	test   $0x20,%al
80106917:	74 e7                	je     80106900 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106919:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010691e:	89 f8                	mov    %edi,%eax
80106920:	ee                   	out    %al,(%dx)
}
80106921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106924:	5b                   	pop    %ebx
80106925:	5e                   	pop    %esi
80106926:	5f                   	pop    %edi
80106927:	5d                   	pop    %ebp
80106928:	c3                   	ret    
80106929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106930 <uartinit>:
{
80106930:	55                   	push   %ebp
80106931:	31 c9                	xor    %ecx,%ecx
80106933:	89 c8                	mov    %ecx,%eax
80106935:	89 e5                	mov    %esp,%ebp
80106937:	57                   	push   %edi
80106938:	56                   	push   %esi
80106939:	53                   	push   %ebx
8010693a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010693f:	89 da                	mov    %ebx,%edx
80106941:	83 ec 0c             	sub    $0xc,%esp
80106944:	ee                   	out    %al,(%dx)
80106945:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010694a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010694f:	89 fa                	mov    %edi,%edx
80106951:	ee                   	out    %al,(%dx)
80106952:	b8 0c 00 00 00       	mov    $0xc,%eax
80106957:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010695c:	ee                   	out    %al,(%dx)
8010695d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106962:	89 c8                	mov    %ecx,%eax
80106964:	89 f2                	mov    %esi,%edx
80106966:	ee                   	out    %al,(%dx)
80106967:	b8 03 00 00 00       	mov    $0x3,%eax
8010696c:	89 fa                	mov    %edi,%edx
8010696e:	ee                   	out    %al,(%dx)
8010696f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106974:	89 c8                	mov    %ecx,%eax
80106976:	ee                   	out    %al,(%dx)
80106977:	b8 01 00 00 00       	mov    $0x1,%eax
8010697c:	89 f2                	mov    %esi,%edx
8010697e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010697f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106984:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106985:	3c ff                	cmp    $0xff,%al
80106987:	74 5a                	je     801069e3 <uartinit+0xb3>
  uart = 1;
80106989:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
80106990:	00 00 00 
80106993:	89 da                	mov    %ebx,%edx
80106995:	ec                   	in     (%dx),%al
80106996:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010699b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010699c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010699f:	bb 0c 9a 10 80       	mov    $0x80109a0c,%ebx
  ioapicenable(IRQ_COM1, 0);
801069a4:	6a 00                	push   $0x0
801069a6:	6a 04                	push   $0x4
801069a8:	e8 63 c0 ff ff       	call   80102a10 <ioapicenable>
801069ad:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801069b0:	b8 78 00 00 00       	mov    $0x78,%eax
801069b5:	eb 13                	jmp    801069ca <uartinit+0x9a>
801069b7:	89 f6                	mov    %esi,%esi
801069b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069c0:	83 c3 01             	add    $0x1,%ebx
801069c3:	0f be 03             	movsbl (%ebx),%eax
801069c6:	84 c0                	test   %al,%al
801069c8:	74 19                	je     801069e3 <uartinit+0xb3>
  if(!uart)
801069ca:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
801069d0:	85 d2                	test   %edx,%edx
801069d2:	74 ec                	je     801069c0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801069d4:	83 c3 01             	add    $0x1,%ebx
801069d7:	e8 04 ff ff ff       	call   801068e0 <uartputc.part.0>
801069dc:	0f be 03             	movsbl (%ebx),%eax
801069df:	84 c0                	test   %al,%al
801069e1:	75 e7                	jne    801069ca <uartinit+0x9a>
}
801069e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e6:	5b                   	pop    %ebx
801069e7:	5e                   	pop    %esi
801069e8:	5f                   	pop    %edi
801069e9:	5d                   	pop    %ebp
801069ea:	c3                   	ret    
801069eb:	90                   	nop
801069ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069f0 <uartputc>:
  if(!uart)
801069f0:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
801069f6:	55                   	push   %ebp
801069f7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801069f9:	85 d2                	test   %edx,%edx
{
801069fb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801069fe:	74 10                	je     80106a10 <uartputc+0x20>
}
80106a00:	5d                   	pop    %ebp
80106a01:	e9 da fe ff ff       	jmp    801068e0 <uartputc.part.0>
80106a06:	8d 76 00             	lea    0x0(%esi),%esi
80106a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a10:	5d                   	pop    %ebp
80106a11:	c3                   	ret    
80106a12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a20 <uartintr>:

void
uartintr(void)
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106a26:	68 b0 68 10 80       	push   $0x801068b0
80106a2b:	e8 e0 9d ff ff       	call   80100810 <consoleintr>
}
80106a30:	83 c4 10             	add    $0x10,%esp
80106a33:	c9                   	leave  
80106a34:	c3                   	ret    

80106a35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a35:	6a 00                	push   $0x0
  pushl $0
80106a37:	6a 00                	push   $0x0
  jmp alltraps
80106a39:	e9 0b fb ff ff       	jmp    80106549 <alltraps>

80106a3e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a3e:	6a 00                	push   $0x0
  pushl $1
80106a40:	6a 01                	push   $0x1
  jmp alltraps
80106a42:	e9 02 fb ff ff       	jmp    80106549 <alltraps>

80106a47 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $2
80106a49:	6a 02                	push   $0x2
  jmp alltraps
80106a4b:	e9 f9 fa ff ff       	jmp    80106549 <alltraps>

80106a50 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a50:	6a 00                	push   $0x0
  pushl $3
80106a52:	6a 03                	push   $0x3
  jmp alltraps
80106a54:	e9 f0 fa ff ff       	jmp    80106549 <alltraps>

80106a59 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a59:	6a 00                	push   $0x0
  pushl $4
80106a5b:	6a 04                	push   $0x4
  jmp alltraps
80106a5d:	e9 e7 fa ff ff       	jmp    80106549 <alltraps>

80106a62 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a62:	6a 00                	push   $0x0
  pushl $5
80106a64:	6a 05                	push   $0x5
  jmp alltraps
80106a66:	e9 de fa ff ff       	jmp    80106549 <alltraps>

80106a6b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $6
80106a6d:	6a 06                	push   $0x6
  jmp alltraps
80106a6f:	e9 d5 fa ff ff       	jmp    80106549 <alltraps>

80106a74 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a74:	6a 00                	push   $0x0
  pushl $7
80106a76:	6a 07                	push   $0x7
  jmp alltraps
80106a78:	e9 cc fa ff ff       	jmp    80106549 <alltraps>

80106a7d <vector8>:
.globl vector8
vector8:
  pushl $8
80106a7d:	6a 08                	push   $0x8
  jmp alltraps
80106a7f:	e9 c5 fa ff ff       	jmp    80106549 <alltraps>

80106a84 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $9
80106a86:	6a 09                	push   $0x9
  jmp alltraps
80106a88:	e9 bc fa ff ff       	jmp    80106549 <alltraps>

80106a8d <vector10>:
.globl vector10
vector10:
  pushl $10
80106a8d:	6a 0a                	push   $0xa
  jmp alltraps
80106a8f:	e9 b5 fa ff ff       	jmp    80106549 <alltraps>

80106a94 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a94:	6a 0b                	push   $0xb
  jmp alltraps
80106a96:	e9 ae fa ff ff       	jmp    80106549 <alltraps>

80106a9b <vector12>:
.globl vector12
vector12:
  pushl $12
80106a9b:	6a 0c                	push   $0xc
  jmp alltraps
80106a9d:	e9 a7 fa ff ff       	jmp    80106549 <alltraps>

80106aa2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106aa2:	6a 0d                	push   $0xd
  jmp alltraps
80106aa4:	e9 a0 fa ff ff       	jmp    80106549 <alltraps>

80106aa9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106aa9:	6a 0e                	push   $0xe
  jmp alltraps
80106aab:	e9 99 fa ff ff       	jmp    80106549 <alltraps>

80106ab0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $15
80106ab2:	6a 0f                	push   $0xf
  jmp alltraps
80106ab4:	e9 90 fa ff ff       	jmp    80106549 <alltraps>

80106ab9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $16
80106abb:	6a 10                	push   $0x10
  jmp alltraps
80106abd:	e9 87 fa ff ff       	jmp    80106549 <alltraps>

80106ac2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106ac2:	6a 11                	push   $0x11
  jmp alltraps
80106ac4:	e9 80 fa ff ff       	jmp    80106549 <alltraps>

80106ac9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106ac9:	6a 00                	push   $0x0
  pushl $18
80106acb:	6a 12                	push   $0x12
  jmp alltraps
80106acd:	e9 77 fa ff ff       	jmp    80106549 <alltraps>

80106ad2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ad2:	6a 00                	push   $0x0
  pushl $19
80106ad4:	6a 13                	push   $0x13
  jmp alltraps
80106ad6:	e9 6e fa ff ff       	jmp    80106549 <alltraps>

80106adb <vector20>:
.globl vector20
vector20:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $20
80106add:	6a 14                	push   $0x14
  jmp alltraps
80106adf:	e9 65 fa ff ff       	jmp    80106549 <alltraps>

80106ae4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $21
80106ae6:	6a 15                	push   $0x15
  jmp alltraps
80106ae8:	e9 5c fa ff ff       	jmp    80106549 <alltraps>

80106aed <vector22>:
.globl vector22
vector22:
  pushl $0
80106aed:	6a 00                	push   $0x0
  pushl $22
80106aef:	6a 16                	push   $0x16
  jmp alltraps
80106af1:	e9 53 fa ff ff       	jmp    80106549 <alltraps>

80106af6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106af6:	6a 00                	push   $0x0
  pushl $23
80106af8:	6a 17                	push   $0x17
  jmp alltraps
80106afa:	e9 4a fa ff ff       	jmp    80106549 <alltraps>

80106aff <vector24>:
.globl vector24
vector24:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $24
80106b01:	6a 18                	push   $0x18
  jmp alltraps
80106b03:	e9 41 fa ff ff       	jmp    80106549 <alltraps>

80106b08 <vector25>:
.globl vector25
vector25:
  pushl $0
80106b08:	6a 00                	push   $0x0
  pushl $25
80106b0a:	6a 19                	push   $0x19
  jmp alltraps
80106b0c:	e9 38 fa ff ff       	jmp    80106549 <alltraps>

80106b11 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b11:	6a 00                	push   $0x0
  pushl $26
80106b13:	6a 1a                	push   $0x1a
  jmp alltraps
80106b15:	e9 2f fa ff ff       	jmp    80106549 <alltraps>

80106b1a <vector27>:
.globl vector27
vector27:
  pushl $0
80106b1a:	6a 00                	push   $0x0
  pushl $27
80106b1c:	6a 1b                	push   $0x1b
  jmp alltraps
80106b1e:	e9 26 fa ff ff       	jmp    80106549 <alltraps>

80106b23 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $28
80106b25:	6a 1c                	push   $0x1c
  jmp alltraps
80106b27:	e9 1d fa ff ff       	jmp    80106549 <alltraps>

80106b2c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b2c:	6a 00                	push   $0x0
  pushl $29
80106b2e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b30:	e9 14 fa ff ff       	jmp    80106549 <alltraps>

80106b35 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b35:	6a 00                	push   $0x0
  pushl $30
80106b37:	6a 1e                	push   $0x1e
  jmp alltraps
80106b39:	e9 0b fa ff ff       	jmp    80106549 <alltraps>

80106b3e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b3e:	6a 00                	push   $0x0
  pushl $31
80106b40:	6a 1f                	push   $0x1f
  jmp alltraps
80106b42:	e9 02 fa ff ff       	jmp    80106549 <alltraps>

80106b47 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $32
80106b49:	6a 20                	push   $0x20
  jmp alltraps
80106b4b:	e9 f9 f9 ff ff       	jmp    80106549 <alltraps>

80106b50 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b50:	6a 00                	push   $0x0
  pushl $33
80106b52:	6a 21                	push   $0x21
  jmp alltraps
80106b54:	e9 f0 f9 ff ff       	jmp    80106549 <alltraps>

80106b59 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b59:	6a 00                	push   $0x0
  pushl $34
80106b5b:	6a 22                	push   $0x22
  jmp alltraps
80106b5d:	e9 e7 f9 ff ff       	jmp    80106549 <alltraps>

80106b62 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b62:	6a 00                	push   $0x0
  pushl $35
80106b64:	6a 23                	push   $0x23
  jmp alltraps
80106b66:	e9 de f9 ff ff       	jmp    80106549 <alltraps>

80106b6b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $36
80106b6d:	6a 24                	push   $0x24
  jmp alltraps
80106b6f:	e9 d5 f9 ff ff       	jmp    80106549 <alltraps>

80106b74 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b74:	6a 00                	push   $0x0
  pushl $37
80106b76:	6a 25                	push   $0x25
  jmp alltraps
80106b78:	e9 cc f9 ff ff       	jmp    80106549 <alltraps>

80106b7d <vector38>:
.globl vector38
vector38:
  pushl $0
80106b7d:	6a 00                	push   $0x0
  pushl $38
80106b7f:	6a 26                	push   $0x26
  jmp alltraps
80106b81:	e9 c3 f9 ff ff       	jmp    80106549 <alltraps>

80106b86 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b86:	6a 00                	push   $0x0
  pushl $39
80106b88:	6a 27                	push   $0x27
  jmp alltraps
80106b8a:	e9 ba f9 ff ff       	jmp    80106549 <alltraps>

80106b8f <vector40>:
.globl vector40
vector40:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $40
80106b91:	6a 28                	push   $0x28
  jmp alltraps
80106b93:	e9 b1 f9 ff ff       	jmp    80106549 <alltraps>

80106b98 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b98:	6a 00                	push   $0x0
  pushl $41
80106b9a:	6a 29                	push   $0x29
  jmp alltraps
80106b9c:	e9 a8 f9 ff ff       	jmp    80106549 <alltraps>

80106ba1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ba1:	6a 00                	push   $0x0
  pushl $42
80106ba3:	6a 2a                	push   $0x2a
  jmp alltraps
80106ba5:	e9 9f f9 ff ff       	jmp    80106549 <alltraps>

80106baa <vector43>:
.globl vector43
vector43:
  pushl $0
80106baa:	6a 00                	push   $0x0
  pushl $43
80106bac:	6a 2b                	push   $0x2b
  jmp alltraps
80106bae:	e9 96 f9 ff ff       	jmp    80106549 <alltraps>

80106bb3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $44
80106bb5:	6a 2c                	push   $0x2c
  jmp alltraps
80106bb7:	e9 8d f9 ff ff       	jmp    80106549 <alltraps>

80106bbc <vector45>:
.globl vector45
vector45:
  pushl $0
80106bbc:	6a 00                	push   $0x0
  pushl $45
80106bbe:	6a 2d                	push   $0x2d
  jmp alltraps
80106bc0:	e9 84 f9 ff ff       	jmp    80106549 <alltraps>

80106bc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106bc5:	6a 00                	push   $0x0
  pushl $46
80106bc7:	6a 2e                	push   $0x2e
  jmp alltraps
80106bc9:	e9 7b f9 ff ff       	jmp    80106549 <alltraps>

80106bce <vector47>:
.globl vector47
vector47:
  pushl $0
80106bce:	6a 00                	push   $0x0
  pushl $47
80106bd0:	6a 2f                	push   $0x2f
  jmp alltraps
80106bd2:	e9 72 f9 ff ff       	jmp    80106549 <alltraps>

80106bd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $48
80106bd9:	6a 30                	push   $0x30
  jmp alltraps
80106bdb:	e9 69 f9 ff ff       	jmp    80106549 <alltraps>

80106be0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106be0:	6a 00                	push   $0x0
  pushl $49
80106be2:	6a 31                	push   $0x31
  jmp alltraps
80106be4:	e9 60 f9 ff ff       	jmp    80106549 <alltraps>

80106be9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106be9:	6a 00                	push   $0x0
  pushl $50
80106beb:	6a 32                	push   $0x32
  jmp alltraps
80106bed:	e9 57 f9 ff ff       	jmp    80106549 <alltraps>

80106bf2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bf2:	6a 00                	push   $0x0
  pushl $51
80106bf4:	6a 33                	push   $0x33
  jmp alltraps
80106bf6:	e9 4e f9 ff ff       	jmp    80106549 <alltraps>

80106bfb <vector52>:
.globl vector52
vector52:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $52
80106bfd:	6a 34                	push   $0x34
  jmp alltraps
80106bff:	e9 45 f9 ff ff       	jmp    80106549 <alltraps>

80106c04 <vector53>:
.globl vector53
vector53:
  pushl $0
80106c04:	6a 00                	push   $0x0
  pushl $53
80106c06:	6a 35                	push   $0x35
  jmp alltraps
80106c08:	e9 3c f9 ff ff       	jmp    80106549 <alltraps>

80106c0d <vector54>:
.globl vector54
vector54:
  pushl $0
80106c0d:	6a 00                	push   $0x0
  pushl $54
80106c0f:	6a 36                	push   $0x36
  jmp alltraps
80106c11:	e9 33 f9 ff ff       	jmp    80106549 <alltraps>

80106c16 <vector55>:
.globl vector55
vector55:
  pushl $0
80106c16:	6a 00                	push   $0x0
  pushl $55
80106c18:	6a 37                	push   $0x37
  jmp alltraps
80106c1a:	e9 2a f9 ff ff       	jmp    80106549 <alltraps>

80106c1f <vector56>:
.globl vector56
vector56:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $56
80106c21:	6a 38                	push   $0x38
  jmp alltraps
80106c23:	e9 21 f9 ff ff       	jmp    80106549 <alltraps>

80106c28 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c28:	6a 00                	push   $0x0
  pushl $57
80106c2a:	6a 39                	push   $0x39
  jmp alltraps
80106c2c:	e9 18 f9 ff ff       	jmp    80106549 <alltraps>

80106c31 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c31:	6a 00                	push   $0x0
  pushl $58
80106c33:	6a 3a                	push   $0x3a
  jmp alltraps
80106c35:	e9 0f f9 ff ff       	jmp    80106549 <alltraps>

80106c3a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c3a:	6a 00                	push   $0x0
  pushl $59
80106c3c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c3e:	e9 06 f9 ff ff       	jmp    80106549 <alltraps>

80106c43 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $60
80106c45:	6a 3c                	push   $0x3c
  jmp alltraps
80106c47:	e9 fd f8 ff ff       	jmp    80106549 <alltraps>

80106c4c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c4c:	6a 00                	push   $0x0
  pushl $61
80106c4e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c50:	e9 f4 f8 ff ff       	jmp    80106549 <alltraps>

80106c55 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c55:	6a 00                	push   $0x0
  pushl $62
80106c57:	6a 3e                	push   $0x3e
  jmp alltraps
80106c59:	e9 eb f8 ff ff       	jmp    80106549 <alltraps>

80106c5e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c5e:	6a 00                	push   $0x0
  pushl $63
80106c60:	6a 3f                	push   $0x3f
  jmp alltraps
80106c62:	e9 e2 f8 ff ff       	jmp    80106549 <alltraps>

80106c67 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $64
80106c69:	6a 40                	push   $0x40
  jmp alltraps
80106c6b:	e9 d9 f8 ff ff       	jmp    80106549 <alltraps>

80106c70 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c70:	6a 00                	push   $0x0
  pushl $65
80106c72:	6a 41                	push   $0x41
  jmp alltraps
80106c74:	e9 d0 f8 ff ff       	jmp    80106549 <alltraps>

80106c79 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c79:	6a 00                	push   $0x0
  pushl $66
80106c7b:	6a 42                	push   $0x42
  jmp alltraps
80106c7d:	e9 c7 f8 ff ff       	jmp    80106549 <alltraps>

80106c82 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c82:	6a 00                	push   $0x0
  pushl $67
80106c84:	6a 43                	push   $0x43
  jmp alltraps
80106c86:	e9 be f8 ff ff       	jmp    80106549 <alltraps>

80106c8b <vector68>:
.globl vector68
vector68:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $68
80106c8d:	6a 44                	push   $0x44
  jmp alltraps
80106c8f:	e9 b5 f8 ff ff       	jmp    80106549 <alltraps>

80106c94 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c94:	6a 00                	push   $0x0
  pushl $69
80106c96:	6a 45                	push   $0x45
  jmp alltraps
80106c98:	e9 ac f8 ff ff       	jmp    80106549 <alltraps>

80106c9d <vector70>:
.globl vector70
vector70:
  pushl $0
80106c9d:	6a 00                	push   $0x0
  pushl $70
80106c9f:	6a 46                	push   $0x46
  jmp alltraps
80106ca1:	e9 a3 f8 ff ff       	jmp    80106549 <alltraps>

80106ca6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ca6:	6a 00                	push   $0x0
  pushl $71
80106ca8:	6a 47                	push   $0x47
  jmp alltraps
80106caa:	e9 9a f8 ff ff       	jmp    80106549 <alltraps>

80106caf <vector72>:
.globl vector72
vector72:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $72
80106cb1:	6a 48                	push   $0x48
  jmp alltraps
80106cb3:	e9 91 f8 ff ff       	jmp    80106549 <alltraps>

80106cb8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106cb8:	6a 00                	push   $0x0
  pushl $73
80106cba:	6a 49                	push   $0x49
  jmp alltraps
80106cbc:	e9 88 f8 ff ff       	jmp    80106549 <alltraps>

80106cc1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106cc1:	6a 00                	push   $0x0
  pushl $74
80106cc3:	6a 4a                	push   $0x4a
  jmp alltraps
80106cc5:	e9 7f f8 ff ff       	jmp    80106549 <alltraps>

80106cca <vector75>:
.globl vector75
vector75:
  pushl $0
80106cca:	6a 00                	push   $0x0
  pushl $75
80106ccc:	6a 4b                	push   $0x4b
  jmp alltraps
80106cce:	e9 76 f8 ff ff       	jmp    80106549 <alltraps>

80106cd3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $76
80106cd5:	6a 4c                	push   $0x4c
  jmp alltraps
80106cd7:	e9 6d f8 ff ff       	jmp    80106549 <alltraps>

80106cdc <vector77>:
.globl vector77
vector77:
  pushl $0
80106cdc:	6a 00                	push   $0x0
  pushl $77
80106cde:	6a 4d                	push   $0x4d
  jmp alltraps
80106ce0:	e9 64 f8 ff ff       	jmp    80106549 <alltraps>

80106ce5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ce5:	6a 00                	push   $0x0
  pushl $78
80106ce7:	6a 4e                	push   $0x4e
  jmp alltraps
80106ce9:	e9 5b f8 ff ff       	jmp    80106549 <alltraps>

80106cee <vector79>:
.globl vector79
vector79:
  pushl $0
80106cee:	6a 00                	push   $0x0
  pushl $79
80106cf0:	6a 4f                	push   $0x4f
  jmp alltraps
80106cf2:	e9 52 f8 ff ff       	jmp    80106549 <alltraps>

80106cf7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $80
80106cf9:	6a 50                	push   $0x50
  jmp alltraps
80106cfb:	e9 49 f8 ff ff       	jmp    80106549 <alltraps>

80106d00 <vector81>:
.globl vector81
vector81:
  pushl $0
80106d00:	6a 00                	push   $0x0
  pushl $81
80106d02:	6a 51                	push   $0x51
  jmp alltraps
80106d04:	e9 40 f8 ff ff       	jmp    80106549 <alltraps>

80106d09 <vector82>:
.globl vector82
vector82:
  pushl $0
80106d09:	6a 00                	push   $0x0
  pushl $82
80106d0b:	6a 52                	push   $0x52
  jmp alltraps
80106d0d:	e9 37 f8 ff ff       	jmp    80106549 <alltraps>

80106d12 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d12:	6a 00                	push   $0x0
  pushl $83
80106d14:	6a 53                	push   $0x53
  jmp alltraps
80106d16:	e9 2e f8 ff ff       	jmp    80106549 <alltraps>

80106d1b <vector84>:
.globl vector84
vector84:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $84
80106d1d:	6a 54                	push   $0x54
  jmp alltraps
80106d1f:	e9 25 f8 ff ff       	jmp    80106549 <alltraps>

80106d24 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $85
80106d26:	6a 55                	push   $0x55
  jmp alltraps
80106d28:	e9 1c f8 ff ff       	jmp    80106549 <alltraps>

80106d2d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d2d:	6a 00                	push   $0x0
  pushl $86
80106d2f:	6a 56                	push   $0x56
  jmp alltraps
80106d31:	e9 13 f8 ff ff       	jmp    80106549 <alltraps>

80106d36 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d36:	6a 00                	push   $0x0
  pushl $87
80106d38:	6a 57                	push   $0x57
  jmp alltraps
80106d3a:	e9 0a f8 ff ff       	jmp    80106549 <alltraps>

80106d3f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $88
80106d41:	6a 58                	push   $0x58
  jmp alltraps
80106d43:	e9 01 f8 ff ff       	jmp    80106549 <alltraps>

80106d48 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d48:	6a 00                	push   $0x0
  pushl $89
80106d4a:	6a 59                	push   $0x59
  jmp alltraps
80106d4c:	e9 f8 f7 ff ff       	jmp    80106549 <alltraps>

80106d51 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d51:	6a 00                	push   $0x0
  pushl $90
80106d53:	6a 5a                	push   $0x5a
  jmp alltraps
80106d55:	e9 ef f7 ff ff       	jmp    80106549 <alltraps>

80106d5a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d5a:	6a 00                	push   $0x0
  pushl $91
80106d5c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d5e:	e9 e6 f7 ff ff       	jmp    80106549 <alltraps>

80106d63 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $92
80106d65:	6a 5c                	push   $0x5c
  jmp alltraps
80106d67:	e9 dd f7 ff ff       	jmp    80106549 <alltraps>

80106d6c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d6c:	6a 00                	push   $0x0
  pushl $93
80106d6e:	6a 5d                	push   $0x5d
  jmp alltraps
80106d70:	e9 d4 f7 ff ff       	jmp    80106549 <alltraps>

80106d75 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d75:	6a 00                	push   $0x0
  pushl $94
80106d77:	6a 5e                	push   $0x5e
  jmp alltraps
80106d79:	e9 cb f7 ff ff       	jmp    80106549 <alltraps>

80106d7e <vector95>:
.globl vector95
vector95:
  pushl $0
80106d7e:	6a 00                	push   $0x0
  pushl $95
80106d80:	6a 5f                	push   $0x5f
  jmp alltraps
80106d82:	e9 c2 f7 ff ff       	jmp    80106549 <alltraps>

80106d87 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $96
80106d89:	6a 60                	push   $0x60
  jmp alltraps
80106d8b:	e9 b9 f7 ff ff       	jmp    80106549 <alltraps>

80106d90 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d90:	6a 00                	push   $0x0
  pushl $97
80106d92:	6a 61                	push   $0x61
  jmp alltraps
80106d94:	e9 b0 f7 ff ff       	jmp    80106549 <alltraps>

80106d99 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d99:	6a 00                	push   $0x0
  pushl $98
80106d9b:	6a 62                	push   $0x62
  jmp alltraps
80106d9d:	e9 a7 f7 ff ff       	jmp    80106549 <alltraps>

80106da2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106da2:	6a 00                	push   $0x0
  pushl $99
80106da4:	6a 63                	push   $0x63
  jmp alltraps
80106da6:	e9 9e f7 ff ff       	jmp    80106549 <alltraps>

80106dab <vector100>:
.globl vector100
vector100:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $100
80106dad:	6a 64                	push   $0x64
  jmp alltraps
80106daf:	e9 95 f7 ff ff       	jmp    80106549 <alltraps>

80106db4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106db4:	6a 00                	push   $0x0
  pushl $101
80106db6:	6a 65                	push   $0x65
  jmp alltraps
80106db8:	e9 8c f7 ff ff       	jmp    80106549 <alltraps>

80106dbd <vector102>:
.globl vector102
vector102:
  pushl $0
80106dbd:	6a 00                	push   $0x0
  pushl $102
80106dbf:	6a 66                	push   $0x66
  jmp alltraps
80106dc1:	e9 83 f7 ff ff       	jmp    80106549 <alltraps>

80106dc6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106dc6:	6a 00                	push   $0x0
  pushl $103
80106dc8:	6a 67                	push   $0x67
  jmp alltraps
80106dca:	e9 7a f7 ff ff       	jmp    80106549 <alltraps>

80106dcf <vector104>:
.globl vector104
vector104:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $104
80106dd1:	6a 68                	push   $0x68
  jmp alltraps
80106dd3:	e9 71 f7 ff ff       	jmp    80106549 <alltraps>

80106dd8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106dd8:	6a 00                	push   $0x0
  pushl $105
80106dda:	6a 69                	push   $0x69
  jmp alltraps
80106ddc:	e9 68 f7 ff ff       	jmp    80106549 <alltraps>

80106de1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106de1:	6a 00                	push   $0x0
  pushl $106
80106de3:	6a 6a                	push   $0x6a
  jmp alltraps
80106de5:	e9 5f f7 ff ff       	jmp    80106549 <alltraps>

80106dea <vector107>:
.globl vector107
vector107:
  pushl $0
80106dea:	6a 00                	push   $0x0
  pushl $107
80106dec:	6a 6b                	push   $0x6b
  jmp alltraps
80106dee:	e9 56 f7 ff ff       	jmp    80106549 <alltraps>

80106df3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $108
80106df5:	6a 6c                	push   $0x6c
  jmp alltraps
80106df7:	e9 4d f7 ff ff       	jmp    80106549 <alltraps>

80106dfc <vector109>:
.globl vector109
vector109:
  pushl $0
80106dfc:	6a 00                	push   $0x0
  pushl $109
80106dfe:	6a 6d                	push   $0x6d
  jmp alltraps
80106e00:	e9 44 f7 ff ff       	jmp    80106549 <alltraps>

80106e05 <vector110>:
.globl vector110
vector110:
  pushl $0
80106e05:	6a 00                	push   $0x0
  pushl $110
80106e07:	6a 6e                	push   $0x6e
  jmp alltraps
80106e09:	e9 3b f7 ff ff       	jmp    80106549 <alltraps>

80106e0e <vector111>:
.globl vector111
vector111:
  pushl $0
80106e0e:	6a 00                	push   $0x0
  pushl $111
80106e10:	6a 6f                	push   $0x6f
  jmp alltraps
80106e12:	e9 32 f7 ff ff       	jmp    80106549 <alltraps>

80106e17 <vector112>:
.globl vector112
vector112:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $112
80106e19:	6a 70                	push   $0x70
  jmp alltraps
80106e1b:	e9 29 f7 ff ff       	jmp    80106549 <alltraps>

80106e20 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e20:	6a 00                	push   $0x0
  pushl $113
80106e22:	6a 71                	push   $0x71
  jmp alltraps
80106e24:	e9 20 f7 ff ff       	jmp    80106549 <alltraps>

80106e29 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e29:	6a 00                	push   $0x0
  pushl $114
80106e2b:	6a 72                	push   $0x72
  jmp alltraps
80106e2d:	e9 17 f7 ff ff       	jmp    80106549 <alltraps>

80106e32 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e32:	6a 00                	push   $0x0
  pushl $115
80106e34:	6a 73                	push   $0x73
  jmp alltraps
80106e36:	e9 0e f7 ff ff       	jmp    80106549 <alltraps>

80106e3b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $116
80106e3d:	6a 74                	push   $0x74
  jmp alltraps
80106e3f:	e9 05 f7 ff ff       	jmp    80106549 <alltraps>

80106e44 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e44:	6a 00                	push   $0x0
  pushl $117
80106e46:	6a 75                	push   $0x75
  jmp alltraps
80106e48:	e9 fc f6 ff ff       	jmp    80106549 <alltraps>

80106e4d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e4d:	6a 00                	push   $0x0
  pushl $118
80106e4f:	6a 76                	push   $0x76
  jmp alltraps
80106e51:	e9 f3 f6 ff ff       	jmp    80106549 <alltraps>

80106e56 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e56:	6a 00                	push   $0x0
  pushl $119
80106e58:	6a 77                	push   $0x77
  jmp alltraps
80106e5a:	e9 ea f6 ff ff       	jmp    80106549 <alltraps>

80106e5f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $120
80106e61:	6a 78                	push   $0x78
  jmp alltraps
80106e63:	e9 e1 f6 ff ff       	jmp    80106549 <alltraps>

80106e68 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e68:	6a 00                	push   $0x0
  pushl $121
80106e6a:	6a 79                	push   $0x79
  jmp alltraps
80106e6c:	e9 d8 f6 ff ff       	jmp    80106549 <alltraps>

80106e71 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e71:	6a 00                	push   $0x0
  pushl $122
80106e73:	6a 7a                	push   $0x7a
  jmp alltraps
80106e75:	e9 cf f6 ff ff       	jmp    80106549 <alltraps>

80106e7a <vector123>:
.globl vector123
vector123:
  pushl $0
80106e7a:	6a 00                	push   $0x0
  pushl $123
80106e7c:	6a 7b                	push   $0x7b
  jmp alltraps
80106e7e:	e9 c6 f6 ff ff       	jmp    80106549 <alltraps>

80106e83 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $124
80106e85:	6a 7c                	push   $0x7c
  jmp alltraps
80106e87:	e9 bd f6 ff ff       	jmp    80106549 <alltraps>

80106e8c <vector125>:
.globl vector125
vector125:
  pushl $0
80106e8c:	6a 00                	push   $0x0
  pushl $125
80106e8e:	6a 7d                	push   $0x7d
  jmp alltraps
80106e90:	e9 b4 f6 ff ff       	jmp    80106549 <alltraps>

80106e95 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e95:	6a 00                	push   $0x0
  pushl $126
80106e97:	6a 7e                	push   $0x7e
  jmp alltraps
80106e99:	e9 ab f6 ff ff       	jmp    80106549 <alltraps>

80106e9e <vector127>:
.globl vector127
vector127:
  pushl $0
80106e9e:	6a 00                	push   $0x0
  pushl $127
80106ea0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ea2:	e9 a2 f6 ff ff       	jmp    80106549 <alltraps>

80106ea7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $128
80106ea9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106eae:	e9 96 f6 ff ff       	jmp    80106549 <alltraps>

80106eb3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $129
80106eb5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106eba:	e9 8a f6 ff ff       	jmp    80106549 <alltraps>

80106ebf <vector130>:
.globl vector130
vector130:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $130
80106ec1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ec6:	e9 7e f6 ff ff       	jmp    80106549 <alltraps>

80106ecb <vector131>:
.globl vector131
vector131:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $131
80106ecd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106ed2:	e9 72 f6 ff ff       	jmp    80106549 <alltraps>

80106ed7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $132
80106ed9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ede:	e9 66 f6 ff ff       	jmp    80106549 <alltraps>

80106ee3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $133
80106ee5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106eea:	e9 5a f6 ff ff       	jmp    80106549 <alltraps>

80106eef <vector134>:
.globl vector134
vector134:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $134
80106ef1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ef6:	e9 4e f6 ff ff       	jmp    80106549 <alltraps>

80106efb <vector135>:
.globl vector135
vector135:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $135
80106efd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106f02:	e9 42 f6 ff ff       	jmp    80106549 <alltraps>

80106f07 <vector136>:
.globl vector136
vector136:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $136
80106f09:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f0e:	e9 36 f6 ff ff       	jmp    80106549 <alltraps>

80106f13 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $137
80106f15:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f1a:	e9 2a f6 ff ff       	jmp    80106549 <alltraps>

80106f1f <vector138>:
.globl vector138
vector138:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $138
80106f21:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f26:	e9 1e f6 ff ff       	jmp    80106549 <alltraps>

80106f2b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $139
80106f2d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f32:	e9 12 f6 ff ff       	jmp    80106549 <alltraps>

80106f37 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $140
80106f39:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f3e:	e9 06 f6 ff ff       	jmp    80106549 <alltraps>

80106f43 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $141
80106f45:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f4a:	e9 fa f5 ff ff       	jmp    80106549 <alltraps>

80106f4f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $142
80106f51:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f56:	e9 ee f5 ff ff       	jmp    80106549 <alltraps>

80106f5b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $143
80106f5d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f62:	e9 e2 f5 ff ff       	jmp    80106549 <alltraps>

80106f67 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $144
80106f69:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f6e:	e9 d6 f5 ff ff       	jmp    80106549 <alltraps>

80106f73 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $145
80106f75:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f7a:	e9 ca f5 ff ff       	jmp    80106549 <alltraps>

80106f7f <vector146>:
.globl vector146
vector146:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $146
80106f81:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f86:	e9 be f5 ff ff       	jmp    80106549 <alltraps>

80106f8b <vector147>:
.globl vector147
vector147:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $147
80106f8d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f92:	e9 b2 f5 ff ff       	jmp    80106549 <alltraps>

80106f97 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $148
80106f99:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f9e:	e9 a6 f5 ff ff       	jmp    80106549 <alltraps>

80106fa3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $149
80106fa5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106faa:	e9 9a f5 ff ff       	jmp    80106549 <alltraps>

80106faf <vector150>:
.globl vector150
vector150:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $150
80106fb1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106fb6:	e9 8e f5 ff ff       	jmp    80106549 <alltraps>

80106fbb <vector151>:
.globl vector151
vector151:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $151
80106fbd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fc2:	e9 82 f5 ff ff       	jmp    80106549 <alltraps>

80106fc7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $152
80106fc9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fce:	e9 76 f5 ff ff       	jmp    80106549 <alltraps>

80106fd3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $153
80106fd5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fda:	e9 6a f5 ff ff       	jmp    80106549 <alltraps>

80106fdf <vector154>:
.globl vector154
vector154:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $154
80106fe1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fe6:	e9 5e f5 ff ff       	jmp    80106549 <alltraps>

80106feb <vector155>:
.globl vector155
vector155:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $155
80106fed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ff2:	e9 52 f5 ff ff       	jmp    80106549 <alltraps>

80106ff7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $156
80106ff9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ffe:	e9 46 f5 ff ff       	jmp    80106549 <alltraps>

80107003 <vector157>:
.globl vector157
vector157:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $157
80107005:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010700a:	e9 3a f5 ff ff       	jmp    80106549 <alltraps>

8010700f <vector158>:
.globl vector158
vector158:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $158
80107011:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107016:	e9 2e f5 ff ff       	jmp    80106549 <alltraps>

8010701b <vector159>:
.globl vector159
vector159:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $159
8010701d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107022:	e9 22 f5 ff ff       	jmp    80106549 <alltraps>

80107027 <vector160>:
.globl vector160
vector160:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $160
80107029:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010702e:	e9 16 f5 ff ff       	jmp    80106549 <alltraps>

80107033 <vector161>:
.globl vector161
vector161:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $161
80107035:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010703a:	e9 0a f5 ff ff       	jmp    80106549 <alltraps>

8010703f <vector162>:
.globl vector162
vector162:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $162
80107041:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107046:	e9 fe f4 ff ff       	jmp    80106549 <alltraps>

8010704b <vector163>:
.globl vector163
vector163:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $163
8010704d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107052:	e9 f2 f4 ff ff       	jmp    80106549 <alltraps>

80107057 <vector164>:
.globl vector164
vector164:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $164
80107059:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010705e:	e9 e6 f4 ff ff       	jmp    80106549 <alltraps>

80107063 <vector165>:
.globl vector165
vector165:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $165
80107065:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010706a:	e9 da f4 ff ff       	jmp    80106549 <alltraps>

8010706f <vector166>:
.globl vector166
vector166:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $166
80107071:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107076:	e9 ce f4 ff ff       	jmp    80106549 <alltraps>

8010707b <vector167>:
.globl vector167
vector167:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $167
8010707d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107082:	e9 c2 f4 ff ff       	jmp    80106549 <alltraps>

80107087 <vector168>:
.globl vector168
vector168:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $168
80107089:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010708e:	e9 b6 f4 ff ff       	jmp    80106549 <alltraps>

80107093 <vector169>:
.globl vector169
vector169:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $169
80107095:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010709a:	e9 aa f4 ff ff       	jmp    80106549 <alltraps>

8010709f <vector170>:
.globl vector170
vector170:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $170
801070a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801070a6:	e9 9e f4 ff ff       	jmp    80106549 <alltraps>

801070ab <vector171>:
.globl vector171
vector171:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $171
801070ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801070b2:	e9 92 f4 ff ff       	jmp    80106549 <alltraps>

801070b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $172
801070b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070be:	e9 86 f4 ff ff       	jmp    80106549 <alltraps>

801070c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $173
801070c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070ca:	e9 7a f4 ff ff       	jmp    80106549 <alltraps>

801070cf <vector174>:
.globl vector174
vector174:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $174
801070d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070d6:	e9 6e f4 ff ff       	jmp    80106549 <alltraps>

801070db <vector175>:
.globl vector175
vector175:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $175
801070dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070e2:	e9 62 f4 ff ff       	jmp    80106549 <alltraps>

801070e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $176
801070e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070ee:	e9 56 f4 ff ff       	jmp    80106549 <alltraps>

801070f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $177
801070f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070fa:	e9 4a f4 ff ff       	jmp    80106549 <alltraps>

801070ff <vector178>:
.globl vector178
vector178:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $178
80107101:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107106:	e9 3e f4 ff ff       	jmp    80106549 <alltraps>

8010710b <vector179>:
.globl vector179
vector179:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $179
8010710d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107112:	e9 32 f4 ff ff       	jmp    80106549 <alltraps>

80107117 <vector180>:
.globl vector180
vector180:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $180
80107119:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010711e:	e9 26 f4 ff ff       	jmp    80106549 <alltraps>

80107123 <vector181>:
.globl vector181
vector181:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $181
80107125:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010712a:	e9 1a f4 ff ff       	jmp    80106549 <alltraps>

8010712f <vector182>:
.globl vector182
vector182:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $182
80107131:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107136:	e9 0e f4 ff ff       	jmp    80106549 <alltraps>

8010713b <vector183>:
.globl vector183
vector183:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $183
8010713d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107142:	e9 02 f4 ff ff       	jmp    80106549 <alltraps>

80107147 <vector184>:
.globl vector184
vector184:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $184
80107149:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010714e:	e9 f6 f3 ff ff       	jmp    80106549 <alltraps>

80107153 <vector185>:
.globl vector185
vector185:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $185
80107155:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010715a:	e9 ea f3 ff ff       	jmp    80106549 <alltraps>

8010715f <vector186>:
.globl vector186
vector186:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $186
80107161:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107166:	e9 de f3 ff ff       	jmp    80106549 <alltraps>

8010716b <vector187>:
.globl vector187
vector187:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $187
8010716d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107172:	e9 d2 f3 ff ff       	jmp    80106549 <alltraps>

80107177 <vector188>:
.globl vector188
vector188:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $188
80107179:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010717e:	e9 c6 f3 ff ff       	jmp    80106549 <alltraps>

80107183 <vector189>:
.globl vector189
vector189:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $189
80107185:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010718a:	e9 ba f3 ff ff       	jmp    80106549 <alltraps>

8010718f <vector190>:
.globl vector190
vector190:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $190
80107191:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107196:	e9 ae f3 ff ff       	jmp    80106549 <alltraps>

8010719b <vector191>:
.globl vector191
vector191:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $191
8010719d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801071a2:	e9 a2 f3 ff ff       	jmp    80106549 <alltraps>

801071a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $192
801071a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801071ae:	e9 96 f3 ff ff       	jmp    80106549 <alltraps>

801071b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $193
801071b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071ba:	e9 8a f3 ff ff       	jmp    80106549 <alltraps>

801071bf <vector194>:
.globl vector194
vector194:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $194
801071c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071c6:	e9 7e f3 ff ff       	jmp    80106549 <alltraps>

801071cb <vector195>:
.globl vector195
vector195:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $195
801071cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071d2:	e9 72 f3 ff ff       	jmp    80106549 <alltraps>

801071d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $196
801071d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071de:	e9 66 f3 ff ff       	jmp    80106549 <alltraps>

801071e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $197
801071e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071ea:	e9 5a f3 ff ff       	jmp    80106549 <alltraps>

801071ef <vector198>:
.globl vector198
vector198:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $198
801071f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071f6:	e9 4e f3 ff ff       	jmp    80106549 <alltraps>

801071fb <vector199>:
.globl vector199
vector199:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $199
801071fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107202:	e9 42 f3 ff ff       	jmp    80106549 <alltraps>

80107207 <vector200>:
.globl vector200
vector200:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $200
80107209:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010720e:	e9 36 f3 ff ff       	jmp    80106549 <alltraps>

80107213 <vector201>:
.globl vector201
vector201:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $201
80107215:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010721a:	e9 2a f3 ff ff       	jmp    80106549 <alltraps>

8010721f <vector202>:
.globl vector202
vector202:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $202
80107221:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107226:	e9 1e f3 ff ff       	jmp    80106549 <alltraps>

8010722b <vector203>:
.globl vector203
vector203:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $203
8010722d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107232:	e9 12 f3 ff ff       	jmp    80106549 <alltraps>

80107237 <vector204>:
.globl vector204
vector204:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $204
80107239:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010723e:	e9 06 f3 ff ff       	jmp    80106549 <alltraps>

80107243 <vector205>:
.globl vector205
vector205:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $205
80107245:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010724a:	e9 fa f2 ff ff       	jmp    80106549 <alltraps>

8010724f <vector206>:
.globl vector206
vector206:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $206
80107251:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107256:	e9 ee f2 ff ff       	jmp    80106549 <alltraps>

8010725b <vector207>:
.globl vector207
vector207:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $207
8010725d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107262:	e9 e2 f2 ff ff       	jmp    80106549 <alltraps>

80107267 <vector208>:
.globl vector208
vector208:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $208
80107269:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010726e:	e9 d6 f2 ff ff       	jmp    80106549 <alltraps>

80107273 <vector209>:
.globl vector209
vector209:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $209
80107275:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010727a:	e9 ca f2 ff ff       	jmp    80106549 <alltraps>

8010727f <vector210>:
.globl vector210
vector210:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $210
80107281:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107286:	e9 be f2 ff ff       	jmp    80106549 <alltraps>

8010728b <vector211>:
.globl vector211
vector211:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $211
8010728d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107292:	e9 b2 f2 ff ff       	jmp    80106549 <alltraps>

80107297 <vector212>:
.globl vector212
vector212:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $212
80107299:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010729e:	e9 a6 f2 ff ff       	jmp    80106549 <alltraps>

801072a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $213
801072a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801072aa:	e9 9a f2 ff ff       	jmp    80106549 <alltraps>

801072af <vector214>:
.globl vector214
vector214:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $214
801072b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801072b6:	e9 8e f2 ff ff       	jmp    80106549 <alltraps>

801072bb <vector215>:
.globl vector215
vector215:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $215
801072bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072c2:	e9 82 f2 ff ff       	jmp    80106549 <alltraps>

801072c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $216
801072c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072ce:	e9 76 f2 ff ff       	jmp    80106549 <alltraps>

801072d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $217
801072d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072da:	e9 6a f2 ff ff       	jmp    80106549 <alltraps>

801072df <vector218>:
.globl vector218
vector218:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $218
801072e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072e6:	e9 5e f2 ff ff       	jmp    80106549 <alltraps>

801072eb <vector219>:
.globl vector219
vector219:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $219
801072ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072f2:	e9 52 f2 ff ff       	jmp    80106549 <alltraps>

801072f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $220
801072f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072fe:	e9 46 f2 ff ff       	jmp    80106549 <alltraps>

80107303 <vector221>:
.globl vector221
vector221:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $221
80107305:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010730a:	e9 3a f2 ff ff       	jmp    80106549 <alltraps>

8010730f <vector222>:
.globl vector222
vector222:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $222
80107311:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107316:	e9 2e f2 ff ff       	jmp    80106549 <alltraps>

8010731b <vector223>:
.globl vector223
vector223:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $223
8010731d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107322:	e9 22 f2 ff ff       	jmp    80106549 <alltraps>

80107327 <vector224>:
.globl vector224
vector224:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $224
80107329:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010732e:	e9 16 f2 ff ff       	jmp    80106549 <alltraps>

80107333 <vector225>:
.globl vector225
vector225:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $225
80107335:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010733a:	e9 0a f2 ff ff       	jmp    80106549 <alltraps>

8010733f <vector226>:
.globl vector226
vector226:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $226
80107341:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107346:	e9 fe f1 ff ff       	jmp    80106549 <alltraps>

8010734b <vector227>:
.globl vector227
vector227:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $227
8010734d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107352:	e9 f2 f1 ff ff       	jmp    80106549 <alltraps>

80107357 <vector228>:
.globl vector228
vector228:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $228
80107359:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010735e:	e9 e6 f1 ff ff       	jmp    80106549 <alltraps>

80107363 <vector229>:
.globl vector229
vector229:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $229
80107365:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010736a:	e9 da f1 ff ff       	jmp    80106549 <alltraps>

8010736f <vector230>:
.globl vector230
vector230:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $230
80107371:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107376:	e9 ce f1 ff ff       	jmp    80106549 <alltraps>

8010737b <vector231>:
.globl vector231
vector231:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $231
8010737d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107382:	e9 c2 f1 ff ff       	jmp    80106549 <alltraps>

80107387 <vector232>:
.globl vector232
vector232:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $232
80107389:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010738e:	e9 b6 f1 ff ff       	jmp    80106549 <alltraps>

80107393 <vector233>:
.globl vector233
vector233:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $233
80107395:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010739a:	e9 aa f1 ff ff       	jmp    80106549 <alltraps>

8010739f <vector234>:
.globl vector234
vector234:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $234
801073a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801073a6:	e9 9e f1 ff ff       	jmp    80106549 <alltraps>

801073ab <vector235>:
.globl vector235
vector235:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $235
801073ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801073b2:	e9 92 f1 ff ff       	jmp    80106549 <alltraps>

801073b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $236
801073b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073be:	e9 86 f1 ff ff       	jmp    80106549 <alltraps>

801073c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $237
801073c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073ca:	e9 7a f1 ff ff       	jmp    80106549 <alltraps>

801073cf <vector238>:
.globl vector238
vector238:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $238
801073d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073d6:	e9 6e f1 ff ff       	jmp    80106549 <alltraps>

801073db <vector239>:
.globl vector239
vector239:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $239
801073dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073e2:	e9 62 f1 ff ff       	jmp    80106549 <alltraps>

801073e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $240
801073e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073ee:	e9 56 f1 ff ff       	jmp    80106549 <alltraps>

801073f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $241
801073f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073fa:	e9 4a f1 ff ff       	jmp    80106549 <alltraps>

801073ff <vector242>:
.globl vector242
vector242:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $242
80107401:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107406:	e9 3e f1 ff ff       	jmp    80106549 <alltraps>

8010740b <vector243>:
.globl vector243
vector243:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $243
8010740d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107412:	e9 32 f1 ff ff       	jmp    80106549 <alltraps>

80107417 <vector244>:
.globl vector244
vector244:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $244
80107419:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010741e:	e9 26 f1 ff ff       	jmp    80106549 <alltraps>

80107423 <vector245>:
.globl vector245
vector245:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $245
80107425:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010742a:	e9 1a f1 ff ff       	jmp    80106549 <alltraps>

8010742f <vector246>:
.globl vector246
vector246:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $246
80107431:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107436:	e9 0e f1 ff ff       	jmp    80106549 <alltraps>

8010743b <vector247>:
.globl vector247
vector247:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $247
8010743d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107442:	e9 02 f1 ff ff       	jmp    80106549 <alltraps>

80107447 <vector248>:
.globl vector248
vector248:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $248
80107449:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010744e:	e9 f6 f0 ff ff       	jmp    80106549 <alltraps>

80107453 <vector249>:
.globl vector249
vector249:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $249
80107455:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010745a:	e9 ea f0 ff ff       	jmp    80106549 <alltraps>

8010745f <vector250>:
.globl vector250
vector250:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $250
80107461:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107466:	e9 de f0 ff ff       	jmp    80106549 <alltraps>

8010746b <vector251>:
.globl vector251
vector251:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $251
8010746d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107472:	e9 d2 f0 ff ff       	jmp    80106549 <alltraps>

80107477 <vector252>:
.globl vector252
vector252:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $252
80107479:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010747e:	e9 c6 f0 ff ff       	jmp    80106549 <alltraps>

80107483 <vector253>:
.globl vector253
vector253:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $253
80107485:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010748a:	e9 ba f0 ff ff       	jmp    80106549 <alltraps>

8010748f <vector254>:
.globl vector254
vector254:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $254
80107491:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107496:	e9 ae f0 ff ff       	jmp    80106549 <alltraps>

8010749b <vector255>:
.globl vector255
vector255:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $255
8010749d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801074a2:	e9 a2 f0 ff ff       	jmp    80106549 <alltraps>
801074a7:	66 90                	xchg   %ax,%ax
801074a9:	66 90                	xchg   %ax,%ax
801074ab:	66 90                	xchg   %ax,%ax
801074ad:	66 90                	xchg   %ax,%ax
801074af:	90                   	nop

801074b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801074b6:	89 d3                	mov    %edx,%ebx
{
801074b8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801074ba:	c1 eb 16             	shr    $0x16,%ebx
801074bd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801074c0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801074c3:	8b 06                	mov    (%esi),%eax
801074c5:	a8 01                	test   $0x1,%al
801074c7:	74 27                	je     801074f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074ce:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801074d4:	c1 ef 0a             	shr    $0xa,%edi
}
801074d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801074da:	89 fa                	mov    %edi,%edx
801074dc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074e2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801074e5:	5b                   	pop    %ebx
801074e6:	5e                   	pop    %esi
801074e7:	5f                   	pop    %edi
801074e8:	5d                   	pop    %ebp
801074e9:	c3                   	ret    
801074ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074f0:	85 c9                	test   %ecx,%ecx
801074f2:	74 2c                	je     80107520 <walkpgdir+0x70>
801074f4:	e8 47 b8 ff ff       	call   80102d40 <kalloc>
801074f9:	85 c0                	test   %eax,%eax
801074fb:	89 c3                	mov    %eax,%ebx
801074fd:	74 21                	je     80107520 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074ff:	83 ec 04             	sub    $0x4,%esp
80107502:	68 00 10 00 00       	push   $0x1000
80107507:	6a 00                	push   $0x0
80107509:	50                   	push   %eax
8010750a:	e8 f1 dd ff ff       	call   80105300 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010750f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107515:	83 c4 10             	add    $0x10,%esp
80107518:	83 c8 07             	or     $0x7,%eax
8010751b:	89 06                	mov    %eax,(%esi)
8010751d:	eb b5                	jmp    801074d4 <walkpgdir+0x24>
8010751f:	90                   	nop
}
80107520:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107530 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107536:	89 d3                	mov    %edx,%ebx
80107538:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010753e:	83 ec 1c             	sub    $0x1c,%esp
80107541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107544:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107548:	8b 7d 08             	mov    0x8(%ebp),%edi
8010754b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107550:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107553:	8b 45 0c             	mov    0xc(%ebp),%eax
80107556:	29 df                	sub    %ebx,%edi
80107558:	83 c8 01             	or     $0x1,%eax
8010755b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010755e:	eb 15                	jmp    80107575 <mappages+0x45>
    if(*pte & PTE_P)
80107560:	f6 00 01             	testb  $0x1,(%eax)
80107563:	75 45                	jne    801075aa <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107565:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107568:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010756b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010756d:	74 31                	je     801075a0 <mappages+0x70>
      break;
    a += PGSIZE;
8010756f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107578:	b9 01 00 00 00       	mov    $0x1,%ecx
8010757d:	89 da                	mov    %ebx,%edx
8010757f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107582:	e8 29 ff ff ff       	call   801074b0 <walkpgdir>
80107587:	85 c0                	test   %eax,%eax
80107589:	75 d5                	jne    80107560 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010758b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010758e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107593:	5b                   	pop    %ebx
80107594:	5e                   	pop    %esi
80107595:	5f                   	pop    %edi
80107596:	5d                   	pop    %ebp
80107597:	c3                   	ret    
80107598:	90                   	nop
80107599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075a3:	31 c0                	xor    %eax,%eax
}
801075a5:	5b                   	pop    %ebx
801075a6:	5e                   	pop    %esi
801075a7:	5f                   	pop    %edi
801075a8:	5d                   	pop    %ebp
801075a9:	c3                   	ret    
      panic("remap");
801075aa:	83 ec 0c             	sub    $0xc,%esp
801075ad:	68 14 9a 10 80       	push   $0x80109a14
801075b2:	e8 d9 8d ff ff       	call   80100390 <panic>
801075b7:	89 f6                	mov    %esi,%esi
801075b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075c0 <printlist>:
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	56                   	push   %esi
801075c4:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
801075c5:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
801075ca:	83 ec 0c             	sub    $0xc,%esp
801075cd:	68 1a 9a 10 80       	push   $0x80109a1a
801075d2:	e8 89 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
801075d7:	e8 f4 cc ff ff       	call   801042d0 <myproc>
801075dc:	83 c4 10             	add    $0x10,%esp
801075df:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
801075e5:	eb 0e                	jmp    801075f5 <printlist+0x35>
801075e7:	89 f6                	mov    %esi,%esi
801075e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
801075f0:	83 ee 01             	sub    $0x1,%esi
801075f3:	74 19                	je     8010760e <printlist+0x4e>
    cprintf("%d -> ", curr->off);
801075f5:	83 ec 08             	sub    $0x8,%esp
801075f8:	ff 33                	pushl  (%ebx)
801075fa:	68 2a 9a 10 80       	push   $0x80109a2a
801075ff:	e8 5c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107604:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107607:	83 c4 10             	add    $0x10,%esp
8010760a:	85 db                	test   %ebx,%ebx
8010760c:	75 e2                	jne    801075f0 <printlist+0x30>
  cprintf("\n");
8010760e:	83 ec 0c             	sub    $0xc,%esp
80107611:	68 40 9b 10 80       	push   $0x80109b40
80107616:	e8 45 90 ff ff       	call   80100660 <cprintf>
}
8010761b:	83 c4 10             	add    $0x10,%esp
8010761e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107621:	5b                   	pop    %ebx
80107622:	5e                   	pop    %esi
80107623:	5d                   	pop    %ebp
80107624:	c3                   	ret    
80107625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107630 <printaq>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	53                   	push   %ebx
80107634:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
80107637:	68 31 9a 10 80       	push   $0x80109a31
8010763c:	e8 1f 90 ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107641:	e8 8a cc ff ff       	call   801042d0 <myproc>
80107646:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010764c:	8b 58 08             	mov    0x8(%eax),%ebx
8010764f:	e8 7c cc ff ff       	call   801042d0 <myproc>
80107654:	83 c4 0c             	add    $0xc,%esp
80107657:	53                   	push   %ebx
80107658:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010765e:	ff 70 08             	pushl  0x8(%eax)
80107661:	68 43 9a 10 80       	push   $0x80109a43
80107666:	e8 f5 8f ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010766b:	e8 60 cc ff ff       	call   801042d0 <myproc>
80107670:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107676:	83 c4 10             	add    $0x10,%esp
80107679:	8b 50 04             	mov    0x4(%eax),%edx
8010767c:	85 d2                	test   %edx,%edx
8010767e:	74 68                	je     801076e8 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
80107680:	e8 4b cc ff ff       	call   801042d0 <myproc>
80107685:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010768b:	85 db                	test   %ebx,%ebx
8010768d:	74 1a                	je     801076a9 <printaq+0x79>
8010768f:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
80107690:	83 ec 08             	sub    $0x8,%esp
80107693:	ff 73 08             	pushl  0x8(%ebx)
80107696:	68 61 9a 10 80       	push   $0x80109a61
8010769b:	e8 c0 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801076a0:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
801076a2:	83 c4 10             	add    $0x10,%esp
801076a5:	85 db                	test   %ebx,%ebx
801076a7:	75 e7                	jne    80107690 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
801076a9:	e8 22 cc ff ff       	call   801042d0 <myproc>
801076ae:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
801076b4:	8b 00                	mov    (%eax),%eax
801076b6:	85 c0                	test   %eax,%eax
801076b8:	74 16                	je     801076d0 <printaq+0xa0>
  cprintf("\n");
801076ba:	83 ec 0c             	sub    $0xc,%esp
801076bd:	68 40 9b 10 80       	push   $0x80109b40
801076c2:	e8 99 8f ff ff       	call   80100660 <cprintf>
}
801076c7:	83 c4 10             	add    $0x10,%esp
801076ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076cd:	c9                   	leave  
801076ce:	c3                   	ret    
801076cf:	90                   	nop
    cprintf("null <-> ");
801076d0:	83 ec 0c             	sub    $0xc,%esp
801076d3:	68 57 9a 10 80       	push   $0x80109a57
801076d8:	e8 83 8f ff ff       	call   80100660 <cprintf>
801076dd:	83 c4 10             	add    $0x10,%esp
801076e0:	eb d8                	jmp    801076ba <printaq+0x8a>
801076e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
801076e8:	83 ec 0c             	sub    $0xc,%esp
801076eb:	68 57 9a 10 80       	push   $0x80109a57
801076f0:	e8 6b 8f ff ff       	call   80100660 <cprintf>
801076f5:	83 c4 10             	add    $0x10,%esp
801076f8:	eb 86                	jmp    80107680 <printaq+0x50>
801076fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107700 <seginit>:
{
80107700:	55                   	push   %ebp
80107701:	89 e5                	mov    %esp,%ebp
80107703:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107706:	e8 a5 cb ff ff       	call   801042b0 <cpuid>
8010770b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107711:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107716:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010771a:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
80107721:	ff 00 00 
80107724:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
8010772b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010772e:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
80107735:	ff 00 00 
80107738:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
8010773f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107742:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
80107749:	ff 00 00 
8010774c:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
80107753:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107756:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
8010775d:	ff 00 00 
80107760:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
80107767:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010776a:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
  pd[1] = (uint)p;
8010776f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107773:	c1 e8 10             	shr    $0x10,%eax
80107776:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010777a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010777d:	0f 01 10             	lgdtl  (%eax)
}
80107780:	c9                   	leave  
80107781:	c3                   	ret    
80107782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107790 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107790:	a1 84 75 19 80       	mov    0x80197584,%eax
{
80107795:	55                   	push   %ebp
80107796:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107798:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010779d:	0f 22 d8             	mov    %eax,%cr3
}
801077a0:	5d                   	pop    %ebp
801077a1:	c3                   	ret    
801077a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 1c             	sub    $0x1c,%esp
801077b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801077bc:	85 db                	test   %ebx,%ebx
801077be:	0f 84 cb 00 00 00    	je     8010788f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801077c4:	8b 43 08             	mov    0x8(%ebx),%eax
801077c7:	85 c0                	test   %eax,%eax
801077c9:	0f 84 da 00 00 00    	je     801078a9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801077cf:	8b 43 04             	mov    0x4(%ebx),%eax
801077d2:	85 c0                	test   %eax,%eax
801077d4:	0f 84 c2 00 00 00    	je     8010789c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801077da:	e8 41 d9 ff ff       	call   80105120 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077df:	e8 4c ca ff ff       	call   80104230 <mycpu>
801077e4:	89 c6                	mov    %eax,%esi
801077e6:	e8 45 ca ff ff       	call   80104230 <mycpu>
801077eb:	89 c7                	mov    %eax,%edi
801077ed:	e8 3e ca ff ff       	call   80104230 <mycpu>
801077f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077f5:	83 c7 08             	add    $0x8,%edi
801077f8:	e8 33 ca ff ff       	call   80104230 <mycpu>
801077fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107800:	83 c0 08             	add    $0x8,%eax
80107803:	ba 67 00 00 00       	mov    $0x67,%edx
80107808:	c1 e8 18             	shr    $0x18,%eax
8010780b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107812:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107819:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010781f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107824:	83 c1 08             	add    $0x8,%ecx
80107827:	c1 e9 10             	shr    $0x10,%ecx
8010782a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107830:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107835:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010783c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107841:	e8 ea c9 ff ff       	call   80104230 <mycpu>
80107846:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010784d:	e8 de c9 ff ff       	call   80104230 <mycpu>
80107852:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107856:	8b 73 08             	mov    0x8(%ebx),%esi
80107859:	e8 d2 c9 ff ff       	call   80104230 <mycpu>
8010785e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107864:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107867:	e8 c4 c9 ff ff       	call   80104230 <mycpu>
8010786c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107870:	b8 28 00 00 00       	mov    $0x28,%eax
80107875:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107878:	8b 43 04             	mov    0x4(%ebx),%eax
8010787b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107880:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107883:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107886:	5b                   	pop    %ebx
80107887:	5e                   	pop    %esi
80107888:	5f                   	pop    %edi
80107889:	5d                   	pop    %ebp
  popcli();
8010788a:	e9 d1 d8 ff ff       	jmp    80105160 <popcli>
    panic("switchuvm: no process");
8010788f:	83 ec 0c             	sub    $0xc,%esp
80107892:	68 69 9a 10 80       	push   $0x80109a69
80107897:	e8 f4 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010789c:	83 ec 0c             	sub    $0xc,%esp
8010789f:	68 94 9a 10 80       	push   $0x80109a94
801078a4:	e8 e7 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078a9:	83 ec 0c             	sub    $0xc,%esp
801078ac:	68 7f 9a 10 80       	push   $0x80109a7f
801078b1:	e8 da 8a ff ff       	call   80100390 <panic>
801078b6:	8d 76 00             	lea    0x0(%esi),%esi
801078b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078c0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801078c0:	55                   	push   %ebp
801078c1:	89 e5                	mov    %esp,%ebp
801078c3:	57                   	push   %edi
801078c4:	56                   	push   %esi
801078c5:	53                   	push   %ebx
801078c6:	83 ec 1c             	sub    $0x1c,%esp
801078c9:	8b 75 10             	mov    0x10(%ebp),%esi
801078cc:	8b 45 08             	mov    0x8(%ebp),%eax
801078cf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801078d2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801078d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801078db:	77 49                	ja     80107926 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801078dd:	e8 5e b4 ff ff       	call   80102d40 <kalloc>
  memset(mem, 0, PGSIZE);
801078e2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801078e5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801078e7:	68 00 10 00 00       	push   $0x1000
801078ec:	6a 00                	push   $0x0
801078ee:	50                   	push   %eax
801078ef:	e8 0c da ff ff       	call   80105300 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801078f4:	58                   	pop    %eax
801078f5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078fb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107900:	5a                   	pop    %edx
80107901:	6a 06                	push   $0x6
80107903:	50                   	push   %eax
80107904:	31 d2                	xor    %edx,%edx
80107906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107909:	e8 22 fc ff ff       	call   80107530 <mappages>
  memmove(mem, init, sz);
8010790e:	89 75 10             	mov    %esi,0x10(%ebp)
80107911:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107914:	83 c4 10             	add    $0x10,%esp
80107917:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010791a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010791d:	5b                   	pop    %ebx
8010791e:	5e                   	pop    %esi
8010791f:	5f                   	pop    %edi
80107920:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107921:	e9 8a da ff ff       	jmp    801053b0 <memmove>
    panic("inituvm: more than a page");
80107926:	83 ec 0c             	sub    $0xc,%esp
80107929:	68 a8 9a 10 80       	push   $0x80109aa8
8010792e:	e8 5d 8a ff ff       	call   80100390 <panic>
80107933:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107940 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107940:	55                   	push   %ebp
80107941:	89 e5                	mov    %esp,%ebp
80107943:	57                   	push   %edi
80107944:	56                   	push   %esi
80107945:	53                   	push   %ebx
80107946:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107949:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107950:	0f 85 91 00 00 00    	jne    801079e7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107956:	8b 75 18             	mov    0x18(%ebp),%esi
80107959:	31 db                	xor    %ebx,%ebx
8010795b:	85 f6                	test   %esi,%esi
8010795d:	75 1a                	jne    80107979 <loaduvm+0x39>
8010795f:	eb 6f                	jmp    801079d0 <loaduvm+0x90>
80107961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107968:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010796e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107974:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107977:	76 57                	jbe    801079d0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107979:	8b 55 0c             	mov    0xc(%ebp),%edx
8010797c:	8b 45 08             	mov    0x8(%ebp),%eax
8010797f:	31 c9                	xor    %ecx,%ecx
80107981:	01 da                	add    %ebx,%edx
80107983:	e8 28 fb ff ff       	call   801074b0 <walkpgdir>
80107988:	85 c0                	test   %eax,%eax
8010798a:	74 4e                	je     801079da <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010798c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010798e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107991:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107996:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010799b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079a1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079a4:	01 d9                	add    %ebx,%ecx
801079a6:	05 00 00 00 80       	add    $0x80000000,%eax
801079ab:	57                   	push   %edi
801079ac:	51                   	push   %ecx
801079ad:	50                   	push   %eax
801079ae:	ff 75 10             	pushl  0x10(%ebp)
801079b1:	e8 5a a3 ff ff       	call   80101d10 <readi>
801079b6:	83 c4 10             	add    $0x10,%esp
801079b9:	39 f8                	cmp    %edi,%eax
801079bb:	74 ab                	je     80107968 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801079bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079c5:	5b                   	pop    %ebx
801079c6:	5e                   	pop    %esi
801079c7:	5f                   	pop    %edi
801079c8:	5d                   	pop    %ebp
801079c9:	c3                   	ret    
801079ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079d3:	31 c0                	xor    %eax,%eax
}
801079d5:	5b                   	pop    %ebx
801079d6:	5e                   	pop    %esi
801079d7:	5f                   	pop    %edi
801079d8:	5d                   	pop    %ebp
801079d9:	c3                   	ret    
      panic("loaduvm: address should exist");
801079da:	83 ec 0c             	sub    $0xc,%esp
801079dd:	68 c2 9a 10 80       	push   $0x80109ac2
801079e2:	e8 a9 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801079e7:	83 ec 0c             	sub    $0xc,%esp
801079ea:	68 58 9c 10 80       	push   $0x80109c58
801079ef:	e8 9c 89 ff ff       	call   80100390 <panic>
801079f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a00 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	53                   	push   %ebx
80107a04:	8b 4d 08             	mov    0x8(%ebp),%ecx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
80107a07:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107a0a:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
80107a10:	6b c2 1c             	imul   $0x1c,%edx,%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  // cprintf("filling ram slot: %d\n", curproc->num_ram);
  // cprintf("allocating addr : %p\n\n", rounded_virtaddr);

  curproc->num_ram++;
80107a13:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107a16:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
80107a18:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107a1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107a21:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a28:	00 00 00 
  page->swap_offset = -1;
80107a2b:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107a32:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107a35:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107a3b:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
  
}
80107a41:	5b                   	pop    %ebx
80107a42:	5d                   	pop    %ebp
80107a43:	c3                   	ret    
80107a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a50 <allocuvm_withswap>:



void
allocuvm_withswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a50:	55                   	push   %ebp
80107a51:	89 e5                	mov    %esp,%ebp
80107a53:	57                   	push   %edi
80107a54:	56                   	push   %esi
80107a55:	53                   	push   %ebx
80107a56:	83 ec 0c             	sub    $0xc,%esp
80107a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107a5c:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
80107a63:	0f 8f 3c 01 00 00    	jg     80107ba5 <allocuvm_withswap+0x155>

      // get info of the page to be evicted
      uint evicted_ind = indexToEvict();
      // cprintf("[allocuvm] index to evict: %d\n",evicted_ind);
      struct page *evicted_page = &curproc->ramPages[evicted_ind];
      int swap_offset = curproc->free_head->off;
80107a69:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx

      if(curproc->free_head->next == 0)
80107a6f:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80107a72:	8b 32                	mov    (%edx),%esi
      if(curproc->free_head->next == 0)
80107a74:	85 c0                	test   %eax,%eax
80107a76:	0f 84 04 01 00 00    	je     80107b80 <allocuvm_withswap+0x130>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80107a7c:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107a7f:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80107a85:	ff 70 08             	pushl  0x8(%eax)
80107a88:	e8 c3 af ff ff       	call   80102a50 <kfree>
80107a8d:	83 c4 10             	add    $0x10,%esp
      }

      // cprintf("before write to swap\n");
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80107a90:	68 00 10 00 00       	push   $0x1000
80107a95:	56                   	push   %esi
80107a96:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
80107a9c:	53                   	push   %ebx
80107a9d:	e8 5e ab ff ff       	call   80102600 <writeToSwapFile>
80107aa2:	83 c4 10             	add    $0x10,%esp
80107aa5:	85 c0                	test   %eax,%eax
80107aa7:	0f 88 12 01 00 00    	js     80107bbf <allocuvm_withswap+0x16f>
        panic("allocuvm: writeToSwapFile");


      curproc->swappedPages[curproc->num_swap].isused = 1;
80107aad:	8b bb 0c 04 00 00    	mov    0x40c(%ebx),%edi
80107ab3:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80107ab6:	01 d9                	add    %ebx,%ecx
80107ab8:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80107abf:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107ac2:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80107ac8:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107ace:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107ad4:	89 b1 94 00 00 00    	mov    %esi,0x94(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107ada:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      // cprintf("num swap: %d\n", curproc->num_swap);
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107ae0:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107ae6:	0f 22 d9             	mov    %ecx,%cr3
      curproc->num_swap ++;
80107ae9:	83 c7 01             	add    $0x1,%edi


      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107aec:	31 c9                	xor    %ecx,%ecx
      curproc->num_swap ++;
80107aee:	89 bb 0c 04 00 00    	mov    %edi,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107af4:	e8 b7 f9 ff ff       	call   801074b0 <walkpgdir>
80107af9:	89 c7                	mov    %eax,%edi



      if(!(*evicted_pte & PTE_P))
80107afb:	8b 00                	mov    (%eax),%eax
80107afd:	a8 01                	test   $0x1,%al
80107aff:	0f 84 ad 00 00 00    	je     80107bb2 <allocuvm_withswap+0x162>
        panic("allocuvm: swap: ram page not present");
      
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107b05:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      
      if(getRefs(P2V(evicted_pa)) == 1)
80107b0a:	83 ec 0c             	sub    $0xc,%esp
80107b0d:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80107b13:	56                   	push   %esi
80107b14:	e8 b7 b3 ff ff       	call   80102ed0 <getRefs>
80107b19:	83 c4 10             	add    $0x10,%esp
80107b1c:	83 f8 01             	cmp    $0x1,%eax
80107b1f:	74 4f                	je     80107b70 <allocuvm_withswap+0x120>
      {
           kfree(P2V(evicted_pa));
      }
      else
      {
             refDec(P2V(evicted_pa));
80107b21:	83 ec 0c             	sub    $0xc,%esp
80107b24:	56                   	push   %esi
80107b25:	e8 c6 b2 ff ff       	call   80102df0 <refDec>
80107b2a:	83 c4 10             	add    $0x10,%esp
  

      *evicted_pte &= 0xFFF; // ???

      *evicted_pte |= PTE_PG;
      *evicted_pte &= ~PTE_P;
80107b2d:	8b 07                	mov    (%edi),%eax
80107b2f:	25 fe 0f 00 00       	and    $0xffe,%eax
80107b34:	80 cc 02             	or     $0x2,%ah
80107b37:	89 07                	mov    %eax,(%edi)
    

      struct page *newpage = &curproc->ramPages[evicted_ind];
      newpage->isused = 1;
      newpage->pgdir = pgdir; // ??? 
80107b39:	8b 45 0c             	mov    0xc(%ebp),%eax
      newpage->isused = 1;
80107b3c:	c7 83 a0 02 00 00 01 	movl   $0x1,0x2a0(%ebx)
80107b43:	00 00 00 
      newpage->swap_offset = -1;
80107b46:	c7 83 a8 02 00 00 ff 	movl   $0xffffffff,0x2a8(%ebx)
80107b4d:	ff ff ff 
      newpage->pgdir = pgdir; // ??? 
80107b50:	89 83 9c 02 00 00    	mov    %eax,0x29c(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80107b56:	8b 45 10             	mov    0x10(%ebp),%eax
80107b59:	89 83 a4 02 00 00    	mov    %eax,0x2a4(%ebx)
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
     
}
80107b5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b62:	5b                   	pop    %ebx
80107b63:	5e                   	pop    %esi
80107b64:	5f                   	pop    %edi
80107b65:	5d                   	pop    %ebp
80107b66:	c3                   	ret    
80107b67:	89 f6                	mov    %esi,%esi
80107b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
           kfree(P2V(evicted_pa));
80107b70:	83 ec 0c             	sub    $0xc,%esp
80107b73:	56                   	push   %esi
80107b74:	e8 d7 ae ff ff       	call   80102a50 <kfree>
80107b79:	83 c4 10             	add    $0x10,%esp
80107b7c:	eb af                	jmp    80107b2d <allocuvm_withswap+0xdd>
80107b7e:	66 90                	xchg   %ax,%ax
        kfree((char*)curproc->free_head);
80107b80:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80107b83:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80107b8a:	00 00 00 
        kfree((char*)curproc->free_head);
80107b8d:	52                   	push   %edx
80107b8e:	e8 bd ae ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80107b93:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80107b9a:	00 00 00 
80107b9d:	83 c4 10             	add    $0x10,%esp
80107ba0:	e9 eb fe ff ff       	jmp    80107a90 <allocuvm_withswap+0x40>
        panic("page limit exceeded");
80107ba5:	83 ec 0c             	sub    $0xc,%esp
80107ba8:	68 e0 9a 10 80       	push   $0x80109ae0
80107bad:	e8 de 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80107bb2:	83 ec 0c             	sub    $0xc,%esp
80107bb5:	68 7c 9c 10 80       	push   $0x80109c7c
80107bba:	e8 d1 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80107bbf:	83 ec 0c             	sub    $0xc,%esp
80107bc2:	68 f4 9a 10 80       	push   $0x80109af4
80107bc7:	e8 c4 87 ff ff       	call   80100390 <panic>
80107bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107bd0 <allocuvm_paging>:
{
80107bd0:	55                   	push   %ebp
80107bd1:	89 e5                	mov    %esp,%ebp
80107bd3:	56                   	push   %esi
80107bd4:	53                   	push   %ebx
80107bd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107bd8:	8b 75 0c             	mov    0xc(%ebp),%esi
80107bdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107bde:	8b 81 08 04 00 00    	mov    0x408(%ecx),%eax
80107be4:	83 f8 0f             	cmp    $0xf,%eax
80107be7:	7f 37                	jg     80107c20 <allocuvm_paging+0x50>
  page->isused = 1;
80107be9:	6b d0 1c             	imul   $0x1c,%eax,%edx
  curproc->num_ram++;
80107bec:	83 c0 01             	add    $0x1,%eax
  page->isused = 1;
80107bef:	01 ca                	add    %ecx,%edx
80107bf1:	c7 82 4c 02 00 00 01 	movl   $0x1,0x24c(%edx)
80107bf8:	00 00 00 
  page->pgdir = pgdir;
80107bfb:	89 b2 48 02 00 00    	mov    %esi,0x248(%edx)
  page->swap_offset = -1;
80107c01:	c7 82 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edx)
80107c08:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107c0b:	89 9a 50 02 00 00    	mov    %ebx,0x250(%edx)
  curproc->num_ram++;
80107c11:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
}
80107c17:	5b                   	pop    %ebx
80107c18:	5e                   	pop    %esi
80107c19:	5d                   	pop    %ebp
80107c1a:	c3                   	ret    
80107c1b:	90                   	nop
80107c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c20:	5b                   	pop    %ebx
80107c21:	5e                   	pop    %esi
80107c22:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107c23:	e9 28 fe ff ff       	jmp    80107a50 <allocuvm_withswap>
80107c28:	90                   	nop
80107c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107c30 <update_selectionfiled_allocuvm>:

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107c30:	55                   	push   %ebp
80107c31:	89 e5                	mov    %esp,%ebp
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107c33:	5d                   	pop    %ebp
80107c34:	c3                   	ret    
80107c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c40 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c40:	55                   	push   %ebp
80107c41:	89 e5                	mov    %esp,%ebp
80107c43:	57                   	push   %edi
80107c44:	56                   	push   %esi
80107c45:	53                   	push   %ebx
80107c46:	83 ec 5c             	sub    $0x5c,%esp
80107c49:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107c4c:	e8 7f c6 ff ff       	call   801042d0 <myproc>
80107c51:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107c54:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c57:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c5a:	0f 83 a3 00 00 00    	jae    80107d03 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107c60:	8b 45 10             	mov    0x10(%ebp),%eax
80107c63:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c69:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107c6f:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c72:	77 6a                	ja     80107cde <deallocuvm+0x9e>
80107c74:	e9 87 00 00 00       	jmp    80107d00 <deallocuvm+0xc0>
80107c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107c80:	8b 00                	mov    (%eax),%eax
80107c82:	a8 01                	test   $0x1,%al
80107c84:	74 4d                	je     80107cd3 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107c86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c8b:	0f 84 b3 01 00 00    	je     80107e44 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107c91:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107c97:	83 ec 0c             	sub    $0xc,%esp
80107c9a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107c9d:	53                   	push   %ebx
80107c9e:	e8 2d b2 ff ff       	call   80102ed0 <getRefs>
80107ca3:	83 c4 10             	add    $0x10,%esp
80107ca6:	83 f8 01             	cmp    $0x1,%eax
80107ca9:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107cac:	0f 84 7e 01 00 00    	je     80107e30 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107cb2:	83 ec 0c             	sub    $0xc,%esp
80107cb5:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107cb8:	53                   	push   %ebx
80107cb9:	e8 32 b1 ff ff       	call   80102df0 <refDec>
80107cbe:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107cc1:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107cc4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107cc7:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107ccb:	7f 43                	jg     80107d10 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107ccd:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107cd3:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107cd9:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cdc:	76 22                	jbe    80107d00 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107cde:	31 c9                	xor    %ecx,%ecx
80107ce0:	89 f2                	mov    %esi,%edx
80107ce2:	89 f8                	mov    %edi,%eax
80107ce4:	e8 c7 f7 ff ff       	call   801074b0 <walkpgdir>
    if(!pte)
80107ce9:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107ceb:	89 c2                	mov    %eax,%edx
    if(!pte)
80107ced:	75 91                	jne    80107c80 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107cef:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107cf5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107cfb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cfe:	77 de                	ja     80107cde <deallocuvm+0x9e>
    }
  }
  return newsz;
80107d00:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d06:	5b                   	pop    %ebx
80107d07:	5e                   	pop    %esi
80107d08:	5f                   	pop    %edi
80107d09:	5d                   	pop    %ebp
80107d0a:	c3                   	ret    
80107d0b:	90                   	nop
80107d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d10:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107d16:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107d19:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107d1f:	89 fa                	mov    %edi,%edx
80107d21:	89 cf                	mov    %ecx,%edi
80107d23:	eb 17                	jmp    80107d3c <deallocuvm+0xfc>
80107d25:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107d28:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107d2b:	0f 84 b7 00 00 00    	je     80107de8 <deallocuvm+0x1a8>
80107d31:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107d34:	39 fb                	cmp    %edi,%ebx
80107d36:	0f 84 e4 00 00 00    	je     80107e20 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107d3c:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107d42:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107d45:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107d4b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107d4e:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107d54:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107d57:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107d5d:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107d60:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107d63:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107d69:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107d6c:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107d72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107d75:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107d7b:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107d7e:	8b 03                	mov    (%ebx),%eax
80107d80:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107d83:	8b 43 04             	mov    0x4(%ebx),%eax
80107d86:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107d89:	8b 43 08             	mov    0x8(%ebx),%eax
80107d8c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107d8f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107d92:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107d95:	8b 43 10             	mov    0x10(%ebx),%eax
80107d98:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107d9b:	8b 43 14             	mov    0x14(%ebx),%eax
80107d9e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107da1:	8b 43 18             	mov    0x18(%ebx),%eax
80107da4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107da7:	0f 85 7b ff ff ff    	jne    80107d28 <deallocuvm+0xe8>
80107dad:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107db0:	0f 85 72 ff ff ff    	jne    80107d28 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107db6:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107db9:	83 ec 04             	sub    $0x4,%esp
80107dbc:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107dbf:	6a 1c                	push   $0x1c
80107dc1:	6a 00                	push   $0x0
80107dc3:	50                   	push   %eax
80107dc4:	e8 37 d5 ff ff       	call   80105300 <memset>
            curproc->num_ram -- ;
80107dc9:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107dcc:	83 c4 10             	add    $0x10,%esp
80107dcf:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107dd2:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107dd9:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107ddc:	0f 85 4f ff ff ff    	jne    80107d31 <deallocuvm+0xf1>
80107de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107de8:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107deb:	0f 85 40 ff ff ff    	jne    80107d31 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107df1:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107df4:	83 ec 04             	sub    $0x4,%esp
80107df7:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107dfa:	6a 1c                	push   $0x1c
80107dfc:	6a 00                	push   $0x0
80107dfe:	83 c3 1c             	add    $0x1c,%ebx
80107e01:	50                   	push   %eax
80107e02:	e8 f9 d4 ff ff       	call   80105300 <memset>
            curproc->num_swap --;
80107e07:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107e0a:	83 c4 10             	add    $0x10,%esp
80107e0d:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107e10:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107e17:	39 fb                	cmp    %edi,%ebx
80107e19:	0f 85 1d ff ff ff    	jne    80107d3c <deallocuvm+0xfc>
80107e1f:	90                   	nop
80107e20:	89 d7                	mov    %edx,%edi
80107e22:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107e25:	e9 a3 fe ff ff       	jmp    80107ccd <deallocuvm+0x8d>
80107e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107e30:	83 ec 0c             	sub    $0xc,%esp
80107e33:	53                   	push   %ebx
80107e34:	e8 17 ac ff ff       	call   80102a50 <kfree>
80107e39:	83 c4 10             	add    $0x10,%esp
80107e3c:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107e3f:	e9 80 fe ff ff       	jmp    80107cc4 <deallocuvm+0x84>
        panic("kfree");
80107e44:	83 ec 0c             	sub    $0xc,%esp
80107e47:	68 7a 92 10 80       	push   $0x8010927a
80107e4c:	e8 3f 85 ff ff       	call   80100390 <panic>
80107e51:	eb 0d                	jmp    80107e60 <allocuvm>
80107e53:	90                   	nop
80107e54:	90                   	nop
80107e55:	90                   	nop
80107e56:	90                   	nop
80107e57:	90                   	nop
80107e58:	90                   	nop
80107e59:	90                   	nop
80107e5a:	90                   	nop
80107e5b:	90                   	nop
80107e5c:	90                   	nop
80107e5d:	90                   	nop
80107e5e:	90                   	nop
80107e5f:	90                   	nop

80107e60 <allocuvm>:
{
80107e60:	55                   	push   %ebp
80107e61:	89 e5                	mov    %esp,%ebp
80107e63:	57                   	push   %edi
80107e64:	56                   	push   %esi
80107e65:	53                   	push   %ebx
80107e66:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107e69:	e8 62 c4 ff ff       	call   801042d0 <myproc>
80107e6e:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107e70:	8b 45 10             	mov    0x10(%ebp),%eax
80107e73:	85 c0                	test   %eax,%eax
80107e75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e78:	0f 88 e2 00 00 00    	js     80107f60 <allocuvm+0x100>
  if(newsz < oldsz)
80107e7e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107e81:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107e84:	0f 82 c6 00 00 00    	jb     80107f50 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
80107e8a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107e90:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107e96:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107e99:	77 41                	ja     80107edc <allocuvm+0x7c>
80107e9b:	e9 b3 00 00 00       	jmp    80107f53 <allocuvm+0xf3>
  page->isused = 1;
80107ea0:	6b c2 1c             	imul   $0x1c,%edx,%eax
  page->pgdir = pgdir;
80107ea3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  curproc->num_ram++;
80107ea6:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107ea9:	01 f8                	add    %edi,%eax
80107eab:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107eb2:	00 00 00 
  page->pgdir = pgdir;
80107eb5:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->swap_offset = -1;
80107ebb:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107ec2:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107ec5:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107ecb:	89 97 08 04 00 00    	mov    %edx,0x408(%edi)
  for(; a < newsz; a += PGSIZE){
80107ed1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107ed7:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107eda:	76 77                	jbe    80107f53 <allocuvm+0xf3>
    mem = kalloc();
80107edc:	e8 5f ae ff ff       	call   80102d40 <kalloc>
    if(mem == 0){
80107ee1:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107ee3:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107ee5:	0f 84 8d 00 00 00    	je     80107f78 <allocuvm+0x118>
    memset(mem, 0, PGSIZE);
80107eeb:	83 ec 04             	sub    $0x4,%esp
80107eee:	68 00 10 00 00       	push   $0x1000
80107ef3:	6a 00                	push   $0x0
80107ef5:	50                   	push   %eax
80107ef6:	e8 05 d4 ff ff       	call   80105300 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107efb:	58                   	pop    %eax
80107efc:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f02:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f07:	5a                   	pop    %edx
80107f08:	6a 06                	push   $0x6
80107f0a:	50                   	push   %eax
80107f0b:	89 da                	mov    %ebx,%edx
80107f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f10:	e8 1b f6 ff ff       	call   80107530 <mappages>
80107f15:	83 c4 10             	add    $0x10,%esp
80107f18:	85 c0                	test   %eax,%eax
80107f1a:	0f 88 90 00 00 00    	js     80107fb0 <allocuvm+0x150>
    if(curproc->pid > 2) 
80107f20:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107f24:	7e ab                	jle    80107ed1 <allocuvm+0x71>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107f26:	8b 97 08 04 00 00    	mov    0x408(%edi),%edx
80107f2c:	83 fa 0f             	cmp    $0xf,%edx
80107f2f:	0f 8e 6b ff ff ff    	jle    80107ea0 <allocuvm+0x40>
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107f35:	83 ec 04             	sub    $0x4,%esp
80107f38:	53                   	push   %ebx
80107f39:	ff 75 08             	pushl  0x8(%ebp)
80107f3c:	57                   	push   %edi
80107f3d:	e8 0e fb ff ff       	call   80107a50 <allocuvm_withswap>
80107f42:	83 c4 10             	add    $0x10,%esp
80107f45:	eb 8a                	jmp    80107ed1 <allocuvm+0x71>
80107f47:	89 f6                	mov    %esi,%esi
80107f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
80107f50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107f53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f59:	5b                   	pop    %ebx
80107f5a:	5e                   	pop    %esi
80107f5b:	5f                   	pop    %edi
80107f5c:	5d                   	pop    %ebp
80107f5d:	c3                   	ret    
80107f5e:	66 90                	xchg   %ax,%ax
    return 0;
80107f60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f6d:	5b                   	pop    %ebx
80107f6e:	5e                   	pop    %esi
80107f6f:	5f                   	pop    %edi
80107f70:	5d                   	pop    %ebp
80107f71:	c3                   	ret    
80107f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107f78:	83 ec 0c             	sub    $0xc,%esp
80107f7b:	68 0e 9b 10 80       	push   $0x80109b0e
80107f80:	e8 db 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107f85:	83 c4 0c             	add    $0xc,%esp
80107f88:	ff 75 0c             	pushl  0xc(%ebp)
80107f8b:	ff 75 10             	pushl  0x10(%ebp)
80107f8e:	ff 75 08             	pushl  0x8(%ebp)
80107f91:	e8 aa fc ff ff       	call   80107c40 <deallocuvm>
      return 0;
80107f96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107f9d:	83 c4 10             	add    $0x10,%esp
}
80107fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fa6:	5b                   	pop    %ebx
80107fa7:	5e                   	pop    %esi
80107fa8:	5f                   	pop    %edi
80107fa9:	5d                   	pop    %ebp
80107faa:	c3                   	ret    
80107fab:	90                   	nop
80107fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107fb0:	83 ec 0c             	sub    $0xc,%esp
80107fb3:	68 26 9b 10 80       	push   $0x80109b26
80107fb8:	e8 a3 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107fbd:	83 c4 0c             	add    $0xc,%esp
80107fc0:	ff 75 0c             	pushl  0xc(%ebp)
80107fc3:	ff 75 10             	pushl  0x10(%ebp)
80107fc6:	ff 75 08             	pushl  0x8(%ebp)
80107fc9:	e8 72 fc ff ff       	call   80107c40 <deallocuvm>
      kfree(mem);
80107fce:	89 34 24             	mov    %esi,(%esp)
80107fd1:	e8 7a aa ff ff       	call   80102a50 <kfree>
      return 0;
80107fd6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107fdd:	83 c4 10             	add    $0x10,%esp
}
80107fe0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fe6:	5b                   	pop    %ebx
80107fe7:	5e                   	pop    %esi
80107fe8:	5f                   	pop    %edi
80107fe9:	5d                   	pop    %ebp
80107fea:	c3                   	ret    
80107feb:	90                   	nop
80107fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107ff0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ff0:	55                   	push   %ebp
80107ff1:	89 e5                	mov    %esp,%ebp
80107ff3:	57                   	push   %edi
80107ff4:	56                   	push   %esi
80107ff5:	53                   	push   %ebx
80107ff6:	83 ec 1c             	sub    $0x1c,%esp
80107ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  uint i;

  if(pgdir == 0)
80107ffc:	85 c0                	test   %eax,%eax
{
80107ffe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pgdir == 0)
80108001:	0f 84 87 00 00 00    	je     8010808e <freevm+0x9e>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80108007:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010800a:	83 ec 04             	sub    $0x4,%esp
8010800d:	6a 00                	push   $0x0
8010800f:	68 00 00 00 80       	push   $0x80000000
80108014:	57                   	push   %edi
80108015:	89 fb                	mov    %edi,%ebx
80108017:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
8010801d:	e8 1e fc ff ff       	call   80107c40 <deallocuvm>
80108022:	83 c4 10             	add    $0x10,%esp
80108025:	eb 10                	jmp    80108037 <freevm+0x47>
80108027:	89 f6                	mov    %esi,%esi
80108029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108030:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80108033:	39 f3                	cmp    %esi,%ebx
80108035:	74 35                	je     8010806c <freevm+0x7c>
    if(pgdir[i] & PTE_P){
80108037:	8b 03                	mov    (%ebx),%eax
80108039:	a8 01                	test   $0x1,%al
8010803b:	74 f3                	je     80108030 <freevm+0x40>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010803d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      if(getRefs(v) == 1)
80108042:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108045:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
      if(getRefs(v) == 1)
8010804b:	57                   	push   %edi
8010804c:	e8 7f ae ff ff       	call   80102ed0 <getRefs>
80108051:	83 c4 10             	add    $0x10,%esp
80108054:	83 f8 01             	cmp    $0x1,%eax
80108057:	74 27                	je     80108080 <freevm+0x90>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80108059:	83 ec 0c             	sub    $0xc,%esp
8010805c:	83 c3 04             	add    $0x4,%ebx
8010805f:	57                   	push   %edi
80108060:	e8 8b ad ff ff       	call   80102df0 <refDec>
80108065:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108068:	39 f3                	cmp    %esi,%ebx
8010806a:	75 cb                	jne    80108037 <freevm+0x47>
      }
    }
  }
  kfree((char*)pgdir);
8010806c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010806f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80108072:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108075:	5b                   	pop    %ebx
80108076:	5e                   	pop    %esi
80108077:	5f                   	pop    %edi
80108078:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108079:	e9 d2 a9 ff ff       	jmp    80102a50 <kfree>
8010807e:	66 90                	xchg   %ax,%ax
        kfree(v);
80108080:	83 ec 0c             	sub    $0xc,%esp
80108083:	57                   	push   %edi
80108084:	e8 c7 a9 ff ff       	call   80102a50 <kfree>
80108089:	83 c4 10             	add    $0x10,%esp
8010808c:	eb a2                	jmp    80108030 <freevm+0x40>
    panic("freevm: no pgdir");
8010808e:	83 ec 0c             	sub    $0xc,%esp
80108091:	68 42 9b 10 80       	push   $0x80109b42
80108096:	e8 f5 82 ff ff       	call   80100390 <panic>
8010809b:	90                   	nop
8010809c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801080a0 <setupkvm>:
{
801080a0:	55                   	push   %ebp
801080a1:	89 e5                	mov    %esp,%ebp
801080a3:	56                   	push   %esi
801080a4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801080a5:	e8 96 ac ff ff       	call   80102d40 <kalloc>
801080aa:	85 c0                	test   %eax,%eax
801080ac:	89 c6                	mov    %eax,%esi
801080ae:	74 42                	je     801080f2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801080b0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080b3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
801080b8:	68 00 10 00 00       	push   $0x1000
801080bd:	6a 00                	push   $0x0
801080bf:	50                   	push   %eax
801080c0:	e8 3b d2 ff ff       	call   80105300 <memset>
801080c5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801080c8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801080cb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801080ce:	83 ec 08             	sub    $0x8,%esp
801080d1:	8b 13                	mov    (%ebx),%edx
801080d3:	ff 73 0c             	pushl  0xc(%ebx)
801080d6:	50                   	push   %eax
801080d7:	29 c1                	sub    %eax,%ecx
801080d9:	89 f0                	mov    %esi,%eax
801080db:	e8 50 f4 ff ff       	call   80107530 <mappages>
801080e0:	83 c4 10             	add    $0x10,%esp
801080e3:	85 c0                	test   %eax,%eax
801080e5:	78 19                	js     80108100 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801080e7:	83 c3 10             	add    $0x10,%ebx
801080ea:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
801080f0:	75 d6                	jne    801080c8 <setupkvm+0x28>
}
801080f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080f5:	89 f0                	mov    %esi,%eax
801080f7:	5b                   	pop    %ebx
801080f8:	5e                   	pop    %esi
801080f9:	5d                   	pop    %ebp
801080fa:	c3                   	ret    
801080fb:	90                   	nop
801080fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80108100:	83 ec 0c             	sub    $0xc,%esp
80108103:	68 53 9b 10 80       	push   $0x80109b53
80108108:	e8 53 85 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
8010810d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80108110:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108112:	e8 d9 fe ff ff       	call   80107ff0 <freevm>
      return 0;
80108117:	83 c4 10             	add    $0x10,%esp
}
8010811a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010811d:	89 f0                	mov    %esi,%eax
8010811f:	5b                   	pop    %ebx
80108120:	5e                   	pop    %esi
80108121:	5d                   	pop    %ebp
80108122:	c3                   	ret    
80108123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108130 <kvmalloc>:
{
80108130:	55                   	push   %ebp
80108131:	89 e5                	mov    %esp,%ebp
80108133:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108136:	e8 65 ff ff ff       	call   801080a0 <setupkvm>
8010813b:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108140:	05 00 00 00 80       	add    $0x80000000,%eax
80108145:	0f 22 d8             	mov    %eax,%cr3
}
80108148:	c9                   	leave  
80108149:	c3                   	ret    
8010814a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108150 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108150:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108151:	31 c9                	xor    %ecx,%ecx
{
80108153:	89 e5                	mov    %esp,%ebp
80108155:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108158:	8b 55 0c             	mov    0xc(%ebp),%edx
8010815b:	8b 45 08             	mov    0x8(%ebp),%eax
8010815e:	e8 4d f3 ff ff       	call   801074b0 <walkpgdir>
  if(pte == 0)
80108163:	85 c0                	test   %eax,%eax
80108165:	74 05                	je     8010816c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80108167:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010816a:	c9                   	leave  
8010816b:	c3                   	ret    
    panic("clearpteu");
8010816c:	83 ec 0c             	sub    $0xc,%esp
8010816f:	68 6f 9b 10 80       	push   $0x80109b6f
80108174:	e8 17 82 ff ff       	call   80100390 <panic>
80108179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108180 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80108180:	55                   	push   %ebp
80108181:	89 e5                	mov    %esp,%ebp
80108183:	57                   	push   %edi
80108184:	56                   	push   %esi
80108185:	53                   	push   %ebx
80108186:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80108189:	e8 12 ff ff ff       	call   801080a0 <setupkvm>
8010818e:	85 c0                	test   %eax,%eax
80108190:	89 c7                	mov    %eax,%edi
80108192:	0f 84 ce 00 00 00    	je     80108266 <cowuvm+0xe6>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80108198:	8b 45 0c             	mov    0xc(%ebp),%eax
8010819b:	85 c0                	test   %eax,%eax
8010819d:	0f 84 c3 00 00 00    	je     80108266 <cowuvm+0xe6>
801081a3:	8b 45 08             	mov    0x8(%ebp),%eax
801081a6:	31 db                	xor    %ebx,%ebx
801081a8:	05 00 00 00 80       	add    $0x80000000,%eax
801081ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801081b0:	eb 62                	jmp    80108214 <cowuvm+0x94>
801081b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *pte = PTE_U | PTE_W | PTE_PG;
       continue;
    }
    
    *pte |= PTE_COW;
    *pte &= ~PTE_W;
801081b8:	89 d1                	mov    %edx,%ecx
801081ba:	89 d6                	mov    %edx,%esi

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
801081bc:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
801081c2:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
801081c5:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
801081c8:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
801081cb:	80 cd 04             	or     $0x4,%ch
801081ce:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
801081d4:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
801081d6:	52                   	push   %edx
801081d7:	b9 00 10 00 00       	mov    $0x1000,%ecx
801081dc:	56                   	push   %esi
801081dd:	89 da                	mov    %ebx,%edx
801081df:	89 f8                	mov    %edi,%eax
801081e1:	e8 4a f3 ff ff       	call   80107530 <mappages>
801081e6:	83 c4 10             	add    $0x10,%esp
801081e9:	85 c0                	test   %eax,%eax
801081eb:	0f 88 7f 00 00 00    	js     80108270 <cowuvm+0xf0>
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
801081f1:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
801081f4:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
801081fa:	56                   	push   %esi
801081fb:	e8 60 ac ff ff       	call   80102e60 <refInc>
80108200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108203:	0f 22 d8             	mov    %eax,%cr3
80108206:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
80108209:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010820f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80108212:	76 52                	jbe    80108266 <cowuvm+0xe6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108214:	8b 45 08             	mov    0x8(%ebp),%eax
80108217:	31 c9                	xor    %ecx,%ecx
80108219:	89 da                	mov    %ebx,%edx
8010821b:	e8 90 f2 ff ff       	call   801074b0 <walkpgdir>
80108220:	85 c0                	test   %eax,%eax
80108222:	0f 84 7f 00 00 00    	je     801082a7 <cowuvm+0x127>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108228:	8b 10                	mov    (%eax),%edx
8010822a:	f7 c2 01 02 00 00    	test   $0x201,%edx
80108230:	74 68                	je     8010829a <cowuvm+0x11a>
    if(*pte & PTE_PG)  //there is pgfault, then not mark this entry as cow
80108232:	f6 c6 02             	test   $0x2,%dh
80108235:	74 81                	je     801081b8 <cowuvm+0x38>
      cprintf("cowuvm,  not marked as cow because pgfault \n");
80108237:	83 ec 0c             	sub    $0xc,%esp
8010823a:	68 d4 9c 10 80       	push   $0x80109cd4
8010823f:	e8 1c 84 ff ff       	call   80100660 <cprintf>
       pte = walkpgdir(d, (void*) i, 1);
80108244:	89 da                	mov    %ebx,%edx
80108246:	b9 01 00 00 00       	mov    $0x1,%ecx
8010824b:	89 f8                	mov    %edi,%eax
8010824d:	e8 5e f2 ff ff       	call   801074b0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE)
80108252:	81 c3 00 10 00 00    	add    $0x1000,%ebx
       continue;
80108258:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
8010825b:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
8010825e:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE)
80108264:	77 ae                	ja     80108214 <cowuvm+0x94>
bad:
  cprintf("bad: cowuvm\n");
  freevm(d);
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
}
80108266:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108269:	89 f8                	mov    %edi,%eax
8010826b:	5b                   	pop    %ebx
8010826c:	5e                   	pop    %esi
8010826d:	5f                   	pop    %edi
8010826e:	5d                   	pop    %ebp
8010826f:	c3                   	ret    
  cprintf("bad: cowuvm\n");
80108270:	83 ec 0c             	sub    $0xc,%esp
80108273:	68 88 9b 10 80       	push   $0x80109b88
80108278:	e8 e3 83 ff ff       	call   80100660 <cprintf>
  freevm(d);
8010827d:	89 3c 24             	mov    %edi,(%esp)
80108280:	e8 6b fd ff ff       	call   80107ff0 <freevm>
80108285:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108288:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010828b:	83 c4 10             	add    $0x10,%esp
}
8010828e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108291:	31 ff                	xor    %edi,%edi
}
80108293:	89 f8                	mov    %edi,%eax
80108295:	5b                   	pop    %ebx
80108296:	5e                   	pop    %esi
80108297:	5f                   	pop    %edi
80108298:	5d                   	pop    %ebp
80108299:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
8010829a:	83 ec 0c             	sub    $0xc,%esp
8010829d:	68 a4 9c 10 80       	push   $0x80109ca4
801082a2:	e8 e9 80 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
801082a7:	83 ec 0c             	sub    $0xc,%esp
801082aa:	68 79 9b 10 80       	push   $0x80109b79
801082af:	e8 dc 80 ff ff       	call   80100390 <panic>
801082b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801082ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801082c0 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	53                   	push   %ebx
801082c4:	83 ec 04             	sub    $0x4,%esp
801082c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
801082ca:	e8 01 c0 ff ff       	call   801042d0 <myproc>
801082cf:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801082d5:	31 c0                	xor    %eax,%eax
801082d7:	eb 12                	jmp    801082eb <getSwappedPageIndex+0x2b>
801082d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082e0:	83 c0 01             	add    $0x1,%eax
801082e3:	83 c2 1c             	add    $0x1c,%edx
801082e6:	83 f8 10             	cmp    $0x10,%eax
801082e9:	74 0d                	je     801082f8 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
801082eb:	39 1a                	cmp    %ebx,(%edx)
801082ed:	75 f1                	jne    801082e0 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
801082ef:	83 c4 04             	add    $0x4,%esp
801082f2:	5b                   	pop    %ebx
801082f3:	5d                   	pop    %ebp
801082f4:	c3                   	ret    
801082f5:	8d 76 00             	lea    0x0(%esi),%esi
801082f8:	83 c4 04             	add    $0x4,%esp
  return -1;
801082fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108300:	5b                   	pop    %ebx
80108301:	5d                   	pop    %ebp
80108302:	c3                   	ret    
80108303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108310 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
80108310:	55                   	push   %ebp
80108311:	89 e5                	mov    %esp,%ebp
80108313:	57                   	push   %edi
80108314:	56                   	push   %esi
80108315:	53                   	push   %ebx
80108316:	83 ec 1c             	sub    $0x1c,%esp
80108319:	8b 45 08             	mov    0x8(%ebp),%eax
8010831c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010831f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
80108322:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80108325:	f6 42 34 02          	testb  $0x2,0x34(%edx)
80108329:	74 07                	je     80108332 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
8010832b:	8b 13                	mov    (%ebx),%edx
8010832d:	f6 c6 04             	test   $0x4,%dh
80108330:	75 16                	jne    80108348 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80108332:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
80108339:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010833c:	5b                   	pop    %ebx
8010833d:	5e                   	pop    %esi
8010833e:	5f                   	pop    %edi
8010833f:	5d                   	pop    %ebp
80108340:	c3                   	ret    
80108341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
80108348:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
8010834a:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
8010834d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108350:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80108356:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
8010835c:	57                   	push   %edi
8010835d:	e8 6e ab ff ff       	call   80102ed0 <getRefs>
      if (ref_count > 1) // more than one reference
80108362:	83 c4 10             	add    $0x10,%esp
80108365:	83 f8 01             	cmp    $0x1,%eax
80108368:	7f 16                	jg     80108380 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
8010836a:	8b 03                	mov    (%ebx),%eax
8010836c:	80 e4 fb             	and    $0xfb,%ah
8010836f:	83 c8 02             	or     $0x2,%eax
80108372:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80108374:	0f 01 3e             	invlpg (%esi)
80108377:	eb c0                	jmp    80108339 <handle_cow_pagefault+0x29>
80108379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80108380:	e8 bb a9 ff ff       	call   80102d40 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108385:	83 ec 04             	sub    $0x4,%esp
80108388:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010838b:	68 00 10 00 00       	push   $0x1000
80108390:	57                   	push   %edi
80108391:	50                   	push   %eax
80108392:	e8 19 d0 ff ff       	call   801053b0 <memmove>
      flags = PTE_FLAGS(*pte);
80108397:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
8010839a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
8010839d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
801083a3:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801083a9:	83 ca 03             	or     $0x3,%edx
801083ac:	09 ca                	or     %ecx,%edx
801083ae:	89 13                	mov    %edx,(%ebx)
801083b0:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
801083b3:	89 7d 08             	mov    %edi,0x8(%ebp)
801083b6:	83 c4 10             	add    $0x10,%esp
}
801083b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083bc:	5b                   	pop    %ebx
801083bd:	5e                   	pop    %esi
801083be:	5f                   	pop    %edi
801083bf:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
801083c0:	e9 2b aa ff ff       	jmp    80102df0 <refDec>
801083c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801083c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801083d0 <handle_pagedout>:

void
handle_pagedout(struct proc* curproc, char* start_page, pte_t* pte)
{
801083d0:	55                   	push   %ebp
801083d1:	89 e5                	mov    %esp,%ebp
801083d3:	57                   	push   %edi
801083d4:	56                   	push   %esi
801083d5:	53                   	push   %ebx
801083d6:	83 ec 20             	sub    $0x20,%esp
801083d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801083dc:	8b 7d 10             	mov    0x10(%ebp),%edi
801083df:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* new_page;
    void* ramPa;
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
801083e2:	8d 43 6c             	lea    0x6c(%ebx),%eax
801083e5:	ff 73 10             	pushl  0x10(%ebx)
801083e8:	50                   	push   %eax
801083e9:	68 04 9d 10 80       	push   $0x80109d04
801083ee:	e8 6d 82 ff ff       	call   80100660 <cprintf>

    new_page = kalloc();
801083f3:	e8 48 a9 ff ff       	call   80102d40 <kalloc>
    *pte |= PTE_P | PTE_W | PTE_U;
    *pte &= ~PTE_PG;
    *pte &= 0xFFF;
801083f8:	8b 17                	mov    (%edi),%edx
    *pte |= V2P(new_page);
801083fa:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
801083ff:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
80108405:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
80108408:	09 d0                	or     %edx,%eax
8010840a:	89 07                	mov    %eax,(%edi)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010840c:	31 ff                	xor    %edi,%edi
  struct proc* curproc = myproc();
8010840e:	e8 bd be ff ff       	call   801042d0 <myproc>
80108413:	83 c4 10             	add    $0x10,%esp
80108416:	05 90 00 00 00       	add    $0x90,%eax
8010841b:	eb 12                	jmp    8010842f <handle_pagedout+0x5f>
8010841d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108420:	83 c7 01             	add    $0x1,%edi
80108423:	83 c0 1c             	add    $0x1c,%eax
80108426:	83 ff 10             	cmp    $0x10,%edi
80108429:	0f 84 c1 01 00 00    	je     801085f0 <handle_pagedout+0x220>
    if(curproc->swappedPages[i].virt_addr == va)
8010842f:	3b 30                	cmp    (%eax),%esi
80108431:	75 ed                	jne    80108420 <handle_pagedout+0x50>
80108433:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108436:	05 88 00 00 00       	add    $0x88,%eax
    
    int index = getSwappedPageIndex(start_page); // get swap page index
    struct page *swap_page = &curproc->swappedPages[index];
8010843b:	01 d8                	add    %ebx,%eax

    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
8010843d:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80108442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108445:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108448:	01 d8                	add    %ebx,%eax
8010844a:	ff b0 94 00 00 00    	pushl  0x94(%eax)
80108450:	68 e0 c5 10 80       	push   $0x8010c5e0
80108455:	53                   	push   %ebx
80108456:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108459:	e8 d2 a1 ff ff       	call   80102630 <readFromSwapFile>
8010845e:	83 c4 10             	add    $0x10,%esp
80108461:	85 c0                	test   %eax,%eax
80108463:	0f 88 36 02 00 00    	js     8010869f <handle_pagedout+0x2cf>
      panic("allocuvm: readFromSwapFile");

    struct fblock *new_block = (struct fblock*)kalloc();
80108469:	e8 d2 a8 ff ff       	call   80102d40 <kalloc>
    new_block->off = swap_page->swap_offset;
8010846e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108471:	8b 91 94 00 00 00    	mov    0x94(%ecx),%edx
    new_block->next = 0;
80108477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
8010847e:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80108480:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108486:	89 50 08             	mov    %edx,0x8(%eax)

    if(curproc->free_tail != 0)
80108489:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
8010848f:	85 d2                	test   %edx,%edx
80108491:	0f 84 d9 01 00 00    	je     80108670 <handle_pagedout+0x2a0>
      curproc->free_tail->next = new_block;
80108497:	89 42 04             	mov    %eax,0x4(%edx)
    curproc->free_tail = new_block;

    // cprintf("free blocks list after readFromSwapFile:\n");
    // printlist();

    memmove((void*)start_page, buffer, PGSIZE);
8010849a:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
8010849d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
801084a3:	68 00 10 00 00       	push   $0x1000
801084a8:	68 e0 c5 10 80       	push   $0x8010c5e0
801084ad:	56                   	push   %esi
801084ae:	e8 fd ce ff ff       	call   801053b0 <memmove>

    // zero swap page entry
    memset((void*)swap_page, 0, sizeof(struct page));
801084b3:	83 c4 0c             	add    $0xc,%esp
801084b6:	6a 1c                	push   $0x1c
801084b8:	6a 00                	push   $0x0
801084ba:	ff 75 e4             	pushl  -0x1c(%ebp)
801084bd:	e8 3e ce ff ff       	call   80105300 <memset>

    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
801084c2:	83 c4 10             	add    $0x10,%esp
801084c5:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
801084cc:	0f 8e 2e 01 00 00    	jle    80108600 <handle_pagedout+0x230>
    else // no sapce in proc RAM, will swap
    {
      int index_to_evicet = indexToEvict();
      // cprintf("[pagefault] index to evict: %d\n", index_to_evicet);
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
      int swap_offset = curproc->free_head->off;
801084d2:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
801084d8:	8b 02                	mov    (%edx),%eax
801084da:	89 45 e4             	mov    %eax,-0x1c(%ebp)

      if(curproc->free_head->next == 0)
801084dd:	8b 42 04             	mov    0x4(%edx),%eax
801084e0:	85 c0                	test   %eax,%eax
801084e2:	0f 84 e0 00 00 00    	je     801085c8 <handle_pagedout+0x1f8>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
801084e8:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
801084eb:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
801084f1:	ff 70 08             	pushl  0x8(%eax)
801084f4:	e8 57 a5 ff ff       	call   80102a50 <kfree>
801084f9:	83 c4 10             	add    $0x10,%esp
      }

      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
801084fc:	68 00 10 00 00       	push   $0x1000
80108501:	ff 75 e4             	pushl  -0x1c(%ebp)
80108504:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
8010850a:	53                   	push   %ebx
8010850b:	e8 f0 a0 ff ff       	call   80102600 <writeToSwapFile>
80108510:	83 c4 10             	add    $0x10,%esp
80108513:	85 c0                	test   %eax,%eax
80108515:	0f 88 91 01 00 00    	js     801086ac <handle_pagedout+0x2dc>
        panic("allocuvm: writeToSwapFile");
      
      swap_page->virt_addr = ram_page->virt_addr;
8010851b:	6b cf 1c             	imul   $0x1c,%edi,%ecx
8010851e:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80108524:	01 d9                	add    %ebx,%ecx
80108526:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
8010852c:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      swap_page->isused = 1;
80108532:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80108539:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
8010853c:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108542:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108545:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)

      // get pte of RAM page
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
8010854b:	8b 43 04             	mov    0x4(%ebx),%eax
8010854e:	31 c9                	xor    %ecx,%ecx
80108550:	e8 5b ef ff ff       	call   801074b0 <walkpgdir>
      if(!(*pte & PTE_P))
80108555:	8b 38                	mov    (%eax),%edi
80108557:	f7 c7 01 00 00 00    	test   $0x1,%edi
8010855d:	0f 84 56 01 00 00    	je     801086b9 <handle_pagedout+0x2e9>
        panic("pagefault: ram page is not present");
      ramPa = (void*)PTE_ADDR(*pte);
80108563:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      

       if(getRefs(P2V(ramPa)) == 1)
80108569:	83 ec 0c             	sub    $0xc,%esp
8010856c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010856f:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108575:	57                   	push   %edi
80108576:	e8 55 a9 ff ff       	call   80102ed0 <getRefs>
8010857b:	83 c4 10             	add    $0x10,%esp
8010857e:	83 f8 01             	cmp    $0x1,%eax
80108581:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108584:	0f 84 f6 00 00 00    	je     80108680 <handle_pagedout+0x2b0>
      {
           kfree(P2V(ramPa));
      }
      else
      {
           refDec(P2V(ramPa));
8010858a:	83 ec 0c             	sub    $0xc,%esp
8010858d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108590:	57                   	push   %edi
80108591:	e8 5a a8 ff ff       	call   80102df0 <refDec>
80108596:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108599:	83 c4 10             	add    $0x10,%esp
      
      *pte &= 0xFFF;   // ???
      
      // prepare to-be-swapped page in RAM to move to swap file
      *pte |= PTE_PG;     // turn "paged-out" flag on
      *pte &= ~PTE_P;     // turn "present" flag off
8010859c:	8b 02                	mov    (%edx),%eax
8010859e:	25 fe 0f 00 00       	and    $0xffe,%eax
801085a3:	80 cc 02             	or     $0x2,%ah
801085a6:	89 02                	mov    %eax,(%edx)

      ram_page->virt_addr = start_page;
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
      
      lcr3(V2P(curproc->pgdir));             // refresh TLB
801085a8:	8b 43 04             	mov    0x4(%ebx),%eax
      ram_page->virt_addr = start_page;
801085ab:	89 b3 a4 02 00 00    	mov    %esi,0x2a4(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
801085b1:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801085b6:	0f 22 d8             	mov    %eax,%cr3
    }
    return;
}
801085b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085bc:	5b                   	pop    %ebx
801085bd:	5e                   	pop    %esi
801085be:	5f                   	pop    %edi
801085bf:	5d                   	pop    %ebp
801085c0:	c3                   	ret    
801085c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
801085c8:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
801085cb:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
801085d2:	00 00 00 
        kfree((char*)curproc->free_head);
801085d5:	52                   	push   %edx
801085d6:	e8 75 a4 ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
801085db:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
801085e2:	00 00 00 
801085e5:	83 c4 10             	add    $0x10,%esp
801085e8:	e9 0f ff ff ff       	jmp    801084fc <handle_pagedout+0x12c>
801085ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801085f0:	b8 6c 00 00 00       	mov    $0x6c,%eax
  return -1;
801085f5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801085fa:	e9 3c fe ff ff       	jmp    8010843b <handle_pagedout+0x6b>
801085ff:	90                   	nop

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80108600:	e8 cb bc ff ff       	call   801042d0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108605:	31 ff                	xor    %edi,%edi
80108607:	05 4c 02 00 00       	add    $0x24c,%eax
8010860c:	eb 0d                	jmp    8010861b <handle_pagedout+0x24b>
8010860e:	66 90                	xchg   %ax,%ax
80108610:	83 c7 01             	add    $0x1,%edi
80108613:	83 c0 1c             	add    $0x1c,%eax
80108616:	83 ff 10             	cmp    $0x10,%edi
80108619:	74 7d                	je     80108698 <handle_pagedout+0x2c8>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
8010861b:	8b 10                	mov    (%eax),%edx
8010861d:	85 d2                	test   %edx,%edx
8010861f:	75 ef                	jne    80108610 <handle_pagedout+0x240>
      cprintf("filling ram slot: %d\n", new_indx);
80108621:	83 ec 08             	sub    $0x8,%esp
80108624:	57                   	push   %edi
80108625:	68 b0 9b 10 80       	push   $0x80109bb0
      curproc->ramPages[new_indx].virt_addr = start_page;
8010862a:	6b ff 1c             	imul   $0x1c,%edi,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010862d:	e8 2e 80 ff ff       	call   80100660 <cprintf>
80108632:	83 c4 10             	add    $0x10,%esp
      curproc->ramPages[new_indx].virt_addr = start_page;
80108635:	01 df                	add    %ebx,%edi
80108637:	89 b7 50 02 00 00    	mov    %esi,0x250(%edi)
      curproc->ramPages[new_indx].isused = 1;
8010863d:	c7 87 4c 02 00 00 01 	movl   $0x1,0x24c(%edi)
80108644:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108647:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
8010864a:	c7 87 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edi)
80108651:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108654:	89 87 48 02 00 00    	mov    %eax,0x248(%edi)
      curproc->num_ram++;
8010865a:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
80108661:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
80108668:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010866b:	5b                   	pop    %ebx
8010866c:	5e                   	pop    %esi
8010866d:	5f                   	pop    %edi
8010866e:	5d                   	pop    %ebp
8010866f:	c3                   	ret    
      curproc->free_head = new_block;
80108670:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108676:	e9 1f fe ff ff       	jmp    8010849a <handle_pagedout+0xca>
8010867b:	90                   	nop
8010867c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
           kfree(P2V(ramPa));
80108680:	83 ec 0c             	sub    $0xc,%esp
80108683:	57                   	push   %edi
80108684:	e8 c7 a3 ff ff       	call   80102a50 <kfree>
80108689:	83 c4 10             	add    $0x10,%esp
8010868c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010868f:	e9 08 ff ff ff       	jmp    8010859c <handle_pagedout+0x1cc>
80108694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return i;
  }
  return -1;
80108698:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010869d:	eb 82                	jmp    80108621 <handle_pagedout+0x251>
      panic("allocuvm: readFromSwapFile");
8010869f:	83 ec 0c             	sub    $0xc,%esp
801086a2:	68 95 9b 10 80       	push   $0x80109b95
801086a7:	e8 e4 7c ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801086ac:	83 ec 0c             	sub    $0xc,%esp
801086af:	68 f4 9a 10 80       	push   $0x80109af4
801086b4:	e8 d7 7c ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
801086b9:	83 ec 0c             	sub    $0xc,%esp
801086bc:	68 34 9d 10 80       	push   $0x80109d34
801086c1:	e8 ca 7c ff ff       	call   80100390 <panic>
801086c6:	8d 76 00             	lea    0x0(%esi),%esi
801086c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801086d0 <pagefault>:
{
801086d0:	55                   	push   %ebp
801086d1:	89 e5                	mov    %esp,%ebp
801086d3:	57                   	push   %edi
801086d4:	56                   	push   %esi
801086d5:	53                   	push   %ebx
801086d6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801086d9:	e8 f2 bb ff ff       	call   801042d0 <myproc>
801086de:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
801086e0:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
801086e3:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
801086ea:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801086ec:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
801086ef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801086f5:	31 c9                	xor    %ecx,%ecx
801086f7:	89 fa                	mov    %edi,%edx
801086f9:	e8 b2 ed ff ff       	call   801074b0 <walkpgdir>
  if((*pte & PTE_PG) && !(*pte & PTE_COW)) // paged out, not COW todo
801086fe:	8b 10                	mov    (%eax),%edx
80108700:	81 e2 00 06 00 00    	and    $0x600,%edx
80108706:	81 fa 00 02 00 00    	cmp    $0x200,%edx
8010870c:	74 62                	je     80108770 <pagefault+0xa0>
    if(va >= KERNBASE || pte == 0)
8010870e:	85 f6                	test   %esi,%esi
80108710:	78 2e                	js     80108740 <pagefault+0x70>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108712:	8b 43 04             	mov    0x4(%ebx),%eax
80108715:	31 c9                	xor    %ecx,%ecx
80108717:	89 f2                	mov    %esi,%edx
80108719:	e8 92 ed ff ff       	call   801074b0 <walkpgdir>
8010871e:	85 c0                	test   %eax,%eax
80108720:	74 64                	je     80108786 <pagefault+0xb6>
    handle_cow_pagefault(curproc, pte, va);
80108722:	83 ec 04             	sub    $0x4,%esp
80108725:	56                   	push   %esi
80108726:	50                   	push   %eax
80108727:	53                   	push   %ebx
80108728:	e8 e3 fb ff ff       	call   80108310 <handle_cow_pagefault>
8010872d:	83 c4 10             	add    $0x10,%esp
}
80108730:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108733:	5b                   	pop    %ebx
80108734:	5e                   	pop    %esi
80108735:	5f                   	pop    %edi
80108736:	5d                   	pop    %ebp
80108737:	c3                   	ret    
80108738:	90                   	nop
80108739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108740:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108743:	83 ec 04             	sub    $0x4,%esp
80108746:	50                   	push   %eax
80108747:	ff 73 10             	pushl  0x10(%ebx)
8010874a:	68 58 9d 10 80       	push   $0x80109d58
8010874f:	e8 0c 7f ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80108754:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
8010875b:	83 c4 10             	add    $0x10,%esp
}
8010875e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108761:	5b                   	pop    %ebx
80108762:	5e                   	pop    %esi
80108763:	5f                   	pop    %edi
80108764:	5d                   	pop    %ebp
80108765:	c3                   	ret    
80108766:	8d 76 00             	lea    0x0(%esi),%esi
80108769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    handle_pagedout(curproc, start_page, pte);
80108770:	83 ec 04             	sub    $0x4,%esp
80108773:	50                   	push   %eax
80108774:	57                   	push   %edi
80108775:	53                   	push   %ebx
80108776:	e8 55 fc ff ff       	call   801083d0 <handle_pagedout>
8010877b:	83 c4 10             	add    $0x10,%esp
}
8010877e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108781:	5b                   	pop    %ebx
80108782:	5e                   	pop    %esi
80108783:	5f                   	pop    %edi
80108784:	5d                   	pop    %ebp
80108785:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
80108786:	83 ec 0c             	sub    $0xc,%esp
80108789:	68 c6 9b 10 80       	push   $0x80109bc6
8010878e:	e8 fd 7b ff ff       	call   80100390 <panic>
80108793:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801087a0 <update_selectionfiled_pagefault>:
801087a0:	55                   	push   %ebp
801087a1:	89 e5                	mov    %esp,%ebp
801087a3:	5d                   	pop    %ebp
801087a4:	c3                   	ret    
801087a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801087a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801087b0 <copyuvm>:
{
801087b0:	55                   	push   %ebp
801087b1:	89 e5                	mov    %esp,%ebp
801087b3:	57                   	push   %edi
801087b4:	56                   	push   %esi
801087b5:	53                   	push   %ebx
801087b6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801087b9:	e8 e2 f8 ff ff       	call   801080a0 <setupkvm>
801087be:	85 c0                	test   %eax,%eax
801087c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801087c3:	0f 84 bf 00 00 00    	je     80108888 <copyuvm+0xd8>
  for(i = 0; i < sz; i += PGSIZE){
801087c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801087cc:	85 db                	test   %ebx,%ebx
801087ce:	0f 84 b4 00 00 00    	je     80108888 <copyuvm+0xd8>
801087d4:	31 f6                	xor    %esi,%esi
801087d6:	eb 69                	jmp    80108841 <copyuvm+0x91>
801087d8:	90                   	nop
801087d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
801087e0:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
801087e2:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
801087e8:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801087ee:	e8 4d a5 ff ff       	call   80102d40 <kalloc>
801087f3:	85 c0                	test   %eax,%eax
801087f5:	0f 84 ad 00 00 00    	je     801088a8 <copyuvm+0xf8>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801087fb:	83 ec 04             	sub    $0x4,%esp
801087fe:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108807:	68 00 10 00 00       	push   $0x1000
8010880c:	57                   	push   %edi
8010880d:	50                   	push   %eax
8010880e:	e8 9d cb ff ff       	call   801053b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108813:	5a                   	pop    %edx
80108814:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108817:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010881a:	59                   	pop    %ecx
8010881b:	53                   	push   %ebx
8010881c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108821:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108827:	52                   	push   %edx
80108828:	89 f2                	mov    %esi,%edx
8010882a:	e8 01 ed ff ff       	call   80107530 <mappages>
8010882f:	83 c4 10             	add    $0x10,%esp
80108832:	85 c0                	test   %eax,%eax
80108834:	78 62                	js     80108898 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108836:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010883c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010883f:	76 47                	jbe    80108888 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108841:	8b 45 08             	mov    0x8(%ebp),%eax
80108844:	31 c9                	xor    %ecx,%ecx
80108846:	89 f2                	mov    %esi,%edx
80108848:	e8 63 ec ff ff       	call   801074b0 <walkpgdir>
8010884d:	85 c0                	test   %eax,%eax
8010884f:	0f 84 8b 00 00 00    	je     801088e0 <copyuvm+0x130>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108855:	8b 18                	mov    (%eax),%ebx
80108857:	f7 c3 01 02 00 00    	test   $0x201,%ebx
8010885d:	74 74                	je     801088d3 <copyuvm+0x123>
    if (*pte & PTE_PG) {
8010885f:	f6 c7 02             	test   $0x2,%bh
80108862:	0f 84 78 ff ff ff    	je     801087e0 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108868:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010886b:	89 f2                	mov    %esi,%edx
8010886d:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80108872:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
80108878:	e8 33 ec ff ff       	call   801074b0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
8010887d:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
80108880:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108886:	77 b9                	ja     80108841 <copyuvm+0x91>
}
80108888:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010888b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010888e:	5b                   	pop    %ebx
8010888f:	5e                   	pop    %esi
80108890:	5f                   	pop    %edi
80108891:	5d                   	pop    %ebp
80108892:	c3                   	ret    
80108893:	90                   	nop
80108894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("copyuvm: mappages failed\n");
80108898:	83 ec 0c             	sub    $0xc,%esp
8010889b:	68 f9 9b 10 80       	push   $0x80109bf9
801088a0:	e8 bb 7d ff ff       	call   80100660 <cprintf>
      goto bad;
801088a5:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801088a8:	83 ec 0c             	sub    $0xc,%esp
801088ab:	68 13 9c 10 80       	push   $0x80109c13
801088b0:	e8 ab 7d ff ff       	call   80100660 <cprintf>
  freevm(d);
801088b5:	58                   	pop    %eax
801088b6:	ff 75 e0             	pushl  -0x20(%ebp)
801088b9:	e8 32 f7 ff ff       	call   80107ff0 <freevm>
  return 0;
801088be:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801088c5:	83 c4 10             	add    $0x10,%esp
}
801088c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801088cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088ce:	5b                   	pop    %ebx
801088cf:	5e                   	pop    %esi
801088d0:	5f                   	pop    %edi
801088d1:	5d                   	pop    %ebp
801088d2:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
801088d3:	83 ec 0c             	sub    $0xc,%esp
801088d6:	68 8c 9d 10 80       	push   $0x80109d8c
801088db:	e8 b0 7a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801088e0:	83 ec 0c             	sub    $0xc,%esp
801088e3:	68 df 9b 10 80       	push   $0x80109bdf
801088e8:	e8 a3 7a ff ff       	call   80100390 <panic>
801088ed:	8d 76 00             	lea    0x0(%esi),%esi

801088f0 <uva2ka>:
{
801088f0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801088f1:	31 c9                	xor    %ecx,%ecx
{
801088f3:	89 e5                	mov    %esp,%ebp
801088f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801088f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801088fb:	8b 45 08             	mov    0x8(%ebp),%eax
801088fe:	e8 ad eb ff ff       	call   801074b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108903:	8b 00                	mov    (%eax),%eax
}
80108905:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108906:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108908:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010890d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108910:	05 00 00 00 80       	add    $0x80000000,%eax
80108915:	83 fa 05             	cmp    $0x5,%edx
80108918:	ba 00 00 00 00       	mov    $0x0,%edx
8010891d:	0f 45 c2             	cmovne %edx,%eax
}
80108920:	c3                   	ret    
80108921:	eb 0d                	jmp    80108930 <copyout>
80108923:	90                   	nop
80108924:	90                   	nop
80108925:	90                   	nop
80108926:	90                   	nop
80108927:	90                   	nop
80108928:	90                   	nop
80108929:	90                   	nop
8010892a:	90                   	nop
8010892b:	90                   	nop
8010892c:	90                   	nop
8010892d:	90                   	nop
8010892e:	90                   	nop
8010892f:	90                   	nop

80108930 <copyout>:
{
80108930:	55                   	push   %ebp
80108931:	89 e5                	mov    %esp,%ebp
80108933:	57                   	push   %edi
80108934:	56                   	push   %esi
80108935:	53                   	push   %ebx
80108936:	83 ec 1c             	sub    $0x1c,%esp
80108939:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010893c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010893f:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80108942:	85 db                	test   %ebx,%ebx
80108944:	75 40                	jne    80108986 <copyout+0x56>
80108946:	eb 70                	jmp    801089b8 <copyout+0x88>
80108948:	90                   	nop
80108949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80108950:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108953:	89 f1                	mov    %esi,%ecx
80108955:	29 d1                	sub    %edx,%ecx
80108957:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010895d:	39 d9                	cmp    %ebx,%ecx
8010895f:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
80108962:	29 f2                	sub    %esi,%edx
80108964:	83 ec 04             	sub    $0x4,%esp
80108967:	01 d0                	add    %edx,%eax
80108969:	51                   	push   %ecx
8010896a:	57                   	push   %edi
8010896b:	50                   	push   %eax
8010896c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010896f:	e8 3c ca ff ff       	call   801053b0 <memmove>
    buf += n;
80108974:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108977:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010897a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108980:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108982:	29 cb                	sub    %ecx,%ebx
80108984:	74 32                	je     801089b8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108986:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108988:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010898b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010898e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108994:	56                   	push   %esi
80108995:	ff 75 08             	pushl  0x8(%ebp)
80108998:	e8 53 ff ff ff       	call   801088f0 <uva2ka>
    if(pa0 == 0)
8010899d:	83 c4 10             	add    $0x10,%esp
801089a0:	85 c0                	test   %eax,%eax
801089a2:	75 ac                	jne    80108950 <copyout+0x20>
}
801089a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801089a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801089ac:	5b                   	pop    %ebx
801089ad:	5e                   	pop    %esi
801089ae:	5f                   	pop    %edi
801089af:	5d                   	pop    %ebp
801089b0:	c3                   	ret    
801089b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801089bb:	31 c0                	xor    %eax,%eax
}
801089bd:	5b                   	pop    %ebx
801089be:	5e                   	pop    %esi
801089bf:	5f                   	pop    %edi
801089c0:	5d                   	pop    %ebp
801089c1:	c3                   	ret    
801089c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801089d0 <getNextFreeRamIndex>:
{ 
801089d0:	55                   	push   %ebp
801089d1:	89 e5                	mov    %esp,%ebp
801089d3:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
801089d6:	e8 f5 b8 ff ff       	call   801042d0 <myproc>
801089db:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
801089e1:	31 c0                	xor    %eax,%eax
801089e3:	eb 0e                	jmp    801089f3 <getNextFreeRamIndex+0x23>
801089e5:	8d 76 00             	lea    0x0(%esi),%esi
801089e8:	83 c0 01             	add    $0x1,%eax
801089eb:	83 c2 1c             	add    $0x1c,%edx
801089ee:	83 f8 10             	cmp    $0x10,%eax
801089f1:	74 0d                	je     80108a00 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
801089f3:	8b 0a                	mov    (%edx),%ecx
801089f5:	85 c9                	test   %ecx,%ecx
801089f7:	75 ef                	jne    801089e8 <getNextFreeRamIndex+0x18>
}
801089f9:	c9                   	leave  
801089fa:	c3                   	ret    
801089fb:	90                   	nop
801089fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108a05:	c9                   	leave  
80108a06:	c3                   	ret    
80108a07:	89 f6                	mov    %esi,%esi
80108a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108a10 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108a10:	55                   	push   %ebp
80108a11:	89 e5                	mov    %esp,%ebp
80108a13:	56                   	push   %esi
80108a14:	53                   	push   %ebx
80108a15:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108a18:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108a1e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108a24:	eb 1d                	jmp    80108a43 <updateLapa+0x33>
80108a26:	8d 76 00             	lea    0x0(%esi),%esi
80108a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108a30:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108a36:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
80108a39:	83 20 df             	andl   $0xffffffdf,(%eax)
80108a3c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a3f:	39 f3                	cmp    %esi,%ebx
80108a41:	74 2b                	je     80108a6e <updateLapa+0x5e>
    if(!cur_page->isused)
80108a43:	8b 43 04             	mov    0x4(%ebx),%eax
80108a46:	85 c0                	test   %eax,%eax
80108a48:	74 f2                	je     80108a3c <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108a4a:	8b 53 08             	mov    0x8(%ebx),%edx
80108a4d:	8b 03                	mov    (%ebx),%eax
80108a4f:	31 c9                	xor    %ecx,%ecx
80108a51:	e8 5a ea ff ff       	call   801074b0 <walkpgdir>
80108a56:	85 c0                	test   %eax,%eax
80108a58:	74 1b                	je     80108a75 <updateLapa+0x65>
80108a5a:	8b 53 18             	mov    0x18(%ebx),%edx
80108a5d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
80108a5f:	f6 00 20             	testb  $0x20,(%eax)
80108a62:	75 cc                	jne    80108a30 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
80108a64:	89 53 18             	mov    %edx,0x18(%ebx)
80108a67:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a6a:	39 f3                	cmp    %esi,%ebx
80108a6c:	75 d5                	jne    80108a43 <updateLapa+0x33>
    }
  }
}
80108a6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a71:	5b                   	pop    %ebx
80108a72:	5e                   	pop    %esi
80108a73:	5d                   	pop    %ebp
80108a74:	c3                   	ret    
      panic("updateLapa: no pte");
80108a75:	83 ec 0c             	sub    $0xc,%esp
80108a78:	68 21 9c 10 80       	push   $0x80109c21
80108a7d:	e8 0e 79 ff ff       	call   80100390 <panic>
80108a82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108a90 <updateNfua>:

void updateNfua(struct proc* p)
{
80108a90:	55                   	push   %ebp
80108a91:	89 e5                	mov    %esp,%ebp
80108a93:	56                   	push   %esi
80108a94:	53                   	push   %ebx
80108a95:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108a98:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108a9e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108aa4:	eb 1d                	jmp    80108ac3 <updateNfua+0x33>
80108aa6:	8d 76 00             	lea    0x0(%esi),%esi
80108aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108ab0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108ab6:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108ab9:	83 20 df             	andl   $0xffffffdf,(%eax)
80108abc:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108abf:	39 f3                	cmp    %esi,%ebx
80108ac1:	74 2b                	je     80108aee <updateNfua+0x5e>
    if(!cur_page->isused)
80108ac3:	8b 43 04             	mov    0x4(%ebx),%eax
80108ac6:	85 c0                	test   %eax,%eax
80108ac8:	74 f2                	je     80108abc <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108aca:	8b 53 08             	mov    0x8(%ebx),%edx
80108acd:	8b 03                	mov    (%ebx),%eax
80108acf:	31 c9                	xor    %ecx,%ecx
80108ad1:	e8 da e9 ff ff       	call   801074b0 <walkpgdir>
80108ad6:	85 c0                	test   %eax,%eax
80108ad8:	74 1b                	je     80108af5 <updateNfua+0x65>
80108ada:	8b 53 14             	mov    0x14(%ebx),%edx
80108add:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
80108adf:	f6 00 20             	testb  $0x20,(%eax)
80108ae2:	75 cc                	jne    80108ab0 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108ae4:	89 53 14             	mov    %edx,0x14(%ebx)
80108ae7:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108aea:	39 f3                	cmp    %esi,%ebx
80108aec:	75 d5                	jne    80108ac3 <updateNfua+0x33>
    }
  }
}
80108aee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108af1:	5b                   	pop    %ebx
80108af2:	5e                   	pop    %esi
80108af3:	5d                   	pop    %ebp
80108af4:	c3                   	ret    
      panic("updateNfua: no pte");
80108af5:	83 ec 0c             	sub    $0xc,%esp
80108af8:	68 34 9c 10 80       	push   $0x80109c34
80108afd:	e8 8e 78 ff ff       	call   80100390 <panic>
80108b02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108b10 <indexToEvict>:
uint indexToEvict()
{  
80108b10:	55                   	push   %ebp
  #if SELECTION==AQ
    return aq();
  #else
  return 11; // default
  #endif
}
80108b11:	b8 03 00 00 00       	mov    $0x3,%eax
{  
80108b16:	89 e5                	mov    %esp,%ebp
}
80108b18:	5d                   	pop    %ebp
80108b19:	c3                   	ret    
80108b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108b20 <aq>:

uint aq()
{
80108b20:	55                   	push   %ebp
80108b21:	89 e5                	mov    %esp,%ebp
80108b23:	57                   	push   %edi
80108b24:	56                   	push   %esi
80108b25:	53                   	push   %ebx
80108b26:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108b29:	e8 a2 b7 ff ff       	call   801042d0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108b2e:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
80108b34:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108b3a:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
80108b3c:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108b3f:	74 45                	je     80108b86 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108b41:	39 d1                	cmp    %edx,%ecx
80108b43:	89 c3                	mov    %eax,%ebx
80108b45:	74 31                	je     80108b78 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108b47:	8b 41 04             	mov    0x4(%ecx),%eax
80108b4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108b50:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
80108b56:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
80108b59:	83 ec 0c             	sub    $0xc,%esp
80108b5c:	52                   	push   %edx
80108b5d:	e8 ee 9e ff ff       	call   80102a50 <kfree>
  curproc->queue_tail = new_tail;
80108b62:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
80108b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108b6b:	89 f0                	mov    %esi,%eax
80108b6d:	5b                   	pop    %ebx
80108b6e:	5e                   	pop    %esi
80108b6f:	5f                   	pop    %edi
80108b70:	5d                   	pop    %ebp
80108b71:	c3                   	ret    
80108b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108b78:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
80108b7f:	00 00 00 
    new_tail = 0;
80108b82:	31 ff                	xor    %edi,%edi
80108b84:	eb d3                	jmp    80108b59 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108b86:	83 ec 0c             	sub    $0xc,%esp
80108b89:	68 c8 9d 10 80       	push   $0x80109dc8
80108b8e:	e8 fd 77 ff ff       	call   80100390 <panic>
80108b93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108ba0 <lapa>:
uint lapa()
{
80108ba0:	55                   	push   %ebp
80108ba1:	89 e5                	mov    %esp,%ebp
80108ba3:	57                   	push   %edi
80108ba4:	56                   	push   %esi
80108ba5:	53                   	push   %ebx
80108ba6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108ba9:	e8 22 b7 ff ff       	call   801042d0 <myproc>
  struct page *ramPages = curproc->ramPages;
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
80108bae:	8b 90 60 02 00 00    	mov    0x260(%eax),%edx
  struct page *ramPages = curproc->ramPages;
80108bb4:	8d b8 48 02 00 00    	lea    0x248(%eax),%edi
80108bba:	89 7d dc             	mov    %edi,-0x24(%ebp)
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
80108bbd:	85 d2                	test   %edx,%edx
80108bbf:	0f 84 ff 00 00 00    	je     80108cc4 <lapa+0x124>
    uint count = 0;
80108bc5:	31 c9                	xor    %ecx,%ecx
80108bc7:	89 f6                	mov    %esi,%esi
80108bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        count += n & 1;
80108bd0:	89 d3                	mov    %edx,%ebx
80108bd2:	83 e3 01             	and    $0x1,%ebx
80108bd5:	01 d9                	add    %ebx,%ecx
    while (n) {
80108bd7:	d1 ea                	shr    %edx
80108bd9:	75 f5                	jne    80108bd0 <lapa+0x30>
80108bdb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108bde:	05 7c 02 00 00       	add    $0x27c,%eax
  uint instances = 0;
80108be3:	31 ff                	xor    %edi,%edi
  uint minloc = 0;
80108be5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108bec:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint count = 0;
80108bef:	89 c6                	mov    %eax,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108bf1:	bb 01 00 00 00       	mov    $0x1,%ebx
80108bf6:	8d 76 00             	lea    0x0(%esi),%esi
80108bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108c00:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108c02:	31 d2                	xor    %edx,%edx
    while (n) {
80108c04:	85 c0                	test   %eax,%eax
80108c06:	74 13                	je     80108c1b <lapa+0x7b>
80108c08:	90                   	nop
80108c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108c10:	89 c1                	mov    %eax,%ecx
80108c12:	83 e1 01             	and    $0x1,%ecx
80108c15:	01 ca                	add    %ecx,%edx
    while (n) {
80108c17:	d1 e8                	shr    %eax
80108c19:	75 f5                	jne    80108c10 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
80108c1b:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
80108c1e:	0f 82 84 00 00 00    	jb     80108ca8 <lapa+0x108>
      instances++;
80108c24:	0f 94 c0             	sete   %al
80108c27:	0f b6 c0             	movzbl %al,%eax
80108c2a:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c2c:	83 c3 01             	add    $0x1,%ebx
80108c2f:	83 c6 1c             	add    $0x1c,%esi
80108c32:	83 fb 10             	cmp    $0x10,%ebx
80108c35:	75 c9                	jne    80108c00 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108c37:	83 ff 01             	cmp    $0x1,%edi
80108c3a:	76 5b                	jbe    80108c97 <lapa+0xf7>
      uint minvalue = ramPages[minloc].lapa_counter;
80108c3c:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
80108c40:	8b 7d dc             	mov    -0x24(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c43:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108c48:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c4c:	89 7d dc             	mov    %edi,-0x24(%ebp)
80108c4f:	8b 7d d8             	mov    -0x28(%ebp),%edi
80108c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108c58:	8b 1f                	mov    (%edi),%ebx
    while (n) {
80108c5a:	85 db                	test   %ebx,%ebx
80108c5c:	74 62                	je     80108cc0 <lapa+0x120>
80108c5e:	89 d8                	mov    %ebx,%eax
    uint count = 0;
80108c60:	31 d2                	xor    %edx,%edx
80108c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
80108c68:	89 c1                	mov    %eax,%ecx
80108c6a:	83 e1 01             	and    $0x1,%ecx
80108c6d:	01 ca                	add    %ecx,%edx
    while (n) {
80108c6f:	d1 e8                	shr    %eax
80108c71:	75 f5                	jne    80108c68 <lapa+0xc8>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
80108c73:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108c76:	75 14                	jne    80108c8c <lapa+0xec>
80108c78:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108c7b:	39 c3                	cmp    %eax,%ebx
80108c7d:	0f 43 d8             	cmovae %eax,%ebx
80108c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c83:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80108c86:	0f 42 c6             	cmovb  %esi,%eax
80108c89:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c8c:	83 c6 01             	add    $0x1,%esi
80108c8f:	83 c7 1c             	add    $0x1c,%edi
80108c92:	83 fe 10             	cmp    $0x10,%esi
80108c95:	75 c1                	jne    80108c58 <lapa+0xb8>
}
80108c97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108c9a:	83 c4 1c             	add    $0x1c,%esp
80108c9d:	5b                   	pop    %ebx
80108c9e:	5e                   	pop    %esi
80108c9f:	5f                   	pop    %edi
80108ca0:	5d                   	pop    %ebp
80108ca1:	c3                   	ret    
80108ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      minloc = i;
80108ca8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80108cab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      instances = 1;
80108cae:	bf 01 00 00 00       	mov    $0x1,%edi
80108cb3:	e9 74 ff ff ff       	jmp    80108c2c <lapa+0x8c>
80108cb8:	90                   	nop
80108cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint count = 0;
80108cc0:	31 d2                	xor    %edx,%edx
80108cc2:	eb af                	jmp    80108c73 <lapa+0xd3>
80108cc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108ccb:	e9 0e ff ff ff       	jmp    80108bde <lapa+0x3e>

80108cd0 <nfua>:
{
80108cd0:	55                   	push   %ebp
80108cd1:	89 e5                	mov    %esp,%ebp
80108cd3:	56                   	push   %esi
80108cd4:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108cd5:	e8 f6 b5 ff ff       	call   801042d0 <myproc>
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108cda:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
80108cdf:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108ce5:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
80108ceb:	31 c0                	xor    %eax,%eax
80108ced:	8d 76 00             	lea    0x0(%esi),%esi
    if(ramPages[i].nfua_counter < minval)
80108cf0:	8b 19                	mov    (%ecx),%ebx
80108cf2:	39 f3                	cmp    %esi,%ebx
80108cf4:	73 04                	jae    80108cfa <nfua+0x2a>
      minloc = i;
80108cf6:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108cf8:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108cfa:	83 c2 01             	add    $0x1,%edx
80108cfd:	83 c1 1c             	add    $0x1c,%ecx
80108d00:	83 fa 10             	cmp    $0x10,%edx
80108d03:	75 eb                	jne    80108cf0 <nfua+0x20>
}
80108d05:	5b                   	pop    %ebx
80108d06:	5e                   	pop    %esi
80108d07:	5d                   	pop    %ebp
80108d08:	c3                   	ret    
80108d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108d10 <scfifo>:
{
80108d10:	55                   	push   %ebp
80108d11:	89 e5                	mov    %esp,%ebp
80108d13:	57                   	push   %edi
80108d14:	56                   	push   %esi
80108d15:	53                   	push   %ebx
80108d16:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108d19:	e8 b2 b5 ff ff       	call   801042d0 <myproc>
80108d1e:	89 c7                	mov    %eax,%edi
80108d20:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108d26:	83 f8 0f             	cmp    $0xf,%eax
80108d29:	89 c3                	mov    %eax,%ebx
80108d2b:	7f 5f                	jg     80108d8c <scfifo+0x7c>
80108d2d:	6b c0 1c             	imul   $0x1c,%eax,%eax
80108d30:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108d37:	eb 17                	jmp    80108d50 <scfifo+0x40>
80108d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108d40:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108d43:	83 e2 df             	and    $0xffffffdf,%edx
80108d46:	83 c6 1c             	add    $0x1c,%esi
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108d49:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
80108d4c:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108d4e:	74 30                	je     80108d80 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108d50:	8b 56 08             	mov    0x8(%esi),%edx
80108d53:	8b 06                	mov    (%esi),%eax
80108d55:	31 c9                	xor    %ecx,%ecx
80108d57:	e8 54 e7 ff ff       	call   801074b0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108d5c:	8b 10                	mov    (%eax),%edx
80108d5e:	f6 c2 20             	test   $0x20,%dl
80108d61:	75 dd                	jne    80108d40 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108d63:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108d6a:	74 74                	je     80108de0 <scfifo+0xd0>
            curproc->clockHand = i + 1;
80108d6c:	8d 43 01             	lea    0x1(%ebx),%eax
80108d6f:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
80108d75:	83 c4 0c             	add    $0xc,%esp
80108d78:	89 d8                	mov    %ebx,%eax
80108d7a:	5b                   	pop    %ebx
80108d7b:	5e                   	pop    %esi
80108d7c:	5f                   	pop    %edi
80108d7d:	5d                   	pop    %ebp
80108d7e:	c3                   	ret    
80108d7f:	90                   	nop
80108d80:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108d86:	31 db                	xor    %ebx,%ebx
    for(j=0; j< curproc->clockHand ;j++)
80108d88:	85 c0                	test   %eax,%eax
80108d8a:	74 a1                	je     80108d2d <scfifo+0x1d>
80108d8c:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108d92:	31 c9                	xor    %ecx,%ecx
80108d94:	eb 20                	jmp    80108db6 <scfifo+0xa6>
80108d96:	8d 76 00             	lea    0x0(%esi),%esi
80108d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          *pte &= ~PTE_A;  
80108da0:	83 e2 df             	and    $0xffffffdf,%edx
80108da3:	83 c6 1c             	add    $0x1c,%esi
80108da6:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108da8:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108dae:	39 c8                	cmp    %ecx,%eax
80108db0:	0f 86 70 ff ff ff    	jbe    80108d26 <scfifo+0x16>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108db6:	8b 56 08             	mov    0x8(%esi),%edx
80108db9:	8b 06                	mov    (%esi),%eax
80108dbb:	89 cb                	mov    %ecx,%ebx
80108dbd:	31 c9                	xor    %ecx,%ecx
80108dbf:	e8 ec e6 ff ff       	call   801074b0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108dc4:	8b 10                	mov    (%eax),%edx
80108dc6:	8d 4b 01             	lea    0x1(%ebx),%ecx
80108dc9:	f6 c2 20             	test   $0x20,%dl
80108dcc:	75 d2                	jne    80108da0 <scfifo+0x90>
          curproc->clockHand = j + 1;
80108dce:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108dd4:	83 c4 0c             	add    $0xc,%esp
80108dd7:	89 d8                	mov    %ebx,%eax
80108dd9:	5b                   	pop    %ebx
80108dda:	5e                   	pop    %esi
80108ddb:	5f                   	pop    %edi
80108ddc:	5d                   	pop    %ebp
80108ddd:	c3                   	ret    
80108dde:	66 90                	xchg   %ax,%ax
            curproc->clockHand = 0;
80108de0:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
80108de7:	00 00 00 
}
80108dea:	83 c4 0c             	add    $0xc,%esp
80108ded:	89 d8                	mov    %ebx,%eax
80108def:	5b                   	pop    %ebx
80108df0:	5e                   	pop    %esi
80108df1:	5f                   	pop    %edi
80108df2:	5d                   	pop    %ebp
80108df3:	c3                   	ret    
80108df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108e00 <countSetBits>:
{
80108e00:	55                   	push   %ebp
    uint count = 0;
80108e01:	31 c0                	xor    %eax,%eax
{
80108e03:	89 e5                	mov    %esp,%ebp
80108e05:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108e08:	85 d2                	test   %edx,%edx
80108e0a:	74 0f                	je     80108e1b <countSetBits+0x1b>
80108e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108e10:	89 d1                	mov    %edx,%ecx
80108e12:	83 e1 01             	and    $0x1,%ecx
80108e15:	01 c8                	add    %ecx,%eax
    while (n) {
80108e17:	d1 ea                	shr    %edx
80108e19:	75 f5                	jne    80108e10 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108e1b:	5d                   	pop    %ebp
80108e1c:	c3                   	ret    
80108e1d:	8d 76 00             	lea    0x0(%esi),%esi

80108e20 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108e20:	55                   	push   %ebp
80108e21:	89 e5                	mov    %esp,%ebp
80108e23:	56                   	push   %esi
80108e24:	53                   	push   %ebx
80108e25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
80108e28:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108e2b:	e8 a0 b4 ff ff       	call   801042d0 <myproc>
80108e30:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108e36:	74 30                	je     80108e68 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108e38:	e8 93 b4 ff ff       	call   801042d0 <myproc>
80108e3d:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108e43:	74 53                	je     80108e98 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108e45:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108e48:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108e4a:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108e4c:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108e4f:	85 d2                	test   %edx,%edx
80108e51:	74 05                	je     80108e58 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108e53:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108e56:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108e58:	85 c0                	test   %eax,%eax
80108e5a:	74 05                	je     80108e61 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108e5c:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108e5e:	89 70 04             	mov    %esi,0x4(%eax)
  }
80108e61:	5b                   	pop    %ebx
80108e62:	5e                   	pop    %esi
80108e63:	5d                   	pop    %ebp
80108e64:	c3                   	ret    
80108e65:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108e68:	e8 63 b4 ff ff       	call   801042d0 <myproc>
80108e6d:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108e73:	e8 58 b4 ff ff       	call   801042d0 <myproc>
80108e78:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108e7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108e84:	e8 47 b4 ff ff       	call   801042d0 <myproc>
80108e89:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108e8f:	75 b4                	jne    80108e45 <swapAQ+0x25>
80108e91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108e98:	e8 33 b4 ff ff       	call   801042d0 <myproc>
80108e9d:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108ea3:	e8 28 b4 ff ff       	call   801042d0 <myproc>
80108ea8:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108eae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108eb5:	eb 8e                	jmp    80108e45 <swapAQ+0x25>
80108eb7:	89 f6                	mov    %esi,%esi
80108eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108ec0 <updateAQ>:
{
80108ec0:	55                   	push   %ebp
80108ec1:	89 e5                	mov    %esp,%ebp
80108ec3:	57                   	push   %edi
80108ec4:	56                   	push   %esi
80108ec5:	53                   	push   %ebx
80108ec6:	83 ec 1c             	sub    $0x1c,%esp
80108ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108ecc:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108ed2:	85 d2                	test   %edx,%edx
80108ed4:	0f 84 7e 00 00 00    	je     80108f58 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108eda:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108ee0:	8b 56 04             	mov    0x4(%esi),%edx
80108ee3:	85 d2                	test   %edx,%edx
80108ee5:	74 71                	je     80108f58 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80108ee7:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
80108eed:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108ef1:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108ef5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108ef8:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108efa:	01 d8                	add    %ebx,%eax
80108efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80108f00:	8b 50 08             	mov    0x8(%eax),%edx
80108f03:	8b 00                	mov    (%eax),%eax
80108f05:	31 c9                	xor    %ecx,%ecx
80108f07:	e8 a4 e5 ff ff       	call   801074b0 <walkpgdir>
80108f0c:	85 c0                	test   %eax,%eax
80108f0e:	89 c3                	mov    %eax,%ebx
80108f10:	74 5e                	je     80108f70 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80108f12:	8b 00                	mov    (%eax),%eax
80108f14:	8b 56 04             	mov    0x4(%esi),%edx
80108f17:	a8 20                	test   $0x20,%al
80108f19:	74 23                	je     80108f3e <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
80108f1b:	85 d2                	test   %edx,%edx
80108f1d:	74 17                	je     80108f36 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80108f1f:	8b 57 08             	mov    0x8(%edi),%edx
80108f22:	8b 07                	mov    (%edi),%eax
80108f24:	31 c9                	xor    %ecx,%ecx
80108f26:	e8 85 e5 ff ff       	call   801074b0 <walkpgdir>
80108f2b:	85 c0                	test   %eax,%eax
80108f2d:	74 41                	je     80108f70 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80108f2f:	f6 00 20             	testb  $0x20,(%eax)
80108f32:	74 2c                	je     80108f60 <updateAQ+0xa0>
80108f34:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80108f36:	83 e0 df             	and    $0xffffffdf,%eax
80108f39:	89 03                	mov    %eax,(%ebx)
80108f3b:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80108f3e:	85 d2                	test   %edx,%edx
80108f40:	74 16                	je     80108f58 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80108f42:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108f46:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80108f4a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80108f4d:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
80108f4f:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108f51:	01 cf                	add    %ecx,%edi
80108f53:	eb ab                	jmp    80108f00 <updateAQ+0x40>
80108f55:	8d 76 00             	lea    0x0(%esi),%esi
}
80108f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108f5b:	5b                   	pop    %ebx
80108f5c:	5e                   	pop    %esi
80108f5d:	5f                   	pop    %edi
80108f5e:	5d                   	pop    %ebp
80108f5f:	c3                   	ret    
          swapAQ(curr_node);
80108f60:	83 ec 0c             	sub    $0xc,%esp
80108f63:	56                   	push   %esi
80108f64:	e8 b7 fe ff ff       	call   80108e20 <swapAQ>
80108f69:	8b 03                	mov    (%ebx),%eax
80108f6b:	83 c4 10             	add    $0x10,%esp
80108f6e:	eb c6                	jmp    80108f36 <updateAQ+0x76>
      panic("updateAQ: no pte");
80108f70:	83 ec 0c             	sub    $0xc,%esp
80108f73:	68 47 9c 10 80       	push   $0x80109c47
80108f78:	e8 13 74 ff ff       	call   80100390 <panic>
