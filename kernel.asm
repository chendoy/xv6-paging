
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
8010004c:	68 e0 8e 10 80       	push   $0x80108ee0
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 95 50 00 00       	call   801050f0 <initlock>
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
80100092:	68 e7 8e 10 80       	push   $0x80108ee7
80100097:	50                   	push   %eax
80100098:	e8 23 4f 00 00       	call   80104fc0 <initsleeplock>
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
801000e4:	e8 47 51 00 00       	call   80105230 <acquire>
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
80100162:	e8 89 51 00 00       	call   801052f0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 4e 00 00       	call   80105000 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 ed 26 00 00       	call   80102870 <iderw>
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
80100193:	68 ee 8e 10 80       	push   $0x80108eee
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
801001ae:	e8 ed 4e 00 00       	call   801050a0 <holdingsleep>
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
801001c4:	e9 a7 26 00 00       	jmp    80102870 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 8e 10 80       	push   $0x80108eff
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
801001ef:	e8 ac 4e 00 00       	call   801050a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 4e 00 00       	call   80105060 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 20 50 00 00       	call   80105230 <acquire>
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
8010025c:	e9 8f 50 00 00       	jmp    801052f0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 8f 10 80       	push   $0x80108f06
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
80100280:	e8 9b 18 00 00       	call   80101b20 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 9f 4f 00 00       	call   80105230 <acquire>
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
801002c5:	e8 16 48 00 00       	call   80104ae0 <sleep>
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
801002ef:	e8 fc 4f 00 00       	call   801052f0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 44 17 00 00       	call   80101a40 <ilock>
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
8010034d:	e8 9e 4f 00 00       	call   801052f0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 e6 16 00 00       	call   80101a40 <ilock>
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
801003b2:	68 0d 8f 10 80       	push   $0x80108f0d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 70 9b 10 80 	movl   $0x80109b70,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 33 4d 00 00       	call   80105110 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 8f 10 80       	push   $0x80108f21
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
8010043a:	e8 f1 65 00 00       	call   80106a30 <uartputc>
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
801004ec:	e8 3f 65 00 00       	call   80106a30 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 33 65 00 00       	call   80106a30 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 27 65 00 00       	call   80106a30 <uartputc>
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
80100524:	e8 c7 4e 00 00       	call   801053f0 <memmove>
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
80100541:	e8 fa 4d 00 00       	call   80105340 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 25 8f 10 80       	push   $0x80108f25
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
801005b1:	0f b6 92 50 8f 10 80 	movzbl -0x7fef70b0(%edx),%edx
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
8010060f:	e8 0c 15 00 00       	call   80101b20 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 10 4c 00 00       	call   80105230 <acquire>
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
80100647:	e8 a4 4c 00 00       	call   801052f0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 eb 13 00 00       	call   80101a40 <ilock>

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
8010071f:	e8 cc 4b 00 00       	call   801052f0 <release>
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
801007d0:	ba 38 8f 10 80       	mov    $0x80108f38,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 3b 4a 00 00       	call   80105230 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 3f 8f 10 80       	push   $0x80108f3f
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
80100823:	e8 08 4a 00 00       	call   80105230 <acquire>
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
80100888:	e8 63 4a 00 00       	call   801052f0 <release>
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
80100916:	e8 05 44 00 00       	call   80104d20 <wakeup>
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
80100997:	e9 14 45 00 00       	jmp    80104eb0 <procdump>
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
801009c6:	68 48 8f 10 80       	push   $0x80108f48
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 1b 47 00 00       	call   801050f0 <initlock>

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
801009f9:	e8 22 20 00 00       	call   80102a20 <ioapicenable>
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
80100a14:	83 ec 10             	sub    $0x10,%esp
80100a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  cprintf("exec now\n");
80100a1a:	68 61 8f 10 80       	push   $0x80108f61
80100a1f:	e8 3c fc ff ff       	call   80100660 <cprintf>
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100a24:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100a2a:	83 c4 0c             	add    $0xc,%esp
80100a2d:	68 c0 01 00 00       	push   $0x1c0
80100a32:	50                   	push   %eax
80100a33:	68 e0 2f 11 80       	push   $0x80112fe0
80100a38:	e8 b3 49 00 00       	call   801053f0 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a3d:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a43:	83 c4 0c             	add    $0xc,%esp
80100a46:	68 c0 01 00 00       	push   $0x1c0
80100a4b:	50                   	push   %eax
80100a4c:	68 c0 31 11 80       	push   $0x801131c0
80100a51:	e8 9a 49 00 00       	call   801053f0 <memmove>
  num_ram_backup = curproc->num_ram; 
80100a56:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
  free_tail_backup = curproc->free_tail;
  swapfile_backup = curproc->swapFile;
  queue_head_backup = curproc->queue_head;
  queue_tail_backup = curproc->queue_tail;
  clockhand_backup = curproc->clockHand;
}
80100a5c:	83 c4 10             	add    $0x10,%esp
  num_ram_backup = curproc->num_ram; 
80100a5f:	a3 6c c5 10 80       	mov    %eax,0x8010c56c
  num_swap_backup = curproc->num_swap;
80100a64:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
80100a6a:	a3 68 c5 10 80       	mov    %eax,0x8010c568
  free_head_backup = curproc->free_head;
80100a6f:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80100a75:	a3 60 c5 10 80       	mov    %eax,0x8010c560
  free_tail_backup = curproc->free_tail;
80100a7a:	8b 83 18 04 00 00    	mov    0x418(%ebx),%eax
80100a80:	a3 5c c5 10 80       	mov    %eax,0x8010c55c
  swapfile_backup = curproc->swapFile;
80100a85:	8b 43 7c             	mov    0x7c(%ebx),%eax
80100a88:	a3 a0 31 11 80       	mov    %eax,0x801131a0
  queue_head_backup = curproc->queue_head;
80100a8d:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80100a93:	a3 80 33 11 80       	mov    %eax,0x80113380
  queue_tail_backup = curproc->queue_tail;
80100a98:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
80100a9e:	a3 84 33 11 80       	mov    %eax,0x80113384
  clockhand_backup = curproc->clockHand;
80100aa3:	8b 83 10 04 00 00    	mov    0x410(%ebx),%eax
}
80100aa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  clockhand_backup = curproc->clockHand;
80100aac:	a3 64 c5 10 80       	mov    %eax,0x8010c564
}
80100ab1:	c9                   	leave  
80100ab2:	c3                   	ret    
80100ab3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ac0 <clean_arrays>:

void 
clean_arrays(struct proc* curproc)
{
80100ac0:	55                   	push   %ebp
80100ac1:	89 e5                	mov    %esp,%ebp
80100ac3:	53                   	push   %ebx
80100ac4:	83 ec 08             	sub    $0x8,%esp
80100ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memset((void*)curproc->swappedPages, 0, 16 * sizeof(struct page));
80100aca:	68 c0 01 00 00       	push   $0x1c0
80100acf:	6a 00                	push   $0x0
80100ad1:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100ad7:	50                   	push   %eax
80100ad8:	e8 63 48 00 00       	call   80105340 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100add:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ae3:	83 c4 0c             	add    $0xc,%esp
80100ae6:	68 c0 01 00 00       	push   $0x1c0
80100aeb:	6a 00                	push   $0x0
80100aed:	50                   	push   %eax
80100aee:	e8 4d 48 00 00       	call   80105340 <memset>
  curproc->num_ram = 0;
80100af3:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80100afa:	00 00 00 
  curproc->num_swap = 0;
80100afd:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80100b04:	00 00 00 
}
80100b07:	83 c4 10             	add    $0x10,%esp
80100b0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100b0d:	c9                   	leave  
80100b0e:	c3                   	ret    
80100b0f:	90                   	nop

80100b10 <alloc_fresh_fblocklst>:

void
alloc_fresh_fblocklst(struct proc* curproc)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
 /*allocating fresh fblock list */
  curproc->free_head = (struct fblock*)kalloc();
  curproc->free_head->prev = 0;
  curproc->free_head->off = 0 * PGSIZE;
  struct fblock *prev = curproc->free_head;
80100b16:	bb 00 10 00 00       	mov    $0x1000,%ebx
{
80100b1b:	83 ec 0c             	sub    $0xc,%esp
80100b1e:	8b 75 08             	mov    0x8(%ebp),%esi
  curproc->free_head = (struct fblock*)kalloc();
80100b21:	e8 1a 22 00 00       	call   80102d40 <kalloc>
80100b26:	89 86 14 04 00 00    	mov    %eax,0x414(%esi)
  curproc->free_head->prev = 0;
80100b2c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  curproc->free_head->off = 0 * PGSIZE;
80100b33:	8b 86 14 04 00 00    	mov    0x414(%esi),%eax
80100b39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  struct fblock *prev = curproc->free_head;
80100b3f:	8b be 14 04 00 00    	mov    0x414(%esi),%edi
80100b45:	8d 76 00             	lea    0x0(%esi),%esi

  for(int i = 1; i < MAX_PSYC_PAGES; i++)
  {
    struct fblock *curr = (struct fblock*)kalloc();
80100b48:	e8 f3 21 00 00       	call   80102d40 <kalloc>
    curr->off = i * PGSIZE;
80100b4d:	89 18                	mov    %ebx,(%eax)
80100b4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    curr->prev = prev;
80100b55:	89 78 08             	mov    %edi,0x8(%eax)
  for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100b58:	81 fb 00 00 01 00    	cmp    $0x10000,%ebx
    curr->prev->next = curr;
80100b5e:	89 47 04             	mov    %eax,0x4(%edi)
80100b61:	89 c7                	mov    %eax,%edi
  for(int i = 1; i < MAX_PSYC_PAGES; i++)
80100b63:	75 e3                	jne    80100b48 <alloc_fresh_fblocklst+0x38>
    prev = curr;
  }
  curproc->free_tail = prev;
80100b65:	89 86 18 04 00 00    	mov    %eax,0x418(%esi)
  curproc->free_tail->next = 0;
80100b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
80100b72:	83 c4 0c             	add    $0xc,%esp
80100b75:	5b                   	pop    %ebx
80100b76:	5e                   	pop    %esi
80100b77:	5f                   	pop    %edi
80100b78:	5d                   	pop    %ebp
80100b79:	c3                   	ret    
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <clean_by_selection>:

void
clean_by_selection(struct proc* curproc)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	53                   	push   %ebx
80100b84:	83 ec 04             	sub    $0x4,%esp
80100b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(curproc->selection == AQ)
80100b8a:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100b90:	83 f8 04             	cmp    $0x4,%eax
80100b93:	74 1b                	je     80100bb0 <clean_by_selection+0x30>
    curproc->queue_head = 0;
    curproc->queue_tail = 0;
    cprintf("cleaning exec queue\n");
  }

  if(curproc->selection == SCFIFO)
80100b95:	83 f8 03             	cmp    $0x3,%eax
80100b98:	75 0a                	jne    80100ba4 <clean_by_selection+0x24>
  {
    curproc->clockHand = 0;
80100b9a:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80100ba1:	00 00 00 
  }
}
80100ba4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ba7:	c9                   	leave  
80100ba8:	c3                   	ret    
80100ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cleaning exec queue\n");
80100bb0:	83 ec 0c             	sub    $0xc,%esp
    curproc->queue_head = 0;
80100bb3:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80100bba:	00 00 00 
    curproc->queue_tail = 0;
80100bbd:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80100bc4:	00 00 00 
    cprintf("cleaning exec queue\n");
80100bc7:	68 6b 8f 10 80       	push   $0x80108f6b
80100bcc:	e8 8f fa ff ff       	call   80100660 <cprintf>
80100bd1:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100bd7:	83 c4 10             	add    $0x10,%esp
80100bda:	eb b9                	jmp    80100b95 <clean_by_selection+0x15>
80100bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100be0 <allocate_fresh>:
void 
allocate_fresh(struct proc* curproc)
{
80100be0:	55                   	push   %ebp
80100be1:	89 e5                	mov    %esp,%ebp
80100be3:	53                   	push   %ebx
80100be4:	83 ec 10             	sub    $0x10,%esp
80100be7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(createSwapFile(curproc) != 0)
80100bea:	53                   	push   %ebx
80100beb:	e8 80 19 00 00       	call   80102570 <createSwapFile>
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	85 c0                	test   %eax,%eax
80100bf5:	75 65                	jne    80100c5c <allocate_fresh+0x7c>
    panic("exec: create swapfile for exec proc failed");
  clean_arrays(curproc);
80100bf7:	83 ec 0c             	sub    $0xc,%esp
80100bfa:	53                   	push   %ebx
80100bfb:	e8 c0 fe ff ff       	call   80100ac0 <clean_arrays>
  alloc_fresh_fblocklst(curproc);
80100c00:	89 1c 24             	mov    %ebx,(%esp)
80100c03:	e8 08 ff ff ff       	call   80100b10 <alloc_fresh_fblocklst>
  if(curproc->selection == AQ)
80100c08:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	83 f8 04             	cmp    $0x4,%eax
80100c14:	74 1a                	je     80100c30 <allocate_fresh+0x50>
  if(curproc->selection == SCFIFO)
80100c16:	83 f8 03             	cmp    $0x3,%eax
80100c19:	75 0a                	jne    80100c25 <allocate_fresh+0x45>
    curproc->clockHand = 0;
80100c1b:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80100c22:	00 00 00 
  clean_by_selection(curproc);

}
80100c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c28:	c9                   	leave  
80100c29:	c3                   	ret    
80100c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("cleaning exec queue\n");
80100c30:	83 ec 0c             	sub    $0xc,%esp
    curproc->queue_head = 0;
80100c33:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80100c3a:	00 00 00 
    curproc->queue_tail = 0;
80100c3d:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80100c44:	00 00 00 
    cprintf("cleaning exec queue\n");
80100c47:	68 6b 8f 10 80       	push   $0x80108f6b
80100c4c:	e8 0f fa ff ff       	call   80100660 <cprintf>
80100c51:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c57:	83 c4 10             	add    $0x10,%esp
80100c5a:	eb ba                	jmp    80100c16 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c5c:	83 ec 0c             	sub    $0xc,%esp
80100c5f:	68 98 8f 10 80       	push   $0x80108f98
80100c64:	e8 27 f7 ff ff       	call   80100390 <panic>
80100c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100c70 <exec>:

int
exec(char *path, char **argv)
{
80100c70:	55                   	push   %ebp
80100c71:	89 e5                	mov    %esp,%ebp
80100c73:	57                   	push   %edi
80100c74:	56                   	push   %esi
80100c75:	53                   	push   %ebx
80100c76:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100c7c:	e8 4f 36 00 00       	call   801042d0 <myproc>
  
  if(curproc->pid > 2)
80100c81:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *curproc = myproc();
80100c85:	89 c3                	mov    %eax,%ebx
  if(curproc->pid > 2)
80100c87:	0f 8f 93 00 00 00    	jg     80100d20 <exec+0xb0>
  {  
    backup(curproc);
    allocate_fresh(curproc);
  }

  begin_op();
80100c8d:	e8 ce 28 00 00       	call   80103560 <begin_op>

  if((ip = namei(path)) == 0){
80100c92:	83 ec 0c             	sub    $0xc,%esp
80100c95:	ff 75 08             	pushl  0x8(%ebp)
80100c98:	e8 03 16 00 00       	call   801022a0 <namei>
80100c9d:	83 c4 10             	add    $0x10,%esp
80100ca0:	85 c0                	test   %eax,%eax
80100ca2:	89 c6                	mov    %eax,%esi
80100ca4:	0f 84 2e 03 00 00    	je     80100fd8 <exec+0x368>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100caa:	83 ec 0c             	sub    $0xc,%esp
80100cad:	50                   	push   %eax
80100cae:	e8 8d 0d 00 00       	call   80101a40 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100cb3:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100cb9:	6a 34                	push   $0x34
80100cbb:	6a 00                	push   $0x0
80100cbd:	50                   	push   %eax
80100cbe:	56                   	push   %esi
80100cbf:	e8 5c 10 00 00       	call   80101d20 <readi>
80100cc4:	83 c4 20             	add    $0x20,%esp
80100cc7:	83 f8 34             	cmp    $0x34,%eax
80100cca:	75 10                	jne    80100cdc <exec+0x6c>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100ccc:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100cd3:	45 4c 46 
80100cd6:	0f 84 f4 00 00 00    	je     80100dd0 <exec+0x160>
  switchuvm(curproc);
  freevm(oldpgdir);
  return 0;

 bad:
  cprintf("exec: bad\n");
80100cdc:	83 ec 0c             	sub    $0xc,%esp
80100cdf:	68 8c 8f 10 80       	push   $0x80108f8c
80100ce4:	e8 77 f9 ff ff       	call   80100660 <cprintf>
80100ce9:	83 c4 10             	add    $0x10,%esp
  if(pgdir)
    freevm(pgdir);
  /* restoring variables */
  if(curproc->pid > 2)
80100cec:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100cf0:	7f 4e                	jg     80100d40 <exec+0xd0>
    curproc->queue_head = queue_head_backup;
    curproc->queue_tail = queue_tail_backup;
  }
  

  if(ip){
80100cf2:	85 f6                	test   %esi,%esi
    iunlockput(ip);
    end_op();
  }
  return -1;
80100cf4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(ip){
80100cf9:	74 11                	je     80100d0c <exec+0x9c>
    iunlockput(ip);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	56                   	push   %esi
80100cff:	e8 cc 0f 00 00       	call   80101cd0 <iunlockput>
    end_op();
80100d04:	e8 c7 28 00 00       	call   801035d0 <end_op>
80100d09:	83 c4 10             	add    $0x10,%esp
}
80100d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d0f:	89 d8                	mov    %ebx,%eax
80100d11:	5b                   	pop    %ebx
80100d12:	5e                   	pop    %esi
80100d13:	5f                   	pop    %edi
80100d14:	5d                   	pop    %ebp
80100d15:	c3                   	ret    
80100d16:	8d 76 00             	lea    0x0(%esi),%esi
80100d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    backup(curproc);
80100d20:	83 ec 0c             	sub    $0xc,%esp
80100d23:	50                   	push   %eax
80100d24:	e8 e7 fc ff ff       	call   80100a10 <backup>
    allocate_fresh(curproc);
80100d29:	89 1c 24             	mov    %ebx,(%esp)
80100d2c:	e8 af fe ff ff       	call   80100be0 <allocate_fresh>
80100d31:	83 c4 10             	add    $0x10,%esp
80100d34:	e9 54 ff ff ff       	jmp    80100c8d <exec+0x1d>
80100d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove((void*)curproc->ramPages, ramPagesBackup, 16 * sizeof(struct page));
80100d40:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100d46:	83 ec 04             	sub    $0x4,%esp
80100d49:	68 c0 01 00 00       	push   $0x1c0
80100d4e:	68 e0 2f 11 80       	push   $0x80112fe0
80100d53:	50                   	push   %eax
80100d54:	e8 97 46 00 00       	call   801053f0 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d59:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d5f:	83 c4 0c             	add    $0xc,%esp
80100d62:	68 c0 01 00 00       	push   $0x1c0
80100d67:	68 c0 31 11 80       	push   $0x801131c0
80100d6c:	50                   	push   %eax
80100d6d:	e8 7e 46 00 00       	call   801053f0 <memmove>
    curproc->free_head = free_head_backup;
80100d72:	a1 60 c5 10 80       	mov    0x8010c560,%eax
    curproc->queue_tail = queue_tail_backup;
80100d77:	83 c4 10             	add    $0x10,%esp
    curproc->free_head = free_head_backup;
80100d7a:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
    curproc->free_tail = free_tail_backup;
80100d80:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100d85:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    curproc->num_ram = num_ram_backup;
80100d8b:	a1 6c c5 10 80       	mov    0x8010c56c,%eax
80100d90:	89 83 08 04 00 00    	mov    %eax,0x408(%ebx)
    curproc->num_swap = num_swap_backup;
80100d96:	a1 68 c5 10 80       	mov    0x8010c568,%eax
80100d9b:	89 83 0c 04 00 00    	mov    %eax,0x40c(%ebx)
    curproc->swapFile = swapfile_backup;
80100da1:	a1 a0 31 11 80       	mov    0x801131a0,%eax
80100da6:	89 43 7c             	mov    %eax,0x7c(%ebx)
    curproc->clockHand = clockhand_backup;
80100da9:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80100dae:	89 83 10 04 00 00    	mov    %eax,0x410(%ebx)
    curproc->queue_head = queue_head_backup;
80100db4:	a1 80 33 11 80       	mov    0x80113380,%eax
80100db9:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
    curproc->queue_tail = queue_tail_backup;
80100dbf:	a1 84 33 11 80       	mov    0x80113384,%eax
80100dc4:	89 83 20 04 00 00    	mov    %eax,0x420(%ebx)
80100dca:	e9 23 ff ff ff       	jmp    80100cf2 <exec+0x82>
80100dcf:	90                   	nop
  if((pgdir = setupkvm()) == 0)
80100dd0:	e8 8b 6f 00 00       	call   80107d60 <setupkvm>
80100dd5:	85 c0                	test   %eax,%eax
80100dd7:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ddd:	0f 84 f9 fe ff ff    	je     80100cdc <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100de3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100dea:	00 
80100deb:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100df1:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100df7:	0f 84 00 03 00 00    	je     801010fd <exec+0x48d>
  sz = 0;
80100dfd:	31 c0                	xor    %eax,%eax
80100dff:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e05:	31 ff                	xor    %edi,%edi
80100e07:	89 c3                	mov    %eax,%ebx
80100e09:	eb 7f                	jmp    80100e8a <exec+0x21a>
80100e0b:	90                   	nop
80100e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100e10:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100e17:	75 63                	jne    80100e7c <exec+0x20c>
    if(ph.memsz < ph.filesz)
80100e19:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100e1f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100e25:	0f 82 86 00 00 00    	jb     80100eb1 <exec+0x241>
80100e2b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100e31:	72 7e                	jb     80100eb1 <exec+0x241>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100e33:	83 ec 04             	sub    $0x4,%esp
80100e36:	50                   	push   %eax
80100e37:	53                   	push   %ebx
80100e38:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e3e:	e8 cd 79 00 00       	call   80108810 <allocuvm>
80100e43:	83 c4 10             	add    $0x10,%esp
80100e46:	85 c0                	test   %eax,%eax
80100e48:	89 c3                	mov    %eax,%ebx
80100e4a:	74 65                	je     80100eb1 <exec+0x241>
    if(ph.vaddr % PGSIZE != 0)
80100e4c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100e52:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100e57:	75 58                	jne    80100eb1 <exec+0x241>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e59:	83 ec 0c             	sub    $0xc,%esp
80100e5c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100e62:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100e68:	56                   	push   %esi
80100e69:	50                   	push   %eax
80100e6a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e70:	e8 0b 6b 00 00       	call   80107980 <loaduvm>
80100e75:	83 c4 20             	add    $0x20,%esp
80100e78:	85 c0                	test   %eax,%eax
80100e7a:	78 35                	js     80100eb1 <exec+0x241>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e7c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100e83:	83 c7 01             	add    $0x1,%edi
80100e86:	39 f8                	cmp    %edi,%eax
80100e88:	7e 56                	jle    80100ee0 <exec+0x270>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100e8a:	89 f8                	mov    %edi,%eax
80100e8c:	6a 20                	push   $0x20
80100e8e:	c1 e0 05             	shl    $0x5,%eax
80100e91:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100e97:	50                   	push   %eax
80100e98:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100e9e:	50                   	push   %eax
80100e9f:	56                   	push   %esi
80100ea0:	e8 7b 0e 00 00       	call   80101d20 <readi>
80100ea5:	83 c4 10             	add    $0x10,%esp
80100ea8:	83 f8 20             	cmp    $0x20,%eax
80100eab:	0f 84 5f ff ff ff    	je     80100e10 <exec+0x1a0>
80100eb1:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  cprintf("exec: bad\n");
80100eb7:	83 ec 0c             	sub    $0xc,%esp
80100eba:	68 8c 8f 10 80       	push   $0x80108f8c
80100ebf:	e8 9c f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100ec4:	58                   	pop    %eax
80100ec5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ecb:	e8 10 6e 00 00       	call   80107ce0 <freevm>
80100ed0:	83 c4 10             	add    $0x10,%esp
80100ed3:	e9 14 fe ff ff       	jmp    80100cec <exec+0x7c>
80100ed8:	90                   	nop
80100ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ee0:	89 d8                	mov    %ebx,%eax
80100ee2:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100ee8:	05 ff 0f 00 00       	add    $0xfff,%eax
80100eed:	89 c7                	mov    %eax,%edi
80100eef:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100ef5:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100efb:	83 ec 0c             	sub    $0xc,%esp
80100efe:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f04:	56                   	push   %esi
80100f05:	e8 c6 0d 00 00       	call   80101cd0 <iunlockput>
  end_op();
80100f0a:	e8 c1 26 00 00       	call   801035d0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100f0f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f15:	83 c4 0c             	add    $0xc,%esp
80100f18:	50                   	push   %eax
80100f19:	57                   	push   %edi
80100f1a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f20:	e8 eb 78 00 00       	call   80108810 <allocuvm>
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	85 c0                	test   %eax,%eax
80100f2a:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f30:	75 04                	jne    80100f36 <exec+0x2c6>
  ip = 0;
80100f32:	31 f6                	xor    %esi,%esi
80100f34:	eb 81                	jmp    80100eb7 <exec+0x247>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f36:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f3c:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100f3f:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f41:	8d 86 00 e0 ff ff    	lea    -0x2000(%esi),%eax
80100f47:	50                   	push   %eax
80100f48:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f4e:	e8 bd 6e 00 00       	call   80107e10 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f53:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f56:	83 c4 10             	add    $0x10,%esp
80100f59:	8b 00                	mov    (%eax),%eax
80100f5b:	85 c0                	test   %eax,%eax
80100f5d:	0f 84 a6 01 00 00    	je     80101109 <exec+0x499>
80100f63:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
80100f69:	89 fb                	mov    %edi,%ebx
80100f6b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100f71:	eb 24                	jmp    80100f97 <exec+0x327>
80100f73:	90                   	nop
80100f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f78:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f7b:	89 b4 9d 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100f82:	83 c3 01             	add    $0x1,%ebx
    ustack[3+argc] = sp;
80100f85:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100f8b:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80100f8e:	85 c0                	test   %eax,%eax
80100f90:	74 65                	je     80100ff7 <exec+0x387>
    if(argc >= MAXARG)
80100f92:	83 fb 20             	cmp    $0x20,%ebx
80100f95:	74 34                	je     80100fcb <exec+0x35b>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f97:	83 ec 0c             	sub    $0xc,%esp
80100f9a:	50                   	push   %eax
80100f9b:	e8 c0 45 00 00       	call   80105560 <strlen>
80100fa0:	f7 d0                	not    %eax
80100fa2:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fa4:	58                   	pop    %eax
80100fa5:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100fa8:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100fab:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fae:	e8 ad 45 00 00       	call   80105560 <strlen>
80100fb3:	83 c0 01             	add    $0x1,%eax
80100fb6:	50                   	push   %eax
80100fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fba:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fbd:	56                   	push   %esi
80100fbe:	57                   	push   %edi
80100fbf:	e8 1c 72 00 00       	call   801081e0 <copyout>
80100fc4:	83 c4 20             	add    $0x20,%esp
80100fc7:	85 c0                	test   %eax,%eax
80100fc9:	79 ad                	jns    80100f78 <exec+0x308>
80100fcb:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ip = 0;
80100fd1:	31 f6                	xor    %esi,%esi
80100fd3:	e9 df fe ff ff       	jmp    80100eb7 <exec+0x247>
    end_op();
80100fd8:	e8 f3 25 00 00       	call   801035d0 <end_op>
    cprintf("exec: fail\n");
80100fdd:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80100fe0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("exec: fail\n");
80100fe5:	68 80 8f 10 80       	push   $0x80108f80
80100fea:	e8 71 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100fef:	83 c4 10             	add    $0x10,%esp
80100ff2:	e9 15 fd ff ff       	jmp    80100d0c <exec+0x9c>
80100ff7:	89 df                	mov    %ebx,%edi
80100ff9:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fff:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80101006:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80101008:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
8010100f:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80101013:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
8010101a:	ff ff ff 
  ustack[1] = argc;
8010101d:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101023:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80101025:	83 c0 0c             	add    $0xc,%eax
80101028:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
8010102a:	50                   	push   %eax
8010102b:	51                   	push   %ecx
8010102c:	56                   	push   %esi
8010102d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80101033:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101039:	e8 a2 71 00 00       	call   801081e0 <copyout>
8010103e:	83 c4 10             	add    $0x10,%esp
80101041:	85 c0                	test   %eax,%eax
80101043:	0f 88 e9 fe ff ff    	js     80100f32 <exec+0x2c2>
  for(last=s=path; *s; s++)
80101049:	8b 45 08             	mov    0x8(%ebp),%eax
8010104c:	8b 55 08             	mov    0x8(%ebp),%edx
8010104f:	0f b6 00             	movzbl (%eax),%eax
80101052:	84 c0                	test   %al,%al
80101054:	74 11                	je     80101067 <exec+0x3f7>
80101056:	89 d1                	mov    %edx,%ecx
80101058:	83 c1 01             	add    $0x1,%ecx
8010105b:	3c 2f                	cmp    $0x2f,%al
8010105d:	0f b6 01             	movzbl (%ecx),%eax
80101060:	0f 44 d1             	cmove  %ecx,%edx
80101063:	84 c0                	test   %al,%al
80101065:	75 f1                	jne    80101058 <exec+0x3e8>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101067:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010106a:	83 ec 04             	sub    $0x4,%esp
8010106d:	6a 10                	push   $0x10
8010106f:	52                   	push   %edx
80101070:	50                   	push   %eax
80101071:	e8 aa 44 00 00       	call   80105520 <safestrcpy>
80101076:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
8010107c:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80101082:	8d 93 48 02 00 00    	lea    0x248(%ebx),%edx
80101088:	83 c4 10             	add    $0x10,%esp
8010108b:	90                   	nop
8010108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ramPages[ind].isused)
80101090:	8b b8 c4 01 00 00    	mov    0x1c4(%eax),%edi
80101096:	85 ff                	test   %edi,%edi
80101098:	74 06                	je     801010a0 <exec+0x430>
      curproc->ramPages[ind].pgdir = pgdir;
8010109a:	89 88 c0 01 00 00    	mov    %ecx,0x1c0(%eax)
    if(curproc->swappedPages[ind].isused)
801010a0:	8b 78 04             	mov    0x4(%eax),%edi
801010a3:	85 ff                	test   %edi,%edi
801010a5:	74 02                	je     801010a9 <exec+0x439>
      curproc->swappedPages[ind].pgdir = pgdir;
801010a7:	89 08                	mov    %ecx,(%eax)
801010a9:	83 c0 1c             	add    $0x1c,%eax
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
801010ac:	39 d0                	cmp    %edx,%eax
801010ae:	75 e0                	jne    80101090 <exec+0x420>
  oldpgdir = curproc->pgdir;
801010b0:	8b 43 04             	mov    0x4(%ebx),%eax
  curproc->tf->eip = elf.entry;  // main
801010b3:	8b 53 18             	mov    0x18(%ebx),%edx
  switchuvm(curproc);
801010b6:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
801010b9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
801010bf:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801010c5:	89 43 04             	mov    %eax,0x4(%ebx)
  curproc->sz = sz;
801010c8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010ce:	89 03                	mov    %eax,(%ebx)
  curproc->tf->eip = elf.entry;  // main
801010d0:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
801010d6:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
801010d9:	8b 53 18             	mov    0x18(%ebx),%edx
801010dc:	89 72 44             	mov    %esi,0x44(%edx)
  switchuvm(curproc);
801010df:	53                   	push   %ebx
  return 0;
801010e0:	31 db                	xor    %ebx,%ebx
  switchuvm(curproc);
801010e2:	e8 09 67 00 00       	call   801077f0 <switchuvm>
  freevm(oldpgdir);
801010e7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010ed:	89 04 24             	mov    %eax,(%esp)
801010f0:	e8 eb 6b 00 00       	call   80107ce0 <freevm>
  return 0;
801010f5:	83 c4 10             	add    $0x10,%esp
801010f8:	e9 0f fc ff ff       	jmp    80100d0c <exec+0x9c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010fd:	31 ff                	xor    %edi,%edi
801010ff:	b8 00 20 00 00       	mov    $0x2000,%eax
80101104:	e9 f2 fd ff ff       	jmp    80100efb <exec+0x28b>
  for(argc = 0; argv[argc]; argc++) {
80101109:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
8010110f:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80101115:	e9 e5 fe ff ff       	jmp    80100fff <exec+0x38f>
8010111a:	66 90                	xchg   %ax,%ax
8010111c:	66 90                	xchg   %ax,%ax
8010111e:	66 90                	xchg   %ax,%ax

80101120 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101126:	68 c3 8f 10 80       	push   $0x80108fc3
8010112b:	68 a0 33 11 80       	push   $0x801133a0
80101130:	e8 bb 3f 00 00       	call   801050f0 <initlock>
}
80101135:	83 c4 10             	add    $0x10,%esp
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101144:	bb d4 33 11 80       	mov    $0x801133d4,%ebx
{
80101149:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010114c:	68 a0 33 11 80       	push   $0x801133a0
80101151:	e8 da 40 00 00       	call   80105230 <acquire>
80101156:	83 c4 10             	add    $0x10,%esp
80101159:	eb 10                	jmp    8010116b <filealloc+0x2b>
8010115b:	90                   	nop
8010115c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101160:	83 c3 18             	add    $0x18,%ebx
80101163:	81 fb 34 3d 11 80    	cmp    $0x80113d34,%ebx
80101169:	73 25                	jae    80101190 <filealloc+0x50>
    if(f->ref == 0){
8010116b:	8b 43 04             	mov    0x4(%ebx),%eax
8010116e:	85 c0                	test   %eax,%eax
80101170:	75 ee                	jne    80101160 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101172:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101175:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010117c:	68 a0 33 11 80       	push   $0x801133a0
80101181:	e8 6a 41 00 00       	call   801052f0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101186:	89 d8                	mov    %ebx,%eax
      return f;
80101188:	83 c4 10             	add    $0x10,%esp
}
8010118b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010118e:	c9                   	leave  
8010118f:	c3                   	ret    
  release(&ftable.lock);
80101190:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101193:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101195:	68 a0 33 11 80       	push   $0x801133a0
8010119a:	e8 51 41 00 00       	call   801052f0 <release>
}
8010119f:	89 d8                	mov    %ebx,%eax
  return 0;
801011a1:	83 c4 10             	add    $0x10,%esp
}
801011a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011a7:	c9                   	leave  
801011a8:	c3                   	ret    
801011a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801011b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	53                   	push   %ebx
801011b4:	83 ec 10             	sub    $0x10,%esp
801011b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
801011ba:	68 a0 33 11 80       	push   $0x801133a0
801011bf:	e8 6c 40 00 00       	call   80105230 <acquire>
  if(f->ref < 1)
801011c4:	8b 43 04             	mov    0x4(%ebx),%eax
801011c7:	83 c4 10             	add    $0x10,%esp
801011ca:	85 c0                	test   %eax,%eax
801011cc:	7e 1a                	jle    801011e8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011ce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011d1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801011d4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011d7:	68 a0 33 11 80       	push   $0x801133a0
801011dc:	e8 0f 41 00 00       	call   801052f0 <release>
  return f;
}
801011e1:	89 d8                	mov    %ebx,%eax
801011e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011e6:	c9                   	leave  
801011e7:	c3                   	ret    
    panic("filedup");
801011e8:	83 ec 0c             	sub    $0xc,%esp
801011eb:	68 ca 8f 10 80       	push   $0x80108fca
801011f0:	e8 9b f1 ff ff       	call   80100390 <panic>
801011f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101200 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	83 ec 28             	sub    $0x28,%esp
80101209:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010120c:	68 a0 33 11 80       	push   $0x801133a0
80101211:	e8 1a 40 00 00       	call   80105230 <acquire>
  if(f->ref < 1)
80101216:	8b 43 04             	mov    0x4(%ebx),%eax
80101219:	83 c4 10             	add    $0x10,%esp
8010121c:	85 c0                	test   %eax,%eax
8010121e:	0f 8e 9b 00 00 00    	jle    801012bf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101224:	83 e8 01             	sub    $0x1,%eax
80101227:	85 c0                	test   %eax,%eax
80101229:	89 43 04             	mov    %eax,0x4(%ebx)
8010122c:	74 1a                	je     80101248 <fileclose+0x48>
    release(&ftable.lock);
8010122e:	c7 45 08 a0 33 11 80 	movl   $0x801133a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101235:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101238:	5b                   	pop    %ebx
80101239:	5e                   	pop    %esi
8010123a:	5f                   	pop    %edi
8010123b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010123c:	e9 af 40 00 00       	jmp    801052f0 <release>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101248:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010124c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010124e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101251:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101254:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010125a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010125d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101260:	68 a0 33 11 80       	push   $0x801133a0
  ff = *f;
80101265:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101268:	e8 83 40 00 00       	call   801052f0 <release>
  if(ff.type == FD_PIPE)
8010126d:	83 c4 10             	add    $0x10,%esp
80101270:	83 ff 01             	cmp    $0x1,%edi
80101273:	74 13                	je     80101288 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101275:	83 ff 02             	cmp    $0x2,%edi
80101278:	74 26                	je     801012a0 <fileclose+0xa0>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	5b                   	pop    %ebx
8010127e:	5e                   	pop    %esi
8010127f:	5f                   	pop    %edi
80101280:	5d                   	pop    %ebp
80101281:	c3                   	ret    
80101282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101288:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010128c:	83 ec 08             	sub    $0x8,%esp
8010128f:	53                   	push   %ebx
80101290:	56                   	push   %esi
80101291:	e8 7a 2a 00 00       	call   80103d10 <pipeclose>
80101296:	83 c4 10             	add    $0x10,%esp
80101299:	eb df                	jmp    8010127a <fileclose+0x7a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
801012a0:	e8 bb 22 00 00       	call   80103560 <begin_op>
    iput(ff.ip);
801012a5:	83 ec 0c             	sub    $0xc,%esp
801012a8:	ff 75 e0             	pushl  -0x20(%ebp)
801012ab:	e8 c0 08 00 00       	call   80101b70 <iput>
    end_op();
801012b0:	83 c4 10             	add    $0x10,%esp
}
801012b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b6:	5b                   	pop    %ebx
801012b7:	5e                   	pop    %esi
801012b8:	5f                   	pop    %edi
801012b9:	5d                   	pop    %ebp
    end_op();
801012ba:	e9 11 23 00 00       	jmp    801035d0 <end_op>
    panic("fileclose");
801012bf:	83 ec 0c             	sub    $0xc,%esp
801012c2:	68 d2 8f 10 80       	push   $0x80108fd2
801012c7:	e8 c4 f0 ff ff       	call   80100390 <panic>
801012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012d0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	53                   	push   %ebx
801012d4:	83 ec 04             	sub    $0x4,%esp
801012d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012da:	83 3b 02             	cmpl   $0x2,(%ebx)
801012dd:	75 31                	jne    80101310 <filestat+0x40>
    ilock(f->ip);
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	ff 73 10             	pushl  0x10(%ebx)
801012e5:	e8 56 07 00 00       	call   80101a40 <ilock>
    stati(f->ip, st);
801012ea:	58                   	pop    %eax
801012eb:	5a                   	pop    %edx
801012ec:	ff 75 0c             	pushl  0xc(%ebp)
801012ef:	ff 73 10             	pushl  0x10(%ebx)
801012f2:	e8 f9 09 00 00       	call   80101cf0 <stati>
    iunlock(f->ip);
801012f7:	59                   	pop    %ecx
801012f8:	ff 73 10             	pushl  0x10(%ebx)
801012fb:	e8 20 08 00 00       	call   80101b20 <iunlock>
    return 0;
80101300:	83 c4 10             	add    $0x10,%esp
80101303:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101305:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101308:	c9                   	leave  
80101309:	c3                   	ret    
8010130a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101315:	eb ee                	jmp    80101305 <filestat+0x35>
80101317:	89 f6                	mov    %esi,%esi
80101319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101320 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101320:	55                   	push   %ebp
80101321:	89 e5                	mov    %esp,%ebp
80101323:	57                   	push   %edi
80101324:	56                   	push   %esi
80101325:	53                   	push   %ebx
80101326:	83 ec 0c             	sub    $0xc,%esp
80101329:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010132c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010132f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101332:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101336:	74 60                	je     80101398 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101338:	8b 03                	mov    (%ebx),%eax
8010133a:	83 f8 01             	cmp    $0x1,%eax
8010133d:	74 41                	je     80101380 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010133f:	83 f8 02             	cmp    $0x2,%eax
80101342:	75 5b                	jne    8010139f <fileread+0x7f>
    ilock(f->ip);
80101344:	83 ec 0c             	sub    $0xc,%esp
80101347:	ff 73 10             	pushl  0x10(%ebx)
8010134a:	e8 f1 06 00 00       	call   80101a40 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010134f:	57                   	push   %edi
80101350:	ff 73 14             	pushl  0x14(%ebx)
80101353:	56                   	push   %esi
80101354:	ff 73 10             	pushl  0x10(%ebx)
80101357:	e8 c4 09 00 00       	call   80101d20 <readi>
8010135c:	83 c4 20             	add    $0x20,%esp
8010135f:	85 c0                	test   %eax,%eax
80101361:	89 c6                	mov    %eax,%esi
80101363:	7e 03                	jle    80101368 <fileread+0x48>
      f->off += r;
80101365:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101368:	83 ec 0c             	sub    $0xc,%esp
8010136b:	ff 73 10             	pushl  0x10(%ebx)
8010136e:	e8 ad 07 00 00       	call   80101b20 <iunlock>
    return r;
80101373:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101376:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101379:	89 f0                	mov    %esi,%eax
8010137b:	5b                   	pop    %ebx
8010137c:	5e                   	pop    %esi
8010137d:	5f                   	pop    %edi
8010137e:	5d                   	pop    %ebp
8010137f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101380:	8b 43 0c             	mov    0xc(%ebx),%eax
80101383:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101386:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101389:	5b                   	pop    %ebx
8010138a:	5e                   	pop    %esi
8010138b:	5f                   	pop    %edi
8010138c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010138d:	e9 2e 2b 00 00       	jmp    80103ec0 <piperead>
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101398:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010139d:	eb d7                	jmp    80101376 <fileread+0x56>
  panic("fileread");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 dc 8f 10 80       	push   $0x80108fdc
801013a7:	e8 e4 ef ff ff       	call   80100390 <panic>
801013ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	83 ec 1c             	sub    $0x1c,%esp
801013b9:	8b 75 08             	mov    0x8(%ebp),%esi
801013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801013bf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801013c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013c6:	8b 45 10             	mov    0x10(%ebp),%eax
801013c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801013cc:	0f 84 aa 00 00 00    	je     8010147c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801013d2:	8b 06                	mov    (%esi),%eax
801013d4:	83 f8 01             	cmp    $0x1,%eax
801013d7:	0f 84 c3 00 00 00    	je     801014a0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013dd:	83 f8 02             	cmp    $0x2,%eax
801013e0:	0f 85 d9 00 00 00    	jne    801014bf <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801013e9:	31 ff                	xor    %edi,%edi
    while(i < n){
801013eb:	85 c0                	test   %eax,%eax
801013ed:	7f 34                	jg     80101423 <filewrite+0x73>
801013ef:	e9 9c 00 00 00       	jmp    80101490 <filewrite+0xe0>
801013f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013f8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801013fb:	83 ec 0c             	sub    $0xc,%esp
801013fe:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101401:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101404:	e8 17 07 00 00       	call   80101b20 <iunlock>
      end_op();
80101409:	e8 c2 21 00 00       	call   801035d0 <end_op>
8010140e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101411:	83 c4 10             	add    $0x10,%esp
      if(r < 0)
        break;
      if(r != n1)
80101414:	39 c3                	cmp    %eax,%ebx
80101416:	0f 85 96 00 00 00    	jne    801014b2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010141c:	01 df                	add    %ebx,%edi
    while(i < n){
8010141e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101421:	7e 6d                	jle    80101490 <filewrite+0xe0>
      int n1 = n - i;
80101423:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101426:	b8 00 06 00 00       	mov    $0x600,%eax
8010142b:	29 fb                	sub    %edi,%ebx
8010142d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101433:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101436:	e8 25 21 00 00       	call   80103560 <begin_op>
      ilock(f->ip);
8010143b:	83 ec 0c             	sub    $0xc,%esp
8010143e:	ff 76 10             	pushl  0x10(%esi)
80101441:	e8 fa 05 00 00       	call   80101a40 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101446:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101449:	53                   	push   %ebx
8010144a:	ff 76 14             	pushl  0x14(%esi)
8010144d:	01 f8                	add    %edi,%eax
8010144f:	50                   	push   %eax
80101450:	ff 76 10             	pushl  0x10(%esi)
80101453:	e8 c8 09 00 00       	call   80101e20 <writei>
80101458:	83 c4 20             	add    $0x20,%esp
8010145b:	85 c0                	test   %eax,%eax
8010145d:	7f 99                	jg     801013f8 <filewrite+0x48>
      iunlock(f->ip);
8010145f:	83 ec 0c             	sub    $0xc,%esp
80101462:	ff 76 10             	pushl  0x10(%esi)
80101465:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101468:	e8 b3 06 00 00       	call   80101b20 <iunlock>
      end_op();
8010146d:	e8 5e 21 00 00       	call   801035d0 <end_op>
      if(r < 0)
80101472:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101475:	83 c4 10             	add    $0x10,%esp
80101478:	85 c0                	test   %eax,%eax
8010147a:	74 98                	je     80101414 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010147c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010147f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101484:	89 f8                	mov    %edi,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	90                   	nop
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101490:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101493:	75 e7                	jne    8010147c <filewrite+0xcc>
}
80101495:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101498:	89 f8                	mov    %edi,%eax
8010149a:	5b                   	pop    %ebx
8010149b:	5e                   	pop    %esi
8010149c:	5f                   	pop    %edi
8010149d:	5d                   	pop    %ebp
8010149e:	c3                   	ret    
8010149f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801014a0:	8b 46 0c             	mov    0xc(%esi),%eax
801014a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801014a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a9:	5b                   	pop    %ebx
801014aa:	5e                   	pop    %esi
801014ab:	5f                   	pop    %edi
801014ac:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801014ad:	e9 fe 28 00 00       	jmp    80103db0 <pipewrite>
        panic("short filewrite");
801014b2:	83 ec 0c             	sub    $0xc,%esp
801014b5:	68 e5 8f 10 80       	push   $0x80108fe5
801014ba:	e8 d1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014bf:	83 ec 0c             	sub    $0xc,%esp
801014c2:	68 eb 8f 10 80       	push   $0x80108feb
801014c7:	e8 c4 ee ff ff       	call   80100390 <panic>
801014cc:	66 90                	xchg   %ax,%ax
801014ce:	66 90                	xchg   %ax,%ax

801014d0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	56                   	push   %esi
801014d4:	53                   	push   %ebx
801014d5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014d7:	c1 ea 0c             	shr    $0xc,%edx
801014da:	03 15 b8 3d 11 80    	add    0x80113db8,%edx
801014e0:	83 ec 08             	sub    $0x8,%esp
801014e3:	52                   	push   %edx
801014e4:	50                   	push   %eax
801014e5:	e8 e6 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014ea:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ec:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014ef:	ba 01 00 00 00       	mov    $0x1,%edx
801014f4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101500:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101502:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101507:	85 d1                	test   %edx,%ecx
80101509:	74 25                	je     80101530 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010150b:	f7 d2                	not    %edx
8010150d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010150f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101512:	21 ca                	and    %ecx,%edx
80101514:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101518:	56                   	push   %esi
80101519:	e8 12 22 00 00       	call   80103730 <log_write>
  brelse(bp);
8010151e:	89 34 24             	mov    %esi,(%esp)
80101521:	e8 ba ec ff ff       	call   801001e0 <brelse>
}
80101526:	83 c4 10             	add    $0x10,%esp
80101529:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152c:	5b                   	pop    %ebx
8010152d:	5e                   	pop    %esi
8010152e:	5d                   	pop    %ebp
8010152f:	c3                   	ret    
    panic("freeing free block");
80101530:	83 ec 0c             	sub    $0xc,%esp
80101533:	68 f5 8f 10 80       	push   $0x80108ff5
80101538:	e8 53 ee ff ff       	call   80100390 <panic>
8010153d:	8d 76 00             	lea    0x0(%esi),%esi

80101540 <balloc>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101549:	8b 0d a0 3d 11 80    	mov    0x80113da0,%ecx
{
8010154f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101552:	85 c9                	test   %ecx,%ecx
80101554:	0f 84 87 00 00 00    	je     801015e1 <balloc+0xa1>
8010155a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101561:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101564:	83 ec 08             	sub    $0x8,%esp
80101567:	89 f0                	mov    %esi,%eax
80101569:	c1 f8 0c             	sar    $0xc,%eax
8010156c:	03 05 b8 3d 11 80    	add    0x80113db8,%eax
80101572:	50                   	push   %eax
80101573:	ff 75 d8             	pushl  -0x28(%ebp)
80101576:	e8 55 eb ff ff       	call   801000d0 <bread>
8010157b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010157e:	a1 a0 3d 11 80       	mov    0x80113da0,%eax
80101583:	83 c4 10             	add    $0x10,%esp
80101586:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101589:	31 c0                	xor    %eax,%eax
8010158b:	eb 2f                	jmp    801015bc <balloc+0x7c>
8010158d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101590:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101592:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101595:	bb 01 00 00 00       	mov    $0x1,%ebx
8010159a:	83 e1 07             	and    $0x7,%ecx
8010159d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010159f:	89 c1                	mov    %eax,%ecx
801015a1:	c1 f9 03             	sar    $0x3,%ecx
801015a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801015a9:	85 df                	test   %ebx,%edi
801015ab:	89 fa                	mov    %edi,%edx
801015ad:	74 41                	je     801015f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015af:	83 c0 01             	add    $0x1,%eax
801015b2:	83 c6 01             	add    $0x1,%esi
801015b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801015ba:	74 05                	je     801015c1 <balloc+0x81>
801015bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801015bf:	77 cf                	ja     80101590 <balloc+0x50>
    brelse(bp);
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801015c7:	e8 14 ec ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801015cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015d3:	83 c4 10             	add    $0x10,%esp
801015d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015d9:	39 05 a0 3d 11 80    	cmp    %eax,0x80113da0
801015df:	77 80                	ja     80101561 <balloc+0x21>
  panic("balloc: out of blocks");
801015e1:	83 ec 0c             	sub    $0xc,%esp
801015e4:	68 08 90 10 80       	push   $0x80109008
801015e9:	e8 a2 ed ff ff       	call   80100390 <panic>
801015ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801015f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801015f6:	09 da                	or     %ebx,%edx
801015f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015fc:	57                   	push   %edi
801015fd:	e8 2e 21 00 00       	call   80103730 <log_write>
        brelse(bp);
80101602:	89 3c 24             	mov    %edi,(%esp)
80101605:	e8 d6 eb ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010160a:	58                   	pop    %eax
8010160b:	5a                   	pop    %edx
8010160c:	56                   	push   %esi
8010160d:	ff 75 d8             	pushl  -0x28(%ebp)
80101610:	e8 bb ea ff ff       	call   801000d0 <bread>
80101615:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101617:	8d 40 5c             	lea    0x5c(%eax),%eax
8010161a:	83 c4 0c             	add    $0xc,%esp
8010161d:	68 00 02 00 00       	push   $0x200
80101622:	6a 00                	push   $0x0
80101624:	50                   	push   %eax
80101625:	e8 16 3d 00 00       	call   80105340 <memset>
  log_write(bp);
8010162a:	89 1c 24             	mov    %ebx,(%esp)
8010162d:	e8 fe 20 00 00       	call   80103730 <log_write>
  brelse(bp);
80101632:	89 1c 24             	mov    %ebx,(%esp)
80101635:	e8 a6 eb ff ff       	call   801001e0 <brelse>
}
8010163a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163d:	89 f0                	mov    %esi,%eax
8010163f:	5b                   	pop    %ebx
80101640:	5e                   	pop    %esi
80101641:	5f                   	pop    %edi
80101642:	5d                   	pop    %ebp
80101643:	c3                   	ret    
80101644:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010164a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101650 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101650:	55                   	push   %ebp
80101651:	89 e5                	mov    %esp,%ebp
80101653:	57                   	push   %edi
80101654:	56                   	push   %esi
80101655:	53                   	push   %ebx
80101656:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101658:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010165a:	bb f4 3d 11 80       	mov    $0x80113df4,%ebx
{
8010165f:	83 ec 28             	sub    $0x28,%esp
80101662:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101665:	68 c0 3d 11 80       	push   $0x80113dc0
8010166a:	e8 c1 3b 00 00       	call   80105230 <acquire>
8010166f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101672:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101675:	eb 17                	jmp    8010168e <iget+0x3e>
80101677:	89 f6                	mov    %esi,%esi
80101679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101680:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101686:	81 fb 14 5a 11 80    	cmp    $0x80115a14,%ebx
8010168c:	73 22                	jae    801016b0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010168e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101691:	85 c9                	test   %ecx,%ecx
80101693:	7e 04                	jle    80101699 <iget+0x49>
80101695:	39 3b                	cmp    %edi,(%ebx)
80101697:	74 4f                	je     801016e8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101699:	85 f6                	test   %esi,%esi
8010169b:	75 e3                	jne    80101680 <iget+0x30>
8010169d:	85 c9                	test   %ecx,%ecx
8010169f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801016a2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801016a8:	81 fb 14 5a 11 80    	cmp    $0x80115a14,%ebx
801016ae:	72 de                	jb     8010168e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801016b0:	85 f6                	test   %esi,%esi
801016b2:	74 5b                	je     8010170f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801016b4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801016b7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801016b9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801016bc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016c3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016ca:	68 c0 3d 11 80       	push   $0x80113dc0
801016cf:	e8 1c 3c 00 00       	call   801052f0 <release>

  return ip;
801016d4:	83 c4 10             	add    $0x10,%esp
}
801016d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016da:	89 f0                	mov    %esi,%eax
801016dc:	5b                   	pop    %ebx
801016dd:	5e                   	pop    %esi
801016de:	5f                   	pop    %edi
801016df:	5d                   	pop    %ebp
801016e0:	c3                   	ret    
801016e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016e8:	39 53 04             	cmp    %edx,0x4(%ebx)
801016eb:	75 ac                	jne    80101699 <iget+0x49>
      release(&icache.lock);
801016ed:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801016f0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801016f3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801016f5:	68 c0 3d 11 80       	push   $0x80113dc0
      ip->ref++;
801016fa:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801016fd:	e8 ee 3b 00 00       	call   801052f0 <release>
      return ip;
80101702:	83 c4 10             	add    $0x10,%esp
}
80101705:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101708:	89 f0                	mov    %esi,%eax
8010170a:	5b                   	pop    %ebx
8010170b:	5e                   	pop    %esi
8010170c:	5f                   	pop    %edi
8010170d:	5d                   	pop    %ebp
8010170e:	c3                   	ret    
    panic("iget: no inodes");
8010170f:	83 ec 0c             	sub    $0xc,%esp
80101712:	68 1e 90 10 80       	push   $0x8010901e
80101717:	e8 74 ec ff ff       	call   80100390 <panic>
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	89 c6                	mov    %eax,%esi
80101728:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010172b:	83 fa 0b             	cmp    $0xb,%edx
8010172e:	77 18                	ja     80101748 <bmap+0x28>
80101730:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101733:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101736:	85 db                	test   %ebx,%ebx
80101738:	74 76                	je     801017b0 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010173a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010173d:	89 d8                	mov    %ebx,%eax
8010173f:	5b                   	pop    %ebx
80101740:	5e                   	pop    %esi
80101741:	5f                   	pop    %edi
80101742:	5d                   	pop    %ebp
80101743:	c3                   	ret    
80101744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101748:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010174b:	83 fb 7f             	cmp    $0x7f,%ebx
8010174e:	0f 87 90 00 00 00    	ja     801017e4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101754:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010175a:	8b 00                	mov    (%eax),%eax
8010175c:	85 d2                	test   %edx,%edx
8010175e:	74 70                	je     801017d0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101760:	83 ec 08             	sub    $0x8,%esp
80101763:	52                   	push   %edx
80101764:	50                   	push   %eax
80101765:	e8 66 e9 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010176a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010176e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101771:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101773:	8b 1a                	mov    (%edx),%ebx
80101775:	85 db                	test   %ebx,%ebx
80101777:	75 1d                	jne    80101796 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101779:	8b 06                	mov    (%esi),%eax
8010177b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010177e:	e8 bd fd ff ff       	call   80101540 <balloc>
80101783:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101786:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101789:	89 c3                	mov    %eax,%ebx
8010178b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010178d:	57                   	push   %edi
8010178e:	e8 9d 1f 00 00       	call   80103730 <log_write>
80101793:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101796:	83 ec 0c             	sub    $0xc,%esp
80101799:	57                   	push   %edi
8010179a:	e8 41 ea ff ff       	call   801001e0 <brelse>
8010179f:	83 c4 10             	add    $0x10,%esp
}
801017a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017a5:	89 d8                	mov    %ebx,%eax
801017a7:	5b                   	pop    %ebx
801017a8:	5e                   	pop    %esi
801017a9:	5f                   	pop    %edi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
801017b0:	8b 00                	mov    (%eax),%eax
801017b2:	e8 89 fd ff ff       	call   80101540 <balloc>
801017b7:	89 47 5c             	mov    %eax,0x5c(%edi)
}
801017ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
801017bd:	89 c3                	mov    %eax,%ebx
}
801017bf:	89 d8                	mov    %ebx,%eax
801017c1:	5b                   	pop    %ebx
801017c2:	5e                   	pop    %esi
801017c3:	5f                   	pop    %edi
801017c4:	5d                   	pop    %ebp
801017c5:	c3                   	ret    
801017c6:	8d 76 00             	lea    0x0(%esi),%esi
801017c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017d0:	e8 6b fd ff ff       	call   80101540 <balloc>
801017d5:	89 c2                	mov    %eax,%edx
801017d7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017dd:	8b 06                	mov    (%esi),%eax
801017df:	e9 7c ff ff ff       	jmp    80101760 <bmap+0x40>
  panic("bmap: out of range");
801017e4:	83 ec 0c             	sub    $0xc,%esp
801017e7:	68 2e 90 10 80       	push   $0x8010902e
801017ec:	e8 9f eb ff ff       	call   80100390 <panic>
801017f1:	eb 0d                	jmp    80101800 <readsb>
801017f3:	90                   	nop
801017f4:	90                   	nop
801017f5:	90                   	nop
801017f6:	90                   	nop
801017f7:	90                   	nop
801017f8:	90                   	nop
801017f9:	90                   	nop
801017fa:	90                   	nop
801017fb:	90                   	nop
801017fc:	90                   	nop
801017fd:	90                   	nop
801017fe:	90                   	nop
801017ff:	90                   	nop

80101800 <readsb>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	56                   	push   %esi
80101804:	53                   	push   %ebx
80101805:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101808:	83 ec 08             	sub    $0x8,%esp
8010180b:	6a 01                	push   $0x1
8010180d:	ff 75 08             	pushl  0x8(%ebp)
80101810:	e8 bb e8 ff ff       	call   801000d0 <bread>
80101815:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101817:	8d 40 5c             	lea    0x5c(%eax),%eax
8010181a:	83 c4 0c             	add    $0xc,%esp
8010181d:	6a 1c                	push   $0x1c
8010181f:	50                   	push   %eax
80101820:	56                   	push   %esi
80101821:	e8 ca 3b 00 00       	call   801053f0 <memmove>
  brelse(bp);
80101826:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101829:	83 c4 10             	add    $0x10,%esp
}
8010182c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010182f:	5b                   	pop    %ebx
80101830:	5e                   	pop    %esi
80101831:	5d                   	pop    %ebp
  brelse(bp);
80101832:	e9 a9 e9 ff ff       	jmp    801001e0 <brelse>
80101837:	89 f6                	mov    %esi,%esi
80101839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101840 <iinit>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	53                   	push   %ebx
80101844:	bb 00 3e 11 80       	mov    $0x80113e00,%ebx
80101849:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010184c:	68 41 90 10 80       	push   $0x80109041
80101851:	68 c0 3d 11 80       	push   $0x80113dc0
80101856:	e8 95 38 00 00       	call   801050f0 <initlock>
8010185b:	83 c4 10             	add    $0x10,%esp
8010185e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101860:	83 ec 08             	sub    $0x8,%esp
80101863:	68 48 90 10 80       	push   $0x80109048
80101868:	53                   	push   %ebx
80101869:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010186f:	e8 4c 37 00 00       	call   80104fc0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101874:	83 c4 10             	add    $0x10,%esp
80101877:	81 fb 20 5a 11 80    	cmp    $0x80115a20,%ebx
8010187d:	75 e1                	jne    80101860 <iinit+0x20>
  readsb(dev, &sb);
8010187f:	83 ec 08             	sub    $0x8,%esp
80101882:	68 a0 3d 11 80       	push   $0x80113da0
80101887:	ff 75 08             	pushl  0x8(%ebp)
8010188a:	e8 71 ff ff ff       	call   80101800 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010188f:	ff 35 b8 3d 11 80    	pushl  0x80113db8
80101895:	ff 35 b4 3d 11 80    	pushl  0x80113db4
8010189b:	ff 35 b0 3d 11 80    	pushl  0x80113db0
801018a1:	ff 35 ac 3d 11 80    	pushl  0x80113dac
801018a7:	ff 35 a8 3d 11 80    	pushl  0x80113da8
801018ad:	ff 35 a4 3d 11 80    	pushl  0x80113da4
801018b3:	ff 35 a0 3d 11 80    	pushl  0x80113da0
801018b9:	68 f4 90 10 80       	push   $0x801090f4
801018be:	e8 9d ed ff ff       	call   80100660 <cprintf>
}
801018c3:	83 c4 30             	add    $0x30,%esp
801018c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018c9:	c9                   	leave  
801018ca:	c3                   	ret    
801018cb:	90                   	nop
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <ialloc>:
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	57                   	push   %edi
801018d4:	56                   	push   %esi
801018d5:	53                   	push   %ebx
801018d6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018d9:	83 3d a8 3d 11 80 01 	cmpl   $0x1,0x80113da8
{
801018e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801018e3:	8b 75 08             	mov    0x8(%ebp),%esi
801018e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801018e9:	0f 86 91 00 00 00    	jbe    80101980 <ialloc+0xb0>
801018ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801018f4:	eb 21                	jmp    80101917 <ialloc+0x47>
801018f6:	8d 76 00             	lea    0x0(%esi),%esi
801018f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101900:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101903:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101906:	57                   	push   %edi
80101907:	e8 d4 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	39 1d a8 3d 11 80    	cmp    %ebx,0x80113da8
80101915:	76 69                	jbe    80101980 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101917:	89 d8                	mov    %ebx,%eax
80101919:	83 ec 08             	sub    $0x8,%esp
8010191c:	c1 e8 03             	shr    $0x3,%eax
8010191f:	03 05 b4 3d 11 80    	add    0x80113db4,%eax
80101925:	50                   	push   %eax
80101926:	56                   	push   %esi
80101927:	e8 a4 e7 ff ff       	call   801000d0 <bread>
8010192c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010192e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101930:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101933:	83 e0 07             	and    $0x7,%eax
80101936:	c1 e0 06             	shl    $0x6,%eax
80101939:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010193d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101941:	75 bd                	jne    80101900 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101943:	83 ec 04             	sub    $0x4,%esp
80101946:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101949:	6a 40                	push   $0x40
8010194b:	6a 00                	push   $0x0
8010194d:	51                   	push   %ecx
8010194e:	e8 ed 39 00 00       	call   80105340 <memset>
      dip->type = type;
80101953:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101957:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010195a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010195d:	89 3c 24             	mov    %edi,(%esp)
80101960:	e8 cb 1d 00 00       	call   80103730 <log_write>
      brelse(bp);
80101965:	89 3c 24             	mov    %edi,(%esp)
80101968:	e8 73 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010196d:	83 c4 10             	add    $0x10,%esp
}
80101970:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101973:	89 da                	mov    %ebx,%edx
80101975:	89 f0                	mov    %esi,%eax
}
80101977:	5b                   	pop    %ebx
80101978:	5e                   	pop    %esi
80101979:	5f                   	pop    %edi
8010197a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010197b:	e9 d0 fc ff ff       	jmp    80101650 <iget>
  panic("ialloc: no inodes");
80101980:	83 ec 0c             	sub    $0xc,%esp
80101983:	68 4e 90 10 80       	push   $0x8010904e
80101988:	e8 03 ea ff ff       	call   80100390 <panic>
8010198d:	8d 76 00             	lea    0x0(%esi),%esi

80101990 <iupdate>:
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	56                   	push   %esi
80101994:	53                   	push   %ebx
80101995:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010199e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801019a1:	c1 e8 03             	shr    $0x3,%eax
801019a4:	03 05 b4 3d 11 80    	add    0x80113db4,%eax
801019aa:	50                   	push   %eax
801019ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801019ae:	e8 1d e7 ff ff       	call   801000d0 <bread>
801019b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801019b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019bc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801019bf:	83 e0 07             	and    $0x7,%eax
801019c2:	c1 e0 06             	shl    $0x6,%eax
801019c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801019d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ed:	6a 34                	push   $0x34
801019ef:	53                   	push   %ebx
801019f0:	50                   	push   %eax
801019f1:	e8 fa 39 00 00       	call   801053f0 <memmove>
  log_write(bp);
801019f6:	89 34 24             	mov    %esi,(%esp)
801019f9:	e8 32 1d 00 00       	call   80103730 <log_write>
  brelse(bp);
801019fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101a01:	83 c4 10             	add    $0x10,%esp
}
80101a04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a07:	5b                   	pop    %ebx
80101a08:	5e                   	pop    %esi
80101a09:	5d                   	pop    %ebp
  brelse(bp);
80101a0a:	e9 d1 e7 ff ff       	jmp    801001e0 <brelse>
80101a0f:	90                   	nop

80101a10 <idup>:
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	53                   	push   %ebx
80101a14:	83 ec 10             	sub    $0x10,%esp
80101a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101a1a:	68 c0 3d 11 80       	push   $0x80113dc0
80101a1f:	e8 0c 38 00 00       	call   80105230 <acquire>
  ip->ref++;
80101a24:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a28:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a2f:	e8 bc 38 00 00       	call   801052f0 <release>
}
80101a34:	89 d8                	mov    %ebx,%eax
80101a36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a39:	c9                   	leave  
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a40 <ilock>:
{
80101a40:	55                   	push   %ebp
80101a41:	89 e5                	mov    %esp,%ebp
80101a43:	56                   	push   %esi
80101a44:	53                   	push   %ebx
80101a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101a48:	85 db                	test   %ebx,%ebx
80101a4a:	0f 84 b7 00 00 00    	je     80101b07 <ilock+0xc7>
80101a50:	8b 53 08             	mov    0x8(%ebx),%edx
80101a53:	85 d2                	test   %edx,%edx
80101a55:	0f 8e ac 00 00 00    	jle    80101b07 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a5b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a5e:	83 ec 0c             	sub    $0xc,%esp
80101a61:	50                   	push   %eax
80101a62:	e8 99 35 00 00       	call   80105000 <acquiresleep>
  if(ip->valid == 0){
80101a67:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a6a:	83 c4 10             	add    $0x10,%esp
80101a6d:	85 c0                	test   %eax,%eax
80101a6f:	74 0f                	je     80101a80 <ilock+0x40>
}
80101a71:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a74:	5b                   	pop    %ebx
80101a75:	5e                   	pop    %esi
80101a76:	5d                   	pop    %ebp
80101a77:	c3                   	ret    
80101a78:	90                   	nop
80101a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a80:	8b 43 04             	mov    0x4(%ebx),%eax
80101a83:	83 ec 08             	sub    $0x8,%esp
80101a86:	c1 e8 03             	shr    $0x3,%eax
80101a89:	03 05 b4 3d 11 80    	add    0x80113db4,%eax
80101a8f:	50                   	push   %eax
80101a90:	ff 33                	pushl  (%ebx)
80101a92:	e8 39 e6 ff ff       	call   801000d0 <bread>
80101a97:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a99:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a9c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a9f:	83 e0 07             	and    $0x7,%eax
80101aa2:	c1 e0 06             	shl    $0x6,%eax
80101aa5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101aa9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101aac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101aaf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101ab3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101ab7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101abb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101abf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101ac3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101ac7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101acb:	8b 50 fc             	mov    -0x4(%eax),%edx
80101ace:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ad1:	6a 34                	push   $0x34
80101ad3:	50                   	push   %eax
80101ad4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ad7:	50                   	push   %eax
80101ad8:	e8 13 39 00 00       	call   801053f0 <memmove>
    brelse(bp);
80101add:	89 34 24             	mov    %esi,(%esp)
80101ae0:	e8 fb e6 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101ae5:	83 c4 10             	add    $0x10,%esp
80101ae8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101aed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101af4:	0f 85 77 ff ff ff    	jne    80101a71 <ilock+0x31>
      panic("ilock: no type");
80101afa:	83 ec 0c             	sub    $0xc,%esp
80101afd:	68 66 90 10 80       	push   $0x80109066
80101b02:	e8 89 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101b07:	83 ec 0c             	sub    $0xc,%esp
80101b0a:	68 60 90 10 80       	push   $0x80109060
80101b0f:	e8 7c e8 ff ff       	call   80100390 <panic>
80101b14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b20 <iunlock>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	74 28                	je     80101b54 <iunlock+0x34>
80101b2c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b2f:	83 ec 0c             	sub    $0xc,%esp
80101b32:	56                   	push   %esi
80101b33:	e8 68 35 00 00       	call   801050a0 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 15                	je     80101b54 <iunlock+0x34>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 0e                	jle    80101b54 <iunlock+0x34>
  releasesleep(&ip->lock);
80101b46:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b49:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b4c:	5b                   	pop    %ebx
80101b4d:	5e                   	pop    %esi
80101b4e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101b4f:	e9 0c 35 00 00       	jmp    80105060 <releasesleep>
    panic("iunlock");
80101b54:	83 ec 0c             	sub    $0xc,%esp
80101b57:	68 75 90 10 80       	push   $0x80109075
80101b5c:	e8 2f e8 ff ff       	call   80100390 <panic>
80101b61:	eb 0d                	jmp    80101b70 <iput>
80101b63:	90                   	nop
80101b64:	90                   	nop
80101b65:	90                   	nop
80101b66:	90                   	nop
80101b67:	90                   	nop
80101b68:	90                   	nop
80101b69:	90                   	nop
80101b6a:	90                   	nop
80101b6b:	90                   	nop
80101b6c:	90                   	nop
80101b6d:	90                   	nop
80101b6e:	90                   	nop
80101b6f:	90                   	nop

80101b70 <iput>:
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	83 ec 28             	sub    $0x28,%esp
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b7c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b7f:	57                   	push   %edi
80101b80:	e8 7b 34 00 00       	call   80105000 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b85:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b88:	83 c4 10             	add    $0x10,%esp
80101b8b:	85 d2                	test   %edx,%edx
80101b8d:	74 07                	je     80101b96 <iput+0x26>
80101b8f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b94:	74 32                	je     80101bc8 <iput+0x58>
  releasesleep(&ip->lock);
80101b96:	83 ec 0c             	sub    $0xc,%esp
80101b99:	57                   	push   %edi
80101b9a:	e8 c1 34 00 00       	call   80105060 <releasesleep>
  acquire(&icache.lock);
80101b9f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101ba6:	e8 85 36 00 00       	call   80105230 <acquire>
  ip->ref--;
80101bab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101baf:	83 c4 10             	add    $0x10,%esp
80101bb2:	c7 45 08 c0 3d 11 80 	movl   $0x80113dc0,0x8(%ebp)
}
80101bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bbc:	5b                   	pop    %ebx
80101bbd:	5e                   	pop    %esi
80101bbe:	5f                   	pop    %edi
80101bbf:	5d                   	pop    %ebp
  release(&icache.lock);
80101bc0:	e9 2b 37 00 00       	jmp    801052f0 <release>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bd0:	e8 5b 36 00 00       	call   80105230 <acquire>
    int r = ip->ref;
80101bd5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bd8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bdf:	e8 0c 37 00 00       	call   801052f0 <release>
    if(r == 1){
80101be4:	83 c4 10             	add    $0x10,%esp
80101be7:	83 fe 01             	cmp    $0x1,%esi
80101bea:	75 aa                	jne    80101b96 <iput+0x26>
80101bec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101bf2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bf5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101bf8:	89 cf                	mov    %ecx,%edi
80101bfa:	eb 0b                	jmp    80101c07 <iput+0x97>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c00:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c03:	39 fe                	cmp    %edi,%esi
80101c05:	74 19                	je     80101c20 <iput+0xb0>
    if(ip->addrs[i]){
80101c07:	8b 16                	mov    (%esi),%edx
80101c09:	85 d2                	test   %edx,%edx
80101c0b:	74 f3                	je     80101c00 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101c0d:	8b 03                	mov    (%ebx),%eax
80101c0f:	e8 bc f8 ff ff       	call   801014d0 <bfree>
      ip->addrs[i] = 0;
80101c14:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101c1a:	eb e4                	jmp    80101c00 <iput+0x90>
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c20:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c26:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c29:	85 c0                	test   %eax,%eax
80101c2b:	75 33                	jne    80101c60 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c2d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101c30:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101c37:	53                   	push   %ebx
80101c38:	e8 53 fd ff ff       	call   80101990 <iupdate>
      ip->type = 0;
80101c3d:	31 c0                	xor    %eax,%eax
80101c3f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101c43:	89 1c 24             	mov    %ebx,(%esp)
80101c46:	e8 45 fd ff ff       	call   80101990 <iupdate>
      ip->valid = 0;
80101c4b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c52:	83 c4 10             	add    $0x10,%esp
80101c55:	e9 3c ff ff ff       	jmp    80101b96 <iput+0x26>
80101c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c60:	83 ec 08             	sub    $0x8,%esp
80101c63:	50                   	push   %eax
80101c64:	ff 33                	pushl  (%ebx)
80101c66:	e8 65 e4 ff ff       	call   801000d0 <bread>
80101c6b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c71:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c77:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c7a:	83 c4 10             	add    $0x10,%esp
80101c7d:	89 cf                	mov    %ecx,%edi
80101c7f:	eb 0e                	jmp    80101c8f <iput+0x11f>
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c88:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101c8b:	39 fe                	cmp    %edi,%esi
80101c8d:	74 0f                	je     80101c9e <iput+0x12e>
      if(a[j])
80101c8f:	8b 16                	mov    (%esi),%edx
80101c91:	85 d2                	test   %edx,%edx
80101c93:	74 f3                	je     80101c88 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c95:	8b 03                	mov    (%ebx),%eax
80101c97:	e8 34 f8 ff ff       	call   801014d0 <bfree>
80101c9c:	eb ea                	jmp    80101c88 <iput+0x118>
    brelse(bp);
80101c9e:	83 ec 0c             	sub    $0xc,%esp
80101ca1:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ca4:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101ca7:	e8 34 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101cac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101cb2:	8b 03                	mov    (%ebx),%eax
80101cb4:	e8 17 f8 ff ff       	call   801014d0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101cb9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101cc0:	00 00 00 
80101cc3:	83 c4 10             	add    $0x10,%esp
80101cc6:	e9 62 ff ff ff       	jmp    80101c2d <iput+0xbd>
80101ccb:	90                   	nop
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cd0 <iunlockput>:
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	53                   	push   %ebx
80101cd4:	83 ec 10             	sub    $0x10,%esp
80101cd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101cda:	53                   	push   %ebx
80101cdb:	e8 40 fe ff ff       	call   80101b20 <iunlock>
  iput(ip);
80101ce0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ce3:	83 c4 10             	add    $0x10,%esp
}
80101ce6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ce9:	c9                   	leave  
  iput(ip);
80101cea:	e9 81 fe ff ff       	jmp    80101b70 <iput>
80101cef:	90                   	nop

80101cf0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	8b 55 08             	mov    0x8(%ebp),%edx
80101cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101cf9:	8b 0a                	mov    (%edx),%ecx
80101cfb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cfe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101d01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101d04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101d08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101d0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101d0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101d13:	8b 52 58             	mov    0x58(%edx),%edx
80101d16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d19:	5d                   	pop    %ebp
80101d1a:	c3                   	ret    
80101d1b:	90                   	nop
80101d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	83 ec 1c             	sub    $0x1c,%esp
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d37:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101d3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101d43:	0f 84 a7 00 00 00    	je     80101df0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d4c:	8b 40 58             	mov    0x58(%eax),%eax
80101d4f:	39 c6                	cmp    %eax,%esi
80101d51:	0f 87 ba 00 00 00    	ja     80101e11 <readi+0xf1>
80101d57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d5a:	89 f9                	mov    %edi,%ecx
80101d5c:	01 f1                	add    %esi,%ecx
80101d5e:	0f 82 ad 00 00 00    	jb     80101e11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d64:	89 c2                	mov    %eax,%edx
80101d66:	29 f2                	sub    %esi,%edx
80101d68:	39 c8                	cmp    %ecx,%eax
80101d6a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d6d:	31 ff                	xor    %edi,%edi
80101d6f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101d71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d74:	74 6c                	je     80101de2 <readi+0xc2>
80101d76:	8d 76 00             	lea    0x0(%esi),%esi
80101d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d83:	89 f2                	mov    %esi,%edx
80101d85:	c1 ea 09             	shr    $0x9,%edx
80101d88:	89 d8                	mov    %ebx,%eax
80101d8a:	e8 91 f9 ff ff       	call   80101720 <bmap>
80101d8f:	83 ec 08             	sub    $0x8,%esp
80101d92:	50                   	push   %eax
80101d93:	ff 33                	pushl  (%ebx)
80101d95:	e8 36 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d9d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d9f:	89 f0                	mov    %esi,%eax
80101da1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101da6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101dab:	83 c4 0c             	add    $0xc,%esp
80101dae:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101db0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101db4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101db7:	29 fb                	sub    %edi,%ebx
80101db9:	39 d9                	cmp    %ebx,%ecx
80101dbb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101dbe:	53                   	push   %ebx
80101dbf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dc0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101dc2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dc5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101dc7:	e8 24 36 00 00       	call   801053f0 <memmove>
    brelse(bp);
80101dcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dcf:	89 14 24             	mov    %edx,(%esp)
80101dd2:	e8 09 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101dd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dda:	83 c4 10             	add    $0x10,%esp
80101ddd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101de0:	77 9e                	ja     80101d80 <readi+0x60>
  }
  return n;
80101de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de8:	5b                   	pop    %ebx
80101de9:	5e                   	pop    %esi
80101dea:	5f                   	pop    %edi
80101deb:	5d                   	pop    %ebp
80101dec:	c3                   	ret    
80101ded:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101df0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101df4:	66 83 f8 09          	cmp    $0x9,%ax
80101df8:	77 17                	ja     80101e11 <readi+0xf1>
80101dfa:	8b 04 c5 40 3d 11 80 	mov    -0x7feec2c0(,%eax,8),%eax
80101e01:	85 c0                	test   %eax,%eax
80101e03:	74 0c                	je     80101e11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101e05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e0b:	5b                   	pop    %ebx
80101e0c:	5e                   	pop    %esi
80101e0d:	5f                   	pop    %edi
80101e0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101e0f:	ff e0                	jmp    *%eax
      return -1;
80101e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e16:	eb cd                	jmp    80101de5 <readi+0xc5>
80101e18:	90                   	nop
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	83 ec 1c             	sub    $0x1c,%esp
80101e29:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101e43:	0f 84 b7 00 00 00    	je     80101f00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e4f:	0f 82 eb 00 00 00    	jb     80101f40 <writei+0x120>
80101e55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e58:	31 d2                	xor    %edx,%edx
80101e5a:	89 f8                	mov    %edi,%eax
80101e5c:	01 f0                	add    %esi,%eax
80101e5e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e66:	0f 87 d4 00 00 00    	ja     80101f40 <writei+0x120>
80101e6c:	85 d2                	test   %edx,%edx
80101e6e:	0f 85 cc 00 00 00    	jne    80101f40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e74:	85 ff                	test   %edi,%edi
80101e76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e7d:	74 72                	je     80101ef1 <writei+0xd1>
80101e7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e83:	89 f2                	mov    %esi,%edx
80101e85:	c1 ea 09             	shr    $0x9,%edx
80101e88:	89 f8                	mov    %edi,%eax
80101e8a:	e8 91 f8 ff ff       	call   80101720 <bmap>
80101e8f:	83 ec 08             	sub    $0x8,%esp
80101e92:	50                   	push   %eax
80101e93:	ff 37                	pushl  (%edi)
80101e95:	e8 36 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e9a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e9d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ea0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ea2:	89 f0                	mov    %esi,%eax
80101ea4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ea9:	83 c4 0c             	add    $0xc,%esp
80101eac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eb1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101eb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101eb7:	39 d9                	cmp    %ebx,%ecx
80101eb9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ebc:	53                   	push   %ebx
80101ebd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ec0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ec2:	50                   	push   %eax
80101ec3:	e8 28 35 00 00       	call   801053f0 <memmove>
    log_write(bp);
80101ec8:	89 3c 24             	mov    %edi,(%esp)
80101ecb:	e8 60 18 00 00       	call   80103730 <log_write>
    brelse(bp);
80101ed0:	89 3c 24             	mov    %edi,(%esp)
80101ed3:	e8 08 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ed8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101edb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ee4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ee7:	77 97                	ja     80101e80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ee9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101eec:	3b 70 58             	cmp    0x58(%eax),%esi
80101eef:	77 37                	ja     80101f28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ef7:	5b                   	pop    %ebx
80101ef8:	5e                   	pop    %esi
80101ef9:	5f                   	pop    %edi
80101efa:	5d                   	pop    %ebp
80101efb:	c3                   	ret    
80101efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101f04:	66 83 f8 09          	cmp    $0x9,%ax
80101f08:	77 36                	ja     80101f40 <writei+0x120>
80101f0a:	8b 04 c5 44 3d 11 80 	mov    -0x7feec2bc(,%eax,8),%eax
80101f11:	85 c0                	test   %eax,%eax
80101f13:	74 2b                	je     80101f40 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101f15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1b:	5b                   	pop    %ebx
80101f1c:	5e                   	pop    %esi
80101f1d:	5f                   	pop    %edi
80101f1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101f1f:	ff e0                	jmp    *%eax
80101f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101f28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101f2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f31:	50                   	push   %eax
80101f32:	e8 59 fa ff ff       	call   80101990 <iupdate>
80101f37:	83 c4 10             	add    $0x10,%esp
80101f3a:	eb b5                	jmp    80101ef1 <writei+0xd1>
80101f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f45:	eb ad                	jmp    80101ef4 <writei+0xd4>
80101f47:	89 f6                	mov    %esi,%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f56:	6a 0e                	push   $0xe
80101f58:	ff 75 0c             	pushl  0xc(%ebp)
80101f5b:	ff 75 08             	pushl  0x8(%ebp)
80101f5e:	e8 fd 34 00 00       	call   80105460 <strncmp>
}
80101f63:	c9                   	leave  
80101f64:	c3                   	ret    
80101f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	57                   	push   %edi
80101f74:	56                   	push   %esi
80101f75:	53                   	push   %ebx
80101f76:	83 ec 1c             	sub    $0x1c,%esp
80101f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f81:	0f 85 85 00 00 00    	jne    8010200c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f87:	8b 53 58             	mov    0x58(%ebx),%edx
80101f8a:	31 ff                	xor    %edi,%edi
80101f8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f8f:	85 d2                	test   %edx,%edx
80101f91:	74 3e                	je     80101fd1 <dirlookup+0x61>
80101f93:	90                   	nop
80101f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f98:	6a 10                	push   $0x10
80101f9a:	57                   	push   %edi
80101f9b:	56                   	push   %esi
80101f9c:	53                   	push   %ebx
80101f9d:	e8 7e fd ff ff       	call   80101d20 <readi>
80101fa2:	83 c4 10             	add    $0x10,%esp
80101fa5:	83 f8 10             	cmp    $0x10,%eax
80101fa8:	75 55                	jne    80101fff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101faa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101faf:	74 18                	je     80101fc9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101fb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fb4:	83 ec 04             	sub    $0x4,%esp
80101fb7:	6a 0e                	push   $0xe
80101fb9:	50                   	push   %eax
80101fba:	ff 75 0c             	pushl  0xc(%ebp)
80101fbd:	e8 9e 34 00 00       	call   80105460 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101fc2:	83 c4 10             	add    $0x10,%esp
80101fc5:	85 c0                	test   %eax,%eax
80101fc7:	74 17                	je     80101fe0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fc9:	83 c7 10             	add    $0x10,%edi
80101fcc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fcf:	72 c7                	jb     80101f98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101fd4:	31 c0                	xor    %eax,%eax
}
80101fd6:	5b                   	pop    %ebx
80101fd7:	5e                   	pop    %esi
80101fd8:	5f                   	pop    %edi
80101fd9:	5d                   	pop    %ebp
80101fda:	c3                   	ret    
80101fdb:	90                   	nop
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101fe0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe3:	85 c0                	test   %eax,%eax
80101fe5:	74 05                	je     80101fec <dirlookup+0x7c>
        *poff = off;
80101fe7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101fec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ff0:	8b 03                	mov    (%ebx),%eax
80101ff2:	e8 59 f6 ff ff       	call   80101650 <iget>
}
80101ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ffa:	5b                   	pop    %ebx
80101ffb:	5e                   	pop    %esi
80101ffc:	5f                   	pop    %edi
80101ffd:	5d                   	pop    %ebp
80101ffe:	c3                   	ret    
      panic("dirlookup read");
80101fff:	83 ec 0c             	sub    $0xc,%esp
80102002:	68 8f 90 10 80       	push   $0x8010908f
80102007:	e8 84 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
8010200c:	83 ec 0c             	sub    $0xc,%esp
8010200f:	68 7d 90 10 80       	push   $0x8010907d
80102014:	e8 77 e3 ff ff       	call   80100390 <panic>
80102019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102020 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	57                   	push   %edi
80102024:	56                   	push   %esi
80102025:	53                   	push   %ebx
80102026:	89 cf                	mov    %ecx,%edi
80102028:	89 c3                	mov    %eax,%ebx
8010202a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010202d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80102030:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80102033:	0f 84 67 01 00 00    	je     801021a0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102039:	e8 92 22 00 00       	call   801042d0 <myproc>
  acquire(&icache.lock);
8010203e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102041:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102044:	68 c0 3d 11 80       	push   $0x80113dc0
80102049:	e8 e2 31 00 00       	call   80105230 <acquire>
  ip->ref++;
8010204e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102052:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102059:	e8 92 32 00 00       	call   801052f0 <release>
8010205e:	83 c4 10             	add    $0x10,%esp
80102061:	eb 08                	jmp    8010206b <namex+0x4b>
80102063:	90                   	nop
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102068:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010206b:	0f b6 03             	movzbl (%ebx),%eax
8010206e:	3c 2f                	cmp    $0x2f,%al
80102070:	74 f6                	je     80102068 <namex+0x48>
  if(*path == 0)
80102072:	84 c0                	test   %al,%al
80102074:	0f 84 ee 00 00 00    	je     80102168 <namex+0x148>
  while(*path != '/' && *path != 0)
8010207a:	0f b6 03             	movzbl (%ebx),%eax
8010207d:	3c 2f                	cmp    $0x2f,%al
8010207f:	0f 84 b3 00 00 00    	je     80102138 <namex+0x118>
80102085:	84 c0                	test   %al,%al
80102087:	89 da                	mov    %ebx,%edx
80102089:	75 09                	jne    80102094 <namex+0x74>
8010208b:	e9 a8 00 00 00       	jmp    80102138 <namex+0x118>
80102090:	84 c0                	test   %al,%al
80102092:	74 0a                	je     8010209e <namex+0x7e>
    path++;
80102094:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102097:	0f b6 02             	movzbl (%edx),%eax
8010209a:	3c 2f                	cmp    $0x2f,%al
8010209c:	75 f2                	jne    80102090 <namex+0x70>
8010209e:	89 d1                	mov    %edx,%ecx
801020a0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
801020a2:	83 f9 0d             	cmp    $0xd,%ecx
801020a5:	0f 8e 91 00 00 00    	jle    8010213c <namex+0x11c>
    memmove(name, s, DIRSIZ);
801020ab:	83 ec 04             	sub    $0x4,%esp
801020ae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801020b1:	6a 0e                	push   $0xe
801020b3:	53                   	push   %ebx
801020b4:	57                   	push   %edi
801020b5:	e8 36 33 00 00       	call   801053f0 <memmove>
    path++;
801020ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
801020bd:	83 c4 10             	add    $0x10,%esp
    path++;
801020c0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
801020c2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801020c5:	75 11                	jne    801020d8 <namex+0xb8>
801020c7:	89 f6                	mov    %esi,%esi
801020c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801020d0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020d3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020d6:	74 f8                	je     801020d0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	56                   	push   %esi
801020dc:	e8 5f f9 ff ff       	call   80101a40 <ilock>
    if(ip->type != T_DIR){
801020e1:	83 c4 10             	add    $0x10,%esp
801020e4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020e9:	0f 85 91 00 00 00    	jne    80102180 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020f2:	85 d2                	test   %edx,%edx
801020f4:	74 09                	je     801020ff <namex+0xdf>
801020f6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020f9:	0f 84 b7 00 00 00    	je     801021b6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020ff:	83 ec 04             	sub    $0x4,%esp
80102102:	6a 00                	push   $0x0
80102104:	57                   	push   %edi
80102105:	56                   	push   %esi
80102106:	e8 65 fe ff ff       	call   80101f70 <dirlookup>
8010210b:	83 c4 10             	add    $0x10,%esp
8010210e:	85 c0                	test   %eax,%eax
80102110:	74 6e                	je     80102180 <namex+0x160>
  iunlock(ip);
80102112:	83 ec 0c             	sub    $0xc,%esp
80102115:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102118:	56                   	push   %esi
80102119:	e8 02 fa ff ff       	call   80101b20 <iunlock>
  iput(ip);
8010211e:	89 34 24             	mov    %esi,(%esp)
80102121:	e8 4a fa ff ff       	call   80101b70 <iput>
80102126:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102129:	83 c4 10             	add    $0x10,%esp
8010212c:	89 c6                	mov    %eax,%esi
8010212e:	e9 38 ff ff ff       	jmp    8010206b <namex+0x4b>
80102133:	90                   	nop
80102134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102138:	89 da                	mov    %ebx,%edx
8010213a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010213c:	83 ec 04             	sub    $0x4,%esp
8010213f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102142:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102145:	51                   	push   %ecx
80102146:	53                   	push   %ebx
80102147:	57                   	push   %edi
80102148:	e8 a3 32 00 00       	call   801053f0 <memmove>
    name[len] = 0;
8010214d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102150:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102153:	83 c4 10             	add    $0x10,%esp
80102156:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010215a:	89 d3                	mov    %edx,%ebx
8010215c:	e9 61 ff ff ff       	jmp    801020c2 <namex+0xa2>
80102161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102168:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010216b:	85 c0                	test   %eax,%eax
8010216d:	75 5d                	jne    801021cc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010216f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102172:	89 f0                	mov    %esi,%eax
80102174:	5b                   	pop    %ebx
80102175:	5e                   	pop    %esi
80102176:	5f                   	pop    %edi
80102177:	5d                   	pop    %ebp
80102178:	c3                   	ret    
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102180:	83 ec 0c             	sub    $0xc,%esp
80102183:	56                   	push   %esi
80102184:	e8 97 f9 ff ff       	call   80101b20 <iunlock>
  iput(ip);
80102189:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010218c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010218e:	e8 dd f9 ff ff       	call   80101b70 <iput>
      return 0;
80102193:	83 c4 10             	add    $0x10,%esp
}
80102196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102199:	89 f0                	mov    %esi,%eax
8010219b:	5b                   	pop    %ebx
8010219c:	5e                   	pop    %esi
8010219d:	5f                   	pop    %edi
8010219e:	5d                   	pop    %ebp
8010219f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801021a0:	ba 01 00 00 00       	mov    $0x1,%edx
801021a5:	b8 01 00 00 00       	mov    $0x1,%eax
801021aa:	e8 a1 f4 ff ff       	call   80101650 <iget>
801021af:	89 c6                	mov    %eax,%esi
801021b1:	e9 b5 fe ff ff       	jmp    8010206b <namex+0x4b>
      iunlock(ip);
801021b6:	83 ec 0c             	sub    $0xc,%esp
801021b9:	56                   	push   %esi
801021ba:	e8 61 f9 ff ff       	call   80101b20 <iunlock>
      return ip;
801021bf:	83 c4 10             	add    $0x10,%esp
}
801021c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c5:	89 f0                	mov    %esi,%eax
801021c7:	5b                   	pop    %ebx
801021c8:	5e                   	pop    %esi
801021c9:	5f                   	pop    %edi
801021ca:	5d                   	pop    %ebp
801021cb:	c3                   	ret    
    iput(ip);
801021cc:	83 ec 0c             	sub    $0xc,%esp
801021cf:	56                   	push   %esi
    return 0;
801021d0:	31 f6                	xor    %esi,%esi
    iput(ip);
801021d2:	e8 99 f9 ff ff       	call   80101b70 <iput>
    return 0;
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	eb 93                	jmp    8010216f <namex+0x14f>
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021e0 <dirlink>:
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	57                   	push   %edi
801021e4:	56                   	push   %esi
801021e5:	53                   	push   %ebx
801021e6:	83 ec 20             	sub    $0x20,%esp
801021e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021ec:	6a 00                	push   $0x0
801021ee:	ff 75 0c             	pushl  0xc(%ebp)
801021f1:	53                   	push   %ebx
801021f2:	e8 79 fd ff ff       	call   80101f70 <dirlookup>
801021f7:	83 c4 10             	add    $0x10,%esp
801021fa:	85 c0                	test   %eax,%eax
801021fc:	75 67                	jne    80102265 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021fe:	8b 7b 58             	mov    0x58(%ebx),%edi
80102201:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102204:	85 ff                	test   %edi,%edi
80102206:	74 29                	je     80102231 <dirlink+0x51>
80102208:	31 ff                	xor    %edi,%edi
8010220a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010220d:	eb 09                	jmp    80102218 <dirlink+0x38>
8010220f:	90                   	nop
80102210:	83 c7 10             	add    $0x10,%edi
80102213:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102216:	73 19                	jae    80102231 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102218:	6a 10                	push   $0x10
8010221a:	57                   	push   %edi
8010221b:	56                   	push   %esi
8010221c:	53                   	push   %ebx
8010221d:	e8 fe fa ff ff       	call   80101d20 <readi>
80102222:	83 c4 10             	add    $0x10,%esp
80102225:	83 f8 10             	cmp    $0x10,%eax
80102228:	75 4e                	jne    80102278 <dirlink+0x98>
    if(de.inum == 0)
8010222a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010222f:	75 df                	jne    80102210 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102231:	8d 45 da             	lea    -0x26(%ebp),%eax
80102234:	83 ec 04             	sub    $0x4,%esp
80102237:	6a 0e                	push   $0xe
80102239:	ff 75 0c             	pushl  0xc(%ebp)
8010223c:	50                   	push   %eax
8010223d:	e8 7e 32 00 00       	call   801054c0 <strncpy>
  de.inum = inum;
80102242:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102245:	6a 10                	push   $0x10
80102247:	57                   	push   %edi
80102248:	56                   	push   %esi
80102249:	53                   	push   %ebx
  de.inum = inum;
8010224a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010224e:	e8 cd fb ff ff       	call   80101e20 <writei>
80102253:	83 c4 20             	add    $0x20,%esp
80102256:	83 f8 10             	cmp    $0x10,%eax
80102259:	75 2a                	jne    80102285 <dirlink+0xa5>
  return 0;
8010225b:	31 c0                	xor    %eax,%eax
}
8010225d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102260:	5b                   	pop    %ebx
80102261:	5e                   	pop    %esi
80102262:	5f                   	pop    %edi
80102263:	5d                   	pop    %ebp
80102264:	c3                   	ret    
    iput(ip);
80102265:	83 ec 0c             	sub    $0xc,%esp
80102268:	50                   	push   %eax
80102269:	e8 02 f9 ff ff       	call   80101b70 <iput>
    return -1;
8010226e:	83 c4 10             	add    $0x10,%esp
80102271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102276:	eb e5                	jmp    8010225d <dirlink+0x7d>
      panic("dirlink read");
80102278:	83 ec 0c             	sub    $0xc,%esp
8010227b:	68 9e 90 10 80       	push   $0x8010909e
80102280:	e8 0b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102285:	83 ec 0c             	sub    $0xc,%esp
80102288:	68 f5 97 10 80       	push   $0x801097f5
8010228d:	e8 fe e0 ff ff       	call   80100390 <panic>
80102292:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <namei>:

struct inode*
namei(char *path)
{
801022a0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801022a1:	31 d2                	xor    %edx,%edx
{
801022a3:	89 e5                	mov    %esp,%ebp
801022a5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801022a8:	8b 45 08             	mov    0x8(%ebp),%eax
801022ab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801022ae:	e8 6d fd ff ff       	call   80102020 <namex>
}
801022b3:	c9                   	leave  
801022b4:	c3                   	ret    
801022b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022c0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022c0:	55                   	push   %ebp
  return namex(path, 1, name);
801022c1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022c6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022cb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ce:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022cf:	e9 4c fd ff ff       	jmp    80102020 <namex>
801022d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801022e0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801022e0:	55                   	push   %ebp
    char const digit[] = "0123456789";
801022e1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801022e6:	89 e5                	mov    %esp,%ebp
801022e8:	57                   	push   %edi
801022e9:	56                   	push   %esi
801022ea:	53                   	push   %ebx
801022eb:	83 ec 10             	sub    $0x10,%esp
801022ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801022f1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801022f8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801022ff:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102303:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102307:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010230a:	85 c9                	test   %ecx,%ecx
8010230c:	79 0a                	jns    80102318 <itoa+0x38>
8010230e:	89 f0                	mov    %esi,%eax
80102310:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102313:	f7 d9                	neg    %ecx
        *p++ = '-';
80102315:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102318:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010231a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010231f:	90                   	nop
80102320:	89 d8                	mov    %ebx,%eax
80102322:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102325:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102328:	f7 ef                	imul   %edi
8010232a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010232d:	29 da                	sub    %ebx,%edx
8010232f:	89 d3                	mov    %edx,%ebx
80102331:	75 ed                	jne    80102320 <itoa+0x40>
    *p = '\0';
80102333:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102336:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010233b:	90                   	nop
8010233c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102340:	89 c8                	mov    %ecx,%eax
80102342:	83 ee 01             	sub    $0x1,%esi
80102345:	f7 eb                	imul   %ebx
80102347:	89 c8                	mov    %ecx,%eax
80102349:	c1 f8 1f             	sar    $0x1f,%eax
8010234c:	c1 fa 02             	sar    $0x2,%edx
8010234f:	29 c2                	sub    %eax,%edx
80102351:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102354:	01 c0                	add    %eax,%eax
80102356:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102358:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010235a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010235f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102361:	88 06                	mov    %al,(%esi)
    }while(i);
80102363:	75 db                	jne    80102340 <itoa+0x60>
    return b;
}
80102365:	8b 45 0c             	mov    0xc(%ebp),%eax
80102368:	83 c4 10             	add    $0x10,%esp
8010236b:	5b                   	pop    %ebx
8010236c:	5e                   	pop    %esi
8010236d:	5f                   	pop    %edi
8010236e:	5d                   	pop    %ebp
8010236f:	c3                   	ret    

80102370 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	57                   	push   %edi
80102374:	56                   	push   %esi
80102375:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102376:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102379:	83 ec 40             	sub    $0x40,%esp
8010237c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010237f:	6a 06                	push   $0x6
80102381:	68 ab 90 10 80       	push   $0x801090ab
80102386:	56                   	push   %esi
80102387:	e8 64 30 00 00       	call   801053f0 <memmove>
  itoa(p->pid, path+ 6);
8010238c:	58                   	pop    %eax
8010238d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102390:	5a                   	pop    %edx
80102391:	50                   	push   %eax
80102392:	ff 73 10             	pushl  0x10(%ebx)
80102395:	e8 46 ff ff ff       	call   801022e0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010239a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010239d:	83 c4 10             	add    $0x10,%esp
801023a0:	85 c0                	test   %eax,%eax
801023a2:	0f 84 88 01 00 00    	je     80102530 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
801023a8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801023ab:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801023ae:	50                   	push   %eax
801023af:	e8 4c ee ff ff       	call   80101200 <fileclose>

  begin_op();
801023b4:	e8 a7 11 00 00       	call   80103560 <begin_op>
  return namex(path, 1, name);
801023b9:	89 f0                	mov    %esi,%eax
801023bb:	89 d9                	mov    %ebx,%ecx
801023bd:	ba 01 00 00 00       	mov    $0x1,%edx
801023c2:	e8 59 fc ff ff       	call   80102020 <namex>
  if((dp = nameiparent(path, name)) == 0)
801023c7:	83 c4 10             	add    $0x10,%esp
801023ca:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801023cc:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801023ce:	0f 84 66 01 00 00    	je     8010253a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	50                   	push   %eax
801023d8:	e8 63 f6 ff ff       	call   80101a40 <ilock>
  return strncmp(s, t, DIRSIZ);
801023dd:	83 c4 0c             	add    $0xc,%esp
801023e0:	6a 0e                	push   $0xe
801023e2:	68 b3 90 10 80       	push   $0x801090b3
801023e7:	53                   	push   %ebx
801023e8:	e8 73 30 00 00       	call   80105460 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 c0                	test   %eax,%eax
801023f2:	0f 84 f8 00 00 00    	je     801024f0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023f8:	83 ec 04             	sub    $0x4,%esp
801023fb:	6a 0e                	push   $0xe
801023fd:	68 b2 90 10 80       	push   $0x801090b2
80102402:	53                   	push   %ebx
80102403:	e8 58 30 00 00       	call   80105460 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102408:	83 c4 10             	add    $0x10,%esp
8010240b:	85 c0                	test   %eax,%eax
8010240d:	0f 84 dd 00 00 00    	je     801024f0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102413:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102416:	83 ec 04             	sub    $0x4,%esp
80102419:	50                   	push   %eax
8010241a:	53                   	push   %ebx
8010241b:	56                   	push   %esi
8010241c:	e8 4f fb ff ff       	call   80101f70 <dirlookup>
80102421:	83 c4 10             	add    $0x10,%esp
80102424:	85 c0                	test   %eax,%eax
80102426:	89 c3                	mov    %eax,%ebx
80102428:	0f 84 c2 00 00 00    	je     801024f0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010242e:	83 ec 0c             	sub    $0xc,%esp
80102431:	50                   	push   %eax
80102432:	e8 09 f6 ff ff       	call   80101a40 <ilock>

  if(ip->nlink < 1)
80102437:	83 c4 10             	add    $0x10,%esp
8010243a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010243f:	0f 8e 11 01 00 00    	jle    80102556 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102445:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010244a:	74 74                	je     801024c0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010244c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010244f:	83 ec 04             	sub    $0x4,%esp
80102452:	6a 10                	push   $0x10
80102454:	6a 00                	push   $0x0
80102456:	57                   	push   %edi
80102457:	e8 e4 2e 00 00       	call   80105340 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010245c:	6a 10                	push   $0x10
8010245e:	ff 75 b8             	pushl  -0x48(%ebp)
80102461:	57                   	push   %edi
80102462:	56                   	push   %esi
80102463:	e8 b8 f9 ff ff       	call   80101e20 <writei>
80102468:	83 c4 20             	add    $0x20,%esp
8010246b:	83 f8 10             	cmp    $0x10,%eax
8010246e:	0f 85 d5 00 00 00    	jne    80102549 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102474:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102479:	0f 84 91 00 00 00    	je     80102510 <removeSwapFile+0x1a0>
  iunlock(ip);
8010247f:	83 ec 0c             	sub    $0xc,%esp
80102482:	56                   	push   %esi
80102483:	e8 98 f6 ff ff       	call   80101b20 <iunlock>
  iput(ip);
80102488:	89 34 24             	mov    %esi,(%esp)
8010248b:	e8 e0 f6 ff ff       	call   80101b70 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102490:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102495:	89 1c 24             	mov    %ebx,(%esp)
80102498:	e8 f3 f4 ff ff       	call   80101990 <iupdate>
  iunlock(ip);
8010249d:	89 1c 24             	mov    %ebx,(%esp)
801024a0:	e8 7b f6 ff ff       	call   80101b20 <iunlock>
  iput(ip);
801024a5:	89 1c 24             	mov    %ebx,(%esp)
801024a8:	e8 c3 f6 ff ff       	call   80101b70 <iput>
  iunlockput(ip);

  end_op();
801024ad:	e8 1e 11 00 00       	call   801035d0 <end_op>

  return 0;
801024b2:	83 c4 10             	add    $0x10,%esp
801024b5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801024b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024ba:	5b                   	pop    %ebx
801024bb:	5e                   	pop    %esi
801024bc:	5f                   	pop    %edi
801024bd:	5d                   	pop    %ebp
801024be:	c3                   	ret    
801024bf:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801024c0:	83 ec 0c             	sub    $0xc,%esp
801024c3:	53                   	push   %ebx
801024c4:	e8 57 36 00 00       	call   80105b20 <isdirempty>
801024c9:	83 c4 10             	add    $0x10,%esp
801024cc:	85 c0                	test   %eax,%eax
801024ce:	0f 85 78 ff ff ff    	jne    8010244c <removeSwapFile+0xdc>
  iunlock(ip);
801024d4:	83 ec 0c             	sub    $0xc,%esp
801024d7:	53                   	push   %ebx
801024d8:	e8 43 f6 ff ff       	call   80101b20 <iunlock>
  iput(ip);
801024dd:	89 1c 24             	mov    %ebx,(%esp)
801024e0:	e8 8b f6 ff ff       	call   80101b70 <iput>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	90                   	nop
801024e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801024f0:	83 ec 0c             	sub    $0xc,%esp
801024f3:	56                   	push   %esi
801024f4:	e8 27 f6 ff ff       	call   80101b20 <iunlock>
  iput(ip);
801024f9:	89 34 24             	mov    %esi,(%esp)
801024fc:	e8 6f f6 ff ff       	call   80101b70 <iput>
    end_op();
80102501:	e8 ca 10 00 00       	call   801035d0 <end_op>
    return -1;
80102506:	83 c4 10             	add    $0x10,%esp
80102509:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010250e:	eb a7                	jmp    801024b7 <removeSwapFile+0x147>
    dp->nlink--;
80102510:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102515:	83 ec 0c             	sub    $0xc,%esp
80102518:	56                   	push   %esi
80102519:	e8 72 f4 ff ff       	call   80101990 <iupdate>
8010251e:	83 c4 10             	add    $0x10,%esp
80102521:	e9 59 ff ff ff       	jmp    8010247f <removeSwapFile+0x10f>
80102526:	8d 76 00             	lea    0x0(%esi),%esi
80102529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102530:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102535:	e9 7d ff ff ff       	jmp    801024b7 <removeSwapFile+0x147>
    end_op();
8010253a:	e8 91 10 00 00       	call   801035d0 <end_op>
    return -1;
8010253f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102544:	e9 6e ff ff ff       	jmp    801024b7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102549:	83 ec 0c             	sub    $0xc,%esp
8010254c:	68 c7 90 10 80       	push   $0x801090c7
80102551:	e8 3a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102556:	83 ec 0c             	sub    $0xc,%esp
80102559:	68 b5 90 10 80       	push   $0x801090b5
8010255e:	e8 2d de ff ff       	call   80100390 <panic>
80102563:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102570 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	56                   	push   %esi
80102574:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102575:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102578:	83 ec 14             	sub    $0x14,%esp
8010257b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010257e:	6a 06                	push   $0x6
80102580:	68 ab 90 10 80       	push   $0x801090ab
80102585:	56                   	push   %esi
80102586:	e8 65 2e 00 00       	call   801053f0 <memmove>
  itoa(p->pid, path+ 6);
8010258b:	58                   	pop    %eax
8010258c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010258f:	5a                   	pop    %edx
80102590:	50                   	push   %eax
80102591:	ff 73 10             	pushl  0x10(%ebx)
80102594:	e8 47 fd ff ff       	call   801022e0 <itoa>

    begin_op();
80102599:	e8 c2 0f 00 00       	call   80103560 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010259e:	6a 00                	push   $0x0
801025a0:	6a 00                	push   $0x0
801025a2:	6a 02                	push   $0x2
801025a4:	56                   	push   %esi
801025a5:	e8 86 37 00 00       	call   80105d30 <create>
  iunlock(in);
801025aa:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801025ad:	89 c6                	mov    %eax,%esi
  iunlock(in);
801025af:	50                   	push   %eax
801025b0:	e8 6b f5 ff ff       	call   80101b20 <iunlock>

  p->swapFile = filealloc();
801025b5:	e8 86 eb ff ff       	call   80101140 <filealloc>
  if (p->swapFile == 0)
801025ba:	83 c4 10             	add    $0x10,%esp
801025bd:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801025bf:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801025c2:	74 32                	je     801025f6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801025c4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801025c7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025ca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801025d0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801025da:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025dd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801025e1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025e4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801025e8:	e8 e3 0f 00 00       	call   801035d0 <end_op>

    return 0;
}
801025ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f0:	31 c0                	xor    %eax,%eax
801025f2:	5b                   	pop    %ebx
801025f3:	5e                   	pop    %esi
801025f4:	5d                   	pop    %ebp
801025f5:	c3                   	ret    
    panic("no slot for files on /store");
801025f6:	83 ec 0c             	sub    $0xc,%esp
801025f9:	68 d6 90 10 80       	push   $0x801090d6
801025fe:	e8 8d dd ff ff       	call   80100390 <panic>
80102603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102616:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102619:	8b 50 7c             	mov    0x7c(%eax),%edx
8010261c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010261f:	8b 55 14             	mov    0x14(%ebp),%edx
80102622:	89 55 10             	mov    %edx,0x10(%ebp)
80102625:	8b 40 7c             	mov    0x7c(%eax),%eax
80102628:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010262b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010262c:	e9 7f ed ff ff       	jmp    801013b0 <filewrite>
80102631:	eb 0d                	jmp    80102640 <readFromSwapFile>
80102633:	90                   	nop
80102634:	90                   	nop
80102635:	90                   	nop
80102636:	90                   	nop
80102637:	90                   	nop
80102638:	90                   	nop
80102639:	90                   	nop
8010263a:	90                   	nop
8010263b:	90                   	nop
8010263c:	90                   	nop
8010263d:	90                   	nop
8010263e:	90                   	nop
8010263f:	90                   	nop

80102640 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102646:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102649:	8b 50 7c             	mov    0x7c(%eax),%edx
8010264c:	89 4a 14             	mov    %ecx,0x14(%edx)
  return fileread(p->swapFile, buffer,  size);
8010264f:	8b 55 14             	mov    0x14(%ebp),%edx
80102652:	89 55 10             	mov    %edx,0x10(%ebp)
80102655:	8b 40 7c             	mov    0x7c(%eax),%eax
80102658:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010265b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010265c:	e9 bf ec ff ff       	jmp    80101320 <fileread>
80102661:	66 90                	xchg   %ax,%ax
80102663:	66 90                	xchg   %ax,%ax
80102665:	66 90                	xchg   %ax,%ax
80102667:	66 90                	xchg   %ax,%ax
80102669:	66 90                	xchg   %ax,%ax
8010266b:	66 90                	xchg   %ax,%ax
8010266d:	66 90                	xchg   %ax,%ax
8010266f:	90                   	nop

80102670 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	57                   	push   %edi
80102674:	56                   	push   %esi
80102675:	53                   	push   %ebx
80102676:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102679:	85 c0                	test   %eax,%eax
8010267b:	0f 84 b4 00 00 00    	je     80102735 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102681:	8b 58 08             	mov    0x8(%eax),%ebx
80102684:	89 c6                	mov    %eax,%esi
80102686:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010268c:	0f 87 96 00 00 00    	ja     80102728 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102692:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801026a0:	89 ca                	mov    %ecx,%edx
801026a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801026a3:	83 e0 c0             	and    $0xffffffc0,%eax
801026a6:	3c 40                	cmp    $0x40,%al
801026a8:	75 f6                	jne    801026a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801026aa:	31 ff                	xor    %edi,%edi
801026ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801026b1:	89 f8                	mov    %edi,%eax
801026b3:	ee                   	out    %al,(%dx)
801026b4:	b8 01 00 00 00       	mov    $0x1,%eax
801026b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801026be:	ee                   	out    %al,(%dx)
801026bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801026c4:	89 d8                	mov    %ebx,%eax
801026c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801026c7:	89 d8                	mov    %ebx,%eax
801026c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801026ce:	c1 f8 08             	sar    $0x8,%eax
801026d1:	ee                   	out    %al,(%dx)
801026d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801026d7:	89 f8                	mov    %edi,%eax
801026d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801026da:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801026de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801026e3:	c1 e0 04             	shl    $0x4,%eax
801026e6:	83 e0 10             	and    $0x10,%eax
801026e9:	83 c8 e0             	or     $0xffffffe0,%eax
801026ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801026ed:	f6 06 04             	testb  $0x4,(%esi)
801026f0:	75 16                	jne    80102708 <idestart+0x98>
801026f2:	b8 20 00 00 00       	mov    $0x20,%eax
801026f7:	89 ca                	mov    %ecx,%edx
801026f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801026fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026fd:	5b                   	pop    %ebx
801026fe:	5e                   	pop    %esi
801026ff:	5f                   	pop    %edi
80102700:	5d                   	pop    %ebp
80102701:	c3                   	ret    
80102702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102708:	b8 30 00 00 00       	mov    $0x30,%eax
8010270d:	89 ca                	mov    %ecx,%edx
8010270f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102710:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102715:	83 c6 5c             	add    $0x5c,%esi
80102718:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010271d:	fc                   	cld    
8010271e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102720:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102723:	5b                   	pop    %ebx
80102724:	5e                   	pop    %esi
80102725:	5f                   	pop    %edi
80102726:	5d                   	pop    %ebp
80102727:	c3                   	ret    
    panic("incorrect blockno");
80102728:	83 ec 0c             	sub    $0xc,%esp
8010272b:	68 50 91 10 80       	push   $0x80109150
80102730:	e8 5b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102735:	83 ec 0c             	sub    $0xc,%esp
80102738:	68 47 91 10 80       	push   $0x80109147
8010273d:	e8 4e dc ff ff       	call   80100390 <panic>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <ideinit>:
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102756:	68 62 91 10 80       	push   $0x80109162
8010275b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102760:	e8 8b 29 00 00       	call   801050f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102765:	58                   	pop    %eax
80102766:	a1 e0 60 18 80       	mov    0x801860e0,%eax
8010276b:	5a                   	pop    %edx
8010276c:	83 e8 01             	sub    $0x1,%eax
8010276f:	50                   	push   %eax
80102770:	6a 0e                	push   $0xe
80102772:	e8 a9 02 00 00       	call   80102a20 <ioapicenable>
80102777:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010277a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010277f:	90                   	nop
80102780:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102781:	83 e0 c0             	and    $0xffffffc0,%eax
80102784:	3c 40                	cmp    $0x40,%al
80102786:	75 f8                	jne    80102780 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102788:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010278d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102792:	ee                   	out    %al,(%dx)
80102793:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102798:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010279d:	eb 06                	jmp    801027a5 <ideinit+0x55>
8010279f:	90                   	nop
  for(i=0; i<1000; i++){
801027a0:	83 e9 01             	sub    $0x1,%ecx
801027a3:	74 0f                	je     801027b4 <ideinit+0x64>
801027a5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801027a6:	84 c0                	test   %al,%al
801027a8:	74 f6                	je     801027a0 <ideinit+0x50>
      havedisk1 = 1;
801027aa:	c7 05 80 c5 10 80 01 	movl   $0x1,0x8010c580
801027b1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801027b9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801027be:	ee                   	out    %al,(%dx)
}
801027bf:	c9                   	leave  
801027c0:	c3                   	ret    
801027c1:	eb 0d                	jmp    801027d0 <ideintr>
801027c3:	90                   	nop
801027c4:	90                   	nop
801027c5:	90                   	nop
801027c6:	90                   	nop
801027c7:	90                   	nop
801027c8:	90                   	nop
801027c9:	90                   	nop
801027ca:	90                   	nop
801027cb:	90                   	nop
801027cc:	90                   	nop
801027cd:	90                   	nop
801027ce:	90                   	nop
801027cf:	90                   	nop

801027d0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
801027d3:	57                   	push   %edi
801027d4:	56                   	push   %esi
801027d5:	53                   	push   %ebx
801027d6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027d9:	68 a0 c5 10 80       	push   $0x8010c5a0
801027de:	e8 4d 2a 00 00       	call   80105230 <acquire>

  if((b = idequeue) == 0){
801027e3:	8b 1d 84 c5 10 80    	mov    0x8010c584,%ebx
801027e9:	83 c4 10             	add    $0x10,%esp
801027ec:	85 db                	test   %ebx,%ebx
801027ee:	74 67                	je     80102857 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801027f0:	8b 43 58             	mov    0x58(%ebx),%eax
801027f3:	a3 84 c5 10 80       	mov    %eax,0x8010c584

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801027f8:	8b 3b                	mov    (%ebx),%edi
801027fa:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102800:	75 31                	jne    80102833 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102802:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102807:	89 f6                	mov    %esi,%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102810:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102811:	89 c6                	mov    %eax,%esi
80102813:	83 e6 c0             	and    $0xffffffc0,%esi
80102816:	89 f1                	mov    %esi,%ecx
80102818:	80 f9 40             	cmp    $0x40,%cl
8010281b:	75 f3                	jne    80102810 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010281d:	a8 21                	test   $0x21,%al
8010281f:	75 12                	jne    80102833 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102821:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102824:	b9 80 00 00 00       	mov    $0x80,%ecx
80102829:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010282e:	fc                   	cld    
8010282f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102831:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102833:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102836:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102839:	89 f9                	mov    %edi,%ecx
8010283b:	83 c9 02             	or     $0x2,%ecx
8010283e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102840:	53                   	push   %ebx
80102841:	e8 da 24 00 00       	call   80104d20 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102846:	a1 84 c5 10 80       	mov    0x8010c584,%eax
8010284b:	83 c4 10             	add    $0x10,%esp
8010284e:	85 c0                	test   %eax,%eax
80102850:	74 05                	je     80102857 <ideintr+0x87>
    idestart(idequeue);
80102852:	e8 19 fe ff ff       	call   80102670 <idestart>
    release(&idelock);
80102857:	83 ec 0c             	sub    $0xc,%esp
8010285a:	68 a0 c5 10 80       	push   $0x8010c5a0
8010285f:	e8 8c 2a 00 00       	call   801052f0 <release>

  release(&idelock);
}
80102864:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102867:	5b                   	pop    %ebx
80102868:	5e                   	pop    %esi
80102869:	5f                   	pop    %edi
8010286a:	5d                   	pop    %ebp
8010286b:	c3                   	ret    
8010286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102870 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102870:	55                   	push   %ebp
80102871:	89 e5                	mov    %esp,%ebp
80102873:	53                   	push   %ebx
80102874:	83 ec 10             	sub    $0x10,%esp
80102877:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010287a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010287d:	50                   	push   %eax
8010287e:	e8 1d 28 00 00       	call   801050a0 <holdingsleep>
80102883:	83 c4 10             	add    $0x10,%esp
80102886:	85 c0                	test   %eax,%eax
80102888:	0f 84 c6 00 00 00    	je     80102954 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010288e:	8b 03                	mov    (%ebx),%eax
80102890:	83 e0 06             	and    $0x6,%eax
80102893:	83 f8 02             	cmp    $0x2,%eax
80102896:	0f 84 ab 00 00 00    	je     80102947 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010289c:	8b 53 04             	mov    0x4(%ebx),%edx
8010289f:	85 d2                	test   %edx,%edx
801028a1:	74 0d                	je     801028b0 <iderw+0x40>
801028a3:	a1 80 c5 10 80       	mov    0x8010c580,%eax
801028a8:	85 c0                	test   %eax,%eax
801028aa:	0f 84 b1 00 00 00    	je     80102961 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801028b0:	83 ec 0c             	sub    $0xc,%esp
801028b3:	68 a0 c5 10 80       	push   $0x8010c5a0
801028b8:	e8 73 29 00 00       	call   80105230 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028bd:	8b 15 84 c5 10 80    	mov    0x8010c584,%edx
801028c3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801028c6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028cd:	85 d2                	test   %edx,%edx
801028cf:	75 09                	jne    801028da <iderw+0x6a>
801028d1:	eb 6d                	jmp    80102940 <iderw+0xd0>
801028d3:	90                   	nop
801028d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028d8:	89 c2                	mov    %eax,%edx
801028da:	8b 42 58             	mov    0x58(%edx),%eax
801028dd:	85 c0                	test   %eax,%eax
801028df:	75 f7                	jne    801028d8 <iderw+0x68>
801028e1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801028e4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801028e6:	39 1d 84 c5 10 80    	cmp    %ebx,0x8010c584
801028ec:	74 42                	je     80102930 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801028ee:	8b 03                	mov    (%ebx),%eax
801028f0:	83 e0 06             	and    $0x6,%eax
801028f3:	83 f8 02             	cmp    $0x2,%eax
801028f6:	74 23                	je     8010291b <iderw+0xab>
801028f8:	90                   	nop
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102900:	83 ec 08             	sub    $0x8,%esp
80102903:	68 a0 c5 10 80       	push   $0x8010c5a0
80102908:	53                   	push   %ebx
80102909:	e8 d2 21 00 00       	call   80104ae0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010290e:	8b 03                	mov    (%ebx),%eax
80102910:	83 c4 10             	add    $0x10,%esp
80102913:	83 e0 06             	and    $0x6,%eax
80102916:	83 f8 02             	cmp    $0x2,%eax
80102919:	75 e5                	jne    80102900 <iderw+0x90>
  }


  release(&idelock);
8010291b:	c7 45 08 a0 c5 10 80 	movl   $0x8010c5a0,0x8(%ebp)
}
80102922:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102925:	c9                   	leave  
  release(&idelock);
80102926:	e9 c5 29 00 00       	jmp    801052f0 <release>
8010292b:	90                   	nop
8010292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102930:	89 d8                	mov    %ebx,%eax
80102932:	e8 39 fd ff ff       	call   80102670 <idestart>
80102937:	eb b5                	jmp    801028ee <iderw+0x7e>
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102940:	ba 84 c5 10 80       	mov    $0x8010c584,%edx
80102945:	eb 9d                	jmp    801028e4 <iderw+0x74>
    panic("iderw: nothing to do");
80102947:	83 ec 0c             	sub    $0xc,%esp
8010294a:	68 7c 91 10 80       	push   $0x8010917c
8010294f:	e8 3c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	68 66 91 10 80       	push   $0x80109166
8010295c:	e8 2f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102961:	83 ec 0c             	sub    $0xc,%esp
80102964:	68 91 91 10 80       	push   $0x80109191
80102969:	e8 22 da ff ff       	call   80100390 <panic>
8010296e:	66 90                	xchg   %ax,%ax

80102970 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102970:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102971:	c7 05 14 5a 11 80 00 	movl   $0xfec00000,0x80115a14
80102978:	00 c0 fe 
{
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	56                   	push   %esi
8010297e:	53                   	push   %ebx
  ioapic->reg = reg;
8010297f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102986:	00 00 00 
  return ioapic->data;
80102989:	a1 14 5a 11 80       	mov    0x80115a14,%eax
8010298e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102997:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010299d:	0f b6 15 40 5b 18 80 	movzbl 0x80185b40,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029a4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801029a7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029aa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801029ad:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801029b0:	39 c2                	cmp    %eax,%edx
801029b2:	74 16                	je     801029ca <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029b4:	83 ec 0c             	sub    $0xc,%esp
801029b7:	68 b0 91 10 80       	push   $0x801091b0
801029bc:	e8 9f dc ff ff       	call   80100660 <cprintf>
801029c1:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
801029c7:	83 c4 10             	add    $0x10,%esp
801029ca:	83 c3 21             	add    $0x21,%ebx
{
801029cd:	ba 10 00 00 00       	mov    $0x10,%edx
801029d2:	b8 20 00 00 00       	mov    $0x20,%eax
801029d7:	89 f6                	mov    %esi,%esi
801029d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801029e0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801029e2:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029e8:	89 c6                	mov    %eax,%esi
801029ea:	81 ce 00 00 01 00    	or     $0x10000,%esi
801029f0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801029f3:	89 71 10             	mov    %esi,0x10(%ecx)
801029f6:	8d 72 01             	lea    0x1(%edx),%esi
801029f9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801029fc:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801029fe:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102a00:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
80102a06:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102a0d:	75 d1                	jne    801029e0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102a0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a12:	5b                   	pop    %ebx
80102a13:	5e                   	pop    %esi
80102a14:	5d                   	pop    %ebp
80102a15:	c3                   	ret    
80102a16:	8d 76 00             	lea    0x0(%esi),%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a20:	55                   	push   %ebp
  ioapic->reg = reg;
80102a21:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
{
80102a27:	89 e5                	mov    %esp,%ebp
80102a29:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a2c:	8d 50 20             	lea    0x20(%eax),%edx
80102a2f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102a33:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a35:	8b 0d 14 5a 11 80    	mov    0x80115a14,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a3b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a3e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a44:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a46:	a1 14 5a 11 80       	mov    0x80115a14,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a4b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102a4e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a51:	5d                   	pop    %ebp
80102a52:	c3                   	ret    
80102a53:	66 90                	xchg   %ax,%ax
80102a55:	66 90                	xchg   %ax,%ax
80102a57:	66 90                	xchg   %ax,%ax
80102a59:	66 90                	xchg   %ax,%ax
80102a5b:	66 90                	xchg   %ax,%ax
80102a5d:	66 90                	xchg   %ax,%ax
80102a5f:	90                   	nop

80102a60 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a60:	55                   	push   %ebp
80102a61:	89 e5                	mov    %esp,%ebp
80102a63:	53                   	push   %ebx
80102a64:	83 ec 04             	sub    $0x4,%esp
80102a67:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102a6a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102a6f:	0f 85 ad 00 00 00    	jne    80102b22 <kfree+0xc2>
80102a75:	3d 88 75 19 80       	cmp    $0x80197588,%eax
80102a7a:	0f 82 a2 00 00 00    	jb     80102b22 <kfree+0xc2>
80102a80:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102a86:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102a8c:	0f 87 90 00 00 00    	ja     80102b22 <kfree+0xc2>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a92:	83 ec 04             	sub    $0x4,%esp
80102a95:	68 00 10 00 00       	push   $0x1000
80102a9a:	6a 01                	push   $0x1
80102a9c:	50                   	push   %eax
80102a9d:	e8 9e 28 00 00       	call   80105340 <memset>

  if(kmem.use_lock) 
80102aa2:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102aa8:	83 c4 10             	add    $0x10,%esp
80102aab:	85 d2                	test   %edx,%edx
80102aad:	75 61                	jne    80102b10 <kfree+0xb0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102aaf:	c1 eb 0c             	shr    $0xc,%ebx
80102ab2:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 1)
80102ab5:	83 3c c5 30 5a 11 80 	cmpl   $0x1,-0x7feea5d0(,%eax,8)
80102abc:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102abd:	8d 14 c5 2c 5a 11 80 	lea    -0x7feea5d4(,%eax,8),%edx
  if(r->refcount != 1)
80102ac4:	75 69                	jne    80102b2f <kfree+0xcf>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
80102ac6:	8b 0d 58 5a 11 80    	mov    0x80115a58,%ecx
  r->refcount = 0;
80102acc:	c7 04 c5 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%eax,8)
80102ad3:	00 00 00 00 
  kmem.freelist = r;
80102ad7:	89 15 58 5a 11 80    	mov    %edx,0x80115a58
  r->next = kmem.freelist;
80102add:	89 0c c5 2c 5a 11 80 	mov    %ecx,-0x7feea5d4(,%eax,8)
  if(kmem.use_lock)
80102ae4:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102ae9:	85 c0                	test   %eax,%eax
80102aeb:	75 0b                	jne    80102af8 <kfree+0x98>
    release(&kmem.lock);
}
80102aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102af0:	c9                   	leave  
80102af1:	c3                   	ret    
80102af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102af8:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b02:	c9                   	leave  
    release(&kmem.lock);
80102b03:	e9 e8 27 00 00       	jmp    801052f0 <release>
80102b08:	90                   	nop
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	68 20 5a 11 80       	push   $0x80115a20
80102b18:	e8 13 27 00 00       	call   80105230 <acquire>
80102b1d:	83 c4 10             	add    $0x10,%esp
80102b20:	eb 8d                	jmp    80102aaf <kfree+0x4f>
    panic("kfree");
80102b22:	83 ec 0c             	sub    $0xc,%esp
80102b25:	68 e2 91 10 80       	push   $0x801091e2
80102b2a:	e8 61 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b2f:	83 ec 0c             	sub    $0xc,%esp
80102b32:	68 e8 91 10 80       	push   $0x801091e8
80102b37:	e8 54 d8 ff ff       	call   80100390 <panic>
80102b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

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
80102b7d:	e8 be 27 00 00       	call   80105340 <memset>

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
80102bce:	e8 5d 26 00 00       	call   80105230 <acquire>
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
80102c0d:	e9 de 26 00 00       	jmp    801052f0 <release>
    panic("kfree_nocheck");
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	68 05 92 10 80       	push   $0x80109205
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
80102c7b:	68 13 92 10 80       	push   $0x80109213
80102c80:	68 20 5a 11 80       	push   $0x80115a20
80102c85:	e8 66 24 00 00       	call   801050f0 <initlock>
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
80102d8b:	e8 60 25 00 00       	call   801052f0 <release>
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
80102db0:	e8 7b 24 00 00       	call   80105230 <acquire>
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
80102ddb:	e8 10 25 00 00       	call   801052f0 <release>
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
80102e31:	e8 fa 23 00 00       	call   80105230 <acquire>
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
80102e55:	e9 96 24 00 00       	jmp    801052f0 <release>
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
80102ea1:	e8 8a 23 00 00       	call   80105230 <acquire>
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
80102ec5:	e9 26 24 00 00       	jmp    801052f0 <release>
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
80102f33:	0f b6 82 40 93 10 80 	movzbl -0x7fef6cc0(%edx),%eax
80102f3a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f3c:	0f b6 82 40 92 10 80 	movzbl -0x7fef6dc0(%edx),%eax
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
80102f53:	8b 04 85 20 92 10 80 	mov    -0x7fef6de0(,%eax,4),%eax
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
80102f78:	0f b6 82 40 93 10 80 	movzbl -0x7fef6cc0(%edx),%eax
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
801032f7:	e8 94 20 00 00       	call   80105390 <memcmp>
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
80103424:	e8 c7 1f 00 00       	call   801053f0 <memmove>
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
801034ca:	68 40 94 10 80       	push   $0x80109440
801034cf:	68 60 5a 18 80       	push   $0x80185a60
801034d4:	e8 17 1c 00 00       	call   801050f0 <initlock>
  readsb(dev, &sb);
801034d9:	58                   	pop    %eax
801034da:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034dd:	5a                   	pop    %edx
801034de:	50                   	push   %eax
801034df:	53                   	push   %ebx
801034e0:	e8 1b e3 ff ff       	call   80101800 <readsb>
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
8010356b:	e8 c0 1c 00 00       	call   80105230 <acquire>
80103570:	83 c4 10             	add    $0x10,%esp
80103573:	eb 18                	jmp    8010358d <begin_op+0x2d>
80103575:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103578:	83 ec 08             	sub    $0x8,%esp
8010357b:	68 60 5a 18 80       	push   $0x80185a60
80103580:	68 60 5a 18 80       	push   $0x80185a60
80103585:	e8 56 15 00 00       	call   80104ae0 <sleep>
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
801035bc:	e8 2f 1d 00 00       	call   801052f0 <release>
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
801035de:	e8 4d 1c 00 00       	call   80105230 <acquire>
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
8010361c:	e8 cf 1c 00 00       	call   801052f0 <release>
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
80103676:	e8 75 1d 00 00       	call   801053f0 <memmove>
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
801036bf:	e8 6c 1b 00 00       	call   80105230 <acquire>
    wakeup(&log);
801036c4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036cb:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036d2:	00 00 00 
    wakeup(&log);
801036d5:	e8 46 16 00 00       	call   80104d20 <wakeup>
    release(&log.lock);
801036da:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036e1:	e8 0a 1c 00 00       	call   801052f0 <release>
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
80103700:	e8 1b 16 00 00       	call   80104d20 <wakeup>
  release(&log.lock);
80103705:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
8010370c:	e8 df 1b 00 00       	call   801052f0 <release>
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
8010371f:	68 44 94 10 80       	push   $0x80109444
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
8010376e:	e8 bd 1a 00 00       	call   80105230 <acquire>
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
801037bd:	e9 2e 1b 00 00       	jmp    801052f0 <release>
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
801037e9:	68 53 94 10 80       	push   $0x80109453
801037ee:	e8 9d cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037f3:	83 ec 0c             	sub    $0xc,%esp
801037f6:	68 69 94 10 80       	push   $0x80109469
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
80103818:	68 84 94 10 80       	push   $0x80109484
8010381d:	e8 3e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103822:	e8 09 2e 00 00       	call   80106630 <idtinit>
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
8010383a:	e8 91 0f 00 00       	call   801047d0 <scheduler>
8010383f:	90                   	nop

80103840 <mpenter>:
{
80103840:	55                   	push   %ebp
80103841:	89 e5                	mov    %esp,%ebp
80103843:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103846:	e8 85 3f 00 00       	call   801077d0 <switchkvm>
  seginit();
8010384b:	e8 f0 3e 00 00       	call   80107740 <seginit>
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
80103881:	e8 6a 45 00 00       	call   80107df0 <kvmalloc>
  mpinit();        // detect other processors
80103886:	e8 75 01 00 00       	call   80103a00 <mpinit>
  lapicinit();     // interrupt controller
8010388b:	e8 60 f7 ff ff       	call   80102ff0 <lapicinit>
  seginit();       // segment descriptors
80103890:	e8 ab 3e 00 00       	call   80107740 <seginit>
  picinit();       // disable pic
80103895:	e8 46 03 00 00       	call   80103be0 <picinit>
  ioapicinit();    // another interrupt controller
8010389a:	e8 d1 f0 ff ff       	call   80102970 <ioapicinit>
  consoleinit();   // console hardware
8010389f:	e8 1c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801038a4:	e8 c7 30 00 00       	call   80106970 <uartinit>
  pinit();         // process table
801038a9:	e8 62 09 00 00       	call   80104210 <pinit>
  tvinit();        // trap vectors
801038ae:	e8 fd 2c 00 00       	call   801065b0 <tvinit>
  binit();         // buffer cache
801038b3:	e8 88 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801038b8:	e8 63 d8 ff ff       	call   80101120 <fileinit>
  ideinit();       // disk 
801038bd:	e8 8e ee ff ff       	call   80102750 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038c2:	83 c4 0c             	add    $0xc,%esp
801038c5:	68 8a 00 00 00       	push   $0x8a
801038ca:	68 8c c4 10 80       	push   $0x8010c48c
801038cf:	68 00 70 00 80       	push   $0x80007000
801038d4:	e8 17 1b 00 00       	call   801053f0 <memmove>

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
801039ae:	68 98 94 10 80       	push   $0x80109498
801039b3:	56                   	push   %esi
801039b4:	e8 d7 19 00 00       	call   80105390 <memcmp>
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
80103a6c:	68 b5 94 10 80       	push   $0x801094b5
80103a71:	56                   	push   %esi
80103a72:	e8 19 19 00 00       	call   80105390 <memcmp>
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
80103b00:	ff 24 95 dc 94 10 80 	jmp    *-0x7fef6b24(,%edx,4)
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
80103bb3:	68 9d 94 10 80       	push   $0x8010949d
80103bb8:	e8 d3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bbd:	83 ec 0c             	sub    $0xc,%esp
80103bc0:	68 bc 94 10 80       	push   $0x801094bc
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
80103c1b:	e8 20 d5 ff ff       	call   80101140 <filealloc>
80103c20:	85 c0                	test   %eax,%eax
80103c22:	89 03                	mov    %eax,(%ebx)
80103c24:	74 22                	je     80103c48 <pipealloc+0x48>
80103c26:	e8 15 d5 ff ff       	call   80101140 <filealloc>
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
80103c52:	e8 a9 d5 ff ff       	call   80101200 <fileclose>
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
80103c7a:	e8 81 d5 ff ff       	call   80101200 <fileclose>
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
80103cbb:	68 f0 94 10 80       	push   $0x801094f0
80103cc0:	50                   	push   %eax
80103cc1:	e8 2a 14 00 00       	call   801050f0 <initlock>
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
80103d1f:	e8 0c 15 00 00       	call   80105230 <acquire>
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
80103d3f:	e8 dc 0f 00 00       	call   80104d20 <wakeup>
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
80103d64:	e9 87 15 00 00       	jmp    801052f0 <release>
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d70:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d76:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d79:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d80:	00 00 00 
    wakeup(&p->nwrite);
80103d83:	50                   	push   %eax
80103d84:	e8 97 0f 00 00       	call   80104d20 <wakeup>
80103d89:	83 c4 10             	add    $0x10,%esp
80103d8c:	eb b9                	jmp    80103d47 <pipeclose+0x37>
80103d8e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d90:	83 ec 0c             	sub    $0xc,%esp
80103d93:	53                   	push   %ebx
80103d94:	e8 57 15 00 00       	call   801052f0 <release>
    kfree((char*)p);
80103d99:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d9c:	83 c4 10             	add    $0x10,%esp
}
80103d9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103da2:	5b                   	pop    %ebx
80103da3:	5e                   	pop    %esi
80103da4:	5d                   	pop    %ebp
    kfree((char*)p);
80103da5:	e9 b6 ec ff ff       	jmp    80102a60 <kfree>
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
80103dbd:	e8 6e 14 00 00       	call   80105230 <acquire>
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
80103e14:	e8 07 0f 00 00       	call   80104d20 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e19:	5a                   	pop    %edx
80103e1a:	59                   	pop    %ecx
80103e1b:	53                   	push   %ebx
80103e1c:	56                   	push   %esi
80103e1d:	e8 be 0c 00 00       	call   80104ae0 <sleep>
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
80103e54:	e8 97 14 00 00       	call   801052f0 <release>
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
80103ea3:	e8 78 0e 00 00       	call   80104d20 <wakeup>
  release(&p->lock);
80103ea8:	89 1c 24             	mov    %ebx,(%esp)
80103eab:	e8 40 14 00 00       	call   801052f0 <release>
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
80103ed0:	e8 5b 13 00 00       	call   80105230 <acquire>
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
80103f05:	e8 d6 0b 00 00       	call   80104ae0 <sleep>
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
80103f3e:	e8 ad 13 00 00       	call   801052f0 <release>
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
80103f97:	e8 84 0d 00 00       	call   80104d20 <wakeup>
  release(&p->lock);
80103f9c:	89 34 24             	mov    %esi,(%esp)
80103f9f:	e8 4c 13 00 00       	call   801052f0 <release>
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
80103fd3:	e8 58 12 00 00       	call   80105230 <acquire>
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
80104019:	e8 d2 12 00 00       	call   801052f0 <release>

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
80104042:	c7 40 14 a1 65 10 80 	movl   $0x801065a1,0x14(%eax)
  p->context = (struct context*)sp;
80104049:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010404c:	6a 14                	push   $0x14
8010404e:	6a 00                	push   $0x0
80104050:	50                   	push   %eax
80104051:	e8 ea 12 00 00       	call   80105340 <memset>
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
8010407c:	e8 ef e4 ff ff       	call   80102570 <createSwapFile>
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
801040ed:	e8 4e 12 00 00       	call   80105340 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040f2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040f8:	83 c4 0c             	add    $0xc,%esp
801040fb:	68 c0 01 00 00       	push   $0x1c0
80104100:	6a 00                	push   $0x0
80104102:	50                   	push   %eax
80104103:	e8 38 12 00 00       	call   80105340 <memset>
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
80104192:	e8 59 11 00 00       	call   801052f0 <release>
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
801041b5:	68 f5 94 10 80       	push   $0x801094f5
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
801041cb:	e8 20 11 00 00       	call   801052f0 <release>

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
801041ef:	e8 4c d6 ff ff       	call   80101840 <iinit>
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
80104216:	68 0f 95 10 80       	push   $0x8010950f
8010421b:	68 00 61 18 80       	push   $0x80186100
80104220:	e8 cb 0e 00 00       	call   801050f0 <initlock>
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
80104290:	68 16 95 10 80       	push   $0x80109516
80104295:	e8 f6 c0 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010429a:	83 ec 0c             	sub    $0xc,%esp
8010429d:	68 04 96 10 80       	push   $0x80109604
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
801042d7:	e8 84 0e 00 00       	call   80105160 <pushcli>
  c = mycpu();
801042dc:	e8 4f ff ff ff       	call   80104230 <mycpu>
  p = c->proc;
801042e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042e7:	e8 b4 0e 00 00       	call   801051a0 <popcli>
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
80104313:	e8 48 3a 00 00       	call   80107d60 <setupkvm>
80104318:	85 c0                	test   %eax,%eax
8010431a:	89 43 04             	mov    %eax,0x4(%ebx)
8010431d:	0f 84 bd 00 00 00    	je     801043e0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104323:	83 ec 04             	sub    $0x4,%esp
80104326:	68 2c 00 00 00       	push   $0x2c
8010432b:	68 60 c4 10 80       	push   $0x8010c460
80104330:	50                   	push   %eax
80104331:	e8 ca 35 00 00       	call   80107900 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104336:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104339:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010433f:	6a 4c                	push   $0x4c
80104341:	6a 00                	push   $0x0
80104343:	ff 73 18             	pushl  0x18(%ebx)
80104346:	e8 f5 0f 00 00       	call   80105340 <memset>
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
8010439f:	68 3f 95 10 80       	push   $0x8010953f
801043a4:	50                   	push   %eax
801043a5:	e8 76 11 00 00       	call   80105520 <safestrcpy>
  p->cwd = namei("/");
801043aa:	c7 04 24 48 95 10 80 	movl   $0x80109548,(%esp)
801043b1:	e8 ea de ff ff       	call   801022a0 <namei>
801043b6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043b9:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043c0:	e8 6b 0e 00 00       	call   80105230 <acquire>
  p->state = RUNNABLE;
801043c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043cc:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043d3:	e8 18 0f 00 00       	call   801052f0 <release>
}
801043d8:	83 c4 10             	add    $0x10,%esp
801043db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043de:	c9                   	leave  
801043df:	c3                   	ret    
    panic("userinit: out of memory?");
801043e0:	83 ec 0c             	sub    $0xc,%esp
801043e3:	68 26 95 10 80       	push   $0x80109526
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
801043fb:	e8 60 0d 00 00       	call   80105160 <pushcli>
  c = mycpu();
80104400:	e8 2b fe ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104405:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010440b:	e8 90 0d 00 00       	call   801051a0 <popcli>
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
8010441f:	e8 cc 33 00 00       	call   801077f0 <switchuvm>
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
8010443a:	e8 d1 43 00 00       	call   80108810 <allocuvm>
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
80104456:	68 4a 95 10 80       	push   $0x8010954a
8010445b:	e8 00 c2 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104463:	83 c4 0c             	add    $0xc,%esp
80104466:	01 c6                	add    %eax,%esi
80104468:	56                   	push   %esi
80104469:	50                   	push   %eax
8010446a:	ff 73 04             	pushl  0x4(%ebx)
8010446d:	e8 4e 36 00 00       	call   80107ac0 <deallocuvm>
80104472:	83 c4 10             	add    $0x10,%esp
80104475:	85 c0                	test   %eax,%eax
80104477:	75 a0                	jne    80104419 <growproc+0x29>
80104479:	eb cb                	jmp    80104446 <growproc+0x56>
8010447b:	90                   	nop
8010447c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104480 <copyAQ>:
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	53                   	push   %ebx
80104486:	83 ec 0c             	sub    $0xc,%esp
80104489:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010448c:	e8 cf 0c 00 00       	call   80105160 <pushcli>
  c = mycpu();
80104491:	e8 9a fd ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104496:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010449c:	e8 ff 0c 00 00       	call   801051a0 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
801044a1:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
801044a7:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
801044ae:	00 00 00 
  np->queue_tail = 0;
801044b1:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
801044b8:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
801044bb:	85 db                	test   %ebx,%ebx
801044bd:	74 4f                	je     8010450e <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
801044bf:	e8 7c e8 ff ff       	call   80102d40 <kalloc>
801044c4:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
801044c6:	8b 43 08             	mov    0x8(%ebx),%eax
801044c9:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
801044cc:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
801044d2:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
801044d9:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801044db:	85 db                	test   %ebx,%ebx
801044dd:	74 37                	je     80104516 <copyAQ+0x96>
801044df:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
801044e0:	e8 5b e8 ff ff       	call   80102d40 <kalloc>
    np_curr->page_index = old_curr->page_index;
801044e5:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
801044e8:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
801044eb:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
801044ee:	89 07                	mov    %eax,(%edi)
801044f0:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
801044f2:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
801044f4:	85 db                	test   %ebx,%ebx
801044f6:	75 e8                	jne    801044e0 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
801044f8:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
801044fe:	85 d2                	test   %edx,%edx
80104500:	74 0c                	je     8010450e <copyAQ+0x8e>
    np_curr->next = 0;
80104502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104508:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
8010450e:	83 c4 0c             	add    $0xc,%esp
80104511:	5b                   	pop    %ebx
80104512:	5e                   	pop    %esi
80104513:	5f                   	pop    %edi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
  while(old_curr != 0)
80104516:	89 f8                	mov    %edi,%eax
80104518:	eb de                	jmp    801044f8 <copyAQ+0x78>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <fork>:
{ 
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	57                   	push   %edi
80104524:	56                   	push   %esi
80104525:	53                   	push   %ebx
80104526:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010452c:	e8 2f 0c 00 00       	call   80105160 <pushcli>
  c = mycpu();
80104531:	e8 fa fc ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104536:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
8010453c:	89 b5 e4 f7 ff ff    	mov    %esi,-0x81c(%ebp)
  popcli();
80104542:	e8 59 0c 00 00       	call   801051a0 <popcli>
  if((np = allocproc()) == 0){
80104547:	e8 74 fa ff ff       	call   80103fc0 <allocproc>
8010454c:	85 c0                	test   %eax,%eax
8010454e:	89 85 e0 f7 ff ff    	mov    %eax,-0x820(%ebp)
80104554:	0f 84 48 02 00 00    	je     801047a2 <fork+0x282>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010455a:	83 ec 08             	sub    $0x8,%esp
8010455d:	ff 36                	pushl  (%esi)
8010455f:	ff 76 04             	pushl  0x4(%esi)
80104562:	89 c3                	mov    %eax,%ebx
80104564:	e8 e7 3a 00 00       	call   80108050 <copyuvm>
  if(np->pgdir == 0){
80104569:	83 c4 10             	add    $0x10,%esp
8010456c:	85 c0                	test   %eax,%eax
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010456e:	89 43 04             	mov    %eax,0x4(%ebx)
  if(np->pgdir == 0){
80104571:	0f 84 32 02 00 00    	je     801047a9 <fork+0x289>
  np->sz = curproc->sz;
80104577:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
8010457d:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
80104583:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80104585:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104588:	89 51 14             	mov    %edx,0x14(%ecx)
  np->sz = curproc->sz;
8010458b:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
8010458d:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
8010458f:	8b 72 18             	mov    0x18(%edx),%esi
80104592:	b9 13 00 00 00       	mov    $0x13,%ecx
80104597:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
80104599:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
8010459d:	0f 8e 1c 01 00 00    	jle    801046bf <fork+0x19f>
    np->totalPgfltCount = 0;
801045a3:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
801045aa:	00 00 00 
    np->totalPgoutCount = 0;
801045ad:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801045b4:	00 00 00 
    np->totalPgfltCount = 0;
801045b7:	89 c1                	mov    %eax,%ecx
    np->num_ram = curproc->num_ram;
801045b9:	8b 82 08 04 00 00    	mov    0x408(%edx),%eax
801045bf:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
    np->num_swap = curproc->num_swap;
801045c5:	8b 82 0c 04 00 00    	mov    0x40c(%edx),%eax
801045cb:	89 81 0c 04 00 00    	mov    %eax,0x40c(%ecx)
      if(curproc->ramPages[i].isused)
801045d1:	8b 9a 4c 02 00 00    	mov    0x24c(%edx),%ebx
801045d7:	85 db                	test   %ebx,%ebx
801045d9:	0f 85 86 01 00 00    	jne    80104765 <fork+0x245>
801045df:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
{ 
801045e5:	c7 85 dc f7 ff ff 00 	movl   $0x0,-0x824(%ebp)
801045ec:	00 00 00 
801045ef:	90                   	nop
      if(curproc->swappedPages[i].isused)
801045f0:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801045f6:	8b 95 dc f7 ff ff    	mov    -0x824(%ebp),%edx
801045fc:	8b 84 11 8c 00 00 00 	mov    0x8c(%ecx,%edx,1),%eax
80104603:	85 c0                	test   %eax,%eax
80104605:	74 45                	je     8010464c <fork+0x12c>
      np->swappedPages[i].isused = 1;
80104607:	8b bd e0 f7 ff ff    	mov    -0x820(%ebp),%edi
8010460d:	c7 84 17 8c 00 00 00 	movl   $0x1,0x8c(%edi,%edx,1)
80104614:	01 00 00 00 
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104618:	8b 84 11 90 00 00 00 	mov    0x90(%ecx,%edx,1),%eax
8010461f:	89 84 17 90 00 00 00 	mov    %eax,0x90(%edi,%edx,1)
      np->swappedPages[i].pgdir = np->pgdir;
80104626:	8b 47 04             	mov    0x4(%edi),%eax
80104629:	89 84 17 88 00 00 00 	mov    %eax,0x88(%edi,%edx,1)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
80104630:	8b 84 11 94 00 00 00 	mov    0x94(%ecx,%edx,1),%eax
80104637:	89 84 17 94 00 00 00 	mov    %eax,0x94(%edi,%edx,1)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
8010463e:	8b 84 11 98 00 00 00 	mov    0x98(%ecx,%edx,1),%eax
80104645:	89 84 17 98 00 00 00 	mov    %eax,0x98(%edi,%edx,1)
        char buffer[PGSIZE / 2] = "";
8010464c:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104652:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104657:	31 c0                	xor    %eax,%eax
80104659:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104660:	00 00 00 
80104663:	f3 ab                	rep stos %eax,%es:(%edi)
        int offset = 0;
80104665:	31 ff                	xor    %edi,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
80104667:	eb 23                	jmp    8010468c <fork+0x16c>
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
80104670:	53                   	push   %ebx
80104671:	57                   	push   %edi
80104672:	56                   	push   %esi
80104673:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
80104679:	e8 92 df ff ff       	call   80102610 <writeToSwapFile>
8010467e:	83 c4 10             	add    $0x10,%esp
80104681:	83 f8 ff             	cmp    $0xffffffff,%eax
80104684:	0f 84 0b 01 00 00    	je     80104795 <fork+0x275>
        offset += nread;
8010468a:	01 df                	add    %ebx,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
8010468c:	68 00 08 00 00       	push   $0x800
80104691:	57                   	push   %edi
80104692:	56                   	push   %esi
80104693:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
80104699:	e8 a2 df ff ff       	call   80102640 <readFromSwapFile>
8010469e:	83 c4 10             	add    $0x10,%esp
801046a1:	85 c0                	test   %eax,%eax
801046a3:	89 c3                	mov    %eax,%ebx
801046a5:	75 c9                	jne    80104670 <fork+0x150>
801046a7:	83 85 dc f7 ff ff 1c 	addl   $0x1c,-0x824(%ebp)
801046ae:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801046b4:	3d c0 01 00 00       	cmp    $0x1c0,%eax
801046b9:	0f 85 31 ff ff ff    	jne    801045f0 <fork+0xd0>
  np->tf->eax = 0;
801046bf:	8b bd e0 f7 ff ff    	mov    -0x820(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
801046c5:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
801046cb:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801046cd:	8b 47 18             	mov    0x18(%edi),%eax
801046d0:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801046d7:	89 f6                	mov    %esi,%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ofile[i])
801046e0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801046e4:	85 c0                	test   %eax,%eax
801046e6:	74 10                	je     801046f8 <fork+0x1d8>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	50                   	push   %eax
801046ec:	e8 bf ca ff ff       	call   801011b0 <filedup>
801046f1:	83 c4 10             	add    $0x10,%esp
801046f4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
801046f8:	83 c6 01             	add    $0x1,%esi
801046fb:	83 fe 10             	cmp    $0x10,%esi
801046fe:	75 e0                	jne    801046e0 <fork+0x1c0>
  np->cwd = idup(curproc->cwd);
80104700:	8b b5 e4 f7 ff ff    	mov    -0x81c(%ebp),%esi
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	ff 76 68             	pushl  0x68(%esi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010470c:	8d 5e 6c             	lea    0x6c(%esi),%ebx
  np->cwd = idup(curproc->cwd);
8010470f:	e8 fc d2 ff ff       	call   80101a10 <idup>
80104714:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010471a:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010471d:	89 41 68             	mov    %eax,0x68(%ecx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104720:	8d 41 6c             	lea    0x6c(%ecx),%eax
80104723:	6a 10                	push   $0x10
80104725:	53                   	push   %ebx
80104726:	89 ce                	mov    %ecx,%esi
80104728:	50                   	push   %eax
80104729:	e8 f2 0d 00 00       	call   80105520 <safestrcpy>
  pid = np->pid;
8010472e:	8b 5e 10             	mov    0x10(%esi),%ebx
  copyAQ(np);
80104731:	89 34 24             	mov    %esi,(%esp)
80104734:	e8 47 fd ff ff       	call   80104480 <copyAQ>
  acquire(&ptable.lock);
80104739:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104740:	e8 eb 0a 00 00       	call   80105230 <acquire>
  np->state = RUNNABLE;
80104745:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
8010474c:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104753:	e8 98 0b 00 00       	call   801052f0 <release>
  return pid;
80104758:	83 c4 10             	add    $0x10,%esp
}
8010475b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010475e:	89 d8                	mov    %ebx,%eax
80104760:	5b                   	pop    %ebx
80104761:	5e                   	pop    %esi
80104762:	5f                   	pop    %edi
80104763:	5d                   	pop    %ebp
80104764:	c3                   	ret    
        np->ramPages[i].isused = 1;
80104765:	c7 81 4c 02 00 00 01 	movl   $0x1,0x24c(%ecx)
8010476c:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010476f:	8b 82 50 02 00 00    	mov    0x250(%edx),%eax
80104775:	89 81 50 02 00 00    	mov    %eax,0x250(%ecx)
        np->ramPages[i].pgdir = np->pgdir;
8010477b:	8b 41 04             	mov    0x4(%ecx),%eax
8010477e:	89 81 48 02 00 00    	mov    %eax,0x248(%ecx)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104784:	8b 82 58 02 00 00    	mov    0x258(%edx),%eax
8010478a:	89 81 58 02 00 00    	mov    %eax,0x258(%ecx)
80104790:	e9 4a fe ff ff       	jmp    801045df <fork+0xbf>
          panic("fork: error copying parent's swap file");
80104795:	83 ec 0c             	sub    $0xc,%esp
80104798:	68 2c 96 10 80       	push   $0x8010962c
8010479d:	e8 ee bb ff ff       	call   80100390 <panic>
    return -1;
801047a2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047a7:	eb b2                	jmp    8010475b <fork+0x23b>
    kfree(np->kstack);
801047a9:	8b b5 e0 f7 ff ff    	mov    -0x820(%ebp),%esi
801047af:	83 ec 0c             	sub    $0xc,%esp
    return -1;
801047b2:	83 cb ff             	or     $0xffffffff,%ebx
    kfree(np->kstack);
801047b5:	ff 76 08             	pushl  0x8(%esi)
801047b8:	e8 a3 e2 ff ff       	call   80102a60 <kfree>
    np->kstack = 0;
801047bd:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    np->state = UNUSED;
801047c4:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return -1;
801047cb:	83 c4 10             	add    $0x10,%esp
801047ce:	eb 8b                	jmp    8010475b <fork+0x23b>

801047d0 <scheduler>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
801047d6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047d9:	e8 52 fa ff ff       	call   80104230 <mycpu>
801047de:	8d 78 04             	lea    0x4(%eax),%edi
801047e1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801047e3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801047ea:	00 00 00 
801047ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801047f0:	fb                   	sti    
    acquire(&ptable.lock);
801047f1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047f4:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
801047f9:	68 00 61 18 80       	push   $0x80186100
801047fe:	e8 2d 0a 00 00       	call   80105230 <acquire>
80104803:	83 c4 10             	add    $0x10,%esp
80104806:	8d 76 00             	lea    0x0(%esi),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104810:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104814:	75 33                	jne    80104849 <scheduler+0x79>
      switchuvm(p);
80104816:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104819:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010481f:	53                   	push   %ebx
80104820:	e8 cb 2f 00 00       	call   801077f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104825:	58                   	pop    %eax
80104826:	5a                   	pop    %edx
80104827:	ff 73 1c             	pushl  0x1c(%ebx)
8010482a:	57                   	push   %edi
      p->state = RUNNING;
8010482b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104832:	e8 44 0d 00 00       	call   8010557b <swtch>
      switchkvm();
80104837:	e8 94 2f 00 00       	call   801077d0 <switchkvm>
      c->proc = 0;
8010483c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104843:	00 00 00 
80104846:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104849:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010484f:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104855:	72 b9                	jb     80104810 <scheduler+0x40>
    release(&ptable.lock);
80104857:	83 ec 0c             	sub    $0xc,%esp
8010485a:	68 00 61 18 80       	push   $0x80186100
8010485f:	e8 8c 0a 00 00       	call   801052f0 <release>
    sti();
80104864:	83 c4 10             	add    $0x10,%esp
80104867:	eb 87                	jmp    801047f0 <scheduler+0x20>
80104869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104870 <sched>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
  pushcli();
80104875:	e8 e6 08 00 00       	call   80105160 <pushcli>
  c = mycpu();
8010487a:	e8 b1 f9 ff ff       	call   80104230 <mycpu>
  p = c->proc;
8010487f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104885:	e8 16 09 00 00       	call   801051a0 <popcli>
  if(!holding(&ptable.lock))
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 00 61 18 80       	push   $0x80186100
80104892:	e8 69 09 00 00       	call   80105200 <holding>
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	85 c0                	test   %eax,%eax
8010489c:	74 4f                	je     801048ed <sched+0x7d>
  if(mycpu()->ncli != 1)
8010489e:	e8 8d f9 ff ff       	call   80104230 <mycpu>
801048a3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801048aa:	75 68                	jne    80104914 <sched+0xa4>
  if(p->state == RUNNING)
801048ac:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801048b0:	74 55                	je     80104907 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048b2:	9c                   	pushf  
801048b3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048b4:	f6 c4 02             	test   $0x2,%ah
801048b7:	75 41                	jne    801048fa <sched+0x8a>
  intena = mycpu()->intena;
801048b9:	e8 72 f9 ff ff       	call   80104230 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801048be:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801048c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801048c7:	e8 64 f9 ff ff       	call   80104230 <mycpu>
801048cc:	83 ec 08             	sub    $0x8,%esp
801048cf:	ff 70 04             	pushl  0x4(%eax)
801048d2:	53                   	push   %ebx
801048d3:	e8 a3 0c 00 00       	call   8010557b <swtch>
  mycpu()->intena = intena;
801048d8:	e8 53 f9 ff ff       	call   80104230 <mycpu>
}
801048dd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801048e0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801048e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048e9:	5b                   	pop    %ebx
801048ea:	5e                   	pop    %esi
801048eb:	5d                   	pop    %ebp
801048ec:	c3                   	ret    
    panic("sched ptable.lock");
801048ed:	83 ec 0c             	sub    $0xc,%esp
801048f0:	68 5b 95 10 80       	push   $0x8010955b
801048f5:	e8 96 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	68 87 95 10 80       	push   $0x80109587
80104902:	e8 89 ba ff ff       	call   80100390 <panic>
    panic("sched running");
80104907:	83 ec 0c             	sub    $0xc,%esp
8010490a:	68 79 95 10 80       	push   $0x80109579
8010490f:	e8 7c ba ff ff       	call   80100390 <panic>
    panic("sched locks");
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	68 6d 95 10 80       	push   $0x8010956d
8010491c:	e8 6f ba ff ff       	call   80100390 <panic>
80104921:	eb 0d                	jmp    80104930 <exit>
80104923:	90                   	nop
80104924:	90                   	nop
80104925:	90                   	nop
80104926:	90                   	nop
80104927:	90                   	nop
80104928:	90                   	nop
80104929:	90                   	nop
8010492a:	90                   	nop
8010492b:	90                   	nop
8010492c:	90                   	nop
8010492d:	90                   	nop
8010492e:	90                   	nop
8010492f:	90                   	nop

80104930 <exit>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	57                   	push   %edi
80104934:	56                   	push   %esi
80104935:	53                   	push   %ebx
80104936:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104939:	e8 22 08 00 00       	call   80105160 <pushcli>
  c = mycpu();
8010493e:	e8 ed f8 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104943:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104949:	e8 52 08 00 00       	call   801051a0 <popcli>
  if(curproc == initproc)
8010494e:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
80104954:	8d 73 28             	lea    0x28(%ebx),%esi
80104957:	8d 7b 68             	lea    0x68(%ebx),%edi
8010495a:	0f 84 22 01 00 00    	je     80104a82 <exit+0x152>
    if(curproc->ofile[fd]){
80104960:	8b 06                	mov    (%esi),%eax
80104962:	85 c0                	test   %eax,%eax
80104964:	74 12                	je     80104978 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104966:	83 ec 0c             	sub    $0xc,%esp
80104969:	50                   	push   %eax
8010496a:	e8 91 c8 ff ff       	call   80101200 <fileclose>
      curproc->ofile[fd] = 0;
8010496f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104975:	83 c4 10             	add    $0x10,%esp
80104978:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010497b:	39 fe                	cmp    %edi,%esi
8010497d:	75 e1                	jne    80104960 <exit+0x30>
  begin_op();
8010497f:	e8 dc eb ff ff       	call   80103560 <begin_op>
  iput(curproc->cwd);
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	ff 73 68             	pushl  0x68(%ebx)
8010498a:	e8 e1 d1 ff ff       	call   80101b70 <iput>
  end_op();
8010498f:	e8 3c ec ff ff       	call   801035d0 <end_op>
  if(curproc->pid > 2) {
80104994:	83 c4 10             	add    $0x10,%esp
80104997:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
8010499b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
801049a2:	0f 8f b9 00 00 00    	jg     80104a61 <exit+0x131>
  acquire(&ptable.lock);
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	68 00 61 18 80       	push   $0x80186100
801049b0:	e8 7b 08 00 00       	call   80105230 <acquire>
  wakeup1(curproc->parent);
801049b5:	8b 53 14             	mov    0x14(%ebx),%edx
801049b8:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049bb:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049c0:	eb 12                	jmp    801049d4 <exit+0xa4>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c8:	05 30 04 00 00       	add    $0x430,%eax
801049cd:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049d2:	73 1e                	jae    801049f2 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
801049d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049d8:	75 ee                	jne    801049c8 <exit+0x98>
801049da:	3b 50 20             	cmp    0x20(%eax),%edx
801049dd:	75 e9                	jne    801049c8 <exit+0x98>
      p->state = RUNNABLE;
801049df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049e6:	05 30 04 00 00       	add    $0x430,%eax
801049eb:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049f0:	72 e2                	jb     801049d4 <exit+0xa4>
      p->parent = initproc;
801049f2:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049f8:	ba 34 61 18 80       	mov    $0x80186134,%edx
801049fd:	eb 0f                	jmp    80104a0e <exit+0xde>
801049ff:	90                   	nop
80104a00:	81 c2 30 04 00 00    	add    $0x430,%edx
80104a06:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104a0c:	73 3a                	jae    80104a48 <exit+0x118>
    if(p->parent == curproc){
80104a0e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104a11:	75 ed                	jne    80104a00 <exit+0xd0>
      if(p->state == ZOMBIE)
80104a13:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104a17:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104a1a:	75 e4                	jne    80104a00 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a1c:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104a21:	eb 11                	jmp    80104a34 <exit+0x104>
80104a23:	90                   	nop
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a28:	05 30 04 00 00       	add    $0x430,%eax
80104a2d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a32:	73 cc                	jae    80104a00 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104a34:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a38:	75 ee                	jne    80104a28 <exit+0xf8>
80104a3a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a3d:	75 e9                	jne    80104a28 <exit+0xf8>
      p->state = RUNNABLE;
80104a3f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a46:	eb e0                	jmp    80104a28 <exit+0xf8>
  curproc->state = ZOMBIE;
80104a48:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104a4f:	e8 1c fe ff ff       	call   80104870 <sched>
  panic("zombie exit");
80104a54:	83 ec 0c             	sub    $0xc,%esp
80104a57:	68 a8 95 10 80       	push   $0x801095a8
80104a5c:	e8 2f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a61:	83 ec 0c             	sub    $0xc,%esp
80104a64:	53                   	push   %ebx
80104a65:	e8 06 d9 ff ff       	call   80102370 <removeSwapFile>
80104a6a:	83 c4 10             	add    $0x10,%esp
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	0f 84 33 ff ff ff    	je     801049a8 <exit+0x78>
      panic("exit: error deleting swap file");
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	68 54 96 10 80       	push   $0x80109654
80104a7d:	e8 0e b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a82:	83 ec 0c             	sub    $0xc,%esp
80104a85:	68 9b 95 10 80       	push   $0x8010959b
80104a8a:	e8 01 b9 ff ff       	call   80100390 <panic>
80104a8f:	90                   	nop

80104a90 <yield>:
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a97:	68 00 61 18 80       	push   $0x80186100
80104a9c:	e8 8f 07 00 00       	call   80105230 <acquire>
  pushcli();
80104aa1:	e8 ba 06 00 00       	call   80105160 <pushcli>
  c = mycpu();
80104aa6:	e8 85 f7 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104aab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ab1:	e8 ea 06 00 00       	call   801051a0 <popcli>
  myproc()->state = RUNNABLE;
80104ab6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104abd:	e8 ae fd ff ff       	call   80104870 <sched>
  release(&ptable.lock);
80104ac2:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104ac9:	e8 22 08 00 00       	call   801052f0 <release>
}
80104ace:	83 c4 10             	add    $0x10,%esp
80104ad1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad4:	c9                   	leave  
80104ad5:	c3                   	ret    
80104ad6:	8d 76 00             	lea    0x0(%esi),%esi
80104ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ae0 <sleep>:
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	57                   	push   %edi
80104ae4:	56                   	push   %esi
80104ae5:	53                   	push   %ebx
80104ae6:	83 ec 0c             	sub    $0xc,%esp
80104ae9:	8b 7d 08             	mov    0x8(%ebp),%edi
80104aec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104aef:	e8 6c 06 00 00       	call   80105160 <pushcli>
  c = mycpu();
80104af4:	e8 37 f7 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104af9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aff:	e8 9c 06 00 00       	call   801051a0 <popcli>
  if(p == 0)
80104b04:	85 db                	test   %ebx,%ebx
80104b06:	0f 84 87 00 00 00    	je     80104b93 <sleep+0xb3>
  if(lk == 0)
80104b0c:	85 f6                	test   %esi,%esi
80104b0e:	74 76                	je     80104b86 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b10:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104b16:	74 50                	je     80104b68 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b18:	83 ec 0c             	sub    $0xc,%esp
80104b1b:	68 00 61 18 80       	push   $0x80186100
80104b20:	e8 0b 07 00 00       	call   80105230 <acquire>
    release(lk);
80104b25:	89 34 24             	mov    %esi,(%esp)
80104b28:	e8 c3 07 00 00       	call   801052f0 <release>
  p->chan = chan;
80104b2d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b30:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b37:	e8 34 fd ff ff       	call   80104870 <sched>
  p->chan = 0;
80104b3c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b43:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104b4a:	e8 a1 07 00 00       	call   801052f0 <release>
    acquire(lk);
80104b4f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b52:	83 c4 10             	add    $0x10,%esp
}
80104b55:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b58:	5b                   	pop    %ebx
80104b59:	5e                   	pop    %esi
80104b5a:	5f                   	pop    %edi
80104b5b:	5d                   	pop    %ebp
    acquire(lk);
80104b5c:	e9 cf 06 00 00       	jmp    80105230 <acquire>
80104b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b68:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b6b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b72:	e8 f9 fc ff ff       	call   80104870 <sched>
  p->chan = 0;
80104b77:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b81:	5b                   	pop    %ebx
80104b82:	5e                   	pop    %esi
80104b83:	5f                   	pop    %edi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
    panic("sleep without lk");
80104b86:	83 ec 0c             	sub    $0xc,%esp
80104b89:	68 ba 95 10 80       	push   $0x801095ba
80104b8e:	e8 fd b7 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b93:	83 ec 0c             	sub    $0xc,%esp
80104b96:	68 b4 95 10 80       	push   $0x801095b4
80104b9b:	e8 f0 b7 ff ff       	call   80100390 <panic>

80104ba0 <wait>:
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
  pushcli();
80104ba5:	e8 b6 05 00 00       	call   80105160 <pushcli>
  c = mycpu();
80104baa:	e8 81 f6 ff ff       	call   80104230 <mycpu>
  p = c->proc;
80104baf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104bb5:	e8 e6 05 00 00       	call   801051a0 <popcli>
  acquire(&ptable.lock);
80104bba:	83 ec 0c             	sub    $0xc,%esp
80104bbd:	68 00 61 18 80       	push   $0x80186100
80104bc2:	e8 69 06 00 00       	call   80105230 <acquire>
80104bc7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104bca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bcc:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104bd1:	eb 13                	jmp    80104be6 <wait+0x46>
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104bde:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104be4:	73 1e                	jae    80104c04 <wait+0x64>
      if(p->parent != curproc)
80104be6:	39 73 14             	cmp    %esi,0x14(%ebx)
80104be9:	75 ed                	jne    80104bd8 <wait+0x38>
      if(p->state == ZOMBIE){
80104beb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104bef:	74 3f                	je     80104c30 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf1:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104bf7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bfc:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104c02:	72 e2                	jb     80104be6 <wait+0x46>
    if(!havekids || curproc->killed){
80104c04:	85 c0                	test   %eax,%eax
80104c06:	0f 84 f3 00 00 00    	je     80104cff <wait+0x15f>
80104c0c:	8b 46 24             	mov    0x24(%esi),%eax
80104c0f:	85 c0                	test   %eax,%eax
80104c11:	0f 85 e8 00 00 00    	jne    80104cff <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c17:	83 ec 08             	sub    $0x8,%esp
80104c1a:	68 00 61 18 80       	push   $0x80186100
80104c1f:	56                   	push   %esi
80104c20:	e8 bb fe ff ff       	call   80104ae0 <sleep>
    havekids = 0;
80104c25:	83 c4 10             	add    $0x10,%esp
80104c28:	eb a0                	jmp    80104bca <wait+0x2a>
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104c30:	83 ec 0c             	sub    $0xc,%esp
80104c33:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104c36:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104c39:	e8 22 de ff ff       	call   80102a60 <kfree>
        freevm(p->pgdir); // panic: kfree
80104c3e:	5a                   	pop    %edx
80104c3f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104c49:	e8 92 30 00 00       	call   80107ce0 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c4e:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104c54:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104c57:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c5e:	68 c0 01 00 00       	push   $0x1c0
80104c63:	6a 00                	push   $0x0
80104c65:	50                   	push   %eax
        p->parent = 0;
80104c66:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c6d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c71:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c78:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c7f:	00 00 00 
        p->swapFile = 0;
80104c82:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104c89:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104c90:	00 00 00 
        p->free_tail = 0;
80104c93:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104c9a:	00 00 00 
        p->queue_head = 0;
80104c9d:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104ca4:	00 00 00 
        p->queue_tail = 0;
80104ca7:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104cae:	00 00 00 
        p->numswappages = 0;
80104cb1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104cb8:	00 00 00 
        p-> nummemorypages = 0;
80104cbb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104cc2:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104cc5:	e8 76 06 00 00       	call   80105340 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104cca:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104cd0:	83 c4 0c             	add    $0xc,%esp
80104cd3:	68 c0 01 00 00       	push   $0x1c0
80104cd8:	6a 00                	push   $0x0
80104cda:	50                   	push   %eax
80104cdb:	e8 60 06 00 00       	call   80105340 <memset>
        release(&ptable.lock);
80104ce0:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104ce7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104cee:	e8 fd 05 00 00       	call   801052f0 <release>
        return pid;
80104cf3:	83 c4 10             	add    $0x10,%esp
}
80104cf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf9:	89 f0                	mov    %esi,%eax
80104cfb:	5b                   	pop    %ebx
80104cfc:	5e                   	pop    %esi
80104cfd:	5d                   	pop    %ebp
80104cfe:	c3                   	ret    
      release(&ptable.lock);
80104cff:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104d02:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104d07:	68 00 61 18 80       	push   $0x80186100
80104d0c:	e8 df 05 00 00       	call   801052f0 <release>
      return -1;
80104d11:	83 c4 10             	add    $0x10,%esp
80104d14:	eb e0                	jmp    80104cf6 <wait+0x156>
80104d16:	8d 76 00             	lea    0x0(%esi),%esi
80104d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d20 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 10             	sub    $0x10,%esp
80104d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104d2a:	68 00 61 18 80       	push   $0x80186100
80104d2f:	e8 fc 04 00 00       	call   80105230 <acquire>
80104d34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d37:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d3c:	eb 0e                	jmp    80104d4c <wakeup+0x2c>
80104d3e:	66 90                	xchg   %ax,%ax
80104d40:	05 30 04 00 00       	add    $0x430,%eax
80104d45:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d4a:	73 1e                	jae    80104d6a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d4c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d50:	75 ee                	jne    80104d40 <wakeup+0x20>
80104d52:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d55:	75 e9                	jne    80104d40 <wakeup+0x20>
      p->state = RUNNABLE;
80104d57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d5e:	05 30 04 00 00       	add    $0x430,%eax
80104d63:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d68:	72 e2                	jb     80104d4c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d6a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d74:	c9                   	leave  
  release(&ptable.lock);
80104d75:	e9 76 05 00 00       	jmp    801052f0 <release>
80104d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d80 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d80:	55                   	push   %ebp
80104d81:	89 e5                	mov    %esp,%ebp
80104d83:	53                   	push   %ebx
80104d84:	83 ec 10             	sub    $0x10,%esp
80104d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d8a:	68 00 61 18 80       	push   $0x80186100
80104d8f:	e8 9c 04 00 00       	call   80105230 <acquire>
80104d94:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d97:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d9c:	eb 0e                	jmp    80104dac <kill+0x2c>
80104d9e:	66 90                	xchg   %ax,%ax
80104da0:	05 30 04 00 00       	add    $0x430,%eax
80104da5:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104daa:	73 34                	jae    80104de0 <kill+0x60>
    if(p->pid == pid){
80104dac:	39 58 10             	cmp    %ebx,0x10(%eax)
80104daf:	75 ef                	jne    80104da0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104db1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104db5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104dbc:	75 07                	jne    80104dc5 <kill+0x45>
        p->state = RUNNABLE;
80104dbe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104dc5:	83 ec 0c             	sub    $0xc,%esp
80104dc8:	68 00 61 18 80       	push   $0x80186100
80104dcd:	e8 1e 05 00 00       	call   801052f0 <release>
      return 0;
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104dd7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dda:	c9                   	leave  
80104ddb:	c3                   	ret    
80104ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104de0:	83 ec 0c             	sub    $0xc,%esp
80104de3:	68 00 61 18 80       	push   $0x80186100
80104de8:	e8 03 05 00 00       	call   801052f0 <release>
  return -1;
80104ded:	83 c4 10             	add    $0x10,%esp
80104df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df8:	c9                   	leave  
80104df9:	c3                   	ret    
80104dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e00 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104e04:	31 db                	xor    %ebx,%ebx
{
80104e06:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104e09:	68 00 61 18 80       	push   $0x80186100
80104e0e:	e8 1d 04 00 00       	call   80105230 <acquire>
80104e13:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e16:	ba 34 61 18 80       	mov    $0x80186134,%edx
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104e1b:	b9 10 00 00 00       	mov    $0x10,%ecx
    if(p->state == UNUSED)
80104e20:	8b 42 0c             	mov    0xc(%edx),%eax
80104e23:	85 c0                	test   %eax,%eax
80104e25:	74 0a                	je     80104e31 <getCurrentFreePages+0x31>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104e27:	89 c8                	mov    %ecx,%eax
80104e29:	2b 82 08 04 00 00    	sub    0x408(%edx),%eax
80104e2f:	01 c3                	add    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e31:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e37:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e3d:	72 e1                	jb     80104e20 <getCurrentFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104e3f:	83 ec 0c             	sub    $0xc,%esp
80104e42:	68 00 61 18 80       	push   $0x80186100
80104e47:	e8 a4 04 00 00       	call   801052f0 <release>
  return sum;
}
80104e4c:	89 d8                	mov    %ebx,%eax
80104e4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e51:	c9                   	leave  
80104e52:	c3                   	ret    
80104e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80104e64:	31 db                	xor    %ebx,%ebx
{
80104e66:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e69:	68 00 61 18 80       	push   $0x80186100
80104e6e:	e8 bd 03 00 00       	call   80105230 <acquire>
80104e73:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e76:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104e7b:	90                   	nop
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80104e80:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104e84:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e87:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e8d:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e93:	72 eb                	jb     80104e80 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80104e95:	83 ec 0c             	sub    $0xc,%esp
80104e98:	68 00 61 18 80       	push   $0x80186100
80104e9d:	e8 4e 04 00 00       	call   801052f0 <release>
  return pcount * MAX_PSYC_PAGES;
80104ea2:	89 d8                	mov    %ebx,%eax
80104ea4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return pcount * MAX_PSYC_PAGES;
80104ea7:	c1 e0 04             	shl    $0x4,%eax
80104eaa:	c9                   	leave  
80104eab:	c3                   	ret    
80104eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104eb0 <procdump>:
{
80104eb0:	55                   	push   %ebp
80104eb1:	89 e5                	mov    %esp,%ebp
80104eb3:	57                   	push   %edi
80104eb4:	56                   	push   %esi
80104eb5:	53                   	push   %ebx
80104eb6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104eb9:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104ebe:	83 ec 3c             	sub    $0x3c,%esp
80104ec1:	eb 41                	jmp    80104f04 <procdump+0x54>
80104ec3:	90                   	nop
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80104ec8:	e8 93 ff ff ff       	call   80104e60 <getTotalFreePages>
80104ecd:	89 c7                	mov    %eax,%edi
80104ecf:	e8 2c ff ff ff       	call   80104e00 <getCurrentFreePages>
80104ed4:	83 ec 04             	sub    $0x4,%esp
80104ed7:	57                   	push   %edi
80104ed8:	50                   	push   %eax
80104ed9:	68 cf 95 10 80       	push   $0x801095cf
80104ede:	e8 7d b7 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104ee3:	c7 04 24 70 9b 10 80 	movl   $0x80109b70,(%esp)
80104eea:	e8 71 b7 ff ff       	call   80100660 <cprintf>
80104eef:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ef2:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104ef8:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104efe:	0f 83 ac 00 00 00    	jae    80104fb0 <procdump+0x100>
    if(p->state == UNUSED)
80104f04:	8b 43 0c             	mov    0xc(%ebx),%eax
80104f07:	85 c0                	test   %eax,%eax
80104f09:	74 e7                	je     80104ef2 <procdump+0x42>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f0b:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104f0e:	ba cb 95 10 80       	mov    $0x801095cb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f13:	77 11                	ja     80104f26 <procdump+0x76>
80104f15:	8b 14 85 dc 96 10 80 	mov    -0x7fef6924(,%eax,4),%edx
      state = "???";
80104f1c:	b8 cb 95 10 80       	mov    $0x801095cb,%eax
80104f21:	85 d2                	test   %edx,%edx
80104f23:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104f26:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104f29:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104f2f:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104f35:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104f3b:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104f41:	50                   	push   %eax
80104f42:	52                   	push   %edx
80104f43:	ff 73 10             	pushl  0x10(%ebx)
80104f46:	68 74 96 10 80       	push   $0x80109674
80104f4b:	e8 10 b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104f50:	83 c4 20             	add    $0x20,%esp
80104f53:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104f57:	0f 85 6b ff ff ff    	jne    80104ec8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f5d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f60:	83 ec 08             	sub    $0x8,%esp
80104f63:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104f66:	50                   	push   %eax
80104f67:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f6a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f6d:	83 c0 08             	add    $0x8,%eax
80104f70:	50                   	push   %eax
80104f71:	e8 9a 01 00 00       	call   80105110 <getcallerpcs>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104f80:	8b 17                	mov    (%edi),%edx
80104f82:	85 d2                	test   %edx,%edx
80104f84:	0f 84 3e ff ff ff    	je     80104ec8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104f8a:	83 ec 08             	sub    $0x8,%esp
80104f8d:	83 c7 04             	add    $0x4,%edi
80104f90:	52                   	push   %edx
80104f91:	68 21 8f 10 80       	push   $0x80108f21
80104f96:	e8 c5 b6 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104f9b:	83 c4 10             	add    $0x10,%esp
80104f9e:	39 fe                	cmp    %edi,%esi
80104fa0:	75 de                	jne    80104f80 <procdump+0xd0>
80104fa2:	e9 21 ff ff ff       	jmp    80104ec8 <procdump+0x18>
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb3:	5b                   	pop    %ebx
80104fb4:	5e                   	pop    %esi
80104fb5:	5f                   	pop    %edi
80104fb6:	5d                   	pop    %ebp
80104fb7:	c3                   	ret    
80104fb8:	66 90                	xchg   %ax,%ax
80104fba:	66 90                	xchg   %ax,%ax
80104fbc:	66 90                	xchg   %ax,%ax
80104fbe:	66 90                	xchg   %ax,%ax

80104fc0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	53                   	push   %ebx
80104fc4:	83 ec 0c             	sub    $0xc,%esp
80104fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104fca:	68 f4 96 10 80       	push   $0x801096f4
80104fcf:	8d 43 04             	lea    0x4(%ebx),%eax
80104fd2:	50                   	push   %eax
80104fd3:	e8 18 01 00 00       	call   801050f0 <initlock>
  lk->name = name;
80104fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104fdb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104fe1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104fe4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104feb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104fee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff1:	c9                   	leave  
80104ff2:	c3                   	ret    
80104ff3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
80105005:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105008:	83 ec 0c             	sub    $0xc,%esp
8010500b:	8d 73 04             	lea    0x4(%ebx),%esi
8010500e:	56                   	push   %esi
8010500f:	e8 1c 02 00 00       	call   80105230 <acquire>
  while (lk->locked) {
80105014:	8b 13                	mov    (%ebx),%edx
80105016:	83 c4 10             	add    $0x10,%esp
80105019:	85 d2                	test   %edx,%edx
8010501b:	74 16                	je     80105033 <acquiresleep+0x33>
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105020:	83 ec 08             	sub    $0x8,%esp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
80105025:	e8 b6 fa ff ff       	call   80104ae0 <sleep>
  while (lk->locked) {
8010502a:	8b 03                	mov    (%ebx),%eax
8010502c:	83 c4 10             	add    $0x10,%esp
8010502f:	85 c0                	test   %eax,%eax
80105031:	75 ed                	jne    80105020 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105033:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105039:	e8 92 f2 ff ff       	call   801042d0 <myproc>
8010503e:	8b 40 10             	mov    0x10(%eax),%eax
80105041:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105044:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105047:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010504a:	5b                   	pop    %ebx
8010504b:	5e                   	pop    %esi
8010504c:	5d                   	pop    %ebp
  release(&lk->lk);
8010504d:	e9 9e 02 00 00       	jmp    801052f0 <release>
80105052:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
80105065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105068:	83 ec 0c             	sub    $0xc,%esp
8010506b:	8d 73 04             	lea    0x4(%ebx),%esi
8010506e:	56                   	push   %esi
8010506f:	e8 bc 01 00 00       	call   80105230 <acquire>
  lk->locked = 0;
80105074:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010507a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105081:	89 1c 24             	mov    %ebx,(%esp)
80105084:	e8 97 fc ff ff       	call   80104d20 <wakeup>
  release(&lk->lk);
80105089:	89 75 08             	mov    %esi,0x8(%ebp)
8010508c:	83 c4 10             	add    $0x10,%esp
}
8010508f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105092:	5b                   	pop    %ebx
80105093:	5e                   	pop    %esi
80105094:	5d                   	pop    %ebp
  release(&lk->lk);
80105095:	e9 56 02 00 00       	jmp    801052f0 <release>
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050a0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
801050a6:	31 ff                	xor    %edi,%edi
801050a8:	83 ec 18             	sub    $0x18,%esp
801050ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801050ae:	8d 73 04             	lea    0x4(%ebx),%esi
801050b1:	56                   	push   %esi
801050b2:	e8 79 01 00 00       	call   80105230 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801050b7:	8b 03                	mov    (%ebx),%eax
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	85 c0                	test   %eax,%eax
801050be:	74 13                	je     801050d3 <holdingsleep+0x33>
801050c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801050c3:	e8 08 f2 ff ff       	call   801042d0 <myproc>
801050c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801050cb:	0f 94 c0             	sete   %al
801050ce:	0f b6 c0             	movzbl %al,%eax
801050d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801050d3:	83 ec 0c             	sub    $0xc,%esp
801050d6:	56                   	push   %esi
801050d7:	e8 14 02 00 00       	call   801052f0 <release>
  return r;
}
801050dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050df:	89 f8                	mov    %edi,%eax
801050e1:	5b                   	pop    %ebx
801050e2:	5e                   	pop    %esi
801050e3:	5f                   	pop    %edi
801050e4:	5d                   	pop    %ebp
801050e5:	c3                   	ret    
801050e6:	66 90                	xchg   %ax,%ax
801050e8:	66 90                	xchg   %ax,%ax
801050ea:	66 90                	xchg   %ax,%ax
801050ec:	66 90                	xchg   %ax,%ax
801050ee:	66 90                	xchg   %ax,%ax

801050f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801050f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801050f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801050ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105102:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105109:	5d                   	pop    %ebp
8010510a:	c3                   	ret    
8010510b:	90                   	nop
8010510c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105110 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105110:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105111:	31 d2                	xor    %edx,%edx
{
80105113:	89 e5                	mov    %esp,%ebp
80105115:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105116:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010511c:	83 e8 08             	sub    $0x8,%eax
8010511f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105120:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105126:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010512c:	77 1a                	ja     80105148 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010512e:	8b 58 04             	mov    0x4(%eax),%ebx
80105131:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105134:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105137:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105139:	83 fa 0a             	cmp    $0xa,%edx
8010513c:	75 e2                	jne    80105120 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010513e:	5b                   	pop    %ebx
8010513f:	5d                   	pop    %ebp
80105140:	c3                   	ret    
80105141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105148:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010514b:	83 c1 28             	add    $0x28,%ecx
8010514e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105150:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105156:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105159:	39 c1                	cmp    %eax,%ecx
8010515b:	75 f3                	jne    80105150 <getcallerpcs+0x40>
}
8010515d:	5b                   	pop    %ebx
8010515e:	5d                   	pop    %ebp
8010515f:	c3                   	ret    

80105160 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	53                   	push   %ebx
80105164:	83 ec 04             	sub    $0x4,%esp
80105167:	9c                   	pushf  
80105168:	5b                   	pop    %ebx
  asm volatile("cli");
80105169:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010516a:	e8 c1 f0 ff ff       	call   80104230 <mycpu>
8010516f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105175:	85 c0                	test   %eax,%eax
80105177:	75 11                	jne    8010518a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105179:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010517f:	e8 ac f0 ff ff       	call   80104230 <mycpu>
80105184:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010518a:	e8 a1 f0 ff ff       	call   80104230 <mycpu>
8010518f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105196:	83 c4 04             	add    $0x4,%esp
80105199:	5b                   	pop    %ebx
8010519a:	5d                   	pop    %ebp
8010519b:	c3                   	ret    
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051a0 <popcli>:

void
popcli(void)
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801051a6:	9c                   	pushf  
801051a7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801051a8:	f6 c4 02             	test   $0x2,%ah
801051ab:	75 35                	jne    801051e2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801051ad:	e8 7e f0 ff ff       	call   80104230 <mycpu>
801051b2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801051b9:	78 34                	js     801051ef <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051bb:	e8 70 f0 ff ff       	call   80104230 <mycpu>
801051c0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051c6:	85 d2                	test   %edx,%edx
801051c8:	74 06                	je     801051d0 <popcli+0x30>
    sti();
}
801051ca:	c9                   	leave  
801051cb:	c3                   	ret    
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051d0:	e8 5b f0 ff ff       	call   80104230 <mycpu>
801051d5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051db:	85 c0                	test   %eax,%eax
801051dd:	74 eb                	je     801051ca <popcli+0x2a>
  asm volatile("sti");
801051df:	fb                   	sti    
}
801051e0:	c9                   	leave  
801051e1:	c3                   	ret    
    panic("popcli - interruptible");
801051e2:	83 ec 0c             	sub    $0xc,%esp
801051e5:	68 ff 96 10 80       	push   $0x801096ff
801051ea:	e8 a1 b1 ff ff       	call   80100390 <panic>
    panic("popcli");
801051ef:	83 ec 0c             	sub    $0xc,%esp
801051f2:	68 16 97 10 80       	push   $0x80109716
801051f7:	e8 94 b1 ff ff       	call   80100390 <panic>
801051fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105200 <holding>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	56                   	push   %esi
80105204:	53                   	push   %ebx
80105205:	8b 75 08             	mov    0x8(%ebp),%esi
80105208:	31 db                	xor    %ebx,%ebx
  pushcli();
8010520a:	e8 51 ff ff ff       	call   80105160 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010520f:	8b 06                	mov    (%esi),%eax
80105211:	85 c0                	test   %eax,%eax
80105213:	74 10                	je     80105225 <holding+0x25>
80105215:	8b 5e 08             	mov    0x8(%esi),%ebx
80105218:	e8 13 f0 ff ff       	call   80104230 <mycpu>
8010521d:	39 c3                	cmp    %eax,%ebx
8010521f:	0f 94 c3             	sete   %bl
80105222:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105225:	e8 76 ff ff ff       	call   801051a0 <popcli>
}
8010522a:	89 d8                	mov    %ebx,%eax
8010522c:	5b                   	pop    %ebx
8010522d:	5e                   	pop    %esi
8010522e:	5d                   	pop    %ebp
8010522f:	c3                   	ret    

80105230 <acquire>:
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	56                   	push   %esi
80105234:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105235:	e8 26 ff ff ff       	call   80105160 <pushcli>
  if(holding(lk))
8010523a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010523d:	83 ec 0c             	sub    $0xc,%esp
80105240:	53                   	push   %ebx
80105241:	e8 ba ff ff ff       	call   80105200 <holding>
80105246:	83 c4 10             	add    $0x10,%esp
80105249:	85 c0                	test   %eax,%eax
8010524b:	0f 85 83 00 00 00    	jne    801052d4 <acquire+0xa4>
80105251:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105253:	ba 01 00 00 00       	mov    $0x1,%edx
80105258:	eb 09                	jmp    80105263 <acquire+0x33>
8010525a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105260:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105263:	89 d0                	mov    %edx,%eax
80105265:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105268:	85 c0                	test   %eax,%eax
8010526a:	75 f4                	jne    80105260 <acquire+0x30>
  __sync_synchronize();
8010526c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105271:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105274:	e8 b7 ef ff ff       	call   80104230 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105279:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010527c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010527f:	89 e8                	mov    %ebp,%eax
80105281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105288:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010528e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105294:	77 1a                	ja     801052b0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105296:	8b 48 04             	mov    0x4(%eax),%ecx
80105299:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010529c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010529f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801052a1:	83 fe 0a             	cmp    $0xa,%esi
801052a4:	75 e2                	jne    80105288 <acquire+0x58>
}
801052a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052a9:	5b                   	pop    %ebx
801052aa:	5e                   	pop    %esi
801052ab:	5d                   	pop    %ebp
801052ac:	c3                   	ret    
801052ad:	8d 76 00             	lea    0x0(%esi),%esi
801052b0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801052b3:	83 c2 28             	add    $0x28,%edx
801052b6:	8d 76 00             	lea    0x0(%esi),%esi
801052b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801052c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801052c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801052c9:	39 d0                	cmp    %edx,%eax
801052cb:	75 f3                	jne    801052c0 <acquire+0x90>
}
801052cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052d0:	5b                   	pop    %ebx
801052d1:	5e                   	pop    %esi
801052d2:	5d                   	pop    %ebp
801052d3:	c3                   	ret    
    panic("acquire");
801052d4:	83 ec 0c             	sub    $0xc,%esp
801052d7:	68 1d 97 10 80       	push   $0x8010971d
801052dc:	e8 af b0 ff ff       	call   80100390 <panic>
801052e1:	eb 0d                	jmp    801052f0 <release>
801052e3:	90                   	nop
801052e4:	90                   	nop
801052e5:	90                   	nop
801052e6:	90                   	nop
801052e7:	90                   	nop
801052e8:	90                   	nop
801052e9:	90                   	nop
801052ea:	90                   	nop
801052eb:	90                   	nop
801052ec:	90                   	nop
801052ed:	90                   	nop
801052ee:	90                   	nop
801052ef:	90                   	nop

801052f0 <release>:
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	53                   	push   %ebx
801052f4:	83 ec 10             	sub    $0x10,%esp
801052f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801052fa:	53                   	push   %ebx
801052fb:	e8 00 ff ff ff       	call   80105200 <holding>
80105300:	83 c4 10             	add    $0x10,%esp
80105303:	85 c0                	test   %eax,%eax
80105305:	74 22                	je     80105329 <release+0x39>
  lk->pcs[0] = 0;
80105307:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010530e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105315:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010531a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105323:	c9                   	leave  
  popcli();
80105324:	e9 77 fe ff ff       	jmp    801051a0 <popcli>
    panic("release");
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	68 25 97 10 80       	push   $0x80109725
80105331:	e8 5a b0 ff ff       	call   80100390 <panic>
80105336:	66 90                	xchg   %ax,%ax
80105338:	66 90                	xchg   %ax,%ax
8010533a:	66 90                	xchg   %ax,%ax
8010533c:	66 90                	xchg   %ax,%ax
8010533e:	66 90                	xchg   %ax,%ax

80105340 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	57                   	push   %edi
80105344:	53                   	push   %ebx
80105345:	8b 55 08             	mov    0x8(%ebp),%edx
80105348:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010534b:	f6 c2 03             	test   $0x3,%dl
8010534e:	75 05                	jne    80105355 <memset+0x15>
80105350:	f6 c1 03             	test   $0x3,%cl
80105353:	74 13                	je     80105368 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105355:	89 d7                	mov    %edx,%edi
80105357:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535a:	fc                   	cld    
8010535b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010535d:	5b                   	pop    %ebx
8010535e:	89 d0                	mov    %edx,%eax
80105360:	5f                   	pop    %edi
80105361:	5d                   	pop    %ebp
80105362:	c3                   	ret    
80105363:	90                   	nop
80105364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105368:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010536c:	c1 e9 02             	shr    $0x2,%ecx
8010536f:	89 f8                	mov    %edi,%eax
80105371:	89 fb                	mov    %edi,%ebx
80105373:	c1 e0 18             	shl    $0x18,%eax
80105376:	c1 e3 10             	shl    $0x10,%ebx
80105379:	09 d8                	or     %ebx,%eax
8010537b:	09 f8                	or     %edi,%eax
8010537d:	c1 e7 08             	shl    $0x8,%edi
80105380:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105382:	89 d7                	mov    %edx,%edi
80105384:	fc                   	cld    
80105385:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105387:	5b                   	pop    %ebx
80105388:	89 d0                	mov    %edx,%eax
8010538a:	5f                   	pop    %edi
8010538b:	5d                   	pop    %ebp
8010538c:	c3                   	ret    
8010538d:	8d 76 00             	lea    0x0(%esi),%esi

80105390 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
80105396:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105399:	8b 75 08             	mov    0x8(%ebp),%esi
8010539c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010539f:	85 db                	test   %ebx,%ebx
801053a1:	74 29                	je     801053cc <memcmp+0x3c>
    if(*s1 != *s2)
801053a3:	0f b6 16             	movzbl (%esi),%edx
801053a6:	0f b6 0f             	movzbl (%edi),%ecx
801053a9:	38 d1                	cmp    %dl,%cl
801053ab:	75 2b                	jne    801053d8 <memcmp+0x48>
801053ad:	b8 01 00 00 00       	mov    $0x1,%eax
801053b2:	eb 14                	jmp    801053c8 <memcmp+0x38>
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053b8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801053bc:	83 c0 01             	add    $0x1,%eax
801053bf:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801053c4:	38 ca                	cmp    %cl,%dl
801053c6:	75 10                	jne    801053d8 <memcmp+0x48>
  while(n-- > 0){
801053c8:	39 d8                	cmp    %ebx,%eax
801053ca:	75 ec                	jne    801053b8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801053cc:	5b                   	pop    %ebx
  return 0;
801053cd:	31 c0                	xor    %eax,%eax
}
801053cf:	5e                   	pop    %esi
801053d0:	5f                   	pop    %edi
801053d1:	5d                   	pop    %ebp
801053d2:	c3                   	ret    
801053d3:	90                   	nop
801053d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801053d8:	0f b6 c2             	movzbl %dl,%eax
}
801053db:	5b                   	pop    %ebx
      return *s1 - *s2;
801053dc:	29 c8                	sub    %ecx,%eax
}
801053de:	5e                   	pop    %esi
801053df:	5f                   	pop    %edi
801053e0:	5d                   	pop    %ebp
801053e1:	c3                   	ret    
801053e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	56                   	push   %esi
801053f4:	53                   	push   %ebx
801053f5:	8b 45 08             	mov    0x8(%ebp),%eax
801053f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801053fb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801053fe:	39 c3                	cmp    %eax,%ebx
80105400:	73 26                	jae    80105428 <memmove+0x38>
80105402:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105405:	39 c8                	cmp    %ecx,%eax
80105407:	73 1f                	jae    80105428 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105409:	85 f6                	test   %esi,%esi
8010540b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010540e:	74 0f                	je     8010541f <memmove+0x2f>
      *--d = *--s;
80105410:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105414:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105417:	83 ea 01             	sub    $0x1,%edx
8010541a:	83 fa ff             	cmp    $0xffffffff,%edx
8010541d:	75 f1                	jne    80105410 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010541f:	5b                   	pop    %ebx
80105420:	5e                   	pop    %esi
80105421:	5d                   	pop    %ebp
80105422:	c3                   	ret    
80105423:	90                   	nop
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105428:	31 d2                	xor    %edx,%edx
8010542a:	85 f6                	test   %esi,%esi
8010542c:	74 f1                	je     8010541f <memmove+0x2f>
8010542e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105430:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105434:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105437:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010543a:	39 d6                	cmp    %edx,%esi
8010543c:	75 f2                	jne    80105430 <memmove+0x40>
}
8010543e:	5b                   	pop    %ebx
8010543f:	5e                   	pop    %esi
80105440:	5d                   	pop    %ebp
80105441:	c3                   	ret    
80105442:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105453:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105454:	eb 9a                	jmp    801053f0 <memmove>
80105456:	8d 76 00             	lea    0x0(%esi),%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
80105464:	56                   	push   %esi
80105465:	8b 7d 10             	mov    0x10(%ebp),%edi
80105468:	53                   	push   %ebx
80105469:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010546c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010546f:	85 ff                	test   %edi,%edi
80105471:	74 2f                	je     801054a2 <strncmp+0x42>
80105473:	0f b6 01             	movzbl (%ecx),%eax
80105476:	0f b6 1e             	movzbl (%esi),%ebx
80105479:	84 c0                	test   %al,%al
8010547b:	74 37                	je     801054b4 <strncmp+0x54>
8010547d:	38 c3                	cmp    %al,%bl
8010547f:	75 33                	jne    801054b4 <strncmp+0x54>
80105481:	01 f7                	add    %esi,%edi
80105483:	eb 13                	jmp    80105498 <strncmp+0x38>
80105485:	8d 76 00             	lea    0x0(%esi),%esi
80105488:	0f b6 01             	movzbl (%ecx),%eax
8010548b:	84 c0                	test   %al,%al
8010548d:	74 21                	je     801054b0 <strncmp+0x50>
8010548f:	0f b6 1a             	movzbl (%edx),%ebx
80105492:	89 d6                	mov    %edx,%esi
80105494:	38 d8                	cmp    %bl,%al
80105496:	75 1c                	jne    801054b4 <strncmp+0x54>
    n--, p++, q++;
80105498:	8d 56 01             	lea    0x1(%esi),%edx
8010549b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010549e:	39 fa                	cmp    %edi,%edx
801054a0:	75 e6                	jne    80105488 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801054a2:	5b                   	pop    %ebx
    return 0;
801054a3:	31 c0                	xor    %eax,%eax
}
801054a5:	5e                   	pop    %esi
801054a6:	5f                   	pop    %edi
801054a7:	5d                   	pop    %ebp
801054a8:	c3                   	ret    
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054b0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801054b4:	29 d8                	sub    %ebx,%eax
}
801054b6:	5b                   	pop    %ebx
801054b7:	5e                   	pop    %esi
801054b8:	5f                   	pop    %edi
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    
801054bb:	90                   	nop
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
801054c5:	8b 45 08             	mov    0x8(%ebp),%eax
801054c8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801054cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801054ce:	89 c2                	mov    %eax,%edx
801054d0:	eb 19                	jmp    801054eb <strncpy+0x2b>
801054d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054d8:	83 c3 01             	add    $0x1,%ebx
801054db:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801054df:	83 c2 01             	add    $0x1,%edx
801054e2:	84 c9                	test   %cl,%cl
801054e4:	88 4a ff             	mov    %cl,-0x1(%edx)
801054e7:	74 09                	je     801054f2 <strncpy+0x32>
801054e9:	89 f1                	mov    %esi,%ecx
801054eb:	85 c9                	test   %ecx,%ecx
801054ed:	8d 71 ff             	lea    -0x1(%ecx),%esi
801054f0:	7f e6                	jg     801054d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801054f2:	31 c9                	xor    %ecx,%ecx
801054f4:	85 f6                	test   %esi,%esi
801054f6:	7e 17                	jle    8010550f <strncpy+0x4f>
801054f8:	90                   	nop
801054f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105500:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105504:	89 f3                	mov    %esi,%ebx
80105506:	83 c1 01             	add    $0x1,%ecx
80105509:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010550b:	85 db                	test   %ebx,%ebx
8010550d:	7f f1                	jg     80105500 <strncpy+0x40>
  return os;
}
8010550f:	5b                   	pop    %ebx
80105510:	5e                   	pop    %esi
80105511:	5d                   	pop    %ebp
80105512:	c3                   	ret    
80105513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
80105525:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105528:	8b 45 08             	mov    0x8(%ebp),%eax
8010552b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010552e:	85 c9                	test   %ecx,%ecx
80105530:	7e 26                	jle    80105558 <safestrcpy+0x38>
80105532:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105536:	89 c1                	mov    %eax,%ecx
80105538:	eb 17                	jmp    80105551 <safestrcpy+0x31>
8010553a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105540:	83 c2 01             	add    $0x1,%edx
80105543:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105547:	83 c1 01             	add    $0x1,%ecx
8010554a:	84 db                	test   %bl,%bl
8010554c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010554f:	74 04                	je     80105555 <safestrcpy+0x35>
80105551:	39 f2                	cmp    %esi,%edx
80105553:	75 eb                	jne    80105540 <safestrcpy+0x20>
    ;
  *s = 0;
80105555:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105558:	5b                   	pop    %ebx
80105559:	5e                   	pop    %esi
8010555a:	5d                   	pop    %ebp
8010555b:	c3                   	ret    
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <strlen>:

int
strlen(const char *s)
{
80105560:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105561:	31 c0                	xor    %eax,%eax
{
80105563:	89 e5                	mov    %esp,%ebp
80105565:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105568:	80 3a 00             	cmpb   $0x0,(%edx)
8010556b:	74 0c                	je     80105579 <strlen+0x19>
8010556d:	8d 76 00             	lea    0x0(%esi),%esi
80105570:	83 c0 01             	add    $0x1,%eax
80105573:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105577:	75 f7                	jne    80105570 <strlen+0x10>
    ;
  return n;
}
80105579:	5d                   	pop    %ebp
8010557a:	c3                   	ret    

8010557b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010557b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010557f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105583:	55                   	push   %ebp
  pushl %ebx
80105584:	53                   	push   %ebx
  pushl %esi
80105585:	56                   	push   %esi
  pushl %edi
80105586:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105587:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105589:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010558b:	5f                   	pop    %edi
  popl %esi
8010558c:	5e                   	pop    %esi
  popl %ebx
8010558d:	5b                   	pop    %ebx
  popl %ebp
8010558e:	5d                   	pop    %ebp
  ret
8010558f:	c3                   	ret    

80105590 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	53                   	push   %ebx
80105594:	83 ec 04             	sub    $0x4,%esp
80105597:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010559a:	e8 31 ed ff ff       	call   801042d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010559f:	8b 00                	mov    (%eax),%eax
801055a1:	39 d8                	cmp    %ebx,%eax
801055a3:	76 1b                	jbe    801055c0 <fetchint+0x30>
801055a5:	8d 53 04             	lea    0x4(%ebx),%edx
801055a8:	39 d0                	cmp    %edx,%eax
801055aa:	72 14                	jb     801055c0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801055ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801055af:	8b 13                	mov    (%ebx),%edx
801055b1:	89 10                	mov    %edx,(%eax)
  return 0;
801055b3:	31 c0                	xor    %eax,%eax
}
801055b5:	83 c4 04             	add    $0x4,%esp
801055b8:	5b                   	pop    %ebx
801055b9:	5d                   	pop    %ebp
801055ba:	c3                   	ret    
801055bb:	90                   	nop
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c5:	eb ee                	jmp    801055b5 <fetchint+0x25>
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	53                   	push   %ebx
801055d4:	83 ec 04             	sub    $0x4,%esp
801055d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801055da:	e8 f1 ec ff ff       	call   801042d0 <myproc>

  if(addr >= curproc->sz)
801055df:	39 18                	cmp    %ebx,(%eax)
801055e1:	76 29                	jbe    8010560c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801055e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055e6:	89 da                	mov    %ebx,%edx
801055e8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801055ea:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801055ec:	39 c3                	cmp    %eax,%ebx
801055ee:	73 1c                	jae    8010560c <fetchstr+0x3c>
    if(*s == 0)
801055f0:	80 3b 00             	cmpb   $0x0,(%ebx)
801055f3:	75 10                	jne    80105605 <fetchstr+0x35>
801055f5:	eb 39                	jmp    80105630 <fetchstr+0x60>
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105600:	80 3a 00             	cmpb   $0x0,(%edx)
80105603:	74 1b                	je     80105620 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105605:	83 c2 01             	add    $0x1,%edx
80105608:	39 d0                	cmp    %edx,%eax
8010560a:	77 f4                	ja     80105600 <fetchstr+0x30>
    return -1;
8010560c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105611:	83 c4 04             	add    $0x4,%esp
80105614:	5b                   	pop    %ebx
80105615:	5d                   	pop    %ebp
80105616:	c3                   	ret    
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105620:	83 c4 04             	add    $0x4,%esp
80105623:	89 d0                	mov    %edx,%eax
80105625:	29 d8                	sub    %ebx,%eax
80105627:	5b                   	pop    %ebx
80105628:	5d                   	pop    %ebp
80105629:	c3                   	ret    
8010562a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105630:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105632:	eb dd                	jmp    80105611 <fetchstr+0x41>
80105634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010563a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105640 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	56                   	push   %esi
80105644:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105645:	e8 86 ec ff ff       	call   801042d0 <myproc>
8010564a:	8b 40 18             	mov    0x18(%eax),%eax
8010564d:	8b 55 08             	mov    0x8(%ebp),%edx
80105650:	8b 40 44             	mov    0x44(%eax),%eax
80105653:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105656:	e8 75 ec ff ff       	call   801042d0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010565b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010565d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105660:	39 c6                	cmp    %eax,%esi
80105662:	73 1c                	jae    80105680 <argint+0x40>
80105664:	8d 53 08             	lea    0x8(%ebx),%edx
80105667:	39 d0                	cmp    %edx,%eax
80105669:	72 15                	jb     80105680 <argint+0x40>
  *ip = *(int*)(addr);
8010566b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010566e:	8b 53 04             	mov    0x4(%ebx),%edx
80105671:	89 10                	mov    %edx,(%eax)
  return 0;
80105673:	31 c0                	xor    %eax,%eax
}
80105675:	5b                   	pop    %ebx
80105676:	5e                   	pop    %esi
80105677:	5d                   	pop    %ebp
80105678:	c3                   	ret    
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105685:	eb ee                	jmp    80105675 <argint+0x35>
80105687:	89 f6                	mov    %esi,%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105690 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	56                   	push   %esi
80105694:	53                   	push   %ebx
80105695:	83 ec 10             	sub    $0x10,%esp
80105698:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010569b:	e8 30 ec ff ff       	call   801042d0 <myproc>
801056a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801056a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056a5:	83 ec 08             	sub    $0x8,%esp
801056a8:	50                   	push   %eax
801056a9:	ff 75 08             	pushl  0x8(%ebp)
801056ac:	e8 8f ff ff ff       	call   80105640 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801056b1:	83 c4 10             	add    $0x10,%esp
801056b4:	85 c0                	test   %eax,%eax
801056b6:	78 28                	js     801056e0 <argptr+0x50>
801056b8:	85 db                	test   %ebx,%ebx
801056ba:	78 24                	js     801056e0 <argptr+0x50>
801056bc:	8b 16                	mov    (%esi),%edx
801056be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c1:	39 c2                	cmp    %eax,%edx
801056c3:	76 1b                	jbe    801056e0 <argptr+0x50>
801056c5:	01 c3                	add    %eax,%ebx
801056c7:	39 da                	cmp    %ebx,%edx
801056c9:	72 15                	jb     801056e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801056cb:	8b 55 0c             	mov    0xc(%ebp),%edx
801056ce:	89 02                	mov    %eax,(%edx)
  return 0;
801056d0:	31 c0                	xor    %eax,%eax
}
801056d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056d5:	5b                   	pop    %ebx
801056d6:	5e                   	pop    %esi
801056d7:	5d                   	pop    %ebp
801056d8:	c3                   	ret    
801056d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e5:	eb eb                	jmp    801056d2 <argptr+0x42>
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056f9:	50                   	push   %eax
801056fa:	ff 75 08             	pushl  0x8(%ebp)
801056fd:	e8 3e ff ff ff       	call   80105640 <argint>
80105702:	83 c4 10             	add    $0x10,%esp
80105705:	85 c0                	test   %eax,%eax
80105707:	78 17                	js     80105720 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105709:	83 ec 08             	sub    $0x8,%esp
8010570c:	ff 75 0c             	pushl  0xc(%ebp)
8010570f:	ff 75 f4             	pushl  -0xc(%ebp)
80105712:	e8 b9 fe ff ff       	call   801055d0 <fetchstr>
80105717:	83 c4 10             	add    $0x10,%esp
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105720:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105725:	c9                   	leave  
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	53                   	push   %ebx
80105734:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105737:	e8 94 eb ff ff       	call   801042d0 <myproc>
8010573c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010573e:	8b 40 18             	mov    0x18(%eax),%eax
80105741:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105744:	8d 50 ff             	lea    -0x1(%eax),%edx
80105747:	83 fa 16             	cmp    $0x16,%edx
8010574a:	77 1c                	ja     80105768 <syscall+0x38>
8010574c:	8b 14 85 60 97 10 80 	mov    -0x7fef68a0(,%eax,4),%edx
80105753:	85 d2                	test   %edx,%edx
80105755:	74 11                	je     80105768 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105757:	ff d2                	call   *%edx
80105759:	8b 53 18             	mov    0x18(%ebx),%edx
8010575c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010575f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105762:	c9                   	leave  
80105763:	c3                   	ret    
80105764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105768:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105769:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010576c:	50                   	push   %eax
8010576d:	ff 73 10             	pushl  0x10(%ebx)
80105770:	68 2d 97 10 80       	push   $0x8010972d
80105775:	e8 e6 ae ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010577a:	8b 43 18             	mov    0x18(%ebx),%eax
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105787:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	66 90                	xchg   %ax,%ax
8010578e:	66 90                	xchg   %ax,%ax

80105790 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	56                   	push   %esi
80105794:	53                   	push   %ebx
80105795:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105797:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010579a:	89 d6                	mov    %edx,%esi
8010579c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010579f:	50                   	push   %eax
801057a0:	6a 00                	push   $0x0
801057a2:	e8 99 fe ff ff       	call   80105640 <argint>
801057a7:	83 c4 10             	add    $0x10,%esp
801057aa:	85 c0                	test   %eax,%eax
801057ac:	78 2a                	js     801057d8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057ae:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057b2:	77 24                	ja     801057d8 <argfd.constprop.0+0x48>
801057b4:	e8 17 eb ff ff       	call   801042d0 <myproc>
801057b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057bc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801057c0:	85 c0                	test   %eax,%eax
801057c2:	74 14                	je     801057d8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801057c4:	85 db                	test   %ebx,%ebx
801057c6:	74 02                	je     801057ca <argfd.constprop.0+0x3a>
    *pfd = fd;
801057c8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801057ca:	89 06                	mov    %eax,(%esi)
  return 0;
801057cc:	31 c0                	xor    %eax,%eax
}
801057ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057d1:	5b                   	pop    %ebx
801057d2:	5e                   	pop    %esi
801057d3:	5d                   	pop    %ebp
801057d4:	c3                   	ret    
801057d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057dd:	eb ef                	jmp    801057ce <argfd.constprop.0+0x3e>
801057df:	90                   	nop

801057e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801057e0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801057e1:	31 c0                	xor    %eax,%eax
{
801057e3:	89 e5                	mov    %esp,%ebp
801057e5:	56                   	push   %esi
801057e6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801057e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801057ea:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801057ed:	e8 9e ff ff ff       	call   80105790 <argfd.constprop.0>
801057f2:	85 c0                	test   %eax,%eax
801057f4:	78 42                	js     80105838 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
801057f6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057f9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057fb:	e8 d0 ea ff ff       	call   801042d0 <myproc>
80105800:	eb 0e                	jmp    80105810 <sys_dup+0x30>
80105802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105808:	83 c3 01             	add    $0x1,%ebx
8010580b:	83 fb 10             	cmp    $0x10,%ebx
8010580e:	74 28                	je     80105838 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105810:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105814:	85 d2                	test   %edx,%edx
80105816:	75 f0                	jne    80105808 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105818:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010581c:	83 ec 0c             	sub    $0xc,%esp
8010581f:	ff 75 f4             	pushl  -0xc(%ebp)
80105822:	e8 89 b9 ff ff       	call   801011b0 <filedup>
  return fd;
80105827:	83 c4 10             	add    $0x10,%esp
}
8010582a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010582d:	89 d8                	mov    %ebx,%eax
8010582f:	5b                   	pop    %ebx
80105830:	5e                   	pop    %esi
80105831:	5d                   	pop    %ebp
80105832:	c3                   	ret    
80105833:	90                   	nop
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105838:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010583b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105840:	89 d8                	mov    %ebx,%eax
80105842:	5b                   	pop    %ebx
80105843:	5e                   	pop    %esi
80105844:	5d                   	pop    %ebp
80105845:	c3                   	ret    
80105846:	8d 76 00             	lea    0x0(%esi),%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105850 <sys_read>:

int
sys_read(void)
{
80105850:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105851:	31 c0                	xor    %eax,%eax
{
80105853:	89 e5                	mov    %esp,%ebp
80105855:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105858:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010585b:	e8 30 ff ff ff       	call   80105790 <argfd.constprop.0>
80105860:	85 c0                	test   %eax,%eax
80105862:	78 4c                	js     801058b0 <sys_read+0x60>
80105864:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105867:	83 ec 08             	sub    $0x8,%esp
8010586a:	50                   	push   %eax
8010586b:	6a 02                	push   $0x2
8010586d:	e8 ce fd ff ff       	call   80105640 <argint>
80105872:	83 c4 10             	add    $0x10,%esp
80105875:	85 c0                	test   %eax,%eax
80105877:	78 37                	js     801058b0 <sys_read+0x60>
80105879:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010587c:	83 ec 04             	sub    $0x4,%esp
8010587f:	ff 75 f0             	pushl  -0x10(%ebp)
80105882:	50                   	push   %eax
80105883:	6a 01                	push   $0x1
80105885:	e8 06 fe ff ff       	call   80105690 <argptr>
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	85 c0                	test   %eax,%eax
8010588f:	78 1f                	js     801058b0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105891:	83 ec 04             	sub    $0x4,%esp
80105894:	ff 75 f0             	pushl  -0x10(%ebp)
80105897:	ff 75 f4             	pushl  -0xc(%ebp)
8010589a:	ff 75 ec             	pushl  -0x14(%ebp)
8010589d:	e8 7e ba ff ff       	call   80101320 <fileread>
801058a2:	83 c4 10             	add    $0x10,%esp
}
801058a5:	c9                   	leave  
801058a6:	c3                   	ret    
801058a7:	89 f6                	mov    %esi,%esi
801058a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_write>:

int
sys_write(void)
{
801058c0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058c1:	31 c0                	xor    %eax,%eax
{
801058c3:	89 e5                	mov    %esp,%ebp
801058c5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058c8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801058cb:	e8 c0 fe ff ff       	call   80105790 <argfd.constprop.0>
801058d0:	85 c0                	test   %eax,%eax
801058d2:	78 4c                	js     80105920 <sys_write+0x60>
801058d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058d7:	83 ec 08             	sub    $0x8,%esp
801058da:	50                   	push   %eax
801058db:	6a 02                	push   $0x2
801058dd:	e8 5e fd ff ff       	call   80105640 <argint>
801058e2:	83 c4 10             	add    $0x10,%esp
801058e5:	85 c0                	test   %eax,%eax
801058e7:	78 37                	js     80105920 <sys_write+0x60>
801058e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ec:	83 ec 04             	sub    $0x4,%esp
801058ef:	ff 75 f0             	pushl  -0x10(%ebp)
801058f2:	50                   	push   %eax
801058f3:	6a 01                	push   $0x1
801058f5:	e8 96 fd ff ff       	call   80105690 <argptr>
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	85 c0                	test   %eax,%eax
801058ff:	78 1f                	js     80105920 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105901:	83 ec 04             	sub    $0x4,%esp
80105904:	ff 75 f0             	pushl  -0x10(%ebp)
80105907:	ff 75 f4             	pushl  -0xc(%ebp)
8010590a:	ff 75 ec             	pushl  -0x14(%ebp)
8010590d:	e8 9e ba ff ff       	call   801013b0 <filewrite>
80105912:	83 c4 10             	add    $0x10,%esp
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105930 <sys_close>:

int
sys_close(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105936:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105939:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010593c:	e8 4f fe ff ff       	call   80105790 <argfd.constprop.0>
80105941:	85 c0                	test   %eax,%eax
80105943:	78 2b                	js     80105970 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105945:	e8 86 e9 ff ff       	call   801042d0 <myproc>
8010594a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010594d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105950:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105957:	00 
  fileclose(f);
80105958:	ff 75 f4             	pushl  -0xc(%ebp)
8010595b:	e8 a0 b8 ff ff       	call   80101200 <fileclose>
  return 0;
80105960:	83 c4 10             	add    $0x10,%esp
80105963:	31 c0                	xor    %eax,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105970:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105975:	c9                   	leave  
80105976:	c3                   	ret    
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105980 <sys_fstat>:

int
sys_fstat(void)
{
80105980:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105981:	31 c0                	xor    %eax,%eax
{
80105983:	89 e5                	mov    %esp,%ebp
80105985:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105988:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010598b:	e8 00 fe ff ff       	call   80105790 <argfd.constprop.0>
80105990:	85 c0                	test   %eax,%eax
80105992:	78 2c                	js     801059c0 <sys_fstat+0x40>
80105994:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105997:	83 ec 04             	sub    $0x4,%esp
8010599a:	6a 14                	push   $0x14
8010599c:	50                   	push   %eax
8010599d:	6a 01                	push   $0x1
8010599f:	e8 ec fc ff ff       	call   80105690 <argptr>
801059a4:	83 c4 10             	add    $0x10,%esp
801059a7:	85 c0                	test   %eax,%eax
801059a9:	78 15                	js     801059c0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801059ab:	83 ec 08             	sub    $0x8,%esp
801059ae:	ff 75 f4             	pushl  -0xc(%ebp)
801059b1:	ff 75 f0             	pushl  -0x10(%ebp)
801059b4:	e8 17 b9 ff ff       	call   801012d0 <filestat>
801059b9:	83 c4 10             	add    $0x10,%esp
}
801059bc:	c9                   	leave  
801059bd:	c3                   	ret    
801059be:	66 90                	xchg   %ax,%ax
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	57                   	push   %edi
801059d4:	56                   	push   %esi
801059d5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059d6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059d9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059dc:	50                   	push   %eax
801059dd:	6a 00                	push   $0x0
801059df:	e8 0c fd ff ff       	call   801056f0 <argstr>
801059e4:	83 c4 10             	add    $0x10,%esp
801059e7:	85 c0                	test   %eax,%eax
801059e9:	0f 88 fb 00 00 00    	js     80105aea <sys_link+0x11a>
801059ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
801059f2:	83 ec 08             	sub    $0x8,%esp
801059f5:	50                   	push   %eax
801059f6:	6a 01                	push   $0x1
801059f8:	e8 f3 fc ff ff       	call   801056f0 <argstr>
801059fd:	83 c4 10             	add    $0x10,%esp
80105a00:	85 c0                	test   %eax,%eax
80105a02:	0f 88 e2 00 00 00    	js     80105aea <sys_link+0x11a>
    return -1;

  begin_op();
80105a08:	e8 53 db ff ff       	call   80103560 <begin_op>
  if((ip = namei(old)) == 0){
80105a0d:	83 ec 0c             	sub    $0xc,%esp
80105a10:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a13:	e8 88 c8 ff ff       	call   801022a0 <namei>
80105a18:	83 c4 10             	add    $0x10,%esp
80105a1b:	85 c0                	test   %eax,%eax
80105a1d:	89 c3                	mov    %eax,%ebx
80105a1f:	0f 84 ea 00 00 00    	je     80105b0f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105a25:	83 ec 0c             	sub    $0xc,%esp
80105a28:	50                   	push   %eax
80105a29:	e8 12 c0 ff ff       	call   80101a40 <ilock>
  if(ip->type == T_DIR){
80105a2e:	83 c4 10             	add    $0x10,%esp
80105a31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a36:	0f 84 bb 00 00 00    	je     80105af7 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105a3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a41:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a44:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a47:	53                   	push   %ebx
80105a48:	e8 43 bf ff ff       	call   80101990 <iupdate>
  iunlock(ip);
80105a4d:	89 1c 24             	mov    %ebx,(%esp)
80105a50:	e8 cb c0 ff ff       	call   80101b20 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a55:	58                   	pop    %eax
80105a56:	5a                   	pop    %edx
80105a57:	57                   	push   %edi
80105a58:	ff 75 d0             	pushl  -0x30(%ebp)
80105a5b:	e8 60 c8 ff ff       	call   801022c0 <nameiparent>
80105a60:	83 c4 10             	add    $0x10,%esp
80105a63:	85 c0                	test   %eax,%eax
80105a65:	89 c6                	mov    %eax,%esi
80105a67:	74 5b                	je     80105ac4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a69:	83 ec 0c             	sub    $0xc,%esp
80105a6c:	50                   	push   %eax
80105a6d:	e8 ce bf ff ff       	call   80101a40 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a72:	83 c4 10             	add    $0x10,%esp
80105a75:	8b 03                	mov    (%ebx),%eax
80105a77:	39 06                	cmp    %eax,(%esi)
80105a79:	75 3d                	jne    80105ab8 <sys_link+0xe8>
80105a7b:	83 ec 04             	sub    $0x4,%esp
80105a7e:	ff 73 04             	pushl  0x4(%ebx)
80105a81:	57                   	push   %edi
80105a82:	56                   	push   %esi
80105a83:	e8 58 c7 ff ff       	call   801021e0 <dirlink>
80105a88:	83 c4 10             	add    $0x10,%esp
80105a8b:	85 c0                	test   %eax,%eax
80105a8d:	78 29                	js     80105ab8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105a8f:	83 ec 0c             	sub    $0xc,%esp
80105a92:	56                   	push   %esi
80105a93:	e8 38 c2 ff ff       	call   80101cd0 <iunlockput>
  iput(ip);
80105a98:	89 1c 24             	mov    %ebx,(%esp)
80105a9b:	e8 d0 c0 ff ff       	call   80101b70 <iput>

  end_op();
80105aa0:	e8 2b db ff ff       	call   801035d0 <end_op>

  return 0;
80105aa5:	83 c4 10             	add    $0x10,%esp
80105aa8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105aaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105aad:	5b                   	pop    %ebx
80105aae:	5e                   	pop    %esi
80105aaf:	5f                   	pop    %edi
80105ab0:	5d                   	pop    %ebp
80105ab1:	c3                   	ret    
80105ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105ab8:	83 ec 0c             	sub    $0xc,%esp
80105abb:	56                   	push   %esi
80105abc:	e8 0f c2 ff ff       	call   80101cd0 <iunlockput>
    goto bad;
80105ac1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ac4:	83 ec 0c             	sub    $0xc,%esp
80105ac7:	53                   	push   %ebx
80105ac8:	e8 73 bf ff ff       	call   80101a40 <ilock>
  ip->nlink--;
80105acd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ad2:	89 1c 24             	mov    %ebx,(%esp)
80105ad5:	e8 b6 be ff ff       	call   80101990 <iupdate>
  iunlockput(ip);
80105ada:	89 1c 24             	mov    %ebx,(%esp)
80105add:	e8 ee c1 ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105ae2:	e8 e9 da ff ff       	call   801035d0 <end_op>
  return -1;
80105ae7:	83 c4 10             	add    $0x10,%esp
}
80105aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af2:	5b                   	pop    %ebx
80105af3:	5e                   	pop    %esi
80105af4:	5f                   	pop    %edi
80105af5:	5d                   	pop    %ebp
80105af6:	c3                   	ret    
    iunlockput(ip);
80105af7:	83 ec 0c             	sub    $0xc,%esp
80105afa:	53                   	push   %ebx
80105afb:	e8 d0 c1 ff ff       	call   80101cd0 <iunlockput>
    end_op();
80105b00:	e8 cb da ff ff       	call   801035d0 <end_op>
    return -1;
80105b05:	83 c4 10             	add    $0x10,%esp
80105b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b0d:	eb 9b                	jmp    80105aaa <sys_link+0xda>
    end_op();
80105b0f:	e8 bc da ff ff       	call   801035d0 <end_op>
    return -1;
80105b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b19:	eb 8f                	jmp    80105aaa <sys_link+0xda>
80105b1b:	90                   	nop
80105b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b20 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	57                   	push   %edi
80105b24:	56                   	push   %esi
80105b25:	53                   	push   %ebx
80105b26:	83 ec 1c             	sub    $0x1c,%esp
80105b29:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b2c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105b30:	76 3e                	jbe    80105b70 <isdirempty+0x50>
80105b32:	bb 20 00 00 00       	mov    $0x20,%ebx
80105b37:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b3a:	eb 0c                	jmp    80105b48 <isdirempty+0x28>
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b40:	83 c3 10             	add    $0x10,%ebx
80105b43:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105b46:	73 28                	jae    80105b70 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b48:	6a 10                	push   $0x10
80105b4a:	53                   	push   %ebx
80105b4b:	57                   	push   %edi
80105b4c:	56                   	push   %esi
80105b4d:	e8 ce c1 ff ff       	call   80101d20 <readi>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	83 f8 10             	cmp    $0x10,%eax
80105b58:	75 23                	jne    80105b7d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105b5a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b5f:	74 df                	je     80105b40 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105b64:	31 c0                	xor    %eax,%eax
}
80105b66:	5b                   	pop    %ebx
80105b67:	5e                   	pop    %esi
80105b68:	5f                   	pop    %edi
80105b69:	5d                   	pop    %ebp
80105b6a:	c3                   	ret    
80105b6b:	90                   	nop
80105b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105b73:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b78:	5b                   	pop    %ebx
80105b79:	5e                   	pop    %esi
80105b7a:	5f                   	pop    %edi
80105b7b:	5d                   	pop    %ebp
80105b7c:	c3                   	ret    
      panic("isdirempty: readi");
80105b7d:	83 ec 0c             	sub    $0xc,%esp
80105b80:	68 c0 97 10 80       	push   $0x801097c0
80105b85:	e8 06 a8 ff ff       	call   80100390 <panic>
80105b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b90 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	57                   	push   %edi
80105b94:	56                   	push   %esi
80105b95:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b96:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b99:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b9c:	50                   	push   %eax
80105b9d:	6a 00                	push   $0x0
80105b9f:	e8 4c fb ff ff       	call   801056f0 <argstr>
80105ba4:	83 c4 10             	add    $0x10,%esp
80105ba7:	85 c0                	test   %eax,%eax
80105ba9:	0f 88 51 01 00 00    	js     80105d00 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105baf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105bb2:	e8 a9 d9 ff ff       	call   80103560 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105bb7:	83 ec 08             	sub    $0x8,%esp
80105bba:	53                   	push   %ebx
80105bbb:	ff 75 c0             	pushl  -0x40(%ebp)
80105bbe:	e8 fd c6 ff ff       	call   801022c0 <nameiparent>
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	89 c6                	mov    %eax,%esi
80105bca:	0f 84 37 01 00 00    	je     80105d07 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105bd0:	83 ec 0c             	sub    $0xc,%esp
80105bd3:	50                   	push   %eax
80105bd4:	e8 67 be ff ff       	call   80101a40 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bd9:	58                   	pop    %eax
80105bda:	5a                   	pop    %edx
80105bdb:	68 b3 90 10 80       	push   $0x801090b3
80105be0:	53                   	push   %ebx
80105be1:	e8 6a c3 ff ff       	call   80101f50 <namecmp>
80105be6:	83 c4 10             	add    $0x10,%esp
80105be9:	85 c0                	test   %eax,%eax
80105beb:	0f 84 d7 00 00 00    	je     80105cc8 <sys_unlink+0x138>
80105bf1:	83 ec 08             	sub    $0x8,%esp
80105bf4:	68 b2 90 10 80       	push   $0x801090b2
80105bf9:	53                   	push   %ebx
80105bfa:	e8 51 c3 ff ff       	call   80101f50 <namecmp>
80105bff:	83 c4 10             	add    $0x10,%esp
80105c02:	85 c0                	test   %eax,%eax
80105c04:	0f 84 be 00 00 00    	je     80105cc8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c0a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c0d:	83 ec 04             	sub    $0x4,%esp
80105c10:	50                   	push   %eax
80105c11:	53                   	push   %ebx
80105c12:	56                   	push   %esi
80105c13:	e8 58 c3 ff ff       	call   80101f70 <dirlookup>
80105c18:	83 c4 10             	add    $0x10,%esp
80105c1b:	85 c0                	test   %eax,%eax
80105c1d:	89 c3                	mov    %eax,%ebx
80105c1f:	0f 84 a3 00 00 00    	je     80105cc8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105c25:	83 ec 0c             	sub    $0xc,%esp
80105c28:	50                   	push   %eax
80105c29:	e8 12 be ff ff       	call   80101a40 <ilock>

  if(ip->nlink < 1)
80105c2e:	83 c4 10             	add    $0x10,%esp
80105c31:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c36:	0f 8e e4 00 00 00    	jle    80105d20 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c3c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c41:	74 65                	je     80105ca8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c43:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c46:	83 ec 04             	sub    $0x4,%esp
80105c49:	6a 10                	push   $0x10
80105c4b:	6a 00                	push   $0x0
80105c4d:	57                   	push   %edi
80105c4e:	e8 ed f6 ff ff       	call   80105340 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c53:	6a 10                	push   $0x10
80105c55:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c58:	57                   	push   %edi
80105c59:	56                   	push   %esi
80105c5a:	e8 c1 c1 ff ff       	call   80101e20 <writei>
80105c5f:	83 c4 20             	add    $0x20,%esp
80105c62:	83 f8 10             	cmp    $0x10,%eax
80105c65:	0f 85 a8 00 00 00    	jne    80105d13 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c6b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c70:	74 6e                	je     80105ce0 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c72:	83 ec 0c             	sub    $0xc,%esp
80105c75:	56                   	push   %esi
80105c76:	e8 55 c0 ff ff       	call   80101cd0 <iunlockput>

  ip->nlink--;
80105c7b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c80:	89 1c 24             	mov    %ebx,(%esp)
80105c83:	e8 08 bd ff ff       	call   80101990 <iupdate>
  iunlockput(ip);
80105c88:	89 1c 24             	mov    %ebx,(%esp)
80105c8b:	e8 40 c0 ff ff       	call   80101cd0 <iunlockput>

  end_op();
80105c90:	e8 3b d9 ff ff       	call   801035d0 <end_op>

  return 0;
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c9d:	5b                   	pop    %ebx
80105c9e:	5e                   	pop    %esi
80105c9f:	5f                   	pop    %edi
80105ca0:	5d                   	pop    %ebp
80105ca1:	c3                   	ret    
80105ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105ca8:	83 ec 0c             	sub    $0xc,%esp
80105cab:	53                   	push   %ebx
80105cac:	e8 6f fe ff ff       	call   80105b20 <isdirempty>
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	75 8b                	jne    80105c43 <sys_unlink+0xb3>
    iunlockput(ip);
80105cb8:	83 ec 0c             	sub    $0xc,%esp
80105cbb:	53                   	push   %ebx
80105cbc:	e8 0f c0 ff ff       	call   80101cd0 <iunlockput>
    goto bad;
80105cc1:	83 c4 10             	add    $0x10,%esp
80105cc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105cc8:	83 ec 0c             	sub    $0xc,%esp
80105ccb:	56                   	push   %esi
80105ccc:	e8 ff bf ff ff       	call   80101cd0 <iunlockput>
  end_op();
80105cd1:	e8 fa d8 ff ff       	call   801035d0 <end_op>
  return -1;
80105cd6:	83 c4 10             	add    $0x10,%esp
80105cd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cde:	eb ba                	jmp    80105c9a <sys_unlink+0x10a>
    dp->nlink--;
80105ce0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105ce5:	83 ec 0c             	sub    $0xc,%esp
80105ce8:	56                   	push   %esi
80105ce9:	e8 a2 bc ff ff       	call   80101990 <iupdate>
80105cee:	83 c4 10             	add    $0x10,%esp
80105cf1:	e9 7c ff ff ff       	jmp    80105c72 <sys_unlink+0xe2>
80105cf6:	8d 76 00             	lea    0x0(%esi),%esi
80105cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105d00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d05:	eb 93                	jmp    80105c9a <sys_unlink+0x10a>
    end_op();
80105d07:	e8 c4 d8 ff ff       	call   801035d0 <end_op>
    return -1;
80105d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d11:	eb 87                	jmp    80105c9a <sys_unlink+0x10a>
    panic("unlink: writei");
80105d13:	83 ec 0c             	sub    $0xc,%esp
80105d16:	68 c7 90 10 80       	push   $0x801090c7
80105d1b:	e8 70 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d20:	83 ec 0c             	sub    $0xc,%esp
80105d23:	68 b5 90 10 80       	push   $0x801090b5
80105d28:	e8 63 a6 ff ff       	call   80100390 <panic>
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi

80105d30 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105d30:	55                   	push   %ebp
80105d31:	89 e5                	mov    %esp,%ebp
80105d33:	57                   	push   %edi
80105d34:	56                   	push   %esi
80105d35:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d36:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105d39:	83 ec 34             	sub    $0x34,%esp
80105d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d3f:	8b 55 10             	mov    0x10(%ebp),%edx
80105d42:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d45:	56                   	push   %esi
80105d46:	ff 75 08             	pushl  0x8(%ebp)
{
80105d49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105d4c:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105d4f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d52:	e8 69 c5 ff ff       	call   801022c0 <nameiparent>
80105d57:	83 c4 10             	add    $0x10,%esp
80105d5a:	85 c0                	test   %eax,%eax
80105d5c:	0f 84 4e 01 00 00    	je     80105eb0 <create+0x180>
    return 0;
  ilock(dp);
80105d62:	83 ec 0c             	sub    $0xc,%esp
80105d65:	89 c3                	mov    %eax,%ebx
80105d67:	50                   	push   %eax
80105d68:	e8 d3 bc ff ff       	call   80101a40 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d6d:	83 c4 0c             	add    $0xc,%esp
80105d70:	6a 00                	push   $0x0
80105d72:	56                   	push   %esi
80105d73:	53                   	push   %ebx
80105d74:	e8 f7 c1 ff ff       	call   80101f70 <dirlookup>
80105d79:	83 c4 10             	add    $0x10,%esp
80105d7c:	85 c0                	test   %eax,%eax
80105d7e:	89 c7                	mov    %eax,%edi
80105d80:	74 3e                	je     80105dc0 <create+0x90>
    iunlockput(dp);
80105d82:	83 ec 0c             	sub    $0xc,%esp
80105d85:	53                   	push   %ebx
80105d86:	e8 45 bf ff ff       	call   80101cd0 <iunlockput>
    ilock(ip);
80105d8b:	89 3c 24             	mov    %edi,(%esp)
80105d8e:	e8 ad bc ff ff       	call   80101a40 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d93:	83 c4 10             	add    $0x10,%esp
80105d96:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d9b:	0f 85 9f 00 00 00    	jne    80105e40 <create+0x110>
80105da1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105da6:	0f 85 94 00 00 00    	jne    80105e40 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105dac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105daf:	89 f8                	mov    %edi,%eax
80105db1:	5b                   	pop    %ebx
80105db2:	5e                   	pop    %esi
80105db3:	5f                   	pop    %edi
80105db4:	5d                   	pop    %ebp
80105db5:	c3                   	ret    
80105db6:	8d 76 00             	lea    0x0(%esi),%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105dc0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105dc4:	83 ec 08             	sub    $0x8,%esp
80105dc7:	50                   	push   %eax
80105dc8:	ff 33                	pushl  (%ebx)
80105dca:	e8 01 bb ff ff       	call   801018d0 <ialloc>
80105dcf:	83 c4 10             	add    $0x10,%esp
80105dd2:	85 c0                	test   %eax,%eax
80105dd4:	89 c7                	mov    %eax,%edi
80105dd6:	0f 84 e8 00 00 00    	je     80105ec4 <create+0x194>
  ilock(ip);
80105ddc:	83 ec 0c             	sub    $0xc,%esp
80105ddf:	50                   	push   %eax
80105de0:	e8 5b bc ff ff       	call   80101a40 <ilock>
  ip->major = major;
80105de5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105de9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105ded:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105df1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105df5:	b8 01 00 00 00       	mov    $0x1,%eax
80105dfa:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105dfe:	89 3c 24             	mov    %edi,(%esp)
80105e01:	e8 8a bb ff ff       	call   80101990 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e06:	83 c4 10             	add    $0x10,%esp
80105e09:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e0e:	74 50                	je     80105e60 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105e10:	83 ec 04             	sub    $0x4,%esp
80105e13:	ff 77 04             	pushl  0x4(%edi)
80105e16:	56                   	push   %esi
80105e17:	53                   	push   %ebx
80105e18:	e8 c3 c3 ff ff       	call   801021e0 <dirlink>
80105e1d:	83 c4 10             	add    $0x10,%esp
80105e20:	85 c0                	test   %eax,%eax
80105e22:	0f 88 8f 00 00 00    	js     80105eb7 <create+0x187>
  iunlockput(dp);
80105e28:	83 ec 0c             	sub    $0xc,%esp
80105e2b:	53                   	push   %ebx
80105e2c:	e8 9f be ff ff       	call   80101cd0 <iunlockput>
  return ip;
80105e31:	83 c4 10             	add    $0x10,%esp
}
80105e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e37:	89 f8                	mov    %edi,%eax
80105e39:	5b                   	pop    %ebx
80105e3a:	5e                   	pop    %esi
80105e3b:	5f                   	pop    %edi
80105e3c:	5d                   	pop    %ebp
80105e3d:	c3                   	ret    
80105e3e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105e40:	83 ec 0c             	sub    $0xc,%esp
80105e43:	57                   	push   %edi
    return 0;
80105e44:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105e46:	e8 85 be ff ff       	call   80101cd0 <iunlockput>
    return 0;
80105e4b:	83 c4 10             	add    $0x10,%esp
}
80105e4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e51:	89 f8                	mov    %edi,%eax
80105e53:	5b                   	pop    %ebx
80105e54:	5e                   	pop    %esi
80105e55:	5f                   	pop    %edi
80105e56:	5d                   	pop    %ebp
80105e57:	c3                   	ret    
80105e58:	90                   	nop
80105e59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105e60:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e65:	83 ec 0c             	sub    $0xc,%esp
80105e68:	53                   	push   %ebx
80105e69:	e8 22 bb ff ff       	call   80101990 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e6e:	83 c4 0c             	add    $0xc,%esp
80105e71:	ff 77 04             	pushl  0x4(%edi)
80105e74:	68 b3 90 10 80       	push   $0x801090b3
80105e79:	57                   	push   %edi
80105e7a:	e8 61 c3 ff ff       	call   801021e0 <dirlink>
80105e7f:	83 c4 10             	add    $0x10,%esp
80105e82:	85 c0                	test   %eax,%eax
80105e84:	78 1c                	js     80105ea2 <create+0x172>
80105e86:	83 ec 04             	sub    $0x4,%esp
80105e89:	ff 73 04             	pushl  0x4(%ebx)
80105e8c:	68 b2 90 10 80       	push   $0x801090b2
80105e91:	57                   	push   %edi
80105e92:	e8 49 c3 ff ff       	call   801021e0 <dirlink>
80105e97:	83 c4 10             	add    $0x10,%esp
80105e9a:	85 c0                	test   %eax,%eax
80105e9c:	0f 89 6e ff ff ff    	jns    80105e10 <create+0xe0>
      panic("create dots");
80105ea2:	83 ec 0c             	sub    $0xc,%esp
80105ea5:	68 e1 97 10 80       	push   $0x801097e1
80105eaa:	e8 e1 a4 ff ff       	call   80100390 <panic>
80105eaf:	90                   	nop
    return 0;
80105eb0:	31 ff                	xor    %edi,%edi
80105eb2:	e9 f5 fe ff ff       	jmp    80105dac <create+0x7c>
    panic("create: dirlink");
80105eb7:	83 ec 0c             	sub    $0xc,%esp
80105eba:	68 ed 97 10 80       	push   $0x801097ed
80105ebf:	e8 cc a4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105ec4:	83 ec 0c             	sub    $0xc,%esp
80105ec7:	68 d2 97 10 80       	push   $0x801097d2
80105ecc:	e8 bf a4 ff ff       	call   80100390 <panic>
80105ed1:	eb 0d                	jmp    80105ee0 <sys_open>
80105ed3:	90                   	nop
80105ed4:	90                   	nop
80105ed5:	90                   	nop
80105ed6:	90                   	nop
80105ed7:	90                   	nop
80105ed8:	90                   	nop
80105ed9:	90                   	nop
80105eda:	90                   	nop
80105edb:	90                   	nop
80105edc:	90                   	nop
80105edd:	90                   	nop
80105ede:	90                   	nop
80105edf:	90                   	nop

80105ee0 <sys_open>:

int
sys_open(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	57                   	push   %edi
80105ee4:	56                   	push   %esi
80105ee5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ee6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105ee9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105eec:	50                   	push   %eax
80105eed:	6a 00                	push   $0x0
80105eef:	e8 fc f7 ff ff       	call   801056f0 <argstr>
80105ef4:	83 c4 10             	add    $0x10,%esp
80105ef7:	85 c0                	test   %eax,%eax
80105ef9:	0f 88 1d 01 00 00    	js     8010601c <sys_open+0x13c>
80105eff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f02:	83 ec 08             	sub    $0x8,%esp
80105f05:	50                   	push   %eax
80105f06:	6a 01                	push   $0x1
80105f08:	e8 33 f7 ff ff       	call   80105640 <argint>
80105f0d:	83 c4 10             	add    $0x10,%esp
80105f10:	85 c0                	test   %eax,%eax
80105f12:	0f 88 04 01 00 00    	js     8010601c <sys_open+0x13c>
    return -1;

  begin_op();
80105f18:	e8 43 d6 ff ff       	call   80103560 <begin_op>

  if(omode & O_CREATE){
80105f1d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105f21:	0f 85 a9 00 00 00    	jne    80105fd0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105f27:	83 ec 0c             	sub    $0xc,%esp
80105f2a:	ff 75 e0             	pushl  -0x20(%ebp)
80105f2d:	e8 6e c3 ff ff       	call   801022a0 <namei>
80105f32:	83 c4 10             	add    $0x10,%esp
80105f35:	85 c0                	test   %eax,%eax
80105f37:	89 c6                	mov    %eax,%esi
80105f39:	0f 84 ac 00 00 00    	je     80105feb <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105f3f:	83 ec 0c             	sub    $0xc,%esp
80105f42:	50                   	push   %eax
80105f43:	e8 f8 ba ff ff       	call   80101a40 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f48:	83 c4 10             	add    $0x10,%esp
80105f4b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f50:	0f 84 aa 00 00 00    	je     80106000 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f56:	e8 e5 b1 ff ff       	call   80101140 <filealloc>
80105f5b:	85 c0                	test   %eax,%eax
80105f5d:	89 c7                	mov    %eax,%edi
80105f5f:	0f 84 a6 00 00 00    	je     8010600b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105f65:	e8 66 e3 ff ff       	call   801042d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f6a:	31 db                	xor    %ebx,%ebx
80105f6c:	eb 0e                	jmp    80105f7c <sys_open+0x9c>
80105f6e:	66 90                	xchg   %ax,%ax
80105f70:	83 c3 01             	add    $0x1,%ebx
80105f73:	83 fb 10             	cmp    $0x10,%ebx
80105f76:	0f 84 ac 00 00 00    	je     80106028 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105f7c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f80:	85 d2                	test   %edx,%edx
80105f82:	75 ec                	jne    80105f70 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f84:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f87:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105f8b:	56                   	push   %esi
80105f8c:	e8 8f bb ff ff       	call   80101b20 <iunlock>
  end_op();
80105f91:	e8 3a d6 ff ff       	call   801035d0 <end_op>

  f->type = FD_INODE;
80105f96:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f9c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f9f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105fa2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105fa5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105fac:	89 d0                	mov    %edx,%eax
80105fae:	f7 d0                	not    %eax
80105fb0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fb3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105fb6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fb9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105fbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fc0:	89 d8                	mov    %ebx,%eax
80105fc2:	5b                   	pop    %ebx
80105fc3:	5e                   	pop    %esi
80105fc4:	5f                   	pop    %edi
80105fc5:	5d                   	pop    %ebp
80105fc6:	c3                   	ret    
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105fd0:	6a 00                	push   $0x0
80105fd2:	6a 00                	push   $0x0
80105fd4:	6a 02                	push   $0x2
80105fd6:	ff 75 e0             	pushl  -0x20(%ebp)
80105fd9:	e8 52 fd ff ff       	call   80105d30 <create>
    if(ip == 0){
80105fde:	83 c4 10             	add    $0x10,%esp
80105fe1:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105fe3:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105fe5:	0f 85 6b ff ff ff    	jne    80105f56 <sys_open+0x76>
      end_op();
80105feb:	e8 e0 d5 ff ff       	call   801035d0 <end_op>
      return -1;
80105ff0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ff5:	eb c6                	jmp    80105fbd <sys_open+0xdd>
80105ff7:	89 f6                	mov    %esi,%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106000:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106003:	85 c9                	test   %ecx,%ecx
80106005:	0f 84 4b ff ff ff    	je     80105f56 <sys_open+0x76>
    iunlockput(ip);
8010600b:	83 ec 0c             	sub    $0xc,%esp
8010600e:	56                   	push   %esi
8010600f:	e8 bc bc ff ff       	call   80101cd0 <iunlockput>
    end_op();
80106014:	e8 b7 d5 ff ff       	call   801035d0 <end_op>
    return -1;
80106019:	83 c4 10             	add    $0x10,%esp
8010601c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106021:	eb 9a                	jmp    80105fbd <sys_open+0xdd>
80106023:	90                   	nop
80106024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80106028:	83 ec 0c             	sub    $0xc,%esp
8010602b:	57                   	push   %edi
8010602c:	e8 cf b1 ff ff       	call   80101200 <fileclose>
80106031:	83 c4 10             	add    $0x10,%esp
80106034:	eb d5                	jmp    8010600b <sys_open+0x12b>
80106036:	8d 76 00             	lea    0x0(%esi),%esi
80106039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106040 <sys_mkdir>:

int
sys_mkdir(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106046:	e8 15 d5 ff ff       	call   80103560 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010604b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010604e:	83 ec 08             	sub    $0x8,%esp
80106051:	50                   	push   %eax
80106052:	6a 00                	push   $0x0
80106054:	e8 97 f6 ff ff       	call   801056f0 <argstr>
80106059:	83 c4 10             	add    $0x10,%esp
8010605c:	85 c0                	test   %eax,%eax
8010605e:	78 30                	js     80106090 <sys_mkdir+0x50>
80106060:	6a 00                	push   $0x0
80106062:	6a 00                	push   $0x0
80106064:	6a 01                	push   $0x1
80106066:	ff 75 f4             	pushl  -0xc(%ebp)
80106069:	e8 c2 fc ff ff       	call   80105d30 <create>
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	74 1b                	je     80106090 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106075:	83 ec 0c             	sub    $0xc,%esp
80106078:	50                   	push   %eax
80106079:	e8 52 bc ff ff       	call   80101cd0 <iunlockput>
  end_op();
8010607e:	e8 4d d5 ff ff       	call   801035d0 <end_op>
  return 0;
80106083:	83 c4 10             	add    $0x10,%esp
80106086:	31 c0                	xor    %eax,%eax
}
80106088:	c9                   	leave  
80106089:	c3                   	ret    
8010608a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106090:	e8 3b d5 ff ff       	call   801035d0 <end_op>
    return -1;
80106095:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010609a:	c9                   	leave  
8010609b:	c3                   	ret    
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060a0 <sys_mknod>:

int
sys_mknod(void)
{
801060a0:	55                   	push   %ebp
801060a1:	89 e5                	mov    %esp,%ebp
801060a3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801060a6:	e8 b5 d4 ff ff       	call   80103560 <begin_op>
  if((argstr(0, &path)) < 0 ||
801060ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060ae:	83 ec 08             	sub    $0x8,%esp
801060b1:	50                   	push   %eax
801060b2:	6a 00                	push   $0x0
801060b4:	e8 37 f6 ff ff       	call   801056f0 <argstr>
801060b9:	83 c4 10             	add    $0x10,%esp
801060bc:	85 c0                	test   %eax,%eax
801060be:	78 60                	js     80106120 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801060c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060c3:	83 ec 08             	sub    $0x8,%esp
801060c6:	50                   	push   %eax
801060c7:	6a 01                	push   $0x1
801060c9:	e8 72 f5 ff ff       	call   80105640 <argint>
  if((argstr(0, &path)) < 0 ||
801060ce:	83 c4 10             	add    $0x10,%esp
801060d1:	85 c0                	test   %eax,%eax
801060d3:	78 4b                	js     80106120 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801060d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060d8:	83 ec 08             	sub    $0x8,%esp
801060db:	50                   	push   %eax
801060dc:	6a 02                	push   $0x2
801060de:	e8 5d f5 ff ff       	call   80105640 <argint>
     argint(1, &major) < 0 ||
801060e3:	83 c4 10             	add    $0x10,%esp
801060e6:	85 c0                	test   %eax,%eax
801060e8:	78 36                	js     80106120 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801060ea:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801060ee:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
801060ef:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
801060f3:	50                   	push   %eax
801060f4:	6a 03                	push   $0x3
801060f6:	ff 75 ec             	pushl  -0x14(%ebp)
801060f9:	e8 32 fc ff ff       	call   80105d30 <create>
801060fe:	83 c4 10             	add    $0x10,%esp
80106101:	85 c0                	test   %eax,%eax
80106103:	74 1b                	je     80106120 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106105:	83 ec 0c             	sub    $0xc,%esp
80106108:	50                   	push   %eax
80106109:	e8 c2 bb ff ff       	call   80101cd0 <iunlockput>
  end_op();
8010610e:	e8 bd d4 ff ff       	call   801035d0 <end_op>
  return 0;
80106113:	83 c4 10             	add    $0x10,%esp
80106116:	31 c0                	xor    %eax,%eax
}
80106118:	c9                   	leave  
80106119:	c3                   	ret    
8010611a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106120:	e8 ab d4 ff ff       	call   801035d0 <end_op>
    return -1;
80106125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612a:	c9                   	leave  
8010612b:	c3                   	ret    
8010612c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106130 <sys_chdir>:

int
sys_chdir(void)
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	56                   	push   %esi
80106134:	53                   	push   %ebx
80106135:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106138:	e8 93 e1 ff ff       	call   801042d0 <myproc>
8010613d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010613f:	e8 1c d4 ff ff       	call   80103560 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106144:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106147:	83 ec 08             	sub    $0x8,%esp
8010614a:	50                   	push   %eax
8010614b:	6a 00                	push   $0x0
8010614d:	e8 9e f5 ff ff       	call   801056f0 <argstr>
80106152:	83 c4 10             	add    $0x10,%esp
80106155:	85 c0                	test   %eax,%eax
80106157:	78 77                	js     801061d0 <sys_chdir+0xa0>
80106159:	83 ec 0c             	sub    $0xc,%esp
8010615c:	ff 75 f4             	pushl  -0xc(%ebp)
8010615f:	e8 3c c1 ff ff       	call   801022a0 <namei>
80106164:	83 c4 10             	add    $0x10,%esp
80106167:	85 c0                	test   %eax,%eax
80106169:	89 c3                	mov    %eax,%ebx
8010616b:	74 63                	je     801061d0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010616d:	83 ec 0c             	sub    $0xc,%esp
80106170:	50                   	push   %eax
80106171:	e8 ca b8 ff ff       	call   80101a40 <ilock>
  if(ip->type != T_DIR){
80106176:	83 c4 10             	add    $0x10,%esp
80106179:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010617e:	75 30                	jne    801061b0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106180:	83 ec 0c             	sub    $0xc,%esp
80106183:	53                   	push   %ebx
80106184:	e8 97 b9 ff ff       	call   80101b20 <iunlock>
  iput(curproc->cwd);
80106189:	58                   	pop    %eax
8010618a:	ff 76 68             	pushl  0x68(%esi)
8010618d:	e8 de b9 ff ff       	call   80101b70 <iput>
  end_op();
80106192:	e8 39 d4 ff ff       	call   801035d0 <end_op>
  curproc->cwd = ip;
80106197:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	31 c0                	xor    %eax,%eax
}
8010619f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061a2:	5b                   	pop    %ebx
801061a3:	5e                   	pop    %esi
801061a4:	5d                   	pop    %ebp
801061a5:	c3                   	ret    
801061a6:	8d 76 00             	lea    0x0(%esi),%esi
801061a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801061b0:	83 ec 0c             	sub    $0xc,%esp
801061b3:	53                   	push   %ebx
801061b4:	e8 17 bb ff ff       	call   80101cd0 <iunlockput>
    end_op();
801061b9:	e8 12 d4 ff ff       	call   801035d0 <end_op>
    return -1;
801061be:	83 c4 10             	add    $0x10,%esp
801061c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c6:	eb d7                	jmp    8010619f <sys_chdir+0x6f>
801061c8:	90                   	nop
801061c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801061d0:	e8 fb d3 ff ff       	call   801035d0 <end_op>
    return -1;
801061d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061da:	eb c3                	jmp    8010619f <sys_chdir+0x6f>
801061dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061e0 <sys_exec>:

int
sys_exec(void)
{
801061e0:	55                   	push   %ebp
801061e1:	89 e5                	mov    %esp,%ebp
801061e3:	57                   	push   %edi
801061e4:	56                   	push   %esi
801061e5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061e6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801061ec:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801061f2:	50                   	push   %eax
801061f3:	6a 00                	push   $0x0
801061f5:	e8 f6 f4 ff ff       	call   801056f0 <argstr>
801061fa:	83 c4 10             	add    $0x10,%esp
801061fd:	85 c0                	test   %eax,%eax
801061ff:	0f 88 87 00 00 00    	js     8010628c <sys_exec+0xac>
80106205:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010620b:	83 ec 08             	sub    $0x8,%esp
8010620e:	50                   	push   %eax
8010620f:	6a 01                	push   $0x1
80106211:	e8 2a f4 ff ff       	call   80105640 <argint>
80106216:	83 c4 10             	add    $0x10,%esp
80106219:	85 c0                	test   %eax,%eax
8010621b:	78 6f                	js     8010628c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010621d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106223:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106226:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106228:	68 80 00 00 00       	push   $0x80
8010622d:	6a 00                	push   $0x0
8010622f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106235:	50                   	push   %eax
80106236:	e8 05 f1 ff ff       	call   80105340 <memset>
8010623b:	83 c4 10             	add    $0x10,%esp
8010623e:	eb 2c                	jmp    8010626c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106240:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106246:	85 c0                	test   %eax,%eax
80106248:	74 56                	je     801062a0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010624a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106250:	83 ec 08             	sub    $0x8,%esp
80106253:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106256:	52                   	push   %edx
80106257:	50                   	push   %eax
80106258:	e8 73 f3 ff ff       	call   801055d0 <fetchstr>
8010625d:	83 c4 10             	add    $0x10,%esp
80106260:	85 c0                	test   %eax,%eax
80106262:	78 28                	js     8010628c <sys_exec+0xac>
  for(i=0;; i++){
80106264:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106267:	83 fb 20             	cmp    $0x20,%ebx
8010626a:	74 20                	je     8010628c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010626c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106272:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106279:	83 ec 08             	sub    $0x8,%esp
8010627c:	57                   	push   %edi
8010627d:	01 f0                	add    %esi,%eax
8010627f:	50                   	push   %eax
80106280:	e8 0b f3 ff ff       	call   80105590 <fetchint>
80106285:	83 c4 10             	add    $0x10,%esp
80106288:	85 c0                	test   %eax,%eax
8010628a:	79 b4                	jns    80106240 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010628c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010628f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106294:	5b                   	pop    %ebx
80106295:	5e                   	pop    %esi
80106296:	5f                   	pop    %edi
80106297:	5d                   	pop    %ebp
80106298:	c3                   	ret    
80106299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801062a0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801062a6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801062a9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801062b0:	00 00 00 00 
  return exec(path, argv);
801062b4:	50                   	push   %eax
801062b5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801062bb:	e8 b0 a9 ff ff       	call   80100c70 <exec>
801062c0:	83 c4 10             	add    $0x10,%esp
}
801062c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062c6:	5b                   	pop    %ebx
801062c7:	5e                   	pop    %esi
801062c8:	5f                   	pop    %edi
801062c9:	5d                   	pop    %ebp
801062ca:	c3                   	ret    
801062cb:	90                   	nop
801062cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062d0 <sys_pipe>:

int
sys_pipe(void)
{
801062d0:	55                   	push   %ebp
801062d1:	89 e5                	mov    %esp,%ebp
801062d3:	57                   	push   %edi
801062d4:	56                   	push   %esi
801062d5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062d6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801062d9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062dc:	6a 08                	push   $0x8
801062de:	50                   	push   %eax
801062df:	6a 00                	push   $0x0
801062e1:	e8 aa f3 ff ff       	call   80105690 <argptr>
801062e6:	83 c4 10             	add    $0x10,%esp
801062e9:	85 c0                	test   %eax,%eax
801062eb:	0f 88 ae 00 00 00    	js     8010639f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801062f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801062f4:	83 ec 08             	sub    $0x8,%esp
801062f7:	50                   	push   %eax
801062f8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801062fb:	50                   	push   %eax
801062fc:	e8 ff d8 ff ff       	call   80103c00 <pipealloc>
80106301:	83 c4 10             	add    $0x10,%esp
80106304:	85 c0                	test   %eax,%eax
80106306:	0f 88 93 00 00 00    	js     8010639f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010630c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010630f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106311:	e8 ba df ff ff       	call   801042d0 <myproc>
80106316:	eb 10                	jmp    80106328 <sys_pipe+0x58>
80106318:	90                   	nop
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106320:	83 c3 01             	add    $0x1,%ebx
80106323:	83 fb 10             	cmp    $0x10,%ebx
80106326:	74 60                	je     80106388 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106328:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010632c:	85 f6                	test   %esi,%esi
8010632e:	75 f0                	jne    80106320 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106330:	8d 73 08             	lea    0x8(%ebx),%esi
80106333:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106337:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010633a:	e8 91 df ff ff       	call   801042d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010633f:	31 d2                	xor    %edx,%edx
80106341:	eb 0d                	jmp    80106350 <sys_pipe+0x80>
80106343:	90                   	nop
80106344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106348:	83 c2 01             	add    $0x1,%edx
8010634b:	83 fa 10             	cmp    $0x10,%edx
8010634e:	74 28                	je     80106378 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106350:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106354:	85 c9                	test   %ecx,%ecx
80106356:	75 f0                	jne    80106348 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106358:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010635c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010635f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106361:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106364:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106367:	31 c0                	xor    %eax,%eax
}
80106369:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010636c:	5b                   	pop    %ebx
8010636d:	5e                   	pop    %esi
8010636e:	5f                   	pop    %edi
8010636f:	5d                   	pop    %ebp
80106370:	c3                   	ret    
80106371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106378:	e8 53 df ff ff       	call   801042d0 <myproc>
8010637d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106384:	00 
80106385:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106388:	83 ec 0c             	sub    $0xc,%esp
8010638b:	ff 75 e0             	pushl  -0x20(%ebp)
8010638e:	e8 6d ae ff ff       	call   80101200 <fileclose>
    fileclose(wf);
80106393:	58                   	pop    %eax
80106394:	ff 75 e4             	pushl  -0x1c(%ebp)
80106397:	e8 64 ae ff ff       	call   80101200 <fileclose>
    return -1;
8010639c:	83 c4 10             	add    $0x10,%esp
8010639f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a4:	eb c3                	jmp    80106369 <sys_pipe+0x99>
801063a6:	66 90                	xchg   %ax,%ax
801063a8:	66 90                	xchg   %ax,%ax
801063aa:	66 90                	xchg   %ax,%ax
801063ac:	66 90                	xchg   %ax,%ax
801063ae:	66 90                	xchg   %ax,%ax

801063b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063b0:	55                   	push   %ebp
801063b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801063b3:	5d                   	pop    %ebp
  return fork();
801063b4:	e9 67 e1 ff ff       	jmp    80104520 <fork>
801063b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063c0 <sys_exit>:

int
sys_exit(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801063c6:	e8 65 e5 ff ff       	call   80104930 <exit>
  return 0;  // not reached
}
801063cb:	31 c0                	xor    %eax,%eax
801063cd:	c9                   	leave  
801063ce:	c3                   	ret    
801063cf:	90                   	nop

801063d0 <sys_wait>:

int
sys_wait(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801063d3:	5d                   	pop    %ebp
  return wait();
801063d4:	e9 c7 e7 ff ff       	jmp    80104ba0 <wait>
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063e0 <sys_kill>:

int
sys_kill(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801063e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801063e9:	50                   	push   %eax
801063ea:	6a 00                	push   $0x0
801063ec:	e8 4f f2 ff ff       	call   80105640 <argint>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	85 c0                	test   %eax,%eax
801063f6:	78 18                	js     80106410 <sys_kill+0x30>
    return -1;
  return kill(pid);
801063f8:	83 ec 0c             	sub    $0xc,%esp
801063fb:	ff 75 f4             	pushl  -0xc(%ebp)
801063fe:	e8 7d e9 ff ff       	call   80104d80 <kill>
80106403:	83 c4 10             	add    $0x10,%esp
}
80106406:	c9                   	leave  
80106407:	c3                   	ret    
80106408:	90                   	nop
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106410:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106415:	c9                   	leave  
80106416:	c3                   	ret    
80106417:	89 f6                	mov    %esi,%esi
80106419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106420 <sys_getpid>:

int
sys_getpid(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106426:	e8 a5 de ff ff       	call   801042d0 <myproc>
8010642b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010642e:	c9                   	leave  
8010642f:	c3                   	ret    

80106430 <sys_sbrk>:

int
sys_sbrk(void)
{
80106430:	55                   	push   %ebp
80106431:	89 e5                	mov    %esp,%ebp
80106433:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106434:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106437:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010643a:	50                   	push   %eax
8010643b:	6a 00                	push   $0x0
8010643d:	e8 fe f1 ff ff       	call   80105640 <argint>
80106442:	83 c4 10             	add    $0x10,%esp
80106445:	85 c0                	test   %eax,%eax
80106447:	78 27                	js     80106470 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106449:	e8 82 de ff ff       	call   801042d0 <myproc>
  if(growproc(n) < 0)
8010644e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106451:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106453:	ff 75 f4             	pushl  -0xc(%ebp)
80106456:	e8 95 df ff ff       	call   801043f0 <growproc>
8010645b:	83 c4 10             	add    $0x10,%esp
8010645e:	85 c0                	test   %eax,%eax
80106460:	78 0e                	js     80106470 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106462:	89 d8                	mov    %ebx,%eax
80106464:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106467:	c9                   	leave  
80106468:	c3                   	ret    
80106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106470:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106475:	eb eb                	jmp    80106462 <sys_sbrk+0x32>
80106477:	89 f6                	mov    %esi,%esi
80106479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106480 <sys_sleep>:

int
sys_sleep(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106484:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106487:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010648a:	50                   	push   %eax
8010648b:	6a 00                	push   $0x0
8010648d:	e8 ae f1 ff ff       	call   80105640 <argint>
80106492:	83 c4 10             	add    $0x10,%esp
80106495:	85 c0                	test   %eax,%eax
80106497:	0f 88 8a 00 00 00    	js     80106527 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010649d:	83 ec 0c             	sub    $0xc,%esp
801064a0:	68 40 6d 19 80       	push   $0x80196d40
801064a5:	e8 86 ed ff ff       	call   80105230 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064ad:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064b0:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  while(ticks - ticks0 < n){
801064b6:	85 d2                	test   %edx,%edx
801064b8:	75 27                	jne    801064e1 <sys_sleep+0x61>
801064ba:	eb 54                	jmp    80106510 <sys_sleep+0x90>
801064bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801064c0:	83 ec 08             	sub    $0x8,%esp
801064c3:	68 40 6d 19 80       	push   $0x80196d40
801064c8:	68 80 75 19 80       	push   $0x80197580
801064cd:	e8 0e e6 ff ff       	call   80104ae0 <sleep>
  while(ticks - ticks0 < n){
801064d2:	a1 80 75 19 80       	mov    0x80197580,%eax
801064d7:	83 c4 10             	add    $0x10,%esp
801064da:	29 d8                	sub    %ebx,%eax
801064dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064df:	73 2f                	jae    80106510 <sys_sleep+0x90>
    if(myproc()->killed){
801064e1:	e8 ea dd ff ff       	call   801042d0 <myproc>
801064e6:	8b 40 24             	mov    0x24(%eax),%eax
801064e9:	85 c0                	test   %eax,%eax
801064eb:	74 d3                	je     801064c0 <sys_sleep+0x40>
      release(&tickslock);
801064ed:	83 ec 0c             	sub    $0xc,%esp
801064f0:	68 40 6d 19 80       	push   $0x80196d40
801064f5:	e8 f6 ed ff ff       	call   801052f0 <release>
      return -1;
801064fa:	83 c4 10             	add    $0x10,%esp
801064fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106502:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106505:	c9                   	leave  
80106506:	c3                   	ret    
80106507:	89 f6                	mov    %esi,%esi
80106509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106510:	83 ec 0c             	sub    $0xc,%esp
80106513:	68 40 6d 19 80       	push   $0x80196d40
80106518:	e8 d3 ed ff ff       	call   801052f0 <release>
  return 0;
8010651d:	83 c4 10             	add    $0x10,%esp
80106520:	31 c0                	xor    %eax,%eax
}
80106522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106525:	c9                   	leave  
80106526:	c3                   	ret    
    return -1;
80106527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010652c:	eb f4                	jmp    80106522 <sys_sleep+0xa2>
8010652e:	66 90                	xchg   %ax,%ax

80106530 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	53                   	push   %ebx
80106534:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106537:	68 40 6d 19 80       	push   $0x80196d40
8010653c:	e8 ef ec ff ff       	call   80105230 <acquire>
  xticks = ticks;
80106541:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
80106547:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
8010654e:	e8 9d ed ff ff       	call   801052f0 <release>
  return xticks;
}
80106553:	89 d8                	mov    %ebx,%eax
80106555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106558:	c9                   	leave  
80106559:	c3                   	ret    
8010655a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106560 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106560:	55                   	push   %ebp
80106561:	89 e5                	mov    %esp,%ebp
80106563:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106566:	e8 65 dd ff ff       	call   801042d0 <myproc>
8010656b:	ba 10 00 00 00       	mov    $0x10,%edx
80106570:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80106576:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106577:	89 d0                	mov    %edx,%eax
}
80106579:	c3                   	ret    
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106580 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80106583:	5d                   	pop    %ebp
  return getTotalFreePages();
80106584:	e9 d7 e8 ff ff       	jmp    80104e60 <getTotalFreePages>

80106589 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106589:	1e                   	push   %ds
  pushl %es
8010658a:	06                   	push   %es
  pushl %fs
8010658b:	0f a0                	push   %fs
  pushl %gs
8010658d:	0f a8                	push   %gs
  pushal
8010658f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106590:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106594:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106596:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106598:	54                   	push   %esp
  call trap
80106599:	e8 c2 00 00 00       	call   80106660 <trap>
  addl $4, %esp
8010659e:	83 c4 04             	add    $0x4,%esp

801065a1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065a1:	61                   	popa   
  popl %gs
801065a2:	0f a9                	pop    %gs
  popl %fs
801065a4:	0f a1                	pop    %fs
  popl %es
801065a6:	07                   	pop    %es
  popl %ds
801065a7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065a8:	83 c4 08             	add    $0x8,%esp
  iret
801065ab:	cf                   	iret   
801065ac:	66 90                	xchg   %ax,%ax
801065ae:	66 90                	xchg   %ax,%ax

801065b0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065b0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801065b1:	31 c0                	xor    %eax,%eax
{
801065b3:	89 e5                	mov    %esp,%ebp
801065b5:	83 ec 08             	sub    $0x8,%esp
801065b8:	90                   	nop
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065c0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801065c7:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
801065ce:	08 00 00 8e 
801065d2:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
801065d9:	80 
801065da:	c1 ea 10             	shr    $0x10,%edx
801065dd:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
801065e4:	80 
  for(i = 0; i < 256; i++)
801065e5:	83 c0 01             	add    $0x1,%eax
801065e8:	3d 00 01 00 00       	cmp    $0x100,%eax
801065ed:	75 d1                	jne    801065c0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065ef:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
801065f4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065f7:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
801065fe:	00 00 ef 
  initlock(&tickslock, "time");
80106601:	68 fd 97 10 80       	push   $0x801097fd
80106606:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010660b:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
80106611:	c1 e8 10             	shr    $0x10,%eax
80106614:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
8010661a:	e8 d1 ea ff ff       	call   801050f0 <initlock>
}
8010661f:	83 c4 10             	add    $0x10,%esp
80106622:	c9                   	leave  
80106623:	c3                   	ret    
80106624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010662a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106630 <idtinit>:

void
idtinit(void)
{
80106630:	55                   	push   %ebp
  pd[0] = size-1;
80106631:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106636:	89 e5                	mov    %esp,%ebp
80106638:	83 ec 10             	sub    $0x10,%esp
8010663b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010663f:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
80106644:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106648:	c1 e8 10             	shr    $0x10,%eax
8010664b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010664f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106652:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106655:	c9                   	leave  
80106656:	c3                   	ret    
80106657:	89 f6                	mov    %esi,%esi
80106659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106660 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	56                   	push   %esi
80106665:	53                   	push   %ebx
80106666:	83 ec 1c             	sub    $0x1c,%esp
80106669:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
8010666c:	e8 5f dc ff ff       	call   801042d0 <myproc>
80106671:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106673:	8b 47 30             	mov    0x30(%edi),%eax
80106676:	83 f8 40             	cmp    $0x40,%eax
80106679:	0f 84 e9 00 00 00    	je     80106768 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010667f:	83 e8 0e             	sub    $0xe,%eax
80106682:	83 f8 31             	cmp    $0x31,%eax
80106685:	77 09                	ja     80106690 <trap+0x30>
80106687:	ff 24 85 a4 98 10 80 	jmp    *-0x7fef675c(,%eax,4)
8010668e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106690:	e8 3b dc ff ff       	call   801042d0 <myproc>
80106695:	85 c0                	test   %eax,%eax
80106697:	0f 84 27 02 00 00    	je     801068c4 <trap+0x264>
8010669d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801066a1:	0f 84 1d 02 00 00    	je     801068c4 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066a7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066aa:	8b 57 38             	mov    0x38(%edi),%edx
801066ad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801066b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801066b3:	e8 f8 db ff ff       	call   801042b0 <cpuid>
801066b8:	8b 77 34             	mov    0x34(%edi),%esi
801066bb:	8b 5f 30             	mov    0x30(%edi),%ebx
801066be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066c1:	e8 0a dc ff ff       	call   801042d0 <myproc>
801066c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066c9:	e8 02 dc ff ff       	call   801042d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ce:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066d1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066d4:	51                   	push   %ecx
801066d5:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801066d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066d9:	ff 75 e4             	pushl  -0x1c(%ebp)
801066dc:	56                   	push   %esi
801066dd:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
801066de:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066e1:	52                   	push   %edx
801066e2:	ff 70 10             	pushl  0x10(%eax)
801066e5:	68 60 98 10 80       	push   $0x80109860
801066ea:	e8 71 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801066ef:	83 c4 20             	add    $0x20,%esp
801066f2:	e8 d9 db ff ff       	call   801042d0 <myproc>
801066f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801066fe:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106700:	e8 cb db ff ff       	call   801042d0 <myproc>
80106705:	85 c0                	test   %eax,%eax
80106707:	74 1d                	je     80106726 <trap+0xc6>
80106709:	e8 c2 db ff ff       	call   801042d0 <myproc>
8010670e:	8b 50 24             	mov    0x24(%eax),%edx
80106711:	85 d2                	test   %edx,%edx
80106713:	74 11                	je     80106726 <trap+0xc6>
80106715:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106719:	83 e0 03             	and    $0x3,%eax
8010671c:	66 83 f8 03          	cmp    $0x3,%ax
80106720:	0f 84 5a 01 00 00    	je     80106880 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106726:	e8 a5 db ff ff       	call   801042d0 <myproc>
8010672b:	85 c0                	test   %eax,%eax
8010672d:	74 0b                	je     8010673a <trap+0xda>
8010672f:	e8 9c db ff ff       	call   801042d0 <myproc>
80106734:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106738:	74 5e                	je     80106798 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010673a:	e8 91 db ff ff       	call   801042d0 <myproc>
8010673f:	85 c0                	test   %eax,%eax
80106741:	74 19                	je     8010675c <trap+0xfc>
80106743:	e8 88 db ff ff       	call   801042d0 <myproc>
80106748:	8b 40 24             	mov    0x24(%eax),%eax
8010674b:	85 c0                	test   %eax,%eax
8010674d:	74 0d                	je     8010675c <trap+0xfc>
8010674f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106753:	83 e0 03             	and    $0x3,%eax
80106756:	66 83 f8 03          	cmp    $0x3,%ax
8010675a:	74 2b                	je     80106787 <trap+0x127>
    exit();
8010675c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010675f:	5b                   	pop    %ebx
80106760:	5e                   	pop    %esi
80106761:	5f                   	pop    %edi
80106762:	5d                   	pop    %ebp
80106763:	c3                   	ret    
80106764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106768:	8b 73 24             	mov    0x24(%ebx),%esi
8010676b:	85 f6                	test   %esi,%esi
8010676d:	0f 85 fd 00 00 00    	jne    80106870 <trap+0x210>
    curproc->tf = tf;
80106773:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106776:	e8 b5 ef ff ff       	call   80105730 <syscall>
    if(myproc()->killed)
8010677b:	e8 50 db ff ff       	call   801042d0 <myproc>
80106780:	8b 58 24             	mov    0x24(%eax),%ebx
80106783:	85 db                	test   %ebx,%ebx
80106785:	74 d5                	je     8010675c <trap+0xfc>
80106787:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010678a:	5b                   	pop    %ebx
8010678b:	5e                   	pop    %esi
8010678c:	5f                   	pop    %edi
8010678d:	5d                   	pop    %ebp
      exit();
8010678e:	e9 9d e1 ff ff       	jmp    80104930 <exit>
80106793:	90                   	nop
80106794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106798:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010679c:	75 9c                	jne    8010673a <trap+0xda>
      if(myproc()->pid > 2) 
8010679e:	e8 2d db ff ff       	call   801042d0 <myproc>
      yield();
801067a3:	e8 e8 e2 ff ff       	call   80104a90 <yield>
801067a8:	eb 90                	jmp    8010673a <trap+0xda>
801067aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
801067b0:	e8 1b db ff ff       	call   801042d0 <myproc>
801067b5:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801067b9:	0f 8e 41 ff ff ff    	jle    80106700 <trap+0xa0>
    pagefault();
801067bf:	e8 bc 24 00 00       	call   80108c80 <pagefault>
      if(curproc->killed) {
801067c4:	8b 4b 24             	mov    0x24(%ebx),%ecx
801067c7:	85 c9                	test   %ecx,%ecx
801067c9:	0f 84 31 ff ff ff    	je     80106700 <trap+0xa0>
        exit();
801067cf:	e8 5c e1 ff ff       	call   80104930 <exit>
801067d4:	e9 27 ff ff ff       	jmp    80106700 <trap+0xa0>
801067d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
801067e0:	e8 cb da ff ff       	call   801042b0 <cpuid>
801067e5:	85 c0                	test   %eax,%eax
801067e7:	0f 84 a3 00 00 00    	je     80106890 <trap+0x230>
    lapiceoi();
801067ed:	e8 1e c9 ff ff       	call   80103110 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801067f2:	e8 d9 da ff ff       	call   801042d0 <myproc>
801067f7:	85 c0                	test   %eax,%eax
801067f9:	0f 85 0a ff ff ff    	jne    80106709 <trap+0xa9>
801067ff:	e9 22 ff ff ff       	jmp    80106726 <trap+0xc6>
80106804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106808:	e8 c3 c7 ff ff       	call   80102fd0 <kbdintr>
    lapiceoi();
8010680d:	e8 fe c8 ff ff       	call   80103110 <lapiceoi>
    break;
80106812:	e9 e9 fe ff ff       	jmp    80106700 <trap+0xa0>
80106817:	89 f6                	mov    %esi,%esi
80106819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80106820:	e8 3b 02 00 00       	call   80106a60 <uartintr>
    lapiceoi();
80106825:	e8 e6 c8 ff ff       	call   80103110 <lapiceoi>
    break;
8010682a:	e9 d1 fe ff ff       	jmp    80106700 <trap+0xa0>
8010682f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106830:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106834:	8b 77 38             	mov    0x38(%edi),%esi
80106837:	e8 74 da ff ff       	call   801042b0 <cpuid>
8010683c:	56                   	push   %esi
8010683d:	53                   	push   %ebx
8010683e:	50                   	push   %eax
8010683f:	68 08 98 10 80       	push   $0x80109808
80106844:	e8 17 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106849:	e8 c2 c8 ff ff       	call   80103110 <lapiceoi>
    break;
8010684e:	83 c4 10             	add    $0x10,%esp
80106851:	e9 aa fe ff ff       	jmp    80106700 <trap+0xa0>
80106856:	8d 76 00             	lea    0x0(%esi),%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106860:	e8 6b bf ff ff       	call   801027d0 <ideintr>
80106865:	eb 86                	jmp    801067ed <trap+0x18d>
80106867:	89 f6                	mov    %esi,%esi
80106869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106870:	e8 bb e0 ff ff       	call   80104930 <exit>
80106875:	e9 f9 fe ff ff       	jmp    80106773 <trap+0x113>
8010687a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106880:	e8 ab e0 ff ff       	call   80104930 <exit>
80106885:	e9 9c fe ff ff       	jmp    80106726 <trap+0xc6>
8010688a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106890:	83 ec 0c             	sub    $0xc,%esp
80106893:	68 40 6d 19 80       	push   $0x80196d40
80106898:	e8 93 e9 ff ff       	call   80105230 <acquire>
      wakeup(&ticks);
8010689d:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
801068a4:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
801068ab:	e8 70 e4 ff ff       	call   80104d20 <wakeup>
      release(&tickslock);
801068b0:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
801068b7:	e8 34 ea ff ff       	call   801052f0 <release>
801068bc:	83 c4 10             	add    $0x10,%esp
801068bf:	e9 29 ff ff ff       	jmp    801067ed <trap+0x18d>
801068c4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801068ca:	e8 e1 d9 ff ff       	call   801042b0 <cpuid>
801068cf:	83 ec 0c             	sub    $0xc,%esp
801068d2:	56                   	push   %esi
801068d3:	53                   	push   %ebx
801068d4:	50                   	push   %eax
801068d5:	ff 77 30             	pushl  0x30(%edi)
801068d8:	68 2c 98 10 80       	push   $0x8010982c
801068dd:	e8 7e 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
801068e2:	83 c4 14             	add    $0x14,%esp
801068e5:	68 02 98 10 80       	push   $0x80109802
801068ea:	e8 a1 9a ff ff       	call   80100390 <panic>
801068ef:	90                   	nop

801068f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801068f0:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
801068f5:	55                   	push   %ebp
801068f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801068f8:	85 c0                	test   %eax,%eax
801068fa:	74 1c                	je     80106918 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801068fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106901:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106902:	a8 01                	test   $0x1,%al
80106904:	74 12                	je     80106918 <uartgetc+0x28>
80106906:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010690b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010690c:	0f b6 c0             	movzbl %al,%eax
}
8010690f:	5d                   	pop    %ebp
80106910:	c3                   	ret    
80106911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010691d:	5d                   	pop    %ebp
8010691e:	c3                   	ret    
8010691f:	90                   	nop

80106920 <uartputc.part.0>:
uartputc(int c)
80106920:	55                   	push   %ebp
80106921:	89 e5                	mov    %esp,%ebp
80106923:	57                   	push   %edi
80106924:	56                   	push   %esi
80106925:	53                   	push   %ebx
80106926:	89 c7                	mov    %eax,%edi
80106928:	bb 80 00 00 00       	mov    $0x80,%ebx
8010692d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106932:	83 ec 0c             	sub    $0xc,%esp
80106935:	eb 1b                	jmp    80106952 <uartputc.part.0+0x32>
80106937:	89 f6                	mov    %esi,%esi
80106939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106940:	83 ec 0c             	sub    $0xc,%esp
80106943:	6a 0a                	push   $0xa
80106945:	e8 e6 c7 ff ff       	call   80103130 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010694a:	83 c4 10             	add    $0x10,%esp
8010694d:	83 eb 01             	sub    $0x1,%ebx
80106950:	74 07                	je     80106959 <uartputc.part.0+0x39>
80106952:	89 f2                	mov    %esi,%edx
80106954:	ec                   	in     (%dx),%al
80106955:	a8 20                	test   $0x20,%al
80106957:	74 e7                	je     80106940 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106959:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010695e:	89 f8                	mov    %edi,%eax
80106960:	ee                   	out    %al,(%dx)
}
80106961:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106964:	5b                   	pop    %ebx
80106965:	5e                   	pop    %esi
80106966:	5f                   	pop    %edi
80106967:	5d                   	pop    %ebp
80106968:	c3                   	ret    
80106969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106970 <uartinit>:
{
80106970:	55                   	push   %ebp
80106971:	31 c9                	xor    %ecx,%ecx
80106973:	89 c8                	mov    %ecx,%eax
80106975:	89 e5                	mov    %esp,%ebp
80106977:	57                   	push   %edi
80106978:	56                   	push   %esi
80106979:	53                   	push   %ebx
8010697a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010697f:	89 da                	mov    %ebx,%edx
80106981:	83 ec 0c             	sub    $0xc,%esp
80106984:	ee                   	out    %al,(%dx)
80106985:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010698a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010698f:	89 fa                	mov    %edi,%edx
80106991:	ee                   	out    %al,(%dx)
80106992:	b8 0c 00 00 00       	mov    $0xc,%eax
80106997:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010699c:	ee                   	out    %al,(%dx)
8010699d:	be f9 03 00 00       	mov    $0x3f9,%esi
801069a2:	89 c8                	mov    %ecx,%eax
801069a4:	89 f2                	mov    %esi,%edx
801069a6:	ee                   	out    %al,(%dx)
801069a7:	b8 03 00 00 00       	mov    $0x3,%eax
801069ac:	89 fa                	mov    %edi,%edx
801069ae:	ee                   	out    %al,(%dx)
801069af:	ba fc 03 00 00       	mov    $0x3fc,%edx
801069b4:	89 c8                	mov    %ecx,%eax
801069b6:	ee                   	out    %al,(%dx)
801069b7:	b8 01 00 00 00       	mov    $0x1,%eax
801069bc:	89 f2                	mov    %esi,%edx
801069be:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069bf:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069c4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801069c5:	3c ff                	cmp    $0xff,%al
801069c7:	74 5a                	je     80106a23 <uartinit+0xb3>
  uart = 1;
801069c9:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
801069d0:	00 00 00 
801069d3:	89 da                	mov    %ebx,%edx
801069d5:	ec                   	in     (%dx),%al
801069d6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069db:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801069dc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801069df:	bb 6c 99 10 80       	mov    $0x8010996c,%ebx
  ioapicenable(IRQ_COM1, 0);
801069e4:	6a 00                	push   $0x0
801069e6:	6a 04                	push   $0x4
801069e8:	e8 33 c0 ff ff       	call   80102a20 <ioapicenable>
801069ed:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801069f0:	b8 78 00 00 00       	mov    $0x78,%eax
801069f5:	eb 13                	jmp    80106a0a <uartinit+0x9a>
801069f7:	89 f6                	mov    %esi,%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a00:	83 c3 01             	add    $0x1,%ebx
80106a03:	0f be 03             	movsbl (%ebx),%eax
80106a06:	84 c0                	test   %al,%al
80106a08:	74 19                	je     80106a23 <uartinit+0xb3>
  if(!uart)
80106a0a:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
80106a10:	85 d2                	test   %edx,%edx
80106a12:	74 ec                	je     80106a00 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106a14:	83 c3 01             	add    $0x1,%ebx
80106a17:	e8 04 ff ff ff       	call   80106920 <uartputc.part.0>
80106a1c:	0f be 03             	movsbl (%ebx),%eax
80106a1f:	84 c0                	test   %al,%al
80106a21:	75 e7                	jne    80106a0a <uartinit+0x9a>
}
80106a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a26:	5b                   	pop    %ebx
80106a27:	5e                   	pop    %esi
80106a28:	5f                   	pop    %edi
80106a29:	5d                   	pop    %ebp
80106a2a:	c3                   	ret    
80106a2b:	90                   	nop
80106a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a30 <uartputc>:
  if(!uart)
80106a30:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
80106a36:	55                   	push   %ebp
80106a37:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106a39:	85 d2                	test   %edx,%edx
{
80106a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106a3e:	74 10                	je     80106a50 <uartputc+0x20>
}
80106a40:	5d                   	pop    %ebp
80106a41:	e9 da fe ff ff       	jmp    80106920 <uartputc.part.0>
80106a46:	8d 76 00             	lea    0x0(%esi),%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a50:	5d                   	pop    %ebp
80106a51:	c3                   	ret    
80106a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a60 <uartintr>:

void
uartintr(void)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106a66:	68 f0 68 10 80       	push   $0x801068f0
80106a6b:	e8 a0 9d ff ff       	call   80100810 <consoleintr>
}
80106a70:	83 c4 10             	add    $0x10,%esp
80106a73:	c9                   	leave  
80106a74:	c3                   	ret    

80106a75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a75:	6a 00                	push   $0x0
  pushl $0
80106a77:	6a 00                	push   $0x0
  jmp alltraps
80106a79:	e9 0b fb ff ff       	jmp    80106589 <alltraps>

80106a7e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a7e:	6a 00                	push   $0x0
  pushl $1
80106a80:	6a 01                	push   $0x1
  jmp alltraps
80106a82:	e9 02 fb ff ff       	jmp    80106589 <alltraps>

80106a87 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $2
80106a89:	6a 02                	push   $0x2
  jmp alltraps
80106a8b:	e9 f9 fa ff ff       	jmp    80106589 <alltraps>

80106a90 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $3
80106a92:	6a 03                	push   $0x3
  jmp alltraps
80106a94:	e9 f0 fa ff ff       	jmp    80106589 <alltraps>

80106a99 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $4
80106a9b:	6a 04                	push   $0x4
  jmp alltraps
80106a9d:	e9 e7 fa ff ff       	jmp    80106589 <alltraps>

80106aa2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106aa2:	6a 00                	push   $0x0
  pushl $5
80106aa4:	6a 05                	push   $0x5
  jmp alltraps
80106aa6:	e9 de fa ff ff       	jmp    80106589 <alltraps>

80106aab <vector6>:
.globl vector6
vector6:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $6
80106aad:	6a 06                	push   $0x6
  jmp alltraps
80106aaf:	e9 d5 fa ff ff       	jmp    80106589 <alltraps>

80106ab4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ab4:	6a 00                	push   $0x0
  pushl $7
80106ab6:	6a 07                	push   $0x7
  jmp alltraps
80106ab8:	e9 cc fa ff ff       	jmp    80106589 <alltraps>

80106abd <vector8>:
.globl vector8
vector8:
  pushl $8
80106abd:	6a 08                	push   $0x8
  jmp alltraps
80106abf:	e9 c5 fa ff ff       	jmp    80106589 <alltraps>

80106ac4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $9
80106ac6:	6a 09                	push   $0x9
  jmp alltraps
80106ac8:	e9 bc fa ff ff       	jmp    80106589 <alltraps>

80106acd <vector10>:
.globl vector10
vector10:
  pushl $10
80106acd:	6a 0a                	push   $0xa
  jmp alltraps
80106acf:	e9 b5 fa ff ff       	jmp    80106589 <alltraps>

80106ad4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106ad4:	6a 0b                	push   $0xb
  jmp alltraps
80106ad6:	e9 ae fa ff ff       	jmp    80106589 <alltraps>

80106adb <vector12>:
.globl vector12
vector12:
  pushl $12
80106adb:	6a 0c                	push   $0xc
  jmp alltraps
80106add:	e9 a7 fa ff ff       	jmp    80106589 <alltraps>

80106ae2 <vector13>:
.globl vector13
vector13:
  pushl $13
80106ae2:	6a 0d                	push   $0xd
  jmp alltraps
80106ae4:	e9 a0 fa ff ff       	jmp    80106589 <alltraps>

80106ae9 <vector14>:
.globl vector14
vector14:
  pushl $14
80106ae9:	6a 0e                	push   $0xe
  jmp alltraps
80106aeb:	e9 99 fa ff ff       	jmp    80106589 <alltraps>

80106af0 <vector15>:
.globl vector15
vector15:
  pushl $0
80106af0:	6a 00                	push   $0x0
  pushl $15
80106af2:	6a 0f                	push   $0xf
  jmp alltraps
80106af4:	e9 90 fa ff ff       	jmp    80106589 <alltraps>

80106af9 <vector16>:
.globl vector16
vector16:
  pushl $0
80106af9:	6a 00                	push   $0x0
  pushl $16
80106afb:	6a 10                	push   $0x10
  jmp alltraps
80106afd:	e9 87 fa ff ff       	jmp    80106589 <alltraps>

80106b02 <vector17>:
.globl vector17
vector17:
  pushl $17
80106b02:	6a 11                	push   $0x11
  jmp alltraps
80106b04:	e9 80 fa ff ff       	jmp    80106589 <alltraps>

80106b09 <vector18>:
.globl vector18
vector18:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $18
80106b0b:	6a 12                	push   $0x12
  jmp alltraps
80106b0d:	e9 77 fa ff ff       	jmp    80106589 <alltraps>

80106b12 <vector19>:
.globl vector19
vector19:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $19
80106b14:	6a 13                	push   $0x13
  jmp alltraps
80106b16:	e9 6e fa ff ff       	jmp    80106589 <alltraps>

80106b1b <vector20>:
.globl vector20
vector20:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $20
80106b1d:	6a 14                	push   $0x14
  jmp alltraps
80106b1f:	e9 65 fa ff ff       	jmp    80106589 <alltraps>

80106b24 <vector21>:
.globl vector21
vector21:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $21
80106b26:	6a 15                	push   $0x15
  jmp alltraps
80106b28:	e9 5c fa ff ff       	jmp    80106589 <alltraps>

80106b2d <vector22>:
.globl vector22
vector22:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $22
80106b2f:	6a 16                	push   $0x16
  jmp alltraps
80106b31:	e9 53 fa ff ff       	jmp    80106589 <alltraps>

80106b36 <vector23>:
.globl vector23
vector23:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $23
80106b38:	6a 17                	push   $0x17
  jmp alltraps
80106b3a:	e9 4a fa ff ff       	jmp    80106589 <alltraps>

80106b3f <vector24>:
.globl vector24
vector24:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $24
80106b41:	6a 18                	push   $0x18
  jmp alltraps
80106b43:	e9 41 fa ff ff       	jmp    80106589 <alltraps>

80106b48 <vector25>:
.globl vector25
vector25:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $25
80106b4a:	6a 19                	push   $0x19
  jmp alltraps
80106b4c:	e9 38 fa ff ff       	jmp    80106589 <alltraps>

80106b51 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $26
80106b53:	6a 1a                	push   $0x1a
  jmp alltraps
80106b55:	e9 2f fa ff ff       	jmp    80106589 <alltraps>

80106b5a <vector27>:
.globl vector27
vector27:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $27
80106b5c:	6a 1b                	push   $0x1b
  jmp alltraps
80106b5e:	e9 26 fa ff ff       	jmp    80106589 <alltraps>

80106b63 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $28
80106b65:	6a 1c                	push   $0x1c
  jmp alltraps
80106b67:	e9 1d fa ff ff       	jmp    80106589 <alltraps>

80106b6c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $29
80106b6e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b70:	e9 14 fa ff ff       	jmp    80106589 <alltraps>

80106b75 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $30
80106b77:	6a 1e                	push   $0x1e
  jmp alltraps
80106b79:	e9 0b fa ff ff       	jmp    80106589 <alltraps>

80106b7e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $31
80106b80:	6a 1f                	push   $0x1f
  jmp alltraps
80106b82:	e9 02 fa ff ff       	jmp    80106589 <alltraps>

80106b87 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $32
80106b89:	6a 20                	push   $0x20
  jmp alltraps
80106b8b:	e9 f9 f9 ff ff       	jmp    80106589 <alltraps>

80106b90 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $33
80106b92:	6a 21                	push   $0x21
  jmp alltraps
80106b94:	e9 f0 f9 ff ff       	jmp    80106589 <alltraps>

80106b99 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $34
80106b9b:	6a 22                	push   $0x22
  jmp alltraps
80106b9d:	e9 e7 f9 ff ff       	jmp    80106589 <alltraps>

80106ba2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $35
80106ba4:	6a 23                	push   $0x23
  jmp alltraps
80106ba6:	e9 de f9 ff ff       	jmp    80106589 <alltraps>

80106bab <vector36>:
.globl vector36
vector36:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $36
80106bad:	6a 24                	push   $0x24
  jmp alltraps
80106baf:	e9 d5 f9 ff ff       	jmp    80106589 <alltraps>

80106bb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $37
80106bb6:	6a 25                	push   $0x25
  jmp alltraps
80106bb8:	e9 cc f9 ff ff       	jmp    80106589 <alltraps>

80106bbd <vector38>:
.globl vector38
vector38:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $38
80106bbf:	6a 26                	push   $0x26
  jmp alltraps
80106bc1:	e9 c3 f9 ff ff       	jmp    80106589 <alltraps>

80106bc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $39
80106bc8:	6a 27                	push   $0x27
  jmp alltraps
80106bca:	e9 ba f9 ff ff       	jmp    80106589 <alltraps>

80106bcf <vector40>:
.globl vector40
vector40:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $40
80106bd1:	6a 28                	push   $0x28
  jmp alltraps
80106bd3:	e9 b1 f9 ff ff       	jmp    80106589 <alltraps>

80106bd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $41
80106bda:	6a 29                	push   $0x29
  jmp alltraps
80106bdc:	e9 a8 f9 ff ff       	jmp    80106589 <alltraps>

80106be1 <vector42>:
.globl vector42
vector42:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $42
80106be3:	6a 2a                	push   $0x2a
  jmp alltraps
80106be5:	e9 9f f9 ff ff       	jmp    80106589 <alltraps>

80106bea <vector43>:
.globl vector43
vector43:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $43
80106bec:	6a 2b                	push   $0x2b
  jmp alltraps
80106bee:	e9 96 f9 ff ff       	jmp    80106589 <alltraps>

80106bf3 <vector44>:
.globl vector44
vector44:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $44
80106bf5:	6a 2c                	push   $0x2c
  jmp alltraps
80106bf7:	e9 8d f9 ff ff       	jmp    80106589 <alltraps>

80106bfc <vector45>:
.globl vector45
vector45:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $45
80106bfe:	6a 2d                	push   $0x2d
  jmp alltraps
80106c00:	e9 84 f9 ff ff       	jmp    80106589 <alltraps>

80106c05 <vector46>:
.globl vector46
vector46:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $46
80106c07:	6a 2e                	push   $0x2e
  jmp alltraps
80106c09:	e9 7b f9 ff ff       	jmp    80106589 <alltraps>

80106c0e <vector47>:
.globl vector47
vector47:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $47
80106c10:	6a 2f                	push   $0x2f
  jmp alltraps
80106c12:	e9 72 f9 ff ff       	jmp    80106589 <alltraps>

80106c17 <vector48>:
.globl vector48
vector48:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $48
80106c19:	6a 30                	push   $0x30
  jmp alltraps
80106c1b:	e9 69 f9 ff ff       	jmp    80106589 <alltraps>

80106c20 <vector49>:
.globl vector49
vector49:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $49
80106c22:	6a 31                	push   $0x31
  jmp alltraps
80106c24:	e9 60 f9 ff ff       	jmp    80106589 <alltraps>

80106c29 <vector50>:
.globl vector50
vector50:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $50
80106c2b:	6a 32                	push   $0x32
  jmp alltraps
80106c2d:	e9 57 f9 ff ff       	jmp    80106589 <alltraps>

80106c32 <vector51>:
.globl vector51
vector51:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $51
80106c34:	6a 33                	push   $0x33
  jmp alltraps
80106c36:	e9 4e f9 ff ff       	jmp    80106589 <alltraps>

80106c3b <vector52>:
.globl vector52
vector52:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $52
80106c3d:	6a 34                	push   $0x34
  jmp alltraps
80106c3f:	e9 45 f9 ff ff       	jmp    80106589 <alltraps>

80106c44 <vector53>:
.globl vector53
vector53:
  pushl $0
80106c44:	6a 00                	push   $0x0
  pushl $53
80106c46:	6a 35                	push   $0x35
  jmp alltraps
80106c48:	e9 3c f9 ff ff       	jmp    80106589 <alltraps>

80106c4d <vector54>:
.globl vector54
vector54:
  pushl $0
80106c4d:	6a 00                	push   $0x0
  pushl $54
80106c4f:	6a 36                	push   $0x36
  jmp alltraps
80106c51:	e9 33 f9 ff ff       	jmp    80106589 <alltraps>

80106c56 <vector55>:
.globl vector55
vector55:
  pushl $0
80106c56:	6a 00                	push   $0x0
  pushl $55
80106c58:	6a 37                	push   $0x37
  jmp alltraps
80106c5a:	e9 2a f9 ff ff       	jmp    80106589 <alltraps>

80106c5f <vector56>:
.globl vector56
vector56:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $56
80106c61:	6a 38                	push   $0x38
  jmp alltraps
80106c63:	e9 21 f9 ff ff       	jmp    80106589 <alltraps>

80106c68 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c68:	6a 00                	push   $0x0
  pushl $57
80106c6a:	6a 39                	push   $0x39
  jmp alltraps
80106c6c:	e9 18 f9 ff ff       	jmp    80106589 <alltraps>

80106c71 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c71:	6a 00                	push   $0x0
  pushl $58
80106c73:	6a 3a                	push   $0x3a
  jmp alltraps
80106c75:	e9 0f f9 ff ff       	jmp    80106589 <alltraps>

80106c7a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c7a:	6a 00                	push   $0x0
  pushl $59
80106c7c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c7e:	e9 06 f9 ff ff       	jmp    80106589 <alltraps>

80106c83 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $60
80106c85:	6a 3c                	push   $0x3c
  jmp alltraps
80106c87:	e9 fd f8 ff ff       	jmp    80106589 <alltraps>

80106c8c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c8c:	6a 00                	push   $0x0
  pushl $61
80106c8e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c90:	e9 f4 f8 ff ff       	jmp    80106589 <alltraps>

80106c95 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c95:	6a 00                	push   $0x0
  pushl $62
80106c97:	6a 3e                	push   $0x3e
  jmp alltraps
80106c99:	e9 eb f8 ff ff       	jmp    80106589 <alltraps>

80106c9e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c9e:	6a 00                	push   $0x0
  pushl $63
80106ca0:	6a 3f                	push   $0x3f
  jmp alltraps
80106ca2:	e9 e2 f8 ff ff       	jmp    80106589 <alltraps>

80106ca7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $64
80106ca9:	6a 40                	push   $0x40
  jmp alltraps
80106cab:	e9 d9 f8 ff ff       	jmp    80106589 <alltraps>

80106cb0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106cb0:	6a 00                	push   $0x0
  pushl $65
80106cb2:	6a 41                	push   $0x41
  jmp alltraps
80106cb4:	e9 d0 f8 ff ff       	jmp    80106589 <alltraps>

80106cb9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106cb9:	6a 00                	push   $0x0
  pushl $66
80106cbb:	6a 42                	push   $0x42
  jmp alltraps
80106cbd:	e9 c7 f8 ff ff       	jmp    80106589 <alltraps>

80106cc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106cc2:	6a 00                	push   $0x0
  pushl $67
80106cc4:	6a 43                	push   $0x43
  jmp alltraps
80106cc6:	e9 be f8 ff ff       	jmp    80106589 <alltraps>

80106ccb <vector68>:
.globl vector68
vector68:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $68
80106ccd:	6a 44                	push   $0x44
  jmp alltraps
80106ccf:	e9 b5 f8 ff ff       	jmp    80106589 <alltraps>

80106cd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106cd4:	6a 00                	push   $0x0
  pushl $69
80106cd6:	6a 45                	push   $0x45
  jmp alltraps
80106cd8:	e9 ac f8 ff ff       	jmp    80106589 <alltraps>

80106cdd <vector70>:
.globl vector70
vector70:
  pushl $0
80106cdd:	6a 00                	push   $0x0
  pushl $70
80106cdf:	6a 46                	push   $0x46
  jmp alltraps
80106ce1:	e9 a3 f8 ff ff       	jmp    80106589 <alltraps>

80106ce6 <vector71>:
.globl vector71
vector71:
  pushl $0
80106ce6:	6a 00                	push   $0x0
  pushl $71
80106ce8:	6a 47                	push   $0x47
  jmp alltraps
80106cea:	e9 9a f8 ff ff       	jmp    80106589 <alltraps>

80106cef <vector72>:
.globl vector72
vector72:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $72
80106cf1:	6a 48                	push   $0x48
  jmp alltraps
80106cf3:	e9 91 f8 ff ff       	jmp    80106589 <alltraps>

80106cf8 <vector73>:
.globl vector73
vector73:
  pushl $0
80106cf8:	6a 00                	push   $0x0
  pushl $73
80106cfa:	6a 49                	push   $0x49
  jmp alltraps
80106cfc:	e9 88 f8 ff ff       	jmp    80106589 <alltraps>

80106d01 <vector74>:
.globl vector74
vector74:
  pushl $0
80106d01:	6a 00                	push   $0x0
  pushl $74
80106d03:	6a 4a                	push   $0x4a
  jmp alltraps
80106d05:	e9 7f f8 ff ff       	jmp    80106589 <alltraps>

80106d0a <vector75>:
.globl vector75
vector75:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $75
80106d0c:	6a 4b                	push   $0x4b
  jmp alltraps
80106d0e:	e9 76 f8 ff ff       	jmp    80106589 <alltraps>

80106d13 <vector76>:
.globl vector76
vector76:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $76
80106d15:	6a 4c                	push   $0x4c
  jmp alltraps
80106d17:	e9 6d f8 ff ff       	jmp    80106589 <alltraps>

80106d1c <vector77>:
.globl vector77
vector77:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $77
80106d1e:	6a 4d                	push   $0x4d
  jmp alltraps
80106d20:	e9 64 f8 ff ff       	jmp    80106589 <alltraps>

80106d25 <vector78>:
.globl vector78
vector78:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $78
80106d27:	6a 4e                	push   $0x4e
  jmp alltraps
80106d29:	e9 5b f8 ff ff       	jmp    80106589 <alltraps>

80106d2e <vector79>:
.globl vector79
vector79:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $79
80106d30:	6a 4f                	push   $0x4f
  jmp alltraps
80106d32:	e9 52 f8 ff ff       	jmp    80106589 <alltraps>

80106d37 <vector80>:
.globl vector80
vector80:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $80
80106d39:	6a 50                	push   $0x50
  jmp alltraps
80106d3b:	e9 49 f8 ff ff       	jmp    80106589 <alltraps>

80106d40 <vector81>:
.globl vector81
vector81:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $81
80106d42:	6a 51                	push   $0x51
  jmp alltraps
80106d44:	e9 40 f8 ff ff       	jmp    80106589 <alltraps>

80106d49 <vector82>:
.globl vector82
vector82:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $82
80106d4b:	6a 52                	push   $0x52
  jmp alltraps
80106d4d:	e9 37 f8 ff ff       	jmp    80106589 <alltraps>

80106d52 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d52:	6a 00                	push   $0x0
  pushl $83
80106d54:	6a 53                	push   $0x53
  jmp alltraps
80106d56:	e9 2e f8 ff ff       	jmp    80106589 <alltraps>

80106d5b <vector84>:
.globl vector84
vector84:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $84
80106d5d:	6a 54                	push   $0x54
  jmp alltraps
80106d5f:	e9 25 f8 ff ff       	jmp    80106589 <alltraps>

80106d64 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d64:	6a 00                	push   $0x0
  pushl $85
80106d66:	6a 55                	push   $0x55
  jmp alltraps
80106d68:	e9 1c f8 ff ff       	jmp    80106589 <alltraps>

80106d6d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d6d:	6a 00                	push   $0x0
  pushl $86
80106d6f:	6a 56                	push   $0x56
  jmp alltraps
80106d71:	e9 13 f8 ff ff       	jmp    80106589 <alltraps>

80106d76 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d76:	6a 00                	push   $0x0
  pushl $87
80106d78:	6a 57                	push   $0x57
  jmp alltraps
80106d7a:	e9 0a f8 ff ff       	jmp    80106589 <alltraps>

80106d7f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $88
80106d81:	6a 58                	push   $0x58
  jmp alltraps
80106d83:	e9 01 f8 ff ff       	jmp    80106589 <alltraps>

80106d88 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d88:	6a 00                	push   $0x0
  pushl $89
80106d8a:	6a 59                	push   $0x59
  jmp alltraps
80106d8c:	e9 f8 f7 ff ff       	jmp    80106589 <alltraps>

80106d91 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d91:	6a 00                	push   $0x0
  pushl $90
80106d93:	6a 5a                	push   $0x5a
  jmp alltraps
80106d95:	e9 ef f7 ff ff       	jmp    80106589 <alltraps>

80106d9a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d9a:	6a 00                	push   $0x0
  pushl $91
80106d9c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d9e:	e9 e6 f7 ff ff       	jmp    80106589 <alltraps>

80106da3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $92
80106da5:	6a 5c                	push   $0x5c
  jmp alltraps
80106da7:	e9 dd f7 ff ff       	jmp    80106589 <alltraps>

80106dac <vector93>:
.globl vector93
vector93:
  pushl $0
80106dac:	6a 00                	push   $0x0
  pushl $93
80106dae:	6a 5d                	push   $0x5d
  jmp alltraps
80106db0:	e9 d4 f7 ff ff       	jmp    80106589 <alltraps>

80106db5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106db5:	6a 00                	push   $0x0
  pushl $94
80106db7:	6a 5e                	push   $0x5e
  jmp alltraps
80106db9:	e9 cb f7 ff ff       	jmp    80106589 <alltraps>

80106dbe <vector95>:
.globl vector95
vector95:
  pushl $0
80106dbe:	6a 00                	push   $0x0
  pushl $95
80106dc0:	6a 5f                	push   $0x5f
  jmp alltraps
80106dc2:	e9 c2 f7 ff ff       	jmp    80106589 <alltraps>

80106dc7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $96
80106dc9:	6a 60                	push   $0x60
  jmp alltraps
80106dcb:	e9 b9 f7 ff ff       	jmp    80106589 <alltraps>

80106dd0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106dd0:	6a 00                	push   $0x0
  pushl $97
80106dd2:	6a 61                	push   $0x61
  jmp alltraps
80106dd4:	e9 b0 f7 ff ff       	jmp    80106589 <alltraps>

80106dd9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106dd9:	6a 00                	push   $0x0
  pushl $98
80106ddb:	6a 62                	push   $0x62
  jmp alltraps
80106ddd:	e9 a7 f7 ff ff       	jmp    80106589 <alltraps>

80106de2 <vector99>:
.globl vector99
vector99:
  pushl $0
80106de2:	6a 00                	push   $0x0
  pushl $99
80106de4:	6a 63                	push   $0x63
  jmp alltraps
80106de6:	e9 9e f7 ff ff       	jmp    80106589 <alltraps>

80106deb <vector100>:
.globl vector100
vector100:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $100
80106ded:	6a 64                	push   $0x64
  jmp alltraps
80106def:	e9 95 f7 ff ff       	jmp    80106589 <alltraps>

80106df4 <vector101>:
.globl vector101
vector101:
  pushl $0
80106df4:	6a 00                	push   $0x0
  pushl $101
80106df6:	6a 65                	push   $0x65
  jmp alltraps
80106df8:	e9 8c f7 ff ff       	jmp    80106589 <alltraps>

80106dfd <vector102>:
.globl vector102
vector102:
  pushl $0
80106dfd:	6a 00                	push   $0x0
  pushl $102
80106dff:	6a 66                	push   $0x66
  jmp alltraps
80106e01:	e9 83 f7 ff ff       	jmp    80106589 <alltraps>

80106e06 <vector103>:
.globl vector103
vector103:
  pushl $0
80106e06:	6a 00                	push   $0x0
  pushl $103
80106e08:	6a 67                	push   $0x67
  jmp alltraps
80106e0a:	e9 7a f7 ff ff       	jmp    80106589 <alltraps>

80106e0f <vector104>:
.globl vector104
vector104:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $104
80106e11:	6a 68                	push   $0x68
  jmp alltraps
80106e13:	e9 71 f7 ff ff       	jmp    80106589 <alltraps>

80106e18 <vector105>:
.globl vector105
vector105:
  pushl $0
80106e18:	6a 00                	push   $0x0
  pushl $105
80106e1a:	6a 69                	push   $0x69
  jmp alltraps
80106e1c:	e9 68 f7 ff ff       	jmp    80106589 <alltraps>

80106e21 <vector106>:
.globl vector106
vector106:
  pushl $0
80106e21:	6a 00                	push   $0x0
  pushl $106
80106e23:	6a 6a                	push   $0x6a
  jmp alltraps
80106e25:	e9 5f f7 ff ff       	jmp    80106589 <alltraps>

80106e2a <vector107>:
.globl vector107
vector107:
  pushl $0
80106e2a:	6a 00                	push   $0x0
  pushl $107
80106e2c:	6a 6b                	push   $0x6b
  jmp alltraps
80106e2e:	e9 56 f7 ff ff       	jmp    80106589 <alltraps>

80106e33 <vector108>:
.globl vector108
vector108:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $108
80106e35:	6a 6c                	push   $0x6c
  jmp alltraps
80106e37:	e9 4d f7 ff ff       	jmp    80106589 <alltraps>

80106e3c <vector109>:
.globl vector109
vector109:
  pushl $0
80106e3c:	6a 00                	push   $0x0
  pushl $109
80106e3e:	6a 6d                	push   $0x6d
  jmp alltraps
80106e40:	e9 44 f7 ff ff       	jmp    80106589 <alltraps>

80106e45 <vector110>:
.globl vector110
vector110:
  pushl $0
80106e45:	6a 00                	push   $0x0
  pushl $110
80106e47:	6a 6e                	push   $0x6e
  jmp alltraps
80106e49:	e9 3b f7 ff ff       	jmp    80106589 <alltraps>

80106e4e <vector111>:
.globl vector111
vector111:
  pushl $0
80106e4e:	6a 00                	push   $0x0
  pushl $111
80106e50:	6a 6f                	push   $0x6f
  jmp alltraps
80106e52:	e9 32 f7 ff ff       	jmp    80106589 <alltraps>

80106e57 <vector112>:
.globl vector112
vector112:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $112
80106e59:	6a 70                	push   $0x70
  jmp alltraps
80106e5b:	e9 29 f7 ff ff       	jmp    80106589 <alltraps>

80106e60 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e60:	6a 00                	push   $0x0
  pushl $113
80106e62:	6a 71                	push   $0x71
  jmp alltraps
80106e64:	e9 20 f7 ff ff       	jmp    80106589 <alltraps>

80106e69 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e69:	6a 00                	push   $0x0
  pushl $114
80106e6b:	6a 72                	push   $0x72
  jmp alltraps
80106e6d:	e9 17 f7 ff ff       	jmp    80106589 <alltraps>

80106e72 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e72:	6a 00                	push   $0x0
  pushl $115
80106e74:	6a 73                	push   $0x73
  jmp alltraps
80106e76:	e9 0e f7 ff ff       	jmp    80106589 <alltraps>

80106e7b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $116
80106e7d:	6a 74                	push   $0x74
  jmp alltraps
80106e7f:	e9 05 f7 ff ff       	jmp    80106589 <alltraps>

80106e84 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e84:	6a 00                	push   $0x0
  pushl $117
80106e86:	6a 75                	push   $0x75
  jmp alltraps
80106e88:	e9 fc f6 ff ff       	jmp    80106589 <alltraps>

80106e8d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e8d:	6a 00                	push   $0x0
  pushl $118
80106e8f:	6a 76                	push   $0x76
  jmp alltraps
80106e91:	e9 f3 f6 ff ff       	jmp    80106589 <alltraps>

80106e96 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e96:	6a 00                	push   $0x0
  pushl $119
80106e98:	6a 77                	push   $0x77
  jmp alltraps
80106e9a:	e9 ea f6 ff ff       	jmp    80106589 <alltraps>

80106e9f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $120
80106ea1:	6a 78                	push   $0x78
  jmp alltraps
80106ea3:	e9 e1 f6 ff ff       	jmp    80106589 <alltraps>

80106ea8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ea8:	6a 00                	push   $0x0
  pushl $121
80106eaa:	6a 79                	push   $0x79
  jmp alltraps
80106eac:	e9 d8 f6 ff ff       	jmp    80106589 <alltraps>

80106eb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106eb1:	6a 00                	push   $0x0
  pushl $122
80106eb3:	6a 7a                	push   $0x7a
  jmp alltraps
80106eb5:	e9 cf f6 ff ff       	jmp    80106589 <alltraps>

80106eba <vector123>:
.globl vector123
vector123:
  pushl $0
80106eba:	6a 00                	push   $0x0
  pushl $123
80106ebc:	6a 7b                	push   $0x7b
  jmp alltraps
80106ebe:	e9 c6 f6 ff ff       	jmp    80106589 <alltraps>

80106ec3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $124
80106ec5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ec7:	e9 bd f6 ff ff       	jmp    80106589 <alltraps>

80106ecc <vector125>:
.globl vector125
vector125:
  pushl $0
80106ecc:	6a 00                	push   $0x0
  pushl $125
80106ece:	6a 7d                	push   $0x7d
  jmp alltraps
80106ed0:	e9 b4 f6 ff ff       	jmp    80106589 <alltraps>

80106ed5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ed5:	6a 00                	push   $0x0
  pushl $126
80106ed7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ed9:	e9 ab f6 ff ff       	jmp    80106589 <alltraps>

80106ede <vector127>:
.globl vector127
vector127:
  pushl $0
80106ede:	6a 00                	push   $0x0
  pushl $127
80106ee0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ee2:	e9 a2 f6 ff ff       	jmp    80106589 <alltraps>

80106ee7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $128
80106ee9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106eee:	e9 96 f6 ff ff       	jmp    80106589 <alltraps>

80106ef3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $129
80106ef5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106efa:	e9 8a f6 ff ff       	jmp    80106589 <alltraps>

80106eff <vector130>:
.globl vector130
vector130:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $130
80106f01:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106f06:	e9 7e f6 ff ff       	jmp    80106589 <alltraps>

80106f0b <vector131>:
.globl vector131
vector131:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $131
80106f0d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106f12:	e9 72 f6 ff ff       	jmp    80106589 <alltraps>

80106f17 <vector132>:
.globl vector132
vector132:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $132
80106f19:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106f1e:	e9 66 f6 ff ff       	jmp    80106589 <alltraps>

80106f23 <vector133>:
.globl vector133
vector133:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $133
80106f25:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106f2a:	e9 5a f6 ff ff       	jmp    80106589 <alltraps>

80106f2f <vector134>:
.globl vector134
vector134:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $134
80106f31:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106f36:	e9 4e f6 ff ff       	jmp    80106589 <alltraps>

80106f3b <vector135>:
.globl vector135
vector135:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $135
80106f3d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106f42:	e9 42 f6 ff ff       	jmp    80106589 <alltraps>

80106f47 <vector136>:
.globl vector136
vector136:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $136
80106f49:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f4e:	e9 36 f6 ff ff       	jmp    80106589 <alltraps>

80106f53 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $137
80106f55:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f5a:	e9 2a f6 ff ff       	jmp    80106589 <alltraps>

80106f5f <vector138>:
.globl vector138
vector138:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $138
80106f61:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f66:	e9 1e f6 ff ff       	jmp    80106589 <alltraps>

80106f6b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $139
80106f6d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f72:	e9 12 f6 ff ff       	jmp    80106589 <alltraps>

80106f77 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $140
80106f79:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f7e:	e9 06 f6 ff ff       	jmp    80106589 <alltraps>

80106f83 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $141
80106f85:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f8a:	e9 fa f5 ff ff       	jmp    80106589 <alltraps>

80106f8f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $142
80106f91:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f96:	e9 ee f5 ff ff       	jmp    80106589 <alltraps>

80106f9b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $143
80106f9d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106fa2:	e9 e2 f5 ff ff       	jmp    80106589 <alltraps>

80106fa7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $144
80106fa9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106fae:	e9 d6 f5 ff ff       	jmp    80106589 <alltraps>

80106fb3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $145
80106fb5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106fba:	e9 ca f5 ff ff       	jmp    80106589 <alltraps>

80106fbf <vector146>:
.globl vector146
vector146:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $146
80106fc1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106fc6:	e9 be f5 ff ff       	jmp    80106589 <alltraps>

80106fcb <vector147>:
.globl vector147
vector147:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $147
80106fcd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106fd2:	e9 b2 f5 ff ff       	jmp    80106589 <alltraps>

80106fd7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $148
80106fd9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106fde:	e9 a6 f5 ff ff       	jmp    80106589 <alltraps>

80106fe3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $149
80106fe5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106fea:	e9 9a f5 ff ff       	jmp    80106589 <alltraps>

80106fef <vector150>:
.globl vector150
vector150:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $150
80106ff1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106ff6:	e9 8e f5 ff ff       	jmp    80106589 <alltraps>

80106ffb <vector151>:
.globl vector151
vector151:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $151
80106ffd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107002:	e9 82 f5 ff ff       	jmp    80106589 <alltraps>

80107007 <vector152>:
.globl vector152
vector152:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $152
80107009:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010700e:	e9 76 f5 ff ff       	jmp    80106589 <alltraps>

80107013 <vector153>:
.globl vector153
vector153:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $153
80107015:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010701a:	e9 6a f5 ff ff       	jmp    80106589 <alltraps>

8010701f <vector154>:
.globl vector154
vector154:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $154
80107021:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107026:	e9 5e f5 ff ff       	jmp    80106589 <alltraps>

8010702b <vector155>:
.globl vector155
vector155:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $155
8010702d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107032:	e9 52 f5 ff ff       	jmp    80106589 <alltraps>

80107037 <vector156>:
.globl vector156
vector156:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $156
80107039:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010703e:	e9 46 f5 ff ff       	jmp    80106589 <alltraps>

80107043 <vector157>:
.globl vector157
vector157:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $157
80107045:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010704a:	e9 3a f5 ff ff       	jmp    80106589 <alltraps>

8010704f <vector158>:
.globl vector158
vector158:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $158
80107051:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107056:	e9 2e f5 ff ff       	jmp    80106589 <alltraps>

8010705b <vector159>:
.globl vector159
vector159:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $159
8010705d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107062:	e9 22 f5 ff ff       	jmp    80106589 <alltraps>

80107067 <vector160>:
.globl vector160
vector160:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $160
80107069:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010706e:	e9 16 f5 ff ff       	jmp    80106589 <alltraps>

80107073 <vector161>:
.globl vector161
vector161:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $161
80107075:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010707a:	e9 0a f5 ff ff       	jmp    80106589 <alltraps>

8010707f <vector162>:
.globl vector162
vector162:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $162
80107081:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107086:	e9 fe f4 ff ff       	jmp    80106589 <alltraps>

8010708b <vector163>:
.globl vector163
vector163:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $163
8010708d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107092:	e9 f2 f4 ff ff       	jmp    80106589 <alltraps>

80107097 <vector164>:
.globl vector164
vector164:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $164
80107099:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010709e:	e9 e6 f4 ff ff       	jmp    80106589 <alltraps>

801070a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $165
801070a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801070aa:	e9 da f4 ff ff       	jmp    80106589 <alltraps>

801070af <vector166>:
.globl vector166
vector166:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $166
801070b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801070b6:	e9 ce f4 ff ff       	jmp    80106589 <alltraps>

801070bb <vector167>:
.globl vector167
vector167:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $167
801070bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801070c2:	e9 c2 f4 ff ff       	jmp    80106589 <alltraps>

801070c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $168
801070c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801070ce:	e9 b6 f4 ff ff       	jmp    80106589 <alltraps>

801070d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $169
801070d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801070da:	e9 aa f4 ff ff       	jmp    80106589 <alltraps>

801070df <vector170>:
.globl vector170
vector170:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $170
801070e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801070e6:	e9 9e f4 ff ff       	jmp    80106589 <alltraps>

801070eb <vector171>:
.globl vector171
vector171:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $171
801070ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801070f2:	e9 92 f4 ff ff       	jmp    80106589 <alltraps>

801070f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $172
801070f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801070fe:	e9 86 f4 ff ff       	jmp    80106589 <alltraps>

80107103 <vector173>:
.globl vector173
vector173:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $173
80107105:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010710a:	e9 7a f4 ff ff       	jmp    80106589 <alltraps>

8010710f <vector174>:
.globl vector174
vector174:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $174
80107111:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107116:	e9 6e f4 ff ff       	jmp    80106589 <alltraps>

8010711b <vector175>:
.globl vector175
vector175:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $175
8010711d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107122:	e9 62 f4 ff ff       	jmp    80106589 <alltraps>

80107127 <vector176>:
.globl vector176
vector176:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $176
80107129:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010712e:	e9 56 f4 ff ff       	jmp    80106589 <alltraps>

80107133 <vector177>:
.globl vector177
vector177:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $177
80107135:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010713a:	e9 4a f4 ff ff       	jmp    80106589 <alltraps>

8010713f <vector178>:
.globl vector178
vector178:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $178
80107141:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107146:	e9 3e f4 ff ff       	jmp    80106589 <alltraps>

8010714b <vector179>:
.globl vector179
vector179:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $179
8010714d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107152:	e9 32 f4 ff ff       	jmp    80106589 <alltraps>

80107157 <vector180>:
.globl vector180
vector180:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $180
80107159:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010715e:	e9 26 f4 ff ff       	jmp    80106589 <alltraps>

80107163 <vector181>:
.globl vector181
vector181:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $181
80107165:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010716a:	e9 1a f4 ff ff       	jmp    80106589 <alltraps>

8010716f <vector182>:
.globl vector182
vector182:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $182
80107171:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107176:	e9 0e f4 ff ff       	jmp    80106589 <alltraps>

8010717b <vector183>:
.globl vector183
vector183:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $183
8010717d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107182:	e9 02 f4 ff ff       	jmp    80106589 <alltraps>

80107187 <vector184>:
.globl vector184
vector184:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $184
80107189:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010718e:	e9 f6 f3 ff ff       	jmp    80106589 <alltraps>

80107193 <vector185>:
.globl vector185
vector185:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $185
80107195:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010719a:	e9 ea f3 ff ff       	jmp    80106589 <alltraps>

8010719f <vector186>:
.globl vector186
vector186:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $186
801071a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801071a6:	e9 de f3 ff ff       	jmp    80106589 <alltraps>

801071ab <vector187>:
.globl vector187
vector187:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $187
801071ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801071b2:	e9 d2 f3 ff ff       	jmp    80106589 <alltraps>

801071b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $188
801071b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801071be:	e9 c6 f3 ff ff       	jmp    80106589 <alltraps>

801071c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $189
801071c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801071ca:	e9 ba f3 ff ff       	jmp    80106589 <alltraps>

801071cf <vector190>:
.globl vector190
vector190:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $190
801071d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801071d6:	e9 ae f3 ff ff       	jmp    80106589 <alltraps>

801071db <vector191>:
.globl vector191
vector191:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $191
801071dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801071e2:	e9 a2 f3 ff ff       	jmp    80106589 <alltraps>

801071e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $192
801071e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801071ee:	e9 96 f3 ff ff       	jmp    80106589 <alltraps>

801071f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $193
801071f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801071fa:	e9 8a f3 ff ff       	jmp    80106589 <alltraps>

801071ff <vector194>:
.globl vector194
vector194:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $194
80107201:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107206:	e9 7e f3 ff ff       	jmp    80106589 <alltraps>

8010720b <vector195>:
.globl vector195
vector195:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $195
8010720d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107212:	e9 72 f3 ff ff       	jmp    80106589 <alltraps>

80107217 <vector196>:
.globl vector196
vector196:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $196
80107219:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010721e:	e9 66 f3 ff ff       	jmp    80106589 <alltraps>

80107223 <vector197>:
.globl vector197
vector197:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $197
80107225:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010722a:	e9 5a f3 ff ff       	jmp    80106589 <alltraps>

8010722f <vector198>:
.globl vector198
vector198:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $198
80107231:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107236:	e9 4e f3 ff ff       	jmp    80106589 <alltraps>

8010723b <vector199>:
.globl vector199
vector199:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $199
8010723d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107242:	e9 42 f3 ff ff       	jmp    80106589 <alltraps>

80107247 <vector200>:
.globl vector200
vector200:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $200
80107249:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010724e:	e9 36 f3 ff ff       	jmp    80106589 <alltraps>

80107253 <vector201>:
.globl vector201
vector201:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $201
80107255:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010725a:	e9 2a f3 ff ff       	jmp    80106589 <alltraps>

8010725f <vector202>:
.globl vector202
vector202:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $202
80107261:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107266:	e9 1e f3 ff ff       	jmp    80106589 <alltraps>

8010726b <vector203>:
.globl vector203
vector203:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $203
8010726d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107272:	e9 12 f3 ff ff       	jmp    80106589 <alltraps>

80107277 <vector204>:
.globl vector204
vector204:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $204
80107279:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010727e:	e9 06 f3 ff ff       	jmp    80106589 <alltraps>

80107283 <vector205>:
.globl vector205
vector205:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $205
80107285:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010728a:	e9 fa f2 ff ff       	jmp    80106589 <alltraps>

8010728f <vector206>:
.globl vector206
vector206:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $206
80107291:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107296:	e9 ee f2 ff ff       	jmp    80106589 <alltraps>

8010729b <vector207>:
.globl vector207
vector207:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $207
8010729d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801072a2:	e9 e2 f2 ff ff       	jmp    80106589 <alltraps>

801072a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $208
801072a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801072ae:	e9 d6 f2 ff ff       	jmp    80106589 <alltraps>

801072b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $209
801072b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801072ba:	e9 ca f2 ff ff       	jmp    80106589 <alltraps>

801072bf <vector210>:
.globl vector210
vector210:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $210
801072c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801072c6:	e9 be f2 ff ff       	jmp    80106589 <alltraps>

801072cb <vector211>:
.globl vector211
vector211:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $211
801072cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801072d2:	e9 b2 f2 ff ff       	jmp    80106589 <alltraps>

801072d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $212
801072d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801072de:	e9 a6 f2 ff ff       	jmp    80106589 <alltraps>

801072e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $213
801072e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801072ea:	e9 9a f2 ff ff       	jmp    80106589 <alltraps>

801072ef <vector214>:
.globl vector214
vector214:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $214
801072f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801072f6:	e9 8e f2 ff ff       	jmp    80106589 <alltraps>

801072fb <vector215>:
.globl vector215
vector215:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $215
801072fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107302:	e9 82 f2 ff ff       	jmp    80106589 <alltraps>

80107307 <vector216>:
.globl vector216
vector216:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $216
80107309:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010730e:	e9 76 f2 ff ff       	jmp    80106589 <alltraps>

80107313 <vector217>:
.globl vector217
vector217:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $217
80107315:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010731a:	e9 6a f2 ff ff       	jmp    80106589 <alltraps>

8010731f <vector218>:
.globl vector218
vector218:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $218
80107321:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107326:	e9 5e f2 ff ff       	jmp    80106589 <alltraps>

8010732b <vector219>:
.globl vector219
vector219:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $219
8010732d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107332:	e9 52 f2 ff ff       	jmp    80106589 <alltraps>

80107337 <vector220>:
.globl vector220
vector220:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $220
80107339:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010733e:	e9 46 f2 ff ff       	jmp    80106589 <alltraps>

80107343 <vector221>:
.globl vector221
vector221:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $221
80107345:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010734a:	e9 3a f2 ff ff       	jmp    80106589 <alltraps>

8010734f <vector222>:
.globl vector222
vector222:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $222
80107351:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107356:	e9 2e f2 ff ff       	jmp    80106589 <alltraps>

8010735b <vector223>:
.globl vector223
vector223:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $223
8010735d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107362:	e9 22 f2 ff ff       	jmp    80106589 <alltraps>

80107367 <vector224>:
.globl vector224
vector224:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $224
80107369:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010736e:	e9 16 f2 ff ff       	jmp    80106589 <alltraps>

80107373 <vector225>:
.globl vector225
vector225:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $225
80107375:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010737a:	e9 0a f2 ff ff       	jmp    80106589 <alltraps>

8010737f <vector226>:
.globl vector226
vector226:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $226
80107381:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107386:	e9 fe f1 ff ff       	jmp    80106589 <alltraps>

8010738b <vector227>:
.globl vector227
vector227:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $227
8010738d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107392:	e9 f2 f1 ff ff       	jmp    80106589 <alltraps>

80107397 <vector228>:
.globl vector228
vector228:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $228
80107399:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010739e:	e9 e6 f1 ff ff       	jmp    80106589 <alltraps>

801073a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $229
801073a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801073aa:	e9 da f1 ff ff       	jmp    80106589 <alltraps>

801073af <vector230>:
.globl vector230
vector230:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $230
801073b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801073b6:	e9 ce f1 ff ff       	jmp    80106589 <alltraps>

801073bb <vector231>:
.globl vector231
vector231:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $231
801073bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801073c2:	e9 c2 f1 ff ff       	jmp    80106589 <alltraps>

801073c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $232
801073c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801073ce:	e9 b6 f1 ff ff       	jmp    80106589 <alltraps>

801073d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $233
801073d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801073da:	e9 aa f1 ff ff       	jmp    80106589 <alltraps>

801073df <vector234>:
.globl vector234
vector234:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $234
801073e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801073e6:	e9 9e f1 ff ff       	jmp    80106589 <alltraps>

801073eb <vector235>:
.globl vector235
vector235:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $235
801073ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801073f2:	e9 92 f1 ff ff       	jmp    80106589 <alltraps>

801073f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $236
801073f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801073fe:	e9 86 f1 ff ff       	jmp    80106589 <alltraps>

80107403 <vector237>:
.globl vector237
vector237:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $237
80107405:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010740a:	e9 7a f1 ff ff       	jmp    80106589 <alltraps>

8010740f <vector238>:
.globl vector238
vector238:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $238
80107411:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107416:	e9 6e f1 ff ff       	jmp    80106589 <alltraps>

8010741b <vector239>:
.globl vector239
vector239:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $239
8010741d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107422:	e9 62 f1 ff ff       	jmp    80106589 <alltraps>

80107427 <vector240>:
.globl vector240
vector240:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $240
80107429:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010742e:	e9 56 f1 ff ff       	jmp    80106589 <alltraps>

80107433 <vector241>:
.globl vector241
vector241:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $241
80107435:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010743a:	e9 4a f1 ff ff       	jmp    80106589 <alltraps>

8010743f <vector242>:
.globl vector242
vector242:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $242
80107441:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107446:	e9 3e f1 ff ff       	jmp    80106589 <alltraps>

8010744b <vector243>:
.globl vector243
vector243:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $243
8010744d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107452:	e9 32 f1 ff ff       	jmp    80106589 <alltraps>

80107457 <vector244>:
.globl vector244
vector244:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $244
80107459:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010745e:	e9 26 f1 ff ff       	jmp    80106589 <alltraps>

80107463 <vector245>:
.globl vector245
vector245:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $245
80107465:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010746a:	e9 1a f1 ff ff       	jmp    80106589 <alltraps>

8010746f <vector246>:
.globl vector246
vector246:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $246
80107471:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107476:	e9 0e f1 ff ff       	jmp    80106589 <alltraps>

8010747b <vector247>:
.globl vector247
vector247:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $247
8010747d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107482:	e9 02 f1 ff ff       	jmp    80106589 <alltraps>

80107487 <vector248>:
.globl vector248
vector248:
  pushl $0
80107487:	6a 00                	push   $0x0
  pushl $248
80107489:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010748e:	e9 f6 f0 ff ff       	jmp    80106589 <alltraps>

80107493 <vector249>:
.globl vector249
vector249:
  pushl $0
80107493:	6a 00                	push   $0x0
  pushl $249
80107495:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010749a:	e9 ea f0 ff ff       	jmp    80106589 <alltraps>

8010749f <vector250>:
.globl vector250
vector250:
  pushl $0
8010749f:	6a 00                	push   $0x0
  pushl $250
801074a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801074a6:	e9 de f0 ff ff       	jmp    80106589 <alltraps>

801074ab <vector251>:
.globl vector251
vector251:
  pushl $0
801074ab:	6a 00                	push   $0x0
  pushl $251
801074ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801074b2:	e9 d2 f0 ff ff       	jmp    80106589 <alltraps>

801074b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801074b7:	6a 00                	push   $0x0
  pushl $252
801074b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801074be:	e9 c6 f0 ff ff       	jmp    80106589 <alltraps>

801074c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801074c3:	6a 00                	push   $0x0
  pushl $253
801074c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801074ca:	e9 ba f0 ff ff       	jmp    80106589 <alltraps>

801074cf <vector254>:
.globl vector254
vector254:
  pushl $0
801074cf:	6a 00                	push   $0x0
  pushl $254
801074d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801074d6:	e9 ae f0 ff ff       	jmp    80106589 <alltraps>

801074db <vector255>:
.globl vector255
vector255:
  pushl $0
801074db:	6a 00                	push   $0x0
  pushl $255
801074dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801074e2:	e9 a2 f0 ff ff       	jmp    80106589 <alltraps>
801074e7:	66 90                	xchg   %ax,%ax
801074e9:	66 90                	xchg   %ax,%ax
801074eb:	66 90                	xchg   %ax,%ax
801074ed:	66 90                	xchg   %ax,%ax
801074ef:	90                   	nop

801074f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	57                   	push   %edi
801074f4:	56                   	push   %esi
801074f5:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
801074f6:	89 d3                	mov    %edx,%ebx
{
801074f8:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
801074fa:	c1 eb 16             	shr    $0x16,%ebx
801074fd:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107500:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107503:	8b 06                	mov    (%esi),%eax
80107505:	a8 01                	test   $0x1,%al
80107507:	74 27                	je     80107530 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107509:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010750e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107514:	c1 ef 0a             	shr    $0xa,%edi
}
80107517:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010751a:	89 fa                	mov    %edi,%edx
8010751c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107522:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
8010752a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107530:	85 c9                	test   %ecx,%ecx
80107532:	74 2c                	je     80107560 <walkpgdir+0x70>
80107534:	e8 07 b8 ff ff       	call   80102d40 <kalloc>
80107539:	85 c0                	test   %eax,%eax
8010753b:	89 c3                	mov    %eax,%ebx
8010753d:	74 21                	je     80107560 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010753f:	83 ec 04             	sub    $0x4,%esp
80107542:	68 00 10 00 00       	push   $0x1000
80107547:	6a 00                	push   $0x0
80107549:	50                   	push   %eax
8010754a:	e8 f1 dd ff ff       	call   80105340 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010754f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107555:	83 c4 10             	add    $0x10,%esp
80107558:	83 c8 07             	or     $0x7,%eax
8010755b:	89 06                	mov    %eax,(%esi)
8010755d:	eb b5                	jmp    80107514 <walkpgdir+0x24>
8010755f:	90                   	nop
}
80107560:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107563:	31 c0                	xor    %eax,%eax
}
80107565:	5b                   	pop    %ebx
80107566:	5e                   	pop    %esi
80107567:	5f                   	pop    %edi
80107568:	5d                   	pop    %ebp
80107569:	c3                   	ret    
8010756a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107570 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107576:	89 d3                	mov    %edx,%ebx
80107578:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010757e:	83 ec 1c             	sub    $0x1c,%esp
80107581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107584:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107588:	8b 7d 08             	mov    0x8(%ebp),%edi
8010758b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107590:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107593:	8b 45 0c             	mov    0xc(%ebp),%eax
80107596:	29 df                	sub    %ebx,%edi
80107598:	83 c8 01             	or     $0x1,%eax
8010759b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010759e:	eb 15                	jmp    801075b5 <mappages+0x45>
    if(*pte & PTE_P)
801075a0:	f6 00 01             	testb  $0x1,(%eax)
801075a3:	75 45                	jne    801075ea <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801075a5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801075a8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801075ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801075ad:	74 31                	je     801075e0 <mappages+0x70>
      break;
    a += PGSIZE;
801075af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801075b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801075bd:	89 da                	mov    %ebx,%edx
801075bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801075c2:	e8 29 ff ff ff       	call   801074f0 <walkpgdir>
801075c7:	85 c0                	test   %eax,%eax
801075c9:	75 d5                	jne    801075a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801075cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075d3:	5b                   	pop    %ebx
801075d4:	5e                   	pop    %esi
801075d5:	5f                   	pop    %edi
801075d6:	5d                   	pop    %ebp
801075d7:	c3                   	ret    
801075d8:	90                   	nop
801075d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075e3:	31 c0                	xor    %eax,%eax
}
801075e5:	5b                   	pop    %ebx
801075e6:	5e                   	pop    %esi
801075e7:	5f                   	pop    %edi
801075e8:	5d                   	pop    %ebp
801075e9:	c3                   	ret    
      panic("remap");
801075ea:	83 ec 0c             	sub    $0xc,%esp
801075ed:	68 74 99 10 80       	push   $0x80109974
801075f2:	e8 99 8d ff ff       	call   80100390 <panic>
801075f7:	89 f6                	mov    %esi,%esi
801075f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107600 <printlist>:
{
80107600:	55                   	push   %ebp
80107601:	89 e5                	mov    %esp,%ebp
80107603:	56                   	push   %esi
80107604:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
80107605:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
8010760a:	83 ec 0c             	sub    $0xc,%esp
8010760d:	68 7a 99 10 80       	push   $0x8010997a
80107612:	e8 49 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
80107617:	e8 b4 cc ff ff       	call   801042d0 <myproc>
8010761c:	83 c4 10             	add    $0x10,%esp
8010761f:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
80107625:	eb 0e                	jmp    80107635 <printlist+0x35>
80107627:	89 f6                	mov    %esi,%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107630:	83 ee 01             	sub    $0x1,%esi
80107633:	74 19                	je     8010764e <printlist+0x4e>
    cprintf("%d -> ", curr->off);
80107635:	83 ec 08             	sub    $0x8,%esp
80107638:	ff 33                	pushl  (%ebx)
8010763a:	68 8a 99 10 80       	push   $0x8010998a
8010763f:	e8 1c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107644:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
80107647:	83 c4 10             	add    $0x10,%esp
8010764a:	85 db                	test   %ebx,%ebx
8010764c:	75 e2                	jne    80107630 <printlist+0x30>
  cprintf("\n");
8010764e:	83 ec 0c             	sub    $0xc,%esp
80107651:	68 70 9b 10 80       	push   $0x80109b70
80107656:	e8 05 90 ff ff       	call   80100660 <cprintf>
}
8010765b:	83 c4 10             	add    $0x10,%esp
8010765e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107661:	5b                   	pop    %ebx
80107662:	5e                   	pop    %esi
80107663:	5d                   	pop    %ebp
80107664:	c3                   	ret    
80107665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107670 <printaq>:
{
80107670:	55                   	push   %ebp
80107671:	89 e5                	mov    %esp,%ebp
80107673:	53                   	push   %ebx
80107674:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
80107677:	68 91 99 10 80       	push   $0x80109991
8010767c:	e8 df 8f ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107681:	e8 4a cc ff ff       	call   801042d0 <myproc>
80107686:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010768c:	8b 58 08             	mov    0x8(%eax),%ebx
8010768f:	e8 3c cc ff ff       	call   801042d0 <myproc>
80107694:	83 c4 0c             	add    $0xc,%esp
80107697:	53                   	push   %ebx
80107698:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010769e:	ff 70 08             	pushl  0x8(%eax)
801076a1:	68 a3 99 10 80       	push   $0x801099a3
801076a6:	e8 b5 8f ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
801076ab:	e8 20 cc ff ff       	call   801042d0 <myproc>
801076b0:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
801076b6:	83 c4 10             	add    $0x10,%esp
801076b9:	8b 50 04             	mov    0x4(%eax),%edx
801076bc:	85 d2                	test   %edx,%edx
801076be:	74 68                	je     80107728 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
801076c0:	e8 0b cc ff ff       	call   801042d0 <myproc>
801076c5:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
801076cb:	85 db                	test   %ebx,%ebx
801076cd:	74 1a                	je     801076e9 <printaq+0x79>
801076cf:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
801076d0:	83 ec 08             	sub    $0x8,%esp
801076d3:	ff 73 08             	pushl  0x8(%ebx)
801076d6:	68 c1 99 10 80       	push   $0x801099c1
801076db:	e8 80 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801076e0:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
801076e2:	83 c4 10             	add    $0x10,%esp
801076e5:	85 db                	test   %ebx,%ebx
801076e7:	75 e7                	jne    801076d0 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
801076e9:	e8 e2 cb ff ff       	call   801042d0 <myproc>
801076ee:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
801076f4:	8b 00                	mov    (%eax),%eax
801076f6:	85 c0                	test   %eax,%eax
801076f8:	74 16                	je     80107710 <printaq+0xa0>
  cprintf("\n");
801076fa:	83 ec 0c             	sub    $0xc,%esp
801076fd:	68 70 9b 10 80       	push   $0x80109b70
80107702:	e8 59 8f ff ff       	call   80100660 <cprintf>
}
80107707:	83 c4 10             	add    $0x10,%esp
8010770a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010770d:	c9                   	leave  
8010770e:	c3                   	ret    
8010770f:	90                   	nop
    cprintf("null <-> ");
80107710:	83 ec 0c             	sub    $0xc,%esp
80107713:	68 b7 99 10 80       	push   $0x801099b7
80107718:	e8 43 8f ff ff       	call   80100660 <cprintf>
8010771d:	83 c4 10             	add    $0x10,%esp
80107720:	eb d8                	jmp    801076fa <printaq+0x8a>
80107722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
80107728:	83 ec 0c             	sub    $0xc,%esp
8010772b:	68 b7 99 10 80       	push   $0x801099b7
80107730:	e8 2b 8f ff ff       	call   80100660 <cprintf>
80107735:	83 c4 10             	add    $0x10,%esp
80107738:	eb 86                	jmp    801076c0 <printaq+0x50>
8010773a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107740 <seginit>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107746:	e8 65 cb ff ff       	call   801042b0 <cpuid>
8010774b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80107751:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107756:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010775a:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
80107761:	ff 00 00 
80107764:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
8010776b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010776e:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
80107775:	ff 00 00 
80107778:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
8010777f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107782:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
80107789:	ff 00 00 
8010778c:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
80107793:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107796:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
8010779d:	ff 00 00 
801077a0:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
801077a7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801077aa:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
  pd[1] = (uint)p;
801077af:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801077b3:	c1 e8 10             	shr    $0x10,%eax
801077b6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077ba:	8d 45 f2             	lea    -0xe(%ebp),%eax
801077bd:	0f 01 10             	lgdtl  (%eax)
}
801077c0:	c9                   	leave  
801077c1:	c3                   	ret    
801077c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077d0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077d0:	a1 84 75 19 80       	mov    0x80197584,%eax
{
801077d5:	55                   	push   %ebp
801077d6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077d8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077dd:	0f 22 d8             	mov    %eax,%cr3
}
801077e0:	5d                   	pop    %ebp
801077e1:	c3                   	ret    
801077e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801077f0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801077f0:	55                   	push   %ebp
801077f1:	89 e5                	mov    %esp,%ebp
801077f3:	57                   	push   %edi
801077f4:	56                   	push   %esi
801077f5:	53                   	push   %ebx
801077f6:	83 ec 1c             	sub    $0x1c,%esp
801077f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801077fc:	85 db                	test   %ebx,%ebx
801077fe:	0f 84 cb 00 00 00    	je     801078cf <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107804:	8b 43 08             	mov    0x8(%ebx),%eax
80107807:	85 c0                	test   %eax,%eax
80107809:	0f 84 da 00 00 00    	je     801078e9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010780f:	8b 43 04             	mov    0x4(%ebx),%eax
80107812:	85 c0                	test   %eax,%eax
80107814:	0f 84 c2 00 00 00    	je     801078dc <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010781a:	e8 41 d9 ff ff       	call   80105160 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010781f:	e8 0c ca ff ff       	call   80104230 <mycpu>
80107824:	89 c6                	mov    %eax,%esi
80107826:	e8 05 ca ff ff       	call   80104230 <mycpu>
8010782b:	89 c7                	mov    %eax,%edi
8010782d:	e8 fe c9 ff ff       	call   80104230 <mycpu>
80107832:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107835:	83 c7 08             	add    $0x8,%edi
80107838:	e8 f3 c9 ff ff       	call   80104230 <mycpu>
8010783d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107840:	83 c0 08             	add    $0x8,%eax
80107843:	ba 67 00 00 00       	mov    $0x67,%edx
80107848:	c1 e8 18             	shr    $0x18,%eax
8010784b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107852:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107859:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010785f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107864:	83 c1 08             	add    $0x8,%ecx
80107867:	c1 e9 10             	shr    $0x10,%ecx
8010786a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107870:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107875:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010787c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107881:	e8 aa c9 ff ff       	call   80104230 <mycpu>
80107886:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010788d:	e8 9e c9 ff ff       	call   80104230 <mycpu>
80107892:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107896:	8b 73 08             	mov    0x8(%ebx),%esi
80107899:	e8 92 c9 ff ff       	call   80104230 <mycpu>
8010789e:	81 c6 00 10 00 00    	add    $0x1000,%esi
801078a4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078a7:	e8 84 c9 ff ff       	call   80104230 <mycpu>
801078ac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801078b0:	b8 28 00 00 00       	mov    $0x28,%eax
801078b5:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801078b8:	8b 43 04             	mov    0x4(%ebx),%eax
801078bb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801078c0:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
801078c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078c6:	5b                   	pop    %ebx
801078c7:	5e                   	pop    %esi
801078c8:	5f                   	pop    %edi
801078c9:	5d                   	pop    %ebp
  popcli();
801078ca:	e9 d1 d8 ff ff       	jmp    801051a0 <popcli>
    panic("switchuvm: no process");
801078cf:	83 ec 0c             	sub    $0xc,%esp
801078d2:	68 c9 99 10 80       	push   $0x801099c9
801078d7:	e8 b4 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801078dc:	83 ec 0c             	sub    $0xc,%esp
801078df:	68 f4 99 10 80       	push   $0x801099f4
801078e4:	e8 a7 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801078e9:	83 ec 0c             	sub    $0xc,%esp
801078ec:	68 df 99 10 80       	push   $0x801099df
801078f1:	e8 9a 8a ff ff       	call   80100390 <panic>
801078f6:	8d 76 00             	lea    0x0(%esi),%esi
801078f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107900 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107900:	55                   	push   %ebp
80107901:	89 e5                	mov    %esp,%ebp
80107903:	57                   	push   %edi
80107904:	56                   	push   %esi
80107905:	53                   	push   %ebx
80107906:	83 ec 1c             	sub    $0x1c,%esp
80107909:	8b 75 10             	mov    0x10(%ebp),%esi
8010790c:	8b 45 08             	mov    0x8(%ebp),%eax
8010790f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107912:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107918:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010791b:	77 49                	ja     80107966 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010791d:	e8 1e b4 ff ff       	call   80102d40 <kalloc>
  memset(mem, 0, PGSIZE);
80107922:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107925:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107927:	68 00 10 00 00       	push   $0x1000
8010792c:	6a 00                	push   $0x0
8010792e:	50                   	push   %eax
8010792f:	e8 0c da ff ff       	call   80105340 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107934:	58                   	pop    %eax
80107935:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010793b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107940:	5a                   	pop    %edx
80107941:	6a 06                	push   $0x6
80107943:	50                   	push   %eax
80107944:	31 d2                	xor    %edx,%edx
80107946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107949:	e8 22 fc ff ff       	call   80107570 <mappages>
  memmove(mem, init, sz);
8010794e:	89 75 10             	mov    %esi,0x10(%ebp)
80107951:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107954:	83 c4 10             	add    $0x10,%esp
80107957:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010795a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795d:	5b                   	pop    %ebx
8010795e:	5e                   	pop    %esi
8010795f:	5f                   	pop    %edi
80107960:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107961:	e9 8a da ff ff       	jmp    801053f0 <memmove>
    panic("inituvm: more than a page");
80107966:	83 ec 0c             	sub    $0xc,%esp
80107969:	68 08 9a 10 80       	push   $0x80109a08
8010796e:	e8 1d 8a ff ff       	call   80100390 <panic>
80107973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107980 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107980:	55                   	push   %ebp
80107981:	89 e5                	mov    %esp,%ebp
80107983:	57                   	push   %edi
80107984:	56                   	push   %esi
80107985:	53                   	push   %ebx
80107986:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107989:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107990:	0f 85 91 00 00 00    	jne    80107a27 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107996:	8b 75 18             	mov    0x18(%ebp),%esi
80107999:	31 db                	xor    %ebx,%ebx
8010799b:	85 f6                	test   %esi,%esi
8010799d:	75 1a                	jne    801079b9 <loaduvm+0x39>
8010799f:	eb 6f                	jmp    80107a10 <loaduvm+0x90>
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801079ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801079b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801079b7:	76 57                	jbe    80107a10 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801079b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801079bc:	8b 45 08             	mov    0x8(%ebp),%eax
801079bf:	31 c9                	xor    %ecx,%ecx
801079c1:	01 da                	add    %ebx,%edx
801079c3:	e8 28 fb ff ff       	call   801074f0 <walkpgdir>
801079c8:	85 c0                	test   %eax,%eax
801079ca:	74 4e                	je     80107a1a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801079cc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801079d1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801079d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801079db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801079e1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801079e4:	01 d9                	add    %ebx,%ecx
801079e6:	05 00 00 00 80       	add    $0x80000000,%eax
801079eb:	57                   	push   %edi
801079ec:	51                   	push   %ecx
801079ed:	50                   	push   %eax
801079ee:	ff 75 10             	pushl  0x10(%ebp)
801079f1:	e8 2a a3 ff ff       	call   80101d20 <readi>
801079f6:	83 c4 10             	add    $0x10,%esp
801079f9:	39 f8                	cmp    %edi,%eax
801079fb:	74 ab                	je     801079a8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
801079fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a05:	5b                   	pop    %ebx
80107a06:	5e                   	pop    %esi
80107a07:	5f                   	pop    %edi
80107a08:	5d                   	pop    %ebp
80107a09:	c3                   	ret    
80107a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a13:	31 c0                	xor    %eax,%eax
}
80107a15:	5b                   	pop    %ebx
80107a16:	5e                   	pop    %esi
80107a17:	5f                   	pop    %edi
80107a18:	5d                   	pop    %ebp
80107a19:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a1a:	83 ec 0c             	sub    $0xc,%esp
80107a1d:	68 22 9a 10 80       	push   $0x80109a22
80107a22:	e8 69 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107a27:	83 ec 0c             	sub    $0xc,%esp
80107a2a:	68 8c 9c 10 80       	push   $0x80109c8c
80107a2f:	e8 5c 89 ff ff       	call   80100390 <panic>
80107a34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a40 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a40:	55                   	push   %ebp
80107a41:	89 e5                	mov    %esp,%ebp
80107a43:	56                   	push   %esi
80107a44:	53                   	push   %ebx
80107a45:	8b 75 08             	mov    0x8(%ebp),%esi
80107a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
80107a4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  page->swap_offset = -1;
  page->virt_addr = rounded_virtaddr;
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  cprintf("filling ram slot: %d\n", curproc->num_ram);
80107a4e:	83 ec 08             	sub    $0x8,%esp
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107a51:	8b 96 08 04 00 00    	mov    0x408(%esi),%edx
  page->isused = 1;
80107a57:	6b c2 1c             	imul   $0x1c,%edx,%eax
80107a5a:	01 f0                	add    %esi,%eax
  page->pgdir = pgdir;
80107a5c:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107a62:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  page->isused = 1;
80107a68:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a6f:	00 00 00 
  page->swap_offset = -1;
80107a72:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107a79:	ff ff ff 
  cprintf("filling ram slot: %d\n", curproc->num_ram);
80107a7c:	52                   	push   %edx
80107a7d:	68 40 9a 10 80       	push   $0x80109a40
80107a82:	e8 d9 8b ff ff       	call   80100660 <cprintf>
  cprintf("allocating addr : %p\n\n", rounded_virtaddr);
80107a87:	58                   	pop    %eax
80107a88:	5a                   	pop    %edx
80107a89:	53                   	push   %ebx
80107a8a:	68 56 9a 10 80       	push   $0x80109a56
80107a8f:	e8 cc 8b ff ff       	call   80100660 <cprintf>

  curproc->num_ram++;
80107a94:	83 86 08 04 00 00 01 	addl   $0x1,0x408(%esi)
  // cprintf("num ram : %d\n", curproc->num_ram);
}
80107a9b:	83 c4 10             	add    $0x10,%esp
80107a9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107aa1:	5b                   	pop    %ebx
80107aa2:	5e                   	pop    %esi
80107aa3:	5d                   	pop    %ebp
80107aa4:	c3                   	ret    
80107aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ab0 <update_selectionfiled_allocuvm>:
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
}

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107ab0:	55                   	push   %ebp
80107ab1:	89 e5                	mov    %esp,%ebp
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107ab3:	5d                   	pop    %ebp
80107ab4:	c3                   	ret    
80107ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107ac0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ac0:	55                   	push   %ebp
80107ac1:	89 e5                	mov    %esp,%ebp
80107ac3:	57                   	push   %edi
80107ac4:	56                   	push   %esi
80107ac5:	53                   	push   %ebx
80107ac6:	83 ec 5c             	sub    $0x5c,%esp
80107ac9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107acc:	e8 ff c7 ff ff       	call   801042d0 <myproc>
80107ad1:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ad7:	39 45 10             	cmp    %eax,0x10(%ebp)
80107ada:	0f 83 a3 00 00 00    	jae    80107b83 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107ae0:	8b 45 10             	mov    0x10(%ebp),%eax
80107ae3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107ae9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107aef:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107af2:	77 6a                	ja     80107b5e <deallocuvm+0x9e>
80107af4:	e9 87 00 00 00       	jmp    80107b80 <deallocuvm+0xc0>
80107af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107b00:	8b 00                	mov    (%eax),%eax
80107b02:	a8 01                	test   $0x1,%al
80107b04:	74 4d                	je     80107b53 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b0b:	0f 84 b3 01 00 00    	je     80107cc4 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107b11:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107b17:	83 ec 0c             	sub    $0xc,%esp
80107b1a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b1d:	53                   	push   %ebx
80107b1e:	e8 ad b3 ff ff       	call   80102ed0 <getRefs>
80107b23:	83 c4 10             	add    $0x10,%esp
80107b26:	83 f8 01             	cmp    $0x1,%eax
80107b29:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107b2c:	0f 84 7e 01 00 00    	je     80107cb0 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107b32:	83 ec 0c             	sub    $0xc,%esp
80107b35:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b38:	53                   	push   %ebx
80107b39:	e8 b2 b2 ff ff       	call   80102df0 <refDec>
80107b3e:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107b41:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107b44:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107b47:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107b4b:	7f 43                	jg     80107b90 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107b4d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107b53:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b59:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b5c:	76 22                	jbe    80107b80 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b5e:	31 c9                	xor    %ecx,%ecx
80107b60:	89 f2                	mov    %esi,%edx
80107b62:	89 f8                	mov    %edi,%eax
80107b64:	e8 87 f9 ff ff       	call   801074f0 <walkpgdir>
    if(!pte)
80107b69:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b6b:	89 c2                	mov    %eax,%edx
    if(!pte)
80107b6d:	75 91                	jne    80107b00 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107b6f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107b75:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b7b:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b7e:	77 de                	ja     80107b5e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107b80:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b86:	5b                   	pop    %ebx
80107b87:	5e                   	pop    %esi
80107b88:	5f                   	pop    %edi
80107b89:	5d                   	pop    %ebp
80107b8a:	c3                   	ret    
80107b8b:	90                   	nop
80107b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107b90:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107b96:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b99:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107b9f:	89 fa                	mov    %edi,%edx
80107ba1:	89 cf                	mov    %ecx,%edi
80107ba3:	eb 17                	jmp    80107bbc <deallocuvm+0xfc>
80107ba5:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107ba8:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107bab:	0f 84 b7 00 00 00    	je     80107c68 <deallocuvm+0x1a8>
80107bb1:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107bb4:	39 fb                	cmp    %edi,%ebx
80107bb6:	0f 84 e4 00 00 00    	je     80107ca0 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107bbc:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107bc2:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107bc5:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107bcb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107bce:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107bd4:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107bd7:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107bdd:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107be0:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107be3:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107be9:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107bec:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107bf2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107bf5:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107bfb:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107bfe:	8b 03                	mov    (%ebx),%eax
80107c00:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107c03:	8b 43 04             	mov    0x4(%ebx),%eax
80107c06:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107c09:	8b 43 08             	mov    0x8(%ebx),%eax
80107c0c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107c0f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107c12:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107c15:	8b 43 10             	mov    0x10(%ebx),%eax
80107c18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107c1b:	8b 43 14             	mov    0x14(%ebx),%eax
80107c1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c21:	8b 43 18             	mov    0x18(%ebx),%eax
80107c24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107c27:	0f 85 7b ff ff ff    	jne    80107ba8 <deallocuvm+0xe8>
80107c2d:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107c30:	0f 85 72 ff ff ff    	jne    80107ba8 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107c36:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107c39:	83 ec 04             	sub    $0x4,%esp
80107c3c:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107c3f:	6a 1c                	push   $0x1c
80107c41:	6a 00                	push   $0x0
80107c43:	50                   	push   %eax
80107c44:	e8 f7 d6 ff ff       	call   80105340 <memset>
            curproc->num_ram -- ;
80107c49:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c4c:	83 c4 10             	add    $0x10,%esp
80107c4f:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107c52:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107c59:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107c5c:	0f 85 4f ff ff ff    	jne    80107bb1 <deallocuvm+0xf1>
80107c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c68:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107c6b:	0f 85 40 ff ff ff    	jne    80107bb1 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107c71:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107c74:	83 ec 04             	sub    $0x4,%esp
80107c77:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107c7a:	6a 1c                	push   $0x1c
80107c7c:	6a 00                	push   $0x0
80107c7e:	83 c3 1c             	add    $0x1c,%ebx
80107c81:	50                   	push   %eax
80107c82:	e8 b9 d6 ff ff       	call   80105340 <memset>
            curproc->num_swap --;
80107c87:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c8a:	83 c4 10             	add    $0x10,%esp
80107c8d:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107c90:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107c97:	39 fb                	cmp    %edi,%ebx
80107c99:	0f 85 1d ff ff ff    	jne    80107bbc <deallocuvm+0xfc>
80107c9f:	90                   	nop
80107ca0:	89 d7                	mov    %edx,%edi
80107ca2:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107ca5:	e9 a3 fe ff ff       	jmp    80107b4d <deallocuvm+0x8d>
80107caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107cb0:	83 ec 0c             	sub    $0xc,%esp
80107cb3:	53                   	push   %ebx
80107cb4:	e8 a7 ad ff ff       	call   80102a60 <kfree>
80107cb9:	83 c4 10             	add    $0x10,%esp
80107cbc:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107cbf:	e9 80 fe ff ff       	jmp    80107b44 <deallocuvm+0x84>
        panic("kfree");
80107cc4:	83 ec 0c             	sub    $0xc,%esp
80107cc7:	68 e2 91 10 80       	push   $0x801091e2
80107ccc:	e8 bf 86 ff ff       	call   80100390 <panic>
80107cd1:	eb 0d                	jmp    80107ce0 <freevm>
80107cd3:	90                   	nop
80107cd4:	90                   	nop
80107cd5:	90                   	nop
80107cd6:	90                   	nop
80107cd7:	90                   	nop
80107cd8:	90                   	nop
80107cd9:	90                   	nop
80107cda:	90                   	nop
80107cdb:	90                   	nop
80107cdc:	90                   	nop
80107cdd:	90                   	nop
80107cde:	90                   	nop
80107cdf:	90                   	nop

80107ce0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107ce0:	55                   	push   %ebp
80107ce1:	89 e5                	mov    %esp,%ebp
80107ce3:	57                   	push   %edi
80107ce4:	56                   	push   %esi
80107ce5:	53                   	push   %ebx
80107ce6:	83 ec 0c             	sub    $0xc,%esp
80107ce9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107cec:	85 f6                	test   %esi,%esi
80107cee:	74 59                	je     80107d49 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107cf0:	83 ec 04             	sub    $0x4,%esp
80107cf3:	89 f3                	mov    %esi,%ebx
80107cf5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107cfb:	6a 00                	push   $0x0
80107cfd:	68 00 00 00 80       	push   $0x80000000
80107d02:	56                   	push   %esi
80107d03:	e8 b8 fd ff ff       	call   80107ac0 <deallocuvm>
80107d08:	83 c4 10             	add    $0x10,%esp
80107d0b:	eb 0a                	jmp    80107d17 <freevm+0x37>
80107d0d:	8d 76 00             	lea    0x0(%esi),%esi
80107d10:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107d13:	39 fb                	cmp    %edi,%ebx
80107d15:	74 23                	je     80107d3a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107d17:	8b 03                	mov    (%ebx),%eax
80107d19:	a8 01                	test   $0x1,%al
80107d1b:	74 f3                	je     80107d10 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d1d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107d22:	83 ec 0c             	sub    $0xc,%esp
80107d25:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d28:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107d2d:	50                   	push   %eax
80107d2e:	e8 2d ad ff ff       	call   80102a60 <kfree>
80107d33:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d36:	39 fb                	cmp    %edi,%ebx
80107d38:	75 dd                	jne    80107d17 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80107d3a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80107d3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d40:	5b                   	pop    %ebx
80107d41:	5e                   	pop    %esi
80107d42:	5f                   	pop    %edi
80107d43:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d44:	e9 17 ad ff ff       	jmp    80102a60 <kfree>
    panic("freevm: no pgdir");
80107d49:	83 ec 0c             	sub    $0xc,%esp
80107d4c:	68 6d 9a 10 80       	push   $0x80109a6d
80107d51:	e8 3a 86 ff ff       	call   80100390 <panic>
80107d56:	8d 76 00             	lea    0x0(%esi),%esi
80107d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107d60 <setupkvm>:
{
80107d60:	55                   	push   %ebp
80107d61:	89 e5                	mov    %esp,%ebp
80107d63:	56                   	push   %esi
80107d64:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107d65:	e8 d6 af ff ff       	call   80102d40 <kalloc>
80107d6a:	85 c0                	test   %eax,%eax
80107d6c:	89 c6                	mov    %eax,%esi
80107d6e:	74 42                	je     80107db2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107d70:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d73:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107d78:	68 00 10 00 00       	push   $0x1000
80107d7d:	6a 00                	push   $0x0
80107d7f:	50                   	push   %eax
80107d80:	e8 bb d5 ff ff       	call   80105340 <memset>
80107d85:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107d88:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107d8b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107d8e:	83 ec 08             	sub    $0x8,%esp
80107d91:	8b 13                	mov    (%ebx),%edx
80107d93:	ff 73 0c             	pushl  0xc(%ebx)
80107d96:	50                   	push   %eax
80107d97:	29 c1                	sub    %eax,%ecx
80107d99:	89 f0                	mov    %esi,%eax
80107d9b:	e8 d0 f7 ff ff       	call   80107570 <mappages>
80107da0:	83 c4 10             	add    $0x10,%esp
80107da3:	85 c0                	test   %eax,%eax
80107da5:	78 19                	js     80107dc0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107da7:	83 c3 10             	add    $0x10,%ebx
80107daa:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107db0:	75 d6                	jne    80107d88 <setupkvm+0x28>
}
80107db2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107db5:	89 f0                	mov    %esi,%eax
80107db7:	5b                   	pop    %ebx
80107db8:	5e                   	pop    %esi
80107db9:	5d                   	pop    %ebp
80107dba:	c3                   	ret    
80107dbb:	90                   	nop
80107dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80107dc0:	83 ec 0c             	sub    $0xc,%esp
80107dc3:	68 7e 9a 10 80       	push   $0x80109a7e
80107dc8:	e8 93 88 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
80107dcd:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107dd0:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107dd2:	e8 09 ff ff ff       	call   80107ce0 <freevm>
      return 0;
80107dd7:	83 c4 10             	add    $0x10,%esp
}
80107dda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ddd:	89 f0                	mov    %esi,%eax
80107ddf:	5b                   	pop    %ebx
80107de0:	5e                   	pop    %esi
80107de1:	5d                   	pop    %ebp
80107de2:	c3                   	ret    
80107de3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107df0 <kvmalloc>:
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107df6:	e8 65 ff ff ff       	call   80107d60 <setupkvm>
80107dfb:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e00:	05 00 00 00 80       	add    $0x80000000,%eax
80107e05:	0f 22 d8             	mov    %eax,%cr3
}
80107e08:	c9                   	leave  
80107e09:	c3                   	ret    
80107e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e10 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e10:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e11:	31 c9                	xor    %ecx,%ecx
{
80107e13:	89 e5                	mov    %esp,%ebp
80107e15:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e18:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e1b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e1e:	e8 cd f6 ff ff       	call   801074f0 <walkpgdir>
  if(pte == 0)
80107e23:	85 c0                	test   %eax,%eax
80107e25:	74 05                	je     80107e2c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e27:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e2a:	c9                   	leave  
80107e2b:	c3                   	ret    
    panic("clearpteu");
80107e2c:	83 ec 0c             	sub    $0xc,%esp
80107e2f:	68 9a 9a 10 80       	push   $0x80109a9a
80107e34:	e8 57 85 ff ff       	call   80100390 <panic>
80107e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e40 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80107e40:	55                   	push   %ebp
80107e41:	89 e5                	mov    %esp,%ebp
80107e43:	57                   	push   %edi
80107e44:	56                   	push   %esi
80107e45:	53                   	push   %ebx
80107e46:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107e49:	e8 12 ff ff ff       	call   80107d60 <setupkvm>
80107e4e:	85 c0                	test   %eax,%eax
80107e50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e53:	0f 84 b2 00 00 00    	je     80107f0b <cowuvm+0xcb>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80107e59:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e5c:	85 d2                	test   %edx,%edx
80107e5e:	0f 84 a7 00 00 00    	je     80107f0b <cowuvm+0xcb>
80107e64:	8b 45 08             	mov    0x8(%ebp),%eax
80107e67:	31 db                	xor    %ebx,%ebx
80107e69:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
80107e6f:	eb 27                	jmp    80107e98 <cowuvm+0x58>
80107e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80107e78:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107e7b:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
80107e81:	56                   	push   %esi
80107e82:	e8 d9 af ff ff       	call   80102e60 <refInc>
80107e87:	0f 22 df             	mov    %edi,%cr3
  for(i = 0; i < sz; i += PGSIZE)
80107e8a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e90:	83 c4 10             	add    $0x10,%esp
80107e93:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107e96:	76 73                	jbe    80107f0b <cowuvm+0xcb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107e98:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9b:	31 c9                	xor    %ecx,%ecx
80107e9d:	89 da                	mov    %ebx,%edx
80107e9f:	e8 4c f6 ff ff       	call   801074f0 <walkpgdir>
80107ea4:	85 c0                	test   %eax,%eax
80107ea6:	74 7b                	je     80107f23 <cowuvm+0xe3>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107ea8:	8b 10                	mov    (%eax),%edx
80107eaa:	f7 c2 01 02 00 00    	test   $0x201,%edx
80107eb0:	74 64                	je     80107f16 <cowuvm+0xd6>
    *pte &= ~PTE_W;
80107eb2:	89 d1                	mov    %edx,%ecx
80107eb4:	89 d6                	mov    %edx,%esi
    flags = PTE_FLAGS(*pte);
80107eb6:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80107ebc:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107ebf:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107ec2:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
80107ec5:	80 cd 04             	or     $0x4,%ch
80107ec8:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107ece:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107ed0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ed3:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ed8:	52                   	push   %edx
80107ed9:	56                   	push   %esi
80107eda:	89 da                	mov    %ebx,%edx
80107edc:	e8 8f f6 ff ff       	call   80107570 <mappages>
80107ee1:	83 c4 10             	add    $0x10,%esp
80107ee4:	85 c0                	test   %eax,%eax
80107ee6:	79 90                	jns    80107e78 <cowuvm+0x38>
    // invlpg((void*)i); // flush TLB
  }
  return d;

bad:
  cprintf("bad: cowuvm\n");
80107ee8:	83 ec 0c             	sub    $0xc,%esp
80107eeb:	68 b3 9a 10 80       	push   $0x80109ab3
80107ef0:	e8 6b 87 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107ef5:	58                   	pop    %eax
80107ef6:	ff 75 e4             	pushl  -0x1c(%ebp)
80107ef9:	e8 e2 fd ff ff       	call   80107ce0 <freevm>
80107efe:	0f 22 df             	mov    %edi,%cr3
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
80107f01:	83 c4 10             	add    $0x10,%esp
80107f04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f11:	5b                   	pop    %ebx
80107f12:	5e                   	pop    %esi
80107f13:	5f                   	pop    %edi
80107f14:	5d                   	pop    %ebp
80107f15:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
80107f16:	83 ec 0c             	sub    $0xc,%esp
80107f19:	68 b0 9c 10 80       	push   $0x80109cb0
80107f1e:	e8 6d 84 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107f23:	83 ec 0c             	sub    $0xc,%esp
80107f26:	68 a4 9a 10 80       	push   $0x80109aa4
80107f2b:	e8 60 84 ff ff       	call   80100390 <panic>

80107f30 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80107f30:	55                   	push   %ebp
80107f31:	89 e5                	mov    %esp,%ebp
80107f33:	53                   	push   %ebx
80107f34:	83 ec 04             	sub    $0x4,%esp
80107f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107f3a:	e8 91 c3 ff ff       	call   801042d0 <myproc>
80107f3f:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107f45:	31 c0                	xor    %eax,%eax
80107f47:	eb 12                	jmp    80107f5b <getSwappedPageIndex+0x2b>
80107f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107f50:	83 c0 01             	add    $0x1,%eax
80107f53:	83 c2 1c             	add    $0x1c,%edx
80107f56:	83 f8 10             	cmp    $0x10,%eax
80107f59:	74 0d                	je     80107f68 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
80107f5b:	39 1a                	cmp    %ebx,(%edx)
80107f5d:	75 f1                	jne    80107f50 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
80107f5f:	83 c4 04             	add    $0x4,%esp
80107f62:	5b                   	pop    %ebx
80107f63:	5d                   	pop    %ebp
80107f64:	c3                   	ret    
80107f65:	8d 76 00             	lea    0x0(%esi),%esi
80107f68:	83 c4 04             	add    $0x4,%esp
  return -1;
80107f6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107f70:	5b                   	pop    %ebx
80107f71:	5d                   	pop    %ebp
80107f72:	c3                   	ret    
80107f73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107f80 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
80107f80:	55                   	push   %ebp
80107f81:	89 e5                	mov    %esp,%ebp
80107f83:	57                   	push   %edi
80107f84:	56                   	push   %esi
80107f85:	53                   	push   %ebx
80107f86:	83 ec 1c             	sub    $0x1c,%esp
80107f89:	8b 45 08             	mov    0x8(%ebp),%eax
80107f8c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80107f8f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
80107f92:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80107f95:	f6 42 34 02          	testb  $0x2,0x34(%edx)
80107f99:	74 07                	je     80107fa2 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
80107f9b:	8b 13                	mov    (%ebx),%edx
80107f9d:	f6 c6 04             	test   $0x4,%dh
80107fa0:	75 16                	jne    80107fb8 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80107fa2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
80107fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fac:	5b                   	pop    %ebx
80107fad:	5e                   	pop    %esi
80107fae:	5f                   	pop    %edi
80107faf:	5d                   	pop    %ebp
80107fb0:	c3                   	ret    
80107fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
80107fb8:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
80107fba:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
80107fbd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107fc0:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80107fc6:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
80107fcc:	57                   	push   %edi
80107fcd:	e8 fe ae ff ff       	call   80102ed0 <getRefs>
      if (ref_count > 1) // more than one reference
80107fd2:	83 c4 10             	add    $0x10,%esp
80107fd5:	83 f8 01             	cmp    $0x1,%eax
80107fd8:	7f 16                	jg     80107ff0 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
80107fda:	8b 03                	mov    (%ebx),%eax
80107fdc:	80 e4 fb             	and    $0xfb,%ah
80107fdf:	83 c8 02             	or     $0x2,%eax
80107fe2:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107fe4:	0f 01 3e             	invlpg (%esi)
80107fe7:	eb c0                	jmp    80107fa9 <handle_cow_pagefault+0x29>
80107fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80107ff0:	e8 4b ad ff ff       	call   80102d40 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80107ff5:	83 ec 04             	sub    $0x4,%esp
80107ff8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107ffb:	68 00 10 00 00       	push   $0x1000
80108000:	57                   	push   %edi
80108001:	50                   	push   %eax
80108002:	e8 e9 d3 ff ff       	call   801053f0 <memmove>
      flags = PTE_FLAGS(*pte);
80108007:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
8010800a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
8010800d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
80108013:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108019:	83 ca 03             	or     $0x3,%edx
8010801c:	09 ca                	or     %ecx,%edx
8010801e:	89 13                	mov    %edx,(%ebx)
80108020:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
80108023:	89 7d 08             	mov    %edi,0x8(%ebp)
80108026:	83 c4 10             	add    $0x10,%esp
}
80108029:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010802c:	5b                   	pop    %ebx
8010802d:	5e                   	pop    %esi
8010802e:	5f                   	pop    %edi
8010802f:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
80108030:	e9 bb ad ff ff       	jmp    80102df0 <refDec>
80108035:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108040 <update_selectionfiled_pagefault>:
80108040:	55                   	push   %ebp
80108041:	89 e5                	mov    %esp,%ebp
80108043:	5d                   	pop    %ebp
80108044:	c3                   	ret    
80108045:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108050 <copyuvm>:

}

pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108050:	55                   	push   %ebp
80108051:	89 e5                	mov    %esp,%ebp
80108053:	57                   	push   %edi
80108054:	56                   	push   %esi
80108055:	53                   	push   %ebx
80108056:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108059:	e8 02 fd ff ff       	call   80107d60 <setupkvm>
8010805e:	85 c0                	test   %eax,%eax
80108060:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108063:	0f 84 be 00 00 00    	je     80108127 <copyuvm+0xd7>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108069:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010806c:	85 db                	test   %ebx,%ebx
8010806e:	0f 84 b3 00 00 00    	je     80108127 <copyuvm+0xd7>
80108074:	31 f6                	xor    %esi,%esi
80108076:	eb 69                	jmp    801080e1 <copyuvm+0x91>
80108078:	90                   	nop
80108079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }

    pa = PTE_ADDR(*pte);
80108080:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80108082:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80108087:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
8010808d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    {
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
        panic("copyuvm: mappages failed");
      continue;
    }
    if((mem = kalloc()) == 0)
80108090:	e8 ab ac ff ff       	call   80102d40 <kalloc>
80108095:	85 c0                	test   %eax,%eax
80108097:	89 c3                	mov    %eax,%ebx
80108099:	0f 84 b1 00 00 00    	je     80108150 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010809f:	83 ec 04             	sub    $0x4,%esp
801080a2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801080a8:	68 00 10 00 00       	push   $0x1000
801080ad:	57                   	push   %edi
801080ae:	50                   	push   %eax
801080af:	e8 3c d3 ff ff       	call   801053f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801080b4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801080ba:	5a                   	pop    %edx
801080bb:	59                   	pop    %ecx
801080bc:	ff 75 e4             	pushl  -0x1c(%ebp)
801080bf:	50                   	push   %eax
801080c0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801080c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801080c8:	89 f2                	mov    %esi,%edx
801080ca:	e8 a1 f4 ff ff       	call   80107570 <mappages>
801080cf:	83 c4 10             	add    $0x10,%esp
801080d2:	85 c0                	test   %eax,%eax
801080d4:	78 62                	js     80108138 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801080d6:	81 c6 00 10 00 00    	add    $0x1000,%esi
801080dc:	39 75 0c             	cmp    %esi,0xc(%ebp)
801080df:	76 46                	jbe    80108127 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801080e1:	8b 45 08             	mov    0x8(%ebp),%eax
801080e4:	31 c9                	xor    %ecx,%ecx
801080e6:	89 f2                	mov    %esi,%edx
801080e8:	e8 03 f4 ff ff       	call   801074f0 <walkpgdir>
801080ed:	85 c0                	test   %eax,%eax
801080ef:	0f 84 93 00 00 00    	je     80108188 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801080f5:	8b 00                	mov    (%eax),%eax
801080f7:	a9 01 02 00 00       	test   $0x201,%eax
801080fc:	74 7d                	je     8010817b <copyuvm+0x12b>
    if (*pte & PTE_PG) {
801080fe:	f6 c4 02             	test   $0x2,%ah
80108101:	0f 84 79 ff ff ff    	je     80108080 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108107:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010810a:	89 f2                	mov    %esi,%edx
8010810c:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80108111:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
80108117:	e8 d4 f3 ff ff       	call   801074f0 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
8010811c:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
8010811f:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108125:	77 ba                	ja     801080e1 <copyuvm+0x91>

bad:
  cprintf("bad: copyuvm\n");
  freevm(d);
  return 0;
}
80108127:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010812a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010812d:	5b                   	pop    %ebx
8010812e:	5e                   	pop    %esi
8010812f:	5f                   	pop    %edi
80108130:	5d                   	pop    %ebp
80108131:	c3                   	ret    
80108132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
80108138:	83 ec 0c             	sub    $0xc,%esp
8010813b:	68 da 9a 10 80       	push   $0x80109ada
80108140:	e8 1b 85 ff ff       	call   80100660 <cprintf>
      kfree(mem);
80108145:	89 1c 24             	mov    %ebx,(%esp)
80108148:	e8 13 a9 ff ff       	call   80102a60 <kfree>
      goto bad;
8010814d:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
80108150:	83 ec 0c             	sub    $0xc,%esp
80108153:	68 f4 9a 10 80       	push   $0x80109af4
80108158:	e8 03 85 ff ff       	call   80100660 <cprintf>
  freevm(d);
8010815d:	58                   	pop    %eax
8010815e:	ff 75 e0             	pushl  -0x20(%ebp)
80108161:	e8 7a fb ff ff       	call   80107ce0 <freevm>
  return 0;
80108166:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
8010816d:	83 c4 10             	add    $0x10,%esp
}
80108170:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108176:	5b                   	pop    %ebx
80108177:	5e                   	pop    %esi
80108178:	5f                   	pop    %edi
80108179:	5d                   	pop    %ebp
8010817a:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
8010817b:	83 ec 0c             	sub    $0xc,%esp
8010817e:	68 e0 9c 10 80       	push   $0x80109ce0
80108183:	e8 08 82 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108188:	83 ec 0c             	sub    $0xc,%esp
8010818b:	68 c0 9a 10 80       	push   $0x80109ac0
80108190:	e8 fb 81 ff ff       	call   80100390 <panic>
80108195:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801081a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801081a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801081a1:	31 c9                	xor    %ecx,%ecx
{
801081a3:	89 e5                	mov    %esp,%ebp
801081a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801081a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801081ab:	8b 45 08             	mov    0x8(%ebp),%eax
801081ae:	e8 3d f3 ff ff       	call   801074f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
801081b3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801081b5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801081b6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801081bd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801081c0:	05 00 00 00 80       	add    $0x80000000,%eax
801081c5:	83 fa 05             	cmp    $0x5,%edx
801081c8:	ba 00 00 00 00       	mov    $0x0,%edx
801081cd:	0f 45 c2             	cmovne %edx,%eax
}
801081d0:	c3                   	ret    
801081d1:	eb 0d                	jmp    801081e0 <copyout>
801081d3:	90                   	nop
801081d4:	90                   	nop
801081d5:	90                   	nop
801081d6:	90                   	nop
801081d7:	90                   	nop
801081d8:	90                   	nop
801081d9:	90                   	nop
801081da:	90                   	nop
801081db:	90                   	nop
801081dc:	90                   	nop
801081dd:	90                   	nop
801081de:	90                   	nop
801081df:	90                   	nop

801081e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801081e0:	55                   	push   %ebp
801081e1:	89 e5                	mov    %esp,%ebp
801081e3:	57                   	push   %edi
801081e4:	56                   	push   %esi
801081e5:	53                   	push   %ebx
801081e6:	83 ec 1c             	sub    $0x1c,%esp
801081e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801081ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801081ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801081f2:	85 db                	test   %ebx,%ebx
801081f4:	75 40                	jne    80108236 <copyout+0x56>
801081f6:	eb 70                	jmp    80108268 <copyout+0x88>
801081f8:	90                   	nop
801081f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108200:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108203:	89 f1                	mov    %esi,%ecx
80108205:	29 d1                	sub    %edx,%ecx
80108207:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010820d:	39 d9                	cmp    %ebx,%ecx
8010820f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108212:	29 f2                	sub    %esi,%edx
80108214:	83 ec 04             	sub    $0x4,%esp
80108217:	01 d0                	add    %edx,%eax
80108219:	51                   	push   %ecx
8010821a:	57                   	push   %edi
8010821b:	50                   	push   %eax
8010821c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010821f:	e8 cc d1 ff ff       	call   801053f0 <memmove>
    len -= n;
    buf += n;
80108224:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108227:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010822a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108230:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108232:	29 cb                	sub    %ecx,%ebx
80108234:	74 32                	je     80108268 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108236:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108238:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010823b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010823e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108244:	56                   	push   %esi
80108245:	ff 75 08             	pushl  0x8(%ebp)
80108248:	e8 53 ff ff ff       	call   801081a0 <uva2ka>
    if(pa0 == 0)
8010824d:	83 c4 10             	add    $0x10,%esp
80108250:	85 c0                	test   %eax,%eax
80108252:	75 ac                	jne    80108200 <copyout+0x20>
  }
  return 0;
}
80108254:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010825c:	5b                   	pop    %ebx
8010825d:	5e                   	pop    %esi
8010825e:	5f                   	pop    %edi
8010825f:	5d                   	pop    %ebp
80108260:	c3                   	ret    
80108261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010826b:	31 c0                	xor    %eax,%eax
}
8010826d:	5b                   	pop    %ebx
8010826e:	5e                   	pop    %esi
8010826f:	5f                   	pop    %edi
80108270:	5d                   	pop    %ebp
80108271:	c3                   	ret    
80108272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108280 <getNextFreeRamIndex>:

int
getNextFreeRamIndex()
{ 
80108280:	55                   	push   %ebp
80108281:	89 e5                	mov    %esp,%ebp
80108283:	83 ec 08             	sub    $0x8,%esp
  int i;
  struct proc * currproc = myproc();
80108286:	e8 45 c0 ff ff       	call   801042d0 <myproc>
8010828b:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108291:	31 c0                	xor    %eax,%eax
80108293:	eb 0e                	jmp    801082a3 <getNextFreeRamIndex+0x23>
80108295:	8d 76 00             	lea    0x0(%esi),%esi
80108298:	83 c0 01             	add    $0x1,%eax
8010829b:	83 c2 1c             	add    $0x1c,%edx
8010829e:	83 f8 10             	cmp    $0x10,%eax
801082a1:	74 0d                	je     801082b0 <getNextFreeRamIndex+0x30>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
801082a3:	8b 0a                	mov    (%edx),%ecx
801082a5:	85 c9                	test   %ecx,%ecx
801082a7:	75 ef                	jne    80108298 <getNextFreeRamIndex+0x18>
      return i;
  }
  return -1;
}
801082a9:	c9                   	leave  
801082aa:	c3                   	ret    
801082ab:	90                   	nop
801082ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
801082b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082b5:	c9                   	leave  
801082b6:	c3                   	ret    
801082b7:	89 f6                	mov    %esi,%esi
801082b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082c0 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
801082c0:	55                   	push   %ebp
801082c1:	89 e5                	mov    %esp,%ebp
801082c3:	56                   	push   %esi
801082c4:	53                   	push   %ebx
801082c5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
801082c8:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
801082ce:	81 c6 08 04 00 00    	add    $0x408,%esi
801082d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  pte_t *pte;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
  {
    struct page *cur_page = &ramPages[i];
    if(!cur_page->isused)
801082d8:	8b 43 04             	mov    0x4(%ebx),%eax
801082db:	85 c0                	test   %eax,%eax
801082dd:	74 27                	je     80108306 <updateLapa+0x46>
      continue;
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
801082df:	8b 53 08             	mov    0x8(%ebx),%edx
801082e2:	8b 03                	mov    (%ebx),%eax
801082e4:	31 c9                	xor    %ecx,%ecx
801082e6:	e8 05 f2 ff ff       	call   801074f0 <walkpgdir>
801082eb:	85 c0                	test   %eax,%eax
801082ed:	74 25                	je     80108314 <updateLapa+0x54>
801082ef:	8b 4b 18             	mov    0x18(%ebx),%ecx
801082f2:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter << 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
801082f5:	89 d1                	mov    %edx,%ecx
801082f7:	81 c9 00 00 00 80    	or     $0x80000000,%ecx
801082fd:	f6 00 20             	testb  $0x20,(%eax)
80108300:	0f 45 d1             	cmovne %ecx,%edx
80108303:	89 53 18             	mov    %edx,0x18(%ebx)
80108306:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108309:	39 f3                	cmp    %esi,%ebx
8010830b:	75 cb                	jne    801082d8 <updateLapa+0x18>
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter << 1; // just shit right one bit
    }
  }
}
8010830d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108310:	5b                   	pop    %ebx
80108311:	5e                   	pop    %esi
80108312:	5d                   	pop    %ebp
80108313:	c3                   	ret    
      panic("updateLapa: no pte");
80108314:	83 ec 0c             	sub    $0xc,%esp
80108317:	68 02 9b 10 80       	push   $0x80109b02
8010831c:	e8 6f 80 ff ff       	call   80100390 <panic>
80108321:	eb 0d                	jmp    80108330 <updateNfua>
80108323:	90                   	nop
80108324:	90                   	nop
80108325:	90                   	nop
80108326:	90                   	nop
80108327:	90                   	nop
80108328:	90                   	nop
80108329:	90                   	nop
8010832a:	90                   	nop
8010832b:	90                   	nop
8010832c:	90                   	nop
8010832d:	90                   	nop
8010832e:	90                   	nop
8010832f:	90                   	nop

80108330 <updateNfua>:

void updateNfua(struct proc* p)
{
80108330:	55                   	push   %ebp
80108331:	89 e5                	mov    %esp,%ebp
80108333:	56                   	push   %esi
80108334:	53                   	push   %ebx
80108335:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108338:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010833e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int i;
  pte_t *pte;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
  {
    struct page *cur_page = &ramPages[i];
    if(!cur_page->isused)
80108348:	8b 43 04             	mov    0x4(%ebx),%eax
8010834b:	85 c0                	test   %eax,%eax
8010834d:	74 27                	je     80108376 <updateNfua+0x46>
      continue;
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010834f:	8b 53 08             	mov    0x8(%ebx),%edx
80108352:	8b 03                	mov    (%ebx),%eax
80108354:	31 c9                	xor    %ecx,%ecx
80108356:	e8 95 f1 ff ff       	call   801074f0 <walkpgdir>
8010835b:	85 c0                	test   %eax,%eax
8010835d:	74 25                	je     80108384 <updateNfua+0x54>
8010835f:	8b 4b 14             	mov    0x14(%ebx),%ecx
80108362:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter << 1; // shift right one bit
      cur_page->nfua_counter |= 1 << 31; // turn on MSB
80108365:	89 d1                	mov    %edx,%ecx
80108367:	81 c9 00 00 00 80    	or     $0x80000000,%ecx
8010836d:	f6 00 20             	testb  $0x20,(%eax)
80108370:	0f 45 d1             	cmovne %ecx,%edx
80108373:	89 53 14             	mov    %edx,0x14(%ebx)
80108376:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108379:	39 f3                	cmp    %esi,%ebx
8010837b:	75 cb                	jne    80108348 <updateNfua+0x18>
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter << 1; // just shit right one bit
    }
  }
}
8010837d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108380:	5b                   	pop    %ebx
80108381:	5e                   	pop    %esi
80108382:	5d                   	pop    %ebp
80108383:	c3                   	ret    
      panic("updateNfua: no pte");
80108384:	83 ec 0c             	sub    $0xc,%esp
80108387:	68 15 9b 10 80       	push   $0x80109b15
8010838c:	e8 ff 7f ff ff       	call   80100390 <panic>
80108391:	eb 0d                	jmp    801083a0 <aq>
80108393:	90                   	nop
80108394:	90                   	nop
80108395:	90                   	nop
80108396:	90                   	nop
80108397:	90                   	nop
80108398:	90                   	nop
80108399:	90                   	nop
8010839a:	90                   	nop
8010839b:	90                   	nop
8010839c:	90                   	nop
8010839d:	90                   	nop
8010839e:	90                   	nop
8010839f:	90                   	nop

801083a0 <aq>:
  return 11; // default
  #endif
}

uint aq()
{
801083a0:	55                   	push   %ebp
801083a1:	89 e5                	mov    %esp,%ebp
801083a3:	57                   	push   %edi
801083a4:	56                   	push   %esi
801083a5:	53                   	push   %ebx
801083a6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801083a9:	e8 22 bf ff ff       	call   801042d0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
801083ae:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
801083b4:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
801083ba:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
801083bc:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
801083bf:	74 45                	je     80108406 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
801083c1:	39 d1                	cmp    %edx,%ecx
801083c3:	89 c3                	mov    %eax,%ebx
801083c5:	74 31                	je     801083f8 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
801083c7:	8b 41 04             	mov    0x4(%ecx),%eax
801083ca:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
801083d0:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
801083d6:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
801083d9:	83 ec 0c             	sub    $0xc,%esp
801083dc:	52                   	push   %edx
801083dd:	e8 7e a6 ff ff       	call   80102a60 <kfree>
  curproc->queue_tail = new_tail;
801083e2:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
801083e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083eb:	89 f0                	mov    %esi,%eax
801083ed:	5b                   	pop    %ebx
801083ee:	5e                   	pop    %esi
801083ef:	5f                   	pop    %edi
801083f0:	5d                   	pop    %ebp
801083f1:	c3                   	ret    
801083f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
801083f8:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
801083ff:	00 00 00 
    new_tail = 0;
80108402:	31 ff                	xor    %edi,%edi
80108404:	eb d3                	jmp    801083d9 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108406:	83 ec 0c             	sub    $0xc,%esp
80108409:	68 1c 9d 10 80       	push   $0x80109d1c
8010840e:	e8 7d 7f ff ff       	call   80100390 <panic>
80108413:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108420 <nfua>:
    minloc = nfua(); // re-use of nfua code
  
  return minloc;
}
uint nfua()
{
80108420:	55                   	push   %ebp
80108421:	89 e5                	mov    %esp,%ebp
80108423:	56                   	push   %esi
80108424:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108425:	e8 a6 be ff ff       	call   801042d0 <myproc>
  /* find the page with the minimal nfua */
  int i;
  uint minval = ramPages[0].nfua_counter;
  uint minloc = 0;

  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010842a:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
8010842f:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108435:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
8010843b:	31 c0                	xor    %eax,%eax
8010843d:	8d 76 00             	lea    0x0(%esi),%esi
  {
    if(ramPages[i].nfua_counter < minval)
80108440:	8b 19                	mov    (%ecx),%ebx
80108442:	39 f3                	cmp    %esi,%ebx
80108444:	73 04                	jae    8010844a <nfua+0x2a>
    {
      minval = ramPages[i].nfua_counter;
      minloc = i;
80108446:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108448:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010844a:	83 c2 01             	add    $0x1,%edx
8010844d:	83 c1 1c             	add    $0x1c,%ecx
80108450:	83 fa 10             	cmp    $0x10,%edx
80108453:	75 eb                	jne    80108440 <nfua+0x20>
    }
  }
  return minloc;
}
80108455:	5b                   	pop    %ebx
80108456:	5e                   	pop    %esi
80108457:	5d                   	pop    %ebp
80108458:	c3                   	ret    
80108459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108460 <lapa>:
{
80108460:	55                   	push   %ebp
80108461:	89 e5                	mov    %esp,%ebp
80108463:	57                   	push   %edi
80108464:	56                   	push   %esi
80108465:	53                   	push   %ebx
    return -1;
}

uint countSetBits(uint n)
{
    uint count = 0;
80108466:	31 ff                	xor    %edi,%edi
{
80108468:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010846b:	e8 60 be ff ff       	call   801042d0 <myproc>
  uint minNumOfOnes = countSetBits(ramPages[0].nfua_counter);
80108470:	8b 90 5c 02 00 00    	mov    0x25c(%eax),%edx
    while (n) {
80108476:	85 d2                	test   %edx,%edx
80108478:	74 11                	je     8010848b <lapa+0x2b>
8010847a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
80108480:	89 d1                	mov    %edx,%ecx
80108482:	83 e1 01             	and    $0x1,%ecx
80108485:	01 cf                	add    %ecx,%edi
    while (n) {
80108487:	d1 ea                	shr    %edx
80108489:	75 f5                	jne    80108480 <lapa+0x20>
8010848b:	8d b0 7c 02 00 00    	lea    0x27c(%eax),%esi
  uint instances = 0;
80108491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  uint minloc = 0;
80108498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i = 1; i < MAX_PSYC_PAGES; i++)
8010849f:	bb 01 00 00 00       	mov    $0x1,%ebx
801084a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
801084a8:	8b 06                	mov    (%esi),%eax
    uint count = 0;
801084aa:	31 d2                	xor    %edx,%edx
    while (n) {
801084ac:	85 c0                	test   %eax,%eax
801084ae:	74 0b                	je     801084bb <lapa+0x5b>
        count += n & 1;
801084b0:	89 c1                	mov    %eax,%ecx
801084b2:	83 e1 01             	and    $0x1,%ecx
801084b5:	01 ca                	add    %ecx,%edx
    while (n) {
801084b7:	d1 e8                	shr    %eax
801084b9:	75 f5                	jne    801084b0 <lapa+0x50>
    if(numOfOnes < minNumOfOnes)
801084bb:	39 fa                	cmp    %edi,%edx
801084bd:	72 29                	jb     801084e8 <lapa+0x88>
      instances++;
801084bf:	0f 94 c0             	sete   %al
801084c2:	0f b6 c0             	movzbl %al,%eax
801084c5:	01 45 e4             	add    %eax,-0x1c(%ebp)
  for(i = 1; i < MAX_PSYC_PAGES; i++)
801084c8:	83 c3 01             	add    $0x1,%ebx
801084cb:	83 c6 1c             	add    $0x1c,%esi
801084ce:	83 fb 10             	cmp    $0x10,%ebx
801084d1:	75 d5                	jne    801084a8 <lapa+0x48>
  if(instances > 1) // more than one counter with minimal number of 1's
801084d3:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
801084d7:	76 1d                	jbe    801084f6 <lapa+0x96>
}
801084d9:	83 c4 1c             	add    $0x1c,%esp
801084dc:	5b                   	pop    %ebx
801084dd:	5e                   	pop    %esi
801084de:	5f                   	pop    %edi
801084df:	5d                   	pop    %ebp
    minloc = nfua(); // re-use of nfua code
801084e0:	e9 3b ff ff ff       	jmp    80108420 <nfua>
801084e5:	8d 76 00             	lea    0x0(%esi),%esi
      minloc = i;
801084e8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
801084eb:	89 d7                	mov    %edx,%edi
      instances = 1;
801084ed:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
801084f4:	eb d2                	jmp    801084c8 <lapa+0x68>
}
801084f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801084f9:	83 c4 1c             	add    $0x1c,%esp
801084fc:	5b                   	pop    %ebx
801084fd:	5e                   	pop    %esi
801084fe:	5f                   	pop    %edi
801084ff:	5d                   	pop    %ebp
80108500:	c3                   	ret    
80108501:	eb 0d                	jmp    80108510 <scfifo>
80108503:	90                   	nop
80108504:	90                   	nop
80108505:	90                   	nop
80108506:	90                   	nop
80108507:	90                   	nop
80108508:	90                   	nop
80108509:	90                   	nop
8010850a:	90                   	nop
8010850b:	90                   	nop
8010850c:	90                   	nop
8010850d:	90                   	nop
8010850e:	90                   	nop
8010850f:	90                   	nop

80108510 <scfifo>:
{
80108510:	55                   	push   %ebp
80108511:	89 e5                	mov    %esp,%ebp
80108513:	57                   	push   %edi
80108514:	56                   	push   %esi
80108515:	53                   	push   %ebx
80108516:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108519:	e8 b2 bd ff ff       	call   801042d0 <myproc>
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
8010851e:	8b 98 10 04 00 00    	mov    0x410(%eax),%ebx
  struct proc* curproc = myproc();
80108524:	89 c7                	mov    %eax,%edi
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108526:	83 fb 0f             	cmp    $0xf,%ebx
80108529:	7f 5f                	jg     8010858a <scfifo+0x7a>
8010852b:	6b c3 1c             	imul   $0x1c,%ebx,%eax
8010852e:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108535:	eb 19                	jmp    80108550 <scfifo+0x40>
80108537:	89 f6                	mov    %esi,%esi
80108539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80108540:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108543:	83 e2 df             	and    $0xffffffdf,%edx
80108546:	83 c6 1c             	add    $0x1c,%esi
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108549:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
8010854c:	89 10                	mov    %edx,(%eax)
    for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
8010854e:	74 30                	je     80108580 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108550:	8b 56 08             	mov    0x8(%esi),%edx
80108553:	8b 06                	mov    (%esi),%eax
80108555:	31 c9                	xor    %ecx,%ecx
80108557:	e8 94 ef ff ff       	call   801074f0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
8010855c:	8b 10                	mov    (%eax),%edx
8010855e:	f6 c2 20             	test   $0x20,%dl
80108561:	75 dd                	jne    80108540 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108563:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
8010856a:	74 7c                	je     801085e8 <scfifo+0xd8>
            curproc->clockHand = i + 1;
8010856c:	8d 43 01             	lea    0x1(%ebx),%eax
8010856f:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
80108575:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108578:	89 d8                	mov    %ebx,%eax
8010857a:	5b                   	pop    %ebx
8010857b:	5e                   	pop    %esi
8010857c:	5f                   	pop    %edi
8010857d:	5d                   	pop    %ebp
8010857e:	c3                   	ret    
8010857f:	90                   	nop
    for(j=0; j< curproc->clockHand ;j++)
80108580:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108586:	85 c0                	test   %eax,%eax
80108588:	74 72                	je     801085fc <scfifo+0xec>
8010858a:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108590:	31 db                	xor    %ebx,%ebx
80108592:	eb 16                	jmp    801085aa <scfifo+0x9a>
80108594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          *pte &= ~PTE_A;  
80108598:	83 e1 df             	and    $0xffffffdf,%ecx
8010859b:	83 c6 1c             	add    $0x1c,%esi
    for(j=0; j< curproc->clockHand ;j++)
8010859e:	89 d3                	mov    %edx,%ebx
          *pte &= ~PTE_A;  
801085a0:	89 08                	mov    %ecx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
801085a2:	39 97 10 04 00 00    	cmp    %edx,0x410(%edi)
801085a8:	76 52                	jbe    801085fc <scfifo+0xec>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
801085aa:	8b 56 08             	mov    0x8(%esi),%edx
801085ad:	8b 06                	mov    (%esi),%eax
801085af:	31 c9                	xor    %ecx,%ecx
801085b1:	e8 3a ef ff ff       	call   801074f0 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
801085b6:	8b 08                	mov    (%eax),%ecx
801085b8:	8d 53 01             	lea    0x1(%ebx),%edx
801085bb:	f6 c1 20             	test   $0x20,%cl
801085be:	75 d8                	jne    80108598 <scfifo+0x88>
          cprintf("scfifo returned %d\n", j);
801085c0:	83 ec 08             	sub    $0x8,%esp
          curproc->clockHand = j + 1;
801085c3:	89 97 10 04 00 00    	mov    %edx,0x410(%edi)
          cprintf("scfifo returned %d\n", j);
801085c9:	53                   	push   %ebx
801085ca:	68 28 9b 10 80       	push   $0x80109b28
801085cf:	e8 8c 80 ff ff       	call   80100660 <cprintf>
          return j;
801085d4:	83 c4 10             	add    $0x10,%esp
}
801085d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085da:	89 d8                	mov    %ebx,%eax
801085dc:	5b                   	pop    %ebx
801085dd:	5e                   	pop    %esi
801085de:	5f                   	pop    %edi
801085df:	5d                   	pop    %ebp
801085e0:	c3                   	ret    
801085e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            curproc->clockHand = 0;
801085e8:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
801085ef:	00 00 00 
}
801085f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085f5:	89 d8                	mov    %ebx,%eax
801085f7:	5b                   	pop    %ebx
801085f8:	5e                   	pop    %esi
801085f9:	5f                   	pop    %edi
801085fa:	5d                   	pop    %ebp
801085fb:	c3                   	ret    
    panic("scfifo: not found any index!");
801085fc:	83 ec 0c             	sub    $0xc,%esp
801085ff:	68 3c 9b 10 80       	push   $0x80109b3c
80108604:	e8 87 7d ff ff       	call   80100390 <panic>
80108609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108610 <indexToEvict>:
{  
80108610:	55                   	push   %ebp
80108611:	89 e5                	mov    %esp,%ebp
}
80108613:	5d                   	pop    %ebp
    return scfifo();
80108614:	e9 f7 fe ff ff       	jmp    80108510 <scfifo>
80108619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108620 <allocuvm_withswap>:
{
80108620:	55                   	push   %ebp
80108621:	89 e5                	mov    %esp,%ebp
80108623:	57                   	push   %edi
80108624:	56                   	push   %esi
80108625:	53                   	push   %ebx
80108626:	83 ec 18             	sub    $0x18,%esp
80108629:	8b 75 08             	mov    0x8(%ebp),%esi
  cprintf("--allocate with swap--\n\n");
8010862c:	68 59 9b 10 80       	push   $0x80109b59
80108631:	e8 2a 80 ff ff       	call   80100660 <cprintf>
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80108636:	83 c4 10             	add    $0x10,%esp
80108639:	83 be 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%esi)
80108640:	0f 8f 7f 01 00 00    	jg     801087c5 <allocuvm_withswap+0x1a5>
    return scfifo();
80108646:	e8 c5 fe ff ff       	call   80108510 <scfifo>
      cprintf("index to evict: %d\n",evicted_ind);
8010864b:	83 ec 08             	sub    $0x8,%esp
    return scfifo();
8010864e:	89 c3                	mov    %eax,%ebx
      cprintf("index to evict: %d\n",evicted_ind);
80108650:	50                   	push   %eax
80108651:	68 8a 9b 10 80       	push   $0x80109b8a
80108656:	e8 05 80 ff ff       	call   80100660 <cprintf>
      int swap_offset = curproc->free_head->off;
8010865b:	8b 96 14 04 00 00    	mov    0x414(%esi),%edx
      if(curproc->free_head->next == 0)
80108661:	83 c4 10             	add    $0x10,%esp
80108664:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80108667:	8b 3a                	mov    (%edx),%edi
      if(curproc->free_head->next == 0)
80108669:	85 c0                	test   %eax,%eax
8010866b:	0f 84 2f 01 00 00    	je     801087a0 <allocuvm_withswap+0x180>
        kfree((char*)curproc->free_head->prev);
80108671:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80108674:	89 86 14 04 00 00    	mov    %eax,0x414(%esi)
        kfree((char*)curproc->free_head->prev);
8010867a:	ff 70 08             	pushl  0x8(%eax)
8010867d:	e8 de a3 ff ff       	call   80102a60 <kfree>
80108682:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80108685:	6b db 1c             	imul   $0x1c,%ebx,%ebx
      cprintf("before write to swap\n");
80108688:	83 ec 0c             	sub    $0xc,%esp
8010868b:	68 9e 9b 10 80       	push   $0x80109b9e
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80108690:	01 f3                	add    %esi,%ebx
      cprintf("before write to swap\n");
80108692:	e8 c9 7f ff ff       	call   80100660 <cprintf>
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80108697:	68 00 10 00 00       	push   $0x1000
8010869c:	57                   	push   %edi
8010869d:	ff b3 50 02 00 00    	pushl  0x250(%ebx)
801086a3:	56                   	push   %esi
801086a4:	e8 67 9f ff ff       	call   80102610 <writeToSwapFile>
801086a9:	83 c4 20             	add    $0x20,%esp
801086ac:	85 c0                	test   %eax,%eax
801086ae:	0f 88 2b 01 00 00    	js     801087df <allocuvm_withswap+0x1bf>
      cprintf("after write to swap\n");
801086b4:	83 ec 0c             	sub    $0xc,%esp
801086b7:	68 ce 9b 10 80       	push   $0x80109bce
801086bc:	e8 9f 7f ff ff       	call   80100660 <cprintf>
      curproc->swappedPages[curproc->num_swap].isused = 1;
801086c1:	8b 96 0c 04 00 00    	mov    0x40c(%esi),%edx
801086c7:	6b c2 1c             	imul   $0x1c,%edx,%eax
801086ca:	01 f0                	add    %esi,%eax
801086cc:	c7 80 8c 00 00 00 01 	movl   $0x1,0x8c(%eax)
801086d3:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
801086d6:	8b 8b 50 02 00 00    	mov    0x250(%ebx),%ecx
801086dc:	89 88 90 00 00 00    	mov    %ecx,0x90(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
801086e2:	8b 8b 48 02 00 00    	mov    0x248(%ebx),%ecx
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
801086e8:	89 b8 94 00 00 00    	mov    %edi,0x94(%eax)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
801086ee:	89 88 88 00 00 00    	mov    %ecx,0x88(%eax)
      cprintf("num swap: %d\n", curproc->num_swap);
801086f4:	58                   	pop    %eax
801086f5:	59                   	pop    %ecx
801086f6:	52                   	push   %edx
801086f7:	68 e3 9b 10 80       	push   $0x80109be3
801086fc:	e8 5f 7f ff ff       	call   80100660 <cprintf>
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80108701:	8b 86 0c 04 00 00    	mov    0x40c(%esi),%eax
80108707:	6b d0 1c             	imul   $0x1c,%eax,%edx
8010870a:	8b 94 16 88 00 00 00 	mov    0x88(%esi,%edx,1),%edx
80108711:	81 c2 00 00 00 80    	add    $0x80000000,%edx
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108717:	0f 22 da             	mov    %edx,%cr3
      curproc->num_swap ++;
8010871a:	83 c0 01             	add    $0x1,%eax
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
8010871d:	31 c9                	xor    %ecx,%ecx
      curproc->num_swap ++;
8010871f:	89 86 0c 04 00 00    	mov    %eax,0x40c(%esi)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80108725:	8b 93 50 02 00 00    	mov    0x250(%ebx),%edx
8010872b:	8b 83 48 02 00 00    	mov    0x248(%ebx),%eax
80108731:	e8 ba ed ff ff       	call   801074f0 <walkpgdir>
      if(!(*evicted_pte & PTE_P))
80108736:	8b 10                	mov    (%eax),%edx
80108738:	83 c4 10             	add    $0x10,%esp
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
8010873b:	89 c6                	mov    %eax,%esi
      if(!(*evicted_pte & PTE_P))
8010873d:	f6 c2 01             	test   $0x1,%dl
80108740:	0f 84 8c 00 00 00    	je     801087d2 <allocuvm_withswap+0x1b2>
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80108746:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(evicted_pa));
8010874c:	83 ec 0c             	sub    $0xc,%esp
8010874f:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108755:	52                   	push   %edx
80108756:	e8 05 a3 ff ff       	call   80102a60 <kfree>
      *evicted_pte &= ~PTE_P;
8010875b:	8b 16                	mov    (%esi),%edx
      newpage->pgdir = pgdir; // ??? 
8010875d:	8b 45 0c             	mov    0xc(%ebp),%eax
}
80108760:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
80108763:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
80108769:	80 ce 02             	or     $0x2,%dh
8010876c:	89 16                	mov    %edx,(%esi)
      newpage->pgdir = pgdir; // ??? 
8010876e:	89 83 48 02 00 00    	mov    %eax,0x248(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80108774:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->isused = 1;
80108777:	c7 83 4c 02 00 00 01 	movl   $0x1,0x24c(%ebx)
8010877e:	00 00 00 
      newpage->swap_offset = -1;
80108781:	c7 83 54 02 00 00 ff 	movl   $0xffffffff,0x254(%ebx)
80108788:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
8010878b:	89 83 50 02 00 00    	mov    %eax,0x250(%ebx)
}
80108791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108794:	5b                   	pop    %ebx
80108795:	5e                   	pop    %esi
80108796:	5f                   	pop    %edi
80108797:	5d                   	pop    %ebp
80108798:	c3                   	ret    
80108799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
801087a0:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
801087a3:	c7 86 18 04 00 00 00 	movl   $0x0,0x418(%esi)
801087aa:	00 00 00 
        kfree((char*)curproc->free_head);
801087ad:	52                   	push   %edx
801087ae:	e8 ad a2 ff ff       	call   80102a60 <kfree>
        curproc->free_head = 0;
801087b3:	c7 86 14 04 00 00 00 	movl   $0x0,0x414(%esi)
801087ba:	00 00 00 
801087bd:	83 c4 10             	add    $0x10,%esp
801087c0:	e9 c0 fe ff ff       	jmp    80108685 <allocuvm_withswap+0x65>
        panic("exceeded max swap pages");
801087c5:	83 ec 0c             	sub    $0xc,%esp
801087c8:	68 72 9b 10 80       	push   $0x80109b72
801087cd:	e8 be 7b ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
801087d2:	83 ec 0c             	sub    $0xc,%esp
801087d5:	68 5c 9d 10 80       	push   $0x80109d5c
801087da:	e8 b1 7b ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801087df:	83 ec 0c             	sub    $0xc,%esp
801087e2:	68 b4 9b 10 80       	push   $0x80109bb4
801087e7:	e8 a4 7b ff ff       	call   80100390 <panic>
801087ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801087f0 <allocuvm_paging>:
{
801087f0:	55                   	push   %ebp
801087f1:	89 e5                	mov    %esp,%ebp
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
801087f3:	8b 45 08             	mov    0x8(%ebp),%eax
801087f6:	83 b8 08 04 00 00 0f 	cmpl   $0xf,0x408(%eax)
801087fd:	7e 09                	jle    80108808 <allocuvm_paging+0x18>
}
801087ff:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80108800:	e9 1b fe ff ff       	jmp    80108620 <allocuvm_withswap>
80108805:	8d 76 00             	lea    0x0(%esi),%esi
}
80108808:	5d                   	pop    %ebp
       allocuvm_noswap(curproc, pgdir, rounded_virtaddr); 
80108809:	e9 32 f2 ff ff       	jmp    80107a40 <allocuvm_noswap>
8010880e:	66 90                	xchg   %ax,%ax

80108810 <allocuvm>:
{
80108810:	55                   	push   %ebp
80108811:	89 e5                	mov    %esp,%ebp
80108813:	57                   	push   %edi
80108814:	56                   	push   %esi
80108815:	53                   	push   %ebx
80108816:	83 ec 28             	sub    $0x28,%esp
  cprintf("*** ALLOCUVM ***\n");
80108819:	68 f1 9b 10 80       	push   $0x80109bf1
8010881e:	e8 3d 7e ff ff       	call   80100660 <cprintf>
  struct proc* curproc = myproc();
80108823:	e8 a8 ba ff ff       	call   801042d0 <myproc>
  if(newsz >= KERNBASE)
80108828:	8b 7d 10             	mov    0x10(%ebp),%edi
8010882b:	83 c4 10             	add    $0x10,%esp
8010882e:	85 ff                	test   %edi,%edi
80108830:	0f 88 ca 00 00 00    	js     80108900 <allocuvm+0xf0>
  if(newsz < oldsz)
80108836:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80108839:	0f 82 b1 00 00 00    	jb     801088f0 <allocuvm+0xe0>
8010883f:	89 c2                	mov    %eax,%edx
  a = PGROUNDUP(oldsz);
80108841:	8b 45 0c             	mov    0xc(%ebp),%eax
80108844:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010884a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80108850:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108853:	0f 86 9a 00 00 00    	jbe    801088f3 <allocuvm+0xe3>
80108859:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010885c:	89 d7                	mov    %edx,%edi
8010885e:	eb 0b                	jmp    8010886b <allocuvm+0x5b>
80108860:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80108866:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108869:	76 72                	jbe    801088dd <allocuvm+0xcd>
    mem = kalloc();
8010886b:	e8 d0 a4 ff ff       	call   80102d40 <kalloc>
    if(mem == 0){
80108870:	85 c0                	test   %eax,%eax
    mem = kalloc();
80108872:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80108874:	0f 84 96 00 00 00    	je     80108910 <allocuvm+0x100>
    memset(mem, 0, PGSIZE);
8010887a:	83 ec 04             	sub    $0x4,%esp
8010887d:	68 00 10 00 00       	push   $0x1000
80108882:	6a 00                	push   $0x0
80108884:	50                   	push   %eax
80108885:	e8 b6 ca ff ff       	call   80105340 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010888a:	58                   	pop    %eax
8010888b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108891:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108896:	5a                   	pop    %edx
80108897:	6a 06                	push   $0x6
80108899:	50                   	push   %eax
8010889a:	89 da                	mov    %ebx,%edx
8010889c:	8b 45 08             	mov    0x8(%ebp),%eax
8010889f:	e8 cc ec ff ff       	call   80107570 <mappages>
801088a4:	83 c4 10             	add    $0x10,%esp
801088a7:	85 c0                	test   %eax,%eax
801088a9:	0f 88 91 00 00 00    	js     80108940 <allocuvm+0x130>
    if(curproc->pid > 2) 
801088af:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
801088b3:	7e ab                	jle    80108860 <allocuvm+0x50>
        cprintf("going to execute: allocuvm_paging\n");
801088b5:	83 ec 0c             	sub    $0xc,%esp
801088b8:	68 84 9d 10 80       	push   $0x80109d84
801088bd:	e8 9e 7d ff ff       	call   80100660 <cprintf>
        allocuvm_paging(curproc, pgdir, (char *)a);
801088c2:	83 c4 0c             	add    $0xc,%esp
801088c5:	53                   	push   %ebx
801088c6:	ff 75 08             	pushl  0x8(%ebp)
  for(; a < newsz; a += PGSIZE){
801088c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        allocuvm_paging(curproc, pgdir, (char *)a);
801088cf:	57                   	push   %edi
801088d0:	e8 1b ff ff ff       	call   801087f0 <allocuvm_paging>
801088d5:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
801088d8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801088db:	77 8e                	ja     8010886b <allocuvm+0x5b>
801088dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
}
801088e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088e3:	5b                   	pop    %ebx
801088e4:	89 f8                	mov    %edi,%eax
801088e6:	5e                   	pop    %esi
801088e7:	5f                   	pop    %edi
801088e8:	5d                   	pop    %ebp
801088e9:	c3                   	ret    
801088ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return oldsz;
801088f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801088f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801088f6:	89 f8                	mov    %edi,%eax
801088f8:	5b                   	pop    %ebx
801088f9:	5e                   	pop    %esi
801088fa:	5f                   	pop    %edi
801088fb:	5d                   	pop    %ebp
801088fc:	c3                   	ret    
801088fd:	8d 76 00             	lea    0x0(%esi),%esi
80108900:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80108903:	31 ff                	xor    %edi,%edi
}
80108905:	89 f8                	mov    %edi,%eax
80108907:	5b                   	pop    %ebx
80108908:	5e                   	pop    %esi
80108909:	5f                   	pop    %edi
8010890a:	5d                   	pop    %ebp
8010890b:	c3                   	ret    
8010890c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory\n");
80108910:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108913:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory\n");
80108915:	68 03 9c 10 80       	push   $0x80109c03
8010891a:	e8 41 7d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010891f:	83 c4 0c             	add    $0xc,%esp
80108922:	ff 75 0c             	pushl  0xc(%ebp)
80108925:	ff 75 10             	pushl  0x10(%ebp)
80108928:	ff 75 08             	pushl  0x8(%ebp)
8010892b:	e8 90 f1 ff ff       	call   80107ac0 <deallocuvm>
      return 0;
80108930:	83 c4 10             	add    $0x10,%esp
}
80108933:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108936:	89 f8                	mov    %edi,%eax
80108938:	5b                   	pop    %ebx
80108939:	5e                   	pop    %esi
8010893a:	5f                   	pop    %edi
8010893b:	5d                   	pop    %ebp
8010893c:	c3                   	ret    
8010893d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108940:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80108943:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory (2)\n");
80108945:	68 1b 9c 10 80       	push   $0x80109c1b
8010894a:	e8 11 7d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010894f:	83 c4 0c             	add    $0xc,%esp
80108952:	ff 75 0c             	pushl  0xc(%ebp)
80108955:	ff 75 10             	pushl  0x10(%ebp)
80108958:	ff 75 08             	pushl  0x8(%ebp)
8010895b:	e8 60 f1 ff ff       	call   80107ac0 <deallocuvm>
      kfree(mem);
80108960:	89 34 24             	mov    %esi,(%esp)
80108963:	e8 f8 a0 ff ff       	call   80102a60 <kfree>
      return 0;
80108968:	83 c4 10             	add    $0x10,%esp
}
8010896b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010896e:	89 f8                	mov    %edi,%eax
80108970:	5b                   	pop    %ebx
80108971:	5e                   	pop    %esi
80108972:	5f                   	pop    %edi
80108973:	5d                   	pop    %ebp
80108974:	c3                   	ret    
80108975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108980 <handle_pagedout>:
{
80108980:	55                   	push   %ebp
80108981:	89 e5                	mov    %esp,%ebp
80108983:	57                   	push   %edi
80108984:	56                   	push   %esi
80108985:	53                   	push   %ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108986:	31 ff                	xor    %edi,%edi
{
80108988:	83 ec 20             	sub    $0x20,%esp
8010898b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010898e:	8b 75 10             	mov    0x10(%ebp),%esi
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108991:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108994:	ff 73 10             	pushl  0x10(%ebx)
80108997:	50                   	push   %eax
80108998:	68 a8 9d 10 80       	push   $0x80109da8
8010899d:	e8 be 7c ff ff       	call   80100660 <cprintf>
    new_page = kalloc();
801089a2:	e8 99 a3 ff ff       	call   80102d40 <kalloc>
    *pte &= 0xFFF;
801089a7:	8b 16                	mov    (%esi),%edx
    *pte |= V2P(new_page);
801089a9:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
801089ae:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
801089b4:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
801089b7:	09 d0                	or     %edx,%eax
801089b9:	89 06                	mov    %eax,(%esi)
  struct proc* curproc = myproc();
801089bb:	e8 10 b9 ff ff       	call   801042d0 <myproc>
801089c0:	83 c4 10             	add    $0x10,%esp
801089c3:	05 90 00 00 00       	add    $0x90,%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801089c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801089cb:	eb 12                	jmp    801089df <handle_pagedout+0x5f>
801089cd:	8d 76 00             	lea    0x0(%esi),%esi
801089d0:	83 c7 01             	add    $0x1,%edi
801089d3:	83 c0 1c             	add    $0x1c,%eax
801089d6:	83 ff 10             	cmp    $0x10,%edi
801089d9:	0f 84 21 02 00 00    	je     80108c00 <handle_pagedout+0x280>
    if(curproc->swappedPages[i].virt_addr == va)
801089df:	3b 10                	cmp    (%eax),%edx
801089e1:	75 ed                	jne    801089d0 <handle_pagedout+0x50>
801089e3:	6b f7 1c             	imul   $0x1c,%edi,%esi
801089e6:	81 c6 88 00 00 00    	add    $0x88,%esi
    struct page *swap_page = &curproc->swappedPages[index];
801089ec:	8d 04 33             	lea    (%ebx,%esi,1),%eax
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801089ef:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
801089f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801089f7:	6b c7 1c             	imul   $0x1c,%edi,%eax
801089fa:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801089fd:	ff b6 94 00 00 00    	pushl  0x94(%esi)
80108a03:	68 e0 c5 10 80       	push   $0x8010c5e0
80108a08:	53                   	push   %ebx
80108a09:	e8 32 9c ff ff       	call   80102640 <readFromSwapFile>
80108a0e:	83 c4 10             	add    $0x10,%esp
80108a11:	85 c0                	test   %eax,%eax
80108a13:	0f 88 3c 02 00 00    	js     80108c55 <handle_pagedout+0x2d5>
    struct fblock *new_block = (struct fblock*)kalloc();
80108a19:	e8 22 a3 ff ff       	call   80102d40 <kalloc>
    new_block->off = swap_page->swap_offset;
80108a1e:	8b 96 94 00 00 00    	mov    0x94(%esi),%edx
    new_block->next = 0;
80108a24:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
80108a2b:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80108a2d:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108a33:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
80108a36:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108a3c:	85 d2                	test   %edx,%edx
80108a3e:	0f 84 cc 01 00 00    	je     80108c10 <handle_pagedout+0x290>
      curproc->free_tail->next = new_block;
80108a44:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80108a47:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
80108a4a:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108a50:	68 00 10 00 00       	push   $0x1000
80108a55:	68 e0 c5 10 80       	push   $0x8010c5e0
80108a5a:	ff 75 0c             	pushl  0xc(%ebp)
80108a5d:	e8 8e c9 ff ff       	call   801053f0 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80108a62:	83 c4 0c             	add    $0xc,%esp
80108a65:	6a 1c                	push   $0x1c
80108a67:	6a 00                	push   $0x0
80108a69:	ff 75 e4             	pushl  -0x1c(%ebp)
80108a6c:	e8 cf c8 ff ff       	call   80105340 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108a71:	83 c4 10             	add    $0x10,%esp
80108a74:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
80108a7b:	0f 8f 7f 00 00 00    	jg     80108b00 <handle_pagedout+0x180>
  struct proc * currproc = myproc();
80108a81:	e8 4a b8 ff ff       	call   801042d0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108a86:	31 f6                	xor    %esi,%esi
80108a88:	05 4c 02 00 00       	add    $0x24c,%eax
80108a8d:	eb 10                	jmp    80108a9f <handle_pagedout+0x11f>
80108a8f:	90                   	nop
80108a90:	83 c6 01             	add    $0x1,%esi
80108a93:	83 c0 1c             	add    $0x1c,%eax
80108a96:	83 fe 10             	cmp    $0x10,%esi
80108a99:	0f 84 81 01 00 00    	je     80108c20 <handle_pagedout+0x2a0>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108a9f:	8b 10                	mov    (%eax),%edx
80108aa1:	85 d2                	test   %edx,%edx
80108aa3:	75 eb                	jne    80108a90 <handle_pagedout+0x110>
      cprintf("filling ram slot: %d\n", new_indx);
80108aa5:	83 ec 08             	sub    $0x8,%esp
80108aa8:	56                   	push   %esi
80108aa9:	68 40 9a 10 80       	push   $0x80109a40
      curproc->ramPages[new_indx].virt_addr = start_page;
80108aae:	6b f6 1c             	imul   $0x1c,%esi,%esi
      cprintf("filling ram slot: %d\n", new_indx);
80108ab1:	e8 aa 7b ff ff       	call   80100660 <cprintf>
      curproc->ramPages[new_indx].virt_addr = start_page;
80108ab6:	8b 45 0c             	mov    0xc(%ebp),%eax
80108ab9:	83 c4 10             	add    $0x10,%esp
80108abc:	01 de                	add    %ebx,%esi
      curproc->ramPages[new_indx].isused = 1;
80108abe:	c7 86 4c 02 00 00 01 	movl   $0x1,0x24c(%esi)
80108ac5:	00 00 00 
      curproc->ramPages[new_indx].virt_addr = start_page;
80108ac8:	89 86 50 02 00 00    	mov    %eax,0x250(%esi)
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108ace:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
80108ad1:	c7 86 54 02 00 00 ff 	movl   $0xffffffff,0x254(%esi)
80108ad8:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108adb:	89 86 48 02 00 00    	mov    %eax,0x248(%esi)
      curproc->num_ram++;      
80108ae1:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
80108ae8:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
80108aef:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108af2:	5b                   	pop    %ebx
80108af3:	5e                   	pop    %esi
80108af4:	5f                   	pop    %edi
80108af5:	5d                   	pop    %ebp
80108af6:	c3                   	ret    
80108af7:	89 f6                	mov    %esi,%esi
80108af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return scfifo();
80108b00:	e8 0b fa ff ff       	call   80108510 <scfifo>
      cprintf("index to evict: %d\n", index_to_evicet);
80108b05:	83 ec 08             	sub    $0x8,%esp
    return scfifo();
80108b08:	89 c6                	mov    %eax,%esi
      cprintf("index to evict: %d\n", index_to_evicet);
80108b0a:	50                   	push   %eax
80108b0b:	68 8a 9b 10 80       	push   $0x80109b8a
80108b10:	e8 4b 7b ff ff       	call   80100660 <cprintf>
      int swap_offset = curproc->free_head->off;
80108b15:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
      if(curproc->free_head->next == 0)
80108b1b:	83 c4 10             	add    $0x10,%esp
      int swap_offset = curproc->free_head->off;
80108b1e:	8b 02                	mov    (%edx),%eax
80108b20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
80108b23:	8b 42 04             	mov    0x4(%edx),%eax
80108b26:	85 c0                	test   %eax,%eax
80108b28:	0f 84 02 01 00 00    	je     80108c30 <handle_pagedout+0x2b0>
        kfree((char*)curproc->free_head->prev);
80108b2e:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80108b31:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108b37:	ff 70 08             	pushl  0x8(%eax)
80108b3a:	e8 21 9f ff ff       	call   80102a60 <kfree>
80108b3f:	83 c4 10             	add    $0x10,%esp
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108b42:	6b f6 1c             	imul   $0x1c,%esi,%esi
      cprintf("swap off : %d\n", swap_offset);
80108b45:	83 ec 08             	sub    $0x8,%esp
80108b48:	ff 75 e4             	pushl  -0x1c(%ebp)
80108b4b:	68 52 9c 10 80       	push   $0x80109c52
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108b50:	01 de                	add    %ebx,%esi
      cprintf("swap off : %d\n", swap_offset);
80108b52:	e8 09 7b ff ff       	call   80100660 <cprintf>
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108b57:	68 00 10 00 00       	push   $0x1000
80108b5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80108b5f:	ff b6 50 02 00 00    	pushl  0x250(%esi)
80108b65:	53                   	push   %ebx
80108b66:	e8 a5 9a ff ff       	call   80102610 <writeToSwapFile>
80108b6b:	83 c4 20             	add    $0x20,%esp
80108b6e:	85 c0                	test   %eax,%eax
80108b70:	0f 88 ec 00 00 00    	js     80108c62 <handle_pagedout+0x2e2>
      swap_page->virt_addr = ram_page->virt_addr;
80108b76:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80108b79:	8b 96 50 02 00 00    	mov    0x250(%esi),%edx
80108b7f:	01 d9                	add    %ebx,%ecx
80108b81:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
80108b87:	8b 86 48 02 00 00    	mov    0x248(%esi),%eax
      swap_page->isused = 1;
80108b8d:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80108b94:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80108b97:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108b9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108ba0:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108ba6:	8b 43 04             	mov    0x4(%ebx),%eax
80108ba9:	31 c9                	xor    %ecx,%ecx
80108bab:	e8 40 e9 ff ff       	call   801074f0 <walkpgdir>
      if(!(*pte & PTE_P))
80108bb0:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108bb2:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80108bb4:	f6 c2 01             	test   $0x1,%dl
80108bb7:	0f 84 b2 00 00 00    	je     80108c6f <handle_pagedout+0x2ef>
      ramPa = (void*)PTE_ADDR(*pte);
80108bbd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      kfree(P2V(ramPa));
80108bc3:	83 ec 0c             	sub    $0xc,%esp
80108bc6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108bcc:	52                   	push   %edx
80108bcd:	e8 8e 9e ff ff       	call   80102a60 <kfree>
      *pte &= ~PTE_P;     // turn "present" flag off
80108bd2:	8b 07                	mov    (%edi),%eax
80108bd4:	25 fe 0f 00 00       	and    $0xffe,%eax
80108bd9:	80 cc 02             	or     $0x2,%ah
80108bdc:	89 07                	mov    %eax,(%edi)
      ram_page->virt_addr = start_page;
80108bde:	8b 45 0c             	mov    0xc(%ebp),%eax
80108be1:	89 86 50 02 00 00    	mov    %eax,0x250(%esi)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108be7:	8b 43 04             	mov    0x4(%ebx),%eax
80108bea:	05 00 00 00 80       	add    $0x80000000,%eax
80108bef:	0f 22 d8             	mov    %eax,%cr3
80108bf2:	83 c4 10             	add    $0x10,%esp
}
80108bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108bf8:	5b                   	pop    %ebx
80108bf9:	5e                   	pop    %esi
80108bfa:	5f                   	pop    %edi
80108bfb:	5d                   	pop    %ebp
80108bfc:	c3                   	ret    
80108bfd:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108c00:	be 6c 00 00 00       	mov    $0x6c,%esi
  return -1;
80108c05:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108c0a:	e9 dd fd ff ff       	jmp    801089ec <handle_pagedout+0x6c>
80108c0f:	90                   	nop
      curproc->free_head = new_block;
80108c10:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108c16:	e9 2c fe ff ff       	jmp    80108a47 <handle_pagedout+0xc7>
80108c1b:	90                   	nop
80108c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108c20:	be ff ff ff ff       	mov    $0xffffffff,%esi
80108c25:	e9 7b fe ff ff       	jmp    80108aa5 <handle_pagedout+0x125>
80108c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree((char*)curproc->free_head);
80108c30:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80108c33:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80108c3a:	00 00 00 
        kfree((char*)curproc->free_head);
80108c3d:	52                   	push   %edx
80108c3e:	e8 1d 9e ff ff       	call   80102a60 <kfree>
        curproc->free_head = 0;
80108c43:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80108c4a:	00 00 00 
80108c4d:	83 c4 10             	add    $0x10,%esp
80108c50:	e9 ed fe ff ff       	jmp    80108b42 <handle_pagedout+0x1c2>
      panic("allocuvm: readFromSwapFile");
80108c55:	83 ec 0c             	sub    $0xc,%esp
80108c58:	68 37 9c 10 80       	push   $0x80109c37
80108c5d:	e8 2e 77 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108c62:	83 ec 0c             	sub    $0xc,%esp
80108c65:	68 b4 9b 10 80       	push   $0x80109bb4
80108c6a:	e8 21 77 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108c6f:	83 ec 0c             	sub    $0xc,%esp
80108c72:	68 d8 9d 10 80       	push   $0x80109dd8
80108c77:	e8 14 77 ff ff       	call   80100390 <panic>
80108c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108c80 <pagefault>:
{
80108c80:	55                   	push   %ebp
80108c81:	89 e5                	mov    %esp,%ebp
80108c83:	57                   	push   %edi
80108c84:	56                   	push   %esi
80108c85:	53                   	push   %ebx
80108c86:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108c89:	e8 42 b6 ff ff       	call   801042d0 <myproc>
80108c8e:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108c90:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108c93:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108c9a:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108c9c:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108c9f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108ca5:	31 c9                	xor    %ecx,%ecx
80108ca7:	89 fa                	mov    %edi,%edx
80108ca9:	e8 42 e8 ff ff       	call   801074f0 <walkpgdir>
  if((*pte & PTE_PG) && (*pte & ~PTE_COW)) // paged out, not COW todo
80108cae:	8b 10                	mov    (%eax),%edx
80108cb0:	f6 c6 02             	test   $0x2,%dh
80108cb3:	74 08                	je     80108cbd <pagefault+0x3d>
80108cb5:	81 e2 ff fb ff ff    	and    $0xfffffbff,%edx
80108cbb:	75 6b                	jne    80108d28 <pagefault+0xa8>
    cprintf("pagefault - %s (pid %d) - COW\n", curproc->name, curproc->pid);
80108cbd:	8d 7b 6c             	lea    0x6c(%ebx),%edi
80108cc0:	83 ec 04             	sub    $0x4,%esp
80108cc3:	ff 73 10             	pushl  0x10(%ebx)
80108cc6:	57                   	push   %edi
80108cc7:	68 fc 9d 10 80       	push   $0x80109dfc
80108ccc:	e8 8f 79 ff ff       	call   80100660 <cprintf>
    if(va >= KERNBASE || pte == 0)
80108cd1:	83 c4 10             	add    $0x10,%esp
80108cd4:	85 f6                	test   %esi,%esi
80108cd6:	78 28                	js     80108d00 <pagefault+0x80>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108cd8:	8b 43 04             	mov    0x4(%ebx),%eax
80108cdb:	31 c9                	xor    %ecx,%ecx
80108cdd:	89 f2                	mov    %esi,%edx
80108cdf:	e8 0c e8 ff ff       	call   801074f0 <walkpgdir>
80108ce4:	85 c0                	test   %eax,%eax
80108ce6:	74 56                	je     80108d3e <pagefault+0xbe>
    handle_cow_pagefault(curproc, pte, va);
80108ce8:	83 ec 04             	sub    $0x4,%esp
80108ceb:	56                   	push   %esi
80108cec:	50                   	push   %eax
80108ced:	53                   	push   %ebx
80108cee:	e8 8d f2 ff ff       	call   80107f80 <handle_cow_pagefault>
80108cf3:	83 c4 10             	add    $0x10,%esp
}
80108cf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108cf9:	5b                   	pop    %ebx
80108cfa:	5e                   	pop    %esi
80108cfb:	5f                   	pop    %edi
80108cfc:	5d                   	pop    %ebp
80108cfd:	c3                   	ret    
80108cfe:	66 90                	xchg   %ax,%ax
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108d00:	83 ec 04             	sub    $0x4,%esp
80108d03:	57                   	push   %edi
80108d04:	ff 73 10             	pushl  0x10(%ebx)
80108d07:	68 1c 9e 10 80       	push   $0x80109e1c
80108d0c:	e8 4f 79 ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80108d11:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
80108d18:	83 c4 10             	add    $0x10,%esp
}
80108d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d1e:	5b                   	pop    %ebx
80108d1f:	5e                   	pop    %esi
80108d20:	5f                   	pop    %edi
80108d21:	5d                   	pop    %ebp
80108d22:	c3                   	ret    
80108d23:	90                   	nop
80108d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    handle_pagedout(curproc, start_page, pte);
80108d28:	83 ec 04             	sub    $0x4,%esp
80108d2b:	50                   	push   %eax
80108d2c:	57                   	push   %edi
80108d2d:	53                   	push   %ebx
80108d2e:	e8 4d fc ff ff       	call   80108980 <handle_pagedout>
80108d33:	83 c4 10             	add    $0x10,%esp
}
80108d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108d39:	5b                   	pop    %ebx
80108d3a:	5e                   	pop    %esi
80108d3b:	5f                   	pop    %edi
80108d3c:	5d                   	pop    %ebp
80108d3d:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
80108d3e:	83 ec 0c             	sub    $0xc,%esp
80108d41:	68 61 9c 10 80       	push   $0x80109c61
80108d46:	e8 45 76 ff ff       	call   80100390 <panic>
80108d4b:	90                   	nop
80108d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108d50 <countSetBits>:
{
80108d50:	55                   	push   %ebp
    uint count = 0;
80108d51:	31 c0                	xor    %eax,%eax
{
80108d53:	89 e5                	mov    %esp,%ebp
80108d55:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108d58:	85 d2                	test   %edx,%edx
80108d5a:	74 0f                	je     80108d6b <countSetBits+0x1b>
80108d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108d60:	89 d1                	mov    %edx,%ecx
80108d62:	83 e1 01             	and    $0x1,%ecx
80108d65:	01 c8                	add    %ecx,%eax
    while (n) {
80108d67:	d1 ea                	shr    %edx
80108d69:	75 f5                	jne    80108d60 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108d6b:	5d                   	pop    %ebp
80108d6c:	c3                   	ret    
80108d6d:	8d 76 00             	lea    0x0(%esi),%esi

80108d70 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108d70:	55                   	push   %ebp
80108d71:	89 e5                	mov    %esp,%ebp
80108d73:	56                   	push   %esi
80108d74:	53                   	push   %ebx
80108d75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  // cprintf("AQ SWAPPING: %d and its prev node!\n", curr_node->page_index);
  struct queue_node *prev_node = curr_node->prev;
80108d78:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108d7b:	e8 50 b5 ff ff       	call   801042d0 <myproc>
80108d80:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108d86:	74 30                	je     80108db8 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108d88:	e8 43 b5 ff ff       	call   801042d0 <myproc>
80108d8d:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108d93:	74 53                	je     80108de8 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108d95:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108d98:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108d9a:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108d9c:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108d9f:	85 d2                	test   %edx,%edx
80108da1:	74 05                	je     80108da8 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108da3:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108da6:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108da8:	85 c0                	test   %eax,%eax
80108daa:	74 05                	je     80108db1 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108dac:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108dae:	89 70 04             	mov    %esi,0x4(%eax)
  }
80108db1:	5b                   	pop    %ebx
80108db2:	5e                   	pop    %esi
80108db3:	5d                   	pop    %ebp
80108db4:	c3                   	ret    
80108db5:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108db8:	e8 13 b5 ff ff       	call   801042d0 <myproc>
80108dbd:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108dc3:	e8 08 b5 ff ff       	call   801042d0 <myproc>
80108dc8:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108dce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108dd4:	e8 f7 b4 ff ff       	call   801042d0 <myproc>
80108dd9:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108ddf:	75 b4                	jne    80108d95 <swapAQ+0x25>
80108de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108de8:	e8 e3 b4 ff ff       	call   801042d0 <myproc>
80108ded:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108df3:	e8 d8 b4 ff ff       	call   801042d0 <myproc>
80108df8:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108e05:	eb 8e                	jmp    80108d95 <swapAQ+0x25>
80108e07:	89 f6                	mov    %esi,%esi
80108e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108e10 <updateAQ>:
{
80108e10:	55                   	push   %ebp
80108e11:	89 e5                	mov    %esp,%ebp
80108e13:	57                   	push   %edi
80108e14:	56                   	push   %esi
80108e15:	53                   	push   %ebx
80108e16:	83 ec 1c             	sub    $0x1c,%esp
80108e19:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108e1c:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108e22:	85 d2                	test   %edx,%edx
80108e24:	0f 84 7e 00 00 00    	je     80108ea8 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108e2a:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108e30:	8b 56 04             	mov    0x4(%esi),%edx
80108e33:	85 d2                	test   %edx,%edx
80108e35:	74 71                	je     80108ea8 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80108e37:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
80108e3d:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108e41:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108e45:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108e48:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108e4a:	01 d8                	add    %ebx,%eax
80108e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80108e50:	8b 50 08             	mov    0x8(%eax),%edx
80108e53:	8b 00                	mov    (%eax),%eax
80108e55:	31 c9                	xor    %ecx,%ecx
80108e57:	e8 94 e6 ff ff       	call   801074f0 <walkpgdir>
80108e5c:	85 c0                	test   %eax,%eax
80108e5e:	89 c3                	mov    %eax,%ebx
80108e60:	74 5e                	je     80108ec0 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80108e62:	8b 00                	mov    (%eax),%eax
80108e64:	8b 56 04             	mov    0x4(%esi),%edx
80108e67:	a8 20                	test   $0x20,%al
80108e69:	74 23                	je     80108e8e <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
80108e6b:	85 d2                	test   %edx,%edx
80108e6d:	74 17                	je     80108e86 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80108e6f:	8b 57 08             	mov    0x8(%edi),%edx
80108e72:	8b 07                	mov    (%edi),%eax
80108e74:	31 c9                	xor    %ecx,%ecx
80108e76:	e8 75 e6 ff ff       	call   801074f0 <walkpgdir>
80108e7b:	85 c0                	test   %eax,%eax
80108e7d:	74 41                	je     80108ec0 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80108e7f:	f6 00 20             	testb  $0x20,(%eax)
80108e82:	74 2c                	je     80108eb0 <updateAQ+0xa0>
80108e84:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80108e86:	83 e0 df             	and    $0xffffffdf,%eax
80108e89:	89 03                	mov    %eax,(%ebx)
80108e8b:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80108e8e:	85 d2                	test   %edx,%edx
80108e90:	74 16                	je     80108ea8 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80108e92:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108e96:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80108e9a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80108e9d:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
80108e9f:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108ea1:	01 cf                	add    %ecx,%edi
80108ea3:	eb ab                	jmp    80108e50 <updateAQ+0x40>
80108ea5:	8d 76 00             	lea    0x0(%esi),%esi
}
80108ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108eab:	5b                   	pop    %ebx
80108eac:	5e                   	pop    %esi
80108ead:	5f                   	pop    %edi
80108eae:	5d                   	pop    %ebp
80108eaf:	c3                   	ret    
          swapAQ(curr_node);
80108eb0:	83 ec 0c             	sub    $0xc,%esp
80108eb3:	56                   	push   %esi
80108eb4:	e8 b7 fe ff ff       	call   80108d70 <swapAQ>
80108eb9:	8b 03                	mov    (%ebx),%eax
80108ebb:	83 c4 10             	add    $0x10,%esp
80108ebe:	eb c6                	jmp    80108e86 <updateAQ+0x76>
      panic("updateAQ: no pte");
80108ec0:	83 ec 0c             	sub    $0xc,%esp
80108ec3:	68 7a 9c 10 80       	push   $0x80109c7a
80108ec8:	e8 c3 74 ff ff       	call   80100390 <panic>
