
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
80100028:	bc 00 e6 10 80       	mov    $0x8010e600,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 80 38 10 80       	mov    $0x80103880,%eax
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
80100044:	bb 34 e6 10 80       	mov    $0x8010e634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 60 90 10 80       	push   $0x80109060
80100051:	68 00 e6 10 80       	push   $0x8010e600
80100056:	e8 f5 4f 00 00       	call   80105050 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 4c 2d 11 80 fc 	movl   $0x80112cfc,0x80112d4c
80100062:	2c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 50 2d 11 80 fc 	movl   $0x80112cfc,0x80112d50
8010006c:	2c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba fc 2c 11 80       	mov    $0x80112cfc,%edx
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
8010008b:	c7 43 50 fc 2c 11 80 	movl   $0x80112cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 90 10 80       	push   $0x80109067
80100097:	50                   	push   %eax
80100098:	e8 83 4e 00 00       	call   80104f20 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 2d 11 80       	mov    0x80112d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 50 2d 11 80    	mov    %ebx,0x80112d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d fc 2c 11 80       	cmp    $0x80112cfc,%eax
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
801000df:	68 00 e6 10 80       	push   $0x8010e600
801000e4:	e8 a7 50 00 00       	call   80105190 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 2d 11 80    	mov    0x80112d50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
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
80100120:	8b 1d 4c 2d 11 80    	mov    0x80112d4c,%ebx
80100126:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 2c 11 80    	cmp    $0x80112cfc,%ebx
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
8010015d:	68 00 e6 10 80       	push   $0x8010e600
80100162:	e8 e9 50 00 00       	call   80105250 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 4d 00 00       	call   80104f60 <acquiresleep>
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
80100193:	68 6e 90 10 80       	push   $0x8010906e
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
801001ae:	e8 4d 4e 00 00       	call   80105000 <holdingsleep>
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
801001cc:	68 7f 90 10 80       	push   $0x8010907f
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
801001ef:	e8 0c 4e 00 00       	call   80105000 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 4d 00 00       	call   80104fc0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 e6 10 80 	movl   $0x8010e600,(%esp)
8010020b:	e8 80 4f 00 00       	call   80105190 <acquire>
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
80100232:	a1 50 2d 11 80       	mov    0x80112d50,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 fc 2c 11 80 	movl   $0x80112cfc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 50 2d 11 80       	mov    0x80112d50,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 50 2d 11 80    	mov    %ebx,0x80112d50
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 00 e6 10 80 	movl   $0x8010e600,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 ef 4f 00 00       	jmp    80105250 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 90 10 80       	push   $0x80109086
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
80100280:	e8 7b 18 00 00       	call   80101b00 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 ff 4e 00 00       	call   80105190 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 2f 11 80    	mov    0x80112fe0,%edx
801002a7:	39 15 e4 2f 11 80    	cmp    %edx,0x80112fe4
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
801002c0:	68 e0 2f 11 80       	push   $0x80112fe0
801002c5:	e8 16 48 00 00       	call   80104ae0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 2f 11 80    	mov    0x80112fe0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 2f 11 80    	cmp    0x80112fe4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 20 40 00 00       	call   80104300 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 5c 4f 00 00       	call   80105250 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 24 17 00 00       	call   80101a20 <ilock>
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
80100313:	a3 e0 2f 11 80       	mov    %eax,0x80112fe0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 2f 11 80 	movsbl -0x7feed0a0(%eax),%eax
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
8010034d:	e8 fe 4e 00 00       	call   80105250 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 c6 16 00 00       	call   80101a20 <ilock>
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
80100372:	89 15 e0 2f 11 80    	mov    %edx,0x80112fe0
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
801003a9:	e8 62 2d 00 00       	call   80103110 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 8d 90 10 80       	push   $0x8010908d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 17 9d 10 80 	movl   $0x80109d17,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 93 4c 00 00       	call   80105070 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 a1 90 10 80       	push   $0x801090a1
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
8010043a:	e8 91 65 00 00       	call   801069d0 <uartputc>
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
801004ec:	e8 df 64 00 00       	call   801069d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 64 00 00       	call   801069d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 64 00 00       	call   801069d0 <uartputc>
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
80100524:	e8 27 4e 00 00       	call   80105350 <memmove>
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
80100541:	e8 5a 4d 00 00       	call   801052a0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 a5 90 10 80       	push   $0x801090a5
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
801005b1:	0f b6 92 d0 90 10 80 	movzbl -0x7fef6f30(%edx),%edx
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
8010060f:	e8 ec 14 00 00       	call   80101b00 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 70 4b 00 00       	call   80105190 <acquire>
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
80100647:	e8 04 4c 00 00       	call   80105250 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 cb 13 00 00       	call   80101a20 <ilock>

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
8010071f:	e8 2c 4b 00 00       	call   80105250 <release>
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
801007d0:	ba b8 90 10 80       	mov    $0x801090b8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 9b 49 00 00       	call   80105190 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 bf 90 10 80       	push   $0x801090bf
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
80100823:	e8 68 49 00 00       	call   80105190 <acquire>
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
80100851:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
80100856:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 2f 11 80       	mov    %eax,0x80112fe8
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
80100888:	e8 c3 49 00 00       	call   80105250 <release>
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
801008a9:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 2f 11 80    	sub    0x80112fe0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 2f 11 80    	mov    %edx,0x80112fe8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 2f 11 80    	mov    %cl,-0x7feed0a0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 2f 11 80       	mov    0x80112fe0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 2f 11 80    	cmp    %eax,0x80112fe8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 2f 11 80       	mov    %eax,0x80112fe4
          wakeup(&input.r);
80100911:	68 e0 2f 11 80       	push   $0x80112fe0
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
80100938:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
8010093d:	39 05 e4 2f 11 80    	cmp    %eax,0x80112fe4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 2f 11 80       	mov    %eax,0x80112fe8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
80100964:	3b 05 e4 2f 11 80    	cmp    0x80112fe4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 2f 11 80 0a 	cmpb   $0xa,-0x7feed0a0(%edx)
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
80100997:	e9 54 44 00 00       	jmp    80104df0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 2f 11 80 0a 	movb   $0xa,-0x7feed0a0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 2f 11 80       	mov    0x80112fe8,%eax
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
801009c6:	68 c8 90 10 80       	push   $0x801090c8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 7b 46 00 00       	call   80105050 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 3d 11 80 00 	movl   $0x80100600,0x80113d6c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 3d 11 80 70 	movl   $0x80100270,0x80113d68
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
  memmove((void*)ramPagesBackup, curproc->ramPages, 16 * sizeof(struct page));
80100a1a:	68 c0 01 00 00       	push   $0x1c0
80100a1f:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100a25:	50                   	push   %eax
80100a26:	68 00 30 11 80       	push   $0x80113000
80100a2b:	e8 20 49 00 00       	call   80105350 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a30:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a36:	83 c4 0c             	add    $0xc,%esp
80100a39:	68 c0 01 00 00       	push   $0x1c0
80100a3e:	50                   	push   %eax
80100a3f:	68 e0 31 11 80       	push   $0x801131e0
80100a44:	e8 07 49 00 00       	call   80105350 <memmove>
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
80100a7b:	a3 c0 31 11 80       	mov    %eax,0x801131c0
  queue_head_backup = curproc->queue_head;
80100a80:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80100a86:	a3 a0 33 11 80       	mov    %eax,0x801133a0
  queue_tail_backup = curproc->queue_tail;
80100a8b:	8b 83 20 04 00 00    	mov    0x420(%ebx),%eax
80100a91:	a3 a4 33 11 80       	mov    %eax,0x801133a4
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
80100ac8:	e8 d3 47 00 00       	call   801052a0 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100acd:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ad3:	83 c4 0c             	add    $0xc,%esp
80100ad6:	68 c0 01 00 00       	push   $0x1c0
80100adb:	6a 00                	push   $0x0
80100add:	50                   	push   %eax
80100ade:	e8 bd 47 00 00       	call   801052a0 <memset>
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
80100bb7:	68 e1 90 10 80       	push   $0x801090e1
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
80100bdb:	e8 70 19 00 00       	call   80102550 <createSwapFile>
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
80100c37:	68 e1 90 10 80       	push   $0x801090e1
80100c3c:	e8 1f fa ff ff       	call   80100660 <cprintf>
80100c41:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	eb ba                	jmp    80100c06 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	68 04 91 10 80       	push   $0x80109104
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
80100c6c:	e8 8f 36 00 00       	call   80104300 <myproc>


  if(curproc->pid > 2)
80100c71:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *curproc = myproc();
80100c75:	89 c3                	mov    %eax,%ebx
  if(curproc->pid > 2)
80100c77:	0f 8f 8b 01 00 00    	jg     80100e08 <exec+0x1a8>
    backup(curproc);
    allocate_fresh(curproc);
  }


  begin_op();
80100c7d:	e8 fe 28 00 00       	call   80103580 <begin_op>

  if((ip = namei(path)) == 0){
80100c82:	83 ec 0c             	sub    $0xc,%esp
80100c85:	ff 75 08             	pushl  0x8(%ebp)
80100c88:	e8 f3 15 00 00       	call   80102280 <namei>
80100c8d:	83 c4 10             	add    $0x10,%esp
80100c90:	85 c0                	test   %eax,%eax
80100c92:	89 c6                	mov    %eax,%esi
80100c94:	0f 84 16 03 00 00    	je     80100fb0 <exec+0x350>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c9a:	83 ec 0c             	sub    $0xc,%esp
80100c9d:	50                   	push   %eax
80100c9e:	e8 7d 0d 00 00       	call   80101a20 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ca3:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ca9:	6a 34                	push   $0x34
80100cab:	6a 00                	push   $0x0
80100cad:	50                   	push   %eax
80100cae:	56                   	push   %esi
80100caf:	e8 4c 10 00 00       	call   80101d00 <readi>
80100cb4:	83 c4 20             	add    $0x20,%esp
80100cb7:	83 f8 34             	cmp    $0x34,%eax
80100cba:	74 34                	je     80100cf0 <exec+0x90>
  if(pgdir)
    freevm(pgdir);

  #if SELECTION != NONE
  /* restoring variables */
  if(curproc->pid > 2)
80100cbc:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80100cc0:	0f 8f 62 01 00 00    	jg     80100e28 <exec+0x1c8>
    curproc->queue_tail = queue_tail_backup;
  }
  #endif
  

  if(ip){
80100cc6:	85 f6                	test   %esi,%esi
    iunlockput(ip);
    end_op();
  }
  return -1;
80100cc8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(ip){
80100ccd:	74 11                	je     80100ce0 <exec+0x80>
    iunlockput(ip);
80100ccf:	83 ec 0c             	sub    $0xc,%esp
80100cd2:	56                   	push   %esi
80100cd3:	e8 d8 0f 00 00       	call   80101cb0 <iunlockput>
    end_op();
80100cd8:	e8 13 29 00 00       	call   801035f0 <end_op>
80100cdd:	83 c4 10             	add    $0x10,%esp
}
80100ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ce3:	89 d8                	mov    %ebx,%eax
80100ce5:	5b                   	pop    %ebx
80100ce6:	5e                   	pop    %esi
80100ce7:	5f                   	pop    %edi
80100ce8:	5d                   	pop    %ebp
80100ce9:	c3                   	ret    
80100cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100cf0:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100cf7:	45 4c 46 
80100cfa:	75 c0                	jne    80100cbc <exec+0x5c>
  if((pgdir = setupkvm()) == 0)
80100cfc:	e8 9f 70 00 00       	call   80107da0 <setupkvm>
80100d01:	85 c0                	test   %eax,%eax
80100d03:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100d09:	74 b1                	je     80100cbc <exec+0x5c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d0b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100d12:	00 
80100d13:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100d19:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d1f:	0f 84 b8 03 00 00    	je     801010dd <exec+0x47d>
  sz = 0;
80100d25:	31 c0                	xor    %eax,%eax
80100d27:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d2d:	31 ff                	xor    %edi,%edi
80100d2f:	89 c3                	mov    %eax,%ebx
80100d31:	e9 8c 00 00 00       	jmp    80100dc2 <exec+0x162>
80100d36:	8d 76 00             	lea    0x0(%esi),%esi
80100d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ph.type != ELF_PROG_LOAD)
80100d40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100d47:	75 67                	jne    80100db0 <exec+0x150>
    if(ph.memsz < ph.filesz)
80100d49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100d4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100d55:	0f 82 8e 00 00 00    	jb     80100de9 <exec+0x189>
80100d5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100d61:	0f 82 82 00 00 00    	jb     80100de9 <exec+0x189>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d67:	83 ec 04             	sub    $0x4,%esp
80100d6a:	50                   	push   %eax
80100d6b:	53                   	push   %ebx
80100d6c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d72:	e8 79 79 00 00       	call   801086f0 <allocuvm>
80100d77:	83 c4 10             	add    $0x10,%esp
80100d7a:	85 c0                	test   %eax,%eax
80100d7c:	89 c3                	mov    %eax,%ebx
80100d7e:	74 69                	je     80100de9 <exec+0x189>
    if(ph.vaddr % PGSIZE != 0)
80100d80:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100d86:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100d8b:	75 5c                	jne    80100de9 <exec+0x189>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d8d:	83 ec 0c             	sub    $0xc,%esp
80100d90:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100d96:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100d9c:	56                   	push   %esi
80100d9d:	50                   	push   %eax
80100d9e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100da4:	e8 77 6b 00 00       	call   80107920 <loaduvm>
80100da9:	83 c4 20             	add    $0x20,%esp
80100dac:	85 c0                	test   %eax,%eax
80100dae:	78 39                	js     80100de9 <exec+0x189>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100db0:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100db7:	83 c7 01             	add    $0x1,%edi
80100dba:	39 f8                	cmp    %edi,%eax
80100dbc:	0f 8e f5 00 00 00    	jle    80100eb7 <exec+0x257>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100dc2:	89 f8                	mov    %edi,%eax
80100dc4:	6a 20                	push   $0x20
80100dc6:	c1 e0 05             	shl    $0x5,%eax
80100dc9:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100dcf:	50                   	push   %eax
80100dd0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100dd6:	50                   	push   %eax
80100dd7:	56                   	push   %esi
80100dd8:	e8 23 0f 00 00       	call   80101d00 <readi>
80100ddd:	83 c4 10             	add    $0x10,%esp
80100de0:	83 f8 20             	cmp    $0x20,%eax
80100de3:	0f 84 57 ff ff ff    	je     80100d40 <exec+0xe0>
80100de9:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
    freevm(pgdir);
80100def:	83 ec 0c             	sub    $0xc,%esp
80100df2:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100df8:	e8 f3 6e 00 00       	call   80107cf0 <freevm>
80100dfd:	83 c4 10             	add    $0x10,%esp
80100e00:	e9 b7 fe ff ff       	jmp    80100cbc <exec+0x5c>
80100e05:	8d 76 00             	lea    0x0(%esi),%esi
    backup(curproc);
80100e08:	83 ec 0c             	sub    $0xc,%esp
80100e0b:	50                   	push   %eax
80100e0c:	e8 ff fb ff ff       	call   80100a10 <backup>
    allocate_fresh(curproc);
80100e11:	89 1c 24             	mov    %ebx,(%esp)
80100e14:	e8 b7 fd ff ff       	call   80100bd0 <allocate_fresh>
80100e19:	83 c4 10             	add    $0x10,%esp
80100e1c:	e9 5c fe ff ff       	jmp    80100c7d <exec+0x1d>
80100e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    memmove((void*)curproc->ramPages, ramPagesBackup, 16 * sizeof(struct page));
80100e28:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100e2e:	83 ec 04             	sub    $0x4,%esp
80100e31:	68 c0 01 00 00       	push   $0x1c0
80100e36:	68 00 30 11 80       	push   $0x80113000
80100e3b:	50                   	push   %eax
80100e3c:	e8 0f 45 00 00       	call   80105350 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100e41:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100e47:	83 c4 0c             	add    $0xc,%esp
80100e4a:	68 c0 01 00 00       	push   $0x1c0
80100e4f:	68 e0 31 11 80       	push   $0x801131e0
80100e54:	50                   	push   %eax
80100e55:	e8 f6 44 00 00       	call   80105350 <memmove>
    curproc->free_head = free_head_backup;
80100e5a:	a1 60 c5 10 80       	mov    0x8010c560,%eax
    curproc->queue_tail = queue_tail_backup;
80100e5f:	83 c4 10             	add    $0x10,%esp
    curproc->free_head = free_head_backup;
80100e62:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
    curproc->free_tail = free_tail_backup;
80100e68:	a1 5c c5 10 80       	mov    0x8010c55c,%eax
80100e6d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    curproc->num_ram = num_ram_backup;
80100e73:	a1 6c c5 10 80       	mov    0x8010c56c,%eax
80100e78:	89 83 08 04 00 00    	mov    %eax,0x408(%ebx)
    curproc->num_swap = num_swap_backup;
80100e7e:	a1 68 c5 10 80       	mov    0x8010c568,%eax
80100e83:	89 83 0c 04 00 00    	mov    %eax,0x40c(%ebx)
    curproc->swapFile = swapfile_backup;
80100e89:	a1 c0 31 11 80       	mov    0x801131c0,%eax
80100e8e:	89 43 7c             	mov    %eax,0x7c(%ebx)
    curproc->clockHand = clockhand_backup;
80100e91:	a1 64 c5 10 80       	mov    0x8010c564,%eax
80100e96:	89 83 10 04 00 00    	mov    %eax,0x410(%ebx)
    curproc->queue_head = queue_head_backup;
80100e9c:	a1 a0 33 11 80       	mov    0x801133a0,%eax
80100ea1:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
    curproc->queue_tail = queue_tail_backup;
80100ea7:	a1 a4 33 11 80       	mov    0x801133a4,%eax
80100eac:	89 83 20 04 00 00    	mov    %eax,0x420(%ebx)
80100eb2:	e9 0f fe ff ff       	jmp    80100cc6 <exec+0x66>
80100eb7:	89 d8                	mov    %ebx,%eax
80100eb9:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
80100ebf:	05 ff 0f 00 00       	add    $0xfff,%eax
80100ec4:	89 c7                	mov    %eax,%edi
80100ec6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100ecc:	8d 87 00 20 00 00    	lea    0x2000(%edi),%eax
  iunlockput(ip);
80100ed2:	83 ec 0c             	sub    $0xc,%esp
80100ed5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100edb:	56                   	push   %esi
80100edc:	e8 cf 0d 00 00       	call   80101cb0 <iunlockput>
  end_op();
80100ee1:	e8 0a 27 00 00       	call   801035f0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ee6:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100eec:	83 c4 0c             	add    $0xc,%esp
80100eef:	50                   	push   %eax
80100ef0:	57                   	push   %edi
80100ef1:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ef7:	e8 f4 77 00 00       	call   801086f0 <allocuvm>
80100efc:	83 c4 10             	add    $0x10,%esp
80100eff:	85 c0                	test   %eax,%eax
80100f01:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100f07:	75 07                	jne    80100f10 <exec+0x2b0>
  ip = 0;
80100f09:	31 f6                	xor    %esi,%esi
80100f0b:	e9 df fe ff ff       	jmp    80100def <exec+0x18f>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f10:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100f16:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100f19:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100f1b:	8d 86 00 e0 ff ff    	lea    -0x2000(%esi),%eax
80100f21:	50                   	push   %eax
80100f22:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f28:	e8 23 6f 00 00       	call   80107e50 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	8b 00                	mov    (%eax),%eax
80100f35:	85 c0                	test   %eax,%eax
80100f37:	0f 84 ac 01 00 00    	je     801010e9 <exec+0x489>
80100f3d:	89 9d ec fe ff ff    	mov    %ebx,-0x114(%ebp)
80100f43:	89 fb                	mov    %edi,%ebx
80100f45:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100f4b:	eb 22                	jmp    80100f6f <exec+0x30f>
80100f4d:	8d 76 00             	lea    0x0(%esi),%esi
80100f50:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100f53:	89 b4 9d 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%ebx,4)
  for(argc = 0; argv[argc]; argc++) {
80100f5a:	83 c3 01             	add    $0x1,%ebx
    ustack[3+argc] = sp;
80100f5d:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100f63:	8b 04 98             	mov    (%eax,%ebx,4),%eax
80100f66:	85 c0                	test   %eax,%eax
80100f68:	74 65                	je     80100fcf <exec+0x36f>
    if(argc >= MAXARG)
80100f6a:	83 fb 20             	cmp    $0x20,%ebx
80100f6d:	74 34                	je     80100fa3 <exec+0x343>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f6f:	83 ec 0c             	sub    $0xc,%esp
80100f72:	50                   	push   %eax
80100f73:	e8 48 45 00 00       	call   801054c0 <strlen>
80100f78:	f7 d0                	not    %eax
80100f7a:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f7c:	58                   	pop    %eax
80100f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f80:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f83:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f86:	e8 35 45 00 00       	call   801054c0 <strlen>
80100f8b:	83 c0 01             	add    $0x1,%eax
80100f8e:	50                   	push   %eax
80100f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f92:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f95:	56                   	push   %esi
80100f96:	57                   	push   %edi
80100f97:	e8 c4 72 00 00       	call   80108260 <copyout>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	79 ad                	jns    80100f50 <exec+0x2f0>
80100fa3:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ip = 0;
80100fa9:	31 f6                	xor    %esi,%esi
80100fab:	e9 3f fe ff ff       	jmp    80100def <exec+0x18f>
    end_op();
80100fb0:	e8 3b 26 00 00       	call   801035f0 <end_op>
    cprintf("exec: fail\n");
80100fb5:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80100fb8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("exec: fail\n");
80100fbd:	68 f6 90 10 80       	push   $0x801090f6
80100fc2:	e8 99 f6 ff ff       	call   80100660 <cprintf>
    return -1;
80100fc7:	83 c4 10             	add    $0x10,%esp
80100fca:	e9 11 fd ff ff       	jmp    80100ce0 <exec+0x80>
80100fcf:	89 df                	mov    %ebx,%edi
80100fd1:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fd7:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100fde:	89 f2                	mov    %esi,%edx
  ustack[3+argc] = 0;
80100fe0:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100fe7:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100feb:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ff2:	ff ff ff 
  ustack[1] = argc;
80100ff5:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ffb:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100ffd:	83 c0 0c             	add    $0xc,%eax
80101000:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101002:	50                   	push   %eax
80101003:	51                   	push   %ecx
80101004:	56                   	push   %esi
80101005:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
8010100b:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80101011:	e8 4a 72 00 00       	call   80108260 <copyout>
80101016:	83 c4 10             	add    $0x10,%esp
80101019:	85 c0                	test   %eax,%eax
8010101b:	0f 88 e8 fe ff ff    	js     80100f09 <exec+0x2a9>
  for(last=s=path; *s; s++)
80101021:	8b 45 08             	mov    0x8(%ebp),%eax
80101024:	0f b6 00             	movzbl (%eax),%eax
80101027:	84 c0                	test   %al,%al
80101029:	74 17                	je     80101042 <exec+0x3e2>
8010102b:	8b 55 08             	mov    0x8(%ebp),%edx
8010102e:	89 d1                	mov    %edx,%ecx
80101030:	83 c1 01             	add    $0x1,%ecx
80101033:	3c 2f                	cmp    $0x2f,%al
80101035:	0f b6 01             	movzbl (%ecx),%eax
80101038:	0f 44 d1             	cmove  %ecx,%edx
8010103b:	84 c0                	test   %al,%al
8010103d:	75 f1                	jne    80101030 <exec+0x3d0>
8010103f:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80101042:	50                   	push   %eax
80101043:	8d 43 6c             	lea    0x6c(%ebx),%eax
80101046:	6a 10                	push   $0x10
80101048:	ff 75 08             	pushl  0x8(%ebp)
8010104b:	50                   	push   %eax
8010104c:	e8 2f 44 00 00       	call   80105480 <safestrcpy>
80101051:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80101057:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
8010105d:	8d 93 48 02 00 00    	lea    0x248(%ebx),%edx
80101063:	83 c4 10             	add    $0x10,%esp
80101066:	8d 76 00             	lea    0x0(%esi),%esi
80101069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(curproc->ramPages[ind].isused)
80101070:	8b b8 c4 01 00 00    	mov    0x1c4(%eax),%edi
80101076:	85 ff                	test   %edi,%edi
80101078:	74 06                	je     80101080 <exec+0x420>
      curproc->ramPages[ind].pgdir = pgdir;
8010107a:	89 88 c0 01 00 00    	mov    %ecx,0x1c0(%eax)
    if(curproc->swappedPages[ind].isused)
80101080:	8b 78 04             	mov    0x4(%eax),%edi
80101083:	85 ff                	test   %edi,%edi
80101085:	74 02                	je     80101089 <exec+0x429>
      curproc->swappedPages[ind].pgdir = pgdir;
80101087:	89 08                	mov    %ecx,(%eax)
80101089:	83 c0 1c             	add    $0x1c,%eax
  for(ind = 0; ind < MAX_PSYC_PAGES; ind++)
8010108c:	39 c2                	cmp    %eax,%edx
8010108e:	75 e0                	jne    80101070 <exec+0x410>
  oldpgdir = curproc->pgdir;
80101090:	8b 43 04             	mov    0x4(%ebx),%eax
  curproc->tf->eip = elf.entry;  // main
80101093:	8b 53 18             	mov    0x18(%ebx),%edx
  switchuvm(curproc);
80101096:	83 ec 0c             	sub    $0xc,%esp
  oldpgdir = curproc->pgdir;
80101099:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
  curproc->pgdir = pgdir;
8010109f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801010a5:	89 43 04             	mov    %eax,0x4(%ebx)
  curproc->sz = sz;
801010a8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
801010ae:	89 03                	mov    %eax,(%ebx)
  curproc->tf->eip = elf.entry;  // main
801010b0:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
801010b6:	89 4a 38             	mov    %ecx,0x38(%edx)
  curproc->tf->esp = sp;
801010b9:	8b 53 18             	mov    0x18(%ebx),%edx
801010bc:	89 72 44             	mov    %esi,0x44(%edx)
  switchuvm(curproc);
801010bf:	53                   	push   %ebx
  return 0;
801010c0:	31 db                	xor    %ebx,%ebx
  switchuvm(curproc);
801010c2:	e8 c9 66 00 00       	call   80107790 <switchuvm>
  freevm(oldpgdir);
801010c7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010cd:	89 04 24             	mov    %eax,(%esp)
801010d0:	e8 1b 6c 00 00       	call   80107cf0 <freevm>
  return 0;
801010d5:	83 c4 10             	add    $0x10,%esp
801010d8:	e9 03 fc ff ff       	jmp    80100ce0 <exec+0x80>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801010dd:	31 ff                	xor    %edi,%edi
801010df:	b8 00 20 00 00       	mov    $0x2000,%eax
801010e4:	e9 e9 fd ff ff       	jmp    80100ed2 <exec+0x272>
  for(argc = 0; argv[argc]; argc++) {
801010e9:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
801010ef:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
801010f5:	e9 dd fe ff ff       	jmp    80100fd7 <exec+0x377>
801010fa:	66 90                	xchg   %ax,%ax
801010fc:	66 90                	xchg   %ax,%ax
801010fe:	66 90                	xchg   %ax,%ax

80101100 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80101106:	68 2f 91 10 80       	push   $0x8010912f
8010110b:	68 c0 33 11 80       	push   $0x801133c0
80101110:	e8 3b 3f 00 00       	call   80105050 <initlock>
}
80101115:	83 c4 10             	add    $0x10,%esp
80101118:	c9                   	leave  
80101119:	c3                   	ret    
8010111a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101120 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101120:	55                   	push   %ebp
80101121:	89 e5                	mov    %esp,%ebp
80101123:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101124:	bb f4 33 11 80       	mov    $0x801133f4,%ebx
{
80101129:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
8010112c:	68 c0 33 11 80       	push   $0x801133c0
80101131:	e8 5a 40 00 00       	call   80105190 <acquire>
80101136:	83 c4 10             	add    $0x10,%esp
80101139:	eb 10                	jmp    8010114b <filealloc+0x2b>
8010113b:	90                   	nop
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101140:	83 c3 18             	add    $0x18,%ebx
80101143:	81 fb 54 3d 11 80    	cmp    $0x80113d54,%ebx
80101149:	73 25                	jae    80101170 <filealloc+0x50>
    if(f->ref == 0){
8010114b:	8b 43 04             	mov    0x4(%ebx),%eax
8010114e:	85 c0                	test   %eax,%eax
80101150:	75 ee                	jne    80101140 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80101152:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80101155:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
8010115c:	68 c0 33 11 80       	push   $0x801133c0
80101161:	e8 ea 40 00 00       	call   80105250 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80101166:	89 d8                	mov    %ebx,%eax
      return f;
80101168:	83 c4 10             	add    $0x10,%esp
}
8010116b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010116e:	c9                   	leave  
8010116f:	c3                   	ret    
  release(&ftable.lock);
80101170:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80101173:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80101175:	68 c0 33 11 80       	push   $0x801133c0
8010117a:	e8 d1 40 00 00       	call   80105250 <release>
}
8010117f:	89 d8                	mov    %ebx,%eax
  return 0;
80101181:	83 c4 10             	add    $0x10,%esp
}
80101184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101187:	c9                   	leave  
80101188:	c3                   	ret    
80101189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101190 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	53                   	push   %ebx
80101194:	83 ec 10             	sub    $0x10,%esp
80101197:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
8010119a:	68 c0 33 11 80       	push   $0x801133c0
8010119f:	e8 ec 3f 00 00       	call   80105190 <acquire>
  if(f->ref < 1)
801011a4:	8b 43 04             	mov    0x4(%ebx),%eax
801011a7:	83 c4 10             	add    $0x10,%esp
801011aa:	85 c0                	test   %eax,%eax
801011ac:	7e 1a                	jle    801011c8 <filedup+0x38>
    panic("filedup");
  f->ref++;
801011ae:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
801011b1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
801011b4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
801011b7:	68 c0 33 11 80       	push   $0x801133c0
801011bc:	e8 8f 40 00 00       	call   80105250 <release>
  return f;
}
801011c1:	89 d8                	mov    %ebx,%eax
801011c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011c6:	c9                   	leave  
801011c7:	c3                   	ret    
    panic("filedup");
801011c8:	83 ec 0c             	sub    $0xc,%esp
801011cb:	68 36 91 10 80       	push   $0x80109136
801011d0:	e8 bb f1 ff ff       	call   80100390 <panic>
801011d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801011d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801011e0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 28             	sub    $0x28,%esp
801011e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
801011ec:	68 c0 33 11 80       	push   $0x801133c0
801011f1:	e8 9a 3f 00 00       	call   80105190 <acquire>
  if(f->ref < 1)
801011f6:	8b 43 04             	mov    0x4(%ebx),%eax
801011f9:	83 c4 10             	add    $0x10,%esp
801011fc:	85 c0                	test   %eax,%eax
801011fe:	0f 8e 9b 00 00 00    	jle    8010129f <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80101204:	83 e8 01             	sub    $0x1,%eax
80101207:	85 c0                	test   %eax,%eax
80101209:	89 43 04             	mov    %eax,0x4(%ebx)
8010120c:	74 1a                	je     80101228 <fileclose+0x48>
    release(&ftable.lock);
8010120e:	c7 45 08 c0 33 11 80 	movl   $0x801133c0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80101215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101218:	5b                   	pop    %ebx
80101219:	5e                   	pop    %esi
8010121a:	5f                   	pop    %edi
8010121b:	5d                   	pop    %ebp
    release(&ftable.lock);
8010121c:	e9 2f 40 00 00       	jmp    80105250 <release>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80101228:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
8010122c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
8010122e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101231:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80101234:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010123a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010123d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101240:	68 c0 33 11 80       	push   $0x801133c0
  ff = *f;
80101245:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80101248:	e8 03 40 00 00       	call   80105250 <release>
  if(ff.type == FD_PIPE)
8010124d:	83 c4 10             	add    $0x10,%esp
80101250:	83 ff 01             	cmp    $0x1,%edi
80101253:	74 13                	je     80101268 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80101255:	83 ff 02             	cmp    $0x2,%edi
80101258:	74 26                	je     80101280 <fileclose+0xa0>
}
8010125a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010125d:	5b                   	pop    %ebx
8010125e:	5e                   	pop    %esi
8010125f:	5f                   	pop    %edi
80101260:	5d                   	pop    %ebp
80101261:	c3                   	ret    
80101262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80101268:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
8010126c:	83 ec 08             	sub    $0x8,%esp
8010126f:	53                   	push   %ebx
80101270:	56                   	push   %esi
80101271:	e8 ca 2a 00 00       	call   80103d40 <pipeclose>
80101276:	83 c4 10             	add    $0x10,%esp
80101279:	eb df                	jmp    8010125a <fileclose+0x7a>
8010127b:	90                   	nop
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101280:	e8 fb 22 00 00       	call   80103580 <begin_op>
    iput(ff.ip);
80101285:	83 ec 0c             	sub    $0xc,%esp
80101288:	ff 75 e0             	pushl  -0x20(%ebp)
8010128b:	e8 c0 08 00 00       	call   80101b50 <iput>
    end_op();
80101290:	83 c4 10             	add    $0x10,%esp
}
80101293:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101296:	5b                   	pop    %ebx
80101297:	5e                   	pop    %esi
80101298:	5f                   	pop    %edi
80101299:	5d                   	pop    %ebp
    end_op();
8010129a:	e9 51 23 00 00       	jmp    801035f0 <end_op>
    panic("fileclose");
8010129f:	83 ec 0c             	sub    $0xc,%esp
801012a2:	68 3e 91 10 80       	push   $0x8010913e
801012a7:	e8 e4 f0 ff ff       	call   80100390 <panic>
801012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012b0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	53                   	push   %ebx
801012b4:	83 ec 04             	sub    $0x4,%esp
801012b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801012ba:	83 3b 02             	cmpl   $0x2,(%ebx)
801012bd:	75 31                	jne    801012f0 <filestat+0x40>
    ilock(f->ip);
801012bf:	83 ec 0c             	sub    $0xc,%esp
801012c2:	ff 73 10             	pushl  0x10(%ebx)
801012c5:	e8 56 07 00 00       	call   80101a20 <ilock>
    stati(f->ip, st);
801012ca:	58                   	pop    %eax
801012cb:	5a                   	pop    %edx
801012cc:	ff 75 0c             	pushl  0xc(%ebp)
801012cf:	ff 73 10             	pushl  0x10(%ebx)
801012d2:	e8 f9 09 00 00       	call   80101cd0 <stati>
    iunlock(f->ip);
801012d7:	59                   	pop    %ecx
801012d8:	ff 73 10             	pushl  0x10(%ebx)
801012db:	e8 20 08 00 00       	call   80101b00 <iunlock>
    return 0;
801012e0:	83 c4 10             	add    $0x10,%esp
801012e3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
801012e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012e8:	c9                   	leave  
801012e9:	c3                   	ret    
801012ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
801012f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f5:	eb ee                	jmp    801012e5 <filestat+0x35>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101300 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101300:	55                   	push   %ebp
80101301:	89 e5                	mov    %esp,%ebp
80101303:	57                   	push   %edi
80101304:	56                   	push   %esi
80101305:	53                   	push   %ebx
80101306:	83 ec 0c             	sub    $0xc,%esp
80101309:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010130c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010130f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101312:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101316:	74 60                	je     80101378 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101318:	8b 03                	mov    (%ebx),%eax
8010131a:	83 f8 01             	cmp    $0x1,%eax
8010131d:	74 41                	je     80101360 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010131f:	83 f8 02             	cmp    $0x2,%eax
80101322:	75 5b                	jne    8010137f <fileread+0x7f>
    ilock(f->ip);
80101324:	83 ec 0c             	sub    $0xc,%esp
80101327:	ff 73 10             	pushl  0x10(%ebx)
8010132a:	e8 f1 06 00 00       	call   80101a20 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010132f:	57                   	push   %edi
80101330:	ff 73 14             	pushl  0x14(%ebx)
80101333:	56                   	push   %esi
80101334:	ff 73 10             	pushl  0x10(%ebx)
80101337:	e8 c4 09 00 00       	call   80101d00 <readi>
8010133c:	83 c4 20             	add    $0x20,%esp
8010133f:	85 c0                	test   %eax,%eax
80101341:	89 c6                	mov    %eax,%esi
80101343:	7e 03                	jle    80101348 <fileread+0x48>
      f->off += r;
80101345:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101348:	83 ec 0c             	sub    $0xc,%esp
8010134b:	ff 73 10             	pushl  0x10(%ebx)
8010134e:	e8 ad 07 00 00       	call   80101b00 <iunlock>
    return r;
80101353:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101359:	89 f0                	mov    %esi,%eax
8010135b:	5b                   	pop    %ebx
8010135c:	5e                   	pop    %esi
8010135d:	5f                   	pop    %edi
8010135e:	5d                   	pop    %ebp
8010135f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101360:	8b 43 0c             	mov    0xc(%ebx),%eax
80101363:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101366:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101369:	5b                   	pop    %ebx
8010136a:	5e                   	pop    %esi
8010136b:	5f                   	pop    %edi
8010136c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010136d:	e9 7e 2b 00 00       	jmp    80103ef0 <piperead>
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101378:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010137d:	eb d7                	jmp    80101356 <fileread+0x56>
  panic("fileread");
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	68 48 91 10 80       	push   $0x80109148
80101387:	e8 04 f0 ff ff       	call   80100390 <panic>
8010138c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101390 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	83 ec 1c             	sub    $0x1c,%esp
80101399:	8b 75 08             	mov    0x8(%ebp),%esi
8010139c:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
8010139f:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801013a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801013a6:	8b 45 10             	mov    0x10(%ebp),%eax
801013a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801013ac:	0f 84 aa 00 00 00    	je     8010145c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801013b2:	8b 06                	mov    (%esi),%eax
801013b4:	83 f8 01             	cmp    $0x1,%eax
801013b7:	0f 84 c3 00 00 00    	je     80101480 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801013bd:	83 f8 02             	cmp    $0x2,%eax
801013c0:	0f 85 d9 00 00 00    	jne    8010149f <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801013c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801013c9:	31 ff                	xor    %edi,%edi
    while(i < n){
801013cb:	85 c0                	test   %eax,%eax
801013cd:	7f 34                	jg     80101403 <filewrite+0x73>
801013cf:	e9 9c 00 00 00       	jmp    80101470 <filewrite+0xe0>
801013d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801013d8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801013db:	83 ec 0c             	sub    $0xc,%esp
801013de:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801013e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801013e4:	e8 17 07 00 00       	call   80101b00 <iunlock>
      end_op();
801013e9:	e8 02 22 00 00       	call   801035f0 <end_op>
801013ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013f1:	83 c4 10             	add    $0x10,%esp
      if(r < 0)
        break;
      if(r != n1)
801013f4:	39 c3                	cmp    %eax,%ebx
801013f6:	0f 85 96 00 00 00    	jne    80101492 <filewrite+0x102>
        panic("short filewrite");
      i += r;
801013fc:	01 df                	add    %ebx,%edi
    while(i < n){
801013fe:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101401:	7e 6d                	jle    80101470 <filewrite+0xe0>
      int n1 = n - i;
80101403:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101406:	b8 00 06 00 00       	mov    $0x600,%eax
8010140b:	29 fb                	sub    %edi,%ebx
8010140d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101413:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101416:	e8 65 21 00 00       	call   80103580 <begin_op>
      ilock(f->ip);
8010141b:	83 ec 0c             	sub    $0xc,%esp
8010141e:	ff 76 10             	pushl  0x10(%esi)
80101421:	e8 fa 05 00 00       	call   80101a20 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101426:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101429:	53                   	push   %ebx
8010142a:	ff 76 14             	pushl  0x14(%esi)
8010142d:	01 f8                	add    %edi,%eax
8010142f:	50                   	push   %eax
80101430:	ff 76 10             	pushl  0x10(%esi)
80101433:	e8 c8 09 00 00       	call   80101e00 <writei>
80101438:	83 c4 20             	add    $0x20,%esp
8010143b:	85 c0                	test   %eax,%eax
8010143d:	7f 99                	jg     801013d8 <filewrite+0x48>
      iunlock(f->ip);
8010143f:	83 ec 0c             	sub    $0xc,%esp
80101442:	ff 76 10             	pushl  0x10(%esi)
80101445:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101448:	e8 b3 06 00 00       	call   80101b00 <iunlock>
      end_op();
8010144d:	e8 9e 21 00 00       	call   801035f0 <end_op>
      if(r < 0)
80101452:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101455:	83 c4 10             	add    $0x10,%esp
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 98                	je     801013f4 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010145c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010145f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101464:	89 f8                	mov    %edi,%eax
80101466:	5b                   	pop    %ebx
80101467:	5e                   	pop    %esi
80101468:	5f                   	pop    %edi
80101469:	5d                   	pop    %ebp
8010146a:	c3                   	ret    
8010146b:	90                   	nop
8010146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101470:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101473:	75 e7                	jne    8010145c <filewrite+0xcc>
}
80101475:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101478:	89 f8                	mov    %edi,%eax
8010147a:	5b                   	pop    %ebx
8010147b:	5e                   	pop    %esi
8010147c:	5f                   	pop    %edi
8010147d:	5d                   	pop    %ebp
8010147e:	c3                   	ret    
8010147f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101480:	8b 46 0c             	mov    0xc(%esi),%eax
80101483:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101486:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101489:	5b                   	pop    %ebx
8010148a:	5e                   	pop    %esi
8010148b:	5f                   	pop    %edi
8010148c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010148d:	e9 4e 29 00 00       	jmp    80103de0 <pipewrite>
        panic("short filewrite");
80101492:	83 ec 0c             	sub    $0xc,%esp
80101495:	68 51 91 10 80       	push   $0x80109151
8010149a:	e8 f1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
8010149f:	83 ec 0c             	sub    $0xc,%esp
801014a2:	68 57 91 10 80       	push   $0x80109157
801014a7:	e8 e4 ee ff ff       	call   80100390 <panic>
801014ac:	66 90                	xchg   %ax,%ax
801014ae:	66 90                	xchg   %ax,%ax

801014b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014b0:	55                   	push   %ebp
801014b1:	89 e5                	mov    %esp,%ebp
801014b3:	56                   	push   %esi
801014b4:	53                   	push   %ebx
801014b5:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801014b7:	c1 ea 0c             	shr    $0xc,%edx
801014ba:	03 15 d8 3d 11 80    	add    0x80113dd8,%edx
801014c0:	83 ec 08             	sub    $0x8,%esp
801014c3:	52                   	push   %edx
801014c4:	50                   	push   %eax
801014c5:	e8 06 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014ca:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014cc:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014cf:	ba 01 00 00 00       	mov    $0x1,%edx
801014d4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014d7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014dd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801014e0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801014e2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801014e7:	85 d1                	test   %edx,%ecx
801014e9:	74 25                	je     80101510 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801014eb:	f7 d2                	not    %edx
801014ed:	89 c6                	mov    %eax,%esi
  log_write(bp);
801014ef:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014f2:	21 ca                	and    %ecx,%edx
801014f4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801014f8:	56                   	push   %esi
801014f9:	e8 52 22 00 00       	call   80103750 <log_write>
  brelse(bp);
801014fe:	89 34 24             	mov    %esi,(%esp)
80101501:	e8 da ec ff ff       	call   801001e0 <brelse>
}
80101506:	83 c4 10             	add    $0x10,%esp
80101509:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010150c:	5b                   	pop    %ebx
8010150d:	5e                   	pop    %esi
8010150e:	5d                   	pop    %ebp
8010150f:	c3                   	ret    
    panic("freeing free block");
80101510:	83 ec 0c             	sub    $0xc,%esp
80101513:	68 61 91 10 80       	push   $0x80109161
80101518:	e8 73 ee ff ff       	call   80100390 <panic>
8010151d:	8d 76 00             	lea    0x0(%esi),%esi

80101520 <balloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101529:	8b 0d c0 3d 11 80    	mov    0x80113dc0,%ecx
{
8010152f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101532:	85 c9                	test   %ecx,%ecx
80101534:	0f 84 87 00 00 00    	je     801015c1 <balloc+0xa1>
8010153a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101541:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101544:	83 ec 08             	sub    $0x8,%esp
80101547:	89 f0                	mov    %esi,%eax
80101549:	c1 f8 0c             	sar    $0xc,%eax
8010154c:	03 05 d8 3d 11 80    	add    0x80113dd8,%eax
80101552:	50                   	push   %eax
80101553:	ff 75 d8             	pushl  -0x28(%ebp)
80101556:	e8 75 eb ff ff       	call   801000d0 <bread>
8010155b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010155e:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80101563:	83 c4 10             	add    $0x10,%esp
80101566:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101569:	31 c0                	xor    %eax,%eax
8010156b:	eb 2f                	jmp    8010159c <balloc+0x7c>
8010156d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101570:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101572:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101575:	bb 01 00 00 00       	mov    $0x1,%ebx
8010157a:	83 e1 07             	and    $0x7,%ecx
8010157d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010157f:	89 c1                	mov    %eax,%ecx
80101581:	c1 f9 03             	sar    $0x3,%ecx
80101584:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101589:	85 df                	test   %ebx,%edi
8010158b:	89 fa                	mov    %edi,%edx
8010158d:	74 41                	je     801015d0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010158f:	83 c0 01             	add    $0x1,%eax
80101592:	83 c6 01             	add    $0x1,%esi
80101595:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010159a:	74 05                	je     801015a1 <balloc+0x81>
8010159c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010159f:	77 cf                	ja     80101570 <balloc+0x50>
    brelse(bp);
801015a1:	83 ec 0c             	sub    $0xc,%esp
801015a4:	ff 75 e4             	pushl  -0x1c(%ebp)
801015a7:	e8 34 ec ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801015ac:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801015b3:	83 c4 10             	add    $0x10,%esp
801015b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801015b9:	39 05 c0 3d 11 80    	cmp    %eax,0x80113dc0
801015bf:	77 80                	ja     80101541 <balloc+0x21>
  panic("balloc: out of blocks");
801015c1:	83 ec 0c             	sub    $0xc,%esp
801015c4:	68 74 91 10 80       	push   $0x80109174
801015c9:	e8 c2 ed ff ff       	call   80100390 <panic>
801015ce:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801015d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801015d3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801015d6:	09 da                	or     %ebx,%edx
801015d8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801015dc:	57                   	push   %edi
801015dd:	e8 6e 21 00 00       	call   80103750 <log_write>
        brelse(bp);
801015e2:	89 3c 24             	mov    %edi,(%esp)
801015e5:	e8 f6 eb ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801015ea:	58                   	pop    %eax
801015eb:	5a                   	pop    %edx
801015ec:	56                   	push   %esi
801015ed:	ff 75 d8             	pushl  -0x28(%ebp)
801015f0:	e8 db ea ff ff       	call   801000d0 <bread>
801015f5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801015f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801015fa:	83 c4 0c             	add    $0xc,%esp
801015fd:	68 00 02 00 00       	push   $0x200
80101602:	6a 00                	push   $0x0
80101604:	50                   	push   %eax
80101605:	e8 96 3c 00 00       	call   801052a0 <memset>
  log_write(bp);
8010160a:	89 1c 24             	mov    %ebx,(%esp)
8010160d:	e8 3e 21 00 00       	call   80103750 <log_write>
  brelse(bp);
80101612:	89 1c 24             	mov    %ebx,(%esp)
80101615:	e8 c6 eb ff ff       	call   801001e0 <brelse>
}
8010161a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161d:	89 f0                	mov    %esi,%eax
8010161f:	5b                   	pop    %ebx
80101620:	5e                   	pop    %esi
80101621:	5f                   	pop    %edi
80101622:	5d                   	pop    %ebp
80101623:	c3                   	ret    
80101624:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010162a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101630 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	57                   	push   %edi
80101634:	56                   	push   %esi
80101635:	53                   	push   %ebx
80101636:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101638:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010163a:	bb 14 3e 11 80       	mov    $0x80113e14,%ebx
{
8010163f:	83 ec 28             	sub    $0x28,%esp
80101642:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101645:	68 e0 3d 11 80       	push   $0x80113de0
8010164a:	e8 41 3b 00 00       	call   80105190 <acquire>
8010164f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101652:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101655:	eb 17                	jmp    8010166e <iget+0x3e>
80101657:	89 f6                	mov    %esi,%esi
80101659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101660:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101666:	81 fb 34 5a 11 80    	cmp    $0x80115a34,%ebx
8010166c:	73 22                	jae    80101690 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010166e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101671:	85 c9                	test   %ecx,%ecx
80101673:	7e 04                	jle    80101679 <iget+0x49>
80101675:	39 3b                	cmp    %edi,(%ebx)
80101677:	74 4f                	je     801016c8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101679:	85 f6                	test   %esi,%esi
8010167b:	75 e3                	jne    80101660 <iget+0x30>
8010167d:	85 c9                	test   %ecx,%ecx
8010167f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101682:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101688:	81 fb 34 5a 11 80    	cmp    $0x80115a34,%ebx
8010168e:	72 de                	jb     8010166e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101690:	85 f6                	test   %esi,%esi
80101692:	74 5b                	je     801016ef <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101694:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101697:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101699:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010169c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801016a3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801016aa:	68 e0 3d 11 80       	push   $0x80113de0
801016af:	e8 9c 3b 00 00       	call   80105250 <release>

  return ip;
801016b4:	83 c4 10             	add    $0x10,%esp
}
801016b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016ba:	89 f0                	mov    %esi,%eax
801016bc:	5b                   	pop    %ebx
801016bd:	5e                   	pop    %esi
801016be:	5f                   	pop    %edi
801016bf:	5d                   	pop    %ebp
801016c0:	c3                   	ret    
801016c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801016c8:	39 53 04             	cmp    %edx,0x4(%ebx)
801016cb:	75 ac                	jne    80101679 <iget+0x49>
      release(&icache.lock);
801016cd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801016d0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801016d3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801016d5:	68 e0 3d 11 80       	push   $0x80113de0
      ip->ref++;
801016da:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801016dd:	e8 6e 3b 00 00       	call   80105250 <release>
      return ip;
801016e2:	83 c4 10             	add    $0x10,%esp
}
801016e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016e8:	89 f0                	mov    %esi,%eax
801016ea:	5b                   	pop    %ebx
801016eb:	5e                   	pop    %esi
801016ec:	5f                   	pop    %edi
801016ed:	5d                   	pop    %ebp
801016ee:	c3                   	ret    
    panic("iget: no inodes");
801016ef:	83 ec 0c             	sub    $0xc,%esp
801016f2:	68 8a 91 10 80       	push   $0x8010918a
801016f7:	e8 94 ec ff ff       	call   80100390 <panic>
801016fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101700 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101700:	55                   	push   %ebp
80101701:	89 e5                	mov    %esp,%ebp
80101703:	57                   	push   %edi
80101704:	56                   	push   %esi
80101705:	53                   	push   %ebx
80101706:	89 c6                	mov    %eax,%esi
80101708:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010170b:	83 fa 0b             	cmp    $0xb,%edx
8010170e:	77 18                	ja     80101728 <bmap+0x28>
80101710:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101713:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101716:	85 db                	test   %ebx,%ebx
80101718:	74 76                	je     80101790 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010171a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010171d:	89 d8                	mov    %ebx,%eax
8010171f:	5b                   	pop    %ebx
80101720:	5e                   	pop    %esi
80101721:	5f                   	pop    %edi
80101722:	5d                   	pop    %ebp
80101723:	c3                   	ret    
80101724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101728:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010172b:	83 fb 7f             	cmp    $0x7f,%ebx
8010172e:	0f 87 90 00 00 00    	ja     801017c4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101734:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010173a:	8b 00                	mov    (%eax),%eax
8010173c:	85 d2                	test   %edx,%edx
8010173e:	74 70                	je     801017b0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101740:	83 ec 08             	sub    $0x8,%esp
80101743:	52                   	push   %edx
80101744:	50                   	push   %eax
80101745:	e8 86 e9 ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010174a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010174e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101751:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101753:	8b 1a                	mov    (%edx),%ebx
80101755:	85 db                	test   %ebx,%ebx
80101757:	75 1d                	jne    80101776 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101759:	8b 06                	mov    (%esi),%eax
8010175b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010175e:	e8 bd fd ff ff       	call   80101520 <balloc>
80101763:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101766:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101769:	89 c3                	mov    %eax,%ebx
8010176b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010176d:	57                   	push   %edi
8010176e:	e8 dd 1f 00 00       	call   80103750 <log_write>
80101773:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101776:	83 ec 0c             	sub    $0xc,%esp
80101779:	57                   	push   %edi
8010177a:	e8 61 ea ff ff       	call   801001e0 <brelse>
8010177f:	83 c4 10             	add    $0x10,%esp
}
80101782:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101785:	89 d8                	mov    %ebx,%eax
80101787:	5b                   	pop    %ebx
80101788:	5e                   	pop    %esi
80101789:	5f                   	pop    %edi
8010178a:	5d                   	pop    %ebp
8010178b:	c3                   	ret    
8010178c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101790:	8b 00                	mov    (%eax),%eax
80101792:	e8 89 fd ff ff       	call   80101520 <balloc>
80101797:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010179a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010179d:	89 c3                	mov    %eax,%ebx
}
8010179f:	89 d8                	mov    %ebx,%eax
801017a1:	5b                   	pop    %ebx
801017a2:	5e                   	pop    %esi
801017a3:	5f                   	pop    %edi
801017a4:	5d                   	pop    %ebp
801017a5:	c3                   	ret    
801017a6:	8d 76 00             	lea    0x0(%esi),%esi
801017a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801017b0:	e8 6b fd ff ff       	call   80101520 <balloc>
801017b5:	89 c2                	mov    %eax,%edx
801017b7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801017bd:	8b 06                	mov    (%esi),%eax
801017bf:	e9 7c ff ff ff       	jmp    80101740 <bmap+0x40>
  panic("bmap: out of range");
801017c4:	83 ec 0c             	sub    $0xc,%esp
801017c7:	68 9a 91 10 80       	push   $0x8010919a
801017cc:	e8 bf eb ff ff       	call   80100390 <panic>
801017d1:	eb 0d                	jmp    801017e0 <readsb>
801017d3:	90                   	nop
801017d4:	90                   	nop
801017d5:	90                   	nop
801017d6:	90                   	nop
801017d7:	90                   	nop
801017d8:	90                   	nop
801017d9:	90                   	nop
801017da:	90                   	nop
801017db:	90                   	nop
801017dc:	90                   	nop
801017dd:	90                   	nop
801017de:	90                   	nop
801017df:	90                   	nop

801017e0 <readsb>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	6a 01                	push   $0x1
801017ed:	ff 75 08             	pushl  0x8(%ebp)
801017f0:	e8 db e8 ff ff       	call   801000d0 <bread>
801017f5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801017f7:	8d 40 5c             	lea    0x5c(%eax),%eax
801017fa:	83 c4 0c             	add    $0xc,%esp
801017fd:	6a 1c                	push   $0x1c
801017ff:	50                   	push   %eax
80101800:	56                   	push   %esi
80101801:	e8 4a 3b 00 00       	call   80105350 <memmove>
  brelse(bp);
80101806:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101809:	83 c4 10             	add    $0x10,%esp
}
8010180c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010180f:	5b                   	pop    %ebx
80101810:	5e                   	pop    %esi
80101811:	5d                   	pop    %ebp
  brelse(bp);
80101812:	e9 c9 e9 ff ff       	jmp    801001e0 <brelse>
80101817:	89 f6                	mov    %esi,%esi
80101819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101820 <iinit>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	bb 20 3e 11 80       	mov    $0x80113e20,%ebx
80101829:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010182c:	68 ad 91 10 80       	push   $0x801091ad
80101831:	68 e0 3d 11 80       	push   $0x80113de0
80101836:	e8 15 38 00 00       	call   80105050 <initlock>
8010183b:	83 c4 10             	add    $0x10,%esp
8010183e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101840:	83 ec 08             	sub    $0x8,%esp
80101843:	68 b4 91 10 80       	push   $0x801091b4
80101848:	53                   	push   %ebx
80101849:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010184f:	e8 cc 36 00 00       	call   80104f20 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	81 fb 40 5a 11 80    	cmp    $0x80115a40,%ebx
8010185d:	75 e1                	jne    80101840 <iinit+0x20>
  readsb(dev, &sb);
8010185f:	83 ec 08             	sub    $0x8,%esp
80101862:	68 c0 3d 11 80       	push   $0x80113dc0
80101867:	ff 75 08             	pushl  0x8(%ebp)
8010186a:	e8 71 ff ff ff       	call   801017e0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010186f:	ff 35 d8 3d 11 80    	pushl  0x80113dd8
80101875:	ff 35 d4 3d 11 80    	pushl  0x80113dd4
8010187b:	ff 35 d0 3d 11 80    	pushl  0x80113dd0
80101881:	ff 35 cc 3d 11 80    	pushl  0x80113dcc
80101887:	ff 35 c8 3d 11 80    	pushl  0x80113dc8
8010188d:	ff 35 c4 3d 11 80    	pushl  0x80113dc4
80101893:	ff 35 c0 3d 11 80    	pushl  0x80113dc0
80101899:	68 60 92 10 80       	push   $0x80109260
8010189e:	e8 bd ed ff ff       	call   80100660 <cprintf>
}
801018a3:	83 c4 30             	add    $0x30,%esp
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    
801018ab:	90                   	nop
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <ialloc>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018b9:	83 3d c8 3d 11 80 01 	cmpl   $0x1,0x80113dc8
{
801018c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801018c3:	8b 75 08             	mov    0x8(%ebp),%esi
801018c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801018c9:	0f 86 91 00 00 00    	jbe    80101960 <ialloc+0xb0>
801018cf:	bb 01 00 00 00       	mov    $0x1,%ebx
801018d4:	eb 21                	jmp    801018f7 <ialloc+0x47>
801018d6:	8d 76 00             	lea    0x0(%esi),%esi
801018d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
801018e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801018e3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801018e6:	57                   	push   %edi
801018e7:	e8 f4 e8 ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801018ec:	83 c4 10             	add    $0x10,%esp
801018ef:	39 1d c8 3d 11 80    	cmp    %ebx,0x80113dc8
801018f5:	76 69                	jbe    80101960 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801018f7:	89 d8                	mov    %ebx,%eax
801018f9:	83 ec 08             	sub    $0x8,%esp
801018fc:	c1 e8 03             	shr    $0x3,%eax
801018ff:	03 05 d4 3d 11 80    	add    0x80113dd4,%eax
80101905:	50                   	push   %eax
80101906:	56                   	push   %esi
80101907:	e8 c4 e7 ff ff       	call   801000d0 <bread>
8010190c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010190e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101910:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101913:	83 e0 07             	and    $0x7,%eax
80101916:	c1 e0 06             	shl    $0x6,%eax
80101919:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010191d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101921:	75 bd                	jne    801018e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101923:	83 ec 04             	sub    $0x4,%esp
80101926:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101929:	6a 40                	push   $0x40
8010192b:	6a 00                	push   $0x0
8010192d:	51                   	push   %ecx
8010192e:	e8 6d 39 00 00       	call   801052a0 <memset>
      dip->type = type;
80101933:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101937:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010193a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010193d:	89 3c 24             	mov    %edi,(%esp)
80101940:	e8 0b 1e 00 00       	call   80103750 <log_write>
      brelse(bp);
80101945:	89 3c 24             	mov    %edi,(%esp)
80101948:	e8 93 e8 ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010194d:	83 c4 10             	add    $0x10,%esp
}
80101950:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101953:	89 da                	mov    %ebx,%edx
80101955:	89 f0                	mov    %esi,%eax
}
80101957:	5b                   	pop    %ebx
80101958:	5e                   	pop    %esi
80101959:	5f                   	pop    %edi
8010195a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010195b:	e9 d0 fc ff ff       	jmp    80101630 <iget>
  panic("ialloc: no inodes");
80101960:	83 ec 0c             	sub    $0xc,%esp
80101963:	68 ba 91 10 80       	push   $0x801091ba
80101968:	e8 23 ea ff ff       	call   80100390 <panic>
8010196d:	8d 76 00             	lea    0x0(%esi),%esi

80101970 <iupdate>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101978:	83 ec 08             	sub    $0x8,%esp
8010197b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010197e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101981:	c1 e8 03             	shr    $0x3,%eax
80101984:	03 05 d4 3d 11 80    	add    0x80113dd4,%eax
8010198a:	50                   	push   %eax
8010198b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101995:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101998:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010199c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010199f:	83 e0 07             	and    $0x7,%eax
801019a2:	c1 e0 06             	shl    $0x6,%eax
801019a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801019a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801019ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801019b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801019b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801019bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801019bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801019c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801019c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801019ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019cd:	6a 34                	push   $0x34
801019cf:	53                   	push   %ebx
801019d0:	50                   	push   %eax
801019d1:	e8 7a 39 00 00       	call   80105350 <memmove>
  log_write(bp);
801019d6:	89 34 24             	mov    %esi,(%esp)
801019d9:	e8 72 1d 00 00       	call   80103750 <log_write>
  brelse(bp);
801019de:	89 75 08             	mov    %esi,0x8(%ebp)
801019e1:	83 c4 10             	add    $0x10,%esp
}
801019e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019e7:	5b                   	pop    %ebx
801019e8:	5e                   	pop    %esi
801019e9:	5d                   	pop    %ebp
  brelse(bp);
801019ea:	e9 f1 e7 ff ff       	jmp    801001e0 <brelse>
801019ef:	90                   	nop

801019f0 <idup>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	53                   	push   %ebx
801019f4:	83 ec 10             	sub    $0x10,%esp
801019f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801019fa:	68 e0 3d 11 80       	push   $0x80113de0
801019ff:	e8 8c 37 00 00       	call   80105190 <acquire>
  ip->ref++;
80101a04:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a08:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80101a0f:	e8 3c 38 00 00       	call   80105250 <release>
}
80101a14:	89 d8                	mov    %ebx,%eax
80101a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <ilock>:
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	56                   	push   %esi
80101a24:	53                   	push   %ebx
80101a25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101a28:	85 db                	test   %ebx,%ebx
80101a2a:	0f 84 b7 00 00 00    	je     80101ae7 <ilock+0xc7>
80101a30:	8b 53 08             	mov    0x8(%ebx),%edx
80101a33:	85 d2                	test   %edx,%edx
80101a35:	0f 8e ac 00 00 00    	jle    80101ae7 <ilock+0xc7>
  acquiresleep(&ip->lock);
80101a3b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	50                   	push   %eax
80101a42:	e8 19 35 00 00       	call   80104f60 <acquiresleep>
  if(ip->valid == 0){
80101a47:	8b 43 4c             	mov    0x4c(%ebx),%eax
80101a4a:	83 c4 10             	add    $0x10,%esp
80101a4d:	85 c0                	test   %eax,%eax
80101a4f:	74 0f                	je     80101a60 <ilock+0x40>
}
80101a51:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101a54:	5b                   	pop    %ebx
80101a55:	5e                   	pop    %esi
80101a56:	5d                   	pop    %ebp
80101a57:	c3                   	ret    
80101a58:	90                   	nop
80101a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a60:	8b 43 04             	mov    0x4(%ebx),%eax
80101a63:	83 ec 08             	sub    $0x8,%esp
80101a66:	c1 e8 03             	shr    $0x3,%eax
80101a69:	03 05 d4 3d 11 80    	add    0x80113dd4,%eax
80101a6f:	50                   	push   %eax
80101a70:	ff 33                	pushl  (%ebx)
80101a72:	e8 59 e6 ff ff       	call   801000d0 <bread>
80101a77:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a79:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a7c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a7f:	83 e0 07             	and    $0x7,%eax
80101a82:	c1 e0 06             	shl    $0x6,%eax
80101a85:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101a89:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a8c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
80101a8f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101a93:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101a97:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101a9b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
80101a9f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101aa3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101aa7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101aab:	8b 50 fc             	mov    -0x4(%eax),%edx
80101aae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101ab1:	6a 34                	push   $0x34
80101ab3:	50                   	push   %eax
80101ab4:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101ab7:	50                   	push   %eax
80101ab8:	e8 93 38 00 00       	call   80105350 <memmove>
    brelse(bp);
80101abd:	89 34 24             	mov    %esi,(%esp)
80101ac0:	e8 1b e7 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101ac5:	83 c4 10             	add    $0x10,%esp
80101ac8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
80101acd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101ad4:	0f 85 77 ff ff ff    	jne    80101a51 <ilock+0x31>
      panic("ilock: no type");
80101ada:	83 ec 0c             	sub    $0xc,%esp
80101add:	68 d2 91 10 80       	push   $0x801091d2
80101ae2:	e8 a9 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101ae7:	83 ec 0c             	sub    $0xc,%esp
80101aea:	68 cc 91 10 80       	push   $0x801091cc
80101aef:	e8 9c e8 ff ff       	call   80100390 <panic>
80101af4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101afa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101b00 <iunlock>:
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	56                   	push   %esi
80101b04:	53                   	push   %ebx
80101b05:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b08:	85 db                	test   %ebx,%ebx
80101b0a:	74 28                	je     80101b34 <iunlock+0x34>
80101b0c:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b0f:	83 ec 0c             	sub    $0xc,%esp
80101b12:	56                   	push   %esi
80101b13:	e8 e8 34 00 00       	call   80105000 <holdingsleep>
80101b18:	83 c4 10             	add    $0x10,%esp
80101b1b:	85 c0                	test   %eax,%eax
80101b1d:	74 15                	je     80101b34 <iunlock+0x34>
80101b1f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b22:	85 c0                	test   %eax,%eax
80101b24:	7e 0e                	jle    80101b34 <iunlock+0x34>
  releasesleep(&ip->lock);
80101b26:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101b29:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b2c:	5b                   	pop    %ebx
80101b2d:	5e                   	pop    %esi
80101b2e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101b2f:	e9 8c 34 00 00       	jmp    80104fc0 <releasesleep>
    panic("iunlock");
80101b34:	83 ec 0c             	sub    $0xc,%esp
80101b37:	68 e1 91 10 80       	push   $0x801091e1
80101b3c:	e8 4f e8 ff ff       	call   80100390 <panic>
80101b41:	eb 0d                	jmp    80101b50 <iput>
80101b43:	90                   	nop
80101b44:	90                   	nop
80101b45:	90                   	nop
80101b46:	90                   	nop
80101b47:	90                   	nop
80101b48:	90                   	nop
80101b49:	90                   	nop
80101b4a:	90                   	nop
80101b4b:	90                   	nop
80101b4c:	90                   	nop
80101b4d:	90                   	nop
80101b4e:	90                   	nop
80101b4f:	90                   	nop

80101b50 <iput>:
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	57                   	push   %edi
80101b54:	56                   	push   %esi
80101b55:	53                   	push   %ebx
80101b56:	83 ec 28             	sub    $0x28,%esp
80101b59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101b5c:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101b5f:	57                   	push   %edi
80101b60:	e8 fb 33 00 00       	call   80104f60 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101b65:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	85 d2                	test   %edx,%edx
80101b6d:	74 07                	je     80101b76 <iput+0x26>
80101b6f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101b74:	74 32                	je     80101ba8 <iput+0x58>
  releasesleep(&ip->lock);
80101b76:	83 ec 0c             	sub    $0xc,%esp
80101b79:	57                   	push   %edi
80101b7a:	e8 41 34 00 00       	call   80104fc0 <releasesleep>
  acquire(&icache.lock);
80101b7f:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80101b86:	e8 05 36 00 00       	call   80105190 <acquire>
  ip->ref--;
80101b8b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101b8f:	83 c4 10             	add    $0x10,%esp
80101b92:	c7 45 08 e0 3d 11 80 	movl   $0x80113de0,0x8(%ebp)
}
80101b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9c:	5b                   	pop    %ebx
80101b9d:	5e                   	pop    %esi
80101b9e:	5f                   	pop    %edi
80101b9f:	5d                   	pop    %ebp
  release(&icache.lock);
80101ba0:	e9 ab 36 00 00       	jmp    80105250 <release>
80101ba5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101ba8:	83 ec 0c             	sub    $0xc,%esp
80101bab:	68 e0 3d 11 80       	push   $0x80113de0
80101bb0:	e8 db 35 00 00       	call   80105190 <acquire>
    int r = ip->ref;
80101bb5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bb8:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80101bbf:	e8 8c 36 00 00       	call   80105250 <release>
    if(r == 1){
80101bc4:	83 c4 10             	add    $0x10,%esp
80101bc7:	83 fe 01             	cmp    $0x1,%esi
80101bca:	75 aa                	jne    80101b76 <iput+0x26>
80101bcc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101bd2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101bd5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101bd8:	89 cf                	mov    %ecx,%edi
80101bda:	eb 0b                	jmp    80101be7 <iput+0x97>
80101bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101be0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101be3:	39 fe                	cmp    %edi,%esi
80101be5:	74 19                	je     80101c00 <iput+0xb0>
    if(ip->addrs[i]){
80101be7:	8b 16                	mov    (%esi),%edx
80101be9:	85 d2                	test   %edx,%edx
80101beb:	74 f3                	je     80101be0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101bed:	8b 03                	mov    (%ebx),%eax
80101bef:	e8 bc f8 ff ff       	call   801014b0 <bfree>
      ip->addrs[i] = 0;
80101bf4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101bfa:	eb e4                	jmp    80101be0 <iput+0x90>
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101c00:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101c06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c09:	85 c0                	test   %eax,%eax
80101c0b:	75 33                	jne    80101c40 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101c0d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101c10:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101c17:	53                   	push   %ebx
80101c18:	e8 53 fd ff ff       	call   80101970 <iupdate>
      ip->type = 0;
80101c1d:	31 c0                	xor    %eax,%eax
80101c1f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101c23:	89 1c 24             	mov    %ebx,(%esp)
80101c26:	e8 45 fd ff ff       	call   80101970 <iupdate>
      ip->valid = 0;
80101c2b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101c32:	83 c4 10             	add    $0x10,%esp
80101c35:	e9 3c ff ff ff       	jmp    80101b76 <iput+0x26>
80101c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c40:	83 ec 08             	sub    $0x8,%esp
80101c43:	50                   	push   %eax
80101c44:	ff 33                	pushl  (%ebx)
80101c46:	e8 85 e4 ff ff       	call   801000d0 <bread>
80101c4b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101c51:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101c57:	8d 70 5c             	lea    0x5c(%eax),%esi
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	89 cf                	mov    %ecx,%edi
80101c5f:	eb 0e                	jmp    80101c6f <iput+0x11f>
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
80101c6b:	39 fe                	cmp    %edi,%esi
80101c6d:	74 0f                	je     80101c7e <iput+0x12e>
      if(a[j])
80101c6f:	8b 16                	mov    (%esi),%edx
80101c71:	85 d2                	test   %edx,%edx
80101c73:	74 f3                	je     80101c68 <iput+0x118>
        bfree(ip->dev, a[j]);
80101c75:	8b 03                	mov    (%ebx),%eax
80101c77:	e8 34 f8 ff ff       	call   801014b0 <bfree>
80101c7c:	eb ea                	jmp    80101c68 <iput+0x118>
    brelse(bp);
80101c7e:	83 ec 0c             	sub    $0xc,%esp
80101c81:	ff 75 e4             	pushl  -0x1c(%ebp)
80101c84:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c87:	e8 54 e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101c8c:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101c92:	8b 03                	mov    (%ebx),%eax
80101c94:	e8 17 f8 ff ff       	call   801014b0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101c99:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101ca0:	00 00 00 
80101ca3:	83 c4 10             	add    $0x10,%esp
80101ca6:	e9 62 ff ff ff       	jmp    80101c0d <iput+0xbd>
80101cab:	90                   	nop
80101cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <iunlockput>:
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	53                   	push   %ebx
80101cb4:	83 ec 10             	sub    $0x10,%esp
80101cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101cba:	53                   	push   %ebx
80101cbb:	e8 40 fe ff ff       	call   80101b00 <iunlock>
  iput(ip);
80101cc0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101cc3:	83 c4 10             	add    $0x10,%esp
}
80101cc6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101cc9:	c9                   	leave  
  iput(ip);
80101cca:	e9 81 fe ff ff       	jmp    80101b50 <iput>
80101ccf:	90                   	nop

80101cd0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101cd0:	55                   	push   %ebp
80101cd1:	89 e5                	mov    %esp,%ebp
80101cd3:	8b 55 08             	mov    0x8(%ebp),%edx
80101cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101cd9:	8b 0a                	mov    (%edx),%ecx
80101cdb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101cde:	8b 4a 04             	mov    0x4(%edx),%ecx
80101ce1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101ce4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101ce8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101ceb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101cef:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101cf3:	8b 52 58             	mov    0x58(%edx),%edx
80101cf6:	89 50 10             	mov    %edx,0x10(%eax)
}
80101cf9:	5d                   	pop    %ebp
80101cfa:	c3                   	ret    
80101cfb:	90                   	nop
80101cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d00 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
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
80101d17:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101d1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d20:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101d23:	0f 84 a7 00 00 00    	je     80101dd0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101d29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d2c:	8b 40 58             	mov    0x58(%eax),%eax
80101d2f:	39 c6                	cmp    %eax,%esi
80101d31:	0f 87 ba 00 00 00    	ja     80101df1 <readi+0xf1>
80101d37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101d3a:	89 f9                	mov    %edi,%ecx
80101d3c:	01 f1                	add    %esi,%ecx
80101d3e:	0f 82 ad 00 00 00    	jb     80101df1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101d44:	89 c2                	mov    %eax,%edx
80101d46:	29 f2                	sub    %esi,%edx
80101d48:	39 c8                	cmp    %ecx,%eax
80101d4a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d4d:	31 ff                	xor    %edi,%edi
80101d4f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101d51:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d54:	74 6c                	je     80101dc2 <readi+0xc2>
80101d56:	8d 76 00             	lea    0x0(%esi),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d60:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101d63:	89 f2                	mov    %esi,%edx
80101d65:	c1 ea 09             	shr    $0x9,%edx
80101d68:	89 d8                	mov    %ebx,%eax
80101d6a:	e8 91 f9 ff ff       	call   80101700 <bmap>
80101d6f:	83 ec 08             	sub    $0x8,%esp
80101d72:	50                   	push   %eax
80101d73:	ff 33                	pushl  (%ebx)
80101d75:	e8 56 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d7a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d7d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101d7f:	89 f0                	mov    %esi,%eax
80101d81:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d86:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d8b:	83 c4 0c             	add    $0xc,%esp
80101d8e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101d90:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101d94:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101d97:	29 fb                	sub    %edi,%ebx
80101d99:	39 d9                	cmp    %ebx,%ecx
80101d9b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101d9e:	53                   	push   %ebx
80101d9f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101da0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101da2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101da5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101da7:	e8 a4 35 00 00       	call   80105350 <memmove>
    brelse(bp);
80101dac:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101daf:	89 14 24             	mov    %edx,(%esp)
80101db2:	e8 29 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101db7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101dba:	83 c4 10             	add    $0x10,%esp
80101dbd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101dc0:	77 9e                	ja     80101d60 <readi+0x60>
  }
  return n;
80101dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc8:	5b                   	pop    %ebx
80101dc9:	5e                   	pop    %esi
80101dca:	5f                   	pop    %edi
80101dcb:	5d                   	pop    %ebp
80101dcc:	c3                   	ret    
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101dd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101dd4:	66 83 f8 09          	cmp    $0x9,%ax
80101dd8:	77 17                	ja     80101df1 <readi+0xf1>
80101dda:	8b 04 c5 60 3d 11 80 	mov    -0x7feec2a0(,%eax,8),%eax
80101de1:	85 c0                	test   %eax,%eax
80101de3:	74 0c                	je     80101df1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101de5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101de8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101def:	ff e0                	jmp    *%eax
      return -1;
80101df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101df6:	eb cd                	jmp    80101dc5 <readi+0xc5>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 1c             	sub    $0x1c,%esp
80101e09:	8b 45 08             	mov    0x8(%ebp),%eax
80101e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101e0f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e12:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101e17:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101e1a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101e1d:	8b 75 10             	mov    0x10(%ebp),%esi
80101e20:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101e23:	0f 84 b7 00 00 00    	je     80101ee0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101e29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e2c:	39 70 58             	cmp    %esi,0x58(%eax)
80101e2f:	0f 82 eb 00 00 00    	jb     80101f20 <writei+0x120>
80101e35:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101e38:	31 d2                	xor    %edx,%edx
80101e3a:	89 f8                	mov    %edi,%eax
80101e3c:	01 f0                	add    %esi,%eax
80101e3e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101e41:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101e46:	0f 87 d4 00 00 00    	ja     80101f20 <writei+0x120>
80101e4c:	85 d2                	test   %edx,%edx
80101e4e:	0f 85 cc 00 00 00    	jne    80101f20 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e54:	85 ff                	test   %edi,%edi
80101e56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101e5d:	74 72                	je     80101ed1 <writei+0xd1>
80101e5f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e60:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101e63:	89 f2                	mov    %esi,%edx
80101e65:	c1 ea 09             	shr    $0x9,%edx
80101e68:	89 f8                	mov    %edi,%eax
80101e6a:	e8 91 f8 ff ff       	call   80101700 <bmap>
80101e6f:	83 ec 08             	sub    $0x8,%esp
80101e72:	50                   	push   %eax
80101e73:	ff 37                	pushl  (%edi)
80101e75:	e8 56 e2 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101e7a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101e7d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e80:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101e82:	89 f0                	mov    %esi,%eax
80101e84:	b9 00 02 00 00       	mov    $0x200,%ecx
80101e89:	83 c4 0c             	add    $0xc,%esp
80101e8c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e91:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101e93:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101e97:	39 d9                	cmp    %ebx,%ecx
80101e99:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101e9c:	53                   	push   %ebx
80101e9d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ea0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101ea2:	50                   	push   %eax
80101ea3:	e8 a8 34 00 00       	call   80105350 <memmove>
    log_write(bp);
80101ea8:	89 3c 24             	mov    %edi,(%esp)
80101eab:	e8 a0 18 00 00       	call   80103750 <log_write>
    brelse(bp);
80101eb0:	89 3c 24             	mov    %edi,(%esp)
80101eb3:	e8 28 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101eb8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ebb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ec4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101ec7:	77 97                	ja     80101e60 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ec9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ecc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ecf:	77 37                	ja     80101f08 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ed1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ed7:	5b                   	pop    %ebx
80101ed8:	5e                   	pop    %esi
80101ed9:	5f                   	pop    %edi
80101eda:	5d                   	pop    %ebp
80101edb:	c3                   	ret    
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ee0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ee4:	66 83 f8 09          	cmp    $0x9,%ax
80101ee8:	77 36                	ja     80101f20 <writei+0x120>
80101eea:	8b 04 c5 64 3d 11 80 	mov    -0x7feec29c(,%eax,8),%eax
80101ef1:	85 c0                	test   %eax,%eax
80101ef3:	74 2b                	je     80101f20 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101ef5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ef8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101efb:	5b                   	pop    %ebx
80101efc:	5e                   	pop    %esi
80101efd:	5f                   	pop    %edi
80101efe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101eff:	ff e0                	jmp    *%eax
80101f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101f08:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101f0b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101f0e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101f11:	50                   	push   %eax
80101f12:	e8 59 fa ff ff       	call   80101970 <iupdate>
80101f17:	83 c4 10             	add    $0x10,%esp
80101f1a:	eb b5                	jmp    80101ed1 <writei+0xd1>
80101f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101f20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f25:	eb ad                	jmp    80101ed4 <writei+0xd4>
80101f27:	89 f6                	mov    %esi,%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101f36:	6a 0e                	push   $0xe
80101f38:	ff 75 0c             	pushl  0xc(%ebp)
80101f3b:	ff 75 08             	pushl  0x8(%ebp)
80101f3e:	e8 7d 34 00 00       	call   801053c0 <strncmp>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	83 ec 1c             	sub    $0x1c,%esp
80101f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101f5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101f61:	0f 85 85 00 00 00    	jne    80101fec <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101f67:	8b 53 58             	mov    0x58(%ebx),%edx
80101f6a:	31 ff                	xor    %edi,%edi
80101f6c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f6f:	85 d2                	test   %edx,%edx
80101f71:	74 3e                	je     80101fb1 <dirlookup+0x61>
80101f73:	90                   	nop
80101f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f78:	6a 10                	push   $0x10
80101f7a:	57                   	push   %edi
80101f7b:	56                   	push   %esi
80101f7c:	53                   	push   %ebx
80101f7d:	e8 7e fd ff ff       	call   80101d00 <readi>
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	83 f8 10             	cmp    $0x10,%eax
80101f88:	75 55                	jne    80101fdf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101f8a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f8f:	74 18                	je     80101fa9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101f91:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f94:	83 ec 04             	sub    $0x4,%esp
80101f97:	6a 0e                	push   $0xe
80101f99:	50                   	push   %eax
80101f9a:	ff 75 0c             	pushl  0xc(%ebp)
80101f9d:	e8 1e 34 00 00       	call   801053c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101fa2:	83 c4 10             	add    $0x10,%esp
80101fa5:	85 c0                	test   %eax,%eax
80101fa7:	74 17                	je     80101fc0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa9:	83 c7 10             	add    $0x10,%edi
80101fac:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101faf:	72 c7                	jb     80101f78 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101fb1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101fb4:	31 c0                	xor    %eax,%eax
}
80101fb6:	5b                   	pop    %ebx
80101fb7:	5e                   	pop    %esi
80101fb8:	5f                   	pop    %edi
80101fb9:	5d                   	pop    %ebp
80101fba:	c3                   	ret    
80101fbb:	90                   	nop
80101fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc3:	85 c0                	test   %eax,%eax
80101fc5:	74 05                	je     80101fcc <dirlookup+0x7c>
        *poff = off;
80101fc7:	8b 45 10             	mov    0x10(%ebp),%eax
80101fca:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101fcc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101fd0:	8b 03                	mov    (%ebx),%eax
80101fd2:	e8 59 f6 ff ff       	call   80101630 <iget>
}
80101fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fda:	5b                   	pop    %ebx
80101fdb:	5e                   	pop    %esi
80101fdc:	5f                   	pop    %edi
80101fdd:	5d                   	pop    %ebp
80101fde:	c3                   	ret    
      panic("dirlookup read");
80101fdf:	83 ec 0c             	sub    $0xc,%esp
80101fe2:	68 fb 91 10 80       	push   $0x801091fb
80101fe7:	e8 a4 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101fec:	83 ec 0c             	sub    $0xc,%esp
80101fef:	68 e9 91 10 80       	push   $0x801091e9
80101ff4:	e8 97 e3 ff ff       	call   80100390 <panic>
80101ff9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102000 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102000:	55                   	push   %ebp
80102001:	89 e5                	mov    %esp,%ebp
80102003:	57                   	push   %edi
80102004:	56                   	push   %esi
80102005:	53                   	push   %ebx
80102006:	89 cf                	mov    %ecx,%edi
80102008:	89 c3                	mov    %eax,%ebx
8010200a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010200d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80102010:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80102013:	0f 84 67 01 00 00    	je     80102180 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80102019:	e8 e2 22 00 00       	call   80104300 <myproc>
  acquire(&icache.lock);
8010201e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102021:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102024:	68 e0 3d 11 80       	push   $0x80113de0
80102029:	e8 62 31 00 00       	call   80105190 <acquire>
  ip->ref++;
8010202e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102032:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80102039:	e8 12 32 00 00       	call   80105250 <release>
8010203e:	83 c4 10             	add    $0x10,%esp
80102041:	eb 08                	jmp    8010204b <namex+0x4b>
80102043:	90                   	nop
80102044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80102048:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
8010204b:	0f b6 03             	movzbl (%ebx),%eax
8010204e:	3c 2f                	cmp    $0x2f,%al
80102050:	74 f6                	je     80102048 <namex+0x48>
  if(*path == 0)
80102052:	84 c0                	test   %al,%al
80102054:	0f 84 ee 00 00 00    	je     80102148 <namex+0x148>
  while(*path != '/' && *path != 0)
8010205a:	0f b6 03             	movzbl (%ebx),%eax
8010205d:	3c 2f                	cmp    $0x2f,%al
8010205f:	0f 84 b3 00 00 00    	je     80102118 <namex+0x118>
80102065:	84 c0                	test   %al,%al
80102067:	89 da                	mov    %ebx,%edx
80102069:	75 09                	jne    80102074 <namex+0x74>
8010206b:	e9 a8 00 00 00       	jmp    80102118 <namex+0x118>
80102070:	84 c0                	test   %al,%al
80102072:	74 0a                	je     8010207e <namex+0x7e>
    path++;
80102074:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80102077:	0f b6 02             	movzbl (%edx),%eax
8010207a:	3c 2f                	cmp    $0x2f,%al
8010207c:	75 f2                	jne    80102070 <namex+0x70>
8010207e:	89 d1                	mov    %edx,%ecx
80102080:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80102082:	83 f9 0d             	cmp    $0xd,%ecx
80102085:	0f 8e 91 00 00 00    	jle    8010211c <namex+0x11c>
    memmove(name, s, DIRSIZ);
8010208b:	83 ec 04             	sub    $0x4,%esp
8010208e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102091:	6a 0e                	push   $0xe
80102093:	53                   	push   %ebx
80102094:	57                   	push   %edi
80102095:	e8 b6 32 00 00       	call   80105350 <memmove>
    path++;
8010209a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
8010209d:	83 c4 10             	add    $0x10,%esp
    path++;
801020a0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
801020a2:	80 3a 2f             	cmpb   $0x2f,(%edx)
801020a5:	75 11                	jne    801020b8 <namex+0xb8>
801020a7:	89 f6                	mov    %esi,%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
801020b0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
801020b3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
801020b6:	74 f8                	je     801020b0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	56                   	push   %esi
801020bc:	e8 5f f9 ff ff       	call   80101a20 <ilock>
    if(ip->type != T_DIR){
801020c1:	83 c4 10             	add    $0x10,%esp
801020c4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801020c9:	0f 85 91 00 00 00    	jne    80102160 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
801020cf:	8b 55 e0             	mov    -0x20(%ebp),%edx
801020d2:	85 d2                	test   %edx,%edx
801020d4:	74 09                	je     801020df <namex+0xdf>
801020d6:	80 3b 00             	cmpb   $0x0,(%ebx)
801020d9:	0f 84 b7 00 00 00    	je     80102196 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801020df:	83 ec 04             	sub    $0x4,%esp
801020e2:	6a 00                	push   $0x0
801020e4:	57                   	push   %edi
801020e5:	56                   	push   %esi
801020e6:	e8 65 fe ff ff       	call   80101f50 <dirlookup>
801020eb:	83 c4 10             	add    $0x10,%esp
801020ee:	85 c0                	test   %eax,%eax
801020f0:	74 6e                	je     80102160 <namex+0x160>
  iunlock(ip);
801020f2:	83 ec 0c             	sub    $0xc,%esp
801020f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801020f8:	56                   	push   %esi
801020f9:	e8 02 fa ff ff       	call   80101b00 <iunlock>
  iput(ip);
801020fe:	89 34 24             	mov    %esi,(%esp)
80102101:	e8 4a fa ff ff       	call   80101b50 <iput>
80102106:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102109:	83 c4 10             	add    $0x10,%esp
8010210c:	89 c6                	mov    %eax,%esi
8010210e:	e9 38 ff ff ff       	jmp    8010204b <namex+0x4b>
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102118:	89 da                	mov    %ebx,%edx
8010211a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010211c:	83 ec 04             	sub    $0x4,%esp
8010211f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102122:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102125:	51                   	push   %ecx
80102126:	53                   	push   %ebx
80102127:	57                   	push   %edi
80102128:	e8 23 32 00 00       	call   80105350 <memmove>
    name[len] = 0;
8010212d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102130:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102133:	83 c4 10             	add    $0x10,%esp
80102136:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010213a:	89 d3                	mov    %edx,%ebx
8010213c:	e9 61 ff ff ff       	jmp    801020a2 <namex+0xa2>
80102141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102148:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010214b:	85 c0                	test   %eax,%eax
8010214d:	75 5d                	jne    801021ac <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010214f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102152:	89 f0                	mov    %esi,%eax
80102154:	5b                   	pop    %ebx
80102155:	5e                   	pop    %esi
80102156:	5f                   	pop    %edi
80102157:	5d                   	pop    %ebp
80102158:	c3                   	ret    
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102160:	83 ec 0c             	sub    $0xc,%esp
80102163:	56                   	push   %esi
80102164:	e8 97 f9 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102169:	89 34 24             	mov    %esi,(%esp)
      return 0;
8010216c:	31 f6                	xor    %esi,%esi
  iput(ip);
8010216e:	e8 dd f9 ff ff       	call   80101b50 <iput>
      return 0;
80102173:	83 c4 10             	add    $0x10,%esp
}
80102176:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102179:	89 f0                	mov    %esi,%eax
8010217b:	5b                   	pop    %ebx
8010217c:	5e                   	pop    %esi
8010217d:	5f                   	pop    %edi
8010217e:	5d                   	pop    %ebp
8010217f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80102180:	ba 01 00 00 00       	mov    $0x1,%edx
80102185:	b8 01 00 00 00       	mov    $0x1,%eax
8010218a:	e8 a1 f4 ff ff       	call   80101630 <iget>
8010218f:	89 c6                	mov    %eax,%esi
80102191:	e9 b5 fe ff ff       	jmp    8010204b <namex+0x4b>
      iunlock(ip);
80102196:	83 ec 0c             	sub    $0xc,%esp
80102199:	56                   	push   %esi
8010219a:	e8 61 f9 ff ff       	call   80101b00 <iunlock>
      return ip;
8010219f:	83 c4 10             	add    $0x10,%esp
}
801021a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a5:	89 f0                	mov    %esi,%eax
801021a7:	5b                   	pop    %ebx
801021a8:	5e                   	pop    %esi
801021a9:	5f                   	pop    %edi
801021aa:	5d                   	pop    %ebp
801021ab:	c3                   	ret    
    iput(ip);
801021ac:	83 ec 0c             	sub    $0xc,%esp
801021af:	56                   	push   %esi
    return 0;
801021b0:	31 f6                	xor    %esi,%esi
    iput(ip);
801021b2:	e8 99 f9 ff ff       	call   80101b50 <iput>
    return 0;
801021b7:	83 c4 10             	add    $0x10,%esp
801021ba:	eb 93                	jmp    8010214f <namex+0x14f>
801021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021c0 <dirlink>:
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	57                   	push   %edi
801021c4:	56                   	push   %esi
801021c5:	53                   	push   %ebx
801021c6:	83 ec 20             	sub    $0x20,%esp
801021c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801021cc:	6a 00                	push   $0x0
801021ce:	ff 75 0c             	pushl  0xc(%ebp)
801021d1:	53                   	push   %ebx
801021d2:	e8 79 fd ff ff       	call   80101f50 <dirlookup>
801021d7:	83 c4 10             	add    $0x10,%esp
801021da:	85 c0                	test   %eax,%eax
801021dc:	75 67                	jne    80102245 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021de:	8b 7b 58             	mov    0x58(%ebx),%edi
801021e1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021e4:	85 ff                	test   %edi,%edi
801021e6:	74 29                	je     80102211 <dirlink+0x51>
801021e8:	31 ff                	xor    %edi,%edi
801021ea:	8d 75 d8             	lea    -0x28(%ebp),%esi
801021ed:	eb 09                	jmp    801021f8 <dirlink+0x38>
801021ef:	90                   	nop
801021f0:	83 c7 10             	add    $0x10,%edi
801021f3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801021f6:	73 19                	jae    80102211 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021f8:	6a 10                	push   $0x10
801021fa:	57                   	push   %edi
801021fb:	56                   	push   %esi
801021fc:	53                   	push   %ebx
801021fd:	e8 fe fa ff ff       	call   80101d00 <readi>
80102202:	83 c4 10             	add    $0x10,%esp
80102205:	83 f8 10             	cmp    $0x10,%eax
80102208:	75 4e                	jne    80102258 <dirlink+0x98>
    if(de.inum == 0)
8010220a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010220f:	75 df                	jne    801021f0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102211:	8d 45 da             	lea    -0x26(%ebp),%eax
80102214:	83 ec 04             	sub    $0x4,%esp
80102217:	6a 0e                	push   $0xe
80102219:	ff 75 0c             	pushl  0xc(%ebp)
8010221c:	50                   	push   %eax
8010221d:	e8 fe 31 00 00       	call   80105420 <strncpy>
  de.inum = inum;
80102222:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102225:	6a 10                	push   $0x10
80102227:	57                   	push   %edi
80102228:	56                   	push   %esi
80102229:	53                   	push   %ebx
  de.inum = inum;
8010222a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010222e:	e8 cd fb ff ff       	call   80101e00 <writei>
80102233:	83 c4 20             	add    $0x20,%esp
80102236:	83 f8 10             	cmp    $0x10,%eax
80102239:	75 2a                	jne    80102265 <dirlink+0xa5>
  return 0;
8010223b:	31 c0                	xor    %eax,%eax
}
8010223d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102240:	5b                   	pop    %ebx
80102241:	5e                   	pop    %esi
80102242:	5f                   	pop    %edi
80102243:	5d                   	pop    %ebp
80102244:	c3                   	ret    
    iput(ip);
80102245:	83 ec 0c             	sub    $0xc,%esp
80102248:	50                   	push   %eax
80102249:	e8 02 f9 ff ff       	call   80101b50 <iput>
    return -1;
8010224e:	83 c4 10             	add    $0x10,%esp
80102251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102256:	eb e5                	jmp    8010223d <dirlink+0x7d>
      panic("dirlink read");
80102258:	83 ec 0c             	sub    $0xc,%esp
8010225b:	68 0a 92 10 80       	push   $0x8010920a
80102260:	e8 2b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102265:	83 ec 0c             	sub    $0xc,%esp
80102268:	68 99 99 10 80       	push   $0x80109999
8010226d:	e8 1e e1 ff ff       	call   80100390 <panic>
80102272:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102280 <namei>:

struct inode*
namei(char *path)
{
80102280:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102281:	31 d2                	xor    %edx,%edx
{
80102283:	89 e5                	mov    %esp,%ebp
80102285:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102288:	8b 45 08             	mov    0x8(%ebp),%eax
8010228b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010228e:	e8 6d fd ff ff       	call   80102000 <namex>
}
80102293:	c9                   	leave  
80102294:	c3                   	ret    
80102295:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801022a0:	55                   	push   %ebp
  return namex(path, 1, name);
801022a1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801022a6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801022a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801022ab:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022ae:	5d                   	pop    %ebp
  return namex(path, 1, name);
801022af:	e9 4c fd ff ff       	jmp    80102000 <namex>
801022b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801022ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801022c0 <itoa>:

#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
801022c0:	55                   	push   %ebp
    char const digit[] = "0123456789";
801022c1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
801022c6:	89 e5                	mov    %esp,%ebp
801022c8:	57                   	push   %edi
801022c9:	56                   	push   %esi
801022ca:	53                   	push   %ebx
801022cb:	83 ec 10             	sub    $0x10,%esp
801022ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
801022d1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
801022d8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
801022df:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
801022e3:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
801022e7:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
801022ea:	85 c9                	test   %ecx,%ecx
801022ec:	79 0a                	jns    801022f8 <itoa+0x38>
801022ee:	89 f0                	mov    %esi,%eax
801022f0:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
801022f3:	f7 d9                	neg    %ecx
        *p++ = '-';
801022f5:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
801022f8:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
801022fa:	bf 67 66 66 66       	mov    $0x66666667,%edi
801022ff:	90                   	nop
80102300:	89 d8                	mov    %ebx,%eax
80102302:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102305:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102308:	f7 ef                	imul   %edi
8010230a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010230d:	29 da                	sub    %ebx,%edx
8010230f:	89 d3                	mov    %edx,%ebx
80102311:	75 ed                	jne    80102300 <itoa+0x40>
    *p = '\0';
80102313:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102316:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010231b:	90                   	nop
8010231c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102320:	89 c8                	mov    %ecx,%eax
80102322:	83 ee 01             	sub    $0x1,%esi
80102325:	f7 eb                	imul   %ebx
80102327:	89 c8                	mov    %ecx,%eax
80102329:	c1 f8 1f             	sar    $0x1f,%eax
8010232c:	c1 fa 02             	sar    $0x2,%edx
8010232f:	29 c2                	sub    %eax,%edx
80102331:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102334:	01 c0                	add    %eax,%eax
80102336:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102338:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010233a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010233f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102341:	88 06                	mov    %al,(%esi)
    }while(i);
80102343:	75 db                	jne    80102320 <itoa+0x60>
    return b;
}
80102345:	8b 45 0c             	mov    0xc(%ebp),%eax
80102348:	83 c4 10             	add    $0x10,%esp
8010234b:	5b                   	pop    %ebx
8010234c:	5e                   	pop    %esi
8010234d:	5f                   	pop    %edi
8010234e:	5d                   	pop    %ebp
8010234f:	c3                   	ret    

80102350 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	57                   	push   %edi
80102354:	56                   	push   %esi
80102355:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102356:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102359:	83 ec 40             	sub    $0x40,%esp
8010235c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010235f:	6a 06                	push   $0x6
80102361:	68 17 92 10 80       	push   $0x80109217
80102366:	56                   	push   %esi
80102367:	e8 e4 2f 00 00       	call   80105350 <memmove>
  itoa(p->pid, path+ 6);
8010236c:	58                   	pop    %eax
8010236d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102370:	5a                   	pop    %edx
80102371:	50                   	push   %eax
80102372:	ff 73 10             	pushl  0x10(%ebx)
80102375:	e8 46 ff ff ff       	call   801022c0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010237a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	85 c0                	test   %eax,%eax
80102382:	0f 84 88 01 00 00    	je     80102510 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80102388:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
8010238b:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
8010238e:	50                   	push   %eax
8010238f:	e8 4c ee ff ff       	call   801011e0 <fileclose>

  begin_op();
80102394:	e8 e7 11 00 00       	call   80103580 <begin_op>
  return namex(path, 1, name);
80102399:	89 f0                	mov    %esi,%eax
8010239b:	89 d9                	mov    %ebx,%ecx
8010239d:	ba 01 00 00 00       	mov    $0x1,%edx
801023a2:	e8 59 fc ff ff       	call   80102000 <namex>
  if((dp = nameiparent(path, name)) == 0)
801023a7:	83 c4 10             	add    $0x10,%esp
801023aa:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801023ac:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801023ae:	0f 84 66 01 00 00    	je     8010251a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	50                   	push   %eax
801023b8:	e8 63 f6 ff ff       	call   80101a20 <ilock>
  return strncmp(s, t, DIRSIZ);
801023bd:	83 c4 0c             	add    $0xc,%esp
801023c0:	6a 0e                	push   $0xe
801023c2:	68 1f 92 10 80       	push   $0x8010921f
801023c7:	53                   	push   %ebx
801023c8:	e8 f3 2f 00 00       	call   801053c0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023cd:	83 c4 10             	add    $0x10,%esp
801023d0:	85 c0                	test   %eax,%eax
801023d2:	0f 84 f8 00 00 00    	je     801024d0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023d8:	83 ec 04             	sub    $0x4,%esp
801023db:	6a 0e                	push   $0xe
801023dd:	68 1e 92 10 80       	push   $0x8010921e
801023e2:	53                   	push   %ebx
801023e3:	e8 d8 2f 00 00       	call   801053c0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023e8:	83 c4 10             	add    $0x10,%esp
801023eb:	85 c0                	test   %eax,%eax
801023ed:	0f 84 dd 00 00 00    	je     801024d0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801023f3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801023f6:	83 ec 04             	sub    $0x4,%esp
801023f9:	50                   	push   %eax
801023fa:	53                   	push   %ebx
801023fb:	56                   	push   %esi
801023fc:	e8 4f fb ff ff       	call   80101f50 <dirlookup>
80102401:	83 c4 10             	add    $0x10,%esp
80102404:	85 c0                	test   %eax,%eax
80102406:	89 c3                	mov    %eax,%ebx
80102408:	0f 84 c2 00 00 00    	je     801024d0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010240e:	83 ec 0c             	sub    $0xc,%esp
80102411:	50                   	push   %eax
80102412:	e8 09 f6 ff ff       	call   80101a20 <ilock>

  if(ip->nlink < 1)
80102417:	83 c4 10             	add    $0x10,%esp
8010241a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010241f:	0f 8e 11 01 00 00    	jle    80102536 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102425:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010242a:	74 74                	je     801024a0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010242c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010242f:	83 ec 04             	sub    $0x4,%esp
80102432:	6a 10                	push   $0x10
80102434:	6a 00                	push   $0x0
80102436:	57                   	push   %edi
80102437:	e8 64 2e 00 00       	call   801052a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010243c:	6a 10                	push   $0x10
8010243e:	ff 75 b8             	pushl  -0x48(%ebp)
80102441:	57                   	push   %edi
80102442:	56                   	push   %esi
80102443:	e8 b8 f9 ff ff       	call   80101e00 <writei>
80102448:	83 c4 20             	add    $0x20,%esp
8010244b:	83 f8 10             	cmp    $0x10,%eax
8010244e:	0f 85 d5 00 00 00    	jne    80102529 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102454:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102459:	0f 84 91 00 00 00    	je     801024f0 <removeSwapFile+0x1a0>
  iunlock(ip);
8010245f:	83 ec 0c             	sub    $0xc,%esp
80102462:	56                   	push   %esi
80102463:	e8 98 f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102468:	89 34 24             	mov    %esi,(%esp)
8010246b:	e8 e0 f6 ff ff       	call   80101b50 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102470:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102475:	89 1c 24             	mov    %ebx,(%esp)
80102478:	e8 f3 f4 ff ff       	call   80101970 <iupdate>
  iunlock(ip);
8010247d:	89 1c 24             	mov    %ebx,(%esp)
80102480:	e8 7b f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
80102485:	89 1c 24             	mov    %ebx,(%esp)
80102488:	e8 c3 f6 ff ff       	call   80101b50 <iput>
  iunlockput(ip);

  end_op();
8010248d:	e8 5e 11 00 00       	call   801035f0 <end_op>

  return 0;
80102492:	83 c4 10             	add    $0x10,%esp
80102495:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102497:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010249a:	5b                   	pop    %ebx
8010249b:	5e                   	pop    %esi
8010249c:	5f                   	pop    %edi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    
8010249f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	53                   	push   %ebx
801024a4:	e8 d7 35 00 00       	call   80105a80 <isdirempty>
801024a9:	83 c4 10             	add    $0x10,%esp
801024ac:	85 c0                	test   %eax,%eax
801024ae:	0f 85 78 ff ff ff    	jne    8010242c <removeSwapFile+0xdc>
  iunlock(ip);
801024b4:	83 ec 0c             	sub    $0xc,%esp
801024b7:	53                   	push   %ebx
801024b8:	e8 43 f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
801024bd:	89 1c 24             	mov    %ebx,(%esp)
801024c0:	e8 8b f6 ff ff       	call   80101b50 <iput>
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	90                   	nop
801024c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	56                   	push   %esi
801024d4:	e8 27 f6 ff ff       	call   80101b00 <iunlock>
  iput(ip);
801024d9:	89 34 24             	mov    %esi,(%esp)
801024dc:	e8 6f f6 ff ff       	call   80101b50 <iput>
    end_op();
801024e1:	e8 0a 11 00 00       	call   801035f0 <end_op>
    return -1;
801024e6:	83 c4 10             	add    $0x10,%esp
801024e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024ee:	eb a7                	jmp    80102497 <removeSwapFile+0x147>
    dp->nlink--;
801024f0:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801024f5:	83 ec 0c             	sub    $0xc,%esp
801024f8:	56                   	push   %esi
801024f9:	e8 72 f4 ff ff       	call   80101970 <iupdate>
801024fe:	83 c4 10             	add    $0x10,%esp
80102501:	e9 59 ff ff ff       	jmp    8010245f <removeSwapFile+0x10f>
80102506:	8d 76 00             	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102515:	e9 7d ff ff ff       	jmp    80102497 <removeSwapFile+0x147>
    end_op();
8010251a:	e8 d1 10 00 00       	call   801035f0 <end_op>
    return -1;
8010251f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102524:	e9 6e ff ff ff       	jmp    80102497 <removeSwapFile+0x147>
    panic("unlink: writei");
80102529:	83 ec 0c             	sub    $0xc,%esp
8010252c:	68 33 92 10 80       	push   $0x80109233
80102531:	e8 5a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102536:	83 ec 0c             	sub    $0xc,%esp
80102539:	68 21 92 10 80       	push   $0x80109221
8010253e:	e8 4d de ff ff       	call   80100390 <panic>
80102543:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102550 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
80102554:	53                   	push   %ebx
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102555:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102558:	83 ec 14             	sub    $0x14,%esp
8010255b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010255e:	6a 06                	push   $0x6
80102560:	68 17 92 10 80       	push   $0x80109217
80102565:	56                   	push   %esi
80102566:	e8 e5 2d 00 00       	call   80105350 <memmove>
  itoa(p->pid, path+ 6);
8010256b:	58                   	pop    %eax
8010256c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010256f:	5a                   	pop    %edx
80102570:	50                   	push   %eax
80102571:	ff 73 10             	pushl  0x10(%ebx)
80102574:	e8 47 fd ff ff       	call   801022c0 <itoa>

    begin_op();
80102579:	e8 02 10 00 00       	call   80103580 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010257e:	6a 00                	push   $0x0
80102580:	6a 00                	push   $0x0
80102582:	6a 02                	push   $0x2
80102584:	56                   	push   %esi
80102585:	e8 06 37 00 00       	call   80105c90 <create>
  iunlock(in);
8010258a:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
8010258d:	89 c6                	mov    %eax,%esi
  iunlock(in);
8010258f:	50                   	push   %eax
80102590:	e8 6b f5 ff ff       	call   80101b00 <iunlock>

  p->swapFile = filealloc();
80102595:	e8 86 eb ff ff       	call   80101120 <filealloc>
  if (p->swapFile == 0)
8010259a:	83 c4 10             	add    $0x10,%esp
8010259d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010259f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801025a2:	74 32                	je     801025d6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801025a4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801025a7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025aa:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801025b0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025b3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801025ba:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025bd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801025c1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801025c4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801025c8:	e8 23 10 00 00       	call   801035f0 <end_op>

    return 0;
}
801025cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d0:	31 c0                	xor    %eax,%eax
801025d2:	5b                   	pop    %ebx
801025d3:	5e                   	pop    %esi
801025d4:	5d                   	pop    %ebp
801025d5:	c3                   	ret    
    panic("no slot for files on /store");
801025d6:	83 ec 0c             	sub    $0xc,%esp
801025d9:	68 42 92 10 80       	push   $0x80109242
801025de:	e8 ad dd ff ff       	call   80100390 <panic>
801025e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801025e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025f0 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
801025f0:	55                   	push   %ebp
801025f1:	89 e5                	mov    %esp,%ebp
801025f3:	57                   	push   %edi
801025f4:	56                   	push   %esi
801025f5:	53                   	push   %ebx
801025f6:	83 ec 28             	sub    $0x28,%esp
801025f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801025fc:	8b 55 10             	mov    0x10(%ebp),%edx
  cprintf("a page has been written to swap\n");
801025ff:	68 b4 92 10 80       	push   $0x801092b4
{
80102604:	8b 75 0c             	mov    0xc(%ebp),%esi
80102607:	8b 7d 14             	mov    0x14(%ebp),%edi
8010260a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  cprintf("a page has been written to swap\n");
8010260d:	e8 4e e0 ff ff       	call   80100660 <cprintf>
  p->swapFile->off = placeOnFile;
80102612:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102615:	8b 55 e4             	mov    -0x1c(%ebp),%edx

  return filewrite(p->swapFile, buffer, size);
80102618:	83 c4 10             	add    $0x10,%esp
  p->swapFile->off = placeOnFile;
8010261b:	89 50 14             	mov    %edx,0x14(%eax)
  return filewrite(p->swapFile, buffer, size);
8010261e:	89 7d 10             	mov    %edi,0x10(%ebp)
80102621:	89 75 0c             	mov    %esi,0xc(%ebp)
80102624:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102627:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010262a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010262d:	5b                   	pop    %ebx
8010262e:	5e                   	pop    %esi
8010262f:	5f                   	pop    %edi
80102630:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
80102631:	e9 5a ed ff ff       	jmp    80101390 <filewrite>
80102636:	8d 76 00             	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
8010265c:	e9 9f ec ff ff       	jmp    80101300 <fileread>
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
8010272b:	68 de 92 10 80       	push   $0x801092de
80102730:	e8 5b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102735:	83 ec 0c             	sub    $0xc,%esp
80102738:	68 d5 92 10 80       	push   $0x801092d5
8010273d:	e8 4e dc ff ff       	call   80100390 <panic>
80102742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102750 <ideinit>:
{
80102750:	55                   	push   %ebp
80102751:	89 e5                	mov    %esp,%ebp
80102753:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102756:	68 f0 92 10 80       	push   $0x801092f0
8010275b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102760:	e8 eb 28 00 00       	call   80105050 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102765:	58                   	pop    %eax
80102766:	a1 00 61 18 80       	mov    0x80186100,%eax
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
801027de:	e8 ad 29 00 00       	call   80105190 <acquire>

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
80102841:	e8 ca 24 00 00       	call   80104d10 <wakeup>

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
8010285f:	e8 ec 29 00 00       	call   80105250 <release>

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
8010287e:	e8 7d 27 00 00       	call   80105000 <holdingsleep>
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
801028b8:	e8 d3 28 00 00       	call   80105190 <acquire>

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
80102926:	e9 25 29 00 00       	jmp    80105250 <release>
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
8010294a:	68 0a 93 10 80       	push   $0x8010930a
8010294f:	e8 3c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102954:	83 ec 0c             	sub    $0xc,%esp
80102957:	68 f4 92 10 80       	push   $0x801092f4
8010295c:	e8 2f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102961:	83 ec 0c             	sub    $0xc,%esp
80102964:	68 1f 93 10 80       	push   $0x8010931f
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
80102971:	c7 05 34 5a 11 80 00 	movl   $0xfec00000,0x80115a34
80102978:	00 c0 fe 
{
8010297b:	89 e5                	mov    %esp,%ebp
8010297d:	56                   	push   %esi
8010297e:	53                   	push   %ebx
  ioapic->reg = reg;
8010297f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102986:	00 00 00 
  return ioapic->data;
80102989:	a1 34 5a 11 80       	mov    0x80115a34,%eax
8010298e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102991:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102997:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010299d:	0f b6 15 60 5b 18 80 	movzbl 0x80185b60,%edx
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
801029b7:	68 40 93 10 80       	push   $0x80109340
801029bc:	e8 9f dc ff ff       	call   80100660 <cprintf>
801029c1:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
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
801029e2:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx

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
80102a00:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
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
80102a21:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
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
80102a35:	8b 0d 34 5a 11 80    	mov    0x80115a34,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a3b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102a3e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102a44:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102a46:	a1 34 5a 11 80       	mov    0x80115a34,%eax
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
80102a75:	3d a8 75 19 80       	cmp    $0x801975a8,%eax
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
80102a9d:	e8 fe 27 00 00       	call   801052a0 <memset>

  if(kmem.use_lock) 
80102aa2:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
80102aa8:	83 c4 10             	add    $0x10,%esp
80102aab:	85 d2                	test   %edx,%edx
80102aad:	75 61                	jne    80102b10 <kfree+0xb0>
    acquire(&kmem.lock);
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102aaf:	c1 eb 0c             	shr    $0xc,%ebx
80102ab2:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 1)
80102ab5:	83 3c c5 50 5a 11 80 	cmpl   $0x1,-0x7feea5b0(,%eax,8)
80102abc:	01 
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102abd:	8d 14 c5 4c 5a 11 80 	lea    -0x7feea5b4(,%eax,8),%edx
  if(r->refcount != 1)
80102ac4:	75 69                	jne    80102b2f <kfree+0xcf>
    // cprintf("ref count is %d", r->refcount);
    panic("kfree: freeing a shared page");
  }


  r->next = kmem.freelist;
80102ac6:	8b 0d 78 5a 11 80    	mov    0x80115a78,%ecx
  r->refcount = 0;
80102acc:	c7 04 c5 50 5a 11 80 	movl   $0x0,-0x7feea5b0(,%eax,8)
80102ad3:	00 00 00 00 
  kmem.freelist = r;
80102ad7:	89 15 78 5a 11 80    	mov    %edx,0x80115a78
  r->next = kmem.freelist;
80102add:	89 0c c5 4c 5a 11 80 	mov    %ecx,-0x7feea5b4(,%eax,8)
  if(kmem.use_lock)
80102ae4:	a1 74 5a 11 80       	mov    0x80115a74,%eax
80102ae9:	85 c0                	test   %eax,%eax
80102aeb:	75 0b                	jne    80102af8 <kfree+0x98>
    release(&kmem.lock);
}
80102aed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102af0:	c9                   	leave  
80102af1:	c3                   	ret    
80102af2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102af8:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b02:	c9                   	leave  
    release(&kmem.lock);
80102b03:	e9 48 27 00 00       	jmp    80105250 <release>
80102b08:	90                   	nop
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b10:	83 ec 0c             	sub    $0xc,%esp
80102b13:	68 40 5a 11 80       	push   $0x80115a40
80102b18:	e8 73 26 00 00       	call   80105190 <acquire>
80102b1d:	83 c4 10             	add    $0x10,%esp
80102b20:	eb 8d                	jmp    80102aaf <kfree+0x4f>
    panic("kfree");
80102b22:	83 ec 0c             	sub    $0xc,%esp
80102b25:	68 72 93 10 80       	push   $0x80109372
80102b2a:	e8 61 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b2f:	83 ec 0c             	sub    $0xc,%esp
80102b32:	68 78 93 10 80       	push   $0x80109378
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
80102b55:	3d a8 75 19 80       	cmp    $0x801975a8,%eax
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
80102b7d:	e8 1e 27 00 00       	call   801052a0 <memset>

  if(kmem.use_lock) 
80102b82:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
80102b88:	83 c4 10             	add    $0x10,%esp
80102b8b:	85 d2                	test   %edx,%edx
80102b8d:	75 31                	jne    80102bc0 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102b8f:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102b94:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102b97:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
80102b9a:	c7 04 dd 50 5a 11 80 	movl   $0x0,-0x7feea5b0(,%ebx,8)
80102ba1:	00 00 00 00 
  r->next = kmem.freelist;
80102ba5:	89 04 dd 4c 5a 11 80 	mov    %eax,-0x7feea5b4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bac:	8d 04 dd 4c 5a 11 80 	lea    -0x7feea5b4(,%ebx,8),%eax
80102bb3:	a3 78 5a 11 80       	mov    %eax,0x80115a78
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
80102bc6:	68 40 5a 11 80       	push   $0x80115a40
  r->next = kmem.freelist;
80102bcb:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102bce:	e8 bd 25 00 00       	call   80105190 <acquire>
  r->next = kmem.freelist;
80102bd3:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  if(kmem.use_lock)
80102bd8:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102bdb:	c7 04 dd 50 5a 11 80 	movl   $0x0,-0x7feea5b0(,%ebx,8)
80102be2:	00 00 00 00 
  r->next = kmem.freelist;
80102be6:	89 04 dd 4c 5a 11 80 	mov    %eax,-0x7feea5b4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bed:	8d 04 dd 4c 5a 11 80 	lea    -0x7feea5b4(,%ebx,8),%eax
80102bf4:	a3 78 5a 11 80       	mov    %eax,0x80115a78
  if(kmem.use_lock)
80102bf9:	a1 74 5a 11 80       	mov    0x80115a74,%eax
80102bfe:	85 c0                	test   %eax,%eax
80102c00:	74 b6                	je     80102bb8 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102c02:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102c09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c0c:	c9                   	leave  
    release(&kmem.lock);
80102c0d:	e9 3e 26 00 00       	jmp    80105250 <release>
    panic("kfree_nocheck");
80102c12:	83 ec 0c             	sub    $0xc,%esp
80102c15:	68 95 93 10 80       	push   $0x80109395
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
80102c7b:	68 a3 93 10 80       	push   $0x801093a3
80102c80:	68 40 5a 11 80       	push   $0x80115a40
80102c85:	e8 c6 23 00 00       	call   80105050 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c8d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c90:	c7 05 74 5a 11 80 00 	movl   $0x0,0x80115a74
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
80102d24:	c7 05 74 5a 11 80 01 	movl   $0x1,0x80115a74
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
80102d46:	a1 74 5a 11 80       	mov    0x80115a74,%eax
80102d4b:	85 c0                	test   %eax,%eax
80102d4d:	75 59                	jne    80102da8 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d4f:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  if(r)
80102d54:	85 c0                	test   %eax,%eax
80102d56:	74 73                	je     80102dcb <kalloc+0x8b>
  {
    kmem.freelist = r->next;
80102d58:	8b 10                	mov    (%eax),%edx
80102d5a:	89 15 78 5a 11 80    	mov    %edx,0x80115a78
    r->refcount = 1;
80102d60:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102d67:	8b 0d 74 5a 11 80    	mov    0x80115a74,%ecx
80102d6d:	85 c9                	test   %ecx,%ecx
80102d6f:	75 0f                	jne    80102d80 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d71:	2d 7c 5a 11 80       	sub    $0x80115a7c,%eax
80102d76:	c1 e0 09             	shl    $0x9,%eax
80102d79:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102d7e:	c9                   	leave  
80102d7f:	c3                   	ret    
    release(&kmem.lock);
80102d80:	83 ec 0c             	sub    $0xc,%esp
80102d83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d86:	68 40 5a 11 80       	push   $0x80115a40
80102d8b:	e8 c0 24 00 00       	call   80105250 <release>
80102d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d93:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d96:	2d 7c 5a 11 80       	sub    $0x80115a7c,%eax
80102d9b:	c1 e0 09             	shl    $0x9,%eax
80102d9e:	05 00 00 00 80       	add    $0x80000000,%eax
80102da3:	eb d9                	jmp    80102d7e <kalloc+0x3e>
80102da5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102da8:	83 ec 0c             	sub    $0xc,%esp
80102dab:	68 40 5a 11 80       	push   $0x80115a40
80102db0:	e8 db 23 00 00       	call   80105190 <acquire>
  r = kmem.freelist;
80102db5:	a1 78 5a 11 80       	mov    0x80115a78,%eax
  if(r)
80102dba:	83 c4 10             	add    $0x10,%esp
80102dbd:	85 c0                	test   %eax,%eax
80102dbf:	75 97                	jne    80102d58 <kalloc+0x18>
  if(kmem.use_lock)
80102dc1:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
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
80102dd6:	68 40 5a 11 80       	push   $0x80115a40
80102ddb:	e8 70 24 00 00       	call   80105250 <release>
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
80102df7:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
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
80102e0d:	83 2c c5 80 5a 11 80 	subl   $0x1,-0x7feea580(,%eax,8)
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
80102e29:	68 40 5a 11 80       	push   $0x80115a40
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e2e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e31:	e8 5a 23 00 00       	call   80105190 <acquire>
  if(kmem.use_lock)
80102e36:	a1 74 5a 11 80       	mov    0x80115a74,%eax
  r->refcount -= 1;
80102e3b:	83 2c dd 80 5a 11 80 	subl   $0x1,-0x7feea580(,%ebx,8)
80102e42:	01 
  if(kmem.use_lock)
80102e43:	83 c4 10             	add    $0x10,%esp
80102e46:	85 c0                	test   %eax,%eax
80102e48:	74 cb                	je     80102e15 <refDec+0x25>
    release(&kmem.lock);
80102e4a:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102e51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e54:	c9                   	leave  
    release(&kmem.lock);
80102e55:	e9 f6 23 00 00       	jmp    80105250 <release>
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
80102e67:	8b 15 74 5a 11 80    	mov    0x80115a74,%edx
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
80102e7d:	83 04 c5 80 5a 11 80 	addl   $0x1,-0x7feea580(,%eax,8)
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
80102e99:	68 40 5a 11 80       	push   $0x80115a40
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e9e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ea1:	e8 ea 22 00 00       	call   80105190 <acquire>
  if(kmem.use_lock)
80102ea6:	a1 74 5a 11 80       	mov    0x80115a74,%eax
  r->refcount += 1;
80102eab:	83 04 dd 80 5a 11 80 	addl   $0x1,-0x7feea580(,%ebx,8)
80102eb2:	01 
  if(kmem.use_lock)
80102eb3:	83 c4 10             	add    $0x10,%esp
80102eb6:	85 c0                	test   %eax,%eax
80102eb8:	74 cb                	je     80102e85 <refInc+0x25>
    release(&kmem.lock);
80102eba:	c7 45 08 40 5a 11 80 	movl   $0x80115a40,0x8(%ebp)
}
80102ec1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ec4:	c9                   	leave  
    release(&kmem.lock);
80102ec5:	e9 86 23 00 00       	jmp    80105250 <release>
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
}
80102ed6:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102ed7:	05 00 00 00 80       	add    $0x80000000,%eax
80102edc:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102edf:	8b 04 c5 80 5a 11 80 	mov    -0x7feea580(,%eax,8),%eax
}
80102ee6:	c3                   	ret    
80102ee7:	89 f6                	mov    %esi,%esi
80102ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ef0 <getNumOfFreePages>:

int getNumOfFreePages(void) {
  int c = 0;
  struct run *r = kmem.freelist;
80102ef0:	8b 15 78 5a 11 80    	mov    0x80115a78,%edx
int getNumOfFreePages(void) {
80102ef6:	55                   	push   %ebp
  int c = 0;
80102ef7:	31 c0                	xor    %eax,%eax
int getNumOfFreePages(void) {
80102ef9:	89 e5                	mov    %esp,%ebp
  while(r) {
80102efb:	85 d2                	test   %edx,%edx
80102efd:	74 0a                	je     80102f09 <getNumOfFreePages+0x19>
80102eff:	90                   	nop
    c++;
    r = r->next;
80102f00:	8b 12                	mov    (%edx),%edx
    c++;
80102f02:	83 c0 01             	add    $0x1,%eax
  while(r) {
80102f05:	85 d2                	test   %edx,%edx
80102f07:	75 f7                	jne    80102f00 <getNumOfFreePages+0x10>
  }
  return c;
80102f09:	5d                   	pop    %ebp
80102f0a:	c3                   	ret    
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102f10:	ba 64 00 00 00       	mov    $0x64,%edx
80102f15:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102f16:	a8 01                	test   $0x1,%al
80102f18:	0f 84 c2 00 00 00    	je     80102fe0 <kbdgetc+0xd0>
80102f1e:	ba 60 00 00 00       	mov    $0x60,%edx
80102f23:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102f24:	0f b6 d0             	movzbl %al,%edx
80102f27:	8b 0d d4 c5 10 80    	mov    0x8010c5d4,%ecx

  if(data == 0xE0){
80102f2d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102f33:	0f 84 7f 00 00 00    	je     80102fb8 <kbdgetc+0xa8>
{
80102f39:	55                   	push   %ebp
80102f3a:	89 e5                	mov    %esp,%ebp
80102f3c:	53                   	push   %ebx
80102f3d:	89 cb                	mov    %ecx,%ebx
80102f3f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f42:	84 c0                	test   %al,%al
80102f44:	78 4a                	js     80102f90 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f46:	85 db                	test   %ebx,%ebx
80102f48:	74 09                	je     80102f53 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f4a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f4d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102f50:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f53:	0f b6 82 e0 94 10 80 	movzbl -0x7fef6b20(%edx),%eax
80102f5a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f5c:	0f b6 82 e0 93 10 80 	movzbl -0x7fef6c20(%edx),%eax
80102f63:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f65:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f67:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f6d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f70:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f73:	8b 04 85 c0 93 10 80 	mov    -0x7fef6c40(,%eax,4),%eax
80102f7a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102f7e:	74 31                	je     80102fb1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102f80:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f83:	83 fa 19             	cmp    $0x19,%edx
80102f86:	77 40                	ja     80102fc8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f88:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f8b:	5b                   	pop    %ebx
80102f8c:	5d                   	pop    %ebp
80102f8d:	c3                   	ret    
80102f8e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f90:	83 e0 7f             	and    $0x7f,%eax
80102f93:	85 db                	test   %ebx,%ebx
80102f95:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102f98:	0f b6 82 e0 94 10 80 	movzbl -0x7fef6b20(%edx),%eax
80102f9f:	83 c8 40             	or     $0x40,%eax
80102fa2:	0f b6 c0             	movzbl %al,%eax
80102fa5:	f7 d0                	not    %eax
80102fa7:	21 c1                	and    %eax,%ecx
    return 0;
80102fa9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102fab:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
}
80102fb1:	5b                   	pop    %ebx
80102fb2:	5d                   	pop    %ebp
80102fb3:	c3                   	ret    
80102fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102fb8:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102fbb:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102fbd:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
    return 0;
80102fc3:	c3                   	ret    
80102fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102fc8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102fcb:	8d 50 20             	lea    0x20(%eax),%edx
}
80102fce:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102fcf:	83 f9 1a             	cmp    $0x1a,%ecx
80102fd2:	0f 42 c2             	cmovb  %edx,%eax
}
80102fd5:	5d                   	pop    %ebp
80102fd6:	c3                   	ret    
80102fd7:	89 f6                	mov    %esi,%esi
80102fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102fe5:	c3                   	ret    
80102fe6:	8d 76 00             	lea    0x0(%esi),%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ff0 <kbdintr>:

void
kbdintr(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102ff6:	68 10 2f 10 80       	push   $0x80102f10
80102ffb:	e8 10 d8 ff ff       	call   80100810 <consoleintr>
}
80103000:	83 c4 10             	add    $0x10,%esp
80103003:	c9                   	leave  
80103004:	c3                   	ret    
80103005:	66 90                	xchg   %ax,%ax
80103007:	66 90                	xchg   %ax,%ax
80103009:	66 90                	xchg   %ax,%ax
8010300b:	66 90                	xchg   %ax,%ax
8010300d:	66 90                	xchg   %ax,%ax
8010300f:	90                   	nop

80103010 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80103010:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
{
80103015:	55                   	push   %ebp
80103016:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80103018:	85 c0                	test   %eax,%eax
8010301a:	0f 84 c8 00 00 00    	je     801030e8 <lapicinit+0xd8>
  lapic[index] = value;
80103020:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103027:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010302a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010302d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103034:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103037:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010303a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103041:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103044:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103047:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010304e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103051:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103054:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010305b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010305e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103061:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103068:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010306b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010306e:	8b 50 30             	mov    0x30(%eax),%edx
80103071:	c1 ea 10             	shr    $0x10,%edx
80103074:	80 fa 03             	cmp    $0x3,%dl
80103077:	77 77                	ja     801030f0 <lapicinit+0xe0>
  lapic[index] = value;
80103079:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103080:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103083:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103086:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010308d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103090:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103093:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010309a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010309d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030a0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801030a7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030aa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ad:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801030b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801030ba:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801030c1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801030c4:	8b 50 20             	mov    0x20(%eax),%edx
801030c7:	89 f6                	mov    %esi,%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801030d0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801030d6:	80 e6 10             	and    $0x10,%dh
801030d9:	75 f5                	jne    801030d0 <lapicinit+0xc0>
  lapic[index] = value;
801030db:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801030e2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030e5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801030e8:	5d                   	pop    %ebp
801030e9:	c3                   	ret    
801030ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801030f0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801030f7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030fa:	8b 50 20             	mov    0x20(%eax),%edx
801030fd:	e9 77 ff ff ff       	jmp    80103079 <lapicinit+0x69>
80103102:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103110 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80103110:	8b 15 7c 5a 18 80    	mov    0x80185a7c,%edx
{
80103116:	55                   	push   %ebp
80103117:	31 c0                	xor    %eax,%eax
80103119:	89 e5                	mov    %esp,%ebp
  if (!lapic)
8010311b:	85 d2                	test   %edx,%edx
8010311d:	74 06                	je     80103125 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
8010311f:	8b 42 20             	mov    0x20(%edx),%eax
80103122:	c1 e8 18             	shr    $0x18,%eax
}
80103125:	5d                   	pop    %ebp
80103126:	c3                   	ret    
80103127:	89 f6                	mov    %esi,%esi
80103129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103130 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80103130:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
{
80103135:	55                   	push   %ebp
80103136:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103138:	85 c0                	test   %eax,%eax
8010313a:	74 0d                	je     80103149 <lapiceoi+0x19>
  lapic[index] = value;
8010313c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103143:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103146:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103149:	5d                   	pop    %ebp
8010314a:	c3                   	ret    
8010314b:	90                   	nop
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103150 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
}
80103153:	5d                   	pop    %ebp
80103154:	c3                   	ret    
80103155:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103160 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103160:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103161:	b8 0f 00 00 00       	mov    $0xf,%eax
80103166:	ba 70 00 00 00       	mov    $0x70,%edx
8010316b:	89 e5                	mov    %esp,%ebp
8010316d:	53                   	push   %ebx
8010316e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103171:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103174:	ee                   	out    %al,(%dx)
80103175:	b8 0a 00 00 00       	mov    $0xa,%eax
8010317a:	ba 71 00 00 00       	mov    $0x71,%edx
8010317f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103180:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103182:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103185:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010318b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010318d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103190:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103193:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103195:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103198:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010319e:	a1 7c 5a 18 80       	mov    0x80185a7c,%eax
801031a3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031a9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031ac:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801031b3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031b6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031b9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801031c0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801031c3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031c6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031cc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031cf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031d5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801031d8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031e1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031e7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801031ea:	5b                   	pop    %ebx
801031eb:	5d                   	pop    %ebp
801031ec:	c3                   	ret    
801031ed:	8d 76 00             	lea    0x0(%esi),%esi

801031f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801031f0:	55                   	push   %ebp
801031f1:	b8 0b 00 00 00       	mov    $0xb,%eax
801031f6:	ba 70 00 00 00       	mov    $0x70,%edx
801031fb:	89 e5                	mov    %esp,%ebp
801031fd:	57                   	push   %edi
801031fe:	56                   	push   %esi
801031ff:	53                   	push   %ebx
80103200:	83 ec 4c             	sub    $0x4c,%esp
80103203:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103204:	ba 71 00 00 00       	mov    $0x71,%edx
80103209:	ec                   	in     (%dx),%al
8010320a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010320d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103212:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103215:	8d 76 00             	lea    0x0(%esi),%esi
80103218:	31 c0                	xor    %eax,%eax
8010321a:	89 da                	mov    %ebx,%edx
8010321c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010321d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103222:	89 ca                	mov    %ecx,%edx
80103224:	ec                   	in     (%dx),%al
80103225:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103228:	89 da                	mov    %ebx,%edx
8010322a:	b8 02 00 00 00       	mov    $0x2,%eax
8010322f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103230:	89 ca                	mov    %ecx,%edx
80103232:	ec                   	in     (%dx),%al
80103233:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103236:	89 da                	mov    %ebx,%edx
80103238:	b8 04 00 00 00       	mov    $0x4,%eax
8010323d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010323e:	89 ca                	mov    %ecx,%edx
80103240:	ec                   	in     (%dx),%al
80103241:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103244:	89 da                	mov    %ebx,%edx
80103246:	b8 07 00 00 00       	mov    $0x7,%eax
8010324b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010324c:	89 ca                	mov    %ecx,%edx
8010324e:	ec                   	in     (%dx),%al
8010324f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103252:	89 da                	mov    %ebx,%edx
80103254:	b8 08 00 00 00       	mov    $0x8,%eax
80103259:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010325a:	89 ca                	mov    %ecx,%edx
8010325c:	ec                   	in     (%dx),%al
8010325d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010325f:	89 da                	mov    %ebx,%edx
80103261:	b8 09 00 00 00       	mov    $0x9,%eax
80103266:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103267:	89 ca                	mov    %ecx,%edx
80103269:	ec                   	in     (%dx),%al
8010326a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010326c:	89 da                	mov    %ebx,%edx
8010326e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103273:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103274:	89 ca                	mov    %ecx,%edx
80103276:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103277:	84 c0                	test   %al,%al
80103279:	78 9d                	js     80103218 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010327b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010327f:	89 fa                	mov    %edi,%edx
80103281:	0f b6 fa             	movzbl %dl,%edi
80103284:	89 f2                	mov    %esi,%edx
80103286:	0f b6 f2             	movzbl %dl,%esi
80103289:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010328c:	89 da                	mov    %ebx,%edx
8010328e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103291:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103294:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103298:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010329b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010329f:	89 45 c0             	mov    %eax,-0x40(%ebp)
801032a2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801032a6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801032a9:	31 c0                	xor    %eax,%eax
801032ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ac:	89 ca                	mov    %ecx,%edx
801032ae:	ec                   	in     (%dx),%al
801032af:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b2:	89 da                	mov    %ebx,%edx
801032b4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801032b7:	b8 02 00 00 00       	mov    $0x2,%eax
801032bc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032bd:	89 ca                	mov    %ecx,%edx
801032bf:	ec                   	in     (%dx),%al
801032c0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032c3:	89 da                	mov    %ebx,%edx
801032c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801032c8:	b8 04 00 00 00       	mov    $0x4,%eax
801032cd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ce:	89 ca                	mov    %ecx,%edx
801032d0:	ec                   	in     (%dx),%al
801032d1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032d4:	89 da                	mov    %ebx,%edx
801032d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801032d9:	b8 07 00 00 00       	mov    $0x7,%eax
801032de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032df:	89 ca                	mov    %ecx,%edx
801032e1:	ec                   	in     (%dx),%al
801032e2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032e5:	89 da                	mov    %ebx,%edx
801032e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801032ea:	b8 08 00 00 00       	mov    $0x8,%eax
801032ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032f0:	89 ca                	mov    %ecx,%edx
801032f2:	ec                   	in     (%dx),%al
801032f3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032f6:	89 da                	mov    %ebx,%edx
801032f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801032fb:	b8 09 00 00 00       	mov    $0x9,%eax
80103300:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103301:	89 ca                	mov    %ecx,%edx
80103303:	ec                   	in     (%dx),%al
80103304:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103307:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010330a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010330d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103310:	6a 18                	push   $0x18
80103312:	50                   	push   %eax
80103313:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103316:	50                   	push   %eax
80103317:	e8 d4 1f 00 00       	call   801052f0 <memcmp>
8010331c:	83 c4 10             	add    $0x10,%esp
8010331f:	85 c0                	test   %eax,%eax
80103321:	0f 85 f1 fe ff ff    	jne    80103218 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103327:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010332b:	75 78                	jne    801033a5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010332d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103330:	89 c2                	mov    %eax,%edx
80103332:	83 e0 0f             	and    $0xf,%eax
80103335:	c1 ea 04             	shr    $0x4,%edx
80103338:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010333b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010333e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103341:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103344:	89 c2                	mov    %eax,%edx
80103346:	83 e0 0f             	and    $0xf,%eax
80103349:	c1 ea 04             	shr    $0x4,%edx
8010334c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010334f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103352:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103355:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103358:	89 c2                	mov    %eax,%edx
8010335a:	83 e0 0f             	and    $0xf,%eax
8010335d:	c1 ea 04             	shr    $0x4,%edx
80103360:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103363:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103366:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103369:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010336c:	89 c2                	mov    %eax,%edx
8010336e:	83 e0 0f             	and    $0xf,%eax
80103371:	c1 ea 04             	shr    $0x4,%edx
80103374:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103377:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010337a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010337d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103380:	89 c2                	mov    %eax,%edx
80103382:	83 e0 0f             	and    $0xf,%eax
80103385:	c1 ea 04             	shr    $0x4,%edx
80103388:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010338b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010338e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103391:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103394:	89 c2                	mov    %eax,%edx
80103396:	83 e0 0f             	and    $0xf,%eax
80103399:	c1 ea 04             	shr    $0x4,%edx
8010339c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010339f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801033a2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801033a5:	8b 75 08             	mov    0x8(%ebp),%esi
801033a8:	8b 45 b8             	mov    -0x48(%ebp),%eax
801033ab:	89 06                	mov    %eax,(%esi)
801033ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
801033b0:	89 46 04             	mov    %eax,0x4(%esi)
801033b3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801033b6:	89 46 08             	mov    %eax,0x8(%esi)
801033b9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801033bc:	89 46 0c             	mov    %eax,0xc(%esi)
801033bf:	8b 45 c8             	mov    -0x38(%ebp),%eax
801033c2:	89 46 10             	mov    %eax,0x10(%esi)
801033c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
801033c8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801033cb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801033d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033d5:	5b                   	pop    %ebx
801033d6:	5e                   	pop    %esi
801033d7:	5f                   	pop    %edi
801033d8:	5d                   	pop    %ebp
801033d9:	c3                   	ret    
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033e0:	8b 0d c8 5a 18 80    	mov    0x80185ac8,%ecx
801033e6:	85 c9                	test   %ecx,%ecx
801033e8:	0f 8e 8a 00 00 00    	jle    80103478 <install_trans+0x98>
{
801033ee:	55                   	push   %ebp
801033ef:	89 e5                	mov    %esp,%ebp
801033f1:	57                   	push   %edi
801033f2:	56                   	push   %esi
801033f3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801033f4:	31 db                	xor    %ebx,%ebx
{
801033f6:	83 ec 0c             	sub    $0xc,%esp
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103400:	a1 b4 5a 18 80       	mov    0x80185ab4,%eax
80103405:	83 ec 08             	sub    $0x8,%esp
80103408:	01 d8                	add    %ebx,%eax
8010340a:	83 c0 01             	add    $0x1,%eax
8010340d:	50                   	push   %eax
8010340e:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
80103414:	e8 b7 cc ff ff       	call   801000d0 <bread>
80103419:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010341b:	58                   	pop    %eax
8010341c:	5a                   	pop    %edx
8010341d:	ff 34 9d cc 5a 18 80 	pushl  -0x7fe7a534(,%ebx,4)
80103424:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
  for (tail = 0; tail < log.lh.n; tail++) {
8010342a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010342d:	e8 9e cc ff ff       	call   801000d0 <bread>
80103432:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103434:	8d 47 5c             	lea    0x5c(%edi),%eax
80103437:	83 c4 0c             	add    $0xc,%esp
8010343a:	68 00 02 00 00       	push   $0x200
8010343f:	50                   	push   %eax
80103440:	8d 46 5c             	lea    0x5c(%esi),%eax
80103443:	50                   	push   %eax
80103444:	e8 07 1f 00 00       	call   80105350 <memmove>
    bwrite(dbuf);  // write dst to disk
80103449:	89 34 24             	mov    %esi,(%esp)
8010344c:	e8 4f cd ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103451:	89 3c 24             	mov    %edi,(%esp)
80103454:	e8 87 cd ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103459:	89 34 24             	mov    %esi,(%esp)
8010345c:	e8 7f cd ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103461:	83 c4 10             	add    $0x10,%esp
80103464:	39 1d c8 5a 18 80    	cmp    %ebx,0x80185ac8
8010346a:	7f 94                	jg     80103400 <install_trans+0x20>
  }
}
8010346c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010346f:	5b                   	pop    %ebx
80103470:	5e                   	pop    %esi
80103471:	5f                   	pop    %edi
80103472:	5d                   	pop    %ebp
80103473:	c3                   	ret    
80103474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103478:	f3 c3                	repz ret 
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103480 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	56                   	push   %esi
80103484:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103485:	83 ec 08             	sub    $0x8,%esp
80103488:	ff 35 b4 5a 18 80    	pushl  0x80185ab4
8010348e:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
80103494:	e8 37 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103499:	8b 1d c8 5a 18 80    	mov    0x80185ac8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010349f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801034a2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
801034a4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
801034a6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801034a9:	7e 16                	jle    801034c1 <write_head+0x41>
801034ab:	c1 e3 02             	shl    $0x2,%ebx
801034ae:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
801034b0:	8b 8a cc 5a 18 80    	mov    -0x7fe7a534(%edx),%ecx
801034b6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
801034ba:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
801034bd:	39 da                	cmp    %ebx,%edx
801034bf:	75 ef                	jne    801034b0 <write_head+0x30>
  }
  bwrite(buf);
801034c1:	83 ec 0c             	sub    $0xc,%esp
801034c4:	56                   	push   %esi
801034c5:	e8 d6 cc ff ff       	call   801001a0 <bwrite>
  brelse(buf);
801034ca:	89 34 24             	mov    %esi,(%esp)
801034cd:	e8 0e cd ff ff       	call   801001e0 <brelse>
}
801034d2:	83 c4 10             	add    $0x10,%esp
801034d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034d8:	5b                   	pop    %ebx
801034d9:	5e                   	pop    %esi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    
801034dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034e0 <initlog>:
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	53                   	push   %ebx
801034e4:	83 ec 2c             	sub    $0x2c,%esp
801034e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801034ea:	68 e0 95 10 80       	push   $0x801095e0
801034ef:	68 80 5a 18 80       	push   $0x80185a80
801034f4:	e8 57 1b 00 00       	call   80105050 <initlock>
  readsb(dev, &sb);
801034f9:	58                   	pop    %eax
801034fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034fd:	5a                   	pop    %edx
801034fe:	50                   	push   %eax
801034ff:	53                   	push   %ebx
80103500:	e8 db e2 ff ff       	call   801017e0 <readsb>
  log.size = sb.nlog;
80103505:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103508:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010350b:	59                   	pop    %ecx
  log.dev = dev;
8010350c:	89 1d c4 5a 18 80    	mov    %ebx,0x80185ac4
  log.size = sb.nlog;
80103512:	89 15 b8 5a 18 80    	mov    %edx,0x80185ab8
  log.start = sb.logstart;
80103518:	a3 b4 5a 18 80       	mov    %eax,0x80185ab4
  struct buf *buf = bread(log.dev, log.start);
8010351d:	5a                   	pop    %edx
8010351e:	50                   	push   %eax
8010351f:	53                   	push   %ebx
80103520:	e8 ab cb ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103525:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010352d:	89 1d c8 5a 18 80    	mov    %ebx,0x80185ac8
  for (i = 0; i < log.lh.n; i++) {
80103533:	7e 1c                	jle    80103551 <initlog+0x71>
80103535:	c1 e3 02             	shl    $0x2,%ebx
80103538:	31 d2                	xor    %edx,%edx
8010353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103540:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103544:	83 c2 04             	add    $0x4,%edx
80103547:	89 8a c8 5a 18 80    	mov    %ecx,-0x7fe7a538(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010354d:	39 d3                	cmp    %edx,%ebx
8010354f:	75 ef                	jne    80103540 <initlog+0x60>
  brelse(buf);
80103551:	83 ec 0c             	sub    $0xc,%esp
80103554:	50                   	push   %eax
80103555:	e8 86 cc ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010355a:	e8 81 fe ff ff       	call   801033e0 <install_trans>
  log.lh.n = 0;
8010355f:	c7 05 c8 5a 18 80 00 	movl   $0x0,0x80185ac8
80103566:	00 00 00 
  write_head(); // clear the log
80103569:	e8 12 ff ff ff       	call   80103480 <write_head>
}
8010356e:	83 c4 10             	add    $0x10,%esp
80103571:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103574:	c9                   	leave  
80103575:	c3                   	ret    
80103576:	8d 76 00             	lea    0x0(%esi),%esi
80103579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103580 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103586:	68 80 5a 18 80       	push   $0x80185a80
8010358b:	e8 00 1c 00 00       	call   80105190 <acquire>
80103590:	83 c4 10             	add    $0x10,%esp
80103593:	eb 18                	jmp    801035ad <begin_op+0x2d>
80103595:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103598:	83 ec 08             	sub    $0x8,%esp
8010359b:	68 80 5a 18 80       	push   $0x80185a80
801035a0:	68 80 5a 18 80       	push   $0x80185a80
801035a5:	e8 36 15 00 00       	call   80104ae0 <sleep>
801035aa:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801035ad:	a1 c0 5a 18 80       	mov    0x80185ac0,%eax
801035b2:	85 c0                	test   %eax,%eax
801035b4:	75 e2                	jne    80103598 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035b6:	a1 bc 5a 18 80       	mov    0x80185abc,%eax
801035bb:	8b 15 c8 5a 18 80    	mov    0x80185ac8,%edx
801035c1:	83 c0 01             	add    $0x1,%eax
801035c4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801035c7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801035ca:	83 fa 1e             	cmp    $0x1e,%edx
801035cd:	7f c9                	jg     80103598 <begin_op+0x18>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
801035cf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
801035d2:	a3 bc 5a 18 80       	mov    %eax,0x80185abc
      release(&log.lock);
801035d7:	68 80 5a 18 80       	push   $0x80185a80
801035dc:	e8 6f 1c 00 00       	call   80105250 <release>
      break;
    }
  }
}
801035e1:	83 c4 10             	add    $0x10,%esp
801035e4:	c9                   	leave  
801035e5:	c3                   	ret    
801035e6:	8d 76 00             	lea    0x0(%esi),%esi
801035e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035f0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801035f9:	68 80 5a 18 80       	push   $0x80185a80
801035fe:	e8 8d 1b 00 00       	call   80105190 <acquire>
  log.outstanding -= 1;
80103603:	a1 bc 5a 18 80       	mov    0x80185abc,%eax
  if(log.committing)
80103608:	8b 35 c0 5a 18 80    	mov    0x80185ac0,%esi
8010360e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103611:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103614:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103616:	89 1d bc 5a 18 80    	mov    %ebx,0x80185abc
  if(log.committing)
8010361c:	0f 85 1a 01 00 00    	jne    8010373c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103622:	85 db                	test   %ebx,%ebx
80103624:	0f 85 ee 00 00 00    	jne    80103718 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010362a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010362d:	c7 05 c0 5a 18 80 01 	movl   $0x1,0x80185ac0
80103634:	00 00 00 
  release(&log.lock);
80103637:	68 80 5a 18 80       	push   $0x80185a80
8010363c:	e8 0f 1c 00 00       	call   80105250 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103641:	8b 0d c8 5a 18 80    	mov    0x80185ac8,%ecx
80103647:	83 c4 10             	add    $0x10,%esp
8010364a:	85 c9                	test   %ecx,%ecx
8010364c:	0f 8e 85 00 00 00    	jle    801036d7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103652:	a1 b4 5a 18 80       	mov    0x80185ab4,%eax
80103657:	83 ec 08             	sub    $0x8,%esp
8010365a:	01 d8                	add    %ebx,%eax
8010365c:	83 c0 01             	add    $0x1,%eax
8010365f:	50                   	push   %eax
80103660:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
80103666:	e8 65 ca ff ff       	call   801000d0 <bread>
8010366b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010366d:	58                   	pop    %eax
8010366e:	5a                   	pop    %edx
8010366f:	ff 34 9d cc 5a 18 80 	pushl  -0x7fe7a534(,%ebx,4)
80103676:	ff 35 c4 5a 18 80    	pushl  0x80185ac4
  for (tail = 0; tail < log.lh.n; tail++) {
8010367c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010367f:	e8 4c ca ff ff       	call   801000d0 <bread>
80103684:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103686:	8d 40 5c             	lea    0x5c(%eax),%eax
80103689:	83 c4 0c             	add    $0xc,%esp
8010368c:	68 00 02 00 00       	push   $0x200
80103691:	50                   	push   %eax
80103692:	8d 46 5c             	lea    0x5c(%esi),%eax
80103695:	50                   	push   %eax
80103696:	e8 b5 1c 00 00       	call   80105350 <memmove>
    bwrite(to);  // write the log
8010369b:	89 34 24             	mov    %esi,(%esp)
8010369e:	e8 fd ca ff ff       	call   801001a0 <bwrite>
    brelse(from);
801036a3:	89 3c 24             	mov    %edi,(%esp)
801036a6:	e8 35 cb ff ff       	call   801001e0 <brelse>
    brelse(to);
801036ab:	89 34 24             	mov    %esi,(%esp)
801036ae:	e8 2d cb ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801036b3:	83 c4 10             	add    $0x10,%esp
801036b6:	3b 1d c8 5a 18 80    	cmp    0x80185ac8,%ebx
801036bc:	7c 94                	jl     80103652 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801036be:	e8 bd fd ff ff       	call   80103480 <write_head>
    install_trans(); // Now install writes to home locations
801036c3:	e8 18 fd ff ff       	call   801033e0 <install_trans>
    log.lh.n = 0;
801036c8:	c7 05 c8 5a 18 80 00 	movl   $0x0,0x80185ac8
801036cf:	00 00 00 
    write_head();    // Erase the transaction from the log
801036d2:	e8 a9 fd ff ff       	call   80103480 <write_head>
    acquire(&log.lock);
801036d7:	83 ec 0c             	sub    $0xc,%esp
801036da:	68 80 5a 18 80       	push   $0x80185a80
801036df:	e8 ac 1a 00 00       	call   80105190 <acquire>
    wakeup(&log);
801036e4:	c7 04 24 80 5a 18 80 	movl   $0x80185a80,(%esp)
    log.committing = 0;
801036eb:	c7 05 c0 5a 18 80 00 	movl   $0x0,0x80185ac0
801036f2:	00 00 00 
    wakeup(&log);
801036f5:	e8 16 16 00 00       	call   80104d10 <wakeup>
    release(&log.lock);
801036fa:	c7 04 24 80 5a 18 80 	movl   $0x80185a80,(%esp)
80103701:	e8 4a 1b 00 00       	call   80105250 <release>
80103706:	83 c4 10             	add    $0x10,%esp
}
80103709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010370c:	5b                   	pop    %ebx
8010370d:	5e                   	pop    %esi
8010370e:	5f                   	pop    %edi
8010370f:	5d                   	pop    %ebp
80103710:	c3                   	ret    
80103711:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	68 80 5a 18 80       	push   $0x80185a80
80103720:	e8 eb 15 00 00       	call   80104d10 <wakeup>
  release(&log.lock);
80103725:	c7 04 24 80 5a 18 80 	movl   $0x80185a80,(%esp)
8010372c:	e8 1f 1b 00 00       	call   80105250 <release>
80103731:	83 c4 10             	add    $0x10,%esp
}
80103734:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103737:	5b                   	pop    %ebx
80103738:	5e                   	pop    %esi
80103739:	5f                   	pop    %edi
8010373a:	5d                   	pop    %ebp
8010373b:	c3                   	ret    
    panic("log.committing");
8010373c:	83 ec 0c             	sub    $0xc,%esp
8010373f:	68 e4 95 10 80       	push   $0x801095e4
80103744:	e8 47 cc ff ff       	call   80100390 <panic>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103750 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103757:	8b 15 c8 5a 18 80    	mov    0x80185ac8,%edx
{
8010375d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103760:	83 fa 1d             	cmp    $0x1d,%edx
80103763:	0f 8f 9d 00 00 00    	jg     80103806 <log_write+0xb6>
80103769:	a1 b8 5a 18 80       	mov    0x80185ab8,%eax
8010376e:	83 e8 01             	sub    $0x1,%eax
80103771:	39 c2                	cmp    %eax,%edx
80103773:	0f 8d 8d 00 00 00    	jge    80103806 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103779:	a1 bc 5a 18 80       	mov    0x80185abc,%eax
8010377e:	85 c0                	test   %eax,%eax
80103780:	0f 8e 8d 00 00 00    	jle    80103813 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103786:	83 ec 0c             	sub    $0xc,%esp
80103789:	68 80 5a 18 80       	push   $0x80185a80
8010378e:	e8 fd 19 00 00       	call   80105190 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103793:	8b 0d c8 5a 18 80    	mov    0x80185ac8,%ecx
80103799:	83 c4 10             	add    $0x10,%esp
8010379c:	83 f9 00             	cmp    $0x0,%ecx
8010379f:	7e 57                	jle    801037f8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037a1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801037a4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801037a6:	3b 15 cc 5a 18 80    	cmp    0x80185acc,%edx
801037ac:	75 0b                	jne    801037b9 <log_write+0x69>
801037ae:	eb 38                	jmp    801037e8 <log_write+0x98>
801037b0:	39 14 85 cc 5a 18 80 	cmp    %edx,-0x7fe7a534(,%eax,4)
801037b7:	74 2f                	je     801037e8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801037b9:	83 c0 01             	add    $0x1,%eax
801037bc:	39 c1                	cmp    %eax,%ecx
801037be:	75 f0                	jne    801037b0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801037c0:	89 14 85 cc 5a 18 80 	mov    %edx,-0x7fe7a534(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801037c7:	83 c0 01             	add    $0x1,%eax
801037ca:	a3 c8 5a 18 80       	mov    %eax,0x80185ac8
  b->flags |= B_DIRTY; // prevent eviction
801037cf:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801037d2:	c7 45 08 80 5a 18 80 	movl   $0x80185a80,0x8(%ebp)
}
801037d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037dc:	c9                   	leave  
  release(&log.lock);
801037dd:	e9 6e 1a 00 00       	jmp    80105250 <release>
801037e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801037e8:	89 14 85 cc 5a 18 80 	mov    %edx,-0x7fe7a534(,%eax,4)
801037ef:	eb de                	jmp    801037cf <log_write+0x7f>
801037f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037f8:	8b 43 08             	mov    0x8(%ebx),%eax
801037fb:	a3 cc 5a 18 80       	mov    %eax,0x80185acc
  if (i == log.lh.n)
80103800:	75 cd                	jne    801037cf <log_write+0x7f>
80103802:	31 c0                	xor    %eax,%eax
80103804:	eb c1                	jmp    801037c7 <log_write+0x77>
    panic("too big a transaction");
80103806:	83 ec 0c             	sub    $0xc,%esp
80103809:	68 f3 95 10 80       	push   $0x801095f3
8010380e:	e8 7d cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103813:	83 ec 0c             	sub    $0xc,%esp
80103816:	68 09 96 10 80       	push   $0x80109609
8010381b:	e8 70 cb ff ff       	call   80100390 <panic>

80103820 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	53                   	push   %ebx
80103824:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103827:	e8 b4 0a 00 00       	call   801042e0 <cpuid>
8010382c:	89 c3                	mov    %eax,%ebx
8010382e:	e8 ad 0a 00 00       	call   801042e0 <cpuid>
80103833:	83 ec 04             	sub    $0x4,%esp
80103836:	53                   	push   %ebx
80103837:	50                   	push   %eax
80103838:	68 24 96 10 80       	push   $0x80109624
8010383d:	e8 1e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103842:	e8 69 2d 00 00       	call   801065b0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103847:	e8 14 0a 00 00       	call   80104260 <mycpu>
8010384c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010384e:	b8 01 00 00 00       	mov    $0x1,%eax
80103853:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010385a:	e8 71 0f 00 00       	call   801047d0 <scheduler>
8010385f:	90                   	nop

80103860 <mpenter>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103866:	e8 05 3f 00 00       	call   80107770 <switchkvm>
  seginit();
8010386b:	e8 70 3e 00 00       	call   801076e0 <seginit>
  lapicinit();
80103870:	e8 9b f7 ff ff       	call   80103010 <lapicinit>
  mpmain();
80103875:	e8 a6 ff ff ff       	call   80103820 <mpmain>
8010387a:	66 90                	xchg   %ax,%ax
8010387c:	66 90                	xchg   %ax,%ax
8010387e:	66 90                	xchg   %ax,%ax

80103880 <main>:
{
80103880:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103884:	83 e4 f0             	and    $0xfffffff0,%esp
80103887:	ff 71 fc             	pushl  -0x4(%ecx)
8010388a:	55                   	push   %ebp
8010388b:	89 e5                	mov    %esp,%ebp
8010388d:	53                   	push   %ebx
8010388e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010388f:	83 ec 08             	sub    $0x8,%esp
80103892:	68 00 00 40 80       	push   $0x80400000
80103897:	68 a8 75 19 80       	push   $0x801975a8
8010389c:	e8 cf f3 ff ff       	call   80102c70 <kinit1>
  kvmalloc();      // kernel page table
801038a1:	e8 8a 45 00 00       	call   80107e30 <kvmalloc>
  mpinit();        // detect other processors
801038a6:	e8 85 01 00 00       	call   80103a30 <mpinit>
  lapicinit();     // interrupt controller
801038ab:	e8 60 f7 ff ff       	call   80103010 <lapicinit>
  seginit();       // segment descriptors
801038b0:	e8 2b 3e 00 00       	call   801076e0 <seginit>
  picinit();       // disable pic
801038b5:	e8 56 03 00 00       	call   80103c10 <picinit>
  ioapicinit();    // another interrupt controller
801038ba:	e8 b1 f0 ff ff       	call   80102970 <ioapicinit>
  consoleinit();   // console hardware
801038bf:	e8 fc d0 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801038c4:	e8 47 30 00 00       	call   80106910 <uartinit>
  pinit();         // process table
801038c9:	e8 72 09 00 00       	call   80104240 <pinit>
  tvinit();        // trap vectors
801038ce:	e8 5d 2c 00 00       	call   80106530 <tvinit>
  binit();         // buffer cache
801038d3:	e8 68 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
801038d8:	e8 23 d8 ff ff       	call   80101100 <fileinit>
  ideinit();       // disk 
801038dd:	e8 6e ee ff ff       	call   80102750 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038e2:	83 c4 0c             	add    $0xc,%esp
801038e5:	68 8a 00 00 00       	push   $0x8a
801038ea:	68 8c c4 10 80       	push   $0x8010c48c
801038ef:	68 00 70 00 80       	push   $0x80007000
801038f4:	e8 57 1a 00 00       	call   80105350 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038f9:	69 05 00 61 18 80 b0 	imul   $0xb0,0x80186100,%eax
80103900:	00 00 00 
80103903:	83 c4 10             	add    $0x10,%esp
80103906:	05 80 5b 18 80       	add    $0x80185b80,%eax
8010390b:	3d 80 5b 18 80       	cmp    $0x80185b80,%eax
80103910:	76 71                	jbe    80103983 <main+0x103>
80103912:	bb 80 5b 18 80       	mov    $0x80185b80,%ebx
80103917:	89 f6                	mov    %esi,%esi
80103919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103920:	e8 3b 09 00 00       	call   80104260 <mycpu>
80103925:	39 d8                	cmp    %ebx,%eax
80103927:	74 41                	je     8010396a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103929:	e8 12 f4 ff ff       	call   80102d40 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010392e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103933:	c7 05 f8 6f 00 80 60 	movl   $0x80103860,0x80006ff8
8010393a:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010393d:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103944:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103947:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010394c:	0f b6 03             	movzbl (%ebx),%eax
8010394f:	83 ec 08             	sub    $0x8,%esp
80103952:	68 00 70 00 00       	push   $0x7000
80103957:	50                   	push   %eax
80103958:	e8 03 f8 ff ff       	call   80103160 <lapicstartap>
8010395d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103960:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103966:	85 c0                	test   %eax,%eax
80103968:	74 f6                	je     80103960 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010396a:	69 05 00 61 18 80 b0 	imul   $0xb0,0x80186100,%eax
80103971:	00 00 00 
80103974:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010397a:	05 80 5b 18 80       	add    $0x80185b80,%eax
8010397f:	39 c3                	cmp    %eax,%ebx
80103981:	72 9d                	jb     80103920 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103983:	83 ec 08             	sub    $0x8,%esp
80103986:	68 00 00 00 8e       	push   $0x8e000000
8010398b:	68 00 00 40 80       	push   $0x80400000
80103990:	e8 4b f3 ff ff       	call   80102ce0 <kinit2>
  userinit();      // first user process
80103995:	e8 96 09 00 00       	call   80104330 <userinit>
  initialNumOfFreePages = getNumberOfFreePages();
8010399a:	e8 61 15 00 00       	call   80104f00 <getNumberOfFreePages>
8010399f:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  mpmain();        // finish this processor's setup
801039a4:	e8 77 fe ff ff       	call   80103820 <mpmain>
801039a9:	66 90                	xchg   %ax,%ax
801039ab:	66 90                	xchg   %ax,%ax
801039ad:	66 90                	xchg   %ax,%ax
801039af:	90                   	nop

801039b0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	57                   	push   %edi
801039b4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801039b5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801039bb:	53                   	push   %ebx
  e = addr+len;
801039bc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801039bf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801039c2:	39 de                	cmp    %ebx,%esi
801039c4:	72 10                	jb     801039d6 <mpsearch1+0x26>
801039c6:	eb 50                	jmp    80103a18 <mpsearch1+0x68>
801039c8:	90                   	nop
801039c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039d0:	39 fb                	cmp    %edi,%ebx
801039d2:	89 fe                	mov    %edi,%esi
801039d4:	76 42                	jbe    80103a18 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039d6:	83 ec 04             	sub    $0x4,%esp
801039d9:	8d 7e 10             	lea    0x10(%esi),%edi
801039dc:	6a 04                	push   $0x4
801039de:	68 38 96 10 80       	push   $0x80109638
801039e3:	56                   	push   %esi
801039e4:	e8 07 19 00 00       	call   801052f0 <memcmp>
801039e9:	83 c4 10             	add    $0x10,%esp
801039ec:	85 c0                	test   %eax,%eax
801039ee:	75 e0                	jne    801039d0 <mpsearch1+0x20>
801039f0:	89 f1                	mov    %esi,%ecx
801039f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801039f8:	0f b6 11             	movzbl (%ecx),%edx
801039fb:	83 c1 01             	add    $0x1,%ecx
801039fe:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103a00:	39 f9                	cmp    %edi,%ecx
80103a02:	75 f4                	jne    801039f8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a04:	84 c0                	test   %al,%al
80103a06:	75 c8                	jne    801039d0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a0b:	89 f0                	mov    %esi,%eax
80103a0d:	5b                   	pop    %ebx
80103a0e:	5e                   	pop    %esi
80103a0f:	5f                   	pop    %edi
80103a10:	5d                   	pop    %ebp
80103a11:	c3                   	ret    
80103a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103a1b:	31 f6                	xor    %esi,%esi
}
80103a1d:	89 f0                	mov    %esi,%eax
80103a1f:	5b                   	pop    %ebx
80103a20:	5e                   	pop    %esi
80103a21:	5f                   	pop    %edi
80103a22:	5d                   	pop    %ebp
80103a23:	c3                   	ret    
80103a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103a30 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a39:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103a40:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103a47:	c1 e0 08             	shl    $0x8,%eax
80103a4a:	09 d0                	or     %edx,%eax
80103a4c:	c1 e0 04             	shl    $0x4,%eax
80103a4f:	85 c0                	test   %eax,%eax
80103a51:	75 1b                	jne    80103a6e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a53:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a5a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a61:	c1 e0 08             	shl    $0x8,%eax
80103a64:	09 d0                	or     %edx,%eax
80103a66:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a69:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a6e:	ba 00 04 00 00       	mov    $0x400,%edx
80103a73:	e8 38 ff ff ff       	call   801039b0 <mpsearch1>
80103a78:	85 c0                	test   %eax,%eax
80103a7a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a7d:	0f 84 3d 01 00 00    	je     80103bc0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a86:	8b 58 04             	mov    0x4(%eax),%ebx
80103a89:	85 db                	test   %ebx,%ebx
80103a8b:	0f 84 4f 01 00 00    	je     80103be0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a91:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103a97:	83 ec 04             	sub    $0x4,%esp
80103a9a:	6a 04                	push   $0x4
80103a9c:	68 55 96 10 80       	push   $0x80109655
80103aa1:	56                   	push   %esi
80103aa2:	e8 49 18 00 00       	call   801052f0 <memcmp>
80103aa7:	83 c4 10             	add    $0x10,%esp
80103aaa:	85 c0                	test   %eax,%eax
80103aac:	0f 85 2e 01 00 00    	jne    80103be0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103ab2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103ab9:	3c 01                	cmp    $0x1,%al
80103abb:	0f 95 c2             	setne  %dl
80103abe:	3c 04                	cmp    $0x4,%al
80103ac0:	0f 95 c0             	setne  %al
80103ac3:	20 c2                	and    %al,%dl
80103ac5:	0f 85 15 01 00 00    	jne    80103be0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103acb:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103ad2:	66 85 ff             	test   %di,%di
80103ad5:	74 1a                	je     80103af1 <mpinit+0xc1>
80103ad7:	89 f0                	mov    %esi,%eax
80103ad9:	01 f7                	add    %esi,%edi
  sum = 0;
80103adb:	31 d2                	xor    %edx,%edx
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103ae0:	0f b6 08             	movzbl (%eax),%ecx
80103ae3:	83 c0 01             	add    $0x1,%eax
80103ae6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103ae8:	39 c7                	cmp    %eax,%edi
80103aea:	75 f4                	jne    80103ae0 <mpinit+0xb0>
80103aec:	84 d2                	test   %dl,%dl
80103aee:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103af1:	85 f6                	test   %esi,%esi
80103af3:	0f 84 e7 00 00 00    	je     80103be0 <mpinit+0x1b0>
80103af9:	84 d2                	test   %dl,%dl
80103afb:	0f 85 df 00 00 00    	jne    80103be0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103b01:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103b07:	a3 7c 5a 18 80       	mov    %eax,0x80185a7c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b0c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103b13:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103b19:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b1e:	01 d6                	add    %edx,%esi
80103b20:	39 c6                	cmp    %eax,%esi
80103b22:	76 23                	jbe    80103b47 <mpinit+0x117>
    switch(*p){
80103b24:	0f b6 10             	movzbl (%eax),%edx
80103b27:	80 fa 04             	cmp    $0x4,%dl
80103b2a:	0f 87 ca 00 00 00    	ja     80103bfa <mpinit+0x1ca>
80103b30:	ff 24 95 7c 96 10 80 	jmp    *-0x7fef6984(,%edx,4)
80103b37:	89 f6                	mov    %esi,%esi
80103b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103b40:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b43:	39 c6                	cmp    %eax,%esi
80103b45:	77 dd                	ja     80103b24 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103b47:	85 db                	test   %ebx,%ebx
80103b49:	0f 84 9e 00 00 00    	je     80103bed <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103b4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b52:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103b56:	74 15                	je     80103b6d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b58:	b8 70 00 00 00       	mov    $0x70,%eax
80103b5d:	ba 22 00 00 00       	mov    $0x22,%edx
80103b62:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b63:	ba 23 00 00 00       	mov    $0x23,%edx
80103b68:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b69:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b6c:	ee                   	out    %al,(%dx)
  }
}
80103b6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b70:	5b                   	pop    %ebx
80103b71:	5e                   	pop    %esi
80103b72:	5f                   	pop    %edi
80103b73:	5d                   	pop    %ebp
80103b74:	c3                   	ret    
80103b75:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103b78:	8b 0d 00 61 18 80    	mov    0x80186100,%ecx
80103b7e:	83 f9 07             	cmp    $0x7,%ecx
80103b81:	7f 19                	jg     80103b9c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b83:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103b87:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103b8d:	83 c1 01             	add    $0x1,%ecx
80103b90:	89 0d 00 61 18 80    	mov    %ecx,0x80186100
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b96:	88 97 80 5b 18 80    	mov    %dl,-0x7fe7a480(%edi)
      p += sizeof(struct mpproc);
80103b9c:	83 c0 14             	add    $0x14,%eax
      continue;
80103b9f:	e9 7c ff ff ff       	jmp    80103b20 <mpinit+0xf0>
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103ba8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103bac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103baf:	88 15 60 5b 18 80    	mov    %dl,0x80185b60
      continue;
80103bb5:	e9 66 ff ff ff       	jmp    80103b20 <mpinit+0xf0>
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103bc0:	ba 00 00 01 00       	mov    $0x10000,%edx
80103bc5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103bca:	e8 e1 fd ff ff       	call   801039b0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bcf:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103bd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103bd4:	0f 85 a9 fe ff ff    	jne    80103a83 <mpinit+0x53>
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103be0:	83 ec 0c             	sub    $0xc,%esp
80103be3:	68 3d 96 10 80       	push   $0x8010963d
80103be8:	e8 a3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bed:	83 ec 0c             	sub    $0xc,%esp
80103bf0:	68 5c 96 10 80       	push   $0x8010965c
80103bf5:	e8 96 c7 ff ff       	call   80100390 <panic>
      ismp = 0;
80103bfa:	31 db                	xor    %ebx,%ebx
80103bfc:	e9 26 ff ff ff       	jmp    80103b27 <mpinit+0xf7>
80103c01:	66 90                	xchg   %ax,%ax
80103c03:	66 90                	xchg   %ax,%ax
80103c05:	66 90                	xchg   %ax,%ax
80103c07:	66 90                	xchg   %ax,%ax
80103c09:	66 90                	xchg   %ax,%ax
80103c0b:	66 90                	xchg   %ax,%ax
80103c0d:	66 90                	xchg   %ax,%ax
80103c0f:	90                   	nop

80103c10 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103c10:	55                   	push   %ebp
80103c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c16:	ba 21 00 00 00       	mov    $0x21,%edx
80103c1b:	89 e5                	mov    %esp,%ebp
80103c1d:	ee                   	out    %al,(%dx)
80103c1e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103c23:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103c24:	5d                   	pop    %ebp
80103c25:	c3                   	ret    
80103c26:	66 90                	xchg   %ax,%ax
80103c28:	66 90                	xchg   %ax,%ax
80103c2a:	66 90                	xchg   %ax,%ax
80103c2c:	66 90                	xchg   %ax,%ax
80103c2e:	66 90                	xchg   %ax,%ax

80103c30 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 0c             	sub    $0xc,%esp
80103c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103c3f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103c45:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c4b:	e8 d0 d4 ff ff       	call   80101120 <filealloc>
80103c50:	85 c0                	test   %eax,%eax
80103c52:	89 03                	mov    %eax,(%ebx)
80103c54:	74 22                	je     80103c78 <pipealloc+0x48>
80103c56:	e8 c5 d4 ff ff       	call   80101120 <filealloc>
80103c5b:	85 c0                	test   %eax,%eax
80103c5d:	89 06                	mov    %eax,(%esi)
80103c5f:	74 3f                	je     80103ca0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c61:	e8 da f0 ff ff       	call   80102d40 <kalloc>
80103c66:	85 c0                	test   %eax,%eax
80103c68:	89 c7                	mov    %eax,%edi
80103c6a:	75 54                	jne    80103cc0 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103c6c:	8b 03                	mov    (%ebx),%eax
80103c6e:	85 c0                	test   %eax,%eax
80103c70:	75 34                	jne    80103ca6 <pipealloc+0x76>
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103c78:	8b 06                	mov    (%esi),%eax
80103c7a:	85 c0                	test   %eax,%eax
80103c7c:	74 0c                	je     80103c8a <pipealloc+0x5a>
    fileclose(*f1);
80103c7e:	83 ec 0c             	sub    $0xc,%esp
80103c81:	50                   	push   %eax
80103c82:	e8 59 d5 ff ff       	call   801011e0 <fileclose>
80103c87:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103c8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c92:	5b                   	pop    %ebx
80103c93:	5e                   	pop    %esi
80103c94:	5f                   	pop    %edi
80103c95:	5d                   	pop    %ebp
80103c96:	c3                   	ret    
80103c97:	89 f6                	mov    %esi,%esi
80103c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103ca0:	8b 03                	mov    (%ebx),%eax
80103ca2:	85 c0                	test   %eax,%eax
80103ca4:	74 e4                	je     80103c8a <pipealloc+0x5a>
    fileclose(*f0);
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	50                   	push   %eax
80103caa:	e8 31 d5 ff ff       	call   801011e0 <fileclose>
  if(*f1)
80103caf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103cb1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103cb4:	85 c0                	test   %eax,%eax
80103cb6:	75 c6                	jne    80103c7e <pipealloc+0x4e>
80103cb8:	eb d0                	jmp    80103c8a <pipealloc+0x5a>
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103cc0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103cc3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103cca:	00 00 00 
  p->writeopen = 1;
80103ccd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103cd4:	00 00 00 
  p->nwrite = 0;
80103cd7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cde:	00 00 00 
  p->nread = 0;
80103ce1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103ce8:	00 00 00 
  initlock(&p->lock, "pipe");
80103ceb:	68 90 96 10 80       	push   $0x80109690
80103cf0:	50                   	push   %eax
80103cf1:	e8 5a 13 00 00       	call   80105050 <initlock>
  (*f0)->type = FD_PIPE;
80103cf6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103cf8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cfb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d01:	8b 03                	mov    (%ebx),%eax
80103d03:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103d07:	8b 03                	mov    (%ebx),%eax
80103d09:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103d0d:	8b 03                	mov    (%ebx),%eax
80103d0f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d12:	8b 06                	mov    (%esi),%eax
80103d14:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d1a:	8b 06                	mov    (%esi),%eax
80103d1c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d20:	8b 06                	mov    (%esi),%eax
80103d22:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d26:	8b 06                	mov    (%esi),%eax
80103d28:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103d2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103d2e:	31 c0                	xor    %eax,%eax
}
80103d30:	5b                   	pop    %ebx
80103d31:	5e                   	pop    %esi
80103d32:	5f                   	pop    %edi
80103d33:	5d                   	pop    %ebp
80103d34:	c3                   	ret    
80103d35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d40 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
80103d45:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d48:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103d4b:	83 ec 0c             	sub    $0xc,%esp
80103d4e:	53                   	push   %ebx
80103d4f:	e8 3c 14 00 00       	call   80105190 <acquire>
  if(writable){
80103d54:	83 c4 10             	add    $0x10,%esp
80103d57:	85 f6                	test   %esi,%esi
80103d59:	74 45                	je     80103da0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d5b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d61:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103d64:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d6b:	00 00 00 
    wakeup(&p->nread);
80103d6e:	50                   	push   %eax
80103d6f:	e8 9c 0f 00 00       	call   80104d10 <wakeup>
80103d74:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d77:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d7d:	85 d2                	test   %edx,%edx
80103d7f:	75 0a                	jne    80103d8b <pipeclose+0x4b>
80103d81:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d87:	85 c0                	test   %eax,%eax
80103d89:	74 35                	je     80103dc0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103d8b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d8e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d91:	5b                   	pop    %ebx
80103d92:	5e                   	pop    %esi
80103d93:	5d                   	pop    %ebp
    release(&p->lock);
80103d94:	e9 b7 14 00 00       	jmp    80105250 <release>
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103da0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103da6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103da9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103db0:	00 00 00 
    wakeup(&p->nwrite);
80103db3:	50                   	push   %eax
80103db4:	e8 57 0f 00 00       	call   80104d10 <wakeup>
80103db9:	83 c4 10             	add    $0x10,%esp
80103dbc:	eb b9                	jmp    80103d77 <pipeclose+0x37>
80103dbe:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103dc0:	83 ec 0c             	sub    $0xc,%esp
80103dc3:	53                   	push   %ebx
80103dc4:	e8 87 14 00 00       	call   80105250 <release>
    kfree((char*)p);
80103dc9:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103dcc:	83 c4 10             	add    $0x10,%esp
}
80103dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103dd2:	5b                   	pop    %ebx
80103dd3:	5e                   	pop    %esi
80103dd4:	5d                   	pop    %ebp
    kfree((char*)p);
80103dd5:	e9 86 ec ff ff       	jmp    80102a60 <kfree>
80103dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103de0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	83 ec 28             	sub    $0x28,%esp
80103de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103dec:	53                   	push   %ebx
80103ded:	e8 9e 13 00 00       	call   80105190 <acquire>
  for(i = 0; i < n; i++){
80103df2:	8b 45 10             	mov    0x10(%ebp),%eax
80103df5:	83 c4 10             	add    $0x10,%esp
80103df8:	85 c0                	test   %eax,%eax
80103dfa:	0f 8e c9 00 00 00    	jle    80103ec9 <pipewrite+0xe9>
80103e00:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e03:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103e09:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103e0f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103e12:	03 4d 10             	add    0x10(%ebp),%ecx
80103e15:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e18:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103e1e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103e24:	39 d0                	cmp    %edx,%eax
80103e26:	75 71                	jne    80103e99 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103e28:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e2e:	85 c0                	test   %eax,%eax
80103e30:	74 4e                	je     80103e80 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e32:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103e38:	eb 3a                	jmp    80103e74 <pipewrite+0x94>
80103e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	57                   	push   %edi
80103e44:	e8 c7 0e 00 00       	call   80104d10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e49:	5a                   	pop    %edx
80103e4a:	59                   	pop    %ecx
80103e4b:	53                   	push   %ebx
80103e4c:	56                   	push   %esi
80103e4d:	e8 8e 0c 00 00       	call   80104ae0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e52:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e58:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e5e:	83 c4 10             	add    $0x10,%esp
80103e61:	05 00 02 00 00       	add    $0x200,%eax
80103e66:	39 c2                	cmp    %eax,%edx
80103e68:	75 36                	jne    80103ea0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103e6a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e70:	85 c0                	test   %eax,%eax
80103e72:	74 0c                	je     80103e80 <pipewrite+0xa0>
80103e74:	e8 87 04 00 00       	call   80104300 <myproc>
80103e79:	8b 40 24             	mov    0x24(%eax),%eax
80103e7c:	85 c0                	test   %eax,%eax
80103e7e:	74 c0                	je     80103e40 <pipewrite+0x60>
        release(&p->lock);
80103e80:	83 ec 0c             	sub    $0xc,%esp
80103e83:	53                   	push   %ebx
80103e84:	e8 c7 13 00 00       	call   80105250 <release>
        return -1;
80103e89:	83 c4 10             	add    $0x10,%esp
80103e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e94:	5b                   	pop    %ebx
80103e95:	5e                   	pop    %esi
80103e96:	5f                   	pop    %edi
80103e97:	5d                   	pop    %ebp
80103e98:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e99:	89 c2                	mov    %eax,%edx
80103e9b:	90                   	nop
80103e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ea0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103ea3:	8d 42 01             	lea    0x1(%edx),%eax
80103ea6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103eac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103eb2:	83 c6 01             	add    $0x1,%esi
80103eb5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103eb9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103ebc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ebf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103ec3:	0f 85 4f ff ff ff    	jne    80103e18 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ec9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103ecf:	83 ec 0c             	sub    $0xc,%esp
80103ed2:	50                   	push   %eax
80103ed3:	e8 38 0e 00 00       	call   80104d10 <wakeup>
  release(&p->lock);
80103ed8:	89 1c 24             	mov    %ebx,(%esp)
80103edb:	e8 70 13 00 00       	call   80105250 <release>
  return n;
80103ee0:	83 c4 10             	add    $0x10,%esp
80103ee3:	8b 45 10             	mov    0x10(%ebp),%eax
80103ee6:	eb a9                	jmp    80103e91 <pipewrite+0xb1>
80103ee8:	90                   	nop
80103ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ef0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	83 ec 18             	sub    $0x18,%esp
80103ef9:	8b 75 08             	mov    0x8(%ebp),%esi
80103efc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103eff:	56                   	push   %esi
80103f00:	e8 8b 12 00 00       	call   80105190 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f05:	83 c4 10             	add    $0x10,%esp
80103f08:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f0e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f14:	75 6a                	jne    80103f80 <piperead+0x90>
80103f16:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103f1c:	85 db                	test   %ebx,%ebx
80103f1e:	0f 84 c4 00 00 00    	je     80103fe8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f24:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103f2a:	eb 2d                	jmp    80103f59 <piperead+0x69>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f30:	83 ec 08             	sub    $0x8,%esp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
80103f35:	e8 a6 0b 00 00       	call   80104ae0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f3a:	83 c4 10             	add    $0x10,%esp
80103f3d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f43:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f49:	75 35                	jne    80103f80 <piperead+0x90>
80103f4b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103f51:	85 d2                	test   %edx,%edx
80103f53:	0f 84 8f 00 00 00    	je     80103fe8 <piperead+0xf8>
    if(myproc()->killed){
80103f59:	e8 a2 03 00 00       	call   80104300 <myproc>
80103f5e:	8b 48 24             	mov    0x24(%eax),%ecx
80103f61:	85 c9                	test   %ecx,%ecx
80103f63:	74 cb                	je     80103f30 <piperead+0x40>
      release(&p->lock);
80103f65:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f68:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f6d:	56                   	push   %esi
80103f6e:	e8 dd 12 00 00       	call   80105250 <release>
      return -1;
80103f73:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f79:	89 d8                	mov    %ebx,%eax
80103f7b:	5b                   	pop    %ebx
80103f7c:	5e                   	pop    %esi
80103f7d:	5f                   	pop    %edi
80103f7e:	5d                   	pop    %ebp
80103f7f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f80:	8b 45 10             	mov    0x10(%ebp),%eax
80103f83:	85 c0                	test   %eax,%eax
80103f85:	7e 61                	jle    80103fe8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103f87:	31 db                	xor    %ebx,%ebx
80103f89:	eb 13                	jmp    80103f9e <piperead+0xae>
80103f8b:	90                   	nop
80103f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f90:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f96:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f9c:	74 1f                	je     80103fbd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f9e:	8d 41 01             	lea    0x1(%ecx),%eax
80103fa1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103fa7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103fad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103fb2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fb5:	83 c3 01             	add    $0x1,%ebx
80103fb8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103fbb:	75 d3                	jne    80103f90 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fbd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103fc3:	83 ec 0c             	sub    $0xc,%esp
80103fc6:	50                   	push   %eax
80103fc7:	e8 44 0d 00 00       	call   80104d10 <wakeup>
  release(&p->lock);
80103fcc:	89 34 24             	mov    %esi,(%esp)
80103fcf:	e8 7c 12 00 00       	call   80105250 <release>
  return i;
80103fd4:	83 c4 10             	add    $0x10,%esp
}
80103fd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fda:	89 d8                	mov    %ebx,%eax
80103fdc:	5b                   	pop    %ebx
80103fdd:	5e                   	pop    %esi
80103fde:	5f                   	pop    %edi
80103fdf:	5d                   	pop    %ebp
80103fe0:	c3                   	ret    
80103fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fe8:	31 db                	xor    %ebx,%ebx
80103fea:	eb d1                	jmp    80103fbd <piperead+0xcd>
80103fec:	66 90                	xchg   %ax,%ax
80103fee:	66 90                	xchg   %ax,%ax

80103ff0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	57                   	push   %edi
80103ff4:	56                   	push   %esi
80103ff5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff6:	bb 54 61 18 80       	mov    $0x80186154,%ebx
{
80103ffb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103ffe:	68 20 61 18 80       	push   $0x80186120
80104003:	e8 88 11 00 00       	call   80105190 <acquire>
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	eb 15                	jmp    80104022 <allocproc+0x32>
8010400d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104010:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104016:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
8010401c:	0f 83 8e 01 00 00    	jae    801041b0 <allocproc+0x1c0>
    if(p->state == UNUSED)
80104022:	8b 43 0c             	mov    0xc(%ebx),%eax
80104025:	85 c0                	test   %eax,%eax
80104027:	75 e7                	jne    80104010 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104029:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
8010402e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80104031:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104038:	8d 50 01             	lea    0x1(%eax),%edx
8010403b:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010403e:	68 20 61 18 80       	push   $0x80186120
  p->pid = nextpid++;
80104043:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80104049:	e8 02 12 00 00       	call   80105250 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010404e:	e8 ed ec ff ff       	call   80102d40 <kalloc>
80104053:	83 c4 10             	add    $0x10,%esp
80104056:	85 c0                	test   %eax,%eax
80104058:	89 43 08             	mov    %eax,0x8(%ebx)
8010405b:	0f 84 6b 01 00 00    	je     801041cc <allocproc+0x1dc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104061:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104067:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010406a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010406f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104072:	c7 40 14 1f 65 10 80 	movl   $0x8010651f,0x14(%eax)
  p->context = (struct context*)sp;
80104079:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010407c:	6a 14                	push   $0x14
8010407e:	6a 00                	push   $0x0
80104080:	50                   	push   %eax
80104081:	e8 1a 12 00 00       	call   801052a0 <memset>
  p->context->eip = (uint)forkret;
80104086:	8b 43 1c             	mov    0x1c(%ebx),%eax

#if SELECTION != NONE
  if(p->pid > 2) {
80104089:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010408c:	c7 40 10 f0 41 10 80 	movl   $0x801041f0,0x10(%eax)
  if(p->pid > 2) {
80104093:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104097:	7f 0f                	jg     801040a8 <allocproc+0xb8>
    }
  }
#endif
  
  return p;
}
80104099:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010409c:	89 d8                	mov    %ebx,%eax
8010409e:	5b                   	pop    %ebx
8010409f:	5e                   	pop    %esi
801040a0:	5f                   	pop    %edi
801040a1:	5d                   	pop    %ebp
801040a2:	c3                   	ret    
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(createSwapFile(p) != 0)
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	53                   	push   %ebx
801040ac:	e8 9f e4 ff ff       	call   80102550 <createSwapFile>
801040b1:	83 c4 10             	add    $0x10,%esp
801040b4:	85 c0                	test   %eax,%eax
801040b6:	0f 85 1e 01 00 00    	jne    801041da <allocproc+0x1ea>
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040bc:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
801040c2:	83 ec 04             	sub    $0x4,%esp
801040c5:	68 c0 01 00 00       	push   $0x1c0
801040ca:	6a 00                	push   $0x0
801040cc:	50                   	push   %eax
801040cd:	e8 ce 11 00 00       	call   801052a0 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040d2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040d8:	83 c4 0c             	add    $0xc,%esp
801040db:	68 c0 01 00 00       	push   $0x1c0
801040e0:	6a 00                	push   $0x0
801040e2:	50                   	push   %eax
801040e3:	e8 b8 11 00 00       	call   801052a0 <memset>
    if(p->selection == SCFIFO)
801040e8:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
801040ee:	83 c4 10             	add    $0x10,%esp
    p->num_ram = 0;
801040f1:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
801040f8:	00 00 00 
    p->num_swap = 0;
801040fb:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80104102:	00 00 00 
    p->totalPgfltCount = 0;
80104105:	c7 83 28 04 00 00 00 	movl   $0x0,0x428(%ebx)
8010410c:	00 00 00 
    p->totalPgoutCount = 0;
8010410f:	c7 83 2c 04 00 00 00 	movl   $0x0,0x42c(%ebx)
80104116:	00 00 00 
    if(p->selection == SCFIFO)
80104119:	83 f8 03             	cmp    $0x3,%eax
8010411c:	0f 84 82 00 00 00    	je     801041a4 <allocproc+0x1b4>
    if(p->selection == AQ)
80104122:	83 f8 04             	cmp    $0x4,%eax
80104125:	75 14                	jne    8010413b <allocproc+0x14b>
      p->queue_head = 0;
80104127:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
8010412e:	00 00 00 
      p->queue_tail = 0;
80104131:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104138:	00 00 00 
    if(p->pid > 2)
8010413b:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
8010413f:	0f 8e 54 ff ff ff    	jle    80104099 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
80104145:	e8 f6 eb ff ff       	call   80102d40 <kalloc>
8010414a:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      p->free_head->prev = 0;
80104150:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = p->free_head;
80104157:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head->off = 0 * PGSIZE;
8010415c:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80104162:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80104168:	8b bb 14 04 00 00    	mov    0x414(%ebx),%edi
8010416e:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80104170:	e8 cb eb ff ff       	call   80102d40 <kalloc>
        curr->off = i * PGSIZE;
80104175:	89 30                	mov    %esi,(%eax)
80104177:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
8010417d:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80104180:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80104186:	89 47 04             	mov    %eax,0x4(%edi)
80104189:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
8010418b:	75 e3                	jne    80104170 <allocproc+0x180>
      p->free_tail = prev;
8010418d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
      p->free_tail->next = 0;
80104193:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
8010419a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010419d:	89 d8                	mov    %ebx,%eax
8010419f:	5b                   	pop    %ebx
801041a0:	5e                   	pop    %esi
801041a1:	5f                   	pop    %edi
801041a2:	5d                   	pop    %ebp
801041a3:	c3                   	ret    
      p->clockHand = 0;
801041a4:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
801041ab:	00 00 00 
801041ae:	eb 8b                	jmp    8010413b <allocproc+0x14b>
  release(&ptable.lock);
801041b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801041b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801041b5:	68 20 61 18 80       	push   $0x80186120
801041ba:	e8 91 10 00 00       	call   80105250 <release>
  return 0;
801041bf:	83 c4 10             	add    $0x10,%esp
}
801041c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041c5:	89 d8                	mov    %ebx,%eax
801041c7:	5b                   	pop    %ebx
801041c8:	5e                   	pop    %esi
801041c9:	5f                   	pop    %edi
801041ca:	5d                   	pop    %ebp
801041cb:	c3                   	ret    
    p->state = UNUSED;
801041cc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801041d3:	31 db                	xor    %ebx,%ebx
801041d5:	e9 bf fe ff ff       	jmp    80104099 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	68 95 96 10 80       	push   $0x80109695
801041e2:	e8 a9 c1 ff ff       	call   80100390 <panic>
801041e7:	89 f6                	mov    %esi,%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801041f6:	68 20 61 18 80       	push   $0x80186120
801041fb:	e8 50 10 00 00       	call   80105250 <release>

  if (first) {
80104200:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	85 c0                	test   %eax,%eax
8010420a:	75 04                	jne    80104210 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010420c:	c9                   	leave  
8010420d:	c3                   	ret    
8010420e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80104210:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80104213:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
8010421a:	00 00 00 
    iinit(ROOTDEV);
8010421d:	6a 01                	push   $0x1
8010421f:	e8 fc d5 ff ff       	call   80101820 <iinit>
    initlog(ROOTDEV);
80104224:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010422b:	e8 b0 f2 ff ff       	call   801034e0 <initlog>
80104230:	83 c4 10             	add    $0x10,%esp
}
80104233:	c9                   	leave  
80104234:	c3                   	ret    
80104235:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104240 <pinit>:
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80104246:	68 af 96 10 80       	push   $0x801096af
8010424b:	68 20 61 18 80       	push   $0x80186120
80104250:	e8 fb 0d 00 00       	call   80105050 <initlock>
}
80104255:	83 c4 10             	add    $0x10,%esp
80104258:	c9                   	leave  
80104259:	c3                   	ret    
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104260 <mycpu>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104265:	9c                   	pushf  
80104266:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104267:	f6 c4 02             	test   $0x2,%ah
8010426a:	75 5e                	jne    801042ca <mycpu+0x6a>
  apicid = lapicid();
8010426c:	e8 9f ee ff ff       	call   80103110 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104271:	8b 35 00 61 18 80    	mov    0x80186100,%esi
80104277:	85 f6                	test   %esi,%esi
80104279:	7e 42                	jle    801042bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010427b:	0f b6 15 80 5b 18 80 	movzbl 0x80185b80,%edx
80104282:	39 d0                	cmp    %edx,%eax
80104284:	74 30                	je     801042b6 <mycpu+0x56>
80104286:	b9 30 5c 18 80       	mov    $0x80185c30,%ecx
  for (i = 0; i < ncpu; ++i) {
8010428b:	31 d2                	xor    %edx,%edx
8010428d:	8d 76 00             	lea    0x0(%esi),%esi
80104290:	83 c2 01             	add    $0x1,%edx
80104293:	39 f2                	cmp    %esi,%edx
80104295:	74 26                	je     801042bd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104297:	0f b6 19             	movzbl (%ecx),%ebx
8010429a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801042a0:	39 c3                	cmp    %eax,%ebx
801042a2:	75 ec                	jne    80104290 <mycpu+0x30>
801042a4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801042aa:	05 80 5b 18 80       	add    $0x80185b80,%eax
}
801042af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042b2:	5b                   	pop    %ebx
801042b3:	5e                   	pop    %esi
801042b4:	5d                   	pop    %ebp
801042b5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
801042b6:	b8 80 5b 18 80       	mov    $0x80185b80,%eax
      return &cpus[i];
801042bb:	eb f2                	jmp    801042af <mycpu+0x4f>
  panic("unknown apicid\n");
801042bd:	83 ec 0c             	sub    $0xc,%esp
801042c0:	68 b6 96 10 80       	push   $0x801096b6
801042c5:	e8 c6 c0 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801042ca:	83 ec 0c             	sub    $0xc,%esp
801042cd:	68 a4 97 10 80       	push   $0x801097a4
801042d2:	e8 b9 c0 ff ff       	call   80100390 <panic>
801042d7:	89 f6                	mov    %esi,%esi
801042d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042e0 <cpuid>:
cpuid() {
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801042e6:	e8 75 ff ff ff       	call   80104260 <mycpu>
801042eb:	2d 80 5b 18 80       	sub    $0x80185b80,%eax
}
801042f0:	c9                   	leave  
  return mycpu()-cpus;
801042f1:	c1 f8 04             	sar    $0x4,%eax
801042f4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042fa:	c3                   	ret    
801042fb:	90                   	nop
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <myproc>:
myproc(void) {
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104307:	e8 b4 0d 00 00       	call   801050c0 <pushcli>
  c = mycpu();
8010430c:	e8 4f ff ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104311:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104317:	e8 e4 0d 00 00       	call   80105100 <popcli>
}
8010431c:	83 c4 04             	add    $0x4,%esp
8010431f:	89 d8                	mov    %ebx,%eax
80104321:	5b                   	pop    %ebx
80104322:	5d                   	pop    %ebp
80104323:	c3                   	ret    
80104324:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010432a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104330 <userinit>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104337:	e8 b4 fc ff ff       	call   80103ff0 <allocproc>
8010433c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010433e:	a3 dc c5 10 80       	mov    %eax,0x8010c5dc
  if((p->pgdir = setupkvm()) == 0)
80104343:	e8 58 3a 00 00       	call   80107da0 <setupkvm>
80104348:	85 c0                	test   %eax,%eax
8010434a:	89 43 04             	mov    %eax,0x4(%ebx)
8010434d:	0f 84 bd 00 00 00    	je     80104410 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104353:	83 ec 04             	sub    $0x4,%esp
80104356:	68 2c 00 00 00       	push   $0x2c
8010435b:	68 60 c4 10 80       	push   $0x8010c460
80104360:	50                   	push   %eax
80104361:	e8 3a 35 00 00       	call   801078a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104366:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104369:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010436f:	6a 4c                	push   $0x4c
80104371:	6a 00                	push   $0x0
80104373:	ff 73 18             	pushl  0x18(%ebx)
80104376:	e8 25 0f 00 00       	call   801052a0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010437b:	8b 43 18             	mov    0x18(%ebx),%eax
8010437e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104383:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104388:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010438b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010438f:	8b 43 18             	mov    0x18(%ebx),%eax
80104392:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104396:	8b 43 18             	mov    0x18(%ebx),%eax
80104399:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010439d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801043a1:	8b 43 18             	mov    0x18(%ebx),%eax
801043a4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801043a8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801043ac:	8b 43 18             	mov    0x18(%ebx),%eax
801043af:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801043b6:	8b 43 18             	mov    0x18(%ebx),%eax
801043b9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801043c0:	8b 43 18             	mov    0x18(%ebx),%eax
801043c3:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801043ca:	8d 43 6c             	lea    0x6c(%ebx),%eax
801043cd:	6a 10                	push   $0x10
801043cf:	68 df 96 10 80       	push   $0x801096df
801043d4:	50                   	push   %eax
801043d5:	e8 a6 10 00 00       	call   80105480 <safestrcpy>
  p->cwd = namei("/");
801043da:	c7 04 24 e8 96 10 80 	movl   $0x801096e8,(%esp)
801043e1:	e8 9a de ff ff       	call   80102280 <namei>
801043e6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043e9:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
801043f0:	e8 9b 0d 00 00       	call   80105190 <acquire>
  p->state = RUNNABLE;
801043f5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043fc:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104403:	e8 48 0e 00 00       	call   80105250 <release>
}
80104408:	83 c4 10             	add    $0x10,%esp
8010440b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010440e:	c9                   	leave  
8010440f:	c3                   	ret    
    panic("userinit: out of memory?");
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 c6 96 10 80       	push   $0x801096c6
80104418:	e8 73 bf ff ff       	call   80100390 <panic>
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <growproc>:
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	56                   	push   %esi
80104424:	53                   	push   %ebx
80104425:	83 ec 10             	sub    $0x10,%esp
80104428:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010442b:	e8 90 0c 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104430:	e8 2b fe ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104435:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010443b:	e8 c0 0c 00 00       	call   80105100 <popcli>
  if(n > 0){
80104440:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80104443:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104445:	7f 19                	jg     80104460 <growproc+0x40>
  } else if(n < 0){
80104447:	75 37                	jne    80104480 <growproc+0x60>
  switchuvm(curproc);
80104449:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010444c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010444e:	53                   	push   %ebx
8010444f:	e8 3c 33 00 00       	call   80107790 <switchuvm>
  return 0;
80104454:	83 c4 10             	add    $0x10,%esp
80104457:	31 c0                	xor    %eax,%eax
}
80104459:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010445c:	5b                   	pop    %ebx
8010445d:	5e                   	pop    %esi
8010445e:	5d                   	pop    %ebp
8010445f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104460:	83 ec 04             	sub    $0x4,%esp
80104463:	01 c6                	add    %eax,%esi
80104465:	56                   	push   %esi
80104466:	50                   	push   %eax
80104467:	ff 73 04             	pushl  0x4(%ebx)
8010446a:	e8 81 42 00 00       	call   801086f0 <allocuvm>
8010446f:	83 c4 10             	add    $0x10,%esp
80104472:	85 c0                	test   %eax,%eax
80104474:	75 d3                	jne    80104449 <growproc+0x29>
      return -1;
80104476:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010447b:	eb dc                	jmp    80104459 <growproc+0x39>
8010447d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("growproc: n < 0\n");
80104480:	83 ec 0c             	sub    $0xc,%esp
80104483:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104486:	68 ea 96 10 80       	push   $0x801096ea
8010448b:	e8 d0 c1 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104490:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104493:	83 c4 0c             	add    $0xc,%esp
80104496:	01 c6                	add    %eax,%esi
80104498:	56                   	push   %esi
80104499:	50                   	push   %eax
8010449a:	ff 73 04             	pushl  0x4(%ebx)
8010449d:	e8 2e 36 00 00       	call   80107ad0 <deallocuvm>
801044a2:	83 c4 10             	add    $0x10,%esp
801044a5:	85 c0                	test   %eax,%eax
801044a7:	75 a0                	jne    80104449 <growproc+0x29>
801044a9:	eb cb                	jmp    80104476 <growproc+0x56>
801044ab:	90                   	nop
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044b0 <copyAQ>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	57                   	push   %edi
801044b4:	56                   	push   %esi
801044b5:	53                   	push   %ebx
801044b6:	83 ec 0c             	sub    $0xc,%esp
801044b9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801044bc:	e8 ff 0b 00 00       	call   801050c0 <pushcli>
  c = mycpu();
801044c1:	e8 9a fd ff ff       	call   80104260 <mycpu>
  p = c->proc;
801044c6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044cc:	e8 2f 0c 00 00       	call   80105100 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
801044d1:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
801044d7:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
801044de:	00 00 00 
  np->queue_tail = 0;
801044e1:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
801044e8:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
801044eb:	85 db                	test   %ebx,%ebx
801044ed:	74 4f                	je     8010453e <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
801044ef:	e8 4c e8 ff ff       	call   80102d40 <kalloc>
801044f4:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
801044f6:	8b 43 08             	mov    0x8(%ebx),%eax
801044f9:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
801044fc:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
80104502:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
80104509:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
8010450b:	85 db                	test   %ebx,%ebx
8010450d:	74 37                	je     80104546 <copyAQ+0x96>
8010450f:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
80104510:	e8 2b e8 ff ff       	call   80102d40 <kalloc>
    np_curr->page_index = old_curr->page_index;
80104515:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
80104518:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
8010451b:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
8010451e:	89 07                	mov    %eax,(%edi)
80104520:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
80104522:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
80104524:	85 db                	test   %ebx,%ebx
80104526:	75 e8                	jne    80104510 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
80104528:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
8010452e:	85 d2                	test   %edx,%edx
80104530:	74 0c                	je     8010453e <copyAQ+0x8e>
    np_curr->next = 0;
80104532:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104538:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
8010453e:	83 c4 0c             	add    $0xc,%esp
80104541:	5b                   	pop    %ebx
80104542:	5e                   	pop    %esi
80104543:	5f                   	pop    %edi
80104544:	5d                   	pop    %ebp
80104545:	c3                   	ret    
  while(old_curr != 0)
80104546:	89 f8                	mov    %edi,%eax
80104548:	eb de                	jmp    80104528 <copyAQ+0x78>
8010454a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104550 <fork>:
{ 
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
80104554:	56                   	push   %esi
80104555:	53                   	push   %ebx
80104556:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010455c:	e8 5f 0b 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104561:	e8 fa fc ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104566:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010456c:	e8 8f 0b 00 00       	call   80105100 <popcli>
  if((np = allocproc()) == 0){
80104571:	e8 7a fa ff ff       	call   80103ff0 <allocproc>
80104576:	85 c0                	test   %eax,%eax
80104578:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
8010457e:	0f 84 09 02 00 00    	je     8010478d <fork+0x23d>
  if(curproc->pid <= 2) // init, shell
80104584:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104588:	89 c7                	mov    %eax,%edi
8010458a:	8b 13                	mov    (%ebx),%edx
8010458c:	8b 43 04             	mov    0x4(%ebx),%eax
8010458f:	0f 8e e3 01 00 00    	jle    80104778 <fork+0x228>
    np->pgdir = cowuvm(curproc->pgdir, curproc->sz);
80104595:	83 ec 08             	sub    $0x8,%esp
80104598:	52                   	push   %edx
80104599:	50                   	push   %eax
8010459a:	e8 e1 38 00 00       	call   80107e80 <cowuvm>
8010459f:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801045a5:	83 c4 10             	add    $0x10,%esp
801045a8:	89 41 04             	mov    %eax,0x4(%ecx)
  if(np->pgdir == 0){
801045ab:	85 c0                	test   %eax,%eax
801045ad:	0f 84 e1 01 00 00    	je     80104794 <fork+0x244>
  np->sz = curproc->sz;
801045b3:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801045b9:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801045bb:	8b 79 18             	mov    0x18(%ecx),%edi
  np->sz = curproc->sz;
801045be:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801045c0:	89 c8                	mov    %ecx,%eax
801045c2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801045c5:	b9 13 00 00 00       	mov    $0x13,%ecx
801045ca:	8b 73 18             	mov    0x18(%ebx),%esi
801045cd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801045cf:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801045d3:	0f 8e 15 01 00 00    	jle    801046ee <fork+0x19e>
    np->totalPgfltCount = 0;
801045d9:	89 c7                	mov    %eax,%edi
801045db:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
801045e2:	00 00 00 
    np->totalPgoutCount = 0;
801045e5:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801045ec:	00 00 00 
    np->num_ram = curproc->num_ram;
801045ef:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
801045f5:	8d 93 90 00 00 00    	lea    0x90(%ebx),%edx
        np->ramPages[i].pgdir = np->pgdir;
801045fb:	8b 4f 04             	mov    0x4(%edi),%ecx
    np->num_ram = curproc->num_ram;
801045fe:	89 87 08 04 00 00    	mov    %eax,0x408(%edi)
    np->num_swap = curproc->num_swap;
80104604:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
8010460a:	89 87 0c 04 00 00    	mov    %eax,0x40c(%edi)
80104610:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
80104616:	81 c7 48 02 00 00    	add    $0x248,%edi
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        np->ramPages[i].isused = 1;
80104620:	c7 80 c4 01 00 00 01 	movl   $0x1,0x1c4(%eax)
80104627:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010462a:	8b b2 c0 01 00 00    	mov    0x1c0(%edx),%esi
80104630:	83 c0 1c             	add    $0x1c,%eax
        np->ramPages[i].pgdir = np->pgdir;
80104633:	89 88 a4 01 00 00    	mov    %ecx,0x1a4(%eax)
80104639:	83 c2 1c             	add    $0x1c,%edx
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010463c:	89 b0 ac 01 00 00    	mov    %esi,0x1ac(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104642:	8b b2 ac 01 00 00    	mov    0x1ac(%edx),%esi
      np->swappedPages[i].isused = 1;
80104648:	c7 40 e8 01 00 00 00 	movl   $0x1,-0x18(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
8010464f:	89 b0 b4 01 00 00    	mov    %esi,0x1b4(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104655:	8b 72 e4             	mov    -0x1c(%edx),%esi
      np->swappedPages[i].pgdir = np->pgdir;
80104658:	89 48 e4             	mov    %ecx,-0x1c(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
8010465b:	89 70 ec             	mov    %esi,-0x14(%eax)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
8010465e:	8b 72 e8             	mov    -0x18(%edx),%esi
80104661:	89 70 f0             	mov    %esi,-0x10(%eax)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
80104664:	8b 72 ec             	mov    -0x14(%edx),%esi
80104667:	89 70 f4             	mov    %esi,-0xc(%eax)
    for(i = 0; i < MAX_PSYC_PAGES; i++)
8010466a:	39 f8                	cmp    %edi,%eax
8010466c:	75 b2                	jne    80104620 <fork+0xd0>
      char buffer[PGSIZE / 2] = "";
8010466e:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104674:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104679:	31 c0                	xor    %eax,%eax
8010467b:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104682:	00 00 00 
      int offset = 0;
80104685:	31 f6                	xor    %esi,%esi
80104687:	89 9d e0 f7 ff ff    	mov    %ebx,-0x820(%ebp)
      char buffer[PGSIZE / 2] = "";
8010468d:	f3 ab                	rep stos %eax,%es:(%edi)
8010468f:	8d bd e8 f7 ff ff    	lea    -0x818(%ebp),%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
80104695:	eb 25                	jmp    801046bc <fork+0x16c>
80104697:	89 f6                	mov    %esi,%esi
80104699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
801046a0:	53                   	push   %ebx
801046a1:	56                   	push   %esi
801046a2:	57                   	push   %edi
801046a3:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
801046a9:	e8 42 df ff ff       	call   801025f0 <writeToSwapFile>
801046ae:	83 c4 10             	add    $0x10,%esp
801046b1:	83 f8 ff             	cmp    $0xffffffff,%eax
801046b4:	0f 84 03 01 00 00    	je     801047bd <fork+0x26d>
        offset += nread;
801046ba:	01 de                	add    %ebx,%esi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801046bc:	68 00 08 00 00       	push   $0x800
801046c1:	56                   	push   %esi
801046c2:	57                   	push   %edi
801046c3:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
801046c9:	e8 72 df ff ff       	call   80102640 <readFromSwapFile>
801046ce:	83 c4 10             	add    $0x10,%esp
801046d1:	85 c0                	test   %eax,%eax
801046d3:	89 c3                	mov    %eax,%ebx
801046d5:	75 c9                	jne    801046a0 <fork+0x150>
      copyAQ(np);
801046d7:	83 ec 0c             	sub    $0xc,%esp
801046da:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
801046e0:	8b 9d e0 f7 ff ff    	mov    -0x820(%ebp),%ebx
801046e6:	e8 c5 fd ff ff       	call   801044b0 <copyAQ>
801046eb:	83 c4 10             	add    $0x10,%esp
  np->tf->eax = 0;
801046ee:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
801046f4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801046f6:	8b 47 18             	mov    0x18(%edi),%eax
801046f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104700:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104704:	85 c0                	test   %eax,%eax
80104706:	74 10                	je     80104718 <fork+0x1c8>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104708:	83 ec 0c             	sub    $0xc,%esp
8010470b:	50                   	push   %eax
8010470c:	e8 7f ca ff ff       	call   80101190 <filedup>
80104711:	83 c4 10             	add    $0x10,%esp
80104714:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104718:	83 c6 01             	add    $0x1,%esi
8010471b:	83 fe 10             	cmp    $0x10,%esi
8010471e:	75 e0                	jne    80104700 <fork+0x1b0>
  np->cwd = idup(curproc->cwd);
80104720:	83 ec 0c             	sub    $0xc,%esp
80104723:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104726:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104729:	e8 c2 d2 ff ff       	call   801019f0 <idup>
8010472e:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104734:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104737:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010473a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010473d:	6a 10                	push   $0x10
8010473f:	53                   	push   %ebx
80104740:	50                   	push   %eax
80104741:	e8 3a 0d 00 00       	call   80105480 <safestrcpy>
  pid = np->pid;
80104746:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104749:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104750:	e8 3b 0a 00 00       	call   80105190 <acquire>
  np->state = RUNNABLE;
80104755:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010475c:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104763:	e8 e8 0a 00 00       	call   80105250 <release>
  return pid;
80104768:	83 c4 10             	add    $0x10,%esp
}
8010476b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010476e:	89 d8                	mov    %ebx,%eax
80104770:	5b                   	pop    %ebx
80104771:	5e                   	pop    %esi
80104772:	5f                   	pop    %edi
80104773:	5d                   	pop    %ebp
80104774:	c3                   	ret    
80104775:	8d 76 00             	lea    0x0(%esi),%esi
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104778:	83 ec 08             	sub    $0x8,%esp
8010477b:	52                   	push   %edx
8010477c:	50                   	push   %eax
8010477d:	e8 5e 39 00 00       	call   801080e0 <copyuvm>
80104782:	83 c4 10             	add    $0x10,%esp
80104785:	89 47 04             	mov    %eax,0x4(%edi)
80104788:	e9 1e fe ff ff       	jmp    801045ab <fork+0x5b>
    return -1;
8010478d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104792:	eb d7                	jmp    8010476b <fork+0x21b>
    kfree(np->kstack);
80104794:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
8010479a:	83 ec 0c             	sub    $0xc,%esp
8010479d:	ff 73 08             	pushl  0x8(%ebx)
801047a0:	e8 bb e2 ff ff       	call   80102a60 <kfree>
    np->kstack = 0;
801047a5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801047ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801047b3:	83 c4 10             	add    $0x10,%esp
801047b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047bb:	eb ae                	jmp    8010476b <fork+0x21b>
          panic("fork: error copying parent's swap file");
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	68 cc 97 10 80       	push   $0x801097cc
801047c5:	e8 c6 bb ff ff       	call   80100390 <panic>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <scheduler>:
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
801047d6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047d9:	e8 82 fa ff ff       	call   80104260 <mycpu>
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
801047f4:	bb 54 61 18 80       	mov    $0x80186154,%ebx
    acquire(&ptable.lock);
801047f9:	68 20 61 18 80       	push   $0x80186120
801047fe:	e8 8d 09 00 00       	call   80105190 <acquire>
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
80104820:	e8 6b 2f 00 00       	call   80107790 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104825:	58                   	pop    %eax
80104826:	5a                   	pop    %edx
80104827:	ff 73 1c             	pushl  0x1c(%ebx)
8010482a:	57                   	push   %edi
      p->state = RUNNING;
8010482b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104832:	e8 a4 0c 00 00       	call   801054db <swtch>
      switchkvm();
80104837:	e8 34 2f 00 00       	call   80107770 <switchkvm>
      c->proc = 0;
8010483c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104843:	00 00 00 
80104846:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104849:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010484f:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
80104855:	72 b9                	jb     80104810 <scheduler+0x40>
    release(&ptable.lock);
80104857:	83 ec 0c             	sub    $0xc,%esp
8010485a:	68 20 61 18 80       	push   $0x80186120
8010485f:	e8 ec 09 00 00       	call   80105250 <release>
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
80104875:	e8 46 08 00 00       	call   801050c0 <pushcli>
  c = mycpu();
8010487a:	e8 e1 f9 ff ff       	call   80104260 <mycpu>
  p = c->proc;
8010487f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104885:	e8 76 08 00 00       	call   80105100 <popcli>
  if(!holding(&ptable.lock))
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 20 61 18 80       	push   $0x80186120
80104892:	e8 c9 08 00 00       	call   80105160 <holding>
80104897:	83 c4 10             	add    $0x10,%esp
8010489a:	85 c0                	test   %eax,%eax
8010489c:	74 4f                	je     801048ed <sched+0x7d>
  if(mycpu()->ncli != 1)
8010489e:	e8 bd f9 ff ff       	call   80104260 <mycpu>
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
801048b9:	e8 a2 f9 ff ff       	call   80104260 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801048be:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801048c1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801048c7:	e8 94 f9 ff ff       	call   80104260 <mycpu>
801048cc:	83 ec 08             	sub    $0x8,%esp
801048cf:	ff 70 04             	pushl  0x4(%eax)
801048d2:	53                   	push   %ebx
801048d3:	e8 03 0c 00 00       	call   801054db <swtch>
  mycpu()->intena = intena;
801048d8:	e8 83 f9 ff ff       	call   80104260 <mycpu>
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
801048f0:	68 fb 96 10 80       	push   $0x801096fb
801048f5:	e8 96 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801048fa:	83 ec 0c             	sub    $0xc,%esp
801048fd:	68 27 97 10 80       	push   $0x80109727
80104902:	e8 89 ba ff ff       	call   80100390 <panic>
    panic("sched running");
80104907:	83 ec 0c             	sub    $0xc,%esp
8010490a:	68 19 97 10 80       	push   $0x80109719
8010490f:	e8 7c ba ff ff       	call   80100390 <panic>
    panic("sched locks");
80104914:	83 ec 0c             	sub    $0xc,%esp
80104917:	68 0d 97 10 80       	push   $0x8010970d
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
80104939:	e8 82 07 00 00       	call   801050c0 <pushcli>
  c = mycpu();
8010493e:	e8 1d f9 ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104943:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104949:	e8 b2 07 00 00       	call   80105100 <popcli>
  if(curproc == initproc)
8010494e:	39 1d dc c5 10 80    	cmp    %ebx,0x8010c5dc
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
8010496a:	e8 71 c8 ff ff       	call   801011e0 <fileclose>
      curproc->ofile[fd] = 0;
8010496f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104975:	83 c4 10             	add    $0x10,%esp
80104978:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010497b:	39 fe                	cmp    %edi,%esi
8010497d:	75 e1                	jne    80104960 <exit+0x30>
  begin_op();
8010497f:	e8 fc eb ff ff       	call   80103580 <begin_op>
  iput(curproc->cwd);
80104984:	83 ec 0c             	sub    $0xc,%esp
80104987:	ff 73 68             	pushl  0x68(%ebx)
8010498a:	e8 c1 d1 ff ff       	call   80101b50 <iput>
  end_op();
8010498f:	e8 5c ec ff ff       	call   801035f0 <end_op>
      if(curproc->pid > 2) {
80104994:	83 c4 10             	add    $0x10,%esp
80104997:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
8010499b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
      if(curproc->pid > 2) {
801049a2:	0f 8f b9 00 00 00    	jg     80104a61 <exit+0x131>
  acquire(&ptable.lock);
801049a8:	83 ec 0c             	sub    $0xc,%esp
801049ab:	68 20 61 18 80       	push   $0x80186120
801049b0:	e8 db 07 00 00       	call   80105190 <acquire>
  wakeup1(curproc->parent);
801049b5:	8b 53 14             	mov    0x14(%ebx),%edx
801049b8:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049bb:	b8 54 61 18 80       	mov    $0x80186154,%eax
801049c0:	eb 12                	jmp    801049d4 <exit+0xa4>
801049c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c8:	05 30 04 00 00       	add    $0x430,%eax
801049cd:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
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
801049eb:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
801049f0:	72 e2                	jb     801049d4 <exit+0xa4>
      p->parent = initproc;
801049f2:	8b 0d dc c5 10 80    	mov    0x8010c5dc,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801049f8:	ba 54 61 18 80       	mov    $0x80186154,%edx
801049fd:	eb 0f                	jmp    80104a0e <exit+0xde>
801049ff:	90                   	nop
80104a00:	81 c2 30 04 00 00    	add    $0x430,%edx
80104a06:	81 fa 54 6d 19 80    	cmp    $0x80196d54,%edx
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
80104a1c:	b8 54 61 18 80       	mov    $0x80186154,%eax
80104a21:	eb 11                	jmp    80104a34 <exit+0x104>
80104a23:	90                   	nop
80104a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a28:	05 30 04 00 00       	add    $0x430,%eax
80104a2d:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
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
80104a57:	68 48 97 10 80       	push   $0x80109748
80104a5c:	e8 2f b9 ff ff       	call   80100390 <panic>
        if (removeSwapFile(curproc) != 0)
80104a61:	83 ec 0c             	sub    $0xc,%esp
80104a64:	53                   	push   %ebx
80104a65:	e8 e6 d8 ff ff       	call   80102350 <removeSwapFile>
80104a6a:	83 c4 10             	add    $0x10,%esp
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	0f 84 33 ff ff ff    	je     801049a8 <exit+0x78>
          panic("exit: error deleting swap file");
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	68 f4 97 10 80       	push   $0x801097f4
80104a7d:	e8 0e b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a82:	83 ec 0c             	sub    $0xc,%esp
80104a85:	68 3b 97 10 80       	push   $0x8010973b
80104a8a:	e8 01 b9 ff ff       	call   80100390 <panic>
80104a8f:	90                   	nop

80104a90 <yield>:
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a97:	68 20 61 18 80       	push   $0x80186120
80104a9c:	e8 ef 06 00 00       	call   80105190 <acquire>
  pushcli();
80104aa1:	e8 1a 06 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104aa6:	e8 b5 f7 ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104aab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ab1:	e8 4a 06 00 00       	call   80105100 <popcli>
  myproc()->state = RUNNABLE;
80104ab6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104abd:	e8 ae fd ff ff       	call   80104870 <sched>
  release(&ptable.lock);
80104ac2:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104ac9:	e8 82 07 00 00       	call   80105250 <release>
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
80104aef:	e8 cc 05 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104af4:	e8 67 f7 ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104af9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104aff:	e8 fc 05 00 00       	call   80105100 <popcli>
  if(p == 0)
80104b04:	85 db                	test   %ebx,%ebx
80104b06:	0f 84 87 00 00 00    	je     80104b93 <sleep+0xb3>
  if(lk == 0)
80104b0c:	85 f6                	test   %esi,%esi
80104b0e:	74 76                	je     80104b86 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b10:	81 fe 20 61 18 80    	cmp    $0x80186120,%esi
80104b16:	74 50                	je     80104b68 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b18:	83 ec 0c             	sub    $0xc,%esp
80104b1b:	68 20 61 18 80       	push   $0x80186120
80104b20:	e8 6b 06 00 00       	call   80105190 <acquire>
    release(lk);
80104b25:	89 34 24             	mov    %esi,(%esp)
80104b28:	e8 23 07 00 00       	call   80105250 <release>
  p->chan = chan;
80104b2d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b30:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b37:	e8 34 fd ff ff       	call   80104870 <sched>
  p->chan = 0;
80104b3c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b43:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
80104b4a:	e8 01 07 00 00       	call   80105250 <release>
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
80104b5c:	e9 2f 06 00 00       	jmp    80105190 <acquire>
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
80104b89:	68 5a 97 10 80       	push   $0x8010975a
80104b8e:	e8 fd b7 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b93:	83 ec 0c             	sub    $0xc,%esp
80104b96:	68 54 97 10 80       	push   $0x80109754
80104b9b:	e8 f0 b7 ff ff       	call   80100390 <panic>

80104ba0 <wait>:
{
80104ba0:	55                   	push   %ebp
80104ba1:	89 e5                	mov    %esp,%ebp
80104ba3:	56                   	push   %esi
80104ba4:	53                   	push   %ebx
  pushcli();
80104ba5:	e8 16 05 00 00       	call   801050c0 <pushcli>
  c = mycpu();
80104baa:	e8 b1 f6 ff ff       	call   80104260 <mycpu>
  p = c->proc;
80104baf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104bb5:	e8 46 05 00 00       	call   80105100 <popcli>
  acquire(&ptable.lock);
80104bba:	83 ec 0c             	sub    $0xc,%esp
80104bbd:	68 20 61 18 80       	push   $0x80186120
80104bc2:	e8 c9 05 00 00       	call   80105190 <acquire>
80104bc7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104bca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bcc:	bb 54 61 18 80       	mov    $0x80186154,%ebx
80104bd1:	eb 13                	jmp    80104be6 <wait+0x46>
80104bd3:	90                   	nop
80104bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bd8:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104bde:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
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
80104bfc:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
80104c02:	72 e2                	jb     80104be6 <wait+0x46>
    if(!havekids || curproc->killed){
80104c04:	85 c0                	test   %eax,%eax
80104c06:	0f 84 ec 00 00 00    	je     80104cf8 <wait+0x158>
80104c0c:	8b 46 24             	mov    0x24(%esi),%eax
80104c0f:	85 c0                	test   %eax,%eax
80104c11:	0f 85 e1 00 00 00    	jne    80104cf8 <wait+0x158>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c17:	83 ec 08             	sub    $0x8,%esp
80104c1a:	68 20 61 18 80       	push   $0x80186120
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
        freevm(p->pgdir);
80104c3e:	5a                   	pop    %edx
80104c3f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c42:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104c49:	e8 a2 30 00 00       	call   80107cf0 <freevm>
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
        p->free_head = 0;
80104c82:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104c89:	00 00 00 
        p->free_tail = 0;
80104c8c:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104c93:	00 00 00 
        p->queue_head = 0;
80104c96:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104c9d:	00 00 00 
        p->queue_tail = 0;
80104ca0:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104ca7:	00 00 00 
        p->numswappages = 0;
80104caa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104cb1:	00 00 00 
        p-> nummemorypages = 0;
80104cb4:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104cbb:	00 00 00 
          memset(p->ramPages, 0, sizeof(p->ramPages));
80104cbe:	e8 dd 05 00 00       	call   801052a0 <memset>
          memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104cc3:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104cc9:	83 c4 0c             	add    $0xc,%esp
80104ccc:	68 c0 01 00 00       	push   $0x1c0
80104cd1:	6a 00                	push   $0x0
80104cd3:	50                   	push   %eax
80104cd4:	e8 c7 05 00 00       	call   801052a0 <memset>
        release(&ptable.lock);
80104cd9:	c7 04 24 20 61 18 80 	movl   $0x80186120,(%esp)
        p->state = UNUSED;
80104ce0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104ce7:	e8 64 05 00 00       	call   80105250 <release>
        return pid;
80104cec:	83 c4 10             	add    $0x10,%esp
}
80104cef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf2:	89 f0                	mov    %esi,%eax
80104cf4:	5b                   	pop    %ebx
80104cf5:	5e                   	pop    %esi
80104cf6:	5d                   	pop    %ebp
80104cf7:	c3                   	ret    
      release(&ptable.lock);
80104cf8:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104cfb:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104d00:	68 20 61 18 80       	push   $0x80186120
80104d05:	e8 46 05 00 00       	call   80105250 <release>
      return -1;
80104d0a:	83 c4 10             	add    $0x10,%esp
80104d0d:	eb e0                	jmp    80104cef <wait+0x14f>
80104d0f:	90                   	nop

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
80104d1a:	68 20 61 18 80       	push   $0x80186120
80104d1f:	e8 6c 04 00 00       	call   80105190 <acquire>
80104d24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d27:	b8 54 61 18 80       	mov    $0x80186154,%eax
80104d2c:	eb 0e                	jmp    80104d3c <wakeup+0x2c>
80104d2e:	66 90                	xchg   %ax,%ax
80104d30:	05 30 04 00 00       	add    $0x430,%eax
80104d35:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
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
80104d53:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
80104d58:	72 e2                	jb     80104d3c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d5a:	c7 45 08 20 61 18 80 	movl   $0x80186120,0x8(%ebp)
}
80104d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d64:	c9                   	leave  
  release(&ptable.lock);
80104d65:	e9 e6 04 00 00       	jmp    80105250 <release>
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
80104d7a:	68 20 61 18 80       	push   $0x80186120
80104d7f:	e8 0c 04 00 00       	call   80105190 <acquire>
80104d84:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d87:	b8 54 61 18 80       	mov    $0x80186154,%eax
80104d8c:	eb 0e                	jmp    80104d9c <kill+0x2c>
80104d8e:	66 90                	xchg   %ax,%ax
80104d90:	05 30 04 00 00       	add    $0x430,%eax
80104d95:	3d 54 6d 19 80       	cmp    $0x80196d54,%eax
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
80104db8:	68 20 61 18 80       	push   $0x80186120
80104dbd:	e8 8e 04 00 00       	call   80105250 <release>
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
80104dd3:	68 20 61 18 80       	push   $0x80186120
80104dd8:	e8 73 04 00 00       	call   80105250 <release>
  return -1;
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104de8:	c9                   	leave  
80104de9:	c3                   	ret    
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104df0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	57                   	push   %edi
80104df4:	56                   	push   %esi
80104df5:	53                   	push   %ebx
80104df6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104df9:	bb 54 61 18 80       	mov    $0x80186154,%ebx
{
80104dfe:	83 ec 3c             	sub    $0x3c,%esp
80104e01:	eb 40                	jmp    80104e43 <procdump+0x53>
80104e03:	90                   	nop
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n<%d / %d>", getNumberOfFreePages(), initialNumOfFreePages);
80104e08:	8b 3d d8 c5 10 80    	mov    0x8010c5d8,%edi
}

int
getNumberOfFreePages(void)
{
  return getNumOfFreePages();
80104e0e:	e8 dd e0 ff ff       	call   80102ef0 <getNumOfFreePages>
    cprintf("\n<%d / %d>", getNumberOfFreePages(), initialNumOfFreePages);
80104e13:	83 ec 04             	sub    $0x4,%esp
80104e16:	57                   	push   %edi
80104e17:	50                   	push   %eax
80104e18:	68 6f 97 10 80       	push   $0x8010976f
80104e1d:	e8 3e b8 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104e22:	c7 04 24 17 9d 10 80 	movl   $0x80109d17,(%esp)
80104e29:	e8 32 b8 ff ff       	call   80100660 <cprintf>
80104e2e:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e31:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104e37:	81 fb 54 6d 19 80    	cmp    $0x80196d54,%ebx
80104e3d:	0f 83 ad 00 00 00    	jae    80104ef0 <procdump+0x100>
    if(p->state == UNUSED)
80104e43:	8b 43 0c             	mov    0xc(%ebx),%eax
80104e46:	85 c0                	test   %eax,%eax
80104e48:	74 e7                	je     80104e31 <procdump+0x41>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e4a:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104e4d:	ba 6b 97 10 80       	mov    $0x8010976b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104e52:	77 11                	ja     80104e65 <procdump+0x75>
80104e54:	8b 14 85 7c 98 10 80 	mov    -0x7fef6784(,%eax,4),%edx
      state = "???";
80104e5b:	b8 6b 97 10 80       	mov    $0x8010976b,%eax
80104e60:	85 d2                	test   %edx,%edx
80104e62:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104e65:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104e68:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104e6e:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104e74:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104e7a:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104e80:	50                   	push   %eax
80104e81:	52                   	push   %edx
80104e82:	ff 73 10             	pushl  0x10(%ebx)
80104e85:	68 14 98 10 80       	push   $0x80109814
80104e8a:	e8 d1 b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104e8f:	83 c4 20             	add    $0x20,%esp
80104e92:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104e96:	0f 85 6c ff ff ff    	jne    80104e08 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104e9c:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104e9f:	83 ec 08             	sub    $0x8,%esp
80104ea2:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104ea5:	50                   	push   %eax
80104ea6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104ea9:	8b 40 0c             	mov    0xc(%eax),%eax
80104eac:	83 c0 08             	add    $0x8,%eax
80104eaf:	50                   	push   %eax
80104eb0:	e8 bb 01 00 00       	call   80105070 <getcallerpcs>
80104eb5:	83 c4 10             	add    $0x10,%esp
80104eb8:	90                   	nop
80104eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104ec0:	8b 17                	mov    (%edi),%edx
80104ec2:	85 d2                	test   %edx,%edx
80104ec4:	0f 84 3e ff ff ff    	je     80104e08 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104eca:	83 ec 08             	sub    $0x8,%esp
80104ecd:	83 c7 04             	add    $0x4,%edi
80104ed0:	52                   	push   %edx
80104ed1:	68 a1 90 10 80       	push   $0x801090a1
80104ed6:	e8 85 b7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104edb:	83 c4 10             	add    $0x10,%esp
80104ede:	39 fe                	cmp    %edi,%esi
80104ee0:	75 de                	jne    80104ec0 <procdump+0xd0>
80104ee2:	e9 21 ff ff ff       	jmp    80104e08 <procdump+0x18>
80104ee7:	89 f6                	mov    %esi,%esi
80104ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104ef0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef3:	5b                   	pop    %ebx
80104ef4:	5e                   	pop    %esi
80104ef5:	5f                   	pop    %edi
80104ef6:	5d                   	pop    %ebp
80104ef7:	c3                   	ret    
80104ef8:	90                   	nop
80104ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f00 <getNumberOfFreePages>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
}
80104f03:	5d                   	pop    %ebp
  return getNumOfFreePages();
80104f04:	e9 e7 df ff ff       	jmp    80102ef0 <getNumOfFreePages>
80104f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f10 <getNumRefs>:

int
getNumRefs(int arrindx)
{ 
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
  return getNumRefsWarpper(arrindx);
80104f13:	5d                   	pop    %ebp
  return getNumRefsWarpper(arrindx);
80104f14:	e9 f7 40 00 00       	jmp    80109010 <getNumRefsWarpper>
80104f19:	66 90                	xchg   %ax,%ax
80104f1b:	66 90                	xchg   %ax,%ax
80104f1d:	66 90                	xchg   %ax,%ax
80104f1f:	90                   	nop

80104f20 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 0c             	sub    $0xc,%esp
80104f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104f2a:	68 94 98 10 80       	push   $0x80109894
80104f2f:	8d 43 04             	lea    0x4(%ebx),%eax
80104f32:	50                   	push   %eax
80104f33:	e8 18 01 00 00       	call   80105050 <initlock>
  lk->name = name;
80104f38:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104f3b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f41:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f44:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f4b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f51:	c9                   	leave  
80104f52:	c3                   	ret    
80104f53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
80104f65:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104f68:	83 ec 0c             	sub    $0xc,%esp
80104f6b:	8d 73 04             	lea    0x4(%ebx),%esi
80104f6e:	56                   	push   %esi
80104f6f:	e8 1c 02 00 00       	call   80105190 <acquire>
  while (lk->locked) {
80104f74:	8b 13                	mov    (%ebx),%edx
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	85 d2                	test   %edx,%edx
80104f7b:	74 16                	je     80104f93 <acquiresleep+0x33>
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104f80:	83 ec 08             	sub    $0x8,%esp
80104f83:	56                   	push   %esi
80104f84:	53                   	push   %ebx
80104f85:	e8 56 fb ff ff       	call   80104ae0 <sleep>
  while (lk->locked) {
80104f8a:	8b 03                	mov    (%ebx),%eax
80104f8c:	83 c4 10             	add    $0x10,%esp
80104f8f:	85 c0                	test   %eax,%eax
80104f91:	75 ed                	jne    80104f80 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104f93:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104f99:	e8 62 f3 ff ff       	call   80104300 <myproc>
80104f9e:	8b 40 10             	mov    0x10(%eax),%eax
80104fa1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104fa4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104fa7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104faa:	5b                   	pop    %ebx
80104fab:	5e                   	pop    %esi
80104fac:	5d                   	pop    %ebp
  release(&lk->lk);
80104fad:	e9 9e 02 00 00       	jmp    80105250 <release>
80104fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fc0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
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
80104fcf:	e8 bc 01 00 00       	call   80105190 <acquire>
  lk->locked = 0;
80104fd4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104fda:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104fe1:	89 1c 24             	mov    %ebx,(%esp)
80104fe4:	e8 27 fd ff ff       	call   80104d10 <wakeup>
  release(&lk->lk);
80104fe9:	89 75 08             	mov    %esi,0x8(%ebp)
80104fec:	83 c4 10             	add    $0x10,%esp
}
80104fef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ff2:	5b                   	pop    %ebx
80104ff3:	5e                   	pop    %esi
80104ff4:	5d                   	pop    %ebp
  release(&lk->lk);
80104ff5:	e9 56 02 00 00       	jmp    80105250 <release>
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	53                   	push   %ebx
80105006:	31 ff                	xor    %edi,%edi
80105008:	83 ec 18             	sub    $0x18,%esp
8010500b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010500e:	8d 73 04             	lea    0x4(%ebx),%esi
80105011:	56                   	push   %esi
80105012:	e8 79 01 00 00       	call   80105190 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105017:	8b 03                	mov    (%ebx),%eax
80105019:	83 c4 10             	add    $0x10,%esp
8010501c:	85 c0                	test   %eax,%eax
8010501e:	74 13                	je     80105033 <holdingsleep+0x33>
80105020:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105023:	e8 d8 f2 ff ff       	call   80104300 <myproc>
80105028:	39 58 10             	cmp    %ebx,0x10(%eax)
8010502b:	0f 94 c0             	sete   %al
8010502e:	0f b6 c0             	movzbl %al,%eax
80105031:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105033:	83 ec 0c             	sub    $0xc,%esp
80105036:	56                   	push   %esi
80105037:	e8 14 02 00 00       	call   80105250 <release>
  return r;
}
8010503c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503f:	89 f8                	mov    %edi,%eax
80105041:	5b                   	pop    %ebx
80105042:	5e                   	pop    %esi
80105043:	5f                   	pop    %edi
80105044:	5d                   	pop    %ebp
80105045:	c3                   	ret    
80105046:	66 90                	xchg   %ax,%ax
80105048:	66 90                	xchg   %ax,%ax
8010504a:	66 90                	xchg   %ax,%ax
8010504c:	66 90                	xchg   %ax,%ax
8010504e:	66 90                	xchg   %ax,%ax

80105050 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105050:	55                   	push   %ebp
80105051:	89 e5                	mov    %esp,%ebp
80105053:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105056:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105059:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010505f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105062:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105069:	5d                   	pop    %ebp
8010506a:	c3                   	ret    
8010506b:	90                   	nop
8010506c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105070 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105070:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105071:	31 d2                	xor    %edx,%edx
{
80105073:	89 e5                	mov    %esp,%ebp
80105075:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105076:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010507c:	83 e8 08             	sub    $0x8,%eax
8010507f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105080:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105086:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010508c:	77 1a                	ja     801050a8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010508e:	8b 58 04             	mov    0x4(%eax),%ebx
80105091:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105094:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105097:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105099:	83 fa 0a             	cmp    $0xa,%edx
8010509c:	75 e2                	jne    80105080 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010509e:	5b                   	pop    %ebx
8010509f:	5d                   	pop    %ebp
801050a0:	c3                   	ret    
801050a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050a8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801050ab:	83 c1 28             	add    $0x28,%ecx
801050ae:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801050b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801050b6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801050b9:	39 c1                	cmp    %eax,%ecx
801050bb:	75 f3                	jne    801050b0 <getcallerpcs+0x40>
}
801050bd:	5b                   	pop    %ebx
801050be:	5d                   	pop    %ebp
801050bf:	c3                   	ret    

801050c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 04             	sub    $0x4,%esp
801050c7:	9c                   	pushf  
801050c8:	5b                   	pop    %ebx
  asm volatile("cli");
801050c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801050ca:	e8 91 f1 ff ff       	call   80104260 <mycpu>
801050cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801050d5:	85 c0                	test   %eax,%eax
801050d7:	75 11                	jne    801050ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801050d9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801050df:	e8 7c f1 ff ff       	call   80104260 <mycpu>
801050e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801050ea:	e8 71 f1 ff ff       	call   80104260 <mycpu>
801050ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801050f6:	83 c4 04             	add    $0x4,%esp
801050f9:	5b                   	pop    %ebx
801050fa:	5d                   	pop    %ebp
801050fb:	c3                   	ret    
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105100 <popcli>:

void
popcli(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105106:	9c                   	pushf  
80105107:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105108:	f6 c4 02             	test   $0x2,%ah
8010510b:	75 35                	jne    80105142 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010510d:	e8 4e f1 ff ff       	call   80104260 <mycpu>
80105112:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105119:	78 34                	js     8010514f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010511b:	e8 40 f1 ff ff       	call   80104260 <mycpu>
80105120:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105126:	85 d2                	test   %edx,%edx
80105128:	74 06                	je     80105130 <popcli+0x30>
    sti();
}
8010512a:	c9                   	leave  
8010512b:	c3                   	ret    
8010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105130:	e8 2b f1 ff ff       	call   80104260 <mycpu>
80105135:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010513b:	85 c0                	test   %eax,%eax
8010513d:	74 eb                	je     8010512a <popcli+0x2a>
  asm volatile("sti");
8010513f:	fb                   	sti    
}
80105140:	c9                   	leave  
80105141:	c3                   	ret    
    panic("popcli - interruptible");
80105142:	83 ec 0c             	sub    $0xc,%esp
80105145:	68 9f 98 10 80       	push   $0x8010989f
8010514a:	e8 41 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010514f:	83 ec 0c             	sub    $0xc,%esp
80105152:	68 b6 98 10 80       	push   $0x801098b6
80105157:	e8 34 b2 ff ff       	call   80100390 <panic>
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <holding>:
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
80105165:	8b 75 08             	mov    0x8(%ebp),%esi
80105168:	31 db                	xor    %ebx,%ebx
  pushcli();
8010516a:	e8 51 ff ff ff       	call   801050c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010516f:	8b 06                	mov    (%esi),%eax
80105171:	85 c0                	test   %eax,%eax
80105173:	74 10                	je     80105185 <holding+0x25>
80105175:	8b 5e 08             	mov    0x8(%esi),%ebx
80105178:	e8 e3 f0 ff ff       	call   80104260 <mycpu>
8010517d:	39 c3                	cmp    %eax,%ebx
8010517f:	0f 94 c3             	sete   %bl
80105182:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105185:	e8 76 ff ff ff       	call   80105100 <popcli>
}
8010518a:	89 d8                	mov    %ebx,%eax
8010518c:	5b                   	pop    %ebx
8010518d:	5e                   	pop    %esi
8010518e:	5d                   	pop    %ebp
8010518f:	c3                   	ret    

80105190 <acquire>:
{
80105190:	55                   	push   %ebp
80105191:	89 e5                	mov    %esp,%ebp
80105193:	56                   	push   %esi
80105194:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105195:	e8 26 ff ff ff       	call   801050c0 <pushcli>
  if(holding(lk))
8010519a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010519d:	83 ec 0c             	sub    $0xc,%esp
801051a0:	53                   	push   %ebx
801051a1:	e8 ba ff ff ff       	call   80105160 <holding>
801051a6:	83 c4 10             	add    $0x10,%esp
801051a9:	85 c0                	test   %eax,%eax
801051ab:	0f 85 83 00 00 00    	jne    80105234 <acquire+0xa4>
801051b1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801051b3:	ba 01 00 00 00       	mov    $0x1,%edx
801051b8:	eb 09                	jmp    801051c3 <acquire+0x33>
801051ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801051c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051c3:	89 d0                	mov    %edx,%eax
801051c5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801051c8:	85 c0                	test   %eax,%eax
801051ca:	75 f4                	jne    801051c0 <acquire+0x30>
  __sync_synchronize();
801051cc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801051d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051d4:	e8 87 f0 ff ff       	call   80104260 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801051d9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801051dc:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801051df:	89 e8                	mov    %ebp,%eax
801051e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801051e8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801051ee:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801051f4:	77 1a                	ja     80105210 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801051f6:	8b 48 04             	mov    0x4(%eax),%ecx
801051f9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801051fc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801051ff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105201:	83 fe 0a             	cmp    $0xa,%esi
80105204:	75 e2                	jne    801051e8 <acquire+0x58>
}
80105206:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5d                   	pop    %ebp
8010520c:	c3                   	ret    
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105213:	83 c2 28             	add    $0x28,%edx
80105216:	8d 76 00             	lea    0x0(%esi),%esi
80105219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105220:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105226:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105229:	39 d0                	cmp    %edx,%eax
8010522b:	75 f3                	jne    80105220 <acquire+0x90>
}
8010522d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105230:	5b                   	pop    %ebx
80105231:	5e                   	pop    %esi
80105232:	5d                   	pop    %ebp
80105233:	c3                   	ret    
    panic("acquire");
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	68 bd 98 10 80       	push   $0x801098bd
8010523c:	e8 4f b1 ff ff       	call   80100390 <panic>
80105241:	eb 0d                	jmp    80105250 <release>
80105243:	90                   	nop
80105244:	90                   	nop
80105245:	90                   	nop
80105246:	90                   	nop
80105247:	90                   	nop
80105248:	90                   	nop
80105249:	90                   	nop
8010524a:	90                   	nop
8010524b:	90                   	nop
8010524c:	90                   	nop
8010524d:	90                   	nop
8010524e:	90                   	nop
8010524f:	90                   	nop

80105250 <release>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	53                   	push   %ebx
80105254:	83 ec 10             	sub    $0x10,%esp
80105257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010525a:	53                   	push   %ebx
8010525b:	e8 00 ff ff ff       	call   80105160 <holding>
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	85 c0                	test   %eax,%eax
80105265:	74 22                	je     80105289 <release+0x39>
  lk->pcs[0] = 0;
80105267:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010526e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105275:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010527a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105280:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105283:	c9                   	leave  
  popcli();
80105284:	e9 77 fe ff ff       	jmp    80105100 <popcli>
    panic("release");
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	68 c5 98 10 80       	push   $0x801098c5
80105291:	e8 fa b0 ff ff       	call   80100390 <panic>
80105296:	66 90                	xchg   %ax,%ax
80105298:	66 90                	xchg   %ax,%ax
8010529a:	66 90                	xchg   %ax,%ax
8010529c:	66 90                	xchg   %ax,%ax
8010529e:	66 90                	xchg   %ax,%ax

801052a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	53                   	push   %ebx
801052a5:	8b 55 08             	mov    0x8(%ebp),%edx
801052a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801052ab:	f6 c2 03             	test   $0x3,%dl
801052ae:	75 05                	jne    801052b5 <memset+0x15>
801052b0:	f6 c1 03             	test   $0x3,%cl
801052b3:	74 13                	je     801052c8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801052b5:	89 d7                	mov    %edx,%edi
801052b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ba:	fc                   	cld    
801052bb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801052bd:	5b                   	pop    %ebx
801052be:	89 d0                	mov    %edx,%eax
801052c0:	5f                   	pop    %edi
801052c1:	5d                   	pop    %ebp
801052c2:	c3                   	ret    
801052c3:	90                   	nop
801052c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801052c8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801052cc:	c1 e9 02             	shr    $0x2,%ecx
801052cf:	89 f8                	mov    %edi,%eax
801052d1:	89 fb                	mov    %edi,%ebx
801052d3:	c1 e0 18             	shl    $0x18,%eax
801052d6:	c1 e3 10             	shl    $0x10,%ebx
801052d9:	09 d8                	or     %ebx,%eax
801052db:	09 f8                	or     %edi,%eax
801052dd:	c1 e7 08             	shl    $0x8,%edi
801052e0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801052e2:	89 d7                	mov    %edx,%edi
801052e4:	fc                   	cld    
801052e5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801052e7:	5b                   	pop    %ebx
801052e8:	89 d0                	mov    %edx,%eax
801052ea:	5f                   	pop    %edi
801052eb:	5d                   	pop    %ebp
801052ec:	c3                   	ret    
801052ed:	8d 76 00             	lea    0x0(%esi),%esi

801052f0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
801052f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801052f9:	8b 75 08             	mov    0x8(%ebp),%esi
801052fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801052ff:	85 db                	test   %ebx,%ebx
80105301:	74 29                	je     8010532c <memcmp+0x3c>
    if(*s1 != *s2)
80105303:	0f b6 16             	movzbl (%esi),%edx
80105306:	0f b6 0f             	movzbl (%edi),%ecx
80105309:	38 d1                	cmp    %dl,%cl
8010530b:	75 2b                	jne    80105338 <memcmp+0x48>
8010530d:	b8 01 00 00 00       	mov    $0x1,%eax
80105312:	eb 14                	jmp    80105328 <memcmp+0x38>
80105314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105318:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010531c:	83 c0 01             	add    $0x1,%eax
8010531f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105324:	38 ca                	cmp    %cl,%dl
80105326:	75 10                	jne    80105338 <memcmp+0x48>
  while(n-- > 0){
80105328:	39 d8                	cmp    %ebx,%eax
8010532a:	75 ec                	jne    80105318 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010532c:	5b                   	pop    %ebx
  return 0;
8010532d:	31 c0                	xor    %eax,%eax
}
8010532f:	5e                   	pop    %esi
80105330:	5f                   	pop    %edi
80105331:	5d                   	pop    %ebp
80105332:	c3                   	ret    
80105333:	90                   	nop
80105334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105338:	0f b6 c2             	movzbl %dl,%eax
}
8010533b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010533c:	29 c8                	sub    %ecx,%eax
}
8010533e:	5e                   	pop    %esi
8010533f:	5f                   	pop    %edi
80105340:	5d                   	pop    %ebp
80105341:	c3                   	ret    
80105342:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105350 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105350:	55                   	push   %ebp
80105351:	89 e5                	mov    %esp,%ebp
80105353:	56                   	push   %esi
80105354:	53                   	push   %ebx
80105355:	8b 45 08             	mov    0x8(%ebp),%eax
80105358:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010535b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010535e:	39 c3                	cmp    %eax,%ebx
80105360:	73 26                	jae    80105388 <memmove+0x38>
80105362:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105365:	39 c8                	cmp    %ecx,%eax
80105367:	73 1f                	jae    80105388 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105369:	85 f6                	test   %esi,%esi
8010536b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010536e:	74 0f                	je     8010537f <memmove+0x2f>
      *--d = *--s;
80105370:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105374:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105377:	83 ea 01             	sub    $0x1,%edx
8010537a:	83 fa ff             	cmp    $0xffffffff,%edx
8010537d:	75 f1                	jne    80105370 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010537f:	5b                   	pop    %ebx
80105380:	5e                   	pop    %esi
80105381:	5d                   	pop    %ebp
80105382:	c3                   	ret    
80105383:	90                   	nop
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105388:	31 d2                	xor    %edx,%edx
8010538a:	85 f6                	test   %esi,%esi
8010538c:	74 f1                	je     8010537f <memmove+0x2f>
8010538e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105390:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105394:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105397:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010539a:	39 d6                	cmp    %edx,%esi
8010539c:	75 f2                	jne    80105390 <memmove+0x40>
}
8010539e:	5b                   	pop    %ebx
8010539f:	5e                   	pop    %esi
801053a0:	5d                   	pop    %ebp
801053a1:	c3                   	ret    
801053a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801053b3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801053b4:	eb 9a                	jmp    80105350 <memmove>
801053b6:	8d 76 00             	lea    0x0(%esi),%esi
801053b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053c0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
801053c5:	8b 7d 10             	mov    0x10(%ebp),%edi
801053c8:	53                   	push   %ebx
801053c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801053cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801053cf:	85 ff                	test   %edi,%edi
801053d1:	74 2f                	je     80105402 <strncmp+0x42>
801053d3:	0f b6 01             	movzbl (%ecx),%eax
801053d6:	0f b6 1e             	movzbl (%esi),%ebx
801053d9:	84 c0                	test   %al,%al
801053db:	74 37                	je     80105414 <strncmp+0x54>
801053dd:	38 c3                	cmp    %al,%bl
801053df:	75 33                	jne    80105414 <strncmp+0x54>
801053e1:	01 f7                	add    %esi,%edi
801053e3:	eb 13                	jmp    801053f8 <strncmp+0x38>
801053e5:	8d 76 00             	lea    0x0(%esi),%esi
801053e8:	0f b6 01             	movzbl (%ecx),%eax
801053eb:	84 c0                	test   %al,%al
801053ed:	74 21                	je     80105410 <strncmp+0x50>
801053ef:	0f b6 1a             	movzbl (%edx),%ebx
801053f2:	89 d6                	mov    %edx,%esi
801053f4:	38 d8                	cmp    %bl,%al
801053f6:	75 1c                	jne    80105414 <strncmp+0x54>
    n--, p++, q++;
801053f8:	8d 56 01             	lea    0x1(%esi),%edx
801053fb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801053fe:	39 fa                	cmp    %edi,%edx
80105400:	75 e6                	jne    801053e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105402:	5b                   	pop    %ebx
    return 0;
80105403:	31 c0                	xor    %eax,%eax
}
80105405:	5e                   	pop    %esi
80105406:	5f                   	pop    %edi
80105407:	5d                   	pop    %ebp
80105408:	c3                   	ret    
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105410:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105414:	29 d8                	sub    %ebx,%eax
}
80105416:	5b                   	pop    %ebx
80105417:	5e                   	pop    %esi
80105418:	5f                   	pop    %edi
80105419:	5d                   	pop    %ebp
8010541a:	c3                   	ret    
8010541b:	90                   	nop
8010541c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105420 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	53                   	push   %ebx
80105425:	8b 45 08             	mov    0x8(%ebp),%eax
80105428:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010542b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010542e:	89 c2                	mov    %eax,%edx
80105430:	eb 19                	jmp    8010544b <strncpy+0x2b>
80105432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105438:	83 c3 01             	add    $0x1,%ebx
8010543b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010543f:	83 c2 01             	add    $0x1,%edx
80105442:	84 c9                	test   %cl,%cl
80105444:	88 4a ff             	mov    %cl,-0x1(%edx)
80105447:	74 09                	je     80105452 <strncpy+0x32>
80105449:	89 f1                	mov    %esi,%ecx
8010544b:	85 c9                	test   %ecx,%ecx
8010544d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105450:	7f e6                	jg     80105438 <strncpy+0x18>
    ;
  while(n-- > 0)
80105452:	31 c9                	xor    %ecx,%ecx
80105454:	85 f6                	test   %esi,%esi
80105456:	7e 17                	jle    8010546f <strncpy+0x4f>
80105458:	90                   	nop
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105460:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105464:	89 f3                	mov    %esi,%ebx
80105466:	83 c1 01             	add    $0x1,%ecx
80105469:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010546b:	85 db                	test   %ebx,%ebx
8010546d:	7f f1                	jg     80105460 <strncpy+0x40>
  return os;
}
8010546f:	5b                   	pop    %ebx
80105470:	5e                   	pop    %esi
80105471:	5d                   	pop    %ebp
80105472:	c3                   	ret    
80105473:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105480 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	56                   	push   %esi
80105484:	53                   	push   %ebx
80105485:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105488:	8b 45 08             	mov    0x8(%ebp),%eax
8010548b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010548e:	85 c9                	test   %ecx,%ecx
80105490:	7e 26                	jle    801054b8 <safestrcpy+0x38>
80105492:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105496:	89 c1                	mov    %eax,%ecx
80105498:	eb 17                	jmp    801054b1 <safestrcpy+0x31>
8010549a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801054a0:	83 c2 01             	add    $0x1,%edx
801054a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801054a7:	83 c1 01             	add    $0x1,%ecx
801054aa:	84 db                	test   %bl,%bl
801054ac:	88 59 ff             	mov    %bl,-0x1(%ecx)
801054af:	74 04                	je     801054b5 <safestrcpy+0x35>
801054b1:	39 f2                	cmp    %esi,%edx
801054b3:	75 eb                	jne    801054a0 <safestrcpy+0x20>
    ;
  *s = 0;
801054b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801054b8:	5b                   	pop    %ebx
801054b9:	5e                   	pop    %esi
801054ba:	5d                   	pop    %ebp
801054bb:	c3                   	ret    
801054bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054c0 <strlen>:

int
strlen(const char *s)
{
801054c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801054c1:	31 c0                	xor    %eax,%eax
{
801054c3:	89 e5                	mov    %esp,%ebp
801054c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801054c8:	80 3a 00             	cmpb   $0x0,(%edx)
801054cb:	74 0c                	je     801054d9 <strlen+0x19>
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
801054d0:	83 c0 01             	add    $0x1,%eax
801054d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801054d7:	75 f7                	jne    801054d0 <strlen+0x10>
    ;
  return n;
}
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    

801054db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801054db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801054df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801054e3:	55                   	push   %ebp
  pushl %ebx
801054e4:	53                   	push   %ebx
  pushl %esi
801054e5:	56                   	push   %esi
  pushl %edi
801054e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801054e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801054e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801054eb:	5f                   	pop    %edi
  popl %esi
801054ec:	5e                   	pop    %esi
  popl %ebx
801054ed:	5b                   	pop    %ebx
  popl %ebp
801054ee:	5d                   	pop    %ebp
  ret
801054ef:	c3                   	ret    

801054f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	53                   	push   %ebx
801054f4:	83 ec 04             	sub    $0x4,%esp
801054f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801054fa:	e8 01 ee ff ff       	call   80104300 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801054ff:	8b 00                	mov    (%eax),%eax
80105501:	39 d8                	cmp    %ebx,%eax
80105503:	76 1b                	jbe    80105520 <fetchint+0x30>
80105505:	8d 53 04             	lea    0x4(%ebx),%edx
80105508:	39 d0                	cmp    %edx,%eax
8010550a:	72 14                	jb     80105520 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010550c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010550f:	8b 13                	mov    (%ebx),%edx
80105511:	89 10                	mov    %edx,(%eax)
  return 0;
80105513:	31 c0                	xor    %eax,%eax
}
80105515:	83 c4 04             	add    $0x4,%esp
80105518:	5b                   	pop    %ebx
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    
8010551b:	90                   	nop
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105525:	eb ee                	jmp    80105515 <fetchint+0x25>
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
80105534:	83 ec 04             	sub    $0x4,%esp
80105537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010553a:	e8 c1 ed ff ff       	call   80104300 <myproc>

  if(addr >= curproc->sz)
8010553f:	39 18                	cmp    %ebx,(%eax)
80105541:	76 29                	jbe    8010556c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105546:	89 da                	mov    %ebx,%edx
80105548:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010554a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010554c:	39 c3                	cmp    %eax,%ebx
8010554e:	73 1c                	jae    8010556c <fetchstr+0x3c>
    if(*s == 0)
80105550:	80 3b 00             	cmpb   $0x0,(%ebx)
80105553:	75 10                	jne    80105565 <fetchstr+0x35>
80105555:	eb 39                	jmp    80105590 <fetchstr+0x60>
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105560:	80 3a 00             	cmpb   $0x0,(%edx)
80105563:	74 1b                	je     80105580 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105565:	83 c2 01             	add    $0x1,%edx
80105568:	39 d0                	cmp    %edx,%eax
8010556a:	77 f4                	ja     80105560 <fetchstr+0x30>
    return -1;
8010556c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105571:	83 c4 04             	add    $0x4,%esp
80105574:	5b                   	pop    %ebx
80105575:	5d                   	pop    %ebp
80105576:	c3                   	ret    
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105580:	83 c4 04             	add    $0x4,%esp
80105583:	89 d0                	mov    %edx,%eax
80105585:	29 d8                	sub    %ebx,%eax
80105587:	5b                   	pop    %ebx
80105588:	5d                   	pop    %ebp
80105589:	c3                   	ret    
8010558a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105590:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105592:	eb dd                	jmp    80105571 <fetchstr+0x41>
80105594:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010559a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801055a0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	56                   	push   %esi
801055a4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055a5:	e8 56 ed ff ff       	call   80104300 <myproc>
801055aa:	8b 40 18             	mov    0x18(%eax),%eax
801055ad:	8b 55 08             	mov    0x8(%ebp),%edx
801055b0:	8b 40 44             	mov    0x44(%eax),%eax
801055b3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055b6:	e8 45 ed ff ff       	call   80104300 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055bb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055bd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055c0:	39 c6                	cmp    %eax,%esi
801055c2:	73 1c                	jae    801055e0 <argint+0x40>
801055c4:	8d 53 08             	lea    0x8(%ebx),%edx
801055c7:	39 d0                	cmp    %edx,%eax
801055c9:	72 15                	jb     801055e0 <argint+0x40>
  *ip = *(int*)(addr);
801055cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ce:	8b 53 04             	mov    0x4(%ebx),%edx
801055d1:	89 10                	mov    %edx,(%eax)
  return 0;
801055d3:	31 c0                	xor    %eax,%eax
}
801055d5:	5b                   	pop    %ebx
801055d6:	5e                   	pop    %esi
801055d7:	5d                   	pop    %ebp
801055d8:	c3                   	ret    
801055d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055e5:	eb ee                	jmp    801055d5 <argint+0x35>
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
801055f5:	83 ec 10             	sub    $0x10,%esp
801055f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801055fb:	e8 00 ed ff ff       	call   80104300 <myproc>
80105600:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105602:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105605:	83 ec 08             	sub    $0x8,%esp
80105608:	50                   	push   %eax
80105609:	ff 75 08             	pushl  0x8(%ebp)
8010560c:	e8 8f ff ff ff       	call   801055a0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105611:	83 c4 10             	add    $0x10,%esp
80105614:	85 c0                	test   %eax,%eax
80105616:	78 28                	js     80105640 <argptr+0x50>
80105618:	85 db                	test   %ebx,%ebx
8010561a:	78 24                	js     80105640 <argptr+0x50>
8010561c:	8b 16                	mov    (%esi),%edx
8010561e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105621:	39 c2                	cmp    %eax,%edx
80105623:	76 1b                	jbe    80105640 <argptr+0x50>
80105625:	01 c3                	add    %eax,%ebx
80105627:	39 da                	cmp    %ebx,%edx
80105629:	72 15                	jb     80105640 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010562b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010562e:	89 02                	mov    %eax,(%edx)
  return 0;
80105630:	31 c0                	xor    %eax,%eax
}
80105632:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105635:	5b                   	pop    %ebx
80105636:	5e                   	pop    %esi
80105637:	5d                   	pop    %ebp
80105638:	c3                   	ret    
80105639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105645:	eb eb                	jmp    80105632 <argptr+0x42>
80105647:	89 f6                	mov    %esi,%esi
80105649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105650 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105650:	55                   	push   %ebp
80105651:	89 e5                	mov    %esp,%ebp
80105653:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105656:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105659:	50                   	push   %eax
8010565a:	ff 75 08             	pushl  0x8(%ebp)
8010565d:	e8 3e ff ff ff       	call   801055a0 <argint>
80105662:	83 c4 10             	add    $0x10,%esp
80105665:	85 c0                	test   %eax,%eax
80105667:	78 17                	js     80105680 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105669:	83 ec 08             	sub    $0x8,%esp
8010566c:	ff 75 0c             	pushl  0xc(%ebp)
8010566f:	ff 75 f4             	pushl  -0xc(%ebp)
80105672:	e8 b9 fe ff ff       	call   80105530 <fetchstr>
80105677:	83 c4 10             	add    $0x10,%esp
}
8010567a:	c9                   	leave  
8010567b:	c3                   	ret    
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105685:	c9                   	leave  
80105686:	c3                   	ret    
80105687:	89 f6                	mov    %esi,%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105690 <syscall>:
[SYS_getNumRefs]           sys_getNumRefs
};

void
syscall(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	53                   	push   %ebx
80105694:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105697:	e8 64 ec ff ff       	call   80104300 <myproc>
8010569c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010569e:	8b 40 18             	mov    0x18(%eax),%eax
801056a1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801056a4:	8d 50 ff             	lea    -0x1(%eax),%edx
801056a7:	83 fa 17             	cmp    $0x17,%edx
801056aa:	77 1c                	ja     801056c8 <syscall+0x38>
801056ac:	8b 14 85 00 99 10 80 	mov    -0x7fef6700(,%eax,4),%edx
801056b3:	85 d2                	test   %edx,%edx
801056b5:	74 11                	je     801056c8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801056b7:	ff d2                	call   *%edx
801056b9:	8b 53 18             	mov    0x18(%ebx),%edx
801056bc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801056bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c2:	c9                   	leave  
801056c3:	c3                   	ret    
801056c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801056c8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801056c9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801056cc:	50                   	push   %eax
801056cd:	ff 73 10             	pushl  0x10(%ebx)
801056d0:	68 cd 98 10 80       	push   $0x801098cd
801056d5:	e8 86 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
801056da:	8b 43 18             	mov    0x18(%ebx),%eax
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801056e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056ea:	c9                   	leave  
801056eb:	c3                   	ret    
801056ec:	66 90                	xchg   %ax,%ax
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	56                   	push   %esi
801056f4:	53                   	push   %ebx
801056f5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801056fa:	89 d6                	mov    %edx,%esi
801056fc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056ff:	50                   	push   %eax
80105700:	6a 00                	push   $0x0
80105702:	e8 99 fe ff ff       	call   801055a0 <argint>
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	85 c0                	test   %eax,%eax
8010570c:	78 2a                	js     80105738 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010570e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105712:	77 24                	ja     80105738 <argfd.constprop.0+0x48>
80105714:	e8 e7 eb ff ff       	call   80104300 <myproc>
80105719:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010571c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105720:	85 c0                	test   %eax,%eax
80105722:	74 14                	je     80105738 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105724:	85 db                	test   %ebx,%ebx
80105726:	74 02                	je     8010572a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105728:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010572a:	89 06                	mov    %eax,(%esi)
  return 0;
8010572c:	31 c0                	xor    %eax,%eax
}
8010572e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105731:	5b                   	pop    %ebx
80105732:	5e                   	pop    %esi
80105733:	5d                   	pop    %ebp
80105734:	c3                   	ret    
80105735:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573d:	eb ef                	jmp    8010572e <argfd.constprop.0+0x3e>
8010573f:	90                   	nop

80105740 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105740:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105741:	31 c0                	xor    %eax,%eax
{
80105743:	89 e5                	mov    %esp,%ebp
80105745:	56                   	push   %esi
80105746:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105747:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010574a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010574d:	e8 9e ff ff ff       	call   801056f0 <argfd.constprop.0>
80105752:	85 c0                	test   %eax,%eax
80105754:	78 42                	js     80105798 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105756:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105759:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010575b:	e8 a0 eb ff ff       	call   80104300 <myproc>
80105760:	eb 0e                	jmp    80105770 <sys_dup+0x30>
80105762:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105768:	83 c3 01             	add    $0x1,%ebx
8010576b:	83 fb 10             	cmp    $0x10,%ebx
8010576e:	74 28                	je     80105798 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105770:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105774:	85 d2                	test   %edx,%edx
80105776:	75 f0                	jne    80105768 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105778:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010577c:	83 ec 0c             	sub    $0xc,%esp
8010577f:	ff 75 f4             	pushl  -0xc(%ebp)
80105782:	e8 09 ba ff ff       	call   80101190 <filedup>
  return fd;
80105787:	83 c4 10             	add    $0x10,%esp
}
8010578a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010578d:	89 d8                	mov    %ebx,%eax
8010578f:	5b                   	pop    %ebx
80105790:	5e                   	pop    %esi
80105791:	5d                   	pop    %ebp
80105792:	c3                   	ret    
80105793:	90                   	nop
80105794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105798:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010579b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801057a0:	89 d8                	mov    %ebx,%eax
801057a2:	5b                   	pop    %ebx
801057a3:	5e                   	pop    %esi
801057a4:	5d                   	pop    %ebp
801057a5:	c3                   	ret    
801057a6:	8d 76 00             	lea    0x0(%esi),%esi
801057a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057b0 <sys_read>:

int
sys_read(void)
{
801057b0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057b1:	31 c0                	xor    %eax,%eax
{
801057b3:	89 e5                	mov    %esp,%ebp
801057b5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057b8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801057bb:	e8 30 ff ff ff       	call   801056f0 <argfd.constprop.0>
801057c0:	85 c0                	test   %eax,%eax
801057c2:	78 4c                	js     80105810 <sys_read+0x60>
801057c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057c7:	83 ec 08             	sub    $0x8,%esp
801057ca:	50                   	push   %eax
801057cb:	6a 02                	push   $0x2
801057cd:	e8 ce fd ff ff       	call   801055a0 <argint>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	78 37                	js     80105810 <sys_read+0x60>
801057d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057dc:	83 ec 04             	sub    $0x4,%esp
801057df:	ff 75 f0             	pushl  -0x10(%ebp)
801057e2:	50                   	push   %eax
801057e3:	6a 01                	push   $0x1
801057e5:	e8 06 fe ff ff       	call   801055f0 <argptr>
801057ea:	83 c4 10             	add    $0x10,%esp
801057ed:	85 c0                	test   %eax,%eax
801057ef:	78 1f                	js     80105810 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801057f1:	83 ec 04             	sub    $0x4,%esp
801057f4:	ff 75 f0             	pushl  -0x10(%ebp)
801057f7:	ff 75 f4             	pushl  -0xc(%ebp)
801057fa:	ff 75 ec             	pushl  -0x14(%ebp)
801057fd:	e8 fe ba ff ff       	call   80101300 <fileread>
80105802:	83 c4 10             	add    $0x10,%esp
}
80105805:	c9                   	leave  
80105806:	c3                   	ret    
80105807:	89 f6                	mov    %esi,%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105810:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105815:	c9                   	leave  
80105816:	c3                   	ret    
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105820 <sys_write>:

int
sys_write(void)
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
8010582b:	e8 c0 fe ff ff       	call   801056f0 <argfd.constprop.0>
80105830:	85 c0                	test   %eax,%eax
80105832:	78 4c                	js     80105880 <sys_write+0x60>
80105834:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 02                	push   $0x2
8010583d:	e8 5e fd ff ff       	call   801055a0 <argint>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 37                	js     80105880 <sys_write+0x60>
80105849:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010584c:	83 ec 04             	sub    $0x4,%esp
8010584f:	ff 75 f0             	pushl  -0x10(%ebp)
80105852:	50                   	push   %eax
80105853:	6a 01                	push   $0x1
80105855:	e8 96 fd ff ff       	call   801055f0 <argptr>
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	85 c0                	test   %eax,%eax
8010585f:	78 1f                	js     80105880 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105861:	83 ec 04             	sub    $0x4,%esp
80105864:	ff 75 f0             	pushl  -0x10(%ebp)
80105867:	ff 75 f4             	pushl  -0xc(%ebp)
8010586a:	ff 75 ec             	pushl  -0x14(%ebp)
8010586d:	e8 1e bb ff ff       	call   80101390 <filewrite>
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

80105890 <sys_close>:

int
sys_close(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105896:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105899:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010589c:	e8 4f fe ff ff       	call   801056f0 <argfd.constprop.0>
801058a1:	85 c0                	test   %eax,%eax
801058a3:	78 2b                	js     801058d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801058a5:	e8 56 ea ff ff       	call   80104300 <myproc>
801058aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801058ad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801058b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801058b7:	00 
  fileclose(f);
801058b8:	ff 75 f4             	pushl  -0xc(%ebp)
801058bb:	e8 20 b9 ff ff       	call   801011e0 <fileclose>
  return 0;
801058c0:	83 c4 10             	add    $0x10,%esp
801058c3:	31 c0                	xor    %eax,%eax
}
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d5:	c9                   	leave  
801058d6:	c3                   	ret    
801058d7:	89 f6                	mov    %esi,%esi
801058d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058e0 <sys_fstat>:

int
sys_fstat(void)
{
801058e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058e1:	31 c0                	xor    %eax,%eax
{
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801058eb:	e8 00 fe ff ff       	call   801056f0 <argfd.constprop.0>
801058f0:	85 c0                	test   %eax,%eax
801058f2:	78 2c                	js     80105920 <sys_fstat+0x40>
801058f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058f7:	83 ec 04             	sub    $0x4,%esp
801058fa:	6a 14                	push   $0x14
801058fc:	50                   	push   %eax
801058fd:	6a 01                	push   $0x1
801058ff:	e8 ec fc ff ff       	call   801055f0 <argptr>
80105904:	83 c4 10             	add    $0x10,%esp
80105907:	85 c0                	test   %eax,%eax
80105909:	78 15                	js     80105920 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010590b:	83 ec 08             	sub    $0x8,%esp
8010590e:	ff 75 f4             	pushl  -0xc(%ebp)
80105911:	ff 75 f0             	pushl  -0x10(%ebp)
80105914:	e8 97 b9 ff ff       	call   801012b0 <filestat>
80105919:	83 c4 10             	add    $0x10,%esp
}
8010591c:	c9                   	leave  
8010591d:	c3                   	ret    
8010591e:	66 90                	xchg   %ax,%ax
    return -1;
80105920:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105925:	c9                   	leave  
80105926:	c3                   	ret    
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105930 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105930:	55                   	push   %ebp
80105931:	89 e5                	mov    %esp,%ebp
80105933:	57                   	push   %edi
80105934:	56                   	push   %esi
80105935:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105936:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105939:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010593c:	50                   	push   %eax
8010593d:	6a 00                	push   $0x0
8010593f:	e8 0c fd ff ff       	call   80105650 <argstr>
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	85 c0                	test   %eax,%eax
80105949:	0f 88 fb 00 00 00    	js     80105a4a <sys_link+0x11a>
8010594f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105952:	83 ec 08             	sub    $0x8,%esp
80105955:	50                   	push   %eax
80105956:	6a 01                	push   $0x1
80105958:	e8 f3 fc ff ff       	call   80105650 <argstr>
8010595d:	83 c4 10             	add    $0x10,%esp
80105960:	85 c0                	test   %eax,%eax
80105962:	0f 88 e2 00 00 00    	js     80105a4a <sys_link+0x11a>
    return -1;

  begin_op();
80105968:	e8 13 dc ff ff       	call   80103580 <begin_op>
  if((ip = namei(old)) == 0){
8010596d:	83 ec 0c             	sub    $0xc,%esp
80105970:	ff 75 d4             	pushl  -0x2c(%ebp)
80105973:	e8 08 c9 ff ff       	call   80102280 <namei>
80105978:	83 c4 10             	add    $0x10,%esp
8010597b:	85 c0                	test   %eax,%eax
8010597d:	89 c3                	mov    %eax,%ebx
8010597f:	0f 84 ea 00 00 00    	je     80105a6f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105985:	83 ec 0c             	sub    $0xc,%esp
80105988:	50                   	push   %eax
80105989:	e8 92 c0 ff ff       	call   80101a20 <ilock>
  if(ip->type == T_DIR){
8010598e:	83 c4 10             	add    $0x10,%esp
80105991:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105996:	0f 84 bb 00 00 00    	je     80105a57 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010599c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801059a1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801059a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801059a7:	53                   	push   %ebx
801059a8:	e8 c3 bf ff ff       	call   80101970 <iupdate>
  iunlock(ip);
801059ad:	89 1c 24             	mov    %ebx,(%esp)
801059b0:	e8 4b c1 ff ff       	call   80101b00 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801059b5:	58                   	pop    %eax
801059b6:	5a                   	pop    %edx
801059b7:	57                   	push   %edi
801059b8:	ff 75 d0             	pushl  -0x30(%ebp)
801059bb:	e8 e0 c8 ff ff       	call   801022a0 <nameiparent>
801059c0:	83 c4 10             	add    $0x10,%esp
801059c3:	85 c0                	test   %eax,%eax
801059c5:	89 c6                	mov    %eax,%esi
801059c7:	74 5b                	je     80105a24 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801059c9:	83 ec 0c             	sub    $0xc,%esp
801059cc:	50                   	push   %eax
801059cd:	e8 4e c0 ff ff       	call   80101a20 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059d2:	83 c4 10             	add    $0x10,%esp
801059d5:	8b 03                	mov    (%ebx),%eax
801059d7:	39 06                	cmp    %eax,(%esi)
801059d9:	75 3d                	jne    80105a18 <sys_link+0xe8>
801059db:	83 ec 04             	sub    $0x4,%esp
801059de:	ff 73 04             	pushl  0x4(%ebx)
801059e1:	57                   	push   %edi
801059e2:	56                   	push   %esi
801059e3:	e8 d8 c7 ff ff       	call   801021c0 <dirlink>
801059e8:	83 c4 10             	add    $0x10,%esp
801059eb:	85 c0                	test   %eax,%eax
801059ed:	78 29                	js     80105a18 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801059ef:	83 ec 0c             	sub    $0xc,%esp
801059f2:	56                   	push   %esi
801059f3:	e8 b8 c2 ff ff       	call   80101cb0 <iunlockput>
  iput(ip);
801059f8:	89 1c 24             	mov    %ebx,(%esp)
801059fb:	e8 50 c1 ff ff       	call   80101b50 <iput>

  end_op();
80105a00:	e8 eb db ff ff       	call   801035f0 <end_op>

  return 0;
80105a05:	83 c4 10             	add    $0x10,%esp
80105a08:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105a0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a0d:	5b                   	pop    %ebx
80105a0e:	5e                   	pop    %esi
80105a0f:	5f                   	pop    %edi
80105a10:	5d                   	pop    %ebp
80105a11:	c3                   	ret    
80105a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a18:	83 ec 0c             	sub    $0xc,%esp
80105a1b:	56                   	push   %esi
80105a1c:	e8 8f c2 ff ff       	call   80101cb0 <iunlockput>
    goto bad;
80105a21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a24:	83 ec 0c             	sub    $0xc,%esp
80105a27:	53                   	push   %ebx
80105a28:	e8 f3 bf ff ff       	call   80101a20 <ilock>
  ip->nlink--;
80105a2d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a32:	89 1c 24             	mov    %ebx,(%esp)
80105a35:	e8 36 bf ff ff       	call   80101970 <iupdate>
  iunlockput(ip);
80105a3a:	89 1c 24             	mov    %ebx,(%esp)
80105a3d:	e8 6e c2 ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105a42:	e8 a9 db ff ff       	call   801035f0 <end_op>
  return -1;
80105a47:	83 c4 10             	add    $0x10,%esp
}
80105a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105a4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a52:	5b                   	pop    %ebx
80105a53:	5e                   	pop    %esi
80105a54:	5f                   	pop    %edi
80105a55:	5d                   	pop    %ebp
80105a56:	c3                   	ret    
    iunlockput(ip);
80105a57:	83 ec 0c             	sub    $0xc,%esp
80105a5a:	53                   	push   %ebx
80105a5b:	e8 50 c2 ff ff       	call   80101cb0 <iunlockput>
    end_op();
80105a60:	e8 8b db ff ff       	call   801035f0 <end_op>
    return -1;
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6d:	eb 9b                	jmp    80105a0a <sys_link+0xda>
    end_op();
80105a6f:	e8 7c db ff ff       	call   801035f0 <end_op>
    return -1;
80105a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a79:	eb 8f                	jmp    80105a0a <sys_link+0xda>
80105a7b:	90                   	nop
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a80 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105a80:	55                   	push   %ebp
80105a81:	89 e5                	mov    %esp,%ebp
80105a83:	57                   	push   %edi
80105a84:	56                   	push   %esi
80105a85:	53                   	push   %ebx
80105a86:	83 ec 1c             	sub    $0x1c,%esp
80105a89:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105a8c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105a90:	76 3e                	jbe    80105ad0 <isdirempty+0x50>
80105a92:	bb 20 00 00 00       	mov    $0x20,%ebx
80105a97:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105a9a:	eb 0c                	jmp    80105aa8 <isdirempty+0x28>
80105a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aa0:	83 c3 10             	add    $0x10,%ebx
80105aa3:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105aa6:	73 28                	jae    80105ad0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105aa8:	6a 10                	push   $0x10
80105aaa:	53                   	push   %ebx
80105aab:	57                   	push   %edi
80105aac:	56                   	push   %esi
80105aad:	e8 4e c2 ff ff       	call   80101d00 <readi>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	83 f8 10             	cmp    $0x10,%eax
80105ab8:	75 23                	jne    80105add <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105aba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105abf:	74 df                	je     80105aa0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105ac4:	31 c0                	xor    %eax,%eax
}
80105ac6:	5b                   	pop    %ebx
80105ac7:	5e                   	pop    %esi
80105ac8:	5f                   	pop    %edi
80105ac9:	5d                   	pop    %ebp
80105aca:	c3                   	ret    
80105acb:	90                   	nop
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105ad3:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ad8:	5b                   	pop    %ebx
80105ad9:	5e                   	pop    %esi
80105ada:	5f                   	pop    %edi
80105adb:	5d                   	pop    %ebp
80105adc:	c3                   	ret    
      panic("isdirempty: readi");
80105add:	83 ec 0c             	sub    $0xc,%esp
80105ae0:	68 64 99 10 80       	push   $0x80109964
80105ae5:	e8 a6 a8 ff ff       	call   80100390 <panic>
80105aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105af0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105af6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105af9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105afc:	50                   	push   %eax
80105afd:	6a 00                	push   $0x0
80105aff:	e8 4c fb ff ff       	call   80105650 <argstr>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	85 c0                	test   %eax,%eax
80105b09:	0f 88 51 01 00 00    	js     80105c60 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b0f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105b12:	e8 69 da ff ff       	call   80103580 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b17:	83 ec 08             	sub    $0x8,%esp
80105b1a:	53                   	push   %ebx
80105b1b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b1e:	e8 7d c7 ff ff       	call   801022a0 <nameiparent>
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 c0                	test   %eax,%eax
80105b28:	89 c6                	mov    %eax,%esi
80105b2a:	0f 84 37 01 00 00    	je     80105c67 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	50                   	push   %eax
80105b34:	e8 e7 be ff ff       	call   80101a20 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b39:	58                   	pop    %eax
80105b3a:	5a                   	pop    %edx
80105b3b:	68 1f 92 10 80       	push   $0x8010921f
80105b40:	53                   	push   %ebx
80105b41:	e8 ea c3 ff ff       	call   80101f30 <namecmp>
80105b46:	83 c4 10             	add    $0x10,%esp
80105b49:	85 c0                	test   %eax,%eax
80105b4b:	0f 84 d7 00 00 00    	je     80105c28 <sys_unlink+0x138>
80105b51:	83 ec 08             	sub    $0x8,%esp
80105b54:	68 1e 92 10 80       	push   $0x8010921e
80105b59:	53                   	push   %ebx
80105b5a:	e8 d1 c3 ff ff       	call   80101f30 <namecmp>
80105b5f:	83 c4 10             	add    $0x10,%esp
80105b62:	85 c0                	test   %eax,%eax
80105b64:	0f 84 be 00 00 00    	je     80105c28 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105b6a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b6d:	83 ec 04             	sub    $0x4,%esp
80105b70:	50                   	push   %eax
80105b71:	53                   	push   %ebx
80105b72:	56                   	push   %esi
80105b73:	e8 d8 c3 ff ff       	call   80101f50 <dirlookup>
80105b78:	83 c4 10             	add    $0x10,%esp
80105b7b:	85 c0                	test   %eax,%eax
80105b7d:	89 c3                	mov    %eax,%ebx
80105b7f:	0f 84 a3 00 00 00    	je     80105c28 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105b85:	83 ec 0c             	sub    $0xc,%esp
80105b88:	50                   	push   %eax
80105b89:	e8 92 be ff ff       	call   80101a20 <ilock>

  if(ip->nlink < 1)
80105b8e:	83 c4 10             	add    $0x10,%esp
80105b91:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b96:	0f 8e e4 00 00 00    	jle    80105c80 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105ba1:	74 65                	je     80105c08 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105ba3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105ba6:	83 ec 04             	sub    $0x4,%esp
80105ba9:	6a 10                	push   $0x10
80105bab:	6a 00                	push   $0x0
80105bad:	57                   	push   %edi
80105bae:	e8 ed f6 ff ff       	call   801052a0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bb3:	6a 10                	push   $0x10
80105bb5:	ff 75 c4             	pushl  -0x3c(%ebp)
80105bb8:	57                   	push   %edi
80105bb9:	56                   	push   %esi
80105bba:	e8 41 c2 ff ff       	call   80101e00 <writei>
80105bbf:	83 c4 20             	add    $0x20,%esp
80105bc2:	83 f8 10             	cmp    $0x10,%eax
80105bc5:	0f 85 a8 00 00 00    	jne    80105c73 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105bcb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105bd0:	74 6e                	je     80105c40 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105bd2:	83 ec 0c             	sub    $0xc,%esp
80105bd5:	56                   	push   %esi
80105bd6:	e8 d5 c0 ff ff       	call   80101cb0 <iunlockput>

  ip->nlink--;
80105bdb:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105be0:	89 1c 24             	mov    %ebx,(%esp)
80105be3:	e8 88 bd ff ff       	call   80101970 <iupdate>
  iunlockput(ip);
80105be8:	89 1c 24             	mov    %ebx,(%esp)
80105beb:	e8 c0 c0 ff ff       	call   80101cb0 <iunlockput>

  end_op();
80105bf0:	e8 fb d9 ff ff       	call   801035f0 <end_op>

  return 0;
80105bf5:	83 c4 10             	add    $0x10,%esp
80105bf8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bfd:	5b                   	pop    %ebx
80105bfe:	5e                   	pop    %esi
80105bff:	5f                   	pop    %edi
80105c00:	5d                   	pop    %ebp
80105c01:	c3                   	ret    
80105c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c08:	83 ec 0c             	sub    $0xc,%esp
80105c0b:	53                   	push   %ebx
80105c0c:	e8 6f fe ff ff       	call   80105a80 <isdirempty>
80105c11:	83 c4 10             	add    $0x10,%esp
80105c14:	85 c0                	test   %eax,%eax
80105c16:	75 8b                	jne    80105ba3 <sys_unlink+0xb3>
    iunlockput(ip);
80105c18:	83 ec 0c             	sub    $0xc,%esp
80105c1b:	53                   	push   %ebx
80105c1c:	e8 8f c0 ff ff       	call   80101cb0 <iunlockput>
    goto bad;
80105c21:	83 c4 10             	add    $0x10,%esp
80105c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105c28:	83 ec 0c             	sub    $0xc,%esp
80105c2b:	56                   	push   %esi
80105c2c:	e8 7f c0 ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105c31:	e8 ba d9 ff ff       	call   801035f0 <end_op>
  return -1;
80105c36:	83 c4 10             	add    $0x10,%esp
80105c39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3e:	eb ba                	jmp    80105bfa <sys_unlink+0x10a>
    dp->nlink--;
80105c40:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105c45:	83 ec 0c             	sub    $0xc,%esp
80105c48:	56                   	push   %esi
80105c49:	e8 22 bd ff ff       	call   80101970 <iupdate>
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	e9 7c ff ff ff       	jmp    80105bd2 <sys_unlink+0xe2>
80105c56:	8d 76 00             	lea    0x0(%esi),%esi
80105c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c65:	eb 93                	jmp    80105bfa <sys_unlink+0x10a>
    end_op();
80105c67:	e8 84 d9 ff ff       	call   801035f0 <end_op>
    return -1;
80105c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c71:	eb 87                	jmp    80105bfa <sys_unlink+0x10a>
    panic("unlink: writei");
80105c73:	83 ec 0c             	sub    $0xc,%esp
80105c76:	68 33 92 10 80       	push   $0x80109233
80105c7b:	e8 10 a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	68 21 92 10 80       	push   $0x80109221
80105c88:	e8 03 a7 ff ff       	call   80100390 <panic>
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi

80105c90 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105c90:	55                   	push   %ebp
80105c91:	89 e5                	mov    %esp,%ebp
80105c93:	57                   	push   %edi
80105c94:	56                   	push   %esi
80105c95:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105c96:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105c99:	83 ec 34             	sub    $0x34,%esp
80105c9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c9f:	8b 55 10             	mov    0x10(%ebp),%edx
80105ca2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105ca5:	56                   	push   %esi
80105ca6:	ff 75 08             	pushl  0x8(%ebp)
{
80105ca9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105cac:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105caf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105cb2:	e8 e9 c5 ff ff       	call   801022a0 <nameiparent>
80105cb7:	83 c4 10             	add    $0x10,%esp
80105cba:	85 c0                	test   %eax,%eax
80105cbc:	0f 84 4e 01 00 00    	je     80105e10 <create+0x180>
    return 0;
  ilock(dp);
80105cc2:	83 ec 0c             	sub    $0xc,%esp
80105cc5:	89 c3                	mov    %eax,%ebx
80105cc7:	50                   	push   %eax
80105cc8:	e8 53 bd ff ff       	call   80101a20 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105ccd:	83 c4 0c             	add    $0xc,%esp
80105cd0:	6a 00                	push   $0x0
80105cd2:	56                   	push   %esi
80105cd3:	53                   	push   %ebx
80105cd4:	e8 77 c2 ff ff       	call   80101f50 <dirlookup>
80105cd9:	83 c4 10             	add    $0x10,%esp
80105cdc:	85 c0                	test   %eax,%eax
80105cde:	89 c7                	mov    %eax,%edi
80105ce0:	74 3e                	je     80105d20 <create+0x90>
    iunlockput(dp);
80105ce2:	83 ec 0c             	sub    $0xc,%esp
80105ce5:	53                   	push   %ebx
80105ce6:	e8 c5 bf ff ff       	call   80101cb0 <iunlockput>
    ilock(ip);
80105ceb:	89 3c 24             	mov    %edi,(%esp)
80105cee:	e8 2d bd ff ff       	call   80101a20 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105cf3:	83 c4 10             	add    $0x10,%esp
80105cf6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105cfb:	0f 85 9f 00 00 00    	jne    80105da0 <create+0x110>
80105d01:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105d06:	0f 85 94 00 00 00    	jne    80105da0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d0f:	89 f8                	mov    %edi,%eax
80105d11:	5b                   	pop    %ebx
80105d12:	5e                   	pop    %esi
80105d13:	5f                   	pop    %edi
80105d14:	5d                   	pop    %ebp
80105d15:	c3                   	ret    
80105d16:	8d 76 00             	lea    0x0(%esi),%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105d20:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105d24:	83 ec 08             	sub    $0x8,%esp
80105d27:	50                   	push   %eax
80105d28:	ff 33                	pushl  (%ebx)
80105d2a:	e8 81 bb ff ff       	call   801018b0 <ialloc>
80105d2f:	83 c4 10             	add    $0x10,%esp
80105d32:	85 c0                	test   %eax,%eax
80105d34:	89 c7                	mov    %eax,%edi
80105d36:	0f 84 e8 00 00 00    	je     80105e24 <create+0x194>
  ilock(ip);
80105d3c:	83 ec 0c             	sub    $0xc,%esp
80105d3f:	50                   	push   %eax
80105d40:	e8 db bc ff ff       	call   80101a20 <ilock>
  ip->major = major;
80105d45:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105d49:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105d4d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105d51:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105d55:	b8 01 00 00 00       	mov    $0x1,%eax
80105d5a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105d5e:	89 3c 24             	mov    %edi,(%esp)
80105d61:	e8 0a bc ff ff       	call   80101970 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105d6e:	74 50                	je     80105dc0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105d70:	83 ec 04             	sub    $0x4,%esp
80105d73:	ff 77 04             	pushl  0x4(%edi)
80105d76:	56                   	push   %esi
80105d77:	53                   	push   %ebx
80105d78:	e8 43 c4 ff ff       	call   801021c0 <dirlink>
80105d7d:	83 c4 10             	add    $0x10,%esp
80105d80:	85 c0                	test   %eax,%eax
80105d82:	0f 88 8f 00 00 00    	js     80105e17 <create+0x187>
  iunlockput(dp);
80105d88:	83 ec 0c             	sub    $0xc,%esp
80105d8b:	53                   	push   %ebx
80105d8c:	e8 1f bf ff ff       	call   80101cb0 <iunlockput>
  return ip;
80105d91:	83 c4 10             	add    $0x10,%esp
}
80105d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d97:	89 f8                	mov    %edi,%eax
80105d99:	5b                   	pop    %ebx
80105d9a:	5e                   	pop    %esi
80105d9b:	5f                   	pop    %edi
80105d9c:	5d                   	pop    %ebp
80105d9d:	c3                   	ret    
80105d9e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	57                   	push   %edi
    return 0;
80105da4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105da6:	e8 05 bf ff ff       	call   80101cb0 <iunlockput>
    return 0;
80105dab:	83 c4 10             	add    $0x10,%esp
}
80105dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105db1:	89 f8                	mov    %edi,%eax
80105db3:	5b                   	pop    %ebx
80105db4:	5e                   	pop    %esi
80105db5:	5f                   	pop    %edi
80105db6:	5d                   	pop    %ebp
80105db7:	c3                   	ret    
80105db8:	90                   	nop
80105db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105dc0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105dc5:	83 ec 0c             	sub    $0xc,%esp
80105dc8:	53                   	push   %ebx
80105dc9:	e8 a2 bb ff ff       	call   80101970 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105dce:	83 c4 0c             	add    $0xc,%esp
80105dd1:	ff 77 04             	pushl  0x4(%edi)
80105dd4:	68 1f 92 10 80       	push   $0x8010921f
80105dd9:	57                   	push   %edi
80105dda:	e8 e1 c3 ff ff       	call   801021c0 <dirlink>
80105ddf:	83 c4 10             	add    $0x10,%esp
80105de2:	85 c0                	test   %eax,%eax
80105de4:	78 1c                	js     80105e02 <create+0x172>
80105de6:	83 ec 04             	sub    $0x4,%esp
80105de9:	ff 73 04             	pushl  0x4(%ebx)
80105dec:	68 1e 92 10 80       	push   $0x8010921e
80105df1:	57                   	push   %edi
80105df2:	e8 c9 c3 ff ff       	call   801021c0 <dirlink>
80105df7:	83 c4 10             	add    $0x10,%esp
80105dfa:	85 c0                	test   %eax,%eax
80105dfc:	0f 89 6e ff ff ff    	jns    80105d70 <create+0xe0>
      panic("create dots");
80105e02:	83 ec 0c             	sub    $0xc,%esp
80105e05:	68 85 99 10 80       	push   $0x80109985
80105e0a:	e8 81 a5 ff ff       	call   80100390 <panic>
80105e0f:	90                   	nop
    return 0;
80105e10:	31 ff                	xor    %edi,%edi
80105e12:	e9 f5 fe ff ff       	jmp    80105d0c <create+0x7c>
    panic("create: dirlink");
80105e17:	83 ec 0c             	sub    $0xc,%esp
80105e1a:	68 91 99 10 80       	push   $0x80109991
80105e1f:	e8 6c a5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105e24:	83 ec 0c             	sub    $0xc,%esp
80105e27:	68 76 99 10 80       	push   $0x80109976
80105e2c:	e8 5f a5 ff ff       	call   80100390 <panic>
80105e31:	eb 0d                	jmp    80105e40 <sys_open>
80105e33:	90                   	nop
80105e34:	90                   	nop
80105e35:	90                   	nop
80105e36:	90                   	nop
80105e37:	90                   	nop
80105e38:	90                   	nop
80105e39:	90                   	nop
80105e3a:	90                   	nop
80105e3b:	90                   	nop
80105e3c:	90                   	nop
80105e3d:	90                   	nop
80105e3e:	90                   	nop
80105e3f:	90                   	nop

80105e40 <sys_open>:

int
sys_open(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	57                   	push   %edi
80105e44:	56                   	push   %esi
80105e45:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e46:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105e49:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e4c:	50                   	push   %eax
80105e4d:	6a 00                	push   $0x0
80105e4f:	e8 fc f7 ff ff       	call   80105650 <argstr>
80105e54:	83 c4 10             	add    $0x10,%esp
80105e57:	85 c0                	test   %eax,%eax
80105e59:	0f 88 1d 01 00 00    	js     80105f7c <sys_open+0x13c>
80105e5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105e62:	83 ec 08             	sub    $0x8,%esp
80105e65:	50                   	push   %eax
80105e66:	6a 01                	push   $0x1
80105e68:	e8 33 f7 ff ff       	call   801055a0 <argint>
80105e6d:	83 c4 10             	add    $0x10,%esp
80105e70:	85 c0                	test   %eax,%eax
80105e72:	0f 88 04 01 00 00    	js     80105f7c <sys_open+0x13c>
    return -1;

  begin_op();
80105e78:	e8 03 d7 ff ff       	call   80103580 <begin_op>

  if(omode & O_CREATE){
80105e7d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105e81:	0f 85 a9 00 00 00    	jne    80105f30 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105e87:	83 ec 0c             	sub    $0xc,%esp
80105e8a:	ff 75 e0             	pushl  -0x20(%ebp)
80105e8d:	e8 ee c3 ff ff       	call   80102280 <namei>
80105e92:	83 c4 10             	add    $0x10,%esp
80105e95:	85 c0                	test   %eax,%eax
80105e97:	89 c6                	mov    %eax,%esi
80105e99:	0f 84 ac 00 00 00    	je     80105f4b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105e9f:	83 ec 0c             	sub    $0xc,%esp
80105ea2:	50                   	push   %eax
80105ea3:	e8 78 bb ff ff       	call   80101a20 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ea8:	83 c4 10             	add    $0x10,%esp
80105eab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105eb0:	0f 84 aa 00 00 00    	je     80105f60 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105eb6:	e8 65 b2 ff ff       	call   80101120 <filealloc>
80105ebb:	85 c0                	test   %eax,%eax
80105ebd:	89 c7                	mov    %eax,%edi
80105ebf:	0f 84 a6 00 00 00    	je     80105f6b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105ec5:	e8 36 e4 ff ff       	call   80104300 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105eca:	31 db                	xor    %ebx,%ebx
80105ecc:	eb 0e                	jmp    80105edc <sys_open+0x9c>
80105ece:	66 90                	xchg   %ax,%ax
80105ed0:	83 c3 01             	add    $0x1,%ebx
80105ed3:	83 fb 10             	cmp    $0x10,%ebx
80105ed6:	0f 84 ac 00 00 00    	je     80105f88 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105edc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ee0:	85 d2                	test   %edx,%edx
80105ee2:	75 ec                	jne    80105ed0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105ee4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105ee7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105eeb:	56                   	push   %esi
80105eec:	e8 0f bc ff ff       	call   80101b00 <iunlock>
  end_op();
80105ef1:	e8 fa d6 ff ff       	call   801035f0 <end_op>

  f->type = FD_INODE;
80105ef6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105efc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105eff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f02:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105f05:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f0c:	89 d0                	mov    %edx,%eax
80105f0e:	f7 d0                	not    %eax
80105f10:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f13:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105f16:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f19:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105f1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f20:	89 d8                	mov    %ebx,%eax
80105f22:	5b                   	pop    %ebx
80105f23:	5e                   	pop    %esi
80105f24:	5f                   	pop    %edi
80105f25:	5d                   	pop    %ebp
80105f26:	c3                   	ret    
80105f27:	89 f6                	mov    %esi,%esi
80105f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105f30:	6a 00                	push   $0x0
80105f32:	6a 00                	push   $0x0
80105f34:	6a 02                	push   $0x2
80105f36:	ff 75 e0             	pushl  -0x20(%ebp)
80105f39:	e8 52 fd ff ff       	call   80105c90 <create>
    if(ip == 0){
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105f43:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105f45:	0f 85 6b ff ff ff    	jne    80105eb6 <sys_open+0x76>
      end_op();
80105f4b:	e8 a0 d6 ff ff       	call   801035f0 <end_op>
      return -1;
80105f50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f55:	eb c6                	jmp    80105f1d <sys_open+0xdd>
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f60:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105f63:	85 c9                	test   %ecx,%ecx
80105f65:	0f 84 4b ff ff ff    	je     80105eb6 <sys_open+0x76>
    iunlockput(ip);
80105f6b:	83 ec 0c             	sub    $0xc,%esp
80105f6e:	56                   	push   %esi
80105f6f:	e8 3c bd ff ff       	call   80101cb0 <iunlockput>
    end_op();
80105f74:	e8 77 d6 ff ff       	call   801035f0 <end_op>
    return -1;
80105f79:	83 c4 10             	add    $0x10,%esp
80105f7c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f81:	eb 9a                	jmp    80105f1d <sys_open+0xdd>
80105f83:	90                   	nop
80105f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	57                   	push   %edi
80105f8c:	e8 4f b2 ff ff       	call   801011e0 <fileclose>
80105f91:	83 c4 10             	add    $0x10,%esp
80105f94:	eb d5                	jmp    80105f6b <sys_open+0x12b>
80105f96:	8d 76 00             	lea    0x0(%esi),%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fa0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105fa0:	55                   	push   %ebp
80105fa1:	89 e5                	mov    %esp,%ebp
80105fa3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105fa6:	e8 d5 d5 ff ff       	call   80103580 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105fab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fae:	83 ec 08             	sub    $0x8,%esp
80105fb1:	50                   	push   %eax
80105fb2:	6a 00                	push   $0x0
80105fb4:	e8 97 f6 ff ff       	call   80105650 <argstr>
80105fb9:	83 c4 10             	add    $0x10,%esp
80105fbc:	85 c0                	test   %eax,%eax
80105fbe:	78 30                	js     80105ff0 <sys_mkdir+0x50>
80105fc0:	6a 00                	push   $0x0
80105fc2:	6a 00                	push   $0x0
80105fc4:	6a 01                	push   $0x1
80105fc6:	ff 75 f4             	pushl  -0xc(%ebp)
80105fc9:	e8 c2 fc ff ff       	call   80105c90 <create>
80105fce:	83 c4 10             	add    $0x10,%esp
80105fd1:	85 c0                	test   %eax,%eax
80105fd3:	74 1b                	je     80105ff0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105fd5:	83 ec 0c             	sub    $0xc,%esp
80105fd8:	50                   	push   %eax
80105fd9:	e8 d2 bc ff ff       	call   80101cb0 <iunlockput>
  end_op();
80105fde:	e8 0d d6 ff ff       	call   801035f0 <end_op>
  return 0;
80105fe3:	83 c4 10             	add    $0x10,%esp
80105fe6:	31 c0                	xor    %eax,%eax
}
80105fe8:	c9                   	leave  
80105fe9:	c3                   	ret    
80105fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105ff0:	e8 fb d5 ff ff       	call   801035f0 <end_op>
    return -1;
80105ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ffa:	c9                   	leave  
80105ffb:	c3                   	ret    
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106000 <sys_mknod>:

int
sys_mknod(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106006:	e8 75 d5 ff ff       	call   80103580 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010600b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010600e:	83 ec 08             	sub    $0x8,%esp
80106011:	50                   	push   %eax
80106012:	6a 00                	push   $0x0
80106014:	e8 37 f6 ff ff       	call   80105650 <argstr>
80106019:	83 c4 10             	add    $0x10,%esp
8010601c:	85 c0                	test   %eax,%eax
8010601e:	78 60                	js     80106080 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106020:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106023:	83 ec 08             	sub    $0x8,%esp
80106026:	50                   	push   %eax
80106027:	6a 01                	push   $0x1
80106029:	e8 72 f5 ff ff       	call   801055a0 <argint>
  if((argstr(0, &path)) < 0 ||
8010602e:	83 c4 10             	add    $0x10,%esp
80106031:	85 c0                	test   %eax,%eax
80106033:	78 4b                	js     80106080 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106035:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106038:	83 ec 08             	sub    $0x8,%esp
8010603b:	50                   	push   %eax
8010603c:	6a 02                	push   $0x2
8010603e:	e8 5d f5 ff ff       	call   801055a0 <argint>
     argint(1, &major) < 0 ||
80106043:	83 c4 10             	add    $0x10,%esp
80106046:	85 c0                	test   %eax,%eax
80106048:	78 36                	js     80106080 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010604a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010604e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010604f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106053:	50                   	push   %eax
80106054:	6a 03                	push   $0x3
80106056:	ff 75 ec             	pushl  -0x14(%ebp)
80106059:	e8 32 fc ff ff       	call   80105c90 <create>
8010605e:	83 c4 10             	add    $0x10,%esp
80106061:	85 c0                	test   %eax,%eax
80106063:	74 1b                	je     80106080 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106065:	83 ec 0c             	sub    $0xc,%esp
80106068:	50                   	push   %eax
80106069:	e8 42 bc ff ff       	call   80101cb0 <iunlockput>
  end_op();
8010606e:	e8 7d d5 ff ff       	call   801035f0 <end_op>
  return 0;
80106073:	83 c4 10             	add    $0x10,%esp
80106076:	31 c0                	xor    %eax,%eax
}
80106078:	c9                   	leave  
80106079:	c3                   	ret    
8010607a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106080:	e8 6b d5 ff ff       	call   801035f0 <end_op>
    return -1;
80106085:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010608a:	c9                   	leave  
8010608b:	c3                   	ret    
8010608c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106090 <sys_chdir>:

int
sys_chdir(void)
{
80106090:	55                   	push   %ebp
80106091:	89 e5                	mov    %esp,%ebp
80106093:	56                   	push   %esi
80106094:	53                   	push   %ebx
80106095:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106098:	e8 63 e2 ff ff       	call   80104300 <myproc>
8010609d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010609f:	e8 dc d4 ff ff       	call   80103580 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801060a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060a7:	83 ec 08             	sub    $0x8,%esp
801060aa:	50                   	push   %eax
801060ab:	6a 00                	push   $0x0
801060ad:	e8 9e f5 ff ff       	call   80105650 <argstr>
801060b2:	83 c4 10             	add    $0x10,%esp
801060b5:	85 c0                	test   %eax,%eax
801060b7:	78 77                	js     80106130 <sys_chdir+0xa0>
801060b9:	83 ec 0c             	sub    $0xc,%esp
801060bc:	ff 75 f4             	pushl  -0xc(%ebp)
801060bf:	e8 bc c1 ff ff       	call   80102280 <namei>
801060c4:	83 c4 10             	add    $0x10,%esp
801060c7:	85 c0                	test   %eax,%eax
801060c9:	89 c3                	mov    %eax,%ebx
801060cb:	74 63                	je     80106130 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801060cd:	83 ec 0c             	sub    $0xc,%esp
801060d0:	50                   	push   %eax
801060d1:	e8 4a b9 ff ff       	call   80101a20 <ilock>
  if(ip->type != T_DIR){
801060d6:	83 c4 10             	add    $0x10,%esp
801060d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801060de:	75 30                	jne    80106110 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	53                   	push   %ebx
801060e4:	e8 17 ba ff ff       	call   80101b00 <iunlock>
  iput(curproc->cwd);
801060e9:	58                   	pop    %eax
801060ea:	ff 76 68             	pushl  0x68(%esi)
801060ed:	e8 5e ba ff ff       	call   80101b50 <iput>
  end_op();
801060f2:	e8 f9 d4 ff ff       	call   801035f0 <end_op>
  curproc->cwd = ip;
801060f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801060fa:	83 c4 10             	add    $0x10,%esp
801060fd:	31 c0                	xor    %eax,%eax
}
801060ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106102:	5b                   	pop    %ebx
80106103:	5e                   	pop    %esi
80106104:	5d                   	pop    %ebp
80106105:	c3                   	ret    
80106106:	8d 76 00             	lea    0x0(%esi),%esi
80106109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	53                   	push   %ebx
80106114:	e8 97 bb ff ff       	call   80101cb0 <iunlockput>
    end_op();
80106119:	e8 d2 d4 ff ff       	call   801035f0 <end_op>
    return -1;
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106126:	eb d7                	jmp    801060ff <sys_chdir+0x6f>
80106128:	90                   	nop
80106129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106130:	e8 bb d4 ff ff       	call   801035f0 <end_op>
    return -1;
80106135:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010613a:	eb c3                	jmp    801060ff <sys_chdir+0x6f>
8010613c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106140 <sys_exec>:

int
sys_exec(void)
{
80106140:	55                   	push   %ebp
80106141:	89 e5                	mov    %esp,%ebp
80106143:	57                   	push   %edi
80106144:	56                   	push   %esi
80106145:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106146:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010614c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106152:	50                   	push   %eax
80106153:	6a 00                	push   $0x0
80106155:	e8 f6 f4 ff ff       	call   80105650 <argstr>
8010615a:	83 c4 10             	add    $0x10,%esp
8010615d:	85 c0                	test   %eax,%eax
8010615f:	0f 88 87 00 00 00    	js     801061ec <sys_exec+0xac>
80106165:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010616b:	83 ec 08             	sub    $0x8,%esp
8010616e:	50                   	push   %eax
8010616f:	6a 01                	push   $0x1
80106171:	e8 2a f4 ff ff       	call   801055a0 <argint>
80106176:	83 c4 10             	add    $0x10,%esp
80106179:	85 c0                	test   %eax,%eax
8010617b:	78 6f                	js     801061ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010617d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106183:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106186:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106188:	68 80 00 00 00       	push   $0x80
8010618d:	6a 00                	push   $0x0
8010618f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106195:	50                   	push   %eax
80106196:	e8 05 f1 ff ff       	call   801052a0 <memset>
8010619b:	83 c4 10             	add    $0x10,%esp
8010619e:	eb 2c                	jmp    801061cc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801061a0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801061a6:	85 c0                	test   %eax,%eax
801061a8:	74 56                	je     80106200 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801061aa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801061b0:	83 ec 08             	sub    $0x8,%esp
801061b3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801061b6:	52                   	push   %edx
801061b7:	50                   	push   %eax
801061b8:	e8 73 f3 ff ff       	call   80105530 <fetchstr>
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	85 c0                	test   %eax,%eax
801061c2:	78 28                	js     801061ec <sys_exec+0xac>
  for(i=0;; i++){
801061c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801061c7:	83 fb 20             	cmp    $0x20,%ebx
801061ca:	74 20                	je     801061ec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801061cc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801061d2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801061d9:	83 ec 08             	sub    $0x8,%esp
801061dc:	57                   	push   %edi
801061dd:	01 f0                	add    %esi,%eax
801061df:	50                   	push   %eax
801061e0:	e8 0b f3 ff ff       	call   801054f0 <fetchint>
801061e5:	83 c4 10             	add    $0x10,%esp
801061e8:	85 c0                	test   %eax,%eax
801061ea:	79 b4                	jns    801061a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801061ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801061ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061f4:	5b                   	pop    %ebx
801061f5:	5e                   	pop    %esi
801061f6:	5f                   	pop    %edi
801061f7:	5d                   	pop    %ebp
801061f8:	c3                   	ret    
801061f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106200:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106206:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106209:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106210:	00 00 00 00 
  return exec(path, argv);
80106214:	50                   	push   %eax
80106215:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010621b:	e8 40 aa ff ff       	call   80100c60 <exec>
80106220:	83 c4 10             	add    $0x10,%esp
}
80106223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106226:	5b                   	pop    %ebx
80106227:	5e                   	pop    %esi
80106228:	5f                   	pop    %edi
80106229:	5d                   	pop    %ebp
8010622a:	c3                   	ret    
8010622b:	90                   	nop
8010622c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106230 <sys_pipe>:

int
sys_pipe(void)
{
80106230:	55                   	push   %ebp
80106231:	89 e5                	mov    %esp,%ebp
80106233:	57                   	push   %edi
80106234:	56                   	push   %esi
80106235:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106236:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106239:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010623c:	6a 08                	push   $0x8
8010623e:	50                   	push   %eax
8010623f:	6a 00                	push   $0x0
80106241:	e8 aa f3 ff ff       	call   801055f0 <argptr>
80106246:	83 c4 10             	add    $0x10,%esp
80106249:	85 c0                	test   %eax,%eax
8010624b:	0f 88 ae 00 00 00    	js     801062ff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106251:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106254:	83 ec 08             	sub    $0x8,%esp
80106257:	50                   	push   %eax
80106258:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010625b:	50                   	push   %eax
8010625c:	e8 cf d9 ff ff       	call   80103c30 <pipealloc>
80106261:	83 c4 10             	add    $0x10,%esp
80106264:	85 c0                	test   %eax,%eax
80106266:	0f 88 93 00 00 00    	js     801062ff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010626c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010626f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106271:	e8 8a e0 ff ff       	call   80104300 <myproc>
80106276:	eb 10                	jmp    80106288 <sys_pipe+0x58>
80106278:	90                   	nop
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106280:	83 c3 01             	add    $0x1,%ebx
80106283:	83 fb 10             	cmp    $0x10,%ebx
80106286:	74 60                	je     801062e8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106288:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010628c:	85 f6                	test   %esi,%esi
8010628e:	75 f0                	jne    80106280 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106290:	8d 73 08             	lea    0x8(%ebx),%esi
80106293:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106297:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010629a:	e8 61 e0 ff ff       	call   80104300 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010629f:	31 d2                	xor    %edx,%edx
801062a1:	eb 0d                	jmp    801062b0 <sys_pipe+0x80>
801062a3:	90                   	nop
801062a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062a8:	83 c2 01             	add    $0x1,%edx
801062ab:	83 fa 10             	cmp    $0x10,%edx
801062ae:	74 28                	je     801062d8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801062b0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801062b4:	85 c9                	test   %ecx,%ecx
801062b6:	75 f0                	jne    801062a8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801062b8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801062bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062bf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801062c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062c4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801062c7:	31 c0                	xor    %eax,%eax
}
801062c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062cc:	5b                   	pop    %ebx
801062cd:	5e                   	pop    %esi
801062ce:	5f                   	pop    %edi
801062cf:	5d                   	pop    %ebp
801062d0:	c3                   	ret    
801062d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801062d8:	e8 23 e0 ff ff       	call   80104300 <myproc>
801062dd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801062e4:	00 
801062e5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801062e8:	83 ec 0c             	sub    $0xc,%esp
801062eb:	ff 75 e0             	pushl  -0x20(%ebp)
801062ee:	e8 ed ae ff ff       	call   801011e0 <fileclose>
    fileclose(wf);
801062f3:	58                   	pop    %eax
801062f4:	ff 75 e4             	pushl  -0x1c(%ebp)
801062f7:	e8 e4 ae ff ff       	call   801011e0 <fileclose>
    return -1;
801062fc:	83 c4 10             	add    $0x10,%esp
801062ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106304:	eb c3                	jmp    801062c9 <sys_pipe+0x99>
80106306:	66 90                	xchg   %ax,%ax
80106308:	66 90                	xchg   %ax,%ax
8010630a:	66 90                	xchg   %ax,%ax
8010630c:	66 90                	xchg   %ax,%ax
8010630e:	66 90                	xchg   %ax,%ax

80106310 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106310:	55                   	push   %ebp
80106311:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106313:	5d                   	pop    %ebp
  return fork();
80106314:	e9 37 e2 ff ff       	jmp    80104550 <fork>
80106319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106320 <sys_exit>:

int
sys_exit(void)
{
80106320:	55                   	push   %ebp
80106321:	89 e5                	mov    %esp,%ebp
80106323:	83 ec 08             	sub    $0x8,%esp
  exit();
80106326:	e8 05 e6 ff ff       	call   80104930 <exit>
  return 0;  // not reached
}
8010632b:	31 c0                	xor    %eax,%eax
8010632d:	c9                   	leave  
8010632e:	c3                   	ret    
8010632f:	90                   	nop

80106330 <sys_wait>:

int
sys_wait(void)
{
80106330:	55                   	push   %ebp
80106331:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106333:	5d                   	pop    %ebp
  return wait();
80106334:	e9 67 e8 ff ff       	jmp    80104ba0 <wait>
80106339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106340 <sys_kill>:

int
sys_kill(void)
{
80106340:	55                   	push   %ebp
80106341:	89 e5                	mov    %esp,%ebp
80106343:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106346:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106349:	50                   	push   %eax
8010634a:	6a 00                	push   $0x0
8010634c:	e8 4f f2 ff ff       	call   801055a0 <argint>
80106351:	83 c4 10             	add    $0x10,%esp
80106354:	85 c0                	test   %eax,%eax
80106356:	78 18                	js     80106370 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106358:	83 ec 0c             	sub    $0xc,%esp
8010635b:	ff 75 f4             	pushl  -0xc(%ebp)
8010635e:	e8 0d ea ff ff       	call   80104d70 <kill>
80106363:	83 c4 10             	add    $0x10,%esp
}
80106366:	c9                   	leave  
80106367:	c3                   	ret    
80106368:	90                   	nop
80106369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106375:	c9                   	leave  
80106376:	c3                   	ret    
80106377:	89 f6                	mov    %esi,%esi
80106379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106380 <sys_getpid>:

int
sys_getpid(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106386:	e8 75 df ff ff       	call   80104300 <myproc>
8010638b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010638e:	c9                   	leave  
8010638f:	c3                   	ret    

80106390 <sys_sbrk>:

int
sys_sbrk(void)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106394:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106397:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010639a:	50                   	push   %eax
8010639b:	6a 00                	push   $0x0
8010639d:	e8 fe f1 ff ff       	call   801055a0 <argint>
801063a2:	83 c4 10             	add    $0x10,%esp
801063a5:	85 c0                	test   %eax,%eax
801063a7:	78 27                	js     801063d0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801063a9:	e8 52 df ff ff       	call   80104300 <myproc>
  if(growproc(n) < 0)
801063ae:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801063b1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801063b3:	ff 75 f4             	pushl  -0xc(%ebp)
801063b6:	e8 65 e0 ff ff       	call   80104420 <growproc>
801063bb:	83 c4 10             	add    $0x10,%esp
801063be:	85 c0                	test   %eax,%eax
801063c0:	78 0e                	js     801063d0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
801063c2:	89 d8                	mov    %ebx,%eax
801063c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801063c7:	c9                   	leave  
801063c8:	c3                   	ret    
801063c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063d0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801063d5:	eb eb                	jmp    801063c2 <sys_sbrk+0x32>
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063e0 <sys_sleep>:

int
sys_sleep(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801063e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801063ea:	50                   	push   %eax
801063eb:	6a 00                	push   $0x0
801063ed:	e8 ae f1 ff ff       	call   801055a0 <argint>
801063f2:	83 c4 10             	add    $0x10,%esp
801063f5:	85 c0                	test   %eax,%eax
801063f7:	0f 88 8a 00 00 00    	js     80106487 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801063fd:	83 ec 0c             	sub    $0xc,%esp
80106400:	68 60 6d 19 80       	push   $0x80196d60
80106405:	e8 86 ed ff ff       	call   80105190 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010640a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106410:	8b 1d a0 75 19 80    	mov    0x801975a0,%ebx
  while(ticks - ticks0 < n){
80106416:	85 d2                	test   %edx,%edx
80106418:	75 27                	jne    80106441 <sys_sleep+0x61>
8010641a:	eb 54                	jmp    80106470 <sys_sleep+0x90>
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106420:	83 ec 08             	sub    $0x8,%esp
80106423:	68 60 6d 19 80       	push   $0x80196d60
80106428:	68 a0 75 19 80       	push   $0x801975a0
8010642d:	e8 ae e6 ff ff       	call   80104ae0 <sleep>
  while(ticks - ticks0 < n){
80106432:	a1 a0 75 19 80       	mov    0x801975a0,%eax
80106437:	83 c4 10             	add    $0x10,%esp
8010643a:	29 d8                	sub    %ebx,%eax
8010643c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010643f:	73 2f                	jae    80106470 <sys_sleep+0x90>
    if(myproc()->killed){
80106441:	e8 ba de ff ff       	call   80104300 <myproc>
80106446:	8b 40 24             	mov    0x24(%eax),%eax
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 d3                	je     80106420 <sys_sleep+0x40>
      release(&tickslock);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	68 60 6d 19 80       	push   $0x80196d60
80106455:	e8 f6 ed ff ff       	call   80105250 <release>
      return -1;
8010645a:	83 c4 10             	add    $0x10,%esp
8010645d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106462:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106465:	c9                   	leave  
80106466:	c3                   	ret    
80106467:	89 f6                	mov    %esi,%esi
80106469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106470:	83 ec 0c             	sub    $0xc,%esp
80106473:	68 60 6d 19 80       	push   $0x80196d60
80106478:	e8 d3 ed ff ff       	call   80105250 <release>
  return 0;
8010647d:	83 c4 10             	add    $0x10,%esp
80106480:	31 c0                	xor    %eax,%eax
}
80106482:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106485:	c9                   	leave  
80106486:	c3                   	ret    
    return -1;
80106487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010648c:	eb f4                	jmp    80106482 <sys_sleep+0xa2>
8010648e:	66 90                	xchg   %ax,%ax

80106490 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106490:	55                   	push   %ebp
80106491:	89 e5                	mov    %esp,%ebp
80106493:	53                   	push   %ebx
80106494:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106497:	68 60 6d 19 80       	push   $0x80196d60
8010649c:	e8 ef ec ff ff       	call   80105190 <acquire>
  xticks = ticks;
801064a1:	8b 1d a0 75 19 80    	mov    0x801975a0,%ebx
  release(&tickslock);
801064a7:	c7 04 24 60 6d 19 80 	movl   $0x80196d60,(%esp)
801064ae:	e8 9d ed ff ff       	call   80105250 <release>
  return xticks;
}
801064b3:	89 d8                	mov    %ebx,%eax
801064b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064b8:	c9                   	leave  
801064b9:	c3                   	ret    
801064ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801064c0 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
801064c0:	55                   	push   %ebp
801064c1:	89 e5                	mov    %esp,%ebp
  return getNumberOfFreePages();
}
801064c3:	5d                   	pop    %ebp
  return getNumberOfFreePages();
801064c4:	e9 37 ea ff ff       	jmp    80104f00 <getNumberOfFreePages>
801064c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064d0 <sys_getNumRefs>:

int
sys_getNumRefs(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	83 ec 20             	sub    $0x20,%esp
  int arrindx;

  if(argint(0, &arrindx) < 0)
801064d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801064d9:	50                   	push   %eax
801064da:	6a 00                	push   $0x0
801064dc:	e8 bf f0 ff ff       	call   801055a0 <argint>
801064e1:	83 c4 10             	add    $0x10,%esp
801064e4:	85 c0                	test   %eax,%eax
801064e6:	78 18                	js     80106500 <sys_getNumRefs+0x30>
    return -1;
  return getNumRefs(arrindx);
801064e8:	83 ec 0c             	sub    $0xc,%esp
801064eb:	ff 75 f4             	pushl  -0xc(%ebp)
801064ee:	e8 1d ea ff ff       	call   80104f10 <getNumRefs>
801064f3:	83 c4 10             	add    $0x10,%esp
801064f6:	c9                   	leave  
801064f7:	c3                   	ret    
801064f8:	90                   	nop
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106505:	c9                   	leave  
80106506:	c3                   	ret    

80106507 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106507:	1e                   	push   %ds
  pushl %es
80106508:	06                   	push   %es
  pushl %fs
80106509:	0f a0                	push   %fs
  pushl %gs
8010650b:	0f a8                	push   %gs
  pushal
8010650d:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010650e:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106512:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106514:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106516:	54                   	push   %esp
  call trap
80106517:	e8 c4 00 00 00       	call   801065e0 <trap>
  addl $4, %esp
8010651c:	83 c4 04             	add    $0x4,%esp

8010651f <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010651f:	61                   	popa   
  popl %gs
80106520:	0f a9                	pop    %gs
  popl %fs
80106522:	0f a1                	pop    %fs
  popl %es
80106524:	07                   	pop    %es
  popl %ds
80106525:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106526:	83 c4 08             	add    $0x8,%esp
  iret
80106529:	cf                   	iret   
8010652a:	66 90                	xchg   %ax,%ax
8010652c:	66 90                	xchg   %ax,%ax
8010652e:	66 90                	xchg   %ax,%ax

80106530 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106530:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106531:	31 c0                	xor    %eax,%eax
{
80106533:	89 e5                	mov    %esp,%ebp
80106535:	83 ec 08             	sub    $0x8,%esp
80106538:	90                   	nop
80106539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106540:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106547:	c7 04 c5 a2 6d 19 80 	movl   $0x8e000008,-0x7fe6925e(,%eax,8)
8010654e:	08 00 00 8e 
80106552:	66 89 14 c5 a0 6d 19 	mov    %dx,-0x7fe69260(,%eax,8)
80106559:	80 
8010655a:	c1 ea 10             	shr    $0x10,%edx
8010655d:	66 89 14 c5 a6 6d 19 	mov    %dx,-0x7fe6925a(,%eax,8)
80106564:	80 
  for(i = 0; i < 256; i++)
80106565:	83 c0 01             	add    $0x1,%eax
80106568:	3d 00 01 00 00       	cmp    $0x100,%eax
8010656d:	75 d1                	jne    80106540 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010656f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106574:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106577:	c7 05 a2 6f 19 80 08 	movl   $0xef000008,0x80196fa2
8010657e:	00 00 ef 
  initlock(&tickslock, "time");
80106581:	68 a1 99 10 80       	push   $0x801099a1
80106586:	68 60 6d 19 80       	push   $0x80196d60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010658b:	66 a3 a0 6f 19 80    	mov    %ax,0x80196fa0
80106591:	c1 e8 10             	shr    $0x10,%eax
80106594:	66 a3 a6 6f 19 80    	mov    %ax,0x80196fa6
  initlock(&tickslock, "time");
8010659a:	e8 b1 ea ff ff       	call   80105050 <initlock>
}
8010659f:	83 c4 10             	add    $0x10,%esp
801065a2:	c9                   	leave  
801065a3:	c3                   	ret    
801065a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801065b0 <idtinit>:

void
idtinit(void)
{
801065b0:	55                   	push   %ebp
  pd[0] = size-1;
801065b1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065b6:	89 e5                	mov    %esp,%ebp
801065b8:	83 ec 10             	sub    $0x10,%esp
801065bb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065bf:	b8 a0 6d 19 80       	mov    $0x80196da0,%eax
801065c4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065c8:	c1 e8 10             	shr    $0x10,%eax
801065cb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065cf:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065d2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801065d5:	c9                   	leave  
801065d6:	c3                   	ret    
801065d7:	89 f6                	mov    %esi,%esi
801065d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801065e0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801065e0:	55                   	push   %ebp
801065e1:	89 e5                	mov    %esp,%ebp
801065e3:	57                   	push   %edi
801065e4:	56                   	push   %esi
801065e5:	53                   	push   %ebx
801065e6:	83 ec 1c             	sub    $0x1c,%esp
801065e9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
801065ec:	e8 0f dd ff ff       	call   80104300 <myproc>
801065f1:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
801065f3:	8b 47 30             	mov    0x30(%edi),%eax
801065f6:	83 f8 40             	cmp    $0x40,%eax
801065f9:	0f 84 e9 00 00 00    	je     801066e8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801065ff:	83 e8 0e             	sub    $0xe,%eax
80106602:	83 f8 31             	cmp    $0x31,%eax
80106605:	77 09                	ja     80106610 <trap+0x30>
80106607:	ff 24 85 48 9a 10 80 	jmp    *-0x7fef65b8(,%eax,4)
8010660e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106610:	e8 eb dc ff ff       	call   80104300 <myproc>
80106615:	85 c0                	test   %eax,%eax
80106617:	0f 84 3d 02 00 00    	je     8010685a <trap+0x27a>
8010661d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106621:	0f 84 33 02 00 00    	je     8010685a <trap+0x27a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106627:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010662a:	8b 57 38             	mov    0x38(%edi),%edx
8010662d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106630:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106633:	e8 a8 dc ff ff       	call   801042e0 <cpuid>
80106638:	8b 77 34             	mov    0x34(%edi),%esi
8010663b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010663e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106641:	e8 ba dc ff ff       	call   80104300 <myproc>
80106646:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106649:	e8 b2 dc ff ff       	call   80104300 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010664e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106651:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106654:	51                   	push   %ecx
80106655:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106656:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106659:	ff 75 e4             	pushl  -0x1c(%ebp)
8010665c:	56                   	push   %esi
8010665d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010665e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106661:	52                   	push   %edx
80106662:	ff 70 10             	pushl  0x10(%eax)
80106665:	68 04 9a 10 80       	push   $0x80109a04
8010666a:	e8 f1 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010666f:	83 c4 20             	add    $0x20,%esp
80106672:	e8 89 dc ff ff       	call   80104300 <myproc>
80106677:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010667e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106680:	e8 7b dc ff ff       	call   80104300 <myproc>
80106685:	85 c0                	test   %eax,%eax
80106687:	74 1d                	je     801066a6 <trap+0xc6>
80106689:	e8 72 dc ff ff       	call   80104300 <myproc>
8010668e:	8b 50 24             	mov    0x24(%eax),%edx
80106691:	85 d2                	test   %edx,%edx
80106693:	74 11                	je     801066a6 <trap+0xc6>
80106695:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106699:	83 e0 03             	and    $0x3,%eax
8010669c:	66 83 f8 03          	cmp    $0x3,%ax
801066a0:	0f 84 5a 01 00 00    	je     80106800 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801066a6:	e8 55 dc ff ff       	call   80104300 <myproc>
801066ab:	85 c0                	test   %eax,%eax
801066ad:	74 0b                	je     801066ba <trap+0xda>
801066af:	e8 4c dc ff ff       	call   80104300 <myproc>
801066b4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801066b8:	74 5e                	je     80106718 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066ba:	e8 41 dc ff ff       	call   80104300 <myproc>
801066bf:	85 c0                	test   %eax,%eax
801066c1:	74 19                	je     801066dc <trap+0xfc>
801066c3:	e8 38 dc ff ff       	call   80104300 <myproc>
801066c8:	8b 40 24             	mov    0x24(%eax),%eax
801066cb:	85 c0                	test   %eax,%eax
801066cd:	74 0d                	je     801066dc <trap+0xfc>
801066cf:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066d3:	83 e0 03             	and    $0x3,%eax
801066d6:	66 83 f8 03          	cmp    $0x3,%ax
801066da:	74 2b                	je     80106707 <trap+0x127>
    exit();
801066dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066df:	5b                   	pop    %ebx
801066e0:	5e                   	pop    %esi
801066e1:	5f                   	pop    %edi
801066e2:	5d                   	pop    %ebp
801066e3:	c3                   	ret    
801066e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
801066e8:	8b 73 24             	mov    0x24(%ebx),%esi
801066eb:	85 f6                	test   %esi,%esi
801066ed:	0f 85 fd 00 00 00    	jne    801067f0 <trap+0x210>
    curproc->tf = tf;
801066f3:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
801066f6:	e8 95 ef ff ff       	call   80105690 <syscall>
    if(myproc()->killed)
801066fb:	e8 00 dc ff ff       	call   80104300 <myproc>
80106700:	8b 58 24             	mov    0x24(%eax),%ebx
80106703:	85 db                	test   %ebx,%ebx
80106705:	74 d5                	je     801066dc <trap+0xfc>
80106707:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010670a:	5b                   	pop    %ebx
8010670b:	5e                   	pop    %esi
8010670c:	5f                   	pop    %edi
8010670d:	5d                   	pop    %ebp
      exit();
8010670e:	e9 1d e2 ff ff       	jmp    80104930 <exit>
80106713:	90                   	nop
80106714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106718:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010671c:	75 9c                	jne    801066ba <trap+0xda>
      if(myproc()->pid > 2) 
8010671e:	e8 dd db ff ff       	call   80104300 <myproc>
80106723:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106727:	0f 8f 17 01 00 00    	jg     80106844 <trap+0x264>
      yield();
8010672d:	e8 5e e3 ff ff       	call   80104a90 <yield>
80106732:	eb 86                	jmp    801066ba <trap+0xda>
80106734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->pid > 2) 
80106738:	e8 c3 db ff ff       	call   80104300 <myproc>
8010673d:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106741:	0f 8e 39 ff ff ff    	jle    80106680 <trap+0xa0>
    pagefault();
80106747:	e8 34 24 00 00       	call   80108b80 <pagefault>
    if(curproc->killed) 
8010674c:	8b 4b 24             	mov    0x24(%ebx),%ecx
8010674f:	85 c9                	test   %ecx,%ecx
80106751:	0f 84 29 ff ff ff    	je     80106680 <trap+0xa0>
        exit();
80106757:	e8 d4 e1 ff ff       	call   80104930 <exit>
8010675c:	e9 1f ff ff ff       	jmp    80106680 <trap+0xa0>
80106761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106768:	e8 73 db ff ff       	call   801042e0 <cpuid>
8010676d:	85 c0                	test   %eax,%eax
8010676f:	0f 84 9b 00 00 00    	je     80106810 <trap+0x230>
    lapiceoi();
80106775:	e8 b6 c9 ff ff       	call   80103130 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010677a:	e8 81 db ff ff       	call   80104300 <myproc>
8010677f:	85 c0                	test   %eax,%eax
80106781:	0f 85 02 ff ff ff    	jne    80106689 <trap+0xa9>
80106787:	e9 1a ff ff ff       	jmp    801066a6 <trap+0xc6>
8010678c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106790:	e8 5b c8 ff ff       	call   80102ff0 <kbdintr>
    lapiceoi();
80106795:	e8 96 c9 ff ff       	call   80103130 <lapiceoi>
    break;
8010679a:	e9 e1 fe ff ff       	jmp    80106680 <trap+0xa0>
8010679f:	90                   	nop
    uartintr();
801067a0:	e8 5b 02 00 00       	call   80106a00 <uartintr>
    lapiceoi();
801067a5:	e8 86 c9 ff ff       	call   80103130 <lapiceoi>
    break;
801067aa:	e9 d1 fe ff ff       	jmp    80106680 <trap+0xa0>
801067af:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067b0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801067b4:	8b 77 38             	mov    0x38(%edi),%esi
801067b7:	e8 24 db ff ff       	call   801042e0 <cpuid>
801067bc:	56                   	push   %esi
801067bd:	53                   	push   %ebx
801067be:	50                   	push   %eax
801067bf:	68 ac 99 10 80       	push   $0x801099ac
801067c4:	e8 97 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
801067c9:	e8 62 c9 ff ff       	call   80103130 <lapiceoi>
    break;
801067ce:	83 c4 10             	add    $0x10,%esp
801067d1:	e9 aa fe ff ff       	jmp    80106680 <trap+0xa0>
801067d6:	8d 76 00             	lea    0x0(%esi),%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
801067e0:	e8 eb bf ff ff       	call   801027d0 <ideintr>
801067e5:	eb 8e                	jmp    80106775 <trap+0x195>
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
801067f0:	e8 3b e1 ff ff       	call   80104930 <exit>
801067f5:	e9 f9 fe ff ff       	jmp    801066f3 <trap+0x113>
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106800:	e8 2b e1 ff ff       	call   80104930 <exit>
80106805:	e9 9c fe ff ff       	jmp    801066a6 <trap+0xc6>
8010680a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106810:	83 ec 0c             	sub    $0xc,%esp
80106813:	68 60 6d 19 80       	push   $0x80196d60
80106818:	e8 73 e9 ff ff       	call   80105190 <acquire>
      wakeup(&ticks);
8010681d:	c7 04 24 a0 75 19 80 	movl   $0x801975a0,(%esp)
      ticks++;
80106824:	83 05 a0 75 19 80 01 	addl   $0x1,0x801975a0
      wakeup(&ticks);
8010682b:	e8 e0 e4 ff ff       	call   80104d10 <wakeup>
      release(&tickslock);
80106830:	c7 04 24 60 6d 19 80 	movl   $0x80196d60,(%esp)
80106837:	e8 14 ea ff ff       	call   80105250 <release>
8010683c:	83 c4 10             	add    $0x10,%esp
8010683f:	e9 31 ff ff ff       	jmp    80106775 <trap+0x195>
        updateAQ(myproc());
80106844:	e8 b7 da ff ff       	call   80104300 <myproc>
80106849:	83 ec 0c             	sub    $0xc,%esp
8010684c:	50                   	push   %eax
8010684d:	e8 fe 26 00 00       	call   80108f50 <updateAQ>
80106852:	83 c4 10             	add    $0x10,%esp
80106855:	e9 d3 fe ff ff       	jmp    8010672d <trap+0x14d>
8010685a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010685d:	8b 5f 38             	mov    0x38(%edi),%ebx
80106860:	e8 7b da ff ff       	call   801042e0 <cpuid>
80106865:	83 ec 0c             	sub    $0xc,%esp
80106868:	56                   	push   %esi
80106869:	53                   	push   %ebx
8010686a:	50                   	push   %eax
8010686b:	ff 77 30             	pushl  0x30(%edi)
8010686e:	68 d0 99 10 80       	push   $0x801099d0
80106873:	e8 e8 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
80106878:	83 c4 14             	add    $0x14,%esp
8010687b:	68 a6 99 10 80       	push   $0x801099a6
80106880:	e8 0b 9b ff ff       	call   80100390 <panic>
80106885:	66 90                	xchg   %ax,%ax
80106887:	66 90                	xchg   %ax,%ax
80106889:	66 90                	xchg   %ax,%ax
8010688b:	66 90                	xchg   %ax,%ax
8010688d:	66 90                	xchg   %ax,%ax
8010688f:	90                   	nop

80106890 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106890:	a1 e0 c5 10 80       	mov    0x8010c5e0,%eax
{
80106895:	55                   	push   %ebp
80106896:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106898:	85 c0                	test   %eax,%eax
8010689a:	74 1c                	je     801068b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010689c:	ba fd 03 00 00       	mov    $0x3fd,%edx
801068a1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801068a2:	a8 01                	test   $0x1,%al
801068a4:	74 12                	je     801068b8 <uartgetc+0x28>
801068a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068ab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801068ac:	0f b6 c0             	movzbl %al,%eax
}
801068af:	5d                   	pop    %ebp
801068b0:	c3                   	ret    
801068b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801068b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068bd:	5d                   	pop    %ebp
801068be:	c3                   	ret    
801068bf:	90                   	nop

801068c0 <uartputc.part.0>:
uartputc(int c)
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	57                   	push   %edi
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	89 c7                	mov    %eax,%edi
801068c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801068cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801068d2:	83 ec 0c             	sub    $0xc,%esp
801068d5:	eb 1b                	jmp    801068f2 <uartputc.part.0+0x32>
801068d7:	89 f6                	mov    %esi,%esi
801068d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801068e0:	83 ec 0c             	sub    $0xc,%esp
801068e3:	6a 0a                	push   $0xa
801068e5:	e8 66 c8 ff ff       	call   80103150 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801068ea:	83 c4 10             	add    $0x10,%esp
801068ed:	83 eb 01             	sub    $0x1,%ebx
801068f0:	74 07                	je     801068f9 <uartputc.part.0+0x39>
801068f2:	89 f2                	mov    %esi,%edx
801068f4:	ec                   	in     (%dx),%al
801068f5:	a8 20                	test   $0x20,%al
801068f7:	74 e7                	je     801068e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801068f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801068fe:	89 f8                	mov    %edi,%eax
80106900:	ee                   	out    %al,(%dx)
}
80106901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106904:	5b                   	pop    %ebx
80106905:	5e                   	pop    %esi
80106906:	5f                   	pop    %edi
80106907:	5d                   	pop    %ebp
80106908:	c3                   	ret    
80106909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106910 <uartinit>:
{
80106910:	55                   	push   %ebp
80106911:	31 c9                	xor    %ecx,%ecx
80106913:	89 c8                	mov    %ecx,%eax
80106915:	89 e5                	mov    %esp,%ebp
80106917:	57                   	push   %edi
80106918:	56                   	push   %esi
80106919:	53                   	push   %ebx
8010691a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010691f:	89 da                	mov    %ebx,%edx
80106921:	83 ec 0c             	sub    $0xc,%esp
80106924:	ee                   	out    %al,(%dx)
80106925:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010692a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010692f:	89 fa                	mov    %edi,%edx
80106931:	ee                   	out    %al,(%dx)
80106932:	b8 0c 00 00 00       	mov    $0xc,%eax
80106937:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010693c:	ee                   	out    %al,(%dx)
8010693d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106942:	89 c8                	mov    %ecx,%eax
80106944:	89 f2                	mov    %esi,%edx
80106946:	ee                   	out    %al,(%dx)
80106947:	b8 03 00 00 00       	mov    $0x3,%eax
8010694c:	89 fa                	mov    %edi,%edx
8010694e:	ee                   	out    %al,(%dx)
8010694f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106954:	89 c8                	mov    %ecx,%eax
80106956:	ee                   	out    %al,(%dx)
80106957:	b8 01 00 00 00       	mov    $0x1,%eax
8010695c:	89 f2                	mov    %esi,%edx
8010695e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010695f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106964:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106965:	3c ff                	cmp    $0xff,%al
80106967:	74 5a                	je     801069c3 <uartinit+0xb3>
  uart = 1;
80106969:	c7 05 e0 c5 10 80 01 	movl   $0x1,0x8010c5e0
80106970:	00 00 00 
80106973:	89 da                	mov    %ebx,%edx
80106975:	ec                   	in     (%dx),%al
80106976:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010697b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010697c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010697f:	bb 10 9b 10 80       	mov    $0x80109b10,%ebx
  ioapicenable(IRQ_COM1, 0);
80106984:	6a 00                	push   $0x0
80106986:	6a 04                	push   $0x4
80106988:	e8 93 c0 ff ff       	call   80102a20 <ioapicenable>
8010698d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106990:	b8 78 00 00 00       	mov    $0x78,%eax
80106995:	eb 13                	jmp    801069aa <uartinit+0x9a>
80106997:	89 f6                	mov    %esi,%esi
80106999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069a0:	83 c3 01             	add    $0x1,%ebx
801069a3:	0f be 03             	movsbl (%ebx),%eax
801069a6:	84 c0                	test   %al,%al
801069a8:	74 19                	je     801069c3 <uartinit+0xb3>
  if(!uart)
801069aa:	8b 15 e0 c5 10 80    	mov    0x8010c5e0,%edx
801069b0:	85 d2                	test   %edx,%edx
801069b2:	74 ec                	je     801069a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801069b4:	83 c3 01             	add    $0x1,%ebx
801069b7:	e8 04 ff ff ff       	call   801068c0 <uartputc.part.0>
801069bc:	0f be 03             	movsbl (%ebx),%eax
801069bf:	84 c0                	test   %al,%al
801069c1:	75 e7                	jne    801069aa <uartinit+0x9a>
}
801069c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069c6:	5b                   	pop    %ebx
801069c7:	5e                   	pop    %esi
801069c8:	5f                   	pop    %edi
801069c9:	5d                   	pop    %ebp
801069ca:	c3                   	ret    
801069cb:	90                   	nop
801069cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801069d0 <uartputc>:
  if(!uart)
801069d0:	8b 15 e0 c5 10 80    	mov    0x8010c5e0,%edx
{
801069d6:	55                   	push   %ebp
801069d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801069d9:	85 d2                	test   %edx,%edx
{
801069db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801069de:	74 10                	je     801069f0 <uartputc+0x20>
}
801069e0:	5d                   	pop    %ebp
801069e1:	e9 da fe ff ff       	jmp    801068c0 <uartputc.part.0>
801069e6:	8d 76 00             	lea    0x0(%esi),%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801069f0:	5d                   	pop    %ebp
801069f1:	c3                   	ret    
801069f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a00 <uartintr>:

void
uartintr(void)
{
80106a00:	55                   	push   %ebp
80106a01:	89 e5                	mov    %esp,%ebp
80106a03:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106a06:	68 90 68 10 80       	push   $0x80106890
80106a0b:	e8 00 9e ff ff       	call   80100810 <consoleintr>
}
80106a10:	83 c4 10             	add    $0x10,%esp
80106a13:	c9                   	leave  
80106a14:	c3                   	ret    

80106a15 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $0
80106a17:	6a 00                	push   $0x0
  jmp alltraps
80106a19:	e9 e9 fa ff ff       	jmp    80106507 <alltraps>

80106a1e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $1
80106a20:	6a 01                	push   $0x1
  jmp alltraps
80106a22:	e9 e0 fa ff ff       	jmp    80106507 <alltraps>

80106a27 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $2
80106a29:	6a 02                	push   $0x2
  jmp alltraps
80106a2b:	e9 d7 fa ff ff       	jmp    80106507 <alltraps>

80106a30 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $3
80106a32:	6a 03                	push   $0x3
  jmp alltraps
80106a34:	e9 ce fa ff ff       	jmp    80106507 <alltraps>

80106a39 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $4
80106a3b:	6a 04                	push   $0x4
  jmp alltraps
80106a3d:	e9 c5 fa ff ff       	jmp    80106507 <alltraps>

80106a42 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $5
80106a44:	6a 05                	push   $0x5
  jmp alltraps
80106a46:	e9 bc fa ff ff       	jmp    80106507 <alltraps>

80106a4b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $6
80106a4d:	6a 06                	push   $0x6
  jmp alltraps
80106a4f:	e9 b3 fa ff ff       	jmp    80106507 <alltraps>

80106a54 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $7
80106a56:	6a 07                	push   $0x7
  jmp alltraps
80106a58:	e9 aa fa ff ff       	jmp    80106507 <alltraps>

80106a5d <vector8>:
.globl vector8
vector8:
  pushl $8
80106a5d:	6a 08                	push   $0x8
  jmp alltraps
80106a5f:	e9 a3 fa ff ff       	jmp    80106507 <alltraps>

80106a64 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $9
80106a66:	6a 09                	push   $0x9
  jmp alltraps
80106a68:	e9 9a fa ff ff       	jmp    80106507 <alltraps>

80106a6d <vector10>:
.globl vector10
vector10:
  pushl $10
80106a6d:	6a 0a                	push   $0xa
  jmp alltraps
80106a6f:	e9 93 fa ff ff       	jmp    80106507 <alltraps>

80106a74 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a74:	6a 0b                	push   $0xb
  jmp alltraps
80106a76:	e9 8c fa ff ff       	jmp    80106507 <alltraps>

80106a7b <vector12>:
.globl vector12
vector12:
  pushl $12
80106a7b:	6a 0c                	push   $0xc
  jmp alltraps
80106a7d:	e9 85 fa ff ff       	jmp    80106507 <alltraps>

80106a82 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a82:	6a 0d                	push   $0xd
  jmp alltraps
80106a84:	e9 7e fa ff ff       	jmp    80106507 <alltraps>

80106a89 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a89:	6a 0e                	push   $0xe
  jmp alltraps
80106a8b:	e9 77 fa ff ff       	jmp    80106507 <alltraps>

80106a90 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $15
80106a92:	6a 0f                	push   $0xf
  jmp alltraps
80106a94:	e9 6e fa ff ff       	jmp    80106507 <alltraps>

80106a99 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $16
80106a9b:	6a 10                	push   $0x10
  jmp alltraps
80106a9d:	e9 65 fa ff ff       	jmp    80106507 <alltraps>

80106aa2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106aa2:	6a 11                	push   $0x11
  jmp alltraps
80106aa4:	e9 5e fa ff ff       	jmp    80106507 <alltraps>

80106aa9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $18
80106aab:	6a 12                	push   $0x12
  jmp alltraps
80106aad:	e9 55 fa ff ff       	jmp    80106507 <alltraps>

80106ab2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $19
80106ab4:	6a 13                	push   $0x13
  jmp alltraps
80106ab6:	e9 4c fa ff ff       	jmp    80106507 <alltraps>

80106abb <vector20>:
.globl vector20
vector20:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $20
80106abd:	6a 14                	push   $0x14
  jmp alltraps
80106abf:	e9 43 fa ff ff       	jmp    80106507 <alltraps>

80106ac4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $21
80106ac6:	6a 15                	push   $0x15
  jmp alltraps
80106ac8:	e9 3a fa ff ff       	jmp    80106507 <alltraps>

80106acd <vector22>:
.globl vector22
vector22:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $22
80106acf:	6a 16                	push   $0x16
  jmp alltraps
80106ad1:	e9 31 fa ff ff       	jmp    80106507 <alltraps>

80106ad6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $23
80106ad8:	6a 17                	push   $0x17
  jmp alltraps
80106ada:	e9 28 fa ff ff       	jmp    80106507 <alltraps>

80106adf <vector24>:
.globl vector24
vector24:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $24
80106ae1:	6a 18                	push   $0x18
  jmp alltraps
80106ae3:	e9 1f fa ff ff       	jmp    80106507 <alltraps>

80106ae8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $25
80106aea:	6a 19                	push   $0x19
  jmp alltraps
80106aec:	e9 16 fa ff ff       	jmp    80106507 <alltraps>

80106af1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $26
80106af3:	6a 1a                	push   $0x1a
  jmp alltraps
80106af5:	e9 0d fa ff ff       	jmp    80106507 <alltraps>

80106afa <vector27>:
.globl vector27
vector27:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $27
80106afc:	6a 1b                	push   $0x1b
  jmp alltraps
80106afe:	e9 04 fa ff ff       	jmp    80106507 <alltraps>

80106b03 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $28
80106b05:	6a 1c                	push   $0x1c
  jmp alltraps
80106b07:	e9 fb f9 ff ff       	jmp    80106507 <alltraps>

80106b0c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $29
80106b0e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b10:	e9 f2 f9 ff ff       	jmp    80106507 <alltraps>

80106b15 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $30
80106b17:	6a 1e                	push   $0x1e
  jmp alltraps
80106b19:	e9 e9 f9 ff ff       	jmp    80106507 <alltraps>

80106b1e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $31
80106b20:	6a 1f                	push   $0x1f
  jmp alltraps
80106b22:	e9 e0 f9 ff ff       	jmp    80106507 <alltraps>

80106b27 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $32
80106b29:	6a 20                	push   $0x20
  jmp alltraps
80106b2b:	e9 d7 f9 ff ff       	jmp    80106507 <alltraps>

80106b30 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $33
80106b32:	6a 21                	push   $0x21
  jmp alltraps
80106b34:	e9 ce f9 ff ff       	jmp    80106507 <alltraps>

80106b39 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $34
80106b3b:	6a 22                	push   $0x22
  jmp alltraps
80106b3d:	e9 c5 f9 ff ff       	jmp    80106507 <alltraps>

80106b42 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $35
80106b44:	6a 23                	push   $0x23
  jmp alltraps
80106b46:	e9 bc f9 ff ff       	jmp    80106507 <alltraps>

80106b4b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $36
80106b4d:	6a 24                	push   $0x24
  jmp alltraps
80106b4f:	e9 b3 f9 ff ff       	jmp    80106507 <alltraps>

80106b54 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $37
80106b56:	6a 25                	push   $0x25
  jmp alltraps
80106b58:	e9 aa f9 ff ff       	jmp    80106507 <alltraps>

80106b5d <vector38>:
.globl vector38
vector38:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $38
80106b5f:	6a 26                	push   $0x26
  jmp alltraps
80106b61:	e9 a1 f9 ff ff       	jmp    80106507 <alltraps>

80106b66 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $39
80106b68:	6a 27                	push   $0x27
  jmp alltraps
80106b6a:	e9 98 f9 ff ff       	jmp    80106507 <alltraps>

80106b6f <vector40>:
.globl vector40
vector40:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $40
80106b71:	6a 28                	push   $0x28
  jmp alltraps
80106b73:	e9 8f f9 ff ff       	jmp    80106507 <alltraps>

80106b78 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $41
80106b7a:	6a 29                	push   $0x29
  jmp alltraps
80106b7c:	e9 86 f9 ff ff       	jmp    80106507 <alltraps>

80106b81 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $42
80106b83:	6a 2a                	push   $0x2a
  jmp alltraps
80106b85:	e9 7d f9 ff ff       	jmp    80106507 <alltraps>

80106b8a <vector43>:
.globl vector43
vector43:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $43
80106b8c:	6a 2b                	push   $0x2b
  jmp alltraps
80106b8e:	e9 74 f9 ff ff       	jmp    80106507 <alltraps>

80106b93 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $44
80106b95:	6a 2c                	push   $0x2c
  jmp alltraps
80106b97:	e9 6b f9 ff ff       	jmp    80106507 <alltraps>

80106b9c <vector45>:
.globl vector45
vector45:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $45
80106b9e:	6a 2d                	push   $0x2d
  jmp alltraps
80106ba0:	e9 62 f9 ff ff       	jmp    80106507 <alltraps>

80106ba5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $46
80106ba7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ba9:	e9 59 f9 ff ff       	jmp    80106507 <alltraps>

80106bae <vector47>:
.globl vector47
vector47:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $47
80106bb0:	6a 2f                	push   $0x2f
  jmp alltraps
80106bb2:	e9 50 f9 ff ff       	jmp    80106507 <alltraps>

80106bb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $48
80106bb9:	6a 30                	push   $0x30
  jmp alltraps
80106bbb:	e9 47 f9 ff ff       	jmp    80106507 <alltraps>

80106bc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $49
80106bc2:	6a 31                	push   $0x31
  jmp alltraps
80106bc4:	e9 3e f9 ff ff       	jmp    80106507 <alltraps>

80106bc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $50
80106bcb:	6a 32                	push   $0x32
  jmp alltraps
80106bcd:	e9 35 f9 ff ff       	jmp    80106507 <alltraps>

80106bd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $51
80106bd4:	6a 33                	push   $0x33
  jmp alltraps
80106bd6:	e9 2c f9 ff ff       	jmp    80106507 <alltraps>

80106bdb <vector52>:
.globl vector52
vector52:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $52
80106bdd:	6a 34                	push   $0x34
  jmp alltraps
80106bdf:	e9 23 f9 ff ff       	jmp    80106507 <alltraps>

80106be4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $53
80106be6:	6a 35                	push   $0x35
  jmp alltraps
80106be8:	e9 1a f9 ff ff       	jmp    80106507 <alltraps>

80106bed <vector54>:
.globl vector54
vector54:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $54
80106bef:	6a 36                	push   $0x36
  jmp alltraps
80106bf1:	e9 11 f9 ff ff       	jmp    80106507 <alltraps>

80106bf6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $55
80106bf8:	6a 37                	push   $0x37
  jmp alltraps
80106bfa:	e9 08 f9 ff ff       	jmp    80106507 <alltraps>

80106bff <vector56>:
.globl vector56
vector56:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $56
80106c01:	6a 38                	push   $0x38
  jmp alltraps
80106c03:	e9 ff f8 ff ff       	jmp    80106507 <alltraps>

80106c08 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $57
80106c0a:	6a 39                	push   $0x39
  jmp alltraps
80106c0c:	e9 f6 f8 ff ff       	jmp    80106507 <alltraps>

80106c11 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $58
80106c13:	6a 3a                	push   $0x3a
  jmp alltraps
80106c15:	e9 ed f8 ff ff       	jmp    80106507 <alltraps>

80106c1a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $59
80106c1c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c1e:	e9 e4 f8 ff ff       	jmp    80106507 <alltraps>

80106c23 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $60
80106c25:	6a 3c                	push   $0x3c
  jmp alltraps
80106c27:	e9 db f8 ff ff       	jmp    80106507 <alltraps>

80106c2c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $61
80106c2e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c30:	e9 d2 f8 ff ff       	jmp    80106507 <alltraps>

80106c35 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $62
80106c37:	6a 3e                	push   $0x3e
  jmp alltraps
80106c39:	e9 c9 f8 ff ff       	jmp    80106507 <alltraps>

80106c3e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $63
80106c40:	6a 3f                	push   $0x3f
  jmp alltraps
80106c42:	e9 c0 f8 ff ff       	jmp    80106507 <alltraps>

80106c47 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $64
80106c49:	6a 40                	push   $0x40
  jmp alltraps
80106c4b:	e9 b7 f8 ff ff       	jmp    80106507 <alltraps>

80106c50 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $65
80106c52:	6a 41                	push   $0x41
  jmp alltraps
80106c54:	e9 ae f8 ff ff       	jmp    80106507 <alltraps>

80106c59 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $66
80106c5b:	6a 42                	push   $0x42
  jmp alltraps
80106c5d:	e9 a5 f8 ff ff       	jmp    80106507 <alltraps>

80106c62 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $67
80106c64:	6a 43                	push   $0x43
  jmp alltraps
80106c66:	e9 9c f8 ff ff       	jmp    80106507 <alltraps>

80106c6b <vector68>:
.globl vector68
vector68:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $68
80106c6d:	6a 44                	push   $0x44
  jmp alltraps
80106c6f:	e9 93 f8 ff ff       	jmp    80106507 <alltraps>

80106c74 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $69
80106c76:	6a 45                	push   $0x45
  jmp alltraps
80106c78:	e9 8a f8 ff ff       	jmp    80106507 <alltraps>

80106c7d <vector70>:
.globl vector70
vector70:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $70
80106c7f:	6a 46                	push   $0x46
  jmp alltraps
80106c81:	e9 81 f8 ff ff       	jmp    80106507 <alltraps>

80106c86 <vector71>:
.globl vector71
vector71:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $71
80106c88:	6a 47                	push   $0x47
  jmp alltraps
80106c8a:	e9 78 f8 ff ff       	jmp    80106507 <alltraps>

80106c8f <vector72>:
.globl vector72
vector72:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $72
80106c91:	6a 48                	push   $0x48
  jmp alltraps
80106c93:	e9 6f f8 ff ff       	jmp    80106507 <alltraps>

80106c98 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $73
80106c9a:	6a 49                	push   $0x49
  jmp alltraps
80106c9c:	e9 66 f8 ff ff       	jmp    80106507 <alltraps>

80106ca1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $74
80106ca3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ca5:	e9 5d f8 ff ff       	jmp    80106507 <alltraps>

80106caa <vector75>:
.globl vector75
vector75:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $75
80106cac:	6a 4b                	push   $0x4b
  jmp alltraps
80106cae:	e9 54 f8 ff ff       	jmp    80106507 <alltraps>

80106cb3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $76
80106cb5:	6a 4c                	push   $0x4c
  jmp alltraps
80106cb7:	e9 4b f8 ff ff       	jmp    80106507 <alltraps>

80106cbc <vector77>:
.globl vector77
vector77:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $77
80106cbe:	6a 4d                	push   $0x4d
  jmp alltraps
80106cc0:	e9 42 f8 ff ff       	jmp    80106507 <alltraps>

80106cc5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $78
80106cc7:	6a 4e                	push   $0x4e
  jmp alltraps
80106cc9:	e9 39 f8 ff ff       	jmp    80106507 <alltraps>

80106cce <vector79>:
.globl vector79
vector79:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $79
80106cd0:	6a 4f                	push   $0x4f
  jmp alltraps
80106cd2:	e9 30 f8 ff ff       	jmp    80106507 <alltraps>

80106cd7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $80
80106cd9:	6a 50                	push   $0x50
  jmp alltraps
80106cdb:	e9 27 f8 ff ff       	jmp    80106507 <alltraps>

80106ce0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $81
80106ce2:	6a 51                	push   $0x51
  jmp alltraps
80106ce4:	e9 1e f8 ff ff       	jmp    80106507 <alltraps>

80106ce9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $82
80106ceb:	6a 52                	push   $0x52
  jmp alltraps
80106ced:	e9 15 f8 ff ff       	jmp    80106507 <alltraps>

80106cf2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $83
80106cf4:	6a 53                	push   $0x53
  jmp alltraps
80106cf6:	e9 0c f8 ff ff       	jmp    80106507 <alltraps>

80106cfb <vector84>:
.globl vector84
vector84:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $84
80106cfd:	6a 54                	push   $0x54
  jmp alltraps
80106cff:	e9 03 f8 ff ff       	jmp    80106507 <alltraps>

80106d04 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $85
80106d06:	6a 55                	push   $0x55
  jmp alltraps
80106d08:	e9 fa f7 ff ff       	jmp    80106507 <alltraps>

80106d0d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $86
80106d0f:	6a 56                	push   $0x56
  jmp alltraps
80106d11:	e9 f1 f7 ff ff       	jmp    80106507 <alltraps>

80106d16 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $87
80106d18:	6a 57                	push   $0x57
  jmp alltraps
80106d1a:	e9 e8 f7 ff ff       	jmp    80106507 <alltraps>

80106d1f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $88
80106d21:	6a 58                	push   $0x58
  jmp alltraps
80106d23:	e9 df f7 ff ff       	jmp    80106507 <alltraps>

80106d28 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $89
80106d2a:	6a 59                	push   $0x59
  jmp alltraps
80106d2c:	e9 d6 f7 ff ff       	jmp    80106507 <alltraps>

80106d31 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $90
80106d33:	6a 5a                	push   $0x5a
  jmp alltraps
80106d35:	e9 cd f7 ff ff       	jmp    80106507 <alltraps>

80106d3a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $91
80106d3c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d3e:	e9 c4 f7 ff ff       	jmp    80106507 <alltraps>

80106d43 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $92
80106d45:	6a 5c                	push   $0x5c
  jmp alltraps
80106d47:	e9 bb f7 ff ff       	jmp    80106507 <alltraps>

80106d4c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $93
80106d4e:	6a 5d                	push   $0x5d
  jmp alltraps
80106d50:	e9 b2 f7 ff ff       	jmp    80106507 <alltraps>

80106d55 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $94
80106d57:	6a 5e                	push   $0x5e
  jmp alltraps
80106d59:	e9 a9 f7 ff ff       	jmp    80106507 <alltraps>

80106d5e <vector95>:
.globl vector95
vector95:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $95
80106d60:	6a 5f                	push   $0x5f
  jmp alltraps
80106d62:	e9 a0 f7 ff ff       	jmp    80106507 <alltraps>

80106d67 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $96
80106d69:	6a 60                	push   $0x60
  jmp alltraps
80106d6b:	e9 97 f7 ff ff       	jmp    80106507 <alltraps>

80106d70 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $97
80106d72:	6a 61                	push   $0x61
  jmp alltraps
80106d74:	e9 8e f7 ff ff       	jmp    80106507 <alltraps>

80106d79 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $98
80106d7b:	6a 62                	push   $0x62
  jmp alltraps
80106d7d:	e9 85 f7 ff ff       	jmp    80106507 <alltraps>

80106d82 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $99
80106d84:	6a 63                	push   $0x63
  jmp alltraps
80106d86:	e9 7c f7 ff ff       	jmp    80106507 <alltraps>

80106d8b <vector100>:
.globl vector100
vector100:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $100
80106d8d:	6a 64                	push   $0x64
  jmp alltraps
80106d8f:	e9 73 f7 ff ff       	jmp    80106507 <alltraps>

80106d94 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $101
80106d96:	6a 65                	push   $0x65
  jmp alltraps
80106d98:	e9 6a f7 ff ff       	jmp    80106507 <alltraps>

80106d9d <vector102>:
.globl vector102
vector102:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $102
80106d9f:	6a 66                	push   $0x66
  jmp alltraps
80106da1:	e9 61 f7 ff ff       	jmp    80106507 <alltraps>

80106da6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $103
80106da8:	6a 67                	push   $0x67
  jmp alltraps
80106daa:	e9 58 f7 ff ff       	jmp    80106507 <alltraps>

80106daf <vector104>:
.globl vector104
vector104:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $104
80106db1:	6a 68                	push   $0x68
  jmp alltraps
80106db3:	e9 4f f7 ff ff       	jmp    80106507 <alltraps>

80106db8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $105
80106dba:	6a 69                	push   $0x69
  jmp alltraps
80106dbc:	e9 46 f7 ff ff       	jmp    80106507 <alltraps>

80106dc1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $106
80106dc3:	6a 6a                	push   $0x6a
  jmp alltraps
80106dc5:	e9 3d f7 ff ff       	jmp    80106507 <alltraps>

80106dca <vector107>:
.globl vector107
vector107:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $107
80106dcc:	6a 6b                	push   $0x6b
  jmp alltraps
80106dce:	e9 34 f7 ff ff       	jmp    80106507 <alltraps>

80106dd3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $108
80106dd5:	6a 6c                	push   $0x6c
  jmp alltraps
80106dd7:	e9 2b f7 ff ff       	jmp    80106507 <alltraps>

80106ddc <vector109>:
.globl vector109
vector109:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $109
80106dde:	6a 6d                	push   $0x6d
  jmp alltraps
80106de0:	e9 22 f7 ff ff       	jmp    80106507 <alltraps>

80106de5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $110
80106de7:	6a 6e                	push   $0x6e
  jmp alltraps
80106de9:	e9 19 f7 ff ff       	jmp    80106507 <alltraps>

80106dee <vector111>:
.globl vector111
vector111:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $111
80106df0:	6a 6f                	push   $0x6f
  jmp alltraps
80106df2:	e9 10 f7 ff ff       	jmp    80106507 <alltraps>

80106df7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $112
80106df9:	6a 70                	push   $0x70
  jmp alltraps
80106dfb:	e9 07 f7 ff ff       	jmp    80106507 <alltraps>

80106e00 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $113
80106e02:	6a 71                	push   $0x71
  jmp alltraps
80106e04:	e9 fe f6 ff ff       	jmp    80106507 <alltraps>

80106e09 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $114
80106e0b:	6a 72                	push   $0x72
  jmp alltraps
80106e0d:	e9 f5 f6 ff ff       	jmp    80106507 <alltraps>

80106e12 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $115
80106e14:	6a 73                	push   $0x73
  jmp alltraps
80106e16:	e9 ec f6 ff ff       	jmp    80106507 <alltraps>

80106e1b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $116
80106e1d:	6a 74                	push   $0x74
  jmp alltraps
80106e1f:	e9 e3 f6 ff ff       	jmp    80106507 <alltraps>

80106e24 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $117
80106e26:	6a 75                	push   $0x75
  jmp alltraps
80106e28:	e9 da f6 ff ff       	jmp    80106507 <alltraps>

80106e2d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $118
80106e2f:	6a 76                	push   $0x76
  jmp alltraps
80106e31:	e9 d1 f6 ff ff       	jmp    80106507 <alltraps>

80106e36 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $119
80106e38:	6a 77                	push   $0x77
  jmp alltraps
80106e3a:	e9 c8 f6 ff ff       	jmp    80106507 <alltraps>

80106e3f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $120
80106e41:	6a 78                	push   $0x78
  jmp alltraps
80106e43:	e9 bf f6 ff ff       	jmp    80106507 <alltraps>

80106e48 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $121
80106e4a:	6a 79                	push   $0x79
  jmp alltraps
80106e4c:	e9 b6 f6 ff ff       	jmp    80106507 <alltraps>

80106e51 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $122
80106e53:	6a 7a                	push   $0x7a
  jmp alltraps
80106e55:	e9 ad f6 ff ff       	jmp    80106507 <alltraps>

80106e5a <vector123>:
.globl vector123
vector123:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $123
80106e5c:	6a 7b                	push   $0x7b
  jmp alltraps
80106e5e:	e9 a4 f6 ff ff       	jmp    80106507 <alltraps>

80106e63 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $124
80106e65:	6a 7c                	push   $0x7c
  jmp alltraps
80106e67:	e9 9b f6 ff ff       	jmp    80106507 <alltraps>

80106e6c <vector125>:
.globl vector125
vector125:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $125
80106e6e:	6a 7d                	push   $0x7d
  jmp alltraps
80106e70:	e9 92 f6 ff ff       	jmp    80106507 <alltraps>

80106e75 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $126
80106e77:	6a 7e                	push   $0x7e
  jmp alltraps
80106e79:	e9 89 f6 ff ff       	jmp    80106507 <alltraps>

80106e7e <vector127>:
.globl vector127
vector127:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $127
80106e80:	6a 7f                	push   $0x7f
  jmp alltraps
80106e82:	e9 80 f6 ff ff       	jmp    80106507 <alltraps>

80106e87 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $128
80106e89:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e8e:	e9 74 f6 ff ff       	jmp    80106507 <alltraps>

80106e93 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $129
80106e95:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e9a:	e9 68 f6 ff ff       	jmp    80106507 <alltraps>

80106e9f <vector130>:
.globl vector130
vector130:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $130
80106ea1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ea6:	e9 5c f6 ff ff       	jmp    80106507 <alltraps>

80106eab <vector131>:
.globl vector131
vector131:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $131
80106ead:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106eb2:	e9 50 f6 ff ff       	jmp    80106507 <alltraps>

80106eb7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $132
80106eb9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ebe:	e9 44 f6 ff ff       	jmp    80106507 <alltraps>

80106ec3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $133
80106ec5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106eca:	e9 38 f6 ff ff       	jmp    80106507 <alltraps>

80106ecf <vector134>:
.globl vector134
vector134:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $134
80106ed1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ed6:	e9 2c f6 ff ff       	jmp    80106507 <alltraps>

80106edb <vector135>:
.globl vector135
vector135:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $135
80106edd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ee2:	e9 20 f6 ff ff       	jmp    80106507 <alltraps>

80106ee7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $136
80106ee9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106eee:	e9 14 f6 ff ff       	jmp    80106507 <alltraps>

80106ef3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $137
80106ef5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106efa:	e9 08 f6 ff ff       	jmp    80106507 <alltraps>

80106eff <vector138>:
.globl vector138
vector138:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $138
80106f01:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f06:	e9 fc f5 ff ff       	jmp    80106507 <alltraps>

80106f0b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $139
80106f0d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f12:	e9 f0 f5 ff ff       	jmp    80106507 <alltraps>

80106f17 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $140
80106f19:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f1e:	e9 e4 f5 ff ff       	jmp    80106507 <alltraps>

80106f23 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $141
80106f25:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f2a:	e9 d8 f5 ff ff       	jmp    80106507 <alltraps>

80106f2f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $142
80106f31:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f36:	e9 cc f5 ff ff       	jmp    80106507 <alltraps>

80106f3b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $143
80106f3d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f42:	e9 c0 f5 ff ff       	jmp    80106507 <alltraps>

80106f47 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $144
80106f49:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f4e:	e9 b4 f5 ff ff       	jmp    80106507 <alltraps>

80106f53 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $145
80106f55:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f5a:	e9 a8 f5 ff ff       	jmp    80106507 <alltraps>

80106f5f <vector146>:
.globl vector146
vector146:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $146
80106f61:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f66:	e9 9c f5 ff ff       	jmp    80106507 <alltraps>

80106f6b <vector147>:
.globl vector147
vector147:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $147
80106f6d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f72:	e9 90 f5 ff ff       	jmp    80106507 <alltraps>

80106f77 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $148
80106f79:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f7e:	e9 84 f5 ff ff       	jmp    80106507 <alltraps>

80106f83 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $149
80106f85:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f8a:	e9 78 f5 ff ff       	jmp    80106507 <alltraps>

80106f8f <vector150>:
.globl vector150
vector150:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $150
80106f91:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f96:	e9 6c f5 ff ff       	jmp    80106507 <alltraps>

80106f9b <vector151>:
.globl vector151
vector151:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $151
80106f9d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fa2:	e9 60 f5 ff ff       	jmp    80106507 <alltraps>

80106fa7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $152
80106fa9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fae:	e9 54 f5 ff ff       	jmp    80106507 <alltraps>

80106fb3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $153
80106fb5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fba:	e9 48 f5 ff ff       	jmp    80106507 <alltraps>

80106fbf <vector154>:
.globl vector154
vector154:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $154
80106fc1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fc6:	e9 3c f5 ff ff       	jmp    80106507 <alltraps>

80106fcb <vector155>:
.globl vector155
vector155:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $155
80106fcd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fd2:	e9 30 f5 ff ff       	jmp    80106507 <alltraps>

80106fd7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $156
80106fd9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fde:	e9 24 f5 ff ff       	jmp    80106507 <alltraps>

80106fe3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $157
80106fe5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106fea:	e9 18 f5 ff ff       	jmp    80106507 <alltraps>

80106fef <vector158>:
.globl vector158
vector158:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $158
80106ff1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ff6:	e9 0c f5 ff ff       	jmp    80106507 <alltraps>

80106ffb <vector159>:
.globl vector159
vector159:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $159
80106ffd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107002:	e9 00 f5 ff ff       	jmp    80106507 <alltraps>

80107007 <vector160>:
.globl vector160
vector160:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $160
80107009:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010700e:	e9 f4 f4 ff ff       	jmp    80106507 <alltraps>

80107013 <vector161>:
.globl vector161
vector161:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $161
80107015:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010701a:	e9 e8 f4 ff ff       	jmp    80106507 <alltraps>

8010701f <vector162>:
.globl vector162
vector162:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $162
80107021:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107026:	e9 dc f4 ff ff       	jmp    80106507 <alltraps>

8010702b <vector163>:
.globl vector163
vector163:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $163
8010702d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107032:	e9 d0 f4 ff ff       	jmp    80106507 <alltraps>

80107037 <vector164>:
.globl vector164
vector164:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $164
80107039:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010703e:	e9 c4 f4 ff ff       	jmp    80106507 <alltraps>

80107043 <vector165>:
.globl vector165
vector165:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $165
80107045:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010704a:	e9 b8 f4 ff ff       	jmp    80106507 <alltraps>

8010704f <vector166>:
.globl vector166
vector166:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $166
80107051:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107056:	e9 ac f4 ff ff       	jmp    80106507 <alltraps>

8010705b <vector167>:
.globl vector167
vector167:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $167
8010705d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107062:	e9 a0 f4 ff ff       	jmp    80106507 <alltraps>

80107067 <vector168>:
.globl vector168
vector168:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $168
80107069:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010706e:	e9 94 f4 ff ff       	jmp    80106507 <alltraps>

80107073 <vector169>:
.globl vector169
vector169:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $169
80107075:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010707a:	e9 88 f4 ff ff       	jmp    80106507 <alltraps>

8010707f <vector170>:
.globl vector170
vector170:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $170
80107081:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107086:	e9 7c f4 ff ff       	jmp    80106507 <alltraps>

8010708b <vector171>:
.globl vector171
vector171:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $171
8010708d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107092:	e9 70 f4 ff ff       	jmp    80106507 <alltraps>

80107097 <vector172>:
.globl vector172
vector172:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $172
80107099:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010709e:	e9 64 f4 ff ff       	jmp    80106507 <alltraps>

801070a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $173
801070a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070aa:	e9 58 f4 ff ff       	jmp    80106507 <alltraps>

801070af <vector174>:
.globl vector174
vector174:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $174
801070b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070b6:	e9 4c f4 ff ff       	jmp    80106507 <alltraps>

801070bb <vector175>:
.globl vector175
vector175:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $175
801070bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070c2:	e9 40 f4 ff ff       	jmp    80106507 <alltraps>

801070c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $176
801070c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070ce:	e9 34 f4 ff ff       	jmp    80106507 <alltraps>

801070d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $177
801070d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070da:	e9 28 f4 ff ff       	jmp    80106507 <alltraps>

801070df <vector178>:
.globl vector178
vector178:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $178
801070e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070e6:	e9 1c f4 ff ff       	jmp    80106507 <alltraps>

801070eb <vector179>:
.globl vector179
vector179:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $179
801070ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070f2:	e9 10 f4 ff ff       	jmp    80106507 <alltraps>

801070f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $180
801070f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070fe:	e9 04 f4 ff ff       	jmp    80106507 <alltraps>

80107103 <vector181>:
.globl vector181
vector181:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $181
80107105:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010710a:	e9 f8 f3 ff ff       	jmp    80106507 <alltraps>

8010710f <vector182>:
.globl vector182
vector182:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $182
80107111:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107116:	e9 ec f3 ff ff       	jmp    80106507 <alltraps>

8010711b <vector183>:
.globl vector183
vector183:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $183
8010711d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107122:	e9 e0 f3 ff ff       	jmp    80106507 <alltraps>

80107127 <vector184>:
.globl vector184
vector184:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $184
80107129:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010712e:	e9 d4 f3 ff ff       	jmp    80106507 <alltraps>

80107133 <vector185>:
.globl vector185
vector185:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $185
80107135:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010713a:	e9 c8 f3 ff ff       	jmp    80106507 <alltraps>

8010713f <vector186>:
.globl vector186
vector186:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $186
80107141:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107146:	e9 bc f3 ff ff       	jmp    80106507 <alltraps>

8010714b <vector187>:
.globl vector187
vector187:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $187
8010714d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107152:	e9 b0 f3 ff ff       	jmp    80106507 <alltraps>

80107157 <vector188>:
.globl vector188
vector188:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $188
80107159:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010715e:	e9 a4 f3 ff ff       	jmp    80106507 <alltraps>

80107163 <vector189>:
.globl vector189
vector189:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $189
80107165:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010716a:	e9 98 f3 ff ff       	jmp    80106507 <alltraps>

8010716f <vector190>:
.globl vector190
vector190:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $190
80107171:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107176:	e9 8c f3 ff ff       	jmp    80106507 <alltraps>

8010717b <vector191>:
.globl vector191
vector191:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $191
8010717d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107182:	e9 80 f3 ff ff       	jmp    80106507 <alltraps>

80107187 <vector192>:
.globl vector192
vector192:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $192
80107189:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010718e:	e9 74 f3 ff ff       	jmp    80106507 <alltraps>

80107193 <vector193>:
.globl vector193
vector193:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $193
80107195:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010719a:	e9 68 f3 ff ff       	jmp    80106507 <alltraps>

8010719f <vector194>:
.globl vector194
vector194:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $194
801071a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071a6:	e9 5c f3 ff ff       	jmp    80106507 <alltraps>

801071ab <vector195>:
.globl vector195
vector195:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $195
801071ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071b2:	e9 50 f3 ff ff       	jmp    80106507 <alltraps>

801071b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $196
801071b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071be:	e9 44 f3 ff ff       	jmp    80106507 <alltraps>

801071c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $197
801071c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071ca:	e9 38 f3 ff ff       	jmp    80106507 <alltraps>

801071cf <vector198>:
.globl vector198
vector198:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $198
801071d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071d6:	e9 2c f3 ff ff       	jmp    80106507 <alltraps>

801071db <vector199>:
.globl vector199
vector199:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $199
801071dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071e2:	e9 20 f3 ff ff       	jmp    80106507 <alltraps>

801071e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $200
801071e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071ee:	e9 14 f3 ff ff       	jmp    80106507 <alltraps>

801071f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $201
801071f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071fa:	e9 08 f3 ff ff       	jmp    80106507 <alltraps>

801071ff <vector202>:
.globl vector202
vector202:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $202
80107201:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107206:	e9 fc f2 ff ff       	jmp    80106507 <alltraps>

8010720b <vector203>:
.globl vector203
vector203:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $203
8010720d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107212:	e9 f0 f2 ff ff       	jmp    80106507 <alltraps>

80107217 <vector204>:
.globl vector204
vector204:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $204
80107219:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010721e:	e9 e4 f2 ff ff       	jmp    80106507 <alltraps>

80107223 <vector205>:
.globl vector205
vector205:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $205
80107225:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010722a:	e9 d8 f2 ff ff       	jmp    80106507 <alltraps>

8010722f <vector206>:
.globl vector206
vector206:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $206
80107231:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107236:	e9 cc f2 ff ff       	jmp    80106507 <alltraps>

8010723b <vector207>:
.globl vector207
vector207:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $207
8010723d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107242:	e9 c0 f2 ff ff       	jmp    80106507 <alltraps>

80107247 <vector208>:
.globl vector208
vector208:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $208
80107249:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010724e:	e9 b4 f2 ff ff       	jmp    80106507 <alltraps>

80107253 <vector209>:
.globl vector209
vector209:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $209
80107255:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010725a:	e9 a8 f2 ff ff       	jmp    80106507 <alltraps>

8010725f <vector210>:
.globl vector210
vector210:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $210
80107261:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107266:	e9 9c f2 ff ff       	jmp    80106507 <alltraps>

8010726b <vector211>:
.globl vector211
vector211:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $211
8010726d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107272:	e9 90 f2 ff ff       	jmp    80106507 <alltraps>

80107277 <vector212>:
.globl vector212
vector212:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $212
80107279:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010727e:	e9 84 f2 ff ff       	jmp    80106507 <alltraps>

80107283 <vector213>:
.globl vector213
vector213:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $213
80107285:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010728a:	e9 78 f2 ff ff       	jmp    80106507 <alltraps>

8010728f <vector214>:
.globl vector214
vector214:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $214
80107291:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107296:	e9 6c f2 ff ff       	jmp    80106507 <alltraps>

8010729b <vector215>:
.globl vector215
vector215:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $215
8010729d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072a2:	e9 60 f2 ff ff       	jmp    80106507 <alltraps>

801072a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $216
801072a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072ae:	e9 54 f2 ff ff       	jmp    80106507 <alltraps>

801072b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $217
801072b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072ba:	e9 48 f2 ff ff       	jmp    80106507 <alltraps>

801072bf <vector218>:
.globl vector218
vector218:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $218
801072c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072c6:	e9 3c f2 ff ff       	jmp    80106507 <alltraps>

801072cb <vector219>:
.globl vector219
vector219:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $219
801072cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072d2:	e9 30 f2 ff ff       	jmp    80106507 <alltraps>

801072d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $220
801072d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072de:	e9 24 f2 ff ff       	jmp    80106507 <alltraps>

801072e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $221
801072e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072ea:	e9 18 f2 ff ff       	jmp    80106507 <alltraps>

801072ef <vector222>:
.globl vector222
vector222:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $222
801072f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072f6:	e9 0c f2 ff ff       	jmp    80106507 <alltraps>

801072fb <vector223>:
.globl vector223
vector223:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $223
801072fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107302:	e9 00 f2 ff ff       	jmp    80106507 <alltraps>

80107307 <vector224>:
.globl vector224
vector224:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $224
80107309:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010730e:	e9 f4 f1 ff ff       	jmp    80106507 <alltraps>

80107313 <vector225>:
.globl vector225
vector225:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $225
80107315:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010731a:	e9 e8 f1 ff ff       	jmp    80106507 <alltraps>

8010731f <vector226>:
.globl vector226
vector226:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $226
80107321:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107326:	e9 dc f1 ff ff       	jmp    80106507 <alltraps>

8010732b <vector227>:
.globl vector227
vector227:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $227
8010732d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107332:	e9 d0 f1 ff ff       	jmp    80106507 <alltraps>

80107337 <vector228>:
.globl vector228
vector228:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $228
80107339:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010733e:	e9 c4 f1 ff ff       	jmp    80106507 <alltraps>

80107343 <vector229>:
.globl vector229
vector229:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $229
80107345:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010734a:	e9 b8 f1 ff ff       	jmp    80106507 <alltraps>

8010734f <vector230>:
.globl vector230
vector230:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $230
80107351:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107356:	e9 ac f1 ff ff       	jmp    80106507 <alltraps>

8010735b <vector231>:
.globl vector231
vector231:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $231
8010735d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107362:	e9 a0 f1 ff ff       	jmp    80106507 <alltraps>

80107367 <vector232>:
.globl vector232
vector232:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $232
80107369:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010736e:	e9 94 f1 ff ff       	jmp    80106507 <alltraps>

80107373 <vector233>:
.globl vector233
vector233:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $233
80107375:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010737a:	e9 88 f1 ff ff       	jmp    80106507 <alltraps>

8010737f <vector234>:
.globl vector234
vector234:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $234
80107381:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107386:	e9 7c f1 ff ff       	jmp    80106507 <alltraps>

8010738b <vector235>:
.globl vector235
vector235:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $235
8010738d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107392:	e9 70 f1 ff ff       	jmp    80106507 <alltraps>

80107397 <vector236>:
.globl vector236
vector236:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $236
80107399:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010739e:	e9 64 f1 ff ff       	jmp    80106507 <alltraps>

801073a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $237
801073a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073aa:	e9 58 f1 ff ff       	jmp    80106507 <alltraps>

801073af <vector238>:
.globl vector238
vector238:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $238
801073b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073b6:	e9 4c f1 ff ff       	jmp    80106507 <alltraps>

801073bb <vector239>:
.globl vector239
vector239:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $239
801073bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073c2:	e9 40 f1 ff ff       	jmp    80106507 <alltraps>

801073c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $240
801073c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073ce:	e9 34 f1 ff ff       	jmp    80106507 <alltraps>

801073d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $241
801073d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073da:	e9 28 f1 ff ff       	jmp    80106507 <alltraps>

801073df <vector242>:
.globl vector242
vector242:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $242
801073e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073e6:	e9 1c f1 ff ff       	jmp    80106507 <alltraps>

801073eb <vector243>:
.globl vector243
vector243:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $243
801073ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073f2:	e9 10 f1 ff ff       	jmp    80106507 <alltraps>

801073f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $244
801073f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073fe:	e9 04 f1 ff ff       	jmp    80106507 <alltraps>

80107403 <vector245>:
.globl vector245
vector245:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $245
80107405:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010740a:	e9 f8 f0 ff ff       	jmp    80106507 <alltraps>

8010740f <vector246>:
.globl vector246
vector246:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $246
80107411:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107416:	e9 ec f0 ff ff       	jmp    80106507 <alltraps>

8010741b <vector247>:
.globl vector247
vector247:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $247
8010741d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107422:	e9 e0 f0 ff ff       	jmp    80106507 <alltraps>

80107427 <vector248>:
.globl vector248
vector248:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $248
80107429:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010742e:	e9 d4 f0 ff ff       	jmp    80106507 <alltraps>

80107433 <vector249>:
.globl vector249
vector249:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $249
80107435:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010743a:	e9 c8 f0 ff ff       	jmp    80106507 <alltraps>

8010743f <vector250>:
.globl vector250
vector250:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $250
80107441:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107446:	e9 bc f0 ff ff       	jmp    80106507 <alltraps>

8010744b <vector251>:
.globl vector251
vector251:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $251
8010744d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107452:	e9 b0 f0 ff ff       	jmp    80106507 <alltraps>

80107457 <vector252>:
.globl vector252
vector252:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $252
80107459:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010745e:	e9 a4 f0 ff ff       	jmp    80106507 <alltraps>

80107463 <vector253>:
.globl vector253
vector253:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $253
80107465:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010746a:	e9 98 f0 ff ff       	jmp    80106507 <alltraps>

8010746f <vector254>:
.globl vector254
vector254:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $254
80107471:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107476:	e9 8c f0 ff ff       	jmp    80106507 <alltraps>

8010747b <vector255>:
.globl vector255
vector255:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $255
8010747d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107482:	e9 80 f0 ff ff       	jmp    80106507 <alltraps>
80107487:	66 90                	xchg   %ax,%ax
80107489:	66 90                	xchg   %ax,%ax
8010748b:	66 90                	xchg   %ax,%ax
8010748d:	66 90                	xchg   %ax,%ax
8010748f:	90                   	nop

80107490 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107490:	55                   	push   %ebp
80107491:	89 e5                	mov    %esp,%ebp
80107493:	57                   	push   %edi
80107494:	56                   	push   %esi
80107495:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80107496:	89 d3                	mov    %edx,%ebx
{
80107498:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010749a:	c1 eb 16             	shr    $0x16,%ebx
8010749d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
801074a0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801074a3:	8b 06                	mov    (%esi),%eax
801074a5:	a8 01                	test   $0x1,%al
801074a7:	74 27                	je     801074d0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801074a9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801074ae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801074b4:	c1 ef 0a             	shr    $0xa,%edi
}
801074b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801074ba:	89 fa                	mov    %edi,%edx
801074bc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801074c2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801074c5:	5b                   	pop    %ebx
801074c6:	5e                   	pop    %esi
801074c7:	5f                   	pop    %edi
801074c8:	5d                   	pop    %ebp
801074c9:	c3                   	ret    
801074ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801074d0:	85 c9                	test   %ecx,%ecx
801074d2:	74 2c                	je     80107500 <walkpgdir+0x70>
801074d4:	e8 67 b8 ff ff       	call   80102d40 <kalloc>
801074d9:	85 c0                	test   %eax,%eax
801074db:	89 c3                	mov    %eax,%ebx
801074dd:	74 21                	je     80107500 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074df:	83 ec 04             	sub    $0x4,%esp
801074e2:	68 00 10 00 00       	push   $0x1000
801074e7:	6a 00                	push   $0x0
801074e9:	50                   	push   %eax
801074ea:	e8 b1 dd ff ff       	call   801052a0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801074ef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801074f5:	83 c4 10             	add    $0x10,%esp
801074f8:	83 c8 07             	or     $0x7,%eax
801074fb:	89 06                	mov    %eax,(%esi)
801074fd:	eb b5                	jmp    801074b4 <walkpgdir+0x24>
801074ff:	90                   	nop
}
80107500:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107503:	31 c0                	xor    %eax,%eax
}
80107505:	5b                   	pop    %ebx
80107506:	5e                   	pop    %esi
80107507:	5f                   	pop    %edi
80107508:	5d                   	pop    %ebp
80107509:	c3                   	ret    
8010750a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107510 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107516:	89 d3                	mov    %edx,%ebx
80107518:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010751e:	83 ec 1c             	sub    $0x1c,%esp
80107521:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107524:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80107528:	8b 7d 08             	mov    0x8(%ebp),%edi
8010752b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80107533:	8b 45 0c             	mov    0xc(%ebp),%eax
80107536:	29 df                	sub    %ebx,%edi
80107538:	83 c8 01             	or     $0x1,%eax
8010753b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010753e:	eb 15                	jmp    80107555 <mappages+0x45>
    if(*pte & PTE_P)
80107540:	f6 00 01             	testb  $0x1,(%eax)
80107543:	75 45                	jne    8010758a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80107545:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80107548:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010754b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010754d:	74 31                	je     80107580 <mappages+0x70>
      break;
    a += PGSIZE;
8010754f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107558:	b9 01 00 00 00       	mov    $0x1,%ecx
8010755d:	89 da                	mov    %ebx,%edx
8010755f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80107562:	e8 29 ff ff ff       	call   80107490 <walkpgdir>
80107567:	85 c0                	test   %eax,%eax
80107569:	75 d5                	jne    80107540 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010756b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010756e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107573:	5b                   	pop    %ebx
80107574:	5e                   	pop    %esi
80107575:	5f                   	pop    %edi
80107576:	5d                   	pop    %ebp
80107577:	c3                   	ret    
80107578:	90                   	nop
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107580:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107583:	31 c0                	xor    %eax,%eax
}
80107585:	5b                   	pop    %ebx
80107586:	5e                   	pop    %esi
80107587:	5f                   	pop    %edi
80107588:	5d                   	pop    %ebp
80107589:	c3                   	ret    
      panic("remap");
8010758a:	83 ec 0c             	sub    $0xc,%esp
8010758d:	68 18 9b 10 80       	push   $0x80109b18
80107592:	e8 f9 8d ff ff       	call   80100390 <panic>
80107597:	89 f6                	mov    %esi,%esi
80107599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801075a0 <printlist>:
{
801075a0:	55                   	push   %ebp
801075a1:	89 e5                	mov    %esp,%ebp
801075a3:	56                   	push   %esi
801075a4:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
801075a5:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
801075aa:	83 ec 0c             	sub    $0xc,%esp
801075ad:	68 1e 9b 10 80       	push   $0x80109b1e
801075b2:	e8 a9 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
801075b7:	e8 44 cd ff ff       	call   80104300 <myproc>
801075bc:	83 c4 10             	add    $0x10,%esp
801075bf:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
801075c5:	eb 0e                	jmp    801075d5 <printlist+0x35>
801075c7:	89 f6                	mov    %esi,%esi
801075c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
801075d0:	83 ee 01             	sub    $0x1,%esi
801075d3:	74 19                	je     801075ee <printlist+0x4e>
    cprintf("%d -> ", curr->off);
801075d5:	83 ec 08             	sub    $0x8,%esp
801075d8:	ff 33                	pushl  (%ebx)
801075da:	68 2e 9b 10 80       	push   $0x80109b2e
801075df:	e8 7c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801075e4:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
801075e7:	83 c4 10             	add    $0x10,%esp
801075ea:	85 db                	test   %ebx,%ebx
801075ec:	75 e2                	jne    801075d0 <printlist+0x30>
  cprintf("\n");
801075ee:	83 ec 0c             	sub    $0xc,%esp
801075f1:	68 17 9d 10 80       	push   $0x80109d17
801075f6:	e8 65 90 ff ff       	call   80100660 <cprintf>
}
801075fb:	83 c4 10             	add    $0x10,%esp
801075fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107601:	5b                   	pop    %ebx
80107602:	5e                   	pop    %esi
80107603:	5d                   	pop    %ebp
80107604:	c3                   	ret    
80107605:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107610 <printaq>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	53                   	push   %ebx
80107614:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
80107617:	68 35 9b 10 80       	push   $0x80109b35
8010761c:	e8 3f 90 ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107621:	e8 da cc ff ff       	call   80104300 <myproc>
80107626:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010762c:	8b 58 08             	mov    0x8(%eax),%ebx
8010762f:	e8 cc cc ff ff       	call   80104300 <myproc>
80107634:	83 c4 0c             	add    $0xc,%esp
80107637:	53                   	push   %ebx
80107638:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010763e:	ff 70 08             	pushl  0x8(%eax)
80107641:	68 47 9b 10 80       	push   $0x80109b47
80107646:	e8 15 90 ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010764b:	e8 b0 cc ff ff       	call   80104300 <myproc>
80107650:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107656:	83 c4 10             	add    $0x10,%esp
80107659:	8b 50 04             	mov    0x4(%eax),%edx
8010765c:	85 d2                	test   %edx,%edx
8010765e:	74 68                	je     801076c8 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
80107660:	e8 9b cc ff ff       	call   80104300 <myproc>
80107665:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010766b:	85 db                	test   %ebx,%ebx
8010766d:	74 1a                	je     80107689 <printaq+0x79>
8010766f:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
80107670:	83 ec 08             	sub    $0x8,%esp
80107673:	ff 73 08             	pushl  0x8(%ebx)
80107676:	68 65 9b 10 80       	push   $0x80109b65
8010767b:	e8 e0 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107680:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
80107682:	83 c4 10             	add    $0x10,%esp
80107685:	85 db                	test   %ebx,%ebx
80107687:	75 e7                	jne    80107670 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
80107689:	e8 72 cc ff ff       	call   80104300 <myproc>
8010768e:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80107694:	8b 00                	mov    (%eax),%eax
80107696:	85 c0                	test   %eax,%eax
80107698:	74 16                	je     801076b0 <printaq+0xa0>
  cprintf("\n");
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	68 17 9d 10 80       	push   $0x80109d17
801076a2:	e8 b9 8f ff ff       	call   80100660 <cprintf>
}
801076a7:	83 c4 10             	add    $0x10,%esp
801076aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076ad:	c9                   	leave  
801076ae:	c3                   	ret    
801076af:	90                   	nop
    cprintf("null <-> ");
801076b0:	83 ec 0c             	sub    $0xc,%esp
801076b3:	68 5b 9b 10 80       	push   $0x80109b5b
801076b8:	e8 a3 8f ff ff       	call   80100660 <cprintf>
801076bd:	83 c4 10             	add    $0x10,%esp
801076c0:	eb d8                	jmp    8010769a <printaq+0x8a>
801076c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
801076c8:	83 ec 0c             	sub    $0xc,%esp
801076cb:	68 5b 9b 10 80       	push   $0x80109b5b
801076d0:	e8 8b 8f ff ff       	call   80100660 <cprintf>
801076d5:	83 c4 10             	add    $0x10,%esp
801076d8:	eb 86                	jmp    80107660 <printaq+0x50>
801076da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076e0 <seginit>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801076e6:	e8 f5 cb ff ff       	call   801042e0 <cpuid>
801076eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801076f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801076f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801076fa:	c7 80 f8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a408(%eax)
80107701:	ff 00 00 
80107704:	c7 80 fc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a404(%eax)
8010770b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010770e:	c7 80 00 5c 18 80 ff 	movl   $0xffff,-0x7fe7a400(%eax)
80107715:	ff 00 00 
80107718:	c7 80 04 5c 18 80 00 	movl   $0xcf9200,-0x7fe7a3fc(%eax)
8010771f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107722:	c7 80 08 5c 18 80 ff 	movl   $0xffff,-0x7fe7a3f8(%eax)
80107729:	ff 00 00 
8010772c:	c7 80 0c 5c 18 80 00 	movl   $0xcffa00,-0x7fe7a3f4(%eax)
80107733:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107736:	c7 80 10 5c 18 80 ff 	movl   $0xffff,-0x7fe7a3f0(%eax)
8010773d:	ff 00 00 
80107740:	c7 80 14 5c 18 80 00 	movl   $0xcff200,-0x7fe7a3ec(%eax)
80107747:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010774a:	05 f0 5b 18 80       	add    $0x80185bf0,%eax
  pd[1] = (uint)p;
8010774f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107753:	c1 e8 10             	shr    $0x10,%eax
80107756:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010775a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010775d:	0f 01 10             	lgdtl  (%eax)
}
80107760:	c9                   	leave  
80107761:	c3                   	ret    
80107762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107770 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107770:	a1 a4 75 19 80       	mov    0x801975a4,%eax
{
80107775:	55                   	push   %ebp
80107776:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107778:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010777d:	0f 22 d8             	mov    %eax,%cr3
}
80107780:	5d                   	pop    %ebp
80107781:	c3                   	ret    
80107782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107790 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 1c             	sub    $0x1c,%esp
80107799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010779c:	85 db                	test   %ebx,%ebx
8010779e:	0f 84 cb 00 00 00    	je     8010786f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801077a4:	8b 43 08             	mov    0x8(%ebx),%eax
801077a7:	85 c0                	test   %eax,%eax
801077a9:	0f 84 da 00 00 00    	je     80107889 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801077af:	8b 43 04             	mov    0x4(%ebx),%eax
801077b2:	85 c0                	test   %eax,%eax
801077b4:	0f 84 c2 00 00 00    	je     8010787c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
801077ba:	e8 01 d9 ff ff       	call   801050c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077bf:	e8 9c ca ff ff       	call   80104260 <mycpu>
801077c4:	89 c6                	mov    %eax,%esi
801077c6:	e8 95 ca ff ff       	call   80104260 <mycpu>
801077cb:	89 c7                	mov    %eax,%edi
801077cd:	e8 8e ca ff ff       	call   80104260 <mycpu>
801077d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077d5:	83 c7 08             	add    $0x8,%edi
801077d8:	e8 83 ca ff ff       	call   80104260 <mycpu>
801077dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801077e0:	83 c0 08             	add    $0x8,%eax
801077e3:	ba 67 00 00 00       	mov    $0x67,%edx
801077e8:	c1 e8 18             	shr    $0x18,%eax
801077eb:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801077f2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801077f9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801077ff:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107804:	83 c1 08             	add    $0x8,%ecx
80107807:	c1 e9 10             	shr    $0x10,%ecx
8010780a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80107810:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107815:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010781c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80107821:	e8 3a ca ff ff       	call   80104260 <mycpu>
80107826:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010782d:	e8 2e ca ff ff       	call   80104260 <mycpu>
80107832:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107836:	8b 73 08             	mov    0x8(%ebx),%esi
80107839:	e8 22 ca ff ff       	call   80104260 <mycpu>
8010783e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107844:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107847:	e8 14 ca ff ff       	call   80104260 <mycpu>
8010784c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107850:	b8 28 00 00 00       	mov    $0x28,%eax
80107855:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107858:	8b 43 04             	mov    0x4(%ebx),%eax
8010785b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107860:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107863:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107866:	5b                   	pop    %ebx
80107867:	5e                   	pop    %esi
80107868:	5f                   	pop    %edi
80107869:	5d                   	pop    %ebp
  popcli();
8010786a:	e9 91 d8 ff ff       	jmp    80105100 <popcli>
    panic("switchuvm: no process");
8010786f:	83 ec 0c             	sub    $0xc,%esp
80107872:	68 6d 9b 10 80       	push   $0x80109b6d
80107877:	e8 14 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010787c:	83 ec 0c             	sub    $0xc,%esp
8010787f:	68 98 9b 10 80       	push   $0x80109b98
80107884:	e8 07 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107889:	83 ec 0c             	sub    $0xc,%esp
8010788c:	68 83 9b 10 80       	push   $0x80109b83
80107891:	e8 fa 8a ff ff       	call   80100390 <panic>
80107896:	8d 76 00             	lea    0x0(%esi),%esi
80107899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078a0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801078a0:	55                   	push   %ebp
801078a1:	89 e5                	mov    %esp,%ebp
801078a3:	57                   	push   %edi
801078a4:	56                   	push   %esi
801078a5:	53                   	push   %ebx
801078a6:	83 ec 1c             	sub    $0x1c,%esp
801078a9:	8b 75 10             	mov    0x10(%ebp),%esi
801078ac:	8b 45 08             	mov    0x8(%ebp),%eax
801078af:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801078b2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801078b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801078bb:	77 49                	ja     80107906 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
801078bd:	e8 7e b4 ff ff       	call   80102d40 <kalloc>
  memset(mem, 0, PGSIZE);
801078c2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801078c5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801078c7:	68 00 10 00 00       	push   $0x1000
801078cc:	6a 00                	push   $0x0
801078ce:	50                   	push   %eax
801078cf:	e8 cc d9 ff ff       	call   801052a0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801078d4:	58                   	pop    %eax
801078d5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801078db:	b9 00 10 00 00       	mov    $0x1000,%ecx
801078e0:	5a                   	pop    %edx
801078e1:	6a 06                	push   $0x6
801078e3:	50                   	push   %eax
801078e4:	31 d2                	xor    %edx,%edx
801078e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078e9:	e8 22 fc ff ff       	call   80107510 <mappages>
  memmove(mem, init, sz);
801078ee:	89 75 10             	mov    %esi,0x10(%ebp)
801078f1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801078f4:	83 c4 10             	add    $0x10,%esp
801078f7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801078fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078fd:	5b                   	pop    %ebx
801078fe:	5e                   	pop    %esi
801078ff:	5f                   	pop    %edi
80107900:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107901:	e9 4a da ff ff       	jmp    80105350 <memmove>
    panic("inituvm: more than a page");
80107906:	83 ec 0c             	sub    $0xc,%esp
80107909:	68 ac 9b 10 80       	push   $0x80109bac
8010790e:	e8 7d 8a ff ff       	call   80100390 <panic>
80107913:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107920 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	57                   	push   %edi
80107924:	56                   	push   %esi
80107925:	53                   	push   %ebx
80107926:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107929:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107930:	0f 85 91 00 00 00    	jne    801079c7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80107936:	8b 75 18             	mov    0x18(%ebp),%esi
80107939:	31 db                	xor    %ebx,%ebx
8010793b:	85 f6                	test   %esi,%esi
8010793d:	75 1a                	jne    80107959 <loaduvm+0x39>
8010793f:	eb 6f                	jmp    801079b0 <loaduvm+0x90>
80107941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107948:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010794e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107954:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107957:	76 57                	jbe    801079b0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107959:	8b 55 0c             	mov    0xc(%ebp),%edx
8010795c:	8b 45 08             	mov    0x8(%ebp),%eax
8010795f:	31 c9                	xor    %ecx,%ecx
80107961:	01 da                	add    %ebx,%edx
80107963:	e8 28 fb ff ff       	call   80107490 <walkpgdir>
80107968:	85 c0                	test   %eax,%eax
8010796a:	74 4e                	je     801079ba <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
8010796c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010796e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107971:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107976:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
8010797b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107981:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107984:	01 d9                	add    %ebx,%ecx
80107986:	05 00 00 00 80       	add    $0x80000000,%eax
8010798b:	57                   	push   %edi
8010798c:	51                   	push   %ecx
8010798d:	50                   	push   %eax
8010798e:	ff 75 10             	pushl  0x10(%ebp)
80107991:	e8 6a a3 ff ff       	call   80101d00 <readi>
80107996:	83 c4 10             	add    $0x10,%esp
80107999:	39 f8                	cmp    %edi,%eax
8010799b:	74 ab                	je     80107948 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010799d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a5:	5b                   	pop    %ebx
801079a6:	5e                   	pop    %esi
801079a7:	5f                   	pop    %edi
801079a8:	5d                   	pop    %ebp
801079a9:	c3                   	ret    
801079aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    
      panic("loaduvm: address should exist");
801079ba:	83 ec 0c             	sub    $0xc,%esp
801079bd:	68 c6 9b 10 80       	push   $0x80109bc6
801079c2:	e8 c9 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801079c7:	83 ec 0c             	sub    $0xc,%esp
801079ca:	68 5c 9d 10 80       	push   $0x80109d5c
801079cf:	e8 bc 89 ff ff       	call   80100390 <panic>
801079d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079e0 <update_selectionfiled_allocuvm>:
     
}

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	53                   	push   %ebx
801079e4:	83 ec 04             	sub    $0x4,%esp
801079e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  #if SELECTION == LAPA
    page->lapa_counter =  0xFFFFFFFF;
  #endif

  #if SELECTION == AQ
    struct queue_node * node = (struct queue_node*)kalloc();
801079ea:	e8 51 b3 ff ff       	call   80102d40 <kalloc>
    node->page_index = page_ramindex;
801079ef:	8b 55 10             	mov    0x10(%ebp),%edx
801079f2:	89 50 08             	mov    %edx,0x8(%eax)
    // cprintf("page ram index is: %d\n", page_ramindex);
    if(curproc->queue_head == 0 && curproc->queue_tail ==0)  //the first queue_node 
801079f5:	8b 93 1c 04 00 00    	mov    0x41c(%ebx),%edx
801079fb:	85 d2                	test   %edx,%edx
801079fd:	74 21                	je     80107a20 <update_selectionfiled_allocuvm+0x40>
      curproc-> queue_head->next = 0;
      curproc-> queue_head->prev = 0;
    }
    else
    {
      curproc->queue_head->prev = node;
801079ff:	89 42 04             	mov    %eax,0x4(%edx)
      node->next = curproc->queue_head;
80107a02:	8b 93 1c 04 00 00    	mov    0x41c(%ebx),%edx
80107a08:	89 10                	mov    %edx,(%eax)
      curproc->queue_head = node;
80107a0a:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
      curproc->queue_head->prev = 0;
80107a10:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    }
  #endif


}
80107a17:	83 c4 04             	add    $0x4,%esp
80107a1a:	5b                   	pop    %ebx
80107a1b:	5d                   	pop    %ebp
80107a1c:	c3                   	ret    
80107a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->queue_head == 0 && curproc->queue_tail ==0)  //the first queue_node 
80107a20:	8b 8b 20 04 00 00    	mov    0x420(%ebx),%ecx
80107a26:	85 c9                	test   %ecx,%ecx
80107a28:	75 d5                	jne    801079ff <update_selectionfiled_allocuvm+0x1f>
      curproc-> queue_head = node;
80107a2a:	89 83 1c 04 00 00    	mov    %eax,0x41c(%ebx)
      curproc-> queue_tail = node;
80107a30:	89 83 20 04 00 00    	mov    %eax,0x420(%ebx)
      curproc-> queue_head->next = 0;
80107a36:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      curproc-> queue_head->prev = 0;
80107a3c:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
      curproc-> queue_head->next = 0;
80107a49:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      curproc-> queue_head->prev = 0;
80107a55:	8b 83 1c 04 00 00    	mov    0x41c(%ebx),%eax
80107a5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80107a62:	eb b3                	jmp    80107a17 <update_selectionfiled_allocuvm+0x37>
80107a64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a70 <allocuvm_noswap>:
{
80107a70:	55                   	push   %ebp
80107a71:	89 e5                	mov    %esp,%ebp
80107a73:	56                   	push   %esi
80107a74:	53                   	push   %ebx
80107a75:	8b 5d 08             	mov    0x8(%ebp),%ebx
  page->pgdir = pgdir;
80107a78:	8b 75 0c             	mov    0xc(%ebp),%esi
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);
80107a7b:	83 ec 04             	sub    $0x4,%esp
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107a7e:	8b 8b 08 04 00 00    	mov    0x408(%ebx),%ecx
  page->isused = 1;
80107a84:	6b d1 1c             	imul   $0x1c,%ecx,%edx
80107a87:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  page->pgdir = pgdir;
80107a8a:	89 b0 48 02 00 00    	mov    %esi,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107a90:	8b 75 10             	mov    0x10(%ebp),%esi
  page->isused = 1;
80107a93:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a9a:	00 00 00 
  page->swap_offset = -1;
80107a9d:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107aa4:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107aa7:	89 b0 50 02 00 00    	mov    %esi,0x250(%eax)
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107aad:	8d 84 13 48 02 00 00 	lea    0x248(%ebx,%edx,1),%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);
80107ab4:	51                   	push   %ecx
80107ab5:	50                   	push   %eax
80107ab6:	53                   	push   %ebx
80107ab7:	e8 24 ff ff ff       	call   801079e0 <update_selectionfiled_allocuvm>
  curproc->num_ram++;
80107abc:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
}
80107ac3:	83 c4 10             	add    $0x10,%esp
80107ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107ac9:	5b                   	pop    %ebx
80107aca:	5e                   	pop    %esi
80107acb:	5d                   	pop    %ebp
80107acc:	c3                   	ret    
80107acd:	8d 76 00             	lea    0x0(%esi),%esi

80107ad0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107ad0:	55                   	push   %ebp
80107ad1:	89 e5                	mov    %esp,%ebp
80107ad3:	57                   	push   %edi
80107ad4:	56                   	push   %esi
80107ad5:	53                   	push   %ebx
80107ad6:	83 ec 5c             	sub    $0x5c,%esp
80107ad9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;

  struct proc* curproc = myproc();
80107adc:	e8 1f c8 ff ff       	call   80104300 <myproc>
80107ae1:	89 45 a4             	mov    %eax,-0x5c(%ebp)


  if(newsz >= oldsz)
80107ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ae7:	39 45 10             	cmp    %eax,0x10(%ebp)
80107aea:	0f 83 a3 00 00 00    	jae    80107b93 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107af0:	8b 45 10             	mov    0x10(%ebp),%eax
80107af3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107af9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107aff:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b02:	77 6a                	ja     80107b6e <deallocuvm+0x9e>
80107b04:	e9 87 00 00 00       	jmp    80107b90 <deallocuvm+0xc0>
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107b10:	8b 00                	mov    (%eax),%eax
80107b12:	a8 01                	test   $0x1,%al
80107b14:	74 4d                	je     80107b63 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107b16:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b1b:	0f 84 b3 01 00 00    	je     80107cd4 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107b21:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107b27:	83 ec 0c             	sub    $0xc,%esp
80107b2a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b2d:	53                   	push   %ebx
80107b2e:	e8 9d b3 ff ff       	call   80102ed0 <getRefs>
80107b33:	83 c4 10             	add    $0x10,%esp
80107b36:	83 f8 01             	cmp    $0x1,%eax
80107b39:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107b3c:	0f 84 7e 01 00 00    	je     80107cc0 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107b42:	83 ec 0c             	sub    $0xc,%esp
80107b45:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107b48:	53                   	push   %ebx
80107b49:	e8 a2 b2 ff ff       	call   80102df0 <refDec>
80107b4e:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107b51:	83 c4 10             	add    $0x10,%esp
      }

  
      if(curproc->pid >2)
80107b54:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107b57:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107b5b:	7f 43                	jg     80107ba0 <deallocuvm+0xd0>
            curproc->num_swap --;
          }
        }

      }
      *pte = 0;
80107b5d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107b63:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b69:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b6c:	76 22                	jbe    80107b90 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b6e:	31 c9                	xor    %ecx,%ecx
80107b70:	89 f2                	mov    %esi,%edx
80107b72:	89 f8                	mov    %edi,%eax
80107b74:	e8 17 f9 ff ff       	call   80107490 <walkpgdir>
    if(!pte)
80107b79:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107b7b:	89 c2                	mov    %eax,%edx
    if(!pte)
80107b7d:	75 91                	jne    80107b10 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107b7f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107b85:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107b8b:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107b8e:	77 de                	ja     80107b6e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107b90:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b96:	5b                   	pop    %ebx
80107b97:	5e                   	pop    %esi
80107b98:	5f                   	pop    %edi
80107b99:	5d                   	pop    %ebp
80107b9a:	c3                   	ret    
80107b9b:	90                   	nop
80107b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ba0:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107ba6:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107ba9:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107baf:	89 fa                	mov    %edi,%edx
80107bb1:	89 cf                	mov    %ecx,%edi
80107bb3:	eb 17                	jmp    80107bcc <deallocuvm+0xfc>
80107bb5:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107bb8:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107bbb:	0f 84 b7 00 00 00    	je     80107c78 <deallocuvm+0x1a8>
80107bc1:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107bc4:	39 fb                	cmp    %edi,%ebx
80107bc6:	0f 84 e4 00 00 00    	je     80107cb0 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107bcc:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107bd2:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107bd5:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107bdb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107bde:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107be4:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107be7:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107bed:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107bf0:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107bf3:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107bf9:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107bfc:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107c02:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107c05:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107c0b:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107c0e:	8b 03                	mov    (%ebx),%eax
80107c10:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107c13:	8b 43 04             	mov    0x4(%ebx),%eax
80107c16:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107c19:	8b 43 08             	mov    0x8(%ebx),%eax
80107c1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107c1f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107c22:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107c25:	8b 43 10             	mov    0x10(%ebx),%eax
80107c28:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107c2b:	8b 43 14             	mov    0x14(%ebx),%eax
80107c2e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107c31:	8b 43 18             	mov    0x18(%ebx),%eax
80107c34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107c37:	0f 85 7b ff ff ff    	jne    80107bb8 <deallocuvm+0xe8>
80107c3d:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107c40:	0f 85 72 ff ff ff    	jne    80107bb8 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107c46:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107c49:	83 ec 04             	sub    $0x4,%esp
80107c4c:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107c4f:	6a 1c                	push   $0x1c
80107c51:	6a 00                	push   $0x0
80107c53:	50                   	push   %eax
80107c54:	e8 47 d6 ff ff       	call   801052a0 <memset>
            curproc->num_ram -- ;
80107c59:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c5c:	83 c4 10             	add    $0x10,%esp
80107c5f:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107c62:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107c69:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107c6c:	0f 85 4f ff ff ff    	jne    80107bc1 <deallocuvm+0xf1>
80107c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107c78:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107c7b:	0f 85 40 ff ff ff    	jne    80107bc1 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107c81:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107c84:	83 ec 04             	sub    $0x4,%esp
80107c87:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107c8a:	6a 1c                	push   $0x1c
80107c8c:	6a 00                	push   $0x0
80107c8e:	83 c3 1c             	add    $0x1c,%ebx
80107c91:	50                   	push   %eax
80107c92:	e8 09 d6 ff ff       	call   801052a0 <memset>
            curproc->num_swap --;
80107c97:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c9a:	83 c4 10             	add    $0x10,%esp
80107c9d:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107ca0:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107ca7:	39 fb                	cmp    %edi,%ebx
80107ca9:	0f 85 1d ff ff ff    	jne    80107bcc <deallocuvm+0xfc>
80107caf:	90                   	nop
80107cb0:	89 d7                	mov    %edx,%edi
80107cb2:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107cb5:	e9 a3 fe ff ff       	jmp    80107b5d <deallocuvm+0x8d>
80107cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107cc0:	83 ec 0c             	sub    $0xc,%esp
80107cc3:	53                   	push   %ebx
80107cc4:	e8 97 ad ff ff       	call   80102a60 <kfree>
80107cc9:	83 c4 10             	add    $0x10,%esp
80107ccc:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107ccf:	e9 80 fe ff ff       	jmp    80107b54 <deallocuvm+0x84>
        panic("kfree");
80107cd4:	83 ec 0c             	sub    $0xc,%esp
80107cd7:	68 72 93 10 80       	push   $0x80109372
80107cdc:	e8 af 86 ff ff       	call   80100390 <panic>
80107ce1:	eb 0d                	jmp    80107cf0 <freevm>
80107ce3:	90                   	nop
80107ce4:	90                   	nop
80107ce5:	90                   	nop
80107ce6:	90                   	nop
80107ce7:	90                   	nop
80107ce8:	90                   	nop
80107ce9:	90                   	nop
80107cea:	90                   	nop
80107ceb:	90                   	nop
80107cec:	90                   	nop
80107ced:	90                   	nop
80107cee:	90                   	nop
80107cef:	90                   	nop

80107cf0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107cf0:	55                   	push   %ebp
80107cf1:	89 e5                	mov    %esp,%ebp
80107cf3:	57                   	push   %edi
80107cf4:	56                   	push   %esi
80107cf5:	53                   	push   %ebx
80107cf6:	83 ec 1c             	sub    $0x1c,%esp
80107cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  uint i;

  if(pgdir == 0)
80107cfc:	85 c0                	test   %eax,%eax
{
80107cfe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(pgdir == 0)
80107d01:	0f 84 87 00 00 00    	je     80107d8e <freevm+0x9e>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107d07:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107d0a:	83 ec 04             	sub    $0x4,%esp
80107d0d:	6a 00                	push   $0x0
80107d0f:	68 00 00 00 80       	push   $0x80000000
80107d14:	57                   	push   %edi
80107d15:	89 fb                	mov    %edi,%ebx
80107d17:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80107d1d:	e8 ae fd ff ff       	call   80107ad0 <deallocuvm>
80107d22:	83 c4 10             	add    $0x10,%esp
80107d25:	eb 10                	jmp    80107d37 <freevm+0x47>
80107d27:	89 f6                	mov    %esi,%esi
80107d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107d30:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107d33:	39 f3                	cmp    %esi,%ebx
80107d35:	74 35                	je     80107d6c <freevm+0x7c>
    if(pgdir[i] & PTE_P){
80107d37:	8b 03                	mov    (%ebx),%eax
80107d39:	a8 01                	test   $0x1,%al
80107d3b:	74 f3                	je     80107d30 <freevm+0x40>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d3d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      if(getRefs(v) == 1)
80107d42:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107d45:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
      if(getRefs(v) == 1)
80107d4b:	57                   	push   %edi
80107d4c:	e8 7f b1 ff ff       	call   80102ed0 <getRefs>
80107d51:	83 c4 10             	add    $0x10,%esp
80107d54:	83 f8 01             	cmp    $0x1,%eax
80107d57:	74 27                	je     80107d80 <freevm+0x90>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107d59:	83 ec 0c             	sub    $0xc,%esp
80107d5c:	83 c3 04             	add    $0x4,%ebx
80107d5f:	57                   	push   %edi
80107d60:	e8 8b b0 ff ff       	call   80102df0 <refDec>
80107d65:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107d68:	39 f3                	cmp    %esi,%ebx
80107d6a:	75 cb                	jne    80107d37 <freevm+0x47>
      }
    }
  }
  kfree((char*)pgdir);
80107d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107d6f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80107d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d75:	5b                   	pop    %ebx
80107d76:	5e                   	pop    %esi
80107d77:	5f                   	pop    %edi
80107d78:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107d79:	e9 e2 ac ff ff       	jmp    80102a60 <kfree>
80107d7e:	66 90                	xchg   %ax,%ax
        kfree(v);
80107d80:	83 ec 0c             	sub    $0xc,%esp
80107d83:	57                   	push   %edi
80107d84:	e8 d7 ac ff ff       	call   80102a60 <kfree>
80107d89:	83 c4 10             	add    $0x10,%esp
80107d8c:	eb a2                	jmp    80107d30 <freevm+0x40>
    panic("freevm: no pgdir");
80107d8e:	83 ec 0c             	sub    $0xc,%esp
80107d91:	68 e4 9b 10 80       	push   $0x80109be4
80107d96:	e8 f5 85 ff ff       	call   80100390 <panic>
80107d9b:	90                   	nop
80107d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107da0 <setupkvm>:
{
80107da0:	55                   	push   %ebp
80107da1:	89 e5                	mov    %esp,%ebp
80107da3:	56                   	push   %esi
80107da4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107da5:	e8 96 af ff ff       	call   80102d40 <kalloc>
80107daa:	85 c0                	test   %eax,%eax
80107dac:	89 c6                	mov    %eax,%esi
80107dae:	74 42                	je     80107df2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107db0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107db3:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80107db8:	68 00 10 00 00       	push   $0x1000
80107dbd:	6a 00                	push   $0x0
80107dbf:	50                   	push   %eax
80107dc0:	e8 db d4 ff ff       	call   801052a0 <memset>
80107dc5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107dc8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107dcb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107dce:	83 ec 08             	sub    $0x8,%esp
80107dd1:	8b 13                	mov    (%ebx),%edx
80107dd3:	ff 73 0c             	pushl  0xc(%ebx)
80107dd6:	50                   	push   %eax
80107dd7:	29 c1                	sub    %eax,%ecx
80107dd9:	89 f0                	mov    %esi,%eax
80107ddb:	e8 30 f7 ff ff       	call   80107510 <mappages>
80107de0:	83 c4 10             	add    $0x10,%esp
80107de3:	85 c0                	test   %eax,%eax
80107de5:	78 19                	js     80107e00 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107de7:	83 c3 10             	add    $0x10,%ebx
80107dea:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80107df0:	75 d6                	jne    80107dc8 <setupkvm+0x28>
}
80107df2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107df5:	89 f0                	mov    %esi,%eax
80107df7:	5b                   	pop    %ebx
80107df8:	5e                   	pop    %esi
80107df9:	5d                   	pop    %ebp
80107dfa:	c3                   	ret    
80107dfb:	90                   	nop
80107dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80107e00:	83 ec 0c             	sub    $0xc,%esp
80107e03:	68 f5 9b 10 80       	push   $0x80109bf5
80107e08:	e8 53 88 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
80107e0d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80107e10:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107e12:	e8 d9 fe ff ff       	call   80107cf0 <freevm>
      return 0;
80107e17:	83 c4 10             	add    $0x10,%esp
}
80107e1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107e1d:	89 f0                	mov    %esi,%eax
80107e1f:	5b                   	pop    %ebx
80107e20:	5e                   	pop    %esi
80107e21:	5d                   	pop    %ebp
80107e22:	c3                   	ret    
80107e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107e30 <kvmalloc>:
{
80107e30:	55                   	push   %ebp
80107e31:	89 e5                	mov    %esp,%ebp
80107e33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107e36:	e8 65 ff ff ff       	call   80107da0 <setupkvm>
80107e3b:	a3 a4 75 19 80       	mov    %eax,0x801975a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107e40:	05 00 00 00 80       	add    $0x80000000,%eax
80107e45:	0f 22 d8             	mov    %eax,%cr3
}
80107e48:	c9                   	leave  
80107e49:	c3                   	ret    
80107e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107e50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107e50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107e51:	31 c9                	xor    %ecx,%ecx
{
80107e53:	89 e5                	mov    %esp,%ebp
80107e55:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107e58:	8b 55 0c             	mov    0xc(%ebp),%edx
80107e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107e5e:	e8 2d f6 ff ff       	call   80107490 <walkpgdir>
  if(pte == 0)
80107e63:	85 c0                	test   %eax,%eax
80107e65:	74 05                	je     80107e6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107e67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107e6a:	c9                   	leave  
80107e6b:	c3                   	ret    
    panic("clearpteu");
80107e6c:	83 ec 0c             	sub    $0xc,%esp
80107e6f:	68 11 9c 10 80       	push   $0x80109c11
80107e74:	e8 17 85 ff ff       	call   80100390 <panic>
80107e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107e80 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80107e80:	55                   	push   %ebp
80107e81:	89 e5                	mov    %esp,%ebp
80107e83:	57                   	push   %edi
80107e84:	56                   	push   %esi
80107e85:	53                   	push   %ebx
80107e86:	83 ec 0c             	sub    $0xc,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80107e89:	e8 12 ff ff ff       	call   80107da0 <setupkvm>
80107e8e:	85 c0                	test   %eax,%eax
80107e90:	89 c7                	mov    %eax,%edi
80107e92:	0f 84 ce 00 00 00    	je     80107f66 <cowuvm+0xe6>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80107e98:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e9b:	85 c0                	test   %eax,%eax
80107e9d:	0f 84 b8 00 00 00    	je     80107f5b <cowuvm+0xdb>
80107ea3:	31 db                	xor    %ebx,%ebx
80107ea5:	eb 62                	jmp    80107f09 <cowuvm+0x89>
80107ea7:	89 f6                	mov    %esi,%esi
80107ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      continue;
    }


    *pte |= PTE_COW;
    *pte &= ~PTE_W; 
80107eb0:	89 d1                	mov    %edx,%ecx
80107eb2:	89 d6                	mov    %edx,%esi

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
80107eb4:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W; 
80107eba:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107ebd:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80107ec0:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W; 
80107ec3:	80 cd 04             	or     $0x4,%ch
80107ec6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80107ecc:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80107ece:	52                   	push   %edx
80107ecf:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ed4:	56                   	push   %esi
80107ed5:	89 da                	mov    %ebx,%edx
80107ed7:	89 f8                	mov    %edi,%eax
80107ed9:	e8 32 f6 ff ff       	call   80107510 <mappages>
80107ede:	83 c4 10             	add    $0x10,%esp
80107ee1:	85 c0                	test   %eax,%eax
80107ee3:	0f 88 87 00 00 00    	js     80107f70 <cowuvm+0xf0>
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80107ee9:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80107eec:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
80107ef2:	56                   	push   %esi
80107ef3:	e8 68 af ff ff       	call   80102e60 <refInc>
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80107ef8:	0f 01 3b             	invlpg (%ebx)
80107efb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
80107efe:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f04:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
80107f07:	76 52                	jbe    80107f5b <cowuvm+0xdb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107f09:	8b 45 08             	mov    0x8(%ebp),%eax
80107f0c:	31 c9                	xor    %ecx,%ecx
80107f0e:	89 da                	mov    %ebx,%edx
80107f10:	e8 7b f5 ff ff       	call   80107490 <walkpgdir>
80107f15:	85 c0                	test   %eax,%eax
80107f17:	0f 84 8f 00 00 00    	je     80107fac <cowuvm+0x12c>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80107f1d:	8b 10                	mov    (%eax),%edx
80107f1f:	f7 c2 01 02 00 00    	test   $0x201,%edx
80107f25:	74 78                	je     80107f9f <cowuvm+0x11f>
    if(*pte & PTE_PG)  //there is pgfault, then not mark this entry as cow
80107f27:	f6 c6 02             	test   $0x2,%dh
80107f2a:	74 84                	je     80107eb0 <cowuvm+0x30>
      cprintf("cowuvm,  not marked as cow because pgfault \n");
80107f2c:	83 ec 0c             	sub    $0xc,%esp
80107f2f:	68 b0 9d 10 80       	push   $0x80109db0
80107f34:	e8 27 87 ff ff       	call   80100660 <cprintf>
      pte = walkpgdir(d, (void*) i, 1);
80107f39:	89 da                	mov    %ebx,%edx
80107f3b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107f40:	89 f8                	mov    %edi,%eax
80107f42:	e8 49 f5 ff ff       	call   80107490 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE)
80107f47:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      continue;
80107f4d:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
80107f50:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
80107f53:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE)
80107f59:	77 ae                	ja     80107f09 <cowuvm+0x89>

    // lcr3(V2P(pgdir));
    invlpg((void*)i); // flush TLB
  }
  lcr3(V2P(pgdir));
80107f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80107f5e:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f63:	0f 22 d8             	mov    %eax,%cr3
bad:
  cprintf("bad: cowuvm\n");
  freevm(d);
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
}
80107f66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f69:	89 f8                	mov    %edi,%eax
80107f6b:	5b                   	pop    %ebx
80107f6c:	5e                   	pop    %esi
80107f6d:	5f                   	pop    %edi
80107f6e:	5d                   	pop    %ebp
80107f6f:	c3                   	ret    
  cprintf("bad: cowuvm\n");
80107f70:	83 ec 0c             	sub    $0xc,%esp
80107f73:	68 2a 9c 10 80       	push   $0x80109c2a
80107f78:	e8 e3 86 ff ff       	call   80100660 <cprintf>
  freevm(d);
80107f7d:	89 3c 24             	mov    %edi,(%esp)
80107f80:	e8 6b fd ff ff       	call   80107cf0 <freevm>
  lcr3(V2P(pgdir));  // flush tlb
80107f85:	8b 45 08             	mov    0x8(%ebp),%eax
80107f88:	05 00 00 00 80       	add    $0x80000000,%eax
80107f8d:	0f 22 d8             	mov    %eax,%cr3
  return 0;
80107f90:	83 c4 10             	add    $0x10,%esp
}
80107f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107f96:	31 ff                	xor    %edi,%edi
}
80107f98:	89 f8                	mov    %edi,%eax
80107f9a:	5b                   	pop    %ebx
80107f9b:	5e                   	pop    %esi
80107f9c:	5f                   	pop    %edi
80107f9d:	5d                   	pop    %ebp
80107f9e:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
80107f9f:	83 ec 0c             	sub    $0xc,%esp
80107fa2:	68 80 9d 10 80       	push   $0x80109d80
80107fa7:	e8 e4 83 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80107fac:	83 ec 0c             	sub    $0xc,%esp
80107faf:	68 1b 9c 10 80       	push   $0x80109c1b
80107fb4:	e8 d7 83 ff ff       	call   80100390 <panic>
80107fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107fc0 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80107fc0:	55                   	push   %ebp
80107fc1:	89 e5                	mov    %esp,%ebp
80107fc3:	53                   	push   %ebx
80107fc4:	83 ec 04             	sub    $0x4,%esp
80107fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
80107fca:	e8 31 c3 ff ff       	call   80104300 <myproc>
80107fcf:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80107fd5:	31 c0                	xor    %eax,%eax
80107fd7:	eb 12                	jmp    80107feb <getSwappedPageIndex+0x2b>
80107fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107fe0:	83 c0 01             	add    $0x1,%eax
80107fe3:	83 c2 1c             	add    $0x1c,%edx
80107fe6:	83 f8 10             	cmp    $0x10,%eax
80107fe9:	74 0d                	je     80107ff8 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
80107feb:	39 1a                	cmp    %ebx,(%edx)
80107fed:	75 f1                	jne    80107fe0 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
80107fef:	83 c4 04             	add    $0x4,%esp
80107ff2:	5b                   	pop    %ebx
80107ff3:	5d                   	pop    %ebp
80107ff4:	c3                   	ret    
80107ff5:	8d 76 00             	lea    0x0(%esi),%esi
80107ff8:	83 c4 04             	add    $0x4,%esp
  return -1;
80107ffb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108000:	5b                   	pop    %ebx
80108001:	5d                   	pop    %ebp
80108002:	c3                   	ret    
80108003:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108010 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc * curproc, pte_t* pte, char* va)
{
80108010:	55                   	push   %ebp
80108011:	89 e5                	mov    %esp,%ebp
80108013:	57                   	push   %edi
80108014:	56                   	push   %esi
80108015:	53                   	push   %ebx
80108016:	83 ec 1c             	sub    $0x1c,%esp
80108019:	8b 45 08             	mov    0x8(%ebp),%eax
8010801c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010801f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
80108022:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80108025:	f6 42 34 02          	testb  $0x2,0x34(%edx)
80108029:	74 07                	je     80108032 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
8010802b:	8b 13                	mov    (%ebx),%edx
8010802d:	f6 c6 04             	test   $0x4,%dh
80108030:	75 16                	jne    80108048 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80108032:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
80108039:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010803c:	5b                   	pop    %ebx
8010803d:	5e                   	pop    %esi
8010803e:	5f                   	pop    %edi
8010803f:	5d                   	pop    %ebp
80108040:	c3                   	ret    
80108041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
80108048:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
8010804a:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
8010804d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108050:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80108056:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
8010805c:	57                   	push   %edi
8010805d:	e8 6e ae ff ff       	call   80102ed0 <getRefs>
      if (ref_count > 1) // more than one reference
80108062:	83 c4 10             	add    $0x10,%esp
80108065:	83 f8 01             	cmp    $0x1,%eax
80108068:	7f 16                	jg     80108080 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
8010806a:	8b 03                	mov    (%ebx),%eax
8010806c:	80 e4 fb             	and    $0xfb,%ah
8010806f:	83 c8 02             	or     $0x2,%eax
80108072:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80108074:	0f 01 3e             	invlpg (%esi)
80108077:	eb c0                	jmp    80108039 <handle_cow_pagefault+0x29>
80108079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80108080:	e8 bb ac ff ff       	call   80102d40 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108085:	83 ec 04             	sub    $0x4,%esp
80108088:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010808b:	68 00 10 00 00       	push   $0x1000
80108090:	57                   	push   %edi
80108091:	50                   	push   %eax
80108092:	e8 b9 d2 ff ff       	call   80105350 <memmove>
      flags = PTE_FLAGS(*pte);
80108097:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
8010809a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
8010809d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
801080a3:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801080a9:	83 ca 03             	or     $0x3,%edx
801080ac:	09 ca                	or     %ecx,%edx
801080ae:	89 13                	mov    %edx,(%ebx)
801080b0:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
801080b3:	89 7d 08             	mov    %edi,0x8(%ebp)
801080b6:	83 c4 10             	add    $0x10,%esp
}
801080b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080bc:	5b                   	pop    %ebx
801080bd:	5e                   	pop    %esi
801080be:	5f                   	pop    %edi
801080bf:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
801080c0:	e9 2b ad ff ff       	jmp    80102df0 <refDec>
801080c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801080c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080d0 <update_selectionfiled_pagefault>:
801080d0:	55                   	push   %ebp
801080d1:	89 e5                	mov    %esp,%ebp
801080d3:	5d                   	pop    %ebp
801080d4:	e9 07 f9 ff ff       	jmp    801079e0 <update_selectionfiled_allocuvm>
801080d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801080e0 <copyuvm>:

}

pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801080e0:	55                   	push   %ebp
801080e1:	89 e5                	mov    %esp,%ebp
801080e3:	57                   	push   %edi
801080e4:	56                   	push   %esi
801080e5:	53                   	push   %ebx
801080e6:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  #if SELECTION != NONE
  if((d = setupkvm()) == 0)
801080e9:	e8 b2 fc ff ff       	call   80107da0 <setupkvm>
801080ee:	85 c0                	test   %eax,%eax
801080f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801080f3:	0f 84 bf 00 00 00    	je     801081b8 <copyuvm+0xd8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801080f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801080fc:	85 db                	test   %ebx,%ebx
801080fe:	0f 84 b4 00 00 00    	je     801081b8 <copyuvm+0xd8>
80108104:	31 f6                	xor    %esi,%esi
80108106:	eb 69                	jmp    80108171 <copyuvm+0x91>
80108108:	90                   	nop
80108109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pte = walkpgdir(d, (void*) i, 1);
      *pte = PTE_U | PTE_W | PTE_PG;
      continue;
    }

    pa = PTE_ADDR(*pte);
80108110:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80108112:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80108118:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    // {
    //   if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
    //     panic("copyuvm: mappages failed");
    //   continue;
    // }
    if((mem = kalloc()) == 0)
8010811e:	e8 1d ac ff ff       	call   80102d40 <kalloc>
80108123:	85 c0                	test   %eax,%eax
80108125:	0f 84 ad 00 00 00    	je     801081d8 <copyuvm+0xf8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010812b:	83 ec 04             	sub    $0x4,%esp
8010812e:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108137:	68 00 10 00 00       	push   $0x1000
8010813c:	57                   	push   %edi
8010813d:	50                   	push   %eax
8010813e:	e8 0d d2 ff ff       	call   80105350 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108143:	5a                   	pop    %edx
80108144:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108147:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010814a:	59                   	pop    %ecx
8010814b:	53                   	push   %ebx
8010814c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108151:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108157:	52                   	push   %edx
80108158:	89 f2                	mov    %esi,%edx
8010815a:	e8 b1 f3 ff ff       	call   80107510 <mappages>
8010815f:	83 c4 10             	add    $0x10,%esp
80108162:	85 c0                	test   %eax,%eax
80108164:	78 62                	js     801081c8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108166:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010816c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010816f:	76 47                	jbe    801081b8 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108171:	8b 45 08             	mov    0x8(%ebp),%eax
80108174:	31 c9                	xor    %ecx,%ecx
80108176:	89 f2                	mov    %esi,%edx
80108178:	e8 13 f3 ff ff       	call   80107490 <walkpgdir>
8010817d:	85 c0                	test   %eax,%eax
8010817f:	0f 84 8b 00 00 00    	je     80108210 <copyuvm+0x130>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108185:	8b 18                	mov    (%eax),%ebx
80108187:	f7 c3 01 02 00 00    	test   $0x201,%ebx
8010818d:	74 74                	je     80108203 <copyuvm+0x123>
    if (*pte & PTE_PG) {
8010818f:	f6 c7 02             	test   $0x2,%bh
80108192:	0f 84 78 ff ff ff    	je     80108110 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108198:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010819b:	89 f2                	mov    %esi,%edx
8010819d:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801081a2:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801081a8:	e8 e3 f2 ff ff       	call   80107490 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
801081ad:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
801081b0:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
801081b6:	77 b9                	ja     80108171 <copyuvm+0x91>

bad:
  cprintf("bad: copyuvm\n");
  freevm(d);
  return 0;
}
801081b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081be:	5b                   	pop    %ebx
801081bf:	5e                   	pop    %esi
801081c0:	5f                   	pop    %edi
801081c1:	5d                   	pop    %ebp
801081c2:	c3                   	ret    
801081c3:	90                   	nop
801081c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("copyuvm: mappages failed\n");
801081c8:	83 ec 0c             	sub    $0xc,%esp
801081cb:	68 51 9c 10 80       	push   $0x80109c51
801081d0:	e8 8b 84 ff ff       	call   80100660 <cprintf>
      goto bad;
801081d5:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801081d8:	83 ec 0c             	sub    $0xc,%esp
801081db:	68 6b 9c 10 80       	push   $0x80109c6b
801081e0:	e8 7b 84 ff ff       	call   80100660 <cprintf>
  freevm(d);
801081e5:	58                   	pop    %eax
801081e6:	ff 75 e0             	pushl  -0x20(%ebp)
801081e9:	e8 02 fb ff ff       	call   80107cf0 <freevm>
  return 0;
801081ee:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801081f5:	83 c4 10             	add    $0x10,%esp
}
801081f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801081fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081fe:	5b                   	pop    %ebx
801081ff:	5e                   	pop    %esi
80108200:	5f                   	pop    %edi
80108201:	5d                   	pop    %ebp
80108202:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
80108203:	83 ec 0c             	sub    $0xc,%esp
80108206:	68 e0 9d 10 80       	push   $0x80109de0
8010820b:	e8 80 81 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108210:	83 ec 0c             	sub    $0xc,%esp
80108213:	68 37 9c 10 80       	push   $0x80109c37
80108218:	e8 73 81 ff ff       	call   80100390 <panic>
8010821d:	8d 76 00             	lea    0x0(%esi),%esi

80108220 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108220:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108221:	31 c9                	xor    %ecx,%ecx
{
80108223:	89 e5                	mov    %esp,%ebp
80108225:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108228:	8b 55 0c             	mov    0xc(%ebp),%edx
8010822b:	8b 45 08             	mov    0x8(%ebp),%eax
8010822e:	e8 5d f2 ff ff       	call   80107490 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108233:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80108235:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108236:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108238:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010823d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108240:	05 00 00 00 80       	add    $0x80000000,%eax
80108245:	83 fa 05             	cmp    $0x5,%edx
80108248:	ba 00 00 00 00       	mov    $0x0,%edx
8010824d:	0f 45 c2             	cmovne %edx,%eax
}
80108250:	c3                   	ret    
80108251:	eb 0d                	jmp    80108260 <copyout>
80108253:	90                   	nop
80108254:	90                   	nop
80108255:	90                   	nop
80108256:	90                   	nop
80108257:	90                   	nop
80108258:	90                   	nop
80108259:	90                   	nop
8010825a:	90                   	nop
8010825b:	90                   	nop
8010825c:	90                   	nop
8010825d:	90                   	nop
8010825e:	90                   	nop
8010825f:	90                   	nop

80108260 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108260:	55                   	push   %ebp
80108261:	89 e5                	mov    %esp,%ebp
80108263:	57                   	push   %edi
80108264:	56                   	push   %esi
80108265:	53                   	push   %ebx
80108266:	83 ec 1c             	sub    $0x1c,%esp
80108269:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010826c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010826f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108272:	85 db                	test   %ebx,%ebx
80108274:	75 40                	jne    801082b6 <copyout+0x56>
80108276:	eb 70                	jmp    801082e8 <copyout+0x88>
80108278:	90                   	nop
80108279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80108280:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108283:	89 f1                	mov    %esi,%ecx
80108285:	29 d1                	sub    %edx,%ecx
80108287:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010828d:	39 d9                	cmp    %ebx,%ecx
8010828f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80108292:	29 f2                	sub    %esi,%edx
80108294:	83 ec 04             	sub    $0x4,%esp
80108297:	01 d0                	add    %edx,%eax
80108299:	51                   	push   %ecx
8010829a:	57                   	push   %edi
8010829b:	50                   	push   %eax
8010829c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010829f:	e8 ac d0 ff ff       	call   80105350 <memmove>
    len -= n;
    buf += n;
801082a4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801082a7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801082aa:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801082b0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801082b2:	29 cb                	sub    %ecx,%ebx
801082b4:	74 32                	je     801082e8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801082b6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801082b8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801082bb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801082be:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801082c4:	56                   	push   %esi
801082c5:	ff 75 08             	pushl  0x8(%ebp)
801082c8:	e8 53 ff ff ff       	call   80108220 <uva2ka>
    if(pa0 == 0)
801082cd:	83 c4 10             	add    $0x10,%esp
801082d0:	85 c0                	test   %eax,%eax
801082d2:	75 ac                	jne    80108280 <copyout+0x20>
  }
  return 0;
}
801082d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801082d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801082dc:	5b                   	pop    %ebx
801082dd:	5e                   	pop    %esi
801082de:	5f                   	pop    %edi
801082df:	5d                   	pop    %ebp
801082e0:	c3                   	ret    
801082e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801082eb:	31 c0                	xor    %eax,%eax
}
801082ed:	5b                   	pop    %ebx
801082ee:	5e                   	pop    %esi
801082ef:	5f                   	pop    %edi
801082f0:	5d                   	pop    %ebp
801082f1:	c3                   	ret    
801082f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801082f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108300 <getNextFreeRamIndex>:

int
getNextFreeRamIndex()
{ 
80108300:	55                   	push   %ebp
80108301:	89 e5                	mov    %esp,%ebp
80108303:	83 ec 08             	sub    $0x8,%esp
  int i;
  struct proc * currproc = myproc();
80108306:	e8 f5 bf ff ff       	call   80104300 <myproc>
8010830b:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108311:	31 c0                	xor    %eax,%eax
80108313:	eb 0e                	jmp    80108323 <getNextFreeRamIndex+0x23>
80108315:	8d 76 00             	lea    0x0(%esi),%esi
80108318:	83 c0 01             	add    $0x1,%eax
8010831b:	83 c2 1c             	add    $0x1c,%edx
8010831e:	83 f8 10             	cmp    $0x10,%eax
80108321:	74 0d                	je     80108330 <getNextFreeRamIndex+0x30>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108323:	8b 0a                	mov    (%edx),%ecx
80108325:	85 c9                	test   %ecx,%ecx
80108327:	75 ef                	jne    80108318 <getNextFreeRamIndex+0x18>
      return i;
  }
  return -1;
}
80108329:	c9                   	leave  
8010832a:	c3                   	ret    
8010832b:	90                   	nop
8010832c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108330:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108335:	c9                   	leave  
80108336:	c3                   	ret    
80108337:	89 f6                	mov    %esi,%esi
80108339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108340 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108340:	55                   	push   %ebp
80108341:	89 e5                	mov    %esp,%ebp
80108343:	56                   	push   %esi
80108344:	53                   	push   %ebx
80108345:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108348:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010834e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108354:	eb 1d                	jmp    80108373 <updateLapa+0x33>
80108356:	8d 76 00             	lea    0x0(%esi),%esi
80108359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108360:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108366:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
80108369:	83 20 df             	andl   $0xffffffdf,(%eax)
8010836c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010836f:	39 f3                	cmp    %esi,%ebx
80108371:	74 2b                	je     8010839e <updateLapa+0x5e>
    if(!cur_page->isused)
80108373:	8b 43 04             	mov    0x4(%ebx),%eax
80108376:	85 c0                	test   %eax,%eax
80108378:	74 f2                	je     8010836c <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010837a:	8b 53 08             	mov    0x8(%ebx),%edx
8010837d:	8b 03                	mov    (%ebx),%eax
8010837f:	31 c9                	xor    %ecx,%ecx
80108381:	e8 0a f1 ff ff       	call   80107490 <walkpgdir>
80108386:	85 c0                	test   %eax,%eax
80108388:	74 1b                	je     801083a5 <updateLapa+0x65>
8010838a:	8b 53 18             	mov    0x18(%ebx),%edx
8010838d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
8010838f:	f6 00 20             	testb  $0x20,(%eax)
80108392:	75 cc                	jne    80108360 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
80108394:	89 53 18             	mov    %edx,0x18(%ebx)
80108397:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010839a:	39 f3                	cmp    %esi,%ebx
8010839c:	75 d5                	jne    80108373 <updateLapa+0x33>
    }
  }
}
8010839e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801083a1:	5b                   	pop    %ebx
801083a2:	5e                   	pop    %esi
801083a3:	5d                   	pop    %ebp
801083a4:	c3                   	ret    
      panic("updateLapa: no pte");
801083a5:	83 ec 0c             	sub    $0xc,%esp
801083a8:	68 79 9c 10 80       	push   $0x80109c79
801083ad:	e8 de 7f ff ff       	call   80100390 <panic>
801083b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801083b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801083c0 <updateNfua>:

void updateNfua(struct proc* p)
{
801083c0:	55                   	push   %ebp
801083c1:	89 e5                	mov    %esp,%ebp
801083c3:	56                   	push   %esi
801083c4:	53                   	push   %ebx
801083c5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
801083c8:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
801083ce:	81 c6 08 04 00 00    	add    $0x408,%esi
801083d4:	eb 1d                	jmp    801083f3 <updateNfua+0x33>
801083d6:	8d 76 00             	lea    0x0(%esi),%esi
801083d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
801083e0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
801083e6:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
801083e9:	83 20 df             	andl   $0xffffffdf,(%eax)
801083ec:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801083ef:	39 f3                	cmp    %esi,%ebx
801083f1:	74 2b                	je     8010841e <updateNfua+0x5e>
    if(!cur_page->isused)
801083f3:	8b 43 04             	mov    0x4(%ebx),%eax
801083f6:	85 c0                	test   %eax,%eax
801083f8:	74 f2                	je     801083ec <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
801083fa:	8b 53 08             	mov    0x8(%ebx),%edx
801083fd:	8b 03                	mov    (%ebx),%eax
801083ff:	31 c9                	xor    %ecx,%ecx
80108401:	e8 8a f0 ff ff       	call   80107490 <walkpgdir>
80108406:	85 c0                	test   %eax,%eax
80108408:	74 1b                	je     80108425 <updateNfua+0x65>
8010840a:	8b 53 14             	mov    0x14(%ebx),%edx
8010840d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
8010840f:	f6 00 20             	testb  $0x20,(%eax)
80108412:	75 cc                	jne    801083e0 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108414:	89 53 14             	mov    %edx,0x14(%ebx)
80108417:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010841a:	39 f3                	cmp    %esi,%ebx
8010841c:	75 d5                	jne    801083f3 <updateNfua+0x33>
    }
  }
}
8010841e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108421:	5b                   	pop    %ebx
80108422:	5e                   	pop    %esi
80108423:	5d                   	pop    %ebp
80108424:	c3                   	ret    
      panic("updateNfua: no pte");
80108425:	83 ec 0c             	sub    $0xc,%esp
80108428:	68 8c 9c 10 80       	push   $0x80109c8c
8010842d:	e8 5e 7f ff ff       	call   80100390 <panic>
80108432:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108440 <aq>:
  return 11; // default
  #endif
}

uint aq()
{
80108440:	55                   	push   %ebp
80108441:	89 e5                	mov    %esp,%ebp
80108443:	53                   	push   %ebx
80108444:	83 ec 04             	sub    $0x4,%esp
  struct proc* curproc = myproc();
80108447:	e8 b4 be ff ff       	call   80104300 <myproc>
8010844c:	89 c2                	mov    %eax,%edx
  int res = curproc->queue_tail->page_index;
8010844e:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108454:	8b 9a 1c 04 00 00    	mov    0x41c(%edx),%ebx
  int res = curproc->queue_tail->page_index;
8010845a:	8b 41 08             	mov    0x8(%ecx),%eax
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
8010845d:	85 db                	test   %ebx,%ebx
8010845f:	74 3e                	je     8010849f <aq+0x5f>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108461:	39 d9                	cmp    %ebx,%ecx
80108463:	74 23                	je     80108488 <aq+0x48>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108465:	8b 49 04             	mov    0x4(%ecx),%ecx
80108468:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
    new_tail =  curproc->queue_tail->prev;
8010846e:	8b 8a 20 04 00 00    	mov    0x420(%edx),%ecx
80108474:	8b 49 04             	mov    0x4(%ecx),%ecx
  }

  // kfree((char*)curproc->queue_tail);
  curproc->queue_tail = new_tail;
80108477:	89 8a 20 04 00 00    	mov    %ecx,0x420(%edx)
  
  return  res;


}
8010847d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108480:	c9                   	leave  
80108481:	c3                   	ret    
80108482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    new_tail = 0;
80108488:	31 c9                	xor    %ecx,%ecx
    curproc->queue_head=0;
8010848a:	c7 82 1c 04 00 00 00 	movl   $0x0,0x41c(%edx)
80108491:	00 00 00 
  curproc->queue_tail = new_tail;
80108494:	89 8a 20 04 00 00    	mov    %ecx,0x420(%edx)
}
8010849a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010849d:	c9                   	leave  
8010849e:	c3                   	ret    
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
8010849f:	83 ec 0c             	sub    $0xc,%esp
801084a2:	68 1c 9e 10 80       	push   $0x80109e1c
801084a7:	e8 e4 7e ff ff       	call   80100390 <panic>
801084ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801084b0 <indexToEvict>:
{  
801084b0:	55                   	push   %ebp
801084b1:	89 e5                	mov    %esp,%ebp
}
801084b3:	5d                   	pop    %ebp
    return aq();
801084b4:	eb 8a                	jmp    80108440 <aq>
801084b6:	8d 76 00             	lea    0x0(%esi),%esi
801084b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801084c0 <allocuvm_withswap>:
{
801084c0:	55                   	push   %ebp
801084c1:	89 e5                	mov    %esp,%ebp
801084c3:	57                   	push   %edi
801084c4:	56                   	push   %esi
801084c5:	53                   	push   %ebx
801084c6:	83 ec 1c             	sub    $0x1c,%esp
801084c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801084cc:	8b 45 0c             	mov    0xc(%ebp),%eax
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
801084cf:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
{
801084d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
801084d9:	8b 45 10             	mov    0x10(%ebp),%eax
801084dc:	89 45 d8             	mov    %eax,-0x28(%ebp)
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
801084df:	0f 8f 64 01 00 00    	jg     80108649 <allocuvm_withswap+0x189>
    return aq();
801084e5:	e8 56 ff ff ff       	call   80108440 <aq>
801084ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      int swap_offset = curproc->free_head->off;
801084ed:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
801084f3:	8b 30                	mov    (%eax),%esi
      if(curproc->free_head->next == 0)
801084f5:	8b 40 04             	mov    0x4(%eax),%eax
801084f8:	85 c0                	test   %eax,%eax
801084fa:	0f 84 30 01 00 00    	je     80108630 <allocuvm_withswap+0x170>
        curproc->free_head = curproc->free_head->next;
80108500:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      cprintf("writing a page to swap\n");
80108506:	83 ec 0c             	sub    $0xc,%esp
80108509:	68 b3 9c 10 80       	push   $0x80109cb3
8010850e:	e8 4d 81 ff ff       	call   80100660 <cprintf>
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80108513:	6b 7d e4 1c          	imul   $0x1c,-0x1c(%ebp),%edi
80108517:	68 00 10 00 00       	push   $0x1000
8010851c:	56                   	push   %esi
8010851d:	01 df                	add    %ebx,%edi
8010851f:	ff b7 50 02 00 00    	pushl  0x250(%edi)
80108525:	53                   	push   %ebx
80108526:	e8 c5 a0 ff ff       	call   801025f0 <writeToSwapFile>
8010852b:	83 c4 20             	add    $0x20,%esp
8010852e:	85 c0                	test   %eax,%eax
80108530:	0f 88 2d 01 00 00    	js     80108663 <allocuvm_withswap+0x1a3>
      curproc->swappedPages[curproc->num_swap].isused = 1;
80108536:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
8010853c:	6b c8 1c             	imul   $0x1c,%eax,%ecx
8010853f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108542:	01 d9                	add    %ebx,%ecx
80108544:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
8010854b:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
8010854e:	8b 97 50 02 00 00    	mov    0x250(%edi),%edx
80108554:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
8010855a:	8b 87 48 02 00 00    	mov    0x248(%edi),%eax
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80108560:	89 b1 94 00 00 00    	mov    %esi,0x94(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80108566:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
8010856c:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108572:	0f 22 d9             	mov    %ecx,%cr3
      curproc->num_swap ++;
80108575:	8b 75 e0             	mov    -0x20(%ebp),%esi
80108578:	8d 4e 01             	lea    0x1(%esi),%ecx
8010857b:	89 8b 0c 04 00 00    	mov    %ecx,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80108581:	31 c9                	xor    %ecx,%ecx
80108583:	e8 08 ef ff ff       	call   80107490 <walkpgdir>
80108588:	89 c6                	mov    %eax,%esi
      if(!(*evicted_pte & PTE_P))
8010858a:	8b 00                	mov    (%eax),%eax
8010858c:	a8 01                	test   $0x1,%al
8010858e:	0f 84 c2 00 00 00    	je     80108656 <allocuvm_withswap+0x196>
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80108594:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      if(getRefs(P2V(evicted_pa)) == 1)
80108599:	83 ec 0c             	sub    $0xc,%esp
8010859c:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
801085a2:	57                   	push   %edi
801085a3:	e8 28 a9 ff ff       	call   80102ed0 <getRefs>
801085a8:	83 c4 10             	add    $0x10,%esp
801085ab:	83 f8 01             	cmp    $0x1,%eax
801085ae:	74 68                	je     80108618 <allocuvm_withswap+0x158>
        refDec(P2V(evicted_pa));
801085b0:	83 ec 0c             	sub    $0xc,%esp
801085b3:	57                   	push   %edi
801085b4:	e8 37 a8 ff ff       	call   80102df0 <refDec>
801085b9:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
801085bc:	8b 06                	mov    (%esi),%eax
      newpage->isused = 1;
801085be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      *evicted_pte &= ~PTE_P;
801085c1:	25 fe 0f 00 00       	and    $0xffe,%eax
      newpage->isused = 1;
801085c6:	6b d7 1c             	imul   $0x1c,%edi,%edx
      *evicted_pte &= ~PTE_P;
801085c9:	80 cc 02             	or     $0x2,%ah
801085cc:	89 06                	mov    %eax,(%esi)
      newpage->pgdir = pgdir;
801085ce:	8b 75 dc             	mov    -0x24(%ebp),%esi
      newpage->isused = 1;
801085d1:	8d 04 13             	lea    (%ebx,%edx,1),%eax
      newpage->pgdir = pgdir;
801085d4:	89 b0 48 02 00 00    	mov    %esi,0x248(%eax)
      newpage->virt_addr = rounded_virtaddr;
801085da:	8b 75 d8             	mov    -0x28(%ebp),%esi
      newpage->isused = 1;
801085dd:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
801085e4:	00 00 00 
      newpage->swap_offset = -1;
801085e7:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
801085ee:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
801085f1:	89 b0 50 02 00 00    	mov    %esi,0x250(%eax)
      struct page *newpage = &curproc->ramPages[evicted_ind];
801085f7:	8d 84 13 48 02 00 00 	lea    0x248(%ebx,%edx,1),%eax
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
801085fe:	89 7d 10             	mov    %edi,0x10(%ebp)
80108601:	89 5d 08             	mov    %ebx,0x8(%ebp)
80108604:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80108607:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010860a:	5b                   	pop    %ebx
8010860b:	5e                   	pop    %esi
8010860c:	5f                   	pop    %edi
8010860d:	5d                   	pop    %ebp
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
8010860e:	e9 cd f3 ff ff       	jmp    801079e0 <update_selectionfiled_allocuvm>
80108613:	90                   	nop
80108614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(P2V(evicted_pa));
80108618:	83 ec 0c             	sub    $0xc,%esp
8010861b:	57                   	push   %edi
8010861c:	e8 3f a4 ff ff       	call   80102a60 <kfree>
80108621:	83 c4 10             	add    $0x10,%esp
80108624:	eb 96                	jmp    801085bc <allocuvm_withswap+0xfc>
80108626:	8d 76 00             	lea    0x0(%esi),%esi
80108629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        curproc->free_tail = 0;
80108630:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80108637:	00 00 00 
        curproc->free_head = 0;
8010863a:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80108641:	00 00 00 
80108644:	e9 bd fe ff ff       	jmp    80108506 <allocuvm_withswap+0x46>
        panic("page limit exceeded");
80108649:	83 ec 0c             	sub    $0xc,%esp
8010864c:	68 9f 9c 10 80       	push   $0x80109c9f
80108651:	e8 3a 7d ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80108656:	83 ec 0c             	sub    $0xc,%esp
80108659:	68 5c 9e 10 80       	push   $0x80109e5c
8010865e:	e8 2d 7d ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108663:	83 ec 0c             	sub    $0xc,%esp
80108666:	68 cb 9c 10 80       	push   $0x80109ccb
8010866b:	e8 20 7d ff ff       	call   80100390 <panic>

80108670 <allocuvm_paging>:
{
80108670:	55                   	push   %ebp
80108671:	89 e5                	mov    %esp,%ebp
80108673:	57                   	push   %edi
80108674:	56                   	push   %esi
80108675:	53                   	push   %ebx
80108676:	83 ec 0c             	sub    $0xc,%esp
80108679:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010867c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010867f:	8b 4d 10             	mov    0x10(%ebp),%ecx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80108682:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
80108688:	83 f8 0f             	cmp    $0xf,%eax
8010868b:	7e 13                	jle    801086a0 <allocuvm_paging+0x30>
}
8010868d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108690:	5b                   	pop    %ebx
80108691:	5e                   	pop    %esi
80108692:	5f                   	pop    %edi
80108693:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80108694:	e9 27 fe ff ff       	jmp    801084c0 <allocuvm_withswap>
80108699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  page->isused = 1;
801086a0:	6b f8 1c             	imul   $0x1c,%eax,%edi
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);
801086a3:	83 ec 04             	sub    $0x4,%esp
  page->isused = 1;
801086a6:	8d 14 3b             	lea    (%ebx,%edi,1),%edx
  page->pgdir = pgdir;
801086a9:	89 b2 48 02 00 00    	mov    %esi,0x248(%edx)
  page->isused = 1;
801086af:	c7 82 4c 02 00 00 01 	movl   $0x1,0x24c(%edx)
801086b6:	00 00 00 
  page->swap_offset = -1;
801086b9:	c7 82 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edx)
801086c0:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
801086c3:	89 8a 50 02 00 00    	mov    %ecx,0x250(%edx)
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);
801086c9:	50                   	push   %eax
  struct page *page = &curproc->ramPages[curproc->num_ram];
801086ca:	8d 84 3b 48 02 00 00 	lea    0x248(%ebx,%edi,1),%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);
801086d1:	50                   	push   %eax
801086d2:	53                   	push   %ebx
801086d3:	e8 08 f3 ff ff       	call   801079e0 <update_selectionfiled_allocuvm>
  curproc->num_ram++;
801086d8:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
801086df:	83 c4 10             	add    $0x10,%esp
}
801086e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086e5:	5b                   	pop    %ebx
801086e6:	5e                   	pop    %esi
801086e7:	5f                   	pop    %edi
801086e8:	5d                   	pop    %ebp
801086e9:	c3                   	ret    
801086ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801086f0 <allocuvm>:
{
801086f0:	55                   	push   %ebp
801086f1:	89 e5                	mov    %esp,%ebp
801086f3:	57                   	push   %edi
801086f4:	56                   	push   %esi
801086f5:	53                   	push   %ebx
801086f6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
801086f9:	e8 02 bc ff ff       	call   80104300 <myproc>
  if(newsz >= KERNBASE)
801086fe:	8b 7d 10             	mov    0x10(%ebp),%edi
80108701:	85 ff                	test   %edi,%edi
80108703:	0f 88 bf 00 00 00    	js     801087c8 <allocuvm+0xd8>
  if(newsz < oldsz)
80108709:	3b 7d 0c             	cmp    0xc(%ebp),%edi
8010870c:	0f 82 a6 00 00 00    	jb     801087b8 <allocuvm+0xc8>
80108712:	89 c2                	mov    %eax,%edx
  a = PGROUNDUP(oldsz);
80108714:	8b 45 0c             	mov    0xc(%ebp),%eax
80108717:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010871d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80108723:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108726:	0f 86 8f 00 00 00    	jbe    801087bb <allocuvm+0xcb>
8010872c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010872f:	89 d7                	mov    %edx,%edi
80108731:	eb 10                	jmp    80108743 <allocuvm+0x53>
80108733:	90                   	nop
80108734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108738:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010873e:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80108741:	76 65                	jbe    801087a8 <allocuvm+0xb8>
    mem = kalloc();
80108743:	e8 f8 a5 ff ff       	call   80102d40 <kalloc>
    if(mem == 0){
80108748:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010874a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
8010874c:	0f 84 86 00 00 00    	je     801087d8 <allocuvm+0xe8>
    memset(mem, 0, PGSIZE);
80108752:	83 ec 04             	sub    $0x4,%esp
80108755:	68 00 10 00 00       	push   $0x1000
8010875a:	6a 00                	push   $0x0
8010875c:	50                   	push   %eax
8010875d:	e8 3e cb ff ff       	call   801052a0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80108762:	58                   	pop    %eax
80108763:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80108769:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010876e:	5a                   	pop    %edx
8010876f:	6a 06                	push   $0x6
80108771:	50                   	push   %eax
80108772:	89 da                	mov    %ebx,%edx
80108774:	8b 45 08             	mov    0x8(%ebp),%eax
80108777:	e8 94 ed ff ff       	call   80107510 <mappages>
8010877c:	83 c4 10             	add    $0x10,%esp
8010877f:	85 c0                	test   %eax,%eax
80108781:	0f 88 81 00 00 00    	js     80108808 <allocuvm+0x118>
    if(curproc->pid > 2) 
80108787:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
8010878b:	7e ab                	jle    80108738 <allocuvm+0x48>
        allocuvm_paging(curproc, pgdir, (char *)a);
8010878d:	83 ec 04             	sub    $0x4,%esp
80108790:	53                   	push   %ebx
80108791:	ff 75 08             	pushl  0x8(%ebp)
  for(; a < newsz; a += PGSIZE){
80108794:	81 c3 00 10 00 00    	add    $0x1000,%ebx
        allocuvm_paging(curproc, pgdir, (char *)a);
8010879a:	57                   	push   %edi
8010879b:	e8 d0 fe ff ff       	call   80108670 <allocuvm_paging>
801087a0:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
801087a3:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801087a6:	77 9b                	ja     80108743 <allocuvm+0x53>
801087a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
}
801087ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087ae:	5b                   	pop    %ebx
801087af:	89 f8                	mov    %edi,%eax
801087b1:	5e                   	pop    %esi
801087b2:	5f                   	pop    %edi
801087b3:	5d                   	pop    %ebp
801087b4:	c3                   	ret    
801087b5:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801087b8:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801087bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087be:	89 f8                	mov    %edi,%eax
801087c0:	5b                   	pop    %ebx
801087c1:	5e                   	pop    %esi
801087c2:	5f                   	pop    %edi
801087c3:	5d                   	pop    %ebp
801087c4:	c3                   	ret    
801087c5:	8d 76 00             	lea    0x0(%esi),%esi
801087c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801087cb:	31 ff                	xor    %edi,%edi
}
801087cd:	89 f8                	mov    %edi,%eax
801087cf:	5b                   	pop    %ebx
801087d0:	5e                   	pop    %esi
801087d1:	5f                   	pop    %edi
801087d2:	5d                   	pop    %ebp
801087d3:	c3                   	ret    
801087d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory\n");
801087d8:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801087db:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory\n");
801087dd:	68 e5 9c 10 80       	push   $0x80109ce5
801087e2:	e8 79 7e ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801087e7:	83 c4 0c             	add    $0xc,%esp
801087ea:	ff 75 0c             	pushl  0xc(%ebp)
801087ed:	ff 75 10             	pushl  0x10(%ebp)
801087f0:	ff 75 08             	pushl  0x8(%ebp)
801087f3:	e8 d8 f2 ff ff       	call   80107ad0 <deallocuvm>
      return 0;
801087f8:	83 c4 10             	add    $0x10,%esp
}
801087fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087fe:	89 f8                	mov    %edi,%eax
80108800:	5b                   	pop    %ebx
80108801:	5e                   	pop    %esi
80108802:	5f                   	pop    %edi
80108803:	5d                   	pop    %ebp
80108804:	c3                   	ret    
80108805:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80108808:	83 ec 0c             	sub    $0xc,%esp
      return 0;
8010880b:	31 ff                	xor    %edi,%edi
      cprintf("allocuvm out of memory (2)\n");
8010880d:	68 fd 9c 10 80       	push   $0x80109cfd
80108812:	e8 49 7e ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108817:	83 c4 0c             	add    $0xc,%esp
8010881a:	ff 75 0c             	pushl  0xc(%ebp)
8010881d:	ff 75 10             	pushl  0x10(%ebp)
80108820:	ff 75 08             	pushl  0x8(%ebp)
80108823:	e8 a8 f2 ff ff       	call   80107ad0 <deallocuvm>
      kfree(mem);
80108828:	89 34 24             	mov    %esi,(%esp)
8010882b:	e8 30 a2 ff ff       	call   80102a60 <kfree>
      return 0;
80108830:	83 c4 10             	add    $0x10,%esp
}
80108833:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108836:	89 f8                	mov    %edi,%eax
80108838:	5b                   	pop    %ebx
80108839:	5e                   	pop    %esi
8010883a:	5f                   	pop    %edi
8010883b:	5d                   	pop    %ebp
8010883c:	c3                   	ret    
8010883d:	8d 76 00             	lea    0x0(%esi),%esi

80108840 <handle_pagedout>:
{
80108840:	55                   	push   %ebp
80108841:	89 e5                	mov    %esp,%ebp
80108843:	57                   	push   %edi
80108844:	56                   	push   %esi
80108845:	53                   	push   %ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108846:	31 ff                	xor    %edi,%edi
{
80108848:	83 ec 20             	sub    $0x20,%esp
8010884b:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010884e:	8b 75 10             	mov    0x10(%ebp),%esi
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108851:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108854:	ff 73 10             	pushl  0x10(%ebx)
80108857:	50                   	push   %eax
80108858:	68 84 9e 10 80       	push   $0x80109e84
8010885d:	e8 fe 7d ff ff       	call   80100660 <cprintf>
    new_page = kalloc();
80108862:	e8 d9 a4 ff ff       	call   80102d40 <kalloc>
    *pte &= 0xFFF;
80108867:	8b 16                	mov    (%esi),%edx
    *pte |= V2P(new_page);
80108869:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
8010886e:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
80108874:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
80108877:	09 d0                	or     %edx,%eax
80108879:	89 06                	mov    %eax,(%esi)
  struct proc* curproc = myproc();
8010887b:	e8 80 ba ff ff       	call   80104300 <myproc>
80108880:	83 c4 10             	add    $0x10,%esp
80108883:	05 90 00 00 00       	add    $0x90,%eax
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108888:	8b 55 0c             	mov    0xc(%ebp),%edx
8010888b:	eb 12                	jmp    8010889f <handle_pagedout+0x5f>
8010888d:	8d 76 00             	lea    0x0(%esi),%esi
80108890:	83 c7 01             	add    $0x1,%edi
80108893:	83 c0 1c             	add    $0x1c,%eax
80108896:	83 ff 10             	cmp    $0x10,%edi
80108899:	0f 84 51 02 00 00    	je     80108af0 <handle_pagedout+0x2b0>
    if(curproc->swappedPages[i].virt_addr == va)
8010889f:	3b 10                	cmp    (%eax),%edx
801088a1:	75 ed                	jne    80108890 <handle_pagedout+0x50>
801088a3:	6b f7 1c             	imul   $0x1c,%edi,%esi
801088a6:	81 c6 88 00 00 00    	add    $0x88,%esi
    struct page *swap_page = &curproc->swappedPages[index];
801088ac:	8d 04 33             	lea    (%ebx,%esi,1),%eax
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801088af:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
801088b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801088b7:	6b c7 1c             	imul   $0x1c,%edi,%eax
801088ba:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801088bd:	ff b6 94 00 00 00    	pushl  0x94(%esi)
801088c3:	68 00 c6 10 80       	push   $0x8010c600
801088c8:	53                   	push   %ebx
801088c9:	e8 72 9d ff ff       	call   80102640 <readFromSwapFile>
801088ce:	83 c4 10             	add    $0x10,%esp
801088d1:	85 c0                	test   %eax,%eax
801088d3:	0f 88 7b 02 00 00    	js     80108b54 <handle_pagedout+0x314>
    struct fblock *new_block = (struct fblock*)kalloc();
801088d9:	e8 62 a4 ff ff       	call   80102d40 <kalloc>
    new_block->off = swap_page->swap_offset;
801088de:	8b 96 94 00 00 00    	mov    0x94(%esi),%edx
    new_block->next = 0;
801088e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
801088eb:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
801088ed:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
801088f3:	89 50 08             	mov    %edx,0x8(%eax)
    if(curproc->free_tail != 0)
801088f6:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
801088fc:	85 d2                	test   %edx,%edx
801088fe:	0f 84 fc 01 00 00    	je     80108b00 <handle_pagedout+0x2c0>
      curproc->free_tail->next = new_block;
80108904:	89 42 04             	mov    %eax,0x4(%edx)
    memmove((void*)start_page, buffer, PGSIZE);
80108907:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
8010890a:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108910:	68 00 10 00 00       	push   $0x1000
80108915:	68 00 c6 10 80       	push   $0x8010c600
8010891a:	ff 75 0c             	pushl  0xc(%ebp)
8010891d:	e8 2e ca ff ff       	call   80105350 <memmove>
    memset((void*)swap_page, 0, sizeof(struct page));
80108922:	83 c4 0c             	add    $0xc,%esp
80108925:	6a 1c                	push   $0x1c
80108927:	6a 00                	push   $0x0
80108929:	ff 75 e4             	pushl  -0x1c(%ebp)
8010892c:	e8 6f c9 ff ff       	call   801052a0 <memset>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108931:	83 c4 10             	add    $0x10,%esp
80108934:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
8010893b:	0f 8f 8f 00 00 00    	jg     801089d0 <handle_pagedout+0x190>
  struct proc * currproc = myproc();
80108941:	e8 ba b9 ff ff       	call   80104300 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108946:	31 ff                	xor    %edi,%edi
80108948:	05 4c 02 00 00       	add    $0x24c,%eax
8010894d:	eb 10                	jmp    8010895f <handle_pagedout+0x11f>
8010894f:	90                   	nop
80108950:	83 c7 01             	add    $0x1,%edi
80108953:	83 c0 1c             	add    $0x1c,%eax
80108956:	83 ff 10             	cmp    $0x10,%edi
80108959:	0f 84 b1 01 00 00    	je     80108b10 <handle_pagedout+0x2d0>
    if(((struct page)currproc->ramPages[i]).isused == 0)
8010895f:	8b 10                	mov    (%eax),%edx
80108961:	85 d2                	test   %edx,%edx
80108963:	75 eb                	jne    80108950 <handle_pagedout+0x110>
80108965:	6b f7 1c             	imul   $0x1c,%edi,%esi
80108968:	81 c6 48 02 00 00    	add    $0x248,%esi
      cprintf("filling ram slot: %d\n", new_indx);
8010896e:	83 ec 08             	sub    $0x8,%esp
      update_selectionfiled_pagefault(curproc, &curproc->ramPages[new_indx], new_indx);
80108971:	01 de                	add    %ebx,%esi
      cprintf("filling ram slot: %d\n", new_indx);
80108973:	57                   	push   %edi
80108974:	68 35 9d 10 80       	push   $0x80109d35
80108979:	e8 e2 7c ff ff       	call   80100660 <cprintf>
      curproc->ramPages[new_indx].virt_addr = start_page;
8010897e:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108981:	8b 4d 0c             	mov    0xc(%ebp),%ecx
      update_selectionfiled_pagefault(curproc, &curproc->ramPages[new_indx], new_indx);
80108984:	83 c4 0c             	add    $0xc,%esp
      curproc->ramPages[new_indx].virt_addr = start_page;
80108987:	01 d8                	add    %ebx,%eax
80108989:	89 88 50 02 00 00    	mov    %ecx,0x250(%eax)
      curproc->ramPages[new_indx].isused = 1;
8010898f:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80108996:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108999:	8b 53 04             	mov    0x4(%ebx),%edx
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
8010899c:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
801089a3:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801089a6:	89 90 48 02 00 00    	mov    %edx,0x248(%eax)
      update_selectionfiled_pagefault(curproc, &curproc->ramPages[new_indx], new_indx);
801089ac:	57                   	push   %edi
801089ad:	56                   	push   %esi
801089ae:	53                   	push   %ebx
801089af:	e8 2c f0 ff ff       	call   801079e0 <update_selectionfiled_allocuvm>
      curproc->num_ram++;
801089b4:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
801089bb:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
801089c2:	83 c4 10             	add    $0x10,%esp
}
801089c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089c8:	5b                   	pop    %ebx
801089c9:	5e                   	pop    %esi
801089ca:	5f                   	pop    %edi
801089cb:	5d                   	pop    %ebp
801089cc:	c3                   	ret    
801089cd:	8d 76 00             	lea    0x0(%esi),%esi
    return aq();
801089d0:	e8 6b fa ff ff       	call   80108440 <aq>
801089d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
801089d8:	6b c0 1c             	imul   $0x1c,%eax,%eax
801089db:	8d 84 03 48 02 00 00 	lea    0x248(%ebx,%eax,1),%eax
801089e2:	89 45 dc             	mov    %eax,-0x24(%ebp)
      int swap_offset = curproc->free_head->off;
801089e5:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
801089eb:	8b 08                	mov    (%eax),%ecx
      if(curproc->free_head->next == 0)
801089ed:	8b 40 04             	mov    0x4(%eax),%eax
801089f0:	85 c0                	test   %eax,%eax
      int swap_offset = curproc->free_head->off;
801089f2:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      if(curproc->free_head->next == 0)
801089f5:	0f 84 25 01 00 00    	je     80108b20 <handle_pagedout+0x2e0>
        curproc->free_head = curproc->free_head->next;
801089fb:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
80108a01:	6b 75 e0 1c          	imul   $0x1c,-0x20(%ebp),%esi
80108a05:	68 00 10 00 00       	push   $0x1000
80108a0a:	ff 75 e4             	pushl  -0x1c(%ebp)
80108a0d:	01 de                	add    %ebx,%esi
80108a0f:	ff b6 50 02 00 00    	pushl  0x250(%esi)
80108a15:	53                   	push   %ebx
80108a16:	e8 d5 9b ff ff       	call   801025f0 <writeToSwapFile>
80108a1b:	83 c4 10             	add    $0x10,%esp
80108a1e:	85 c0                	test   %eax,%eax
80108a20:	0f 88 3b 01 00 00    	js     80108b61 <handle_pagedout+0x321>
      swap_page->virt_addr = ram_page->virt_addr;
80108a26:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80108a29:	8b 96 50 02 00 00    	mov    0x250(%esi),%edx
80108a2f:	01 d9                	add    %ebx,%ecx
80108a31:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
80108a37:	8b 86 48 02 00 00    	mov    0x248(%esi),%eax
      swap_page->isused = 1;
80108a3d:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80108a44:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
80108a47:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108a4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108a50:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108a56:	8b 43 04             	mov    0x4(%ebx),%eax
80108a59:	31 c9                	xor    %ecx,%ecx
80108a5b:	e8 30 ea ff ff       	call   80107490 <walkpgdir>
      if(!(*pte & PTE_P))
80108a60:	8b 30                	mov    (%eax),%esi
80108a62:	f7 c6 01 00 00 00    	test   $0x1,%esi
80108a68:	0f 84 00 01 00 00    	je     80108b6e <handle_pagedout+0x32e>
      ramPa = (void*)PTE_ADDR(*pte);
80108a6e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
       if(getRefs(P2V(ramPa)) == 1)
80108a74:	83 ec 0c             	sub    $0xc,%esp
80108a77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108a7a:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80108a80:	56                   	push   %esi
80108a81:	e8 4a a4 ff ff       	call   80102ed0 <getRefs>
80108a86:	83 c4 10             	add    $0x10,%esp
80108a89:	83 f8 01             	cmp    $0x1,%eax
80108a8c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108a8f:	0f 84 ab 00 00 00    	je     80108b40 <handle_pagedout+0x300>
           refDec(P2V(ramPa));
80108a95:	83 ec 0c             	sub    $0xc,%esp
80108a98:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108a9b:	56                   	push   %esi
80108a9c:	e8 4f a3 ff ff       	call   80102df0 <refDec>
80108aa1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108aa4:	83 c4 10             	add    $0x10,%esp
      *pte &= ~PTE_P;     // turn "present" flag off
80108aa7:	8b 02                	mov    (%edx),%eax
      ram_page->virt_addr = start_page;
80108aa9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
80108aac:	83 ec 04             	sub    $0x4,%esp
      ram_page->virt_addr = start_page;
80108aaf:	8b 75 0c             	mov    0xc(%ebp),%esi
      *pte &= ~PTE_P;     // turn "present" flag off
80108ab2:	25 fe 0f 00 00       	and    $0xffe,%eax
80108ab7:	80 cc 02             	or     $0x2,%ah
80108aba:	89 02                	mov    %eax,(%edx)
      ram_page->virt_addr = start_page;
80108abc:	6b c1 1c             	imul   $0x1c,%ecx,%eax
80108abf:	89 b4 03 50 02 00 00 	mov    %esi,0x250(%ebx,%eax,1)
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
80108ac6:	51                   	push   %ecx
80108ac7:	ff 75 dc             	pushl  -0x24(%ebp)
80108aca:	53                   	push   %ebx
80108acb:	e8 10 ef ff ff       	call   801079e0 <update_selectionfiled_allocuvm>
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108ad0:	8b 43 04             	mov    0x4(%ebx),%eax
80108ad3:	05 00 00 00 80       	add    $0x80000000,%eax
80108ad8:	0f 22 d8             	mov    %eax,%cr3
80108adb:	83 c4 10             	add    $0x10,%esp
}
80108ade:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108ae1:	5b                   	pop    %ebx
80108ae2:	5e                   	pop    %esi
80108ae3:	5f                   	pop    %edi
80108ae4:	5d                   	pop    %ebp
80108ae5:	c3                   	ret    
80108ae6:	8d 76 00             	lea    0x0(%esi),%esi
80108ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108af0:	be 6c 00 00 00       	mov    $0x6c,%esi
  return -1;
80108af5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108afa:	e9 ad fd ff ff       	jmp    801088ac <handle_pagedout+0x6c>
80108aff:	90                   	nop
      curproc->free_head = new_block;
80108b00:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108b06:	e9 fc fd ff ff       	jmp    80108907 <handle_pagedout+0xc7>
80108b0b:	90                   	nop
80108b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108b10:	be 2c 02 00 00       	mov    $0x22c,%esi
  return -1;
80108b15:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108b1a:	e9 4f fe ff ff       	jmp    8010896e <handle_pagedout+0x12e>
80108b1f:	90                   	nop
        curproc->free_tail = 0;
80108b20:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80108b27:	00 00 00 
        curproc->free_head = 0;
80108b2a:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80108b31:	00 00 00 
80108b34:	e9 c8 fe ff ff       	jmp    80108a01 <handle_pagedout+0x1c1>
80108b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
           kfree(P2V(ramPa));
80108b40:	83 ec 0c             	sub    $0xc,%esp
80108b43:	56                   	push   %esi
80108b44:	e8 17 9f ff ff       	call   80102a60 <kfree>
80108b49:	83 c4 10             	add    $0x10,%esp
80108b4c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108b4f:	e9 53 ff ff ff       	jmp    80108aa7 <handle_pagedout+0x267>
      panic("allocuvm: readFromSwapFile1");
80108b54:	83 ec 0c             	sub    $0xc,%esp
80108b57:	68 19 9d 10 80       	push   $0x80109d19
80108b5c:	e8 2f 78 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108b61:	83 ec 0c             	sub    $0xc,%esp
80108b64:	68 cb 9c 10 80       	push   $0x80109ccb
80108b69:	e8 22 78 ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108b6e:	83 ec 0c             	sub    $0xc,%esp
80108b71:	68 b4 9e 10 80       	push   $0x80109eb4
80108b76:	e8 15 78 ff ff       	call   80100390 <panic>
80108b7b:	90                   	nop
80108b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108b80 <pagefault>:
{
80108b80:	55                   	push   %ebp
80108b81:	89 e5                	mov    %esp,%ebp
80108b83:	57                   	push   %edi
80108b84:	56                   	push   %esi
80108b85:	53                   	push   %ebx
80108b86:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108b89:	e8 72 b7 ff ff       	call   80104300 <myproc>
80108b8e:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108b90:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108b93:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108b9a:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108b9c:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
80108b9f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108ba5:	31 c9                	xor    %ecx,%ecx
80108ba7:	89 fa                	mov    %edi,%edx
80108ba9:	e8 e2 e8 ff ff       	call   80107490 <walkpgdir>
  if((*pte & PTE_PG) && !(*pte & PTE_COW)) // paged out, not COW todo
80108bae:	8b 10                	mov    (%eax),%edx
80108bb0:	81 e2 00 06 00 00    	and    $0x600,%edx
80108bb6:	81 fa 00 02 00 00    	cmp    $0x200,%edx
80108bbc:	74 52                	je     80108c10 <pagefault+0x90>
    if(va >= KERNBASE || pte == 0)
80108bbe:	85 f6                	test   %esi,%esi
80108bc0:	78 1e                	js     80108be0 <pagefault+0x60>
    handle_cow_pagefault(curproc, pte, start_page);
80108bc2:	83 ec 04             	sub    $0x4,%esp
80108bc5:	57                   	push   %edi
80108bc6:	50                   	push   %eax
80108bc7:	53                   	push   %ebx
80108bc8:	e8 43 f4 ff ff       	call   80108010 <handle_cow_pagefault>
80108bcd:	83 c4 10             	add    $0x10,%esp
}
80108bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108bd3:	5b                   	pop    %ebx
80108bd4:	5e                   	pop    %esi
80108bd5:	5f                   	pop    %edi
80108bd6:	5d                   	pop    %ebp
80108bd7:	c3                   	ret    
80108bd8:	90                   	nop
80108bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108be0:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108be3:	83 ec 04             	sub    $0x4,%esp
80108be6:	50                   	push   %eax
80108be7:	ff 73 10             	pushl  0x10(%ebx)
80108bea:	68 d8 9e 10 80       	push   $0x80109ed8
80108bef:	e8 6c 7a ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80108bf4:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
80108bfb:	83 c4 10             	add    $0x10,%esp
}
80108bfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c01:	5b                   	pop    %ebx
80108c02:	5e                   	pop    %esi
80108c03:	5f                   	pop    %edi
80108c04:	5d                   	pop    %ebp
80108c05:	c3                   	ret    
80108c06:	8d 76 00             	lea    0x0(%esi),%esi
80108c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      handle_pagedout(curproc, start_page, pte);
80108c10:	83 ec 04             	sub    $0x4,%esp
80108c13:	50                   	push   %eax
80108c14:	57                   	push   %edi
80108c15:	53                   	push   %ebx
80108c16:	e8 25 fc ff ff       	call   80108840 <handle_pagedout>
80108c1b:	83 c4 10             	add    $0x10,%esp
}
80108c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c21:	5b                   	pop    %ebx
80108c22:	5e                   	pop    %esi
80108c23:	5f                   	pop    %edi
80108c24:	5d                   	pop    %ebp
80108c25:	c3                   	ret    
80108c26:	8d 76 00             	lea    0x0(%esi),%esi
80108c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108c30 <lapa>:
uint lapa()
{
80108c30:	55                   	push   %ebp
80108c31:	89 e5                	mov    %esp,%ebp
80108c33:	57                   	push   %edi
80108c34:	56                   	push   %esi
80108c35:	53                   	push   %ebx
80108c36:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108c39:	e8 c2 b6 ff ff       	call   80104300 <myproc>
  struct page *ramPages = curproc->ramPages;
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
80108c3e:	8b 90 60 02 00 00    	mov    0x260(%eax),%edx
  struct page *ramPages = curproc->ramPages;
80108c44:	8d b8 48 02 00 00    	lea    0x248(%eax),%edi
80108c4a:	89 7d dc             	mov    %edi,-0x24(%ebp)
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
80108c4d:	85 d2                	test   %edx,%edx
80108c4f:	0f 84 ff 00 00 00    	je     80108d54 <lapa+0x124>
    uint count = 0;
80108c55:	31 c9                	xor    %ecx,%ecx
80108c57:	89 f6                	mov    %esi,%esi
80108c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        count += n & 1;
80108c60:	89 d3                	mov    %edx,%ebx
80108c62:	83 e3 01             	and    $0x1,%ebx
80108c65:	01 d9                	add    %ebx,%ecx
    while (n) {
80108c67:	d1 ea                	shr    %edx
80108c69:	75 f5                	jne    80108c60 <lapa+0x30>
80108c6b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108c6e:	05 7c 02 00 00       	add    $0x27c,%eax
  uint instances = 0;
80108c73:	31 ff                	xor    %edi,%edi
  uint minloc = 0;
80108c75:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108c7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint count = 0;
80108c7f:	89 c6                	mov    %eax,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c81:	bb 01 00 00 00       	mov    $0x1,%ebx
80108c86:	8d 76 00             	lea    0x0(%esi),%esi
80108c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108c90:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108c92:	31 d2                	xor    %edx,%edx
    while (n) {
80108c94:	85 c0                	test   %eax,%eax
80108c96:	74 13                	je     80108cab <lapa+0x7b>
80108c98:	90                   	nop
80108c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108ca0:	89 c1                	mov    %eax,%ecx
80108ca2:	83 e1 01             	and    $0x1,%ecx
80108ca5:	01 ca                	add    %ecx,%edx
    while (n) {
80108ca7:	d1 e8                	shr    %eax
80108ca9:	75 f5                	jne    80108ca0 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
80108cab:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
80108cae:	0f 82 84 00 00 00    	jb     80108d38 <lapa+0x108>
      instances++;
80108cb4:	0f 94 c0             	sete   %al
80108cb7:	0f b6 c0             	movzbl %al,%eax
80108cba:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108cbc:	83 c3 01             	add    $0x1,%ebx
80108cbf:	83 c6 1c             	add    $0x1c,%esi
80108cc2:	83 fb 10             	cmp    $0x10,%ebx
80108cc5:	75 c9                	jne    80108c90 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108cc7:	83 ff 01             	cmp    $0x1,%edi
80108cca:	76 5b                	jbe    80108d27 <lapa+0xf7>
      uint minvalue = ramPages[minloc].lapa_counter;
80108ccc:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
80108cd0:	8b 7d dc             	mov    -0x24(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108cd3:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108cd8:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108cdc:	89 7d dc             	mov    %edi,-0x24(%ebp)
80108cdf:	8b 7d d8             	mov    -0x28(%ebp),%edi
80108ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108ce8:	8b 1f                	mov    (%edi),%ebx
    while (n) {
80108cea:	85 db                	test   %ebx,%ebx
80108cec:	74 62                	je     80108d50 <lapa+0x120>
80108cee:	89 d8                	mov    %ebx,%eax
    uint count = 0;
80108cf0:	31 d2                	xor    %edx,%edx
80108cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
80108cf8:	89 c1                	mov    %eax,%ecx
80108cfa:	83 e1 01             	and    $0x1,%ecx
80108cfd:	01 ca                	add    %ecx,%edx
    while (n) {
80108cff:	d1 e8                	shr    %eax
80108d01:	75 f5                	jne    80108cf8 <lapa+0xc8>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
80108d03:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108d06:	75 14                	jne    80108d1c <lapa+0xec>
80108d08:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d0b:	39 c3                	cmp    %eax,%ebx
80108d0d:	0f 43 d8             	cmovae %eax,%ebx
80108d10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d13:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80108d16:	0f 42 c6             	cmovb  %esi,%eax
80108d19:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d1c:	83 c6 01             	add    $0x1,%esi
80108d1f:	83 c7 1c             	add    $0x1c,%edi
80108d22:	83 fe 10             	cmp    $0x10,%esi
80108d25:	75 c1                	jne    80108ce8 <lapa+0xb8>
}
80108d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d2a:	83 c4 1c             	add    $0x1c,%esp
80108d2d:	5b                   	pop    %ebx
80108d2e:	5e                   	pop    %esi
80108d2f:	5f                   	pop    %edi
80108d30:	5d                   	pop    %ebp
80108d31:	c3                   	ret    
80108d32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      minloc = i;
80108d38:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80108d3b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      instances = 1;
80108d3e:	bf 01 00 00 00       	mov    $0x1,%edi
80108d43:	e9 74 ff ff ff       	jmp    80108cbc <lapa+0x8c>
80108d48:	90                   	nop
80108d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint count = 0;
80108d50:	31 d2                	xor    %edx,%edx
80108d52:	eb af                	jmp    80108d03 <lapa+0xd3>
80108d54:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108d5b:	e9 0e ff ff ff       	jmp    80108c6e <lapa+0x3e>

80108d60 <nfua>:
{
80108d60:	55                   	push   %ebp
80108d61:	89 e5                	mov    %esp,%ebp
80108d63:	56                   	push   %esi
80108d64:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108d65:	e8 96 b5 ff ff       	call   80104300 <myproc>
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d6a:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
80108d6f:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108d75:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
80108d7b:	31 c0                	xor    %eax,%eax
80108d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ramPages[i].nfua_counter < minval)
80108d80:	8b 19                	mov    (%ecx),%ebx
80108d82:	39 f3                	cmp    %esi,%ebx
80108d84:	73 04                	jae    80108d8a <nfua+0x2a>
      minloc = i;
80108d86:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108d88:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d8a:	83 c2 01             	add    $0x1,%edx
80108d8d:	83 c1 1c             	add    $0x1c,%ecx
80108d90:	83 fa 10             	cmp    $0x10,%edx
80108d93:	75 eb                	jne    80108d80 <nfua+0x20>
}
80108d95:	5b                   	pop    %ebx
80108d96:	5e                   	pop    %esi
80108d97:	5d                   	pop    %ebp
80108d98:	c3                   	ret    
80108d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108da0 <scfifo>:
{
80108da0:	55                   	push   %ebp
80108da1:	89 e5                	mov    %esp,%ebp
80108da3:	57                   	push   %edi
80108da4:	56                   	push   %esi
80108da5:	53                   	push   %ebx
80108da6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108da9:	e8 52 b5 ff ff       	call   80104300 <myproc>
80108dae:	89 c7                	mov    %eax,%edi
80108db0:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108db6:	83 f8 0f             	cmp    $0xf,%eax
80108db9:	89 c3                	mov    %eax,%ebx
80108dbb:	7f 5f                	jg     80108e1c <scfifo+0x7c>
80108dbd:	6b c0 1c             	imul   $0x1c,%eax,%eax
80108dc0:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108dc7:	eb 17                	jmp    80108de0 <scfifo+0x40>
80108dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108dd0:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108dd3:	83 e2 df             	and    $0xffffffdf,%edx
80108dd6:	83 c6 1c             	add    $0x1c,%esi
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108dd9:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
80108ddc:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108dde:	74 30                	je     80108e10 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108de0:	8b 56 08             	mov    0x8(%esi),%edx
80108de3:	8b 06                	mov    (%esi),%eax
80108de5:	31 c9                	xor    %ecx,%ecx
80108de7:	e8 a4 e6 ff ff       	call   80107490 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108dec:	8b 10                	mov    (%eax),%edx
80108dee:	f6 c2 20             	test   $0x20,%dl
80108df1:	75 dd                	jne    80108dd0 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108df3:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108dfa:	74 74                	je     80108e70 <scfifo+0xd0>
            curproc->clockHand = i + 1;
80108dfc:	8d 43 01             	lea    0x1(%ebx),%eax
80108dff:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
80108e05:	83 c4 0c             	add    $0xc,%esp
80108e08:	89 d8                	mov    %ebx,%eax
80108e0a:	5b                   	pop    %ebx
80108e0b:	5e                   	pop    %esi
80108e0c:	5f                   	pop    %edi
80108e0d:	5d                   	pop    %ebp
80108e0e:	c3                   	ret    
80108e0f:	90                   	nop
80108e10:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108e16:	31 db                	xor    %ebx,%ebx
    for(j=0; j< curproc->clockHand ;j++)
80108e18:	85 c0                	test   %eax,%eax
80108e1a:	74 a1                	je     80108dbd <scfifo+0x1d>
80108e1c:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108e22:	31 c9                	xor    %ecx,%ecx
80108e24:	eb 20                	jmp    80108e46 <scfifo+0xa6>
80108e26:	8d 76 00             	lea    0x0(%esi),%esi
80108e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          *pte &= ~PTE_A;  
80108e30:	83 e2 df             	and    $0xffffffdf,%edx
80108e33:	83 c6 1c             	add    $0x1c,%esi
80108e36:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108e38:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108e3e:	39 c8                	cmp    %ecx,%eax
80108e40:	0f 86 70 ff ff ff    	jbe    80108db6 <scfifo+0x16>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108e46:	8b 56 08             	mov    0x8(%esi),%edx
80108e49:	8b 06                	mov    (%esi),%eax
80108e4b:	89 cb                	mov    %ecx,%ebx
80108e4d:	31 c9                	xor    %ecx,%ecx
80108e4f:	e8 3c e6 ff ff       	call   80107490 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108e54:	8b 10                	mov    (%eax),%edx
80108e56:	8d 4b 01             	lea    0x1(%ebx),%ecx
80108e59:	f6 c2 20             	test   $0x20,%dl
80108e5c:	75 d2                	jne    80108e30 <scfifo+0x90>
          curproc->clockHand = j + 1;
80108e5e:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108e64:	83 c4 0c             	add    $0xc,%esp
80108e67:	89 d8                	mov    %ebx,%eax
80108e69:	5b                   	pop    %ebx
80108e6a:	5e                   	pop    %esi
80108e6b:	5f                   	pop    %edi
80108e6c:	5d                   	pop    %ebp
80108e6d:	c3                   	ret    
80108e6e:	66 90                	xchg   %ax,%ax
            curproc->clockHand = 0;
80108e70:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
80108e77:	00 00 00 
}
80108e7a:	83 c4 0c             	add    $0xc,%esp
80108e7d:	89 d8                	mov    %ebx,%eax
80108e7f:	5b                   	pop    %ebx
80108e80:	5e                   	pop    %esi
80108e81:	5f                   	pop    %edi
80108e82:	5d                   	pop    %ebp
80108e83:	c3                   	ret    
80108e84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108e8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108e90 <countSetBits>:
{
80108e90:	55                   	push   %ebp
    uint count = 0;
80108e91:	31 c0                	xor    %eax,%eax
{
80108e93:	89 e5                	mov    %esp,%ebp
80108e95:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108e98:	85 d2                	test   %edx,%edx
80108e9a:	74 0f                	je     80108eab <countSetBits+0x1b>
80108e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108ea0:	89 d1                	mov    %edx,%ecx
80108ea2:	83 e1 01             	and    $0x1,%ecx
80108ea5:	01 c8                	add    %ecx,%eax
    while (n) {
80108ea7:	d1 ea                	shr    %edx
80108ea9:	75 f5                	jne    80108ea0 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108eab:	5d                   	pop    %ebp
80108eac:	c3                   	ret    
80108ead:	8d 76 00             	lea    0x0(%esi),%esi

80108eb0 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108eb0:	55                   	push   %ebp
80108eb1:	89 e5                	mov    %esp,%ebp
80108eb3:	56                   	push   %esi
80108eb4:	53                   	push   %ebx
80108eb5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
80108eb8:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108ebb:	e8 40 b4 ff ff       	call   80104300 <myproc>
80108ec0:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108ec6:	74 30                	je     80108ef8 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108ec8:	e8 33 b4 ff ff       	call   80104300 <myproc>
80108ecd:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108ed3:	74 53                	je     80108f28 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108ed5:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108ed8:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108eda:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108edc:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108edf:	85 d2                	test   %edx,%edx
80108ee1:	74 05                	je     80108ee8 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108ee3:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108ee6:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108ee8:	85 c0                	test   %eax,%eax
80108eea:	74 05                	je     80108ef1 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108eec:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108eee:	89 70 04             	mov    %esi,0x4(%eax)
  }
}
80108ef1:	5b                   	pop    %ebx
80108ef2:	5e                   	pop    %esi
80108ef3:	5d                   	pop    %ebp
80108ef4:	c3                   	ret    
80108ef5:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108ef8:	e8 03 b4 ff ff       	call   80104300 <myproc>
80108efd:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108f03:	e8 f8 b3 ff ff       	call   80104300 <myproc>
80108f08:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108f0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108f14:	e8 e7 b3 ff ff       	call   80104300 <myproc>
80108f19:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108f1f:	75 b4                	jne    80108ed5 <swapAQ+0x25>
80108f21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108f28:	e8 d3 b3 ff ff       	call   80104300 <myproc>
80108f2d:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108f33:	e8 c8 b3 ff ff       	call   80104300 <myproc>
80108f38:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108f3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108f45:	eb 8e                	jmp    80108ed5 <swapAQ+0x25>
80108f47:	89 f6                	mov    %esi,%esi
80108f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108f50 <updateAQ>:
{
80108f50:	55                   	push   %ebp
80108f51:	89 e5                	mov    %esp,%ebp
80108f53:	57                   	push   %edi
80108f54:	56                   	push   %esi
80108f55:	53                   	push   %ebx
80108f56:	83 ec 1c             	sub    $0x1c,%esp
80108f59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108f5c:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108f62:	85 d2                	test   %edx,%edx
80108f64:	0f 84 7e 00 00 00    	je     80108fe8 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108f6a:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108f70:	8b 56 04             	mov    0x4(%esi),%edx
80108f73:	85 d2                	test   %edx,%edx
80108f75:	74 71                	je     80108fe8 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80108f77:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
80108f7d:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108f81:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108f85:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108f88:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108f8a:	01 d8                	add    %ebx,%eax
80108f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80108f90:	8b 50 08             	mov    0x8(%eax),%edx
80108f93:	8b 00                	mov    (%eax),%eax
80108f95:	31 c9                	xor    %ecx,%ecx
80108f97:	e8 f4 e4 ff ff       	call   80107490 <walkpgdir>
80108f9c:	85 c0                	test   %eax,%eax
80108f9e:	89 c3                	mov    %eax,%ebx
80108fa0:	74 5e                	je     80109000 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80108fa2:	8b 00                	mov    (%eax),%eax
80108fa4:	8b 56 04             	mov    0x4(%esi),%edx
80108fa7:	a8 20                	test   $0x20,%al
80108fa9:	74 23                	je     80108fce <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
80108fab:	85 d2                	test   %edx,%edx
80108fad:	74 17                	je     80108fc6 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
80108faf:	8b 57 08             	mov    0x8(%edi),%edx
80108fb2:	8b 07                	mov    (%edi),%eax
80108fb4:	31 c9                	xor    %ecx,%ecx
80108fb6:	e8 d5 e4 ff ff       	call   80107490 <walkpgdir>
80108fbb:	85 c0                	test   %eax,%eax
80108fbd:	74 41                	je     80109000 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
80108fbf:	f6 00 20             	testb  $0x20,(%eax)
80108fc2:	74 2c                	je     80108ff0 <updateAQ+0xa0>
80108fc4:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80108fc6:	83 e0 df             	and    $0xffffffdf,%eax
80108fc9:	89 03                	mov    %eax,(%ebx)
80108fcb:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
80108fce:	85 d2                	test   %edx,%edx
80108fd0:	74 16                	je     80108fe8 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80108fd2:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108fd6:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
80108fda:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
80108fdd:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
80108fdf:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80108fe1:	01 cf                	add    %ecx,%edi
80108fe3:	eb ab                	jmp    80108f90 <updateAQ+0x40>
80108fe5:	8d 76 00             	lea    0x0(%esi),%esi
}
80108fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108feb:	5b                   	pop    %ebx
80108fec:	5e                   	pop    %esi
80108fed:	5f                   	pop    %edi
80108fee:	5d                   	pop    %ebp
80108fef:	c3                   	ret    
          swapAQ(curr_node);
80108ff0:	83 ec 0c             	sub    $0xc,%esp
80108ff3:	56                   	push   %esi
80108ff4:	e8 b7 fe ff ff       	call   80108eb0 <swapAQ>
80108ff9:	8b 03                	mov    (%ebx),%eax
80108ffb:	83 c4 10             	add    $0x10,%esp
80108ffe:	eb c6                	jmp    80108fc6 <updateAQ+0x76>
      panic("updateAQ: no pte");
80109000:	83 ec 0c             	sub    $0xc,%esp
80109003:	68 4b 9d 10 80       	push   $0x80109d4b
80109008:	e8 83 73 ff ff       	call   80100390 <panic>
8010900d:	8d 76 00             	lea    0x0(%esi),%esi

80109010 <getNumRefsWarpper>:

 int
  getNumRefsWarpper(int idx)
  {
80109010:	55                   	push   %ebp
80109011:	89 e5                	mov    %esp,%ebp
80109013:	53                   	push   %ebx
80109014:	83 ec 04             	sub    $0x4,%esp
80109017:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc * curproc = myproc();
8010901a:	e8 e1 b2 ff ff       	call   80104300 <myproc>
    pte_t *evicted_pte = walkpgdir(curproc->ramPages[idx].pgdir, (void*)curproc->ramPages[idx].virt_addr, 0);
8010901f:	31 c9                	xor    %ecx,%ecx
80109021:	6b db 1c             	imul   $0x1c,%ebx,%ebx
80109024:	01 d8                	add    %ebx,%eax
80109026:	8b 90 50 02 00 00    	mov    0x250(%eax),%edx
8010902c:	8b 80 48 02 00 00    	mov    0x248(%eax),%eax
80109032:	e8 59 e4 ff ff       	call   80107490 <walkpgdir>
    char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80109037:	8b 00                	mov    (%eax),%eax
80109039:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    return getRefs(P2V(evicted_pa));
8010903e:	05 00 00 00 80       	add    $0x80000000,%eax
80109043:	89 45 08             	mov    %eax,0x8(%ebp)

  }
80109046:	83 c4 04             	add    $0x4,%esp
80109049:	5b                   	pop    %ebx
8010904a:	5d                   	pop    %ebp
    return getRefs(P2V(evicted_pa));
8010904b:	e9 80 9e ff ff       	jmp    80102ed0 <getRefs>

80109050 <getRamPageIndexByVirtAddr>:
80109050:	55                   	push   %ebp
80109051:	89 e5                	mov    %esp,%ebp
80109053:	5d                   	pop    %ebp
80109054:	e9 67 ef ff ff       	jmp    80107fc0 <getSwappedPageIndex>
