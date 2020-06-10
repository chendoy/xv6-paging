
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
8010004c:	68 80 90 10 80       	push   $0x80109080
80100051:	68 e0 e5 10 80       	push   $0x8010e5e0
80100056:	e8 b5 50 00 00       	call   80105110 <initlock>
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
80100092:	68 87 90 10 80       	push   $0x80109087
80100097:	50                   	push   %eax
80100098:	e8 43 4f 00 00       	call   80104fe0 <initsleeplock>
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
801000e4:	e8 67 51 00 00       	call   80105250 <acquire>
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
80100162:	e8 a9 51 00 00       	call   80105310 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ae 4e 00 00       	call   80105020 <acquiresleep>
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
80100193:	68 8e 90 10 80       	push   $0x8010908e
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
801001ae:	e8 0d 4f 00 00       	call   801050c0 <holdingsleep>
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
801001cc:	68 9f 90 10 80       	push   $0x8010909f
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
801001ef:	e8 cc 4e 00 00       	call   801050c0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 7c 4e 00 00       	call   80105080 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 e0 e5 10 80 	movl   $0x8010e5e0,(%esp)
8010020b:	e8 40 50 00 00       	call   80105250 <acquire>
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
8010025c:	e9 af 50 00 00       	jmp    80105310 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 90 10 80       	push   $0x801090a6
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
8010028c:	e8 bf 4f 00 00       	call   80105250 <acquire>
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
801002c5:	e8 36 48 00 00       	call   80104b00 <sleep>
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
801002ef:	e8 1c 50 00 00       	call   80105310 <release>
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
8010034d:	e8 be 4f 00 00       	call   80105310 <release>
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
801003b2:	68 ad 90 10 80       	push   $0x801090ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 40 9c 10 80 	movl   $0x80109c40,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 53 4d 00 00       	call   80105130 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 90 10 80       	push   $0x801090c1
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
8010043a:	e8 11 66 00 00       	call   80106a50 <uartputc>
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
801004ec:	e8 5f 65 00 00       	call   80106a50 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 53 65 00 00       	call   80106a50 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 47 65 00 00       	call   80106a50 <uartputc>
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
80100524:	e8 e7 4e 00 00       	call   80105410 <memmove>
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
80100541:	e8 1a 4e 00 00       	call   80105360 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 90 10 80       	push   $0x801090c5
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
801005b1:	0f b6 92 f0 90 10 80 	movzbl -0x7fef6f10(%edx),%edx
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
8010061b:	e8 30 4c 00 00       	call   80105250 <acquire>
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
80100647:	e8 c4 4c 00 00       	call   80105310 <release>
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
8010071f:	e8 ec 4b 00 00       	call   80105310 <release>
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
801007d0:	ba d8 90 10 80       	mov    $0x801090d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 c5 10 80       	push   $0x8010c520
801007f0:	e8 5b 4a 00 00       	call   80105250 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 90 10 80       	push   $0x801090df
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
80100823:	e8 28 4a 00 00       	call   80105250 <acquire>
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
80100888:	e8 83 4a 00 00       	call   80105310 <release>
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
80100916:	e8 25 44 00 00       	call   80104d40 <wakeup>
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
80100997:	e9 34 45 00 00       	jmp    80104ed0 <procdump>
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
801009c6:	68 e8 90 10 80       	push   $0x801090e8
801009cb:	68 20 c5 10 80       	push   $0x8010c520
801009d0:	e8 3b 47 00 00       	call   80105110 <initlock>

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
80100a2b:	e8 e0 49 00 00       	call   80105410 <memmove>
  memmove((void*)swappedPagesBackup, curproc->swappedPages, 16 * sizeof(struct page));
80100a30:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100a36:	83 c4 0c             	add    $0xc,%esp
80100a39:	68 c0 01 00 00       	push   $0x1c0
80100a3e:	50                   	push   %eax
80100a3f:	68 c0 31 11 80       	push   $0x801131c0
80100a44:	e8 c7 49 00 00       	call   80105410 <memmove>
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
80100ac8:	e8 93 48 00 00       	call   80105360 <memset>
  memset((void*)curproc->ramPages, 0, 16 * sizeof(struct page));
80100acd:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80100ad3:	83 c4 0c             	add    $0xc,%esp
80100ad6:	68 c0 01 00 00       	push   $0x1c0
80100adb:	6a 00                	push   $0x0
80100add:	50                   	push   %eax
80100ade:	e8 7d 48 00 00       	call   80105360 <memset>
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
80100bb7:	68 01 91 10 80       	push   $0x80109101
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
80100c37:	68 01 91 10 80       	push   $0x80109101
80100c3c:	e8 1f fa ff ff       	call   80100660 <cprintf>
80100c41:	8b 83 24 04 00 00    	mov    0x424(%ebx),%eax
80100c47:	83 c4 10             	add    $0x10,%esp
80100c4a:	eb ba                	jmp    80100c06 <allocate_fresh+0x36>
    panic("exec: create swapfile for exec proc failed");
80100c4c:	83 ec 0c             	sub    $0xc,%esp
80100c4f:	68 30 91 10 80       	push   $0x80109130
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
80100ccf:	68 22 91 10 80       	push   $0x80109122
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
80100d44:	e8 c7 46 00 00       	call   80105410 <memmove>
    memmove((void*)curproc->swappedPages, swappedPagesBackup, 16 * sizeof(struct page));
80100d49:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80100d4f:	83 c4 0c             	add    $0xc,%esp
80100d52:	68 c0 01 00 00       	push   $0x1c0
80100d57:	68 c0 31 11 80       	push   $0x801131c0
80100d5c:	50                   	push   %eax
80100d5d:	e8 ae 46 00 00       	call   80105410 <memmove>
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
80100dc0:	e8 2b 73 00 00       	call   801080f0 <setupkvm>
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
80100e2e:	e8 ad 70 00 00       	call   80107ee0 <allocuvm>
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
80100e60:	e8 7b 6b 00 00       	call   801079e0 <loaduvm>
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
80100eaa:	68 22 91 10 80       	push   $0x80109122
80100eaf:	e8 ac f7 ff ff       	call   80100660 <cprintf>
    freevm(pgdir);
80100eb4:	58                   	pop    %eax
80100eb5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ebb:	e8 b0 71 00 00       	call   80108070 <freevm>
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
80100f10:	e8 cb 6f 00 00       	call   80107ee0 <allocuvm>
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
80100f3e:	e8 5d 72 00 00       	call   801081a0 <clearpteu>
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
80100f8b:	e8 f0 45 00 00       	call   80105580 <strlen>
80100f90:	f7 d0                	not    %eax
80100f92:	01 c6                	add    %eax,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f94:	58                   	pop    %eax
80100f95:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100f98:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f9b:	ff 34 98             	pushl  (%eax,%ebx,4)
80100f9e:	e8 dd 45 00 00       	call   80105580 <strlen>
80100fa3:	83 c0 01             	add    $0x1,%eax
80100fa6:	50                   	push   %eax
80100fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
80100faa:	ff 34 98             	pushl  (%eax,%ebx,4)
80100fad:	56                   	push   %esi
80100fae:	57                   	push   %edi
80100faf:	e8 7c 7a 00 00       	call   80108a30 <copyout>
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
80100fd5:	68 16 91 10 80       	push   $0x80109116
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
80101029:	e8 02 7a 00 00       	call   80108a30 <copyout>
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
80101061:	e8 da 44 00 00       	call   80105540 <safestrcpy>
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
801010d2:	e8 79 67 00 00       	call   80107850 <switchuvm>
  freevm(oldpgdir);
801010d7:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
801010dd:	89 04 24             	mov    %eax,(%esp)
801010e0:	e8 8b 6f 00 00       	call   80108070 <freevm>
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
80101116:	68 5b 91 10 80       	push   $0x8010915b
8010111b:	68 a0 33 11 80       	push   $0x801133a0
80101120:	e8 eb 3f 00 00       	call   80105110 <initlock>
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
80101141:	e8 0a 41 00 00       	call   80105250 <acquire>
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
80101171:	e8 9a 41 00 00       	call   80105310 <release>
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
8010118a:	e8 81 41 00 00       	call   80105310 <release>
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
801011af:	e8 9c 40 00 00       	call   80105250 <acquire>
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
801011cc:	e8 3f 41 00 00       	call   80105310 <release>
  return f;
}
801011d1:	89 d8                	mov    %ebx,%eax
801011d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801011d6:	c9                   	leave  
801011d7:	c3                   	ret    
    panic("filedup");
801011d8:	83 ec 0c             	sub    $0xc,%esp
801011db:	68 62 91 10 80       	push   $0x80109162
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
80101201:	e8 4a 40 00 00       	call   80105250 <acquire>
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
8010122c:	e9 df 40 00 00       	jmp    80105310 <release>
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
80101258:	e8 b3 40 00 00       	call   80105310 <release>
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
801012b2:	68 6a 91 10 80       	push   $0x8010916a
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
80101392:	68 74 91 10 80       	push   $0x80109174
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
801014a5:	68 7d 91 10 80       	push   $0x8010917d
801014aa:	e8 e1 ee ff ff       	call   80100390 <panic>
  panic("filewrite");
801014af:	83 ec 0c             	sub    $0xc,%esp
801014b2:	68 83 91 10 80       	push   $0x80109183
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
80101523:	68 8d 91 10 80       	push   $0x8010918d
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
801015d4:	68 a0 91 10 80       	push   $0x801091a0
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
80101615:	e8 46 3d 00 00       	call   80105360 <memset>
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
8010165a:	e8 f1 3b 00 00       	call   80105250 <acquire>
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
801016bf:	e8 4c 3c 00 00       	call   80105310 <release>

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
801016ed:	e8 1e 3c 00 00       	call   80105310 <release>
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
80101702:	68 b6 91 10 80       	push   $0x801091b6
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
801017d7:	68 c6 91 10 80       	push   $0x801091c6
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
80101811:	e8 fa 3b 00 00       	call   80105410 <memmove>
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
8010183c:	68 d9 91 10 80       	push   $0x801091d9
80101841:	68 c0 3d 11 80       	push   $0x80113dc0
80101846:	e8 c5 38 00 00       	call   80105110 <initlock>
8010184b:	83 c4 10             	add    $0x10,%esp
8010184e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	68 e0 91 10 80       	push   $0x801091e0
80101858:	53                   	push   %ebx
80101859:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010185f:	e8 7c 37 00 00       	call   80104fe0 <initsleeplock>
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
801018a9:	68 8c 92 10 80       	push   $0x8010928c
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
8010193e:	e8 1d 3a 00 00       	call   80105360 <memset>
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
80101973:	68 e6 91 10 80       	push   $0x801091e6
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
801019e1:	e8 2a 3a 00 00       	call   80105410 <memmove>
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
80101a0f:	e8 3c 38 00 00       	call   80105250 <acquire>
  ip->ref++;
80101a14:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101a18:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101a1f:	e8 ec 38 00 00       	call   80105310 <release>
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
80101a52:	e8 c9 35 00 00       	call   80105020 <acquiresleep>
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
80101ac8:	e8 43 39 00 00       	call   80105410 <memmove>
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
80101aed:	68 fe 91 10 80       	push   $0x801091fe
80101af2:	e8 99 e8 ff ff       	call   80100390 <panic>
    panic("ilock");
80101af7:	83 ec 0c             	sub    $0xc,%esp
80101afa:	68 f8 91 10 80       	push   $0x801091f8
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
80101b23:	e8 98 35 00 00       	call   801050c0 <holdingsleep>
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
80101b3f:	e9 3c 35 00 00       	jmp    80105080 <releasesleep>
    panic("iunlock");
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 0d 92 10 80       	push   $0x8010920d
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
80101b70:	e8 ab 34 00 00       	call   80105020 <acquiresleep>
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
80101b8a:	e8 f1 34 00 00       	call   80105080 <releasesleep>
  acquire(&icache.lock);
80101b8f:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101b96:	e8 b5 36 00 00       	call   80105250 <acquire>
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
80101bb0:	e9 5b 37 00 00       	jmp    80105310 <release>
80101bb5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101bb8:	83 ec 0c             	sub    $0xc,%esp
80101bbb:	68 c0 3d 11 80       	push   $0x80113dc0
80101bc0:	e8 8b 36 00 00       	call   80105250 <acquire>
    int r = ip->ref;
80101bc5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101bc8:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80101bcf:	e8 3c 37 00 00       	call   80105310 <release>
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
80101db7:	e8 54 36 00 00       	call   80105410 <memmove>
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
80101eb3:	e8 58 35 00 00       	call   80105410 <memmove>
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
80101f4e:	e8 2d 35 00 00       	call   80105480 <strncmp>
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
80101fad:	e8 ce 34 00 00       	call   80105480 <strncmp>
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
80101ff2:	68 27 92 10 80       	push   $0x80109227
80101ff7:	e8 94 e3 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101ffc:	83 ec 0c             	sub    $0xc,%esp
80101fff:	68 15 92 10 80       	push   $0x80109215
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
80102039:	e8 12 32 00 00       	call   80105250 <acquire>
  ip->ref++;
8010203e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80102042:	c7 04 24 c0 3d 11 80 	movl   $0x80113dc0,(%esp)
80102049:	e8 c2 32 00 00       	call   80105310 <release>
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
801020a5:	e8 66 33 00 00       	call   80105410 <memmove>
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
80102138:	e8 d3 32 00 00       	call   80105410 <memmove>
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
8010222d:	e8 ae 32 00 00       	call   801054e0 <strncpy>
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
8010226b:	68 36 92 10 80       	push   $0x80109236
80102270:	e8 1b e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102275:	83 ec 0c             	sub    $0xc,%esp
80102278:	68 95 99 10 80       	push   $0x80109995
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
80102371:	68 43 92 10 80       	push   $0x80109243
80102376:	56                   	push   %esi
80102377:	e8 94 30 00 00       	call   80105410 <memmove>
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
801023d2:	68 4b 92 10 80       	push   $0x8010924b
801023d7:	53                   	push   %ebx
801023d8:	e8 a3 30 00 00       	call   80105480 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801023dd:	83 c4 10             	add    $0x10,%esp
801023e0:	85 c0                	test   %eax,%eax
801023e2:	0f 84 f8 00 00 00    	je     801024e0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801023e8:	83 ec 04             	sub    $0x4,%esp
801023eb:	6a 0e                	push   $0xe
801023ed:	68 4a 92 10 80       	push   $0x8010924a
801023f2:	53                   	push   %ebx
801023f3:	e8 88 30 00 00       	call   80105480 <strncmp>
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
80102447:	e8 14 2f 00 00       	call   80105360 <memset>
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
801024b4:	e8 87 36 00 00       	call   80105b40 <isdirempty>
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
8010253c:	68 5f 92 10 80       	push   $0x8010925f
80102541:	e8 4a de ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102546:	83 ec 0c             	sub    $0xc,%esp
80102549:	68 4d 92 10 80       	push   $0x8010924d
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
80102570:	68 43 92 10 80       	push   $0x80109243
80102575:	56                   	push   %esi
80102576:	e8 95 2e 00 00       	call   80105410 <memmove>
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
80102595:	e8 b6 37 00 00       	call   80105d50 <create>
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
801025e9:	68 6e 92 10 80       	push   $0x8010926e
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
8010271b:	68 e8 92 10 80       	push   $0x801092e8
80102720:	e8 6b dc ff ff       	call   80100390 <panic>
    panic("idestart");
80102725:	83 ec 0c             	sub    $0xc,%esp
80102728:	68 df 92 10 80       	push   $0x801092df
8010272d:	e8 5e dc ff ff       	call   80100390 <panic>
80102732:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <ideinit>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102746:	68 fa 92 10 80       	push   $0x801092fa
8010274b:	68 a0 c5 10 80       	push   $0x8010c5a0
80102750:	e8 bb 29 00 00       	call   80105110 <initlock>
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
801027ce:	e8 7d 2a 00 00       	call   80105250 <acquire>

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
80102831:	e8 0a 25 00 00       	call   80104d40 <wakeup>

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
8010284f:	e8 bc 2a 00 00       	call   80105310 <release>

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
8010286e:	e8 4d 28 00 00       	call   801050c0 <holdingsleep>
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
801028a8:	e8 a3 29 00 00       	call   80105250 <acquire>

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
801028f9:	e8 02 22 00 00       	call   80104b00 <sleep>
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
80102916:	e9 f5 29 00 00       	jmp    80105310 <release>
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
8010293a:	68 14 93 10 80       	push   $0x80109314
8010293f:	e8 4c da ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 fe 92 10 80       	push   $0x801092fe
8010294c:	e8 3f da ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	68 29 93 10 80       	push   $0x80109329
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
801029a7:	68 48 93 10 80       	push   $0x80109348
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
80102a8d:	e8 ce 28 00 00       	call   80105360 <memset>

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
80102af3:	e9 18 28 00 00       	jmp    80105310 <release>
80102af8:	90                   	nop
80102af9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102b00:	83 ec 0c             	sub    $0xc,%esp
80102b03:	68 20 5a 11 80       	push   $0x80115a20
80102b08:	e8 43 27 00 00       	call   80105250 <acquire>
80102b0d:	83 c4 10             	add    $0x10,%esp
80102b10:	eb 8d                	jmp    80102a9f <kfree+0x4f>
    panic("kfree");
80102b12:	83 ec 0c             	sub    $0xc,%esp
80102b15:	68 7a 93 10 80       	push   $0x8010937a
80102b1a:	e8 71 d8 ff ff       	call   80100390 <panic>
    panic("kfree: freeing a shared page");
80102b1f:	83 ec 0c             	sub    $0xc,%esp
80102b22:	68 80 93 10 80       	push   $0x80109380
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
80102b6d:	e8 ee 27 00 00       	call   80105360 <memset>

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
80102bbe:	e8 8d 26 00 00       	call   80105250 <acquire>
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
80102bfd:	e9 0e 27 00 00       	jmp    80105310 <release>
    panic("kfree_nocheck");
80102c02:	83 ec 0c             	sub    $0xc,%esp
80102c05:	68 9d 93 10 80       	push   $0x8010939d
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
80102c6b:	68 ab 93 10 80       	push   $0x801093ab
80102c70:	68 20 5a 11 80       	push   $0x80115a20
80102c75:	e8 96 24 00 00       	call   80105110 <initlock>
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
80102d7b:	e8 90 25 00 00       	call   80105310 <release>
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
80102da0:	e8 ab 24 00 00       	call   80105250 <acquire>
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
80102dcb:	e8 40 25 00 00       	call   80105310 <release>
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
80102e21:	e8 2a 24 00 00       	call   80105250 <acquire>
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
80102e45:	e9 c6 24 00 00       	jmp    80105310 <release>
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
80102e91:	e8 ba 23 00 00       	call   80105250 <acquire>
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
80102eb5:	e9 56 24 00 00       	jmp    80105310 <release>
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
80102f23:	0f b6 82 e0 94 10 80 	movzbl -0x7fef6b20(%edx),%eax
80102f2a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102f2c:	0f b6 82 e0 93 10 80 	movzbl -0x7fef6c20(%edx),%eax
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
80102f43:	8b 04 85 c0 93 10 80 	mov    -0x7fef6c40(,%eax,4),%eax
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
80102f68:	0f b6 82 e0 94 10 80 	movzbl -0x7fef6b20(%edx),%eax
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
801032e7:	e8 c4 20 00 00       	call   801053b0 <memcmp>
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
80103414:	e8 f7 1f 00 00       	call   80105410 <memmove>
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
801034ba:	68 e0 95 10 80       	push   $0x801095e0
801034bf:	68 60 5a 18 80       	push   $0x80185a60
801034c4:	e8 47 1c 00 00       	call   80105110 <initlock>
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
8010355b:	e8 f0 1c 00 00       	call   80105250 <acquire>
80103560:	83 c4 10             	add    $0x10,%esp
80103563:	eb 18                	jmp    8010357d <begin_op+0x2d>
80103565:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103568:	83 ec 08             	sub    $0x8,%esp
8010356b:	68 60 5a 18 80       	push   $0x80185a60
80103570:	68 60 5a 18 80       	push   $0x80185a60
80103575:	e8 86 15 00 00       	call   80104b00 <sleep>
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
801035ac:	e8 5f 1d 00 00       	call   80105310 <release>
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
801035ce:	e8 7d 1c 00 00       	call   80105250 <acquire>
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
8010360c:	e8 ff 1c 00 00       	call   80105310 <release>
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
80103666:	e8 a5 1d 00 00       	call   80105410 <memmove>
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
801036af:	e8 9c 1b 00 00       	call   80105250 <acquire>
    wakeup(&log);
801036b4:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
    log.committing = 0;
801036bb:	c7 05 a0 5a 18 80 00 	movl   $0x0,0x80185aa0
801036c2:	00 00 00 
    wakeup(&log);
801036c5:	e8 76 16 00 00       	call   80104d40 <wakeup>
    release(&log.lock);
801036ca:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036d1:	e8 3a 1c 00 00       	call   80105310 <release>
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
801036f0:	e8 4b 16 00 00       	call   80104d40 <wakeup>
  release(&log.lock);
801036f5:	c7 04 24 60 5a 18 80 	movl   $0x80185a60,(%esp)
801036fc:	e8 0f 1c 00 00       	call   80105310 <release>
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
8010370f:	68 e4 95 10 80       	push   $0x801095e4
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
8010375e:	e8 ed 1a 00 00       	call   80105250 <acquire>
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
801037ad:	e9 5e 1b 00 00       	jmp    80105310 <release>
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
801037d9:	68 f3 95 10 80       	push   $0x801095f3
801037de:	e8 ad cb ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801037e3:	83 ec 0c             	sub    $0xc,%esp
801037e6:	68 09 96 10 80       	push   $0x80109609
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
80103808:	68 24 96 10 80       	push   $0x80109624
8010380d:	e8 4e ce ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103812:	e8 39 2e 00 00       	call   80106650 <idtinit>
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
8010382a:	e8 c1 0f 00 00       	call   801047f0 <scheduler>
8010382f:	90                   	nop

80103830 <mpenter>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103836:	e8 f5 3f 00 00       	call   80107830 <switchkvm>
  seginit();
8010383b:	e8 60 3f 00 00       	call   801077a0 <seginit>
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
80103871:	e8 0a 49 00 00       	call   80108180 <kvmalloc>
  mpinit();        // detect other processors
80103876:	e8 75 01 00 00       	call   801039f0 <mpinit>
  lapicinit();     // interrupt controller
8010387b:	e8 60 f7 ff ff       	call   80102fe0 <lapicinit>
  seginit();       // segment descriptors
80103880:	e8 1b 3f 00 00       	call   801077a0 <seginit>
  picinit();       // disable pic
80103885:	e8 46 03 00 00       	call   80103bd0 <picinit>
  ioapicinit();    // another interrupt controller
8010388a:	e8 d1 f0 ff ff       	call   80102960 <ioapicinit>
  consoleinit();   // console hardware
8010388f:	e8 2c d1 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103894:	e8 f7 30 00 00       	call   80106990 <uartinit>
  pinit();         // process table
80103899:	e8 62 09 00 00       	call   80104200 <pinit>
  tvinit();        // trap vectors
8010389e:	e8 2d 2d 00 00       	call   801065d0 <tvinit>
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
801038c4:	e8 47 1b 00 00       	call   80105410 <memmove>

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
8010399e:	68 38 96 10 80       	push   $0x80109638
801039a3:	56                   	push   %esi
801039a4:	e8 07 1a 00 00       	call   801053b0 <memcmp>
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
80103a5c:	68 55 96 10 80       	push   $0x80109655
80103a61:	56                   	push   %esi
80103a62:	e8 49 19 00 00       	call   801053b0 <memcmp>
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
80103af0:	ff 24 95 7c 96 10 80 	jmp    *-0x7fef6984(,%edx,4)
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
80103ba3:	68 3d 96 10 80       	push   $0x8010963d
80103ba8:	e8 e3 c7 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103bad:	83 ec 0c             	sub    $0xc,%esp
80103bb0:	68 5c 96 10 80       	push   $0x8010965c
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
80103cab:	68 90 96 10 80       	push   $0x80109690
80103cb0:	50                   	push   %eax
80103cb1:	e8 5a 14 00 00       	call   80105110 <initlock>
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
80103d0f:	e8 3c 15 00 00       	call   80105250 <acquire>
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
80103d2f:	e8 0c 10 00 00       	call   80104d40 <wakeup>
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
80103d54:	e9 b7 15 00 00       	jmp    80105310 <release>
80103d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103d60:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103d66:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103d69:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103d70:	00 00 00 
    wakeup(&p->nwrite);
80103d73:	50                   	push   %eax
80103d74:	e8 c7 0f 00 00       	call   80104d40 <wakeup>
80103d79:	83 c4 10             	add    $0x10,%esp
80103d7c:	eb b9                	jmp    80103d37 <pipeclose+0x37>
80103d7e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	53                   	push   %ebx
80103d84:	e8 87 15 00 00       	call   80105310 <release>
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
80103dad:	e8 9e 14 00 00       	call   80105250 <acquire>
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
80103e04:	e8 37 0f 00 00       	call   80104d40 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e09:	5a                   	pop    %edx
80103e0a:	59                   	pop    %ecx
80103e0b:	53                   	push   %ebx
80103e0c:	56                   	push   %esi
80103e0d:	e8 ee 0c 00 00       	call   80104b00 <sleep>
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
80103e44:	e8 c7 14 00 00       	call   80105310 <release>
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
80103e93:	e8 a8 0e 00 00       	call   80104d40 <wakeup>
  release(&p->lock);
80103e98:	89 1c 24             	mov    %ebx,(%esp)
80103e9b:	e8 70 14 00 00       	call   80105310 <release>
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
80103ec0:	e8 8b 13 00 00       	call   80105250 <acquire>
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
80103ef5:	e8 06 0c 00 00       	call   80104b00 <sleep>
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
80103f2e:	e8 dd 13 00 00       	call   80105310 <release>
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
80103f87:	e8 b4 0d 00 00       	call   80104d40 <wakeup>
  release(&p->lock);
80103f8c:	89 34 24             	mov    %esi,(%esp)
80103f8f:	e8 7c 13 00 00       	call   80105310 <release>
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
80103fc3:	e8 88 12 00 00       	call   80105250 <acquire>
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
80104009:	e8 02 13 00 00       	call   80105310 <release>

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
80104032:	c7 40 14 c1 65 10 80 	movl   $0x801065c1,0x14(%eax)
  p->context = (struct context*)sp;
80104039:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010403c:	6a 14                	push   $0x14
8010403e:	6a 00                	push   $0x0
80104040:	50                   	push   %eax
80104041:	e8 1a 13 00 00       	call   80105360 <memset>
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
801040dd:	e8 7e 12 00 00       	call   80105360 <memset>
    memset(p->swappedPages, 0, sizeof(struct page) * MAX_PSYC_PAGES);
801040e2:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
801040e8:	83 c4 0c             	add    $0xc,%esp
801040eb:	68 c0 01 00 00       	push   $0x1c0
801040f0:	6a 00                	push   $0x0
801040f2:	50                   	push   %eax
801040f3:	e8 68 12 00 00       	call   80105360 <memset>
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
80104182:	e8 89 11 00 00       	call   80105310 <release>
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
801041a5:	68 95 96 10 80       	push   $0x80109695
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
801041bb:	e8 50 11 00 00       	call   80105310 <release>

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
80104206:	68 af 96 10 80       	push   $0x801096af
8010420b:	68 00 61 18 80       	push   $0x80186100
80104210:	e8 fb 0e 00 00       	call   80105110 <initlock>
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
80104280:	68 b6 96 10 80       	push   $0x801096b6
80104285:	e8 06 c1 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010428a:	83 ec 0c             	sub    $0xc,%esp
8010428d:	68 a4 97 10 80       	push   $0x801097a4
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
801042c7:	e8 b4 0e 00 00       	call   80105180 <pushcli>
  c = mycpu();
801042cc:	e8 4f ff ff ff       	call   80104220 <mycpu>
  p = c->proc;
801042d1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042d7:	e8 e4 0e 00 00       	call   801051c0 <popcli>
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
80104303:	e8 e8 3d 00 00       	call   801080f0 <setupkvm>
80104308:	85 c0                	test   %eax,%eax
8010430a:	89 43 04             	mov    %eax,0x4(%ebx)
8010430d:	0f 84 bd 00 00 00    	je     801043d0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104313:	83 ec 04             	sub    $0x4,%esp
80104316:	68 2c 00 00 00       	push   $0x2c
8010431b:	68 60 c4 10 80       	push   $0x8010c460
80104320:	50                   	push   %eax
80104321:	e8 3a 36 00 00       	call   80107960 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80104326:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80104329:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010432f:	6a 4c                	push   $0x4c
80104331:	6a 00                	push   $0x0
80104333:	ff 73 18             	pushl  0x18(%ebx)
80104336:	e8 25 10 00 00       	call   80105360 <memset>
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
8010438f:	68 df 96 10 80       	push   $0x801096df
80104394:	50                   	push   %eax
80104395:	e8 a6 11 00 00       	call   80105540 <safestrcpy>
  p->cwd = namei("/");
8010439a:	c7 04 24 e8 96 10 80 	movl   $0x801096e8,(%esp)
801043a1:	e8 ea de ff ff       	call   80102290 <namei>
801043a6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801043a9:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043b0:	e8 9b 0e 00 00       	call   80105250 <acquire>
  p->state = RUNNABLE;
801043b5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801043bc:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
801043c3:	e8 48 0f 00 00       	call   80105310 <release>
}
801043c8:	83 c4 10             	add    $0x10,%esp
801043cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043ce:	c9                   	leave  
801043cf:	c3                   	ret    
    panic("userinit: out of memory?");
801043d0:	83 ec 0c             	sub    $0xc,%esp
801043d3:	68 c6 96 10 80       	push   $0x801096c6
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
801043eb:	e8 90 0d 00 00       	call   80105180 <pushcli>
  c = mycpu();
801043f0:	e8 2b fe ff ff       	call   80104220 <mycpu>
  p = c->proc;
801043f5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043fb:	e8 c0 0d 00 00       	call   801051c0 <popcli>
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
8010440f:	e8 3c 34 00 00       	call   80107850 <switchuvm>
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
8010442a:	e8 b1 3a 00 00       	call   80107ee0 <allocuvm>
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
80104446:	68 ea 96 10 80       	push   $0x801096ea
8010444b:	e8 10 c2 ff ff       	call   80100660 <cprintf>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104453:	83 c4 0c             	add    $0xc,%esp
80104456:	01 c6                	add    %eax,%esi
80104458:	56                   	push   %esi
80104459:	50                   	push   %eax
8010445a:	ff 73 04             	pushl  0x4(%ebx)
8010445d:	e8 5e 38 00 00       	call   80107cc0 <deallocuvm>
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
8010447c:	e8 ff 0c 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104481:	e8 9a fd ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104486:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010448c:	e8 2f 0d 00 00       	call   801051c0 <popcli>
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
8010451c:	e8 5f 0c 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104521:	e8 fa fc ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104526:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
8010452c:	89 b5 e4 f7 ff ff    	mov    %esi,-0x81c(%ebp)
  popcli();
80104532:	e8 89 0c 00 00       	call   801051c0 <popcli>
  if((np = allocproc()) == 0){
80104537:	e8 74 fa ff ff       	call   80103fb0 <allocproc>
8010453c:	85 c0                	test   %eax,%eax
8010453e:	89 85 e0 f7 ff ff    	mov    %eax,-0x820(%ebp)
80104544:	0f 84 73 02 00 00    	je     801047bd <fork+0x2ad>
  if(curproc->pid <= 2) // init, shell
8010454a:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
8010454e:	89 c3                	mov    %eax,%ebx
80104550:	8b 16                	mov    (%esi),%edx
80104552:	8b 46 04             	mov    0x4(%esi),%eax
80104555:	0f 8f 0a 02 00 00    	jg     80104765 <fork+0x255>
    np->pgdir = copyuvm(curproc->pgdir, curproc->sz);
8010455b:	83 ec 08             	sub    $0x8,%esp
8010455e:	52                   	push   %edx
8010455f:	50                   	push   %eax
80104560:	e8 3b 43 00 00       	call   801088a0 <copyuvm>
80104565:	83 c4 10             	add    $0x10,%esp
80104568:	89 43 04             	mov    %eax,0x4(%ebx)
  if(np->pgdir == 0){
8010456b:	85 c0                	test   %eax,%eax
8010456d:	0f 84 51 02 00 00    	je     801047c4 <fork+0x2b4>
  np->sz = curproc->sz;
80104573:	8b 95 e4 f7 ff ff    	mov    -0x81c(%ebp),%edx
80104579:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
8010457f:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80104581:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104584:	89 51 14             	mov    %edx,0x14(%ecx)
  np->sz = curproc->sz;
80104587:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104589:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
8010458b:	8b 72 18             	mov    0x18(%edx),%esi
8010458e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104593:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  if(curproc->pid > 2) // not init or shell
80104595:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80104599:	0f 8e 20 01 00 00    	jle    801046bf <fork+0x1af>
    np->totalPgfltCount = 0;
8010459f:	c7 80 28 04 00 00 00 	movl   $0x0,0x428(%eax)
801045a6:	00 00 00 
    np->totalPgoutCount = 0;
801045a9:	c7 80 2c 04 00 00 00 	movl   $0x0,0x42c(%eax)
801045b0:	00 00 00 
    np->totalPgfltCount = 0;
801045b3:	89 c1                	mov    %eax,%ecx
    np->num_ram = curproc->num_ram;
801045b5:	8b 82 08 04 00 00    	mov    0x408(%edx),%eax
801045bb:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
    np->num_swap = curproc->num_swap;
801045c1:	8b 82 0c 04 00 00    	mov    0x40c(%edx),%eax
801045c7:	89 81 0c 04 00 00    	mov    %eax,0x40c(%ecx)
      if(curproc->ramPages[i].isused)
801045cd:	8b 9a 4c 02 00 00    	mov    0x24c(%edx),%ebx
801045d3:	85 db                	test   %ebx,%ebx
801045d5:	0f 85 a5 01 00 00    	jne    80104780 <fork+0x270>
801045db:	8d b5 e8 f7 ff ff    	lea    -0x818(%ebp),%esi
{ 
801045e1:	c7 85 dc f7 ff ff 00 	movl   $0x0,-0x824(%ebp)
801045e8:	00 00 00 
801045eb:	90                   	nop
801045ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(curproc->swappedPages[i].isused)
801045f0:	8b 8d e4 f7 ff ff    	mov    -0x81c(%ebp),%ecx
801045f6:	8b 95 dc f7 ff ff    	mov    -0x824(%ebp),%edx
801045fc:	8b 84 11 8c 00 00 00 	mov    0x8c(%ecx,%edx,1),%eax
80104603:	85 c0                	test   %eax,%eax
80104605:	74 45                	je     8010464c <fork+0x13c>
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
80104667:	eb 23                	jmp    8010468c <fork+0x17c>
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        if (writeToSwapFile(np, buffer, offset, nread) == -1)
80104670:	53                   	push   %ebx
80104671:	57                   	push   %edi
80104672:	56                   	push   %esi
80104673:	ff b5 e0 f7 ff ff    	pushl  -0x820(%ebp)
80104679:	e8 82 df ff ff       	call   80102600 <writeToSwapFile>
8010467e:	83 c4 10             	add    $0x10,%esp
80104681:	83 f8 ff             	cmp    $0xffffffff,%eax
80104684:	0f 84 26 01 00 00    	je     801047b0 <fork+0x2a0>
        offset += nread;
8010468a:	01 df                	add    %ebx,%edi
      while ((nread = readFromSwapFile(curproc, buffer, offset, PGSIZE / 2)) != 0) {
8010468c:	68 00 08 00 00       	push   $0x800
80104691:	57                   	push   %edi
80104692:	56                   	push   %esi
80104693:	ff b5 e4 f7 ff ff    	pushl  -0x81c(%ebp)
80104699:	e8 92 df ff ff       	call   80102630 <readFromSwapFile>
8010469e:	83 c4 10             	add    $0x10,%esp
801046a1:	85 c0                	test   %eax,%eax
801046a3:	89 c3                	mov    %eax,%ebx
801046a5:	75 c9                	jne    80104670 <fork+0x160>
801046a7:	83 85 dc f7 ff ff 1c 	addl   $0x1c,-0x824(%ebp)
801046ae:	8b 85 dc f7 ff ff    	mov    -0x824(%ebp),%eax
    for(i = 0; i < MAX_PSYC_PAGES; i++)
801046b4:	3d c0 01 00 00       	cmp    $0x1c0,%eax
801046b9:	0f 85 31 ff ff ff    	jne    801045f0 <fork+0xe0>
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
801046e6:	74 10                	je     801046f8 <fork+0x1e8>
      np->ofile[i] = filedup(curproc->ofile[i]);
801046e8:	83 ec 0c             	sub    $0xc,%esp
801046eb:	50                   	push   %eax
801046ec:	e8 af ca ff ff       	call   801011a0 <filedup>
801046f1:	83 c4 10             	add    $0x10,%esp
801046f4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
801046f8:	83 c6 01             	add    $0x1,%esi
801046fb:	83 fe 10             	cmp    $0x10,%esi
801046fe:	75 e0                	jne    801046e0 <fork+0x1d0>
  np->cwd = idup(curproc->cwd);
80104700:	8b b5 e4 f7 ff ff    	mov    -0x81c(%ebp),%esi
80104706:	83 ec 0c             	sub    $0xc,%esp
80104709:	ff 76 68             	pushl  0x68(%esi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010470c:	8d 5e 6c             	lea    0x6c(%esi),%ebx
  np->cwd = idup(curproc->cwd);
8010470f:	e8 ec d2 ff ff       	call   80101a00 <idup>
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
80104729:	e8 12 0e 00 00       	call   80105540 <safestrcpy>
  pid = np->pid;
8010472e:	8b 5e 10             	mov    0x10(%esi),%ebx
  copyAQ(np);
80104731:	89 34 24             	mov    %esi,(%esp)
80104734:	e8 37 fd ff ff       	call   80104470 <copyAQ>
  acquire(&ptable.lock);
80104739:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104740:	e8 0b 0b 00 00       	call   80105250 <acquire>
  np->state = RUNNABLE;
80104745:	c7 46 0c 03 00 00 00 	movl   $0x3,0xc(%esi)
  release(&ptable.lock);
8010474c:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104753:	e8 b8 0b 00 00       	call   80105310 <release>
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
    np->pgdir = cowuvm(curproc->pgdir, curproc->sz);
80104765:	83 ec 08             	sub    $0x8,%esp
80104768:	52                   	push   %edx
80104769:	50                   	push   %eax
8010476a:	e8 61 3a 00 00       	call   801081d0 <cowuvm>
8010476f:	8b 8d e0 f7 ff ff    	mov    -0x820(%ebp),%ecx
80104775:	83 c4 10             	add    $0x10,%esp
80104778:	89 41 04             	mov    %eax,0x4(%ecx)
8010477b:	e9 eb fd ff ff       	jmp    8010456b <fork+0x5b>
        np->ramPages[i].isused = 1;
80104780:	c7 81 4c 02 00 00 01 	movl   $0x1,0x24c(%ecx)
80104787:	00 00 00 
        np->ramPages[i].virt_addr = curproc->ramPages[i].virt_addr;
8010478a:	8b 82 50 02 00 00    	mov    0x250(%edx),%eax
80104790:	89 81 50 02 00 00    	mov    %eax,0x250(%ecx)
        np->ramPages[i].pgdir = np->pgdir;
80104796:	8b 41 04             	mov    0x4(%ecx),%eax
80104799:	89 81 48 02 00 00    	mov    %eax,0x248(%ecx)
        np->ramPages[i].ref_bit = curproc->ramPages[i].ref_bit;
8010479f:	8b 82 58 02 00 00    	mov    0x258(%edx),%eax
801047a5:	89 81 58 02 00 00    	mov    %eax,0x258(%ecx)
801047ab:	e9 2b fe ff ff       	jmp    801045db <fork+0xcb>
          panic("fork: error copying parent's swap file");
801047b0:	83 ec 0c             	sub    $0xc,%esp
801047b3:	68 cc 97 10 80       	push   $0x801097cc
801047b8:	e8 d3 bb ff ff       	call   80100390 <panic>
    return -1;
801047bd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801047c2:	eb 97                	jmp    8010475b <fork+0x24b>
    kfree(np->kstack);
801047c4:	8b b5 e0 f7 ff ff    	mov    -0x820(%ebp),%esi
801047ca:	83 ec 0c             	sub    $0xc,%esp
    return -1;
801047cd:	83 cb ff             	or     $0xffffffff,%ebx
    kfree(np->kstack);
801047d0:	ff 76 08             	pushl  0x8(%esi)
801047d3:	e8 78 e2 ff ff       	call   80102a50 <kfree>
    np->kstack = 0;
801047d8:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    np->state = UNUSED;
801047df:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    return -1;
801047e6:	83 c4 10             	add    $0x10,%esp
801047e9:	e9 6d ff ff ff       	jmp    8010475b <fork+0x24b>
801047ee:	66 90                	xchg   %ax,%ax

801047f0 <scheduler>:
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	57                   	push   %edi
801047f4:	56                   	push   %esi
801047f5:	53                   	push   %ebx
801047f6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801047f9:	e8 22 fa ff ff       	call   80104220 <mycpu>
801047fe:	8d 78 04             	lea    0x4(%eax),%edi
80104801:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104803:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010480a:	00 00 00 
8010480d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104810:	fb                   	sti    
    acquire(&ptable.lock);
80104811:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104814:	bb 34 61 18 80       	mov    $0x80186134,%ebx
    acquire(&ptable.lock);
80104819:	68 00 61 18 80       	push   $0x80186100
8010481e:	e8 2d 0a 00 00       	call   80105250 <acquire>
80104823:	83 c4 10             	add    $0x10,%esp
80104826:	8d 76 00             	lea    0x0(%esi),%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104830:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104834:	75 33                	jne    80104869 <scheduler+0x79>
      switchuvm(p);
80104836:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104839:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010483f:	53                   	push   %ebx
80104840:	e8 0b 30 00 00       	call   80107850 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104845:	58                   	pop    %eax
80104846:	5a                   	pop    %edx
80104847:	ff 73 1c             	pushl  0x1c(%ebx)
8010484a:	57                   	push   %edi
      p->state = RUNNING;
8010484b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104852:	e8 44 0d 00 00       	call   8010559b <swtch>
      switchkvm();
80104857:	e8 d4 2f 00 00       	call   80107830 <switchkvm>
      c->proc = 0;
8010485c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104863:	00 00 00 
80104866:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104869:	81 c3 30 04 00 00    	add    $0x430,%ebx
8010486f:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104875:	72 b9                	jb     80104830 <scheduler+0x40>
    release(&ptable.lock);
80104877:	83 ec 0c             	sub    $0xc,%esp
8010487a:	68 00 61 18 80       	push   $0x80186100
8010487f:	e8 8c 0a 00 00       	call   80105310 <release>
    sti();
80104884:	83 c4 10             	add    $0x10,%esp
80104887:	eb 87                	jmp    80104810 <scheduler+0x20>
80104889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104890 <sched>:
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
  pushcli();
80104895:	e8 e6 08 00 00       	call   80105180 <pushcli>
  c = mycpu();
8010489a:	e8 81 f9 ff ff       	call   80104220 <mycpu>
  p = c->proc;
8010489f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048a5:	e8 16 09 00 00       	call   801051c0 <popcli>
  if(!holding(&ptable.lock))
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	68 00 61 18 80       	push   $0x80186100
801048b2:	e8 69 09 00 00       	call   80105220 <holding>
801048b7:	83 c4 10             	add    $0x10,%esp
801048ba:	85 c0                	test   %eax,%eax
801048bc:	74 4f                	je     8010490d <sched+0x7d>
  if(mycpu()->ncli != 1)
801048be:	e8 5d f9 ff ff       	call   80104220 <mycpu>
801048c3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801048ca:	75 68                	jne    80104934 <sched+0xa4>
  if(p->state == RUNNING)
801048cc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801048d0:	74 55                	je     80104927 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048d2:	9c                   	pushf  
801048d3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048d4:	f6 c4 02             	test   $0x2,%ah
801048d7:	75 41                	jne    8010491a <sched+0x8a>
  intena = mycpu()->intena;
801048d9:	e8 42 f9 ff ff       	call   80104220 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801048de:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801048e1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801048e7:	e8 34 f9 ff ff       	call   80104220 <mycpu>
801048ec:	83 ec 08             	sub    $0x8,%esp
801048ef:	ff 70 04             	pushl  0x4(%eax)
801048f2:	53                   	push   %ebx
801048f3:	e8 a3 0c 00 00       	call   8010559b <swtch>
  mycpu()->intena = intena;
801048f8:	e8 23 f9 ff ff       	call   80104220 <mycpu>
}
801048fd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104900:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104906:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104909:	5b                   	pop    %ebx
8010490a:	5e                   	pop    %esi
8010490b:	5d                   	pop    %ebp
8010490c:	c3                   	ret    
    panic("sched ptable.lock");
8010490d:	83 ec 0c             	sub    $0xc,%esp
80104910:	68 fb 96 10 80       	push   $0x801096fb
80104915:	e8 76 ba ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010491a:	83 ec 0c             	sub    $0xc,%esp
8010491d:	68 27 97 10 80       	push   $0x80109727
80104922:	e8 69 ba ff ff       	call   80100390 <panic>
    panic("sched running");
80104927:	83 ec 0c             	sub    $0xc,%esp
8010492a:	68 19 97 10 80       	push   $0x80109719
8010492f:	e8 5c ba ff ff       	call   80100390 <panic>
    panic("sched locks");
80104934:	83 ec 0c             	sub    $0xc,%esp
80104937:	68 0d 97 10 80       	push   $0x8010970d
8010493c:	e8 4f ba ff ff       	call   80100390 <panic>
80104941:	eb 0d                	jmp    80104950 <exit>
80104943:	90                   	nop
80104944:	90                   	nop
80104945:	90                   	nop
80104946:	90                   	nop
80104947:	90                   	nop
80104948:	90                   	nop
80104949:	90                   	nop
8010494a:	90                   	nop
8010494b:	90                   	nop
8010494c:	90                   	nop
8010494d:	90                   	nop
8010494e:	90                   	nop
8010494f:	90                   	nop

80104950 <exit>:
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	56                   	push   %esi
80104955:	53                   	push   %ebx
80104956:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104959:	e8 22 08 00 00       	call   80105180 <pushcli>
  c = mycpu();
8010495e:	e8 bd f8 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104963:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104969:	e8 52 08 00 00       	call   801051c0 <popcli>
  if(curproc == initproc)
8010496e:	39 1d d8 c5 10 80    	cmp    %ebx,0x8010c5d8
80104974:	8d 73 28             	lea    0x28(%ebx),%esi
80104977:	8d 7b 68             	lea    0x68(%ebx),%edi
8010497a:	0f 84 22 01 00 00    	je     80104aa2 <exit+0x152>
    if(curproc->ofile[fd]){
80104980:	8b 06                	mov    (%esi),%eax
80104982:	85 c0                	test   %eax,%eax
80104984:	74 12                	je     80104998 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104986:	83 ec 0c             	sub    $0xc,%esp
80104989:	50                   	push   %eax
8010498a:	e8 61 c8 ff ff       	call   801011f0 <fileclose>
      curproc->ofile[fd] = 0;
8010498f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104995:	83 c4 10             	add    $0x10,%esp
80104998:	83 c6 04             	add    $0x4,%esi
  for(fd = 0; fd < NOFILE; fd++){
8010499b:	39 fe                	cmp    %edi,%esi
8010499d:	75 e1                	jne    80104980 <exit+0x30>
  begin_op();
8010499f:	e8 ac eb ff ff       	call   80103550 <begin_op>
  iput(curproc->cwd);
801049a4:	83 ec 0c             	sub    $0xc,%esp
801049a7:	ff 73 68             	pushl  0x68(%ebx)
801049aa:	e8 b1 d1 ff ff       	call   80101b60 <iput>
  end_op();
801049af:	e8 0c ec ff ff       	call   801035c0 <end_op>
  if(curproc->pid > 2) {
801049b4:	83 c4 10             	add    $0x10,%esp
801049b7:	83 7b 10 02          	cmpl   $0x2,0x10(%ebx)
  curproc->cwd = 0;
801049bb:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  if(curproc->pid > 2) {
801049c2:	0f 8f b9 00 00 00    	jg     80104a81 <exit+0x131>
  acquire(&ptable.lock);
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	68 00 61 18 80       	push   $0x80186100
801049d0:	e8 7b 08 00 00       	call   80105250 <acquire>
  wakeup1(curproc->parent);
801049d5:	8b 53 14             	mov    0x14(%ebx),%edx
801049d8:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049db:	b8 34 61 18 80       	mov    $0x80186134,%eax
801049e0:	eb 12                	jmp    801049f4 <exit+0xa4>
801049e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049e8:	05 30 04 00 00       	add    $0x430,%eax
801049ed:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
801049f2:	73 1e                	jae    80104a12 <exit+0xc2>
    if(p->state == SLEEPING && p->chan == chan)
801049f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801049f8:	75 ee                	jne    801049e8 <exit+0x98>
801049fa:	3b 50 20             	cmp    0x20(%eax),%edx
801049fd:	75 e9                	jne    801049e8 <exit+0x98>
      p->state = RUNNABLE;
801049ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a06:	05 30 04 00 00       	add    $0x430,%eax
80104a0b:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a10:	72 e2                	jb     801049f4 <exit+0xa4>
      p->parent = initproc;
80104a12:	8b 0d d8 c5 10 80    	mov    0x8010c5d8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a18:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104a1d:	eb 0f                	jmp    80104a2e <exit+0xde>
80104a1f:	90                   	nop
80104a20:	81 c2 30 04 00 00    	add    $0x430,%edx
80104a26:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104a2c:	73 3a                	jae    80104a68 <exit+0x118>
    if(p->parent == curproc){
80104a2e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104a31:	75 ed                	jne    80104a20 <exit+0xd0>
      if(p->state == ZOMBIE)
80104a33:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104a37:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104a3a:	75 e4                	jne    80104a20 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a3c:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104a41:	eb 11                	jmp    80104a54 <exit+0x104>
80104a43:	90                   	nop
80104a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a48:	05 30 04 00 00       	add    $0x430,%eax
80104a4d:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104a52:	73 cc                	jae    80104a20 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104a54:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104a58:	75 ee                	jne    80104a48 <exit+0xf8>
80104a5a:	3b 48 20             	cmp    0x20(%eax),%ecx
80104a5d:	75 e9                	jne    80104a48 <exit+0xf8>
      p->state = RUNNABLE;
80104a5f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104a66:	eb e0                	jmp    80104a48 <exit+0xf8>
  curproc->state = ZOMBIE;
80104a68:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80104a6f:	e8 1c fe ff ff       	call   80104890 <sched>
  panic("zombie exit");
80104a74:	83 ec 0c             	sub    $0xc,%esp
80104a77:	68 48 97 10 80       	push   $0x80109748
80104a7c:	e8 0f b9 ff ff       	call   80100390 <panic>
    if (removeSwapFile(curproc) != 0)
80104a81:	83 ec 0c             	sub    $0xc,%esp
80104a84:	53                   	push   %ebx
80104a85:	e8 d6 d8 ff ff       	call   80102360 <removeSwapFile>
80104a8a:	83 c4 10             	add    $0x10,%esp
80104a8d:	85 c0                	test   %eax,%eax
80104a8f:	0f 84 33 ff ff ff    	je     801049c8 <exit+0x78>
      panic("exit: error deleting swap file");
80104a95:	83 ec 0c             	sub    $0xc,%esp
80104a98:	68 f4 97 10 80       	push   $0x801097f4
80104a9d:	e8 ee b8 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104aa2:	83 ec 0c             	sub    $0xc,%esp
80104aa5:	68 3b 97 10 80       	push   $0x8010973b
80104aaa:	e8 e1 b8 ff ff       	call   80100390 <panic>
80104aaf:	90                   	nop

80104ab0 <yield>:
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	53                   	push   %ebx
80104ab4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104ab7:	68 00 61 18 80       	push   $0x80186100
80104abc:	e8 8f 07 00 00       	call   80105250 <acquire>
  pushcli();
80104ac1:	e8 ba 06 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104ac6:	e8 55 f7 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104acb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104ad1:	e8 ea 06 00 00       	call   801051c0 <popcli>
  myproc()->state = RUNNABLE;
80104ad6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104add:	e8 ae fd ff ff       	call   80104890 <sched>
  release(&ptable.lock);
80104ae2:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104ae9:	e8 22 08 00 00       	call   80105310 <release>
}
80104aee:	83 c4 10             	add    $0x10,%esp
80104af1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104af4:	c9                   	leave  
80104af5:	c3                   	ret    
80104af6:	8d 76 00             	lea    0x0(%esi),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <sleep>:
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 0c             	sub    $0xc,%esp
80104b09:	8b 7d 08             	mov    0x8(%ebp),%edi
80104b0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104b0f:	e8 6c 06 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104b14:	e8 07 f7 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104b19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104b1f:	e8 9c 06 00 00       	call   801051c0 <popcli>
  if(p == 0)
80104b24:	85 db                	test   %ebx,%ebx
80104b26:	0f 84 87 00 00 00    	je     80104bb3 <sleep+0xb3>
  if(lk == 0)
80104b2c:	85 f6                	test   %esi,%esi
80104b2e:	74 76                	je     80104ba6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104b30:	81 fe 00 61 18 80    	cmp    $0x80186100,%esi
80104b36:	74 50                	je     80104b88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104b38:	83 ec 0c             	sub    $0xc,%esp
80104b3b:	68 00 61 18 80       	push   $0x80186100
80104b40:	e8 0b 07 00 00       	call   80105250 <acquire>
    release(lk);
80104b45:	89 34 24             	mov    %esi,(%esp)
80104b48:	e8 c3 07 00 00       	call   80105310 <release>
  p->chan = chan;
80104b4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b57:	e8 34 fd ff ff       	call   80104890 <sched>
  p->chan = 0;
80104b5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104b63:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
80104b6a:	e8 a1 07 00 00       	call   80105310 <release>
    acquire(lk);
80104b6f:	89 75 08             	mov    %esi,0x8(%ebp)
80104b72:	83 c4 10             	add    $0x10,%esp
}
80104b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b78:	5b                   	pop    %ebx
80104b79:	5e                   	pop    %esi
80104b7a:	5f                   	pop    %edi
80104b7b:	5d                   	pop    %ebp
    acquire(lk);
80104b7c:	e9 cf 06 00 00       	jmp    80105250 <acquire>
80104b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104b88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104b8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104b92:	e8 f9 fc ff ff       	call   80104890 <sched>
  p->chan = 0;
80104b97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	5b                   	pop    %ebx
80104ba2:	5e                   	pop    %esi
80104ba3:	5f                   	pop    %edi
80104ba4:	5d                   	pop    %ebp
80104ba5:	c3                   	ret    
    panic("sleep without lk");
80104ba6:	83 ec 0c             	sub    $0xc,%esp
80104ba9:	68 5a 97 10 80       	push   $0x8010975a
80104bae:	e8 dd b7 ff ff       	call   80100390 <panic>
    panic("sleep");
80104bb3:	83 ec 0c             	sub    $0xc,%esp
80104bb6:	68 54 97 10 80       	push   $0x80109754
80104bbb:	e8 d0 b7 ff ff       	call   80100390 <panic>

80104bc0 <wait>:
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
  pushcli();
80104bc5:	e8 b6 05 00 00       	call   80105180 <pushcli>
  c = mycpu();
80104bca:	e8 51 f6 ff ff       	call   80104220 <mycpu>
  p = c->proc;
80104bcf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104bd5:	e8 e6 05 00 00       	call   801051c0 <popcli>
  acquire(&ptable.lock);
80104bda:	83 ec 0c             	sub    $0xc,%esp
80104bdd:	68 00 61 18 80       	push   $0x80186100
80104be2:	e8 69 06 00 00       	call   80105250 <acquire>
80104be7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104bea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bec:	bb 34 61 18 80       	mov    $0x80186134,%ebx
80104bf1:	eb 13                	jmp    80104c06 <wait+0x46>
80104bf3:	90                   	nop
80104bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bf8:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104bfe:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104c04:	73 1e                	jae    80104c24 <wait+0x64>
      if(p->parent != curproc)
80104c06:	39 73 14             	cmp    %esi,0x14(%ebx)
80104c09:	75 ed                	jne    80104bf8 <wait+0x38>
      if(p->state == ZOMBIE){
80104c0b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104c0f:	74 3f                	je     80104c50 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c11:	81 c3 30 04 00 00    	add    $0x430,%ebx
      havekids = 1;
80104c17:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c1c:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104c22:	72 e2                	jb     80104c06 <wait+0x46>
    if(!havekids || curproc->killed){
80104c24:	85 c0                	test   %eax,%eax
80104c26:	0f 84 f3 00 00 00    	je     80104d1f <wait+0x15f>
80104c2c:	8b 46 24             	mov    0x24(%esi),%eax
80104c2f:	85 c0                	test   %eax,%eax
80104c31:	0f 85 e8 00 00 00    	jne    80104d1f <wait+0x15f>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104c37:	83 ec 08             	sub    $0x8,%esp
80104c3a:	68 00 61 18 80       	push   $0x80186100
80104c3f:	56                   	push   %esi
80104c40:	e8 bb fe ff ff       	call   80104b00 <sleep>
    havekids = 0;
80104c45:	83 c4 10             	add    $0x10,%esp
80104c48:	eb a0                	jmp    80104bea <wait+0x2a>
80104c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104c50:	83 ec 0c             	sub    $0xc,%esp
80104c53:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104c56:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104c59:	e8 f2 dd ff ff       	call   80102a50 <kfree>
        freevm(p->pgdir); // panic: kfree
80104c5e:	5a                   	pop    %edx
80104c5f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104c62:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir); // panic: kfree
80104c69:	e8 02 34 00 00       	call   80108070 <freevm>
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c6e:	8d 83 48 02 00 00    	lea    0x248(%ebx),%eax
80104c74:	83 c4 0c             	add    $0xc,%esp
        p->pid = 0;
80104c77:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104c7e:	68 c0 01 00 00       	push   $0x1c0
80104c83:	6a 00                	push   $0x0
80104c85:	50                   	push   %eax
        p->parent = 0;
80104c86:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104c8d:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104c91:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->clockHand = 0;
80104c98:	c7 83 10 04 00 00 00 	movl   $0x0,0x410(%ebx)
80104c9f:	00 00 00 
        p->swapFile = 0;
80104ca2:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
        p->free_head = 0;
80104ca9:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80104cb0:	00 00 00 
        p->free_tail = 0;
80104cb3:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80104cba:	00 00 00 
        p->queue_head = 0;
80104cbd:	c7 83 1c 04 00 00 00 	movl   $0x0,0x41c(%ebx)
80104cc4:	00 00 00 
        p->queue_tail = 0;
80104cc7:	c7 83 20 04 00 00 00 	movl   $0x0,0x420(%ebx)
80104cce:	00 00 00 
        p->numswappages = 0;
80104cd1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80104cd8:	00 00 00 
        p-> nummemorypages = 0;
80104cdb:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104ce2:	00 00 00 
        memset(p->ramPages, 0, sizeof(p->ramPages));
80104ce5:	e8 76 06 00 00       	call   80105360 <memset>
        memset(p->swappedPages, 0, sizeof(p->swappedPages));
80104cea:	8d 83 88 00 00 00    	lea    0x88(%ebx),%eax
80104cf0:	83 c4 0c             	add    $0xc,%esp
80104cf3:	68 c0 01 00 00       	push   $0x1c0
80104cf8:	6a 00                	push   $0x0
80104cfa:	50                   	push   %eax
80104cfb:	e8 60 06 00 00       	call   80105360 <memset>
        release(&ptable.lock);
80104d00:	c7 04 24 00 61 18 80 	movl   $0x80186100,(%esp)
        p->state = UNUSED;
80104d07:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104d0e:	e8 fd 05 00 00       	call   80105310 <release>
        return pid;
80104d13:	83 c4 10             	add    $0x10,%esp
}
80104d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d19:	89 f0                	mov    %esi,%eax
80104d1b:	5b                   	pop    %ebx
80104d1c:	5e                   	pop    %esi
80104d1d:	5d                   	pop    %ebp
80104d1e:	c3                   	ret    
      release(&ptable.lock);
80104d1f:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104d22:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104d27:	68 00 61 18 80       	push   $0x80186100
80104d2c:	e8 df 05 00 00       	call   80105310 <release>
      return -1;
80104d31:	83 c4 10             	add    $0x10,%esp
80104d34:	eb e0                	jmp    80104d16 <wait+0x156>
80104d36:	8d 76 00             	lea    0x0(%esi),%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	53                   	push   %ebx
80104d44:	83 ec 10             	sub    $0x10,%esp
80104d47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104d4a:	68 00 61 18 80       	push   $0x80186100
80104d4f:	e8 fc 04 00 00       	call   80105250 <acquire>
80104d54:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d57:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104d5c:	eb 0e                	jmp    80104d6c <wakeup+0x2c>
80104d5e:	66 90                	xchg   %ax,%ax
80104d60:	05 30 04 00 00       	add    $0x430,%eax
80104d65:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d6a:	73 1e                	jae    80104d8a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80104d6c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104d70:	75 ee                	jne    80104d60 <wakeup+0x20>
80104d72:	3b 58 20             	cmp    0x20(%eax),%ebx
80104d75:	75 e9                	jne    80104d60 <wakeup+0x20>
      p->state = RUNNABLE;
80104d77:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d7e:	05 30 04 00 00       	add    $0x430,%eax
80104d83:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104d88:	72 e2                	jb     80104d6c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
80104d8a:	c7 45 08 00 61 18 80 	movl   $0x80186100,0x8(%ebp)
}
80104d91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d94:	c9                   	leave  
  release(&ptable.lock);
80104d95:	e9 76 05 00 00       	jmp    80105310 <release>
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 10             	sub    $0x10,%esp
80104da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104daa:	68 00 61 18 80       	push   $0x80186100
80104daf:	e8 9c 04 00 00       	call   80105250 <acquire>
80104db4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104db7:	b8 34 61 18 80       	mov    $0x80186134,%eax
80104dbc:	eb 0e                	jmp    80104dcc <kill+0x2c>
80104dbe:	66 90                	xchg   %ax,%ax
80104dc0:	05 30 04 00 00       	add    $0x430,%eax
80104dc5:	3d 34 6d 19 80       	cmp    $0x80196d34,%eax
80104dca:	73 34                	jae    80104e00 <kill+0x60>
    if(p->pid == pid){
80104dcc:	39 58 10             	cmp    %ebx,0x10(%eax)
80104dcf:	75 ef                	jne    80104dc0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104dd1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104dd5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104ddc:	75 07                	jne    80104de5 <kill+0x45>
        p->state = RUNNABLE;
80104dde:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104de5:	83 ec 0c             	sub    $0xc,%esp
80104de8:	68 00 61 18 80       	push   $0x80186100
80104ded:	e8 1e 05 00 00       	call   80105310 <release>
      return 0;
80104df2:	83 c4 10             	add    $0x10,%esp
80104df5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104df7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104dfa:	c9                   	leave  
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	68 00 61 18 80       	push   $0x80186100
80104e08:	e8 03 05 00 00       	call   80105310 <release>
  return -1;
80104e0d:	83 c4 10             	add    $0x10,%esp
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e18:	c9                   	leave  
80104e19:	c3                   	ret    
80104e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e20 <getCurrentFreePages>:
  }
}

int
getCurrentFreePages(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	53                   	push   %ebx
  struct proc *p;
  int sum = 0;
80104e24:	31 db                	xor    %ebx,%ebx
{
80104e26:	83 ec 10             	sub    $0x10,%esp
  int pcount = 0;
  acquire(&ptable.lock);
80104e29:	68 00 61 18 80       	push   $0x80186100
80104e2e:	e8 1d 04 00 00       	call   80105250 <acquire>
80104e33:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e36:	ba 34 61 18 80       	mov    $0x80186134,%edx
  {
    if(p->state == UNUSED)
      continue;
    sum += MAX_PSYC_PAGES - p->num_ram;
80104e3b:	b9 10 00 00 00       	mov    $0x10,%ecx
    if(p->state == UNUSED)
80104e40:	8b 42 0c             	mov    0xc(%edx),%eax
80104e43:	85 c0                	test   %eax,%eax
80104e45:	74 0a                	je     80104e51 <getCurrentFreePages+0x31>
    sum += MAX_PSYC_PAGES - p->num_ram;
80104e47:	89 c8                	mov    %ecx,%eax
80104e49:	2b 82 08 04 00 00    	sub    0x408(%edx),%eax
80104e4f:	01 c3                	add    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e51:	81 c2 30 04 00 00    	add    $0x430,%edx
80104e57:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104e5d:	72 e1                	jb     80104e40 <getCurrentFreePages+0x20>
    pcount++;
  }
  release(&ptable.lock);
80104e5f:	83 ec 0c             	sub    $0xc,%esp
80104e62:	68 00 61 18 80       	push   $0x80186100
80104e67:	e8 a4 04 00 00       	call   80105310 <release>
  return sum;
}
80104e6c:	89 d8                	mov    %ebx,%eax
80104e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e71:	c9                   	leave  
80104e72:	c3                   	ret    
80104e73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e80 <getTotalFreePages>:

int
getTotalFreePages(void)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	53                   	push   %ebx
  struct proc *p;
  int pcount = 0;
80104e84:	31 db                	xor    %ebx,%ebx
{
80104e86:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80104e89:	68 00 61 18 80       	push   $0x80186100
80104e8e:	e8 bd 03 00 00       	call   80105250 <acquire>
80104e93:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e96:	ba 34 61 18 80       	mov    $0x80186134,%edx
80104e9b:	90                   	nop
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    if(p->state == UNUSED)
      continue;
    pcount++;
80104ea0:	83 7a 0c 01          	cmpl   $0x1,0xc(%edx)
80104ea4:	83 db ff             	sbb    $0xffffffff,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ea7:	81 c2 30 04 00 00    	add    $0x430,%edx
80104ead:	81 fa 34 6d 19 80    	cmp    $0x80196d34,%edx
80104eb3:	72 eb                	jb     80104ea0 <getTotalFreePages+0x20>
  }
  release(&ptable.lock);
80104eb5:	83 ec 0c             	sub    $0xc,%esp
80104eb8:	68 00 61 18 80       	push   $0x80186100
80104ebd:	e8 4e 04 00 00       	call   80105310 <release>
  return pcount * MAX_PSYC_PAGES;
80104ec2:	89 d8                	mov    %ebx,%eax
80104ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return pcount * MAX_PSYC_PAGES;
80104ec7:	c1 e0 04             	shl    $0x4,%eax
80104eca:	c9                   	leave  
80104ecb:	c3                   	ret    
80104ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ed0 <procdump>:
{
80104ed0:	55                   	push   %ebp
80104ed1:	89 e5                	mov    %esp,%ebp
80104ed3:	57                   	push   %edi
80104ed4:	56                   	push   %esi
80104ed5:	53                   	push   %ebx
80104ed6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ed9:	bb 34 61 18 80       	mov    $0x80186134,%ebx
{
80104ede:	83 ec 3c             	sub    $0x3c,%esp
80104ee1:	eb 41                	jmp    80104f24 <procdump+0x54>
80104ee3:	90                   	nop
80104ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("\n<%d / %d>", getCurrentFreePages(), getTotalFreePages());
80104ee8:	e8 93 ff ff ff       	call   80104e80 <getTotalFreePages>
80104eed:	89 c7                	mov    %eax,%edi
80104eef:	e8 2c ff ff ff       	call   80104e20 <getCurrentFreePages>
80104ef4:	83 ec 04             	sub    $0x4,%esp
80104ef7:	57                   	push   %edi
80104ef8:	50                   	push   %eax
80104ef9:	68 6f 97 10 80       	push   $0x8010976f
80104efe:	e8 5d b7 ff ff       	call   80100660 <cprintf>
    cprintf("\n");
80104f03:	c7 04 24 40 9c 10 80 	movl   $0x80109c40,(%esp)
80104f0a:	e8 51 b7 ff ff       	call   80100660 <cprintf>
80104f0f:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f12:	81 c3 30 04 00 00    	add    $0x430,%ebx
80104f18:	81 fb 34 6d 19 80    	cmp    $0x80196d34,%ebx
80104f1e:	0f 83 ac 00 00 00    	jae    80104fd0 <procdump+0x100>
    if(p->state == UNUSED)
80104f24:	8b 43 0c             	mov    0xc(%ebx),%eax
80104f27:	85 c0                	test   %eax,%eax
80104f29:	74 e7                	je     80104f12 <procdump+0x42>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f2b:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104f2e:	ba 6b 97 10 80       	mov    $0x8010976b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f33:	77 11                	ja     80104f46 <procdump+0x76>
80104f35:	8b 14 85 7c 98 10 80 	mov    -0x7fef6784(,%eax,4),%edx
      state = "???";
80104f3c:	b8 6b 97 10 80       	mov    $0x8010976b,%eax
80104f41:	85 d2                	test   %edx,%edx
80104f43:	0f 44 d0             	cmove  %eax,%edx
    cprintf("<pid: %d> <state: %s> <name: %s> <num_ram: %d> <num swap: %d> <page faults: %d> <total paged out: %d>\n",
80104f46:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104f49:	ff b3 2c 04 00 00    	pushl  0x42c(%ebx)
80104f4f:	ff b3 28 04 00 00    	pushl  0x428(%ebx)
80104f55:	ff b3 0c 04 00 00    	pushl  0x40c(%ebx)
80104f5b:	ff b3 08 04 00 00    	pushl  0x408(%ebx)
80104f61:	50                   	push   %eax
80104f62:	52                   	push   %edx
80104f63:	ff 73 10             	pushl  0x10(%ebx)
80104f66:	68 14 98 10 80       	push   $0x80109814
80104f6b:	e8 f0 b6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104f70:	83 c4 20             	add    $0x20,%esp
80104f73:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104f77:	0f 85 6b ff ff ff    	jne    80104ee8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104f7d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104f80:	83 ec 08             	sub    $0x8,%esp
80104f83:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104f86:	50                   	push   %eax
80104f87:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104f8a:	8b 40 0c             	mov    0xc(%eax),%eax
80104f8d:	83 c0 08             	add    $0x8,%eax
80104f90:	50                   	push   %eax
80104f91:	e8 9a 01 00 00       	call   80105130 <getcallerpcs>
80104f96:	83 c4 10             	add    $0x10,%esp
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104fa0:	8b 17                	mov    (%edi),%edx
80104fa2:	85 d2                	test   %edx,%edx
80104fa4:	0f 84 3e ff ff ff    	je     80104ee8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104faa:	83 ec 08             	sub    $0x8,%esp
80104fad:	83 c7 04             	add    $0x4,%edi
80104fb0:	52                   	push   %edx
80104fb1:	68 c1 90 10 80       	push   $0x801090c1
80104fb6:	e8 a5 b6 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104fbb:	83 c4 10             	add    $0x10,%esp
80104fbe:	39 fe                	cmp    %edi,%esi
80104fc0:	75 de                	jne    80104fa0 <procdump+0xd0>
80104fc2:	e9 21 ff ff ff       	jmp    80104ee8 <procdump+0x18>
80104fc7:	89 f6                	mov    %esi,%esi
80104fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80104fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd3:	5b                   	pop    %ebx
80104fd4:	5e                   	pop    %esi
80104fd5:	5f                   	pop    %edi
80104fd6:	5d                   	pop    %ebp
80104fd7:	c3                   	ret    
80104fd8:	66 90                	xchg   %ax,%ax
80104fda:	66 90                	xchg   %ax,%ax
80104fdc:	66 90                	xchg   %ax,%ax
80104fde:	66 90                	xchg   %ax,%ax

80104fe0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	53                   	push   %ebx
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104fea:	68 94 98 10 80       	push   $0x80109894
80104fef:	8d 43 04             	lea    0x4(%ebx),%eax
80104ff2:	50                   	push   %eax
80104ff3:	e8 18 01 00 00       	call   80105110 <initlock>
  lk->name = name;
80104ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104ffb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80105001:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80105004:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010500b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010500e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105011:	c9                   	leave  
80105012:	c3                   	ret    
80105013:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
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
8010502f:	e8 1c 02 00 00       	call   80105250 <acquire>
  while (lk->locked) {
80105034:	8b 13                	mov    (%ebx),%edx
80105036:	83 c4 10             	add    $0x10,%esp
80105039:	85 d2                	test   %edx,%edx
8010503b:	74 16                	je     80105053 <acquiresleep+0x33>
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80105040:	83 ec 08             	sub    $0x8,%esp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
80105045:	e8 b6 fa ff ff       	call   80104b00 <sleep>
  while (lk->locked) {
8010504a:	8b 03                	mov    (%ebx),%eax
8010504c:	83 c4 10             	add    $0x10,%esp
8010504f:	85 c0                	test   %eax,%eax
80105051:	75 ed                	jne    80105040 <acquiresleep+0x20>
  }
  lk->locked = 1;
80105053:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80105059:	e8 62 f2 ff ff       	call   801042c0 <myproc>
8010505e:	8b 40 10             	mov    0x10(%eax),%eax
80105061:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80105064:	89 75 08             	mov    %esi,0x8(%ebp)
}
80105067:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010506a:	5b                   	pop    %ebx
8010506b:	5e                   	pop    %esi
8010506c:	5d                   	pop    %ebp
  release(&lk->lk);
8010506d:	e9 9e 02 00 00       	jmp    80105310 <release>
80105072:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105080 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
80105085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80105088:	83 ec 0c             	sub    $0xc,%esp
8010508b:	8d 73 04             	lea    0x4(%ebx),%esi
8010508e:	56                   	push   %esi
8010508f:	e8 bc 01 00 00       	call   80105250 <acquire>
  lk->locked = 0;
80105094:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010509a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801050a1:	89 1c 24             	mov    %ebx,(%esp)
801050a4:	e8 97 fc ff ff       	call   80104d40 <wakeup>
  release(&lk->lk);
801050a9:	89 75 08             	mov    %esi,0x8(%ebp)
801050ac:	83 c4 10             	add    $0x10,%esp
}
801050af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b2:	5b                   	pop    %ebx
801050b3:	5e                   	pop    %esi
801050b4:	5d                   	pop    %ebp
  release(&lk->lk);
801050b5:	e9 56 02 00 00       	jmp    80105310 <release>
801050ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801050c0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	57                   	push   %edi
801050c4:	56                   	push   %esi
801050c5:	53                   	push   %ebx
801050c6:	31 ff                	xor    %edi,%edi
801050c8:	83 ec 18             	sub    $0x18,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801050ce:	8d 73 04             	lea    0x4(%ebx),%esi
801050d1:	56                   	push   %esi
801050d2:	e8 79 01 00 00       	call   80105250 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801050d7:	8b 03                	mov    (%ebx),%eax
801050d9:	83 c4 10             	add    $0x10,%esp
801050dc:	85 c0                	test   %eax,%eax
801050de:	74 13                	je     801050f3 <holdingsleep+0x33>
801050e0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801050e3:	e8 d8 f1 ff ff       	call   801042c0 <myproc>
801050e8:	39 58 10             	cmp    %ebx,0x10(%eax)
801050eb:	0f 94 c0             	sete   %al
801050ee:	0f b6 c0             	movzbl %al,%eax
801050f1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801050f3:	83 ec 0c             	sub    $0xc,%esp
801050f6:	56                   	push   %esi
801050f7:	e8 14 02 00 00       	call   80105310 <release>
  return r;
}
801050fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050ff:	89 f8                	mov    %edi,%eax
80105101:	5b                   	pop    %ebx
80105102:	5e                   	pop    %esi
80105103:	5f                   	pop    %edi
80105104:	5d                   	pop    %ebp
80105105:	c3                   	ret    
80105106:	66 90                	xchg   %ax,%ax
80105108:	66 90                	xchg   %ax,%ax
8010510a:	66 90                	xchg   %ax,%ax
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80105116:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80105119:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010511f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80105122:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105129:	5d                   	pop    %ebp
8010512a:	c3                   	ret    
8010512b:	90                   	nop
8010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105130 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105130:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80105131:	31 d2                	xor    %edx,%edx
{
80105133:	89 e5                	mov    %esp,%ebp
80105135:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80105136:	8b 45 08             	mov    0x8(%ebp),%eax
{
80105139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010513c:	83 e8 08             	sub    $0x8,%eax
8010513f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105140:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80105146:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010514c:	77 1a                	ja     80105168 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010514e:	8b 58 04             	mov    0x4(%eax),%ebx
80105151:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80105154:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80105157:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80105159:	83 fa 0a             	cmp    $0xa,%edx
8010515c:	75 e2                	jne    80105140 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010515e:	5b                   	pop    %ebx
8010515f:	5d                   	pop    %ebp
80105160:	c3                   	ret    
80105161:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105168:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010516b:	83 c1 28             	add    $0x28,%ecx
8010516e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105170:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80105176:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80105179:	39 c1                	cmp    %eax,%ecx
8010517b:	75 f3                	jne    80105170 <getcallerpcs+0x40>
}
8010517d:	5b                   	pop    %ebx
8010517e:	5d                   	pop    %ebp
8010517f:	c3                   	ret    

80105180 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	53                   	push   %ebx
80105184:	83 ec 04             	sub    $0x4,%esp
80105187:	9c                   	pushf  
80105188:	5b                   	pop    %ebx
  asm volatile("cli");
80105189:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010518a:	e8 91 f0 ff ff       	call   80104220 <mycpu>
8010518f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105195:	85 c0                	test   %eax,%eax
80105197:	75 11                	jne    801051aa <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80105199:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010519f:	e8 7c f0 ff ff       	call   80104220 <mycpu>
801051a4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801051aa:	e8 71 f0 ff ff       	call   80104220 <mycpu>
801051af:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801051b6:	83 c4 04             	add    $0x4,%esp
801051b9:	5b                   	pop    %ebx
801051ba:	5d                   	pop    %ebp
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <popcli>:

void
popcli(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801051c6:	9c                   	pushf  
801051c7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801051c8:	f6 c4 02             	test   $0x2,%ah
801051cb:	75 35                	jne    80105202 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801051cd:	e8 4e f0 ff ff       	call   80104220 <mycpu>
801051d2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801051d9:	78 34                	js     8010520f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051db:	e8 40 f0 ff ff       	call   80104220 <mycpu>
801051e0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051e6:	85 d2                	test   %edx,%edx
801051e8:	74 06                	je     801051f0 <popcli+0x30>
    sti();
}
801051ea:	c9                   	leave  
801051eb:	c3                   	ret    
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801051f0:	e8 2b f0 ff ff       	call   80104220 <mycpu>
801051f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801051fb:	85 c0                	test   %eax,%eax
801051fd:	74 eb                	je     801051ea <popcli+0x2a>
  asm volatile("sti");
801051ff:	fb                   	sti    
}
80105200:	c9                   	leave  
80105201:	c3                   	ret    
    panic("popcli - interruptible");
80105202:	83 ec 0c             	sub    $0xc,%esp
80105205:	68 9f 98 10 80       	push   $0x8010989f
8010520a:	e8 81 b1 ff ff       	call   80100390 <panic>
    panic("popcli");
8010520f:	83 ec 0c             	sub    $0xc,%esp
80105212:	68 b6 98 10 80       	push   $0x801098b6
80105217:	e8 74 b1 ff ff       	call   80100390 <panic>
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <holding>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
80105225:	8b 75 08             	mov    0x8(%ebp),%esi
80105228:	31 db                	xor    %ebx,%ebx
  pushcli();
8010522a:	e8 51 ff ff ff       	call   80105180 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010522f:	8b 06                	mov    (%esi),%eax
80105231:	85 c0                	test   %eax,%eax
80105233:	74 10                	je     80105245 <holding+0x25>
80105235:	8b 5e 08             	mov    0x8(%esi),%ebx
80105238:	e8 e3 ef ff ff       	call   80104220 <mycpu>
8010523d:	39 c3                	cmp    %eax,%ebx
8010523f:	0f 94 c3             	sete   %bl
80105242:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80105245:	e8 76 ff ff ff       	call   801051c0 <popcli>
}
8010524a:	89 d8                	mov    %ebx,%eax
8010524c:	5b                   	pop    %ebx
8010524d:	5e                   	pop    %esi
8010524e:	5d                   	pop    %ebp
8010524f:	c3                   	ret    

80105250 <acquire>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105255:	e8 26 ff ff ff       	call   80105180 <pushcli>
  if(holding(lk))
8010525a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010525d:	83 ec 0c             	sub    $0xc,%esp
80105260:	53                   	push   %ebx
80105261:	e8 ba ff ff ff       	call   80105220 <holding>
80105266:	83 c4 10             	add    $0x10,%esp
80105269:	85 c0                	test   %eax,%eax
8010526b:	0f 85 83 00 00 00    	jne    801052f4 <acquire+0xa4>
80105271:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105273:	ba 01 00 00 00       	mov    $0x1,%edx
80105278:	eb 09                	jmp    80105283 <acquire+0x33>
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105280:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105283:	89 d0                	mov    %edx,%eax
80105285:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105288:	85 c0                	test   %eax,%eax
8010528a:	75 f4                	jne    80105280 <acquire+0x30>
  __sync_synchronize();
8010528c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105291:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105294:	e8 87 ef ff ff       	call   80104220 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80105299:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010529c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010529f:	89 e8                	mov    %ebp,%eax
801052a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801052a8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801052ae:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801052b4:	77 1a                	ja     801052d0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801052b6:	8b 48 04             	mov    0x4(%eax),%ecx
801052b9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801052bc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801052bf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801052c1:	83 fe 0a             	cmp    $0xa,%esi
801052c4:	75 e2                	jne    801052a8 <acquire+0x58>
}
801052c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c9:	5b                   	pop    %ebx
801052ca:	5e                   	pop    %esi
801052cb:	5d                   	pop    %ebp
801052cc:	c3                   	ret    
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
801052d0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801052d3:	83 c2 28             	add    $0x28,%edx
801052d6:	8d 76 00             	lea    0x0(%esi),%esi
801052d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801052e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801052e6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801052e9:	39 d0                	cmp    %edx,%eax
801052eb:	75 f3                	jne    801052e0 <acquire+0x90>
}
801052ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052f0:	5b                   	pop    %ebx
801052f1:	5e                   	pop    %esi
801052f2:	5d                   	pop    %ebp
801052f3:	c3                   	ret    
    panic("acquire");
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	68 bd 98 10 80       	push   $0x801098bd
801052fc:	e8 8f b0 ff ff       	call   80100390 <panic>
80105301:	eb 0d                	jmp    80105310 <release>
80105303:	90                   	nop
80105304:	90                   	nop
80105305:	90                   	nop
80105306:	90                   	nop
80105307:	90                   	nop
80105308:	90                   	nop
80105309:	90                   	nop
8010530a:	90                   	nop
8010530b:	90                   	nop
8010530c:	90                   	nop
8010530d:	90                   	nop
8010530e:	90                   	nop
8010530f:	90                   	nop

80105310 <release>:
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	53                   	push   %ebx
80105314:	83 ec 10             	sub    $0x10,%esp
80105317:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010531a:	53                   	push   %ebx
8010531b:	e8 00 ff ff ff       	call   80105220 <holding>
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	85 c0                	test   %eax,%eax
80105325:	74 22                	je     80105349 <release+0x39>
  lk->pcs[0] = 0;
80105327:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010532e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80105335:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010533a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80105340:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105343:	c9                   	leave  
  popcli();
80105344:	e9 77 fe ff ff       	jmp    801051c0 <popcli>
    panic("release");
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	68 c5 98 10 80       	push   $0x801098c5
80105351:	e8 3a b0 ff ff       	call   80100390 <panic>
80105356:	66 90                	xchg   %ax,%ax
80105358:	66 90                	xchg   %ax,%ax
8010535a:	66 90                	xchg   %ax,%ax
8010535c:	66 90                	xchg   %ax,%ax
8010535e:	66 90                	xchg   %ax,%ax

80105360 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105360:	55                   	push   %ebp
80105361:	89 e5                	mov    %esp,%ebp
80105363:	57                   	push   %edi
80105364:	53                   	push   %ebx
80105365:	8b 55 08             	mov    0x8(%ebp),%edx
80105368:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010536b:	f6 c2 03             	test   $0x3,%dl
8010536e:	75 05                	jne    80105375 <memset+0x15>
80105370:	f6 c1 03             	test   $0x3,%cl
80105373:	74 13                	je     80105388 <memset+0x28>
  asm volatile("cld; rep stosb" :
80105375:	89 d7                	mov    %edx,%edi
80105377:	8b 45 0c             	mov    0xc(%ebp),%eax
8010537a:	fc                   	cld    
8010537b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010537d:	5b                   	pop    %ebx
8010537e:	89 d0                	mov    %edx,%eax
80105380:	5f                   	pop    %edi
80105381:	5d                   	pop    %ebp
80105382:	c3                   	ret    
80105383:	90                   	nop
80105384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80105388:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010538c:	c1 e9 02             	shr    $0x2,%ecx
8010538f:	89 f8                	mov    %edi,%eax
80105391:	89 fb                	mov    %edi,%ebx
80105393:	c1 e0 18             	shl    $0x18,%eax
80105396:	c1 e3 10             	shl    $0x10,%ebx
80105399:	09 d8                	or     %ebx,%eax
8010539b:	09 f8                	or     %edi,%eax
8010539d:	c1 e7 08             	shl    $0x8,%edi
801053a0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801053a2:	89 d7                	mov    %edx,%edi
801053a4:	fc                   	cld    
801053a5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801053a7:	5b                   	pop    %ebx
801053a8:	89 d0                	mov    %edx,%eax
801053aa:	5f                   	pop    %edi
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    
801053ad:	8d 76 00             	lea    0x0(%esi),%esi

801053b0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801053b0:	55                   	push   %ebp
801053b1:	89 e5                	mov    %esp,%ebp
801053b3:	57                   	push   %edi
801053b4:	56                   	push   %esi
801053b5:	53                   	push   %ebx
801053b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801053b9:	8b 75 08             	mov    0x8(%ebp),%esi
801053bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801053bf:	85 db                	test   %ebx,%ebx
801053c1:	74 29                	je     801053ec <memcmp+0x3c>
    if(*s1 != *s2)
801053c3:	0f b6 16             	movzbl (%esi),%edx
801053c6:	0f b6 0f             	movzbl (%edi),%ecx
801053c9:	38 d1                	cmp    %dl,%cl
801053cb:	75 2b                	jne    801053f8 <memcmp+0x48>
801053cd:	b8 01 00 00 00       	mov    $0x1,%eax
801053d2:	eb 14                	jmp    801053e8 <memcmp+0x38>
801053d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801053dc:	83 c0 01             	add    $0x1,%eax
801053df:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801053e4:	38 ca                	cmp    %cl,%dl
801053e6:	75 10                	jne    801053f8 <memcmp+0x48>
  while(n-- > 0){
801053e8:	39 d8                	cmp    %ebx,%eax
801053ea:	75 ec                	jne    801053d8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801053ec:	5b                   	pop    %ebx
  return 0;
801053ed:	31 c0                	xor    %eax,%eax
}
801053ef:	5e                   	pop    %esi
801053f0:	5f                   	pop    %edi
801053f1:	5d                   	pop    %ebp
801053f2:	c3                   	ret    
801053f3:	90                   	nop
801053f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
801053f8:	0f b6 c2             	movzbl %dl,%eax
}
801053fb:	5b                   	pop    %ebx
      return *s1 - *s2;
801053fc:	29 c8                	sub    %ecx,%eax
}
801053fe:	5e                   	pop    %esi
801053ff:	5f                   	pop    %edi
80105400:	5d                   	pop    %ebp
80105401:	c3                   	ret    
80105402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	56                   	push   %esi
80105414:	53                   	push   %ebx
80105415:	8b 45 08             	mov    0x8(%ebp),%eax
80105418:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010541b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010541e:	39 c3                	cmp    %eax,%ebx
80105420:	73 26                	jae    80105448 <memmove+0x38>
80105422:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80105425:	39 c8                	cmp    %ecx,%eax
80105427:	73 1f                	jae    80105448 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80105429:	85 f6                	test   %esi,%esi
8010542b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010542e:	74 0f                	je     8010543f <memmove+0x2f>
      *--d = *--s;
80105430:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105434:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80105437:	83 ea 01             	sub    $0x1,%edx
8010543a:	83 fa ff             	cmp    $0xffffffff,%edx
8010543d:	75 f1                	jne    80105430 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010543f:	5b                   	pop    %ebx
80105440:	5e                   	pop    %esi
80105441:	5d                   	pop    %ebp
80105442:	c3                   	ret    
80105443:	90                   	nop
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80105448:	31 d2                	xor    %edx,%edx
8010544a:	85 f6                	test   %esi,%esi
8010544c:	74 f1                	je     8010543f <memmove+0x2f>
8010544e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80105450:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80105454:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80105457:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010545a:	39 d6                	cmp    %edx,%esi
8010545c:	75 f2                	jne    80105450 <memmove+0x40>
}
8010545e:	5b                   	pop    %ebx
8010545f:	5e                   	pop    %esi
80105460:	5d                   	pop    %ebp
80105461:	c3                   	ret    
80105462:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105470 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80105473:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80105474:	eb 9a                	jmp    80105410 <memmove>
80105476:	8d 76 00             	lea    0x0(%esi),%esi
80105479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105480 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	57                   	push   %edi
80105484:	56                   	push   %esi
80105485:	8b 7d 10             	mov    0x10(%ebp),%edi
80105488:	53                   	push   %ebx
80105489:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010548c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010548f:	85 ff                	test   %edi,%edi
80105491:	74 2f                	je     801054c2 <strncmp+0x42>
80105493:	0f b6 01             	movzbl (%ecx),%eax
80105496:	0f b6 1e             	movzbl (%esi),%ebx
80105499:	84 c0                	test   %al,%al
8010549b:	74 37                	je     801054d4 <strncmp+0x54>
8010549d:	38 c3                	cmp    %al,%bl
8010549f:	75 33                	jne    801054d4 <strncmp+0x54>
801054a1:	01 f7                	add    %esi,%edi
801054a3:	eb 13                	jmp    801054b8 <strncmp+0x38>
801054a5:	8d 76 00             	lea    0x0(%esi),%esi
801054a8:	0f b6 01             	movzbl (%ecx),%eax
801054ab:	84 c0                	test   %al,%al
801054ad:	74 21                	je     801054d0 <strncmp+0x50>
801054af:	0f b6 1a             	movzbl (%edx),%ebx
801054b2:	89 d6                	mov    %edx,%esi
801054b4:	38 d8                	cmp    %bl,%al
801054b6:	75 1c                	jne    801054d4 <strncmp+0x54>
    n--, p++, q++;
801054b8:	8d 56 01             	lea    0x1(%esi),%edx
801054bb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801054be:	39 fa                	cmp    %edi,%edx
801054c0:	75 e6                	jne    801054a8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801054c2:	5b                   	pop    %ebx
    return 0;
801054c3:	31 c0                	xor    %eax,%eax
}
801054c5:	5e                   	pop    %esi
801054c6:	5f                   	pop    %edi
801054c7:	5d                   	pop    %ebp
801054c8:	c3                   	ret    
801054c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054d0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801054d4:	29 d8                	sub    %ebx,%eax
}
801054d6:	5b                   	pop    %ebx
801054d7:	5e                   	pop    %esi
801054d8:	5f                   	pop    %edi
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	90                   	nop
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054e0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
801054e5:	8b 45 08             	mov    0x8(%ebp),%eax
801054e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801054eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801054ee:	89 c2                	mov    %eax,%edx
801054f0:	eb 19                	jmp    8010550b <strncpy+0x2b>
801054f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054f8:	83 c3 01             	add    $0x1,%ebx
801054fb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
801054ff:	83 c2 01             	add    $0x1,%edx
80105502:	84 c9                	test   %cl,%cl
80105504:	88 4a ff             	mov    %cl,-0x1(%edx)
80105507:	74 09                	je     80105512 <strncpy+0x32>
80105509:	89 f1                	mov    %esi,%ecx
8010550b:	85 c9                	test   %ecx,%ecx
8010550d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80105510:	7f e6                	jg     801054f8 <strncpy+0x18>
    ;
  while(n-- > 0)
80105512:	31 c9                	xor    %ecx,%ecx
80105514:	85 f6                	test   %esi,%esi
80105516:	7e 17                	jle    8010552f <strncpy+0x4f>
80105518:	90                   	nop
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80105520:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80105524:	89 f3                	mov    %esi,%ebx
80105526:	83 c1 01             	add    $0x1,%ecx
80105529:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
8010552b:	85 db                	test   %ebx,%ebx
8010552d:	7f f1                	jg     80105520 <strncpy+0x40>
  return os;
}
8010552f:	5b                   	pop    %ebx
80105530:	5e                   	pop    %esi
80105531:	5d                   	pop    %ebp
80105532:	c3                   	ret    
80105533:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105540 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	53                   	push   %ebx
80105545:	8b 4d 10             	mov    0x10(%ebp),%ecx
80105548:	8b 45 08             	mov    0x8(%ebp),%eax
8010554b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010554e:	85 c9                	test   %ecx,%ecx
80105550:	7e 26                	jle    80105578 <safestrcpy+0x38>
80105552:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80105556:	89 c1                	mov    %eax,%ecx
80105558:	eb 17                	jmp    80105571 <safestrcpy+0x31>
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105560:	83 c2 01             	add    $0x1,%edx
80105563:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80105567:	83 c1 01             	add    $0x1,%ecx
8010556a:	84 db                	test   %bl,%bl
8010556c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010556f:	74 04                	je     80105575 <safestrcpy+0x35>
80105571:	39 f2                	cmp    %esi,%edx
80105573:	75 eb                	jne    80105560 <safestrcpy+0x20>
    ;
  *s = 0;
80105575:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80105578:	5b                   	pop    %ebx
80105579:	5e                   	pop    %esi
8010557a:	5d                   	pop    %ebp
8010557b:	c3                   	ret    
8010557c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105580 <strlen>:

int
strlen(const char *s)
{
80105580:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105581:	31 c0                	xor    %eax,%eax
{
80105583:	89 e5                	mov    %esp,%ebp
80105585:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105588:	80 3a 00             	cmpb   $0x0,(%edx)
8010558b:	74 0c                	je     80105599 <strlen+0x19>
8010558d:	8d 76 00             	lea    0x0(%esi),%esi
80105590:	83 c0 01             	add    $0x1,%eax
80105593:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105597:	75 f7                	jne    80105590 <strlen+0x10>
    ;
  return n;
}
80105599:	5d                   	pop    %ebp
8010559a:	c3                   	ret    

8010559b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010559b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010559f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801055a3:	55                   	push   %ebp
  pushl %ebx
801055a4:	53                   	push   %ebx
  pushl %esi
801055a5:	56                   	push   %esi
  pushl %edi
801055a6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801055a7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801055a9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801055ab:	5f                   	pop    %edi
  popl %esi
801055ac:	5e                   	pop    %esi
  popl %ebx
801055ad:	5b                   	pop    %ebx
  popl %ebp
801055ae:	5d                   	pop    %ebp
  ret
801055af:	c3                   	ret    

801055b0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	53                   	push   %ebx
801055b4:	83 ec 04             	sub    $0x4,%esp
801055b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801055ba:	e8 01 ed ff ff       	call   801042c0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055bf:	8b 00                	mov    (%eax),%eax
801055c1:	39 d8                	cmp    %ebx,%eax
801055c3:	76 1b                	jbe    801055e0 <fetchint+0x30>
801055c5:	8d 53 04             	lea    0x4(%ebx),%edx
801055c8:	39 d0                	cmp    %edx,%eax
801055ca:	72 14                	jb     801055e0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801055cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801055cf:	8b 13                	mov    (%ebx),%edx
801055d1:	89 10                	mov    %edx,(%eax)
  return 0;
801055d3:	31 c0                	xor    %eax,%eax
}
801055d5:	83 c4 04             	add    $0x4,%esp
801055d8:	5b                   	pop    %ebx
801055d9:	5d                   	pop    %ebp
801055da:	c3                   	ret    
801055db:	90                   	nop
801055dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e5:	eb ee                	jmp    801055d5 <fetchint+0x25>
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
801055f4:	83 ec 04             	sub    $0x4,%esp
801055f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801055fa:	e8 c1 ec ff ff       	call   801042c0 <myproc>

  if(addr >= curproc->sz)
801055ff:	39 18                	cmp    %ebx,(%eax)
80105601:	76 29                	jbe    8010562c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80105603:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105606:	89 da                	mov    %ebx,%edx
80105608:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010560a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010560c:	39 c3                	cmp    %eax,%ebx
8010560e:	73 1c                	jae    8010562c <fetchstr+0x3c>
    if(*s == 0)
80105610:	80 3b 00             	cmpb   $0x0,(%ebx)
80105613:	75 10                	jne    80105625 <fetchstr+0x35>
80105615:	eb 39                	jmp    80105650 <fetchstr+0x60>
80105617:	89 f6                	mov    %esi,%esi
80105619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105620:	80 3a 00             	cmpb   $0x0,(%edx)
80105623:	74 1b                	je     80105640 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80105625:	83 c2 01             	add    $0x1,%edx
80105628:	39 d0                	cmp    %edx,%eax
8010562a:	77 f4                	ja     80105620 <fetchstr+0x30>
    return -1;
8010562c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80105631:	83 c4 04             	add    $0x4,%esp
80105634:	5b                   	pop    %ebx
80105635:	5d                   	pop    %ebp
80105636:	c3                   	ret    
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105640:	83 c4 04             	add    $0x4,%esp
80105643:	89 d0                	mov    %edx,%eax
80105645:	29 d8                	sub    %ebx,%eax
80105647:	5b                   	pop    %ebx
80105648:	5d                   	pop    %ebp
80105649:	c3                   	ret    
8010564a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105650:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105652:	eb dd                	jmp    80105631 <fetchstr+0x41>
80105654:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010565a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105660 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	56                   	push   %esi
80105664:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105665:	e8 56 ec ff ff       	call   801042c0 <myproc>
8010566a:	8b 40 18             	mov    0x18(%eax),%eax
8010566d:	8b 55 08             	mov    0x8(%ebp),%edx
80105670:	8b 40 44             	mov    0x44(%eax),%eax
80105673:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105676:	e8 45 ec ff ff       	call   801042c0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010567b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010567d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105680:	39 c6                	cmp    %eax,%esi
80105682:	73 1c                	jae    801056a0 <argint+0x40>
80105684:	8d 53 08             	lea    0x8(%ebx),%edx
80105687:	39 d0                	cmp    %edx,%eax
80105689:	72 15                	jb     801056a0 <argint+0x40>
  *ip = *(int*)(addr);
8010568b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010568e:	8b 53 04             	mov    0x4(%ebx),%edx
80105691:	89 10                	mov    %edx,(%eax)
  return 0;
80105693:	31 c0                	xor    %eax,%eax
}
80105695:	5b                   	pop    %ebx
80105696:	5e                   	pop    %esi
80105697:	5d                   	pop    %ebp
80105698:	c3                   	ret    
80105699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801056a5:	eb ee                	jmp    80105695 <argint+0x35>
801056a7:	89 f6                	mov    %esi,%esi
801056a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	56                   	push   %esi
801056b4:	53                   	push   %ebx
801056b5:	83 ec 10             	sub    $0x10,%esp
801056b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801056bb:	e8 00 ec ff ff       	call   801042c0 <myproc>
801056c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801056c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	50                   	push   %eax
801056c9:	ff 75 08             	pushl  0x8(%ebp)
801056cc:	e8 8f ff ff ff       	call   80105660 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801056d1:	83 c4 10             	add    $0x10,%esp
801056d4:	85 c0                	test   %eax,%eax
801056d6:	78 28                	js     80105700 <argptr+0x50>
801056d8:	85 db                	test   %ebx,%ebx
801056da:	78 24                	js     80105700 <argptr+0x50>
801056dc:	8b 16                	mov    (%esi),%edx
801056de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e1:	39 c2                	cmp    %eax,%edx
801056e3:	76 1b                	jbe    80105700 <argptr+0x50>
801056e5:	01 c3                	add    %eax,%ebx
801056e7:	39 da                	cmp    %ebx,%edx
801056e9:	72 15                	jb     80105700 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801056eb:	8b 55 0c             	mov    0xc(%ebp),%edx
801056ee:	89 02                	mov    %eax,(%edx)
  return 0;
801056f0:	31 c0                	xor    %eax,%eax
}
801056f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801056f5:	5b                   	pop    %ebx
801056f6:	5e                   	pop    %esi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105700:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105705:	eb eb                	jmp    801056f2 <argptr+0x42>
80105707:	89 f6                	mov    %esi,%esi
80105709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105710 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105716:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105719:	50                   	push   %eax
8010571a:	ff 75 08             	pushl  0x8(%ebp)
8010571d:	e8 3e ff ff ff       	call   80105660 <argint>
80105722:	83 c4 10             	add    $0x10,%esp
80105725:	85 c0                	test   %eax,%eax
80105727:	78 17                	js     80105740 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80105729:	83 ec 08             	sub    $0x8,%esp
8010572c:	ff 75 0c             	pushl  0xc(%ebp)
8010572f:	ff 75 f4             	pushl  -0xc(%ebp)
80105732:	e8 b9 fe ff ff       	call   801055f0 <fetchstr>
80105737:	83 c4 10             	add    $0x10,%esp
}
8010573a:	c9                   	leave  
8010573b:	c3                   	ret    
8010573c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105740:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105745:	c9                   	leave  
80105746:	c3                   	ret    
80105747:	89 f6                	mov    %esi,%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <syscall>:
[SYS_getTotalFreePages]    sys_getTotalFreePages
};

void
syscall(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	53                   	push   %ebx
80105754:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105757:	e8 64 eb ff ff       	call   801042c0 <myproc>
8010575c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010575e:	8b 40 18             	mov    0x18(%eax),%eax
80105761:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105764:	8d 50 ff             	lea    -0x1(%eax),%edx
80105767:	83 fa 16             	cmp    $0x16,%edx
8010576a:	77 1c                	ja     80105788 <syscall+0x38>
8010576c:	8b 14 85 00 99 10 80 	mov    -0x7fef6700(,%eax,4),%edx
80105773:	85 d2                	test   %edx,%edx
80105775:	74 11                	je     80105788 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105777:	ff d2                	call   *%edx
80105779:	8b 53 18             	mov    0x18(%ebx),%edx
8010577c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010577f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105782:	c9                   	leave  
80105783:	c3                   	ret    
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105788:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105789:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010578c:	50                   	push   %eax
8010578d:	ff 73 10             	pushl  0x10(%ebx)
80105790:	68 cd 98 10 80       	push   $0x801098cd
80105795:	e8 c6 ae ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010579a:	8b 43 18             	mov    0x18(%ebx),%eax
8010579d:	83 c4 10             	add    $0x10,%esp
801057a0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801057a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    
801057ac:	66 90                	xchg   %ax,%ax
801057ae:	66 90                	xchg   %ax,%ax

801057b0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	56                   	push   %esi
801057b4:	53                   	push   %ebx
801057b5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801057b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801057ba:	89 d6                	mov    %edx,%esi
801057bc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801057bf:	50                   	push   %eax
801057c0:	6a 00                	push   $0x0
801057c2:	e8 99 fe ff ff       	call   80105660 <argint>
801057c7:	83 c4 10             	add    $0x10,%esp
801057ca:	85 c0                	test   %eax,%eax
801057cc:	78 2a                	js     801057f8 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057ce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801057d2:	77 24                	ja     801057f8 <argfd.constprop.0+0x48>
801057d4:	e8 e7 ea ff ff       	call   801042c0 <myproc>
801057d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057dc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801057e0:	85 c0                	test   %eax,%eax
801057e2:	74 14                	je     801057f8 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
801057e4:	85 db                	test   %ebx,%ebx
801057e6:	74 02                	je     801057ea <argfd.constprop.0+0x3a>
    *pfd = fd;
801057e8:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
801057ea:	89 06                	mov    %eax,(%esi)
  return 0;
801057ec:	31 c0                	xor    %eax,%eax
}
801057ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057f1:	5b                   	pop    %ebx
801057f2:	5e                   	pop    %esi
801057f3:	5d                   	pop    %ebp
801057f4:	c3                   	ret    
801057f5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801057f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057fd:	eb ef                	jmp    801057ee <argfd.constprop.0+0x3e>
801057ff:	90                   	nop

80105800 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80105800:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105801:	31 c0                	xor    %eax,%eax
{
80105803:	89 e5                	mov    %esp,%ebp
80105805:	56                   	push   %esi
80105806:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105807:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010580a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010580d:	e8 9e ff ff ff       	call   801057b0 <argfd.constprop.0>
80105812:	85 c0                	test   %eax,%eax
80105814:	78 42                	js     80105858 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80105816:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105819:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010581b:	e8 a0 ea ff ff       	call   801042c0 <myproc>
80105820:	eb 0e                	jmp    80105830 <sys_dup+0x30>
80105822:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105828:	83 c3 01             	add    $0x1,%ebx
8010582b:	83 fb 10             	cmp    $0x10,%ebx
8010582e:	74 28                	je     80105858 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105830:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105834:	85 d2                	test   %edx,%edx
80105836:	75 f0                	jne    80105828 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105838:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
8010583c:	83 ec 0c             	sub    $0xc,%esp
8010583f:	ff 75 f4             	pushl  -0xc(%ebp)
80105842:	e8 59 b9 ff ff       	call   801011a0 <filedup>
  return fd;
80105847:	83 c4 10             	add    $0x10,%esp
}
8010584a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010584d:	89 d8                	mov    %ebx,%eax
8010584f:	5b                   	pop    %ebx
80105850:	5e                   	pop    %esi
80105851:	5d                   	pop    %ebp
80105852:	c3                   	ret    
80105853:	90                   	nop
80105854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105858:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010585b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105860:	89 d8                	mov    %ebx,%eax
80105862:	5b                   	pop    %ebx
80105863:	5e                   	pop    %esi
80105864:	5d                   	pop    %ebp
80105865:	c3                   	ret    
80105866:	8d 76 00             	lea    0x0(%esi),%esi
80105869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105870 <sys_read>:

int
sys_read(void)
{
80105870:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105871:	31 c0                	xor    %eax,%eax
{
80105873:	89 e5                	mov    %esp,%ebp
80105875:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105878:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010587b:	e8 30 ff ff ff       	call   801057b0 <argfd.constprop.0>
80105880:	85 c0                	test   %eax,%eax
80105882:	78 4c                	js     801058d0 <sys_read+0x60>
80105884:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105887:	83 ec 08             	sub    $0x8,%esp
8010588a:	50                   	push   %eax
8010588b:	6a 02                	push   $0x2
8010588d:	e8 ce fd ff ff       	call   80105660 <argint>
80105892:	83 c4 10             	add    $0x10,%esp
80105895:	85 c0                	test   %eax,%eax
80105897:	78 37                	js     801058d0 <sys_read+0x60>
80105899:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010589c:	83 ec 04             	sub    $0x4,%esp
8010589f:	ff 75 f0             	pushl  -0x10(%ebp)
801058a2:	50                   	push   %eax
801058a3:	6a 01                	push   $0x1
801058a5:	e8 06 fe ff ff       	call   801056b0 <argptr>
801058aa:	83 c4 10             	add    $0x10,%esp
801058ad:	85 c0                	test   %eax,%eax
801058af:	78 1f                	js     801058d0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
801058b1:	83 ec 04             	sub    $0x4,%esp
801058b4:	ff 75 f0             	pushl  -0x10(%ebp)
801058b7:	ff 75 f4             	pushl  -0xc(%ebp)
801058ba:	ff 75 ec             	pushl  -0x14(%ebp)
801058bd:	e8 4e ba ff ff       	call   80101310 <fileread>
801058c2:	83 c4 10             	add    $0x10,%esp
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

801058e0 <sys_write>:

int
sys_write(void)
{
801058e0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058e1:	31 c0                	xor    %eax,%eax
{
801058e3:	89 e5                	mov    %esp,%ebp
801058e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058e8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801058eb:	e8 c0 fe ff ff       	call   801057b0 <argfd.constprop.0>
801058f0:	85 c0                	test   %eax,%eax
801058f2:	78 4c                	js     80105940 <sys_write+0x60>
801058f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058f7:	83 ec 08             	sub    $0x8,%esp
801058fa:	50                   	push   %eax
801058fb:	6a 02                	push   $0x2
801058fd:	e8 5e fd ff ff       	call   80105660 <argint>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	78 37                	js     80105940 <sys_write+0x60>
80105909:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010590c:	83 ec 04             	sub    $0x4,%esp
8010590f:	ff 75 f0             	pushl  -0x10(%ebp)
80105912:	50                   	push   %eax
80105913:	6a 01                	push   $0x1
80105915:	e8 96 fd ff ff       	call   801056b0 <argptr>
8010591a:	83 c4 10             	add    $0x10,%esp
8010591d:	85 c0                	test   %eax,%eax
8010591f:	78 1f                	js     80105940 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105921:	83 ec 04             	sub    $0x4,%esp
80105924:	ff 75 f0             	pushl  -0x10(%ebp)
80105927:	ff 75 f4             	pushl  -0xc(%ebp)
8010592a:	ff 75 ec             	pushl  -0x14(%ebp)
8010592d:	e8 6e ba ff ff       	call   801013a0 <filewrite>
80105932:	83 c4 10             	add    $0x10,%esp
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

80105950 <sys_close>:

int
sys_close(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105956:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105959:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010595c:	e8 4f fe ff ff       	call   801057b0 <argfd.constprop.0>
80105961:	85 c0                	test   %eax,%eax
80105963:	78 2b                	js     80105990 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80105965:	e8 56 e9 ff ff       	call   801042c0 <myproc>
8010596a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010596d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105970:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105977:	00 
  fileclose(f);
80105978:	ff 75 f4             	pushl  -0xc(%ebp)
8010597b:	e8 70 b8 ff ff       	call   801011f0 <fileclose>
  return 0;
80105980:	83 c4 10             	add    $0x10,%esp
80105983:	31 c0                	xor    %eax,%eax
}
80105985:	c9                   	leave  
80105986:	c3                   	ret    
80105987:	89 f6                	mov    %esi,%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105990:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105995:	c9                   	leave  
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059a0 <sys_fstat>:

int
sys_fstat(void)
{
801059a0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059a1:	31 c0                	xor    %eax,%eax
{
801059a3:	89 e5                	mov    %esp,%ebp
801059a5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801059ab:	e8 00 fe ff ff       	call   801057b0 <argfd.constprop.0>
801059b0:	85 c0                	test   %eax,%eax
801059b2:	78 2c                	js     801059e0 <sys_fstat+0x40>
801059b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059b7:	83 ec 04             	sub    $0x4,%esp
801059ba:	6a 14                	push   $0x14
801059bc:	50                   	push   %eax
801059bd:	6a 01                	push   $0x1
801059bf:	e8 ec fc ff ff       	call   801056b0 <argptr>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	85 c0                	test   %eax,%eax
801059c9:	78 15                	js     801059e0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
801059cb:	83 ec 08             	sub    $0x8,%esp
801059ce:	ff 75 f4             	pushl  -0xc(%ebp)
801059d1:	ff 75 f0             	pushl  -0x10(%ebp)
801059d4:	e8 e7 b8 ff ff       	call   801012c0 <filestat>
801059d9:	83 c4 10             	add    $0x10,%esp
}
801059dc:	c9                   	leave  
801059dd:	c3                   	ret    
801059de:	66 90                	xchg   %ax,%ax
    return -1;
801059e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059e5:	c9                   	leave  
801059e6:	c3                   	ret    
801059e7:	89 f6                	mov    %esi,%esi
801059e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059f0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801059f9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801059fc:	50                   	push   %eax
801059fd:	6a 00                	push   $0x0
801059ff:	e8 0c fd ff ff       	call   80105710 <argstr>
80105a04:	83 c4 10             	add    $0x10,%esp
80105a07:	85 c0                	test   %eax,%eax
80105a09:	0f 88 fb 00 00 00    	js     80105b0a <sys_link+0x11a>
80105a0f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105a12:	83 ec 08             	sub    $0x8,%esp
80105a15:	50                   	push   %eax
80105a16:	6a 01                	push   $0x1
80105a18:	e8 f3 fc ff ff       	call   80105710 <argstr>
80105a1d:	83 c4 10             	add    $0x10,%esp
80105a20:	85 c0                	test   %eax,%eax
80105a22:	0f 88 e2 00 00 00    	js     80105b0a <sys_link+0x11a>
    return -1;

  begin_op();
80105a28:	e8 23 db ff ff       	call   80103550 <begin_op>
  if((ip = namei(old)) == 0){
80105a2d:	83 ec 0c             	sub    $0xc,%esp
80105a30:	ff 75 d4             	pushl  -0x2c(%ebp)
80105a33:	e8 58 c8 ff ff       	call   80102290 <namei>
80105a38:	83 c4 10             	add    $0x10,%esp
80105a3b:	85 c0                	test   %eax,%eax
80105a3d:	89 c3                	mov    %eax,%ebx
80105a3f:	0f 84 ea 00 00 00    	je     80105b2f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105a45:	83 ec 0c             	sub    $0xc,%esp
80105a48:	50                   	push   %eax
80105a49:	e8 e2 bf ff ff       	call   80101a30 <ilock>
  if(ip->type == T_DIR){
80105a4e:	83 c4 10             	add    $0x10,%esp
80105a51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105a56:	0f 84 bb 00 00 00    	je     80105b17 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80105a5c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a61:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80105a64:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105a67:	53                   	push   %ebx
80105a68:	e8 13 bf ff ff       	call   80101980 <iupdate>
  iunlock(ip);
80105a6d:	89 1c 24             	mov    %ebx,(%esp)
80105a70:	e8 9b c0 ff ff       	call   80101b10 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105a75:	58                   	pop    %eax
80105a76:	5a                   	pop    %edx
80105a77:	57                   	push   %edi
80105a78:	ff 75 d0             	pushl  -0x30(%ebp)
80105a7b:	e8 30 c8 ff ff       	call   801022b0 <nameiparent>
80105a80:	83 c4 10             	add    $0x10,%esp
80105a83:	85 c0                	test   %eax,%eax
80105a85:	89 c6                	mov    %eax,%esi
80105a87:	74 5b                	je     80105ae4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	50                   	push   %eax
80105a8d:	e8 9e bf ff ff       	call   80101a30 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a92:	83 c4 10             	add    $0x10,%esp
80105a95:	8b 03                	mov    (%ebx),%eax
80105a97:	39 06                	cmp    %eax,(%esi)
80105a99:	75 3d                	jne    80105ad8 <sys_link+0xe8>
80105a9b:	83 ec 04             	sub    $0x4,%esp
80105a9e:	ff 73 04             	pushl  0x4(%ebx)
80105aa1:	57                   	push   %edi
80105aa2:	56                   	push   %esi
80105aa3:	e8 28 c7 ff ff       	call   801021d0 <dirlink>
80105aa8:	83 c4 10             	add    $0x10,%esp
80105aab:	85 c0                	test   %eax,%eax
80105aad:	78 29                	js     80105ad8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80105aaf:	83 ec 0c             	sub    $0xc,%esp
80105ab2:	56                   	push   %esi
80105ab3:	e8 08 c2 ff ff       	call   80101cc0 <iunlockput>
  iput(ip);
80105ab8:	89 1c 24             	mov    %ebx,(%esp)
80105abb:	e8 a0 c0 ff ff       	call   80101b60 <iput>

  end_op();
80105ac0:	e8 fb da ff ff       	call   801035c0 <end_op>

  return 0;
80105ac5:	83 c4 10             	add    $0x10,%esp
80105ac8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80105aca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105acd:	5b                   	pop    %ebx
80105ace:	5e                   	pop    %esi
80105acf:	5f                   	pop    %edi
80105ad0:	5d                   	pop    %ebp
80105ad1:	c3                   	ret    
80105ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105ad8:	83 ec 0c             	sub    $0xc,%esp
80105adb:	56                   	push   %esi
80105adc:	e8 df c1 ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105ae1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105ae4:	83 ec 0c             	sub    $0xc,%esp
80105ae7:	53                   	push   %ebx
80105ae8:	e8 43 bf ff ff       	call   80101a30 <ilock>
  ip->nlink--;
80105aed:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105af2:	89 1c 24             	mov    %ebx,(%esp)
80105af5:	e8 86 be ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105afa:	89 1c 24             	mov    %ebx,(%esp)
80105afd:	e8 be c1 ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105b02:	e8 b9 da ff ff       	call   801035c0 <end_op>
  return -1;
80105b07:	83 c4 10             	add    $0x10,%esp
}
80105b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80105b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b12:	5b                   	pop    %ebx
80105b13:	5e                   	pop    %esi
80105b14:	5f                   	pop    %edi
80105b15:	5d                   	pop    %ebp
80105b16:	c3                   	ret    
    iunlockput(ip);
80105b17:	83 ec 0c             	sub    $0xc,%esp
80105b1a:	53                   	push   %ebx
80105b1b:	e8 a0 c1 ff ff       	call   80101cc0 <iunlockput>
    end_op();
80105b20:	e8 9b da ff ff       	call   801035c0 <end_op>
    return -1;
80105b25:	83 c4 10             	add    $0x10,%esp
80105b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b2d:	eb 9b                	jmp    80105aca <sys_link+0xda>
    end_op();
80105b2f:	e8 8c da ff ff       	call   801035c0 <end_op>
    return -1;
80105b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b39:	eb 8f                	jmp    80105aca <sys_link+0xda>
80105b3b:	90                   	nop
80105b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b40 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
80105b46:	83 ec 1c             	sub    $0x1c,%esp
80105b49:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b4c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105b50:	76 3e                	jbe    80105b90 <isdirempty+0x50>
80105b52:	bb 20 00 00 00       	mov    $0x20,%ebx
80105b57:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b5a:	eb 0c                	jmp    80105b68 <isdirempty+0x28>
80105b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b60:	83 c3 10             	add    $0x10,%ebx
80105b63:	3b 5e 58             	cmp    0x58(%esi),%ebx
80105b66:	73 28                	jae    80105b90 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b68:	6a 10                	push   $0x10
80105b6a:	53                   	push   %ebx
80105b6b:	57                   	push   %edi
80105b6c:	56                   	push   %esi
80105b6d:	e8 9e c1 ff ff       	call   80101d10 <readi>
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	83 f8 10             	cmp    $0x10,%eax
80105b78:	75 23                	jne    80105b9d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
80105b7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105b7f:	74 df                	je     80105b60 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
80105b81:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80105b84:	31 c0                	xor    %eax,%eax
}
80105b86:	5b                   	pop    %ebx
80105b87:	5e                   	pop    %esi
80105b88:	5f                   	pop    %edi
80105b89:	5d                   	pop    %ebp
80105b8a:	c3                   	ret    
80105b8b:	90                   	nop
80105b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105b93:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b98:	5b                   	pop    %ebx
80105b99:	5e                   	pop    %esi
80105b9a:	5f                   	pop    %edi
80105b9b:	5d                   	pop    %ebp
80105b9c:	c3                   	ret    
      panic("isdirempty: readi");
80105b9d:	83 ec 0c             	sub    $0xc,%esp
80105ba0:	68 60 99 10 80       	push   $0x80109960
80105ba5:	e8 e6 a7 ff ff       	call   80100390 <panic>
80105baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bb0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	57                   	push   %edi
80105bb4:	56                   	push   %esi
80105bb5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105bb6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105bb9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80105bbc:	50                   	push   %eax
80105bbd:	6a 00                	push   $0x0
80105bbf:	e8 4c fb ff ff       	call   80105710 <argstr>
80105bc4:	83 c4 10             	add    $0x10,%esp
80105bc7:	85 c0                	test   %eax,%eax
80105bc9:	0f 88 51 01 00 00    	js     80105d20 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80105bcf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105bd2:	e8 79 d9 ff ff       	call   80103550 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105bd7:	83 ec 08             	sub    $0x8,%esp
80105bda:	53                   	push   %ebx
80105bdb:	ff 75 c0             	pushl  -0x40(%ebp)
80105bde:	e8 cd c6 ff ff       	call   801022b0 <nameiparent>
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	89 c6                	mov    %eax,%esi
80105bea:	0f 84 37 01 00 00    	je     80105d27 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105bf0:	83 ec 0c             	sub    $0xc,%esp
80105bf3:	50                   	push   %eax
80105bf4:	e8 37 be ff ff       	call   80101a30 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bf9:	58                   	pop    %eax
80105bfa:	5a                   	pop    %edx
80105bfb:	68 4b 92 10 80       	push   $0x8010924b
80105c00:	53                   	push   %ebx
80105c01:	e8 3a c3 ff ff       	call   80101f40 <namecmp>
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	0f 84 d7 00 00 00    	je     80105ce8 <sys_unlink+0x138>
80105c11:	83 ec 08             	sub    $0x8,%esp
80105c14:	68 4a 92 10 80       	push   $0x8010924a
80105c19:	53                   	push   %ebx
80105c1a:	e8 21 c3 ff ff       	call   80101f40 <namecmp>
80105c1f:	83 c4 10             	add    $0x10,%esp
80105c22:	85 c0                	test   %eax,%eax
80105c24:	0f 84 be 00 00 00    	je     80105ce8 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c2a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105c2d:	83 ec 04             	sub    $0x4,%esp
80105c30:	50                   	push   %eax
80105c31:	53                   	push   %ebx
80105c32:	56                   	push   %esi
80105c33:	e8 28 c3 ff ff       	call   80101f60 <dirlookup>
80105c38:	83 c4 10             	add    $0x10,%esp
80105c3b:	85 c0                	test   %eax,%eax
80105c3d:	89 c3                	mov    %eax,%ebx
80105c3f:	0f 84 a3 00 00 00    	je     80105ce8 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105c45:	83 ec 0c             	sub    $0xc,%esp
80105c48:	50                   	push   %eax
80105c49:	e8 e2 bd ff ff       	call   80101a30 <ilock>

  if(ip->nlink < 1)
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105c56:	0f 8e e4 00 00 00    	jle    80105d40 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c5c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c61:	74 65                	je     80105cc8 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80105c63:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105c66:	83 ec 04             	sub    $0x4,%esp
80105c69:	6a 10                	push   $0x10
80105c6b:	6a 00                	push   $0x0
80105c6d:	57                   	push   %edi
80105c6e:	e8 ed f6 ff ff       	call   80105360 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c73:	6a 10                	push   $0x10
80105c75:	ff 75 c4             	pushl  -0x3c(%ebp)
80105c78:	57                   	push   %edi
80105c79:	56                   	push   %esi
80105c7a:	e8 91 c1 ff ff       	call   80101e10 <writei>
80105c7f:	83 c4 20             	add    $0x20,%esp
80105c82:	83 f8 10             	cmp    $0x10,%eax
80105c85:	0f 85 a8 00 00 00    	jne    80105d33 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80105c8b:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c90:	74 6e                	je     80105d00 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105c92:	83 ec 0c             	sub    $0xc,%esp
80105c95:	56                   	push   %esi
80105c96:	e8 25 c0 ff ff       	call   80101cc0 <iunlockput>

  ip->nlink--;
80105c9b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105ca0:	89 1c 24             	mov    %ebx,(%esp)
80105ca3:	e8 d8 bc ff ff       	call   80101980 <iupdate>
  iunlockput(ip);
80105ca8:	89 1c 24             	mov    %ebx,(%esp)
80105cab:	e8 10 c0 ff ff       	call   80101cc0 <iunlockput>

  end_op();
80105cb0:	e8 0b d9 ff ff       	call   801035c0 <end_op>

  return 0;
80105cb5:	83 c4 10             	add    $0x10,%esp
80105cb8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80105cba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cbd:	5b                   	pop    %ebx
80105cbe:	5e                   	pop    %esi
80105cbf:	5f                   	pop    %edi
80105cc0:	5d                   	pop    %ebp
80105cc1:	c3                   	ret    
80105cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105cc8:	83 ec 0c             	sub    $0xc,%esp
80105ccb:	53                   	push   %ebx
80105ccc:	e8 6f fe ff ff       	call   80105b40 <isdirempty>
80105cd1:	83 c4 10             	add    $0x10,%esp
80105cd4:	85 c0                	test   %eax,%eax
80105cd6:	75 8b                	jne    80105c63 <sys_unlink+0xb3>
    iunlockput(ip);
80105cd8:	83 ec 0c             	sub    $0xc,%esp
80105cdb:	53                   	push   %ebx
80105cdc:	e8 df bf ff ff       	call   80101cc0 <iunlockput>
    goto bad;
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105ce8:	83 ec 0c             	sub    $0xc,%esp
80105ceb:	56                   	push   %esi
80105cec:	e8 cf bf ff ff       	call   80101cc0 <iunlockput>
  end_op();
80105cf1:	e8 ca d8 ff ff       	call   801035c0 <end_op>
  return -1;
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cfe:	eb ba                	jmp    80105cba <sys_unlink+0x10a>
    dp->nlink--;
80105d00:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105d05:	83 ec 0c             	sub    $0xc,%esp
80105d08:	56                   	push   %esi
80105d09:	e8 72 bc ff ff       	call   80101980 <iupdate>
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	e9 7c ff ff ff       	jmp    80105c92 <sys_unlink+0xe2>
80105d16:	8d 76 00             	lea    0x0(%esi),%esi
80105d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d25:	eb 93                	jmp    80105cba <sys_unlink+0x10a>
    end_op();
80105d27:	e8 94 d8 ff ff       	call   801035c0 <end_op>
    return -1;
80105d2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d31:	eb 87                	jmp    80105cba <sys_unlink+0x10a>
    panic("unlink: writei");
80105d33:	83 ec 0c             	sub    $0xc,%esp
80105d36:	68 5f 92 10 80       	push   $0x8010925f
80105d3b:	e8 50 a6 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105d40:	83 ec 0c             	sub    $0xc,%esp
80105d43:	68 4d 92 10 80       	push   $0x8010924d
80105d48:	e8 43 a6 ff ff       	call   80100390 <panic>
80105d4d:	8d 76 00             	lea    0x0(%esi),%esi

80105d50 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	57                   	push   %edi
80105d54:	56                   	push   %esi
80105d55:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d56:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105d59:	83 ec 34             	sub    $0x34,%esp
80105d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d5f:	8b 55 10             	mov    0x10(%ebp),%edx
80105d62:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105d65:	56                   	push   %esi
80105d66:	ff 75 08             	pushl  0x8(%ebp)
{
80105d69:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80105d6c:	89 55 d0             	mov    %edx,-0x30(%ebp)
80105d6f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80105d72:	e8 39 c5 ff ff       	call   801022b0 <nameiparent>
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	85 c0                	test   %eax,%eax
80105d7c:	0f 84 4e 01 00 00    	je     80105ed0 <create+0x180>
    return 0;
  ilock(dp);
80105d82:	83 ec 0c             	sub    $0xc,%esp
80105d85:	89 c3                	mov    %eax,%ebx
80105d87:	50                   	push   %eax
80105d88:	e8 a3 bc ff ff       	call   80101a30 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105d8d:	83 c4 0c             	add    $0xc,%esp
80105d90:	6a 00                	push   $0x0
80105d92:	56                   	push   %esi
80105d93:	53                   	push   %ebx
80105d94:	e8 c7 c1 ff ff       	call   80101f60 <dirlookup>
80105d99:	83 c4 10             	add    $0x10,%esp
80105d9c:	85 c0                	test   %eax,%eax
80105d9e:	89 c7                	mov    %eax,%edi
80105da0:	74 3e                	je     80105de0 <create+0x90>
    iunlockput(dp);
80105da2:	83 ec 0c             	sub    $0xc,%esp
80105da5:	53                   	push   %ebx
80105da6:	e8 15 bf ff ff       	call   80101cc0 <iunlockput>
    ilock(ip);
80105dab:	89 3c 24             	mov    %edi,(%esp)
80105dae:	e8 7d bc ff ff       	call   80101a30 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105db3:	83 c4 10             	add    $0x10,%esp
80105db6:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105dbb:	0f 85 9f 00 00 00    	jne    80105e60 <create+0x110>
80105dc1:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105dc6:	0f 85 94 00 00 00    	jne    80105e60 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80105dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dcf:	89 f8                	mov    %edi,%eax
80105dd1:	5b                   	pop    %ebx
80105dd2:	5e                   	pop    %esi
80105dd3:	5f                   	pop    %edi
80105dd4:	5d                   	pop    %ebp
80105dd5:	c3                   	ret    
80105dd6:	8d 76 00             	lea    0x0(%esi),%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if((ip = ialloc(dp->dev, type)) == 0)
80105de0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105de4:	83 ec 08             	sub    $0x8,%esp
80105de7:	50                   	push   %eax
80105de8:	ff 33                	pushl  (%ebx)
80105dea:	e8 d1 ba ff ff       	call   801018c0 <ialloc>
80105def:	83 c4 10             	add    $0x10,%esp
80105df2:	85 c0                	test   %eax,%eax
80105df4:	89 c7                	mov    %eax,%edi
80105df6:	0f 84 e8 00 00 00    	je     80105ee4 <create+0x194>
  ilock(ip);
80105dfc:	83 ec 0c             	sub    $0xc,%esp
80105dff:	50                   	push   %eax
80105e00:	e8 2b bc ff ff       	call   80101a30 <ilock>
  ip->major = major;
80105e05:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105e09:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80105e0d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105e11:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105e15:	b8 01 00 00 00       	mov    $0x1,%eax
80105e1a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80105e1e:	89 3c 24             	mov    %edi,(%esp)
80105e21:	e8 5a bb ff ff       	call   80101980 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105e26:	83 c4 10             	add    $0x10,%esp
80105e29:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e2e:	74 50                	je     80105e80 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105e30:	83 ec 04             	sub    $0x4,%esp
80105e33:	ff 77 04             	pushl  0x4(%edi)
80105e36:	56                   	push   %esi
80105e37:	53                   	push   %ebx
80105e38:	e8 93 c3 ff ff       	call   801021d0 <dirlink>
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	85 c0                	test   %eax,%eax
80105e42:	0f 88 8f 00 00 00    	js     80105ed7 <create+0x187>
  iunlockput(dp);
80105e48:	83 ec 0c             	sub    $0xc,%esp
80105e4b:	53                   	push   %ebx
80105e4c:	e8 6f be ff ff       	call   80101cc0 <iunlockput>
  return ip;
80105e51:	83 c4 10             	add    $0x10,%esp
}
80105e54:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e57:	89 f8                	mov    %edi,%eax
80105e59:	5b                   	pop    %ebx
80105e5a:	5e                   	pop    %esi
80105e5b:	5f                   	pop    %edi
80105e5c:	5d                   	pop    %ebp
80105e5d:	c3                   	ret    
80105e5e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105e60:	83 ec 0c             	sub    $0xc,%esp
80105e63:	57                   	push   %edi
    return 0;
80105e64:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105e66:	e8 55 be ff ff       	call   80101cc0 <iunlockput>
    return 0;
80105e6b:	83 c4 10             	add    $0x10,%esp
}
80105e6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e71:	89 f8                	mov    %edi,%eax
80105e73:	5b                   	pop    %ebx
80105e74:	5e                   	pop    %esi
80105e75:	5f                   	pop    %edi
80105e76:	5d                   	pop    %ebp
80105e77:	c3                   	ret    
80105e78:	90                   	nop
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105e80:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105e85:	83 ec 0c             	sub    $0xc,%esp
80105e88:	53                   	push   %ebx
80105e89:	e8 f2 ba ff ff       	call   80101980 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e8e:	83 c4 0c             	add    $0xc,%esp
80105e91:	ff 77 04             	pushl  0x4(%edi)
80105e94:	68 4b 92 10 80       	push   $0x8010924b
80105e99:	57                   	push   %edi
80105e9a:	e8 31 c3 ff ff       	call   801021d0 <dirlink>
80105e9f:	83 c4 10             	add    $0x10,%esp
80105ea2:	85 c0                	test   %eax,%eax
80105ea4:	78 1c                	js     80105ec2 <create+0x172>
80105ea6:	83 ec 04             	sub    $0x4,%esp
80105ea9:	ff 73 04             	pushl  0x4(%ebx)
80105eac:	68 4a 92 10 80       	push   $0x8010924a
80105eb1:	57                   	push   %edi
80105eb2:	e8 19 c3 ff ff       	call   801021d0 <dirlink>
80105eb7:	83 c4 10             	add    $0x10,%esp
80105eba:	85 c0                	test   %eax,%eax
80105ebc:	0f 89 6e ff ff ff    	jns    80105e30 <create+0xe0>
      panic("create dots");
80105ec2:	83 ec 0c             	sub    $0xc,%esp
80105ec5:	68 81 99 10 80       	push   $0x80109981
80105eca:	e8 c1 a4 ff ff       	call   80100390 <panic>
80105ecf:	90                   	nop
    return 0;
80105ed0:	31 ff                	xor    %edi,%edi
80105ed2:	e9 f5 fe ff ff       	jmp    80105dcc <create+0x7c>
    panic("create: dirlink");
80105ed7:	83 ec 0c             	sub    $0xc,%esp
80105eda:	68 8d 99 10 80       	push   $0x8010998d
80105edf:	e8 ac a4 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105ee4:	83 ec 0c             	sub    $0xc,%esp
80105ee7:	68 72 99 10 80       	push   $0x80109972
80105eec:	e8 9f a4 ff ff       	call   80100390 <panic>
80105ef1:	eb 0d                	jmp    80105f00 <sys_open>
80105ef3:	90                   	nop
80105ef4:	90                   	nop
80105ef5:	90                   	nop
80105ef6:	90                   	nop
80105ef7:	90                   	nop
80105ef8:	90                   	nop
80105ef9:	90                   	nop
80105efa:	90                   	nop
80105efb:	90                   	nop
80105efc:	90                   	nop
80105efd:	90                   	nop
80105efe:	90                   	nop
80105eff:	90                   	nop

80105f00 <sys_open>:

int
sys_open(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	57                   	push   %edi
80105f04:	56                   	push   %esi
80105f05:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f06:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105f09:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f0c:	50                   	push   %eax
80105f0d:	6a 00                	push   $0x0
80105f0f:	e8 fc f7 ff ff       	call   80105710 <argstr>
80105f14:	83 c4 10             	add    $0x10,%esp
80105f17:	85 c0                	test   %eax,%eax
80105f19:	0f 88 1d 01 00 00    	js     8010603c <sys_open+0x13c>
80105f1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f22:	83 ec 08             	sub    $0x8,%esp
80105f25:	50                   	push   %eax
80105f26:	6a 01                	push   $0x1
80105f28:	e8 33 f7 ff ff       	call   80105660 <argint>
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	85 c0                	test   %eax,%eax
80105f32:	0f 88 04 01 00 00    	js     8010603c <sys_open+0x13c>
    return -1;

  begin_op();
80105f38:	e8 13 d6 ff ff       	call   80103550 <begin_op>

  if(omode & O_CREATE){
80105f3d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105f41:	0f 85 a9 00 00 00    	jne    80105ff0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105f47:	83 ec 0c             	sub    $0xc,%esp
80105f4a:	ff 75 e0             	pushl  -0x20(%ebp)
80105f4d:	e8 3e c3 ff ff       	call   80102290 <namei>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	89 c6                	mov    %eax,%esi
80105f59:	0f 84 ac 00 00 00    	je     8010600b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
80105f5f:	83 ec 0c             	sub    $0xc,%esp
80105f62:	50                   	push   %eax
80105f63:	e8 c8 ba ff ff       	call   80101a30 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105f68:	83 c4 10             	add    $0x10,%esp
80105f6b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105f70:	0f 84 aa 00 00 00    	je     80106020 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105f76:	e8 b5 b1 ff ff       	call   80101130 <filealloc>
80105f7b:	85 c0                	test   %eax,%eax
80105f7d:	89 c7                	mov    %eax,%edi
80105f7f:	0f 84 a6 00 00 00    	je     8010602b <sys_open+0x12b>
  struct proc *curproc = myproc();
80105f85:	e8 36 e3 ff ff       	call   801042c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f8a:	31 db                	xor    %ebx,%ebx
80105f8c:	eb 0e                	jmp    80105f9c <sys_open+0x9c>
80105f8e:	66 90                	xchg   %ax,%ax
80105f90:	83 c3 01             	add    $0x1,%ebx
80105f93:	83 fb 10             	cmp    $0x10,%ebx
80105f96:	0f 84 ac 00 00 00    	je     80106048 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
80105f9c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105fa0:	85 d2                	test   %edx,%edx
80105fa2:	75 ec                	jne    80105f90 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105fa4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105fa7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105fab:	56                   	push   %esi
80105fac:	e8 5f bb ff ff       	call   80101b10 <iunlock>
  end_op();
80105fb1:	e8 0a d6 ff ff       	call   801035c0 <end_op>

  f->type = FD_INODE;
80105fb6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105fbc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fbf:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105fc2:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105fc5:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105fcc:	89 d0                	mov    %edx,%eax
80105fce:	f7 d0                	not    %eax
80105fd0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fd3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105fd6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105fd9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105fe0:	89 d8                	mov    %ebx,%eax
80105fe2:	5b                   	pop    %ebx
80105fe3:	5e                   	pop    %esi
80105fe4:	5f                   	pop    %edi
80105fe5:	5d                   	pop    %ebp
80105fe6:	c3                   	ret    
80105fe7:	89 f6                	mov    %esi,%esi
80105fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105ff0:	6a 00                	push   $0x0
80105ff2:	6a 00                	push   $0x0
80105ff4:	6a 02                	push   $0x2
80105ff6:	ff 75 e0             	pushl  -0x20(%ebp)
80105ff9:	e8 52 fd ff ff       	call   80105d50 <create>
    if(ip == 0){
80105ffe:	83 c4 10             	add    $0x10,%esp
80106001:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80106003:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80106005:	0f 85 6b ff ff ff    	jne    80105f76 <sys_open+0x76>
      end_op();
8010600b:	e8 b0 d5 ff ff       	call   801035c0 <end_op>
      return -1;
80106010:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106015:	eb c6                	jmp    80105fdd <sys_open+0xdd>
80106017:	89 f6                	mov    %esi,%esi
80106019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80106020:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106023:	85 c9                	test   %ecx,%ecx
80106025:	0f 84 4b ff ff ff    	je     80105f76 <sys_open+0x76>
    iunlockput(ip);
8010602b:	83 ec 0c             	sub    $0xc,%esp
8010602e:	56                   	push   %esi
8010602f:	e8 8c bc ff ff       	call   80101cc0 <iunlockput>
    end_op();
80106034:	e8 87 d5 ff ff       	call   801035c0 <end_op>
    return -1;
80106039:	83 c4 10             	add    $0x10,%esp
8010603c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106041:	eb 9a                	jmp    80105fdd <sys_open+0xdd>
80106043:	90                   	nop
80106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80106048:	83 ec 0c             	sub    $0xc,%esp
8010604b:	57                   	push   %edi
8010604c:	e8 9f b1 ff ff       	call   801011f0 <fileclose>
80106051:	83 c4 10             	add    $0x10,%esp
80106054:	eb d5                	jmp    8010602b <sys_open+0x12b>
80106056:	8d 76 00             	lea    0x0(%esi),%esi
80106059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106060 <sys_mkdir>:

int
sys_mkdir(void)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106066:	e8 e5 d4 ff ff       	call   80103550 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010606b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010606e:	83 ec 08             	sub    $0x8,%esp
80106071:	50                   	push   %eax
80106072:	6a 00                	push   $0x0
80106074:	e8 97 f6 ff ff       	call   80105710 <argstr>
80106079:	83 c4 10             	add    $0x10,%esp
8010607c:	85 c0                	test   %eax,%eax
8010607e:	78 30                	js     801060b0 <sys_mkdir+0x50>
80106080:	6a 00                	push   $0x0
80106082:	6a 00                	push   $0x0
80106084:	6a 01                	push   $0x1
80106086:	ff 75 f4             	pushl  -0xc(%ebp)
80106089:	e8 c2 fc ff ff       	call   80105d50 <create>
8010608e:	83 c4 10             	add    $0x10,%esp
80106091:	85 c0                	test   %eax,%eax
80106093:	74 1b                	je     801060b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106095:	83 ec 0c             	sub    $0xc,%esp
80106098:	50                   	push   %eax
80106099:	e8 22 bc ff ff       	call   80101cc0 <iunlockput>
  end_op();
8010609e:	e8 1d d5 ff ff       	call   801035c0 <end_op>
  return 0;
801060a3:	83 c4 10             	add    $0x10,%esp
801060a6:	31 c0                	xor    %eax,%eax
}
801060a8:	c9                   	leave  
801060a9:	c3                   	ret    
801060aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801060b0:	e8 0b d5 ff ff       	call   801035c0 <end_op>
    return -1;
801060b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060ba:	c9                   	leave  
801060bb:	c3                   	ret    
801060bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060c0 <sys_mknod>:

int
sys_mknod(void)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801060c6:	e8 85 d4 ff ff       	call   80103550 <begin_op>
  if((argstr(0, &path)) < 0 ||
801060cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060ce:	83 ec 08             	sub    $0x8,%esp
801060d1:	50                   	push   %eax
801060d2:	6a 00                	push   $0x0
801060d4:	e8 37 f6 ff ff       	call   80105710 <argstr>
801060d9:	83 c4 10             	add    $0x10,%esp
801060dc:	85 c0                	test   %eax,%eax
801060de:	78 60                	js     80106140 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801060e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060e3:	83 ec 08             	sub    $0x8,%esp
801060e6:	50                   	push   %eax
801060e7:	6a 01                	push   $0x1
801060e9:	e8 72 f5 ff ff       	call   80105660 <argint>
  if((argstr(0, &path)) < 0 ||
801060ee:	83 c4 10             	add    $0x10,%esp
801060f1:	85 c0                	test   %eax,%eax
801060f3:	78 4b                	js     80106140 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801060f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060f8:	83 ec 08             	sub    $0x8,%esp
801060fb:	50                   	push   %eax
801060fc:	6a 02                	push   $0x2
801060fe:	e8 5d f5 ff ff       	call   80105660 <argint>
     argint(1, &major) < 0 ||
80106103:	83 c4 10             	add    $0x10,%esp
80106106:	85 c0                	test   %eax,%eax
80106108:	78 36                	js     80106140 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010610a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010610e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010610f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106113:	50                   	push   %eax
80106114:	6a 03                	push   $0x3
80106116:	ff 75 ec             	pushl  -0x14(%ebp)
80106119:	e8 32 fc ff ff       	call   80105d50 <create>
8010611e:	83 c4 10             	add    $0x10,%esp
80106121:	85 c0                	test   %eax,%eax
80106123:	74 1b                	je     80106140 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80106125:	83 ec 0c             	sub    $0xc,%esp
80106128:	50                   	push   %eax
80106129:	e8 92 bb ff ff       	call   80101cc0 <iunlockput>
  end_op();
8010612e:	e8 8d d4 ff ff       	call   801035c0 <end_op>
  return 0;
80106133:	83 c4 10             	add    $0x10,%esp
80106136:	31 c0                	xor    %eax,%eax
}
80106138:	c9                   	leave  
80106139:	c3                   	ret    
8010613a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80106140:	e8 7b d4 ff ff       	call   801035c0 <end_op>
    return -1;
80106145:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010614a:	c9                   	leave  
8010614b:	c3                   	ret    
8010614c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_chdir>:

int
sys_chdir(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	56                   	push   %esi
80106154:	53                   	push   %ebx
80106155:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80106158:	e8 63 e1 ff ff       	call   801042c0 <myproc>
8010615d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010615f:	e8 ec d3 ff ff       	call   80103550 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106164:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106167:	83 ec 08             	sub    $0x8,%esp
8010616a:	50                   	push   %eax
8010616b:	6a 00                	push   $0x0
8010616d:	e8 9e f5 ff ff       	call   80105710 <argstr>
80106172:	83 c4 10             	add    $0x10,%esp
80106175:	85 c0                	test   %eax,%eax
80106177:	78 77                	js     801061f0 <sys_chdir+0xa0>
80106179:	83 ec 0c             	sub    $0xc,%esp
8010617c:	ff 75 f4             	pushl  -0xc(%ebp)
8010617f:	e8 0c c1 ff ff       	call   80102290 <namei>
80106184:	83 c4 10             	add    $0x10,%esp
80106187:	85 c0                	test   %eax,%eax
80106189:	89 c3                	mov    %eax,%ebx
8010618b:	74 63                	je     801061f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010618d:	83 ec 0c             	sub    $0xc,%esp
80106190:	50                   	push   %eax
80106191:	e8 9a b8 ff ff       	call   80101a30 <ilock>
  if(ip->type != T_DIR){
80106196:	83 c4 10             	add    $0x10,%esp
80106199:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010619e:	75 30                	jne    801061d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801061a0:	83 ec 0c             	sub    $0xc,%esp
801061a3:	53                   	push   %ebx
801061a4:	e8 67 b9 ff ff       	call   80101b10 <iunlock>
  iput(curproc->cwd);
801061a9:	58                   	pop    %eax
801061aa:	ff 76 68             	pushl  0x68(%esi)
801061ad:	e8 ae b9 ff ff       	call   80101b60 <iput>
  end_op();
801061b2:	e8 09 d4 ff ff       	call   801035c0 <end_op>
  curproc->cwd = ip;
801061b7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801061ba:	83 c4 10             	add    $0x10,%esp
801061bd:	31 c0                	xor    %eax,%eax
}
801061bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801061c2:	5b                   	pop    %ebx
801061c3:	5e                   	pop    %esi
801061c4:	5d                   	pop    %ebp
801061c5:	c3                   	ret    
801061c6:	8d 76 00             	lea    0x0(%esi),%esi
801061c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801061d0:	83 ec 0c             	sub    $0xc,%esp
801061d3:	53                   	push   %ebx
801061d4:	e8 e7 ba ff ff       	call   80101cc0 <iunlockput>
    end_op();
801061d9:	e8 e2 d3 ff ff       	call   801035c0 <end_op>
    return -1;
801061de:	83 c4 10             	add    $0x10,%esp
801061e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061e6:	eb d7                	jmp    801061bf <sys_chdir+0x6f>
801061e8:	90                   	nop
801061e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801061f0:	e8 cb d3 ff ff       	call   801035c0 <end_op>
    return -1;
801061f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061fa:	eb c3                	jmp    801061bf <sys_chdir+0x6f>
801061fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106200 <sys_exec>:

int
sys_exec(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	57                   	push   %edi
80106204:	56                   	push   %esi
80106205:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106206:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010620c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106212:	50                   	push   %eax
80106213:	6a 00                	push   $0x0
80106215:	e8 f6 f4 ff ff       	call   80105710 <argstr>
8010621a:	83 c4 10             	add    $0x10,%esp
8010621d:	85 c0                	test   %eax,%eax
8010621f:	0f 88 87 00 00 00    	js     801062ac <sys_exec+0xac>
80106225:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010622b:	83 ec 08             	sub    $0x8,%esp
8010622e:	50                   	push   %eax
8010622f:	6a 01                	push   $0x1
80106231:	e8 2a f4 ff ff       	call   80105660 <argint>
80106236:	83 c4 10             	add    $0x10,%esp
80106239:	85 c0                	test   %eax,%eax
8010623b:	78 6f                	js     801062ac <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010623d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106243:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80106246:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80106248:	68 80 00 00 00       	push   $0x80
8010624d:	6a 00                	push   $0x0
8010624f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80106255:	50                   	push   %eax
80106256:	e8 05 f1 ff ff       	call   80105360 <memset>
8010625b:	83 c4 10             	add    $0x10,%esp
8010625e:	eb 2c                	jmp    8010628c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80106260:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80106266:	85 c0                	test   %eax,%eax
80106268:	74 56                	je     801062c0 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010626a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80106270:	83 ec 08             	sub    $0x8,%esp
80106273:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80106276:	52                   	push   %edx
80106277:	50                   	push   %eax
80106278:	e8 73 f3 ff ff       	call   801055f0 <fetchstr>
8010627d:	83 c4 10             	add    $0x10,%esp
80106280:	85 c0                	test   %eax,%eax
80106282:	78 28                	js     801062ac <sys_exec+0xac>
  for(i=0;; i++){
80106284:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80106287:	83 fb 20             	cmp    $0x20,%ebx
8010628a:	74 20                	je     801062ac <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010628c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80106292:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80106299:	83 ec 08             	sub    $0x8,%esp
8010629c:	57                   	push   %edi
8010629d:	01 f0                	add    %esi,%eax
8010629f:	50                   	push   %eax
801062a0:	e8 0b f3 ff ff       	call   801055b0 <fetchint>
801062a5:	83 c4 10             	add    $0x10,%esp
801062a8:	85 c0                	test   %eax,%eax
801062aa:	79 b4                	jns    80106260 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801062ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801062af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062b4:	5b                   	pop    %ebx
801062b5:	5e                   	pop    %esi
801062b6:	5f                   	pop    %edi
801062b7:	5d                   	pop    %ebp
801062b8:	c3                   	ret    
801062b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801062c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801062c6:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
801062c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801062d0:	00 00 00 00 
  return exec(path, argv);
801062d4:	50                   	push   %eax
801062d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801062db:	e8 80 a9 ff ff       	call   80100c60 <exec>
801062e0:	83 c4 10             	add    $0x10,%esp
}
801062e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e6:	5b                   	pop    %ebx
801062e7:	5e                   	pop    %esi
801062e8:	5f                   	pop    %edi
801062e9:	5d                   	pop    %ebp
801062ea:	c3                   	ret    
801062eb:	90                   	nop
801062ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801062f0 <sys_pipe>:

int
sys_pipe(void)
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	57                   	push   %edi
801062f4:	56                   	push   %esi
801062f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801062f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801062fc:	6a 08                	push   $0x8
801062fe:	50                   	push   %eax
801062ff:	6a 00                	push   $0x0
80106301:	e8 aa f3 ff ff       	call   801056b0 <argptr>
80106306:	83 c4 10             	add    $0x10,%esp
80106309:	85 c0                	test   %eax,%eax
8010630b:	0f 88 ae 00 00 00    	js     801063bf <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106311:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106314:	83 ec 08             	sub    $0x8,%esp
80106317:	50                   	push   %eax
80106318:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010631b:	50                   	push   %eax
8010631c:	e8 cf d8 ff ff       	call   80103bf0 <pipealloc>
80106321:	83 c4 10             	add    $0x10,%esp
80106324:	85 c0                	test   %eax,%eax
80106326:	0f 88 93 00 00 00    	js     801063bf <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010632c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010632f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80106331:	e8 8a df ff ff       	call   801042c0 <myproc>
80106336:	eb 10                	jmp    80106348 <sys_pipe+0x58>
80106338:	90                   	nop
80106339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80106340:	83 c3 01             	add    $0x1,%ebx
80106343:	83 fb 10             	cmp    $0x10,%ebx
80106346:	74 60                	je     801063a8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80106348:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010634c:	85 f6                	test   %esi,%esi
8010634e:	75 f0                	jne    80106340 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80106350:	8d 73 08             	lea    0x8(%ebx),%esi
80106353:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106357:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010635a:	e8 61 df ff ff       	call   801042c0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010635f:	31 d2                	xor    %edx,%edx
80106361:	eb 0d                	jmp    80106370 <sys_pipe+0x80>
80106363:	90                   	nop
80106364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106368:	83 c2 01             	add    $0x1,%edx
8010636b:	83 fa 10             	cmp    $0x10,%edx
8010636e:	74 28                	je     80106398 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80106370:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80106374:	85 c9                	test   %ecx,%ecx
80106376:	75 f0                	jne    80106368 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80106378:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010637c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010637f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106381:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106384:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80106387:	31 c0                	xor    %eax,%eax
}
80106389:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010638c:	5b                   	pop    %ebx
8010638d:	5e                   	pop    %esi
8010638e:	5f                   	pop    %edi
8010638f:	5d                   	pop    %ebp
80106390:	c3                   	ret    
80106391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80106398:	e8 23 df ff ff       	call   801042c0 <myproc>
8010639d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801063a4:	00 
801063a5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
801063a8:	83 ec 0c             	sub    $0xc,%esp
801063ab:	ff 75 e0             	pushl  -0x20(%ebp)
801063ae:	e8 3d ae ff ff       	call   801011f0 <fileclose>
    fileclose(wf);
801063b3:	58                   	pop    %eax
801063b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801063b7:	e8 34 ae ff ff       	call   801011f0 <fileclose>
    return -1;
801063bc:	83 c4 10             	add    $0x10,%esp
801063bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c4:	eb c3                	jmp    80106389 <sys_pipe+0x99>
801063c6:	66 90                	xchg   %ax,%ax
801063c8:	66 90                	xchg   %ax,%ax
801063ca:	66 90                	xchg   %ax,%ax
801063cc:	66 90                	xchg   %ax,%ax
801063ce:	66 90                	xchg   %ax,%ax

801063d0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801063d3:	5d                   	pop    %ebp
  return fork();
801063d4:	e9 37 e1 ff ff       	jmp    80104510 <fork>
801063d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063e0 <sys_exit>:

int
sys_exit(void)
{
801063e0:	55                   	push   %ebp
801063e1:	89 e5                	mov    %esp,%ebp
801063e3:	83 ec 08             	sub    $0x8,%esp
  exit();
801063e6:	e8 65 e5 ff ff       	call   80104950 <exit>
  return 0;  // not reached
}
801063eb:	31 c0                	xor    %eax,%eax
801063ed:	c9                   	leave  
801063ee:	c3                   	ret    
801063ef:	90                   	nop

801063f0 <sys_wait>:

int
sys_wait(void)
{
801063f0:	55                   	push   %ebp
801063f1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801063f3:	5d                   	pop    %ebp
  return wait();
801063f4:	e9 c7 e7 ff ff       	jmp    80104bc0 <wait>
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106400 <sys_kill>:

int
sys_kill(void)
{
80106400:	55                   	push   %ebp
80106401:	89 e5                	mov    %esp,%ebp
80106403:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106406:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106409:	50                   	push   %eax
8010640a:	6a 00                	push   $0x0
8010640c:	e8 4f f2 ff ff       	call   80105660 <argint>
80106411:	83 c4 10             	add    $0x10,%esp
80106414:	85 c0                	test   %eax,%eax
80106416:	78 18                	js     80106430 <sys_kill+0x30>
    return -1;
  return kill(pid);
80106418:	83 ec 0c             	sub    $0xc,%esp
8010641b:	ff 75 f4             	pushl  -0xc(%ebp)
8010641e:	e8 7d e9 ff ff       	call   80104da0 <kill>
80106423:	83 c4 10             	add    $0x10,%esp
}
80106426:	c9                   	leave  
80106427:	c3                   	ret    
80106428:	90                   	nop
80106429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106435:	c9                   	leave  
80106436:	c3                   	ret    
80106437:	89 f6                	mov    %esi,%esi
80106439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106440 <sys_getpid>:

int
sys_getpid(void)
{
80106440:	55                   	push   %ebp
80106441:	89 e5                	mov    %esp,%ebp
80106443:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106446:	e8 75 de ff ff       	call   801042c0 <myproc>
8010644b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010644e:	c9                   	leave  
8010644f:	c3                   	ret    

80106450 <sys_sbrk>:

int
sys_sbrk(void)
{
80106450:	55                   	push   %ebp
80106451:	89 e5                	mov    %esp,%ebp
80106453:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106454:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80106457:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010645a:	50                   	push   %eax
8010645b:	6a 00                	push   $0x0
8010645d:	e8 fe f1 ff ff       	call   80105660 <argint>
80106462:	83 c4 10             	add    $0x10,%esp
80106465:	85 c0                	test   %eax,%eax
80106467:	78 27                	js     80106490 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80106469:	e8 52 de ff ff       	call   801042c0 <myproc>
  if(growproc(n) < 0)
8010646e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106471:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106473:	ff 75 f4             	pushl  -0xc(%ebp)
80106476:	e8 65 df ff ff       	call   801043e0 <growproc>
8010647b:	83 c4 10             	add    $0x10,%esp
8010647e:	85 c0                	test   %eax,%eax
80106480:	78 0e                	js     80106490 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106482:	89 d8                	mov    %ebx,%eax
80106484:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106487:	c9                   	leave  
80106488:	c3                   	ret    
80106489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106490:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106495:	eb eb                	jmp    80106482 <sys_sbrk+0x32>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801064a0 <sys_sleep>:

int
sys_sleep(void)
{
801064a0:	55                   	push   %ebp
801064a1:	89 e5                	mov    %esp,%ebp
801064a3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801064a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801064a7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801064aa:	50                   	push   %eax
801064ab:	6a 00                	push   $0x0
801064ad:	e8 ae f1 ff ff       	call   80105660 <argint>
801064b2:	83 c4 10             	add    $0x10,%esp
801064b5:	85 c0                	test   %eax,%eax
801064b7:	0f 88 8a 00 00 00    	js     80106547 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801064bd:	83 ec 0c             	sub    $0xc,%esp
801064c0:	68 40 6d 19 80       	push   $0x80196d40
801064c5:	e8 86 ed ff ff       	call   80105250 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801064ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064cd:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801064d0:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  while(ticks - ticks0 < n){
801064d6:	85 d2                	test   %edx,%edx
801064d8:	75 27                	jne    80106501 <sys_sleep+0x61>
801064da:	eb 54                	jmp    80106530 <sys_sleep+0x90>
801064dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801064e0:	83 ec 08             	sub    $0x8,%esp
801064e3:	68 40 6d 19 80       	push   $0x80196d40
801064e8:	68 80 75 19 80       	push   $0x80197580
801064ed:	e8 0e e6 ff ff       	call   80104b00 <sleep>
  while(ticks - ticks0 < n){
801064f2:	a1 80 75 19 80       	mov    0x80197580,%eax
801064f7:	83 c4 10             	add    $0x10,%esp
801064fa:	29 d8                	sub    %ebx,%eax
801064fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801064ff:	73 2f                	jae    80106530 <sys_sleep+0x90>
    if(myproc()->killed){
80106501:	e8 ba dd ff ff       	call   801042c0 <myproc>
80106506:	8b 40 24             	mov    0x24(%eax),%eax
80106509:	85 c0                	test   %eax,%eax
8010650b:	74 d3                	je     801064e0 <sys_sleep+0x40>
      release(&tickslock);
8010650d:	83 ec 0c             	sub    $0xc,%esp
80106510:	68 40 6d 19 80       	push   $0x80196d40
80106515:	e8 f6 ed ff ff       	call   80105310 <release>
      return -1;
8010651a:	83 c4 10             	add    $0x10,%esp
8010651d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80106522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106525:	c9                   	leave  
80106526:	c3                   	ret    
80106527:	89 f6                	mov    %esi,%esi
80106529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80106530:	83 ec 0c             	sub    $0xc,%esp
80106533:	68 40 6d 19 80       	push   $0x80196d40
80106538:	e8 d3 ed ff ff       	call   80105310 <release>
  return 0;
8010653d:	83 c4 10             	add    $0x10,%esp
80106540:	31 c0                	xor    %eax,%eax
}
80106542:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106545:	c9                   	leave  
80106546:	c3                   	ret    
    return -1;
80106547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010654c:	eb f4                	jmp    80106542 <sys_sleep+0xa2>
8010654e:	66 90                	xchg   %ax,%ax

80106550 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106550:	55                   	push   %ebp
80106551:	89 e5                	mov    %esp,%ebp
80106553:	53                   	push   %ebx
80106554:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106557:	68 40 6d 19 80       	push   $0x80196d40
8010655c:	e8 ef ec ff ff       	call   80105250 <acquire>
  xticks = ticks;
80106561:	8b 1d 80 75 19 80    	mov    0x80197580,%ebx
  release(&tickslock);
80106567:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
8010656e:	e8 9d ed ff ff       	call   80105310 <release>
  return xticks;
}
80106573:	89 d8                	mov    %ebx,%eax
80106575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106578:	c9                   	leave  
80106579:	c3                   	ret    
8010657a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106580 <sys_getNumberOfFreePages>:

int
sys_getNumberOfFreePages(void)
{
80106580:	55                   	push   %ebp
80106581:	89 e5                	mov    %esp,%ebp
80106583:	83 ec 08             	sub    $0x8,%esp
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106586:	e8 35 dd ff ff       	call   801042c0 <myproc>
8010658b:	ba 10 00 00 00       	mov    $0x10,%edx
80106590:	2b 90 80 00 00 00    	sub    0x80(%eax),%edx
}
80106596:	c9                   	leave  
  return MAX_PSYC_PAGES - myproc()->nummemorypages;
80106597:	89 d0                	mov    %edx,%eax
}
80106599:	c3                   	ret    
8010659a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065a0 <sys_getTotalFreePages>:

int
sys_getTotalFreePages(void)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
  return getTotalFreePages();
801065a3:	5d                   	pop    %ebp
  return getTotalFreePages();
801065a4:	e9 d7 e8 ff ff       	jmp    80104e80 <getTotalFreePages>

801065a9 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801065a9:	1e                   	push   %ds
  pushl %es
801065aa:	06                   	push   %es
  pushl %fs
801065ab:	0f a0                	push   %fs
  pushl %gs
801065ad:	0f a8                	push   %gs
  pushal
801065af:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801065b0:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801065b4:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801065b6:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801065b8:	54                   	push   %esp
  call trap
801065b9:	e8 c2 00 00 00       	call   80106680 <trap>
  addl $4, %esp
801065be:	83 c4 04             	add    $0x4,%esp

801065c1 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801065c1:	61                   	popa   
  popl %gs
801065c2:	0f a9                	pop    %gs
  popl %fs
801065c4:	0f a1                	pop    %fs
  popl %es
801065c6:	07                   	pop    %es
  popl %ds
801065c7:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801065c8:	83 c4 08             	add    $0x8,%esp
  iret
801065cb:	cf                   	iret   
801065cc:	66 90                	xchg   %ax,%ax
801065ce:	66 90                	xchg   %ax,%ax

801065d0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
801065d0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
801065d1:	31 c0                	xor    %eax,%eax
{
801065d3:	89 e5                	mov    %esp,%ebp
801065d5:	83 ec 08             	sub    $0x8,%esp
801065d8:	90                   	nop
801065d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801065e0:	8b 14 85 08 c0 10 80 	mov    -0x7fef3ff8(,%eax,4),%edx
801065e7:	c7 04 c5 82 6d 19 80 	movl   $0x8e000008,-0x7fe6927e(,%eax,8)
801065ee:	08 00 00 8e 
801065f2:	66 89 14 c5 80 6d 19 	mov    %dx,-0x7fe69280(,%eax,8)
801065f9:	80 
801065fa:	c1 ea 10             	shr    $0x10,%edx
801065fd:	66 89 14 c5 86 6d 19 	mov    %dx,-0x7fe6927a(,%eax,8)
80106604:	80 
  for(i = 0; i < 256; i++)
80106605:	83 c0 01             	add    $0x1,%eax
80106608:	3d 00 01 00 00       	cmp    $0x100,%eax
8010660d:	75 d1                	jne    801065e0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010660f:	a1 08 c1 10 80       	mov    0x8010c108,%eax

  initlock(&tickslock, "time");
80106614:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106617:	c7 05 82 6f 19 80 08 	movl   $0xef000008,0x80196f82
8010661e:	00 00 ef 
  initlock(&tickslock, "time");
80106621:	68 9d 99 10 80       	push   $0x8010999d
80106626:	68 40 6d 19 80       	push   $0x80196d40
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010662b:	66 a3 80 6f 19 80    	mov    %ax,0x80196f80
80106631:	c1 e8 10             	shr    $0x10,%eax
80106634:	66 a3 86 6f 19 80    	mov    %ax,0x80196f86
  initlock(&tickslock, "time");
8010663a:	e8 d1 ea ff ff       	call   80105110 <initlock>
}
8010663f:	83 c4 10             	add    $0x10,%esp
80106642:	c9                   	leave  
80106643:	c3                   	ret    
80106644:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010664a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106650 <idtinit>:

void
idtinit(void)
{
80106650:	55                   	push   %ebp
  pd[0] = size-1;
80106651:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106656:	89 e5                	mov    %esp,%ebp
80106658:	83 ec 10             	sub    $0x10,%esp
8010665b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010665f:	b8 80 6d 19 80       	mov    $0x80196d80,%eax
80106664:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106668:	c1 e8 10             	shr    $0x10,%eax
8010666b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010666f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106672:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106675:	c9                   	leave  
80106676:	c3                   	ret    
80106677:	89 f6                	mov    %esi,%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106680 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106680:	55                   	push   %ebp
80106681:	89 e5                	mov    %esp,%ebp
80106683:	57                   	push   %edi
80106684:	56                   	push   %esi
80106685:	53                   	push   %ebx
80106686:	83 ec 1c             	sub    $0x1c,%esp
80106689:	8b 7d 08             	mov    0x8(%ebp),%edi
  // cprintf("at trap");
  struct proc* curproc = myproc();
8010668c:	e8 2f dc ff ff       	call   801042c0 <myproc>
80106691:	89 c3                	mov    %eax,%ebx
  if(tf->trapno == T_SYSCALL){
80106693:	8b 47 30             	mov    0x30(%edi),%eax
80106696:	83 f8 40             	cmp    $0x40,%eax
80106699:	0f 84 e9 00 00 00    	je     80106788 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010669f:	83 e8 0e             	sub    $0xe,%eax
801066a2:	83 f8 31             	cmp    $0x31,%eax
801066a5:	77 09                	ja     801066b0 <trap+0x30>
801066a7:	ff 24 85 44 9a 10 80 	jmp    *-0x7fef65bc(,%eax,4)
801066ae:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801066b0:	e8 0b dc ff ff       	call   801042c0 <myproc>
801066b5:	85 c0                	test   %eax,%eax
801066b7:	0f 84 27 02 00 00    	je     801068e4 <trap+0x264>
801066bd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801066c1:	0f 84 1d 02 00 00    	je     801068e4 <trap+0x264>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801066c7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ca:	8b 57 38             	mov    0x38(%edi),%edx
801066cd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801066d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801066d3:	e8 c8 db ff ff       	call   801042a0 <cpuid>
801066d8:	8b 77 34             	mov    0x34(%edi),%esi
801066db:	8b 5f 30             	mov    0x30(%edi),%ebx
801066de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801066e1:	e8 da db ff ff       	call   801042c0 <myproc>
801066e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801066e9:	e8 d2 db ff ff       	call   801042c0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066ee:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801066f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801066f4:	51                   	push   %ecx
801066f5:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801066f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801066f9:	ff 75 e4             	pushl  -0x1c(%ebp)
801066fc:	56                   	push   %esi
801066fd:	53                   	push   %ebx
            myproc()->pid, myproc()->name, tf->trapno,
801066fe:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106701:	52                   	push   %edx
80106702:	ff 70 10             	pushl  0x10(%eax)
80106705:	68 00 9a 10 80       	push   $0x80109a00
8010670a:	e8 51 9f ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010670f:	83 c4 20             	add    $0x20,%esp
80106712:	e8 a9 db ff ff       	call   801042c0 <myproc>
80106717:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010671e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106720:	e8 9b db ff ff       	call   801042c0 <myproc>
80106725:	85 c0                	test   %eax,%eax
80106727:	74 1d                	je     80106746 <trap+0xc6>
80106729:	e8 92 db ff ff       	call   801042c0 <myproc>
8010672e:	8b 50 24             	mov    0x24(%eax),%edx
80106731:	85 d2                	test   %edx,%edx
80106733:	74 11                	je     80106746 <trap+0xc6>
80106735:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106739:	83 e0 03             	and    $0x3,%eax
8010673c:	66 83 f8 03          	cmp    $0x3,%ax
80106740:	0f 84 5a 01 00 00    	je     801068a0 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106746:	e8 75 db ff ff       	call   801042c0 <myproc>
8010674b:	85 c0                	test   %eax,%eax
8010674d:	74 0b                	je     8010675a <trap+0xda>
8010674f:	e8 6c db ff ff       	call   801042c0 <myproc>
80106754:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80106758:	74 5e                	je     801067b8 <trap+0x138>
      }
      yield();
     }

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010675a:	e8 61 db ff ff       	call   801042c0 <myproc>
8010675f:	85 c0                	test   %eax,%eax
80106761:	74 19                	je     8010677c <trap+0xfc>
80106763:	e8 58 db ff ff       	call   801042c0 <myproc>
80106768:	8b 40 24             	mov    0x24(%eax),%eax
8010676b:	85 c0                	test   %eax,%eax
8010676d:	74 0d                	je     8010677c <trap+0xfc>
8010676f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106773:	83 e0 03             	and    $0x3,%eax
80106776:	66 83 f8 03          	cmp    $0x3,%ax
8010677a:	74 2b                	je     801067a7 <trap+0x127>
    exit();
8010677c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010677f:	5b                   	pop    %ebx
80106780:	5e                   	pop    %esi
80106781:	5f                   	pop    %edi
80106782:	5d                   	pop    %ebp
80106783:	c3                   	ret    
80106784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->killed)
80106788:	8b 73 24             	mov    0x24(%ebx),%esi
8010678b:	85 f6                	test   %esi,%esi
8010678d:	0f 85 fd 00 00 00    	jne    80106890 <trap+0x210>
    curproc->tf = tf;
80106793:	89 7b 18             	mov    %edi,0x18(%ebx)
    syscall();
80106796:	e8 b5 ef ff ff       	call   80105750 <syscall>
    if(myproc()->killed)
8010679b:	e8 20 db ff ff       	call   801042c0 <myproc>
801067a0:	8b 58 24             	mov    0x24(%eax),%ebx
801067a3:	85 db                	test   %ebx,%ebx
801067a5:	74 d5                	je     8010677c <trap+0xfc>
801067a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067aa:	5b                   	pop    %ebx
801067ab:	5e                   	pop    %esi
801067ac:	5f                   	pop    %edi
801067ad:	5d                   	pop    %ebp
      exit();
801067ae:	e9 9d e1 ff ff       	jmp    80104950 <exit>
801067b3:	90                   	nop
801067b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801067b8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801067bc:	75 9c                	jne    8010675a <trap+0xda>
      if(myproc()->pid > 2) 
801067be:	e8 fd da ff ff       	call   801042c0 <myproc>
      yield();
801067c3:	e8 e8 e2 ff ff       	call   80104ab0 <yield>
801067c8:	eb 90                	jmp    8010675a <trap+0xda>
801067ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->pid > 2) 
801067d0:	e8 eb da ff ff       	call   801042c0 <myproc>
801067d5:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801067d9:	0f 8e 41 ff ff ff    	jle    80106720 <trap+0xa0>
    pagefault();
801067df:	e8 dc 1f 00 00       	call   801087c0 <pagefault>
      if(curproc->killed) {
801067e4:	8b 4b 24             	mov    0x24(%ebx),%ecx
801067e7:	85 c9                	test   %ecx,%ecx
801067e9:	0f 84 31 ff ff ff    	je     80106720 <trap+0xa0>
        exit();
801067ef:	e8 5c e1 ff ff       	call   80104950 <exit>
801067f4:	e9 27 ff ff ff       	jmp    80106720 <trap+0xa0>
801067f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106800:	e8 9b da ff ff       	call   801042a0 <cpuid>
80106805:	85 c0                	test   %eax,%eax
80106807:	0f 84 a3 00 00 00    	je     801068b0 <trap+0x230>
    lapiceoi();
8010680d:	e8 ee c8 ff ff       	call   80103100 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106812:	e8 a9 da ff ff       	call   801042c0 <myproc>
80106817:	85 c0                	test   %eax,%eax
80106819:	0f 85 0a ff ff ff    	jne    80106729 <trap+0xa9>
8010681f:	e9 22 ff ff ff       	jmp    80106746 <trap+0xc6>
80106824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106828:	e8 93 c7 ff ff       	call   80102fc0 <kbdintr>
    lapiceoi();
8010682d:	e8 ce c8 ff ff       	call   80103100 <lapiceoi>
    break;
80106832:	e9 e9 fe ff ff       	jmp    80106720 <trap+0xa0>
80106837:	89 f6                	mov    %esi,%esi
80106839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80106840:	e8 3b 02 00 00       	call   80106a80 <uartintr>
    lapiceoi();
80106845:	e8 b6 c8 ff ff       	call   80103100 <lapiceoi>
    break;
8010684a:	e9 d1 fe ff ff       	jmp    80106720 <trap+0xa0>
8010684f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106850:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80106854:	8b 77 38             	mov    0x38(%edi),%esi
80106857:	e8 44 da ff ff       	call   801042a0 <cpuid>
8010685c:	56                   	push   %esi
8010685d:	53                   	push   %ebx
8010685e:	50                   	push   %eax
8010685f:	68 a8 99 10 80       	push   $0x801099a8
80106864:	e8 f7 9d ff ff       	call   80100660 <cprintf>
    lapiceoi();
80106869:	e8 92 c8 ff ff       	call   80103100 <lapiceoi>
    break;
8010686e:	83 c4 10             	add    $0x10,%esp
80106871:	e9 aa fe ff ff       	jmp    80106720 <trap+0xa0>
80106876:	8d 76 00             	lea    0x0(%esi),%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106880:	e8 3b bf ff ff       	call   801027c0 <ideintr>
80106885:	eb 86                	jmp    8010680d <trap+0x18d>
80106887:	89 f6                	mov    %esi,%esi
80106889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106890:	e8 bb e0 ff ff       	call   80104950 <exit>
80106895:	e9 f9 fe ff ff       	jmp    80106793 <trap+0x113>
8010689a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
801068a0:	e8 ab e0 ff ff       	call   80104950 <exit>
801068a5:	e9 9c fe ff ff       	jmp    80106746 <trap+0xc6>
801068aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
801068b0:	83 ec 0c             	sub    $0xc,%esp
801068b3:	68 40 6d 19 80       	push   $0x80196d40
801068b8:	e8 93 e9 ff ff       	call   80105250 <acquire>
      wakeup(&ticks);
801068bd:	c7 04 24 80 75 19 80 	movl   $0x80197580,(%esp)
      ticks++;
801068c4:	83 05 80 75 19 80 01 	addl   $0x1,0x80197580
      wakeup(&ticks);
801068cb:	e8 70 e4 ff ff       	call   80104d40 <wakeup>
      release(&tickslock);
801068d0:	c7 04 24 40 6d 19 80 	movl   $0x80196d40,(%esp)
801068d7:	e8 34 ea ff ff       	call   80105310 <release>
801068dc:	83 c4 10             	add    $0x10,%esp
801068df:	e9 29 ff ff ff       	jmp    8010680d <trap+0x18d>
801068e4:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801068e7:	8b 5f 38             	mov    0x38(%edi),%ebx
801068ea:	e8 b1 d9 ff ff       	call   801042a0 <cpuid>
801068ef:	83 ec 0c             	sub    $0xc,%esp
801068f2:	56                   	push   %esi
801068f3:	53                   	push   %ebx
801068f4:	50                   	push   %eax
801068f5:	ff 77 30             	pushl  0x30(%edi)
801068f8:	68 cc 99 10 80       	push   $0x801099cc
801068fd:	e8 5e 9d ff ff       	call   80100660 <cprintf>
      panic("trap");
80106902:	83 c4 14             	add    $0x14,%esp
80106905:	68 a2 99 10 80       	push   $0x801099a2
8010690a:	e8 81 9a ff ff       	call   80100390 <panic>
8010690f:	90                   	nop

80106910 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106910:	a1 dc c5 10 80       	mov    0x8010c5dc,%eax
{
80106915:	55                   	push   %ebp
80106916:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106918:	85 c0                	test   %eax,%eax
8010691a:	74 1c                	je     80106938 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010691c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106921:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106922:	a8 01                	test   $0x1,%al
80106924:	74 12                	je     80106938 <uartgetc+0x28>
80106926:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010692b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010692c:	0f b6 c0             	movzbl %al,%eax
}
8010692f:	5d                   	pop    %ebp
80106930:	c3                   	ret    
80106931:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010693d:	5d                   	pop    %ebp
8010693e:	c3                   	ret    
8010693f:	90                   	nop

80106940 <uartputc.part.0>:
uartputc(int c)
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
80106946:	89 c7                	mov    %eax,%edi
80106948:	bb 80 00 00 00       	mov    $0x80,%ebx
8010694d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106952:	83 ec 0c             	sub    $0xc,%esp
80106955:	eb 1b                	jmp    80106972 <uartputc.part.0+0x32>
80106957:	89 f6                	mov    %esi,%esi
80106959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106960:	83 ec 0c             	sub    $0xc,%esp
80106963:	6a 0a                	push   $0xa
80106965:	e8 b6 c7 ff ff       	call   80103120 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010696a:	83 c4 10             	add    $0x10,%esp
8010696d:	83 eb 01             	sub    $0x1,%ebx
80106970:	74 07                	je     80106979 <uartputc.part.0+0x39>
80106972:	89 f2                	mov    %esi,%edx
80106974:	ec                   	in     (%dx),%al
80106975:	a8 20                	test   $0x20,%al
80106977:	74 e7                	je     80106960 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106979:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010697e:	89 f8                	mov    %edi,%eax
80106980:	ee                   	out    %al,(%dx)
}
80106981:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106984:	5b                   	pop    %ebx
80106985:	5e                   	pop    %esi
80106986:	5f                   	pop    %edi
80106987:	5d                   	pop    %ebp
80106988:	c3                   	ret    
80106989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106990 <uartinit>:
{
80106990:	55                   	push   %ebp
80106991:	31 c9                	xor    %ecx,%ecx
80106993:	89 c8                	mov    %ecx,%eax
80106995:	89 e5                	mov    %esp,%ebp
80106997:	57                   	push   %edi
80106998:	56                   	push   %esi
80106999:	53                   	push   %ebx
8010699a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010699f:	89 da                	mov    %ebx,%edx
801069a1:	83 ec 0c             	sub    $0xc,%esp
801069a4:	ee                   	out    %al,(%dx)
801069a5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801069aa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801069af:	89 fa                	mov    %edi,%edx
801069b1:	ee                   	out    %al,(%dx)
801069b2:	b8 0c 00 00 00       	mov    $0xc,%eax
801069b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069bc:	ee                   	out    %al,(%dx)
801069bd:	be f9 03 00 00       	mov    $0x3f9,%esi
801069c2:	89 c8                	mov    %ecx,%eax
801069c4:	89 f2                	mov    %esi,%edx
801069c6:	ee                   	out    %al,(%dx)
801069c7:	b8 03 00 00 00       	mov    $0x3,%eax
801069cc:	89 fa                	mov    %edi,%edx
801069ce:	ee                   	out    %al,(%dx)
801069cf:	ba fc 03 00 00       	mov    $0x3fc,%edx
801069d4:	89 c8                	mov    %ecx,%eax
801069d6:	ee                   	out    %al,(%dx)
801069d7:	b8 01 00 00 00       	mov    $0x1,%eax
801069dc:	89 f2                	mov    %esi,%edx
801069de:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801069df:	ba fd 03 00 00       	mov    $0x3fd,%edx
801069e4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801069e5:	3c ff                	cmp    $0xff,%al
801069e7:	74 5a                	je     80106a43 <uartinit+0xb3>
  uart = 1;
801069e9:	c7 05 dc c5 10 80 01 	movl   $0x1,0x8010c5dc
801069f0:	00 00 00 
801069f3:	89 da                	mov    %ebx,%edx
801069f5:	ec                   	in     (%dx),%al
801069f6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801069fb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801069fc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801069ff:	bb 0c 9b 10 80       	mov    $0x80109b0c,%ebx
  ioapicenable(IRQ_COM1, 0);
80106a04:	6a 00                	push   $0x0
80106a06:	6a 04                	push   $0x4
80106a08:	e8 03 c0 ff ff       	call   80102a10 <ioapicenable>
80106a0d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106a10:	b8 78 00 00 00       	mov    $0x78,%eax
80106a15:	eb 13                	jmp    80106a2a <uartinit+0x9a>
80106a17:	89 f6                	mov    %esi,%esi
80106a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a20:	83 c3 01             	add    $0x1,%ebx
80106a23:	0f be 03             	movsbl (%ebx),%eax
80106a26:	84 c0                	test   %al,%al
80106a28:	74 19                	je     80106a43 <uartinit+0xb3>
  if(!uart)
80106a2a:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
80106a30:	85 d2                	test   %edx,%edx
80106a32:	74 ec                	je     80106a20 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106a34:	83 c3 01             	add    $0x1,%ebx
80106a37:	e8 04 ff ff ff       	call   80106940 <uartputc.part.0>
80106a3c:	0f be 03             	movsbl (%ebx),%eax
80106a3f:	84 c0                	test   %al,%al
80106a41:	75 e7                	jne    80106a2a <uartinit+0x9a>
}
80106a43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a46:	5b                   	pop    %ebx
80106a47:	5e                   	pop    %esi
80106a48:	5f                   	pop    %edi
80106a49:	5d                   	pop    %ebp
80106a4a:	c3                   	ret    
80106a4b:	90                   	nop
80106a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106a50 <uartputc>:
  if(!uart)
80106a50:	8b 15 dc c5 10 80    	mov    0x8010c5dc,%edx
{
80106a56:	55                   	push   %ebp
80106a57:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106a59:	85 d2                	test   %edx,%edx
{
80106a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106a5e:	74 10                	je     80106a70 <uartputc+0x20>
}
80106a60:	5d                   	pop    %ebp
80106a61:	e9 da fe ff ff       	jmp    80106940 <uartputc.part.0>
80106a66:	8d 76 00             	lea    0x0(%esi),%esi
80106a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106a70:	5d                   	pop    %ebp
80106a71:	c3                   	ret    
80106a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a80 <uartintr>:

void
uartintr(void)
{
80106a80:	55                   	push   %ebp
80106a81:	89 e5                	mov    %esp,%ebp
80106a83:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106a86:	68 10 69 10 80       	push   $0x80106910
80106a8b:	e8 80 9d ff ff       	call   80100810 <consoleintr>
}
80106a90:	83 c4 10             	add    $0x10,%esp
80106a93:	c9                   	leave  
80106a94:	c3                   	ret    

80106a95 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106a95:	6a 00                	push   $0x0
  pushl $0
80106a97:	6a 00                	push   $0x0
  jmp alltraps
80106a99:	e9 0b fb ff ff       	jmp    801065a9 <alltraps>

80106a9e <vector1>:
.globl vector1
vector1:
  pushl $0
80106a9e:	6a 00                	push   $0x0
  pushl $1
80106aa0:	6a 01                	push   $0x1
  jmp alltraps
80106aa2:	e9 02 fb ff ff       	jmp    801065a9 <alltraps>

80106aa7 <vector2>:
.globl vector2
vector2:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $2
80106aa9:	6a 02                	push   $0x2
  jmp alltraps
80106aab:	e9 f9 fa ff ff       	jmp    801065a9 <alltraps>

80106ab0 <vector3>:
.globl vector3
vector3:
  pushl $0
80106ab0:	6a 00                	push   $0x0
  pushl $3
80106ab2:	6a 03                	push   $0x3
  jmp alltraps
80106ab4:	e9 f0 fa ff ff       	jmp    801065a9 <alltraps>

80106ab9 <vector4>:
.globl vector4
vector4:
  pushl $0
80106ab9:	6a 00                	push   $0x0
  pushl $4
80106abb:	6a 04                	push   $0x4
  jmp alltraps
80106abd:	e9 e7 fa ff ff       	jmp    801065a9 <alltraps>

80106ac2 <vector5>:
.globl vector5
vector5:
  pushl $0
80106ac2:	6a 00                	push   $0x0
  pushl $5
80106ac4:	6a 05                	push   $0x5
  jmp alltraps
80106ac6:	e9 de fa ff ff       	jmp    801065a9 <alltraps>

80106acb <vector6>:
.globl vector6
vector6:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $6
80106acd:	6a 06                	push   $0x6
  jmp alltraps
80106acf:	e9 d5 fa ff ff       	jmp    801065a9 <alltraps>

80106ad4 <vector7>:
.globl vector7
vector7:
  pushl $0
80106ad4:	6a 00                	push   $0x0
  pushl $7
80106ad6:	6a 07                	push   $0x7
  jmp alltraps
80106ad8:	e9 cc fa ff ff       	jmp    801065a9 <alltraps>

80106add <vector8>:
.globl vector8
vector8:
  pushl $8
80106add:	6a 08                	push   $0x8
  jmp alltraps
80106adf:	e9 c5 fa ff ff       	jmp    801065a9 <alltraps>

80106ae4 <vector9>:
.globl vector9
vector9:
  pushl $0
80106ae4:	6a 00                	push   $0x0
  pushl $9
80106ae6:	6a 09                	push   $0x9
  jmp alltraps
80106ae8:	e9 bc fa ff ff       	jmp    801065a9 <alltraps>

80106aed <vector10>:
.globl vector10
vector10:
  pushl $10
80106aed:	6a 0a                	push   $0xa
  jmp alltraps
80106aef:	e9 b5 fa ff ff       	jmp    801065a9 <alltraps>

80106af4 <vector11>:
.globl vector11
vector11:
  pushl $11
80106af4:	6a 0b                	push   $0xb
  jmp alltraps
80106af6:	e9 ae fa ff ff       	jmp    801065a9 <alltraps>

80106afb <vector12>:
.globl vector12
vector12:
  pushl $12
80106afb:	6a 0c                	push   $0xc
  jmp alltraps
80106afd:	e9 a7 fa ff ff       	jmp    801065a9 <alltraps>

80106b02 <vector13>:
.globl vector13
vector13:
  pushl $13
80106b02:	6a 0d                	push   $0xd
  jmp alltraps
80106b04:	e9 a0 fa ff ff       	jmp    801065a9 <alltraps>

80106b09 <vector14>:
.globl vector14
vector14:
  pushl $14
80106b09:	6a 0e                	push   $0xe
  jmp alltraps
80106b0b:	e9 99 fa ff ff       	jmp    801065a9 <alltraps>

80106b10 <vector15>:
.globl vector15
vector15:
  pushl $0
80106b10:	6a 00                	push   $0x0
  pushl $15
80106b12:	6a 0f                	push   $0xf
  jmp alltraps
80106b14:	e9 90 fa ff ff       	jmp    801065a9 <alltraps>

80106b19 <vector16>:
.globl vector16
vector16:
  pushl $0
80106b19:	6a 00                	push   $0x0
  pushl $16
80106b1b:	6a 10                	push   $0x10
  jmp alltraps
80106b1d:	e9 87 fa ff ff       	jmp    801065a9 <alltraps>

80106b22 <vector17>:
.globl vector17
vector17:
  pushl $17
80106b22:	6a 11                	push   $0x11
  jmp alltraps
80106b24:	e9 80 fa ff ff       	jmp    801065a9 <alltraps>

80106b29 <vector18>:
.globl vector18
vector18:
  pushl $0
80106b29:	6a 00                	push   $0x0
  pushl $18
80106b2b:	6a 12                	push   $0x12
  jmp alltraps
80106b2d:	e9 77 fa ff ff       	jmp    801065a9 <alltraps>

80106b32 <vector19>:
.globl vector19
vector19:
  pushl $0
80106b32:	6a 00                	push   $0x0
  pushl $19
80106b34:	6a 13                	push   $0x13
  jmp alltraps
80106b36:	e9 6e fa ff ff       	jmp    801065a9 <alltraps>

80106b3b <vector20>:
.globl vector20
vector20:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $20
80106b3d:	6a 14                	push   $0x14
  jmp alltraps
80106b3f:	e9 65 fa ff ff       	jmp    801065a9 <alltraps>

80106b44 <vector21>:
.globl vector21
vector21:
  pushl $0
80106b44:	6a 00                	push   $0x0
  pushl $21
80106b46:	6a 15                	push   $0x15
  jmp alltraps
80106b48:	e9 5c fa ff ff       	jmp    801065a9 <alltraps>

80106b4d <vector22>:
.globl vector22
vector22:
  pushl $0
80106b4d:	6a 00                	push   $0x0
  pushl $22
80106b4f:	6a 16                	push   $0x16
  jmp alltraps
80106b51:	e9 53 fa ff ff       	jmp    801065a9 <alltraps>

80106b56 <vector23>:
.globl vector23
vector23:
  pushl $0
80106b56:	6a 00                	push   $0x0
  pushl $23
80106b58:	6a 17                	push   $0x17
  jmp alltraps
80106b5a:	e9 4a fa ff ff       	jmp    801065a9 <alltraps>

80106b5f <vector24>:
.globl vector24
vector24:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $24
80106b61:	6a 18                	push   $0x18
  jmp alltraps
80106b63:	e9 41 fa ff ff       	jmp    801065a9 <alltraps>

80106b68 <vector25>:
.globl vector25
vector25:
  pushl $0
80106b68:	6a 00                	push   $0x0
  pushl $25
80106b6a:	6a 19                	push   $0x19
  jmp alltraps
80106b6c:	e9 38 fa ff ff       	jmp    801065a9 <alltraps>

80106b71 <vector26>:
.globl vector26
vector26:
  pushl $0
80106b71:	6a 00                	push   $0x0
  pushl $26
80106b73:	6a 1a                	push   $0x1a
  jmp alltraps
80106b75:	e9 2f fa ff ff       	jmp    801065a9 <alltraps>

80106b7a <vector27>:
.globl vector27
vector27:
  pushl $0
80106b7a:	6a 00                	push   $0x0
  pushl $27
80106b7c:	6a 1b                	push   $0x1b
  jmp alltraps
80106b7e:	e9 26 fa ff ff       	jmp    801065a9 <alltraps>

80106b83 <vector28>:
.globl vector28
vector28:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $28
80106b85:	6a 1c                	push   $0x1c
  jmp alltraps
80106b87:	e9 1d fa ff ff       	jmp    801065a9 <alltraps>

80106b8c <vector29>:
.globl vector29
vector29:
  pushl $0
80106b8c:	6a 00                	push   $0x0
  pushl $29
80106b8e:	6a 1d                	push   $0x1d
  jmp alltraps
80106b90:	e9 14 fa ff ff       	jmp    801065a9 <alltraps>

80106b95 <vector30>:
.globl vector30
vector30:
  pushl $0
80106b95:	6a 00                	push   $0x0
  pushl $30
80106b97:	6a 1e                	push   $0x1e
  jmp alltraps
80106b99:	e9 0b fa ff ff       	jmp    801065a9 <alltraps>

80106b9e <vector31>:
.globl vector31
vector31:
  pushl $0
80106b9e:	6a 00                	push   $0x0
  pushl $31
80106ba0:	6a 1f                	push   $0x1f
  jmp alltraps
80106ba2:	e9 02 fa ff ff       	jmp    801065a9 <alltraps>

80106ba7 <vector32>:
.globl vector32
vector32:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $32
80106ba9:	6a 20                	push   $0x20
  jmp alltraps
80106bab:	e9 f9 f9 ff ff       	jmp    801065a9 <alltraps>

80106bb0 <vector33>:
.globl vector33
vector33:
  pushl $0
80106bb0:	6a 00                	push   $0x0
  pushl $33
80106bb2:	6a 21                	push   $0x21
  jmp alltraps
80106bb4:	e9 f0 f9 ff ff       	jmp    801065a9 <alltraps>

80106bb9 <vector34>:
.globl vector34
vector34:
  pushl $0
80106bb9:	6a 00                	push   $0x0
  pushl $34
80106bbb:	6a 22                	push   $0x22
  jmp alltraps
80106bbd:	e9 e7 f9 ff ff       	jmp    801065a9 <alltraps>

80106bc2 <vector35>:
.globl vector35
vector35:
  pushl $0
80106bc2:	6a 00                	push   $0x0
  pushl $35
80106bc4:	6a 23                	push   $0x23
  jmp alltraps
80106bc6:	e9 de f9 ff ff       	jmp    801065a9 <alltraps>

80106bcb <vector36>:
.globl vector36
vector36:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $36
80106bcd:	6a 24                	push   $0x24
  jmp alltraps
80106bcf:	e9 d5 f9 ff ff       	jmp    801065a9 <alltraps>

80106bd4 <vector37>:
.globl vector37
vector37:
  pushl $0
80106bd4:	6a 00                	push   $0x0
  pushl $37
80106bd6:	6a 25                	push   $0x25
  jmp alltraps
80106bd8:	e9 cc f9 ff ff       	jmp    801065a9 <alltraps>

80106bdd <vector38>:
.globl vector38
vector38:
  pushl $0
80106bdd:	6a 00                	push   $0x0
  pushl $38
80106bdf:	6a 26                	push   $0x26
  jmp alltraps
80106be1:	e9 c3 f9 ff ff       	jmp    801065a9 <alltraps>

80106be6 <vector39>:
.globl vector39
vector39:
  pushl $0
80106be6:	6a 00                	push   $0x0
  pushl $39
80106be8:	6a 27                	push   $0x27
  jmp alltraps
80106bea:	e9 ba f9 ff ff       	jmp    801065a9 <alltraps>

80106bef <vector40>:
.globl vector40
vector40:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $40
80106bf1:	6a 28                	push   $0x28
  jmp alltraps
80106bf3:	e9 b1 f9 ff ff       	jmp    801065a9 <alltraps>

80106bf8 <vector41>:
.globl vector41
vector41:
  pushl $0
80106bf8:	6a 00                	push   $0x0
  pushl $41
80106bfa:	6a 29                	push   $0x29
  jmp alltraps
80106bfc:	e9 a8 f9 ff ff       	jmp    801065a9 <alltraps>

80106c01 <vector42>:
.globl vector42
vector42:
  pushl $0
80106c01:	6a 00                	push   $0x0
  pushl $42
80106c03:	6a 2a                	push   $0x2a
  jmp alltraps
80106c05:	e9 9f f9 ff ff       	jmp    801065a9 <alltraps>

80106c0a <vector43>:
.globl vector43
vector43:
  pushl $0
80106c0a:	6a 00                	push   $0x0
  pushl $43
80106c0c:	6a 2b                	push   $0x2b
  jmp alltraps
80106c0e:	e9 96 f9 ff ff       	jmp    801065a9 <alltraps>

80106c13 <vector44>:
.globl vector44
vector44:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $44
80106c15:	6a 2c                	push   $0x2c
  jmp alltraps
80106c17:	e9 8d f9 ff ff       	jmp    801065a9 <alltraps>

80106c1c <vector45>:
.globl vector45
vector45:
  pushl $0
80106c1c:	6a 00                	push   $0x0
  pushl $45
80106c1e:	6a 2d                	push   $0x2d
  jmp alltraps
80106c20:	e9 84 f9 ff ff       	jmp    801065a9 <alltraps>

80106c25 <vector46>:
.globl vector46
vector46:
  pushl $0
80106c25:	6a 00                	push   $0x0
  pushl $46
80106c27:	6a 2e                	push   $0x2e
  jmp alltraps
80106c29:	e9 7b f9 ff ff       	jmp    801065a9 <alltraps>

80106c2e <vector47>:
.globl vector47
vector47:
  pushl $0
80106c2e:	6a 00                	push   $0x0
  pushl $47
80106c30:	6a 2f                	push   $0x2f
  jmp alltraps
80106c32:	e9 72 f9 ff ff       	jmp    801065a9 <alltraps>

80106c37 <vector48>:
.globl vector48
vector48:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $48
80106c39:	6a 30                	push   $0x30
  jmp alltraps
80106c3b:	e9 69 f9 ff ff       	jmp    801065a9 <alltraps>

80106c40 <vector49>:
.globl vector49
vector49:
  pushl $0
80106c40:	6a 00                	push   $0x0
  pushl $49
80106c42:	6a 31                	push   $0x31
  jmp alltraps
80106c44:	e9 60 f9 ff ff       	jmp    801065a9 <alltraps>

80106c49 <vector50>:
.globl vector50
vector50:
  pushl $0
80106c49:	6a 00                	push   $0x0
  pushl $50
80106c4b:	6a 32                	push   $0x32
  jmp alltraps
80106c4d:	e9 57 f9 ff ff       	jmp    801065a9 <alltraps>

80106c52 <vector51>:
.globl vector51
vector51:
  pushl $0
80106c52:	6a 00                	push   $0x0
  pushl $51
80106c54:	6a 33                	push   $0x33
  jmp alltraps
80106c56:	e9 4e f9 ff ff       	jmp    801065a9 <alltraps>

80106c5b <vector52>:
.globl vector52
vector52:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $52
80106c5d:	6a 34                	push   $0x34
  jmp alltraps
80106c5f:	e9 45 f9 ff ff       	jmp    801065a9 <alltraps>

80106c64 <vector53>:
.globl vector53
vector53:
  pushl $0
80106c64:	6a 00                	push   $0x0
  pushl $53
80106c66:	6a 35                	push   $0x35
  jmp alltraps
80106c68:	e9 3c f9 ff ff       	jmp    801065a9 <alltraps>

80106c6d <vector54>:
.globl vector54
vector54:
  pushl $0
80106c6d:	6a 00                	push   $0x0
  pushl $54
80106c6f:	6a 36                	push   $0x36
  jmp alltraps
80106c71:	e9 33 f9 ff ff       	jmp    801065a9 <alltraps>

80106c76 <vector55>:
.globl vector55
vector55:
  pushl $0
80106c76:	6a 00                	push   $0x0
  pushl $55
80106c78:	6a 37                	push   $0x37
  jmp alltraps
80106c7a:	e9 2a f9 ff ff       	jmp    801065a9 <alltraps>

80106c7f <vector56>:
.globl vector56
vector56:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $56
80106c81:	6a 38                	push   $0x38
  jmp alltraps
80106c83:	e9 21 f9 ff ff       	jmp    801065a9 <alltraps>

80106c88 <vector57>:
.globl vector57
vector57:
  pushl $0
80106c88:	6a 00                	push   $0x0
  pushl $57
80106c8a:	6a 39                	push   $0x39
  jmp alltraps
80106c8c:	e9 18 f9 ff ff       	jmp    801065a9 <alltraps>

80106c91 <vector58>:
.globl vector58
vector58:
  pushl $0
80106c91:	6a 00                	push   $0x0
  pushl $58
80106c93:	6a 3a                	push   $0x3a
  jmp alltraps
80106c95:	e9 0f f9 ff ff       	jmp    801065a9 <alltraps>

80106c9a <vector59>:
.globl vector59
vector59:
  pushl $0
80106c9a:	6a 00                	push   $0x0
  pushl $59
80106c9c:	6a 3b                	push   $0x3b
  jmp alltraps
80106c9e:	e9 06 f9 ff ff       	jmp    801065a9 <alltraps>

80106ca3 <vector60>:
.globl vector60
vector60:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $60
80106ca5:	6a 3c                	push   $0x3c
  jmp alltraps
80106ca7:	e9 fd f8 ff ff       	jmp    801065a9 <alltraps>

80106cac <vector61>:
.globl vector61
vector61:
  pushl $0
80106cac:	6a 00                	push   $0x0
  pushl $61
80106cae:	6a 3d                	push   $0x3d
  jmp alltraps
80106cb0:	e9 f4 f8 ff ff       	jmp    801065a9 <alltraps>

80106cb5 <vector62>:
.globl vector62
vector62:
  pushl $0
80106cb5:	6a 00                	push   $0x0
  pushl $62
80106cb7:	6a 3e                	push   $0x3e
  jmp alltraps
80106cb9:	e9 eb f8 ff ff       	jmp    801065a9 <alltraps>

80106cbe <vector63>:
.globl vector63
vector63:
  pushl $0
80106cbe:	6a 00                	push   $0x0
  pushl $63
80106cc0:	6a 3f                	push   $0x3f
  jmp alltraps
80106cc2:	e9 e2 f8 ff ff       	jmp    801065a9 <alltraps>

80106cc7 <vector64>:
.globl vector64
vector64:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $64
80106cc9:	6a 40                	push   $0x40
  jmp alltraps
80106ccb:	e9 d9 f8 ff ff       	jmp    801065a9 <alltraps>

80106cd0 <vector65>:
.globl vector65
vector65:
  pushl $0
80106cd0:	6a 00                	push   $0x0
  pushl $65
80106cd2:	6a 41                	push   $0x41
  jmp alltraps
80106cd4:	e9 d0 f8 ff ff       	jmp    801065a9 <alltraps>

80106cd9 <vector66>:
.globl vector66
vector66:
  pushl $0
80106cd9:	6a 00                	push   $0x0
  pushl $66
80106cdb:	6a 42                	push   $0x42
  jmp alltraps
80106cdd:	e9 c7 f8 ff ff       	jmp    801065a9 <alltraps>

80106ce2 <vector67>:
.globl vector67
vector67:
  pushl $0
80106ce2:	6a 00                	push   $0x0
  pushl $67
80106ce4:	6a 43                	push   $0x43
  jmp alltraps
80106ce6:	e9 be f8 ff ff       	jmp    801065a9 <alltraps>

80106ceb <vector68>:
.globl vector68
vector68:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $68
80106ced:	6a 44                	push   $0x44
  jmp alltraps
80106cef:	e9 b5 f8 ff ff       	jmp    801065a9 <alltraps>

80106cf4 <vector69>:
.globl vector69
vector69:
  pushl $0
80106cf4:	6a 00                	push   $0x0
  pushl $69
80106cf6:	6a 45                	push   $0x45
  jmp alltraps
80106cf8:	e9 ac f8 ff ff       	jmp    801065a9 <alltraps>

80106cfd <vector70>:
.globl vector70
vector70:
  pushl $0
80106cfd:	6a 00                	push   $0x0
  pushl $70
80106cff:	6a 46                	push   $0x46
  jmp alltraps
80106d01:	e9 a3 f8 ff ff       	jmp    801065a9 <alltraps>

80106d06 <vector71>:
.globl vector71
vector71:
  pushl $0
80106d06:	6a 00                	push   $0x0
  pushl $71
80106d08:	6a 47                	push   $0x47
  jmp alltraps
80106d0a:	e9 9a f8 ff ff       	jmp    801065a9 <alltraps>

80106d0f <vector72>:
.globl vector72
vector72:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $72
80106d11:	6a 48                	push   $0x48
  jmp alltraps
80106d13:	e9 91 f8 ff ff       	jmp    801065a9 <alltraps>

80106d18 <vector73>:
.globl vector73
vector73:
  pushl $0
80106d18:	6a 00                	push   $0x0
  pushl $73
80106d1a:	6a 49                	push   $0x49
  jmp alltraps
80106d1c:	e9 88 f8 ff ff       	jmp    801065a9 <alltraps>

80106d21 <vector74>:
.globl vector74
vector74:
  pushl $0
80106d21:	6a 00                	push   $0x0
  pushl $74
80106d23:	6a 4a                	push   $0x4a
  jmp alltraps
80106d25:	e9 7f f8 ff ff       	jmp    801065a9 <alltraps>

80106d2a <vector75>:
.globl vector75
vector75:
  pushl $0
80106d2a:	6a 00                	push   $0x0
  pushl $75
80106d2c:	6a 4b                	push   $0x4b
  jmp alltraps
80106d2e:	e9 76 f8 ff ff       	jmp    801065a9 <alltraps>

80106d33 <vector76>:
.globl vector76
vector76:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $76
80106d35:	6a 4c                	push   $0x4c
  jmp alltraps
80106d37:	e9 6d f8 ff ff       	jmp    801065a9 <alltraps>

80106d3c <vector77>:
.globl vector77
vector77:
  pushl $0
80106d3c:	6a 00                	push   $0x0
  pushl $77
80106d3e:	6a 4d                	push   $0x4d
  jmp alltraps
80106d40:	e9 64 f8 ff ff       	jmp    801065a9 <alltraps>

80106d45 <vector78>:
.globl vector78
vector78:
  pushl $0
80106d45:	6a 00                	push   $0x0
  pushl $78
80106d47:	6a 4e                	push   $0x4e
  jmp alltraps
80106d49:	e9 5b f8 ff ff       	jmp    801065a9 <alltraps>

80106d4e <vector79>:
.globl vector79
vector79:
  pushl $0
80106d4e:	6a 00                	push   $0x0
  pushl $79
80106d50:	6a 4f                	push   $0x4f
  jmp alltraps
80106d52:	e9 52 f8 ff ff       	jmp    801065a9 <alltraps>

80106d57 <vector80>:
.globl vector80
vector80:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $80
80106d59:	6a 50                	push   $0x50
  jmp alltraps
80106d5b:	e9 49 f8 ff ff       	jmp    801065a9 <alltraps>

80106d60 <vector81>:
.globl vector81
vector81:
  pushl $0
80106d60:	6a 00                	push   $0x0
  pushl $81
80106d62:	6a 51                	push   $0x51
  jmp alltraps
80106d64:	e9 40 f8 ff ff       	jmp    801065a9 <alltraps>

80106d69 <vector82>:
.globl vector82
vector82:
  pushl $0
80106d69:	6a 00                	push   $0x0
  pushl $82
80106d6b:	6a 52                	push   $0x52
  jmp alltraps
80106d6d:	e9 37 f8 ff ff       	jmp    801065a9 <alltraps>

80106d72 <vector83>:
.globl vector83
vector83:
  pushl $0
80106d72:	6a 00                	push   $0x0
  pushl $83
80106d74:	6a 53                	push   $0x53
  jmp alltraps
80106d76:	e9 2e f8 ff ff       	jmp    801065a9 <alltraps>

80106d7b <vector84>:
.globl vector84
vector84:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $84
80106d7d:	6a 54                	push   $0x54
  jmp alltraps
80106d7f:	e9 25 f8 ff ff       	jmp    801065a9 <alltraps>

80106d84 <vector85>:
.globl vector85
vector85:
  pushl $0
80106d84:	6a 00                	push   $0x0
  pushl $85
80106d86:	6a 55                	push   $0x55
  jmp alltraps
80106d88:	e9 1c f8 ff ff       	jmp    801065a9 <alltraps>

80106d8d <vector86>:
.globl vector86
vector86:
  pushl $0
80106d8d:	6a 00                	push   $0x0
  pushl $86
80106d8f:	6a 56                	push   $0x56
  jmp alltraps
80106d91:	e9 13 f8 ff ff       	jmp    801065a9 <alltraps>

80106d96 <vector87>:
.globl vector87
vector87:
  pushl $0
80106d96:	6a 00                	push   $0x0
  pushl $87
80106d98:	6a 57                	push   $0x57
  jmp alltraps
80106d9a:	e9 0a f8 ff ff       	jmp    801065a9 <alltraps>

80106d9f <vector88>:
.globl vector88
vector88:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $88
80106da1:	6a 58                	push   $0x58
  jmp alltraps
80106da3:	e9 01 f8 ff ff       	jmp    801065a9 <alltraps>

80106da8 <vector89>:
.globl vector89
vector89:
  pushl $0
80106da8:	6a 00                	push   $0x0
  pushl $89
80106daa:	6a 59                	push   $0x59
  jmp alltraps
80106dac:	e9 f8 f7 ff ff       	jmp    801065a9 <alltraps>

80106db1 <vector90>:
.globl vector90
vector90:
  pushl $0
80106db1:	6a 00                	push   $0x0
  pushl $90
80106db3:	6a 5a                	push   $0x5a
  jmp alltraps
80106db5:	e9 ef f7 ff ff       	jmp    801065a9 <alltraps>

80106dba <vector91>:
.globl vector91
vector91:
  pushl $0
80106dba:	6a 00                	push   $0x0
  pushl $91
80106dbc:	6a 5b                	push   $0x5b
  jmp alltraps
80106dbe:	e9 e6 f7 ff ff       	jmp    801065a9 <alltraps>

80106dc3 <vector92>:
.globl vector92
vector92:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $92
80106dc5:	6a 5c                	push   $0x5c
  jmp alltraps
80106dc7:	e9 dd f7 ff ff       	jmp    801065a9 <alltraps>

80106dcc <vector93>:
.globl vector93
vector93:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $93
80106dce:	6a 5d                	push   $0x5d
  jmp alltraps
80106dd0:	e9 d4 f7 ff ff       	jmp    801065a9 <alltraps>

80106dd5 <vector94>:
.globl vector94
vector94:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $94
80106dd7:	6a 5e                	push   $0x5e
  jmp alltraps
80106dd9:	e9 cb f7 ff ff       	jmp    801065a9 <alltraps>

80106dde <vector95>:
.globl vector95
vector95:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $95
80106de0:	6a 5f                	push   $0x5f
  jmp alltraps
80106de2:	e9 c2 f7 ff ff       	jmp    801065a9 <alltraps>

80106de7 <vector96>:
.globl vector96
vector96:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $96
80106de9:	6a 60                	push   $0x60
  jmp alltraps
80106deb:	e9 b9 f7 ff ff       	jmp    801065a9 <alltraps>

80106df0 <vector97>:
.globl vector97
vector97:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $97
80106df2:	6a 61                	push   $0x61
  jmp alltraps
80106df4:	e9 b0 f7 ff ff       	jmp    801065a9 <alltraps>

80106df9 <vector98>:
.globl vector98
vector98:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $98
80106dfb:	6a 62                	push   $0x62
  jmp alltraps
80106dfd:	e9 a7 f7 ff ff       	jmp    801065a9 <alltraps>

80106e02 <vector99>:
.globl vector99
vector99:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $99
80106e04:	6a 63                	push   $0x63
  jmp alltraps
80106e06:	e9 9e f7 ff ff       	jmp    801065a9 <alltraps>

80106e0b <vector100>:
.globl vector100
vector100:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $100
80106e0d:	6a 64                	push   $0x64
  jmp alltraps
80106e0f:	e9 95 f7 ff ff       	jmp    801065a9 <alltraps>

80106e14 <vector101>:
.globl vector101
vector101:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $101
80106e16:	6a 65                	push   $0x65
  jmp alltraps
80106e18:	e9 8c f7 ff ff       	jmp    801065a9 <alltraps>

80106e1d <vector102>:
.globl vector102
vector102:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $102
80106e1f:	6a 66                	push   $0x66
  jmp alltraps
80106e21:	e9 83 f7 ff ff       	jmp    801065a9 <alltraps>

80106e26 <vector103>:
.globl vector103
vector103:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $103
80106e28:	6a 67                	push   $0x67
  jmp alltraps
80106e2a:	e9 7a f7 ff ff       	jmp    801065a9 <alltraps>

80106e2f <vector104>:
.globl vector104
vector104:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $104
80106e31:	6a 68                	push   $0x68
  jmp alltraps
80106e33:	e9 71 f7 ff ff       	jmp    801065a9 <alltraps>

80106e38 <vector105>:
.globl vector105
vector105:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $105
80106e3a:	6a 69                	push   $0x69
  jmp alltraps
80106e3c:	e9 68 f7 ff ff       	jmp    801065a9 <alltraps>

80106e41 <vector106>:
.globl vector106
vector106:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $106
80106e43:	6a 6a                	push   $0x6a
  jmp alltraps
80106e45:	e9 5f f7 ff ff       	jmp    801065a9 <alltraps>

80106e4a <vector107>:
.globl vector107
vector107:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $107
80106e4c:	6a 6b                	push   $0x6b
  jmp alltraps
80106e4e:	e9 56 f7 ff ff       	jmp    801065a9 <alltraps>

80106e53 <vector108>:
.globl vector108
vector108:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $108
80106e55:	6a 6c                	push   $0x6c
  jmp alltraps
80106e57:	e9 4d f7 ff ff       	jmp    801065a9 <alltraps>

80106e5c <vector109>:
.globl vector109
vector109:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $109
80106e5e:	6a 6d                	push   $0x6d
  jmp alltraps
80106e60:	e9 44 f7 ff ff       	jmp    801065a9 <alltraps>

80106e65 <vector110>:
.globl vector110
vector110:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $110
80106e67:	6a 6e                	push   $0x6e
  jmp alltraps
80106e69:	e9 3b f7 ff ff       	jmp    801065a9 <alltraps>

80106e6e <vector111>:
.globl vector111
vector111:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $111
80106e70:	6a 6f                	push   $0x6f
  jmp alltraps
80106e72:	e9 32 f7 ff ff       	jmp    801065a9 <alltraps>

80106e77 <vector112>:
.globl vector112
vector112:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $112
80106e79:	6a 70                	push   $0x70
  jmp alltraps
80106e7b:	e9 29 f7 ff ff       	jmp    801065a9 <alltraps>

80106e80 <vector113>:
.globl vector113
vector113:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $113
80106e82:	6a 71                	push   $0x71
  jmp alltraps
80106e84:	e9 20 f7 ff ff       	jmp    801065a9 <alltraps>

80106e89 <vector114>:
.globl vector114
vector114:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $114
80106e8b:	6a 72                	push   $0x72
  jmp alltraps
80106e8d:	e9 17 f7 ff ff       	jmp    801065a9 <alltraps>

80106e92 <vector115>:
.globl vector115
vector115:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $115
80106e94:	6a 73                	push   $0x73
  jmp alltraps
80106e96:	e9 0e f7 ff ff       	jmp    801065a9 <alltraps>

80106e9b <vector116>:
.globl vector116
vector116:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $116
80106e9d:	6a 74                	push   $0x74
  jmp alltraps
80106e9f:	e9 05 f7 ff ff       	jmp    801065a9 <alltraps>

80106ea4 <vector117>:
.globl vector117
vector117:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $117
80106ea6:	6a 75                	push   $0x75
  jmp alltraps
80106ea8:	e9 fc f6 ff ff       	jmp    801065a9 <alltraps>

80106ead <vector118>:
.globl vector118
vector118:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $118
80106eaf:	6a 76                	push   $0x76
  jmp alltraps
80106eb1:	e9 f3 f6 ff ff       	jmp    801065a9 <alltraps>

80106eb6 <vector119>:
.globl vector119
vector119:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $119
80106eb8:	6a 77                	push   $0x77
  jmp alltraps
80106eba:	e9 ea f6 ff ff       	jmp    801065a9 <alltraps>

80106ebf <vector120>:
.globl vector120
vector120:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $120
80106ec1:	6a 78                	push   $0x78
  jmp alltraps
80106ec3:	e9 e1 f6 ff ff       	jmp    801065a9 <alltraps>

80106ec8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $121
80106eca:	6a 79                	push   $0x79
  jmp alltraps
80106ecc:	e9 d8 f6 ff ff       	jmp    801065a9 <alltraps>

80106ed1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $122
80106ed3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ed5:	e9 cf f6 ff ff       	jmp    801065a9 <alltraps>

80106eda <vector123>:
.globl vector123
vector123:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $123
80106edc:	6a 7b                	push   $0x7b
  jmp alltraps
80106ede:	e9 c6 f6 ff ff       	jmp    801065a9 <alltraps>

80106ee3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $124
80106ee5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ee7:	e9 bd f6 ff ff       	jmp    801065a9 <alltraps>

80106eec <vector125>:
.globl vector125
vector125:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $125
80106eee:	6a 7d                	push   $0x7d
  jmp alltraps
80106ef0:	e9 b4 f6 ff ff       	jmp    801065a9 <alltraps>

80106ef5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $126
80106ef7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ef9:	e9 ab f6 ff ff       	jmp    801065a9 <alltraps>

80106efe <vector127>:
.globl vector127
vector127:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $127
80106f00:	6a 7f                	push   $0x7f
  jmp alltraps
80106f02:	e9 a2 f6 ff ff       	jmp    801065a9 <alltraps>

80106f07 <vector128>:
.globl vector128
vector128:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $128
80106f09:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106f0e:	e9 96 f6 ff ff       	jmp    801065a9 <alltraps>

80106f13 <vector129>:
.globl vector129
vector129:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $129
80106f15:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106f1a:	e9 8a f6 ff ff       	jmp    801065a9 <alltraps>

80106f1f <vector130>:
.globl vector130
vector130:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $130
80106f21:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106f26:	e9 7e f6 ff ff       	jmp    801065a9 <alltraps>

80106f2b <vector131>:
.globl vector131
vector131:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $131
80106f2d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106f32:	e9 72 f6 ff ff       	jmp    801065a9 <alltraps>

80106f37 <vector132>:
.globl vector132
vector132:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $132
80106f39:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106f3e:	e9 66 f6 ff ff       	jmp    801065a9 <alltraps>

80106f43 <vector133>:
.globl vector133
vector133:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $133
80106f45:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106f4a:	e9 5a f6 ff ff       	jmp    801065a9 <alltraps>

80106f4f <vector134>:
.globl vector134
vector134:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $134
80106f51:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106f56:	e9 4e f6 ff ff       	jmp    801065a9 <alltraps>

80106f5b <vector135>:
.globl vector135
vector135:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $135
80106f5d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106f62:	e9 42 f6 ff ff       	jmp    801065a9 <alltraps>

80106f67 <vector136>:
.globl vector136
vector136:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $136
80106f69:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106f6e:	e9 36 f6 ff ff       	jmp    801065a9 <alltraps>

80106f73 <vector137>:
.globl vector137
vector137:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $137
80106f75:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106f7a:	e9 2a f6 ff ff       	jmp    801065a9 <alltraps>

80106f7f <vector138>:
.globl vector138
vector138:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $138
80106f81:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106f86:	e9 1e f6 ff ff       	jmp    801065a9 <alltraps>

80106f8b <vector139>:
.globl vector139
vector139:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $139
80106f8d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106f92:	e9 12 f6 ff ff       	jmp    801065a9 <alltraps>

80106f97 <vector140>:
.globl vector140
vector140:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $140
80106f99:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106f9e:	e9 06 f6 ff ff       	jmp    801065a9 <alltraps>

80106fa3 <vector141>:
.globl vector141
vector141:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $141
80106fa5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106faa:	e9 fa f5 ff ff       	jmp    801065a9 <alltraps>

80106faf <vector142>:
.globl vector142
vector142:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $142
80106fb1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106fb6:	e9 ee f5 ff ff       	jmp    801065a9 <alltraps>

80106fbb <vector143>:
.globl vector143
vector143:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $143
80106fbd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106fc2:	e9 e2 f5 ff ff       	jmp    801065a9 <alltraps>

80106fc7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $144
80106fc9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106fce:	e9 d6 f5 ff ff       	jmp    801065a9 <alltraps>

80106fd3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $145
80106fd5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106fda:	e9 ca f5 ff ff       	jmp    801065a9 <alltraps>

80106fdf <vector146>:
.globl vector146
vector146:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $146
80106fe1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106fe6:	e9 be f5 ff ff       	jmp    801065a9 <alltraps>

80106feb <vector147>:
.globl vector147
vector147:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $147
80106fed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106ff2:	e9 b2 f5 ff ff       	jmp    801065a9 <alltraps>

80106ff7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $148
80106ff9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106ffe:	e9 a6 f5 ff ff       	jmp    801065a9 <alltraps>

80107003 <vector149>:
.globl vector149
vector149:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $149
80107005:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010700a:	e9 9a f5 ff ff       	jmp    801065a9 <alltraps>

8010700f <vector150>:
.globl vector150
vector150:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $150
80107011:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107016:	e9 8e f5 ff ff       	jmp    801065a9 <alltraps>

8010701b <vector151>:
.globl vector151
vector151:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $151
8010701d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107022:	e9 82 f5 ff ff       	jmp    801065a9 <alltraps>

80107027 <vector152>:
.globl vector152
vector152:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $152
80107029:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010702e:	e9 76 f5 ff ff       	jmp    801065a9 <alltraps>

80107033 <vector153>:
.globl vector153
vector153:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $153
80107035:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010703a:	e9 6a f5 ff ff       	jmp    801065a9 <alltraps>

8010703f <vector154>:
.globl vector154
vector154:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $154
80107041:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107046:	e9 5e f5 ff ff       	jmp    801065a9 <alltraps>

8010704b <vector155>:
.globl vector155
vector155:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $155
8010704d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107052:	e9 52 f5 ff ff       	jmp    801065a9 <alltraps>

80107057 <vector156>:
.globl vector156
vector156:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $156
80107059:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010705e:	e9 46 f5 ff ff       	jmp    801065a9 <alltraps>

80107063 <vector157>:
.globl vector157
vector157:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $157
80107065:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010706a:	e9 3a f5 ff ff       	jmp    801065a9 <alltraps>

8010706f <vector158>:
.globl vector158
vector158:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $158
80107071:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107076:	e9 2e f5 ff ff       	jmp    801065a9 <alltraps>

8010707b <vector159>:
.globl vector159
vector159:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $159
8010707d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107082:	e9 22 f5 ff ff       	jmp    801065a9 <alltraps>

80107087 <vector160>:
.globl vector160
vector160:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $160
80107089:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010708e:	e9 16 f5 ff ff       	jmp    801065a9 <alltraps>

80107093 <vector161>:
.globl vector161
vector161:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $161
80107095:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010709a:	e9 0a f5 ff ff       	jmp    801065a9 <alltraps>

8010709f <vector162>:
.globl vector162
vector162:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $162
801070a1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801070a6:	e9 fe f4 ff ff       	jmp    801065a9 <alltraps>

801070ab <vector163>:
.globl vector163
vector163:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $163
801070ad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801070b2:	e9 f2 f4 ff ff       	jmp    801065a9 <alltraps>

801070b7 <vector164>:
.globl vector164
vector164:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $164
801070b9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801070be:	e9 e6 f4 ff ff       	jmp    801065a9 <alltraps>

801070c3 <vector165>:
.globl vector165
vector165:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $165
801070c5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801070ca:	e9 da f4 ff ff       	jmp    801065a9 <alltraps>

801070cf <vector166>:
.globl vector166
vector166:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $166
801070d1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801070d6:	e9 ce f4 ff ff       	jmp    801065a9 <alltraps>

801070db <vector167>:
.globl vector167
vector167:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $167
801070dd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801070e2:	e9 c2 f4 ff ff       	jmp    801065a9 <alltraps>

801070e7 <vector168>:
.globl vector168
vector168:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $168
801070e9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801070ee:	e9 b6 f4 ff ff       	jmp    801065a9 <alltraps>

801070f3 <vector169>:
.globl vector169
vector169:
  pushl $0
801070f3:	6a 00                	push   $0x0
  pushl $169
801070f5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801070fa:	e9 aa f4 ff ff       	jmp    801065a9 <alltraps>

801070ff <vector170>:
.globl vector170
vector170:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $170
80107101:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107106:	e9 9e f4 ff ff       	jmp    801065a9 <alltraps>

8010710b <vector171>:
.globl vector171
vector171:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $171
8010710d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107112:	e9 92 f4 ff ff       	jmp    801065a9 <alltraps>

80107117 <vector172>:
.globl vector172
vector172:
  pushl $0
80107117:	6a 00                	push   $0x0
  pushl $172
80107119:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010711e:	e9 86 f4 ff ff       	jmp    801065a9 <alltraps>

80107123 <vector173>:
.globl vector173
vector173:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $173
80107125:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010712a:	e9 7a f4 ff ff       	jmp    801065a9 <alltraps>

8010712f <vector174>:
.globl vector174
vector174:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $174
80107131:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107136:	e9 6e f4 ff ff       	jmp    801065a9 <alltraps>

8010713b <vector175>:
.globl vector175
vector175:
  pushl $0
8010713b:	6a 00                	push   $0x0
  pushl $175
8010713d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107142:	e9 62 f4 ff ff       	jmp    801065a9 <alltraps>

80107147 <vector176>:
.globl vector176
vector176:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $176
80107149:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010714e:	e9 56 f4 ff ff       	jmp    801065a9 <alltraps>

80107153 <vector177>:
.globl vector177
vector177:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $177
80107155:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010715a:	e9 4a f4 ff ff       	jmp    801065a9 <alltraps>

8010715f <vector178>:
.globl vector178
vector178:
  pushl $0
8010715f:	6a 00                	push   $0x0
  pushl $178
80107161:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107166:	e9 3e f4 ff ff       	jmp    801065a9 <alltraps>

8010716b <vector179>:
.globl vector179
vector179:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $179
8010716d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107172:	e9 32 f4 ff ff       	jmp    801065a9 <alltraps>

80107177 <vector180>:
.globl vector180
vector180:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $180
80107179:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010717e:	e9 26 f4 ff ff       	jmp    801065a9 <alltraps>

80107183 <vector181>:
.globl vector181
vector181:
  pushl $0
80107183:	6a 00                	push   $0x0
  pushl $181
80107185:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010718a:	e9 1a f4 ff ff       	jmp    801065a9 <alltraps>

8010718f <vector182>:
.globl vector182
vector182:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $182
80107191:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107196:	e9 0e f4 ff ff       	jmp    801065a9 <alltraps>

8010719b <vector183>:
.globl vector183
vector183:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $183
8010719d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801071a2:	e9 02 f4 ff ff       	jmp    801065a9 <alltraps>

801071a7 <vector184>:
.globl vector184
vector184:
  pushl $0
801071a7:	6a 00                	push   $0x0
  pushl $184
801071a9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801071ae:	e9 f6 f3 ff ff       	jmp    801065a9 <alltraps>

801071b3 <vector185>:
.globl vector185
vector185:
  pushl $0
801071b3:	6a 00                	push   $0x0
  pushl $185
801071b5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801071ba:	e9 ea f3 ff ff       	jmp    801065a9 <alltraps>

801071bf <vector186>:
.globl vector186
vector186:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $186
801071c1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801071c6:	e9 de f3 ff ff       	jmp    801065a9 <alltraps>

801071cb <vector187>:
.globl vector187
vector187:
  pushl $0
801071cb:	6a 00                	push   $0x0
  pushl $187
801071cd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801071d2:	e9 d2 f3 ff ff       	jmp    801065a9 <alltraps>

801071d7 <vector188>:
.globl vector188
vector188:
  pushl $0
801071d7:	6a 00                	push   $0x0
  pushl $188
801071d9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801071de:	e9 c6 f3 ff ff       	jmp    801065a9 <alltraps>

801071e3 <vector189>:
.globl vector189
vector189:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $189
801071e5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801071ea:	e9 ba f3 ff ff       	jmp    801065a9 <alltraps>

801071ef <vector190>:
.globl vector190
vector190:
  pushl $0
801071ef:	6a 00                	push   $0x0
  pushl $190
801071f1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801071f6:	e9 ae f3 ff ff       	jmp    801065a9 <alltraps>

801071fb <vector191>:
.globl vector191
vector191:
  pushl $0
801071fb:	6a 00                	push   $0x0
  pushl $191
801071fd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107202:	e9 a2 f3 ff ff       	jmp    801065a9 <alltraps>

80107207 <vector192>:
.globl vector192
vector192:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $192
80107209:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010720e:	e9 96 f3 ff ff       	jmp    801065a9 <alltraps>

80107213 <vector193>:
.globl vector193
vector193:
  pushl $0
80107213:	6a 00                	push   $0x0
  pushl $193
80107215:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010721a:	e9 8a f3 ff ff       	jmp    801065a9 <alltraps>

8010721f <vector194>:
.globl vector194
vector194:
  pushl $0
8010721f:	6a 00                	push   $0x0
  pushl $194
80107221:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107226:	e9 7e f3 ff ff       	jmp    801065a9 <alltraps>

8010722b <vector195>:
.globl vector195
vector195:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $195
8010722d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107232:	e9 72 f3 ff ff       	jmp    801065a9 <alltraps>

80107237 <vector196>:
.globl vector196
vector196:
  pushl $0
80107237:	6a 00                	push   $0x0
  pushl $196
80107239:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010723e:	e9 66 f3 ff ff       	jmp    801065a9 <alltraps>

80107243 <vector197>:
.globl vector197
vector197:
  pushl $0
80107243:	6a 00                	push   $0x0
  pushl $197
80107245:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010724a:	e9 5a f3 ff ff       	jmp    801065a9 <alltraps>

8010724f <vector198>:
.globl vector198
vector198:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $198
80107251:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107256:	e9 4e f3 ff ff       	jmp    801065a9 <alltraps>

8010725b <vector199>:
.globl vector199
vector199:
  pushl $0
8010725b:	6a 00                	push   $0x0
  pushl $199
8010725d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107262:	e9 42 f3 ff ff       	jmp    801065a9 <alltraps>

80107267 <vector200>:
.globl vector200
vector200:
  pushl $0
80107267:	6a 00                	push   $0x0
  pushl $200
80107269:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010726e:	e9 36 f3 ff ff       	jmp    801065a9 <alltraps>

80107273 <vector201>:
.globl vector201
vector201:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $201
80107275:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010727a:	e9 2a f3 ff ff       	jmp    801065a9 <alltraps>

8010727f <vector202>:
.globl vector202
vector202:
  pushl $0
8010727f:	6a 00                	push   $0x0
  pushl $202
80107281:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107286:	e9 1e f3 ff ff       	jmp    801065a9 <alltraps>

8010728b <vector203>:
.globl vector203
vector203:
  pushl $0
8010728b:	6a 00                	push   $0x0
  pushl $203
8010728d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107292:	e9 12 f3 ff ff       	jmp    801065a9 <alltraps>

80107297 <vector204>:
.globl vector204
vector204:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $204
80107299:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010729e:	e9 06 f3 ff ff       	jmp    801065a9 <alltraps>

801072a3 <vector205>:
.globl vector205
vector205:
  pushl $0
801072a3:	6a 00                	push   $0x0
  pushl $205
801072a5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801072aa:	e9 fa f2 ff ff       	jmp    801065a9 <alltraps>

801072af <vector206>:
.globl vector206
vector206:
  pushl $0
801072af:	6a 00                	push   $0x0
  pushl $206
801072b1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801072b6:	e9 ee f2 ff ff       	jmp    801065a9 <alltraps>

801072bb <vector207>:
.globl vector207
vector207:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $207
801072bd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801072c2:	e9 e2 f2 ff ff       	jmp    801065a9 <alltraps>

801072c7 <vector208>:
.globl vector208
vector208:
  pushl $0
801072c7:	6a 00                	push   $0x0
  pushl $208
801072c9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801072ce:	e9 d6 f2 ff ff       	jmp    801065a9 <alltraps>

801072d3 <vector209>:
.globl vector209
vector209:
  pushl $0
801072d3:	6a 00                	push   $0x0
  pushl $209
801072d5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801072da:	e9 ca f2 ff ff       	jmp    801065a9 <alltraps>

801072df <vector210>:
.globl vector210
vector210:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $210
801072e1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801072e6:	e9 be f2 ff ff       	jmp    801065a9 <alltraps>

801072eb <vector211>:
.globl vector211
vector211:
  pushl $0
801072eb:	6a 00                	push   $0x0
  pushl $211
801072ed:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801072f2:	e9 b2 f2 ff ff       	jmp    801065a9 <alltraps>

801072f7 <vector212>:
.globl vector212
vector212:
  pushl $0
801072f7:	6a 00                	push   $0x0
  pushl $212
801072f9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801072fe:	e9 a6 f2 ff ff       	jmp    801065a9 <alltraps>

80107303 <vector213>:
.globl vector213
vector213:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $213
80107305:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010730a:	e9 9a f2 ff ff       	jmp    801065a9 <alltraps>

8010730f <vector214>:
.globl vector214
vector214:
  pushl $0
8010730f:	6a 00                	push   $0x0
  pushl $214
80107311:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107316:	e9 8e f2 ff ff       	jmp    801065a9 <alltraps>

8010731b <vector215>:
.globl vector215
vector215:
  pushl $0
8010731b:	6a 00                	push   $0x0
  pushl $215
8010731d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107322:	e9 82 f2 ff ff       	jmp    801065a9 <alltraps>

80107327 <vector216>:
.globl vector216
vector216:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $216
80107329:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010732e:	e9 76 f2 ff ff       	jmp    801065a9 <alltraps>

80107333 <vector217>:
.globl vector217
vector217:
  pushl $0
80107333:	6a 00                	push   $0x0
  pushl $217
80107335:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010733a:	e9 6a f2 ff ff       	jmp    801065a9 <alltraps>

8010733f <vector218>:
.globl vector218
vector218:
  pushl $0
8010733f:	6a 00                	push   $0x0
  pushl $218
80107341:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107346:	e9 5e f2 ff ff       	jmp    801065a9 <alltraps>

8010734b <vector219>:
.globl vector219
vector219:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $219
8010734d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107352:	e9 52 f2 ff ff       	jmp    801065a9 <alltraps>

80107357 <vector220>:
.globl vector220
vector220:
  pushl $0
80107357:	6a 00                	push   $0x0
  pushl $220
80107359:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010735e:	e9 46 f2 ff ff       	jmp    801065a9 <alltraps>

80107363 <vector221>:
.globl vector221
vector221:
  pushl $0
80107363:	6a 00                	push   $0x0
  pushl $221
80107365:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010736a:	e9 3a f2 ff ff       	jmp    801065a9 <alltraps>

8010736f <vector222>:
.globl vector222
vector222:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $222
80107371:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107376:	e9 2e f2 ff ff       	jmp    801065a9 <alltraps>

8010737b <vector223>:
.globl vector223
vector223:
  pushl $0
8010737b:	6a 00                	push   $0x0
  pushl $223
8010737d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107382:	e9 22 f2 ff ff       	jmp    801065a9 <alltraps>

80107387 <vector224>:
.globl vector224
vector224:
  pushl $0
80107387:	6a 00                	push   $0x0
  pushl $224
80107389:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010738e:	e9 16 f2 ff ff       	jmp    801065a9 <alltraps>

80107393 <vector225>:
.globl vector225
vector225:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $225
80107395:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010739a:	e9 0a f2 ff ff       	jmp    801065a9 <alltraps>

8010739f <vector226>:
.globl vector226
vector226:
  pushl $0
8010739f:	6a 00                	push   $0x0
  pushl $226
801073a1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801073a6:	e9 fe f1 ff ff       	jmp    801065a9 <alltraps>

801073ab <vector227>:
.globl vector227
vector227:
  pushl $0
801073ab:	6a 00                	push   $0x0
  pushl $227
801073ad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801073b2:	e9 f2 f1 ff ff       	jmp    801065a9 <alltraps>

801073b7 <vector228>:
.globl vector228
vector228:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $228
801073b9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801073be:	e9 e6 f1 ff ff       	jmp    801065a9 <alltraps>

801073c3 <vector229>:
.globl vector229
vector229:
  pushl $0
801073c3:	6a 00                	push   $0x0
  pushl $229
801073c5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801073ca:	e9 da f1 ff ff       	jmp    801065a9 <alltraps>

801073cf <vector230>:
.globl vector230
vector230:
  pushl $0
801073cf:	6a 00                	push   $0x0
  pushl $230
801073d1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801073d6:	e9 ce f1 ff ff       	jmp    801065a9 <alltraps>

801073db <vector231>:
.globl vector231
vector231:
  pushl $0
801073db:	6a 00                	push   $0x0
  pushl $231
801073dd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801073e2:	e9 c2 f1 ff ff       	jmp    801065a9 <alltraps>

801073e7 <vector232>:
.globl vector232
vector232:
  pushl $0
801073e7:	6a 00                	push   $0x0
  pushl $232
801073e9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801073ee:	e9 b6 f1 ff ff       	jmp    801065a9 <alltraps>

801073f3 <vector233>:
.globl vector233
vector233:
  pushl $0
801073f3:	6a 00                	push   $0x0
  pushl $233
801073f5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801073fa:	e9 aa f1 ff ff       	jmp    801065a9 <alltraps>

801073ff <vector234>:
.globl vector234
vector234:
  pushl $0
801073ff:	6a 00                	push   $0x0
  pushl $234
80107401:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107406:	e9 9e f1 ff ff       	jmp    801065a9 <alltraps>

8010740b <vector235>:
.globl vector235
vector235:
  pushl $0
8010740b:	6a 00                	push   $0x0
  pushl $235
8010740d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107412:	e9 92 f1 ff ff       	jmp    801065a9 <alltraps>

80107417 <vector236>:
.globl vector236
vector236:
  pushl $0
80107417:	6a 00                	push   $0x0
  pushl $236
80107419:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010741e:	e9 86 f1 ff ff       	jmp    801065a9 <alltraps>

80107423 <vector237>:
.globl vector237
vector237:
  pushl $0
80107423:	6a 00                	push   $0x0
  pushl $237
80107425:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010742a:	e9 7a f1 ff ff       	jmp    801065a9 <alltraps>

8010742f <vector238>:
.globl vector238
vector238:
  pushl $0
8010742f:	6a 00                	push   $0x0
  pushl $238
80107431:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107436:	e9 6e f1 ff ff       	jmp    801065a9 <alltraps>

8010743b <vector239>:
.globl vector239
vector239:
  pushl $0
8010743b:	6a 00                	push   $0x0
  pushl $239
8010743d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107442:	e9 62 f1 ff ff       	jmp    801065a9 <alltraps>

80107447 <vector240>:
.globl vector240
vector240:
  pushl $0
80107447:	6a 00                	push   $0x0
  pushl $240
80107449:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010744e:	e9 56 f1 ff ff       	jmp    801065a9 <alltraps>

80107453 <vector241>:
.globl vector241
vector241:
  pushl $0
80107453:	6a 00                	push   $0x0
  pushl $241
80107455:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010745a:	e9 4a f1 ff ff       	jmp    801065a9 <alltraps>

8010745f <vector242>:
.globl vector242
vector242:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $242
80107461:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107466:	e9 3e f1 ff ff       	jmp    801065a9 <alltraps>

8010746b <vector243>:
.globl vector243
vector243:
  pushl $0
8010746b:	6a 00                	push   $0x0
  pushl $243
8010746d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107472:	e9 32 f1 ff ff       	jmp    801065a9 <alltraps>

80107477 <vector244>:
.globl vector244
vector244:
  pushl $0
80107477:	6a 00                	push   $0x0
  pushl $244
80107479:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010747e:	e9 26 f1 ff ff       	jmp    801065a9 <alltraps>

80107483 <vector245>:
.globl vector245
vector245:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $245
80107485:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010748a:	e9 1a f1 ff ff       	jmp    801065a9 <alltraps>

8010748f <vector246>:
.globl vector246
vector246:
  pushl $0
8010748f:	6a 00                	push   $0x0
  pushl $246
80107491:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107496:	e9 0e f1 ff ff       	jmp    801065a9 <alltraps>

8010749b <vector247>:
.globl vector247
vector247:
  pushl $0
8010749b:	6a 00                	push   $0x0
  pushl $247
8010749d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801074a2:	e9 02 f1 ff ff       	jmp    801065a9 <alltraps>

801074a7 <vector248>:
.globl vector248
vector248:
  pushl $0
801074a7:	6a 00                	push   $0x0
  pushl $248
801074a9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801074ae:	e9 f6 f0 ff ff       	jmp    801065a9 <alltraps>

801074b3 <vector249>:
.globl vector249
vector249:
  pushl $0
801074b3:	6a 00                	push   $0x0
  pushl $249
801074b5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801074ba:	e9 ea f0 ff ff       	jmp    801065a9 <alltraps>

801074bf <vector250>:
.globl vector250
vector250:
  pushl $0
801074bf:	6a 00                	push   $0x0
  pushl $250
801074c1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801074c6:	e9 de f0 ff ff       	jmp    801065a9 <alltraps>

801074cb <vector251>:
.globl vector251
vector251:
  pushl $0
801074cb:	6a 00                	push   $0x0
  pushl $251
801074cd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801074d2:	e9 d2 f0 ff ff       	jmp    801065a9 <alltraps>

801074d7 <vector252>:
.globl vector252
vector252:
  pushl $0
801074d7:	6a 00                	push   $0x0
  pushl $252
801074d9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801074de:	e9 c6 f0 ff ff       	jmp    801065a9 <alltraps>

801074e3 <vector253>:
.globl vector253
vector253:
  pushl $0
801074e3:	6a 00                	push   $0x0
  pushl $253
801074e5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801074ea:	e9 ba f0 ff ff       	jmp    801065a9 <alltraps>

801074ef <vector254>:
.globl vector254
vector254:
  pushl $0
801074ef:	6a 00                	push   $0x0
  pushl $254
801074f1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801074f6:	e9 ae f0 ff ff       	jmp    801065a9 <alltraps>

801074fb <vector255>:
.globl vector255
vector255:
  pushl $0
801074fb:	6a 00                	push   $0x0
  pushl $255
801074fd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107502:	e9 a2 f0 ff ff       	jmp    801065a9 <alltraps>
80107507:	66 90                	xchg   %ax,%ax
80107509:	66 90                	xchg   %ax,%ax
8010750b:	66 90                	xchg   %ax,%ax
8010750d:	66 90                	xchg   %ax,%ax
8010750f:	90                   	nop

80107510 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107510:	55                   	push   %ebp
80107511:	89 e5                	mov    %esp,%ebp
80107513:	57                   	push   %edi
80107514:	56                   	push   %esi
80107515:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;
  pde = &pgdir[PDX(va)];
80107516:	89 d3                	mov    %edx,%ebx
{
80107518:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010751a:	c1 eb 16             	shr    $0x16,%ebx
8010751d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80107520:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107523:	8b 06                	mov    (%esi),%eax
80107525:	a8 01                	test   $0x1,%al
80107527:	74 27                	je     80107550 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107529:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010752e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107534:	c1 ef 0a             	shr    $0xa,%edi
}
80107537:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010753a:	89 fa                	mov    %edi,%edx
8010753c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107542:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80107545:	5b                   	pop    %ebx
80107546:	5e                   	pop    %esi
80107547:	5f                   	pop    %edi
80107548:	5d                   	pop    %ebp
80107549:	c3                   	ret    
8010754a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107550:	85 c9                	test   %ecx,%ecx
80107552:	74 2c                	je     80107580 <walkpgdir+0x70>
80107554:	e8 d7 b7 ff ff       	call   80102d30 <kalloc>
80107559:	85 c0                	test   %eax,%eax
8010755b:	89 c3                	mov    %eax,%ebx
8010755d:	74 21                	je     80107580 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010755f:	83 ec 04             	sub    $0x4,%esp
80107562:	68 00 10 00 00       	push   $0x1000
80107567:	6a 00                	push   $0x0
80107569:	50                   	push   %eax
8010756a:	e8 f1 dd ff ff       	call   80105360 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010756f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107575:	83 c4 10             	add    $0x10,%esp
80107578:	83 c8 07             	or     $0x7,%eax
8010757b:	89 06                	mov    %eax,(%esi)
8010757d:	eb b5                	jmp    80107534 <walkpgdir+0x24>
8010757f:	90                   	nop
}
80107580:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107583:	31 c0                	xor    %eax,%eax
}
80107585:	5b                   	pop    %ebx
80107586:	5e                   	pop    %esi
80107587:	5f                   	pop    %edi
80107588:	5d                   	pop    %ebp
80107589:	c3                   	ret    
8010758a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107590 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107590:	55                   	push   %ebp
80107591:	89 e5                	mov    %esp,%ebp
80107593:	57                   	push   %edi
80107594:	56                   	push   %esi
80107595:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107596:	89 d3                	mov    %edx,%ebx
80107598:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010759e:	83 ec 1c             	sub    $0x1c,%esp
801075a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801075a4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801075a8:	8b 7d 08             	mov    0x8(%ebp),%edi
801075ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801075b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801075b6:	29 df                	sub    %ebx,%edi
801075b8:	83 c8 01             	or     $0x1,%eax
801075bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801075be:	eb 15                	jmp    801075d5 <mappages+0x45>
    if(*pte & PTE_P)
801075c0:	f6 00 01             	testb  $0x1,(%eax)
801075c3:	75 45                	jne    8010760a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
801075c5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
801075c8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801075cb:	89 30                	mov    %esi,(%eax)
    if(a == last)
801075cd:	74 31                	je     80107600 <mappages+0x70>
      break;
    a += PGSIZE;
801075cf:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801075d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d8:	b9 01 00 00 00       	mov    $0x1,%ecx
801075dd:	89 da                	mov    %ebx,%edx
801075df:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801075e2:	e8 29 ff ff ff       	call   80107510 <walkpgdir>
801075e7:	85 c0                	test   %eax,%eax
801075e9:	75 d5                	jne    801075c0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801075eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801075ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075f3:	5b                   	pop    %ebx
801075f4:	5e                   	pop    %esi
801075f5:	5f                   	pop    %edi
801075f6:	5d                   	pop    %ebp
801075f7:	c3                   	ret    
801075f8:	90                   	nop
801075f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107600:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107603:	31 c0                	xor    %eax,%eax
}
80107605:	5b                   	pop    %ebx
80107606:	5e                   	pop    %esi
80107607:	5f                   	pop    %edi
80107608:	5d                   	pop    %ebp
80107609:	c3                   	ret    
      panic("remap");
8010760a:	83 ec 0c             	sub    $0xc,%esp
8010760d:	68 14 9b 10 80       	push   $0x80109b14
80107612:	e8 79 8d ff ff       	call   80100390 <panic>
80107617:	89 f6                	mov    %esi,%esi
80107619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107620 <safe_kfree>:
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	53                   	push   %ebx
80107624:	83 ec 10             	sub    $0x10,%esp
80107627:	8b 5d 08             	mov    0x8(%ebp),%ebx
      if(getRefs(v) == 1)
8010762a:	53                   	push   %ebx
8010762b:	e8 90 b8 ff ff       	call   80102ec0 <getRefs>
80107630:	83 c4 10             	add    $0x10,%esp
80107633:	83 f8 01             	cmp    $0x1,%eax
        kfree(v);
80107636:	89 5d 08             	mov    %ebx,0x8(%ebp)
      if(getRefs(v) == 1)
80107639:	74 0d                	je     80107648 <safe_kfree+0x28>
}
8010763b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010763e:	c9                   	leave  
        refDec(v);
8010763f:	e9 9c b7 ff ff       	jmp    80102de0 <refDec>
80107644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80107648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010764b:	c9                   	leave  
        kfree(v);
8010764c:	e9 ff b3 ff ff       	jmp    80102a50 <kfree>
80107651:	eb 0d                	jmp    80107660 <printlist>
80107653:	90                   	nop
80107654:	90                   	nop
80107655:	90                   	nop
80107656:	90                   	nop
80107657:	90                   	nop
80107658:	90                   	nop
80107659:	90                   	nop
8010765a:	90                   	nop
8010765b:	90                   	nop
8010765c:	90                   	nop
8010765d:	90                   	nop
8010765e:	90                   	nop
8010765f:	90                   	nop

80107660 <printlist>:
{
80107660:	55                   	push   %ebp
80107661:	89 e5                	mov    %esp,%ebp
80107663:	56                   	push   %esi
80107664:	53                   	push   %ebx
  struct fblock *curr = myproc()->free_head;
80107665:	be 10 00 00 00       	mov    $0x10,%esi
  cprintf("printing list:\n");
8010766a:	83 ec 0c             	sub    $0xc,%esp
8010766d:	68 1a 9b 10 80       	push   $0x80109b1a
80107672:	e8 e9 8f ff ff       	call   80100660 <cprintf>
  struct fblock *curr = myproc()->free_head;
80107677:	e8 44 cc ff ff       	call   801042c0 <myproc>
8010767c:	83 c4 10             	add    $0x10,%esp
8010767f:	8b 98 14 04 00 00    	mov    0x414(%eax),%ebx
80107685:	eb 0e                	jmp    80107695 <printlist+0x35>
80107687:	89 f6                	mov    %esi,%esi
80107689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  for(int i = 0; i < MAX_PSYC_PAGES; i++)
80107690:	83 ee 01             	sub    $0x1,%esi
80107693:	74 19                	je     801076ae <printlist+0x4e>
    cprintf("%d -> ", curr->off);
80107695:	83 ec 08             	sub    $0x8,%esp
80107698:	ff 33                	pushl  (%ebx)
8010769a:	68 2a 9b 10 80       	push   $0x80109b2a
8010769f:	e8 bc 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
801076a4:	8b 5b 04             	mov    0x4(%ebx),%ebx
    if(curr == 0)
801076a7:	83 c4 10             	add    $0x10,%esp
801076aa:	85 db                	test   %ebx,%ebx
801076ac:	75 e2                	jne    80107690 <printlist+0x30>
  cprintf("\n");
801076ae:	83 ec 0c             	sub    $0xc,%esp
801076b1:	68 40 9c 10 80       	push   $0x80109c40
801076b6:	e8 a5 8f ff ff       	call   80100660 <cprintf>
}
801076bb:	83 c4 10             	add    $0x10,%esp
801076be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801076c1:	5b                   	pop    %ebx
801076c2:	5e                   	pop    %esi
801076c3:	5d                   	pop    %ebp
801076c4:	c3                   	ret    
801076c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076d0 <printaq>:
{
801076d0:	55                   	push   %ebp
801076d1:	89 e5                	mov    %esp,%ebp
801076d3:	53                   	push   %ebx
801076d4:	83 ec 10             	sub    $0x10,%esp
  cprintf("\n\n\n\nprinting aq:\n");
801076d7:	68 31 9b 10 80       	push   $0x80109b31
801076dc:	e8 7f 8f ff ff       	call   80100660 <cprintf>
  cprintf("head: %d, tail: %d\n", myproc()->queue_head->page_index, myproc()->queue_tail->page_index);
801076e1:	e8 da cb ff ff       	call   801042c0 <myproc>
801076e6:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
801076ec:	8b 58 08             	mov    0x8(%eax),%ebx
801076ef:	e8 cc cb ff ff       	call   801042c0 <myproc>
801076f4:	83 c4 0c             	add    $0xc,%esp
801076f7:	53                   	push   %ebx
801076f8:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
801076fe:	ff 70 08             	pushl  0x8(%eax)
80107701:	68 43 9b 10 80       	push   $0x80109b43
80107706:	e8 55 8f ff ff       	call   80100660 <cprintf>
  if(myproc()->queue_head->prev == 0)
8010770b:	e8 b0 cb ff ff       	call   801042c0 <myproc>
80107710:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80107716:	83 c4 10             	add    $0x10,%esp
80107719:	8b 50 04             	mov    0x4(%eax),%edx
8010771c:	85 d2                	test   %edx,%edx
8010771e:	74 68                	je     80107788 <printaq+0xb8>
  struct queue_node *curr = myproc()->queue_head;
80107720:	e8 9b cb ff ff       	call   801042c0 <myproc>
80107725:	8b 98 1c 04 00 00    	mov    0x41c(%eax),%ebx
  while(curr != 0)
8010772b:	85 db                	test   %ebx,%ebx
8010772d:	74 1a                	je     80107749 <printaq+0x79>
8010772f:	90                   	nop
    cprintf("%d <-> ", curr->page_index);
80107730:	83 ec 08             	sub    $0x8,%esp
80107733:	ff 73 08             	pushl  0x8(%ebx)
80107736:	68 61 9b 10 80       	push   $0x80109b61
8010773b:	e8 20 8f ff ff       	call   80100660 <cprintf>
    curr = curr->next;
80107740:	8b 1b                	mov    (%ebx),%ebx
  while(curr != 0)
80107742:	83 c4 10             	add    $0x10,%esp
80107745:	85 db                	test   %ebx,%ebx
80107747:	75 e7                	jne    80107730 <printaq+0x60>
  if(myproc()->queue_tail->next == 0)
80107749:	e8 72 cb ff ff       	call   801042c0 <myproc>
8010774e:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80107754:	8b 00                	mov    (%eax),%eax
80107756:	85 c0                	test   %eax,%eax
80107758:	74 16                	je     80107770 <printaq+0xa0>
  cprintf("\n");
8010775a:	83 ec 0c             	sub    $0xc,%esp
8010775d:	68 40 9c 10 80       	push   $0x80109c40
80107762:	e8 f9 8e ff ff       	call   80100660 <cprintf>
}
80107767:	83 c4 10             	add    $0x10,%esp
8010776a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010776d:	c9                   	leave  
8010776e:	c3                   	ret    
8010776f:	90                   	nop
    cprintf("null <-> ");
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	68 57 9b 10 80       	push   $0x80109b57
80107778:	e8 e3 8e ff ff       	call   80100660 <cprintf>
8010777d:	83 c4 10             	add    $0x10,%esp
80107780:	eb d8                	jmp    8010775a <printaq+0x8a>
80107782:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("null <-> ");
80107788:	83 ec 0c             	sub    $0xc,%esp
8010778b:	68 57 9b 10 80       	push   $0x80109b57
80107790:	e8 cb 8e ff ff       	call   80100660 <cprintf>
80107795:	83 c4 10             	add    $0x10,%esp
80107798:	eb 86                	jmp    80107720 <printaq+0x50>
8010779a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077a0 <seginit>:
{
801077a0:	55                   	push   %ebp
801077a1:	89 e5                	mov    %esp,%ebp
801077a3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801077a6:	e8 f5 ca ff ff       	call   801042a0 <cpuid>
801077ab:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
801077b1:	ba 2f 00 00 00       	mov    $0x2f,%edx
801077b6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077ba:	c7 80 d8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a428(%eax)
801077c1:	ff 00 00 
801077c4:	c7 80 dc 5b 18 80 00 	movl   $0xcf9a00,-0x7fe7a424(%eax)
801077cb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801077ce:	c7 80 e0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a420(%eax)
801077d5:	ff 00 00 
801077d8:	c7 80 e4 5b 18 80 00 	movl   $0xcf9200,-0x7fe7a41c(%eax)
801077df:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801077e2:	c7 80 e8 5b 18 80 ff 	movl   $0xffff,-0x7fe7a418(%eax)
801077e9:	ff 00 00 
801077ec:	c7 80 ec 5b 18 80 00 	movl   $0xcffa00,-0x7fe7a414(%eax)
801077f3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801077f6:	c7 80 f0 5b 18 80 ff 	movl   $0xffff,-0x7fe7a410(%eax)
801077fd:	ff 00 00 
80107800:	c7 80 f4 5b 18 80 00 	movl   $0xcff200,-0x7fe7a40c(%eax)
80107807:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010780a:	05 d0 5b 18 80       	add    $0x80185bd0,%eax
  pd[1] = (uint)p;
8010780f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107813:	c1 e8 10             	shr    $0x10,%eax
80107816:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010781a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010781d:	0f 01 10             	lgdtl  (%eax)
}
80107820:	c9                   	leave  
80107821:	c3                   	ret    
80107822:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107830 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107830:	a1 84 75 19 80       	mov    0x80197584,%eax
{
80107835:	55                   	push   %ebp
80107836:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107838:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010783d:	0f 22 d8             	mov    %eax,%cr3
}
80107840:	5d                   	pop    %ebp
80107841:	c3                   	ret    
80107842:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107850 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107850:	55                   	push   %ebp
80107851:	89 e5                	mov    %esp,%ebp
80107853:	57                   	push   %edi
80107854:	56                   	push   %esi
80107855:	53                   	push   %ebx
80107856:	83 ec 1c             	sub    $0x1c,%esp
80107859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010785c:	85 db                	test   %ebx,%ebx
8010785e:	0f 84 cb 00 00 00    	je     8010792f <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80107864:	8b 43 08             	mov    0x8(%ebx),%eax
80107867:	85 c0                	test   %eax,%eax
80107869:	0f 84 da 00 00 00    	je     80107949 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010786f:	8b 43 04             	mov    0x4(%ebx),%eax
80107872:	85 c0                	test   %eax,%eax
80107874:	0f 84 c2 00 00 00    	je     8010793c <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
8010787a:	e8 01 d9 ff ff       	call   80105180 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010787f:	e8 9c c9 ff ff       	call   80104220 <mycpu>
80107884:	89 c6                	mov    %eax,%esi
80107886:	e8 95 c9 ff ff       	call   80104220 <mycpu>
8010788b:	89 c7                	mov    %eax,%edi
8010788d:	e8 8e c9 ff ff       	call   80104220 <mycpu>
80107892:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107895:	83 c7 08             	add    $0x8,%edi
80107898:	e8 83 c9 ff ff       	call   80104220 <mycpu>
8010789d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801078a0:	83 c0 08             	add    $0x8,%eax
801078a3:	ba 67 00 00 00       	mov    $0x67,%edx
801078a8:	c1 e8 18             	shr    $0x18,%eax
801078ab:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
801078b2:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
801078b9:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801078bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801078c4:	83 c1 08             	add    $0x8,%ecx
801078c7:	c1 e9 10             	shr    $0x10,%ecx
801078ca:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801078d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801078d5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801078dc:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801078e1:	e8 3a c9 ff ff       	call   80104220 <mycpu>
801078e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801078ed:	e8 2e c9 ff ff       	call   80104220 <mycpu>
801078f2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801078f6:	8b 73 08             	mov    0x8(%ebx),%esi
801078f9:	e8 22 c9 ff ff       	call   80104220 <mycpu>
801078fe:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107904:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107907:	e8 14 c9 ff ff       	call   80104220 <mycpu>
8010790c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107910:	b8 28 00 00 00       	mov    $0x28,%eax
80107915:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107918:	8b 43 04             	mov    0x4(%ebx),%eax
8010791b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107920:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80107923:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107926:	5b                   	pop    %ebx
80107927:	5e                   	pop    %esi
80107928:	5f                   	pop    %edi
80107929:	5d                   	pop    %ebp
  popcli();
8010792a:	e9 91 d8 ff ff       	jmp    801051c0 <popcli>
    panic("switchuvm: no process");
8010792f:	83 ec 0c             	sub    $0xc,%esp
80107932:	68 69 9b 10 80       	push   $0x80109b69
80107937:	e8 54 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010793c:	83 ec 0c             	sub    $0xc,%esp
8010793f:	68 94 9b 10 80       	push   $0x80109b94
80107944:	e8 47 8a ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107949:	83 ec 0c             	sub    $0xc,%esp
8010794c:	68 7f 9b 10 80       	push   $0x80109b7f
80107951:	e8 3a 8a ff ff       	call   80100390 <panic>
80107956:	8d 76 00             	lea    0x0(%esi),%esi
80107959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107960 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107960:	55                   	push   %ebp
80107961:	89 e5                	mov    %esp,%ebp
80107963:	57                   	push   %edi
80107964:	56                   	push   %esi
80107965:	53                   	push   %ebx
80107966:	83 ec 1c             	sub    $0x1c,%esp
80107969:	8b 75 10             	mov    0x10(%ebp),%esi
8010796c:	8b 45 08             	mov    0x8(%ebp),%eax
8010796f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80107972:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107978:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010797b:	77 49                	ja     801079c6 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
8010797d:	e8 ae b3 ff ff       	call   80102d30 <kalloc>
  memset(mem, 0, PGSIZE);
80107982:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107985:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107987:	68 00 10 00 00       	push   $0x1000
8010798c:	6a 00                	push   $0x0
8010798e:	50                   	push   %eax
8010798f:	e8 cc d9 ff ff       	call   80105360 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107994:	58                   	pop    %eax
80107995:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010799b:	b9 00 10 00 00       	mov    $0x1000,%ecx
801079a0:	5a                   	pop    %edx
801079a1:	6a 06                	push   $0x6
801079a3:	50                   	push   %eax
801079a4:	31 d2                	xor    %edx,%edx
801079a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079a9:	e8 e2 fb ff ff       	call   80107590 <mappages>
  memmove(mem, init, sz);
801079ae:	89 75 10             	mov    %esi,0x10(%ebp)
801079b1:	89 7d 0c             	mov    %edi,0xc(%ebp)
801079b4:	83 c4 10             	add    $0x10,%esp
801079b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801079ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801079bd:	5b                   	pop    %ebx
801079be:	5e                   	pop    %esi
801079bf:	5f                   	pop    %edi
801079c0:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801079c1:	e9 4a da ff ff       	jmp    80105410 <memmove>
    panic("inituvm: more than a page");
801079c6:	83 ec 0c             	sub    $0xc,%esp
801079c9:	68 a8 9b 10 80       	push   $0x80109ba8
801079ce:	e8 bd 89 ff ff       	call   80100390 <panic>
801079d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801079d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079e0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801079e0:	55                   	push   %ebp
801079e1:	89 e5                	mov    %esp,%ebp
801079e3:	57                   	push   %edi
801079e4:	56                   	push   %esi
801079e5:	53                   	push   %ebx
801079e6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801079e9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801079f0:	0f 85 91 00 00 00    	jne    80107a87 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801079f6:	8b 75 18             	mov    0x18(%ebp),%esi
801079f9:	31 db                	xor    %ebx,%ebx
801079fb:	85 f6                	test   %esi,%esi
801079fd:	75 1a                	jne    80107a19 <loaduvm+0x39>
801079ff:	eb 6f                	jmp    80107a70 <loaduvm+0x90>
80107a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a08:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107a0e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80107a14:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80107a17:	76 57                	jbe    80107a70 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107a19:	8b 55 0c             	mov    0xc(%ebp),%edx
80107a1c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a1f:	31 c9                	xor    %ecx,%ecx
80107a21:	01 da                	add    %ebx,%edx
80107a23:	e8 e8 fa ff ff       	call   80107510 <walkpgdir>
80107a28:	85 c0                	test   %eax,%eax
80107a2a:	74 4e                	je     80107a7a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80107a2c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107a31:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107a36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107a3b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80107a41:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107a44:	01 d9                	add    %ebx,%ecx
80107a46:	05 00 00 00 80       	add    $0x80000000,%eax
80107a4b:	57                   	push   %edi
80107a4c:	51                   	push   %ecx
80107a4d:	50                   	push   %eax
80107a4e:	ff 75 10             	pushl  0x10(%ebp)
80107a51:	e8 ba a2 ff ff       	call   80101d10 <readi>
80107a56:	83 c4 10             	add    $0x10,%esp
80107a59:	39 f8                	cmp    %edi,%eax
80107a5b:	74 ab                	je     80107a08 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80107a5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107a65:	5b                   	pop    %ebx
80107a66:	5e                   	pop    %esi
80107a67:	5f                   	pop    %edi
80107a68:	5d                   	pop    %ebp
80107a69:	c3                   	ret    
80107a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107a73:	31 c0                	xor    %eax,%eax
}
80107a75:	5b                   	pop    %ebx
80107a76:	5e                   	pop    %esi
80107a77:	5f                   	pop    %edi
80107a78:	5d                   	pop    %ebp
80107a79:	c3                   	ret    
      panic("loaduvm: address should exist");
80107a7a:	83 ec 0c             	sub    $0xc,%esp
80107a7d:	68 c2 9b 10 80       	push   $0x80109bc2
80107a82:	e8 09 89 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107a87:	83 ec 0c             	sub    $0xc,%esp
80107a8a:	68 74 9d 10 80       	push   $0x80109d74
80107a8f:	e8 fc 88 ff ff       	call   80100390 <panic>
80107a94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107a9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107aa0 <allocuvm_noswap>:
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
    }
}

void allocuvm_noswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107aa0:	55                   	push   %ebp
80107aa1:	89 e5                	mov    %esp,%ebp
80107aa3:	53                   	push   %ebx
80107aa4:	8b 4d 08             	mov    0x8(%ebp),%ecx
// cprintf("allocuvm, not init or shell, there is space in RAM\n");

  struct page *page = &curproc->ramPages[curproc->num_ram];

  page->isused = 1;
  page->pgdir = pgdir;
80107aa7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct page *page = &curproc->ramPages[curproc->num_ram];
80107aaa:	8b 91 08 04 00 00    	mov    0x408(%ecx),%edx
  page->isused = 1;
80107ab0:	6b c2 1c             	imul   $0x1c,%edx,%eax
  update_selectionfiled_allocuvm(curproc, page, curproc->num_ram);

  // cprintf("filling ram slot: %d\n", curproc->num_ram);
  // cprintf("allocating addr : %p\n\n", rounded_virtaddr);

  curproc->num_ram++;
80107ab3:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107ab6:	01 c8                	add    %ecx,%eax
  page->pgdir = pgdir;
80107ab8:	89 98 48 02 00 00    	mov    %ebx,0x248(%eax)
  page->virt_addr = rounded_virtaddr;
80107abe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  page->isused = 1;
80107ac1:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107ac8:	00 00 00 
  page->swap_offset = -1;
80107acb:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107ad2:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107ad5:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107adb:	89 91 08 04 00 00    	mov    %edx,0x408(%ecx)
  
}
80107ae1:	5b                   	pop    %ebx
80107ae2:	5d                   	pop    %ebp
80107ae3:	c3                   	ret    
80107ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107af0 <allocuvm_withswap>:



void
allocuvm_withswap(struct proc* curproc, pde_t *pgdir, char* rounded_virtaddr)
{
80107af0:	55                   	push   %ebp
80107af1:	89 e5                	mov    %esp,%ebp
80107af3:	57                   	push   %edi
80107af4:	56                   	push   %esi
80107af5:	53                   	push   %ebx
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
   if(curproc-> num_swap >= MAX_PSYC_PAGES)
80107afc:	83 bb 0c 04 00 00 0f 	cmpl   $0xf,0x40c(%ebx)
80107b03:	0f 8f 1c 01 00 00    	jg     80107c25 <allocuvm_withswap+0x135>

      // get info of the page to be evicted
      uint evicted_ind = indexToEvict();
      // cprintf("[allocuvm] index to evict: %d\n",evicted_ind);
      struct page *evicted_page = &curproc->ramPages[evicted_ind];
      int swap_offset = curproc->free_head->off;
80107b09:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx

      if(curproc->free_head->next == 0)
80107b0f:	8b 42 04             	mov    0x4(%edx),%eax
      int swap_offset = curproc->free_head->off;
80107b12:	8b 32                	mov    (%edx),%esi
      if(curproc->free_head->next == 0)
80107b14:	85 c0                	test   %eax,%eax
80107b16:	0f 84 e4 00 00 00    	je     80107c00 <allocuvm_withswap+0x110>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80107b1c:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
80107b1f:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80107b25:	ff 70 08             	pushl  0x8(%eax)
80107b28:	e8 23 af ff ff       	call   80102a50 <kfree>
80107b2d:	83 c4 10             	add    $0x10,%esp
      }

      // cprintf("before write to swap\n");
      if(writeToSwapFile(curproc, evicted_page->virt_addr, swap_offset, PGSIZE) < 0)
80107b30:	68 00 10 00 00       	push   $0x1000
80107b35:	56                   	push   %esi
80107b36:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
80107b3c:	53                   	push   %ebx
80107b3d:	e8 be aa ff ff       	call   80102600 <writeToSwapFile>
80107b42:	83 c4 10             	add    $0x10,%esp
80107b45:	85 c0                	test   %eax,%eax
80107b47:	0f 88 f2 00 00 00    	js     80107c3f <allocuvm_withswap+0x14f>
        panic("allocuvm: writeToSwapFile");


      curproc->swappedPages[curproc->num_swap].isused = 1;
80107b4d:	8b bb 0c 04 00 00    	mov    0x40c(%ebx),%edi
80107b53:	6b cf 1c             	imul   $0x1c,%edi,%ecx
80107b56:	01 d9                	add    %ebx,%ecx
80107b58:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80107b5f:	00 00 00 
      curproc->swappedPages[curproc->num_swap].virt_addr = curproc->ramPages[evicted_ind].virt_addr;
80107b62:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80107b68:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107b6e:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      curproc->swappedPages[curproc->num_swap].swap_offset = swap_offset;
80107b74:	89 b1 94 00 00 00    	mov    %esi,0x94(%ecx)
      curproc->swappedPages[curproc->num_swap].pgdir = curproc->ramPages[evicted_ind].pgdir;
80107b7a:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      // cprintf("num swap: %d\n", curproc->num_swap);
      lcr3(V2P(curproc->swappedPages[curproc->num_swap].pgdir)); // flush TLB
80107b80:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80107b86:	0f 22 d9             	mov    %ecx,%cr3
      curproc->num_swap ++;
80107b89:	83 c7 01             	add    $0x1,%edi


      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b8c:	31 c9                	xor    %ecx,%ecx
      curproc->num_swap ++;
80107b8e:	89 bb 0c 04 00 00    	mov    %edi,0x40c(%ebx)
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b94:	e8 77 f9 ff ff       	call   80107510 <walkpgdir>



      if(!(*evicted_pte & PTE_P))
80107b99:	8b 10                	mov    (%eax),%edx
      pte_t *evicted_pte = walkpgdir(curproc->ramPages[evicted_ind].pgdir, (void*)curproc->ramPages[evicted_ind].virt_addr, 0);
80107b9b:	89 c6                	mov    %eax,%esi
      if(!(*evicted_pte & PTE_P))
80107b9d:	f6 c2 01             	test   $0x1,%dl
80107ba0:	0f 84 8c 00 00 00    	je     80107c32 <allocuvm_withswap+0x142>
        panic("allocuvm: swap: ram page not present");
      
      char *evicted_pa = (char*)PTE_ADDR(*evicted_pte);
80107ba6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      

      kfree(P2V(evicted_pa));
80107bac:	83 ec 0c             	sub    $0xc,%esp
80107baf:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107bb5:	52                   	push   %edx
80107bb6:	e8 95 ae ff ff       	call   80102a50 <kfree>

      *evicted_pte &= 0xFFF; // ???

      *evicted_pte |= PTE_PG;
      *evicted_pte &= ~PTE_P;
80107bbb:	8b 16                	mov    (%esi),%edx
    

      struct page *newpage = &curproc->ramPages[evicted_ind];
      newpage->isused = 1;
      newpage->pgdir = pgdir; // ??? 
80107bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
      newpage->swap_offset = -1;
      newpage->virt_addr = rounded_virtaddr;
      update_selectionfiled_allocuvm(curproc, newpage, evicted_ind);
     
}
80107bc0:	83 c4 10             	add    $0x10,%esp
      *evicted_pte &= ~PTE_P;
80107bc3:	81 e2 fe 0f 00 00    	and    $0xffe,%edx
80107bc9:	80 ce 02             	or     $0x2,%dh
80107bcc:	89 16                	mov    %edx,(%esi)
      newpage->pgdir = pgdir; // ??? 
80107bce:	89 83 9c 02 00 00    	mov    %eax,0x29c(%ebx)
      newpage->virt_addr = rounded_virtaddr;
80107bd4:	8b 45 10             	mov    0x10(%ebp),%eax
      newpage->isused = 1;
80107bd7:	c7 83 a0 02 00 00 01 	movl   $0x1,0x2a0(%ebx)
80107bde:	00 00 00 
      newpage->swap_offset = -1;
80107be1:	c7 83 a8 02 00 00 ff 	movl   $0xffffffff,0x2a8(%ebx)
80107be8:	ff ff ff 
      newpage->virt_addr = rounded_virtaddr;
80107beb:	89 83 a4 02 00 00    	mov    %eax,0x2a4(%ebx)
}
80107bf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107bf4:	5b                   	pop    %ebx
80107bf5:	5e                   	pop    %esi
80107bf6:	5f                   	pop    %edi
80107bf7:	5d                   	pop    %ebp
80107bf8:	c3                   	ret    
80107bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        kfree((char*)curproc->free_head);
80107c00:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
80107c03:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
80107c0a:	00 00 00 
        kfree((char*)curproc->free_head);
80107c0d:	52                   	push   %edx
80107c0e:	e8 3d ae ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
80107c13:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
80107c1a:	00 00 00 
80107c1d:	83 c4 10             	add    $0x10,%esp
80107c20:	e9 0b ff ff ff       	jmp    80107b30 <allocuvm_withswap+0x40>
        panic("page limit exceeded");
80107c25:	83 ec 0c             	sub    $0xc,%esp
80107c28:	68 e0 9b 10 80       	push   $0x80109be0
80107c2d:	e8 5e 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: swap: ram page not present");
80107c32:	83 ec 0c             	sub    $0xc,%esp
80107c35:	68 98 9d 10 80       	push   $0x80109d98
80107c3a:	e8 51 87 ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
80107c3f:	83 ec 0c             	sub    $0xc,%esp
80107c42:	68 f4 9b 10 80       	push   $0x80109bf4
80107c47:	e8 44 87 ff ff       	call   80100390 <panic>
80107c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107c50 <allocuvm_paging>:
{
80107c50:	55                   	push   %ebp
80107c51:	89 e5                	mov    %esp,%ebp
80107c53:	56                   	push   %esi
80107c54:	53                   	push   %ebx
80107c55:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107c58:	8b 75 0c             	mov    0xc(%ebp),%esi
80107c5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107c5e:	8b 81 08 04 00 00    	mov    0x408(%ecx),%eax
80107c64:	83 f8 0f             	cmp    $0xf,%eax
80107c67:	7f 37                	jg     80107ca0 <allocuvm_paging+0x50>
  page->isused = 1;
80107c69:	6b d0 1c             	imul   $0x1c,%eax,%edx
  curproc->num_ram++;
80107c6c:	83 c0 01             	add    $0x1,%eax
  page->isused = 1;
80107c6f:	01 ca                	add    %ecx,%edx
80107c71:	c7 82 4c 02 00 00 01 	movl   $0x1,0x24c(%edx)
80107c78:	00 00 00 
  page->pgdir = pgdir;
80107c7b:	89 b2 48 02 00 00    	mov    %esi,0x248(%edx)
  page->swap_offset = -1;
80107c81:	c7 82 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edx)
80107c88:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107c8b:	89 9a 50 02 00 00    	mov    %ebx,0x250(%edx)
  curproc->num_ram++;
80107c91:	89 81 08 04 00 00    	mov    %eax,0x408(%ecx)
}
80107c97:	5b                   	pop    %ebx
80107c98:	5e                   	pop    %esi
80107c99:	5d                   	pop    %ebp
80107c9a:	c3                   	ret    
80107c9b:	90                   	nop
80107c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ca0:	5b                   	pop    %ebx
80107ca1:	5e                   	pop    %esi
80107ca2:	5d                   	pop    %ebp
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107ca3:	e9 48 fe ff ff       	jmp    80107af0 <allocuvm_withswap>
80107ca8:	90                   	nop
80107ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107cb0 <update_selectionfiled_allocuvm>:

void
update_selectionfiled_allocuvm(struct proc* curproc, struct page* page, int page_ramindex)
{
80107cb0:	55                   	push   %ebp
80107cb1:	89 e5                	mov    %esp,%ebp
      curproc->queue_head->prev = 0;
    }
  #endif


}
80107cb3:	5d                   	pop    %ebp
80107cb4:	c3                   	ret    
80107cb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107cc0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107cc0:	55                   	push   %ebp
80107cc1:	89 e5                	mov    %esp,%ebp
80107cc3:	57                   	push   %edi
80107cc4:	56                   	push   %esi
80107cc5:	53                   	push   %ebx
80107cc6:	83 ec 5c             	sub    $0x5c,%esp
80107cc9:	8b 7d 08             	mov    0x8(%ebp),%edi
  // struct proc *curproc = myproc();
  pte_t *pte;
  uint a, pa;
  struct proc* curproc = myproc();
80107ccc:	e8 ef c5 ff ff       	call   801042c0 <myproc>
80107cd1:	89 45 a4             	mov    %eax,-0x5c(%ebp)

  if(newsz >= oldsz)
80107cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cd7:	39 45 10             	cmp    %eax,0x10(%ebp)
80107cda:	0f 83 a3 00 00 00    	jae    80107d83 <deallocuvm+0xc3>
    return oldsz;

  a = PGROUNDUP(newsz);
80107ce0:	8b 45 10             	mov    0x10(%ebp),%eax
80107ce3:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107ce9:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  
  for(; a  < oldsz; a += PGSIZE){
80107cef:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107cf2:	77 6a                	ja     80107d5e <deallocuvm+0x9e>
80107cf4:	e9 87 00 00 00       	jmp    80107d80 <deallocuvm+0xc0>
80107cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
    {
      a += (NPTENTRIES - 1) * PGSIZE;
    }
    else if((*pte & PTE_P) != 0)
80107d00:	8b 00                	mov    (%eax),%eax
80107d02:	a8 01                	test   $0x1,%al
80107d04:	74 4d                	je     80107d53 <deallocuvm+0x93>
    {
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107d06:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107d0b:	0f 84 b3 01 00 00    	je     80107ec4 <deallocuvm+0x204>
        panic("kfree");
      char *v = P2V(pa);
80107d11:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
      
      if(getRefs(v) == 1)
80107d17:	83 ec 0c             	sub    $0xc,%esp
80107d1a:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107d1d:	53                   	push   %ebx
80107d1e:	e8 9d b1 ff ff       	call   80102ec0 <getRefs>
80107d23:	83 c4 10             	add    $0x10,%esp
80107d26:	83 f8 01             	cmp    $0x1,%eax
80107d29:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107d2c:	0f 84 7e 01 00 00    	je     80107eb0 <deallocuvm+0x1f0>
      {
        kfree(v);
      }
      else
      {
        refDec(v);
80107d32:	83 ec 0c             	sub    $0xc,%esp
80107d35:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107d38:	53                   	push   %ebx
80107d39:	e8 a2 b0 ff ff       	call   80102de0 <refDec>
80107d3e:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107d41:	83 c4 10             	add    $0x10,%esp
      }

      if(curproc->pid >2)
80107d44:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107d47:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80107d4b:	7f 43                	jg     80107d90 <deallocuvm+0xd0>
          }
        }

      }
     
      *pte = 0;
80107d4d:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  for(; a  < oldsz; a += PGSIZE){
80107d53:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d59:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107d5c:	76 22                	jbe    80107d80 <deallocuvm+0xc0>
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d5e:	31 c9                	xor    %ecx,%ecx
80107d60:	89 f2                	mov    %esi,%edx
80107d62:	89 f8                	mov    %edi,%eax
80107d64:	e8 a7 f7 ff ff       	call   80107510 <walkpgdir>
    if(!pte)
80107d69:	85 c0                	test   %eax,%eax
    pte = walkpgdir(pgdir, (char*)a, 0);
80107d6b:	89 c2                	mov    %eax,%edx
    if(!pte)
80107d6d:	75 91                	jne    80107d00 <deallocuvm+0x40>
      a += (NPTENTRIES - 1) * PGSIZE;
80107d6f:	81 c6 00 f0 3f 00    	add    $0x3ff000,%esi
  for(; a  < oldsz; a += PGSIZE){
80107d75:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107d7b:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107d7e:	77 de                	ja     80107d5e <deallocuvm+0x9e>
    }
  }
  return newsz;
80107d80:	8b 45 10             	mov    0x10(%ebp),%eax
}
80107d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d86:	5b                   	pop    %ebx
80107d87:	5e                   	pop    %esi
80107d88:	5f                   	pop    %edi
80107d89:	5d                   	pop    %ebp
80107d8a:	c3                   	ret    
80107d8b:	90                   	nop
80107d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107d90:	8d 88 48 02 00 00    	lea    0x248(%eax),%ecx
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107d96:	89 55 a0             	mov    %edx,-0x60(%ebp)
80107d99:	8d 98 88 00 00 00    	lea    0x88(%eax),%ebx
80107d9f:	89 fa                	mov    %edi,%edx
80107da1:	89 cf                	mov    %ecx,%edi
80107da3:	eb 17                	jmp    80107dbc <deallocuvm+0xfc>
80107da5:	8d 76 00             	lea    0x0(%esi),%esi
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107da8:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107dab:	0f 84 b7 00 00 00    	je     80107e68 <deallocuvm+0x1a8>
80107db1:	83 c3 1c             	add    $0x1c,%ebx
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107db4:	39 fb                	cmp    %edi,%ebx
80107db6:	0f 84 e4 00 00 00    	je     80107ea0 <deallocuvm+0x1e0>
          struct page p_ram = curproc->ramPages[i];
80107dbc:	8b 83 c0 01 00 00    	mov    0x1c0(%ebx),%eax
80107dc2:	89 45 b0             	mov    %eax,-0x50(%ebp)
80107dc5:	8b 83 c4 01 00 00    	mov    0x1c4(%ebx),%eax
80107dcb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80107dce:	8b 83 c8 01 00 00    	mov    0x1c8(%ebx),%eax
80107dd4:	89 45 b8             	mov    %eax,-0x48(%ebp)
80107dd7:	8b 83 cc 01 00 00    	mov    0x1cc(%ebx),%eax
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107ddd:	39 75 b8             	cmp    %esi,-0x48(%ebp)
          struct page p_ram = curproc->ramPages[i];
80107de0:	89 45 bc             	mov    %eax,-0x44(%ebp)
80107de3:	8b 83 d0 01 00 00    	mov    0x1d0(%ebx),%eax
80107de9:	89 45 c0             	mov    %eax,-0x40(%ebp)
80107dec:	8b 83 d4 01 00 00    	mov    0x1d4(%ebx),%eax
80107df2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80107df5:	8b 83 d8 01 00 00    	mov    0x1d8(%ebx),%eax
80107dfb:	89 45 c8             	mov    %eax,-0x38(%ebp)
          struct page p_swap = curproc->swappedPages[i];
80107dfe:	8b 03                	mov    (%ebx),%eax
80107e00:	89 45 cc             	mov    %eax,-0x34(%ebp)
80107e03:	8b 43 04             	mov    0x4(%ebx),%eax
80107e06:	89 45 d0             	mov    %eax,-0x30(%ebp)
80107e09:	8b 43 08             	mov    0x8(%ebx),%eax
80107e0c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80107e0f:	8b 43 0c             	mov    0xc(%ebx),%eax
80107e12:	89 45 d8             	mov    %eax,-0x28(%ebp)
80107e15:	8b 43 10             	mov    0x10(%ebx),%eax
80107e18:	89 45 dc             	mov    %eax,-0x24(%ebp)
80107e1b:	8b 43 14             	mov    0x14(%ebx),%eax
80107e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107e21:	8b 43 18             	mov    0x18(%ebx),%eax
80107e24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          if((uint)p_ram.virt_addr == a && p_ram.pgdir == pgdir)
80107e27:	0f 85 7b ff ff ff    	jne    80107da8 <deallocuvm+0xe8>
80107e2d:	39 55 b0             	cmp    %edx,-0x50(%ebp)
80107e30:	0f 85 72 ff ff ff    	jne    80107da8 <deallocuvm+0xe8>
            memset((void*)&p_ram, 0, sizeof(struct page)); // zero that page struct
80107e36:	8d 45 b0             	lea    -0x50(%ebp),%eax
80107e39:	83 ec 04             	sub    $0x4,%esp
80107e3c:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107e3f:	6a 1c                	push   $0x1c
80107e41:	6a 00                	push   $0x0
80107e43:	50                   	push   %eax
80107e44:	e8 17 d5 ff ff       	call   80105360 <memset>
            curproc->num_ram -- ;
80107e49:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107e4c:	83 c4 10             	add    $0x10,%esp
80107e4f:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107e52:	83 a8 08 04 00 00 01 	subl   $0x1,0x408(%eax)
          if((uint)p_swap.virt_addr == a && p_swap.pgdir == pgdir)
80107e59:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
80107e5c:	0f 85 4f ff ff ff    	jne    80107db1 <deallocuvm+0xf1>
80107e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107e68:	39 55 cc             	cmp    %edx,-0x34(%ebp)
80107e6b:	0f 85 40 ff ff ff    	jne    80107db1 <deallocuvm+0xf1>
            memset((void*)&p_swap, 0, sizeof(struct page)); // zero that page struct
80107e71:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107e74:	83 ec 04             	sub    $0x4,%esp
80107e77:	89 55 9c             	mov    %edx,-0x64(%ebp)
80107e7a:	6a 1c                	push   $0x1c
80107e7c:	6a 00                	push   $0x0
80107e7e:	83 c3 1c             	add    $0x1c,%ebx
80107e81:	50                   	push   %eax
80107e82:	e8 d9 d4 ff ff       	call   80105360 <memset>
            curproc->num_swap --;
80107e87:	8b 45 a4             	mov    -0x5c(%ebp),%eax
80107e8a:	83 c4 10             	add    $0x10,%esp
80107e8d:	8b 55 9c             	mov    -0x64(%ebp),%edx
80107e90:	83 a8 0c 04 00 00 01 	subl   $0x1,0x40c(%eax)
        for(i = 0; i < MAX_PSYC_PAGES; i++)
80107e97:	39 fb                	cmp    %edi,%ebx
80107e99:	0f 85 1d ff ff ff    	jne    80107dbc <deallocuvm+0xfc>
80107e9f:	90                   	nop
80107ea0:	89 d7                	mov    %edx,%edi
80107ea2:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107ea5:	e9 a3 fe ff ff       	jmp    80107d4d <deallocuvm+0x8d>
80107eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(v);
80107eb0:	83 ec 0c             	sub    $0xc,%esp
80107eb3:	53                   	push   %ebx
80107eb4:	e8 97 ab ff ff       	call   80102a50 <kfree>
80107eb9:	83 c4 10             	add    $0x10,%esp
80107ebc:	8b 55 a0             	mov    -0x60(%ebp),%edx
80107ebf:	e9 80 fe ff ff       	jmp    80107d44 <deallocuvm+0x84>
        panic("kfree");
80107ec4:	83 ec 0c             	sub    $0xc,%esp
80107ec7:	68 7a 93 10 80       	push   $0x8010937a
80107ecc:	e8 bf 84 ff ff       	call   80100390 <panic>
80107ed1:	eb 0d                	jmp    80107ee0 <allocuvm>
80107ed3:	90                   	nop
80107ed4:	90                   	nop
80107ed5:	90                   	nop
80107ed6:	90                   	nop
80107ed7:	90                   	nop
80107ed8:	90                   	nop
80107ed9:	90                   	nop
80107eda:	90                   	nop
80107edb:	90                   	nop
80107edc:	90                   	nop
80107edd:	90                   	nop
80107ede:	90                   	nop
80107edf:	90                   	nop

80107ee0 <allocuvm>:
{
80107ee0:	55                   	push   %ebp
80107ee1:	89 e5                	mov    %esp,%ebp
80107ee3:	57                   	push   %edi
80107ee4:	56                   	push   %esi
80107ee5:	53                   	push   %ebx
80107ee6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* curproc = myproc();
80107ee9:	e8 d2 c3 ff ff       	call   801042c0 <myproc>
80107eee:	89 c7                	mov    %eax,%edi
  if(newsz >= KERNBASE)
80107ef0:	8b 45 10             	mov    0x10(%ebp),%eax
80107ef3:	85 c0                	test   %eax,%eax
80107ef5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107ef8:	0f 88 e2 00 00 00    	js     80107fe0 <allocuvm+0x100>
  if(newsz < oldsz)
80107efe:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107f04:	0f 82 c6 00 00 00    	jb     80107fd0 <allocuvm+0xf0>
  a = PGROUNDUP(oldsz);
80107f0a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107f10:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80107f16:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107f19:	77 41                	ja     80107f5c <allocuvm+0x7c>
80107f1b:	e9 b3 00 00 00       	jmp    80107fd3 <allocuvm+0xf3>
  page->isused = 1;
80107f20:	6b c2 1c             	imul   $0x1c,%edx,%eax
  page->pgdir = pgdir;
80107f23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  curproc->num_ram++;
80107f26:	83 c2 01             	add    $0x1,%edx
  page->isused = 1;
80107f29:	01 f8                	add    %edi,%eax
80107f2b:	c7 80 4c 02 00 00 01 	movl   $0x1,0x24c(%eax)
80107f32:	00 00 00 
  page->pgdir = pgdir;
80107f35:	89 88 48 02 00 00    	mov    %ecx,0x248(%eax)
  page->swap_offset = -1;
80107f3b:	c7 80 54 02 00 00 ff 	movl   $0xffffffff,0x254(%eax)
80107f42:	ff ff ff 
  page->virt_addr = rounded_virtaddr;
80107f45:	89 98 50 02 00 00    	mov    %ebx,0x250(%eax)
  curproc->num_ram++;
80107f4b:	89 97 08 04 00 00    	mov    %edx,0x408(%edi)
  for(; a < newsz; a += PGSIZE){
80107f51:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107f57:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107f5a:	76 77                	jbe    80107fd3 <allocuvm+0xf3>
    mem = kalloc();
80107f5c:	e8 cf ad ff ff       	call   80102d30 <kalloc>
    if(mem == 0){
80107f61:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107f63:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107f65:	0f 84 8d 00 00 00    	je     80107ff8 <allocuvm+0x118>
    memset(mem, 0, PGSIZE);
80107f6b:	83 ec 04             	sub    $0x4,%esp
80107f6e:	68 00 10 00 00       	push   $0x1000
80107f73:	6a 00                	push   $0x0
80107f75:	50                   	push   %eax
80107f76:	e8 e5 d3 ff ff       	call   80105360 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107f7b:	58                   	pop    %eax
80107f7c:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107f82:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107f87:	5a                   	pop    %edx
80107f88:	6a 06                	push   $0x6
80107f8a:	50                   	push   %eax
80107f8b:	89 da                	mov    %ebx,%edx
80107f8d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f90:	e8 fb f5 ff ff       	call   80107590 <mappages>
80107f95:	83 c4 10             	add    $0x10,%esp
80107f98:	85 c0                	test   %eax,%eax
80107f9a:	0f 88 90 00 00 00    	js     80108030 <allocuvm+0x150>
    if(curproc->pid > 2) 
80107fa0:	83 7f 10 02          	cmpl   $0x2,0x10(%edi)
80107fa4:	7e ab                	jle    80107f51 <allocuvm+0x71>
    if(curproc->num_ram < MAX_PSYC_PAGES) // there is space in RAM
80107fa6:	8b 97 08 04 00 00    	mov    0x408(%edi),%edx
80107fac:	83 fa 0f             	cmp    $0xf,%edx
80107faf:	0f 8e 6b ff ff ff    	jle    80107f20 <allocuvm+0x40>
      allocuvm_withswap(curproc, pgdir, rounded_virtaddr);
80107fb5:	83 ec 04             	sub    $0x4,%esp
80107fb8:	53                   	push   %ebx
80107fb9:	ff 75 08             	pushl  0x8(%ebp)
80107fbc:	57                   	push   %edi
80107fbd:	e8 2e fb ff ff       	call   80107af0 <allocuvm_withswap>
80107fc2:	83 c4 10             	add    $0x10,%esp
80107fc5:	eb 8a                	jmp    80107f51 <allocuvm+0x71>
80107fc7:	89 f6                	mov    %esi,%esi
80107fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return oldsz;
80107fd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107fd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fd9:	5b                   	pop    %ebx
80107fda:	5e                   	pop    %esi
80107fdb:	5f                   	pop    %edi
80107fdc:	5d                   	pop    %ebp
80107fdd:	c3                   	ret    
80107fde:	66 90                	xchg   %ax,%ax
    return 0;
80107fe0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107fe7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107fea:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107fed:	5b                   	pop    %ebx
80107fee:	5e                   	pop    %esi
80107fef:	5f                   	pop    %edi
80107ff0:	5d                   	pop    %ebp
80107ff1:	c3                   	ret    
80107ff2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107ff8:	83 ec 0c             	sub    $0xc,%esp
80107ffb:	68 0e 9c 10 80       	push   $0x80109c0e
80108000:	e8 5b 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108005:	83 c4 0c             	add    $0xc,%esp
80108008:	ff 75 0c             	pushl  0xc(%ebp)
8010800b:	ff 75 10             	pushl  0x10(%ebp)
8010800e:	ff 75 08             	pushl  0x8(%ebp)
80108011:	e8 aa fc ff ff       	call   80107cc0 <deallocuvm>
      return 0;
80108016:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010801d:	83 c4 10             	add    $0x10,%esp
}
80108020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108026:	5b                   	pop    %ebx
80108027:	5e                   	pop    %esi
80108028:	5f                   	pop    %edi
80108029:	5d                   	pop    %ebp
8010802a:	c3                   	ret    
8010802b:	90                   	nop
8010802c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80108030:	83 ec 0c             	sub    $0xc,%esp
80108033:	68 26 9c 10 80       	push   $0x80109c26
80108038:	e8 23 86 ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010803d:	83 c4 0c             	add    $0xc,%esp
80108040:	ff 75 0c             	pushl  0xc(%ebp)
80108043:	ff 75 10             	pushl  0x10(%ebp)
80108046:	ff 75 08             	pushl  0x8(%ebp)
80108049:	e8 72 fc ff ff       	call   80107cc0 <deallocuvm>
      kfree(mem);
8010804e:	89 34 24             	mov    %esi,(%esp)
80108051:	e8 fa a9 ff ff       	call   80102a50 <kfree>
      return 0;
80108056:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010805d:	83 c4 10             	add    $0x10,%esp
}
80108060:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108063:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108066:	5b                   	pop    %ebx
80108067:	5e                   	pop    %esi
80108068:	5f                   	pop    %edi
80108069:	5d                   	pop    %ebp
8010806a:	c3                   	ret    
8010806b:	90                   	nop
8010806c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80108070 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108070:	55                   	push   %ebp
80108071:	89 e5                	mov    %esp,%ebp
80108073:	57                   	push   %edi
80108074:	56                   	push   %esi
80108075:	53                   	push   %ebx
80108076:	83 ec 0c             	sub    $0xc,%esp
80108079:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010807c:	85 f6                	test   %esi,%esi
8010807e:	74 59                	je     801080d9 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0); // panic: kfree
80108080:	83 ec 04             	sub    $0x4,%esp
80108083:	89 f3                	mov    %esi,%ebx
80108085:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010808b:	6a 00                	push   $0x0
8010808d:	68 00 00 00 80       	push   $0x80000000
80108092:	56                   	push   %esi
80108093:	e8 28 fc ff ff       	call   80107cc0 <deallocuvm>
80108098:	83 c4 10             	add    $0x10,%esp
8010809b:	eb 0a                	jmp    801080a7 <freevm+0x37>
8010809d:	8d 76 00             	lea    0x0(%esi),%esi
801080a0:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
801080a3:	39 fb                	cmp    %edi,%ebx
801080a5:	74 23                	je     801080ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801080a7:	8b 03                	mov    (%ebx),%eax
801080a9:	a8 01                	test   $0x1,%al
801080ab:	74 f3                	je     801080a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801080b2:	83 ec 0c             	sub    $0xc,%esp
801080b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801080b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801080bd:	50                   	push   %eax
801080be:	e8 8d a9 ff ff       	call   80102a50 <kfree>
801080c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801080c6:	39 fb                	cmp    %edi,%ebx
801080c8:	75 dd                	jne    801080a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801080ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801080cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801080d0:	5b                   	pop    %ebx
801080d1:	5e                   	pop    %esi
801080d2:	5f                   	pop    %edi
801080d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801080d4:	e9 77 a9 ff ff       	jmp    80102a50 <kfree>
    panic("freevm: no pgdir");
801080d9:	83 ec 0c             	sub    $0xc,%esp
801080dc:	68 42 9c 10 80       	push   $0x80109c42
801080e1:	e8 aa 82 ff ff       	call   80100390 <panic>
801080e6:	8d 76 00             	lea    0x0(%esi),%esi
801080e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801080f0 <setupkvm>:
{
801080f0:	55                   	push   %ebp
801080f1:	89 e5                	mov    %esp,%ebp
801080f3:	56                   	push   %esi
801080f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801080f5:	e8 36 ac ff ff       	call   80102d30 <kalloc>
801080fa:	85 c0                	test   %eax,%eax
801080fc:	89 c6                	mov    %eax,%esi
801080fe:	74 42                	je     80108142 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80108100:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108103:	bb 20 c4 10 80       	mov    $0x8010c420,%ebx
  memset(pgdir, 0, PGSIZE);
80108108:	68 00 10 00 00       	push   $0x1000
8010810d:	6a 00                	push   $0x0
8010810f:	50                   	push   %eax
80108110:	e8 4b d2 ff ff       	call   80105360 <memset>
80108115:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80108118:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010811b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010811e:	83 ec 08             	sub    $0x8,%esp
80108121:	8b 13                	mov    (%ebx),%edx
80108123:	ff 73 0c             	pushl  0xc(%ebx)
80108126:	50                   	push   %eax
80108127:	29 c1                	sub    %eax,%ecx
80108129:	89 f0                	mov    %esi,%eax
8010812b:	e8 60 f4 ff ff       	call   80107590 <mappages>
80108130:	83 c4 10             	add    $0x10,%esp
80108133:	85 c0                	test   %eax,%eax
80108135:	78 19                	js     80108150 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108137:	83 c3 10             	add    $0x10,%ebx
8010813a:	81 fb 60 c4 10 80    	cmp    $0x8010c460,%ebx
80108140:	75 d6                	jne    80108118 <setupkvm+0x28>
}
80108142:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108145:	89 f0                	mov    %esi,%eax
80108147:	5b                   	pop    %ebx
80108148:	5e                   	pop    %esi
80108149:	5d                   	pop    %ebp
8010814a:	c3                   	ret    
8010814b:	90                   	nop
8010814c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("mappages failed on setupkvm");
80108150:	83 ec 0c             	sub    $0xc,%esp
80108153:	68 53 9c 10 80       	push   $0x80109c53
80108158:	e8 03 85 ff ff       	call   80100660 <cprintf>
      freevm(pgdir);
8010815d:	89 34 24             	mov    %esi,(%esp)
      return 0;
80108160:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80108162:	e8 09 ff ff ff       	call   80108070 <freevm>
      return 0;
80108167:	83 c4 10             	add    $0x10,%esp
}
8010816a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010816d:	89 f0                	mov    %esi,%eax
8010816f:	5b                   	pop    %ebx
80108170:	5e                   	pop    %esi
80108171:	5d                   	pop    %ebp
80108172:	c3                   	ret    
80108173:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108180 <kvmalloc>:
{
80108180:	55                   	push   %ebp
80108181:	89 e5                	mov    %esp,%ebp
80108183:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80108186:	e8 65 ff ff ff       	call   801080f0 <setupkvm>
8010818b:	a3 84 75 19 80       	mov    %eax,0x80197584
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80108190:	05 00 00 00 80       	add    $0x80000000,%eax
80108195:	0f 22 d8             	mov    %eax,%cr3
}
80108198:	c9                   	leave  
80108199:	c3                   	ret    
8010819a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801081a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
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
801081ae:	e8 5d f3 ff ff       	call   80107510 <walkpgdir>
  if(pte == 0)
801081b3:	85 c0                	test   %eax,%eax
801081b5:	74 05                	je     801081bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801081b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801081ba:	c9                   	leave  
801081bb:	c3                   	ret    
    panic("clearpteu");
801081bc:	83 ec 0c             	sub    $0xc,%esp
801081bf:	68 6f 9c 10 80       	push   $0x80109c6f
801081c4:	e8 c7 81 ff ff       	call   80100390 <panic>
801081c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801081d0 <cowuvm>:
// of it for a child.


pde_t*
cowuvm(pde_t *pgdir, uint sz)
{
801081d0:	55                   	push   %ebp
801081d1:	89 e5                	mov    %esp,%ebp
801081d3:	57                   	push   %edi
801081d4:	56                   	push   %esi
801081d5:	53                   	push   %ebx
801081d6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801081d9:	e8 12 ff ff ff       	call   801080f0 <setupkvm>
801081de:	85 c0                	test   %eax,%eax
801081e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801081e3:	0f 84 35 01 00 00    	je     8010831e <cowuvm+0x14e>
    return 0;
  
  for(i = 0; i < sz; i += PGSIZE)
801081e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801081ec:	85 db                	test   %ebx,%ebx
801081ee:	0f 84 2a 01 00 00    	je     8010831e <cowuvm+0x14e>
801081f4:	8b 45 08             	mov    0x8(%ebp),%eax
801081f7:	31 f6                	xor    %esi,%esi
801081f9:	05 00 00 00 80       	add    $0x80000000,%eax
801081fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
80108201:	eb 7a                	jmp    8010827d <cowuvm+0xad>
80108203:	90                   	nop
80108204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
       continue;
    }

     if(*pte & PTE_PG)
    {
      if(mappages(d, (void*)i, PGSIZE, 0, flags) < 0)
80108208:	83 ec 08             	sub    $0x8,%esp
8010820b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010820e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108213:	57                   	push   %edi
80108214:	6a 00                	push   $0x0
80108216:	89 f2                	mov    %esi,%edx
80108218:	e8 73 f3 ff ff       	call   80107590 <mappages>
8010821d:	83 c4 10             	add    $0x10,%esp
80108220:	85 c0                	test   %eax,%eax
80108222:	0f 88 a9 01 00 00    	js     801083d1 <cowuvm+0x201>
        panic("copyuvm: mappages failed");

      if((mem = kalloc()) == 0)
80108228:	e8 03 ab ff ff       	call   80102d30 <kalloc>
8010822d:	85 c0                	test   %eax,%eax
8010822f:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108232:	0f 84 74 01 00 00    	je     801083ac <cowuvm+0x1dc>
        goto bad;
      memmove(mem, (char*)P2V(pa), PGSIZE);
80108238:	83 ec 04             	sub    $0x4,%esp
8010823b:	68 00 10 00 00       	push   $0x1000
80108240:	53                   	push   %ebx
80108241:	89 c3                	mov    %eax,%ebx
80108243:	50                   	push   %eax
80108244:	e8 c7 d1 ff ff       	call   80105410 <memmove>
      if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108249:	89 d8                	mov    %ebx,%eax
8010824b:	5a                   	pop    %edx
8010824c:	05 00 00 00 80       	add    $0x80000000,%eax
80108251:	89 f2                	mov    %esi,%edx
80108253:	59                   	pop    %ecx
80108254:	57                   	push   %edi
80108255:	50                   	push   %eax
80108256:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010825b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010825e:	e8 2d f3 ff ff       	call   80107590 <mappages>
80108263:	83 c4 10             	add    $0x10,%esp
80108266:	85 c0                	test   %eax,%eax
80108268:	0f 88 ec 00 00 00    	js     8010835a <cowuvm+0x18a>
  for(i = 0; i < sz; i += PGSIZE)
8010826e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108274:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108277:	0f 86 a1 00 00 00    	jbe    8010831e <cowuvm+0x14e>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010827d:	8b 45 08             	mov    0x8(%ebp),%eax
80108280:	31 c9                	xor    %ecx,%ecx
80108282:	89 f2                	mov    %esi,%edx
80108284:	e8 87 f2 ff ff       	call   80107510 <walkpgdir>
80108289:	85 c0                	test   %eax,%eax
8010828b:	0f 84 33 01 00 00    	je     801083c4 <cowuvm+0x1f4>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108291:	8b 38                	mov    (%eax),%edi
80108293:	f7 c7 01 02 00 00    	test   $0x201,%edi
80108299:	0f 84 18 01 00 00    	je     801083b7 <cowuvm+0x1e7>
    if(!(*pte & PTE_PG)) // was not marked as paged-out in the parent
8010829f:	f7 c7 00 02 00 00    	test   $0x200,%edi
801082a5:	0f 85 85 00 00 00    	jne    80108330 <cowuvm+0x160>
    pa = PTE_ADDR(*pte);
801082ab:	89 fa                	mov    %edi,%edx
      *pte &= ~PTE_W;
801082ad:	89 f9                	mov    %edi,%ecx
      refInc(virt_addr);
801082af:	83 ec 0c             	sub    $0xc,%esp
    pa = PTE_ADDR(*pte);
801082b2:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
      *pte &= ~PTE_W;
801082b8:	83 e1 fd             	and    $0xfffffffd,%ecx
801082bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
      char *virt_addr = P2V(pa);
801082be:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
      *pte &= ~PTE_W;
801082c4:	80 cd 04             	or     $0x4,%ch
      char *virt_addr = P2V(pa);
801082c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
      *pte &= ~PTE_W;
801082ca:	89 08                	mov    %ecx,(%eax)
    flags = PTE_FLAGS(*pte);
801082cc:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
      refInc(virt_addr);
801082d2:	53                   	push   %ebx
801082d3:	e8 78 ab ff ff       	call   80102e50 <refInc>
     if(*pte & PTE_PG)
801082d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801082db:	83 c4 10             	add    $0x10,%esp
801082de:	8b 00                	mov    (%eax),%eax
801082e0:	f6 c4 02             	test   $0x2,%ah
801082e3:	0f 85 1f ff ff ff    	jne    80108208 <cowuvm+0x38>
801082e9:	8b 55 dc             	mov    -0x24(%ebp),%edx
      }

    }
    else
    {
       if(mappages(d, (void *) i, PGSIZE, pa, flags) < 0)
801082ec:	83 ec 08             	sub    $0x8,%esp
801082ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801082f2:	57                   	push   %edi
801082f3:	b9 00 10 00 00       	mov    $0x1000,%ecx
801082f8:	52                   	push   %edx
801082f9:	89 f2                	mov    %esi,%edx
801082fb:	e8 90 f2 ff ff       	call   80107590 <mappages>
80108300:	8b 7d d8             	mov    -0x28(%ebp),%edi
80108303:	83 c4 10             	add    $0x10,%esp
80108306:	85 c0                	test   %eax,%eax
80108308:	89 fb                	mov    %edi,%ebx
8010830a:	78 72                	js     8010837e <cowuvm+0x1ae>
8010830c:	0f 22 df             	mov    %edi,%cr3
  for(i = 0; i < sz; i += PGSIZE)
8010830f:	81 c6 00 10 00 00    	add    $0x1000,%esi
80108315:	39 75 0c             	cmp    %esi,0xc(%ebp)
80108318:	0f 87 5f ff ff ff    	ja     8010827d <cowuvm+0xad>
bad:
  cprintf("bad: cowuvm\n");
  freevm(d);
  lcr3(V2P(pgdir));  // flush tlb
  return 0;
}
8010831e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108321:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108324:	5b                   	pop    %ebx
80108325:	5e                   	pop    %esi
80108326:	5f                   	pop    %edi
80108327:	5d                   	pop    %ebp
80108328:	c3                   	ret    
80108329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cprintf("marked as pagedout in parent will not cot cow\n");
80108330:	83 ec 0c             	sub    $0xc,%esp
80108333:	68 f0 9d 10 80       	push   $0x80109df0
80108338:	e8 23 83 ff ff       	call   80100660 <cprintf>
       pte = walkpgdir(d, (void*) i, 1);
8010833d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108340:	b9 01 00 00 00       	mov    $0x1,%ecx
80108345:	89 f2                	mov    %esi,%edx
80108347:	e8 c4 f1 ff ff       	call   80107510 <walkpgdir>
       continue;
8010834c:	83 c4 10             	add    $0x10,%esp
      *pte = PTE_U | PTE_W | PTE_PG;
8010834f:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
       continue;
80108355:	e9 14 ff ff ff       	jmp    8010826e <cowuvm+0x9e>
        cprintf("copyuvm: mappages failed\n");
8010835a:	83 ec 0c             	sub    $0xc,%esp
8010835d:	8b 7d e0             	mov    -0x20(%ebp),%edi
80108360:	68 a1 9c 10 80       	push   $0x80109ca1
80108365:	e8 f6 82 ff ff       	call   80100660 <cprintf>
        kfree(mem);
8010836a:	89 3c 24             	mov    %edi,(%esp)
8010836d:	e8 de a6 ff ff       	call   80102a50 <kfree>
80108372:	8b 45 08             	mov    0x8(%ebp),%eax
        goto bad;
80108375:	83 c4 10             	add    $0x10,%esp
80108378:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  cprintf("bad: cowuvm\n");
8010837e:	83 ec 0c             	sub    $0xc,%esp
80108381:	68 bb 9c 10 80       	push   $0x80109cbb
80108386:	e8 d5 82 ff ff       	call   80100660 <cprintf>
  freevm(d);
8010838b:	58                   	pop    %eax
8010838c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010838f:	e8 dc fc ff ff       	call   80108070 <freevm>
80108394:	0f 22 db             	mov    %ebx,%cr3
  return 0;
80108397:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010839e:	83 c4 10             	add    $0x10,%esp
}
801083a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801083a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801083a7:	5b                   	pop    %ebx
801083a8:	5e                   	pop    %esi
801083a9:	5f                   	pop    %edi
801083aa:	5d                   	pop    %ebp
801083ab:	c3                   	ret    
801083ac:	8b 45 08             	mov    0x8(%ebp),%eax
801083af:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801083b5:	eb c7                	jmp    8010837e <cowuvm+0x1ae>
      panic("cowuvm: page not present and not page faulted!");
801083b7:	83 ec 0c             	sub    $0xc,%esp
801083ba:	68 c0 9d 10 80       	push   $0x80109dc0
801083bf:	e8 cc 7f ff ff       	call   80100390 <panic>
      panic("cowuvm: no pte");
801083c4:	83 ec 0c             	sub    $0xc,%esp
801083c7:	68 79 9c 10 80       	push   $0x80109c79
801083cc:	e8 bf 7f ff ff       	call   80100390 <panic>
        panic("copyuvm: mappages failed");
801083d1:	83 ec 0c             	sub    $0xc,%esp
801083d4:	68 88 9c 10 80       	push   $0x80109c88
801083d9:	e8 b2 7f ff ff       	call   80100390 <panic>
801083de:	66 90                	xchg   %ax,%ax

801083e0 <getSwappedPageIndex>:

int 
getSwappedPageIndex(char* va)
{
801083e0:	55                   	push   %ebp
801083e1:	89 e5                	mov    %esp,%ebp
801083e3:	53                   	push   %ebx
801083e4:	83 ec 04             	sub    $0x4,%esp
801083e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc* curproc = myproc();
801083ea:	e8 d1 be ff ff       	call   801042c0 <myproc>
801083ef:	8d 90 90 00 00 00    	lea    0x90(%eax),%edx
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801083f5:	31 c0                	xor    %eax,%eax
801083f7:	eb 12                	jmp    8010840b <getSwappedPageIndex+0x2b>
801083f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108400:	83 c0 01             	add    $0x1,%eax
80108403:	83 c2 1c             	add    $0x1c,%edx
80108406:	83 f8 10             	cmp    $0x10,%eax
80108409:	74 0d                	je     80108418 <getSwappedPageIndex+0x38>
  {
    if(curproc->swappedPages[i].virt_addr == va)
8010840b:	39 1a                	cmp    %ebx,(%edx)
8010840d:	75 f1                	jne    80108400 <getSwappedPageIndex+0x20>
      return i;
  }
  return -1;
}
8010840f:	83 c4 04             	add    $0x4,%esp
80108412:	5b                   	pop    %ebx
80108413:	5d                   	pop    %ebp
80108414:	c3                   	ret    
80108415:	8d 76 00             	lea    0x0(%esi),%esi
80108418:	83 c4 04             	add    $0x4,%esp
  return -1;
8010841b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108420:	5b                   	pop    %ebx
80108421:	5d                   	pop    %ebp
80108422:	c3                   	ret    
80108423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108430 <handle_cow_pagefault>:
  }
}

void
handle_cow_pagefault(struct proc* curproc, pte_t* pte, uint va)
{
80108430:	55                   	push   %ebp
80108431:	89 e5                	mov    %esp,%ebp
80108433:	57                   	push   %edi
80108434:	56                   	push   %esi
80108435:	53                   	push   %ebx
80108436:	83 ec 1c             	sub    $0x1c,%esp
80108439:	8b 45 08             	mov    0x8(%ebp),%eax
8010843c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010843f:	8b 55 10             	mov    0x10(%ebp),%edx
  uint err = curproc->tf->err;
80108442:	8b 48 18             	mov    0x18(%eax),%ecx
  uint flags;
  char* new_page;
  uint pa, new_pa;

   // checking that page fault caused by write
  if(err & FEC_WR) // a cow pagefault is a write fault
80108445:	f6 41 34 02          	testb  $0x2,0x34(%ecx)
80108449:	74 08                	je     80108453 <handle_cow_pagefault+0x23>
  {
    // if the page of this address not includes the PTE_COW flag, kill the process
    if(!(*pte & PTE_COW))
8010844b:	f7 03 00 04 00 00    	testl  $0x400,(%ebx)
80108451:	75 15                	jne    80108468 <handle_cow_pagefault+0x38>
    {
      curproc->killed = 1;
80108453:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  else // pagefault is not write fault
  {
    curproc->killed = 1;
    return;
  }
}
8010845a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010845d:	5b                   	pop    %ebx
8010845e:	5e                   	pop    %esi
8010845f:	5f                   	pop    %edi
80108460:	5d                   	pop    %ebp
80108461:	c3                   	ret    
80108462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("pagefault - %s (pid %d) - COW\n", curproc->name, curproc->pid);
80108468:	83 ec 04             	sub    $0x4,%esp
8010846b:	83 c0 6c             	add    $0x6c,%eax
8010846e:	ff 70 a4             	pushl  -0x5c(%eax)
80108471:	50                   	push   %eax
80108472:	68 20 9e 10 80       	push   $0x80109e20
80108477:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010847a:	e8 e1 81 ff ff       	call   80100660 <cprintf>
      pa = PTE_ADDR(*pte);
8010847f:	8b 33                	mov    (%ebx),%esi
80108481:	89 f7                	mov    %esi,%edi
80108483:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
      char *virt_addr = P2V(pa);
80108489:	81 c7 00 00 00 80    	add    $0x80000000,%edi
      ref_count = getRefs(virt_addr);
8010848f:	89 3c 24             	mov    %edi,(%esp)
80108492:	e8 29 aa ff ff       	call   80102ec0 <getRefs>
      if (ref_count > 1) // more than one reference
80108497:	83 c4 10             	add    $0x10,%esp
8010849a:	83 f8 01             	cmp    $0x1,%eax
8010849d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801084a0:	7f 16                	jg     801084b8 <handle_cow_pagefault+0x88>
        *pte &= ~PTE_COW; // turn COW off
801084a2:	8b 03                	mov    (%ebx),%eax
801084a4:	80 e4 fb             	and    $0xfb,%ah
801084a7:	83 c8 02             	or     $0x2,%eax
801084aa:	89 03                	mov    %eax,(%ebx)
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
801084ac:	0f 01 3a             	invlpg (%edx)
801084af:	eb a9                	jmp    8010845a <handle_cow_pagefault+0x2a>
801084b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801084b8:	89 55 e0             	mov    %edx,-0x20(%ebp)
      flags = PTE_FLAGS(*pte);
801084bb:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
        new_page = kalloc();
801084c1:	e8 6a a8 ff ff       	call   80102d30 <kalloc>
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
801084c6:	83 ec 04             	sub    $0x4,%esp
801084c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801084cc:	83 ce 03             	or     $0x3,%esi
        memmove(new_page, virt_addr, PGSIZE); // copy the faulty page to the newly allocated one
801084cf:	68 00 10 00 00       	push   $0x1000
801084d4:	57                   	push   %edi
801084d5:	50                   	push   %eax
801084d6:	e8 35 cf ff ff       	call   80105410 <memmove>
        new_pa = V2P(new_page);
801084db:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801084de:	8b 55 e0             	mov    -0x20(%ebp),%edx
801084e1:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
        *pte = new_pa | flags | PTE_P | PTE_W; // make pte point to new page, turning the required bits ON
801084e7:	09 ce                	or     %ecx,%esi
801084e9:	89 33                	mov    %esi,(%ebx)
801084eb:	0f 01 3a             	invlpg (%edx)
        refDec(virt_addr); // decrement old page's ref count
801084ee:	89 7d 08             	mov    %edi,0x8(%ebp)
801084f1:	83 c4 10             	add    $0x10,%esp
}
801084f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084f7:	5b                   	pop    %ebx
801084f8:	5e                   	pop    %esi
801084f9:	5f                   	pop    %edi
801084fa:	5d                   	pop    %ebp
        refDec(virt_addr); // decrement old page's ref count
801084fb:	e9 e0 a8 ff ff       	jmp    80102de0 <refDec>

80108500 <handle_pagedout>:

void
handle_pagedout(struct proc* curproc, char* start_page, pte_t* pte)
{
80108500:	55                   	push   %ebp
80108501:	89 e5                	mov    %esp,%ebp
80108503:	57                   	push   %edi
80108504:	56                   	push   %esi
80108505:	53                   	push   %ebx
80108506:	83 ec 20             	sub    $0x20,%esp
80108509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010850c:	8b 7d 10             	mov    0x10(%ebp),%edi
8010850f:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* new_page;
    void* ramPa;
    cprintf("pagefault - %s (pid %d) - page was paged out\n", curproc->name, curproc->pid);
80108512:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108515:	ff 73 10             	pushl  0x10(%ebx)
80108518:	50                   	push   %eax
80108519:	68 40 9e 10 80       	push   $0x80109e40
8010851e:	e8 3d 81 ff ff       	call   80100660 <cprintf>

    new_page = kalloc();
80108523:	e8 08 a8 ff ff       	call   80102d30 <kalloc>
    *pte |= PTE_P | PTE_W | PTE_U;
    *pte &= ~PTE_PG;
    *pte &= 0xFFF;
80108528:	8b 17                	mov    (%edi),%edx
    *pte |= V2P(new_page);
8010852a:	05 00 00 00 80       	add    $0x80000000,%eax
    *pte &= 0xFFF;
8010852f:	81 e2 ff 0d 00 00    	and    $0xdff,%edx
80108535:	83 ca 07             	or     $0x7,%edx
    *pte |= V2P(new_page);
80108538:	09 d0                	or     %edx,%eax
8010853a:	89 07                	mov    %eax,(%edi)
  for(i = 0; i < MAX_PSYC_PAGES; i++)
8010853c:	31 ff                	xor    %edi,%edi
  struct proc* curproc = myproc();
8010853e:	e8 7d bd ff ff       	call   801042c0 <myproc>
80108543:	83 c4 10             	add    $0x10,%esp
80108546:	05 90 00 00 00       	add    $0x90,%eax
8010854b:	eb 12                	jmp    8010855f <handle_pagedout+0x5f>
8010854d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108550:	83 c7 01             	add    $0x1,%edi
80108553:	83 c0 1c             	add    $0x1c,%eax
80108556:	83 ff 10             	cmp    $0x10,%edi
80108559:	0f 84 99 01 00 00    	je     801086f8 <handle_pagedout+0x1f8>
    if(curproc->swappedPages[i].virt_addr == va)
8010855f:	3b 30                	cmp    (%eax),%esi
80108561:	75 ed                	jne    80108550 <handle_pagedout+0x50>
80108563:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108566:	05 88 00 00 00       	add    $0x88,%eax
    
    int index = getSwappedPageIndex(start_page); // get swap page index
    struct page *swap_page = &curproc->swappedPages[index];
8010856b:	01 d8                	add    %ebx,%eax

    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
8010856d:	68 00 10 00 00       	push   $0x1000
    struct page *swap_page = &curproc->swappedPages[index];
80108572:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readFromSwapFile(curproc, buffer, swap_page->swap_offset, PGSIZE) < 0)
80108575:	6b c7 1c             	imul   $0x1c,%edi,%eax
80108578:	01 d8                	add    %ebx,%eax
8010857a:	ff b0 94 00 00 00    	pushl  0x94(%eax)
80108580:	68 e0 c5 10 80       	push   $0x8010c5e0
80108585:	53                   	push   %ebx
80108586:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108589:	e8 a2 a0 ff ff       	call   80102630 <readFromSwapFile>
8010858e:	83 c4 10             	add    $0x10,%esp
80108591:	85 c0                	test   %eax,%eax
80108593:	0f 88 fe 01 00 00    	js     80108797 <handle_pagedout+0x297>
      panic("allocuvm: readFromSwapFile");

    struct fblock *new_block = (struct fblock*)kalloc();
80108599:	e8 92 a7 ff ff       	call   80102d30 <kalloc>
    new_block->off = swap_page->swap_offset;
8010859e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801085a1:	8b 91 94 00 00 00    	mov    0x94(%ecx),%edx
    new_block->next = 0;
801085a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    new_block->off = swap_page->swap_offset;
801085ae:	89 10                	mov    %edx,(%eax)
    new_block->prev = curproc->free_tail;
801085b0:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
801085b6:	89 50 08             	mov    %edx,0x8(%eax)

    if(curproc->free_tail != 0)
801085b9:	8b 93 18 04 00 00    	mov    0x418(%ebx),%edx
801085bf:	85 d2                	test   %edx,%edx
801085c1:	0f 84 b9 01 00 00    	je     80108780 <handle_pagedout+0x280>
      curproc->free_tail->next = new_block;
801085c7:	89 42 04             	mov    %eax,0x4(%edx)
    curproc->free_tail = new_block;

    // cprintf("free blocks list after readFromSwapFile:\n");
    // printlist();

    memmove((void*)start_page, buffer, PGSIZE);
801085ca:	83 ec 04             	sub    $0x4,%esp
    curproc->free_tail = new_block;
801085cd:	89 83 18 04 00 00    	mov    %eax,0x418(%ebx)
    memmove((void*)start_page, buffer, PGSIZE);
801085d3:	68 00 10 00 00       	push   $0x1000
801085d8:	68 e0 c5 10 80       	push   $0x8010c5e0
801085dd:	56                   	push   %esi
801085de:	e8 2d ce ff ff       	call   80105410 <memmove>

    // zero swap page entry
    memset((void*)swap_page, 0, sizeof(struct page));
801085e3:	83 c4 0c             	add    $0xc,%esp
801085e6:	6a 1c                	push   $0x1c
801085e8:	6a 00                	push   $0x0
801085ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801085ed:	e8 6e cd ff ff       	call   80105360 <memset>

    if(curproc->num_ram < MAX_PSYC_PAGES) // there is sapce in proc RAM
801085f2:	83 c4 10             	add    $0x10,%esp
801085f5:	83 bb 08 04 00 00 0f 	cmpl   $0xf,0x408(%ebx)
801085fc:	0f 8e 0e 01 00 00    	jle    80108710 <handle_pagedout+0x210>
    else // no sapce in proc RAM, will swap
    {
      int index_to_evicet = indexToEvict();
      // cprintf("[pagefault] index to evict: %d\n", index_to_evicet);
      struct page *ram_page = &curproc->ramPages[index_to_evicet];
      int swap_offset = curproc->free_head->off;
80108602:	8b 93 14 04 00 00    	mov    0x414(%ebx),%edx
80108608:	8b 02                	mov    (%edx),%eax
8010860a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

      if(curproc->free_head->next == 0)
8010860d:	8b 42 04             	mov    0x4(%edx),%eax
80108610:	85 c0                	test   %eax,%eax
80108612:	0f 84 b8 00 00 00    	je     801086d0 <handle_pagedout+0x1d0>
        curproc->free_head = 0;
      }
      else
      {
        curproc->free_head = curproc->free_head->next;
        kfree((char*)curproc->free_head->prev);
80108618:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_head = curproc->free_head->next;
8010861b:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
        kfree((char*)curproc->free_head->prev);
80108621:	ff 70 08             	pushl  0x8(%eax)
80108624:	e8 27 a4 ff ff       	call   80102a50 <kfree>
80108629:	83 c4 10             	add    $0x10,%esp
      }

      if(writeToSwapFile(curproc, (char*)ram_page->virt_addr, swap_offset, PGSIZE) < 0)   // buffer now has bytes from swapped page (faulty one)
8010862c:	68 00 10 00 00       	push   $0x1000
80108631:	ff 75 e4             	pushl  -0x1c(%ebp)
80108634:	ff b3 a4 02 00 00    	pushl  0x2a4(%ebx)
8010863a:	53                   	push   %ebx
8010863b:	e8 c0 9f ff ff       	call   80102600 <writeToSwapFile>
80108640:	83 c4 10             	add    $0x10,%esp
80108643:	85 c0                	test   %eax,%eax
80108645:	0f 88 59 01 00 00    	js     801087a4 <handle_pagedout+0x2a4>
        panic("allocuvm: writeToSwapFile");
      
      swap_page->virt_addr = ram_page->virt_addr;
8010864b:	6b cf 1c             	imul   $0x1c,%edi,%ecx
8010864e:	8b 93 a4 02 00 00    	mov    0x2a4(%ebx),%edx
80108654:	01 d9                	add    %ebx,%ecx
80108656:	89 91 90 00 00 00    	mov    %edx,0x90(%ecx)
      swap_page->pgdir = ram_page->pgdir;
8010865c:	8b 83 9c 02 00 00    	mov    0x29c(%ebx),%eax
      swap_page->isused = 1;
80108662:	c7 81 8c 00 00 00 01 	movl   $0x1,0x8c(%ecx)
80108669:	00 00 00 
      swap_page->pgdir = ram_page->pgdir;
8010866c:	89 81 88 00 00 00    	mov    %eax,0x88(%ecx)
      swap_page->swap_offset = swap_offset;
80108672:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80108675:	89 81 94 00 00 00    	mov    %eax,0x94(%ecx)

      // get pte of RAM page
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
8010867b:	8b 43 04             	mov    0x4(%ebx),%eax
8010867e:	31 c9                	xor    %ecx,%ecx
80108680:	e8 8b ee ff ff       	call   80107510 <walkpgdir>
      if(!(*pte & PTE_P))
80108685:	8b 10                	mov    (%eax),%edx
      pte = walkpgdir(curproc->pgdir, (void*)ram_page->virt_addr, 0);
80108687:	89 c7                	mov    %eax,%edi
      if(!(*pte & PTE_P))
80108689:	f6 c2 01             	test   $0x1,%dl
8010868c:	0f 84 1f 01 00 00    	je     801087b1 <handle_pagedout+0x2b1>
        panic("pagefault: ram page is not present");
      ramPa = (void*)PTE_ADDR(*pte);
80108692:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx

      kfree(P2V(ramPa));
80108698:	83 ec 0c             	sub    $0xc,%esp
8010869b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801086a1:	52                   	push   %edx
801086a2:	e8 a9 a3 ff ff       	call   80102a50 <kfree>
      *pte &= 0xFFF;   // ???
      
      // prepare to-be-swapped page in RAM to move to swap file
      *pte |= PTE_PG;     // turn "paged-out" flag on
      *pte &= ~PTE_P;     // turn "present" flag off
801086a7:	8b 07                	mov    (%edi),%eax
801086a9:	25 fe 0f 00 00       	and    $0xffe,%eax
801086ae:	80 cc 02             	or     $0x2,%ah
801086b1:	89 07                	mov    %eax,(%edi)

      ram_page->virt_addr = start_page;
      update_selectionfiled_pagefault(curproc, ram_page, index_to_evicet);
      
      lcr3(V2P(curproc->pgdir));             // refresh TLB
801086b3:	8b 43 04             	mov    0x4(%ebx),%eax
      ram_page->virt_addr = start_page;
801086b6:	89 b3 a4 02 00 00    	mov    %esi,0x2a4(%ebx)
      lcr3(V2P(curproc->pgdir));             // refresh TLB
801086bc:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801086c1:	0f 22 d8             	mov    %eax,%cr3
801086c4:	83 c4 10             	add    $0x10,%esp
    }
    return;
}
801086c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801086ca:	5b                   	pop    %ebx
801086cb:	5e                   	pop    %esi
801086cc:	5f                   	pop    %edi
801086cd:	5d                   	pop    %ebp
801086ce:	c3                   	ret    
801086cf:	90                   	nop
        kfree((char*)curproc->free_head);
801086d0:	83 ec 0c             	sub    $0xc,%esp
        curproc->free_tail = 0;
801086d3:	c7 83 18 04 00 00 00 	movl   $0x0,0x418(%ebx)
801086da:	00 00 00 
        kfree((char*)curproc->free_head);
801086dd:	52                   	push   %edx
801086de:	e8 6d a3 ff ff       	call   80102a50 <kfree>
        curproc->free_head = 0;
801086e3:	c7 83 14 04 00 00 00 	movl   $0x0,0x414(%ebx)
801086ea:	00 00 00 
801086ed:	83 c4 10             	add    $0x10,%esp
801086f0:	e9 37 ff ff ff       	jmp    8010862c <handle_pagedout+0x12c>
801086f5:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < MAX_PSYC_PAGES; i++)
801086f8:	b8 6c 00 00 00       	mov    $0x6c,%eax
  return -1;
801086fd:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108702:	e9 64 fe ff ff       	jmp    8010856b <handle_pagedout+0x6b>
80108707:	89 f6                	mov    %esi,%esi
80108709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

int
getNextFreeRamIndex()
{ 
  int i;
  struct proc * currproc = myproc();
80108710:	e8 ab bb ff ff       	call   801042c0 <myproc>
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108715:	31 ff                	xor    %edi,%edi
80108717:	05 4c 02 00 00       	add    $0x24c,%eax
8010871c:	eb 0d                	jmp    8010872b <handle_pagedout+0x22b>
8010871e:	66 90                	xchg   %ax,%ax
80108720:	83 c7 01             	add    $0x1,%edi
80108723:	83 c0 1c             	add    $0x1c,%eax
80108726:	83 ff 10             	cmp    $0x10,%edi
80108729:	74 65                	je     80108790 <handle_pagedout+0x290>
  {
    if(((struct page)currproc->ramPages[i]).isused == 0)
8010872b:	8b 10                	mov    (%eax),%edx
8010872d:	85 d2                	test   %edx,%edx
8010872f:	75 ef                	jne    80108720 <handle_pagedout+0x220>
      cprintf("filling ram slot: %d\n", new_indx);
80108731:	83 ec 08             	sub    $0x8,%esp
80108734:	57                   	push   %edi
80108735:	68 e3 9c 10 80       	push   $0x80109ce3
      curproc->ramPages[new_indx].virt_addr = start_page;
8010873a:	6b ff 1c             	imul   $0x1c,%edi,%edi
      cprintf("filling ram slot: %d\n", new_indx);
8010873d:	e8 1e 7f ff ff       	call   80100660 <cprintf>
80108742:	83 c4 10             	add    $0x10,%esp
      curproc->ramPages[new_indx].virt_addr = start_page;
80108745:	01 df                	add    %ebx,%edi
80108747:	89 b7 50 02 00 00    	mov    %esi,0x250(%edi)
      curproc->ramPages[new_indx].isused = 1;
8010874d:	c7 87 4c 02 00 00 01 	movl   $0x1,0x24c(%edi)
80108754:	00 00 00 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108757:	8b 43 04             	mov    0x4(%ebx),%eax
      curproc->ramPages[new_indx].swap_offset = -1;//change the swap offset by the new index
8010875a:	c7 87 54 02 00 00 ff 	movl   $0xffffffff,0x254(%edi)
80108761:	ff ff ff 
      curproc->ramPages[new_indx].pgdir = curproc->pgdir;
80108764:	89 87 48 02 00 00    	mov    %eax,0x248(%edi)
      curproc->num_ram++;
8010876a:	83 83 08 04 00 00 01 	addl   $0x1,0x408(%ebx)
      curproc->num_swap--;
80108771:	83 ab 0c 04 00 00 01 	subl   $0x1,0x40c(%ebx)
}
80108778:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010877b:	5b                   	pop    %ebx
8010877c:	5e                   	pop    %esi
8010877d:	5f                   	pop    %edi
8010877e:	5d                   	pop    %ebp
8010877f:	c3                   	ret    
      curproc->free_head = new_block;
80108780:	89 83 14 04 00 00    	mov    %eax,0x414(%ebx)
80108786:	e9 3f fe ff ff       	jmp    801085ca <handle_pagedout+0xca>
8010878b:	90                   	nop
8010878c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return i;
  }
  return -1;
80108790:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80108795:	eb 9a                	jmp    80108731 <handle_pagedout+0x231>
      panic("allocuvm: readFromSwapFile");
80108797:	83 ec 0c             	sub    $0xc,%esp
8010879a:	68 c8 9c 10 80       	push   $0x80109cc8
8010879f:	e8 ec 7b ff ff       	call   80100390 <panic>
        panic("allocuvm: writeToSwapFile");
801087a4:	83 ec 0c             	sub    $0xc,%esp
801087a7:	68 f4 9b 10 80       	push   $0x80109bf4
801087ac:	e8 df 7b ff ff       	call   80100390 <panic>
        panic("pagefault: ram page is not present");
801087b1:	83 ec 0c             	sub    $0xc,%esp
801087b4:	68 70 9e 10 80       	push   $0x80109e70
801087b9:	e8 d2 7b ff ff       	call   80100390 <panic>
801087be:	66 90                	xchg   %ax,%ax

801087c0 <pagefault>:
{
801087c0:	55                   	push   %ebp
801087c1:	89 e5                	mov    %esp,%ebp
801087c3:	57                   	push   %edi
801087c4:	56                   	push   %esi
801087c5:	53                   	push   %ebx
801087c6:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
801087c9:	e8 f2 ba ff ff       	call   801042c0 <myproc>
801087ce:	89 c3                	mov    %eax,%ebx
  asm volatile("movl %%cr2,%0" : "=r" (val));
801087d0:	0f 20 d6             	mov    %cr2,%esi
  curproc->totalPgfltCount++;
801087d3:	83 80 28 04 00 00 01 	addl   $0x1,0x428(%eax)
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
801087da:	89 f7                	mov    %esi,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801087dc:	8b 40 04             	mov    0x4(%eax),%eax
  char *start_page = (char*)PGROUNDDOWN((uint)va); //round the va to closet 2 exponenet, to get the start of the page addr
801087df:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  pte = walkpgdir(curproc->pgdir, start_page, 0);
801087e5:	31 c9                	xor    %ecx,%ecx
801087e7:	89 fa                	mov    %edi,%edx
801087e9:	e8 22 ed ff ff       	call   80107510 <walkpgdir>
  if((*pte & PTE_PG) && (*pte & ~PTE_COW)) // paged out, not COW todo
801087ee:	8b 10                	mov    (%eax),%edx
801087f0:	f6 c6 02             	test   $0x2,%dh
801087f3:	74 08                	je     801087fd <pagefault+0x3d>
801087f5:	81 e2 ff fb ff ff    	and    $0xfffffbff,%edx
801087fb:	75 63                	jne    80108860 <pagefault+0xa0>
    if(va >= KERNBASE || pte == 0)
801087fd:	85 f6                	test   %esi,%esi
801087ff:	78 2f                	js     80108830 <pagefault+0x70>
    if((pte = walkpgdir(curproc->pgdir, (void*)va, 0)) == 0)
80108801:	8b 43 04             	mov    0x4(%ebx),%eax
80108804:	31 c9                	xor    %ecx,%ecx
80108806:	89 f2                	mov    %esi,%edx
80108808:	e8 03 ed ff ff       	call   80107510 <walkpgdir>
8010880d:	85 c0                	test   %eax,%eax
8010880f:	74 65                	je     80108876 <pagefault+0xb6>
    handle_cow_pagefault(curproc, pte, va);
80108811:	83 ec 04             	sub    $0x4,%esp
80108814:	56                   	push   %esi
80108815:	50                   	push   %eax
80108816:	53                   	push   %ebx
80108817:	e8 14 fc ff ff       	call   80108430 <handle_cow_pagefault>
8010881c:	83 c4 10             	add    $0x10,%esp
}
8010881f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108822:	5b                   	pop    %ebx
80108823:	5e                   	pop    %esi
80108824:	5f                   	pop    %edi
80108825:	5d                   	pop    %ebp
80108826:	c3                   	ret    
80108827:	89 f6                	mov    %esi,%esi
80108829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cprintf("Page fault: pid %d (%s) accesses invalid address.\n", curproc->pid, curproc->name);
80108830:	8d 43 6c             	lea    0x6c(%ebx),%eax
80108833:	83 ec 04             	sub    $0x4,%esp
80108836:	50                   	push   %eax
80108837:	ff 73 10             	pushl  0x10(%ebx)
8010883a:	68 94 9e 10 80       	push   $0x80109e94
8010883f:	e8 1c 7e ff ff       	call   80100660 <cprintf>
      curproc->killed = 1;
80108844:	c7 43 24 01 00 00 00 	movl   $0x1,0x24(%ebx)
      return;
8010884b:	83 c4 10             	add    $0x10,%esp
}
8010884e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108851:	5b                   	pop    %ebx
80108852:	5e                   	pop    %esi
80108853:	5f                   	pop    %edi
80108854:	5d                   	pop    %ebp
80108855:	c3                   	ret    
80108856:	8d 76 00             	lea    0x0(%esi),%esi
80108859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    handle_pagedout(curproc, start_page, pte);
80108860:	83 ec 04             	sub    $0x4,%esp
80108863:	50                   	push   %eax
80108864:	57                   	push   %edi
80108865:	53                   	push   %ebx
80108866:	e8 95 fc ff ff       	call   80108500 <handle_pagedout>
8010886b:	83 c4 10             	add    $0x10,%esp
}
8010886e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108871:	5b                   	pop    %ebx
80108872:	5e                   	pop    %esi
80108873:	5f                   	pop    %edi
80108874:	5d                   	pop    %ebp
80108875:	c3                   	ret    
      panic("pagefult (cow): pte is 0");
80108876:	83 ec 0c             	sub    $0xc,%esp
80108879:	68 f9 9c 10 80       	push   $0x80109cf9
8010887e:	e8 0d 7b ff ff       	call   80100390 <panic>
80108883:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108890 <update_selectionfiled_pagefault>:
80108890:	55                   	push   %ebp
80108891:	89 e5                	mov    %esp,%ebp
80108893:	5d                   	pop    %ebp
80108894:	c3                   	ret    
80108895:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80108899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801088a0 <copyuvm>:
{
801088a0:	55                   	push   %ebp
801088a1:	89 e5                	mov    %esp,%ebp
801088a3:	57                   	push   %edi
801088a4:	56                   	push   %esi
801088a5:	53                   	push   %ebx
801088a6:	83 ec 1c             	sub    $0x1c,%esp
  if((d = setupkvm()) == 0)
801088a9:	e8 42 f8 ff ff       	call   801080f0 <setupkvm>
801088ae:	85 c0                	test   %eax,%eax
801088b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801088b3:	0f 84 be 00 00 00    	je     80108977 <copyuvm+0xd7>
  for(i = 0; i < sz; i += PGSIZE){
801088b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801088bc:	85 db                	test   %ebx,%ebx
801088be:	0f 84 b3 00 00 00    	je     80108977 <copyuvm+0xd7>
801088c4:	31 f6                	xor    %esi,%esi
801088c6:	eb 69                	jmp    80108931 <copyuvm+0x91>
801088c8:	90                   	nop
801088c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
801088d0:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801088d2:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
801088d7:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
801088dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
801088e0:	e8 4b a4 ff ff       	call   80102d30 <kalloc>
801088e5:	85 c0                	test   %eax,%eax
801088e7:	89 c3                	mov    %eax,%ebx
801088e9:	0f 84 b1 00 00 00    	je     801089a0 <copyuvm+0x100>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801088ef:	83 ec 04             	sub    $0x4,%esp
801088f2:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801088f8:	68 00 10 00 00       	push   $0x1000
801088fd:	57                   	push   %edi
801088fe:	50                   	push   %eax
801088ff:	e8 0c cb ff ff       	call   80105410 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80108904:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010890a:	5a                   	pop    %edx
8010890b:	59                   	pop    %ecx
8010890c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010890f:	50                   	push   %eax
80108910:	b9 00 10 00 00       	mov    $0x1000,%ecx
80108915:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108918:	89 f2                	mov    %esi,%edx
8010891a:	e8 71 ec ff ff       	call   80107590 <mappages>
8010891f:	83 c4 10             	add    $0x10,%esp
80108922:	85 c0                	test   %eax,%eax
80108924:	78 62                	js     80108988 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80108926:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010892c:	39 75 0c             	cmp    %esi,0xc(%ebp)
8010892f:	76 46                	jbe    80108977 <copyuvm+0xd7>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108931:	8b 45 08             	mov    0x8(%ebp),%eax
80108934:	31 c9                	xor    %ecx,%ecx
80108936:	89 f2                	mov    %esi,%edx
80108938:	e8 d3 eb ff ff       	call   80107510 <walkpgdir>
8010893d:	85 c0                	test   %eax,%eax
8010893f:	0f 84 93 00 00 00    	je     801089d8 <copyuvm+0x138>
    if(!(*pte & PTE_P) && !(*pte & PTE_PG))
80108945:	8b 00                	mov    (%eax),%eax
80108947:	a9 01 02 00 00       	test   $0x201,%eax
8010894c:	74 7d                	je     801089cb <copyuvm+0x12b>
    if (*pte & PTE_PG) {
8010894e:	f6 c4 02             	test   $0x2,%ah
80108951:	0f 84 79 ff ff ff    	je     801088d0 <copyuvm+0x30>
      pte = walkpgdir(d, (void*) i, 1);
80108957:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010895a:	89 f2                	mov    %esi,%edx
8010895c:	b9 01 00 00 00       	mov    $0x1,%ecx
  for(i = 0; i < sz; i += PGSIZE){
80108961:	81 c6 00 10 00 00    	add    $0x1000,%esi
      pte = walkpgdir(d, (void*) i, 1);
80108967:	e8 a4 eb ff ff       	call   80107510 <walkpgdir>
  for(i = 0; i < sz; i += PGSIZE){
8010896c:	39 75 0c             	cmp    %esi,0xc(%ebp)
      *pte = PTE_U | PTE_W | PTE_PG;
8010896f:	c7 00 06 02 00 00    	movl   $0x206,(%eax)
  for(i = 0; i < sz; i += PGSIZE){
80108975:	77 ba                	ja     80108931 <copyuvm+0x91>
}
80108977:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010897a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010897d:	5b                   	pop    %ebx
8010897e:	5e                   	pop    %esi
8010897f:	5f                   	pop    %edi
80108980:	5d                   	pop    %ebp
80108981:	c3                   	ret    
80108982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("copyuvm: mappages failed\n");
80108988:	83 ec 0c             	sub    $0xc,%esp
8010898b:	68 a1 9c 10 80       	push   $0x80109ca1
80108990:	e8 cb 7c ff ff       	call   80100660 <cprintf>
      kfree(mem);
80108995:	89 1c 24             	mov    %ebx,(%esp)
80108998:	e8 b3 a0 ff ff       	call   80102a50 <kfree>
      goto bad;
8010899d:	83 c4 10             	add    $0x10,%esp
  cprintf("bad: copyuvm\n");
801089a0:	83 ec 0c             	sub    $0xc,%esp
801089a3:	68 2c 9d 10 80       	push   $0x80109d2c
801089a8:	e8 b3 7c ff ff       	call   80100660 <cprintf>
  freevm(d);
801089ad:	58                   	pop    %eax
801089ae:	ff 75 e0             	pushl  -0x20(%ebp)
801089b1:	e8 ba f6 ff ff       	call   80108070 <freevm>
  return 0;
801089b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801089bd:	83 c4 10             	add    $0x10,%esp
}
801089c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801089c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801089c6:	5b                   	pop    %ebx
801089c7:	5e                   	pop    %esi
801089c8:	5f                   	pop    %edi
801089c9:	5d                   	pop    %ebp
801089ca:	c3                   	ret    
      panic("copyuvm: page not present and also not paged out to disk");
801089cb:	83 ec 0c             	sub    $0xc,%esp
801089ce:	68 c8 9e 10 80       	push   $0x80109ec8
801089d3:	e8 b8 79 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801089d8:	83 ec 0c             	sub    $0xc,%esp
801089db:	68 12 9d 10 80       	push   $0x80109d12
801089e0:	e8 ab 79 ff ff       	call   80100390 <panic>
801089e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801089e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801089f0 <uva2ka>:
{
801089f0:	55                   	push   %ebp
  pte = walkpgdir(pgdir, uva, 0);
801089f1:	31 c9                	xor    %ecx,%ecx
{
801089f3:	89 e5                	mov    %esp,%ebp
801089f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801089f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801089fb:	8b 45 08             	mov    0x8(%ebp),%eax
801089fe:	e8 0d eb ff ff       	call   80107510 <walkpgdir>
  if((*pte & PTE_P) == 0)
80108a03:	8b 00                	mov    (%eax),%eax
}
80108a05:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80108a06:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108a08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80108a0d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80108a10:	05 00 00 00 80       	add    $0x80000000,%eax
80108a15:	83 fa 05             	cmp    $0x5,%edx
80108a18:	ba 00 00 00 00       	mov    $0x0,%edx
80108a1d:	0f 45 c2             	cmovne %edx,%eax
}
80108a20:	c3                   	ret    
80108a21:	eb 0d                	jmp    80108a30 <copyout>
80108a23:	90                   	nop
80108a24:	90                   	nop
80108a25:	90                   	nop
80108a26:	90                   	nop
80108a27:	90                   	nop
80108a28:	90                   	nop
80108a29:	90                   	nop
80108a2a:	90                   	nop
80108a2b:	90                   	nop
80108a2c:	90                   	nop
80108a2d:	90                   	nop
80108a2e:	90                   	nop
80108a2f:	90                   	nop

80108a30 <copyout>:
{
80108a30:	55                   	push   %ebp
80108a31:	89 e5                	mov    %esp,%ebp
80108a33:	57                   	push   %edi
80108a34:	56                   	push   %esi
80108a35:	53                   	push   %ebx
80108a36:	83 ec 1c             	sub    $0x1c,%esp
80108a39:	8b 5d 14             	mov    0x14(%ebp),%ebx
80108a3c:	8b 55 0c             	mov    0xc(%ebp),%edx
80108a3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(len > 0){
80108a42:	85 db                	test   %ebx,%ebx
80108a44:	75 40                	jne    80108a86 <copyout+0x56>
80108a46:	eb 70                	jmp    80108ab8 <copyout+0x88>
80108a48:	90                   	nop
80108a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    n = PGSIZE - (va - va0);
80108a50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80108a53:	89 f1                	mov    %esi,%ecx
80108a55:	29 d1                	sub    %edx,%ecx
80108a57:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80108a5d:	39 d9                	cmp    %ebx,%ecx
80108a5f:	0f 47 cb             	cmova  %ebx,%ecx
    memmove(pa0 + (va - va0), buf, n);
80108a62:	29 f2                	sub    %esi,%edx
80108a64:	83 ec 04             	sub    $0x4,%esp
80108a67:	01 d0                	add    %edx,%eax
80108a69:	51                   	push   %ecx
80108a6a:	57                   	push   %edi
80108a6b:	50                   	push   %eax
80108a6c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108a6f:	e8 9c c9 ff ff       	call   80105410 <memmove>
    buf += n;
80108a74:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80108a77:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80108a7a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80108a80:	01 cf                	add    %ecx,%edi
  while(len > 0){
80108a82:	29 cb                	sub    %ecx,%ebx
80108a84:	74 32                	je     80108ab8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80108a86:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108a88:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80108a8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80108a8e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80108a94:	56                   	push   %esi
80108a95:	ff 75 08             	pushl  0x8(%ebp)
80108a98:	e8 53 ff ff ff       	call   801089f0 <uva2ka>
    if(pa0 == 0)
80108a9d:	83 c4 10             	add    $0x10,%esp
80108aa0:	85 c0                	test   %eax,%eax
80108aa2:	75 ac                	jne    80108a50 <copyout+0x20>
}
80108aa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80108aa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108aac:	5b                   	pop    %ebx
80108aad:	5e                   	pop    %esi
80108aae:	5f                   	pop    %edi
80108aaf:	5d                   	pop    %ebp
80108ab0:	c3                   	ret    
80108ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108ab8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80108abb:	31 c0                	xor    %eax,%eax
}
80108abd:	5b                   	pop    %ebx
80108abe:	5e                   	pop    %esi
80108abf:	5f                   	pop    %edi
80108ac0:	5d                   	pop    %ebp
80108ac1:	c3                   	ret    
80108ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108ad0 <getNextFreeRamIndex>:
{ 
80108ad0:	55                   	push   %ebp
80108ad1:	89 e5                	mov    %esp,%ebp
80108ad3:	83 ec 08             	sub    $0x8,%esp
  struct proc * currproc = myproc();
80108ad6:	e8 e5 b7 ff ff       	call   801042c0 <myproc>
80108adb:	8d 90 4c 02 00 00    	lea    0x24c(%eax),%edx
  for(i = 0; i < MAX_PSYC_PAGES ; i++)
80108ae1:	31 c0                	xor    %eax,%eax
80108ae3:	eb 0e                	jmp    80108af3 <getNextFreeRamIndex+0x23>
80108ae5:	8d 76 00             	lea    0x0(%esi),%esi
80108ae8:	83 c0 01             	add    $0x1,%eax
80108aeb:	83 c2 1c             	add    $0x1c,%edx
80108aee:	83 f8 10             	cmp    $0x10,%eax
80108af1:	74 0d                	je     80108b00 <getNextFreeRamIndex+0x30>
    if(((struct page)currproc->ramPages[i]).isused == 0)
80108af3:	8b 0a                	mov    (%edx),%ecx
80108af5:	85 c9                	test   %ecx,%ecx
80108af7:	75 ef                	jne    80108ae8 <getNextFreeRamIndex+0x18>
}
80108af9:	c9                   	leave  
80108afa:	c3                   	ret    
80108afb:	90                   	nop
80108afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80108b00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80108b05:	c9                   	leave  
80108b06:	c3                   	ret    
80108b07:	89 f6                	mov    %esi,%esi
80108b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108b10 <updateLapa>:
// Blank page.
//PAGEBREAK!
// Blank page.

void updateLapa(struct proc* p)
{
80108b10:	55                   	push   %ebp
80108b11:	89 e5                	mov    %esp,%ebp
80108b13:	56                   	push   %esi
80108b14:	53                   	push   %ebx
80108b15:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108b18:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108b1e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108b24:	eb 1d                	jmp    80108b43 <updateLapa+0x33>
80108b26:	8d 76 00             	lea    0x0(%esi),%esi
80108b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateLapa: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // shift right one bit
      cur_page->lapa_counter |= 1 << 31; // turn on MSB
80108b30:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108b36:	89 53 18             	mov    %edx,0x18(%ebx)
      *pte &= ~PTE_A;
80108b39:	83 20 df             	andl   $0xffffffdf,(%eax)
80108b3c:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108b3f:	39 f3                	cmp    %esi,%ebx
80108b41:	74 2b                	je     80108b6e <updateLapa+0x5e>
    if(!cur_page->isused)
80108b43:	8b 43 04             	mov    0x4(%ebx),%eax
80108b46:	85 c0                	test   %eax,%eax
80108b48:	74 f2                	je     80108b3c <updateLapa+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108b4a:	8b 53 08             	mov    0x8(%ebx),%edx
80108b4d:	8b 03                	mov    (%ebx),%eax
80108b4f:	31 c9                	xor    %ecx,%ecx
80108b51:	e8 ba e9 ff ff       	call   80107510 <walkpgdir>
80108b56:	85 c0                	test   %eax,%eax
80108b58:	74 1b                	je     80108b75 <updateLapa+0x65>
80108b5a:	8b 53 18             	mov    0x18(%ebx),%edx
80108b5d:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
80108b5f:	f6 00 20             	testb  $0x20,(%eax)
80108b62:	75 cc                	jne    80108b30 <updateLapa+0x20>
    }
    else
    {
      cur_page->lapa_counter = cur_page->lapa_counter >> 1; // just shit right one bit
80108b64:	89 53 18             	mov    %edx,0x18(%ebx)
80108b67:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108b6a:	39 f3                	cmp    %esi,%ebx
80108b6c:	75 d5                	jne    80108b43 <updateLapa+0x33>
    }
  }
}
80108b6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108b71:	5b                   	pop    %ebx
80108b72:	5e                   	pop    %esi
80108b73:	5d                   	pop    %ebp
80108b74:	c3                   	ret    
      panic("updateLapa: no pte");
80108b75:	83 ec 0c             	sub    $0xc,%esp
80108b78:	68 3a 9d 10 80       	push   $0x80109d3a
80108b7d:	e8 0e 78 ff ff       	call   80100390 <panic>
80108b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108b90 <updateNfua>:

void updateNfua(struct proc* p)
{
80108b90:	55                   	push   %ebp
80108b91:	89 e5                	mov    %esp,%ebp
80108b93:	56                   	push   %esi
80108b94:	53                   	push   %ebx
80108b95:	8b 75 08             	mov    0x8(%ebp),%esi
  struct page *ramPages = p->ramPages;
80108b98:	8d 9e 48 02 00 00    	lea    0x248(%esi),%ebx
80108b9e:	81 c6 08 04 00 00    	add    $0x408,%esi
80108ba4:	eb 1d                	jmp    80108bc3 <updateNfua+0x33>
80108ba6:	8d 76 00             	lea    0x0(%esi),%esi
80108ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
      panic("updateNfua: no pte");
    if(*pte & PTE_A) // if accessed
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // shift right one bit
      cur_page->nfua_counter |= 0x80000000; // turn on MSB
80108bb0:	81 ca 00 00 00 80    	or     $0x80000000,%edx
80108bb6:	89 53 14             	mov    %edx,0x14(%ebx)
      *pte &= ~PTE_A;
80108bb9:	83 20 df             	andl   $0xffffffdf,(%eax)
80108bbc:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108bbf:	39 f3                	cmp    %esi,%ebx
80108bc1:	74 2b                	je     80108bee <updateNfua+0x5e>
    if(!cur_page->isused)
80108bc3:	8b 43 04             	mov    0x4(%ebx),%eax
80108bc6:	85 c0                	test   %eax,%eax
80108bc8:	74 f2                	je     80108bbc <updateNfua+0x2c>
    if((pte = walkpgdir(cur_page->pgdir, cur_page->virt_addr, 0)) == 0)
80108bca:	8b 53 08             	mov    0x8(%ebx),%edx
80108bcd:	8b 03                	mov    (%ebx),%eax
80108bcf:	31 c9                	xor    %ecx,%ecx
80108bd1:	e8 3a e9 ff ff       	call   80107510 <walkpgdir>
80108bd6:	85 c0                	test   %eax,%eax
80108bd8:	74 1b                	je     80108bf5 <updateNfua+0x65>
80108bda:	8b 53 14             	mov    0x14(%ebx),%edx
80108bdd:	d1 ea                	shr    %edx
    if(*pte & PTE_A) // if accessed
80108bdf:	f6 00 20             	testb  $0x20,(%eax)
80108be2:	75 cc                	jne    80108bb0 <updateNfua+0x20>
      
    }
    else
    {
      cur_page->nfua_counter = cur_page->nfua_counter >> 1; // just shit right one bit
80108be4:	89 53 14             	mov    %edx,0x14(%ebx)
80108be7:	83 c3 1c             	add    $0x1c,%ebx
  for(i = 0; i < MAX_PSYC_PAGES; i++)
80108bea:	39 f3                	cmp    %esi,%ebx
80108bec:	75 d5                	jne    80108bc3 <updateNfua+0x33>
    }
  }
}
80108bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108bf1:	5b                   	pop    %ebx
80108bf2:	5e                   	pop    %esi
80108bf3:	5d                   	pop    %ebp
80108bf4:	c3                   	ret    
      panic("updateNfua: no pte");
80108bf5:	83 ec 0c             	sub    $0xc,%esp
80108bf8:	68 4d 9d 10 80       	push   $0x80109d4d
80108bfd:	e8 8e 77 ff ff       	call   80100390 <panic>
80108c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108c10 <indexToEvict>:
uint indexToEvict()
{  
80108c10:	55                   	push   %ebp
  #if SELECTION==AQ
    return aq();
  #else
  return 11; // default
  #endif
}
80108c11:	b8 03 00 00 00       	mov    $0x3,%eax
{  
80108c16:	89 e5                	mov    %esp,%ebp
}
80108c18:	5d                   	pop    %ebp
80108c19:	c3                   	ret    
80108c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80108c20 <aq>:

uint aq()
{
80108c20:	55                   	push   %ebp
80108c21:	89 e5                	mov    %esp,%ebp
80108c23:	57                   	push   %edi
80108c24:	56                   	push   %esi
80108c25:	53                   	push   %ebx
80108c26:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108c29:	e8 92 b6 ff ff       	call   801042c0 <myproc>
  int res = curproc->queue_tail->page_index;
  struct queue_node* new_tail;
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108c2e:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
  int res = curproc->queue_tail->page_index;
80108c34:	8b 88 20 04 00 00    	mov    0x420(%eax),%ecx
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108c3a:	85 d2                	test   %edx,%edx
  int res = curproc->queue_tail->page_index;
80108c3c:	8b 71 08             	mov    0x8(%ecx),%esi
  if(curproc->queue_tail == 0 || curproc->queue_head == 0)
80108c3f:	74 45                	je     80108c86 <aq+0x66>
  {
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
  }

  if(curproc->queue_tail == curproc->queue_head)
80108c41:	39 d1                	cmp    %edx,%ecx
80108c43:	89 c3                	mov    %eax,%ebx
80108c45:	74 31                	je     80108c78 <aq+0x58>
    curproc->queue_head=0;
    new_tail = 0;
  }
  else
  {
    curproc->queue_tail->prev->next = 0;
80108c47:	8b 41 04             	mov    0x4(%ecx),%eax
80108c4a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    new_tail =  curproc->queue_tail->prev;
80108c50:	8b 93 20 04 00 00    	mov    0x420(%ebx),%edx
80108c56:	8b 7a 04             	mov    0x4(%edx),%edi
  }

  kfree((char*)curproc->queue_tail);
80108c59:	83 ec 0c             	sub    $0xc,%esp
80108c5c:	52                   	push   %edx
80108c5d:	e8 ee 9d ff ff       	call   80102a50 <kfree>
  curproc->queue_tail = new_tail;
80108c62:	89 bb 20 04 00 00    	mov    %edi,0x420(%ebx)
  
  return  res;


}
80108c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108c6b:	89 f0                	mov    %esi,%eax
80108c6d:	5b                   	pop    %ebx
80108c6e:	5e                   	pop    %esi
80108c6f:	5f                   	pop    %edi
80108c70:	5d                   	pop    %ebp
80108c71:	c3                   	ret    
80108c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    curproc->queue_head=0;
80108c78:	c7 80 1c 04 00 00 00 	movl   $0x0,0x41c(%eax)
80108c7f:	00 00 00 
    new_tail = 0;
80108c82:	31 ff                	xor    %edi,%edi
80108c84:	eb d3                	jmp    80108c59 <aq+0x39>
    panic("AQ INDEX SELECTION: empty queue cann't make index selection!");
80108c86:	83 ec 0c             	sub    $0xc,%esp
80108c89:	68 04 9f 10 80       	push   $0x80109f04
80108c8e:	e8 fd 76 ff ff       	call   80100390 <panic>
80108c93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108ca0 <lapa>:
uint lapa()
{
80108ca0:	55                   	push   %ebp
80108ca1:	89 e5                	mov    %esp,%ebp
80108ca3:	57                   	push   %edi
80108ca4:	56                   	push   %esi
80108ca5:	53                   	push   %ebx
80108ca6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80108ca9:	e8 12 b6 ff ff       	call   801042c0 <myproc>
  struct page *ramPages = curproc->ramPages;
  /* find the page with the smallest number of '1's */
  int i;
  uint minNumOfOnes = countSetBits(ramPages[0].lapa_counter);
80108cae:	8b 90 60 02 00 00    	mov    0x260(%eax),%edx
  struct page *ramPages = curproc->ramPages;
80108cb4:	8d b8 48 02 00 00    	lea    0x248(%eax),%edi
80108cba:	89 7d dc             	mov    %edi,-0x24(%ebp)
}

uint countSetBits(uint n)
{
    uint count = 0;
    while (n) {
80108cbd:	85 d2                	test   %edx,%edx
80108cbf:	0f 84 ff 00 00 00    	je     80108dc4 <lapa+0x124>
    uint count = 0;
80108cc5:	31 c9                	xor    %ecx,%ecx
80108cc7:	89 f6                	mov    %esi,%esi
80108cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        count += n & 1;
80108cd0:	89 d3                	mov    %edx,%ebx
80108cd2:	83 e3 01             	and    $0x1,%ebx
80108cd5:	01 d9                	add    %ebx,%ecx
    while (n) {
80108cd7:	d1 ea                	shr    %edx
80108cd9:	75 f5                	jne    80108cd0 <lapa+0x30>
80108cdb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80108cde:	05 7c 02 00 00       	add    $0x27c,%eax
  uint instances = 0;
80108ce3:	31 ff                	xor    %edi,%edi
  uint minloc = 0;
80108ce5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80108cec:	89 45 d8             	mov    %eax,-0x28(%ebp)
    uint count = 0;
80108cef:	89 c6                	mov    %eax,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108cf1:	bb 01 00 00 00       	mov    $0x1,%ebx
80108cf6:	8d 76 00             	lea    0x0(%esi),%esi
80108cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108d00:	8b 06                	mov    (%esi),%eax
    uint count = 0;
80108d02:	31 d2                	xor    %edx,%edx
    while (n) {
80108d04:	85 c0                	test   %eax,%eax
80108d06:	74 13                	je     80108d1b <lapa+0x7b>
80108d08:	90                   	nop
80108d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108d10:	89 c1                	mov    %eax,%ecx
80108d12:	83 e1 01             	and    $0x1,%ecx
80108d15:	01 ca                	add    %ecx,%edx
    while (n) {
80108d17:	d1 e8                	shr    %eax
80108d19:	75 f5                	jne    80108d10 <lapa+0x70>
    if(numOfOnes < minNumOfOnes)
80108d1b:	3b 55 e4             	cmp    -0x1c(%ebp),%edx
80108d1e:	0f 82 84 00 00 00    	jb     80108da8 <lapa+0x108>
      instances++;
80108d24:	0f 94 c0             	sete   %al
80108d27:	0f b6 c0             	movzbl %al,%eax
80108d2a:	01 c7                	add    %eax,%edi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d2c:	83 c3 01             	add    $0x1,%ebx
80108d2f:	83 c6 1c             	add    $0x1c,%esi
80108d32:	83 fb 10             	cmp    $0x10,%ebx
80108d35:	75 c9                	jne    80108d00 <lapa+0x60>
  if(instances > 1) // more than one counter with minimal number of 1's
80108d37:	83 ff 01             	cmp    $0x1,%edi
80108d3a:	76 5b                	jbe    80108d97 <lapa+0xf7>
      uint minvalue = ramPages[minloc].lapa_counter;
80108d3c:	6b 45 e0 1c          	imul   $0x1c,-0x20(%ebp),%eax
80108d40:	8b 7d dc             	mov    -0x24(%ebp),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d43:	be 01 00 00 00       	mov    $0x1,%esi
      uint minvalue = ramPages[minloc].lapa_counter;
80108d48:	8b 7c 07 18          	mov    0x18(%edi,%eax,1),%edi
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d4c:	89 7d dc             	mov    %edi,-0x24(%ebp)
80108d4f:	8b 7d d8             	mov    -0x28(%ebp),%edi
80108d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        uint numOfOnes = countSetBits(ramPages[i].lapa_counter);
80108d58:	8b 1f                	mov    (%edi),%ebx
    while (n) {
80108d5a:	85 db                	test   %ebx,%ebx
80108d5c:	74 62                	je     80108dc0 <lapa+0x120>
80108d5e:	89 d8                	mov    %ebx,%eax
    uint count = 0;
80108d60:	31 d2                	xor    %edx,%edx
80108d62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        count += n & 1;
80108d68:	89 c1                	mov    %eax,%ecx
80108d6a:	83 e1 01             	and    $0x1,%ecx
80108d6d:	01 ca                	add    %ecx,%edx
    while (n) {
80108d6f:	d1 e8                	shr    %eax
80108d71:	75 f5                	jne    80108d68 <lapa+0xc8>
        if(numOfOnes == minNumOfOnes && ramPages[i].lapa_counter < minvalue)
80108d73:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80108d76:	75 14                	jne    80108d8c <lapa+0xec>
80108d78:	8b 45 dc             	mov    -0x24(%ebp),%eax
80108d7b:	39 c3                	cmp    %eax,%ebx
80108d7d:	0f 43 d8             	cmovae %eax,%ebx
80108d80:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d83:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80108d86:	0f 42 c6             	cmovb  %esi,%eax
80108d89:	89 45 e0             	mov    %eax,-0x20(%ebp)
      for(i = 1; i < MAX_PSYC_PAGES; i++)
80108d8c:	83 c6 01             	add    $0x1,%esi
80108d8f:	83 c7 1c             	add    $0x1c,%edi
80108d92:	83 fe 10             	cmp    $0x10,%esi
80108d95:	75 c1                	jne    80108d58 <lapa+0xb8>
}
80108d97:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108d9a:	83 c4 1c             	add    $0x1c,%esp
80108d9d:	5b                   	pop    %ebx
80108d9e:	5e                   	pop    %esi
80108d9f:	5f                   	pop    %edi
80108da0:	5d                   	pop    %ebp
80108da1:	c3                   	ret    
80108da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      minloc = i;
80108da8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
80108dab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      instances = 1;
80108dae:	bf 01 00 00 00       	mov    $0x1,%edi
80108db3:	e9 74 ff ff ff       	jmp    80108d2c <lapa+0x8c>
80108db8:	90                   	nop
80108db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uint count = 0;
80108dc0:	31 d2                	xor    %edx,%edx
80108dc2:	eb af                	jmp    80108d73 <lapa+0xd3>
80108dc4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80108dcb:	e9 0e ff ff ff       	jmp    80108cde <lapa+0x3e>

80108dd0 <nfua>:
{
80108dd0:	55                   	push   %ebp
80108dd1:	89 e5                	mov    %esp,%ebp
80108dd3:	56                   	push   %esi
80108dd4:	53                   	push   %ebx
  struct proc *curproc = myproc();
80108dd5:	e8 e6 b4 ff ff       	call   801042c0 <myproc>
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108dda:	ba 01 00 00 00       	mov    $0x1,%edx
  uint minval = ramPages[0].nfua_counter;
80108ddf:	8b b0 5c 02 00 00    	mov    0x25c(%eax),%esi
80108de5:	8d 88 78 02 00 00    	lea    0x278(%eax),%ecx
  uint minloc = 0;
80108deb:	31 c0                	xor    %eax,%eax
80108ded:	8d 76 00             	lea    0x0(%esi),%esi
    if(ramPages[i].nfua_counter < minval)
80108df0:	8b 19                	mov    (%ecx),%ebx
80108df2:	39 f3                	cmp    %esi,%ebx
80108df4:	73 04                	jae    80108dfa <nfua+0x2a>
      minloc = i;
80108df6:	89 d0                	mov    %edx,%eax
    if(ramPages[i].nfua_counter < minval)
80108df8:	89 de                	mov    %ebx,%esi
  for(i = 1; i < MAX_PSYC_PAGES; i++)
80108dfa:	83 c2 01             	add    $0x1,%edx
80108dfd:	83 c1 1c             	add    $0x1c,%ecx
80108e00:	83 fa 10             	cmp    $0x10,%edx
80108e03:	75 eb                	jne    80108df0 <nfua+0x20>
}
80108e05:	5b                   	pop    %ebx
80108e06:	5e                   	pop    %esi
80108e07:	5d                   	pop    %ebp
80108e08:	c3                   	ret    
80108e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80108e10 <scfifo>:
{
80108e10:	55                   	push   %ebp
80108e11:	89 e5                	mov    %esp,%ebp
80108e13:	57                   	push   %edi
80108e14:	56                   	push   %esi
80108e15:	53                   	push   %ebx
80108e16:	83 ec 0c             	sub    $0xc,%esp
  struct proc* curproc = myproc();
80108e19:	e8 a2 b4 ff ff       	call   801042c0 <myproc>
80108e1e:	89 c7                	mov    %eax,%edi
80108e20:	8b 80 10 04 00 00    	mov    0x410(%eax),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108e26:	83 f8 0f             	cmp    $0xf,%eax
80108e29:	89 c3                	mov    %eax,%ebx
80108e2b:	7f 5f                	jg     80108e8c <scfifo+0x7c>
80108e2d:	6b c0 1c             	imul   $0x1c,%eax,%eax
80108e30:	8d b4 07 48 02 00 00 	lea    0x248(%edi,%eax,1),%esi
80108e37:	eb 17                	jmp    80108e50 <scfifo+0x40>
80108e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80108e40:	83 c3 01             	add    $0x1,%ebx
          *pte &= ~PTE_A; 
80108e43:	83 e2 df             	and    $0xffffffdf,%edx
80108e46:	83 c6 1c             	add    $0x1c,%esi
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108e49:	83 fb 10             	cmp    $0x10,%ebx
          *pte &= ~PTE_A; 
80108e4c:	89 10                	mov    %edx,(%eax)
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108e4e:	74 30                	je     80108e80 <scfifo+0x70>
      pte_t *pte = walkpgdir(curproc->ramPages[i].pgdir, curproc->ramPages[i].virt_addr, 0);
80108e50:	8b 56 08             	mov    0x8(%esi),%edx
80108e53:	8b 06                	mov    (%esi),%eax
80108e55:	31 c9                	xor    %ecx,%ecx
80108e57:	e8 b4 e6 ff ff       	call   80107510 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108e5c:	8b 10                	mov    (%eax),%edx
80108e5e:	f6 c2 20             	test   $0x20,%dl
80108e61:	75 dd                	jne    80108e40 <scfifo+0x30>
          if(curproc->clockHand == MAX_PSYC_PAGES - 1)
80108e63:	83 bf 10 04 00 00 0f 	cmpl   $0xf,0x410(%edi)
80108e6a:	74 74                	je     80108ee0 <scfifo+0xd0>
            curproc->clockHand = i + 1;
80108e6c:	8d 43 01             	lea    0x1(%ebx),%eax
80108e6f:	89 87 10 04 00 00    	mov    %eax,0x410(%edi)
}
80108e75:	83 c4 0c             	add    $0xc,%esp
80108e78:	89 d8                	mov    %ebx,%eax
80108e7a:	5b                   	pop    %ebx
80108e7b:	5e                   	pop    %esi
80108e7c:	5f                   	pop    %edi
80108e7d:	5d                   	pop    %ebp
80108e7e:	c3                   	ret    
80108e7f:	90                   	nop
80108e80:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
     for(i = curproc->clockHand ; i < MAX_PSYC_PAGES ; i++)
80108e86:	31 db                	xor    %ebx,%ebx
    for(j=0; j< curproc->clockHand ;j++)
80108e88:	85 c0                	test   %eax,%eax
80108e8a:	74 a1                	je     80108e2d <scfifo+0x1d>
80108e8c:	8d b7 48 02 00 00    	lea    0x248(%edi),%esi
80108e92:	31 c9                	xor    %ecx,%ecx
80108e94:	eb 20                	jmp    80108eb6 <scfifo+0xa6>
80108e96:	8d 76 00             	lea    0x0(%esi),%esi
80108e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
          *pte &= ~PTE_A;  
80108ea0:	83 e2 df             	and    $0xffffffdf,%edx
80108ea3:	83 c6 1c             	add    $0x1c,%esi
80108ea6:	89 10                	mov    %edx,(%eax)
    for(j=0; j< curproc->clockHand ;j++)
80108ea8:	8b 87 10 04 00 00    	mov    0x410(%edi),%eax
80108eae:	39 c8                	cmp    %ecx,%eax
80108eb0:	0f 86 70 ff ff ff    	jbe    80108e26 <scfifo+0x16>
      pte_t *pte = walkpgdir(curproc->ramPages[j].pgdir, curproc->ramPages[j].virt_addr, 0);
80108eb6:	8b 56 08             	mov    0x8(%esi),%edx
80108eb9:	8b 06                	mov    (%esi),%eax
80108ebb:	89 cb                	mov    %ecx,%ebx
80108ebd:	31 c9                	xor    %ecx,%ecx
80108ebf:	e8 4c e6 ff ff       	call   80107510 <walkpgdir>
       if(!(*pte & PTE_A)) //ref bit is off
80108ec4:	8b 10                	mov    (%eax),%edx
80108ec6:	8d 4b 01             	lea    0x1(%ebx),%ecx
80108ec9:	f6 c2 20             	test   $0x20,%dl
80108ecc:	75 d2                	jne    80108ea0 <scfifo+0x90>
          curproc->clockHand = j + 1;
80108ece:	89 8f 10 04 00 00    	mov    %ecx,0x410(%edi)
}
80108ed4:	83 c4 0c             	add    $0xc,%esp
80108ed7:	89 d8                	mov    %ebx,%eax
80108ed9:	5b                   	pop    %ebx
80108eda:	5e                   	pop    %esi
80108edb:	5f                   	pop    %edi
80108edc:	5d                   	pop    %ebp
80108edd:	c3                   	ret    
80108ede:	66 90                	xchg   %ax,%ax
            curproc->clockHand = 0;
80108ee0:	c7 87 10 04 00 00 00 	movl   $0x0,0x410(%edi)
80108ee7:	00 00 00 
}
80108eea:	83 c4 0c             	add    $0xc,%esp
80108eed:	89 d8                	mov    %ebx,%eax
80108eef:	5b                   	pop    %ebx
80108ef0:	5e                   	pop    %esi
80108ef1:	5f                   	pop    %edi
80108ef2:	5d                   	pop    %ebp
80108ef3:	c3                   	ret    
80108ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80108efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80108f00 <countSetBits>:
{
80108f00:	55                   	push   %ebp
    uint count = 0;
80108f01:	31 c0                	xor    %eax,%eax
{
80108f03:	89 e5                	mov    %esp,%ebp
80108f05:	8b 55 08             	mov    0x8(%ebp),%edx
    while (n) {
80108f08:	85 d2                	test   %edx,%edx
80108f0a:	74 0f                	je     80108f1b <countSetBits+0x1b>
80108f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        count += n & 1;
80108f10:	89 d1                	mov    %edx,%ecx
80108f12:	83 e1 01             	and    $0x1,%ecx
80108f15:	01 c8                	add    %ecx,%eax
    while (n) {
80108f17:	d1 ea                	shr    %edx
80108f19:	75 f5                	jne    80108f10 <countSetBits+0x10>
        n >>= 1;
    }
    return count;
}
80108f1b:	5d                   	pop    %ebp
80108f1c:	c3                   	ret    
80108f1d:	8d 76 00             	lea    0x0(%esi),%esi

80108f20 <swapAQ>:
// assumes there exist a page preceding curr_node.
// queue structure at entry point:
// [maybeLeft?] <-> [prev_node] <-> [curr_node] <-> [maybeRight?] 

void swapAQ(struct queue_node *curr_node)
{
80108f20:	55                   	push   %ebp
80108f21:	89 e5                	mov    %esp,%ebp
80108f23:	56                   	push   %esi
80108f24:	53                   	push   %ebx
80108f25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct queue_node *prev_node = curr_node->prev;
80108f28:	8b 73 04             	mov    0x4(%ebx),%esi
  struct queue_node *maybeLeft, *maybeRight;

  if(curr_node == myproc()->queue_tail)
80108f2b:	e8 90 b3 ff ff       	call   801042c0 <myproc>
80108f30:	39 98 20 04 00 00    	cmp    %ebx,0x420(%eax)
80108f36:	74 30                	je     80108f68 <swapAQ+0x48>
  {
    myproc()->queue_tail = prev_node;
    myproc()->queue_tail->next = 0;
  }

  if(prev_node == myproc()->queue_head)
80108f38:	e8 83 b3 ff ff       	call   801042c0 <myproc>
80108f3d:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108f43:	74 53                	je     80108f98 <swapAQ+0x78>
    myproc()->queue_head = curr_node;
    myproc()->queue_head->prev = 0;
  }

  // saving maybeLeft and maybeRight pointers for later
    maybeLeft = prev_node->prev;
80108f45:	8b 56 04             	mov    0x4(%esi),%edx
    maybeRight = curr_node->next;
80108f48:	8b 03                	mov    (%ebx),%eax

  // re-connecting prev_node and curr_node (simple)
  curr_node->next = prev_node;
80108f4a:	89 33                	mov    %esi,(%ebx)
  prev_node->prev = curr_node;
80108f4c:	89 5e 04             	mov    %ebx,0x4(%esi)

  // updating maybeLeft and maybeRight
  if(maybeLeft != 0)
80108f4f:	85 d2                	test   %edx,%edx
80108f51:	74 05                	je     80108f58 <swapAQ+0x38>
  {
    curr_node->prev = maybeLeft;
80108f53:	89 53 04             	mov    %edx,0x4(%ebx)
    maybeLeft->next = curr_node;    
80108f56:	89 1a                	mov    %ebx,(%edx)
  }
  
  if(maybeRight != 0)
80108f58:	85 c0                	test   %eax,%eax
80108f5a:	74 05                	je     80108f61 <swapAQ+0x41>
  {
    prev_node->next = maybeRight;
80108f5c:	89 06                	mov    %eax,(%esi)
    maybeRight->prev = prev_node;
80108f5e:	89 70 04             	mov    %esi,0x4(%eax)
  }
80108f61:	5b                   	pop    %ebx
80108f62:	5e                   	pop    %esi
80108f63:	5d                   	pop    %ebp
80108f64:	c3                   	ret    
80108f65:	8d 76 00             	lea    0x0(%esi),%esi
    myproc()->queue_tail = prev_node;
80108f68:	e8 53 b3 ff ff       	call   801042c0 <myproc>
80108f6d:	89 b0 20 04 00 00    	mov    %esi,0x420(%eax)
    myproc()->queue_tail->next = 0;
80108f73:	e8 48 b3 ff ff       	call   801042c0 <myproc>
80108f78:	8b 80 20 04 00 00    	mov    0x420(%eax),%eax
80108f7e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  if(prev_node == myproc()->queue_head)
80108f84:	e8 37 b3 ff ff       	call   801042c0 <myproc>
80108f89:	39 b0 1c 04 00 00    	cmp    %esi,0x41c(%eax)
80108f8f:	75 b4                	jne    80108f45 <swapAQ+0x25>
80108f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    myproc()->queue_head = curr_node;
80108f98:	e8 23 b3 ff ff       	call   801042c0 <myproc>
80108f9d:	89 98 1c 04 00 00    	mov    %ebx,0x41c(%eax)
    myproc()->queue_head->prev = 0;
80108fa3:	e8 18 b3 ff ff       	call   801042c0 <myproc>
80108fa8:	8b 80 1c 04 00 00    	mov    0x41c(%eax),%eax
80108fae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80108fb5:	eb 8e                	jmp    80108f45 <swapAQ+0x25>
80108fb7:	89 f6                	mov    %esi,%esi
80108fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80108fc0 <updateAQ>:
{
80108fc0:	55                   	push   %ebp
80108fc1:	89 e5                	mov    %esp,%ebp
80108fc3:	57                   	push   %edi
80108fc4:	56                   	push   %esi
80108fc5:	53                   	push   %ebx
80108fc6:	83 ec 1c             	sub    $0x1c,%esp
80108fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(p->queue_tail == 0 || p->queue_head == 0)
80108fcc:	8b 90 1c 04 00 00    	mov    0x41c(%eax),%edx
80108fd2:	85 d2                	test   %edx,%edx
80108fd4:	0f 84 7e 00 00 00    	je     80109058 <updateAQ+0x98>
  struct queue_node *curr_node = p->queue_tail;
80108fda:	8b b0 20 04 00 00    	mov    0x420(%eax),%esi
  if(curr_node->prev == 0)
80108fe0:	8b 56 04             	mov    0x4(%esi),%edx
80108fe3:	85 d2                	test   %edx,%edx
80108fe5:	74 71                	je     80109058 <updateAQ+0x98>
  struct page *ramPages = p->ramPages;
80108fe7:	8d 98 48 02 00 00    	lea    0x248(%eax),%ebx
  prev_page = &ramPages[curr_node->prev->page_index];
80108fed:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108ff1:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
  struct page *ramPages = p->ramPages;
80108ff5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  prev_page = &ramPages[curr_node->prev->page_index];
80108ff8:	01 df                	add    %ebx,%edi
  struct page *curr_page = &ramPages[curr_node->page_index];
80108ffa:	01 d8                	add    %ebx,%eax
80108ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte_curr = walkpgdir(curr_page->pgdir, curr_page->virt_addr, 0)) == 0)
80109000:	8b 50 08             	mov    0x8(%eax),%edx
80109003:	8b 00                	mov    (%eax),%eax
80109005:	31 c9                	xor    %ecx,%ecx
80109007:	e8 04 e5 ff ff       	call   80107510 <walkpgdir>
8010900c:	85 c0                	test   %eax,%eax
8010900e:	89 c3                	mov    %eax,%ebx
80109010:	74 5e                	je     80109070 <updateAQ+0xb0>
    if(*pte_curr & PTE_A) // an accessed page
80109012:	8b 00                	mov    (%eax),%eax
80109014:	8b 56 04             	mov    0x4(%esi),%edx
80109017:	a8 20                	test   $0x20,%al
80109019:	74 23                	je     8010903e <updateAQ+0x7e>
      if(curr_node->prev != 0) // there is a page behind it
8010901b:	85 d2                	test   %edx,%edx
8010901d:	74 17                	je     80109036 <updateAQ+0x76>
        if((pte_prev = walkpgdir(prev_page->pgdir, prev_page->virt_addr, 0)) == 0)
8010901f:	8b 57 08             	mov    0x8(%edi),%edx
80109022:	8b 07                	mov    (%edi),%eax
80109024:	31 c9                	xor    %ecx,%ecx
80109026:	e8 e5 e4 ff ff       	call   80107510 <walkpgdir>
8010902b:	85 c0                	test   %eax,%eax
8010902d:	74 41                	je     80109070 <updateAQ+0xb0>
        if(!(*pte_prev & PTE_A)) // was not accessed, will swap
8010902f:	f6 00 20             	testb  $0x20,(%eax)
80109032:	74 2c                	je     80109060 <updateAQ+0xa0>
80109034:	8b 03                	mov    (%ebx),%eax
      *pte_curr &= ~PTE_A;
80109036:	83 e0 df             	and    $0xffffffdf,%eax
80109039:	89 03                	mov    %eax,(%ebx)
8010903b:	8b 56 04             	mov    0x4(%esi),%edx
      if(curr_node->prev != 0)
8010903e:	85 d2                	test   %edx,%edx
80109040:	74 16                	je     80109058 <updateAQ+0x98>
      curr_page = &ramPages[curr_node->page_index];
80109042:	6b 46 08 1c          	imul   $0x1c,0x8(%esi),%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80109046:	6b 7a 08 1c          	imul   $0x1c,0x8(%edx),%edi
      curr_page = &ramPages[curr_node->page_index];
8010904a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
        prev_page = &ramPages[curr_node->prev->page_index];
8010904d:	89 d6                	mov    %edx,%esi
      curr_page = &ramPages[curr_node->page_index];
8010904f:	01 c8                	add    %ecx,%eax
        prev_page = &ramPages[curr_node->prev->page_index];
80109051:	01 cf                	add    %ecx,%edi
80109053:	eb ab                	jmp    80109000 <updateAQ+0x40>
80109055:	8d 76 00             	lea    0x0(%esi),%esi
}
80109058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010905b:	5b                   	pop    %ebx
8010905c:	5e                   	pop    %esi
8010905d:	5f                   	pop    %edi
8010905e:	5d                   	pop    %ebp
8010905f:	c3                   	ret    
          swapAQ(curr_node);
80109060:	83 ec 0c             	sub    $0xc,%esp
80109063:	56                   	push   %esi
80109064:	e8 b7 fe ff ff       	call   80108f20 <swapAQ>
80109069:	8b 03                	mov    (%ebx),%eax
8010906b:	83 c4 10             	add    $0x10,%esp
8010906e:	eb c6                	jmp    80109036 <updateAQ+0x76>
      panic("updateAQ: no pte");
80109070:	83 ec 0c             	sub    $0xc,%esp
80109073:	68 60 9d 10 80       	push   $0x80109d60
80109078:	e8 13 73 ff ff       	call   80100390 <panic>
