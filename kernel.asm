
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
8010002d:	b8 40 38 10 80       	mov    $0x80103840,%eax
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
80100056:	e8 35 50 00 00       	call   80105090 <initlock>
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
80100098:	e8 c3 4e 00 00       	call   80104f60 <initsleeplock>
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
801000e4:	e8 e7 50 00 00       	call   801051d0 <acquire>
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
80100162:	e8 29 51 00 00       	call   80105290 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 4e 00 00       	call   80104fa0 <acquiresleep>
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
801001ae:	e8 8d 4e 00 00       	call   80105040 <holdingsleep>
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
801001ef:	e8 4c 4e 00 00       	call   80105040 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 4d 00 00       	call   80105000 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 c0 4f 00 00       	call   801051d0 <acquire>
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
8010025c:	e9 2f 50 00 00       	jmp    80105290 <release>
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
80100280:	e8 8b 18 00 00       	call   80101b10 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010028c:	e8 3f 4f 00 00       	call   801051d0 <acquire>
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
801002c5:	e8 b6 47 00 00       	call   80104a80 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 c0 2f 11 80    	mov    0x80112fc0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 c4 2f 11 80    	cmp    0x80112fc4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 3f 00 00       	call   801042b0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 c5 10 80       	push   $0x8010c520
801002ef:	e8 9c 4f 00 00       	call   80105290 <release>
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
8010034d:	e8 3e 4f 00 00       	call   80105290 <release>
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
801003a9:	e8 22 2d 00 00       	call   801030d0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 8f 10 80       	push   $0x80108f0d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 a0 9a 10 80 	movl   $0x80109aa0,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 d3 4c 00 00       	call   801050b0 <getcallerpcs>
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
80100524:	e8 67 4e 00 00       	call   80105390 <memmove>
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
80100541:	e8 9a 4d 00 00       	call   801052e0 <memset>
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
8010060f:	e8 fc 14 00 00       	call   80101b10 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 c5 10 80 	movl   $0x8010c520,(%esp)
8010061b:	e8 b0 4b 00 00       	call   801051d0 <acquire>
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
80100647:	e8 44 4c 00 00       	call   80105290 <release>
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
8010071f:	e8 6c 4b 00 00       	call   80105290 <release>
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
801007f0:	e8 db 49 00 00       	call   801051d0 <acquire>
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
80100823:	e8 a8 49 00 00       	call   801051d0 <acquire>
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
80100888:	e8 03 4a 00 00       	call   80105290 <release>
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
80100916:	e8 a5 43 00 00       	call   80104cc0 <wakeup>
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
80100997:	e9 b4 44 00 00       	jmp    80104e50 <procdump>
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
801009d0:	e8 bb 46 00 00       	call   80105090 <initlock>

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
80100a2b:	e8 60 49 00 00       	call   80105390 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a30:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a36:	83 c4 0c             	add    $0xc,%esp
80100a39:	68 c0 01 00 00       	push   $0x1c0
80100a3e:	50                   	push   %eax
80100a3f:	68 c0 31 11 80       	push   $0x801131c0
80100a44:	e8 47 49 00 00       	call   80105390 <memmove>
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
80100ac8:	e8 13 48 00 00       	call   801052e0 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100acd:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ad3:	83 c4 0c             	add    $0xc,%esp
80100ad6:	68 c0 01 00 00       	push   $0x1c0
80100adb:	6a 00                	push   $0x0
80100add:	50                   	push   %eax
80100ade:	e8 fd 47 00 00       	call   801052e0 <memset>
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
80100b11:	e8 0a 22 00 00       	call   80102d20 <kalloc>
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
80100b38:	e8 e3 21 00 00       	call   80102d20 <kalloc>
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
80100bb7:	68 61 8f 10 80       	push   $0x80108f61
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
80100c37:	68 61 8f 10 80       	push   $0x80108f61
80100c3c:	e8 1f fa ff ff       	call   80100660 <cprintf>
80100c41:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	eb ba                	jmp    80100c06 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	68 90 8f 10 80       	push   $0x80108f90
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
80100c6c:	e8 3f 36 00 00       	call   801042b0 <myproc>
  
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
80100c7d:	e8 be 28 00 00       	call   80103540 <begin_op>

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
80100ccf:	68 82 8f 10 80       	push   $0x80108f82
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
80100cf4:	e8 b7 28 00 00       	call   801035b0 <end_op>
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
80100d44:	e8 47 46 00 00       	call   80105390 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d49:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d4f:	83 c4 0c             	add    $0xc,%esp
80100d52:	68 c0 01 00 00       	push   $0x1c0
80100d57:	68 c0 31 11 80       	push   $0x801131c0
80100d5c:	50                   	push   %eax
80100d5d:	e8 2e 46 00 00       	call   80105390 <memmove>
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
80100dc0:	e8 6b 72 00 00       	call   80108030 <setupkvm>
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
80100e2e:	e8 ed 6f 00 00       	call   80107e20 <allocuvm>
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
80100e60:	e8 bb 6a 00 00       	call   80107920 <loaduvm>
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
80100eaa:	68 82 8f 10 80       	push   $0x80108f82
80100eaf:	e8 ac f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100eb4:	58                   	pop    %eax
80100eb5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ebb:	e8 f0 70 00 00       	call   80107fb0 <freevm>
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
80100efa:	e8 b1 26 00 00       	call   801035b0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100eff:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100f05:	83 c4 0c             	add    $0xc,%esp
80100f08:	50                   	push   %eax
80100f09:	57                   	push   %edi
80100f0a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100f10:	e8 0b 6f 00 00       	call   80107e20 <allocuvm>
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
80100f3e:	e8 9d 71 00 00       	call   801080e0 <clearpteu>
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
80100f8b:	e8 70 45 00 00       	call   80105500 <strlen>
80100f90:	f7 d0                	not    %eax
80100f92:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f94:	58                   	pop    %eax
80100f95:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f98:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f9b:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f9e:	e8 5d 45 00 00       	call   80105500 <strlen>
80100fa3:	83 c0 01             	add    $0x1,%eax
80100fa6:	50                   	push   %eax
80100fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faa:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fad:	56                   	push   %esi
80100fae:	57                   	push   %edi
80100faf:	e8 cc 78 00 00       	call   80108880 <copyout>
80100fb4:	83 c4 20             	add    $0x20,%esp
80100fb7:	85 c0                	test   %eax,%eax
80100fb9:	79 ad                	jns    80100f68 <exec+0x308>
80100fbb:	8b 9d ec fe ff ff    	mov    -0x114(%ebp),%ebx
  ip = 0;
80100fc1:	31 f6                	xor    %esi,%esi
80100fc3:	e9 df fe ff ff       	jmp    80100ea7 <exec+0x247>
    end_op();
80100fc8:	e8 e3 25 00 00       	call   801035b0 <end_op>
    cprintf("exec: fail\n");
80100fcd:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80100fd0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    cprintf("exec: fail\n");
80100fd5:	68 76 8f 10 80       	push   $0x80108f76
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
80101029:	e8 52 78 00 00       	call   80108880 <copyout>
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
80101061:	e8 5a 44 00 00       	call   801054c0 <safestrcpy>
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
801010d2:	e8 b9 66 00 00       	call   80107790 <switchuvm>
  freevm(oldpgdir);
801010d7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 cb 6e 00 00       	call   80107fb0 <freevm>
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
80101116:	68 bb 8f 10 80       	push   $0x80108fbb
8010111b:	68 a0 33 11 80       	push   $0x801133a0
80101120:	e8 6b 3f 00 00       	call   80105090 <initlock>
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
80101141:	e8 8a 40 00 00       	call   801051d0 <acquire>
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
80101171:	e8 1a 41 00 00       	call   80105290 <release>
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
8010118a:	e8 01 41 00 00       	call   80105290 <release>
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
801011af:	e8 1c 40 00 00       	call   801051d0 <acquire>
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
801011cc:	e8 bf 40 00 00       	call   80105290 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 c2 8f 10 80       	push   $0x80108fc2
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
80101201:	e8 ca 3f 00 00       	call   801051d0 <acquire>
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
8010122c:	e9 5f 40 00 00       	jmp    80105290 <release>
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
80101258:	e8 33 40 00 00       	call   80105290 <release>
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
80101281:	e8 6a 2a 00 00       	call   80103cf0 <pipeclose>
80101286:	83 c4 10             	add    $0x10,%esp
80101289:	eb df                	jmp    8010126a <fileclose+0x7a>
8010128b:	90                   	nop
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80101290:	e8 ab 22 00 00       	call   80103540 <begin_op>
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
801012aa:	e9 01 23 00 00       	jmp    801035b0 <end_op>
    panic("fileclose");
801012af:	83 ec 0c             	sub    $0xc,%esp
801012b2:	68 ca 8f 10 80       	push   $0x80108fca
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
8010137d:	e9 1e 2b 00 00       	jmp    80103ea0 <piperead>
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101388:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010138d:	eb d7                	jmp    80101366 <fileread+0x56>
  panic("fileread");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 d4 8f 10 80       	push   $0x80108fd4
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
801013f9:	e8 b2 21 00 00       	call   801035b0 <end_op>
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
80101426:	e8 15 21 00 00       	call   80103540 <begin_op>
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
8010145d:	e8 4e 21 00 00       	call   801035b0 <end_op>
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
8010149d:	e9 ee 28 00 00       	jmp    80103d90 <pipewrite>
        panic("short filewrite");
801014a2:	83 ec 0c             	sub    $0xc,%esp
801014a5:	68 dd 8f 10 80       	push   $0x80108fdd
801014aa:	e8 e1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 e3 8f 10 80       	push   $0x80108fe3
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
80101509:	e8 02 22 00 00       	call   80103710 <log_write>
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
80101523:	68 ed 8f 10 80       	push   $0x80108fed
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
801015d4:	68 00 90 10 80       	push   $0x80109000
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
801015ed:	e8 1e 21 00 00       	call   80103710 <log_write>
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
80101615:	e8 c6 3c 00 00       	call   801052e0 <memset>
  log_write(bp);
8010161a:	89 1c 24             	mov    %ebx,(%esp)
8010161d:	e8 ee 20 00 00       	call   80103710 <log_write>
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
8010165a:	e8 71 3b 00 00       	call   801051d0 <acquire>
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
801016bf:	e8 cc 3b 00 00       	call   80105290 <release>

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
801016ed:	e8 9e 3b 00 00       	call   80105290 <release>
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
80101702:	68 16 90 10 80       	push   $0x80109016
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
8010177e:	e8 8d 1f 00 00       	call   80103710 <log_write>
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
801017d7:	68 26 90 10 80       	push   $0x80109026
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
80101811:	e8 7a 3b 00 00       	call   80105390 <memmove>
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
8010183c:	68 39 90 10 80       	push   $0x80109039
80101841:	68 c0 3d 11 80       	push   $0x80113dc0
80101846:	e8 45 38 00 00       	call   80105090 <initlock>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	68 40 90 10 80       	push   $0x80109040
80101858:	53                   	push   %ebx
80101859:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010185f:	e8 fc 36 00 00       	call   80104f60 <initsleeplock>
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
801018a9:	68 ec 90 10 80       	push   $0x801090ec
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
8010193e:	e8 9d 39 00 00       	call   801052e0 <memset>
      dip->type = type;
80101943:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101947:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010194a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010194d:	89 3c 24             	mov    %edi,(%esp)
80101950:	e8 bb 1d 00 00       	call   80103710 <log_write>
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
80101973:	68 46 90 10 80       	push   $0x80109046
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
801019e1:	e8 aa 39 00 00       	call   80105390 <memmove>
  log_write(bp);
801019e6:	89 34 24             	mov    %esi,(%esp)
801019e9:	e8 22 1d 00 00       	call   80103710 <log_write>
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
80101a0f:	e8 bc 37 00 00       	call   801051d0 <acquire>
  ip->ref++;
80101a14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a18:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a1f:	e8 6c 38 00 00       	call   80105290 <release>
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
80101a52:	e8 49 35 00 00       	call   80104fa0 <acquiresleep>
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
80101ac8:	e8 c3 38 00 00       	call   80105390 <memmove>
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
80101aed:	68 5e 90 10 80       	push   $0x8010905e
80101af2:	e8 99 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 58 90 10 80       	push   $0x80109058
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
80101b23:	e8 18 35 00 00       	call   80105040 <holdingsleep>
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
80101b3f:	e9 bc 34 00 00       	jmp    80105000 <releasesleep>
    panic("iunlock");
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 6d 90 10 80       	push   $0x8010906d
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
80101b70:	e8 2b 34 00 00       	call   80104fa0 <acquiresleep>
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
80101b8a:	e8 71 34 00 00       	call   80105000 <releasesleep>
  acquire(&icache.lock);
80101b8f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101b96:	e8 35 36 00 00       	call   801051d0 <acquire>
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
80101bb0:	e9 db 36 00 00       	jmp    80105290 <release>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bc0:	e8 0b 36 00 00       	call   801051d0 <acquire>
    int r = ip->ref;
80101bc5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bc8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bcf:	e8 bc 36 00 00       	call   80105290 <release>
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
80101db7:	e8 d4 35 00 00       	call   80105390 <memmove>
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
80101eb3:	e8 d8 34 00 00       	call   80105390 <memmove>
    log_write(bp);
80101eb8:	89 3c 24             	mov    %edi,(%esp)
80101ebb:	e8 50 18 00 00       	call   80103710 <log_write>
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
80101f4e:	e8 ad 34 00 00       	call   80105400 <strncmp>
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
80101fad:	e8 4e 34 00 00       	call   80105400 <strncmp>
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
80101ff2:	68 87 90 10 80       	push   $0x80109087
80101ff7:	e8 94 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	68 75 90 10 80       	push   $0x80109075
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
80102029:	e8 82 22 00 00       	call   801042b0 <myproc>
  acquire(&icache.lock);
8010202e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80102031:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80102034:	68 c0 3d 11 80       	push   $0x80113dc0
80102039:	e8 92 31 00 00       	call   801051d0 <acquire>
  ip->ref++;
8010203e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102042:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102049:	e8 42 32 00 00       	call   80105290 <release>
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
801020a5:	e8 e6 32 00 00       	call   80105390 <memmove>
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
80102138:	e8 53 32 00 00       	call   80105390 <memmove>
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
8010222d:	e8 2e 32 00 00       	call   80105460 <strncpy>
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
8010226b:	68 96 90 10 80       	push   $0x80109096
80102270:	e8 1b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 f5 97 10 80       	push   $0x801097f5
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
80102371:	68 a3 90 10 80       	push   $0x801090a3
80102376:	56                   	push   %esi
80102377:	e8 14 30 00 00       	call   80105390 <memmove>
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
801023a4:	e8 97 11 00 00       	call   80103540 <begin_op>
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
801023d2:	68 ab 90 10 80       	push   $0x801090ab
801023d7:	53                   	push   %ebx
801023d8:	e8 23 30 00 00       	call   80105400 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	85 c0                	test   %eax,%eax
801023e2:	0f 84 f8 00 00 00    	je     801024e0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023e8:	83 ec 04             	sub    $0x4,%esp
801023eb:	6a 0e                	push   $0xe
801023ed:	68 aa 90 10 80       	push   $0x801090aa
801023f2:	53                   	push   %ebx
801023f3:	e8 08 30 00 00       	call   80105400 <strncmp>
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
80102447:	e8 94 2e 00 00       	call   801052e0 <memset>
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
8010249d:	e8 0e 11 00 00       	call   801035b0 <end_op>

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
801024b4:	e8 07 36 00 00       	call   80105ac0 <isdirempty>
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
801024f1:	e8 ba 10 00 00       	call   801035b0 <end_op>
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
8010252a:	e8 81 10 00 00       	call   801035b0 <end_op>
    return -1;
8010252f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102534:	e9 6e ff ff ff       	jmp    801024a7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102539:	83 ec 0c             	sub    $0xc,%esp
8010253c:	68 bf 90 10 80       	push   $0x801090bf
80102541:	e8 4a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	68 ad 90 10 80       	push   $0x801090ad
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
80102570:	68 a3 90 10 80       	push   $0x801090a3
80102575:	56                   	push   %esi
80102576:	e8 15 2e 00 00       	call   80105390 <memmove>
  itoa(p->pid, path+ 6);
8010257b:	58                   	pop    %eax
8010257c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010257f:	5a                   	pop    %edx
80102580:	50                   	push   %eax
80102581:	ff 73 10             	pushl  0x10(%ebx)
80102584:	e8 47 fd ff ff       	call   801022d0 <itoa>

    begin_op();
80102589:	e8 b2 0f 00 00       	call   80103540 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010258e:	6a 00                	push   $0x0
80102590:	6a 00                	push   $0x0
80102592:	6a 02                	push   $0x2
80102594:	56                   	push   %esi
80102595:	e8 36 37 00 00       	call   80105cd0 <create>
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
801025d8:	e8 d3 0f 00 00       	call   801035b0 <end_op>

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
801025e9:	68 ce 90 10 80       	push   $0x801090ce
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
8010271b:	68 48 91 10 80       	push   $0x80109148
80102720:	e8 6b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102725:	83 ec 0c             	sub    $0xc,%esp
80102728:	68 3f 91 10 80       	push   $0x8010913f
8010272d:	e8 5e dc ff ff       	call   80100390 <panic>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <ideinit>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102746:	68 5a 91 10 80       	push   $0x8010915a
8010274b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102750:	e8 3b 29 00 00       	call   80105090 <initlock>
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
801027ce:	e8 fd 29 00 00       	call   801051d0 <acquire>

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
80102831:	e8 8a 24 00 00       	call   80104cc0 <wakeup>

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
8010284f:	e8 3c 2a 00 00       	call   80105290 <release>

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
8010286e:	e8 cd 27 00 00       	call   80105040 <holdingsleep>
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
801028a8:	e8 23 29 00 00       	call   801051d0 <acquire>

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
801028f9:	e8 82 21 00 00       	call   80104a80 <sleep>
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
80102916:	e9 75 29 00 00       	jmp    80105290 <release>
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
8010293a:	68 74 91 10 80       	push   $0x80109174
8010293f:	e8 4c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 5e 91 10 80       	push   $0x8010915e
8010294c:	e8 3f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	68 89 91 10 80       	push   $0x80109189
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
801029a7:	68 a8 91 10 80       	push   $0x801091a8
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
80102a5f:	0f 85 9d 00 00 00    	jne    80102b02 <kfree+0xb2>
80102a65:	3d 88 75 19 80       	cmp    $0x80197588,%eax
80102a6a:	0f 82 92 00 00 00    	jb     80102b02 <kfree+0xb2>
80102a70:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102a76:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102a7c:	0f 87 80 00 00 00    	ja     80102b02 <kfree+0xb2>
  {
    panic("kfree");
  }

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a82:	83 ec 04             	sub    $0x4,%esp
80102a85:	68 00 10 00 00       	push   $0x1000
80102a8a:	6a 01                	push   $0x1
80102a8c:	50                   	push   %eax
80102a8d:	e8 4e 28 00 00       	call   801052e0 <memset>

  if(kmem.use_lock) 
80102a92:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102a97:	83 c4 10             	add    $0x10,%esp
80102a9a:	85 c0                	test   %eax,%eax
80102a9c:	75 52                	jne    80102af0 <kfree+0xa0>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102a9e:	c1 eb 0c             	shr    $0xc,%ebx
80102aa1:	8d 43 06             	lea    0x6(%ebx),%eax

  if(r->refcount != 0)
80102aa4:	8b 0c c5 30 5a 11 80 	mov    -0x7feea5d0(,%eax,8),%ecx
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102aab:	8d 14 c5 2c 5a 11 80 	lea    -0x7feea5d4(,%eax,8),%edx
  if(r->refcount != 0)
80102ab2:	85 c9                	test   %ecx,%ecx
80102ab4:	75 59                	jne    80102b0f <kfree+0xbf>
    panic("kfree: freeing a shared page");
  

  r->next = kmem.freelist;
80102ab6:	8b 0d 58 5a 11 80    	mov    0x80115a58,%ecx
  r->refcount = 0;
  kmem.freelist = r;
80102abc:	89 15 58 5a 11 80    	mov    %edx,0x80115a58
  r->next = kmem.freelist;
80102ac2:	89 0c c5 2c 5a 11 80 	mov    %ecx,-0x7feea5d4(,%eax,8)
  if(kmem.use_lock)
80102ac9:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102ace:	85 c0                	test   %eax,%eax
80102ad0:	75 0e                	jne    80102ae0 <kfree+0x90>
    release(&kmem.lock);
}
80102ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ad5:	c9                   	leave  
80102ad6:	c3                   	ret    
80102ad7:	89 f6                	mov    %esi,%esi
80102ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    release(&kmem.lock);
80102ae0:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102ae7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aea:	c9                   	leave  
    release(&kmem.lock);
80102aeb:	e9 a0 27 00 00       	jmp    80105290 <release>
    acquire(&kmem.lock);
80102af0:	83 ec 0c             	sub    $0xc,%esp
80102af3:	68 20 5a 11 80       	push   $0x80115a20
80102af8:	e8 d3 26 00 00       	call   801051d0 <acquire>
80102afd:	83 c4 10             	add    $0x10,%esp
80102b00:	eb 9c                	jmp    80102a9e <kfree+0x4e>
    panic("kfree");
80102b02:	83 ec 0c             	sub    $0xc,%esp
80102b05:	68 da 91 10 80       	push   $0x801091da
80102b0a:	e8 81 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b0f:	83 ec 0c             	sub    $0xc,%esp
80102b12:	68 e0 91 10 80       	push   $0x801091e0
80102b17:	e8 74 d8 ff ff       	call   80100390 <panic>
80102b1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b20 <kfree_nocheck>:

void
kfree_nocheck(char *v)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 04             	sub    $0x4,%esp
80102b27:	8b 45 08             	mov    0x8(%ebp),%eax
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b2a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80102b2f:	0f 85 bd 00 00 00    	jne    80102bf2 <kfree_nocheck+0xd2>
80102b35:	3d 88 75 19 80       	cmp    $0x80197588,%eax
80102b3a:	0f 82 b2 00 00 00    	jb     80102bf2 <kfree_nocheck+0xd2>
80102b40:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80102b46:	81 fb ff ff ff 0d    	cmp    $0xdffffff,%ebx
80102b4c:	0f 87 a0 00 00 00    	ja     80102bf2 <kfree_nocheck+0xd2>
    panic("kfree_nocheck");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b52:	83 ec 04             	sub    $0x4,%esp
80102b55:	68 00 10 00 00       	push   $0x1000
80102b5a:	6a 01                	push   $0x1
80102b5c:	50                   	push   %eax
80102b5d:	e8 7e 27 00 00       	call   801052e0 <memset>

  if(kmem.use_lock) 
80102b62:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102b68:	83 c4 10             	add    $0x10,%esp
80102b6b:	85 d2                	test   %edx,%edx
80102b6d:	75 31                	jne    80102ba0 <kfree_nocheck+0x80>
    acquire(&kmem.lock);
  
  
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page

  r->next = kmem.freelist;
80102b6f:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102b74:	c1 eb 0c             	shr    $0xc,%ebx
  r->next = kmem.freelist;
80102b77:	83 c3 06             	add    $0x6,%ebx
  r->refcount = 0;
80102b7a:	c7 04 dd 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%ebx,8)
80102b81:	00 00 00 00 
  r->next = kmem.freelist;
80102b85:	89 04 dd 2c 5a 11 80 	mov    %eax,-0x7feea5d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102b8c:	8d 04 dd 2c 5a 11 80 	lea    -0x7feea5d4(,%ebx,8),%eax
80102b93:	a3 58 5a 11 80       	mov    %eax,0x80115a58
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102b98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b9b:	c9                   	leave  
80102b9c:	c3                   	ret    
80102b9d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102ba0:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102ba3:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102ba6:	68 20 5a 11 80       	push   $0x80115a20
  r->next = kmem.freelist;
80102bab:	83 c3 06             	add    $0x6,%ebx
    acquire(&kmem.lock);
80102bae:	e8 1d 26 00 00       	call   801051d0 <acquire>
  r->next = kmem.freelist;
80102bb3:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(kmem.use_lock)
80102bb8:	83 c4 10             	add    $0x10,%esp
  r->refcount = 0;
80102bbb:	c7 04 dd 30 5a 11 80 	movl   $0x0,-0x7feea5d0(,%ebx,8)
80102bc2:	00 00 00 00 
  r->next = kmem.freelist;
80102bc6:	89 04 dd 2c 5a 11 80 	mov    %eax,-0x7feea5d4(,%ebx,8)
  r = &kmem.runs[(V2P(v) / PGSIZE)]; // get the page
80102bcd:	8d 04 dd 2c 5a 11 80 	lea    -0x7feea5d4(,%ebx,8),%eax
80102bd4:	a3 58 5a 11 80       	mov    %eax,0x80115a58
  if(kmem.use_lock)
80102bd9:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102bde:	85 c0                	test   %eax,%eax
80102be0:	74 b6                	je     80102b98 <kfree_nocheck+0x78>
    release(&kmem.lock);
80102be2:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102bec:	c9                   	leave  
    release(&kmem.lock);
80102bed:	e9 9e 26 00 00       	jmp    80105290 <release>
    panic("kfree_nocheck");
80102bf2:	83 ec 0c             	sub    $0xc,%esp
80102bf5:	68 fd 91 10 80       	push   $0x801091fd
80102bfa:	e8 91 d7 ff ff       	call   80100390 <panic>
80102bff:	90                   	nop

80102c00 <freerange>:
{
80102c00:	55                   	push   %ebp
80102c01:	89 e5                	mov    %esp,%ebp
80102c03:	56                   	push   %esi
80102c04:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102c05:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102c08:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102c0b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c11:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c1d:	39 de                	cmp    %ebx,%esi
80102c1f:	72 23                	jb     80102c44 <freerange+0x44>
80102c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102c28:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c2e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102c37:	50                   	push   %eax
80102c38:	e8 e3 fe ff ff       	call   80102b20 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c3d:	83 c4 10             	add    $0x10,%esp
80102c40:	39 f3                	cmp    %esi,%ebx
80102c42:	76 e4                	jbe    80102c28 <freerange+0x28>
}
80102c44:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c47:	5b                   	pop    %ebx
80102c48:	5e                   	pop    %esi
80102c49:	5d                   	pop    %ebp
80102c4a:	c3                   	ret    
80102c4b:	90                   	nop
80102c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c50 <kinit1>:
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	56                   	push   %esi
80102c54:	53                   	push   %ebx
80102c55:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102c58:	83 ec 08             	sub    $0x8,%esp
80102c5b:	68 0b 92 10 80       	push   $0x8010920b
80102c60:	68 20 5a 11 80       	push   $0x80115a20
80102c65:	e8 26 24 00 00       	call   80105090 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
80102c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c6d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102c70:	c7 05 54 5a 11 80 00 	movl   $0x0,0x80115a54
80102c77:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
80102c7a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102c80:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c86:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102c8c:	39 de                	cmp    %ebx,%esi
80102c8e:	72 1c                	jb     80102cac <kinit1+0x5c>
    kfree_nocheck(p);
80102c90:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102c96:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c99:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102c9f:	50                   	push   %eax
80102ca0:	e8 7b fe ff ff       	call   80102b20 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ca5:	83 c4 10             	add    $0x10,%esp
80102ca8:	39 de                	cmp    %ebx,%esi
80102caa:	73 e4                	jae    80102c90 <kinit1+0x40>
}
80102cac:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102caf:	5b                   	pop    %ebx
80102cb0:	5e                   	pop    %esi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
80102cb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <kinit2>:
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	56                   	push   %esi
80102cc4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102cc5:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102cc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102ccb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102cd1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cd7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102cdd:	39 de                	cmp    %ebx,%esi
80102cdf:	72 23                	jb     80102d04 <kinit2+0x44>
80102ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree_nocheck(p);
80102ce8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102cee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cf1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree_nocheck(p);
80102cf7:	50                   	push   %eax
80102cf8:	e8 23 fe ff ff       	call   80102b20 <kfree_nocheck>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102cfd:	83 c4 10             	add    $0x10,%esp
80102d00:	39 de                	cmp    %ebx,%esi
80102d02:	73 e4                	jae    80102ce8 <kinit2+0x28>
  kmem.use_lock = 1;
80102d04:	c7 05 54 5a 11 80 01 	movl   $0x1,0x80115a54
80102d0b:	00 00 00 
}
80102d0e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102d11:	5b                   	pop    %ebx
80102d12:	5e                   	pop    %esi
80102d13:	5d                   	pop    %ebp
80102d14:	c3                   	ret    
80102d15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d20:	55                   	push   %ebp
80102d21:	89 e5                	mov    %esp,%ebp
80102d23:	83 ec 18             	sub    $0x18,%esp
  struct run *r;
  char *rv;

  if(kmem.use_lock)
80102d26:	a1 54 5a 11 80       	mov    0x80115a54,%eax
80102d2b:	85 c0                	test   %eax,%eax
80102d2d:	75 59                	jne    80102d88 <kalloc+0x68>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102d2f:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(r)
80102d34:	85 c0                	test   %eax,%eax
80102d36:	74 73                	je     80102dab <kalloc+0x8b>
  {
    kmem.freelist = r->next;
80102d38:	8b 10                	mov    (%eax),%edx
80102d3a:	89 15 58 5a 11 80    	mov    %edx,0x80115a58
    r->refcount = 1;
80102d40:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  if(kmem.use_lock)
80102d47:	8b 0d 54 5a 11 80    	mov    0x80115a54,%ecx
80102d4d:	85 c9                	test   %ecx,%ecx
80102d4f:	75 0f                	jne    80102d60 <kalloc+0x40>
    release(&kmem.lock);
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d51:	2d 5c 5a 11 80       	sub    $0x80115a5c,%eax
80102d56:	c1 e0 09             	shl    $0x9,%eax
80102d59:	05 00 00 00 80       	add    $0x80000000,%eax
  return rv;
}
80102d5e:	c9                   	leave  
80102d5f:	c3                   	ret    
    release(&kmem.lock);
80102d60:	83 ec 0c             	sub    $0xc,%esp
80102d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d66:	68 20 5a 11 80       	push   $0x80115a20
80102d6b:	e8 20 25 00 00       	call   80105290 <release>
80102d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d73:	83 c4 10             	add    $0x10,%esp
  rv = r ? P2V((r - kmem.runs) * PGSIZE) : r;
80102d76:	2d 5c 5a 11 80       	sub    $0x80115a5c,%eax
80102d7b:	c1 e0 09             	shl    $0x9,%eax
80102d7e:	05 00 00 00 80       	add    $0x80000000,%eax
80102d83:	eb d9                	jmp    80102d5e <kalloc+0x3e>
80102d85:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102d88:	83 ec 0c             	sub    $0xc,%esp
80102d8b:	68 20 5a 11 80       	push   $0x80115a20
80102d90:	e8 3b 24 00 00       	call   801051d0 <acquire>
  r = kmem.freelist;
80102d95:	a1 58 5a 11 80       	mov    0x80115a58,%eax
  if(r)
80102d9a:	83 c4 10             	add    $0x10,%esp
80102d9d:	85 c0                	test   %eax,%eax
80102d9f:	75 97                	jne    80102d38 <kalloc+0x18>
  if(kmem.use_lock)
80102da1:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
80102da7:	85 d2                	test   %edx,%edx
80102da9:	75 05                	jne    80102db0 <kalloc+0x90>
{
80102dab:	31 c0                	xor    %eax,%eax
}
80102dad:	c9                   	leave  
80102dae:	c3                   	ret    
80102daf:	90                   	nop
    release(&kmem.lock);
80102db0:	83 ec 0c             	sub    $0xc,%esp
80102db3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102db6:	68 20 5a 11 80       	push   $0x80115a20
80102dbb:	e8 d0 24 00 00       	call   80105290 <release>
80102dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dc3:	83 c4 10             	add    $0x10,%esp
}
80102dc6:	c9                   	leave  
80102dc7:	c3                   	ret    
80102dc8:	90                   	nop
80102dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102dd0 <refDec>:

void
refDec(char *v)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102dd7:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
{
80102ddd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102de0:	85 d2                	test   %edx,%edx
80102de2:	75 1c                	jne    80102e00 <refDec+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102de4:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102dea:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount -= 1;
80102ded:	83 2c c5 60 5a 11 80 	subl   $0x1,-0x7feea5a0(,%eax,8)
80102df4:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102df5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102df8:	c9                   	leave  
80102df9:	c3                   	ret    
80102dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e00:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e03:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e09:	68 20 5a 11 80       	push   $0x80115a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e0e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e11:	e8 ba 23 00 00       	call   801051d0 <acquire>
  if(kmem.use_lock)
80102e16:	a1 54 5a 11 80       	mov    0x80115a54,%eax
  r->refcount -= 1;
80102e1b:	83 2c dd 60 5a 11 80 	subl   $0x1,-0x7feea5a0(,%ebx,8)
80102e22:	01 
  if(kmem.use_lock)
80102e23:	83 c4 10             	add    $0x10,%esp
80102e26:	85 c0                	test   %eax,%eax
80102e28:	74 cb                	je     80102df5 <refDec+0x25>
    release(&kmem.lock);
80102e2a:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102e31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e34:	c9                   	leave  
    release(&kmem.lock);
80102e35:	e9 56 24 00 00       	jmp    80105290 <release>
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e40 <refInc>:

void
refInc(char *v)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	53                   	push   %ebx
80102e44:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102e47:	8b 15 54 5a 11 80    	mov    0x80115a54,%edx
{
80102e4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(kmem.use_lock)
80102e50:	85 d2                	test   %edx,%edx
80102e52:	75 1c                	jne    80102e70 <refInc+0x30>
    acquire(&kmem.lock);
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e54:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102e5a:	c1 e8 0c             	shr    $0xc,%eax
  r->refcount += 1;
80102e5d:	83 04 c5 60 5a 11 80 	addl   $0x1,-0x7feea5a0(,%eax,8)
80102e64:	01 
  if(kmem.use_lock)
    release(&kmem.lock);
}
80102e65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e68:	c9                   	leave  
80102e69:	c3                   	ret    
80102e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102e70:	83 ec 0c             	sub    $0xc,%esp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e73:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    acquire(&kmem.lock);
80102e79:	68 20 5a 11 80       	push   $0x80115a20
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102e7e:	c1 eb 0c             	shr    $0xc,%ebx
    acquire(&kmem.lock);
80102e81:	e8 4a 23 00 00       	call   801051d0 <acquire>
  if(kmem.use_lock)
80102e86:	a1 54 5a 11 80       	mov    0x80115a54,%eax
  r->refcount += 1;
80102e8b:	83 04 dd 60 5a 11 80 	addl   $0x1,-0x7feea5a0(,%ebx,8)
80102e92:	01 
  if(kmem.use_lock)
80102e93:	83 c4 10             	add    $0x10,%esp
80102e96:	85 c0                	test   %eax,%eax
80102e98:	74 cb                	je     80102e65 <refInc+0x25>
    release(&kmem.lock);
80102e9a:	c7 45 08 20 5a 11 80 	movl   $0x80115a20,0x8(%ebp)
}
80102ea1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ea4:	c9                   	leave  
    release(&kmem.lock);
80102ea5:	e9 e6 23 00 00       	jmp    80105290 <release>
80102eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102eb0 <getRefs>:

int
getRefs(char *v)
{
80102eb0:	55                   	push   %ebp
80102eb1:	89 e5                	mov    %esp,%ebp
  struct run *r;

  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  return r->refcount;
80102eb6:	5d                   	pop    %ebp
  r = &kmem.runs[(V2P(v) / PGSIZE)];
80102eb7:	05 00 00 00 80       	add    $0x80000000,%eax
80102ebc:	c1 e8 0c             	shr    $0xc,%eax
  return r->refcount;
80102ebf:	8b 04 c5 60 5a 11 80 	mov    -0x7feea5a0(,%eax,8),%eax
80102ec6:	c3                   	ret    
80102ec7:	66 90                	xchg   %ax,%ax
80102ec9:	66 90                	xchg   %ax,%ax
80102ecb:	66 90                	xchg   %ax,%ax
80102ecd:	66 90                	xchg   %ax,%ax
80102ecf:	90                   	nop

80102ed0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ed0:	ba 64 00 00 00       	mov    $0x64,%edx
80102ed5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102ed6:	a8 01                	test   $0x1,%al
80102ed8:	0f 84 c2 00 00 00    	je     80102fa0 <kbdgetc+0xd0>
80102ede:	ba 60 00 00 00       	mov    $0x60,%edx
80102ee3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102ee4:	0f b6 d0             	movzbl %al,%edx
80102ee7:	8b 0d d4 c5 10 80    	mov    0x8010c5d4,%ecx

  if(data == 0xE0){
80102eed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102ef3:	0f 84 7f 00 00 00    	je     80102f78 <kbdgetc+0xa8>
{
80102ef9:	55                   	push   %ebp
80102efa:	89 e5                	mov    %esp,%ebp
80102efc:	53                   	push   %ebx
80102efd:	89 cb                	mov    %ecx,%ebx
80102eff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102f02:	84 c0                	test   %al,%al
80102f04:	78 4a                	js     80102f50 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102f06:	85 db                	test   %ebx,%ebx
80102f08:	74 09                	je     80102f13 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102f0a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102f0d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102f10:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102f13:	0f b6 82 40 93 10 80 	movzbl -0x7fef6cc0(%edx),%eax
80102f1a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f1c:	0f b6 82 40 92 10 80 	movzbl -0x7fef6dc0(%edx),%eax
80102f23:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f25:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102f27:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
  c = charcode[shift & (CTL | SHIFT)][data];
80102f2d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102f30:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102f33:	8b 04 85 20 92 10 80 	mov    -0x7fef6de0(,%eax,4),%eax
80102f3a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102f3e:	74 31                	je     80102f71 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102f40:	8d 50 9f             	lea    -0x61(%eax),%edx
80102f43:	83 fa 19             	cmp    $0x19,%edx
80102f46:	77 40                	ja     80102f88 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102f48:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102f4b:	5b                   	pop    %ebx
80102f4c:	5d                   	pop    %ebp
80102f4d:	c3                   	ret    
80102f4e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102f50:	83 e0 7f             	and    $0x7f,%eax
80102f53:	85 db                	test   %ebx,%ebx
80102f55:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102f58:	0f b6 82 40 93 10 80 	movzbl -0x7fef6cc0(%edx),%eax
80102f5f:	83 c8 40             	or     $0x40,%eax
80102f62:	0f b6 c0             	movzbl %al,%eax
80102f65:	f7 d0                	not    %eax
80102f67:	21 c1                	and    %eax,%ecx
    return 0;
80102f69:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102f6b:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
}
80102f71:	5b                   	pop    %ebx
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret    
80102f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102f78:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102f7b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102f7d:	89 0d d4 c5 10 80    	mov    %ecx,0x8010c5d4
    return 0;
80102f83:	c3                   	ret    
80102f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102f88:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102f8b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102f8e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102f8f:	83 f9 1a             	cmp    $0x1a,%ecx
80102f92:	0f 42 c2             	cmovb  %edx,%eax
}
80102f95:	5d                   	pop    %ebp
80102f96:	c3                   	ret    
80102f97:	89 f6                	mov    %esi,%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102fa5:	c3                   	ret    
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <kbdintr>:

void
kbdintr(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102fb6:	68 d0 2e 10 80       	push   $0x80102ed0
80102fbb:	e8 50 d8 ff ff       	call   80100810 <consoleintr>
}
80102fc0:	83 c4 10             	add    $0x10,%esp
80102fc3:	c9                   	leave  
80102fc4:	c3                   	ret    
80102fc5:	66 90                	xchg   %ax,%ax
80102fc7:	66 90                	xchg   %ax,%ax
80102fc9:	66 90                	xchg   %ax,%ax
80102fcb:	66 90                	xchg   %ax,%ax
80102fcd:	66 90                	xchg   %ax,%ax
80102fcf:	90                   	nop

80102fd0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102fd0:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
{
80102fd5:	55                   	push   %ebp
80102fd6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102fd8:	85 c0                	test   %eax,%eax
80102fda:	0f 84 c8 00 00 00    	je     801030a8 <lapicinit+0xd8>
  lapic[index] = value;
80102fe0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102fe7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102fed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ff4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ff7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ffa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103001:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103004:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103007:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010300e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103011:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103014:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010301b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010301e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103021:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103028:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010302b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010302e:	8b 50 30             	mov    0x30(%eax),%edx
80103031:	c1 ea 10             	shr    $0x10,%edx
80103034:	80 fa 03             	cmp    $0x3,%dl
80103037:	77 77                	ja     801030b0 <lapicinit+0xe0>
  lapic[index] = value;
80103039:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80103040:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103043:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103046:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010304d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103050:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103053:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010305a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010305d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103060:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103067:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010306a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010306d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80103074:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103077:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010307a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80103081:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80103084:	8b 50 20             	mov    0x20(%eax),%edx
80103087:	89 f6                	mov    %esi,%esi
80103089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103090:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103096:	80 e6 10             	and    $0x10,%dh
80103099:	75 f5                	jne    80103090 <lapicinit+0xc0>
  lapic[index] = value;
8010309b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801030a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801030a5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801030a8:	5d                   	pop    %ebp
801030a9:	c3                   	ret    
801030aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801030b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801030b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801030ba:	8b 50 20             	mov    0x20(%eax),%edx
801030bd:	e9 77 ff ff ff       	jmp    80103039 <lapicinit+0x69>
801030c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030d0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801030d0:	8b 15 5c 5a 18 80    	mov    0x80185a5c,%edx
{
801030d6:	55                   	push   %ebp
801030d7:	31 c0                	xor    %eax,%eax
801030d9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801030db:	85 d2                	test   %edx,%edx
801030dd:	74 06                	je     801030e5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801030df:	8b 42 20             	mov    0x20(%edx),%eax
801030e2:	c1 e8 18             	shr    $0x18,%eax
}
801030e5:	5d                   	pop    %ebp
801030e6:	c3                   	ret    
801030e7:	89 f6                	mov    %esi,%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030f0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801030f0:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
{
801030f5:	55                   	push   %ebp
801030f6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030f8:	85 c0                	test   %eax,%eax
801030fa:	74 0d                	je     80103109 <lapiceoi+0x19>
  lapic[index] = value;
801030fc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103103:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103106:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80103109:	5d                   	pop    %ebp
8010310a:	c3                   	ret    
8010310b:	90                   	nop
8010310c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103110 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
}
80103113:	5d                   	pop    %ebp
80103114:	c3                   	ret    
80103115:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103120 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103120:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103121:	b8 0f 00 00 00       	mov    $0xf,%eax
80103126:	ba 70 00 00 00       	mov    $0x70,%edx
8010312b:	89 e5                	mov    %esp,%ebp
8010312d:	53                   	push   %ebx
8010312e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103131:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103134:	ee                   	out    %al,(%dx)
80103135:	b8 0a 00 00 00       	mov    $0xa,%eax
8010313a:	ba 71 00 00 00       	mov    $0x71,%edx
8010313f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80103140:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103142:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80103145:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010314b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010314d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103150:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103153:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103155:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103158:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010315e:	a1 5c 5a 18 80       	mov    0x80185a5c,%eax
80103163:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103169:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010316c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103173:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103176:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103179:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103180:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103183:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103186:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010318c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010318f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103195:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103198:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010319e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801031a1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801031a7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801031aa:	5b                   	pop    %ebx
801031ab:	5d                   	pop    %ebp
801031ac:	c3                   	ret    
801031ad:	8d 76 00             	lea    0x0(%esi),%esi

801031b0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801031b0:	55                   	push   %ebp
801031b1:	b8 0b 00 00 00       	mov    $0xb,%eax
801031b6:	ba 70 00 00 00       	mov    $0x70,%edx
801031bb:	89 e5                	mov    %esp,%ebp
801031bd:	57                   	push   %edi
801031be:	56                   	push   %esi
801031bf:	53                   	push   %ebx
801031c0:	83 ec 4c             	sub    $0x4c,%esp
801031c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031c4:	ba 71 00 00 00       	mov    $0x71,%edx
801031c9:	ec                   	in     (%dx),%al
801031ca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031cd:	bb 70 00 00 00       	mov    $0x70,%ebx
801031d2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801031d5:	8d 76 00             	lea    0x0(%esi),%esi
801031d8:	31 c0                	xor    %eax,%eax
801031da:	89 da                	mov    %ebx,%edx
801031dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031dd:	b9 71 00 00 00       	mov    $0x71,%ecx
801031e2:	89 ca                	mov    %ecx,%edx
801031e4:	ec                   	in     (%dx),%al
801031e5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031e8:	89 da                	mov    %ebx,%edx
801031ea:	b8 02 00 00 00       	mov    $0x2,%eax
801031ef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031f0:	89 ca                	mov    %ecx,%edx
801031f2:	ec                   	in     (%dx),%al
801031f3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f6:	89 da                	mov    %ebx,%edx
801031f8:	b8 04 00 00 00       	mov    $0x4,%eax
801031fd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031fe:	89 ca                	mov    %ecx,%edx
80103200:	ec                   	in     (%dx),%al
80103201:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103204:	89 da                	mov    %ebx,%edx
80103206:	b8 07 00 00 00       	mov    $0x7,%eax
8010320b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010320c:	89 ca                	mov    %ecx,%edx
8010320e:	ec                   	in     (%dx),%al
8010320f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103212:	89 da                	mov    %ebx,%edx
80103214:	b8 08 00 00 00       	mov    $0x8,%eax
80103219:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010321a:	89 ca                	mov    %ecx,%edx
8010321c:	ec                   	in     (%dx),%al
8010321d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010321f:	89 da                	mov    %ebx,%edx
80103221:	b8 09 00 00 00       	mov    $0x9,%eax
80103226:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103227:	89 ca                	mov    %ecx,%edx
80103229:	ec                   	in     (%dx),%al
8010322a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010322c:	89 da                	mov    %ebx,%edx
8010322e:	b8 0a 00 00 00       	mov    $0xa,%eax
80103233:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103234:	89 ca                	mov    %ecx,%edx
80103236:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103237:	84 c0                	test   %al,%al
80103239:	78 9d                	js     801031d8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010323b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010323f:	89 fa                	mov    %edi,%edx
80103241:	0f b6 fa             	movzbl %dl,%edi
80103244:	89 f2                	mov    %esi,%edx
80103246:	0f b6 f2             	movzbl %dl,%esi
80103249:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010324c:	89 da                	mov    %ebx,%edx
8010324e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103251:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103254:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103258:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010325b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010325f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103262:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103266:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103269:	31 c0                	xor    %eax,%eax
8010326b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010326c:	89 ca                	mov    %ecx,%edx
8010326e:	ec                   	in     (%dx),%al
8010326f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103272:	89 da                	mov    %ebx,%edx
80103274:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103277:	b8 02 00 00 00       	mov    $0x2,%eax
8010327c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010327d:	89 ca                	mov    %ecx,%edx
8010327f:	ec                   	in     (%dx),%al
80103280:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103283:	89 da                	mov    %ebx,%edx
80103285:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103288:	b8 04 00 00 00       	mov    $0x4,%eax
8010328d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010328e:	89 ca                	mov    %ecx,%edx
80103290:	ec                   	in     (%dx),%al
80103291:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103294:	89 da                	mov    %ebx,%edx
80103296:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103299:	b8 07 00 00 00       	mov    $0x7,%eax
8010329e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010329f:	89 ca                	mov    %ecx,%edx
801032a1:	ec                   	in     (%dx),%al
801032a2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a5:	89 da                	mov    %ebx,%edx
801032a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801032aa:	b8 08 00 00 00       	mov    $0x8,%eax
801032af:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032b0:	89 ca                	mov    %ecx,%edx
801032b2:	ec                   	in     (%dx),%al
801032b3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b6:	89 da                	mov    %ebx,%edx
801032b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801032bb:	b8 09 00 00 00       	mov    $0x9,%eax
801032c0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032c1:	89 ca                	mov    %ecx,%edx
801032c3:	ec                   	in     (%dx),%al
801032c4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032c7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801032ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801032cd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801032d0:	6a 18                	push   $0x18
801032d2:	50                   	push   %eax
801032d3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801032d6:	50                   	push   %eax
801032d7:	e8 54 20 00 00       	call   80105330 <memcmp>
801032dc:	83 c4 10             	add    $0x10,%esp
801032df:	85 c0                	test   %eax,%eax
801032e1:	0f 85 f1 fe ff ff    	jne    801031d8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801032e7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801032eb:	75 78                	jne    80103365 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032ed:	8b 45 b8             	mov    -0x48(%ebp),%eax
801032f0:	89 c2                	mov    %eax,%edx
801032f2:	83 e0 0f             	and    $0xf,%eax
801032f5:	c1 ea 04             	shr    $0x4,%edx
801032f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801032fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801032fe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103301:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103304:	89 c2                	mov    %eax,%edx
80103306:	83 e0 0f             	and    $0xf,%eax
80103309:	c1 ea 04             	shr    $0x4,%edx
8010330c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010330f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103312:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80103315:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103318:	89 c2                	mov    %eax,%edx
8010331a:	83 e0 0f             	and    $0xf,%eax
8010331d:	c1 ea 04             	shr    $0x4,%edx
80103320:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103323:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103326:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80103329:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010332c:	89 c2                	mov    %eax,%edx
8010332e:	83 e0 0f             	and    $0xf,%eax
80103331:	c1 ea 04             	shr    $0x4,%edx
80103334:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103337:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010333a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010333d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103340:	89 c2                	mov    %eax,%edx
80103342:	83 e0 0f             	and    $0xf,%eax
80103345:	c1 ea 04             	shr    $0x4,%edx
80103348:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010334b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010334e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103351:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103354:	89 c2                	mov    %eax,%edx
80103356:	83 e0 0f             	and    $0xf,%eax
80103359:	c1 ea 04             	shr    $0x4,%edx
8010335c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010335f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103362:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103365:	8b 75 08             	mov    0x8(%ebp),%esi
80103368:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010336b:	89 06                	mov    %eax,(%esi)
8010336d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103370:	89 46 04             	mov    %eax,0x4(%esi)
80103373:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103376:	89 46 08             	mov    %eax,0x8(%esi)
80103379:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010337c:	89 46 0c             	mov    %eax,0xc(%esi)
8010337f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103382:	89 46 10             	mov    %eax,0x10(%esi)
80103385:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103388:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010338b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103392:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103395:	5b                   	pop    %ebx
80103396:	5e                   	pop    %esi
80103397:	5f                   	pop    %edi
80103398:	5d                   	pop    %ebp
80103399:	c3                   	ret    
8010339a:	66 90                	xchg   %ax,%ax
8010339c:	66 90                	xchg   %ax,%ax
8010339e:	66 90                	xchg   %ax,%ax

801033a0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033a0:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
801033a6:	85 c9                	test   %ecx,%ecx
801033a8:	0f 8e 8a 00 00 00    	jle    80103438 <install_trans+0x98>
{
801033ae:	55                   	push   %ebp
801033af:	89 e5                	mov    %esp,%ebp
801033b1:	57                   	push   %edi
801033b2:	56                   	push   %esi
801033b3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
801033b4:	31 db                	xor    %ebx,%ebx
{
801033b6:	83 ec 0c             	sub    $0xc,%esp
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033c0:	a1 94 5a 18 80       	mov    0x80185a94,%eax
801033c5:	83 ec 08             	sub    $0x8,%esp
801033c8:	01 d8                	add    %ebx,%eax
801033ca:	83 c0 01             	add    $0x1,%eax
801033cd:	50                   	push   %eax
801033ce:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
801033d4:	e8 f7 cc ff ff       	call   801000d0 <bread>
801033d9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033db:	58                   	pop    %eax
801033dc:	5a                   	pop    %edx
801033dd:	ff 34 9d ac 5a 18 80 	pushl  -0x7fe7a554(,%ebx,4)
801033e4:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
  for (tail = 0; tail < log.lh.n; tail++) {
801033ea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033ed:	e8 de cc ff ff       	call   801000d0 <bread>
801033f2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033f4:	8d 47 5c             	lea    0x5c(%edi),%eax
801033f7:	83 c4 0c             	add    $0xc,%esp
801033fa:	68 00 02 00 00       	push   $0x200
801033ff:	50                   	push   %eax
80103400:	8d 46 5c             	lea    0x5c(%esi),%eax
80103403:	50                   	push   %eax
80103404:	e8 87 1f 00 00       	call   80105390 <memmove>
    bwrite(dbuf);  // write dst to disk
80103409:	89 34 24             	mov    %esi,(%esp)
8010340c:	e8 8f cd ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80103411:	89 3c 24             	mov    %edi,(%esp)
80103414:	e8 c7 cd ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80103419:	89 34 24             	mov    %esi,(%esp)
8010341c:	e8 bf cd ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103421:	83 c4 10             	add    $0x10,%esp
80103424:	39 1d a8 5a 18 80    	cmp    %ebx,0x80185aa8
8010342a:	7f 94                	jg     801033c0 <install_trans+0x20>
  }
}
8010342c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010342f:	5b                   	pop    %ebx
80103430:	5e                   	pop    %esi
80103431:	5f                   	pop    %edi
80103432:	5d                   	pop    %ebp
80103433:	c3                   	ret    
80103434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103438:	f3 c3                	repz ret 
8010343a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103440 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	56                   	push   %esi
80103444:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80103445:	83 ec 08             	sub    $0x8,%esp
80103448:	ff 35 94 5a 18 80    	pushl  0x80185a94
8010344e:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
80103454:	e8 77 cc ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103459:	8b 1d a8 5a 18 80    	mov    0x80185aa8,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010345f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103462:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103464:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103466:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103469:	7e 16                	jle    80103481 <write_head+0x41>
8010346b:	c1 e3 02             	shl    $0x2,%ebx
8010346e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103470:	8b 8a ac 5a 18 80    	mov    -0x7fe7a554(%edx),%ecx
80103476:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010347a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010347d:	39 da                	cmp    %ebx,%edx
8010347f:	75 ef                	jne    80103470 <write_head+0x30>
  }
  bwrite(buf);
80103481:	83 ec 0c             	sub    $0xc,%esp
80103484:	56                   	push   %esi
80103485:	e8 16 cd ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010348a:	89 34 24             	mov    %esi,(%esp)
8010348d:	e8 4e cd ff ff       	call   801001e0 <brelse>
}
80103492:	83 c4 10             	add    $0x10,%esp
80103495:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103498:	5b                   	pop    %ebx
80103499:	5e                   	pop    %esi
8010349a:	5d                   	pop    %ebp
8010349b:	c3                   	ret    
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801034a0 <initlog>:
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	53                   	push   %ebx
801034a4:	83 ec 2c             	sub    $0x2c,%esp
801034a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801034aa:	68 40 94 10 80       	push   $0x80109440
801034af:	68 60 5a 18 80       	push   $0x80185a60
801034b4:	e8 d7 1b 00 00       	call   80105090 <initlock>
  readsb(dev, &sb);
801034b9:	58                   	pop    %eax
801034ba:	8d 45 dc             	lea    -0x24(%ebp),%eax
801034bd:	5a                   	pop    %edx
801034be:	50                   	push   %eax
801034bf:	53                   	push   %ebx
801034c0:	e8 2b e3 ff ff       	call   801017f0 <readsb>
  log.size = sb.nlog;
801034c5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
801034c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
801034cb:	59                   	pop    %ecx
  log.dev = dev;
801034cc:	89 1d a4 5a 18 80    	mov    %ebx,0x80185aa4
  log.size = sb.nlog;
801034d2:	89 15 98 5a 18 80    	mov    %edx,0x80185a98
  log.start = sb.logstart;
801034d8:	a3 94 5a 18 80       	mov    %eax,0x80185a94
  struct buf *buf = bread(log.dev, log.start);
801034dd:	5a                   	pop    %edx
801034de:	50                   	push   %eax
801034df:	53                   	push   %ebx
801034e0:	e8 eb cb ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
801034e5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
801034e8:	83 c4 10             	add    $0x10,%esp
801034eb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
801034ed:	89 1d a8 5a 18 80    	mov    %ebx,0x80185aa8
  for (i = 0; i < log.lh.n; i++) {
801034f3:	7e 1c                	jle    80103511 <initlog+0x71>
801034f5:	c1 e3 02             	shl    $0x2,%ebx
801034f8:	31 d2                	xor    %edx,%edx
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80103500:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80103504:	83 c2 04             	add    $0x4,%edx
80103507:	89 8a a8 5a 18 80    	mov    %ecx,-0x7fe7a558(%edx)
  for (i = 0; i < log.lh.n; i++) {
8010350d:	39 d3                	cmp    %edx,%ebx
8010350f:	75 ef                	jne    80103500 <initlog+0x60>
  brelse(buf);
80103511:	83 ec 0c             	sub    $0xc,%esp
80103514:	50                   	push   %eax
80103515:	e8 c6 cc ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010351a:	e8 81 fe ff ff       	call   801033a0 <install_trans>
  log.lh.n = 0;
8010351f:	c7 05 a8 5a 18 80 00 	movl   $0x0,0x80185aa8
80103526:	00 00 00 
  write_head(); // clear the log
80103529:	e8 12 ff ff ff       	call   80103440 <write_head>
}
8010352e:	83 c4 10             	add    $0x10,%esp
80103531:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103534:	c9                   	leave  
80103535:	c3                   	ret    
80103536:	8d 76 00             	lea    0x0(%esi),%esi
80103539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103540 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103546:	68 60 5a 18 80       	push   $0x80185a60
8010354b:	e8 80 1c 00 00       	call   801051d0 <acquire>
80103550:	83 c4 10             	add    $0x10,%esp
80103553:	eb 18                	jmp    8010356d <begin_op+0x2d>
80103555:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103558:	83 ec 08             	sub    $0x8,%esp
8010355b:	68 60 5a 18 80       	push   $0x80185a60
80103560:	68 60 5a 18 80       	push   $0x80185a60
80103565:	e8 16 15 00 00       	call   80104a80 <sleep>
8010356a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010356d:	a1 a0 5a 18 80       	mov    0x80185aa0,%eax
80103572:	85 c0                	test   %eax,%eax
80103574:	75 e2                	jne    80103558 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103576:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
8010357b:	8b 15 a8 5a 18 80    	mov    0x80185aa8,%edx
80103581:	83 c0 01             	add    $0x1,%eax
80103584:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103587:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010358a:	83 fa 1e             	cmp    $0x1e,%edx
8010358d:	7f c9                	jg     80103558 <begin_op+0x18>
      // cprintf("before sleep\n");
      sleep(&log, &log.lock); // deadlock
      // cprintf("after sleep\n");
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010358f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103592:	a3 9c 5a 18 80       	mov    %eax,0x80185a9c
      release(&log.lock);
80103597:	68 60 5a 18 80       	push   $0x80185a60
8010359c:	e8 ef 1c 00 00       	call   80105290 <release>
      break;
    }
  }
}
801035a1:	83 c4 10             	add    $0x10,%esp
801035a4:	c9                   	leave  
801035a5:	c3                   	ret    
801035a6:	8d 76 00             	lea    0x0(%esi),%esi
801035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035b0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
801035b9:	68 60 5a 18 80       	push   $0x80185a60
801035be:	e8 0d 1c 00 00       	call   801051d0 <acquire>
  log.outstanding -= 1;
801035c3:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
  if(log.committing)
801035c8:	8b 35 a0 5a 18 80    	mov    0x80185aa0,%esi
801035ce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801035d1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
801035d4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
801035d6:	89 1d 9c 5a 18 80    	mov    %ebx,0x80185a9c
  if(log.committing)
801035dc:	0f 85 1a 01 00 00    	jne    801036fc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801035e2:	85 db                	test   %ebx,%ebx
801035e4:	0f 85 ee 00 00 00    	jne    801036d8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801035ea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801035ed:	c7 05 a0 5a 18 80 01 	movl   $0x1,0x80185aa0
801035f4:	00 00 00 
  release(&log.lock);
801035f7:	68 60 5a 18 80       	push   $0x80185a60
801035fc:	e8 8f 1c 00 00       	call   80105290 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103601:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
80103607:	83 c4 10             	add    $0x10,%esp
8010360a:	85 c9                	test   %ecx,%ecx
8010360c:	0f 8e 85 00 00 00    	jle    80103697 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103612:	a1 94 5a 18 80       	mov    0x80185a94,%eax
80103617:	83 ec 08             	sub    $0x8,%esp
8010361a:	01 d8                	add    %ebx,%eax
8010361c:	83 c0 01             	add    $0x1,%eax
8010361f:	50                   	push   %eax
80103620:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
80103626:	e8 a5 ca ff ff       	call   801000d0 <bread>
8010362b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010362d:	58                   	pop    %eax
8010362e:	5a                   	pop    %edx
8010362f:	ff 34 9d ac 5a 18 80 	pushl  -0x7fe7a554(,%ebx,4)
80103636:	ff 35 a4 5a 18 80    	pushl  0x80185aa4
  for (tail = 0; tail < log.lh.n; tail++) {
8010363c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010363f:	e8 8c ca ff ff       	call   801000d0 <bread>
80103644:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103646:	8d 40 5c             	lea    0x5c(%eax),%eax
80103649:	83 c4 0c             	add    $0xc,%esp
8010364c:	68 00 02 00 00       	push   $0x200
80103651:	50                   	push   %eax
80103652:	8d 46 5c             	lea    0x5c(%esi),%eax
80103655:	50                   	push   %eax
80103656:	e8 35 1d 00 00       	call   80105390 <memmove>
    bwrite(to);  // write the log
8010365b:	89 34 24             	mov    %esi,(%esp)
8010365e:	e8 3d cb ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103663:	89 3c 24             	mov    %edi,(%esp)
80103666:	e8 75 cb ff ff       	call   801001e0 <brelse>
    brelse(to);
8010366b:	89 34 24             	mov    %esi,(%esp)
8010366e:	e8 6d cb ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103673:	83 c4 10             	add    $0x10,%esp
80103676:	3b 1d a8 5a 18 80    	cmp    0x80185aa8,%ebx
8010367c:	7c 94                	jl     80103612 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010367e:	e8 bd fd ff ff       	call   80103440 <write_head>
    install_trans(); // Now install writes to home locations
80103683:	e8 18 fd ff ff       	call   801033a0 <install_trans>
    log.lh.n = 0;
80103688:	c7 05 a8 5a 18 80 00 	movl   $0x0,0x80185aa8
8010368f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103692:	e8 a9 fd ff ff       	call   80103440 <write_head>
    acquire(&log.lock);
80103697:	83 ec 0c             	sub    $0xc,%esp
8010369a:	68 60 5a 18 80       	push   $0x80185a60
8010369f:	e8 2c 1b 00 00       	call   801051d0 <acquire>
    wakeup(&log);
801036a4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036ab:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036b2:	00 00 00 
    wakeup(&log);
801036b5:	e8 06 16 00 00       	call   80104cc0 <wakeup>
    release(&log.lock);
801036ba:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036c1:	e8 ca 1b 00 00       	call   80105290 <release>
801036c6:	83 c4 10             	add    $0x10,%esp
}
801036c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036cc:	5b                   	pop    %ebx
801036cd:	5e                   	pop    %esi
801036ce:	5f                   	pop    %edi
801036cf:	5d                   	pop    %ebp
801036d0:	c3                   	ret    
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801036d8:	83 ec 0c             	sub    $0xc,%esp
801036db:	68 60 5a 18 80       	push   $0x80185a60
801036e0:	e8 db 15 00 00       	call   80104cc0 <wakeup>
  release(&log.lock);
801036e5:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036ec:	e8 9f 1b 00 00       	call   80105290 <release>
801036f1:	83 c4 10             	add    $0x10,%esp
}
801036f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036f7:	5b                   	pop    %ebx
801036f8:	5e                   	pop    %esi
801036f9:	5f                   	pop    %edi
801036fa:	5d                   	pop    %ebp
801036fb:	c3                   	ret    
    panic("log.committing");
801036fc:	83 ec 0c             	sub    $0xc,%esp
801036ff:	68 44 94 10 80       	push   $0x80109444
80103704:	e8 87 cc ff ff       	call   80100390 <panic>
80103709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103710 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103717:	8b 15 a8 5a 18 80    	mov    0x80185aa8,%edx
{
8010371d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103720:	83 fa 1d             	cmp    $0x1d,%edx
80103723:	0f 8f 9d 00 00 00    	jg     801037c6 <log_write+0xb6>
80103729:	a1 98 5a 18 80       	mov    0x80185a98,%eax
8010372e:	83 e8 01             	sub    $0x1,%eax
80103731:	39 c2                	cmp    %eax,%edx
80103733:	0f 8d 8d 00 00 00    	jge    801037c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103739:	a1 9c 5a 18 80       	mov    0x80185a9c,%eax
8010373e:	85 c0                	test   %eax,%eax
80103740:	0f 8e 8d 00 00 00    	jle    801037d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103746:	83 ec 0c             	sub    $0xc,%esp
80103749:	68 60 5a 18 80       	push   $0x80185a60
8010374e:	e8 7d 1a 00 00       	call   801051d0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103753:	8b 0d a8 5a 18 80    	mov    0x80185aa8,%ecx
80103759:	83 c4 10             	add    $0x10,%esp
8010375c:	83 f9 00             	cmp    $0x0,%ecx
8010375f:	7e 57                	jle    801037b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103761:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103764:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103766:	3b 15 ac 5a 18 80    	cmp    0x80185aac,%edx
8010376c:	75 0b                	jne    80103779 <log_write+0x69>
8010376e:	eb 38                	jmp    801037a8 <log_write+0x98>
80103770:	39 14 85 ac 5a 18 80 	cmp    %edx,-0x7fe7a554(,%eax,4)
80103777:	74 2f                	je     801037a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103779:	83 c0 01             	add    $0x1,%eax
8010377c:	39 c1                	cmp    %eax,%ecx
8010377e:	75 f0                	jne    80103770 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103780:	89 14 85 ac 5a 18 80 	mov    %edx,-0x7fe7a554(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103787:	83 c0 01             	add    $0x1,%eax
8010378a:	a3 a8 5a 18 80       	mov    %eax,0x80185aa8
  b->flags |= B_DIRTY; // prevent eviction
8010378f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103792:	c7 45 08 60 5a 18 80 	movl   $0x80185a60,0x8(%ebp)
}
80103799:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010379c:	c9                   	leave  
  release(&log.lock);
8010379d:	e9 ee 1a 00 00       	jmp    80105290 <release>
801037a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801037a8:	89 14 85 ac 5a 18 80 	mov    %edx,-0x7fe7a554(,%eax,4)
801037af:	eb de                	jmp    8010378f <log_write+0x7f>
801037b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037b8:	8b 43 08             	mov    0x8(%ebx),%eax
801037bb:	a3 ac 5a 18 80       	mov    %eax,0x80185aac
  if (i == log.lh.n)
801037c0:	75 cd                	jne    8010378f <log_write+0x7f>
801037c2:	31 c0                	xor    %eax,%eax
801037c4:	eb c1                	jmp    80103787 <log_write+0x77>
    panic("too big a transaction");
801037c6:	83 ec 0c             	sub    $0xc,%esp
801037c9:	68 53 94 10 80       	push   $0x80109453
801037ce:	e8 bd cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037d3:	83 ec 0c             	sub    $0xc,%esp
801037d6:	68 69 94 10 80       	push   $0x80109469
801037db:	e8 b0 cb ff ff       	call   80100390 <panic>

801037e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
801037e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801037e7:	e8 a4 0a 00 00       	call   80104290 <cpuid>
801037ec:	89 c3                	mov    %eax,%ebx
801037ee:	e8 9d 0a 00 00       	call   80104290 <cpuid>
801037f3:	83 ec 04             	sub    $0x4,%esp
801037f6:	53                   	push   %ebx
801037f7:	50                   	push   %eax
801037f8:	68 84 94 10 80       	push   $0x80109484
801037fd:	e8 5e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103802:	e8 c9 2d 00 00       	call   801065d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103807:	e8 04 0a 00 00       	call   80104210 <mycpu>
8010380c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010380e:	b8 01 00 00 00       	mov    $0x1,%eax
80103813:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010381a:	e8 51 0f 00 00       	call   80104770 <scheduler>
8010381f:	90                   	nop

80103820 <mpenter>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103826:	e8 45 3f 00 00       	call   80107770 <switchkvm>
  seginit();
8010382b:	e8 b0 3e 00 00       	call   801076e0 <seginit>
  lapicinit();
80103830:	e8 9b f7 ff ff       	call   80102fd0 <lapicinit>
  mpmain();
80103835:	e8 a6 ff ff ff       	call   801037e0 <mpmain>
8010383a:	66 90                	xchg   %ax,%ax
8010383c:	66 90                	xchg   %ax,%ax
8010383e:	66 90                	xchg   %ax,%ax

80103840 <main>:
{
80103840:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103844:	83 e4 f0             	and    $0xfffffff0,%esp
80103847:	ff 71 fc             	pushl  -0x4(%ecx)
8010384a:	55                   	push   %ebp
8010384b:	89 e5                	mov    %esp,%ebp
8010384d:	53                   	push   %ebx
8010384e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010384f:	83 ec 08             	sub    $0x8,%esp
80103852:	68 00 00 40 80       	push   $0x80400000
80103857:	68 88 75 19 80       	push   $0x80197588
8010385c:	e8 ef f3 ff ff       	call   80102c50 <kinit1>
  kvmalloc();      // kernel page table
80103861:	e8 5a 48 00 00       	call   801080c0 <kvmalloc>
  mpinit();        // detect other processors
80103866:	e8 75 01 00 00       	call   801039e0 <mpinit>
  lapicinit();     // interrupt controller
8010386b:	e8 60 f7 ff ff       	call   80102fd0 <lapicinit>
  seginit();       // segment descriptors
80103870:	e8 6b 3e 00 00       	call   801076e0 <seginit>
  picinit();       // disable pic
80103875:	e8 46 03 00 00       	call   80103bc0 <picinit>
  ioapicinit();    // another interrupt controller
8010387a:	e8 e1 f0 ff ff       	call   80102960 <ioapicinit>
  consoleinit();   // console hardware
8010387f:	e8 3c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103884:	e8 87 30 00 00       	call   80106910 <uartinit>
  pinit();         // process table
80103889:	e8 62 09 00 00       	call   801041f0 <pinit>
  tvinit();        // trap vectors
8010388e:	e8 bd 2c 00 00       	call   80106550 <tvinit>
  binit();         // buffer cache
80103893:	e8 a8 c7 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103898:	e8 73 d8 ff ff       	call   80101110 <fileinit>
  ideinit();       // disk 
8010389d:	e8 9e ee ff ff       	call   80102740 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801038a2:	83 c4 0c             	add    $0xc,%esp
801038a5:	68 8a 00 00 00       	push   $0x8a
801038aa:	68 8c c4 10 80       	push   $0x8010c48c
801038af:	68 00 70 00 80       	push   $0x80007000
801038b4:	e8 d7 1a 00 00       	call   80105390 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801038b9:	69 05 e0 60 18 80 b0 	imul   $0xb0,0x801860e0,%eax
801038c0:	00 00 00 
801038c3:	83 c4 10             	add    $0x10,%esp
801038c6:	05 60 5b 18 80       	add    $0x80185b60,%eax
801038cb:	3d 60 5b 18 80       	cmp    $0x80185b60,%eax
801038d0:	76 71                	jbe    80103943 <main+0x103>
801038d2:	bb 60 5b 18 80       	mov    $0x80185b60,%ebx
801038d7:	89 f6                	mov    %esi,%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801038e0:	e8 2b 09 00 00       	call   80104210 <mycpu>
801038e5:	39 d8                	cmp    %ebx,%eax
801038e7:	74 41                	je     8010392a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038e9:	e8 32 f4 ff ff       	call   80102d20 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801038ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801038f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103820,0x80006ff8
801038fa:	38 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038fd:	c7 05 f4 6f 00 80 00 	movl   $0x10b000,0x80006ff4
80103904:	b0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103907:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010390c:	0f b6 03             	movzbl (%ebx),%eax
8010390f:	83 ec 08             	sub    $0x8,%esp
80103912:	68 00 70 00 00       	push   $0x7000
80103917:	50                   	push   %eax
80103918:	e8 03 f8 ff ff       	call   80103120 <lapicstartap>
8010391d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103920:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103926:	85 c0                	test   %eax,%eax
80103928:	74 f6                	je     80103920 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010392a:	69 05 e0 60 18 80 b0 	imul   $0xb0,0x801860e0,%eax
80103931:	00 00 00 
80103934:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010393a:	05 60 5b 18 80       	add    $0x80185b60,%eax
8010393f:	39 c3                	cmp    %eax,%ebx
80103941:	72 9d                	jb     801038e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103943:	83 ec 08             	sub    $0x8,%esp
80103946:	68 00 00 00 8e       	push   $0x8e000000
8010394b:	68 00 00 40 80       	push   $0x80400000
80103950:	e8 6b f3 ff ff       	call   80102cc0 <kinit2>
  userinit();      // first user process
80103955:	e8 86 09 00 00       	call   801042e0 <userinit>
  mpmain();        // finish this processor's setup
8010395a:	e8 81 fe ff ff       	call   801037e0 <mpmain>
8010395f:	90                   	nop

80103960 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103965:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010396b:	53                   	push   %ebx
  e = addr+len;
8010396c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010396f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103972:	39 de                	cmp    %ebx,%esi
80103974:	72 10                	jb     80103986 <mpsearch1+0x26>
80103976:	eb 50                	jmp    801039c8 <mpsearch1+0x68>
80103978:	90                   	nop
80103979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103980:	39 fb                	cmp    %edi,%ebx
80103982:	89 fe                	mov    %edi,%esi
80103984:	76 42                	jbe    801039c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103986:	83 ec 04             	sub    $0x4,%esp
80103989:	8d 7e 10             	lea    0x10(%esi),%edi
8010398c:	6a 04                	push   $0x4
8010398e:	68 98 94 10 80       	push   $0x80109498
80103993:	56                   	push   %esi
80103994:	e8 97 19 00 00       	call   80105330 <memcmp>
80103999:	83 c4 10             	add    $0x10,%esp
8010399c:	85 c0                	test   %eax,%eax
8010399e:	75 e0                	jne    80103980 <mpsearch1+0x20>
801039a0:	89 f1                	mov    %esi,%ecx
801039a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801039a8:	0f b6 11             	movzbl (%ecx),%edx
801039ab:	83 c1 01             	add    $0x1,%ecx
801039ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801039b0:	39 f9                	cmp    %edi,%ecx
801039b2:	75 f4                	jne    801039a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039b4:	84 c0                	test   %al,%al
801039b6:	75 c8                	jne    80103980 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801039b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039bb:	89 f0                	mov    %esi,%eax
801039bd:	5b                   	pop    %ebx
801039be:	5e                   	pop    %esi
801039bf:	5f                   	pop    %edi
801039c0:	5d                   	pop    %ebp
801039c1:	c3                   	ret    
801039c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801039cb:	31 f6                	xor    %esi,%esi
}
801039cd:	89 f0                	mov    %esi,%eax
801039cf:	5b                   	pop    %ebx
801039d0:	5e                   	pop    %esi
801039d1:	5f                   	pop    %edi
801039d2:	5d                   	pop    %ebp
801039d3:	c3                   	ret    
801039d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	57                   	push   %edi
801039e4:	56                   	push   %esi
801039e5:	53                   	push   %ebx
801039e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801039e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801039f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801039f7:	c1 e0 08             	shl    $0x8,%eax
801039fa:	09 d0                	or     %edx,%eax
801039fc:	c1 e0 04             	shl    $0x4,%eax
801039ff:	85 c0                	test   %eax,%eax
80103a01:	75 1b                	jne    80103a1e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a03:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103a0a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103a11:	c1 e0 08             	shl    $0x8,%eax
80103a14:	09 d0                	or     %edx,%eax
80103a16:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103a19:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103a1e:	ba 00 04 00 00       	mov    $0x400,%edx
80103a23:	e8 38 ff ff ff       	call   80103960 <mpsearch1>
80103a28:	85 c0                	test   %eax,%eax
80103a2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a2d:	0f 84 3d 01 00 00    	je     80103b70 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103a36:	8b 58 04             	mov    0x4(%eax),%ebx
80103a39:	85 db                	test   %ebx,%ebx
80103a3b:	0f 84 4f 01 00 00    	je     80103b90 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103a41:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103a47:	83 ec 04             	sub    $0x4,%esp
80103a4a:	6a 04                	push   $0x4
80103a4c:	68 b5 94 10 80       	push   $0x801094b5
80103a51:	56                   	push   %esi
80103a52:	e8 d9 18 00 00       	call   80105330 <memcmp>
80103a57:	83 c4 10             	add    $0x10,%esp
80103a5a:	85 c0                	test   %eax,%eax
80103a5c:	0f 85 2e 01 00 00    	jne    80103b90 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103a62:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103a69:	3c 01                	cmp    $0x1,%al
80103a6b:	0f 95 c2             	setne  %dl
80103a6e:	3c 04                	cmp    $0x4,%al
80103a70:	0f 95 c0             	setne  %al
80103a73:	20 c2                	and    %al,%dl
80103a75:	0f 85 15 01 00 00    	jne    80103b90 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
80103a7b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103a82:	66 85 ff             	test   %di,%di
80103a85:	74 1a                	je     80103aa1 <mpinit+0xc1>
80103a87:	89 f0                	mov    %esi,%eax
80103a89:	01 f7                	add    %esi,%edi
  sum = 0;
80103a8b:	31 d2                	xor    %edx,%edx
80103a8d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103a90:	0f b6 08             	movzbl (%eax),%ecx
80103a93:	83 c0 01             	add    $0x1,%eax
80103a96:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103a98:	39 c7                	cmp    %eax,%edi
80103a9a:	75 f4                	jne    80103a90 <mpinit+0xb0>
80103a9c:	84 d2                	test   %dl,%dl
80103a9e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103aa1:	85 f6                	test   %esi,%esi
80103aa3:	0f 84 e7 00 00 00    	je     80103b90 <mpinit+0x1b0>
80103aa9:	84 d2                	test   %dl,%dl
80103aab:	0f 85 df 00 00 00    	jne    80103b90 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103ab1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103ab7:	a3 5c 5a 18 80       	mov    %eax,0x80185a5c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103abc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103ac3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103ac9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103ace:	01 d6                	add    %edx,%esi
80103ad0:	39 c6                	cmp    %eax,%esi
80103ad2:	76 23                	jbe    80103af7 <mpinit+0x117>
    switch(*p){
80103ad4:	0f b6 10             	movzbl (%eax),%edx
80103ad7:	80 fa 04             	cmp    $0x4,%dl
80103ada:	0f 87 ca 00 00 00    	ja     80103baa <mpinit+0x1ca>
80103ae0:	ff 24 95 dc 94 10 80 	jmp    *-0x7fef6b24(,%edx,4)
80103ae7:	89 f6                	mov    %esi,%esi
80103ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103af0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103af3:	39 c6                	cmp    %eax,%esi
80103af5:	77 dd                	ja     80103ad4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103af7:	85 db                	test   %ebx,%ebx
80103af9:	0f 84 9e 00 00 00    	je     80103b9d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103b02:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103b06:	74 15                	je     80103b1d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b08:	b8 70 00 00 00       	mov    $0x70,%eax
80103b0d:	ba 22 00 00 00       	mov    $0x22,%edx
80103b12:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b13:	ba 23 00 00 00       	mov    $0x23,%edx
80103b18:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103b19:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b1c:	ee                   	out    %al,(%dx)
  }
}
80103b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b20:	5b                   	pop    %ebx
80103b21:	5e                   	pop    %esi
80103b22:	5f                   	pop    %edi
80103b23:	5d                   	pop    %ebp
80103b24:	c3                   	ret    
80103b25:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103b28:	8b 0d e0 60 18 80    	mov    0x801860e0,%ecx
80103b2e:	83 f9 07             	cmp    $0x7,%ecx
80103b31:	7f 19                	jg     80103b4c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b33:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103b37:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
80103b3d:	83 c1 01             	add    $0x1,%ecx
80103b40:	89 0d e0 60 18 80    	mov    %ecx,0x801860e0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103b46:	88 97 60 5b 18 80    	mov    %dl,-0x7fe7a4a0(%edi)
      p += sizeof(struct mpproc);
80103b4c:	83 c0 14             	add    $0x14,%eax
      continue;
80103b4f:	e9 7c ff ff ff       	jmp    80103ad0 <mpinit+0xf0>
80103b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103b58:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103b5c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103b5f:	88 15 40 5b 18 80    	mov    %dl,0x80185b40
      continue;
80103b65:	e9 66 ff ff ff       	jmp    80103ad0 <mpinit+0xf0>
80103b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103b70:	ba 00 00 01 00       	mov    $0x10000,%edx
80103b75:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103b7a:	e8 e1 fd ff ff       	call   80103960 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b7f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103b81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b84:	0f 85 a9 fe ff ff    	jne    80103a33 <mpinit+0x53>
80103b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103b90:	83 ec 0c             	sub    $0xc,%esp
80103b93:	68 9d 94 10 80       	push   $0x8010949d
80103b98:	e8 f3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 bc 94 10 80       	push   $0x801094bc
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
      ismp = 0;
80103baa:	31 db                	xor    %ebx,%ebx
80103bac:	e9 26 ff ff ff       	jmp    80103ad7 <mpinit+0xf7>
80103bb1:	66 90                	xchg   %ax,%ax
80103bb3:	66 90                	xchg   %ax,%ax
80103bb5:	66 90                	xchg   %ax,%ax
80103bb7:	66 90                	xchg   %ax,%ax
80103bb9:	66 90                	xchg   %ax,%ax
80103bbb:	66 90                	xchg   %ax,%ax
80103bbd:	66 90                	xchg   %ax,%ax
80103bbf:	90                   	nop

80103bc0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bc6:	ba 21 00 00 00       	mov    $0x21,%edx
80103bcb:	89 e5                	mov    %esp,%ebp
80103bcd:	ee                   	out    %al,(%dx)
80103bce:	ba a1 00 00 00       	mov    $0xa1,%edx
80103bd3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103bd4:	5d                   	pop    %ebp
80103bd5:	c3                   	ret    
80103bd6:	66 90                	xchg   %ax,%ax
80103bd8:	66 90                	xchg   %ax,%ax
80103bda:	66 90                	xchg   %ax,%ax
80103bdc:	66 90                	xchg   %ax,%ax
80103bde:	66 90                	xchg   %ax,%ax

80103be0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 0c             	sub    $0xc,%esp
80103be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103bef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103bf5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103bfb:	e8 30 d5 ff ff       	call   80101130 <filealloc>
80103c00:	85 c0                	test   %eax,%eax
80103c02:	89 03                	mov    %eax,(%ebx)
80103c04:	74 22                	je     80103c28 <pipealloc+0x48>
80103c06:	e8 25 d5 ff ff       	call   80101130 <filealloc>
80103c0b:	85 c0                	test   %eax,%eax
80103c0d:	89 06                	mov    %eax,(%esi)
80103c0f:	74 3f                	je     80103c50 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c11:	e8 0a f1 ff ff       	call   80102d20 <kalloc>
80103c16:	85 c0                	test   %eax,%eax
80103c18:	89 c7                	mov    %eax,%edi
80103c1a:	75 54                	jne    80103c70 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103c1c:	8b 03                	mov    (%ebx),%eax
80103c1e:	85 c0                	test   %eax,%eax
80103c20:	75 34                	jne    80103c56 <pipealloc+0x76>
80103c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103c28:	8b 06                	mov    (%esi),%eax
80103c2a:	85 c0                	test   %eax,%eax
80103c2c:	74 0c                	je     80103c3a <pipealloc+0x5a>
    fileclose(*f1);
80103c2e:	83 ec 0c             	sub    $0xc,%esp
80103c31:	50                   	push   %eax
80103c32:	e8 b9 d5 ff ff       	call   801011f0 <fileclose>
80103c37:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103c42:	5b                   	pop    %ebx
80103c43:	5e                   	pop    %esi
80103c44:	5f                   	pop    %edi
80103c45:	5d                   	pop    %ebp
80103c46:	c3                   	ret    
80103c47:	89 f6                	mov    %esi,%esi
80103c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103c50:	8b 03                	mov    (%ebx),%eax
80103c52:	85 c0                	test   %eax,%eax
80103c54:	74 e4                	je     80103c3a <pipealloc+0x5a>
    fileclose(*f0);
80103c56:	83 ec 0c             	sub    $0xc,%esp
80103c59:	50                   	push   %eax
80103c5a:	e8 91 d5 ff ff       	call   801011f0 <fileclose>
  if(*f1)
80103c5f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103c61:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103c64:	85 c0                	test   %eax,%eax
80103c66:	75 c6                	jne    80103c2e <pipealloc+0x4e>
80103c68:	eb d0                	jmp    80103c3a <pipealloc+0x5a>
80103c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103c70:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103c73:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103c7a:	00 00 00 
  p->writeopen = 1;
80103c7d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103c84:	00 00 00 
  p->nwrite = 0;
80103c87:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103c8e:	00 00 00 
  p->nread = 0;
80103c91:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103c98:	00 00 00 
  initlock(&p->lock, "pipe");
80103c9b:	68 f0 94 10 80       	push   $0x801094f0
80103ca0:	50                   	push   %eax
80103ca1:	e8 ea 13 00 00       	call   80105090 <initlock>
  (*f0)->type = FD_PIPE;
80103ca6:	8b 03                	mov    (%ebx),%eax
  return 0;
80103ca8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103cab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cb1:	8b 03                	mov    (%ebx),%eax
80103cb3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cb7:	8b 03                	mov    (%ebx),%eax
80103cb9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cbd:	8b 03                	mov    (%ebx),%eax
80103cbf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103cc2:	8b 06                	mov    (%esi),%eax
80103cc4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103cca:	8b 06                	mov    (%esi),%eax
80103ccc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103cd0:	8b 06                	mov    (%esi),%eax
80103cd2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103cd6:	8b 06                	mov    (%esi),%eax
80103cd8:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103cdb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103cde:	31 c0                	xor    %eax,%eax
}
80103ce0:	5b                   	pop    %ebx
80103ce1:	5e                   	pop    %esi
80103ce2:	5f                   	pop    %edi
80103ce3:	5d                   	pop    %ebp
80103ce4:	c3                   	ret    
80103ce5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	56                   	push   %esi
80103cf4:	53                   	push   %ebx
80103cf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cf8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103cfb:	83 ec 0c             	sub    $0xc,%esp
80103cfe:	53                   	push   %ebx
80103cff:	e8 cc 14 00 00       	call   801051d0 <acquire>
  if(writable){
80103d04:	83 c4 10             	add    $0x10,%esp
80103d07:	85 f6                	test   %esi,%esi
80103d09:	74 45                	je     80103d50 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103d0b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d11:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103d14:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103d1b:	00 00 00 
    wakeup(&p->nread);
80103d1e:	50                   	push   %eax
80103d1f:	e8 9c 0f 00 00       	call   80104cc0 <wakeup>
80103d24:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103d27:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103d2d:	85 d2                	test   %edx,%edx
80103d2f:	75 0a                	jne    80103d3b <pipeclose+0x4b>
80103d31:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103d37:	85 c0                	test   %eax,%eax
80103d39:	74 35                	je     80103d70 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103d3b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103d3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d41:	5b                   	pop    %ebx
80103d42:	5e                   	pop    %esi
80103d43:	5d                   	pop    %ebp
    release(&p->lock);
80103d44:	e9 47 15 00 00       	jmp    80105290 <release>
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d50:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d56:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d59:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d60:	00 00 00 
    wakeup(&p->nwrite);
80103d63:	50                   	push   %eax
80103d64:	e8 57 0f 00 00       	call   80104cc0 <wakeup>
80103d69:	83 c4 10             	add    $0x10,%esp
80103d6c:	eb b9                	jmp    80103d27 <pipeclose+0x37>
80103d6e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	53                   	push   %ebx
80103d74:	e8 17 15 00 00       	call   80105290 <release>
    kfree((char*)p);
80103d79:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103d7c:	83 c4 10             	add    $0x10,%esp
}
80103d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d82:	5b                   	pop    %ebx
80103d83:	5e                   	pop    %esi
80103d84:	5d                   	pop    %ebp
    kfree((char*)p);
80103d85:	e9 c6 ec ff ff       	jmp    80102a50 <kfree>
80103d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103d90 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	57                   	push   %edi
80103d94:	56                   	push   %esi
80103d95:	53                   	push   %ebx
80103d96:	83 ec 28             	sub    $0x28,%esp
80103d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103d9c:	53                   	push   %ebx
80103d9d:	e8 2e 14 00 00       	call   801051d0 <acquire>
  for(i = 0; i < n; i++){
80103da2:	8b 45 10             	mov    0x10(%ebp),%eax
80103da5:	83 c4 10             	add    $0x10,%esp
80103da8:	85 c0                	test   %eax,%eax
80103daa:	0f 8e c9 00 00 00    	jle    80103e79 <pipewrite+0xe9>
80103db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103db3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103db9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103dbf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103dc2:	03 4d 10             	add    0x10(%ebp),%ecx
80103dc5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103dc8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103dce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103dd4:	39 d0                	cmp    %edx,%eax
80103dd6:	75 71                	jne    80103e49 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103dd8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103dde:	85 c0                	test   %eax,%eax
80103de0:	74 4e                	je     80103e30 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103de2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103de8:	eb 3a                	jmp    80103e24 <pipewrite+0x94>
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103df0:	83 ec 0c             	sub    $0xc,%esp
80103df3:	57                   	push   %edi
80103df4:	e8 c7 0e 00 00       	call   80104cc0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103df9:	5a                   	pop    %edx
80103dfa:	59                   	pop    %ecx
80103dfb:	53                   	push   %ebx
80103dfc:	56                   	push   %esi
80103dfd:	e8 7e 0c 00 00       	call   80104a80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e02:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103e08:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103e0e:	83 c4 10             	add    $0x10,%esp
80103e11:	05 00 02 00 00       	add    $0x200,%eax
80103e16:	39 c2                	cmp    %eax,%edx
80103e18:	75 36                	jne    80103e50 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103e1a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103e20:	85 c0                	test   %eax,%eax
80103e22:	74 0c                	je     80103e30 <pipewrite+0xa0>
80103e24:	e8 87 04 00 00       	call   801042b0 <myproc>
80103e29:	8b 40 24             	mov    0x24(%eax),%eax
80103e2c:	85 c0                	test   %eax,%eax
80103e2e:	74 c0                	je     80103df0 <pipewrite+0x60>
        release(&p->lock);
80103e30:	83 ec 0c             	sub    $0xc,%esp
80103e33:	53                   	push   %ebx
80103e34:	e8 57 14 00 00       	call   80105290 <release>
        return -1;
80103e39:	83 c4 10             	add    $0x10,%esp
80103e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103e41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e44:	5b                   	pop    %ebx
80103e45:	5e                   	pop    %esi
80103e46:	5f                   	pop    %edi
80103e47:	5d                   	pop    %ebp
80103e48:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e49:	89 c2                	mov    %eax,%edx
80103e4b:	90                   	nop
80103e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e50:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103e53:	8d 42 01             	lea    0x1(%edx),%eax
80103e56:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103e5c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103e62:	83 c6 01             	add    $0x1,%esi
80103e65:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103e69:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103e6c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103e6f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103e73:	0f 85 4f ff ff ff    	jne    80103dc8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103e79:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103e7f:	83 ec 0c             	sub    $0xc,%esp
80103e82:	50                   	push   %eax
80103e83:	e8 38 0e 00 00       	call   80104cc0 <wakeup>
  release(&p->lock);
80103e88:	89 1c 24             	mov    %ebx,(%esp)
80103e8b:	e8 00 14 00 00       	call   80105290 <release>
  return n;
80103e90:	83 c4 10             	add    $0x10,%esp
80103e93:	8b 45 10             	mov    0x10(%ebp),%eax
80103e96:	eb a9                	jmp    80103e41 <pipewrite+0xb1>
80103e98:	90                   	nop
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ea0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	57                   	push   %edi
80103ea4:	56                   	push   %esi
80103ea5:	53                   	push   %ebx
80103ea6:	83 ec 18             	sub    $0x18,%esp
80103ea9:	8b 75 08             	mov    0x8(%ebp),%esi
80103eac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103eaf:	56                   	push   %esi
80103eb0:	e8 1b 13 00 00       	call   801051d0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103eb5:	83 c4 10             	add    $0x10,%esp
80103eb8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ebe:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ec4:	75 6a                	jne    80103f30 <piperead+0x90>
80103ec6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103ecc:	85 db                	test   %ebx,%ebx
80103ece:	0f 84 c4 00 00 00    	je     80103f98 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103ed4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103eda:	eb 2d                	jmp    80103f09 <piperead+0x69>
80103edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee0:	83 ec 08             	sub    $0x8,%esp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
80103ee5:	e8 96 0b 00 00       	call   80104a80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103eea:	83 c4 10             	add    $0x10,%esp
80103eed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103ef3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103ef9:	75 35                	jne    80103f30 <piperead+0x90>
80103efb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103f01:	85 d2                	test   %edx,%edx
80103f03:	0f 84 8f 00 00 00    	je     80103f98 <piperead+0xf8>
    if(myproc()->killed){
80103f09:	e8 a2 03 00 00       	call   801042b0 <myproc>
80103f0e:	8b 48 24             	mov    0x24(%eax),%ecx
80103f11:	85 c9                	test   %ecx,%ecx
80103f13:	74 cb                	je     80103ee0 <piperead+0x40>
      release(&p->lock);
80103f15:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103f18:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103f1d:	56                   	push   %esi
80103f1e:	e8 6d 13 00 00       	call   80105290 <release>
      return -1;
80103f23:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f29:	89 d8                	mov    %ebx,%eax
80103f2b:	5b                   	pop    %ebx
80103f2c:	5e                   	pop    %esi
80103f2d:	5f                   	pop    %edi
80103f2e:	5d                   	pop    %ebp
80103f2f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f30:	8b 45 10             	mov    0x10(%ebp),%eax
80103f33:	85 c0                	test   %eax,%eax
80103f35:	7e 61                	jle    80103f98 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103f37:	31 db                	xor    %ebx,%ebx
80103f39:	eb 13                	jmp    80103f4e <piperead+0xae>
80103f3b:	90                   	nop
80103f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f40:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103f46:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103f4c:	74 1f                	je     80103f6d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f4e:	8d 41 01             	lea    0x1(%ecx),%eax
80103f51:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103f57:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103f5d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103f62:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f65:	83 c3 01             	add    $0x1,%ebx
80103f68:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103f6b:	75 d3                	jne    80103f40 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103f6d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103f73:	83 ec 0c             	sub    $0xc,%esp
80103f76:	50                   	push   %eax
80103f77:	e8 44 0d 00 00       	call   80104cc0 <wakeup>
  release(&p->lock);
80103f7c:	89 34 24             	mov    %esi,(%esp)
80103f7f:	e8 0c 13 00 00       	call   80105290 <release>
  return i;
80103f84:	83 c4 10             	add    $0x10,%esp
}
80103f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f8a:	89 d8                	mov    %ebx,%eax
80103f8c:	5b                   	pop    %ebx
80103f8d:	5e                   	pop    %esi
80103f8e:	5f                   	pop    %edi
80103f8f:	5d                   	pop    %ebp
80103f90:	c3                   	ret    
80103f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f98:	31 db                	xor    %ebx,%ebx
80103f9a:	eb d1                	jmp    80103f6d <piperead+0xcd>
80103f9c:	66 90                	xchg   %ax,%ax
80103f9e:	66 90                	xchg   %ax,%ax

80103fa0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa6:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80103fab:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80103fae:	68 00 61 18 80       	push   $0x80186100
80103fb3:	e8 18 12 00 00       	call   801051d0 <acquire>
80103fb8:	83 c4 10             	add    $0x10,%esp
80103fbb:	eb 15                	jmp    80103fd2 <allocproc+0x32>
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc0:	81 c3 30 04 00 00    	add    $0x430,%ebx
80103fc6:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80103fcc:	0f 83 96 01 00 00    	jae    80104168 <allocproc+0x1c8>
    if(p->state == UNUSED)
80103fd2:	8b 43 0c             	mov    0xc(%ebx),%eax
80103fd5:	85 c0                	test   %eax,%eax
80103fd7:	75 e7                	jne    80103fc0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103fd9:	a1 04 c0 10 80       	mov    0x8010c004,%eax

  release(&ptable.lock);
80103fde:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103fe1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103fe8:	8d 50 01             	lea    0x1(%eax),%edx
80103feb:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103fee:	68 00 61 18 80       	push   $0x80186100
  p->pid = nextpid++;
80103ff3:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
  release(&ptable.lock);
80103ff9:	e8 92 12 00 00       	call   80105290 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ffe:	e8 1d ed ff ff       	call   80102d20 <kalloc>
80104003:	83 c4 10             	add    $0x10,%esp
80104006:	85 c0                	test   %eax,%eax
80104008:	89 43 08             	mov    %eax,0x8(%ebx)
8010400b:	0f 84 73 01 00 00    	je     80104184 <allocproc+0x1e4>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104011:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80104017:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010401a:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010401f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80104022:	c7 40 14 41 65 10 80 	movl   $0x80106541,0x14(%eax)
  p->context = (struct context*)sp;
80104029:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010402c:	6a 14                	push   $0x14
8010402e:	6a 00                	push   $0x0
80104030:	50                   	push   %eax
80104031:	e8 aa 12 00 00       	call   801052e0 <memset>
  p->context->eip = (uint)forkret;
80104036:	8b 43 1c             	mov    0x1c(%ebx),%eax

  if(p->pid > 2) {
80104039:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010403c:	c7 40 10 a0 41 10 80 	movl   $0x801041a0,0x10(%eax)
  if(p->pid > 2) {
80104043:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104047:	7f 0f                	jg     80104058 <allocproc+0xb8>
      // cprintf("\n");

    }
  }
  return p;
}
80104049:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010404c:	89 d8                	mov    %ebx,%eax
8010404e:	5b                   	pop    %ebx
8010404f:	5e                   	pop    %esi
80104050:	5f                   	pop    %edi
80104051:	5d                   	pop    %ebp
80104052:	c3                   	ret    
80104053:	90                   	nop
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(createSwapFile(p) != 0)
80104058:	83 ec 0c             	sub    $0xc,%esp
8010405b:	53                   	push   %ebx
8010405c:	e8 ff e4 ff ff       	call   80102560 <createSwapFile>
80104061:	83 c4 10             	add    $0x10,%esp
80104064:	85 c0                	test   %eax,%eax
80104066:	0f 85 26 01 00 00    	jne    80104192 <allocproc+0x1f2>
    if(p->selection == SCFIFO)
8010406c:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
    p->num_ram = 0;
80104072:	c7 83 08 04 00 00 00 	movl   $0x0,0x408(%ebx)
80104079:	00 00 00 
    p->num_swap = 0;
8010407c:	c7 83 0c 04 00 00 00 	movl   $0x0,0x40c(%ebx)
80104083:	00 00 00 
    p->totalPgfltCount = 0;
80104086:	c7 83 28 04 00 00 00 	movl   $0x0,0x428(%ebx)
8010408d:	00 00 00 
    p->totalPgoutCount = 0;
80104090:	c7 83 2c 04 00 00 00 	movl   $0x0,0x42c(%ebx)
80104097:	00 00 00 
    if(p->selection == SCFIFO)
8010409a:	83 f8 03             	cmp    $0x3,%eax
8010409d:	0f 84 b1 00 00 00    	je     80104154 <allocproc+0x1b4>
    if(p->selection == AQ)
801040a3:	83 f8 04             	cmp    $0x4,%eax
801040a6:	75 14                	jne    801040bc <allocproc+0x11c>
      p->queue_head = 0;
801040a8:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
801040af:	00 00 00 
      p->queue_tail = 0;
801040b2:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
801040b9:	00 00 00 
    memset(p->ramPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040bc:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
801040c2:	83 ec 04             	sub    $0x4,%esp
801040c5:	68 c0 01 00 00       	push   $0x1c0
801040ca:	6a 00                	push   $0x0
801040cc:	50                   	push   %eax
801040cd:	e8 0e 12 00 00       	call   801052e0 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040d2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040d8:	83 c4 0c             	add    $0xc,%esp
801040db:	68 c0 01 00 00       	push   $0x1c0
801040e0:	6a 00                	push   $0x0
801040e2:	50                   	push   %eax
801040e3:	e8 f8 11 00 00       	call   801052e0 <memset>
    if(p->pid > 2)
801040e8:	83 c4 10             	add    $0x10,%esp
801040eb:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801040ef:	0f 8e 54 ff ff ff    	jle    80104049 <allocproc+0xa9>
      p->free_head = (struct fblock*)kalloc();
801040f5:	e8 26 ec ff ff       	call   80102d20 <kalloc>
801040fa:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
      p->free_head->prev = 0;
80104100:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
      struct fblock *prev = p->free_head;
80104107:	be 00 10 00 00       	mov    $0x1000,%esi
      p->free_head->off = 0 * PGSIZE;
8010410c:	8b 83 14 04 00 00    	mov    0x414(%ebx),%eax
80104112:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      struct fblock *prev = p->free_head;
80104118:	8b bb 14 04 00 00    	mov    0x414(%ebx),%edi
8010411e:	66 90                	xchg   %ax,%ax
        struct fblock *curr = (struct fblock*)kalloc();
80104120:	e8 fb eb ff ff       	call   80102d20 <kalloc>
        curr->off = i * PGSIZE;
80104125:	89 30                	mov    %esi,(%eax)
80104127:	81 c6 00 10 00 00    	add    $0x1000,%esi
        curr->prev = prev;
8010412d:	89 78 08             	mov    %edi,0x8(%eax)
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
80104130:	81 fe 00 00 01 00    	cmp    $0x10000,%esi
        curr->prev->next = curr;
80104136:	89 47 04             	mov    %eax,0x4(%edi)
80104139:	89 c7                	mov    %eax,%edi
      for(int i = 1; i < MAX_PSYC_PAGES; i++)
8010413b:	75 e3                	jne    80104120 <allocproc+0x180>
      p->free_tail = prev;
8010413d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
      p->free_tail->next = 0;
80104143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
}
8010414a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414d:	89 d8                	mov    %ebx,%eax
8010414f:	5b                   	pop    %ebx
80104150:	5e                   	pop    %esi
80104151:	5f                   	pop    %edi
80104152:	5d                   	pop    %ebp
80104153:	c3                   	ret    
      p->clockHand = 0;
80104154:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
8010415b:	00 00 00 
8010415e:	e9 59 ff ff ff       	jmp    801040bc <allocproc+0x11c>
80104163:	90                   	nop
80104164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104168:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010416b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010416d:	68 00 61 18 80       	push   $0x80186100
80104172:	e8 19 11 00 00       	call   80105290 <release>
  return 0;
80104177:	83 c4 10             	add    $0x10,%esp
}
8010417a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010417d:	89 d8                	mov    %ebx,%eax
8010417f:	5b                   	pop    %ebx
80104180:	5e                   	pop    %esi
80104181:	5f                   	pop    %edi
80104182:	5d                   	pop    %ebp
80104183:	c3                   	ret    
    p->state = UNUSED;
80104184:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010418b:	31 db                	xor    %ebx,%ebx
8010418d:	e9 b7 fe ff ff       	jmp    80104049 <allocproc+0xa9>
      panic("allocproc: createSwapFile");
80104192:	83 ec 0c             	sub    $0xc,%esp
80104195:	68 f5 94 10 80       	push   $0x801094f5
8010419a:	e8 f1 c1 ff ff       	call   80100390 <panic>
8010419f:	90                   	nop

801041a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801041a6:	68 00 61 18 80       	push   $0x80186100
801041ab:	e8 e0 10 00 00       	call   80105290 <release>

  if (first) {
801041b0:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801041b5:	83 c4 10             	add    $0x10,%esp
801041b8:	85 c0                	test   %eax,%eax
801041ba:	75 04                	jne    801041c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801041bc:	c9                   	leave  
801041bd:	c3                   	ret    
801041be:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801041c0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801041c3:	c7 05 00 c0 10 80 00 	movl   $0x0,0x8010c000
801041ca:	00 00 00 
    iinit(ROOTDEV);
801041cd:	6a 01                	push   $0x1
801041cf:	e8 5c d6 ff ff       	call   80101830 <iinit>
    initlog(ROOTDEV);
801041d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801041db:	e8 c0 f2 ff ff       	call   801034a0 <initlog>
801041e0:	83 c4 10             	add    $0x10,%esp
}
801041e3:	c9                   	leave  
801041e4:	c3                   	ret    
801041e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <pinit>:
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801041f6:	68 0f 95 10 80       	push   $0x8010950f
801041fb:	68 00 61 18 80       	push   $0x80186100
80104200:	e8 8b 0e 00 00       	call   80105090 <initlock>
}
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	c9                   	leave  
80104209:	c3                   	ret    
8010420a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104210 <mycpu>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	56                   	push   %esi
80104214:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104215:	9c                   	pushf  
80104216:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104217:	f6 c4 02             	test   $0x2,%ah
8010421a:	75 5e                	jne    8010427a <mycpu+0x6a>
  apicid = lapicid();
8010421c:	e8 af ee ff ff       	call   801030d0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104221:	8b 35 e0 60 18 80    	mov    0x801860e0,%esi
80104227:	85 f6                	test   %esi,%esi
80104229:	7e 42                	jle    8010426d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010422b:	0f b6 15 60 5b 18 80 	movzbl 0x80185b60,%edx
80104232:	39 d0                	cmp    %edx,%eax
80104234:	74 30                	je     80104266 <mycpu+0x56>
80104236:	b9 10 5c 18 80       	mov    $0x80185c10,%ecx
  for (i = 0; i < ncpu; ++i) {
8010423b:	31 d2                	xor    %edx,%edx
8010423d:	8d 76 00             	lea    0x0(%esi),%esi
80104240:	83 c2 01             	add    $0x1,%edx
80104243:	39 f2                	cmp    %esi,%edx
80104245:	74 26                	je     8010426d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80104247:	0f b6 19             	movzbl (%ecx),%ebx
8010424a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80104250:	39 c3                	cmp    %eax,%ebx
80104252:	75 ec                	jne    80104240 <mycpu+0x30>
80104254:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010425a:	05 60 5b 18 80       	add    $0x80185b60,%eax
}
8010425f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104262:	5b                   	pop    %ebx
80104263:	5e                   	pop    %esi
80104264:	5d                   	pop    %ebp
80104265:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80104266:	b8 60 5b 18 80       	mov    $0x80185b60,%eax
      return &cpus[i];
8010426b:	eb f2                	jmp    8010425f <mycpu+0x4f>
  panic("unknown apicid\n");
8010426d:	83 ec 0c             	sub    $0xc,%esp
80104270:	68 16 95 10 80       	push   $0x80109516
80104275:	e8 16 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 04 96 10 80       	push   $0x80109604
80104282:	e8 09 c1 ff ff       	call   80100390 <panic>
80104287:	89 f6                	mov    %esi,%esi
80104289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104290 <cpuid>:
cpuid() {
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104296:	e8 75 ff ff ff       	call   80104210 <mycpu>
8010429b:	2d 60 5b 18 80       	sub    $0x80185b60,%eax
}
801042a0:	c9                   	leave  
  return mycpu()-cpus;
801042a1:	c1 f8 04             	sar    $0x4,%eax
801042a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801042aa:	c3                   	ret    
801042ab:	90                   	nop
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <myproc>:
myproc(void) {
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801042b7:	e8 44 0e 00 00       	call   80105100 <pushcli>
  c = mycpu();
801042bc:	e8 4f ff ff ff       	call   80104210 <mycpu>
  p = c->proc;
801042c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042c7:	e8 74 0e 00 00       	call   80105140 <popcli>
}
801042cc:	83 c4 04             	add    $0x4,%esp
801042cf:	89 d8                	mov    %ebx,%eax
801042d1:	5b                   	pop    %ebx
801042d2:	5d                   	pop    %ebp
801042d3:	c3                   	ret    
801042d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801042e0 <userinit>:
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801042e7:	e8 b4 fc ff ff       	call   80103fa0 <allocproc>
801042ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801042ee:	a3 d8 c5 10 80       	mov    %eax,0x8010c5d8
  if((p->pgdir = setupkvm()) == 0)
801042f3:	e8 38 3d 00 00       	call   80108030 <setupkvm>
801042f8:	85 c0                	test   %eax,%eax
801042fa:	89 43 04             	mov    %eax,0x4(%ebx)
801042fd:	0f 84 bd 00 00 00    	je     801043c0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104303:	83 ec 04             	sub    $0x4,%esp
80104306:	68 2c 00 00 00       	push   $0x2c
8010430b:	68 60 c4 10 80       	push   $0x8010c460
80104310:	50                   	push   %eax
80104311:	e8 8a 35 00 00       	call   801078a0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104316:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104319:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010431f:	6a 4c                	push   $0x4c
80104321:	6a 00                	push   $0x0
80104323:	ff 73 18             	pushl  0x18(%ebx)
80104326:	e8 b5 0f 00 00       	call   801052e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010432b:	8b 43 18             	mov    0x18(%ebx),%eax
8010432e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104333:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104338:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010433b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010433f:	8b 43 18             	mov    0x18(%ebx),%eax
80104342:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104346:	8b 43 18             	mov    0x18(%ebx),%eax
80104349:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010434d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104351:	8b 43 18             	mov    0x18(%ebx),%eax
80104354:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80104358:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010435c:	8b 43 18             	mov    0x18(%ebx),%eax
8010435f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104366:	8b 43 18             	mov    0x18(%ebx),%eax
80104369:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104370:	8b 43 18             	mov    0x18(%ebx),%eax
80104373:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010437a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010437d:	6a 10                	push   $0x10
8010437f:	68 3f 95 10 80       	push   $0x8010953f
80104384:	50                   	push   %eax
80104385:	e8 36 11 00 00       	call   801054c0 <safestrcpy>
  p->cwd = namei("/");
8010438a:	c7 04 24 48 95 10 80 	movl   $0x80109548,(%esp)
80104391:	e8 fa de ff ff       	call   80102290 <namei>
80104396:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104399:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043a0:	e8 2b 0e 00 00       	call   801051d0 <acquire>
  p->state = RUNNABLE;
801043a5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043ac:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043b3:	e8 d8 0e 00 00       	call   80105290 <release>
}
801043b8:	83 c4 10             	add    $0x10,%esp
801043bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043be:	c9                   	leave  
801043bf:	c3                   	ret    
    panic("userinit: out of memory?");
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	68 26 95 10 80       	push   $0x80109526
801043c8:	e8 c3 bf ff ff       	call   80100390 <panic>
801043cd:	8d 76 00             	lea    0x0(%esi),%esi

801043d0 <growproc>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
801043d5:	83 ec 10             	sub    $0x10,%esp
801043d8:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801043db:	e8 20 0d 00 00       	call   80105100 <pushcli>
  c = mycpu();
801043e0:	e8 2b fe ff ff       	call   80104210 <mycpu>
  p = c->proc;
801043e5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043eb:	e8 50 0d 00 00       	call   80105140 <popcli>
  if(n > 0){
801043f0:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801043f3:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801043f5:	7f 19                	jg     80104410 <growproc+0x40>
  } else if(n < 0){
801043f7:	75 37                	jne    80104430 <growproc+0x60>
  switchuvm(curproc);
801043f9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801043fc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801043fe:	53                   	push   %ebx
801043ff:	e8 8c 33 00 00       	call   80107790 <switchuvm>
  return 0;
80104404:	83 c4 10             	add    $0x10,%esp
80104407:	31 c0                	xor    %eax,%eax
}
80104409:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010440c:	5b                   	pop    %ebx
8010440d:	5e                   	pop    %esi
8010440e:	5d                   	pop    %ebp
8010440f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104410:	83 ec 04             	sub    $0x4,%esp
80104413:	01 c6                	add    %eax,%esi
80104415:	56                   	push   %esi
80104416:	50                   	push   %eax
80104417:	ff 73 04             	pushl  0x4(%ebx)
8010441a:	e8 01 3a 00 00       	call   80107e20 <allocuvm>
8010441f:	83 c4 10             	add    $0x10,%esp
80104422:	85 c0                	test   %eax,%eax
80104424:	75 d3                	jne    801043f9 <growproc+0x29>
      return -1;
80104426:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010442b:	eb dc                	jmp    80104409 <growproc+0x39>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("growproc: n < 0\n");
80104430:	83 ec 0c             	sub    $0xc,%esp
80104433:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104436:	68 4a 95 10 80       	push   $0x8010954a
8010443b:	e8 20 c2 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104440:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104443:	83 c4 0c             	add    $0xc,%esp
80104446:	01 c6                	add    %eax,%esi
80104448:	56                   	push   %esi
80104449:	50                   	push   %eax
8010444a:	ff 73 04             	pushl  0x4(%ebx)
8010444d:	e8 ae 37 00 00       	call   80107c00 <deallocuvm>
80104452:	83 c4 10             	add    $0x10,%esp
80104455:	85 c0                	test   %eax,%eax
80104457:	75 a0                	jne    801043f9 <growproc+0x29>
80104459:	eb cb                	jmp    80104426 <growproc+0x56>
8010445b:	90                   	nop
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <fork>:
{ 
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	57                   	push   %edi
80104464:	56                   	push   %esi
80104465:	53                   	push   %ebx
80104466:	81 ec 1c 08 00 00    	sub    $0x81c,%esp
  pushcli();
8010446c:	e8 8f 0c 00 00       	call   80105100 <pushcli>
  c = mycpu();
80104471:	e8 9a fd ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104476:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010447c:	e8 bf 0c 00 00       	call   80105140 <popcli>
  if((np = allocproc()) == 0){
80104481:	e8 1a fb ff ff       	call   80103fa0 <allocproc>
80104486:	85 c0                	test   %eax,%eax
80104488:	89 85 e4 f7 ff ff    	mov    %eax,-0x81c(%ebp)
8010448e:	0f 84 f9 01 00 00    	je     8010468d <fork+0x22d>
  if(curproc->pid <= 2) // init, shell
80104494:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
80104498:	89 c7                	mov    %eax,%edi
8010449a:	8b 13                	mov    (%ebx),%edx
8010449c:	8b 43 04             	mov    0x4(%ebx),%eax
8010449f:	0f 8e d3 01 00 00    	jle    80104678 <fork+0x218>
    np->pgdir = cowuvm(curproc->pgdir, curproc->sz);
801044a5:	83 ec 08             	sub    $0x8,%esp
801044a8:	52                   	push   %edx
801044a9:	50                   	push   %eax
801044aa:	e8 61 3c 00 00       	call   80108110 <cowuvm>
801044af:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801044b5:	83 c4 10             	add    $0x10,%esp
801044b8:	89 41 04             	mov    %eax,0x4(%ecx)
  if(np->pgdir == 0){
801044bb:	85 c0                	test   %eax,%eax
801044bd:	0f 84 d1 01 00 00    	je     80104694 <fork+0x234>
  np->sz = curproc->sz;
801044c3:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801044c9:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801044cb:	8b 79 18             	mov    0x18(%ecx),%edi
  np->sz = curproc->sz;
801044ce:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801044d0:	89 c8                	mov    %ecx,%eax
801044d2:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801044d5:	b9 13 00 00 00       	mov    $0x13,%ecx
801044da:	8b 73 18             	mov    0x18(%ebx),%esi
801044dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
801044df:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
801044e3:	0f 8e 04 01 00 00    	jle    801045ed <fork+0x18d>
    np->totalPgfltCount = 0;
801044e9:	89 c7                	mov    %eax,%edi
801044eb:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
801044f2:	00 00 00 
    np->totalPgoutCount = 0;
801044f5:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801044fc:	00 00 00 
    np->num_ram = curproc->num_ram;
801044ff:	8b 83 08 04 00 00    	mov    0x408(%ebx),%eax
80104505:	8d 93 90 00 00 00    	lea    0x90(%ebx),%edx
        np->ramPages[i].pgdir = np->pgdir;
8010450b:	8b 4f 04             	mov    0x4(%edi),%ecx
    np->num_ram = curproc->num_ram;
8010450e:	89 87 08 04 00 00    	mov    %eax,0x408(%edi)
    np->num_swap = curproc->num_swap;
80104514:	8b 83 0c 04 00 00    	mov    0x40c(%ebx),%eax
8010451a:	89 87 0c 04 00 00    	mov    %eax,0x40c(%edi)
80104520:	8d 87 88 00 00 00    	lea    0x88(%edi),%eax
80104526:	81 c7 48 02 00 00    	add    $0x248,%edi
8010452c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        np->ramPages[i].isused = 1;
80104530:	c7 80 c4 01 00 00 01 	movl   $0x1,0x1c4(%eax)
80104537:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010453a:	8b b2 c0 01 00 00    	mov    0x1c0(%edx),%esi
80104540:	83 c0 1c             	add    $0x1c,%eax
        np->ramPages[i].pgdir = np->pgdir;
80104543:	89 88 a4 01 00 00    	mov    %ecx,0x1a4(%eax)
80104549:	83 c2 1c             	add    $0x1c,%edx
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010454c:	89 b0 ac 01 00 00    	mov    %esi,0x1ac(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
80104552:	8b b2 ac 01 00 00    	mov    0x1ac(%edx),%esi
      np->swappedPages[i].isused = 1;
80104558:	c7 40 e8 01 00 00 00 	movl   $0x1,-0x18(%eax)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
8010455f:	89 b0 b4 01 00 00    	mov    %esi,0x1b4(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
80104565:	8b 72 e4             	mov    -0x1c(%edx),%esi
      np->swappedPages[i].pgdir = np->pgdir;
80104568:	89 48 e4             	mov    %ecx,-0x1c(%eax)
      np->swappedPages[i].virt_addr = curproc->swappedPages[i].virt_addr;
8010456b:	89 70 ec             	mov    %esi,-0x14(%eax)
      np->swappedPages[i].swap_offset = curproc->swappedPages[i].swap_offset;
8010456e:	8b 72 e8             	mov    -0x18(%edx),%esi
80104571:	89 70 f0             	mov    %esi,-0x10(%eax)
      np->swappedPages[i].ref_bit = curproc->swappedPages[i].ref_bit;
80104574:	8b 72 ec             	mov    -0x14(%edx),%esi
80104577:	89 70 f4             	mov    %esi,-0xc(%eax)
    for(i = 0; i < MAX_PSYC_PAGES; i++)
8010457a:	39 f8                	cmp    %edi,%eax
8010457c:	75 b2                	jne    80104530 <fork+0xd0>
      char buffer[PGSIZE / 2] = "";
8010457e:	8d bd ec f7 ff ff    	lea    -0x814(%ebp),%edi
80104584:	b9 ff 01 00 00       	mov    $0x1ff,%ecx
80104589:	31 c0                	xor    %eax,%eax
8010458b:	c7 85 e8 f7 ff ff 00 	movl   $0x0,-0x818(%ebp)
80104592:	00 00 00 
      int offset = 0;
80104595:	31 f6                	xor    %esi,%esi
80104597:	89 9d e0 f7 ff ff    	mov    %ebx,-0x820(%ebp)
      char buffer[PGSIZE / 2] = "";
8010459d:	f3 ab                	rep stos %eax,%es:(%edi)
8010459f:	8d bd e8 f7 ff ff    	lea    -0x818(%ebp),%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801045a5:	eb 25                	jmp    801045cc <fork+0x16c>
801045a7:	89 f6                	mov    %esi,%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
801045b0:	53                   	push   %ebx
801045b1:	56                   	push   %esi
801045b2:	57                   	push   %edi
801045b3:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
801045b9:	e8 42 e0 ff ff       	call   80102600 <writeToSwapFile>
801045be:	83 c4 10             	add    $0x10,%esp
801045c1:	83 f8 ff             	cmp    $0xffffffff,%eax
801045c4:	0f 84 f3 00 00 00    	je     801046bd <fork+0x25d>
        offset += nread;
801045ca:	01 de                	add    %ebx,%esi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
801045cc:	68 00 08 00 00       	push   $0x800
801045d1:	56                   	push   %esi
801045d2:	57                   	push   %edi
801045d3:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
801045d9:	e8 52 e0 ff ff       	call   80102630 <readFromSwapFile>
801045de:	83 c4 10             	add    $0x10,%esp
801045e1:	85 c0                	test   %eax,%eax
801045e3:	89 c3                	mov    %eax,%ebx
801045e5:	75 c9                	jne    801045b0 <fork+0x150>
801045e7:	8b 9d e0 f7 ff ff    	mov    -0x820(%ebp),%ebx
  np->tf->eax = 0;
801045ed:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  for(i = 0; i < NOFILE; i++)
801045f3:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801045f5:	8b 47 18             	mov    0x18(%edi),%eax
801045f8:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801045ff:	90                   	nop
    if(curproc->ofile[i])
80104600:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104604:	85 c0                	test   %eax,%eax
80104606:	74 10                	je     80104618 <fork+0x1b8>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104608:	83 ec 0c             	sub    $0xc,%esp
8010460b:	50                   	push   %eax
8010460c:	e8 8f cb ff ff       	call   801011a0 <filedup>
80104611:	83 c4 10             	add    $0x10,%esp
80104614:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104618:	83 c6 01             	add    $0x1,%esi
8010461b:	83 fe 10             	cmp    $0x10,%esi
8010461e:	75 e0                	jne    80104600 <fork+0x1a0>
  np->cwd = idup(curproc->cwd);
80104620:	83 ec 0c             	sub    $0xc,%esp
80104623:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104626:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104629:	e8 d2 d3 ff ff       	call   80101a00 <idup>
8010462e:	8b bd e4 f7 ff ff    	mov    -0x81c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104634:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80104637:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010463a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010463d:	6a 10                	push   $0x10
8010463f:	53                   	push   %ebx
80104640:	50                   	push   %eax
80104641:	e8 7a 0e 00 00       	call   801054c0 <safestrcpy>
  pid = np->pid;
80104646:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104649:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104650:	e8 7b 0b 00 00       	call   801051d0 <acquire>
  np->state = RUNNABLE;
80104655:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010465c:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104663:	e8 28 0c 00 00       	call   80105290 <release>
  return pid;
80104668:	83 c4 10             	add    $0x10,%esp
}
8010466b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010466e:	89 d8                	mov    %ebx,%eax
80104670:	5b                   	pop    %ebx
80104671:	5e                   	pop    %esi
80104672:	5f                   	pop    %edi
80104673:	5d                   	pop    %ebp
80104674:	c3                   	ret    
80104675:	8d 76 00             	lea    0x0(%esi),%esi
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
80104678:	83 ec 08             	sub    $0x8,%esp
8010467b:	52                   	push   %edx
8010467c:	50                   	push   %eax
8010467d:	e8 7e 40 00 00       	call   80108700 <copyuvm>
80104682:	83 c4 10             	add    $0x10,%esp
80104685:	89 47 04             	mov    %eax,0x4(%edi)
80104688:	e9 2e fe ff ff       	jmp    801044bb <fork+0x5b>
    return -1;
8010468d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104692:	eb d7                	jmp    8010466b <fork+0x20b>
    kfree(np->kstack);
80104694:	8b 9d e4 f7 ff ff    	mov    -0x81c(%ebp),%ebx
8010469a:	83 ec 0c             	sub    $0xc,%esp
8010469d:	ff 73 08             	pushl  0x8(%ebx)
801046a0:	e8 ab e3 ff ff       	call   80102a50 <kfree>
    np->kstack = 0;
801046a5:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801046ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801046b3:	83 c4 10             	add    $0x10,%esp
801046b6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046bb:	eb ae                	jmp    8010466b <fork+0x20b>
          panic("fork: error copying parent's swap file");
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 2c 96 10 80       	push   $0x8010962c
801046c5:	e8 c6 bc ff ff       	call   80100390 <panic>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <copyAQ>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	57                   	push   %edi
801046d4:	56                   	push   %esi
801046d5:	53                   	push   %ebx
801046d6:	83 ec 0c             	sub    $0xc,%esp
801046d9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801046dc:	e8 1f 0a 00 00       	call   80105100 <pushcli>
  c = mycpu();
801046e1:	e8 2a fb ff ff       	call   80104210 <mycpu>
  p = c->proc;
801046e6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801046ec:	e8 4f 0a 00 00       	call   80105140 <popcli>
  struct queue_node *old_curr = curproc->queue_head;
801046f1:	8b 9b 1c 04 00 00    	mov    0x41c(%ebx),%ebx
  np->queue_head = 0;
801046f7:	c7 86 1c 04 00 00 00 	movl   $0x0,0x41c(%esi)
801046fe:	00 00 00 
  np->queue_tail = 0;
80104701:	c7 86 20 04 00 00 00 	movl   $0x0,0x420(%esi)
80104708:	00 00 00 
  if(old_curr != 0) // copying first node separately to set new queue_head
8010470b:	85 db                	test   %ebx,%ebx
8010470d:	74 4f                	je     8010475e <copyAQ+0x8e>
    np_curr = (struct queue_node*)kalloc();
8010470f:	e8 0c e6 ff ff       	call   80102d20 <kalloc>
80104714:	89 c7                	mov    %eax,%edi
    np_curr->page_index = old_curr->page_index;
80104716:	8b 43 08             	mov    0x8(%ebx),%eax
80104719:	89 47 08             	mov    %eax,0x8(%edi)
    np->queue_head =np_curr;
8010471c:	89 be 1c 04 00 00    	mov    %edi,0x41c(%esi)
    np_curr->prev = 0;
80104722:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
    old_curr = old_curr->next;
80104729:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
8010472b:	85 db                	test   %ebx,%ebx
8010472d:	74 37                	je     80104766 <copyAQ+0x96>
8010472f:	90                   	nop
    np_curr = (struct queue_node*)kalloc();
80104730:	e8 eb e5 ff ff       	call   80102d20 <kalloc>
    np_curr->page_index = old_curr->page_index;
80104735:	8b 53 08             	mov    0x8(%ebx),%edx
    np_curr->prev = np_prev;
80104738:	89 78 04             	mov    %edi,0x4(%eax)
    np_curr->page_index = old_curr->page_index;
8010473b:	89 50 08             	mov    %edx,0x8(%eax)
    np_prev->next = np_curr;
8010473e:	89 07                	mov    %eax,(%edi)
80104740:	89 c7                	mov    %eax,%edi
    old_curr = old_curr->next;
80104742:	8b 1b                	mov    (%ebx),%ebx
  while(old_curr != 0)
80104744:	85 db                	test   %ebx,%ebx
80104746:	75 e8                	jne    80104730 <copyAQ+0x60>
  if(np->queue_head != 0) // if the queue wasn't empty
80104748:	8b 96 1c 04 00 00    	mov    0x41c(%esi),%edx
8010474e:	85 d2                	test   %edx,%edx
80104750:	74 0c                	je     8010475e <copyAQ+0x8e>
    np_curr->next = 0;
80104752:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    np->queue_tail = np_curr;
80104758:	89 86 20 04 00 00    	mov    %eax,0x420(%esi)
}
8010475e:	83 c4 0c             	add    $0xc,%esp
80104761:	5b                   	pop    %ebx
80104762:	5e                   	pop    %esi
80104763:	5f                   	pop    %edi
80104764:	5d                   	pop    %ebp
80104765:	c3                   	ret    
  while(old_curr != 0)
80104766:	89 f8                	mov    %edi,%eax
80104768:	eb de                	jmp    80104748 <copyAQ+0x78>
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104770 <scheduler>:
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	57                   	push   %edi
80104774:	56                   	push   %esi
80104775:	53                   	push   %ebx
80104776:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104779:	e8 92 fa ff ff       	call   80104210 <mycpu>
8010477e:	8d 78 04             	lea    0x4(%eax),%edi
80104781:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104783:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010478a:	00 00 00 
8010478d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104790:	fb                   	sti    
    acquire(&ptable.lock);
80104791:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104794:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
80104799:	68 00 61 18 80       	push   $0x80186100
8010479e:	e8 2d 0a 00 00       	call   801051d0 <acquire>
801047a3:	83 c4 10             	add    $0x10,%esp
801047a6:	8d 76 00             	lea    0x0(%esi),%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
801047b0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801047b4:	75 33                	jne    801047e9 <scheduler+0x79>
      switchuvm(p);
801047b6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
801047b9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801047bf:	53                   	push   %ebx
801047c0:	e8 cb 2f 00 00       	call   80107790 <switchuvm>
      swtch(&(c->scheduler), p->context);
801047c5:	58                   	pop    %eax
801047c6:	5a                   	pop    %edx
801047c7:	ff 73 1c             	pushl  0x1c(%ebx)
801047ca:	57                   	push   %edi
      p->state = RUNNING;
801047cb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801047d2:	e8 44 0d 00 00       	call   8010551b <swtch>
      switchkvm();
801047d7:	e8 94 2f 00 00       	call   80107770 <switchkvm>
      c->proc = 0;
801047dc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801047e3:	00 00 00 
801047e6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047e9:	81 c3 30 04 00 00    	add    $0x430,%ebx
801047ef:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
801047f5:	72 b9                	jb     801047b0 <scheduler+0x40>
    release(&ptable.lock);
801047f7:	83 ec 0c             	sub    $0xc,%esp
801047fa:	68 00 61 18 80       	push   $0x80186100
801047ff:	e8 8c 0a 00 00       	call   80105290 <release>
    sti();
80104804:	83 c4 10             	add    $0x10,%esp
80104807:	eb 87                	jmp    80104790 <scheduler+0x20>
80104809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104810 <sched>:
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	56                   	push   %esi
80104814:	53                   	push   %ebx
  pushcli();
80104815:	e8 e6 08 00 00       	call   80105100 <pushcli>
  c = mycpu();
8010481a:	e8 f1 f9 ff ff       	call   80104210 <mycpu>
  p = c->proc;
8010481f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104825:	e8 16 09 00 00       	call   80105140 <popcli>
  if(!holding(&ptable.lock))
8010482a:	83 ec 0c             	sub    $0xc,%esp
8010482d:	68 00 61 18 80       	push   $0x80186100
80104832:	e8 69 09 00 00       	call   801051a0 <holding>
80104837:	83 c4 10             	add    $0x10,%esp
8010483a:	85 c0                	test   %eax,%eax
8010483c:	74 4f                	je     8010488d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010483e:	e8 cd f9 ff ff       	call   80104210 <mycpu>
80104843:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010484a:	75 68                	jne    801048b4 <sched+0xa4>
  if(p->state == RUNNING)
8010484c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104850:	74 55                	je     801048a7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104852:	9c                   	pushf  
80104853:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104854:	f6 c4 02             	test   $0x2,%ah
80104857:	75 41                	jne    8010489a <sched+0x8a>
  intena = mycpu()->intena;
80104859:	e8 b2 f9 ff ff       	call   80104210 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010485e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104861:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104867:	e8 a4 f9 ff ff       	call   80104210 <mycpu>
8010486c:	83 ec 08             	sub    $0x8,%esp
8010486f:	ff 70 04             	pushl  0x4(%eax)
80104872:	53                   	push   %ebx
80104873:	e8 a3 0c 00 00       	call   8010551b <swtch>
  mycpu()->intena = intena;
80104878:	e8 93 f9 ff ff       	call   80104210 <mycpu>
}
8010487d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104880:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104886:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
    panic("sched ptable.lock");
8010488d:	83 ec 0c             	sub    $0xc,%esp
80104890:	68 5b 95 10 80       	push   $0x8010955b
80104895:	e8 f6 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010489a:	83 ec 0c             	sub    $0xc,%esp
8010489d:	68 87 95 10 80       	push   $0x80109587
801048a2:	e8 e9 ba ff ff       	call   80100390 <panic>
    panic("sched running");
801048a7:	83 ec 0c             	sub    $0xc,%esp
801048aa:	68 79 95 10 80       	push   $0x80109579
801048af:	e8 dc ba ff ff       	call   80100390 <panic>
    panic("sched locks");
801048b4:	83 ec 0c             	sub    $0xc,%esp
801048b7:	68 6d 95 10 80       	push   $0x8010956d
801048bc:	e8 cf ba ff ff       	call   80100390 <panic>
801048c1:	eb 0d                	jmp    801048d0 <exit>
801048c3:	90                   	nop
801048c4:	90                   	nop
801048c5:	90                   	nop
801048c6:	90                   	nop
801048c7:	90                   	nop
801048c8:	90                   	nop
801048c9:	90                   	nop
801048ca:	90                   	nop
801048cb:	90                   	nop
801048cc:	90                   	nop
801048cd:	90                   	nop
801048ce:	90                   	nop
801048cf:	90                   	nop

801048d0 <exit>:
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	56                   	push   %esi
801048d5:	53                   	push   %ebx
801048d6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801048d9:	e8 22 08 00 00       	call   80105100 <pushcli>
  c = mycpu();
801048de:	e8 2d f9 ff ff       	call   80104210 <mycpu>
  p = c->proc;
801048e3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048e9:	e8 52 08 00 00       	call   80105140 <popcli>
  if(curproc == initproc)
801048ee:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
801048f4:	8d 73 28             	lea    0x28(%ebx),%esi
801048f7:	8d 7b 68             	lea    0x68(%ebx),%edi
801048fa:	0f 84 22 01 00 00    	je     80104a22 <exit+0x152>
    if(curproc->ofile[fd]){
80104900:	8b 06                	mov    (%esi),%eax
80104902:	85 c0                	test   %eax,%eax
80104904:	74 12                	je     80104918 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104906:	83 ec 0c             	sub    $0xc,%esp
80104909:	50                   	push   %eax
8010490a:	e8 e1 c8 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
8010490f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104915:	83 c4 10             	add    $0x10,%esp
80104918:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010491b:	39 fe                	cmp    %edi,%esi
8010491d:	75 e1                	jne    80104900 <exit+0x30>
  begin_op();
8010491f:	e8 1c ec ff ff       	call   80103540 <begin_op>
  iput(curproc->cwd);
80104924:	83 ec 0c             	sub    $0xc,%esp
80104927:	ff 73 68             	pushl  0x68(%ebx)
8010492a:	e8 31 d2 ff ff       	call   80101b60 <iput>
  end_op();
8010492f:	e8 7c ec ff ff       	call   801035b0 <end_op>
  if(curproc->pid > 2) {
80104934:	83 c4 10             	add    $0x10,%esp
80104937:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
8010493b:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
80104942:	0f 8f b9 00 00 00    	jg     80104a01 <exit+0x131>
  acquire(&ptable.lock);
80104948:	83 ec 0c             	sub    $0xc,%esp
8010494b:	68 00 61 18 80       	push   $0x80186100
80104950:	e8 7b 08 00 00       	call   801051d0 <acquire>
  wakeup1(curproc->parent);
80104955:	8b 53 14             	mov    0x14(%ebx),%edx
80104958:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010495b:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104960:	eb 12                	jmp    80104974 <exit+0xa4>
80104962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104968:	05 30 04 00 00       	add    $0x430,%eax
8010496d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104972:	73 1e                	jae    80104992 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
80104974:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104978:	75 ee                	jne    80104968 <exit+0x98>
8010497a:	3b 50 20             	cmp    0x20(%eax),%edx
8010497d:	75 e9                	jne    80104968 <exit+0x98>
      p->state = RUNNABLE;
8010497f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104986:	05 30 04 00 00       	add    $0x430,%eax
8010498b:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104990:	72 e2                	jb     80104974 <exit+0xa4>
      p->parent = initproc;
80104992:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104998:	ba 34 61 18 80       	mov    $0x80186134,%edx
8010499d:	eb 0f                	jmp    801049ae <exit+0xde>
8010499f:	90                   	nop
801049a0:	81 c2 30 04 00 00    	add    $0x430,%edx
801049a6:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
801049ac:	73 3a                	jae    801049e8 <exit+0x118>
    if(p->parent == curproc){
801049ae:	39 5a 14             	cmp    %ebx,0x14(%edx)
801049b1:	75 ed                	jne    801049a0 <exit+0xd0>
      if(p->state == ZOMBIE)
801049b3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801049b7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801049ba:	75 e4                	jne    801049a0 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049bc:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049c1:	eb 11                	jmp    801049d4 <exit+0x104>
801049c3:	90                   	nop
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049c8:	05 30 04 00 00       	add    $0x430,%eax
801049cd:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049d2:	73 cc                	jae    801049a0 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
801049d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049d8:	75 ee                	jne    801049c8 <exit+0xf8>
801049da:	3b 48 20             	cmp    0x20(%eax),%ecx
801049dd:	75 e9                	jne    801049c8 <exit+0xf8>
      p->state = RUNNABLE;
801049df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801049e6:	eb e0                	jmp    801049c8 <exit+0xf8>
  curproc->state = ZOMBIE;
801049e8:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801049ef:	e8 1c fe ff ff       	call   80104810 <sched>
  panic("zombie exit");
801049f4:	83 ec 0c             	sub    $0xc,%esp
801049f7:	68 a8 95 10 80       	push   $0x801095a8
801049fc:	e8 8f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a01:	83 ec 0c             	sub    $0xc,%esp
80104a04:	53                   	push   %ebx
80104a05:	e8 56 d9 ff ff       	call   80102360 <removeSwapFile>
80104a0a:	83 c4 10             	add    $0x10,%esp
80104a0d:	85 c0                	test   %eax,%eax
80104a0f:	0f 84 33 ff ff ff    	je     80104948 <exit+0x78>
      panic("exit: error deleting swap file");
80104a15:	83 ec 0c             	sub    $0xc,%esp
80104a18:	68 54 96 10 80       	push   $0x80109654
80104a1d:	e8 6e b9 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104a22:	83 ec 0c             	sub    $0xc,%esp
80104a25:	68 9b 95 10 80       	push   $0x8010959b
80104a2a:	e8 61 b9 ff ff       	call   80100390 <panic>
80104a2f:	90                   	nop

80104a30 <yield>:
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	53                   	push   %ebx
80104a34:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a37:	68 00 61 18 80       	push   $0x80186100
80104a3c:	e8 8f 07 00 00       	call   801051d0 <acquire>
  pushcli();
80104a41:	e8 ba 06 00 00       	call   80105100 <pushcli>
  c = mycpu();
80104a46:	e8 c5 f7 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104a4b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a51:	e8 ea 06 00 00       	call   80105140 <popcli>
  myproc()->state = RUNNABLE;
80104a56:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104a5d:	e8 ae fd ff ff       	call   80104810 <sched>
  release(&ptable.lock);
80104a62:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104a69:	e8 22 08 00 00       	call   80105290 <release>
}
80104a6e:	83 c4 10             	add    $0x10,%esp
80104a71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a74:	c9                   	leave  
80104a75:	c3                   	ret    
80104a76:	8d 76 00             	lea    0x0(%esi),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <sleep>:
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	57                   	push   %edi
80104a84:	56                   	push   %esi
80104a85:	53                   	push   %ebx
80104a86:	83 ec 0c             	sub    $0xc,%esp
80104a89:	8b 7d 08             	mov    0x8(%ebp),%edi
80104a8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104a8f:	e8 6c 06 00 00       	call   80105100 <pushcli>
  c = mycpu();
80104a94:	e8 77 f7 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104a99:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104a9f:	e8 9c 06 00 00       	call   80105140 <popcli>
  if(p == 0)
80104aa4:	85 db                	test   %ebx,%ebx
80104aa6:	0f 84 87 00 00 00    	je     80104b33 <sleep+0xb3>
  if(lk == 0)
80104aac:	85 f6                	test   %esi,%esi
80104aae:	74 76                	je     80104b26 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ab0:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104ab6:	74 50                	je     80104b08 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ab8:	83 ec 0c             	sub    $0xc,%esp
80104abb:	68 00 61 18 80       	push   $0x80186100
80104ac0:	e8 0b 07 00 00       	call   801051d0 <acquire>
    release(lk);
80104ac5:	89 34 24             	mov    %esi,(%esp)
80104ac8:	e8 c3 07 00 00       	call   80105290 <release>
  p->chan = chan;
80104acd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104ad0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104ad7:	e8 34 fd ff ff       	call   80104810 <sched>
  p->chan = 0;
80104adc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104ae3:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104aea:	e8 a1 07 00 00       	call   80105290 <release>
    acquire(lk);
80104aef:	89 75 08             	mov    %esi,0x8(%ebp)
80104af2:	83 c4 10             	add    $0x10,%esp
}
80104af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af8:	5b                   	pop    %ebx
80104af9:	5e                   	pop    %esi
80104afa:	5f                   	pop    %edi
80104afb:	5d                   	pop    %ebp
    acquire(lk);
80104afc:	e9 cf 06 00 00       	jmp    801051d0 <acquire>
80104b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b08:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b0b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b12:	e8 f9 fc ff ff       	call   80104810 <sched>
  p->chan = 0;
80104b17:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b21:	5b                   	pop    %ebx
80104b22:	5e                   	pop    %esi
80104b23:	5f                   	pop    %edi
80104b24:	5d                   	pop    %ebp
80104b25:	c3                   	ret    
    panic("sleep without lk");
80104b26:	83 ec 0c             	sub    $0xc,%esp
80104b29:	68 ba 95 10 80       	push   $0x801095ba
80104b2e:	e8 5d b8 ff ff       	call   80100390 <panic>
    panic("sleep");
80104b33:	83 ec 0c             	sub    $0xc,%esp
80104b36:	68 b4 95 10 80       	push   $0x801095b4
80104b3b:	e8 50 b8 ff ff       	call   80100390 <panic>

80104b40 <wait>:
{
80104b40:	55                   	push   %ebp
80104b41:	89 e5                	mov    %esp,%ebp
80104b43:	56                   	push   %esi
80104b44:	53                   	push   %ebx
  pushcli();
80104b45:	e8 b6 05 00 00       	call   80105100 <pushcli>
  c = mycpu();
80104b4a:	e8 c1 f6 ff ff       	call   80104210 <mycpu>
  p = c->proc;
80104b4f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104b55:	e8 e6 05 00 00       	call   80105140 <popcli>
  acquire(&ptable.lock);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	68 00 61 18 80       	push   $0x80186100
80104b62:	e8 69 06 00 00       	call   801051d0 <acquire>
80104b67:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104b6a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b6c:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104b71:	eb 13                	jmp    80104b86 <wait+0x46>
80104b73:	90                   	nop
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b78:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104b7e:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104b84:	73 1e                	jae    80104ba4 <wait+0x64>
      if(p->parent != curproc)
80104b86:	39 73 14             	cmp    %esi,0x14(%ebx)
80104b89:	75 ed                	jne    80104b78 <wait+0x38>
      if(p->state == ZOMBIE){
80104b8b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104b8f:	74 3f                	je     80104bd0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b91:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104b97:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b9c:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104ba2:	72 e2                	jb     80104b86 <wait+0x46>
    if(!havekids || curproc->killed){
80104ba4:	85 c0                	test   %eax,%eax
80104ba6:	0f 84 f3 00 00 00    	je     80104c9f <wait+0x15f>
80104bac:	8b 46 24             	mov    0x24(%esi),%eax
80104baf:	85 c0                	test   %eax,%eax
80104bb1:	0f 85 e8 00 00 00    	jne    80104c9f <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104bb7:	83 ec 08             	sub    $0x8,%esp
80104bba:	68 00 61 18 80       	push   $0x80186100
80104bbf:	56                   	push   %esi
80104bc0:	e8 bb fe ff ff       	call   80104a80 <sleep>
    havekids = 0;
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	eb a0                	jmp    80104b6a <wait+0x2a>
80104bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104bd0:	83 ec 0c             	sub    $0xc,%esp
80104bd3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104bd6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104bd9:	e8 72 de ff ff       	call   80102a50 <kfree>
        freevm(p->pgdir); // panic: kfree
80104bde:	5a                   	pop    %edx
80104bdf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104be2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104be9:	e8 c2 33 00 00       	call   80107fb0 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104bee:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104bf4:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104bf7:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104bfe:	68 c0 01 00 00       	push   $0x1c0
80104c03:	6a 00                	push   $0x0
80104c05:	50                   	push   %eax
        p->parent = 0;
80104c06:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c0d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c11:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c18:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c1f:	00 00 00 
        p->swapFile = 0;
80104c22:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104c29:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104c30:	00 00 00 
        p->free_tail = 0;
80104c33:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104c3a:	00 00 00 
        p->queue_head = 0;
80104c3d:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104c44:	00 00 00 
        p->queue_tail = 0;
80104c47:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104c4e:	00 00 00 
        p->numswappages = 0;
80104c51:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104c58:	00 00 00 
        p-> nummemorypages = 0;
80104c5b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104c62:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c65:	e8 76 06 00 00       	call   801052e0 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104c6a:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104c70:	83 c4 0c             	add    $0xc,%esp
80104c73:	68 c0 01 00 00       	push   $0x1c0
80104c78:	6a 00                	push   $0x0
80104c7a:	50                   	push   %eax
80104c7b:	e8 60 06 00 00       	call   801052e0 <memset>
        release(&ptable.lock);
80104c80:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104c87:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104c8e:	e8 fd 05 00 00       	call   80105290 <release>
        return pid;
80104c93:	83 c4 10             	add    $0x10,%esp
}
80104c96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c99:	89 f0                	mov    %esi,%eax
80104c9b:	5b                   	pop    %ebx
80104c9c:	5e                   	pop    %esi
80104c9d:	5d                   	pop    %ebp
80104c9e:	c3                   	ret    
      release(&ptable.lock);
80104c9f:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104ca2:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104ca7:	68 00 61 18 80       	push   $0x80186100
80104cac:	e8 df 05 00 00       	call   80105290 <release>
      return -1;
80104cb1:	83 c4 10             	add    $0x10,%esp
80104cb4:	eb e0                	jmp    80104c96 <wait+0x156>
80104cb6:	8d 76 00             	lea    0x0(%esi),%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 10             	sub    $0x10,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104cca:	68 00 61 18 80       	push   $0x80186100
80104ccf:	e8 fc 04 00 00       	call   801051d0 <acquire>
80104cd4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cd7:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104cdc:	eb 0e                	jmp    80104cec <wakeup+0x2c>
80104cde:	66 90                	xchg   %ax,%ax
80104ce0:	05 30 04 00 00       	add    $0x430,%eax
80104ce5:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104cea:	73 1e                	jae    80104d0a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104cec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104cf0:	75 ee                	jne    80104ce0 <wakeup+0x20>
80104cf2:	3b 58 20             	cmp    0x20(%eax),%ebx
80104cf5:	75 e9                	jne    80104ce0 <wakeup+0x20>
      p->state = RUNNABLE;
80104cf7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104cfe:	05 30 04 00 00       	add    $0x430,%eax
80104d03:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d08:	72 e2                	jb     80104cec <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d0a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d14:	c9                   	leave  
  release(&ptable.lock);
80104d15:	e9 76 05 00 00       	jmp    80105290 <release>
80104d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d20 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 10             	sub    $0x10,%esp
80104d27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104d2a:	68 00 61 18 80       	push   $0x80186100
80104d2f:	e8 9c 04 00 00       	call   801051d0 <acquire>
80104d34:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d37:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d3c:	eb 0e                	jmp    80104d4c <kill+0x2c>
80104d3e:	66 90                	xchg   %ax,%ax
80104d40:	05 30 04 00 00       	add    $0x430,%eax
80104d45:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d4a:	73 34                	jae    80104d80 <kill+0x60>
    if(p->pid == pid){
80104d4c:	39 58 10             	cmp    %ebx,0x10(%eax)
80104d4f:	75 ef                	jne    80104d40 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104d51:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104d55:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104d5c:	75 07                	jne    80104d65 <kill+0x45>
        p->state = RUNNABLE;
80104d5e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104d65:	83 ec 0c             	sub    $0xc,%esp
80104d68:	68 00 61 18 80       	push   $0x80186100
80104d6d:	e8 1e 05 00 00       	call   80105290 <release>
      return 0;
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104d77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d7a:	c9                   	leave  
80104d7b:	c3                   	ret    
80104d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104d80:	83 ec 0c             	sub    $0xc,%esp
80104d83:	68 00 61 18 80       	push   $0x80186100
80104d88:	e8 03 05 00 00       	call   80105290 <release>
  return -1;
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d98:	c9                   	leave  
80104d99:	c3                   	ret    
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104da4:	31 db                	xor    %ebx,%ebx
{
80104da6:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104da9:	68 00 61 18 80       	push   $0x80186100
80104dae:	e8 1d 04 00 00       	call   801051d0 <acquire>
80104db3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104db6:	ba 34 61 18 80       	mov    $0x80186134,%edx
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104dbb:	b9 10 00 00 00       	mov    $0x10,%ecx
    if(p->state == UNUSED)
80104dc0:	8b 42 0c             	mov    0xc(%edx),%eax
80104dc3:	85 c0                	test   %eax,%eax
80104dc5:	74 0a                	je     80104dd1 <getCurrentFreePages+0x31>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104dc7:	89 c8                	mov    %ecx,%eax
80104dc9:	2b 82 08 04 00 00    	sub    0x408(%edx),%eax
80104dcf:	01 c3                	add    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104dd1:	81 c2 30 04 00 00    	add    $0x430,%edx
80104dd7:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104ddd:	72 e1                	jb     80104dc0 <getCurrentFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	68 00 61 18 80       	push   $0x80186100
80104de7:	e8 a4 04 00 00       	call   80105290 <release>
  return sum;
}
80104dec:	89 d8                	mov    %ebx,%eax
80104dee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df1:	c9                   	leave  
80104df2:	c3                   	ret    
80104df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e00 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104e00:	55                   	push   %ebp
80104e01:	89 e5                	mov    %esp,%ebp
80104e03:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80104e04:	31 db                	xor    %ebx,%ebx
{
80104e06:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e09:	68 00 61 18 80       	push   $0x80186100
80104e0e:	e8 bd 03 00 00       	call   801051d0 <acquire>
80104e13:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e16:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104e1b:	90                   	nop
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80104e20:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104e24:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e27:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e2d:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e33:	72 eb                	jb     80104e20 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80104e35:	83 ec 0c             	sub    $0xc,%esp
80104e38:	68 00 61 18 80       	push   $0x80186100
80104e3d:	e8 4e 04 00 00       	call   80105290 <release>
  return pcount * MAX_PSYC_PAGES;
80104e42:	89 d8                	mov    %ebx,%eax
80104e44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return pcount * MAX_PSYC_PAGES;
80104e47:	c1 e0 04             	shl    $0x4,%eax
80104e4a:	c9                   	leave  
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e50 <procdump>:
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	56                   	push   %esi
80104e55:	53                   	push   %ebx
80104e56:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e59:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104e5e:	83 ec 3c             	sub    $0x3c,%esp
80104e61:	eb 41                	jmp    80104ea4 <procdump+0x54>
80104e63:	90                   	nop
80104e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80104e68:	e8 93 ff ff ff       	call   80104e00 <getTotalFreePages>
80104e6d:	89 c7                	mov    %eax,%edi
80104e6f:	e8 2c ff ff ff       	call   80104da0 <getCurrentFreePages>
80104e74:	83 ec 04             	sub    $0x4,%esp
80104e77:	57                   	push   %edi
80104e78:	50                   	push   %eax
80104e79:	68 cf 95 10 80       	push   $0x801095cf
80104e7e:	e8 dd b7 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104e83:	c7 04 24 a0 9a 10 80 	movl   $0x80109aa0,(%esp)
80104e8a:	e8 d1 b7 ff ff       	call   80100660 <cprintf>
80104e8f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104e92:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104e98:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104e9e:	0f 83 ac 00 00 00    	jae    80104f50 <procdump+0x100>
    if(p->state == UNUSED)
80104ea4:	8b 43 0c             	mov    0xc(%ebx),%eax
80104ea7:	85 c0                	test   %eax,%eax
80104ea9:	74 e7                	je     80104e92 <procdump+0x42>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104eab:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104eae:	ba cb 95 10 80       	mov    $0x801095cb,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104eb3:	77 11                	ja     80104ec6 <procdump+0x76>
80104eb5:	8b 14 85 dc 96 10 80 	mov    -0x7fef6924(,%eax,4),%edx
      state = "???";
80104ebc:	b8 cb 95 10 80       	mov    $0x801095cb,%eax
80104ec1:	85 d2                	test   %edx,%edx
80104ec3:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104ec6:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104ec9:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104ecf:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104ed5:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104edb:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104ee1:	50                   	push   %eax
80104ee2:	52                   	push   %edx
80104ee3:	ff 73 10             	pushl  0x10(%ebx)
80104ee6:	68 74 96 10 80       	push   $0x80109674
80104eeb:	e8 70 b7 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104ef0:	83 c4 20             	add    $0x20,%esp
80104ef3:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104ef7:	0f 85 6b ff ff ff    	jne    80104e68 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104efd:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f00:	83 ec 08             	sub    $0x8,%esp
80104f03:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104f06:	50                   	push   %eax
80104f07:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f0a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f0d:	83 c0 08             	add    $0x8,%eax
80104f10:	50                   	push   %eax
80104f11:	e8 9a 01 00 00       	call   801050b0 <getcallerpcs>
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104f20:	8b 17                	mov    (%edi),%edx
80104f22:	85 d2                	test   %edx,%edx
80104f24:	0f 84 3e ff ff ff    	je     80104e68 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104f2a:	83 ec 08             	sub    $0x8,%esp
80104f2d:	83 c7 04             	add    $0x4,%edi
80104f30:	52                   	push   %edx
80104f31:	68 21 8f 10 80       	push   $0x80108f21
80104f36:	e8 25 b7 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104f3b:	83 c4 10             	add    $0x10,%esp
80104f3e:	39 fe                	cmp    %edi,%esi
80104f40:	75 de                	jne    80104f20 <procdump+0xd0>
80104f42:	e9 21 ff ff ff       	jmp    80104e68 <procdump+0x18>
80104f47:	89 f6                	mov    %esi,%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104f50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f53:	5b                   	pop    %ebx
80104f54:	5e                   	pop    %esi
80104f55:	5f                   	pop    %edi
80104f56:	5d                   	pop    %ebp
80104f57:	c3                   	ret    
80104f58:	66 90                	xchg   %ax,%ax
80104f5a:	66 90                	xchg   %ax,%ax
80104f5c:	66 90                	xchg   %ax,%ax
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	53                   	push   %ebx
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104f6a:	68 f4 96 10 80       	push   $0x801096f4
80104f6f:	8d 43 04             	lea    0x4(%ebx),%eax
80104f72:	50                   	push   %eax
80104f73:	e8 18 01 00 00       	call   80105090 <initlock>
  lk->name = name;
80104f78:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104f7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104f81:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104f84:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104f8b:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104f8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f91:	c9                   	leave  
80104f92:	c3                   	ret    
80104f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fa0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	56                   	push   %esi
80104fa4:	53                   	push   %ebx
80104fa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	8d 73 04             	lea    0x4(%ebx),%esi
80104fae:	56                   	push   %esi
80104faf:	e8 1c 02 00 00       	call   801051d0 <acquire>
  while (lk->locked) {
80104fb4:	8b 13                	mov    (%ebx),%edx
80104fb6:	83 c4 10             	add    $0x10,%esp
80104fb9:	85 d2                	test   %edx,%edx
80104fbb:	74 16                	je     80104fd3 <acquiresleep+0x33>
80104fbd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	56                   	push   %esi
80104fc4:	53                   	push   %ebx
80104fc5:	e8 b6 fa ff ff       	call   80104a80 <sleep>
  while (lk->locked) {
80104fca:	8b 03                	mov    (%ebx),%eax
80104fcc:	83 c4 10             	add    $0x10,%esp
80104fcf:	85 c0                	test   %eax,%eax
80104fd1:	75 ed                	jne    80104fc0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104fd3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104fd9:	e8 d2 f2 ff ff       	call   801042b0 <myproc>
80104fde:	8b 40 10             	mov    0x10(%eax),%eax
80104fe1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104fe4:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104fe7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fea:	5b                   	pop    %ebx
80104feb:	5e                   	pop    %esi
80104fec:	5d                   	pop    %ebp
  release(&lk->lk);
80104fed:	e9 9e 02 00 00       	jmp    80105290 <release>
80104ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
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
8010500f:	e8 bc 01 00 00       	call   801051d0 <acquire>
  lk->locked = 0;
80105014:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010501a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80105021:	89 1c 24             	mov    %ebx,(%esp)
80105024:	e8 97 fc ff ff       	call   80104cc0 <wakeup>
  release(&lk->lk);
80105029:	89 75 08             	mov    %esi,0x8(%ebp)
8010502c:	83 c4 10             	add    $0x10,%esp
}
8010502f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105032:	5b                   	pop    %ebx
80105033:	5e                   	pop    %esi
80105034:	5d                   	pop    %ebp
  release(&lk->lk);
80105035:	e9 56 02 00 00       	jmp    80105290 <release>
8010503a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105040 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	57                   	push   %edi
80105044:	56                   	push   %esi
80105045:	53                   	push   %ebx
80105046:	31 ff                	xor    %edi,%edi
80105048:	83 ec 18             	sub    $0x18,%esp
8010504b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010504e:	8d 73 04             	lea    0x4(%ebx),%esi
80105051:	56                   	push   %esi
80105052:	e8 79 01 00 00       	call   801051d0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80105057:	8b 03                	mov    (%ebx),%eax
80105059:	83 c4 10             	add    $0x10,%esp
8010505c:	85 c0                	test   %eax,%eax
8010505e:	74 13                	je     80105073 <holdingsleep+0x33>
80105060:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80105063:	e8 48 f2 ff ff       	call   801042b0 <myproc>
80105068:	39 58 10             	cmp    %ebx,0x10(%eax)
8010506b:	0f 94 c0             	sete   %al
8010506e:	0f b6 c0             	movzbl %al,%eax
80105071:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80105073:	83 ec 0c             	sub    $0xc,%esp
80105076:	56                   	push   %esi
80105077:	e8 14 02 00 00       	call   80105290 <release>
  return r;
}
8010507c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010507f:	89 f8                	mov    %edi,%eax
80105081:	5b                   	pop    %ebx
80105082:	5e                   	pop    %esi
80105083:	5f                   	pop    %edi
80105084:	5d                   	pop    %ebp
80105085:	c3                   	ret    
80105086:	66 90                	xchg   %ax,%ax
80105088:	66 90                	xchg   %ax,%ax
8010508a:	66 90                	xchg   %ax,%ax
8010508c:	66 90                	xchg   %ax,%ax
8010508e:	66 90                	xchg   %ax,%ax

80105090 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105096:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105099:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010509f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801050a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050a9:	5d                   	pop    %ebp
801050aa:	c3                   	ret    
801050ab:	90                   	nop
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801050b0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801050b1:	31 d2                	xor    %edx,%edx
{
801050b3:	89 e5                	mov    %esp,%ebp
801050b5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801050b6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801050b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801050bc:	83 e8 08             	sub    $0x8,%eax
801050bf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801050c0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801050c6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801050cc:	77 1a                	ja     801050e8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801050ce:	8b 58 04             	mov    0x4(%eax),%ebx
801050d1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801050d4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801050d7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801050d9:	83 fa 0a             	cmp    $0xa,%edx
801050dc:	75 e2                	jne    801050c0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801050de:	5b                   	pop    %ebx
801050df:	5d                   	pop    %ebp
801050e0:	c3                   	ret    
801050e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050e8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801050eb:	83 c1 28             	add    $0x28,%ecx
801050ee:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801050f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801050f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801050f9:	39 c1                	cmp    %eax,%ecx
801050fb:	75 f3                	jne    801050f0 <getcallerpcs+0x40>
}
801050fd:	5b                   	pop    %ebx
801050fe:	5d                   	pop    %ebp
801050ff:	c3                   	ret    

80105100 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	53                   	push   %ebx
80105104:	83 ec 04             	sub    $0x4,%esp
80105107:	9c                   	pushf  
80105108:	5b                   	pop    %ebx
  asm volatile("cli");
80105109:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010510a:	e8 01 f1 ff ff       	call   80104210 <mycpu>
8010510f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105115:	85 c0                	test   %eax,%eax
80105117:	75 11                	jne    8010512a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105119:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010511f:	e8 ec f0 ff ff       	call   80104210 <mycpu>
80105124:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010512a:	e8 e1 f0 ff ff       	call   80104210 <mycpu>
8010512f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80105136:	83 c4 04             	add    $0x4,%esp
80105139:	5b                   	pop    %ebx
8010513a:	5d                   	pop    %ebp
8010513b:	c3                   	ret    
8010513c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105140 <popcli>:

void
popcli(void)
{
80105140:	55                   	push   %ebp
80105141:	89 e5                	mov    %esp,%ebp
80105143:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105146:	9c                   	pushf  
80105147:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80105148:	f6 c4 02             	test   $0x2,%ah
8010514b:	75 35                	jne    80105182 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010514d:	e8 be f0 ff ff       	call   80104210 <mycpu>
80105152:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80105159:	78 34                	js     8010518f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010515b:	e8 b0 f0 ff ff       	call   80104210 <mycpu>
80105160:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105166:	85 d2                	test   %edx,%edx
80105168:	74 06                	je     80105170 <popcli+0x30>
    sti();
}
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105170:	e8 9b f0 ff ff       	call   80104210 <mycpu>
80105175:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010517b:	85 c0                	test   %eax,%eax
8010517d:	74 eb                	je     8010516a <popcli+0x2a>
  asm volatile("sti");
8010517f:	fb                   	sti    
}
80105180:	c9                   	leave  
80105181:	c3                   	ret    
    panic("popcli - interruptible");
80105182:	83 ec 0c             	sub    $0xc,%esp
80105185:	68 ff 96 10 80       	push   $0x801096ff
8010518a:	e8 01 b2 ff ff       	call   80100390 <panic>
    panic("popcli");
8010518f:	83 ec 0c             	sub    $0xc,%esp
80105192:	68 16 97 10 80       	push   $0x80109716
80105197:	e8 f4 b1 ff ff       	call   80100390 <panic>
8010519c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051a0 <holding>:
{
801051a0:	55                   	push   %ebp
801051a1:	89 e5                	mov    %esp,%ebp
801051a3:	56                   	push   %esi
801051a4:	53                   	push   %ebx
801051a5:	8b 75 08             	mov    0x8(%ebp),%esi
801051a8:	31 db                	xor    %ebx,%ebx
  pushcli();
801051aa:	e8 51 ff ff ff       	call   80105100 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051af:	8b 06                	mov    (%esi),%eax
801051b1:	85 c0                	test   %eax,%eax
801051b3:	74 10                	je     801051c5 <holding+0x25>
801051b5:	8b 5e 08             	mov    0x8(%esi),%ebx
801051b8:	e8 53 f0 ff ff       	call   80104210 <mycpu>
801051bd:	39 c3                	cmp    %eax,%ebx
801051bf:	0f 94 c3             	sete   %bl
801051c2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801051c5:	e8 76 ff ff ff       	call   80105140 <popcli>
}
801051ca:	89 d8                	mov    %ebx,%eax
801051cc:	5b                   	pop    %ebx
801051cd:	5e                   	pop    %esi
801051ce:	5d                   	pop    %ebp
801051cf:	c3                   	ret    

801051d0 <acquire>:
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801051d5:	e8 26 ff ff ff       	call   80105100 <pushcli>
  if(holding(lk))
801051da:	8b 5d 08             	mov    0x8(%ebp),%ebx
801051dd:	83 ec 0c             	sub    $0xc,%esp
801051e0:	53                   	push   %ebx
801051e1:	e8 ba ff ff ff       	call   801051a0 <holding>
801051e6:	83 c4 10             	add    $0x10,%esp
801051e9:	85 c0                	test   %eax,%eax
801051eb:	0f 85 83 00 00 00    	jne    80105274 <acquire+0xa4>
801051f1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801051f3:	ba 01 00 00 00       	mov    $0x1,%edx
801051f8:	eb 09                	jmp    80105203 <acquire+0x33>
801051fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105200:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105203:	89 d0                	mov    %edx,%eax
80105205:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105208:	85 c0                	test   %eax,%eax
8010520a:	75 f4                	jne    80105200 <acquire+0x30>
  __sync_synchronize();
8010520c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105211:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105214:	e8 f7 ef ff ff       	call   80104210 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105219:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010521c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010521f:	89 e8                	mov    %ebp,%eax
80105221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105228:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010522e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80105234:	77 1a                	ja     80105250 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80105236:	8b 48 04             	mov    0x4(%eax),%ecx
80105239:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010523c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010523f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105241:	83 fe 0a             	cmp    $0xa,%esi
80105244:	75 e2                	jne    80105228 <acquire+0x58>
}
80105246:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105249:	5b                   	pop    %ebx
8010524a:	5e                   	pop    %esi
8010524b:	5d                   	pop    %ebp
8010524c:	c3                   	ret    
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
80105250:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80105253:	83 c2 28             	add    $0x28,%edx
80105256:	8d 76 00             	lea    0x0(%esi),%esi
80105259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80105260:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105266:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105269:	39 d0                	cmp    %edx,%eax
8010526b:	75 f3                	jne    80105260 <acquire+0x90>
}
8010526d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105270:	5b                   	pop    %ebx
80105271:	5e                   	pop    %esi
80105272:	5d                   	pop    %ebp
80105273:	c3                   	ret    
    panic("acquire");
80105274:	83 ec 0c             	sub    $0xc,%esp
80105277:	68 1d 97 10 80       	push   $0x8010971d
8010527c:	e8 0f b1 ff ff       	call   80100390 <panic>
80105281:	eb 0d                	jmp    80105290 <release>
80105283:	90                   	nop
80105284:	90                   	nop
80105285:	90                   	nop
80105286:	90                   	nop
80105287:	90                   	nop
80105288:	90                   	nop
80105289:	90                   	nop
8010528a:	90                   	nop
8010528b:	90                   	nop
8010528c:	90                   	nop
8010528d:	90                   	nop
8010528e:	90                   	nop
8010528f:	90                   	nop

80105290 <release>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	53                   	push   %ebx
80105294:	83 ec 10             	sub    $0x10,%esp
80105297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010529a:	53                   	push   %ebx
8010529b:	e8 00 ff ff ff       	call   801051a0 <holding>
801052a0:	83 c4 10             	add    $0x10,%esp
801052a3:	85 c0                	test   %eax,%eax
801052a5:	74 22                	je     801052c9 <release+0x39>
  lk->pcs[0] = 0;
801052a7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801052ae:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801052b5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801052ba:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801052c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052c3:	c9                   	leave  
  popcli();
801052c4:	e9 77 fe ff ff       	jmp    80105140 <popcli>
    panic("release");
801052c9:	83 ec 0c             	sub    $0xc,%esp
801052cc:	68 25 97 10 80       	push   $0x80109725
801052d1:	e8 ba b0 ff ff       	call   80100390 <panic>
801052d6:	66 90                	xchg   %ax,%ax
801052d8:	66 90                	xchg   %ax,%ax
801052da:	66 90                	xchg   %ax,%ax
801052dc:	66 90                	xchg   %ax,%ax
801052de:	66 90                	xchg   %ax,%ax

801052e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	57                   	push   %edi
801052e4:	53                   	push   %ebx
801052e5:	8b 55 08             	mov    0x8(%ebp),%edx
801052e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801052eb:	f6 c2 03             	test   $0x3,%dl
801052ee:	75 05                	jne    801052f5 <memset+0x15>
801052f0:	f6 c1 03             	test   $0x3,%cl
801052f3:	74 13                	je     80105308 <memset+0x28>
  asm volatile("cld; rep stosb" :
801052f5:	89 d7                	mov    %edx,%edi
801052f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801052fa:	fc                   	cld    
801052fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801052fd:	5b                   	pop    %ebx
801052fe:	89 d0                	mov    %edx,%eax
80105300:	5f                   	pop    %edi
80105301:	5d                   	pop    %ebp
80105302:	c3                   	ret    
80105303:	90                   	nop
80105304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105308:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010530c:	c1 e9 02             	shr    $0x2,%ecx
8010530f:	89 f8                	mov    %edi,%eax
80105311:	89 fb                	mov    %edi,%ebx
80105313:	c1 e0 18             	shl    $0x18,%eax
80105316:	c1 e3 10             	shl    $0x10,%ebx
80105319:	09 d8                	or     %ebx,%eax
8010531b:	09 f8                	or     %edi,%eax
8010531d:	c1 e7 08             	shl    $0x8,%edi
80105320:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105322:	89 d7                	mov    %edx,%edi
80105324:	fc                   	cld    
80105325:	f3 ab                	rep stos %eax,%es:(%edi)
}
80105327:	5b                   	pop    %ebx
80105328:	89 d0                	mov    %edx,%eax
8010532a:	5f                   	pop    %edi
8010532b:	5d                   	pop    %ebp
8010532c:	c3                   	ret    
8010532d:	8d 76 00             	lea    0x0(%esi),%esi

80105330 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	57                   	push   %edi
80105334:	56                   	push   %esi
80105335:	53                   	push   %ebx
80105336:	8b 5d 10             	mov    0x10(%ebp),%ebx
80105339:	8b 75 08             	mov    0x8(%ebp),%esi
8010533c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010533f:	85 db                	test   %ebx,%ebx
80105341:	74 29                	je     8010536c <memcmp+0x3c>
    if(*s1 != *s2)
80105343:	0f b6 16             	movzbl (%esi),%edx
80105346:	0f b6 0f             	movzbl (%edi),%ecx
80105349:	38 d1                	cmp    %dl,%cl
8010534b:	75 2b                	jne    80105378 <memcmp+0x48>
8010534d:	b8 01 00 00 00       	mov    $0x1,%eax
80105352:	eb 14                	jmp    80105368 <memcmp+0x38>
80105354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105358:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010535c:	83 c0 01             	add    $0x1,%eax
8010535f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80105364:	38 ca                	cmp    %cl,%dl
80105366:	75 10                	jne    80105378 <memcmp+0x48>
  while(n-- > 0){
80105368:	39 d8                	cmp    %ebx,%eax
8010536a:	75 ec                	jne    80105358 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010536c:	5b                   	pop    %ebx
  return 0;
8010536d:	31 c0                	xor    %eax,%eax
}
8010536f:	5e                   	pop    %esi
80105370:	5f                   	pop    %edi
80105371:	5d                   	pop    %ebp
80105372:	c3                   	ret    
80105373:	90                   	nop
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80105378:	0f b6 c2             	movzbl %dl,%eax
}
8010537b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010537c:	29 c8                	sub    %ecx,%eax
}
8010537e:	5e                   	pop    %esi
8010537f:	5f                   	pop    %edi
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    
80105382:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105390 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	56                   	push   %esi
80105394:	53                   	push   %ebx
80105395:	8b 45 08             	mov    0x8(%ebp),%eax
80105398:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010539b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010539e:	39 c3                	cmp    %eax,%ebx
801053a0:	73 26                	jae    801053c8 <memmove+0x38>
801053a2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801053a5:	39 c8                	cmp    %ecx,%eax
801053a7:	73 1f                	jae    801053c8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801053a9:	85 f6                	test   %esi,%esi
801053ab:	8d 56 ff             	lea    -0x1(%esi),%edx
801053ae:	74 0f                	je     801053bf <memmove+0x2f>
      *--d = *--s;
801053b0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801053b4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801053b7:	83 ea 01             	sub    $0x1,%edx
801053ba:	83 fa ff             	cmp    $0xffffffff,%edx
801053bd:	75 f1                	jne    801053b0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801053bf:	5b                   	pop    %ebx
801053c0:	5e                   	pop    %esi
801053c1:	5d                   	pop    %ebp
801053c2:	c3                   	ret    
801053c3:	90                   	nop
801053c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801053c8:	31 d2                	xor    %edx,%edx
801053ca:	85 f6                	test   %esi,%esi
801053cc:	74 f1                	je     801053bf <memmove+0x2f>
801053ce:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801053d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801053d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801053d7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801053da:	39 d6                	cmp    %edx,%esi
801053dc:	75 f2                	jne    801053d0 <memmove+0x40>
}
801053de:	5b                   	pop    %ebx
801053df:	5e                   	pop    %esi
801053e0:	5d                   	pop    %ebp
801053e1:	c3                   	ret    
801053e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801053f3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801053f4:	eb 9a                	jmp    80105390 <memmove>
801053f6:	8d 76 00             	lea    0x0(%esi),%esi
801053f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105400 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	8b 7d 10             	mov    0x10(%ebp),%edi
80105408:	53                   	push   %ebx
80105409:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010540c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010540f:	85 ff                	test   %edi,%edi
80105411:	74 2f                	je     80105442 <strncmp+0x42>
80105413:	0f b6 01             	movzbl (%ecx),%eax
80105416:	0f b6 1e             	movzbl (%esi),%ebx
80105419:	84 c0                	test   %al,%al
8010541b:	74 37                	je     80105454 <strncmp+0x54>
8010541d:	38 c3                	cmp    %al,%bl
8010541f:	75 33                	jne    80105454 <strncmp+0x54>
80105421:	01 f7                	add    %esi,%edi
80105423:	eb 13                	jmp    80105438 <strncmp+0x38>
80105425:	8d 76 00             	lea    0x0(%esi),%esi
80105428:	0f b6 01             	movzbl (%ecx),%eax
8010542b:	84 c0                	test   %al,%al
8010542d:	74 21                	je     80105450 <strncmp+0x50>
8010542f:	0f b6 1a             	movzbl (%edx),%ebx
80105432:	89 d6                	mov    %edx,%esi
80105434:	38 d8                	cmp    %bl,%al
80105436:	75 1c                	jne    80105454 <strncmp+0x54>
    n--, p++, q++;
80105438:	8d 56 01             	lea    0x1(%esi),%edx
8010543b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010543e:	39 fa                	cmp    %edi,%edx
80105440:	75 e6                	jne    80105428 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80105442:	5b                   	pop    %ebx
    return 0;
80105443:	31 c0                	xor    %eax,%eax
}
80105445:	5e                   	pop    %esi
80105446:	5f                   	pop    %edi
80105447:	5d                   	pop    %ebp
80105448:	c3                   	ret    
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105450:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80105454:	29 d8                	sub    %ebx,%eax
}
80105456:	5b                   	pop    %ebx
80105457:	5e                   	pop    %esi
80105458:	5f                   	pop    %edi
80105459:	5d                   	pop    %ebp
8010545a:	c3                   	ret    
8010545b:	90                   	nop
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
80105465:	8b 45 08             	mov    0x8(%ebp),%eax
80105468:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010546b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010546e:	89 c2                	mov    %eax,%edx
80105470:	eb 19                	jmp    8010548b <strncpy+0x2b>
80105472:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105478:	83 c3 01             	add    $0x1,%ebx
8010547b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010547f:	83 c2 01             	add    $0x1,%edx
80105482:	84 c9                	test   %cl,%cl
80105484:	88 4a ff             	mov    %cl,-0x1(%edx)
80105487:	74 09                	je     80105492 <strncpy+0x32>
80105489:	89 f1                	mov    %esi,%ecx
8010548b:	85 c9                	test   %ecx,%ecx
8010548d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105490:	7f e6                	jg     80105478 <strncpy+0x18>
    ;
  while(n-- > 0)
80105492:	31 c9                	xor    %ecx,%ecx
80105494:	85 f6                	test   %esi,%esi
80105496:	7e 17                	jle    801054af <strncpy+0x4f>
80105498:	90                   	nop
80105499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801054a0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801054a4:	89 f3                	mov    %esi,%ebx
801054a6:	83 c1 01             	add    $0x1,%ecx
801054a9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801054ab:	85 db                	test   %ebx,%ebx
801054ad:	7f f1                	jg     801054a0 <strncpy+0x40>
  return os;
}
801054af:	5b                   	pop    %ebx
801054b0:	5e                   	pop    %esi
801054b1:	5d                   	pop    %ebp
801054b2:	c3                   	ret    
801054b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	56                   	push   %esi
801054c4:	53                   	push   %ebx
801054c5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801054c8:	8b 45 08             	mov    0x8(%ebp),%eax
801054cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801054ce:	85 c9                	test   %ecx,%ecx
801054d0:	7e 26                	jle    801054f8 <safestrcpy+0x38>
801054d2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801054d6:	89 c1                	mov    %eax,%ecx
801054d8:	eb 17                	jmp    801054f1 <safestrcpy+0x31>
801054da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801054e0:	83 c2 01             	add    $0x1,%edx
801054e3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801054e7:	83 c1 01             	add    $0x1,%ecx
801054ea:	84 db                	test   %bl,%bl
801054ec:	88 59 ff             	mov    %bl,-0x1(%ecx)
801054ef:	74 04                	je     801054f5 <safestrcpy+0x35>
801054f1:	39 f2                	cmp    %esi,%edx
801054f3:	75 eb                	jne    801054e0 <safestrcpy+0x20>
    ;
  *s = 0;
801054f5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801054f8:	5b                   	pop    %ebx
801054f9:	5e                   	pop    %esi
801054fa:	5d                   	pop    %ebp
801054fb:	c3                   	ret    
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <strlen>:

int
strlen(const char *s)
{
80105500:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105501:	31 c0                	xor    %eax,%eax
{
80105503:	89 e5                	mov    %esp,%ebp
80105505:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105508:	80 3a 00             	cmpb   $0x0,(%edx)
8010550b:	74 0c                	je     80105519 <strlen+0x19>
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
80105510:	83 c0 01             	add    $0x1,%eax
80105513:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105517:	75 f7                	jne    80105510 <strlen+0x10>
    ;
  return n;
}
80105519:	5d                   	pop    %ebp
8010551a:	c3                   	ret    

8010551b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010551b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010551f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105523:	55                   	push   %ebp
  pushl %ebx
80105524:	53                   	push   %ebx
  pushl %esi
80105525:	56                   	push   %esi
  pushl %edi
80105526:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105527:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105529:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010552b:	5f                   	pop    %edi
  popl %esi
8010552c:	5e                   	pop    %esi
  popl %ebx
8010552d:	5b                   	pop    %ebx
  popl %ebp
8010552e:	5d                   	pop    %ebp
  ret
8010552f:	c3                   	ret    

80105530 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
80105534:	83 ec 04             	sub    $0x4,%esp
80105537:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010553a:	e8 71 ed ff ff       	call   801042b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010553f:	8b 00                	mov    (%eax),%eax
80105541:	39 d8                	cmp    %ebx,%eax
80105543:	76 1b                	jbe    80105560 <fetchint+0x30>
80105545:	8d 53 04             	lea    0x4(%ebx),%edx
80105548:	39 d0                	cmp    %edx,%eax
8010554a:	72 14                	jb     80105560 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010554c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010554f:	8b 13                	mov    (%ebx),%edx
80105551:	89 10                	mov    %edx,(%eax)
  return 0;
80105553:	31 c0                	xor    %eax,%eax
}
80105555:	83 c4 04             	add    $0x4,%esp
80105558:	5b                   	pop    %ebx
80105559:	5d                   	pop    %ebp
8010555a:	c3                   	ret    
8010555b:	90                   	nop
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105565:	eb ee                	jmp    80105555 <fetchint+0x25>
80105567:	89 f6                	mov    %esi,%esi
80105569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105570 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	53                   	push   %ebx
80105574:	83 ec 04             	sub    $0x4,%esp
80105577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010557a:	e8 31 ed ff ff       	call   801042b0 <myproc>

  if(addr >= curproc->sz)
8010557f:	39 18                	cmp    %ebx,(%eax)
80105581:	76 29                	jbe    801055ac <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105586:	89 da                	mov    %ebx,%edx
80105588:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010558a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010558c:	39 c3                	cmp    %eax,%ebx
8010558e:	73 1c                	jae    801055ac <fetchstr+0x3c>
    if(*s == 0)
80105590:	80 3b 00             	cmpb   $0x0,(%ebx)
80105593:	75 10                	jne    801055a5 <fetchstr+0x35>
80105595:	eb 39                	jmp    801055d0 <fetchstr+0x60>
80105597:	89 f6                	mov    %esi,%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055a0:	80 3a 00             	cmpb   $0x0,(%edx)
801055a3:	74 1b                	je     801055c0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801055a5:	83 c2 01             	add    $0x1,%edx
801055a8:	39 d0                	cmp    %edx,%eax
801055aa:	77 f4                	ja     801055a0 <fetchstr+0x30>
    return -1;
801055ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801055b1:	83 c4 04             	add    $0x4,%esp
801055b4:	5b                   	pop    %ebx
801055b5:	5d                   	pop    %ebp
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801055c0:	83 c4 04             	add    $0x4,%esp
801055c3:	89 d0                	mov    %edx,%eax
801055c5:	29 d8                	sub    %ebx,%eax
801055c7:	5b                   	pop    %ebx
801055c8:	5d                   	pop    %ebp
801055c9:	c3                   	ret    
801055ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801055d0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801055d2:	eb dd                	jmp    801055b1 <fetchstr+0x41>
801055d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801055da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801055e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055e5:	e8 c6 ec ff ff       	call   801042b0 <myproc>
801055ea:	8b 40 18             	mov    0x18(%eax),%eax
801055ed:	8b 55 08             	mov    0x8(%ebp),%edx
801055f0:	8b 40 44             	mov    0x44(%eax),%eax
801055f3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801055f6:	e8 b5 ec ff ff       	call   801042b0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055fb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801055fd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105600:	39 c6                	cmp    %eax,%esi
80105602:	73 1c                	jae    80105620 <argint+0x40>
80105604:	8d 53 08             	lea    0x8(%ebx),%edx
80105607:	39 d0                	cmp    %edx,%eax
80105609:	72 15                	jb     80105620 <argint+0x40>
  *ip = *(int*)(addr);
8010560b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010560e:	8b 53 04             	mov    0x4(%ebx),%edx
80105611:	89 10                	mov    %edx,(%eax)
  return 0;
80105613:	31 c0                	xor    %eax,%eax
}
80105615:	5b                   	pop    %ebx
80105616:	5e                   	pop    %esi
80105617:	5d                   	pop    %ebp
80105618:	c3                   	ret    
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105625:	eb ee                	jmp    80105615 <argint+0x35>
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	56                   	push   %esi
80105634:	53                   	push   %ebx
80105635:	83 ec 10             	sub    $0x10,%esp
80105638:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010563b:	e8 70 ec ff ff       	call   801042b0 <myproc>
80105640:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105642:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105645:	83 ec 08             	sub    $0x8,%esp
80105648:	50                   	push   %eax
80105649:	ff 75 08             	pushl  0x8(%ebp)
8010564c:	e8 8f ff ff ff       	call   801055e0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	85 c0                	test   %eax,%eax
80105656:	78 28                	js     80105680 <argptr+0x50>
80105658:	85 db                	test   %ebx,%ebx
8010565a:	78 24                	js     80105680 <argptr+0x50>
8010565c:	8b 16                	mov    (%esi),%edx
8010565e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105661:	39 c2                	cmp    %eax,%edx
80105663:	76 1b                	jbe    80105680 <argptr+0x50>
80105665:	01 c3                	add    %eax,%ebx
80105667:	39 da                	cmp    %ebx,%edx
80105669:	72 15                	jb     80105680 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010566b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010566e:	89 02                	mov    %eax,(%edx)
  return 0;
80105670:	31 c0                	xor    %eax,%eax
}
80105672:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105675:	5b                   	pop    %ebx
80105676:	5e                   	pop    %esi
80105677:	5d                   	pop    %ebp
80105678:	c3                   	ret    
80105679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105685:	eb eb                	jmp    80105672 <argptr+0x42>
80105687:	89 f6                	mov    %esi,%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105690 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105696:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105699:	50                   	push   %eax
8010569a:	ff 75 08             	pushl  0x8(%ebp)
8010569d:	e8 3e ff ff ff       	call   801055e0 <argint>
801056a2:	83 c4 10             	add    $0x10,%esp
801056a5:	85 c0                	test   %eax,%eax
801056a7:	78 17                	js     801056c0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801056a9:	83 ec 08             	sub    $0x8,%esp
801056ac:	ff 75 0c             	pushl  0xc(%ebp)
801056af:	ff 75 f4             	pushl  -0xc(%ebp)
801056b2:	e8 b9 fe ff ff       	call   80105570 <fetchstr>
801056b7:	83 c4 10             	add    $0x10,%esp
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056d0 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	53                   	push   %ebx
801056d4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801056d7:	e8 d4 eb ff ff       	call   801042b0 <myproc>
801056dc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801056de:	8b 40 18             	mov    0x18(%eax),%eax
801056e1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801056e4:	8d 50 ff             	lea    -0x1(%eax),%edx
801056e7:	83 fa 16             	cmp    $0x16,%edx
801056ea:	77 1c                	ja     80105708 <syscall+0x38>
801056ec:	8b 14 85 60 97 10 80 	mov    -0x7fef68a0(,%eax,4),%edx
801056f3:	85 d2                	test   %edx,%edx
801056f5:	74 11                	je     80105708 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801056f7:	ff d2                	call   *%edx
801056f9:	8b 53 18             	mov    0x18(%ebx),%edx
801056fc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801056ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105702:	c9                   	leave  
80105703:	c3                   	ret    
80105704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105708:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105709:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010570c:	50                   	push   %eax
8010570d:	ff 73 10             	pushl  0x10(%ebx)
80105710:	68 2d 97 10 80       	push   $0x8010972d
80105715:	e8 46 af ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010571a:	8b 43 18             	mov    0x18(%ebx),%eax
8010571d:	83 c4 10             	add    $0x10,%esp
80105720:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105727:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010572a:	c9                   	leave  
8010572b:	c3                   	ret    
8010572c:	66 90                	xchg   %ax,%ax
8010572e:	66 90                	xchg   %ax,%ax

80105730 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	56                   	push   %esi
80105734:	53                   	push   %ebx
80105735:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105737:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010573a:	89 d6                	mov    %edx,%esi
8010573c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010573f:	50                   	push   %eax
80105740:	6a 00                	push   $0x0
80105742:	e8 99 fe ff ff       	call   801055e0 <argint>
80105747:	83 c4 10             	add    $0x10,%esp
8010574a:	85 c0                	test   %eax,%eax
8010574c:	78 2a                	js     80105778 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010574e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105752:	77 24                	ja     80105778 <argfd.constprop.0+0x48>
80105754:	e8 57 eb ff ff       	call   801042b0 <myproc>
80105759:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010575c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105760:	85 c0                	test   %eax,%eax
80105762:	74 14                	je     80105778 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80105764:	85 db                	test   %ebx,%ebx
80105766:	74 02                	je     8010576a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105768:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
8010576a:	89 06                	mov    %eax,(%esi)
  return 0;
8010576c:	31 c0                	xor    %eax,%eax
}
8010576e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105771:	5b                   	pop    %ebx
80105772:	5e                   	pop    %esi
80105773:	5d                   	pop    %ebp
80105774:	c3                   	ret    
80105775:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577d:	eb ef                	jmp    8010576e <argfd.constprop.0+0x3e>
8010577f:	90                   	nop

80105780 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105780:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105781:	31 c0                	xor    %eax,%eax
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	56                   	push   %esi
80105786:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105787:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010578a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010578d:	e8 9e ff ff ff       	call   80105730 <argfd.constprop.0>
80105792:	85 c0                	test   %eax,%eax
80105794:	78 42                	js     801057d8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105796:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105799:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010579b:	e8 10 eb ff ff       	call   801042b0 <myproc>
801057a0:	eb 0e                	jmp    801057b0 <sys_dup+0x30>
801057a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057a8:	83 c3 01             	add    $0x1,%ebx
801057ab:	83 fb 10             	cmp    $0x10,%ebx
801057ae:	74 28                	je     801057d8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801057b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801057b4:	85 d2                	test   %edx,%edx
801057b6:	75 f0                	jne    801057a8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801057b8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	ff 75 f4             	pushl  -0xc(%ebp)
801057c2:	e8 d9 b9 ff ff       	call   801011a0 <filedup>
  return fd;
801057c7:	83 c4 10             	add    $0x10,%esp
}
801057ca:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057cd:	89 d8                	mov    %ebx,%eax
801057cf:	5b                   	pop    %ebx
801057d0:	5e                   	pop    %esi
801057d1:	5d                   	pop    %ebp
801057d2:	c3                   	ret    
801057d3:	90                   	nop
801057d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801057db:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801057e0:	89 d8                	mov    %ebx,%eax
801057e2:	5b                   	pop    %ebx
801057e3:	5e                   	pop    %esi
801057e4:	5d                   	pop    %ebp
801057e5:	c3                   	ret    
801057e6:	8d 76 00             	lea    0x0(%esi),%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <sys_read>:

int
sys_read(void)
{
801057f0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057f1:	31 c0                	xor    %eax,%eax
{
801057f3:	89 e5                	mov    %esp,%ebp
801057f5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057f8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801057fb:	e8 30 ff ff ff       	call   80105730 <argfd.constprop.0>
80105800:	85 c0                	test   %eax,%eax
80105802:	78 4c                	js     80105850 <sys_read+0x60>
80105804:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105807:	83 ec 08             	sub    $0x8,%esp
8010580a:	50                   	push   %eax
8010580b:	6a 02                	push   $0x2
8010580d:	e8 ce fd ff ff       	call   801055e0 <argint>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	78 37                	js     80105850 <sys_read+0x60>
80105819:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010581c:	83 ec 04             	sub    $0x4,%esp
8010581f:	ff 75 f0             	pushl  -0x10(%ebp)
80105822:	50                   	push   %eax
80105823:	6a 01                	push   $0x1
80105825:	e8 06 fe ff ff       	call   80105630 <argptr>
8010582a:	83 c4 10             	add    $0x10,%esp
8010582d:	85 c0                	test   %eax,%eax
8010582f:	78 1f                	js     80105850 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80105831:	83 ec 04             	sub    $0x4,%esp
80105834:	ff 75 f0             	pushl  -0x10(%ebp)
80105837:	ff 75 f4             	pushl  -0xc(%ebp)
8010583a:	ff 75 ec             	pushl  -0x14(%ebp)
8010583d:	e8 ce ba ff ff       	call   80101310 <fileread>
80105842:	83 c4 10             	add    $0x10,%esp
}
80105845:	c9                   	leave  
80105846:	c3                   	ret    
80105847:	89 f6                	mov    %esi,%esi
80105849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105850:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105855:	c9                   	leave  
80105856:	c3                   	ret    
80105857:	89 f6                	mov    %esi,%esi
80105859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105860 <sys_write>:

int
sys_write(void)
{
80105860:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105861:	31 c0                	xor    %eax,%eax
{
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105868:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010586b:	e8 c0 fe ff ff       	call   80105730 <argfd.constprop.0>
80105870:	85 c0                	test   %eax,%eax
80105872:	78 4c                	js     801058c0 <sys_write+0x60>
80105874:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105877:	83 ec 08             	sub    $0x8,%esp
8010587a:	50                   	push   %eax
8010587b:	6a 02                	push   $0x2
8010587d:	e8 5e fd ff ff       	call   801055e0 <argint>
80105882:	83 c4 10             	add    $0x10,%esp
80105885:	85 c0                	test   %eax,%eax
80105887:	78 37                	js     801058c0 <sys_write+0x60>
80105889:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010588c:	83 ec 04             	sub    $0x4,%esp
8010588f:	ff 75 f0             	pushl  -0x10(%ebp)
80105892:	50                   	push   %eax
80105893:	6a 01                	push   $0x1
80105895:	e8 96 fd ff ff       	call   80105630 <argptr>
8010589a:	83 c4 10             	add    $0x10,%esp
8010589d:	85 c0                	test   %eax,%eax
8010589f:	78 1f                	js     801058c0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
801058a1:	83 ec 04             	sub    $0x4,%esp
801058a4:	ff 75 f0             	pushl  -0x10(%ebp)
801058a7:	ff 75 f4             	pushl  -0xc(%ebp)
801058aa:	ff 75 ec             	pushl  -0x14(%ebp)
801058ad:	e8 ee ba ff ff       	call   801013a0 <filewrite>
801058b2:	83 c4 10             	add    $0x10,%esp
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058c5:	c9                   	leave  
801058c6:	c3                   	ret    
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058d0 <sys_close>:

int
sys_close(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801058d6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801058d9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058dc:	e8 4f fe ff ff       	call   80105730 <argfd.constprop.0>
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 2b                	js     80105910 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801058e5:	e8 c6 e9 ff ff       	call   801042b0 <myproc>
801058ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801058ed:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801058f0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801058f7:	00 
  fileclose(f);
801058f8:	ff 75 f4             	pushl  -0xc(%ebp)
801058fb:	e8 f0 b8 ff ff       	call   801011f0 <fileclose>
  return 0;
80105900:	83 c4 10             	add    $0x10,%esp
80105903:	31 c0                	xor    %eax,%eax
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

80105920 <sys_fstat>:

int
sys_fstat(void)
{
80105920:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105921:	31 c0                	xor    %eax,%eax
{
80105923:	89 e5                	mov    %esp,%ebp
80105925:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105928:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010592b:	e8 00 fe ff ff       	call   80105730 <argfd.constprop.0>
80105930:	85 c0                	test   %eax,%eax
80105932:	78 2c                	js     80105960 <sys_fstat+0x40>
80105934:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105937:	83 ec 04             	sub    $0x4,%esp
8010593a:	6a 14                	push   $0x14
8010593c:	50                   	push   %eax
8010593d:	6a 01                	push   $0x1
8010593f:	e8 ec fc ff ff       	call   80105630 <argptr>
80105944:	83 c4 10             	add    $0x10,%esp
80105947:	85 c0                	test   %eax,%eax
80105949:	78 15                	js     80105960 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010594b:	83 ec 08             	sub    $0x8,%esp
8010594e:	ff 75 f4             	pushl  -0xc(%ebp)
80105951:	ff 75 f0             	pushl  -0x10(%ebp)
80105954:	e8 67 b9 ff ff       	call   801012c0 <filestat>
80105959:	83 c4 10             	add    $0x10,%esp
}
8010595c:	c9                   	leave  
8010595d:	c3                   	ret    
8010595e:	66 90                	xchg   %ax,%ax
    return -1;
80105960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105970 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	57                   	push   %edi
80105974:	56                   	push   %esi
80105975:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105976:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105979:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010597c:	50                   	push   %eax
8010597d:	6a 00                	push   $0x0
8010597f:	e8 0c fd ff ff       	call   80105690 <argstr>
80105984:	83 c4 10             	add    $0x10,%esp
80105987:	85 c0                	test   %eax,%eax
80105989:	0f 88 fb 00 00 00    	js     80105a8a <sys_link+0x11a>
8010598f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105992:	83 ec 08             	sub    $0x8,%esp
80105995:	50                   	push   %eax
80105996:	6a 01                	push   $0x1
80105998:	e8 f3 fc ff ff       	call   80105690 <argstr>
8010599d:	83 c4 10             	add    $0x10,%esp
801059a0:	85 c0                	test   %eax,%eax
801059a2:	0f 88 e2 00 00 00    	js     80105a8a <sys_link+0x11a>
    return -1;

  begin_op();
801059a8:	e8 93 db ff ff       	call   80103540 <begin_op>
  if((ip = namei(old)) == 0){
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	ff 75 d4             	pushl  -0x2c(%ebp)
801059b3:	e8 d8 c8 ff ff       	call   80102290 <namei>
801059b8:	83 c4 10             	add    $0x10,%esp
801059bb:	85 c0                	test   %eax,%eax
801059bd:	89 c3                	mov    %eax,%ebx
801059bf:	0f 84 ea 00 00 00    	je     80105aaf <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
801059c5:	83 ec 0c             	sub    $0xc,%esp
801059c8:	50                   	push   %eax
801059c9:	e8 62 c0 ff ff       	call   80101a30 <ilock>
  if(ip->type == T_DIR){
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059d6:	0f 84 bb 00 00 00    	je     80105a97 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
801059dc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801059e1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801059e4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801059e7:	53                   	push   %ebx
801059e8:	e8 93 bf ff ff       	call   80101980 <iupdate>
  iunlock(ip);
801059ed:	89 1c 24             	mov    %ebx,(%esp)
801059f0:	e8 1b c1 ff ff       	call   80101b10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801059f5:	58                   	pop    %eax
801059f6:	5a                   	pop    %edx
801059f7:	57                   	push   %edi
801059f8:	ff 75 d0             	pushl  -0x30(%ebp)
801059fb:	e8 b0 c8 ff ff       	call   801022b0 <nameiparent>
80105a00:	83 c4 10             	add    $0x10,%esp
80105a03:	85 c0                	test   %eax,%eax
80105a05:	89 c6                	mov    %eax,%esi
80105a07:	74 5b                	je     80105a64 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a09:	83 ec 0c             	sub    $0xc,%esp
80105a0c:	50                   	push   %eax
80105a0d:	e8 1e c0 ff ff       	call   80101a30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a12:	83 c4 10             	add    $0x10,%esp
80105a15:	8b 03                	mov    (%ebx),%eax
80105a17:	39 06                	cmp    %eax,(%esi)
80105a19:	75 3d                	jne    80105a58 <sys_link+0xe8>
80105a1b:	83 ec 04             	sub    $0x4,%esp
80105a1e:	ff 73 04             	pushl  0x4(%ebx)
80105a21:	57                   	push   %edi
80105a22:	56                   	push   %esi
80105a23:	e8 a8 c7 ff ff       	call   801021d0 <dirlink>
80105a28:	83 c4 10             	add    $0x10,%esp
80105a2b:	85 c0                	test   %eax,%eax
80105a2d:	78 29                	js     80105a58 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105a2f:	83 ec 0c             	sub    $0xc,%esp
80105a32:	56                   	push   %esi
80105a33:	e8 88 c2 ff ff       	call   80101cc0 <iunlockput>
  iput(ip);
80105a38:	89 1c 24             	mov    %ebx,(%esp)
80105a3b:	e8 20 c1 ff ff       	call   80101b60 <iput>

  end_op();
80105a40:	e8 6b db ff ff       	call   801035b0 <end_op>

  return 0;
80105a45:	83 c4 10             	add    $0x10,%esp
80105a48:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105a4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a4d:	5b                   	pop    %ebx
80105a4e:	5e                   	pop    %esi
80105a4f:	5f                   	pop    %edi
80105a50:	5d                   	pop    %ebp
80105a51:	c3                   	ret    
80105a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a58:	83 ec 0c             	sub    $0xc,%esp
80105a5b:	56                   	push   %esi
80105a5c:	e8 5f c2 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105a61:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a64:	83 ec 0c             	sub    $0xc,%esp
80105a67:	53                   	push   %ebx
80105a68:	e8 c3 bf ff ff       	call   80101a30 <ilock>
  ip->nlink--;
80105a6d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a72:	89 1c 24             	mov    %ebx,(%esp)
80105a75:	e8 06 bf ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105a7a:	89 1c 24             	mov    %ebx,(%esp)
80105a7d:	e8 3e c2 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105a82:	e8 29 db ff ff       	call   801035b0 <end_op>
  return -1;
80105a87:	83 c4 10             	add    $0x10,%esp
}
80105a8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a92:	5b                   	pop    %ebx
80105a93:	5e                   	pop    %esi
80105a94:	5f                   	pop    %edi
80105a95:	5d                   	pop    %ebp
80105a96:	c3                   	ret    
    iunlockput(ip);
80105a97:	83 ec 0c             	sub    $0xc,%esp
80105a9a:	53                   	push   %ebx
80105a9b:	e8 20 c2 ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105aa0:	e8 0b db ff ff       	call   801035b0 <end_op>
    return -1;
80105aa5:	83 c4 10             	add    $0x10,%esp
80105aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aad:	eb 9b                	jmp    80105a4a <sys_link+0xda>
    end_op();
80105aaf:	e8 fc da ff ff       	call   801035b0 <end_op>
    return -1;
80105ab4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab9:	eb 8f                	jmp    80105a4a <sys_link+0xda>
80105abb:	90                   	nop
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105ac0:	55                   	push   %ebp
80105ac1:	89 e5                	mov    %esp,%ebp
80105ac3:	57                   	push   %edi
80105ac4:	56                   	push   %esi
80105ac5:	53                   	push   %ebx
80105ac6:	83 ec 1c             	sub    $0x1c,%esp
80105ac9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105acc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105ad0:	76 3e                	jbe    80105b10 <isdirempty+0x50>
80105ad2:	bb 20 00 00 00       	mov    $0x20,%ebx
80105ad7:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105ada:	eb 0c                	jmp    80105ae8 <isdirempty+0x28>
80105adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ae0:	83 c3 10             	add    $0x10,%ebx
80105ae3:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105ae6:	73 28                	jae    80105b10 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105ae8:	6a 10                	push   $0x10
80105aea:	53                   	push   %ebx
80105aeb:	57                   	push   %edi
80105aec:	56                   	push   %esi
80105aed:	e8 1e c2 ff ff       	call   80101d10 <readi>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	83 f8 10             	cmp    $0x10,%eax
80105af8:	75 23                	jne    80105b1d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105afa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105aff:	74 df                	je     80105ae0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105b04:	31 c0                	xor    %eax,%eax
}
80105b06:	5b                   	pop    %ebx
80105b07:	5e                   	pop    %esi
80105b08:	5f                   	pop    %edi
80105b09:	5d                   	pop    %ebp
80105b0a:	c3                   	ret    
80105b0b:	90                   	nop
80105b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105b13:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b18:	5b                   	pop    %ebx
80105b19:	5e                   	pop    %esi
80105b1a:	5f                   	pop    %edi
80105b1b:	5d                   	pop    %ebp
80105b1c:	c3                   	ret    
      panic("isdirempty: readi");
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	68 c0 97 10 80       	push   $0x801097c0
80105b25:	e8 66 a8 ff ff       	call   80100390 <panic>
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b30 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	57                   	push   %edi
80105b34:	56                   	push   %esi
80105b35:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b36:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105b39:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105b3c:	50                   	push   %eax
80105b3d:	6a 00                	push   $0x0
80105b3f:	e8 4c fb ff ff       	call   80105690 <argstr>
80105b44:	83 c4 10             	add    $0x10,%esp
80105b47:	85 c0                	test   %eax,%eax
80105b49:	0f 88 51 01 00 00    	js     80105ca0 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105b4f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105b52:	e8 e9 d9 ff ff       	call   80103540 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105b57:	83 ec 08             	sub    $0x8,%esp
80105b5a:	53                   	push   %ebx
80105b5b:	ff 75 c0             	pushl  -0x40(%ebp)
80105b5e:	e8 4d c7 ff ff       	call   801022b0 <nameiparent>
80105b63:	83 c4 10             	add    $0x10,%esp
80105b66:	85 c0                	test   %eax,%eax
80105b68:	89 c6                	mov    %eax,%esi
80105b6a:	0f 84 37 01 00 00    	je     80105ca7 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105b70:	83 ec 0c             	sub    $0xc,%esp
80105b73:	50                   	push   %eax
80105b74:	e8 b7 be ff ff       	call   80101a30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105b79:	58                   	pop    %eax
80105b7a:	5a                   	pop    %edx
80105b7b:	68 ab 90 10 80       	push   $0x801090ab
80105b80:	53                   	push   %ebx
80105b81:	e8 ba c3 ff ff       	call   80101f40 <namecmp>
80105b86:	83 c4 10             	add    $0x10,%esp
80105b89:	85 c0                	test   %eax,%eax
80105b8b:	0f 84 d7 00 00 00    	je     80105c68 <sys_unlink+0x138>
80105b91:	83 ec 08             	sub    $0x8,%esp
80105b94:	68 aa 90 10 80       	push   $0x801090aa
80105b99:	53                   	push   %ebx
80105b9a:	e8 a1 c3 ff ff       	call   80101f40 <namecmp>
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	85 c0                	test   %eax,%eax
80105ba4:	0f 84 be 00 00 00    	je     80105c68 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105baa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105bad:	83 ec 04             	sub    $0x4,%esp
80105bb0:	50                   	push   %eax
80105bb1:	53                   	push   %ebx
80105bb2:	56                   	push   %esi
80105bb3:	e8 a8 c3 ff ff       	call   80101f60 <dirlookup>
80105bb8:	83 c4 10             	add    $0x10,%esp
80105bbb:	85 c0                	test   %eax,%eax
80105bbd:	89 c3                	mov    %eax,%ebx
80105bbf:	0f 84 a3 00 00 00    	je     80105c68 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105bc5:	83 ec 0c             	sub    $0xc,%esp
80105bc8:	50                   	push   %eax
80105bc9:	e8 62 be ff ff       	call   80101a30 <ilock>

  if(ip->nlink < 1)
80105bce:	83 c4 10             	add    $0x10,%esp
80105bd1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105bd6:	0f 8e e4 00 00 00    	jle    80105cc0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105be1:	74 65                	je     80105c48 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105be3:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105be6:	83 ec 04             	sub    $0x4,%esp
80105be9:	6a 10                	push   $0x10
80105beb:	6a 00                	push   $0x0
80105bed:	57                   	push   %edi
80105bee:	e8 ed f6 ff ff       	call   801052e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bf3:	6a 10                	push   $0x10
80105bf5:	ff 75 c4             	pushl  -0x3c(%ebp)
80105bf8:	57                   	push   %edi
80105bf9:	56                   	push   %esi
80105bfa:	e8 11 c2 ff ff       	call   80101e10 <writei>
80105bff:	83 c4 20             	add    $0x20,%esp
80105c02:	83 f8 10             	cmp    $0x10,%eax
80105c05:	0f 85 a8 00 00 00    	jne    80105cb3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c0b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c10:	74 6e                	je     80105c80 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c12:	83 ec 0c             	sub    $0xc,%esp
80105c15:	56                   	push   %esi
80105c16:	e8 a5 c0 ff ff       	call   80101cc0 <iunlockput>

  ip->nlink--;
80105c1b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105c20:	89 1c 24             	mov    %ebx,(%esp)
80105c23:	e8 58 bd ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105c28:	89 1c 24             	mov    %ebx,(%esp)
80105c2b:	e8 90 c0 ff ff       	call   80101cc0 <iunlockput>

  end_op();
80105c30:	e8 7b d9 ff ff       	call   801035b0 <end_op>

  return 0;
80105c35:	83 c4 10             	add    $0x10,%esp
80105c38:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c3d:	5b                   	pop    %ebx
80105c3e:	5e                   	pop    %esi
80105c3f:	5f                   	pop    %edi
80105c40:	5d                   	pop    %ebp
80105c41:	c3                   	ret    
80105c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c48:	83 ec 0c             	sub    $0xc,%esp
80105c4b:	53                   	push   %ebx
80105c4c:	e8 6f fe ff ff       	call   80105ac0 <isdirempty>
80105c51:	83 c4 10             	add    $0x10,%esp
80105c54:	85 c0                	test   %eax,%eax
80105c56:	75 8b                	jne    80105be3 <sys_unlink+0xb3>
    iunlockput(ip);
80105c58:	83 ec 0c             	sub    $0xc,%esp
80105c5b:	53                   	push   %ebx
80105c5c:	e8 5f c0 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105c61:	83 c4 10             	add    $0x10,%esp
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105c68:	83 ec 0c             	sub    $0xc,%esp
80105c6b:	56                   	push   %esi
80105c6c:	e8 4f c0 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105c71:	e8 3a d9 ff ff       	call   801035b0 <end_op>
  return -1;
80105c76:	83 c4 10             	add    $0x10,%esp
80105c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c7e:	eb ba                	jmp    80105c3a <sys_unlink+0x10a>
    dp->nlink--;
80105c80:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105c85:	83 ec 0c             	sub    $0xc,%esp
80105c88:	56                   	push   %esi
80105c89:	e8 f2 bc ff ff       	call   80101980 <iupdate>
80105c8e:	83 c4 10             	add    $0x10,%esp
80105c91:	e9 7c ff ff ff       	jmp    80105c12 <sys_unlink+0xe2>
80105c96:	8d 76 00             	lea    0x0(%esi),%esi
80105c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca5:	eb 93                	jmp    80105c3a <sys_unlink+0x10a>
    end_op();
80105ca7:	e8 04 d9 ff ff       	call   801035b0 <end_op>
    return -1;
80105cac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cb1:	eb 87                	jmp    80105c3a <sys_unlink+0x10a>
    panic("unlink: writei");
80105cb3:	83 ec 0c             	sub    $0xc,%esp
80105cb6:	68 bf 90 10 80       	push   $0x801090bf
80105cbb:	e8 d0 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105cc0:	83 ec 0c             	sub    $0xc,%esp
80105cc3:	68 ad 90 10 80       	push   $0x801090ad
80105cc8:	e8 c3 a6 ff ff       	call   80100390 <panic>
80105ccd:	8d 76 00             	lea    0x0(%esi),%esi

80105cd0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	57                   	push   %edi
80105cd4:	56                   	push   %esi
80105cd5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105cd6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105cd9:	83 ec 34             	sub    $0x34,%esp
80105cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cdf:	8b 55 10             	mov    0x10(%ebp),%edx
80105ce2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105ce5:	56                   	push   %esi
80105ce6:	ff 75 08             	pushl  0x8(%ebp)
{
80105ce9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105cec:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105cef:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105cf2:	e8 b9 c5 ff ff       	call   801022b0 <nameiparent>
80105cf7:	83 c4 10             	add    $0x10,%esp
80105cfa:	85 c0                	test   %eax,%eax
80105cfc:	0f 84 4e 01 00 00    	je     80105e50 <create+0x180>
    return 0;
  ilock(dp);
80105d02:	83 ec 0c             	sub    $0xc,%esp
80105d05:	89 c3                	mov    %eax,%ebx
80105d07:	50                   	push   %eax
80105d08:	e8 23 bd ff ff       	call   80101a30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d0d:	83 c4 0c             	add    $0xc,%esp
80105d10:	6a 00                	push   $0x0
80105d12:	56                   	push   %esi
80105d13:	53                   	push   %ebx
80105d14:	e8 47 c2 ff ff       	call   80101f60 <dirlookup>
80105d19:	83 c4 10             	add    $0x10,%esp
80105d1c:	85 c0                	test   %eax,%eax
80105d1e:	89 c7                	mov    %eax,%edi
80105d20:	74 3e                	je     80105d60 <create+0x90>
    iunlockput(dp);
80105d22:	83 ec 0c             	sub    $0xc,%esp
80105d25:	53                   	push   %ebx
80105d26:	e8 95 bf ff ff       	call   80101cc0 <iunlockput>
    ilock(ip);
80105d2b:	89 3c 24             	mov    %edi,(%esp)
80105d2e:	e8 fd bc ff ff       	call   80101a30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105d33:	83 c4 10             	add    $0x10,%esp
80105d36:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105d3b:	0f 85 9f 00 00 00    	jne    80105de0 <create+0x110>
80105d41:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105d46:	0f 85 94 00 00 00    	jne    80105de0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105d4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d4f:	89 f8                	mov    %edi,%eax
80105d51:	5b                   	pop    %ebx
80105d52:	5e                   	pop    %esi
80105d53:	5f                   	pop    %edi
80105d54:	5d                   	pop    %ebp
80105d55:	c3                   	ret    
80105d56:	8d 76 00             	lea    0x0(%esi),%esi
80105d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105d60:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105d64:	83 ec 08             	sub    $0x8,%esp
80105d67:	50                   	push   %eax
80105d68:	ff 33                	pushl  (%ebx)
80105d6a:	e8 51 bb ff ff       	call   801018c0 <ialloc>
80105d6f:	83 c4 10             	add    $0x10,%esp
80105d72:	85 c0                	test   %eax,%eax
80105d74:	89 c7                	mov    %eax,%edi
80105d76:	0f 84 e8 00 00 00    	je     80105e64 <create+0x194>
  ilock(ip);
80105d7c:	83 ec 0c             	sub    $0xc,%esp
80105d7f:	50                   	push   %eax
80105d80:	e8 ab bc ff ff       	call   80101a30 <ilock>
  ip->major = major;
80105d85:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105d89:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105d8d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105d91:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105d95:	b8 01 00 00 00       	mov    $0x1,%eax
80105d9a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105d9e:	89 3c 24             	mov    %edi,(%esp)
80105da1:	e8 da bb ff ff       	call   80101980 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105da6:	83 c4 10             	add    $0x10,%esp
80105da9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105dae:	74 50                	je     80105e00 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105db0:	83 ec 04             	sub    $0x4,%esp
80105db3:	ff 77 04             	pushl  0x4(%edi)
80105db6:	56                   	push   %esi
80105db7:	53                   	push   %ebx
80105db8:	e8 13 c4 ff ff       	call   801021d0 <dirlink>
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	0f 88 8f 00 00 00    	js     80105e57 <create+0x187>
  iunlockput(dp);
80105dc8:	83 ec 0c             	sub    $0xc,%esp
80105dcb:	53                   	push   %ebx
80105dcc:	e8 ef be ff ff       	call   80101cc0 <iunlockput>
  return ip;
80105dd1:	83 c4 10             	add    $0x10,%esp
}
80105dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dd7:	89 f8                	mov    %edi,%eax
80105dd9:	5b                   	pop    %ebx
80105dda:	5e                   	pop    %esi
80105ddb:	5f                   	pop    %edi
80105ddc:	5d                   	pop    %ebp
80105ddd:	c3                   	ret    
80105dde:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105de0:	83 ec 0c             	sub    $0xc,%esp
80105de3:	57                   	push   %edi
    return 0;
80105de4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105de6:	e8 d5 be ff ff       	call   80101cc0 <iunlockput>
    return 0;
80105deb:	83 c4 10             	add    $0x10,%esp
}
80105dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105df1:	89 f8                	mov    %edi,%eax
80105df3:	5b                   	pop    %ebx
80105df4:	5e                   	pop    %esi
80105df5:	5f                   	pop    %edi
80105df6:	5d                   	pop    %ebp
80105df7:	c3                   	ret    
80105df8:	90                   	nop
80105df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105e00:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e05:	83 ec 0c             	sub    $0xc,%esp
80105e08:	53                   	push   %ebx
80105e09:	e8 72 bb ff ff       	call   80101980 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e0e:	83 c4 0c             	add    $0xc,%esp
80105e11:	ff 77 04             	pushl  0x4(%edi)
80105e14:	68 ab 90 10 80       	push   $0x801090ab
80105e19:	57                   	push   %edi
80105e1a:	e8 b1 c3 ff ff       	call   801021d0 <dirlink>
80105e1f:	83 c4 10             	add    $0x10,%esp
80105e22:	85 c0                	test   %eax,%eax
80105e24:	78 1c                	js     80105e42 <create+0x172>
80105e26:	83 ec 04             	sub    $0x4,%esp
80105e29:	ff 73 04             	pushl  0x4(%ebx)
80105e2c:	68 aa 90 10 80       	push   $0x801090aa
80105e31:	57                   	push   %edi
80105e32:	e8 99 c3 ff ff       	call   801021d0 <dirlink>
80105e37:	83 c4 10             	add    $0x10,%esp
80105e3a:	85 c0                	test   %eax,%eax
80105e3c:	0f 89 6e ff ff ff    	jns    80105db0 <create+0xe0>
      panic("create dots");
80105e42:	83 ec 0c             	sub    $0xc,%esp
80105e45:	68 e1 97 10 80       	push   $0x801097e1
80105e4a:	e8 41 a5 ff ff       	call   80100390 <panic>
80105e4f:	90                   	nop
    return 0;
80105e50:	31 ff                	xor    %edi,%edi
80105e52:	e9 f5 fe ff ff       	jmp    80105d4c <create+0x7c>
    panic("create: dirlink");
80105e57:	83 ec 0c             	sub    $0xc,%esp
80105e5a:	68 ed 97 10 80       	push   $0x801097ed
80105e5f:	e8 2c a5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105e64:	83 ec 0c             	sub    $0xc,%esp
80105e67:	68 d2 97 10 80       	push   $0x801097d2
80105e6c:	e8 1f a5 ff ff       	call   80100390 <panic>
80105e71:	eb 0d                	jmp    80105e80 <sys_open>
80105e73:	90                   	nop
80105e74:	90                   	nop
80105e75:	90                   	nop
80105e76:	90                   	nop
80105e77:	90                   	nop
80105e78:	90                   	nop
80105e79:	90                   	nop
80105e7a:	90                   	nop
80105e7b:	90                   	nop
80105e7c:	90                   	nop
80105e7d:	90                   	nop
80105e7e:	90                   	nop
80105e7f:	90                   	nop

80105e80 <sys_open>:

int
sys_open(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	57                   	push   %edi
80105e84:	56                   	push   %esi
80105e85:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e86:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105e89:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105e8c:	50                   	push   %eax
80105e8d:	6a 00                	push   $0x0
80105e8f:	e8 fc f7 ff ff       	call   80105690 <argstr>
80105e94:	83 c4 10             	add    $0x10,%esp
80105e97:	85 c0                	test   %eax,%eax
80105e99:	0f 88 1d 01 00 00    	js     80105fbc <sys_open+0x13c>
80105e9f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ea2:	83 ec 08             	sub    $0x8,%esp
80105ea5:	50                   	push   %eax
80105ea6:	6a 01                	push   $0x1
80105ea8:	e8 33 f7 ff ff       	call   801055e0 <argint>
80105ead:	83 c4 10             	add    $0x10,%esp
80105eb0:	85 c0                	test   %eax,%eax
80105eb2:	0f 88 04 01 00 00    	js     80105fbc <sys_open+0x13c>
    return -1;

  begin_op();
80105eb8:	e8 83 d6 ff ff       	call   80103540 <begin_op>

  if(omode & O_CREATE){
80105ebd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ec1:	0f 85 a9 00 00 00    	jne    80105f70 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ec7:	83 ec 0c             	sub    $0xc,%esp
80105eca:	ff 75 e0             	pushl  -0x20(%ebp)
80105ecd:	e8 be c3 ff ff       	call   80102290 <namei>
80105ed2:	83 c4 10             	add    $0x10,%esp
80105ed5:	85 c0                	test   %eax,%eax
80105ed7:	89 c6                	mov    %eax,%esi
80105ed9:	0f 84 ac 00 00 00    	je     80105f8b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105edf:	83 ec 0c             	sub    $0xc,%esp
80105ee2:	50                   	push   %eax
80105ee3:	e8 48 bb ff ff       	call   80101a30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ee8:	83 c4 10             	add    $0x10,%esp
80105eeb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105ef0:	0f 84 aa 00 00 00    	je     80105fa0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105ef6:	e8 35 b2 ff ff       	call   80101130 <filealloc>
80105efb:	85 c0                	test   %eax,%eax
80105efd:	89 c7                	mov    %eax,%edi
80105eff:	0f 84 a6 00 00 00    	je     80105fab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105f05:	e8 a6 e3 ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f0a:	31 db                	xor    %ebx,%ebx
80105f0c:	eb 0e                	jmp    80105f1c <sys_open+0x9c>
80105f0e:	66 90                	xchg   %ax,%ax
80105f10:	83 c3 01             	add    $0x1,%ebx
80105f13:	83 fb 10             	cmp    $0x10,%ebx
80105f16:	0f 84 ac 00 00 00    	je     80105fc8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105f1c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105f20:	85 d2                	test   %edx,%edx
80105f22:	75 ec                	jne    80105f10 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f24:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105f27:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105f2b:	56                   	push   %esi
80105f2c:	e8 df bb ff ff       	call   80101b10 <iunlock>
  end_op();
80105f31:	e8 7a d6 ff ff       	call   801035b0 <end_op>

  f->type = FD_INODE;
80105f36:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105f3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f3f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105f42:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105f45:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105f4c:	89 d0                	mov    %edx,%eax
80105f4e:	f7 d0                	not    %eax
80105f50:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f53:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105f56:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105f59:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f60:	89 d8                	mov    %ebx,%eax
80105f62:	5b                   	pop    %ebx
80105f63:	5e                   	pop    %esi
80105f64:	5f                   	pop    %edi
80105f65:	5d                   	pop    %ebp
80105f66:	c3                   	ret    
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105f70:	6a 00                	push   $0x0
80105f72:	6a 00                	push   $0x0
80105f74:	6a 02                	push   $0x2
80105f76:	ff 75 e0             	pushl  -0x20(%ebp)
80105f79:	e8 52 fd ff ff       	call   80105cd0 <create>
    if(ip == 0){
80105f7e:	83 c4 10             	add    $0x10,%esp
80105f81:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105f83:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105f85:	0f 85 6b ff ff ff    	jne    80105ef6 <sys_open+0x76>
      end_op();
80105f8b:	e8 20 d6 ff ff       	call   801035b0 <end_op>
      return -1;
80105f90:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f95:	eb c6                	jmp    80105f5d <sys_open+0xdd>
80105f97:	89 f6                	mov    %esi,%esi
80105f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fa0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105fa3:	85 c9                	test   %ecx,%ecx
80105fa5:	0f 84 4b ff ff ff    	je     80105ef6 <sys_open+0x76>
    iunlockput(ip);
80105fab:	83 ec 0c             	sub    $0xc,%esp
80105fae:	56                   	push   %esi
80105faf:	e8 0c bd ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105fb4:	e8 f7 d5 ff ff       	call   801035b0 <end_op>
    return -1;
80105fb9:	83 c4 10             	add    $0x10,%esp
80105fbc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105fc1:	eb 9a                	jmp    80105f5d <sys_open+0xdd>
80105fc3:	90                   	nop
80105fc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	57                   	push   %edi
80105fcc:	e8 1f b2 ff ff       	call   801011f0 <fileclose>
80105fd1:	83 c4 10             	add    $0x10,%esp
80105fd4:	eb d5                	jmp    80105fab <sys_open+0x12b>
80105fd6:	8d 76 00             	lea    0x0(%esi),%esi
80105fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fe0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105fe0:	55                   	push   %ebp
80105fe1:	89 e5                	mov    %esp,%ebp
80105fe3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105fe6:	e8 55 d5 ff ff       	call   80103540 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105feb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fee:	83 ec 08             	sub    $0x8,%esp
80105ff1:	50                   	push   %eax
80105ff2:	6a 00                	push   $0x0
80105ff4:	e8 97 f6 ff ff       	call   80105690 <argstr>
80105ff9:	83 c4 10             	add    $0x10,%esp
80105ffc:	85 c0                	test   %eax,%eax
80105ffe:	78 30                	js     80106030 <sys_mkdir+0x50>
80106000:	6a 00                	push   $0x0
80106002:	6a 00                	push   $0x0
80106004:	6a 01                	push   $0x1
80106006:	ff 75 f4             	pushl  -0xc(%ebp)
80106009:	e8 c2 fc ff ff       	call   80105cd0 <create>
8010600e:	83 c4 10             	add    $0x10,%esp
80106011:	85 c0                	test   %eax,%eax
80106013:	74 1b                	je     80106030 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106015:	83 ec 0c             	sub    $0xc,%esp
80106018:	50                   	push   %eax
80106019:	e8 a2 bc ff ff       	call   80101cc0 <iunlockput>
  end_op();
8010601e:	e8 8d d5 ff ff       	call   801035b0 <end_op>
  return 0;
80106023:	83 c4 10             	add    $0x10,%esp
80106026:	31 c0                	xor    %eax,%eax
}
80106028:	c9                   	leave  
80106029:	c3                   	ret    
8010602a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106030:	e8 7b d5 ff ff       	call   801035b0 <end_op>
    return -1;
80106035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010603a:	c9                   	leave  
8010603b:	c3                   	ret    
8010603c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106040 <sys_mknod>:

int
sys_mknod(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80106046:	e8 f5 d4 ff ff       	call   80103540 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010604b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010604e:	83 ec 08             	sub    $0x8,%esp
80106051:	50                   	push   %eax
80106052:	6a 00                	push   $0x0
80106054:	e8 37 f6 ff ff       	call   80105690 <argstr>
80106059:	83 c4 10             	add    $0x10,%esp
8010605c:	85 c0                	test   %eax,%eax
8010605e:	78 60                	js     801060c0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106060:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106063:	83 ec 08             	sub    $0x8,%esp
80106066:	50                   	push   %eax
80106067:	6a 01                	push   $0x1
80106069:	e8 72 f5 ff ff       	call   801055e0 <argint>
  if((argstr(0, &path)) < 0 ||
8010606e:	83 c4 10             	add    $0x10,%esp
80106071:	85 c0                	test   %eax,%eax
80106073:	78 4b                	js     801060c0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80106075:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106078:	83 ec 08             	sub    $0x8,%esp
8010607b:	50                   	push   %eax
8010607c:	6a 02                	push   $0x2
8010607e:	e8 5d f5 ff ff       	call   801055e0 <argint>
     argint(1, &major) < 0 ||
80106083:	83 c4 10             	add    $0x10,%esp
80106086:	85 c0                	test   %eax,%eax
80106088:	78 36                	js     801060c0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010608a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010608e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010608f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106093:	50                   	push   %eax
80106094:	6a 03                	push   $0x3
80106096:	ff 75 ec             	pushl  -0x14(%ebp)
80106099:	e8 32 fc ff ff       	call   80105cd0 <create>
8010609e:	83 c4 10             	add    $0x10,%esp
801060a1:	85 c0                	test   %eax,%eax
801060a3:	74 1b                	je     801060c0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801060a5:	83 ec 0c             	sub    $0xc,%esp
801060a8:	50                   	push   %eax
801060a9:	e8 12 bc ff ff       	call   80101cc0 <iunlockput>
  end_op();
801060ae:	e8 fd d4 ff ff       	call   801035b0 <end_op>
  return 0;
801060b3:	83 c4 10             	add    $0x10,%esp
801060b6:	31 c0                	xor    %eax,%eax
}
801060b8:	c9                   	leave  
801060b9:	c3                   	ret    
801060ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801060c0:	e8 eb d4 ff ff       	call   801035b0 <end_op>
    return -1;
801060c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ca:	c9                   	leave  
801060cb:	c3                   	ret    
801060cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060d0 <sys_chdir>:

int
sys_chdir(void)
{
801060d0:	55                   	push   %ebp
801060d1:	89 e5                	mov    %esp,%ebp
801060d3:	56                   	push   %esi
801060d4:	53                   	push   %ebx
801060d5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801060d8:	e8 d3 e1 ff ff       	call   801042b0 <myproc>
801060dd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801060df:	e8 5c d4 ff ff       	call   80103540 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801060e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060e7:	83 ec 08             	sub    $0x8,%esp
801060ea:	50                   	push   %eax
801060eb:	6a 00                	push   $0x0
801060ed:	e8 9e f5 ff ff       	call   80105690 <argstr>
801060f2:	83 c4 10             	add    $0x10,%esp
801060f5:	85 c0                	test   %eax,%eax
801060f7:	78 77                	js     80106170 <sys_chdir+0xa0>
801060f9:	83 ec 0c             	sub    $0xc,%esp
801060fc:	ff 75 f4             	pushl  -0xc(%ebp)
801060ff:	e8 8c c1 ff ff       	call   80102290 <namei>
80106104:	83 c4 10             	add    $0x10,%esp
80106107:	85 c0                	test   %eax,%eax
80106109:	89 c3                	mov    %eax,%ebx
8010610b:	74 63                	je     80106170 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010610d:	83 ec 0c             	sub    $0xc,%esp
80106110:	50                   	push   %eax
80106111:	e8 1a b9 ff ff       	call   80101a30 <ilock>
  if(ip->type != T_DIR){
80106116:	83 c4 10             	add    $0x10,%esp
80106119:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010611e:	75 30                	jne    80106150 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80106120:	83 ec 0c             	sub    $0xc,%esp
80106123:	53                   	push   %ebx
80106124:	e8 e7 b9 ff ff       	call   80101b10 <iunlock>
  iput(curproc->cwd);
80106129:	58                   	pop    %eax
8010612a:	ff 76 68             	pushl  0x68(%esi)
8010612d:	e8 2e ba ff ff       	call   80101b60 <iput>
  end_op();
80106132:	e8 79 d4 ff ff       	call   801035b0 <end_op>
  curproc->cwd = ip;
80106137:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010613a:	83 c4 10             	add    $0x10,%esp
8010613d:	31 c0                	xor    %eax,%eax
}
8010613f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106142:	5b                   	pop    %ebx
80106143:	5e                   	pop    %esi
80106144:	5d                   	pop    %ebp
80106145:	c3                   	ret    
80106146:	8d 76 00             	lea    0x0(%esi),%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80106150:	83 ec 0c             	sub    $0xc,%esp
80106153:	53                   	push   %ebx
80106154:	e8 67 bb ff ff       	call   80101cc0 <iunlockput>
    end_op();
80106159:	e8 52 d4 ff ff       	call   801035b0 <end_op>
    return -1;
8010615e:	83 c4 10             	add    $0x10,%esp
80106161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106166:	eb d7                	jmp    8010613f <sys_chdir+0x6f>
80106168:	90                   	nop
80106169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80106170:	e8 3b d4 ff ff       	call   801035b0 <end_op>
    return -1;
80106175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010617a:	eb c3                	jmp    8010613f <sys_chdir+0x6f>
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106180 <sys_exec>:

int
sys_exec(void)
{
80106180:	55                   	push   %ebp
80106181:	89 e5                	mov    %esp,%ebp
80106183:	57                   	push   %edi
80106184:	56                   	push   %esi
80106185:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106186:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010618c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106192:	50                   	push   %eax
80106193:	6a 00                	push   $0x0
80106195:	e8 f6 f4 ff ff       	call   80105690 <argstr>
8010619a:	83 c4 10             	add    $0x10,%esp
8010619d:	85 c0                	test   %eax,%eax
8010619f:	0f 88 87 00 00 00    	js     8010622c <sys_exec+0xac>
801061a5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801061ab:	83 ec 08             	sub    $0x8,%esp
801061ae:	50                   	push   %eax
801061af:	6a 01                	push   $0x1
801061b1:	e8 2a f4 ff ff       	call   801055e0 <argint>
801061b6:	83 c4 10             	add    $0x10,%esp
801061b9:	85 c0                	test   %eax,%eax
801061bb:	78 6f                	js     8010622c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801061bd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801061c3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801061c6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801061c8:	68 80 00 00 00       	push   $0x80
801061cd:	6a 00                	push   $0x0
801061cf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801061d5:	50                   	push   %eax
801061d6:	e8 05 f1 ff ff       	call   801052e0 <memset>
801061db:	83 c4 10             	add    $0x10,%esp
801061de:	eb 2c                	jmp    8010620c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801061e0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801061e6:	85 c0                	test   %eax,%eax
801061e8:	74 56                	je     80106240 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801061ea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801061f0:	83 ec 08             	sub    $0x8,%esp
801061f3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801061f6:	52                   	push   %edx
801061f7:	50                   	push   %eax
801061f8:	e8 73 f3 ff ff       	call   80105570 <fetchstr>
801061fd:	83 c4 10             	add    $0x10,%esp
80106200:	85 c0                	test   %eax,%eax
80106202:	78 28                	js     8010622c <sys_exec+0xac>
  for(i=0;; i++){
80106204:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106207:	83 fb 20             	cmp    $0x20,%ebx
8010620a:	74 20                	je     8010622c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010620c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106212:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106219:	83 ec 08             	sub    $0x8,%esp
8010621c:	57                   	push   %edi
8010621d:	01 f0                	add    %esi,%eax
8010621f:	50                   	push   %eax
80106220:	e8 0b f3 ff ff       	call   80105530 <fetchint>
80106225:	83 c4 10             	add    $0x10,%esp
80106228:	85 c0                	test   %eax,%eax
8010622a:	79 b4                	jns    801061e0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010622c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010622f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106234:	5b                   	pop    %ebx
80106235:	5e                   	pop    %esi
80106236:	5f                   	pop    %edi
80106237:	5d                   	pop    %ebp
80106238:	c3                   	ret    
80106239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106240:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106246:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80106249:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106250:	00 00 00 00 
  return exec(path, argv);
80106254:	50                   	push   %eax
80106255:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010625b:	e8 00 aa ff ff       	call   80100c60 <exec>
80106260:	83 c4 10             	add    $0x10,%esp
}
80106263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106266:	5b                   	pop    %ebx
80106267:	5e                   	pop    %esi
80106268:	5f                   	pop    %edi
80106269:	5d                   	pop    %ebp
8010626a:	c3                   	ret    
8010626b:	90                   	nop
8010626c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106270 <sys_pipe>:

int
sys_pipe(void)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
80106273:	57                   	push   %edi
80106274:	56                   	push   %esi
80106275:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106276:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80106279:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010627c:	6a 08                	push   $0x8
8010627e:	50                   	push   %eax
8010627f:	6a 00                	push   $0x0
80106281:	e8 aa f3 ff ff       	call   80105630 <argptr>
80106286:	83 c4 10             	add    $0x10,%esp
80106289:	85 c0                	test   %eax,%eax
8010628b:	0f 88 ae 00 00 00    	js     8010633f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106291:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106294:	83 ec 08             	sub    $0x8,%esp
80106297:	50                   	push   %eax
80106298:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010629b:	50                   	push   %eax
8010629c:	e8 3f d9 ff ff       	call   80103be0 <pipealloc>
801062a1:	83 c4 10             	add    $0x10,%esp
801062a4:	85 c0                	test   %eax,%eax
801062a6:	0f 88 93 00 00 00    	js     8010633f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062ac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801062af:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801062b1:	e8 fa df ff ff       	call   801042b0 <myproc>
801062b6:	eb 10                	jmp    801062c8 <sys_pipe+0x58>
801062b8:	90                   	nop
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801062c0:	83 c3 01             	add    $0x1,%ebx
801062c3:	83 fb 10             	cmp    $0x10,%ebx
801062c6:	74 60                	je     80106328 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801062c8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801062cc:	85 f6                	test   %esi,%esi
801062ce:	75 f0                	jne    801062c0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801062d0:	8d 73 08             	lea    0x8(%ebx),%esi
801062d3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801062d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801062da:	e8 d1 df ff ff       	call   801042b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801062df:	31 d2                	xor    %edx,%edx
801062e1:	eb 0d                	jmp    801062f0 <sys_pipe+0x80>
801062e3:	90                   	nop
801062e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062e8:	83 c2 01             	add    $0x1,%edx
801062eb:	83 fa 10             	cmp    $0x10,%edx
801062ee:	74 28                	je     80106318 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801062f0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801062f4:	85 c9                	test   %ecx,%ecx
801062f6:	75 f0                	jne    801062e8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801062f8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801062fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
801062ff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106301:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106304:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106307:	31 c0                	xor    %eax,%eax
}
80106309:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010630c:	5b                   	pop    %ebx
8010630d:	5e                   	pop    %esi
8010630e:	5f                   	pop    %edi
8010630f:	5d                   	pop    %ebp
80106310:	c3                   	ret    
80106311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106318:	e8 93 df ff ff       	call   801042b0 <myproc>
8010631d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106324:	00 
80106325:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80106328:	83 ec 0c             	sub    $0xc,%esp
8010632b:	ff 75 e0             	pushl  -0x20(%ebp)
8010632e:	e8 bd ae ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
80106333:	58                   	pop    %eax
80106334:	ff 75 e4             	pushl  -0x1c(%ebp)
80106337:	e8 b4 ae ff ff       	call   801011f0 <fileclose>
    return -1;
8010633c:	83 c4 10             	add    $0x10,%esp
8010633f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106344:	eb c3                	jmp    80106309 <sys_pipe+0x99>
80106346:	66 90                	xchg   %ax,%ax
80106348:	66 90                	xchg   %ax,%ax
8010634a:	66 90                	xchg   %ax,%ax
8010634c:	66 90                	xchg   %ax,%ax
8010634e:	66 90                	xchg   %ax,%ax

80106350 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106350:	55                   	push   %ebp
80106351:	89 e5                	mov    %esp,%ebp
  return fork();
}
80106353:	5d                   	pop    %ebp
  return fork();
80106354:	e9 07 e1 ff ff       	jmp    80104460 <fork>
80106359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106360 <sys_exit>:

int
sys_exit(void)
{
80106360:	55                   	push   %ebp
80106361:	89 e5                	mov    %esp,%ebp
80106363:	83 ec 08             	sub    $0x8,%esp
  exit();
80106366:	e8 65 e5 ff ff       	call   801048d0 <exit>
  return 0;  // not reached
}
8010636b:	31 c0                	xor    %eax,%eax
8010636d:	c9                   	leave  
8010636e:	c3                   	ret    
8010636f:	90                   	nop

80106370 <sys_wait>:

int
sys_wait(void)
{
80106370:	55                   	push   %ebp
80106371:	89 e5                	mov    %esp,%ebp
  return wait();
}
80106373:	5d                   	pop    %ebp
  return wait();
80106374:	e9 c7 e7 ff ff       	jmp    80104b40 <wait>
80106379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106380 <sys_kill>:

int
sys_kill(void)
{
80106380:	55                   	push   %ebp
80106381:	89 e5                	mov    %esp,%ebp
80106383:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106386:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106389:	50                   	push   %eax
8010638a:	6a 00                	push   $0x0
8010638c:	e8 4f f2 ff ff       	call   801055e0 <argint>
80106391:	83 c4 10             	add    $0x10,%esp
80106394:	85 c0                	test   %eax,%eax
80106396:	78 18                	js     801063b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106398:	83 ec 0c             	sub    $0xc,%esp
8010639b:	ff 75 f4             	pushl  -0xc(%ebp)
8010639e:	e8 7d e9 ff ff       	call   80104d20 <kill>
801063a3:	83 c4 10             	add    $0x10,%esp
}
801063a6:	c9                   	leave  
801063a7:	c3                   	ret    
801063a8:	90                   	nop
801063a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063b5:	c9                   	leave  
801063b6:	c3                   	ret    
801063b7:	89 f6                	mov    %esi,%esi
801063b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801063c0 <sys_getpid>:

int
sys_getpid(void)
{
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801063c6:	e8 e5 de ff ff       	call   801042b0 <myproc>
801063cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801063ce:	c9                   	leave  
801063cf:	c3                   	ret    

801063d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801063d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801063d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801063da:	50                   	push   %eax
801063db:	6a 00                	push   $0x0
801063dd:	e8 fe f1 ff ff       	call   801055e0 <argint>
801063e2:	83 c4 10             	add    $0x10,%esp
801063e5:	85 c0                	test   %eax,%eax
801063e7:	78 27                	js     80106410 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801063e9:	e8 c2 de ff ff       	call   801042b0 <myproc>
  if(growproc(n) < 0)
801063ee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801063f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801063f3:	ff 75 f4             	pushl  -0xc(%ebp)
801063f6:	e8 d5 df ff ff       	call   801043d0 <growproc>
801063fb:	83 c4 10             	add    $0x10,%esp
801063fe:	85 c0                	test   %eax,%eax
80106400:	78 0e                	js     80106410 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106402:	89 d8                	mov    %ebx,%eax
80106404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106407:	c9                   	leave  
80106408:	c3                   	ret    
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106410:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106415:	eb eb                	jmp    80106402 <sys_sbrk+0x32>
80106417:	89 f6                	mov    %esi,%esi
80106419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106420 <sys_sleep>:

int
sys_sleep(void)
{
80106420:	55                   	push   %ebp
80106421:	89 e5                	mov    %esp,%ebp
80106423:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106424:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106427:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010642a:	50                   	push   %eax
8010642b:	6a 00                	push   $0x0
8010642d:	e8 ae f1 ff ff       	call   801055e0 <argint>
80106432:	83 c4 10             	add    $0x10,%esp
80106435:	85 c0                	test   %eax,%eax
80106437:	0f 88 8a 00 00 00    	js     801064c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010643d:	83 ec 0c             	sub    $0xc,%esp
80106440:	68 40 6d 19 80       	push   $0x80196d40
80106445:	e8 86 ed ff ff       	call   801051d0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010644a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010644d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80106450:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  while(ticks - ticks0 < n){
80106456:	85 d2                	test   %edx,%edx
80106458:	75 27                	jne    80106481 <sys_sleep+0x61>
8010645a:	eb 54                	jmp    801064b0 <sys_sleep+0x90>
8010645c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106460:	83 ec 08             	sub    $0x8,%esp
80106463:	68 40 6d 19 80       	push   $0x80196d40
80106468:	68 80 75 19 80       	push   $0x80197580
8010646d:	e8 0e e6 ff ff       	call   80104a80 <sleep>
  while(ticks - ticks0 < n){
80106472:	a1 80 75 19 80       	mov    0x80197580,%eax
80106477:	83 c4 10             	add    $0x10,%esp
8010647a:	29 d8                	sub    %ebx,%eax
8010647c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010647f:	73 2f                	jae    801064b0 <sys_sleep+0x90>
    if(myproc()->killed){
80106481:	e8 2a de ff ff       	call   801042b0 <myproc>
80106486:	8b 40 24             	mov    0x24(%eax),%eax
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 d3                	je     80106460 <sys_sleep+0x40>
      release(&tickslock);
8010648d:	83 ec 0c             	sub    $0xc,%esp
80106490:	68 40 6d 19 80       	push   $0x80196d40
80106495:	e8 f6 ed ff ff       	call   80105290 <release>
      return -1;
8010649a:	83 c4 10             	add    $0x10,%esp
8010649d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801064a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064a5:	c9                   	leave  
801064a6:	c3                   	ret    
801064a7:	89 f6                	mov    %esi,%esi
801064a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801064b0:	83 ec 0c             	sub    $0xc,%esp
801064b3:	68 40 6d 19 80       	push   $0x80196d40
801064b8:	e8 d3 ed ff ff       	call   80105290 <release>
  return 0;
801064bd:	83 c4 10             	add    $0x10,%esp
801064c0:	31 c0                	xor    %eax,%eax
}
801064c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064c5:	c9                   	leave  
801064c6:	c3                   	ret    
    return -1;
801064c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cc:	eb f4                	jmp    801064c2 <sys_sleep+0xa2>
801064ce:	66 90                	xchg   %ax,%ax

801064d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801064d0:	55                   	push   %ebp
801064d1:	89 e5                	mov    %esp,%ebp
801064d3:	53                   	push   %ebx
801064d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801064d7:	68 40 6d 19 80       	push   $0x80196d40
801064dc:	e8 ef ec ff ff       	call   801051d0 <acquire>
  xticks = ticks;
801064e1:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
801064e7:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
801064ee:	e8 9d ed ff ff       	call   80105290 <release>
  return xticks;
}
801064f3:	89 d8                	mov    %ebx,%eax
801064f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801064f8:	c9                   	leave  
801064f9:	c3                   	ret    
801064fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106500 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106506:	e8 a5 dd ff ff       	call   801042b0 <myproc>
8010650b:	ba 10 00 00 00       	mov    $0x10,%edx
80106510:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80106516:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106517:	89 d0                	mov    %edx,%eax
}
80106519:	c3                   	ret    
8010651a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106520 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
80106520:	55                   	push   %ebp
80106521:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
80106523:	5d                   	pop    %ebp
  return getTotalFreePages();
80106524:	e9 d7 e8 ff ff       	jmp    80104e00 <getTotalFreePages>

80106529 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106529:	1e                   	push   %ds
  pushl %es
8010652a:	06                   	push   %es
  pushl %fs
8010652b:	0f a0                	push   %fs
  pushl %gs
8010652d:	0f a8                	push   %gs
  pushal
8010652f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106530:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106534:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106536:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106538:	54                   	push   %esp
  call trap
80106539:	e8 c2 00 00 00       	call   80106600 <trap>
  addl $4, %esp
8010653e:	83 c4 04             	add    $0x4,%esp

80106541 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106541:	61                   	popa   
  popl %gs
80106542:	0f a9                	pop    %gs
  popl %fs
80106544:	0f a1                	pop    %fs
  popl %es
80106546:	07                   	pop    %es
  popl %ds
80106547:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106548:	83 c4 08             	add    $0x8,%esp
  iret
8010654b:	cf                   	iret   
8010654c:	66 90                	xchg   %ax,%ax
8010654e:	66 90                	xchg   %ax,%ax

80106550 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106550:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106551:	31 c0                	xor    %eax,%eax
{
80106553:	89 e5                	mov    %esp,%ebp
80106555:	83 ec 08             	sub    $0x8,%esp
80106558:	90                   	nop
80106559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106560:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
80106567:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
8010656e:	08 00 00 8e 
80106572:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
80106579:	80 
8010657a:	c1 ea 10             	shr    $0x10,%edx
8010657d:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
80106584:	80 
  for(i = 0; i < 256; i++)
80106585:	83 c0 01             	add    $0x1,%eax
80106588:	3d 00 01 00 00       	cmp    $0x100,%eax
8010658d:	75 d1                	jne    80106560 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010658f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106594:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106597:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
8010659e:	00 00 ef 
  initlock(&tickslock, "time");
801065a1:	68 fd 97 10 80       	push   $0x801097fd
801065a6:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801065ab:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
801065b1:	c1 e8 10             	shr    $0x10,%eax
801065b4:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
801065ba:	e8 d1 ea ff ff       	call   80105090 <initlock>
}
801065bf:	83 c4 10             	add    $0x10,%esp
801065c2:	c9                   	leave  
801065c3:	c3                   	ret    
801065c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801065d0 <idtinit>:

void
idtinit(void)
{
801065d0:	55                   	push   %ebp
  pd[0] = size-1;
801065d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801065d6:	89 e5                	mov    %esp,%ebp
801065d8:	83 ec 10             	sub    $0x10,%esp
801065db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801065df:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
801065e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801065e8:	c1 e8 10             	shr    $0x10,%eax
801065eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801065ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801065f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801065f5:	c9                   	leave  
801065f6:	c3                   	ret    
801065f7:	89 f6                	mov    %esi,%esi
801065f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106600 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106600:	55                   	push   %ebp
80106601:	89 e5                	mov    %esp,%ebp
80106603:	57                   	push   %edi
80106604:	56                   	push   %esi
80106605:	53                   	push   %ebx
80106606:	83 ec 1c             	sub    $0x1c,%esp
80106609:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
8010660c:	e8 9f dc ff ff       	call   801042b0 <myproc>
80106611:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106613:	8b 47 30             	mov    0x30(%edi),%eax
80106616:	83 f8 40             	cmp    $0x40,%eax
80106619:	0f 84 e9 00 00 00    	je     80106708 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010661f:	83 e8 0e             	sub    $0xe,%eax
80106622:	83 f8 31             	cmp    $0x31,%eax
80106625:	77 09                	ja     80106630 <trap+0x30>
80106627:	ff 24 85 a4 98 10 80 	jmp    *-0x7fef675c(,%eax,4)
8010662e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106630:	e8 7b dc ff ff       	call   801042b0 <myproc>
80106635:	85 c0                	test   %eax,%eax
80106637:	0f 84 27 02 00 00    	je     80106864 <trap+0x264>
8010663d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106641:	0f 84 1d 02 00 00    	je     80106864 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106647:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010664a:	8b 57 38             	mov    0x38(%edi),%edx
8010664d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80106650:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106653:	e8 38 dc ff ff       	call   80104290 <cpuid>
80106658:	8b 77 34             	mov    0x34(%edi),%esi
8010665b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010665e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106661:	e8 4a dc ff ff       	call   801042b0 <myproc>
80106666:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106669:	e8 42 dc ff ff       	call   801042b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010666e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106671:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106674:	51                   	push   %ecx
80106675:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106676:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106679:	ff 75 e4             	pushl  -0x1c(%ebp)
8010667c:	56                   	push   %esi
8010667d:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
8010667e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106681:	52                   	push   %edx
80106682:	ff 70 10             	pushl  0x10(%eax)
80106685:	68 60 98 10 80       	push   $0x80109860
8010668a:	e8 d1 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010668f:	83 c4 20             	add    $0x20,%esp
80106692:	e8 19 dc ff ff       	call   801042b0 <myproc>
80106697:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010669e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066a0:	e8 0b dc ff ff       	call   801042b0 <myproc>
801066a5:	85 c0                	test   %eax,%eax
801066a7:	74 1d                	je     801066c6 <trap+0xc6>
801066a9:	e8 02 dc ff ff       	call   801042b0 <myproc>
801066ae:	8b 50 24             	mov    0x24(%eax),%edx
801066b1:	85 d2                	test   %edx,%edx
801066b3:	74 11                	je     801066c6 <trap+0xc6>
801066b5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066b9:	83 e0 03             	and    $0x3,%eax
801066bc:	66 83 f8 03          	cmp    $0x3,%ax
801066c0:	0f 84 5a 01 00 00    	je     80106820 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801066c6:	e8 e5 db ff ff       	call   801042b0 <myproc>
801066cb:	85 c0                	test   %eax,%eax
801066cd:	74 0b                	je     801066da <trap+0xda>
801066cf:	e8 dc db ff ff       	call   801042b0 <myproc>
801066d4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801066d8:	74 5e                	je     80106738 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801066da:	e8 d1 db ff ff       	call   801042b0 <myproc>
801066df:	85 c0                	test   %eax,%eax
801066e1:	74 19                	je     801066fc <trap+0xfc>
801066e3:	e8 c8 db ff ff       	call   801042b0 <myproc>
801066e8:	8b 40 24             	mov    0x24(%eax),%eax
801066eb:	85 c0                	test   %eax,%eax
801066ed:	74 0d                	je     801066fc <trap+0xfc>
801066ef:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801066f3:	83 e0 03             	and    $0x3,%eax
801066f6:	66 83 f8 03          	cmp    $0x3,%ax
801066fa:	74 2b                	je     80106727 <trap+0x127>
    exit();
801066fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066ff:	5b                   	pop    %ebx
80106700:	5e                   	pop    %esi
80106701:	5f                   	pop    %edi
80106702:	5d                   	pop    %ebp
80106703:	c3                   	ret    
80106704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106708:	8b 73 24             	mov    0x24(%ebx),%esi
8010670b:	85 f6                	test   %esi,%esi
8010670d:	0f 85 fd 00 00 00    	jne    80106810 <trap+0x210>
    curproc->tf = tf;
80106713:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106716:	e8 b5 ef ff ff       	call   801056d0 <syscall>
    if(myproc()->killed)
8010671b:	e8 90 db ff ff       	call   801042b0 <myproc>
80106720:	8b 58 24             	mov    0x24(%eax),%ebx
80106723:	85 db                	test   %ebx,%ebx
80106725:	74 d5                	je     801066fc <trap+0xfc>
80106727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010672a:	5b                   	pop    %ebx
8010672b:	5e                   	pop    %esi
8010672c:	5f                   	pop    %edi
8010672d:	5d                   	pop    %ebp
      exit();
8010672e:	e9 9d e1 ff ff       	jmp    801048d0 <exit>
80106733:	90                   	nop
80106734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106738:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010673c:	75 9c                	jne    801066da <trap+0xda>
      if(myproc()->pid > 2) 
8010673e:	e8 6d db ff ff       	call   801042b0 <myproc>
      yield();
80106743:	e8 e8 e2 ff ff       	call   80104a30 <yield>
80106748:	eb 90                	jmp    801066da <trap+0xda>
8010674a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
80106750:	e8 5b db ff ff       	call   801042b0 <myproc>
80106755:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80106759:	0f 8e 41 ff ff ff    	jle    801066a0 <trap+0xa0>
    pagefault();
8010675f:	e8 bc 1e 00 00       	call   80108620 <pagefault>
      if(curproc->killed) {
80106764:	8b 4b 24             	mov    0x24(%ebx),%ecx
80106767:	85 c9                	test   %ecx,%ecx
80106769:	0f 84 31 ff ff ff    	je     801066a0 <trap+0xa0>
        exit();
8010676f:	e8 5c e1 ff ff       	call   801048d0 <exit>
80106774:	e9 27 ff ff ff       	jmp    801066a0 <trap+0xa0>
80106779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106780:	e8 0b db ff ff       	call   80104290 <cpuid>
80106785:	85 c0                	test   %eax,%eax
80106787:	0f 84 a3 00 00 00    	je     80106830 <trap+0x230>
    lapiceoi();
8010678d:	e8 5e c9 ff ff       	call   801030f0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106792:	e8 19 db ff ff       	call   801042b0 <myproc>
80106797:	85 c0                	test   %eax,%eax
80106799:	0f 85 0a ff ff ff    	jne    801066a9 <trap+0xa9>
8010679f:	e9 22 ff ff ff       	jmp    801066c6 <trap+0xc6>
801067a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801067a8:	e8 03 c8 ff ff       	call   80102fb0 <kbdintr>
    lapiceoi();
801067ad:	e8 3e c9 ff ff       	call   801030f0 <lapiceoi>
    break;
801067b2:	e9 e9 fe ff ff       	jmp    801066a0 <trap+0xa0>
801067b7:	89 f6                	mov    %esi,%esi
801067b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
801067c0:	e8 3b 02 00 00       	call   80106a00 <uartintr>
    lapiceoi();
801067c5:	e8 26 c9 ff ff       	call   801030f0 <lapiceoi>
    break;
801067ca:	e9 d1 fe ff ff       	jmp    801066a0 <trap+0xa0>
801067cf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801067d0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801067d4:	8b 77 38             	mov    0x38(%edi),%esi
801067d7:	e8 b4 da ff ff       	call   80104290 <cpuid>
801067dc:	56                   	push   %esi
801067dd:	53                   	push   %ebx
801067de:	50                   	push   %eax
801067df:	68 08 98 10 80       	push   $0x80109808
801067e4:	e8 77 9e ff ff       	call   80100660 <cprintf>
    lapiceoi();
801067e9:	e8 02 c9 ff ff       	call   801030f0 <lapiceoi>
    break;
801067ee:	83 c4 10             	add    $0x10,%esp
801067f1:	e9 aa fe ff ff       	jmp    801066a0 <trap+0xa0>
801067f6:	8d 76 00             	lea    0x0(%esi),%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106800:	e8 bb bf ff ff       	call   801027c0 <ideintr>
80106805:	eb 86                	jmp    8010678d <trap+0x18d>
80106807:	89 f6                	mov    %esi,%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106810:	e8 bb e0 ff ff       	call   801048d0 <exit>
80106815:	e9 f9 fe ff ff       	jmp    80106713 <trap+0x113>
8010681a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106820:	e8 ab e0 ff ff       	call   801048d0 <exit>
80106825:	e9 9c fe ff ff       	jmp    801066c6 <trap+0xc6>
8010682a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106830:	83 ec 0c             	sub    $0xc,%esp
80106833:	68 40 6d 19 80       	push   $0x80196d40
80106838:	e8 93 e9 ff ff       	call   801051d0 <acquire>
      wakeup(&ticks);
8010683d:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
80106844:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
8010684b:	e8 70 e4 ff ff       	call   80104cc0 <wakeup>
      release(&tickslock);
80106850:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
80106857:	e8 34 ea ff ff       	call   80105290 <release>
8010685c:	83 c4 10             	add    $0x10,%esp
8010685f:	e9 29 ff ff ff       	jmp    8010678d <trap+0x18d>
80106864:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106867:	8b 5f 38             	mov    0x38(%edi),%ebx
8010686a:	e8 21 da ff ff       	call   80104290 <cpuid>
8010686f:	83 ec 0c             	sub    $0xc,%esp
80106872:	56                   	push   %esi
80106873:	53                   	push   %ebx
80106874:	50                   	push   %eax
80106875:	ff 77 30             	pushl  0x30(%edi)
80106878:	68 2c 98 10 80       	push   $0x8010982c
8010687d:	e8 de 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
80106882:	83 c4 14             	add    $0x14,%esp
80106885:	68 02 98 10 80       	push   $0x80109802
8010688a:	e8 01 9b ff ff       	call   80100390 <panic>
8010688f:	90                   	nop

80106890 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106890:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
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
801068e5:	e8 26 c8 ff ff       	call   80103110 <microdelay>
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
80106969:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
80106970:	00 00 00 
80106973:	89 da                	mov    %ebx,%edx
80106975:	ec                   	in     (%dx),%al
80106976:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010697b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010697c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010697f:	bb 6c 99 10 80       	mov    $0x8010996c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106984:	6a 00                	push   $0x0
80106986:	6a 04                	push   $0x4
80106988:	e8 83 c0 ff ff       	call   80102a10 <ioapicenable>
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
801069aa:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
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
801069d0:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
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
80106a19:	e9 0b fb ff ff       	jmp    80106529 <alltraps>

80106a1e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $1
80106a20:	6a 01                	push   $0x1
  jmp alltraps
80106a22:	e9 02 fb ff ff       	jmp    80106529 <alltraps>

80106a27 <vector2>:
.globl vector2
vector2:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $2
80106a29:	6a 02                	push   $0x2
  jmp alltraps
80106a2b:	e9 f9 fa ff ff       	jmp    80106529 <alltraps>

80106a30 <vector3>:
.globl vector3
vector3:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $3
80106a32:	6a 03                	push   $0x3
  jmp alltraps
80106a34:	e9 f0 fa ff ff       	jmp    80106529 <alltraps>

80106a39 <vector4>:
.globl vector4
vector4:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $4
80106a3b:	6a 04                	push   $0x4
  jmp alltraps
80106a3d:	e9 e7 fa ff ff       	jmp    80106529 <alltraps>

80106a42 <vector5>:
.globl vector5
vector5:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $5
80106a44:	6a 05                	push   $0x5
  jmp alltraps
80106a46:	e9 de fa ff ff       	jmp    80106529 <alltraps>

80106a4b <vector6>:
.globl vector6
vector6:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $6
80106a4d:	6a 06                	push   $0x6
  jmp alltraps
80106a4f:	e9 d5 fa ff ff       	jmp    80106529 <alltraps>

80106a54 <vector7>:
.globl vector7
vector7:
  pushl $0
80106a54:	6a 00                	push   $0x0
  pushl $7
80106a56:	6a 07                	push   $0x7
  jmp alltraps
80106a58:	e9 cc fa ff ff       	jmp    80106529 <alltraps>

80106a5d <vector8>:
.globl vector8
vector8:
  pushl $8
80106a5d:	6a 08                	push   $0x8
  jmp alltraps
80106a5f:	e9 c5 fa ff ff       	jmp    80106529 <alltraps>

80106a64 <vector9>:
.globl vector9
vector9:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $9
80106a66:	6a 09                	push   $0x9
  jmp alltraps
80106a68:	e9 bc fa ff ff       	jmp    80106529 <alltraps>

80106a6d <vector10>:
.globl vector10
vector10:
  pushl $10
80106a6d:	6a 0a                	push   $0xa
  jmp alltraps
80106a6f:	e9 b5 fa ff ff       	jmp    80106529 <alltraps>

80106a74 <vector11>:
.globl vector11
vector11:
  pushl $11
80106a74:	6a 0b                	push   $0xb
  jmp alltraps
80106a76:	e9 ae fa ff ff       	jmp    80106529 <alltraps>

80106a7b <vector12>:
.globl vector12
vector12:
  pushl $12
80106a7b:	6a 0c                	push   $0xc
  jmp alltraps
80106a7d:	e9 a7 fa ff ff       	jmp    80106529 <alltraps>

80106a82 <vector13>:
.globl vector13
vector13:
  pushl $13
80106a82:	6a 0d                	push   $0xd
  jmp alltraps
80106a84:	e9 a0 fa ff ff       	jmp    80106529 <alltraps>

80106a89 <vector14>:
.globl vector14
vector14:
  pushl $14
80106a89:	6a 0e                	push   $0xe
  jmp alltraps
80106a8b:	e9 99 fa ff ff       	jmp    80106529 <alltraps>

80106a90 <vector15>:
.globl vector15
vector15:
  pushl $0
80106a90:	6a 00                	push   $0x0
  pushl $15
80106a92:	6a 0f                	push   $0xf
  jmp alltraps
80106a94:	e9 90 fa ff ff       	jmp    80106529 <alltraps>

80106a99 <vector16>:
.globl vector16
vector16:
  pushl $0
80106a99:	6a 00                	push   $0x0
  pushl $16
80106a9b:	6a 10                	push   $0x10
  jmp alltraps
80106a9d:	e9 87 fa ff ff       	jmp    80106529 <alltraps>

80106aa2 <vector17>:
.globl vector17
vector17:
  pushl $17
80106aa2:	6a 11                	push   $0x11
  jmp alltraps
80106aa4:	e9 80 fa ff ff       	jmp    80106529 <alltraps>

80106aa9 <vector18>:
.globl vector18
vector18:
  pushl $0
80106aa9:	6a 00                	push   $0x0
  pushl $18
80106aab:	6a 12                	push   $0x12
  jmp alltraps
80106aad:	e9 77 fa ff ff       	jmp    80106529 <alltraps>

80106ab2 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ab2:	6a 00                	push   $0x0
  pushl $19
80106ab4:	6a 13                	push   $0x13
  jmp alltraps
80106ab6:	e9 6e fa ff ff       	jmp    80106529 <alltraps>

80106abb <vector20>:
.globl vector20
vector20:
  pushl $0
80106abb:	6a 00                	push   $0x0
  pushl $20
80106abd:	6a 14                	push   $0x14
  jmp alltraps
80106abf:	e9 65 fa ff ff       	jmp    80106529 <alltraps>

80106ac4 <vector21>:
.globl vector21
vector21:
  pushl $0
80106ac4:	6a 00                	push   $0x0
  pushl $21
80106ac6:	6a 15                	push   $0x15
  jmp alltraps
80106ac8:	e9 5c fa ff ff       	jmp    80106529 <alltraps>

80106acd <vector22>:
.globl vector22
vector22:
  pushl $0
80106acd:	6a 00                	push   $0x0
  pushl $22
80106acf:	6a 16                	push   $0x16
  jmp alltraps
80106ad1:	e9 53 fa ff ff       	jmp    80106529 <alltraps>

80106ad6 <vector23>:
.globl vector23
vector23:
  pushl $0
80106ad6:	6a 00                	push   $0x0
  pushl $23
80106ad8:	6a 17                	push   $0x17
  jmp alltraps
80106ada:	e9 4a fa ff ff       	jmp    80106529 <alltraps>

80106adf <vector24>:
.globl vector24
vector24:
  pushl $0
80106adf:	6a 00                	push   $0x0
  pushl $24
80106ae1:	6a 18                	push   $0x18
  jmp alltraps
80106ae3:	e9 41 fa ff ff       	jmp    80106529 <alltraps>

80106ae8 <vector25>:
.globl vector25
vector25:
  pushl $0
80106ae8:	6a 00                	push   $0x0
  pushl $25
80106aea:	6a 19                	push   $0x19
  jmp alltraps
80106aec:	e9 38 fa ff ff       	jmp    80106529 <alltraps>

80106af1 <vector26>:
.globl vector26
vector26:
  pushl $0
80106af1:	6a 00                	push   $0x0
  pushl $26
80106af3:	6a 1a                	push   $0x1a
  jmp alltraps
80106af5:	e9 2f fa ff ff       	jmp    80106529 <alltraps>

80106afa <vector27>:
.globl vector27
vector27:
  pushl $0
80106afa:	6a 00                	push   $0x0
  pushl $27
80106afc:	6a 1b                	push   $0x1b
  jmp alltraps
80106afe:	e9 26 fa ff ff       	jmp    80106529 <alltraps>

80106b03 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b03:	6a 00                	push   $0x0
  pushl $28
80106b05:	6a 1c                	push   $0x1c
  jmp alltraps
80106b07:	e9 1d fa ff ff       	jmp    80106529 <alltraps>

80106b0c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b0c:	6a 00                	push   $0x0
  pushl $29
80106b0e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b10:	e9 14 fa ff ff       	jmp    80106529 <alltraps>

80106b15 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b15:	6a 00                	push   $0x0
  pushl $30
80106b17:	6a 1e                	push   $0x1e
  jmp alltraps
80106b19:	e9 0b fa ff ff       	jmp    80106529 <alltraps>

80106b1e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b1e:	6a 00                	push   $0x0
  pushl $31
80106b20:	6a 1f                	push   $0x1f
  jmp alltraps
80106b22:	e9 02 fa ff ff       	jmp    80106529 <alltraps>

80106b27 <vector32>:
.globl vector32
vector32:
  pushl $0
80106b27:	6a 00                	push   $0x0
  pushl $32
80106b29:	6a 20                	push   $0x20
  jmp alltraps
80106b2b:	e9 f9 f9 ff ff       	jmp    80106529 <alltraps>

80106b30 <vector33>:
.globl vector33
vector33:
  pushl $0
80106b30:	6a 00                	push   $0x0
  pushl $33
80106b32:	6a 21                	push   $0x21
  jmp alltraps
80106b34:	e9 f0 f9 ff ff       	jmp    80106529 <alltraps>

80106b39 <vector34>:
.globl vector34
vector34:
  pushl $0
80106b39:	6a 00                	push   $0x0
  pushl $34
80106b3b:	6a 22                	push   $0x22
  jmp alltraps
80106b3d:	e9 e7 f9 ff ff       	jmp    80106529 <alltraps>

80106b42 <vector35>:
.globl vector35
vector35:
  pushl $0
80106b42:	6a 00                	push   $0x0
  pushl $35
80106b44:	6a 23                	push   $0x23
  jmp alltraps
80106b46:	e9 de f9 ff ff       	jmp    80106529 <alltraps>

80106b4b <vector36>:
.globl vector36
vector36:
  pushl $0
80106b4b:	6a 00                	push   $0x0
  pushl $36
80106b4d:	6a 24                	push   $0x24
  jmp alltraps
80106b4f:	e9 d5 f9 ff ff       	jmp    80106529 <alltraps>

80106b54 <vector37>:
.globl vector37
vector37:
  pushl $0
80106b54:	6a 00                	push   $0x0
  pushl $37
80106b56:	6a 25                	push   $0x25
  jmp alltraps
80106b58:	e9 cc f9 ff ff       	jmp    80106529 <alltraps>

80106b5d <vector38>:
.globl vector38
vector38:
  pushl $0
80106b5d:	6a 00                	push   $0x0
  pushl $38
80106b5f:	6a 26                	push   $0x26
  jmp alltraps
80106b61:	e9 c3 f9 ff ff       	jmp    80106529 <alltraps>

80106b66 <vector39>:
.globl vector39
vector39:
  pushl $0
80106b66:	6a 00                	push   $0x0
  pushl $39
80106b68:	6a 27                	push   $0x27
  jmp alltraps
80106b6a:	e9 ba f9 ff ff       	jmp    80106529 <alltraps>

80106b6f <vector40>:
.globl vector40
vector40:
  pushl $0
80106b6f:	6a 00                	push   $0x0
  pushl $40
80106b71:	6a 28                	push   $0x28
  jmp alltraps
80106b73:	e9 b1 f9 ff ff       	jmp    80106529 <alltraps>

80106b78 <vector41>:
.globl vector41
vector41:
  pushl $0
80106b78:	6a 00                	push   $0x0
  pushl $41
80106b7a:	6a 29                	push   $0x29
  jmp alltraps
80106b7c:	e9 a8 f9 ff ff       	jmp    80106529 <alltraps>

80106b81 <vector42>:
.globl vector42
vector42:
  pushl $0
80106b81:	6a 00                	push   $0x0
  pushl $42
80106b83:	6a 2a                	push   $0x2a
  jmp alltraps
80106b85:	e9 9f f9 ff ff       	jmp    80106529 <alltraps>

80106b8a <vector43>:
.globl vector43
vector43:
  pushl $0
80106b8a:	6a 00                	push   $0x0
  pushl $43
80106b8c:	6a 2b                	push   $0x2b
  jmp alltraps
80106b8e:	e9 96 f9 ff ff       	jmp    80106529 <alltraps>

80106b93 <vector44>:
.globl vector44
vector44:
  pushl $0
80106b93:	6a 00                	push   $0x0
  pushl $44
80106b95:	6a 2c                	push   $0x2c
  jmp alltraps
80106b97:	e9 8d f9 ff ff       	jmp    80106529 <alltraps>

80106b9c <vector45>:
.globl vector45
vector45:
  pushl $0
80106b9c:	6a 00                	push   $0x0
  pushl $45
80106b9e:	6a 2d                	push   $0x2d
  jmp alltraps
80106ba0:	e9 84 f9 ff ff       	jmp    80106529 <alltraps>

80106ba5 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ba5:	6a 00                	push   $0x0
  pushl $46
80106ba7:	6a 2e                	push   $0x2e
  jmp alltraps
80106ba9:	e9 7b f9 ff ff       	jmp    80106529 <alltraps>

80106bae <vector47>:
.globl vector47
vector47:
  pushl $0
80106bae:	6a 00                	push   $0x0
  pushl $47
80106bb0:	6a 2f                	push   $0x2f
  jmp alltraps
80106bb2:	e9 72 f9 ff ff       	jmp    80106529 <alltraps>

80106bb7 <vector48>:
.globl vector48
vector48:
  pushl $0
80106bb7:	6a 00                	push   $0x0
  pushl $48
80106bb9:	6a 30                	push   $0x30
  jmp alltraps
80106bbb:	e9 69 f9 ff ff       	jmp    80106529 <alltraps>

80106bc0 <vector49>:
.globl vector49
vector49:
  pushl $0
80106bc0:	6a 00                	push   $0x0
  pushl $49
80106bc2:	6a 31                	push   $0x31
  jmp alltraps
80106bc4:	e9 60 f9 ff ff       	jmp    80106529 <alltraps>

80106bc9 <vector50>:
.globl vector50
vector50:
  pushl $0
80106bc9:	6a 00                	push   $0x0
  pushl $50
80106bcb:	6a 32                	push   $0x32
  jmp alltraps
80106bcd:	e9 57 f9 ff ff       	jmp    80106529 <alltraps>

80106bd2 <vector51>:
.globl vector51
vector51:
  pushl $0
80106bd2:	6a 00                	push   $0x0
  pushl $51
80106bd4:	6a 33                	push   $0x33
  jmp alltraps
80106bd6:	e9 4e f9 ff ff       	jmp    80106529 <alltraps>

80106bdb <vector52>:
.globl vector52
vector52:
  pushl $0
80106bdb:	6a 00                	push   $0x0
  pushl $52
80106bdd:	6a 34                	push   $0x34
  jmp alltraps
80106bdf:	e9 45 f9 ff ff       	jmp    80106529 <alltraps>

80106be4 <vector53>:
.globl vector53
vector53:
  pushl $0
80106be4:	6a 00                	push   $0x0
  pushl $53
80106be6:	6a 35                	push   $0x35
  jmp alltraps
80106be8:	e9 3c f9 ff ff       	jmp    80106529 <alltraps>

80106bed <vector54>:
.globl vector54
vector54:
  pushl $0
80106bed:	6a 00                	push   $0x0
  pushl $54
80106bef:	6a 36                	push   $0x36
  jmp alltraps
80106bf1:	e9 33 f9 ff ff       	jmp    80106529 <alltraps>

80106bf6 <vector55>:
.globl vector55
vector55:
  pushl $0
80106bf6:	6a 00                	push   $0x0
  pushl $55
80106bf8:	6a 37                	push   $0x37
  jmp alltraps
80106bfa:	e9 2a f9 ff ff       	jmp    80106529 <alltraps>

80106bff <vector56>:
.globl vector56
vector56:
  pushl $0
80106bff:	6a 00                	push   $0x0
  pushl $56
80106c01:	6a 38                	push   $0x38
  jmp alltraps
80106c03:	e9 21 f9 ff ff       	jmp    80106529 <alltraps>

80106c08 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c08:	6a 00                	push   $0x0
  pushl $57
80106c0a:	6a 39                	push   $0x39
  jmp alltraps
80106c0c:	e9 18 f9 ff ff       	jmp    80106529 <alltraps>

80106c11 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c11:	6a 00                	push   $0x0
  pushl $58
80106c13:	6a 3a                	push   $0x3a
  jmp alltraps
80106c15:	e9 0f f9 ff ff       	jmp    80106529 <alltraps>

80106c1a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c1a:	6a 00                	push   $0x0
  pushl $59
80106c1c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c1e:	e9 06 f9 ff ff       	jmp    80106529 <alltraps>

80106c23 <vector60>:
.globl vector60
vector60:
  pushl $0
80106c23:	6a 00                	push   $0x0
  pushl $60
80106c25:	6a 3c                	push   $0x3c
  jmp alltraps
80106c27:	e9 fd f8 ff ff       	jmp    80106529 <alltraps>

80106c2c <vector61>:
.globl vector61
vector61:
  pushl $0
80106c2c:	6a 00                	push   $0x0
  pushl $61
80106c2e:	6a 3d                	push   $0x3d
  jmp alltraps
80106c30:	e9 f4 f8 ff ff       	jmp    80106529 <alltraps>

80106c35 <vector62>:
.globl vector62
vector62:
  pushl $0
80106c35:	6a 00                	push   $0x0
  pushl $62
80106c37:	6a 3e                	push   $0x3e
  jmp alltraps
80106c39:	e9 eb f8 ff ff       	jmp    80106529 <alltraps>

80106c3e <vector63>:
.globl vector63
vector63:
  pushl $0
80106c3e:	6a 00                	push   $0x0
  pushl $63
80106c40:	6a 3f                	push   $0x3f
  jmp alltraps
80106c42:	e9 e2 f8 ff ff       	jmp    80106529 <alltraps>

80106c47 <vector64>:
.globl vector64
vector64:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $64
80106c49:	6a 40                	push   $0x40
  jmp alltraps
80106c4b:	e9 d9 f8 ff ff       	jmp    80106529 <alltraps>

80106c50 <vector65>:
.globl vector65
vector65:
  pushl $0
80106c50:	6a 00                	push   $0x0
  pushl $65
80106c52:	6a 41                	push   $0x41
  jmp alltraps
80106c54:	e9 d0 f8 ff ff       	jmp    80106529 <alltraps>

80106c59 <vector66>:
.globl vector66
vector66:
  pushl $0
80106c59:	6a 00                	push   $0x0
  pushl $66
80106c5b:	6a 42                	push   $0x42
  jmp alltraps
80106c5d:	e9 c7 f8 ff ff       	jmp    80106529 <alltraps>

80106c62 <vector67>:
.globl vector67
vector67:
  pushl $0
80106c62:	6a 00                	push   $0x0
  pushl $67
80106c64:	6a 43                	push   $0x43
  jmp alltraps
80106c66:	e9 be f8 ff ff       	jmp    80106529 <alltraps>

80106c6b <vector68>:
.globl vector68
vector68:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $68
80106c6d:	6a 44                	push   $0x44
  jmp alltraps
80106c6f:	e9 b5 f8 ff ff       	jmp    80106529 <alltraps>

80106c74 <vector69>:
.globl vector69
vector69:
  pushl $0
80106c74:	6a 00                	push   $0x0
  pushl $69
80106c76:	6a 45                	push   $0x45
  jmp alltraps
80106c78:	e9 ac f8 ff ff       	jmp    80106529 <alltraps>

80106c7d <vector70>:
.globl vector70
vector70:
  pushl $0
80106c7d:	6a 00                	push   $0x0
  pushl $70
80106c7f:	6a 46                	push   $0x46
  jmp alltraps
80106c81:	e9 a3 f8 ff ff       	jmp    80106529 <alltraps>

80106c86 <vector71>:
.globl vector71
vector71:
  pushl $0
80106c86:	6a 00                	push   $0x0
  pushl $71
80106c88:	6a 47                	push   $0x47
  jmp alltraps
80106c8a:	e9 9a f8 ff ff       	jmp    80106529 <alltraps>

80106c8f <vector72>:
.globl vector72
vector72:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $72
80106c91:	6a 48                	push   $0x48
  jmp alltraps
80106c93:	e9 91 f8 ff ff       	jmp    80106529 <alltraps>

80106c98 <vector73>:
.globl vector73
vector73:
  pushl $0
80106c98:	6a 00                	push   $0x0
  pushl $73
80106c9a:	6a 49                	push   $0x49
  jmp alltraps
80106c9c:	e9 88 f8 ff ff       	jmp    80106529 <alltraps>

80106ca1 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ca1:	6a 00                	push   $0x0
  pushl $74
80106ca3:	6a 4a                	push   $0x4a
  jmp alltraps
80106ca5:	e9 7f f8 ff ff       	jmp    80106529 <alltraps>

80106caa <vector75>:
.globl vector75
vector75:
  pushl $0
80106caa:	6a 00                	push   $0x0
  pushl $75
80106cac:	6a 4b                	push   $0x4b
  jmp alltraps
80106cae:	e9 76 f8 ff ff       	jmp    80106529 <alltraps>

80106cb3 <vector76>:
.globl vector76
vector76:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $76
80106cb5:	6a 4c                	push   $0x4c
  jmp alltraps
80106cb7:	e9 6d f8 ff ff       	jmp    80106529 <alltraps>

80106cbc <vector77>:
.globl vector77
vector77:
  pushl $0
80106cbc:	6a 00                	push   $0x0
  pushl $77
80106cbe:	6a 4d                	push   $0x4d
  jmp alltraps
80106cc0:	e9 64 f8 ff ff       	jmp    80106529 <alltraps>

80106cc5 <vector78>:
.globl vector78
vector78:
  pushl $0
80106cc5:	6a 00                	push   $0x0
  pushl $78
80106cc7:	6a 4e                	push   $0x4e
  jmp alltraps
80106cc9:	e9 5b f8 ff ff       	jmp    80106529 <alltraps>

80106cce <vector79>:
.globl vector79
vector79:
  pushl $0
80106cce:	6a 00                	push   $0x0
  pushl $79
80106cd0:	6a 4f                	push   $0x4f
  jmp alltraps
80106cd2:	e9 52 f8 ff ff       	jmp    80106529 <alltraps>

80106cd7 <vector80>:
.globl vector80
vector80:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $80
80106cd9:	6a 50                	push   $0x50
  jmp alltraps
80106cdb:	e9 49 f8 ff ff       	jmp    80106529 <alltraps>

80106ce0 <vector81>:
.globl vector81
vector81:
  pushl $0
80106ce0:	6a 00                	push   $0x0
  pushl $81
80106ce2:	6a 51                	push   $0x51
  jmp alltraps
80106ce4:	e9 40 f8 ff ff       	jmp    80106529 <alltraps>

80106ce9 <vector82>:
.globl vector82
vector82:
  pushl $0
80106ce9:	6a 00                	push   $0x0
  pushl $82
80106ceb:	6a 52                	push   $0x52
  jmp alltraps
80106ced:	e9 37 f8 ff ff       	jmp    80106529 <alltraps>

80106cf2 <vector83>:
.globl vector83
vector83:
  pushl $0
80106cf2:	6a 00                	push   $0x0
  pushl $83
80106cf4:	6a 53                	push   $0x53
  jmp alltraps
80106cf6:	e9 2e f8 ff ff       	jmp    80106529 <alltraps>

80106cfb <vector84>:
.globl vector84
vector84:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $84
80106cfd:	6a 54                	push   $0x54
  jmp alltraps
80106cff:	e9 25 f8 ff ff       	jmp    80106529 <alltraps>

80106d04 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d04:	6a 00                	push   $0x0
  pushl $85
80106d06:	6a 55                	push   $0x55
  jmp alltraps
80106d08:	e9 1c f8 ff ff       	jmp    80106529 <alltraps>

80106d0d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d0d:	6a 00                	push   $0x0
  pushl $86
80106d0f:	6a 56                	push   $0x56
  jmp alltraps
80106d11:	e9 13 f8 ff ff       	jmp    80106529 <alltraps>

80106d16 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d16:	6a 00                	push   $0x0
  pushl $87
80106d18:	6a 57                	push   $0x57
  jmp alltraps
80106d1a:	e9 0a f8 ff ff       	jmp    80106529 <alltraps>

80106d1f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $88
80106d21:	6a 58                	push   $0x58
  jmp alltraps
80106d23:	e9 01 f8 ff ff       	jmp    80106529 <alltraps>

80106d28 <vector89>:
.globl vector89
vector89:
  pushl $0
80106d28:	6a 00                	push   $0x0
  pushl $89
80106d2a:	6a 59                	push   $0x59
  jmp alltraps
80106d2c:	e9 f8 f7 ff ff       	jmp    80106529 <alltraps>

80106d31 <vector90>:
.globl vector90
vector90:
  pushl $0
80106d31:	6a 00                	push   $0x0
  pushl $90
80106d33:	6a 5a                	push   $0x5a
  jmp alltraps
80106d35:	e9 ef f7 ff ff       	jmp    80106529 <alltraps>

80106d3a <vector91>:
.globl vector91
vector91:
  pushl $0
80106d3a:	6a 00                	push   $0x0
  pushl $91
80106d3c:	6a 5b                	push   $0x5b
  jmp alltraps
80106d3e:	e9 e6 f7 ff ff       	jmp    80106529 <alltraps>

80106d43 <vector92>:
.globl vector92
vector92:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $92
80106d45:	6a 5c                	push   $0x5c
  jmp alltraps
80106d47:	e9 dd f7 ff ff       	jmp    80106529 <alltraps>

80106d4c <vector93>:
.globl vector93
vector93:
  pushl $0
80106d4c:	6a 00                	push   $0x0
  pushl $93
80106d4e:	6a 5d                	push   $0x5d
  jmp alltraps
80106d50:	e9 d4 f7 ff ff       	jmp    80106529 <alltraps>

80106d55 <vector94>:
.globl vector94
vector94:
  pushl $0
80106d55:	6a 00                	push   $0x0
  pushl $94
80106d57:	6a 5e                	push   $0x5e
  jmp alltraps
80106d59:	e9 cb f7 ff ff       	jmp    80106529 <alltraps>

80106d5e <vector95>:
.globl vector95
vector95:
  pushl $0
80106d5e:	6a 00                	push   $0x0
  pushl $95
80106d60:	6a 5f                	push   $0x5f
  jmp alltraps
80106d62:	e9 c2 f7 ff ff       	jmp    80106529 <alltraps>

80106d67 <vector96>:
.globl vector96
vector96:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $96
80106d69:	6a 60                	push   $0x60
  jmp alltraps
80106d6b:	e9 b9 f7 ff ff       	jmp    80106529 <alltraps>

80106d70 <vector97>:
.globl vector97
vector97:
  pushl $0
80106d70:	6a 00                	push   $0x0
  pushl $97
80106d72:	6a 61                	push   $0x61
  jmp alltraps
80106d74:	e9 b0 f7 ff ff       	jmp    80106529 <alltraps>

80106d79 <vector98>:
.globl vector98
vector98:
  pushl $0
80106d79:	6a 00                	push   $0x0
  pushl $98
80106d7b:	6a 62                	push   $0x62
  jmp alltraps
80106d7d:	e9 a7 f7 ff ff       	jmp    80106529 <alltraps>

80106d82 <vector99>:
.globl vector99
vector99:
  pushl $0
80106d82:	6a 00                	push   $0x0
  pushl $99
80106d84:	6a 63                	push   $0x63
  jmp alltraps
80106d86:	e9 9e f7 ff ff       	jmp    80106529 <alltraps>

80106d8b <vector100>:
.globl vector100
vector100:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $100
80106d8d:	6a 64                	push   $0x64
  jmp alltraps
80106d8f:	e9 95 f7 ff ff       	jmp    80106529 <alltraps>

80106d94 <vector101>:
.globl vector101
vector101:
  pushl $0
80106d94:	6a 00                	push   $0x0
  pushl $101
80106d96:	6a 65                	push   $0x65
  jmp alltraps
80106d98:	e9 8c f7 ff ff       	jmp    80106529 <alltraps>

80106d9d <vector102>:
.globl vector102
vector102:
  pushl $0
80106d9d:	6a 00                	push   $0x0
  pushl $102
80106d9f:	6a 66                	push   $0x66
  jmp alltraps
80106da1:	e9 83 f7 ff ff       	jmp    80106529 <alltraps>

80106da6 <vector103>:
.globl vector103
vector103:
  pushl $0
80106da6:	6a 00                	push   $0x0
  pushl $103
80106da8:	6a 67                	push   $0x67
  jmp alltraps
80106daa:	e9 7a f7 ff ff       	jmp    80106529 <alltraps>

80106daf <vector104>:
.globl vector104
vector104:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $104
80106db1:	6a 68                	push   $0x68
  jmp alltraps
80106db3:	e9 71 f7 ff ff       	jmp    80106529 <alltraps>

80106db8 <vector105>:
.globl vector105
vector105:
  pushl $0
80106db8:	6a 00                	push   $0x0
  pushl $105
80106dba:	6a 69                	push   $0x69
  jmp alltraps
80106dbc:	e9 68 f7 ff ff       	jmp    80106529 <alltraps>

80106dc1 <vector106>:
.globl vector106
vector106:
  pushl $0
80106dc1:	6a 00                	push   $0x0
  pushl $106
80106dc3:	6a 6a                	push   $0x6a
  jmp alltraps
80106dc5:	e9 5f f7 ff ff       	jmp    80106529 <alltraps>

80106dca <vector107>:
.globl vector107
vector107:
  pushl $0
80106dca:	6a 00                	push   $0x0
  pushl $107
80106dcc:	6a 6b                	push   $0x6b
  jmp alltraps
80106dce:	e9 56 f7 ff ff       	jmp    80106529 <alltraps>

80106dd3 <vector108>:
.globl vector108
vector108:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $108
80106dd5:	6a 6c                	push   $0x6c
  jmp alltraps
80106dd7:	e9 4d f7 ff ff       	jmp    80106529 <alltraps>

80106ddc <vector109>:
.globl vector109
vector109:
  pushl $0
80106ddc:	6a 00                	push   $0x0
  pushl $109
80106dde:	6a 6d                	push   $0x6d
  jmp alltraps
80106de0:	e9 44 f7 ff ff       	jmp    80106529 <alltraps>

80106de5 <vector110>:
.globl vector110
vector110:
  pushl $0
80106de5:	6a 00                	push   $0x0
  pushl $110
80106de7:	6a 6e                	push   $0x6e
  jmp alltraps
80106de9:	e9 3b f7 ff ff       	jmp    80106529 <alltraps>

80106dee <vector111>:
.globl vector111
vector111:
  pushl $0
80106dee:	6a 00                	push   $0x0
  pushl $111
80106df0:	6a 6f                	push   $0x6f
  jmp alltraps
80106df2:	e9 32 f7 ff ff       	jmp    80106529 <alltraps>

80106df7 <vector112>:
.globl vector112
vector112:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $112
80106df9:	6a 70                	push   $0x70
  jmp alltraps
80106dfb:	e9 29 f7 ff ff       	jmp    80106529 <alltraps>

80106e00 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e00:	6a 00                	push   $0x0
  pushl $113
80106e02:	6a 71                	push   $0x71
  jmp alltraps
80106e04:	e9 20 f7 ff ff       	jmp    80106529 <alltraps>

80106e09 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e09:	6a 00                	push   $0x0
  pushl $114
80106e0b:	6a 72                	push   $0x72
  jmp alltraps
80106e0d:	e9 17 f7 ff ff       	jmp    80106529 <alltraps>

80106e12 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e12:	6a 00                	push   $0x0
  pushl $115
80106e14:	6a 73                	push   $0x73
  jmp alltraps
80106e16:	e9 0e f7 ff ff       	jmp    80106529 <alltraps>

80106e1b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $116
80106e1d:	6a 74                	push   $0x74
  jmp alltraps
80106e1f:	e9 05 f7 ff ff       	jmp    80106529 <alltraps>

80106e24 <vector117>:
.globl vector117
vector117:
  pushl $0
80106e24:	6a 00                	push   $0x0
  pushl $117
80106e26:	6a 75                	push   $0x75
  jmp alltraps
80106e28:	e9 fc f6 ff ff       	jmp    80106529 <alltraps>

80106e2d <vector118>:
.globl vector118
vector118:
  pushl $0
80106e2d:	6a 00                	push   $0x0
  pushl $118
80106e2f:	6a 76                	push   $0x76
  jmp alltraps
80106e31:	e9 f3 f6 ff ff       	jmp    80106529 <alltraps>

80106e36 <vector119>:
.globl vector119
vector119:
  pushl $0
80106e36:	6a 00                	push   $0x0
  pushl $119
80106e38:	6a 77                	push   $0x77
  jmp alltraps
80106e3a:	e9 ea f6 ff ff       	jmp    80106529 <alltraps>

80106e3f <vector120>:
.globl vector120
vector120:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $120
80106e41:	6a 78                	push   $0x78
  jmp alltraps
80106e43:	e9 e1 f6 ff ff       	jmp    80106529 <alltraps>

80106e48 <vector121>:
.globl vector121
vector121:
  pushl $0
80106e48:	6a 00                	push   $0x0
  pushl $121
80106e4a:	6a 79                	push   $0x79
  jmp alltraps
80106e4c:	e9 d8 f6 ff ff       	jmp    80106529 <alltraps>

80106e51 <vector122>:
.globl vector122
vector122:
  pushl $0
80106e51:	6a 00                	push   $0x0
  pushl $122
80106e53:	6a 7a                	push   $0x7a
  jmp alltraps
80106e55:	e9 cf f6 ff ff       	jmp    80106529 <alltraps>

80106e5a <vector123>:
.globl vector123
vector123:
  pushl $0
80106e5a:	6a 00                	push   $0x0
  pushl $123
80106e5c:	6a 7b                	push   $0x7b
  jmp alltraps
80106e5e:	e9 c6 f6 ff ff       	jmp    80106529 <alltraps>

80106e63 <vector124>:
.globl vector124
vector124:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $124
80106e65:	6a 7c                	push   $0x7c
  jmp alltraps
80106e67:	e9 bd f6 ff ff       	jmp    80106529 <alltraps>

80106e6c <vector125>:
.globl vector125
vector125:
  pushl $0
80106e6c:	6a 00                	push   $0x0
  pushl $125
80106e6e:	6a 7d                	push   $0x7d
  jmp alltraps
80106e70:	e9 b4 f6 ff ff       	jmp    80106529 <alltraps>

80106e75 <vector126>:
.globl vector126
vector126:
  pushl $0
80106e75:	6a 00                	push   $0x0
  pushl $126
80106e77:	6a 7e                	push   $0x7e
  jmp alltraps
80106e79:	e9 ab f6 ff ff       	jmp    80106529 <alltraps>

80106e7e <vector127>:
.globl vector127
vector127:
  pushl $0
80106e7e:	6a 00                	push   $0x0
  pushl $127
80106e80:	6a 7f                	push   $0x7f
  jmp alltraps
80106e82:	e9 a2 f6 ff ff       	jmp    80106529 <alltraps>

80106e87 <vector128>:
.globl vector128
vector128:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $128
80106e89:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106e8e:	e9 96 f6 ff ff       	jmp    80106529 <alltraps>

80106e93 <vector129>:
.globl vector129
vector129:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $129
80106e95:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106e9a:	e9 8a f6 ff ff       	jmp    80106529 <alltraps>

80106e9f <vector130>:
.globl vector130
vector130:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $130
80106ea1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106ea6:	e9 7e f6 ff ff       	jmp    80106529 <alltraps>

80106eab <vector131>:
.globl vector131
vector131:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $131
80106ead:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106eb2:	e9 72 f6 ff ff       	jmp    80106529 <alltraps>

80106eb7 <vector132>:
.globl vector132
vector132:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $132
80106eb9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ebe:	e9 66 f6 ff ff       	jmp    80106529 <alltraps>

80106ec3 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $133
80106ec5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106eca:	e9 5a f6 ff ff       	jmp    80106529 <alltraps>

80106ecf <vector134>:
.globl vector134
vector134:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $134
80106ed1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106ed6:	e9 4e f6 ff ff       	jmp    80106529 <alltraps>

80106edb <vector135>:
.globl vector135
vector135:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $135
80106edd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ee2:	e9 42 f6 ff ff       	jmp    80106529 <alltraps>

80106ee7 <vector136>:
.globl vector136
vector136:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $136
80106ee9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106eee:	e9 36 f6 ff ff       	jmp    80106529 <alltraps>

80106ef3 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $137
80106ef5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106efa:	e9 2a f6 ff ff       	jmp    80106529 <alltraps>

80106eff <vector138>:
.globl vector138
vector138:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $138
80106f01:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f06:	e9 1e f6 ff ff       	jmp    80106529 <alltraps>

80106f0b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $139
80106f0d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f12:	e9 12 f6 ff ff       	jmp    80106529 <alltraps>

80106f17 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $140
80106f19:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f1e:	e9 06 f6 ff ff       	jmp    80106529 <alltraps>

80106f23 <vector141>:
.globl vector141
vector141:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $141
80106f25:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106f2a:	e9 fa f5 ff ff       	jmp    80106529 <alltraps>

80106f2f <vector142>:
.globl vector142
vector142:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $142
80106f31:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106f36:	e9 ee f5 ff ff       	jmp    80106529 <alltraps>

80106f3b <vector143>:
.globl vector143
vector143:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $143
80106f3d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106f42:	e9 e2 f5 ff ff       	jmp    80106529 <alltraps>

80106f47 <vector144>:
.globl vector144
vector144:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $144
80106f49:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106f4e:	e9 d6 f5 ff ff       	jmp    80106529 <alltraps>

80106f53 <vector145>:
.globl vector145
vector145:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $145
80106f55:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106f5a:	e9 ca f5 ff ff       	jmp    80106529 <alltraps>

80106f5f <vector146>:
.globl vector146
vector146:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $146
80106f61:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106f66:	e9 be f5 ff ff       	jmp    80106529 <alltraps>

80106f6b <vector147>:
.globl vector147
vector147:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $147
80106f6d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106f72:	e9 b2 f5 ff ff       	jmp    80106529 <alltraps>

80106f77 <vector148>:
.globl vector148
vector148:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $148
80106f79:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106f7e:	e9 a6 f5 ff ff       	jmp    80106529 <alltraps>

80106f83 <vector149>:
.globl vector149
vector149:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $149
80106f85:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106f8a:	e9 9a f5 ff ff       	jmp    80106529 <alltraps>

80106f8f <vector150>:
.globl vector150
vector150:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $150
80106f91:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106f96:	e9 8e f5 ff ff       	jmp    80106529 <alltraps>

80106f9b <vector151>:
.globl vector151
vector151:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $151
80106f9d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106fa2:	e9 82 f5 ff ff       	jmp    80106529 <alltraps>

80106fa7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $152
80106fa9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106fae:	e9 76 f5 ff ff       	jmp    80106529 <alltraps>

80106fb3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $153
80106fb5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106fba:	e9 6a f5 ff ff       	jmp    80106529 <alltraps>

80106fbf <vector154>:
.globl vector154
vector154:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $154
80106fc1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106fc6:	e9 5e f5 ff ff       	jmp    80106529 <alltraps>

80106fcb <vector155>:
.globl vector155
vector155:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $155
80106fcd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106fd2:	e9 52 f5 ff ff       	jmp    80106529 <alltraps>

80106fd7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $156
80106fd9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106fde:	e9 46 f5 ff ff       	jmp    80106529 <alltraps>

80106fe3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $157
80106fe5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106fea:	e9 3a f5 ff ff       	jmp    80106529 <alltraps>

80106fef <vector158>:
.globl vector158
vector158:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $158
80106ff1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106ff6:	e9 2e f5 ff ff       	jmp    80106529 <alltraps>

80106ffb <vector159>:
.globl vector159
vector159:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $159
80106ffd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107002:	e9 22 f5 ff ff       	jmp    80106529 <alltraps>

80107007 <vector160>:
.globl vector160
vector160:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $160
80107009:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010700e:	e9 16 f5 ff ff       	jmp    80106529 <alltraps>

80107013 <vector161>:
.globl vector161
vector161:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $161
80107015:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010701a:	e9 0a f5 ff ff       	jmp    80106529 <alltraps>

8010701f <vector162>:
.globl vector162
vector162:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $162
80107021:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107026:	e9 fe f4 ff ff       	jmp    80106529 <alltraps>

8010702b <vector163>:
.globl vector163
vector163:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $163
8010702d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107032:	e9 f2 f4 ff ff       	jmp    80106529 <alltraps>

80107037 <vector164>:
.globl vector164
vector164:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $164
80107039:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010703e:	e9 e6 f4 ff ff       	jmp    80106529 <alltraps>

80107043 <vector165>:
.globl vector165
vector165:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $165
80107045:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010704a:	e9 da f4 ff ff       	jmp    80106529 <alltraps>

8010704f <vector166>:
.globl vector166
vector166:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $166
80107051:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107056:	e9 ce f4 ff ff       	jmp    80106529 <alltraps>

8010705b <vector167>:
.globl vector167
vector167:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $167
8010705d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107062:	e9 c2 f4 ff ff       	jmp    80106529 <alltraps>

80107067 <vector168>:
.globl vector168
vector168:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $168
80107069:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010706e:	e9 b6 f4 ff ff       	jmp    80106529 <alltraps>

80107073 <vector169>:
.globl vector169
vector169:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $169
80107075:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010707a:	e9 aa f4 ff ff       	jmp    80106529 <alltraps>

8010707f <vector170>:
.globl vector170
vector170:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $170
80107081:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107086:	e9 9e f4 ff ff       	jmp    80106529 <alltraps>

8010708b <vector171>:
.globl vector171
vector171:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $171
8010708d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107092:	e9 92 f4 ff ff       	jmp    80106529 <alltraps>

80107097 <vector172>:
.globl vector172
vector172:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $172
80107099:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010709e:	e9 86 f4 ff ff       	jmp    80106529 <alltraps>

801070a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $173
801070a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801070aa:	e9 7a f4 ff ff       	jmp    80106529 <alltraps>

801070af <vector174>:
.globl vector174
vector174:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $174
801070b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801070b6:	e9 6e f4 ff ff       	jmp    80106529 <alltraps>

801070bb <vector175>:
.globl vector175
vector175:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $175
801070bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801070c2:	e9 62 f4 ff ff       	jmp    80106529 <alltraps>

801070c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $176
801070c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801070ce:	e9 56 f4 ff ff       	jmp    80106529 <alltraps>

801070d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $177
801070d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801070da:	e9 4a f4 ff ff       	jmp    80106529 <alltraps>

801070df <vector178>:
.globl vector178
vector178:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $178
801070e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801070e6:	e9 3e f4 ff ff       	jmp    80106529 <alltraps>

801070eb <vector179>:
.globl vector179
vector179:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $179
801070ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801070f2:	e9 32 f4 ff ff       	jmp    80106529 <alltraps>

801070f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $180
801070f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801070fe:	e9 26 f4 ff ff       	jmp    80106529 <alltraps>

80107103 <vector181>:
.globl vector181
vector181:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $181
80107105:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010710a:	e9 1a f4 ff ff       	jmp    80106529 <alltraps>

8010710f <vector182>:
.globl vector182
vector182:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $182
80107111:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107116:	e9 0e f4 ff ff       	jmp    80106529 <alltraps>

8010711b <vector183>:
.globl vector183
vector183:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $183
8010711d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107122:	e9 02 f4 ff ff       	jmp    80106529 <alltraps>

80107127 <vector184>:
.globl vector184
vector184:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $184
80107129:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010712e:	e9 f6 f3 ff ff       	jmp    80106529 <alltraps>

80107133 <vector185>:
.globl vector185
vector185:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $185
80107135:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010713a:	e9 ea f3 ff ff       	jmp    80106529 <alltraps>

8010713f <vector186>:
.globl vector186
vector186:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $186
80107141:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107146:	e9 de f3 ff ff       	jmp    80106529 <alltraps>

8010714b <vector187>:
.globl vector187
vector187:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $187
8010714d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107152:	e9 d2 f3 ff ff       	jmp    80106529 <alltraps>

80107157 <vector188>:
.globl vector188
vector188:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $188
80107159:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010715e:	e9 c6 f3 ff ff       	jmp    80106529 <alltraps>

80107163 <vector189>:
.globl vector189
vector189:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $189
80107165:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010716a:	e9 ba f3 ff ff       	jmp    80106529 <alltraps>

8010716f <vector190>:
.globl vector190
vector190:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $190
80107171:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107176:	e9 ae f3 ff ff       	jmp    80106529 <alltraps>

8010717b <vector191>:
.globl vector191
vector191:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $191
8010717d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107182:	e9 a2 f3 ff ff       	jmp    80106529 <alltraps>

80107187 <vector192>:
.globl vector192
vector192:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $192
80107189:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010718e:	e9 96 f3 ff ff       	jmp    80106529 <alltraps>

80107193 <vector193>:
.globl vector193
vector193:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $193
80107195:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010719a:	e9 8a f3 ff ff       	jmp    80106529 <alltraps>

8010719f <vector194>:
.globl vector194
vector194:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $194
801071a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801071a6:	e9 7e f3 ff ff       	jmp    80106529 <alltraps>

801071ab <vector195>:
.globl vector195
vector195:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $195
801071ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801071b2:	e9 72 f3 ff ff       	jmp    80106529 <alltraps>

801071b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $196
801071b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801071be:	e9 66 f3 ff ff       	jmp    80106529 <alltraps>

801071c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $197
801071c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801071ca:	e9 5a f3 ff ff       	jmp    80106529 <alltraps>

801071cf <vector198>:
.globl vector198
vector198:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $198
801071d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801071d6:	e9 4e f3 ff ff       	jmp    80106529 <alltraps>

801071db <vector199>:
.globl vector199
vector199:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $199
801071dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801071e2:	e9 42 f3 ff ff       	jmp    80106529 <alltraps>

801071e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $200
801071e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801071ee:	e9 36 f3 ff ff       	jmp    80106529 <alltraps>

801071f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $201
801071f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801071fa:	e9 2a f3 ff ff       	jmp    80106529 <alltraps>

801071ff <vector202>:
.globl vector202
vector202:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $202
80107201:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107206:	e9 1e f3 ff ff       	jmp    80106529 <alltraps>

8010720b <vector203>:
.globl vector203
vector203:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $203
8010720d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107212:	e9 12 f3 ff ff       	jmp    80106529 <alltraps>

80107217 <vector204>:
.globl vector204
vector204:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $204
80107219:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010721e:	e9 06 f3 ff ff       	jmp    80106529 <alltraps>

80107223 <vector205>:
.globl vector205
vector205:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $205
80107225:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010722a:	e9 fa f2 ff ff       	jmp    80106529 <alltraps>

8010722f <vector206>:
.globl vector206
vector206:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $206
80107231:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107236:	e9 ee f2 ff ff       	jmp    80106529 <alltraps>

8010723b <vector207>:
.globl vector207
vector207:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $207
8010723d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107242:	e9 e2 f2 ff ff       	jmp    80106529 <alltraps>

80107247 <vector208>:
.globl vector208
vector208:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $208
80107249:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010724e:	e9 d6 f2 ff ff       	jmp    80106529 <alltraps>

80107253 <vector209>:
.globl vector209
vector209:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $209
80107255:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010725a:	e9 ca f2 ff ff       	jmp    80106529 <alltraps>

8010725f <vector210>:
.globl vector210
vector210:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $210
80107261:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107266:	e9 be f2 ff ff       	jmp    80106529 <alltraps>

8010726b <vector211>:
.globl vector211
vector211:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $211
8010726d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107272:	e9 b2 f2 ff ff       	jmp    80106529 <alltraps>

80107277 <vector212>:
.globl vector212
vector212:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $212
80107279:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010727e:	e9 a6 f2 ff ff       	jmp    80106529 <alltraps>

80107283 <vector213>:
.globl vector213
vector213:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $213
80107285:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010728a:	e9 9a f2 ff ff       	jmp    80106529 <alltraps>

8010728f <vector214>:
.globl vector214
vector214:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $214
80107291:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107296:	e9 8e f2 ff ff       	jmp    80106529 <alltraps>

8010729b <vector215>:
.globl vector215
vector215:
  pushl $0
8010729b:	6a 00                	push   $0x0
  pushl $215
8010729d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801072a2:	e9 82 f2 ff ff       	jmp    80106529 <alltraps>

801072a7 <vector216>:
.globl vector216
vector216:
  pushl $0
801072a7:	6a 00                	push   $0x0
  pushl $216
801072a9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801072ae:	e9 76 f2 ff ff       	jmp    80106529 <alltraps>

801072b3 <vector217>:
.globl vector217
vector217:
  pushl $0
801072b3:	6a 00                	push   $0x0
  pushl $217
801072b5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801072ba:	e9 6a f2 ff ff       	jmp    80106529 <alltraps>

801072bf <vector218>:
.globl vector218
vector218:
  pushl $0
801072bf:	6a 00                	push   $0x0
  pushl $218
801072c1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801072c6:	e9 5e f2 ff ff       	jmp    80106529 <alltraps>

801072cb <vector219>:
.globl vector219
vector219:
  pushl $0
801072cb:	6a 00                	push   $0x0
  pushl $219
801072cd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801072d2:	e9 52 f2 ff ff       	jmp    80106529 <alltraps>

801072d7 <vector220>:
.globl vector220
vector220:
  pushl $0
801072d7:	6a 00                	push   $0x0
  pushl $220
801072d9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801072de:	e9 46 f2 ff ff       	jmp    80106529 <alltraps>

801072e3 <vector221>:
.globl vector221
vector221:
  pushl $0
801072e3:	6a 00                	push   $0x0
  pushl $221
801072e5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801072ea:	e9 3a f2 ff ff       	jmp    80106529 <alltraps>

801072ef <vector222>:
.globl vector222
vector222:
  pushl $0
801072ef:	6a 00                	push   $0x0
  pushl $222
801072f1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801072f6:	e9 2e f2 ff ff       	jmp    80106529 <alltraps>

801072fb <vector223>:
.globl vector223
vector223:
  pushl $0
801072fb:	6a 00                	push   $0x0
  pushl $223
801072fd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107302:	e9 22 f2 ff ff       	jmp    80106529 <alltraps>

80107307 <vector224>:
.globl vector224
vector224:
  pushl $0
80107307:	6a 00                	push   $0x0
  pushl $224
80107309:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010730e:	e9 16 f2 ff ff       	jmp    80106529 <alltraps>

80107313 <vector225>:
.globl vector225
vector225:
  pushl $0
80107313:	6a 00                	push   $0x0
  pushl $225
80107315:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010731a:	e9 0a f2 ff ff       	jmp    80106529 <alltraps>

8010731f <vector226>:
.globl vector226
vector226:
  pushl $0
8010731f:	6a 00                	push   $0x0
  pushl $226
80107321:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107326:	e9 fe f1 ff ff       	jmp    80106529 <alltraps>

8010732b <vector227>:
.globl vector227
vector227:
  pushl $0
8010732b:	6a 00                	push   $0x0
  pushl $227
8010732d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107332:	e9 f2 f1 ff ff       	jmp    80106529 <alltraps>

80107337 <vector228>:
.globl vector228
vector228:
  pushl $0
80107337:	6a 00                	push   $0x0
  pushl $228
80107339:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010733e:	e9 e6 f1 ff ff       	jmp    80106529 <alltraps>

80107343 <vector229>:
.globl vector229
vector229:
  pushl $0
80107343:	6a 00                	push   $0x0
  pushl $229
80107345:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010734a:	e9 da f1 ff ff       	jmp    80106529 <alltraps>

8010734f <vector230>:
.globl vector230
vector230:
  pushl $0
8010734f:	6a 00                	push   $0x0
  pushl $230
80107351:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107356:	e9 ce f1 ff ff       	jmp    80106529 <alltraps>

8010735b <vector231>:
.globl vector231
vector231:
  pushl $0
8010735b:	6a 00                	push   $0x0
  pushl $231
8010735d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107362:	e9 c2 f1 ff ff       	jmp    80106529 <alltraps>

80107367 <vector232>:
.globl vector232
vector232:
  pushl $0
80107367:	6a 00                	push   $0x0
  pushl $232
80107369:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010736e:	e9 b6 f1 ff ff       	jmp    80106529 <alltraps>

80107373 <vector233>:
.globl vector233
vector233:
  pushl $0
80107373:	6a 00                	push   $0x0
  pushl $233
80107375:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010737a:	e9 aa f1 ff ff       	jmp    80106529 <alltraps>

8010737f <vector234>:
.globl vector234
vector234:
  pushl $0
8010737f:	6a 00                	push   $0x0
  pushl $234
80107381:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107386:	e9 9e f1 ff ff       	jmp    80106529 <alltraps>

8010738b <vector235>:
.globl vector235
vector235:
  pushl $0
8010738b:	6a 00                	push   $0x0
  pushl $235
8010738d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107392:	e9 92 f1 ff ff       	jmp    80106529 <alltraps>

80107397 <vector236>:
.globl vector236
vector236:
  pushl $0
80107397:	6a 00                	push   $0x0
  pushl $236
80107399:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010739e:	e9 86 f1 ff ff       	jmp    80106529 <alltraps>

801073a3 <vector237>:
.globl vector237
vector237:
  pushl $0
801073a3:	6a 00                	push   $0x0
  pushl $237
801073a5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801073aa:	e9 7a f1 ff ff       	jmp    80106529 <alltraps>

801073af <vector238>:
.globl vector238
vector238:
  pushl $0
801073af:	6a 00                	push   $0x0
  pushl $238
801073b1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801073b6:	e9 6e f1 ff ff       	jmp    80106529 <alltraps>

801073bb <vector239>:
.globl vector239
vector239:
  pushl $0
801073bb:	6a 00                	push   $0x0
  pushl $239
801073bd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801073c2:	e9 62 f1 ff ff       	jmp    80106529 <alltraps>

801073c7 <vector240>:
.globl vector240
vector240:
  pushl $0
801073c7:	6a 00                	push   $0x0
  pushl $240
801073c9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801073ce:	e9 56 f1 ff ff       	jmp    80106529 <alltraps>

801073d3 <vector241>:
.globl vector241
vector241:
  pushl $0
801073d3:	6a 00                	push   $0x0
  pushl $241
801073d5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801073da:	e9 4a f1 ff ff       	jmp    80106529 <alltraps>

801073df <vector242>:
.globl vector242
vector242:
  pushl $0
801073df:	6a 00                	push   $0x0
  pushl $242
801073e1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801073e6:	e9 3e f1 ff ff       	jmp    80106529 <alltraps>

801073eb <vector243>:
.globl vector243
vector243:
  pushl $0
801073eb:	6a 00                	push   $0x0
  pushl $243
801073ed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801073f2:	e9 32 f1 ff ff       	jmp    80106529 <alltraps>

801073f7 <vector244>:
.globl vector244
vector244:
  pushl $0
801073f7:	6a 00                	push   $0x0
  pushl $244
801073f9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801073fe:	e9 26 f1 ff ff       	jmp    80106529 <alltraps>

80107403 <vector245>:
.globl vector245
vector245:
  pushl $0
80107403:	6a 00                	push   $0x0
  pushl $245
80107405:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010740a:	e9 1a f1 ff ff       	jmp    80106529 <alltraps>

8010740f <vector246>:
.globl vector246
vector246:
  pushl $0
8010740f:	6a 00                	push   $0x0
  pushl $246
80107411:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107416:	e9 0e f1 ff ff       	jmp    80106529 <alltraps>

8010741b <vector247>:
.globl vector247
vector247:
  pushl $0
8010741b:	6a 00                	push   $0x0
  pushl $247
8010741d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107422:	e9 02 f1 ff ff       	jmp    80106529 <alltraps>

80107427 <vector248>:
.globl vector248
vector248:
  pushl $0
80107427:	6a 00                	push   $0x0
  pushl $248
80107429:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010742e:	e9 f6 f0 ff ff       	jmp    80106529 <alltraps>

80107433 <vector249>:
.globl vector249
vector249:
  pushl $0
80107433:	6a 00                	push   $0x0
  pushl $249
80107435:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010743a:	e9 ea f0 ff ff       	jmp    80106529 <alltraps>

8010743f <vector250>:
.globl vector250
vector250:
  pushl $0
8010743f:	6a 00                	push   $0x0
  pushl $250
80107441:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107446:	e9 de f0 ff ff       	jmp    80106529 <alltraps>

8010744b <vector251>:
.globl vector251
vector251:
  pushl $0
8010744b:	6a 00                	push   $0x0
  pushl $251
8010744d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107452:	e9 d2 f0 ff ff       	jmp    80106529 <alltraps>

80107457 <vector252>:
.globl vector252
vector252:
  pushl $0
80107457:	6a 00                	push   $0x0
  pushl $252
80107459:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010745e:	e9 c6 f0 ff ff       	jmp    80106529 <alltraps>

80107463 <vector253>:
.globl vector253
vector253:
  pushl $0
80107463:	6a 00                	push   $0x0
  pushl $253
80107465:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010746a:	e9 ba f0 ff ff       	jmp    80106529 <alltraps>

8010746f <vector254>:
.globl vector254
vector254:
  pushl $0
8010746f:	6a 00                	push   $0x0
  pushl $254
80107471:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107476:	e9 ae f0 ff ff       	jmp    80106529 <alltraps>

8010747b <vector255>:
.globl vector255
vector255:
  pushl $0
8010747b:	6a 00                	push   $0x0
  pushl $255
8010747d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107482:	e9 a2 f0 ff ff       	jmp    80106529 <alltraps>
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
801074d4:	e8 47 b8 ff ff       	call   80102d20 <kalloc>
801074d9:	85 c0                	test   %eax,%eax
801074db:	89 c3                	mov    %eax,%ebx
801074dd:	74 21                	je     80107500 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801074df:	83 ec 04             	sub    $0x4,%esp
801074e2:	68 00 10 00 00       	push   $0x1000
801074e7:	6a 00                	push   $0x0
801074e9:	50                   	push   %eax
801074ea:	e8 f1 dd ff ff       	call   801052e0 <memset>
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
8010758d:	68 74 99 10 80       	push   $0x80109974
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
801075ad:	68 7a 99 10 80       	push   $0x8010997a
801075b2:	e8 a9 90 ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
801075b7:	e8 f4 cc ff ff       	call   801042b0 <myproc>
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
801075da:	68 8a 99 10 80       	push   $0x8010998a
801075df:	e8 7c 90 ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801075e4:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
801075e7:	83 c4 10             	add    $0x10,%esp
801075ea:	85 db                	test   %ebx,%ebx
801075ec:	75 e2                	jne    801075d0 <printlist+0x30>
  cprintf("\n");
801075ee:	83 ec 0c             	sub    $0xc,%esp
801075f1:	68 a0 9a 10 80       	push   $0x80109aa0
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
80107617:	68 91 99 10 80       	push   $0x80109991
8010761c:	e8 3f 90 ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
80107621:	e8 8a cc ff ff       	call   801042b0 <myproc>
80107626:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
8010762c:	8b 58 08             	mov    0x8(%eax),%ebx
8010762f:	e8 7c cc ff ff       	call   801042b0 <myproc>
80107634:	83 c4 0c             	add    $0xc,%esp
80107637:	53                   	push   %ebx
80107638:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
8010763e:	ff 70 08             	pushl  0x8(%eax)
80107641:	68 a3 99 10 80       	push   $0x801099a3
80107646:	e8 15 90 ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010764b:	e8 60 cc ff ff       	call   801042b0 <myproc>
80107650:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107656:	83 c4 10             	add    $0x10,%esp
80107659:	8b 50 04             	mov    0x4(%eax),%edx
8010765c:	85 d2                	test   %edx,%edx
8010765e:	74 68                	je     801076c8 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
80107660:	e8 4b cc ff ff       	call   801042b0 <myproc>
80107665:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010766b:	85 db                	test   %ebx,%ebx
8010766d:	74 1a                	je     80107689 <printaq+0x79>
8010766f:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
80107670:	83 ec 08             	sub    $0x8,%esp
80107673:	ff 73 08             	pushl  0x8(%ebx)
80107676:	68 c1 99 10 80       	push   $0x801099c1
8010767b:	e8 e0 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107680:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
80107682:	83 c4 10             	add    $0x10,%esp
80107685:	85 db                	test   %ebx,%ebx
80107687:	75 e7                	jne    80107670 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
80107689:	e8 22 cc ff ff       	call   801042b0 <myproc>
8010768e:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80107694:	8b 00                	mov    (%eax),%eax
80107696:	85 c0                	test   %eax,%eax
80107698:	74 16                	je     801076b0 <printaq+0xa0>
  cprintf("\n");
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	68 a0 9a 10 80       	push   $0x80109aa0
801076a2:	e8 b9 8f ff ff       	call   80100660 <cprintf>
}
801076a7:	83 c4 10             	add    $0x10,%esp
801076aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801076ad:	c9                   	leave  
801076ae:	c3                   	ret    
801076af:	90                   	nop
    cprintf("null <-> ");
801076b0:	83 ec 0c             	sub    $0xc,%esp
801076b3:	68 b7 99 10 80       	push   $0x801099b7
801076b8:	e8 a3 8f ff ff       	call   80100660 <cprintf>
801076bd:	83 c4 10             	add    $0x10,%esp
801076c0:	eb d8                	jmp    8010769a <printaq+0x8a>
801076c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
801076c8:	83 ec 0c             	sub    $0xc,%esp
801076cb:	68 b7 99 10 80       	push   $0x801099b7
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
801076e6:	e8 a5 cb ff ff       	call   80104290 <cpuid>
801076eb:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801076f1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801076f6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801076fa:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
80107701:	ff 00 00 
80107704:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
8010770b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010770e:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
80107715:	ff 00 00 
80107718:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
8010771f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107722:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
80107729:	ff 00 00 
8010772c:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
80107733:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107736:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
8010773d:	ff 00 00 
80107740:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
80107747:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010774a:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
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
80107770:	a1 84 75 19 80       	mov    0x80197584,%eax
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
801077ba:	e8 41 d9 ff ff       	call   80105100 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801077bf:	e8 4c ca ff ff       	call   80104210 <mycpu>
801077c4:	89 c6                	mov    %eax,%esi
801077c6:	e8 45 ca ff ff       	call   80104210 <mycpu>
801077cb:	89 c7                	mov    %eax,%edi
801077cd:	e8 3e ca ff ff       	call   80104210 <mycpu>
801077d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077d5:	83 c7 08             	add    $0x8,%edi
801077d8:	e8 33 ca ff ff       	call   80104210 <mycpu>
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
80107821:	e8 ea c9 ff ff       	call   80104210 <mycpu>
80107826:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010782d:	e8 de c9 ff ff       	call   80104210 <mycpu>
80107832:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107836:	8b 73 08             	mov    0x8(%ebx),%esi
80107839:	e8 d2 c9 ff ff       	call   80104210 <mycpu>
8010783e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107844:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107847:	e8 c4 c9 ff ff       	call   80104210 <mycpu>
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
8010786a:	e9 d1 d8 ff ff       	jmp    80105140 <popcli>
    panic("switchuvm: no process");
8010786f:	83 ec 0c             	sub    $0xc,%esp
80107872:	68 c9 99 10 80       	push   $0x801099c9
80107877:	e8 14 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010787c:	83 ec 0c             	sub    $0xc,%esp
8010787f:	68 f4 99 10 80       	push   $0x801099f4
80107884:	e8 07 8b ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107889:	83 ec 0c             	sub    $0xc,%esp
8010788c:	68 df 99 10 80       	push   $0x801099df
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
801078bd:	e8 5e b4 ff ff       	call   80102d20 <kalloc>
  memset(mem, 0, PGSIZE);
801078c2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
801078c5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801078c7:	68 00 10 00 00       	push   $0x1000
801078cc:	6a 00                	push   $0x0
801078ce:	50                   	push   %eax
801078cf:	e8 0c da ff ff       	call   801052e0 <memset>
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
80107901:	e9 8a da ff ff       	jmp    80105390 <memmove>
    panic("inituvm: more than a page");
80107906:	83 ec 0c             	sub    $0xc,%esp
80107909:	68 08 9a 10 80       	push   $0x80109a08
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
80107991:	e8 7a a3 ff ff       	call   80101d10 <readi>
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
801079bd:	68 22 9a 10 80       	push   $0x80109a22
801079c2:	e8 c9 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801079c7:	83 ec 0c             	sub    $0xc,%esp
801079ca:	68 b8 9b 10 80       	push   $0x80109bb8
801079cf:	e8 bc 89 ff ff       	call   80100390 <panic>
801079d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801079e0 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	53                   	push   %ebx
801079e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
801079e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
801079ea:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
801079f0:	6b c2 1c             	imul   $0x1c,%edx,%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  // cprintf("filling ram slot: %d\n", curproc->num_ram);
  // cprintf("allocating addr : %p\n\n", rounded_virtaddr);

  curproc->num_ram++;
801079f3:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
801079f6:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
801079f8:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
801079fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107a01:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107a08:	00 00 00 
  page->swap_offset = -1;
80107a0b:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107a12:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107a15:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107a1b:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
  
}
80107a21:	5b                   	pop    %ebx
80107a22:	5d                   	pop    %ebp
80107a23:	c3                   	ret    
80107a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107a30 <allocuvm_withswap>:



void
allocuvm_withswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107a30:	55                   	push   %ebp
80107a31:	89 e5                	mov    %esp,%ebp
80107a33:	57                   	push   %edi
80107a34:	56                   	push   %esi
80107a35:	53                   	push   %ebx
80107a36:	83 ec 0c             	sub    $0xc,%esp
80107a39:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107a3c:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
80107a43:	0f 8f 1c 01 00 00    	jg     80107b65 <allocuvm_withswap+0x135>

      // get info of the page to be evicted
      uint evicted_ind = indexToEvict();
      // cprintf("[allocuvm] index to evict: %d\n",evicted_ind);
      struct page *evicted_page = &curproc->ramPages[evicted_ind];
      int swap_offset = curproc->free_head->off;
80107a49:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx

      if(curproc->free_head->next == 0)
80107a4f:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80107a52:	8b 32                	mov    (%edx),%esi
      if(curproc->free_head->next == 0)
80107a54:	85 c0                	test   %eax,%eax
80107a56:	0f 84 e4 00 00 00    	je     80107b40 <allocuvm_withswap+0x110>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80107a5c:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107a5f:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80107a65:	ff 70 08             	pushl  0x8(%eax)
80107a68:	e8 e3 af ff ff       	call   80102a50 <kfree>
80107a6d:	83 c4 10             	add    $0x10,%esp
      }

      // cprintf("before write to swap\n");
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80107a70:	68 00 10 00 00       	push   $0x1000
80107a75:	56                   	push   %esi
80107a76:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
80107a7c:	53                   	push   %ebx
80107a7d:	e8 7e ab ff ff       	call   80102600 <writeToSwapFile>
80107a82:	83 c4 10             	add    $0x10,%esp
80107a85:	85 c0                	test   %eax,%eax
80107a87:	0f 88 f2 00 00 00    	js     80107b7f <allocuvm_withswap+0x14f>
        panic("allocuvm: writeToSwapFile");


      curproc->swappedPages[curproc->num_swap].isused = 1;
80107a8d:	8b bb 0c 04 00 00    	mov    0x40c(%ebx),%edi
80107a93:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80107a96:	01 d9                	add    %ebx,%ecx
80107a98:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80107a9f:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107aa2:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80107aa8:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107aae:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107ab4:	89 b1 94 00 00 00    	mov    %esi,0x94(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107aba:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      // cprintf("num swap: %d\n", curproc->num_swap);
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107ac0:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107ac6:	0f 22 d9             	mov    %ecx,%cr3
      curproc->num_swap ++;
80107ac9:	83 c7 01             	add    $0x1,%edi


      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107acc:	31 c9                	xor    %ecx,%ecx
      curproc->num_swap ++;
80107ace:	89 bb 0c 04 00 00    	mov    %edi,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107ad4:	e8 b7 f9 ff ff       	call   80107490 <walkpgdir>



      if(!(*evicted_pte & PTE_P))
80107ad9:	8b 10                	mov    (%eax),%edx
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107adb:	89 c6                	mov    %eax,%esi
      if(!(*evicted_pte & PTE_P))
80107add:	f6 c2 01             	test   $0x1,%dl
80107ae0:	0f 84 8c 00 00 00    	je     80107b72 <allocuvm_withswap+0x142>
        panic("allocuvm: swap: ram page not present");
      
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107ae6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      

      kfree(P2V(evicted_pa));
80107aec:	83 ec 0c             	sub    $0xc,%esp
80107aef:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107af5:	52                   	push   %edx
80107af6:	e8 55 af ff ff       	call   80102a50 <kfree>

      *evicted_pte &= 0xFFF; // ???

      *evicted_pte |= PTE_PG;
      *evicted_pte &= ~PTE_P;
80107afb:	8b 16                	mov    (%esi),%edx
    

      struct page *newpage = &curproc->ramPages[evicted_ind];
      newpage->isused = 1;
      newpage->pgdir = pgdir; // ??? 
80107afd:	8b 45 0c             	mov    0xc(%ebp),%eax
      newpage->swap_offset = -1;
      newpage->virt_addr = rounded_virtaddr;
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
     
}
80107b00:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
80107b03:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
80107b09:	80 ce 02             	or     $0x2,%dh
80107b0c:	89 16                	mov    %edx,(%esi)
      newpage->pgdir = pgdir; // ??? 
80107b0e:	89 83 9c 02 00 00    	mov    %eax,0x29c(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80107b14:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->isused = 1;
80107b17:	c7 83 a0 02 00 00 01 	movl   $0x1,0x2a0(%ebx)
80107b1e:	00 00 00 
      newpage->swap_offset = -1;
80107b21:	c7 83 a8 02 00 00 ff 	movl   $0xffffffff,0x2a8(%ebx)
80107b28:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
80107b2b:	89 83 a4 02 00 00    	mov    %eax,0x2a4(%ebx)
}
80107b31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107b34:	5b                   	pop    %ebx
80107b35:	5e                   	pop    %esi
80107b36:	5f                   	pop    %edi
80107b37:	5d                   	pop    %ebp
80107b38:	c3                   	ret    
80107b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
80107b40:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80107b43:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80107b4a:	00 00 00 
        kfree((char*)curproc->free_head);
80107b4d:	52                   	push   %edx
80107b4e:	e8 fd ae ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80107b53:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80107b5a:	00 00 00 
80107b5d:	83 c4 10             	add    $0x10,%esp
80107b60:	e9 0b ff ff ff       	jmp    80107a70 <allocuvm_withswap+0x40>
        panic("page limit exceeded");
80107b65:	83 ec 0c             	sub    $0xc,%esp
80107b68:	68 40 9a 10 80       	push   $0x80109a40
80107b6d:	e8 1e 88 ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80107b72:	83 ec 0c             	sub    $0xc,%esp
80107b75:	68 dc 9b 10 80       	push   $0x80109bdc
80107b7a:	e8 11 88 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80107b7f:	83 ec 0c             	sub    $0xc,%esp
80107b82:	68 54 9a 10 80       	push   $0x80109a54
80107b87:	e8 04 88 ff ff       	call   80100390 <panic>
80107b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b90 <allocuvm_paging>:
{
80107b90:	55                   	push   %ebp
80107b91:	89 e5                	mov    %esp,%ebp
80107b93:	56                   	push   %esi
80107b94:	53                   	push   %ebx
80107b95:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107b98:	8b 75 0c             	mov    0xc(%ebp),%esi
80107b9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107b9e:	8b 81 08 04 00 00    	mov    0x408(%ecx),%eax
80107ba4:	83 f8 0f             	cmp    $0xf,%eax
80107ba7:	7f 37                	jg     80107be0 <allocuvm_paging+0x50>
  page->isused = 1;
80107ba9:	6b d0 1c             	imul   $0x1c,%eax,%edx
  curproc->num_ram++;
80107bac:	83 c0 01             	add    $0x1,%eax
  page->isused = 1;
80107baf:	01 ca                	add    %ecx,%edx
80107bb1:	c7 82 4c 02 00 00 01 	movl   $0x1,0x24c(%edx)
80107bb8:	00 00 00 
  page->pgdir = pgdir;
80107bbb:	89 b2 48 02 00 00    	mov    %esi,0x248(%edx)
  page->swap_offset = -1;
80107bc1:	c7 82 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edx)
80107bc8:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107bcb:	89 9a 50 02 00 00    	mov    %ebx,0x250(%edx)
  curproc->num_ram++;
80107bd1:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
}
80107bd7:	5b                   	pop    %ebx
80107bd8:	5e                   	pop    %esi
80107bd9:	5d                   	pop    %ebp
80107bda:	c3                   	ret    
80107bdb:	90                   	nop
80107bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107be0:	5b                   	pop    %ebx
80107be1:	5e                   	pop    %esi
80107be2:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107be3:	e9 48 fe ff ff       	jmp    80107a30 <allocuvm_withswap>
80107be8:	90                   	nop
80107be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107bf0 <update_selectionfiled_allocuvm>:

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107bf0:	55                   	push   %ebp
80107bf1:	89 e5                	mov    %esp,%ebp
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107bf3:	5d                   	pop    %ebp
80107bf4:	c3                   	ret    
80107bf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107c00 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107c00:	55                   	push   %ebp
80107c01:	89 e5                	mov    %esp,%ebp
80107c03:	57                   	push   %edi
80107c04:	56                   	push   %esi
80107c05:	53                   	push   %ebx
80107c06:	83 ec 5c             	sub    $0x5c,%esp
80107c09:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107c0c:	e8 9f c6 ff ff       	call   801042b0 <myproc>
80107c11:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107c14:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c17:	39 45 10             	cmp    %eax,0x10(%ebp)
80107c1a:	0f 83 a3 00 00 00    	jae    80107cc3 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107c20:	8b 45 10             	mov    0x10(%ebp),%eax
80107c23:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107c29:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107c2f:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c32:	77 6a                	ja     80107c9e <deallocuvm+0x9e>
80107c34:	e9 87 00 00 00       	jmp    80107cc0 <deallocuvm+0xc0>
80107c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107c40:	8b 00                	mov    (%eax),%eax
80107c42:	a8 01                	test   $0x1,%al
80107c44:	74 4d                	je     80107c93 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107c46:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c4b:	0f 84 b3 01 00 00    	je     80107e04 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107c51:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107c57:	83 ec 0c             	sub    $0xc,%esp
80107c5a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107c5d:	53                   	push   %ebx
80107c5e:	e8 4d b2 ff ff       	call   80102eb0 <getRefs>
80107c63:	83 c4 10             	add    $0x10,%esp
80107c66:	83 f8 01             	cmp    $0x1,%eax
80107c69:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107c6c:	0f 84 7e 01 00 00    	je     80107df0 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107c72:	83 ec 0c             	sub    $0xc,%esp
80107c75:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107c78:	53                   	push   %ebx
80107c79:	e8 52 b1 ff ff       	call   80102dd0 <refDec>
80107c7e:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107c81:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107c84:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107c87:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107c8b:	7f 43                	jg     80107cd0 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107c8d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107c93:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107c99:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107c9c:	76 22                	jbe    80107cc0 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107c9e:	31 c9                	xor    %ecx,%ecx
80107ca0:	89 f2                	mov    %esi,%edx
80107ca2:	89 f8                	mov    %edi,%eax
80107ca4:	e8 e7 f7 ff ff       	call   80107490 <walkpgdir>
    if(!pte)
80107ca9:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107cab:	89 c2                	mov    %eax,%edx
    if(!pte)
80107cad:	75 91                	jne    80107c40 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107caf:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107cb5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107cbb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cbe:	77 de                	ja     80107c9e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107cc0:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107cc6:	5b                   	pop    %ebx
80107cc7:	5e                   	pop    %esi
80107cc8:	5f                   	pop    %edi
80107cc9:	5d                   	pop    %ebp
80107cca:	c3                   	ret    
80107ccb:	90                   	nop
80107ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cd0:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107cd6:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107cd9:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107cdf:	89 fa                	mov    %edi,%edx
80107ce1:	89 cf                	mov    %ecx,%edi
80107ce3:	eb 17                	jmp    80107cfc <deallocuvm+0xfc>
80107ce5:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107ce8:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107ceb:	0f 84 b7 00 00 00    	je     80107da8 <deallocuvm+0x1a8>
80107cf1:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107cf4:	39 fb                	cmp    %edi,%ebx
80107cf6:	0f 84 e4 00 00 00    	je     80107de0 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107cfc:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107d02:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107d05:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107d0b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107d0e:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107d14:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107d17:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107d1d:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107d20:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107d23:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107d29:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107d2c:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107d32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107d35:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107d3b:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107d3e:	8b 03                	mov    (%ebx),%eax
80107d40:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107d43:	8b 43 04             	mov    0x4(%ebx),%eax
80107d46:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107d49:	8b 43 08             	mov    0x8(%ebx),%eax
80107d4c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107d4f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107d52:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107d55:	8b 43 10             	mov    0x10(%ebx),%eax
80107d58:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107d5b:	8b 43 14             	mov    0x14(%ebx),%eax
80107d5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107d61:	8b 43 18             	mov    0x18(%ebx),%eax
80107d64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107d67:	0f 85 7b ff ff ff    	jne    80107ce8 <deallocuvm+0xe8>
80107d6d:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107d70:	0f 85 72 ff ff ff    	jne    80107ce8 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107d76:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107d79:	83 ec 04             	sub    $0x4,%esp
80107d7c:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107d7f:	6a 1c                	push   $0x1c
80107d81:	6a 00                	push   $0x0
80107d83:	50                   	push   %eax
80107d84:	e8 57 d5 ff ff       	call   801052e0 <memset>
            curproc->num_ram -- ;
80107d89:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107d8c:	83 c4 10             	add    $0x10,%esp
80107d8f:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107d92:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107d99:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107d9c:	0f 85 4f ff ff ff    	jne    80107cf1 <deallocuvm+0xf1>
80107da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107da8:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107dab:	0f 85 40 ff ff ff    	jne    80107cf1 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107db1:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107db4:	83 ec 04             	sub    $0x4,%esp
80107db7:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107dba:	6a 1c                	push   $0x1c
80107dbc:	6a 00                	push   $0x0
80107dbe:	83 c3 1c             	add    $0x1c,%ebx
80107dc1:	50                   	push   %eax
80107dc2:	e8 19 d5 ff ff       	call   801052e0 <memset>
            curproc->num_swap --;
80107dc7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107dca:	83 c4 10             	add    $0x10,%esp
80107dcd:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107dd0:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107dd7:	39 fb                	cmp    %edi,%ebx
80107dd9:	0f 85 1d ff ff ff    	jne    80107cfc <deallocuvm+0xfc>
80107ddf:	90                   	nop
80107de0:	89 d7                	mov    %edx,%edi
80107de2:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107de5:	e9 a3 fe ff ff       	jmp    80107c8d <deallocuvm+0x8d>
80107dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107df0:	83 ec 0c             	sub    $0xc,%esp
80107df3:	53                   	push   %ebx
80107df4:	e8 57 ac ff ff       	call   80102a50 <kfree>
80107df9:	83 c4 10             	add    $0x10,%esp
80107dfc:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107dff:	e9 80 fe ff ff       	jmp    80107c84 <deallocuvm+0x84>
        panic("kfree");
80107e04:	83 ec 0c             	sub    $0xc,%esp
80107e07:	68 da 91 10 80       	push   $0x801091da
80107e0c:	e8 7f 85 ff ff       	call   80100390 <panic>
80107e11:	eb 0d                	jmp    80107e20 <allocuvm>
80107e13:	90                   	nop
80107e14:	90                   	nop
80107e15:	90                   	nop
80107e16:	90                   	nop
80107e17:	90                   	nop
80107e18:	90                   	nop
80107e19:	90                   	nop
80107e1a:	90                   	nop
80107e1b:	90                   	nop
80107e1c:	90                   	nop
80107e1d:	90                   	nop
80107e1e:	90                   	nop
80107e1f:	90                   	nop

80107e20 <allocuvm>:
{
80107e20:	55                   	push   %ebp
80107e21:	89 e5                	mov    %esp,%ebp
80107e23:	57                   	push   %edi
80107e24:	56                   	push   %esi
80107e25:	53                   	push   %ebx
80107e26:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107e29:	e8 82 c4 ff ff       	call   801042b0 <myproc>
80107e2e:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107e30:	8b 45 10             	mov    0x10(%ebp),%eax
80107e33:	85 c0                	test   %eax,%eax
80107e35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107e38:	0f 88 e2 00 00 00    	js     80107f20 <allocuvm+0x100>
  if(newsz < oldsz)
80107e3e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107e41:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107e44:	0f 82 c6 00 00 00    	jb     80107f10 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
80107e4a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107e50:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107e56:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107e59:	77 41                	ja     80107e9c <allocuvm+0x7c>
80107e5b:	e9 b3 00 00 00       	jmp    80107f13 <allocuvm+0xf3>
  page->isused = 1;
80107e60:	6b c2 1c             	imul   $0x1c,%edx,%eax
  page->pgdir = pgdir;
80107e63:	8b 4d 08             	mov    0x8(%ebp),%ecx
  curproc->num_ram++;
80107e66:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107e69:	01 f8                	add    %edi,%eax
80107e6b:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107e72:	00 00 00 
  page->pgdir = pgdir;
80107e75:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->swap_offset = -1;
80107e7b:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107e82:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107e85:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107e8b:	89 97 08 04 00 00    	mov    %edx,0x408(%edi)
  for(; a < newsz; a += PGSIZE){
80107e91:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107e97:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107e9a:	76 77                	jbe    80107f13 <allocuvm+0xf3>
    mem = kalloc();
80107e9c:	e8 7f ae ff ff       	call   80102d20 <kalloc>
    if(mem == 0){
80107ea1:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107ea3:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107ea5:	0f 84 8d 00 00 00    	je     80107f38 <allocuvm+0x118>
    memset(mem, 0, PGSIZE);
80107eab:	83 ec 04             	sub    $0x4,%esp
80107eae:	68 00 10 00 00       	push   $0x1000
80107eb3:	6a 00                	push   $0x0
80107eb5:	50                   	push   %eax
80107eb6:	e8 25 d4 ff ff       	call   801052e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107ebb:	58                   	pop    %eax
80107ebc:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107ec2:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107ec7:	5a                   	pop    %edx
80107ec8:	6a 06                	push   $0x6
80107eca:	50                   	push   %eax
80107ecb:	89 da                	mov    %ebx,%edx
80107ecd:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed0:	e8 3b f6 ff ff       	call   80107510 <mappages>
80107ed5:	83 c4 10             	add    $0x10,%esp
80107ed8:	85 c0                	test   %eax,%eax
80107eda:	0f 88 90 00 00 00    	js     80107f70 <allocuvm+0x150>
    if(curproc->pid > 2) 
80107ee0:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107ee4:	7e ab                	jle    80107e91 <allocuvm+0x71>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107ee6:	8b 97 08 04 00 00    	mov    0x408(%edi),%edx
80107eec:	83 fa 0f             	cmp    $0xf,%edx
80107eef:	0f 8e 6b ff ff ff    	jle    80107e60 <allocuvm+0x40>
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107ef5:	83 ec 04             	sub    $0x4,%esp
80107ef8:	53                   	push   %ebx
80107ef9:	ff 75 08             	pushl  0x8(%ebp)
80107efc:	57                   	push   %edi
80107efd:	e8 2e fb ff ff       	call   80107a30 <allocuvm_withswap>
80107f02:	83 c4 10             	add    $0x10,%esp
80107f05:	eb 8a                	jmp    80107e91 <allocuvm+0x71>
80107f07:	89 f6                	mov    %esi,%esi
80107f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
80107f10:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107f13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f19:	5b                   	pop    %ebx
80107f1a:	5e                   	pop    %esi
80107f1b:	5f                   	pop    %edi
80107f1c:	5d                   	pop    %ebp
80107f1d:	c3                   	ret    
80107f1e:	66 90                	xchg   %ax,%ax
    return 0;
80107f20:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f2d:	5b                   	pop    %ebx
80107f2e:	5e                   	pop    %esi
80107f2f:	5f                   	pop    %edi
80107f30:	5d                   	pop    %ebp
80107f31:	c3                   	ret    
80107f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107f38:	83 ec 0c             	sub    $0xc,%esp
80107f3b:	68 6e 9a 10 80       	push   $0x80109a6e
80107f40:	e8 1b 87 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107f45:	83 c4 0c             	add    $0xc,%esp
80107f48:	ff 75 0c             	pushl  0xc(%ebp)
80107f4b:	ff 75 10             	pushl  0x10(%ebp)
80107f4e:	ff 75 08             	pushl  0x8(%ebp)
80107f51:	e8 aa fc ff ff       	call   80107c00 <deallocuvm>
      return 0;
80107f56:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80107f5d:	83 c4 10             	add    $0x10,%esp
}
80107f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107f66:	5b                   	pop    %ebx
80107f67:	5e                   	pop    %esi
80107f68:	5f                   	pop    %edi
80107f69:	5d                   	pop    %ebp
80107f6a:	c3                   	ret    
80107f6b:	90                   	nop
80107f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80107f70:	83 ec 0c             	sub    $0xc,%esp
80107f73:	68 86 9a 10 80       	push   $0x80109a86
80107f78:	e8 e3 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107f7d:	83 c4 0c             	add    $0xc,%esp
80107f80:	ff 75 0c             	pushl  0xc(%ebp)
80107f83:	ff 75 10             	pushl  0x10(%ebp)
80107f86:	ff 75 08             	pushl  0x8(%ebp)
80107f89:	e8 72 fc ff ff       	call   80107c00 <deallocuvm>
      kfree(mem);
80107f8e:	89 34 24             	mov    %esi,(%esp)
80107f91:	e8 ba aa ff ff       	call   80102a50 <kfree>
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

80107fb0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107fb0:	55                   	push   %ebp
80107fb1:	89 e5                	mov    %esp,%ebp
80107fb3:	57                   	push   %edi
80107fb4:	56                   	push   %esi
80107fb5:	53                   	push   %ebx
80107fb6:	83 ec 0c             	sub    $0xc,%esp
80107fb9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107fbc:	85 f6                	test   %esi,%esi
80107fbe:	74 59                	je     80108019 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80107fc0:	83 ec 04             	sub    $0x4,%esp
80107fc3:	89 f3                	mov    %esi,%ebx
80107fc5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107fcb:	6a 00                	push   $0x0
80107fcd:	68 00 00 00 80       	push   $0x80000000
80107fd2:	56                   	push   %esi
80107fd3:	e8 28 fc ff ff       	call   80107c00 <deallocuvm>
80107fd8:	83 c4 10             	add    $0x10,%esp
80107fdb:	eb 0a                	jmp    80107fe7 <freevm+0x37>
80107fdd:	8d 76 00             	lea    0x0(%esi),%esi
80107fe0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107fe3:	39 fb                	cmp    %edi,%ebx
80107fe5:	74 23                	je     8010800a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107fe7:	8b 03                	mov    (%ebx),%eax
80107fe9:	a8 01                	test   $0x1,%al
80107feb:	74 f3                	je     80107fe0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107fed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107ff2:	83 ec 0c             	sub    $0xc,%esp
80107ff5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107ff8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80107ffd:	50                   	push   %eax
80107ffe:	e8 4d aa ff ff       	call   80102a50 <kfree>
80108003:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108006:	39 fb                	cmp    %edi,%ebx
80108008:	75 dd                	jne    80107fe7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010800a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010800d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108010:	5b                   	pop    %ebx
80108011:	5e                   	pop    %esi
80108012:	5f                   	pop    %edi
80108013:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80108014:	e9 37 aa ff ff       	jmp    80102a50 <kfree>
    panic("freevm: no pgdir");
80108019:	83 ec 0c             	sub    $0xc,%esp
8010801c:	68 a2 9a 10 80       	push   $0x80109aa2
80108021:	e8 6a 83 ff ff       	call   80100390 <panic>
80108026:	8d 76 00             	lea    0x0(%esi),%esi
80108029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108030 <setupkvm>:
{
80108030:	55                   	push   %ebp
80108031:	89 e5                	mov    %esp,%ebp
80108033:	56                   	push   %esi
80108034:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80108035:	e8 e6 ac ff ff       	call   80102d20 <kalloc>
8010803a:	85 c0                	test   %eax,%eax
8010803c:	89 c6                	mov    %eax,%esi
8010803e:	74 42                	je     80108082 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108040:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108043:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108048:	68 00 10 00 00       	push   $0x1000
8010804d:	6a 00                	push   $0x0
8010804f:	50                   	push   %eax
80108050:	e8 8b d2 ff ff       	call   801052e0 <memset>
80108055:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108058:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010805b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010805e:	83 ec 08             	sub    $0x8,%esp
80108061:	8b 13                	mov    (%ebx),%edx
80108063:	ff 73 0c             	pushl  0xc(%ebx)
80108066:	50                   	push   %eax
80108067:	29 c1                	sub    %eax,%ecx
80108069:	89 f0                	mov    %esi,%eax
8010806b:	e8 a0 f4 ff ff       	call   80107510 <mappages>
80108070:	83 c4 10             	add    $0x10,%esp
80108073:	85 c0                	test   %eax,%eax
80108075:	78 19                	js     80108090 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108077:	83 c3 10             	add    $0x10,%ebx
8010807a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108080:	75 d6                	jne    80108058 <setupkvm+0x28>
}
80108082:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108085:	89 f0                	mov    %esi,%eax
80108087:	5b                   	pop    %ebx
80108088:	5e                   	pop    %esi
80108089:	5d                   	pop    %ebp
8010808a:	c3                   	ret    
8010808b:	90                   	nop
8010808c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80108090:	83 ec 0c             	sub    $0xc,%esp
80108093:	68 b3 9a 10 80       	push   $0x80109ab3
80108098:	e8 c3 85 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
8010809d:	89 34 24             	mov    %esi,(%esp)
      return 0;
801080a0:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801080a2:	e8 09 ff ff ff       	call   80107fb0 <freevm>
      return 0;
801080a7:	83 c4 10             	add    $0x10,%esp
}
801080aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801080ad:	89 f0                	mov    %esi,%eax
801080af:	5b                   	pop    %ebx
801080b0:	5e                   	pop    %esi
801080b1:	5d                   	pop    %ebp
801080b2:	c3                   	ret    
801080b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801080b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080c0 <kvmalloc>:
{
801080c0:	55                   	push   %ebp
801080c1:	89 e5                	mov    %esp,%ebp
801080c3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080c6:	e8 65 ff ff ff       	call   80108030 <setupkvm>
801080cb:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801080d0:	05 00 00 00 80       	add    $0x80000000,%eax
801080d5:	0f 22 d8             	mov    %eax,%cr3
}
801080d8:	c9                   	leave  
801080d9:	c3                   	ret    
801080da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801080e0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801080e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801080e1:	31 c9                	xor    %ecx,%ecx
{
801080e3:	89 e5                	mov    %esp,%ebp
801080e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801080e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801080eb:	8b 45 08             	mov    0x8(%ebp),%eax
801080ee:	e8 9d f3 ff ff       	call   80107490 <walkpgdir>
  if(pte == 0)
801080f3:	85 c0                	test   %eax,%eax
801080f5:	74 05                	je     801080fc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801080f7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801080fa:	c9                   	leave  
801080fb:	c3                   	ret    
    panic("clearpteu");
801080fc:	83 ec 0c             	sub    $0xc,%esp
801080ff:	68 cf 9a 10 80       	push   $0x80109acf
80108104:	e8 87 82 ff ff       	call   80100390 <panic>
80108109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108110 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
80108110:	55                   	push   %ebp
80108111:	89 e5                	mov    %esp,%ebp
80108113:	57                   	push   %edi
80108114:	56                   	push   %esi
80108115:	53                   	push   %ebx
80108116:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
80108119:	e8 12 ff ff ff       	call   80108030 <setupkvm>
8010811e:	85 c0                	test   %eax,%eax
80108120:	89 c7                	mov    %eax,%edi
80108122:	0f 84 ce 00 00 00    	je     801081f6 <cowuvm+0xe6>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
80108128:	8b 45 0c             	mov    0xc(%ebp),%eax
8010812b:	85 c0                	test   %eax,%eax
8010812d:	0f 84 c3 00 00 00    	je     801081f6 <cowuvm+0xe6>
80108133:	8b 45 08             	mov    0x8(%ebp),%eax
80108136:	31 db                	xor    %ebx,%ebx
80108138:	05 00 00 00 80       	add    $0x80000000,%eax
8010813d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108140:	eb 62                	jmp    801081a4 <cowuvm+0x94>
80108142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *pte = PTE_U | PTE_W | PTE_PG;
       continue;
    }
    
    *pte |= PTE_COW;
    *pte &= ~PTE_W;
80108148:	89 d1                	mov    %edx,%ecx
8010814a:	89 d6                	mov    %edx,%esi

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
8010814c:	81 e2 fd 0f 00 00    	and    $0xffd,%edx
    *pte &= ~PTE_W;
80108152:	83 e1 fd             	and    $0xfffffffd,%ecx
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80108155:	83 ec 08             	sub    $0x8,%esp
    flags = PTE_FLAGS(*pte);
80108158:	80 ce 04             	or     $0x4,%dh
    *pte &= ~PTE_W;
8010815b:	80 cd 04             	or     $0x4,%ch
8010815e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80108164:	89 08                	mov    %ecx,(%eax)
    if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
80108166:	52                   	push   %edx
80108167:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010816c:	56                   	push   %esi
8010816d:	89 da                	mov    %ebx,%edx
8010816f:	89 f8                	mov    %edi,%eax
80108171:	e8 9a f3 ff ff       	call   80107510 <mappages>
80108176:	83 c4 10             	add    $0x10,%esp
80108179:	85 c0                	test   %eax,%eax
8010817b:	0f 88 7f 00 00 00    	js     80108200 <cowuvm+0xf0>
      goto bad;

    char *virt_addr = P2V(pa);
    refInc(virt_addr);
80108181:	83 ec 0c             	sub    $0xc,%esp
    char *virt_addr = P2V(pa);
80108184:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    refInc(virt_addr);
8010818a:	56                   	push   %esi
8010818b:	e8 b0 ac ff ff       	call   80102e40 <refInc>
80108190:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108193:	0f 22 d8             	mov    %eax,%cr3
80108196:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
80108199:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010819f:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801081a2:	76 52                	jbe    801081f6 <cowuvm+0xe6>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801081a4:	8b 45 08             	mov    0x8(%ebp),%eax
801081a7:	31 c9                	xor    %ecx,%ecx
801081a9:	89 da                	mov    %ebx,%edx
801081ab:	e8 e0 f2 ff ff       	call   80107490 <walkpgdir>
801081b0:	85 c0                	test   %eax,%eax
801081b2:	0f 84 7f 00 00 00    	je     80108237 <cowuvm+0x127>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801081b8:	8b 10                	mov    (%eax),%edx
801081ba:	f7 c2 01 02 00 00    	test   $0x201,%edx
801081c0:	74 68                	je     8010822a <cowuvm+0x11a>
    if(*pte & PTE_PG)  //there is pgfault, then not mark this entry as cow
801081c2:	f6 c6 02             	test   $0x2,%dh
801081c5:	74 81                	je     80108148 <cowuvm+0x38>
      cprintf("cowuvm,  not marked as cow because pgfault \n");
801081c7:	83 ec 0c             	sub    $0xc,%esp
801081ca:	68 34 9c 10 80       	push   $0x80109c34
801081cf:	e8 8c 84 ff ff       	call   80100660 <cprintf>
       pte = walkpgdir(d, (void*) i, 1);
801081d4:	89 da                	mov    %ebx,%edx
801081d6:	b9 01 00 00 00       	mov    $0x1,%ecx
801081db:	89 f8                	mov    %edi,%eax
801081dd:	e8 ae f2 ff ff       	call   80107490 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE)
801081e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
       continue;
801081e8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < sz; i += PGSIZE)
801081eb:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
801081ee:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE)
801081f4:	77 ae                	ja     801081a4 <cowuvm+0x94>
bad:
  cprintf("bad: cowuvm\n");
  freevm(d);
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
}
801081f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801081f9:	89 f8                	mov    %edi,%eax
801081fb:	5b                   	pop    %ebx
801081fc:	5e                   	pop    %esi
801081fd:	5f                   	pop    %edi
801081fe:	5d                   	pop    %ebp
801081ff:	c3                   	ret    
  cprintf("bad: cowuvm\n");
80108200:	83 ec 0c             	sub    $0xc,%esp
80108203:	68 e8 9a 10 80       	push   $0x80109ae8
80108208:	e8 53 84 ff ff       	call   80100660 <cprintf>
  freevm(d);
8010820d:	89 3c 24             	mov    %edi,(%esp)
80108210:	e8 9b fd ff ff       	call   80107fb0 <freevm>
80108215:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108218:	0f 22 d8             	mov    %eax,%cr3
  return 0;
8010821b:	83 c4 10             	add    $0x10,%esp
}
8010821e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108221:	31 ff                	xor    %edi,%edi
}
80108223:	89 f8                	mov    %edi,%eax
80108225:	5b                   	pop    %ebx
80108226:	5e                   	pop    %esi
80108227:	5f                   	pop    %edi
80108228:	5d                   	pop    %ebp
80108229:	c3                   	ret    
      panic("cowuvm: page not present and not page faulted!");
8010822a:	83 ec 0c             	sub    $0xc,%esp
8010822d:	68 04 9c 10 80       	push   $0x80109c04
80108232:	e8 59 81 ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
80108237:	83 ec 0c             	sub    $0xc,%esp
8010823a:	68 d9 9a 10 80       	push   $0x80109ad9
8010823f:	e8 4c 81 ff ff       	call   80100390 <panic>
80108244:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010824a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108250 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
80108250:	55                   	push   %ebp
80108251:	89 e5                	mov    %esp,%ebp
80108253:	53                   	push   %ebx
80108254:	83 ec 04             	sub    $0x4,%esp
80108257:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
8010825a:	e8 51 c0 ff ff       	call   801042b0 <myproc>
8010825f:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108265:	31 c0                	xor    %eax,%eax
80108267:	eb 12                	jmp    8010827b <getSwappedPageIndex+0x2b>
80108269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108270:	83 c0 01             	add    $0x1,%eax
80108273:	83 c2 1c             	add    $0x1c,%edx
80108276:	83 f8 10             	cmp    $0x10,%eax
80108279:	74 0d                	je     80108288 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
8010827b:	39 1a                	cmp    %ebx,(%edx)
8010827d:	75 f1                	jne    80108270 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
8010827f:	83 c4 04             	add    $0x4,%esp
80108282:	5b                   	pop    %ebx
80108283:	5d                   	pop    %ebp
80108284:	c3                   	ret    
80108285:	8d 76 00             	lea    0x0(%esi),%esi
80108288:	83 c4 04             	add    $0x4,%esp
  return -1;
8010828b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108290:	5b                   	pop    %ebx
80108291:	5d                   	pop    %ebp
80108292:	c3                   	ret    
80108293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801082a0 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
801082a0:	55                   	push   %ebp
801082a1:	89 e5                	mov    %esp,%ebp
801082a3:	57                   	push   %edi
801082a4:	56                   	push   %esi
801082a5:	53                   	push   %ebx
801082a6:	83 ec 1c             	sub    $0x1c,%esp
801082a9:	8b 45 08             	mov    0x8(%ebp),%eax
801082ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801082af:	8b 75 10             	mov    0x10(%ebp),%esi
  uint err = curproc->tf->err;
801082b2:	8b 50 18             	mov    0x18(%eax),%edx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
801082b5:	f6 42 34 02          	testb  $0x2,0x34(%edx)
801082b9:	74 07                	je     801082c2 <handle_cow_pagefault+0x22>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
801082bb:	8b 13                	mov    (%ebx),%edx
801082bd:	f6 c6 04             	test   $0x4,%dh
801082c0:	75 16                	jne    801082d8 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
801082c2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
801082c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801082cc:	5b                   	pop    %ebx
801082cd:	5e                   	pop    %esi
801082ce:	5f                   	pop    %edi
801082cf:	5d                   	pop    %ebp
801082d0:	c3                   	ret    
801082d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      pa = PTE_ADDR(*pte);
801082d8:	89 d7                	mov    %edx,%edi
      ref_count = getRefs(virt_addr);
801082da:	83 ec 0c             	sub    $0xc,%esp
      pa = PTE_ADDR(*pte);
801082dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801082e0:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
801082e6:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
801082ec:	57                   	push   %edi
801082ed:	e8 be ab ff ff       	call   80102eb0 <getRefs>
      if (ref_count > 1) // more than one reference
801082f2:	83 c4 10             	add    $0x10,%esp
801082f5:	83 f8 01             	cmp    $0x1,%eax
801082f8:	7f 16                	jg     80108310 <handle_cow_pagefault+0x70>
        *pte &= ~PTE_COW; // turn COW off
801082fa:	8b 03                	mov    (%ebx),%eax
801082fc:	80 e4 fb             	and    $0xfb,%ah
801082ff:	83 c8 02             	or     $0x2,%eax
80108302:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
80108304:	0f 01 3e             	invlpg (%esi)
80108307:	eb c0                	jmp    801082c9 <handle_cow_pagefault+0x29>
80108309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new_page = kalloc();
80108310:	e8 0b aa ff ff       	call   80102d20 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
80108315:	83 ec 04             	sub    $0x4,%esp
80108318:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010831b:	68 00 10 00 00       	push   $0x1000
80108320:	57                   	push   %edi
80108321:	50                   	push   %eax
80108322:	e8 69 d0 ff ff       	call   80105390 <memmove>
      flags = PTE_FLAGS(*pte);
80108327:	8b 55 e4             	mov    -0x1c(%ebp),%edx
        new_pa = V2P(new_page);
8010832a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      flags = PTE_FLAGS(*pte);
8010832d:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        new_pa = V2P(new_page);
80108333:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
80108339:	83 ca 03             	or     $0x3,%edx
8010833c:	09 ca                	or     %ecx,%edx
8010833e:	89 13                	mov    %edx,(%ebx)
80108340:	0f 01 3e             	invlpg (%esi)
        refDec(virt_addr); // decrement old page's ref count
80108343:	89 7d 08             	mov    %edi,0x8(%ebp)
80108346:	83 c4 10             	add    $0x10,%esp
}
80108349:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010834c:	5b                   	pop    %ebx
8010834d:	5e                   	pop    %esi
8010834e:	5f                   	pop    %edi
8010834f:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
80108350:	e9 7b aa ff ff       	jmp    80102dd0 <refDec>
80108355:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108360 <handle_pagedout>:

void
handle_pagedout(struct proc* curproc, char* start_page, pte_t* pte)
{
80108360:	55                   	push   %ebp
80108361:	89 e5                	mov    %esp,%ebp
80108363:	57                   	push   %edi
80108364:	56                   	push   %esi
80108365:	53                   	push   %ebx
80108366:	83 ec 20             	sub    $0x20,%esp
80108369:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010836c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010836f:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* new_page;
    void* ramPa;
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108372:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108375:	ff 73 10             	pushl  0x10(%ebx)
80108378:	50                   	push   %eax
80108379:	68 64 9c 10 80       	push   $0x80109c64
8010837e:	e8 dd 82 ff ff       	call   80100660 <cprintf>

    new_page = kalloc();
80108383:	e8 98 a9 ff ff       	call   80102d20 <kalloc>
    *pte |= PTE_P | PTE_W | PTE_U;
    *pte &= ~PTE_PG;
    *pte &= 0xFFF;
80108388:	8b 17                	mov    (%edi),%edx
    *pte |= V2P(new_page);
8010838a:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
8010838f:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
80108395:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
80108398:	09 d0                	or     %edx,%eax
8010839a:	89 07                	mov    %eax,(%edi)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010839c:	31 ff                	xor    %edi,%edi
  struct proc* curproc = myproc();
8010839e:	e8 0d bf ff ff       	call   801042b0 <myproc>
801083a3:	83 c4 10             	add    $0x10,%esp
801083a6:	05 90 00 00 00       	add    $0x90,%eax
801083ab:	eb 12                	jmp    801083bf <handle_pagedout+0x5f>
801083ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801083b0:	83 c7 01             	add    $0x1,%edi
801083b3:	83 c0 1c             	add    $0x1c,%eax
801083b6:	83 ff 10             	cmp    $0x10,%edi
801083b9:	0f 84 99 01 00 00    	je     80108558 <handle_pagedout+0x1f8>
    if(curproc->swappedPages[i].virt_addr == va)
801083bf:	3b 30                	cmp    (%eax),%esi
801083c1:	75 ed                	jne    801083b0 <handle_pagedout+0x50>
801083c3:	6b c7 1c             	imul   $0x1c,%edi,%eax
801083c6:	05 88 00 00 00       	add    $0x88,%eax
    
    int index = getSwappedPageIndex(start_page); // get swap page index
    struct page *swap_page = &curproc->swappedPages[index];
801083cb:	01 d8                	add    %ebx,%eax

    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801083cd:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
801083d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
801083d5:	6b c7 1c             	imul   $0x1c,%edi,%eax
801083d8:	01 d8                	add    %ebx,%eax
801083da:	ff b0 94 00 00 00    	pushl  0x94(%eax)
801083e0:	68 e0 c5 10 80       	push   $0x8010c5e0
801083e5:	53                   	push   %ebx
801083e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083e9:	e8 42 a2 ff ff       	call   80102630 <readFromSwapFile>
801083ee:	83 c4 10             	add    $0x10,%esp
801083f1:	85 c0                	test   %eax,%eax
801083f3:	0f 88 fe 01 00 00    	js     801085f7 <handle_pagedout+0x297>
      panic("allocuvm: readFromSwapFile");

    struct fblock *new_block = (struct fblock*)kalloc();
801083f9:	e8 22 a9 ff ff       	call   80102d20 <kalloc>
    new_block->off = swap_page->swap_offset;
801083fe:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80108401:	8b 91 94 00 00 00    	mov    0x94(%ecx),%edx
    new_block->next = 0;
80108407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
8010840e:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
80108410:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
80108416:	89 50 08             	mov    %edx,0x8(%eax)

    if(curproc->free_tail != 0)
80108419:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
8010841f:	85 d2                	test   %edx,%edx
80108421:	0f 84 b9 01 00 00    	je     801085e0 <handle_pagedout+0x280>
      curproc->free_tail->next = new_block;
80108427:	89 42 04             	mov    %eax,0x4(%edx)
    curproc->free_tail = new_block;

    // cprintf("free blocks list after readFromSwapFile:\n");
    // printlist();

    memmove((void*)start_page, buffer, PGSIZE);
8010842a:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
8010842d:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
80108433:	68 00 10 00 00       	push   $0x1000
80108438:	68 e0 c5 10 80       	push   $0x8010c5e0
8010843d:	56                   	push   %esi
8010843e:	e8 4d cf ff ff       	call   80105390 <memmove>

    // zero swap page entry
    memset((void*)swap_page, 0, sizeof(struct page));
80108443:	83 c4 0c             	add    $0xc,%esp
80108446:	6a 1c                	push   $0x1c
80108448:	6a 00                	push   $0x0
8010844a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010844d:	e8 8e ce ff ff       	call   801052e0 <memset>

    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
80108452:	83 c4 10             	add    $0x10,%esp
80108455:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
8010845c:	0f 8e 0e 01 00 00    	jle    80108570 <handle_pagedout+0x210>
    else // no sapce in proc RAM, will swap
    {
      int index_to_evicet = indexToEvict();
      // cprintf("[pagefault] index to evict: %d\n", index_to_evicet);
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
      int swap_offset = curproc->free_head->off;
80108462:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
80108468:	8b 02                	mov    (%edx),%eax
8010846a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

      if(curproc->free_head->next == 0)
8010846d:	8b 42 04             	mov    0x4(%edx),%eax
80108470:	85 c0                	test   %eax,%eax
80108472:	0f 84 b8 00 00 00    	je     80108530 <handle_pagedout+0x1d0>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80108478:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
8010847b:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108481:	ff 70 08             	pushl  0x8(%eax)
80108484:	e8 c7 a5 ff ff       	call   80102a50 <kfree>
80108489:	83 c4 10             	add    $0x10,%esp
      }

      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
8010848c:	68 00 10 00 00       	push   $0x1000
80108491:	ff 75 e4             	pushl  -0x1c(%ebp)
80108494:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
8010849a:	53                   	push   %ebx
8010849b:	e8 60 a1 ff ff       	call   80102600 <writeToSwapFile>
801084a0:	83 c4 10             	add    $0x10,%esp
801084a3:	85 c0                	test   %eax,%eax
801084a5:	0f 88 59 01 00 00    	js     80108604 <handle_pagedout+0x2a4>
        panic("allocuvm: writeToSwapFile");
      
      swap_page->virt_addr = ram_page->virt_addr;
801084ab:	6b cf 1c             	imul   $0x1c,%edi,%ecx
801084ae:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
801084b4:	01 d9                	add    %ebx,%ecx
801084b6:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
801084bc:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      swap_page->isused = 1;
801084c2:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
801084c9:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
801084cc:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
801084d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801084d5:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)

      // get pte of RAM page
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
801084db:	8b 43 04             	mov    0x4(%ebx),%eax
801084de:	31 c9                	xor    %ecx,%ecx
801084e0:	e8 ab ef ff ff       	call   80107490 <walkpgdir>
      if(!(*pte & PTE_P))
801084e5:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
801084e7:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
801084e9:	f6 c2 01             	test   $0x1,%dl
801084ec:	0f 84 1f 01 00 00    	je     80108611 <handle_pagedout+0x2b1>
        panic("pagefault: ram page is not present");
      ramPa = (void*)PTE_ADDR(*pte);
801084f2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx

      kfree(P2V(ramPa));
801084f8:	83 ec 0c             	sub    $0xc,%esp
801084fb:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108501:	52                   	push   %edx
80108502:	e8 49 a5 ff ff       	call   80102a50 <kfree>
      *pte &= 0xFFF;   // ???
      
      // prepare to-be-swapped page in RAM to move to swap file
      *pte |= PTE_PG;     // turn "paged-out" flag on
      *pte &= ~PTE_P;     // turn "present" flag off
80108507:	8b 07                	mov    (%edi),%eax
80108509:	25 fe 0f 00 00       	and    $0xffe,%eax
8010850e:	80 cc 02             	or     $0x2,%ah
80108511:	89 07                	mov    %eax,(%edi)

      ram_page->virt_addr = start_page;
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
      
      lcr3(V2P(curproc->pgdir));             // refresh TLB
80108513:	8b 43 04             	mov    0x4(%ebx),%eax
      ram_page->virt_addr = start_page;
80108516:	89 b3 a4 02 00 00    	mov    %esi,0x2a4(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
8010851c:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80108521:	0f 22 d8             	mov    %eax,%cr3
80108524:	83 c4 10             	add    $0x10,%esp
    }
    return;
}
80108527:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010852a:	5b                   	pop    %ebx
8010852b:	5e                   	pop    %esi
8010852c:	5f                   	pop    %edi
8010852d:	5d                   	pop    %ebp
8010852e:	c3                   	ret    
8010852f:	90                   	nop
        kfree((char*)curproc->free_head);
80108530:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80108533:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
8010853a:	00 00 00 
        kfree((char*)curproc->free_head);
8010853d:	52                   	push   %edx
8010853e:	e8 0d a5 ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80108543:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
8010854a:	00 00 00 
8010854d:	83 c4 10             	add    $0x10,%esp
80108550:	e9 37 ff ff ff       	jmp    8010848c <handle_pagedout+0x12c>
80108555:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108558:	b8 6c 00 00 00       	mov    $0x6c,%eax
  return -1;
8010855d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108562:	e9 64 fe ff ff       	jmp    801083cb <handle_pagedout+0x6b>
80108567:	89 f6                	mov    %esi,%esi
80108569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80108570:	e8 3b bd ff ff       	call   801042b0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108575:	31 ff                	xor    %edi,%edi
80108577:	05 4c 02 00 00       	add    $0x24c,%eax
8010857c:	eb 0d                	jmp    8010858b <handle_pagedout+0x22b>
8010857e:	66 90                	xchg   %ax,%ax
80108580:	83 c7 01             	add    $0x1,%edi
80108583:	83 c0 1c             	add    $0x1c,%eax
80108586:	83 ff 10             	cmp    $0x10,%edi
80108589:	74 65                	je     801085f0 <handle_pagedout+0x290>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
8010858b:	8b 10                	mov    (%eax),%edx
8010858d:	85 d2                	test   %edx,%edx
8010858f:	75 ef                	jne    80108580 <handle_pagedout+0x220>
      cprintf("filling ram slot: %d\n", new_indx);
80108591:	83 ec 08             	sub    $0x8,%esp
80108594:	57                   	push   %edi
80108595:	68 10 9b 10 80       	push   $0x80109b10
      curproc->ramPages[new_indx].virt_addr = start_page;
8010859a:	6b ff 1c             	imul   $0x1c,%edi,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010859d:	e8 be 80 ff ff       	call   80100660 <cprintf>
801085a2:	83 c4 10             	add    $0x10,%esp
      curproc->ramPages[new_indx].virt_addr = start_page;
801085a5:	01 df                	add    %ebx,%edi
801085a7:	89 b7 50 02 00 00    	mov    %esi,0x250(%edi)
      curproc->ramPages[new_indx].isused = 1;
801085ad:	c7 87 4c 02 00 00 01 	movl   $0x1,0x24c(%edi)
801085b4:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801085b7:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
801085ba:	c7 87 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edi)
801085c1:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
801085c4:	89 87 48 02 00 00    	mov    %eax,0x248(%edi)
      curproc->num_ram++;
801085ca:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
801085d1:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
801085d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085db:	5b                   	pop    %ebx
801085dc:	5e                   	pop    %esi
801085dd:	5f                   	pop    %edi
801085de:	5d                   	pop    %ebp
801085df:	c3                   	ret    
      curproc->free_head = new_block;
801085e0:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
801085e6:	e9 3f fe ff ff       	jmp    8010842a <handle_pagedout+0xca>
801085eb:	90                   	nop
801085ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return i;
  }
  return -1;
801085f0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801085f5:	eb 9a                	jmp    80108591 <handle_pagedout+0x231>
      panic("allocuvm: readFromSwapFile");
801085f7:	83 ec 0c             	sub    $0xc,%esp
801085fa:	68 f5 9a 10 80       	push   $0x80109af5
801085ff:	e8 8c 7d ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80108604:	83 ec 0c             	sub    $0xc,%esp
80108607:	68 54 9a 10 80       	push   $0x80109a54
8010860c:	e8 7f 7d ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
80108611:	83 ec 0c             	sub    $0xc,%esp
80108614:	68 94 9c 10 80       	push   $0x80109c94
80108619:	e8 72 7d ff ff       	call   80100390 <panic>
8010861e:	66 90                	xchg   %ax,%ax

80108620 <pagefault>:
{
80108620:	55                   	push   %ebp
80108621:	89 e5                	mov    %esp,%ebp
80108623:	57                   	push   %edi
80108624:	56                   	push   %esi
80108625:	53                   	push   %ebx
80108626:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108629:	e8 82 bc ff ff       	call   801042b0 <myproc>
8010862e:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108630:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
80108633:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010863a:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
8010863c:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
8010863f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
80108645:	31 c9                	xor    %ecx,%ecx
80108647:	89 fa                	mov    %edi,%edx
80108649:	e8 42 ee ff ff       	call   80107490 <walkpgdir>
  if((*pte & PTE_PG) && !(*pte & PTE_COW)) // paged out, not COW todo
8010864e:	8b 10                	mov    (%eax),%edx
80108650:	81 e2 00 06 00 00    	and    $0x600,%edx
80108656:	81 fa 00 02 00 00    	cmp    $0x200,%edx
8010865c:	74 62                	je     801086c0 <pagefault+0xa0>
    if(va >= KERNBASE || pte == 0)
8010865e:	85 f6                	test   %esi,%esi
80108660:	78 2e                	js     80108690 <pagefault+0x70>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108662:	8b 43 04             	mov    0x4(%ebx),%eax
80108665:	31 c9                	xor    %ecx,%ecx
80108667:	89 f2                	mov    %esi,%edx
80108669:	e8 22 ee ff ff       	call   80107490 <walkpgdir>
8010866e:	85 c0                	test   %eax,%eax
80108670:	74 64                	je     801086d6 <pagefault+0xb6>
    handle_cow_pagefault(curproc, pte, va);
80108672:	83 ec 04             	sub    $0x4,%esp
80108675:	56                   	push   %esi
80108676:	50                   	push   %eax
80108677:	53                   	push   %ebx
80108678:	e8 23 fc ff ff       	call   801082a0 <handle_cow_pagefault>
8010867d:	83 c4 10             	add    $0x10,%esp
}
80108680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108683:	5b                   	pop    %ebx
80108684:	5e                   	pop    %esi
80108685:	5f                   	pop    %edi
80108686:	5d                   	pop    %ebp
80108687:	c3                   	ret    
80108688:	90                   	nop
80108689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108690:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108693:	83 ec 04             	sub    $0x4,%esp
80108696:	50                   	push   %eax
80108697:	ff 73 10             	pushl  0x10(%ebx)
8010869a:	68 b8 9c 10 80       	push   $0x80109cb8
8010869f:	e8 bc 7f ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
801086a4:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
801086ab:	83 c4 10             	add    $0x10,%esp
}
801086ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086b1:	5b                   	pop    %ebx
801086b2:	5e                   	pop    %esi
801086b3:	5f                   	pop    %edi
801086b4:	5d                   	pop    %ebp
801086b5:	c3                   	ret    
801086b6:	8d 76 00             	lea    0x0(%esi),%esi
801086b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    handle_pagedout(curproc, start_page, pte);
801086c0:	83 ec 04             	sub    $0x4,%esp
801086c3:	50                   	push   %eax
801086c4:	57                   	push   %edi
801086c5:	53                   	push   %ebx
801086c6:	e8 95 fc ff ff       	call   80108360 <handle_pagedout>
801086cb:	83 c4 10             	add    $0x10,%esp
}
801086ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086d1:	5b                   	pop    %ebx
801086d2:	5e                   	pop    %esi
801086d3:	5f                   	pop    %edi
801086d4:	5d                   	pop    %ebp
801086d5:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
801086d6:	83 ec 0c             	sub    $0xc,%esp
801086d9:	68 26 9b 10 80       	push   $0x80109b26
801086de:	e8 ad 7c ff ff       	call   80100390 <panic>
801086e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801086e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801086f0 <update_selectionfiled_pagefault>:
801086f0:	55                   	push   %ebp
801086f1:	89 e5                	mov    %esp,%ebp
801086f3:	5d                   	pop    %ebp
801086f4:	c3                   	ret    
801086f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801086f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108700 <copyuvm>:
{
80108700:	55                   	push   %ebp
80108701:	89 e5                	mov    %esp,%ebp
80108703:	57                   	push   %edi
80108704:	56                   	push   %esi
80108705:	53                   	push   %ebx
80108706:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
80108709:	e8 22 f9 ff ff       	call   80108030 <setupkvm>
8010870e:	85 c0                	test   %eax,%eax
80108710:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108713:	0f 84 bf 00 00 00    	je     801087d8 <copyuvm+0xd8>
  for(i = 0; i < sz; i += PGSIZE){
80108719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010871c:	85 db                	test   %ebx,%ebx
8010871e:	0f 84 b4 00 00 00    	je     801087d8 <copyuvm+0xd8>
80108724:	31 f6                	xor    %esi,%esi
80108726:	eb 69                	jmp    80108791 <copyuvm+0x91>
80108728:	90                   	nop
80108729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
80108730:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80108732:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80108738:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010873e:	e8 dd a5 ff ff       	call   80102d20 <kalloc>
80108743:	85 c0                	test   %eax,%eax
80108745:	0f 84 ad 00 00 00    	je     801087f8 <copyuvm+0xf8>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010874b:	83 ec 04             	sub    $0x4,%esp
8010874e:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80108754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108757:	68 00 10 00 00       	push   $0x1000
8010875c:	57                   	push   %edi
8010875d:	50                   	push   %eax
8010875e:	e8 2d cc ff ff       	call   80105390 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108763:	5a                   	pop    %edx
80108764:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108767:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010876a:	59                   	pop    %ecx
8010876b:	53                   	push   %ebx
8010876c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108771:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80108777:	52                   	push   %edx
80108778:	89 f2                	mov    %esi,%edx
8010877a:	e8 91 ed ff ff       	call   80107510 <mappages>
8010877f:	83 c4 10             	add    $0x10,%esp
80108782:	85 c0                	test   %eax,%eax
80108784:	78 62                	js     801087e8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108786:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010878c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010878f:	76 47                	jbe    801087d8 <copyuvm+0xd8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108791:	8b 45 08             	mov    0x8(%ebp),%eax
80108794:	31 c9                	xor    %ecx,%ecx
80108796:	89 f2                	mov    %esi,%edx
80108798:	e8 f3 ec ff ff       	call   80107490 <walkpgdir>
8010879d:	85 c0                	test   %eax,%eax
8010879f:	0f 84 8b 00 00 00    	je     80108830 <copyuvm+0x130>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
801087a5:	8b 18                	mov    (%eax),%ebx
801087a7:	f7 c3 01 02 00 00    	test   $0x201,%ebx
801087ad:	74 74                	je     80108823 <copyuvm+0x123>
    if (*pte & PTE_PG) {
801087af:	f6 c7 02             	test   $0x2,%bh
801087b2:	0f 84 78 ff ff ff    	je     80108730 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
801087b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087bb:	89 f2                	mov    %esi,%edx
801087bd:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
801087c2:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
801087c8:	e8 c3 ec ff ff       	call   80107490 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
801087cd:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
801087d0:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
801087d6:	77 b9                	ja     80108791 <copyuvm+0x91>
}
801087d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801087db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801087de:	5b                   	pop    %ebx
801087df:	5e                   	pop    %esi
801087e0:	5f                   	pop    %edi
801087e1:	5d                   	pop    %ebp
801087e2:	c3                   	ret    
801087e3:	90                   	nop
801087e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("copyuvm: mappages failed\n");
801087e8:	83 ec 0c             	sub    $0xc,%esp
801087eb:	68 59 9b 10 80       	push   $0x80109b59
801087f0:	e8 6b 7e ff ff       	call   80100660 <cprintf>
      goto bad;
801087f5:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801087f8:	83 ec 0c             	sub    $0xc,%esp
801087fb:	68 73 9b 10 80       	push   $0x80109b73
80108800:	e8 5b 7e ff ff       	call   80100660 <cprintf>
  freevm(d);
80108805:	58                   	pop    %eax
80108806:	ff 75 e0             	pushl  -0x20(%ebp)
80108809:	e8 a2 f7 ff ff       	call   80107fb0 <freevm>
  return 0;
8010880e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108815:	83 c4 10             	add    $0x10,%esp
}
80108818:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010881b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010881e:	5b                   	pop    %ebx
8010881f:	5e                   	pop    %esi
80108820:	5f                   	pop    %edi
80108821:	5d                   	pop    %ebp
80108822:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
80108823:	83 ec 0c             	sub    $0xc,%esp
80108826:	68 ec 9c 10 80       	push   $0x80109cec
8010882b:	e8 60 7b ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80108830:	83 ec 0c             	sub    $0xc,%esp
80108833:	68 3f 9b 10 80       	push   $0x80109b3f
80108838:	e8 53 7b ff ff       	call   80100390 <panic>
8010883d:	8d 76 00             	lea    0x0(%esi),%esi

80108840 <uva2ka>:
{
80108840:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
80108841:	31 c9                	xor    %ecx,%ecx
{
80108843:	89 e5                	mov    %esp,%ebp
80108845:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80108848:	8b 55 0c             	mov    0xc(%ebp),%edx
8010884b:	8b 45 08             	mov    0x8(%ebp),%eax
8010884e:	e8 3d ec ff ff       	call   80107490 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108853:	8b 00                	mov    (%eax),%eax
}
80108855:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108856:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108858:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
8010885d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108860:	05 00 00 00 80       	add    $0x80000000,%eax
80108865:	83 fa 05             	cmp    $0x5,%edx
80108868:	ba 00 00 00 00       	mov    $0x0,%edx
8010886d:	0f 45 c2             	cmovne %edx,%eax
}
80108870:	c3                   	ret    
80108871:	eb 0d                	jmp    80108880 <copyout>
80108873:	90                   	nop
80108874:	90                   	nop
80108875:	90                   	nop
80108876:	90                   	nop
80108877:	90                   	nop
80108878:	90                   	nop
80108879:	90                   	nop
8010887a:	90                   	nop
8010887b:	90                   	nop
8010887c:	90                   	nop
8010887d:	90                   	nop
8010887e:	90                   	nop
8010887f:	90                   	nop

80108880 <copyout>:
{
80108880:	55                   	push   %ebp
80108881:	89 e5                	mov    %esp,%ebp
80108883:	57                   	push   %edi
80108884:	56                   	push   %esi
80108885:	53                   	push   %ebx
80108886:	83 ec 1c             	sub    $0x1c,%esp
80108889:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010888c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010888f:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80108892:	85 db                	test   %ebx,%ebx
80108894:	75 40                	jne    801088d6 <copyout+0x56>
80108896:	eb 70                	jmp    80108908 <copyout+0x88>
80108898:	90                   	nop
80108899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
801088a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801088a3:	89 f1                	mov    %esi,%ecx
801088a5:	29 d1                	sub    %edx,%ecx
801088a7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801088ad:	39 d9                	cmp    %ebx,%ecx
801088af:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
801088b2:	29 f2                	sub    %esi,%edx
801088b4:	83 ec 04             	sub    $0x4,%esp
801088b7:	01 d0                	add    %edx,%eax
801088b9:	51                   	push   %ecx
801088ba:	57                   	push   %edi
801088bb:	50                   	push   %eax
801088bc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801088bf:	e8 cc ca ff ff       	call   80105390 <memmove>
    buf += n;
801088c4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
801088c7:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
801088ca:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
801088d0:	01 cf                	add    %ecx,%edi
  while(len > 0){
801088d2:	29 cb                	sub    %ecx,%ebx
801088d4:	74 32                	je     80108908 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
801088d6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801088d8:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
801088db:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801088de:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
801088e4:	56                   	push   %esi
801088e5:	ff 75 08             	pushl  0x8(%ebp)
801088e8:	e8 53 ff ff ff       	call   80108840 <uva2ka>
    if(pa0 == 0)
801088ed:	83 c4 10             	add    $0x10,%esp
801088f0:	85 c0                	test   %eax,%eax
801088f2:	75 ac                	jne    801088a0 <copyout+0x20>
}
801088f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801088f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801088fc:	5b                   	pop    %ebx
801088fd:	5e                   	pop    %esi
801088fe:	5f                   	pop    %edi
801088ff:	5d                   	pop    %ebp
80108900:	c3                   	ret    
80108901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108908:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010890b:	31 c0                	xor    %eax,%eax
}
8010890d:	5b                   	pop    %ebx
8010890e:	5e                   	pop    %esi
8010890f:	5f                   	pop    %edi
80108910:	5d                   	pop    %ebp
80108911:	c3                   	ret    
80108912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108920 <getNextFreeRamIndex>:
{ 
80108920:	55                   	push   %ebp
80108921:	89 e5                	mov    %esp,%ebp
80108923:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80108926:	e8 85 b9 ff ff       	call   801042b0 <myproc>
8010892b:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108931:	31 c0                	xor    %eax,%eax
80108933:	eb 0e                	jmp    80108943 <getNextFreeRamIndex+0x23>
80108935:	8d 76 00             	lea    0x0(%esi),%esi
80108938:	83 c0 01             	add    $0x1,%eax
8010893b:	83 c2 1c             	add    $0x1c,%edx
8010893e:	83 f8 10             	cmp    $0x10,%eax
80108941:	74 0d                	je     80108950 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108943:	8b 0a                	mov    (%edx),%ecx
80108945:	85 c9                	test   %ecx,%ecx
80108947:	75 ef                	jne    80108938 <getNextFreeRamIndex+0x18>
}
80108949:	c9                   	leave  
8010894a:	c3                   	ret    
8010894b:	90                   	nop
8010894c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108955:	c9                   	leave  
80108956:	c3                   	ret    
80108957:	89 f6                	mov    %esi,%esi
80108959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108960 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108960:	55                   	push   %ebp
80108961:	89 e5                	mov    %esp,%ebp
80108963:	56                   	push   %esi
80108964:	53                   	push   %ebx
80108965:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108968:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
8010896e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108974:	eb 1d                	jmp    80108993 <updateLapa+0x33>
80108976:	8d 76 00             	lea    0x0(%esi),%esi
80108979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108980:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108986:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
80108989:	83 20 df             	andl   $0xffffffdf,(%eax)
8010898c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010898f:	39 f3                	cmp    %esi,%ebx
80108991:	74 2b                	je     801089be <updateLapa+0x5e>
    if(!cur_page->isused)
80108993:	8b 43 04             	mov    0x4(%ebx),%eax
80108996:	85 c0                	test   %eax,%eax
80108998:	74 f2                	je     8010898c <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
8010899a:	8b 53 08             	mov    0x8(%ebx),%edx
8010899d:	8b 03                	mov    (%ebx),%eax
8010899f:	31 c9                	xor    %ecx,%ecx
801089a1:	e8 ea ea ff ff       	call   80107490 <walkpgdir>
801089a6:	85 c0                	test   %eax,%eax
801089a8:	74 1b                	je     801089c5 <updateLapa+0x65>
801089aa:	8b 53 18             	mov    0x18(%ebx),%edx
801089ad:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
801089af:	f6 00 20             	testb  $0x20,(%eax)
801089b2:	75 cc                	jne    80108980 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
801089b4:	89 53 18             	mov    %edx,0x18(%ebx)
801089b7:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801089ba:	39 f3                	cmp    %esi,%ebx
801089bc:	75 d5                	jne    80108993 <updateLapa+0x33>
    }
  }
}
801089be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801089c1:	5b                   	pop    %ebx
801089c2:	5e                   	pop    %esi
801089c3:	5d                   	pop    %ebp
801089c4:	c3                   	ret    
      panic("updateLapa: no pte");
801089c5:	83 ec 0c             	sub    $0xc,%esp
801089c8:	68 81 9b 10 80       	push   $0x80109b81
801089cd:	e8 be 79 ff ff       	call   80100390 <panic>
801089d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801089d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801089e0 <updateNfua>:

void updateNfua(struct proc* p)
{
801089e0:	55                   	push   %ebp
801089e1:	89 e5                	mov    %esp,%ebp
801089e3:	56                   	push   %esi
801089e4:	53                   	push   %ebx
801089e5:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
801089e8:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
801089ee:	81 c6 08 04 00 00    	add    $0x408,%esi
801089f4:	eb 1d                	jmp    80108a13 <updateNfua+0x33>
801089f6:	8d 76 00             	lea    0x0(%esi),%esi
801089f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108a00:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108a06:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108a09:	83 20 df             	andl   $0xffffffdf,(%eax)
80108a0c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a0f:	39 f3                	cmp    %esi,%ebx
80108a11:	74 2b                	je     80108a3e <updateNfua+0x5e>
    if(!cur_page->isused)
80108a13:	8b 43 04             	mov    0x4(%ebx),%eax
80108a16:	85 c0                	test   %eax,%eax
80108a18:	74 f2                	je     80108a0c <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108a1a:	8b 53 08             	mov    0x8(%ebx),%edx
80108a1d:	8b 03                	mov    (%ebx),%eax
80108a1f:	31 c9                	xor    %ecx,%ecx
80108a21:	e8 6a ea ff ff       	call   80107490 <walkpgdir>
80108a26:	85 c0                	test   %eax,%eax
80108a28:	74 1b                	je     80108a45 <updateNfua+0x65>
80108a2a:	8b 53 14             	mov    0x14(%ebx),%edx
80108a2d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
80108a2f:	f6 00 20             	testb  $0x20,(%eax)
80108a32:	75 cc                	jne    80108a00 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108a34:	89 53 14             	mov    %edx,0x14(%ebx)
80108a37:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108a3a:	39 f3                	cmp    %esi,%ebx
80108a3c:	75 d5                	jne    80108a13 <updateNfua+0x33>
    }
  }
}
80108a3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108a41:	5b                   	pop    %ebx
80108a42:	5e                   	pop    %esi
80108a43:	5d                   	pop    %ebp
80108a44:	c3                   	ret    
      panic("updateNfua: no pte");
80108a45:	83 ec 0c             	sub    $0xc,%esp
80108a48:	68 94 9b 10 80       	push   $0x80109b94
80108a4d:	e8 3e 79 ff ff       	call   80100390 <panic>
80108a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108a60 <indexToEvict>:
uint indexToEvict()
{  
80108a60:	55                   	push   %ebp
  #if SELECTION==AQ
    return aq();
  #else
  return 11; // default
  #endif
}
80108a61:	b8 03 00 00 00       	mov    $0x3,%eax
{  
80108a66:	89 e5                	mov    %esp,%ebp
}
80108a68:	5d                   	pop    %ebp
80108a69:	c3                   	ret    
80108a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108a70 <aq>:

uint aq()
{
80108a70:	55                   	push   %ebp
80108a71:	89 e5                	mov    %esp,%ebp
80108a73:	57                   	push   %edi
80108a74:	56                   	push   %esi
80108a75:	53                   	push   %ebx
80108a76:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108a79:	e8 32 b8 ff ff       	call   801042b0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108a7e:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
80108a84:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108a8a:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
80108a8c:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108a8f:	74 45                	je     80108ad6 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108a91:	39 d1                	cmp    %edx,%ecx
80108a93:	89 c3                	mov    %eax,%ebx
80108a95:	74 31                	je     80108ac8 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108a97:	8b 41 04             	mov    0x4(%ecx),%eax
80108a9a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108aa0:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
80108aa6:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
80108aa9:	83 ec 0c             	sub    $0xc,%esp
80108aac:	52                   	push   %edx
80108aad:	e8 9e 9f ff ff       	call   80102a50 <kfree>
  curproc->queue_tail = new_tail;
80108ab2:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
80108ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108abb:	89 f0                	mov    %esi,%eax
80108abd:	5b                   	pop    %ebx
80108abe:	5e                   	pop    %esi
80108abf:	5f                   	pop    %edi
80108ac0:	5d                   	pop    %ebp
80108ac1:	c3                   	ret    
80108ac2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108ac8:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
80108acf:	00 00 00 
    new_tail = 0;
80108ad2:	31 ff                	xor    %edi,%edi
80108ad4:	eb d3                	jmp    80108aa9 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108ad6:	83 ec 0c             	sub    $0xc,%esp
80108ad9:	68 28 9d 10 80       	push   $0x80109d28
80108ade:	e8 ad 78 ff ff       	call   80100390 <panic>
80108ae3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108af0 <lapa>:
uint lapa()
{
80108af0:	55                   	push   %ebp
80108af1:	89 e5                	mov    %esp,%ebp
80108af3:	57                   	push   %edi
80108af4:	56                   	push   %esi
80108af5:	53                   	push   %ebx
80108af6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108af9:	e8 b2 b7 ff ff       	call   801042b0 <myproc>
  struct page *ramPages = curproc->ramPages;
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
80108afe:	8b 90 60 02 00 00    	mov    0x260(%eax),%edx
  struct page *ramPages = curproc->ramPages;
80108b04:	8d b8 48 02 00 00    	lea    0x248(%eax),%edi
80108b0a:	89 7d dc             	mov    %edi,-0x24(%ebp)
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
80108b0d:	85 d2                	test   %edx,%edx
80108b0f:	0f 84 ff 00 00 00    	je     80108c14 <lapa+0x124>
    uint count = 0;
80108b15:	31 c9                	xor    %ecx,%ecx
80108b17:	89 f6                	mov    %esi,%esi
80108b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        count += n & 1;
80108b20:	89 d3                	mov    %edx,%ebx
80108b22:	83 e3 01             	and    $0x1,%ebx
80108b25:	01 d9                	add    %ebx,%ecx
    while (n) {
80108b27:	d1 ea                	shr    %edx
80108b29:	75 f5                	jne    80108b20 <lapa+0x30>
80108b2b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108b2e:	05 7c 02 00 00       	add    $0x27c,%eax
  uint instances = 0;
80108b33:	31 ff                	xor    %edi,%edi
  uint minloc = 0;
80108b35:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108b3c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint count = 0;
80108b3f:	89 c6                	mov    %eax,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108b41:	bb 01 00 00 00       	mov    $0x1,%ebx
80108b46:	8d 76 00             	lea    0x0(%esi),%esi
80108b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108b50:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108b52:	31 d2                	xor    %edx,%edx
    while (n) {
80108b54:	85 c0                	test   %eax,%eax
80108b56:	74 13                	je     80108b6b <lapa+0x7b>
80108b58:	90                   	nop
80108b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108b60:	89 c1                	mov    %eax,%ecx
80108b62:	83 e1 01             	and    $0x1,%ecx
80108b65:	01 ca                	add    %ecx,%edx
    while (n) {
80108b67:	d1 e8                	shr    %eax
80108b69:	75 f5                	jne    80108b60 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
80108b6b:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
80108b6e:	0f 82 84 00 00 00    	jb     80108bf8 <lapa+0x108>
      instances++;
80108b74:	0f 94 c0             	sete   %al
80108b77:	0f b6 c0             	movzbl %al,%eax
80108b7a:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108b7c:	83 c3 01             	add    $0x1,%ebx
80108b7f:	83 c6 1c             	add    $0x1c,%esi
80108b82:	83 fb 10             	cmp    $0x10,%ebx
80108b85:	75 c9                	jne    80108b50 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108b87:	83 ff 01             	cmp    $0x1,%edi
80108b8a:	76 5b                	jbe    80108be7 <lapa+0xf7>
      uint minvalue = ramPages[minloc].lapa_counter;
80108b8c:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
80108b90:	8b 7d dc             	mov    -0x24(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108b93:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108b98:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108b9c:	89 7d dc             	mov    %edi,-0x24(%ebp)
80108b9f:	8b 7d d8             	mov    -0x28(%ebp),%edi
80108ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108ba8:	8b 1f                	mov    (%edi),%ebx
    while (n) {
80108baa:	85 db                	test   %ebx,%ebx
80108bac:	74 62                	je     80108c10 <lapa+0x120>
80108bae:	89 d8                	mov    %ebx,%eax
    uint count = 0;
80108bb0:	31 d2                	xor    %edx,%edx
80108bb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
80108bb8:	89 c1                	mov    %eax,%ecx
80108bba:	83 e1 01             	and    $0x1,%ecx
80108bbd:	01 ca                	add    %ecx,%edx
    while (n) {
80108bbf:	d1 e8                	shr    %eax
80108bc1:	75 f5                	jne    80108bb8 <lapa+0xc8>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
80108bc3:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108bc6:	75 14                	jne    80108bdc <lapa+0xec>
80108bc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108bcb:	39 c3                	cmp    %eax,%ebx
80108bcd:	0f 43 d8             	cmovae %eax,%ebx
80108bd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bd3:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80108bd6:	0f 42 c6             	cmovb  %esi,%eax
80108bd9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108bdc:	83 c6 01             	add    $0x1,%esi
80108bdf:	83 c7 1c             	add    $0x1c,%edi
80108be2:	83 fe 10             	cmp    $0x10,%esi
80108be5:	75 c1                	jne    80108ba8 <lapa+0xb8>
}
80108be7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bea:	83 c4 1c             	add    $0x1c,%esp
80108bed:	5b                   	pop    %ebx
80108bee:	5e                   	pop    %esi
80108bef:	5f                   	pop    %edi
80108bf0:	5d                   	pop    %ebp
80108bf1:	c3                   	ret    
80108bf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      minloc = i;
80108bf8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80108bfb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      instances = 1;
80108bfe:	bf 01 00 00 00       	mov    $0x1,%edi
80108c03:	e9 74 ff ff ff       	jmp    80108b7c <lapa+0x8c>
80108c08:	90                   	nop
80108c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint count = 0;
80108c10:	31 d2                	xor    %edx,%edx
80108c12:	eb af                	jmp    80108bc3 <lapa+0xd3>
80108c14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108c1b:	e9 0e ff ff ff       	jmp    80108b2e <lapa+0x3e>

80108c20 <nfua>:
{
80108c20:	55                   	push   %ebp
80108c21:	89 e5                	mov    %esp,%ebp
80108c23:	56                   	push   %esi
80108c24:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108c25:	e8 86 b6 ff ff       	call   801042b0 <myproc>
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c2a:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
80108c2f:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108c35:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
80108c3b:	31 c0                	xor    %eax,%eax
80108c3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ramPages[i].nfua_counter < minval)
80108c40:	8b 19                	mov    (%ecx),%ebx
80108c42:	39 f3                	cmp    %esi,%ebx
80108c44:	73 04                	jae    80108c4a <nfua+0x2a>
      minloc = i;
80108c46:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108c48:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108c4a:	83 c2 01             	add    $0x1,%edx
80108c4d:	83 c1 1c             	add    $0x1c,%ecx
80108c50:	83 fa 10             	cmp    $0x10,%edx
80108c53:	75 eb                	jne    80108c40 <nfua+0x20>
}
80108c55:	5b                   	pop    %ebx
80108c56:	5e                   	pop    %esi
80108c57:	5d                   	pop    %ebp
80108c58:	c3                   	ret    
80108c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108c60 <scfifo>:
{
80108c60:	55                   	push   %ebp
80108c61:	89 e5                	mov    %esp,%ebp
80108c63:	57                   	push   %edi
80108c64:	56                   	push   %esi
80108c65:	53                   	push   %ebx
80108c66:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108c69:	e8 42 b6 ff ff       	call   801042b0 <myproc>
80108c6e:	89 c7                	mov    %eax,%edi
80108c70:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108c76:	83 f8 0f             	cmp    $0xf,%eax
80108c79:	89 c3                	mov    %eax,%ebx
80108c7b:	7f 5f                	jg     80108cdc <scfifo+0x7c>
80108c7d:	6b c0 1c             	imul   $0x1c,%eax,%eax
80108c80:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108c87:	eb 17                	jmp    80108ca0 <scfifo+0x40>
80108c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c90:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108c93:	83 e2 df             	and    $0xffffffdf,%edx
80108c96:	83 c6 1c             	add    $0x1c,%esi
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108c99:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
80108c9c:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108c9e:	74 30                	je     80108cd0 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108ca0:	8b 56 08             	mov    0x8(%esi),%edx
80108ca3:	8b 06                	mov    (%esi),%eax
80108ca5:	31 c9                	xor    %ecx,%ecx
80108ca7:	e8 e4 e7 ff ff       	call   80107490 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108cac:	8b 10                	mov    (%eax),%edx
80108cae:	f6 c2 20             	test   $0x20,%dl
80108cb1:	75 dd                	jne    80108c90 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108cb3:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108cba:	74 74                	je     80108d30 <scfifo+0xd0>
            curproc->clockHand = i + 1;
80108cbc:	8d 43 01             	lea    0x1(%ebx),%eax
80108cbf:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
80108cc5:	83 c4 0c             	add    $0xc,%esp
80108cc8:	89 d8                	mov    %ebx,%eax
80108cca:	5b                   	pop    %ebx
80108ccb:	5e                   	pop    %esi
80108ccc:	5f                   	pop    %edi
80108ccd:	5d                   	pop    %ebp
80108cce:	c3                   	ret    
80108ccf:	90                   	nop
80108cd0:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108cd6:	31 db                	xor    %ebx,%ebx
    for(j=0; j< curproc->clockHand ;j++)
80108cd8:	85 c0                	test   %eax,%eax
80108cda:	74 a1                	je     80108c7d <scfifo+0x1d>
80108cdc:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108ce2:	31 c9                	xor    %ecx,%ecx
80108ce4:	eb 20                	jmp    80108d06 <scfifo+0xa6>
80108ce6:	8d 76 00             	lea    0x0(%esi),%esi
80108ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          *pte &= ~PTE_A;  
80108cf0:	83 e2 df             	and    $0xffffffdf,%edx
80108cf3:	83 c6 1c             	add    $0x1c,%esi
80108cf6:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108cf8:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108cfe:	39 c8                	cmp    %ecx,%eax
80108d00:	0f 86 70 ff ff ff    	jbe    80108c76 <scfifo+0x16>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108d06:	8b 56 08             	mov    0x8(%esi),%edx
80108d09:	8b 06                	mov    (%esi),%eax
80108d0b:	89 cb                	mov    %ecx,%ebx
80108d0d:	31 c9                	xor    %ecx,%ecx
80108d0f:	e8 7c e7 ff ff       	call   80107490 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108d14:	8b 10                	mov    (%eax),%edx
80108d16:	8d 4b 01             	lea    0x1(%ebx),%ecx
80108d19:	f6 c2 20             	test   $0x20,%dl
80108d1c:	75 d2                	jne    80108cf0 <scfifo+0x90>
          curproc->clockHand = j + 1;
80108d1e:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108d24:	83 c4 0c             	add    $0xc,%esp
80108d27:	89 d8                	mov    %ebx,%eax
80108d29:	5b                   	pop    %ebx
80108d2a:	5e                   	pop    %esi
80108d2b:	5f                   	pop    %edi
80108d2c:	5d                   	pop    %ebp
80108d2d:	c3                   	ret    
80108d2e:	66 90                	xchg   %ax,%ax
            curproc->clockHand = 0;
80108d30:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
80108d37:	00 00 00 
}
80108d3a:	83 c4 0c             	add    $0xc,%esp
80108d3d:	89 d8                	mov    %ebx,%eax
80108d3f:	5b                   	pop    %ebx
80108d40:	5e                   	pop    %esi
80108d41:	5f                   	pop    %edi
80108d42:	5d                   	pop    %ebp
80108d43:	c3                   	ret    
80108d44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108d4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

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
  struct queue_node *prev_node = curr_node->prev;
80108d78:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108d7b:	e8 30 b5 ff ff       	call   801042b0 <myproc>
80108d80:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108d86:	74 30                	je     80108db8 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108d88:	e8 23 b5 ff ff       	call   801042b0 <myproc>
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
80108db8:	e8 f3 b4 ff ff       	call   801042b0 <myproc>
80108dbd:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108dc3:	e8 e8 b4 ff ff       	call   801042b0 <myproc>
80108dc8:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108dce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108dd4:	e8 d7 b4 ff ff       	call   801042b0 <myproc>
80108dd9:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108ddf:	75 b4                	jne    80108d95 <swapAQ+0x25>
80108de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108de8:	e8 c3 b4 ff ff       	call   801042b0 <myproc>
80108ded:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108df3:	e8 b8 b4 ff ff       	call   801042b0 <myproc>
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
80108e57:	e8 34 e6 ff ff       	call   80107490 <walkpgdir>
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
80108e76:	e8 15 e6 ff ff       	call   80107490 <walkpgdir>
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
80108ec3:	68 a7 9b 10 80       	push   $0x80109ba7
80108ec8:	e8 c3 74 ff ff       	call   80100390 <panic>
